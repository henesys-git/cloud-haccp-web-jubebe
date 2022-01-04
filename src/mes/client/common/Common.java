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
		} else { // 공백 무시
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
				"개폐","온도","습도","중량","압력",
				"유량","수위","카운터","타이머","사운드",
				"동영상","이미지","위치"};
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
    	    // 양끝의 투명문자를 지우고..
    	    numStr = numStr.trim();
    	    if (numStr.length() == 0) return false;
        	char[] arrChar = new char[numStr.length()];
        	checkCount = numStr.length();
         
        	// 한 바이트씩 검사한다.
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
    	    // 양끝의 투명문자를 지우고..
    	    numStr = numStr.trim();
    	    if (numStr.length() == 0) return 0;
        	char[] arrChar = new char[numStr.length()];
         
        	// 한 바이트씩 검사한다.
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
    	    // 양끝의 투명문자를 지우고..
    	    numStr = numStr.trim();
    	    if (numStr.length() == 0) return 0;
        	char[] arrChar = new char[numStr.length()];
         
        	// 한 바이트씩 검사한다.
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
    	    // 양끝의 투명문자를 지우고..
    	    numStr = numStr.trim();
    	    if (numStr.length() == 0) return 0;
        	char[] arrChar = new char[numStr.length()];
         
        	// 한 바이트씩 검사한다.
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
    	    // 양끝의 투명문자를 지우고..
    	    numStr = numStr.trim();
    	    if (numStr.length() == 0) return 0;
        	char[] arrChar = new char[numStr.length()];
         
        	// 한 바이트씩 검사한다.
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
		//시스템날짜를 만든다.
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
		//시스템날짜를 만든다.
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
	
	//올바른 전화번호인지를 체크한다.
	public static String checkTelno(String telnoStr) {
		// 먼저 전화번호의 길이가 적당한가?
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

    //일자가 맞는지 체크한다.
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
    		// 윤달을 계산한다. 그리고 쓴다. dd를...
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

    // 콤보박스에 들어갈 민원분류(대,중,소)를 가져온다.
    public static Vector getMinwonData (String gubun) {
    	DBServletLink dbServletLink = new DBServletLink();
		Vector retVector = new Vector();
    	dbServletLink.connectURL("M04S050E099");
		retVector = dbServletLink.getSingleVector(gubun);
    	return retVector ;
	}
    // 민원 대분류 선택시   중분류 콤보데이터 체인지 
    public static Vector getMComboUpdateFromBCombo (String param) {
    	DBServletLink dbServletLink = new DBServletLink();
		Vector retVector = new Vector();
    	dbServletLink.connectURL("M04S050E088");
		retVector = dbServletLink.getSingleVector(param);
    	return retVector ;
	}
    // 민원 대분류 선택시   소분류 콤보데이터 체인지 
    public static Vector getSComboUpdateFromBCombo (String param) {
    	DBServletLink dbServletLink = new DBServletLink();
		Vector retVector = new Vector();
    	dbServletLink.connectURL("M04S050E077");
		retVector = dbServletLink.getSingleVector(param);
    	return retVector ;
	}
    // 민원 중분류 선택시   소분류 콤보데이터 체인지 
    public static Vector getSComboUpdateFromMCombo (String param) {
    	DBServletLink dbServletLink = new DBServletLink();
		Vector retVector = new Vector();
    	dbServletLink.connectURL("M04S050E066");
		retVector = dbServletLink.getSingleVector(param);
    	return retVector ;
	}

    // 유저그룹코드가져오기 
    public static Vector getUSRGRPData() {
    	DBServletLink dbServletLink = new DBServletLink(); 
        dbServletLink.connectURL("M02S010E024");
        Vector retVector  = dbServletLink.getSingleVector(" ");
        return retVector;
        }

    // 유저그룹이름가져오기 
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
		
		// 성립안됨
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
			    //핸드폰
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
			    //서울
			    if(telLen == 9){
			    	DDD = telno.substring(0,2);
					TelNo = telno.substring(2,5) + "-" + telno.substring(5,9);
				}else{
					DDD = telno.substring(0,2);
					TelNo = telno.substring(2,6) + "-" + telno.substring(6,10);
			    }
			}else if(headInt == 30){
			    //서울
			    if(telLen == 12){
					DDD = telno.substring(0,4);
					TelNo = telno.substring(4,8) + "-" + telno.substring(8,12);
				    }else {
					DDD = telno.substring(0,4);
					TelNo = telno.substring(4,7) + "-" + telno.substring(7,11);
			    }
			}else if(headInt > 30 && headInt < 50 ){
			    //지방
			    if(telLen == 10){
					DDD = telno.substring(0,3);
					TelNo = telno.substring(3,6) + "-" + telno.substring(6,10);
			    }else{
			    	DDD = telno.substring(0,3);
			    	TelNo = telno.substring(3,7) + "-" + telno.substring(7,11);
			    }
			}else if(headInt == 50){
			    //서울
			    if(telLen == 12){
					DDD = telno.substring(0,4);
					TelNo = telno.substring(4,8) + "-" + telno.substring(8,12);
			    }else {
					DDD = telno.substring(0,4);
					TelNo = telno.substring(4,7) + "-" + telno.substring(7,11);
			    }
			}else if(headInt > 50 && headInt < 70 ){
			    //지방
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
			    //외국
			    System.out.println("외국 " + telno);
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
           // 0070(X좌표),0070(Y좌표),9(바코드타입),1(체크디짓트),02(돗트수),0,0100,+0000000000,000,1,00
           barcodePrintMessage += "{XB01;0110,0100,9,1,02,0,0100,+0000000000,000,1,00|}\n";
           barcodePrintMessage += "{RB01;" + vPart_Code + "|}\n";   
           barcodePrintMessage += "{XS;I,0001,0002C5101|}\n";

        
//        String txt = null;
//        //굴림체 , 굵게 , 14
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
//           +"{PC004;0100,0145,1,2,51,-07,00,B,+0000000000|}{RC004;관리번호|}"//한글출력
//           +"{PC002;0100,0190,1,2,51,-07,00,B,+0000000000|}{RC002;물품명|}"
//           +"{PC003;0100,0230,1,2,51,-07,00,B,+0000000000|}{RC003;규격명|}"
//           +"{PC004;0100,0275,1,2,51,-07,00,B,+0000000000|}{RC004;분류번호|}"
//           +"{PC005;0640,0145,1,2,51,-07,00,B,+0000000000|}{RC005;취득단가|}"
//           +"{PC006;0640,0190,1,2,51,-07,00,B,+0000000000|}{RC006;취득일자|}"
//           +"{PC007;0640,0275,1,2,51,-07,00,B,+0000000000|}{RC007;회계구분|}"
//           //+"{XS;I,0001,0004C5101|}" 
//           ;
//        
//        //RFID태그 출력 
//        String RFID01 = ""
//           + "{@003;+0150,0|}" //RFID
//           + "{XB01;0000,0000,r,T24,G2,L00,B01|}" //RFID
//           + "{RB01;1234567890|}" //RFID write 0800출력문자의unicode값00
//           ;
//        
//        msg =    "{C|}{AX;+000,+000,+00|}{AY;+00,0|}{D0500,0940,0450|}" 
//           + txt
//           //+ RFID01 //RFID print는 임시로 주석처리함. 
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