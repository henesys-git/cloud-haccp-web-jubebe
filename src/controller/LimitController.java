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

import dao.LimitDaoImpl;
import model.Limit;
import service.LimitService;
import utils.FormatTransformer;


@WebServlet("/limit")
public class LimitController extends HttpServlet {
	
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	static final Logger logger = 
			Logger.getLogger(LimitController.class.getName());
	
	public void doGet(HttpServletRequest req, HttpServletResponse res) 
			throws ServletException, IOException {
		HttpSession session = req.getSession();
		String bizNo = (String) session.getAttribute("bizNo");
		
		if(bizNo == null) {
			bizNo = req.getParameter("bizNo");
		}
		
		String id = req.getParameter("id");
		String eventCode = req.getParameter("eventCode");
		String objectId = req.getParameter("objectId");
		
		LimitService limitService = new LimitService(new LimitDaoImpl(), bizNo);
		
		String result = "";
		
		if(id.equals("all")) {
			List<Limit> list = limitService.getAllLimit();
			result = FormatTransformer.toJson(list);
		} else {
			Limit limit = limitService.getLimitById(eventCode, objectId);
			result = FormatTransformer.toJson(limit);
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
	}
	
	public void insert(HttpServletRequest req, HttpServletResponse res) {
		HttpSession session = req.getSession();
		String tenantId = (String) session.getAttribute("bizNo");
		
		Limit limit = new Limit(
				req.getParameter("eventCode"), 
				req.getParameter("objectId"),
				req.getParameter("minValue"),
				req.getParameter("maxValue"),
				req.getParameter("valueUnit")
			);
		
		LimitService limitService = new LimitService(new LimitDaoImpl(), tenantId);
		Boolean inserted = limitService.insert(limit);
		
		res.setContentType("html/text; charset=UTF-8");
		
		try {
			PrintWriter out = res.getWriter();
			out.print(inserted.toString());
		} catch(Exception e) {
			e.printStackTrace();
		}
	}

	public void update(HttpServletRequest req, HttpServletResponse res) {
		HttpSession session = req.getSession();
		String tenantId = (String) session.getAttribute("bizNo");
		
		Limit limit = new Limit(
				req.getParameter("eventCode"), 
				req.getParameter("objectId"),
				req.getParameter("minValue"),
				req.getParameter("maxValue"),
				req.getParameter("valueUnit")
			);
		
		LimitService limitService = new LimitService(new LimitDaoImpl(), tenantId);
		Boolean updated = limitService.update(limit);
		
		res.setContentType("html/text; charset=UTF-8");
		
		try {
			PrintWriter out = res.getWriter();
			out.print(updated.toString());
		} catch(Exception e) {
			e.printStackTrace();
		}
	}
	
	public void delete(HttpServletRequest req, HttpServletResponse res) {
		HttpSession session = req.getSession();
		String tenantId = (String) session.getAttribute("bizNo");
		
		String eventCode = req.getParameter("eventCode");
		String objectId = req.getParameter("objectId");
		
		LimitService limitService = new LimitService(new LimitDaoImpl(), tenantId);
		Boolean deleted = limitService.delete(eventCode, objectId);
		
		res.setContentType("html/text; charset=UTF-8");
		
		try {
			PrintWriter out = res.getWriter();
			out.print(deleted.toString());
		} catch(Exception e) {
			e.printStackTrace();
		}
		
	}
}
