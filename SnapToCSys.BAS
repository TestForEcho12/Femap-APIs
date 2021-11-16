Rem File: ViewColorSwap.BAS
Sub Main
	Dim app As femap.model
    Set app = feFemap()

	'Get current view
	Dim viewID As Long
	Dim view As object
	Set view = app.feViewOrient
	Dim global_eye_X as Double
	Dim global_eye_Y as Double
	Dim global_eye_Z as Double
	Dim global_right_X as Double
	Dim global_right_Y as Double
	Dim global_right_Z as Double
	rc = app.feAppGetActiveView(viewID)
	rc = view.Get(viewID)
	rc = view.GetEyeDirection(global_eye_X, global_eye_Y, global_eye_Z, global_right_X, global_right_Y, global_right_Z)
	
	'Get CSys info
	Dim csys as object
	Set csys = app.feCSys
	Dim matrix as Variant
	rc = csys.SelectID("Select CSys to Snap to")
	matrix = csys.matrix
	
	'Current view in CSys coordinates
	Dim local_eye(2) as Double
	Dim local_right(2) as Double
	local_eye(0) = matrix(0)*global_eye_X + matrix(1)*global_eye_Y + matrix(2)*global_eye_Z
	local_eye(1) = matrix(3)*global_eye_X + matrix(4)*global_eye_Y + matrix(5)*global_eye_Z
	local_eye(2) = matrix(6)*global_eye_X + matrix(7)*global_eye_Y + matrix(8)*global_eye_Z
	local_right(0) = matrix(0)*global_right_X + matrix(1)*global_right_Y + matrix(2)*global_right_Z
	local_right(1) = matrix(3)*global_right_X + matrix(4)*global_right_Y + matrix(5)*global_right_Z
	local_right(2) = matrix(6)*global_right_X + matrix(7)*global_right_Y + matrix(8)*global_right_Z
	
	'Determine axis to snap to
	Dim local_eye_idx as Integer
	Dim local_right_idx as Integer
	Dim local_eye_sign as Integer
	Dim local_right_sign as Integer
	Dim eye_val as Long
	Dim right_val as Long
	local_eye_idx = 0
	local_right_idx = 0
	eye_val = 0
	right_val = 0
	For i = 0 To 2
		If Abs(local_eye(i)) > eye_val Then
			eye_val = Abs(local_eye(i))
			local_eye_idx = i
			If local_eye(i) > 0 Then
				local_eye_sign = 1
			Else
				local_eye_sign = -1
			End If
		End If
		If Abs(local_right(i)) > right_val Then
			right_val = Abs(local_right(i))
			local_right_idx = i
			If local_right(i) > 0 Then
				local_right_sign = 1
			Else
				local_right_sign = -1
			End If
		End If
	Next i
	
	'View to snap to in CSys coordinates
	Dim snap_local_eye(2) as Integer
	Dim snap_local_right(2) as Integer
	snap_local_eye(local_eye_idx) = local_eye_sign
	snap_local_right(local_right_idx) = local_right_sign
	
	'View to snap to in global coordinates
	Dim snap_global_eye(2) as Double
	Dim snap_global_right(2) as Double
	snap_global_eye(0) = matrix(0)*snap_local_eye(0) + matrix(3)*snap_local_eye(1) + matrix(6)*snap_local_eye(2)
	snap_global_eye(1) = matrix(1)*snap_local_eye(0) + matrix(4)*snap_local_eye(1) + matrix(7)*snap_local_eye(2)
	snap_global_eye(2) = matrix(2)*snap_local_eye(0) + matrix(5)*snap_local_eye(1) + matrix(8)*snap_local_eye(2)
	snap_global_right(0) = matrix(0)*snap_local_right(0) + matrix(3)*snap_local_right(1) + matrix(6)*snap_local_right(2)
	snap_global_right(1) = matrix(1)*snap_local_right(0) + matrix(4)*snap_local_right(1) + matrix(7)*snap_local_right(2)
	snap_global_right(2) = matrix(2)*snap_local_right(0) + matrix(5)*snap_local_right(1) + matrix(8)*snap_local_right(2)
	
	'Update view
	rc = view.SetEyeDirection(snap_global_eye(0), snap_global_eye(1), snap_global_eye(2), snap_global_right(0), snap_global_right(1), snap_global_right(2))
	rc = view.Put(viewID)
	app.feWindowRegenerate(viewID)

End Sub
