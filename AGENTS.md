# Gitea 运维工作区（gpu001）

本目录是 **joy-x Gitea 托管栈**（官方镜像 + compose），不是上游 Gitea 源码开发仓。

- 只在 `/home/wilber/service/gitea` 操作本栈。
- 官方镜像 + 专用 `gitea-nginx`（HTTP `:18600`）；Git SSH `:18622`；库不映射宿主机口。
- 阶段 1：本机 + 局域网。未提及时不做 Tailscale / 公网域名 / NPM / cpolar。
- 用户未明确说「部署 / 启动 / up / 上线」时：禁止 `compose up`、建容器、拉业务镜像跑栈。
- 禁止宿主机 `gitea web` / `go run` / `make watch`；禁止改他项 compose / 端口 / NPM；禁止 `docker system prune`；未确认不删 `/mnt/storage/gitea`。
- 启停、端口、nginx、ROOT_URL：读 skill `gitea-ops`。领域知识先查 `wiki/index.md`；跨会话回想用 agentmemory（`:3111`）。
- 开发者指南分支：`developer-docs`（GitHub `1980-X/gitea`）。
- 密钥只在本目录 `.env`，不写入 Skill / 规则 / wiki / Git。
