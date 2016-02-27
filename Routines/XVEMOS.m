XVEMOS ;DJB,VRROLD**Get Program [12/31/94]
 ;;7.0;VPE;;COPYRIGHT David Bolduc @1993
 ;
EN ;Enter here from ^XVEMO
 D HD,GETPGM G:FLAGQ EX D SETGLB
EX ;
 Q
GETPGM ;
 I $G(FLAGPRM)=1 S FLAGPRM="VRR",VRRPGM=%1 G GETPGM1
 NEW RTN
 S RTN=$G(^XVEMS("E","VRR",DUZ))
 ; Next: If RTN doesn't exist it shouldn't be the default routine
 I RTN]"",'$$EXIST^XVEMKU(RTN) S RTN="" KILL ^XVEMS("E","VRR",DUZ)
 I $G(XVVSHL)="RUN" D  G:VRRPGM?1"<".E1">" GETPGM G GETPGM1
 . S VRRPGM=$$CLHEDIT^XVEMSCL("VRR","Select ROUTINE: "_$S(RTN]"":RTN_"//",1:"")) S:VRRPGM="" VRRPGM=RTN S:VRRPGM=" " VRRPGM="^"
 W !?1,"Select ROUTINE: ",$S(RTN]"":RTN_"//",1:"")
 R VRRPGM:XVV("TIME") S:'$T!(VRRPGM=" ") VRRPGM="^" S:VRRPGM="" VRRPGM=RTN
GETPGM1 ;Come here when passing a parameter
 I "^"[VRRPGM S FLAGQ=1 Q
 S:VRRPGM["^" VRRPGM=$P(VRRPGM,"^",2) S:VRRPGM["(" VRRPGM=$P(VRRPGM,"(")
 I VRRPGM="?" D HELP G GETPGM
 I VRRPGM="??" D LIST KILL ^UTILITY($J) W ! G GETPGM
 I VRRPGM'?.1"%"1A.7AN D MSG1 G GETPGM
 I $D(^XVEMS("E")) S ^XVEMS("E","VRR",DUZ)=VRRPGM
 ;Next line checks to see if anyone else is editing this routine.
 I $G(FLAGVPE)["EDIT",VRRS=1 L ^XVEMS("E","LOCK",VRRPGM):0 I '$T D  S FLAGQ=1
 . W $C(7),!!?5,"This program is currently being edited. Try later.",!
 Q
LIST ;List routines
 KILL ^UTILITY($J)
 D @$S($D(^%ZOSF("RSEL")):"ZOSF^XVEMOSS",1:XVV("OS")_"^XVEMOSS") Q:$O(^UTILITY($J,""))=""
LIST1 R !!?1,"Select [B]lock or [L]ist: L// ",XVVX:XVV("TIME") S:'$T XVVX="^" S:XVVX="" XVVX="L" I XVVX="^" Q
 I XVVX="?" W "   Enter 'B' or 'L'" G LIST1
 I ",B,b,L,l,"'[(","_XVVX_",") W $C(7),"   ??" G LIST1
 S XVVX=$S(XVVX="b":"B",XVVX="l":"L",1:XVVX)
 D @$S(XVVX="B":"LISTB",XVVX="L":"LISTL",1:"")
 Q
LISTB ;Block list of programs, 8 to a line, 5 lines at a time
 NEW CNT,COL,FLAGQ,I,X
 S (CNT,FLAGQ,X,XX)=0,COL=1 W !
 F I=1:1 S X=$O(^UTILITY($J,X)) Q:X=""  W:COL=1 ! W ?COL,X S COL=COL+10 I COL>75 D  Q:FLAGQ
 . S COL=1,CNT=CNT+1 I CNT#5=0 D PAUSEQ^XVEMKC(2) W !
 D:I=1 MSG1 W:I>1 !
 Q
LISTL ;List top line of selected programs
 NEW CNT,FLAGQ,RTN
 S (FLAGQ,RTN)=0 W @XVV("IOF")
 F CNT=1:1 S RTN=$O(^UTILITY($J,RTN)) Q:RTN=""  D  Q:FLAGQ
 . W !,$J(CNT,3),". ",RTN,?14,$E($P($T(^@RTN)," ",2,99),1,65)
 . I $Y>XVVSIZE D PAUSEQ^XVEMKC(2) Q:FLAGQ  W @XVV("IOF"),!
 Q
SETGLB ;Put routine into global
 NEW I,TXT,X KILL ^TMP("XVV","VRR",$J,VRRS)
 I $G(XVVSHL)="RUN" D CLHSET^XVEMSCL("VRR",VRRPGM) ;Cmnd Line History
 S X=VRRPGM,^TMP("XVV","VRR",$J,VRRS,"NAME")=VRRPGM
 I '$$EXIST^XVEMKU(X) S VRRHIGH=0 Q
 X "ZL @VRRPGM F I=1:1 S TXT=$T(+I) Q:TXT=""""  S TXT=$P(TXT,"" "")_$C(9)_$P(TXT,"" "",2,999),^TMP(""XVV"",""VRR"",$J,VRRS,""TXT"",I)=TXT"
 S VRRHIGH=I-1
 S ^TMP("XVV","VRR",$J,VRRS,"HOT")=VRRHIGH
 Q
MSG ;Messages
MSG1 W $C(7),!?1,"Invalid Program" Q
HELP ;Help text
 W !!?5,"Enter a routine name, or <RETURN> to select default routine."
 W !?5,"Enter '??' to display routine names in one of the following forms:"
 W !!?10,"BLOCK.....Routines listed 8 to a line, 5 lines at a time."
 W !?10,"LIST......Lists top line of each selected routine.",!
 Q
HD ;Heading
 Q:$G(%1)]""  ;Don't display heading when parameter passing
 Q:VRRS>1  ;Don't display heading when branching to another program
 W !?1,"Victory Routine ",$S($G(FLAGVPE)["EDIT":"Editor",1:"Reader")," . . . . . . . . . . . . . . . . . . . . . David Bolduc"
 W !?1,"^=Quit   <RETURN>=DefaultRtn   ?=Help   ??=RtnList",!
 Q
