package com.dntkdwls.dto;

// DTO(VO) 사용 장점
// 1. 중요한 정보 보안 강화 (필드 직접 접근 차단)
// 2. 데이터 관리의 일원화 (객체를 통해서만 데이터 접근)
// 3. 데이터 값 검증 (유효한 값만 사용)
public class MemberVo {
	private int code;
	private String name;
	private String userid;
	private String pwd;
	private String email;
	private String phone;
	private String nickname;
	private String introduce;
	private String userlatlng;
	
	@Override
	public String toString() {
		return "MemberVo [code=" + code + ", name=" + name + ", userid=" + userid + ", pwd=" + pwd + ", email=" + email
				+ ", phone=" + phone + ", nickname=" + nickname + ", introduce=" + introduce + ", userlatlng="
				+ userlatlng + "]";
	}
	
	public int getCode() {
		return code;
	}
	public void setCode(int code) {
		this.code = code;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public String getUserid() {
		return userid;
	}
	public void setUserid(String userid) {
		this.userid = userid;
	}
	public String getPwd() {
		return pwd;
	}
	public void setPwd(String pwd) {
		this.pwd = pwd;
	}
	public String getEmail() {
		return email;
	}
	public void setEmail(String email) {
		this.email = email;
	}
	public String getPhone() {
		return phone;
	}
	public void setPhone(String phone) {
		this.phone = phone;
	}
	public String getNickname() {
		return nickname;
	}
	public void setNickname(String nickname) {
		this.nickname = nickname;
	}
	public String getIntroduce() {
		return introduce;
	}
	public void setIntroduce(String introduce) {
		this.introduce = introduce;
	}
	public String getUserlatlng() {
		return userlatlng;
	}
	public void setUserlatlng(String userlatlng) {
		this.userlatlng = userlatlng;
	}
	
	
	
	
	
	
}
