package shm;

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

import shm.dao.CCPDataDaoImpl;
import shm.service.CCPDataService;
import shm.viewmodel.CCPDataDetailViewModel;
import shm.viewmodel.CCPDataHeadViewModel;
import utils.FormatTransformer;

@WebServlet("/shm/ccpvm")
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
		
		String date = "";
		String processCode = "";
		String sensorId = "";
		
		switch(method) {
		case "head":
			sensorId = req.getParameter("sensorId");
			date = req.getParameter("date");
			processCode = req.getParameter("processCode");
			
			List<CCPDataHeadViewModel> cvmHeadList = ccpService.getCCPDataHeadViewModels(sensorId, date, date, processCode);
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
		}
	}

	public void doPost(HttpServletRequest req, HttpServletResponse res) 
			throws ServletException, IOException {
		doGet(req, res);
	}
}
