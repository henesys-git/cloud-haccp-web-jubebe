package mes.edms.server;
import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.json.simple.JSONObject;

import mes.client.guiComponents.DoyosaeTableModel;

public class FlowMeter extends HttpServlet {   	
	DoyosaeTableModel TableModel_select;
	int select_result;

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
		System.out.println("started FlowMeter Servlet");
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
			jArray.put("censor_no", "FM0"+id);
			
		} else {
			jArray.put("censor_no", "FM"+id);
		}
		jArray.put("censor_channel_no", 1);
		jArray.put("censor_data_type", "liter");
		jArray.put("censor_value", value);
		TableModel_select = new DoyosaeTableModel("M707S010600E108", strColumnHead, jArray);
		select_result = Integer.parseInt(TableModel_select.getValueAt(0, 0).toString());
		
		if(select_result == 1) {
			TableModel_insert = new DoyosaeTableModel("M707S010600E111", strColumnHead, jArray);
			
		}
		
		
	}
	
}

