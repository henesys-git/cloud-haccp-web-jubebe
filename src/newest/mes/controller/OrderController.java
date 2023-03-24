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
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;

import dao.CustomerDaoImpl;
import dao.ProductDaoImpl;
import mes.client.util.NumberGeneratorForCloudMES;
import model.Customer;
import model.Product;import newest.mes.dao.OrderDaoImpl;
import newest.mes.model.Order;
import newest.mes.service.OrderService;
import service.CustomerService;
import service.ProductService;
import utils.FormatTransformer;


@WebServlet("/mes-order")
public class OrderController extends HttpServlet {
	
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	static final Logger logger = 
			Logger.getLogger(OrderController.class.getName());
	
	public void doGet(HttpServletRequest req, HttpServletResponse res) 
			throws ServletException, IOException {
		HttpSession session = req.getSession();
		String tenantId = (String) session.getAttribute("bizNo");
		
		if(tenantId == null) {
			tenantId = req.getParameter("bizNo");
		}
		
		String id = req.getParameter("id");
		String orderNo = req.getParameter("orderNo");
		String prodNm = req.getParameter("prodNm");
		String custNm = req.getParameter("custNm");
		
		OrderService orderService = new OrderService(new OrderDaoImpl(), tenantId);
		ProductService productService = new ProductService(new ProductDaoImpl(), tenantId);
		CustomerService customerService = new CustomerService(new CustomerDaoImpl(), tenantId);
		
		String result = "";
		
		if(id.equals("all")) {
			List<Order> list = orderService.getAllOrders();
			result = FormatTransformer.toJson(list);
		}
		else if(id.equals("detail")) {
			List<Order> list = orderService.getOrderDetails(orderNo);
			result = FormatTransformer.toJson(list);
		}
		else if(id.equals("allNoChulhaYet")) {
			List<Order> list = orderService.getAllOrdersNoChulhaYet();
			result = FormatTransformer.toJson(list);
		}
		else if(id.equals("detailNoChulhaYet")) {
			List<Order> list = orderService.getOrderDetailsNoChulhaYet(orderNo);
			result = FormatTransformer.toJson(list);
		}		
		else if(id.equals("info")) {
			List<Order> list = orderService.getOrderInfos();
			result = FormatTransformer.toJson(list);
		}
		else if(id.equals("getProdCd")) {
			Product list = productService.getProductByNm(prodNm);
			result = FormatTransformer.toJson(list);
		}
		else if(id.equals("getCustCd")) {
			Customer list = customerService.getCustomerByNm(custNm);
			result = FormatTransformer.toJson(list);
		}
		else {
			Order order = orderService.getOrderById(id);
			result = FormatTransformer.toJson(order);
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
		
		if(req.getParameter("type").equals("excelInsert")) {
			excelInsert(req, res);
		}
	}
	
	public void insert(HttpServletRequest req, HttpServletResponse res) {
		HttpSession session = req.getSession();
		String tenantId = (String) session.getAttribute("bizNo");
		
		JSONParser parser = new JSONParser();  
		JSONObject json;
		JSONArray jsonArray;
		
		String orderDate = req.getParameter("orderDate");
		String custCode = req.getParameter("custCode");
		String orderData = req.getParameter("orderData");
		
		NumberGeneratorForCloudMES generator = new NumberGeneratorForCloudMES();
		
		String orderNo = generator.generateOdrNum();
		
		
		try {
			json = (JSONObject) parser.parse(orderData);
			
			JSONArray param = (JSONArray) json.get("param");
			
			Order order = new Order();
			order.setOrderNo(orderNo);
			order.setOrderDate(orderDate);
			order.setCustomerCode(custCode);
			
			OrderService orderService = new OrderService(new OrderDaoImpl(), tenantId);
			Boolean inserted = orderService.insert(order, param);
			
			res.setContentType("html/text; charset=UTF-8");
			
			PrintWriter out = res.getWriter();
			out.print(inserted.toString());
		} catch(Exception e) {
			e.printStackTrace();
		}
	}

	public void update(HttpServletRequest req, HttpServletResponse res) {
		HttpSession session = req.getSession();
		String tenantId = (String) session.getAttribute("bizNo");
		
		Order order = new Order();
		
		OrderService orderService = new OrderService(new OrderDaoImpl(), tenantId);
		Boolean updated = orderService.update(order);
		
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
		
		String orderNo = req.getParameter("id");
		
		OrderService orderService = new OrderService(new OrderDaoImpl(), tenantId);
		Boolean deleted = orderService.delete(orderNo);
		
		res.setContentType("html/text; charset=UTF-8");
		
		try {
			PrintWriter out = res.getWriter();
			out.print(deleted.toString());
		} catch(Exception e) {
			e.printStackTrace();
		}
		
	}
	
	public void excelInsert(HttpServletRequest req, HttpServletResponse res) {
		HttpSession session = req.getSession();
		String tenantId = (String) session.getAttribute("bizNo");
		
		JSONParser parser = new JSONParser();  
		JSONObject json;
		JSONArray jsonArray;
		
		String orderDate = req.getParameter("orderDate");
		String custCode = req.getParameter("custCode");
		String orderData = req.getParameter("orderData");
		
		NumberGeneratorForCloudMES generator = new NumberGeneratorForCloudMES();
		
		String orderNo = generator.generateOdrNum();
		
		
		try {
			json = (JSONObject) parser.parse(orderData);
			
			JSONArray param = (JSONArray) json.get("param");
			
			Order order = new Order();
			order.setOrderNo(orderNo);
			order.setOrderDate(orderDate);
			order.setCustomerCode(custCode);
			
			OrderService orderService = new OrderService(new OrderDaoImpl(), tenantId);
			Boolean inserted = orderService.insert(order, param);
			
			res.setContentType("html/text; charset=UTF-8");
			
			PrintWriter out = res.getWriter();
			out.print(inserted.toString());
		} catch(Exception e) {
			e.printStackTrace();
		}
	}

}
