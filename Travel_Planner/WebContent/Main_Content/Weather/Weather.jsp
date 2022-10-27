<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
  <head>
    <title>Marker Clustering</title>
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
<script src="https://maps.googleapis.com/maps/api/js?key=AIzaSyDjtW34Ax16khc7UYth6--V4pNFX1XlHUE&libraries=places"></script>
<script src="https://developers.google.com/maps/documentation/javascript/examples/markerclusterer/markerclusterer.js"></script>
<div id="container">
	<div id="map"></div>
</div>
<script type="text/javascript">
var map, polyline,markers = new Array();		
var stockholm = {lat:45,lng:10}; 
var s = "";
var weather = new Array();
var error = "";
function initMap(){	
      // 지도의 옵션
      var options = {
        	zoom:4,
        	center:stockholm, 
        	streetViewControl: true,
        	draggable:true,
        	mapTypeId: "roadmap",	
			

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
	  	map = new google.maps.Map(document.getElementById('map'),options);		// 지도 영역 설정 div id = map
     
    // 마커의 데이터, 재활용한거여서 iconImage와 content는 안쓴다
    var markers = [ 	
        // 가나
        {
          coords:{lat:6.6666004, lng:-1.6162709},
          iconImage:'assets/img/places/stparkdublin.png',
          content:'<div style="height:auto;width:400px;"><h1>가나-쿠마시</h1>쿠마시는 가나 아샨티 주의 주도이며 구 아샨티 왕국의 수도였다. 수도인 아크라에서 북서쪽으로 약 250km 떨어져 있다. 쿠마시는 적도로부터 북쪽으로 약 482km, 기니만으로터 북쪽으로 약 160km 에 위치한다.<br><br><div style="width:400px;height:auto;"><a href="photo.jsp"><img src="https://pds.joongang.co.kr/news/component/htmlphoto_mmdata/201809/20/26ed3595-8cff-43a9-993d-ea10be3c0393.jpg"  width="400px" height="auto"></a></div></div>',
        },
        // 가봉
        {
          coords:{lat:0.4161976, lng:9.4672676},
          iconImage:'assets/img/places/buncrana1.png',
          content:'<div style="height:auto;width:400px;"><h1>가봉-리브르빌</h1>볼리브르빌(프랑스어: Libreville)은 가봉의 수도이자 에스튀에르 주의 주도이다. 1849년 해방 노예 출신 인사들에 의해 건설되었다.<br><br><div style="width:400px;height:auto;"><a href="photo.jsp"><img src="http://upload.wikimedia.org/wikipedia/commons/8/83/Libreville.jpg"  width="400px" height="auto"></a></div></div>',
        },
        // 가이아나
        {
          coords:{lat:6.7963553, lng:-58.1531906},
          iconImage:'assets/img/places/wexford museum.png',
          content:'<div style="height:auto;width:400px;"><h1>가이아나-조지타운</h1>조지타운은 가이아나의 수도이며 인구는 75,000명이다. 데메라라 강의 하구에 위치한 도시로 대서양에 접해 있다. "카리브 해의 정원 도시"라는 별명이 있으며 데메라라마하이카 주에 위치한다. 네덜란드령이었던 시대는 스타브루크로 불리고 있었다.<br><br><div style="width:400px;height:auto;"><a href="photo.jsp"><img src="http://t3.gstatic.com/licensed-image?q=tbn:ANd9GcRUrUuFBwJZJCRMtbwUGqGu_x8Kr-xbZiBV1s7Tcs-uCZYa5DH_OqPW7D4lVYd3BJon"  width="400px" height="auto"></a></div></div>',
        },
        // 감비아
        {
          coords:{lat:13.454375, lng:-16.5753186},
          iconImage:'assets/img/places/wicklow.png',
          content:'<div style="height:auto;width:400px;"><h1>감비아-반줄</h1>반줄은 아프리카 서쪽에 위치한 감비아의 수도로, 같은 이름을 가진 행정 구역 안에 위치한다. 구 명칭은 바서스트였다. 대서양으로 빠져들어가는 감비아 강어귀에 있는 하중도 세인트 메리 섬, 즉 반줄 섬 위에 위치해 있다.<br><br><div style="width:400px;height:auto;"><a href="photo.jsp"><img src="http://t2.gstatic.com/licensed-image?q=tbn:ANd9GcStxGm0op5YFGmL-nGsF40Al9s7-ce3LDggxtmr75dxavspMCNbtKHO9CqcZlhVzVhR"  width="400px" height="auto"></a></div></div>',
        },
        // 과테말라
        {
          coords:{lat:14.633333, lng:-90.66},
          iconImage:'assets/img/places/glendalough.png',
          content:'<div style="height:auto;width:400px;"><h1>과테말라-믹스코</h1>믹스코는 과테말라 과테말라주의 도시로 면적은 132km², 높이는 1,650m, 인구는 688,124명이다. 과테말라의 수도인 과테말라 시에서 19km 정도 떨어진 곳에 위치한다.<br><br><div style="width:400px;height:auto;"><a href="photo.jsp"><img src="https://upload.wikimedia.org/wikipedia/commons/thumb/8/82/Cerroalux2009.jpg/250px-Cerroalux2009.jpg"  width="400px" height="auto"></a></div></div>',
        },
        // 그레나다
        {
          coords:{lat:12.1165, lng:-61.67899999999999},
          iconImage:'assets/img/places/butterCork.png',
          content:'<div style="height:auto;width:400px;"><h1>그레나다-그레나다</h1>>그레나다는 카리브 해에 있는 영연방 군주국이다. 수도는 세인트조지스이며 공용어는 영어이다. 그레나다는 ‘향신료의 섬’으로도 알려져 있는데, 그레나다가 세계에서 가장 많은 양의 너트맥과 메이스 작물을 수출하기 때문이다.<br><br><div style="width:400px;height:auto;"><a href="photo.jsp"><img src="https://t1.daumcdn.net/cfile/tistory/275CC83D59748CE22B"  width="400px" height="auto"></a></div></div>',
        },
        // 조지아
        {
          coords:{lat:42.2662428, lng:42.7180019},
          iconImage:'assets/img/places/prisoncork.png',
          content:'<div style="height:auto;width:400px;"><h1>조지아-쿠타이시</h1>쿠타이시는 조지아 서쪽의 중심지이다. 인구는 약 14만7635명이다. 소비에트 연방 붕괴 이전에는 그루지야 SSR 제2의 공업 도시였고, 자동차 공장 등이 유명했다. 트빌리시로부터는 221킬로미터 지점에 위치해 있다.<br><br><div style="width:400px;height:auto;"><a href="photo.jsp"><img src="http://t2.gstatic.com/licensed-image?q=tbn:ANd9GcT09bYMhrtaETa1ZbfCQ246OJ4pJguknm43_-5riWn0OJXEl7s_GARnHXaOZopCqm1k"  width="400px" height="auto"></a></div></div>',
        },
        // 그리스
        {
          coords:{lat:39.074208, lng:21.824312},
          iconImage:'assets/img/places/Cork.png',
          content:'<div style="height:auto;width:400px;"><h1>그리스-아테네</h1>아테네는 그리스의 수도이자 최대의 도시이며, 아티키 주의 중심 도시이다. 세계적으로 오래된 도시이며, 역사 시대가 개막한 지 3,400년에 이른다. 대략 기원전 11세기 ~ 7세기부터 인간이 정착해 살았던 흔적이 남아있다.<br><br><div style="width:400px;height:auto;"><a href="photo.jsp"><img src="http://t0.gstatic.com/licensed-image?q=tbn:ANd9GcQnnEGadu7L1DQdj_clC4ZHVA4YvTBuzBXt6msh5VHbNnlw3NbVSwd1u0xh9CLfVRLk"  width="400px" height="auto"></a></div></div>',
        },
        // 기니
        {
              coords:{lat:9.641185499999999, lng:-13.5784012},
              iconImage:'assets/img/places/wexford.png',
              content:'<div style="height:auto;width:400px;"><h1>기니-코나크리</h1>코나크리는 기니 공화국의 수도이며 대서양에 접하고 있다. 인구는 166만 973명이다. 기니의 경제적·문화적 중심지로, 시가지 및 중심부는 기니 연안의 톰보 섬에 위치해 있다.<br><br><div style="width:400px;height:auto;"><a href="photo.jsp"><img src="http://t2.gstatic.com/licensed-image?q=tbn:ANd9GcS4VBwONAzFJosSWeayvMKV3p5CmbfucB1y9sXsVoHQiePXatsglAhsgUxDBJ6ebKJ4"  width="400px" height="auto"></a></div></div>',
        },
        // 기니비사우
        {
              coords:{lat:11.8632196, lng:-15.5843227},
              iconImage:'assets/img/places/wexford.png',
              content:'<div style="height:auto;width:400px;"><h1>기니비사우-비사우</h1>비사우는 기니비사우의 수도로, 인구는 492,004명이다. 제바 강 어귀, 대서양을 바라보는 곳에 위치한 비사우는 나라의 가장 큰 도시이자, 주요 항구, 행정과 군사 중심이다.<br><br><div style="width:400px;height:auto;"><a href="photo.jsp"><img src="http://t1.gstatic.com/licensed-image?q=tbn:ANd9GcS7evZMArvgvwXZ0ARw2vPxCk5QxOxs4MsY55BhW8QNPexHUTPY8AlmrHvD3fUiyRDU"  width="400px" height="auto"></a></div></div>',
        },
        // 나미비아
        {
              coords:{lat:-22.5608807, lng:17.0657549},
              iconImage:'assets/img/places/wexford.png',
              content:'<div style="height:auto;width:400px;"><h1>나미비아-빈트후크</h1>빈트후크는 나미비아의 수도이다. 나미비아의 거의 중앙에 있으며, 남아프리카 공화국과 연결되는 철도가 있다. 도시는 작고 주위가 사막에 둘러싸여 있어 강수량은 적다.<br><br><div style="width:400px;height:auto;"><a href="photo.jsp"><img src="http://t3.gstatic.com/licensed-image?q=tbn:ANd9GcTWVeHtrGDfCVueATK696soXdsINF7CJ2zKig-g-JLjyhrOt39bfHZkb55MQof5xPK6"  width="400px" height="auto"></a></div></div>',
        },
        // 나우루
        {
              coords:{lat:-0.522778, lng:166.931503},
              iconImage:'assets/img/places/wexford.png',
              content:'<div style="height:auto;width:400px;"><h1>나우루-아레니스</h1>나우루 공화국(나우루어: Ripublik Naoero 리퍼블릭 나오에로, 영어: Republic of Nauru) 또는 나우루는 오세아니아의 미크로네시아에 있는 나라이다.<br><br><div style="width:400px;height:auto;"><a href="photo.jsp"><img src="https://mblogthumb-phinf.pstatic.net/MjAyMTAyMDNfODYg/MDAxNjEyMzEyMjA0NjM0.sGMC0zRcRv1g5k-D61VPBjO8StIzhUue3RbqFLdDtY0g.APmwxUT6OXtBUG5kd69zKa6nFzLpLaJHgWcPJhYawdkg.JPEG.the20thcenturyfarmer/photo-1553947315-42cee3c8c771.jpg?type=w800"  width="400px" height="auto"></a></div></div>',
        },
        // 나이지리아
        {
              coords:{lat:9.0764785, lng:7.398574},
              iconImage:'assets/img/places/wexford.png',
              content:'<div style="height:auto;width:400px;"><h1>나이지리아-아부자</h1>아부자는 나이지리아의 수도이다. 인구는 1,078,700명이다. 1976년 나이지리아 정부가 수도를 라고스에서 이전하는 정책을 추진하고 있었는데, 나이지리아의 새 수도로 아부자가 선정되었다.<br><br><div style="width:400px;height:auto;"><a href="photo.jsp"><img src="https://youimg1.tripcdn.com/target/100v1f000001h1a25F19A.jpg?proc=source%2Ftrip"  width="400px" height="auto"></a></div></div>',
        },
        // 남수단
        {
              coords:{lat:4.859363, lng:31.57125},
              iconImage:'assets/img/places/wexford.png',
              content:'<div style="height:auto;width:400px;"><h1>남수단-주바</h1>주바는 남수단의 수도이자 주베크 주의 주도이다.<br><br><div style="width:400px;height:auto;"><a href="photo.jsp"><img src="http://t0.gstatic.com/licensed-image?q=tbn:ANd9GcTHlicIo-3lGwwoxs37fpdKvdc3fru9jTE4niK5iXclQaei3VYEPkOCXpd9lro3LNVQ"  width="400px" height="auto"></a></div></div>',
        },
        // 남아프리카공화국
        {
              coords:{lat:-33.9248685, lng:18.4240553},
              iconImage:'assets/img/places/wexford.png',
              content:'<div style="height:auto;width:400px;"><h1>남아프리카공화국-케이프타운</h1>케이프타운은 남아프리카 공화국의 입법 수도이다. 아프리칸스어로는 카앞스탇, 이카파 라고 부른다. 이 도시의 배후에는 테이블 산이 있으며, 부근에 희망봉이 있다.<br><br><div style="width:400px;height:auto;"><a href="photo.jsp"><img src="http://t2.gstatic.com/licensed-image?q=tbn:ANd9GcTfd_vOa29DU0mLgNi64CfwgCYXvkGJ_xaSk4rp9TJ6dewMYVoYyQOs7rY-b5d9Qlry"  width="400px" height="auto"></a></div></div>',
        },
        // 네덜란드
        {
              coords:{lat:52.3675734, lng:4.9041389},
              iconImage:'assets/img/places/wexford.png',
              content:'<div style="height:auto;width:400px;"><h1>네덜란드-암스테르담</h1>암스테르담은 네덜란드의 수도이자 최대 도시이다. 그러나 행정의 중심지는 암스테르담으로부터 남서쪽으로 약 50 킬로미터 떨어진 헤이그에 있다.<br><br><div style="width:400px;height:auto;"><a href="photo.jsp"><img src="http://t3.gstatic.com/licensed-image?q=tbn:ANd9GcQl7QL1Nl9U-ViPNA6ipvcULVJGnF4xg2rVNwKx5xFC6DUUdFs1XU8IPR6weMMt6VTA"  width="400px" height="auto"></a></div></div>',
        },
        // 네팔
        {
              coords:{lat:27.7172453, lng:85.3239605},
              iconImage:'assets/img/places/wexford.png',
              content:'<div style="height:auto;width:400px;"><h1>네팔-카트만두</h1>카트만두는 네팔의 수도로 네팔에서 가장 큰 도시이다. 네팔 중앙의 카트만두 계곡에 위치하고 있으며, 더르바르 광장, 스와얌부나트 사원, 부다나트 사원, 파슈파티나트 사원 등은 세계문화유산으로 지정되어 있다.<br><br><div style="width:400px;height:auto;"><a href="photo.jsp"><img src="https://t1.daumcdn.net/cfile/tistory/2370D64450DC78C71D"  width="400px" height="auto"></a></div></div>',
        },
        // 노르웨이
        {
              coords:{lat:59.9138688, lng:10.7522454},
              iconImage:'assets/img/places/wexford.png',
              content:'<div style="height:auto;width:400px;"><h1>노르웨이-오슬로</h1>오슬로는 노르웨이의 남부 해안에 있는 도시이며, 이 나라의 수도이다. 13세기 호콘 5세에 의하여 수도로 정해져 한자 동맹의 항구로서 번영했다.<br><br><div style="width:400px;height:auto;"><a href="photo.jsp"><img src="http://t3.gstatic.com/licensed-image?q=tbn:ANd9GcQrhjAsOPf2ojyQlI3qis5lY1B4LxCa7kb52WeQyIz2GOWO27VEXPywMEyRjCV3nABW"  width="400px" height="auto"></a></div></div>',
        },
        // 뉴질랜드
        {
              coords:{lat:-36.8476191, lng:174.7698041},
              iconImage:'assets/img/places/wexford.png',
              content:'<div style="height:auto;width:400px;"><h1>뉴질랜드-오클랜드</h1>오클랜드는 인구 122만 3200명의 뉴질랜드의 최대의 도시로, 북섬 북단에 자리잡고 있다. 오클랜드 반도 기부의 지협상에 자리하고 있다.<br><br><div style="width:400px;height:auto;"><a href="photo.jsp"><img src="http://t1.gstatic.com/licensed-image?q=tbn:ANd9GcRr4SHtElSDWw0tHGhgifVsnposKXo4vBMLK5MZeBOUfe6mg6EGsiCQGHtmqWRD8pkd"  width="400px" height="auto"></a></div></div>',
        },
        // 니제르
        {
              coords:{lat:13.5115963, lng:2.1253854},
              iconImage:'assets/img/places/wexford.png',
              content:'<div style="height:auto;width:400px;"><h1>니제르-니아메</h1>니아메는 서아프리카의 내륙국 니제르의 수도이다. 니제르 최대 도시이자 니제르의 정치·경제의 중심지이다. 내륙 도시이지만 아프리카의 중요한 강의 하나인 나이저강에 접한, 항만 도시이기도 하다.<br><br><div style="width:400px;height:auto;"><a href="photo.jsp"><img src="http://t1.gstatic.com/licensed-image?q=tbn:ANd9GcTQ2EvPS46JzzVa07ExLEud7TKd1DxHz6Kp3VkaoHXXdQJtLLTf91kHMWgjYxo1dQQF"  width="400px" height="auto"></a></div></div>',
        },
        // 니카라과
        {
              coords:{lat:12.865416, lng:-85.207229},
              iconImage:'assets/img/places/wexford.png',
              content:'<div style="height:auto;width:400px;"><h1>니카라과-마나과</h1>마나과는 니카라과의 수도이고 인구는 220만~250만명이다. 중앙아메리카에서 두 번째로 큰 도시이다. <br><br><div style="width:400px;height:auto;"><a href="photo.jsp"><img src="http://t0.gstatic.com/licensed-image?q=tbn:ANd9GcQEVpXxfI6x2mMscKEAq3QxPH7daNYmQpDZvXAc93nXK7hWN27Zm57LDj7dcIjwlk4g"  width="400px" height="auto"></a></div></div>',
        },
        // 덴마크
        {
              coords:{lat:55.6760968, lng:12.5683371},
              iconImage:'assets/img/places/wexford.png',
              content:'<div style="height:auto;width:400px;"><h1>덴마크-쾨벤하운</h1>코펜하겐은 덴마크의 수도이다. 덴마크의 국회, 정부, 왕궁이 모두 코펜하겐에 소재해 있다.<br><br><div style="width:400px;height:auto;"><a href="photo.jsp"><img src="http://t0.gstatic.com/licensed-image?q=tbn:ANd9GcRbPWQ5Q4rNpDu-QT3kzjSEpFSf4HNzqBDuMQXhZqYkO0cEy9AIzH7AlZIr2EbUaNJn"  width="400px" height="auto"></a></div></div>',
        },
        // 도미니카 연방
        {
              coords:{lat:15.3091676, lng:-61.37935539999999},
              iconImage:'assets/img/places/wexford.png',
              content:'<div style="height:auto;width:400px;"><h1>도미니카연방-로조</h1>로조(Roseau)는 도미니카 연방의 수도이다. 카리브 해에 접한 도미니카 섬의 서해안에 위치하고 인구는 15,853명이다. 시가지에는 프랑스풍 건물이 나란히 서있다.<br><br><div style="width:400px;height:auto;"><a href="photo.jsp"><img src="https://storage.doopedia.co.kr/upload/_upload/image4/1712/16/171216021698131/171216021698131_thumb_400.jpg"  width="400px" height="auto"></a></div></div>',
        },
        // 도미니카공화국
        {
              coords:{lat:18.4860575, lng:-69.93121169999999},
              iconImage:'assets/img/places/wexford.png',
              content:'<div style="height:auto;width:400px;"><h1>도미니카공화국-산토도밍고</h1>산토도밍고는 도미니카 공화국의 수도로 인구 2,061,200명이다. 정식 명칭은 산토도밍고데구스만이다. 행정 구역상으로는 국가 지구에 속한다. <br><br><div style="width:400px;height:auto;"><a href="photo.jsp"><img src="https://mblogthumb-phinf.pstatic.net/MjAyMDAyMDVfMjIz/MDAxNTgwOTA3Nzc3NzQy.d_BKCspZ7Z-D4J8lwB47sTUBtuALYMcRN5z6fbN9U70g.XH4rMb4CdZSGKxPDbZfSZkIVQTN6frnJaKJQasCJd0og.JPEG.dyd4154/20191223_131244.jpg?type=w800"  width="400px" height="auto"></a></div></div>',
        },
        // 독일
        {
            coords:{lat:52.52000659999999, lng:13.404954},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>독일-베를린</h1>베를린은 독일의 수도이다. 2020년 12월 기준 인구는 3,769,495명으로, 독일 내 단일 규모로는 최대의 도시이고 유럽 연합의 최대 도시이기도 하다. 독일 북동부 슈프레강과 하펠강 연안에 있다. <br><br><div style="width:400px;height:auto;"><a href="photo.jsp"><img src="https://w.namu.la/s/bca3b2d9c2145bebc7b4cadaf82d5e9401f556c844ca6d9d7eb59d7280e8da51e2c52fbe21bc30d3e8009c5afcb15682530bb0d6804135f5a20bb74f479fbf2439235332b2e50939cb7944ebfd69a8a5bb0a0c56056d0e2776961cd3528a3996cdf071f820ce32a02442aa3c64269bde"  width="400px" height="auto"></a></div></div>',
        },
        // 동티모르
        {
            coords:{lat: -8.5568557, lng:125.5603143},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>동티모르-딜리</h1>딜리는 티모르섬 북동부에 위치하는 동티모르의 수도이자, 동티모르 최대의 도시이다. 인구는 약 22만명으로 1520년에 포르투갈의 식민지로 건설되었다. 소순다 열도의 가장 동쪽, 티모르섬의 북쪽 해안에 위치한다.<br><br><div style="width:400px;height:auto;"><a href="photo.jsp"><img src="https://dynamic-media-cdn.tripadvisor.com/media/photo-o/0f/8e/45/f9/backside-beach-from-the.jpg?w=700&h=-1&s=1"  width="400px" height="auto"></a></div></div>',
        },
        // 라오스
        {
            coords:{lat:18.95009, lng:102.44379},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>라오스-방비엥</h1>왕위앙은 라오스 비엔티안주의 도시로 인구는 약 25,000명이다. 남송 강과 접하며 루앙프라방과 비엔티안의 중간 지점에 위치한다. 카르스트 지형을 띤 언덕으로 유명한 곳이다.<br><br><div style="width:400px;height:auto;"><a href="photo.jsp"><img src="https://d2qgx4jylglh9c.cloudfront.net/kr/wp-content/uploads/2015/03/2268CE4454FFE10938C0BC.jpg"  width="400px" height="auto"></a></div></div>',
        },
        // 라이베리아
        {
            coords:{lat:6.3156068, lng:-10.8073698},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>라이베리아-몬로비아</h1>몬로비아는 라이베리아의 수도이다. 메주라도 곶 대서양 연안에 위치하며, 라이베리아에서 가장 인구가 많은 주인 몽세라도 주에 위치한다. <br><br><div style="width:400px;height:auto;"><a href="photo.jsp"><img src="https://pds.joongang.co.kr/news/component/htmlphoto_mmdata/202201/20/d1f59c9d-c750-4467-b90b-5bb23f695155.jpg"  width="400px" height="auto"></a></div></div>',
        },
        // 라트비아
        {
            coords:{lat:56.9676941, lng:24.1056221},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>라트비아-리가</h1>리가는 라트비아의 수도로, 발트해와 다우가바강에 접해 있다. 리가는 발트 3국 가운데 가장 큰 도시이다. 면적은 307.17 km²로서, 해발 1~10m 사이에 분포해 있으며, 평지와 사구로 되어 있다. <br><br><div style="width:400px;height:auto;"><a href="photo.jsp"><img src="https://mblogthumb-phinf.pstatic.net/MjAxNzA4MTdfMjc3/MDAxNTAyOTI3NTEyMTM5.gQEc9sWPNyEvjM19WfsS8N0W4_5OaWMTU3Af2DKWJzYg.UTTNfGpDL5_soSHYDLgaGxhAhAjqw6j4tY_iaQawFR0g.JPEG.kotfa198643/riga-1380164_1920.jpg?type=w800"  width="400px" height="auto"></a></div></div>',
        },
        // 러시아
        {
            coords:{lat:55.755826, lng:37.6173},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>러시아-모스크바</h1>모스크바는 러시아의 수도이다. 러시아 최대의 도시이자 유럽에서 인구가 가장 많은 도시이며, 세계에서는 4번째로 큰 도시이다. 14세기에서 18세기 초까지 러시아 제국의 수도는 상트페테르부르크였다.<br><br><div style="width:400px;height:auto;"><a href="photo.jsp"><img src="https://dimg.donga.com/ugc/CDB/SHINDONGA/Article/5e/60/54/94/5e605494098dd2738de6.jpg"  width="400px" height="auto"></a></div></div>',
        },
        // 레바논
        {
            coords:{lat:33.8937913, lng:35.5017767},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>레바논-베이루트</h1>베이루트는 레바논의 수도이며, 베이루트 주의 중심지이자 레바논 최대의 도시다. 또 지중해에 접한 레바논 제일의 해항이다. <br><br><div style="width:400px;height:auto;"><a href="photo.jsp"><img src="https://img.freepik.com/premium-photo/lebanon-beirut-city-skyline_24859-755.jpg"  width="400px" height="auto"></a></div></div>',
        },
        // 레소토
        {
            coords:{lat:-29.3076703, lng:27.4792557},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>레소토-마세루</h1>마세루는 레소토의 수도이자 최대 도시이다. 셀리던 강의 하류에 위치해 있으며, 남아프리카 공화국과의 국경을 접한다. 레소토 상업의 중심지이고 인구는 22만 명이다. <br><br><div style="width:400px;height:auto;"><a href="photo.jsp"><img src="https://storage.doopedia.co.kr/upload/_upload/image5/2206/29/220629024347534/220629024347534_thumb_400.jpg"  width="400px" height="auto"></a></div></div>',
        },
        // 루마니아
        {
            coords:{lat:46.7712101, lng:23.6236353},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>루마니아-클루지나포카</h1>클루지나포카는 루마니아 서북부 클루지 주에 있는 도시로 루마니아 제2의 도시다. 인구 324,576. 트란실바니아 지방의 중심 도시이며 줄여서 클루지라고 부르기도 한다. <br><br><div style="width:400px;height:auto;"><a href="photo.jsp"><img src="https://w.namu.la/s/780beb8009e44030dfcc5b6cfe067dfc366ae521924219e14bcd83bfa9478d670855c1bc2ea331c05a9f30c7c0e61399828da8b2d0eb4d6af6de7837696fcf580656ef0af3477095288addba540f513b91579e569b206ce84bce01bd455c97c8"  width="400px" height="auto"></a></div></div>',
        },
        // 룩셈부르크
        {
            coords:{lat:50.0546886, lng:5.467698299999999},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>룩셈부르크-뤽상부르</h1>룩셈부르크 대공국, 약칭 룩셈부르크는 서유럽에 위치한 국가이며 대공이 통치하는 대공국이다. 수도는 룩셈부르크이다. 룩셈부르크는 세계에서 국민 소득이 높은 나라 중 하나이기도 하다.<br><br><div style="width:400px;height:auto;"><a href="photo.jsp"><img src="https://youimg1.tripcdn.com/target/0103l1200082ev53l539B_C_640_320_R5_Q70.jpg_.webp?proc=source%2Ftrip"  width="400px" height="auto"></a></div></div>',
        },
        // 르완다
        {
            coords:{lat:-1.9440727, lng:30.0618851},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>르완다-키갈리</h1>키갈리는 르완다의 수도로, 면적은 730km², 인구는 745,261명이다. 르완다의 거의 중앙에 위치해 있고, 1,433ｍ에서 1,645m의 고지에 위치해 있다. 3개 구를 관할한다.<br><br><div style="width:400px;height:auto;"><a href="photo.jsp"><img src="https://youimg1.tripcdn.com/target/100p10000000o2w4pA6DC_C_640_320_R5_Q70.jpg_.webp?proc=source%2Ftrip"  width="400px" height="auto"></a></div></div>',
        },
        // 리비아 
        {
            coords:{lat:32.8872094, lng:13.1913383},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>리비아-트리폴리</h1>트리폴리는 리비아의 수도이다. 리비아의 북서부에 위치해 있고, 지중해에 접한 항구도시이다. 해안지대의 좁은 오아시스에 있고, 30km 떨어진 내륙은 사막지대이다. <br><br><div style="width:400px;height:auto;"><a href="photo.jsp"><img src="https://mblogthumb-phinf.pstatic.net/20141227_178/hansongp_1419608364564nj8Yk_JPEG/IMG_1335-1%C6%AE%B8%AE%C6%FA%B8%AE%C0%FC%B0%E62.jpg?type=w2"  width="400px" height="auto"></a></div></div>',
        },
        // 리투아니아
        {
            coords:{lat:54.8985207, lng:23.9035965},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>리투아니아-카우나스</h1>카우나스는 리투아니아 제2의 도시이다. 카우나스 주의 중심지이기도 하며, 카우나스 시와 카우나스 군청이 동시에 자리해 있다. 또 카우나스 대교구 교회도 이곳에 있다.<br><br><div style="width:400px;height:auto;"><a href="photo.jsp"><img src="https://dynamic-media-cdn.tripadvisor.com/media/photo-o/0e/33/00/a4/lrm-export-20170114-183226.jpg?w=700&h=500&s=1"  width="400px" height="auto"></a></div></div>',
        },
        // 리헤텐슈타인
        {
            coords:{lat:47.1410303, lng:9.5209277},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>리헤텐슈타인-바두츠</h1>파두츠는 리히텐슈타인의 수도로 인구는 2005년 기준으로 5019명이다. 리히텐슈타인 공작가는 본래 오스트리아에 거소가 있었는데, 1938년부터 이곳에 거소를 두었다.<br><br><div style="width:400px;height:auto;"><a href="photo.jsp"><img src="https://post-phinf.pstatic.net/MjAxNzAzMjlfNzAg/MDAxNDkwNzY5OTI3MTkz.GcainkGLoDdXltGRSub2Ev1gcYHonKifBiNnT-SM9Z4g.UuuxDcxkFc4PX0UG5vhK69F2KsFYkHp7F-x30w9zRgsg.JPEG/SAM_9787.JPG?type=w1200"  width="400px" height="auto"></a></div></div>',
        },
        // 마다가스카르
        {
            coords:{lat:-18.8791902, lng:47.5079055},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>마다가스카르-안타나나리보</h1>안타나나리보는 마다가스카르의 수도로 마다가스카르섬의 거의 중앙에 위치한다. 마다가스카르 고원에 위치하고, 표고는 1,200미터를 넘는다.<br><br><div style="width:400px;height:auto;"><a href="photo.jsp"><img src="http://ojsfile.ohmynews.com/STD_IMG_FILE/2007/1002/IE000812151_STD.jpg"  width="400px" height="auto"></a></div></div>',
        },
        // 마셜 제도
        {
            coords:{lat:7.094972899999999, lng:171.1150819},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>마셜제도-아젤테이크</h1>Ajeltake는 마셜 제도의 도시입니다. 그것은 Majuro Atoll에 위치하고 Atoll 고리의 남서쪽 부분을 차지합니다. 2006 년 인구는 1,700 명입니다. <br><br><div style="width:400px;height:auto;"><a href="photo.jsp"><img src="https://mblogthumb-phinf.pstatic.net/MjAyMDExMDVfNTYg/MDAxNjA0NTU3NTU5NzM3.zeplcb6LUzq4Fw533c2pZ9Mmzm1x_HzpodJNkMaOwPUg.Ie5V9oY8GbhuJyPnQoOvQte1laj5S_hjJ39adt7_voUg.JPEG.sptokorea/SE-7f11a9cb-df77-42ba-ab18-acccf63d03ed.jpg?type=w800"  width="400px" height="auto"></a></div></div>',
        },
        // 말라위
        {
            coords:{lat:-14.5943269, lng:34.2099104},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>말라위-릴롱궤</h1>릴롱궤는 인구 866,272명의 말라위의 수도이다.<br><br><div style="width:400px;height:auto;"><a href="photo.jsp"><img src="https://dynamic-media-cdn.tripadvisor.com/media/photo-o/12/09/43/c4/monkey-bay.jpg?w=500&h=300&s=1"  width="400px" height="auto"></a></div></div>',
        },
        // 말레이시아
        {
            coords:{lat:3.1569486, lng:101.712303},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>말레이시아-쿠알라룸푸르</h1>쿠알라룸푸르, 공식적으로 쿠알라룸푸르 연방 직할구는 말레이시아의 수도이며 말레이시아에서 가장 큰 도시로 면적은 243km² 이며, 2016년 기준 인구는 약 173 만 명이다. <br><br><div style="width:400px;height:auto;"><a href="photo.jsp"><img src="https://t1.daumcdn.net/cfile/tistory/9914873C5CD84E120C"  width="400px" height="auto"></a></div></div>',
        },
        // 말리
        {
            coords:{lat:12.6392316, lng:-8.0028892},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>말리-바마코</h1>바마코는 말리의 수도이다. 니제르 강과 말리의 남서쪽에 위치한다. 바마코는 행정 중심이자 가까이에 쿨리코로 항구가 위치해있으며 주요한 지역의 무역 중심이다.<br><br><div style="width:400px;height:auto;"><a href="photo.jsp"><img src="https://previews.123rf.com/images/dutourdumonde/dutourdumonde1405/dutourdumonde140500005/28104905-%EB%B0%94%EB%A7%88%EC%BD%94%EC%9D%98%EB%B3%B4%EA%B8%B0-%EB%A7%90%EB%A6%AC%EC%9D%98-%EB%8B%88%EC%A0%9C%EB%A5%B4-%EA%B0%95.jpg"  width="400px" height="auto"></a></div></div>',
        },
        // 멕시코
        {
            coords:{lat:25.6866142, lng:-100.3161126},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>멕시코-몬테레이</h1>몬테레이는 멕시코 동북부 누에보레온주에 있는 도시이다. 누에보레온주의 주도이며, 광역 인구는 약 4,689,601명이다. <br><br><div style="width:400px;height:auto;"><a href="photo.jsp"><img src="http://ojsfile.ohmynews.com/STD_IMG_FILE/2017/0210/IE002108308_STD.JPG"  width="400px" height="auto"></a></div></div>',
        },
        // 모나코
        {
            coords:{lat:43.7308084, lng:7.4225881},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>모나코-모나코빌</h1>모나코빌은 모나코 중부에 위치한 행정구로 면적은 0.19km², 인구는 1,151명이다. 지중해 연안과 접하며 흔히 르로셰라고 부르기도 한다.<br><br><div style="width:400px;height:auto;"><a href="photo.jsp"><img src="https://media.istockphoto.com/photos/cityscape-of-la-condamine-monacoville-monaco-picture-id521530364"  width="400px" height="auto"></a></div></div>',
        },
        // 모로코
        {
            coords:{lat:33.5731104, lng:-7.589843399999999},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>모로코-카사블랑카</h1>카사블랑카는 대서양에 위치한 모로코의 최대 도시이다. 위도는 33°32′N 7°35′W.에 있다. 도시 이름은 스페인어로 "하얀 집"을 뜻한다.<br><br><div style="width:400px;height:auto;"><a href="photo.jsp"><img src="https://youimg1.tripcdn.com/target/10031f000001gs27k71AD_D_1180_558.jpg?proc=source%2Ftrip"  width="400px" height="auto"></a></div></div>',
        },
        // 모리타니
        {
            coords:{lat:18.0735299, lng:-15.9582372},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>모리타니-누악쇼트</h1>누악쇼트는 모리타니의 수도이며 사하라 사막최대의 도시이다. 누악쇼트란 말은 "거센 바람이 부는 곳"이란 뜻이다. 대서양 기슭에 위치해 있으며 인구는 1999년 추계로 881,000명이다. <br><br><div style="width:400px;height:auto;"><a href="photo.jsp"><img src="https://t1.daumcdn.net/cfile/blog/235506465594380D17"  width="400px" height="auto"></a></div></div>',
        },
        // 모잠비크
        {
            coords:{lat:-25.969248, lng:32.5731746},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>모잠비크-마푸투</h1>마푸투는 모잠비크의 수도이다. 포르투갈의 전직 축구 선수 에우제비우가 태어난 곳으로 유명하다. 옛날에는 로렌수마르케스라고 불렀다. 인도양에 위치한 항만이며, 그곳의 경제는 항구에 집중되어 있다. <br><br><div style="width:400px;height:auto;"><a href="photo.jsp"><img src="https://cdn.crowdpic.net/detail-thumb/thumb_d_0250317EB2CE076C3A7E2F3F6D384B46.jpg"  width="400px" height="auto"></a></div></div>',
        },
        // 몬테네그로
        {
            coords:{lat:42.4304196, lng:19.2593642},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>몬테네그로-포드고리차</h1>포드고리차는 몬테네그로의 수도이다. 1326년 이전에는 리브니차, 1945년부터 1991년까지는 요시프 브로즈 티토의 이름을 따서 티토그라드라고 불렀다. 도시의 이름은 세르비아어로 "고리차" 아래라는 뜻이다.<br><br><div style="width:400px;height:auto;"><a href="photo.jsp"><img src="https://eb.findmybucketlist.com/bucket/new/cp/3424425_cp_00.jpg?update_date=2019-10-2516:35:07"  width="400px" height="auto"></a></div></div>',
        },
        // 몰도바
        {
            coords:{lat:47.0104529, lng:28.8638103},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>몰도바-키시나우</h1>키시너우는 몰도바의 수도로 인구는 92만이다. 러시아어 이름인 키시뇨프로 잘 알려져 있다. 드니스테르강의 지류인 브크강가에 자리잡고 있으며 산업과 서비스업의 중심지이다. 기계제조, 식료품, 담배 등의 공업이 있고, 학술·문화의 중심지이다.<br><br><div style="width:400px;height:auto;"><a href="photo.jsp"><img src="https://dynamic-media-cdn.tripadvisor.com/media/photo-o/0a/a6/1a/0a/triumphal-arch.jpg?w=700&h=-1&s=1"  width="400px" height="auto"></a></div></div>',
        },
        // 몰디브
        {
            coords:{lat:3.202778, lng:73.22068},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>몰디브-몰디브</h1>몰디브 공화국, 약칭 몰디브은 남아시아 인도양에 있는 섬나라로, 인도와 스리랑카 남서쪽에 있다. 국토는 남북으로 길게 늘어선 26개의 환초로 이루어져 있으며, 섬의 총수는 1,192개이다. 수도인 말레는 군주제 시절에 술탄이 왕궁을 짓고 다스리던 곳이다.<br><br><div style="width:400px;height:auto;"><a href="photo.jsp"><img src="https://youimg1.tripcdn.com/target/100k1f000001gui9o94D8_C_640_320_R5_Q70.jpg_.webp?proc=source%2Ftrip"  width="400px" height="auto"></a></div></div>',
        },
        // 몰타
        {
            coords:{lat:35.937496, lng:14.375416},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>몰타-몰타</h1>몰타 공화국은 남유럽에 위치한 섬나라로 수도는 발레타이다. 공용어로 몰타어와 영어를 사용하며, 주민의 대다수는 셈어족에 속하는 몰타인이다. <br><br><div style="width:400px;height:auto;"><a href="photo.jsp"><img src="https://t1.daumcdn.net/cfile/tistory/99BA263B5D2CC54F03"  width="400px" height="auto"></a></div></div>',
        },
        // 몽골
        {
            coords:{lat:47.88639879999999, lng:106.9057439},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>몽골-울란바토르</h1>울란바토르는 몽골의 수도이다. 도시 명칭의 뜻은 몽골어로 "붉은 영웅"이란 뜻이다. "울란바토르"라는 표기는 몽골어가 아닌 러시아어의 독법에서 유래했다. 면적은 4,704.4 km², 인구는 137만 2000여 명이다.<br><br><div style="width:400px;height:auto;"><a href="photo.jsp"><img src="http://www.traveldaily.co.kr/news/photo/201901/18598_25400_5915.jpg"  width="400px" height="auto"></a></div></div>',
        },
        // 미국
        {
            coords:{lat:40.7127753, lng:-74.0059728},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>미국-뉴욕</h1>뉴욕은 미합중국의 북동부, 뉴욕주의 남쪽 끝에 있는 도시이다. 또한 미합중국에서 가장 인구가 많은 도시로, 전 세계에서 가장 인구가 많은 도시 중 하나이며, 미합중국의 최대 도시이다.<br><br><div style="width:400px;height:auto;"><a href="photo.jsp"><img src="https://t1.daumcdn.net/cfile/tistory/99A789435A7FD5720B"  width="400px" height="auto"></a></div></div>',
        },
        // 미얀마
        {
            coords:{lat:21.9588282, lng:96.0891032},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>미얀마-만달레이</h1>만달레이는 미얀마 중부의 도시로, 만달레이도의 도청 소재지이다. 미얀마의 마지막 왕조인 꾼바웅 왕조의 수도였던 역사가 있는 미얀마의 전통적인 제2도시이다.<br><br><div style="width:400px;height:auto;"><a href="photo.jsp"><img src="https://t1.daumcdn.net/cfile/tistory/243C7A3C5692F8CE15"  width="400px" height="auto"></a></div></div>',
        },
        // 미크로네시아 연방
        {
            coords:{lat:7.425554, lng:150.550812},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>미크로네시아연방-미크로네시아연방</h1>미크로네시아 연방 또는 미크로네시아는 오세아니아의 미크로네시아 캐롤라인 제도에 있는 국가이다. 북쪽으로는 북마리아나 제도, 동쪽으로는 마셜 제도, 서쪽으로는 팔라우, 그리고 남쪽으로는 파푸아뉴기니가 존재한다.<br><br><div style="width:400px;height:auto;"><a href="photo.jsp"><img src="http://pds.joongang.co.kr/news/component/htmlphoto_mmdata/201203/22/htm_20120322120431075.jpg"  width="400px" height="auto"></a></div></div>',
        },
        // 바누아투
        {
            coords:{lat:-15.376706, lng:166.959158},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>바누아투-바누아투</h1>바누아투 공화국 혹은 바누아투는 오세아니아의 멜라네시아에 있는 국가이다. 공화제를 채택하였으며 수도는 포트빌라이다.<br><br><div style="width:400px;height:auto;"><a href="photo.jsp"><img src="https://t1.daumcdn.net/cfile/tistory/99A224485B40106E36"  width="400px" height="auto"></a></div></div>',
        },
        // 바레인
        {
            coords:{lat:26.2235305, lng:50.5875935},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>바레인-마나마</h1>마나마는 1932년 무하라크에서 바뀌어 바레인의 수도로 지정되었으며 페르시아 만에 위치해 있고, 바레인 섬에서 북동쪽에 있다. 도시의 어원은 "휴식의 장소" 또는 "꿈의 장소"라는 의미의 아랍어에서 유래되었다.<br><br><div style="width:400px;height:auto;"><a href="photo.jsp"><img src="https://dynamic-media-cdn.tripadvisor.com/media/photo-o/15/33/fb/8b/manama.jpg?w=700&h=500&s=1"  width="400px" height="auto"></a></div></div>',
        },
        // 바베이도스
        {
            coords:{lat:13.1059816, lng:-59.61317409999999},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>바베이도스-브리지타운</h1>브리지타운은 바베이도스의 수도이다. 행정 구역상으로는 세인트마이클 교구에 속한다. 1628년에 영국에 의해 건설되어 현재는 관광지의 역할을 주로 하고 있다. 인구는 110,000명이다.<br><br><div style="width:400px;height:auto;"><a href="photo.jsp"><img src="https://i.ytimg.com/vi/x8ZadA-enQU/maxresdefault.jpg"  width="400px" height="auto"></a></div></div>',
        },
        // 바티칸
        {
            coords:{lat:41.902916, lng:12.453389},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>바티칸-바티칸</h1>바티칸 시국은 이탈리아의 로마 시내에 위치하고 있으며, 국경 역할을 하는 장벽으로 둘러싸인 영역으로 이루어져 있는 내륙국이자 도시국가이다.<br><br><div style="width:400px;height:auto;"><a href="photo.jsp"><img src="https://youimg1.tripcdn.com/target/fd/tg/g2/M02/89/4C/CghzgFWwvbmASh1HAD9zaM_TB5c256_C_640_320_R5_Q70.jpg_.webp?proc=source%2Ftrip"  width="400px" height="auto"></a></div></div>',
        },
        // 바하마
        {
            coords:{lat:25.0401387, lng:-77.3512619},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>바하마-나사우</h1>나소는 바하마의 수도이다. 인구는 26만5,924명이다. 바하마의 주요 공항인 린든 핀들링 국제공항이 나소 중심지에서 서쪽으로 16km 떨어진 곳에 위치해 있다.<br><br><div style="width:400px;height:auto;"><a href="photo.jsp"><img src="https://q-xx.bstatic.com/xdata/images/hotel/max700/229533928.jpg?k=8e044fdc92881803a1df2a0a8244deb2053a600000f8f9959252142c315bd891&o="  width="400px" height="auto"></a></div></div>',
        },
        // 방글라데시
        {
            coords:{lat:23.810332, lng:90.4125181},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>방글라데시-다카</h1>다카는 방글라데시의 수도이자, 방글라데시 최대의 도시이다. 2001년 인구는 903만 2268명이고, 방글라데시 중앙부에 위치한다. 방글라데시의 상업·공업의 중심지이고, 황마·면 가공이나 식품 가공 등의 제조업이 발달해 있다. <br><br><div style="width:400px;height:auto;"><a href="photo.jsp"><img src="https://t1.daumcdn.net/cfile/tistory/9967F14E5C8773F407"  width="400px" height="auto"></a></div></div>',
        },
        // 베네수엘라
        {
            coords:{lat:10.642707, lng:-71.6125366},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>베네수엘라-마라카이보</h1>마라카이보는 베네수엘라에서 두 번째로 큰 도시로, 술리아 주의 주도다. 1990년 인구는 265만명이었고 2007년 추정 인구는 320만명이다.<br><br><div style="width:400px;height:auto;"><a href="photo.jsp"><img src="https://post-phinf.pstatic.net/MjAyMDA3MDhfNDAg/MDAxNTk0MTc0MzkzNDYz.iTGA2QbN-MXizkUEzARnjqrbkKYN1Tyxqm_Ap935Dz4g.jeNoHJImBWre_wdRdRkXHlgGb9CeHvYM-g7-WHtYfCog.JPEG/01.jpg?type=w1200"  width="400px" height="auto"></a></div></div>',
        },
        // 베냉
        {
            coords:{lat:6.4968574, lng:2.6288523},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>베냉-포르토노보</h1>포르토노보는 베냉의 헌법상의 수도이다. 베넹 국토의 남동쪽, 기니 만 연안에 위치해 있다. 주요 생산품은 팜유, 면화, 양목면 등이다. 1990년대에 유전이 발견되었으며, 점점 중요한 수출 품목이 되고 있다.<br><br><div style="width:400px;height:auto;"><a href="photo.jsp"><img src="https://eb.findmybucketlist.com/bucket/new/cp/3424690_cp_00.jpg?update_date=2019-08-1921:50:23"  width="400px" height="auto"></a></div></div>',
        },
        // 베트남
        {
            coords:{lat:21.0277644, lng:105.8341598},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>베트남-하노이</h1>하노이는 베트남의 수도다. 역대 왕조가 왕도를 정했던 도시로, 홍강 삼각주, 홍강 오른쪽 편에 위치한다. 베트남 최대의 도시인 호치민에서는 북쪽으로 1,720km, 항구도시 하이퐁에서 서쪽으로 105km 떨어져 있다.<br><br><div style="width:400px;height:auto;"><a href="photo.jsp"><img src="http://image14.hanatour.com/uploads/2019/12/DSC_0455_18164565.jpg"  width="400px" height="auto"></a></div></div>',
        },
        // 벨기에
        {
            coords:{lat:50.8476424, lng:4.3571696},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>벨기에-브뤼셀</h1>브뤼셀 시은 브뤼셀의 행정 구역으로, 벨기에의 법적 수도이다.<br><br><div style="width:400px;height:auto;"><a href="photo.jsp"><img src="https://post-phinf.pstatic.net/MjAxODA1MzFfNjcg/MDAxNTI3NzQzNTg3MTcy.vIQUzkUoy0n_LSv_Tv88I6NAgLoByNWURqVNTeejZHAg.aPuO2eHBF7mzn_9N9LXcjMuvAXL1S2ce1_UPZU_L_70g.JPEG/%EB%B8%8C%EB%A4%BC%EC%85%80_%EC%97%AC%ED%96%89_%EA%B7%B8%EB%9E%91%ED%94%8C%EB%9D%BC%EC%8A%A42.jpg?type=w1200"  width="400px" height="auto"></a></div></div>',
        },
        // 벨라루스
        {
            coords:{lat:53.9006011, lng:27.558972},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>벨라루스-민스크</h1>민스크는 벨라루스의 수도이다. 기계 제조, 모직물 등의 공업도시로 교통의 요지이기도 하다.<br><br><div style="width:400px;height:auto;"><a href="photo.jsp"><img src="https://dynamic-media-cdn.tripadvisor.com/media/photo-o/15/4d/45/97/minsk.jpg?w=700&h=500&s=1"  width="400px" height="auto"></a></div></div>',
        },
        // 벨리즈
        {
            coords:{lat:17.2510114, lng:-88.7590201},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>벨리즈-벨모판</h1>벨모판은 중앙아메리카에 있는 벨리즈의 수도이다. 인구는 약 16,000명이다. 벨리즈 강의 동쪽에 위치하며, 옛 수도 벨리즈시티에서 내륙 쪽으로 80km 정도 떨어진 곳에 있다. 행정 구역상으로는 카요 구에 속한다.<br><br><div style="width:400px;height:auto;"><a href="photo.jsp"><img src="https://dynamic-media-cdn.tripadvisor.com/media/photo-o/05/48/e7/00/blue-hole-national-park.jpg?w=700&h=500&s=1"  width="400px" height="auto"></a></div></div>',
        },
        // 보스니아 헤르체고비나
        {
            coords:{lat:43.8562586, lng:18.4130763},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>보스니아헤르체고비나-사라예보</h1>사라예보는 보스니아 헤르체고비나의 수도이다. 인구는 2013년의 조사에 따르면 약 275,000명이다. 보스나강의 지류인 밀랴츠카강이 시내를 흐른다.<br><br><div style="width:400px;height:auto;"><a href="photo.jsp"><img src="https://dynamic-media-cdn.tripadvisor.com/media/photo-o/21/e8/1c/d8/caption.jpg?w=700&h=-1&s=1"  width="400px" height="auto"></a></div></div>',
        },
        // 보츠와나
        {
            coords:{lat:-24.6282079, lng:25.9231471},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>보츠와나-가보로네</h1>가보로네는 아프리카 남부에 있는 보츠와나의 수도이다. 남아프리카공화국과의 접경 지대로부터 15km 떨어져 있다.<br><br><div style="width:400px;height:auto;"><a href="photo.jsp"><img src="https://mblogthumb-phinf.pstatic.net/MjAxNzEyMzBfMTQ1/MDAxNTE0NjI2MTMzNjQ5.R3m4EhLZGCJFcKlVXBAAkEcsMkmezBrnUku7T9v31aUg.sGo2PAMmYn8BM_gnbA1HGUSkswfRneVtN66xubIbO68g.JPEG.easy_loan/1.jpg?type=w800"  width="400px" height="auto"></a></div></div>',
        },
        // 볼리비아
        {
            coords:{lat:-17.8145819, lng:-63.1560853},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>볼리비아-산타크루즈</h1>산타크루스데라시에라, 약칭 산타크루스는 볼리비아 동부 산타크루스 주에 있는 도시이다. 인구 1,528,683. 볼리비아 국토의 중앙부의 표고 400m 지점, 아마존 강 수계에 속하는 피라이 강 연안에 위치한다.<br><br><div style="width:400px;height:auto;"><a href="photo.jsp"><img src="https://t1.daumcdn.net/thumb/R720x0/?fname=http://t1.daumcdn.net/brunch/service/user/xmW/image/fGclX3P4TFNkiaJjDMQhVBgpGqE.JPG"  width="400px" height="auto"></a></div></div>',
        },
        // 부룬디
        {
            coords:{lat:-3.361378, lng:29.3598782},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>부룬디-부줌부라</h1>부줌부라는 부룬디의 최대 도시로 2014년 인구는 658,859명으로 추산된다. 도시는 탕가니카 호수의 북서쪽 끝단에 위치하며 행정, 통신 및 경제의 중심으로 2019년까지 부룬디의 수도였다.<br><br><div style="width:400px;height:auto;"><a href="photo.jsp"><img src="https://media.istockphoto.com/photos/panoramic-view-of-bujumbura-capital-city-of-burundi-africa-picture-id1222863038"  width="400px" height="auto"></a></div></div>',
        },
        // 부르키나파소
        {
            coords:{lat:11.1649219, lng:-4.3051542},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>부르키나파소-보보디울라소</h1>보보디울라소는 부르키나파소의 도시로, 오트바생 주의 주도이자 우에 현의 현도이다. 부르키나파소에서 2번째로 큰 도시이며 인구는 435,543명, 높이는 해발 445m이다.<br><br><div style="width:400px;height:auto;"><a href="photo.jsp"><img src="https://storage.doopedia.co.kr/upload/_upload/image/1510/30/151030019856562/151030019856562_thumb_400.jpg"  width="400px" height="auto"></a></div></div>',
        },
        // 부탄
        {
            coords:{lat:27.4712216, lng:89.6339041},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>부탄-팀부</h1>팀부는 부탄의 수도이다. 히말라야 산맥에 있는 약 2,400m의 장소에 세워진 도시로, 근래에는 식품 공장이나 제재소도 등장했다. 공항·철도가 없지만 부탄 각지와 인도를 연결하는 도로가 있다.<br><br><div style="width:400px;height:auto;"><a href="photo.jsp"><img src="https://cf.bstatic.com/xdata/images/hotel/max1024x768/17178578.jpg?k=b542a5547511a50aed4e70dc9ce2b713d34213e79b119b2a1f527aeca0da03df&o=&hp=1"  width="400px" height="auto"></a></div></div>',
        },
        // 북한 
        {
            coords:{lat:39.0737987, lng:125.8197642},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>북한-평양</h1>북한의 수도이자 한반도 이북 최대 도시. 북한에선 혁명의 수도라고 부르고 있다.<br><br><div style="width:400px;height:auto;"><a href="photo.jsp"><img src="https://img4.yna.co.kr/photo/yna/YH/2018/12/30/PYH2018123006880034000_P4.jpg"  width="400px" height="auto"></a></div></div>',
        },
        // 북마케도니아 
        {
            coords:{lat:41.9981294, lng:21.4254355},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>북마케도니아-스코페</h1>스코페는 북마케도니아의 수도로 인구는 약 44만 명이다. 바르다르강 연안 스코페 분지에 위치한다. 교통의 요지이며 베오그라드-테살로니키 철도가 통한다. 공업 도시이며, 문화의 중심지이다.<br><br><div style="width:400px;height:auto;"><a href="photo.jsp"><img src="https://mblogthumb-phinf.pstatic.net/MjAxOTA2MTFfMjM4/MDAxNTYwMjY1MTAyMzE4.xZvU4O0FRIBFpXBJImg71-9NgkR6XlHIJh6ObJLBRQAg.pVSxIOzBdep8wM2fUfYz27l5z4PaJoiShF515iXleggg.JPEG.sonantravel/SE-29daae36-64a3-41bc-8404-7821e3fcfe03.jpg?type=w800"  width="400px" height="auto"></a></div></div>',
        },
        // 불가리아
        {
            coords:{lat:42.6977082, lng:23.3218675},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>불가리아-소피아</h1>소피아는 불가리아의 수도이자 최대 도시이다. 유럽에서 가장 오래된 수도의 하나이다. 소피아의 역사는 기원전 8세기에 이곳에 세워진 트라키아인들의 거주지로 거슬러 올라간다. 불가리아 서부 비토샤 산 밑에 자리잡고 있다.<br><br><div style="width:400px;height:auto;"><a href="photo.jsp"><img src="https://dynamic-media-cdn.tripadvisor.com/media/photo-o/15/33/fc/c5/sofia.jpg?w=700&h=500&s=1"  width="400px" height="auto"></a></div></div>',
        },
        // 브라질
        {
            coords:{lat:-23.5557714, lng:-46.6395571},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>브라질-상파울로</h1>상파울루는 브라질 남부 상파울루주의 주도이다. 브라질에서 가장 인구가 많은 도시이다. 면적은 1,523.0 km², 인구는 1,233만명이다. 브라질 최대의 도시이며, 브라질 뿐 아니라 남아메리카와 남반구 전체에서 가장 큰 세계적인 도시이다.<br><br><div style="width:400px;height:auto;"><a href="photo.jsp"><img src="https://cdn.cctoday.co.kr/news/photo/200601/125495-1-42089.jpg"  width="400px" height="auto"></a></div></div>',
        },
        // 브루나이
        {
            coords:{lat:4.535277, lng:114.727669},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>브루나이-반다르세리베가완</h1>반다르스리브가완은 브루나이의 수도로, 브루나이 최대의 도시이다. 아시아에서 가장 큰 모스크가 있다. 인구는 140,000명이며 면적은 100.36km²이다. 도시 이름은 "존경하는 통치자의 항구"를 뜻한다.<br><br><div style="width:400px;height:auto;"><a href="photo.jsp"><img src="https://youimg1.tripcdn.com/target/100m0p000000frtpu7715_C_640_320_R5_Q70.jpg_.webp?proc=source%2Ftrip"  width="400px" height="auto"></a></div></div>',
        },
        // 산마리노
        {
            coords:{lat:43.94236, lng:12.457777},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>산마리노-산마리노</h1>가장 고귀한 공화국 산마리노 공화국, 영어: The noblest Republic of San Marino, 약칭 산마리노는 전면이 이탈리아에 둘러싸인 내륙국가이다. <br><br><div style="width:400px;height:auto;"><a href="photo.jsp"><img src="https://mblogthumb-phinf.pstatic.net/20110513_10/cityhuntorr_1305258743440yS7sP_JPEG/%BB%EA%B8%B6%B8%AE%B3%EB_%BC%BA3%B0%B3%B3%AA%BF%C2%B1%D7%B8%B2.jpg?type=w2"  width="400px" height="auto"></a></div></div>',
        },
        // 사모아
        {
            coords:{lat:-13.7591099, lng:-172.1046293},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>사모아-사모아</h1>사모아 독립국은 오세아니아의 폴리네시아 사모아 제도에 있는 나라이며, 수도는 아피아이다. 동쪽에 접하는 미국령 사모아와 구별하기 위하여 서사모아라고도 부른다.<br><br><div style="width:400px;height:auto;"><a href="photo.jsp"><img src="https://cdn.travie.com/news/photo/201908/21093_4953_3351.jpg"  width="400px" height="auto"></a></div></div>',
        },
        // 사우디아라비아
        {
            coords:{lat:24.7135517, lng:46.6752957},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>사우디아라비아-리야드</h1>리야드는 사우디아라비아의 수도이다. 또한 리야드는 사우디아라비아에서 최대 도시이며, 리야드의 인구는 2016년 기준으로 6,506,700 명으로, 아랍권에서 사람이 가장 많이 살고 있는 도시 가운데 한 곳이다.<br><br><div style="width:400px;height:auto;"><a href="photo.jsp"><img src="https://dynamic-media-cdn.tripadvisor.com/media/photo-o/12/3b/1c/75/kingdom-centre-tower.jpg?w=300&h=300&s=1"  width="400px" height="auto"></a></div></div>',
        },
        // 상투메 프린시페 
        {
            coords:{lat:0.18636, lng:6.613080999999999},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>상투메프린시페-상투메프린시페</h1>상투메는 서아프리카 기니 만에 있는 상투메 프린시페의 수도이자 상투메 프린시페의 최대 도시이다. 도시가 위치한 상투메 섬은 화산섬이며 최고점은 2,205m이다.<br><br><div style="width:400px;height:auto;"><a href="photo.jsp"><img src="https://eb.findmybucketlist.com/bucket/new/cp/3424601_cp_00.jpg?update_date=2019-10-2516:32:05"  width="400px" height="auto"></a></div></div>',
        },
        // 세네갈
        {
            coords:{lat:14.7910052, lng:-16.9358604},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>세네갈-티에스</h1>티에스는 세네갈 서부에 위치한 도시로, 티에스 주의 주도이며 세네갈에서 두 번째로 큰 도시이다. 인구는 237,849명이다.<br><br><div style="width:400px;height:auto;"><a href="photo.jsp"><img src="https://storage.doopedia.co.kr/upload/_upload/image5/2208/01/220801024389062/220801024389062_thumb_400.jpg"  width="400px" height="auto"></a></div></div>',
        },
        // 세르비아
        {
            coords:{lat:44.8125449, lng:19.8227056},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>세르비아-베오그라드</h1>베오그라드는 세르비아의 수도이자, 발칸반도의 주요 도시 중 하나이다. 베오그라드는 ‘하얀 도시’라는 뜻이다. 1918년부터 2002년까지는 유고슬라비아의 수도였으며, 그 후 2005년까지는 세르비아 몬테네그로 연방의 수도였다.<br><br><div style="width:400px;height:auto;"><a href="photo.jsp"><img src="http://www.outdoornews.co.kr/news/photo/201611/23026_71909_441.JPG"  width="400px" height="auto"></a></div></div>',
        },
        // 세이셸
        {
            coords:{lat:-4.679574, lng:55.491977},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>세이셸-세이셸</h1>세이셸 공화국은 아프리카 동부, 인도양에 위치하여 있는 섬 나라이다. 아프리카 대륙에서 약 1,600km 떨어져 있다. 수도는 빅토리아이다. 아프리카에서는 유일하게 인도식 화폐인 루피를 쓴다.<br><br><div style="width:400px;height:auto;"><a href="photo.jsp"><img src="https://cdn.travie.com/news/photo/first/201712/img_20042_2.jpg"  width="400px" height="auto"></a></div></div>',
        },
        // 세인트루시아
        {
            coords:{lat:13.909444, lng:-60.978893},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>세인트루시아-세인트루시아</h1>세인트루시아는 중앙아메리카 카리브 해 소앤틸리스 제도에 있는 섬나라이다. 국어는 영어를 사용하며, 수도는 캐스트리스이다.<br><br><div style="width:400px;height:auto;"><a href="photo.jsp"><img src="https://theplanetsworld.com/wp-content3_1/14-top-rated-tourist-attractions-in-st-lucia-2.jpg"  width="400px" height="auto"></a></div></div>',
        },
        // 세인트빈센트 그레나딘
        {
            coords:{lat:12.984305, lng:-61.287228},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>세인트빈센트그레나딘-세인트빈센트그레나딘</h1>세인트빈센트 그레나딘은 카리브 해에 있는 섬나라이다. 동카리브해의 소앤틸리스 제도 남방에 떠 있는 약 600여 개의 섬으로, 이 중 세인트빈센트 섬이 중심이다.<br><br><div style="width:400px;height:auto;"><a href="photo.jsp"><img src="https://dynamic-media-cdn.tripadvisor.com/media/photo-o/15/4d/43/96/st-vincent-and-the-grenadines.jpg?w=700&h=500&s=1"  width="400px" height="auto"></a></div></div>',
        },
        // 세인트키츠 네비스
        {
            coords:{lat:17.357822, lng:-62.782998},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>세인트키츠네비스-세인트키츠네비스</h1>세인트키츠 네비스 연방 또는 줄여서 세인트키츠 네비스는 1983년 영국으로부터 독립한 섬나라이며 수도는 바스테르이다.<br><br><div style="width:400px;height:auto;"><a href="photo.jsp"><img src="https://mblogthumb-phinf.pstatic.net/MjAxOTA0MTZfMjIz/MDAxNTU1Mzc5ODg5ODE0.ktpLP0KeaqNb_NOHlo-gAnO3e2Tu_cZYGLX5sn5FFpQg.Ie_r0V7BBjB2zrDRsuR7N0326piwhlAILmrLYVZxdYcg.JPEG.glomad/%EC%84%B8%EC%9D%B8%ED%8A%B8%ED%82%A4%EC%B8%A0%EB%84%A4%EB%B9%84%EC%8A%A42.jpg?type=w800"  width="400px" height="auto"></a></div></div>',
        },
        // 소말리아
        {
            coords:{lat:2.0469343, lng:45.3181623},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>소말리아-모가디슈</h1>모가디슈는 소말리아의 수도이다. 2009년 당시 인구는 1,300,000여 명이다. 인도양 해안의 베나디르 지역에 위치한 도시는 수세기 동안 중요한 지역의 항구로서 역할을 해 왔다.<br><br><div style="width:400px;height:auto;"><a href="photo.jsp"><img src="https://pds.joongang.co.kr/news/component/htmlphoto_mmdata/202107/28/aa4712b8-7fa3-4d09-830c-af821adefd12.jpg"  width="400px" height="auto"></a></div></div>',
        },
        // 솔로몬 제도
        {
            coords:{lat:-9.64571, lng:160.156194},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>솔로몬제도-솔로몬제도</h1>솔로몬 제도는 오세아니아의 멜라네시아에 위치한 국가이자 영연방 국가이다. <br><br><div style="width:400px;height:auto;"><a href="photo.jsp"><img src="http://img.khan.co.kr/news/2019/09/03/l_2019090301000487000038451.jpg"  width="400px" height="auto"></a></div></div>',
        },
        // 수단
        {
            coords:{lat:15.5006544, lng:32.5598994},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>수단-카르툼</h1>하르툼은 북아프리카에 속하는 나라인 수단의 수도로, 카르툼이라고도 일컫는다.<br><br><div style="width:400px;height:auto;"><a href="photo.jsp"><img src="https://mblogthumb-phinf.pstatic.net/MjAxODEyMTNfMTMx/MDAxNTQ0NjQ3Mzk5NjYw.hP5aFGDLvolCe48SFg1ks7DJmwSzh8WR6kiAwH9XiHIg.r3GcX9lTWDewC1pVmmpc6CPmWBCFKE-missyxnpWxfQg.JPEG.hansu0922/%EC%95%84%ED%94%84%EB%A6%AC%EC%B9%B4_%EC%88%98%EB%8B%A8_%EC%B9%B4%EB%A5%B4%ED%88%BC%EC%9C%BC%EB%A1%9C20151103-173238-015%EC%84%B8%EA%B3%84%EC%97%AC%ED%96%89.jpg?type=w800"  width="400px" height="auto"></a></div></div>',
        },
        // 수리남
        {
            coords:{lat:5.8520355, lng:-55.2038278},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>수리남-파라마리보</h1>파라마리보는 수리남의 수도이다. 인구는 222,843명이고 대서양으로부터 약 15km의 지점에 위치한다. 교외에서는 보크사이트, 사탕수수, 벼, 카카오, 커피가 생산되어서 수출하고 있다. 시가에서는 시멘트, 럼주를 제조하고 있다.<br><br><div style="width:400px;height:auto;"><a href="photo.jsp"><img src="https://image.shutterstock.com/image-photo/synagogue-neve-shalom-mosque-keizerstraat-260nw-1050684365.jpg"  width="400px" height="auto"></a></div></div>',
        },
        // 스리랑카
        {
            coords:{lat:6.9270786, lng:79.861243},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>스리랑카-콜롬보</h1>콜롬보는 스리랑카의 최대 도시이자 경제 수도이다. 명칭의 유래는 싱할라어로 망고 나무가 무성한 해안을 의미하는 Kola-amba-thota에서 유래되었다.<br><br><div style="width:400px;height:auto;"><a href="photo.jsp"><img src="https://www.cathaypacific.com/content/dam/destinations/colombo/cityguide-gallery/colombo_skyline_920x500.jpg"  width="400px" height="auto"></a></div></div>',
        },
        // 스웨덴 
        {
            coords:{lat:59.32932349999999, lng:18.0685808},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>스웨덴-스톡홀름</h1>스톡홀름은 스웨덴의 수도이자 스칸디나비아반도 최대 도시이다. 많은 섬을 끼고 있어 "북방의 베네치아"라고도 불린다. 회토리예트에 위치한 콘서트홀에서는 매년 노벨상 시상식이 열리며, 1912년에는 하계 올림픽 대회를 개최하였고, 1958년에는 FIFA 월드컵 결승전이 열린 곳이다.<br><br><div style="width:400px;height:auto;"><a href="photo.jsp"><img src="https://dynamic-media-cdn.tripadvisor.com/media/photo-o/15/33/f9/5e/stockholm.jpg?w=700&h=500&s=1"  width="400px" height="auto"></a></div></div>',
        },
        // 스위스
        {
            coords:{lat:46.9479739, lng:7.4474468},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>스위스-베른</h1>베른은 스위스의 연방시이며 사실상 수도이다. 2020년 기준으로 인구 약 14만 4000명으로, 베른은 스위스에서 다섯 번째로 인구가 많은 도시이다.<br><br><div style="width:400px;height:auto;"><a href="photo.jsp"><img src="http://www.travelnbike.com/news/photo/201808/63363_102853_168.jpg"  width="400px" height="auto"></a></div></div>',
        },
        // 스페인
        {
            coords:{lat:40.4167754, lng:-3.7037902},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:auto;width:400px;"><h1>스페인-마드리드</h1>마드리드는 스페인의 수도로, 나라의 중앙부에 있다. 인구는 약 300만 명 이다. 마드리드는 만사나레스강을 끼고 있으며 스페인의 중심에 위치한다. 마드리드가 쏟아내는 경제적 효과로 인해 주변 도시들이 크게 영향을 받는다.<br><br><div style="width:400px;height:auto;"><a href="photo.jsp"><img src="https://storage.googleapis.com/cbmpress/uploads/sites/3/2018/02/travle_mar_main.jpg"  width="400px" height="auto"></a></div></div>',
        },
        // 슬로바키아
        {
            coords:{lat:48.7163857, lng:21.2610746},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:300px;width:400px;"><h1>슬로바키아-코시체</h1>'+'<br>' + '<h3>Learn More</h3>' + '<a>https://www.visitwexford.ie/</a>'
        },
        // 슬로베니아
        {
            coords:{lat:46.0569465, lng:14.5057515},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:300px;width:400px;"><h1>슬로베니아-류블랴나</h1>'+'<br>' + '<h3>Learn More</h3>' + '<a>https://www.visitwexford.ie/</a>'
        },
        // 시리아 
        {
            coords:{lat:33.5138073, lng:36.2765279},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:300px;width:400px;"><h1>시리아-다마스커스</h1>'+'<br>' + '<h3>Learn More</h3>' + '<a>https://www.visitwexford.ie/</a>'
        },
        // 시에라리온
        {
            coords:{lat:8.4656765, lng:-13.2317225},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:300px;width:400px;"><h1>시에라리온-프리타운</h1>'+'<br>' + '<h3>Learn More</h3>' + '<a>https://www.visitwexford.ie/</a>'
        },
        // 싱가포르  
        {
            coords:{lat:1.352083, lng:103.819836},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:300px;width:400px;"><h1>싱가포르-싱가포르</h1>'+'<br>' + '<h3>Learn More</h3>' + '<a>https://www.visitwexford.ie/</a>'
        },
        // 아랍에미리트
        {
            coords:{lat:24.453884, lng:54.3773438},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:300px;width:400px;"><h1>아랍에미리트-아부다비</h1>'+'<br>' + '<h3>Learn More</h3>' + '<a>https://www.visitwexford.ie/</a>'
        },
        // 아르메니아
        {
            coords:{lat:40.1872023, lng:44.515209},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:300px;width:400px;"><h1>아르메니아-예레반</h1>'+'<br>' + '<h3>Learn More</h3>' + '<a>https://www.visitwexford.ie/</a>'
        },
        // 아르헨티나
        {
            coords:{lat:-34.6036844, lng:-58.3815591},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:300px;width:400px;"><h1>아르헨티나-부에노스아이레스</h1>'+'<br>' + '<h3>Learn More</h3>' + '<a>https://www.visitwexford.ie/</a>'
        },
        // 아이슬란드
        {
            coords:{lat:64.146582, lng:-21.9426354},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:300px;width:400px;"><h1>아이슬란드-레이캬비크</h1>'+'<br>' + '<h3>Learn More</h3>' + '<a>https://www.visitwexford.ie/</a>'
        },
        // 아이티
        {
            coords:{lat:18.594395, lng:-72.3074326},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:300px;width:400px;"><h1>아이티-포르토프랭스</h1>'+'<br>' + '<h3>Learn More</h3>' + '<a>https://www.visitwexford.ie/</a>'
        },
        // 아일랜드
        {
            coords:{lat:53.3498053, lng:-6.2603097},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:300px;width:400px;"><h1>아일랜드-더블린</h1>'+'<br>' + '<h3>Learn More</h3>' + '<a>https://www.visitwexford.ie/</a>'
        },
        // 아제르바이잔
        {
            coords:{lat:40.40926169999999, lng:49.8670924},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:300px;width:400px;"><h1>아제르바이잔-바쿠</h1>'+'<br>' + '<h3>Learn More</h3>' + '<a>https://www.visitwexford.ie/</a>'
        },
        // 아프가니스탄
        {
            coords:{lat:34.5553494, lng:69.207486},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:300px;width:400px;"><h1>아프가니스탄-카불</h1>'+'<br>' + '<h3>Learn More</h3>' + '<a>https://www.visitwexford.ie/</a>'
        },
        // 안도라
        {
            coords:{lat:42.506285, lng:1.521801},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:300px;width:400px;"><h1>안도라-안도라</h1>'+'<br>' + '<h3>Learn More</h3>' + '<a>https://www.visitwexford.ie/</a>'
        },
        // 알바니아
        {
            coords:{lat:41.3275459, lng:19.8186982},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:300px;width:400px;"><h1>알바니아-티라나</h1>'+'<br>' + '<h3>Learn More</h3>' + '<a>https://www.visitwexford.ie/</a>'
        },
        // 알제리
        {
            coords:{lat:36.753768, lng:3.0587561},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:300px;width:400px;"><h1>알제리-알제</h1>'+'<br>' + '<h3>Learn More</h3>' + '<a>https://www.visitwexford.ie/</a>'
        },
        // 앙골라
        {
            coords:{lat:-8.8146556, lng:13.2301756},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:300px;width:400px;"><h1>앙골라-루안다</h1>'+'<br>' + '<h3>Learn More</h3>' + '<a>https://www.visitwexford.ie/</a>'
        },
        // 에스와티니
        {
            coords:{lat:-26.3054482, lng:31.1366715},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:300px;width:400px;"><h1>에스와티니-음바바네</h1>'+'<br>' + '<h3>Learn More</h3>' + '<a>https://www.visitwexford.ie/</a>'
        },
        // 에콰도르
        {
            coords:{lat:-0.1806532, lng:-78.4678382},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:300px;width:400px;"><h1>에콰도르-키토</h1>'+'<br>' + '<h3>Learn More</h3>' + '<a>https://www.visitwexford.ie/</a>'
        },
        // 에리트레아
        {
            coords:{lat:15.3228767, lng:38.9250517},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:300px;width:400px;"><h1>에리트레아-아스마라</h1>'+'<br>' + '<h3>Learn More</h3>' + '<a>https://www.visitwexford.ie/</a>'
        },
        // 에스토니아
        {
            coords:{lat:59.43696079999999, lng:24.7535746},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:300px;width:400px;"><h1>에스토니아-탈린</h1>'+'<br>' + '<h3>Learn More</h3>' + '<a>https://www.visitwexford.ie/</a>'
        },
        // 에티오피아
        {
            coords:{lat:8.9806034, lng:38.7577605},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:300px;width:400px;"><h1>에티오피아-아디스아바바</h1>'+'<br>' + '<h3>Learn More</h3>' + '<a>https://www.visitwexford.ie/</a>'
        },
        // 영국
        {
            coords:{lat:51.5072178, lng:-0.1275862},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:300px;width:400px;"><h1>영국-런던</h1>'+'<br>' + '<h3>Learn More</h3>' + '<a>https://www.visitwexford.ie/</a>'
        },
        // 예멘
        {
            coords:{lat:15.3694451, lng:44.1910066},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:300px;width:400px;"><h1>예멘-사나</h1>'+'<br>' + '<h3>Learn More</h3>' + '<a>https://www.visitwexford.ie/</a>'
        },
        // 오만
        {
            coords:{lat:23.5880307, lng:58.3828717},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:300px;width:400px;"><h1>오만-무스카트</h1>'+'<br>' + '<h3>Learn More</h3>' + '<a>https://www.visitwexford.ie/</a>'
        },
        // 오스트레일리아
        {
            coords:{lat:-34.9284989, lng:138.6007456},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:300px;width:400px;"><h1>오스트레일리아-애들레이드</h1>'+'<br>' + '<h3>Learn More</h3>' + '<a>https://www.visitwexford.ie/</a>'
        },
        // 오스트리아
        {
            coords:{lat:48.2081743, lng:16.3738189},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:300px;width:400px;"><h1>오스트리아-빈</h1>'+'<br>' + '<h3>Learn More</h3>' + '<a>https://www.visitwexford.ie/</a>'
        },
        // 온두라스
        {
            coords:{lat:14.065049, lng:-87.1715002},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:300px;width:400px;"><h1>온두라스-테구시갈파</h1>'+'<br>' + '<h3>Learn More</h3>' + '<a>https://www.visitwexford.ie/</a>'
        },
        // 요르단
        {
            coords:{lat:31.9539494, lng:35.910635},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:300px;width:400px;"><h1>요르단-암만주</h1>'+'<br>' + '<h3>Learn More</h3>' + '<a>https://www.visitwexford.ie/</a>'
        },
        // 우간다
        {
            coords:{lat:0.3475964, lng:32.5825197},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:300px;width:400px;"><h1>우간다-캄팔라</h1>'+'<br>' + '<h3>Learn More</h3>' + '<a>https://www.visitwexford.ie/</a>'
        },
        // 우루과이 
        {
            coords:{lat:-34.9011127, lng:-56.16453139999999},
            iconImage:'assets/img/places/wexford.png',
            content:'<div style="height:300px;width:400px;"><h1>우루과이-몬테비데오</h1>'+'<br>' + '<h3>Learn More</h3>' + '<a>https://www.visitwexford.ie/</a>'
        },
        // 우즈베키스탄
        {
            coords:{lat:41.2994958, lng:69.2400734},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:300px;width:400px;"><h1>우즈베키스탄-타슈켄트</h1>'+'<br>' + '<h3>Learn More</h3>' + '<a>https://www.visitwexford.ie/</a>'
        },
        // 우크라이나
        {
            coords:{lat:50.4501, lng:30.5234},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:300px;width:400px;"><h1>우크라이나-키이우</h1>'+'<br>' + '<h3>Learn More</h3>' + '<a>https://www.visitwexford.ie/</a>'
        },
        // 이라크
        {
            coords:{lat:33.315241, lng:44.3660671},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:300px;width:400px;"><h1>이라크-바그다드</h1>'+'<br>' + '<h3>Learn More</h3>' + '<a>https://www.visitwexford.ie/</a>'
        },
        // 이란
        {
            coords:{lat:35.7218583, lng:51.3346954},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:300px;width:400px;"><h1>이란-테헤란</h1>'+'<br>' + '<h3>Learn More</h3>' + '<a>https://www.visitwexford.ie/</a>'
        },
        // 이스라엘
        {
            coords:{lat:31.768319, lng:35.21371},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:300px;width:400px;"><h1>이스라엘-예루살렘</h1>'+'<br>' + '<h3>Learn More</h3>' + '<a>https://www.visitwexford.ie/</a>'
        },
        // 이집트
        {
            coords:{lat:30.0444196, lng:31.2357116},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:300px;width:400px;"><h1>이집트-카이로</h1>'+'<br>' + '<h3>Learn More</h3>' + '<a>https://www.visitwexford.ie/</a>'
        },
        // 이탈리아
        {
            coords:{lat:45.4642035, lng:9.189982},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:300px;width:400px;"><h1>이탈리아-밀라노</h1>'+'<br>' + '<h3>Learn More</h3>' + '<a>https://www.visitwexford.ie/</a>'
        },
        // 인도
        {
            coords:{lat:28.6139391, lng:77.2090212},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:300px;width:400px;"><h1>인도-뉴델리</h1>'+'<br>' + '<h3>Learn More</h3>' + '<a>https://www.visitwexford.ie/</a>'
        },
        // 인도네시아
        {
            coords:{lat:3.5951956, lng:98.6722227},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:300px;width:400px;"><h1>인도네시아-메단</h1>'+'<br>' + '<h3>Learn More</h3>' + '<a>https://www.visitwexford.ie/</a>'
        },
        // 일본
        {
            coords:{lat:35.6761919, lng:139.6503106},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:300px;width:400px;"><h1>일본-도쿄</h1>'+'<br>' + '<h3>Learn More</h3>' + '<a>https://www.visitwexford.ie/</a>'
        },
        // 자메이카
        {
            coords:{lat:18.0178743, lng:-76.8099041},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:300px;width:400px;"><h1>자메이카-킹스톤</h1>'+'<br>' + '<h3>Learn More</h3>' + '<a>https://www.visitwexford.ie/</a>'
        },
        // 잠비아
        {
            coords:{lat:-15.3875259, lng:28.3228165},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:300px;width:400px;"><h1>잠비아-루사카</h1>'+'<br>' + '<h3>Learn More</h3>' + '<a>https://www.visitwexford.ie/</a>'
        },
        // 적도기니
        {
            coords:{lat:1.5890407, lng:10.8225732},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:300px;width:400px;"><h1>적도기니-시우다드데라파스</h1>'+'<br>' + '<h3>Learn More</h3>' + '<a>https://www.visitwexford.ie/</a>'
        },
        // 중앙아프리카공화국
        {
            coords:{lat:4.3946735, lng:18.5581899},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:300px;width:400px;"><h1>중앙아프리카공화국-방기</h1>'+'<br>' + '<h3>Learn More</h3>' + '<a>https://www.visitwexford.ie/</a>'
        },
        // 중국
        {
            coords:{lat:39.904211, lng:116.407395},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:300px;width:400px;"><h1>중국-베이징</h1>'+'<br>' + '<h3>Learn More</h3>' + '<a>https://www.visitwexford.ie/</a>'
        },
        // 지부티
        {
            coords:{lat:11.825138, lng:42.590275},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:300px;width:400px;"><h1>지부티-지부티</h1>'+'<br>' + '<h3>Learn More</h3>' + '<a>https://www.visitwexford.ie/</a>'
        },
        // 짐바브웨
        {
            coords:{lat:-17.8216288, lng:31.0492259},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:300px;width:400px;"><h1>짐바브웨-하라레</h1>'+'<br>' + '<h3>Learn More</h3>' + '<a>https://www.visitwexford.ie/</a>'
        },
        // 차드
        {
            coords:{lat:12.1348457, lng:15.0557415},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:300px;width:400px;"><h1>차드-은자메나</h1>'+'<br>' + '<h3>Learn More</h3>' + '<a>https://www.visitwexford.ie/</a>'
        },
        // 체코
        {
            coords:{lat:50.0755381, lng:14.4378005},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:300px;width:400px;"><h1>체코-프라하</h1>'+'<br>' + '<h3>Learn More</h3>' + '<a>https://www.visitwexford.ie/</a>'
        },
        // 칠레
        {
            coords:{lat:-33.4488897, lng:-70.6692655},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:300px;width:400px;"><h1>칠레-산티아고</h1>'+'<br>' + '<h3>Learn More</h3>' + '<a>https://www.visitwexford.ie/</a>'
        },
        // 카메룬
        {
            coords:{lat:3.8480325, lng:11.5020752},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:300px;width:400px;"><h1>카메룬-야운데</h1>'+'<br>' + '<h3>Learn More</h3>' + '<a>https://www.visitwexford.ie/</a>'
        },
        // 카자흐스탄
        {
            coords:{lat:51.16052269999999, lng:71.4703558},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:300px;width:400px;"><h1>카자흐스탄-누르술탄</h1>'+'<br>' + '<h3>Learn More</h3>' + '<a>https://www.visitwexford.ie/</a>'
        },
        // 카보베르데
        {
            coords:{lat:14.93305, lng:-23.5133267},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:300px;width:400px;"><h1>카보베르데-프라이아</h1>'+'<br>' + '<h3>Learn More</h3>' + '<a>https://www.visitwexford.ie/</a>'
        },
        // 카타르
        {
            coords:{lat:25.2854473, lng:51.53103979999999},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:300px;width:400px;"><h1>카타르-도하</h1>'+'<br>' + '<h3>Learn More</h3>' + '<a>https://www.visitwexford.ie/</a>'
        },
        // 캄보디아 
        {
            coords:{lat:11.5563738, lng:104.9282099},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:300px;width:400px;"><h1>캄보디아-프놈펜</h1>'+'<br>' + '<h3>Learn More</h3>' + '<a>https://www.visitwexford.ie/</a>'
        },
        // 캐나다
        {
            coords:{lat:49.2827291, lng:-123.1207375},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:300px;width:400px;"><h1>캐나다-밴쿠버</h1>'+'<br>' + '<h3>Learn More</h3>' + '<a>https://www.visitwexford.ie/</a>'
        },
        // 케냐
        {
            coords:{lat:-1.2920659, lng:36.8219462},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:300px;width:400px;"><h1>케냐-나이로비</h1>'+'<br>' + '<h3>Learn More</h3>' + '<a>https://www.visitwexford.ie/</a>'
        },
        // 코모로
        {
            coords:{lat:-11.6455, lng:43.3333},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:300px;width:400px;"><h1>코모로-코모로</h1>'+'<br>' + '<h3>Learn More</h3>' + '<a>https://www.visitwexford.ie/</a>'
        },
        // 코스타리카
        {
            coords:{lat:9.9280694, lng:-84.0907246},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:300px;width:400px;"><h1>코스타리카-산호세</h1>'+'<br>' + '<h3>Learn More</h3>' + '<a>https://www.visitwexford.ie/</a>'
        },
        // 코트디부아르
        {
            coords:{lat:6.827622799999999, lng:-5.2893433},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:300px;width:400px;"><h1>코트디부아르-야무수크로</h1>'+'<br>' + '<h3>Learn More</h3>' + '<a>https://www.visitwexford.ie/</a>'
        },
        // 쿠바
        {
            coords:{lat:23.1135925, lng:-82.3665956},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:300px;width:400px;"><h1>쿠바-하바나</h1>'+'<br>' + '<h3>Learn More</h3>' + '<a>https://www.visitwexford.ie/</a>'
        },
        // 쿠웨이트
        {
            coords:{lat:29.375859, lng:47.9774052},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:300px;width:400px;"><h1>쿠웨이트-쿠웨이트시티</h1>'+'<br>' + '<h3>Learn More</h3>' + '<a>https://www.visitwexford.ie/</a>'
        },
        // 콜롬비아
        {
            coords:{lat:4.710988599999999, lng:-74.072092},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:300px;width:400px;"><h1>콜롬비아-보고타</h1>'+'<br>' + '<h3>Learn More</h3>' + '<a>https://www.visitwexford.ie/</a>'
        },
        // 콩고공화국
        {
            coords:{lat:-4.2633597, lng:15.2428853},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:300px;width:400px;"><h1>콩고공화국-브라자빌</h1>'+'<br>' + '<h3>Learn More</h3>' + '<a>https://www.visitwexford.ie/</a>'
        },
        // 콩고민주공화국 
        {
            coords:{lat:-4.4419311, lng:15.2662931},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:300px;width:400px;"><h1>콩고민주공화국-킨샤샤</h1>'+'<br>' + '<h3>Learn More</h3>' + '<a>https://www.visitwexford.ie/</a>'
        },
        // 크로아티아
        {
            coords:{lat:44.8666232, lng:13.8495788},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:300px;width:400px;"><h1>크로아티아-풀라</h1>'+'<br>' + '<h3>Learn More</h3>' + '<a>https://www.visitwexford.ie/</a>'
        },
        // 키르기스스탄
        {
            coords:{lat:42.8746212, lng:74.5697617},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:300px;width:400px;"><h1>키르기스스탄-비슈케크</h1>'+'<br>' + '<h3>Learn More</h3>' + '<a>https://www.visitwexford.ie/</a>'
        },
        // 키리바시
        {
            coords:{lat:-3.370417, lng:-168.734039},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:300px;width:400px;"><h1>키리바시-키리바시</h1>'+'<br>' + '<h3>Learn More</h3>' + '<a>https://www.visitwexford.ie/</a>'
        },
        // 키프로스
        {
            coords:{lat:35.1855659, lng:33.38227639999999},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:300px;width:400px;"><h1>키프로스-니코시아</h1>'+'<br>' + '<h3>Learn More</h3>' + '<a>https://www.visitwexford.ie/</a>'
        },
        // 타지키스탄
        {
            coords:{lat:38.5597722, lng:68.7870384},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:300px;width:400px;"><h1>타지키스탄-두샨베</h1>'+'<br>' + '<h3>Learn More</h3>' + '<a>https://www.visitwexford.ie/</a>'
        },
        // 탄자니아
        {
            coords:{lat:-6.162959000000001, lng:35.7516069},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:300px;width:400px;"><h1>탄자니아-도도마</h1>'+'<br>' + '<h3>Learn More</h3>' + '<a>https://www.visitwexford.ie/</a>'
        },
        // 태국
        {
            coords:{lat:13.7563309, lng:100.5017651},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:300px;width:400px;"><h1>태국-방콕</h1>'+'<br>' + '<h3>Learn More</h3>' + '<a>https://www.visitwexford.ie/</a>'
        },
        // 토고
        {
            coords:{lat:10.8733058, lng:0.2010233},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:300px;width:400px;"><h1>토고-다파옹</h1>'+'<br>' + '<h3>Learn More</h3>' + '<a>https://www.visitwexford.ie/</a>'
        },
        // 통가
        {
            coords:{lat:-21.178986, lng:-175.198242},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:300px;width:400px;"><h1>통가-통가</h1>'+'<br>' + '<h3>Learn More</h3>' + '<a>https://www.visitwexford.ie/</a>'
        },
        // 투르크메니스탄
        {
            coords:{lat:41.8368737, lng:59.9651904},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:300px;width:400px;"><h1>투르크메니스탄-다쇼구즈</h1>'+'<br>' + '<h3>Learn More</h3>' + '<a>https://www.visitwexford.ie/</a>'
        },
        // 투발루
        {
            coords:{lat:-7.109534999999999, lng:177.64933},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:300px;width:400px;"><h1>투발루-투발루</h1>'+'<br>' + '<h3>Learn More</h3>' + '<a>https://www.visitwexford.ie/</a>'
        },
        // 튀니지
        {
            coords:{lat:36.8064948, lng:10.1815316},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:300px;width:400px;"><h1>튀니지-튀니스</h1>'+'<br>' + '<h3>Learn More</h3>' + '<a>https://www.visitwexford.ie/</a>'
        },
        // 터키
        {
            coords:{lat:41.0082376, lng:28.9783589},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:300px;width:400px;"><h1>터키-이스탄불</h1>'+'<br>' + '<h3>Learn More</h3>' + '<a>https://www.visitwexford.ie/</a>'
        },
        // 트리니다드토바고
        {
            coords:{lat:10.691803, lng:-61.222503},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:300px;width:400px;"><h1>트리니다드토바고-트리니다드토바고</h1>'+'<br>' + '<h3>Learn More</h3>' + '<a>https://www.visitwexford.ie/</a>'
        },
        // 파나마
        {
            coords:{lat:8.0759622, lng:-80.9688946},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:300px;width:400px;"><h1>파나마-산티아고</h1>'+'<br>' + '<h3>Learn More</h3>' + '<a>https://www.visitwexford.ie/</a>'
        },
        // 파라과이
        {
            coords:{lat:-25.2637399, lng:-57.57592599999999},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:300px;width:400px;"><h1>파라과이-아순시온</h1>'+'<br>' + '<h3>Learn More</h3>' + '<a>https://www.visitwexford.ie/</a>'
        },
        // 파키스탄
        {
            coords:{lat:33.6844202, lng:73.04788479999999},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:300px;width:400px;"><h1>파키스탄-이슬라마바드</h1>'+'<br>' + '<h3>Learn More</h3>' + '<a>https://www.visitwexford.ie/</a>'
        },
        // 파피아뉴기니
        {
            coords:{lat:-9.443800399999999, lng:147.1802671},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:300px;width:400px;"><h1>파피아뉴기니-포트모르즈비</h1>'+'<br>' + '<h3>Learn More</h3>' + '<a>https://www.visitwexford.ie/</a>'
        },
        // 팔라우
        {
            coords:{lat:7.514979999999999, lng:134.58252},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:300px;width:400px;"><h1>팔라우-팔라우</h1>'+'<br>' + '<h3>Learn More</h3>' + '<a>https://www.visitwexford.ie/</a>'
        },
        // 페루
        {
            coords:{lat:-8.106042799999999, lng:-79.0329727},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:300px;width:400px;"><h1>페루-트루히요</h1>'+'<br>' + '<h3>Learn More</h3>' + '<a>https://www.visitwexford.ie/</a>'
        },
        // 포르투갈
        {
            coords:{lat:38.7222524, lng:-9.1393366},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:300px;width:400px;"><h1>포르투갈-리스본</h1>'+'<br>' + '<h3>Learn More</h3>' + '<a>https://www.visitwexford.ie/</a>'
        },
        // 폴란드
        {
            coords:{lat:52.2296756, lng:21.0122287},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:300px;width:400px;"><h1>폴란드-바르샤바</h1>'+'<br>' + '<h3>Learn More</h3>' + '<a>https://www.visitwexford.ie/</a>'
        },
        // 프랑스
        {
            coords:{lat:48.856614, lng:2.3522219},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:auto;width:400px;"><h1>프랑스-파리</h1>프랑스의 수도이자 가장 인구가 많은 도시로 프랑스 북부 일드프랑스 지방의 중앙에 있다. 센강 중류에 있으며, 행정 구역은 1~20구로 나뉘어 있다. 센강을 기준으로 우안과 좌안으로 나뉜다. 17세기 이후 파리는 유럽의 금융, 외교, 상업, 패션, 과학, 예술 중심지다. 생활비가 싱가포르에 이어 세계에서 두 번째로 비싼 도시다. 샤를르 드골 공항과 오를리 공항이 있고, 유럽의 주요 철도, 고속도로, 항공 교통의 허브이며, 루브르 등 관광명소가 많아 관광의 중심지이기도 하다.<br><br><div style="width:400px;height:auto;"><a href="photo.jsp"><img src="https://search.pstatic.net/common/?src=http%3A%2F%2Fblogfiles.naver.net%2FMjAyMjA4MjZfMjAx%2FMDAxNjYxNDY3OTgzMjA2.qgQlgQZEvQ2LisBbVaDMcEJ9YZ37c9wRLHd5SUUP5Dkg.SqLDiIlYT7CubjzV-GDpNJKhl7HoIXnZXcEZ38d-pBcg.JPEG.juja0150%2F20220714_121425.jpg&type=a340"  width="400px" height="auto"></a></div></div>',
        },
        // 피지
        {
            coords:{lat:-17.713371, lng:178.065032},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:auto;width:400px;"><h1>피지-피지</h1>1643년 네덜란드인 탐험가 타스만(Abel Janszoon Tasman)에 의하여 발견된 피지는 유럽인의 정착이 이루어진 후에도 19세기 중엽 여러 추장들의 패권 다툼으로 내전이 벌어졌다. 당시 이 곳에 와 있던 미국인들은 중립을 지켰지만 생명과 재산을 잃게 되자  피지왕(王)으로 자처하고 있던 자콘바우에게 4만 5000달러의 배상금을 요구하였다. 지불능력이 없었던 자콘바우는 영국에서 돈을 빌리는 대가로 20만 에이커의 토지를 할양하였으며 이것을 계기로 1874년 영국은 섬 전체를 식민지로 삼았다.<br><br><div style="width:400px;height:auto;"><a href="photo.jsp"><img src="https://search.pstatic.net/common/?src=http%3A%2F%2Fimgnews.naver.net%2Fimage%2F5192%2F2020%2F09%2F09%2F0000057932_002_20200909075820813.jpg&type=a340"  width="400px" height="auto"></a></div></div>',
        },
        // 핀란드
        {
            coords:{lat:65.0120888, lng:25.4650773},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:auto;width:400px;"><h1>핀란드-오울루</h1>오울루는 핀란드 북부의 북(北)포흐얀마(Pohjois-Pohjanmaa)주에 속한 도시다. 핀란드 북부에서 가장 인구가 많은 도시로, 핀란드 전체적으론 5위다. 오울루는 주민들이 지역사회 차원에서 실시되는 NFC태그나 유비쿼터스 스크린 같은 신기술 실험에 적극적으로 참여해서 유럽의 살아있는 실험실 중 하나로 불린다.<br><br><div style="width:400px;height:auto;"><a href="photo.jsp"><img src="https://dthumb-phinf.pstatic.net/?src=%22https%3A%2F%2Fdbscthumb-phinf.pstatic.net%2F5854_000_1%2F20200314002004242_1W3SBERDI.png%2FOulu_02.png%3Ftype%3Dw690_fst%26wm%3DN%22&twidth=690&theight=461&opts=17"  width="400px" height="auto"></a></div></div>',
        },
        // 필리핀
        {
            coords:{lat:14.5995124, lng:120.9842195},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:auto;width:400px;"><h1>필리핀-마닐라</h1>마닐라는 필리핀의 수도로 스페인 점령기의 문화가 남아 있으며 상업과 금융이 발달해 있다.<br><br><div style="width:400px;height:auto;"><a href="photo.jsp"><img src="https://search.pstatic.net/common/?src=https%3A%2F%2Fdbscthumb-phinf.pstatic.net%2F2765_000_37%2F20181006040832933_B3F0QRGF6.jpg%2F1456442.jpg%3Ftype%3Dm4500_4500_fst&type=a340"  width="400px" height="auto"></a></div></div>',
        },
        // 대한민국
        {
            coords:{lat:37.566535, lng:126.9779692},
            iconImage:'planner_ico_paging_selected.png',
            content:'<div style="height:auto;width:400px;"><h1>대한민국-서울</h1>대한민국의 수도인 서울을 지방자치단체인 특별시로 부르는 명칭이다. 한반도 중앙에 있으며, 한강을 사이에 두고 남북으로 펼쳐져 있다. 북쪽 끝은 도봉구 도봉동, 동쪽 끝은 강동구 상일동, 남쪽 끝은 서초구 원지동, 서쪽 끝은 강서구 오곡동이다. 시청은 중구 을지로1가(태평로1가 31)에 있다.<br><br><div style="width:400px;height:auto;"><a href="photo.jsp"><img src="https://search.pstatic.net/sunny/?src=https%3A%2F%2Fthumb2.gettyimageskorea.com%2Fimage_preview%2F700%2F201711%2FMBRF%2FMBRF17020404.jpg&type=a340"  width="400px" height="auto"></a></div></div>',
        },  
      ];
	
      // Loop through markers
      var gmarkers = [];
      for(var i = 0; i < markers.length; i++){
        gmarkers.push(addMarker(markers[i]));
      }
      
      function addMarker(props){				// 설정한 마커의 데이터로 날씨데이터(getWeather)와 마커(addPoint)를 생성한다.
            getWeather(props);
          	addPoint(props);
      }
     
      var markerCluster = new MarkerClusterer(map, gmarkers, 
      	{
        	imagePath:'https://developers.google.com/maps/documentation/javascript/examples/markerclusterer/m',
        	gridSize:100,
        	minClusterSize:10,
      	});
    }
    
  google.maps.event.addDomListener(window, 'load', initMap);


  function getWeather(props) {
	  var apikey = "3522c50ccbe794a9c2124c10ff6be15a";		// apikey를 따로 지정한 이유는 openweather api key의 하루 호출량이 매우 적어서 금방 Many request라는 오류가 뜨기 때문이다
	  if(error != null){
		  apikey = "3f3a8b2eb571d6f73b36b644d29fb1c5";
		  if(error != null){
			  apikey = "ffd6b15e1b0c3e510959f139f64214ce";
		  }
	  }
	  // openWeather api를 가져와서 마커의 데이터에 있는 좌표값으로 해당 위치에 날씨 데이터를 받아온다, fetch함수로 받아온 JSON 형태의 데이터
	    fetch('https://api.openweathermap.org/data/2.5/weather?lat=' + props.coords['lat'] + '&lon=' + props.coords['lng'] + '&units=metric&appid='+ apikey)
	        .then((response) => {
	                return response.json();
	        })
	        .then((myJson) => {
	        		console.log(myJson);
	        		weather[0] = (myJson.name).toString();						// 해당좌표의 위치 이름 예) 서울, 파리 등등
	        		weather[1] = (myJson.main.temp).toString();					// 해당좌표의 현재온도
	        		weather[2] = (myJson.main.temp_max).toString();				// 해당좌표의 하루중 최고온도 
	        		weather[3] = (myJson.main.temp_min).toString();				// 해당좌표의 하루중 최저온도
	        		weather[4] = (myJson.main.humidity).toString();				// 해당좌표의 현재습도
	        		weather[5] = (myJson.wind.speed).toString();				// 해당좌표의 현재풍속
	        		weather[6] = (myJson.weather[0].main).toString();			// 해당좌표의 현재 날씨	예)구름,비,눈 등등
	        		weather[7] = (myJson.weather[0].description).toString();	// 해당좌표의 현재 자세한 날씨 예)구름이 많다,눈과 비가 같이 온다 등등
	        		       		
	        		myJson = (myJson.weather[0].id).toString();					// 해당좌표의 현재 날씨 ID값
	        	      		
	                addPoint(props, myJson, weather);							// 설정한 해당좌표 데이터와 마커데이터를 기반으로 마커 설정
	        }).catch((err) => {
	                console.log("Error: " + err);
	                error = err;
	                return error;
	        });
	}

	function addPoint(props, myJson, weather) {									// 설정한 해당좌표 데이터와 마커데이터를 기반으로 마커 설정
		var iconurl = null;
		if(myJson != null){
			if(myJson.charAt(0) == "2"){										// 해당좌표의 현재 날씨 ID값 앞자리가 2이면
				iconurl="http://openweathermap.org/img/wn/11d@2x.png";
			}else if(myJson.charAt(0) == "3"){									// 해당좌표의 현재 날씨 ID값 앞자리가 3이면
				iconurl="http://openweathermap.org/img/wn/09d@2x.png";
			}else if(myJson.charAt(0) == "5"){									// 해당좌표의 현재 날씨 ID값 앞자리가 5이면
				iconurl="http://openweathermap.org/img/wn/09d@2x.png";
			}else if(myJson.charAt(0) == "6"){									// 해당좌표의 현재 날씨 ID값 앞자리가 6이면
				iconurl="http://openweathermap.org/img/wn/13d@2x.png";
			}else if(myJson.charAt(0) == "7"){									// 해당좌표의 현재 날씨 ID값 앞자리가 7이면
				iconurl="http://openweathermap.org/img/wn/50d@2x.png";
			}else if(myJson.indexOf('80') == 0){								// 해당좌표의 현재 날씨 ID값 앞자리가 80이면
				iconurl="http://openweathermap.org/img/wn/01d@2x.png";
				if(myJson != "800"){											// 해당좌표의 현재 날씨 ID값 앞자리가 80이지만 ID값이 800이 아니면
					iconurl="http://openweathermap.org/img/wn/03d@2x.png";					
				}
			}
		}
		const weathericon = {													// 해당좌표의 ID값으로 설정한 url기반으로 마커 이미지 설정
			url: iconurl,
			scaledSize: new google.maps.Size(40, 40),
		}
	    var marker = new google.maps.Marker({									// 마커 생성
	        position: props.coords,												// 마커의 좌표값은 마커의 데이터 기반
	        map: map,
	    	icon:weathericon													// 해당좌표의 ID값으로 설정한 url기반으로 마커 이미지 설정 
	    });
		
	    var info = new Array();													// getWeather에서 가져온 데이터값을 배열로 다시 설정
	   	if(weather != null){
	   		info.push(weather);
		    console.log("해당도시의 날씨 데이터: " + info[0]);												// getWeather에서 가져온 데이터값
		    // 마커의 정보창에 넣기위해 데이터 정렬및 정보창 폼 설정
		    info = "<div style='width:200px;height:auto;'><h1>"+ info[0][0]+"</h1><br>현재날씨: "+info[0][6]+"<br>현재날씨설명: "+info[0][7]+"<br><br>현재온도: "+info[0][1]+"℃<br>최고온도: "+info[0][2]+"℃<br>최저온도: "+info[0][3]+"℃<br>현재 습도: "+info[0][4]+"%<br>현재 풍속: "+info[0][5]+"m/s<br></div>";
	   	}    
	    
	    var infoWindow = new google.maps.InfoWindow({			// 마커의 정보창 초기화
        	content: info
	    });
	    marker.addListener('click', function () {				// 마커클릭시 이벤트, 정보창이 열린다
            infoWindow.open(map, marker);
        });
		
		markers.push(marker);									// 마커를 배열안에 넣는다
		
		
		for(var i=0;i<markers.length;i++){						
			if (myJson == null && typeof myJson == "undefined") {

	            markers[i].setMap(null);
	            markers.splice(i, 1);
	        }
			
		}
	   	   
	}
</script>

</body>
</html>