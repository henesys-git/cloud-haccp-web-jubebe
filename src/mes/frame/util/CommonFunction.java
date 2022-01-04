package mes.frame.util;

import java.text.DecimalFormat;
import java.util.Calendar;
import java.util.StringTokenizer;
import java.util.Vector;

import mes.client.conf.Config;

public class CommonFunction {
	public static int getInt(String str){
		try{
			return Integer.parseInt(str);
		}catch(Exception e){
			return 0;
		}
	}
	public static int getParamCount(StringBuffer str){
		int count = 0;
		int len = str.length() ;
		String comp = "";
		for(int i=0; i < len; i++){
			comp = str.substring(i,i+1);
			if(comp.equals("?")) count++;
		}
		return count;
	}

	public  static String[] split(String str, String delimiter, boolean bEmpty) throws Exception {
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

	public static String getSystemTime(String gubun) {
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
		String         sysDate = strYYYY + "." + strMM + "." + strDD;
		String         sysDateNumeric = strYYYY + strMM + strDD;

		int sysHour = date.get(Calendar.HOUR_OF_DAY);
		int sysMinute = date.get(Calendar.MINUTE);
		int sysSecond = date.get(Calendar.SECOND);
		String strHour = df2.format(sysHour);
		String strMinute = df2.format(sysMinute);
		String strSecond = df2.format(sysSecond);
		String sysTime = strHour + ":" + strMinute + ":" + strSecond;
		String sysTimeNumeric = strHour + strMinute + strSecond;

		if (gubun.equals("date")) retStr = sysDate;
		else if (gubun.equals("time")) retStr = sysTime;
		else if (gubun.equals("dateNumeric")) retStr = sysDateNumeric;
		else if (gubun.equals("timeNumeric")) retStr = sysTimeNumeric;
		else if (gubun.equals("datetimeGeneral")) retStr = sysDate + sysTime;
		else if (gubun.equals("datetimeNumeric")) retStr = sysDateNumeric + sysTimeNumeric;

		return retStr;
	}

	public static String getPlusHangmokKey(String org_key){
		byte[] max_code_char_array = org_key.getBytes();
		byte[] new_max_code_char_array = new byte[1];
		new_max_code_char_array[0] = ++(max_code_char_array[0]);
		return (new String(new_max_code_char_array));
	}
	
	// 항목의 코드를 결정한다.
	public static String getPlusHangmokCode(String org_code){
		int len = org_code.length();
		String org_key = org_code.substring(len-1, len);
		// 만약 대문자가 다 사용되었으면... 즉, Z에 이르렀으면 소문자를 넣어주자.
		// if (org_key.equals("Z")) org_key = "z"; // [\]은 문제가 있으므로 걸러버린다.
		byte[] max_code_char_array = org_key.getBytes();
		byte[] new_max_code_char_array = new byte[1];
		new_max_code_char_array[0] = ++(max_code_char_array[0]);
		String retStr = org_code.substring(0, len-1) + (new String(new_max_code_char_array));
		return (retStr);
	}

	/**
	 * request Parameter 를 벡터로 리턴해주는 method 
	 * @param str
	 * @return Vector
	 */
	public static Vector getConvVector(String str){
		Vector resultVector= new Vector();
		Vector temp = null;
		String[] conv1 = str.split("\r");
		String[] conv2 = null;
		for(int i=0; i < conv1.length; i++){
			temp = new Vector();
			conv2 = conv1[i].split("\t");
			for(int j=0; j < conv2.length ; j++){
				temp.add(conv2[j]);
			}
			resultVector.add(temp);
		}
		return resultVector;
	}

	/**
	 * Vector를 String으로 리텬해주는 method
	 * @param temp
	 * @return String
	 */
	public static String getConvString(Vector temp) {
		int tSize = 0;
		try{
			if((tSize=temp.size()) == 0) return "";
		}catch(Exception e){
			return "";
		}
		int rSize = 0;

		StringBuffer returnStr = new StringBuffer();
		Vector row = null;
		String tempStr = "";
		for(int i=0; i< tSize; i++){
			row = (Vector)temp.elementAt(i);
			rSize = row.size();
			for(int j=0 ; j < rSize ; j++){
				tempStr = (String)row.elementAt(j);
				returnStr.append(tempStr);
				if(j < (rSize-1)) returnStr.append("\\t");
			}
			returnStr.append("\\r");
		}
		return returnStr.toString();	
	}

	public static String getConvString(String str, String charset) {
		if( str == null) return "";
		String retStr = "";
		try {
			retStr = new String(str.getBytes(), charset);
		} catch (Exception e) {
		}
		return retStr;
	}

	public static String getConvLineString(Vector temp, String delemeter){
		int tSize = 0;
		try{
			if((tSize=temp.size()) == 0) return "";
		}catch(Exception e){
			return "";
		}
		int rSize = 0;

		StringBuffer returnStr = new StringBuffer();
		Vector row = null;
		String tempStr = "";
		for(int i=0; i< tSize; i++){
			row = (Vector)temp.elementAt(i);
			rSize = row.size();
			for(int j=0 ; j < rSize ; j++){
				tempStr = (String)row.elementAt(j);
				returnStr.append(tempStr);
			}
			if (i < (tSize-1)) returnStr.append("|");
		}
		return returnStr.toString();	
	}

	public static Vector getConvStringDamogjuk(String str) throws Exception {
		// 결과 벡터로서 0.헤드:String[][], 1.테이블:String[][]
		Vector resultVector = new Vector();
		
		StringBuffer tmpBuf = new StringBuffer(str);
		// 마지막 파이프 뒤에 아무것도 없으면 파라미터가 하나 모자라게 된다.
		if ( (tmpBuf.lastIndexOf("|")+1) == tmpBuf.length()) {
			tmpBuf.append(" ");
		}
		int offSet = 0;
		// 델리미터가 같이 붙어 있으면 제대로 안됨.
		// String에서 2개 이상의 문자는 replace가 안됨...
		while( (offSet=tmpBuf.indexOf("||")) >= 0) {
			tmpBuf.insert(offSet+1, " ");
		}
		str = tmpBuf.toString();

		String headStr = str.substring(0, str.indexOf(Config.MSGTOKEN));
		String dataStr = str.substring(str.indexOf(Config.MSGTOKEN)+Config.MSGTOKEN.length());
		
		// 헤드는 기존의 방식댜로 그냥...
		String[][] headResultArray = getConvString2DoubleArray(headStr);		

		// Row에 대한 토큰을 나누고...
		String[][] dataResultArray;
		int r = 0;
//		========================================================
		String[] stRow = split(dataStr, Config.PARAMTOKEN, true);
		dataResultArray = new String[stRow.length-1][];   
		//  stRow.length-1 : Config.PARAMTOKEN의 제일마지막 배열을 하나 제외  1|2|3| `#@#`  => 실제 1개만 필요한데 배열이 2개로 만들어짐

		for(r = 0; r<stRow.length-1; r++) {
			// Column 토큰을 나누고...
			String[] st = split(stRow[r], "|", true); 
			dataResultArray[r] = new String[st.length];
			int c = 0;
			for(c = 0; c < st.length-1; c++) {
				// 배열에 담는다.
				dataResultArray[r][c] = st[c].trim();
			}
		}
		
		// 최종 벡터에 담는다.
		resultVector.add(headResultArray);
		resultVector.add(dataResultArray);
		return resultVector;
	}

	public static String[][] getConvString2MultiDoubleArray(String str) {
		StringBuffer tmpBuf = new StringBuffer(str);
		// 마지막 파이프 뒤에 아무것도 없으면 파라미터가 하나 모자라게 된다.
		if ( (tmpBuf.lastIndexOf("|")+1) == tmpBuf.length()) {
			tmpBuf.append(" ");
		}
		int offSet = 0;
		// 델리미터가 같이 붙어 있으면 제대로 안됨.
		// String에서 2개 이상의 문자는 replace가 안됨...
		while( (offSet=tmpBuf.indexOf("||")) >= 0) {
			tmpBuf.insert(offSet+1, " ");
		}
		str = tmpBuf.toString();

		String[][] resultArray;

		// Row에 대한 토큰을 나누고...
		int r = 0;
		StringTokenizer stRow = new StringTokenizer(str, Config.PARAMTOKEN);
		resultArray = new String[stRow.countTokens()][];

		while (stRow.hasMoreTokens() ) {
			// Column 토큰을 나누고...
			StringTokenizer st = new StringTokenizer(stRow.nextToken().trim(), "|");
			resultArray[r] = new String[st.countTokens()];
			int c = 0;
			while (st.hasMoreTokens() ) {
				// 배열에 담는다.
				resultArray[r][c] = st.nextToken().trim();
				c++;
			}
			r++;
		}
		return resultArray;
	}
	public static String[][] getConvVector2Array(Vector temp){
		int tSize = 0;
		try{
			if((tSize=temp.size()) == 0) return null;
		}catch(Exception e){
			return null;
		}
		int rSize = ((Vector)(temp.elementAt(0))).size();

		String[][] returnArr = new String[tSize][rSize];
		Vector row = null;
		String tempStr = "";
		for(int i=0; i< tSize; i++){
			row = (Vector)temp.elementAt(i);
			for(int j=0 ; j < rSize ; j++){
				tempStr = (String)row.elementAt(j);
				try {
					// 톰캣으로 할려면 이놈으로 한다.
					//returnArr[i][j] = new String(tempStr.getBytes("8859_1"), "euc-kr");
					returnArr[i][j] = tempStr;
				} catch (Exception e) {
					return null;
				}
			}
		}
		return returnArr;
	}
	public static String[][] getConvString2DoubleArray(int colSize, String str) {
		// 돌려줄 결과 값
		String[][] resultArray = null;
		try {
			// 토큰을 나누고...
			String[] oneArray = split(str, "|", true);
			int totLen = oneArray.length;
			// 배열의 크기를 정한다.
			resultArray = new String[((int)(totLen/colSize))][colSize];
			int row = 0;
			int col = 0;
			for (int i=0; i<totLen; i++) {
				// 배열에 담는다.
				resultArray[row][col] = oneArray[i].trim();
				col++;
				if (col >= colSize) {
					col = 0;
					row++;
				}
			}
		} catch (Exception e) {
		}
		return resultArray;
	}

	public static String[][] getConvString2DoubleArray(String str) {
		// 토큰을 나누고...
		String[] tmpArr = null;
		String[][] resultArray = null;
		try {
			tmpArr = split(str, "|", true);
			resultArray = new String[1][tmpArr.length];
			for (int i=0; i<tmpArr.length; i++) {
				// 배열에 담는다.
				resultArray[0][i] = tmpArr[i].trim();
			}
		} catch (Exception e) {
			return null;
		}
		return resultArray;
	}

	public static String[][] getConvVector2Array(Vector temp, String charset){
		int tSize = 0;
		try{
			if((tSize=temp.size()) == 0) return null;
		}catch(Exception e){
			return null;
		}
		int rSize = ((Vector)(temp.elementAt(0))).size();

		String[][] returnArr = new String[tSize][rSize];
		Vector row = null;
		String tempStr = "";
		for(int i=0; i< tSize; i++){
			row = (Vector)temp.elementAt(i);
			for(int j=0 ; j < rSize ; j++){
				tempStr = (String)row.elementAt(j);
				try {
					if (charset.equals("")) {
						returnArr[i][j] = tempStr;
					} else {
						returnArr[i][j] = new String(tempStr.getBytes(), charset);
					}
				} catch (Exception e) {
					return null;
				}
			}
		}
		return returnArr;
	}

	public static int getMaxLength(String[][] temp, int chkPos){
		int tSize = 0;
		int mLength = 0;
		int oldLength = 0;
		try{
			if((tSize=temp.length) == 0) return 0;
		}catch(Exception e){
			return 0;
		}

		for(int i=0; i< tSize; i++){
			mLength = (temp[i][chkPos]).trim().length();
			if (mLength > oldLength) oldLength = mLength;
		}
		return oldLength;
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
}
