;
load "$NCARG_ROOT/lib/ncarg/nclex/gsun/gsn_code.ncl"
load "$NCARG_LIB/ncarg/nclscripts/csm/contributed.ncl"
modl = getenv("MODL")
disclaimer = " Not For Official Guidance"
;
load "$NCL_HOME/obj/cmap3.ncl"
;
begin
;
airport_id = asciiread("$NCL_HOME/Airports_id.txt",-1,"string")
airport_loc = asciiread("$NCL_HOME/Airports_locs.txt",(/dimsizes(airport_id),2/),"float")
;
fname = asciiread("arw_file.txt",-1,"string")
grb_file = addfile(fname,"r")
;
domainname = asciiread("domain.txt",-1,"string")
;
load "$NCL_HOME/obj/fim_grib_names.ncl"
;
; Get the 500mb level index
;
do ll = 0,5
  lnam = "lv_ISBL"+ll
  if (isfilevar(grb_file,lnam)) then
    break
  end if
end do
;
levnam = grb_file->$lnam$
levunits = grb_file->$lnam$@units
if (levunits .eq. "Pa") then
  levnam = levnam / 100
end if
do ii = 0, dimsizes(levnam)-1
  if (levnam(ii) .eq. 500) then
    level = ii
    break
  end if
end do
;
if (domainname .eq. "fim") then
;
  ny = filevardimsizes(grb_file,LAT)
  nx = filevardimsizes(grb_file,LON)
;
  intm = grb_file->$TSFC$@initial_time
  fctm = grb_file->$TSFC$@forecast_time
  lat = grb_file->$LAT$(:)
  lon = grb_file->$LON$(:)
  tvar = grb_file->$VBDSF$(0,:,:)
  hvar = grb_file->$GHISBL$(level,:,:) / 10. ; use decameters
  hybhvar = grb_file->$GHNAT$(:,:,:) * 3.28084 ; convert to feet
  wstrid = 10
  dis_opos = 0.13
;
  uvar = grb_file->$U10M$(:,:) * 1.9429 ; convert to knots
  vvar = grb_file->$V10M$(:,:) * 1.9429 ; convert to knots
;
end if
;
if (domainname .eq. "129") then
;
  ny = filevardimsizes(grb_file,LAT)
  nx = filevardimsizes(grb_file,LON)
;
  intm = grb_file->$TSFC$@initial_time
  fctm = grb_file->$TSFC$@forecast_time
  lat = grb_file->$LAT$(:)
  lon = grb_file->$LON$(:)
  tvar = grb_file->$VBDSF$(0,:,:)
  hvar = grb_file->$GHISBL$(level,:,:) / 10. ; use decameters
  hybhvar = grb_file->$GHNAT$(:,:,:) * 3.28084 ; convert to feet
  wstrid = 20
  dis_opos = 0.13
;
  uvar = grb_file->$U10M$(:,:) * 1.9429 ; convert to knots
  vvar = grb_file->$V10M$(:,:) * 1.9429 ; convert to knots
;
end if
;
if (domainname .eq. "83") then
;
  fimsizes = filevardimsizes(grb_file,LAT)
  ny = fimsizes(0)
  nx = fimsizes(1)
;
  intm = grb_file->$TSFC$@initial_time
  fctm = grb_file->$TSFC$@forecast_time
  lat = grb_file->$LAT$(:,:)
  lon = grb_file->$LON$(:,:)
  tvar = grb_file->$VBDSF$(0,:,:)
  hvar = grb_file->$GHISBL$(level,:,:) / 10. ; use decameters
  hybhvar = grb_file->$GHNAT$(:,:,:) * 3.28084 ; convert to feet
  wstrid = 10
  dis_opos = 0.13
;
  uvar = grb_file->$U10M$(:,:) * 1.9429 ; convert to knots
  vvar = grb_file->$V10M$(:,:) * 1.9429 ; convert to knots
;
end if
;
if (domainname .eq. "130") then
;
  fimsizes = filevardimsizes(grb_file,LAT)
  ny = fimsizes(0)
  nx = fimsizes(1)
;
  intm = grb_file->$TSFC$@initial_time
  fctm = grb_file->$TSFC$@forecast_time
  lat = grb_file->$LAT$(:,:)
  lon = grb_file->$LON$(:,:)
  latin1 = grb_file->$LON$@Latin1
  latin2 = grb_file->$LON$@Latin2
  lov = grb_file->$LON$@Lov
  tvar = grb_file->$VBDSF$(0,:,:)
  hvar = grb_file->$GHISBL$(level,:,:) / 10. ; use decameters
  hybhvar = grb_file->$GHNAT$(:,:,:) * 3.28084 ; convert to feet
  wstrid = 6
  dis_opos = 0.09
;
  uvar = grb_file->$U10M$(:,:) * 1.9429 ; convert to knots
  vvar = grb_file->$V10M$(:,:) * 1.9429 ; convert to knots
;
end if
;
if (domainname .eq. "236") then
;
  fimsizes = filevardimsizes(grb_file,LAT)
  ny = fimsizes(0)
  nx = fimsizes(1)
;
  intm = grb_file->$TSFC$@initial_time
  fctm = grb_file->$TSFC$@forecast_time
  lat = grb_file->$LAT$(:,:)
  lon = grb_file->$LON$(:,:)
  latin1 = grb_file->$LON$@Latin1
  latin2 = grb_file->$LON$@Latin2
  lov = grb_file->$LON$@Lov
  tvar = grb_file->$VBDSF$(0,:,:)
  hvar = grb_file->$GHISBL$(level,:,:) / 10. ; use decameters
  hybhvar = grb_file->$GHNAT$(:,:,:) * 3.28084 ; convert to feet
  wstrid = 3
  dis_opos = 0.09
;
  uvar = grb_file->$U10M$(:,:) * 1.9429 ; convert to knots
  vvar = grb_file->$V10M$(:,:) * 1.9429 ; convert to knots
;
end if
;
if (domainname .eq. "africa" .or. domainname .eq. "europe" .or. \
    domainname .eq. "w_pacific" .or. domainname .eq. "floating" .or. \
    domainname .eq. "e_pacific") then
;
  nx = filevardimsizes(grb_file,LON)
  ny = filevardimsizes(grb_file,LAT)
;
  intm = grb_file->$TSFC$@initial_time
  fctm = grb_file->$TSFC$@forecast_time
  lat = grb_file->$LAT$(:)
  lon = grb_file->$LON$(:)
  tvar = grb_file->$VBDSF$(0,:,:)
  hvar = grb_file->$GHISBL$(level,:,:) / 10. ; use decameters
  hybhvar = grb_file->$GHNAT$(:,:,:) * 3.28084 ; convert to feet
  wstrid = 5
  if (domainname .eq. "floating") then
    wstrid = 2
    dis_opos = 0.067
  end if
  if (domainname .eq. "w_pacific" .or. domainname .eq. "e_pacific") then
    wstrid = 7
    dis_opos = 0.117
  end if
  if (domainname .eq. "europe") then
    dis_opos = 0.117
  end if
  if (domainname .eq. "africa") then
    dis_opos = 0.09
  end if
;
  uvar = grb_file->$U10M$(:,:) * 1.9429 ; convert to knots
  vvar = grb_file->$V10M$(:,:) * 1.9429 ; convert to knots
;
end if
;
if (domainname .eq. "201") then
;
  fimsizes = filevardimsizes(grb_file,LAT)
  ny = fimsizes(0)
  nx = fimsizes(1)
;
  intm = grb_file->$TSFC$@initial_time
  fctm = grb_file->$TSFC$@forecast_time
  lat = grb_file->$LAT$(:,:)
  lon = grb_file->$LON$(:,:)
  tvar = grb_file->$VBDSF$(0,:,:)
  hvar = grb_file->$GHISBL$(level,:,:) / 10. ; use decameters
  hybhvar = grb_file->$GHNAT$(:,:,:) * 3.28084 ; convert to feet
  uvartmp = grb_file->$U10M$(:,:)
  vvartmp = grb_file->$V10M$(:,:)
;
  rot = grb_file->$ROT$(:,:)
;
  ugrid = cos(rot)*uvartmp - sin(rot)*vvartmp
  vgrid = sin(rot)*uvartmp + cos(rot)*vvartmp
;
  uvar = ugrid * 1.9429 ; convert to knots
  vvar = vgrid * 1.9429 ; convert to knots
;
  uv2 = uvar * uvar
  vv2 = vvar * vvar
  tvar = sqrt(uv2 + vv2)
  wstrid = 4
  dis_opos = 0.068
;
end if
;
if (domainname .eq. "28") then
;
  fimsizes = filevardimsizes(grb_file,LAT)
  ny = fimsizes(0)
  nx = fimsizes(1)
;
  intm = grb_file->$TSFC$@initial_time
  fctm = grb_file->$TSFC$@forecast_time
  lat = grb_file->$LAT$(:,:)
  lon = grb_file->$LON$(:,:)
  tvar = grb_file->$VBDSF$(0,:,:)
  hvar = grb_file->$GHISBL$(level,:,:) / 10. ; use decameters
  hybhvar = grb_file->$GHNAT$(:,:,:) * 3.28084 ; convert to feet
  wstrid = 2
  dis_opos = 0.068
;
  uvar = grb_file->$U10M$(:,:) * 1.9429 ; convert to knots
  vvar = grb_file->$V10M$(:,:) * 1.9429 ; convert to knots
  uvar = -uvar
  vvar = -vvar
;
end if
;
if (domainname .eq. "244") then
;
  ny = filevardimsizes(grb_file,LAT)
  nx = filevardimsizes(grb_file,LON)
;
  intm = grb_file->$TSFC$@initial_time
  fctm = grb_file->$TSFC$@forecast_time
  lat = grb_file->$LAT$(:)
  lon = grb_file->$LON$(:)
  tvar = grb_file->$VBDSF$(0,:,:)
  hvar = grb_file->$GHISBL$(level,:,:) / 10. ; use decameters
  hybhvar = grb_file->$GHNAT$(:,:,:) * 3.28084 ; convert to feet
  wstrid = 7
  dis_opos = 0.095
;
  uvar = grb_file->$U10M$(:,:) * 1.9429 ; convert to knots
  vvar = grb_file->$V10M$(:,:) * 1.9429 ; convert to knots
;
end if
;
print("min tvar = "+min(tvar))
print("max tvar = "+max(tvar))
;
;tvar = tvar * 10.
do ii = 0,nx-1
  do jj = 0,ny-1
    if (.not.ismissing(tvar(jj,ii))) then
      if (tvar(jj,ii) .lt. 2.) then
        tvar(jj,ii) = 1.
      end if
    end if
  end do
end do
tvar = log10(tvar)
;
print("min tvar after log10 = "+min(tvar))
print("max tvar after log10 = "+max(tvar))
;
load "$NCL_HOME/obj/get_date_str_FIM.ncl"
;
print(date_str) 
print("Sfc Cs2")
print(min(tvar))
print(max(tvar))
;print("500 mb hvar")
;print(min(hvar))
;print(max(hvar))
;
if (max(tvar) .eq. 0) then  ; constant zero field
  tvar(0,0) = 0.11 ; set the ll corner point so it makes a plot anyway
;  exit
end if
;
xdim = nx - 1
ydim = ny - 1
rnx = 1.*xdim
rny = 1.*ydim
if (rny .ge. rnx) then
  vpheight = .88
  vpy = 1.-((1.-vpheight)/2.)
  vpwidth = (vpheight/rny)*rnx
  vpx = (1.-((vpheight/rny)*rnx))/2.
else
  vpwidth = .88
  vpx = (1.-vpwidth)/2.
  vpheight = (vpwidth/rnx)*rny
  vpy = 1.-((1.-((vpwidth/rnx)*rny))/2.)
end if
;
; Create an application object.
;
appid = create "mdss" appClass defaultapp
    "appUsrDir" : "./"
    "appDefaultParent" : True
end create
;
; Set only one of the following three params to 1, depending on the type
; of output desired (NCGM=metacode file, X11=screen, PS=PostScript file)
;
    NCGM=1
    X11=0
    PS=0
;
    if (NCGM .eq. 1) then
;
; Create an ncgmWorkstation object.
;
        wid = create "mdssWork" ncgmWorkstationClass defaultapp
           "wkMetaName" : "./sfc_Cs2.ncgm"
        end create
    else
      if (X11 .eq. 1) then
;
; Create an XWorkstation object.
;
        wid = create "mdssWork" xWorkstationClass defaultapp
            "wkPause" : True
        end create
      else
        if (PS .eq. 1) then
;
; Create a PSWorkstation object.
;
          wid = create "mdssWork" psWorkstationClass defaultapp
           "wkPSFileName" : "./sfc_Cs2.ps"
          end create
        end if
      end if
    end if
;
; Assign the colormap to the workstation.
setvalues wid
   "wkColorMap" : gen_colormap()
end setvalues
;
setvalues NhlGetWorkspaceObjectId()
   "wsMaximumSize": 247108864
end setvalues
;
; Create a ScalarField object.
;
if (domainname .eq. "130") then
;
  load "$NCL_HOME/obj/ruc_tiles_loop.ncl"
;
;  if (min(tvar(lly,llx)) .eq. 0 .and. max(tvar(lly,llx)) .eq. 0) then
;    tvar(lly,llx) = .001
;  end if
;
  if (iq .eq. 0) then
    load "$NCL_HOME/obj/lambert_conformal_map_blk.ncl"
  else
    load "$NCL_HOME/obj/lc_map_counties.ncl"
    setvalues mpid
      "mpNationalLineColor" : "background"
    end setvalues
  end if
;
  tfield = create "ScalarField" scalarFieldClass appid
      "sfDataArray" : tvar
      "sfXCStartSubsetV" : llx
      "sfYCStartSubsetV" : lly
      "sfXCEndSubsetV" : urx
      "sfYCEndSubsetV" : ury
      "sfMissingValueV" : tvar@_FillValue
  end create
;
  hfield = create "ScalarField" scalarFieldClass appid
      "sfDataArray" : hvar
      "sfXCStartSubsetV" : llx
      "sfYCStartSubsetV" : lly
      "sfXCEndSubsetV" : urx
      "sfYCEndSubsetV" : ury
      "sfMissingValueV" : hvar@_FillValue
  end create
;
  if (iq .eq. 0) then
    vfield = create "VectorField" vectorFieldClass appid
      "vfUDataArray" : uvar
      "vfVDataArray" : vvar
      "vfXCStartSubsetV" : llx
      "vfYCStartSubsetV" : lly
      "vfXCEndSubsetV" : urx
      "vfYCEndSubsetV" : ury
      "vfMissingVValueV" : vvar@_FillValue
      "vfMissingUValueV" : uvar@_FillValue
      "vfXCStride" : 7          ; i.e., plot a vector at every (n+1)th point.
      "vfYCStride" : 7
    end create
  else
    vfield = create "VectorField" vectorFieldClass appid
      "vfUDataArray" : uvar
      "vfVDataArray" : vvar
      "vfXCStartSubsetV" : llx
      "vfYCStartSubsetV" : lly
      "vfXCEndSubsetV" : urx
      "vfYCEndSubsetV" : ury
      "vfMissingVValueV" : vvar@_FillValue
      "vfMissingUValueV" : uvar@_FillValue
      "vfXCStride" : 5          ; i.e., plot a vector at every (n+1)th point.
      "vfYCStride" : 5
    end create
  end if
;
  vcid = create "vectorplot" vectorPlotClass wid
      "vcVectorFieldData":  vfield
      "vcGlyphStyle" : "WindBarb"
      "vcWindBarbLineThicknessF" : 1.2
      "vcWindBarbColor" : 0
      "vcRefAnnoOn" : False
      "vcWindBarbTickSpacingF" : 0.1875
      "pmTickMarkDisplayMode" : "NoCreate"
      "vpXF"      : vpx        ; set viewport
      "vpYF"      : vpy
      "vpWidthF"  : vpwidth
      "vpHeightF" : vpheight
  end create
;
  setvalues vcid
    "vcMinMagnitudeF" : 0
  end setvalues
;
  load "$NCL_HOME/obj/Cs.ncl"
;
  setvalues cnid
    "cnRasterModeOn" : False
  end setvalues
;
  load "$NCL_HOME/obj/height_60m.ncl"
;
  titlestring = "Lowest Hybrid Level Cs 1 (log10 scaled), 10m Wind (kt)"
  load "$NCL_HOME/obj/add_titles.ncl"
  load "$NCL_HOME/obj/add_explabel.ncl"
;
; Draw map
;
  draw(cnid)
  draw(mpid)
;  draw(cnid4)
  draw(vcid)
;
  gsres = True
  if (iq .eq. 0) then
    do i = 0,dimsizes(airport_id)-1
      gsres@gsMarkerIndex = 16
      gsres@gsMarkerColor = 36
      gsres@gsMarkerSizeF = 0.004
      gsn_polymarker(wid,mpid,airport_loc(i,1),airport_loc(i,0),gsres)
      gsres@gsMarkerIndex = 16
      gsres@gsMarkerColor = 1
      gsres@gsMarkerSizeF = 0.002
      gsn_polymarker(wid,mpid,airport_loc(i,1),airport_loc(i,0),gsres)
    end do
  else
    do i = 0,dimsizes(airport_id)-1
      gsres@gsMarkerIndex = 16
      gsres@gsMarkerColor = 36
      gsres@gsMarkerSizeF = 0.01
      gsn_polymarker(wid,mpid,airport_loc(i,1),airport_loc(i,0),gsres)
      gsres@gsMarkerIndex = 16
      gsres@gsMarkerColor = 1
      gsres@gsMarkerSizeF = 0.005
      gsn_polymarker(wid,mpid,airport_loc(i,1),airport_loc(i,0),gsres)
    end do
  end if
;
  end do  ; loop begins in ruc_tiles_loop.ncl
;
else  ; domain is not 130
;
  load "$NCL_HOME/obj/fim_maps_blk.ncl"
;
  if (domainname .eq. "floating") then
    setvalues mpid
      "mpDataSetName" : "Earth..4"
    end setvalues
  end if
;
; Create a ScalarField object.
;
  if (domainname .eq. "fim" .or. domainname .eq. "244" .or. domainname .eq. "129") then
;
    tfield = create "ScalarField" scalarFieldClass appid
        "sfDataArray" : tvar
        "sfXCStartV" : 0
        "sfYCStartV" : ydim
        "sfXCEndV" : xdim
        "sfYCEndV" : 0
        "sfMissingValueV" : tvar@_FillValue
    end create
;
    hfield = create "ScalarField" scalarFieldClass appid
        "sfDataArray" : hvar
        "sfXCStartV" : 0
        "sfYCStartV" : ydim
        "sfXCEndV" : xdim
        "sfYCEndV" : 0
        "sfMissingValueV" : hvar@_FillValue
    end create
;
    vfield = create "VectorField" vectorFieldClass appid
        "vfUDataArray" : uvar
        "vfVDataArray" : vvar
        "vfXCStartV" : 0
        "vfYCStartV" : ydim
        "vfXCEndV" : xdim
        "vfYCEndV" : 0
        "vfMissingVValueV" : vvar@_FillValue
        "vfMissingUValueV" : uvar@_FillValue
        "vfXCStride" : wstrid       ; i.e., plot a vector at every (n+1)th point.
        "vfYCStride" : wstrid
    end create
;
  end if
;
  if (domainname .eq. "236" .or. domainname .eq. "africa" .or. \
      domainname .eq. "201" .or. domainname .eq. "w_pacific" .or. \
      domainname .eq. "europe" .or. domainname .eq. "floating" .or. \
      domainname .eq. "e_pacific" .or. domainname .eq. "83") then
;
    tfield = create "ScalarField" scalarFieldClass appid
        "sfDataArray" : tvar
        "sfXCStartV" : 0
        "sfYCStartV" : 0
        "sfXCEndV" : xdim
        "sfYCEndV" : ydim
        "sfMissingValueV" : tvar@_FillValue
    end create
;
    hfield = create "ScalarField" scalarFieldClass appid
        "sfDataArray" : hvar
        "sfXCStartV" : 0
        "sfYCStartV" : 0
        "sfXCEndV" : xdim
        "sfYCEndV" : ydim
        "sfMissingValueV" : hvar@_FillValue
    end create
;
    vfield = create "VectorField" vectorFieldClass appid
        "vfUDataArray" : uvar
        "vfVDataArray" : vvar
        "vfXCStartV" : 0
        "vfYCStartV" : 0
        "vfXCEndV" : xdim
        "vfYCEndV" : ydim
        "vfMissingVValueV" : vvar@_FillValue
        "vfMissingUValueV" : uvar@_FillValue
        "vfXCStride" : wstrid        ; i.e., plot a vector at every (n+1)th point.
        "vfYCStride" : wstrid
    end create
;
  end if
;
  if (domainname .eq. "28") then
;
    tfield = create "ScalarField" scalarFieldClass appid
        "sfDataArray" : tvar
        "sfXCStartV" : xdim
        "sfYCStartV" : ydim
        "sfXCEndV" : 0
        "sfYCEndV" : 0
        "sfMissingValueV" : tvar@_FillValue
    end create
;
    hfield = create "ScalarField" scalarFieldClass appid
        "sfDataArray" : hvar
        "sfXCStartV" : xdim
        "sfYCStartV" : ydim
        "sfXCEndV" : 0
        "sfYCEndV" : 0
        "sfMissingValueV" : hvar@_FillValue
    end create
;
    vfield = create "VectorField" vectorFieldClass appid
        "vfUDataArray" : uvar
        "vfVDataArray" : vvar
        "vfXCStartV" : xdim
        "vfYCStartV" : ydim
        "vfXCEndV" : 0
        "vfYCEndV" : 0
        "vfMissingVValueV" : vvar@_FillValue
        "vfMissingUValueV" : uvar@_FillValue
        "vfXCStride" : wstrid       ; i.e., plot a vector at every (n+1)th point.
        "vfYCStride" : wstrid
    end create
;
  end if
;
  vcid = create "vectorplot" vectorPlotClass wid
      "vcVectorFieldData":  vfield
      "vcGlyphStyle" : "WindBarb"
      "vcWindBarbLineThicknessF" : 1.2
      "vcWindBarbColor" : 0
      "vcRefAnnoOn" : False
      "vcWindBarbTickSpacingF" : 0.1875
      "pmTickMarkDisplayMode" : "NoCreate"
      "vpXF"      : vpx        ; set viewport
      "vpYF"      : vpy       
      "vpWidthF"  : vpwidth
      "vpHeightF" : vpheight
  end create
;
  setvalues vcid
    "vcMinMagnitudeF" : 0
  end setvalues
;
; Create a ContourPlot object.
;
  load "$NCL_HOME/obj/Cs.ncl"
;
  if (domainname .eq. "236" .or. domainname .eq. "africa" .or. \
      domainname .eq. "244" .or. domainname .eq. "w_pacific" .or. \
      domainname .eq. "europe" .or. domainname .eq. "28" .or. \
      domainname .eq. "floating" .or. domainname .eq. "e_pacific" .or. \
      domainname .eq. "83" .or. domainname .eq. "201") then
;
    setvalues cnid
      "cnRasterModeOn" : False
    end setvalues
;
  end if
;
  load "$NCL_HOME/obj/height_60m.ncl"
;
  if (domainname .eq. "fim" .or. domainname .eq. "129") then
    setvalues cnid4
      "cnLineThicknessF" : 1
      "cnLineLabelDensityF" : 0.001
    end setvalues
  end if
;
  if (domainname .eq. "201") then
    setvalues cnid4
      "cnLineLabelDensityF" : 0.001
    end setvalues
  end if
;
  titlestring = "Lowest Hybrid Level Cs 1 (log10 scaled), 10m Wind (kt)"
  load "$NCL_HOME/obj/add_titles.ncl"
  load "$NCL_HOME/obj/add_explabel_vcid.ncl"
;
; Draw map
;
  draw(cnid)
  draw(mpid)
;  draw(cnid4)
  draw(vcid)
;
  gsres = True
  if (domainname .eq. "236") then
    do i = 0,dimsizes(airport_id)-1
      gsres@gsMarkerIndex = 16
      gsres@gsMarkerColor = 36
      gsres@gsMarkerSizeF = 0.004
      gsn_polymarker(wid,mpid,airport_loc(i,1),airport_loc(i,0),gsres)
      gsres@gsMarkerIndex = 16
      gsres@gsMarkerColor = 1
      gsres@gsMarkerSizeF = 0.002
      gsn_polymarker(wid,mpid,airport_loc(i,1),airport_loc(i,0),gsres)
    end do
  end if
;
  frame(wid)
;
end if  ; domainname .eq. "130"
;
end

