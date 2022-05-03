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
import dao.ChecklistInfoDaoImpl;
import mes.model.ChecklistAlarm;
import mes.service.ChecklistAlarmService;
import model.ChecklistInfo;
import service.ChecklistInfoService;
import utils.FormatTransformer;

@WebServlet("/document-info")
public class DocumentInfoController extends HttpServlet {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	static final Logger logger = 
			Logger.getLogger(DocumentInfoController.class.getName());
	
	public void doGet(HttpServletRequest req, HttpServletResponse res) 
			throws ServletException, IOException {
		HttpSession session = req.getSession();
		String bizNo = (String) session.getAttribute("bizNo");
		
		String id = req.getParameter("id");
		
		ChecklistInfoService cldService = new ChecklistInfoService(new ChecklistInfoDaoImpl(), bizNo);
		
		String result = "";
		
		if(id.equals("all")) {
			List<ChecklistInfo> list = cldService.selectAll();
			result = FormatTransformer.toJson(list);
		} else {
			ChecklistInfo clInfo = cldService.select(id);
			result = FormatTransformer.toJson(clInfo);
		}
		
		res.setContentType("application/json; charset=UTF-8");
		PrintWriter out = res.getWriter();
		
		out.print(result);
	}

	public void doPost(HttpServletRequest req, HttpServletResponse res) 
			throws ServletException, IOException {
		
		if(req.getParameter("type").equals("insert")) {
			insert(req, res);
		}
		
		if(req.getParameter("type").equals("update")) {
			update(req, res);
		}
		
		if(req.getParameter("type").equals("delete")) {
			delete(req, res);
		}
		
		if(req.getParameter("type").equals("alarm")) {
			alarm(req, res);
		}
	}
	
	private void insert(HttpServletRequest req, HttpServletResponse res) {
		HttpSession session = req.getSession();
		String tenantId = (String) session.getAttribute("bizNo");
		
		ChecklistInfo clInfo = new ChecklistInfo(
				req.getParameter("id"),
				0,
				req.getParameter("name"),
				req.getParameter("imagePath"),
				req.getParameter("metaDataFilePath")
				);
		
		ChecklistInfoService clService = new ChecklistInfoService(new ChecklistInfoDaoImpl(), tenantId);
		Boolean inserted = clService.insert(clInfo);
		
		res.setContentType("html/text; charset=UTF-8");
		
		try {
			PrintWriter out = res.getWriter();
			out.print(inserted.toString());
		} catch(Exception e) {
			e.printStackTrace();
		}
	}

	private void update(HttpServletRequest req, HttpServletResponse res) {
		HttpSession session = req.getSession();
		String tenantId = (String) session.getAttribute("bizNo");
		
		ChecklistInfo clInfo = new ChecklistInfo(
				req.getParameter("id"),
				req.getParameter("name"),
				req.getParameter("imagePath"),
				req.getParameter("metaDataFilePath")
				);
		
		ChecklistInfoService clService = new ChecklistInfoService(new ChecklistInfoDaoImpl(), tenantId);
		Boolean updated = clService.update(clInfo);
		
		res.setContentType("html/text; charset=UTF-8");
		
		try {
			PrintWriter out = res.getWriter();
			out.print(updated.toString());
		} catch(Exception e) {
			e.printStackTrace();
		}
	}
	
	private void delete(HttpServletRequest req, HttpServletResponse res) {
		HttpSession session = req.getSession();
		String tenantId = (String) session.getAttribute("bizNo");
		
		String checklistId = req.getParameter("id");
		
		ChecklistInfoService clService = new ChecklistInfoService(new ChecklistInfoDaoImpl(), tenantId);
		Boolean deleted = clService.delete(checklistId);
		
		res.setContentType("html/text; charset=UTF-8");
		
		try {
			PrintWriter out = res.getWriter();
			out.print(deleted.toString());
		} catch(Exception e) {
			e.printStackTrace();
		}
		
	}
	
	private void alarm(HttpServletRequest req, HttpServletResponse res) {
		HttpSession session = req.getSession();
		String tenantId = (String) session.getAttribute("bizNo");
		
		ChecklistAlarm clAlarm = new ChecklistAlarm(
				req.getParameter("id"),
				req.getParameter("alarmInterval")
				);
		
		ChecklistAlarmService clService = new ChecklistAlarmService(new ChecklistAlarmDaoImpl(), tenantId);
		Boolean alarmDoned = clService.alarm(clAlarm);
		
		res.setContentType("html/text; charset=UTF-8");
		
		try {
			PrintWriter out = res.getWriter();
			out.print(alarmDoned.toString());
		} catch(Exception e) {
			e.printStackTrace();
		}
		
	}
}
