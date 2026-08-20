# Agent memory wiring (this repo)

> Source: local `.cursor/docs/agent-memory.md` and Helix-style two-layer memory (wiki + agentmemory on gpu001)
> Collected: 2026-08-18
> Published: 2026-08-18

面向本仓库 Cursor / Agent：可审阅的编译知识库 + 跨会话本地回想。不依赖其它业务仓；不上 Mem0 云 / Graphiti / Letta。

编译知识库：Karpathy LLM wiki（skill karpathy-llm-wiki），落点 raw/ 与 wiki/。

跨会话记忆：agentmemory，~/.agentmemory + MCP :3111。

wiki/ 与 raw/ 在本仓用 .git/info/exclude 排除，不进 Gitea 上游 Git。

用户级 MCP 已在 ~/.cursor/mcp.json；本项目 .cursor/mcp.json 再声明一次以便本窗口加载。

REST 127.0.0.1:3111 · viewer :3113。健康：curl -fsS http://127.0.0.1:3111/agentmemory/livez。

不要把 agentmemory 并进 Gitea compose；勿写入 .env 密码。

Skills：remember / recall / handoff / recap 等（用户级 ~/.cursor/skills 已有则不必再复制）。
