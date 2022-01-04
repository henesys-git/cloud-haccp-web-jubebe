package mes.frame.business.M909;

import java.lang.reflect.Method;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.util.Vector;

import org.json.simple.JSONObject;

import mes.client.conf.Config;
import mes.frame.common.EventDefine;
import mes.frame.common.HashObject;
import mes.frame.common.MessageDefine;
import mes.frame.database.JDBCConnectionPool;
import mes.frame.database.SqlAdapter;
import mes.frame.serviceinterface.InoutParameter;
import mes.frame.serviceinterface.LoggingWriter;
import mes.frame.util.CommonFunction;


public class M909S130100 extends SqlAdapter{
	Connection con = null;
	PreparedStatement pstmt = null;
	String resultString = "";
	int resultInt = -1;
	StringBuffer sql = new StringBuffer();
	
	String[][] v_paramArray = new String[0][0]; 
	Class[] optClass = null;
	Object[] optObj = null;
	Object obj = null;
	
	public M909S130100(){
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

			Method method = M909S130100.class.getMethod(event,optClass);
			LoggingWriter.setLogDebug(M909S130100.class.getName(),"==== " + event + " EventMethod Create Success ====");

			obj = method.invoke(M909S130100.class.newInstance(),optObj);
			doExcute_result = CommonFunction.getInt(obj.toString());
			
	    } catch (Exception ex) {
	    	doExcute_result = EventDefine.E_DOEXCUTE_INIT;
			ioParam.setMessage(MessageDefine.M_NO_EVENTID);
			LoggingWriter.setLogError(M909S130100.class.getName(),"==== EventID Not define : EVENT ID [ " + ioParam.getEventID() + "]");
	    } finally {
	    	obj = null;
			optClass = null;
			optObj = null;
	    }
	    long endTime = System.currentTimeMillis();
		long runningTime = endTime - startTime;
		LoggingWriter.setLogAll(M909S130100.class.getName(),"==== Query [����ð�  : " + runningTime + " ms]");
		
		return doExcute_result;
	}
	

	public int E101(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			System.out.println("JSONObject jArray rcvData="+ jArray.toString());
			
			// Ŭ���̾�Ʈ�� ���� ���� �Ķ���͸� �Ű� ��´�.
//			String rcvData = (String)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			
			// Ŭ���̾�Ʈ�� ���� ���� �Ķ���͸� �ɰ�� �迭�� ��´�.
//			String[][] c_paramArray = CommonFunction.getConvString2DoubleArray(rcvData);

			String sql = new StringBuilder()
				.append("INSERT INTO tbm_doc_base ( "
						+		"document_no, "
						+		"revision_no, "
						+		"document_name, "
						+		"security_doc_yn, "
						+		"hold_period, "
						+		"gubun_code, "
						+		"start_date, "
						+		"duration_date, "
						+		"create_user_id, "
						+		"create_date, "
						+		"modify_user_id, "
						+		"modify_reason, "
						+		"modify_date,"
						+		"member_key  \n")
				.append(") values ('"+ jArray.get("DocCode") + "' \n")		//document_no
				.append(" 		,'"+ jArray.get("RevisionNo") + "' \n") 	//revision_no
				.append(" 		,'"+ jArray.get("DocName") + "' \n") 		//document_name
				.append(" 		,'"+ jArray.get("Secret") + "' \n") 		//security_doc_yn
				.append(" 		,'"+ jArray.get("HoldYear") + "' \n") 		//hold_period
				.append(" 		,'"+ jArray.get("DocGubunCode") + "' \n") 	//gubun_code
				.append(" 		,'"+ jArray.get("StartDate") + "' \n") 	//start_date
				.append(" 		,'9999-12-31' \n") 						//duration_date
				.append(" 		,'"+ jArray.get("user_id") + "' \n") 		//create_user_id
				.append(" 		,SYSDATETIME\n") 						//create_date
				.append(" 		,'"+ jArray.get("user_id") + "'\n") 		//modify_user_id
				.append(" 		,'���ʵ��'\n") 							//modify_reason
				.append(" 		,SYSDATETIME \n")						//modify_date
				.append(" 		,'" + jArray.get("member_key") + "' \n") //member_key_values
				.append(") \n")
				.toString();
					
			// System.out.println(sql.toString());
				resultInt = super.excuteUpdate(con, sql.toString());
				if (resultInt < 0) {
					ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
				} else {
					ioParam.setMessage(resultInt + "�� " + MessageDefine.M_INSERT_RESULT);
				}
				
		} catch(Exception e) {
			LoggingWriter.setLogError("M909S130100E101()","==== SQL ERROR ===="+ e.getMessage() + "\n" + sql.toString());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M909S130100E101()","==== finally ===="+ e.getMessage());
				}
	    	} else {
	    	}
	    }
	    // ��� ���� ������ ���� �Ķ���͵��� ���̿� �Ķ���Ϳ� �����Ѵ�.
		ioParam.setResultString(resultString);
		// ���ۿ��� ó���� Į���� ������ Ŭ���̾�Ʈ���� ������ ���� �����´�.
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
		// �� ó���Ǿ��ٴ� �޽����� Ŭ���̾�Ʈ���� ������ ���� I/O�Ķ���Ϳ� �����Ѵ�.
		// ������ ����� ���� �����ϱ� ���ؼ� ���´�.
    	// ioParam.setMessage(MessageDefine.M_QUERY_OK);
	    return EventDefine.E_QUERY_RESULT;
	}

	public int E102(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			System.out.println("JSONObject jArray rcvData="+ jArray.toString());
			
			// Ŭ���̾�Ʈ�� ���� ���� �Ķ���͸� �Ű� ��´�.
//			String rcvData = (String)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			// Ŭ���̾�Ʈ�� ���� ���� �Ķ���͸� �ɰ�� �迭�� ��´�.
//			String[][] c_paramArray = CommonFunction.getConvString2DoubleArray(rcvData);
			
			con.setAutoCommit(false);

			// ���� ���� �������� ���� �����������ڸ� �̹��� �������ڿ��� �Ϸ縦 �� ��¥�� �����Ѵ�.
			String sqlPre = new StringBuilder()
					.append("UPDATE tbm_doc_base SET	\n")
					.append(" duration_date = to_char(TO_DATE('"+ jArray.get("StartDate") + "', 'YYYY-MM-DD')-1 , 'YYYY-MM-DD')	\n")
					.append(" 	,member_key = 	'" + jArray.get("member_key") + "'		\n")
					.append("WHERE document_no = '" + jArray.get("DocCode") + "'\n")
					// 13��°�� ������ �������ڵ尡 ���´�.
					.append("	AND revision_no = '" + jArray.get("RevisionNo_Target") + "'\n")
					.append(" 	AND member_key = '" + jArray.get("member_key") + "' \n") //member_key_select, update, delete
					.toString();
			
			System.out.println(sqlPre.toString());
			
			resultInt = super.excuteUpdate(con, sqlPre.toString());
			if (resultInt < 0) {
				con.rollback();
				ioParam.setMessage(MessageDefine.M_UPDATE_FAILED);
				return resultInt;
			} else {
				ioParam.setMessage(resultInt + "�� " + MessageDefine.M_UPDATE_RESULT);
			}

			
			String sql = new StringBuilder()
					.append("INSERT INTO tbm_doc_base ( "
							+ "document_no, "
							+ "revision_no, "
							+ "document_name, "
							+ "security_doc_yn, "
							+ "hold_period, "
							+ "gubun_code, "
							+ "start_date, "
							+ "duration_date, "
							+ "create_user_id, "
							+ "create_date, "
							+ "modify_user_id, "
							+ "modify_reason, "
							+ "modify_date,"
							+ "member_key \n")
					.append(") values ('"	+ jArray.get("DocCode") + "' \n")		//document_no
					.append(" 		,'" 	+ jArray.get("RevisionNo") + "' \n") 	//revision_no
					.append(" 		,'" 	+ jArray.get("DocName") + "' \n") 		//document_name
					.append(" 		,'" 	+ jArray.get("Secret") + "' \n") 		//security_doc_yn
					.append(" 		,'" 	+ jArray.get("HoldYear") + "' \n") 		//hold_period
					.append(" 		,'" 	+ jArray.get("DocGubunCode") + "' \n") 	//gubun_code
					.append(" 		,'" 	+ jArray.get("StartDate") + "' \n") 	//start_date
					.append(" 		,'9999-12-31' \n") 								//duration_date
					.append(" 		,'" 	+ jArray.get("user_id") + "' \n") 		//create_user_id
					.append(" 		,SYSDATETIME					  \n") 			//create_date
					.append(" 		,'" 	+ jArray.get("user_id") + "' \n") 		//modify_user_id
					.append(" 		,'����' \n") 										//modify_reason
					.append(" 		,SYSDATETIME \n")								//modify_date
					.append(" 		,'" + jArray.get("member_key") + "' \n") //member_key_values
					.append(") \n")
					.toString();
					
			// System.out.println(sql.toString());
				resultInt = super.excuteUpdate(con, sql.toString());
				if (resultInt < 0) {
					ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
				} else {
					ioParam.setMessage(resultInt + "�� " + MessageDefine.M_INSERT_RESULT);
				}
				
			con.commit();
		} catch(Exception e) {
			LoggingWriter.setLogError("M909S130100E102()","==== SQL ERROR ===="+ e.getMessage() + "\n" + sql.toString());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M909S130100E102()","==== finally ===="+ e.getMessage());
				}
	    	} else {
	    	}
	    }
	    // ��� ���� ������ ���� �Ķ���͵��� ���̿� �Ķ���Ϳ� �����Ѵ�.
		ioParam.setResultString(resultString);
		// ���ۿ��� ó���� Į���� ������ Ŭ���̾�Ʈ���� ������ ���� �����´�.
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
		// �� ó���Ǿ��ٴ� �޽����� Ŭ���̾�Ʈ���� ������ ���� I/O�Ķ���Ϳ� �����Ѵ�.
		// ������ ����� ���� �����ϱ� ���ؼ� ���´�.
    	// ioParam.setMessage(MessageDefine.M_QUERY_OK);
	    return EventDefine.E_QUERY_RESULT;
	}

	
	public int E103(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			System.out.println("JSONObject jArray rcvData="+ jArray.toString());
			
			// Ŭ���̾�Ʈ�� ���� ���� �Ķ���͸� �Ű� ��´�.
//			String rcvData = (String)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			
			// Ŭ���̾�Ʈ�� ���� ���� �Ķ���͸� �ɰ�� �迭�� ��´�.
//			String[][] c_paramArray = CommonFunction.getConvString2DoubleArray(rcvData);

			String sql = new StringBuilder()
				.append("DELETE FROM tbm_doc_base  \n")
				.append(" WHERE document_no = '" 	+ jArray.get("DocCode") + "'	\n")
				.append("	AND revision_no = '" 	+ jArray.get("RevisionNo_Target") + "'	\n")
				.append(" 	AND member_key = '" + jArray.get("member_key") + "' \n") //member_key_select, update, delete
				.toString();
					
				resultInt = super.excuteUpdate(con, sql.toString());
				if (resultInt < 0) {
					ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
				} else {
					ioParam.setMessage(resultInt + "�� " + MessageDefine.M_INSERT_RESULT);
				}
				
		} catch(Exception e) {
			LoggingWriter.setLogError("M909S130100E103()","==== SQL ERROR ===="+ e.getMessage() + "\n" + sql.toString());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M909S130100E103()","==== finally ===="+ e.getMessage());
				}
	    	} else {
	    	}
	    }
	    // ��� ���� ������ ���� �Ķ���͵��� ���̿� �Ķ���Ϳ� �����Ѵ�.
		ioParam.setResultString(resultString);
		// ���ۿ��� ó���� Į���� ������ Ŭ���̾�Ʈ���� ������ ���� �����´�.
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
		// �� ó���Ǿ��ٴ� �޽����� Ŭ���̾�Ʈ���� ������ ���� I/O�Ķ���Ϳ� �����Ѵ�.
		// ������ ����� ���� �����ϱ� ���ؼ� ���´�.
    	// ioParam.setMessage(MessageDefine.M_QUERY_OK);
	    return EventDefine.E_QUERY_RESULT;
	}

	// �̷����ǿ� �ش��ϴ� �ŷ�ó ����� GROUP BY �˻��Ѵ�. 
	public int E104(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			System.out.println("JSONObject jArray rcvData="+ jArray.toString());
			
			// Ŭ���̾�Ʈ�� ���� ���� �Ķ���͸� �Ű� ��´�.
//			String rcvData = (String)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			// Ŭ���̾�Ʈ�� ���� ���� �Ķ���͸� �ɰ�� �迭�� ��´�.
			// rcvData = [���浵]
			
//			String[][] c_paramArray = CommonFunction.getConvString2DoubleArray(rcvData);
			String sql = new StringBuilder()
					.append("SELECT\n")
					.append("	document_no,		\n")
					.append("	revision_no,		\n")
					.append("	document_name,		\n")
					.append("	security_doc_yn,	\n")
					.append("	hold_period,		\n")
					.append("	gubun_code,			\n")
					.append("	B.code_name,		\n")
					.append("	start_date,			\n")
					.append("	duration_date,		\n")
					.append("	create_user_id,		\n")
					.append("	create_date,		\n")
					.append("	modify_user_id,		\n")
					.append("	modify_reason,		\n")
					.append("	modify_date			\n")
					.append("FROM	tbm_doc_base A		\n")
					.append("INNER JOIN v_doc_gubun B	\n")
					.append("ON  A.gubun_code = B.code_value\n")
					.append("	AND A.member_key = B.member_key\n")
					.append("WHERE gubun_code like '%" 	+ jArray.get("DOCGUBUN") + "%'	\n")
					.append(" 	AND A.member_key = '" + jArray.get("member_key") + "' \n") //member_key_select, update, delete
					.toString();  

			resultString = super.excuteQueryString(con, sql.toString());
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M909S130100E104()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M909S130100E104()","==== finally ===="+ e.getMessage());
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
	
	// �̷����ǿ� �ش��ϴ� �ŷ�ó ����� GROUP BY �˻��Ѵ�. 
	public int E105(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			System.out.println("JSONObject jArray rcvData="+ jArray.toString());
			
			// Ŭ���̾�Ʈ�� ���� ���� �Ķ���͸� �Ű� ��´�.
//			String rcvData = (String)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			// Ŭ���̾�Ʈ�� ���� ���� �Ķ���͸� �ɰ�� �迭�� ��´�.
			// rcvData = [���浵]
			
//			String[][] c_paramArray = CommonFunction.getConvString2DoubleArray(rcvData);
			String sql = new StringBuilder()
					.append("SELECT\n")
					.append("	document_no,		\n")
					.append("	revision_no,		\n")
					.append("	document_name,		\n")
					.append("	security_doc_yn,	\n")
					.append("	hold_period,		\n")
					.append("	gubun_code,			\n")
					.append("	B.code_name,		\n")
					.append("	start_date,			\n")
					.append("	duration_date,		\n")
					.append("	create_user_id,		\n")
					.append("	create_date,		\n")
					.append("	modify_user_id,		\n")
					.append("	modify_reason,		\n")
					.append("	modify_date			\n")
					.append("FROM	tbm_doc_base A		\n")
					.append("INNER JOIN v_doc_gubun B	\n")
					.append("ON  A.gubun_code = B.code_value\n")
					.append("	AND A.member_key = B.member_key\n")
					.append("WHERE gubun_code like '%" 	+ jArray.get("DOCGUBUN") + "%'	\n")
					.append(" 	and TO_CHAR(SYSDATE,'YYYY-MM-DD') BETWEEN  start_date AND duration_date\n")
					.append(" 	AND A.member_key = '" + jArray.get("member_key") + "' \n") //member_key_select, update, delete
					.toString();  

			resultString = super.excuteQueryString(con, sql.toString());
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M909S130100E105()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M909S130100E105()","==== finally ===="+ e.getMessage());
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

	// DocCodeView.jsp 
	public int E194(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			// Ŭ���̾�Ʈ�� ���� ���� �Ķ���͸� �Ű� ��´�.
			String rcvData = (String)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			// Ŭ���̾�Ʈ�� ���� ���� �Ķ���͸� �ɰ�� �迭�� ��´�.
			// rcvData = [���浵]
			
			String[][] c_paramArray = CommonFunction.getConvString2DoubleArray(rcvData);
			String sql = new StringBuilder()
					.append("SELECT\n")
					.append("	document_no,		\n")
					.append("	revision_no,		\n")
					.append("	document_name,		\n")
					.append("	security_doc_yn,	\n")
					.append("	hold_period,		\n")
					.append("	gubun_code,			\n")
					.append("	B.code_name		\n")
					.append("FROM	vtbm_doc_base A		\n")
					.append("INNER JOIN v_doc_gubun B	\n")
					.append("ON  A.gubun_code = B.code_value\n")
					.append("	AND A.member_key = B.member_key\n")
					.append("WHERE A.gubun_code LIKE '" + c_paramArray[0][0] + "%' \n") //member_key_select, update, delete
					.append("	AND A.document_no LIKE '" + c_paramArray[0][1] + "%' \n")
					.append("	AND A.member_key = '" + c_paramArray[0][2] + "' \n")
					.toString();  

			resultString = super.excuteQueryString(con, sql.toString());
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M909S130100E194()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M909S130100E194()","==== finally ===="+ e.getMessage());
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


	public int E204(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			System.out.println("JSONObject jArray rcvData="+ jArray.toString());
			
			// Ŭ���̾�Ʈ�� ���� ���� �Ķ���͸� �Ű� ��´�.
//			String rcvData = (String)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			// Ŭ���̾�Ʈ�� ���� ���� �Ķ���͸� �ɰ�� �迭�� ��´�.
			// rcvData = [���浵]
//			String[][] c_paramArray = CommonFunction.getConvString2DoubleArray(rcvData);
			String sql = new StringBuilder()
					.append("SELECT\n")
					.append("	document_no,		\n")
					.append("	revision_no,		\n")
					.append("	document_name,		\n")
					.append("	security_doc_yn,	\n")
					.append("	hold_period,		\n")
					.append("	gubun_code,			\n")
					.append("	B.code_name,		\n")
					.append("	start_date,			\n")
					.append("	duration_date,		\n")
					.append("	create_user_id,		\n")
					.append("	create_date,		\n")
					.append("	modify_user_id,		\n")
					.append("	modify_reason,		\n")
					.append("	modify_date			\n")
					.append("FROM	tbm_doc_base A		\n")
					.append("INNER JOIN v_doc_gubun B	\n")
					.append("ON  A.gubun_code = B.code_value\n")
					.append("	AND A.member_key = B.member_key\n")
					.append("WHERE document_no like '%" 	+ jArray.get("DOC_NO") + "%'	\n")
					.append("	AND revision_no = '" 	+ jArray.get("REVISION_NO") + "'	\n")
					.append(" 	AND A.member_key = '" + jArray.get("member_key") + "' \n") //member_key_select, update, delete
					.toString();  

			resultString = super.excuteQueryString(con, sql.toString());
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M909S130100E204()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M909S130100E204()","==== finally ===="+ e.getMessage());
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
	
	public int E010(InoutParameter ioParam){  //2020.12.02 �ӽ� �߰�. (�Ź���)
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			System.out.println("JSONObject jArray rcvData="+ jArray.toString());
			
			// Ŭ���̾�Ʈ�� ���� ���� �Ķ���͸� �Ű� ��´�.
//			String rcvData = (String)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			// Ŭ���̾�Ʈ�� ���� ���� �Ķ���͸� �ɰ�� �迭�� ��´�.
//			String[][] c_paramArray = CommonFunction.getConvString2DoubleArray(rcvData);
			
			// ���� ���� �������� ���� �����������ڸ� �̹��� �������ڿ��� �Ϸ縦 �� ��¥�� �����Ѵ�.
			String sqlPre = new StringBuilder()
					.append("UPDATE tbm_doc_base SET	\n")
					.append(" duration_date = to_char(TO_DATE('"+ jArray.get("StartDate") + "', 'YYYY-MM-DD')-1 , 'YYYY-MM-DD')	\n")
					.append(" 	,member_key = 	'" + jArray.get("member_key") + "'		\n")
					.append("WHERE document_no = '" + jArray.get("DocCode") + "'\n")
					// 13��°�� ������ �������ڵ尡 ���´�.
					.append("	AND revision_no = '" + jArray.get("RevisionNo_Target") + "'\n")
					.append(" 	AND member_key = '" + jArray.get("member_key") + "' \n") //member_key_select, update, delete
					.toString();
			
			
			resultInt = super.excuteUpdate(con, sqlPre.toString());
			if (resultInt < 0) {
				con.rollback();
				ioParam.setMessage(MessageDefine.M_UPDATE_FAILED);
				return resultInt;
			} else {
				ioParam.setMessage(resultInt + "�� " + MessageDefine.M_UPDATE_RESULT);
			}
			
			sql = new StringBuffer();
					sql.append("INSERT INTO tbm_doc_base ( "
							+ "document_no, "
							+ "revision_no, "
							+ "document_name, "
							+ "security_doc_yn, "
							+ "hold_period, "
							+ "gubun_code, "
							+ "start_date, "
							+ "duration_date, "
							+ "create_user_id, "
							+ "create_date, "
							+ "modify_user_id, "
							+ "modify_reason, "
							+ "modify_date,"
							+ "member_key \n");
					sql.append(") values ('"	+ jArray.get("DocCode") + "' \n");		//document_no
					sql.append(" 		,'" 	+ jArray.get("RevisionNo") + "' \n"); 	//revision_no
					sql.append(" 		,'" 	+ jArray.get("DocName") + "' \n"); 		//document_name
					sql.append(" 		,'" 	+ jArray.get("Secret") + "' \n");		//security_doc_yn
					sql.append(" 		,'" 	+ jArray.get("HoldYear") + "' \n"); 		//hold_period
					sql.append(" 		,'" 	+ jArray.get("DocGubunCode") + "' \n"); 	//gubun_code
					sql.append(" 		,'" 	+ jArray.get("StartDate") + "' \n"); 	//start_date
					sql.append(" 		,'9999-12-31' \n"); 								//duration_date
					sql.append(" 		,'" 	+ jArray.get("user_id") + "' \n"); 		//create_user_id
					sql.append(" 		,SYSDATETIME					  \n"); 			//create_date
					sql.append(" 		,'" 	+ jArray.get("user_id") + "' \n"); 		//modify_user_id
					sql.append(" 		,'����' \n"); 										//modify_reason
					sql.append(" 		,SYSDATETIME \n");								//modify_date
					sql.append(" 		,'" + jArray.get("member_key") + "' \n"); //member_key_values
					sql.append(") \n");
					
					
					
				resultInt = super.excuteUpdate(con, sql.toString());
				if (resultInt < 0) {
					con.rollback();
					ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
					return resultInt;
				} else {
					ioParam.setMessage(resultInt + "�� " + MessageDefine.M_INSERT_RESULT);
				}
				con.commit();
			
			
		} catch(Exception e) {
			LoggingWriter.setLogError("M909S080100E010()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M909S080100E010()","==== finally ===="+ e.getMessage());
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
}