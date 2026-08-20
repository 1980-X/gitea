# joy-x Gitea 运维仓（gpu001）

本仓库是 **Gitea 托管栈配置**（官方镜像 + compose），**不是** Gitea 上游源码。

| 分支 | 用途 |
| ---- | ---- |
| `main` | 运维：compose、nginx、Agent skills/rules、wiki |
| `developer-docs` | 开发者起步指南（仅文档） |

开发者请拉：

```bash
git clone -b developer-docs https://github.com/1980-X/gitea.git
# 打开 docs/开发者-Cursor配置指南.md
```

## 阶段 1 入口

| 用途 | 地址 |
| ---- | ---- |
| Web | http://192.168.1.84:18600/ |
| Git SSH | `192.168.1.84:18622`（用户 `git`） |
| ROOT_URL | `http://192.168.1.84:18600/` |

数据：`/mnt/storage/gitea/{gitea,postgres}`。密钥在本机 `.env`（不入库）。

## 本机操作

```bash
cd /home/wilber/service/gitea
cp .env.example .env   # 首次：填密码与 ROOT_URL
docker compose up -d   # 须用户明确授权后再执行
```

禁止：宿主机跑 `gitea web`、映射应用口 3000、改他项 compose、未确认删数据盘。详见 `.cursor/skills/gitea-ops/`。
