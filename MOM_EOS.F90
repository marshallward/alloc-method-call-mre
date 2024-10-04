module MOM_EOS

use MOM_EOS_base_type, only : EOS_base

type :: EOS_type
  ! Unit conversion factors (normally used for dimensional testing but could also allow for
  ! change of units of arguments to functions)
  real :: m_to_Z = 1.      !< A constant that translates distances in meters to the units of depth [Z m-1 ~> 1]
  real :: kg_m3_to_R = 1.  !< A constant that translates kilograms per meter cubed to the
                           !! units of density [R m3 kg-1 ~> 1]
  real :: R_to_kg_m3 = 1.  !< A constant that translates the units of density to
                           !! kilograms per meter cubed [kg m-3 R-1 ~> 1]
  real :: RL2_T2_to_Pa = 1.!< Convert pressures from R L2 T-2 to Pa [Pa T2 R-1 L-2 ~> 1]
  real :: L_T_to_m_s = 1.  !< Convert lateral velocities from L T-1 to m s-1 [m T s-1 L-1 ~> 1]
  real :: degC_to_C = 1.   !< A constant that translates degrees Celsius to the units of temperature [C degC-1 ~> 1]
  real :: C_to_degC = 1.   !< A constant that translates the units of temperature to degrees Celsius [degC C-1 ~> 1]
  real :: ppt_to_S = 1.    !< A constant that translates parts per thousand to the units of salinity [S ppt-1 ~> 1]
  real :: S_to_ppt = 1.    !< A constant that translates the units of salinity to parts per thousand [ppt S-1 ~> 1]

  class(EOS_base), allocatable :: type
end type

contains

subroutine calculate_density_1d(T, S, pressure, rho, EOS, dom, rho_ref, scale)
  !$acc routine
  real, dimension(:),    intent(in)    :: T        !< Potential temperature referenced to the surface [C ~> degC]
  real, dimension(:),    intent(in)    :: S        !< Salinity [S ~> ppt]
  real, dimension(:),    intent(in)    :: pressure !< Pressure [R L2 T-2 ~> Pa]
  real, dimension(:),    intent(inout) :: rho      !< Density (in-situ if pressure is local) [R ~> kg m-3]
  type(EOS_type),        intent(in)    :: EOS      !< Equation of state structure
  integer, dimension(2), optional, intent(in) :: dom   !< The domain of indices to work on, taking
                                                       !! into account that arrays start at 1.
  real,                  optional, intent(in) :: rho_ref !< A reference density [R ~> kg m-3]
  real,                  optional, intent(in) :: scale !< A multiplicative factor by which to scale density
                                                   !! in combination with scaling stored in EOS [various]
  ! Local variables
  real :: rho_scale ! A factor to convert density from kg m-3 to the desired units [R m3 kg-1 ~> 1]
  real, dimension(size(rho)) :: pres  ! Pressure converted to [Pa]
  real, dimension(size(rho)) :: Ta    ! Temperature converted to [degC]
  real, dimension(size(rho)) :: Sa    ! Salinity converted to [ppt]
  integer :: i, is, ie, npts

  if (present(dom)) then
    is = dom(1) ; ie = dom(2) ; npts = 1 + ie - is
  else
    is = 1 ; ie = size(rho) ; npts = 1 + ie - is
  endif

  if ((EOS%RL2_T2_to_Pa == 1.0) .and. (EOS%R_to_kg_m3 == 1.0) .and. &
      (EOS%C_to_degC == 1.0) .and. (EOS%S_to_ppt == 1.0)) then
    call EOS%type%calculate_density_array(T, S, pressure, rho, is, npts, rho_ref=rho_ref)
  else ! This is the same as above, but with some extra work to rescale variables.
    do i=is,ie
      pres(i) = EOS%RL2_T2_to_Pa * pressure(i)
      Ta(i) = EOS%C_to_degC * T(i)
      Sa(i) = EOS%S_to_ppt * S(i)
    enddo
    if (present(rho_ref)) then
      call EOS%type%calculate_density_array(Ta, Sa, pres, rho, is, npts, rho_ref=EOS%R_to_kg_m3*rho_ref)
    else
      call EOS%type%calculate_density_array(Ta, Sa, pres, rho, is, npts)
    endif
  endif

  rho_scale = EOS%kg_m3_to_R
  if (present(scale)) rho_scale = rho_scale * scale
  if (rho_scale /= 1.0) then ; do i=is,ie
    rho(i) = rho_scale * rho(i)
  enddo ; endif

end subroutine calculate_density_1d

end module MOM_EOS
