package mes.client.conf;

import java.io.FileReader;
import java.net.InetAddress;
import java.net.NetworkInterface;
import java.net.SocketException;
import java.util.Enumeration;

import org.apache.log4j.Logger;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import mes.client.guiComponents.DoyosaeTableModel;

public class SysConfig {
	
	static final Logger logger = Logger.getLogger(SysConfig.class.getName());
	
	// MES 서버
	public String server_ip = "";
	
	// 바코드 프린터
	public String barcode_print_ip = "";
	public int barcode_print_port = 0;
	
	// 온도 센서
	public String temperature_ip1 = "";
	public int temperature_port1 = 0;
	public String temperature_ip2 = "";
	public int temperature_port2 = 0;
	
	// 중량선별기
	public String weight_checker_ip = "";
	public int weight_checker_port = 0;

	// 금속검출기
	public String metal_detector_ip = "";
	public int metal_detector_port = 0;
	
	/* 안쓰는 듯? */
	public DoyosaeTableModel sysConfigModel;
	public String sys_config_key = "";
	public String sub_server_ip = "";
	public String vision_camera_ip = "";
	public String humidity_gage_ip = "";
	public String pressure_gage_ip = "";
	public String temprature_gage_ip = "";
	public String UTLZ = "";
	
	public JSONParser parser = null;
	public JSONObject jsonObject = null;
	
	public SysConfig() {
		String jsonFilePath = Config.sysConfigPath + "SysConfig.conf";
		
		try {
			parser = new JSONParser();
		    Object obj = parser.parse(new FileReader(jsonFilePath));
			jsonObject = (JSONObject) obj;
			
			this.server_ip = (String)jsonObject.get("server_ip");
			
			this.barcode_print_ip = (String)jsonObject.get("barcode_print_ip");
			this.barcode_print_port	= Integer.parseInt(jsonObject.get("barcode_print_port").toString());
			
			this.temperature_ip1 = (String)jsonObject.get("temperature_ip1");
			this.temperature_port1 = Integer.parseInt(jsonObject.get("temperature_port1").toString());
			this.temperature_ip2 = (String)jsonObject.get("temperature_ip2");
			this.temperature_port2 = Integer.parseInt(jsonObject.get("temperature_port2").toString());
			
			this.weight_checker_ip = (String)jsonObject.get("weight_checker_ip");
			this.weight_checker_port = Integer.parseInt(jsonObject.get("weight_checker_port").toString());
			
			this.metal_detector_ip = (String)jsonObject.get("metal_detector_ip");
			this.metal_detector_port = Integer.parseInt(jsonObject.get("metal_detector_port").toString());
			
			/* 2021 02 13 최현수
			 * 안쓰는 것 같은 변수들(나중에 정리하기) needtocheck
			 * */
			this.sub_server_ip = (String)jsonObject.get("sub_server_ip");
			this.vision_camera_ip = (String)jsonObject.get("vision_camera_ip");
			this.humidity_gage_ip = (String)jsonObject.get("humidity_gage_ip");
			this.pressure_gage_ip = (String)jsonObject.get("pressure_gage_ip");
			this.temprature_gage_ip = (String)jsonObject.get("temprature_gage_ip");
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		GetServerIP();
		logger.debug("Server IP = " + this.server_ip);

		this.UTLZ = (String) jsonObject.get(this.server_ip);
//		if(server_ip.equals("192.168.10.80")) {
//			UTLZ="UTLZ_1";
//		}else if (server_ip.equals("192.168.10.81")) {
//			UTLZ="UTLZ_2";
//		}else if (server_ip.equals("192.168.10.82")) {
//			UTLZ="UTLZ_3";
//		}else if (server_ip.equals("192.168.10.83")) {
//			UTLZ="UTLZ_4";
//		}else if (server_ip.equals("192.168.0.19")) {
//			UTLZ="UTLZ_5";
//		}
	}
	
	public void GetServerIP() {
		try {
			Enumeration<NetworkInterface> nienum = NetworkInterface.getNetworkInterfaces();

			while (nienum.hasMoreElements()) {
				NetworkInterface ni = nienum.nextElement();
				Enumeration<InetAddress> kk= ni.getInetAddresses();

				while (kk.hasMoreElements()) {
					InetAddress inetAddress = kk.nextElement();
					if(!inetAddress.isLoopbackAddress() && 
					   !inetAddress.isLinkLocalAddress() && 
					   inetAddress.isSiteLocalAddress()) {
						this.server_ip = inetAddress.getHostAddress().toString();
					}
				}
			}
		} catch (SocketException e) {
			e.printStackTrace();
		}
	}
}