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
import dao.CPDataDaoImpl;
import service.CCPDataService;
import service.CPDataService;
import utils.FormatTransformer;
import viewmodel.CCPDataDetailViewModel;
import viewmodel.CCPDataHeadViewModel;
import viewmodel.CCPDataMonitoringModel;
import viewmodel.CCPDataStatisticModel;
import viewmodel.CPDataHeadViewModel;
import viewmodel.CPDataMonitoringModel;

@WebServlet("/cpvm")
public class CPDataViewModelController extends HttpServlet {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	static final Logger logger = 
			Logger.getLogger(CPDataViewModelController.class.getName());
	
	public void doGet(HttpServletRequest req, HttpServletResponse res) 
			throws ServletException, IOException {
		HttpSession session = req.getSession();
		String bizNo = (String) session.getAttribute("bizNo");

		String method = req.getParameter("method");
		
		CPDataService ccpService = new CPDataService(new CPDataDaoImpl(), bizNo);
		
		String result;
		PrintWriter out;
		
		String date = "";
		String processCode = "";
		String sensorId = "";
		
		switch(method) {
		case "head":
			sensorId = req.getParameter("sensorId");
			date = req.getParameter("date");
			processCode = req.getParameter("processCode");
			
			List<CPDataHeadViewModel> cvmHeadList = ccpService.getCCPDataHeadViewModels(sensorId, date, date, processCode);
			result = FormatTransformer.toJson(cvmHeadList);
			
			res.setContentType("application/json; charset=UTF-8");
			out = res.getWriter();
			
			out.print(result);
			break;
		case "monitoring":
			List<CPDataMonitoringModel> cvmMonitoringList = ccpService.getCCPDataMonitoringModel();
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
