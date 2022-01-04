package mes.client.util;

import java.util.ArrayList;
import java.util.Enumeration;
import java.util.StringTokenizer;
import java.util.Vector;

public class Convert
{
	/** 
	 * ���� : ���͸� String[][]�� ��ȯ�Ͽ� ��ȯ�Ѵ�. 
	 * @return String[][] 
	 */	
	public static String[][] vecTotwoStr(Vector vec)
	{
		String[][] twoStr = null;
		if(vec == null) return twoStr;	
		if(vec.size() == 0) return twoStr;

		try{
			int rowSize = vec.size();
			Vector result = (Vector)vec.elementAt(0);
			int colSize = result.size();
			twoStr = new String[rowSize][colSize];
		    for(int i=0; i < rowSize ; i++){
	        	result = (Vector)vec.elementAt(i);
	        	for(int j=0; j < colSize; j++){
	        		twoStr[i][j] = (String)result.get(j);
	        	}
	        }
		}
		catch(Exception e)
		{
			twoStr = null;
		}
		return twoStr;
	}    
	
	public static String[] enumToOneArr(Enumeration enums)
	{
		if(enums==null) return null;
		ArrayList al = new ArrayList();
		
		String[] oneArr = null;
		String str = "";
		while(enums.hasMoreElements())
		{
			str = (String)enums.nextElement();
			al.add( str );
		}
		oneArr = new String[al.size()];

		al.toArray(oneArr);
		Vector vec = new Vector();
		
		return oneArr;
	}
	
	/**
	 * �������迭�� 1�����迭�� �����´�. 
	 * @param index			�������迭�� ���� �ε���
	 * @param twoArr 			�������迭�ҽ�
	 * @return String[]		�ε����� �´� �������迭
	 */
	
	public static String[] twoArrToOneArr(int index, String[][] twoArr)
	{
		String[] oneArr = new String[twoArr[index].length];
		System.arraycopy(twoArr[index], 0, oneArr, 0, oneArr.length);
		return oneArr;
	}
	
	/**
	 * ������ �迭 Ȯ��
	 * @param tmp     �������迭 ���ڿ�
	 */	
	public static void twoConfirm(String[][] tmp)
	{
        if(tmp==null) {
            System.out.println("Convert== ������ �迭 NULL");
            return;
        }
		  //�������迭 tmp�� ġȯ
        System.out.println("Convert================= ������ �迭 Ȯ�� ����=======================");
        try
        {
            for(int k=0;k<tmp.length;k++)
            {
                for(int z=0;z<tmp[k].length;z++)
                {   
                	System.out.println(" �������迭 ����  :::::: tmp : ["+k+"]["+z+"],"+tmp[k][z].length() +" = "+tmp[k][z]);
                }
            }
        }catch(Exception e)
        {
        	System.out.println("Ȯ���� ����");
        }
        System.out.println(" ================= ������ �迭 Ȯ�� ��=======================");
	}

	/**
	 * 
	 * @param date 8�ڸ� ����
	 * @param time 6�ڸ� ����
	 * @return  ex) 2007-12-23 12:36:27 	
	 */
	public static String getDateTime(String date, String time)
	{
		if(date == null || time == null ) return "";
		
		date = getDecimal(date.trim());
		time = getDecimal(time.trim());

		int dateCnt = date.length();
		int timeCnt = time.length();
		
		if(dateCnt != 8 || timeCnt != 6)
		{
			return "";
		}
		
		String dateGubun = "-";
		String timeGubun = ":";
	
		String dateTime = date.substring(0,4)+dateGubun+date.substring(4,6)+dateGubun+date.substring(6,8)+" "+time.substring(0,2)+timeGubun+time.substring(2,4)+":"+time.substring(4,6); 
		
		return dateTime;
	}	

	/**
	 * 
	 * @param date 14�ڸ� ����
	 * @return  ex) 2007-12-23 12:36:27 	
	 */
	public static String getDateTime(String dateTime)
	{
		if(dateTime == null) return "";
		
		int dateTimeCnt = dateTime.length();
		
		if(dateTimeCnt != 14)
		{
			return "";
		}
		
		String dateGubun = "-";
		String timeGubun = ":";
	
		dateTime = dateTime.substring(0,4)+dateGubun+dateTime.substring(4,6)+dateGubun+dateTime.substring(6,8)+" "+dateTime.substring(8,10)+timeGubun+dateTime.substring(10,12)+":"+dateTime.substring(12,14); 
		
		return dateTime;
	}	
	
	/**
	 * ��¥�� �޾Ƽ� �������ִ� ��¥�� ��ȯ�Ѵ�.
	 * @param date 8�ڸ� ����
	 * @return  ex) 2007-12-23 	
	 */
	public static String getDate(String date)
	{
		if(date == null) return "";
		
		int dateCnt = date.length();
		
		date = date.trim();
		if(dateCnt != 8)
		{
			return "";
		}
		
		String dateGubun = "-";
	
		String convertDate = date.substring(0,4)+dateGubun+date.substring(4,6)+dateGubun+date.substring(6,8); 
		
		return convertDate;
	}	
	
	
	/**
	 * �ð��� �޾Ƽ� �������ִ� �ð����� ��ȯ�Ѵ�.
	 * @param date 6�ڸ� ����
	 * @return  ex) 12:23:32
	 */
	public static String getTime(String time)
	{
		if(time == null) return "";
		
		time = getDecimal(time.trim());

		int dateCnt = time.length();
		
		if(dateCnt != 6)
		{
			return "";
		}
		
		String dateGubun = ":";
	
		String convertTime = time.substring(0,2)+dateGubun+time.substring(2,4)+dateGubun+time.substring(4,6); 
		
		return convertTime;
	}	
	
	
	
	/**
	 * ���ڿ��� �޾Ƽ� ���ڷ� ��ȯ�Ѵ�.
	 * @param srcStr   �����̿��� �ٸ����ڿ� ���� ���� ex)2007-12-23
	 * @return	String   ����  ex)20071223
	 */
	public static String getDecimal(String srcStr)
	{
		if(srcStr == null) return "";
		
		StringBuffer desStr = new StringBuffer();
		int strCnt = srcStr.length();
		char ch = ' ';
		for(int i=0 ; i<strCnt ; i++)
		{
			ch = srcStr.charAt(i);
			
			if(ch>= '0' && ch <= '9')
			{
				desStr.append(ch);
			}
		}
		return desStr.toString();
	}
	
	
	/**
	 * ��¥�ð����� �Ǿ��ִ� ���� ��¥�� �����´�.
	 * @param dateTime ex) 2007-12-23 12:36:27 	
	 * @return 8�ڸ� ����
	 */
	public static String getSplitDate(String dateTime)
	{
		if(dateTime==null)return "";

		dateTime = getDecimal(dateTime);
		dateTime = dateTime.substring(0,8);
		
		return  dateTime;
	}

	/**
	 * ��¥�ð����� �Ǿ��ִ� ���� �ð��� �����´�.
	 * @param dateTime ex) 2007-12-23 12:36:27 	
	 * @return 6�ڸ� ����
	 */
	public static String getSplitTime(String dateTime)
	{
		if(dateTime==null)return "";

		dateTime = getDecimal(dateTime);
		dateTime = dateTime.substring(0,dateTime.length());
		
		return dateTime;
	}
	
	
	// [Length \t Head \t responseInt \t columnCount \t Data] �����͸� String[][] ���·� ��ȯ�Ѵ�.
    public static  String[][] sbTotwoArr(StringBuffer data) {
		if (data == null || data.toString().equals("")) return null; 
		String[][] resultTwoArr = null;
		
		int i = 0;
		Vector rowData = new Vector();
		String tmpStr = "";
		
		try {    
		    StringTokenizer st = new StringTokenizer(data.toString(), "\t");
		    String dataLength = st.nextToken().trim();
		    String HEAD = st.nextToken().trim();
		    int ERROR_CODE = Integer.parseInt( st.nextToken().trim() );
		    
		    int colCnt = 0;
		    try {
		    	colCnt = Integer.parseInt( st.nextToken().trim() );
		    } catch (Exception e) {
		    	return resultTwoArr;
		    }
		    if (colCnt <= 0) return resultTwoArr;
	
		    while (st.hasMoreTokens() ) {
	    		Vector colData = new Vector();
	    		i = 0;
	    		while (st.hasMoreTokens() ) {
	    		    tmpStr = ((String)st.nextToken()).trim();
	    		    // �������� ����Ÿ�� ���鶧 �̷� ���("null")�� ����� �� �� �ִ�.
	    		    if (tmpStr==null || tmpStr.equals("null") ) tmpStr = "";
	    		    colData.add(tmpStr);
	    		    // colData.add(new String(tmpStr.getBytes(),"ksc5601"));
	    		    i++;
	    		    if (i >= colCnt) break;
	    		}
	    		if (i >= colCnt) rowData.add(colData);
		    }
		    
		    resultTwoArr = vecTotwoStr(rowData);
		} catch (Exception e) {
		    e.printStackTrace();
		} finally {
		}
		return resultTwoArr;
    }
}