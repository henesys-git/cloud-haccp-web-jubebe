package mes.frame.business.M000;

import java.lang.reflect.Method;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.text.SimpleDateFormat;
import java.util.Date;

import mes.frame.common.EventDefine;
import mes.frame.common.HashObject;
import mes.frame.common.MessageDefine;
import mes.frame.database.JDBCConnectionPool;
import mes.frame.database.SqlAdapter;
import mes.frame.serviceinterface.InoutParameter;
import mes.frame.serviceinterface.LoggingWriter;
import mes.frame.util.CommonFunction;


public class M000S030000 extends SqlAdapter {
	Connection con = null;
	PreparedStatement pstmt = null;
	String resultString = "";
	int resultInt = -1;
	StringBuffer sql = new StringBuffer();
	
	String[][] v_paramArray = new String[0][0];
	Class[] optClass = null;
	Object[] optObj = null;
	Object obj = null;
	
	public M000S030000(){
	}
	/**
	 * ����ڰ� �����ؼ� �Ķ���� �����ϴ� method.
	 * @param	ioParam , p_sql
	 * @return the desired integer.
	 */
	public int custParamCheck(InoutParameter ioParam, StringBuffer p_sql){
		int paramInt = 0;
	
		return paramInt;
	}

	public String getCurrentDate(String format) {
        Date d = new Date();
        SimpleDateFormat sdf = new SimpleDateFormat(format);
        return sdf.format(d);
    }

	/**
	 * �Է��Ķ��Ÿ�� 2���� �����ΰ�� �Ķ���� �����ϴ� method.
	 * @param	ioParam , p_sql
	 * @return the desired integer.
	 */
	public int paramCheck(InoutParameter ioParam, StringBuffer p_sql){
		v_paramArray = super.getParamCheck(ioParam,p_sql);
		return v_paramArray[0].length;
	}
	/**
	 * �Է��Ķ��Ÿ���� �̺�ƮID���� �޼ҵ� ȣ���ϴ� method.
	 * @param	ioParam
	 * @return the desired integer.
	 */
	public int doExcute(InoutParameter ioParam){
		long startTime = System.currentTimeMillis();
		int doExcute_result = EventDefine.E_DOEXCUTE_INIT;;
		String event = ioParam.getEventSubID();
		
	    try {
            optClass = new Class[1];
			optClass[0] = ioParam.getClass() ;
			optObj = new Object[1];
			optObj[0] = ioParam;
			
			Method method = M000S030000.class.getMethod(event,optClass);
			LoggingWriter.setLogDebug(M000S030000.class.getName(),"==== " + event + " EventMethod Create Success ====");

			obj = method.invoke(M000S030000.class.newInstance(),optObj);
			doExcute_result = CommonFunction.getInt(obj.toString());
			
	    } catch (Exception ex) {
	    	doExcute_result = EventDefine.E_DOEXCUTE_INIT;
			ioParam.setMessage(MessageDefine.M_NO_EVENTID);
			LoggingWriter.setLogError(M000S030000.class.getName(),"==== EventID Not define : EVENT ID [ " + ioParam.getEventID() + "]");
	    } finally {
	    	obj = null;
			optClass = null;
			optObj = null;
	    }
	    
	    long endTime = System.currentTimeMillis();
		long runningTime = endTime - startTime;
		LoggingWriter.setLogAll(M000S030000.class.getName(),"==== Query [����ð�  : " + runningTime + " ms]");
		
		return doExcute_result;
	}
	
	// ǰ���˻籸���ڵ� v_inspect_gubun_code
	public int E036(InoutParameter ioParam){		
		resultInt = EventDefine.E_DOEXCUTE_INIT;
				
		try {
			String rcvData = (String)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			v_paramArray = CommonFunction.getConvString2DoubleArray(rcvData);
			
			con = JDBCConnectionPool.getConnection();
			
			// ä��(CHAN)
			sql = new StringBuffer();
			sql.append(" select CODE_VALUE, CODE_NAME, CODE_CD \n");
			sql.append(" from v_incongruity_code ");
			resultString = super.excuteQueryString(con, sql.toString());
			
		} catch(Exception e) {
			LoggingWriter.setLogError("M000S030000E036()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
			try {
				if (con != null) con.close();
			} catch (Exception e) {
				LoggingWriter.setLogError("M000S030000E036()","==== finally ===="+ e.getMessage());
			}
	    }

	    // ��� ���� ������ ���� �Ķ���͵��� ���̿� �Ķ���Ϳ� �����Ѵ�.
		ioParam.setResultString(resultString);
		// ���ۿ��� ó���� Į���� ������ Ŭ���̾�Ʈ���� ������ ���� �����´�.
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
		// �� ó���Ǿ��ٴ� �޽����� Ŭ���̾�Ʈ���� ������ ���� I/O�Ķ���Ϳ� �����Ѵ�.
    	ioParam.setMessage(MessageDefine.M_QUERY_OK);
	    return EventDefine.E_QUERY_RESULT;
	}

}