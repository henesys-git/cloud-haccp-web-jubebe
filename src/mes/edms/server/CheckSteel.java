package mes.edms.server;
import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.json.simple.JSONObject;

import mes.client.guiComponents.DoyosaeTableModel;

public class CheckSteel extends HttpServlet {   	
	


	public HttpServletResponse setAllowOrigin(HttpServletResponse response) {
        
        //response.setHeader("Access-Control-Allow-Methods", "POST, GET, OPTIONS, DELETE");
        response.setHeader("Access-Control-Allow-Methods", "POST, GET");
        response.setHeader("Access-Control-Max-Age", "3600");
        response.setHeader("Access-Control-Allow-Headers", "x-requested-with");
        response.setHeader("Access-Control-Allow-Origin", "*");

        return response ;
    }	
	@Override
	public void init() throws ServletException {
		super.init();
		System.out.println("started CheckSteel Servlet");
	}
	
	public void doGet(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
		test(req, res);
	}
	
	public void doPost(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
		test(req, res);
	}
		
	public void test(HttpServletRequest req, HttpServletResponse res) throws ServletException {
		DoyosaeTableModel TableModel_insert;
		String[] strColumnHead 	= {"力前疙","力前蔼"};
		JSONObject jArray = new JSONObject();
		
		
		String id = req.getParameter("id");
		String value = req.getParameter("value");
		
		System.out.println("id : " +id);
		System.out.println("value : " +value);
		
		if(Integer.parseInt(id) <10) {
			jArray.put("censor_no", "SC0"+id);
			
		} else {
			jArray.put("censor_no", "SC"+id);
		}
		
		jArray.put("censor_channel_no", 1);
		jArray.put("censor_data_type", "CTYPE005");
		jArray.put("censor_value", value);
		TableModel_insert = new DoyosaeTableModel("M707S010600E111", strColumnHead, jArray);
		
	}
	
}

