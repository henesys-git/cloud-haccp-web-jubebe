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

import dao.CustomerDaoImpl;
import model.Customer;
import service.CustomerService;
import utils.FormatTransformer;
import viewmodel.CustomerViewModel;


@WebServlet("/customer")
public class CustomerController extends HttpServlet {
	
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	static final Logger logger = 
			Logger.getLogger(CustomerController.class.getName());
	
	public void doGet(HttpServletRequest req, HttpServletResponse res) 
			throws ServletException, IOException {
		HttpSession session = req.getSession();
		String tenantId = (String) session.getAttribute("bizNo");
		
		if(tenantId == null) {
			tenantId = req.getParameter("bizNo");
		}
		
		String id = req.getParameter("id");
		
		CustomerService customerService = new CustomerService(new CustomerDaoImpl(), tenantId);
		
		String result = "";
		
		if(id.equals("all")) {
			List<Customer> list = customerService.getAllCustomers();
			result = FormatTransformer.toJson(list);
		} else if(id.equals("allvm")) {
			List<CustomerViewModel> list = customerService.getAllCustomersViewModel();
			result = FormatTransformer.toJson(list);
		} else {
			Customer customer = customerService.getCustomerById(id);
			result = FormatTransformer.toJson(customer);
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
		
		Customer customer = new Customer(req.getParameter("id"), req.getParameter("name"));
		
		CustomerService customerService = new CustomerService(new CustomerDaoImpl(), tenantId);
		Boolean inserted = customerService.insert(customer);
		
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
		
		Customer customer = new Customer(req.getParameter("id"), req.getParameter("name"));
		
		CustomerService customerService = new CustomerService(new CustomerDaoImpl(), tenantId);
		Boolean updated = customerService.update(customer);
		
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
		
		String customerId = req.getParameter("id");
		
		CustomerService customerService = new CustomerService(new CustomerDaoImpl(), tenantId);
		Boolean deleted = customerService.delete(customerId);
		
		res.setContentType("html/text; charset=UTF-8");
		
		try {
			PrintWriter out = res.getWriter();
			out.print(deleted.toString());
		} catch(Exception e) {
			e.printStackTrace();
		}
		
	}

}
