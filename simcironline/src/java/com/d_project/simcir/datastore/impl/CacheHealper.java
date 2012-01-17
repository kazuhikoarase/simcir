package com.d_project.simcir.datastore.impl;


/**
 * CacheHelper
 * @author kazuhiko arase
 */
interface CacheHelper<K,V> {
	
	public V get(K key, boolean useCache) throws Exception;
	
	public K put(K key, V value) throws Exception;
}
