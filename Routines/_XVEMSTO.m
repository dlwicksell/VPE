%XVEMSTO ;DJB,VSHL**Time Out - Screen Saver ; 1/24/09 10:51pm
 ;;12;VPE;**TOAD**;COPYRIGHT David Bolduc @1993
 ;
EN ;
 I $G(XVVSHL)'="RUN" W $C(7),!!?2,"This routine may only be run from the VShell.",! Q
 NEW XVVS D MARGIN
TOP ;Come here from VMS1
 N $ESTACK,$ETRAP S $ETRAP="D ERR^ZU Q:$QUIT -9 Q"
 NEW DOT,DOT1,FF,FLAGQ,I,PASSWORD,WHICH,X,XX,XX1,Y
 D INIT,INIT1,CUROFF
 S WHICH=1,FLAGQ=0
 F  D @("TYPE"_WHICH) Q:FLAGQ  S WHICH=WHICH+1 S:WHICH>4 WHICH=1
EX ;Exit
 D CURSOR X FF,XVVS("RM80")
 I $D(^%ZOSF("BRK")) X ^("BRK") ;Reenable Ctrl C
 Q
TYPE1 ;Top to Bottom
 F Y=1:1:XVV("IOSL") Q:FLAGQ  F X=1:1:XVV("IOM") D DRAW Q:FLAGQ
 D DOTSET
 Q
TYPE2 ;Left to Right
 F X=1:1:XVV("IOM") Q:FLAGQ  F Y=1:1:XVV("IOSL") D DRAW Q:FLAGQ
 D DOTSET
 Q
TYPE3 ;Bottom to Top
 F Y=XVV("IOSL"):-1:0 Q:FLAGQ  F X=XVV("IOM"):-1:0 D DRAW Q:FLAGQ
 D DOTSET
 Q
TYPE4 ;Right to Left
 F X=XVV("IOM"):-1:0 Q:FLAGQ  F Y=XVV("IOSL"):-1:0 D DRAW Q:FLAGQ
 D DOTSET
 Q
DRAW ;
 R XX#1:0 I $T S FLAGQ=1 Q
 W $C(27)_"["_Y_";"_X_"H"
 ;Smiley face
 I Y=5!(Y=17)&(",19,21,59,61,"[(","_X_",")) W 0 Q
 I Y=5!(Y=17)&(",20,60,"[(","_X_",")) W " " Q
 I Y=6!(Y=18)&(",19,21,59,61,"[(","_X_",")) W " " Q
 I Y=6!(Y=18)&(",20,60,"[(","_X_",")) W ">" Q
 I Y=7!(Y=19)&(",21,61,"[(","_X_",")) W " " Q
 I Y=7!(Y=19)&(",19,59,"[(","_X_",")) W $S(DOT="_":"\",1:"/") Q
 I Y=7!(Y=19)&(",20,60,"[(","_X_",")) W $S(DOT="_":"/",1:"\") Q
 ;Box pattern
 I X<41,Y<13 W $S(X<15!(X>25):DOT,Y<4!(Y>9):DOT,1:DOT1) Q
 I X<41,Y>12 W $S(X<15!(X>25):DOT1,Y<16!(Y>21):DOT1,1:DOT) Q
 I X>40,Y<13 W $S(X<55!(X>65):DOT1,Y<4!(Y>9):DOT1,1:DOT) Q
 I X>40,Y>12 W $S(X<55!(X>65):DOT,Y<16!(Y>21):DOT,1:DOT1)
 Q
DOTSET ;Change DOT
 S DOT=$S(DOT="_":"|",1:"_"),DOT1=$S(DOT1="_":"|",1:"_")
 Q
CURSOR W $C(27)_"[?25h" Q  ;Cursor on
CUROFF W $C(27)_"[?25l" Q  ;Cursor off
ERROR ;Turn Cursor back on
 D CURSOR,ERRMSG^%XVEMKU1("'SCRN SAVER'"),PAUSE^%XVEMKU(2)
 Q
INIT ;Initialize variables
 S PASSWORD="++"
 I $D(^%ZOSF("NBRK")) X ^("NBRK") ;Disable 'Ctrl C'
 Q
INIT1 ;
 S DOT="_",DOT1="|",FF="F I=1:1:50 W !"
 X FF,XVVS("RM0")
 Q
MARGIN ;Adjust margin if Micronetics
 I XVV("OS")=8 S XVVS("RM0")="U $I:(0)",XVVS("RM80")="U $I:(80)"
 E  S (XVVS("RM0"),XVVS("RM80"))=""
 Q
VMS ;Drop to VMS to disable Control Y
 I $G(XVV("OS"))']"" W $C(7),!!?2,"This routine may only be run from the VShell.",! Q
 NEW %SPAWN S %SPAWN="@TIMEOUT.COM" D ^%SPAWN
 Q
VMS1 ;TIMEOUT.COM should call here
 NEW XVVS
 S (XVVS("RM0"),XVVS("RM80"))=""
 G TOP
BLANK ;Call here to blank the screen
 I $G(XVVSHL)'="RUN" W $C(7),!!?2,"This routine may only be run from the VShell.",! Q
 NEW I,PASSWORD,XX
 D INIT,CUROFF
 X XVV("EOFF") F I=1:1:50 W !
BLANK1 R XX#$L(PASSWORD) I XX=PASSWORD X XVV("EON") D CURSOR Q
 G BLANK1
 Q
