package newest.mes.controller;

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
import newest.mes.dao.RawmaterialStorageDaoImpl;
import newest.mes.model.RawmaterialStorage;
import newest.mes.service.RawmaterialStorageService;
import service.RawmaterialService;
import utils.FormatTransformer;


@WebServlet("/rawmaterial-storage")
public class RawmaterialStorageController extends HttpServlet {
	
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	static final Logger logger = 
			Logger.getLogger(RawmaterialStorageController.class.getName());
	
	public void doGet(HttpServletRequest req, HttpServletResponse res) 
			throws ServletException, IOException {
		HttpSession session = req.getSession();
		String tenantId = (String) session.getAttribute("bizNo");
		
		if(tenantId == null) {
			tenantId = req.getParameter("bizNo");
		}
		
		String id = req.getParameter("id");
		String rawmaterialId = req.getParameter("rawmaterialId");
		String stockNo = req.getParameter("stockNo");
		
		RawmaterialStorageService psService = new RawmaterialStorageService(new RawmaterialStorageDaoImpl(), tenantId);
		
		String result = "";
		
		if(id.equals("groupByRawmaterialId")) {
			List<RawmaterialStorage> list = psService.getStockGroupByRawmaterialId();
			result = FormatTransformer.toJson(list);
		} else if(id.equals("groupByStockNo")) {
			List<RawmaterialStorage> list = psService.getStockGroupByStockNo(rawmaterialId);
			result = FormatTransformer.toJson(list);
		} else if(id.equals("ipgoChulgo")) {
			String rawmaterialStockNo = req.getParameter("rawmaterialStockNo");
			String ioDatetime = req.getParameter("ioDatetime");
			int ioAmt = Integer.parseInt(req.getParameter("ioAmt"));
			Boolean success = psService.ipgoChulgo(rawmaterialStockNo, rawmaterialId, ioDatetime, ioAmt);
			result = success.toString();
		} else if(id.equals("stock")) {
			List<RawmaterialStorage> list = psService.getStock(stockNo);
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
