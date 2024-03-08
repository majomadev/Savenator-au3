#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.16.1
 Author:         Navarro

 Script Function:
	- Gestor de partidas para Juego Icarus - PC

#ce ----------------------------------------------------------------------------

;Importacion de funciones
#include <ButtonConstants.au3>
#include <GUIListBox.au3>
#include <String.au3>
#include <StaticConstants.au3>
#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#include <File.au3>
#include <WinAPIFiles.au3>
#include <EditConstants.au3>
#include <Date.au3>

;Declaracion de constantes
Const $app = "SaveNator"
Const $cmd = @WorkingDir &  "\bin\7z.exe"
Const $icarusPath = @LocalAppDataDir & "\Icarus"
Const $carpetaSaves = @WorkingDir & "\Saves\Icarus"
Const $autoSave = @WorkingDir & "\bin\Autosave.exe"
$autoSavePID= ""

;Declaracion de evento de cierre
HotKeySet("{END}", "_finish")

;Declaracion de globales
Global $frmPrincipal
Global $imgHeader, $gbMarco, $btnSalir, $btnGuardar, $btnListar, $btnCargar

;Declaracion de funciones
Func _guiCreate()
	$frmPrincipal = GUICreate($app & " - Gestor de partidas de Icarus PC", 460, 465, -1, -1)

	$imgHeader = GUICtrlCreatePic("", 0, 0, 460, 215)
	GUICtrlSetImage(-1, @WorkingDir & "\res\Header.jpg")

	$gbMarco = GUICtrlCreateGroup("", 10, 225, 440, 230)
		$btnCargar = GUICtrlCreateButton("&Cargar partida", 15, 235, 430, 50)
		$btnGuardar = GUICtrlCreateButton("&Guardar partida", 15, 300, 430, 50)
		$btnSalir = GUICtrlCreateButton("&Salir", 15, 415, 430, 30)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

EndFunc

Func _main()
	_guiCreate()
	GUISetState(@SW_SHOWNORMAL)

	While 1
		Switch GUIGetMsg()
			Case $GUI_EVENT_CLOSE
				_finish()
			Case $btnSalir
				_finish()
			Case $btnGuardar
				_guardar()
			Case $btnCargar
				_cargar()
			Case Else
				;
		EndSwitch
	WEnd
EndFunc

Func _finish()
        Local $respuesta = MsgBox(4+32, "Pregunta", "¿Desea salir de la aplicación?")
		If $respuesta == 6 Then
			ProcessClose($autoSavePID)
			Exit
		EndIf
EndFunc

Func _cargar()
	;Controles del formulario
	$frmCargar = GUICreate("Cargar partida", 495, 395, -1, -1)
	Local $gbCargar = GUICtrlCreateGroup("Cargar partida:", 8, 8, 481, 345,-1,-1)
	Local $lstPartidas = GUICtrlCreateList("", 16, 48, 465, 302)
	Local $lblPartidasEncontradas = GUICtrlCreateLabel("Partidas encontradas:", 202, 24, 107, 17)
	;Variables Locales
	Local $partidaElegida=""
	Local $archivos=""
	Local $partidas=""

	;Creamos el contenido del formulario
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

#cs Funciones Utiles
#ce
Func _formateoPartidas(ByRef $paramPartida, $ctrlLstPartidas)
		$paramPartida = GUICtrlRead($ctrlLstPartidas)
		$paramPartida = _StringInsert($paramPartida,"Saved.", 0)
		Local $lengthPartidaElegida = StringLen($paramPartida)
		$paramPartida = _StringInsert($paramPartida,".7z.001", $lengthPartidaElegida)
EndFunc

Func _refrescarLista($paramArchivos, $paramPartidas, $paramLstPartidas)
	;Limpiamos el listBox
	GUICtrlSetData($paramLstPartidas, "")
	;Cargamos la lista
	$paramArchivos = _FileListToArray($carpetaSaves,"*7z.001")
	;Limpiamos el string
	$paramPartidas = ""

	If UBound($paramArchivos) > 0 Then
		;Recorremos el Array y agregamos a una variable
		For $i = 1 To UBound($paramArchivos) - 1
			$paramPartidas &= $paramArchivos[$i] & "|"
		Next

			$paramPartidas = StringReplace($paramPartidas,"Saved.","")
			$paramPartidas = StringReplace($paramPartidas,".7z.001","")
		;Establecemos la lista de partidas
		GUICtrlSetData($paramLstPartidas, $paramPartidas)
		Return 1
	Else
		MsgBox(16, "Error", "¡No se encontraron partidas!")
		Return 0
	EndIf

EndFunc

Func _restaurarPartida($paramPartidaElegida)
	Local $existe = FileExists($icarusPath)
				If $existe Then
					Local $parametros = "x " & " " &  "-o" & $icarusPath & " " & '"' & $carpetaSaves & "\" & $paramPartidaElegida & '"'
					Local $uError = ShellExecute($cmd, $parametros,"","",@SW_HIDE)
					If $uError == 0 Then
						MsgBox(16, $app, "¡Ocurrieron errores al restaurar la partida!")
					Else
						MsgBox(64, $app, "¡Partida restaurada correctamente!")
					EndIf
				Else
					DirCreate($icarusPath)
					Local $parametros = "x " & " " &  "-o" & $icarusPath & " " & '"' & $carpetaSaves & "\" & $paramPartidaElegida & '"'
					Local $uError = ShellExecute($cmd, $parametros,"","",@SW_HIDE)
					If $uError == 0 Then
						MsgBox(16, $app, "¡Ocurrieron errores al restaurar la partida!")
					Else
						MsgBox(64, $app, "¡Partida restaurada correctamente!")
					EndIf
				EndIf
			EndFunc

Func _borrarPartida($paramPartidaElegida)
	Local $res = MsgBox(4+32,"Pregunta","¿Desea borrar la partida : " & $paramPartidaElegida & "?")
	If $res == 6 Then
			Local $pathPartida = $carpetaSaves & "\" & $paramPartidaElegida
			Return FileDelete($pathPartida)
	EndIf
EndFunc
;Ejecucion de main ->
_main()



