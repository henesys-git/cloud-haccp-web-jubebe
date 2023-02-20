package controller;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.log4j.Logger;

import dao.CCPSignDaoImpl;
import dao.UserDaoImpl;
import model.CCPSign;
import model.User;
import service.CCPSignService;
import service.UserService;
import utils.FormatTransformer;
import viewmodel.CCPSignViewModel;

@WebServlet(urlPatterns="/ccpsign")
public class CCPSignController extends HttpServlet {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	static final Logger logger = 
			Logger.getLogger(CCPSignController.class.getName());
	
	public void doGet(HttpServletRequest req, HttpServletResponse res) 
			throws ServletException, IOException {
		HttpSession session = req.getSession();
		String tenantId = (String) session.getAttribute("bizNo");
		
		String date = req.getParameter("date");
		String processCode = req.getParameter("processCode");
		
		CCPSignService ccpService = new CCPSignService(new CCPSignDaoImpl(), tenantId);
		CCPSign ccpSign = ccpService.getCCPSignByDateAndProcessCode(date, processCode);
		
		UserService userService = new UserService(new UserDaoImpl(), tenantId);
		User user = userService.getUser(ccpSign.getCheckerId());
		
		CCPSignViewModel ccpSignVM = new CCPSignViewModel();
		ccpSignVM.setCheckerId(ccpSign.getCheckerId());
		ccpSignVM.setProcessCode(ccpSign.getProcessCode());
		ccpSignVM.setSignDate(ccpSign.getSignDate());
		ccpSignVM.setCheckerName(user.getUserName());
		
		String result = FormatTransformer.toJson(ccpSignVM);
		
		res.setContentType("application/json; charset=UTF-8");
		PrintWriter out = res.getWriter();
		
		out.print(result);
	}

	public void doPost(HttpServletRequest req, HttpServletResponse res) 
			throws ServletException, IOException {
		HttpSession session = req.getSession();
		String userId = (String) session.getAttribute("login_id");
		String tenantId = (String) session.getAttribute("bizNo");
		
		String date = req.getParameter("date");
		String processCode = req.getParameter("processCode");
		String signType = req.getParameter("signType");
		
		CCPSign ccpSign = new CCPSign();
		ccpSign.setCheckerId(userId);
		ccpSign.setProcessCode(processCode);
		ccpSign.setSignDate(date);
		ccpSign.setSignType(signType);
		
		CCPSignService ccpService = new CCPSignService(new CCPSignDaoImpl(), tenantId);
		String checkerName = ccpService.sign(ccpSign);
		
		res.setContentType("html/text; charset=UTF-8");
		PrintWriter out = res.getWriter();
		
		out.print(checkerName);
	}
	
	public void doPut(HttpServletRequest req, HttpServletResponse res) 
			throws ServletException, IOException {
		HttpSession session = req.getSession();
		String tenantId = (String) session.getAttribute("bizNo");
		
		String date = req.getParameter("date");
		String processCode = req.getParameter("processCode");
		
		CCPSignService ccpService = new CCPSignService(new CCPSignDaoImpl(), tenantId);
		Boolean deleted = ccpService.delete(date, processCode);
		String result = deleted.toString();
		
		res.setContentType("html/text; charset=UTF-8");
		PrintWriter out = res.getWriter();
		
		out.print(result);
	}
}
