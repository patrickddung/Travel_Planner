<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>일정 게시판 페이지</title>
<link rel="stylesheet" href="css/admin_form.css">
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
    <h1>일정 게시판 리스트(관리자)</h1>
    		<form action="multiDeleteWorld.do" onSubmit="return del()">
    		<table>
	    		<tr>
	    			<th style="width:5%"><input type="checkbox" name="all" value="allchk" onclick="allchk(this)"></th>
	    			<!-- <th style="width:5%">대륙</th> -->
	    			<th style="width:15%">일정 제목</th>
	    			<th style="width:10%">작성자</th>	    			
	    			<th style="width:50%">소개</th>
	    			<th style="width:10%">상세</th>
			        <th style="width:10%">삭제</th>
	    		</tr>
		    	<c:forEach var="world" items="${worldList}">
				    <tr>
		        		<td style="align:center;"><input type="checkbox" id="check" name="chk" value="${world.title}" ></td>
		        		<%-- <td>${world.continent}</td> --%>
				        <td>${world.title}</td>
				        <td>${world.introduce}</td>
				     	<td>${world.userid}</td>
				        <td><a href="adminWorldDetail.do?title=${world.title}">상세</a></td>
				        <td><a href="deleteWorldAdmin.do?title=${world.title}" onclick="return removeCheck()">삭제</a></td>
				    </tr>
				</c:forEach>
		    </table>
		
		    <div style="float: right;">
		    	<br>
				<input type="submit" value="삭제" id="delete" >
			</div>
    	</form>
<!-- ==========================페이지============================ -->
		

		<c:set var="page" value="${(empty param.p)?1:param.p}"></c:set>
		<c:set var="startNum" value="${page - (page-1) % 5}"></c:set>
		<c:set var="lastNum" value="${fn:substringBefore(Math.ceil(count/10), '.')}"></c:set>
		
		
		
<!-- 		<table> -->
<!-- 			<tr> -->
<!-- 				<td> -->
<%-- 					<div><span>${(empty param.p)?1:param.p}</span>/${lastNum} pages</div> --%>
<!-- 				</td> -->
<!-- 			</tr> -->
<!-- 		</table> -->
		
		
		<c:if test="${startNum-1 > 0}" >
			<a href="?p=${startNum-1}">이전 </a>
		</c:if>
		<c:if test="${startNum-1 <= 0}">
			<span onclick="alert('이전 페이지가 없습니다.');">이전</span>
		</c:if>
		
		<c:forEach var="i" begin="0" end="4">
			<c:if test="${(i+startNum) <= lastNum}">
				<a style="color:${(page==(i+startNum))?'blue':''}"
					href="?p=${i+startNum}&column=${param.column}&keyword=${param.keyword}">
					${i+startNum}
				</a>
			</c:if>	
		</c:forEach>
<%-- 		${count} --%>
<%-- 		${startNum} --%>
<%-- 		${lastNum} --%>
		<c:if test="${(startNum+4) < lastNum}">
			<a href="?p=${startNum+5}"> 다음</a>
		</c:if>

		<c:if test="${(startNum+4) >= lastNum}">
			<span onclick="alert('다음 페이지가 없습니다.');">다음</span>
		</c:if>
    	<div>
			<form action="searchWorldAdmin.do">
				<select name="column">
					<option ${(param.column=="userid")?"selected":""} value="userid">아이디</option>
					<option ${(param.column=="continent")?"selected":""} value="continent">대륙</option>
					<option ${(param.column=="title")?"selected":""} value="title">글제목</option>
				</select>

				<input type="text" name="keyword" value="${param.keyword}">
				<input type="submit" value="검색">
			</form>
    	</div>
    	
    	</section>
  </div>
  
</body>
<script>
function allchk(allchk)  {
	  const checkboxes 
	       = document.getElementsByName('chk');
	  
	  checkboxes.forEach((checkbox) => {
	    checkbox.checked = allchk.checked;
	  })
	}

document.getElementById('delete').addEventListener('click', function (e) {
	if (document.querySelectorAll('input[type="checkbox"]:checked').length == 0) {
	    alert('하나 이상 체크해주세요.')
	    e.preventDefault();
	} 
})    

function del(){
	if (document.querySelectorAll('input[type="checkbox"]:checked').length != 0 && confirm("삭제하시겠습니까?")) {
		alert("삭제 완료");
	} else {
		alert("취소");
		return false;		
	}	
}

function removeCheck(){
	if(confirm("삭제하시겠습니까?") == true){
		document.removefrm.submit();
	} else{
		return false;
	}
}

</script>
</html>