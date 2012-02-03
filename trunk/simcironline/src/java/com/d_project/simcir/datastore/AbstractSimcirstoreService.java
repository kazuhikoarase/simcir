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
		return putUser(null, nickname, url, null, false);
	}

	public void putToolboxList(String toolboxListXml) throws Exception {

		// trim
		Document doc = Util.parseDocument(toolboxListXml);
		if (doc.getDocumentElement().hasChildNodes() ) {
			toolboxListXml = Util.toXMLString(doc);
		} else {
			toolboxListXml = "";
		}
		
		putUser(null, null, null, toolboxListXml, false);
	}
}
