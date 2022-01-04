package mes.edms.server;
import java.util.ArrayList;

public class ByteSet {
	static String[] oven1 = new String[6];
	static String[] oven2 = new String[12];
	static String[] ovenRpm = new String[2];
	static String[] cooler = new String[4];
	static String[] coolerTmp = new String[1];
	static ArrayList<String[]> arr = new ArrayList<String[]>();
	
	public static void setData() {
		
		//1번 오븐온도
		oven1[0] = "2,0,OV01,temperature";
		oven1[1] = "2,1,OV02,temperature";
		oven1[2] = "2,2,OV03,temperature";
		oven1[3] = "2,3,OV04,temperature";
		oven1[4] = "2,4,OV05,temperature";
		oven1[5] = "2,5,OV06,temperature";

		//2번 오븐온도
		oven2[0]  = "0,0,OV07,temperature";
		oven2[1]  = "0,1,OV08,temperature";
		oven2[2]  = "0,2,OV09,temperature";
		oven2[3]  = "0,3,OV10,temperature";
		oven2[4]  = "0,4,OV11,temperature";
		oven2[5]  = "0,5,OV12,temperature";
		oven2[6]  = "0,6,OV13,temperature";
		oven2[7]  = "0,7,OV14,temperature";
		oven2[8]  = "0,8,OV15,temperature";
		oven2[9]  = "0,9,OV16,temperature";
		oven2[10] = "1,0,OV17,temperature";
		oven2[11] = "1,1,OV18,temperature";

		//오븐 컨베이어
		ovenRpm[0] = "1,2,CY01,RPM";
		ovenRpm[1] = "1,3,CY02,RPM";

		//냉각기 컨베이어
		cooler[0] = "3,0,COOLER01,RPM";
		cooler[1] = "3,1,COOLER02,RPM";
		cooler[2] = "3,2,COOLER03,RPM";
		cooler[3] = "3,3,COOLER04,RPM";
		
		//냉각기 온도
		coolerTmp[0] = "3,4,COOLER05,temperature"; 
		
		arr.add(oven1);
		arr.add(oven2);
		arr.add(ovenRpm);
		arr.add(cooler);
		arr.add(coolerTmp);
	}
}
