package mes.client.util;

import java.io.UnsupportedEncodingException;
import java.text.NumberFormat;
import java.text.ParseException;
import java.util.Locale;

public class StringUtil
{
	public static String juminNumHipen(String str)
	{
		String value = "";
		
		if(str == null ) return "";
		
		if(str.length()>6)
		{
			value = str.substring(0,6) + "-" + str.substring(6); 
		}
		
		return value;
	}
		public static String Trim(String str)
	{
		if(str == null)return "";
		return str.trim();
	}
	/**
	 *	�ش���ڿ� 0�� ä�� ���ڸ� ����� �Լ�
	 *	
	 */
	public static String zeroFill(int length,int num)
	{
		String zeroFill = "";
		String strNum = num + "";
		int strNumLength = strNum.length();
		for(int i=0 ; i < length - strNumLength ; i++)
		{
			zeroFill += "0" ;
		}
		String value = zeroFill + num ;
		return value ;
	} 
    
	/**
	 *	��Ʈ�� ġȯ �Լ�
	 *	
	 *	�־��� ���ڿ�(buffer)���� Ư�����ڿ�('src')�� ã�� Ư�����ڿ�('dst')�� ġȯ
	 *
	 */
	public static String ReplaceAll(String buffer, String src, String dst){
		if(buffer == null) return null;
		if(buffer.indexOf(src) < 0) return buffer;
		
		int bufLen = buffer.length();
		int srcLen = src.length();
		StringBuffer result = new StringBuffer();

		int i = 0; 
		int j = 0;
		for(; i < bufLen; ){
			j = buffer.indexOf(src, j);
			if(j >= 0) {
				result.append(buffer.substring(i, j));
				result.append(dst);
				
				j += srcLen;
				i = j;
			}else break;
		}
		result.append(buffer.substring(i));
		return result.toString();
	}
	
    public static String getHtmlContents(String src)
    {
        src = ReplaceAll(src, "\n", "<br>");
        src = ReplaceAll(src, "&quot;", "\"");
        return src;
    }
        
    
    public static String toJS(String str) 
    {
        if(str==null || str.equals(""))return str;
        String value = "";
        
/*        return str.replace("\\", "\\\\")
                  .replace("\'", "\\\'")
                  .replace("\"", "\\\"")
                  .replace("\r\n", "\\n")
                  .replace("\n", "\\n");*/
                return str.replaceAll("'", "��").replaceAll("\"","��");
    }    
 
    /**
     * null�� ��� ""�� return
     * @param value
     * @return
     */
    public static String nvl(String value) {
        return nvl(value, "");
    }

    /**
     * value�� null�� ��� defalult���� return
     * @param value
     * @param defaultValue
     * @return
     */
    public static String nvl(String value, String defaultValue) {
        if (value == null || value.equals(""))
            return defaultValue;
        else
            return value;
    }

    /**
     * value�� null�� ��� defalult���� return
     * @param value
     * @param defaultValue
     * @return
     */
    public static int nvl(String value, int defaultValue) {
        if (value == null || value.equals(""))
            return defaultValue;
        else
            return Integer.parseInt(value);
    }
        
    
    public static boolean isValue(String[][] rs, int row, int col)
    {
        boolean value = false;
        try
        {
            if(rs !=null && rs[row][col] != null && !rs[row][col].equals(""))
            {
                value = true;
            }
        }catch(ArrayIndexOutOfBoundsException e)
        {
            value = false;
        }
        return value;
    }
    

    public static String setMaxLength(String str, int length) 
   {
    
    String result="";
    
    try{
        if(str != null ){
            result =  new String(str.trim().getBytes("KSC5601"),"Cp1252");
            if(result.length()<= length){
                result=new String(result.getBytes("Cp1252"),"KSC5601"); 
            }else {
                result = result.substring(0,length);
                result=new String(result.getBytes("Cp1252"),"KSC5601"); 
                String endchar = result.substring(result.length()-1,result.length());    //������ ���� ����
                endchar = new String(endchar.getBytes("KSC5601"),"Cp1252"); 
                if(endchar.length()==1) //1byte���ڶ�� �����Ѵ�. ? �ѱ�©������ó��
                {
                    result = result.substring(0,result.length()-1);
                }
                result = result+"..";
            }
        }
    }catch(UnsupportedEncodingException e){
        return result;
    }       
    return result;
   }

    //�ִ������ length���� Ȯ���Ͽ� ���� �Ѵ�. 
    //true : ���̺��� ū��� false:���̺��� ���� ���
    public static boolean isMaxLengthCheck(String str, int length) 
    {
     
     String result="";
     boolean bFlag = false;
     
     try
     {
         if(str != null )
         {
             result =  new String(str.trim().getBytes("KSC5601"),"Cp1252");
             bFlag = result.length() > length? true: false;
         }
         else
         {
             bFlag = false;
         }
     }catch(UnsupportedEncodingException e){}       
     return bFlag;
    }
        
    /**
     * String.substring(int start, int end) ��ü
     * NullPointException ����
     */
    public static String substring(String src, int start, int end){
        if(src == null || "".equals(src) || start > src.length() || start > end || start < 0) return "";
        if(end > src.length()) end = src.length();

        return src.substring(start, end);
    }
       
//  1�����迭�� �����ڷ� String���� ��ȯ�Ѵ�.
    public static String join(String[] array, String simbol)
    {
        StringBuffer sb = new StringBuffer();
        if(array != null)
        {
            int arrayCnt = array.length;
            for(int i=0;i<arrayCnt;i++)
            {
                if(array[i] != null)
                {
                    sb.append(array[i]);
                }
                else
                {
                    sb.append("");
                }
                if(i < (arrayCnt -1))
                {
                    sb.append(simbol);
                }

            }
        }

        return sb.toString();
    }    
    
    
    public static String null2String(String s)
    {
        if(s == null)
            s = "";
        return s;
    }
    
    public static String null2Zero(String s)
    {
        if(s == null || "".equals(s.trim()))
            s = "0";
        return s;
    }
    
    public static short parseShort(String s)
    {
        short result = 0;
        try
        {
            if(s != null && !s.trim().equals(""))
                result = Short.parseShort(s.trim());
        }
        catch(NumberFormatException ne) { }
        return result;
    }
    
    public static int parseInt(String s)
    {
        int result = 0;
        try
        {
            if(s != null && !s.trim().equals(""))
                result = Integer.parseInt(s.trim());
        }
        catch(NumberFormatException ne) { }
        return result;
    }
    
    
    /**
     *  ��Ʈ�� ġȯ �Լ�
     *  
     *  �־��� ���ڿ�(buffer)���� Ư�����ڿ�('src')�� ã�� Ư�����ڿ�('dst')�� ġȯ
     *
     */
    public static String replaceAll(String buffer, String src, String dst){
        if(buffer == null) return null;
        if(buffer.indexOf(src) < 0) return buffer;
        
        int bufLen = buffer.length();
        int srcLen = src.length();
        StringBuffer result = new StringBuffer();

        int i = 0; 
        int j = 0;
        for(; i < bufLen; ){
            j = buffer.indexOf(src, j);
            if(j >= 0) {
                result.append(buffer.substring(i, j));
                result.append(dst);
                
                j += srcLen;
                i = j;
            }else break;
        }
        String str;
        
        result.append(buffer.substring(i));
        return result.toString();
    }    
    
    public static String replaceAll(String text, int start, String src, String dest)
    {
        if(text == null)
            return null;
        if(src == null || dest == null)
            return text;
        int textlen = text.length();
        int srclen = src.length();
        int diff = dest.length() - srclen;
        int d = 0;
        StringBuffer t = new StringBuffer(text);
        while(start < textlen) 
        {
            start = text.indexOf(src, start);
            if(start < 0)
                break;
            t.replace(start + d, start + d + srclen, dest);
            start += srclen;
            d += diff;
        }
        return t.toString();
    }
    
    public static String dFormat(String str)
    {
        if(str == null)
            return "";
        if(str.length() == 0)
            return "";
        NumberFormat nf = NumberFormat.getInstance(Locale.KOREA);
        Number num = null;
        String ret = "";
        try
        {
            num = nf.parse(str);
        }
        catch(ParseException e) { }
        ret = dFormat(num.longValue());
        return ret;
    }
    
    public static String dFormat(int num)
    {
        NumberFormat nf = NumberFormat.getInstance(Locale.KOREA);
        String tempStr = nf.format(num);
        return tempStr;
    }
    
    public static String dFormat(long num)
    {
        NumberFormat nf = NumberFormat.getInstance(Locale.KOREA);
        String tempStr = nf.format(num);
        return tempStr;
    }
    
    public static String dFormat(double num)
    {
        NumberFormat nf = NumberFormat.getInstance(Locale.KOREA);
        String tempStr = nf.format(num);
        return tempStr;
    }
    
    /**
     * @deprecated Method getProductName is deprecated
     */
    
    public static String getProductName(String str, int length)
    {
        if(str == null)
            return "";
        if(str.trim().length() <= length)
            return str;
        byte bytes[] = str.trim().getBytes();
        if(length * 2 > bytes.length - 3)
            return new String(bytes);
        else
            return new String(bytes, 0, length * 2) + "...";
    }
    
   
    public static String getSplitDate(String strDate)
    {
        return getSplitDate(strDate, "-");
    }
    
    public static String getSplitDate(String strDate, String deliminator)
    {
        String delim = "-";
        if(strDate == null)
            return "";
        if(deliminator != null && deliminator.length() > 0)
            delim = deliminator;
        if(strDate.length() == 8)
            return strDate.substring(0, 4) + delim + strDate.substring(4, 6) + delim + strDate.substring(6);
        if(strDate.length() == 6)
            return strDate.substring(0, 4) + delim + strDate.substring(4, 6);
        else
            return strDate;
    }
    
    public static String getSplitTime(String strTime)
    {
        String tempString = strTime;
        int idx = 0;
        if(strTime == null)
            return "";
        if(strTime.length() < 2)
            return strTime;
        if(strTime.length() >= 2)
        {
            tempString = strTime.substring(0, 2);
            idx = 2;
        }
        if(strTime.length() >= 4)
        {
            tempString = tempString + ":" + strTime.substring(2, 4);
            idx = 4;
        }
        if(strTime.length() > idx)
            tempString = tempString + ":" + strTime.substring(idx);
        return tempString;
    }
    
    public static String getSocialid2Birthday(String socialid)
    {
        String result = "";
        if(socialid == null)
            return "";
        if(socialid.length() >= 13)
        {
            result = socialid.substring(0, 6);
            if(socialid.charAt(6) == '1' || socialid.charAt(6) == '2')
                result = "19" + result;
            else
                result = "20" + result;
            return getSplitDate(result);
        } else
        {
            return result;
        }
    }
    
    public static String pad(String str, int width)
    {
        return pad(str, width, " ");
    }
    
    public static String pad(String str, int width, String specChar)
    {
        if(str == null)
            str = "";
        StringBuffer buf = new StringBuffer();
        for(int space = width - str.length(); space-- > 0;)
            buf.append(specChar);
        
        buf.append(str);
        return buf.toString();
    }
    
    public static String getSocialId(String socialId)
    {
        if(socialId == null)
            return "";
        if(socialId.length() < 6)
            return socialId;
        if(socialId.charAt(6) == '-')
            return socialId;
        else
            return (new StringBuffer(socialId)).insert(6, '-').toString();
    }
    
    public static String getSocialId(String socialId, boolean isFirst)
    {
        if(isFirst)
            return socialId.substring(0, 6);
        else
            return socialId.substring(6);
    }
    
    public static String ltrim(String src, String key)
    {
        if(src == null)
            return src;
        if(key == null || "".equals(key))
            return src;
        int len = key.length();
        int idx;
        for(idx = 0; src.startsWith(key, idx); idx += len);
        return src.substring(idx);
    }
    
    public static String ltrim(String str)
    {
        String value = str;
        for(int i=0;i<str.length();i++)
        {
            
            char ch = str.charAt(i);
            if(ch==' ')
            {
                value = str.substring(i+1);
            }
            else
            {
               break; 
            }
        }
        return value;
    }
    
	/**
	 * ���ڿ���  �������� üũ�Ѵ�.
	 * @return	true ���� false ���ڰ� �ƴ�.
	 */
	public static boolean isDecimal(String srcStr)
	{
		if(srcStr == null) return false;
		
		StringBuffer desStr = new StringBuffer();
		int strCnt = srcStr.length();
		char ch = ' ';
		for(int i=0 ; i<strCnt ; i++)
		{
			ch = srcStr.charAt(i);
			
			if( ! ( ch>= '0' && ch <= '9' ))
			{
				return false;
			}
		}
		return true;
	}

	/**
	 * ���ڿ���  ���ڿ� ���������� üũ�Ѵ�.
	 * @return	true ���� false ���ڰ� �ƴ�.
	 */
	public static boolean isDecimalHipen(String srcStr)
	{
		if(srcStr == null) return false;
		
		StringBuffer desStr = new StringBuffer();
		int strCnt = srcStr.length();
		char ch = ' ';
		for(int i=0 ; i<strCnt ; i++)
		{
			ch = srcStr.charAt(i);
			
			if( ! ( ch>= '0' && ch <= '9' ) && ch != '-')
			{
				return false;
			}
		}
		return true;
	}
	
	/**
	 * �ֹι�ȣ�� üũ�Ѵ�.
	 * @param ID_V
	 * @return ��������
	 */
	public static boolean isCheckJumin(String ID_V){
	    int total_id,  check_last_value , count_num , add_num;
	    int check_ID_value ,check_Total_ID_value;
	    String  IDAdd = "234567892345"; // �ֹε�Ϲ�ȣ�� ������ ��
	    String Send_Mesg = "";
	    boolean bSuccess = false;
	    
	    total_id = 0;
	    try {
		    if (ID_V.length() == 13){ // �ֹε�Ϲ�ȣ �ڸ����� �´°��� Ȯ���Ѵ�.
		    	for (int i = 1; i <13 ; i++){
		    		count_num = Integer.parseInt(ID_V.substring(i-1,i));
		    		add_num = Integer.parseInt(IDAdd.substring(i-1,i));
		    		total_id = total_id + count_num * add_num;
		    	}
	
	
			    total_id = 11 - (total_id % 11);
			    check_ID_value = Integer.parseInt(ID_V.substring(12,13));
			    check_Total_ID_value = total_id % 10;
		
			    if (check_ID_value ==  check_Total_ID_value){
			        Send_Mesg = "üũ �Ǿ����ϴ�.";
			        bSuccess = true;
			    } else {
			    	  Send_Mesg = "�߸��� �ֹε�Ϲ�ȣ �Դϴ�.";
			    	  bSuccess = false;
			    }
		    } else {
		    	Send_Mesg = "�ֹε�Ϲ�ȣ ���̰� �߸��Ǿ����ϴ�.";
		    	  bSuccess = false;
		    }
	    } catch (Exception e) { 
	    }
	    
	    return bSuccess;
	}
	
}
