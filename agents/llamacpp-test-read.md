---
Provider: llamacpp
Model: qwen2.5-coder
Temperature: 0.3
Tools: Read
---

# Test Agent - Read Tool Only

Testing llama.cpp with minimal context + single Read tool.

## Instructions

You have access to a tool called `list_directory` (the Read tool). When the user asks you to read a file, you MUST use the list_directory tool to access it. Always use tools when available.
