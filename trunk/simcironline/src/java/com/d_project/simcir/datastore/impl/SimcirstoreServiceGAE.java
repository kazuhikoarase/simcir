package com.d_project.simcir.datastore.impl;

import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.Date;
import java.util.List;

import org.w3c.dom.Document;

import com.d_project.simcir.Util;
import com.d_project.simcir.datastore.Circuit;
import com.d_project.simcir.datastore.CircuitList;
import com.d_project.simcir.datastore.Library;
import com.d_project.simcir.datastore.SimcirstoreService;
import com.d_project.simcir.datastore.User;
import com.d_project.util.Base64;
import com.google.appengine.api.datastore.Blob;
import com.google.appengine.api.datastore.DatastoreService;
import com.google.appengine.api.datastore.DatastoreServiceFactory;
import com.google.appengine.api.datastore.Entity;
import com.google.appengine.api.datastore.EntityNotFoundException;
import com.google.appengine.api.datastore.FetchOptions;
import com.google.appengine.api.datastore.Key;
import com.google.appengine.api.datastore.KeyFactory;
import com.google.appengine.api.datastore.PreparedQuery;
import com.google.appengine.api.datastore.Query;
import com.google.appengine.api.datastore.Text;
import com.google.appengine.api.datastore.Query.FilterOperator;
import com.google.appengine.api.images.Image;
import com.google.appengine.api.images.ImagesService;
import com.google.appengine.api.images.ImagesServiceFactory;
import com.google.appengine.api.images.Transform;
import com.google.appengine.api.users.UserService;
import com.google.appengine.api.users.UserServiceFactory;

/**
 * SimcirstoreServiceGAE
 * @author kazuhiko arase
 */
public class SimcirstoreServiceGAE implements SimcirstoreService {
	
	private static final String KIND_USER = "User";
	
	private static final String KIND_CIRCUIT = "Circuit";
	
	private static final String KIND_LIBRARY = "Library";

	private static final String CHAR_ENCODING = "UTF-8";

	private static final long DAY_IN_MILLIS = 1000L * 3600 * 24;
	
//	private int numPerPage = 3;
	private int numPerPage = 10;
	
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
		
		protected Circuit get(String keyString) throws Exception {
			DatastoreService ds = DatastoreServiceFactory.getDatastoreService();
			return entityToCircuit(ds, ds.get(KeyFactory.stringToKey(keyString) ) );
		}
		
		protected void updateCache(Circuit circuit) throws Exception {
			Key key = KeyFactory.stringToKey(circuit.getKey() );
			User cache = userCache.get(KeyFactory.keyToString(key.getParent() ), true);
			if (cache != null) {
				circuit.setUser(cache);
			}
		}
	};

	private MemcacheHelper<String,User> userCache = new MemcacheHelper<String,User>("user") {
		
		protected User get(String key) throws Exception {
			DatastoreService ds = DatastoreServiceFactory.getDatastoreService();
			return entityToUser(ds.get(KeyFactory.stringToKey(key) ) );
		}
	};
	
	public SimcirstoreServiceGAE() {
	}
	
	public CircuitList getRecentCircuitList(int currentPage) throws Exception {
		return circuitListCache.get(currentPage, true);
	}
	
	public CircuitList getRecentCircuitListImpl(int currentPage) throws Exception {

		Date date = new Date(System.currentTimeMillis() - DAY_IN_MILLIS * 7);
		
		DatastoreService ds = DatastoreServiceFactory.getDatastoreService();

		Query query = new Query(KIND_CIRCUIT);
		query.addFilter("private", FilterOperator.EQUAL, false);
//		query.addFilter("createDate", FilterOperator.GREATER_THAN, date);
		query.addSort("createDate", Query.SortDirection.DESCENDING);

		PreparedQuery pq = ds.prepare(query);

		int offset = currentPage * numPerPage;
		int limit = numPerPage;
		
		List<Circuit> list = new ArrayList<Circuit>();
		for (Entity entity : pq.asList(FetchOptions.Builder.withOffset(offset).limit(limit) ) ) {
			Circuit circuit = entityToCircuit(ds, entity);
			circuitCache.put(circuit.getKey(), circuit);
			list.add(circuit);
		}

		int numCircuits = pq.countEntities(FetchOptions.Builder.withDefaults() );
		int numPages = ( (numCircuits - 1) / numPerPage) + 1;

		CircuitList circuitList = new CircuitList();
		circuitList.setList(list);
		circuitList.setCurrentPage(currentPage);
		circuitList.setNumPages(numPages);
		circuitList.setNumPerPage(numPerPage);
		circuitList.setNumCircuits(numCircuits);
		return circuitList;
	}
	
	public void deleteCircuit(String keyString) throws Exception {

		checkOwner(keyString);

		DatastoreService ds = DatastoreServiceFactory.getDatastoreService();
		
		Key key = KeyFactory.stringToKey(keyString);
		if (!key.getParent().equals(getCurrentUserKey() ) ) {
			throw new Exception();
		}
		ds.delete(key);
	}
	
	public CircuitList getCircuitList(int currentPage) throws Exception {

		DatastoreService ds = DatastoreServiceFactory.getDatastoreService();
	
		Query query = new Query(KIND_CIRCUIT, getCurrentUserKey() );
		query.addSort("createDate", Query.SortDirection.DESCENDING);

		PreparedQuery pq = ds.prepare(query);

		int offset = currentPage * numPerPage;
		int limit = numPerPage;
		
		List<Circuit> list = new ArrayList<Circuit>();
		for (Entity entity : pq.asList(FetchOptions.Builder.withOffset(offset).limit(limit) ) ) {
			Circuit circuit = entityToCircuit(ds, entity);
			circuitCache.put(circuit.getKey(), circuit);
			list.add(circuit);
		}

		int numCircuits = pq.countEntities(FetchOptions.Builder.withDefaults() );
		int numPages = ( (numCircuits - 1) / numPerPage) + 1;

		CircuitList circuitList = new CircuitList();
		circuitList.setList(list);
		circuitList.setCurrentPage(currentPage);
		circuitList.setNumPages(numPages);
		circuitList.setNumPerPage(numPerPage);
		circuitList.setNumCircuits(numCircuits);
		return circuitList;
	}

	public Circuit putCircuit(
		String keyString,
		String title,
		String xml,
		String image,
		String thumbnail,
		boolean isPrivate
	) throws Exception {

		DatastoreService ds = DatastoreServiceFactory.getDatastoreService();

		Date date = new Date();
		Entity entity;
		
		if (!Util.isEmpty(keyString) ) {
			checkOwner(keyString);
			entity = ds.get(KeyFactory.stringToKey(keyString) );
		} else {
			entity = new Entity(KIND_CIRCUIT, getCurrentUserKey() );
			entity.setProperty("createDate", date);
		}

		// trim and set title
		Document doc = Util.parseDocument(xml);
		doc.getDocumentElement().setAttribute("title", title);
		xml = Util.toXMLString(doc);
		
		entity.setProperty("updateDate", date);
		
		entity.setProperty("title", new Text(title) );
		entity.setProperty("xml", stringToBlob(xml) );
		entity.setProperty("image", imgToBlob(image) );
		entity.setProperty("thumbnail", imgToBlob(thumbnail) );
		entity.setProperty("private", isPrivate);

		Key key = ds.put(entity);
		
		Circuit circuit = entityToCircuit(ds, entity);
		circuit.setKey(KeyFactory.keyToString(key) );

		circuitCache.put(circuit.getKey(), circuit);
		
		return circuit;
	}

	public Circuit getCircuit(String keyString, boolean useCache) throws Exception {
		
		if (Util.isEmpty(keyString) ) {
			return null;
		}

		if (!useCache) {
			try {
				checkOwner(keyString);
			} catch(Exception e) {
				// not owner, so force use cache
				useCache = true;
			}
		}

		Circuit circuit = circuitCache.get(keyString, useCache);

		if (circuit.isPrivate() ) {
			checkOwner(keyString);
		}
		
		return circuit;
	}

	public void deleteLibrary(String keyString) throws Exception {

		checkOwner(keyString);
		
		DatastoreService ds = DatastoreServiceFactory.getDatastoreService();
		
		Key key = KeyFactory.stringToKey(keyString);
		if (!key.getParent().equals(getCurrentUserKey() ) ) {
			throw new Exception();
		}
		ds.delete(key);
	}

	public List<Library> getLibraryList() throws Exception {

		DatastoreService ds = DatastoreServiceFactory.getDatastoreService();
		
		Query query = new Query(KIND_LIBRARY, getCurrentUserKey() );
		query.addSort("addedDate", Query.SortDirection.DESCENDING);
		
		PreparedQuery pq = ds.prepare(query);
		
		List<Library> list = new ArrayList<Library>();
		for (Entity entity : pq.asList(FetchOptions.Builder.withDefaults() ) ) {
			try {
				list.add(entityToLibrary(ds, entity) );
			} catch(Exception e) {
				e.printStackTrace();
				deleteLibrary(KeyFactory.keyToString(entity.getKey() ) );
			}
		}

		Collections.sort(list, new Comparator<Library>() {
			public int compare(Library l1, Library l2) {
				return l1.getCir().getTitle().compareTo(l2.getCir().getTitle() );
			}
		} );
		
		return list;
	}

	public String putLibrary(String keyString) throws Exception {

		DatastoreService ds = DatastoreServiceFactory.getDatastoreService();

		Date date = new Date();

		Entity entity = new Entity(KIND_LIBRARY, getCurrentUserKey() );
		entity.setProperty("addedDate", date);
		entity.setProperty("key", KeyFactory.stringToKey(keyString) );

		return KeyFactory.keyToString(ds.put(entity) );
	}
	
	public User getUser(boolean useCache) throws Exception {

		try {
			return getUser(KeyFactory.keyToString(getCurrentUserKey() ), useCache);
		} catch(EntityNotFoundException e) {

			UserService us = UserServiceFactory.getUserService();
			com.google.appengine.api.users.User cu = us.getCurrentUser();

			User user = new User();
			user.setUserId(cu.getUserId() );
			user.setNickname(cu.getEmail() );
			user.setUrl("");
			user.setToolboxListXml("");
			
			// put default.
			putUser(user, true);
			
			return user;
		}
	}
	
	public User getUser(String key, boolean useCache) throws Exception {
		return userCache.get(key, useCache);
	}
	
	public User putUser(String nickname, String url) throws Exception {
		User user = getUser(false);
		user.setNickname(nickname);
		user.setUrl(url);
		return putUser(user, false);
	}
	
	private User putUser(User user, boolean newUser) throws Exception {

		DatastoreService ds = DatastoreServiceFactory.getDatastoreService();
		
		Entity entity = new Entity(getCurrentUserKey() );
		entity.setProperty("nickname", user.getNickname() );
		entity.setProperty("url", user.getUrl() );
		entity.setProperty("toolboxListXml",
				stringToBlob(user.getToolboxListXml() ) );
		
		Date date = new Date();
		if (newUser) {
			entity.setProperty("createDate", date);
		}
		entity.setProperty("updateDate", date);

		Key key = ds.put(entity);
		user = entityToUser(entity);
		
		userCache.put(KeyFactory.keyToString(key), user);
		
		return user;
	}

	public boolean isUserLoggedIn() throws Exception {
		UserService us = UserServiceFactory.getUserService();
		return us.isUserLoggedIn();
	}

	public String createLogoutURL(String url) throws Exception {
		UserService us = UserServiceFactory.getUserService();
		return us.createLogoutURL(url);
	}

	public void putToolboxList(String toolboxListXml) throws Exception {

		Document doc = Util.parseDocument(toolboxListXml);
		if (doc.getDocumentElement().hasChildNodes() ) {
			toolboxListXml = Util.toXMLString(doc);
		} else {
			toolboxListXml = "";
		}
		
		User user = getUser(false);
		user.setToolboxListXml(toolboxListXml);
		putUser(user, false);
	}

	private Key getCurrentUserKey() throws Exception {
		UserService us = UserServiceFactory.getUserService();
		com.google.appengine.api.users.User cu = us.getCurrentUser();
		if (cu == null) {
			return null;
		}
		return KeyFactory.createKey(KIND_USER, cu.getUserId() );
	}

	private Library entityToLibrary(
		DatastoreService ds,
		Entity entity
	) throws Exception {
		
		String circuitKeyString = KeyFactory.keyToString( (Key)entity.getProperty("key") );
		Circuit circuit = getCircuit(circuitKeyString, true);
		
		Library lib = new Library();
		
		lib.setKey(KeyFactory.keyToString(entity.getKey() ) );
		lib.setAddedDate( (Date)entity.getProperty("addedDate") );
		lib.setCir(circuit);	

		return lib;
	}
	
	private Circuit entityToCircuit(
		DatastoreService ds,
		Entity entity
	) throws Exception {

		Circuit cir = new Circuit();
		
		cir.setKey(KeyFactory.keyToString(entity.getKey() ) );
		cir.setCreateDate( (Date)entity.getProperty("createDate") );
		cir.setUpdateDate( (Date)entity.getProperty("updateDate") );

		cir.setTitle( ( (Text)entity.getProperty("title") ).getValue() );
		cir.setImage( ( (Blob)entity.getProperty("image") ).getBytes() );

		try {
			cir.setThumbnail( ( (Blob)entity.getProperty("thumbnail") ).getBytes() );
		}catch(Exception e) {
			cir.setThumbnail(createThumbnail(cir.getImage() ) );
		}

		cir.setXml(blobToString( (Blob)entity.getProperty("xml") ) );
		cir.setPrivate( (Boolean)entity.getProperty("private") );

		User user = userCache.get(KeyFactory.
				keyToString(entity.getKey().getParent() ), true);
		cir.setUser(user);

		return cir;
	}

	private User entityToUser(Entity entity) throws Exception {

		User user = new User();
		user.setUserId(entity.getKey().getName() );
		user.setNickname( (String)entity.getProperty("nickname") );
		user.setUrl( (String)entity.getProperty("url") );

		// TODO
		try {
			user.setToolboxListXml(
				blobToString( (Blob)entity.getProperty("toolboxListXml") ) );
		} catch(Exception e) {
			user.setToolboxListXml("");
		}
		
		return user;
	}
	
	private void checkOwner(String keyString) throws Exception {
		Key key = KeyFactory.stringToKey(keyString);
		if (!key.getParent().equals(getCurrentUserKey() ) ) {
			throw new EntityNotFoundException(key);
		}
	}

	private Blob imgToBlob(String img) throws Exception {
		return new Blob(Base64.decode(img.getBytes("ISO-8859-1") ) );
	}
	
	private Blob stringToBlob(String s) throws Exception {
		return new Blob(Util.compress(s.getBytes(CHAR_ENCODING) ) );
	}

	private String blobToString(Blob b) throws Exception {
		return new String(Util.uncompress( b.getBytes() ), CHAR_ENCODING);	
	}

	private byte[] createThumbnail(byte[] imageData) {
		Image image = ImagesServiceFactory.makeImage(imageData);
		ImagesService is = ImagesServiceFactory.getImagesService();
		Transform transform = ImagesServiceFactory.makeResize(
				image.getWidth() / 5, 
				image.getHeight() / 5);
		return is.applyTransform(transform, image).getImageData();
	}
}

