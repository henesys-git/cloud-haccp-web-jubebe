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

import dao.ProductDaoImpl;
import model.Product;
import service.ProductService;
import utils.FormatTransformer;


@WebServlet("/product")
public class ProductController extends HttpServlet {
	
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	static final Logger logger = 
			Logger.getLogger(ProductController.class.getName());
	
	public void doGet(HttpServletRequest req, HttpServletResponse res) 
			throws ServletException, IOException {
		HttpSession session = req.getSession();
		String tenantId = (String) session.getAttribute("bizNo");
		
		if(tenantId == null) {
			tenantId = req.getParameter("bizNo");
		}
		
		String id = req.getParameter("id");
		
		ProductService productService = new ProductService(new ProductDaoImpl(), tenantId);
		
		String result = "";
		
		if(id.equals("all")) {
			List<Product> list = productService.getAllProducts();
			result = FormatTransformer.toJson(list);
		} else {
			Product product = productService.getProductById(id);
			result = FormatTransformer.toJson(product);
		}
		
		res.setContentType("application/json; charset=UTF-8");
		PrintWriter out = res.getWriter();
		
		out.print(result);
	}

	public void doPost(HttpServletRequest req, HttpServletResponse res) 
			throws ServletException, IOException {
		HttpSession session = req.getSession();
		String bizNo = (String) session.getAttribute("bizNo");
		
		ProductService productService = new ProductService(new ProductDaoImpl(), bizNo);
		List<Product> productList = productService.getAllProducts();
		String result = FormatTransformer.toJson(productList);
		
		res.setContentType("application/json; charset=UTF-8");
		PrintWriter out = res.getWriter();
		
		out.print(result);
	}
}
