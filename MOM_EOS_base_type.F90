module MOM_EOS_base_type

type, abstract :: EOS_base
  contains
  procedure(i_density_elem), deferred :: density_elem
  procedure :: calculate_density_array => a_calculate_density_array
end type EOS_base

interface
  real elemental function i_density_elem(this, T, S, pressure)
    import :: EOS_base
    class(EOS_base), intent(in) :: this     !< This EOS
    real,            intent(in) :: T        !< Potential temperature relative to the surface [degC]
    real,            intent(in) :: S        !< Salinity [PSU]
    real,            intent(in) :: pressure !< Pressure [Pa]
  end function i_density_elem
end interface

contains

!> Calculate the in-situ density for 1D arraya inputs and outputs.
!subroutine a_calculate_density_array(this, T, S, pressure, rho, start, npts)
subroutine a_calculate_density_array(this, T, S, pressure, rho)
  class(EOS_base), intent(in) :: this     !< This EOS
  real, dimension(:), intent(in)  :: T        !< Potential temperature relative to the surface [degC]
  real, dimension(:), intent(in)  :: S        !< Salinity [PSU]
  real, dimension(:), intent(in)  :: pressure !< Pressure [Pa]
  real, dimension(:), intent(out) :: rho      !< In situ density [kg m-3]

  rho(:) = this%density_elem(T(:), S(:), pressure(:))
end subroutine a_calculate_density_array

end module MOM_EOS_base_type
