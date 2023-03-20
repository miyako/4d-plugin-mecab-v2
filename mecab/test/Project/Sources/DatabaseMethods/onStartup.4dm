インストール

If (Test path name:C476(Get 4D folder:C485(Database folder:K5:14)+"Resources.zip")=Is a document:K24:1)
	DOCUMENT LIST:C474(Get 4D folder:C485(Current resources folder:K5:16); $files; Ignore invisible:K24:16)
	If (Size of array:C274($files)=0)
		TRACE:C157  //まずResourcesフォルダーを展開してください
		SHOW ON DISK:C922(Get 4D folder:C485(Database folder:K5:14)+"Resources.zip")
	End if 
End if 