# unofficial-typst Plugin Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Build a Claude Code plugin that bundles Typst binaries and provides a prompt-to-PDF workflow in any Claude environment.

**Architecture:** Monolithic plugin with platform-detection wrapper in `bin/`, a Typst language reference skill, and a `/compile` command that goes from natural language to PDF. Binaries are committed directly to the repo.

**Tech Stack:** POSIX shell (wrapper script), Bash (download script), Markdown (skill + command)

**Spec:** `docs/superpowers/specs/2026-04-07-unofficial-typst-plugin-design.md`

---

## File Structure

```
unofficial-typst/
├── .claude-plugin/
│   └── plugin.json                        # Plugin manifest (metadata only)
├── bin/
│   ├── typst                              # POSIX shell wrapper (platform detection + exec)
│   ├── typst-aarch64-apple-darwin         # macOS ARM binary (downloaded)
│   ├── typst-x86_64-apple-darwin          # macOS Intel binary (downloaded)
│   ├── typst-aarch64-unknown-linux-musl   # Linux ARM binary (downloaded)
│   └── typst-x86_64-unknown-linux-musl    # Linux x86_64 binary (downloaded)
├── skills/
│   └── typst/
│       └── SKILL.md                       # Typst language reference card
├── commands/
│   └── compile.md                         # /unofficial-typst:compile slash command
├── scripts/
│   └── download-binaries.sh               # Fetches Typst release binaries from GitHub
├── .gitattributes                         # Binary file handling
└── README.md                              # Usage and installation docs
```

---

### Task 1: Plugin Manifest & Git Setup

**Files:**
- Create: `.claude-plugin/plugin.json`
- Create: `.gitattributes`

- [ ] **Step 1: Create plugin manifest**

Create `.claude-plugin/plugin.json`:

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

- [ ] **Step 2: Create .gitattributes**

Mark binaries so git handles them correctly:

```
bin/typst-* binary
```

- [ ] **Step 3: Commit**

```bash
git add .claude-plugin/plugin.json .gitattributes
git commit -m "feat: add plugin manifest and git config"
```

---

### Task 2: Platform Detection Wrapper Script

**Files:**
- Create: `bin/typst`

- [ ] **Step 1: Write the wrapper script**

Create `bin/typst`:

```sh
#!/bin/sh
set -e

# Resolve the directory this script lives in
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

# Detect OS
OS="$(uname -s)"
case "$OS" in
  Darwin) OS_TARGET="apple-darwin" ;;
  Linux)  OS_TARGET="unknown-linux-musl" ;;
  *)
    echo "Error: Unsupported operating system: $OS" >&2
    echo "unofficial-typst supports macOS and Linux only." >&2
    exit 1
    ;;
esac

# Detect architecture
ARCH="$(uname -m)"
case "$ARCH" in
  arm64|aarch64) ARCH_TARGET="aarch64" ;;
  x86_64)        ARCH_TARGET="x86_64" ;;
  *)
    echo "Error: Unsupported architecture: $ARCH" >&2
    echo "unofficial-typst supports aarch64 and x86_64 only." >&2
    exit 1
    ;;
esac

# Construct binary path
BINARY="$SCRIPT_DIR/typst-${ARCH_TARGET}-${OS_TARGET}"

if [ ! -x "$BINARY" ]; then
  echo "Error: Typst binary not found at $BINARY" >&2
  echo "Run scripts/download-binaries.sh to fetch binaries." >&2
  exit 1
fi

exec "$BINARY" "$@"
```

- [ ] **Step 2: Make it executable**

```bash
chmod +x bin/typst
```

- [ ] **Step 3: Test the wrapper (smoke test)**

```bash
bin/typst --version
```

Expected: Error about missing binary (since we haven't downloaded them yet), specifically: `Error: Typst binary not found at .../bin/typst-<arch>-<os>`

- [ ] **Step 4: Commit**

```bash
git add bin/typst
git commit -m "feat: add platform detection wrapper script"
```

---

### Task 3: Binary Download Script

**Files:**
- Create: `scripts/download-binaries.sh`

- [ ] **Step 1: Write the download script**

Create `scripts/download-binaries.sh`:

```bash
#!/bin/bash
set -euo pipefail

VERSION="${1:-latest}"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
BIN_DIR="$SCRIPT_DIR/../bin"
TEMP_DIR="$(mktemp -d)"

# Targets to download
TARGETS=(
  "aarch64-apple-darwin"
  "x86_64-apple-darwin"
  "aarch64-unknown-linux-musl"
  "x86_64-unknown-linux-musl"
)

# Resolve version
if [ "$VERSION" = "latest" ]; then
  echo "Fetching latest Typst version..."
  VERSION="$(curl -sI https://github.com/typst/typst/releases/latest | grep -i '^location:' | sed 's/.*tag\///' | tr -d '\r\n')"
fi

echo "Downloading Typst $VERSION binaries..."

cleanup() {
  rm -rf "$TEMP_DIR"
}
trap cleanup EXIT

for TARGET in "${TARGETS[@]}"; do
  ARCHIVE="typst-${TARGET}.tar.xz"
  URL="https://github.com/typst/typst/releases/download/${VERSION}/${ARCHIVE}"
  DEST="$BIN_DIR/typst-${TARGET}"

  echo "  Downloading $ARCHIVE..."
  curl -sL "$URL" -o "$TEMP_DIR/$ARCHIVE"

  echo "  Extracting..."
  tar -xf "$TEMP_DIR/$ARCHIVE" -C "$TEMP_DIR"

  # The archive contains typst-<target>/typst
  cp "$TEMP_DIR/typst-${TARGET}/typst" "$DEST"
  chmod +x "$DEST"

  echo "  Installed: $DEST"
done

echo ""
echo "Done! Typst $VERSION binaries installed to $BIN_DIR"
echo "Verify with: bin/typst --version"
```

- [ ] **Step 2: Make it executable**

```bash
chmod +x scripts/download-binaries.sh
```

- [ ] **Step 3: Commit**

```bash
git add scripts/download-binaries.sh
git commit -m "feat: add binary download script"
```

---

### Task 4: Download and Commit Binaries

**Files:**
- Create: `bin/typst-aarch64-apple-darwin`
- Create: `bin/typst-x86_64-apple-darwin`
- Create: `bin/typst-aarch64-unknown-linux-musl`
- Create: `bin/typst-x86_64-unknown-linux-musl`

- [ ] **Step 1: Run the download script**

```bash
./scripts/download-binaries.sh v0.14.2
```

Expected: All 4 binaries downloaded and placed in `bin/`.

- [ ] **Step 2: Verify the wrapper works**

```bash
bin/typst --version
```

Expected: `typst 0.14.2` (or similar version string)

- [ ] **Step 3: Verify with a test compile**

```bash
echo '= Hello World' > /tmp/test.typ
bin/typst compile /tmp/test.typ /tmp/test.pdf
ls -la /tmp/test.pdf
rm /tmp/test.typ /tmp/test.pdf
```

Expected: PDF created successfully.

- [ ] **Step 4: Commit binaries**

```bash
git add bin/typst-*
git commit -m "feat: add Typst v0.14.2 binaries for macOS and Linux"
```

---

### Task 5: Typst Language Skill

**Files:**
- Create: `skills/typst/SKILL.md`

- [ ] **Step 1: Write the skill**

Create `skills/typst/SKILL.md` with the following content. This is a Typst language reference card that Claude auto-activates when working with `.typ` files or generating documents.

```markdown
---
name: typst
description: >
  Use when creating, editing, or compiling Typst (.typ) documents, or when
  the user asks to generate PDFs from markup. Typst is a modern typesetting
  system — an alternative to LaTeX with simpler syntax.
---

# Typst Reference

Typst compiles `.typ` files to PDF. Compile with: `typst compile input.typ output.pdf`

## Document Structure

A Typst document is markup by default. Use `#` to enter code mode inline.

### Page & Text Setup

```typst
#set page(paper: "us-letter", margin: (x: 1in, y: 1in))
#set text(font: "Linux Libertine", size: 11pt)
#set par(justify: true)
```

### Headings

```typst
= Top-Level Heading
== Second Level
=== Third Level
```

### Text Formatting

```typst
*bold text*
_italic text_
`inline code`
*_bold italic_*
```

### Lists

```typst
- Unordered item
- Another item
  - Nested item

+ Ordered item
+ Second item

/ Term: Description
/ Another: Its definition
```

### Links & References

```typst
https://example.com
#link("https://example.com")[click here]

= Introduction <intro>
See @intro for details.
```

### Images & Figures

```typst
#figure(
  image("photo.png", width: 80%),
  caption: [A descriptive caption],
)
```

### Tables

```typst
#table(
  columns: (1fr, 2fr, 1fr),
  align: (left, center, right),
  table.header([Name], [Description], [Value]),
  [Alpha], [First item], [100],
  [Beta], [Second item], [200],
)
```

### Math

Inline: $x^2 + y^2 = z^2$

Display (note the spaces inside `$`):

```typst
$ sum_(i=0)^n i = (n(n+1)) / 2 $
```

### Code Blocks

````typst
```python
def hello():
    print("world")
```
````

### Variables & Functions

```typst
#let title = "My Document"
#let greet(name) = [Hello, #name!]

#greet("World")
```

### Show Rules (Customization)

```typst
// Make all headings blue
#show heading: set text(fill: blue)

// Custom heading rendering
#show heading.where(level: 1): it => {
  set text(size: 20pt, weight: "bold")
  block(below: 1em)[#it.body]
}
```

### Page Breaks

```typst
#pagebreak()
```

### Horizontal Rule

```typst
#line(length: 100%)
```

## Common Patterns

### Letter

```typst
#set page(paper: "us-letter", margin: 1.5in)
#set text(size: 12pt)

#align(right)[
  Your Name \
  Your Address \
  #datetime.today().display("[month repr:long] [day], [year]")
]

#v(2em)

Dear Recipient,

#lorem(50)

Sincerely, \
Your Name
```

### Report with Table of Contents

```typst
#set page(paper: "us-letter", margin: 1in)
#set text(size: 11pt)
#set heading(numbering: "1.1")

#align(center)[
  #text(size: 24pt, weight: "bold")[Report Title]
  #v(1em)
  Author Name
  #v(0.5em)
  #datetime.today().display()
]

#pagebreak()
#outline()
#pagebreak()

= Introduction
#lorem(100)

= Methodology
#lorem(100)
```

## Key Differences from LaTeX

- No `\begin{document}` — content starts immediately
- Use `*bold*` not `\textbf{bold}`
- Use `_italic_` not `\textit{italic}`
- Use `= Heading` not `\section{Heading}`
- Use `#set` for configuration, not preamble commands
- Use `$...$` for math (same), but display math uses spaces: `$ x $`
- Lists use `- + /` prefixes, not `\begin{itemize}`
- No packages to import for basic features — batteries included

## Error Handling

Typst provides line-numbered error messages. Common errors:
- `unknown variable` — check spelling, ensure `#let` is before usage
- `expected ... found ...` — type mismatch, check function arguments
- `file not found` — check path relative to the `.typ` file
- `unknown font family` — font not available; use `typst fonts` to list available fonts
```

- [ ] **Step 2: Commit**

```bash
git add skills/typst/SKILL.md
git commit -m "feat: add Typst language reference skill"
```

---

### Task 6: Compile Command

**Files:**
- Create: `commands/compile.md`

- [ ] **Step 1: Write the compile command**

Create `commands/compile.md`:

```markdown
---
description: Generate a PDF from a natural language description or compile an existing .typ file
---

# Typst Compile

You have been asked to create a PDF document. The user's request is: "$ARGUMENTS"

Follow this workflow:

## Step 1: Determine mode

- If the argument ends in `.typ`, this is a **compile-only** request. Skip to Step 3.
- Otherwise, this is a **generate-and-compile** request. Continue to Step 2.

## Step 2: Generate the .typ file

Based on the user's description, create a Typst document:

1. Choose a descriptive filename (e.g., `resume.typ`, `report.typ`, `letter.typ`)
2. Write the complete `.typ` file using your Typst knowledge
3. Make it professional and well-structured
4. Use appropriate page setup, fonts, and layout for the document type

Write the file using the Write tool.

## Step 3: Compile to PDF

Run:
```
typst compile <filename>.typ
```

This produces `<filename>.pdf` in the same directory.

## Step 4: Handle errors

If compilation fails:
1. Read the error message carefully — Typst provides line numbers and clear descriptions
2. Fix the issue in the `.typ` source file
3. Recompile
4. Repeat up to 3 times. If still failing, report the error to the user.

## Step 5: Report result

Tell the user:
- The PDF file path
- A brief summary of what was created
- Any notable design choices you made
```

- [ ] **Step 2: Commit**

```bash
git add commands/compile.md
git commit -m "feat: add /compile command for prompt-to-PDF workflow"
```

---

### Task 7: README

**Files:**
- Create: `README.md`

- [ ] **Step 1: Write the README**

Create `README.md`:

```markdown
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
```

- [ ] **Step 2: Commit**

```bash
git add README.md
git commit -m "docs: add README with installation and usage instructions"
```

---

### Task 8: End-to-End Test

- [ ] **Step 1: Load the plugin and test**

```bash
claude --plugin-dir .
```

Inside Claude Code:
1. Run `/unofficial-typst:compile a one-page summary of climate change`
2. Verify a `.typ` file is created
3. Verify a `.pdf` file is created
4. Check the PDF has reasonable content

- [ ] **Step 2: Test direct compilation**

Create a test file manually, then:
```
/unofficial-typst:compile test.typ
```

Verify the PDF is produced.

- [ ] **Step 3: Test the skill activates**

Ask Claude: "Create a Typst document with a table comparing programming languages"

Verify Claude uses correct Typst syntax (not LaTeX).
