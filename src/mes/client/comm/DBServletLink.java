package mes.client.comm;

import java.text.DecimalFormat;
import java.util.StringTokenizer;
import java.util.Vector;

import org.apache.log4j.Logger;
import org.json.simple.JSONObject;

import mes.client.conf.Config;

public class DBServletLink {
	
	static final Logger logger = Logger.getLogger(DBServletLink.class.getName());
	
	// ���ϵ� �����ڵ�
	public static int ERROR_CODE = 0;

	String PID_STRING = "";
	SERVLET_MODULE servletModule = null;
	String resultDataFromServletModule = null;
	
    //2018-02-09 ����====�� ���� �ϰ�ó���� ���Ͽ�.. ����.. 2018.10.05 �����.
	//String sendEncoding = "euc-kr";
    String sendEncoding = Config.ENCODING;
	
    // ��� ����Ÿ
    StringBuffer RESULT_STRING_BUFFER_FROM_SERVLET_MODULE = new StringBuffer();
    String RESULT_STRING_FROM_SERVLET_MODULE = "";
    private Vector rowData = null;
    private Vector colData = null;
    private Vector rowSingleData = null;
    
	public DBServletLink() {
		servletModule = new SERVLET_MODULE();
	}

	public void connectURL(String pid) {
		try {
			ERROR_CODE=0;
			PID_STRING = pid;
		} catch (Exception e) {
			logger.error("DBServletLink.connectURL : pid - "+pid+"  / Chanel Setup Error");
		}
	}


	// ������ ó��
    private Vector getData(StringBuffer data) {
		if (data == null || data.toString().equals("")) {
			return null; 
		}

		int i = 0;
		rowData = new Vector();
		String tmpStr = "";
		
		// Ŭ���̾�Ʈ�� �������� ������ ������ [Length \t Head \t responseInt \t columnCount \t Data]
		try {    
		    StringTokenizer st = new StringTokenizer(data.toString(), "\t");
		    String dataLength = st.nextToken().trim();
		    String HEAD = st.nextToken().trim();
		    ERROR_CODE = Integer.parseInt( st.nextToken().trim() );
		    
		    int colCnt = 0;
		    try {
		    	colCnt = Integer.parseInt( st.nextToken().trim() );
		    } catch (Exception e) {
		    	return rowData;
		    }
		    if (colCnt <= 0) return rowData;
	
		    while (st.hasMoreTokens() ) {
	    		colData = new Vector();
	    		i = 0;
	    		while (st.hasMoreTokens() ) {
	    		    tmpStr = ((String)st.nextToken()).trim();
	    		    // �������� ����Ÿ�� ���鶧 �̷� ���("null")�� ����� �� �� �ִ�.
	    		    if (tmpStr==null || tmpStr.equals("null") ) tmpStr = "";
	    		    // ��Ʈ�����۷� �Ѱ��ٶ� �ѱ� ó���� �ؼ� �Ѱ� �ֹǷ� ������ �ѱ�ó���� ���� �ʴ´�.
    		    	colData.add(tmpStr);
	    		    i++;
	    		    if (i >= colCnt) break;
	    		}
	    		if (i >= colCnt) rowData.add(colData);
		    }
		} catch (Exception e) {
		    e.printStackTrace();
		} finally {
			// ��Ʈ���� �ݵ�� �ݴ´�.
//			closeStream();
		}
		return rowData;
    }

    /// ------- ��� ó�� �� ---------- 

    // ������ ���� ������ �����Ѵ�.
    public String setRequestData(String query, boolean continueYN, String HEAD) {
        DecimalFormat df7 = new DecimalFormat("0000000");
		String retString = "";
		// Ȥ�� ���� ��������� ���� �����̽��� �ٲ۴�.
		while (query.indexOf("\t") >= 0) {
		    query = query.replace('\t', ' ');
		}
		// �� Ȥ�� --�� ������(�������� �ڸ�Ʈ) __�� �ٲ۴�.
		while (query.indexOf("--") >= 0) {
		    query = query.replace("--", "__");
		}
		
		// ������ ���Ͽ� ��忡 ������ Ű�� �߰��Ѵ�.
		HEAD += Config.S_KEY;
		
		// ������ �����Ѵ�.
		if (continueYN) retString = HEAD + "\tY\t" + query;
		else retString = HEAD + "\tN\t" + query;
		logger.debug("retString = " + retString);
		return ("" + df7.format( (retString.getBytes()).length+8 ) + "\t" + retString);
    }
    
    public String setRequestData(JSONObject query, boolean continueYN, String HEAD) {
        DecimalFormat df7 = new DecimalFormat("0000000");
		String retString = "";
		// Ȥ�� ���� ��������� ���� �����̽��� �ٲ۴�.
//		while (query.indexOf("\t") >= 0) {
//		    query = query.replace('\t', ' ');
//		}
//		// �� Ȥ�� --�� ������(�������� �ڸ�Ʈ) __�� �ٲ۴�.
//		while (query.indexOf("--") >= 0) {
//		    query = query.replace("--", "__");
//		}
		
		// ������ ���Ͽ� ��忡 ������ Ű�� �߰��Ѵ�.
		HEAD += Config.S_KEY;
		
		// ������ �����Ѵ�.
		if (continueYN) retString = HEAD + "\tY\t" + query;
		else retString = HEAD + "\tN\t" + query;
		logger.debug("retString = " + retString);
		return ("" + df7.format( (retString.getBytes()).length+8 ) + "\t" + retString);
    }
    
    // ------- Ŭ���̾�Ʈ ȣ�� �� --------- /

    public void queryProcess(String parameter, boolean continueYN) {
		try {
			resultDataFromServletModule = 
				servletModule.performTask(PID_STRING, this.setRequestData(parameter, continueYN, "queryProcess"));

			getData(RESULT_STRING_BUFFER_FROM_SERVLET_MODULE.append(resultDataFromServletModule));
		} catch (Exception e) {
			e.printStackTrace();
		}
    }	
    
    public String queryProcessForjsp(String parameter, boolean continueYN) {
		try {
			resultDataFromServletModule = 
				servletModule.performTask(PID_STRING, this.setRequestData(parameter, continueYN, "queryProcessForJsp"));
			
			getData(RESULT_STRING_BUFFER_FROM_SERVLET_MODULE.append(resultDataFromServletModule));
		} catch (Exception e) {
			e.printStackTrace();
		}
		return RESULT_STRING_BUFFER_FROM_SERVLET_MODULE.toString();
    }	
    
    // JSONObject�� ���޿� �޼ҵ�
    public String queryProcessForjsp(JSONObject parameter, boolean continueYN) {
		try {
			resultDataFromServletModule = 
					servletModule.performTask(PID_STRING, parameter, continueYN, "doQuery");
			
			getData(RESULT_STRING_BUFFER_FROM_SERVLET_MODULE.append(resultDataFromServletModule));
		} catch (Exception e) {
			e.printStackTrace();
		}
		return RESULT_STRING_BUFFER_FROM_SERVLET_MODULE.toString();
    }	
    
    public synchronized Vector doQuery(String parameter, boolean continueYN) { 
		try {	
			resultDataFromServletModule = 
				servletModule.performTask(PID_STRING, this.setRequestData(parameter, continueYN, "doQuery"));
		} catch (Exception e) {
			e.printStackTrace();
		}
		return (getData(RESULT_STRING_BUFFER_FROM_SERVLET_MODULE.append(resultDataFromServletModule)));
    }
    
    public synchronized Vector doQuery(JSONObject parameter, boolean continueYN) { 
		try {	
			resultDataFromServletModule = 
				servletModule.performTask(PID_STRING, parameter, continueYN, "doQuery");
		} catch (Exception e) {
			e.printStackTrace();
		}
		return (getData(RESULT_STRING_BUFFER_FROM_SERVLET_MODULE.append(resultDataFromServletModule)));
    }
    
    public Vector doQueryTableFieldName(JSONObject parameter, boolean continueYN) { 
		try {	
			resultDataFromServletModule = 
					servletModule.performTask(PID_STRING, parameter, continueYN, "doQueryTableFieldName");
		} catch (Exception e) {
			e.printStackTrace();
			logger.error("Internet problem. Please start again.");
		}
		return (getData(RESULT_STRING_BUFFER_FROM_SERVLET_MODULE.append(resultDataFromServletModule)) );
    }
    
    public Vector doQueryTableFieldName( String parameter, boolean continueYN) { 
		try {	
			resultDataFromServletModule = 
					servletModule.performTask(PID_STRING, this.setRequestData(parameter, continueYN, "doQueryTableFieldName"));

		} catch (Exception e) {
			e.printStackTrace();
			logger.error("Internet problem. Please start again.");
		}
		return (getData(RESULT_STRING_BUFFER_FROM_SERVLET_MODULE.append(resultDataFromServletModule)) );
    }
    public String getColumnValue( String parameter) {
		try {	
			resultDataFromServletModule = 
					servletModule.performTask(PID_STRING, this.setRequestData(parameter, false, "getColumnValue"));
			
		} catch (Exception e) {
			e.printStackTrace();
		}
	
		return this.getOneColumnValue(getData(RESULT_STRING_BUFFER_FROM_SERVLET_MODULE.append(resultDataFromServletModule)));
    } 

    public String getColumnValue( String parameter, boolean continueYN) {
		try {	
			resultDataFromServletModule = 
					servletModule.performTask(PID_STRING, this.setRequestData(parameter, continueYN, "getColumnValue"));
			

		} catch (Exception e) {
			e.printStackTrace();
		}
		return this.getOneColumnValue(getData(RESULT_STRING_BUFFER_FROM_SERVLET_MODULE.append(resultDataFromServletModule)));
    }	


    public String getMultiColumnValue( String parameter, boolean continueYN,int index) {
		try {	
			resultDataFromServletModule = 
					servletModule.performTask(PID_STRING, this.setRequestData(parameter, continueYN, "getMultiColumnValue"));
			

		} catch (Exception e) {
			e.printStackTrace();
		}
		return this.getOneRowMultiColumnValue(getData(RESULT_STRING_BUFFER_FROM_SERVLET_MODULE.append(resultDataFromServletModule)),index);
    }	    
    
    public Vector getSingleVector( String parameter) {
		try {	
			resultDataFromServletModule = 
					servletModule.performTask(PID_STRING, this.setRequestData(parameter, false, "getSingleVector"));
			

		} catch (Exception e) {
			e.printStackTrace();
		}
	
		return this.getColumnData(getData(RESULT_STRING_BUFFER_FROM_SERVLET_MODULE.append(resultDataFromServletModule)), 0); 
    }
    	
    // ------- ��� ó�� �� --------- /

    public synchronized String getOneColumnValue(Vector rData) {
		String colStr = "";
		if (rData.size() > 0) {
		    colStr = (String)( ((Vector)rData.elementAt(0)).elementAt(0));
		}
		return colStr;
    }
    
    //0 col~ index ���� Col ���� 
    public synchronized String getOneRowMultiColumnValue(Vector rData, int index) {
		String colStr = "";
		if (rData.size() > 0) {
			for (int i=0; i<index; i++) {
				colStr += ((Vector)rData.elementAt(0)).elementAt(i) + "\t";
			}		    
		}
		return colStr;
    }
    
    public synchronized Vector getColumnData(Vector rData, int index) {
		rowSingleData = null;
		rowSingleData = new Vector();
		int rCnt = rData.size();
		for (int i=0; i<rCnt; i++) {
		    rowSingleData.addElement ( ((Vector)rData.elementAt(i)).elementAt(index) );
		}
		return rowSingleData;
    }

 
}
