XVEMBLDL ;DJB,VSHL**VPE Setup - Load Editor & Shell ; 9/7/02 2:06pm
 ;;12;VPE;;COPYRIGHT David Bolduc @1993
 ;
TOP ;
 D SHELL
 I FLAGQ D  G EX
 . W !!,"VPE Shell global not loaded."
 D EDITOR
 W !!,"VPE Programmer Shell successfully loaded."
 W !,"VPE full screen routine editor successfully loaded."
 W !,"Initialization finished."
 W !!,"NOTE: To start the VPE Shell, type:  X ^XVEMS"
 R !!,"<RETURN> to continue..",XX:300
 D DISCLAIM^XVEMKU1
EX ;
 Q
 ;===================================================================
SHELL ;Load VPE Shell Global - ^XVEMS
 S FLAGQ=0
 ;W !!?2,"S T E P   2",!
 D YESNO^XVEMBLD("Load VPE Shell global: YES// ")
 Q:FLAGQ
 D ALL^XVEMSG
 Q
 ;
EDITOR ;Load Editor into ^XVEMS("E") global
 NEW CODE,I,TXT
 ;S FLAGQ=0
 ;W !!?2,"S T E P   1",!
 ;D YESNO^XVEMBLD("Install 'VPE Routine Editor': YES// ")
 ;Q:FLAGQ
EDITOR1 ;
 S TXT=$T(CODE+1)
 S CODE=$P(TXT,";",3,99)
 KILL ^XVEMS("E")
 S ^XVEMS("E")=CODE
 F I=2:1 S TXT=$T(CODE+I) Q:$P(TXT,";",3)="***"  S CODE=$P(TXT,";",3,99),^XVEMS("E",I-1)=CODE
 Q
 ;
CODE ;Global for Rtn editing
 ;;X ^XVEMS("E",3) Q:$G(DUZ)=""  NEW FLAGSAVE,FLAGVPE,XVVS NEW:$G(XVV("OS"))']"" XVV X ^XVEMS("E",4) Q:'$D(^TMP("XVV","VRR",$J))  X ^XVEMS("E",1) KILL ^UTILITY($J) L
 ;;NEW %Y,VRRPGM,X D SAVE^XVEMRC(1) Q:$G(VRRPGM)']""  X ^XVEMS("E",2)
 ;;NEW X S X=VRRPGM X XVVS("ZS"),^XVEMS("E",5)
 ;;Q:$G(DUZ)>0  S ^TMP("XVV",$J,1)=$G(%1),^(2)=$G(%2) D ID^XVEMKU S:$G(XVVSHL)="RUN" %1=^TMP("XVV",$J,1),%2=^(2) KILL ^TMP("XVV",$J)
 ;;S $P(FLAGVPE,"^",4)="EDIT" D PARAM^XVEMR($G(%1),$G(%2))
 ;;Q:XVV("OS")'=17&(XVV("OS")'=19)  NEW LINK,PGM S PGM=VRRPGM,PGM=$TR(PGM,"%","_") S LINK="ZLINK """_PGM_"""" X LINK
 ;;***
