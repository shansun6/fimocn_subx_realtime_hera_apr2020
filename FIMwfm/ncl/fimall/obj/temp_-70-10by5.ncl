;
; uses cmap1b
;
cnid = create "contourplot" contourPlotClass wid
    "cnScalarFieldData":  tfield
    "cnFillColors" : (/ 11,12,13,21,22,2,3,4,5,6,7,8,9,10,11,12,13,21 /)
    "cnLevelSelectionMode" : "ExplicitLevels"
    "cnLevels" : (/ -70,-65,-60,-55,-50,-45,-40,-35,-30,-25,-20,-15,-10,-5,0,5,10 /)
    "cnFillOn" : True
    "cnLinesOn" : False
    "cnLineLabelsOn" : False
    "cnInfoLabelOn" : False
    "cnRasterModeOn" : True
    "pmTickMarkDisplayMode" : "NoCreate"
    "pmLabelBarDisplayMode" : "ALWAYS"
    "pmLabelBarHeightF" : .05
    "pmLabelBarWidthF" : 0.9
    "pmLabelBarSide" : "bottom"
    "pmLabelBarOrthogonalPosF" : 0.0
    "lbOrientation" : "horizontal"
    "lbTitleFont" : 22
    "lbPerimOn" : False
    "lbBoxLinesOn" : 0
    "lbLabelFontHeightF" : 0.06
    "vpXF"      : vpx        ; set viewport
    "vpYF"      : vpy
    "vpWidthF"  : vpwidth
    "vpHeightF" : vpheight
end create
