# ====================================================================
# .latexmkrc
# --------------------------------------------------------------------
# Build configuration for `latexmk -pdf main`.
#
# Handles:
#   - pdflatex compilation
#   - bibtex for references
#   - makeindex for the nomencl nomenclature list (.nlo -> .nls)
# ====================================================================

$pdf_mode    = 1;   # use pdflatex
$bibtex_use  = 2;   # run bibtex when needed, even if .bib is missing

# Custom dependency: nomencl uses makeindex with the nomencl style file
# to turn the .nlo file into a printable .nls file.
add_cus_dep('nlo', 'nls', 0, 'nlo2nls');
sub nlo2nls {
    system("makeindex \"$_[0].nlo\" -s nomencl.ist -o \"$_[0].nls\"");
}

# Treat .nls and .nlo as generated files so `latexmk -c` cleans them up.
push @generated_exts, 'nlo', 'nls';
