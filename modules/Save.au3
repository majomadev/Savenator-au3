#include <Date.au3>

Func _guardar()
	Local $modAutoSave = FileExists($autoSave)
	If $modAutoSave <> 1 Then
			MsgBox(16,"Error", "¡Falta modulo de autoguardado!")
			Exit
	EndIf

	$frmGuardar = GUICreate("Guardar partida", 362, 136, -1, -1)
	$gbGuardar = GUICtrlCreateGroup("Guardar partida:", 8, 8, 345, 89)
	$chkAutoguardado = GUICtrlCreateCheckbox("Autoguardado", 16, 28, 89, 25)
	$lblTiempo = GUICtrlCreateLabel("Tiempo:", 108, 32, 42, 17)
	GUICtrlSetState(-1, $GUI_DISABLE)
	$txtTiempo = GUICtrlCreateInput("", 152, 30, 113, 21)
	GUICtrlSetData($txtTiempo, "1")
	GUICtrlSetState(-1, $GUI_DISABLE)
	$lblTiempo2 = GUICtrlCreateLabel("En segundos.", 268, 30, 69, 17)
	GUICtrlSetState(-1, $GUI_DISABLE)
	GUICtrlCreateGroup("", -99, -99, 1, 1)
	$btnGuardarPartida = GUICtrlCreateButton("Guardar ahora", 16, 56, 329, 33)
	$btnMenu = GUICtrlCreateButton("Menú", 120, 104, 121, 25)
	GUISetState(@SW_SHOW)

	Local $fechaHora = _Now()
	Local $tiempoEspera = 0
	Local $boolAutoGuardado

	GUICtrlSetData($txtTiempo, "1")

While 1
	$nMsg2 = GUIGetMsg()
	Switch $nMsg2
		Case $GUI_EVENT_CLOSE
			GUIDelete($frmGuardar)
			ExitLoop
		Case $chkAutoguardado
				$boolAutoGuardado = GUICtrlRead($chkAutoguardado)
				If $boolAutoGuardado == 1 Then
					GUICtrlSetState($lblTiempo,64)
					GUICtrlSetState($lblTiempo2,64)
					GUICtrlSetState($txtTiempo,64)
					GUICtrlSetState($txtTiempo,256)
				Else
					GUICtrlSetState($lblTiempo,128)
					GUICtrlSetState($lblTiempo2,128)
					GUICtrlSetState($txtTiempo,128)
				EndIf
			Case $btnGuardarPartida
				;Obtenemos el texto del boton
				Local $captionGuardar = GUICtrlRead($btnGuardarPartida)

				Switch $captionGuardar
				Case "Detener"
					ProcessClose($autoSavePID)
					_finish()
				Case "Guardar ahora"
					If $boolAutoGuardado == 1 Then
						;Si el checkbox esta activado
							;Obtenemos el tiempo del control txt
							Local $tiempo= GUICtrlRead($txtTiempo)
							If $tiempo > 0 Then
								$tiempo *= 1000 ;-- realizamos la conversion a milisegundos

								If $tiempo >= 1000 Then
									;Cambiamos el texto del boton por "Detener"
									GUICtrlSetData($btnGuardarPartida, "Detener")
									;Deshabilitamos los demas controles
									GUICtrlSetState($lblTiempo, $GUI_DISABLE)
									GUICtrlSetState($lblTiempo2, $GUI_DISABLE)
									GUICtrlSetState($txtTiempo, $GUI_DISABLE)
									GUICtrlSetState($chkAutoguardado, $GUI_DISABLE)
									GUICtrlSetState($btnMenu, $GUI_DISABLE)

									;Grabamos la partida con autoguardado
									ProcessClose($autoSavePID)
									$autoSavePID = ShellExecute($autoSave, $tiempo,"","",@SW_HIDE)
								EndIf
							ElseIf $tiempo == 0 Or $tiempo == "" Then
								;Error no se puede con valor 0 o vacio
								MsgBox(16, "Error", "¡Valores incorrectos!")
							EndIf
						Else
							;Si no esta activado el checkbox se guardaria de forma normal
							ProcessClose($autoSavePID)
							$autoSavePID = ShellExecute($autoSave, 0,"","",@SW_HIDE)
					EndIf
				EndSwitch
		Case $btnMenu
			GUIDelete($frmGuardar)
			ExitLoop
	EndSwitch
WEnd

EndFunc
