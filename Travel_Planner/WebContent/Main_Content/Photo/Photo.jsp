<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>    
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>사진</title>
<style>
.card-wrapper {
  display: inline-block;
  perspective: 1000px;
}
.card-wrapper .card {
  position: relative;
  cursor: pointer;
  transition-duration: 0.6s;
  transition-timing-function: ease-in-out;
  transform-style: preserve-3d;
}
.card-wrapper .card .front,
.card-wrapper .card .back {
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  backface-visibility: hidden;
  transform: rotateX(0deg);
}
.card-wrapper .card .front {
  z-index: 2;
}
.card-wrapper .card .back,
.card-wrapper.flip-right .card .back {
  transform: rotateY(180deg);
}
.card-wrapper:hover .card,
.card-wrapper.flip-right:hover .card {
  transform: rotateY(180deg);
}
.card-wrapper.flip-left .card .back {
  transform: rotateY(-180deg);
}
.card-wrapper.flip-left:hover .card {
  transform: rotateY(-180deg);
}
.card-wrapper.flip-up .card .back {
  transform: rotateX(180deg);
}
.card-wrapper.flip-up:hover .card {
  transform: rotateX(180deg);
}
.card-wrapper.flip-down .card .back {
  transform: rotateX(-180deg);
}
.card-wrapper.flip-down:hover .card {
  transform: rotateX(-180deg);
}
.card-wrapper.flip-diagonal-right .card .back {
  transform: rotate3d(1, 1, 0, 180deg);
}
.card-wrapper.flip-diagonal-right:hover .card {
  transform: rotate3d(1, 1, 0, 180deg);
}
.card-wrapper.flip-diagonal-left .card .back {
  transform: rotate3d(1, 1, 0, -180deg);
}
.card-wrapper.flip-diagonal-left:hover .card {
  transform: rotate3d(1, 1, 0, -180deg);
}
.card-wrapper.flip-inverted-diagonal-right .card .back {
  transform: rotate3d(-1, 1, 0, 180deg);
}
.card-wrapper.flip-inverted-diagonal-right:hover .card {
  transform: rotate3d(-1, 1, 0, 180deg);
}
.card-wrapper.flip-inverted-diagonal-left .card .back {
  transform: rotate3d(1, -1, 0, 180deg);
}
.card-wrapper.flip-inverted-diagonal-left:hover .card {
  transform: rotate3d(1, -1, 0, 180deg);
}
/* DEMO */
.body {
  background: #E7BDD6;
}
.card-wrapper,
.card {
  width: 200px;
  height: 200px;
  margin: 10px;
}
.card .front,
.card .back {
  display: flex;
  align-items: center;
  justify-content: center;
  border: 1px solid #FC545E;
  border-radius: 4px;
}
.card .front {
  color: #FC545E;
  background: #FFFFFF;
  font-weight: 700;
  font-size: 1rem;
}
.card .back {
  font-size: 1.5rem;
  color: #FFFFFF;
  background: #FC545E;
}
</style>
</head>
<body>
<h1>&nbsp;여행 사진</h1>
<p>&nbsp;&nbsp;여행 사진을 공유하세요.</p>
		
<c:forEach var="product" items="${productList}">
	<div class="card-wrapper flip-right">
    	<div class="card">
        	<div class="front">
        		<img style="width:200px;height:200px;margin:10px;" src="upload/${product.pictureurl}">
	    		<%-- ${product.name} --%>
        	</div>
        	<div class="back">${product.description}</div>
    	</div>
	</div>
</c:forEach>

</body>
</html>