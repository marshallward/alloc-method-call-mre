module EOS
use EOS_base_mod, only : EOS_base

implicit none

type :: EOS_type
  class(EOS_base), allocatable :: etype
end type

contains

subroutine calculate_density_1d(EOS)
  !$acc routine
  type(EOS_type), intent(in) :: EOS

  call EOS%etype%calc_density_array()
end subroutine calculate_density_1d

end module EOS
