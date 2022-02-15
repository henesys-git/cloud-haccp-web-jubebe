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

import dao.EventInfoDaoImpl;
import model.EventInfo;
import service.EventInfoService;
import utils.FormatTransformer;


@WebServlet("/rpi/value/judge")
public class OnPacketReceiveController extends HttpServlet {
	
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	static final Logger logger = 
			Logger.getLogger(OnPacketReceiveController.class.getName());
	
	public void doGet(HttpServletRequest req, HttpServletResponse res) 
			throws ServletException, IOException {
		HttpSession session = req.getSession();
		String bizNo = (String) session.getAttribute("bizNo");
		
		if(bizNo == null) {
			bizNo = req.getParameter("bizNo");
		}
		
		String code = req.getParameter("code");
		double value = Double.parseDouble(req.getParameter("value"));
		
		EventInfoService eventInfoService = new EventInfoService(new EventInfoDaoImpl(), bizNo);
		EventInfo eventInfo = eventInfoService.getEventInfoByCode(code);
		boolean isLimitOut = eventInfoService.isLimitOut(eventInfo, value);
		eventInfo.setIsLimitOut(isLimitOut);
		
		res.setContentType("application/json; charset=UTF-8");
		PrintWriter out = res.getWriter();
		
		out.print( FormatTransformer.toJson(eventInfo) );
	}

	public void doPost(HttpServletRequest req, HttpServletResponse res) 
			throws ServletException, IOException {
		logger.error("post request not supported");
	}
}
