cnid = create "contourplot" contourPlotClass wid
    "cnScalarFieldData":  tfield
    "cnFillColors" : (/ 2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18 /)
    "cnLevelSelectionMode" : "ExplicitLevels"
    "cnLevels" : (/ -80,-70,-60,-50,-40,-30,-20,-10, \
                    10,20,30,40,50,60,70,80 /)
    "cnFillOn" : True
    "cnLinesOn" : False
    "cnLineLabelsOn" : False
    "cnInfoLabelOn" : False
    "cnRasterModeOn" : True
    "cnRasterSmoothingOn" : True
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
    "vpXF"      : vpx        ; set viewport
    "vpYF"      : vpy
    "vpWidthF"  : vpwidth
    "vpHeightF" : vpheight
end create
