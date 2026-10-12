# Examples

Two finished documents built with the template, to show what it produces with
real content in it and not placeholder text.

| | Technical document | Dissertation |
|---|---|---|
| What it is | A design note for an anti-aliasing filter in front of a 12-bit ADC | A dissertation on getting more resolution from an ADC by oversampling and averaging |
| Length | 15 pages | 24 pages |
| Built PDF | [technical-document-example.pdf](technical-document-example.pdf) | [dissertation-example.pdf](dissertation-example.pdf) |
| Source | [technical-document/](technical-document) | [dissertation/](dissertation) |

<p align="center">
  <img src="technical-document-preview.png" width="330" alt="Title page of the technical document example">
  <img src="dissertation-preview.png" width="330" alt="Title page of the dissertation example">
</p>

## How the content was written

The content of both examples was developed by Claude Opus 5.5, an AI model
made by Anthropic. I asked it to use the template and write the two documents
so that there was something substantial to show as examples, and I am noting
it here to be transparent about having used it.

A few things follow from that, which are worth knowing before you read them:

- The company, the university, the author and the supervisor named in the
  documents are made up. "Example Electronics Ltd" and the "University of
  Example" do not exist.
- The filter values and the tolerance figures in the design note are
  calculated from the equations in it, and the results in the dissertation
  are the output of the simulation in `dissertation/assets/code/python/`,
  which you can run yourself.
- Nothing was built or measured. The design note says so, and gives a test
  plan where the results would go. The dissertation is a simulation study and
  says what that leaves out.
- The references are real publications, but check the details against the
  originals before citing them yourself.

They are here to show the template, so treat them as examples of layout and
structure and not as designs to build from.

## What each one shows

The design note is the kind of document the template was made for. It has a
revision table with two issues, a requirements table, a circuit drawn with
`circuitikz`, a response plotted from its equation with `pgfplots`, a
tolerance table, a timing diagram, a C listing, a test plan, references, and
a derivation in an appendix.

The dissertation shows the other set of front matter, which is the
dissertation title page, the declaration of authorship, the abstract and the
acknowledgements. Its tables and plots are built straight from the CSV files
that the simulation writes, and its code listings are pulled from the real
source file, so the document cannot drift away from the results.

## How they are put together

Each example folder is a complete project, with its own copy of the preamble
and front matter, so you can take either one as it is and use it as the start
of your own document.

Most of the files in each are plain copies of the template's. The ones written
for the example, which are the ones you would change for a document of your
own, are:

- `preamble/metadata.tex`, for the title, the names and the switches
- `main.tex`, to list the sections
- the sections, appendices, figures, code and references
- the nomenclature, and the revision table or the abstract and
  acknowledgements

## Building them

From inside either example folder, build it in the usual way:

```bash
latexmk -pdf main
```

On Overleaf, zip the example folder and upload it as a new project, with the
compiler set to pdfLaTeX.

## Keeping them up to date

When the template changes, the copies in the examples need to follow. This
script copies the template's shared files into both examples again, rebuilds
them, and refreshes the PDFs and preview images in this folder:

```bash
bash examples/build-examples.sh
```

It builds in a temporary folder, so no build files are left behind. It needs
`latexmk`, and `pdftoppm` for the preview images.

To reproduce the dissertation's results, run the simulation, which rewrites
the two CSV files in `dissertation/assets/data/`. It uses a fixed seed, so
the numbers come out the same every time:

```bash
python examples/dissertation/assets/code/python/oversampling_sim.py
```
