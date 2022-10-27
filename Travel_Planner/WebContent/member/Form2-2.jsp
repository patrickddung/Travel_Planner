<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>게시글 삭제</title>
<link rel="stylesheet" href="css/admin_form.css">
<script src="jquery-3.6.1.min.js"></script>
</head>
<body>
<link href="https://fonts.googleapis.com/css2?family=Do+Hyeon&family=Nanum+Myeongjo&family=Stylish&display=swap" rel="stylesheet">
<div class="app-container">
	<div class="left-area">
    	<div class="app-name">메뉴</div>
    	<br>
    	<a href="member/Master.jsp" class="item-link active" id="pageLink">
    		<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" fill="none" stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="2" class="feather feather-grid" viewBox="0 0 24 24">
        		<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3.055 11H5a2 2 0 012 2v1a2 2 0 002 2 2 2 0 012 2v2.945M8 3.935V5.5A2.5 2.5 0 0010.5 8h.5a2 2 0 012 2 2 2 0 104 0 2 2 0 012-2h1.064M15 20.488V18a2 2 0 012-2h3.064M21 12a9 9 0 11-18 0 9 9 0 0118 0z"></path>
      		</svg>
    	</a>
	</div>
  	<div class="main-area">
  		<section class="content-section">
  			<h2>게시판 삭제 페이지</h2>
			<form action="deleteProductAdmin.do" method="post">
				<c:choose>
					<c:when test="${empty Product.pictureurl}}">
						<img style="heigth:auto;width:100%" src="image/noimage.jpg">
					</c:when>
					<c:otherwise>
						<img style="heigth:auto;width:100%" src="upload/${Product.pictureurl}">
					</c:otherwise>
				</c:choose>								
			<table>
				<tr>
    				<th style="width:20%">사진 제목</th>
    				<td style="width:80%">${Product.name}</td>
    			</tr>
				<tr>
					<th>아이디</th>
					<td>${Product.userid}</td>
				</tr>
				<tr>
					<th>내용</th>
					<td>${Product.description}</td>
				</tr>
				<tr>
					<th>댓글</th>
					<td id="usermessage"></td>  
				</tr> 
			</table>
			<br>
			<input type="hidden" name="code" value="${Product.code}"> 
			<input type="submit" value="삭제"> 
			<input type="button" value="목록" onclick="location.href='adminProductList.do'">
			</form>
		</section>
	</div>
</div>
<script>
var photomessage = null;
photomessage = "${Product.message}";	
console.log(photomessage);

if(photomessage.slice(0,9) == "null`!@#$"){
	photomessage = photomessage.slice(9);
}

if(photomessage.slice(0,4) == "null"){
	photomessage = photomessage.slice(4);
}

//document.getElementById('message1').value = photomessage;
console.log(photomessage);
console.log(typeof(photomessage));
photomessage = photomessage.replace('`!@#$`!@#$', '`!@#$');
var message = new Array();
message = photomessage.split("`!@#$");
for(var i=0;i<message.length;i++){
	
}
message  = message.filter(function(item) {
	 return item !== null && item !== undefined && item !== '';
});
console.log(message);

var usermessage = null;
for(var i=0;i<message.length;i++){
	usermessage += message[i]  + "<br>";
}
if(usermessage.slice(0,4) == "null"){
	usermessage = usermessage.slice(4);
}
console.log(usermessage);
document.getElementById("usermessage").innerHTML = usermessage;
</script>
</body>
</html>



