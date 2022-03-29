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

import dao.CommonCodeDaoImpl;
import dao.SensorDaoImpl;
import dao.UserDaoImpl;
import model.CommonCode;
import model.Sensor;
import model.User;
import service.CommonCodeService;
import service.SensorService;
import service.UserService;
import utils.FormatTransformer;


@WebServlet("/commonCode")
public class CommonCodeController extends HttpServlet {
	
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	static final Logger logger = 
			Logger.getLogger(CommonCodeController.class.getName());
	
	public void doGet(HttpServletRequest req, HttpServletResponse res) 
			throws ServletException, IOException {
		HttpSession session = req.getSession();
		String bizNo = (String) session.getAttribute("bizNo");
		
		if(bizNo == null) {
			bizNo = req.getParameter("bizNo");
		}
		
		String id = req.getParameter("id");
		
		CommonCodeService commonCodeService = new CommonCodeService(new CommonCodeDaoImpl(), bizNo);
		
		String result = "";
		
		if(id.equals("all")) {
			List<CommonCode> list = commonCodeService.getAllCodes();
			result = FormatTransformer.toJson(list);
		} else {
			CommonCode commonCode = commonCodeService.getCodeById(id);
			result = FormatTransformer.toJson(commonCode);
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
		
		CommonCode commonCode = new CommonCode(
				req.getParameter("code"), 
				req.getParameter("name"),
				req.getParameter("valueType")
				
			);
		
		CommonCodeService commonCodeService = new CommonCodeService(new CommonCodeDaoImpl(), tenantId);
		Boolean inserted = commonCodeService.insert(commonCode);
		
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
		
		CommonCode commonCode = new CommonCode(
				req.getParameter("code"), 
				req.getParameter("name"),
				req.getParameter("valueType")
				
			);
		
		CommonCodeService commonCodeService = new CommonCodeService(new CommonCodeDaoImpl(), tenantId);
		Boolean updated = commonCodeService.update(commonCode);
		
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
		
		String commonCodeId = req.getParameter("code");
		
		CommonCodeService commonCodeService = new CommonCodeService(new CommonCodeDaoImpl(), tenantId);
		Boolean deleted = commonCodeService.delete(commonCodeId);
		
		res.setContentType("html/text; charset=UTF-8");
		
		try {
			PrintWriter out = res.getWriter();
			out.print(deleted.toString());
		} catch(Exception e) {
			e.printStackTrace();
		}
		
	}
}
