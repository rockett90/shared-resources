#!/usr/bin/env bash
# ====================================================================
# build-examples.sh
# --------------------------------------------------------------------
# Brings the examples in this folder up to date with the template and
# rebuilds their PDFs.
#
# Each example is a complete project that builds on its own. Most of
# its files are plain copies of the template's, so after the template
# changes this script:
#   1. copies the template's shared files into each example again
#   2. builds each example in a temporary folder, from its own files
#      only, which proves it still stands alone
#   3. copies the PDF, and a preview of its first page, back here
#
# Usage, from anywhere:   bash examples/build-examples.sh
# Needs: latexmk, and pdftoppm for the preview images (optional).
# ====================================================================
set -euo pipefail

here="$(cd "$(dirname "$0")" && pwd)"
template="$(dirname "$here")"

# Template files that every example uses exactly as they are. These are
# overwritten each time, so do not edit them inside an example.
shared=(
  .latexmkrc
  .gitignore
  preamble/packages.tex
  preamble/macros.tex
  preamble/layout.tex
  preamble/header-footer.tex
  preamble/styling.tex
  preamble/watermark.tex
  content/frontmatter/frontmatter.tex
  content/frontmatter/lists.tex
  content/frontmatter/titlepage/titlePage.tex
  content/frontmatter/titlepage/titlePage-dissertation.tex
  assets/logos/Logo.png
)

# Template files an example may replace with its own. These are copied
# only where the example does not have one, so that every switch in
# metadata.tex still has a file behind it.
placeholders=(
  content/frontmatter/titlepage/overview.tex
  content/frontmatter/revisionControl.tex
  content/frontmatter/nomenclature.tex
  content/frontmatter/declaration.tex
  content/frontmatter/abstract.tex
  content/frontmatter/acknowledgements.tex
)

for example in technical-document dissertation; do
  echo "Updating $example ..."
  for f in "${shared[@]}"; do
    mkdir -p "$here/$example/$(dirname "$f")"
    cp "$template/$f" "$here/$example/$f"
  done
  for f in "${placeholders[@]}"; do
    if [ ! -e "$here/$example/$f" ]; then
      mkdir -p "$here/$example/$(dirname "$f")"
      cp "$template/$f" "$here/$example/$f"
    fi
  done

  echo "Building $example ..."
  work="$(mktemp -d)"
  cp -r "$here/$example/." "$work/"
  if ! (cd "$work" && latexmk -pdf -interaction=nonstopmode -halt-on-error main > build.out 2>&1); then
    tail -n 40 "$work/build.out"
    echo "Build failed. The working folder is $work"
    exit 1
  fi

  cp "$work/main.pdf" "$here/$example-example.pdf"
  if command -v pdftoppm > /dev/null; then
    pdftoppm -r 110 -f 1 -l 1 -singlefile -png "$work/main.pdf" "$here/$example-preview"
  fi
  rm -rf "$work"
  echo "  wrote examples/$example-example.pdf"
done
