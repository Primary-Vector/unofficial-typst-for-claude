# unofficial-typst-for-claude

A [Claude Code](https://docs.anthropic.com/en/docs/claude-code) plugin that bundles [Typst](https://typst.app) binaries so Claude can generate PDFs without any external setup.

> **This is an unofficial community plugin.** It is not affiliated with or endorsed by the Typst project. Typst is created and maintained by [typst/typst](https://github.com/typst/typst) and licensed under the Apache License 2.0. All credit for the Typst typesetting system belongs to its authors and contributors.

## Why

[Typst](https://typst.app) is a markup language that compiles to PDF, SVG, and PNG. Its syntax is clean enough that LLMs can write it pretty well which makes it nice for generating resumes, invoices, or other structured documents from Claude.

The catch is, if you're running Claude CoWork... it runs things in a locked-down Linux VM where you can't install packages.

This plugin ships pre-built Typst binaries for macOS and Linux, so `typst` is on PATH the moment you install it. It also includes a Typst language skill (so Claude writes well-formed `.typ` syntax instead and a `/compile` command that goes from a natural language prompt to a finished PDF.

## What's included

- **Typst binaries** for macOS (Apple Silicon, Intel) and Linux (ARM64, x86_64), selected automatically at runtime
- **`typst` skill** — language reference so Claude writes well-formed `.typ` syntax instead of guessing
- **`typst-packages` skill** — tells Claude to search the [Typst package registry](https://packages.typst.org) for community packages before building complex documents (Gantt charts, timelines, diagrams, etc.) from scratch
- **`/compile` command** — goes from a natural language prompt to a finished PDF, SVG, or PNG

## Installation

Add the marketplace and install:

```
/plugin marketplace add Primary-Vector/unofficial-typst-for-claude
/plugin install unofficial-typst@unofficial-typst-for-claude
```

Or load directly during development:

```bash
claude --plugin-dir ./unofficial-typst-for-claude
```

## Usage

### Generate a PDF from a prompt

```
/unofficial-typst:compile a professional resume for a senior software engineer
```

Claude writes the `.typ` file, compiles it, and gives you the PDF.

### Compile an existing .typ file

```
/unofficial-typst:compile document.typ
```

### Use Typst directly

The plugin adds `typst` to your PATH:

```bash
typst compile input.typ output.pdf
```

## Bundled Platforms

| Platform | Architecture | Target |
|----------|-------------|--------|
| macOS | Apple Silicon | `aarch64-apple-darwin` |
| macOS | Intel | `x86_64-apple-darwin` |
| Linux | ARM64 | `aarch64-unknown-linux-musl` |
| Linux | x86_64 | `x86_64-unknown-linux-musl` |

The correct binary is selected automatically at runtime.

## Bundled Typst Version

**v0.14.2** - Binaries are sourced from [typst/typst releases](https://github.com/typst/typst/releases).

To update to a newer release:

```bash
./scripts/download-binaries.sh v0.15.0  # specific version
./scripts/download-binaries.sh           # latest
```

## License

This plugin is licensed under the [Apache License 2.0](LICENSE).

Typst itself is licensed under the Apache License 2.0 by its authors. See [typst/typst](https://github.com/typst/typst) for details. The pre-built binaries bundled in this plugin are unmodified copies from the official Typst releases.
