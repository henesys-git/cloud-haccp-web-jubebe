package controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;

import mes.dao.CCPDataDaoImpl;
import mes.model.CCPData;
import mes.service.CCPDataService;

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
		String ccpType = req.getParameter("ccpType");
		String startDate = req.getParameter("startDate");
		String endDate = req.getParameter("endDate");
		
		CCPDataService ccpService = new CCPDataService(new CCPDataDaoImpl());
		List<CCPData> listCCPData = ccpService.getCCPData(ccpType, startDate, endDate);
		String result = ccpService.getListAsJson(listCCPData);
		
		res.setContentType("application/json; charset=UTF-8");
		PrintWriter out = res.getWriter();

		logger.debug(result);
			
		out.print(result);
	}
}
