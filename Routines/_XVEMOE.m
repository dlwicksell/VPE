%XVEMOE ;DJB,VRROLD**INSERT,DELETE,CHANGE [12/31/94]
 ;;7.0;VPE;;COPYRIGHT David Bolduc @1993
 ;
DELETE ;Delete a line
 NEW VRRLN,I,II,X1,X2 D BOTTOM^%XVEMOU
DELETEA S VRRLN=$$GETLINE^%XVEMOU("DELETE WHICH LINE NUMBER(S): ") Q:VRRLN="^"
DELETEB I VRRLN=1 W $C(7) Q
 I VRRLN="?"!(VRRLN="INVALID") D MSG2^%XVEMOUM(12) G DELETEA
 I VRRLN="INVALID RNG" D MSG2^%XVEMOUM(13) G DELETEA
 S (X1,X2)=VRRLN I VRRLN["-" S X1=$P(VRRLN,"-"),X2=$P(VRRLN,"-",2),VRRLN=X1
 F I=X1:1:X2 D
 . F II=VRRLN:1:(VRRHIGH-1) S ^TMP("XVV","VRR",$J,VRRS,"TXT",II)=^TMP("XVV","VRR",$J,VRRS,"TXT",(II+1))
 . KILL ^TMP("XVV","VRR",$J,VRRS,"TXT",VRRHIGH) S VRRHIGH=VRRHIGH-1,FLAGSAVE=1
 . S $P(^TMP("XVV","VRR",$J,VRRS,"HOT"),"^",1)=VRRHIGH
 Q
 ;====================================================================
INSERT ;Insert line of code
 NEW VRRLN,CD
 D BOTTOM^%XVEMOU
INSERTA S VRRLN=$$GETLINE^%XVEMOU("INSERT AFTER LINE NUMBER: ") Q:VRRLN="^"
 I VRRLN'?1.N D MSG2^%XVEMOUM(14) G INSERTA
 D BOTTOM^%XVEMOU W ?1,"ENTER CODE:"
INSERT1 D BOTTOM1^%XVEMOU
INSERT2 R ?1,"*",CD:XVV("TIME") S:'$T CD="^" I "^"[CD Q
 I "??"[CD D MSGS^%XVEMOUM(15,1) G INSERT1
 I $$TAGCHK^%XVEMOEU(CD) Q
 I $$LINECHK^%XVEMOEU(CD) Q
 S VRRHIGH=VRRHIGH+1
 S $P(^TMP("XVV","VRR",$J,VRRS,"HOT"),"^",1)=VRRHIGH
 F I=VRRHIGH:-1:(VRRLN+2) S ^TMP("XVV","VRR",$J,VRRS,"TXT",I)=^TMP("XVV","VRR",$J,VRRS,"TXT",(I-1))
 S VRRLN=VRRLN+1 D SAVE^%XVEMOEU,KILLCHK^%XVEMKU(CD)
 W ! G INSERT2
 ;====================================================================
CHANGE ;Change a line
 NEW VRRLN D BOTTOM^%XVEMOU
CHANGE1 S VRRLN=$$GETLINE^%XVEMOU("CHANGE LINE NUMBER: ") G:VRRLN="^" EX
 I VRRLN'?1.N D MSGS^%XVEMOUM(3) G CHANGE1
CHANGE2 ;Entry point for ^%XVEMOM
 NEW CD,CDHLD,CHK,NEW,OLD,TAB,TEMP,TEMP1,VALID
 S (CD,CDHLD)=$G(^TMP("XVV","VRR",$J,VRRS,"TXT",VRRLN)) G:CD']"" EX
 I $G(^%XVEMS("E","EDIT",DUZ))'="LINE" D ^%XVEMOEA G EX ;Screen mode editor.
CHANGE3 D LINE^%XVEMKE("") G:CD=CDHLD EX
 S TEMP=$$TAGCHK^%XVEMOEU(CD) I TEMP S CD=CDHLD G CHANGE3
 S TEMP=$$LINECHK^%XVEMOEU(CD) I TEMP D:TEMP=2 DELLINE^%XVEMOEA G:TEMP=2 EX S CD=CDHLD G CHANGE3
 D SAVE^%XVEMOEU
EX ;Exit
 D KILLCHK^%XVEMKU(CD)
 Q
