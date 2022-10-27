<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>사진</title>
<link rel="stylesheet" type="text/css" href="css/table.css">
<script src="script/product.js"></script>
</head>
<body>
<br>
<h2 align="center">사진 수정</h2>

<div id="wrap" align="center">
<form  action="updateProduct.do" method="post" enctype="multipart/form-data" name="frm">
	<table border="2">
		<tr>
			<img src="upload/${product.pictureurl}" style="width:900px; height: auto;"><br>
			<input type="file" name="pictureurl">(이미지 변경시 선택하세요.)
		</tr>
		<tr>
			<th style="width: 10%;">제목</th>
			<td><input style="width:100%;" type="text" name="name" value="${product.name}"></td>
		</tr>
		<tr>
			<th style="width: 10%;">내용</th>
			<td><input style="width:100%;" type="text" name="description" value="${product.description}"></td>
		</tr>
		<tr>
			<th>댓글</th>
			<td id="message"></td> 
			<input type="hidden" name="message" id="message1"> 
		</tr> 
	</table>
	<br>
	<input type="hidden" name="code" value="${product.code}">
	<input style="width:50px;height:auto;" type="submit" value="수정" onclick="return checkProduct()">&nbsp;&nbsp;&nbsp;
	<input style="width:50px;height:auto;"  type="reset" value="취소">&nbsp;&nbsp;&nbsp;
	<input style="width:50px;height:auto;"  type="button" value="목록" onclick="location.href='productuserList.do'">
	<input type="hidden" id="userid" name="userid">
</form>
</div>

<form action="productdeletemessage.do" method="post" name="frm" id="frm">
	<input type="hidden" name="Usermessage" id="Usermessage">
	<textarea hidden id="code" name="code">${product.code}</textarea>
</form>
<form id="PM" name="PM" action="productmessage.do" method="post">
	<input type="hidden" name="user" id="user" form="PM">
	<input type="hidden" name="code" value="${product.code}" form="PM">
	<input type="hidden" name="userid" value="${product.userid}" form="PM">
	<input type="hidden" name="message" form="PM">
</form>
<script>
// 지금 접속한 사람의 아이디를 가져온다
var userid = '<%= (String) session.getAttribute("id") %>';
document.getElementById('userid').value = userid;				// 가져온 아이디를 input id="userid"에 넣는다, 수정을 하기위해

var code = "${product.code}";									// 수정할 사진의 사진번호를 가져온다
console.log("수정할 사진의 사진번호: " + code);						// 수정할 사진의 사진번호를 제대로 가져왔는지 확인한다
document.getElementById("code").value = code;					// 수정할 사진의 사진번호를 input id="code"에 넣는다, 수정을 하기위해

var photomessage = null;										// 수정할 사진의 메세지를 넣을 변수 설정
photomessage = "${product.message}";						 	// 변수에 사진의 메세지를 넣는다
console.log("사진 메세지: " + photomessage);						// 제대로 변수에 들어갔는지 확인한다

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

var form = 	"<hr>${product.userid}의 댓글: <input type='text' name='message' form='PM'>&nbsp;<input type='submit' value='전송' form='PM'>";


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
	document.getElementById("frm").submit();
}
function submit(){
	document.getElementById("PM").submit();
}
</script>
</body>
</html>