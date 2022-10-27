<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>사진</title>
<link rel="stylesheet" type="text/css" href="css/table.css">
</head>
<body>
<div id="wrap" align="center">
	<h2>사진 상세</h2>
	<table border="2">
		<tr>
			<img src="upload/${product.pictureurl}" style="width:900px; height: auto;"><br>
		</tr>
		<tr>
			<th style="width: 10%;">제목</th>
			<td>${product.name}</td>
		</tr>
		<tr>
			<th style="width: 10%;">내용</th>
			<td>${product.description}</td>
		</tr>
		<tr>
			<th>댓글</th>
			<td id="usermessage"></td> 
			<!-- <input type="hidden" name="message" id="message"> --> 
		</tr> 
	</table>		
	<br>
	<input type="button" value="목록" onclick="location.href='productuserList.do'">
</div>

<script>
var photomessage = null;
photomessage = "${product.message}";	
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