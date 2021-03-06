      SUBROUTINE RFFTI1(N,WA,IFAC)                                      
C***BEGIN PROLOGUE  RFFTI1                                              
c!#   $Id: rffti1.F,v 1.1 2000/11/07 20:11:09 mcc Exp $
c!#   $Log: rffti1.F,v $
c!#   Revision 1.1  2000/11/07 20:11:09  mcc
c!#   Routine added to build fft.f90dir lib. Initial rev.
c!#
c!#   Revision 1.1  1997/02/07 16:57:20  leidner
c!#   Initial revision
c!#
C***REFER TO  RFFTI                                                     
C***ROUTINES CALLED  (NONE)                                             
C***END PROLOGUE  RFFTI1                                                
      DIMENSION       WA(1)      ,IFAC(1)    ,NTRYH(4)                  
      DATA NTRYH(1),NTRYH(2),NTRYH(3),NTRYH(4)/4,2,3,5/                 
C***FIRST EXECUTABLE STATEMENT  RFFTI1                                  
      NL = N                                                            
      NF = 0                                                            
      J = 0                                                             
  101 J = J+1                                                           
      IF (J-4) 102,102,103                                              
  102 NTRY = NTRYH(J)                                                   
      GO TO 104                                                         
  103 NTRY = NTRY+2                                                     
  104 NQ = NL/NTRY                                                      
      NR = NL-NTRY*NQ                                                   
      IF (NR) 101,105,101                                               
  105 NF = NF+1                                                         
      IFAC(NF+2) = NTRY                                                 
      NL = NQ                                                           
      IF (NTRY .NE. 2) GO TO 107                                        
      IF (NF .EQ. 1) GO TO 107                                          
      DO 106 I=2,NF                                                     
         IB = NF-I+2                                                    
         IFAC(IB+2) = IFAC(IB+1)                                        
  106 CONTINUE                                                          
      IFAC(3) = 2                                                       
  107 IF (NL .NE. 1) GO TO 104                                          
      IFAC(1) = N                                                       
      IFAC(2) = NF                                                      
      TPI = 6.28318530717959                                            
      ARGH = TPI/FLOAT(N)                                               
      IS = 0                                                            
      NFM1 = NF-1                                                       
      L1 = 1                                                            
      IF (NFM1 .EQ. 0) RETURN                                           
      DO 110 K1=1,NFM1                                                  
         IP = IFAC(K1+2)                                                
         LD = 0                                                         
         L2 = L1*IP                                                     
         IDO = N/L2                                                     
         IPM = IP-1                                                     
         DO 109 J=1,IPM                                                 
            LD = LD+L1                                                  
            I = IS                                                      
            ARGLD = FLOAT(LD)*ARGH                                      
            FI = 0.                                                     
            DO 108 II=3,IDO,2                                           
               I = I+2                                                  
               FI = FI+1.                                               
               ARG = FI*ARGLD                                           
               WA(I-1) = COS(ARG)                                       
               WA(I) = SIN(ARG)                                         
  108       CONTINUE                                                    
            IS = IS+IDO                                                 
  109    CONTINUE                                                       
         L1 = L2                                                        
  110 CONTINUE                                                          
      RETURN                                                            
      END                                                               
