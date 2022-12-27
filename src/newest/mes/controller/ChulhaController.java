package newest.mes.controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.log4j.Logger;

import newest.mes.dao.ChulhaDaoImpl;
import newest.mes.model.ChulhaInfo;
import newest.mes.model.ChulhaInfoDetail;
import newest.mes.service.ChulhaService;
import newest.mes.viewmodel.ChulhaInfoViewModel;
import utils.FormatTransformer;


@WebServlet("/chulha-info")
public class ChulhaController extends HttpServlet {
	
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	static final Logger logger = 
			Logger.getLogger(ChulhaController.class.getName());
	
	public void doGet(HttpServletRequest req, HttpServletResponse res) 
			throws ServletException, IOException {
		HttpSession session = req.getSession();
		String tenantId = (String) session.getAttribute("bizNo");
		
		if(tenantId == null) {
			tenantId = req.getParameter("bizNo");
		}
		
		String id = req.getParameter("id");
		String chulhaNo = req.getParameter("chulhaNo");
		
		ChulhaService ChulhaService = new ChulhaService(new ChulhaDaoImpl(), tenantId);
		
		String result = "";
		
		if(id.equals("all")) {
			List<ChulhaInfoViewModel> list = ChulhaService.getChulhaInfo();
			result = FormatTransformer.toJson(list);
		} else if(id.equals("detail")) {
			List<ChulhaInfoViewModel> list = ChulhaService.getChulhaInfoDetail(chulhaNo);
			result = FormatTransformer.toJson(list);
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
		
		ChulhaInfo ci = new ChulhaInfo();
		List<ChulhaInfoDetail> detailList = new ArrayList<>();
		
		ChulhaService chulhaService = new ChulhaService(new ChulhaDaoImpl(), tenantId);
		Boolean inserted = chulhaService.insert(ci, detailList);
		
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
		
		ChulhaInfo ci = new ChulhaInfo();
		List<ChulhaInfoDetail> detailList = new ArrayList<>();
		
		ChulhaService chulhaService = new ChulhaService(new ChulhaDaoImpl(), tenantId);
		Boolean inserted = chulhaService.update(ci, detailList);
		
		res.setContentType("html/text; charset=UTF-8");
		
		try {
			PrintWriter out = res.getWriter();
			out.print(inserted.toString());
		} catch(Exception e) {
			e.printStackTrace();
		}
	}
	
	public void delete(HttpServletRequest req, HttpServletResponse res) {
		HttpSession session = req.getSession();
		String tenantId = (String) session.getAttribute("bizNo");
		
		String chulhaNo = req.getParameter("chulhaNo");
		
		ChulhaService chulhaService = new ChulhaService(new ChulhaDaoImpl(), tenantId);
		Boolean deleted = chulhaService.delete(chulhaNo);
		
		res.setContentType("html/text; charset=UTF-8");
		
		try {
			PrintWriter out = res.getWriter();
			out.print(deleted.toString());
		} catch(Exception e) {
			e.printStackTrace();
		}
		
	}

}
