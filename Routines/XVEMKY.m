XVEMKY ;DJB,KRN**Kernel - Basic Init ; 4/5/03 7:35am
 ;;13.0;VICTORY PROG ENVIRONMENT;;Feb 29, 2016
 ;
INIT ;Initialize variables
 D TIME
 S U="^"
 S $P(XVVLINE,"-",212)=""
 S $P(XVVLINE1,"=",212)=""
 S $P(XVVLINE2,". ",106)=""
 D IO
 S XVVSIZE=(XVV("IOSL")-6)
 S XVVIOST=$S($G(IOST)]"":IOST,1:"C-VT100")
 Q
 ;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
TIME ;Set timeout length
 Q:$G(XVV("TIME"))>0
 I $G(XVV("ID"))>0,$G(^XVEMS("PARAM",XVV("ID"),"TO"))>0 S XVV("TIME")=^("TO") Q
 S XVV("TIME")=$S($D(DTIME):DTIME,1:300)
 Q
 ;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
IO ;Form Feed, Margin, Sheet Length
 I $D(XVV("IOF")),$D(XVV("IOSL")),$D(XVV("IOM")) Q
 D  D PARAM
 . I $G(IOF)]"",$G(IOSL)]"",$G(IOM)]"" D  Q
 . . S XVV("IOF")=IOF,XVV("IOSL")=IOSL,XVV("IOM")=IOM
 . I $D(^%ZIS(1)) D KERN Q
 . D NOKERN
 Q
 ;
PARAM ;Adjust screen length/width to ..PARAM settings
 I $G(XVV("ID"))>0 D  ;
 . S:$D(^XVEMS("PARAM",XVV("ID"),"WIDTH")) XVV("IOM")=^("WIDTH")
 . S:$D(^XVEMS("PARAM",XVV("ID"),"LENGTH")) XVV("IOSL")=^("LENGTH")
 S XVVSIZE=XVV("IOSL")-$S(XVV("IOSL")>6:6,1:"")
 Q
 ;
KERN ;VA KERNEL
 D HOME^%ZIS
 S XVV("IOSL")=IOSL
 S XVV("IOF")=IOF
 S XVV("IOM")=IOM
 Q
 ;
NOKERN ;No VA KERNEL
 S XVV("IOSL")=24
 S XVV("IOF")="#,$C(27),""[2J"",$C(27),""[H"""
 S XVV("IOM")=80
 Q
 ;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
OS ;Get Operating System
 ;This subroutine returns FLAGQ=1 if XVV("OS") cannot be set.
 S FLAGQ=0 D  Q:FLAGQ
 . I $D(^%ZOSF("OS")) S XVV("OS")=+$P(^("OS"),"^",2) Q:XVV("OS")>0
 . I $D(^DD("OS")) S XVV("OS")=+^("OS") Q:XVV("OS")>0
 . I $D(^XVEMS("OS")) S XVV("OS")=+^("OS") Q:XVV("OS")>0
 . D SET
 I XVV("OS")=9 D  Q
 . X "I $I=1,$ZDEV(""VT"")=0 S FLAGQ=1 D DTMHELP" Q
 Q
 ;
SET ;Get MUMPS System
 NEW NUM
 S NUM=7
 I '$D(^XVEMS) D  S FLAGQ=1 Q
 . W $C(7),!!,"Sorry, this software requires that you have either the VA KERNEL,"
 . W !,"FileMan, or the VPE Shell on your system.",!
 NEW X
 W !!,"I need to know what type of Mumps system you are running."
 W !,"Select from the following choices. Selecting a system other"
 W !,"than the one you are running, will cause errors or"
 W !,"unpredictable behavior. DO SET^XVEMKY again to correct."
 W !!,"1. MSM",!,"2. DTM",!,"3. DSM",!,"4. VAX DSM",!,"5. CACHE",!,"6. GT.M (VMS)",!,"7. GT.M (Unix)"
 W !
SET1 R !,"Enter number: ",X:300 S:'$T X="^"
 I "^"[X W ! S FLAGQ=1 Q
 I X'?1N!(X<1)!(X>NUM) D  G SET1
 . W "   Enter a number from 1 to "_NUM
 S X=$S(X=1:8,X=2:9,X=3:2,X=4:16,X=5:18,X=6:17,X=7:19,1:"")
 I X']"" Q
 I $D(^XVEMS) S (^XVEMS("OS"),XVV("OS"))=X
 I $D(^XVEMS("E")) S (^XVEMS("E","OS"),XVV("OS"))=X
 Q
 ;
DTMHELP ;DataTree users on console device must be in VT220 emulation.
 W !!,"============================================================================="
 W $C(7),!!?2,"If you are using DataTree Mumps on the console device, you must enable"
 W !?2,"the VT220 emulation features. You may set the VT device parameter as"
 W !?2,"follows:"
 W !!?10,"USE 1:VT=1   ;to enable",!?10,"USE 1:VT=0   ;to disable"
 W !!?2,"The $ZDEV(""VT"") variable returns the current value of the VT parameter."
 W !!?2,"If you have the DEVICE and TERMINAL TYPE files from the VA KERNEL on your"
 W !?2,"system, go into the DEVICE file and edit the device whose $I field equals"
 W !?2,"1, and enter ""VT=1"" in the USE PARAMETER field."
 W !!,"=============================================================================",!
 Q
