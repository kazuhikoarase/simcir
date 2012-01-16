package com.d_project.simcir.datastore;

import java.io.Serializable;
import java.util.Date;

/**
 * Library
 * @author kazuhiko arase
 */
@SuppressWarnings("serial")
public class Library implements Serializable {

	private String key;
	private Date addedDate;
	private Circuit cir;

	public Library() {
	}

	public String getKey() {
		return key;
	}
	public void setKey(String key) {
		this.key = key;
	}
	public Date getAddedDate() {
		return addedDate;
	}
	public void setAddedDate(Date addedDate) {
		this.addedDate = addedDate;
	}
	public Circuit getCir() {
		return cir;
	}
	public void setCir(Circuit cir) {
		this.cir = cir;
	}
}
