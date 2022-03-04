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

import dao.ChecklistAlarmDaoImpl;
import mes.model.ChecklistAlarm;
import mes.model.ChecklistSign;
import mes.service.ChecklistAlarmService;
import utils.FormatTransformer;

@WebServlet("/checklist_alarm")
public class ChecklistAlarmController extends HttpServlet {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	static final Logger logger = 
			Logger.getLogger(ChecklistAlarmController.class.getName());
	
	public void doGet(HttpServletRequest req, HttpServletResponse res) 
			throws ServletException, IOException {
		HttpSession session = req.getSession();
		String bizNo = (String) session.getAttribute("bizNo");
		ChecklistAlarmService cldService = new ChecklistAlarmService(new ChecklistAlarmDaoImpl(), bizNo);
		List<ChecklistAlarm> clAlarmList = cldService.select();
		//ChecklistAlarm clAlarm = cldService.select();
		String result = FormatTransformer.toJson(clAlarmList);
		
		res.setContentType("application/json; charset=UTF-8");
		PrintWriter out = res.getWriter();
		out.print(result);
	}

	public void doPost(HttpServletRequest req, HttpServletResponse res) 
			throws ServletException, IOException {
		HttpSession session = req.getSession();
		String bizNo = (String) session.getAttribute("bizNo");
		ChecklistAlarmService cldService = new ChecklistAlarmService(new ChecklistAlarmDaoImpl(), bizNo);
		List<ChecklistSign> clSignList = cldService.select2();
		String result = FormatTransformer.toJson(clSignList);
		
		res.setContentType("application/json; charset=UTF-8");
		PrintWriter out = res.getWriter();
		out.print(result);

	}
}
