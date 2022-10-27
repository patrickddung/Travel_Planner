<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>회원 정보 수정</title>
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
    <button class="btn-logout">
    <a href="adminLogout.do" class="item-link" id="pageLink">
      <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" fill="none" stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="2" class="feather feather-log-out" viewBox="0 0 24 24">
        <defs/>
        <path d="M9 21H5a2 2 0 01-2-2V5a2 2 0 012-2h4M16 17l5-5-5-5M21 12H9"/>
      </svg>
    </a>
    </button>
  </div>
  <div class="main-area">
  <section class="content-section">
	
	<h2>회원정보 수정 페이지</h2>
	<form action=updateMemberAdmin.do method="post" name="frm">
	<table>
			<tr>
				<th style="width:20%">이름</th>
				<td style="width:80%"><input type="text" name="name" value="${member.name}"></td>	
			</tr>
			<tr>
				<th>아이디</th>
				<td><input type="text" name="userid" value="${member.userid}" readonly></td>	
			</tr>
			<tr>
				<th>암호</th>
				<td><input type="text" name="pwd" value="${member.pwd}"></td>	
			</tr>
			<tr>
				<th>이메일</th>
				<td><input type="text" name="email" value="${member.email}"></td>	
			</tr>
			<tr>
				<th>전화번호</th>
				<td><input type="text" name="phone" value="${member.phone}"></td>	
			</tr>
			<tr>
				<th>닉네임</th>
				<td><input type="text" name="nickname" value="${member.nickname}"></td>	
			</tr>
			<tr>
				<th>소개</th>
				<td><textarea cols="40" rows="5" name="introduce">${member.introduce}</textarea></td>	
			</tr>
			<tr>
				<th>가고싶은 곳 위치</th>
				<td><input type="text" name="userlatlng" value="${member.userlatlng}" readonly></td>	
			</tr>
	</table>
	<br>
	<input type="hidden" name="name" value="${member.userid}">
	<input type="submit" value="수정">
	<input type="reset" value="취소">
	<input type="button" value="목록" onclick="location.href='adminMemberList.do'">
</form>

    
    </section>

</body>
</html>



