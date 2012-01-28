package com.d_project.simcir.datastore;

import java.io.Serializable;

/**
 * User
 * @author kazuhiko arase
 */
@SuppressWarnings("serial")
public class User implements Serializable {

	private String userId;
	private String email;
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
	public String getEmail() {
		return email;
	}
	public void setEmail(String email) {
		this.email = email;
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
