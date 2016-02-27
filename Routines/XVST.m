XVST ; Paideia/SMH - VPE handle timeout ; 10/18/09 12:29am
 S XVVSHC=$G(^XVEMS("QU",XVV("ID"),"TO"))
 Q:XVVSHC=""
 S:XVVSHC="HALT"!(XVVSHC="halt") XVVSHC="^"
