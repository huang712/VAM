      SUBROUTINE CFFTF1(N,C,CH,WA,IFAC)                                 
C***BEGIN PROLOGUE  CFFTF1                                              
c!#   $Id: cfftf1.F,v 1.1 2000/11/07 20:09:15 mcc Exp $
c!#   $Log: cfftf1.F,v $
c!#   Revision 1.1  2000/11/07 20:09:15  mcc
c!#   Routine added to build fft.f90dir lib. Initial rev.
c!#
c!#   Revision 1.1  1997/02/07 16:57:20  leidner
c!#   Initial revision
c!#
C***REFER TO  CFFTF                                                     
C***ROUTINES CALLED  PASSF,PASSF2,PASSF3,PASSF4,PASSF5                  
C***END PROLOGUE  CFFTF1                                                
      DIMENSION       CH(1)      ,C(1)       ,WA(1)      ,IFAC(1)       
C***FIRST EXECUTABLE STATEMENT  CFFTF1                                  
      NF = IFAC(2)                                                      
      NA = 0                                                            
      L1 = 1                                                            
      IW = 1                                                            
      DO 116 K1=1,NF                                                    
         IP = IFAC(K1+2)                                                
         L2 = IP*L1                                                     
         IDO = N/L2                                                     
         IDOT = IDO+IDO                                                 
         IDL1 = IDOT*L1                                                 
         IF (IP .NE. 4) GO TO 103                                       
         IX2 = IW+IDOT                                                  
         IX3 = IX2+IDOT                                                 
         IF (NA .NE. 0) GO TO 101                                       
         CALL PASSF4 (IDOT,L1,C,CH,WA(IW),WA(IX2),WA(IX3))              
         GO TO 102                                                      
  101    CALL PASSF4 (IDOT,L1,CH,C,WA(IW),WA(IX2),WA(IX3))              
  102    NA = 1-NA                                                      
         GO TO 115                                                      
  103    IF (IP .NE. 2) GO TO 106                                       
         IF (NA .NE. 0) GO TO 104                                       
         CALL PASSF2 (IDOT,L1,C,CH,WA(IW))                              
         GO TO 105                                                      
  104    CALL PASSF2 (IDOT,L1,CH,C,WA(IW))                              
  105    NA = 1-NA                                                      
         GO TO 115                                                      
  106    IF (IP .NE. 3) GO TO 109                                       
         IX2 = IW+IDOT                                                  
         IF (NA .NE. 0) GO TO 107                                       
         CALL PASSF3 (IDOT,L1,C,CH,WA(IW),WA(IX2))                      
         GO TO 108                                                      
  107    CALL PASSF3 (IDOT,L1,CH,C,WA(IW),WA(IX2))                      
  108    NA = 1-NA                                                      
         GO TO 115                                                      
  109    IF (IP .NE. 5) GO TO 112                                       
         IX2 = IW+IDOT                                                  
         IX3 = IX2+IDOT                                                 
         IX4 = IX3+IDOT                                                 
         IF (NA .NE. 0) GO TO 110                                       
         CALL PASSF5 (IDOT,L1,C,CH,WA(IW),WA(IX2),WA(IX3),WA(IX4))      
         GO TO 111                                                      
  110    CALL PASSF5 (IDOT,L1,CH,C,WA(IW),WA(IX2),WA(IX3),WA(IX4))      
  111    NA = 1-NA                                                      
         GO TO 115                                                      
  112    IF (NA .NE. 0) GO TO 113                                       
         CALL PASSF (NAC,IDOT,IP,L1,IDL1,C,C,C,CH,CH,WA(IW))            
         GO TO 114                                                      
  113    CALL PASSF (NAC,IDOT,IP,L1,IDL1,CH,CH,CH,C,C,WA(IW))           
  114    IF (NAC .NE. 0) NA = 1-NA                                      
  115    L1 = L2                                                        
         IW = IW+(IP-1)*IDOT                                            
  116 CONTINUE                                                          
      IF (NA .EQ. 0) RETURN                                             
      N2 = N+N                                                          
      DO 117 I=1,N2                                                     
         C(I) = CH(I)                                                   
  117 CONTINUE                                                          
      RETURN                                                            
      END                                                               
