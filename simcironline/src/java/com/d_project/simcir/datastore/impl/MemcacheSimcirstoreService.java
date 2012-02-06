package com.d_project.simcir.datastore.impl;

import java.util.List;

import com.d_project.simcir.datastore.AbstractSimcirstoreService;
import com.d_project.simcir.datastore.Circuit;
import com.d_project.simcir.datastore.CircuitList;
import com.d_project.simcir.datastore.Library;
import com.d_project.simcir.datastore.SimcirstoreService;
import com.d_project.simcir.datastore.User;

/**
 * MemcacheSimcirstoreService
 * @author kazuhiko arase
 */
public class MemcacheSimcirstoreService extends AbstractSimcirstoreService {
	
	private CacheHelper<String,Circuit> circuitCache = new MemcacheHelper<String,Circuit>("circuit") {
		
		protected Circuit get(String key) throws Exception {
			return service.getCircuit(key, false);
		}
		
		protected void updateCache(Circuit circuit) throws Exception {
			User cache = userCache.get(circuit.getUser().getUserId(), true);
			if (cache != null) {
				circuit.setUser(cache);
			}
		}
	};

	private CacheHelper<String,User> userCache = new MemcacheHelper<String,User>("user") {

		protected User get(String userId) throws Exception {
			if (isUserLoggedIn() && userId.equals(getCurrentUserId() ) ) {
				return service.getUser(false);
			}
			return service.getUser(userId, false);
		}
	};
	
	private SimcirstoreService service;
	
	public MemcacheSimcirstoreService(SimcirstoreService service) {
		this.service = service;
	}

	public void deleteCircuit(String circuitKey) throws Exception {
		service.deleteCircuit(circuitKey);
	}
	
	public CircuitList getCircuitList(int currentPage) throws Exception {
		CircuitList circuitList = service.getCircuitList(currentPage);
		for (Circuit circuit : circuitList.getList() ) {
			circuitCache.put(circuit.getKey(), circuit);
		}
		return circuitList;
	}

	public Circuit putCircuit(
		String circuitKey,
		String title,
		String xml,
		String image,
		String thumbnail,
		boolean _private,
		boolean showNonVisuals
	) throws Exception {
		Circuit circuit = service.putCircuit(
			circuitKey,
			title, xml,
			image, thumbnail,
			_private,
			showNonVisuals
		);
		circuitCache.put(circuit.getKey(), circuit);
		return circuit;
	}

	public Circuit getCircuit(String circuitKey, boolean useCache) throws Exception {

		if (!useCache) {
			try {
				checkOwner(circuitKey);
			} catch(Exception e) {
				// not owner, so force use cache
				useCache = true;
			}
		}

		Circuit circuit = circuitCache.get(circuitKey, useCache);
		if (circuit.isPrivate() ) {
			checkOwner(circuitKey);
		}
		return circuit;
	}

	public void checkOwner(String circuitKey) throws Exception {
		service.checkOwner(circuitKey);
	}

	public void deleteLibrary(String libraryKey) throws Exception {
		service.deleteLibrary(libraryKey);
	}

	public List<Library> getLibraryList() throws Exception {
		return service.getLibraryList();
	}

	public void putLibrary(String circuitKey) throws Exception {
		service.putLibrary(circuitKey);
	}
	
	public User getUser(boolean useCache) throws Exception {
		return getUser(getCurrentUserId(), useCache);
	}
	
	public User getUser(String userId, boolean useCache) throws Exception {
		return userCache.get(userId, useCache);
	}
	
	public User putUser(
		String email,
		String nickname,
		String url, 
		String toolboxListXml,
		boolean newUser
	) throws Exception {
		User user = service.putUser(
			email, nickname, url, toolboxListXml, newUser);
		userCache.put(user.getUserId(), user);
		return user;
	}

	public String getCurrentUserId() throws Exception {
		return service.getCurrentUserId();
	}

	public boolean isUserLoggedIn() throws Exception {
		return service.isUserLoggedIn();
	}

	public String createLogoutURL(String url) throws Exception {
		return service.createLogoutURL(url);
	}
}

