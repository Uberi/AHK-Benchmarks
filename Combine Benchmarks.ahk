#NoEnv

FileSelectFile, File1, 11, %A_ScriptDir%, Select the first benchmark., *.html
If ErrorLevel
 ExitApp
File1Version = AHK v1.0.48.05
InputBox, File1Version, AutoHotkey version, Input the version of AutoHotkey this benchmark was run on:,, 380, 120,,,,, %File1Version%
If ErrorLevel
 ExitApp
FileSelectFile, File2, 11, %A_ScriptDir%, Select the second benchmark., *.html
If ErrorLevel
 ExitApp
File2Version = AHK_L v1.1.00.00
InputBox, File2Version, AutoHotkey version, Input the version of AutoHotkey this benchmark was run on:,, 380, 120,,,,, %File2Version%
If ErrorLevel
 ExitApp

FileRead, File1, %File1%
Temp1 := GetNumbers(File1)
StringSplit, File1Result, Temp1, `n
FileRead, File2, %File2%
Temp1 := GetNumbers(File2)
StringSplit, File2Result, Temp1, `n

FoundPos := 1, FoundPos1 := 1
While, (FoundPos := RegExMatch(File1,"S)(<tr(?: class=""alt"")?><td>[^<]+</td><td><pre>[^<]+</pre></td>)<td>[^<]+</td></tr>",Match,FoundPos))
 Result .= SubStr(File1,FoundPos1,FoundPos - FoundPos1) . Match1 . "<td>" . File1Result%A_Index% . "</td><td>" . File2Result%A_Index% . "</td></tr>", FoundPos += StrLen(Match), FoundPos1 := FoundPos
Result .= SubStr(File1,FoundPos1)
Result := RegExReplace(Result,"S)<th>[^<]+</th><th>[^<]+</th>\K<th>[^<]+</th></tr>","<th>" . File1Version . "</th><th>" . File2Version . "</th></tr>")
FileSelectFile, FileName, S16, Combined Benchmarks.html, Select a save path for the combined benchmark., *.html
If Not ErrorLevel
{
 FileDelete, %FileName%
 FileAppend, %Result%, %FileName%
}
ExitApp

GetNumbers(Benchmark)
{
 Benchmark := SubStr(Benchmark,InStr(Benchmark,"<tr class=""alt""><td>"))
 StringReplace, Benchmark, Benchmark, <table>,, All
 StringReplace, Benchmark, Benchmark, </table>,, All
 StringReplace, Benchmark, Benchmark, <tr class="alt">, <tr>, All
 Benchmark := SubStr(Benchmark,1,InStr(Benchmark,"<h2 id=""SystemInformation"">",False,0) - 1)
 Benchmark := RegExReplace(Benchmark,"S)<tr><th>[^<]+</th><th>[^<]+</th><th>[^<]+</th></tr>")
 Benchmark := RegExReplace(Benchmark,"S)<p>[^<]+</p>")
 Benchmark := RegExReplace(Benchmark,"S)<h2 id=""[^""]+"">[^<]+</h2>")
 Benchmark := RegExReplace(Benchmark,"S)<tr><td>[^<]+</td><td><pre>[^<]+</pre></td>")
 StringReplace, Benchmark, Benchmark, </td></tr>,, All
 StringReplace, Benchmark, Benchmark, <td>, `n, All
 Return, SubStr(Benchmark,2)
}