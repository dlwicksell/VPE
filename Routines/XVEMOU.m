XVEMOU ;DJB,VRROLD**GETLINE,SCREEN,FF,HOT ; 12/15/00 8:31pm
 ;;13.0;VICTORY PROG ENVIRONMENT;;Feb 29, 2016
 ;
GETLINE(PROMPT) ;;Extrinsic Function to return line number
 ;;Returns: ^,?,M,"INVALID","INVALID RNG",Line number or range.
 NEW LN,X1,X2
 W ?1,PROMPT
 S LN=$$READ^XVEMKR()
 S:LN']"" LN=$G(XVV("K"))
 S:",<TO>,<RET>,<ESC>,^,"[(","_LN_",") LN="^"
 I "^"[LN Q LN
 I LN="<TAB>" S LN=$G(VRRCRSR) I LN']"" S LN="^" Q LN
 I $E(LN)="?" S LN="?" Q LN
 I "mk,MK"[LN S LN="MK" Q LN
 I LN="ALL"!(LN="all") S LN="2-"_VRRHIGH
 I LN["-" D  Q LN
 . I LN'?1.N1"-"1.N S LN="INVALID RNG" Q
 . S X1=$P(LN,"-")
 . S X2=$P(LN,"-",2)
 . S:X2>VRRHIGH X2=VRRHIGH
 . I X1'?1.N!(X1<1)!(X1>X2)!(X2'?1.N) S LN="INVALID RNG" Q
 . S LN=X1_"-"_X2
 ;
 I PROMPT["INSERT AFTER LINE NUMBER"!(PROMPT["UNSAVE AFTER LINE NUMBER"),LN=0 Q LN
 I LN'?1.N!(LN<1)!(LN>VRRHIGH) S LN="INVALID"
 Q LN
 ;====================================================================
RUN(RTN) ;Run RTN, reset RM0
 Q:$G(RTN)']""
 X XVVS("RM80") D @RTN X XVVS("RM0")
 Q
 ;====================================================================
FF ;Set up top part of display
 Q:FLAGL
 S FLAGBLNK=1 ;FLAGBLNK=Surpress highlight on blank screen
 NEW DX,DY
 W @XVV("IOF")
 S DX=9,DY=0 X XVVS("CRSR")
 W "Routine "_VRRS_" of 4: ^"_VRRPGM_"    Lines: "_VRRHIGH
 I $G(FLAGHOT)="YES" D  W "HOT KEY ACTIVE",@XVV("ROFF")
 . S DX=64 X XVVS("CRSR")
 . W @XVV("RON") X XVVS("XY")
 W !,$E(VRRLINE,1,XVV("IOM"))
 Q
 ;====================================================================
BOTTOM ;Set up bottom part of display
 S DX=0,DY=21 X XVVS("CRSR")
 W @XVVS("BLANK_C_EOS")
 X XVVS("XY")
 Q
 ;
BOTTOM1 ;Set up bottom part of display, preserving one line of text
 S DX=0,DY=22 X XVVS("CRSR")
 W @XVVS("BLANK_C_EOS")
 X XVVS("XY")
 Q
 ;
BOTTOM2 ;Don't redraw menu line at bottom of screen
 S DX=0,DY=22 X XVVS("CRSR")
 W ?1,"Select: "
 Q
 ;====================================================================
HOT ;Hot key to switch between routines
 NEW TEMP S TEMP=VRRS
 NEW FLAGBLNK,FLAGCOL,FLAGHOT,FLAGL,FLAGQ,FLAGTAG
 NEW BOTTOM,END,END1,I,LNUM,PGTOP,START,STNG,TAG
 NEW CODE,CODELN,CODETG,DX,DY
 NEW VRRACT,VRRCRSR,VRRHIGH,VRRLN,VRRMARK,VRRPGM,VRRS
 S FLAGHOT="YES"
 S (FLAGCOL,FLAGQ)=0
 S VRRSP=1
 D HOTRTN Q:FLAGQ
 S VRRHIGH=$P(^TMP("XVV","VRR",$J,VRRS,"HOT"),"^",1)
 S VRRPGM=^("NAME")
 S (PGTOP,START)=$S($P(^("HOT"),"^",2)]"":$P(^("HOT"),"^",2),1:1)
 S TEMP=VRRS
 D TOP^XVEMO
 Q:'$D(^TMP("XVV","VRR",$J,TEMP,"HOT"))
 S $P(^("HOT"),"^",2)=$G(PGTOP)
 Q
 ;
HOTRTN ;Get Routine
 NEW I,X
 I '$D(^TMP("XVV","VRR",$J,2,"HOT")) D  Q  ;Hasn't branched yet
 . W $C(7),"   You haven't branched to any routines yet.."
 . S FLAGQ=1
 . D PAUSE^XVEMKU(1)
 S X=""
 F  S X=$O(^TMP("XVV","VRR",$J,X)) Q:X=""  D
 . Q:X=TEMP
 . Q:'$D(^TMP("XVV","VRR",$J,X,"HOT"))
 . S TEMP(X)=""
 S X=""
 F I=1:1 S X=$O(TEMP(X)) Q:X=""
 I I=1 S FLAGQ=1 Q
 I I=2 S VRRS=$O(TEMP("")) Q
 W !!?2,"HOT KEY"
 W !?2,"Routine Select:"
 S X=""
 F I=1:1 S X=$O(TEMP(X)) Q:X=""  D
 . W ?19,X,". ",^TMP("XVV","VRR",$J,X,"NAME"),!
HOTRTN1 R !?2,"Select NUMBER: ",VRRS:300 S:'$T VRRS="^"
 I "^"[VRRS S FLAGQ=1 Q
 I '$D(TEMP(VRRS)) W "   Enter number of your choice." G HOTRTN1
 I VRRS=TEMP W $C(7),"   You're already in this routine.." G HOTRTN1
 Q
