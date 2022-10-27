<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>    
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>사진</title>
<link rel="stylesheet" href="css/table.css">
</head>
<body>
<br>
	
<div id="wrap" align="center">
<h2>나의 사진</h2>
<table class="list" border="1">
	<tr>
		<td colspan="7" style="border:white; text-align:right; padding-right:20px">
			<a href="writeProduct.do">사진 등록</a>
		</td>
	</tr>
		
	<tr>
		<!-- <th>코드</th> --><th style="width:10%">사진 제목</th><th style="width:60%">설명</th><th style="width:10%">상세</th><th style="width:10%">수정</th><th style="width:10%">삭제</th>
	</tr>
	<!-- 상품 목록 출력 -->
	<c:forEach var="product" items="${productUserList}">	
		<tr>
			<%-- <td>${product.code}</td> --%>
			<td>${product.name}</td>
			<td>${product.description}</td>	
			<td><a href="productDetail.do?code=${product.code}">사진상세</a></td>
			<td><a href="updateProduct.do?code=${product.code}">사진수정</a></td>
			<td><a href="deleteProduct.do?code=${product.code}">사진삭제</a></td>
		</tr>
	</c:forEach>
</table>
</div>
</body>
</html>