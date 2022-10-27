<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
  <head>
  	<meta charset="UTF-8">
    <title>북아메리카_지도</title>
    <script src="https://polyfill.io/v3/polyfill.min.js?features=default"></script>
    <link rel="stylesheet" href="../../css/actiontoggle.css">
   <style>	
	/*===========================================================================================*/
	#map {
  	flex-basis: 0;
  	flex-grow: 4;
  	height: 100%;
	}
	
	/*===========================================================================================*/

	/* Optional: Makes the sample page fill the window. */

	html,
	body {
  	height: 100%;
  	margin: 0;
  	padding: 0;
	}
	
	
	/* KML*/
	#container {
  	height: 100%;
  	display: flex;
  	
  	transition: margin-left .5s; /* If you want a transition effect */
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

	.pac-card {
  	background-color: #fff;
  	border: 0;
  	border-radius: 2px;
  	box-shadow: 0 1px 4px -1px rgba(0, 0, 0, 0.3);
  	margin: 10px;
  	padding: 0 0.5em;
  	font: 400 18px Roboto, Arial, sans-serif;
  	overflow: hidden;
  	font-family: Roboto;
  	padding: 0;
	}

	#pac-container {
  	padding-bottom: 12px;
  	margin-right: 12px;
	}

	.pac-controls {
  	display: inline-block;
  	padding: 5px 11px;
	}

	.pac-controls label {
	font-family: Roboto;
  	font-size: 13px;
  	font-weight: 300;
	}

	#pac-input {
  	background-color: #fff;
  	font-family: Roboto;
  	font-size: 15px;
  	font-weight: 300;
  	margin-left: 12px;
  	padding: 0 11px 0 13px;
  	text-overflow: ellipsis;
  	width: 400px;
	}

	#pac-input:focus {
  	border-color: #4d90fe;
	}

	#title {
  	color: #fff;
  	background-color: #4d90fe;
  	font-size: 25px;
  	font-weight: 500;
  	padding: 6px 12px;
	}

	#target {
  	width: 345px;
	}		
    </style> 
    
</head>
<body>

<input id="pac-input" class="controls" type="text" placeholder="Search Box"/>
<div id="container">
	<div id="map"></div>
	<div id="sidebar"></div>
	<div class="action" onclick="actionToggle();">	
  		<span>+</span>
  		<ul>
    		<li><img src="https://www.flaticon.com/svg/static/icons/svg/2111/2111392.svg" alt="" width="25px"><a onclick="closeNav()">사이드바 닫기</a></li>
    		<li><img src="https://www.flaticon.com/svg/static/icons/svg/2111/2111765.svg" alt="" width="25px"><a onclick="openNav()">사이드바 열기</a></li>
    		<li><img src="https://www.flaticon.com/svg/static/icons/svg/2111/2111432.svg" alt="" width="25px"><a onclick="markersClear()">경로 다시설정</a></li>
   			<li><img src="https://www.flaticon.com/svg/static/icons/svg/1384/1384031.svg" alt="" width="25px"><a onclick="move()">경로설정</a></li>
  		</ul>
	</div>
</div>
<script src="https://maps.googleapis.com/maps/api/js?key=AIzaSyDjtW34Ax16khc7UYth6--V4pNFX1XlHUE&libraries=places"></script>
<script src="https://developers.google.com/maps/documentation/javascript/examples/markerclusterer/markerclusterer.js"></script>
<script type="text/javascript">

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
var markers1 = [];

var data = new Array;
var data1 = new Array;

var data_p = new Array;

var city = null;
var date = null;
var what = null;
var like = null;

var arr1 = new Array;
var arr2 = new Array;
var arr3 = new Array;

var poly1 = null;
var poly2 = null;
var poly3 = null;

const sidebar = document.getElementById("sidebar"); 		// 사이드바 설정

var activeInfoWindow = null; 								// 마커의 정보창이 하나씩만 열리도록 하는 변수 설정

function initMap(){	
    // 지도의 옵션
    var options = {
        zoom:4,
        center:{lat:41.8781136, lng:-87.6297982}, 
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
    	
    	map = new google.maps.Map(document.getElementById('map'),options);			// 지도의 영역 설정 div id="map"
      
      	polyline = new google.maps.Polyline({										// Polyline 설정
          	strokeColor: 'red',
          	strokeWeight: 3,
          	strokeOpacity: 1.0,
          	map: map,
          	geodesic: true,
          	icons: [{
                icon: {path: google.maps.SymbolPath.FORWARD_CLOSED_ARROW},
                offset: '100%',
                repeat: '100px'
            }]
      	});
      	
      	
      	const input = document.getElementById("pac-input");						// 검색창 영역 설정 div id="pac-input"
      	const searchBox = new google.maps.places.SearchBox(input);				// 검색창 영역에 searchBox 설정
      	map.controls[google.maps.ControlPosition.TOP_LEFT].push(input);			// searchBox 위치 설정 
      	
      	searchBox.addListener("places_changed", () => {							// searchBox 이벤트 설정, 검색한 장소 return
          	const places = searchBox.getPlaces();
          	if (places.length == 0) {
              	return;
          	}
          	const bounds = new google.maps.LatLngBounds();						// 검색한 장소 좌표값 return
          	places.forEach((place) => {
              	if (!place.geometry || !place.geometry.location) {
                  	console.log("Returned place contains no geometry");
                  	return;
              	}
            	const icon = {													// 검색한 장소 icon 설정
            		url: "selectcityICON_red_bold.png",
            		scaledSize: new google.maps.Size(25, 25)
            	};
            	
            	var marker1 = new google.maps.Marker({							// 검색한 장소 marker1 설정
            		map,
                	icon,
                	title: place.name,
                	position: place.geometry.location,
            	});
            	marker1.addListener('click',function(){							// marker1 클릭 이벤트	
            		if(arr1.length == 2){										// 만약 보조 polyline이 있다면 제거
            	  		  polyClear();    		  
            	  	} 
            	    	
            	  	latlnglatlng = JSON.stringify(marker1.position.toJSON());	// 클릭한 곳에 좌표값을 JSON으로 변환
            	    coordsnation = JSON.parse(latlnglatlng);					// JSON 값을 다시 Object로 변환
            	    console.log("클릭한 곳에 좌표값: " + Object.values(coordsnation));
            	    console.log("클릭한 곳에 좌표값의 타입: " + typeof(coordsnation.lat));
        			latlng2 = coordsnation.lat.toFixed(4);						// 클릭한 좌표값을 경도 위도로 나눈다(DB에 넣을것이기때문에 소수점 4자리까지만 설정)
        			latlng3 = coordsnation.lng.toFixed(4);
        				
        	     	latlng1.push(latlng2);										// 좌표값을 다시 배열로 합친다
        	     	latlng1.push(latlng3);	
        	     	
        	     	console.log("클릭한 곳에 위도: " + latlng1[0]);					// 좌표값이 제대로 들어갔는지 체크
        	     	console.log("클릭한 곳에 값이 제대로 배열에 들어갔는지 체크: " + latlng1);
        	     	
        	     	localStorage.setItem("좌표",latlng1); 						// 좌표값을 다음페이지에서 쓸 수 있도록 localStorage값 설정
            	     	
        	     	var poznamka = null;										// 일정에 들어갈 변수 설정
        	     	
        	     	while(poznamka == null || poznamka == ""){					// 일정에 null값이 없도록 설정
      	    		  	poznamka = prompt("얼마나 머무르실 예정입니까?(숫자만)", 3);    	// 얼마나 머무를 것인지 설정, 차후 marker위에 label 값이 될 예정
      	    	  	}
        	     	
        	     	data.push(poznamka);										// 입력값 배열에 추가
        	    	localStorage.setItem("note",data);							// 다음페이지에서 쓸수 있도록 localStorage 설정
        	    	console.log("얼마나 머무를 예정: " + data);						// 잘들어갔는지 확인
        	    	
        	    	
        	   		city = prompt("여기는 어디입니까?");								// 일정에 들어갈 위치 이름 값 입력
        	    	while(city == null || city == ""){							// 일정에 null값이 업도록 설정
        	    		city = prompt("여기는 어디입니까?");							// 여기가 어딘지 설정, 차후 marker의 정보창에 기입될 예정
        	    	}
        	    	var poznamka1 = new Array();								// 일정값 넣을 배열 설정
        	    	poznamka1.push(city);										// 일정값 배열에 추가
        	    	console.log("일정: " + poznamka1);							// 잘들어갔는지 확인
        	    	  
        	    	date = prompt("여행하는 날짜?","2022-10-14");					// 일정에 들어갈 여행 날짜 설정
        			while(date == null || date == ""){							// 일정에 null값이 업도록 설정
        				date = prompt("여행하는 날짜?","2022-10-14");				// 여행 날짜가 언젠지 설정, 차후 marker의 정보창에 기입될 예정
        			} 
        			what = prompt("할일?","맥도날드 가기");							// 일정에 들어갈 할일 설정
        			while(what == null || what == ""){							// 일정에 null값이 없도록 설정
        				what = prompt("할일?","맥도날드 가기");						// 할일이 무엇인지 설정, 차후 marker의 정보창에 기입될 예정
        			}
        			like = prompt("기대되는것?","스타벅스 가기");						// 일정에 들어갈 기대되는일 설정
        			while(like == null || like == ""){							// 일정에 null값이 없도록 설정
        				like = prompt("기대되는것?","스타벅스 가기");					// 기대되는것이 무엇인지 설정, 차후 marker의 정보창에 기입될 예정
        			}
        			poznamka1.push(date);										// 일정에 여행날짜 추가
        			poznamka1.push(what);										// 일정에 할일 추가
        			poznamka1.push(like);   	  								// 일정에 기대되는것 추가
        	    	  
        	    	console.log("일정: " + poznamka1);							// 일정 배열에 잘 들어갔는지 확인
        			data1.push(poznamka1);									 	// 일정 배열을 다시 배열로 옮긴다
        			console.log("일정: " + data1);								// 잘 옮겼는지 확인
        	    	localStorage.setItem("note1",data1);						// 다음페이지에서 쓸수 있도록 localStorage 설정
        			  
        	    	attachNote_marker1(marker1, poznamka, poznamka1);			// marker를 생성할수 있도록 함수호출
        	    	addpolyline_marker1(marker1.position);						// polyline을 생성할수 있도록 함수호출
      	    	   
            	});
            	marker1.addListener('rightclick',function(){					// marker1 우클릭 이벤트, marker1 제거
            		if(arr1.length == 2){										// 만약 보조 polyline이 있다면 제거
              		    polyClear();    		  
              	  	}
              	  
              	    latlnglatlng_del = JSON.stringify(marker1.position.toJSON());		// 클릭한 곳에 좌표값을 JSON으로 변환
                 	coordsnation_del = JSON.parse(latlnglatlng_del);					// JSON 값을 다시 Object로 변환
                    console.log("삭제한 곳에 좌표값: " + Object.values(coordsnation_del));	// Object의 값을 체크
                 	console.log("삭제한 곳에 좌표값 타입: " + typeof(coordsnation_del.lat));
            		latlng2_del = coordsnation_del.lat.toFixed(4);						// 클릭한 좌표값을 경도 위도로 나눈다(DB에 넣을것이기때문에 소수점 4자리까지만 설정)
            	    latlng3_del = coordsnation_del.lng.toFixed(4);
            	      
            	    console.log(data);							// 현재 일정 배열에 있는 값 조회
          		    console.log(data1);							
            					
            		for(let i = 0; i < latlng1.length; i++) {	// 좌표값 배열에 있는 값 조회 해서 삭제할 위도 값 있으면 제거 + 같은 인덱스 위치에 일정도 제거
            		  	if(latlng1[i] === latlng2_del)  {
            				latlng1.splice(i, 1);
            				data.splice(i/2,1);
            			}
            		}
            		for(let i = 0; i < latlng1.length; i++) {	// 좌표값 배열에 있는 값 조회 해서 삭제할 경도 값 있으면 제거 + 같은 인덱스 위치에 일정도 제거
            			if(latlng1[i] === latlng3_del)  {
            				latlng1.splice(i, 1);
            				data1.splice(i/2,1);  			    
            			}
            	    }
            		console.log(data);						// 현재 일정 배열에 제대로 제거 되었는지 확인
            		console.log(data1);
          		  
            
            	    localStorage.setItem("좌표",latlng1);		// 삭제하고 남은 데이터 다시 다음페이지에서 쓸수 있도록 localStorage 설정
            		localStorage.setItem("note",data);
            		localStorage.setItem("note1",data1);
            		
                	marker1.setMap(null);						// 삭제할 마커도 삭제
            		removepolyline_marker1(marker1.position);	// 마커와 같이 있는 polyline도 삭제
            	});
            	
            	if (place.geometry.viewport) {
            		bounds.union(place.geometry.viewport);
            	}else {
            		bounds.extend(place.geometry.location);
            	}
            
        	});
        	map.fitBounds(bounds);
    	});
      	
    // 고정 마커 추가 
    markers2 = [
    	
        // 가나
        {
          coords:{lat:6.6666004, lng:-1.6162709},
          iconImage:'assets/img/places/stparkdublin.png',
          content:'<div style="height:auto;width:400px;"><h1>가나-쿠마시</h1>쿠마시는 가나 아샨티 주의 주도이며 구 아샨티 왕국의 수도였다. 수도인 아크라에서 북서쪽으로 약 250km 떨어져 있다. 쿠마시는 적도로부터 북쪽으로 약 482km, 기니만으로터 북쪽으로 약 160km 에 위치한다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://pds.joongang.co.kr/news/component/htmlphoto_mmdata/201809/20/26ed3595-8cff-43a9-993d-ea10be3c0393.jpg"  width="400px" height="auto"></a></div></div>',
        },
        {
          coords:{lat:5.6037168,lng:-0.1869644},
          iconImage:'assets/img/places/botanic garden.png',
          content:'<div style="height:auto;width:400px;"><h1>가나-아크라</h1>아크라는 가나 공화국의 수도이자 약 227만 명의 인구를 가진 가나 최대의 도시이다. 도시 자체도 아크라 메트로폴리스 특구에 속해 있으며, 그 면적은 약 139km²이다. 아크라의 관광지 중에 가나 국립 박물관이 있다. 코토카 국제공항이 있다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="http://t1.gstatic.com/licensed-image?q=tbn:ANd9GcQu2I-J2QaYjQyf8IizvUEk_eGtw2fbYqa5Py-Ald0lE6Biew--obE463IjR99TTzKJ"  width="400px" height="auto"></a></div></div>',
        },
        {
          coords:{lat:5.1315, lng:-1.2794744},
          iconImage:'assets/img/places/stparkdublin.png',
          content:'<div style="height:auto;width:400px;"><h1>가나-케이프코스트</h1>케이프코스트는 가나의 항구 도시로, 중앙 주의 주도이다. 16세기부터 영국과 포르투갈, 스웨덴, 덴마크, 네덜란드의 통치를 받았다. 15세기 포르투갈이 이 곳을 발견했으며 1653년 스웨덴이 케이프코스트 성을 건설했다. 이 성은 현재 세계유산으로 지정되어 있다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="http://t1.gstatic.com/licensed-image?q=tbn:ANd9GcQ2g4qfGjEUmQdgsPRS8f4rYv3UdgYMB8UfWE2DgyBVsKNyTVtpL2zIiX9MlBFU9Vxa"  width="400px" height="auto"></a></div></div>',
        },
        {
          coords:{lat:9.393908, lng:-0.8556313999999999},
          iconImage:'assets/img/places/swordscastle.png',
          content:'<div style="height:auto;width:400px;"><h1>가나-타말레</h1>타말레은 가나 북부 주의 주도이다. 인구는 55만명이다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="http://t2.gstatic.com/licensed-image?q=tbn:ANd9GcSsRv3s_tS_DNb3TYpKJ5kp7VQOxYVvzFdpjS68rssYC-ZEy_wjNS2amu_3AafIYfS5"  width="400px" height="auto"></a></div></div>',
        },
        {
          coords:{lat:10.7875419, lng:-0.8579818},
          iconImage:'assets/img/places/Howth.png',
          content:'<div style="height:auto;width:400px;"><h1>가나-볼가탕가</h1>볼가탕가는 가나의 도시이다. 경작과 가축 사육이 주된 생업이다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://upload.wikimedia.org/wikipedia/commons/thumb/0/08/Bolgatanga_Montage.jpg/220px-Bolgatanga_Montage.jpg"  width="400px" height="auto"></a></div></div>',
        },
        // 가봉
        {
          coords:{lat:0.4161976, lng:9.4672676},
          iconImage:'assets/img/places/buncrana1.png',
          content:'<div style="height:auto;width:400px;"><h1>가봉-리브르빌</h1>볼리브르빌(프랑스어: Libreville)은 가봉의 수도이자 에스튀에르 주의 주도이다. 1849년 해방 노예 출신 인사들에 의해 건설되었다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="http://upload.wikimedia.org/wikipedia/commons/8/83/Libreville.jpg"  width="400px" height="auto"></a></div></div>',
        },

        {
          coords:{lat:-0.7351025999999999, lng:8.7591311},
          iconImage:'assets/img/places/sugarloaf_icon.png',
          content:'<div style="height:auto;width:400px;"><h1>가봉-포트장틸</h1>포르장티는 가봉 서부의 오고웨마리팀 주의 주도로 가봉에서 두번째로 큰 도시다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="http://t2.gstatic.com/licensed-image?q=tbn:ANd9GcS3rDUFh0fakMGfYfmNalUxguDR_WaNQBBk4CcXir2riid97Ms8DD0xMC1OxWPDJUum"  width="400px" height="auto"></a></div></div>',
        },
        {
          coords:{lat:-2.9278774, lng:10.997658},
          iconImage:'assets/img/places/killarney.png',
          content:'<div style="height:auto;width:400px;"><h1>가봉-치방가</h1>치방가는 가봉 남부에 위치한 도시로, 냥가 주의 주도이며 인구는 약 24,000명이다. 치방가 강 유역에 위치하며 N6 도로가 지나간다. 시내에는 공항이 들어서 있다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://www.1blueplanet.com/photos/vatican_city/photo267.jpeg"  width="400px" height="auto"></a></div></div>',
        },
        {
          coords:{lat:-1.6196441, lng:13.6015463},
          iconImage:'assets/img/places/clifs.png',
          content:'<div style="height:auto;width:400px;"><h1>가봉-프랑스빌</h1>프랑스빌 또는 마수쿠는 가봉 남동부에 위치한 도시로, 가봉에서 네 번째로 큰 도시이며 오트오고웨 주의 주도이다. 인구는 약 22,000명이며 광물 무역의 중심지 역할을 한다. 트랜스가봉 철도와 N3 도로가 이 곳을 지나간다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://upload.wikimedia.org/wikipedia/commons/thumb/1/1f/Franceville.jpg/220px-Franceville.jpg"  width="400px" height="auto"></a></div></div>',
        },
        {
          coords:{lat:1.5991751, lng:11.5759672},
          iconImage:'assets/img/places/clifs.png',
          content:'<div style="height:auto;width:400px;"><h1>가봉-오옘</h1>오옘은 월뢰은템 주의 주도이자 가봉의 도시이다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://upload.wikimedia.org/wikipedia/commons/thumb/e/ed/Oyem_taxi.JPG/220px-Oyem_taxi.JPG"  width="400px" height="auto"></a></div></div>',
        },
        // 가이아나
        {
          coords:{lat:6.7963553, lng:-58.1531906},
          iconImage:'assets/img/places/wexford museum.png',
          content:'<div style="height:auto;width:400px;"><h1>가이아나-조지타운</h1>조지타운은 가이아나의 수도이며 인구는 75,000명이다. 데메라라 강의 하구에 위치한 도시로 대서양에 접해 있다. "카리브 해의 정원 도시"라는 별명이 있으며 데메라라마하이카 주에 위치한다. 네덜란드령이었던 시대는 스타브루크로 불리고 있었다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="http://t3.gstatic.com/licensed-image?q=tbn:ANd9GcRUrUuFBwJZJCRMtbwUGqGu_x8Kr-xbZiBV1s7Tcs-uCZYa5DH_OqPW7D4lVYd3BJon"  width="400px" height="auto"></a></div></div>',
        },
        // 감비아
        {
          coords:{lat:13.454375, lng:-16.5753186},
          iconImage:'assets/img/places/wicklow.png',
          content:'<div style="height:auto;width:400px;"><h1>감비아-반줄</h1>반줄은 아프리카 서쪽에 위치한 감비아의 수도로, 같은 이름을 가진 행정 구역 안에 위치한다. 구 명칭은 바서스트였다. 대서양으로 빠져들어가는 감비아 강어귀에 있는 하중도 세인트 메리 섬, 즉 반줄 섬 위에 위치해 있다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="http://t2.gstatic.com/licensed-image?q=tbn:ANd9GcStxGm0op5YFGmL-nGsF40Al9s7-ce3LDggxtmr75dxavspMCNbtKHO9CqcZlhVzVhR"  width="400px" height="auto"></a></div></div>',
        },
        // 과테말라
        {
          coords:{lat:14.633333, lng:-90.66},
          iconImage:'assets/img/places/glendalough.png',
          content:'<div style="height:auto;width:400px;"><h1>과테말라-믹스코</h1>믹스코는 과테말라 과테말라주의 도시로 면적은 132km², 높이는 1,650m, 인구는 688,124명이다. 과테말라의 수도인 과테말라 시에서 19km 정도 떨어진 곳에 위치한다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://upload.wikimedia.org/wikipedia/commons/thumb/8/82/Cerroalux2009.jpg/250px-Cerroalux2009.jpg"  width="400px" height="auto"></a></div></div>',
        },
        {
          coords:{lat:14.8446068, lng:-91.5231866},
          iconImage:'https://cdn.jbsori.com/news/photo/202012/2516_4208_299.jpg',
          content:'<div style="height:auto;width:400px;"><h1>과테말라-케살테낭고</h1>케트살테낭고는 과테말라의 도시로 케트살테낭고 주의 주도이며 면적은 127km², 높이는 2,380m, 인구는 412,000명이다. 원주민 언어로는 셀라후, 셀라라고 부르기도 한다. 과테말라의 수도인 과테말라 시에서 206km 정도 떨어진 곳에 위치한다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="http://t3.gstatic.com/licensed-image?q=tbn:ANd9GcS3zRKfkYr7795YLgSY_Dy17yXVIdjN_wI6B119-fgyvse4hqTp6JQ7hoyobQbUSAbi"  width="400px" height="auto"></a></div></div>',
        },
        {
          coords:{lat:16.9068496, lng: -89.88941},
          iconImage:'assets/img/places/greystones.png',
          content:'<div style="height:auto;width:400px;"><h1>과테말라-플로레스</h1>플로레스는 과테말라 북부에 위치한 도시로 페텐 주의 주도이며 인구는 13,700명이다. 페텐이트사 호에 위치한다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="http://t2.gstatic.com/licensed-image?q=tbn:ANd9GcQ9RZvU3O_yQTFCy9JWosygLxzrITOyyofJ9WlL6kLo__dFeoGBL3eJdjezGY8BjmUw"  width="400px" height="auto"></a></div></div>',
        },
        {
          coords:{lat:15.3588376, lng:-91.4457471},
          iconImage:'assets/img/places/Cashel.png',
          content:'<div style="height:auto;width:400px;"><h1>과테말라-우에우에테낭고</h1>우에우에테낭고는 과테말라 서부에 위치한 도시로 우에우에테낭고 주의 주도이며 면적은 7,400km², 높이는 1,901m, 인구는 81,294명이다. 과테말라의 수도인 과테말라 시에서 269km 정도 떨어진 곳에 위치한다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="http://t1.gstatic.com/licensed-image?q=tbn:ANd9GcR8bGKtIcjkGrMoEU-yhzN65SEAnm7k91FrY3PkGJll53aW7WiBwCCCNqDocSu7KyoL"  width="400px" height="auto"></a></div></div>',
        },
        {
          coords:{lat:15.4630116, lng: -90.3581451},
          iconImage:'assets/img/places/kilkenny.png',
          content:'<div style="height:auto;width:400px;"><h1>과테말라-코반</h1>코반은 과테말라 중부에 위치한 도시로 알타베라파스 주의 주도이며 면적은 2,132km², 높이는 1,320m, 인구는 250,675명이다. 과테말라의 수도인 과테말라 시에서 269km 정도 떨어진 곳에 위치한다. 도시의 경제는 커피 재배가 주를 이룬다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://upload.wikimedia.org/wikipedia/commons/thumb/5/5a/Cob%C3%A1n.jpg/250px-Cob%C3%A1n.jpg"  width="400px" height="auto"></a></div></div>',
        },
        // 그레나다
        {
          coords:{lat:12.1165, lng:-61.67899999999999},
          iconImage:'assets/img/places/butterCork.png',
          content:'<div style="height:auto;width:400px;"><h1>그레나다-그레나다</h1>>그레나다는 카리브 해에 있는 영연방 군주국이다. 수도는 세인트조지스이며 공용어는 영어이다. 그레나다는 ‘향신료의 섬’으로도 알려져 있는데, 그레나다가 세계에서 가장 많은 양의 너트맥과 메이스 작물을 수출하기 때문이다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://t1.daumcdn.net/cfile/tistory/275CC83D59748CE22B"  width="400px" height="auto"></a></div></div>',
        },
        // 조지아
        {
          coords:{lat:42.2662428, lng:42.7180019},
          iconImage:'assets/img/places/prisoncork.png',
          content:'<div style="height:auto;width:400px;"><h1>조지아-쿠타이시</h1>쿠타이시는 조지아 서쪽의 중심지이다. 인구는 약 14만7635명이다. 소비에트 연방 붕괴 이전에는 그루지야 SSR 제2의 공업 도시였고, 자동차 공장 등이 유명했다. 트빌리시로부터는 221킬로미터 지점에 위치해 있다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="http://t2.gstatic.com/licensed-image?q=tbn:ANd9GcT09bYMhrtaETa1ZbfCQ246OJ4pJguknm43_-5riWn0OJXEl7s_GARnHXaOZopCqm1k"  width="400px" height="auto"></a></div></div>',
        },
        {
          coords:{lat:41.7151377, lng:44.827096},
          iconImage:'assets/img/places/malahideB.png',
          content:'<div style="height:auto;width:400px;"><h1>조지아-트빌리시</h1>트빌리시는 조지아의 수도이다. 도시의 면적은 726km²이며 인구는 134만 5천 명이다. 옛 이름은 티플리스이다. 트빌리시는 5세기에 사카르트벨로 왕 바흐탄그 1세 고르가살리에 의해 세워졌다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="http://t3.gstatic.com/licensed-image?q=tbn:ANd9GcS_TLnwDWDQLQfWvysEsstUHr4Etm-zWjAo-_JqWreCL6zjUPRdAxjHUUzXlsCjrPtv"  width="400px" height="auto"></a></div></div>',
        },

        {
          coords:{lat:41.6167547, lng:41.6367455},
          iconImage:'assets/img/places/galway.png',
          content:'<div style="height:auto;width:400px;"><h1>조지아-바투미</h1>바투미는 흑해에 면한 조지아의 항만 도시로, 아자리아의 주도이다. 인구는 약 15만 4100명이다. 바투미에는 조지아 최대의 항구가 있고, 중요한 상공업 도시이다. 터키와의 국경으로부터는 약 20 km지점에 위치해 있다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://pds.joongang.co.kr//news/component/htmlphoto_mmdata/201801/25/ecc3ed81-a274-420f-b1a0-ec94c726c6ea.jpg"  width="400px" height="auto"></a></div></div>',
        },
        {
          coords:{lat:43.0015252, lng:41.0234153},
          iconImage:'assets/img/places/galway.png',
          content:'<div style="height:auto;width:400px;"><h1>조지아-수후미</h1>수후미는 압하지야의 수도이고 흑해와 마주하고 있다. 인구는 92,300명이다. 철도 분기점이기도 하다. 온대 기후이고 식물원으로 유명하다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://media.istockphoto.com/photos/cityscape-of-sukhumi-the-main-city-of-abkhazia-picture-id939822224"  width="400px" height="auto"></a></div></div>',
        },
        {
          coords:{lat:41.8399528, lng:43.3907569},
          iconImage:'assets/img/places/clifsofmoher.png',
          content:'<div style="height:auto;width:400px;"><h1>조지아-보르조미</h1>보르조미는 조지아중부, 카르틀리 주 서부의 도시이자 물의 깨끗한 휴양지로 알려져 있다. 이 마을의 광천으로부터 분출하는 광천수가 유명하고, 이 도시 이름의 광천수도 있다. 인구 약 10,546명이다. 가까운 보르조미 계곡은 경승지이다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="http://t3.gstatic.com/licensed-image?q=tbn:ANd9GcQXPyL-XEMDoBwHaeS9_LcxwIpquWJJp5hc8V-ld1e39aBy5F8CIxgDaxH8w2PIVHAM"  width="400px" height="auto"></a></div></div>',
        },
        // 그리스
        {
          coords:{lat:39.074208, lng:21.824312},
          iconImage:'assets/img/places/Cork.png',
          content:'<div style="height:auto;width:400px;"><h1>그리스-아테네</h1>아테네는 그리스의 수도이자 최대의 도시이며, 아티키 주의 중심 도시이다. 세계적으로 오래된 도시이며, 역사 시대가 개막한 지 3,400년에 이른다. 대략 기원전 11세기 ~ 7세기부터 인간이 정착해 살았던 흔적이 남아있다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="http://t0.gstatic.com/licensed-image?q=tbn:ANd9GcQnnEGadu7L1DQdj_clC4ZHVA4YvTBuzBXt6msh5VHbNnlw3NbVSwd1u0xh9CLfVRLk"  width="400px" height="auto"></a></div></div>',
        },
        {
          coords:{lat:39.66502880000001, lng:20.8537466},
          iconImage:'assets/img/places/Leixlip.png',
          content:'<div style="height:auto;width:400px;"><h1>그리스-요아니나</h1>이오아니나 또는 얀니나, 얀네나는 그리스 북서부 이피로스 주에 위치한 도시이자 주도이다. 아울러 이오아니나 현의 현청 소재지이다. 주변 도시권의 인구는 10만 명에 이르는 대도시이며, 평균 해발 고도 600m 지점에 자리잡고 있다. 도시 서편에는 이오아니나 호수가 있다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="http://t3.gstatic.com/licensed-image?q=tbn:ANd9GcTOV7Qtij3n5o_U3_Nfpr6_9LRl4JdaC6bXXrsarPl44ss0V8PvXvlHCaUV_pYu4tlD"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:39.63902239999999, lng:22.4191254},
            iconImage:'assets/img/places/littlesugarloaf.png',
            content:'<div style="height:auto;width:400px;"><h1>그리스-라리사</h1>라리사는 그리스 테살리아주의 주도이자 라리사현의 현도이다. 그리스의 농업과 운송의 중심지로서 볼로스, 테살로니키, 아테네와 철도로 연결되어 있다. 인구는 약 25만이며 니카이아, 기아눌리 등의 근교 공통체와 자치에 참여하고 있다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="http://t1.gstatic.com/licensed-image?q=tbn:ANd9GcTFVGpYYJpm4xI6gVltzdZCmZvFtI1zrS6yWM0i27iB47jEv_9KfgGwMoaSQk2x5CoS"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:37.0366386, lng:22.1143716},
            iconImage:'assets/img/places/rockabill view.png',
            content:'<div style="height:auto;width:400px;"><h1>그리스-칼라마타</h1>칼라마타는 그리스의 펠로폰네소스 반도에 있는 도시로 메시니아 현의 현청 소재지이다. 면적은 253.2km²이고 최고고도는 21m이다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="http://t0.gstatic.com/licensed-image?q=tbn:ANd9GcTWDiDiNmWppQnFXW76l4J58JFB2yaIoS1paArFbSaIU75t-mC5nIhFLiy-gRLx572w"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:40.6400629, lng:22.9444191},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>그리스-테살로니키</h1>테살로니키는 아테네 다음으로 큰 그리스 제2의 도시이자 그리스령 마케도니아 지방의 중심 도시이다. 이 도시는 명예 지명으로 그리스의 공동 수도라고 일컫기도 하며, 비잔티움 제국 때에는 공동 황제 수도라 일컫기도 하였다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://stuweb.s3.amazonaws.com/photo/1/2/bea75671ce29bfa67bedcda2ea10305d.jpg"  width="400px" height="auto"></a></div></div>',
        },
        // 기니
        {
              coords:{lat:9.641185499999999, lng:-13.5784012},
              iconImage:'assets/img/places/wexford.png',
              content:'<div style="height:auto;width:400px;"><h1>기니-코나크리</h1>코나크리는 기니 공화국의 수도이며 대서양에 접하고 있다. 인구는 166만 973명이다. 기니의 경제적·문화적 중심지로, 시가지 및 중심부는 기니 연안의 톰보 섬에 위치해 있다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="http://t2.gstatic.com/licensed-image?q=tbn:ANd9GcS4VBwONAzFJosSWeayvMKV3p5CmbfucB1y9sXsVoHQiePXatsglAhsgUxDBJ6ebKJ4"  width="400px" height="auto"></a></div></div>',
        },
        {
              coords:{lat:10.3891382, lng:-9.3079214},
              iconImage:'assets/img/places/wexford.png',
              content:'<div style="height:auto;width:400px;"><h1>기니-칸칸</h1>캉칸은 기니 동부에 위치한 도시로, 기니에서 세 번째로 큰 도시이며 인구는 207,790명이다. 캉칸 주의 주도이며 밀로 강과 접한다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://cloudfront-ap-northeast-1.images.arcpublishing.com/chosun/3HSPHXF333Z4GE6ABF7L6S27OQ.jpg"  width="400px" height="auto"></a></div></div>',
        },
        {
              coords:{lat:10.9384532, lng:-14.2764206},
              iconImage:'assets/img/places/wexford.png',
              content:'<div style="height:auto;width:400px;"><h1>기니-보케</h1>보케는 기니 서부에 위치한 도시로, 보케 주의 주도이며 인구는 116,270명이다. 기니비사우 국경 인근에 위치한다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://storage.doopedia.co.kr/upload/_upload/image5/2207/28/220728024375097/220728024375097_thumb_400.jpg"  width="400px" height="auto"></a></div></div>',
        },
        {
              coords:{lat:7.747835899999999, lng:-8.8252502},
              iconImage:'assets/img/places/wexford.png',
              content:'<div style="height:auto;width:400px;"><h1>기니-은제레코레</h1>은제레코레는 기니 동부에 위치한 도시로, 은제레코레 주의 주도이자 은제레코레 현의 현도이며 시장과 은 세공으로 유명한 도시이다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://upload.wikimedia.org/wikipedia/commons/thumb/d/da/Nzerekore.jpg/300px-Nzerekore.jpg"  width="400px" height="auto"></a></div></div>',
        },
        // 기니비사우
        {
              coords:{lat:11.8632196, lng:-15.5843227},
              iconImage:'assets/img/places/wexford.png',
              content:'<div style="height:auto;width:400px;"><h1>기니비사우-비사우</h1>비사우는 기니비사우의 수도로, 인구는 492,004명이다. 제바 강 어귀, 대서양을 바라보는 곳에 위치한 비사우는 나라의 가장 큰 도시이자, 주요 항구, 행정과 군사 중심이다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="http://t1.gstatic.com/licensed-image?q=tbn:ANd9GcS7evZMArvgvwXZ0ARw2vPxCk5QxOxs4MsY55BhW8QNPexHUTPY8AlmrHvD3fUiyRDU"  width="400px" height="auto"></a></div></div>',
        },
        // 나미비아
        {
              coords:{lat:-22.5608807, lng:17.0657549},
              iconImage:'assets/img/places/wexford.png',
              content:'<div style="height:auto;width:400px;"><h1>나미비아-빈트후크</h1>빈트후크는 나미비아의 수도이다. 나미비아의 거의 중앙에 있으며, 남아프리카 공화국과 연결되는 철도가 있다. 도시는 작고 주위가 사막에 둘러싸여 있어 강수량은 적다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="http://t3.gstatic.com/licensed-image?q=tbn:ANd9GcTWVeHtrGDfCVueATK696soXdsINF7CJ2zKig-g-JLjyhrOt39bfHZkb55MQof5xPK6"  width="400px" height="auto"></a></div></div>',
        },
        {
              coords:{lat:-26.6420382, lng:15.1639082},
              iconImage:'assets/img/places/wexford.png',
              content:'<div style="height:auto;width:400px;"><h1>나미비아-뤼데리츠</h1>뤼데리츠는 나미비아 남부에 위치한 카라스주의 도시로, 대서양과 접한 항구 도시이다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="http://t2.gstatic.com/licensed-image?q=tbn:ANd9GcSPKh5k-LRvaJ5G2d5nsfqCjmw59vzRNEsQkxKb3GeE1Kr5UShdJucuZ7dP0WDDK-k-"  width="400px" height="auto"></a></div></div>',
        },
        {
              coords:{lat:-26.5642351, lng:18.1310083},
              iconImage:'assets/img/places/wexford.png',
              content:'<div style="height:auto;width:400px;"><h1>나미비아-케이트만스호프</h1>케이트만스호프는 나미비아 남부에 위치해 있는 도시로, 카라스 주의 주도이며, 케이트만스호프의 인구는 2007년 기준으로 16,800명이다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://imagescdn.gettyimagesbank.com/500/202101/a12215791.jpg"  width="400px" height="auto"></a></div></div>',
        },
        {
              coords:{lat:-17.7894532, lng:15.7057792},
              iconImage:'assets/img/places/wexford.png',
              content:'<div style="height:auto;width:400px;"><h1>나미비아-오샤카티</h1>오샤카티는 나미비아 북부에 있는 인구 37,000명의 마을입니다. 오늘날 오샤나 지역의 수도이자 나미비아에서 가장 큰 도시 중 하나입니다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://cf.bstatic.com/xdata/images/hotel/270x200/21691821.jpg?k=9d111de4a308572d25b18c69b7370aec07a42e7c029a029ea306a9ea6eabb39e&o="  width="400px" height="auto"></a></div></div>',
        },
        {
              coords:{lat:-17.9253295, lng:19.7532148},
              iconImage:'assets/img/places/wexford.png',
              content:'<div style="height:auto;width:400px;"><h1>나미비아-룬두</h1>룬두는 나미비아 북부에 위치한 도시로, 동카방고 주의 주도이며 인구는 36,964명이다. 해발 1,095m에 달하는 지대에 위치한다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://q-xx.bstatic.com/xdata/images/hotel/max1024x768/113879098.jpg?k=3812c8ce6aff7ec484c59e3dff614990456c96c79a17be62ba3daf9a6b87a5c8&o="  width="400px" height="auto"></a></div></div>',
        },
        // 나우루
        {
              coords:{lat:-0.522778, lng:166.931503},
              iconImage:'assets/img/places/wexford.png',
              content:'<div style="height:auto;width:400px;"><h1>나우루-아레니스</h1>나우루 공화국(나우루어: Ripublik Naoero 리퍼블릭 나오에로, 영어: Republic of Nauru) 또는 나우루는 오세아니아의 미크로네시아에 있는 나라이다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://mblogthumb-phinf.pstatic.net/MjAyMTAyMDNfODYg/MDAxNjEyMzEyMjA0NjM0.sGMC0zRcRv1g5k-D61VPBjO8StIzhUue3RbqFLdDtY0g.APmwxUT6OXtBUG5kd69zKa6nFzLpLaJHgWcPJhYawdkg.JPEG.the20thcenturyfarmer/photo-1553947315-42cee3c8c771.jpg?type=w800"  width="400px" height="auto"></a></div></div>',
        },
        // 나이지리아
        {
              coords:{lat:9.0764785, lng:7.398574},
              iconImage:'assets/img/places/wexford.png',
              content:'<div style="height:auto;width:400px;"><h1>나이지리아-아부자</h1>아부자는 나이지리아의 수도이다. 인구는 1,078,700명이다. 1976년 나이지리아 정부가 수도를 라고스에서 이전하는 정책을 추진하고 있었는데, 나이지리아의 새 수도로 아부자가 선정되었다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://youimg1.tripcdn.com/target/100v1f000001h1a25F19A.jpg?proc=source%2Ftrip"  width="400px" height="auto"></a></div></div>',
        },
        {
              coords:{lat:6.5243793, lng:3.3792057},
              iconImage:'assets/img/places/wexford.png',
              content:'<div style="height:auto;width:400px;"><h1>나이지리아-라고스</h1>라고스는 나이지리아, 아프리카 연합의 최대 도시이다. 1991년까지 나이지리아의 수도였으며 현재는 수도가 아부자로 옮겨진 상태이다. <br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://upload.wikimedia.org/wikipedia/commons/8/82/Victoria_Island-Lagos2.jpg"  width="400px" height="auto"></a></div></div>',
        },
        {
              coords:{lat:12.0021794, lng:8.591956099999999},
              iconImage:'assets/img/places/wexford.png',
              content:'<div style="height:auto;width:400px;"><h1>나이지리아-카노</h1>카노는 나이지리아 북부에 있는 도시로 카노 주의 주도입니다. 라고스 다음으로 나이지리아에서 두 번째로 큰 도시로 400만 명이 넘는 시민이 449km² 내에 거주하고 있습니다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://wikiless.org/media/wikipedia/commons/thumb/0/06/KanofromDalaHill.jpg/800px-KanofromDalaHill.jpg"  width="400px" height="auto"></a></div></div>',
        },
        {
              coords:{lat:7.3775355, lng:3.9470396},
              iconImage:'assets/img/places/wexford.png',
              content:'<div style="height:auto;width:400px;"><h1>나이지리아-이바단</h1>이바단은 나이지리아에서 라고스에 이어 두 번째로 큰 도시로, 요루바족이 세운 오래된 도시이다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://storage.doopedia.co.kr/upload/_upload/image5/2205/31/220531024313622/220531024313622_thumb_400.jpg"  width="400px" height="auto"></a></div></div>',
        },
        {
              coords:{lat:6.448270099999999, lng:7.5138947},
              iconImage:'assets/img/places/wexford.png',
              content:'<div style="height:auto;width:400px;"><h1>나이지리아-에누구</h1>에누구(Enugu)는 나이지리아의 도시로, 에누구 주의 주도이며 인구는 722,664명(2005년 기준)이다. 이그보족이 도시 인구의 다수를 차지한다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://upload.wikimedia.org/wikipedia/commons/thumb/0/07/Enugu.jpg/300px-Enugu.jpg"  width="400px" height="auto"></a></div></div>',
        },
        {
              coords:{lat:11.8310981, lng:13.1509672},
              iconImage:'assets/img/places/wexford.png',
              content:'<div style="height:auto;width:400px;"><h1>나이지리아-마이두구리</h1>마이두구리는 나이지리아 북동부에 위치한 도시로, 보르노 주의 주도이며 인구는 1,197,497명이다. 무슬림 인구가 가장 많으며 그 다음으로는 기독교 신자가 많다. <br><br><div style="width:400px;height:auto;"><a href="#"><img src="http://img.segye.com/content/image/2015/06/03/20150603000076_0.jpg"  width="400px" height="auto"></a></div></div>',
        },
        // 남수단
        {
              coords:{lat:4.859363, lng:31.57125},
              iconImage:'assets/img/places/wexford.png',
              content:'<div style="height:auto;width:400px;"><h1>남수단-주바</h1>주바는 남수단의 수도이자 주베크 주의 주도이다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="http://t0.gstatic.com/licensed-image?q=tbn:ANd9GcTHlicIo-3lGwwoxs37fpdKvdc3fru9jTE4niK5iXclQaei3VYEPkOCXpd9lro3LNVQ"  width="400px" height="auto"></a></div></div>',
        },
        {
              coords:{lat:9.5136171, lng:31.6754965},
              iconImage:'assets/img/places/wexford.png',
              content:'<div style="height:auto;width:400px;"><h1>남수단-말라칼</h1>말라칼은 남수단 북동부 백나일 강 우안에 있는 도시이다. 동나일 주의 주도이며 인구는 139,450명이다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://upload.wikimedia.org/wikipedia/commons/thumb/c/cf/South_Sudan_Malakal_Marketplace_Aug_2005.jpg/300px-South_Sudan_Malakal_Marketplace_Aug_2005.jpg"  width="400px" height="auto"></a></div></div>',
        },
        {
              coords:{lat:7.701125200000001, lng:27.9986358},
              iconImage:'assets/img/places/wexford.png',
              content:'<div style="height:auto;width:400px;"><h1>남수단-와우</h1>와우는 남수단의 도시로 와우 주의 주도이며 인구는 136,932명, 높이는 해발 438m이다. 바르알가잘 지방에서 가장 큰 도시이며 수단의 수도인 하르툼을 연결하는 철도가 지나간다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://upload.wikimedia.org/wikipedia/commons/thumb/e/ec/Huts_outside_Wau%2CSudan.jpg/300px-Huts_outside_Wau%2CSudan.jpg"  width="400px" height="auto"></a></div></div>',
        },
        // 남아프리카공화국
        {
              coords:{lat:-33.9248685, lng:18.4240553},
              iconImage:'assets/img/places/wexford.png',
              content:'<div style="height:auto;width:400px;"><h1>남아프리카공화국-케이프타운</h1>케이프타운은 남아프리카 공화국의 입법 수도이다. 아프리칸스어로는 카앞스탇, 이카파 라고 부른다. 이 도시의 배후에는 테이블 산이 있으며, 부근에 희망봉이 있다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="http://t2.gstatic.com/licensed-image?q=tbn:ANd9GcTfd_vOa29DU0mLgNi64CfwgCYXvkGJ_xaSk4rp9TJ6dewMYVoYyQOs7rY-b5d9Qlry"  width="400px" height="auto"></a></div></div>',
        },
        {
              coords:{lat:-29.085214, lng:26.1595761},
              iconImage:'assets/img/places/wexford.png',
              content:'<div style="height:auto;width:400px;"><h1>남아프리카공화국-블럼폰탄</h1>블룸폰테인, 약칭 블룸은 남아프리카 공화국의 사법 수도이며 프리스테이트 주의 주도이다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src=""  width="400px" height="auto"></a></div></div>',
        },
        {
              coords:{lat:-33.9608369, lng:25.6022423},
              iconImage:'assets/img/places/wexford.png',
              content:'<div style="height:auto;width:400px;"><h1>남아프리카공화국-포트엘리자베스</h1><br><br><div style="width:400px;height:auto;"><a href="#"><img src="http://t3.gstatic.com/licensed-image?q=tbn:ANd9GcSBJMEaAcu4xjNbS5qdAos2Pa0D0Uxlp-l12LC27ffQURERWKNBLgRLWO-B9MoxxImk"  width="400px" height="auto"></a></div></div>',
        },
        {
              coords:{lat:-25.7478676, lng:28.2292712},
              iconImage:'assets/img/places/wexford.png',
              content:'<div style="height:auto;width:400px;"><h1>남아프리카공화국-프레토리아</h1>프리토리아는 남아프리카 공화국 3개의 수도 중 하나로 행정 수도이다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="http://t2.gstatic.com/licensed-image?q=tbn:ANd9GcTwUR4sev2Ydpr3kvNsGgF2uKNMUou8aD5a-nG4KjRMM5zHI6c3mUCeOdw05ni24GBN"  width="400px" height="auto"></a></div></div>',
        },
        {
              coords:{lat:-29.83887929999999, lng:30.9548707},
              iconImage:'assets/img/places/wexford.png',
              content:'<div style="height:auto;width:400px;"><h1>남아프리카공화국-다반</h1>더반은 남아프리카 공화국의 항구도시로, 인구가 요하네스버그, 프리토리아에 이어 세번째로 많은 도시이며 도시권으로는 요하네스버그, 케이프타운에 이은 세번째이다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="http://t2.gstatic.com/licensed-image?q=tbn:ANd9GcRFtLbJHSjsEEvWIA5qiH4cIltkViwNo8Wb0dudovX29trZvfCZKydiUSHsxppVTECV"  width="400px" height="auto"></a></div></div>',
        },
        // 네덜란드
        {
              coords:{lat:52.3675734, lng:4.9041389},
              iconImage:'assets/img/places/wexford.png',
              content:'<div style="height:auto;width:400px;"><h1>네덜란드-암스테르담</h1>암스테르담은 네덜란드의 수도이자 최대 도시이다. 그러나 행정의 중심지는 암스테르담으로부터 남서쪽으로 약 50 킬로미터 떨어진 헤이그에 있다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="http://t3.gstatic.com/licensed-image?q=tbn:ANd9GcQl7QL1Nl9U-ViPNA6ipvcULVJGnF4xg2rVNwKx5xFC6DUUdFs1XU8IPR6weMMt6VTA"  width="400px" height="auto"></a></div></div>',
        },
        {
              coords:{lat:51.42314229999999, lng:5.462289699999999},
              iconImage:'assets/img/places/wexford.png',
              content:'<div style="height:auto;width:400px;"><h1>네덜란드-에인트호벤</h1>에인트호번은 네덜란드 남부 노르트브라반트주의 도시이다. 인구는 419,045명이다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="http://t3.gstatic.com/licensed-image?q=tbn:ANd9GcSFmmKZAP570tzz3jLwPXqQ8CiiIEHp_icEOkZtKfXFs_h_PFuVtZePRHSfw_zUyQp3"  width="400px" height="auto"></a></div></div>',
        },
        {
              coords:{lat:51.9244201, lng:4.4777325},
              iconImage:'assets/img/places/wexford.png',
              content:'<div style="height:auto;width:400px;"><h1>네덜란드-로테르담</h1>로테르담은 네덜란드 자위트홀란트주에 있는 유럽 최대의 무역항 로테르담 항이 있는 도시이다. 인구는 약 60만명 이다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="http://t0.gstatic.com/licensed-image?q=tbn:ANd9GcR5dl_qfScoQ4vSD1LUAwHIXPdaHyS8rkQ7H1x7RbPgndyMNQ4O_SOICHdcpW3NWau8"  width="400px" height="auto"></a></div></div>',
        },
        {
              coords:{lat:53.2193835, lng:6.566501799999999},
              iconImage:'assets/img/places/wexford.png',
              content:'<div style="height:auto;width:400px;"><h1>네덜란드-그로닝겐</h1>흐로닝언은 네덜란드 흐로닝언 주의 주도이다. 네덜란드 북부 상공업의 중심 도시로서, 인구는 약 185,000 명이다. <br><br><div style="width:400px;height:auto;"><a href="#"><img src="http://t0.gstatic.com/licensed-image?q=tbn:ANd9GcSRmP7lvgaqBUJdfTSy0xK_HFAt7HKEPk6RyLjJ6BfTS1YNKAyrOUCvgUUpQZ30RKtF"  width="400px" height="auto"></a></div></div>',
        },
        {
              coords:{lat:52.5167747, lng:6.083021899999999},
              iconImage:'assets/img/places/wexford.png',
              content:'<div style="height:auto;width:400px;"><h1>네덜란드-즈볼러</h1>즈볼러는 네덜란드 동부 오버레이설주에 위치한 도시로 오버레이설 주의 주도이며, 800년경에 프리슬란트인 상인들과 카롤루스 대제가 이끄는 군대에 의해 설립되었다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="http://t2.gstatic.com/licensed-image?q=tbn:ANd9GcSps32ylEjh-YSVIB4JsyBP7Z5-YTaozGL2oOqT8pGkTRJ806q88Ff-cvfZtae4SVVb"  width="400px" height="auto"></a></div></div>',
        },
        // 네팔
        {
              coords:{lat:27.7172453, lng:85.3239605},
              iconImage:'assets/img/places/wexford.png',
              content:'<div style="height:auto;width:400px;"><h1>네팔-카트만두</h1>카트만두는 네팔의 수도로 네팔에서 가장 큰 도시이다. 네팔 중앙의 카트만두 계곡에 위치하고 있으며, 더르바르 광장, 스와얌부나트 사원, 부다나트 사원, 파슈파티나트 사원 등은 세계문화유산으로 지정되어 있다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://t1.daumcdn.net/cfile/tistory/2370D64450DC78C71D"  width="400px" height="auto"></a></div></div>',
        },
        {
              coords:{lat:26.4524746, lng:87.27178099999999},
              iconImage:'assets/img/places/wexford.png',
              content:'<div style="height:auto;width:400px;"><h1>네팔-비랏나가르</h1>네팔과 인도 국경을 오가는 물자 무역의 중계 지역이며 주요 산업은 농업과 상업, 공업이다. 주로 쌀과 황마가 재배된다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src=""  width="400px" height="auto"></a></div></div>',
        },
        {
              coords:{lat:28.2095831, lng:83.9855674},
              iconImage:'assets/img/places/wexford.png',
              content:'<div style="height:auto;width:400px;"><h1>네팔-포카라</h1>포카라 는 네팔의 수도인 카트만두에서 서쪽으로 약 200 km 떨어진 곳에 위치한 도시로 약 19만 명의 주민이 살고 있어 네팔에서 두 번째로 큰 도시로 꼽힌다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://www.sasec.asia/uploads/news/2018/biratnagar-gate-news.jpg"  width="400px" height="auto"></a></div></div>',
        },
        {
              coords:{lat:26.7271466, lng:85.9406745},
              iconImage:'assets/img/places/wexford.png',
              content:'<div style="height:auto;width:400px;"><h1>네팔-자낙푸르</h1>자낙푸르는 네팔의 도시로, 자낙푸르담이라고 부르기도 한다. 인구는 약 80,000명이다. 행정 구역상으로는 자낙푸르 구에 속하며 다누사 현의 현청 소재지이다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="http://t0.gstatic.com/licensed-image?q=tbn:ANd9GcRLgG-neLbNlBKhBUnLjbO2RqI4L-LOL2jeMUmH8DNsIoT1EWJnZUNHChlIkYntBerp"  width="400px" height="auto"></a></div></div>',
        },
        // 노르웨이
        {
              coords:{lat:59.9138688, lng:10.7522454},
              iconImage:'assets/img/places/wexford.png',
              content:'<div style="height:auto;width:400px;"><h1>노르웨이-오슬로</h1>오슬로는 노르웨이의 남부 해안에 있는 도시이며, 이 나라의 수도이다. 13세기 호콘 5세에 의하여 수도로 정해져 한자 동맹의 항구로서 번영했다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="http://t3.gstatic.com/licensed-image?q=tbn:ANd9GcQrhjAsOPf2ojyQlI3qis5lY1B4LxCa7kb52WeQyIz2GOWO27VEXPywMEyRjCV3nABW"  width="400px" height="auto"></a></div></div>',
        },
        {
              coords:{lat:60.39126279999999, lng:5.3220544},
              iconImage:'assets/img/places/wexford.png',
              content:'<div style="height:auto;width:400px;"><h1>노르웨이-베르겐</h1>베르겐은 노르웨이 서남부, 호르달란주에 있는 도시이다. 수도 오슬로에서 서북쪽으로 400km 떨어져 있으며, 노르웨이에서 오슬로 다음으로 큰 제2의 도시이다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="http://t1.gstatic.com/licensed-image?q=tbn:ANd9GcTZCIyfQcygKux0rCWzpnRAYUSa4ns9nyuG-d1Jo470Ztgn3fqvDns9MWk9Jq2fRpFF"  width="400px" height="auto"></a></div></div>',
        },
        {
              coords:{lat:69.6492047, lng:18.9553238},
              iconImage:'assets/img/places/wexford.png',
              content:'<div style="height:auto;width:400px;"><h1>노르웨이-트롬쇠</h1>트롬쇠는 노르웨이 북부 트롬스주 에 위치한 도시이다.트롬쇠는 노르웨이에서 일곱 번째로 큰 도시로 북극권 트롬쇠위아섬에 위치해 있다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://upload.wikimedia.org/wikipedia/commons/e/ed/Troms%C3%B8_view.jpg"  width="400px" height="auto"></a></div></div>',
        },
        {
              coords:{lat:63.4305149, lng:10.3950528},
              iconImage:'assets/img/places/wexford.png',
              content:'<div style="height:auto;width:400px;"><h1>노르웨이-트론헤임</h1>트론헤임은 노르웨이 쇠르트뢰넬라그주에 있는 도시이다. 역사적으로는 니다로스라는 이름으로 불리기도 했다. <br><br><div style="width:400px;height:auto;"><a href="#"><img src="http://t3.gstatic.com/licensed-image?q=tbn:ANd9GcT1q8ToEMh28Ys2Bew3W0LfQbFj0IIpH-Ly022J__Sk1hd3nFq7VPhsL6UgmC4kECsg"  width="400px" height="auto"></a></div></div>',
        },
        {
              coords:{lat:68.2343088, lng:14.5682238},
              iconImage:'assets/img/places/wexford.png',
              content:'<div style="height:auto;width:400px;"><h1>노르웨이-스볼베르</h1>인구 4300명의 작은 마을 스볼베르이곳이 로포텐의 행정, 상업의 중심지페리와 여객선이 즐비한 경치까지도 아름다운 해안 도시입니다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="http://t3.gstatic.com/licensed-image?q=tbn:ANd9GcSGbLG0cFmhPbtaex9NNAkhX8-_BJ7VMF_dxXccOl11LeKzuSjPuKVqOS-bJTD4gpk1"  width="400px" height="auto"></a></div></div>',
        },
        // 뉴질랜드
        {
              coords:{lat:-36.8476191, lng:174.7698041},
              iconImage:'assets/img/places/wexford.png',
              content:'<div style="height:auto;width:400px;"><h1>뉴질랜드-오클랜드</h1>오클랜드는 인구 122만 3200명의 뉴질랜드의 최대의 도시로, 북섬 북단에 자리잡고 있다. 오클랜드 반도 기부의 지협상에 자리하고 있다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="http://t1.gstatic.com/licensed-image?q=tbn:ANd9GcRr4SHtElSDWw0tHGhgifVsnposKXo4vBMLK5MZeBOUfe6mg6EGsiCQGHtmqWRD8pkd"  width="400px" height="auto"></a></div></div>',
        },
        {
              coords:{lat:-41.2923814, lng:174.7787463},
              iconImage:'assets/img/places/wexford.png',
              content:'<div style="height:auto;width:400px;"><h1>뉴질랜드-웰링턴</h1>웰링턴은 뉴질랜드의 수도이다. 1865년 오클랜드로부터 이곳으로 수도를 옮겼으며, 오클랜드에 이어 뉴질랜드에서 두 번째로 큰 도시이다. <br><br><div style="width:400px;height:auto;"><a href="#"><img src="http://t0.gstatic.com/licensed-image?q=tbn:ANd9GcSLEcla-YqDKo8YZ0UeNRCU2T14XzYO2TKjrsOUknhj5hqoRoR6f3-2dsscnG_It4EH"  width="400px" height="auto"></a></div></div>',
        },
        {
              coords:{lat:-45.0301511, lng:168.6615141},
              iconImage:'assets/img/places/wexford.png',
              content:'<div style="height:auto;width:400px;"><h1>뉴질랜드-퀸스타운</h1>퀸스타운은 뉴질랜드 남섬 오타고 지방의 내륙, 와카티푸 호수 기슭에 위치한 도시이다. 세계적으로 유명한 관광, 휴양지이다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="http://t1.gstatic.com/licensed-image?q=tbn:ANd9GcTBkYiZC8CPxfsdbi5vL-wqqi5kEHGlDK7-7DpLsNB_GYs6ZNfsCsPAKGCbhx6MXNZg"  width="400px" height="auto"></a></div></div>',
        },
        {
              coords:{lat:-37.6869653, lng:176.1654272},
              iconImage:'assets/img/places/wexford.png',
              content:'<div style="height:auto;width:400px;"><h1>뉴질랜드-타우랑가</h1>타우랑가는 뉴질랜드 북섬 북동부에 있는 베이오브플렌티 지방의 중심 도시이다. 2006년을 기준으로 인구는 101,200명이며, 베이 오브 플렌티 지방의 중심 도시이다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="http://t1.gstatic.com/licensed-image?q=tbn:ANd9GcSyAZ0lf7ouP-al_5vB6EYitEN-uuNhBKINLDvdPDJIpxjsgBR2ryk7Nhxr34i7zYH6"  width="400px" height="auto"></a></div></div>',
        },
        {
              coords:{lat:-43.5320214, lng:172.6305589},
              iconImage:'assets/img/places/wexford.png',
              content:'<div style="height:auto;width:400px;"><h1>뉴질랜드-크라이스트처치</h1>크라이스트처치는 뉴질랜드의 남섬 동쪽에 있는 캔터버리 지방의 주요 도시로, 남섬에서 인구가 가장 많은 도시이다. <br><br><div style="width:400px;height:auto;"><a href="#"><img src="http://t3.gstatic.com/licensed-image?q=tbn:ANd9GcTIBo6mqB4US_tZHG5QjnTG1IY_MUlycMVYrjg_JCIOhDBfp1FGbEjPyJDG5LcE7tgk"  width="400px" height="auto"></a></div></div>',
        },
        // 니제르
        {
              coords:{lat:13.5115963, lng:2.1253854},
              iconImage:'assets/img/places/wexford.png',
              content:'<div style="height:auto;width:400px;"><h1>니제르-니아메</h1>니아메는 서아프리카의 내륙국 니제르의 수도이다. 니제르 최대 도시이자 니제르의 정치·경제의 중심지이다. 내륙 도시이지만 아프리카의 중요한 강의 하나인 나이저강에 접한, 항만 도시이기도 하다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="http://t1.gstatic.com/licensed-image?q=tbn:ANd9GcTQ2EvPS46JzzVa07ExLEud7TKd1DxHz6Kp3VkaoHXXdQJtLLTf91kHMWgjYxo1dQQF"  width="400px" height="auto"></a></div></div>',
        },
        {
              coords:{lat:16.9741689, lng:7.986535},
              iconImage:'assets/img/places/wexford.png',
              content:'<div style="height:auto;width:400px;"><h1>니제르-아가데즈</h1>아가데즈는 아가데즈 주의 주도이며 니제르북부에서 가장 큰 도시다. 2012년 현재 인구는 110,497명이고 고도는 520m다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://heritage.unesco.or.kr/wp-content/uploads/2019/04/hd6_970_i1.jpg"  width="400px" height="auto"></a></div></div>',
        },
        {
              coords:{lat:13.5009779, lng:7.103639599999999},
              iconImage:'assets/img/places/wexford.png',
              content:'<div style="height:auto;width:400px;"><h1>니제르-마라디</h1>마라디는 니제르의 도시로 마라디 주의 주도다. 마라디 주 남부에 위치하며 인구는 174,485명, 높이는 385m다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://upload.wikimedia.org/wikipedia/commons/thumb/d/d6/To_market.jpg/1200px-To_market.jpg"  width="400px" height="auto"></a></div></div>',
        },
        {
              coords:{lat:20.20131, lng:12.9637033},
              iconImage:'assets/img/places/wexford.png',
              content:'<div style="height:auto;width:400px;"><h1>니제르-픽조엄리</h1>니제르 공화국는 서아프리카에 있는 내륙국이며 수도는 니아메이다. 알제리, 리비아, 차드, 말리, 부르키나파소, 나이지리아 등과 국경을 접한다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://msf.or.kr/sites/default/files/MSF261234.jpg"  width="400px" height="auto"></a></div></div>',
        },
        // 니카라과
        {
              coords:{lat:12.865416, lng:-85.207229},
              iconImage:'assets/img/places/wexford.png',
              content:'<div style="height:auto;width:400px;"><h1>니카라과-마나과</h1>마나과는 니카라과의 수도이고 인구는 220만~250만명이다. 중앙아메리카에서 두 번째로 큰 도시이다. <br><br><div style="width:400px;height:auto;"><a href="#"><img src="http://t0.gstatic.com/licensed-image?q=tbn:ANd9GcQEVpXxfI6x2mMscKEAq3QxPH7daNYmQpDZvXAc93nXK7hWN27Zm57LDj7dcIjwlk4g"  width="400px" height="auto"></a></div></div>',
        },
        {
              coords:{lat:12.6234721, lng:-87.1273253},
              iconImage:'assets/img/places/wexford.png',
              content:'<div style="height:auto;width:400px;"><h1>니카라과-치난데가</h1>치난데가는 니카라과의 도시로 치난데가 주의 주도이며 면적은 686.61km², 인구는 121,793명이다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://mediaim.expedia.com/destination/1/ac8c6e14924f9564f43546bed17be372.jpg"  width="400px" height="auto"></a></div></div>',
        },
        {
              coords:{lat:13.0820507, lng:-86.35698440000002},
              iconImage:'assets/img/places/wexford.png',
              content:'<div style="height:auto;width:400px;"><h1>니카라과-에스텔리</h1>에스텔리는 니카라과의 도시로 에스텔리 주의 주도이며, 수도 마나과에서 북쪽에서 150km 정도 떨어진 곳에 위치하며 팬아메리칸 하이웨이가 지나간다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://media.istockphoto.com/photos/salto-de-la-estanzuela-esteli-nicaragua-picture-id505333418"  width="400px" height="auto"></a></div></div>',
        },
        {
              coords:{lat:14.0291463, lng:-83.3925223},
              iconImage:'assets/img/places/wexford.png',
              content:'<div style="height:auto;width:400px;"><h1>니카라과-푸에르트카베사스</h1>푸에르토카베사스는 니카라과의 도시로 북아틀란티코 자치구의 행정 중심지이며 면적은 5,985km², 인구는 66,169명, 인구 밀도는 11명/km²이다. <br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://upload.wikimedia.org/wikipedia/commons/f/f0/Muelle_de_Bilwi%2C_Puerto_Cabezas_%28RAAN%29.jpg"  width="400px" height="auto"></a></div></div>',
        },
        // 덴마크
        {
              coords:{lat:55.6760968, lng:12.5683371},
              iconImage:'assets/img/places/wexford.png',
              content:'<div style="height:auto;width:400px;"><h1>덴마크-쾨벤하운</h1>코펜하겐은 덴마크의 수도이다. 덴마크의 국회, 정부, 왕궁이 모두 코펜하겐에 소재해 있다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="http://t0.gstatic.com/licensed-image?q=tbn:ANd9GcRbPWQ5Q4rNpDu-QT3kzjSEpFSf4HNzqBDuMQXhZqYkO0cEy9AIzH7AlZIr2EbUaNJn"  width="400px" height="auto"></a></div></div>',
        },
        {
              coords:{lat:55.40375599999999, lng:10.40237},
              iconImage:'assets/img/places/wexford.png',
              content:'<div style="height:auto;width:400px;"><h1>덴마크-오덴세</h1>오덴세는 덴마크의 도시로 퓐섬의 중심 도시이다. 인구는 172,512명으로 덴마크에서 세 번째로 인구가 많은 도시이다. <br><br><div style="width:400px;height:auto;"><a href="#"><img src="http://t2.gstatic.com/licensed-image?q=tbn:ANd9GcSFS9Qx1GbmWzhnbogdx7Zy-ZfORVEibGscpxSCIufHkSYtFd7jBN2cmKfFDXyXmhuN"  width="400px" height="auto"></a></div></div>',
        },
        {
              coords:{lat:57.0488195, lng:9.921747},
              iconImage:'assets/img/places/wexford.png',
              content:'<div style="height:auto;width:400px;"><h1>덴마크-올보로그</h1>올보르는 덴마크에서 4번째 도시로 인구는 121,540명이다. 노르윌란 주의 주도이다. "북유럽의 파리"라는 별명이 있다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="http://t2.gstatic.com/licensed-image?q=tbn:ANd9GcRnCegZB4aABeNSl_mAzn32yTkX0tRZnOCH2CoV0GOi8TJNClAD6DyrPeMvE2LcoZ2s"  width="400px" height="auto"></a></div></div>',
        },
        {
              coords:{lat:55.476466, lng:8.459405},
              iconImage:'assets/img/places/wexford.png',
              content:'<div style="height:auto;width:400px;"><h1>덴마크-에스비에르</h1>에스비에르는 덴마크 남서부 윌란 반도 서부 연안에 위치한 항구 도시로, 행정 구역상으로는 남덴마크 지역 에스비에르 시에 속하며 덴마크에서 5번째로 큰 도시이다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="http://t1.gstatic.com/licensed-image?q=tbn:ANd9GcQTPpNFpZ77baV-qAHTudusPtRGmQtehRDK5Hz3whAaFuR_-M1HZWrydrZ3YtML6GVO"  width="400px" height="auto"></a></div></div>',
        },
        {
              coords:{lat:56.36153400000001, lng:8.621727},
              iconImage:'assets/img/places/wexford.png',
              content:'<div style="height:auto;width:400px;"><h1>덴마크-홀스테브로</h1>홀스테브로는 덴마크 중앙윌란 지역에 위치한 도시로 면적은 800.19km², 인구는 34,873명, 인구 밀도는 44명/km²이다. 행정 구역상으로는 홀스테브로 시에 속한다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://dynamic-media-cdn.tripadvisor.com/media/photo-o/0c/13/a0/bd/the-view-from-the-balcony.jpg?w=500&h=300&s=1"  width="400px" height="auto"></a></div></div>',
        },
        // 도미니카 연방
        {
              coords:{lat:15.3091676, lng:-61.37935539999999},
              iconImage:'assets/img/places/wexford.png',
              content:'<div style="height:auto;width:400px;"><h1>도미니카연방-로조</h1>로조(Roseau)는 도미니카 연방의 수도이다. 카리브 해에 접한 도미니카 섬의 서해안에 위치하고 인구는 15,853명이다. 시가지에는 프랑스풍 건물이 나란히 서있다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://storage.doopedia.co.kr/upload/_upload/image4/1712/16/171216021698131/171216021698131_thumb_400.jpg"  width="400px" height="auto"></a></div></div>',
        },
        // 도미니카공화국
        {
              coords:{lat:18.4860575, lng:-69.93121169999999},
              iconImage:'assets/img/places/wexford.png',
              content:'<div style="height:auto;width:400px;"><h1>도미니카공화국-산토도밍고</h1>산토도밍고는 도미니카 공화국의 수도로 인구 2,061,200명이다. 정식 명칭은 산토도밍고데구스만이다. 행정 구역상으로는 국가 지구에 속한다. <br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://mblogthumb-phinf.pstatic.net/MjAyMDAyMDVfMjIz/MDAxNTgwOTA3Nzc3NzQy.d_BKCspZ7Z-D4J8lwB47sTUBtuALYMcRN5z6fbN9U70g.XH4rMb4CdZSGKxPDbZfSZkIVQTN6frnJaKJQasCJd0og.JPEG.dyd4154/20191223_131244.jpg?type=w800"  width="400px" height="auto"></a></div></div>',
        },
        {
              coords:{lat:19.4647779, lng:-70.6922129},
              iconImage:'assets/img/places/wexford.png',
              content:'<div style="height:auto;width:400px;"><h1>도미니카공화국-산티아고</h1>산티아고 주는 도미니카 공화국 북서부에 위치한 주로 주도는 산티아고데로스카바예로스이며 면적은 2.806.29km², 인구는 1,503,362명이다. 1844년에 신설되었다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://upload.wikimedia.org/wikipedia/commons/thumb/1/12/SantiagoCityDominicanRep.JPG/300px-SantiagoCityDominicanRep.JPG"  width="400px" height="auto"></a></div></div>',
        },    
        {
            coords:{lat:18.460225, lng:-71.417514},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>도미니카공화국-네이바</h1>네이바는 도미니카 공화국 남서부에 위치한 도시로 바오루코 주의 주도이며 면적은 275.33km², 인구는 53,605명, 높이는 10m, 인구 밀도는 190명/km²이다. 수도 산토도밍고에서 서쪽으로 230km 정도 떨어진 곳에 위치한다. <br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://youimg1.tripcdn.com/target/0ww0512000946w0a4C4F6_D_1180_558.jpg"  width="400px" height="auto"></a></div></div>',
        },
        // 독일
        {
            coords:{lat:52.52000659999999, lng:13.404954},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>독일-베를린</h1>베를린은 독일의 수도이다. 2020년 12월 기준 인구는 3,769,495명으로, 독일 내 단일 규모로는 최대의 도시이고 유럽 연합의 최대 도시이기도 하다. 독일 북동부 슈프레강과 하펠강 연안에 있다. <br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://w.namu.la/s/bca3b2d9c2145bebc7b4cadaf82d5e9401f556c844ca6d9d7eb59d7280e8da51e2c52fbe21bc30d3e8009c5afcb15682530bb0d6804135f5a20bb74f479fbf2439235332b2e50939cb7944ebfd69a8a5bb0a0c56056d0e2776961cd3528a3996cdf071f820ce32a02442aa3c64269bde"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:51.3396955, lng:12.3730747},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>독일-라이프치히</h1>라이프치히는 독일 작센 주의 가장 큰 도시이다. 라이프치히의 인구는 제2차 세계 대전 전에 750,000명으로 역사상 정점을 지나 2002년 현재는 약 50만 명이다. 통일 이후 BMW와 포르쉐가 라이프치히에 공장을 신설하면서 자동차 공업이 성하고 있다. <br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://pds.joongang.co.kr/news/component/htmlphoto_mmdata/202205/11/9e314af4-b7c6-4e6a-a398-73445d5fb8e3.jpg"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:51.0504088, lng:13.7372621},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>독일-드레스덴</h1>드레스덴은 독일 동부에 위치한 작센주의 주도로 엘베 강변에 위치해 있다. 작센 삼각 대도시권의 한 부분으로서, 예로부터 독일 남부 문화·정치·상공업의 중심지이다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://t1.daumcdn.net/cfile/tistory/21749D3950DA333E1D"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:53.5510846, lng:9.9936818},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>독일-함부르크</h1>함부르크는 독일 북부에 있는 주이며 도시이다. 독일 최대의 항구 도시이자 제2의 대도시이다. 정식 이름은 함부르크 자유 한자 시이다. 알스터 강, 빌레 강과 엘베 강이 흐른다. <br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://cdn.smartcitytoday.co.kr/news/photo/201905/img_1522_0.jpg"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:53.07929619999999, lng:8.8016937},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>독일-브레멘</h1>브레멘은 독일 북서부의 자유시로, 베저 강 연안에 있다. 브레멘주의 주도이다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://storage.doopedia.co.kr/upload/_upload/image4/slide/201710/30/20171030210502467da15515bf5115c9f833c0fc8dfd0524dFi2P/20171030210502467da15515bf5115c9f833c0fc8dfd0524dFi2P_thumb_1200.JPG"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:51.5135872, lng:7.465298100000001},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>독일-도르트문트</h1>도르트문트는 독일 노르트라인베스트팔렌 주의 도시이다. 노르트라인페스트팔렌 주의 지리적 중심부에 자리 잡아 경제적, 상업적 중심지 역할을 수행한다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://upload.wikimedia.org/wikipedia/commons/thumb/6/67/Borussia_Dortmund_logo.svg/1200px-Borussia_Dortmund_logo.svg.png"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:50.937531, lng:6.9602786},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>독일-쾰른</h1>쾰른은 독일 노르트라인베스트팔렌주의 도시다. 베를린, 함부르크, 뮌헨에 이어 독일에서 가장 큰 도시로, 옛 프로이센에서는 베를린 다음으로 제2의 도시였다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://mblogthumb-phinf.pstatic.net/MjAxOTAyMThfMTg2/MDAxNTUwNDY0NzAzOTE0.xbPn9kBVMBHoeoTqZ19jFoYYX_u7st-Kv7909hPqnSIg.IJwuJlC1CIlbhTb-P0dA1uYNfOWRWfLuTe_wO0tU8icg.JPEG.myrealtrip/%EC%BE%B0%EB%A5%B8.jpg?type=w800"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:50.1109221, lng:8.6821267},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>독일-프랑크푸르트</h1>프랑크푸르트암마인은 독일 중서부 헤센주에 위치한 도시이다. 또한 프랑크푸르트암마인은 브란덴부르크주 소재의 도시인 프랑크푸르트 안 데어 오데르와 구분된다. <br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://post-phinf.pstatic.net/MjAxODEwMTdfMTAx/MDAxNTM5NzQwNjg0MzQy.TYvp-6sAJpCSbiYOt9vvGHeH5pa2-8io4hHxXx0WXDUg.xQCQRkwKb_FK7ubtbkzbylJqPup3up_MLfgMVwcqpsUg.JPEG/%ED%94%84%EB%9E%91%ED%81%AC%ED%91%B8%EB%A5%B4%ED%8A%B8%EC%97%AC%ED%96%89.jpg?type=w1200"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:48.7758459, lng:9.1829321},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>독일-슈투트가르트</h1>슈투트가르트는 독일 바덴뷔르템베르크주의 주도이다. 옛 뷔르템베르크 왕국의 수도였으며, 2006년 FIFA 월드컵의 경기가 열린 도시 중 하나이기도 하다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="data:image/jpeg;base64,/9j/4AAQSkZJRgABAQAAAQABAAD/2wCEAAoGBxMUExYUFBQXFxYYGRwYGRkZGSIgGRkYISEYIiIZISEcHyoiHB8oHx8ZJDQjJysuMTExHCI2OzYwOisxMS4BCwsLDw4PHBERHTAoIScwMDAwMDAwMDAwMDAwMDAwMDAwMDgwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMP/AABEIALQBGQMBIgACEQEDEQH/xAAbAAACAgMBAAAAAAAAAAAAAAAEBQMGAAECB//EAEsQAAIBAgQEBAIGBQgIBQUAAAECEQMhAAQSMQUiQVEGEzJhcYEjQlKRobEUFZLR8AczU2JyweHxFiRDY4KTstOUoqPS4lRVc8Lj/8QAGAEAAwEBAAAAAAAAAAAAAAAAAAECAwT/xAAnEQACAgICAQMEAwEAAAAAAAAAAQIREiExQVEDE2EEInGhMoGRM//aAAwDAQACEQMRAD8AZ0/hg2kD0wry3FKB/wBoo+Mj8xgxeLZcb1U+V/yGO0ztDKhTPU/jg2nMYS0fEGXn1n46Gj8sHUOMZdtqy/OV/wCoDCdhkg9V9/wwQF9h8YwF+sKAua1P9sf3HGJxzLzAqT8FY/3YWx2hjTpjsPuxI69gML141l/6ZB/alf8AqAx3T45lv/qKf7WIeQWhlREC4H9+OhRB6nA1HidBvTXpH4Ov78TJnKR2q0/21/fidj0TUlg7YLU4HpaTsQfgcEAYzkxo7U40TONEjHS4kZuMbC4ycbnAIw4zGA43gGajGAY3jMAGYzGY1gAycZOMxvABqcbxmMwAZjMZjMAGpxkY3jMIDm2Ng4yMbwAaOIazxiYjEVQYAF+aqDAcr2P4YNzNOcC+QP4GNE0I8USss3kT1/v9XbHa6bTVQf8AC1t97fK09MYMmu/vG/W1r/EYnWiUsLfP4j52J+841UjGjdNQBLOtwYi/bttM/hiJs1EBS29zFiPgcc1suxNvzvjgZd+i2+OKUxMYZXMFu4H8ff3wUh3Bn23OFtCV6Hb5YLp5gweQ+3b4Cevv+WFm+gomSlf29v8AHGq9VV7n7t/vwMOJG/L8ib/O1scVcyW6D+/f47/hi4zl2S4oKp5kbQf8ME08yADc29/wgDC/L6iew9owdSQd2PfbDl6rQKIWmZH2iPnP5YY5PidVJ0VWHtr/AH2wjamen4b+3X8scCqwMXDfx0xOWQ+C10vEuY+2DHcA/wCOCE8W1gP9mfkR/wDtis5fNB9xB98F0wLBRfYRv8MJuPaKtllpeKqp2pqfg3+GOz4sqf0a/Nv8BiukqDEA+/v8txM/hiRPhg+zwO35H/8ApTV/o1A95/MY3/pXU+wn44TLUIE8sdiYxjEE7EfDaPhaMUoQfQWx4viqp9hPxxOniVj9Rf2sVxlKjcdQfl3xyrT/AIYftQfQZSLWnH260/xx0OPz9T8cVlMyRAn5Xxj53oYP4fng9qPgM2WccbHVfxx3+ul7YrIzo7fKRtjBn164PZj4DJlqp8WU98SfrNffFaTPLNrntBviQ8QFoUE9hcn5XIxm/SRWTHtXjKDoT9378Rjjqdm/D9+EFTME+pSom5YFQPvGIHzai8z8Ov33xS9GLFmy0fr2n/W+7Gxx2l/W+7FMq8QJMLYdzv8AuGIGqHcn8Rhv0Ihmy8HxBQ+0fu/djB4hod2/ZOKKc0v2vuxDVz/YH4k4n2Yhmy/nxHl/tn9lv3Y4qeJcv/Sf+Vv3Y85qcRfsPx/fiFuIt7fx88L2YC9xnodTxDl/6Qfst+7EP6/y/wDSL9zfux55V4mw6D+PniD9bHsMHtRD3GJiDBg26WAPS++w2nuMSUqLAgSeYWjSdiBAhr7kSJuN4vjdSD7AEn1d+5a8fPqcD1UAOplYAaYJYAFREdQfb5YyUkOg18swiXgG03gHbcW3I+/EtCuoI5yRsQVBhpFtwbzO+3xwLlKlSo0rUhVWWJY2CsDLEDo+m/sPbE1dRUYl8woYAA8oLabkEBW57na5vh2H4JFrTADANsIEzY7Drcb7/liVVf7Zg9uotbpF/wB18FjhiDk8xyZ5VLQdMWMlVaxBk6Y+EE4zMcLsoFVUOooVYkkvywDEaep6jrfDseLB6eT+0IM3Ewdtri5+J7dMaqZVoLCnyRPqBnmI+Jg2+WDqHDfKLjMFifW3LJVCrAVOcy06WGmCZg4nCqUA1vo5QCzgHTpYDkC2PoJ1TOxAth5BgJWyzr9RhFmOk2I7kWwUlWLE/eL/AJYZU3RSKjlATKobobHcsAe88uxf1W1DbaqYLq3M0ayFHJJH2xMA/VvHKRpiMDdhgBLX62j8v3f44681G3II94I/wxPSDAINSlFEOAqsASJYo02Vun9k9gCTkaq6hLB50+omNTXBZtLSLMYmxjeYwYoWIItADobCQL2HeNx8cS02cjlkTYEDr2mO3TG3dUCzoK6rgrTV2u0nSllhY6iZECbY7Xy6g0WLaYVlVfWSOVQPVEKCb2mB1wBiZk8y3XTM6QZuo2LX+YHz9o7pVwROpV9rkj9+NZdYURSmm3oMFtUg35gCDOnqBI2wLmqbog81SnVSbwpMzYQdxueuLVA1QwoVrCUPebk/VOwsLMPvGO6dZQeaQJ30tHTmv894+XRbmM6hpUwjhmQmbmGBv6Tefc9hHticQBOrVocCOQNJAG20dN8VZI9oKknTXuNiQRI23uCLz3sfnPUQgegPUPu7v1N1iNut9wZxVhm2A9b7COYquk22U3ud8SHNkadRLDVqHNIkdL/3fawn+R2P6VSqSUbTqEQpCySdhcTO1j3GM/SKo3R1vGoAwCBtKwJ+/fAXA+IaagqVaoVPRDc50keqDJIVotvtix5zjNB1CCsmjUJBDLa4tFMX1R1jEObT4KSTQjJcsGAMFt2so+JO1iCT92JKWa0BiGpyvVApG8XZ2/LeRgTM5/RUNWi6qHiULnYcoaxBI5TcH+8DXEcwXoo7VPNYn7UhPVv1kQBJ7j56Z3yTR3mOIqX1BCAAQRMyZmTaMRpxJl1aRpBIJ5Z2mPV0vvgFHHN3G4JIbY/I/CO2OZ6jSnsX/KemLVUTsIOYk3sTv8P7saNT/G/8fwMBK43v3n+L401fv2/j5YeSJCmqEzBAt8/hiBp6/wAbYjK9yB8T7fjjdgJ1KTYi6kXv0JG24NxecGQqO9UXkY01X+On8bY5ZwDMWPSdW/uP49sQvWBjY+15Hz+faffEvY+DdR7+354jZsdNoIgGGn3iL2O8nbYYGcAf5f4/DE2FHFZpxFA74kYjv/Hb+O2IvM/qjBkFHX6RSSoKsuzBw+0qSDquG7nfBlHxFYEUVqMWY6zBYEwSYExcrcRIBBON5A04QMq694fUwgFgCFlQosoYsxE9IsF68RdarrT8lIJTWgpgsBvLwTuJsYkWnc8pvx2Oz4lr1ZpqqkFjA0BhO4iFJOm9ifedsapUcwyswICUmL6CgH84YtyXiL3tA3kwuqLSo1DUjMa2OqCFSmSRuNStIgzM7EY7znG3qWKAKTJl2knvaFEbWG334YWT1wwKIfMJZWYaHWQvpgjSB22J9W+J8ujJVU1FK0yt3ZQsMEhevRtIkbg33wmGegiKpUj7Aknbed9h1sNupMxrubksbTNVrX2hbsQRtGALGn6zWQgFN5GkgtUGow1xo3kGDJvAtbERqpclNKmZVVCqQSPrMJEQRq1A/jiLLZlwFJdAregLTVSdtr6ovtPUdowRlqHMTBapMDWQ7BrWaRppkGSC1yIwwORxALR8oCkQJu0M1yZhkWBYxYi098bpZ0lgEUu4iAFJPsY1OWNuv3d2a8U8qhWVPLbMrUVKYWCCPoyW0+liJa/Q7RE41lcxxB2DOSJaXASmA6yJAbVIJEjsJ98OwAhk6zhdRRV2UsyhJPQaJv3hZ+/B6+H0Fnrr3Agc0DodZ7j7xgH9IrO+kVnZgDZfLYrvbc6b9D8sR8f4fWpIhrKw1Eka1pg3vMIdU/2v34EwapWMsnw7LB2VcxqIAkFSFJEgf2jOq4PXoME1vLpqVpGk7AlmYBtSwZXmV9S8zNzbiV2jFPkbkC/t+OGvhpQ71V16JonmiY56PSRPbcYbQlLoOydAVagRXJDCNIckFZiSHqk6DIBgmeljJZVfMpM1OnlNT7a+WHgqJlVNRAeg1CZnvjivwtKmYMgJSSmBUZZDVLg6OU3b0R1iN7DE6cIyBaAWVj1FRgSQSNU7dxuOsAYTY6YDS4dmYH+rDYEHzHETc2FPeRFu2C6CU9Kh6GaDAC6cwB6QSga46MJ/PBR8O5Vn0+dVtOo+cDtAgSPnPtG9sdZnw9SRCEqMSFJAqNqBZfymZ5QOuDNBiKeKcLato8sszGyrUZQ8WIGwUgAN1tI+GFlXhla9AA60YEpGzMOjgleYBNyLgdd29XgtcCWpBr8xFVAAQqz6lYm8gbbxsTgOv5ZJdKqrTtHlQzs2phJRl1SL/V+sThpktBlOjmDQq/pQFNUQENo5muoC60JUySRBvfthj4d8ZgIKeYI0hRDKJgAKOYC/Wdv8KyK6a71XgCCHonQ0ibimoYiYPNGwI6zK2cGkqK76D0NNQn9nnphtEEqLyBucJrQ0z0erwqgQQaaGZ3UdZNjE9THacUvi+UGUrEOuvLVQeU3Gq1/ZhAuIJBncWecM8QVCwpvSlSBpKmGA6qwNiR0AMn3M4LzC0c3RanqkG8izJcwYNwRtf4YhWuSmrK5xHJrFPzB5qbqRJZpE+pbsYgzcMOaAJ0rK2QAOnLsrqTEEqSrHYEgyFMGDtg2nUbLf6tmByaeQiSrqJIjuQYAFip0kdnIOacEaKgMreVLhxYfS6AWVgba1nfmSxbGik0S0I8vw+q0aqJAP10llAMc3JqYqP78Q5nLhSQaswYDA6VaOvONtrnqcNH4rlp01CtNwfS0Op96dWmGDD3PNe5XHL8cy7adRBBkExpZTvfSCrTaAdQ7mMUpbIpCugaO1R/bliTM7GGB+ED4jHYyjNehTeov9amRcxuVYiPckfDEwGVJkVqh3LMFVRTAEwwVAN4uTEfhvyVUKVr6SwMM6aFb4NSJmIEkM0e22G5DSs5HCSwBOWroD1UTE9I0Tv3OBhwqbNrVo2cBR1ggzJHywXmOFzFTSJhWDIya6gBIlSzM4M/a1BoABHQduIMhaA63kTe39YqbXJECCDHbCUn5BxQFmqdSmdLQRsIZWX8j+WAmJiQJ0i5kdYH34eU81RYEVFqkASWpqWUSd/XKye/UHBmU4RlnGta6KjWh1Vyu9iA5qC8CJm+Kc0LHwVStUJ3A+6B0At/hjXnL2OG3Fsoq1GFNqdRxvpQqEj6oFT1bzafe+Fkt9j/0x/wC3ByKjqk4VGPnUGLMBBY6gBIOlgRE2sREAEHBnC+Ka8wlV1pMqKAqkBxIUBTcsVMhWtvETfFWrgCNJLKdiAJt3AJA+84J4bXKbI5nvCgnpe5PXp06YxLLX+pmqUjSWq5AqeaDovzLUBSAYtoSGkXJuJwPwjgtAnnV9SyStVZYFSVIJnQpJ0sCQ4AU7zIP8O5gDMVKeZrLSVQQAUJpkgcx1E3kMyi7SRaNjsU6Jq5cheTUjOJBDksSXOjlbUhHw26YHsaB/DdSm/nI1NlU03ZAqDXrDDTpGmC5UkbfWOMznCcvVqNUVcwFOkDYK1kBhipIuN2jeNIABxzwqmaHEaCBXZVqujwGaIdULNvpUAm5iJwJxDhD0dKELUKyHVXPLNo9JJcAAxEXF4vhPfA06W0bfgtRRC1aqQv2SBpGrcyBYfkfk0yVA06emsJTSVkepiGjUCwmmY7i+r4YG4S9CkVIpVLAl1aRqIIK82g9RPLB9Ik46pZgUx/NtU3bVVqOxDWG2pFA09dJMgSezUXWxuS6D+EcYamrAUw8zzcoKgqAVUq0KsLJAjrhnleI05LDJ01MGDItOrczM6Sf8oAH/AFrVFB660aJoJUFNAr1Id2IUaFJ5QZAjcl9sLKXiMFgq5YHUAgQO3Mx0gCQN5AFuvWMJ7C6Js5kHiKP0UksZqeomLhQy/gOvwwn4hw/MOIp1jXdOZ0kAUmBgIJdtTySCJsZHeLRxDiiUqrGkikAKNeufLB13F41/O19r4Bo0CNYOvXWMal0jzIgGmAstvIPUsOsSBNiaTK9w3guZqOAyBFJOp9SkCN40m5m3acWvLcOo0VZaaS5TmgnXo1IdUwYJIECBeI7YMo8BRa9EvUc1JX6NXIorzICmgHSQFJ7ifvwgqZVnaoy5mixbUCErtOkfVgU7RYR0jDTsWNDrLZ7MUwQtGo3MzXpgQzTaVdp+tf3EWjBNbxFmQpJpuscxmiz7ab8rrG62g953ioUuFVGZgGeQbsWgNO8FqQ1bX/xxI+UrUmP0mYU7ygUgmIIU6B0C7QLze5wNIdss/E/ENZXUUq6klqwIZFIXyjNyIKizCDJgjvdVk+FI9NartZiRSVgBu55QAjWBFTTJEW2icL1cyS5qMxmXdBqI+ySpBItMH4n2nPEQFC1KjkCNCnZVGobX6lr9QY2wJA2F8R8P0EQsFaSoMGIW4+rAZxubH8sKaWTdmBRgEMgEioBrEsRcncAn1TvYYKPFaX+0fk2iJF5AGmmsm56fG2+CM7n8uKdKpSjy/MlFaQWJV1K6WIYiWmZPXa2HxyLTIR4ezMvpdDtbURKrudiTEi3uYwDxWjWy1RPNCujBxAJKlwvpMr1lSLHeYthm3ieoJ0oisdzfawi5IvA/zvjupxwVwtOrRTQ7LSLAsTFTTTnbcW79DvhtoVAivUpItcA+WULrNV2DJEGA66SACQZ2j4YJoccRZqPV8oJEuo9JaTpMAM8mLKCZOOeG8L0qqVKTqoE7MxB1MrgyNLXhhywytPS67jeZZHQougKDJCFNReYYEAa1EKuodWGFyPgvHC85Rz1DRUAYNOlo5X0/WU/VeQ1uwOK5xvI5jJ1qr0nLDSLxzBTMBrdI9Q/DCNxmXKlWaDpCjTSiQNMgswIkhhfrbti28P41VFE0szTZkCJqckNVYKOZjpMGGKgT779Jaa4GnYBkePDlXzNLECVZNdFrE86Dqftppa95AubUyiVo8thSeoBFJnLUahiZpOY3AkKCGG+kY34p8LAhqtCwjVCjlixm336vhPQ4SZPOGiXo10GjTzqQDt10kaakwBMgwBDG2BSDjke0svVflqUhUqKLwr06yDYAVQoU7QLrI6kXxujTgn1M4MhWpolcISQSwaFqLezFSTEavrGLL1lrU00uatJpIpufpVuOVKkhxDADSxEnYkRhNx7iVSjplKRWRoRnrPUU9dLMQVJixAAINpE4fIXQ9KCopR1dhYOE8ylUCmQG0SQ8lY5Ga2wOxr+f4KlKGoZkB7kKWKuIsV9IvtuF7X3x1lPENOsr68w9GoIim4fRcgEh0LMbbh1/CcMc5w2pUdXbMZV3UAKfPFiL2AEb/wCQwKxaYpp5uvSM1ERHB9bBqbkwTAZdNN9jYkzBxJW46juKlQ5bzFj6QeUGIvvpa+55YIO0kgYbZrJ13SHegw96pBvcnUqggzBB3HQ4BzmdrUWFNc2jD1aajLUdR9mUGsgiBqZY7nD/ACAqp0lqOaiVgTJE1IK8xU6i6QFvqtp7T3xJ+rqnZP8AxdL/ALmGmZqaqaPWr5UqYB5tNUnqAQIJ/sm/UYXaMj/vvv8A/wCmHYsSoZeglP6N6jHSYeAAwM8wXmO20/hg7JcWAUAICQDzTzGQwgntDHp0GGX6opuxqIAzEklkqiqCxOotoYmSTvJvgVvDSLJL1Ab8tkBYmyiabhBFtzf4Qc8vJTiFUs7TcqTTisXAuxH2QpJEARYbTCyd8OOKeHa9JqrHT5iAFS2YdjUMdNTWWZBdwBINycV5ODAOw8yo6rzA0wmsrPRVNQnYydIuItM464n4mz9Woz1KC3LEAKQdI2lUqbhQOk4d+AS8lq/SKwp0RKF6hV3ajNVHqSCXqvSUkkmY2Ai50gqa9V4XxB3eIqhfUyMGpibgxTh/USPTuDqtcjDiedgf6qIMn1kbHSQdVTf23gz3x2vienTYpmKDkizKjgBR1nWp1A9NgReTOBKhs1TpZgLoak1OYmTBJETJA5VmTpLW3xI2YzAElqYUQutyAgFgJYiOwkmScAZjjRNR2R3RS5ZVY7CSQI9NrbWxOvHahHOEqD3UXt3Fvw6YGn0xWh/wPK167CnRjWQGeqtkVD11hidJIIhYL9wARhnx2hSytGkcupeolZHNUjmdoaDAsFBggGRAnrJW+FvFAWhXFQhEDodIBJYuGEWjV6RYdj0k4H474hFRT5NQjoY1K99wJUSNiSLmRaAZzr7h2qBqXiRg0qmmTJsCSRIEl1kWNwfwxYvBvFKZWpVLaqiwqSBKqdQMCBeSFBgnm97+dfoyjZnA3gsD/diz/wAnh+kYf1SQY2MgT7WJ+/4Y0nwTF7LnxSoKdbItEF5LXm+unN+u+/tgXwvwVXrvVQqUDbNSUeYSp03UzYkkhrgTZZxzxpg9bLU1k1BqFMKpIViycznYMCoI6ANJGxLqhnEpfR0Xp8kglShJf6zFR1kG28IB1xF6NKGNbwxl4JCEsZM62EsYljBtJubdWOKvS4TTzL06eqpzlnWG5Up6QA3chihcA9Ki7bYaZrjjVKZp6xNTkMGCiadTvI+ymxHeeows4DSzjh6tJCpLCkG1JrVYXoUZdIGlbXGjY4FYEtTwApE+dUFpjWOpiL0zv0/uxH/oERyjMVhLMAA4iQJm1K1rT0NsHURxIETraZGlvJ/2cwOVV5iwkX0wbxtjg5zPhdYFUgIavoomVe9oIMi82nsDvh2xUjjhnhdqW1QvOg/SQTD8oHp6GQfjY4F4zwdgl6mgFHHLSS2hirtOmfUVMAyRteSA874nrEMq1dNSm4puPLVkZabkAgpUlSCehImx3xBxjxBVrALrUaXLIQpF2JLTD3vtBEe++KSYm0QcW8KCihY1n5WVbFWmQzExIMREGfqmR1wBTVaYCJUNQalcOCJMSVNiYBhGgmQR0OJsvmXVpFQDrHlt64In+c7kmIm5v1wtGWZq9RTVB0ojFipYSQRYFzE2sXiW32GG00TrodjNh2VS7USTEgK2o9S2oE9zIM9++A/EHD3jV5rVNAOqky7K0BlUiPq6bMAdt8T8NypVSfP0ncwioCVJsWDMSp9iIuDjrNUK4IYVkJJM+oHfpLbaQDe9j8mge0A5HMgGmCxhUckNsS2gHWI2KhhaCJ7CDqn4hyyHRLEIxF3eYBkA/RkmDaJ2G5BOEeTrMlZlfcyp+Ik9LEe4wy49VUZcDuVFt7Anp8MOtE2WngnjCmzJQpVwuqPXTZ1DbkCyQp99r/HBXFMu1fMfo1QUmdqD1fN8p10HUECgyYNzta1wcVeigFGmgA16aag2B1QOvS/XFk8GeTUTy60rWUndiGZJHXrDHTHy3GImqLi7As5watlQTTUvESFcagp+xNM6pgyBeLRBOB8txynmlCPSbQDcMdQaRty0S9P20kbCOWRi7ZrhVIGJq2/3rfvxXuPeFqNQa6BNOoIMyWDWaQQTJklTv02nEKRTRWa/DqbKHFOqgFj9GxqlCdIZtNLS9wII5jqkgmYVtwdHkJ+kAiY85NCPG4VmAAI/rFe29i0p8SzGWcUqiwQsw7EA9OSoByyJEMSvcDbDfK8Rp5pNDlkq0zbUAHpzadI5HB7hSOyLBOLsmkIOF+ENZZfPSlUWJVYYwYIJKsALEXEjpvIwcPD9WiHDVKkNyjU1EhzNguurqN4+qCbWGAeJeHGpzUpvCwSKlMSpF1JKhyUE2LoXXcewmyXi3MZZdNYCqmytr6WtrAJPTlcBhPywXYtdm24e66dTotR4K0y2l2BMb7N1tqB/HDD9R1P6Sn+xR/7+K1Q4uK1ZqgL0WjkBqGoAYAgswBj477E4a/Q9st+yv/vwmOihDhtwdSn+zMwOo1AX+eC6OazVISlarpHQsWA2IMXXtt2xbv1XQ+wv3fvxyvDKAltAHckwB7745Y/VxeqZWRX6Xi7MKfpEo1gOpTS3xlCPywxp+NaemHo1Afsmp5lM9b6hIX2W4xFnXVpVKa9pcMZi4tp/Cd++AH4cLk2Ftgw/6hGOhSi+UP8AofpxLIVZ0tRpsejB6cGBPOoVSAb7DoPfBNHg4qltCUGVpirRYvWB6apYq3SYCkjr3qdThim+qIAFwSB8wO04ifhMEFWUEdbqT+1H4Yf2+RWh7m/CtYElcwvwq03T8YYfjgX9Q5obUkqj7VGopn7zJ+7EFPP56gJFesBHUl0A+LSB8MGUfFmZMalo1gBEtTAP3oR+WK2GgRUzdCSKdWl0MlqZO56FdVh77YhqcTquymoxaBALOzR/Vlzb4A9cN6niqhUha+VJifRVIAPcBtunX54jptw5iC1SvSm8FFK/gWeN+pOHflE0ArXPaetjbp7YaeEuLpl2q1anpVD3uSRAt3MXiwnB2VpcMZYU0L9HZ1YfNyy4Py3CMqgeuqqRS0lV1B6bVT/NghUEgGWjaUg2nEt3oMaJKj1zFQvUpB4MM4UERPpHP9ae3NaMF8HzlTz6ZqZlRTnmHmHSAFI/2ncx33PyTawzEuxliSx3MmZYyR16z998M8rlcsbeYCTAIL6TFrgEajcYqML0JsJzvFCteuopBKDHyaTsDpqoNI5NI5lAB5piG9zhTxXxHRfSA1XlphJAGktLO7jn3aoQJ+yDvbBueorTcJSEloBpHmWoxPKjAm8ifcSCImcP+L/yZZZgfKWpR6xTq6p9tNVD9wYYmUUnTHbfBW8n4mzKLOWpnyyznU1VQWBtGlidGkjoTMTNyMTt45zKq2qmBNPQT5tIwoBuoVtWoTbf4G2Ia/hDMUEUIA4lhLUlV59UEHXNmGxI/IKuKCrTSolYlH0SqFbv0HL5QBUkRMxvvGFQWzXCquXcIz16a1WNV2lgr6y76bSCdS6QBB3xdE8JUKhmnR0SVJRaj6aZA2Un07mdEb36RUOBMfKpLp2V7G0GSfSRax6/LF9p5yrSdSlOo4BYkBTDK2gEBjYOCqkAxILAXgFTbXBUEiNfBmXQMzu4EXitVAj3L1Gm3W2AsweGBgAKlRlTQPJWq0JJME0yARJJk98NuL00z1Bly9QFgZKmzAj6rqYZT0MjFa/RnHl0q6LR8sMSKwmi/XUSPrna/tBG2FBZLb2VJ1wgscN4ayqoo5lAtlHlVuW+0ajaYO0Y7TgWRdyUrTUO+ssGuI9JK3j5nrOFVSipPIqeqfXTcbyAArAAexB+ODaLyYqiaUXRiHi3+zCSyGfgANyca4fJnl8CSr/J/WLMDWo2k87MrlQbMQyCLR1wDmvClQiPOR9JhiavLMwNzyzcCTzHbFs4c6VaZo5irTFMA6VqFfMMqwKrqOpRMTYg7RE4VvwJ4ih5zEAKusnS0bDmUJG0gR/dhXumwxVWiTw7wSpl2FSvUZyQ2imFZiNJjVqcgLKyQOq73IU9NkaNel9CWpVBVdAGuoqKRyNMmmzB6cODoaVBiEOOsvSeiumpUopsSiklhG7FEi03MNECIM3X8R4vkVNRm82u7EFlDaKTNCiRBNgFQGTNhMkWl2x6SGvDPENZK/kZktYLTJcGdYtqJIkSYB1TMggkEEvUYt6AzDoVEqf+L0/jihJ4wrGDl8tSorHK4XXUtbld/UADcAGJxvJ8ar1GZqtU1wxCqCeVCJBDIYB+rupHQXkYTXkEy38RytKtNOpTVnIi2p3TffygQnxLDpiujRkCjVErI7BxTZKlOqzIApqLLKgpgcpgMZ22kGXK1q9YfRywW1vSvwmEH3YJreDauZIeuysQIAZmbSPZVARem29sLOK4GI08TUOUwxYAkOVp6wCTIYLVAFo2IYAABhAwXW8qq80XUs1wVYCoJiz+UHVlMxDAEmQWJxNnfA1UOXoVVVyOUBQiOREi1lMdwQesSTiqVxzFKtM0qoHMpkKQTb07A/HSYsRh2Jh2d4GNJq09LIBLPRCk9wXUMaaT/VK2IscLP0Nvtf8AlOGNTQ1MAVjSq010qH5xCxyrUjzUBURpLFdo9o/1zmv/ALnR++r/ANrDv5DEZVqoUamMAfefYCRJwoq55qhn0qDIWxj3JFycarFarlajKTtoBsB0AHqA/Hrg7L8N0raAIkwL9Oh3Ikfv7ccPTUF8lxhQN5sCZAA9sBNX1DUwBUdOpHbf2N8OKWQpxLsJ6Cbnv8LDb3npgzI5dIhEZmE8yrIAMerUbAd+mNUyyttX1EQQFiIjp0uDbEtNgBLKQI1CFF+k3v1/gY7qmmmYIBFttwNcXjryn8RjDlA9QKtQI5tzuFU7RBYxPqsB0HcYdkSHPhDJ1M3XCK5RVAao3Wmm2/222X3k30kYtPirKcNpHmRFHMGaRIeBEFgztUAGyzYc2wlX4ZrpQTytYQagzQbObiZiW2IGr+rhv4g8MKXVVq1ASWZdNXQ6ljcXJDA6dipjSY64pa4CtFUzuY4U5I/R6gO2qmSAQOsNWC+9lA9sbyXhHJVlNRMzURIKksgfSw0kqVXSRYqeXvuRjVbg1CmS3nFktzalYPJ+p5aDVG9o9hj0bI+GKYy+lICso0yLc2mW07KT1J1E9ThqTJSPOM1/J7CB0zVIoRq51ZLTE3VlG3ftjng3CTl6dVKhVqdV0ipSKtFSn5tiARI0uZBIuJBtGPTvITLCm1TM6KSgJ5ZCKjHUxJEjVtA0jp8cU7xvxihmiq5epWFRGB1MSKZSGGlUmAZIM6QYHXGkbYnSAE4OxuKtOD3Dz/0H88H5XgtED6R6rHtTVQsfFmJP7IwsoZfPEALVSPgPb/dzjjiHBqiqGzObjfk5mmegDFR9wxRN/Bacr4gyOTP0WXGvu1QF/wAA2n4CBgXMePa1Xlo0VIneodQHwLdfiCcUjzUA+jUR9pzqPyAAXbuDhhwvKVnsKhpz1KAsR2E+kewgfnhqKYZMacc4s60qdXOxmC7EIgOkIADLLtJ7kAC8fESl4vywWEpZimoM6RUVh22b1/Azv7YufhLwzlmpN5o89gwDM7EkMAYFjy2O3uMOKvgzItE5enGwlm27DmxnKrKVnmw8T5NrstQ/2qFIjElLj+RE3Amd8tGkHt5YG3vPvOLzX8CcNY6Fy9MOI+s5gEz0Yb3wMngPhrsUWiVYG41H3tub4KDZVf19lOUjMU5Fr06ot3JBFxY9NiLTInTjtIi2aoH+1UrLHtdziwp/Jzw4hopNKjYsAPYkhfb/ADwmHhXILSZmrUgbKgFem9MtzEKxagYHXYn1dsINg65wMTGY4fFoD1SfneD8dTfDBKpSIn/VmIv9GKJJ/wCYxGBsv4a4YZFTMUgRABDUWDCNyWohpmxMdeuB08I8OMhsxSFpQrWBXVaQ00gQLCNIOxnDsNhlYZ0lTQcinMsjeQNXsDTAKdrE4WcQ4DxKspV2gFpMO5npB5nkDt3xL/obwvS05lNe6kVwEItIJFPUCL9IuL4ZUv5PcqKJrpXrM1OGZaNVagCmGBiokHlIaGFx0wWGxFl/AKgMalaoTBI0ZapAaLTytqAN4Gmfbox4TlXpEUfI1UFcMmui5KQG5wGUyYtqMG7CIxx5NOkNNOvU5AGPmUKbgKYgk0qlOoZn1SZ+RxLR4qVF6FOv70M7Xot/y6rWPwc/uNhobZ3PZbMDy8yJCwFqxET2G4gXtaYsYxVeN8F8ptdHM0qs8srVTWRHpdSeYe5uIF2J0g7NeKUlQKGepPBhGzDn3MCoNRsQe1598KE8WVqY5qtf+dFlWiAtHVJUKyyahWRqJCzEjCSBtMj4bma1NZTzVMjUQDCkTAaCQ4ImCR02Ivj03KZ1dSIJ1VNoBImGaCRYEhXid9J+fnXEuP5UzVy9TMLVb1NUo0NTC0BmpFWZbCxke1oIdDxU55ilKZl4y6sOWCoIRg1yNM3F79cGIJpHqOYzWh9J26+2E3iXg1GrSOpZW0Eepb7g9trbWEg4QcF41UroruuUpFnZAp1q0rEnlBCiTFzuDh9TpuV/nKMdlrVgOnYxhNDPN+J8Pq5ZjP0lJRZpgrqJI/s+k9xfucCecPtN+wP349LzWSqHm8pKk7kV6k7H7Y9o+eE/6ty//wBEMFioRB1UEIoB/s7e+8n5TgY1+XX5gIM3ZlBNugDEgexANjjEyimnfzfOkm5GhbiCFEtOmbwLx03NXMDlVypqMrTroi4DRKTNiVuQVuMYuSXydy9FzWlXi+waWIAEXIAJVpYmwAJW8jp1nHNbhWY8xxWRXI5ShJkEHY23F7YYrnmVgS9MGOVatYLFosFB7xufbBGe4k1GizqS1QEa1JDU1U6tIQSHY2vy2E32OFGVuqFP6fCOTe/FCdchUVyq0lE8o1FQx1RPquBYkdRhtTy1LLoT5mqoV3Q6gCTsSH07Wm8dpGAuHVa0GqzMknUGCwZ6LqNMggwZhgdvfHQrKxKgKZNt1f6sgD0aZa0iN77TpRy2WHwblVaolSoeRGtLAGRLFjLQURVc263xnGeMtUru+pgrFggZydINpWZCiABAEfO+BEcKj+VVUArDUxJc8yzzayHiTeBABjc4UswJJabbgbx2HvaMAFn8H8OOZzaKGPk0YqPF4A1aU1dnJMgWIRu+Lt4l42aFCo7QdIKAX53NlA6ra5jYBo2GI/DHDBk8rcEVqvO4JkhyLJMAQgtsL/HFb/lMoKy0KZBHI1QlSZLkaRMbxLY0hG2TJ0ikVswx6xcmFAUCSWIAAsJJt74DrVN5kg7xvvM4w0Gp1fKBZlK6yzEkx0EbL/fM+2JHTp32x0NaMOzqjnqcQ2aq0xGwWof+k364jFXJqSS9ao15IULJ/wCK/wCOGvDvBear3WgVB+tV5B9zcxHuAcWTK/yd0aKNVzNZmCKXZKIiygkjUw1NYdAuM20i0m+in0+L05C0cs8mw+0T2FyWPsMWTJeH824VszVp5KmxAUOwFV5IsE1A32hmmfqnEORr1oBy+WqU9aBlpZVSaxpmdLV8y6s41CSFSDEE6ZEwV/C2bJLnhk6vUWqVndviRW1H4xibb4HVF2ocbyHDlWgGeNIcRTYs7SQWZoCG4NgbdgImxcD4tTzVIVaTakJIEqQQQYIIYAgz/nfHkVfhL06lNXy7UKpjykqnzMvVjanzwyEmwBLCYB0zOL6/6RR4UPJoN+kOgLJl1VWQvuwUzzBYmATN4OIplphfibxrlcsxpl3eqLaKKqShPctyA+xk+2F9DxcRc5DOIfT5mlNYJgFgjkTvcgECbxilcU4Zmnp0gMjVQ8xgZc+YAAo52SQQxk82lpBMDdmdPwXnPIFKlTputT1irRFJ6Zs2oMx1NBEbSOggmDYD3P8AjJqaFKtMLWqMFp6JMJqs9RmRRqmZVNQntiq8WpVaVaqtLyvJqFKio7WAhmUgMGg6XAMRdT8Ma4/4FbK0BVerTaszBTTQ2VCCZkwXOoL0AAnfBuQrU6+WOYqKCaE02UgEkGHViRzBAWqLuDyzIAM006TXNk90LUy+aYkJSyzaUFQwyeiJ1Xpid+kmZxj0cxfSuXcAKzEKICESGP0O0Xv79sX7KcfyflItSiKYCwaYpqyfAHeJk3jCHjeWpKqZiilM0pg0n5StNpimXQMwBbWbfbA6CallHlfoEk+GV9cvmjr0rlCtMBnYaIFMwQ8eTLAiDABtGHnhfilehU11AhRPo6/lryrR3UjQgB0k1GkjZiAYOAc1TAYO9OmopkkIyQwoMYWGakSNJOgnqGA6TjM3RelpqPTpEKuoI8DzMsSAkvTpyukwpgCxS1jjOUm1Q0hx4v4WKToaZC0ah1q0Bl2aaW3KDIZSI+YxWvJ59Jk1A3p0vEb6gwGnow3BBX4YcZg5itSTLrmFy6ozV0WpT5Hy45tMtTkFLXB9DNPpurSt9TzMtU0g6/KdID+zSrASXse+kyEU4qLtAyZGqQJGpdWrSWAAb7QhrHpIIN9xhlwnjuYWpOt69IjQadSrFSlebGoQKnUc51xsXi6Rgg+rS/56W/8ANiKpVNtLUki/89SPaZl7i2x+c4dXyFl+pJRqc9LRMmVIBBIMEERYg2MQR9ZRthL4syOUFJqtWk1JlZdVSjTBamDIFUhfVTHXuLeoCAMjxKqw+jrBnWWFDWjozXJGpJqIxiVKtPqszAipYeG8SXMJ1R1OkgxqV4kowiDqXpEMpkRcLm1TLTyR5rxCg61gGqJddQqU7rXS4FQMoJefSZGoEQdhEnCaz1yyqTy9OT933dx3xe6vh3KtSagKCUwGLwggq5/2lM7xa3S2kjpio5zJvlaoWpEGfKzCrvvI+P2qbWO4PXDu+CXGgqnRzQWFQEfBD+RGIv0fN/Y/9P8A+WDMnnC8XAYibTpaNys333U3HXE/mN3OJ35FoqFNsskCrmPM6xqCoYOxWmLj4nBtGqr6UpMXpgyQnKqgNzBeXQpgmIUyZkE4EoVNHKgpActhSomdKsAZm9zqkne+98abhdSoT5lZaehk1JTEMQyFi+qmTTDFtMoTKztAGrJwVcnfD6i5L7f27/0e5hqTO7vQplW0KEYKUpogCqgLLM2uxuSfhgDNcCpupqUBTDXYU2K06Y0wDU5rGJO5BMx8F/BKBD1Pp6jJp0NZmcAkMCDBEyqiOze9yKmc0DQNMTJ5SCdoDAkkkC2/UxuSXCLXLsj6j1YTrGNf3YOgAXQNTC8meYk9Zvf27D54MymU12Bpap1MGbSG6kKqAmVEWEC++BZEs/SbRPwnmuJn8emClzTinpLMF3IayhgT2J7qNzsMWc1HWbZgxXUCxiQSTaRy80kjpc7SMWD+Tvgvn5kMy/RZcI5nZqv1F+UFz8F74rQokSY1OTpVRuxMQvQwSAATeD1tj1nhHDxlMslC3mMNdUjq5jV8rBR7LgStgEZ7Mmq5lWCiArSIad4htQ/4gPacQcSylPMKq1kU6fSyyrDbqD7CxEWFsdIKjaVpqGJN9TaQFG7DlMn2t8RvjuqlRNRahVKqrNqXQ06RMKq1C7Meg042uiasRv4W4bRh6iBQzAAvVqQxgkD1bBVJjYAHYDHOT8QZdARw7h9Sv/vaNIU6RP8A+Rhqa/WI6zhlw7iWUzcpZmpc1SjXQo6R1ZHA1KD1usgTcCHWXzytTU09BQqIZDYrsCCp/LCbbCkJczx2pRqotfK1VpVBTHnKwdFd4s4F1XUdOq+0xGG2boqVKHYiD3wQKrOCpIvIsNvkZB6b4ytTX594EnElUK8hVr5VRSp0FrUVEKEdUqIPs6X0oQNhDCAAL4ZUePqwE02puZlHemXXsSKbuYO4gH3jHNakYsZF745oUFIktzfZho/K/wAcPkRLmaiVQNSBtLBxaSGW4IG4I+R3tgDiviXL5efMqSw3VOZp94sPmRhRx3NVKzCjSrstKSrmggd9akh1LKQtGZAuxJ0nlEHVxkOEZej6cotVgSCatXzH6gfRhdIMiLAfHBoW+iB/H2YrNoymVZugaGb8VGlfmcAcQ/WlQgZjMDLhiABJkajAlaIYxJA5yovvi2oaeY5EqVKD7hRoYbQSvmKyiBIhdPUkHHfDfCFJJY18zV1MWOurCkhpPKgVQCR0HwwZeAx8nl/jfwY+UNPzKxrGorGSCoDAqCI1GRBB3wv4Bnf0cPCBhU0yNTKQaeohwabBgeZl3uGYY9N/lMohsvTrFQRQrU3KkQCjGChBuATomR0x5PmHao7sSGqOZYj4liY37/L4Y1ilJbM5aZaOE+I/NJX9Fy4CrqmHmZAj1jucLcx4wZ6ppNlqMKGX1VQsWnlDgTIW+9hewxFw5jllqmrpDHSgUOpYGak6gG5RIi99rQRKDNAeYzltJMmI+WKmotIUW+yxnj8ERQomxQS1YgKQQRertBNvnjmlxsJATL5YTIgebHMCGsasXBM98V0ZQQW13Jj5EY0vDp2BPy+PtiMY+B38lsyvGmV6WihR1eYq0/52AWYCBNaOtxsZvgbM5HJ138zzMuZY3QVokAnZFidIkxeBM4m/k/8AC1etmKZUMKdKpTqOziEAUk6QIkuTp27XO2PSuKeHiS4o0KAQDWjMBpDz/Rhb6YBBkdB0nEyqPCKgrPKV4LlNIcNSKRq1BK5XSDpLSFiJEE7TbHJ4LlPMWizJTqOeVWp10Y9JGtRaxuY29senZrgCeSr1KNFnICtyINTADmAK7WnT8r9UtSjmV1IMlTZdXoR6f80dRV4YAajpiIjlxOZeJUOG8SyaQi5pYcgcqOsVLQ4IQKpnfYRfcAiwRUK+fSY+dS1CvRfVpqKWDculToE+YREaHO4WMOMpVdvMNTKmmdOldb0iX9XKDT1aQDO9ufaxwpy3mBhWKmkVJBp1GVy9PlGl9BKwVtG/KG6jCysK7HuUzIrqPUlRTClxDq8Amm4+1ESNmUhlttzmqSVlelVQGY10zsezA/iGG2EWf4d+j16dTLnkqM1N6DFodlZ7U3v9IGBCLG3ZQRh1RzArqIOmosgGIPLZlYdCCCGTofiCYei0yl8X4c+VNy1TLMwh/rIegaPSw6OLHY9jn67/AN9V/Zp/vxZc1xKnT5MwCKTSlUkApTmIZhv5bXEjY33syn/RvhX9Nl//ABRw+SKKnRKJD1bXGkAXHXUfaJj4e0E7iGa82mgpqWUsAAJGo9QJ3uVknuB1tXxmNet6j7ksq7fIAWUQB7AR2w4y9Gn5BqV6bhnBVFgonlG6lHDmekqVAKzeRjNQRpGWKaRpVhIqUyKmssBU1hxAHMykx3iVkDSZM44eSZ2iCST9Xfubm1um3TGqmoDVYsbFCJJBG9xFgdwSQYNoBxNl6TAyRrWeaZKk8wMspEAAd9xtimStk+TXmDculJIExL3XQRaFAv7wQemOqIZswAKkavUWkiZGpRG4iPje4x3XYs5cszDV9YliASNyb9Y+7EtJKChpVpI3mBG8x2NrD/IboKLH4A4aj16mYVQ1HLNppz9eqfSRyiAFIaI3ZYxcKtRmOsgybwen49seacP8RmlTWktUClq1AKkXmAxJW5sDvtA7YcVfHYFECD5pPq1AKFBudrkiegN/gcOMqBlod80ra6LU0JQLBvBBJO6ncnpHpHyLyOez5dRUal5ZB1EDm+IsB+HyxVuF+OsulPmao53A5xHcarT0ExgWv41oN5j+WC+k+UWBJDEAXJ/m7QJE7TBOK9z4JpeR0nAVajWNeirKqsqEFamcqOQobXUXk5iWUpEEGWIjDrIUKeWoZehTNSvEUlZubSoUtzvTTSAqgKLXle84oj+L6Zam15FOGHmVLtsWu4iRA2kC22/P+nBFHRTIVmYyWVjbrBknUT1iB74nJj15PU06AAByJI3IF726HAuXz6NXqUBWVqyqHenaaakCJgE3kGGJNxAAx55wvxpVqMhrPlyCyAq1NlIQagSRznVJBGwgHvAsPiXxMKARVZE5xqZqd9IYAwoFyfeBANzGE/Up1Q61ZaM3pTc62NlQGJbot/x7AHCqpwitUBXMgvTa5prHlKwA0qABLCRMsTBA64ovij+UTVTqUaGrTUQozOoBVTIMaADq6gzAnY4rLceZiP5wkfHfvvi1bIcqPdKKUdCrTYKpJ1fVeATa9xBkQcSilSIMuNAAgagYFwZnoQYvO+PIuG+KXo0tNPMMhN4CGxsfUVjebHe42xHxjxhnapKpmSBoINtMapn0LJMGBv6VMSJwlJj1R6JxqgfNLoNzrBVhyuZiCYgkqCR/WO98N+GcX5Ppkam6yGlSdW3OpUEFTJ226WvjxXO+Js05A/SajLCgSzKZ7nSJI+JODaXiSoCD+ktIVUBGoFRDSJ3bqZM9I7YTk0O0en8Q4vmSWFLJ0npkwGq1XXULQdHksVvEA+2FebPEH5f0TIot55qp3B/3aButj7Htim1eNCjQb/WKtSKnNTDVFZ9WmZcQxVWBIK6SD7EjAdfx7y1KS1Ki06iaX1O7uCYEqTOk2Hfrhq2DpF/oZXiwsq5FACQC1KszRPWwHbB+RpZpaNXzSiVjda1KmAqGNI1pUcghTvBFj0N8eTVvHmYMn9Lr3IiKjiB1tbHL+NahU/6zWLRJ52Int6sVXyRfweoUshxhmj9YR3AylK3zapf7sQ8Ty3EKAU1eJVACYkUsuontzHeJgX2OPOOAcSrZvNU6KViGZSoaqzBJ94mJsB7xi2ZrgVXJBa1d6NUBx6WLFY1G6FeaYCjbSYMgThPSGiXPcYdN+JZqSQq6vJRS5WQCy0yVBvciAVYdIx1wjxNTXnrZ6q8qYR6wZStucinQUyLgr03iSMVLirhsw71Ka2fUEEhAu4UdVQg22jVNseg5PwpwutSSqmXHl1FkfS1AQCZKnnsQZB9xiPcRUdvQu4FxRENV6uaDhqupWqVHOmmzWVVZQEXYkKFi0wFXCfJ8O4WzNNWstRiX8xtSAKTZAxBGqwkzNyJAMYtWa8F5LQyrShmB01NTFkJsCAWgx2xRsplRTqPQrU082mSJ0zqFiCD1BEEe0YmU+xtNaYxp5rKJUUJmM1pKFiz1nKgieXTqMMLGIgg74xvEtPkIeq7AMSo08wvGkvGmJUapmxicLhkaJLEC8iYAtHS4wVSyuXXUfLDlhu19J9pFvla+I96IUxunFctm6f6PQLFSojUCrnqdPmXqN6jvzQb9cVFuKNlMzzty1QrVNKqieaFANSmUAQgTHfdWvOJ87wyk0kDS06gwWSrDawi09MF5rInO0Wq1FC1tbkItU+SHIUOQhB8stKse50m040hOMloTsftVWugYEaonUNnXb626m8g7G3vgXTU/o0/ZP7sVzw/SfLiqHrKnlEN5dUgOKZ+tTvFS4IKWkC3SHv64H+6/b/8AhigsoGXyqBWq6ZNMjSp9NwJnr+OJOL1PLJ0WVAjIpJYKXVGMaiSeZmNyd8ZjMEeCpdGUpZi78xAaJAgWmwAA3wZl6zBWufULdJO5+ONYzCfIumcZfONdOnKDvzXYyRMTI3AnfucSZjnJLX5ojpAmBjWMxMuBdHdHKLp67d8crk1LGZN4ibR2xrGYylyZSJalAGBcD2JwZw3hqPURbgOQDEW9xqBg++NYzCXKCPIE1MayvYC+xN+sY7XLLD72MC5sLY1jMUJk+XpjTtht4roA1tRJkKgBnYdh95xmMxC5ZS/iKDlF1ReInf3wNWy45d773xmMxcSEH1MuoQGBfppURBEEEAGfniHM5RQLSJMm+9pj4TjMZiXyhsWrUOlj1/gflgirUgaQLWPXcxJ33xmMxrHkcOTKC/SlZO0T1iPu/DBFXKoVMqOYwf3/AB98ZjME+Spg/wCh07co6dT+/E5pAm49O1zbGYzEECvi2YNEo6f1pUyVYRsRNx7Y3wbi71dYZUACgjSsXnff+JONYzGy/wCY+h9nb0qLn1EOhPdUKR84cj4Be2Lt/JJmGejmKbGVRlZe4165HwlQfiT3xmMxj2XD+SLstIQd8UD+VvJpTNCugipzoT3VSInvEt9/sIzGYs19Tgp9DNlNcKD8S3c/1sKq3iCr5zrC6QbDm6H+1164zGYzSVkBy8YZj6EHwL9/dzhh4eqk5miwAUu4Ro+shKSp1Ta5xmMxfppWINzvD6ba6LLqFIVCjMSXEtVUrJ6FYERaARBE4TfqCh2f/mP/AO7GYzGwH//Z"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:48.1351253, lng:11.5819806},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>독일-뮌헨</h1>뮌헨은 독일 바이에른주의 최대 도시이자 주도시이다. 이 도시는 알프스 북부의 이자르 강가에 위치한다. 뮌헨은 독일 내에서 베를린과 함부르크에 이어 세 번째로 큰 도시이다. <br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://img1.daumcdn.net/thumb/R1280x0/?fname=http://t1.daumcdn.net/brunch/service/user/P7F/image/N9oJkTQpfaM5UGwBNqR7ImRmWTA.jpg"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:52.3758916, lng:9.732010400000002},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>독일-하노버</h1>하노버는 라이네 강 중류에 위치한 독일 니더작센주의 주도이다. 역사적으로 영국의 하노버 왕가가 선제후로 있었던 하노버 선제후령의 수도이기도 하다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://t1.daumcdn.net/cfile/blog/15735A3450A68A5625"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:49.4521018, lng:11.0766654},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>독일-뉘른베르크</h1>뉘른베르크는 독일 바이에른주에 있는 도시이다. 인구는 약 518,370명이며 바이에른 주에서는 뮌헨에 이어 2번째로 큰 도시이다. 프랑켄 지방의 경제적, 문화적 중심지이기도 하다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="http://www.travelnbike.com/news/photo/201512/16370_15877_623.jpg"  width="400px" height="auto"></a></div></div>',
        },
        // 동티모르
        {
            coords:{lat: -8.5568557, lng:125.5603143},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>동티모르-딜리</h1>딜리는 티모르섬 북동부에 위치하는 동티모르의 수도이자, 동티모르 최대의 도시이다. 인구는 약 22만명으로 1520년에 포르투갈의 식민지로 건설되었다. 소순다 열도의 가장 동쪽, 티모르섬의 북쪽 해안에 위치한다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://dynamic-media-cdn.tripadvisor.com/media/photo-o/0f/8e/45/f9/backside-beach-from-the.jpg?w=700&h=-1&s=1"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:-8.5272256, lng:127.0002673},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>동티모르-로스팔로스</h1>로스팔루스는 동티모르 라우텡 현의 현도로, 딜리에서 동쪽으로 248km 정도 떨어진 곳에 위치한다. 인구는 17,186명이며 구 전체 인구는 25,417명이다. <br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://file.mk.co.kr/meet/neds/2018/01/image_readtop_2018_38142_15161686393175070.jpg"  width="400px" height="auto"></a></div></div>',
        },
        // 라오스
        {
            coords:{lat:18.95009, lng:102.44379},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>라오스-방비엥</h1>왕위앙은 라오스 비엔티안주의 도시로 인구는 약 25,000명이다. 남송 강과 접하며 루앙프라방과 비엔티안의 중간 지점에 위치한다. 카르스트 지형을 띤 언덕으로 유명한 곳이다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://d2qgx4jylglh9c.cloudfront.net/kr/wp-content/uploads/2015/03/2268CE4454FFE10938C0BC.jpg"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:17.9757058, lng:102.6331035},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>라오스-비엔티안</h1>비엔티안 또는 위앙짠은 메콩 강에 접한 라오스의 수도다. 1563년에 미얀마의 침략을 피하고자 라오스의 수도가 되었다. <br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://www.popco.net/zboard/data/foreign_talk/2017/03/09/58649021458c11e567a633.jpg"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:19.883285, lng:102.1387166},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>라오스-루앙프라방</h1>루앙파방은 라오스 북부에 위치한 고대 도시이다. 도시 자체가 세계문화유산으로 유네스코의 세계유산에 등록되어 있다. 라오스의 수도 비엔티안에서 메콩 강을 약 400km 상류로 거슬러 올라가 칸 강과 합류한 곳에 위치한다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://file.mk.co.kr/meet/neds/2016/11/image_readtop_2016_823370_14802732672696228.jpg"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:15.1171823, lng:105.8159045},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>라오스-팍세</h1>빡세은 라오스 남부 참파사크 주의 주도로, 인구는 약 87,000명이며 쎄도네 강과 메콩 강이 합류하는 지점에 위치한다. <br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://pds.joongang.co.kr/news/component/htmlphoto_mmdata/201912/13/edf21405-8f75-42ac-bd24-263f857f0803.jpg"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:15.7165658, lng:106.4140868},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>라오스-사라반</h1>Salavan은 라오스 남부의 Salavan Province의 수도입니다. 또한 지방 지구입니다. 부분 포장 도로의 Pakse에서 125km 떨어져 있습니다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://www.artinsight.co.kr/data/tmp/1909/2b867c53d794f5a6c0965d6c31e99e2d_u1k4zZG33cPk3aj.JPG"  width="400px" height="auto"></a></div></div>',
        },
        // 라이베리아
        {
            coords:{lat:6.3156068, lng:-10.8073698},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>라이베리아-몬로비아</h1>몬로비아는 라이베리아의 수도이다. 메주라도 곶 대서양 연안에 위치하며, 라이베리아에서 가장 인구가 많은 주인 몽세라도 주에 위치한다. <br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://pds.joongang.co.kr/news/component/htmlphoto_mmdata/202201/20/d1f59c9d-c750-4467-b90b-5bb23f695155.jpg"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:7.0024321, lng:-9.4728244},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>라이베리아-바른가</h1>바릉가는 라이베리아 봉 주의 주도이다. 2008년 임시 인구 조사에서 34,046명의 인구를 기록했다. <br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://mblogthumb-phinf.pstatic.net/20091216_146/braveattack_1260966440264Lyz6y_gif/roosevelt_and_barclay_braveattack.gif?type=w2"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:4.5882858, lng:-7.6710889},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>라이베리아-헬로메</h1>라이베리아 공화국, 약칭 라이베리아는 1847년에 세워진 아프리카의 첫 공화국이다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://w.namu.la/s/d981ca0c510861cc4c79002fac6302e6aff8e57e21b8477c80c126ce01c761470d92ef19bbce1ffdb45d8452d3cead32d9fae42fae3844f763986000523dcff4b08ebc7acf2fd64f069b3945aa7b58a7a294fb11ad18f2e9187bd5f6d2c546e7"  width="400px" height="auto"></a></div></div>',
        },
        // 라트비아
        {
            coords:{lat:56.9676941, lng:24.1056221},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>라트비아-리가</h1>리가는 라트비아의 수도로, 발트해와 다우가바강에 접해 있다. 리가는 발트 3국 가운데 가장 큰 도시이다. 면적은 307.17 km²로서, 해발 1~10m 사이에 분포해 있으며, 평지와 사구로 되어 있다. <br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://mblogthumb-phinf.pstatic.net/MjAxNzA4MTdfMjc3/MDAxNTAyOTI3NTEyMTM5.gQEc9sWPNyEvjM19WfsS8N0W4_5OaWMTU3Af2DKWJzYg.UTTNfGpDL5_soSHYDLgaGxhAhAjqw6j4tY_iaQawFR0g.JPEG.kotfa198643/riga-1380164_1920.jpg?type=w800"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:56.6511478, lng:23.7196411},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>라트비아-옐가바</h1>옐가바는 라트비아 중부에 위치한 도시로, 면적은 60km², 인구는 64,516명, 인구 밀도는 1,073명/km²이다. 젬갈레 지방에서 가장 큰 도시이며 리가에서 남서쪽으로 41km 정도 떨어진 곳에 위치한다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://p.bookcdn.com/data/Photos/380x200/11752/1175222/1175222642/Hotel-Jelgava-photos-Exterior.JPEG"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:56.5384577, lng:21.0538204},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>라트비아-리예파야</h1>리에파야는 라트비아 서쪽의 발트해에 위치한 도시이다. 쿠를란트 지방의 중심지로 인구는 14만 명이다. 라트비아에서 3번째로 인구가 많은 도시이다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://storage.doopedia.co.kr/upload/_upload/image/1603/25/160325020191380/160325020191380_thumb_400.jpg"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:55.88261259999999, lng:26.5464985},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>라트비아-다우가프필스</h1>다우가프필스는 라트비아 최동단의 도시이다. 다우가바 강에 위치해 있다. <br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://dynamic-media-cdn.tripadvisor.com/media/photo-o/08/a0/cb/0e/daugavpils-mark-rothko.jpg?w=700&h=-1&s=1"  width="400px" height="auto"></a></div></div>',
        },
        // 러시아
        {
            coords:{lat:43.1332484, lng:131.9112975},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>러시아-블라디보스토크</h1>블라디보스토크는 러시아의 도시이다. 러시아 극동의 중심지이며 프리모르스키 지방의 행정중심지이다. 시베리아 횡단 철도의 출발점이며, 러시아의 태평양 진출의 문호이다. 인구는 2013년 기준으로 60만3천명이다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://w.namu.la/s/fba648605618e26b443f466ee8d425056c31d1c077ff6cdfc25a5e0625c94de5d660c9d99715a6592d529383164b16e272e00e30831c8b167c256588ebbc29992fd9991245210fc6828b845620e46f80a4a4d02289c05f0136ed9b9982930760"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:48.4814433, lng:135.0720667},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>러시아-하바로프스크</h1>하바롭스크는 러시아의 도시로, 하바롭스크 지방의 중심지이다. 아무르 강 유역에 자리잡고 있는 하바롭스크는, 강을 끼고있는 도시가 얼마나 아름다운지를 단적으로 보여주고 있다. <br><br><div style="width:400px;height:auto;"><a href="#"><img src="http://www.krcon.co.kr/webzine/1902/images/sub/12_2a.png"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:52.2854834, lng:104.2890222},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>러시아-이르쿠츠크</h1>이르쿠츠크는 시베리아에 있는 도시이자, 러시아 이르쿠츠크주의 주도이다. 인구는 약 60만 명이다. 기계 제조, 목재 가공, 모피, 식료품 등의 공업이 발달 했으며, 수력전기에 의한 알루미늄 제조업이 번성했다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://youimg1.tripcdn.com/target/fd/tg/g2/M0B/A1/E2/CghzgVVkJ7qAH2PrAChKz2l-zJ0761_C_640_320_R5_Q70.jpg_.webp?proc=source%2Ftrip"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:54.9832693, lng:82.8963831},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>러시아-노보시비르스크</h1>노보시비르스크는 인구 수 기준으로 러시아 제3의 도시이며 시베리아 제1의 도시다. 시베리아 연방관구, 노보시비르스크주, 노보시비르스크구의 행정수도이며 서시베리아경제구역의 중심지이다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://www.sjpost.co.kr/news/photo/202010/54463_50893_3954.jpg"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:54.9913545, lng:73.3645204},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>러시아-옴스크</h1>옴스크는 러시아 중남부의 도시이다. 시베리아 연방관구에 위치한다. 인구는 1,140,200명이다. 시베리아에서는 노보시비르스크에 뒤를 잇는 두 번째로 큰 도시이다. 모스크바로부터는 2,555킬로미터 떨어져 있다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://t1.daumcdn.net/cfile/tistory/99EA9C4C5B7650513A"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:55.755826, lng:37.6173},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>러시아-모스크바</h1>모스크바는 러시아의 수도이다. 러시아 최대의 도시이자 유럽에서 인구가 가장 많은 도시이며, 세계에서는 4번째로 큰 도시이다. 14세기에서 18세기 초까지 러시아 제국의 수도는 상트페테르부르크였다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://dimg.donga.com/ugc/CDB/SHINDONGA/Article/5e/60/54/94/5e605494098dd2738de6.jpg"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:59.9310584, lng:30.3609097},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>러시아-상트페테르부르크</h1>상트페테르부르크는 러시아의 북서쪽에 있는 연방시이다. 네바 강 하구에 있으며, 그 델타지대에 형성된 자연섬과 운하로 인해 생긴 수많은 섬 위에 세워진 도시이다. 발트해의 핀란드 만에 접해 있다. <br><br><div style="width:400px;height:auto;"><a href="#"><img src="http://economychosun.com/query/upload/215/215_54.jpg"  width="400px" height="auto"></a></div></div>',
        },
        // 레바논
        {
            coords:{lat:33.8937913, lng:35.5017767},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>레바논-베이루트</h1>베이루트는 레바논의 수도이며, 베이루트 주의 중심지이자 레바논 최대의 도시다. 또 지중해에 접한 레바논 제일의 해항이다. <br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://img.freepik.com/premium-photo/lebanon-beirut-city-skyline_24859-755.jpg"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:34.4432743, lng:35.8349635},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>레바논-트리폴리</h1>트리폴리는 지중해 동부 연안에 위치한 레바논의 도시로, 북부 주의 주도이며 베이루트에서 북쪽으로 85km 정도 떨어진 곳에 위치한다.광역 인구는 약 500,000명이며 레바논에서 베이루트에 이어 두 번째로 큰 도시이자 항구 도시이기도 하다. <br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://dynamic-media-cdn.tripadvisor.com/media/photo-o/03/fe/36/3a/citadel-saint-gilles.jpg?w=700&h=-1&s=1"  width="400px" height="auto"></a></div></div>',
        },
        // 레소토
        {
            coords:{lat:-29.3076703, lng:27.4792557},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>레소토-마세루</h1>마세루는 레소토의 수도이자 최대 도시이다. 셀리던 강의 하류에 위치해 있으며, 남아프리카 공화국과의 국경을 접한다. 레소토 상업의 중심지이고 인구는 22만 명이다. <br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://storage.doopedia.co.kr/upload/_upload/image5/2206/29/220629024347534/220629024347534_thumb_400.jpg"  width="400px" height="auto"></a></div></div>',
        },
        // 루마니아
        {
            coords:{lat:46.7712101, lng:23.6236353},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>루마니아-클루지나포카</h1>클루지나포카는 루마니아 서북부 클루지 주에 있는 도시로 루마니아 제2의 도시다. 인구 324,576. 트란실바니아 지방의 중심 도시이며 줄여서 클루지라고 부르기도 한다. <br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://w.namu.la/s/780beb8009e44030dfcc5b6cfe067dfc366ae521924219e14bcd83bfa9478d670855c1bc2ea331c05a9f30c7c0e61399828da8b2d0eb4d6af6de7837696fcf580656ef0af3477095288addba540f513b91579e569b206ce84bce01bd455c97c8"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:44.4267674, lng:26.1025384},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>루마니아-부쿠레슈티</h1>부쿠레슈티는 루마니아의 수도이다. 영어로는 부카레스트라고 한다. 인구는 2,272,163명이다. 부쿠레슈티가 기록에 가장 먼저 등장한 것은 1459년이다. <br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://m1.daumcdn.net/cfile221/image/216BF03655C850F4237768"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:47.1584549, lng:27.6014418},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>루마니아-이아시</h1>이아시는 루마니아 북동부와 몰다비아 지방 중부에 위치한 도시로, 면적은 93.9km², 인구는 315,214명이다. 루마니아 동부 지방에서 가장 큰 도시이며 부쿠레슈티 다음으로 루마니아에서 두 번째로 큰 도시이다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://www.hotelscombined.co.kr/rimg/dimg/ea/ff/74214aef-city-7673-165b4b6c1c4.jpg?width=1366&height=768&xhint=1676&yhint=1096&crop=true"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:45.7488716, lng:21.2086793},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>루마니아-티미쇼아라</h1>티미쇼아라는 루마니아 서부에 있는 도시로 티미슈 주의 주도이다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://youimg1.tripcdn.com/target/0103b120008x12q7q13B0_D_1180_558.jpg?proc=source%2Ftrip"  width="400px" height="auto"></a></div></div>',
        },
        // 룩셈부르크
        {
            coords:{lat:50.0546886, lng:5.467698299999999},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>룩셈부르크-뤽상부르</h1>룩셈부르크 대공국, 약칭 룩셈부르크는 서유럽에 위치한 국가이며 대공이 통치하는 대공국이다. 수도는 룩셈부르크이다. 룩셈부르크는 세계에서 국민 소득이 높은 나라 중 하나이기도 하다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://youimg1.tripcdn.com/target/0103l1200082ev53l539B_C_640_320_R5_Q70.jpg_.webp?proc=source%2Ftrip"  width="400px" height="auto"></a></div></div>',
        },
        // 르완다
        {
            coords:{lat:-1.9440727, lng:30.0618851},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>르완다-키갈리</h1>키갈리는 르완다의 수도로, 면적은 730km², 인구는 745,261명이다. 르완다의 거의 중앙에 위치해 있고, 1,433ｍ에서 1,645m의 고지에 위치해 있다. 3개 구를 관할한다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://youimg1.tripcdn.com/target/100p10000000o2w4pA6DC_C_640_320_R5_Q70.jpg_.webp?proc=source%2Ftrip"  width="400px" height="auto"></a></div></div>',
        },
        // 리비아 
        {
            coords:{lat:32.8872094, lng:13.1913383},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>리비아-트리폴리</h1>트리폴리는 리비아의 수도이다. 리비아의 북서부에 위치해 있고, 지중해에 접한 항구도시이다. 해안지대의 좁은 오아시스에 있고, 30km 떨어진 내륙은 사막지대이다. <br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://mblogthumb-phinf.pstatic.net/20141227_178/hansongp_1419608364564nj8Yk_JPEG/IMG_1335-1%C6%AE%B8%AE%C6%FA%B8%AE%C0%FC%B0%E62.jpg?type=w2"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:32.1194242, lng:20.0867909},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>리비아-벵가지</h1>벵가지는 리비아의 두 번째로 큰 도시이다. 키레나이카 지방의 중심도시이며, 인구는 660,147명이다. 기원전 8세기경 페니키아인들이 교역항으로 사용하였고, 리비아 왕국 때 수도로서 번창했다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="http://www.ikld.kr/news/photo/200907/3392_1831.jpg"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:27.0401565, lng:14.4929723},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>리비아-사바</h1>사바는 리비아 남서부에 위치한 도시로, 세바 주의 주도이다. 인구는 약 130,000명이며 페잔 지방에서 가장 큰 도시이다. <br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://mblogthumb-phinf.pstatic.net/20101004_296/lljy3414_1286199881017ozHhy_JPEG/marib2.jpg?type=w2"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:30.757528, lng:20.2230039},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>리비아-아즈다비야</h1>아지다비야는 리비아 동부에 위치한 도시로, 알와하트 주의 주도이다. 벵가지에서 남쪽으로 160km 정도 떨어진 곳에 위치하며 인구는 134,358명이다. 2001년부터 2007년까지는 아지다비야 주의 주도였다. <br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://pds.joongang.co.kr/news/component/htmlphoto_mmdata/202209/01/80b25ef0-73f3-4d13-9e7d-10b92e5013d4.jpg/_ir_400x224_/"  width="400px" height="auto"></a></div></div>',
        },
        // 리투아니아
        {
            coords:{lat:54.8985207, lng:23.9035965},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>리투아니아-카우나스</h1>카우나스는 리투아니아 제2의 도시이다. 카우나스 주의 중심지이기도 하며, 카우나스 시와 카우나스 군청이 동시에 자리해 있다. 또 카우나스 대교구 교회도 이곳에 있다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://dynamic-media-cdn.tripadvisor.com/media/photo-o/0e/33/00/a4/lrm-export-20170114-183226.jpg?w=700&h=500&s=1"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:55.70329479999999, lng:21.1442794},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>리투아니아-클라이페다</h1>클라이페다는 발트해에 있는 리투아니아의 유일한 항구 도시이다. 네만 강 하류에 위치하고 있으며, 스웨덴, 덴마크, 독일 등과 이어지는 주요한 페리 항이다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://www.hotelscombined.co.kr/rimg/dimg/4f/7a/2e20cfe7-city-32249-166c1b8ab45.jpg?width=1366&height=768&xhint=2471&yhint=2104&crop=true"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:54.6871555, lng:25.2796514},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>리투아니아-빌뉴스</h1>빌뉴스는 리투아니아의 수도로, 옛 이름은 빌나 였다. 전간기에는 리투아니아 대공국, 후에 폴란드-리투아니아 연방의 영토였다. <br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://upload.wikimedia.org/wikipedia/commons/thumb/5/54/Vilnius_Modern_Skyline_At_Dusk%2C_Lithuania_-_Diliff.jpg/640px-Vilnius_Modern_Skyline_At_Dusk%2C_Lithuania_-_Diliff.jpg"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:55.9349085, lng:23.3136823},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>리투아니아-시아울리아이</h1>샤울랴이는 리투아니아 북부에 있는 도시로, 샤울랴이 주의 주도이다. 리투아니아에서 네 번째로 큰 도시이며 십자가 언덕으로 유명한 도시이다. <br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://media.istockphoto.com/photos/hill-of-crosses-in-lithuania-picture-id134934649?k=20&m=134934649&s=612x612&w=0&h=s25WGzHZvLtjbFy2EUvnGWfLSSStj1-6QbnH-mZ6ljQ="  width="400px" height="auto"></a></div></div>',
        },
        // 리헤텐슈타인
        {
            coords:{lat:47.1410303, lng:9.5209277},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>리헤텐슈타인-바두츠</h1>파두츠는 리히텐슈타인의 수도로 인구는 2005년 기준으로 5019명이다. 리히텐슈타인 공작가는 본래 오스트리아에 거소가 있었는데, 1938년부터 이곳에 거소를 두었다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://post-phinf.pstatic.net/MjAxNzAzMjlfNzAg/MDAxNDkwNzY5OTI3MTkz.GcainkGLoDdXltGRSub2Ev1gcYHonKifBiNnT-SM9Z4g.UuuxDcxkFc4PX0UG5vhK69F2KsFYkHp7F-x30w9zRgsg.JPEG/SAM_9787.JPG?type=w1200"  width="400px" height="auto"></a></div></div>',
        },
        // 마다가스카르
        {
            coords:{lat:-18.8791902, lng:47.5079055},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>마다가스카르-안타나나리보</h1>안타나나리보는 마다가스카르의 수도로 마다가스카르섬의 거의 중앙에 위치한다. 마다가스카르 고원에 위치하고, 표고는 1,200미터를 넘는다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="http://ojsfile.ohmynews.com/STD_IMG_FILE/2007/1002/IE000812151_STD.jpg"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat: -13.6635336, lng:48.4537424},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>마다가스카르-암반자</h1>암반자는 마다가스카르 북부에 위치한 도시로, 인구는 28,468명이다. 모잠비크 해협과 접하며 암반자 현의 행정 중심지이다. 암반자 전체 인구 가운데 60%는 농업에, 2%는 목축업에 종사한다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://mblogthumb-phinf.pstatic.net/MjAxOTAyMTNfMTAz/MDAxNTUwMDQ0Mzg1NTU4.9FDtXUqbT40Y0STjs2d7Hap3mw2nHo2IUezAVrj3Jfkg.PtIoDY3fKZX8qPmRxzy1MT8FJA99jH7RCQtEmeCvJKAg.JPEG.hyechotravel/%EB%A7%88%EB%8B%A4%EA%B0%80%EC%8A%A4%EC%B9%B4%EB%A5%B4_%EB%B0%94%EC%98%A4%EB%B0%A5%EA%B1%B0%EB%A6%AC_shutterstock_259688654.jpg?type=w800"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:-18.1442811, lng:49.3957836},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>마다가스카르-토아마시나</h1>토아마시나 또는 타마타브는 마다가스카르 동부와 인도양 연안에 위치한 항구도시이다. <br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://storage.doopedia.co.kr/upload/_upload/image5/2207/28/220728024375613/220728024375613_thumb_400.jpg"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:-20.2904186, lng:44.2999955},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>마다가스카르-모론디바</h1>모론다바는 마다가스카르의 도시로, 메나베 구의 행정 중심지이며 높이는 해발 8m이다. 모잠비크 해협과 접하며 모론다바 강 삼각주 지대에 위치한다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://mblogthumb-phinf.pstatic.net/MjAxOTEwMjlfMTIw/MDAxNTcyMzMwMzA0ODQ2.AYML6sc2_pNLlFqOZX4IqGNfObgbfrt0d9ASYKmGRpMg.sN6mq4lesLpDEfbkgdoSwZWl3W1bWcFRTF8nifKOlggg.JPEG.harry1670/20191027_182653.jpg?type=w800"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:-25.0225309, lng:46.9853688},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>마다가스카르-톨라나로</h1>톨라나로는 마다가스카르의 도시이다. 마다가스카르 섬 남부에 위치해 있으며, 인도양과 접한 항구 도시이다. 옛 명칭은 포르도팽이었다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://media.istockphoto.com/photos/malagasy-people-rowing-picture-id929087062?k=20&m=929087062&s=612x612&w=0&h=OnZIjzXd4NnxC5J-n_w2mJ-To2UWkPEygFuw-s2qTq4="  width="400px" height="auto"></a></div></div>',
        },
        // 마셜 제도
        {
            coords:{lat:7.094972899999999, lng:171.1150819},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>마셜제도-아젤테이크</h1>Ajeltake는 마셜 제도의 도시입니다. 그것은 Majuro Atoll에 위치하고 Atoll 고리의 남서쪽 부분을 차지합니다. 2006 년 인구는 1,700 명입니다. <br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://mblogthumb-phinf.pstatic.net/MjAyMDExMDVfNTYg/MDAxNjA0NTU3NTU5NzM3.zeplcb6LUzq4Fw533c2pZ9Mmzm1x_HzpodJNkMaOwPUg.Ie5V9oY8GbhuJyPnQoOvQte1laj5S_hjJ39adt7_voUg.JPEG.sptokorea/SE-7f11a9cb-df77-42ba-ab18-acccf63d03ed.jpg?type=w800"  width="400px" height="auto"></a></div></div>',
        },
        // 말라위
        {
            coords:{lat:-14.5943269, lng:34.2099104},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>말라위-릴롱궤</h1>릴롱궤는 인구 866,272명의 말라위의 수도이다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://dynamic-media-cdn.tripadvisor.com/media/photo-o/12/09/43/c4/monkey-bay.jpg?w=500&h=300&s=1"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:-11.4389649, lng:34.0084395},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>말라위-음주주</h1>음주주는 말라위 북부에 위치한 도시로, 북부주의 주도이다. 말라위에서 세 번째로 큰 도시이며 인구는 175,345명이다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://t1.daumcdn.net/cfile/tistory/22646C4057ACA5612B"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:-15.7666707, lng:35.1090431},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>말라위-블랜타이어</h1>블랜타이어는 말라위의 북쪽 소체 산 기슭에 위치한 말라위 최대의 도시로 남부주의 주도이자 블랜타이어현의 현도이다. <br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://dynamic-media-cdn.tripadvisor.com/media/photo-o/0f/6d/dc/ba/our-beautiful-pool-offering.jpg?w=500&h=300&s=1"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:-12.9316863, lng:34.2810541},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>말라위-은코타코타</h1>은코타코타는 말라위 호와 접한 말라위의 도시로, 중부 주 은코타코타 현의 현도이며 높이는 472m, 인구는 33,150명이다. 19세기 중반 아랍계 노예 무역의 중심지였던 곳이다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://img1.daumcdn.net/thumb/R1280x0.fjpg/?fname=http://t1.daumcdn.net/brunch/service/user/clER/image/swCIq6pPU-I3ihQRyX7tUWFwGYk.jpg"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:-13.8357073, lng:33.0423203},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>말라위-엔코타카타</h1>말라위 공화국은 과거 니아살랜드라고 불리던 동남부 아프리카에 있는 내륙국이다. 북서부로는 잠비아, 북동부로는 탄자니아, 동부, 남부, 서부로는 모잠비크와 국경을 이루고 있고, 말라위 호에 의해 탄자니아와 모잠비크로 나뉘어 있다. <br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://w.namu.la/s/33c479ac4e9bb534931eefcf91291bfdd3d99d78e08407df9931fffb2f85b47949270127609b02b29900e678231abcc8f25b3ab1d93eee97e529430c7b2040419ae38ff58d7e7c9711f5f77064edd1939d6705c3ea7280bf95960e85aa39593b"  width="400px" height="auto"></a></div></div>',
        },
        // 말레이시아
        {
            coords:{lat:3.1569486, lng:101.712303},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>말레이시아-쿠알라룸푸르</h1>쿠알라룸푸르, 공식적으로 쿠알라룸푸르 연방 직할구는 말레이시아의 수도이며 말레이시아에서 가장 큰 도시로 면적은 243km² 이며, 2016년 기준 인구는 약 173 만 명이다. <br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://t1.daumcdn.net/cfile/tistory/9914873C5CD84E120C"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:5.643589, lng:100.4894179},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>말레이시아-숭파이페타니</h1>숭가이 페타니(Sungai Petani)는 말레이시아 케다주 쿠알라 무다 구에 있는 마을이다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://res.cloudinary.com/stay-list/image/upload/w_500/v1549609635/area/vietnam/thai-nguyen-l.jpg"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:2.287284, lng:111.830535},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>말레이시아-시부</h1>시부는 말레이시아 동부 사라왁주와 보르네오섬 북서부에 위치한 타운으로, 면적은 8,278.3km², 인구는 209,616명이다. 라장강과 이간 강이 합류하는 지점에 위치하며 바다에서 약 60km 정도 떨어진 곳에 위치한다. <br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://dynamic-media-cdn.tripadvisor.com/media/photo-o/10/a0/05/60/screenshot-2017-09-11.jpg?w=700&h=500&s=1"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:3.171322, lng:113.0419069},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>말레이시아-빈툴루</h1>빈툴루는 말레이시아 사라왁주에 위치한 마을이며, 빈툴루 구역의 중심 도시이다. 사라왁의 주도인 쿠칭으로부터 650km, 미리/시부로부터 215km가량 떨어져 있다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://dynamic-media-cdn.tripadvisor.com/media/photo-o/17/c3/93/8e/morning-view-at-pantai.jpg?w=500&h=300&s=1"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:5.839443999999999, lng:118.1171729},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>말레이시아-센다칸</h1>산다칸은 말레이시아 사바주에 위치한 도시로, 보르네오섬 북동부에 위치한다. 코타키나발루 다음으로 사바 주에서 두 번째로 인구가 많은 도시이며 면적은 2,266km², 인구는 479,121명이다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://image.kkday.com/v2/image/get/w_960%2Cc_fit%2Cq_55%2Ct_webp/s1.kkday.com/product_7183/20160407034649_kAOV1/jpg"  width="400px" height="auto"></a></div></div>',
        },
        // 말리
        {
            coords:{lat:12.6392316, lng:-8.0028892},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>말리-바마코</h1>바마코는 말리의 수도이다. 니제르 강과 말리의 남서쪽에 위치한다. 바마코는 행정 중심이자 가까이에 쿨리코로 항구가 위치해있으며 주요한 지역의 무역 중심이다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://previews.123rf.com/images/dutourdumonde/dutourdumonde1405/dutourdumonde140500005/28104905-%EB%B0%94%EB%A7%88%EC%BD%94%EC%9D%98%EB%B3%B4%EA%B8%B0-%EB%A7%90%EB%A6%AC%EC%9D%98-%EB%8B%88%EC%A0%9C%EB%A5%B4-%EA%B0%95.jpg"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:16.7665887, lng:-3.0025615},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>말리-팀북투</h1>팀북투 또는 통북투는 말리의 통북투 주에 있는 도시이다. 니제르강변에 위치하고 있다. <br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://w.namu.la/s/8d0e3b2344231317d9784036dde6949d4019ff04620d7d42bb9c6b5598f8690b2bac2b2780ef8e7371015643f85210b92725c2a48ffaa727aab70f0c25adcc8f31ae2e274159a1e345cbf02cb2f63159782b1491665c918a53291c44078a113e"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:16.2639807, lng:-0.0279867},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>말리-가오</h1>가오는 말리에 위치해 있는 도시로, 가오 주의 주도이며 나이저 강변에 위치해 있다. 고도 팀북투로부터는 동남동쪽으로 320km 떨어진 위치에 있다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://img1.yna.co.kr/etc/inner/KR/2016/12/26/AKR20161226140900081_01_i_P4.jpg"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:13.4316597, lng:-6.2482149},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>말리-세구</h1>세구는 니제르 강을 접하는 말리 세구 주의 주도다. 면적은 64947km²며 인구는 100,000명이다. 바마코에서 240km 떨어져있다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://storage.doopedia.co.kr/upload/_upload/comm/travelworld/201004/11/400_127095544731664.jpg"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:14.4297846, lng:-11.4897737},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>말리-케스</h1>말리 공화국은 아프리카에 있는 공화국이다. 사하라에서 서아프리카로 광대한 국토가 펼쳐지는데, 기후는 북반부가 사막성이고 남으로는 스텝성 열대사바나성으로 건조한 땅이다. <br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://w.namu.la/s/8226d5155442081b59c7fe0a584064cf334626e280e783180da2af735768d9d4f6191d0c11ddd830db5615ab888c77083df2230148cb4cee2d89c1faa94e5c1e18c8b359591f9851b3a968fcdd5e1cec7df5f5859ce16ba945979815e30403e8"  width="400px" height="auto"></a></div></div>',
        },
        // 멕시코
        {
            coords:{lat:25.6866142, lng:-100.3161126},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>멕시코-몬테레이</h1>몬테레이는 멕시코 동북부 누에보레온주에 있는 도시이다. 누에보레온주의 주도이며, 광역 인구는 약 4,689,601명이다. <br><br><div style="width:400px;height:auto;"><a href="#"><img src="http://ojsfile.ohmynews.com/STD_IMG_FILE/2017/0210/IE002108308_STD.JPG"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:22.1564699, lng:-100.9855409},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>멕시코-산루이스포토시주</h1>산루이포토시는 멕시코 산루이스포토시주의 주도이다. 면적은 385km²이며, 인구는 685,934명이다. 도시 이름은 프랑스의 군주인 루이 9세에서 유래된 이름이다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://wishbeen-seoul.s3.ap-northeast-2.amazonaws.com/spot/1431681576628_2099002580_64378d41e8_o.jpg"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:19.4326077, lng:-99.133208},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>멕시코-멕시코시티</h1>멕시코시티는 멕시코의 수도로, 멕시코 고원 위에 위치해 있다. 아스텍 제국 시대에는 텍스코코 호 위의 섬에 있는 테노치티틀란이라는 도시였는데, 스페인 사람들이 호수를 메워 멕시코시티를 건설했다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://youimg1.tripcdn.com/target/100a1f000001grmdw5A61_D_760_506.jpg"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:20.9649647, lng:-89.5731022},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>멕시코-메리다</h1>메리다는 유카탄주의 주도이자 가장 큰 도시이다. 멕시코 만 해안으로부터 대략 35km, 주의 북서쪽에 위치해 있다. 도시는 또한 그곳을 둘러싸는 동명의 지역 자치제 소재지이다. <br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://i.ytimg.com/vi/Afp5MDkzrQk/maxresdefault.jpg"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:29.0729673, lng:-110.9559192},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>멕시코-에르모시요</h1>에르모시요 는 멕시코의 소노라주에서 가장 큰 도시이자 주도이다. 소노라 주의 중심에 위치해 있으며 미국과의 국경으로부터 167 마일 떨어져 있다. 소노라 주의 내부에 자리잡고 있다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://mblogthumb-phinf.pstatic.net/20161020_113/adstratours_1476904128810736Ro_JPEG/zaragoza2.jpg?type=w800"  width="400px" height="auto"></a></div></div>',
        },
        // 모나코
        {
            coords:{lat:43.7308084, lng:7.4225881},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>모나코-모나코빌</h1>모나코빌은 모나코 중부에 위치한 행정구로 면적은 0.19km², 인구는 1,151명이다. 지중해 연안과 접하며 흔히 르로셰라고 부르기도 한다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://media.istockphoto.com/photos/cityscape-of-la-condamine-monacoville-monaco-picture-id521530364"  width="400px" height="auto"></a></div></div>',
        },
        // 모로코
        {
            coords:{lat:33.5731104, lng:-7.589843399999999},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>모로코-카사블랑카</h1>카사블랑카는 대서양에 위치한 모로코의 최대 도시이다. 위도는 33°32′N 7°35′W.에 있다. 도시 이름은 스페인어로 "하얀 집"을 뜻한다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://youimg1.tripcdn.com/target/10031f000001gs27k71AD_D_1180_558.jpg?proc=source%2Ftrip"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:34.0181246, lng:-5.0078451},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>모로코-페스</h1>페스는 모로코에 있는 도시이며, 인구는 1,008,782명이다. 모로코 중앙 북부의 산기슭의 페스 강 연안에 위치한다. <br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://t1.daumcdn.net/cfile/blog/0211CA3F51BD80790F"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:31.6294723, lng:-7.981084500000001},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>모로코-마라케시</h1>마라케시는 모로코 중앙부에 있는 도시이다. 인구는 1,036,500명이다. 카사블랑카 남쪽의 아틀라스 산맥 북쪽 기슭에 위치한다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://i0.wp.com/blog.findmybucketlist.com/wp-content/uploads/2020/12/1209-1__________________________________________________________________________________________.jpg?resize=792%2C446&ssl=1"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:33.9715904, lng:-6.8498129},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>모로코-라바트</h1>라바트는 모로코의 수도이다. 인구 수는 2012년을 기준으로 100만명에 달하고 있으며, 면적은 5,321km²로 경기도의 절반 크기에 해당된다. <br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://www.yeongnam.com/mnt/file/202103/2021033001001144600047012.jpg"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:31.5084926, lng:-9.7595041},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>모로코-에사우이라</h1>에사우이라는 모로코 서부와 대서양 연안에 위치한 마라케시텐시프트엘하우즈 지방의 도시이다. 오래전부터 항구 도시로 번영을 누린 도시이며 관광 유적으로 유명한 곳이다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://youimg1.tripcdn.com/target/100s10000000or2oh2D1B_C_640_320_R5_Q70.jpg_.webp?proc=source%2Ftrip"  width="400px" height="auto"></a></div></div>',
        },
        // 모리셔스
        {
            coords:{lat:-20.1608912, lng:57.5012222},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>모리셔스-포트루이스</h1>포트루이스는 모리셔스의 수도로 인구는 약 15만 명이다. 섬의 북서부 해안에 있으며 항구 도시로 상업 중심지이다. 담배 제조업이 성하고 설탕을 수출한다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://mblogthumb-phinf.pstatic.net/MjAxODA3MTBfMTEy/MDAxNTMxMjA1ODQxMDUy.Gq9ehVPBEyV2h9LMYoASuTSAPk6KLuBvjcAWAHZfdIgg.ZrjgoRFMKA3gG4M2kUb1XTTMsHXv040OqfOjNGJXvcUg.JPEG.everything91/%EB%AA%A8%EB%A6%AC%EC%85%94%EC%8A%A4%EC%9E%90%EC%9C%A0%EC%97%AC%ED%96%89_%ED%8F%AC%ED%8A%B8%EB%A3%A8%EC%9D%B4%EC%8A%A433.jpg?type=w800"  width="400px" height="auto"></a></div></div>',
        },
        // 모리타니
        {
            coords:{lat:18.0735299, lng:-15.9582372},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>모리타니-누악쇼트</h1>누악쇼트는 모리타니의 수도이며 사하라 사막최대의 도시이다. 누악쇼트란 말은 "거센 바람이 부는 곳"이란 뜻이다. 대서양 기슭에 위치해 있으며 인구는 1999년 추계로 881,000명이다. <br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://t1.daumcdn.net/cfile/blog/235506465594380D17"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:20.5072923, lng:-13.052978},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>모리타니-아타르</h1>아타르는 모리타니 북서부에 위치한 도시로, 아드라르 주의 주도이며 인구는 24,021명이다. 시내에는 공항과 박물관, 1674년에 건설된 역사적인 모스크가 있다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://upload.wikimedia.org/wikipedia/commons/thumb/f/f9/Aerial_view_of_Atar%2C_Mauritania%2C_1967-1.jpg/400px-Aerial_view_of_Atar%2C_Mauritania%2C_1967-1.jpg"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:16.6143698, lng:-7.2598913},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>모리타니-네마</h1>네마는 모리타니 남동부에 위치한 도시로, 호드에슈샤르기 주의 주도이다. 도시 지역의 인구는 5~6만 명 정도로 추산되며 교외 지역의 인구는 약 20만 명 정도로 추산된다. <br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://ncc-phinf.pstatic.net/20130411_1/jinsuk1127_13656633323527t2KI_JPEG/001.jpg?type=w646"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:16.639487, lng:-11.3830551},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>모리타니-키파</h1>키파는 모리타니 중남부에 위치한 도시로, 아사바 주의 주도이다. <br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://t1.daumcdn.net/cfile/tistory/176E34024BB323F57D"  width="400px" height="auto"></a></div></div>',
        },
        // 모잠비크
        {
            coords:{lat:-25.969248, lng:32.5731746},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>모잠비크-마푸투</h1>마푸투는 모잠비크의 수도이다. 포르투갈의 전직 축구 선수 에우제비우가 태어난 곳으로 유명하다. 옛날에는 로렌수마르케스라고 불렀다. 인도양에 위치한 항만이며, 그곳의 경제는 항구에 집중되어 있다. <br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://cdn.crowdpic.net/detail-thumb/thumb_d_0250317EB2CE076C3A7E2F3F6D384B46.jpg"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:-15.1266347, lng:39.2687161},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>모잠비크-남풀라</h1>남풀라는 모잠비크 남풀라 주의 주도로, 인구는 471,717명이다. 마푸투와 베이라에 이어 모잠비크에서 세 번째로 큰 도시이며 모잠비크 북부 지방의 중심 도시이다. <br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTWdyYFA5YzZb94ucaxajpwoLHu5kBLEnsu1lm2gksW_WidYaM4yV28ZC6PgpLXzLqBtxA&usqp=CAU"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:-17.8502636, lng:36.9218584},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>모잠비크-켈리마느</h1>켈리마느는 모잠비크 중부에 위치한 항구 도시로, 잠베지아 주의 주도이며 인구는 192,876명이다. 도시 이름은 "농사를 짓는다"라는 뜻을 가진 단어인 "쿨리아마니"에서 유래된 이름이다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTtDh7t3if82Qj7U_uZtMZhDGdGEG_m84b6fA&usqp=CAU"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:-19.8315949, lng:34.8370183},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>모잠비크-베이라</h1>베이라는 모잠비크 중부에 위치한 도시로, 소팔라 주의 주도이며 인구는 436,240명이다. 모잠비크에서 두 번째로 큰 도시이며 모잠비크 해협과 접한다. 짐바브웨와 말라위, 잠비아를 연결하는 도로와 철도가 기나간다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://ko.theworldmarch.org/wp-content/uploads/2019/06/mozambique-2.jpg"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:-16.1328104, lng:33.6063855},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>모잠비크-테트</h1>테트는 모잠비크 서부에 위치한 도시로, 테트 주의 주도이다. 또한 테트의 인구는 2008년 기준으로 155,870명이다. 또한 테트는 잠베지 강과 접하며, 도시의 이름은 "갈대"를 뜻한다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS4AyWFw8YBloi5P6bqJQYNtZAzRxCtBkHQPHLX3uu3xB0kp2V_2DZYPb06pkZNeOkEORI&usqp=CAU"  width="400px" height="auto"></a></div></div>',
        },
        // 몬테네그로
        {
            coords:{lat:42.4304196, lng:19.2593642},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>몬테네그로-포드고리차</h1>포드고리차는 몬테네그로의 수도이다. 1326년 이전에는 리브니차, 1945년부터 1991년까지는 요시프 브로즈 티토의 이름을 따서 티토그라드라고 불렀다. 도시의 이름은 세르비아어로 "고리차" 아래라는 뜻이다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://eb.findmybucketlist.com/bucket/new/cp/3424425_cp_00.jpg?update_date=2019-10-2516:35:07"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:43.1555152, lng:19.1226018},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>몬테네그로-자블라크</h1>자블라크는 몬테네그로 북부에 위치한 도시로, 면적은 445km², 도시 인구는 1,937명, 인구밀도는 9명/km², 지방 자치체 인구는 4,204명이며 두르미토르 국립공원에 위치한다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://mblogthumb-phinf.pstatic.net/MjAxNzA0MTJfMjAz/MDAxNDkxOTk2OTYwMTg2.fUZeoTgPoPlMetEM66XwYxkaE3PcY-xHV0DtlExj7eMg.dVPAY8uLCovM9SlhatIu-qP0QYS0HZxBz1Bo4IKwKakg.JPEG.lsh5755/LSH_9332.jpg?type=w2"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:42.83793439999999, lng:19.8603732},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>몬테네그로-베라네</h1>베라네는 몬테네그로 북동부에 위치한 도시로, 면적은 717km², 도시 인구는 11,776명, 인구밀도는 49명/km², 지방 자치체 인구는 35,068명이다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://ak-d.tripcdn.com/images/02227120008xjgxoq2C9D_Z_550_412_R5_Q70_D.jpg"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:43.0369422, lng:19.7561911},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>몬테네그로-비옐로폴레</h1>비옐로폴레는 몬테네그로 북부에 위치한 도시로, 면적은 924 km², 높이는 578m, 도시 인구는 15,883명, 인구밀도는 54명/km², 지방 자치체 인구는 50,284명이다. 도시 이름은 세르보크로아트어로 "하얀 들판"을 뜻한다. <br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://upload.wikimedia.org/wikipedia/commons/thumb/2/26/20090719_Crkva_Gospa_od_Zdravlja_Kotor_Bay_Montenegro.jpg/500px-20090719_Crkva_Gospa_od_Zdravlja_Kotor_Bay_Montenegro.jpg"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:42.8204751, lng:19.5240814},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>몬테네그로-콜라신</h1>콜라신는 몬테네그로 북부에 위치한 도시로, 면적은 897km², 도시 인구는 2,989명, 인구밀도는 11명/km², 지방 자치체 인구는 9,949명이다. <br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTG7iM4Z9M8p0cPC-Cj6DU4h_jIRW8j6gH6xxWwVWB6w3UV0RxXVAU_UtdvnAKliplyBog&usqp=CAU"  width="400px" height="auto"></a></div></div>',
        },
        // 몰도바
        {
            coords:{lat:47.0104529, lng:28.8638103},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>몰도바-키시나우</h1>키시너우는 몰도바의 수도로 인구는 92만이다. 러시아어 이름인 키시뇨프로 잘 알려져 있다. 드니스테르강의 지류인 브크강가에 자리잡고 있으며 산업과 서비스업의 중심지이다. 기계제조, 식료품, 담배 등의 공업이 있고, 학술·문화의 중심지이다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://dynamic-media-cdn.tripadvisor.com/media/photo-o/0a/a6/1a/0a/triumphal-arch.jpg?w=700&h=-1&s=1"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:46.84818500000001, lng:29.596805},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>몰도바-티라스폴</h1>티라스폴은 트란스니스트리아에 있는 도시이다. 드니스테르 강 동쪽에 위치하며, 1992년 이래 몰도바로부터 독립을 선언한 트란스니스트리아의 수도이다. 인구는 16만 2000명이다. 드네스트르 강의 동쪽에 있으며, 가구 및 전기제품 등 경공업의 중심지이다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://img.freepik.com/premium-photo/tiraspol-moldova-06-09-2021-bridge-over-the-dniester-river-in-tiraspol-transnistria-or-moldova-on-a-sunny-summer-day_3510-2274.jpg"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:47.766088, lng:27.9165581},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>몰도바-발티</h1>벌치는 몰도바에 있는 도시이다. 지역과 경제적인 중요성이라는 점에서 키시너우 다음으로 두 번째로 크며, 인구라는 점에서 키시너우와 티라스폴 다음으로 세 번째로 큰 도시이다. <br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://storage.doopedia.co.kr/upload/_upload/image5/2103/27/210327023764116/210327023764116_thumb_400.jpg"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:46.82275509999999, lng:29.4620101},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>몰도바-벤데르</h1>벤데르 또는 벤데리는 트란스니스트리아에 위치해 있는 도시이다. 또한 벤대르의 인구는 2010년 기준으로 93,751명이다. 벤데르의 주민으로는 러시아인, 몰도바인, 우크라이나인을 비롯한 여러 민족이 있다. <br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://storage.doopedia.co.kr/upload/_upload/image5/2103/27/210327023764584/210327023764584_thumb_400.jpg"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:47.38604, lng:28.8303082},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>몰도바-오르헤이</h1>오르헤이는 몰도바의 도시로, 오르헤이 구의 행정 중심지이며 면적은 8.5km², 인구는 33,500명, 인구 밀도는 3,941.2명/km²이다. 수도 키시너우에서 북쪽으로 약 50km 정도 떨어진 곳에 위치한다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://cdn.pixabay.com/photo/2013/06/14/19/26/moldova-139367_960_720.jpg"  width="400px" height="auto"></a></div></div>',
        },
        // 몰디브
        {
            coords:{lat:3.202778, lng:73.22068},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>몰디브-몰디브</h1>몰디브 공화국, 약칭 몰디브은 남아시아 인도양에 있는 섬나라로, 인도와 스리랑카 남서쪽에 있다. 국토는 남북으로 길게 늘어선 26개의 환초로 이루어져 있으며, 섬의 총수는 1,192개이다. 수도인 말레는 군주제 시절에 술탄이 왕궁을 짓고 다스리던 곳이다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://youimg1.tripcdn.com/target/100k1f000001gui9o94D8_C_640_320_R5_Q70.jpg_.webp?proc=source%2Ftrip"  width="400px" height="auto"></a></div></div>',
        },
        // 몰타
        {
            coords:{lat:35.937496, lng:14.375416},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>몰타-몰타</h1>몰타 공화국은 남유럽에 위치한 섬나라로 수도는 발레타이다. 공용어로 몰타어와 영어를 사용하며, 주민의 대다수는 셈어족에 속하는 몰타인이다. <br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://t1.daumcdn.net/cfile/tistory/99BA263B5D2CC54F03"  width="400px" height="auto"></a></div></div>',
        },
        // 몽골
        {
            coords:{lat:47.88639879999999, lng:106.9057439},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>몽골-울란바토르</h1>울란바토르는 몽골의 수도이다. 도시 명칭의 뜻은 몽골어로 "붉은 영웅"이란 뜻이다. "울란바토르"라는 표기는 몽골어가 아닌 러시아어의 독법에서 유래했다. 면적은 4,704.4 km², 인구는 137만 2000여 명이다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="http://www.traveldaily.co.kr/news/photo/201901/18598_25400_5915.jpg"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:50.3492922, lng:106.4820081},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>몽골-카흐타</h1>캬흐타(러시아어: Кяхта, 몽골어: Хиагт, 중국어 간체자: 恰克图, 정체자: 恰克圖, 병음: Qiàkètú, 부랴트어: Хяагта)는 부랴트 공화국에 있는 도시이름이다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR0cCWx0s_WIVoA8joAVUxMfIo2VHeiGt9e8Q&usqp=CAU"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:49.6428895, lng:100.1771896},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>몽골-므릉</h1>무룽은 몽골 북부에 위치한 도시로 후브스굴 주의 주도이며 인구는 35,789명이다. 도시 이름은 몽골어로 "강"을 뜻한다. 무룽 공항을 통해 울란바토르를 연결하는 정기 항공 노선이 운행한다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://mblogthumb-phinf.pstatic.net/MjAyMTA2MjZfMjg5/MDAxNjI0NjkzMjY4NzM0.WLoZtMm97HUBqlqvlPWuKzwpgsxU_zqYCxp5PtH9qNMg.qh9mAcvxCSBSZmft2S-8B80EeAa-S63EDfq4JheJxNIg.JPEG.dsboo/D710465E-F844-452A-BA0A-94F3140772F6.jpg?type=w800"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:46.177215, lng:100.7118653},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>몽골-바양홍고르</h1>바잉헝거르는 몽골 바잉헝거르 주의 주도로 면적은 64km², 인구는 26,252명이다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://storage.doopedia.co.kr/upload/_upload/image4/newimage/20171031164826_ribizhic.jpg"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:48.8231572, lng:103.5218199},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>몽골-볼강</h1>볼간은 몽골 볼간 주의 주도로 면적은 99.95km², 인구는 18,494명이다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://t1.daumcdn.net/cfile/tistory/150178244B9659D931"  width="400px" height="auto"></a></div></div>',
        },
        // 미국
        {
            coords:{lat:40.7127753, lng:-74.0059728},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>미국-뉴욕</h1>뉴욕은 미합중국의 북동부, 뉴욕주의 남쪽 끝에 있는 도시이다. 또한 미합중국에서 가장 인구가 많은 도시로, 전 세계에서 가장 인구가 많은 도시 중 하나이며, 미합중국의 최대 도시이다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://t1.daumcdn.net/cfile/tistory/99A789435A7FD5720B"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:29.7604267, lng:-95.3698028},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>미국-휴스턴</h1>휴스턴 시은 미국 텍사스주의 가장 큰 도시이며, 미국 전체에서는 4번째로 많은 인구가 사는 도시이다. 2016년 기준으로 인구는 약 230만 명으로 추산되며, 면적은 2010년을 기준으로 1,552.9 km²이다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://www.gousa.or.kr/sites/default/files/styles/16_9_1280x720/public/2016-10/0%20HERO_HoustonTX_GettyImages-532390052_0.jpg?h=c5520b1b&itok=QYZzO_gS"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:41.8781136, lng:-87.6297982},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>미국-시카고</h1>시카고 시는 뉴욕, 로스앤젤레스에 이어 미국에서 3번째로 큰 도시이며, 일리노이주 및 미국 중서부에서 가장 큰 도시로 그 인구는 270만 명이다. <br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://cloudfront-ap-northeast-1.images.arcpublishing.com/chosunbiz/YSZ4XB7WHL3ENMJPGBJAZVMA3M.png"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:47.6062095, lng:-122.3320708},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>미국-시애틀</h1>시애틀은 미국 워싱턴주 킹 군의 군청 소재지로 해안 항구 도시이다. 북미 태평양 북서부와 미국 워싱턴 주에서 가장 큰 도시로 2020년 기준 737,015명의 인구가 거주하고 있으며, 미국에서 가장 빠르게 인구가 증가하고 있는 대도시이다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://post-phinf.pstatic.net/MjAxOTA4MjdfMTE2/MDAxNTY2ODc4NTM1MTI3.t2v2BCOumxl1AUfevExRDFtCzQ7nasvUmFEtJfmMElog.fK67P3SAN7_zr_rxQmQaCn9a9dFZJhTugeZe6D_gCo4g.JPEG/%EC%8B%9C%EC%95%A0%ED%8B%80_%EC%9E%90%EC%9C%A0%EC%97%AC%ED%96%89_%EC%9D%BC%EC%A0%95_01.jpg?type=w1200"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:34.0522342, lng:-118.2436849},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>미국-로스엔젤레스</h1>로스앤젤레스는 미국 캘리포니아주의 남부에 위치한 대도시로, 면적은 1290.6 km²에 달한다. 2010년 미국 인구조사를 기준으로 3,792,621 명의 인구 가 거주하고 있어 캘리포니아주에서 가장 인구가 많은 도시이자, 미국 전체에서는 뉴욕에 이어 두 번째로 인구가 가장 많다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://mblogthumb-phinf.pstatic.net/MjAxOTA3MDZfMjIw/MDAxNTYyNDE4MjgwOTMz.56WUOudtR_qI5eVHfBHiK1-vRhTx_EbM313OYozTwuQg.BGXwb_auPiNZDDukNy4NvTpGZV-pcSBEhs6B47_C2cQg.JPEG.jrkimceo/Los_Angeles,_Winter.jpg?type=w800"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:32.715738, lng:-117.1610838},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>미국-샌디에고</h1>샌디에고 또는 샌디에이고는 미국 캘리포니아주 남부의 도시이다. 이름은 스페인어로 성 디다쿠스라는 뜻이다. 2016년 기준으로 인구는 1,406,630 명으로 추정되어, 캘리포니아주에서는 두 번째, 미국에서는 여덟 번째로 큰 도시이다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://media.istockphoto.com/photos/aerial-view-of-mission-bay-beaches-in-san-diego-california-usa-picture-id1139605891"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:36.171563, lng:-115.1391009},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>미국-라스베이거스</h1>라스베이거스 또는 라스베가스는 미국 남서부 사우스웨스트 네바다주 남부 사막 가운데에 있는 도시이자 최대 도시이다. 클라크군에 위치해 있다. 세계적으로 잘 알려진 카지노가 많은 관광과 도박의 도시이며, 결혼과 이혼 수속이 간단한 곳으로도 잘 알려져 있다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://t1.daumcdn.net/cfile/tistory/25714E46556BDD262C"  width="400px" height="auto"></a></div></div>',
        },
        // 미얀마
        {
            coords:{lat:21.9588282, lng:96.0891032},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>미얀마-만달레이</h1>만달레이는 미얀마 중부의 도시로, 만달레이도의 도청 소재지이다. 미얀마의 마지막 왕조인 꾼바웅 왕조의 수도였던 역사가 있는 미얀마의 전통적인 제2도시이다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://t1.daumcdn.net/cfile/tistory/243C7A3C5692F8CE15"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:19.7633057, lng:96.07851040000001},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>미얀마-네피도</h1>네피도는 미얀마의 수도이다. 2005년 11월 6일 미얀마의 행정 수도로 이전되었다. 삔머나에서 서쪽으로 3.2km, 옛 수도인 얀군에서 북쪽으로 320km 떨어진 곳에 위치한다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://dynamic-media-cdn.tripadvisor.com/media/photo-o/09/62/7c/68/20151029-175521-largejpg.jpg?w=700&h=500&s=1"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:17.3220711, lng:96.4663286},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>미얀마-바고</h1>베쿠 는 미얀마의 베쿠도의 수도이다. 양곤에서 80km 떨어져 있고 인구는 22만 명이다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://dynamic-media-cdn.tripadvisor.com/media/photo-o/09/b1/ed/42/kambazathadi-golden-palace.jpg?w=700&h=500&s=1"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:16.840939, lng:96.173526},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>미얀마-양곤</h1>양곤은 미얀마에서 가장 큰 도시이자 옛 수도이며 양곤 구의 주도이다. 원래의 이름은 랑군이었으나 국호를 버마에서 미얀마로 바꾸면서 랑군의 명칭을 양곤으로 바꾸었다. 도시의 이름은 전쟁의 끝 또는 평화라는 의미이다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="http://img.khan.co.kr/lady/2022/06/27/l_2022062704000033400277301.jpg"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:16.4543173, lng:97.64396110000001},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>미얀마-모울메인</h1>멀라먀잉 또는 멋멀름 은 미얀마에서 3번째로 큰 도시로, 양곤에서 남동쪽으로 300km, 따통에서 남쪽으로 70km 떨어진 딴륀강 하구에 위치한다. 인구는 약 30만 명으로 몬주에서 가장 큰 도시이며 미얀마 남동부의 주요 교역 중심지이자 항구이다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://t1.daumcdn.net/cfile/tistory/99A40F3C5E51E7EF34"  width="400px" height="auto"></a></div></div>',
        },
        // 미크로네시아 연방
        {
            coords:{lat:7.425554, lng:150.550812},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>미크로네시아연방-미크로네시아연방</h1>미크로네시아 연방 또는 미크로네시아는 오세아니아의 미크로네시아 캐롤라인 제도에 있는 국가이다. 북쪽으로는 북마리아나 제도, 동쪽으로는 마셜 제도, 서쪽으로는 팔라우, 그리고 남쪽으로는 파푸아뉴기니가 존재한다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="http://pds.joongang.co.kr/news/component/htmlphoto_mmdata/201203/22/htm_20120322120431075.jpg"  width="400px" height="auto"></a></div></div>',
        },
        // 바누아투
        {
            coords:{lat:-15.376706, lng:166.959158},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>바누아투-바누아투</h1>바누아투 공화국 혹은 바누아투는 오세아니아의 멜라네시아에 있는 국가이다. 공화제를 채택하였으며 수도는 포트빌라이다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://t1.daumcdn.net/cfile/tistory/99A224485B40106E36"  width="400px" height="auto"></a></div></div>',
        },
        // 바레인
        {
            coords:{lat:26.2235305, lng:50.5875935},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>바레인-마나마</h1>마나마는 1932년 무하라크에서 바뀌어 바레인의 수도로 지정되었으며 페르시아 만에 위치해 있고, 바레인 섬에서 북동쪽에 있다. 도시의 어원은 "휴식의 장소" 또는 "꿈의 장소"라는 의미의 아랍어에서 유래되었다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://dynamic-media-cdn.tripadvisor.com/media/photo-o/15/33/fb/8b/manama.jpg?w=700&h=500&s=1"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:26.1323123, lng:50.5406926},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>바레인-리파</h1>리파는 바레인에서 두 번째로 큰 도시로 인구는 121,566명이다. 도시는 동리파와 서리파로 나뉜다. 도시의 대부분 지역이 중부주에 위치하고 있고 소수 지역이 남부주에 위치한다. 주민의 대부분은 수니파 무슬림이다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://q-xx.bstatic.com/xdata/images/hotel/max1024x768/132138614.jpg?k=1a85e0fd48962e8b1a12043ae83b366287aa2a9aee9791d6066acf61f2609968&o="  width="400px" height="auto"></a></div></div>',
        },
        // 바베이도스
        {
            coords:{lat:13.1059816, lng:-59.61317409999999},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>바베이도스-브리지타운</h1>브리지타운은 바베이도스의 수도이다. 행정 구역상으로는 세인트마이클 교구에 속한다. 1628년에 영국에 의해 건설되어 현재는 관광지의 역할을 주로 하고 있다. 인구는 110,000명이다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://i.ytimg.com/vi/x8ZadA-enQU/maxresdefault.jpg"  width="400px" height="auto"></a></div></div>',
        },
        // 바티칸
        {
            coords:{lat:41.902916, lng:12.453389},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>바티칸-바티칸</h1>바티칸 시국은 이탈리아의 로마 시내에 위치하고 있으며, 국경 역할을 하는 장벽으로 둘러싸인 영역으로 이루어져 있는 내륙국이자 도시국가이다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://youimg1.tripcdn.com/target/fd/tg/g2/M02/89/4C/CghzgFWwvbmASh1HAD9zaM_TB5c256_C_640_320_R5_Q70.jpg_.webp?proc=source%2Ftrip"  width="400px" height="auto"></a></div></div>',
        },
        // 바하마
        {
            coords:{lat:25.0401387, lng:-77.3512619},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>바하마-나사우</h1>나소는 바하마의 수도이다. 인구는 26만5,924명이다. 바하마의 주요 공항인 린든 핀들링 국제공항이 나소 중심지에서 서쪽으로 16km 떨어진 곳에 위치해 있다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://q-xx.bstatic.com/xdata/images/hotel/max700/229533928.jpg?k=8e044fdc92881803a1df2a0a8244deb2053a600000f8f9959252142c315bd891&o="  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:24.7048435, lng:-77.7852575},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>바하마-안드로스타운</h1>안드로스 타운(Andros Town)은 노스 안드로스에 있는 마을로 바하마 안드로스 섬의 주도입니다. 2010년 이 도시의 인구는 386명이었습니다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://theplanetsworld.com/caribbean/7-best-islands-in-bahamas-to-visit-that-are-under-radar-4.jpg"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:25.1230497, lng:-78.02368659999999},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>바하마-니콜스타운</h1>Nicholls Town은 바하마의 Andros 섬의 일부인 North Andros에 위치한 도시입니다. 마을에는 해변가가 있습니다. 그것은 19 세기 초 카리브해의 앵글로-아일랜드 군 지도자 인 Edward Nicolls의 이름을 따서 명명되었습니다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://mediaim.expedia.com/destination/1/305ce6727419fa6a0a35da8190891930.jpg?impolicy=fcrop&w=360&h=224&q=medium"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:23.9455592, lng:-77.5308184},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>바하마-리틀크릭세틀먼트</h1>바하마 연방, 줄여서 바하마는 북아메리카 카리브 해에 있는 섬나라이다. 영어가 공용어이며, 29개의 주요 섬과 661개의 작은 섬, 2,389개의 암초로 이루어져 있다. 총 면적은 14,000 km²이며, 인구는 33만 명이다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS3SfYorH3JC2xpnSiRW76J5qa7EZJ1CGj1sm5b-8uQIhLjFPWlYEGDxIZTpl3EDVU_JYE&usqp=CAU"  width="400px" height="auto"></a></div></div>',
        },
        // 방글라데시
        {
            coords:{lat:23.810332, lng:90.4125181},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>방글라데시-다카</h1>다카는 방글라데시의 수도이자, 방글라데시 최대의 도시이다. 2001년 인구는 903만 2268명이고, 방글라데시 중앙부에 위치한다. 방글라데시의 상업·공업의 중심지이고, 황마·면 가공이나 식품 가공 등의 제조업이 발달해 있다. <br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://t1.daumcdn.net/cfile/tistory/9967F14E5C8773F407"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:23.831457, lng:91.2867777},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>방글라데시-아가르탈라</h1>아가르탈라는 인도 서부 트리푸라 주의 주도로, 인구는 367,822명, 면적은 58.84km²이며 인구밀도는 6,251명/km², 높이는 해발 12.8m이다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://cdn.travie.com/news/photo/202110/21993_12306_038.jpg"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:22.845641, lng:89.5403279},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>방글라데시-쿨나</h1>쿨나는 방글라데시의 도시로, 쿨나주의 주도이며 인구는 약 140만 명이다. 방글라데시에서 세 번째로 큰 도시이며 다카에서 남서쪽으로 약 333km 정도 떨어진 곳에 위치한다. 상공업이 발달한 도시이다. <br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://youimg1.tripcdn.com/target/0ww5i120006pj21rgFCC7_C_640_320_R5_Q70.jpg_.webp"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:24.848078, lng:89.3729633},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>방글라데시-보그라</h1>공식적으로 Bogura로 알려진 Bogra는 방글라데시 Rajshahi Division의 Bogra 지구에 위치한 주요 도시입니다. 이 도시는 방글라데시 북부의 주요 상업 중심지입니다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://youimg1.tripcdn.com/target/0ww5n1200090e6sjh333E_C_640_320_R5_Q70.jpg_.webp"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:22.356851, lng:91.7831819},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>방글라데시-치타공</h1>치타공, 공식적으로는 차토그람은 방글라데시 남동부에 위치한 도시로 치타공주의 주도이다. 벵골만에서 카르나풀리 강을 약간 거슬러 올라간 곳에 있는 항만 도시이다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://storage.doopedia.co.kr/upload/_upload/comm/travelworld/200806/24/400_121428902382560.jpg"  width="400px" height="auto"></a></div></div>',
        },
        // 베네수엘라
        {
            coords:{lat:10.642707, lng:-71.6125366},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>베네수엘라-마라카이보</h1>마라카이보는 베네수엘라에서 두 번째로 큰 도시로, 술리아 주의 주도다. 1990년 인구는 265만명이었고 2007년 추정 인구는 320만명이다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://post-phinf.pstatic.net/MjAyMDA3MDhfNDAg/MDAxNTk0MTc0MzkzNDYz.iTGA2QbN-MXizkUEzARnjqrbkKYN1Tyxqm_Ap935Dz4g.jeNoHJImBWre_wdRdRkXHlgGb9CeHvYM-g7-WHtYfCog.JPEG/01.jpg?type=w1200"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:10.4805937, lng:-66.90360629999999},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>베네수엘라-카라카스</h1>카라카스는 베네수엘라의 수도이다. 베네수엘라의 북해안에 있다. 2005년 현재 인구는 327만 6000명이다. 리베르타도르 시와 미란다 주의 차카오, 수크레, 바르타, 엘아티요를 합쳐서 말하지만, 리베르타도르 시만을 가리켜서 카라카스라고 말하기도 한다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://dynamic-media-cdn.tripadvisor.com/media/photo-o/15/33/fe/d4/caracas.jpg?w=700&h=500&s=1"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:10.0677719, lng:-69.3473509},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>베네수엘라-바르키시메토</h1>바르키시메토는 베네수엘라 라라 주의 주도로, 인구는 2,000,000명이다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://dynamic-media-cdn.tripadvisor.com/media/photo-o/09/13/32/db/catedral-de-barquisimeto.jpg?w=700&h=500&s=1"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:10.1579312, lng:-67.9972104},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>베네수엘라-발렌시아</h1>발렌시아는 베네수엘라 중북부 카라보보 주의 주도이다. 해안 산맥으로 둘러싸인 골짜기에 위치하고 있다. 베네수엘라 제3의 도시로, 상공업의 중심지이다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://dynamic-media-cdn.tripadvisor.com/media/photo-o/07/9a/ac/b4/visto-desde-la-torre.jpg?w=700&h=500&s=1"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:8.088279100000001, lng:-63.5535552},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>베네수엘라-시우다드볼리바르</h1>시우다드볼리바르는 베네수엘라 볼리바르 주의 주도로, 인구는 350,691명이다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://dynamic-media-cdn.tripadvisor.com/media/photo-o/0e/7e/ef/d3/going-up-the-walls-of.jpg?w=500&h=300&s=1"  width="400px" height="auto"></a></div></div>',
        },
        // 베냉
        {
            coords:{lat:6.4968574, lng:2.6288523},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>베냉-포르토노보</h1>포르토노보는 베냉의 헌법상의 수도이다. 베넹 국토의 남동쪽, 기니 만 연안에 위치해 있다. 주요 생산품은 팜유, 면화, 양목면 등이다. 1990년대에 유전이 발견되었으며, 점점 중요한 수출 품목이 되고 있다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://eb.findmybucketlist.com/bucket/new/cp/3424690_cp_00.jpg?update_date=2019-08-1921:50:23"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:9.3466822, lng:2.6090043},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>베냉-파라쿠</h1>파라쿠는 베냉 북부에 위치한 도시로, 보르구 주의 주도이며 높이는 324m, 인구는 188,853명이다. 코토누까지를 연결하는 철도가 지나간다. 주요 산업은 땅콩 기름 제조업이다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://a.travel-assets.com/findyours-php/viewfinder/images/res70/267000/267397-Abomey.jpg?impolicy=fcrop&w=360&h=224&q=mediumLow"  width="400px" height="auto"></a></div></div>',
        },
        // 베트남
        {
            coords:{lat:21.0277644, lng:105.8341598},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>베트남-하노이</h1>하노이는 베트남의 수도다. 역대 왕조가 왕도를 정했던 도시로, 홍강 삼각주, 홍강 오른쪽 편에 위치한다. 베트남 최대의 도시인 호치민에서는 북쪽으로 1,720km, 항구도시 하이퐁에서 서쪽으로 105km 떨어져 있다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="http://image14.hanatour.com/uploads/2019/12/DSC_0455_18164565.jpg"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:20.8449115, lng:106.6880841},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>베트남-하이퐁</h1>하이퐁은 베트남 북부의 항구도시이며, 공업도시이다. 하이퐁은 다섯 중앙직할시 중 하나이며, 다낭, 껀터와 같은 국가급 중심도시이다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://cdn-asia.heykorean.com/community/uploads/images/2020/04/1586184938.jpg"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:16.4637117, lng:107.5908628},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>베트남-후에</h1>후에시는 베트남 중부에 위치한 도시로 트어티엔후에성의 성도이다. 1802년부터 1945년까지는 베트남의 수도였다. 많은 역사적 기념물과 건축물들을 보유하고 있으며, 이 도시에 있는 후에 성은 유네스코 세계문화유산으로 등록되어 있다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://dynamic-media-cdn.tripadvisor.com/media/photo-o/0f/b4/dd/eb/hue-imperial-city-citadel.jpg?w=700&h=500&s=1"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:16.0544563, lng:108.0717219},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>베트남-다낭</h1>다낭은 베트남 남중부 지방의 최대 상업 및 항구도시이자 베트남의 다섯 개의 직할시 중 하나이고, 베트남에서 호찌민시, 하노이, 하이퐁 다음으로 네 번째 큰 도시이다. <br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://image.ajunews.com/content/image/2019/01/22/20190122161648145400.jpg"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:10.8230989, lng:106.6296638},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>베트남-호치민</h1>호찌민시는 베트남에서 가장 큰 도시로 사이공강과 동나이강 하류에 있다. 16세기에 베트남인에게 정복되기 전에는 쁘르이노꼬란 이름으로 캄보디아의 주요 항구였다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://res.klook.com/image/upload/c_crop,w_1841,h_1021,x_480,y_0/w_1125,h_624/w_80,x_15,y_15,g_south_west,l_Klook_water_br_trans_yhcmh3/destination/totuq6hcfaftv5lwndjd.jpg"  width="400px" height="auto"></a></div></div>',
        },
        // 벨기에
        {
            coords:{lat:50.8476424, lng:4.3571696},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>벨기에-브뤼셀</h1>브뤼셀 시은 브뤼셀의 행정 구역으로, 벨기에의 법적 수도이다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://post-phinf.pstatic.net/MjAxODA1MzFfNjcg/MDAxNTI3NzQzNTg3MTcy.vIQUzkUoy0n_LSv_Tv88I6NAgLoByNWURqVNTeejZHAg.aPuO2eHBF7mzn_9N9LXcjMuvAXL1S2ce1_UPZU_L_70g.JPEG/%EB%B8%8C%EB%A4%BC%EC%85%80_%EC%97%AC%ED%96%89_%EA%B7%B8%EB%9E%91%ED%94%8C%EB%9D%BC%EC%8A%A42.jpg?type=w1200"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:51.0500182, lng:3.7303351},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>벨기에-헨트</h1>헨트는 벨기에 오스트플란데런주의 주도이자 가장 큰 도시로 플랑드르에 있는 지방 자치체다. 면적은 156.18km²이며 인구는 2020년 1월 1일 현재 263,614명으로 인구밀도는 1,689명이다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="http://d3b39vpyptsv01.cloudfront.net/photo/1/2/81ea09fa315e412173921feb9fda18fe_l.jpg"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:50.45466340000001, lng:3.952313499999999},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>벨기에-몽스</h1>몽스는 벨기에 왈롱 지역의 도시로, 에노주의 주도이다. 면적은 146.56km2, 인구는 95,568명, 인구 밀도는 652명/km2이다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://dynamic-media-cdn.tripadvisor.com/media/photo-o/10/50/2e/49/hotel-de-ville.jpg?w=700&h=-1&s=1"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:50.63295859999999, lng:5.569749799999999},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>벨기에-리에주</h1>리에주는 벨기에 동부 왈롱 지방에 위치한 도시로 리에주주의 주도이며 면적은 69.39km², 인구는 197,355명, 인구 밀도는 2,800명/km²이다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://dynamic-media-cdn.tripadvisor.com/media/photo-o/15/33/f9/39/liege.jpg?w=700&h=500&s=1"  width="400px" height="auto"></a></div></div>',
        },
        // 벨라루스
        {
            coords:{lat:53.9006011, lng:27.558972},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>벨라루스-민스크</h1>민스크는 벨라루스의 수도이다. 기계 제조, 모직물 등의 공업도시로 교통의 요지이기도 하다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://dynamic-media-cdn.tripadvisor.com/media/photo-o/15/4d/45/97/minsk.jpg?w=700&h=500&s=1"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:53.8980663, lng:30.3325337},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>벨라루스-모길료프</h1>마힐료우는 벨라루스 동부에 위치한 도시로, 마힐료우 주의 주도이며 드네프르 강과 접한다. 벨라루스에서 세 번째로 큰 도시이다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://overseas.mofa.go.kr/upload/se2/20ce95f8-f0e4-4f7d-a262-3660a205dd53.jpg"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:55.1926809, lng:30.206359},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>벨라루스-비테프스크</h1>비쳅스크는 벨라루스의 도시이다. 러시아 및 라트비아와의 국경에 가깝다. 비쳅스크 주의 주도로 인구는 342,381명이다. <br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://www.100ssd.co.kr/news/photo/202201/84288_64394_4729.jpg"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:52.428643, lng:31.0045409},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>벨라루스-고멜</h1>호멜은 벨라루스의 남동부에 위치하는 도시로 호멜 주의 주도이다. 인구에서는 벨라루스에서 2번째로 많은 도시이다. 면적은 113km²이다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://cdn.pixabay.com/photo/2018/04/25/22/43/gomel-3350788__480.jpg"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:52.0996507, lng:23.7636662},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>벨라루스-브레스트</h1>브레스트는 벨라루스의 도시로, 브레스트 주의 주도이다. 소련의 제일 서쪽 끝에 있는 도시 중의 하나였다. 제2차 세계 대전 이전에는 폴란드의 도시였다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://overseas.mofa.go.kr/upload/se2/5c5ef58a-81a8-465b-87bc-a787b239fee4.jpg"  width="400px" height="auto"></a></div></div>',
        },
        // 벨리즈
        {
            coords:{lat:17.2510114, lng:-88.7590201},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>벨리즈-벨모판</h1>벨모판은 중앙아메리카에 있는 벨리즈의 수도이다. 인구는 약 16,000명이다. 벨리즈 강의 동쪽에 위치하며, 옛 수도 벨리즈시티에서 내륙 쪽으로 80km 정도 떨어진 곳에 있다. 행정 구역상으로는 카요 구에 속한다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://dynamic-media-cdn.tripadvisor.com/media/photo-o/05/48/e7/00/blue-hole-national-park.jpg?w=700&h=500&s=1"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:17.5045661, lng:-88.1962133},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>벨리즈-벨리즈시티</h1>벨리즈시티는 중앙아메리카의 벨리즈에 있는 도시이다. 벨리즈 구의 행정 중심지이며, 벨리즈 최대의 도시이다. 벨리즈 시의 인구는 비공식적으로는 7만 800명 이상이다. 카리브 해 연안에 위치해 있으며, 벨리즈 강 하구에 접해 있다. <br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://dynamic-media-cdn.tripadvisor.com/media/photo-o/16/b5/59/af/photo5jpg.jpg?w=500&h=300&s=1"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:16.0945498, lng:-88.7981781},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>벨리즈-푼타고르다</h1>벨리즈는 중앙아메리카의 유카탄 반도 남쪽에 위치하며, 카리브 해에 접해 있는 독립국이다. 북쪽으로는 멕시코, 서쪽으로는 과테말라와 국경을 접하고 있으며, 남동쪽으로는 온두라스 만을 사이에 두고 온두라스와 접한다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="http://www.opinionnews.co.kr/news/photo/201809/11449_9224_5731.jpg"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:18.0842472, lng:-88.5710266},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>벨리즈-오렌지워크</h1>오렌지워크는 벨리즈에서 4번째로 큰 도시로 오렌지워크 구의 행정 중심지이며 인구는 13,708명이다. 벨리즈시티에서 북쪽으로 85km 정도 떨어진 곳에 위치한다. 사탕수수 산업이 발달했다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://media.istockphoto.com/photos/old-ancient-stone-mayan-precolumbian-civilization-pyramid-with-carved-picture-id1192327875"  width="400px" height="auto"></a></div></div>',
        },
        // 보스니아 헤르체고비나
        {
            coords:{lat:43.8562586, lng:18.4130763},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>보스니아헤르체고비나-사라예보</h1>사라예보는 보스니아 헤르체고비나의 수도이다. 인구는 2013년의 조사에 따르면 약 275,000명이다. 보스나강의 지류인 밀랴츠카강이 시내를 흐른다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://dynamic-media-cdn.tripadvisor.com/media/photo-o/21/e8/1c/d8/caption.jpg?w=700&h=-1&s=1"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:43.34377480000001, lng:17.8077578},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>보스니아헤르체고비나-모스타르</h1>모스타르는 보스니아 헤르체고비나에 있는 도시이자 자치제이며, 헤르체고비나 지역에서 가장 크고 가장 중요한 도시이다. 보스니아 헤르체고비나 연방을 구성하는 주 가운데 하나인 헤르체고비나네레트바 주의 주도이다. <br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://eb.findmybucketlist.com/city/new/cp/1216485_cp_00.jpg?update_date=2019-08-1921:27:45"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:44.2034392, lng:17.9077432},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>보스니아헤르체고비나-제니차</h1>제니차는 보스니아 헤르체고비나 중부에 위치한 공업 도시로 면적은 499.7km², 높이는 316m, 인구는 127,334명, 인구 밀도는 293명/km²이다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://media-cdn.sygictraveldata.com/media/380x254/612664395a40232133447d33247d383833343538363733"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:44.53746109999999, lng:18.6734688},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>보스니아헤르체고비나-투즐라</h1>투즐라는 보스니아 헤르체고비나 북동부에 위치한 도시로, 면적은 302km², 인구는 131,444명, 인구 밀도는 434명/km²이다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://eb.findmybucketlist.com/city/new/cp/1217070_cp_00.jpg?update_date=2022-01-1909:43:46"  width="400px" height="auto"></a></div></div>',
        },
        // 보츠와나
        {
            coords:{lat:-24.6282079, lng:25.9231471},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>보츠와나-가보로네</h1>가보로네는 아프리카 남부에 있는 보츠와나의 수도이다. 남아프리카공화국과의 접경 지대로부터 15km 떨어져 있다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://mblogthumb-phinf.pstatic.net/MjAxNzEyMzBfMTQ1/MDAxNTE0NjI2MTMzNjQ5.R3m4EhLZGCJFcKlVXBAAkEcsMkmezBrnUku7T9v31aUg.sGo2PAMmYn8BM_gnbA1HGUSkswfRneVtN66xubIbO68g.JPEG.easy_loan/1.jpg?type=w800"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat: -21.1661005, lng:27.5143603},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>보츠와나-프랜시스타운</h1>프랜시스타운은 보츠와나의 도시로, 북동부 구에 속하며 인구는 113,315명이다. 보츠와나 제2의 도시이며 가보로네에서 북쪽과 북동쪽으로 400km, 짐바브웨 접경 지대에서 90km 정도 떨어진 곳에 위치한다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://dynamic-media-cdn.tripadvisor.com/media/photo-o/15/50/f9/69/bagan-myanmar.jpg?w=600&h=400&s=1"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:-21.3190924, lng:21.2294336},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>보츠와나-그루트라에그트</h1>보츠와나 공화국, 줄여서 보츠와나는 아프리카 남부에 있는 내륙 국가이며 영연방의 구성국이다.수도는 가보로네이며, 영토의 대부분은 칼라하리 사막이기 때문에 인구가 매우 적다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://mediaim.expedia.com/destination/1/088291f281a05b304e8ab494973c89d6.jpg?impolicy=fcrop&w=400&h=225&q=mediumLow"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:-22.4036831, lng:26.7142835},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>보츠와나-세로웨</h1>세로웨는 보츠와나의 도시로, 중부 구의 행정 중심지이며 인구는 약 90,000명이다. 수도 가보로네에서 북쪽으로 350km 정도 떨어진 곳에 위치하며 토지가 비옥해 농업이 발달했다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://t1.daumcdn.net/thumb/R720x0/?fname=http://t1.daumcdn.net/brunch/service/user/zzp/image/1RFIaw8BdB-muMV1dEpHV7gfXfc.jpg"  width="400px" height="auto"></a></div></div>',
        },
        // 볼리비아
        {
            coords:{lat:-17.8145819, lng:-63.1560853},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>볼리비아-산타크루즈</h1>산타크루스데라시에라, 약칭 산타크루스는 볼리비아 동부 산타크루스 주에 있는 도시이다. 인구 1,528,683. 볼리비아 국토의 중앙부의 표고 400m 지점, 아마존 강 수계에 속하는 피라이 강 연안에 위치한다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://t1.daumcdn.net/thumb/R720x0/?fname=http://t1.daumcdn.net/brunch/service/user/xmW/image/fGclX3P4TFNkiaJjDMQhVBgpGqE.JPG"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:-17.4139766, lng:-66.1653224},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>볼리비아-코차밤바</h1>코차밤바는 볼리비아에서 3번째로 큰 도시이다. 코차밤바 주의 행정부 소재지로, 주의 서부에 위치한다. 안데스 산맥 내부에 동서로 발달한 분지 안에 있으며, 표고 약 2,600m이다. <br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://cdn.lecturernews.com/news/photo/201904/16968_39928_3240.jpg"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:-16.489689, lng:-68.11929359999999},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>볼리비아-라파스</h1>라파스는 볼리비아의 행정 수도이다. 1548년 에스파냐의 알론소 데 멘도사 선장이 건설했다. 티티카카 호수가 가까이 있고 알티플라노 고원에 위치해 평균고도가 3,600m에 달하는, 세계에서 가장 높은 곳에 있는 행정 수도다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://upload.wikimedia.org/wikipedia/commons/thumb/a/a4/La_Paz_Skyline.jpg/800px-La_Paz_Skyline.jpg"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:-19.035345, lng:-65.2592128},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>볼리비아-수크레</h1>수크레는 볼리비아의 공식 사법 수도로 대법원이 있다. 인구는 약 25만 명이다. 볼리비아 행정부는 1898년에 라파스로 이전하였다. 1991년에는 유네스코의 세계유산으로 등록되었다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://mblogthumb-phinf.pstatic.net/MjAyMDA1MTRfMTUw/MDAxNTg5NDE5ODE0Mjgz.v-z4rQnty-KpkdTl2KEZz0HrG1icvIPq6ucQeMnBqoIg.ARqsAVkRKZ0MKU6TdjQ5Ln7PkcixGhEezT0No27S9o4g.JPEG.iitmddnrii/03020027%E2%98%85-050_by_steave.JPG?type=w800"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:-14.8321487, lng:-64.9019015},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>볼리비아-트리나다드</h1>트리니다드는 볼리비아 중부에 위치한 도시로 베니 주의 주도이며 면적은 27km², 높이는 130m, 인구는 101,293명이다. <br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://dynamic-media-cdn.tripadvisor.com/media/photo-o/06/29/ed/9e/tapacare.jpg?w=600&h=400&s=1"  width="400px" height="auto"></a></div></div>',
        },
        // 부룬디
        {
            coords:{lat:-3.361378, lng:29.3598782},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>부룬디-부줌부라</h1>부줌부라는 부룬디의 최대 도시로 2014년 인구는 658,859명으로 추산된다. 도시는 탕가니카 호수의 북서쪽 끝단에 위치하며 행정, 통신 및 경제의 중심으로 2019년까지 부룬디의 수도였다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://media.istockphoto.com/photos/panoramic-view-of-bujumbura-capital-city-of-burundi-africa-picture-id1222863038"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:-3.4272755, lng:29.9246016},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>부룬디-기테가</h1>기테가는 부룬디의 수도로, 기테가 주의 주도이다. 부줌부라 다음으로 부룬디에서 두 번째로 큰 도시이다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://cdn.pixabay.com/photo/2021/12/18/09/52/burundi-6878378__480.jpg"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:-3.9754049, lng:29.4388014},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>부룬디-루몽게</h1>Rumonge는 부룬디 Rumonge Province의 수도이며 Tanganyika 호수 기슭에 있습니다. 2008 년 인구 조사는 Rumonge에서 35,931 명의 인구를 기록하여 부룬디에서 네 번째로 큰 도시입니다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://upload.wikimedia.org/wikipedia/commons/thumb/5/50/Flag_of_Burundi.svg/800px-Flag_of_Burundi.svg.png"  width="400px" height="auto"></a></div></div>',
        },
        // 부르키나파소
        {
            coords:{lat:11.1649219, lng:-4.3051542},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>부르키나파소-보보디울라소</h1>보보디울라소는 부르키나파소의 도시로, 오트바생 주의 주도이자 우에 현의 현도이다. 부르키나파소에서 2번째로 큰 도시이며 인구는 435,543명, 높이는 해발 445m이다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://storage.doopedia.co.kr/upload/_upload/image/1510/30/151030019856562/151030019856562_thumb_400.jpg"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:12.2562183, lng:-2.3517526},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>부르키나파소-쿠두구</h1>쿠두구는 부르키나파소 중서부 주 불키엠데 현에 위치한 도시이다. 부르키나파소에서 3번째로 큰 도시이며 인구는 131,825이다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://img.khan.co.kr/news/2022/03/22/l_2022032201002778100248201.jpg"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:12.5840501, lng:-1.2987349},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>부르키나파소-지니아레</h1>지니아레는 부르키나파소 중부에 위치한 도시로 플라토상트랄 주의 주도이자 우브리텡가 현의 현도이며 인구는 22,220명이다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://w.namu.la/s/6300b46f7f89102de34b94b4b3cf7a54d30eb6ffea9a9b2936116afc89051dbfecc50bb522947433a0b69c4a5aadd9ff9e6314fcdb5a44a42471c8445b7588e1deb4179c987b9e0441db069a591ae0e2dbdecbf13febc8db6c7d8dd54e00f768"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:13.5668258, lng:-2.4109908},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>부르키나파소-와이구야</h1>와이구야는 부르키나파소 북부에 위치한 도시로, 북부 주의 주도이자 야텡가 현의 현도이며 인구는 122,677명이다. 와가두구에서 북서쪽으로 182km 정도 떨어진 곳에 위치하며 부르키나파소에서 세 번째로 큰 도시이다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://image.news1.kr/system/photos/2019/5/14/3643812/article.jpg/dims/optimize"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:12.0601649, lng:0.3654204},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>부르키나파소-파다응구르마</h1>파다응구르마는 부르키나파소 동부에 위치한 도시로 동부 주의 주도이자 구르마 현의 현도이며 높이는 294m, 인구는 51,421명이다. 부르키나파소의 수도인 와가두구에서 동쪽으로 219km 정도 떨어진 곳에 위치한다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://msf.or.kr/sites/default/files/MSF301156_Medium_0.jpg"  width="400px" height="auto"></a></div></div>',
        },
        // 부탄
        {
            coords:{lat:27.4712216, lng:89.6339041},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>부탄-팀부</h1>팀부는 부탄의 수도이다. 히말라야 산맥에 있는 약 2,400m의 장소에 세워진 도시로, 근래에는 식품 공장이나 제재소도 등장했다. 공항·철도가 없지만 부탄 각지와 인도를 연결하는 도로가 있다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://cf.bstatic.com/xdata/images/hotel/max1024x768/17178578.jpg?k=b542a5547511a50aed4e70dc9ce2b713d34213e79b119b2a1f527aeca0da03df&o=&hp=1"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:27.5908052, lng:90.8841992},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>부탄-탱밸리</h1>부탄 왕국, 약칭 부탄은 남아시아 히말라야 산맥에 있는 내륙국이다. 인도와 중화인민공화국 사이에 있다. 네팔과 방글라데시에 근접해 있지만 국경을 맞닿고 있지는 않다. 인구는 754,388명, 면적은 38,394 km2이다. <br><br><div style="width:400px;height:auto;"><a href="#"><img src="http://health.chosun.com/site/data/img_dir/2017/08/23/2017082301418_0.jpg"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:27.8236356, lng:91.44346900000001},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>부탄-트라쉬양트세</h1>Trashiyangtse 또는 Tashi Yangtse는 Yangtse Gewog의 작은 도시이며 부탄 동부의 Trashiyangtse 지구의 지구 본부입니다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://mblogthumb-phinf.pstatic.net/20160414_7/mina6273_1460600428958Ss0ot_JPEG/Cloud-hidden%2C_whereabouts_unknown_%28Paro%2C_Bhutan%29.jpg?type=w800"  width="400px" height="auto"></a></div></div>',
        },
        // 북한 
        {
            coords:{lat:39.0737987, lng:125.8197642},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>북한-평양</h1>북한의 수도이자 한반도 이북 최대 도시. 북한에선 혁명의 수도라고 부르고 있다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://img4.yna.co.kr/photo/yna/YH/2018/12/30/PYH2018123006880034000_P4.jpg"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:39.9838002, lng:127.6124553},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>북한-함흥</h1>함흥시는 조선민주주의인민공화국 함경남도 동해안에 있는 도시이자 함경남도청 소재지이다. 조선민주주의인민공화국에서는 평양시, 남포시에 이어 3번째로 인구가 많은 도시이며, 동북 지방 최대 도시이다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://t1.daumcdn.net/cfile/tistory/9951D9375C6CE3C321"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:41.7669671, lng:129.723402},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>북한-청진</h1>청진시는 조선민주주의인민공화국 함경북도 동해안에 있는 시이자 함경북도청 소재지이다. 조선민주주의인민공화국에서는 평양시, 남포시, 함흥시에 이어 4번째로 인구가 많은 도시이다. <br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://img1.daumcdn.net/thumb/R800x0/?scode=mtistory2&fname=https%3A%2F%2Fblog.kakaocdn.net%2Fdn%2FsgZW6%2FbtqDZZbuIHu%2F1aM3RS2uWkkQW4YjWJg72K%2Fimg.jpg"  width="400px" height="auto"></a></div></div>',
        },
        // 북마케도니아 
        {
            coords:{lat:41.9981294, lng:21.4254355},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>북마케도니아-스코페</h1>스코페는 북마케도니아의 수도로 인구는 약 44만 명이다. 바르다르강 연안 스코페 분지에 위치한다. 교통의 요지이며 베오그라드-테살로니키 철도가 통한다. 공업 도시이며, 문화의 중심지이다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://mblogthumb-phinf.pstatic.net/MjAxOTA2MTFfMjM4/MDAxNTYwMjY1MTAyMzE4.xZvU4O0FRIBFpXBJImg71-9NgkR6XlHIJh6ObJLBRQAg.pVSxIOzBdep8wM2fUfYz27l5z4PaJoiShF515iXleggg.JPEG.sonantravel/SE-29daae36-64a3-41bc-8404-7821e3fcfe03.jpg?type=w800"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:42.0069115, lng:20.9715269},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>북마케도니아-테토보</h1>테토보는 북마케도니아 북서부에 위치한 도시로 면적은 1,068km², 높이는 468m, 인구는 86,580명, 인구 밀도는 330명/km²이다. 샤르 산맥 기슭에 위치하며 도시는 페나 강을 경계로 서로 나뉜다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://cf.bstatic.com/xdata/images/hotel/270x200/293357582.jpg?k=1e0cb6fa80604d4fa85ff94982ce345bb0e41a172c14dcfc871ab477cd946833&o="  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:41.0296773, lng:21.3292164},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>북마케도니아-비톨라</h1>비톨라는 북마케도니아 남서부에 위치한 도시로, 북마케도니아에서 스코페에 이어 두 번째로 큰 도시이다. 그리스와 국경을 접하며 북마케도니아의 행정, 문화, 산업, 상업, 교육의 중심지 역할을 한다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://www.hotelscombined.co.kr/rimg/dimg/de/1c/9a8d8026-city-56533-1725a2f793a.jpg?width=1366&height=768&xhint=1478&yhint=2065&crop=true"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:41.4378004, lng:22.6427428},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>북마케도니아-스트루미차</h1>스트루미차는 마케도니아 공화국 남동부에 위치한 도시로 면적은 233.05km², 인구는 54,676명, 인구 밀도는 234.6명/km²이다. 스트루미차 시의 행정 중심지이며 동쪽으로는 불가리아, 남쪽으로는 그리스와 국경을 접한다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://upload.wikimedia.org/wikipedia/commons/thumb/4/42/Panair_Korab.jpg/400px-Panair_Korab.jpg"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:41.91680480000001, lng:22.4082849},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>북마케도니아-코차니</h1>코차니는 마케도니아 공화국 동부에 위치한 도시로 면적은 18.6km², 높이는 350~450m, 인구는 28,330명, 인구 밀도는 1,523.1명/km²이다. 코차니 시의 행정 중심지이며 스코페에서 120km 정도 떨어진 곳에 위치한다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://upload.wikimedia.org/wikipedia/commons/thumb/5/55/LakeMavrovo.jpg/250px-LakeMavrovo.jpg"  width="400px" height="auto"></a></div></div>',
        },
        // 불가리아
        {
            coords:{lat:42.6977082, lng:23.3218675},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>불가리아-소피아</h1>소피아는 불가리아의 수도이자 최대 도시이다. 유럽에서 가장 오래된 수도의 하나이다. 소피아의 역사는 기원전 8세기에 이곳에 세워진 트라키아인들의 거주지로 거슬러 올라간다. 불가리아 서부 비토샤 산 밑에 자리잡고 있다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://dynamic-media-cdn.tripadvisor.com/media/photo-o/15/33/fc/c5/sofia.jpg?w=700&h=500&s=1"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:42.1354079, lng:24.7452904},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>불가리아-플로브디프</h1>플로브디프는 불가리아 중남부에 위치한 도시로 플로브디프 주의 주도이다. 수도 소피아 다음으로 불가리아에서 두 번째로 가장 큰 도시로 인구는 380,312명이다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://t1.daumcdn.net/cfile/tistory/235E5F4D55A2CDB11E"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:43.2140504, lng:27.9147333},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>불가리아-바르나</h1>바르나는 불가리아 동해안에 있는 도시로 바르나 주의 주도다. 인구 354,220. 불가리아 동부, 흑해와 바르나 호 연안에 위치한다. 역사가 깊은 도시로 유럽에서 가장 오래 된 도시의 하나로 손꼽힌다. <br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://dynamic-media-cdn.tripadvisor.com/media/photo-o/15/4d/45/a5/varna.jpg?w=700&h=500&s=1"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:42.6051862, lng:23.0378368},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>불가리아-페르니크</h1>페르니크는 불가리아 서부에 위치한 도시로, 페르니크 주의 주도이며 인구는 81,052명, 높이는 710m이다. 소피아에서 남서쪽으로 약 30km 정도 떨어진 곳에 위치하고 있고 스트루마 강과 접한다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://img.insight.co.kr/static/2020/09/09/1200/8t2u8x4k1242e243y011.jpg"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:43.4170423, lng:24.6066847},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>불가리아-플레벤</h1>플레벤 또는 플레브나는 불가리아 북부에 위치한 도시로, 플레벤 주의 주도이며 인구는 106,011명, 높이는 116m이다. 소피아에서 170km, 흑해 연안에서 서쪽으로 320km, 다뉴브 강에서 남쪽으로 50km 정도 떨어진 곳에 위치한다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://dynamic-media-cdn.tripadvisor.com/media/photo-o/1a/0e/59/f8/lake-in-the-park.jpg?w=500&h=300&s=1"  width="400px" height="auto"></a></div></div>',
        },
        // 브라질
        {
            coords:{lat:-23.5557714, lng:-46.6395571},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>브라질-상파울로</h1>상파울루는 브라질 남부 상파울루주의 주도이다. 브라질에서 가장 인구가 많은 도시이다. 면적은 1,523.0 km², 인구는 1,233만명이다. 브라질 최대의 도시이며, 브라질 뿐 아니라 남아메리카와 남반구 전체에서 가장 큰 세계적인 도시이다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://cdn.cctoday.co.kr/news/photo/200601/125495-1-42089.jpg"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:-22.9068467, lng:-43.1728965},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>브라질-리우데자네이루</h1>리우데자네이루는 브라질 남동부 대서양 연안에 자리한 도시로 리우데자네이루주의 주도이다. 줄여서 리우라고도 불린다. 포르투갈 왕국과 브라질의 수도이기도 했다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://t1.daumcdn.net/cfile/blog/137EE5475017D99C18"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:-15.7975154, lng:-47.89188739999999},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>브라질-브라질리아</h1>브라질리아는 1960년부터 브라질의 수도가 된 도시이다. 이 도시는 계획 도시로 알려져 있다. 브라질리아는 세계 유산에 등록되었다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://t1.daumcdn.net/cfile/tistory/9946063D5B17A19C05"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:-30.0368176, lng:-51.2089887},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>브라질-뽀르뚜알레그리</h1>포르투알레그리는 브라질 남부 히우그란지두술주의 주도이다. 넓이 496.8 km², 인구 1,440,939명. 풍요로운 브라질 남부의 중심지로, 대서양과 연결되는 파투스 호에 면하는 항구 도시이다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://upload.wikimedia.org/wikipedia/commons/thumb/5/52/Porto_Alegre_-_Brazil_Landscape-Night.jpg/1200px-Porto_Alegre_-_Brazil_Landscape-Night.jpg"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:-1.4563073, lng:-48.5012804},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>브라질-벨렘</h1>벨렘(Belém of Para)은 브라질 북부의 파라 주의 주도이자 최대 도시입니다. 번화한 항구, 공항, 버스/마차 정류장이 있는 아마존 강의 관문입니다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://dynamic-media-cdn.tripadvisor.com/media/photo-o/06/64/46/45/mangal-das-garcas.jpg?w=700&h=-1&s=1"  width="400px" height="auto"></a></div></div>',
        },
        // 브루나이
        {
            coords:{lat:4.535277, lng:114.727669},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>브루나이-반다르세리베가완</h1>반다르스리브가완은 브루나이의 수도로, 브루나이 최대의 도시이다. 아시아에서 가장 큰 모스크가 있다. 인구는 140,000명이며 면적은 100.36km²이다. 도시 이름은 "존경하는 통치자의 항구"를 뜻한다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://youimg1.tripcdn.com/target/100m0p000000frtpu7715_C_640_320_R5_Q70.jpg_.webp?proc=source%2Ftrip"  width="400px" height="auto"></a></div></div>',
        },
        // 산마리노
        {
            coords:{lat:43.94236, lng:12.457777},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>산마리노-산마리노</h1>가장 고귀한 공화국 산마리노 공화국, 영어: The noblest Republic of San Marino, 약칭 산마리노는 전면이 이탈리아에 둘러싸인 내륙국가이다. <br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://mblogthumb-phinf.pstatic.net/20110513_10/cityhuntorr_1305258743440yS7sP_JPEG/%BB%EA%B8%B6%B8%AE%B3%EB_%BC%BA3%B0%B3%B3%AA%BF%C2%B1%D7%B8%B2.jpg?type=w2"  width="400px" height="auto"></a></div></div>',
        },
        // 사모아
        {
            coords:{lat:-13.7591099, lng:-172.1046293},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>사모아-사모아</h1>사모아 독립국은 오세아니아의 폴리네시아 사모아 제도에 있는 나라이며, 수도는 아피아이다. 동쪽에 접하는 미국령 사모아와 구별하기 위하여 서사모아라고도 부른다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://cdn.travie.com/news/photo/201908/21093_4953_3351.jpg"  width="400px" height="auto"></a></div></div>',
        },
        // 사우디아라비아
        {
            coords:{lat:24.7135517, lng:46.6752957},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>사우디아라비아-리야드</h1>리야드는 사우디아라비아의 수도이다. 또한 리야드는 사우디아라비아에서 최대 도시이며, 리야드의 인구는 2016년 기준으로 6,506,700 명으로, 아랍권에서 사람이 가장 많이 살고 있는 도시 가운데 한 곳이다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://dynamic-media-cdn.tripadvisor.com/media/photo-o/12/3b/1c/75/kingdom-centre-tower.jpg?w=300&h=300&s=1"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:24.5246542, lng:39.5691841},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>사우디아라비아-메디나</h1>메디나 또는 마디나는 사우디아라비아의 서부 헤자즈 지방에 있는 도시로, 마디나 주의 주도이다. 메카 북쪽으로 약 350km 지점에 있는 성지로, 무함마드가 622년 메카에서 추방당하여 헤지라를 행한 곳으로서, 그 묘가 있다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://dynamic-media-cdn.tripadvisor.com/media/photo-o/13/60/b1/42/medina.jpg?w=700&h=500&s=1"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:21.485811, lng:39.19250479999999},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>사우디아라비아-제다</h1>지다 혹은 제다는 사우디아라비아에서 가장 중요한 항구 도시로 행정 구역상으로는 메카 주에 속한다. 홍해 연안에 위치하여 "홍해의 신부"라고 불린다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="http://cdn.topdigital.com.au/news/photo/201512/img_947_0.jpg"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:21.3890824, lng:39.8579118},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>사우디아라비아-메카</h1>메카 또는 마카는 과거에 히자즈로 알려졌던 사우디아라비아의 도시로 메카 주의 주도이다. 홍해 연안의 항구 도시 지다에서 70 km 정도 내륙인 북위 21도 29분, 동경 39도 45분에 위치해 있으며 해발 277미터이고, 2012년 기준 인구는 약 2백만명이다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="http://diverseasia.snu.ac.kr/wp-content/uploads/2021/06/4.jpg"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:16.8893586, lng:42.57056740000001},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>사우디아라비아-지잔</h1>지잔은 사우디아라비아 남서부에 위치한 도시로 지잔 주의 주도이며 인구는 100,694명이다. 예멘 국경 북쪽에 위치하며 홍해 연안과 접한다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://a.travel-assets.com/findyours-php/viewfinder/images/res70/522000/522416-alula.jpg?impolicy=fcrop&w=360&h=224&q=mediumLow"  width="400px" height="auto"></a></div></div>',
        },
        // 상투메 프린시페 
        {
            coords:{lat:0.18636, lng:6.613080999999999},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>상투메프린시페-상투메프린시페</h1>상투메는 서아프리카 기니 만에 있는 상투메 프린시페의 수도이자 상투메 프린시페의 최대 도시이다. 도시가 위치한 상투메 섬은 화산섬이며 최고점은 2,205m이다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://eb.findmybucketlist.com/bucket/new/cp/3424601_cp_00.jpg?update_date=2019-10-2516:32:05"  width="400px" height="auto"></a></div></div>',
        },
        // 세네갈
        {
            coords:{lat:14.7910052, lng:-16.9358604},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>세네갈-티에스</h1>티에스는 세네갈 서부에 위치한 도시로, 티에스 주의 주도이며 세네갈에서 두 번째로 큰 도시이다. 인구는 237,849명이다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://storage.doopedia.co.kr/upload/_upload/image5/2208/01/220801024389062/220801024389062_thumb_400.jpg"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:16.0326307, lng:-16.4818167},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>세네갈-세인트루이스</h1>생루이 또는 은다르는 세네갈 북서부에 위치한 도시로, 생루이 주의 주도이며 인구는 176,000명이다. 수도 다카르에서 북쪽으로 약 320km 정도 떨어진 곳에 위치하며 세네갈 강 어귀와 접한다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://upload.wikimedia.org/wikipedia/commons/thumb/b/b6/Saintlouis_ile_pecheur.jpg/660px-Saintlouis_ile_pecheur.jpg"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:14.716677, lng:-17.4676861},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>세네갈-다카르</h1>다카르는 세네갈의 수도로 인구 207만9,000명이 거주하고 있다. 대서양에 접해 있는 무역항이다. 아프리카의 최서단에 위치해 있고 대서양 횡단 무역 및 유럽 무역에 있어서, 중요한 위치를 차지하는 중요한 항만이다. <br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://www.motorgraph.com/news/photo/201901/21479_70318_147.jpg"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:14.8665572, lng:-15.8994956},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>세네갈-투바</h1>투바는 세네갈 중부 디우르벨 주에 위치한 도시로 높이는 35m, 인구는 529,176명이다. 도시 이름은 아랍어로 "행복"을 뜻한다. 이슬람교의 분파 가운데 하나인 무리디파의 성지로 여겨지고 있으며 1963년에 준공된 대형 모스크가 들어서 있다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://upload.wikimedia.org/wikipedia/commons/thumb/0/0b/Touba_034_%2845718877585%29.jpg/300px-Touba_034_%2845718877585%29.jpg"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:14.1652083, lng:-16.0757749},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>세네갈-꺄올락끄</h1>카올라크는 세네갈의 도시로, 카올라크 주의 주도이며 인구는 172,305명이다. 남쪽으로는 감비아와 국경을 접하며 세네갈의 주요 생산 품목인 땅콩 무역과 유통 산업이 발달했다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://mblogthumb-phinf.pstatic.net/MjAxODA5MjVfMTg1/MDAxNTM3ODMxNDc1NDk1.vNoSJy8hUNtgO3rAi4M8SJdopmdZIphH0g5q9jSPJTgg.A760eEHzCmzabBVSX1vXk3ErvOVVHvOoDECBkY0OshYg.JPEG.itravelworld/IMG_8343.JPG?type=w800"  width="400px" height="auto"></a></div></div>',
        },
        // 세르비아
        {
            coords:{lat:44.8125449, lng:19.8227056},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>세르비아-베오그라드</h1>베오그라드는 세르비아의 수도이자, 발칸반도의 주요 도시 중 하나이다. 베오그라드는 ‘하얀 도시’라는 뜻이다. 1918년부터 2002년까지는 유고슬라비아의 수도였으며, 그 후 2005년까지는 세르비아 몬테네그로 연방의 수도였다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="http://www.outdoornews.co.kr/news/photo/201611/23026_71909_441.JPG"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:45.2396085, lng:19.5240814},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>세르비아-노비사드</h1>노비사드는 세르비아 북부 보이보디나 자치주에 있는 도시이다. 인구 400,000. 보이보디나 자치주의 주도이자 남바치카구의 행정 중심지이며, 세르비아에서 수도 베오그라드 다음으로 큰 도시이다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://dynamic-media-cdn.tripadvisor.com/media/photo-o/05/0f/b6/c7/petrovaradin-fortress.jpg?w=700&h=500&s=1"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:43.320926, lng:21.8954069},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>세르비아-니슈</h1>니시는 세르비아 남부 니샤바구에 있는 도시이다. 인구 299,728. 도나우강의 지류인 벨리카모라바강 유역의 비옥한 니샤바 분지의 중심지이다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://eb.findmybucketlist.com/city/new/cp/1216408_cp_00.jpg?update_date=2019-08-1921:23:16"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:45.3834283, lng:20.3906166},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>세르비아-즈레냐닌</h1>즈레냐닌은 세르비아 보이보디나 자치주의 도시로, 중앙바나트 구의 행정 중심지이며 면적은 1,324km², 인구는 132,051명이다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://dynamic-media-cdn.tripadvisor.com/media/photo-o/0c/ce/ca/b8/zrenjanin.jpg?w=700&h=500&s=1"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:46.09695809999999, lng:19.65763},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>세르비아-수보티차</h1>수보티차는 세르비아 북부 보이보디나에 있는 도시로, 인구는 148,401명이다. 세르비아 북쪽 끝, 헝가리 국경에 접한다. 오래전부터의 도시였으나 13세기 타타르의 침입 때 파괴된 것으로 보이며, 1391년 저바드커라는 이름의 헝가리 왕국의 정착지로 처음 역사에 등장했다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://youimg1.tripcdn.com/target/10010y000000mb7tr4D23_D_1180_558.jpg?proc=source%2Ftrip"  width="400px" height="auto"></a></div></div>',
        },
        // 세이셸
        {
            coords:{lat:-4.679574, lng:55.491977},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>세이셸-세이셸</h1>세이셸 공화국은 아프리카 동부, 인도양에 위치하여 있는 섬 나라이다. 아프리카 대륙에서 약 1,600km 떨어져 있다. 수도는 빅토리아이다. 아프리카에서는 유일하게 인도식 화폐인 루피를 쓴다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://cdn.travie.com/news/photo/first/201712/img_20042_2.jpg"  width="400px" height="auto"></a></div></div>',
        },
        // 세인트루시아
        {
            coords:{lat:13.909444, lng:-60.978893},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>세인트루시아-세인트루시아</h1>세인트루시아는 중앙아메리카 카리브 해 소앤틸리스 제도에 있는 섬나라이다. 국어는 영어를 사용하며, 수도는 캐스트리스이다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://theplanetsworld.com/wp-content3_1/14-top-rated-tourist-attractions-in-st-lucia-2.jpg"  width="400px" height="auto"></a></div></div>',
        },
        // 세인트빈센트 그레나딘
        {
            coords:{lat:12.984305, lng:-61.287228},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>세인트빈센트그레나딘-세인트빈센트그레나딘</h1>세인트빈센트 그레나딘은 카리브 해에 있는 섬나라이다. 동카리브해의 소앤틸리스 제도 남방에 떠 있는 약 600여 개의 섬으로, 이 중 세인트빈센트 섬이 중심이다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://dynamic-media-cdn.tripadvisor.com/media/photo-o/15/4d/43/96/st-vincent-and-the-grenadines.jpg?w=700&h=500&s=1"  width="400px" height="auto"></a></div></div>',
        },
        // 세인트키츠 네비스
        {
            coords:{lat:17.357822, lng:-62.782998},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>세인트키츠네비스-세인트키츠네비스</h1>세인트키츠 네비스 연방 또는 줄여서 세인트키츠 네비스는 1983년 영국으로부터 독립한 섬나라이며 수도는 바스테르이다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://mblogthumb-phinf.pstatic.net/MjAxOTA0MTZfMjIz/MDAxNTU1Mzc5ODg5ODE0.ktpLP0KeaqNb_NOHlo-gAnO3e2Tu_cZYGLX5sn5FFpQg.Ie_r0V7BBjB2zrDRsuR7N0326piwhlAILmrLYVZxdYcg.JPEG.glomad/%EC%84%B8%EC%9D%B8%ED%8A%B8%ED%82%A4%EC%B8%A0%EB%84%A4%EB%B9%84%EC%8A%A42.jpg?type=w800"  width="400px" height="auto"></a></div></div>',
        },
        // 소말리아
        {
            coords:{lat:2.0469343, lng:45.3181623},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>소말리아-모가디슈</h1>모가디슈는 소말리아의 수도이다. 2009년 당시 인구는 1,300,000여 명이다. 인도양 해안의 베나디르 지역에 위치한 도시는 수세기 동안 중요한 지역의 항구로서 역할을 해 왔다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://pds.joongang.co.kr/news/component/htmlphoto_mmdata/202107/28/aa4712b8-7fa3-4d09-830c-af821adefd12.jpg"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:11.2755407, lng:49.1878994},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>소말리아-보사소</h1>보사소는 소말리아 바리 주의 주도로, 아덴 만과 접하며 2013년 3월 기준으로 인구는 700.000명 이상이다. 소말리아의 대표적인 항구 도시 가운데 하나이며 벤데르 카심 국제공항이 있다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://media.istockphoto.com/photos/ship-wrecks-in-the-port-of-bossaso-somalia-picture-id1190204437"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:3.1140502, lng:43.651925},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>소말리아-바이다보</h1>바이다보는 소말리아 북서부에 위치한 도시로, 바이 주의 주도이며 모가디슈에서 북서쪽으로 256km 정도 떨어진 곳에 위치한다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://upload.wikimedia.org/wikipedia/commons/thumb/c/c3/Somali_Civil_War_%282009-present%29.svg/320px-Somali_Civil_War_%282009-present%29.svg.png"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:6.7872726, lng:47.4392352},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>소말리아-갈카요</h1>갈카요는 소말리아 중부에 위치한 도시로, 무두그 주의 주도이며 인구는 약 545,000명이다. 시 북반부는 푼틀란드의 지배하에 있다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://mblogthumb-phinf.pstatic.net/20130510_39/koreamof_1368167157922M5xv2_JPEG/seaoflee_307168_1492828.jpg?type=w2"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:9.525916600000002, lng:45.5346307},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>소말리아-부라오</h1>Buro 또는 Burao라고도 하는 Burao는 Togdheer 지역의 수도이자 소말릴란드에서 두 번째로 큰 도시입니다. Burao는 또한 소말리아에서 세 번째로 큰 도시였습니다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://media.istockphoto.com/photos/the-turkish-mosque-in-burao-sheekh-berbera-somaliland-somalia-picture-id1317621042?s=612x612"  width="400px" height="auto"></a></div></div>',
        },
        // 솔로몬 제도
        {
            coords:{lat:-9.64571, lng:160.156194},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>솔로몬제도-솔로몬제도</h1>솔로몬 제도는 오세아니아의 멜라네시아에 위치한 국가이자 영연방 국가이다. <br><br><div style="width:400px;height:auto;"><a href="#"><img src="http://img.khan.co.kr/news/2019/09/03/l_2019090301000487000038451.jpg"  width="400px" height="auto"></a></div></div>',
        },
        // 수단
        {
            coords:{lat:15.5006544, lng:32.5598994},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>수단-카르툼</h1>하르툼은 북아프리카에 속하는 나라인 수단의 수도로, 카르툼이라고도 일컫는다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://mblogthumb-phinf.pstatic.net/MjAxODEyMTNfMTMx/MDAxNTQ0NjQ3Mzk5NjYw.hP5aFGDLvolCe48SFg1ks7DJmwSzh8WR6kiAwH9XiHIg.r3GcX9lTWDewC1pVmmpc6CPmWBCFKE-missyxnpWxfQg.JPEG.hansu0922/%EC%95%84%ED%94%84%EB%A6%AC%EC%B9%B4_%EC%88%98%EB%8B%A8_%EC%B9%B4%EB%A5%B4%ED%88%BC%EC%9C%BC%EB%A1%9C20151103-173238-015%EC%84%B8%EA%B3%84%EC%97%AC%ED%96%89.jpg?type=w800"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:13.6197501, lng:25.3548713},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>수단-알파시르</h1>알파시르은 수단 북다르푸르 주의 주도다. 2006년 기준으로 인구는 264,734명이다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://upload.wikimedia.org/wikipedia/commons/thumb/0/0d/Sudan_Envoy_-_Darfur_from_above.jpg/220px-Sudan_Envoy_-_Darfur_from_above.jpg"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:19.1461403, lng:30.4703258},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>수단-동골라</h1>동골라는 수단 북부 주의 주도다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://mblogthumb-phinf.pstatic.net/MjAxNzEyMDVfMjA2/MDAxNTEyNDE4NjYzMzgy.PzPFJOhmUIrcZevwqRgoQwkNIahXDV33QYT38S9LP-kg.3eA6yVBKmetPWwf6dQor_WkFWZWCfMBs8-tHuSUfFl4g.JPEG.itravelworld/DSC_3735.JPG?type=w800"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:17.7014525, lng:34.0084395},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>수단-아트바라</h1>아트바라는 수단 북동부의 나일강 주에 위치한 도시입니다. 철도 산업과의 연결성 때문에 Atbara는 "철도 도시"로도 알려져 있습니다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://i2.wp.com/socialist.kr/wp_ksowebzine/wp-content/uploads/2019/06/sudanatbara-afp-2019.jpg?resize=696%2C463"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:13.447898, lng:22.4649083},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>수단-알주나이나</h1>알주나이나는 수단의 도시로, 서다르푸르 주의 주도이며 인구는 170,618명이다. 차드와 국경을 접하며 다르푸르 분쟁 이후부터 피난민들이 증가하기 시작했다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://server.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/12/1892/2303"  width="400px" height="auto"></a></div></div>',
        },
        // 수리남
        {
            coords:{lat:5.8520355, lng:-55.2038278},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>수리남-파라마리보</h1>파라마리보는 수리남의 수도이다. 인구는 222,843명이고 대서양으로부터 약 15km의 지점에 위치한다. 교외에서는 보크사이트, 사탕수수, 벼, 카카오, 커피가 생산되어서 수출하고 있다. 시가에서는 시멘트, 럼주를 제조하고 있다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://image.shutterstock.com/image-photo/synagogue-neve-shalom-mosque-keizerstraat-260nw-1050684365.jpg"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:3.1627782, lng:-55.7147796},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>수리남-펠렐로테푸</h1>펠레루 테푸는 수리남의 도시이다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://upload.wikimedia.org/wikipedia/commons/thumb/9/97/Pelulu_Tepu_%28Suriname%29_%28cropped%29%2C_2018.png/500px-Pelulu_Tepu_%28Suriname%29_%28cropped%29%2C_2018.png"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:5.608084799999999, lng:-54.398656},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>수리남-모엔고</h1>모엔고는 수리남의 도시이다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://upload.wikimedia.org/wikipedia/commons/3/36/Tropenmuseum_Royal_Tropical_Institute_Objectnumber_60006898_Bauxietfabriek_van_Moengo.jpg"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:5.7, lng:-55.866667},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>수리남-바타비아</h1>바타비아는 수리남의 도시이다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://pbs.twimg.com/media/ClMexhfVYAAL1pj.jpg"  width="400px" height="auto"></a></div></div>',
        },
        // 스리랑카
        {
            coords:{lat:6.9270786, lng:79.861243},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>스리랑카-콜롬보</h1>콜롬보는 스리랑카의 최대 도시이자 경제 수도이다. 명칭의 유래는 싱할라어로 망고 나무가 무성한 해안을 의미하는 Kola-amba-thota에서 유래되었다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://www.cathaypacific.com/content/dam/destinations/colombo/cityguide-gallery/colombo_skyline_920x500.jpg"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:6.032894799999999, lng:80.2167912},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>스리랑카-갈</h1>갈은 스리랑카의 도시이다.인구는 90,934명이고, 면적은 1,652km²이다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://cdn.travie.com/news/photo/202005/21483_7850_193.jpg"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:7.286591400000001, lng:80.6327783},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>스리랑카-캔디</h1>캔디는 스리랑카 중부에 위치한 제1의 관광도시이다. 실론 최후 왕조의 수도로 각처에 낡은 전통을 생각케 하는 왕궁, 사원, 민속무용이 훌륭하게 보존되어 있다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://pds.joongang.co.kr/news/component/htmlphoto_mmdata/202011/18/6ed73e58-9fc1-4cd0-954e-8aa17664b164.jpg"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:7.730997100000001, lng:81.6747295},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>스리랑카-바키칼로아</h1>바티칼로아는 스리랑카 동부 주 바티칼로아구의 행정 중심지이다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://pix10.agoda.net/hotelImages/929/929204/929204_15070922550032003602.jpg?ca=4&ce=1&s=450x450"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:8.5873638, lng:81.2152121},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>스리랑카-트링코말리</h1>트링코말리는 스리랑카 북동부에 위치한 항구 도시로, 동부 주와 타밀일람의 주도이며 트링코말리 구의 행정 중심지이다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://youimg1.tripcdn.com/target/100j1f000001gptc65A24_C_640_320_R5_Q70.jpg_.webp?proc=source%2Ftrip"  width="400px" height="auto"></a></div></div>',
        },
        // 스웨덴 
        {
            coords:{lat:59.32932349999999, lng:18.0685808},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>스웨덴-스톡홀름</h1>스톡홀름은 스웨덴의 수도이자 스칸디나비아반도 최대 도시이다. 많은 섬을 끼고 있어 "북방의 베네치아"라고도 불린다. 회토리예트에 위치한 콘서트홀에서는 매년 노벨상 시상식이 열리며, 1912년에는 하계 올림픽 대회를 개최하였고, 1958년에는 FIFA 월드컵 결승전이 열린 곳이다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://dynamic-media-cdn.tripadvisor.com/media/photo-o/15/33/f9/5e/stockholm.jpg?w=700&h=500&s=1"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:57.70887, lng:11.97456},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>스웨덴-예테보리</h1>예테보리는 스웨덴에 있는 도시로 베스트라예탈란드주의 주도이다. 인구는 581,822명으로 수도 스톡홀름에 이어 스웨덴에서 두 번째로 큰 도시이다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://post-phinf.pstatic.net/MjAxNzA1MTZfMjE0/MDAxNDk0OTE1MDMzOTIw.n-I6ZITohT__wS1nZLgVLjvv_B6IgfMVpywlj91G9AAg.RIls_ZWIn1tahu8rd7jnAecPYifzw5tst_I0SDJvc6gg.JPEG/image_7366940221494915025462.jpg?type=w1200"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:55.604981, lng:13.003822},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>스웨덴-말뫼</h1>말뫼는 스웨덴 서남부 스코네주에 있는 도시이다. 스코네 주의 주도이다. 인구 282,904. 스웨덴 서남쪽 끝, 외레순 해협에 면하는 항구도시이며, 덴마크의 코펜하겐 건너편에 있다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://post-phinf.pstatic.net/MjAxNzA1MThfMjcy/MDAxNDk1MDk1MDE3NjYy.l8glEzzJzEx4ImHvDMS01P0VJWygH5yzxDq2N-7aEjwg.1O0qiYvOpmpGQLeD1dirBaoNWghi5jcNTEQgRIs8B5cg.JPEG/18e6cb2899675b0dd0a4ab9793b85f5e%28ssacc.se%29.jpg?type=w1200"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:57.78261370000001, lng:14.1617876},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>스웨덴-옌셰핑</h1>옌셰핑은 스웨덴 남부에 위치한 도시로, 옌셰핑주의 주도이며 면적은 44.82km², 인구는 89,396명, 인구 밀도는 1,995명/km²이다. 스웨덴에서 9번째로 큰 도시이며 베테른 호 남단과 접한다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://media.istockphoto.com/photos/jonkoping-sweden-picture-id154066958"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:59.60990049999999, lng:16.5448091},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>스웨덴-베스테로스</h1>베스테로스는 스웨덴 중부 베스트만란드주에 있는 도시이다. 인구 133,623. 베스테만란드 주의 주도이다. 멜라렌 호의 서안에 위치하며, 스톡홀름 서쪽 100km 지점에 있다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://media.istockphoto.com/photos/modern-apartment-in-the-city-vasteras-sweden-picture-id532916723"  width="400px" height="auto"></a></div></div>',
        },
        // 스위스
        {
            coords:{lat:46.9479739, lng:7.4474468},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>스위스-베른</h1>베른은 스위스의 연방시이며 사실상 수도이다. 2020년 기준으로 인구 약 14만 4000명으로, 베른은 스위스에서 다섯 번째로 인구가 많은 도시이다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="http://www.travelnbike.com/news/photo/201808/63363_102853_168.jpg"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:47.3768866, lng:8.541694},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>스위스-취리히</h1>취리히는 스위스에서 가장 큰 도시이자 취리히주의 주도이며, 스위스의 중간 지역에 취리히호의 북쪽 끝에 위치해 있다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://img1.daumcdn.net/thumb/R800x0/?scode=mtistory2&fname=https%3A%2F%2Ft1.daumcdn.net%2Fcfile%2Ftistory%2F9967D6355BC8230D14"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:47.05016819999999, lng:8.3093072},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>스위스-루체른</h1>루체른은 스위스 중부 루체른주에 있는 도시로, 루체른 주의 주도이다. 루체른호의 서안에 붙어 있으며, 로이스강이 시내를 흐른다. 8세기에 수도원과 대성당이 건립되었고, 알프스 산맥을 넘는 교통로의 요지로 발달하였다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://medisf.traasgpu.com/ifis/aeed6091ac7034ca-1024x576.jpg"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:47.5595986, lng:7.5885761},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>스위스-바젤</h1>바젤은 스위스에서 세 번째로 인구가 많은 도시로 바젤슈타트주에 속한다. 인접 도시권을 포함하면 약 69만 명으로 스위스에서 두 번째로 크다. 스위스의 북서쪽 라인 강변에 자리하고 있으며, 화학과 제약 산업의 중심 도시 역할을 하고 있다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://youimg1.tripcdn.com/target/100i07000000224xv260B_C_640_320_R5_Q70.jpg_.webp?proc=source%2Ftrip"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:46.5196535, lng:6.6322734},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>스위스-로잔</h1>로잔은 스위스의 도시로 보주의 주도이다. 레만호 유역에 위치하며, 프랑스어를 사용하는 지역에 속한다. 로마 제국 시절 라우소니움이라는 이름으로 건설된 오래된 도시로서, 세계적인 관광도시이다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://mblogthumb-phinf.pstatic.net/MjAxNzExMjlfMjgz/MDAxNTExOTIwODU0NzE3.8-l8ZHdELYPLC3wlAjIr6cUmnFLpQra7HyKcwN2u20kg.iLMIPCifKtGUyHOlldIxFdPJ3nFqxv0VyAr0CG3R7oog.JPEG.chansoondae/DSC_1532.jpg?type=w800"  width="400px" height="auto"></a></div></div>',
        },
        // 스페인
        {
            coords:{lat:40.4167754, lng:-3.7037902},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>스페인-마드리드</h1>마드리드는 스페인의 수도로, 나라의 중앙부에 있다. 인구는 약 300만 명 이다. 마드리드는 만사나레스강을 끼고 있으며 스페인의 중심에 위치한다. 마드리드가 쏟아내는 경제적 효과로 인해 주변 도시들이 크게 영향을 받는다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://storage.googleapis.com/cbmpress/uploads/sites/3/2018/02/travle_mar_main.jpg"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:39.4699075, lng:-0.3762881},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>스페인-발렌시아</h1>발렌시아는 스페인 발렌시아 주의 주도이다. 인구는 약 81만 명으로 제지·담배·식료품 공업의 중심지이며 마요르카 섬과 함께 보양·관광지로 되어 있다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://post-phinf.pstatic.net/MjAxOTA3MjFfMTcy/MDAxNTYzNjQzMDAzODA3.tZJc2-3JC3BykgwfE4M6u1G51sj8cOA3G1QVIZQBqrAg.34aORRYWtKEZL-sYXpUVvfikxys84GM2ltcRIYHDMdMg.JPEG/Valencia-Spain.jpg?type=w1200"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:41.3873974, lng:2.168568},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>스페인-바르셀로나</h1>바르셀로나는 스페인에서 두 번째로 큰 도시로, 스페인 동부 지중해 연안 지역부터 프랑스 남쪽 피레네 산맥과 접경지역을 아우르는 카탈루냐 지방의 중심 도시이다. 인구는 1,620,343명이고 면적은 101.3 km²이다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://post-phinf.pstatic.net/MjAxOTAxMjlfMjQ2/MDAxNTQ4NzI5NzY2MjU4.u1K-aPP66RPwmfQuE_XhQLAsx7DO_IYb1Q1-8oO3Js0g.-vh6rsD8azBkc2HSlLSezwTEEY86M8SjI32UYgw7b6cg.JPEG/shutterstock_1095000005_%EC%82%AC%EB%B3%B8.jpg?type=w1200"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:43.2630126, lng:-2.9349852},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>스페인-빌바오</h1>빌바오는 스페인 바스크 지방의 중심 도시이다. 빌바오 시만의 인구는 2006년 기준으로 약 35만 명이고, 주변 지역을 포함하는 빌바오 대도시권의 인구는 바스크 지방 전체 인구의 약 1/3을 차지하는 95만여 명이다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://happist.com/wp-content/uploads/2019/12/%EC%8A%A4%ED%8E%98%EC%9D%B8-%EB%B9%8C%EB%B0%94%EC%98%A4-%EB%8F%84%EC%8B%9C-%EC%A0%84%EA%B2%BD-Bilbao-Spain-Photo-by-Yves-Alarie-1-1024x667.jpg"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:41.6488226, lng:-0.8890853},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>스페인-사라고사</h1>사라고사는 스페인 북동부 아라곤 지방의 도시로, 사라고사 주의 주도이다. 중세에는 아라곤 왕국의 수도였다. 스페인 북동부를 흐르는 에브로 강의 중류에 위치해 있다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://file2.nocutnews.co.kr/newsroom/image/2014/06/24/20140624190716123375.jpg"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:37.9922399, lng:-1.1306544},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>스페인-무르시아</h1>무르시아는 스페인 남동부 무르시아 지방의 도시이며, 스페인에서 7번째로 크다. 세구라 강에 접한다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://previews.123rf.com/images/philipus/philipus1407/philipus140700041/29858959-%EC%A7%80%EC%A4%91%ED%95%B4-%EB%A7%88-aguilas-%EB%B0%A4%EC%9E%85%EB%8B%88%EB%8B%A4-%EC%8A%A4%ED%8E%98%EC%9D%B8-%EB%AC%B4%EB%A5%B4%EC%8B%9C%EC%95%84-%EC%A7%80%EB%B0%A9.jpg"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:36.721261, lng:-4.4212655},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>스페인-말라가</h1>말라가는 스페인 남부 안달루시아 지방의 해안 도시다.인구는 대략 600,000명으로 세비야에 이어서 안달루시아에서 두 번째로 많고 스페인 전체에서는 마드리드, 바르셀로나, 발렌시아, 세비야, 사라고사에 이어 여섯 번째로 인구가 많은 도시다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://post-phinf.pstatic.net/MjAyMDAxMTVfMjA3/MDAxNTc5MDYzMjgwNDU2.7LYxUcc3n_MgOghDGUwwvOPvfkcfZmSoncDoC-mYBOMg.iKj7NeZdRelcsjyWYNgy-QpdkDTEcKcQjnPfDviHHnwg.JPEG/Malaga_main.jpg?type=w1200"  width="400px" height="auto"></a></div></div>',
        },
        // 슬로바키아
        {
            coords:{lat:48.7163857, lng:21.2610746},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>슬로바키아-코시체</h1>코시체는 슬로바키아에 위치한 도시로 코시체 주의 주도이다. 인구는 브라티슬라바 다음으로 제일 많은 24만 2천 명이다. <br><br><div style="width:400px;height:auto;"><a href="#"><img src="http://t2.gstatic.com/licensed-image?q=tbn:ANd9GcQkoedVUCqrwkMLcofvS95JMFo6Cb7ha-X-414prNms5an9lAEO5yDAo4PhIzvyaiqs"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:48.1485965, lng:17.1077477},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>슬로바키아-브라티슬라바</h1>브라티슬라바는 슬로바키아의 수도이다. 슬로바키아 남서부에 위치한 도시로서 슬로바키아 대통령 관저, 의회, 정부 부처, 대법원, 중앙은행이 이 곳에 위치한다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="http://t1.gstatic.com/licensed-image?q=tbn:ANd9GcTpx8OcxSHgACubN8rIQhw_TJGpK3LpkVz_tx34gZD_QewkwtAYG5DbyjpbT2CVDfE8"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:49.21944980000001, lng:18.7408001},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>슬로바키아-질리나</h1>질리나는 슬로바키아 서북부에 위치한 도시로, 질리나 주의 주도이다. 슬로바키아의 대표적인 산업 도시이기도 하다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="http://t1.gstatic.com/licensed-image?q=tbn:ANd9GcTfht2NICNfG_11UMF2XPP4CmW27_R29WpF-dQ0kY1SGGvrnDE1BVCDqRM6odLdTpSy"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:48.884936, lng:18.0335209},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>슬로바키아-트렌친</h1>트렌친은 슬로바키아 서부에 위치한 도시로, 트렌친 주의 주도이며  수도 브라티슬라바에서 약 120km 정도 떨어진 곳에 위치하고 있고 체코 국경과 가까운 편이다. <br><br><div style="width:400px;height:auto;"><a href="#"><img src="http://t3.gstatic.com/licensed-image?q=tbn:ANd9GcS-F4xccjKnPLz16koSwihzy6b1OEv2abjcY8AHZ9OzloExR9Tbj52oq-yBheRsKORA"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:48.3061414, lng:18.076376},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>슬로바키아-니트라</h1>니트라는 슬로바키아 서부에 위치한 도시로 니트라 주의 주도이다. 슬로바키아에서 5번째로 큰 도시로서 슬로바키아의 도시 가운데 가장 오래된 역사를 자랑한다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="http://t3.gstatic.com/licensed-image?q=tbn:ANd9GcQOqn04iu3q_hjJ_Zl4P6_TNfGeoQTn152pj9meGnLnmB2WTG4aUaQOPKPDuQdDZ84_"  width="400px" height="auto"></a></div></div>',
        },
        // 슬로베니아
        {
            coords:{lat:46.0569465, lng:14.5057515},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>슬로베니아-류블랴나</h1>류블랴나는 슬로베니아의 수도이다. 11개 특별시 중 하나로 지정되어 있다. 알프스 산맥과 지중해의 연결 부분과, 사바 강으로 흘러서 들어가는 류블랴냐 강의 하구에 있다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="http://t3.gstatic.com/licensed-image?q=tbn:ANd9GcS9ALzNyW6fbVJo05kaQ2lseHV7mCjNx4iSa-07FRZxFDcFXztDbwgSJaQFytrrS73v"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:45.80108240000001, lng:15.1710089},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>슬로베니아-노보메스토</h1>노보메스토는 슬로베니아 남동부에 위치한 도시로 크로아티아와 국경을 접하고, 1365년 4월 7일에 신설되었다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="http://t1.gstatic.com/licensed-image?q=tbn:ANd9GcSk_FCPUOyofJMzw30Tp4vB9mkLGdHluH2YXLI7kbbK-juEiJIJUCiMn8PoW4MBwqEz"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:46.5546503, lng:15.6458812},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>슬로베니아-마리보르</h1>마리보르는 슬로베니아 북부에 있는 도시이다. 인구 119,071. 수도 류블랴나 다음 가는 슬로베니아 제2의 도시이다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="http://t3.gstatic.com/licensed-image?q=tbn:ANd9GcRtvlRNVGcnCPO0afeDQsE2AKbx96MqYpZxfuvbSlPQcX5UIKc1pz1h0uSzsLO3GeWs"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:46.3622743, lng:15.1106582},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>슬로베니아-벨레네</h1>벨레네는 슬로베니아의 도시로 면적은 83.5km², 인구는 33,331명, 인구밀도는 399.2명/km²이다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSmAurXX4YrFAumeLM4gt4WLFPpIZgPaU-RNA&usqp=CAU"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:46.6581381, lng:16.1610293},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>슬로베니아-무르스카소보타</h1>무르스카소보타는 슬로베니아 북동부에 위치한 도시로 면적은 14.5km², 인구는 11,679명, 인구 밀도는 806명/km²이며 무어 강과 접한다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://cf.bstatic.com/xdata/images/hotel/square200/231799548.jpg?k=ca890b4c42e0b0ac7796102de090a04760b407b1e174e3225b05f3cb36755ae8&o="  width="400px" height="auto"></a></div></div>',
        },
        // 시리아 
        {
            coords:{lat:33.5138073, lng:36.2765279},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>시리아-다마스커스</h1>다마스쿠스는 시리아의 수도이다. 앗샴이라 불리기도 한다. 2007년 기준으로 인구는 약 555만명에 달한다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="http://t2.gstatic.com/licensed-image?q=tbn:ANd9GcTEd8zx6CAo-aUYttYdcntiuoT3bY0j33Dkis7RBgxJR3AScwaQV0R6j6SVb25ep4wd"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:34.7324273, lng:36.7136959},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>시리아-홈스</h1>홈스 또는 십자군 시대의 라 카멜레는 시리아 서부의 도시로 홈스 주의 주도이다. <br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://w.namu.la/s/abf016f4ebd00eb4c2ef2f4d34932366feffee99ac0b2e8fb9d3d9601a16cdb4136ead4a506788e2caf9c1afefe88731741e834b9550c316f16024b8bda38ddaa62c65556b822cd057c380e9b215a7c0c62f77db65e7ac1a3882a0360f231c1be664a95be5c0d7f9fab0ec294bd304b3"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:34.8959276, lng:35.8866517},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>시리아-타르투스</h1>타르투스는 지중해 연안과 접한 시리아의 도시로, 시리아 서부에 위치한다. 타르투스 주의 주도이며 라타키아에 이어 시리아에서 두 번째로 큰 항구 도시이다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="http://t1.gstatic.com/licensed-image?q=tbn:ANd9GcTVtBmULCCx7atdcRAn0X4GWoXBE06N3ZtVn3J1_DYvgyJqAQGucpPIGo0VQuifwDfO"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:36.507867, lng:40.7462671},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>시리아-하사카</h1>하사카는 시리아 북동부에 위치한 도시로, 하사카 주의 주도이며 인구는 81,809명이다. 시 중심부에는 하부르 강이 흐른다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://upload.wikimedia.org/wikipedia/commons/thumb/0/0e/Kokab_Mountain_al_Hasakah.JPG/300px-Kokab_Mountain_al_Hasakah.JPG"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:36.2021047, lng:37.1342603},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>시리아-알레포</h1>알레포는 시리아 북부의 도시로 알레포 주의 주도이다. 그 인구는 4,393,000명에 달하며 시리아에서 가장 큰 주이다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="http://t1.gstatic.com/licensed-image?q=tbn:ANd9GcRk--GJSPCYk95Cqj0Jpi8lDRUNtchPC0QAD1OehBl7UwD86cdmoisiF1dfEPRl6d3g"  width="400px" height="auto"></a></div></div>',
        },
        // 시에라리온
        {
            coords:{lat:8.4656765, lng:-13.2317225},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>시에라리온-프리타운</h1>프리타운은 시에라리온의 수도이다. 프리타운의 경제는 주로 항구 주위에서 이루어지며, 아프리카에서 가장 큰 천연 항구이자, 세계에서 3번째로 가장 큰 천연 항구이다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="http://t3.gstatic.com/licensed-image?q=tbn:ANd9GcTwZzCNMjBS_3Thl7hVuzXAEB5Q1m64Ys9UVkxSR331tqTEwHbirvGnl2eh_v9mrWZm"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:8.6448125, lng:-10.9693968},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>시에라리온-코이두</h1>코이두는 시에라리온 동부에 위치한 도시로, 시에라리온에서 네 번째로 큰 도시이며 인구는 87,789명이다. 다이아몬드가 많이 매장되어 있다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://upload.wikimedia.org/wikipedia/commons/2/2d/KoiduStreet.jpg"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:8.871974699999999, lng:-12.0375565},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>시에라리온-마케니</h1>마케니는 시에라리온 중부에 위치한 도시로, 북부주의 주도이며 봄발리구의 행정 중심지이다. <br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://upload.wikimedia.org/wikipedia/commons/thumb/4/42/Makeni%2C_Sierra_Leone_-_Mapillary_%28PTorXQnlRBZ7KlI3olHDAw%29.jpg/220px-Makeni%2C_Sierra_Leone_-_Mapillary_%28PTorXQnlRBZ7KlI3olHDAw%29.jpg"  width="400px" height="auto"></a></div></div>',
        },
        // 싱가포르  
        {
            coords:{lat:1.352083, lng:103.819836},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>싱가포르-싱가포르</h1>싱가포르 공화국, 줄여서 싱가포르는 동남아시아, 말레이 반도의 끝에 위치한 섬나라이자 항구 도시로 이루어진 도시 국가이다. <br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://youimg1.tripcdn.com/target/100i0x000000lcy8zC02B_C_640_320_R5_Q70.jpg_.webp?proc=source%2Ftrip"  width="400px" height="auto"></a></div></div>',
        },
        // 아랍에미리트
        {
            coords:{lat:24.453884, lng:54.3773438},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>아랍에미리트-아부다비</h1>아부다비는 아랍에미리트의 수도이다. 아라비아 반도의 아라비아 해안에 위치하고, 아랍에미리트를 구성하는 토후국 가운데 하나인 아부다비 토후국의 수도이다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="http://t3.gstatic.com/licensed-image?q=tbn:ANd9GcQrCDCNAAaQK_s3U3nSB-YsR599ZmxudNoiDQBlzAO1TW-W4BWFczkEX_Eq1MrUFdju"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:25.2048493, lng:55.2707828},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>아랍에미리트-두바이</h1>두바이는 페르시아 만 남동쪽 해안에 위치한 아랍에미리트의 최대 도시이다. 아랍에미리트를 구성하는 7개의 토후국 가운데 하나인 두바이 토후국의 수도이다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="http://t1.gstatic.com/licensed-image?q=tbn:ANd9GcTnavcE0R1cW9vbZSJU9A_92W41dYEqmnQRVz51osw9lq-dYLXMRz2uqIIL1LrWzvQN"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:24.1301619, lng:55.8023118},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>아랍에미리트-알아인</h1>알아인은 아랍에미리트 아부다비 토후국에 위치한 도시로, 인구는 650,000명으로 아랍에미리트에서 4번째로 인구가 많은 도시이다. <br><br><div style="width:400px;height:auto;"><a href="#"><img src="http://t3.gstatic.com/licensed-image?q=tbn:ANd9GcQdEayXbYLIGdf2NGtBqnELapqnwegar1LXT49PUpbSflATFZ1yS6E4U5tpN0tkjziB"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:25.8006926, lng:55.9761994},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>아랍에미리트-라스알카이마</h1>라스알카이마는 아랍에미리트를 구성하는 7개의 토후국 가운데 하나인 라스알카이마 토후국의 수도로 인구는 120,347명이다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://upload.wikimedia.org/wikipedia/commons/thumb/f/f9/Ras_al-Khaimah_December_2015_by_Vincent_Eisfeld.jpg/300px-Ras_al-Khaimah_December_2015_by_Vincent_Eisfeld.jpg"  width="400px" height="auto"></a></div></div>',
        },
        // 아르메니아
        {
            coords:{lat:40.1872023, lng:44.515209},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>아르메니아-예레반</h1>예레반은 아르메니아의 수도이자 가장 큰 도시이다. 또한 세계에서 가장 오래 인간이 살아온 도시 중 한 곳이다. 예리반, 예레브니라는 이름으로도 불렸었다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="http://t2.gstatic.com/licensed-image?q=tbn:ANd9GcRmtR-ruZFa49sg_LL5XZk_t3AzB-PVYrXZrv-nb23MD0R62b8_rlwf18iKU3_9Ag2C"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:40.7929026, lng:43.8464971},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>아르메니아-규므리</h1>귬리 또는 규므리는 아르메니아 북서부에 위치한 도시로, 시라크 주의 주도이며 인구는 150,917명이다. <br><br><div style="width:400px;height:auto;"><a href="#"><img src="http://t2.gstatic.com/licensed-image?q=tbn:ANd9GcQyK64MXXc3Kx3PgRPoViE0NASTSdGWtsdivQ3qrvCxHuNBmhSRrG2-ajef7Ffzreux"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:39.20772090000001, lng:46.4067952},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>아르메니아-카판</h1>카판은 아르메니아의 도시로, 슈니크 주의 주도이며 예레반에서 316km 정도 떨어진 곳에 위치한다. <br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://pix10.agoda.net/geo/city/710532/1_710532_02.jpg?ca=6&ce=1&s=1920x822"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:40.8791442, lng:45.1470572},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>아르메니아-이제반</h1>이제반은 아르메니아 북부에 위치한 도시로, 타부시 주의 주도이며 인구는 20,500명이다. <br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://cf.bstatic.com/xdata/images/hotel/270x200/364834343.jpg?k=9930f7db871f4b44274667437e1447770daed5376e786b3fbfa3ae7783eded7f&o="  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:40.13641870000001, lng:45.3023323},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>아르메니아-마르투니</h1>마르투니는 아르메니아 동부 게가르쿠니크주에 위치한 도시로 면적은 10km², 높이는 1,510m, 인구는 12,894명이다. 세반호 남안과 접한다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://upload.wikimedia.org/wikipedia/commons/4/46/Martuni_Armenia%2C_Gegharkunik.jpg"  width="400px" height="auto"></a></div></div>',
        },
        // 아르헨티나
        {
            coords:{lat:-34.6036844, lng:-58.3815591},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>아르헨티나-부에노스아이레스</h1>부에노스아이레스는 아르헨티나의 수도이며 가장 큰 도시이다. 남아메리카 동남부 라플라타 강의 하구에 자리한 항구 도시이며, 남아메리카에서 가장 큰 도시 중의 하나이다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="http://t3.gstatic.com/licensed-image?q=tbn:ANd9GcRqc79XsVXU4gALwRu9sU9SkBvF16FLTudA_Vpgq4vw8SH-iRsJzm2Yu6ZAqNqMZxXX"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:-32.9587022, lng:-60.69304159999999},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>아르헨티나-로사리오</h1>로사리오는 산타페주에 있는 아르헨티나 제3의 도시이다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="http://t0.gstatic.com/licensed-image?q=tbn:ANd9GcS264uax2l-vfDaqczwM8VoOEEDJWn-SMfKuRrYqsJpp2sKZ8J62V8CmOc4Y90GEyLM"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:-31.42008329999999, lng:-64.1887761},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>아르헨티나-코르도바</h1>코르도바는 아르헨티나 코르도바 주의 주도이다. 제2차 세계 대전 후 자동차·항공기 공업이 발달하여, 이 나라의 대표적인 공업 도시로 되었다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="http://t2.gstatic.com/licensed-image?q=tbn:ANd9GcS40ZYDTd5MqWQyf0aXvaXo0SLDeUC1McdtfOhGKgmr_M4VxCQjr51m9_JudL2S1Fru"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:-38.0054771, lng:-57.5426106},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>아르헨티나-마르델플라타</h1>마르델플라타는 아르헨티나의 수도 부에노스아이레스에서도 서남쪽 400km 해안에 있는 유명한 해수욕장이자 관광지이다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="http://t3.gstatic.com/licensed-image?q=tbn:ANd9GcS-OXPiLKY2I56yCrMJAa7vxmj3uFo-15P95b4JrEmmA4rSkdWfXs4an54UiYELL-wS"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:-24.7821269, lng:-65.4231976},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>아르헨티나-살타</h1>살타는 아르헨티나 북서부에 위치한 살타주의 주도이다. 메트로폴리탄 지역을 따라 인구 46만 4천 678명이 거주를 하며, 아르헨티나의 규모면에서 여덟번 째에 해당하는 도시이다. <br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://q-xx.bstatic.com/xdata/images/hotel/max1024x768/54461541.jpg?k=fb007ab9a7710921fbf8427d0107194465875d0e33b598b08b46aa513801acad&o="  width="400px" height="auto"></a></div></div>',
        },
        // 아이슬란드
        {
            coords:{lat:64.146582, lng:-21.9426354},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>아이슬란드-레이캬비크</h1>레이캬비크는 아이슬란드의 수도이자 회뷔드보르가르스바이디의 행정 중심지인 도시이다. <br><br><div style="width:400px;height:auto;"><a href="#"><img src="http://t0.gstatic.com/licensed-image?q=tbn:ANd9GcRkNm2fsP9Jcy4lwOQNrYxPNR_FU25MhCn2f0dHa8m6_dnhzsFsyBdFpTEIQ4sEs0q3"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:63.4186315, lng:-19.0060479},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>아이슬란드-비크이뮈르달</h1>비크는 아이슬란드 최남단에 위치한 도시로 정식 명칭은 비크이뮈르달이며 인구는 291명이다. <br><br><div style="width:400px;height:auto;"><a href="#"><img src="http://t1.gstatic.com/licensed-image?q=tbn:ANd9GcRBm-iktOXAEJSPYexFnikBxdPJRCIEl9H-uR5_TCN3zAGi3etKO_fzrghyTfZ7qfiF"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:65.2668743, lng:-14.3948469},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>아이슬란드-에이일스타디르</h1>에이일스스타디르는 아이슬란드 동부에 위치한 도시로, 인구는 2,257명이다. 행정 구역상으로는 외이스튀를란드에 속한다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://upload.wikimedia.org/wikipedia/commons/thumb/d/dd/Egilsstadir_Iceland.JPG/250px-Egilsstadir_Iceland.JPG"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:66.0449706, lng:-17.3383443},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>아이슬란드-후사비크</h1>후사비크는 아이슬란드 북부 연안에 위치한 도시로 인구는 2,237명이다. <br><br><div style="width:400px;height:auto;"><a href="#"><img src="http://t1.gstatic.com/licensed-image?q=tbn:ANd9GcR9su9jAJlzxIjVh_8qTcrKZYzJ5bxFevhJbHtY0HSCSl5yAPXCS2LSNbpwk8vKBLn5"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:65.66009249999999, lng:-20.2796587},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>아이슬란드-블뢴뒤오스</h1>블뢴뒤오스는 아이슬란드 북부에 위치한 도시로 면적은 183km², 인구는 881명이다. <br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://upload.wikimedia.org/wikipedia/commons/thumb/d/d9/Blonduos4.jpg/250px-Blonduos4.jpg"  width="400px" height="auto"></a></div></div>',
        },
        // 아이티
        {
            coords:{lat:18.594395, lng:-72.3074326},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>아이티-포르토프랭스</h1>포르토프랭스는 인구 약 84만 6200명의 아이티의 수도이자 가장 큰 도시이다. 도시 이름은 프랑스어로 "왕자의 항구"를 뜻한다. <br><br><div style="width:400px;height:auto;"><a href="#"><img src="http://t2.gstatic.com/licensed-image?q=tbn:ANd9GcRfu61mHZI2HXMpi5wShH0gVujbeS4tYFJJAkIm3_DSigYmfE-9LaIs26-7Tsnub55m"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:19.7370362, lng:-72.20676809999999},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>아이티-카프아이시앵</h1>카프아이시앵은 아이티의 도시이다. 2003년 인구는 11만명이며, 북부 주의 주청 소재지이다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="http://t1.gstatic.com/licensed-image?q=tbn:ANd9GcSCWFFmJjQcjqbq1atgEOr8mb8GPNYVJITpp3IWVegaJ_FdyAlKSMNYLS2ugzvphqj0"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:18.2430063, lng:-72.52639839999999},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>아이티-자크멜</h1>자크멜은 아이티 남부에 위치한 도시로 남동부 주의 주도이며 면적은 443.88km², 높이는 43m, 인구는 170,289명, 인구 밀도는 384명/km²이다. <br><br><div style="width:400px;height:auto;"><a href="#"><img src="http://t1.gstatic.com/licensed-image?q=tbn:ANd9GcQmmquKAQtdauVeaBvUp8DE2qmzyFruzfqb1OABPc42OFQsvDlqbE1qKZJbgtlwCj0e"  width="400px" height="auto"></a></div></div>',
        },
        // 아일랜드
        {
            coords:{lat:53.3498053, lng:-6.2603097},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>아일랜드-더블린</h1>더블린은 아일랜드의 수도이자 최대 도시이다. 더블린은 아일랜드어로 Baile Átha Cliath 불리며 그 뜻은 단단히 다진 땅의 도시라는 뜻을 갖고 있다. <br><br><div style="width:400px;height:auto;"><a href="#"><img src="http://t3.gstatic.com/licensed-image?q=tbn:ANd9GcT3gfaKbCl9h0gplrhrZXatTan7HLbmofmvo7IuBGogeInMOS-P0NHgmMIparFgho9s"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:53.270668, lng:-9.0567905},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>아일랜드-골웨이</h1>골웨이는 아일랜드 골웨이주의 주도이며, 아일랜드 제3의 도시이다. 면적은 54.2km²이며 인구는 2006년 기준 72,729명이다. 매년 골웨이 국제 굴 축제가 열린다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="http://t3.gstatic.com/licensed-image?q=tbn:ANd9GcRhl9zPcHA2P7cAG0OY3sygIoSrL_gXYClchH7Otka6OplUtGO1CR6k-rbrOD0LEQL1"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:52.6638367, lng:-8.6267343},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>아일랜드-리머릭</h1>리머릭은 아일랜드의 도시로, 인구는 약 9만 1천명이다. 서안에 있어서의 항구로서 중요한 역할을 하며, 예로부터 공업과 상업의 중심으로 되어 있다. <br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://media.istockphoto.com/photos/limerick-picture-id1044936938"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:51.8985143, lng:-8.4756035},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>아일랜드-코크</h1>코크는 아일랜드의 도시이다. 아름다운 리강의 하구에 있으며, 이 나라 남부 정치 경제의 중심이자 중요한 국제항이다. <br><br><div style="width:400px;height:auto;"><a href="#"><img src="http://t0.gstatic.com/licensed-image?q=tbn:ANd9GcQPCjXDqd-FphBC0TNI94Vz-TXFORfC8cFjZaWWYW5whaVX2LC6nAyPuTUGbRKMdXwA"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:53.4282006, lng:-7.953178599999999},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>아일랜드-알트론</h1>애슬론은 아일랜드 웨스트미스주와 로스커먼주에 걸쳐 있는 도시이다. 2011년 인구조사 결과 인구는 20,153명이었다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="http://t0.gstatic.com/licensed-image?q=tbn:ANd9GcSRUEYTYL0aghaZ3f94q25y6Re1qogmnxNohMTG9KQ1X_U8o2bCFEXt_esCS1K1dSYL"  width="400px" height="auto"></a></div></div>',
        },
        // 아제르바이잔
        {
            coords:{lat:40.40926169999999, lng:49.8670924},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>아제르바이잔-바쿠</h1>바쿠는 아제르바이잔의 수도이다. 카스피 해 서쪽에 뻗어 있는 압셰론 반도에 위치하고, 시가지는 반도 남쪽의 바쿠 만에 접한 항구 도시이다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="http://t0.gstatic.com/licensed-image?q=tbn:ANd9GcQ0D_WKwN09neI6JL37-wxJEcqbhAPL8jaVi8OUrZlHEGGthPEYQZbm6OR2XVIwPhfz"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:40.6878581, lng:46.3723313},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>아제르바이잔-간자</h1>간자는 아제르바이잔의 도시로 인구는 30만 명이다. 아제르바이잔에서 인구가 두 번째로 많은 도시이다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="http://t2.gstatic.com/licensed-image?q=tbn:ANd9GcRYaKw94BdxSGAi66STQ6oJawccFTNRuqX7pOTrhn5SIalC_59Zbz8K0jF7hm76GH55"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:40.63187310000001, lng:48.6363801},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>아제르바이잔-샤마흐</h1>샤마흐는 아제르바이잔의 도시로 샤마흐 구의 행정 중심지이며 면적은 6km², 높이는 709m, 인구는 31,704명이다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="http://t1.gstatic.com/licensed-image?q=tbn:ANd9GcTAhwMhKTWz4v3ZsOd18SPu0gFv3qXXV_w0az-HjhdYuUc6nJ110_3wid7AHFhKzFLm"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:39.9265747, lng:48.9205727},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>아제르바이잔-시르반</h1>시르반은 아제르바이잔의 도시로, 면적은 30km², 인구는 75,453명이다. 쿠라 강과 접하고 있고 2008년 이전까지는 엘리바이람르라는 이름으로 알려지기도 했다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://upload.wikimedia.org/wikipedia/commons/d/d8/Shirvan_city.jpg"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:42.8204751, lng:19.5240814},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>아제르바이잔-게벨레</h1>게벨레는 아제르바이잔의 도시로 게벨레 구의 행정 중심지이며 면적은 1,548km², 높이는 783m, 인구는 12,808명이다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://youimg1.tripcdn.com/target/ww091f000001gqsje3297_C_640_320_R5_Q70.png_.webp"  width="400px" height="auto"></a></div></div>',
        },
        // 아프가니스탄
        {
            coords:{lat:34.5553494, lng:69.207486},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>아프가니스탄-카불</h1>카불은 아프가니스탄의 수도이자 가장 큰 도시이다. 아프가니스탄 동쪽의 카불 주에 있으며 카불 주의 주도이기도 하다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="http://t3.gstatic.com/licensed-image?q=tbn:ANd9GcR1yYh65j6ZgfQQNQTVCuFxGPkOx--eBWwooyFU41QaoR0XMpudBqG69RqZuqLqqjHI"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:31.628871, lng:65.7371749},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>아프가니스탄-칸다하르</h1>칸다하르는 아프가니스탄에서 두 번째로 인구가 많은 도시로 칸다하르 주의 주도이다. 해발 약 1,000미터에 있다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="http://t1.gstatic.com/licensed-image?q=tbn:ANd9GcQxDD3jdVj1plrjweTllYkCVxJaBylJOx19oyfpCXNH1eO1OT6ix4963D-_D993-1As"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:34.352865, lng:62.20402869999999},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>아프가니스탄-헤라트</h1>헤라트는 서부 아프가니스탄의 헤라트 주의 주도이다. 그곳은 하리 강의 계곡에 위치한다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="http://t3.gstatic.com/licensed-image?q=tbn:ANd9GcTjIPE0enoeJ3FTWcwolCMSxGZJ5KZB99sK_qAydolMok847HDl0MJ66iuRAekzzN6G"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:36.69261669999999, lng:67.1179511},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>아프가니스탄-마자르이샤리프</h1>마자르-이-샤리프는 아프가니스탄 북부에서 가장 큰 도시이고 발흐 주의 주도이다. 마자르이샤리프에서 사용되는 언어는 다리어이다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://media.istockphoto.com/photos/mazarisharif-balkh-province-shrine-of-ali-one-of-afghanistans-most-picture-id1340971758?k=20&m=1340971758&s=612x612&w=0&h=HxlXVXjGfWEsOyiYWFhv-0EEBuvlgLX2FyDCzRzPjzc="  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:31.6095648, lng:64.4082082},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>아프가니스탄-라슈카르가</h1>라슈카르가는 아프가니스탄 남부에 위치한 도시로, 헬만드 주의 주도이며 인구는 201,546명이다. <br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://upload.wikimedia.org/wikipedia/commons/6/6a/Mosque_in_Lashkar_Gah.jpg"  width="400px" height="auto"></a></div></div>',
        },
        // 안도라
        {
            coords:{lat:42.506285, lng:1.521801},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>안도라-안도라</h1>안도라 공국, 줄여서 안도라는 유럽의 카탈루냐와 프랑스 사이에 있는 공국이다. 468 평방 킬로미터의 작은 나라이며 프랑스 대통령과 스페인 카탈루냐 지방의 교구인 우르젤의 주교가 공동영주로서 지배하는 나라이다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://youimg1.tripcdn.com/target/100b0e00000078w5l95B6_C_640_320_R5_Q70.jpg_.webp?proc=source%2Ftrip"  width="400px" height="auto"></a></div></div>',
        },
        // 알바니아
        {
            coords:{lat:41.3275459, lng:19.8186982},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>알바니아-티라나</h1>티라나는 알바니아의 수도로, 아드리아 해와 접해 있는 두러스에서 동쪽으로 35km 정도 떨어진 곳에 위치한다. 티라나 주의 주도이자 티라나 현의 현청 소재지이다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://cdn.travie.com/news/photo/201808/20487_1119_2155.jpg"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:41.0365342, lng:20.0926112},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>알바니아-엘바산</h1>엘바산은 알바니아 중부에 위치한 도시로, 엘바산 주의 주도이자 엘바산 현의 현청 소재지이다. 엘바산 문자가 발명된 곳으로 유명하다. 목재 가공업과 시멘트, 비누, 올리브유, 담배 생산이 주요 산업이며 부근에서 니켈이 채굴된다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://media.istockphoto.com/photos/view-of-prrenjas-town-in-elbasan-albania-picture-id1011276370"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:40.4660668, lng:19.491356},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>알바니아-블로러</h1>블로러 또는 블로라는 알바니아 남서부에 위치한 도시로, 블로러 주의 주도이자 블로러 현의 현청 소재지이며 인구는 124,000명이다. 이탈리아어로는 발로나라고 부르기도 한다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://storage.doopedia.co.kr/upload/_upload/image5/2108/31/210831023977730/210831023977730_thumb_400.jpg"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:42.0692985, lng:19.5032559},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>알바니아-쉬코드라</h1>Shkodër 또는 Shkodra는 알바니아 북서부의 도시이자 자치체입니다. Shkodër 또는 Shkodra는 다음을 참조할 수도 있습니다. Shkodër County, 알바니아의 1급 행정 구역 알바니아의 이전 행정 구역인 Shkodër 지구 남유럽에서 가장 큰 호수인 슈코더 호수<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://t1.daumcdn.net/thumb/R720x0/?fname=http://t1.daumcdn.net/brunch/service/user/4wQw/image/uv5w5BAuOqT02F-sf6zrlJ-Gpo8.jpg"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:40.6140785, lng:20.7778071},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>알바니아-코르처</h1>코르처 또는 코르차는 알바니아 남동부에 위치한 도시로, 코르처 주의 주도이자 코르처현의 현청 소재지이며 인구는 57,758명이다. 그리스 국경과 가까운 편이며 알바니아에서 7번째로 큰 도시이다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://storage.doopedia.co.kr/upload/_upload/image5/2108/31/210831023978398/210831023978398_thumb_400.jpg"  width="400px" height="auto"></a></div></div>',
        },
        // 알제리
        {
            coords:{lat:36.753768, lng:3.0587561},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>알제리-알제</h1>알제는 북아프리카의 알제리의 수도이며 알제리 최대의 도시이다. 서지중해에 접해 있다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://dynamic-media-cdn.tripadvisor.com/media/photo-o/07/60/5b/58/great-view.jpg?w=700&h=500&s=1"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:33.8078341, lng:2.8628294},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>알제리-라구아트</h1>라구아트는 알제리 북동부에 위치한 도시로 라구아트 주의 주도이며 면적은 400km², 높이는 769m, 인구는 134,372명, 인구 밀도는 340명/km²이다. 수도 알제에서 남쪽으로 400km 정도 떨어진 곳에 위치한다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://youimg1.tripcdn.com/target/0ww3w120009561cbt197B_C_380_240_R5.jpg"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:35.6987388, lng:-0.6349319},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>알제리-오랑</h1>오랑은 알제리 북서부에 위치한 도시로 면적은 2,121km², 인구는 1,560,329명이다. 오랑주의 주도이며 알제리의 수도인 알제에서 432km 정도 떨어진 곳에 위치한다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://dynamic-media-cdn.tripadvisor.com/media/photo-o/10/5d/ac/67/oran3.jpg?w=700&h=500&s=1"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:36.9142081, lng:7.742667300000001},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>알제리-안나바</h1>안나바는 튀니지와 국경을 접하는 알제리 북동부 항구도시로 안나바 주의 주도다. 2002년 추정 인구는 258053명이다. 알제리에서 네 번째로 가장 큰 도시다. 고도는 0m다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://storage.doopedia.co.kr/upload/_upload/image5/2206/29/220629024345119/220629024345119_thumb_400.jpg"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:36.1579664, lng:1.3372823},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>알제리-츨레프</h1>슐레프는 알제리 북부에 위치한 도시로 슐레프 주의 주도이며 인구는 178,616명이다. 수도 알제에서 서쪽으로 약 200km 정도 떨어진 곳에 위치한다. 로마 제국 시대에 카스텔룸 팅기타눔이라는 요새가 세워졌으며 1834년 프랑스에 의해 오를레앙빌이라는 도시가 건설되었다. <br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://mediaim.expedia.com/destination/1/0eb47d1f1597a83b7884e1cad9991d94.jpg?impolicy=fcrop&w=400&h=225&q=mediumLow"  width="400px" height="auto"></a></div></div>',
        },
        // 앙골라
        {
            coords:{lat:-8.8146556, lng:13.2301756},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>앙골라-루안다</h1>루안다는 앙골라의 수도이다. 대서양에 접한 앙골라의 주요 항 임과 동시에 행정중심지이기도 하다. 거의 300만명의 인구가 루안다에 살고 루안다 주의 주도이기도 하다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://newsimg.sedaily.com/2018/07/06/1S1ZA4TP7Y_3.jpg"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:-12.5905158, lng:13.416501},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>앙골라-벵겔라</h1>벵겔라는 아프리카 남서부 앙골라 서안에 있는 항구 도시로, 벵겔라 주의 주도이다. 1617년에 만들어졌으며 노예 무역의 일대 중심지였다. 커피, 고무 등을 수출한다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://upload.wikimedia.org/wikipedia/commons/7/71/Beach_of_Coatinha_in_Benguela%2C_Angola.jpg"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:-9.539572, lng:16.3388643},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>앙골라-말란즈</h1>말란즈는 앙골라의 도시로, 말란즈 주의 주도이며 인구는 약 222,000명이다. 1975년 이전까지는 세르파핀투라는 이름으로 알려지기도 했다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://mediaim.expedia.com/destination/2/dbf27c8deb9778c492d99c63b87e131b.jpg?impolicy=fcrop&w=360&h=224&q=mediumLow"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:-12.7739761, lng:15.7468535},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>앙골라-우암부</h1>우암부 주는 앙골라의 주로, 주도는 우암부이며 면적은 34,270km², 인구는 약 1,900,000명이다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://upload.wikimedia.org/wikipedia/commons/thumb/9/9d/Flag_of_Angola.svg/1200px-Flag_of_Angola.svg.png"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:-14.6594083, lng:17.6984879},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>앙골라-메농그</h1>메농그는 앙골라의 도시로, 쿠안두쿠방구 주의 주도이며 인구는 약 19,000명이다. 모사메드스와 연결되는 철도의 종점이다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://pds.joongang.co.kr/news/component/htmlphoto_mmdata/201706/22/af5ab18e-e8c6-4ccb-bb30-bd8fe4a5cb27.jpg"  width="400px" height="auto"></a></div></div>',
        },
        // 앤티가바부다
        {
            coords:{lat:17.060816, lng:-61.796428},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>앤티가바부다-앤티가바부다</h1>앤티가 바부다는 카리브해와 대서양을 끼고 있는 섬나라이자 영국 연방의 회원국이다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://dynamic-media-cdn.tripadvisor.com/media/photo-o/0a/57/53/77/photo0jpg.jpg?w=700&h=500&s=1"  width="400px" height="auto"></a></div></div>',
        },
        // 에스와티니
        {
            coords:{lat:-26.3054482, lng:31.1366715},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>에스와티니-음바바네</h1>음바바네는 에스와티니의 수도이다. 2003년 통계로는 7만 명이 거주하고 있는 것으로 조사되었다. 음바바네 강과 음딤바 산맥에 있는 폴린자네 강 지류에 있다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://storage.doopedia.co.kr/upload/_upload/image5/2206/29/220629024344291/220629024344291_thumb_400.jpg"  width="400px" height="auto"></a></div></div>',
        },
        // 에콰도르
        {
            coords:{lat:-0.1806532, lng:-78.4678382},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>에콰도르-키토</h1>키토는 에콰도르의 수도이다. 과야킬 다음으로 인구가 많다. 피친차 주의 주도이기도 하다. 적도 가까이에 위치하고 있지만, 안데스 산맥의 산 중턱 에 있기 때문에 비교적 시원하다. 인구는 1,978,376명 이다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://media.istockphoto.com/photos/cityscape-of-the-historic-center-of-quito-ecuador-picture-id1274404993"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:-2.1894128, lng:-79.8890662},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>에콰도르-과야킬</h1>과야킬, 정식 명칭 산티아고 데 과야킬은 에콰도르 과야스 주의 주도·항구도시이자, 에콰도르에서 가장 큰 도시이다. 과야스 강의 서쪽에 과야킬 만이 태평양에 접하는 곳에 자리해 있다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://mediaim.expedia.com/destination/1/de36e92aa1599c96ee252e820af1d920.jpg?impolicy=fcrop&w=360&h=224&q=mediumLow"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:-0.2538414, lng:-79.1763307},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>에콰도르-산토도밍고</h1>산토도밍고 또는 산토도밍고데로스콜로라도스는 에콰도르 산토도밍고데로스차칠라스 주의 주도로 면적은 1,092.89 km², 인구는 305,632명, 해발고도는 625m, 인구 밀도는 280명/km²이다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://cdn.pixabay.com/photo/2019/02/28/19/36/church-4026665_960_720.jpg"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:-3.2581112, lng:-79.9553924},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>에콰도르-마찰라</h1>마찰라는 에콰도르 남서부에 위치한 도시로 엘오로 주의 주도이며 면적은 207.09km², 인구는 241,606명, 높이는 6m, 인구 밀도는 1,200명/km²이다. 과야킬 만의 비옥한 저지대에 위치하며 "세계의 바나나의 수도"라는 별칭으로 부르기도 한다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://dynamic-media-cdn.tripadvisor.com/media/photo-o/01/03/31/ab/parque-juan-montalvo.jpg?w=500&h=300&s=1"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:-2.9001285, lng:-79.00589649999999},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>에콰도르-쿠엥카</h1>쿠엥카는 에콰도르 중남부에 위치한 도시로 아수아이 주의 주도이며 면적은 70.59km², 높이는 2,560m, 인구는 400,000명이다. 정식 명칭은 산타아나데로스쿠아트로리오스데쿠엥카이다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://media.istockphoto.com/photos/view-of-the-city-of-cuenca-picture-id614430422"  width="400px" height="auto"></a></div></div>',
        },
        // 에리트레아
        {
            coords:{lat:15.3228767, lng:38.9250517},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>에리트레아-아스마라</h1>아스마라는 에리트레아의 수도이다. 인구는 2009년 기준 64만 9천 명이다. 고도 2,325m에 위치한 고원 도시이다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://www.hotelscombined.co.kr/rimg/dimg/de/4c/12f3e11b-city-1809-16d71922618.jpg?width=1366&height=768&xhint=1885&yhint=1145&crop=true"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:15.6080391, lng:39.45310690000001},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>에리트레아-마사와</h1>마사와는 홍해 북부 주의 주도이며 에리트레아에서 아스마라에 이어 두 번째로 큰 도시다. 2004년 기준 인구는 36700명이고 고도는 63m다. 철도로써 아스마라와 이어져 있다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT36qIi2CqEkjmsgKbk5hsGb2X_MMYms-iy1A&usqp=CAU"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:16.6663939, lng:38.47651400000001},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>에리트레아-낙파</h1>에리트레아 낙파는 에리트레아의 통화이다. 1 낙파는 100 센트로 나뉜다. ISO 4217 부호는 "ERN"이다. 통화 이름은 낙파라는 이름의 도시에서 유래된 이름이다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRo34JWM6-tXhP7rbS4QeRH0yOGmBLCNHgn71rYh7BD4nkmJFxmRaucYr3CinQzDdBUPVI&usqp=CAU"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:15.1093615, lng:37.5895692},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>에리트레아-바렌투</h1>바렌투는 에리트레아 남서부에 위치한 도시로 가시바르카 주의 주도이며 높이는 1,032m이고, 인구는 20,968명이다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://media.istockphoto.com/photos/barentu-street-arcade-for-retail-commerce-and-the-grande-mosque-picture-id1305106025"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:14.8841369, lng:38.812898},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>에리트레아-멘데페라</h1>멘데페라는 에리트레아의 도시로 남부 주의 주도이며 높이는 1,972m, 인구는 25,332명이다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://mblogthumb-phinf.pstatic.net/20140810_298/braveattack_1407639473996vk3cR_JPEG/Eritrea_Train_Mountain_Tunnel.jpg?type=w2"  width="400px" height="auto"></a></div></div>',
        },
        // 에스토니아
        {
            coords:{lat:59.43696079999999, lng:24.7535746},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>에스토니아-탈린</h1>탈린은 에스토니아의 수도이며, 발트해의 핀란드 만 연안에 있는 항만 도시로서 공업의 중심지이다. 모터·수은 정류기·라디오·굴착기·케이블·직물 등의 공장이 있다. 40만여 명이 살고 있다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://d3b39vpyptsv01.cloudfront.net/photo/1/2/5c87937143b8fb7af44b819abb7cbe67.jpg"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:58.88785799999999, lng:25.5411706},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>에스토니아-파이데</h1>파이데는 에스토니아 얘르바 주의 주도로, 면적은 10.036km2, 인구는 8,868명(2012년 1월 1일 기준)이다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://storage.doopedia.co.kr/upload/_upload/image5/2103/13/210313023743287/210313023743287_thumb_400.jpg"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:57.84250170000001, lng:27.0059657},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>에스토니아-버루</h1>버루는 에스토니아 남동부에 위치한 도시로, 버루 주의 주도이며 면적은 13.24km², 인구는 14,554명, 인구 밀도는 1,099.2명/km²이다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://mediaim.expedia.com/destination/1/cd3c693a27c7b739cf4e15659d950c02.jpg?impolicy=fcrop&w=360&h=224&q=mediumLow"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:58.37798299999999, lng:26.7290383},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>에스토니아-타르투</h1>타르투는 에스토니아에서 두 번째로 큰 도시로 인구는 98,449명이고 면적은 38.8 km²이다. 타르투 대학교가 위치해 있고 탈린에서 남동쪽으로 186km 떨어져 있다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://media.istockphoto.com/photos/-picture-id1049888626"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:57.78145679999999, lng:26.0550403},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>에스토니아-발가</h1>발가는 에스토니아 남부에 위치한 도시로, 발가 주의 주도이며 면적은 16.54km², 인구는 13,692명, 인구 밀도는 830명/km²이다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://dynamic-media-cdn.tripadvisor.com/media/photo-o/04/4c/eb/97/greete-motell.jpg?w=600&h=400&s=1"  width="400px" height="auto"></a></div></div>',
        },
        // 에티오피아
        {
            coords:{lat:8.9806034, lng:38.7577605},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>에티오피아-아디스아바바</h1>아디스아바바 또는 아디스아베바는 에티오피아의 수도이자 최대 규모의 도시로, 그 이름은 암하라어로 「새로운 꽃」이라는 뜻이다. 오로모어로 핀피네라고 일컫기도 한다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://www.hotelscombined.co.kr/rimg/dimg/e9/d3/52a1c197-city-31584-165624937c9.jpg?width=1366&height=768&xhint=1972&yhint=1277&crop=true"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:11.5742086, lng:37.3613533},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>에티오피아-바히르다르</h1>바히르다르는 에티오피아 북서부에 위치한 도시로 암하라 주의 주도이며 면적은 28km², 높이는 1,800m, 인구는 318,429명, 인구 밀도는 12,000명/km²이다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://www.hotelscombined.co.kr/rimg/dimg/3a/44/4e357c34-city-51869-1730416b382.jpg?width=1366&height=768&xhint=1250&yhint=1623&crop=true"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:9.6008747, lng:41.850142},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>에티오피아-디레다와</h1>디레다와는 에티오피아의 특별시이지만 수도는 아니다. 2002년 통계에 따르면 164,851명이 거주한다. 디레다와는 에티오피아 동부의 해발 1,300m에 있는 도시인데, 에티오피아의 커피 주요 산지이기도 한 디레다와는 예로부터 발달된 상업도시다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="http://image.newsis.com/2022/04/30/NISI20220430_0018753116_web.jpg"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:13.4935504, lng:39.465738},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>에티오피아-메켈레</h1>메켈레는 에티오피아 북부에 위치한 도시로 티그레 주의 주도이며 면적은 54.44km², 높이는 2,084m, 인구는 480,217명, 인구 밀도는 8,800명/km²이다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://blog.kakaocdn.net/dn/dnk4dI/btqOvSzEnMW/IEMXVCxX4BKkJ5ezMJQ1HK/img.jpg"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:7.050374199999999, lng:38.4955043},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>에티오피아-아와사</h1>아와사는 에티오피아 남부에 위치한 도시로 시다마주와 남부국민민족인민주의 공동 주도이며 시다마주에 속한다. 면적은 50km², 높이는 1,708m, 인구는 165,275명, 인구 밀도는 3,300명/km²이다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://www.hotelscombined.co.kr/rimg/dimg/fa/29/6ef2c144-city-51854-17273122a11.jpg?width=1366&height=768&xhint=1499&yhint=2739&crop=true"  width="400px" height="auto"></a></div></div>',
        },
        // 영국
        {
            coords:{lat:51.5072178, lng:-0.1275862},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>영국-런던</h1>런던은 영국과 잉글랜드의 수도이자 최대 도시이다. 인구는 2014년 기준 8,538,689명으로 영국은 물론 유럽 전체 대도시권 중 가장 큰 권역이며, 음역어로는 倫敦이라 부른다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://cdn.jbsori.com/news/photo/202012/2516_4208_299.jpg"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:52.6292567, lng:1.2978802},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>영국-노리치</h1>노리치는 영국 잉글랜드 동부 이스트앵글리아의 도시로, 노퍽주의 주도이다. 면적은 약 39km², 인구는 약 13만명, 도시권 인구는 약 26만명이다. 이스트앵글리아 대학이 소재해 있다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://img.hankyung.com/photo/202205/PYH2022052300570034000_P4.jpg"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:52.48624299999999, lng:-1.890401},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>영국-버밍엄</h1>버밍엄은 영국 잉글랜드 중부에 위치한 도시이다. 도시 인구 110만 명, 광역권 인구는 380만 명으로, 영국과 잉글랜드 모두에서 두번째로 가장 큰 도시이자 광역권이다. <br><br><div style="width:400px;height:auto;"><a href="#"><img src="http://economychosun.com/query/upload/166/166_23.jpg"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:53.38112899999999, lng:-1.470085},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>영국-셰필드</h1>셰필드는 영국 잉글랜드 사우스요크셔주의 도시이다. 철강 공업의 중심 도시이다. 16세기부터 훌륭한 강철을 생산하며 현재도 특수강의 중요한 산지이다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://previews.123rf.com/images/sakhaphotos/sakhaphotos1504/sakhaphotos150400015/39491405-%EC%85%B0%ED%95%84%EB%93%9C-%ED%83%80%EC%9A%B4-%ED%99%80-%EC%85%B0%ED%95%84%EB%93%9C-%EC%98%81%EA%B5%AD%EC%9D%98-%EB%8F%84%EC%8B%9C%EC%97%90%EC%9E%88%EB%8A%94-%EA%B1%B4%EB%AC%BC%EC%9E%85%EB%8B%88%EB%8B%A4-.jpg"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:53.4807593, lng:-2.2426305},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>영국-맨체스터</h1>맨체스터는 영국의 도시이다. 리버풀 동북쪽 약 50 km, 머지 강의 지류인 어웰 강과 아크 강의 합류점에 위치해 있다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://dynamic-media-cdn.tripadvisor.com/media/photo-o/06/3d/31/60/manchester-town-hall.jpg?w=700&h=-1&s=1"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:53.4083714, lng:-2.9915726},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>영국-리버풀</h1>리버풀은 잉글랜드 북서부 머지사이드주의 도시로 2015년 기준으로 인구는 478,580 명이다. 머지 강 어귀의 동쪽에 자리잡고 있다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://dimg.donga.com/ugc/CDB/WEEKLY/Article/5c/f9/b6/05/5cf9b6050913d2738de6.jpg"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:53.8007554, lng:-1.5490774},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>영국-리즈</h1>리즈는 영국 잉글랜드 웨스트요크셔주의 도시이다. 요크셔 지방 최대의 도시로서 에어 강에 향해 있으며 잉글랜드의 동서양 해안의 거의 중간에 자리잡고 있는데 양안과 일찍부터 운하로 연결되어 있었다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://us.123rf.com/450wm/sakhaphotos/sakhaphotos1406/sakhaphotos140600008/29327284-%EB%A6%AC%EC%A6%88-%ED%83%80%EC%9A%B4-%ED%99%80-%EB%A6%AC%EC%A6%88-%EC%98%81%EA%B5%AD-%EC%8B%9C%EB%82%B4-%EC%A4%91%EC%8B%AC%EC%97%90%EC%84%9C-1-%EA%B8%89-%EB%93%B1%EC%9E%AC-%EB%90%9C-%EA%B1%B4%EB%AC%BC%EC%9E%85%EB%8B%88%EB%8B%A4.jpg"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:55.953252, lng:-3.188267},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>영국-에든버러</h1>에든버러, 또는 에딘버러는 스코틀랜드의 수도이며, 글래스고 다음으로 큰 도시다. 1437년 스코틀랜드의 수도가 되었으며, 이후 스코틀랜드의 문화, 정치, 교육, 관광의 중심지 역할을 하고 있다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://file.mk.co.kr/meet/neds/2016/07/image_readtop_2016_512206_14687820662549795.jpg"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:55.864237, lng:-4.251806},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>영국-글래스고</h1>래스고는 스코틀랜드 최대의 항구 도시로 면적은 175.5km², 인구는 612,040명, 인구 밀도는 3,298명/km²이다. 2016년 조사 기준의 도시 인구가 612,040명으로, 영국 본토 내에서 세 번째로 큰 도시이다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://dynamic-media-cdn.tripadvisor.com/media/photo-o/0f/c7/ab/93/the-university-of-glasgow.jpg?w=700&h=500&s=1"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:57.1498891, lng:-2.0937528},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>영국-애버딘</h1>애버딘은 영국 스코틀랜드의 해안 도시로, 스코틀랜드의 32개 지방 자치 의회 구역 중 하나이다. 어업과 상업이 발달해 있다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://dynamic-media-cdn.tripadvisor.com/media/photo-o/15/4d/43/c7/aberdeen.jpg?w=700&h=500&s=1"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:54.59728500000001, lng:-5.93012},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>영국-벨파스트</h1>벨파스트는 영국의 도시로, 북아일랜드의 수도이다. 북아일랜드에서 가장 큰 도시로 아일랜드섬에서는 더블린 다음으로 크며, 영국 내에서는 인구 규모 17위이다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://media.istockphoto.com/photos/belfast-city-hall-northern-ireland-united-kingdom-picture-id978261638"  width="400px" height="auto"></a></div></div>',
        },
        // 예멘
        {
            coords:{lat:15.3694451, lng:44.1910066},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>예멘-사나</h1>사나는 아라비아반도 남서부에 있는 예멘의 수도이다. 해발 약 2,350m의 누쿰산 서쪽 기슭에 자리잡고 있으며, 오랜 세월 동안 예멘 제1의 경제·정치·종교 중심지로 여겨졌다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://t1.daumcdn.net/cfile/tistory/2678793358B5547612"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:12.7854969, lng:45.0186548},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>예멘-아덴</h1>아덴은 예멘의 항구 도시이다. 홍해의 아덴 만 연안과 접하며 바브엘만데브 해협에서 동쪽으로 약 170km 정도 떨어진 곳에 위치한다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://img.hankyung.com/photo/202008/AKR20200809045100111_02_i.jpg"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:14.5404328, lng:49.127197},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>예멘-무칼라</h1>무칼라는 아라비아 반도 남부 아덴 만 연안에 있는 예멘의 항구 도시로 하드라마우트 주의 주도이다. 1035년에 설립되었으며 옛부터 인도, 아프리카를 연결하는 무역로로 널리 알려진 곳이다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://upload.wikimedia.org/wikipedia/commons/thumb/8/80/Makulla_from_Hadramaut.jpg/300px-Makulla_from_Hadramaut.jpg"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:13.5775886, lng:44.0177989},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>예멘-타이즈</h1>타이즈는 아라비아 반도 남서부에 위치한 예멘의 도시로, 타이즈주의 주도이며 인구는 460,000명이다. 예멘에서 두 번째로 인구가 많은 도시이며 1948년부터 1962년까지 예멘 왕국의 수도였던 곳이다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://w.namu.la/s/2bc03be83cb7196eea2458a970ab53a0bcc8fe88878f746a5e2563f6015d8ea00de33a261f83da494f7dde278b3fdb66cbbeb479a16bfca81cd5d9c7f3b370f422876cf5adc93a106b0a92a68edfa7ab8bb86f25b1abd7284d172f6c2175850a7ecee86f748cf9d6e79c66cd0eac23f7"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:15.515888, lng:45.4498065},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>예멘-마리브</h1>마리브는 예멘의 도시로 마리브 주의 주도이며 인구는 16,794명이다. 고대 사바 왕국의 수도였던 곳이다. 수도 사나에서 동쪽으로 약 120km 정도 떨어진 곳에 위치한다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://upload.wikimedia.org/wikipedia/commons/thumb/3/3b/Ancient_Ma%27rib_01.jpg/1200px-Ancient_Ma%27rib_01.jpg"  width="400px" height="auto"></a></div></div>',
        },
        // 오만
        {
            coords:{lat:23.5880307, lng:58.3828717},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>오만-무스카트</h1>무스카트는 오만의 수도로, 역사 유적과 자연 풍광, 전통과 현대 문명이 잘 어우러진 항구 도시이다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://img.hankyung.com/photo/201906/AA.19875061.1.jpg"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:24.3500672, lng:56.71332580000001},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>오만-소하르</h1>소하르는 오만 북바티나 주의 주도로 무스카트에서 북쪽으로 200km 정도 떨어진 곳에 위치한다. 페르시아 만과 접한 항구 도시이며 18세기까지 오만의 수도였던 곳이다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://mblogthumb-phinf.pstatic.net/20121228_15/hyun68_1356674704700sesJv_JPEG/P1010124.JPG?type=w2"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:23.2359238, lng:56.49439839999999},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>오만-이브리</h1>이브 리 (Ibri)는 오만 북서쪽에 위치한 주지사 아다 히라 (Ad Dhahirah)의 도시이자 윌 라야 트 (Wilāyat)입니다. <br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://us.123rf.com/450wm/katiekk2/katiekk21805/katiekk2180500007/100954038-2018%EB%85%84-4%EC%9B%94-28%EC%9D%BC-%EC%98%A4%EB%A7%8C-%EC%9D%B4%EB%B8%8C%EB%A6%AC-%EC%95%84%EB%9D%BC%EB%B9%84%EC%95%84-%EB%A7%90%EC%9D%84-%ED%83%80%EA%B3%A0-%EC%9E%88%EB%8A%94-%EC%98%A4%EB%A7%8C-%EC%95%84%EB%B2%84%EC%A7%80%EC%99%80-%EC%95%84%EB%93%A4.jpg?ver=6"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:17.0193843, lng:54.11075049999999},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>오만-살랄라</h1>살랄라는 오만 남부에 위치한 도시로, 도파르 주의 주도이며 인구는 178,469명이다. 오만에서 두 번째로 큰 도시로 항구도시다. 아라비아 반도, 인도양과 접해 있기 때문에 사막 기후와 열대 기후를 띤다. <br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://dynamic-media-cdn.tripadvisor.com/media/photo-o/23/14/d7/0b/caption.jpg?w=600&h=400&s=1"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:22.9171031, lng:57.536292},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>오만-니즈와</h1>니즈와는 오만 다킬리야 주의 주도로 무스카트에서 140km 정도 떨어진 곳에 위치한다. 오만에서 가장 오래된 역사를 자랑하는 도시이며 6세기부터 7세기까지 오만의 수도였던 곳이다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://www.hotelscombined.co.kr/rimg/dimg/45/c7/9e1fef04-city-46610-1713dca359c.jpg?width=1366&height=768&xhint=2630&yhint=2194&crop=true"  width="400px" height="auto"></a></div></div>',
        },
        // 오스트레일리아
        {
            coords:{lat:-34.9284989, lng:138.6007456},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>오스트레일리아-애들레이드</h1>애들레이드는 호주 사우스오스트레일리아주의 주도로, 남극해로 통하는 세인트빈센트 만에 있는 도시이다. 호주 횡단 철도의 출발점으로서, 호주 남부 지역의 중심 도시이자 교통 요지이다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://upload.wikimedia.org/wikipedia/commons/thumb/4/46/Adelaide_DougBarber.jpg/300px-Adelaide_DougBarber.jpg"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:-37.8136276, lng:144.9630576},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>오스트레일리아-멜버른</h1>멜버른 또는 멜번은 오스트레일리아의 도시로, 빅토리아주의 주도이다. 오스트레일리아에서 시드니 다음으로 큰 도시이다. 통칭 멜버른이라고 하면 멜버른 시 포함 주변 대도시권 9,900 km² 를 가리킨다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://img1.daumcdn.net/thumb/R800x0/?scode=mtistory2&fname=https%3A%2F%2Ft1.daumcdn.net%2Fcfile%2Ftistory%2F99F028395B055AC222"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:-33.8688197, lng:151.2092955},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>오스트레일리아-시드니</h1>시드니는 오스트레일리아와 오세아니아에서 가장 인구가 많은 도시 중 하나로써, 도시권의 인구는 약 475만명이다. 그리고 시드니는 뉴사우스웨일스주의 행정도시이며, 오스트레일리아에서 최초로 만들어진 식민지가 있던 자리이다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://t1.daumcdn.net/cfile/tistory/996DB0475A90E2A117"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:-27.4704528, lng:153.0260341},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>오스트레일리아-브리즈번</h1>브리즈번은 오스트레일리아 퀸즐랜드주에서 가장 인구가 많은 도시이자 주도이다. 오스트레일리아 전체에서는 세 번째로 많은 인구를 가진 도시이다<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://p.bookcdn.com/data/Photos/380x204/7665/766571/766571365/Brisbane-City-Yha-photos-Exterior.JPEG"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:-35.2801903, lng:149.1310038},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>오스트레일리아-캔버라</h1>캔버라는 오스트레일리아의 수도이다. 오스트레일리아 내륙에서 가장 큰 도시이며, 전국에서는 8번째로 큰 도시이다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://w.namu.la/s/932c2c49cefab7ee3798800b0fd95c06c56dd0a664a066d36a638c6f282e5c03a74fce7be7c5435e44c93eb81b0a149fb0becda8603ca32fbcad555096eec73166fe47595780a58401168d60f1fbfc7b68b7b59d99f243a514e001bcd6da96fbbaeeb5cda7300fd2f80dfd73930b4cd8"  width="400px" height="auto"></a></div></div>',
        },
        // 오스트리아
        {
            coords:{lat:48.2081743, lng:16.3738189},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>오스트리아-빈</h1>빈은 오스트리아의 수도이다. 영어 명칭인 비엔나로도 알려져 있다. 다뉴브강이 도시 내부를 흐르며 인구는 약 190여만 명이고 대도시권 광역 인구는 약 230여만 명이다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="http://newsimg.hankookilbo.com/2019/09/04/201909041813757750_1.jpg"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:47.070714, lng:15.439504},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>오스트리아-그랏츠</h1>그라츠는 오스트리아에서 두 번째로 큰 도시로 슈타이어마르크주의 주도이다. 무어 강과 접한 오랜 전통의 교육 도시로 여섯 개의 대학에 6만여명의 학생들이 재학 중이다. 그라츠의 구 시가지는 중부 유럽 안에서 가장 잘 보존된 도심 중 하나이다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://t1.daumcdn.net/cfile/blog/2207AB3D53833E3632"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:47.80949, lng:13.05501},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>오스트리아-잘츠부르크</h1>잘츠부르크는 오스트리아 서부에 있는 도시로 잘츠부르크주의 주도이기도 하다. 잘츠부르크는 바로크 양식의 건축과, 다양한 역사, 모차르트의 출생지, 그리고 알프스로의 관문으로 널리 알려져 있다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="http://economychosun.com/query/upload/293/20190331180724_ozowdqoi.jpg"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:46.6364598, lng:14.3122246},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>오스트리아-클라겐푸르트</h1>클라겐푸르트는 오스트리아 남부 케른텐주의 주도로 인구는 93,000명, 면적은 120.11km²이다. 흔히 클라겐푸르트암뵈르터제라고 부르기도 한다. 뵈르트호 동쪽 가장자리에 위치한다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://www.hotelscombined.co.kr/rimg/dimg/5e/91/149751ae-city-25114-172c157af7c.jpg?width=1366&height=768&xhint=2929&yhint=1917&crop=true"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:48.30694, lng:14.28583},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>오스트리아-린즈</h1>린츠는 오스트리아 북부의 중심에 위치해 있는 오버외스터라이히주의 주도이며 오스트리아에서 세 번째로 큰 도시이다. 동유럽 체코 국경에서 30km 남쪽에 있으며, 도나우 강을 끼고 있다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://dynamic-media-cdn.tripadvisor.com/media/photo-o/23/47/95/e4/caption.jpg?w=600&h=400&s=1"  width="400px" height="auto"></a></div></div>',
        },
        // 온두라스
        {
            coords:{lat:14.065049, lng:-87.1715002},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>온두라스-테구시갈파</h1>테구시갈파는 온두라스의 수도이며 프란시스코모라산주의 주도이기도 하다. 인구는 897,000명이며, 해발 3250미터의 테구시갈파 골짜기에 있다. 테구시갈파는 원주민 언어로 "은의 산"을 뜻한다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://storage.doopedia.co.kr/upload/_upload/image4/travel/editor/1806/17/rep_20180617082758246.jpg"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:15.5038827, lng:-88.01386190000001},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>온두라스-산페드로술라</h1>산페드로술라는 온두라스 북서쪽에 위치한 도시로, 코르테스 주의 주도이기도 하다. 인구는 약 80만명 이상이며 수도 테구시갈파에 이어 두 번째로 많다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://dynamic-media-cdn.tripadvisor.com/media/photo-o/03/b0/64/17/miami-garifuna-village.jpg?w=700&h=500&s=1"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:15.770288, lng:-86.7919009},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>온두라스-라세이바</h1>라세이바는 온두라스 북부 연안에 위치한 도시로 아틀란티다 주의 주도이며 면적은 25km², 인구는 196,856명이다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://youimg1.tripcdn.com/target/1004180000013me5l9D54_D_1180_558.jpg?proc=source%2Ftrip"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:14.8437223, lng:-85.8793252},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>온두라스-카타카마스</h1>Catacamas는 인구 59,990 명의 ​​도시이며 온두라스의 Olancho Department에있는 자치제입니다. 면적 측면에서 중앙 아메리카에서 가장 큰 자치체입니다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://q-xx.bstatic.com/xdata/images/hotel/max500/64636114.jpg?k=269379076f1b9342d25f989909d0fd70cfe97d32929bd0783295b450a9f6abe6&s=450x450"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:15.9116789, lng:-85.9534465},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>온두라스-트루히요</h1>트루히요는 인구 20,780명의 도시이며 수도인 콜론의 온두라스 주의 북부 카리브 해안에 있는 시정촌입니다. 시정촌의 인구는 약 30,000명이었습니다. 이 도시는 트루히요 만이 내려다보이는 절벽에 위치해 있습니다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://dynamic-media-cdn.tripadvisor.com/media/photo-o/03/fc/83/18/campo-del-mar-nature.jpg?w=600&h=400&s=1"  width="400px" height="auto"></a></div></div>',
        },
        // 요르단
        {
            coords:{lat:31.9539494, lng:35.910635},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>요르단-암만주</h1>암만은 요르단의 수도로, 암만 주의 주도이다. 인구는 약 120만 명으로 요르단 전체 인구의 1/4을 차지하고 있으며 요르단의 정치, 경제의 중심지이기도 하다. 암만은 근대적인 도시이며 옛 시장의 중심지가 위치해 있다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://d2ur7st6jjikze.cloudfront.net/offer_photos/3379/14992_large_1433158604.jpg?1433158604"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:31.1853497, lng:35.7047733},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>요르단-카라크</h1>카라크는 요르단 중부에 위치한 도시로, 카라크 주의 주도이며 인구는 21,678명이다. 사해 동쪽에 위치하며 1142년 십자군이 세운 요새 유적이 있다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://media.istockphoto.com/photos/view-to-the-city-from-al-karak-hill-in-karak-jordan-picture-id1166822794"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:32.5568095, lng:35.846887},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>요르단-이르비드</h1>이르비드는 요르단 북부에 위치한 도시로, 이르비드 주의 주도이며 인구는 292,040명이다. 암만에서 북쪽으로 70km 정도 떨어진 곳에 위치하며 암만과 자르카에 이어 요르단에서 세 번째로 큰 도시이다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://upload.wikimedia.org/wikipedia/commons/f/fc/Irbid1.jpg"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:30.3216354, lng:35.4801251},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>요르단-와디무사</h1>Wadi Musa는 요르단 남부의 Maan Governorate에 위치한 도시입니다. 페트라 부서의 행정 중심지이며 페트라의 고고학 유적지에서 가장 가까운 도시입니다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://dynamic-media-cdn.tripadvisor.com/media/photo-o/10/0f/97/11/petra-beautiful-place.jpg?w=600&h=400&s=1"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:32.0608187, lng:36.0941795},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>요르단-자르카</h1>자르카는 요르단 서부에 위치한 도시로, 자르카 주의 주도이며 인구는 395,227명이다. 암만 북동쪽에 위치하며 요르단에서 암만에 이어 두 번째로 큰 도시이다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://storage.doopedia.co.kr/upload/_upload/image/1509/16/150916019744785/150916019744785_thumb_400.jpg"  width="400px" height="auto"></a></div></div>',
        },
        // 우간다
        {
            coords:{lat:0.3475964, lng:32.5825197},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>우간다-캄팔라</h1>캄팔라는 우간다의 수도이다. 중부 주의 주도이자 캄팔라 구의 행정 중심지이며 도시는 센트럴, 카웸페, 마킨뎨, 나카와, 루바가 등 총 5개의 지구로 나뉜 상태이다. 빅토리아 호 북쪽 끝에 있다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://newsimg.hankookilbo.com/cms/articlerelease/2020/12/14/2383ad48-4d99-4797-b3c1-8e7408350d9a.jpg"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:2.7724038, lng:32.2880726},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>우간다-글루</h1>굴루는 우간다 북부에 위치한 도시로 북부 주의 주도이자 굴루 구의 행정 중심지이며 높이는 1,100m, 인구는 152,276명이다. 수도 캄팔라에서 약 340km 정도 떨어진 곳에 위치한다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://m.miral.org/data_source/data_content/%EC%9A%B0%EA%B0%84%EB%8B%A4%20%EC%9A%B0%EB%AC%BC%20(5).png"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:1.0784436, lng:34.1810057},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>우간다-엠베일</h1>음 발레는 우간다의 동부 지역에있는 도시입니다. 그것은 Mbale 지구와 주변 소 지역의 주요 도시, 행정 및 상업 중심지입니다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://d2uh4olaxaj5eq.cloudfront.net/fit-in/720x0/0eb849f8-77f1-4cd6-aa70-5cf1bed88828.jpg"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:-0.6071596, lng:30.6545022},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>우간다-음바라라</h1>음바라라는 우간다의 도시로 서부 주의 주도이자 음바라라 구의 행정 중심지이며 인구는 195,013명이다. 수도 캄팔라에서 남서쪽으로 약 290km 정도 떨어진 곳에 위치한다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://pix10.agoda.net/geo/city/701287/89dddd431faa674a91490e0d686db39d.jpg?ca=0&ce=1&s=1920x822"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:0.6546257, lng:30.2801166},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>우간다-포트포털</h1>포트포털 또는 카바롤레는 우간다 서부에 위치한 도시로, 카바롤레 구의 행정 중심지이다. 역사적으로 토로 왕국의 수도였던 곳이기도 하다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://t1.daumcdn.net/cfile/tistory/22587A415831318F08"  width="400px" height="auto"></a></div></div>',
        },
        // 우루과이 
        {
            coords:{lat:-34.9011127, lng:-56.16453139999999},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>우루과이-몬테비데오</h1>몬테비데오는 우루과이의 수도이자 최대의 무역항이며, 우루과이 국내에서 인구가 백만이 넘는 도시이다. 몬테비데오주의 주도이기도 하다. 2010년 현재 인구는 132만 7115명이다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://www.flirkorea.com/globalassets/industrial/discover/traffic/montevideo-acyclica-banner.jpg"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:-34.9363205, lng:-54.9377826},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>우루과이-푼타델에스테</h1>푼타델에스테는 우루과이 남동부에 위치한 말도나도주의 도시로 면적은 20.35km², 인구는 9,277명이다. 도시가 신설된 시기는 1907년이다. 도시 이름은 스페인어로 "동쪽의 곶"을 뜻한다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://previews.123rf.com/images/danflcreativo/danflcreativo1409/danflcreativo140900030/31459971-%ED%91%BC-%ED%83%80%EB%8D%B8-%EC%97%90%EC%8A%A4%ED%85%8C-%EC%9A%B0%EB%A3%A8%EA%B3%BC%EC%9D%B4%EC%9D%98-la-mansa-%ED%95%B4%EB%B3%80%EC%97%90%EC%84%9C%EC%9D%98-%EC%9D%BC%EB%AA%B0.jpg"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:-33.5201418, lng:-56.9042201},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>우루과이-트리니다드</h1>트리니다드는 우루과이 남부에 위치한 도시로 플로레스주의 주도이며 높이는 134m, 인구는 21,429명이다. 도시가 신설된 시기는 1805년이다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://img1.yna.co.kr/photo/reuters/2021/07/28/PRU20210728022601009_P2.jpg"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:-34.402302, lng:-53.79494099999999},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>우루과이-카보폴로니오</h1>카보 폴로니오는 우루과이 로차주의 동해안에 있는 햄릿이다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://img.hankyung.com/photo/201601/AA.11127078.1.jpg"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:-32.3112903, lng:-58.0757701},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:auto;width:400px;"><h1>우루과이-파이산두</h1>파이산두는 우루과이 서부에 위치한 도시로 파이산두주의 주도이다. 우루과이에서 4번째로 인구가 많은 도시로 현재 인구는 76,412명이다. 아르헨티나 국경과 가까운 편이며 시내에는 우루과이강이 흐른다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://cf.bstatic.com/xdata/images/hotel/270x200/307014362.jpg?k=4abf95bb9141b765120ef1d3b639e09aa7e5505890c4902cacc3481026a53d39&o="  width="400px" height="auto"></a></div></div>',
        },
        // 우즈베키스탄
        {
            coords:{lat:41.2994958, lng:69.2400734},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:auto;width:400px;"><h1>우즈베키스탄-타슈켄트</h1>타슈켄트는 우즈베키스탄의 수도이다. 주민은 우즈베크인 70%, 러시아인 13%, 타타르인 4.5%, 우크라이나인 4%, 고려인 2.2%로 구성되어 있다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://upload.wikimedia.org/wikipedia/commons/2/26/Vue_de_l%27Aqua-Park_-_Tachkent.jpg"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:39.627012, lng:66.9749731},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:auto;width:400px;"><h1>우즈베키스탄-사마르칸트</h1>사마르칸트는 중앙아시아 두번째로 큰 우즈베키스탄의 고도이며, 사마르칸트 주의 주도이다. 소그드어로 ‘돌 요새’ 또는 ‘바위 도시’라는 의미이며, 몽골어로는 ‘밤 바위’ 또는 ‘딱딱한 바위’를 의미한다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://dynamic-media-cdn.tripadvisor.com/media/photo-o/0f/78/99/60/photo1jpg.jpg?w=700&h=500&s=1"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:38.86119180000001, lng:65.7847269},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:auto;width:400px;"><h1>우즈베키스탄-카르시</h1>카르시는 우즈베키스탄 남부에 위치한 도시로, 카슈카다리야 주의 주도이며 인구는 197,600명이다. 타슈켄트에서 남동쪽으로 520km 정도 떨어진 곳에 위치한다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://overseas.mofa.go.kr/webmodule/crosseditor/binary/images/000849/20150728201102288_0CCMSRK0.png"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:41.5345323, lng:60.6248891},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:auto;width:400px;"><h1>우즈베키스탄-우르겐치</h1>우르겐치는 우즈베키스탄 호레즘 주의 주도이다. 이곳의 주민들은 우즈베크인과 타지크인, 투르크멘인, 카자흐인, 카라칼팍족, 러시아인들이 거주한다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://ko.skyticket.com/static/img/international-flights/UZB.jpg"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:42.461891, lng:59.6166312},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:auto;width:400px;"><h1>우즈베키스탄-누쿠스</h1>누쿠스는 우즈베키스탄의 자치 공화국인 카라칼파크스탄 공화국의 주도이다. 인구는 1999년에 약 20만 명으로 카라칼파크스탄 공화국에서 가장 큰 도시이다. 우즈베키스탄 전체에서는 6번째로 인구가 많다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://media.istockphoto.com/photos/mizdakhan-cemetery-around-the-city-of-nukus-uzbekistan-picture-id1157519294"  width="400px" height="auto"></a></div></div>',
        },
        // 우크라이나
        {
            coords:{lat:50.4501, lng:30.5234},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:auto;width:400px;"><h1>우크라이나-키이우</h1>키이우, 또는 키예프는 우크라이나의 최대 도시이자 수도이다. 드니프로강의 북쪽 중앙에 위치하고 있는데 드니프로강이 흑해로 흘러드는 어귀로부터는 952km 떨어진 곳에 자리잡고 있다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://img.insight.co.kr/static/2022/03/03/700/img_20220303105825_g5683r03.webp"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:49.9935, lng:36.230383},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:auto;width:400px;"><h1>우크라이나-하르키우</h1>하르키우는 우크라이나 북동부의 도시이고 하르키우주의 주도이다. 인구는 1,430,885명으로 인구에서는 키이우에 이어 우크라이나에서 2번째로 큰 도시이다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://w.namu.la/s/d0efe3948319ba37f86991b68d28fb45528e3e21d172248dd6356e475503c5c28ae122ecd1e590e5fb761f0860c3f2727f81d69a16d330cd2d0ef7331ec7c7dce0281f6be3e4c9860022e8073da22400a6043cbd31640b3a50bc8607023347db34cbced030df5cd7a07a9a7a0b4f357b"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:47.097133, lng:37.543367},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:auto;width:400px;"><h1>우크라이나-마리우풀</h1>마리우폴은 우크라이나 남동부에 위치한 항구 도시로, 아조프 해의 북안이자 칼미우스 강구에 위치한다. 행정 구역상으로는 도네츠크주에 속하며 인구는 431,859명이다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://image.fmkorea.com/files/attach/new2/20210829/33854530/652171119/3873597405/2383bb1c2d17d6e25c68f9110dd50d3a.jpg"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:46.975033, lng:31.994583},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:auto;width:400px;"><h1>우크라이나-미콜라이프</h1>미콜라이우는 우크라이나 남부에 위치한 도시로, 미콜라이우주의 주도이며 면적은 259.83km², 인구는 505,900명, 인구밀도는 1,959명/km²이다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://t1.daumcdn.net/cfile/tistory/2678E93957C06AF617"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:49.839683, lng:24.029717},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:auto;width:400px;"><h1>우크라이나-리비우</h1>르비우는 우크라이나 서부의 도시이고 인구는 약 83만명이다. 르비우주의 주도이며 폴란드와의 국경으로부터 70km 지점에 위치해 있다. 르비우 역사 지구는 유네스코의 세계 유산에 등록되어 있다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://eb.findmybucketlist.com/bucket/new/cp/3343244_cp_00.jpg?update_date=2019-10-2516:37:52"  width="400px" height="auto"></a></div></div>',
        },
        // 이라크
        {
            coords:{lat:33.315241, lng:44.3660671},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:auto;width:400px;"><h1>이라크-바그다드</h1>바그다드는 이라크의 수도이다. 시내를 유프라테스 강과 티그리스 강이 흐른다. 카이로, 테헤란, 이스탄불에 이어 중동에서 네 번째로 큰 대도시이다. 인구는 2006년 현재 약 700만으로 추정된다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://dynamic-media-cdn.tripadvisor.com/media/photo-o/0b/9e/e9/f2/al-jawadain-holy-shrine.jpg?w=600&h=-1&s=1"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:36.190073, lng:43.9930303},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:auto;width:400px;"><h1>이라크-아르빌</h1>아르빌은 이라크 쿠르드 자치구에 위치한 도시로, 이라크 전체에서는 바그다드, 바스라, 모술에 이어 네번째로 큰 도시이다. 모술의 동쪽으로부터 80km 떨어져 있으며, 쿠르드 자치구의 수도이다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://us.123rf.com/450wm/homeros/homeros1209/homeros120900041/16628676-%EC%BF%A0%EB%A5%B4%EB%93%9C-%EC%9D%B4%EB%9D%BC%ED%81%AC-%EC%95%84%EB%A5%B4%EB%B9%8C%EC%8B%9C.jpg"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:30.5257657, lng:47.77379699999999},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:auto;width:400px;"><h1>이라크-바스라</h1>바스라는 이라크 남부의 중심으로 이라크 제3의 도시이다. 무역항이며 시내에 운하망이 있다. 바스라 주의 주도이다. 2012년 기준 인구 250만 명으로 추정된다. 초기 이슬람 역사에서 중요한 역할을 했으며 636년에 지어졌다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://www.koscaj.com/news/photo/202101/215599_47570_3526.jpg"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:35.5557603, lng:45.4351181},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:auto;width:400px;"><h1>이라크-술라이마니야</h1>술라이마니야는 이라크 쿠르드 자치구에 위치한 도시로, 술라이마니야 주의 주도이며 1784년 신설되었다. 높이는 해발 882m이며 인구는 1,041,490명이다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://www.hotelscombined.co.kr/rimg/dimg/d1/eb/e7429868-city-70770-172c1567fc8.jpg?width=1366&height=768&xhint=1131&yhint=820&crop=true"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:36.3489278, lng:43.157736},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:auto;width:400px;"><h1>이라크-모술</h1>모술은 이라크 북부에 있는 도시이다. 니네와 주의 주도이다. 이라크에서 바그다드 다음으로 두번째로 큰 도시이다. 고대 니네베 유적과 석유 생산으로 알려진 도시이다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTjfMe4mDOqtxlm1gObKWNkVIqz61LnjD4yMw&usqp=CAU"  width="400px" height="auto"></a></div></div>',
        },
        // 이란
        {
            coords:{lat:35.7218583, lng:51.3346954},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:auto;width:400px;"><h1>이란-테헤란</h1>테헤란은 이란의 수도로 테헤란 주의 인구 1105만명의 중심지이다. 이란의 정치, 경제, 문화의 중심지로써, 이란 산업의 절반 이상이 테헤란에 집중되어 있다. 서아시아에서 가장 큰 도시이며, 지구에서 21번째로 큰 도시이다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://media.istockphoto.com/photos/tehraniranfamous-night-view-of-tehranflow-of-traffic-round-tohid-picture-id1197802544"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:38.0791831, lng:46.2886732},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:auto;width:400px;"><h1>이란-타브리즈</h1>타브리즈는 이란 북서부의 도시로, 아자르바이잔에샤르키주의 주도이다. 해발 약 1,350m의 고지대에 있으며, 인구는 약 140만 명으로 이란에서 네번째로 많다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://cdn.pixabay.com/photo/2020/05/31/20/13/iran-5244060_960_720.jpg"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:36.2972006, lng:59.60669},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:auto;width:400px;"><h1>이란-마슈하드</h1>마슈하드는 이란에서 두 번째로 큰 도시이며 시아파 세계에서 가장 성스러운 도시 중의 하나이다. 이 도시는 테헤란에서 동쪽으로 850km 떨어져 있으며 호라산에라자비주의 중심이다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://mblogthumb-phinf.pstatic.net/20140907_129/hojubwings_1410093428169fQFgw_JPEG/1_L_1350975137.jpg?type=w2"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:29.5926119, lng:52.5835646},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:auto;width:400px;"><h1>이란-시라즈</h1>시라즈는 이란의 5번째로 인구 밀집된 도시이며 파르스주의 주도이다. 시라즈는 이란의 남서부에 위치하며 루드카네예 호쉬크 강이 계절에 따라서 흐른다. 시라즈의 기후는 좋은 편이며 1000년 이상 지역의 교역 중심이었다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://babajung.com/wp-content/uploads/2018/06/IMG_1109.jpg"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:32.6538966, lng:51.66596560000001},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:auto;width:400px;"><h1>이란-이스파한</h1>이스파한은 테헤란 남방 420km 이란고원 위의 교통의 요지에 있는 미려한 도시이다. 인구는 약 200만 명으로 이란에서 세 번째로 큰 도시이며 광역권을 포함하면 약 398만 명으로 두 번째로 큰 광역도시권이다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://t1.daumcdn.net/cfile/tistory/99A393335A1BB84F30"  width="400px" height="auto"></a></div></div>',
        },
        // 이스라엘
        {
            coords:{lat:31.768319, lng:35.21371},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:auto;width:400px;"><h1>이스라엘-예루살렘</h1>예루살렘은 예로부터 종교 분쟁에서 불씨가 되어온 중동에 있는 도시다. 예루살렘은 팔레스타인 중심부의 지중해 연안 평야와 요르단 강에서 이어지는 그레이트 리프트 밸리 사이에 자리하고 있으며 3대 아브라함 계통의 종교인 기독교, 유대교, 이슬람교의 성지이다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://t1.daumcdn.net/cfile/blog/126F4E1A4A5B31E2D1"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:32.0852999, lng:34.78176759999999},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:auto;width:400px;"><h1>이스라엘-텔아비브</h1>텔아비브는 이스라엘 서부 지중해 연안에 있는 도시이다. 이스라엘의 실질적 수도이며, 국제법적 수도이다. 시내 인구는 405,300명으로 예루살렘 다음으로 많다. 대도시권의 인구는 3,850,000명에 달하며 이스라엘 최대의 대도시권을 형성하고 있다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://www.hotelscombined.co.kr/rimg/dimg/65/be/5907f602-city-54749-166a780a201.jpg?width=1366&height=768&xhint=1624&yhint=1764&crop=true"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:32.7940463, lng:34.989571},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:auto;width:400px;"><h1>이스라엘-하이파</h1>하이파는 북부 이스라엘 최대의 도시이자 이스라엘 세 번째 크기의 도시이다. 인구는 약 26만 7800명이다. 도시 및 그 주변은 하이파 지방에 속한다. 항구 도시이며, 지중해를 접하고 있다. 카르멜 산 자락에 위치한다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://dynamic-media-cdn.tripadvisor.com/media/photo-o/15/33/fb/88/haifa.jpg?w=700&h=500&s=1"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:31.252973, lng:34.791462},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:auto;width:400px;"><h1>이스라엘-베르셰바</h1>베르셰바는 네게브 사막에 위치한 이스라엘의 도시로, "네게브의 주도"로 불리기도 한다. 2005년 현재 인구는 184,500명으로 이스라엘에서 6번째로 큰 도시다. 20년 전에는 11만 8천명이었다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://dynamic-media-cdn.tripadvisor.com/media/photo-o/0f/68/12/bf/the-river-zin-riverbed.jpg?w=700&h=500&s=1"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:32.321458, lng:34.853196},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:auto;width:400px;"><h1>이스라엘-네타냐</h1>네타냐는 이스라엘 중부 구 북부에 위치한 도시로, 면적은 28.5km², 인구는 183,200명이다. 텔아비브에서 북쪽으로 30km, 하이파에서 남쪽으로 56km 정도 떨어진 곳에 위치하며 도시 이름은 히브리어로 "신이 주신"을 뜻한다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://eb.findmybucketlist.com/city/new/cp/1210249_cp_00.jpg?update_date=2019-08-1921:23:06"  width="400px" height="auto"></a></div></div>',
        },
        // 이집트
        {
            coords:{lat:30.0444196, lng:31.2357116},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:auto;width:400px;"><h1>이집트-카이로</h1>카이로는 이집트와 아랍 연맹의 수도이며, 나일강의 물줄기가 여러 지류로 갈라지기 시작하는 바로 그 지점에 위치하고 있는 아프리카 대륙과 중동 지역 최대의 도시이다. 서기 642년에 건설된 도시로, 도시권의 인구는 1700만에 달한다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://dynamic-media-cdn.tripadvisor.com/media/photo-o/03/9b/2f/5b/cairo.jpg?w=700&h=500&s=1"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:31.2000924, lng:29.9187387},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:auto;width:400px;"><h1>이집트-알랙산드리아</h1>알렉산드리아는 이집트 북부 알렉산드리아 주의 지중해에 면한 항구도시로 이집트에서는 수도인 카이로 다음으로 두 번째로 큰 도시이자 가장 큰 항구도시이다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://dynamic-media-cdn.tripadvisor.com/media/photo-o/0d/18/7d/e2/roman-amphitheater.jpg?w=600&h=400&s=1"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:27.2578957, lng:33.8116067},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:auto;width:400px;"><h1>이집트-후루가다</h1>후르가다는 이집트 홍해 주의 주도이며, 해변에 있는 관광 도시이다. 20세기 초에 건설됐으며, 1980년대 이후 이집트 정부에 의해 관광업이 많이 발달되었다. 후르가다 국제공항이 위치해 있다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://t4.daumcdn.net/thumb/R720x0/?fname=http://t1.daumcdn.net/brunch/service/user/6Vs/image/byXUmTY0MFgK88Z_vKaM_sfYTp8.jpg"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:31.3543445, lng:27.2373159},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:auto;width:400px;"><h1>이집트-메르사마트루</h1>메르사마트루는 이집트 마트루 주의 주도이며, 항구 도시이다. 인구는 68,339명이다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://storage.doopedia.co.kr/upload/_upload/image5/2206/30/220630024350265/220630024350265_thumb_400.jpg"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:22.3460086, lng:31.6156242},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:auto;width:400px;"><h1>이집트-아부심벨</h1>아부 심벨 신전은 이집트 남부에 있는 고대 이집트의 유적이다. 20m의 좌상들과 암벽을 60m 깊이로 파서 만든 석굴사원으로, 우리나라로 친다면, 석굴암 비슷한 것이다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://t1.daumcdn.net/cfile/tistory/1923A4344E84ED840A"  width="400px" height="auto"></a></div></div>',
        },
        // 이탈리아
        {
            coords:{lat:45.4642035, lng:9.189982},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:auto;width:400px;"><h1>이탈리아-밀라노</h1>밀라노는 이탈리아의 북부에 있는 도시로, 롬바르디아주의 주도이다. 밀라노는 이탈리아 북부의 최대 도시로, 롬바르디아 평원에 위치하고 있으며, 포 강이 이 도시를 흐르고 있다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://www.eurobike.kr/upload/goods_data/422018470424603.jpg"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:45.4408474, lng:12.3155151},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:auto;width:400px;"><h1>이탈리아-베니스</h1>베네치아는 이탈리아 북부에 위치한 베네토주 베네치아 광역시에 속하는 도시로, 베네토 주의 주도이다. 과거 베네치아 공화국의 수도였다. 또한 세계적 관광지이며, 수상 도시이자 운하의 도시로도 유명하다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://i0.wp.com/blog.findmybucketlist.com/wp-content/uploads/2020/10/%EB%B2%A0%EB%8B%88%EC%8A%A4-%EB%B3%B4%EC%A0%87%E3%85%87.jpg?resize=792%2C446&ssl=1"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:44.4056499, lng:8.946256},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:auto;width:400px;"><h1>이탈리아-제노바</h1>제노바는 이탈리아의 북부에 있는 지중해의 항구 도시로, 리구리아주의 주도이다. 고대 리구리아인들의 도시였다. 유럽 연합은 제노바를 프랑스의 릴과 함께 2004년 유럽 문화 수도로 선정하였다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://www.hotelscombined.co.kr/rimg/dimg/62/20/95278e91-city-6888-1656820e3c9.jpg?width=1366&height=768&xhint=1790&yhint=1391&crop=true"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:44.494887, lng:11.3426163},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:auto;width:400px;"><h1>이탈리아-볼로냐</h1>볼로냐는 이탈리아 북부 내륙에 있는 대학 도시이다. 세계에서 가장 오래된 것으로 알려진 볼로냐 대학교가 있는 곳이다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://pix10.agoda.net/geo/city/1002/1_1002_02.jpg?ca=6&ce=1&s=1920x822"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:43.7695604, lng:11.2558136},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:auto;width:400px;"><h1>이탈리아-플로렌스</h1>피렌체는 이탈리아 중부 토스카나주의 주도이다. 피렌체현의 현청 소재지이며, 인구는 38만명이고 근교의 인구까지 합치면 총 약 150만명이다. 토스카나 주에서 가장 인구가 많은 도시이기도 하다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="http://www.travelnbike.com/news/photo/201404/1497_1624_1345.jpg"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:43.7228386, lng:10.4016888},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:auto;width:400px;"><h1>이탈리아-피사</h1>피사는 이탈리아 토스카나주에 있는 도시이다. 피사도의 현청 소재지이며, 시의 인구는 약 9만명이다. 예로부터 문예의 중심지로 번창했으며, 갈릴레오 갈릴레이도 이 곳의 대학에서 공부하였다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://www.eurobike.kr/upload/goods_data/432018470424082.jpg"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:41.9027835, lng:12.4963655},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:auto;width:400px;"><h1>이탈리아-로마</h1>로마는 이탈리아의 수도이자 최대 도시로, 라치오주의 주도이며, 테베레 강 연안에 있다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="http://d3b39vpyptsv01.cloudfront.net/photo/1/2/17f552dbb8d76670480cd3ec5e9ac0c2.jpg"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:40.8517983, lng:14.26812},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:auto;width:400px;"><h1>이탈리아-나폴리</h1>나폴리는 이탈리아 남부에 있는 도시로, 캄파니아주의 주도이다. 이 도시는 이탈리아 통일 전까지는 양시칠리아 왕국의 수도였다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="http://d3b39vpyptsv01.cloudfront.net/photo/1/2/adce93a602280f7cda53244add2c2c5c_l.jpg"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:41.1171432, lng:16.8718715},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:auto;width:400px;"><h1>이탈리아-바리</h1>바리는 이탈리아 남부 풀리아주에 있는 도시이다. 인구 328,458. 이탈리아 반도 동남부, 아드리아 해에 면하는 항구도시이다. 풀리아 주의 주도이기도 하다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://dynamic-media-cdn.tripadvisor.com/media/photo-o/14/10/2d/ec/bari.jpg?w=700&h=500&s=1"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:38.11569, lng:13.3614868},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:auto;width:400px;"><h1>이탈리아-팔레르모</h1>팔레르모는 이탈리아 남부 시칠리아섬에 있는 도시로, 인구는 654,121명이다. 시칠리아주의 주도이며, 티레니아해에 면하는 항구도시이다. 팔레르모는 기원전 8세기에 건설된 오래된 도시이다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://media.istockphoto.com/photos/piazza-pretoria-and-the-praetorian-fountain-in-palermo-sicily-italy-picture-id1159760794"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:37.5078772, lng:15.0830304},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:auto;width:400px;"><h1>이탈리아-카타니아</h1>카타니아는 이탈리아 남부 시칠리아주에 있는 도시로 카타니아현의 현청 소재지이다. 인구는 2015년 기준으로 315,601명이다. 시칠리아섬 동남부, 에트나 산 기슭에 위치하며, 이오니아 해에 면하는 유서깊은 항구도시이다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="http://d3b39vpyptsv01.cloudfront.net/photo/1/2/0562fb33486dd4daf6c9478c2cdf8574_l.jpg"  width="400px" height="auto"></a></div></div>',
        },
        // 인도
        {
            coords:{lat:28.6139391, lng:77.2090212},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:auto;width:400px;"><h1>인도-뉴델리</h1>뉴델리는 인도의 수도이고, 델리 수도권에 속하는 도시이며, 1911년 인도의 새 수도로 정해진 후 20년간에 걸쳐 완성된 계획도시로 넓은 도로망이 펼쳐진 정치의 중심지이다. 야무나 강 우안, 델리의 남부에 위치해 있다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://eb.findmybucketlist.com/city/new/cp/1227113_cp_00.jpg?update_date=2019-08-1921:14:33"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:26.9124336, lng:75.7872709},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:auto;width:400px;"><h1>인도-자이푸르</h1>자이푸르는 인도 라자스탄 주의 주도로서 도로와 철도 등 교통망이 정비된 상공업 중심지이다. 18세기에 건설된 사각형의 계획도시로 거리 전체가 분홍색이라‘분홍 도시’로도 알려져 있는 곳이다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://pix10.agoda.net/geo/city/8845/1_8845_02.jpg?ca=6&ce=1&s=1920x822"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:23.022505, lng:72.5713621},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:auto;width:400px;"><h1>인도-아마다바드</h1>아마다바드는 인도 서부 구자라트 주 최대의 도시로 인구는 351만 5,361명이다. 사바르마티 강 연변에 전개된다. 15세기에 아마드 1세가 건설한 도시인데, 시내에는 자마마스지드 이슬람교 대사원과 아마드샤의 묘를 비롯한 많은 훌륭한 건축물이 남아 있다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://dynamic-media-cdn.tripadvisor.com/media/photo-o/0d/eb/b8/4d/lake-view.jpg?w=600&h=400&s=1"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:19.0759837, lng:72.8776559},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:auto;width:400px;"><h1>인도-뭄바이</h1>뭄바이는 인도 마하라슈트라주의 주도이다. 1995년에 봄베이에서 뭄바이로 이름을 바꾸었다. 인구는 약 1,287만 8447명 이다. 인도의 상업 중심지이자 세계에서 가장 많은 양의 영화를 제작하는 영화 산업의 본고장이다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="http://diverseasia.snu.ac.kr/wp-content/uploads/2021/06/image02-1.png"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:18.5204303, lng:73.8567437},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:auto;width:400px;"><h1>인도-푸네</h1>푸네는 인도의 데칸 고원에 위치한 마하라슈트라 주에서 두 번째로 큰 도시이다. 식민지 시대의 영어 명칭 푸나로도 널리 알려져 있다. 해발 600미터의 고원에 있기 때문에 뭄바이의 피서지로서 발달했다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://post-phinf.pstatic.net/MjAxODAyMTRfMTE1/MDAxNTE4NTg4MjkzOTEx.6vYGIgj1YPvejjgc3YWRn6BjoBnWU7mqe_-0u3aK1mQg.8nIhKKDKe9JAc6BGlpmAMEA87EoK5JJ5Uo25kjifeHkg.JPEG/1.jpg?type=w1200"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:17.385044, lng:78.486671},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:auto;width:400px;"><h1>인도-하이데라바드</h1>하이데라바드는 인도 텔랑가나주의 도시로 텔랑가나주의 주도이다. 옛 하이데라바드 왕국의 수도로, 16~8세기에 세워진 많은 회교사원은 당시의 영화를 생각케 한다. 중앙부를 흐르는 무시 강의 북안이 시의 중심지로 정부기관, 학교, 공원 등이 있다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://dynamic-media-cdn.tripadvisor.com/media/photo-o/0f/98/f7/df/charminar.jpg?w=700&h=500&s=1"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:12.9715987, lng:77.5945627},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:auto;width:400px;"><h1>인도-벵갈루루</h1>벵갈루루는 인도 카르나타카 주의 주도이다. 주로, 뱅걸로 또는 방갈로르라는 이름으로 더 유명하다. 데칸 고원에 자리하고 있다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://file.thisisgame.com/upload/nboard/news/2016/05/13/20160513165312_8195.jpg"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:13.0826802, lng:80.2707184},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:auto;width:400px;"><h1>인도-첸나이</h1>첸나이는 인도 타밀나두주, 벵골만 연안에 있는 도시다. 과거에는 마드라스라는 도시명이었으나, 1996년에 첸나이로 이름을 바꾸었다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://dynamic-media-cdn.tripadvisor.com/media/photo-o/15/4d/46/b8/chennai-madras.jpg?w=700&h=500&s=1"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:22.572646, lng:88.36389500000001},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:auto;width:400px;"><h1>인도-캘커타</h1>콜카타는 인도의 서벵골 주의 주도로, 한때 영국령 인도의 수도였다. 콜카타라는 이름은 여기서 숭배하는 여신 칼리와 연관이 있다. 인구는 14,112,536명으로 인도에서 3번째로 큰 대도시권을 형성한다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://dynamic-media-cdn.tripadvisor.com/media/photo-o/15/33/fe/ac/kolkata-calcutta.jpg?w=700&h=500&s=1"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:26.8466937, lng:80.94616599999999},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:auto;width:400px;"><h1>인도-러크나우</h1>러크나우는 인도 우타르프라데시 주의 주도이다. 갠지스 강의 지류 굼티 강에 면한 이슬람 문화가 개화한 도시로 옛 회교사원과 묘묘 등의 유적이 있다. 세포이 항쟁이 일어난 곳으로도 유명하며 인도 민족 운동이 중심지였다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://youimg1.tripcdn.com/target/0103a120008x82rn1031D_C_640_320_R5_Q70.jpg_.webp?proc=source%2Ftrip"  width="400px" height="auto"></a></div></div>',
        },
        // 인도네시아
        {
            coords:{lat:3.5951956, lng:98.6722227},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:auto;width:400px;"><h1>인도네시아-메단</h1>메단 은 인도네시아 수마트라우타라주의 주도이다. 해안을 따라서 주의 북쪽 부분에 위치한, 메단은 인도네시아에서 세 번째로 큰 도시이다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://t1.daumcdn.net/cfile/tistory/99949F3F5C5813242A"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:-6.2087634, lng:106.845599},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:auto;width:400px;"><h1>인도네시아-자카르타</h1>자카르타 특별수도지역는 인도네시아의 수도이자 인도네시아의 최대 도시이다. 옛 이름은 바타비아이며 자와섬 북서 기슭에 위치해 있다. 해안에서 가까운 상업 시가지와 Pakubuwono, Pondok Indah 등의 아파트가 밀집한 신시가지로 나뉜다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://dynamic-media-cdn.tripadvisor.com/media/photo-o/14/10/2e/cb/jakarta.jpg?w=700&h=500&s=1"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:-6.9174639, lng:107.6191228},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:auto;width:400px;"><h1>인도네시아-반둥</h1>반둥은 인도네시아의 서부 자와섬에 위치한 서자와주의 주도로, 인도네시아에서는 3번째로 큰 도시이다. 2018년 아시안 게임의 축구 경기가 개최된 도시 중 하나다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://d2ur7st6jjikze.cloudfront.net/offer_photos/52895/325248_large_1550721659.jpg?1550721659"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:-7.2574719, lng:112.7520883},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:auto;width:400px;"><h1>인도네시아-수라바야</h1>수라바야는 인도네시아의 제2의 도시이자 자와티무르 주의 주도이다. 인구는 약 300만 명이다. 자와섬 북쪽 해안의 마스 강 하구에 위치한다. 인도네시아의 최대의 항만이다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://mediaim.expedia.com/destination/1/49c8026d6585316e9aee11ec9bc27dcc.jpg?impolicy=fcrop&w=360&h=224&q=mediumLow"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:-0.0263303, lng:109.3425039},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:auto;width:400px;"><h1>인도네시아-폰티아낙</h1>폰티아낙은 인도네시아 보르네오섬에 위치한 칼리만탄바랏주의 주도로, 면적은 107.82km², 인구는 516,737명이다. 카푸아스강 삼각주 지대에 위치하며 적도가 지나가는 지점에 위치한 도시 가운데 가장 큰 규모를 자랑한다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://dynamic-media-cdn.tripadvisor.com/media/photo-o/09/a3/c2/cd/masjid-raya-mujahidin.jpg?w=400&h=-1&s=1"  width="400px" height="auto"></a></div></div>',
        },
        // 일본
        {
            coords:{lat:43.0617713, lng:141.3544506},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:auto;width:400px;"><h1>일본-삿포로</h1>삿포로시는 일본 홋카이도의 도오지방에 위치하고 이시카리 진흥국에 속한다. 도청 소재지의 이시카리 진홍국에 위치하며 정치, 경제의 중심 도시다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://resources.matcha-jp.com/resize/720x2000/2017/03/14-21283.jpeg"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:38.268195, lng:140.869418},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:auto;width:400px;"><h1>일본-센다이</h1>센다이시는 미야기현의 현청 소재지이고, 도호쿠 지방의 중심 도시로서의 기능도 갖추고 있다. <br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://t1.daumcdn.net/cfile/tistory/99056C375AA5B5D524"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:37.5178386, lng:138.9269794},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:auto;width:400px;"><h1>일본-니이가타</h1>니가타현은 일본 주부 지방 동해 연안에 있는 현이다. 현청 소재지는 니가타시이다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://media-cdn.tripadvisor.com/media/photo-m/1280/19/17/ca/b5/photo0jpg.jpg"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:35.6761919, lng:139.6503106},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:auto;width:400px;"><h1>일본-도쿄</h1>도쿄도 또는 도쿄, 동경은 일본의 수도이며 간토지방에 위치하는 도로, 일본의 도 행정구역 가운데서 인구 수가 2021년 기준 14,049,146으로 가장 많은 지역이다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://www.agoda.com/wp-content/uploads/2019/01/Things-to-do-in-Tokyo-Tokyo-Tower.jpg"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:35.4436739, lng:139.6379639},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:auto;width:400px;"><h1>일본-요코하마</h1>요코하마시 는 일본 가나가와현 동부에 있는 현청 소재지이다. 일본에서는 도쿄 다음으로 2번째로 인구 수가 많은 도시로, 가나가와현의 현도이다. 도쿄 대도시권에 속하며, 권역 내에서 경제적 중심지를 맡고 있다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://rimage.gnst.jp/livejapan.com/public/article/detail/a/00/04/a0004133/img/basic/a0004133_main.jpg?20200902135313&q=80&rw=750&rh=536"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:35.18145060000001, lng:136.9065571},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:auto;width:400px;"><h1>일본-나고야</h1>나고야시는 아이치현의 서부에 위치한 현청 소재지이다. 정령지정도시로 지정되어 있다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://www.nagoya-info.jp/assets/otherlan/img/nagoya/about_p01.jpg"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:34.6937249, lng:135.5022535},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:auto;width:400px;"><h1>일본-오사카</h1>오사카시는 일본 오사카부에 있는 도시로 부청 소재지다. 혼슈 긴키 지방의 요도가와 강 하구 오사카 만에 위치해 있으며, 일본에서 도쿄 다음으로 규모가 크다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://rimage.gnst.jp/livejapan.com/public/article/detail/a/20/00/a2000366/img/basic/a2000366_main.jpg?20200603194001&q=80&rw=750&rh=536"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:34.3852894, lng:132.4553055},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:auto;width:400px;"><h1>일본-히로시마</h1>히로시마시는 히로시마현의 현청 소재지이다. 일본 전국에서 11번째로 인구가 많은 도시이며, 1974년에는 인구가 80만 명을 넘어 정령지정도시 지정을 요구해 온 결과 1980년 4월 1일에 정령지정도시로 지정되었다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://post-phinf.pstatic.net/MjAxODExMTZfOSAg/MDAxNTQyMzQ1NzQ1NjI0.AfWnDnJi3uS7HxuD8qRJ1c_PHowhXx3hGyNueyjzlIcg.6YwCTwJLoUkOPoU1EuFmKJgHGZovw54yVlO4h5SH6N4g.JPEG/%ED%9E%88%EB%A1%9C%EC%8B%9C%EB%A7%88%EC%97%AC%ED%96%89_%282%29.jpg?type=w1200"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:33.5901838, lng:130.4016888},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:auto;width:400px;"><h1>일본-후쿠오카</h1>후쿠오카시는 후쿠오카현의 현청 소재지이다. 일본 전국에서 6번째, 규슈에서는 제일 인구가 많은 도시이다. 1972년에 정령지정도시로 지정되었다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://t1.daumcdn.net/cfile/tistory/2529CC3D594B2B0830"  width="400px" height="auto"></a></div></div>',
        },
        // 자메이카
        {
            coords:{lat:18.0178743, lng:-76.8099041},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:auto;width:400px;"><h1>자메이카-킹스톤</h1>킹스턴은 자메이카의 수도이자 가장 큰 도시이다. 자메이카 섬의 동남부 연안에 위치하며 인구는 2011년 조사 기준 1,041,084명이다. 행정 구역상으로는 서리주 킹스턴구에 속한다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://eb.findmybucketlist.com/city/new/cp/1211458_cp_00.jpg?update_date=2019-08-0816:57:49"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:17.8840843, lng:-77.7655781},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:auto;width:400px;"><h1>자메이카-트래저비치</h1>자메이카는 북아메리카 카리브해의 섬나라이다. 쿠바, 멕시코, 아이티와 가깝다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://theplanetsworld.com/adventure-trips/7-best-beaches-in-jamaica.jpg"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:18.4762228, lng:-77.8938895},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:auto;width:400px;"><h1>자메이카-몬테고베이</h1>몬테고베이는 자메이카 북서부에 위치한 도시로 인구는 96,488명이다. 콘월주 세인트제임스구의 행정 중심지로서 수도 킹스턴에 이어 자메이카에서 2번째로 큰 도시, 자메이카에서 4번째로 인구가 많은 도시이기도 하다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://cf.bstatic.com/xdata/images/hotel/270x200/91579216.jpg?k=42a6c226ff5ab2833b3eb67d33333fb5a9470b552c008236ebe5c710cd81ec85&o="  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:18.1712764, lng:-76.44763209999999},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:auto;width:400px;"><h1>자메이카-포트안토니오</h1>포트 안토니오는 킹스턴에서 약 100km 떨어진 자메이카 북동쪽 해안에있는 포틀랜드 교구의 수도입니다. 1982 년에 12,285 명, 1991 년에 13,246 명의 인구를 가졌습니다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://dynamic-media-cdn.tripadvisor.com/media/photo-o/17/3a/75/fb/one-of-jamaica-s-hidden.jpg?w=600&h=400&s=1"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:18.2683058, lng:-78.3472424},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:auto;width:400px;"><h1>자메이카-네그릴</h1>네 그릴은 웨스트 모어 랜드와 하노버의 두 자메이카 교구의 일부에 위치한 작지만 널리 퍼진 비치 리조트 타운입니다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://media.istockphoto.com/photos/booby-cay-island-in-negril-jamaica-picture-id504194602?k=20&m=504194602&s=612x612&w=0&h=MYX7-ThNKyUGY43-boiPyiNBO48mubcTzLNa5RU6410="  width="400px" height="auto"></a></div></div>',
        },
        // 잠비아
        {
            coords:{lat:-15.3875259, lng:28.3228165},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:auto;width:400px;"><h1>잠비아-루사카</h1>루사카는 잠비아의 수도이자 잠비아 최대의 도시이다. 인구는 174만 명이다. 루사카라고 하는 이름은 1905년, 마을의 추장이었던 루사카에 유래되었고, 유럽에서 온 이주자에 의해서 이름이 붙여졌다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://mediaim.expedia.com/destination/1/feffb02b627dc3c1d8c96bd53fb23c38.jpg?impolicy=fcrop&w=400&h=225&q=mediumLow"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:-10.2290555, lng:31.193945},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:auto;width:400px;"><h1>잠비아-카사마</h1>카사마는 잠비아 북부에 위치한 도시로, 북부 주의 주도이며 인구는 200,000명이다. 해발 1,400m에 달하는 지대에 위치한다. <br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://cdn.pixabay.com/photo/2022/06/28/09/18/travel-7289249__340.jpg"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:-12.1668712, lng:26.3839765},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:auto;width:400px;"><h1>잠비아-솔웨지</h1>솔웨지는 잠비아의 도시로, 북서부 주의 주도이며 인구는 65,000명이다. 해발 1,235m에 달하는 고원 지대에 위치하며 주요 산업은 구리 채굴과 제련이다. 시내에서 5km 정도 떨어진 곳에는 석기 시대 유적이 있다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://mblogthumb-phinf.pstatic.net/20150909_215/kores_love_14417660806381PYjo_PNG/%C0%E1%BA%F16.png?type=w2"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:-15.2735504, lng:23.1501117},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:auto;width:400px;"><h1>잠비아-몽구</h1>몽구는 잠비아 서부에 위치한 도시로, 서부 주의 주도이며 인구는 44,310명이다. 루사카에서 북서쪽으로 620km 정도 떨어진 곳에 위치한다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="http://newsteacher.chosun.com/site/data/img_dir/2016/03/03/2016030300396_0.jpg"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:-13.6445104, lng:32.6447001},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:auto;width:400px;"><h1>잠비아-치파타</h1>치파타는 잠비아 동부에 위치한 도시로, 동부 주의 주도이며 인구는 98,416명이다. 해발 1,140m에 달하는 지대에 위치하며 말라위 국경 인근에 위치한다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://media-cdn.tripadvisor.com/media/photo-s/25/3b/14/d6/exterior.jpg"  width="400px" height="auto"></a></div></div>',
        },
        // 적도기니
        {
            coords:{lat:1.5890407, lng:10.8225732},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:auto;width:400px;"><h1>적도기니-시우다드데라파스</h1>시우다드데라파스는 적도 기니의 미래 수도를 목표로 건설 중인 도시로 행정 구역상으로는 지블로호 주에 속한다. 웰레은사스 주에서 분리되었다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://images.chosun.com/resizer/34v6gOal-zZZUZgxJGB4X0W8WPk=/1080x607/smart/cloudfront-ap-northeast-1.images.arcpublishing.com/chosun/CG7EFXY4PDHOPB7EQLN7G3WR2U.jpg"  width="400px" height="auto"></a></div></div>',
        },
        // 중앙아프리카공화국
        {
            coords:{lat:4.3946735, lng:18.5581899},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:auto;width:400px;"><h1>중앙아프리카공화국-방기</h1>방기는 중앙아프리카 공화국의 수도이자 가장 큰 도시이다. 인구는 53만 명이고 1889년에 프랑스가 쌓아 올린 기지에서 유래되었다. 콩고 강의 지류인 우방기 강 하류에 위치한다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://upload.wikimedia.org/wikipedia/commons/5/5a/Ubangi_river_near_Bangui.jpg"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:10.2933091, lng:22.7822485},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:auto;width:400px;"><h1>중앙아프리카공화국-비라오</h1>Birao는 중앙 아프리카 공화국의 14 개 현 중 하나 인 Vakaga의 수도이며 Ubangui-Shari의 식민지에있는 행정직이었습니다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://t1.daumcdn.net/cfile/blog/127EA61B4B62C0FF37"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:8.4101505, lng:20.6481794},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:auto;width:400px;"><h1>중앙아프리카공화국-엔델레</h1>은델레는 중앙아프리카공화국의 북부에 위치한 상업 도시이다. 은델레는 중앙아프리카 공화국 14개 현 중 하나인 바밍기방고랑 주의 주도이다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="http://www.ourtoday.co.kr/data/photos/20220519/art_16522333934415_43ccec.jpg"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:7.246608600000001, lng:16.4346979},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:auto;width:400px;"><h1>중앙아프리카공화국-파오우아</h1>Paoua는 중앙 아프리카 공화국의 Ouham-Pendé 현에 위치한 마을입니다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://msf.or.kr/sites/default/files/MSB39310_Medium.jpg"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:4.257109199999999, lng:15.7879371},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:auto;width:400px;"><h1>중앙아프리카공화국-베르베라티</h1>베르베라티는 중앙아프리카 공화국 남서부에 위치한 도시로, 중앙아프리카 공화국에서 세 번째로 큰 도시이다. 맘베레카데이 주의 주도이며 높이는 589m, 인구는 76,918명이다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://youimg1.tripcdn.com/target/ww0q1f000001gq66zD0A5_C_380_240_R5.png"  width="400px" height="auto"></a></div></div>',
        },
        // 중국
        {
            coords:{lat:45.7567307, lng:126.6424173},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:auto;width:400px;"><h1>중국-하얼빈</h1>하얼빈은 부성급시이자 중국 헤이룽장성의 성도이다. 쑹화 강 남쪽 기슭에 자리 잡고 있는 공업 도시이다. 하얼빈은 중국에서 10번째로 큰 도시로 만주 지방의 정치, 경제, 과학, 문화, 통신의 중심지이다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://ichef.bbci.co.uk/news/640/cpsprodpb/CF35/production/_116354035_shutterstock_editorial_11679210a.jpg"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:39.904211, lng:116.407395},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:auto;width:400px;"><h1>중국-베이징</h1>베이징 또는 북경은 중화인민공화국의 수도이며 상하이시에 이어 두 번째로 큰 도시이다. 허베이성으로 둘러싸여 있으며 동쪽으로는 톈진시와 경계를 접한다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://cdn.traveltimes.co.kr/news/photo/202101/111099_8327_5955.jpg"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:36.0662299, lng:120.38299},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:auto;width:400px;"><h1>중국-칭다오</h1>칭다오는 중화인민공화국 산둥성의 부성급시이다. 산둥 반도 남부에 위치한 산업 도시이며, 군항이다. 면적 1만1026km², 인구 838만명이다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://dynamic-media-cdn.tripadvisor.com/media/daodao/photo-s/01/e3/56/7b/caption.jpg?w=400&h=-1&s=1"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:32.0583799, lng:118.79647},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:auto;width:400px;"><h1>중국-난징</h1>난징시는 중화인민공화국 장쑤성의 지급시, 부성급시이다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://eb.findmybucketlist.com/city/new/cp/1218850_cp_00.jpg?update_date=2019-07-2413:11:22"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:31.230416, lng:121.473701},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:auto;width:400px;"><h1>중국-상하이</h1>상하이 또는 상해는 중국 본토 동부의 장강 하구에 있는 중화인민공화국의 최대 도시이자 세계 1위의 컨테이너 물류량을 보유한 직할시이다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://t1.daumcdn.net/cfile/tistory/99897D375C42FC1912"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:30.2741499, lng:120.15515},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:auto;width:400px;"><h1>중국-항저우</h1>항저우는 장강 삼각주 지역에 자리를 잡고 있으며 중화인민공화국 저장성의 성도이다. 상하이에서 180km쯤 떨어져 있으며, 상하이에서 고속열차로 약1시간 거리쯤에 있다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://post-phinf.pstatic.net/MjAxNzA5MTFfMjIg/MDAxNTA1MDk3NjU0Nzk0.1vNdTqNP8PmqN4zVqJHfMWyvWSeLFKrJiHCshOVFCJYg.a_hi5c2ZnxZuc0iIiEfQGDjvlBAyt2pZ8HgWECHtDYUg.JPEG/1.jpg?type=w1200"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:24.4795099, lng:118.0894799},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:auto;width:400px;"><h1>중국-샤먼</h1>샤먼은 중국 푸젠성 남부에 있는 지급시로, 국제적으로는 아모이로도 알려져 있다 푸젠성 내에서는 가장 큰 도시다. 중국의 5대 경제 특구 중 하나이고, 부성급 시로도 지정되어 있다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://t1.daumcdn.net/thumb/R720x0/?fname=http://t1.daumcdn.net/brunch/service/user/7wcA/image/QqsKLOEpcy1urB7vRTIpzo2Dn_I.jpg"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:23.1290799, lng:113.26436},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:auto;width:400px;"><h1>중국-광저우</h1>광저우 또는 광주는 중화인민공화국 남부 광둥성의 성도이자, 화남 지방 전체의 행정 중심지이다. 부성급시로서 성에 준하는 권한을 가지고 있다. 면적은 7,434km²이고, 인구는 약 1539만 명이다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://www.discoverhongkong.com/content/dam/dhk/intl/greater-bay-area/guangzhou/guangzhou_16_9.jpg"  width="400px" height="auto"></a></div></div>',
        },
        // 지부티
        {
            coords:{lat:11.825138, lng:42.590275},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:auto;width:400px;"><h1>지부티-지부티</h1>지부티 공화국, 줄여서 지부티는 아프리카 대륙의 아프리카의 뿔 지대에 있는 나라이며 수도는 지부티이다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://media-cdn.tripadvisor.com/media/photo-s/21/8e/04/c5/the-red-sea.jpg"  width="400px" height="auto"></a></div></div>',
        },
        // 짐바브웨
        {
            coords:{lat:-17.8216288, lng:31.0492259},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:auto;width:400px;"><h1>짐바브웨-하라레</h1>하라레는 짐바브웨의 수도이다. 원래 이름은 솔즈베리였지만, 1982년 4월 18일에 현재의 이름으로 바뀌었다. 행정상으로, 하라레는 주와 동등한 지위를 가진 독립적인 도시이다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://storage.doopedia.co.kr/upload/_upload/comm/travelworld/200910/27/400_125662817598775.jpg"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:-20.1457125, lng:28.5873388},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:auto;width:400px;"><h1>짐바브웨-불라와요</h1>불라와요는 짐바브웨에 있는 도시이다. 인구는 653,337명이다. 짐바브웨 서남부의 해발고도 1300m 지점에 위치한다. 은데벨레족이 살던 곳이었으며, 1893년 영국이 점령하였다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://pix10.agoda.net/geo/city/102517/1_102517_02.jpg?ca=6&ce=1&s=1920x822"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:-18.975755, lng:32.6691331},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:auto;width:400px;"><h1>짐바브웨-무타레</h1>무타레는 짐바브웨 동부 국경 가까이에 있는 도시로, 마니칼랜드주의 주도이다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://dynamic-media-cdn.tripadvisor.com/media/photo-o/0c/8c/26/51/a-bridge-over-the-main.jpg?w=700&h=-1&s=1"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:-18.3558779, lng:26.5019976},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:auto;width:400px;"><h1>짐바브웨-황게</h1>황게는 짐바브웨 북서부 마타 벨 랜드 북부의 황게 지구에 위치한 짐바브웨의 마을로 보츠와나와 잠비아와의 국경에 가깝습니다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://storage.doopedia.co.kr/upload/_upload/image/1209/22/120922017979319/120922017979319_thumb_400.jpg"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:-20.4888192, lng:27.8103124},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:auto;width:400px;"><h1>짐바브웨-플럼트리</h1>Plumtree는 짐바브웨에 있는 마을입니다. 마룰라 나무 옆에는 야생 매화가 많이 자랍니다. 이 도시는 한때 baKalanga에 의해 Getjenge라고 불렸습니다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://www.plumtreetowncouncil.co.zw/wp-content/uploads/resized/e1091bbcf978ec4fd3d185551f1ee5e0/header2-2000x1500_1400x1050.jpg"  width="400px" height="auto"></a></div></div>',
        },
        // 차드
        {
            coords:{lat:12.1348457, lng:15.0557415},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:auto;width:400px;"><h1>차드-은자메나</h1>은자메나는 차드의 수도이고, 인구는 2009년 현재 951,418명, 인구밀도는 9,148명으로 차드 제1의 도시다. 은자메나는 부근의 식료품 교역 중심지이기도 하며 소금, 대추야자, 곡물이 거래된다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://dynamic-media-cdn.tripadvisor.com/media/photo-o/09/8b/c9/b3/cinema-le-normandie.jpg?w=600&h=400&s=1"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:17.1946775, lng:21.5819996},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:auto;width:400px;"><h1>차드-파다</h1>파다는 차드 북동부에 위치한 도시로, 엔네디 주의 주도이며 인구는 23,786명이다. 차드의 대통령 이드리스 데비가 태어난 곳이기도 하다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR22gk8itRCXw0q-tV_9bvleUJaxeF7NkkEzw&usqp=CAU"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:9.35, lng:14.9666667},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:auto;width:400px;"><h1>차드-빨라</h1>차드 공화국, 줄여서 차드는 아프리카에 있는 공화국이다. 아프리카 중앙부에 위치하며 북쪽은 리비아, 동쪽은 수단 서쪽은 니제르, 카메룬, 그리고 차드 호를 건너 나이지리아와 접해 있는 사막과 사바나의 나라이다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://cdn-icons-png.flaticon.com/512/3371/3371951.png"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:8.566666699999999, lng:16.0833333},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:auto;width:400px;"><h1>차드-몽두</h1>아베셰는 차드 동부에 위치한 도시로, 와다이 주의 주도이며 인구는 78,191명이다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://t1.daumcdn.net/thumb/R720x0.fjpg/?fname=http://t1.daumcdn.net/brunch/service/user/79ne/image/q9vyqIYMs5faOUrxVD0I8w_NK-8.jpg"  width="400px" height="auto"></a></div></div>',
        },
        // 체코
        {
            coords:{lat:50.0755381, lng:14.4378005},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:auto;width:400px;"><h1>체코-프라하</h1>프라하는 체코의 수도이다. 인구는 약 128만 명이며, 광역도시권을 모두 포함하면 인구는 약 216만 명에 달한다. 프라하는 체코의 도시 중 가장 인구가 많은 도시이며, 유럽 연합에서 14번째로 인구가 많은 도시이다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="http://tourimage.interpark.com/BBS/Tour/FckUpload/201503/6356258929950226150.jpg"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:49.7384314, lng:13.3736371},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:auto;width:400px;"><h1>체코-필센</h1>플젠은 체코 서부 보헤미아 지방에 위치한 도시이며 플젠 주의 주도이다. 프라하에서 남서쪽으로 90km 정도 거리에 있으며 브르노, 오스트라바 다음으로 큰 공업 기술 중심 도시이다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://media.istockphoto.com/photos/aerial-view-of-the-great-synagogue-in-pilsen-czech-republic-synagogue-picture-id1225989349"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:49.1950602, lng:16.6068371},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:auto;width:400px;"><h1>체코-브르노</h1>브르노는 모라바 땅에 있으며 남모라바 주의 주도로 체코 공화국에서 두 번째로 큰 도시이다. 인구는 약 39만명이다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://mblogthumb-phinf.pstatic.net/MjAxOTA3MDdfMjQ5/MDAxNTYyNDc5ODU3MjE0.J0jAGvTet9AwPWV0ufIfKc6bxAjRV1z53cY18z4_eMMg.uBPYnHhfZ2E08DjIRpRHD-srEX8YfoeIG9n960r3-5cg.JPEG.neweunha/%EC%B2%B4%EC%BD%94_%EB%B8%8C%EB%A5%B4%EB%85%B8_(1).JPG?type=w800"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:49.2244365, lng:17.6627635},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:auto;width:400px;"><h1>체코-즐린</h1>즐린은 체코 남동부 모라바 지방에 위치한 도시로, 즐린 주의 주도이며 면적은 102.83km², 높이는 230m, 인구는 80,122명, 인구 밀도는 779명/km²이다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://cdn.discoverynews.kr/news/photo/202104/392932_49380_4721.jpg"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:49.8209226, lng:18.2625243},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:auto;width:400px;"><h1>체코-오스트라바</h1>오스트라바는 체코의 북동쪽 모라바와 실레시아 지역에 폴란드와의 국경에 가까이 위치한 공업 도시로 프라하, 브르노에 이어 세 번째로 크며 모라바슬레스코 주의 주도이다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://media.istockphoto.com/photos/city-of-ostrava-czech-republic-picture-id144353224"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:50.76627999999999, lng:15.0543387},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:auto;width:400px;"><h1>체코-리베레츠</h1>리베레츠는 체코 리베레츠 주의 주도로, 체코에서 6번째로 큰 도시이며 면적은 106.1km², 높이는 374m, 인구는 104,946명, 인구 밀도는 989명/km²이다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://t1.daumcdn.net/cfile/tistory/99B924475F2DD85A10"  width="400px" height="auto"></a></div></div>',
        },
        // 칠레
        {
            coords:{lat:-33.4488897, lng:-70.6692655},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:auto;width:400px;"><h1>칠레-산티아고</h1>산티아고 데 칠레는 칠레의 수도이다. 간단히 줄여서 산티아고라고 부르기도 한다. 인구는 2017년 기준으로 5,220,161명이며 중부 계곡에 위치해 있다. 1962년 월드컵 대회가 열린 4개 도시 중 하나이다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://eb.findmybucketlist.com/city/new/cp/1209201_cp_00.jpg?update_date=2019-08-1921:16:23"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:-29.9026691, lng:-71.2519374},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:auto;width:400px;"><h1>칠레-라세레나</h1>라 세레나는 칠레에서 두 번째로 역사가 깊은 도시로, 하나의 코무나를 이룬다. 라 세레나라는 말은 "잔잔한 것"이라는 뜻이다. 산티아고에서 북쪽으로 471 km 떨어져 있다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://dynamic-media-cdn.tripadvisor.com/media/photo-o/0f/fc/57/69/img-20141123-225658-largejpg.jpg?w=700&h=500&s=1"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:-36.8201352, lng:-73.0443904},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:auto;width:400px;"><h1>칠레-콘셉시온</h1>콘셉시온은 칠레 비오비오주의 도시이다. 남부 칠레의 농산물 집산지이다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://media-cdn.tripadvisor.com/media/photo-s/06/7f/af/61/cerro-concepcion.jpg"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:-41.468917, lng:-72.94113639999999},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:auto;width:400px;"><h1>칠레-푸에르토몬트</h1>푸에르토몬트는 칠레 로스라고스 주의 주도이다. 면적은 1,673km², 인구는 175,938이다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="http://monthly.chosun.com/upload/0604/0604_390.jpg"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:-53.1633845, lng:-70.9078263},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:auto;width:400px;"><h1>칠레-푼타아레나스</h1>푼타아레나스는 칠레 최남단의 중심 도시, 위치는 티에라델푸에고 제도에 포함된 행정 구역인 마가야네스 이 안타르티카칠레나 주에 속한다. 면적은 17,846.3km²이고 인구는 2002년 센서스 기준으로 119,496명이다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://dynamic-media-cdn.tripadvisor.com/media/photo-o/15/33/fc/e2/punta-arenas.jpg?w=700&h=500&s=1"  width="400px" height="auto"></a></div></div>',
        },
        // 카메룬
        {
            coords:{lat:3.8480325, lng:11.5020752},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:auto;width:400px;"><h1>카메룬-야운데</h1>야운데는 카메룬의 수도이며 중앙 주의 주도이다. 정치와 행정의 중심지이며, 인구는 1,430,000명으로 두알라 다음으로 인구가 가장 많은 도시이다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://dynamic-media-cdn.tripadvisor.com/media/photo-o/19/f5/96/97/img-20191022-223020-674.jpg?w=500&h=300&s=1"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:4.0510564, lng:9.7678687},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:auto;width:400px;"><h1>카메룬-두알라</h1>두알라는 카메룬 서부 해안에 위치하는 도시로 리토랄 주의 주도이다. 인구 약 200만으로 카메룬 최대의 도시이다. 카메룬 서부, 우리 강 하구에 위치한다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://media.istockphoto.com/photos/city-of-douala-cameroon-picture-id458085379?s=612x612"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:4.5791946, lng:13.6767958},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:auto;width:400px;"><h1>카메룬-베르투아</h1>베르투아는 카메룬의 도시로, 동부 주의 주도이며 인구는 88,462명이다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://www.cts.tv/plugin/editor/summernote/upload/10f6721f6da5c0078ac9dd3e01b865eb_thumb.png"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:9.322601599999999, lng:13.393389},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:auto;width:400px;"><h1>카메룬-가루아</h1>가루아는 카메룬 북부에 위치한 도시로, 북부 주의 주도이다. 인구는 490,000명이며 주요 산업은 섬유 공업이다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="http://cdn.bosa.co.kr/news/photo/202207/2177893_209388_055.jpg"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:2.9405941, lng:9.9101915},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:auto;width:400px;"><h1>카메룬-크리비</h1>Kribi는 카메룬의 해변 리조트 및 항구입니다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://1001beach.com/img/posts/2290/1200/kribi-2.jpg"  width="400px" height="auto"></a></div></div>',
        },
        // 카자흐스탄
        {
            coords:{lat:51.16052269999999, lng:71.4703558},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:auto;width:400px;"><h1>카자흐스탄-누르술탄</h1>누르술탄시은 카자흐스탄의 수도이다. 1997년 12월 10일 알마티에서 수도를 옮겼다. 카자흐스탄 북부에 있는 아크몰라주의 주도였으나, 수도가 되면서 아크몰라주에서 분리되었다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="http://www.e2news.com/news/photo/202112/238391_92820_247.jpg"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:49.8046835, lng:73.1093826},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:auto;width:400px;"><h1>카자흐스탄-카라간다</h1>카라간다는 카자흐스탄 카라간다 주의 주도이다. 카라간다 탄전의 중심 도시이며 주요 산업으로는 석탄업과 광산 기계 제조업, 식료품, 경공업이 있다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://dynamic-media-cdn.tripadvisor.com/media/photo-o/0a/32/0d/9f/2015.jpg?w=700&h=-1&s=1"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:52.2873032, lng:76.9674023},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:auto;width:400px;"><h1>카자흐스탄-파블로다르</h1>파블로다르는 카자흐스탄 북동부에 위치한 파블로다르 주의 주도이다. 이르티시 강에 면해 있고, 인구는 353,930 명이다. 수도 누르술탄로부터는 북동쪽으로 350km, 러시아의 옴스크에서는 남동쪽으로 350km 정도 떨어진 곳에 위치해 있다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://images.kiwi.com/photos/1200x628/almaty_kz.jpg"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:43.3666958, lng:68.4094405},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:auto;width:400px;"><h1>카자흐스탄-투르키스탄</h1>투르키스탄은 카자흐스탄 남부 투르키스탄주의 도시로, 시르다리야 강과 접하며 인구는 85,600명이다. 트랜스아랄 철도를 따라 쉼켄트에서 북서쪽으로 160km 정도 떨어진 곳에 위치한다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://storage.doopedia.co.kr/upload/_upload/jwupload/image/201311/12/20131112155937050/20131112155937050_thumb_1024.jpg"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:47.0944959, lng:51.9238373},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:auto;width:400px;"><h1>카자흐스탄-아티라우</h1>아티라우는 카자흐스탄의 도시이다. 소비에트 연방 시절에는 구리예프로 알려졌다. 아티라우 주의 주도이며 알마티에서 서쪽으로 2,700km, 아스트라한에서 동쪽으로 350km 떨어져 있다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://storage.doopedia.co.kr/upload/_upload/image/1512/15/151215019968589/151215019968589_thumb_400.jpg"  width="400px" height="auto"></a></div></div>',
        },
        // 카보베르데
        {
            coords:{lat:14.93305, lng:-23.5133267},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:auto;width:400px;"><h1>카보베르데-프라이아</h1>프라이아는 아프리카 세네갈 서쪽 대서양에 있는 섬나라인 카보베르데의 수도이다. 도시 이름은 포르투갈어로 "해변"을 뜻한다. 소타벤투 제도 산티아구섬의 남쪽 해안에 놓여있으며 프라이아 시의 행정 중심지이기도 하다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://dynamic-media-cdn.tripadvisor.com/media/photo-o/0b/6a/72/7c/aerial-view.jpg?w=600&h=400&s=1"  width="400px" height="auto"></a></div></div>',
        },
        // 카타르
        {
            coords:{lat:25.2854473, lng:51.53103979999999},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:auto;width:400px;"><h1>카타르-도하</h1>도하는 카타르의 수도이자 최대 도시이며, 페르시아 만과 접해 있다. 2015년 인구 조사에 따르면 도하의 인구는 95만 6천여 명이다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://i0.wp.com/eb.findmybucketlist.com/bucket/new/ho/2944536_ho_00.jpg?w=792&ssl=1"  width="400px" height="auto"></a></div></div>',
        },
        // 캄보디아 
        {
            coords:{lat:11.5563738, lng:104.9282099},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:auto;width:400px;"><h1>캄보디아-프놈펜</h1>프놈펜은 캄보디아의 수도이자, 행정, 경제, 문화의 중심지로 캄보디아 최대의 도시이다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://dynamic-media-cdn.tripadvisor.com/media/photo-o/10/e4/ce/b1/20171006-093816-01-largejpg.jpg?w=700&h=500&s=1"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:13.09573, lng:103.2022055},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:auto;width:400px;"><h1>캄보디아-바탐방</h1>바탐방은 캄보디아 북서부 바탐방 주의 주도로, 캄보디아에서 두 번째로 큰 도시이며 인구는 250,000명이다. 크메르 제국의 전성기였던 11세기에 설립되었으며 시암의 침공 이후에는 시암 동부 지방의 대표적인 상업 중심지로 성장했다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://www.hotelscombined.co.kr/rimg/dimg/49/f6/2a84e1d4-city-2605-16ab6baace0.jpg?width=1366&height=768&xhint=1472&yhint=1045&crop=true"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:13.3632533, lng:103.856403},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:auto;width:400px;"><h1>캄보디아-시엠레아프</h1>씨엠립는 캄보디아 씨엠립 주의 주도이다. 씨엠립은 17세기 타이의 아유타야 왕조와의 전쟁에서 승리한 것과 관련이 있다. 앙코르 와트, 바이욘 등이 있는 앙코르 유적군 관광의 거점이 되는 도시이다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://image.ajunews.com/content/image/2022/08/24/20220824145212287792.jpg"  width="400px" height="auto"></a></div></div>',
        },
        // 캐나다
        {
            coords:{lat:49.2827291, lng:-123.1207375},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:auto;width:400px;"><h1>캐나다-밴쿠버</h1>밴쿠버는 캐나다의 브리티시컬럼비아주 남서부에 있는 도시이자 캐나다에서 토론토와 몬트리올을 잇는 세 번째로 큰 도시이다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://img1.daumcdn.net/thumb/R800x0/?scode=mtistory2&fname=https%3A%2F%2Fblog.kakaocdn.net%2Fdn%2FbNohlI%2FbtqvBaYYt5s%2FSW0bNDoMsYCB9S3yX8qC60%2Fimg.jpg"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:51.04473309999999, lng:-114.0718831},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:auto;width:400px;"><h1>캐나다-캘거리</h1>캘거리는 캐나다 앨버타주에 있는 도시이다. 1988년 동계 올림픽이 이곳에서 열렸다. 캘거리는 캐나다 앨버타 주 남부 지방의 고원 지대에 있으며 록키 산맥으로부터 80km 떨어져 있는 곳에 위치해 있다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://dynamic-media-cdn.tripadvisor.com/media/photo-o/15/33/f5/8b/calgary.jpg?w=700&h=500&s=1"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:53.5460983, lng:-113.4937266},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:auto;width:400px;"><h1>캐나다-애드먼턴</h1>에드먼턴은 캐나다 앨버타주의 주도이다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://dynamic-media-cdn.tripadvisor.com/media/photo-o/1a/cf/35/c4/caption.jpg?w=600&h=400&s=1"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:49.8954221, lng:-97.1385145},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:auto;width:400px;"><h1>캐나다-위니펙</h1>위니펙은 캐나다의 매니토바주의 주도로, 주 인구의 절반 이상이 거주하고 있는 주 내 최대 규모의 도시이다. 서부 캐나다 대초원 지역의 끝에 위치하고 있어, 교통, 경제, 공업, 농업, 교육 등에서 중요한 역할을 담당하고 있다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://youimg1.tripcdn.com/target/10061f000001g3z579DB1_C_640_320_R5_Q70.jpg_.webp?proc=source%2Ftrip"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:45.4215296, lng:-75.69719309999999},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:auto;width:400px;"><h1>캐나다-오타와</h1>오타와는 캐나다의 수도이자, 지방자치단체로 온타리오주 내에 두 번째로 큰 도시이다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://www.travelnbike.com/news/photo/201907/84814_162669_4638.jpg"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:46.8130816, lng:-71.20745959999999},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:auto;width:400px;"><h1>캐나다-퀘벡</h1>퀘벡은 캐나다 퀘벡주의 주도이다. 퀘벡 주 카피탈나시오날 행정 지역의 중심 도시로, 퀘벡 주의회와 같은 주요 기관이 자리잡고 있다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://t1.daumcdn.net/cfile/tistory/99CADF495C90AA6008"  width="400px" height="auto"></a></div></div>',
        },
        // 케냐
        {
            coords:{lat:-1.2920659, lng:36.8219462},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:auto;width:400px;"><h1>케냐-나이로비</h1>나이로비는 케냐의 수도이다. 시원한 물을 뜻하는 마사이어 에와소 니이로비 또는 엥카레나이로비에서 현 지명이 유래했다는 설이 있다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://cdn.kbmaeil.com/news/photo/201210/267806_714061_2728.jpg"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:-0.3030988, lng:36.080026},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:auto;width:400px;"><h1>케냐-나쿠루</h1>나쿠루는 케냐의 도시로, 리프트밸리 주의 주도이며 인구는 약 300,000명이다. 케냐에서 네 번째로 큰 도시이며 나쿠루 호와 접한다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://storage.doopedia.co.kr/upload/_upload/image/1601/12/160112020036575/160112020036575_thumb_400.jpg"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:-0.0917016, lng:34.7679568},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:auto;width:400px;"><h1>케냐-키수무</h1>키수무는 케냐의 도시로, 니안자 주의 주도이며 인구는 355,024명이다. 해발 1,131m에 달하는 지대에 있으며, 빅토리아 호 연안에 위치한 항구 도시이며 케냐에서 세 번째로 큰 도시이다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://storage.doopedia.co.kr/upload/_upload/image5/2206/30/220630024355443/220630024355443_thumb_400.jpg"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:-4.0434771, lng:39.6682065},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:auto;width:400px;"><h1>케냐-몸바사</h1>몸바사 는 인도양을 접하는 케냐에서 2번째 규모가 큰 도시이다. 주요 항구와 국제 공항이 있다. 몸바사는 해양 관광 산업의 중심이다. 최초의 아라비아 이름은 "전쟁의 섬"을 뜻하는 만바사 이다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://dynamic-media-cdn.tripadvisor.com/media/photo-o/11/ff/d4/cb/mbabamb-3-largejpg.jpg?w=700&h=-1&s=1"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:-3.2191864, lng:40.1168906},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:auto;width:400px;"><h1>케냐-말린디</h1>말린디는 케냐의 도시로, 인구는 약 120,000명이며 인도양과 접한 항구 도시이다. 인도양에 진출한 무슬림 상인들이 이 곳에서 무역을 하면서 발전했다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://1001beach.com/img/posts/1325/1200/malindi-1.jpg"  width="400px" height="auto"></a></div></div>',
        },
        // 코모로
        {
            coords:{lat:-11.6455, lng:43.3333},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:auto;width:400px;"><h1>코모로-코모로</h1>코모로 연합 줄여서 코모로는 인도양에 위치한 공화국이며 섬나라이다. 코모로라는 이름은 아랍어로 "달"을 뜻하는 단어인 카마르에서 유래된 이름이다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://www.hotelscombined.co.kr/rimg/dimg/d3/d4/31e1fcd5-city-53679-16a68660180.jpg?width=1366&height=768&xhint=2634&yhint=1490&crop=true"  width="400px" height="auto"></a></div></div>',
        },
        // 코스타리카
        {
            coords:{lat:9.9280694, lng:-84.0907246},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:auto;width:400px;"><h1>코스타리카-산호세</h1>산호세는 코스타리카의 수도이자 코스타리카의 최대 도시로 정치/경제/문화의 중심지이다. 산호세주의 주도이기도 하다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://dynamic-media-cdn.tripadvisor.com/media/photo-o/0d/c7/a2/1c/t6-largejpg.jpg?w=700&h=-1&s=1"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:10.6345964, lng:-85.4406747},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:auto;width:400px;"><h1>코스타리카-라이베리아</h1>리베리아는 코스타리카 과나카스테주의 주도이다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://www.hotelscombined.co.kr/rimg/dimg/21/0a/c9f7e6b6-city-59-159750d9a46.jpg?width=1366&height=768&xhint=2796&yhint=2098&crop=true"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:9.9913106, lng:-83.04150779999999},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:auto;width:400px;"><h1>코스타리카-리몬</h1>리몬은 코스타리카 동부에 있는 항구 도시로, 리몬주의 주도이다. 푸에르토리몬으로 불리기도 한다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://media.istockphoto.com/photos/tropical-paradise-limon-costa-rica-caribbean-beach-travel-picture-id501604642?s=612x612"  width="400px" height="auto"></a></div></div>',
        },
        // 코트디부아르
        {
            coords:{lat:6.827622799999999, lng:-5.2893433},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:auto;width:400px;"><h1>코트디부아르-야무수크로</h1>야무수크로는 코트디부아르의 수도이다. 1983년에 수도가 되었다. 면적은 3,500km²이며, 인구는 200,659명이다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://youimg1.tripcdn.com/target/01033120008x7p0m3407A_C_640_320_R5_Q70.jpg_.webp?proc=source%2Ftrip"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:5.3599517, lng:-4.0082563},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:auto;width:400px;"><h1>코트디부아르-아비장</h1>아비장은 코트디부아르의 최대 도시이다. 한때 코트디부아르의 수도였지만 1983년에 수도가 북쪽으로 240km 떨어진 야무수크로로 이전되었다. 그러나 현재도 행정·경제의 중심지로서 사실상의 수도 기능을 맡고 있다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://cdn.cctoday.co.kr/news/photo/201505/904712_295117_0055.jpg"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:7.690466, lng:-5.0390536},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:auto;width:400px;"><h1>코트디부아르-부아케</h1>부아케는 코트디부아르의 도시로, 발레뒤반다마 주의 주도이며 인구는 775,300명이다. 아비장 다음으로 코트디부아르에서 두 번째로 큰 도시이며 야무수크로 북동쪽에 위치한다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTlXjmYcD7rjNJDakCjrRYvK2NU3uJQ6-eFAQ&usqp=CAU"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:6.715698199999999, lng:-3.4801349},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:auto;width:400px;"><h1>코트디부아르-아방구루</h1>아방구루는 코트디부아르 무아얭코모에 주의 주도로, 인구는 105,000명이다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://q-xx.bstatic.com/xdata/images/hotel/840x460/248037345.jpg?k=ab7c90b2ab1bb3c9843630cfe6661cf687f452236e6dd9bf624ea7d9d32d2a41&o="  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:9.4669337, lng:-5.6142558},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:auto;width:400px;"><h1>코트디부아르-코로고</h1>코로고는 코트디부아르의 북중부 사반 주에 있는 도시이다. 2008년 도시의 인구는 174,000명이었다. 목화, 케이폭, 기장, 땅콩, 옥수수, 마, 양, 염소, 다이아몬드 같은 물품을 생산하여 가공 처리한다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR72nYK-BfFqxDLdjDgPAVzKhsgy63km4NXnA&usqp=CAU"  width="400px" height="auto"></a></div></div>',
        },
        // 쿠바
        {
            coords:{lat:23.1135925, lng:-82.3665956},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:auto;width:400px;"><h1>쿠바-하바나</h1>아바나 또는 하바나는 쿠바의 수도이다. 서쪽에 치우쳐 있다. 공식 이름은 산 크리스토발 데 라 아바나이다. 인구는 210만명이다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://img1.daumcdn.net/thumb/R800x0/?scode=mtistory2&fname=https%3A%2F%2Ft1.daumcdn.net%2Fcfile%2Ftistory%2F9941A7335C036BB71E"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:22.1599753, lng:-80.4437781},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:auto;width:400px;"><h1>쿠바-시엔푸에고스</h1>시엔푸에고스는 쿠바 남부 연안에 위치한 도시로 시엔푸에고스 주의 주도이며 면적은 333km², 높이는 25m, 인구는 164,924명, 인구 밀도는 500명/km²이다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://youimg1.tripcdn.com/target/100j1f000001gprzhF814_C_640_320_R5_Q70.jpg_.webp?proc=source%2Ftrip"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:21.3926035, lng:-77.9053182},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:auto;width:400px;"><h1>쿠바-카마궤이</h1>카마궤이는 쿠바 중부에 있는 도시로 카마궤이 주의 주도이며 면적은 1,106km², 높이는 95m, 인구는 321,992명, 인구 밀도는 290명/km²이다. 쿠바의 수도인 아바나에서 550km 떨어져 있다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://img1.daumcdn.net/thumb/R658x0.q70/?fname=https://t1.daumcdn.net/news/202111/26/hani/20211126140614935daiz.jpg"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:20.8795129, lng:-76.2594981},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:auto;width:400px;"><h1>쿠바-올긴</h1>올긴은 쿠바의 도시로 올긴 주의 주도이며 면적은 655.9km², 높이는 5m, 인구는 346,191명, 인구 밀도는 528명/km²이다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://media.istockphoto.com/photos/cuba-holguin-caribbean-sea-hut-beach-sunset-picture-id179101904?s=612x612"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:20.01693, lng:-75.8301537},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:auto;width:400px;"><h1>쿠바-산티아고데쿠바</h1>산티아고데쿠바는 쿠바 제2의 도시로, 산티아고데쿠바 주의 주도이다. 쿠바 남동부 카리브 해 연안에 있는 항구 도시이다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://previews.123rf.com/images/julianpetersphotography/julianpetersphotography1703/julianpetersphotography170300040/73455547-%EC%82%B0%ED%8B%B0%EC%95%84%EA%B3%A0-%EB%8D%B0-%EC%BF%A0%EB%B0%94-2016%EB%85%84-1%EC%9B%94-4%EC%9D%BC%EC%97%90-%EC%BF%A0%EB%B0%94-%EC%97%AC%EC%84%B1-%EA%B0%80%EB%82%9C%ED%95%9C-%EC%A3%BC%EA%B1%B0-%EC%A7%80%EC%97%AD%EC%97%90-%EA%B1%B0%EB%A6%AC%EB%A5%BC-%EA%B1%B8%EC%96%B4.jpg"  width="400px" height="auto"></a></div></div>',
        },
        // 쿠웨이트
        {
            coords:{lat:29.375859, lng:47.9774052},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:auto;width:400px;"><h1>쿠웨이트-쿠웨이트시티</h1>쿠웨이트시티는 쿠웨이트의 수도이다. 인구는 191,000명이고 쿠웨이트의 가장 큰 도시이다. 시내에는 정부 청사나 기업 본사, 금융기관의 본점, 쿠웨이트 타워 등이 있다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://media-cdn.tripadvisor.com/media/photo-s/12/67/4f/1f/grand-majestic-hotel.jpg"  width="400px" height="auto"></a></div></div>',
        },
        // 콜롬비아
        {
            coords:{lat:6.2476376, lng:-75.56581530000001},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:auto;width:400px;"><h1>콜롬비아-메데인</h1>메데인은 콜롬비아에 있는 도시이다. 인구 2,499,080명으로 콜롬비아 제2위의 도시이며 콜롬비아 서부, 안티오키아 주의 주도이다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://blog.kakaocdn.net/dn/erXXDg/btqwMUACpVY/EcJdS35ra9UNTtlDZ3hIC1/img.jpg"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:4.710988599999999, lng:-74.072092},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:auto;width:400px;"><h1>콜롬비아-보고타</h1>보고타는 콜롬비아의 수도이며, 쿤디나마르카 주의 주도이기도 하다. 안데스 산맥의 고원 분지에 위치해 있다. 공식 명칭은 보고타 수도 구역이며, 1991년부터 2000년까지는 산타페데보고타라고 했다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://dynamic-media-cdn.tripadvisor.com/media/photo-o/01/08/3a/c2/twilight-view-over-bogota.jpg?w=700&h=500&s=1"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:3.4516467, lng:-76.5319854},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:auto;width:400px;"><h1>콜롬비아-산티아고데칼리</h1>칼리는 콜롬비아 서부 바예델카우카 주에 있는 도시이다. 정식명칭은 산티아고데칼리이며, 바예델카우카 주의 주도이다. 인구 2,068,386. 카우카 강 연안의 해발고도 950m 지점에 위치한다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://mediaim.expedia.com/destination/2/20830ecb9cc101e2e8f362c28add1f17.jpg?impolicy=fcrop&w=360&h=224&q=mediumLow"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:11.0041072, lng:-74.80698129999999},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:auto;width:400px;"><h1>콜롬비아-바랑키야</h1>바랑키야는 콜롬비아 북부 아틀란티코 주의 주도이다. 인구 1,113,016. 막달레나 강 하구, 카리브 해 연안에 위치한다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://heritage.unesco.or.kr/wp-content/uploads/2019/02/hd10_082_i1.jpg"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:1.2058837, lng:-77.285787},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:auto;width:400px;"><h1>콜롬비아-파스토</h1>파스토는 콜롬비아 나리뇨 주의 주도로, 인구는 399,723명이다. 공식 이름은 산후안데파스토이다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://dynamic-media-cdn.tripadvisor.com/media/photo-o/08/20/ab/3a/santuario-de-las-lajas.jpg?w=700&h=500&s=1"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:7.8890971, lng:-72.4966896},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:auto;width:400px;"><h1>콜롬비아-쿠쿠타</h1>쿠쿠타는 콜롬비아의 도시이다. 노르테데산탄데르 주의 주도이며 2005년 기준으로 인구는 74만명이다. 프란시스코 데 파울라 산탄데르의 생가로도 유명하다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://dynamic-media-cdn.tripadvisor.com/media/photo-o/08/a8/cb/76/malecon.jpg?w=700&h=500&s=1"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:8.750983, lng:-75.8785348},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:auto;width:400px;"><h1>콜롬비아-몬테리아</h1>몬테리아는 콜롬비아 코르도바 주의 주도로, 인구는 624,711명이다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://media.istockphoto.com/photos/riverbank-sinu-in-montera-colombia-picture-id1203823219"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:2.4448143, lng:-76.6147395},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:auto;width:400px;"><h1>콜롬비아-포파얀</h1>포파얀은 콜롬비아 카우카 주의 주도로, 인구는 258,653명이다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="http://m.rehmcoffee.co.kr/web/product/big/202101/8f2ec5507cfda7e01279822b066da762.jpg"  width="400px" height="auto"></a></div></div>',
        },
        // 콩고공화국
        {
            coords:{lat:-4.2633597, lng:15.2428853},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:auto;width:400px;"><h1>콩고공화국-브라자빌</h1>브라자빌은 인구 94만명이 살고 있는, 콩고 공화국의 수도이다. 콩고강 하구로부터 약 500km 상류에 있고 스탠리풀의 북서쪽에 위치하며 킨샤사와 마주보고 있다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://us.123rf.com/450wm/ravennka/ravennka1511/ravennka151100033/47859106-%EC%BD%A9%EA%B3%A0-%EA%B3%B5%ED%99%94%EA%B5%AD-%EC%BD%A9%EA%B3%A0-%EB%AF%BC%EC%A3%BC-%EA%B3%B5%ED%99%94%EA%B5%AD-%EC%BD%A9%EA%B3%A0-%EA%B3%B5%ED%99%94%EA%B5%AD-%EC%BD%A9%EA%B3%A0-%EB%B8%8C%EB%9D%BC%EC%9E%90%EB%B9%8C%EC%9D%98-%EA%B3%B5%EC%8B%9D-%EA%B5%AD%EA%B8%B0-%EB%B0%8F-%EB%B9%84%EC%9C%A8.jpg"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:-4.7691623, lng:11.866362},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:auto;width:400px;"><h1>콩고공화국-푸앵트누아르</h1>푸앵트누아르는 콩고 공화국 남서부 해안에 위치한 도시이다. 580,000명이 거주하며 브라자빌까지 연결되는 철도가 건설되면서 항구 도시로 개발하였다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://media.istockphoto.com/photos/gorges-de-diosso-red-rocks-in-the-republic-of-congo-picture-id1210289776?k=20&m=1210289776&s=612x612&w=0&h=HynlvVceugoX6R1L-hEkPZy1ni3WlxCulZ_kTvmNvBs="  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:0.0202834, lng:14.8892473},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:auto;width:400px;"><h1>콩고공화국-에툼비</h1>에툼비는 콩고 공화국 퀴베트우에스트 주에 위치한 마을이다. 주민들 대부분이 인근 숲에서 수렵 생활을 한다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://pds.joongang.co.kr/news/component/htmlphoto_mmdata/201707/18/1d0c85fe-2bcd-44ba-b235-af89a500afce.jpg"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:1.6154718, lng:16.0463837},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:auto;width:400px;"><h1>콩고공화국-우에소</h1>우에소는 콩고 공화국 북부에 위치한 도시로, 상가 주의 주도이며 카메룬과 국경을 접한다. 상가 강과 접하며 강 하류에 있는 브라자빌까지 운행하는 페리가 지나간다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://q-xx.bstatic.com/xdata/images/hotel/840x460/299979487.jpg?k=624f8a6b38abc590f361e092ab6df24ef1da37d152e9c6d21647209ee481406b&o="  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:1.6259451, lng:18.0539382},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:auto;width:400px;"><h1>콩고공화국-임퐁도</h1>임퐁도는 콩고 공화국 북동부에 위치한 도시로, 리쿠알라 주의 주도이며 인구는 약 20,000명이다. 우방기 강과 접하며 강을 경계로 콩고 민주 공화국과 국경을 접한다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://www.redcross.or.kr/icrc/file_util.do?action=image&display_filename=drc-ecosec-cd-e-01232-10.jpg&filepath=contents/85/1185/4315"  width="400px" height="auto"></a></div></div>',
        },
        // 콩고민주공화국 
        {
            coords:{lat:-4.4419311, lng:15.2662931},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:auto;width:400px;"><h1>콩고민주공화국-킨샤샤</h1>킨샤사는 콩고 민주 공화국의 수도이다. 시청 소재지는 곰베이다. 서쪽으로 콩고 공화국의 수도 브라자빌과 맞닿아 있다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://upload.wikimedia.org/wikipedia/commons/thumb/3/3c/Vue_Kinshasa.jpg/300px-Vue_Kinshasa.jpg"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:-5.8508719, lng:13.4627375},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:auto;width:400px;"><h1>콩고민주공화국-마타디</h1>마타디는 콩고 민주 공화국의 항구 도시로, 바콩고 주의 주도이다. 마타디는 콩고어로 "돌"을 뜻한다. 인구는 245,862명이며 콩고 강 좌안, 대서양과 킨샤사 사이에 위치한다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://mblogthumb-phinf.pstatic.net/MjAxODA3MDRfMjYx/MDAxNTMwNjg1Mjg0OTY0.bl4Dovo5eQUH-lXRUcLl1u2cMk0s_GPXgxOlJs9tOWog.Bv9RhdimsluCA9IPAdyswDI6kPCH6EnWhgKEnOTZ__Mg.JPEG.itravelworld/20180623_171450.jpg?type=w800"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:-11.6876026, lng:27.5026174},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:auto;width:400px;"><h1>콩고민주공화국-루붐바시</h1>루붐바시는 아프리카 중앙부 콩고 민주 공화국에 있는 도시이다. 콩고 민주 공화국 남부 카탕가 주의 주도이다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://media.istockphoto.com/photos/lubumbashi-democratic-republic-of-congo-young-woman-and-group-of-picture-id1092339124"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:0.5185303, lng:25.2007728},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:auto;width:400px;"><h1>콩고민주공화국-키상가니</h1>키상가니는 콩고 민주 공화국 북동부에 위치한 도시로, 동부 주의 주도이며 인구는 1,130,000명이다. 콩고 강 중류에 위치한다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://cdn.pixabay.com/photo/2019/05/19/22/19/kisangani-4215410_960_720.jpg"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:3.2515532, lng:19.7770261},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:auto;width:400px;"><h1>콩고민주공화국-게메나</h1>Gemena는 콩고 민주 공화국의 Sud-Ubangi 지방의 수도입니다. 인구는 350,511 명입니다. <br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://contents.verygoodtour.com/content/350/MV/0000/MLE/image/24730_0.jpg"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:0.114047, lng:29.3018011},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:auto;width:400px;"><h1>콩고민주공화국-부템보</h1>Butembo는 북동부 콩고 민주 공화국 북 키부 북에 위치한 도시로 비 룬가 국립 공원 서쪽에 위치하고 있습니다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://media.istockphoto.com/photos/cemetery-in-butembo-drc-picture-id1301269487?s=612x612"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:-6.1306709, lng:23.5966577},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:auto;width:400px;"><h1>콩고민주공화국-음부지마이</h1>음부지마이는 콩고 민주 공화국 남부에 위치한 도시로, 카사이오리앙탈 주의 주도이며 인구는 1,480,000명이다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://world.moleg.go.kr/oweb/images/countryFlag/CD_L.png"  width="400px" height="auto"></a></div></div>',
        },
        // 크로아티아
        {
            coords:{lat:44.8666232, lng:13.8495788},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:auto;width:400px;"><h1>크로아티아-풀라</h1>풀라는 크로아티아 이스트라주의 도시로 면적은 51.65km², 높이는 30m, 도시 인구는 62,080명, 지방 자치체 인구는 90,000명, 인구밀도는 1,201.9명/km²이다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://www.hotelscombined.co.kr/himg/c8/de/49/expediav2-3109388-c57344-996796.jpg"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:45.3270631, lng:14.442176},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:auto;width:400px;"><h1>크로아티아-리예카</h1>리예카는 크로아티아 서북부에 있는 도시로 프리모레고르스키코타르 주의 주도이다. 인구 144,043. 아드리아해에 딸린 크바르네르만과 접한 항구 도시이다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://previews.123rf.com/images/elec/elec1411/elec141100094/33429884-%ED%81%AC%EB%A1%9C%EC%95%84%ED%8B%B0%EC%95%84-%EB%A6%AC%EC%98%88-%EC%B9%B4-rijeka-%EB%8F%84%EC%8B%9C-%EC%A0%84%EB%A7%9D.jpg"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:44.119371, lng:15.2313648},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:auto;width:400px;"><h1>크로아티아-자다르</h1>자다르는 크로아티아 서쪽 달마티아 지방에 있는 도시이다. 남동쪽으로 115km 떨어진 곳에 스플리트가 있다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://t1.daumcdn.net/cfile/tistory/21417A4B5955D4032A"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:43.5147118, lng:16.4435148},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:auto;width:400px;"><h1>크로아티아-스플리트</h1>스플리트는 크로아티아 서남부 스플리트달마티아 주에 있는 도시이다. 인구 221,456. 아드리아 해와 마주하는 항구 도시이며, 크로아티아에서 수도 자그레브 다음으로 큰 도시이다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://youimg1.tripcdn.com/target/fd/tg/g5/M00/C7/32/CggYsVc6xeSAQnytABN66PW04eg867_C_640_320_R5_Q70.jpg_.webp?proc=source%2Ftrip"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:45.8150108, lng:15.981919},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:auto;width:400px;"><h1>크로아티아-자그레브</h1>자그레브은 크로아티아의 수도이다. 자그레브는 크로아티아의 북서쪽, 다뉴브 강의 지류인 사바 강 변에 위치해 있고, 메드베드니차 산의 남쪽에 위치해있다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://mblogthumb-phinf.pstatic.net/MjAxODAyMjhfMjAw/MDAxNTE5ODA0NDAyNTUz.9Rsg0OoVwbW7siLXJQOchdwwlpurwfUCxVXYCEq4l1Mg.jbLGOYy80raZyyfZYmsWAOxt5bOVqs9YkhT8y5P0M2Mg.JPEG.urimalo_/%ED%81%AC%EB%A1%9C%EC%95%84%ED%8B%B0%EC%95%84_%EC%9E%90%EA%B7%B8%EB%A0%88%EB%B8%8C_%EC%8A%A4%EC%B9%B4%EC%9D%B4%EB%9D%BC%EC%9D%B8.jpg?type=w800"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:45.5549624, lng:18.6955144},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:auto;width:400px;"><h1>크로아티아-오시예크</h1>오시예크는 크로아티아에서 네 번째로 큰 도시로 슬라보니아 지역의 경제적·문화적 중심지이자 오시예크바라냐 주의 주도이다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://dynamic-media-cdn.tripadvisor.com/media/photo-o/0c/8b/b1/b7/yosemite-ca.jpg?w=700&h=-1&s=1"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:45.8987972, lng:16.8423093},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:auto;width:400px;"><h1>크로아티아-볠로바르</h1>벨로바르는 크로아티아 중부에 위치한 도시로, 벨로바르빌로고라 주의 주도이며 면적은 191.9km², 높이는 135m, 인구는 41,869명이다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://upload.wikimedia.org/wikipedia/commons/thumb/f/f2/Bjelovar_Rotor.JPG/300px-Bjelovar_Rotor.JPG"  width="400px" height="auto"></a></div></div>',
        },
        // 키르기스스탄
        {
            coords:{lat:42.8746212, lng:74.5697617},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:auto;width:400px;"><h1>키르기스스탄-비슈케크</h1>비슈케크는 키르기스스탄의 수도이자 최대 도시이다. 인구는 약 100만 명이다. 키르기스스탄에서 생산되는 공업 생산품의 대부분을 생산하며, 농업기계, 건설자재, 직물, 의복 외에 식육콤비나트 및 양조공장이 있다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://t1.daumcdn.net/cfile/tistory/185C07594E0B3E8B38"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:40.5139985, lng:72.81609759999999},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:auto;width:400px;"><h1>키르기스스탄-오시</h1>오시는 키르기스스탄 서남부 오시 주에 있는 도시이다. 오시 주의 주도이며, 수도 비슈케크 다음가는 키르기스스탄 제 2의 도시이다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="http://f.xza.co.kr/http://www.morningsunday.com/data/morningsunday_com/mainimages/201910/2019102029359174.jpg"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:40.9331541, lng:72.9814877},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:auto;width:400px;"><h1>키르기스스탄-잘랄아바트</h1>잘랄아바트는 키르기스스탄 남서부에 위치한 도시로, 잘랄아바트 주의 주도이며 페르가나 분지 북동단에 위치한다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://mediaim.expedia.com/destination/1/b035fae8a617e3a5667e537e456c7674.jpg?impolicy=fcrop&w=384&h=216&q=medium"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:42.5317628, lng:72.2304571},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:auto;width:400px;"><h1>키르기스스탄-탈라스</h1>탈라스는 키르기스스탄의 북서쪽에 위치한 긴 계곡에 자리한 소도시이다. 인구는 1999년 기준으로 32,538명으로 탈라스 주의 행정 중심이다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://news.imaeil.com/photos/2022/08/10/2022081013473973944_l.jpg"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:42.4782102, lng:78.39559860000001},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:auto;width:400px;"><h1>키르기스스탄-프셰발스크</h1>카라콜은 키르기스스탄 동부에 위치한 도시로, 이식쿨 주의 주도이며 키르기스스탄의 수도인 비슈케크에서 380km 정도 떨어진 곳에 위치한다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://mblogthumb-phinf.pstatic.net/MjAxNzA3MjFfNDIg/MDAxNTAwNTk4Njc0MTA2.6pRxIUokUt14sDLrUjnm6T7PU1UnNDnPONoHn3wp8u0g.vEg3R1nr0RhDaKnVN_BNOHHxH0G2MQLwV4x2J2be6vUg.JPEG.sanghwanga/%ED%94%84%EC%85%B0%EB%B0%9C%EC%8A%A4%ED%81%AC_16.jpg?type=w800"  width="400px" height="auto"></a></div></div>',
        },
        // 키리바시
        {
            coords:{lat:-3.370417, lng:-168.734039},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:auto;width:400px;"><h1>키리바시-키리바시</h1>키리바시 공화국, 약칭 키리바시는 오세아니아의 미크로네시아에 있는 나라이다. 수도는 사우스타라와이며 공용어는 영어이다. 날짜변경선의 가장 동쪽에 있는 국가이다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://youimg1.tripcdn.com/target/0106a120008x0tmd4C598_C_640_320_R5_Q70.jpg_.webp?proc=source%2Ftrip"  width="400px" height="auto"></a></div></div>',
        },
        // 키프로스
        {
            coords:{lat:35.1855659, lng:33.38227639999999},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:auto;width:400px;"><h1>키프로스-니코시아</h1>니코시아는 키프로스와 북키프로스의 수도로, 인구는 313,400명인 도시이다. 원형의 성벽이 니코시아에 위치해 있고, 1960년 독립 이전부터 키프로스 섬의 중심지였다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://mblogthumb-phinf.pstatic.net/20151019_135/mocienews_1445245866143Fkt5m_JPEG/2p.jpg?type=w2"  width="400px" height="auto"></a></div></div>',
        },
        // 타지키스탄
        {
            coords:{lat:38.5597722, lng:68.7870384},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:auto;width:400px;"><h1>타지키스탄-두샨베</h1>두샨베는 타지키스탄의 수도로 인구는 58만 2,400명이다. 도시 이름은 타지크어로 "월요일"을 의미하는데 이는 월요일에 개장하는 시장이 있는 마을이 급성장했기 때문에 붙여진 이름이다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://obj-sg.thewiki.kr/data/65787465726e616c2f75706c6f61642e77696b696d656469612e6f72672f36343070782d44757368616e62655f70616e6f72616d615f30322e6a7067.jpg"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:40.2735091, lng:69.63923539999999},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:auto;width:400px;"><h1>타지키스탄-후잔트</h1>후잔트는 타지키스탄에서 두 번째로 큰 도시이며 수그드 주의 주도이다. 1939년에는 블라디미르 레닌의 이름을 딴 레니나바트라는 이름으로 바뀌었으나 1992년 원래의 이름을 되찾았다. <br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://youimg1.tripcdn.com/target/0ww1x12000956xmbh360F_C_640_320_R5_Q70.jpg_.webp"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:37.9273983, lng:69.8001762},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:auto;width:400px;"><h1>타지키스탄-쿨롭</h1>쿨로프은 타지키스탄 하틀론주의 도시로, 인구는 82,000명이며 두샨베에서 남동쪽으로 203km 정도 떨어진 곳에 위치한다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://dynamic-media-cdn.tripadvisor.com/media/photo-o/17/19/8a/ae/tajikistan.jpg?w=500&h=400&s=1"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:37.8456119, lng:68.79896169999999},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:auto;width:400px;"><h1>타지키스탄-쿠르곤텝파</h1>쿠르곤텝파는 타지키스탄 남서부에 위치한 도시로, 하틀론 주의 주도이며 두샨베에서 100km 정도 떨어진 곳에 위치한다. 인구는 85,000명이며 타지키스탄에서 세 번째로 큰 도시이다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://youimg1.tripcdn.com/target/0ww0s120008yau1p70367.jpg?proc=source%2Ftrip"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:39.8772715, lng:69.02549259999999},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:auto;width:400px;"><h1>타지키스탄-이스트라브샨</h1>이스트라브샨은 타지키스탄 수그드 주에 위치한 도시로 면적은 1,830km², 높이는 992m, 인구는 54,200명이다. 후잔트에서 남서쪽으로 78km 정도 떨어진 곳에 위치하며 2,500년의 역사를 자랑한다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://youimg1.tripcdn.com/target/ww0u1f000001gozdk9E8B_D_1180_558.png"  width="400px" height="auto"></a></div></div>',
        },
        // 탄자니아
        {
            coords:{lat:-6.162959000000001, lng:35.7516069},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:auto;width:400px;"><h1>탄자니아-도도마</h1>도도마는 탄자니아의 법률상의 수도이며 도도마 주의 주도이다. 1973년에 다르에스살람에서 도도마로 옮길 것이라는 국민투표가 결정했다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://pix10.agoda.net/geo/city/162506/1_162506_02.jpg?ca=6&ce=1&s=1920x822"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:-6.792354, lng:39.2083284},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:auto;width:400px;"><h1>탄자니아-다르에스살람</h1>다르에스살람은 탄자니아의 옛 수도이며 가장 큰 도시이다. 1961년에서 1964년까지는 탕가니카의 수도였다. 다르에스살람은 아랍어로 "평화의 집", "평화의 땅"을 뜻한다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://youimg1.tripcdn.com/target/100s10000000pl5aoAF6D_C_640_320_R5_Q70.jpg_.webp?proc=source%2Ftrip"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:-8.9094014, lng:33.4607744},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:auto;width:400px;"><h1>탄자니아-음베야</h1>므베야는 탄자니아 남서부에 위치한 도시로, 므베야 주의 주도이며 인구는 690,598명이다. 해발 1,700m에 달하는 지대에 위치한다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://youimg1.tripcdn.com/target/0ww3l120009544i073FD1_D_1180_558.jpg"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:-2.5164305, lng:32.9174517},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:auto;width:400px;"><h1>탄자니아-므완자</h1>므완자는 탄자니아의 도시로, 빅토리아 호반 남쪽에 위치한다. 므완자 주의 주도이기도 하며 인구는 476,646명이다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://storage.doopedia.co.kr/upload/_upload/image5/2207/31/220731024383708/220731024383708_thumb_400.jpg"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:-10.3112236, lng:40.1759806},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:auto;width:400px;"><h1>탄자니아-무트와라</h1>므트와라는 탄자니아 남동부에 위치한 도시로, 므트와라 주의 주도이며 인구는 79,277명이다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://mediaim.expedia.com/destination/1/82e9e63c1be46a0ca8a1c4d97fbbba1a.jpg?impolicy=fcrop&w=400&h=225&q=mediumLow"  width="400px" height="auto"></a></div></div>',
        },
        // 태국
        {
            coords:{lat:13.7563309, lng:100.5017651},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:auto;width:400px;"><h1>태국-방콕</h1>방콕, 통칭 끄룽텝 마하나콘, 더 줄여서 끄룽텝은 태국의 수도이자 가장 큰 도시이다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://tourimage.interpark.com//Spot/301/20190/201909/6370491993334989420.jpg"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:18.7883439, lng:98.98530079999999},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:auto;width:400px;"><h1>태국-치앙마이</h1>치앙마이는 태국 북부에서 가장 크고 문화적으로 중요한 도시이자 치앙마이 주의 주도이다. 방콕에서 북쪽으로 700km 떨어진 차오프라야 강의 지류인 삥 강 기슭에 있다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://post-phinf.pstatic.net/MjAxNzEyMjhfMTc1/MDAxNTE0NDI1MzU5NzQx.2EZ7bcDO6k7MCQdT1Mu1TyyLIe33dPvqIanZeLaIic4g.wQb9QHTSsrf99f1qzM5LotXeGdqOyfgqrWolEzZyfP8g.JPEG/00_%EC%B9%98%EC%95%99%EB%A7%88%EC%9D%B4_1.jpg?type=w1200"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:12.9235557, lng:100.8824551},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:auto;width:400px;"><h1>태국-파타야</h1>파타야는 태국 촌부리주의 도시로, 타이 만의 동쪽 해안에 있는 동남의 유명한 휴양지이다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://blog.kakaocdn.net/dn/bep77U/btqK825SYri/ykN9KaeACymsWrbUwd3GkK/img.jpg"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:7.8804479, lng:98.3922504},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:auto;width:400px;"><h1>태국-푸껫</h1>푸껫주는 태국 남부의 주이다. 푸껫 국제공항이 이곳에 있다. 푸껫섬은 인도양의 안다만 해역에 있으며, 방콕에서 약 860km 떨어진, 깨끗하고 매력적인 섬이다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://static.hubzum.zumst.com/hubzum/2016/12/26/16/bb2744d6b8ae4147bb7748128106d7c5_780x0c.jpg"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:7.189765899999998, lng:100.5953813},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:auto;width:400px;"><h1>태국-송클라</h1>송클라는 태국 남부의 송클라 주에 있는 도시이다. 인구는 2006년 기준으로 75,048명이다. 도시는 핫야이-송클라 도시권의 일부이다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRqt_aBAVjzSH-xOtl6w8DvuDvi8moFoWyZrQ&usqp=CAU"  width="400px" height="auto"></a></div></div>',
        },
        // 토고
        {
            coords:{lat:10.8733058, lng:0.2010233},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:auto;width:400px;"><h1>토고-다파옹</h1>다파옹은 토고 사반 주의 주도로, 로메에서 북쪽으로 638km 정도 떨어진 곳에 위치하며 부르키나파소와 국경을 접하는 지점 근처에 위치한다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://media-cdn.tripadvisor.com/media/photo-s/07/4a/15/bc/plage-robinson-hotel.jpg"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:9.5486112, lng:1.1977158},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:auto;width:400px;"><h1>토고-카라</h1>카라는 토고의 도시로, 카라 주의 주도이며 인구는 109,287명이다. 토고 북부 지방의 중심 도시이며 수도 로메와 소코데 다음으로 토고에서 세 번째로 큰 도시이다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://dynamic-media-cdn.tripadvisor.com/media/photo-o/0f/2c/5a/7d/koutammakou.jpg?w=700&h=-1&s=1"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:7.5286908, lng:1.1305049},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:auto;width:400px;"><h1>토고-아타크파메</h1>아타크파메는 토고 플라토 주의 주도로, 인구는 84,979명이며 토고에서 5번째로 인구가 많은 도시이다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://mblogthumb-phinf.pstatic.net/MjAxODA0MThfMTE4/MDAxNTI0MDExMjk1NTUy.I--LwwIju9BB4kX1L3WM7n36C3kXGHGaewPij7cvjbQg.J4gFb1WQ0zPkbzqAqp2HdkWCj0GgzZLs3ejyqyfGzPcg.JPEG.perryjerry77/%ED%86%A0%EA%B3%A0_%EA%B0%95%EC%98%81%EB%A7%8C02.jpg?type=w800"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:6.1256261, lng:1.2254183},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:auto;width:400px;"><h1>토고-로메</h1>로메는 토고의 수도이다. 1998년의 인구는 약 70만명이다. 기니 만에 접하고, 토고의 중심이 되는 항만뿐만이 아니라 공업의 중심지이다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://mblogthumb-phinf.pstatic.net/MjAxNzA3MTBfMjMg/MDAxNDk5NjY3ODAwNzUx.MX_31vJSJQOgk_TokrDDkAKbMNsasQpxj-IgAxNuJ1sg.7zOc2GXvo9uNPMcgnfWodrQYFbQsy09SYXc-Fjbgup4g.JPEG.mrahnn/naver_com_20170710_152256.jpg?type=w2"  width="400px" height="auto"></a></div></div>',
        },
        // 통가
        {
            coords:{lat:-21.178986, lng:-175.198242},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:auto;width:400px;"><h1>통가-통가</h1>통가 왕국, 약칭 통가는 오세아니아의 폴리네시아에 있는 국가로, 수도는 누쿠알로파이다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://mblogthumb-phinf.pstatic.net/MjAxODAyMTFfMTYx/MDAxNTE4MjkxNjM2NjQ1.ykBsqcVc9mhdg50A-7bI9D2JjDY9L-DNaV3LHoT-Ti8g.UW9_C05VMexBhi3qmuz_SWR5zXgIcifUDFG9P9QC7W0g.JPEG.byunsawoo/213690-Tonga.jpg?type=w800"  width="400px" height="auto"></a></div></div>',
        },
        // 투르크메니스탄
        {
            coords:{lat:41.8368737, lng:59.9651904},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:auto;width:400px;"><h1>투르크메니스탄-다쇼구즈</h1>다쇼구즈는 투르크메니스탄 북부에 위치한 도시로 다쇼구즈 주의 주도이며 인구는 166,500명이다. 과거 타샤우즈라는 이름으로 불린 곳이며 도시 이름은 투르크멘어로 "돌의 샘"을 뜻한다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://media.istockphoto.com/photos/the-turquoise-crater-karakum-desert-north-of-darvaza-dashoguz-picture-id1297492637"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:39.0041313, lng:63.568808},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:auto;width:400px;"><h1>투르크메니스탄-투르크메나바트</h1>투르크메나바트는 투르크메니스탄에서 두 번째로 인구가 많은 도시이다. 레바프 주의 주도로 인구는 20만명이다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTMkND71dwvp1jgIDnZONiuSaGTp_9FyjMiVg&usqp=CAU"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:37.8099917, lng:65.2026017},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:auto;width:400px;"><h1>투르크메니스탄-아타무라트</h1>아타무라트는 투르크메니스탄 동부 레바프 주에 위치한 도시로 인구는 96,720명이다. 아무다리야 강 좌안과 접하며 투르크메나바트에서 남동쪽으로 200km 정도 떨어진 곳에 위치한다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://img1.daumcdn.net/thumb/R800x0/?scode=mtistory2&fname=https%3A%2F%2Ft1.daumcdn.net%2Fcfile%2Ftistory%2F9930744A5F00B7D908"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:37.6092461, lng:61.86432519999999},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:auto;width:400px;"><h1>투르크메니스탄-마리</h1>마리는 투르크메니스탄에서 두 번째로 큰 도시로 마리 주의 주도이다. 카라쿰 운하와 무르그합 강이 교차하는 곳에 위치하고 있으며, 수도인 아시가바트에서 동쪽으로 약 350km 떨어져 있다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://storage.doopedia.co.kr/upload/_upload/image/1512/15/151215019968832/151215019968832_thumb_400.jpg"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:37.9600766, lng:58.32606289999999},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:auto;width:400px;"><h1>투르크메니스탄-아슈하바트</h1>아시가바트는 투르크메니스탄의 수도이다. 옛 이름은 러시아어 표기를 로마자로 옮긴 아슈하바트, 폴토라츠크이다. 코펫다크 산맥 주변에 위치하고 주요 산업은 금속 가공업, 유리 제조, 포도주 양조, 면직물업이다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://static.educalingo.com/img/ko/800/asyuhabateu.jpg"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:40.0336591, lng:52.9759299},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:auto;width:400px;"><h1>투르크메니스탄-투르크멘바시</h1>튀르크멘바시는 중앙아시아 투르크메니스탄 서부 발칸 주의 카스피해에 접해 있는 항구도시다. 인구 약 68000명.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://img7.yna.co.kr/photo/yna/YH/2019/04/18/PYH2019041821270001300_P2.jpg"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:38.97043499999999, lng:56.31530129999999},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:auto;width:400px;"><h1>투르크메니스탄-세르다르</h1>투르크메니스탄은 중앙아시아에 있는 이슬람 공화국이다. 북서쪽, 북쪽, 동쪽으로 우즈베키스탄, 남동쪽으로 아프가니스탄, 남쪽과 남서쪽으로 이란, 서쪽으로 카스피해가 닿아 있다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://img.seoul.co.kr/img/upload/2020/11/13/SSI_20201113075518_V.jpg"  width="400px" height="auto"></a></div></div>',
        },
        // 투발루
        {
            coords:{lat:-7.109534999999999, lng:177.64933},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:auto;width:400px;"><h1>투발루-투발루</h1>투발루는 오세아니아의 폴리네시아에 있는 섬나라로, 키리바시, 나우루, 사모아, 피지와 가깝고 하와이와 오스트레일리아 사이의 중간 쯤에 위치한다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://www.gndaily.kr/news/photo/202009/37062_265818_5115.jpg"  width="400px" height="auto"></a></div></div>',
        },
        // 튀니지
        {
            coords:{lat:36.8064948, lng:10.1815316},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:auto;width:400px;"><h1>튀니지-튀니스</h1>튀니스는 튀니지의 수도이다. 2008년 기준 인구 120만 명으로 튀니지에서 가장 큰 도시이다. 큰 지중해 만 위에, 튀니스 호수와 라굴레트 항구 의 뒤에 위치한 도시는 그곳을 둘러싼 해안의 평야와 언덕을 따라 뻗어 있다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://t1.daumcdn.net/tistoryfile/fs12/3_tistory_2008_10_23_06_54_48ffa108f15c4?original"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:37.2767579, lng:9.8641609},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:auto;width:400px;"><h1>튀니지-비제르트</h1>비제르테는 튀니지 비제르테 주의 주도이다. 인구는 114,371명이다. 튀니스에서 15km 떨어져 있다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://storage.doopedia.co.kr/upload/_upload/image/1206/10/120610017792467/120610017792467_thumb_400.jpg"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:34.739822, lng:10.7600196},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:auto;width:400px;"><h1>튀니지-스팍스</h1>스팍스는 튀니지 남부 상공업의 중심지로 인구 약 330,440명으로 튀니지에서 두번째로 크다. 인광석의 선적항이다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://dynamic-media-cdn.tripadvisor.com/media/photo-o/18/cb/fb/2b/img-20190813-193236-largejpg.jpg?w=500&h=300&s=1"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:35.17227159999999, lng:8.8307626},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:auto;width:400px;"><h1>튀니지-카쎄린</h1>카세린주는 알제리와 접하는 튀니지 서부의 주로, 주도는 카세린이다. 면적은 8,066km²이며, 인구는 412,278명이다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://q-xx.bstatic.com/xdata/images/hotel/840x460/279619371.jpg?k=557c29ee896b1b503dbc722aa5689e04684a819d05c3995a3b53ac7e3260941d&o="  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:33.5041035, lng:11.0881494},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:auto;width:400px;"><h1>튀니지-자르지스</h1>자르지스는 튀니지 메드닌주의 도시이다. 인구는 70,859명(2004년)이다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://q-xx.bstatic.com/xdata/images/hotel/max1024x768/12292610.jpg?k=b12623311485c6ca4bf9851efc61c844976fd941da8eabc808b69c6998ff6c8c&o="  width="400px" height="auto"></a></div></div>',
        },
        // 터키
        {
            coords:{lat:41.0082376, lng:28.9783589},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:auto;width:400px;"><h1>터키-이스탄불</h1>이스탄불은 튀르키예의 최대 도시이다. 행정 구역상 이스탄불주에 속해 있다. 터키 서부에 있고 마르마라해와 흑해를 연결하는 보스포루스 해협을 가운데에 두고 아시아와 유럽 양 대륙에 걸쳐 있다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://youimg1.tripcdn.com/target/10060g0000007qh9aB677_C_640_320_R5_Q70.jpg_.webp?proc=source%2Ftrip"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:38.423734, lng:27.142826},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:auto;width:400px;"><h1>터키-이즈미르</h1>이즈미르는 터키의 3대 도시이며, 이스탄불 다음으로 큰 항구이다. 역사적으로는 스미르나라고 불렸다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://eb.findmybucketlist.com/city/new/cp/1210327_cp_00.jpg?update_date=2019-08-1921:16:15"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:40.1885281, lng:29.0609636},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:auto;width:400px;"><h1>터키-부르사</h1>부르사는 아나톨리아 북서부 마르마라 지역에 있는 터키의 대도시이다. 터키 내에서 네 번째로 인구가 많은 도시이자, 가장 산업화가 이뤄진 대도시권 도시 중 한 곳이며, 부르사주의 주도이기도 하다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://post-phinf.pstatic.net/MjAyMDA2MDRfMjAw/MDAxNTkxMjM2ODY0ODA0.NPLXKhpeDi5Z2nXbL_oHOt8dtDiJme5LqLy9ag0QD3Qg.y3DeO-cVhk4hXYk8VlQ7kzxfPM0ktyE2Cu1b3gFVykQg.PNG/%EB%A7%8C%EA%B0%9C%EC%9D%98%EB%8F%84%EC%8B%9C%281%29.png?type=w1200"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:39.9333635, lng:32.8597419},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:auto;width:400px;"><h1>터키-앙카라</h1>앙카라는 튀르키예의 수도이다. 이스탄불에 이어 두 번째로 큰 도시이며 앙카라 주의 주도이기도 하다. 인구는 4,587,558명이고, 앙카라 주의 인구는 5,150,072명이다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://dynamic-media-cdn.tripadvisor.com/media/photo-o/15/33/fd/6f/ankara.jpg?w=700&h=500&s=1"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:36.8968908, lng:30.7133233},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:auto;width:400px;"><h1>터키-안탈리아</h1>안탈리아는 지중해 연안에 위치한 터키의 도시이다. 산으로 둘러싸인 이 도시는 안탈리아 주의 주도이며 특히 프로 축구 클럽들이 전지훈련을 위해 자주 찾는 도시로 잘 알려져 있다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://file2.nocutnews.co.kr/newsroom/image/2016/05/19/20160519150951316487.jpg"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:37.8746429, lng:32.4931554},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:auto;width:400px;"><h1>터키-코니아</h1>콘야는 터키의 내륙 중부 아나톨리아 지방의 주요 도시 중 하나이다. 콘야는 2011년 현재 약 110만 명이 사는 터키에서 7번째로 인구가 많은 도시이다. 콘야 주의 주도이며, 콘야 주에서 가장 경제, 산업, 문화 등이 발전된 도시이다. <br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://post-phinf.pstatic.net/MjAyMDA0MTVfMjE5/MDAxNTg2OTEzOTg1NzU3.karwBQGndmBq4cG5ctpOUnONRFG3kWpuxwzM2_vdPY0g.LqoPj7AZUIzrO7kY0GlnsNlI6-nuQsDqYSMlfBMHLYog.PNG/5.png?type=w1200"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:38.720489, lng:35.48259700000001},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:auto;width:400px;"><h1>터키-카이세리</h1>카이세리는 터키 중앙부에 있는 도시이다. 인구는 약 100만명이고 튀르키예에서 4번째로 높은 산인 엘제스 산를 근처에 있다. 옛날에는 카파도기아 왕국의 수도일 때, 마자카로 불렸다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://t1.daumcdn.net/cfile/blog/997AAE465B3A4CC801"  width="400px" height="auto"></a></div></div>',
        },
        // 트리니다드토바고
        {
            coords:{lat:10.691803, lng:-61.222503},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:auto;width:400px;"><h1>트리니다드토바고-트리니다드토바고</h1>토바고섬은 소앤틸리스 제도에서 트리니다드섬의 북동쪽 약 30km에 위치하는 작은 섬이다. 트리니다드 토바고의 영토이다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://dynamic-media-cdn.tripadvisor.com/media/photo-o/15/33/f5/52/trinidad-and-tobago.jpg?w=700&h=500&s=1"  width="400px" height="auto"></a></div></div>',
        },
        // 파나마
        {
            coords:{lat:8.4007278, lng:-82.4427769},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:auto;width:400px;"><h1>파나마-다비드</h1>다비드는 파나마 서부의 도시로 치리키 주의 주도다. 1602년 세워졌고, 파나마에서 부유한 도시 중 하나이다. 팬아메리칸 하이웨이가 지나가고, 다비드 강이 흐른다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://media.istockphoto.com/photos/panamanian-men-swimming-in-river-near-david-panama-picture-id534741615"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:8.0759622, lng:-80.9688946},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:auto;width:400px;"><h1>파나마-산티아고</h1>산티아고데베라과스는 파나마 중부에 위치한 도시로 베라과스 주의 주도이며 면적은 975km², 높이는 101m, 인구는 88,997명이다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://media.istockphoto.com/photos/santiago-fortress-in-portobelo-picture-id931305496"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:8.8828941, lng:-79.77363059999999},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:auto;width:400px;"><h1>파나마-라초레라</h1>라초레라는 파나마 중부에 위치한 도시로 서파나마 주의 주도이며 면적은 40km², 인구는 62,803명이다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://content.r9cdn.net/rimg/himg/ed/3d/95/leonardo-65523501-ptybw-pool-5643-hor-clsc_O-185669.jpg?crop=true&width=500&height=350"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:7.9523119, lng:-80.4382153},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:auto;width:400px;"><h1>파나마-치트레</h1>치트레는 파나마 중부에 위치한 도시로 에레라 주의 주도이며 면적은 12.4km², 높이는 24m, 인구는 9,092명이다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://dynamic-media-cdn.tripadvisor.com/media/photo-o/07/8c/6f/19/chitre.jpg?w=700&h=500&s=1"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:8.9614604, lng:-79.51320609999999},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:auto;width:400px;"><h1>파나마-파나마</h1>파나마 공화국은 북아메리카 최남단인 파나마 지협에 있는 나라이다. 서쪽으로는 코스타리카, 동쪽으로는 콜롬비아와 국경을 접하고 있다. <br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://mediaim.expedia.com/destination/1/d5ab8e549e1cfa831dcb33b7e1b0352d.jpg?impolicy=fcrop&w=360&h=224&q=mediumLow"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:9.359302, lng:-79.89986080000001},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:auto;width:400px;"><h1>파나마-콜론</h1>콜론은 파나마 중부에 있는 도시로 콜론 주의 주도이다. 2000년 현재 인구는 약 20만4천명이다. 1900년 당시의 인구는 약 3,000명 정도였다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://www.snmnews.com/news/photo/201606/358742_249029_5336.jpg"  width="400px" height="auto"></a></div></div>',
        },
        // 파라과이
        {
            coords:{lat:-25.2637399, lng:-57.57592599999999},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:auto;width:400px;"><h1>파라과이-아순시온</h1>아순시온은 파라과이 최대 도시이자 수도이며, 인구는 85만 명 정도다. 파라과이강 좌안과 접하며, 남아메리카에서 오랜 역사를 가진 도시 가운데 하나다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://cdn.dailybizon.com/news/photo/201901/12394_5695_490.jpg"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:-27.2522918, lng:-55.9135867},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:auto;width:400px;"><h1>파라과이-엥카르나시온</h1>엥카르나시온은 파라과이 남동부에 위치한 도시로 이타푸아 주의 주도이며 면적은 558km², 높이는 91m, 인구는 93,497명이다. <br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://youimg1.tripcdn.com/target/01062120008x80k7r4FE7_D_1180_558.jpg?proc=source%2Ftrip"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:-25.4645818, lng:-56.013851},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:auto;width:400px;"><h1>파라과이-카아과수</h1>카과수 주는 파라과이 남동부에 위치한 주로 주도는 코로넬오비에도이며 면적은 11,474km², 인구는 448,983명, 인구 밀도는 39명/km²이다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://w.namu.la/s/0a2ebdfdb87921328e1cd6d2d3050f561eeaed328dcdf24a0188fee76616534f50be0a5b4946a932617fe015d0a8c77728e5483733ddd87f94b09a040c976a5fc8b593c9423a61a9212cf66af9c06e2f1c5039f82099ad6589a6f76c6fd14384"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:-22.352316, lng:-60.0375098},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:auto;width:400px;"><h1>파라과이-필라델피아</h1>필라델피아는 파라과이 서부에 위치한 도시로 보케론 주의 주도이며 인구는 9,713명이다. 1930년 소련을 탈출한 러시아계 메노나이트에 의해 건설되었다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://cdn.travie.com/news/photo/first/201801/img_20087_1.jpg"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:-23.4214264, lng:-57.43444509999999},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:auto;width:400px;"><h1>파라과이-콘셉시온</h1>콘셉시온은 파라과이 북부에 위치한 도시로 콘셉시온 주의 주도이며 면적은 8,490km², 높이는 44m, 인구는 76,378명이다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://dynamic-media-cdn.tripadvisor.com/media/photo-o/16/a3/4d/28/el-roble.jpg?w=500&h=300&s=1"  width="400px" height="auto"></a></div></div>',
        },
     	// 파키스탄
        {
            coords:{lat:33.6844202, lng:73.04788479999999},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:auto;width:400px;"><h1>파키스탄-이슬라마바드</h1>파키스탄의 수도. 이 나라 북부, 라왈핀디 북동쪽 약 10km에 있음. 인구 20만 1000명. 1956년 파키스탄이 이슬람공화국이 되면서 수도를 카라치에서 이슬라마바드로 옮기기로 결정하고 1959년부터 10개년 계획으로 새 수도를 건설했음.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://search.pstatic.net/common/?src=http%3A%2F%2Fblogfiles.naver.net%2FMjAxODAzMDFfMTY1%2FMDAxNTE5OTEwNzIxNjMx.8eJsVi_PscFKFuq0CIkIKDcV8FMsmDOJ3spO8Tatybcg.fL5UGyqJBNdPl3RgO1Hvq9OtggTeH6audD0DwP2NR-Qg.JPEG.club246%2F20121021_164053.jpg&type=a340"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:31.5203696, lng:74.35874729999999},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:auto;width:400px;"><h1>파키스탄-라호르</h1>파키스탄 중동부, 펀자브 주의 주도. 라비 강 좌안에 있음. 인구 295만 3000명. 교통 · 상거래의 중심지이며 큰 철도공작창이 있음. 철강 · 고무 · 섬유 · 신발 및 금 · 은목걸이와 장신구를 생산함. 거대한 병영이 있음.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://search.pstatic.net/common/?src=http%3A%2F%2Fcafefiles.naver.net%2FMjAxOTA0MDVfMTA0%2FMDAxNTU0NDYyOTQ0MDQ1.bIs0TrE5qVzzU-1JiFofqZQgjJWj0hPMd7NgqMjW6sgg.qyHl9MNOJQDHQ8_BYkAhwz8g0Rg4V7xHIudvL2fPRjQg.JPEG.operwhen%2FexternalFile.JPG&type=a340"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:31.45036619999999, lng:73.13496049999999},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:auto;width:400px;"><h1>파키스탄-파이살라바드</h1>파키스탄 펀자브주의 도시. 이슬라마바드 & 라왈핀디 광역권에서 남쪽으로 170km, 물탄에서 동북쪽으로 160km, 라호르에서 서쪽으로 100km 떨어진 체납 강과 라비 강 사이의 평원에 위치한다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://t1.daumcdn.net/cfile/blog/99CD81495E04985E10"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:30.157458, lng:71.5249154},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:auto;width:400px;"><h1>파키스탄-물탄</h1>파키스탄 동부 라홀의 서남쪽 320km. 인더스 강 지류 치에나브 강의 좌안에 있는 도시. 툴람바(Tulamba) 유적의 발굴조사로 알렉산더 대왕 원정 이전의 B.C. 4세기부터 기원 16세기까지 연속한 문화층이 명백하게 되었다. 7세기에 현장이 방문한 무라삼부노국(茂羅三部盧國)을 이에 해당시키는 설이 있다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://search.pstatic.net/common/?src=http%3A%2F%2Fblogfiles.naver.net%2FMjAyMjAxMDdfMTE0%2FMDAxNjQxNTAzOTgxODE0.CSxP0V_q-RIQLSA70N6waeczhGTw4uX5I7khSgHTy7Ig.UvsdUQuoTydNY8mm6mzY-8wvn4WgUwnsaRCAewXyGcAg.JPEG.freshgang%2FIMG_2643.JPG&type=a340"  width="400px" height="auto"></a></div></div>',        },
        {
            coords:{lat:25.3959687, lng:68.357776},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:auto;width:400px;"><h1>파키스탄-하이데라바드</h1>인더스강(江) 동안에 위치하며, 하구에서 약 200km 떨어진 거리에 있다. 1768년 굴람 샤칼호라에 의해 건설되어 1843년 영국에 점거되었다. 지방의 농산물 집산지이며, 비단·금은자수(金銀刺繡)·도자기 등의 전통공업도 영위된다. 근래에는 방직·피혁·유리·시멘트 등 공업도 일어나고 있다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://search.pstatic.net/common/?src=http%3A%2F%2Fblogfiles.naver.net%2FMjAyMTAzMDVfMjYw%2FMDAxNjE0ODk5MDAyMjY4.AJPxVnMNRumD_GrCgK3g4hX598yEtoXc0hb470mC48og.M9NGgN7SNIpw6fKr-MPcaRlXWSsA93Baklv9atWZ1Kkg.JPEG.findmybucketlist%2F3424695_ho_00.jpg&type=a340"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:24.8607343, lng:67.0011364},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:auto;width:400px;"><h1>파키스탄-카라치</h1>파키스탄 남부 신드주의 주도. 아라비아해(海)에 면한 파키스탄 최대의 도시이다. 인더스강(江)의 분류(分流) 라야리·말리르 두 강으로 둘러싸인 삼각주에 건설된 항만도시이다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://dbscthumb-phinf.pstatic.net/2765_000_45/20181009200647172_KJ2HUTM09.jpg/48144.jpg?type=m250&wm=N"  width="400px" height="auto"></a></div></div>',
        },
        // 파푸아뉴기니
        {
            coords:{lat:-9.443800399999999, lng:147.1802671},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:auto;width:400px;"><h1>파푸아뉴기니-포트모르즈비</h1>파푸아뉴기니의 수도. 뉴기니 섬 남동 해안 파푸아 만(灣) 연안에 위치하는 양항(良港)이다. 1873년 이 곳을 발견한 J. 모르즈비가 자신의 이름을 붙여 개척의 기지로 삼았다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://search.pstatic.net/common/?src=http%3A%2F%2Fblogfiles.naver.net%2F20121022_262%2Fchen28218_1350876905268NPHb3_JPEG%2F3088888924_0645eb19aa_o.jpg&type=a340"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:-9.078195899999999, lng:143.2099707},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:auto;width:400px;"><h1>파푸아뉴기니-다루</h1>파푸아뉴기니 남부, 웨스턴 주의 주도. 인구 7100명. 토레스 해협쪽으로 출어하는 진주잡이배의 출입이 잦음.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://upload.wikimedia.org/wikipedia/commons/thumb/6/68/Daru-island-whirlwind-cropped-enhanced.png/220px-Daru-island-whirlwind-cropped-enhanced.png"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:-6.7155252, lng:146.999905},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:auto;width:400px;"><h1>파푸아뉴기니-라에</h1>라에는 1920년대에서 1930년대 사이 금광의 발견과 함께 탄생하였다. 파푸아 뉴기니의 많은 도시들처럼 활주로 주변에 솟아났으며, 라에에 도착한 화물은 다시 항공로를 통해 와우의 금광 지역으로 이동되었다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://search.pstatic.net/common/?src=http%3A%2F%2Fblogfiles.naver.net%2F20150101_289%2Fjhson9_1420086893654ri2eR_JPEG%2FDSC04448.JPG&type=sc960_832"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:-5.8581876, lng:144.2429343},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:auto;width:400px;"><h1>파푸아뉴기니-마운트하겐</h1>파푸아뉴기니 중부, 웨스턴하일랜즈 주의 주도. 라에 서북서쪽, 중앙고원 하겐산 기슭, 라에에서 라이아감으로 가는 도로연변에 위치. 인구 1만 7000명. 커피산지로 고로카와 함께 중앙고원의 중심지.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://search.pstatic.net/common/?src=http%3A%2F%2Fblogfiles.naver.net%2FMjAyMTA1MTdfMTI5%2FMDAxNjIxMjI5NzQxOTg1.gJ2dZopOu1azDT0OAhP90NyXOe2FwVKUWBEGE2_o1uYg.g8tjpmbiB454fQj5B28JUPUc7yS-KfMPC3vWX3C3apIg.JPEG.sptokorea%2FDSCF6604.jpg&type=a340"  width="400px" height="auto"></a></div></div>',
        }, 
		{
            coords:{lat:-3.5800229, lng:143.6583166},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:auto;width:400px;"><h1>파푸아뉴기니-웨와크</h1>파푸아뉴기니 북부, 동세피크 주의 주도이며 항만 도시. 뉴기니 섬 중북부, 비스마르크 해에 면함. 인구 2만 9000명. 제2차 세계대전 초기 일본군 기지로 이용돼 폭격을 심하게 받았음.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://search.pstatic.net/common/?src=http%3A%2F%2Fblogfiles.naver.net%2Fimages%2F119%2F160%2F451014%2Fh030715029752_45051554.jpg&type=a340"  width="400px" height="auto"></a></div></div>',
        // 팔라우
		},
        {
            coords:{lat:7.514979999999999, lng:134.58252},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:auto;width:400px;"><h1>팔라우-팔라우</h1>“신들의 바다 정원”이라 불리는 남태평양의 청정 휴양지이자 다이빙의 천국<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://search.pstatic.net/common/?src=http%3A%2F%2Fblogfiles.naver.net%2FMjAyMTAzMThfMTgy%2FMDAxNjE2MDU2MDQyNDIw.gkX1gUDE2RcnnWs3D6boeCrFovBnH8BMHuM2bQMqYAog.4StKmXSPfu-F-yMr5hcb0_uxymLPUGiZyephC_R3ZPcg.PNG.bnlee42%2Fimage.png&type=a340"  width="400px" height="auto"></a></div></div>',
        // 페루
        },
        {
            coords:{lat:-8.106042799999999, lng:-79.0329727},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:auto;width:400px;"><h1>페루-트루히요</h1>남아메리카 페루 서북쪽에 있는 상업 도시. 사탕수수 재배 중심지이며 제당업, 식품 가공업 따위가 발달하였다. 부근에 잉카 문화의 유적이 있다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://search.pstatic.net/common/?src=http%3A%2F%2Fblogfiles.naver.net%2F20101105_107%2Fjonandrachel_1288962420157O0Cf9_JPEG%2F_DSC0189.jpg&type=sc960_832"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:-12.0463731, lng:-77.042754},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:auto;width:400px;"><h1>페루-리마</h1>페루의 수도이자 대부분의 남미 여행자들이 출발점으로 삼는 해안가 절벽 위의 도시<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://search.pstatic.net/common?src=https://dbscthumb-phinf.pstatic.net/5885_000_10/20201112005529564_71VAIY5H6.jpg/fb279_3_i1.jpg?type=w540_fst&type=w800_travelsearch"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:-13.53195, lng:-71.96746259999999},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:auto;width:400px;"><h1>페루-쿠스코</h1>과거 잉카 제국의 수도. 세상의 중심이라 생각하여 ‘배꼽’이란 뜻의 꾸스꼬로 불리는 도시<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://search.pstatic.net/common/?src=http%3A%2F%2Fblogfiles.naver.net%2FMjAyMTA5MDFfMTUx%2FMDAxNjMwNDY2ODc3Mzcz.afoHHDbpugsDCd7KLvfVGWHdoPLRYYAvWKoSxwlxX24g.lRAqCn81SYpYdEwYnYf0EaQzwJTIWk2CNJThP3ncQEwg.JPEG.sbnee%2FIMG_3613.JPG&type=a340"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:-16.4090474, lng:-71.53745099999999},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:auto;width:400px;"><h1>페루-아레키파</h1>교통 요충지로 당시 잉카 제국 최고의 부를 누렸던 페루 제2의 도시<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://search.pstatic.net/common?src=https://dbscthumb-phinf.pstatic.net/5885_000_10/20201112010106493_WYF33O1BG.jpg/fb281_3_i1.jpg?type=w540_fst&type=w800_travelsearch"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:-14.8358687, lng:-74.9327583},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:auto;width:400px;"><h1>페루-나스카</h1>사막에 펼쳐진 거대 그림들, 미스터리 지상라인을 품은 나스카br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://search.pstatic.net/common?src=https://dbscthumb-phinf.pstatic.net/5885_000_10/20201112010514731_WJ4YAN0EJ.jpg/fb283_3_i1.jpg?type=w540_fst&type=w800_travelsearch"  width="400px" height="auto"></a></div></div>',
        },
        // 포르투갈
        {
            coords:{lat:41.5454486, lng:-8.426506999999999},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:auto;width:400px;"><h1>포르투갈-브라가</h1>브라가는 포르투갈 북부에 있는 도시로 브라가주의 주도이다. 미뉴 지방의 한가운데에 있는 브라가는 북쪽에는 카바두강이 흐르고 동쪽, 남쪽에 피쿠스 산맥과 카르발류스 산맥이 있다. 브라가는 역사가 오랜 도시로 11세기에 건축이 시작된 브라가 성당이 있고 유네스코 세계유산으로 등재된 봉제주스두몬트 성소, 사메이루 성소 등이 있다. 국제나노기술연구소가 시내에 있다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://dthumb-phinf.pstatic.net/?src=%22https%3A%2F%2Fdbscthumb-phinf.pstatic.net%2F5854_000_2%2F20201005162608260_S43ULY0R7.jpg%2FBraga_01.jpg%3Ftype%3Dw690_fst%26wm%3DN%22&twidth=690&theight=460&opts=17"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:41.1579438, lng:-8.629105299999999},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:auto;width:400px;"><h1>포르투갈-포르토</h1>세계적으로 유명한 포트 와인의 도시이자, 도우루강 하구 언덕에 펼쳐진 아름다운 도시<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://search.pstatic.net/common?src=https://dbscthumb-phinf.pstatic.net/5885_000_6/20200917113824827_7OGJBTXUP.jpg/fb127_3_i1.jpg?type=w540_fst&type=w800_travelsearch"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:41.3010351, lng:-7.7422354},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:auto;width:400px;"><h1>포르투갈-빌라헤알</h1>빌라헤알은 포르투갈 노르트 지방에 위치한 도시다. ‘빌라 헤알’은 ‘왕의 도시’라는 뜻으로, 중세 시대에는 수도 리스본에 이어 가장 많은 왕실 일가가 살던 도시였다. 두 개의 산지로 둘러싸인 지리적 위치 때문에 극과 극의 기후를 보인다. 무어인들의 이베리아 침략 당시 인구가 급감하기도 했다. 모터 스포츠의 도시로도 유명하다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://search.pstatic.net/common/?src=https%3A%2F%2Fdbscthumb-phinf.pstatic.net%2F5854_000_2%2F20200317222706568_Q7UGNHGHA.jpg%2FVilaReal_03.jpg%3Ftype%3Dm4500_4500_fst_n&type=sc960_832"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:40.6405055, lng:-8.6537539},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:auto;width:400px;"><h1>포르투갈-아베이루</h1>아베이루는 포르투갈 중앙 지방에 있는 도시로서 아베이루주의 주도이다. 대서양 연안에 있는 아베이루는 공업도시이면서 중요한 항구도시이다. 포르투갈의 베네치아로도 알려져 있는 아베이루는 유서 깊은 고적이 많고 운하에 곤돌라가 운행되는 등 보고 즐길 거리가 풍부해 관광도시로 인기 있다. 15세기에 지어진 예수수도원은 성조아나공주가 묻힌 아베이루의 명소이다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://dthumb-phinf.pstatic.net/?src=%22https%3A%2F%2Fdbscthumb-phinf.pstatic.net%2F5854_000_2%2F20201005162608130_53HV8ULC8.jpg%2FAveiro_01.jpg%3Ftype%3Dw690_fst%26wm%3DN%22&twidth=690&theight=388&opts=17"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:40.2033145, lng:-8.4102573},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:auto;width:400px;"><h1>포르투갈-코임브라</h1>코임브라는 포르투갈 중부에 있는 도시로 코임브라주의 주도이다. 몬데구강이 코임브라 시내를 지난다. 코임브라는 1255년까지 포르투갈의 수도였다. 유럽의 오래된 대학 중 하나인 코임브라대학이 있다. 대학 안과 부근에 유서 깊은 건축물, 박물관이 많고 18세기에 만들어진 코임브라대학식물원이 있다. 몬데구강 서쪽에 테마파크와 산타클라라수도원이 있다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://dthumb-phinf.pstatic.net/?src=%22https%3A%2F%2Fdbscthumb-phinf.pstatic.net%2F5854_000_2%2F20201005162608131_7D7T3X9DZ.jpg%2FCoimbra_01.jpg%3Ftype%3Dw690_fst%26wm%3DN%22&twidth=690&theight=460&opts=17"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:38.7222524, lng:-9.1393366},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:auto;width:400px;"><h1>포르투갈-리스본</h1>리스본은 포르투갈의 수도이자 가장 큰 도시로 세계에서 가장 오래된 도시들 중 하나다. 이베리아반도의 대서양 쪽 끝자락이자 유럽 대륙의 최서단 지점에 위치하고 있다. 리스본은 역사적으로 중요한 교역 거점이었으며, 오늘날 금융, 상업, 미디어, 무역, 교육 및 관광 등의 분야에서 유럽 대륙의 중요한 경제 중심지 가운데 하나다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://dthumb-phinf.pstatic.net/?src=%22https%3A%2F%2Fdbscthumb-phinf.pstatic.net%2F5854_000_2%2F20200317201353474_WK8OKHKLH.jpg%2FLisbon_01.jpg%3Ftype%3Dw690_fst_n%26wm%3DY%22&twidth=690&theight=460&opts=17"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:38.0153039, lng:-7.8627308},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:auto;width:400px;"><h1>포르투갈-베자</h1>베자는 포르투갈 알렌테주 지방에 있는 도시다. 해발 277m의 언덕 위에 위치한 전략적 요충지로 고대부터 로마 시대에 이르기까지 중요한 지역이었다. 과거 서고트족, 이슬람 세력 등에 의해 정복되었으며 기독교 국가와의 사이에 탈환과 재점령이 오랜 기간 반복되었다. 오늘날 포르투갈의 공군기지가 이곳에 있다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://dthumb-phinf.pstatic.net/?src=%22https%3A%2F%2Fdbscthumb-phinf.pstatic.net%2F5854_000_2%2F20200317174150059_159JY6L6Y.JPG%2FBeja_01.JPG%3Ftype%3Dw690_fst_n%26wm%3DY%22&twidth=690&theight=288&opts=17"  width="400px" height="auto"></a></div></div>',
        },
        // 폴란드
        {
            coords:{lat:53.13248859999999, lng:23.1688403},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:auto;width:400px;"><h1>폴란드-비아위스토크</h1>비아위스토크는 폴란드 포들라스키에주의 주도이다. 폴란드 북동부 행정 · 경제 · 문화예술의 중심지로 섬유 · 식품가공업이 발달했다. 중세 이후 폴란드 · 프로이센 · 러시아 · 구소련에 차례로 점유되었다가 1945년 제2차 세계대전이 끝난 후 다시 폴란드 영토가 되었다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://search.pstatic.net/common/?src=https%3A%2F%2Fdbscthumb-phinf.pstatic.net%2F5854_000_1%2F20200318174844742_R7UV0GNOC.JPG%2FBialystok_10.JPG%3Ftype%3Dm4500_4500_fst&type=a340"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:51.2464536, lng:22.5684463},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:auto;width:400px;"><h1>폴란드-루블린</h1>폴란드 동부에 있는 공업 도시. 기계ㆍ화학ㆍ자동차 공업이 발달해 있으며, 대학ㆍ박물관ㆍ극장 따위가 있는 문화 도시이기도 하다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://dthumb-phinf.pstatic.net/?src=%22https%3A%2F%2Fdbscthumb-phinf.pstatic.net%2F5854_000_1%2F20200318160626978_9E1BUQ12O.jpg%2FLublin_01.jpg%3Ftype%3Dw690_fst%26wm%3DN%22&twidth=690&theight=473&opts=17"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:50.06465009999999, lng:19.9449799},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:auto;width:400px;"><h1>폴란드-크라쿠프</h1>유럽에서 가장 아름다운 도시 중 하나. 구시가지는 유네스코 세계문화유산으로 지정되어 있다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://search.pstatic.net/common?src=https://dbscthumb-phinf.pstatic.net/5885_000_10/20201111183101631_G2SU9XY9L.jpg/fb250_3_i2.jpg?type=w540_fst&type=w800_travelsearch"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:50.8118195, lng:19.1203094},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:auto;width:400px;"><h1>폴란드-쳉스토호바</h1>쳉스토호바는 폴란드 남부 실롱스키에주의 도시로 바르타강 유역에 위치한다. 폴란드, 프로이센, 러시아, 독일의 지배를 거쳐 제2차 세계대전이 끝난 후 다시 폴란드 영토가 되었다. 야스나 구라 수도원에 소장된 ‘검은 성모 마리아’ 성화로 특히 유명하다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://dthumb-phinf.pstatic.net/?src=%22https%3A%2F%2Fdbscthumb-phinf.pstatic.net%2F5854_000_1%2F20200318173510679_XTCGO5ILX.JPG%2FCzestochowa_01.JPG%3Ftype%3Dw690_fst%26wm%3DN%22&twidth=690&theight=518&opts=17"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:51.7592485, lng:19.4559833},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:auto;width:400px;"><h1>폴란드-우치</h1>우치는 폴란드 중부 우츠키에주의 산업도시로 폴란드에서 세 번째로 큰 도시이다. 16세기까지만 해도 인구 800명 미만의 작은 도시였으나 19세기 들어 섬유산업의 중심지로 도약하면서 급속히 대도시로 발전했다. 한때 ‘폴란드의 맨체스터’로 불렸다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://dthumb-phinf.pstatic.net/?src=%22https%3A%2F%2Fdbscthumb-phinf.pstatic.net%2F5854_000_1%2F20200318155614058_LM6SLSJEY.jpg%2FLodz_01.jpg%3Ftype%3Dw690_fst%26wm%3DN%22&twidth=351&theight=530&opts=17"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:52.2296756, lng:21.0122287},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:auto;width:400px;"><h1>폴란드-바르샤바</h1>쇼팽의 음악이 흐르는 도시<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://search.pstatic.net/common?src=https://dbscthumb-phinf.pstatic.net/5885_000_5/20200910145859678_MO1Y65OL3.jpg/fb129_3_i1.jpg?type=w540_fst&type=w800_travelsearch"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:51.1078852, lng:17.0385376},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:auto;width:400px;"><h1>폴란드-브로츠와프</h1>독특한 유럽 각국의 문화와 전통이 어우러진 복합 문화 도시<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://search.pstatic.net/common?src=https://dbscthumb-phinf.pstatic.net/5885_000_10/20201111184532058_511YJ93NR.jpg/fb251_3_i1.jpg?type=w540_fst&type=w800_travelsearch"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:52.406374, lng:16.9251681},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:auto;width:400px;"><h1>폴란드-포즈난</h1>옛 중세 시대 때부터 상업 도시로 알려졌고 학문, 기술, 상공업의 중심지<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://search.pstatic.net/common?src=https://dbscthumb-phinf.pstatic.net/5885_000_10/20201111185957316_IETTV4T52.jpg/fb254_3_i1.jpg?type=w540_fst&type=w800_travelsearch"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:53.4285438, lng:14.5528116},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:auto;width:400px;"><h1>폴란드-슈체친</h1>슈체친은 폴란드 자호드니오포모르스키에주의 주도다. 폴란드 북서부 발트해 연안의 도시로 독일 국경과 인접해 있다. 역사적으로 폴란드 왕국, 프로이센 왕국, 신성로마제국, 독일제국의 지배를 받아왔다. 2차 세계대전 후 폴란드 영토가 되었다. 무역항이자 조선업 · 기계공업 등이 발달한 산업도시다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://dbscthumb-phinf.pstatic.net/5854_000_1/20200310163606310_YOU80ZXJ8.jpg/Lille_02.jpg?type=w530_fst_n&wm=Y"  width="400px" height="auto"></a></div></div>',
        },
        // 프랑스
        {
            coords:{lat:50.62925, lng:3.057256},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:auto;width:400px;"><h1>프랑스-릴</h1>릴은 프랑스 북부 오드프랑스지방 노르주의 주도로 파리에서 219km 떨어져 있으며, 벨기에와는 14km 거리에 있는 국경 도시다. 이 도시에서는 1983년 세계 최초의 자동 고속철도 지하망인 VAL이 개통되었다. 릴은 온화한 해양성 기후를 가지고 있어 여름은 그리 덥지 않고, 겨울은 평균적으로 영상의 기온을 유지한다. 이 도시는 2004년에 이탈리아 제노바와 함께 ‘유럽 문화수도’로 선정되었다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://search.pstatic.net/common/?src=http%3A%2F%2Fblogfiles.naver.net%2FMjAyMjAyMDNfOTYg%2FMDAxNjQzODkwODA4NzA3.1SFtkES58lovDrT4VjM5hl5y9uv3dcJGMC2YsCIpqWwg.1KwcX1F5-erERoDZ723iXyAoyPDOUHg_jt3J9Y1vzTog.JPEG.pakele1250%2FIMG_2592_Original.JPG&type=a340"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:48.5734053, lng:7.752111299999999},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:auto;width:400px;"><h1>프랑스-스트라스부르</h1>스트라스부르는 프랑스와 독일의 경계에 위치해 있다. 라인강을 건너면 독일 도시인 케흘이 나온다. 2000년 이상의 역사를 가진 이 도시는 음식, 언어, 문화 등에서 독일과 많은 것을 공유하고 있다. 많은 비유럽 국제기구들의 소재지로, 파리 다음으로 국제회의와 심포지엄이 많이 개최되는 프랑스 제2의 도시다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://dthumb-phinf.pstatic.net/?src=%22https%3A%2F%2Fdbscthumb-phinf.pstatic.net%2F5854_000_1%2F20200310175519836_1PKV989RL.jpg%2FStrasbourg_01.jpg%3Ftype%3Dw690_fst_n%26wm%3DY%22&twidth=690&theight=451&opts=17"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:48.856614, lng:2.3522219},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:auto;width:400px;"><h1>프랑스-파리</h1>프랑스의 수도이자 가장 인구가 많은 도시로 프랑스 북부 일드프랑스 지방의 중앙에 있다. 센강 중류에 있으며, 행정 구역은 1~20구로 나뉘어 있다. 센강을 기준으로 우안과 좌안으로 나뉜다. 17세기 이후 파리는 유럽의 금융, 외교, 상업, 패션, 과학, 예술 중심지다. 생활비가 싱가포르에 이어 세계에서 두 번째로 비싼 도시다. 샤를르 드골 공항과 오를리 공항이 있고, 유럽의 주요 철도, 고속도로, 항공 교통의 허브이며, 루브르 등 관광명소가 많아 관광의 중심지이기도 하다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://search.pstatic.net/common/?src=http%3A%2F%2Fblogfiles.naver.net%2FMjAyMjA4MjZfMjAx%2FMDAxNjYxNDY3OTgzMjA2.qgQlgQZEvQ2LisBbVaDMcEJ9YZ37c9wRLHd5SUUP5Dkg.SqLDiIlYT7CubjzV-GDpNJKhl7HoIXnZXcEZ38d-pBcg.JPEG.juja0150%2F20220714_121425.jpg&type=a340"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:47.218371, lng:-1.553621},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:auto;width:400px;"><h1>프랑스-낭트</h1>낭트는 프랑스 북서부에 위치하며 파리에서 남서쪽으로 342km 떨어져 있다. 페이드라루아르지방 루아르아틀랑티크주의 주도(州都)로 프랑스에서 여섯 번째로 큰 도시다. 낭트는 대서양에 근접해 있어 해양성 기후로 겨울은 따뜻하고 비가 많이 오며, 여름은 시원하다. 낭트에는 218만m2에 달하는 100개의 공원과 정원, 광장이 있다. 연간 200만 명의 방문객이 찾아오는 프랑스에서 일곱 번째로 큰 관광 도시이기도 하다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://dthumb-phinf.pstatic.net/?src=%22https%3A%2F%2Fdbscthumb-phinf.pstatic.net%2F5854_000_1%2F20200310170935340_UGN2KXUIH.jpg%2FNantes_01.jpg%3Ftype%3Dw690_fst_n%26wm%3DY%22&twidth=690&theight=518&opts=17"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:43.604652, lng:1.444209},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:auto;width:400px;"><h1>프랑스-툴루즈</h1>툴루즈는 파리·마르세유·리옹에 다음 가는 프랑스 제4의 도시이다. 대서양 연안과 지중해를 연결하는 지점에 있으며, 가론 운하와 1996년 유네스코 문화유산으로 지정된 미디 운하의 분기점에 자리 잡고 있다. 툴루즈는 프랑스 남부 최대의 교통·산업·문화의 중심지로 항공우주산업이 특히 발달해 있다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://dthumb-phinf.pstatic.net/?src=%22https%3A%2F%2Fdbscthumb-phinf.pstatic.net%2F5854_000_1%2F20200310180732728_PT0LLG20F.jpg%2FToulouse_01.jpg%3Ftype%3Dw690_fst_n%26wm%3DY%22&twidth=690&theight=463&opts=17"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:43.610769, lng:3.876716},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:auto;width:400px;"><h1>프랑스-몽펠리에</h1>몽펠리에 ( 프랑스어: Montpellier , 오크어: Montpelhièr )는 2017년부터 프랑스에서 7번째로 큰 도시로 프랑스 남부 옥시타니 레지옹과 에호 주의 중심 도시이다. 2018년 1월 1일 현재 거주민은 282,143 명이며(INSEE,) 인구의 50%가 34세 이하인 젊은 도시이다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://dthumb-phinf.pstatic.net/?src=%22https%3A%2F%2Fdbscthumb-phinf.pstatic.net%2F5854_000_1%2F20200310170310810_3R4O2F5G6.jpg%2FMontpellier_01.jpg%3Ftype%3Dw690_fst_n%26wm%3DY%22&twidth=690&theight=319&opts=17"  width="400px" height="auto"></a></div></div>',        },
        {
            coords:{lat:43.296482, lng:5.36978},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:auto;width:400px;"><h1>프랑스-마르세유</h1>프랑스에서 파리, 리옹의 뒤를 잇는 3번째로 큰 도시일 뿐 아니라 유럽, 중동과 아프리카를 비롯한 아시아와 해상으로 문화 연결을 만들어왔던 역사적으로 중요한 도시.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://search.pstatic.net/common/?src=http%3A%2F%2Fblogfiles.naver.net%2FMjAyMTExMThfNzAg%2FMDAxNjM3MjE1NDI2MzA0.aWxpwYUvn7R4tttjfy_AGjAkxTxv3ir6Byk8JoozNG0g.IEurC_KL-wR7a_viUrp4FPjY-CnIlk9NOarLQdnEn0og.JPEG.haneuimom2003%2F%25B4%25D9%25BF%25EE%25B7%25CE%25B5%25E5_%252811%2529.jpg&type=a340"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:45.764043, lng:4.835659},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:auto;width:400px;"><h1>프랑스-리옹</h1>프랑스 남동부 오베르뉴론알프 레지옹의 중심 도시. 파리, 마르세유에 이은 프랑스 제3의 도시이다. 마르세유와 제2의 자리를 놓고 자존심 싸움을 하기도 하는데, 구 시가지나 지리적, 역사적 의미에 중점을 두면 마르세유가 압도적이고, 프랑스적인 분위기에 중점을 두면 리옹이 압도적이다. 도시 이름의 유래는 갈리아족의 신 루구스(Lugus)에서 유래된 라틴어 지명 루그두눔(Lugdunum, 루구스의 언덕/요새)이다. 뒷 부분의 자음이 점점 약화되면서 리옹이 된 듯하다. 마스코트는 사자가 걷고 있는 옆 모습이며, 캐치프레이즈는 ONLY-LYON이다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://search.pstatic.net/common/?src=http%3A%2F%2Fblogfiles.naver.net%2FMjAyMjA5MDJfNzcg%2FMDAxNjYyMTE1MDk4NDE3.x6yughux1Gk_Ucd5TkFuKGv9eMO-7tlj2C-3tRMyNP0g.L5ASvxpvUfa6rzMiCCLF-cenQUnh2UxiBxUpWID1v5kg.JPEG.takkuni%2FIMG_5487.JPG&type=a340"  width="400px" height="auto"></a></div></div>',
        },
        // 피지
        {
            coords:{lat:-17.713371, lng:178.065032},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:auto;width:400px;"><h1>피지-피지</h1>1643년 네덜란드인 탐험가 타스만(Abel Janszoon Tasman)에 의하여 발견된 피지는 유럽인의 정착이 이루어진 후에도 19세기 중엽 여러 추장들의 패권 다툼으로 내전이 벌어졌다. 당시 이 곳에 와 있던 미국인들은 중립을 지켰지만 생명과 재산을 잃게 되자  피지왕(王)으로 자처하고 있던 자콘바우에게 4만 5000달러의 배상금을 요구하였다. 지불능력이 없었던 자콘바우는 영국에서 돈을 빌리는 대가로 20만 에이커의 토지를 할양하였으며 이것을 계기로 1874년 영국은 섬 전체를 식민지로 삼았다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://search.pstatic.net/common/?src=http%3A%2F%2Fimgnews.naver.net%2Fimage%2F5192%2F2020%2F09%2F09%2F0000057932_002_20200909075820813.jpg&type=a340"  width="400px" height="auto"></a></div></div>',
        },
        // 핀란드
        {
            coords:{lat:65.0120888, lng:25.4650773},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:auto;width:400px;"><h1>핀란드-오울루</h1>오울루는 핀란드 북부의 북(北)포흐얀마(Pohjois-Pohjanmaa)주에 속한 도시다. 핀란드 북부에서 가장 인구가 많은 도시로, 핀란드 전체적으론 5위다. 오울루는 주민들이 지역사회 차원에서 실시되는 NFC태그나 유비쿼터스 스크린 같은 신기술 실험에 적극적으로 참여해서 유럽의 살아있는 실험실 중 하나로 불린다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://dthumb-phinf.pstatic.net/?src=%22https%3A%2F%2Fdbscthumb-phinf.pstatic.net%2F5854_000_1%2F20200314002004242_1W3SBERDI.png%2FOulu_02.png%3Ftype%3Dw690_fst%26wm%3DN%22&twidth=690&theight=461&opts=17"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:62.89796999999999, lng:27.6781725},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:auto;width:400px;"><h1>핀란드-쿠오피오</h1>요약 쿠오피오는 동부 핀란드의 포효이스 사보(Pohjois-Savo)주의 주도로 핀란드에서 9번째로 큰 도시다. 면적은 4,326km2에 이르는데, 이중 719km2는 물이고 절반은 숲이다. 도시 지역은 km2당 1,618명 살아 핀란드에서 인구밀도가 두 번째로 높다. 쿠오피오는 1969년 이래 주변의 자치체들을 흡수하며 성장했다. 2013년초 닐시에(Nilsiä)와의 통합으로 쿠오피오 인구는 10만명을 넘어섰다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://search.pstatic.net/common/?src=http%3A%2F%2Fblogfiles.naver.net%2FMjAyMTAyMTFfMjg5%2FMDAxNjEzMDE2ODM5NjMy.l4fb9PHYrHelv4JkU6cQak_MgIy2OUu22WkdxyyWAKMg.LlsWCJ_05hPZldFYacmGWr6F1HbCYkY-DMuHihwH7dMg.JPEG.barndining_%2FKakaoTalk_20210210_180459460_03.jpg&type=a340"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:61.4977524, lng:23.7609535},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:auto;width:400px;"><h1>핀란드-탐페레</h1>핀란드 산업과 근현대사의 중심이자 제3 도시<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://search.pstatic.net/sunny/?src=https%3A%2F%2Fwww.hotelscombined.co.kr%2Frimg%2Fdimg%2F32%2Fa6%2F4bfae593-city-29758-1697da8c43f.jpg%3Fwidth%3D1200%26height%3D630%26xhint%3D1383%26yhint%3D519%26crop%3Dtrue&type=l340_165"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:60.4518126, lng:22.2666303},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:auto;width:400px;"><h1>핀란드-투르쿠</h1>핀란드의 500년간 옛 수도이자 군도 지역으로 가는 교통의 중심지<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://search.pstatic.net/common/?src=http%3A%2F%2Fblogfiles.naver.net%2FMjAxODAzMjNfMTAz%2FMDAxNTIxNzY2NDIxMjI0.okijp7H-fnwUkkLTge8x7rb1jSl_r2oFiDRjz2Gyenwg.A0x1mcqxFkaM4fEu_r1A032LSPzmK5ddhpsyrV7_hZAg.JPEG.space4value%2F36171623921_8581dfc93c_z.jpg&type=a340"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:60.16985569999999, lng:24.938379},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:auto;width:400px;"><h1>핀란드-바기오</h1>‘발트 해의 아가씨’답게 단아하고 깨끗한 이미지의 핀란드의 수도<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://search.pstatic.net/common?src=https://dbscthumb-phinf.pstatic.net/5885_000_5/20200910135712697_PBFOJ72VD.jpg/fb117_3_i1.jpg?type=w540_fst&type=w800_travelsearch"  width="400px" height="auto"></a></div></div>',
        },
        // 필리핀
        {
            coords:{lat:16.4023332, lng:120.5960071},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:auto;width:400px;"><h1>필리핀-바기오</h1>루손섬 북부의 상업과 교육의 중심지이자 해발 1470m에 위치한 필리핀의 여름 수도<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://search.pstatic.net/common/?src=http%3A%2F%2Fblogfiles.naver.net%2FMjAxOTEwMTVfMTIg%2FMDAxNTcxMTExMzUzNzAw.JAgZ5awifAWp-02BYe0BR5lPSK1faF3IYrVNJrbU1-gg.GzF0FBwnyOVpQ-6v_nP0PGlQR0qe8MuaQPCV6UhMN6Ig.JPEG.yhsoo00%2FKakaoTalk_Photo_20191015_1227_58831.jpg&type=a340"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:14.5995124, lng:120.9842195},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:auto;width:400px;"><h1>필리핀-마닐라</h1>마닐라는 필리핀의 수도로 스페인 점령기의 문화가 남아 있으며 상업과 금융이 발달해 있다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://search.pstatic.net/common/?src=https%3A%2F%2Fdbscthumb-phinf.pstatic.net%2F2765_000_37%2F20181006040832933_B3F0QRGF6.jpg%2F1456442.jpg%3Ftype%3Dm4500_4500_fst&type=a340"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:10.3156992, lng:123.8854366},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:auto;width:400px;"><h1>필리핀-세부</h1>세부는 필리핀에서 두 번째로 큰 대도시이며 리조트가 잘 발달된 대표적 관광지 중 하나이다.br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://search.pstatic.net/common/?src=http%3A%2F%2Fblogfiles.naver.net%2FMjAyMTEyMjlfMjQx%2FMDAxNjQwNzU4NDkyNDYy.NQttxEsViDUp_YYQa3lAWn4BHSzA-HFja_9-bxApONEg.Jb5bGT0X_NIT13IA1CjIJY1CZ5UJDUZ96X13WtI32_0g.JPEG.walyd%2FIMG_4917.jpg&type=a340"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:7.190708, lng:125.455341},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:auto;width:400px;"><h1>필리핀-다바오</h1>필리핀에서 두번째로 큰 민다나오 섬의 주도<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://search.pstatic.net/common?src=https://dbscthumb-phinf.pstatic.net/5885_000_16/20211223141647630_2TUX47YEG.jpg/fb511_3_i1.jpg?type=w540_fst&type=w800_travelsearch"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:9.8349493, lng:118.7383615},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:auto;width:400px;"><h1>필리핀-팔라완</h1>개발의 손이 닿지 않은 에메랄드빛 바다와 거대한 석회암벽이 장관을 이루는 히든플레이스다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://search.pstatic.net/common/?src=http%3A%2F%2Fblogfiles.naver.net%2FMjAyMjA5MDJfMTg4%2FMDAxNjYyMDY5OTY4MDM0.zwmtW0rg26e4EA-Xeuu3cI-w7ht6zmrT5zDi-Amj7qIg._ny3gkJxhjqgz6OC9P4aZ8ra2GiPs6sOenB0UVV88Acg.JPEG.aa11bb88%2F6688993.jpg&type=a340"  width="400px" height="auto"></a></div></div>',
        },
        // 대한민국
        {
            coords:{lat:37.566535, lng:126.9779692},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:auto;width:400px;"><h1>대한민국-서울</h1>대한민국의 수도인 서울을 지방자치단체인 특별시로 부르는 명칭이다. 한반도 중앙에 있으며, 한강을 사이에 두고 남북으로 펼쳐져 있다. 북쪽 끝은 도봉구 도봉동, 동쪽 끝은 강동구 상일동, 남쪽 끝은 서초구 원지동, 서쪽 끝은 강서구 오곡동이다. 시청은 중구 을지로1가(태평로1가 31)에 있다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://search.pstatic.net/sunny/?src=https%3A%2F%2Fthumb2.gettyimageskorea.com%2Fimage_preview%2F700%2F201711%2FMBRF%2FMBRF17020404.jpg&type=a340"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:37.4562557, lng:126.7052062},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:auto;width:400px;"><h1>대한민국-인천</h1>동경 124°36~ 126°47, 북위 36°55~ 37°58에 있다. 동서거리 192.23km, 남북거리 117.60km에 달한다. 북쪽으로 개풍군·황해도 연백군, 동쪽으로 서울특별시·김포시·부천시·시흥시·안산시, 남쪽으로 충청남도 서산시에 접하고, 서쪽으로 서해에 면한다. 2014년 현재 가구수는 113만 6,280가구이며, 행정구역은 8구 2군 1읍 19면 129개동으로 이루어져 있다. 시청은 남동구 구월동에 있다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://search.pstatic.net/common/?src=http%3A%2F%2Fblogfiles.naver.net%2FMjAyMjA2MTJfMjcw%2FMDAxNjU1MDMwOTg3NzEy.6WMLZTn7w07yjn3-VcXVkgde-1TyTg_Tj0NcEbQ6Nysg.ntv7atvYjKz0XDf-xjLaM8OPRhhrmmat4HqI2A3J1QAg.JPEG.k_suyeon%2F20220515%25A3%25DF204825.jpg&type=a340"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:37.2635727, lng:127.0286009},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:auto;width:400px;"><h1>대한민국-수원</h1>경기도의 도청소재지로서 동쪽은 용인시, 서쪽은 안산시, 남쪽은 화성시, 북쪽은 의왕시에 접한다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://search.pstatic.net/common/?src=http%3A%2F%2Fblogfiles.naver.net%2FMjAyMjA2MTNfMjAw%2FMDAxNjU1MTE4NDcwODYy.q0O2l5tTQfhMeIhJUDGeY2XN1T3VlPy38HjL3E0fquMg.EGjJtJcUvKaOnLTC5fHbZUKvhaSNNmtPwFDQ_sSUb7sg.JPEG.natural8a%2F%253F%253F%253F%259D%25B4%253F%253F-%25EB%25B0%25B0%25EA%25B2%25BD.jpg&type=l340_165"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:36.3504119, lng:127.3845475},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:auto;width:400px;"><h1>대한민국-대전</h1>동경 127°14~127°33, 북위 36°10~36°29에 있다. 동쪽으로 충청북도 보은군·옥천군, 북쪽으로 충청북도 청주시, 세종특별자치시, 남쪽으로 충청남도 금산군, 서쪽으로 충청남도 논산시·공주시에 접한다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://search.pstatic.net/common/?src=http%3A%2F%2Fblogfiles.naver.net%2FMjAyMjA4MjFfMjY2%2FMDAxNjYxMDE2Nzg5NjQ4.2DCmfZ01dUSArCHD_ibOzAxySrR1Ae5Ruvmg8JqtHzIg.R_CrkY866osAbBibJnXBzSeP1CI6o_fFspgexGvPmZ8g.JPEG.jhchoe262%2F20220819_193305.jpg&type=ofullfill340_600_png"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:35.8242238, lng:127.1479532},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:auto;width:400px;"><h1>대한민국-전주</h1>동경 126°59′~ 127°14′, 북위 35°43′~ 35°53′에 있다. 전라북도 행정·교육·문화의 중심지이며 도청소재지이다. 서쪽 일부와 북쪽 일부가 김제시와 익산시에 접하고 전북 중앙부를 북동으로부터 남서로 뻗어있는 노령산맥의 지류인 기린봉, 고덕산, 남고산, 모악산 그리고 완산칠봉 등이 시가지의 동·남·서방에 둘러싸여 분지를 이루고 있다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://search.pstatic.net/common/?src=http%3A%2F%2Fblogfiles.naver.net%2FMjAyMjA4MjdfMTg1%2FMDAxNjYxNTYzNzU0NDU3.GWhyb-2iUbpRXG2c2WJgGnjBRRTgFMT5wYi-v2j4OBMg.3D6-7MCwYGAV4BESFv4BubZGvNkHBEYf3mMpYaFg0ogg.JPEG.1ayoung%2Foutput_730459121.jpg&type=a340"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:35.8714354, lng:128.601445},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:auto;width:400px;"><h1>대한민국-대구</h1>대구광역시는 대한민국 동남부 내륙에 있는 광역시이다. 동쪽으로 경상북도 경산시, 영천시, 서쪽으로 고령군, 성주군, 북쪽으로 청송군, 군위군 남쪽으로 경상남도 창녕군과 인접한다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://search.pstatic.net/common/?src=http%3A%2F%2Fblogfiles.naver.net%2FMjAyMjA3MTNfMjQw%2FMDAxNjU3Njg1ODE1ODc3.Ygysa76r2aqcoGJO9abm58Lng_yvRevR8HCBOZwsJe8g.dW-3sJmn2wYlapsJpsCrdDAyq91EdBMd4lHXlsP_Ukog.JPEG.eunche55%2F1657464881955.jpg&type=a340"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:35.1595454, lng:126.8526012},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:auto;width:400px;"><h1>대한민국-광주</h1>광주광역시는 대한민국의 남서부에 있는 광역시이다. 남동쪽으로 전라남도 화순군, 북동쪽으로 전라남도 담양군, 서쪽으로 전라남도 함평군, 서남쪽으로 전라남도 나주시, 북쪽으로 전라남도 장성군과 접한다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://dynamic-media-cdn.tripadvisor.com/media/photo-o/0c/c7/b4/bf/screenshot-2016-09-01.jpg?w=500&h=-1&s=1"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:35.1795543, lng:129.0756416},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:auto;width:400px;"><h1>대한민국-부산</h1>부산광역시는 대한민국 동남부 해안에 위치한 광역시이다. 대한민국의 제2의 도시이자 최대의 해양 물류 도시이며, 부산항을 중심으로 해상 무역과 물류 산업이 발달하였다. <br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://search.pstatic.net/common/?src=http%3A%2F%2Fblogfiles.naver.net%2FMjAyMjA3MTJfNTQg%2FMDAxNjU3NTUxNzI0NDky.8KYE_lC5D888wilA-DTdnezwOFIwg3ePfow7lOLZ-pAg.t4QQL6K53wTlJWmdpTVoCAkWOOfXFGpRWpiUWWN0T10g.JPEG.carmin31%2FDSC06644.jpg&type=a340"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:34.7603737, lng:127.6622221},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:auto;width:400px;"><h1>대한민국-여수</h1>여수시는 대한민국 전라남도 동남부 여수반도에 있는 시이다. 면적은 510.08km²이고, 해안선 길이는 879.03km이며, 365개의 부속 섬이 있다.<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://search.pstatic.net/common/?src=http%3A%2F%2Fblogfiles.naver.net%2FMjAyMjA4MjdfODAg%2FMDAxNjYxNTc5ODIxNjU4.Yk0H5ifHFiFhaPCEzAMA8g9Pw-yXY86-oSZaEjYgUAQg.xYgZ-yLathF7FZkTAf7c-ZszcGXHeSe1iW1bdGYKd4Yg.JPEG.oneday_222%2FIMG_0313.jpg&type=a340"  width="400px" height="auto"></a></div></div>',
        },
        {
            coords:{lat:37.518414, lng:126.906134},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:auto;width:400px;"><h1>대한민국-휴면교육센터</h1>국비무료교육, 국비지원교육, 취업연계 IT무료교육, S/W개발자 교육, 웹개발, 앱개발 등 IT전문교육, 임석재 선생님 잘생기고 착함<br><br><div style="width:400px;height:auto;"><a href="#"><img src="https://search.pstatic.net/common/?src=http%3A%2F%2Fblogfiles.naver.net%2FMjAyMDEwMjJfMjg4%2FMDAxNjAzMzQyNjA1NDIz.53B-0kemxMtj_RKwXPbv92N8TgRFEe5ZJalzrOvbtskg.J8_bOSJY6kNLsa-wMkQW3497im3PhsStP3zGILmXExIg.PNG.yedi0911%2F%25C3%25B5233.png&type=a340"  width="400px" height="auto"></a></div></div>',
        },
      ];
	
    var gmarkers = [];
    for(var i = 0; i < markers2.length; i++){		// 위에서 정의한 marker2 클러스터링 적용하기위해 gmarkers배열에 추기ㅏ
      gmarkers.push(addmarker(markers2[i]));
    }
       
    google.maps.event.addListener(map, 'click', function (event) {		// 지도 클릭시 이벤트, marker 생성 
    	if(arr1.length == 2){											// 만약 보조 polyline이 있다면 제거
  		  polyClear();    		  
  	  	} 
    	
  		latlnglatlng = JSON.stringify(event.latLng.toJSON());				// 클릭한 곳에 좌표값을 JSON으로 변환
     	coordsnation = JSON.parse(latlnglatlng);							// JSON 값을 다시 Object로 변환
      	console.log("클릭한 곳에 좌표값: " + Object.values(coordsnation));		// Object의 값을 체크
     	console.log("클릭한 곳에 좌표값의 타입: " + typeof(coordsnation.lat));		
		latlng2 = coordsnation.lat.toFixed(4);								// 클릭한 좌표값을 경도 위도로 나눈다(DB에 넣을것이기때문에 소수점 4자리까지만 설정)
		latlng3 = coordsnation.lng.toFixed(4);
			
     	latlng1.push(latlng2);												// 좌표값을 다시 배열로 합친다
     	latlng1.push(latlng3);	
     	
     	console.log("클릭한 곳에 위도: " + latlng1[0]);							// 좌표값이 제대로 들어갔는지 체크
     	console.log("클릭한 곳에 값이 제대로 배열에 들어갔는지 체크: " + latlng1);
     	
     	localStorage.setItem("좌표",latlng1);									// 좌표값을 다음페이지에서 쓸 수 있도록 localStorage값 설정
     	
     	
     	var poznamka = null;												// 일정에 들어갈 변수 설정
    	  while(poznamka == null || poznamka == ""){						// 일정에 null값이 없도록 설정
    		  poznamka = prompt("얼마나 머무르실 예정입니까?(숫자만)", 3);    		// 얼마나 머무를 것인지 설정, 차후 marker위에 label 값이 될 예정
    	  }
    	    	
    	  data.push(poznamka);												// 입력값 배열에 추가
    	  localStorage.setItem("note",data);								// 다음페이지에서 쓸수 있도록 localStorage 설정
    	  console.log("얼마나 머무를 예정: " + data);							// 잘들어갔는지 확인
    	
    	
    	  city = prompt("여기는 어디입니까?");									// 일정에 들어갈 위치 이름 값 입력
    	  while(city == null || city == ""){								// 일정에 null값이 업도록 설정
    		  city = prompt("여기는 어디입니까?");								// 여기가 어딘지 설정, 차후 marker의 정보창에 기입될 예정
    	  }
    	  var poznamka1 = new Array();										// 일정값 넣을 배열 설정
    	  poznamka1.push(city);												// 일정값 배열에 추가
    	  console.log("일정: " + poznamka1);									// 잘들어갔는지 확인
    	  
    	  date = prompt("여행하는 날짜?","2022-10-14");							// 일정에 들어갈 여행 날짜 설정
		  while(date == null || date == ""){								// 일정에 null값이 업도록 설정
			  date = prompt("여행하는 날짜?","2022-10-14");						// 여행 날짜가 언젠지 설정, 차후 marker의 정보창에 기입될 예정
		  } 
		  what = prompt("할일?","맥도날드 가기");								// 일정에 들어갈 할일 설정
		  while(what == null || what == ""){								// 일정에 null값이 없도록 설정
			  what = prompt("할일?","맥도날드 가기");							// 할일이 무엇인지 설정, 차후 marker의 정보창에 기입될 예정
		  }
		  like = prompt("기대되는것?","스타벅스 가기");							// 일정에 들어갈 기대되는일 설정
		  while(like == null || like == ""){								// 일정에 null값이 없도록 설정
			  like = prompt("기대되는것?","스타벅스 가기");						// 기대되는것이 무엇인지 설정, 차후 marker의 정보창에 기입될 예정
		  }
		  poznamka1.push(date);												// 일정에 여행날짜 추가
		  poznamka1.push(what);												// 일정에 할일 추가
		  poznamka1.push(like);   	  										// 일정에 기대되는것 추가
    	  
    	  console.log("일정: " + poznamka1);									// 일정 배열에 잘 들어갔는지 확인
		  data1.push(poznamka1);											// 일정 배열을 다시 배열로 옮긴다
		  console.log("일정: " + data1);										// 잘 옮겼는지 확인
    	  localStorage.setItem("note1",data1);								// 다음페이지에서 쓸수 있도록 localStorage 설정
		  

    	addPoint(event.latLng, map, poznamka, poznamka1);					// marker를 생성할수 있도록 함수호출
  	});
    
   
    function addmarker(props){								// 위에서 정의한 marker2의 배열 데이터를 받아 마커생성
      var marker2 = new google.maps.Marker({
        position:props.coords,								// marker2의 좌표값을 받아 마커 위치 지정
        map:map,
        descrip:props.content,        						// marker2의 content값을 받아 정보창 내용 지정
      });
      
     
      
      marker2.addListener('click',function(position){ 		// marker2 클릭 이벤트	
    	  if(arr1.length == 2){								// 만약 보조 polyline이 있다면 제거
    		  polyClear();    		  
    	  } 
    	 
    	  arr1 = [];										// 보조 polyline 생성할 배열 생성
    	  arr2 = [];
    	  arr3 = [];
    	  
    	  for(var i=0;i<markers2.length;i++){				// marker2의 배열 생성 순서에 따라 보조 polyline 배열에 좌표값 추가
    		  if(markers2[i] == props){
    			  arr1.push(markers2[i].coords);			// arr1은 클릭좌표, -1좌표
    			  arr1.push(markers2[i-1].coords);
    			  arr2.push(markers2[i].coords);			// arr2은 클릭좌표, +1좌표
    			  arr2.push(markers2[i+1].coords);
    			  arr3.push(markers2[i].coords);			// arr3은 클릭좦표, +2좌표
    			  arr3.push(markers2[i+2].coords);
    		  } 
    	  }
    	  console.log(arr1);								// 각배열에 잘추가 되었는지 확인
    	  console.log(arr2);
    	  console.log(arr3);
    	  
    	  poly1 = new google.maps.Polyline({				// 보조 polyline마다 polyline설정
  		    path: arr1,
  		  	strokeColor: 'black',
        	strokeWeight: 2,
        	strokeOpacity: 0.4,
        	map: map,
        	geodesic: true,
        	icons: [{
              	icon: {path: google.maps.SymbolPath.FORWARD_CLOSED_ARROW},
              	offset: '100%',
              	repeat: '100px'
          	}]            	
      	  }); 
    	  poly2 = new google.maps.Polyline({
  		    path: arr2,
  		  	strokeColor: 'black',
        	strokeWeight: 2,
        	strokeOpacity: 0.4,
        	map: map,
        	geodesic: true,
        	icons: [{
              	icon: {path: google.maps.SymbolPath.FORWARD_CLOSED_ARROW},
              	offset: '100%',
              	repeat: '100px'
          	}]            	
      	  }); 
    	  poly3 = new google.maps.Polyline({
    		    path: arr3,
    		    strokeColor: 'black',
              	strokeWeight: 2,
              	strokeOpacity: 0.4,
              	map: map,
              	geodesic: true,
              	icons: [{
                    icon: {path: google.maps.SymbolPath.FORWARD_CLOSED_ARROW},
                    offset: '100%',
                    repeat: '100px'
                }]           	
        	});     
    	  
    	  
    	  
    	  
    	  latlnglatlng = JSON.stringify(marker2.position.toJSON());			// 클릭한 곳에 좌표값을 JSON으로 변환
       	  coordsnation = JSON.parse(latlnglatlng);							// JSON 값을 다시 Object로 변환
          console.log("클릭한 곳에 좌표값: " + Object.values(coordsnation));		// Object의 값을 체크
       	  console.log("클릭한 곳에 좌표값의 타입: " + typeof(coordsnation.lat));
  		  latlng2 = coordsnation.lat.toFixed(4);							// 클릭한 좌표값을 경도 위도로 나눈다(DB에 넣을것이기때문에 소수점 4자리까지만 설정)
  		  latlng3 = coordsnation.lng.toFixed(4);
  			
       	  latlng1.push(latlng2);											// 좌표값을 다시 배열로 합친다
       	  latlng1.push(latlng3);	
       	
       	  console.log("클릭한 곳에 위도: " + latlng1[0]);						// 좌표값이 제대로 들어갔는지 체크
       	  console.log("클릭한 곳에 값이 제대로 배열에 들어갔는지 체크: " + latlng1);
       	  
       	  localStorage.setItem("좌표",latlng1);								// 좌표값을 다음페이지에서 쓸 수 있도록 localStorage값 설정
    	  
    	  console.log(marker2.position);									// marker2의 위치 체크
    	  
    	  var poznamka = prompt("얼마나 머무르실 예정입니까?(숫자만)", 3);			// 일정에 들어갈 변수 설정
    	  while(poznamka == null && poznamka == ""){						// 일정에 null값이 없도록 설정
    		  poznamka = prompt("얼마나 머무르실 예정입니까?(숫자만)", 3);    		// 얼마나 머무를 것인지 설정, 차후 marker위에 label 값이 될 예정	
    	  }
    	    	
    	  data.push(poznamka);												// 입력값 배열에 추가
    	  localStorage.setItem("note",data);								// 다음페이지에서 쓸수 있도록 localStorage 설정
    	  console.log("얼마나 머무를 예정: " + data);							// 잘들어갔는지 확인
    	   	
    	  city = prompt("여기는 어디입니까?");									// 일정에 들어갈 위치 이름 값 입력
    	  while(city == null || city == ""){								// 일정에 null값이 업도록 설정
    		  city = prompt("여기는 어디입니까?");								// 여기가 어딘지 설정, 차후 marker의 정보창에 기입될 예정
    	  }
    	  var poznamka1 = new Array();										// 일정값 넣을 배열 설정
    	  poznamka1.push(city);												// 일정값 배열에 추가
    	  console.log("일정: " + poznamka1);									// 잘들어갔는지 확인
    	  
    	  date = prompt("여행하는 날짜?","2022-10-14");							// 일정에 들어갈 여행 날짜 설정
		  while(date == null || date == ""){								// 일정에 null값이 업도록 설정
			  date = prompt("여행하는 날짜?","2022-10-14");						// 여행 날짜가 언젠지 설정, 차후 marker의 정보창에 기입될 예정
		  } 
		  what = prompt("할일?","맥도날드 가기");								// 일정에 들어갈 할일 설정
		  while(what == null || what == ""){								// 일정에 null값이 없도록 설정
			  what = prompt("할일?","맥도날드 가기");							// 할일이 무엇인지 설정, 차후 marker의 정보창에 기입될 예정
		  }
		  like = prompt("기대되는것?","스타벅스 가기");							// 일정에 들어갈 기대되는일 설정
		  while(like == null || like == ""){								// 일정에 null값이 없도록 설정
			  like = prompt("기대되는것?","스타벅스 가기");						// 기대되는것이 무엇인지 설정, 차후 marker의 정보창에 기입될 예정
		  }
		  poznamka1.push(date);												// 일정에 여행날짜 추가
		  poznamka1.push(what);												// 일정에 할일 추가
		  poznamka1.push(like);												// 일정에 기대되는것 추가
 
    	  console.log("일정: " + poznamka1);									// 일정 배열에 잘 들어갔는지 확인
		  data1.push(poznamka1);											// 일정 배열을 다시 배열로 옮긴다
		  console.log("일정: " + data1);										// 잘 옮겼는지 확인
    	  localStorage.setItem("note1",data1);								// 다음페이지에서 쓸수 있도록 localStorage 설정
	        	  
    	 
    	  addpolyline(marker2.position);									// polyline을 생성할수 있도록 함수호출
      	  
      });
      
      marker2.addListener('rightclick',function(position){					// marker2 우클릭 이벤트, marker2 제거
    	  if(arr1.length == 2){												// 만약 보조 polyline이 있다면 제거
    		  polyClear();    		  
    	  }
    	  
    	  latlnglatlng_del = JSON.stringify(marker2.position.toJSON());			// 클릭한 곳에 좌표값을 JSON으로 변환
       	  coordsnation_del = JSON.parse(latlnglatlng_del);						// JSON 값을 다시 Object로 변환
          console.log("삭제한 곳에 좌표값: " + Object.values(coordsnation_del));		// Object의 값을 체크
       	  console.log("삭제한 곳에 좌표값 타입: " + typeof(coordsnation_del.lat));
  		  latlng2_del = coordsnation_del.lat.toFixed(4);						// 클릭한 좌표값을 경도 위도로 나눈다(DB에 넣을것이기때문에 소수점 4자리까지만 설정)
  	      latlng3_del = coordsnation_del.lng.toFixed(4);
  	      
  	      console.log(data);													// 현재 일정 배열에 있는 값 조회
		  console.log(data1);
  					
  		  for(let i = 0; i < latlng1.length; i++) {								// 좌표값 배열에 있는 값 조회 해서 삭제할 위도 값 있으면 제거 + 같은 인덱스 위치에 일정도 제거
  		  	  if(latlng1[i] === latlng2_del)  {
  				 latlng1.splice(i, 1);
  				 data.splice(i/2,1);
  			  }
  		  }
  		  for(let i = 0; i < latlng1.length; i++) {								// 좌표값 배열에 있는 값 조회 해서 삭제할 경도 값 있으면 제거 + 같은 인덱스 위치에 일정도 제거
  			 if(latlng1[i] === latlng3_del)  {
  				 latlng1.splice(i, 1);
  				 data1.splice(i/2,1);  			    
  			 }
  	      }
  		  console.log(data);													// 현재 일정 배열에 제대로 제거 되었는지 확인
  		  console.log(data1);
		  
  
  	      localStorage.setItem("좌표",latlng1);									// 삭제하고 남은 데이터 다시 다음페이지에서 쓸수 있도록 localStorage 설정
  		  localStorage.setItem("note",data);
  		  localStorage.setItem("note1",data1);
    	  
      	  removepolyline(marker2.position);     								// 마커와 같이 있는 polyline도 삭제   	  
      });
      

      if(props.iconImage){														// marker2의 iconImage값을 받아 마커 이미지 지정
      	for(var i = 0; i < markers2.length; i++){
      		props.iconImage='planner_ico_paging_selected.png';     		
      	}
      	marker2.setIcon(props.iconImage);
      	
      }

      
      if(props.content){														// marker2의 content값이 있으면 받아 정보창 내용 지정				
        var infoWindow = new google.maps.InfoWindow({
          	content:props.content 
        });
        marker2.addListener('mouseover',function(){								// marker2 마우스오버 이벤트, 정보창 열기		
        	if (activeInfoWindow) { activeInfoWindow.close()}					// 정보창이 한개만 열수 있도록 지정
            infoWindow.open(map, marker2);
            activeInfoWindow = infoWindow;
      	  infoWindow.open(map,marker2);
      	  for(var i=0;i<markers2.length;i++){									// 마우스 오버시 사이드바에 정보창 데이터 추가
      		  sidebar.innerHTML = props.content;
      	  }
        });
        
      }
      return marker2;
 
    }
    
  var markerCluster = new MarkerClusterer(map, gmarkers, 						// 마커 클러스터링 이벤트 마커 여러개를 뭉쳐서 렉과 가시적으로 더 효율성 있게 만든다
    {
      imagePath:'https://developers.google.com/maps/documentation/javascript/examples/markerclusterer/m',
      gridSize:100,
      minClusterSize:10,
    });
  

}

function addpolyline_marker1(marker1) {						// marker1 polyline 생성 함수

    markers.push(marker1);									// 일정 마커에 marker1을 추가
	console.log("추가한 마커: " + marker1);					// 추가한 marker1 정보 출력
    polyline.getPath().setAt(markers.length - 1, marker1);	// polyline 생성
      
}

	
function removepolyline_marker1(marker1) {					// marker1 polyline 제거 함수

    for (var i = 0; i < markers.length; i++) {				// 일정 마커에 marker1이 있으면 제거

        if (markers[i] === marker1) {
			   								
            markers.splice(i, 1);
            console.log(markers);							// 제대로 제거 되었는지 확인
            polyline.getPath().removeAt(i);					// polyline 제거

        }
    }
}

function addpolyline(marker2) {								// marker2 polyline 생성 함수
	
    markers.push(marker2);									// 일정 마커에 marker2 추가
	console.log("추가한 마커: " + markers);					// 추가한 marker2 정보 출력
    polyline.getPath().setAt(markers.length - 1, marker2);	// polyline 생성
    
}

function removepolyline(marker2) {							// marker2 polyline 제거 함수

    for (var i = 0; i < markers.length; i++) {				// 일정 마커에 marker2 있으면 제거

        if (markers[i] === marker2) {

            // markers[i].setMap(null);						// marker1과 다르게 marker2는 고정마커이기 때문에 marker를 지도에서 없애면 안된다
            markers.splice(i, 1);							

            polyline.getPath().removeAt(i);					// polyline 제거
            
            break;											// break를 하는 이유는 경로의 중복값이 있기때문에 한번 클릭에 하나의 polyline만 제거하기 위함
        }
    }
}


function addpolyline_marker(marker) {						// marker polyline 생성 함수

    markers.push(marker);									// 일정 마커에 marker 추가

    polyline.getPath().setAt(markers.length - 1, marker);	// polyline 생성
        
}

function removepolyline_marker(marker) {					// marker polyline 제거 함수

    for (var i = 0; i < markers.length; i++) {				// 일정 마커에 marker 있으면 제거

        if (markers[i] === marker) {

            // markers[i].setMap(null);
            markers.splice(i, 1);							

            polyline.getPath().removeAt(i);					// polyline 제거
            
            break;
        }
    }
}


function removePoint(marker) {								// marker 제거 함수

    for (var i = 0; i < markers.length; i++) {				// 일정 마커에 marker 있으면 제거

        if (markers[i] === marker) {

            markers[i].setMap(null);						
            // console.log(markers);
            markers.splice(i, 1);
                        
            polyline.getPath().removeAt(i);					// polyline 제거
        }
    }
}


function addPoint(latlng, map, note, note1) {				// 위에서 정의한 데이터 받아서 제대로 제거 되었는지 확인
    
    var marker = new google.maps.Marker({					
        position: latlng,
        map: map,
        animation: google.maps.Animation.DROP,
        label: {
            color: 'white',
            fontWeight: 'bold',
            fontSize: '20px',
            text: note
        },
        optimized: false,
     });
    
    marker.addListener('click',function(){					// marker 클릭시 polyline 설정 
    	if(arr1.length == 2){								// 만약 보조 polyline이 있다면 제거
  		  polyClear();    		  
  	  	}
    	
    	var poznamka = new Array;							// 일정에 들어갈 변수 설정
    	  while(poznamka == null || poznamka == ""){		// 일정에 null값이 없도록 설정
    		  poznamka = prompt("얼마나 머무르실 예정입니까?", "숫자만 입력해주세요.");	// 얼마나 머무를 것인지 설정, 차후 marker위에 label 값이 될 예정
    		  if(poznamka != null && poznamka != ""){
    			  break;
    		  }
    		
    	  }
    	    	
    	  data.push(poznamka);								// 입력값 배열에 추가
    	  localStorage.setItem("note",data);				// 다음페이지에서 쓸수 있도록 localStorage 설정
    	
    	
    	  city = prompt("여기는 어디입니까?");					// 일정에 들어갈 위치 이름 값 입력
    	  while(city == null || city == ""){				// 일정에 null값이 업도록 설정
    		  city = prompt("여기는 어디입니까?");				// 여기가 어딘지 설정, 차후 marker의 정보창에 기입될 예정
    	  }
    	  var poznamka1 = new Array();						// 일정값 넣을 배열 설정
    	  console.log("일정: " + poznamka1);					// 잘들어갔는지 확인
    	 
    	  date = prompt("여행하는 날짜?","2022-10-14");			// 일정에 들어갈 여행 날짜 설정
		  while(date == null || date == ""){				// 일정에 null값이 업도록 설정
			  date = prompt("여행하는 날짜?","2022-10-14");   	// 여행 날짜가 언젠지 설정, 차후 marker의 정보창에 기입될 예정 			   
		  } 
		  what = prompt("할일?","맥도날드 가기");				// 일정에 들어갈 할일 설정
		  while(what == null || what == ""){				// 일정에 null값이 없도록 설정
			  what = prompt("할일?","맥도날드 가기");			// 할일이 무엇인지 설정, 차후 marker의 정보창에 기입될 예정
		  }
		  like = prompt("기대되는것?","스타벅스 가기");			// 일정에 들어갈 기대되는일 설정
		  while(like == null || like == ""){				// 일정에 null값이 없도록 설정
			  like = prompt("기대되는것?","스타벅스 가기");		// 기대되는것이 무엇인지 설정, 차후 marker의 정보창에 기입될 예정
		  }
		  poznamka1.push(date);								// 일정에 여행날짜 추가
		  poznamka1.push(what);								// 일정에 할일 추가
		  poznamka1.push(like);	 							// 일정에 기대되는것 추가 
    	  
		  poznamka1.unshift(city);
		  console.log("일정: " + poznamka1);					// 일정 배열에 잘 들어갔는지 확인
    	  data1.push(poznamka1);							// 일정 배열을 다시 배열로 옮긴다
    	  localStorage.setItem("note1",data1);				// 다음페이지에서 쓸수 있도록 localStorage 설정
		  
	    
  	  
  	    latlnglatlng = JSON.stringify(marker.position.toJSON());	// 클릭한 곳에 좌표값을 JSON으로 변환
     	coordsnation = JSON.parse(latlnglatlng);					// JSON 값을 다시 Object로 변환
        console.log("클릭한 곳에 좌표값: " + Object.values(coordsnation));
     	console.log("클릭한 곳에 좌표값의 타입: " + typeof(coordsnation.lat));
		latlng2 = coordsnation.lat.toFixed(4);						// 클릭한 좌표값을 경도 위도로 나눈다(DB에 넣을것이기때문에 소수점 4자리까지만 설정)
		latlng3 = coordsnation.lng.toFixed(4);
			
     	latlng1.push(latlng2);										// 좌표값을 다시 배열로 합친다
     	latlng1.push(latlng3);	
     	
     	console.log("클릭한 곳에 위도: " + latlng1[0]);					// 좌표값이 제대로 들어갔는지 체크
     	console.log("클릭한 곳에 값이 제대로 배열에 들어갔는지 체크: " + latlng1);
     	
     	localStorage.setItem("좌표",latlng1);							// 좌표값을 다음페이지에서 쓸 수 있도록 localStorage값 설정
  	  
  	    console.log(marker.position);
  	    addpolyline_marker(marker.position);						// polyline을 생성할수 있도록 함수호출
    	  
    });  
    
 	marker.addListener('rightclick',function(){						// marker 우클릭 이벤트, marker 제거
 		if(arr1.length == 2){										// 만약 보조 polyline이 있다면 제거
  		  polyClear();    		  
  	  	}
 		
 		latlnglatlng_del = JSON.stringify(marker.position.toJSON());		// 클릭한 곳에 좌표값을 JSON으로 변환
     	coordsnation_del = JSON.parse(latlnglatlng_del);					// JSON 값을 다시 Object로 변환
        console.log("삭제한 곳에 좌표값: " + Object.values(coordsnation_del));	// Object의 값을 체크
     	console.log("삭제한 곳에 좌표값 타입: " + typeof(coordsnation_del.lat));
		latlng2_del = coordsnation_del.lat.toFixed(4);						// 클릭한 좌표값을 경도 위도로 나눈다(DB에 넣을것이기때문에 소수점 4자리까지만 설정)
	    latlng3_del = coordsnation_del.lng.toFixed(4);
	    
			
		for(let i = 0; i < latlng1.length; i++) {					// 좌표값 배열에 있는 값 조회 해서 삭제할 위도 값 있으면 제거 + 같은 인덱스 위치에 일정도 제거
			if(latlng1[i] == latlng2_del) {
				latlng1.splice(i, 1);
				data.splice(i/2,1); 			   
			}
		}
		for(let i = 0; i < latlng1.length; i++) {					// 좌표값 배열에 있는 값 조회 해서 삭제할 경도 값 있으면 제거 + 같은 인덱스 위치에 일정도 제거
			if(latlng1[i] == latlng3_del)  {
				latlng1.splice(i, 1);
				data1.splice(i/2,1);
			}
	    }

	    localStorage.setItem("좌표",latlng1);							// 삭제하고 남은 데이터 다시 다음페이지에서 쓸수 있도록 localStorage 설정
		localStorage.setItem("note",data);
		localStorage.setItem("note1",data1);
		console.log(data);											// 현재 일정 배열에 제대로 제거 되었는지 확인
		console.log(data1);
  	  
    	removepolyline_marker(marker.position);        				// marker와 같이 있는 polyline도 삭제	  
    }); 
    
	google.maps.event.addListener(marker, 'rightclick', function(event) {	// 지도 우클릭 이벤트, marker 제거
		if(arr1.length == 2){												// 만약 보조 polyline이 있다면 제거
  		  polyClear();    		  
  	  	}
		
		latlnglatlng_del = JSON.stringify(event.latLng.toJSON());			// 클릭한 곳에 좌표값을 JSON으로 변환
     	coordsnation_del = JSON.parse(latlnglatlng_del);					// JSON 값을 다시 Object로 변환
      	console.log("삭제한 곳에 좌표값: " + Object.values(coordsnation_del));	// Object의 값을 체크
     	console.log("삭제한 곳에 좌표값 타입: " + typeof(coordsnation_del.lat));
		latlng2_del = coordsnation_del.lat.toFixed(4);						// 클릭한 좌표값을 경도 위도로 나눈다(DB에 넣을것이기때문에 소수점 4자리까지만 설정)
		latlng3_del = coordsnation_del.lng.toFixed(4);
			
     		
		
		for(let i = 0; i < latlng1.length; i++) {							// 좌표값 배열에 있는 값 조회 해서 삭제할 위도 값 있으면 제거 + 같은 인덱스 위치에 일정도 제거
			  if(latlng1[i] === latlng2_del)  {
				  latlng1.splice(i, 1);
				  data.splice(i/2,1);
			   
			  }
			}
		for(let i = 0; i < latlng1.length; i++) {							// 좌표값 배열에 있는 값 조회 해서 삭제할 경도 값 있으면 제거 + 같은 인덱스 위치에 일정도 제거
			  if(latlng1[i] === latlng3_del)  {
				  latlng1.splice(i, 1);
				  data1.splice(i/2,1);
			    
			  }
			}
	
		localStorage.setItem("좌표",latlng1);				// 삭제하고 남은 데이터 다시 다음페이지에서 쓸수 있도록 localStorage 설정
		localStorage.setItem("note",data);
		localStorage.setItem("note1",data1);
		console.log(data);								// 현재 일정 배열에 제대로 제거 되었는지 확인
		console.log(data1);
		removePoint(marker);							// marker와 같이있는 polyline 제거
    });   
	attachNote(marker, note1);								// marker 생성 및 정보창 생성
    markers.push(marker);									// 일정마커에 marker 추가
	polyline.getPath().setAt(markers.length - 1, latlng);	// polyline 생성
    
}


function attachNote(marker, note1) {					// marker 생성 함수
	var contents = "<h2>"+city+"</h2>"+"<br><hr>";		// 정보창 form 생성
	for(var i=1;i<note1.length;i++){
		contents += note1[i]+"<br>";
		if( i%3==0 && i != note1.length){
			contents += "<hr>";
		}
	}
  	var infowindow = new google.maps.InfoWindow({		// 정보창 생성
				content: "<div style='height:auto;width:400px'>"+contents+"</div>"
	});
    marker.addListener('mouseover', function () {			// marker 마우스 오버 효과, 정보창 열림
          if (activeInfoWindow) { activeInfoWindow.close()}	// 정보창이 하나만 열리게 하기위해 만듬
          infowindow.open(map, marker);
          activeInfoWindow = infowindow;
          for(var i=0;i<markers.length;i++){				// 마우스 오버시 사이드바에 정보창에 있는 데이터 출력
    		  sidebar.innerHTML = contents;
    	  }
    });
}

function attachNote_marker1(marker1, note, note1) {		// marker1 생성 함수
	var contents = "<h2>"+city+"</h2>"+"<br><hr>";		// 정보창 form 생성
	for(var i=1;i<note1.length;i++){
		contents += note1[i]+"<br>";
		if( i%3==0 && i != note1.length){
			contents += "<hr>";
		}
	}
  	var infowindow = new google.maps.InfoWindow({			// 정보창 생성
				content: "<div style='height:auto;width:400px'>"+contents+"</div>"
	});
    marker1.addListener('mouseover', function () {			// marker1 마우스 오버 효과, 정보창 열림
          if (activeInfoWindow) { activeInfoWindow.close()}	// 정보창이 하나만 열리게 하기위해 만듬
          infowindow.open(map, marker1);
          activeInfoWindow = infowindow;
          for(var i=0;i<markers.length;i++){				// 마우스 오버시 사이드바에 정보창에 있는 데이터 출력
    		  sidebar.innerHTML = contents;
    	  }
    });
}

function markersClear(){					// 지도에있는 마커를 모두 초기화 하는 함수
	localStorage.removeItem("note");		// 가지고있던 localStorage값이 겹치지 않게 모두 초기화
	localStorage.removeItem("note1");
	localStorage.removeItem("좌표");
	window.location.reload();				// 페이지 새로고침
}

function polyClear(){						// 보조 polyline 제거함수
	 poly1.setMap(null);
	 poly2.setMap(null);
	 poly3.setMap(null);	 
}

function move(){							// 경로 설정하는 페이지로 이동함수, 경로설정을 해야 DB에 입력이된다
	if(latlng1.length == 0){				// 만약 하나의 마커도 없다면 경로 설정을 못한다
		alert("경로 설정해주세요.");
	}else{
		location.href="../../joinmap.do";
	}
}



google.maps.event.addDomListener(window, 'load', initMap);



</script>

</body>
<script>
function actionToggle() {				// 액션 메뉴바 생성 함수
	  const action = document.querySelector('.action');
	  action.classList.toggle('active')
}

function openNav() {					// 사이드바 여는 함수
  document.getElementById("sidebar").style.width = "427px";
  document.getElementById("sidebar").style.padding = "1rem";  
  document.getElementById("container").style.marginright = "427px";
}

function closeNav() {					// 사이드바 닫는 함수
  document.getElementById("sidebar").style.width = "0";
  document.getElementById("sidebar").style.padding = "0";
  document.getElementById("container").style.marginright = "0";
}
</script>
</html>