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
	
	public SimcirstoreServiceGAE() {
	}

	public CircuitList getRecentCircuitList(int currentPage) throws Exception {

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
			list.add(entityToCircuit(ds, entity) );
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
			list.add(entityToCircuit(ds, entity) );
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

	public String putCircuit(
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

		// set title
		Document doc = Util.parseDocument(xml);
		doc.getDocumentElement().setAttribute("title", title);
		xml = Util.toXMLString(doc);
		
		entity.setProperty("updateDate", date);
		entity.setProperty("title", new Text(title) );
		entity.setProperty("xml", stringToBlob(xml) );
		entity.setProperty("image", imgToBlob(image) );
		entity.setProperty("thumbnail", imgToBlob(thumbnail) );
		entity.setProperty("private", isPrivate);
		
		Key newKey = ds.put(entity);

		return KeyFactory.keyToString(newKey);
	}

	public Circuit getCircuit(String keyString) throws Exception {

		DatastoreService ds = DatastoreServiceFactory.getDatastoreService();
		
		if (!Util.isEmpty(keyString) ) {
			Circuit circuit = entityToCircuit(ds, ds.get(KeyFactory.stringToKey(keyString) ) );
			if (circuit.isPrivate() ) {
				checkOwner(keyString);
			}
			return circuit;
		}

		return null;
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
			} catch(EntityNotFoundException e) {
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

		Key newKey = ds.put(entity);

		return KeyFactory.keyToString(newKey);
	}

	public User getUser() throws Exception {

		UserService us = UserServiceFactory.getUserService();
		com.google.appengine.api.users.User cu = us.getCurrentUser();

		try {
			return getUser(KeyFactory.createKey(KIND_USER, cu.getUserId() ) );
		} catch(EntityNotFoundException e) {

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
	
	private User getUser(Key userKey) throws Exception {
		DatastoreService ds = DatastoreServiceFactory.getDatastoreService();
		return entityToUser(ds.get(userKey) );
	}
	
	public String putUser(String nickname, String url) throws Exception {
		User user = getUser();
		user.setNickname(nickname);
		user.setUrl(url);
		return putUser(user, false);
	}
	
	private String putUser(User user, boolean newUser) throws Exception {

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
		
		return KeyFactory.keyToString(ds.put(entity) );
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
		
		User user = getUser();
		user.setToolboxListXml(toolboxListXml);
		putUser(user, false);
	}

	private Key getCurrentUserKey() throws Exception {
		UserService us = UserServiceFactory.getUserService();
		com.google.appengine.api.users.User cu = us.getCurrentUser();
		return KeyFactory.createKey(KIND_USER, cu.getUserId() );
	}

	private Library entityToLibrary(
		DatastoreService ds,
		Entity entity
	) throws Exception {
		
		String circuitKeyString = KeyFactory.keyToString( (Key)entity.getProperty("key") );
		Circuit circuit = getCircuit(circuitKeyString);
		
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
		
		// TODO
		try {
			cir.setThumbnail( ( (Blob)entity.getProperty("thumbnail") ).getBytes() );
		}catch(Exception e) {
			cir.setThumbnail(new byte[0]);
		}

		cir.setXml(blobToString( (Blob)entity.getProperty("xml") ) );
		cir.setPrivate( (Boolean)entity.getProperty("private") );

		User user = getUser(entity.getKey().getParent() );
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
			throw new Exception("not owner");
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
}

