module MOM_EOS_base_type

type, abstract :: EOS_base
  contains
  procedure(i_density_elem), deferred :: density_elem
  procedure(i_density_anomaly_elem), deferred :: density_anomaly_elem
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

  real elemental function i_density_anomaly_elem(this, T, S, pressure, rho_ref)
    import :: EOS_base
    class(EOS_base), intent(in) :: this     !< This EOS
    real,            intent(in) :: T        !< Potential temperature relative to the surface [degC]
    real,            intent(in) :: S        !< Salinity [PSU]
    real,            intent(in) :: pressure !< Pressure [Pa]
    real,            intent(in) :: rho_ref  !< A reference density [kg m-3]

  end function i_density_anomaly_elem
end interface

contains

!> Calculate the in-situ density for 1D arraya inputs and outputs.
subroutine a_calculate_density_array(this, T, S, pressure, rho, start, npts, rho_ref)
  class(EOS_base), intent(in) :: this     !< This EOS
  real, dimension(:), intent(in)  :: T        !< Potential temperature relative to the surface [degC]
  real, dimension(:), intent(in)  :: S        !< Salinity [PSU]
  real, dimension(:), intent(in)  :: pressure !< Pressure [Pa]
  real, dimension(:), intent(out) :: rho      !< In situ density [kg m-3]
  integer,            intent(in)  :: start    !< The starting index for calculations
  integer,            intent(in)  :: npts     !< The number of values to calculate
  real,     optional, intent(in)  :: rho_ref  !< A reference density [kg m-3]

  ! Local variables
  integer :: js, je

  js = start
  je = start+npts-1

  if (present(rho_ref)) then
    rho(js:je) = this%density_anomaly_elem(T(js:je), S(js:je), pressure(js:je), rho_ref)
  else
    rho(js:je) = this%density_elem(T(js:je), S(js:je), pressure(js:je))
  endif

end subroutine a_calculate_density_array

end module MOM_EOS_base_type
