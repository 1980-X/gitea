# Agent 长期记忆（本仓）

面向本仓库 Cursor / Agent：**可审阅的编译知识库** + **跨会话本地回想**。不依赖其它业务仓；不上 Mem0 云 / Graphiti / Letta。

## 两层分工

| 层         | 组件                                           | 落点                           | 用途                    |
| ---------- | ---------------------------------------------- | ------------------------------ | ----------------------- |
| 编译知识库 | Karpathy LLM wiki（skill `karpathy-llm-wiki`） | `raw/` · `wiki/`               | 运维约定、可沉淀可 lint |
| 跨会话记忆 | agentmemory                                    | `~/.agentmemory` + MCP `:3111` | 偏好 / 决策 / 近期事实  |

查知识：先读 [`wiki/index.md`](../../wiki/index.md)。运维操作：skill `gitea-ops`。

`wiki/` 与 `raw/` 在本仓用 `.git/info/exclude` 排除，不进 Gitea 上游 Git。

## agentmemory（本机 gpu001）

用户级 MCP 已在 `~/.cursor/mcp.json`；本项目 `.cursor/mcp.json` 再声明一次以便本窗口加载。

- REST `127.0.0.1:3111` · viewer `:3113`
- 健康：`curl -fsS http://127.0.0.1:3111/agentmemory/livez`
- **不要**把 agentmemory 并进 Gitea compose；勿写入 `.env` 密码。

Skills：`remember` / `recall` / `handoff` / `recap` 等（用户级 `~/.cursor/skills` 已有则不必再复制）。

## Wiki 常用话术

- 「ingest 这篇 / 这个文件进 wiki」
- 「wiki 里关于 ROOT_URL / nginx 知道什么」
- 「lint wiki」

真源仍以 compose、`.env.example`、实际容器状态为准；wiki 是编译导航层。
