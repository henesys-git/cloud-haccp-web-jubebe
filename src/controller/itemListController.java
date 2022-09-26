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

import dao.ItemListDaoImpl;
import dao.ProductDaoImpl;
import model.ItemList;
import model.Product;
import service.ItemListService;
import service.ProductService;
import utils.FormatTransformer;


@WebServlet("/itemList")
public class itemListController extends HttpServlet {
	
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	static final Logger logger = 
			Logger.getLogger(itemListController.class.getName());
	
	public void doGet(HttpServletRequest req, HttpServletResponse res) 
			throws ServletException, IOException {
		HttpSession session = req.getSession();
		String tenantId = (String) session.getAttribute("bizNo");
		
		if(tenantId == null) {
			tenantId = req.getParameter("bizNo");
		}
		
		String type = req.getParameter("type");
		String type_cd = req.getParameter("type_cd");
		
		ItemListService itemListService = new ItemListService(new ItemListDaoImpl(), tenantId);
		
		String result = "";
		
		if(type.equals("sensorListAll")) {
			List<ItemList> list = itemListService.getSensorList();
			result = FormatTransformer.toJson(list);
		}
		else if(type.equals("sensorList")) {
			List<ItemList> list = itemListService.getSensorList(type_cd);
			result = FormatTransformer.toJson(list);
		}
		else {
			List<ItemList> list = itemListService.getCCPList(type_cd);
			result = FormatTransformer.toJson(list);
		}
		
		res.setContentType("application/json; charset=UTF-8");
		PrintWriter out = res.getWriter();
		
		out.print(result);
	}

	public void doPost(HttpServletRequest req, HttpServletResponse res) 
			throws ServletException, IOException {
		
		doGet(req, res);
		
	}

}
