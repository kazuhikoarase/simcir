package com.d_project.simcir.filter;

import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;

import javax.servlet.FilterChain;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * DefaultFilter
 * @author kazuhiko arase
 */
public class DefaultFilter extends FilterBase {

	public void doFilter(ServletRequest servletRequest, ServletResponse servletResponse, FilterChain chain) throws IOException, ServletException {

		HttpServletRequest request = (HttpServletRequest)servletRequest;
		HttpServletResponse response = (HttpServletResponse)servletResponse;
		
		response.setHeader("Cache-Control", "no-cache");
		response.setHeader("Pragma", "no-cache");
		response.setIntHeader("Expires", 0);
		
		request.setCharacterEncoding("UTF-8");

		String timestamp = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss.SSS").format(new Date() );
		StringBuffer url = request.getRequestURL();
		String query = request.getQueryString();
		if (query != null) {
			url.append('?');
			url.append(query);
		}
		System.out.println(timestamp + " - " + url);

		chain.doFilter(request, response);
	}
}