Sub Main
	Dim App As femap.model
    Set App = feFemap()
	
	dim emptyLayers as object
	dim layer as object
	dim layerID as long
	
	set emptyLayers = App.feSet
	set layer = App.feLayer
	
	emptyLayers.ID = 100

	layer.ClearLayerInfo()
	layer.InitAllLayerInfo(True, False, False)
	rc = layer.FindEmptyLayers(100)
	
	
	emptyLayers.reset()
	layerID = emptyLayers.next()
	rc=App.feAppMessage(2, "Empty Layers: " & CStr(emptyLayers.Count()))
	
	while layerID<>0
		rc=App.feAppMessage(2, CStr(layerID))
		layerID = emptyLayers.next()
	wend

End Sub