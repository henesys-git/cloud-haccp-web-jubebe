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

import dao.ProductDaoImpl;
import model.Product;
import newest.mes.dao.ProductStorageDaoImpl;
import newest.mes.model.ProductStorage;
import newest.mes.service.ProductStorageService;
import service.ProductService;
import utils.FormatTransformer;


@WebServlet("/product-storage")
public class ProductStorageController extends HttpServlet {
	
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	static final Logger logger = 
			Logger.getLogger(ProductStorageController.class.getName());
	
	public void doGet(HttpServletRequest req, HttpServletResponse res) 
			throws ServletException, IOException {
		HttpSession session = req.getSession();
		String tenantId = (String) session.getAttribute("bizNo");
		
		if(tenantId == null) {
			tenantId = req.getParameter("bizNo");
		}
		
		String id = req.getParameter("id");
		String productId = req.getParameter("productId");
		String stockNo = req.getParameter("stockNo");
		
		ProductStorageService psService = new ProductStorageService(new ProductStorageDaoImpl(), tenantId);
		
		String result = "";
		
		if(id.equals("groupByProductId")) {
			List<ProductStorage> list = psService.getStockGroupByProductId();
			result = FormatTransformer.toJson(list);
		} else if(id.equals("groupByStockNo")) {
			List<ProductStorage> list = psService.getStockGroupByStockNo(productId);
			result = FormatTransformer.toJson(list);
		} else if(id.equals("ipgoChulgo")) {
			String productStockNo = req.getParameter("productStockNo");
			String ioDatetime = req.getParameter("ioDatetime");
			int ioAmt = Integer.parseInt(req.getParameter("ioAmt"));
			String prodResultParam = req.getParameter("prodResultParam");
			String planNo = req.getParameter("planNo");
			Boolean success = psService.ipgoChulgo(productStockNo, productId, ioDatetime, ioAmt, prodResultParam, planNo);
			result = success.toString();
		} else if(id.equals("stock")) {
			List<ProductStorage> list = psService.getStock(stockNo);
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
		
		Product product = new Product(req.getParameter("id"), req.getParameter("name"));
		
		ProductService productService = new ProductService(new ProductDaoImpl(), tenantId);
		Boolean inserted = productService.insert(product);
		
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
		
		Product product = new Product(req.getParameter("id"), req.getParameter("name"));
		
		ProductService productService = new ProductService(new ProductDaoImpl(), tenantId);
		Boolean updated = productService.update(product);
		
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
		
		String productId = req.getParameter("id");
		
		ProductService productService = new ProductService(new ProductDaoImpl(), tenantId);
		Boolean deleted = productService.delete(productId);
		
		res.setContentType("html/text; charset=UTF-8");
		
		try {
			PrintWriter out = res.getWriter();
			out.print(deleted.toString());
		} catch(Exception e) {
			e.printStackTrace();
		}
		
	}

}
