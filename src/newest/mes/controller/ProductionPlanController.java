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

import dao.ProductDaoImpl;
import mes.client.util.NumberGeneratorForCloudMES;
import model.Product;
import newest.mes.dao.OrderDaoImpl;
import newest.mes.dao.ProductionPlanDaoImpl;
import newest.mes.model.Order;
import newest.mes.model.ProductionPlan;
import newest.mes.service.OrderService;
import newest.mes.service.ProductionPlanService;
import service.ProductService;
import utils.FormatTransformer;
import viewmodel.ProductViewModel;


@WebServlet("/mes-productionPlan")
public class ProductionPlanController extends HttpServlet {
	
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	static final Logger logger = 
			Logger.getLogger(ProductionPlanController.class.getName());
	
	public void doGet(HttpServletRequest req, HttpServletResponse res) 
			throws ServletException, IOException {
		HttpSession session = req.getSession();
		String tenantId = (String) session.getAttribute("bizNo");
		
		if(tenantId == null) {
			tenantId = req.getParameter("bizNo");
		}
		
		String id = req.getParameter("id");
		String planNo = req.getParameter("planNo");
		
		ProductionPlanService planService = new ProductionPlanService(new ProductionPlanDaoImpl(), tenantId);
		
		String result = "";
		
		if(id.equals("all")) {
			List<ProductionPlan> list = planService.getAllPlans();
			result = FormatTransformer.toJson(list);
		}
		else {
			Order order = planService.getOrderById(id);
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
		
		if(req.getParameter("type").equals("instruction_insert")) {
			instructionInsert(req, res);
		}
	}
	
	public void insert(HttpServletRequest req, HttpServletResponse res) {
		HttpSession session = req.getSession();
		String tenantId = (String) session.getAttribute("bizNo");
		
		String planDate = req.getParameter("planDate");
		String custCode = req.getParameter("customerCode");
		String productId = req.getParameter("productId");
		String orderNo = req.getParameter("orderNo");
		String planCount = req.getParameter("planCount");
		
		NumberGeneratorForCloudMES generator = new NumberGeneratorForCloudMES();
		
		String planNo = generator.generatePlanNum();
		String lotNo = generator.generateLotNo();
		
		
		try {
			ProductionPlan plan = new ProductionPlan();
			plan.setOrderNo(orderNo);
			plan.setPlanNo(planNo);
			plan.setPlanDate(planDate);
			plan.setCustomerCode(custCode);
			plan.setProductId(productId);
			plan.setPlanCount(planCount);
			plan.setLotNo(lotNo);
			
			ProductionPlanService planService = new ProductionPlanService(new ProductionPlanDaoImpl(), tenantId);
			Boolean inserted = planService.insert(plan);
			
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
		
		ProductionPlan plan = new ProductionPlan();
		
		String planCount = req.getParameter("planCount");
		String planNo = req.getParameter("planNo");
		String productId = req.getParameter("productId");
		String planDate = req.getParameter("planDate");
		
		plan.setPlanCount(planCount);
		plan.setPlanNo(planNo);
		plan.setProductId(productId);
		plan.setPlanDate(planDate);
		
		ProductionPlanService planService = new ProductionPlanService(new ProductionPlanDaoImpl(), tenantId);
		Boolean updated = planService.update(plan);
		
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
		
		String planNo = req.getParameter("id");
		
		ProductionPlanService planService = new ProductionPlanService(new ProductionPlanDaoImpl(), tenantId);
		Boolean deleted = planService.delete(planNo);
		
		res.setContentType("html/text; charset=UTF-8");
		
		try {
			PrintWriter out = res.getWriter();
			out.print(deleted.toString());
		} catch(Exception e) {
			e.printStackTrace();
		}
		
	}
	
	public void instructionInsert(HttpServletRequest req, HttpServletResponse res) {
		HttpSession session = req.getSession();
		String tenantId = (String) session.getAttribute("bizNo");
		
		String instructionDate = req.getParameter("instructionDate");
		String productId = req.getParameter("productId");
		String planNo = req.getParameter("planNo");
		String instructionCount = req.getParameter("instructionCount");
		String lotNo = req.getParameter("lotNo");
		
		ProductionPlanService planService = new ProductionPlanService(new ProductionPlanDaoImpl(), tenantId);
		Boolean inserted = planService.instructionInsert(instructionDate, productId, planNo, instructionCount, lotNo);
		
		res.setContentType("html/text; charset=UTF-8");
		
		try {
			PrintWriter out = res.getWriter();
			out.print(inserted.toString());
		} catch(Exception e) {
			e.printStackTrace();
		}
	}

}
