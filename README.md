# unofficial-typst-for-claude

A [Claude Code](https://docs.anthropic.com/en/docs/claude-code) plugin that ships pre-built [Typst](https://typst.app) binaries, so you can generate PDFs from markup in any Claude environment.

> **This is an unofficial community plugin.** It is not affiliated with or endorsed by the Typst project. Typst is created and maintained by [typst/typst](https://github.com/typst/typst) and licensed under the Apache License 2.0. All credit for the Typst typesetting system belongs to its authors and contributors.

## Why

[Typst](https://typst.app) is a modern markup language for producing consistent, well-formatted documents. It compiles to PDF, has clean syntax, and is easy for LLMs to write correctly. It is a great fit for generating resumes, reports, invoices, and letters from Claude.

The problem is getting Typst installed. Workbench runs on locked-down Linux VMs where you can't install anything. Local Claude Code requires users to set up Typst themselves. Either way, there is friction between "write me a document" and actually getting a PDF.

This plugin removes that friction. It bundles Typst binaries for macOS and Linux directly, so `typst` is on PATH the moment you install it. No package manager, no setup, no prerequisites. It also includes a Typst language skill (so Claude writes correct `.typ` syntax instead of hallucinating LaTeX) and a `/compile` command that takes you from a natural language prompt to a finished PDF in one step.

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
