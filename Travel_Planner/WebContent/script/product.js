function checkProduct(){
	if(document.frm.name.value.length===0){
		alert("상품명을 입력하세요.");
		frm.name.focus();
		return false;
	}
	if(document.frm.price.value.length===0){
		alert("가격을 입력하세요.");
		frm.price.focus();
		return false;
	}
	if(isNaN(document.frm.name.value)){
		alert("숫자로 입력하세요.");
		frm.price.focus();
		return false;
	}
	return true;
}