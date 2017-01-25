(TeX-add-style-hook
 "bdd"
 (lambda ()
   (TeX-run-style-hooks
    "images/Elaboration/diagramme_tables")
   (LaTeX-add-labels
    "fig:tables"))
 :latex)

