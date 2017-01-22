(TeX-add-style-hook
 "Rapport_BDD"
 (lambda ()
   (TeX-add-to-alist 'LaTeX-provided-class-options
                     '(("article" "11pt" "a4paper")))
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
    "text/Travail_realise/ennonce"
    "text/Travail_realise/rendu"
    "text/Travail_realise/installation"
    "text/Plateforme/vues"
    "text/Plateforme/users"
    "text/Plateforme/phones"
    "text/Plateforme/bills"
    "text/Plateforme/abonnements"
    "text/Ameliorations/plateforme"
    "article"
    "art11")
   (TeX-add-symbols
    "sectionbreak")
   (LaTeX-add-labels
    "sec:elaboration-bdd"))
 :latex)

