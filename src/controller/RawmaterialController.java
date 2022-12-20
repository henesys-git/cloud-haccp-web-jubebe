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

import dao.RawmaterialDaoImpl;
import model.Rawmaterial;
import service.RawmaterialService;
import utils.FormatTransformer;
import viewmodel.RawmaterialViewModel;


@WebServlet("/rawmaterial")
public class RawmaterialController extends HttpServlet {
	
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	static final Logger logger = 
			Logger.getLogger(RawmaterialController.class.getName());
	
	public void doGet(HttpServletRequest req, HttpServletResponse res) 
			throws ServletException, IOException {
		HttpSession session = req.getSession();
		String tenantId = (String) session.getAttribute("bizNo");
		
		if(tenantId == null) {
			tenantId = req.getParameter("bizNo");
		}
		
		String id = req.getParameter("id");
		
		RawmaterialService rawmaterialService = new RawmaterialService(new RawmaterialDaoImpl(), tenantId);
		
		String result = "";
		
		if(id.equals("all")) {
			List<Rawmaterial> list = rawmaterialService.getAllRawmaterials();
			result = FormatTransformer.toJson(list);
		} else if(id.equals("allvm")) {
			List<RawmaterialViewModel> list = rawmaterialService.getAllRawmaterialsViewModel();
			result = FormatTransformer.toJson(list);
		} else {
			Rawmaterial rawmaterial = rawmaterialService.getRawmaterialById(id);
			result = FormatTransformer.toJson(rawmaterial);
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
		
		Rawmaterial rawmaterial = new Rawmaterial(req.getParameter("id"), req.getParameter("name"));
		
		RawmaterialService rawmaterialService = new RawmaterialService(new RawmaterialDaoImpl(), tenantId);
		Boolean inserted = rawmaterialService.insert(rawmaterial);
		
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
		
		Rawmaterial rawmaterial = new Rawmaterial(req.getParameter("id"), req.getParameter("name"));
		
		RawmaterialService rawmaterialService = new RawmaterialService(new RawmaterialDaoImpl(), tenantId);
		Boolean updated = rawmaterialService.update(rawmaterial);
		
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
		
		String rawmaterialId = req.getParameter("id");
		
		RawmaterialService rawmaterialService = new RawmaterialService(new RawmaterialDaoImpl(), tenantId);
		Boolean deleted = rawmaterialService.delete(rawmaterialId);
		
		res.setContentType("html/text; charset=UTF-8");
		
		try {
			PrintWriter out = res.getWriter();
			out.print(deleted.toString());
		} catch(Exception e) {
			e.printStackTrace();
		}
		
	}

}
