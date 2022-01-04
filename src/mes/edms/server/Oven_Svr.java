package mes.edms.server;
import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.json.simple.JSONObject;

import mes.client.guiComponents.DoyosaeTableModel;

public class Oven_Svr extends HttpServlet {   	
	Thread thread;


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
		System.out.println("started Oven Servlet");
		//thread = new Thread(new OvenThread());
		//thread.start();
		
	}
	
	@Override
	public void destroy() {
		// TODO Auto-generated method stub
		thread.interrupt();
		System.exit(0);
		super.destroy();
	}
	
	
	
	public void doGet(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
		test(req, res);
	}
	
	public void doPost(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
		test(req, res);
	}
		
	public void test(HttpServletRequest req, HttpServletResponse res) throws ServletException {
		DoyosaeTableModel TableModel_insert;
		JSONObject jArray = new JSONObject();
		
		
		String censor_no = req.getParameter("censor_no");
		String censor_data_type = req.getParameter("censor_data_type");
		String censor_value = req.getParameter("censor_value");
		
		System.out.println("censor_no : " +censor_no);
		System.out.println("censor_data_type : " +censor_data_type);
		System.out.println("censor_value : " +censor_value);
		
		
		jArray.put("censor_no", censor_no);
		jArray.put("censor_channel_no", 1);
		jArray.put("censor_data_type", censor_data_type);
		jArray.put("censor_value", censor_value);
		TableModel_insert = new DoyosaeTableModel("M707S010600E111", jArray);
		
	}

}




