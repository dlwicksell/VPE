XV ; Paideia/SMH,TOAD - Entry point for VPE ; 6/18/16 12:53pm
 ;;13.1;VICTORY PROG ENVIRONMENT;;May 23, 2016
 ;;XV;
 ; Original VPE by David Buldoc
 ; Refactored VPE by David Wicksell and Sam Habiel
 ;
 N FLAGQ S FLAGQ=0 ;quit flag
 ;
 ; Temporary Error Trap when setting up VPE
 N $ETRAP S $ETRAP="W ""Error Occurred during Set-up."",! G ERROR^XVEMSY"
 ;
 I $D(XVSIMERR) S $EC=",U-SIM-ERROR," ; Simulated Error for testing
 ;
 N XVV  ; stores VPE settings in subscripts; see XVSS
 ;
NOUSER ; Ask for DUZ if not there
 I '$G(DUZ) S DUZ=0 D
 . I ($D(^DD))&($D(^DIC)) D
 . . D DT^DICRW
 . . S DIC="^VA(200,",DIC(0)="QEAZ",D="B" 
 . . D IX^DIC
 . . S DUZ=$P(Y,"^")
DUZ I DUZ'>0 R !,"Please enter your DUZ: ",DUZ
 I DUZ'>0 W !,"You need to enter your DUZ." G DUZ
 I ('$D(U))!('$D(DTIME))!('$D(DT)) D
 . ;Set up VPE environment if FM is installed or a minimal environment if not
 . I ($D(^DD))&($D(^DIC)) D DT^DICRW
 . I ('$D(^DD))!('$D(^DIC)) S U="^",DTIME=9999,DT=3160000
 D ^XVEMSY ; init lots of stuff
 ;
 Q:FLAGQ
 KILL FLAGQ
 ;
BLD ; Build ^XVEMS if it doesn't exist
 I '$D(^XVEMS("QS")) D ^XVEMBLD
 I '$D(^XVEMS("QS")) W !!,"VPE Quiks and Help are not loaded",! QUIT
 ;
FM ; Build VPE Fileman Files
 I $D(^DD),'$D(^DD(19200.11)) D ^XVVMINIT
 ;
RUN ; Run VPE
 D ^XVSS ; Save symbol table, init XVV
 N XVVSHC S XVVSHC="" ; Shell input
 N XVVSHL S XVVSHL="RUN" ; Shell state
 D ^XVSA ; main loop
 I XVVSHC=U D ^XVSK ; kill temp space when user halts out
 W !
 QUIT  ; <--- XV
