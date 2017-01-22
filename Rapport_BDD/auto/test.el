(TeX-add-style-hook
 "test"
 (lambda ()
   (TeX-run-style-hooks
    "latex2e"
    "article"
    "art10"
    "pdftexcmds")
   (TeX-add-symbols
    '("switch" 1)
    "be"))
 :latex)

