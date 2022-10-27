<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<html>

<head>

    <script src="https://maps.googleapis.com/maps/api/js?key=AIzaSyDjtW34Ax16khc7UYth6--V4pNFX1XlHUE&libraries=places"></script>
	<script src="https://code.jquery.com/jquery-3.4.1.min.js"></script>
	<script src="https://html2canvas.hertzen.com/dist/html2canvas.min.js"></script>
	
	<link rel="stylesheet" href="css/actiontoggle.css">
    <style type="text/css">
    	#mapDiv .gm-style .gm-style-iw-c {box-shadow: none !important;}
    
        html { 
        height: 100%
        }

        body { 
        height: 100%;
        margin: 5;
        }

        #mapDiv { 
        width: 100%; 
        height: 100%;
        flex-basis: 0;
  		flex-grow: 4;
        }
        
        /* Optional: Makes the sample page fill the window. */

		/* KML*/
		#container {
  		height: 100%;
  		display: flex;
		}

		#sidebar {
  		/* flex-basis: 18rem;
  		flex-grow: 1;
  		padding: 1rem;
  		max-width: 30rem;
  		height: 100%;
  		box-sizing: border-box;
  		overflow: auto; */ 
  	 
  		/* padding: 1rem; */
  		width: 0; /* 0 width - change this with JavaScript */ */
  		position: fixed; /* Stay in place */
  		z-index: 1; /* Stay on top */
  		top: 0;
  		right: 0;
  		background-color: white;
  		overflow-x: hidden; /* Disable horizontal scroll */
  		padding-top: 60px; /* Place content 60px from the top */
  		transition: 0.5s; /* 0.5 second transition effect to slide in the sidebar */
		}
		
		#route {
  		/* flex-basis: 18rem;
  		flex-grow: 1;
  		padding: 1rem;
  		max-width: 30rem;
  		height: 100%;
  		box-sizing: border-box;
  		overflow: auto; */ 
  	 
  		/* padding: 1rem; */
  		width: 0; /* 0 width - change this with JavaScript */ */
  		position: fixed; /* Stay in place */
  		z-index: 1; /* Stay on top */
  		top: 0;
  		right: 0;
  		background-color: white;
  		overflow-x: hidden; /* Disable horizontal scroll */
  		padding-top: 60px; /* Place content 60px from the top */
  		transition: 0.5s; /* 0.5 second transition effect to slide in the sidebar */
		}
		/*===========================================================================================*/

    </style>

    <script>
    	// 일정등록할때 자신이 지은 일정제목 확인
    	console.log("일정제목: " + '<%=(String)session.getAttribute("settitle")%>');
    	// DB에 일정을 등록할때 일정제목이 테이블에서 중복되어서 올리지못할때 경고창을 띄운다, 일정제목은 기본키이기 때문
    	if('<%=(String)session.getAttribute("settitle")%>' != "null"){
    		alert("title이 중복되었습니다. 다른 title을 쓰세요.");
    	}
    	
    	function chunk(arr, size) {						// 배열을 내가 설정한 값으로 나눌 수 있도록 정의한 함수
        	var i, j, temparray = [], chunk = size;
        	for (i = 0, j = arr.length; i < j; i += chunk) {
            	temparray.push(arr.slice(i, i + chunk));
        	}
        	return temparray
	    }
		
        var sidebar;		
        
        var map;

        var polyline;
        
        var latlng;
        
        var note = localStorage.getItem("note");		// 일정을 만들때 설정한 localStorage 값, 마커의 라벨 데이터
        console.log("마커의 라벨 데이터");
        console.log(note);								// 잘들어왔는지 확인
       
        var note1 = localStorage.getItem("note1");		// 일정을 만들때 설정한 localStorage 값, 마커의 정보창의 들어갈 데이터
        console.log("마커의 정보창에 들어갈 데이터");
        console.log(note1);								// 잘들어왔는지 확인
        
        var data = new Array;
        var data1 = new Array;
        
        data = note.split(',');   			// 마커의 라벨 데이터를 구분자(,)로 나눈다, 마커가 여러개이기 때문
        console.log("마커의 라벨 데이터를 구분자(,)로 나눔");
        console.log(data);					// 잘나눠졌는지 확인
        data1 = note1.split(',');			// 마커의 정보창에 들어갈 데이터 구분자로 나눈다, 데이터를 나눠서 그사이에 html 코드를 추가할려고
        console.log("마커의 정보창에 들어갈 데이터를 구분자(,)로 나눔");
        console.log(data1);					// 잘 나눠 졌는지 확인
        
        data1 = chunk(data1, 4);			// 마커마다 4개의 데이터가 들어가기 때문에 4개로 다시 나눠준다 
        console.log(data1);
        
        
        var country = localStorage.getItem("country");		// 처음 대륙선택할때 설정한 localStorage 값, 어떤 대륙에 여행일정인지 판단
        console.log("마커의 좌표 데이터");
        console.log(localStorage.getItem("좌표"));			// 일정을 만들때 설정한 localStorage 값, 마커의 좌표 데이터
        var latlng1 = localStorage.getItem("좌표");			// 다시 변수로 설정해준다
        var latlng2 = new Array;			
        var lineCoordinates = [];
        var sang = [];
        
        latlng2 = latlng1.split(',');						// 변수로 설정해준 마커의 좌표데이터를 구분자(,)로 나누어준다
        console.log("마커의 좌표 데이터를 구분자(,)로 나눔");
        console.log(latlng2);								// 잘 나눠졌는지 확인
        
        latlng2.forEach((value, index) => {					// String으로 되어있는 마커의 좌표데이터를 하나씩 쪼개서 parseFloat을 통해 number 타입으로 바꿔줌
        	  sang[index] = parseFloat(latlng2.slice(index));       	     	  
        });
        console.log("마커의 좌표 데이터 타입을 String에서 number로 바꿈")
        console.log(sang);									// 잘바꿔줬는지 확인
        lineCoordinates = chunk(sang,2);					// 다시 마커의 좌표데이터를 위도와 경도를 짝 지어준다
        console.log("마커의 좌표 데이터를 위도와 경도를 짝지어줌");
        console.log(lineCoordinates);						// 짝이 맞는지 확인
   
        
        var database = new Array();
        for(var i = 0;i<lineCoordinates.length;i++){		// 마커의 라벨,정보창,좌표 데이터들을 마커마다마다 들어갈수 있게 짝지어준다
        	database.push(lineCoordinates[i]);				// 좌표
        	database.push(data[i]);							// 라벨
        	database.push(data1[i]);						// 정보창
        }
        console.log("마커의 총데이터를 짝지어준 배열");				// 잘들어갔는지 확인
        console.log(database);						
        
        
        // 밑에 마커를 생성하는 부분을 제외 하고는 따온 코드여서 입력값과 출력값을 분석해서 체크후 사용하는 코드이다
        // 그래서 100% 이해를 못했지만 animation이 마커의 좌표값을 받아 움직이기 때문에(원래 코드의 locations변수안에 좌표데이터가 들어가있었음)
        // locations 변수안에 위에서 만든 마커의 좌표데이터를 number 값으로 변환한 배열(lineCoordinates)를 넣어서 코드를 이용 
        
        var locations = lineCoordinates;						// animation을 만들기 위해 locations값에 마커의 좌표데이터를 넣어준다
        console.log("animation에 필요한 마커의 좌표데이터"); 			// 잘들어갔는지 확인
        console.log(locations);
        
        function addAnimatedPolyline () {

            //First we iterate over the coordinates array to create a

            // new array which includes objects of LatLng class.

            var pointCount = lineCoordinates.length;

            var polyLoc = [];

            for (var i=0; i < pointCount; i++) {

                var tempLatLng = new google.maps.LatLng(lineCoordinates[i][0], lineCoordinates[i][1]);

                polyLoc.push(tempLatLng);

            }
            

 

            // Defining arrow symbol

            var arrowSymbol = {

                strokeColor: '#070',

                scale: 3,

                path: google.maps.SymbolPath.FORWARD_CLOSED_ARROW

            };

 

            // Polyline properties are defined below

            var departure = polyLoc[0]; //Set to whatever lat/lng you need for your departure location

            var arrival = polyLoc[polyLoc.length - 1]; //Set to whatever lat/lng you need for your arrival location

            polyline = new google.maps.Polyline({

                path: [departure, departure],

                icons: [{

                    icon: arrowSymbol,

                    offset: '100%',
                    
                    repeat: '100px'

                }],

                strokeColor: "#FF0000",

                strokeOpacity: 0.7,

                strokeWeight: 2,

                geodesic: true, //set to false if you want straight line instead of arc

                map: map,

            });

            var step = 0;

            var numSteps; //Change this to set animation resolution

            var timePerStep = 10; //Change this to alter animation speed

            var stepDivide = 10;

			var pathIdx = 0;
	
			var pathDrawLoc = [polyLoc[pathIdx]];

             var interval = setInterval(

               function() {

                   // 여러개의 지점을 각 2개씩 매칭해서 그려나간다. 모두 끝나면 interval 종료

                   if( pathIdx < polyLoc.length-1 ){

              step += 1;

              // 두 지점사의 거리에 따라서 그리는 속도를 달리하도록 한다. (짧을 수록 빨리 끝나게)

              numSteps = calcDistance(polyLoc[pathIdx],polyLoc[pathIdx+1])/stepDivide;

              if (step > numSteps) {

                  step = 0;

                  pathIdx++;

              } else {

              //console.log(polyLoc[pathIdx],polyLoc[pathIdx+1]);

                  var midPoint = new google.maps.geometry.spherical.interpolate(

                  polyLoc[pathIdx],polyLoc[pathIdx+1],step/numSteps);

                  pathDrawLoc.push(midPoint);

                  polyline.setPath(pathDrawLoc);

              }

                   }else{

                  clearInterval(interval);

                   }

            }, timePerStep);

 

            // Calling the arrow animation function

            //animateArrow();

        }

 

        function animateArrow() {

            var counter = 0;

            var accessVar = window.setInterval(function() {

                counter = (counter + 1) % 350;

 

                var arrows = polyline.get('icons');

                arrows[0].offset = (counter / 2) + '%';

                polyline.set('icons', arrows);

            }, 50);

        }

 
		
        function initMap() {

            google.maps.visualRefresh = true;
            
            sidebar = document.getElementById("sidebar");				// sidebar 영역지정 div id="sidebar"
            
            for(var i=0;i<data1.length;i++){							// 마커의 정보창 데이터를 style 지정해서 sidebar에 대입(전체일정)
            	sidebar.innerHTML += "<div style='height:auto;width:400px;'><h2>"+data1[i][0]+"</h2><br><hr>"+data1[i][1]+"<br>"+data1[i][2]+"<br>"+data1[i][3]+"<br></div> ";	
            }
            console.log("sidebar에 들어간 마커의 정보창 데이터(전체일정)"); 		// 잘들어갔는지 확인
			console.log(sidebar.innerHTML);
 

            var mapOptions = {											// 지도 옵션 생성

                center: new google.maps.LatLng(10,0),

                zoom: 2,
                
                label: data,

                mapTypeId: google.maps.MapTypeId.ROADMAP

            };
            

            var mapElement = document.getElementById('mapDiv');				// 지도 영역지정 div id="mapDiv"

            map = new google.maps.Map(mapElement, mapOptions);				// 지도 옵션 지정
            
            var infowindow = new google.maps.InfoWindow();					// 마커 정보창 생성
            
            var marker,i;
            
            for (i = 0; i < locations.length; i++) {  						// for문으로 마커의 데이터 추가
                marker = new google.maps.Marker({
                  position: new google.maps.LatLng(locations[i][0], locations[i][1]),		// 마커의 좌표데이터를 마커마다 지정
                  map: map,
                  label:data[i],															// 마커의 라벨데이터를 마커마다 지정
                  zIndex:9																	// zIndex를 주는 이유는 캡쳐 할때 마커의 라벨데이터가 잘 보이기 위해서
                });
                google.maps.event.addListener(marker, 'click', (function(marker, i) {		// 마커 클릭이벤트, 정보창이 열린다
                    return function() {
                      // 마커마다 정보창 데이터를 style 지정하고 정보창에 데이터를 넣는다 
                      infowindow.setContent("<div style='height:auto;width:400px;'><h2>"+data1[i][0]+"</h2><br><hr>"+data1[i][1]+"<br>"+data1[i][2]+"<br>"+data1[i][3]+"<br></div> ");
                      // 정보창이 열린다
                      infowindow.open(map, marker);                    
                  	  // 열린 정보창에 데이터들이 sidbar에 대입
                      sidebar.innerHTML += "<div style='height:auto;width:400px;'><h2>"+data1[i][0]+"</h2><br><hr>"+data1[i][1]+"<br>"+data1[i][2]+"<br>"+data1[i][3]+"<br></div> ";                  	  
                    }
                  })(marker, i));
            } 
            addAnimatedPolyline();
        }
        
        





// 두 지점사이에 실제 거리를 구하는 공식

        function calcDistance(point1, point2){

        var EARTH_R, Rad, radLat1, radLat2, radDist; 

        var distance, ret;





        EARTH_R = 6371000.0;

        Rad = Math.PI/180;

        radLat1 = Rad * point1.lat();

        radLat2 = Rad * point2.lat();

        radDist = Rad * (point1.lng() - point2.lng());



        distance = Math.sin(radLat1) * Math.sin(radLat2);

        distance = distance + Math.cos(radLat1) * Math.cos(radLat2) * Math.cos(radDist);

        ret = EARTH_R * Math.acos(distance);



        var rtn = Math.round(Math.round(ret) / 1000);

        return  rtn;

        }
        
        google.maps.event.addDomListener(window, 'load', initMap);
        
        function markersClear(){			// 일정을 다시만들고 싶을때 전페이지로 돌아가기위해 만든 함수
        	history.go(-1);
        }
        function route(){					// DB에 일정을 집어넣기위해 만든 함수
        	// 지금 접속자의 id
        	var uid = '<%=(String)session.getAttribute("id")%>';
        	console.log("접속자 id");
        	console.log(uid);
        	// DB에 저장하기 위한 form을 스타일 지정해서 sidebar에 넣는다
    		document.getElementById('sidebar').innerHTML="<div style='height:auto;width:400px;'><form action='joinmap.do' enctype='multipart/form-data' method='post' id='frm' name='database'><h2>경로 저장</h2><br><tr><th>Title</th>&nbsp;<td><input type='text' name='title' id='title'></td></tr><br><tr><th>설명</th><td><textarea style='width:400px;height:auto;resize:none' cols='58' rows='10' id='description' name='description' placeholder='여행 설명을 작성하세요.'></textarea></td></tr><input type='hidden' name='continent' id='continent' value="+country+"><textarea hidden style='width:400px;height:auto;resize:none' cols='58' rows='10' name='schedule' id='schedule' placeholder='여행 설명을 작성하세요.'>"+database+"</textarea><input type='file' name='pictureurl' id='picture'><input type='hidden' name='userid' id='userid' value="+uid+"><input type='submit' value='경로저장'><br></div></form>";
    		// DB에 넣기위해 마커의 데이터들을 schedule영역에 넣은 값
    		console.log("DB에 넣을 마커의 데이터");
    		console.log(document.getElementById('schedule').value);
    	}
        	


    </script>

</head>

<body>
<div id="container">
    <div id="mapDiv"></div>
    <div id="sidebar">
		<a id="picture"></a>
	</div>
	<div class="action" onclick="actionToggle();">	
  		<span>+</span>
  		<ul>
    		<li><img src="https://www.flaticon.com/svg/static/icons/svg/2111/2111341.svg" alt="" width="25px"><a onclick='closeNav()'>사이드바 닫기</a></li>
   			<li><img src="https://www.flaticon.com/svg/static/icons/svg/1384/1384030.svg" alt="" width="25px"><a onclick='openNav()'>사이드바 열기</a></li>
    		<li><img src="https://www.flaticon.com/svg/static/icons/svg/2111/2111432.svg" alt="" width="25px"><a onclick='sidebarClear()'>사이드바 내용삭제</a></li>
   			<li><img src="https://www.flaticon.com/svg/static/icons/svg/1384/1384031.svg" alt="" width="25px"><a onclick='markersClear()'>경로 다시설정</a></li>
   			<li><img src="https://www.flaticon.com/svg/static/icons/svg/1384/1384031.svg" alt="" width="25px"><a onclick='route()'>경로 저장</a></li>		
   			<li><img src="https://www.flaticon.com/svg/static/icons/svg/1384/1384031.svg" alt="" width="25px"><a onclick='submit()'>경로 캡쳐</a></li>			
  		</ul>
	</div>
</div>
</body>

<script>

function submit() {																	// 일정 캡쳐를 위해 만든 함수
	var picture = prompt("캡쳐할 사진 제목은 어떻게 하실껀가요?");							// 일정제목을 직접 지을수 있도록 prompt 함수 호출
	html2canvas(document.querySelector("#mapDiv"),{scale: 1.001,useCORS: true,}).then(canvas => {		// mapDiv를 캡쳐 영역으로 지정
		saveAs(canvas.toDataURL('image/jpg'),picture);						// 사진의 다운로드할 경로,형식 지정
	});
	function saveAs(uri, filename){
		var link = document.createElement('a');				// a 영역 생성
		if(typeof link.download === 'string'){					
			link.href = uri;								// link에 경로 지정,즉 사진을 다운로드 할 경로
			link.download = filename;						// 위에서 받은 filename 즉, 사진 이름
			console.log("사진의 이름");
			console.log(filename);							// 다운로드가 잘되었는지 체크, 위에서 입력한 사진의 이름으로
			document.body.appendChild(link);				
			link.click();
			console.log(link);						
		}else{
			window.open(url);
		}
	}
}

function actionToggle() {					// 액션 메뉴바 생성 함수
	  const action = document.querySelector('.action');
	  action.classList.toggle('active')
}
function sidebarClear(){					// 사이드바 초기화 함수
	document.getElementById('sidebar').innerHTML=" ";
}	

function openNav() {						// 사이드바 여는 함수
  document.getElementById("sidebar").style.width = "427px";
  document.getElementById("sidebar").style.padding = "1rem";  
  document.getElementById("container").style.marginright = "427px";
}


function closeNav() {						// 사이드바 닫는 함수
  document.getElementById("sidebar").style.width = "0";
  document.getElementById("sidebar").style.padding = "0";
  document.getElementById("container").style.marginright = "0";
}
</script>

</html>