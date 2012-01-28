package com.d_project.simcir.datastore.impl;

import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.Date;
import java.util.List;

import org.w3c.dom.Document;

import com.d_project.simcir.Util;
import com.d_project.simcir.datastore.AbstractSimcirstoreService;
import com.d_project.simcir.datastore.Circuit;
import com.d_project.simcir.datastore.CircuitList;
import com.d_project.simcir.datastore.Library;
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
public class SimcirstoreServiceGAE extends AbstractSimcirstoreService {
	
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
	
	public void deleteCircuit(String circuitKey) throws Exception {

		checkOwner(circuitKey);

		DatastoreService ds = DatastoreServiceFactory.getDatastoreService();
		
		Key key = KeyFactory.stringToKey(circuitKey);
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
/*
	private Set<Key> getReferrenceKeys(Document doc) throws Exception {
		NodeList urls = Util.getDeviceRefUrls(doc);
		Set<Key> keys = new HashSet<Key>();
		for (int i = 0; i < urls.getLength(); i += 1) {
			Key key = extractKey(urls.item(i).getNodeValue() );
			if (key != null) {
				keys.add(key);
			}
		}
		return keys;
	}

	private Key extractKey(String url) {
		try {
			Matcher mat = Pattern.compile("^.*key=(\\w+).*$").matcher(url);
			if (mat.find() ) {
				return KeyFactory.stringToKey(mat.group(1) );
			}
		} catch(Exception e) {
			// ignore
		}
		return null;
	}
	*/
	public Circuit putCircuit(
		String circuitKey,
		String title,
		String xml,
		String image,
		String thumbnail,
		boolean _private,
		boolean showNonVisuals
	) throws Exception {

		DatastoreService ds = DatastoreServiceFactory.getDatastoreService();

		Date date = new Date();
		Entity entity;
		
		if (!Util.isEmpty(circuitKey) ) {
			checkOwner(circuitKey);
			entity = ds.get(KeyFactory.stringToKey(circuitKey) );
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
		entity.setProperty("image", verifyImage(imgToBlob(image), 800, 450) );
		entity.setProperty("thumbnail", verifyImage(imgToBlob(thumbnail), 160, 90) );
		entity.setProperty("private", _private);
		entity.setProperty("showNonVisuals", showNonVisuals);

		Key key = ds.put(entity);

		Circuit circuit = entityToCircuit(ds, entity);
		circuit.setKey(KeyFactory.keyToString(key) );
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

		DatastoreService ds = DatastoreServiceFactory.getDatastoreService();
		Circuit circuit = entityToCircuit(ds, ds.get(KeyFactory.stringToKey(circuitKey) ) );

		if (circuit.isPrivate() ) {
			checkOwner(circuitKey);
		}
		
		return circuit;
	}

	public void deleteLibrary(String libraryKey) throws Exception {

		checkOwner(libraryKey);
		
		DatastoreService ds = DatastoreServiceFactory.getDatastoreService();
		
		Key key = KeyFactory.stringToKey(libraryKey);
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

	public void putLibrary(String circuitKey) throws Exception {

		DatastoreService ds = DatastoreServiceFactory.getDatastoreService();

		Date date = new Date();

		Entity entity = new Entity(KIND_LIBRARY, getCurrentUserKey() );
		entity.setProperty("addedDate", date);
		entity.setProperty("key", KeyFactory.stringToKey(circuitKey) );

		ds.put(entity);
	}

	public User getUser(boolean useCache) throws Exception {
		try {
			User user = getUser(getCurrentUserId(), useCache);
			// TODO
			if (Util.isEmpty(user.getEmail() ) ) {
				UserService us = UserServiceFactory.getUserService();
				com.google.appengine.api.users.User cu = us.getCurrentUser();
				user.setEmail(cu.getEmail() );
			}
			return user;
		} catch(EntityNotFoundException e) {
			// put default.
			UserService us = UserServiceFactory.getUserService();
			com.google.appengine.api.users.User cu = us.getCurrentUser();
			return putUser(cu.getEmail(), cu.getEmail(), "", "", true);
		}
	}
	
	public User getUser(String userId, boolean useCache) throws Exception {
		DatastoreService ds = DatastoreServiceFactory.getDatastoreService();
		return entityToUser(ds.get(KeyFactory.createKey(KIND_USER, userId) ) );
	}

	public User putUser(
		String email,
		String nickname,
		String url, 
		String toolboxListXml,
		boolean newUser
	) throws Exception {

		DatastoreService ds = DatastoreServiceFactory.getDatastoreService();
		
		Entity entity = new Entity(getCurrentUserKey() );
		entity.setProperty("email", email);
		entity.setProperty("nickname", nickname);
		entity.setProperty("url", url);
		entity.setProperty("toolboxListXml",
				stringToBlob(toolboxListXml) );
		
		Date date = new Date();
		if (newUser) {
			entity.setProperty("createDate", date);
		}
		entity.setProperty("updateDate", date);

		Key key = ds.put(entity);
		User user = entityToUser(entity);
		user.setUserId(key.getName() );
		return user;
	}

	public String getCurrentUserId() throws Exception {
		UserService us = UserServiceFactory.getUserService();
		return us.getCurrentUser().getUserId();
	}

	public boolean isUserLoggedIn() throws Exception {
		UserService us = UserServiceFactory.getUserService();
		return us.isUserLoggedIn();
	}

	public String createLogoutURL(String url) throws Exception {
		UserService us = UserServiceFactory.getUserService();
		return us.createLogoutURL(url);
	}
	
	public void checkOwner(String circuitKey) throws Exception {
		Key key = KeyFactory.stringToKey(circuitKey);
		if (!key.getParent().equals(getCurrentUserKey() ) ) {
			throw new EntityNotFoundException(key);
		}
	}

	private Key getCurrentUserKey() throws Exception {
		return KeyFactory.createKey(KIND_USER, getCurrentUserId() );
	}

	private Library entityToLibrary(DatastoreService ds, Entity entity) throws Exception {
		
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
		cir.setPrivate(toBoolean(entity.getProperty("private") ) );
		cir.setShowNonVisuals(toBoolean(entity.getProperty("showNonVisuals") ) );

		User user = getUser(entity.getKey().getParent().getName(), true);
		cir.setUser(user);

		return cir;
	}
	
	private static boolean toBoolean(Object o) {
		return (o == null)? true : ( (Boolean)o).booleanValue();
	}
	
	private User entityToUser(Entity entity) throws Exception {

		User user = new User();
		user.setUserId(entity.getKey().getName() );
		user.setEmail( (String)entity.getProperty("email") );
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

	private static Blob imgToBlob(String img) throws Exception {
		return new Blob(Base64.decode(img.getBytes("ISO-8859-1") ) );
	}
	
	private static Blob stringToBlob(String s) throws Exception {
		return new Blob(Util.compress(s.getBytes(CHAR_ENCODING) ) );
	}

	private static String blobToString(Blob b) throws Exception {
		return new String(Util.uncompress(b.getBytes() ), CHAR_ENCODING);	
	}

	private static Blob verifyImage(
		Blob imageData, int width, int height
	) throws Exception {
		Image image = ImagesServiceFactory.makeImage(imageData.getBytes() );
		if (!image.getFormat().equals(Image.Format.PNG) ||
				image.getWidth() > width ||
				image.getHeight() > height) {
			throw new Exception();
		}
		return imageData;
	}

	private static byte[] createThumbnail(byte[] imageData) {
		Image image = ImagesServiceFactory.makeImage(imageData);
		ImagesService is = ImagesServiceFactory.getImagesService();
		Transform transform = ImagesServiceFactory.makeResize(
				image.getWidth() / 5, 
				image.getHeight() / 5);
		return is.applyTransform(transform, image).getImageData();
	}
}

