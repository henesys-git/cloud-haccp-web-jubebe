package mes.frame.servlet;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;
import mes.subserver.MetalDetector;

public class MetalDetectorStatusService extends HttpServlet { 
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	static final Logger logger = 
			Logger.getLogger(MetalDetectorStatusService.class.getName());
	
	public void doPut(HttpServletRequest req, HttpServletResponse res) 
			throws ServletException, IOException {
		res.setContentType("text/html;charset=UTF-8");
		PrintWriter out = res.getWriter();

		logger.debug("[Metal Detector] changing status");
		System.out.println(req.getParameterMap());
		String mode;
		if(req.getParameter("mode") != null) {
			mode = (String) req.getParameter("mode");
			logger.debug("[Metal Detector] GET PARAMETER NOT NULL : " + mode);
		} else {
			logger.error("[Metal Detector] GET PARAMETER NULL");
			out.print("15");
			return;
		}
		
		MetalDetector md = new MetalDetector();
		String result = md.changeMode(mode);
		
		out.print(result);
	}

	public void doGet(HttpServletRequest req, HttpServletResponse res) 
			throws ServletException, IOException {
		res.setContentType("text/html;charset=UTF-8");
		PrintWriter out = res.getWriter();
		
		logger.debug("[Metal Detector] changing status");
		System.out.println(req.getParameterMap());
		String mode;
		if(req.getParameter("mode") != null) {
			mode = (String) req.getParameter("mode");
			logger.debug("[Metal Detector] GET PARAMETER NOT NULL : " + mode);
		} else {
			logger.error("[Metal Detector] GET PARAMETER NULL");
			out.print("15");
			return;
		}
		
		MetalDetector md = new MetalDetector();
		String result = md.changeMode(mode);
		
		out.print(result);
	}
}