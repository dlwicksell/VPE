XVRCE ;VEN/TOAD - Routine Change ; 9/17/09 10:37pm
 ;;**LOCAL** VEN/TOAD 1/29/2009;;;;Build 9
 ;
 ; call ^XVRCE to get interaction
 ; call CALL^XVRCE with:
 ;   %ZF - string to find
 ;   %ZN - new string
 ;   %ZR - routine array or name
 ;         %ZD - device to receive a trail
 ;
 N cnt1,cnt2,cnt3,fnd,h,i,o,out,outd,r,tf,x,xn,%ZC,%ZD,%ZF,%ZN,%ZR
 I '$d(%zdebug) N $et S $et="zg "_$zl_":ERR^%RCE" D
 . U $p:(ctrap=$c(3):exc="zg "_$zl_":LOOP^%RCE")
 D INIT,MAIN
 U $p:(ctrap="":exc="")
 ;
 QUIT  ; end of main subroutine
 ;
 ;
CALL I '$l($g(%ZF)) Q
 N zc,zd S zc=$G(%ZC),zd=$G(%ZD)
 N cnt1,cnt2,cnt3,fnd,h,i,o,out,outd,r,tf,x,xn,%ZD,%ZC,lzd
 N:'$d(%ZN) %ZN
 S %ZC=zc,%ZD=zd
 S %ZD=$g(%ZD)
 S %ZN=$g(%ZN)
 S (cnt1,cnt2,cnt3,out,outd)=0
 S tf=$j_"rce.tmp"
 S lzd=$l(%ZD)
 S:'lzd %ZD=$P
 S:%ZC outd=$l(%ZD)
 S:'outd %ZD=$p
 S:'lzd %ZD=$P
 S %ZC=1
 I $d(%ZR)<10 D CALL^%RSEL
 D WORK
 ;
 QUIT  ; end of CALL
 ;
 ;
INIT S %ZC=1
 S (cnt1,cnt2,cnt3)=0
 S out=1
 S tf=$j_"rce.tmp"
 W !,"Routine Change Every occurrence",!
 ;
 QUIT  ; end of INIT
 ;
 ;
MAIN S %ZR="" D CALL^%RSEL
 I %ZR=0 W !,"No routines selected" Q
 W !,$s(%ZC:"Old",1:"Find")," string: " R %ZF
 I '$l(%ZF) W !,"No search string to find - no search performed",! Q
 I %ZF?.E1C.E W !,"The find string contains control characters"
 I %ZC R !,"New string: ",%ZN
 I %ZC,%ZN?.E1C.E W !,"The New string contains control characters"
 W !,$s(%ZC:"Replace",1:"Find")," all occurrences of:",!,">",%ZF,"<",!
 I %ZC W "With: ",!,">",%ZN,"<",!
 I %ZC F  R !,"Show changed lines <Yes>?: ",x,! Q:$e(x)'="?"  D HELP
 I %ZC,$l(x) Q:"\QUIT"[("\"_$tr(x,"quit","QUIT"))  D
 . S outd=$e("NO",1,$l(x))'=$e($tr(x,"no","NO"),1,2)
 E  S outd=1
 I outd F  D  Q:$l(%ZD)
 . R !,"Output device: <terminal>: ",%ZD,!
 . I '$l(%ZD) S %ZD=$p Q
 . I %ZD="^" Q
 . I %ZD="?" D  Q
  . . W !!,"Select the device you want for output"
  . . W !,"If you wish to exit enter a carat (^)",!
  . . S %ZD=""
 . I $zparse(%ZD)="" W "  no such device" S %ZD="" Q
 . O %ZD:(newversion:block=2048:record=2044:exception="g noopen"):0
 . I '$t  W !,%ZD," is not available" S %ZD="" Q
 . Q
NOOPEN . W !,$p($ZS,",",2,999),! C %ZD S %ZD=""
 I '$D(%ZD) S %ZD=""
 Q:%ZD="^"
 W !
 D WORK
 ;
 QUIT  ; end of NOOPEN
 ;
 ;
WORK S %ZR="",r=$zsearch("__")
 I outd,%ZD'=$p U %ZD W $zd($h,"DD-MON-YEAR 24:60:SS"),!
 I  D
 . W "Routine ",$s(%ZC:"Change",1:"Search for")
 . W " Every occurrence of:",!,">",%ZF,"<",!
 . I %ZC W "To:",!,">",%ZN,"<",!
 I '%ZC D
 . S gtmvt=$$GTMVT^%GSE
 . I gtmvt S sx=$c(27)_"[7m"_%ZF_$c(27)_"[0m"
 . E  S sx=%ZF,flen=$l(%ZF),tics=$tr($j("",flen)," ","^")
 F  S %ZR=$o(%ZR(%ZR)) Q:'$l(%ZR)  D SCAN
 Q:'out
 U %ZD
 W !!,"Total of ",cnt1," routine",$s(cnt1=1:"",1:"s")," parsed.",!
 W cnt2," occurrence",$s(cnt2=1:" ",1:"s ")
 W $s(%ZC:"changed",1:"found")," in ",cnt3
 W " routine",$s(cnt3=1:".",1:"s."),!
 C %ZD
 ;
 QUIT  ; end of WORK
 ;
 ;
SCAN S r=%ZR(%ZR)_$tr($e(%ZR),"%","_")_$e(%ZR,2,9999)_".m"
 S o=$zsearch(r)
 S fnd=0
 U $p I out,%ZD'=$p!'outd D
 . W:$x>70 !
 . ; w %ZR,?$x\10+1*10
 I outd ; U %ZD W !!,r
 O:%ZC tf:(newversion:exception="S fnd=0 G REOF")
 O o:(readonly:record=2048:rewind:exception="G RNOOPEN")
 U o:exception="G REOF"
 N XVLABEL S XVLABEL=""
 N XVOFFSET S XVOFFSET=0
 S cnt1=cnt1+1
 F  U o R x S h=$l(x,%ZF) D
 . ;
 . N XVTAG S XVTAG=$P(x," ") ; line tag, if any
 . I XVTAG="" S XVOFFSET=XVOFFSET+1
 . E  D
 . . S XVTAG=$P(XVTAG,"(")
 . . S XVLABEL=XVTAG
 . . S XVOFFSET=0
 . ;
 . I h=1 D:%ZC  Q
 . . U tf W x,!
 . ;
 . I fnd=0,'%ZC D
 . . U %ZD W !!,"***** ",%ZR," *****",!
 . S fnd=fnd+h-1
 . ;
 . I %ZC D  Q
 . . I outd U %ZD W !,"Was: " W x
 . . S xn=""
 . . F i=1:1:h-1 S xn=xn_$p(x,%ZF,i)_%ZN
 . . S xn=xn_$p(x,%ZF,h)
 . . I outd W !,"Now: ",xn
 . . U tf W xn,! Q
 . ;
 . U %ZD
 . W !,XVLABEL I XVOFFSET W "+",XVOFFSET,":",!
 . S rl=""
 . ;
 . F i=1:1:h-1 D
 . . S p=$tr($p(x,%ZF,i),$c(9)," ")
 . . W p,sx
 . . I 'gtmvt S rl=rl_$j(tics,$l(p)+flen)
 . W $p(x,%ZF,h)
 . I 'gtmvt W !,rl
 ;
 QUIT  ; end of SCAN
 ;
 ;
REOF I fnd D
 . S cnt2=cnt2+fnd
 . S cnt3=cnt3+1
 . I %ZC C:$zver'["VMS" o:(DELETE) C tf:(RENAME=r)
 I 'fnd!'%ZC C o I %ZC C tf:(DELETE)
 ;
 ; warning - fall-through
 ;
RNOOPEN I $zs'["EOF" W !,$p($zs,",",2,999),!
 ;
 QUIT  ; end of RNOOPEN
 ;
 ;
HELP I "Dd"[$e(x,2),$l(x)=2 D CUR Q
 I %ZC W !,"Answer No to this prompt if you do not wish a trail of the changes"
 W !,"Enter Q to exit",!
 W !,"?D for the current routine selection"
 ;
 QUIT  ; end of HELP
 ;
 ;
CUR W ! S r=""
 F  S r=$o(%ZR(r)) Q:'$l(r)  W:$x>70 ! W r,?$x\10+1*10
 ;
 QUIT  ; end of CUR
 ;
 ;
ERR I $d(tf) C tf:(DELETE)
 I $d(o) C o
 I $d(%ZD),%ZD'=$p C %ZD
 U $p W !,$p($ZS,",",2,999),!
 U $p:(ctrap="":exception="")
 S $ec=""
 ;
 QUIT  ; end of ERR
 ;
 ;
LOOP I $d(tf) C tf:delete
 I $d(o) C o
 I $d(%ZD),%ZD'=$p C %ZD
 D MAIN
 U $p:(ctrap="":exception="")
 ;
 QUIT  ; end of LOOP
 ;
 ; end of routine XVRCE
