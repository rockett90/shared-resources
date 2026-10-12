#!/usr/bin/env bash
# ====================================================================
# build-examples.sh
# --------------------------------------------------------------------
# Rebuilds the example PDFs in this folder.
#
# Each example folder holds only the files that differ from the
# template. For each one, this script copies the template to a
# temporary folder, copies the example over the top, builds it with
# latexmk, and copies the PDF (and a preview of its first page) back
# here. Nothing is built in place, so the template stays clean.
#
# Usage, from anywhere:   bash examples/build-examples.sh
# Needs: latexmk, and pdftoppm for the preview images (optional).
# ====================================================================
set -euo pipefail

here="$(cd "$(dirname "$0")" && pwd)"
template="$(dirname "$here")"

for example in technical-document dissertation; do
  echo "Building $example ..."
  work="$(mktemp -d)"

  # The template, without its examples or any build output
  cp "$template/main.tex" "$template/.latexmkrc" "$work/"
  cp -r "$template/preamble" "$template/content" "$template/assets" "$template/bib" "$work/"

  # The example's own files, over the top
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
