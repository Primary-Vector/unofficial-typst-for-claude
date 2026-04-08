# unofficial-typst Plugin Design

## Overview

A Claude Code plugin that bundles Typst binaries for multiple platforms, enabling PDF generation from Typst markup in any Claude environment — including locked-down Workbench VMs where Typst cannot be installed.

## Problem

Claude Code Workbench runs a locked-down Linux VM that cannot install arbitrary software. Users who want to generate PDFs using Typst have no way to do so. Even in local Claude Code, requiring users to install Typst adds friction.

## Solution

A self-contained Claude Code plugin that:
1. Ships pre-built Typst binaries for macOS and Linux (ARM + x86_64)
2. Provides a platform-detection wrapper script in `bin/` (auto-added to PATH by Claude Code)
3. Includes an agent skill with Typst language reference for high-quality `.typ` generation
4. Offers a `/unofficial-typst:compile` slash command for prompt-to-PDF workflow

## Target Platforms (v0.1.0)

| Target Triple | OS | Arch | Use Case |
|---|---|---|---|
| `aarch64-apple-darwin` | macOS | ARM (Apple Silicon) | Local Claude Code |
| `x86_64-apple-darwin` | macOS | Intel | Local Claude Code |
| `aarch64-unknown-linux-musl` | Linux | ARM | Workbench / servers |
| `x86_64-unknown-linux-musl` | Linux | x86_64 | Workbench / servers |

Windows and exotic Linux targets (armv7, riscv64) are deferred to future versions.

## Directory Structure

```
unofficial-typst/
├── .claude-plugin/
│   └── plugin.json                        # Plugin manifest
├── bin/
│   ├── typst                              # Wrapper script (platform detection)
│   ├── typst-aarch64-apple-darwin         # macOS ARM binary
│   ├── typst-x86_64-apple-darwin          # macOS Intel binary
│   ├── typst-aarch64-unknown-linux-musl   # Linux ARM binary
│   └── typst-x86_64-unknown-linux-musl    # Linux x86_64 binary
├── skills/
│   └── typst/
│       └── SKILL.md                       # Typst language reference
├── commands/
│   └── compile.md                         # /unofficial-typst:compile command
├── scripts/
│   └── download-binaries.sh               # Fetch/update Typst binaries
├── .gitattributes                         # Mark bin/* as binary
└── README.md                              # Installation & usage docs
```

## Component Details

### 1. Plugin Manifest (`.claude-plugin/plugin.json`)

```json
{
  "name": "unofficial-typst",
  "description": "Typst typesetting system with bundled binaries — generate PDFs from markup in any Claude environment",
  "version": "0.1.0",
  "author": {
    "name": "Jon"
  },
  "license": "MIT",
  "keywords": ["typst", "pdf", "typesetting", "documents"]
}
```

### 2. Platform Detection Wrapper (`bin/typst`)

A POSIX shell script that:
- Detects OS via `uname -s` (Darwin → apple-darwin, Linux → unknown-linux-musl)
- Detects architecture via `uname -m` (arm64/aarch64 → aarch64, x86_64 → x86_64)
- Constructs the target triple
- Execs the matching binary from the same directory
- Exits with a clear error if no matching binary is found

Key design decisions:
- Uses `exec` to replace the wrapper process (no extra PID, correct signal handling)
- Uses `$(dirname "$0")` to locate sibling binaries (works regardless of PATH resolution)
- POSIX sh for maximum portability (no bash dependency)

### 3. Typst Skill (`skills/typst/SKILL.md`)

An agent skill that Claude auto-activates when working with Typst or generating documents.

**Trigger description**: "Use when creating, editing, or compiling Typst (.typ) documents, or when the user asks to generate PDFs from markup."

**Content covers**:
- Document structure: `#set`, `#show`, `#let`, content blocks
- Text formatting: `*bold*`, `_italic_`, `` `code` ``, `@references`
- Page setup: `#set page(paper: "us-letter", margin: ...)`, `#set text(font: ..., size: ...)`
- Headings: `= H1`, `== H2`, etc.
- Lists: `- unordered`, `+ ordered`, `/ term: description`
- Tables: `#table(columns: ..., ...)`
- Figures and images: `#figure(image("path"), caption: [...])`
- Math mode: `$ inline $` and `$ display $` (with space)
- Functions and show rules
- Common document patterns: letters, reports, resumes, invoices
- Key differences from LaTeX to prevent incorrect syntax
- Compilation command: `typst compile input.typ output.pdf`

The skill acts as a reference card — concise syntax examples, not a tutorial.

### 4. Compile Command (`commands/compile.md`)

**Usage**: `/unofficial-typst:compile <natural language description or .typ file path>`

**Workflow**:
1. Parse `$ARGUMENTS`:
   - If it ends in `.typ`, treat as a file path → compile that file directly
   - Otherwise, treat as a natural language prompt → generate a `.typ` file first
2. For prompt-to-PDF:
   - Interpret the user's request
   - Write a `.typ` file (filename derived from content, e.g., `resume.typ`)
   - Use the Typst skill knowledge for correct syntax
3. Compile: run `typst compile <file>.typ`
4. Error handling: if compilation fails, read Typst's error output (which includes line numbers), fix the `.typ` source, retry (up to 3 attempts)
5. Report: output the PDF path and a summary of what was created

### 5. Binary Download Script (`scripts/download-binaries.sh`)

A bash script that:
- Accepts an optional version argument (defaults to latest)
- Downloads the 4 target archives from GitHub releases
- Extracts each binary
- Places them in `bin/` with correct names
- Sets executable permissions
- Cleans up temporary files

Used for initial setup and for updating to new Typst releases.

## Binary Management

- Binaries are committed directly to the git repo
- `.gitattributes` marks `bin/typst-*` as binary files
- Total repo size: ~100MB (4 binaries, ~25MB each uncompressed)
- The `scripts/download-binaries.sh` script handles updates
- Typst version is tracked in the plugin version (plugin 0.1.0 ships Typst 0.14.2)

## What's Intentionally Excluded

- **No hooks**: Nothing needs to run on Claude Code events
- **No MCP servers**: Typst is a CLI tool, no persistent server needed
- **No agents**: The skill + command fully cover the use case
- **No LSP**: Would require the Typst language server to be installed separately; could be added later
- **No Windows binaries**: Deferred to future version
- **No Typst package management**: Typst's package system pulls from the internet; may not work in all environments. Deferred.

## Future Considerations

- Windows binary support
- Typst LSP integration for code intelligence
- Font bundling for environments without system fonts
- Typst package/template bundling for offline use
- Submission to the official Claude Code plugin marketplace
