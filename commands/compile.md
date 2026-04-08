---
description: Generate a document from a natural language description or compile an existing .typ file. Outputs PDF by default; also supports SVG and PNG.
---

# Typst Compile

You have been asked to create a document. The user's request is: "$ARGUMENTS"

Follow this workflow:

## Step 1: Determine mode and output format

- If the argument ends in `.typ`, this is a **compile-only** request. Skip to Step 2.
- Otherwise, this is a **generate-and-compile** request. Continue to Step 2.

Determine the output format from the user's request:
- Default is **PDF** unless the user asks for something else.
- If they mention PNG, SVG, or image output, use that format instead.

## Step 2: Generate the .typ file

Based on the user's description, create a Typst document:

1. Choose a descriptive filename (e.g., `resume.typ`, `report.typ`, `letter.typ`)
2. Write the complete `.typ` file using your Typst knowledge
3. Make it professional and well-structured
4. Use appropriate page setup, fonts, and layout for the document type

Write the file using the Write tool.

## Step 3: Compile

Run the appropriate command based on output format:

**PDF (default):**
```
typst compile <filename>.typ
```

**SVG:**
```
typst compile <filename>.typ <filename>.svg
```

**PNG:**
```
typst compile <filename>.typ <filename>.png
```

For PNG, you can control resolution with `--ppi` (default 144):
```
typst compile <filename>.typ <filename>.png --ppi 300
```

For multi-page documents exported to PNG or SVG, use a page number template:
```
typst compile <filename>.typ <filename>-{p}.png
```

## Step 4: Handle errors

If compilation fails:
1. Read the error message carefully — Typst provides line numbers and clear descriptions
2. Fix the issue in the `.typ` source file
3. Recompile
4. Repeat up to 3 times. If still failing, report the error to the user.

## Step 5: Report result

Tell the user:
- The output file path(s)
- A brief summary of what was created
- Any notable design choices you made
