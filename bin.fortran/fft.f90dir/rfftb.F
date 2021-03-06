      SUBROUTINE RFFTB(N,R,WSAVE)                                       
C***BEGIN PROLOGUE  RFFTB                                               
c!#   $Id: rfftb.F,v 1.1 2000/11/07 20:10:52 mcc Exp $
c!#   $Log: rfftb.F,v $
c!#   Revision 1.1  2000/11/07 20:10:52  mcc
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
C***PURPOSE  BACKWARD TRANSFORM OF A REAL COEFFICIENT ARRAY.            
C***DESCRIPTION                                                         
C                                                                       
C  SUBROUTINE RFFTB COMPUTES THE REAL PERODIC SEQUENCE FROM ITS         
C  FOURIER COEFFICIENTS (FOURIER SYNTHESIS).  THE TRANSFORM IS DEFINED  
C  BELOW AT OUTPUT PARAMETER R.                                         
C                                                                       
C  INPUT PARAMETERS                                                     
C                                                                       
C  N       THE LENGTH OF THE ARRAY R TO BE TRANSFORMED.  THE METHOD     
C          IS MOST EFFICIENT WHEN N IS A PRODUCT OF SMALL PRIMES.       
C          N MAY CHANGE SO LONG AS DIFFERENT WORK ARRAYS ARE PROVIDED.  
C                                                                       
C  R       A REAL ARRAY OF LENGTH N WHICH CONTAINS THE SEQUENCE         
C          TO BE TRANSFORMED                                            
C                                                                       
C  WSAVE   A WORK ARRAY WHICH MUST BE DIMENSIONED AT LEAST 2*N+15       
C          IN THE PROGRAM THAT CALLS RFFTB.  THE WSAVE ARRAY MUST BE    
C          INITIALIZED BY CALLING SUBROUTINE RFFTI(N,WSAVE), AND A      
C          DIFFERENT WSAVE ARRAY MUST BE USED FOR EACH DIFFERENT        
C          VALUE OF N.  THIS INITIALIZATION DOES NOT HAVE TO BE         
C          REPEATED SO LONG AS N REMAINS UNCHANGED.  THUS SUBSEQUENT    
C          TRANSFORMS CAN BE OBTAINED FASTER THAN THE FIRST.            
C          THE SAME WSAVE ARRAY CAN BE USED BY RFFTF AND RFFTB.         
C                                                                       
C                                                                       
C  OUTPUT PARAMETERS                                                    
C                                                                       
C  R       FOR N EVEN AND FOR I = 1,...,N                               
C                                                                       
C               R(I) = R(1)+(-1)**(I-1)*R(N)                            
C                                                                       
C                    PLUS THE SUM FROM K=2 TO K=N/2 OF                  
C                                                                       
C                     2.*R(2*K-2)*COS((K-1)*(I-1)*2*PI/N)               
C                                                                       
C                    -2.*R(2*K-1)*SIN((K-1)*(I-1)*2*PI/N)               
C                                                                       
C          FOR N ODD AND FOR I = 1,...,N                                
C                                                                       
C               R(I) = R(1) PLUS THE SUM FROM K=2 TO K=(N+1)/2 OF       
C                                                                       
C                    2.*R(2*K-2)*COS((K-1)*(I-1)*2*PI/N)                
C                                                                       
C                   -2.*R(2*K-1)*SIN((K-1)*(I-1)*2*PI/N)                
C                                                                       
C   *****  NOTE:                                                        
C               THIS TRANSFORM IS UNNORMALIZED SINCE A CALL OF RFFTF    
C               FOLLOWED BY A CALL OF RFFTB WILL MULTIPLY THE INPUT     
C               SEQUENCE BY N.                                          
C                                                                       
C  WSAVE   CONTAINS RESULTS WHICH MUST NOT BE DESTROYED BETWEEN         
C          CALLS OF RFFTB OR RFFTF.                                     
C***REFERENCES  (NONE)                                                  
C***ROUTINES CALLED  RFFTB1                                             
C***END PROLOGUE  RFFTB                                                 
      DIMENSION       R(1)       ,WSAVE(1)                              
C***FIRST EXECUTABLE STATEMENT  RFFTB                                   
      IF (N .EQ. 1) RETURN                                              
      CALL RFFTB1 (N,R,WSAVE,WSAVE(N+1),WSAVE(2*N+1))                   
      RETURN                                                            
      END                                                               
