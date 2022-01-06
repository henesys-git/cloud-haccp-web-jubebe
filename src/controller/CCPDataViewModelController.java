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

import mes.dao.CCPDataDaoImpl;
import mes.service.CCPDataService;
import utils.FormatTransformer;
import viewmodel.CCPDataViewModel;

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
		doPost(req, res);
	}

	public void doPost(HttpServletRequest req, HttpServletResponse res) 
			throws ServletException, IOException {
		HttpSession session = req.getSession();
		String bizNo = (String) session.getAttribute("bizNo");
		
		String ccpType = req.getParameter("ccpType");
		String startDate = req.getParameter("startDate");
		String endDate = req.getParameter("endDate");
		
		CCPDataService ccpService = new CCPDataService(new CCPDataDaoImpl(), bizNo);
		List<CCPDataViewModel> cvmList = ccpService.getCCPDataViewModels(ccpType, startDate, endDate);
		String result = FormatTransformer.toJson(cvmList);
		
		res.setContentType("application/json; charset=UTF-8");
		PrintWriter out = res.getWriter();
			
		out.print(result);
	}
}
