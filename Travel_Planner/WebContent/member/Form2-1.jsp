<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="EUC-KR">
<title>게시판 수정 페이지</title>
<link rel="stylesheet" href="css/admin_form.css">
<script src="jquery-3.6.1.min.js"></script>

</head>
<body>
	<link
		href="https://fonts.googleapis.com/css2?family=Do+Hyeon&family=Nanum+Myeongjo&family=Stylish&display=swap"
		rel="stylesheet">
	<div class="app-container">
		<div class="left-area">
			<div class="app-name">메뉴</div>
			<br> <a href="member/Master.jsp" class="item-link active"
				id="pageLink"> <svg xmlns="http://www.w3.org/2000/svg"
					width="24" height="24" fill="none" stroke="currentColor"
					stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
					class="feather feather-grid" viewBox="0 0 24 24">
        <path stroke-linecap="round" stroke-linejoin="round"
						stroke-width="2"
						d="M3.055 11H5a2 2 0 012 2v1a2 2 0 002 2 2 2 0 012 2v2.945M8 3.935V5.5A2.5 2.5 0 0010.5 8h.5a2 2 0 012 2 2 2 0 104 0 2 2 0 012-2h1.064M15 20.488V18a2 2 0 012-2h3.064M21 12a9 9 0 11-18 0 9 9 0 0118 0z"></path>
      </svg>
			</a> 
			<button class="btn-logout">
				<a href="adminLogout.do" class="item-link" id="pageLink"> <svg
						xmlns="http://www.w3.org/2000/svg" width="24" height="24"
						fill="none" stroke="currentColor" stroke-linecap="round"
						stroke-linejoin="round" stroke-width="2"
						class="feather feather-log-out" viewBox="0 0 24 24">
        <defs />
        <path
							d="M9 21H5a2 2 0 01-2-2V5a2 2 0 012-2h4M16 17l5-5-5-5M21 12H9" />
      </svg>
				</a>
			</button>
		</div>
		<div class="main-area">
    <section class="content-section">
    	<h1>사진 게시판 수정</h1>
    	<form action="updateProductAdmin.do" method="post" enctype="multipart/form-data" name="frm">
    	<c:choose>
			<c:when test="${empty Product.pictureurl}">
				<img style="heigth:auto;width:100%" src="image/noimage.jpg">
			</c:when>
			<c:otherwise>
				<img style="heigth:auto;width:100%" src="upload/${Product.pictureurl}">
			</c:otherwise>
		</c:choose>
    	<table>
    		<%-- <tr>
   				<td>번호</td>
   				<td>${Product.code}</td>
    		</tr> --%>
    		<tr>
    			<td style="width:20%">사진 제목</td>
    			<td style="width:80%"><input type="text" name="name" value="${Product.name}"></td>
    		</tr>
    		<tr>
    			<td>작성자</td>
    			<td><input type="text" name="userid" value="${Product.userid}"></td>
    		</tr>
    		<tr>
    			<td>사진 파일</td>
    			<td>
					<input type="file" name="pictureurl" value="${Product.pictureurl}">
				</td>
    		</tr>
    		<tr>
    			<td>사진 설명</td>
    			<td><textarea cols="40" rows="5" name="description" style="resize: none;">${Product.description}</textarea></td>
    		</tr>
    		<tr>
    			<td>사진 댓글</td>
    			<td id="message"></td> 
    			<input type="hidden" name="message" id="message1">
    		</tr>
    	</table>	
    	<br>
    		<input type="hidden" name="code" value="${Product.code}"> 
    		<input type="submit" value="수정">
			<input type="button" value="취소" onclick="location.href='adminProductList.do'">
		</form>
    </section>
  </div>
  <form action="productdeletemessage.do" method="post" name="form" id="form">
  	  <input type="hidden" name="Usermessage" id="Usermessage">
	  <input type="hidden" id="code" name="code" value="${Product.code}">
  </form>
  <form id="PM" name="PM" action="productmessage.do" method="post">
	  <input type="hidden" name="user" id="user" form="PM">
	  <input type="hidden" name="code" value="${Product.code}" form="PM">
	  <input type="hidden" name="userid" value="관리자" form="PM">
	  <input type="hidden" name="message" form="PM">
  </form>
<script>
var code = "${Product.code}";
console.log(code);

var photomessage = null;
photomessage = "${Product.message}";	
console.log(photomessage);

if(photomessage.slice(0,9) == "null`!@#$"){
	photomessage = photomessage.slice(9);
}
if(photomessage.slice(0,4) == "null"){
	photomessage = photomessage.slice(4);
}
document.getElementById('message1').value = photomessage;
console.log(photomessage);
console.log(typeof(photomessage));
photomessage = photomessage.replace('`!@#$`!@#$', '`!@#$');
var message = new Array();
message = photomessage.split("`!@#$");
console.log(message);




if(photomessage != null && photomessage != ""){
	for(var i=0;i<message.length;i++){
		if(message[i] != "" && message[i] != null){
			message[i] = "<div id='usermessage"+[i]+"' value='"+message[i]+"'>"+message[i] +"&nbsp;&nbsp;&nbsp;<input type='button' id='delete"+[i]+"' name='delete"+[i]+"' value='x' onclick='remove(this.id)'></div>";		
		}
	}
}
console.log(message);


var usermessage = null;
for(var i=0;i<message.length;i++){
	usermessage += message[i];
}

if(usermessage.slice(0,4) == "null"){
	usermessage = usermessage.slice(4);
}

var form = 	"<hr>관리자의 댓글: <input type='text' name='message' form='PM'><input type='submit' value='전송' form='PM'>";


document.getElementById("message").innerHTML = usermessage + form;
console.log(usermessage);
var user = "updateProduct.do?code=" + code;
document.getElementById("user").value = user;
console.log(user);


function remove(clicked_id){			
	console.log(clicked_id);
	clicked_id = clicked_id.substr(6);
	console.log(clicked_id);
	var usermessage = "usermessage" + clicked_id;
	console.log(usermessage);
	var usermessageid = document.getElementById(usermessage).innerHTML;
	console.log(usermessageid);
	usermessageid = usermessageid.split("&nbsp")[0];
	console.log(usermessageid);
	usermessageid = usermessageid + "`!@#$";
	console.log(usermessageid);
	document.getElementById("Usermessage").value = usermessageid;
	console.log("밸류는"+document.getElementById("Usermessage").value);
	document.getElementById("form").submit();
}
function submit(){
	document.getElementById("PM").submit();
}
</script>
  
</body>
</html>