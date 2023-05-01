package newest.mes.interfaces;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
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
import org.json.simple.parser.ParseException;

import dao.ProductDaoImpl;
import mes.client.util.NumberGeneratorForCloudMES;
import mes.frame.database.JDBCConnectionPool;
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


@WebServlet("/mes-interfaces")
public class MESInterface extends HttpServlet {
	
	private Connection conn;
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	static final Logger logger = 
			Logger.getLogger(MESInterface.class.getName());
	
	public void doGet(HttpServletRequest req, HttpServletResponse res) 
			throws ServletException, IOException {
		performTask(req, res);
	}

	public void doPost(HttpServletRequest req, HttpServletResponse res) 
			throws ServletException, IOException {
		performTask(req, res);
	}
	
	public void performTask(HttpServletRequest req, HttpServletResponse res) {
		
		
		HttpSession session = req.getSession();
		String tenantId = (String) session.getAttribute("bizNo");
		String data = req.getParameter("data");
		
		String data_date = "";
		String prev_product_id = "";
		String prev_product_cnt = "";
		String cur_product_id = "";
		String cur_product_cnt = "";
		
		JSONParser parser = new JSONParser();  
		JSONObject json;
		
		String sql = "";
		/*
		if(tenantId == null) {
			tenantId = req.getParameter("bizNo");
		}
		*/
		try {
			if(data != null) {
				json = (JSONObject) parser.parse(data);
				tenantId =  "B" + json.get("bizNo").toString();
				data_date = json.get("data_date").toString();
				prev_product_id = json.get("prev_product_id").toString();
				prev_product_cnt = json.get("prev_product_cnt").toString();
				cur_product_id = json.get("cur_product_id").toString();
				cur_product_cnt = json.get("cur_product_cnt").toString();
				
			}
			else {
				tenantId = "B" + (String) req.getParameter("bizNo");
				data_date = (String) req.getParameter("data_date");
				prev_product_id = (String) req.getParameter("prev_product_id");
				prev_product_cnt = (String) req.getParameter("prev_product_cnt");
				cur_product_id = (String) req.getParameter("cur_product_id");
				cur_product_cnt = (String) req.getParameter("cur_product_cnt");
			}
			
		} catch(ParseException e) {
			e.printStackTrace();
		}
		
		conn = JDBCConnectionPool.getTenantDB(tenantId);
		
		try {
			sql = new StringBuilder()
					.append("INSERT INTO mes_packing_data \n")
					.append("	(   			\n")
					.append("	 data_date,   \n")
					.append("	 prev_product_id, \n")
					.append("	 prev_product_cnt,\n")
					.append("	 cur_product_id,\n")
					.append("	 cur_product_cnt, \n")
					.append("	 tenant_id \n")
					.append("	)\n")
					.append("VALUES\n")
					.append("	(\n")
					.append("		?,\n")
					.append("		?,\n")
					.append("		?,\n")
					.append("		?,\n")
					.append("		?,\n")
					.append("		? \n")
					.append("	);\n")
					.toString();

			PreparedStatement ps = conn.prepareStatement(sql);
			
			ps.setString(1, data_date);
			ps.setString(2, prev_product_id);
			ps.setString(3, prev_product_cnt);
			ps.setString(4, cur_product_id);
			ps.setString(5, cur_product_cnt);
			ps.setString(6, JDBCConnectionPool.getTenantId(conn));
			
	        int i = ps.executeUpdate();
	        /*
	        if(i == 1) {
	        	return true;
	        }
	        */
	    } catch (SQLException ex) {
	        ex.printStackTrace();
	    }
	    //return false;
	}

}
