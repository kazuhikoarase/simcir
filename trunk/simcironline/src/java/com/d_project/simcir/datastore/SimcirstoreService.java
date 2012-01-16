package com.d_project.simcir.datastore;

import java.util.List;

/**
 * SimcirstoreService
 * @author kazuhiko arase
 */
public interface SimcirstoreService {

	CircuitList getRecentCircuitList(int currentPage) throws Exception;

	void deleteCircuit(String key) throws Exception;
	
	CircuitList getCircuitList(int currentPage) throws Exception;
	
	Circuit putCircuit(String key, String title, String xml, String image, String thumbnail, boolean isPrivate) throws Exception;
	
	Circuit getCircuit(String key, boolean useCache) throws Exception;

	void deleteLibrary(String key) throws Exception;
	
	List<Library> getLibraryList() throws Exception;

	String putLibrary(String key) throws Exception;

	User getUser(boolean useCache) throws Exception;

	User putUser(String nickname, String url) throws Exception;
	
	boolean isUserLoggedIn() throws Exception;

	String createLogoutURL(String url) throws Exception;

	void putToolboxList(String toolboxListXml) throws Exception;
}
