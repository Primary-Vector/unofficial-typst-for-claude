# unofficial-typst

A Claude Code plugin that bundles [Typst](https://typst.app) binaries for macOS and Linux, enabling PDF generation from markup in any Claude environment — including Claude Code Workbench VMs where Typst cannot be installed.

## Installation

### From a marketplace

```bash
/plugin install <marketplace-url>
```

### From local directory

```bash
claude --plugin-dir ./unofficial-typst
```

## Usage

### Generate a PDF from a prompt

```
/unofficial-typst:compile a professional resume for a senior software engineer
```

### Compile an existing .typ file

```
/unofficial-typst:compile document.typ
```

### Use Typst directly

The plugin adds `typst` to your PATH, so you can use it in any Bash command:

```bash
typst compile input.typ output.pdf
```

## Bundled Platforms

| Platform | Architecture | Binary |
|----------|-------------|--------|
| macOS | Apple Silicon (ARM) | `typst-aarch64-apple-darwin` |
| macOS | Intel (x86_64) | `typst-x86_64-apple-darwin` |
| Linux | ARM | `typst-aarch64-unknown-linux-musl` |
| Linux | x86_64 | `typst-x86_64-unknown-linux-musl` |

## Updating Typst

To update to a newer version of Typst:

```bash
./scripts/download-binaries.sh v0.15.0
```

Or fetch the latest:

```bash
./scripts/download-binaries.sh
```

## License

This plugin is MIT licensed. Typst itself is licensed under the Apache License 2.0.
