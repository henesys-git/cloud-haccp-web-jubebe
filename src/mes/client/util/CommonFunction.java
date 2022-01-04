package mes.client.util;

import java.text.DecimalFormat;
import java.util.HashMap;
import java.util.StringTokenizer;
import java.util.Vector;

import mes.client.common.Common;
import mes.client.conf.Config;


public class CommonFunction {
    public static String[] getHostAndPort(String fullHostStr) throws Exception {
        String[] hostAndPortArray = new String[2];

        String[] tempArray = CommonFunction.split(fullHostStr, "/", true);
        for (int i=0; i<tempArray.length; i++) {
                if (i > 0 && tempArray[i].indexOf(":") > 0) {
                        hostAndPortArray = CommonFunction.split(tempArray[i], ":", true);
                        break;
                }
        }
        return hostAndPortArray;
    }
    
    /*
    public static synchronized boolean getHashmapFromString(HashMap resultDataMap, String orgStrData) {
        try {
                //{NAME=도요새, TELNO=010-2207-9690, SERNO=1}
                HashMap resultRowMap = null;
                // 앞뒤 중괄호를 떼어낸다음....
                orgStrData = orgStrData.substring(orgStrData.indexOf("{")+1, orgStrData.lastIndexOf("}"));
                // "{"를 델리미터로 ROW단위로 쪼갠다.--서버에서 트림해서 }{구조로 되어애 한다.
                String[] rowArray = CommonFunction.split(orgStrData, "}{", true);
                for (int r=0; r<rowArray.length; r++) {
                        resultRowMap = new HashMap();
                        String[] dataStrArr = CommonFunction.split(rowArray[r], ", ", true);
                        String[] tmpStrArr = new String[2];
                        for (int c=0; c<dataStrArr.length; c++) {
                                tmpStrArr = CommonFunction.split(dataStrArr[c], "=", true);
                                resultRowMap.put(tmpStrArr[0].trim(), tmpStrArr[1].trim());
                        }
                        resultDataMap.put(r, resultRowMap);
                }
        } catch (Exception e) {
                e.printStackTrace();
                return false;
        }
        return true;
    }
    */

    // 숫자(double)를 포맷형식으로 변환
    public static String getFormatData(double value, String format) {
                DecimalFormat df = new DecimalFormat(format);
                String tempStr = df.format(value);
                return tempStr;
    }

    // 숫자(long)를 포맷형식으로 변환
    public static String getFormatData(long value, String format) {
                DecimalFormat df = new DecimalFormat(format);
                String tempStr = df.format(value);
                return tempStr;
    }

    public static synchronized String[] split(String str, String delimiter, boolean bEmpty) throws Exception {
        if (str == null) throw new Exception("Common.split() : Illegal parameter 'str'. It is null.");

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

	public static String[][] getConvString2DoubleArray(int colSize, String str) {
		// 돌려줄 결과 값
		String[][] resultArray = null;
		try {
			// 토큰을 나누고...
			String[] oneArray = Common.split(str, "|", true);
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
			tmpArr = Common.split(str, "|", true);
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
					returnArr[i][j] = tempStr;
				} catch (Exception e) {
					return null;
				}
			}
		}
		return returnArr;
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

	/** 
	 * 벡터를 스트링으로 반환. 
	 */
    public static String getVecToStr(Vector vec, int row, int col){
    	String rtnStr = "";
    	try {
    		if(vec!=null) rtnStr = ((Vector)vec.elementAt(row)).elementAt(col).toString() ;
		} catch (Exception e) {}
    	return rtnStr ;
    }
}
