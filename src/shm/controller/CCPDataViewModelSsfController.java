package shm.controller;

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

import shm.dao.SsfKPIDaoImpl;
import shm.service.CCPDataSsfService;
import shm.viewmodel.SsfKpiLevel2;
import utils.FormatTransformer;

@WebServlet("/ssf/ccpvm")
public class CCPDataViewModelSsfController extends HttpServlet {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	static final Logger logger = 
			Logger.getLogger(CCPDataViewModelSsfController.class.getName());
	
	public void doGet(HttpServletRequest req, HttpServletResponse res) 
			throws ServletException, IOException {
		HttpSession session = req.getSession();
		String bizNo = (String) session.getAttribute("bizNo");

		CCPDataSsfService ccpService = new CCPDataSsfService(new SsfKPIDaoImpl(), bizNo);
		
		String result;
		PrintWriter out;
		
		List<SsfKpiLevel2> list = ccpService.getCCPDataViewModels();
		result = FormatTransformer.toJson(list);
		
		res.setContentType("application/json; charset=UTF-8");
		out = res.getWriter();
		
		out.print(result);
	}

	public void doPost(HttpServletRequest req, HttpServletResponse res) 
			throws ServletException, IOException {
		doGet(req, res);
	}
}
