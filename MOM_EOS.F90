module MOM_EOS

use MOM_EOS_base_type, only : EOS_base

type :: EOS_type
  class(EOS_base), allocatable :: type
end type

contains

subroutine calculate_density_1d(T, S, pressure, rho, EOS)
  !$acc routine
  real, dimension(:),    intent(in)    :: T        !< Potential temperature referenced to the surface [C ~> degC]
  real, dimension(:),    intent(in)    :: S        !< Salinity [S ~> ppt]
  real, dimension(:),    intent(in)    :: pressure !< Pressure [R L2 T-2 ~> Pa]
  real, dimension(:),    intent(inout) :: rho      !< Density (in-situ if pressure is local) [R ~> kg m-3]
  type(EOS_type),        intent(in)    :: EOS      !< Equation of state structure

  ! Local variables
  real :: rho_scale ! A factor to convert density from kg m-3 to the desired units [R m3 kg-1 ~> 1]
  real, dimension(size(rho)) :: pres  ! Pressure converted to [Pa]
  real, dimension(size(rho)) :: Ta    ! Temperature converted to [degC]
  real, dimension(size(rho)) :: Sa    ! Salinity converted to [ppt]

  call EOS%type%calculate_density_array(T, S, pressure, rho)
end subroutine calculate_density_1d

end module MOM_EOS
