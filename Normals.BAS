Rem File: Normals.BAS
Sub Main
	Dim App As femap.model
    Set App = feFemap()

	Dim viewID As Long
	Dim feView As femap.View
	Set feView = App.feView

	rc = App.feAppGetActiveView( viewID )
	rc = feView.Get(viewID)

	feview.Label( 10 ) = 1
	feview.ColorMode( 10 ) = 1
	feview.Color( 10 ) = 0
	
	If feview.Draw ( 10 ) = False Then
		feview.Draw ( 10 ) = True

	Else
		feview.Draw ( 10 ) = False
	
	End If

	rc = feView.Put( viewID )
	rc = App.feViewRegenerate( 0 )

End Sub