%XVEMOY ;DJB,VRROLD**Init,Branching,Error ; 9/6/02 8:15am
 ;;7.0;VPE;COPYRIGHT David Bolduc @1993
 ;
INIT ;Initialize variables
 S VRRS=$S($G(VRRS)="":1,1:(VRRS+1)) ;VRRS=# of prgrms you are viewing
 S (PGTOP,START,VRRSP)=1 ;VRRSP sets single spacing as default
 D INIT^%XVEMKY
 S $P(VRRLINE,"=",212)="",VRRLINE="|"_$E(VRRLINE,2,8)_"|"_$E(VRRLINE,10,(XVV("IOM")-1))_"|"
 Q:$G(FLAGVPE)["VRR"
 I $D(XVV("OS"))#2=0 D OS^%XVEMKY Q:FLAGQ
 I $D(XVV("TRMON"))#2=0 D TRMREAD^%XVEMKY1
 D REVVID^%XVEMKY2
 D BS^%XVEMKY1
 D SCRNVAR^%XVEMKY2
 D BLANK^%XVEMKY3
 Q
VGL ;Run the VGlobal Lister
 I $G(VRRS)>2 D  D PAUSE^%XVEMKC(1) Q
 . W $C(7),!?1,"You can't call VGL if you've branched to more than 2 programs."
 I $G(DUZ(0))'["@",$G(DUZ(0))'["#" D  D PAUSE^%XVEMKC(1) Q
 . W $C(7),!?1,"You don't have access. See Help option."
 I '$$EXIST^%XVEMKU("%XVEMG") D  D PAUSE^%XVEMKC(1) Q
 . W $C(7),!?1,"You don't have the 'VGlobal Lister' Routines."
 D SYMTAB^%XVEMKST("C","VRR",VRRS) ;Clear symbol table
 D RUN^%XVEMOU("^%XVEMG")
 D SYMTAB^%XVEMKST("R","VRR",VRRS) ;Restore symbol table
 Q
VEDD ;Call VEDD, VElectronic Data Dictionary
 I $G(VRRS)>2 D  D PAUSE^%XVEMKC(1) Q
 . W $C(7),!?1,"You can't call VEDD if you've branched to more than 2 programs."
 I '$$EXIST^%XVEMKU("%XVEMD") D  D PAUSE^%XVEMKC(1) Q
 . W $C(7),!?1,"You don't have the 'VElectronic Data Dictionary' Routines."
 D SYMTAB^%XVEMKST("C","VRR",VRRS) ;Clear symbol table
 D RUN^%XVEMOU("DIR^%XVEMD")
 D SYMTAB^%XVEMKST("R","VRR",VRRS) ;Restore symbol table
 Q
RSE ;Search Routine for string(s)
 I $G(VRRS)>2 D  D PAUSE^%XVEMKC(1) Q
 . W $C(7),!?1,"You can't do Routine Search if you've branched to more than 2 programs."
 D ^%XVEMOSS
 Q
ERROR ;Error trap.
 NEW ZE
 S @("ZE="_XVV("$ZE"))
 I $G(VRRS)>0 D
 . I $G(FLAGVPE)'["EDIT"!(VRRS>1) KILL ^TMP("XVV","VRR",$J,VRRS)
 S FLAGQ=1 I ZE["<INRPT>" W !!?1,"....Interrupted.",!! Q
 D ERRMSG^%XVEMKU1("VRR"),PAUSE^%XVEMKU(2)
 S VRRS=VRRS-1 Q:VRRS  X XVVS("RM80")
 KILL:$G(FLAGVPE)'["EDIT" ^TMP("XVV","VRR",$J)
 Q
