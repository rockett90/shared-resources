# CV template

A clean, two-page LaTeX CV template. It shares the visual identity of the
[technical-doc-template](../technical-doc-template) in this repo — Linux
Libertine type, a teal/ochre accent palette on a warm cream page, an
Inconsolata mono accent for dates and skill labels, and a stacked double-rule
masthead.

It's designed to stay **parser-friendly** for automated CV/résumé intake (ATS):
a genuine selectable text layer, single column, standard section headings, and
contact details as real text. See [Parser notes](#parser-notes-ats) below.

> The template ships with a fictional persona ("Jane Doe") and lorem ipsum
> content so you can see the layout. Replace all of it with your own details.

## Compiling

**Locally** (TeX Live or MiKTeX), from this folder:

```bash
latexmk -pdf main        # recommended — runs as many passes as needed
# or, run twice for correct page balance:
pdflatex main.tex
pdflatex main.tex
```

Output is `main.pdf`.

**On [Overleaf](https://www.overleaf.com):** upload `main.tex` (and `.latexmkrc`),
set the compiler to **pdfLaTeX**, and compile. No bibliography or extra passes
are needed.

> **Fonts:** requires `libertine`, `libertinust1math`, `inconsolata` and
> `fontawesome5` — all present in a full TeX Live / Overleaf install. On a
> minimal local install, add the `texlive-fonts-extra` package.

## What to edit

Almost everything you'll change lives in the **`CONFIG`** block near the top of
`main.tex`:

- **Personal fields** — `\cvName`, `\cvRole`, `\cvEmail`, `\cvPhone`,
  `\cvLocation`, `\cvLinkedinText` / `\cvLinkedinUrl`.
- **Palette** — `linkblue` (primary teal: role titles, links, icons, section
  bar), `inknavy` (deeper teal: name + headings), `ochre` (hairline + bullets),
  `darkgrey` (secondary text), `creampage` (background). For a plain white page,
  set `\pagecolor{white}`.
- **Leading / margins** — `\linespread` in the config block; page `margin` in
  the `geometry` line just above it.

The body content (summary, experience, education, skills, certifications) sits
in the `DOCUMENT` section lower down and uses these helper macros:

| Macro | Use |
|-------|-----|
| `\role{title}{dates}{employer}{location}` | A job, followed by a `cvitems` bullet list. |
| `\shortrole{title}{employer}{dates}{location}{one-line descriptor}` | A compact entry for older roles. |
| `\edu{qualification}{institution}{dates}` | An education entry. |
| `\edusub{sub-award}{institution}{dates}` | A smaller item nested under the preceding `\edu`. |
| `\skillrow{category}{comma, separated, list}` | A labelled skills line. |

## Draft placeholders

The template has a draft toggle for spots where you might add a metric but don't
have one yet — never invent figures:

```latex
\draftmodetrue     % placeholders VISIBLE (default) — shows e.g. [ add figure: … ]
\draftmodefalse    % placeholders HIDDEN — set this before producing the final PDF
```

Mark such a spot with `\addfigure{what's missing}`. The bundled example puts one
on an experience bullet. **Set `\draftmodefalse` (or fill the figures) before you
send the CV** — otherwise the red markers appear in the PDF.

## Parser notes (ATS)

- **Contact icons** use `accsupp` to set empty `ActualText`, so they render
  visually but add nothing to the extracted text layer — the contact line
  copies/pastes as clean text.
- **Cream background** is a separate PDF rendering layer; text extraction is
  unaffected. Set `\pagecolor{white}` if you want maximum conservatism.
- **Acronyms:** expand on first use (e.g. "Electromagnetic Compatibility (EMC)"),
  short form thereafter.
- **PDF metadata** (title, author, subject, keywords) is set in the
  `\hypersetup` block — keep it in sync with your details.

## Layout notes

- The **footer** (name · role left, page number right) appears on page 2 only.
- Page balance is tuned for a well-filled two pages. If content spills a single
  line onto a third page, nudge the `geometry` `margin` or the `\titlespacing`
  values slightly.
