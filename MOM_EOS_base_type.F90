module MOM_EOS_base_type
implicit none

type, abstract :: EOS_base
  contains
  procedure :: calculate_density_array => a_calculate_density_array
end type EOS_base

contains

subroutine a_calculate_density_array(this)
  class(EOS_base), intent(in) :: this
end subroutine a_calculate_density_array

end module MOM_EOS_base_type
