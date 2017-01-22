(TeX-add-style-hook
 "fonts"
 (lambda ()
   (TeX-add-to-alist 'LaTeX-provided-package-options
                     '(("kurier" "math")))
   (TeX-run-style-hooks
    "fontspec"
    "kurier"
    "fontawesome"))
 :latex)

