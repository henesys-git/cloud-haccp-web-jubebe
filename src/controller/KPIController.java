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
import service.KPIService;
import utils.FormatTransformer;
import viewmodel.KPIProductionViewModel;
import viewmodel.KPIQualityViewModel;

@WebServlet("/kpi")
public class KPIController extends HttpServlet {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	static final Logger logger = 
			Logger.getLogger(KPIController.class.getName());
	
	public void doGet(HttpServletRequest req, HttpServletResponse res) 
			throws ServletException, IOException {
		HttpSession session = req.getSession();
		String bizNo = (String) session.getAttribute("bizNo");

		String method = req.getParameter("method");
		
		KPIService kpiService = new KPIService(new CCPDataDaoImpl(), bizNo);
		
		String result;
		PrintWriter out;
		
		String date = "";
		String processCode = "";
		String sensorId = "";
		
		switch(method) {
		case "production":
			date = req.getParameter("date");
			processCode = req.getParameter("processCode");
			
			List<KPIProductionViewModel> cvmHeadList = kpiService.getKPIProductionViewModels(processCode, date, date);
			result = FormatTransformer.toJson(cvmHeadList);
			
			res.setContentType("application/json; charset=UTF-8");
			out = res.getWriter();
			
			out.print(result);
			break;
		case "quality":
			date = req.getParameter("date");
			processCode = req.getParameter("processCode");
			sensorId = req.getParameter("sensorId");
			
			List<KPIQualityViewModel> cvmHeadList2 = kpiService.getKPIQualityViewModels(processCode, date, date, sensorId);
			result = FormatTransformer.toJson(cvmHeadList2);
			
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
