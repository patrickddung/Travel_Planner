<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>파일 업로드</title>
</head>
<body>
<form action="../multiUpload.do" method="post", enctype="multipart/form-data">
	1. 첫번째 파일 업로드 : <input type="file" name="uploadFile01"><br>
	2. 두번째 파일 업로드 : <input type="file" name="uploadFile02"><br>
	3. 세번째 파일 업로드 : <input type="file" name="uploadFile03"><br>
	<input type="submit" value="전송">
</form>
</body>
</html>