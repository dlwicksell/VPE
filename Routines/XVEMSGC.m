XVEMSGC ;DJB,VSHL**VShell Global - ZA,ZC,ZO,ZQ ; 4/5/03 7:32am
 ;;12;VPE;;COPYRIGHT David Bolduc @1993
 ;
ZA ;;;Main area for processing users input at >> prompt.
 S @($$T^%XVEMSY) X ^%XVEMS("ZO",4),^%XVEMS("ZO",2) F  Q:'$D(^%XVEMS)  X ^%XVEMS("ZA",6) I $G(XVVSHC)]"" Q:XVVSHC="^"  W ! X ^%XVEMS("ZO",1),XVVSHC D RESET^%XVEMSY X ^%XVEMS("ZS",2)
 X ^%XVEMS("ZK",4),^%XVEMS("ZA",4) Q:"^"[XVVSHC  X:XVVSHC="<TO>" ^%XVEMS("ZT",1) Q:"^"[XVVSHC  X ^%XVEMS("ZS",4),$S(XVVSHC?1.2".":^%XVEMS("ZQ",1),XVVSHC?1.2"."1A.E:^%XVEMS("ZQ",1),1:^%XVEMS("ZA",3))
 I XVVSHC?1"<".E1">"!(XVVSHC?1.2"."1N.E) D ^%XVEMSQ S XVVSHC=$S(XVVSHC?1"**".E:$E(XVVSHC,3,999),1:"") I XVVSHC]"" X ^%XVEMS("ZA",2) ;CLH
 S:XVVSHC?.E1P1"XVVSHL".1P.E XVVSHC="" S:$E(XVVSHC)="?"!(XVVSHC="<ESCH>") XVVSHC="D ^%XVEMSH" I ",^,H,h,HALT,halt,"[(","_XVVSHC_",") S XVVSHC="^"
 X ^%XVEMS("ZS",3),^%XVEMS("ZA",7),^%XVEMS("ZO",2) KILL XVVWARN S XVVSHL="RUN" D USEZERO^%XVEMSU ;Reset variables
 X ^%XVEMS("ZA",5),^%XVEMS("ZR",1) Q:"^"[XVVSHC  X ^%XVEMS("ZA",2) Q:"^"[XVVSHC  X ^%XVEMS("ZC",1) KILL XVVWARN
 I $G(XVV("OS"))=8 X "ZM 0" ;Disable MSM trace function
 ;;;***
ZC ;;;Check for Global KILL
 Q:$G(XVVWARN)="QWIK"  NEW HLD X ^%XVEMS("ZQ",2) I HLD["K",HLD["^" NEW FLAGG S FLAGG="GLB" D KILLCHK^%XVEMKU(HLD)
 ;;;***
ZK ;;;Exit Shell-KILL ^%XVEMS("%"). VA KERNEL interface.
 X:'$D(XVV("ID"))!('$D(XVV("OS"))) ^%XVEMS("ZS",3) X ^%XVEMS("ZK",3) Q:$G(XVVSHC)="NO EXIT"  X ^%XVEMS("ZK",2),^%XVEMS("ZK",5),^%XVEMS("ZK",6),^%XVEMS("ZK",7),^%XVEMS("ZK",9)
 Q:'$D(^%XVEMS("%",$J_$G(^%XVEMS("SY")),"XUTL"))  KILL ^XUTL("XQ",$J) NEW %X,%Y S %X="^%XVEMS(""%"","""_$J_$G(^%XVEMS("SY"))_""",""XUTL"",",%Y="^XUTL(""XQ"",$J," D %XY^%RCR
 NEW U1,U2 X ^%XVEMS("ZK",8) I U1]"",U2]"",U1'=U2 S XVVSHC="NO EXIT" W $C(7),!!?2,"VA KERNEL menu option active.",!?2,"Move to UCI '",U2,"' to HALT.",!
 I $D(^XUSEC(0)),",D ^ZU,DO ^ZU,d ^zu,do ^zu,d ^ZU,do ^ZU,"[(","_XVVSHC_",") S XVVSHC="" W $C(7),!!?2,"HALT out of VSHELL before calling ^ZU.",!
 I XVV("OS")=9,$D(^%XVEMS("%",$J_$G(^%XVEMS("SY")),"DTM")) X "U $I:(IXXLATE=$P(^(""DTM""),""^"",1))"
 I $D(^%XVEMS("%",$J_$G(^%XVEMS("SY")),"KRNUCI")) D NOBRK^%XVEMKY2
 I $D(^%XVEMS("%",$J_$G(^%XVEMS("SY")),"SYMTAB")) D RESSYM^%XVEMSU ;Restore sym table
 S U1=$G(^%XVEMS("CLH","UCI",XVV("ID")_$G(^%XVEMS("SY")))),U2=$G(^%XVEMS("%",$J_$G(^%XVEMS("SY")),"KRNUCI"))
 KILL ^%XVEMS("%",$J_$G(^%XVEMS("SY")))
 ;;;***
ZO ;;;Other
 NEW X S:$G(XVV("$ZR"))]"" @("X=$"_$S(XVV("$ZR")["(":"O",1:"D")_"("_XVV("$ZR")_")") I $G(XVV("$T")) ;Reset $ZR and $T
 Q:'$D(XVV("ID"))  Q:'$D(^%ZOSF("UCI"))  NEW Y X ^("UCI") Q:$G(^%XVEMS("CLH","UCI",XVV("ID")_$G(^%XVEMS("SY"))))=Y  X ^%XVEMS("ZO",3)
 S ^%XVEMS("CLH","UCI",XVV("ID")_$G(^%XVEMS("SY")))=Y KILL ^%XVEMS("CLH",XVV("ID"),"VSHL") ;Kill VShell's CLH if user switches UCIs.
 S:$D(%1) X=%1 KILL:'$D(%1) X KILL %1 ;Reset X after ^%ZOSF("TRAP")
 ;;;***
ZQ ;;;Process QWIK Commands. XVVWARN turns off Global Kill Warning.
 NEW HLD S XVVWARN="QWIK" X ^%XVEMS("ZQ",2) D QWIK^%XVEMSQS(HLD)
 S HLD=$TR(XVVSHC,"abcdefghijklmnopqrstuvwxyz","ABCDEFGHIJKLMNOPQRSTUVWXYZ")
 ;;;***
