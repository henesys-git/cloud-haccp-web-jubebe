package mes.edms.server;
import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.text.SimpleDateFormat;
import java.util.Date;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;

import mes.client.guiComponents.DoyosaeTableModel;


public class ScheduleExecTest implements Runnable {
	
	public URL postUrl;
	public HttpURLConnection connection1;
	public HttpURLConnection connection2;
	public HttpURLConnection connection3;
	public BufferedReader br;
	public String output;
	public JSONParser parser = new JSONParser();
	public Object obj_key;
	public Object obj_location;
	public Object obj_temp;
	public JSONObject keyObj;
	public JSONObject locationObj;
	public JSONObject tempObj;
	public JSONArray jsonArr_key;
	public JSONArray jsonArr_location;
	public JSONArray jsonArr_temp;
	public SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMddHHmmss");
	public SimpleDateFormat sdf2 = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	public DoyosaeTableModel TableModel;
	public Geocoding geo = new Geocoding();
	public JSONObject data_jArray;
	public ScheduleExecTest() {
		
	}
	
	public void run(){
		try {
			while(!Thread.currentThread().isInterrupted()) {
				String result1="";
				String result2="";
				String result3="";
				String urlAddr="";
				JSONObject result_jArray = new JSONObject();
				urlAddr = "https://s1.u-vis.com/uvisc/SSOAction.do?method=GetAccessKeyWithValues&SerialKey=S2001-6253-9C97--68B";
				postUrl = new URL(urlAddr); // ��û URL 
				connection1 = (HttpURLConnection) postUrl.openConnection(); //URL ����
				
				
				 br = new BufferedReader(new InputStreamReader(
						  (connection1.getInputStream()),"UTF-8"));

						  while ((output = br.readLine()) != null) {
						  result1 = result1 + output.trim();
						  	
						  }	
						  
						  
						  obj_key = parser.parse(result1);
						  jsonArr_key = (JSONArray) obj_key;
						  keyObj = (JSONObject)jsonArr_key.get(0);
						  
						  connection1.disconnect();
						  br.close();
//						  
						  urlAddr = "https://s1.u-vis.com/uvisc/InterfaceAction.do?method=Realtime&AccessKey="+keyObj.get("AccessKey");
						  postUrl = new URL(urlAddr); // ��û URL 
						  connection2 = (HttpURLConnection) postUrl.openConnection(); //URL ����
						  
						 		  
				br = new BufferedReader(new InputStreamReader(
						  (connection2.getInputStream()),"UTF-8"));

						  while ((output = br.readLine()) != null) {
						  result2 = result2 + output.trim();
						  
						  }	
						  
						  obj_location = parser.parse(result2);
						  jsonArr_location = (JSONArray) obj_location;
						  locationObj = (JSONObject)jsonArr_location.get(0);
						  
						  connection2.disconnect();
						  br.close();
				
						 	  
						  
				  urlAddr = "https://s1.u-vis.com/uvisc/SSOAction.do?method=TempInfoInterface&AccessKey="+keyObj.get("AccessKey");
				  postUrl = new URL(urlAddr); // ��û URL 
				  connection3 = (HttpURLConnection) postUrl.openConnection(); //URL ����	
				  
				  
				  br = new BufferedReader(new InputStreamReader(
						  (connection3.getInputStream()),"UTF-8"));

						  while ((output = br.readLine()) != null) {
						  result3 = result3 + output.trim();
						  
						  }	
						  
						  obj_temp = parser.parse(result3);
						  jsonArr_temp = (JSONArray) obj_temp;
						  tempObj = (JSONObject)jsonArr_temp.get(0);
						  
						  connection3.disconnect();
						  br.close();
						  
						  for(int i=0; i<jsonArr_location.size(); i++) {
							  locationObj = (JSONObject)jsonArr_location.get(i);
							  tempObj = (JSONObject)jsonArr_temp.get(i);
							  System.out.println("�µ�������ġ ���� : "+tempObj.get("X_POSITION"));
							  System.out.println("�µ�������ġ �浵 : "+tempObj.get("Y_POSITION"));
							  System.out.println("Aä�� ����/���� : "+tempObj.get("SIGNAL_A"));
							  System.out.println("Bä�� ����/���� : "+tempObj.get("SIGNAL_B"));
							  System.out.println("Aä�� �µ� : "+tempObj.get("DEGREE_A"));
							  System.out.println("Bä�� �µ� : "+tempObj.get("DEGREE_B"));
							  System.out.println("Aä�� �ּҿµ� : "+tempObj.get("TPL_MIN_A"));
							  System.out.println("Aä�� �ִ�µ� : "+tempObj.get("TPL_MAX_A"));
							  System.out.println("Bä�� �ּҿµ� : "+tempObj.get("TPL_MIN_B"));
							  System.out.println("Bä�� �ִ�µ� : "+tempObj.get("TPL_MAX_B"));
							  System.out.println("�ܸ��� ID : "+locationObj.get("TID_ID"));
							  System.out.println("������ȣ     : "+locationObj.get("CM_NUMBER"));
							  Date date = sdf.parse(locationObj.get("BI_DATE").toString() + locationObj.get("BI_TIME"));
							  String date_result = sdf2.format(date);
							  System.out.println("���˽ð�     : "+date_result);
							  System.out.println("�õ�����     : "+locationObj.get("BI_TURN_ONOFF"));

							  
							  
							  
//							  haccp_transit_data ���
							  data_jArray = new JSONObject();
							  data_jArray.put("censor_no", locationObj.get("TID_ID"));
							  data_jArray.put("vehicle_cd", locationObj.get("CM_NUMBER"));
							  data_jArray.put("receive_date", date_result);
							  data_jArray.put("turn_on_off", locationObj.get("BI_TURN_ONOFF"));
							  data_jArray.put("x_position", tempObj.get("X_POSITION"));
							  data_jArray.put("y_position", tempObj.get("Y_POSITION"));
							  data_jArray.put("signal_a", tempObj.get("SIGNAL_A"));
							  data_jArray.put("signal_b", tempObj.get("SIGNAL_B"));
							  data_jArray.put("degree_a", tempObj.get("DEGREE_A"));
							  data_jArray.put("degree_b", tempObj.get("DEGREE_B"));
							  data_jArray.put("min_temp_a", tempObj.get("TPL_MIN_A"));
							  data_jArray.put("min_temp_b", tempObj.get("TPL_MIN_B"));
							  data_jArray.put("max_temp_a", tempObj.get("TPL_MAX_A"));
							  data_jArray.put("max_temp_b", tempObj.get("TPL_MAX_B"));
							  
							  
//							  haccp_censor_data ���
							  data_jArray.put("serial", locationObj.get("TID_ID"));
							  data_jArray.put("measured_at", date_result);
							  data_jArray.put("channel", "0");
							  data_jArray.put("type", "temperature");
							  data_jArray.put("value", tempObj.get("DEGREE_A"));
							  data_jArray.put("member_key", "314-86-32370");
							  
							  if(!tempObj.get("X_POSITION").toString().equals("")) {
								 String result =  geo.location(Double.parseDouble(tempObj.get("X_POSITION").toString()), Double.parseDouble(tempObj.get("Y_POSITION").toString()));
								 System.out.println("��ġ��� : " + result);
								 data_jArray.put("location", result);
							  }
							  
							  
							  TableModel = new DoyosaeTableModel("M707S010100E501", data_jArray);
							  TableModel = new DoyosaeTableModel("M707S010600E105", data_jArray);
							  System.out.println("========================================================");
							  
							  
							  
							  
							  
						  }
						  
						  
						
						  
						  
					Thread.sleep(600000);	  
//					Thread.sleep(10000);	  
				
			}

		} catch (Exception e) {
			
			e.printStackTrace();

		}
	}
	
}




