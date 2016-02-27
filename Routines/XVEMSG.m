XVEMSG ;DJB,VSHL**Global Loader ; 1/24/09 10:52pm
 ;;12;VPE;**TOAD**;**DLW**;COPYRIGHT David Bolduc @1993
 ;
 Q
ALL ;Load entire ^%XVEMS global and ^DD("OS",19,"ZS") to p directory
 NEW I,RTN,TAG,TXT
 D INIT
 S RTN="XVEMSGC" D DD,ENTRY,A,C,K,O,Q
 S RTN="XVEMSGD" D R,S,SY,T
 ;
 ;Build System QWIKs
 D ^XVEMSGS
 D ^XVEMSGT
 D ^XVEMSGU
 ;
 ;Load ZOSF nodes
 ;D ^XVEMSGR
 ;
 ;Load Help and other text
 D TEXT^XVEMSGH
 Q
 ;
DD ;Load ^DD("OS",19,"ZS") with GT.M in Linux fix for saving to the p directory
 S ^DD("OS",19,"ZS")="N %I,%F,%S S %I=$I,%F=$P($ZRO,"" "")_""/""_$TR(X,""%"",""_"")_"".m"" O %F:(NEWVERSION) U %F X ""S %S=0 F  S %S=$O(^UTILITY($J,0,%S)) Q:%S=""""""""  Q:'$D(^(%S))  S %=^UTILITY($J,0,%S) I $E(%)'="""";"""" W %,!"" C %F U %I"
 Q
 ;
ENTRY ;Load ^%XVEMS Global entry point
 S ^%XVEMS="NEW FLAGQ,XVV S FLAGQ=0 D ^%XVEMSY S:FLAGQ $ZT=""B"" Q:FLAGQ  KILL FLAGQ X ^%XVEMS(""ZS"",1) NEW XVVSHC,XVVSHL S XVVSHL=""RUN"" X ""F  X ^%XVEMS(""""ZA"""",1) I $G(XVVSHC)=""""^"""" X:$D(^%XVEMS(""""ZK"""",1)) ^(1) Q:XVVSHC'=""""NO EXIT"""""" S $ZT=""B"""
 Q
 ;
BUILD ;Build ^%XVEMS global
 W "."
 X "F I=1:1 S TXT=$T("_TAG_"+I^"_RTN_") Q:TXT']""""  S TXT=$P(TXT,"" "",2,999) Q:TXT="";;;***""  S ^%XVEMS("""_TAG_""",I)=TXT"
 Q
 ;
A ;
 KILL ^%XVEMS("ZA")
 S ^%XVEMS("ZA")="Main Section"
 S TAG="ZA" D BUILD
 Q
 ;
C ;
 KILL ^%XVEMS("ZC")
 S ^%XVEMS("ZC")="Check for global KILL"
 S TAG="ZC" D BUILD
 Q
 ;
K ;
 KILL ^%XVEMS("ZK")
 S ^%XVEMS("ZK")="Kill ^%XVEMS(""%"") on exit, VA KERNEL interface"
 S TAG="ZK" D BUILD
 Q
 ;
O ;
 KILL ^%XVEMS("ZO")
 S ^%XVEMS("ZO")="Other"
 S TAG="ZO" D BUILD
 Q
 ;
Q ;
 KILL ^%XVEMS("ZQ")
 S ^%XVEMS("ZQ")="Process QWIKs. XVVWARN turns off glb kill warning."
 S TAG="ZQ" D BUILD
 Q
 ;
R ;
 KILL ^%XVEMS("ZR")
 S ^%XVEMS("ZR")="Single Character READ"
 S TAG="ZR" D BUILD
 Q
 ;
S ;
 KILL ^%XVEMS("ZS")
 S ^%XVEMS("ZS")="Save/Restore Variables"
 S TAG="ZS" D BUILD
 Q
 ;
SY ;Use to guarantee unique subscript - $J_$G(^%XVEMS("SY"))
 ;Necessary because not all systems support $SY.
 S ^%XVEMS("SY")=""
 ;Set error trap to test if vendor supports $SY
 D  ;
 . N $ESTACK,$ETRAP S $ETRAP="D ERR^ZU Q:$QUIT -9 Q"
 . I $SY]"" S ^%XVEMS("SY")="-"_$SY
 Q
 ;
T ;
 KILL ^%XVEMS("ZT")
 S ^%XVEMS("ZT")="Session timed out"
 S TAG="ZT" D BUILD
 Q
 ;
INIT ;
 S U="^"
 S ^%XVEMS("%")="Scratch area"
 S ^%XVEMS("CLH")="Command line history"
 S ^%XVEMS("ID")="User IDs"
 S ^%XVEMS("PARAM")="Shell parameters"
 Q
 ;
ERROR ;
 Q
