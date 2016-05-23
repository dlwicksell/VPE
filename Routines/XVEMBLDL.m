XVEMBLDL ;DJB,VSHL**VPE Setup - Load Editor & Shell ; 2/29/16 9:21am
 ;;13.1;VICTORY PROG ENVIRONMENT;;May 23, 2016
 ;
TOP ;
 D SHELL
 I FLAGQ D  G EX
 . W !!,"VPE Shell global not loaded."
 W !!,"VPE Programmer Shell successfully loaded."
 W !,"Initialization finished."
 W !!,"NOTE: To start the VPE Shell, type:  D ^XV"
 R !!,"<RETURN> to continue..",XX:300
 D DISCLAIM^XVEMKU1
EX ;
 Q
 ;===================================================================
SHELL ;Load VPE Shell Global - ^XVEMS
 S FLAGQ=0
 D YESNO^XVEMBLD("Load VPE Shell global: YES// ")
 Q:FLAGQ
 D ALL^XVEMSG
 Q
 ;
