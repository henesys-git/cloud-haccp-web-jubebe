package controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.log4j.Logger;

import dao.CCPDataDaoImpl;
import dao.CCPSignDaoImpl;
import mes.frame.database.JDBCConnectionPool;
import service.CCPDataService;
import service.CCPSignService;

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
		
		String sensorKey = req.getParameter("sensorKey");
		String createTime = req.getParameter("createTime");
		String improvementAction = req.getParameter("improvementAction");
		String date = req.getParameter("date");
		String processCode = req.getParameter("processCode");
		
		CCPDataService ccpService = new CCPDataService(new CCPDataDaoImpl(), new CCPSignDaoImpl(), tenantId);
		Boolean fixed = ccpService.fixLimitOut(sensorKey, createTime, improvementAction, date, processCode);
		String result = fixed.toString();

		res.setContentType("text/html; charset=UTF-8");
		PrintWriter out = res.getWriter();
		out.print(result);
	}
}
