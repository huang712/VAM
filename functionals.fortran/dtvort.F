c!#   $Id: dtvort.F,v 1.1 2000/11/13 13:47:21 mcc Exp $
c!#   $Log: dtvort.F,v $
c!#   Revision 1.1  2000/11/13 13:47:21  mcc
c!#   File added for build of libss.a. Initial revision.
c!#
c!#   Revision 1.2  1997/02/12 19:19:28  leidner
c!#   all include files changed to *.h
c!#
c!#	Revision 1.1  1997/02/10  16:39:08  leidner
c!#	Initial revision
c!#
      SUBROUTINE DTVORT
#include "vam.h"
C***********************************************************************
C*****DTVORT CALCULATES D/DT VORTICITY FOR ANALYSIS GRID
C*****AND PLOT ON PRINTER (INTEGRATION AREA ONLY.)
C-----SPECIFICATIONS
C-----XREFS:
C-----USER : .PLDTV ERRSEA ...... ...... ...... ...... ...... ......
C-----FORT : ..SQRT FRDNL# FWRNL# IBCOM# ...... ...... ...... ......
C-----COMMON BLOCK DESCRIBING GRID PARMS WITH IDIM=IBF, IDIMY= JBF MAY82
#include "gparm.h"
#include "grdta.h"
C-----DEFINE NUMERICAL CONSTANTS
      REAL NINETY
      data NINETY/90D0/
C-----DEFINE PHYSICAL CONSTANT: ROTATION RATE OF EARTH (RADIANS/SEC)
      DATA OMEGA/7.292D-5/
C-----DEFINE CONVERSION FACTOR: DEGREES TO RADIANS
      DATA FACTOR/1.74532925199432946D-2/
C-----DEFINE PHYSICAL CONSTANT: RADIUS OF EARTH (METERS)
      DATA REARTH/6371D3/
      DATA SCALEV/1D-8/,VINTER/1D0/
      DATA IPRINT/0/,IPLOT/1/
      NAMELIST /INPUT/ SCALEV,IPRINT,IPLOT,VINTER
C     DOUBLE PRECISION SQRT
C     SQRT(DUMMY)=sqrt(DUMMY)
      IF (NGRDPT.LE.0) CALL ERRSEA (513,6HDTVORT)
      WRITE (6,101) NAME
  101 FORMAT ('0D/DT VORTICITY CALCULATION FOR GRID ',A8/)
      READ (30,INPUT,END=1520,ERR=1520)
      WRITE (6,INPUT)
C-----CHECK THAT INTEGRATION AREA IS INTERIOR TO GRID EXCEPT AT POLES
      IF(KMIN.EQ.1 .OR. KMAX.EQ.NX) CALL ERRSEA (514,6HDTVORT)
      IF ((LMIN.EQ.1  .AND. YS.NE.-NINETY) .OR.
     +    (LMAX.EQ.NY .AND. YF.NE.+NINETY)) CALL ERRSEA (514,6HDTVORT)
C-----IF POLES PRESENT ALL LONGITUDES MUST BE PRESENT
      IF ( ((LMIN.EQ.1 .AND. YS.EQ.-NINETY)  .OR.
     +      (LMAX.EQ.NY.AND. YF.EQ.+NINETY)) .AND.
     +     (IPER.GT.NX) ) CALL ERRSEA (514,6HDTVORT)
C-----GLOBAL TEMPORARIES
      RY=1/(2*REARTH*FACTOR*DELY)
      RYY=(2*RY)**2
C-----PRECALCULATE VEL
      DO 100 J=1,NY
      DO 100 I=1,NX
      VEL(I,J)=SQRT(U(I,J)**2 + V(I,J)**2)
  100 CONTINUE
C-----CALCULATION IS OVER INTEGRATION AREA
      DO 1000 L=LMIN,LMAX
C-----CHECK FOR POLE
      IF ( .NOT. ((L.EQ.1 .AND. YS.EQ.-NINETY)  .OR.
     +      (L.EQ.NY.AND. YF.EQ.+NINETY)) ) GO TO 800
C-----CALL ERRSEA (529,6HDTVORT)
C-----SEE BELOW FOR POLE TREATMENT
      GO TO 1000
C-----NON POLAR L
  800 CONTINUE
C-----LATITUDE DEPENDENT TEMPORARIES
      F=2*OMEGA*AZ(L)
      T=AZ(L)/(REARTH*BZ(L))
      BETAP=2*OMEGA*BZ(L)/REARTH - F*T
      RX=1/(2*REARTH*FACTOR*DELX*BZ(L))
      RXX=(2*RX)**2
      RXY=RX*RY
      DO 900 K=KMIN,KMAX
C-----POINT DEPENDENT TEMPORARIES
      U00=U(K,L)
      V00=V(K,L)
      UX=RX*(U(K+1,L)-U(K-1,L))
      VX=RX*(V(K+1,L)-V(K-1,L))
      UY=RY*(U(K,L+1)-U(K,L-1))
      VY=RY*(V(K,L+1)-V(K,L-1))
      VXX=RXX*(V(K+1,L)-2*V(K,L)+V(K-1,L))
      VXY=RXY*(V(K+1,L+1)-V(K+1,L-1)-V(K-1,L+1)+V(K-1,L-1))
      UXY=RXY*(U(K+1,L+1)-U(K+1,L-1)-U(K-1,L+1)+U(K-1,L-1))
      UYY=RYY*(U(K,L+1)-2*U(K,L)+U(K,L-1))
C-----
      T1=UX+VY
      T2=VX-UY
      T3=VXX-UXY
      T4=VXY-UYY
      T5=2*T*V00-(UX+VY)
      T6=2*T*U00+F+(VX-UY)
      T7=  T*U00+F+(VX-UY)
C-----NOTE THAT CD NOT DIVIDED BY VEL AS IT WAS IN SSDTZ
      DTZ = T2*T1 + U00*V00/(REARTH**2) + T*(U00*(2*UX + VY) + 2*V00*UY)
     +      + U00*T3 + V00*T4 + F*T1 + BETAP*V00
     F      - RX*(CD(K+1,L)*VEL(K+1,L)*V(K+1,L)
     F          - CD(K-1,L)*VEL(K-1,L)*V(K-1,L) )
     F      + RY*(CD(K,L+1)*VEL(K,L+1)*U(K,L+1)
     F          - CD(K,L-1)*VEL(K,L-1)*U(K,L-1) )
     F      - T*CD(K,L)*VEL(K,L)**2*U00
C-----CONTINUATIONS WITH F ARE FOR FRICTIONAL EFFECTS
C-----MINUS SIGN NEGLECTED IN SSDTZ SINCE NOT NEEDED.
      DELSSU(K  ,L  ) = -DTZ
C=====DEBUG OUTPUT
C=====WRITE (6,49) K,L,DELSSU(K,L)
C==49=FORMAT (1X,2I5,5D20.6)
  900 CONTINUE
 1000 CONTINUE
C-----CALCULATE VALUES AT POLES AS AVERAGE OF VALUES ONE LATITUDE AWAY
C-----THIS IS NOT QUITE CONSISTENT WITH SSDTZ
      IF (.NOT.((LMIN.EQ.1).AND.(YS.EQ.-NINETY))) GO TO 1200
C-----SOUTH POLE PRESENT
      KPER=KMIN+IPER-1
      DTZ=0
      DO 1125 K=KMIN,KPER
 1125 DTZ=DTZ+DELSSU(K,LMIN+1)
      DTZ=DTZ/IPER
      DO 1150 K=KMIN,KMAX
 1150 DELSSU(K,LMAX-1)=DTZ
 1200 IF (.NOT.((LMAX.EQ.NX).AND.(YF.EQ. NINETY))) GO TO 1275
C-----NORTH POLE PRESENT
      KPER=KMIN+IPER-1
      DTZ=0
      DO 1225 K=KMIN,KPER
 1225 DTZ=DTZ+DELSSU(K,LMAX-1)
      DTZ=DTZ/IPER
      DO 1250 K=KMIN,KMAX
 1250 DELSSU(K,LMAX-1)=DTZ
 1275 CONTINUE
C-----OUTPUT RESULTS
c     CALL PLDTZ (DELSSU,IDIM,IP,JP,NIP,NJP,SCALEV,IPRINT,IPLOT,
c    +   VINTER,'D/DT VORTICITY',14,NAME)
      RETURN
 1520 CALL ERRSEA (520,6HDTVORT)
      RETURN
      END
