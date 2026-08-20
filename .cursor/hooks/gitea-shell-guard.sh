#!/usr/bin/env bash
# beforeShellExecution：拦宿主机跑 Gitea、误伤他栈、删数据盘、把应用/库端口映射到宿主机。
# 本目录 compose up/start 不在此硬拦（软闸门：靠 rules + 用户明确授权）。
set -euo pipefail

input="$(cat || true)"

deny() {
  local msg="$1"
  printf '{"permission":"deny","user_message":%s}\n' "$(python3 -c 'import json,sys; print(json.dumps(sys.argv[1]))' "$msg")"
  exit 0
}

allow() {
  printf '{"permission":"allow"}\n'
  exit 0
}

cmd="$(
  printf '%s' "$input" | python3 -c '
import json,sys
raw=sys.stdin.read() or "{}"
try:
  d=json.loads(raw)
except Exception:
  print(""); sys.exit(0)
for k in ("command","command_line","cmd"):
  if isinstance(d.get(k), str):
    print(d[k]); sys.exit(0)
ti=d.get("tool_input") or d.get("input") or {}
if isinstance(ti, dict):
  for k in ("command","command_line","cmd"):
    if isinstance(ti.get(k), str):
      print(ti[k]); sys.exit(0)
print("")
' 2>/dev/null || true
)"

[[ -z "$cmd" ]] && allow

if echo "$cmd" | grep -Eqi 'docker[[:space:]]+system[[:space:]]+prune'; then
  deny "拒绝 docker system prune（会波及其它业务容器）。"
fi

if echo "$cmd" | grep -Eqi 'rm[[:space:]]+-[a-zA-Z]*r[a-zA-Z]*f[[:space:]]+.*/mnt/storage/gitea|rm[[:space:]]+-[a-zA-Z]*f[a-zA-Z]*r[[:space:]]+.*/mnt/storage/gitea'; then
  deny "拒绝删除 /mnt/storage/gitea。须用户在自己的终端明确确认后再做。"
fi

# 宿主机当服务跑 Gitea
if echo "$cmd" | grep -Eqi '(^|[;&|][[:space:]]*)(gitea[[:space:]]+web|go[[:space:]]+run[[:space:]]+.*gitea|make[[:space:]]+watch)'; then
  deny "拒绝在宿主机以进程方式启动 Gitea。须用 ~/service/gitea 容器栈（且需用户明确授权部署）。"
fi

# 把 gitea/postgres 端口直接映射到宿主机
if echo "$cmd" | grep -Eqi 'docker[[:space:]]+run' \
  && echo "$cmd" | grep -Eqi '(gitea/gitea|postgres)' \
  && echo "$cmd" | grep -Eqe '(^|[[:space:]])-p[[:space:]]|[[:space:]]--publish([=[:space:]]|$)'; then
  deny "拒绝把 gitea/postgres 端口映射到宿主机。须走本项目 gitea-nginx 唯一入口。"
fi

# 他项 compose（即使命令里碰巧出现 gitea 字样）
if echo "$cmd" | grep -Eqi 'service/(nginx-proxy-manager|perforce|soulvoix|h5pl|plantvr|helix|openclaw|dify|ac922)'; then
  if echo "$cmd" | grep -Eqi 'docker[[:space:]]+compose|docker[[:space:]]+start|docker[[:space:]]+stop|docker[[:space:]]+rm'; then
    deny "拒绝操作其它业务目录的 Docker。Gitea 栈仅允许在 ~/service/gitea。"
  fi
fi

# 未在本项目上下文时，拒绝对其它目录 compose down
if echo "$cmd" | grep -Eqi 'docker[[:space:]]+compose[[:space:]]+.*\bdown\b'; then
  if ! echo "$cmd" | grep -Eqi 'service/gitea|/home/wilber/service/gitea|gitea_net|gitea-nginx'; then
    deny "拒绝在非 Gitea 运维上下文执行 compose down。请限定 ~/service/gitea。"
  fi
fi

# 起栈：无本目录或 gitea 上下文则拒绝；有上下文仍靠规则（须用户授权）
if echo "$cmd" | grep -Eqi 'docker[[:space:]]+compose[[:space:]]+([a-z-]+[[:space:]]+)*\b(up|start)\b|docker[[:space:]]+compose[[:space:]]+.*\brun\b'; then
  if ! echo "$cmd" | grep -Eqi 'service/gitea|/home/wilber/service/gitea|gitea_net|gitea-nginx|container_name:[[:space:]]*gitea'; then
    deny "拒绝在非 ~/service/gitea 上下文启动 compose。Gitea 栈仅允许在本项目目录操作。"
  fi
fi

if echo "$cmd" | grep -Eqi 'nginx-proxy-manager/(data|letsencrypt)|service/nginx-proxy-manager.*\b(up|down|restart)\b'; then
  deny "拒绝修改或重启 Nginx Proxy Manager。Gitea 阶段 1 不用 NPM；反代由其专用 nginx 容器负责。"
fi

allow
