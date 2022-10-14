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

import dao.NoticeDaoImpl;
import model.Notice;
import service.NoticeService;
import utils.FormatTransformer;


@WebServlet("/notice")
public class NoticeController extends HttpServlet {
	
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	static final Logger logger = 
			Logger.getLogger(NoticeController.class.getName());
	
	public void doGet(HttpServletRequest req, HttpServletResponse res) 
			throws ServletException, IOException {
		HttpSession session = req.getSession();
		String tenantId = (String) session.getAttribute("bizNo");
		String regDatetime = req.getParameter("registerDatetime");
		
		if(tenantId == null) {
			tenantId = req.getParameter("tenantId");
		}
		
		NoticeService noticeService = new NoticeService(new NoticeDaoImpl(), tenantId);
		
		String result = "";
		
		if(regDatetime != null) {
			if(regDatetime.equals("all")) {
				List<Notice> list = noticeService.getAllNotice();
				result = FormatTransformer.toJson(list);
			}
			else if(regDatetime.equals("active")) {
				List<Notice> list = noticeService.getActiveNotice();
				result = FormatTransformer.toJson(list);
			}
			else {
				Notice notice = noticeService.getNotice(regDatetime);
				result = FormatTransformer.toJson(notice);
			}
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
		
		Notice notice = new Notice(
				req.getParameter("regiterDatetime"), 
				req.getParameter("noticeTitle"),
				req.getParameter("noticeContent"),
				req.getParameter("active")
			);
		
		NoticeService noticeService = new NoticeService(new NoticeDaoImpl(), tenantId);
		Boolean inserted = noticeService.insert(notice);
		
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
		
		String registerDatetimeOrg = req.getParameter("regiterDatetime");
		
		Notice notice = new Notice(
				req.getParameter("regiterDatetime"), 
				req.getParameter("noticeTitle"),
				req.getParameter("noticeContent"),
				req.getParameter("active")
			);
		
		NoticeService noticeService = new NoticeService(new NoticeDaoImpl(), tenantId);
		Boolean updated = noticeService.update(notice, registerDatetimeOrg);
		
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
		
		String regDatetime = req.getParameter("registerDatetime");
		
		NoticeService noticeService = new NoticeService(new NoticeDaoImpl(), tenantId);
		Boolean deleted = noticeService.delete(regDatetime);
		
		res.setContentType("html/text; charset=UTF-8");
		
		try {
			PrintWriter out = res.getWriter();
			out.print(deleted.toString());
		} catch(Exception e) {
			e.printStackTrace();
		}
		
	}
}
