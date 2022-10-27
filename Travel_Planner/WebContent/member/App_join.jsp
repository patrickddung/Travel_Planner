<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
  <head>
  	<meta charset="UTF-8">
    <title>회원가입</title>
    <script src="https://polyfill.io/v3/polyfill.min.js?features=default"></script>
    
    <style>
	#map {
  	flex-basis: 0;
  	flex-grow: 4;
  	height: 100%;
	}
	html,
	body {
  	height: 100%;
  	margin: 0;
  	padding: 0;
	}
	#container {
  	height: 100%;
  	display: flex;
	}
	#sidebar {
  	flex-basis: 20rem;
  	padding: 1rem;
  	max-width: 15rem;
  	height: 100%;
  	box-sizing: border-box;
  	overflow: auto;
	}
	#description {
  	font-family: Roboto;
  	font-size: 15px;
  	font-weight: 300;
	}

	#infowindow-content .title {
	font-weight: bold;
	}

	#infowindow-content {
	display: none;
	}

	#map #infowindow-content {
	display: inline;
	}
    </style> 
<script type="text/javascript" src="script/member.js"></script>   
</head>
<body>

<div id="container">
	<div id="map"></div>
	<div id="sidebar">
	<center><h2>회원 가입</h2></center>
	<form action="join.do" method="post" name="frm">
		<table>
			<tr>
				<td>이름<hr>
				<input type="text" name="name"></td>
			</tr>
			<tr>
				<td>아이디<hr>
					<input type="text" name="userid" id="userid">
					<!-- 중복체크 수행여부 저장 변수 -->
					<input type="hidden" name="checkid">
					<input type="button" value="중복 체크" onclick="checkId()">
				</td>
			</tr>
			<tr>
				<td>암호<hr>
				<input type="password" name="pwd"></td>
			</tr>
			<tr>
				<td>암호확인<hr>
				<input type="password" name="pwd_check"></td>
			</tr>
			<tr>
				<td>이메일<hr>
				<input type="text" name="email"></td>
			</tr>
			<tr>
				<td>전화번호<hr>
				<input type="text" name="phone"></td>
			</tr>
			<tr>
				<td>별명<hr>
				<input type="text" name="nickname" id="nickname"></td>
			</tr>
			<tr>
				<td>자기소개<hr>
				<input type="text" name="introduce" id="introduce"></td>
			</tr>
			<tr>
				<td>내위치<hr>
				<input type="text" name="userlatlng" id="userlatlng" readonly>
				<input type="button" value="내위치 선택" onclick="again()">		<!-- 다시 좌표값을 설정할려면 전페이지로 돌아간다 -->
				</td>
			</tr>
			<tr>
				<td colspan="2">
					<font size="1.5em" color="red">* 모든 사항은 필수사항 입니다.*</font>
					<center>
						<br>
						<input type="submit" value="확인" onclick="return checkJoin()">&nbsp;&nbsp;&nbsp;&nbsp;
						<input type="reset" value="취소">&nbsp;&nbsp;&nbsp;&nbsp;
					</center>
				</td>	
			</tr>
		</table>
		</form>
	</div>
</div>
<script src="https://maps.googleapis.com/maps/api/js?key=AIzaSyDjtW34Ax16khc7UYth6--V4pNFX1XlHUE&libraries=places"></script>
<script src="https://developers.google.com/maps/documentation/javascript/examples/markerclusterer/markerclusterer.js"></script>
<script type="text/javascript">
function chunk(arr, size) {								// 배열을 내가 설정한 값으로 나눌 수 있도록 정의한 함수 
	var i, j, temparray = [], chunk = size;
	for (i = 0, j = arr.length; i < j; i += chunk) {
    	temparray.push(arr.slice(i, i + chunk));
	}
	return temparray
}

var latlnglatlng = new Array;
var latlng1 = new Array;
var coordsnation = new Array;
var latlng2 = null;
var latlng3 = null;
var polyline = new Array;

var latlnglatlng_del = new Array;
var coordsnation_del = new Array;
var latlng1_del = new Array;

var map;
var xhttp = new XMLHttpRequest();
var markers = new Array;
var markers2 = new Array;
var marker;

var data = new Array;
var data1 = new Array;

var data_p = new Array;

var city = null;
var date = null;
var what = null;
var like = null;

document.getElementById('userlatlng').value = localStorage.getItem("custom좌표");					// 전페이지에서 설정한 좌표값 가져오기, input영역인 userlatlng에 값넣기
	
console.log("설정한 좌표값: " + localStorage.getItem("custom좌표"));									// 전페이지에서 설정한 좌표값 확인
var latlng1 = localStorage.getItem("custom좌표");
var latlng2 = new Array;
var lineCoordinates = [];
var sang = [];

latlng2 = latlng1.split(',');																	// 좌표값을 위도와 경도로 자른다
console.log("설정한 좌표값을 위도와 경도로 나눈 배열: " + latlng2);

latlng2.forEach((value, index) => {																// String으로 가져온 좌표값을 number 값으로 바꿔 다시 배열에 넣는다
	  console.log(latlng2.slice(index,index+1));												
	  sang[index] = parseFloat(latlng2.slice(index));       	     	  
});
console.log("설정한 좌표값을 number타입으로 바꾼 값: " + sang);
lineCoordinates = chunk(sang,2);																// 위에서 정의한 함수로 좌표값을 나눈다	

document.getElementById('introduce').value = localStorage.getItem("customnote");				// 전페이지에서 설정한 자기소개값을 input영역인 introduce에 값넣기
document.getElementById('nickname').value = localStorage.getItem("customnote1");				// 전페이지에서 설정한 닉네임값을  input영역인 nickname에 값넣기

var note = localStorage.getItem("customnote");													// 전페이지에서 설정한 자기소개값을 받아서 변수에 넣는다
console.log("설정한 자기소개값: " + note);

var note1 = localStorage.getItem("customnote1");												// 전페이지에서 설정한 닉네임값을 받아서 변수에 넣는다
console.log("설정한 닉네임값: " + note1);

var data = new Array;
var data1 = new Array;

data = note.split(',');   																		// 전페이지에서 설정한 자기소개값을 다시 배열에 넣는다																	
console.log(data);
data1 = note1.split(',');																		// 전페이지에서 설정한 닉네임값을 다시 배열에 넣는다
console.log(data1);

const sidebar = document.getElementById("sidebar"); 											// sidebar 영역 설정
var activeInfoWindow = null; 

var stockholm = {lat:45,lng:10}; 		// 맵 중앙 설정

function initMap(){	
    // 지도 옵션
    var options = {
        zoom:4,
        center:stockholm, 
       	streetViewControl: true,
        draggable:true,
        mapTypeId: "roadmap",
    
		
		// 맵 기본 컨트롤 설정
    	mapTypeControl: true,
  	  	mapTypeControlOptions: {
  	       	position: google.maps.ControlPosition.RIGHT_TOP
  	   	},
  	   	panControl: true,
  	 	panControlOptions: {
  	       	position: google.maps.ControlPosition.RIGHT_TOP
  	    },
  	   	zoomControl: true,
  	   	zoomControlOptions: {
  	       	style: google.maps.ZoomControlStyle.SMALL,
  	       	position: google.maps.ControlPosition.RIGHT_TOP
      	},
 	    	scaleControl: true
        }
    	
	    map = new google.maps.Map(document.getElementById('map'),options);  						// 지도 영역 설정 div id = map
    
    	var infowindow = new google.maps.InfoWindow();												// 마커에 정보창 생성
    
    	var marker,i;																				// 마커 초기화
    
    	for (i = 0; i < lineCoordinates.length; i++) {  
        	marker = new google.maps.Marker({
          		position: new google.maps.LatLng(lineCoordinates[i][0], lineCoordinates[i][1]),		// 마커에 포지션 설정
          		map: map,	
          		label:data1[i]																		// 마커위에 새길 정보 설정, 전페이지에서 가져온 닉네임 값
          		
        		});
        		google.maps.event.addListener(marker, 'click', (function(marker, i) {				// 마커클릭시 이벤트, 설정한 정보창이 열리도록
            		return function() {
              			infowindow.setContent(data[i]); infowindow.open(map, marker);				// 정보창안에 있는 데이터 설정, 전페이지에서 가져온 자기소개 값
          	  		}
          		})(marker, i));
        		infowindow = new google.maps.InfoWindow({ content: data[i], maxWidth: 300 });		// 정보창에 스타일 지정
        	    infowindow.open(map, marker);
    	} 
    	
} 
function again(){
	location.href = 'member/join_before.jsp';														// 마커의 위치를 다시 설정하고 싶을 때 전페이지로 돌아갈수 있도록 정의한 함수
}

google.maps.event.addDomListener(window, 'load', initMap);
</script>

</body>
</html>