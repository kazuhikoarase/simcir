package com.d_project.simcir.datastore.impl;

import java.util.List;

import org.w3c.dom.Document;

import com.d_project.simcir.Util;
import com.d_project.simcir.datastore.Circuit;
import com.d_project.simcir.datastore.CircuitList;
import com.d_project.simcir.datastore.Library;
import com.d_project.simcir.datastore.SimcirstoreService;
import com.d_project.simcir.datastore.User;

/**
 * MemcacheSimcirstoreService
 * @author kazuhiko arase
 */
public class MemcacheSimcirstoreService implements SimcirstoreService {

	private MemcacheHelper<Integer,CircuitList> circuitListCache = new MemcacheHelper<Integer,CircuitList>("circuitList") {
		
		protected CircuitList get(Integer currentPage) throws Exception {
			return getRecentCircuitListImpl(currentPage);
		}

		protected void updateCache(CircuitList circuitList) throws Exception {
			for (int i = 0; i < circuitList.getList().size(); i += 1) {
				Circuit circuit = circuitList.getList().get(i);
				Circuit cache = circuitCache.get(circuit.getKey(), true);
				if (cache != null) {
					circuitList.getList().set(i, cache);
				}
			}
		}
	};
	
	private MemcacheHelper<String,Circuit> circuitCache = new MemcacheHelper<String,Circuit>("circuit") {
		
		protected Circuit get(String key) throws Exception {
			return service.getCircuit(key, false);
		}
		
		protected void updateCache(Circuit circuit) throws Exception {
			User cache = userCache.get(circuit.getUser().getUserId() );
			if (cache != null) {
				circuit.setUser(cache);
			}
		}
	};

	private MemcacheHelper<String,User> userCache = new MemcacheHelper<String,User>("user") {

		protected User get(String key) throws Exception {
			return service.getUser(key, false);
		}
	};
	
	private SimcirstoreService service;
	
	public MemcacheSimcirstoreService(SimcirstoreService service) {
		this.service = service;
	}
	
	public CircuitList getRecentCircuitList(int currentPage) throws Exception {
		return circuitListCache.get(currentPage, true);
	}
	
	private CircuitList getRecentCircuitListImpl(int currentPage) throws Exception {
		CircuitList circuitList = service.getRecentCircuitList(currentPage);
		for (Circuit circuit : circuitList.getList() ) {
			circuitCache.put(circuit.getKey(), circuit);
		}
		return circuitList;
	}
	
	public void deleteCircuit(String key) throws Exception {
		service.deleteCircuit(key);
	}
	
	public CircuitList getCircuitList(int currentPage) throws Exception {
		CircuitList circuitList = service.getCircuitList(currentPage);
		for (Circuit circuit : circuitList.getList() ) {
			circuitCache.put(circuit.getKey(), circuit);
		}
		return circuitList;
	}

	public Circuit putCircuit(
		String key,
		String title,
		String xml,
		String image,
		String thumbnail,
		boolean isPrivate
	) throws Exception {

		Circuit circuit = service.putCircuit(key, title, xml, image, thumbnail, isPrivate);

		circuitCache.put(circuit.getKey(), circuit);
		
		return circuit;
	}

	public Circuit getCircuit(String key, boolean useCache) throws Exception {
		
		if (Util.isEmpty(key) ) {
			return null;
		}

		if (!useCache) {
			try {
				checkOwner(key);
			} catch(Exception e) {
				// not owner, so force use cache
				useCache = true;
			}
		}

		Circuit circuit = circuitCache.get(key, useCache);

		if (circuit.isPrivate() ) {
			checkOwner(key);
		}
		
		return circuit;
	}

	public void checkOwner(String key) throws Exception {
		service.checkOwner(key);
	}

	public void deleteLibrary(String key) throws Exception {
		service.deleteLibrary(key);
	}

	public List<Library> getLibraryList() throws Exception {
		return service.getLibraryList();
	}

	public void putLibrary(String key) throws Exception {
		service.putLibrary(key);
	}
	
	public User getUser(boolean useCache) throws Exception {
		return getUser(null, useCache);
	}
	
	public User getUser(String key, boolean useCache) throws Exception {
		if (key == null) {
			User user = service.getUser(useCache);
			userCache.put(user.getUserId(), user);
			return user;
		}
		return userCache.get(key, useCache);
	}
	
	public User putUser(String nickname, String url) throws Exception {
		User user = getUser(false);
		return putUser(
			nickname,
			url,
			user.getToolboxListXml(), false);
	}

	public void putToolboxList(String toolboxListXml) throws Exception {

		Document doc = Util.parseDocument(toolboxListXml);
		if (doc.getDocumentElement().hasChildNodes() ) {
			toolboxListXml = Util.toXMLString(doc);
		} else {
			toolboxListXml = "";
		}
		
		User user = getUser(false);
		putUser(
			user.getNickname(),
			user.getUrl(),
			toolboxListXml, false);
	}
	
	public User putUser(
		String nickname,
		String url, 
		String toolboxListXml,
		boolean newUser
	) throws Exception {
		User user = service.putUser(nickname, url, toolboxListXml, newUser);
		userCache.put(user.getUserId(), user);
		return user;
	}

	public boolean isUserLoggedIn() throws Exception {
		return service.isUserLoggedIn();
	}

	public String createLogoutURL(String url) throws Exception {
		return service.createLogoutURL(url);
	}

}

