; 練習問題 2.55 (car ''abracadabra) ;=> quote
; ''somethingがインタープリタにより、(quote (quote something))と見做されたため、
; (car ''something)は quote と評価された.