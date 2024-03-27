#include <GUIListBox.au3>

Func _cargar()
	Local $partidaElegida=""
	Local $archivos=""
	Local $partidas=""

	$frmCargar = GUICreate("Cargar partida", 495, 395, -1, -1)
	Local $gbCargar = GUICtrlCreateGroup("Cargar partida:", 8, 8, 481, 345,-1,-1)
	Local $lstPartidas = GUICtrlCreateList("", 16, 48, 465, 302)
	Local $lblPartidasEncontradas = GUICtrlCreateLabel("Partidas encontradas:", 202, 24, 107, 17)

	GUICtrlCreateGroup("", -99, -99, 1, 1)
		Local $btnCargarPartida = GUICtrlCreateButton("Cargar", 16, 360, 185, 25)
		Local $btnMenu = GUICtrlCreateButton("Menú", 368, 360, 121, 25)
		Local $btnBorrarPartida = GUICtrlCreateButton("Borrar", 208, 360, 153, 25)
		GUICtrlSetState($btnCargarPartida, $GUI_DISABLE)
		GUICtrlSetState($btnBorrarPartida, $GUI_DISABLE)
	GUISetState(@SW_SHOW)

	Local $partidasEncontradas = _refrescarLista($archivos, $partidas, $lstPartidas)
	If $partidasEncontradas <> 0 Then
				GUICtrlSetState($btnCargarPartida, $GUI_ENABLE)
				GUICtrlSetState($btnBorrarPartida, $GUI_ENABLE)
	EndIf

While 1
		$nMsg = GUIGetMsg()
		Switch $nMsg
			Case $GUI_EVENT_CLOSE
				GUIDelete($frmCargar)
				ExitLoop
			Case $btnMenu
				GUIDelete($frmCargar)
				ExitLoop
			Case $btnBorrarPartida
				Local $respuesta = _borrarPartida($partidaElegida)
				If $respuesta == 1 Then
						MsgBox(64,"Información", "¡Partida borrada!")
						_refrescarLista($archivos, $partidas, $lstPartidas)
				EndIf
			Case $lstPartidas
				_formateoPartidas($partidaElegida, $lstPartidas)
			Case $btnCargarPartida
				_restaurarPartida($partidaElegida)
		EndSwitch
WEnd

EndFunc
