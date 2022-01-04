package mes.client.conf;

public class DepotConfig {
	//public static String DEPOT_GW = "172.30.7.128";
	public static String DEPOT_GW = "192.168.10.1";
	public static String DEPOT_SubNet_Mask = "255.255.255.0";
	//public static String DEPOT_IP = "172.30.7.1:81";
	//public static String DEPOT_IP = "192.168.10.243:81";
	//public static String CGI_URL = "http://" + DEPOT_IP + "/cgi-bin/";
	public static String CGI_READ_VALUE = "readVal.exe";
	public static String CGI_WRITE_VALUE = "writeVal.exe";
	public static String CGI_SET_VALUES = "setValues.exe";
	public static String CGI_ORDER_VALUES = "OrderValues.exe";
	public static String CGI_READ_FILE = "ReadFile.exe";
	// 
	public static String PREF_PDP = "PDP,,";
	public static String PREP_DATA_BLOCK_904 = "DB904.DB";
	
	public static String endingString = "]";
	public static String WAS = "RESIN";
	
	public static String getCgiUrl(String machineNumber) {
		String resultCgiUrl = "";
		if ("01".equals(machineNumber) || "1".equals(machineNumber)) {
			resultCgiUrl = "http://192.168.10.241:81/cgi-bin/";
		} else if ("02".equals(machineNumber) || "2".equals(machineNumber)) {
			resultCgiUrl = "http://192.168.10.243:81/cgi-bin/";
		} else if (machineNumber.equals("03") || machineNumber.equals("3")) {
			resultCgiUrl = "http://192.168.10.245:81/cgi-bin/";
		}
		return resultCgiUrl;
	}
}
