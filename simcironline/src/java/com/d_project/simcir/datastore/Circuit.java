package com.d_project.simcir.datastore;

import java.io.Serializable;
import java.util.Date;

/**
 * Circuit
 * @author kazuhiko arase
 */
@SuppressWarnings("serial")
public class Circuit implements Serializable {
	
	private String key;
	private Date createDate;
	private Date updateDate;
	private String title;
	private String xml;
	private byte[] image;
	private byte[] thumbnail;
	private User user;
	private boolean _private;

	public Circuit() {
	}
	
	public String getKey() {
		return key;
	}
	public void setKey(String key) {
		this.key = key;
	}
	public Date getCreateDate() {
		return createDate;
	}
	public void setCreateDate(Date createDate) {
		this.createDate = createDate;
	}
	public Date getUpdateDate() {
		return updateDate;
	}
	public void setUpdateDate(Date updateDate) {
		this.updateDate = updateDate;
	}
	public String getTitle() {
		return title;
	}
	public void setTitle(String title) {
		this.title = title;
	}
	public String getXml() {
		return xml;
	}
	public void setXml(String xml) {
		this.xml = xml;
	}
	public byte[] getImage() {
		return image;
	}
	public void setImage(byte[] image) {
		this.image = image;
	}
	public byte[] getThumbnail() {
		return thumbnail;
	}
	public void setThumbnail(byte[] thumbnail) {
		this.thumbnail = thumbnail;
	}
	public User getUser() {
		return user;
	}
	public void setUser(User user) {
		this.user = user;
	}
	public void setPrivate(boolean value) {
		this._private = value;
	}
	public boolean isPrivate() {
		return _private;
	}
}
