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
import viewmodel.CCPDataDetailViewModel;
import viewmodel.CCPDataHeadViewModel;
import viewmodel.CCPDataMonitoringModel;
import viewmodel.CCPDataStatisticModel;

@WebServlet("/ccpvm")
public class CCPDataViewModelController extends HttpServlet {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	static final Logger logger = 
			Logger.getLogger(CCPDataViewModelController.class.getName());
	
	public void doGet(HttpServletRequest req, HttpServletResponse res) 
			throws ServletException, IOException {
		HttpSession session = req.getSession();
		String bizNo = (String) session.getAttribute("bizNo");

		String method = req.getParameter("method");
		
		CCPDataService ccpService = new CCPDataService(new CCPDataDaoImpl(), bizNo);
		
		String result;
		PrintWriter out;
		
		switch(method) {
		case "head":
			String ccpType = req.getParameter("ccpType");
			String startDate = req.getParameter("startDate");
			String endDate = req.getParameter("endDate");
			
			List<CCPDataHeadViewModel> cvmHeadList = ccpService.getCCPDataHeadViewModels(ccpType, startDate, endDate);
			result = FormatTransformer.toJson(cvmHeadList);
			
			res.setContentType("application/json; charset=UTF-8");
			out = res.getWriter();
			
			out.print(result);
			break;
		case "detail":
			String sensorKey = req.getParameter("sensorKey");
			
			List<CCPDataDetailViewModel> cvmDetailList = ccpService.getCCPDataDetailViewModels(sensorKey);
			result = FormatTransformer.toJson(cvmDetailList);
			
			res.setContentType("application/json; charset=UTF-8");
			out = res.getWriter();
			
			out.print(result);
			break;
		case "statistic":
			String toDate = req.getParameter("toDate");
			String sensorId = req.getParameter("sensorId");
			
			List<CCPDataStatisticModel> cvmStatisticList = ccpService.getCCPDataStatisticModel(toDate, sensorId);
			result = FormatTransformer.toJson(cvmStatisticList);
			
			res.setContentType("application/json; charset=UTF-8");
			out = res.getWriter();
			
			out.print(result);
			break;
		case "monitoring":
			String toDay = req.getParameter("toDay");
			
			List<CCPDataMonitoringModel> cvmMonitoringList = ccpService.getCCPDataMonitoringModel(toDay);
			result = FormatTransformer.toJson(cvmMonitoringList);
			
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
