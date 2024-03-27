#pragma compile(Out, Autosave.exe)
#pragma compile(FileDescription, Modulo Autosave para Savenator)
#pragma compile(ProductName, Autosave)
#pragma compile(ProductVersion, 1.0)
#pragma compile(FileVersion, 1.0.0.0)
#pragma compile(LegalCopyright, © Mathias Navarro)
#pragma compile(CompanyName, 'Navarro Inc.')

#include <Date.au3>

Const $cmd = @WorkingDir &  "\bin\7z.exe"
Const $icarusPath = @LocalAppDataDir & "\Icarus"
Const $carpetaSaves = @WorkingDir & "\Saves\Icarus"
Global $fechaHoraPartida = _fechaHoraActual()
Global $parameters = "a -t7z -m0=LZMA2 -mmt=on -mx9 -md=64m -mfb=64 -ms=16g -mqs=on -sccUTF-8 -bb0 -bse0 -bsp2 -v4290772992" & " " &  "-w" & $carpetaSaves & " " & "-mtc=on -mta=on" & " " & $carpetaSaves & "\Saved." & $fechaHoraPartida & ".7z" & " " & $icarusPath & "\Saved"

Func _guardarPartida($tiempoAuto)
	_refrescarParametros($fechaHoraPartida, $parameters)

	If $tiempoAuto >= 1000 Then

			While 1
				_refrescarParametros($fechaHoraPartida, $parameters)

				ShellExecute($cmd, $parameters,"","",@SW_HIDE)
				Sleep($tiempoAuto)
			WEnd
	Else
				_refrescarParametros($fechaHoraPartida, $parameters)

				Local $resp = ShellExecute($cmd, $parameters,"","",@SW_HIDE)
				If $resp <> 0 Then
					MsgBox(64, "Información", "¡Se ha guardado correctamente!")
				Else
					MsgBox(16, "Error", "¡Se han producido errores al guardar!")
				EndIf
	EndIf
EndFunc

Func _refrescarParametros(ByRef $fechaHoraPartida, ByRef $parameters)
			$fechaHoraPartida = _fechaHoraActual()
			$parameters = "a -t7z -m0=LZMA2 -mmt=on -mx9 -md=64m -mfb=64 -ms=16g -mqs=on -sccUTF-8 -bb0 -bse0 -bsp2 -v4290772992" & " " &  "-w" & $carpetaSaves & " " & "-mtc=on -mta=on" & " " & $carpetaSaves & "\Saved." & $fechaHoraPartida & ".7z" & " " & $icarusPath & "\Saved"
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
