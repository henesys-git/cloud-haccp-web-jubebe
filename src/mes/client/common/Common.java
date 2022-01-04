package mes.client.common;

import java.io.DataOutputStream;
import java.io.OutputStreamWriter;
import java.net.Socket;
import java.text.DecimalFormat;
import java.util.Calendar;
import java.util.StringTokenizer;
import java.util.Vector;

import mes.client.comm.DBServletLink;
import mes.client.util.Convert;


public class Common {
	public static synchronized String[] split(String str, String delimiter, boolean bEmpty) throws Exception {
		if (str == null) throw new Exception("CodeUtil.split() : Illegal parameter 'str'. It is null.");

		if (delimiter == null || delimiter.equals("")) {
			String[] ret = { str };
			return ret;
		}

		if (bEmpty) {
			Vector vector = new Vector();
			
			int start = 0;
			int end = 0;
			while ((end = str.indexOf(delimiter, start)) != -1) {
				String token = str.substring(start, end);
				vector.add(token);
				start = end + delimiter.length();
			}
			vector.add(str.substring(start).trim());

			String[] ret = new String[vector.size()];
			vector.copyInto(ret);
			return ret;
		} else { // ���� ����
			StringTokenizer st = new StringTokenizer(str, delimiter);

			String ret[] = new String[st.countTokens()];
			int cnt = 0;
			while (st.hasMoreTokens()) {
				ret[cnt++] = st.nextToken().trim();
			}
			return ret;
		}
	}

	public static String[] getViewType() {
		String[] viewType = {
				"����","�µ�","����","�߷�","�з�",
				"����","����","ī����","Ÿ�̸�","����",
				"������","�̹���","��ġ"};
		return viewType;
	}
	
	public static int getInt(String str) {
	    int retInt = 0;
	    try {
	        retInt = Integer.parseInt(str.trim());
	    } catch (Exception e) {
	    }
	    return retInt;
	}
	
	public static double getDouble(String str) {
	    double retDouble = 0;
	    try {
	        retDouble = Double.parseDouble(str.trim());
	    } catch (Exception e) {
	    }
	    return retDouble;
	}
	
    public static String getFormatData(String value, String format) {
       	int intValue = 0;
       	try {
       	    intValue = Integer.parseInt(value.trim());
       	} catch (Exception e) {
       	}
       	DecimalFormat df = new DecimalFormat(format);
       	String tempStr = df.format(intValue);
       	return tempStr;
   	}
    
    public static String getFormatData(int value, String format) {
    	DecimalFormat df = new DecimalFormat(format);
    	String tempStr = df.format(value);
    	return tempStr;
	}
    
    public static String getFormatData(double value, String format) {
    	DecimalFormat df = new DecimalFormat(format);
    	String tempStr = df.format(value);
    	return tempStr;
	}
    
    public static String checkNullNumericFormat(String tConVal, String format, int length) {
        return "";
    }
    
    public static boolean checkNumeric(String numStr, char sep) {
    	boolean resultBoolean = true;
    	int checkedCount = 0;
    	int checkCount = 0;
     
    	try{
    	    // �糡�� �����ڸ� �����..
    	    numStr = numStr.trim();
    	    if (numStr.length() == 0) return false;
        	char[] arrChar = new char[numStr.length()];
        	checkCount = numStr.length();
         
        	// �� ����Ʈ�� �˻��Ѵ�.
    	    for (int i=0; i<numStr.length(); i++) {
    	        char ch = numStr.charAt(i);
    	        if (ch=='0'||ch=='1'||ch=='2'||ch=='3'||ch=='4'||ch=='5'||ch=='6'||ch=='7'||ch=='8'||ch=='9'||ch==sep) {
    	        	checkedCount++;
    	        } else {
    	        	break;
    	        }
    	    }
    	    if (checkCount == checkedCount) {
    	    	resultBoolean = true;
    	    } else {
    	    	resultBoolean = false;
    	    }
    	} catch(Exception ex) {
    	    return false;
    	}
    	return resultBoolean;
    }

    public static int getIntFilter(String numStr) {
    	boolean cont = true;
     
    	try{
    	    // �糡�� �����ڸ� �����..
    	    numStr = numStr.trim();
    	    if (numStr.length() == 0) return 0;
        	char[] arrChar = new char[numStr.length()];
         
        	// �� ����Ʈ�� �˻��Ѵ�.
        	int nonumCount = 0;
        	int resSize = 0;
    	    for (int i=0; i<numStr.length(); i++) {
    	        char ch = numStr.charAt(i);
    	        if (ch=='0'||ch=='1'||ch=='2'||ch=='3'||ch=='4'||ch=='5'||ch=='6'||ch=='7'||ch=='8'||ch=='9'||ch=='-') {
    	        } else {
    	            nonumCount++;
    	    	    continue;
    	        }
    	    
    	        resSize = i-nonumCount;
    	        arrChar[resSize] = ch;
    	    }
    	    resSize++;
    	    char[] retArrChar = new char[resSize];
    	    for (int j=0; j<resSize; j++) {
    	        retArrChar[j] = arrChar[j];
    	    }

    	    String strvalue = new String(retArrChar);
    	    return Integer.parseInt(strvalue);
    	} catch(Exception ex) {
    	    return 0;
    	}
    }
    
    public static long getLongFilter(String numStr) {
    	boolean cont = true;
     
    	try{
    	    // �糡�� �����ڸ� �����..
    	    numStr = numStr.trim();
    	    if (numStr.length() == 0) return 0;
        	char[] arrChar = new char[numStr.length()];
         
        	// �� ����Ʈ�� �˻��Ѵ�.
        	int nonumCount = 0;
        	int resSize = 0;
    	    for (int i=0; i<numStr.length(); i++) {
    	        char ch = numStr.charAt(i);
    	        if (ch=='0'||ch=='1'||ch=='2'||ch=='3'||ch=='4'||ch=='5'||ch=='6'||ch=='7'||ch=='8'||ch=='9'||ch=='-') {
    	        } else {
    	            nonumCount++;
    	    	    continue;
    	        }
    	    
    	        resSize = i-nonumCount;
    	        arrChar[resSize] = ch;
    	    }
    	    resSize++;
    	    char[] retArrChar = new char[resSize];
    	    for (int j=0; j<resSize; j++) {
    	        retArrChar[j] = arrChar[j];
    	    }

    	    String strvalue = new String(retArrChar);
    	    return Long.parseLong(strvalue);
    	} catch(Exception ex) {
    	    return 0;
    	}
    }
   
    public static int getIntFilterDot(String numStr) {
    	boolean cont = true;
     
    	try{
    	    // �糡�� �����ڸ� �����..
    	    numStr = numStr.trim();
    	    if (numStr.length() == 0) return 0;
        	char[] arrChar = new char[numStr.length()];
         
        	// �� ����Ʈ�� �˻��Ѵ�.
        	int nonumCount = 0;
        	int resSize = 0;
    	    for (int i=0; i<numStr.length(); i++) {
    	        char ch = numStr.charAt(i);
    	        if (ch=='0'||ch=='1'||ch=='2'||ch=='3'||ch=='4'||ch=='5'||ch=='6'||ch=='7'||ch=='8'||ch=='9'||ch=='-'||ch=='.') {
    	        } else {
    	            nonumCount++;
    	    	    continue;
    	        }
    	    
    	        resSize = i-nonumCount;
    	        arrChar[resSize] = ch;
    	    }
    	    resSize++;
    	    char[] retArrChar = new char[resSize];
    	    for (int j=0; j<resSize; j++) {
    	        retArrChar[j] = arrChar[j];
    	    }

    	    String strvalue = new String(retArrChar);
    	    return Integer.parseInt(strvalue);
    	} catch(Exception ex) {
    	    return 0;
    	}
    }       

    public static double getDoubleFilter(String numStr) {
    	boolean cont = true;
     
    	try{
    	    // �糡�� �����ڸ� �����..
    	    numStr = numStr.trim();
    	    if (numStr.length() == 0) return 0;
        	char[] arrChar = new char[numStr.length()];
         
        	// �� ����Ʈ�� �˻��Ѵ�.
        	int nonumCount = 0;
        	int resSize = 0;
    	    for (int i=0; i<numStr.length(); i++) {
    	        char ch = numStr.charAt(i);
    	        if (ch=='0'||ch=='1'||ch=='2'||ch=='3'||ch=='4'||ch=='5'||ch=='6'||ch=='7'||ch=='8'||ch=='9'||ch=='-'||ch=='.') {
    	        } else {
    	            nonumCount++;
    	    	    continue;
    	        }
    	    
    	        resSize = i-nonumCount;
    	        arrChar[resSize] = ch;
    	    }
    	    resSize++;
    	    char[] retArrChar = new char[resSize];
    	    for (int j=0; j<resSize; j++) {
    	        retArrChar[j] = arrChar[j];
    	    }

    	    String strvalue = new String(retArrChar);
    	    return Double.parseDouble(strvalue);
    	} catch(Exception ex) {
    	    return 0;
    	}
    }
    

	public static String getSystemTime(String strDateTime) {
		String retStr = "";
		//�ý��۳�¥�� �����.
		Calendar       date    = Calendar.getInstance();
		int            sysYYYY = date.get(Calendar.YEAR);
		int            sysMM   = date.get(Calendar.MONTH)+1;
		int            sysDD   = date.get(Calendar.DAY_OF_MONTH);
		DecimalFormat  df4  = new DecimalFormat("0000");
		DecimalFormat  df2    = new DecimalFormat("00");
		String         strYYYY = df4.format(sysYYYY);
		String         strMM   = df2.format(sysMM);
		String         strDD   = df2.format(sysDD);
		String         sysDate = strYYYY + "-" + strMM + "-" + strDD;
		String         sysDateNumeric = strYYYY + strMM + strDD;

		int sysHour = date.get(Calendar.HOUR_OF_DAY);
		int sysMinute = date.get(Calendar.MINUTE);
		int sysSecond = date.get(Calendar.SECOND);
		String strHour = df2.format(sysHour);
		String strMinute = df2.format(sysMinute);
		String strSecond = df2.format(sysSecond);
		String sysTime = strHour + ":" + strMinute + ":" + strSecond;
		String sysTimeNumeric = strHour + strMinute + strSecond;

		if (strDateTime.equals("date")) retStr = sysDate;
		else if (strDateTime.equals("time")) retStr = sysTime;
		else if (strDateTime.equals("dateNumeric")) retStr = sysDateNumeric;
		else if (strDateTime.equals("timeNumeric")) retStr = sysTimeNumeric;
		else if (strDateTime.equals("datetime")) retStr = sysDate + sysTime;
		else if (strDateTime.equals("datetimeNumeric")) retStr = sysDateNumeric + sysTimeNumeric;

		return retStr;
	}
    
	public static String getSystemTime(String strDateTime, String gubun) {
		String retStr = "";
		//�ý��۳�¥�� �����.
		//String gubun: -, ., 
		Calendar       date    = Calendar.getInstance();
		int            sysYYYY = date.get(Calendar.YEAR);
		int            sysMM   = date.get(Calendar.MONTH)+1;
		int            sysDD   = date.get(Calendar.DAY_OF_MONTH);
		DecimalFormat  df4  = new DecimalFormat("0000");
		DecimalFormat  df2    = new DecimalFormat("00");
		String         strYYYY = df4.format(sysYYYY);
		String         strMM   = df2.format(sysMM);
		String         strDD   = df2.format(sysDD);
		String         sysDate = strYYYY + gubun + strMM + gubun + strDD;
		String         sysDateNumeric = strYYYY + strMM + strDD;

		int sysHour = date.get(Calendar.HOUR_OF_DAY);
		int sysMinute = date.get(Calendar.MINUTE);
		int sysSecond = date.get(Calendar.SECOND);
		String strHour = df2.format(sysHour);
		String strMinute = df2.format(sysMinute);
		String strSecond = df2.format(sysSecond);
		String sysTime = strHour + ":" + strMinute + ":" + strSecond;
		String sysTimeNumeric = strHour + strMinute + strSecond;

		if (strDateTime.equals("date")) retStr = sysDate;
		else if (strDateTime.equals("time")) retStr = sysTime;
		else if (strDateTime.equals("dateNumeric")) retStr = sysDateNumeric;
		else if (strDateTime.equals("timeNumeric")) retStr = sysTimeNumeric;
		else if (strDateTime.equals("datetime")) retStr = sysDate + sysTime;
		else if (strDateTime.equals("datetimeNumeric")) retStr = sysDateNumeric + sysTimeNumeric;

		return retStr;
	}
	
	//�ùٸ� ��ȭ��ȣ������ üũ�Ѵ�.
	public static String checkTelno(String telnoStr) {
		// ���� ��ȭ��ȣ�� ���̰� �����Ѱ�?
		telnoStr = telnoStr.trim();
		int len = telnoStr.length();
		if (len < 9) return "NOTELNO";
		
		char[] telnoChar = telnoStr.toCharArray();
		len = telnoChar.length;
		char[] retTelnoChar = new char[len];
		for (int i=0; i<len; i++) {
			if (!Character.isDigit(telnoChar[i])) break;
			retTelnoChar[i] = telnoChar[i];
		}
		telnoStr = new String(retTelnoChar);
		return telnoStr.trim();
	}

    //���ڰ� �´��� üũ�Ѵ�.
    public static boolean dateCheck(String date){
    	if (date == null) return false;

    	String checkDate = date;
    	int check_dd = 0;
    	int result = 0;
    	int remain = 0;
	   
    	if(checkDate.length() != 10){
    		return false;
    	}
			
    	int yyyy = Integer.parseInt(checkDate.substring(0,4));
    	int mm = Integer.parseInt(checkDate.substring(5,7));
    	int dd = Integer.parseInt(checkDate.substring(8,10));
							
    	if (yyyy < 1900) return false;
    	if (mm < 1 || mm > 12) return false;
    	if (dd < 1 || dd > 31) return false;
										
    	if (mm==1 || mm==3 || mm==5 || mm==7 || mm==8 || mm==10 || mm==12) {
    		check_dd = 31;
    		if (dd > check_dd) return false;
    		else return true;
    	} else if (mm == 2) {
    		// ������ ����Ѵ�. �׸��� ����. dd��...
    		result = (int)(yyyy / 100);
    		remain = yyyy - (result * 100);
    		if (remain == 0) remain = result;
    		result = (int)(remain / 4);
    		remain = remain - (result * 4);
    		if (remain == 0) {
    			check_dd = 29;
    			if (dd > check_dd) return false;
    			else return true;
    		} else {
    			check_dd = 28;
    			if (dd > check_dd) return false;
    			else return true;
    		}
    	} else {
    		check_dd = 30;
    		if (dd > check_dd) return false;
    		else return true;
    	}
    }
    
    public static String convDirFormW2U(String winForm) {
    	String returnForm = "";
    	try {
	    	String[] fields = split(winForm, "\\", true);
	    	for (int i=0; i<fields.length; i++) {
	    		returnForm += fields[i] + "/";
	    	}
	    	returnForm = returnForm.substring(0, returnForm.lastIndexOf("/"));
    	} catch (Exception e) {
    	}
    	return returnForm;
    }

    // �޺��ڽ��� �� �ο��з�(��,��,��)�� �����´�.
    public static Vector getMinwonData (String gubun) {
    	DBServletLink dbServletLink = new DBServletLink();
		Vector retVector = new Vector();
    	dbServletLink.connectURL("M04S050E099");
		retVector = dbServletLink.getSingleVector(gubun);
    	return retVector ;
	}
    // �ο� ��з� ���ý�   �ߺз� �޺������� ü���� 
    public static Vector getMComboUpdateFromBCombo (String param) {
    	DBServletLink dbServletLink = new DBServletLink();
		Vector retVector = new Vector();
    	dbServletLink.connectURL("M04S050E088");
		retVector = dbServletLink.getSingleVector(param);
    	return retVector ;
	}
    // �ο� ��з� ���ý�   �Һз� �޺������� ü���� 
    public static Vector getSComboUpdateFromBCombo (String param) {
    	DBServletLink dbServletLink = new DBServletLink();
		Vector retVector = new Vector();
    	dbServletLink.connectURL("M04S050E077");
		retVector = dbServletLink.getSingleVector(param);
    	return retVector ;
	}
    // �ο� �ߺз� ���ý�   �Һз� �޺������� ü���� 
    public static Vector getSComboUpdateFromMCombo (String param) {
    	DBServletLink dbServletLink = new DBServletLink();
		Vector retVector = new Vector();
    	dbServletLink.connectURL("M04S050E066");
		retVector = dbServletLink.getSingleVector(param);
    	return retVector ;
	}

    // �����׷��ڵ尡������ 
    public static Vector getUSRGRPData() {
    	DBServletLink dbServletLink = new DBServletLink(); 
        dbServletLink.connectURL("M02S010E024");
        Vector retVector  = dbServletLink.getSingleVector(" ");
        return retVector;
        }

    // �����׷��̸��������� 
	public static Vector getUSRGRPData2() {
		DBServletLink dbServletLink = new DBServletLink(); 
	    dbServletLink.connectURL("M02S010E034");
	    Vector retVector2  = dbServletLink.getSingleVector(" ");
	    return retVector2;
    }
	
	public static String getTelnoHipen(String telno) {
		String TelNo = "";
		String DDD = "";
		telno = Convert.getDecimal(telno);
		int telLen = telno.trim().length();
		
		// �����ȵ�
		if (telLen < 9 || telLen > 11) {
			return telno;
		}
		
		String headStr = telno.substring(0,3);
		int    headInt = 0;
		try {
			headInt = Integer.parseInt(headStr);
		} catch(Exception e) {
			return telno;
		}
		
		try {
			if( headInt >= 10 && headInt < 20 ){
			    //�ڵ���
			    if (headStr.equals("013")) {
					if(telLen == 11){
					    DDD = telno.substring(0,4);
					    TelNo =  telno.substring(4,7) + "-" + telno.substring(7,11);
					} else {
					    DDD = telno.substring(0,4);
					    TelNo = telno.substring(4,8) + "-" + telno.substring(8,12);
					}
				}else{
					if(telLen == 10){
					    DDD = telno.substring(0,3);
					    TelNo =  telno.substring(3,6) + "-" + telno.substring(6,10);
					}else{
					    DDD = telno.substring(0,3);
					    TelNo = telno.substring(3,7) + "-" + telno.substring(7,11);
					}
			    }
			}else if(headInt >= 20 && headInt < 30 ){
			    //����
			    if(telLen == 9){
			    	DDD = telno.substring(0,2);
					TelNo = telno.substring(2,5) + "-" + telno.substring(5,9);
				}else{
					DDD = telno.substring(0,2);
					TelNo = telno.substring(2,6) + "-" + telno.substring(6,10);
			    }
			}else if(headInt == 30){
			    //����
			    if(telLen == 12){
					DDD = telno.substring(0,4);
					TelNo = telno.substring(4,8) + "-" + telno.substring(8,12);
				    }else {
					DDD = telno.substring(0,4);
					TelNo = telno.substring(4,7) + "-" + telno.substring(7,11);
			    }
			}else if(headInt > 30 && headInt < 50 ){
			    //����
			    if(telLen == 10){
					DDD = telno.substring(0,3);
					TelNo = telno.substring(3,6) + "-" + telno.substring(6,10);
			    }else{
			    	DDD = telno.substring(0,3);
			    	TelNo = telno.substring(3,7) + "-" + telno.substring(7,11);
			    }
			}else if(headInt == 50){
			    //����
			    if(telLen == 12){
					DDD = telno.substring(0,4);
					TelNo = telno.substring(4,8) + "-" + telno.substring(8,12);
			    }else {
					DDD = telno.substring(0,4);
					TelNo = telno.substring(4,7) + "-" + telno.substring(7,11);
			    }
			}else if(headInt > 50 && headInt < 70 ){
			    //����
			    if(telLen == 10){
					DDD = telno.substring(0,3);
					TelNo = telno.substring(3,6) + "-" + telno.substring(6,10);
			    }else{
					DDD = telno.substring(0,3);
					TelNo = telno.substring(3,7) + "-" + telno.substring(7,11);
			    }
			}else if(headInt == 70 ){
				// VOIP
				DDD = telno.substring(0,3);
				TelNo = telno.substring(3,7) + "-" + telno.substring(7,11);
			}else{
			    //�ܱ�
			    System.out.println("�ܱ� " + telno);
			    TelNo = telno;
			}
		} catch(Exception e){
			DDD = "";
			TelNo = "";
		}
		
		String newTel = "";
		if(DDD.equals("") && TelNo.equals("")) {
			newTel = telno;
		} else {
			newTel = (DDD + "-" + TelNo);
		}
		return  newTel;
	}

    public static String getPartCodeBar(String partCode) {
    	String retStr = "";
    	retStr = partCode.substring(0,5) + "-" + partCode.substring(5, 10);
    	if (partCode.length() > 10) {
    		retStr += "-" + partCode.substring(10);
    	}
    	return retStr;
    }
    

    public static String BarcodePrint(String partCode) {
    	String retStr = "";
        System.out.println("--------------start-------------------");
        String returnValue = "";
        
        Socket socket = null;
        String ip = "192.168.1.202";//ip
        int port = 8000;//port
        String msg = null;
        String vPart_Code="24LC16B1";   //Part Code
        
        String barcodePrintMessage = "";
           barcodePrintMessage += "{C|}\n";
           barcodePrintMessage += "{AX;+000,+000,+00|}\n";
           barcodePrintMessage += "{AY;+09,0|}\n";
           barcodePrintMessage += "{C|}\n";
           barcodePrintMessage += "{D0330,0500,0300|}\n";
           // 0070(X��ǥ),0070(Y��ǥ),9(���ڵ�Ÿ��),1(üũ����Ʈ),02(��Ʈ��),0,0100,+0000000000,000,1,00
           barcodePrintMessage += "{XB01;0110,0100,9,1,02,0,0100,+0000000000,000,1,00|}\n";
           barcodePrintMessage += "{RB01;" + vPart_Code + "|}\n";   
           barcodePrintMessage += "{XS;I,0001,0002C5101|}\n";

        
//        String txt = null;
//        //����ü , ���� , 14
//        txt = "" 
//           +"{LC;0050,0140,0920,0310,1,2|}" // box
//           +"{LC;0050,0183,0920,0183,0,2|}" // 1 hor line
//           +"{LC;0050,0225,0920,0225,0,2|}" // 2 hor line
//           +"{LC;0050,0267,0920,0267,0,2|}" // 3 hor line
//           +"{LC;0200,0140,0200,0310,0,2|}" //1 ver line
//           +"{LC;0610,0140,0610,0225,0,2|}" //2-1ver line
//           +"{LC;0610,0267,0610,0310,0,2|}" //ver line
//           +"{LC;0740,0140,0740,0225,0,2|}" //ver line
//           +"{LC;0740,0267,0740,0310,0,2|}" //ver line
//           +"{PC004;0100,0145,1,2,51,-07,00,B,+0000000000|}{RC004;������ȣ|}"//�ѱ����
//           +"{PC002;0100,0190,1,2,51,-07,00,B,+0000000000|}{RC002;��ǰ��|}"
//           +"{PC003;0100,0230,1,2,51,-07,00,B,+0000000000|}{RC003;�԰ݸ�|}"
//           +"{PC004;0100,0275,1,2,51,-07,00,B,+0000000000|}{RC004;�з���ȣ|}"
//           +"{PC005;0640,0145,1,2,51,-07,00,B,+0000000000|}{RC005;���ܰ�|}"
//           +"{PC006;0640,0190,1,2,51,-07,00,B,+0000000000|}{RC006;�������|}"
//           +"{PC007;0640,0275,1,2,51,-07,00,B,+0000000000|}{RC007;ȸ�豸��|}"
//           //+"{XS;I,0001,0004C5101|}" 
//           ;
//        
//        //RFID�±� ��� 
//        String RFID01 = ""
//           + "{@003;+0150,0|}" //RFID
//           + "{XB01;0000,0000,r,T24,G2,L00,B01|}" //RFID
//           + "{RB01;1234567890|}" //RFID write 0800��¹�����unicode��00
//           ;
//        
//        msg =    "{C|}{AX;+000,+000,+00|}{AY;+00,0|}{D0500,0940,0450|}" 
//           + txt
//           //+ RFID01 //RFID print�� �ӽ÷� �ּ�ó����. 
//           + "{XS;I,0001,0004C5101|}"
//           ;//
  //    
       
        DataOutputStream out = null;
        OutputStreamWriter osw = null;
        try {
           socket = new Socket(ip, port);
           socket.setSoTimeout( 1000 );
           osw = new OutputStreamWriter(socket.getOutputStream(), "KSC5601" );
           //osw.write(msg );
           osw.write(barcodePrintMessage );
           osw.flush();
        }catch (Exception e) {
           e.printStackTrace();
           System.out.println("Exception e : " + e.toString() );
        }finally{
           if(osw != null){ try{ osw.close(); }catch(Exception e){ osw = null; }}
           if(out != null){ try{ out.close(); }catch(Exception e){ out = null; }}
           if(socket != null){ try{ socket.close(); }catch(Exception e){ socket = null; }}
        }
        System.out.println("--------------end;-------------------");
        
    	return retStr;
    }
}