(TeX-add-style-hook
 "TemplateV2"
 (lambda ()
   (TeX-add-to-alist 'LaTeX-provided-class-options
                     '(("article" "11pt" "a4paper" "twoside")))
   (TeX-run-style-hooks
    "latex2e"
    "model/import"
    "model/colors"
    "conf/user_conf"
    "conf/auto_include"
    "model/code_generation"
    "model/format"
    "model/tikzConf"
    "model/boxes"
    "model/tableOfContents"
    "model/figures"
    "model/items"
    "model/miscellaneous"
    "model/sections_display"
    "model/sections"
    "model/section"
    "model/maths"
    "model/code"
    "model/fonts"
    "bib/all_bibs"
    "article"
    "art11")
   (TeX-add-symbols
    "sectionbreak"))
 :latex)

