
c!#   CSU IDENTIFICATION : JscES0
c!#   $Id: jsces0.for,v 1.2 2000/01/24 15:44:10 trn Exp $

c     Copyright (c)       Ross Hoffman           AER          10 Feb 93

c!##  PURPOSE : JscES0 calculates sigma0 values using a model function.

c!#   JscES0 calculates the scatterometer sigma0 values from the neutral
c!#   stability wind using the scatterometer model function.

c!#   CSU SPECIFICATION AND CONSTRAINTS :

c!##  REQUIREMENTS :

c!#   Avoid division by zero by enforcing a minimum value of sigma0.

c!##  CONSTRAINTS :

c!##  LANGUAGE : Fortran

c!#   CSU DESIGN :

c     ------------------------------------------------------------------

c!##  INPUT/OUTPUT INTERFACE :

<NLM> subroutine JscES0   !#
<LTM> subroutine JscES0tl   !#
<ADJ> subroutine JscES0ad   !#
     C    ( N, s0table, !#
     I    Pol, Theta, Azm, !#
     I    U, D, !#
<PER>T    U5, D5, S05, !#
     O    S0) !#

c!##  GLOBAL AND SHARED DATA :

<ALL> use types, only: s0_table_typ, npol
<ALL> use constants, only: pi
<ALL> use s0_init_mod, only: s0min

<ALL> implicit none

c!#   Input constants:
c!#~   N         Length of data vectors
<ALL> integer N !#
<ALL> type (s0_table_typ), intent(in) :: s0table

c!#   Observational data and constants:
c!#~   Pol       Polarization (0=Hpol, 1=Vpol)
c!#~   Theta     Beam incidence angle (rad)
c!#~   Azm       Radar pointing direction (rad)
c!#~   Azm.      From direction, clockwise from north
<ALL> integer Pol(N) !#
<ALL> real Theta(N), Azm(N) !#

c!#   Inputs:
c!#~   U         Neutral wind speed (m/s)
c!#~   U.        At reference level
c!#~   D         Wind direction (rad)
c!#~   D.        From direction, clockwise from north
<ALL> real U(N), D(N) !#

c!#   Outputs:
c!#~   S0        Sigma0 (radar backscatter) (normalized)
<ALL> real S0(N) !#
cPER>
cPER> Variables with a 5 suffix are the corresponding trajectory !#
cPER> variables. !#
<PER> real U5(N), D5(N), S05(N) !#

c     ------------------------------------------------------------------

c!##  DATA CONVERSION :

c!##  ALGORITHMS :

c!#   Use one of possibly several look up tables, for each
c!#   observation.

c!#   If the trajectory value of S0 < S0min it is set to S0min.
c!#   When this happens the preliminary model calculation of S0 is
c!#   meaningless and the linear model is simply S0 = 0.

c!##  REFERENCES :

c!##  LIMITATIONS :

c!#   If the number of model functions grows, it may be desirable to
c!#   have this routine call other environmental interface routines.
c!#   This way the model function common blocks could be private.

c!##  CHANGE LOG :
c!#   $Log: jsces0.for,v $
c!#   Revision 1.2  2000/01/24 15:44:10  trn
c!#   Cosmetic changes
c!#
c!#   Revision 1.1  2000/01/20 16:31:39  trn
c!#   Initial revision
c!#
c!#   Revision 1.3  1998/01/13 19:32:20  rnh
c!#   Major diet complete.
c!#

c     ------------------------------------------------------------------

c!##  LOCAL DATA ELEMENTS :

c!#~   j        Loop variable
c!#~   Delta    Bias correction (1)
c!#~   Angle    Incidence angle for computing bias (degrees)
c!#~   iAngle   Incidence angle to nearest degree for computing bias
c!#~   jPol     Polarization index

<ALL> integer j, iAngle, jPol
<ALL> real Delta, Angle

c!##  LOCAL DATA STRUCTURES :

c!##  DATA FILES :

c     ------------------------------------------------------------------

c!##  LOGIC FLOW AND DETAILED ALGORITHM :

c!#   2. Or, if using sigma0 look up table, interpolate the table.

      do 240 j = 1, N
<ALL>    jPol = 2 - Pol(j)
<ALL>    if (jpol .gt. npol .or. jpol .lt. 1) then
<ALL>       write (*,*) 'jsces0: invalid value for polarization: ',
<ALL>&      pol(j)
<ALL>       stop 'jsceso(td,ad): invalid value for polarization'
<ALL>    endif

<LTM>    if (S05(j) .gt. S0min) then
<ADJ>    if (S05(j) .gt. S0min) then
<NLM>       call JscCS0Tb
<LTM>       call JscCS0Tbtl
<ADJ>       call JscCS0Tbad
     C        (s0table%nTheta, s0table%nU, Pi, s0table%lCubic,
     C        s0table%Theta0, s0table%DTheta, s0table%NTheta,
     C        s0table%U0, s0table%DU, s0table%NU,
     C        s0table%Phi0, s0table%DPhi, s0table%NPhi,
     C        s0table%S0Tbl(1, 1, 1, jPol), s0table%S00Tbl(1, jPol),
     I        Theta(j), Azm(j), U(j), D(j),
<PER>T        U5(j), D5(j), S05(j),
     O        S0(j))
<PER>    else
<PER>       S0(j) = 0
<PER>    endif

<NLM>    if (S0(j)  .le. S0min) S0(j) = S0min

  240 enddo

c     ------------------------------------------------------------------

c!##  ERROR HANDLING :

      return
      end
