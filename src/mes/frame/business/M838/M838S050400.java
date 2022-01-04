package mes.frame.business.M838;
/*BOM�ڵ�*/
import java.lang.reflect.Method;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.util.Vector;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;

import mes.frame.common.ApprovalActionNo;
import mes.client.conf.Config;
import mes.frame.common.EventDefine;
import mes.frame.common.HashObject;
import mes.frame.common.MessageDefine;
import mes.frame.database.JDBCConnectionPool;
import mes.frame.database.SqlAdapter;
import mes.frame.serviceinterface.InoutParameter;
import mes.frame.serviceinterface.LoggingWriter;
import mes.frame.util.CommonFunction;


/**
 * ���� : �̺�ƮID�� �޼ҵ� ����
 */
public  class M838S050400 extends SqlAdapter{
	Connection con = null;
	PreparedStatement pstmt = null;
	String resultString = "";
	int resultInt = -1;
	StringBuffer sql = new StringBuffer();
	
	String[][] v_paramArray = new String[0][0]; 
	Class[] optClass = null;
	Object[] optObj = null;
	Object obj = null;
	
	public M838S050400(){
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
	public  int doExcute(InoutParameter ioParam){
		long startTime = System.currentTimeMillis();
		int doExcute_result = EventDefine.E_DOEXCUTE_INIT;;
		String event = ioParam.getEventSubID();

	    try{
            optClass = new Class[1];
			optClass[0] = ioParam.getClass() ;
			optObj = new Object[1];
			optObj[0] = ioParam;
			
			Method method = M838S050400.class.getMethod(event,optClass);
			LoggingWriter.setLogDebug(M838S050400.class.getName(),"==== " + event + " EventMethod Create Success ====");

			obj = method.invoke(M838S050400.class.newInstance(),optObj);
			doExcute_result = CommonFunction.getInt(obj.toString());
			
	    } catch (Exception ex) {
	    	doExcute_result = EventDefine.E_DOEXCUTE_INIT;
			ioParam.setMessage(MessageDefine.M_NO_EVENTID);
			LoggingWriter.setLogError(M838S050400.class.getName(),"==== EventID Not define : EVENT ID [ " + ioParam.getEventID() + "]");
	    } finally {
	    	obj = null;
			optClass = null;
			optObj = null;
	    }
	    long endTime = System.currentTimeMillis();
		long runningTime = endTime - startTime;
		LoggingWriter.setLogAll(M838S050400.class.getName(),"==== Query [����ð�  : " + runningTime + " ms]");
		
		return doExcute_result;
	}
	
	// S838S050400.jsp
	public int E104(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			System.out.println("JSONObject jArray rcvData="+ jArray.toString());
    		
			String sql = new StringBuilder()
					.append("SELECT \n")
					
					.append("	TO_CHAR(extnl_in_date,'YYYY-MM-DD HH24:MI:SS'),\n")
					.append("	extnl_in_object,\n")
					.append("	extnl_in_conpany,\n")
					.append("	extnl_in_title,\n")
					.append("	extnl_in_cust_name,\n")
					.append("	extnl_in_signature,\n")
					.append("	qc_mgr_aprvl,\n")
					.append("	qc_mgr_aprvl_date,\n")
					.append("	approval_mgr,\n")
					.append("	approval_date\n")
					
					.append("FROM\n")
					.append("	haccp_extnl_in_log_list\n")
					
					.append("WHERE TO_CHAR(extnl_in_date,'YYYY-MM-DD') \n")
					.append("BETWEEN '" + jArray.get("fromdate") + "' 	\n")
					.append("	 AND '" + jArray.get("todate") + "'	\n")
					.append(" 	AND member_key = '" + jArray.get("member_key") + "' \n") //member_key_select, update, delete
					
					.toString();

			String ActionCommand = ioParam.getActionCommand();
			if(ActionCommand.startsWith("doQueryTableFieldName")) {
				resultString = super.excuteQueryStringTableFieldName(con, sql.toString());
			}
			else {
				resultString = super.excuteQueryString(con, sql.toString());
			}
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M838S050400E104()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M838S050400E104()","==== finally ===="+ e.getMessage());
				}
	    	} else {
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
	
	// S838S050402.jsp ���� // S838S050403.jsp ����
	public int E124(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			System.out.println("JSONObject jArray rcvData="+ jArray.toString());
    		
			String sql = new StringBuilder()
					.append("SELECT \n")
					
					.append("	TO_CHAR(extnl_in_date,'YYYY-MM-DD HH24:MI:SS'),\n")
					.append("	extnl_in_object,\n")
					.append("	extnl_in_conpany,\n")
					.append("	extnl_in_title,\n")
					.append("	extnl_in_cust_name,\n")
					.append("	extnl_in_signature,\n")
					.append("	qc_mgr_aprvl,\n")
					.append("	qc_mgr_aprvl_date,\n")
					.append("	approval_mgr,\n")
					.append("	approval_date\n")
					
					.append("FROM\n")
					.append("	haccp_extnl_in_log_list\n")
					
					.append("WHERE extnl_in_date='" + jArray.get("extnl_in_date") + "' \n")
					.append("  AND member_key = '" + jArray.get("member_key") + "' \n")
					
					.toString();

			String ActionCommand = ioParam.getActionCommand();
			if(ActionCommand.startsWith("doQueryTableFieldName")) {
				resultString = super.excuteQueryStringTableFieldName(con, sql.toString());
			}
			else {
				resultString = super.excuteQueryString(con, sql.toString());
			}
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M838S050400E124()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M838S050400E124()","==== finally ===="+ e.getMessage());
				}
	    	} else {
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
	
	// S838S050400_canvas.jsp
	public int E144(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			System.out.println("JSONObject jArray rcvData="+ jArray.toString());
			
			String sql = new StringBuilder()
					.append("SELECT \n")
					
					.append("	TO_CHAR(extnl_in_date,'YYYY-MM-DD') AS extnl_in_date,\n")
					.append("	extnl_in_object,\n")
					.append("	extnl_in_conpany,\n")
					.append("	extnl_in_title,\n")
					.append("	extnl_in_cust_name,\n")
					.append("	extnl_in_signature,\n")
					.append("	qc_mgr_aprvl,\n")
					.append("	qc_mgr_aprvl_date,\n")
					.append("	approval_mgr,\n")
					.append("	approval_date\n")
					.append("FROM\n")
					.append("	haccp_extnl_in_log_list\n")
//					.append("WHERE extnl_in_date \n")
//					.append("BETWEEN '" + jArray.get("extnl_in_date_start") + "' 	\n")
//					.append("	 AND '" + jArray.get("extnl_in_date_end") + "'	\n")
//					.append(" 	AND member_key = '" + jArray.get("member_key") + "' \n") //member_key_select, update, delete
					.append("WHERE member_key = '" + jArray.get("member_key") + "' \n")
					.append("ORDER BY extnl_in_date  \n")
					.append("LIMIT " + jArray.get("page_start") + "," + jArray.get("page_end") + " \n")
					.toString();
			
			String ActionCommand = ioParam.getActionCommand();
			if(ActionCommand.startsWith("doQueryTableFieldName")) {
				resultString = super.excuteQueryStringTableFieldName(con, sql.toString());
			}
			else {
				resultString = super.excuteQueryString(con, sql.toString());
			}
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M838S050400E144()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M838S050400E144()","==== finally ===="+ e.getMessage());
				}
	    	} else {
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
	
	// T838S050400.jsp ���ȭ��(Tablet) // S838S050401.jsp ���
	public int E101(InoutParameter ioParam){ 
		resultInt = EventDefine.E_DOEXCUTE_INIT;

		try {
			con = JDBCConnectionPool.getConnection();
			con.setAutoCommit(false);
			
			// insert_update_delete_json.jsp���� �޾ƿ� JSON������ ó��
    		JSONObject jArray = new JSONObject();
    		jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
    		System.out.println("JSONObject jArray rcvData="+ jArray.toString());
    		// Object�����Ϳ��� Ű��(param)���� JSONArray�����͸� ������. (�����͹��� �ϳ��϶� ����)

			String sql = new StringBuilder()
				.append("INSERT INTO \n")
				.append("	haccp_extnl_in_log_list ( \n")
				.append("		extnl_in_date,\n")
				.append("		extnl_in_object,\n")
				.append("		extnl_in_conpany,\n")
				.append("		extnl_in_title,\n")
				.append("		extnl_in_cust_name,\n")
				.append("		extnl_in_signature,\n")
				.append("		qc_mgr_aprvl,\n")
				.append("		qc_mgr_aprvl_date,\n")
				.append("		approval_mgr,\n")
				.append("		approval_date\n")
				.append(" 		,member_key	\n") // member_key_insert
				.append("	) VALUES ( \n")
				.append(" 		'"	+ jArray.get("extnl_in_date") + "',	\n")
				.append(" 		'"	+ jArray.get("extnl_in_object") + "',	\n")
				.append(" 		'"	+ jArray.get("extnl_in_conpany") + "',	\n")
				.append(" 		'"	+ jArray.get("extnl_in_title") + "',	\n")
				.append(" 		'"	+ jArray.get("extnl_in_cust_name") + "',	\n")
				.append(" 		'"	+ jArray.get("extnl_in_signature") + "',	\n")
				.append(" 		'"	+ jArray.get("qc_mgr_aprvl") + "',	\n")
				.append(" 		'"	+ jArray.get("qc_mgr_aprvl_date") + "',	\n")
				.append(" 		'"	+ jArray.get("approval_mgr") + "',	\n")
				.append(" 		'"	+ jArray.get("approval_date") + "'	\n")
				.append(" 		,'" + jArray.get("member_key") + "' \n") //member_key_values
				.append("	) \n")
				.toString();
		
			resultInt = super.excuteUpdate(con, sql.toString());
	    	if(resultInt < 0){  //
				ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
				con.rollback();
				return EventDefine.E_DOEXCUTE_ERROR ;
			}
			con.commit();
		} catch(Exception e) {
			e.getStackTrace();
			LoggingWriter.setLogError("M838S050400E101()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
				}
	    	} else {
	    	}
	    }
		ioParam.setResultString(resultString);
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
    	ioParam.setMessage(MessageDefine.M_QUERY_OK);
	    return EventDefine.E_QUERY_RESULT;
	}	
	
	// S838S050402.jsp ����
	public int E102(InoutParameter ioParam){ 
		resultInt = EventDefine.E_DOEXCUTE_INIT;

		try {
			con = JDBCConnectionPool.getConnection();
			con.setAutoCommit(false);
			
			// insert_update_delete_json.jsp���� �޾ƿ� JSON������ ó��
    		JSONObject jArray = new JSONObject();
    		jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
    		System.out.println("JSONObject jArray rcvData="+ jArray.toString());
    		// Object�����Ϳ��� Ű��(param)���� JSONArray�����͸� ������. (�����͹��� �ϳ��϶� ����)

			String sql = new StringBuilder()
				.append("UPDATE haccp_extnl_in_log_list \n")
				.append("SET \n")
				.append("	extnl_in_date='"	+ jArray.get("extnl_in_date") + "',\n")
				.append("	extnl_in_object='"	+ jArray.get("extnl_in_object") + "',\n")
				.append("	extnl_in_conpany='"	+ jArray.get("extnl_in_conpany") + "',\n")
				.append("	extnl_in_title='"	+ jArray.get("extnl_in_title") + "',\n")
				.append("	extnl_in_cust_name='"	+ jArray.get("extnl_in_cust_name") + "',\n")
				.append("	extnl_in_signature='"	+ jArray.get("extnl_in_signature") + "',\n")
				.append("	qc_mgr_aprvl='"		+ jArray.get("qc_mgr_aprvl") + "',\n")
				.append("	qc_mgr_aprvl_date='"+ jArray.get("qc_mgr_aprvl_date") + "',\n")
				.append("	approval_mgr='"		+ jArray.get("approval_mgr") + "',\n")
				.append("	approval_date='"	+ jArray.get("approval_date") + "',\n")
				.append(" 	member_key='" 		+ jArray.get("member_key") + "' \n") // member_key_insert
				.append("WHERE extnl_in_date='" + jArray.get("extnl_in_date") + "' \n")
				.append("  AND member_key = '" 	+ jArray.get("member_key") + "' \n")
				.toString();
		
			resultInt = super.excuteUpdate(con, sql.toString());
	    	if(resultInt < 0){  //
				ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
				con.rollback();
				return EventDefine.E_DOEXCUTE_ERROR ;
			}
			con.commit();
		} catch(Exception e) {
			e.getStackTrace();
			LoggingWriter.setLogError("M838S050400E102()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
				}
	    	} else {
	    	}
	    }
		ioParam.setResultString(resultString);
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
    	ioParam.setMessage(MessageDefine.M_QUERY_OK);
	    return EventDefine.E_QUERY_RESULT;
	}
	
	// S838S050403.jsp ����
	public int E103(InoutParameter ioParam){ 
		resultInt = EventDefine.E_DOEXCUTE_INIT;

		try {
			con = JDBCConnectionPool.getConnection();
			con.setAutoCommit(false);
			
			// insert_update_delete_json.jsp���� �޾ƿ� JSON������ ó��
    		JSONObject jArray = new JSONObject();
    		jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
    		System.out.println("JSONObject jArray rcvData="+ jArray.toString());
    		// Object�����Ϳ��� Ű��(param)���� JSONArray�����͸� ������. (�����͹��� �ϳ��϶� ����)

			String sql = new StringBuilder()
				.append("DELETE FROM haccp_extnl_in_log_list \n")
				.append("WHERE extnl_in_date='" + jArray.get("extnl_in_date") + "' \n")
				.append("  AND member_key = '" 	+ jArray.get("member_key") + "' \n")
				.toString();
		
			resultInt = super.excuteUpdate(con, sql.toString());
	    	if(resultInt < 0){  //
				ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
				con.rollback();
				return EventDefine.E_DOEXCUTE_ERROR ;
			}
			con.commit();
		} catch(Exception e) {
			e.getStackTrace();
			LoggingWriter.setLogError("M838S050400E103()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
				}
	    	} else {
	    	}
	    }
		ioParam.setResultString(resultString);
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
    	ioParam.setMessage(MessageDefine.M_QUERY_OK);
	    return EventDefine.E_QUERY_RESULT;
	}

}