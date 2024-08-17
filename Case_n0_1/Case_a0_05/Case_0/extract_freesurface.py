# trace generated using paraview version 5.12.0
#import paraview
#paraview.compatibility.major = 5
#paraview.compatibility.minor = 12

#### import the simple module from the paraview
from paraview.simple import *
#### disable automatic camera reset on 'Show'
paraview.simple._DisableFirstRenderCameraReset()

# create a new 'Open FOAM Reader'
case_$ifoam = OpenFOAMReader(registrationName='Case_$i.foam', FileName='$ddir/Case_$i/Case_$i.foam')

# get active view
renderView1 = GetActiveViewOrCreate('RenderView')

# show data in view
case_$ifoamDisplay = Show(case_$ifoam, renderView1, 'UnstructuredGridRepresentation')

# trace defaults for the display properties.
case_$ifoamDisplay.Representation = 'Surface'

# reset view to fit data
renderView1.ResetCamera(False, 0.9)

# get the material library
materialLibrary1 = GetMaterialLibrary()

# update the view to ensure updated data information
renderView1.Update()

# Properties modified on case_6foam
case_$ifoam.CaseType = 'Decomposed Case'

# get animation scene
animationScene1 = GetAnimationScene()

# update animation scene based on data timesteps
animationScene1.UpdateAnimationUsingDataTimeSteps()

# Properties modified on case_6foam
case_$ifoam.SkipZeroTime = 0
case_$ifoam.MeshRegions = ['internalMesh']
case_$ifoam.CellArrays = ['U', 'alpha.water', 'p', 'p_rgh', 'porosity']

# update the view to ensure updated data information
renderView1.Update()

# create a new 'Slice'
slice1 = Slice(registrationName='Slice1', Input=case_$ifoam)

# Properties modified on slice1.SliceType
slice1.SliceType.Normal = [0.0, 0.0, 1.0]

# show data in view
slice1Display = Show(slice1, renderView1, 'GeometryRepresentation')

# trace defaults for the display properties.
slice1Display.Representation = 'Surface'

# hide data in view
Hide(case_$ifoam, renderView1)

# show color bar/color legend
slice1Display.SetScalarBarVisibility(renderView1, True)

# update the view to ensure updated data information
renderView1.Update()

# get color transfer function/color map for 'p'
pLUT = GetColorTransferFunction('p')

# get opacity transfer function/opacity map for 'p'
pPWF = GetOpacityTransferFunction('p')

# get 2D transfer function for 'p'
pTF2D = GetTransferFunction2D('p')

# create a new 'Contour'
contour1 = Contour(registrationName='Contour1', Input=slice1)

# Properties modified on contour1
contour1.ContourBy = ['POINTS', 'alpha.water']
contour1.Isosurfaces = [0.25]

# show data in view
contour1Display = Show(contour1, renderView1, 'GeometryRepresentation')

# trace defaults for the display properties.
contour1Display.Representation = 'Surface'

# hide data in view
Hide(slice1, renderView1)

# show color bar/color legend
contour1Display.SetScalarBarVisibility(renderView1, True)

# update the view to ensure updated data information
renderView1.Update()

# get color transfer function/color map for 'alphawater'
alphawaterLUT = GetColorTransferFunction('alphawater')

# get opacity transfer function/opacity map for 'alphawater'
alphawaterPWF = GetOpacityTransferFunction('alphawater')

# get 2D transfer function for 'alphawater'
alphawaterTF2D = GetTransferFunction2D('alphawater')

# save data
SaveData('$ddir/Case_$i/data_case$i.csv', proxy=contour1, WriteTimeSteps=1,
    WriteTimeStepsSeparately=1,
    ChooseArraysToWrite=1,
    PointDataArrays=['alpha.water'],
    Precision=8)

#================================================================
# addendum: following script captures some of the application
# state to faithfully reproduce the visualization during playback
#================================================================

# get layout
layout1 = GetLayout()

#--------------------------------
# saving layout sizes for layouts

# layout/tab size in pixels
layout1.SetSize(1216, 848)

#-----------------------------------
# saving camera placements for views

# current camera placement for renderView1
renderView1.CameraPosition = [3.0, 0.20000000298023224, 10.272289945152906]
renderView1.CameraFocalPoint = [3.0, 0.20000000298023224, 0.004999999888241291]
renderView1.CameraParallelScale = 12.615587807797151


##--------------------------------------------
## You may need to add some code at the end of this python script depending on your usage, eg:
#
## Render all views to see them appears
# RenderAllViews()
#
## Interact with the view, usefull when running from pvpython
# Interact()
#
## Save a screenshot of the active view
# SaveScreenshot("path/to/screenshot.png")
#
## Save a screenshot of a layout (multiple splitted view)
# SaveScreenshot("path/to/screenshot.png", GetLayout())
#
## Save all "Extractors" from the pipeline browser
# SaveExtracts()
#
## Save a animation of the current active view
# SaveAnimation()
#
## Please refer to the documentation of paraview.simple
## https://kitware.github.io/paraview-docs/latest/python/paraview.simple.html
##--------------------------------------------
