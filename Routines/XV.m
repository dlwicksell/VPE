XV ; Paideia/SMH,TOAD - Entry point for VPE ; 3/1/16 10:06am
 ;;13.0;VICTORY PROG ENVIRONMENT;;Feb 29, 2016
 ;;XV;
 ; Original VPE by David Buldoc
 N FLAGQ S FLAGQ=0 ;quit flag
 N $ESTACK,$ETRAP S $ETRAP="D ERR^ZU Q:$QUIT -9 Q"
 N XVV  ; stores VPE settings in subscripts; see XVSS
NOUSER I '$D(DUZ) D
 . I ($D(^DD))&($D(^DIC)) D
 . . S DIC="^VA(200,",DIC(0)="QEAZ",D="B" 
 . . D IX^DIC
 . . S DUZ=$P(Y,"^")
DUZ I ($G(DUZ)']"")!($G(DUZ)="-1")  R !,"Please enter your DUZ: ",DUZ
 I $G(DUZ)']"" W !,"You need to enter your DUZ." G DUZ
 I ('$D(U))!('$D(DTIME))!('$D(DT)) D
 . ;Set up VPE environment if FM is installed or a minimal environment if not
 . I ($D(^DD))&($D(^DIC)) D ^XVUP
 . I ('$D(^DD))!('$D(^DIC)) S U="^",DTIME=9999,DT=$$DT^XLFDT
 D ^XVEMSY ; init lots of stuff
 Q:FLAGQ
 KILL FLAGQ
BLD ; Build ^XVEMS if it doesn't exist
 I '$D(^XVEMS("QS")) D ^XVEMBLD
 I '$D(^XVEMS("QS")) W !!,"VPE Quiks and Help are not loaded",! QUIT
 ;
RUN ; Run VPE
 D ^XVSS ; Save symbol table, init XVV
 N XVVSHC S XVVSHC="" ; Shell input
 N XVVSHL S XVVSHL="RUN" ; Shell state
 D ^XVSA ; main loop
 I XVVSHC=U D ^XVSK ; kill temp space when user halts out
 W !
 QUIT  ; <--- XV
 ;
 ; Unused code
 ; F  D  Q:XVVSHC'="NO EXIT"
 ; . ; X ^XVEMS("ZA",1) //smh
 ; . D ^XVSA ; main loop
 ; . I $G(XVVSHC)=U D ^XVSK ; kill temp space when "^"
