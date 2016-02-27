XVSC ; Paideia/SMH - VPE warn of a global kill; ; 10/17/09 11:16pm
 ;;XV
 ;
 Q:$G(XVVWARN)="QWIK"
 N HLD
 S HLD=$$UP^XLFSTR(XVVSHC)
 I HLD["K",HLD["^" DO
 . N FLAGG S FLAGG="GLB"
 . D KILLCHK^XVEMKU(HLD)
 QUIT
