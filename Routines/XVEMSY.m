XVEMSY ;DJB,VSHL**Init,Error ; 4/6/03 8:25am
 ;;12;VPE;;COPYRIGHT David Bolduc @1993
 ;
INIT ;Initialize variables
 NEW XVVSIZE,X,Y
 I $D(XQY0),$P(XQY0,"^",1)'["VSHELL" D XQY0MSG^XVEMSY1 I $D(XQY0) S FLAGQ=1 G EX
 D  I FLAGQ=1 W $C(7),!!?3,"*** VSHELL CURRENTLY ACTIVE ***",! G EX
 . I $G(XVVSHL)="RUN" S FLAGQ=1 Q
 . I $D(XQY0),$G(^XVEMS("%",$J_$G(^XVEMS("SY")),"SHL"))="RUN" S FLAGQ=1
 KILL ^XVEMS("%",$J_$G(^XVEMS("SY")))
 S ^XVEMS("%",$J_$G(^XVEMS("SY")),"SHL")="RUN"
 D KERNSAVE^XVEMSU ;Support for VA KERNEL
 I $G(XVV("ID"))'>0 D SETID G:FLAGQ EX
 D IO^XVEMKY
 D CLH^XVEMSY1,OS^XVEMKY G:FLAGQ EX
 D BS^XVEMKY1
 D ZE^XVEMKY1
 D TRMREAD^XVEMKY1
 D ECHO^XVEMKY1
 D HD^XVEMSY1
 D DTM^XVEMKY2
 I $D(^XVEMS("%",$J_$G(^XVEMS("SY")),"KRNUCI")) D BRK^XVEMKY2 ;Enable Ctrl C if VShell is a VA KERNEL menu option.
 D AUDIT^XVEMSY1 Q:FLAGQ
EX ;
 Q
SETID ;Set XVV("ID") variable
 I $D(^XUSEC(0)) D KERN Q
 D GETID
 Q
KERN ;Get ID using VA KERNEL
 I $G(DUZ)'>0 D  D ^XUP I $G(DUZ)'>0 S FLAGQ=1 Q
 . W !!,"------------------------------------------"
 . W !,"Your DUZ isn't defined. I'm calling ^XUP."
 . W !,"------------------------------------------",!
 S FLAGQ=0 I '$D(^%ZOSF("UCI")) D GETID Q
 NEW XVVUCI X ^%ZOSF("UCI") S XVVUCI=Y
 I $D(^XVEMS("ID","DUZ",DUZ,XVVUCI)) D  Q
 . S XVV("ID")=$O(^XVEMS("ID","DUZ",DUZ,XVVUCI,""))
 . S ^XVEMS("ID","DUZ",DUZ,XVVUCI,XVV("ID"))=$H
 . S ^XVEMS("ID","SHL",XVV("ID"),XVVUCI,DUZ)=$H
 D KGETID Q:FLAGQ
 S ^XVEMS("ID","DUZ",DUZ,XVVUCI,XVV("ID"))=$H
 S ^XVEMS("ID","SHL",XVV("ID"),XVVUCI,DUZ)=$H
 Q
KGETID ;Get ID when using VA KERNEL
 NEW DEF,ID
 D IDMSG^XVEMSY1,DISCLAIM^XVEMKU1
 S DEF=$G(DUZ)
KGETID1 W !,"Enter ID Number: " I DEF W DEF_"// "
 R ID:600 S:'$T ID="^" S:ID="" ID=DEF
 I "^"[ID S FLAGQ=1 Q
 I +ID'=ID!(ID<.1)!(ID>999999) D IDHELP^XVEMSY1 G KGETID1
 I $D(^XVEMS("ID","SHL",ID,XVVUCI)) D  G KGETID1
 . W $C(7),"   This ID is already in use."
 S XVV("ID")=ID
 Q
GETID ;Get ID not using VA KERNEL
 NEW ID
 D IDMSG^XVEMSY1,DISCLAIM^XVEMKU1
GETID1 W !,"Enter ID Number: "
 R ID:600 S:'$T ID="^" I "^"[ID S FLAGQ=1 Q
 I +ID'=ID!(ID<.1)!(ID>999999) D IDHELP^XVEMSY1 G GETID1
 S XVV("ID")=ID
 Q
T() ;Set error trap. Called by ^XVEMS("ZA",1)
 KILL %1
 I $D(X)#2 S %1=X
 S X="ERROR^XVEMSY"
 I $D(^%ZOSF("TRAP")) Q ^("TRAP")
 Q "$ZT=X"
 ;
RESET ;Reset $T and Naked Reference
 NEW FLAGQ
 S XVV("$T")=$T
 I '$G(XVV("OS")) D OS^XVEMKY
 Q:'$G(XVV("OS"))
 I XVV("OS")=17!(XVV("OS")=19) D  I 1 ;GTM Mumps
 . X "I $R'[""^XVEMS"",$R'[""^TMP(""""XVV"""""" S XVV(""$ZR"")=$R"
 E  D  ;Non-GTM Mumps
 . X "I $ZR'[""^XVEMS"",$ZR'[""^TMP(""""XVV"""""" S XVV(""$ZR"")=$ZR"
 Q
 ;
ERROR ;Error trap.
 NEW ERROR,ZE
 S XVV("$T")=$T
 S @("ZE="_XVV("$ZE"))
 ;
 ;Stop error loops from occurring. If same error occurrs less than a
 ;second apart, quit VPE Shell.
 S ERROR=$G(^XVEMS("ERROR",XVV("ID")))
 I ERROR]"",ZE=$P(ERROR,"^",3),$P($H,",",1)=$P(ERROR,"^",1),$P($H,",",2)-$P(ERROR,"^",2)=0 D  Q
 . S XVVSHC="^" ;Stop Shell
 . W !,"-------------------------------------------------------------"
 . W !,"The VPE Shell detected an error loop and shut itself down."
 . W !,"An error loop is the same error occurring twice for the same"
 . W !,"person, less than a second apart."
 . W !,"-------------------------------------------------------------"
 . W !
 S ^XVEMS("ERROR",XVV("ID"))=$P($H,",",1)_"^"_$P($H,",",2)_"^"_ZE
 ;
 I XVV("OS")=17!(XVV("OS")=19) D  I 1 ;GTM Mumps
 . X "I $R'[""^XVEMS"",$R'[""^TMP(""""XVV"""""" S XVV(""$ZR"")=$R"
 . X "I $R[""^%ZOSF(""""UCI"""")"" S XVV(""$ZR"")="""""
 E  D  ;Non-GTM Mumps
 . X "I $ZR'[""^XVEMS"",$ZR'[""^TMP(""""XVV"""""" S XVV(""$ZR"")=$ZR"
 . X "I $ZR[""^%ZOSF(""""UCI"""")"" S XVV(""$ZR"")="""""
 I ZE["PROT" S XVV("$ZR")="" ;Prevents repetitive <PROT> errors
 I ZE["NOSYS" S XVV("$ZR")="" ;Prevents repetitive <NOSYS> errors
 S XVV("$ZR")=$G(XVV("$ZR"))
 D USEZERO^XVEMSU
 I $D(XVV("TRMOFF")) X XVV("TRMOFF")
 I $D(XVV("EON")) X XVV("EON")
 W !!,"VPE Error Trap"
 W !,"Last Global: ",XVV("$ZR")
 W !,"ERROR: ",ZE,!
 I $G(IO)>0,$G(XVV("IO"))>0,IO'=XVV("IO") D  D PAUSE^XVEMKU(2)
 . W $C(7),!!,"---------> VSHELL ALERT!"
 . W !!,"Your IO device isn't what VShell thinks it should be. D ^%ZISC to"
 . W !,"restore your IO variables to match your login device.",!
 NEW I F I=1:1:9 KILL @("%"_I) ;Clean up parameter variables
 Q
 ;I stopped using following code. In OpenM, it caused Shell to Halt.
 ;Next, see if ^%ZOSF("VOL") has been deleted or changed.
 I '$D(^XVEMS("%",$J_$G(^XVEMS("SY")))) D  Q
 . W $C(7),!!,"W A R N I N G ! !"
 . W !!,"^%ZOSF(""VOL"") may have been alterred. This node must"
 . W !,"be set correctly for VShell to work."
 . S XVVSHC="^" D PAUSE^XVEMKU(2)
 Q
