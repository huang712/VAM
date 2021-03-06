      SUBROUTINE EZFFTF(N,R,AZERO,A,B,WSAVE)                            
C***BEGIN PROLOGUE  EZFFTF                                              
c!#   $Id: ezfftf.F,v 1.1 2000/11/07 20:09:48 mcc Exp $
c!#   $Log: ezfftf.F,v $
c!#   Revision 1.1  2000/11/07 20:09:48  mcc
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
C***PURPOSE  A SIMPLIFIED REAL, PERIODIC, FORWARD TRANSFORM             
C***DESCRIPTION                                                         
C                                                                       
C  SUBROUTINE EZFFTF COMPUTES THE FOURIER COEFFICIENTS OF A REAL        
C  PERODIC SEQUENCE (FOURIER ANALYSIS).  THE TRANSFORM IS DEFINED       
C  BELOW AT OUTPUT PARAMETERS AZERO, A AND B.  EZFFTF IS A SIMPLIFIED   
C  BUT SLOWER VERSION OF RFFTF.                                         
C                                                                       
C  INPUT PARAMETERS                                                     
C                                                                       
C  N       THE LENGTH OF THE ARRAY R TO BE TRANSFORMED.  THE METHOD     
C          IS MUST EFFICIENT WHEN N IS THE PRODUCT OF SMALL PRIMES.     
C                                                                       
C  R       A REAL ARRAY OF LENGTH N WHICH CONTAINS THE SEQUENCE         
C          TO BE TRANSFORMED.  R IS NOT DESTROYED.                      
C                                                                       
C                                                                       
C  WSAVE   A WORK ARRAY WHICH MUST BE DIMENSIONED AT LEAST 3*N+15       
C          IN THE PROGRAM THAT CALLS EZFFTF.  THE WSAVE ARRAY MUST BE   
C          INITIALIZED BY CALLING SUBROUTINE EZFFTI(N,WSAVE), AND A     
C          DIFFERENT WSAVE ARRAY MUST BE USED FOR EACH DIFFERENT        
C          VALUE OF N.  THIS INITIALIZATION DOES NOT HAVE TO BE         
C          REPEATED SO LONG AS N REMAINS UNCHANGED.  THUS SUBSEQUENT    
C          TRANSFORMS CAN BE OBTAINED FASTER THAN THE FIRST.            
C          THE SAME WSAVE ARRAY CAN BE USED BY EZFFTF AND EZFFTB.       
C                                                                       
C  OUTPUT PARAMETERS                                                    
C                                                                       
C  AZERO   THE SUM FROM I=1 TO I=N OF R(I)/N                            
C                                                                       
C  A,B     FOR N EVEN B(N/2)=0. AND A(N/2) IS THE SUM FROM I=1 TO       
C          I=N OF (-1)**(I-1)*R(I)/N                                    
C                                                                       
C          FOR N EVEN DEFINE KMAX=N/2-1                                 
C          FOR N ODD  DEFINE KMAX=(N-1)/2                               
C                                                                       
C          THEN FOR  K=1,...,KMAX                                       
C                                                                       
C               A(K) EQUALS THE SUM FROM I=1 TO I=N OF                  
C                                                                       
C                    2./N*R(I)*COS(K*(I-1)*2*PI/N)                      
C                                                                       
C               B(K) EQUALS THE SUM FROM I=1 TO I=N OF                  
C                                                                       
C                    2./N*R(I)*SIN(K*(I-1)*2*PI/N)                      
C***REFERENCES  (NONE)                                                  
C***ROUTINES CALLED  RFFTF                                              
C***END PROLOGUE  EZFFTF                                                
      DIMENSION       R(1)       ,A(1)       ,B(1)       ,WSAVE(1)      
C***FIRST EXECUTABLE STATEMENT  EZFFTF                                  
      IF (N-2) 101,102,103                                              
  101 AZERO = R(1)                                                      
      RETURN                                                            
  102 AZERO = .5*(R(1)+R(2))                                            
      A(1) = .5*(R(1)-R(2))                                             
      RETURN                                                            
  103 DO 104 I=1,N                                                      
         WSAVE(I) = R(I)                                                
  104 CONTINUE                                                          
      CALL RFFTF (N,WSAVE,WSAVE(N+1))                                   
      CF = 2./FLOAT(N)                                                  
      CFM = -CF                                                         
      AZERO = .5*CF*WSAVE(1)                                            
      NS2 = (N+1)/2                                                     
      NS2M = NS2-1                                                      
      DO 105 I=1,NS2M                                                   
         A(I) = CF*WSAVE(2*I)                                           
         B(I) = CFM*WSAVE(2*I+1)                                        
  105 CONTINUE                                                          
      IF (MOD(N,2) .EQ. 0) A(NS2) = .5*CF*WSAVE(N)                      
      RETURN                                                            
      END                                                               
