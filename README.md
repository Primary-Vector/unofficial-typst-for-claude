# unofficial-typst

A [Claude Code](https://docs.anthropic.com/en/docs/claude-code) plugin that ships pre-built [Typst](https://typst.app) binaries, so you can generate PDFs from markup in any Claude environment — including locked-down VMs like Claude Code Workbench where you can't install software.

> **This is an unofficial community plugin.** It is not affiliated with or endorsed by the Typst project. Typst is created and maintained by [typst/typst](https://github.com/typst/typst) and licensed under the Apache License 2.0. All credit for the Typst typesetting system belongs to its authors and contributors.

## The Problem

Claude Code Workbench runs on locked-down Linux VMs with no package manager access. If you want Claude to generate a PDF — a resume, a report, an invoice — there's no way to install a typesetting tool. Even in local Claude Code, requiring users to install Typst adds friction.

## The Solution

This plugin bundles Typst binaries directly. Install the plugin, and `typst` is available on PATH. No setup, no package manager, no prerequisites.

It also includes:
- A **Typst language skill** so Claude writes correct `.typ` syntax instead of guessing
- A **`/compile` command** that goes from natural language prompt to PDF in one step

## Installation

Add the marketplace and install:

```
/plugin marketplace add Primary-Vector/unofficial-typst
/plugin install unofficial-typst@unofficial-typst
```

Or load directly during development:

```bash
claude --plugin-dir ./unofficial-typst
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

**v0.14.2** — Binaries are sourced from [typst/typst releases](https://github.com/typst/typst/releases).

To update to a newer release:

```bash
./scripts/download-binaries.sh v0.15.0  # specific version
./scripts/download-binaries.sh           # latest
```

## License

This plugin is licensed under the [Apache License 2.0](LICENSE).

Typst itself is licensed under the Apache License 2.0 by its authors. See [typst/typst](https://github.com/typst/typst) for details. The pre-built binaries bundled in this plugin are unmodified copies from the official Typst releases.
