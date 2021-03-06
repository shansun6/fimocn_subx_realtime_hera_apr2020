MODULE MODULE_WRFPHYSVARS

   IMPLICIT NONE

!
! the next are variables that chemdriver will need
!
   REAL, ALLOCATABLE :: moist( :, :, :, : )
   REAL, ALLOCATABLE :: scalar( :, :, :, : )
   REAL, ALLOCATABLE :: tsk( :, :)
   REAL, ALLOCATABLE :: dxy( :, :)
   REAL, ALLOCATABLE :: rri( : , : , : )
   REAL, ALLOCATABLE :: t_phy( : , : , : )
   REAL, ALLOCATABLE :: th_phy( : , : , : )
   REAL, ALLOCATABLE :: p_phy( : , : , : )
   REAL, ALLOCATABLE :: pi_phy( : , : , : )
   REAL, ALLOCATABLE :: dz8w( : , : , : )
   REAL, ALLOCATABLE :: t8w( : , : , : )
   REAL, ALLOCATABLE :: p8w( : , : , : )
   REAL, ALLOCATABLE :: z_at_w ( : , : , : )
   REAL, ALLOCATABLE :: zmid ( : , : , : )
   REAL, ALLOCATABLE :: u_phy( : , : , : )
   REAL, ALLOCATABLE :: v_phy( : , : , : )
   REAL, ALLOCATABLE :: vvel( : , : , : )
   REAL, ALLOCATABLE :: rho_phy( : , : , : )
   REAL, ALLOCATABLE :: exch_h( : , : , : )
   REAL, ALLOCATABLE :: cldfra( : , : , : )
   REAL, ALLOCATABLE :: rqvcuten( : , : , : )
   REAL, ALLOCATABLE :: rqvblten( : , : , : )
   REAL, ALLOCATABLE :: rqvften( : , : , : )
   REAL, ALLOCATABLE :: rthcuten( : , : , : )
   REAL, ALLOCATABLE :: rucuten( : , : , : )
   REAL, ALLOCATABLE :: rvcuten( : , : , : )
   REAL, ALLOCATABLE :: rthblten( : , : , : )
   REAL, ALLOCATABLE :: rthraten( : , : , : )
   REAL, ALLOCATABLE :: rthratenlw( : , : , : )
   REAL, ALLOCATABLE :: rthratensw( : , : , : )
   REAL, ALLOCATABLE :: rthften( : , : , : )
   REAL, ALLOCATABLE :: rqrcuten( : , : , : )
   REAL, ALLOCATABLE :: rqccuten( : , : , : )
   REAL, ALLOCATABLE :: rqscuten( : , : , : )
   REAL, ALLOCATABLE :: rqicuten( : , : , : )
   REAL, ALLOCATABLE :: rqgcuten( : , : , : )
   INTEGER, ALLOCATABLE :: ivgtyp( : , : )
   INTEGER, ALLOCATABLE :: isltyp( : , : )
   REAL, ALLOCATABLE :: u10( : , : )
   REAL, ALLOCATABLE :: v10( : , : )
   REAL, ALLOCATABLE :: gsw( : , : )
   REAL, ALLOCATABLE :: glw( : , : )
   REAL, ALLOCATABLE :: sr( : , : )
   REAL, ALLOCATABLE :: pbl( : , : )
   REAL, ALLOCATABLE :: hfx( : , : )
   REAL, ALLOCATABLE :: qfx( : , : )
   REAL, ALLOCATABLE :: vegfra( : , : )
   REAL, ALLOCATABLE :: rmol( : , : )
   REAL, ALLOCATABLE :: ust( : , : )
   REAL, ALLOCATABLE :: xland( : , : )
   REAL, ALLOCATABLE :: xlat( : , : )
   REAL, ALLOCATABLE :: xlong( : , : )
   REAL, ALLOCATABLE :: znt( : , : )
   REAL, ALLOCATABLE :: ht( : , : )
   REAL, ALLOCATABLE :: alb_uvb( : , : )
   REAL, ALLOCATABLE :: alb_uvd( : , : )
   REAL, ALLOCATABLE :: alb_irb( : , : )
   REAL, ALLOCATABLE :: alb_ird( : , : )
   REAL, ALLOCATABLE :: sfc_emiss( : , : )
   REAL, ALLOCATABLE :: swcf( : , : )
   REAL, ALLOCATABLE :: lwcf( : , : )
   REAL, ALLOCATABLE :: gsw_net( : , : )
   REAL, ALLOCATABLE :: snowh( : , : )
   REAL, ALLOCATABLE :: xice( : , : )
! for convective schemes
   REAL, ALLOCATABLE :: rainc( : , : )
   REAL, ALLOCATABLE :: apr_gr( : , : )
   REAL, ALLOCATABLE :: apr_w( : , : )
   REAL, ALLOCATABLE :: apr_mc( : , : )
   REAL, ALLOCATABLE :: apr_as( : , : )
   REAL, ALLOCATABLE :: apr_st( : , : )
   REAL, ALLOCATABLE :: apr_capma( : , : )
   REAL, ALLOCATABLE :: apr_capme( : , : )
   REAL, ALLOCATABLE :: apr_capmi( : , : )
   REAL, ALLOCATABLE :: mass_flux( : , : )
   REAL, ALLOCATABLE :: cugd_tten( : , : , : )
   REAL, ALLOCATABLE :: cugd_ttens( : , : , : )
   REAL, ALLOCATABLE :: cugd_qvten( : , : , : )
   REAL, ALLOCATABLE :: cugd_qcten( : , : , : )
   REAL, ALLOCATABLE :: cugd_qvtens( : , : , : )
   REAL, ALLOCATABLE :: gd_cloud( : , : , : )
   REAL, ALLOCATABLE :: gd_cloud2( : , : , : )
   REAL, ALLOCATABLE :: raincv( : , : )
! end convective schemes
   REAL, ALLOCATABLE :: rainnc( : , : )
   REAL, ALLOCATABLE :: rainncv( : , : )
   REAL, ALLOCATABLE :: snownc( : , : )
   REAL, ALLOCATABLE :: snowncv( : , : )
   REAL, ALLOCATABLE :: graupelnc( : , : )
   REAL, ALLOCATABLE :: graupelncv( : , : )
  REAL, ALLOCATABLE :: smois( :, :, : )
END MODULE MODULE_WRFPHYSVARS
