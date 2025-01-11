[General]
SyntaxVersion=2
MacroID=4ec43695-b2b4-46fe-b560-a54b365511c4
[Comment]

[Script]
//请在下面写上您的子程序或函数
//写完保存后，在任一命令库上点击右键并选择“刷新”即可

'微信窗口信息
Dim wechatMainObject

'打开微信窗口
Function open
	wechatMain = Plugin.Window.Find("WeChatMainWndForPC", "Weixin")
	Delay 100
	Call Plugin.Window.Restore(wechatMain)
//	Call Plugin.Window.Active(wechatMain)
	Call Plugin.Window.Show(wechatMain)
//	Call Plugin.Window.Top(wechatMain, 0)
	'窗口位置信息
	wechatMainRect = Plugin.Window.GetClientRect(wechatMain)
	wechatMainRectArray = Split(wechatMainRect, "|")
	Set wechatMainObject = CreateObject("Scripting.Dictionary")
	wechatMainObject.Add "L", CLng(wechatMainRectArray(0))
	wechatMainObject.Add "T", CLng(wechatMainRectArray(1))
	wechatMainObject.Add "R", CLng(wechatMainRectArray(2)) + wechatMainObject("L")
	wechatMainObject.Add "B", CLng(wechatMainRectArray(3)) + wechatMainObject("T")
End Function

// 进入文件传输助手
Function enterFileTransfer
	'点击微信助手
	FindPic wechatMainObject("L"), wechatMainObject("T"), wechatMainObject("R"), wechatMainObject("B"), "Attachment:\文件助手icon.bmp", 0.5, x, y
	Delay 100
	If x > 0 and y > 0 Then   
		MoveTo x+1,y+1   
		LeftClick 1
	Else
	    MessageBox "微信首屏未发现文件助手，请手动进入文件助手"
	    ExitScript
	End If
	'激活输入框
	Delay 1000
	FindPic wechatMainObject("L"), wechatMainObject("T"), wechatMainObject("R"), wechatMainObject("B"), "Attachment:\输入框表情.bmp", 0.6, emoticonX, emoticonY
	If emoticonX > 0 and emoticonY > 0 Then   
		MoveTo emoticonX + 5, emoticonY + 50
		wechatMainObject.Add "InputX", emoticonX + 5
		wechatMainObject.Add "InputY", emoticonY + 50
		LeftClick 1
	Else    
	    MessageBox "激活输入框失败"
	    ExitScript
	End If
End Function

// 3.访问链接
Function Browse(url)
	// 3.1.输入并发送内容
	MoveTo wechatMainObject("InputX"), wechatMainObject("InputY")
	LeftClick 1
	SayString url
	KeyPress "Enter", 1
	
	// 3.2.浏览内容
	Delay 300
//	FindColorEx 727,422,1128,464,"8E785C",0,0.7,intX,intY
	FindColorEx wechatMainObject("InputX"), wechatMainObject("T")+62, wechatMainObject("R")-72, wechatMainObject("InputY"), "8E785C", 2, 0.7, x, y
	If x > 0 And y > 0 Then 
		MoveTo x, y
	End If
	LeftClick 1// 点击打开文章
	Delay 5000
	wechatChrome = Plugin.Window.Find("Chrome_WidgetWin_0", "微信")
	Delay 200
	Call Plugin.Window.Show(wechatChrome)// 显示窗口
	Call Plugin.Window.Active(wechatChrome)
	Call Plugin.Window.Top(wechatChrome, 0)
	wechatChromeRect = Plugin.Window.GetClientRect(wechatChrome)
	wechatChromeRectArray = Split(wechatChromeRect, "|")
	L = CLng(wechatChromeRectArray(0))
	T = CLng(wechatChromeRectArray(1))
	R = CLng(wechatChromeRectArray(2))
	B = CLng(wechatChromeRectArray(3))
	MoveTo L + 10, T + 50
	Delay 1000
	For 5
		MouseWheel -10 
		Delay 1000
	Next
	
	// 3.3.关闭浏览
	Call Plugin.Window.CloseEx(wechatChrome)
End Function



// 读取任务列表
//Text = Plugin.File.ReadFileEx(dataSourcePath)  
//MyArray = Split(Text, "|")   
//If UBound(MyArray) >= 0 Then 
//	For i = 0 To UBound(MyArray)
//		url = Cstr(MyArray(i))
//		If url <> "" Then // 忽略空行
//    		Browse (url)
//    	End If
//	Next
//End If

