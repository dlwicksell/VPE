XVRSE ;VEN/TOAD - Routine Search ; 9/17/09 10:36pm
 ;;13.0;VICTORY PROG ENVIRONMENT;;Feb 29, 2016
 ;
 ; call XVRSE to get interaction
 ; CALL CALL^XVRSE with:
 ;    %ZF - string to find
 ;    %ZR - routine array or name
 ;    %ZD - a device to receive a trail
 ;
 N cnt1,cnt2,cnt3,flen,fnd,gtmvt,h,i,o,out,outd,p,r,rl,sx,tics,x,xn,%ZC,%ZD,%ZF,%ZR
 W !,"Routine Search for Every occurrence",!
 S %ZC=0,(cnt1,cnt2,cnt3)=0,(out,outd)=1
 I '$d(%zdebug) N $et S $et="zg "_$zl_":ERR^XVRCE" D
 . ; U $p:(ctrap=$c(3):exc="zg "_$zl_":LOOP^XVRCE")
 . U $p:(exc="zg "_$zl_":LOOP^XVRCE")
 ;
 D MAIN^XVRCE
 ;
 U $p:(ctrap="":exc="")
 ;
 QUIT  ; end of main subroutine
 ;
CALL I '$l($g(%ZF)) Q
 N %ZC,cnt1,cnt2,cnt3,flen,fnd,gtmvt,h,i,o,out,outd,p,r,rl,sx,tics,x,xn
 N:'$d(%ZD) %ZD
 S %ZD=$g(%ZD),(%ZC,cnt1,cnt2,cnt3,out)=0,outd=$l(%ZD)
 I $d(%ZR)<10 D CALL^%RSEL
 D WORK^XVRCE
 ;
 QUIT  ; end of CALL
 ;
 ; end of routine XVRSE
