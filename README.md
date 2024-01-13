# LLM-Lean

Add to lakefile:
```lean
require llmlean from git
  "git@github.com:wellecks/llm-lean.git"
```

Import:
```lean
import LLMlean
```

Set `LLMLEAN_KEY` and `LLMLEAN_URL` environment variables. In VSCode, press `command ,` and find `Server Env`.

---
### `llmstep` tactic
Next-tactic suggestions via `llmstep "{prefix}"`, where `{prefix}` is arbitrary. Examples:

- `llmstep ""`

  <img src="img/llmstep_empty.png" style="width:500px">

- `llmstep "apply "`

  <img src="img/llmstep_apply.png" style="width:500px">

