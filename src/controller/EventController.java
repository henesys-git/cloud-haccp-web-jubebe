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

import dao.EventInfoDaoImpl;
import model.EventInfo;
import service.EventInfoService;
import utils.FormatTransformer;


@WebServlet("/event")
public class EventController extends HttpServlet {
	
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	static final Logger logger = 
			Logger.getLogger(EventController.class.getName());
	
	public void doGet(HttpServletRequest req, HttpServletResponse res) 
			throws ServletException, IOException {
		HttpSession session = req.getSession();
		String bizNo = (String) session.getAttribute("bizNo");
		
		if(bizNo == null) {
			bizNo = req.getParameter("bizNo");
		}
		
		String code = req.getParameter("code");
		
		EventInfoService eventInfoService = new EventInfoService(new EventInfoDaoImpl(), bizNo);
		
		String result = "";
		
		if(code.equals("all")) {
			List<EventInfo> list = eventInfoService.getAllEventInfo();
			result = FormatTransformer.toJson(list);
		} else {
			EventInfo eventInfo = eventInfoService.getEventInfoByCode(code);
			result = FormatTransformer.toJson(eventInfo);
		}
		
		res.setContentType("application/json; charset=UTF-8");
		PrintWriter out = res.getWriter();
		
		out.print(result);
	}

	public void doPost(HttpServletRequest req, HttpServletResponse res) 
			throws ServletException, IOException {
		HttpSession session = req.getSession();
		String bizNo = (String) session.getAttribute("bizNo");
		
		EventInfoService eventService = new EventInfoService(new EventInfoDaoImpl(), bizNo);
		Boolean inserted = eventService.insert();
		
		res.setContentType("application/json; charset=UTF-8");
		PrintWriter out = res.getWriter();
		
		out.print(inserted.toString());
	}
}
