<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>일정 게시판 상세 페이지</title>
<script type="text/javascript" src="script/member.js"></script>
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
			<br> <a href="member/Master.jsp" class="item-link active" id="pageLink">
				<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24"
					fill="none" stroke="currentColor" stroke-linecap="round"
					stroke-linejoin="round" stroke-width="2"
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
			
				<h2>일정 게시판 상세</h2>
				<table>
					<tr>
						<th style="width:20%">작성자</th>
						<td style="width:80%">${world.userid}</td>
					</tr>
					<tr>
						<th>대륙</th>
						<td>${world.continent}</td>
					</tr>
					<tr>
						<th>제목</th>
						<td>${world.title}</td>
					</tr>
					<tr>
						<th>소개</th>
						<td>
							<div style="height=220px; width=100%;">${world.introduce}</div>
						</td>
					</tr>
					<tr>
						<th>일정</th>
						<td id="schedule">						
							<%-- ${world.schedule} --%>
						</td>
					</tr>
					<tr>
						<th>댓글</th>
						<td id="message"></td> 
						<input type="hidden" name="message" id="message1"> 
					</tr>
				</table>
				<br>
				<input type="button" value="목록" onclick="location.href='adminWorldList.do'">
			</section>

		</div>
	</div>
<form action="worlddeletemessage.do" method="post" name="frm" id="frm">
	<input type="hidden" name="Usermessage" id="Usermessage">
	<textarea hidden id="title" name="title">${world.title}</textarea>
</form>
<form id="PM" name="PM" action="worldmessage.do" method="post">
	<input type="hidden" name="user" id="user" form="PM">
	<input type="hidden" name="title" value="${world.title}" form="PM">
	<input type="hidden" name="userid" value="관리자" form="PM">
	<input type="hidden" name="message" form="PM">
</form>	
	
<script>
function chunk(arr, size) {
	var i, j, temparray = [], chunk = size;
    for (i = 0, j = arr.length; i < j; i += chunk) {
    	temparray.push(arr.slice(i, i + chunk));
    }
    return temparray
}

var schedule = null;
schedule = "${world.schedule}";
console.log(schedule);

schedule = schedule.split(',');
console.log(schedule);
schedule = chunk(schedule, 7);
console.log(schedule);

for(var i=0;i<schedule.length;i++){
	
	schedule[i][0] = "위도: " + schedule[i][0] +"<br>";
	schedule[i][1] = "경도: " + schedule[i][1] +"<br>";
	schedule[i][2] = "몇일: " + schedule[i][2] +"<br>";
	schedule[i][3] = "위치: " + schedule[i][3] +"<br>";
	schedule[i][4] = "날짜: " + schedule[i][4] +"<br>";
	schedule[i][5] = "할것: " + schedule[i][5] +"<br>";
	schedule[i][6] = "기대되는것: " + schedule[i][6] +"<br><br>";
	
}
console.log(schedule);
var schedulelist = null;
for(var i=0;i<schedule.length;i++){
	
	for(var j=0;j<schedule[i].length;j++){
		
		schedulelist += schedule[i][j];
		
	}
	
}
console.log(schedulelist);
if(schedulelist.slice(0,4)=="null"){
	schedulelist = schedulelist.substr(4);
}
console.log(schedulelist);
document.getElementById('schedule').innerHTML = schedulelist;



// ============================================================



var photomessage = null;
photomessage = "${world.message}";	
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

var form = 	"<hr>관리자의 댓글: <input type='text' name='message' form='PM'>&nbsp;<input type='submit' value='전송' form='PM'>";


document.getElementById("message").innerHTML = usermessage + form;
console.log(usermessage);


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