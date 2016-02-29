XVEMSGD ;DJB,VSHL**VShell Global - ZR,ZS,ZT ; 9/6/02 7:56am
 ;;13.0;VICTORY PROG ENVIRONMENT;;Feb 29, 2016
 ;
ZR ;;;Load ^XVEMS("ZR")
 NEW CD,FLAGCLH,PROMPT,Y S:'$D(XVV("IOM")) XVV("IOM")=80 X ^XVEMS("ZR",2) S CD="",FLAGCLH=">>" D SCREEN^XVEMKEA(PROMPT,0,XVV("IOM")-2) X ^XVEMS("ZR",4),^XVEMS("ZR",3)
 X:$D(^%ZOSF("UCI"))&($D(^XVEMS("PARAM",XVV("ID"),"PROMPT"))) ^%ZOSF("UCI")  S PROMPT=$G(Y)_">>" X ^XVEMS("ZR",5)
 S XVVSHC=$S(XVVSHC="<RET>":CD,XVVSHC?1"<".E1">".E&(CD']""):XVVSHC,1:"")
 I XVVSHC="TOO LONG" W ! D CLHSET^XVEMSCL("VSHL",CD) S XVVSHC=""
 KILL ^XVEMS("ERROR",XVV("ID"))
 ;;;***
ZS ;;;Load ^XVEMS("ZS")
 NEW % S ^XVEMS("%",$J_$G(^XVEMS("SY")))=+$H_"^Scratch Area" X ^XVEMS("ZS",7)
 Q:$G(^XVEMS("%",$J_$G(^XVEMS("SY")),"SV"))=""  X ^XVEMS("ZS",8)
 X ^XVEMS("ZS",2) D BS^XVEMKY1 NEW I F I=1:1:9 KILL @("%"_I) ;kill parameter variables
 Q:XVVSHC?1"<".E1">"!(",^,H,h,HALT,halt,"[(","_XVVSHC_","))  NEW CHK,X S CHK=0,X=$G(^XVEMS("CLH",XVV("ID"),"VSHL")) X ^XVEMS("ZS",6) Q:CHK  X ^XVEMS("ZS",5)
 S X=$G(^XVEMS("CLH",XVV("ID"),"VSHL"))+1,^("VSHL")=X,^("VSHL",X)=XVVSHC I X>20 S X=$O(^XVEMS("CLH",XVV("ID"),"VSHL","")) KILL ^(X)
 I X>0,$G(^XVEMS("CLH",XVV("ID"),"VSHL",X))=XVVSHC!($G(^(X-1))=XVVSHC) S CHK=1
 NEW %,LIST,VAR X ^XVEMS("ZS",9) S ^XVEMS("%",$J_$G(^XVEMS("SY")),"SV")="" F %=1:1:$L(LIST,"^") S VAR=$P(LIST,"^",%) S ^("SV")=^("SV")_$S($D(@VAR)#2:@VAR,1:"")_"^"
 NEW %,LIST X ^XVEMS("ZS",9) F %=1:1:$L(LIST,"^") S @($P(LIST,"^",%)_"=$P(^XVEMS(""%"",$J_$G(^XVEMS(""SY"")),""SV""),""^"",%)")
 S LIST="XVV(""ID"")^XVV(""EON"")^XVV(""EOFF"")^XVV(""IOF"")^XVV(""IOSL"")^XVV(""OS"")^XVV(""IO"")^XVV(""IOM"")^XVV(""TRMON"")^XVV(""TRMOFF"")^XVV(""TRMRD"")^XVV(""$ZE"")"
 ;;;***
ZT ;;;Shell timed out
 S XVVSHC=$G(^XVEMS("QU",XVV("ID"),"TO")) Q:XVVSHC=""  S:XVVSHC="HALT"!(XVVSHC="halt") XVVSHC="^"
 ;;;***
