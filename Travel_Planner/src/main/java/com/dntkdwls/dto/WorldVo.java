package com.dntkdwls.dto;

public class WorldVo {
	private String userid;
	private String continent;
	private String schedule;
	private String introduce;
	private String title;
	private String pictureurl;
	private String message;
	
	public String getMessage() {
		return message;
	}
	public void setMessage(String message) {
		this.message = message;
	}
	public String getUserid() {
		return userid;
	}
	public void setUserid(String userid) {
		this.userid = userid;
	}
	public String getContinent() {
		return continent;
	}
	public void setContinent(String continent) {
		this.continent = continent;
	}
	public String getSchedule() {
		return schedule;
	}
	public void setSchedule(String schedule) {
		this.schedule = schedule;
	}
	public String getIntroduce() {
		return introduce;
	}
	public void setIntroduce(String introduce) {
		this.introduce = introduce;
	}
	public String getTitle() {
		return title;
	}
	public void setTitle(String title) {
		this.title = title;
	}
	public String getPictureurl() {
		return pictureurl;
	}
	public void setPictureurl(String pictureurl) {
		this.pictureurl = pictureurl;
	}
	
	@Override
	public String toString() {
		return "WorldVo [userid=" + userid + ", continent=" + continent + ", schedule=" + schedule + ", introduce="
				+ introduce + ", title=" + title + ", pictureurl=" + pictureurl + ", message=" + message + "]";
	}
	
	
	
}
