package controller;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.log4j.Logger;

import dao.CCPDataDaoImpl;
import dao.CCPSignDaoImpl;
import service.CCPDataService;

@WebServlet("/ccp")
public class CCPDataController extends HttpServlet {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	static final Logger logger = 
			Logger.getLogger(CCPDataController.class.getName());
	
	public void doGet(HttpServletRequest req, HttpServletResponse res) 
			throws ServletException, IOException {
		doPost(req, res);
	}

	public void doPost(HttpServletRequest req, HttpServletResponse res) 
			throws ServletException, IOException {
		
	}
	
	public void doPut(HttpServletRequest req, HttpServletResponse res) 
			throws ServletException, IOException {
		
		HttpSession session = req.getSession();
		String tenantId = (String) session.getAttribute("bizNo");
		
		String method = req.getParameter("method");
		String sensorKey = req.getParameter("sensorKey");
		String createTime = req.getParameter("createTime");
		String improvementAction = req.getParameter("improvementAction");
		String date = req.getParameter("date");
		String date2 = req.getParameter("date2");
		String processCode = req.getParameter("processCode");
		String result = "";
		
		if(method.equals("All")) {
			
			CCPDataService ccpService = new CCPDataService(new CCPDataDaoImpl(), new CCPSignDaoImpl(), tenantId);
			Boolean fixed = ccpService.fixLimitOutAll(improvementAction, date, date2, processCode);
			result = fixed.toString();
			
		}
		else {
			
			CCPDataService ccpService = new CCPDataService(new CCPDataDaoImpl(), new CCPSignDaoImpl(), tenantId);
			Boolean fixed = ccpService.fixLimitOut(sensorKey, createTime, improvementAction, date, processCode);
			result = fixed.toString();
			
		}
		

		res.setContentType("text/html; charset=UTF-8");
		PrintWriter out = res.getWriter();
		out.print(result);
	}
}
