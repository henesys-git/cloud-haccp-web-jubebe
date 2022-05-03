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
import service.CCPDataService;
import utils.FormatTransformer;
import viewmodel.CCPTestDataHeadViewModel;
import viewmodel.CCPTestDataViewModel;

@WebServlet("/ccptestvm")
public class CCPTestDataViewModelController extends HttpServlet {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	static final Logger logger = 
			Logger.getLogger(CCPTestDataViewModelController.class.getName());
	
	public void doGet(HttpServletRequest req, HttpServletResponse res) 
			throws ServletException, IOException {
		HttpSession session = req.getSession();
		String bizNo = (String) session.getAttribute("bizNo");

		String method = req.getParameter("method");
		
		CCPDataService ccpService = new CCPDataService(new CCPDataDaoImpl(), bizNo);
		
		String result;
		PrintWriter out;
		
		String date = "";
		String startDate = "";
		String endDate = "";
		String processCode = "";
		String sensorId = "";
		
		switch(method) {
		case "head":
			startDate = req.getParameter("startDate");
			endDate = req.getParameter("endDate");
			
			List<CCPTestDataHeadViewModel> cvmHeadList = ccpService.getCCPTestDataHead(startDate, endDate);
			result = FormatTransformer.toJson(cvmHeadList);
			
			res.setContentType("application/json; charset=UTF-8");
			out = res.getWriter();
			
			out.print(result);
			break;
		case "detail":
			date = req.getParameter("date");
			processCode = req.getParameter("processCode");
			sensorId = req.getParameter("sensorId");
			
			List<CCPTestDataViewModel> testDataList = ccpService.getCCPTestData(date, processCode, sensorId);
			result = FormatTransformer.toJson(testDataList);
			
			res.setContentType("application/json; charset=UTF-8");
			out = res.getWriter();
			
			out.print(result);
			break;
		}
	}

	public void doPost(HttpServletRequest req, HttpServletResponse res) 
			throws ServletException, IOException {
		doGet(req, res);
	}
}
