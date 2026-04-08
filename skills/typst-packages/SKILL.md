---
name: typst-packages
description: >
  Use before creating complex Typst documents like Gantt charts, timelines,
  diagrams, or specialized layouts. Searches the Typst package registry for
  existing packages that could simplify the task.
---

# Typst Package Search

Before writing complex Typst markup from scratch, check whether a community package already handles it.

## When to search

Search for packages when the user asks for:
- Charts or diagrams (Gantt, flowchart, sequence diagram, etc.)
- Timelines or calendars
- Specialized table layouts
- Code syntax highlighting beyond basics
- Scientific or academic formats (IEEE, APA, etc.)
- Slide presentations
- Any document type that feels like it needs a template

## How to search

Use WebFetch to search the Typst package registry:

```
https://packages.typst.org/preview/index.json
```

This returns a JSON index of all published packages with names and descriptions. Search it for keywords related to the user's request.

Packages are imported in Typst with:

```typst
#import "@preview/package-name:version": *
```

## What to do with results

- If a relevant package exists, tell the user and use it.
- If multiple packages match, briefly list them and recommend one.
- If nothing fits, write the Typst markup from scratch.

Do not spend excessive time searching. A quick keyword check is enough.
