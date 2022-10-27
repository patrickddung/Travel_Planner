<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
  <head>
  	<meta charset="UTF-8">
    <title>채팅</title>
    <script src="https://polyfill.io/v3/polyfill.min.js?features=default"></script>
    
    <style>
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
	#map {
  	flex-basis: 0;
  	flex-grow: 4;
  	height: 100%;
	}
	
	/*===========================================================================================*/

	/*Optional: Makes the sample page fill the window. */

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
	}

	#sidebar {
  	/*flex-basis: 18rem;
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

<!-- <input id="pac-input" class="controls" type="text" placeholder="Search Box"/> -->
<div id="container">
	<div id="map"></div>
	<div id="sidebar">
		<%@ include file="../../chat/chat.jsp" %>	
		
	</div>
	<div class="action" onclick="actionToggle();">	
  		<span>+</span>
  		<ul>
    		<!-- <li><img src="https://www.flaticon.com/svg/static/icons/svg/2111/2111392.svg" alt="" width="25px">Share on Facebook</li> -->
    		<li><img src="https://www.flaticon.com/svg/static/icons/svg/2111/2111392.svg" alt="" width="25px"><a onclick="closeNav()">사이드바 닫기</a></li>
    		<li><img src="https://www.flaticon.com/svg/static/icons/svg/2111/2111765.svg" alt="" width="25px"><a onclick="openNav()">사이드바 열기</a></li>
    		<!-- <li><img src="https://www.flaticon.com/svg/static/icons/svg/1384/1384031.svg" alt="" width="25px"><a href="마지막googlemap최종전단계(9월30일)note_animation실행.jsp">경로설정</a></li>
   			<li><img src="https://www.flaticon.com/svg/static/icons/svg/2111/2111341.svg" alt="" width="25px">사진</li>
   			<li><img src="https://www.flaticon.com/svg/static/icons/svg/1384/1384030.svg" alt="" width="25px">홈으로</li> -->
  		</ul>
	</div>
</div>
<script src="https://maps.googleapis.com/maps/api/js?key=AIzaSyDjtW34Ax16khc7UYth6--V4pNFX1XlHUE&libraries=places"></script>
<script src="https://developers.google.com/maps/documentation/javascript/examples/markerclusterer/markerclusterer.js"></script>
<script type="text/javascript">
function chunk(arr, size) {
	var i, j, temparray = [], chunk = size;
	for (i = 0, j = arr.length; i < j; i += chunk) {
    	temparray.push(arr.slice(i, i + chunk));
	}
	return temparray
}

var value= new Array();

<c:forEach var="member" items="${memberList}" varStatus="status">
    value.push("${member.name}"); 
    value.push("${member.nickname}"); 
    value.push("${member.introduce}"); 
    value.push("${member.userlatlng}"); 
</c:forEach>
   
console.log(value);
console.log(value.length);
console.log(value.length/4);

value = chunk(value, 4);
console.log(value);


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


var latlng1 = new Array();
console.log(latlng1);

var latlng2 = new Array;
var lineCoordinates = [];
var sang = [];

for(var i=0;i<value.length;i++){
	latlng1.push(value[i][3]);
}
console.log(latlng1);

for(var i=0;i<latlng1.length;i++){
	latlng2.push(latlng1[i].split(','));
}

console.log(latlng2);

/* latlng2.forEach((value, index) => {
	  console.log(latlng2.slice(index,index+1));
	  sang[index] = parseFloat(latlng2.slice(index));       	     	  
});
console.log(sang);
lineCoordinates = chunk(sang,2); */

//var note = document.getElementById('nickname').value;
//console.log(note);

//var note1 = document.getElementById('introduce').value;
//console.log(note1);

var data = new Array;
var data1 = new Array;

//data = note.split(',');   
console.log(data);
//data1 = note1.split(',');
console.log(data1); 

const sidebar = document.getElementById("sidebar"); 		// sidebar
var activeInfoWindow = null; 

var stockholm = {lat:45,lng:10}; 		// 맵 중앙 설정



function initMap(){	
    // map options
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
    	// Map 호출 ======================================================================
	    map = new google.maps.Map(document.getElementById('map'),options);  	
    
    	var infowindow = new google.maps.InfoWindow();
    
    	var marker,i;
    	
    	var locations = new Array();
    	
    	for (i = 0; i < value.length; i++) {  
        	marker = new google.maps.Marker({
          		position: new google.maps.LatLng(latlng2[i][0], latlng2[i][1]),
          		map: map,
          		label:value[i][1]
          		
        		});
        		google.maps.event.addListener(marker, 'click', (function(marker, i) {
            		return function() {
              			infowindow.setContent(value[i][2]); infowindow.open(map, marker);
            		}
          		})(marker, i));
        		infowindow = new google.maps.InfoWindow({ content: value[i][2], maxWidth: 300 });
        	    infowindow.open(map, marker);
     		
    	} 
    	 
      	
      /* 	// searchbox===================
      	const input = document.getElementById("pac-input");
      	const searchBox = new google.maps.places.SearchBox(input);
      	map.controls[google.maps.ControlPosition.TOP_LEFT].push(input);
      	let markers1 = [];
      	// Listen for the event fired when the user selects a prediction and retrieve
      	// more details for that place.
      	searchBox.addListener("places_changed", () => {
          	const places = searchBox.getPlaces();
          	if (places.length == 0) {
              	return;
          	}
          	// Clear out the old markers.
          	markers1.forEach((marker) => {
              	marker.setMap(null);
          	});
          	markers1 = [];
          	// For each place, get the icon, name and location.
          	const bounds = new google.maps.LatLngBounds();
          	places.forEach((place) => {
              	if (!place.geometry || !place.geometry.location) {
                  	console.log("Returned place contains no geometry");
                  	return;
              	}
            	const icon = {
            		url: place.icon,
                  	size: new google.maps.Size(71, 71),
                  	origin: new google.maps.Point(0, 0),
                  	anchor: new google.maps.Point(17, 34),
                  	scaledSize: new google.maps.Size(25, 25),
            	};
            	// Create a marker for each place.
            	markers1.push(new google.maps.Marker({
            		map,
                	icon,
                	title: place.name,
                	position: place.geometry.location,
            	}));
            	if (place.geometry.viewport) {
            		bounds.union(place.geometry.viewport);
            	}else {
            		bounds.extend(place.geometry.location);
            	}
            
        	});
        	map.fitBounds(bounds);
    	}); */
      	
      	
   
	
}    


google.maps.event.addDomListener(window, 'load', initMap);
</script>

</body>
<script>
function actionToggle() {
	  const action = document.querySelector('.action');
	  action.classList.toggle('active')
}
/* Set the width of the sidebar to 250px and the left margin of the page content to 250px */
function openNav() {
  document.getElementById("sidebar").style.width = "427px";
  document.getElementById("sidebar").style.padding = "1rem";  
  document.getElementById("container").style.marginright = "427px";
}

/* Set the width of the sidebar to 0 and the left margin of the page content to 0 */
function closeNav() {
  document.getElementById("sidebar").style.width = "0";
  document.getElementById("sidebar").style.padding = "0";
  document.getElementById("container").style.marginright = "0";
}
</script>
</html>