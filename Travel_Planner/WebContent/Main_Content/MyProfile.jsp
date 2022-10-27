<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>마이프로필</title>
<link href="https://fonts.googleapis.com/css2?family=Do+Hyeon&family=Nanum+Myeongjo&family=Stylish&display=swap" rel="stylesheet">
</head>
<body>
<style>
/* 프로필을 감싸는 가장 바깥쪽의 선 */
.form {
 width: 240px;
 height: 700px;
 border-radius: 25px;
 border: 10px double #999;
}
/* 밖에서 2번째의 선 */
.form2 {
 width: 223px;
 min-width: 200px;
}
</style>
<div class="form">
<div class="form2">
<h1 align="center">마이프로필<br></h1><h2 align="center">${loginUser.name}님</h2> <%-- 프로필 헤더, 가운데 정렬 --%>
<div class="Profile" align="center">
	<p align="center"><img src="https://th.bing.com/th/id/OIP.2c-Xwvhb6aJpF_dRQfzNpQHaHa?w=157&h=180&c=7&r=0&o=5&pid=1.7" style="width:60%" class="dog">
	</p>
</div>
<div class="My_Profile"><br>
	<form action="logout.do">	<!-- post 방식으로 logout.do로 데이터 전송 -->
	<table>
	<tr>
		<!-- 로그인 유저 이름(아이디), 이메일 표시 -->
		<td>
		<center>
		안녕하세요♬<br>
		${loginUser.name}(${loginUser.userid})님
		(${loginUser.email})<br>
		☆환영합니☆<br>
		☆즐거운 하루 보내세요☆
		</center>
		</td>
	</tr>
	<tr>
	<td>
		<center>
		<!-- 로그 아웃, 회원정보변경 수행 -->
		<input type="submit" value="로그아웃">		<!-- input type=submit이라면 굳이 method=post를 적지 않아도 된다-->
		<input type="button" value="회원정보변경" onclick="location.href='updateMember.do?userId=${loginUser.userid}'">
		</center>
	</td>
	</tr>
</table>
</form>
</div>
<div class="sns">
	<td>
		<!-- 로그 아웃, 회원정보변경 수행 -->
		<p style="text-align:center;">
			<input type="button" value="kakao" onClick="location.href='https://www.kakao.com/talk'" style="background-color:#FFFF00; border: 5px double #999">
			<input type="button" value="insta" onClick="location.href='https://www.instagram.com'" style="background-color:#EE82EE; border: 5px double #999">
		</p>
	</td>
</div>
</div>
</div>
</body>
</html>