package com.d_project.simcir.servlet;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.*;

/**
 * SimcirServlet
 * @author kazuhiko arase
 */
@SuppressWarnings("serial")
public class SimcirServlet extends HttpServlet {

	public SimcirServlet() {
	}
	
	@Override
	protected void service(HttpServletRequest request, HttpServletResponse response)
	throws ServletException, IOException {
		String path = "/WEB-INF/pages" + request.getServletPath() + ".jspx";
		getServletContext().
			getRequestDispatcher(path).
			forward(request, response);
	}
}
