%XVEMSHY ;DJB,VSHL**Help Text Menu Init [11/12/95 8:57am]
 ;;12;VPE;;COPYRIGHT David Bolduc @1993
 ;
HD ;Heading
 NEW MAR
 S MAR=$G(XVV("IOM")) S:MAR'>0 MAR=80
 W @XVV("IOF") S DX=1,DY=22 X XVVS("CRSR") W @XVV("RON")
 W !," <ESC><ESC>,'^'=Quit    HIGHLIGHT<RET>,Enter Name=Select Menu Option",?(MAR-1),@XVV("ROFF")
 S DX=0,DY=0 X XVVS("CRSR") W @XVV("RON")
 W !?(MAR-$L(HD)/2),HD,?(MAR-1),@XVV("ROFF")
 Q
INIT ;Initialize variables
 I '$D(XVV("OS")) D OS^%XVEMKY Q:FLAGQ
 D IO^%XVEMKY,SCRNVAR^%XVEMKY2,REVVID^%XVEMKY2,BLANK^%XVEMKY3
 S (COL,CNT)=1
 S PROMPT="S DX=8,DY=21 X XVVS(""CRSR"") W ""SELECT: "",@XVVS(""BLANK_C_EOL"")"
 S SET="S DX=$P(TXT,"";"",7),DY=$P(TXT,"";"",8),TXT=$P(TXT,"";"",4)"
 S WRITE="X XVVS(""CRSR"") W "" ""_TXT_$E(SPACES,1,WIDTH-$L(TXT))"
 S LAST=0 F I=1:1 Q:$P(COLUMNS,"^",I)'>0  S COL(I)=$P(COLUMNS,"^",I),LAST=LAST+COL(I)
 S COLCNT=I-1,$P(SPACES," ",XVV("IOM"))=""
 Q
