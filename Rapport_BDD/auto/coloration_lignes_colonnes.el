(TeX-add-style-hook
 "coloration_lignes_colonnes"
 (lambda ()
   (TeX-add-to-alist 'LaTeX-provided-package-options
                     '(("xcolor" "table")))
   (TeX-run-style-hooks
    "xcolor")
   (TeX-add-symbols
    "cc"))
 :latex)

