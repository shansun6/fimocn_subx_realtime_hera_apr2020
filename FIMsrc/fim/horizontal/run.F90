!*********************************************************************
! "Run" program for fim global model
! Alexander E. MacDonald  12/24/2005
! J. LEE                  12/28/2005
!*********************************************************************

subroutine run ()
  use module_chem_driver           ,only: chem_run=>chem_driver
  use module_constants
  use module_control               ,only: nip,ntra,ntrb,nabl,itsDFI
  use fimnamelist                  ,only: itsStart,nts,nvl,PrintIpnDiag,	&
                                          digifilt,wts_type,readrestart,	&
                                          restart_freq,addtend,ArchvTimeUnit,	&
                                          dophysics,TimingBarriers,		&
  					  coupled,atmonly,ocnonly
  use module_core_setup            ,only: iam_fim_task
  use module_fim_cpl_run           ,only: cpl_run
  use module_fim_dyn_run           ,only: dyn_run
  use module_fim_phy_run           ,only: phy_run
  use module_initial_chem_namelists,only: chem_opt,mp_physics,cu_physics
  use module_wrf_phy_run           ,only: wrf_phy_run
  use hycom_run,		    only: hycom
  use module_digifilt              ,only: digifilt_wts
  use module_variables,only: u_tdcy,v_tdcy,dp_tdcy,dpl_tdcy,massflx,		&
                           nf,of,vof,us3d,vs3d,dp3d,pr3d,ph3d,ex3d,mp3d,	&
                           tr3d,trdp,trl_tdcy,trc_tdcy,sdot
  use module_savesfc, only: savesfc
  use module_sfc_variables
  use module_hybgen   ,only: hybgen
  use module_fim_phy_init ,only: phy_init
  use restart, only: write_restart
  use global_bounds, only: ips, ipe
  use icosio,only:icosio_out_stop,icosio_stop

  implicit none

#include <gptl.inc>

!SMS$DISTRIBUTE(dh,2) BEGIN
  real, allocatable, dimension(:,:)   :: us3d_f,vs3d_f,dp3d_f
  real, allocatable, dimension(:,:)   :: us3d_s,vs3d_s,dp3d_s
  real, allocatable, dimension(:,:,:) :: tr3d_f
  real, allocatable, dimension(:,:,:) :: tr3d_s
!SMS$DISTRIBUTE END
  real, allocatable, dimension(:) :: wts
  character(len=80) filename

! Local variables:
  integer :: its        ! time step index
  integer :: itsm1
  integer :: itsStart1  ! local itsStart, reset if digifilt = .true. (DFI is used)
  integer :: ipn,ivl,nwts,i,k
  integer :: ret
  real, external :: its2time
  real*8  :: wall1, wall2, usr, sys

  ret = gptlstart ('main_loop')

  !...........................................................
  ! Note that the time-stepping loop has been "phase-shifted" 
  ! to conform to the NCEP ESMF approach in which 
  ! single-phase DYN and PHY run components alternate 
  ! execution during each time step.  Previously, the time 
  ! step loop looked like this:  
  !
  !   do its=itsStart,nts
  !     DYN_1
  !     PHY
  !     DYN_2
  !   enddo
  !
  ! "DYN_1" comprised all calls from the start of the loop 
  ! up to but not including the call to physics().
  !
  ! "PHY" included only the call to physics().  
  !
  ! "DYN_2" comprised all calls after physics() through the 
  ! end of the loop.  
  !
  ! This loop was then "phase-shifted" to look like this:  
  !
  !   do its=itsStart,nts+1
  !     if (its > itsStart) then
  !       DYN_2(its-1)
  !     endif
  !     if (its <= nts) then
  !       DYN_1
  !       PHY
  !     endif
  !   enddo
  !
  ! Here, DYN_2 is run for the previous time-step (its-1) 
  ! while DYN_1 and PHY are run for the current time step 
  ! (its) as before.  
  !
  ! DYN_1 and DYN_2 were then combined into new routine 
  ! dyn_run() and PHY was encapsulated in new routine 
  ! phy_run().  With the "if" statements pushed inside, 
  ! the final result looks like the NCEP approach:  
  !
  !   do its=itsStart,nts+1
  !     call dyn_run(its)
  !     call phy_run(its)
  !   enddo
  !
  ! In all ways the model behaves as it did before these 
  ! changes were made.  The model still iterates through 
  ! nts actual time steps, despite modification of the 
  ! loop uppper bound.  

  ! Checks on things that have not yet been verified to work in restart mode:
  if (readrestart) then
    if (mp_physics > 0 .or. cu_physics > 0) then
      write(6,*)'run: readrestart and wrf_physics (mp_physics or cu_physics) both true does not work. Stopping.'
      call flush(6)
      stop
    end if
  end if

  if (.not.dophysics) then
    addtend = .false.
  endif

  itsStart1 = itsStart

  write(6,*)'run: ntra=', ntra
  write(6,*)'run: ntrb=', ntrb

  if (digifilt) then
! --------------------------------------------
!   Start digital filter initialization (DFI) if requested
! --------------------------------------------
    print *,'DFI being used, should not be in here unless you really want to use it'
    call digifilt_wts(wts,nwts)
  !  for debugging
  !  wts=0.; wts((nwts/2)+1)=1.
    allocate(us3d_f(nvl,nip),vs3d_f(nvl,nip))
    allocate(dp3d_f(nvl,nip))
    allocate(tr3d_f(nvl,nip,ntra+ntrb))  ! 1=pot.temp, 2=water vapor, 3=cloud water, 4=ozone
    allocate(us3d_s(nvl,nip),vs3d_s(nvl,nip))
    allocate(dp3d_s(nvl,nip))
    allocate(tr3d_s(nvl,nip,ntra+ntrb))  ! 1=pot.temp, 2=water vapor, 3=cloud water, 4=ozone

!SMS$PARALLEL (dh,ipn) BEGIN
    do ipn=1,nip
      us3d_f(:,ipn) = 0.
      vs3d_f(:,ipn) = 0.
      dp3d_f(:,ipn) = 0.
      tr3d_f(:,ipn,:) = 0.
    end do
!SMS$PARALLEL END
    if (iam_fim_task) then
      do its=itsDFI,nwts	!   digital filter part
        itsm1 = its - 1
! ---      to start diagnostics in the middle of a run, define PrintIpnDiag here
!          if (its.gt.____) PrintIpnDiag=____
        call dyn_run (its)                     ! Dynamics run method.
        call cpl_run (its, dyn_to_phy=.true.)  ! Coupler run method: dyn->phy
        if (dophysics) then
          call phy_run (its)                   ! physics run method.  
        else
          call nophysics ()                    ! Dummy sets physics tendencies to zero
        end if
        call cpl_run (its, dyn_to_phy=.false.) ! Coupler run method: phy->dyn
! --------------------------------------------
        ! accumulate filtered values during DFI period
! --------------------------------------------
!SMS$PARALLEL (dh,ipn) BEGIN
        do ipn=1,nip
          us3d_f(:,ipn) = us3d_f(:,ipn) + wts(its-itsDFI+1)*us3d(:,ipn)
          vs3d_f(:,ipn) = vs3d_f(:,ipn) + wts(its-itsDFI+1)*vs3d(:,ipn)
          dp3d_f(:,ipn) = dp3d_f(:,ipn) + wts(its-itsDFI+1)*dp3d(:,ipn)
          tr3d_f(:,ipn,:) = tr3d_f(:,ipn,:) + wts(its-itsDFI+1)*tr3d(:,ipn,:)
        end do
! --------------------------------------------
!SMS$PARALLEL END
        if (its-itsDFI+1 == (nwts/2)+1) then ! center of filter window
!SMS$PARALLEL (dh,ipn) BEGIN
          do ipn=1,nip
            us3d_s(:,ipn) = us3d(:,ipn)
            vs3d_s(:,ipn) = vs3d(:,ipn) 
            dp3d_s(:,ipn) = dp3d(:,ipn) 
            tr3d_s(:,ipn,:) = tr3d(:,ipn,:)
          end do
!SMS$PARALLEL END
! --------------------------------------------
         !    save sfc variables at center of filter window.
! --------------------------------------------
          filename = 'gfsfc.dat'
          print*,'calling savesfc',trim(filename)
          call savesfc(filename)
!sms$serial (<us3d,vs3d,dp3d,tr3d,st3d,in>:default=ignore) begin
          print *,'before digital filter: wt = ',its-itsDFI+1,wts(its-itsDFI+1)
          print *,'min/max us3d',minval(us3d),maxval(us3d)
          print *,'min/max vs3d',minval(vs3d),maxval(vs3d)
          print *,'min/max dp3d',minval(dp3d),maxval(dp3d)
          print *,'min/max tr3d(1)',minval(tr3d(:,:,1)),maxval(tr3d(:,:,1))
          print *,'min/max st3d(1)',minval(st3d(1,:)),maxval(st3d(1,:))
          print *,'min/max st3d(4)',minval(st3d(4,:)),maxval(st3d(4,:))
!sms$serial end
        end if ! end save state at middle of digital filter window

        if (chem_opt > 0) then
          call wrf_phy_run (its)  ! physics run method
          call chem_run (its)     ! chemistry run method.  
        end if
        call icosio_out_stop(itsm1) ! signal end of output event
      end do ! time step loop

!     replace variables with filter variables, reset time setup counter
!     to center of filter window.
      itsDFI = itsDFI + (nwts/2) + 1  ! nwts must be odd integer.
!SMS$PARALLEL (dh,ipn) BEGIN
      do ipn=1,nip
        us3d(:,ipn) = us3d_f(:,ipn)
        vs3d(:,ipn) = vs3d_f(:,ipn) 
        dp3d(:,ipn) = dp3d_f(:,ipn)
        tr3d(:,ipn,:) = tr3d_f(:,ipn,:)
        us3d_s(:,ipn) = us3d_s(:,ipn) - us3d(:,ipn)
        vs3d_s(:,ipn) = vs3d_s(:,ipn) - vs3d(:,ipn)
        dp3d_s(:,ipn) = dp3d_s(:,ipn) - dp3d(:,ipn)
        tr3d_s(:,ipn,:) = tr3d_s(:,ipn,:) - tr3d(:,ipn,:)
        do ivl=1,nvl
          tr3d(ivl  ,ipn,2) = max(qvmin,tr3d(ivl,ipn,2))
          tr3d(ivl  ,ipn,3) = max(0.   ,tr3d(ivl,ipn,3))
          tr3d(ivl  ,ipn,4) = max(0.   ,tr3d(ivl,ipn,4))
        end do
      end do
!     diagnose pressure, exner, mont. pot and geopot.
      do ipn=1,nip              !  global icos loop
        do ivl=nvl,1,-1         ! loop through layers (top-down for p,ex,omega)
          pr3d(ivl,ipn) = pr3d(ivl+1,ipn) + dp3d(ivl,ipn)
          ex3d(ivl,ipn) = cp*(pr3d(ivl,ipn)/p1000)**(rd/cp)
          do i=1,ntra+ntrb
            trdp(ivl,ipn,i) = tr3d(ivl,ipn,i)*dp3d(ivl,ipn)
          end do
        end do
      end do
!SMS$PARALLEL END
!sms$serial (<us3d,vs3d,dp3d,st3d,pr3d,ph3d,tr3d,us3d_s,vs3d_s,dp3d_s,tr3d_s,in>:default=ignore) begin
      print *,'after digital filter: reset its to',itsDFI
      print *,'min/max us3d',minval(us3d),maxval(us3d)
      print *,'min/max vs3d',minval(vs3d),maxval(vs3d)
      print *,'min/max dp3d',minval(dp3d),maxval(dp3d)
      print *,'min/max st3d(1)',minval(st3d(1,:)),maxval(st3d(1,:))
      print *,'min/max st3d(4)',minval(st3d(4,:)),maxval(st3d(4,:))
      print *,'min/max pr3d',minval(pr3d),maxval(pr3d)
      print *,'min/max ph3d',minval(ph3d),maxval(ph3d)
      print *,'min/max tr3d(1)',minval(tr3d(:,:,1)),maxval(tr3d(:,:,1))
      print *,'min/max us3d diff',minval(us3d_s),maxval(us3d_s)
      print *,'min/max vs3d diff',minval(vs3d_s),maxval(vs3d_s)
      print *,'min/max dp3d diff',minval(dp3d_s),maxval(dp3d_s)
      print *,'min/max tr3d(1) diff',minval(tr3d_s(:,:,1)),maxval(tr3d_s(:,:,1))
!sms$serial end
      call hybgen(itsDFI-1,		&
              thetac,			& ! target pot.temperature
              us3d,vs3d,tr3d,		& ! zonal, meridional wind, mass field tracers
              sdot,ex3d,dp3d,pr3d,TimingBarriers) ! intfc displ., exner, lyr thknss, pressure
!SMS$PARALLEL (dh,ipn) BEGIN
      do ipn=1,nip		!  global icos loop
        mp3d(1,ipn) = ex3d(1,ipn)*tr3d(1,ipn,1) + ph3d(1,ipn)	! mont pot, layer 1
        ph3d(2,ipn) = mp3d(1,ipn) - tr3d(1,ipn,1)*ex3d(2,ipn)	! geopot, level 2
        do k=2,nvl		!  vertical loop
          mp3d(k,ipn) = mp3d(k-1,ipn) + ex3d(k,ipn)*(tr3d(k,ipn,1)-tr3d(k-1,ipn,1))
          ph3d(k+1,ipn) = mp3d(k,ipn) - tr3d(k,ipn,1)*ex3d(k+1,ipn)
        end do
      end do
!     re-initialize forcing arrays
      do ipn=1,nip
        u_tdcy(:,ipn,:)   = 0. ! u forcing
        v_tdcy(:,ipn,:)   = 0.	! v forcing
        dp_tdcy(:,ipn,:)  = 0.     ! dp forcing
        dpl_tdcy(:,ipn,:) = 0.     ! low order forcing
        trc_tdcy(:,ipn,:,:) = 0.     ! tracer forcing
        trl_tdcy(:,ipn,:,:) = 0.     ! tracer forcing low order
      end do
!SMS$PARALLEL END
! initial Adams-Bashforth indexes
      nf  = 0	! "new field" index 
      of  = 2	! "old field" index
      vof = 1	! "very old field" index
! re-initialize physics (re-read surface file to get values at center of filter
! window)
      call phy_init ()
! clean up.
      deallocate(wts,us3d_f,vs3d_f,dp3d_f,tr3d_f)
      deallocate(us3d_s,vs3d_s,dp3d_s,tr3d_s)
    end if
  itsStart1=itsDFI
  end if     ! digifilt=.true.
!  Digital filter initialization is complete (if used)

!SMS$EXCHANGE(dp_tdcy(:,:,1:nabl))

! --------------------------------------------
!  Start main forward integration
! --------------------------------------------
  if (iam_fim_task) then
! Phony loop to verify threading configuration--needed since default timing is
! zero calls inside of threaded loops
!sms$ignore begin
!$OMP PARALLEL DO PRIVATE (ret) SCHEDULE (static)
    do ipn=ips,ipe
      ret = gptlstart ('threading')
      ret = gptlstop ('threading')
    end do
!$OMP END PARALLEL DO
!sms$ignore end

    do its=itsStart1,itsStart+nts ! its=index time step, nts = num time steps
      ret = gptlstamp (wall1, usr, sys)
      itsm1 = its - 1

! Write a restart file if it's time
      if (its > itsStart1 .and. mod (itsm1, restart_freq) == 0) then
        call write_restart (itsm1)
      end if

! --- to start diagnostics in the middle of a run, define PrintIpnDiag here
!     if (its.gt.____) PrintIpnDiag=____

      if (coupled .or. atmonly) then		! coupled or amip run

        call dyn_run (its)			! Dynamics run method.  
        call cpl_run (its, dyn_to_phy=.true.)	! Coupler run method: dyn->phy
        if (dophysics) then
          call phy_run (its)			! Physics run method.
        else
          call nophysics ()			! Dummy sets physics tendencies to zero
        end if
        call cpl_run (its, dyn_to_phy=.false.)	! Coupler run method: phy->dyn

        if (mp_physics > 0 .or. cu_physics > 0) then
          call wrf_phy_run (its)		! physics run method.  
        end if

        if (chem_opt > 0) then
          call chem_run (its)			! chemistry run method.  
        end if

      endif					! coupled or amip run
      !...........................................................
      ! Call ocean
      !...........................................................
      if (coupled.or.ocnonly) call hycom (its)	! amip run doesn't call hycom

      call icosio_out_stop(itsm1)
      ret = gptlstamp (wall2, usr, sys)
      print "('its=',i8,4x,a,'=',f8.2,a,f9.3)", its, ArchvTimeUnit,	&
        its2time(its), '   time(s)=', wall2-wall1
    end do ! time step loop
    call icosio_stop(itsm1) ! shut down write task(s)
  end if

  ret = gptlstop ('main_loop')

  return
end subroutine run
