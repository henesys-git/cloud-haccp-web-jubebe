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
public  class M838S070900 extends SqlAdapter{
	Connection con = null;
	PreparedStatement pstmt = null;
	String resultString = "";
	int resultInt = -1;
	StringBuffer sql = new StringBuffer();
	
	String[][] v_paramArray = new String[0][0]; 
	Class[] optClass = null;
	Object[] optObj = null;
	Object obj = null;
	
	public M838S070900(){
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
			
			Method method = M838S070900.class.getMethod(event,optClass);
			LoggingWriter.setLogDebug(M838S070900.class.getName(),"==== " + event + " EventMethod Create Success ====");

			obj = method.invoke(M838S070900.class.newInstance(),optObj);
			doExcute_result = CommonFunction.getInt(obj.toString());
			
	    } catch (Exception ex) {
	    	doExcute_result = EventDefine.E_DOEXCUTE_INIT;
			ioParam.setMessage(MessageDefine.M_NO_EVENTID);
			LoggingWriter.setLogError(M838S070900.class.getName(),"==== EventID Not define : EVENT ID [ " + ioParam.getEventID() + "]");
	    } finally {
	    	obj = null;
			optClass = null;
			optObj = null;
	    }
	    long endTime = System.currentTimeMillis();
		long runningTime = endTime - startTime;
		LoggingWriter.setLogAll(M838S070900.class.getName(),"==== Query [����ð�  : " + runningTime + " ms]");
		
		return doExcute_result;
	}
	
	// S838S070900.jsp
	public int E104(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			System.out.println("JSONObject jArray rcvData="+ jArray.toString());
    		
			String sql = new StringBuilder()
					.append("SELECT\n")
					.append("	TO_CHAR(check_datetime,'YYYY-MM-DD HH24:MI'),\n")
					.append("	A.item_cd,\n")
					.append("	A.item_cd_rev,\n")
					.append("	P.part_nm,\n")
					.append("	orign_country,\n")
					.append("	TO_CHAR(thaw_start_datetime,'YYYY-MM-DD HH24:MI'),\n")
					.append("	TO_CHAR(thaw_end_datetime,'YYYY-MM-DD HH24:MI'),\n")
					.append("	temperature,\n")
					.append("	sign_matter,\n")
					.append("	packing_shape,\n")
					.append("	A.writor,\n")
					.append("	A.writor_rev,\n")
					.append("	U1.user_nm,\n")
					.append("	write_date,\n")
					.append("	A.approval,\n")
					.append("	A.approval_rev,\n")
					.append("	U2.user_nm,\n")
					.append("	approve_date,\n")
					.append("	incong_note,\n")
					.append("	improve_note,\n")
					.append("	bigo_note\n")
					.append("FROM\n")
					.append("	haccp_thaw_check_report A\n")
					.append("INNER JOIN tbm_part_list P\n")
					.append("	ON A.item_cd = P.part_cd\n")
					.append("	AND A.item_cd_rev = P.revision_no\n")
					.append("	AND A.member_key = P.member_key\n")
					.append("INNER JOIN tbm_users U1\n")
					.append("	ON A.writor = U1.user_id\n")
					.append("	AND A.writor_rev = U1.revision_no\n")
					.append("	AND A.member_key = U1.member_key\n")
					.append("LEFT OUTER JOIN tbm_users U2\n")
					.append("	ON A.approval = U2.user_id\n")
					.append("	AND A.approval_rev = U2.revision_no\n")
					.append("	AND A.member_key = U2.member_key\n")
					.append("WHERE TO_CHAR(A.check_datetime,'YYYY-MM-DD')\n")
					.append("		BETWEEN '" + jArray.get("fromdate") + "'	\n")
					.append("			AND '" 	+ jArray.get("todate") 	 + "'	\n")
					.append(" 	AND A.member_key = '" + jArray.get("member_key") + "' \n") //member_key_select, update, delete
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
			LoggingWriter.setLogError("M838S070900E104()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M838S070900E104()","==== finally ===="+ e.getMessage());
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
	
	// S838S070900_canvas.jsp
	public int E144(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			System.out.println("JSONObject jArray rcvData="+ jArray.toString());
			
			String sql = new StringBuilder()
					.append("SELECT\n")
					.append("	P.part_nm,\n") // .append("A.item_cd,\n").append("A.item_cd_rev,\n")
					.append("	orign_country,\n")
					.append("	thaw_start_datetime,\n")
					.append("	thaw_end_datetime,\n")
					.append("	temperature,\n")
					.append("	sign_matter,\n")
					.append("	packing_shape,\n")
					.append("	U1.user_nm,\n") // .append("A.writor,\n").append("A.writor_rev,\n")
					.append("	U2.user_nm,\n") // .append("A.approval,\n").append("A.approval_rev,\n")
					.append("	incong_note,\n")
					.append("	improve_note,\n")
					.append("	bigo_note\n")
					.append("FROM\n")
					.append("	haccp_thaw_check_report A\n")
					.append("INNER JOIN tbm_part_list P\n")
					.append("	ON A.item_cd = P.part_cd\n")
					.append("	AND A.item_cd_rev = P.revision_no\n")
					.append("	AND A.member_key = P.member_key\n")
					.append("INNER JOIN tbm_users U1\n")
					.append("	ON A.writor = U1.user_id\n")
					.append("	AND A.writor_rev = U1.revision_no\n")
					.append("	AND A.member_key = U1.member_key\n")
					.append("LEFT OUTER JOIN tbm_users U2\n")
					.append("	ON A.approval = U2.user_id\n")
					.append("	AND A.approval_rev = U2.revision_no\n")
					.append("	AND A.member_key = U2.member_key\n")
//					.append("WHERE TO_CHAR(A.check_datetime,'YYYY-MM-DD')\n")
//					.append("		BETWEEN '" + jArray.get("check_date_start") + "' 	\n")
//					.append("			AND '" + jArray.get("check_date_end") + "'	\n")
//					.append("	AND A.member_key = '" + jArray.get("member_key") + "' \n")
					.append("WHERE A.member_key = '" + jArray.get("member_key") + "' \n")
					.append("ORDER BY A.check_datetime \n")
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
			LoggingWriter.setLogError("M838S070900E144()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M838S070900E144()","==== finally ===="+ e.getMessage());
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

	
	// T838S070900.jsp ���ȭ��(Tablet)
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
				.append("	haccp_thaw_check_report (	\n")
				.append("		check_datetime,\n")
				.append("		item_cd,\n")
				.append("		item_cd_rev,\n")
				.append("		orign_country,\n")
				.append("		thaw_start_datetime,\n")
				.append("		thaw_end_datetime,\n")
				.append("		temperature,\n")
				.append("		sign_matter,\n")
				.append("		packing_shape,\n")
				.append("		writor,\n")
				.append("		writor_rev,\n")
				.append("		write_date,\n")
				.append("		approval,\n")
				.append("		approval_rev,\n")
				.append("		approve_date,\n")
				.append("		incong_note,\n")
				.append("		improve_note,\n")
				.append("		bigo_note,\n")
				.append("		member_key\n")
				.append("	) VALUES ( 				\n")
				.append(" 		'"	+ jArray.get("check_datetime") + "',	\n")
				.append(" 		'"	+ jArray.get("item_cd") + "',	\n")
				.append(" 		'"	+ jArray.get("item_cd_rev") + "',	\n")
				.append(" 		'"	+ jArray.get("orign_country") + "',	\n")
				.append(" 		'"	+ jArray.get("thaw_start_datetime") + "',	\n")
				.append(" 		'"	+ jArray.get("thaw_end_datetime") + "',	\n")
				.append(" 		'"	+ jArray.get("temperature") + "',	\n")
				.append(" 		'"	+ jArray.get("sign_matter") + "',	\n")
				.append(" 		'"	+ jArray.get("packing_shape") + "',	\n")
				.append(" 		'"	+ jArray.get("writor") + "',	\n")
				.append(" 		'"	+ jArray.get("writor_rev") + "',	\n")
				.append(" 		'"	+ jArray.get("write_date") + "',	\n")
				.append(" 		'"	+ jArray.get("approval") + "',	\n")
				.append(" 		'"	+ jArray.get("approval_rev") + "',	\n")
				.append(" 		'"	+ jArray.get("approve_date") + "',	\n")
				.append(" 		'"	+ jArray.get("incong_note") + "',	\n")
				.append(" 		'"	+ jArray.get("improve_note") + "',	\n")
				.append(" 		'"	+ jArray.get("bigo_note") + "',	\n")
				.append(" 		'"	+ jArray.get("member_key") + "' \n")
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
			LoggingWriter.setLogError("M838S070900E101()","==== SQL ERROR ===="+ e.getMessage());
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