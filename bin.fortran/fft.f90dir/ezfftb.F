      SUBROUTINE EZFFTB(N,R,AZERO,A,B,WSAVE)                            
C***BEGIN PROLOGUE  EZFFTB                                              
c!#   $Id: ezfftb.F,v 1.1 2000/11/07 20:09:45 mcc Exp $
c!#   $Log: ezfftb.F,v $
c!#   Revision 1.1  2000/11/07 20:09:45  mcc
c!#   Routine added to build fft.f90dir lib. Initial rev.
c!#
c!#   Revision 1.1  1997/02/07 16:57:20  leidner
c!#   Initial revision
c!#
C***DATE WRITTEN   790601   (YYMMDD)                                    
C***REVISION DATE  830401   (YYMMDD)                                    
C***CATEGORY NO.  J1A1                                                  
C***KEYWORDS  FOURIER TRANSFORM                                         
C***AUTHOR  SWARZTRAUBER, P. N., (NCAR)                                 
C***PURPOSE  A SIMPLIFIED REAL, PERIODIC, BACKWARD TRANSFORM            
C***DESCRIPTION                                                         
C                                                                       
C  SUBROUTINE EZFFTB COMPUTES A REAL PERODIC SEQUENCE FROM ITS          
C  FOURIER COEFFICIENTS (FOURIER SYNTHESIS).  THE TRANSFORM IS          
C  DEFINED BELOW AT OUTPUT PARAMETER R.  EZFFTB IS A SIMPLIFIED         
C  BUT SLOWER VERSION OF RFFTB.                                         
C                                                                       
C  INPUT PARAMETERS                                                     
C                                                                       
C  N       THE LENGTH OF THE OUTPUT ARRAY R.  THE METHOD IS MOST        
C          EFFICIENT WHEN N IS THE PRODUCT OF SMALL PRIMES.             
C                                                                       
C  AZERO   THE CONSTANT FOURIER COEFFICIENT                             
C                                                                       
C  A,B     ARRAYS WHICH CONTAIN THE REMAINING FOURIER COEFFICIENTS.     
C          THESE ARRAYS ARE NOT DESTROYED.                              
C                                                                       
C          THE LENGTH OF THESE ARRAYS DEPENDS ON WHETHER N IS EVEN OR   
C          ODD.                                                         
C                                                                       
C          IF N IS EVEN, N/2    LOCATIONS ARE REQUIRED.                 
C          IF N IS ODD, (N-1)/2 LOCATIONS ARE REQUIRED                  
C                                                                       
C  WSAVE   A WORK ARRAY WHICH MUST BE DIMENSIONED AT LEAST 3*N+15       
C          IN THE PROGRAM THAT CALLS EZFFTB.  THE WSAVE ARRAY MUST BE   
C          INITIALIZED BY CALLING SUBROUTINE EZFFTI(N,WSAVE), AND A     
C          DIFFERENT WSAVE ARRAY MUST BE USED FOR EACH DIFFERENT        
C          VALUE OF N.  THIS INITIALIZATION DOES NOT HAVE TO BE         
C          REPEATED SO LONG AS N REMAINS UNCHANGED.  THUS SUBSEQUENT    
C          TRANSFORMS CAN BE OBTAINED FASTER THAN THE FIRST.            
C          THE SAME WSAVE ARRAY CAN BE USED BY EZFFTF AND EZFFTB.       
C                                                                       
C                                                                       
C  OUTPUT PARAMETERS                                                    
C                                                                       
C  R       IF N IS EVEN, DEFINE KMAX=N/2                                
C          IF N IS ODD,  DEFINE KMAX=(N-1)/2                            
C                                                                       
C          THEN FOR I=1,...,N                                           
C                                                                       
C               R(I)=AZERO PLUS THE SUM FROM K=1 TO K=KMAX OF           
C                                                                       
C               A(K)*COS(K*(I-1)*2*PI/N)+B(K)*SIN(K*(I-1)*2*PI/N)       
C                                                                       
C  ********************* COMPLEX NOTATION **************************    
C                                                                       
C          FOR J=1,...,N                                                
C                                                                       
C          R(J) EQUALS THE SUM FROM K=-KMAX TO K=KMAX OF                
C                                                                       
C               C(K)*EXP(I*K*(J-1)*2*PI/N)                              
C                                                                       
C          WHERE                                                        
C                                                                       
C               C(K) = .5*CMPLX(A(K),-B(K))   FOR K=1,...,KMAX          
C                                                                       
C               C(-K) = CONJG(C(K))                                     
C                                                                       
C               C(0) = AZERO                                            
C                                                                       
C                    AND I=SQRT(-1)                                     
C                                                                       
C  *************** AMPLITUDE - PHASE NOTATION ***********************   
C                                                                       
C          FOR I=1,...,N                                                
C                                                                       
C          R(I) EQUALS AZERO PLUS THE SUM FROM K=1 TO K=KMAX OF         
C                                                                       
C               ALPHA(K)*COS(K*(I-1)*2*PI/N+BETA(K))                    
C                                                                       
C          WHERE                                                        
C                                                                       
C               ALPHA(K) = SQRT(A(K)*A(K)+B(K)*B(K))                    
C                                                                       
C               COS(BETA(K))=A(K)/ALPHA(K)                              
C                                                                       
C               SIN(BETA(K))=-B(K)/ALPHA(K)                             
C***REFERENCES  (NONE)                                                  
C***ROUTINES CALLED  RFFTB                                              
C***END PROLOGUE  EZFFTB                                                
      DIMENSION       R(1)       ,A(1)       ,B(1)       ,WSAVE(1)      
C***FIRST EXECUTABLE STATEMENT  EZFFTB                                  
      IF (N-2) 101,102,103                                              
  101 R(1) = AZERO                                                      
      RETURN                                                            
  102 R(1) = AZERO+A(1)                                                 
      R(2) = AZERO-A(1)                                                 
      RETURN                                                            
  103 NS2 = (N-1)/2                                                     
      DO 104 I=1,NS2                                                    
         R(2*I) = .5*A(I)                                               
         R(2*I+1) = -.5*B(I)                                            
  104 CONTINUE                                                          
      R(1) = AZERO                                                      
      IF (MOD(N,2) .EQ. 0) R(N) = A(NS2+1)                              
      CALL RFFTB (N,R,WSAVE(N+1))                                       
      RETURN                                                            
      END                                                               
