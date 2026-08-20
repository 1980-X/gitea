# Gitea ops 参考（无密钥）

## 环境变量名

写在 `.env` / `.env.example`，compose 用 `${VAR}` 引用。**不要**把真实密码写入本文件或 Git。

| 变量                                                  | 用途                                                     |
| ----------------------------------------------------- | -------------------------------------------------------- |
| `GITEA_HTTP_PORT`                                     | 宿主机 HTTP 入口，默认 `18600`（nginx）                  |
| `GITEA_SSH_PORT`                                      | 宿主机 Git SSH 映射，默认 `18622` → 容器 `22`            |
| `POSTGRES_USER` / `POSTGRES_PASSWORD` / `POSTGRES_DB` | 库账号；compose 把 `PASSWD` 指到同一 `POSTGRES_PASSWORD` |
| `GITEA__database__DB_TYPE`                            | 固定 `postgres`                                          |
| `GITEA__database__HOST`                               | `gitea-db:5432`                                          |
| `GITEA__server__DOMAIN`                               | 阶段 1：`192.168.1.84`                                   |
| `GITEA__server__ROOT_URL`                             | `http://192.168.1.84:18600/`                             |
| `GITEA__server__HTTP_PORT`                            | 容器内 `3000`                                            |
| `GITEA__server__DISABLE_SSH`                          | `false`                                                  |
| `GITEA__server__SSH_PORT`                             | 对外 SSH 口 `18622`（clone URL 用）                      |
| `USER_UID` / `USER_GID`                               | `1000`（`wilber`）                                       |

镜像走本机 registry mirror，不必在 compose 里写死加速器地址。

## nginx 要点

- `proxy_pass http://gitea:3000;`
- Web UI、git HTTP、`/api` 同一 upstream。
- 对 websocket（通知等）设 `Upgrade` / `Connection`。
- 客户端真实 IP：`X-Forwarded-For` / `X-Real-IP` / `X-Forwarded-Proto`。
- 大仓库推送：适当加大 `client_max_body_size`。

## 数据目录

```text
/mnt/storage/gitea/
  gitea/     # 应用 data → 容器 /data
  postgres/  # PG data → /var/lib/postgresql/data
```

属主 `1000:1000`；未确认禁止 `rm -rf`。

## Git SSH（客户端）

Gitea Web → 设置 → SSH / GPG 密钥 → 添加本机公钥。

`~/.ssh/config` 示例：

```sshconfig
Host joy-x
  HostName 192.168.1.84
  User git
  Port 18622
  IdentityFile ~/.ssh/id_ed25519
```

Clone：`git clone git@joy-x:用户名/仓库.git`

开发者自助配置：GitHub https://github.com/1980-X/gitea 分支 `developer-docs`；joy-x `wilber/gitea` 同分支。`main` 上见 `.cursor/docs/开发者-Cursor配置指南.md`（入口提示）。
