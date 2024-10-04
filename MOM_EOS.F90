module MOM_EOS

use MOM_EOS_base_type, only : EOS_base

type :: EOS_type
  class(EOS_base), allocatable :: type
end type

contains

subroutine calculate_density_1d(T, S, pressure, rho, EOS)
  !$acc routine
  type(EOS_type), intent(in) :: EOS

  call EOS%type%calculate_density_array()
end subroutine calculate_density_1d

end module MOM_EOS
