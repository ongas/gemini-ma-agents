# Gemini-MA Agent Definitions

A collection of reusable agent definitions for [gemini-ma](https://github.com/ongas/gemini-ma) - a fork of Google's Gemini CLI with enhanced multi-agent capabilities.

## 📁 Project Structure

```
gemini-ma-agents/
├── agents/              # Agent definitions
│   ├── ollama-coder.md            # Ollama coding agent (full tools)
│   ├── llamacpp-coder.md          # llama.cpp main agent (simplified)
│   ├── llamacpp-expanded-tools.md # llama.cpp with expanded toolset
│   ├── llamacpp-multi-tools.md    # llama.cpp with Read/Glob/Grep
│   ├── llamacpp-read-only.md      # llama.cpp read-only mode
│   └── llamacpp-readwrite.md      # llama.cpp read/write mode
├── examples/            # Example agent definitions for learning
├── scripts/             # Installation and management scripts
│   ├── install.sh       # Copy agents to a project
│   └── update.sh        # Update agents in a project
└── README.md
```

## 🚀 Quick Start

### Option 1: Copy Specific Agents

```bash
# Copy a specific agent to your project
cp agents/ollama-coder.md /path/to/your/project/.gemini/agents/

# Verify it's available
cd /path/to/your/project
gemini-ma --list-agents
```

### Option 2: Use Installation Script

```bash
# Install all agents to a project
./scripts/install.sh /path/to/your/project

# Install specific agents
./scripts/install.sh /path/to/your/project ollama-coder
```

### Option 3: Symlink for Live Updates

```bash
# Create symlinks (changes here automatically reflect in project)
cd /path/to/your/project/.gemini
ln -s /mnt/e/source/personal_repos/gemini-ma-agents/agents agents
```

## 📦 Available Agents

### `ollama-coder` - Ollama Coding Agent

Uses Ollama's qwen2.5-coder:7b for fast, offline code generation with full tool support.

**Use cases:**
- Code generation and refactoring
- File operations with full tool access
- Quick edits and debugging
- Avoiding API quota limits
- Complex multi-step workflows

**Requirements:**
- Ollama installed and running
- Model pulled: `ollama pull qwen2.5-coder:7b`

**Usage:**
```bash
gemini-ma --agent ollama_coder
```

### `llamacpp-coder` - llama.cpp/vLLM Coding Agent

Fast offline coding agent using llama.cpp via vLLM serving Qwen2.5-Coder-7B-Instruct.

**Current Status - Simplified Mode:**
Due to limitations with 7B parameter models, this agent operates without tool calling or conversation history. Best for simple Q&A and code generation.

**Use cases:**
- Fast code explanations
- Algorithm discussions
- Code generation from descriptions
- Syntax help and programming Q&A
- Offline development for lightweight queries

**Requirements:**
- vLLM serving llama.cpp model on port 8000
- Environment: `export LLAMACPP_BASE_URL=http://localhost:8000`
- Hardware: Minimum 8GB RAM + 8GB VRAM

**Usage:**
```bash
# Start vLLM server first
export HF_HOME="/path/to/models"
python -m vllm.entrypoints.openai.api_server \
  --model Qwen/Qwen2.5-Coder-7B-Instruct \
  --host 0.0.0.0 --port 8000

# Use the agent
gemini-ma --agent llamacpp_coder
```

**Note:** For full tool support and complex workflows, use the `ollama-coder` agent instead.

### Alternative llama.cpp Agents

Additional llama.cpp agents with different tool configurations:

#### `llamacpp-expanded-tools`
llama.cpp with expanded file operations and code exploration toolset.
- **Tools**: `read_file`, `write_file`, `list_directory`, `glob`, `search_file_content`
- **Use**: File operations with llama.cpp
- **Agent name**: `llamacpp_expanded_tools`

#### `llamacpp-multi-tools`
llama.cpp with multiple file exploration tools.
- **Tools**: `Read`, `Glob`, `Grep`
- **Use**: Multi-tool file exploration
- **Agent name**: `llamacpp_multi_tools`

#### `llamacpp-read-only`
llama.cpp with read-only file access.
- **Tools**: `Read` only
- **Use**: Safe read-only operations
- **Agent name**: `llamacpp_read_only`

#### `llamacpp-readwrite`
llama.cpp with basic file read and write capabilities.
- **Tools**: `read_file`, `write_file`
- **Use**: Basic file manipulation
- **Agent name**: `llamacpp_readwrite`

**Usage:**
```bash
# Use any alternative agent
gemini-ma --agent llamacpp_expanded_tools
gemini-ma --agent llamacpp_multi_tools
gemini-ma --agent llamacpp_read_only
gemini-ma --agent llamacpp_readwrite
```

**Note:** These agents offer different tool configurations for specific use cases. For general use, `ollama-coder` (full features) or `llamacpp-coder` (Q&A) are recommended.

## 🔄 Workflow

### Creating a New Agent

1. Create agent file in `agents/` directory:
```bash
touch agents/my-agent.md
```

2. Define the agent (see [Agent Definition Format](#-agent-definition-format))

3. Commit and push:
```bash
git add agents/my-agent.md
git commit -m "Add my-agent definition"
git push
```

### Using Agents in Projects

**One-time copy (recommended for production):**
```bash
cp agents/my-agent.md /path/to/project/.gemini/agents/
```

**Symlink for development:**
```bash
cd /path/to/project/.gemini
ln -s /path/to/gemini-ma-agents/agents/my-agent.md agents/
```

### Updating Agents

**If using copies:**
```bash
# Update the agent definition here
vim agents/my-agent.md

# Copy to all projects using it
./scripts/update.sh agents/my-agent.md /path/to/project1 /path/to/project2
```

**If using symlinks:**
- Just edit the agent here - changes reflect automatically

## 📝 Agent Definition Format

Agent definitions use YAML front matter + markdown:

```markdown
---
Provider: ollama
Model: qwen2.5-coder:7b
Temperature: 0.3
Tools: all
---

# Agent Name

Brief description of what this agent does.

## Capabilities

- Capability 1
- Capability 2

## Instructions

Your detailed instructions for the agent's behavior...
```

### Metadata Fields

- **Provider**: `gemini` | `ollama` | `openai`
- **Model**: Model identifier (e.g., `gemini-2.0-flash-exp`, `qwen2.5-coder:7b`)
- **Temperature**: 0.0-1.0 (lower = more deterministic)
- **Tools**: `all` | `none` | comma-separated list

## 🛠️ Scripts

### `install.sh`

Copy agents to a project's `.gemini/agents/` directory.

```bash
# Install all agents
./scripts/install.sh /path/to/project

# Install specific agents
./scripts/install.sh /path/to/project local-coder my-agent
```

### `update.sh`

Update agent definitions in multiple projects.

```bash
# Update a specific agent in multiple projects
./scripts/update.sh agents/local-coder.md /path/to/project1 /path/to/project2
```

## 🎯 Best Practices

1. **Version Control**: Always commit agent changes with descriptive messages
2. **Testing**: Test agents in a sample project before deploying widely
3. **Documentation**: Include clear capabilities and use cases in each agent
4. **Naming**: Use lowercase with hyphens (e.g., `local-coder.md`)
5. **Production**: Copy agents to projects (don't symlink in production)
6. **Development**: Symlink during development for rapid iteration

## 🔗 Related Links

- [Gemini-MA (Fork)](https://github.com/ongas/gemini-ma)
- [Original Gemini CLI](https://github.com/google/gemini-cli)
- [Ollama Models](https://ollama.com/library)

## 📄 License

[Your License Here]
