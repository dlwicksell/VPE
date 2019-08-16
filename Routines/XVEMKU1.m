XVEMKU1 ;DJB/KRN**DATEDASH,CURSOR,YN,TRAP,ERRMSG,DISCLAIM ;Aug 16, 2019@15:13
 ;;15.1;VICTORY PROG ENVIRONMENT;;Jun 19, 2019
 ; Original Code authored by David J. Bolduc 1985-2005
 ;
DATEDASH(DATE) ;Convert date to "3/4/93" format.
 I $G(DATE)']"" Q ""
 S DATE=$E(DATE,4,5)_"/"_$E(DATE,6,7)_"/"_$E(DATE,2,3)
 Q DATE
CURSOR(DX,DY,ERASE) ;Position cursor. If ERASE, erase to end of screen
 S DX=+$G(DX),DY=+$G(DY),ERASE=+$G(ERASE) Q:'DY
 X XVVS("CRSR") Q:'ERASE  W @XVVS("BLANK_C_EOS") X XVVS("XY")
 Q
YN(PROMPT,DFLT) ;Process YES/NO type questions. DFLT 1=YES, 2=NO
 NEW YN S PROMPT=$G(PROMPT),DFLT=$G(DFLT) S:DFLT']"" DFLT=0
YN1 ;
 W !,PROMPT,$P("YES// ^NO// ","^",DFLT)
 R YN:300 S:'$T YN="^" I YN["^" Q -1
 I YN="" Q DFLT
 S YN=$E(YN)
 I "YyNn"'[YN W:YN'="?" $C(7) W "   Y=YES   N=NO" G YN1
 I "Yy"[YN Q 1
 Q 2
TRAP() ;Set error trap
 I $D(^%ZOSF("TRAP")) Q ^("TRAP")
 Q "$ZT=X"
ERRMSG(PKG) ;Generic error message
 NEW ZE
 S @("ZE="_XVV("$ZE"))
 LOCK  ; UNLOCK EVERYTHING!
 W $C(7),!!,"NOTE: You've discovered an error in "_PKG_"."
 W !,"Error: ",ZE
 W !,"Please create (or update) an issue in the VPE issue tracker at"
 W !,"https://github.com/shabiel/VPE/issues.",!
 Q
DISCLAIM ;Disclaimer
 W !!,"=========================< D I S C L A I M E R >========================="
 W !,"IN NO EVENT WILL I, THE DEVELOPER OF THIS SOFTWARE, BE LIABLE FOR DIRECT,"
 W !,"INCIDENTAL, INDIRECT, SPECIAL, OR CONSEQUENTIAL DAMAGES RESULTING FROM"
 W !,"ANY DEFECT IN THIS SOFTWARE OR ITS DOCUMENTATION OR ARISING OUT OF THE"
 W !,"USE OF OR INABILITY TO USE THE SOFTWARE OR ACCOMPANYING DOCUMENTATION."
 W !,"DAVID BOLDUC"
 W !,"=========================================================================",!
 Q
