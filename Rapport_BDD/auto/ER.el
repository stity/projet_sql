(TeX-add-style-hook
 "ER"
 (lambda ()
   (TeX-run-style-hooks
    "images/Elaboration/diagramme_er")
   (LaTeX-add-labels
    "fig:diag-er"))
 :latex)

