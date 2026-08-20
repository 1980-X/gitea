# Gitea ops locked decisions (gpu001)

> Source: local `.cursor/rules/gitea-ops.mdc` and skill `gitea-ops` (this workspace)
> Collected: 2026-08-18
> Published: 2026-08-18

用途：用 Gitea 管代码（运维托管），官方镜像 gitea/gitea，不是本机源码构建当入口。

工作区：仅 /home/wilber/service/gitea。勿在 ~/project/gitea 做本栈运维。

入口：本项目专用 nginx 容器为唯一宿主机端口映射；gitea / postgres 只 expose，不映射宿主机。

阶段 1 访问：本机 + 局域网。Tailscale 公网域名 / NPM / cpolar 本阶段不做。

部署闸门：用户未明确说「部署 / 启动 / up / 上线」时，禁止 compose up、建容器、拉业务镜像跑栈。

目标栈：gitea-nginx 唯一入口，建议 18600:80（落地前再核占用）；gitea 应用不映射；postgres 库不映射。网络名 gitea_net。数据建议 /mnt/storage/gitea/ bind。

容器名建议：gitea-nginx、gitea、gitea-db。

ROOT_URL 阶段 1 用实际访问 URL（如 http://<局域网IP>:18600/），与反代一致。SSH git 推送阶段 1 默认可不做；优先 HTTPS + token。

硬禁止：宿主机安装或运行 Gitea / go run / make watch / 裸 gitea web。占用他项已用端口；改他项 compose / 容器名 / NPM Proxy Host。复用 soulvoix / h5pl / plantvr / helix 等库或网络。docker system prune、对其它项目 compose down、未确认删数据目录。进容器手改数据库。

AGENTS.md 为运维入口；上游贡献指南在 .cursor/AGENTS.upstream.md。

Shell hook 不拦本目录 compose up（软闸门）。拦：他栈 compose、宿主机跑 Gitea、prune、删 /mnt/storage/gitea、把 gitea/postgres 端口映射到宿主机。
