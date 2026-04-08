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
