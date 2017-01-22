(TeX-add-style-hook
 "miscellaneous"
 (lambda ()
   (TeX-add-symbols
    '("getmin" 2)
    '("iiResult" 4)
    '("isResult" 3)
    '("itResult" 2)
    '("iResult" 2)
    '("inputn" 1)
    '("roundboxwithline" 2)
    '("itemAcro" 4)
    '("itemGlossaire" 3)
    '("needCompletion" 1)
    "printheaderLeft"
    "printheaderRight"
    "printfooterRight"
    "printfooterLeft"
    "emphasizeTab"
    "beware"
    "rectif"
    "qpays"
    "qvolprod"
    "qprofil"
    "qinteret"
    "qpayback"
    "qbudget"
    "qagriculture")
   (LaTeX-add-labels
    "#2"
    "#3")
   (LaTeX-add-environments
    "changemargin")
   (LaTeX-add-pagestyles
    "mystyle"))
 :latex)

