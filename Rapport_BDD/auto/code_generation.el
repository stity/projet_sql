(TeX-add-style-hook
 "code_generation"
 (lambda ()
   (TeX-run-style-hooks
    "text/Pages_gnl/resume"
    "text/Pages_gnl/abstract"
    "text/Pages_gnl/remerciements"
    "text/Pages_gnl/introduction"
    "text/Pages_gnl/conclusion")
   (TeX-add-symbols
    '("printIfNotZero" 2)
    '("includeRemerciements" 1)
    '("includeAbstract" 1)
    '("includeResume" 1)
    '("includeLOT" 1)
    '("includeLOF" 1)
    '("includeTOC" 1)
    '("whereIncludeFile" 4)
    "includeIntroduction"
    "includeConclusion"))
 :latex)

