[General]
SyntaxVersion=2
BeginHotkey=121
BeginHotkeyMod=0
PauseHotkey=0
PauseHotkeyMod=0
StopHotkey=123
StopHotkeyMod=0
RunOnce=1
EnableWindow=
MacroID=08b1d5b7-ab9a-47e5-a9ac-8f18e586aec3
Description=main
Enable=1
AutoRun=0
[Repeat]
Type=0
Number=1
[SetupUI]
Type=2
QUI=
[Relative]
SetupOCXFile=
[Comment]

[Attachment]
UEsDBBQAAgAIACxJ+FYWajvXsgEAAKoDAAAOABEAyuTI67/yse3H6S5ibXBVVA0AB+I/vmTiP75k3j++ZHWTu27CQBBFN8oXpMsn5AvyAekoDFUKMNBASxdDi4EOkKDgUQNVeMgtAkpKhGhMCQgaJB7i1eeItWzLgZG8unN3Rndmdvyl/L6Ku33yffC9Wd+LeL/zP9a9224u2+/33W43lUqFQiFFUTjBMPDuMCdnMBgQpOv6cDhcLBbEcYLT6TQ8wJvTbDYjkch0Or09sslkEg6HW62Wk4NCNBpdr9dgzlKppKqqz+fjLJfLNk+aVBPUEAwGpYJpmpRBznw+PxwOnGAYgFQDEy/a7TY9QJ1Op1gsZhiGp7BerxePx7kF0xsjEclkcjQa4aObSCQe9gNvxzBJgdxyucSv1WqBQOD7kcHX63VimCTxgneQ46eB7XPjVj6g3+93dLDr9Uq7l8vFrup8PsPAS9fS0TRN1opVKhVGXCwW7ZxCoQBTrVala/XD3DKZjKTy+TwRuVzOzslmszBkSpcJdzodsdvteJ/ZbAZ1PB7H47F7u8Aw8GDe0HofnH6/zx5sNpvbc2MPiGFjnH1rNBpQUu2/ocAtO+nda9Qokt4YyWq1ogZOMD3ASwVvDkZvjIRJ2v8PGMb7//wBUEsDBBQAAgAIANBE+FbJcWOJAQEAAG4RAAAQABEAzsS8/tb6ytZpY29uLmJtcFVUDQAHkDi+ZJA4vmSQOL5kc/LNE2QAAzMg1gBiNShmZJAAi1tA5ZGB6yJtOqNRO0ftHLVz6NqZsN4ra2sYSSh2nTsFdkavcf377+9/EsG3X189FuuRa2fO1vD/ZAHfZabDx85///7++/ePvnbeeXvj0INdNLbz558fr748hyOghe6LdZdenPn772+a2Xnm6VGsyur25fz684u+dvYdqwcGAV3i89KLM95LjZZfnv3v/z96paHbb67dfnuN3nnlH93zykgph4Dg1purq6/OR0OzzvRQUK9kbwnDY+HN15d9l5pQu/70WmJ44vHBO2+vY6ITjw8Er7AebZuM2jlq56ido3YSb2fsCg96WhiyzI6BAQBQSwECFwsUAAIACAAsSfhWFmo717IBAACqAwAADgAJAAAAAAAAACAAgIEAAAAAyuTI67/yse3H6S5ibXBVVAUAB+I/vmRQSwECFwsUAAIACADQRPhWyXFjiQEBAABuEQAAEAAJAAAAAAAAACAAgIHvAQAAzsS8/tb6ytZpY29uLmJtcFVUBQAHkDi+ZFBLBQYAAAAAAgACAIwAAAAvAwAAAAA=


[Script]
// 依赖项
Import "D:/RPA/vbs/VbsJson.vbs" 'VbsJson类
 'HTTP.QML命令库:httpRequest
'SendMessageByWechat 


// 全局变量
baseURL = "http://huaer-market-data.weijuju.com" '接口根路径
token = "huaer365888" '接口安全令牌

// 主程序
Sub main()
	// 轮询执行
	Do While True
		TracePrint "轮询+1"
	
       	'拉取任务
        url = baseURL + "/rpa/api/task/getUndoWxDataRpaTask"
		JSonString = Lib.Http.httpRequest(url, "POST", "token=" + token, Null)
		TracePrint "JsonString" & JsonString
//		If VarType(JSonString) <> vbObject Then
//			TracePrint "拉取任务请求错误"
//			Delay 10000
//			GoTo ContinueLoop
//    	End If
		
		'解析任务数据
//       	On Error Resume Next
		Set jsonParser = New VbsJson
		Set res = jsonParser.Decode(JSonString)
		If VarType(res) <> vbObject Then 
			TracePrint "解析任务数据错误" & JSonString
			Delay 10000
			GoTo ContinueLoop
    	End If
		
		'请求任务错误
		If res("code") <> 200 Then
			TracePrint "请求任务错误，错误码：" & res("code")
        	Delay 10000
        	
		'任务为空
		ElseIf res.Exists("data") = False Or IsNull(res("data")) Then 
			TracePrint "暂无任务"
        	Delay 10000
        	
        '有效任务
		Else
			TracePrint "开始执行任务"
			recordId = res("data")("recordId") '任务id
			Set extraInfo = jsonParser.Decode(res("data")("extra")) '任务链接
			taskLink = extraInfo("wxArticleLink")
			Call taskWorker(recordId, taskLink)
        	Delay 3000
		End If
		
	Call keepAlive'记录心跳
	
	Rem ContinueLoop
    Loop

End Sub

// 心跳
prevTime = Plugin.Sys.GetTime()
Sub keepAlive
    currentTime = Plugin.Sys.GetTime()
    elapsedTime = currentTime - prevTime
	' 判断时间差是否大于15分钟
	If elapsedTime > 15 * 60 * 1000 Then 
		prevTime = currentTime
    	url = baseURL + "/rpa/api/collect/mp/alive"
		JSonString = Lib.Http.httpRequest(url, "GET", "token=" + token, Null)
		TracePrint "keppAlive..." 	
	End If
End Sub


// 初始化微信
Call Lib.WechatController.open()
Delay 3000
Call Lib.WechatController.enterFileTransfer()
Call main '调用主程序


// 执行任务
Sub taskWorker(recordId, taskLink)
	TracePrint "任务执行中..."
	url = baseURL + "/rpa/api/task/modifyTaskState"
	params = "token=" + token + "&recordId=" + recordId + "&state=2"
	JsonString = Lib.Http.httpRequest(url, "POST", params, Null)
	
	Call Lib.WechatController.Browse(taskLink)'浏览链接
	If Err.Number <> 0 Then 
		TracePrint "浏览链接错误" & Err.Description
		Err.Clear
		url = baseURL + "/rpa/api/task/modifyTaskState"
		params = "token=" + token + "&recordId=" + recordId + "&state=4"
		Call Lib.Http.httpRequest(url, "POST", params, Null)
		Exit Sub
    End If
	
	TracePrint "任务执行成功"
	url = baseURL + "/rpa/api/task/modifyTaskState"
	params = "token=" + token + "&recordId=" + recordId + "&state=3"
	Call Lib.Http.httpRequest(url, "POST", params, Null)
End Sub


