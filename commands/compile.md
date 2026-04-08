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
