package com.d_project.simcir.datastore;

import java.util.List;

/**
 * SimcirstoreService
 * @author kazuhiko arase
 */
public interface SimcirstoreService {

	CircuitList getRecentCircuitList(int currentPage) throws Exception;

	void deleteCircuit(String circuitKey) throws Exception;
	
	CircuitList getCircuitList(int currentPage) throws Exception;

	void checkOwner(String circuitKey) throws Exception;
	
	Circuit putCircuit(String circuitKey, String title, String xml, String image, String thumbnail, boolean isPrivate) throws Exception;
	
	Circuit getCircuit(String circuitKey, boolean useCache) throws Exception;

	void deleteLibrary(String libraryKey) throws Exception;
	
	List<Library> getLibraryList() throws Exception;

	void putLibrary(String circuitKey) throws Exception;

	User getUser(boolean useCache) throws Exception;

	User getUser(String userId, boolean useCache) throws Exception;

	User putUser(String nickname, String url, String toolboxListXml, boolean newUser) throws Exception;

	User putUser(String nickname, String url) throws Exception;

	void putToolboxList(String toolboxListXml) throws Exception;

	String getCurrentUserId() throws Exception;
	
	boolean isUserLoggedIn() throws Exception;

	String createLogoutURL(String url) throws Exception;
}
