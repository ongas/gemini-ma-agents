---
Provider: gemini
Model: gemini-2.0-flash-exp
Temperature: 0.7
Tools: all
---

# Example Agent Template

This is a template for creating new agent definitions. Copy this file and customize it for your needs.

## Agent Purpose

[Brief description of what this agent does and when to use it]

## Capabilities

- Capability 1
- Capability 2
- Capability 3

## Use Cases

- Use case 1
- Use case 2
- Use case 3

## Requirements

- Requirement 1 (e.g., specific tools, APIs, models)
- Requirement 2

## Instructions

[Detailed instructions for the agent's behavior]

### Core Principles

1. Principle 1
2. Principle 2
3. Principle 3

### Response Style

[How the agent should format and present responses]

### Constraints

- Constraint 1
- Constraint 2

### Example Interactions

**User**: [Example question]

**Agent**: [Example response demonstrating the agent's style and capabilities]

---

## Metadata Field Reference

### Provider
- `gemini` - Google's Gemini models (requires API key or OAuth)
- `ollama` - Local Ollama models (requires Ollama running)
- `openai` - OpenAI models (requires API key)

### Model
Common models:
- Gemini: `gemini-2.0-flash-exp`, `gemini-1.5-pro`, `gemini-1.5-flash`
- Ollama: `qwen2.5-coder:7b`, `llama3.1:8b`, `deepseek-coder-v2:16b`
- OpenAI: `gpt-4`, `gpt-3.5-turbo`

### Temperature
- `0.0` - Deterministic, focused (good for code, analysis)
- `0.3-0.5` - Balanced (good for most tasks)
- `0.7-0.9` - Creative, varied (good for brainstorming, writing)
- `1.0+` - Very creative, unpredictable

### Tools
- `all` - Access to all available tools
- `none` - No tool access (conversation only)
- `read,write,edit` - Specific comma-separated tools
