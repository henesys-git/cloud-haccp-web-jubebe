package web.exceptions;

import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;

//Extend HttpServlet class
public class ErrorHandler extends HttpServlet {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	public void doGet(HttpServletRequest request, HttpServletResponse response)
	   throws ServletException, IOException {
	   
	   Throwable throwable = (Throwable)
	   request.getAttribute("javax.servlet.error.exception");
	   Integer statusCode = (Integer)
	   request.getAttribute("javax.servlet.error.status_code");
	   String servletName = (String)
	   request.getAttribute("javax.servlet.error.servlet_name");
	      
	   if (servletName == null) {
	      servletName = "Unknown";
	   }
	   String requestUri = (String)
	   request.getAttribute("javax.servlet.error.request_uri");
	   
	   if (requestUri == null) {
	      requestUri = "Unknown";
	   }
	
	   response.setContentType("text/html; charset=UTF-8");
	   response.setCharacterEncoding("UTF-8");
	
	   PrintWriter out = response.getWriter();
	   String title = "에러 발생";
	   String docType = "<!doctype html>\n";
	      
	   out.println(docType +
	      "<html>\n" +
	      "<meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\"/>\n" + 
	      "<head><title>" + title + "</title></head>\n" +
	      "<body bgcolor = \"#f0f0f0\">\n");
	
	   if (throwable == null && statusCode == null) {
	      out.println("<h2>불분명한 에러 발생</h2>");
	      out.println("관리자에게 문의해 주세요");
	      out.println("<a href='#' onclick='window.close()'>창 닫기</a>");
	   } else if (statusCode != null) {
	      out.println("The status code : " + statusCode);
	   } else {
	      out.println("<h2>에러 상세</h2>");
	      out.println("Servlet Name : " + servletName + "</br></br>");
	      out.println("Exception Type : " + throwable.getClass( ).getName( ) + "</br></br>");
	      out.println("The request URI: " + requestUri + "<br><br>");
	      out.println("The exception message: " + throwable.getMessage( ));
	   }
	   out.println("</body>");
	   out.println("</html>");
	}
	
	public void doPost(HttpServletRequest request, HttpServletResponse response)
	   throws ServletException, IOException {
	   
	   doGet(request, response);
	}
}