package com.d_project.simcir.datastore;

import com.d_project.simcir.datastore.impl.MemcacheSimcirstoreService;
import com.d_project.simcir.datastore.impl.SimcirstoreServiceGAE;

/**
 * SimcirstoreServiceFactory
 * @author kazuhiko arase
 */
public class SimcirstoreServiceFactory {
	
	private SimcirstoreServiceFactory() {
	}
	
	public static SimcirstoreService getSimcirstoreService() {
		return new MemcacheSimcirstoreService(
				new SimcirstoreServiceGAE() );
	}
}
