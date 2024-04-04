#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.16.1
 Author:         Navarro

 Script Function:
	- Gestor de partidas para Juego Icarus - PC

#ce ----------------------------------------------------------------------------
#pragma compile(Icon, res\icono.ico)
#pragma compile(Out, Savenator.exe)
#pragma compile(FileDescription, Gestor de partidas de Icarus)
#pragma compile(ProductName, Savenator)
#pragma compile(ProductVersion, 1.0)
#pragma compile(FileVersion, 1.0.0.0)
#pragma compile(LegalCopyright, © Mathias Navarro)
#pragma compile(CompanyName, 'Navarro Inc.')

#include <GUIConstantsEx.au3>
;Importacion de modulos propios
#include <modules\Save.au3>
#include <modules\Load.au3>
#include <modules\Utils.au3>

Const $app = "SaveNator"
Const $cmd = @WorkingDir &  "\bin\7z.exe"
Const $icarusPath = @LocalAppDataDir & "\Icarus"
Const $carpetaSaves = @WorkingDir & "\Saves\Icarus"
Const $autoSave = @WorkingDir & "\bin\Autosave.exe"
Const $cfg = @WorkingDir & "\cfg.ini"
Global $autoSavePID= ""

HotKeySet("{END}", "_finish")

Global $frmPrincipal
Global $imgHeader, $gbMarco, $btnSalir, $btnGuardar, $btnListar, $btnCargar, $btnIniciarJuego

Func _guiCreate()
	$frmPrincipal = GUICreate($app & " - Gestor de partidas de Icarus PC", 460, 465, -1, -1)

	$imgHeader = GUICtrlCreatePic("", 0, 0, 460, 215)
	GUICtrlSetImage($imgHeader, @WorkingDir & "\res\Header.jpg")

	$gbMarco = GUICtrlCreateGroup("", 10, 225, 440, 230)
		$btnCargar = GUICtrlCreateButton("&Cargar partida", 15, 235, 430, 50)
		$btnGuardar = GUICtrlCreateButton("&Guardar partida", 15, 290, 430, 50)
		$btnIniciarJuego = GUICtrlCreateButton("Iniciar &Icarus", 15, 345, 430, 50)
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
			Case $btnIniciarJuego
				_iniciarJuego()
			Case Else
		EndSwitch
	WEnd
EndFunc

Func _finish()
        Local $respuesta = MsgBox(4+32, $app, "¿Desea salir de la aplicación?")
		If $respuesta == 6 Then
			ProcessClose($autoSavePID)
			Exit
		EndIf
	EndFunc

Func _iniciarJuego()
	Local $pathIcarusGame = IniRead($cfg,"GamePath","IcarusGamePath", "")
	Local $result = StringLen($pathIcarusGame)

	If	$result <> 0 Then
		Local $existsExe = FileExists($pathIcarusGame)
		If $existsExe Then
			GUICtrlSetState($btnIniciarJuego, $GUI_DISABLE)
			ShellExecute($pathIcarusGame)
		Else
			MsgBox(16, $app, "¡El archivo no existe!")
			IniWrite($cfg,"GamePath","IcarusGamePath","")
		EndIf
	Else
			Local $icarusExe = FileOpenDialog("Buscar juego Icarus", @DesktopDir & "\", "Ejecutable Icarus (Icarus.exe)",$FD_FILEMUSTEXIST)
			If @error <> 0 Then
			Else
				IniWrite($cfg,"GamePath","IcarusGamePath", $icarusExe)
				MsgBox(64, $app, "¡Se estableció nueva ruta del lanzador!")
			EndIf
	EndIf
EndFunc

_main()



