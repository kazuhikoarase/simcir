package com.d_project.simcir.filter;

import javax.servlet.Filter;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;

/**
 * FilterBase
 * @author kazuhiko arase
 */
public abstract class FilterBase implements Filter {

	protected FilterConfig config;

	protected FilterBase() {
	}

	public void init(FilterConfig config) throws ServletException {
		this.config = config;
	}

	public void destroy() {
	}
}