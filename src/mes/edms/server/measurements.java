package mes.edms.server;
import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;

import mes.client.conf.Config;
import mes.client.guiComponents.DoyosaeTableModel;

public class measurements extends HttpServlet {   	
	
	int temp_cycle;
	Date tempTime;
	Date curTime;
	Calendar cal = Calendar.getInstance();
	Calendar cal2 = Calendar.getInstance();
	SimpleDateFormat f = new SimpleDateFormat("yyyy-MM-dd kk:mm:ss");

	String jsonFilePath = Config.sysConfigPath + "SysConfig.conf";

	JSONParser parser;
    Object obj_common;
    JSONObject json_temp_cycle;
    JSONObject json_data;

 

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
		System.out.println("started EFENTO Servlet");
		
		try {
			jsonFilePath = Config.sysConfigPath + "SysConfig.conf";
		    System.out.println(jsonFilePath);
	   
		    parser = new JSONParser();
		    obj_common = parser.parse(new FileReader(jsonFilePath));
		} catch (Exception e) {
			// TODO: handle exception
		}
		
		
		
		
	}
	
	public void doGet(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
		test(req, res);
	}
	
	public void doPost(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
		test(req, res);
	}
	
	
	public void test(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
		
		
		
		
		DoyosaeTableModel TableModel_select;
		DoyosaeTableModel TableModel_insert;
		DoyosaeTableModel TableModel_member_key;
		
		String[] strColumnHead 	= {"제품명","제품값"};
		
		BufferedReader dis = new BufferedReader(new InputStreamReader(req.getInputStream()));
		String aa = dis.readLine();
		System.out.println(aa);
		try {

//			json_data = (JSONObject)obj_common;
//			JSONObject jArray = (JSONObject)json_data.get("tt");
//			JSONArray resultArr = (JSONArray)jArray.get("measurements");
//			JSONObject data_jArray;
//			System.out.println(resultArr);
			
			JSONParser parser = new JSONParser();
			Object obj = parser.parse( aa );
			JSONObject jArray = (JSONObject) obj;
			JSONObject data_jArray;
			JSONArray resultArr = (JSONArray)jArray.get("measurements");
			
			for(int i=0; i<resultArr.size(); i++) {
				data_jArray = new JSONObject();
				JSONObject innerArr = (JSONObject)resultArr.get(i);
				JSONArray valueArr = (JSONArray)innerArr.get("params");
				JSONObject params = (JSONObject)valueArr.get(0);
				
				
				data_jArray.put("serial", innerArr.get("serial").toString());				
				TableModel_member_key = new DoyosaeTableModel("M707S010600E108", strColumnHead, data_jArray);
				
				json_temp_cycle = (JSONObject)obj_common;
				JSONObject jArray_cycle_obj  = (JSONObject)json_temp_cycle.get("tempcycle");
				String jArray_cycle_result  = (String)jArray_cycle_obj.get(TableModel_member_key.getValueAt(0, 0));

				int tempcycle = Integer.parseInt(jArray_cycle_result.toString());
				 
				 data_jArray.put("measured_at", innerArr.get("measured_at").toString());
				 data_jArray.put("time_cycle", tempcycle);				
				 data_jArray.put("member_key", TableModel_member_key.getValueAt(0,0).toString());
				
				TableModel_select = new DoyosaeTableModel("M707S010600E107", strColumnHead, data_jArray);
				
				if(TableModel_select.getValueAt(0, 0).toString().equals("1")) {
					data_jArray.put("channel", params.get("channel").toString());
					data_jArray.put("type",  params.get("type").toString());
					data_jArray.put("value",  params.get("value").toString());
					
					TableModel_insert = new DoyosaeTableModel("M707S010600E105", strColumnHead, data_jArray);
				} else if(TableModel_select.getValueAt(0, 0).toString().equals("")) {
					data_jArray.put("channel", params.get("channel").toString());
					data_jArray.put("type",  params.get("type").toString());
					data_jArray.put("value",  params.get("value").toString());
					
					TableModel_insert = new DoyosaeTableModel("M707S010600E105", strColumnHead, data_jArray);
				} else {
					System.out.println(tempcycle+"분 보다 작음");
				}
				
				
				
			}

			//TableModel_insert = new DoyosaeTableModel("M707S010600E105", strColumnHead, jArray);	

		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	
	}
	
}


	




