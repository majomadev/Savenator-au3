;Importacion de funciones
#include <ButtonConstants.au3>
#include <String.au3>
#include <StaticConstants.au3>
#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#include <File.au3>
#include <WinAPIFiles.au3>
#include <EditConstants.au3>
#include <Date.au3>

;Declaracion de constantes
Const $cmd = @WorkingDir &  "\bin\7z.exe"
Const $icarusPath = @LocalAppDataDir & "\Icarus"
Const $carpetaSaves = @WorkingDir & "\Saves\Icarus"

Func _guardarPartida($tiempoAuto)
		Local $fechaHoraPartida = _fechaHoraActual()
		Local $parameters = "a -t7z -m0=LZMA2 -mmt=on -mx9 -md=64m -mfb=64 -ms=16g -mqs=on -sccUTF-8 -bb0 -bse0 -bsp2 -v4290772992" & " " &  "-w" & $carpetaSaves & " " & "-mtc=on -mta=on" & " " & $carpetaSaves & "\Saved." & $fechaHoraPartida & ".7z" & " " & $icarusPath & "\Saved"

	If $tiempoAuto >= 1000 Then

			While 1
				$fechaHoraPartida = _fechaHoraActual()
				$parameters = "a -t7z -m0=LZMA2 -mmt=on -mx9 -md=64m -mfb=64 -ms=16g -mqs=on -sccUTF-8 -bb0 -bse0 -bsp2 -v4290772992" & " " &  "-w" & $carpetaSaves & " " & "-mtc=on -mta=on" & " " & $carpetaSaves & "\Saved." & $fechaHoraPartida & ".7z" & " " & $icarusPath & "\Saved"
				ShellExecute($cmd, $parameters,"","",@SW_HIDE)
				Sleep($tiempoAuto)
			WEnd
	Else
				$fechaHoraPartida = _fechaHoraActual()
				$parameters = "a -t7z -m0=LZMA2 -mmt=on -mx9 -md=64m -mfb=64 -ms=16g -mqs=on -sccUTF-8 -bb0 -bse0 -bsp2 -v4290772992" & " " &  "-w" & $carpetaSaves & " " & "-mtc=on -mta=on" & " " & $carpetaSaves & "\Saved." & $fechaHoraPartida & ".7z" & " " & $icarusPath & "\Saved"

				Local $resp = ShellExecute($cmd, $parameters,"","",@SW_HIDE)
				If $resp <> 0 Then
					MsgBox(64, "Información", "¡Se ha guardado correctamente!")
				Else
					MsgBox(16, "Error", "¡Se han producido errores al guardar!")
				EndIf
	EndIf
EndFunc

Func _fechaHoraActual()
	Local $fechaHora = _Now()
	$fechaHora = StringReplace($fechaHora, "/","-")
	$fechaHora = StringReplace($fechaHora, ":","_")
	$fechaHora = StringReplace($fechaHora, " ",".")
	Return $fechaHora
EndFunc

If UBound($CmdLine) > 1 Then
	_guardarPartida($CmdLine[1])
EndIf
