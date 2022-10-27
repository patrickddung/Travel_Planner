<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>사진</title>
<link rel="stylesheet" href="css/table.css">
<script src="script/product.js"></script>
</head>
<body>


<div align="center">
	<h2>사진 등록</h2>
	<form  method="post" enctype="multipart/form-data" name="frm">
		<table border="1">
<!-- 
		<tr>
			<th>상품코드</th>
			<td>
				<input type="text" name="code">
			</td>
		</tr> 
-->	
			<tr>
				<th>제목</th>
				<td>
					<input type="text" name="name">
				</td>
			</tr>
			<tr>
				<th>사진</th>
				<td>
					<input type="file" name="pictureurl">
				</td>
			</tr>
			<tr>
				<th>설명</th>
				<td>
					<!-- <input type="text" name="description"> -->
					<textarea cols="80" rows="10" name="description" placeholder="상품 설명을 작성하세요."></textarea>
				</td>
			</tr>
		</table>
		<br>
		<input type="submit" value="등록" onclick="return checkProduct()">
		<input type="reset" value="취소">
		<input type="button" value="목록" onclick="location.href='productuserList.do'">	
		<input type="hidden" id="userid" name="userid">
	</form>
</div>
<script>
var userid = '<%= (String) session.getAttribute("id") %>';
document.getElementById('userid').value = userid;
</script>
</body>
</html>