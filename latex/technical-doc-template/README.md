# Technical Document Template

A general-purpose LaTeX template for technical documentation — engineering
reports, specifications, research write-ups, educational material, and
university dissertations. The bundled examples use an electronics theme, but 
nothing in the framework is field-specific; replace the example content with 
your own.

## Compiling

The easiest way is with `latexmk`:

```
latexmk -pdf main
```

This handles the full chain automatically: `pdflatex` → `bibtex` →
`makeindex` (for nomenclature) → `pdflatex` → `pdflatex`. A `.latexmkrc`
is included to wire in the nomenclature step.

If compiling manually:

```
pdflatex main
bibtex main
makeindex main.nlo -s nomencl.ist -o main.nls
pdflatex main
pdflatex main
```

On Overleaf, set the compiler to **pdfLaTeX** and the project should work
out of the box.

## What to edit for a new document

For most documents you only need to touch a few places:

- `preamble/metadata.tex` — title, author, company, issue, date, logo path
- `content/frontmatter/titlepage/overview.tex` — Short paragraph on the standard (non-dissertation) title page
- `content/frontmatter/titlepage/titlePage.tex` — Update the figure for your circuit or example
- `content/sections` — the actual writing

Everything else (packages, layout, styling) stays the same across documents.

## Folder structure

```
main.tex                   entry point
preamble/                  all configuration
  packages.tex             every \usepackage in one place
  metadata.tex             per-document fields
  macros.tex               user-defined shortcuts
  layout.tex               table helpers, section/ToC depth
  header-footer.tex        fancyhdr setup
  styling.tex              colours, hyperref, listings style
  watermark.tex            DRAFT overlay (draft mode only)
content/
  frontmatter/             title page, revision control, ToC, lists, nomenclature
  sections/                main body (\section, not \chapter — article class)
  appendices/              appendix material
assets/
  logos/                   logo image(s) used on the title page
  code/                    code listing examples
  figures/                 circuits, plots, timing diagrams
bib/mybib.bib              bibliography database
LINKS.md                   useful editor URLs
```

## Draft mode

Toggle `\draftmodetrue` / `\draftmodefalse` in `preamble/metadata.tex` to
switch the DRAFT watermark (and any other draft-only elements) on and off.

## Dissertation use

For university dissertation use, several optional bits are stubbed (commented
out) in `content/frontmatter/frontmatter.tex` — abstract, acknowledgements,
declaration of authorship, and a dissertation-style title page. Uncomment the
`\input` lines there to enable them.

To switch to the dissertation title page, in `frontmatter.tex` comment out the
`titlePage` input and uncomment the `titlePage-dissertation` one. The
dissertation fields (supervisor, department, university, degree, submission
date) are pre-filled with placeholders in `preamble/metadata.tex` — edit them
there. The page compiles even if a field is missing, showing a bracketed
placeholder like `[supervisor name]` so you can see what still needs filling
in.

For printed and bound copies, see the `bindingoffset` comment in
`preamble/packages.tex` to add an inner-margin gutter.

## Requirements

- A reasonably current TeX distribution (TeX Live 2020+ or MiKTeX)
- Packages: libertine, circuitikz, tikz-timing, siunitx, natbib, nomencl,
  pgfplots, hyperref, cleveref, and the usual suspects (all in TeX Live)
- IEEEtran.bst (for IEEE-style citations, included in TeX Live)
