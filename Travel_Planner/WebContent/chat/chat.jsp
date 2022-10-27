<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
    <title>채팅</title>
    
</head>
<body>
    <fieldset style="height:100%">
        <textarea id="messageWindow" rows="10" cols="50" readonly="true" style="height:90%"></textarea>
        <br/>
        <input id="inputMessage" type="text"/>
        <input type="submit" value="send" onclick="send()" />
    </fieldset>
</body>
    <script type="text/javascript">
        var textarea = document.getElementById("messageWindow");
        var webSocket = new WebSocket('ws://localhost:8080/Planner/broadcasting');
        var inputMessage = document.getElementById('inputMessage');
    	webSocket.onerror = function(event) {
      		onError(event)
    	};
    	webSocket.onopen = function(event) {
    		onOpen(event)
    	};

    	webSocket.onmessage = function(event) {
    		onMessage(event)
    	};

    	function onMessage(event) {
    	    textarea.value += "상대 : " + event.data + "\n";
    	}

    	function onOpen(event) {
    	    textarea.value += "연결 성공\n";
    	}

    	function onError(event) {
    	    // alert(event.data);
    	} 

    	function send() {
    	    textarea.value += "나 : " + inputMessage.value + "\n";
    	    webSocket.send(inputMessage.value);
    	    inputMessage.value = "";
    	}

    
  </script>
</html>