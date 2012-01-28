package com.d_project.simcir.datastore;

import org.w3c.dom.Document;

import com.d_project.simcir.Util;

/**
 * AbstractSimcirstoreService
 * @author kazuhiko arase
 */
public abstract class AbstractSimcirstoreService
implements SimcirstoreService {

	protected AbstractSimcirstoreService() {
	}
	
	public User putUser(String nickname, String url) throws Exception {
		User user = getUser(false);
		return putUser(
			user.getEmail(), 
			nickname, 
			url,
			user.getToolboxListXml(), 
			false);
	}

	public void putToolboxList(String toolboxListXml) throws Exception {

		// trim
		Document doc = Util.parseDocument(toolboxListXml);
		if (doc.getDocumentElement().hasChildNodes() ) {
			toolboxListXml = Util.toXMLString(doc);
		} else {
			toolboxListXml = "";
		}
		
		User user = getUser(false);
		putUser(
			user.getEmail(),
			user.getNickname(),
			user.getUrl(),
			toolboxListXml,
			false);
	}
}
