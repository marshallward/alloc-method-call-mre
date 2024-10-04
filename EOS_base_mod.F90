module EOS_base_mod
implicit none

type, abstract :: EOS_base
  contains
  procedure :: calc_density_array
end type EOS_base

contains

subroutine calc_density_array(this)
  class(EOS_base), intent(in) :: this
end subroutine calc_density_array

end module EOS_base_mod
