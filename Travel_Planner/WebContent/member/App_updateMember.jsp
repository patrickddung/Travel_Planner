<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
  <head>
  	<meta charset="UTF-8">
    <title>회원 정보 수정</title>
    <script src="https://polyfill.io/v3/polyfill.min.js?features=default"></script>
    <script type="text/javascript" src="script/member.js"></script>
    
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
    
</head>
<body>
<div id="container">
	<div id="map"></div>
	<div id="sidebar">
	<center><h3>회원 정보 수정</h3></center>
	<form action="updateMember.do" method="post" name="frm">
	<table>
		<tr>
			<td>이름<hr>
			<input type="text" name="name" value="${mVo.name}"></td>
		</tr>
		<tr>
			<td>아이디<hr>
			<input type="text" name="userId" value="${mVo.userid}" readonly></td>
		</tr>
		<tr>
			<td>암호<hr>
			<input type="password" name="userPwd" value="${mVo.pwd}"></td>
		</tr>
		<tr>
			<td>암호 확인<hr>
			<input type="password" name="userPwd_check"></td>
		</tr>
		<tr>
			<td>이메일<hr>
			<input type="text" name="email" value="${mVo.email}"></td>
		</tr>
		<tr>
			<td>전화번호<hr>
			<input type="text" name="phone" value="${mVo.phone}"></td>
		</tr>
		<tr>
			<td>별명<hr>
			<input type="text" name="nickname" id="nickname" value="${mVo.nickname}" ></td>
		</tr>
		<tr>
			<td>자기소개<hr>
			<input type="text" name="introduce" id="introduce" value="${mVo.introduce}" ></td>
		</tr>
		<tr>
			<td>내위치<hr>
			<input type="text" name="userlatlng" id="userlatlng" value="${mVo.userlatlng}" readonly></td>
		</tr>
		<tr>
			<td colspan="2">
				<!-- 태그에 onclick이 있는 경우, onclick을 먼저 수행하고 href로 이동하는 액션 수행 -->
				<!-- onclick에서 return이 false인 경우 href로 이동하는 액션을 수행하지 않음 -->
				<font size="1.5em" color="red">* 모든 사항은 필수사항 입니다.*</font>
				<center>
				<br>
				&nbsp;&nbsp;&nbsp;&nbsp;<input type="submit" value="확인" onclick="return Update()">				<!-- 회원수정 버튼 -->
				&nbsp;&nbsp;&nbsp;&nbsp;<input type="reset" value="취소" onclick="location.href='login.do'">
				<br>
				<br>
				&nbsp;&nbsp;&nbsp;&nbsp;<input type="button" value="회원탈퇴" form="delete" onclick="deleteUser()"> <!-- 회원탈퇴 버튼 -->
				</center>
			</td>
		</tr>
	</table>
	</form>	
	<form action="deleteuser.do" method="post" name="delete" id="delete">
		<input type="hidden" name="userid" value="${mVo.userid}">
	</form>
	</div>
</div>
<script src="https://maps.googleapis.com/maps/api/js?key=AIzaSyDjtW34Ax16khc7UYth6--V4pNFX1XlHUE&libraries=places"></script>
<script src="https://developers.google.com/maps/documentation/javascript/examples/markerclusterer/markerclusterer.js"></script>
<script type="text/javascript">
function deleteUser(){									// 회원탈퇴 버튼을 누르면 실행될 폼 지정 
	document.getElementById('delete').submit();		
}

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
var marker1;

var data = new Array;
var data1 = new Array;

var data_p = new Array;

var city = null;
var date = null;
var what = null;
var like = null;




console.log("내가 가고싶어 하는곳에 좌표값: " + document.getElementById('userlatlng').value);	// DB에 있는 내가 가고싶어하는곳에 좌표값 가져오기
var latlng1 = document.getElementById('userlatlng').value;								// DB에 있는 내가 가고싶어하는곳에 좌표값을 변수 설정
var latlng2 = new Array;
var lineCoordinates = [];
var sang = [];

latlng2 = latlng1.split(',');															// DB에 있는 내가 가고싶어하는곳에 좌표값을 위도와 경도로 자른다
console.log("설정한 좌표값을 위도와 경도로 나눈 배열: " + latlng2);


latlng2.forEach((value, index) => {														// String으로 가져온 좌표값을 number 값으로 바꿔 다시 배열에 넣는다
	  console.log(latlng2.slice(index,index+1));
	  sang[index] = parseFloat(latlng2.slice(index));       	     	  
});
console.log("설정한 좌표값을 number타입으로 바꾼 값: " + sang);
lineCoordinates = chunk(sang,2);														// 위에서 정의한 함수로 좌표값을 나눈다

var note = document.getElementById('introduce').value;									// DB에 있는 자기소개값을 변수로 설정
console.log("설정한 자기소개값: " + note);

var note1 = document.getElementById('nickname').value;									// DB에 있는 닉네임값을 변수로 설정
console.log("설정한 닉네임값: " + note1);

var data = new Array;														
var data1 = new Array;

data = note;																			// DB에 있는 자기소개값을 다시 변수로 설정

data1 = note1;																			// DB에 있는 닉네임값을 다시 변수로 설정

const sidebar = document.getElementById("sidebar"); 		// sidebar

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
    	
	    map = new google.maps.Map(document.getElementById('map'),options);  			// 지도 영역 설정 div id = map
    
    	var infowindow = new google.maps.InfoWindow();									// 마커에 정보창 생성
    
    	var marker,i;																	// 마커 초기화
    	
		google.maps.event.addListener(map, 'click', function (event) {					// 마커클릭시 이벤트
   			
    		if(marker == null && marker1 == null){										// 지도에 마커가 없다면
    			latlng1 = new Array;
    			latlnglatlng = JSON.stringify(event.latLng.toJSON());					// 클릭한 곳에 좌표값을 JSON으로 변환
    	     	coordsnation = JSON.parse(latlnglatlng);								// JSON 값을 다시 Object로 변환
    	      	console.log("클릭한 곳에 좌표값: " + Object.values(coordsnation));			// Object의 값을 체크
    	     	console.log("클릭한 곳에 좌표값의 타입: " + typeof(coordsnation.lat));
    			latlng2 = coordsnation.lat.toFixed(4);									// 클릭한 좌표값을 경도 위도로 나눈다(DB에 넣을것이기때문에 소수점 4자리까지만 설정)							
    			latlng3 = coordsnation.lng.toFixed(4);
    				
    	     	latlng1.push(latlng2);													// 좌표값을 다시 배열로 합친다
    	     	latlng1.push(latlng3);
    			
    			document.getElementById('userlatlng').value = latlng1;					// 좌표값을 DB에 넣을 수 있도록 input id=userlatlng에 넣는다
    			data = document.getElementById('introduce').value;						// 자기소개값을 DB에 넣을 수 있도록 input id=introduce에 넣는다
    			data1 = document.getElementById('nickname').value;						// 닉네임값을 DB에 넣을 수 있도록 input id=nickname에 넣는다
   				addPoint(event.latLng, data, data1);    			
   			}else{																		// 만약 지도에 마커가 있는데 더 생성할려고 한다면 경고창을 띄운다
   				alert("마커는 하나밖에 생성하지 못합니다");
   				alert("다시 설정할려면 기존 마커를 우클릭하여 제거해 주세요");
   			}
    	
    	});
    
    	for (i = 0; i < lineCoordinates.length; i++) {  								
        	marker = new google.maps.Marker({														// 위에서 정의한 좌표값으로 마커 생성
          		position: new google.maps.LatLng(lineCoordinates[i][0], lineCoordinates[i][1]),		
          		map: map,
          		label:data1																			// 마커위에 새길 정보 설정, 위에서 정의한 닉네임값
          		
        		});
        		marker.addListener('rightclick', function() {										// 우클릭시 마커 삭제, 지도에 마커가 1개만 설정할수 있기 때문이다.
        		  	latlnglatlng_del = JSON.stringify(marker.position.toJSON());					// 클릭한 곳에 좌표값을 JSON으로 변환
        	   	  	coordsnation_del = JSON.parse(latlnglatlng_del);								// JSON 값을 다시 Object로 변환
        	      	console.log("삭제한 곳에 좌표값: " + Object.values(coordsnation_del));				// Object의 값을 체크
        	   	  	console.log("삭제한 곳에 좌표값의 타입: " + typeof(coordsnation_del.lat));
        		  	latlng2_del = coordsnation_del.lat.toFixed(4);									// 클릭한 좌표값을 경도 위도로 나눈다(DB에 넣을것이기때문에 소수점 4자리까지만 설정)
        		  	latlng3_del = coordsnation_del.lng.toFixed(4);
        						
        		  	for(let i = 0; i < latlng1.length; i++) {										// 클릭한 좌표값이 아까 설정한 배열에 들어 있다면 제거
        			 	if(latlng1[i] === latlng2_del)  {
        			     	latlng1.splice(i, 1);      			     	 			   
        			 	}
        		  	}
        		  	for(let i = 0; i < latlng1.length; i++) {										// 클릭한 좌표값이 아까 설정한 배열에 들어 있다면 제거
        				if(latlng1[i] === latlng3_del)  {
        			      	latlng1.splice(i, 1); 			    
        			  	}
        		  	}
        			  
        	      	marker.setMap(null);															// 지도에서도 마커를 없앤다
        	      	marker = null;
        	  	});
        		marker.addListener('click', (function(marker, i) {									// 마커클릭시 이벤트, 설정한 정보창이 열리도록
            		return function() {
              			infowindow.setContent(data); infowindow.open(map, marker);					// 정보창안에 있는 데이터 설정, 위에서 설정한 자기소개 값
          	  		}
          		})(marker, i));
        		infowindow = new google.maps.InfoWindow({ content: data, maxWidth: 300 });			// 정보창에 스타일 지정
        	    infowindow.open(map, marker);
        		
    	} 
    	
	}
function addPoint(latlng, data, data1) {															// 마커를 삭제하고 다시 설정할때 쓰이는 함수, 마커 재설정(수정)
   
    marker1 = new google.maps.Marker({
        position: latlng,								// 위에서 설정한 좌표값 
        label: data1,									// 위에서 설정한 닉네임값 마커위에 설정
        map: map,
        animation: google.maps.Animation.DROP,			
        optimized: false,
     });
    marker1.addListener('rightclick', function() {								// 우클릭시 마커 삭제, 지도에 마커가 1개만 설정할수 있기 때문이다.
	  	latlnglatlng_del = JSON.stringify(marker1.position.toJSON());			// 클릭한 곳에 좌표값을 JSON으로 변환
   	  	coordsnation_del = JSON.parse(latlnglatlng_del);						// JSON 값을 다시 Object로 변환
      	console.log("삭제한 곳에 좌표값: " + Object.values(coordsnation_del));		// Object의 값을 체크
   	  	console.log("삭제한 곳에 좌표값의 타입: " + typeof(coordsnation_del.lat));
	  	latlng2_del = coordsnation_del.lat.toFixed(4);							// 클릭한 좌표값을 경도 위도로 나눈다(DB에 넣을것이기때문에 소수점 4자리까지만 설정)
	  	latlng3_del = coordsnation_del.lng.toFixed(4);
					
	  	for(let i = 0; i < latlng1.length; i++) {								// 클릭한 좌표값이 아까 설정한 배열에 들어 있다면 제거
		 	if(latlng1[i] === latlng2_del)  {
		     	latlng1.splice(i, 1);      			     	 			   
		 	}
	  	}
	  	for(let i = 0; i < latlng1.length; i++) {								// 클릭한 좌표값이 아까 설정한 배열에 들어 있다면 제거
			if(latlng1[i] === latlng3_del)  {
		      	latlng1.splice(i, 1); 			    
		  	}
	  	}
		  
      	marker1.setMap(null);													// 지도에서도 마커를 없앤다
      	marker1 = null;
  	});
    marker1.addListener('click', (function(marker) {							// 마커클릭시 이벤트, 설정한 정보창이 열리도록
		return function() {
  			infowindow.setContent(data); 										// 정보창안에 있는 데이터 설정, 위에서 설정한 자기소개 값
  			infowindow.open(map, marker1);				
	  		}
		})(marker));
	infowindow = new google.maps.InfoWindow({ content: data, maxWidth: 300 });	// 정보창에 스타일 지정
    infowindow.open(map, marker1);
}

google.maps.event.addDomListener(window, 'load', initMap);
</script>

</body>
</html>