%XVEMSI ;DLW,VRR**ZInsert a routine into VPE ; 12/8/09 5:08pm
 ;;12.5;VPE;;COPYRIGHT David Wicksell @2009
 ;
 ; Enter a routine. Sort of a ZInsert routine. This is a system QWIK
 ; and is called by typing ..ZI while in the VSHELL.
 ; This routine tries to simulate the functionality of ZInsert from
 ; Caché, but it does not allow editing after you have copy and pasted
 ; in a routine. For that you should just open up the editor after.
 ;
 W #?19,"ZInsert mode -- Please enter your routine.",!
 W ?19,"When you are finished, type: Ctl-D<RETURN>",!
 N B S $P(B,"*",79)="" W ?1,B,!
 N $ESTACK,$ETRAP S $ETRAP="D ERR^ZU Q:$QUIT -9 Q"
 N VRRS,ND,FL,LST,XVZI S (VRRS,XVZI)=1,ND=VRRS,(FL,LST)=0
 N I,J,K,RTN,RNM,RT,RS,RL,SRS 
 F I=1:1 D  Q:RTN=$C(4)  ;Loop through every line pasted into the buffer
 . I FL S FL=0 Q
 . S (RT,RS,RL)="" ;RT=Record Tag, RS=Record Separator, RL=Record Line
 . I LST S RTN=$C(4) ;Allows same ZI quit for every situation, LST=Last
 . E  R RTN ;RTN=Routine line
 . I RTN[$C(4) D  ;Check for a Ctl-D in any line
 . . I $L(RTN)>1 S RTN=$E(RTN,1,$L(RTN)-1),LST=1 ;Strip Ctl-D, set LST 
 . . E  S RT=" <> <> <>"  ;VPE looks for this line to end
 . I RTN="" S RTN=" "
 . I $E(RTN)=$C(9) S RT="",RS=" ",RL=$E(RTN,2,999) ;Change tabs to spaces 
 . I $E(RTN)=" " D
 . . S RT="" F J=1:1 Q:$E(RTN,J)'=" "  S RS=RS_$E(RTN,J) ;Gather all spaces
 . . S RL=$E(RTN,J,999)
 . I ($E(RTN)'=$C(9))&($E(RTN)'=" ") D  ;A line with a tag
 . . F J=1:1 Q:($E(RTN,J)=$C(9))!($E(RTN,J)=" ")!($E(RTN,J)="")  D
 . . . S RT=RT_$E(RTN,J) ;Gather the whole tag
 . . I ($E(RTN,J)=$C(9))!($E(RTN,J)="") S RS=" ",RL=$E(RTN,J+1,999)
 . . E  D
 . . . F K=J:1 Q:$E(RTN,K)'=" "  S RS=RS_$E(RTN,K) ;Gather all spaces
 . . . S RL=$E(RTN,K,999)
 . I I=1 S RNM=$P(RTN,RS),SRS=RS_$C(30) ;RNM=Routine Name, SRS=Saved Record Sep
 . I $L(RL)>68 D  ;Break lines over 68 chars, per VPE format
 . . S ^TMP("XVV","IR"_ND,$J,I)=RT_RS_$C(30)_$E(RL,1,68)
 . . S ^TMP("XVV","IR"_ND,$J,I+1)=$E(RL,60,999)
 . . S FL=1 ;Set FL to skip an iteration of the loop
 . E  S ^TMP("XVV","IR"_ND,$J,I)=RT_RS_$C(30)_RL
 W #
SAVE ;Save an inserted routine
 N SV S SV=1 ;SV=Save
 I $G(RNM)=$C(4) W !?1,"You have quit ZInsert." Q  ;Ctl-D by itself to quit
 I ($L($G(RNM))<1)!($L($G(RNM))>8) D
 . W !!,"This response must have at least 1 character and no more than 8"
 . W !,"characters and must not contain embedded uparrow.",!
 . S RNM=$$ASKN(RNM) ;Ask for new name of routine
 . S ^TMP("XVV","IR"_ND,$J,1)=RNM_SRS_$P(^TMP("XVV","IR"_ND,$J,1),SRS,2,999)
 . D SAVE S SV=0 ;Need to check routine name again, but not after popping stack
 I SV,$$EXISTS(RNM) D  ;Only question if routine already exists
 . I '$$ASKE(RNM) D  ;Don't want to overwrite routine
 . . I '$$ASKO(RNM) W #!?1,"You did not save your routine." S SV=0 Q
 . . S RNM=$$ASKN(RNM) ;Ask for new name of routine
 . . S ^TMP("XVV","IR"_ND,$J,1)=RNM_SRS_$P(^TMP("XVV","IR"_ND,$J,1),SRS,2,999)
 . . I $$EXISTS(RNM) D SAVE S SV=0 ;Routine exists, ask questions again
 I ($L($G(RNM))<1)!($L($G(RNM))>8) D SAVE S SV=0 ;Is routine name SAC compliant?
 D:SV  ;We are ready to save
 . N FLAGQ S ^TMP("XVV","VRR",$J,VRRS,"NAME")=$G(RNM),FLAGQ=1 ;FLAGQ=1 per API
 . W # D SAVE^%XVEMRMS ;API for writing ^TMP to ^UTILITY, then saving to disk
 K ^TMP("XVV","VRR",$J,VRRS,"NAME"),^TMP("XVV","IR"_ND,$J) ;Clean up afterwards
 Q
 ;
EXISTS(RNM) ;Test to see if file exists.
 N FILE,TST
 S FILE=$P($ZRO," ")_"/"_$G(RNM)_".m"
 ; Below tests to see if a file exists in the first directory of routine path
 S TST=$$RETURN^%ZOSV("if [ -e "_FILE_" ]; then echo 1; else echo 0; fi")
 Q TST
 ;
ASKE(RNM) ;Ask if you want to overwrite an existing routine
 I ($D(^DD))&($D(^DIC)) N DIR,X,Y D  Q Y
 . S DIR(0)="Y",DIR("B")="NO"
 . S DIR("A")=" "_$G(RNM)_" exists. Would you like to overwrite it"
 . D ^DIR
 E  N FL D  Q FL
 . N ANS S ANS=$$ASK(" "_$G(RNM)_" exists. Would you like to overwrite it",2)
 . I ANS="Y" S FL=1
 . E  S FL=0 
 ;
ASKO(RNM) ;Ask if you want to rename the routine
 I ($D(^DD))&($D(^DIC)) N DIR,X,Y D  Q Y
 . S DIR(0)="Y",DIR("B")="NO"
 . S DIR("A")=" Would you like to rename your routine"
 . D ^DIR
 E  N FL D  Q FL
 . N ANS S ANS=$$ASK(" Would you like to rename your routine",2)
 . I ANS="Y" S FL=1
 . E  S FL=0
 ;
ASKN(RNM) ;Ask what the new routine name should be
 I ($D(^DD))&($D(^DIC)) N DIR,X,Y D  Q Y
 . S DIR(0)="FA^1:8",DIR("B")=RNM
 . S DIR("A")=" What would you like to name your routine? "
 . D ^DIR
 E  N ANS S ANS=$$ASK(" What would you like to name your routine",3) Q ANS
 ;
ASK(PROMPT,DEFAULT) ;Return: Y=YES, N=NO, RNM=Routine name
 N YN,TST
 S TST=DEFAULT 
 S DEFAULT=$S($G(DEFAULT)=2:"NO",$G(DEFAULT)=3:$G(RNM),1:"YES")
ASK1 ;
 W !,$G(PROMPT),"? "_DEFAULT_"// "
 R YN:300 S:'$T YN="^" S:YN="" YN=DEFAULT I YN="^" Q YN
 I TST'=3 D
 . S YN=$TR($E(YN,1),"yn","YN")
 . I "YN"'[YN W "   Y=YES  N=NO" G ASK1
 Q YN
