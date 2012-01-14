package com.d_project.simcir.datastore;

/**
 * User
 * @author kazuhiko arase
 */
public class User {

	private String userId;
	private String nickname;
	private String url;
	private String toolboxListXml;
	
	public User() {
	}
	
	public String getUserId() {
		return userId;
	}
	public void setUserId(String userId) {
		this.userId = userId;
	}
	public String getNickname() {
		return nickname;
	}
	public void setNickname(String nickname) {
		this.nickname = nickname;
	}
	public String getUrl() {
		return url;
	}
	public void setUrl(String url) {
		this.url = url;
	}
	public String getToolboxListXml() {
		return toolboxListXml;
	}
	public void setToolboxListXml(String toolboxListXml) {
		this.toolboxListXml = toolboxListXml;
	}
}
