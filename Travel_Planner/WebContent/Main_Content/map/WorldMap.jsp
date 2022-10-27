<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>세계_지도</title>
<style>
html, body {
  height: 100%;
}

body {
  background-color: #f0f0f0;
  display: flex;
  align-items: center;
  justify-content: center;
}

.map-container {
  padding: 3.2rem 0.8rem;
  position: relative;
  display: inline-block;
}
.map-container img {
  width: 100%;
}
.map-container .point {
  cursor: pointer;
  position: absolute;
  width: 1.6rem;
  height: 1.6rem;
  background-color: #00acc1;
  border-radius: 50%;
  transition: all 0.3s ease;
  will-change: transform, box-shadow;
  transform: translate(-50%, -50%);
  box-shadow: 0 0 0 rgba(0, 172, 193, 0.4);
  animation: pulse 3s infinite;
}
.map-container .point:hover {
  animation: none;
  transform: translate(-50%, -50%) scale3D(1.35, 1.35, 1);
  box-shadow: 0 3px 6px rgba(0, 0, 0, 0.16), 0 3px 6px rgba(0, 0, 0, 0.23);
}


.map-container .africa {
  top: 50%;
  left: 50%;
}
.map-container .europe {
  top: 30%;
  left: 55%;
}
.map-container .northamerica {
  top: 33%;
  left: 13%;
}
.map-container .southamerica {
  top: 65%;
  left: 25%;
}
.map-container .asia {
  top: 45%;
  left: 80%;
}

@keyframes pulse {
  0% {
    box-shadow: 0 0 0 0 rgba(0, 172, 193, 0.5);
  }
  70% {
    box-shadow: 0 0 0 25px rgba(0, 172, 193, 0);
  }
  100% {
    box-shadow: 0 0 0 0 rgba(0, 172, 193, 0);
  }
}
</style>
<script src="jquery-3.6.1.min.js"></script>
</head>
<body>
<script>
$(document).ready(function(){
    tippy('.tippy', {
      theme: 'light',
      size: 'big',
      arrow: true
    })
});
</script>
<div class="container">
  <div class="map-container">
    <img src="http://res.cloudinary.com/slzr/image/upload/v1500321012/world-map-1500_vvekl5.png">
    <a id="country" onclick="africa()"><div class="point africa tippy" title="Africa"></div></a>
    <a id="country" onclick="europe()"><div class="point europe tippy" title="Europe"></div></a>
    <a id="country" onclick="northamerica()"><div class="point northamerica tippy" title="NorthAmerica"></div></a>
    <a id="country" onclick="southamerica()"><div class="point southamerica tippy" title="SouthAmerica"></div></a>
    <a id="country" onclick="asia()"><div class="point asia tippy" title="Asia"></div></a>
  </div>
</div>
<script>
// 어느 대륙으로 여행을 하는지 판별하기위해 localStorage 값을 줌
function africa(){									
	localStorage.clear();
	localStorage.setItem("country","아프리카");
	location.href="Main_Content/map/App_Africa.jsp";
}

function asia(){
	localStorage.clear();
	localStorage.setItem("country","아시아");
	location.href="Main_Content/map/App_Asia.jsp";
}

function europe(){
	localStorage.clear();
	localStorage.setItem("country","유럽");
	location.href="Main_Content/map/App_Europe.jsp";
}

function southamerica(){
	localStorage.clear();
	localStorage.setItem("country","남아메리카");
	location.href="Main_Content/map/App_SouthAmerica.jsp";
}

function northamerica(){
	localStorage.clear();
	localStorage.setItem("country","북아메리카");
	location.href="Main_Content/map/App_NorthAmerica.jsp";
}

</script>



</body>
</html>