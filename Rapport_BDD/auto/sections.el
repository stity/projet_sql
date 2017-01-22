(TeX-add-style-hook
 "sections"
 (lambda ()
   (TeX-run-style-hooks
    "text/Pages_gnl/annexe")
   (TeX-add-symbols
    '("crule" ["argument"] 2)
    '("subsubParagraphe" 1)
    '("subParagraphe" 1)
    '("nnsection" 1)
    '("invisiblesection" 1)
    "appendixsection"
    "pasdetitreici"
    "section")
   (LaTeX-add-environments
    '("exemple" 1)
    '("question" 1)
    '("paragraphe" 1)
    '("generalminiparagraph" 4)
    '("generalparagraph" 4)
    "remarque"
    "attention"
    "information"
    "convention"
    "lecture"
    "notation"
    "demonstration"
    "exempleInterne")
   (LaTeX-add-lengths
    "mytextsize"))
 :latex)

