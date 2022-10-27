/** 
 * 만약 개발자도구에서 소스가 안보이는 경우,
 * 1. Network 탭으로 이동하여 Disable cache 체크박스에 체크
 * => Sources 탭으로 이동하여 F5(새로고침),
 * 2. 그래도안보이면 Console 탭으로 이동, console.log 입력 후 엔터
 * => Sources 탭으로 이동하여 F5(새로고침),
 */

// id를 입력후 중복체크버튼을 눌렀을 때, 동작 함수
function checkId(){
	if(document.frm.userid.value===""){
		alert("아이디를 입력하여 주세요.");
		return;
	}
	var url = "checkId.do?userid="+document.frm.userid.value;
	window.open(url, "_blank_1", "menubar= no, resizeable=no, width=450, height=200");	
}


// idCheck.jsp에서 사용 버튼 클릭시, 동작할 함수
function idOk(){
	// 중복체크 창에 입력된 아이디값을 회원가입창 아이디 입력양식에 표시
	opener.frm.userid.value = document.frm.userid.value;
	// 중복체크가 완료되었는지 확인하기 위한 목적의 변수에 아이디값 저장
	opener.frm.checkid.value = document.frm.userid.value;
	self.close();		// 생성된 창 닫기
}

// 로그인 페이지에서 입력된 양식에 정상 데이터가 포함되었는지 확인
function checkLogin(){
	if(document.frm.userId.value.length === 0){
		alert('아이디를 입력해주세요');
		frm.userid.focus();
		return false;
	}
	if(document.frm.userPwd.value === ""){
		alert('암호를 입력해주세요');
		frm.pwd.focus();
		return false;
	}
	return true;
}




// 회원 가입 페이지에서 입력된 양식에 정상 데이터가 포함되었는지 확인
function checkJoin(){

	if(document.frm.name.value.length === 0){
		alert('이름을 입력해주세요');
		frm.name.focus();
		return false;
	}
	if(document.frm.userid.value.length === 0){
		alert('아이디를 입력해주세요');
		frm.userid.focus();
		return false;
	}
	if(document.frm.userid.value.length <4){
		alert('아이디는 4자 이상 입력해주세요');
		frm.userid.focus();
		return false;
	}
	if(document.frm.pwd.value.length === 0){
		alert('암호를 입력해주세요');
		frm.pwd.focus();
		return false;
	}
	if(document.frm.pwd_check.value !== document.frm.pwd.value){
		alert('암호가 일치하지 않습니다.');
		frm.pwd_check.focus();
		return false;
	}
	
	// alert(document.frm.checkid.value.length);
	if(document.frm.checkid.value.length === 0){
		alert("중복 체크를 하지 않았습니다.");
		frm.userid.focus();
		return false;
	}
	return true;
}

// 회원 가입 페이지에서 입력된 양식에 정상 데이터가 포함되었는지 확인
function Update(){

	if(document.frm.name.value.length === 0){
		alert('이름을 입력해주세요');
		frm.name.focus();
		return false;
	}
	if(document.frm.userPwd.value.length === 0){
		alert('암호를 입력해주세요');
		frm.pwd.focus();
		return false;
	}
	if(document.frm.userPwd_check.value !== document.frm.userPwd.value){
		alert('암호가 일치하지 않습니다.');
		frm.userPwd_check.focus();
		return false;
	}
	return true;
}