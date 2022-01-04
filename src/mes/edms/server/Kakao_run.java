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
//					�Ѱ������Ż(�ִ밪)
//					urlAddr = "http://121.138.241.20:8080/popbill/KakaoService/sendATS_multi_max.jsp"; //�����
					urlAddr = "http://localhost:8080/HACCP_WONWOO/popbill/KakaoService/sendATS_multi_max.jsp"; //���� ����
					postUrl = new URL(urlAddr); // ��û URL 
					connection1 = (HttpURLConnection) postUrl.openConnection(); //URL ����
					
					
					br = new BufferedReader(new InputStreamReader((connection1.getInputStream()), "UTF-8"));

					while ((output = br.readLine()) != null) {
						result1 = result1 + output.trim();

					}

					connection1.disconnect();
					br.close();
					
					System.out.println("�Ѱ���� ��Ż�� �˸��� �߼�(�ִ밪)");
					
//					�Ѱ������Ż(�ּҰ�)
//					urlAddr = "http://121.138.241.20:8080/popbill/KakaoService/sendATS_multi.jsp"; //�����
					urlAddr = "http://localhost:8080/HACCP_WONWOO/popbill/KakaoService/sendATS_multi.jsp"; //���� ����
					postUrl = new URL(urlAddr); // ��û URL 
					connection2 = (HttpURLConnection) postUrl.openConnection(); //URL ����
					
					
					br = new BufferedReader(new InputStreamReader((connection2.getInputStream()), "UTF-8"));

					while ((output = br.readLine()) != null) {
						result1 = result1 + output.trim();

					}

					connection2.disconnect();
					br.close();
					
					System.out.println("�Ѱ���� ��Ż�� �˸��� �߼�(�ּҰ�)");
					
				}catch (Exception e) {
					e.printStackTrace();
				}
				
				//�ѽð��� �� ��
				Thread.sleep(3600000);
				
			}

		} catch (Exception e) {
			
			e.printStackTrace();

		}
	}
	
}