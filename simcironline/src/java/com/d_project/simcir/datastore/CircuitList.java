package com.d_project.simcir.datastore;

import java.io.Serializable;
import java.util.List;

/**
 * CircuitList
 * @author kazuhiko arase
 */
@SuppressWarnings("serial")
public class CircuitList implements Serializable {

	private int currentPage;
	private int numPages;
	private int numPerPage;
	private int numCircuits;
	private List<Circuit> list;
	
	public CircuitList() {
	}
	
	public int getCurrentPage() {
		return currentPage;
	}
	public void setCurrentPage(int currentPage) {
		this.currentPage = currentPage;
	}
	public int getNumPages() {
		return numPages;
	}
	public void setNumPages(int numPages) {
		this.numPages = numPages;
	}
	public int getNumPerPage() {
		return numPerPage;
	}
	public void setNumPerPage(int numPerPage) {
		this.numPerPage = numPerPage;
	}
	public int getNumCircuits() {
		return numCircuits;
	}
	public void setNumCircuits(int numCircuits) {
		this.numCircuits = numCircuits;
	}
	public List<Circuit> getList() {
		return list;
	}
	public void setList(List<Circuit> list) {
		this.list = list;
	}
}
