package com.dntkdwls.dto;

import java.sql.Date;

public class ProductVo {
	private int code;
	private String name;
	private String pictureurl;
	private String description;
	private String userid;
	private String message;
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
	public String getPictureurl() {
		return pictureurl;
	}
	public void setPictureurl(String pictureurl) {
		this.pictureurl = pictureurl;
	}
	public String getDescription() {
		return description;
	}
	public void setDescription(String description) {
		this.description = description;
	}
	public String getUserid() {
		return userid;
	}
	public void setUserid(String userid) {
		this.userid = userid;
	}
	public String getMessage() {
		return message;
	}
	public void setMessage(String message) {
		this.message = message;
	}
	@Override
	public String toString() {
		return "ProductVo [code=" + code + ", name=" + name + ", pictureurl=" + pictureurl + ", description="
				+ description + ", userid=" + userid + ", message=" + message + "]";
	}
	
	
	
	
	
}
