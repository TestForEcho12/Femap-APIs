Sub Main
	Dim App As femap.model
    Set App = feFemap()

	Dim viewID As Long
	Dim feView As femap.View
	Dim PropSet as Object
	Set PropSet = App.feSet
	Set feView = App.feView

	rc = PropSet.AddAll(11)
	rc = App.feModifyColor(11,PropSet.ID,1,True)
	rc = App.feAppGetActiveView( viewID )
	rc = feView.Get(viewID)

	feview.ColorMode( 9 ) = 3		'Color element by property
	feview.ColorMode( 26 ) = 1		'Filled edges use view color
	feview.Color( 26 ) = 0			'Filled edges view color is black
	feview.Draw( 33 ) = False		'Turn off origin
	feview.Draw( 31 ) = False		'Turn off view legend
	feview.Draw( 24 ) = False		'Turn off curve - mesh size
	feview.Draw( 94 ) = False		'Turn off rigid symbols
	
	feview.Draw( 2 ) = False		'Turn off Point
	feview.Draw( 3 ) = False		'Turn off Curve
	feview.Draw( 4 ) = False		'Turn off Surface
	feview.Draw( 6 ) = False		'Turn off Text
	feview.Draw( 79 ) = False		'Turn off Connector
	feview.Draw( 91 ) = False		'Turn off Connection region
	feview.Draw( 1 ) = False		'Turn off Coordinate System
	feview.Draw( 7 ) = False		'Turn off Node
	'feview.Draw(  ) = False		'Turn off Load
	feview.Draw( 20 ) = False		'Turn off Constraint
	feview.Draw( 9 ) = True			'Turn on elements
	

	rc = feView.Put( viewID )
	rc = App.feViewRegenerate( 0 )

End Sub