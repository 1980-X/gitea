# Gitea 部署（gpu001）

本仓库 **仅含部署配置**（compose、nginx）。运维知识、开发者配置见 **[ops-hub](https://github.com/1980-X/ops-hub)**。

| 用途 | 地址 |
|---|---|
| Web | http://192.168.1.84:18600/ |
| Git SSH | `git@192.168.1.84:18622` |

数据：`/mnt/storage/gitea/{gitea,postgres}`。密钥在 `.env`（不入库）。

```bash
cp .env.example .env
docker compose up -d    # 须显式授权后再执行
bash ~/ops-hub/scripts/gitea/status.sh
```
