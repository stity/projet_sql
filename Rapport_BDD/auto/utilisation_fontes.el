(TeX-add-style-hook
 "utilisation_fontes"
 (lambda ()
   (TeX-run-style-hooks
    "latex2e"
    "article"
    "art10"
    "fontspec")
   (TeX-add-symbols
    "textmyfont")
   (LaTeX-add-environments
    "myfont"))
 :latex)

