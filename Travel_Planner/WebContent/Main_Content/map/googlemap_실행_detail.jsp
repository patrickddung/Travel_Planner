<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<html>

<head>

    <script src="https://maps.googleapis.com/maps/api/js?key=AIzaSyDjtW34Ax16khc7UYth6--V4pNFX1XlHUE&libraries=places"></script>

    <style type="text/css">
    	@import url('https://fonts.googleapis.com/css2?family=Poppins:wght@100;200;300;400;500;600;700;800;900&display=swap');
		* {
  		margin: 0;
  		padding: 0;
  		font-family: 'Poppins', sans-serif;
		}
		body {
  		min-height: 100vh;
  		/* background: linear-gradient(#7d6cfc, #c635ea); */
		}
		.action {
  		position: fixed;
  		bottom: 100px;
  		left: 200px;
  		width: 50px;
  		height: 50px;
  		background: #fff;
  		border-radius: 50%;
  		cursor: pointer;
  		box-shadow: 0 5px 5px rgba(0,0,0,0.1);
		}
		.action span {
  		position: relative;
  		width: 100%;
  		height: 100%;
  		display: flex;
  		justify-content: center;
  		align-items: center;
  		color: #a13dea;
  		font-size: 2em;
  		transition: .3s ease-in-out;
		}
		.action.active span  {
  		transform: rotate(135deg);
		}

		.action ul {
  		position: absolute;
  		bottom: 55px;
  		background: #fff;
  		min-width: 250px;
  		padding: 20px;
  		border-radius: 20px;
  		opacity: 0;
  		visibility: hidden;
  		transition: .3s;
		}
		.action.active ul {
  		bottom: 65px;
  		opacity: 1;
  		visibility: visible;
  		transition: .3s;
		}
		.action ul li {
  		list-style:none;
   		text-decoration: none;
  		display: flex;
  		justify-content: flex-start;
  		align-items: center;
  		padding: 7px 0;
		}

		.action ul li:hover {
  		font-weight: 600;
		}
		.action ul li:not(:last-child) {
  		border-bottom: 1px solid rgba(0,0,0,0.1);
		}
		.action ul li img {
  		margin-right: 15px;
  		opacity: .2;
  		transform: scale(.7);
		}
		.action ul li:hover img {  
  		opacity: .8;
  		transform: scale(1.0);
		}
    	/*===========================================================================================*/

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
		/*===========================================================================================*/


    </style>

    <script>
    	console.log("선택한 일정의 메세지");				// 선택한일정의 메세지가 잘들어왔는지 확인			
    	console.log("${world.message}");			
    	
    	function chunk(arr, size) {					// 배열을 내가 설정한 값으로 나눌 수 있도록 정의한 함수
        	var i, j, temparray = [], chunk = size;
        	for (i = 0, j = arr.length; i < j; i += chunk) {
            	temparray.push(arr.slice(i, i + chunk));
        	}
        	return temparray
	    }
    	
    	var worldlist = new Array();
    	var world = new Array();
    	var worldchunk = new Array();
    	console.log("선택한 일정의 일정")
    	console.log("${world.schedule}");		// 선택한 일정이 잘들어왔는지 확인
    	
    	worldlist = "${world.schedule}".split(',');		// 선택한 일정을 구분자(',')로 나누어서 배열에넣는다
    	worldchunk = chunk(worldlist, 7);				// 나눈 일정을 마커마다 들어갈 데이터로 나눈다, 마커에 7개의 데이터가 들어감
    	world = worldchunk;								// 다시 배열로 옮긴다
    	console.log("마커마다 데이터를 배열로 만듬");
    	console.log(world);								// 잘옮겨졌는지 확인
    	
    	var worldlatlng_bf = new Array();				
    	var worldday_bf = new Array();
    	var worldschedule_bf = new Array();
    	
    	var worldlatlng_af = new Array();
    	var worldday_af = new Array();
    	var worldschedule_af = new Array();
    	
    	
    	for(var i=0;i<world.length;i++){			// 마커마다 들어갈 데이터를 for문으로 나누어서 각각배열로 옮긴다
    		worldlatlng_bf.push(world[i][0]);		// 마커의 좌표 데이터
    		worldlatlng_bf.push(world[i][1]);		
    		
    		worldday_bf.push(world[i][2]);			// 마커의 라벨 데이터
    		
    		worldschedule_bf.push(world[i][3]);		// 마커의 정보창 데이터
    		worldschedule_bf.push(world[i][4]);
    		worldschedule_bf.push(world[i][5]);
    		worldschedule_bf.push(world[i][6]);
    	}
    	console.log("총 마커의 좌표데이터 배열");				// 배열 마다 잘들어갔는지 확인
    	console.log(worldlatlng_bf);	
    	console.log("총 마커의 라벨데이터 배열");
    	console.log(worldday_bf);
    	console.log("총 마커의 정보창데이터 배열");
    	console.log(worldschedule_bf);
    	
    	worldschedule_af = chunk(worldschedule_bf, 4);		// 마커마다 정보창에 필요한 데이터는 4개씩이기 때문에 4개씩 들어갈수 있게 나눔
    	console.log("마커마다 정보창 데이터 배열");				// 잘들어 갔는지 확인
    	console.log(worldschedule_af);

       
		
        var sidebar;
        
        var map;

        var polyline;
        
        var latlng;
        
        var note1 = worldschedule_af;					// 마커마다 정보창 데이터 배열을 다른 배열로 옮긴다
        console.log("마커마다 정보창 데이터 배열을 다른 배열로 옮김");
        console.log(note1);								// 잘들어갔는지 확인
        
        var data1 = new Array;
        
        data1 = note1;									// 다시 옮긴다
        console.log(data1);								// 잘들어갔는지 확인
        
        var latlng1 = new Array;						
        for(var i =0;i<worldlatlng_bf.length;i++){		// 마커의 좌표데이터를 number타입으로 변환후 다른 배열로 옮김
        	latlng1.push(parseFloat(worldlatlng_bf[i]));
        }
        console.log("마커의 좌표데이터 number타입");			// 잘 바뀌고 옮겨졌는지 확인
        console.log(latlng1);
        
        var latlng2 = chunk(latlng1, 2);				// 위도와 경도를 짝짓는다
        console.log("마커의 좌표데이터가 위도와 경도로 짝지음");	// 잘 짝지어졌는지 확인
        console.log(latlng2);
        
        var lineCoordinates = [];
        var sang = [];
        
        lineCoordinates = latlng2;		
     	
        // 밑에 마커를 생성하는 부분을 제외 하고는 따온 코드여서 입력값과 출력값을 분석해서 체크후 사용하는 코드이다
        // 그래서 100% 이해를 못했지만 animation이 마커의 좌표값을 받아 움직이기 때문에(원래 코드의 locations변수안에 좌표데이터가 들어가있었음)
        // locations 변수안에 위에서 만든 마커의 좌표데이터를 number 값으로 변환한 배열(lineCoordinates)를 넣어서 코드를 이용 
         
        var locations = lineCoordinates;				// animation을 만들기 위해 locations값에 마커의 좌표데이터를 넣어준다
        console.log("animation에 필요한 마커의 좌표데이터"); 	// 잘들어갔는지 확인
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
            
            sidebar = document.getElementById("sidebar");			// sidebar 영역지정 div id="sidebar"
            
            for(var i=0;i<data1.length;i++){						// 마커의 정보창 데이터를 style 지정해서 sidebar에 대입(전체일정)
            	sidebar.innerHTML += "<div style='height:auto;width:400px;'><h2>"+data1[i][0]+"</h2><br><hr>"+data1[i][1]+"<br>"+data1[i][2]+"<br>"+data1[i][3]+"<br></div> ";	
            }
            console.log("sidebar에 들어간 마커의 정보창 데이터(전체일정)"); 		// 잘들어갔는지 확인
			console.log(sidebar.innerHTML);
 	
            var mapOptions = {								// 지도 옵션 생성
            		
                center: new google.maps.LatLng(10,0),

                zoom: 2,
                
                label: worldday_bf,

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
                  label:worldday_bf[i],														// 마커의 라벨데이터를 마커마다 지정
                });
                google.maps.event.addListener(marker, 'click', (function(marker, i) {			// 마커 클릭이벤트, 정보창이 열린다	
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
        
        function message(){				// 댓글창 함수, 댓글을 지울수도 있고 쓸수도 있게
        	openNav();					// 사이드바여는 함수호출
        	
        	console.log("해당 일정의 댓글");			// 해당일정의 댓글 확인
        	console.log("${world.message}");		
        	console.log("해당 일정의 일정제목");			// 해당일정의 일정 제목 확인
        	console.log("${world.title}");
        	
        	// 해당일정의 댓글을 변수로 지정
        	var usermessage = "${world.message}";	
        	// 댓글을 쓸수 있도록 댓글창 생성
        	var message = "<hr>" + '<%= (String) session.getAttribute("id") %>' +"의 댓글: <form action='worldmessage.do' method='post'><input hidden name='title' value='${world.title}'><input type='hidden' name='userid' value='<%= (String) session.getAttribute("id") %>'><input type='text' name='message'><input type='submit' value='전송'></form>";
        	
        	usermessage = usermessage.split("`!@#$");		// 댓글을 구분자로 나누어준다
        	console.log("구분자(,)로 나눈 댓글");
        	console.log(usermessage);						// 잘 나누어졌는지 확인
        	
        	// 지금 접속한 사람의 아이디를 가져온다
        	console.log("지금 접속한 사람의 아이디: " + "<%= (String) session.getAttribute("id") %>");		

        	var Myname = "<%= (String) session.getAttribute("id") %>";
        	var Mynamelength = Myname.length;
        	console.log("지금 접속한 사람의 아이디길이: " + Mynamelength);
        	
        	if(localStorage.getItem("계획") == "전체계획"){		// userWorldlist(개인 일정) 과 Worldlist(전체 일정), 즉 개인페이지와 단체페이지를 나눌때 localStorage값을 매겨주어서 웹에서 인지한다
        		for(var i=0;i<usermessage.length;i++){
        			console.log(usermessage[i].slice(0,Mynamelength));
        			console.log(Myname);
        			// if문을 통해서 만약 지금 접속자와 사진메세지 작성자가 같다면 자기가 쓴 메세지를 지울수 있는 버튼 생성
        			<%-- if(usermessage[i].indexOf("<%= (String) session.getAttribute("id") %>")!=-1){ --%>
        			if(usermessage[i].slice(0,Mynamelength) == Myname){
        				
    					usermessage[i] = "<div id='usermessage"+[i]+"' value='"+usermessage[i]+"'>"+usermessage[i] +"&nbsp;&nbsp;&nbsp;<input type='button' id='delete"+[i]+"' name='delete"+[i]+"' value='x' onclick='remove(this.id)'></div>";
    				
        			}else if(usermessage[i] != "" && usermessage[i] != null){
        				usermessage[i] = usermessage[i] + "<br>";
        			}
        		
        		}
        	}else{
        		
				for(var i=0;i<usermessage.length;i++){
        			
					if(usermessage[i] != "" && usermessage[i] != null){
						usermessage[i] = "<div id='usermessage"+[i]+"' value='"+usermessage[i]+"'>"+usermessage[i] +"&nbsp;&nbsp;&nbsp;<input type='button' id='delete"+[i]+"' name='delete"+[i]+"' value='x' onclick='remove(this.id)'></div>";	
					}    						
        		}
        	}
        	console.log("필요없는 값을 제거한 댓글");		// 필요없는값이 잘 제거되었는지 확인 
        	console.log(usermessage);
        	var UM = null;
        	for(var i=0;i<usermessage.length;i++){	// 댓글을 배열로 다시 옮긴다
        		UM += usermessage[i];
        	}
        	if(UM.slice(0,4) == "null"){			// 만약 댓글에 아직 제거못한 null값이 있다면 제거
        		UM = UM.substr(4);
        	}
        	console.log("null값 제거한 댓글 배열");		// null값이 잘 제거되었는지 확인
        	console.log(UM);
        	
        	document.getElementById('sidebar').innerHTML = "<h2>댓글창</h2><hr>"+UM + message + "<form action='worlddeletemessage.do' method='post' name='frm' id='frm'><input type='hidden' name='Usermessage' id='Usermessage'><input hidden name='title' value='${world.title}'></form>";
        }

        function remove(clicked_id){					// 자기가 적은 메세지를 삭제하기위한 함수		
			console.log(clicked_id);					// 클릭한 메세지의 id값 판별, 메세지마다 id값이 다르다
			clicked_id = clicked_id.substr(6);			// 클릭한 메세지의 id값에 앞에있는 delete제거, 숫자만 남기기 하기 위함이다
			console.log(clicked_id);					// 다시 삭제할 메세지의 id값 확인
			var usermessage = "usermessage" + clicked_id;	// 위에서 확인 메세지 id값에 앞에 usermessage를 더한다
			console.log(usermessage);						// usermessage 확인
			var usermessageid = document.getElementById(usermessage).innerHTML;		// 아까 메세지가 어떤메세지인지 다시 확인
			console.log(usermessageid);												// 값이 제대로 들어갔는지 확인
			usermessageid = usermessageid.split("&nbsp")[0];						// &nbsp를 구분자로 다시자른다
			console.log(usermessageid);												// 잘 잘렸는지 확인
			usermessageid = usermessageid + "`!@#$";								// 다시 DB에 넣기위해 구분자 주기, 구분자를 주는 이유는 배열이아니라 문자열값으로 DB에 넣기 때문에 구분자가 무조건 필요하다
			document.getElementById("Usermessage").value = usermessageid;			// 메세지 삭제폼에 위에있는 구분자 추가한 메세지 값을 넣는다
			console.log("밸류는"+document.getElementById("Usermessage").value);		// 마지막으로 삭제할 메세지가 잘들어갔는지 확인
			document.getElementById("frm").submit();								// 메세지 삭제 form을 submit
		}
        
                
    </script>

</head>

<body>
<div id="container">
    <div id="mapDiv"></div>
    <div id="sidebar">
	</div>
	<div class="action" onclick="actionToggle();">	
  		<span>+</span>
  		<ul>
    		<li><img src="https://www.flaticon.com/svg/static/icons/svg/2111/2111341.svg" alt="" width="25px"><a onclick='closeNav()'>사이드바 닫기</a></li>
   			<li><img src="https://www.flaticon.com/svg/static/icons/svg/1384/1384030.svg" alt="" width="25px"><a onclick='openNav()'>사이드바 열기</a></li>
    		<li><img src="https://www.flaticon.com/svg/static/icons/svg/2111/2111432.svg" alt="" width="25px"><a onclick='sidebarClear()'>사이드바 내용삭제</a></li>
  			<li><img src="https://www.flaticon.com/svg/static/icons/svg/2111/2111432.svg" alt="" width="25px"><a onclick='message()'>댓글창</a></li>
  		</ul>
	</div>
</div>
</body>
<script>
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