<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>일정 리스트</title>
<link rel="stylesheet" href="css/table.css">
</head>
<body>
<br>
<div id="wrap" align="center">
	<h2>나의 일정</h2>
	<!-- <a href="writeProduct.do">상품 등록</a> -->
	<%-- ${productList} --%>

	<table class="list" border="1">
		<tr>
			<td colspan="2" style="border:white; text-align:right; padding-right:20px">
			</td>
		</tr>
		
		<tr>
			<th style="width:10%">대륙</th><th style="width:10%">일정 제목</th><th style="width:60%">내용</th><th style="width:10%">상세</th><th style="width:10%">삭제</th>
		</tr>
		<c:forEach var="world" items="${worldUserList}">	
			<tr>
				<td>${world.continent}</td>
				<td id="title">${world.title}</td>
				<td>${world.introduce}</td>		
				<td><a href="worldDetail.do?title=${world.title}">일정상세</a></td>
				<td><a href="worldDelete.do?title=${world.title}">일정삭제</a></td>
			</tr>
		</c:forEach>
	</table>
</div>
<script>
localStorage.removeItem("계획");		// 전체계획과 개인계획을 분리하기위해 사용한 localStorage 값, 여기는 개인계획이여서 전체계획에 필요한 localStorage 값 제거
</script>
</body>
</html>
