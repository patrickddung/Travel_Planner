<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>사진</title>
<style>
*,
*::before,
*::after {
  box-sizing: border-box;
  padding: 0;
  margin: 0;
}

html,
body {
  height: 100%;
}

#app {
  display: flex;
  height: 100%;
  padding:50px;
}

.album {
  margin: auto;
  display: flex;
  flex-wrap: wrap;
  list-style: none;
  justify-content: center;
  gap: 10px;
  width: 90%;
  max-width: 1800px;
}

.album-item {
  flex: 1 1 20%;
}

.album-item img {
  width: 80%;
  cursor: pointer;
  border: 1px solid black;
  box-shadow: 1px 3px 8px rgba(0,0,0,0.5);
}

.img_popup {
  position: fixed;
  top: 0;
  bottom: 0;
  left: 0;
  right: 0;
  backdrop-filter: blur(10px);
  background-color: rgba(0, 0, 0, 0.5);
  display: flex;
  cursor: pointer;
}

.img_popup .content {
  margin: auto;
  width: 900px;
  height: auto;
  max-width: 1800px;
  display: flex;
  cursor: default;
  position: relative;
  border-radius: 10px;
  overflow: hidden;
  border:5px solid white;
  box-shadow: 1px 3px 8px rgba(0,0,0,0.5);
}

.img_popup .content img {
  width: 70%;
}

.img_popup .content .text {
  position: absolute;
  right: 0;
  width: 30%;
  height: 100%;
  padding: 10px;
  background-color: white;
  overflow-y: auto;
}

button {
  padding: 10px;
  background: transparent;
  border: none;
  font-size: 100px;
  color: white;
  cursor: pointer;
  transition: 0.3s ease;
}

button:hover {
  background-color: rgba(0, 0, 0, 0.5);
}

</style>
</head>
<body>
<img-popup v-if="index !== -1" :photos="photos" :index="index" @close="index=-1"></img-popup>
  
  
<div id="app">
  <div class="album">
    <album-item v-for="(photo,i) in photos" :key="i" :package="photo" @click="index = i"></album-item>
  </div>
  <img-popup v-if="index !== -1" :photos="photos" :index="index" @close="index=-1">
  </img-popup>
</div>
<script src="https://cdnjs.cloudflare.com/ajax/libs/vue/3.2.30/vue.global.min.js"></script>
<script>
function chunk(arr, size) {							// 배열을 내가 설정한 값으로 나눌 수 있도록 정의한 함수 
	var i, j, temparray = [], chunk = size;
    for (i = 0, j = arr.length; i < j; i += chunk) {
    	temparray.push(arr.slice(i, i + chunk));
    }
    return temparray
}

var photoname = new Array();				// DB에서 사진이름을 가져올 변수 설정
var photopictureurl = new Array();			// DB에서 사진경로을 가져올 변수 설정
var photodescription = new Array();			// DB에서 사진설명을 가져올 변수 설정
var photouserid = new Array();				// DB에서 사진작성자을 가져올 변수 설정
var photocode = new Array();				// DB에서 사진번호을 가져올 변수 설정
var photomessage1 = new Array();			// DB에서 사진메세지을 가져올 변수 설정

<c:forEach var="product" items="${productList}">		// c:forEach문으로 DB에서 정보를 가져온다
	console.log("사진이름: " + "${product.name}");
	console.log("사진경로: " + "${product.pictureurl}");
	console.log("사진설명: " + "${product.description}");
	console.log("사진작성자: " + "${product.userid}");
	console.log("사진번호: " + "${product.code}");
	console.log("사진메세지: " + "${product.message}");
	
	photoname.push("${product.name}");								// DB에서 사진이름을 가져와서 배열에 추가
	photopictureurl.push("upload/"+"${product.pictureurl}");		// DB에서 사진경로을 가져와서 배열에 추가
	photodescription.push("${product.description}");				// DB에서 사진경로을 가져와서 배열에 추가
	photouserid.push("${product.userid}");							// DB에서 사진작성자을 가져와서 배열에 추가
	photocode.push("${product.code}");								// DB에서 사진번호을 가져와서 배열에 추가
	photomessage1.push("${product.message}");						// DB에서 사진메세지을 가져와서 배열에 추가
</c:forEach>
console.log("사진이름: " + photoname);					// 배열에 잘 추가 됬는지 확인
console.log("사진경로: " + photopictureurl);
console.log("사진설명: " + photodescription);
console.log("사진작성자: " + photouserid);
console.log("사진번호: " + photocode);
console.log("사진메세지:");
console.log(photomessage1);

	
// 지금 접속한 사람의 아이디를 가져온다
console.log("지금 접속한 사람의 아이디: " + "<%= (String) session.getAttribute("id") %>");		

var Myname = "<%= (String) session.getAttribute("id") %>";
var Mynamelength = Myname.length;
console.log("지금 접속한 사람의 아이디길이: " + Mynamelength);


var photomessage = new Array();				// 사진메세지를 가져와서 다시 추가할 배열
for(var i=0;i<photomessage1.length;i++){
	photomessage[i] = photomessage1[i].split('`!@#$');	// 사진메세지를 구분자로 나누고 위에 배열에 추가
}
console.log("구분자로 구분한 메세지: ");		// 사진메세지를 구분자로 나누고 위에 배열에 잘 추가되어있는지 확인
console.log(photomessage);


for(var i=0;i<photomessage.length;i++){					// DB에 메세지컬럼에 있는 "null" 값 제거
	 photomessage[i].splice(0, 1);
}
console.log("null값제거한 사진메세지: " + photomessage);					// "null"값이 잘 제거 되었는지 확인

for(var i=0;i<photomessage.length;i++){					// 지금 접속자와 사진작성자가 같은지 확인하기 위한 for문
	
	for(var j=0;j<photomessage[i].length;j++){
		
		// if문을 통해서 만약 지금 접속자와 사진메세지 작성자가 같다면 자기가 쓴 메세지를 지울수 있는 버튼 생성
		<%-- if(photomessage[i][j].indexOf("<%= (String) session.getAttribute("id") %>")!=-1){ --%>
		if(photomessage[i][j].slice(0,Mynamelength) == Myname){
			
			photomessage[i][j] = "<div id='usermessage"+[j]+"' value='"+photomessage[i][j]+"'>"+photomessage[i][j] +"&nbsp;&nbsp;&nbsp;<input type='button' id='delete"+[j]+"' name='delete"+[j]+"' value='x' onclick='remove(this.id)'></div>";
						
		}
		
	}
	
}

for(var i=0;i<photomessage.length;i++){					// 만약 메세지에 제거못한 필요없는 null 값이나 undefined값이 있다면 제거
	photomessage[i]  = photomessage[i].filter(function(item) {
		  return item !== null && item !== undefined && item !== '';
	});
	
} 

console.log("필요없는 값을 제거한 메세지: " + photomessage);	// 필요없는값이 잘 제거되었는지 확인 

var message = new Array(photomessage.length);			// 마지막으로 사진메세지에 줄 구분자(br)을 넣기위해 배열 생성
for(var i=0;i<photomessage.length;i++){
	
	for(var j=0;j<photomessage[i].length;j++){
		
		message[i] += photomessage[i][j] + "<br>";		// 사진메세지 배열하나하나에 줄 구분자(br)추가
		
		if(message[i].slice(0,9)=="undefined"){			// 만약 배열에 아직 제거못한 undefined값이 있다면 제거
			message[i] = message[i].substr(9);
		}
		if(message[i].slice(0,4)=="null"){				// 만약 배열에 아직 제거못한 null값이 있다면 제거
			message[i] = message[i].substr(4);
		} 		
	}
}
console.log("최종 메세지: " + message);					// 마지막으로 사진메세지 확인
	

var Photo = new Array(photoname.length);				// DB에 있는 데이터가 얼마나 있는지 확인 length함수
for(var i =0;i<photoname.length;i++){					
	Photo[i] = {title:"",photo:"",alt:"",comment:"",code:"",message:""};	// Object에 DB에서 가져온 값 추가하기위해 Object form 생성
}
console.log("Object form: ");				// Object가 값을 제대로 넣을수 있도록 form이 제대로 생성되었는지 확인
console.log(Photo);

for(var i=0;i<photoname.length;i++){				// Object에 값 추가
	Photo[i].title = photoname[i];					// 사진이름	
	Photo[i].photo = photopictureurl[i];			// 사진경로
	Photo[i].alt = photouserid[i];					// 사진작성자
	Photo[i].comment = photodescription[i];			// 사진설명
	Photo[i].code = photocode[i];					// 사진번호
	Photo[i].message = message[i];					// 사진메세지
}
console.log("Object Value: " );				// Object에 값이 제대로 들어갔는지 확인
console.log(Photo);
var PhotoAlbum = {									
		  data() {
		    return {
		      index: -1,
		      photos: Photo
		      
		    };
		  }
		};
		

		const app = Vue.createApp(PhotoAlbum);		// Vue.js에 있는 createApp() 함수 호출
		
		app.component("album-item", {				// Object에 들어 있는 값을 album-item에 추가, 사진 클릭전에 보여지는 템플릿
		  props: ["package"],
		  emits: ["click"],
		  template: `
			  <span class="album-item" @click="$emit('click')">
		            <img :src="package.photo" :alt="package.alt">
		        </span>
		    `,
		  data() {
		    return {
		      isOpened: false
		    };
		  }
		});

		app.component("img-popup", {			// Object에 들어 있는 값을 img-popup에 추가, 사진 클릭후에 보여지는 템플릿
		  props: ["photos", "index"],
		  emits: ["close"],
		  template: `
		        <teleport to="body">
		        <div class="img_popup" @click.self="$emit('close')">
		            <button type="button" class="to_left" @click="previous">&#8249;</button>
		            <div class="content">
		                <img :src="photos[id].photo" :alt="photos.alt">		
		                <div class="text">
		                    <h2>{{photos[id].title}}</h2>					
		                    <br>
		                    <p>{{photos[id].comment}}</p>					
		                    <br>
		                    <hr>
		                    <p v-html="photos[id].message"></p>				
		                    <hr>
		                    <%= (String) session.getAttribute("id") %>의		
		                    댓글: 	      
		                    <form action="productmessage.do" method="post">											
		                    <textarea hidden name="code">{{photos[id].code}}</textarea>								
		        
		                    <input type="hidden" name="userid" value="<%= (String) session.getAttribute("id") %>">	
		                    <input type="text" name="message">		
		                    <input type="submit" value="전송">		
		                    </form>
		                    <form action="productdeletemessage.do" method="post" name="frm" id="frm">		
		                    <input type="hidden" name="Usermessage" id="Usermessage">						
		                    <textarea hidden name="code">{{photos[id].code}}</textarea>						
		                    </form>
		                </div>  
		            </div>
		            <button type="button" class="to_right" @click="next">&#8250;</button>					
		        </div>
		    </teleport>
		    `,
		  data() {
		    return {
		      id: this.$props.index
		    };
		  },
		  methods: {
		    previous: function () {							// 이전사진으로 넘어갈수 있는 버튼 이벤트
		      if (!this.id) {
		        this.id = this.$props.photos.length - 1;
		      } else {
		        this.id--;
		      }
		    },
		    next: function () {								// 다음사진으로 넘어갈수 있는 버튼 이벤트
		      if (this.id === this.$props.photos.length - 1) {
		        this.id = 0;
		      } else {
		        this.id++;
		      }
		    }
		  }
		});

		app.mount("#app");
		
		function remove(clicked_id){					// 자기가 적은 메세지를 삭제하기위한 함수	
			console.log(clicked_id);					// 클릭한 메세지의 id값 판별, 메세지마다 id값이 다르다
			clicked_id = clicked_id.substr(6);			// 클릭한 메세지의 id값에 앞에있는 delete제거, 숫자만 남기기 하기 위함이다
			console.log(clicked_id);					// 다시 삭제할 메세지의 id값 확인
			var usermessage = "usermessage" + clicked_id;	// 위에서 확인 메세지 id값에 앞에 usermessage를 더한다
			console.log(usermessage);						// usermessage 확인
			var usermessageid = document.getElementById(usermessage).innerHTML;	// 아까 메세지가 어떤메세지인지 다시 확인
			console.log(usermessageid);											// 값이 제대로 들어갔는지 확인
			usermessageid = usermessageid.split("&nbsp")[0];					// &nbsp를 구분자로 다시자른다
			console.log(usermessageid);											// 잘 잘렸는지 확인
			usermessageid = usermessageid + "`!@#$";							// 다시 DB에 넣기위해 구분자 주기, 구분자를 주는 이유는 배열이아니라 문자열값으로 DB에 넣기 때문에 구분자가 무조건 필요하다
			document.getElementById("Usermessage").value = usermessageid;		// 메세지 삭제폼에 위에있는 구분자 추가한 메세지 값을 넣는다
			console.log("최종 삭제할 메세지: "+document.getElementById("Usermessage").value);	// 마지막으로 삭제할 메세지가 잘들어갔는지 확인
			document.getElementById("frm").submit();					// 메세지 삭제 form을 submit
		}

</script>


</body>
</html>