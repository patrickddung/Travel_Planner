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
    </div>
    <script src="https://maps.googleapis.com/maps/api/js?key=AIzaSyDjtW34Ax16khc7UYth6--V4pNFX1XlHUE&libraries=places">
    </script>
    <script type="text/javascript">
        alert("가고싶은 나라를 클릭하세요");

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

        var activeInfoWindow = null;

        var stockholm = {
            lat: 45,
            lng: 10
        }; // 맵 중앙 설정

        function initMap() {
            // 지도의 옵션
            var options = {
                zoom: 4,
                center: stockholm,
                streetViewControl: true,
                draggable: true,
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

            map = new google.maps.Map(document.getElementById('map'), options); // 지도 영역 설정 div id = map

            google.maps.event.addListener(map, 'click', function (event) { // 클릭시 마커 설정 

                addPoint(event.latLng);

            });
        }

        var i = 1; // 가상의 숫자 설정 = 마커를 한개 이상 찍지 못하도록 막기 위해
        function addPoint(latlng) {
            var addMarker; // 마커의 변수 설정
            var iMax = 1; // 가상의 숫자 설정 = 마커를 한개 이상 찍지 못하도록 막기 위해ㅍ


            if (i <= iMax) {
                addMarker = new google.maps.Marker({
                    draggable: false,
                    position: latlng,
                    map: map
                });

                latlnglatlng = JSON.stringify(latlng.toJSON()); // 클릭한 곳에 좌표값을 JSON으로 변환
                coordsnation = JSON.parse(latlnglatlng); // JSON 값을 다시 Object로 변환
                console.log("클릭한 곳에 좌표값: " + Object.values(coordsnation)); // Object의 값을 체크
                console.log("클릭한 곳에 좌표값의 타입: " + typeof (coordsnation.lat));
                latlng2 = coordsnation.lat.toFixed(4); // 클릭한 좌표값을 경도 위도로 나눈다(DB에 넣을것이기때문에 소수점 4자리까지만 설정)
                latlng3 = coordsnation.lng.toFixed(4);

                latlng1.push(latlng2); // 좌표값을 다시 배열로 합친다
                latlng1.push(latlng3);

                console.log("클릭한 곳에 위도: " + latlng1[0]); // 좌표값이 제대로 들어갔는지 체크
                console.log("클릭한 곳에 값이 제대로 배열에 들어갔는지 체크: " + latlng1);

                localStorage.setItem("custom좌표", latlng1); // 좌표값을 다음페이지에서 쓸 수 있도록 localStorage값 설정

                var poznamka1 = null; // 회원가입할때 들어갈 닉네임 변수 설정
                while (poznamka1 == null || poznamka1 == "") { // 닉네임에 null값이 없도록 한다
                    poznamka1 = prompt("별명은 무엇입니까?");
                }

                data1.push(poznamka1); // 닉네임 값을 배열에 넣는다
                localStorage.setItem("customnote1", data1); // 닉네임 값을 다음페이지에서 쓸 수 있도록 localStorage값 설정

                var poznamka = null; // 회원가입할때 들어갈 자기소개 변수 설정
                while (poznamka == null || poznamka == "") { // 자기소개에 null값이 없도록 한다
                    poznamka = prompt("자기소개 해주세요");
                }

                data.push(poznamka); // 자기소개 값을 배열에 넣는다
                localStorage.setItem("customnote", data); // 자기소개 값을 다음페이지에서 쓸 수 있도록 localStorage값 설정

                if (i == 1) {
                    var clear = confirm("여기로 하실껍니까?"); // 아까 설정한 가상의 i 값으로 회원가입 할지 말지 체크
                    if (clear == true) {
                        location.href = '../join.do'; // 만약 물음에 값이 true라면 회원가입창으로 이동
                    }else {
                    	alert("마커를 더블클릭하면 마커를 다시 재설정 하실수 있습니다."); // false라면 다시 설정할수 있도록 한다	
                	}
                    
                }

                google.maps.event.addListener(addMarker, 'dblclick',function () { // 더블클릭시 마커 삭제, 지도에 마커가 1개만 설정할수 있기 때문이다.
                    latlnglatlng_del = JSON.stringify(latlng.toJSON()); // 클릭한 곳에 좌표값을 JSON으로 변환
                    coordsnation_del = JSON.parse(latlnglatlng_del); // JSON 값을 다시 Object로 변환
                    console.log("삭제한 곳에 좌표값: " + Object.values(coordsnation_del)); // Object의 값을 체크
                    console.log("삭제한 곳에 좌표값의 타입: " + typeof (coordsnation_del.lat));
                    latlng2_del = coordsnation_del.lat.toFixed(4); // 클릭한 좌표값을 경도 위도로 나눈다(DB에 넣을것이기때문에 소수점 4자리까지만 설정)
                    latlng3_del = coordsnation_del.lng.toFixed(4);

                    for (let i = 0; i < latlng1.length; i++) { // 클릭한 좌표값이 아까 설정한 배열에 들어 있다면 제거
                        if (latlng1[i] === latlng2_del) {
                            latlng1.splice(i, 1);
                            data.splice(i, 1);
                        }
                    }
                    for (let i = 0; i < latlng1.length; i++) { // 클릭한 좌표값이  아까 설정한 배열에 들어 있다면 제거
                        if (latlng1[i] === latlng3_del) {
                            latlng1.splice(i, 1);
                            data1.splice(i, 1);
                        }
                    }

                    localStorage.setItem("custom좌표", latlng1); //  localStorage값 초기화
                    localStorage.setItem("customnote", data);
                    localStorage.setItem("customnote1", data1);

                    addMarker.setMap(null); // 지도에서도 마커를 없앤다
                    i = 1;
                });

                i++;

            } else {
                alert('마커는 하나만 찍어주세요'); // 만약 마커를 한개 이상 찍는다면 경고창을 띄우고 못찍게 한다
            }

        }

        google.maps.event.addDomListener(window, 'load', initMap);
    </script>
</body>

</html>