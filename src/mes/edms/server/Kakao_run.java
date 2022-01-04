package mes.edms.server;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;


public class Kakao_run implements Runnable {
	public URL postUrl;
	public HttpURLConnection connection1;
	public HttpURLConnection connection2;
	public BufferedReader br;
	public String output;
	String result1="";
	public Object obj_key;
	public JSONParser parser = new JSONParser();
	public JSONArray jsonArr_key;
	public JSONObject keyObj;
	
	public Kakao_run() {
		
	}
	
	public void run(){
		try {
			while(!Thread.currentThread().isInterrupted()) {
								
				try {
					String urlAddr="";
//					한계기준이탈(최대값)
//					urlAddr = "http://121.138.241.20:8080/popbill/KakaoService/sendATS_multi_max.jsp"; //운영서버
					urlAddr = "http://localhost:8080/HACCP_WONWOO/popbill/KakaoService/sendATS_multi_max.jsp"; //개발 로컬
					postUrl = new URL(urlAddr); // 요청 URL 
					connection1 = (HttpURLConnection) postUrl.openConnection(); //URL 연결
					
					
					br = new BufferedReader(new InputStreamReader((connection1.getInputStream()), "UTF-8"));

					while ((output = br.readLine()) != null) {
						result1 = result1 + output.trim();

					}

					connection1.disconnect();
					br.close();
					
					System.out.println("한계기준 이탈시 알림톡 발송(최대값)");
					
//					한계기준이탈(최소값)
//					urlAddr = "http://121.138.241.20:8080/popbill/KakaoService/sendATS_multi.jsp"; //운영서버
					urlAddr = "http://localhost:8080/HACCP_WONWOO/popbill/KakaoService/sendATS_multi.jsp"; //개발 로컬
					postUrl = new URL(urlAddr); // 요청 URL 
					connection2 = (HttpURLConnection) postUrl.openConnection(); //URL 연결
					
					
					br = new BufferedReader(new InputStreamReader((connection2.getInputStream()), "UTF-8"));

					while ((output = br.readLine()) != null) {
						result1 = result1 + output.trim();

					}

					connection2.disconnect();
					br.close();
					
					System.out.println("한계기준 이탈시 알림톡 발송(최소값)");
					
				}catch (Exception e) {
					e.printStackTrace();
				}
				
				//한시간에 한 번
				Thread.sleep(3600000);
				
			}

		} catch (Exception e) {
			
			e.printStackTrace();

		}
	}
	
}