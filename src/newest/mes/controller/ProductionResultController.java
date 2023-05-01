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
import mes.frame.servlet.SixSeallerServerModbus;
import model.Product;
import newest.mes.dao.OrderDaoImpl;
import newest.mes.dao.ProductionPlanDaoImpl;
import newest.mes.dao.ProductionResultDaoImpl;
import newest.mes.model.Order;
import newest.mes.model.ProductionPlan;
import newest.mes.model.ProductionResult;
import newest.mes.service.OrderService;
import newest.mes.service.ProductionPlanService;
import newest.mes.service.ProductionResultService;
import service.ProductService;
import utils.FormatTransformer;
import viewmodel.ProductViewModel;


@WebServlet("/mes-productionResult")
public class ProductionResultController extends HttpServlet {
	
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	static final Logger logger = 
			Logger.getLogger(ProductionResultController.class.getName());
	
	public void doGet(HttpServletRequest req, HttpServletResponse res) 
			throws ServletException, IOException {
		HttpSession session = req.getSession();
		String tenantId = (String) session.getAttribute("bizNo");
		
		if(tenantId == null) {
			tenantId = req.getParameter("bizNo");
		}
		
		String id = req.getParameter("id");
		String planNo = req.getParameter("planNo");
		
		ProductionResultService resultService = new ProductionResultService(new ProductionResultDaoImpl(), tenantId);
		
		String result = "";
		String resultString = "";
		
		if(id.equals("all")) {
			List<ProductionResult> list = resultService.getAllResults();
			result = FormatTransformer.toJson(list);
			
			res.setContentType("application/json; charset=UTF-8");
			PrintWriter out = res.getWriter();
			
			out.print(result);
		}
		else if(id.equals("packingRead")) {
			String param1 = req.getParameter("param1");
			int slaveId = Integer.parseInt(param1);

			SixSeallerServerModbus sealer = new SixSeallerServerModbus();

			// 1ȸ ���� * 6�ŽǷ�(�ѹ��� 6�� ����)
			String tempCountStr = sealer.getCupSealerTotal(slaveId);
			if(tempCountStr.equals("-1")) {
				resultString = tempCountStr;
			} else {
				//int tempCount = Integer.parseInt(tempCountStr) * 6;
				resultString = String.valueOf(tempCountStr);					
			}
			
			logger.debug("############�ŽǷ� ī��Ʈ(*4 ����):" + resultString);
			
			res.setContentType("plain/text;charset=UTF-8");
			PrintWriter out = res.getWriter();
			out.print(resultString.trim());
			out.flush();
			
		}
		else if(id.equals("packingReadDB")) {
			String prod_cd = req.getParameter("prod_cd");
			
			List<ProductionResult> list = resultService.getPackingCountDB(prod_cd);
			result = FormatTransformer.toJson(list);
			
			res.setContentType("application/json; charset=UTF-8");
			PrintWriter out = res.getWriter();
			
			out.print(result);
			
		}
		
	}

	public void doPost(HttpServletRequest req, HttpServletResponse res) 
			throws ServletException, IOException {
		
		if(req.getParameter("type").equals("insert")) {
			insert(req, res);
		}
		
		if(req.getParameter("type").equals("packingUpdate")) {
			packingUpdate(req, res);
		}
		
		if(req.getParameter("type").equals("delete")) {
			delete(req, res);
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
		
		
		try {
			ProductionPlan plan = new ProductionPlan();
			plan.setOrderNo(orderNo);
			plan.setPlanNo(planNo);
			plan.setPlanDate(planDate);
			plan.setCustomerCode(custCode);
			plan.setProductId(productId);
			plan.setPlanCount(planCount);
			
			ProductionPlanService planService = new ProductionPlanService(new ProductionPlanDaoImpl(), tenantId);
			Boolean inserted = planService.insert(plan);
			
			res.setContentType("html/text; charset=UTF-8");
			
			PrintWriter out = res.getWriter();
			out.print(inserted.toString());
		} catch(Exception e) {
			e.printStackTrace();
		}
	}

	public void packingUpdate(HttpServletRequest req, HttpServletResponse res) {
		HttpSession session = req.getSession();
		String tenantId = (String) session.getAttribute("bizNo");
		
		String packingCount = req.getParameter("packingCount");
		String planNo = req.getParameter("planNo");
		
		
		ProductionResultService resultService = new ProductionResultService(new ProductionResultDaoImpl(), tenantId);
		Boolean updated = resultService.packingUpdate(packingCount, planNo);
		
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

}
