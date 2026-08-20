# Agent memory system (this repo)

> Sources: local overlay notes, 2026-08-18
> Raw: [wiring](../../raw/agent-memory/2026-08-18-agent-memory-wiring.md)
> Updated: 2026-08-18

## Overview

本仓 Agent 记忆分两层，互不替代：Karpathy wiki（`raw/` + `wiki/`）沉淀运维约定；agentmemory（MCP `:3111`）做跨会话回想。不上 Mem0 云 / Graphiti / Letta，不以其它业务仓 wiki 当真源。

## Wiki

Skill：`.cursor/skills/karpathy-llm-wiki/`。入口：`wiki/index.md`。`wiki/` 与 `raw/` 经 `.git/info/exclude` 排除，不进 Gitea 上游 Git。真源仍是 compose、`.env.example`、实际容器状态。

## agentmemory

本机 REST `127.0.0.1:3111`、viewer `:3113`。用户级 `~/.cursor/mcp.json` 已有；本项目 `.cursor/mcp.json` 再声明以便本窗口加载。不要把 agentmemory 并进 Gitea compose；勿把 `.env` 密码写入 memory 或 wiki。健康检查：`curl -fsS http://127.0.0.1:3111/agentmemory/livez`。

## See Also

- [Gitea hosting stack](../gitea-ops/hosting-stack.md)
