---
name: gitea-ops
description: >-
  Operate the gpu001 Gitea hosting stack under ~/service/gitea with a
  dedicated nginx entry, official gitea/gitea image, and isolated postgres.
  Use when the user mentions Gitea deploy, compose, gitea-nginx, git hosting,
  ROOT_URL, or this service directory.
---

# Gitea 运维（本机托管）

## 工作区

```bash
cd /home/wilber/service/gitea
```

仅在此目录操作本栈。Cursor 打开本目录，而非 `~/project/gitea`。根目录 `AGENTS.md` 为运维入口；上游贡献指南在 `.cursor/AGENTS.upstream.md`。

## 产品定位

- **管代码**：官方镜像 + compose；不是贡献上游时的源码热编译入口。
- **HTTP 入口**：`gitea-nginx` → `:18600`；**Git SSH** 直连 `gitea` → `:18622`（不经 nginx）。

## 阶段

| 阶段          | 范围                                  | Agent                          |
| ------------- | ------------------------------------- | ------------------------------ |
| **1（当前）** | 本机 + 局域网经专用 nginx 端口        | 可规划；**部署须用户明确下令** |
| 后置          | Tailscale 专项、公网域名、NPM、cpolar | 用户未提及时不做               |

## 部署闸门

未出现明确部署意图时：

- 可讨论方案、改 skills/rules/wiki、写尚未执行的草稿说明。
- **不要** `docker compose up`、`build` 起栈、创建并启动容器。

用户明确说「部署 / 启动 / 可以 up」后再 `docker compose up -d`。栈已运行；Git SSH 已开 `:18622`。

Shell hook **不**拦本目录 `compose up`（软闸门，靠本 skill 与规则）。拦的是：他栈 compose、宿主机跑 Gitea、prune、删数据盘、把应用/库端口映射到宿主机。

## 目标拓扑（阶段 1）

```text
浏览器 (本机/局域网)
    → 宿主机 :18600 → gitea-nginx:80 → gitea:3000

Git (SSH)
    → 宿主机 :18622 → gitea:22

gitea:3000 → gitea-db:5432
网络: gitea_net
```

- 容器名：`gitea-nginx`、`gitea`、`gitea-db`。
- `ROOT_URL`：`http://192.168.1.84:18600/`。
- Git SSH：`git@192.168.1.84:18622:owner/repo.git`；`~/.ssh/config` 别名见 [reference.md](reference.md)。

## 已落文件

| 路径                                  | 作用                                           |
| ------------------------------------- | ---------------------------------------------- |
| `docker-compose.yml`                  | nginx `:18600` + gitea SSH `:18622` + postgres |
| `nginx/gitea.conf`                    | 反代到 `gitea:3000`（git HTTP / websocket）    |
| `.env.example`                        | 变量名清单（无密钥）                           |
| `.env`                                | 本地密钥；不提交                               |
| `/mnt/storage/gitea/{gitea,postgres}` | bind 数据目录                                  |

变量名与 nginx 要点见 [reference.md](reference.md)。

## 数据与密钥

- 持久化：`/mnt/storage/gitea/...` bind，禁止只写容器可写层。
- `.env` 本地保管；禁止写入 Skill、规则、wiki、Git。

## 禁止

- 宿主机跑 Gitea 进程；映射 gitea **3000** 或 postgres **5432** 到宿主机（SSH `:18622` 除外）。
- 改 NPM 或其他项目的 proxy/端口/容器；`docker system prune`；未确认删 `/mnt/storage/gitea`。
- 进容器手改数据库。

## 记忆

领域约定先读 `wiki/index.md`。跨会话决策用 agentmemory（`:3111`）。说明：`.cursor/docs/agent-memory.md`。

## 授权部署后的检查清单

1. `ss` / `docker ps` 确认入口端口空闲且不冲突。
2. 仅本目录 `docker compose up -d`。
3. 本机与一台局域网设备打开 `http://<IP>:<入口端口>/`。
4. 健康：nginx → gitea → db；不声称「公网/Tailscale 已就绪」。
