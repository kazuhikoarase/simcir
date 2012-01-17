package com.d_project.simcir.datastore.impl;

import com.google.appengine.api.memcache.Expiration;
import com.google.appengine.api.memcache.MemcacheService;
import com.google.appengine.api.memcache.MemcacheServiceFactory;

/**
 * MemcacheHelper
 * @author kazuhiko arase
 */
@SuppressWarnings("unchecked")
abstract class MemcacheHelper<K,V> implements CacheHelper<K,V> {
	
	private static int getCount = 0;
	private static int hitCount = 0;
	
	private String keyPrefix;

	public MemcacheHelper(String keyPrefix) {
		this.keyPrefix = keyPrefix;
	}

	protected abstract V get(K key) throws Exception;

	protected void updateCache(V value) throws Exception {
	}

	public V get(K key, boolean useCache) throws Exception {
		
		if (key == null) {
			throw new NullPointerException();
		}
		
		MemcacheService ms = MemcacheServiceFactory.getMemcacheService();

		V value = null;
		
		if (useCache) {
			// attempt to get from memcache.
			value = (V)ms.get(createCacheKey(key) );
		}

/*		
		getCount += 1;
		if (value != null) {
			hitCount += 1;
		}
		System.out.println(getCount + "/" + hitCount);
*/

		if (value == null) {

			// no data in cache. get from source
			value = get(key);
			if (value == null) {
				throw new NullPointerException();
			}
			
			// put into cache
			put(key, value);

		} else {
			updateCache(value);
		}
		
		return value;
	}

	public K put(K key, V value) throws Exception {

		if (key == null) {
			throw new NullPointerException();
		}

		MemcacheService ms = MemcacheServiceFactory.getMemcacheService();
		ms.put(createCacheKey(key), value, Expiration.byDeltaSeconds(60) );
		return key;
	}
	
	private Object createCacheKey(K key) {
		return keyPrefix + "." + key;
	}
}
