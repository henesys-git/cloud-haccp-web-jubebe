package controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

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
import service.DashBoardService;
import utils.FormatTransformer;
import model.DashBoard;

@WebServlet("/dashboard")
public class DashBoardController extends HttpServlet {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	static final Logger logger = 
			Logger.getLogger(DashBoardController.class.getName());
	
	public void doGet(HttpServletRequest req, HttpServletResponse res) 
			throws ServletException, IOException {
		
		HttpSession session = req.getSession();
		String tenantId = (String) session.getAttribute("bizNo");
		
		String method = req.getParameter("method");
		String result = "";
		
		if(method.equals("dashboard1Table")) {
			
			DashBoardService dashService = new DashBoardService(new DashBoardDataDaoImpl(), tenantId);
			List<DashBoard> list = dashService.getDashBoardData1Table();
			
			result = FormatTransformer.toJson(list);
			
		}
		else if(method.equals("dashboard1Graph")) {
			
			DashBoardService dashService = new DashBoardService(new DashBoardDataDaoImpl(), tenantId);
			List<DashBoard> list = dashService.getDashBoardData1Graph();
			
			result = FormatTransformer.toJson(list);
			
		} 
		else if(method.equals("dashboard2Table")) {
			
			DashBoardService dashService = new DashBoardService(new DashBoardDataDaoImpl(), tenantId);
			List<DashBoard> list = dashService.getDashBoardData2Table();
			
			result = FormatTransformer.toJson(list);
			
		}
		else if(method.equals("dashboard2Graph")) {
			
			DashBoardService dashService = new DashBoardService(new DashBoardDataDaoImpl(), tenantId);
			List<DashBoard> list = dashService.getDashBoardData2Graph();
			
			result = FormatTransformer.toJson(list);
			
		} 
		
		res.setContentType("text/html; charset=UTF-8");
		PrintWriter out = res.getWriter();
		out.print(result);
		
	}

	public void doPost(HttpServletRequest req, HttpServletResponse res) 
			throws ServletException, IOException {
		
	}
	
	public void doPut(HttpServletRequest req, HttpServletResponse res) 
			throws ServletException, IOException {
		
	}
}
