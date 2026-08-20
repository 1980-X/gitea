# Gitea hosting stack (gpu001)

> Sources: local rules/skill, 2026-08-18–19
> Raw: [locked decisions](../../raw/gitea-ops/2026-08-18-locked-decisions.md); [compose overlay](../../raw/gitea-ops/2026-08-19-compose-overlay.md); [SSH 18622](../../raw/gitea-ops/2026-08-19-ssh-18622.md)
> Updated: 2026-08-19

## Overview

gpu001 上的 Gitea 是 **代码托管**（站点名 joy-x）。官方镜像 `docker.gitea.com/gitea:1.27.2`，HTTP 经 nginx，Git SSH 直连 gitea 容器。栈 **已部署并完成安装**（`INSTALL_LOCK=true`）。

## Layout

工作区 `/home/wilber/service/gitea`。HTTP：`http://192.168.1.84:18600/`。Git SSH：`git@192.168.1.84:18622:owner/repo.git`。

| 路径        | 宿主机口 | 说明                  |
| ----------- | -------- | --------------------- |
| gitea-nginx | 18600→80 | Web / HTTP git        |
| gitea       | 18622→22 | Git SSH（不经 nginx） |
| gitea-db    | 不映射   | 仅 gitea_net 内 5432  |

数据：`/mnt/storage/gitea/gitea`、`/mnt/storage/gitea/postgres`。宿主机 `:22` 为系统 sshd；`:3000` 被其它服务占用，gitea 应用口不映射。

## Gates

部署变更仍须用户明确授权。Shell hook 不拦本目录 compose up。禁止映射 gitea 3000 / postgres 5432、禁止占宿主机 22、禁止 docker system prune。

## See Also

- [Agent memory system](../agent-memory/agent-memory-system.md)
