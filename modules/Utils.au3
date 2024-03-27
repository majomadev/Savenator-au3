#include <String.au3>
#include <File.au3>

Func _formateoPartidas(ByRef $paramPartida, $ctrlLstPartidas)
		$paramPartida = GUICtrlRead($ctrlLstPartidas)
		$paramPartida = _StringInsert($paramPartida,"Saved.", 0)
		Local $lengthPartidaElegida = StringLen($paramPartida)
		$paramPartida = _StringInsert($paramPartida,".7z.001", $lengthPartidaElegida)
EndFunc

Func _refrescarLista($paramArchivos, $paramPartidas, $paramLstPartidas)

	GUICtrlSetData($paramLstPartidas, "")

	$paramArchivos = _FileListToArray($carpetaSaves,"*7z.001")

	$paramPartidas = ""

	If UBound($paramArchivos) > 0 Then

		For $i = 1 To UBound($paramArchivos) - 1
			$paramPartidas &= $paramArchivos[$i] & "|"
		Next

			$paramPartidas = StringReplace($paramPartidas,"Saved.","")
			$paramPartidas = StringReplace($paramPartidas,".7z.001","")

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
