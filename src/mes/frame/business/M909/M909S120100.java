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


public class M909S120100 extends SqlAdapter{
	Connection con = null;
	PreparedStatement pstmt = null;
	String resultString = "";
	int resultInt = -1;
	StringBuffer sql = new StringBuffer();
	
	String[][] v_paramArray = new String[0][0]; 
	Class[] optClass = null;
	Object[] optObj = null;
	Object obj = null;
	
	public M909S120100(){
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

			Method method = M909S120100.class.getMethod(event,optClass);
			LoggingWriter.setLogDebug(M909S120100.class.getName(),"==== " + event + " EventMethod Create Success ====");

			obj = method.invoke(M909S120100.class.newInstance(),optObj);
			doExcute_result = CommonFunction.getInt(obj.toString());
			
	    } catch (Exception ex) {
	    	doExcute_result = EventDefine.E_DOEXCUTE_INIT;
			ioParam.setMessage(MessageDefine.M_NO_EVENTID);
			LoggingWriter.setLogError(M909S120100.class.getName(),"==== EventID Not define : EVENT ID [ " + ioParam.getEventID() + "]");
	    } finally {
	    	obj = null;
			optClass = null;
			optObj = null;
	    }
	    long endTime = System.currentTimeMillis();
		long runningTime = endTime - startTime;
		LoggingWriter.setLogAll(M909S120100.class.getName(),"==== Query [����ð�  : " + runningTime + " ms]");
		
		return doExcute_result;
	}
	

	public int E101(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			System.out.println("JSONObject jArray rcvData="+ jArray.toString());

			String sql = new StringBuilder()
				.append("INSERT INTO\n")
				.append("	tbm_process (\n")
				.append("		process_gubun,\n")
				.append("		proc_code_gb_big,\n")
				.append("		proc_code_gb_mid,\n")
				.append("		proc_cd,\n")
				.append("		process_nm,\n")
				.append("		work_order_index,\n")
				.append("		process_seq,\n")
				.append("		product_process_yn,\n")
				.append("		packing_process_yn,\n")
				.append("		bigo,\n")
				.append("		start_date,\n")
				.append("		create_date,\n")
				.append("		create_user_id\n")
				.append(" 		,member_key						\n") // member_key_insert
				.append("	)\n")

				.append(" values ('"	+ jArray.get("process_gubun") + "' \n")		//process_gubun
				.append(" 		,'" 	+ jArray.get("proc_code_gb_big") + "' \n")	//proc_code_gb_big
				.append(" 		,'" 	+ jArray.get("proc_code_gb_mid") + "' \n") 	//proc_code_gb_mid
				.append(" 		,'" 	+ jArray.get("proc_cd") + "' \n") 			//proc_cd
				.append(" 		,'" 	+ jArray.get("process_nm") + "' \n") 		//process_nm
				.append(" 		,SUBSTR(proc_cd,-2) \n") 							//work_order_index
				.append(" 		,SUBSTR(proc_cd,-2) \n") 							//process_seq
				.append(" 		,'" 	+ jArray.get("product_process_yn") + "' \n") //product_process_yn
				.append(" 		,'" 	+ jArray.get("packing_process_yn") + "' \n") //packing_process_yn
				.append(" 		,'" 	+ jArray.get("bigo") + "' \n") 				//bigo
				.append(" 		,'" 	+ jArray.get("start_date") + "' \n") 		//start_date
				.append(" 		,SYSDATETIME					  \n") 				//create_date
				.append(" 		,'" 	+ jArray.get("user_id") + "' \n") 			//create_user_id
				.append(" 		,'" + jArray.get("member_key") + "' \n") //member_key_values
				.append("	)\n")
				.toString();
			
				resultInt = super.excuteUpdate(con, sql.toString());
				if (resultInt < 0) {
					ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
				} else {
					ioParam.setMessage(resultInt + "�� " + MessageDefine.M_INSERT_RESULT);
				}
				
		} catch(Exception e) {
			LoggingWriter.setLogError("M909S120100E101()","==== SQL ERROR ===="+ e.getMessage() + "\n" + sql.toString());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M909S120100E101()","==== finally ===="+ e.getMessage());
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
			
			con.setAutoCommit(false);
			
			// ���� ���� �������� �����������ڸ� ���ο� ����������ڿ��� �Ϸ縦 �� ��¥�� �����Ѵ�.
			// ���� ���ο� �������� ����������� = ���� �������� ����������� ��� ���� �������� �����������ڸ� ����������ڿ� ���� ��¥�� �����Ѵ�.
			String sqlPre = new StringBuilder()
					.append("UPDATE tbm_process SET	\n")
					.append("	duration_date =																							\n")
					.append("		CASE																								\n")
					.append("			WHEN start_date = '" + jArray.get("after_start_date") + "' THEN start_date						\n")
					.append("			ELSE TO_CHAR(TO_DATE( '" + jArray.get("after_start_date") + "','YYYY-MM-DD')-1, 'YYYY-MM-DD')	\n")
					.append("		END																									\n")
					.append("WHERE proc_cd = '" + jArray.get("proc_cd") + "'\n")
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
					.append("INSERT INTO\n")
					.append("	tbm_process (\n")
					.append("		process_gubun,\n")
					.append("		proc_code_gb_big,\n")
					.append("		proc_code_gb_mid,\n")
					.append("		proc_cd,\n")
					.append("		process_nm,\n")
					.append("		work_order_index,\n")
					.append("		process_seq,\n")
					.append("		product_process_yn,\n")
					.append("		packing_process_yn,\n")
					.append("		bigo,\n")
					.append("		start_date,\n")
					.append("		create_date,\n")
					.append("		create_user_id,\n")
					.append("		modify_user_id,\n")
					.append("		modify_reason,\n")
					.append("		modify_date, \n")
					.append("		revision_no, \n")
					.append(" 		member_key	\n") // member_key_insert					
					.append("	)\n")

				.append(" values ('"	+ jArray.get("process_gubun") + "' \n")		//process_gubun
				.append(" 		,'" 	+ jArray.get("proc_code_gb_big") + "' \n")	//proc_code_gb_big
				.append(" 		,'" 	+ jArray.get("proc_code_gb_mid") + "' \n") 	//proc_code_gb_mid
				.append(" 		,'" 	+ jArray.get("proc_cd") + "' \n") 			//proc_cd
				.append(" 		,'" 	+ jArray.get("process_nm") + "' \n") 		//process_nm
				.append(" 		,'" 	+ jArray.get("work_order_index") + "' \n") 	//work_order_index
				.append(" 		,'" 	+ jArray.get("process_seq") + "' \n") 		//process_seq
				.append(" 		,'" 	+ jArray.get("product_process_yn") + "' \n") //product_process_yn
				.append(" 		,'" 	+ jArray.get("packing_process_yn") + "' \n") //packing_process_yn
				.append(" 		,'" 	+ jArray.get("bigo") + "' \n") 				//bigo
				.append(" 		,'" 	+ jArray.get("after_start_date") + "' \n") 		//start_date
				.append(" 		,SYSDATETIME					  \n") 				//create_date
				.append(" 		,'" 	+ jArray.get("user_id") + "' \n") 			//create_user_id
				.append(" 		,'" 	+ jArray.get("user_id") + "' \n") 		//modify_user_id
				.append(" 		,'����' \n") 									//modify_reason
				.append(" 		,SYSDATETIME	\n")								//modify_date
				.append(" 		,'" 	+ jArray.get("revision_no") + "' \n")
				.append(" 		,'" + jArray.get("member_key") + "' \n") //member_key_values
				.append("	)\n")
				.toString();
			
//			
//			String sql = new StringBuilder()
//					.append("INSERT INTO tbm_process ( "
//							+ "proc_cd, "
//							+ "revision_no, "
//							+ "process_nm, "
//							+ "work_order_index, "
//							+ "process_seq, "
//							+ "bigo, "
//							+ "start_date, "
//							+ "duration_date, "
//							+ "create_user_id, "
//							+ "create_date, "
//							+ "modify_user_id, "
//							+ "modify_reason, "
//							+ "modify_date, "
//							+ "process_gubun ) \n")
//					.append(" values ('"	+ jArray.get("ProcCd") + "' \n")		//proc_cd
//					.append(" 		,'" 	+ jArray.get("RevisionNo") + "' \n") 	//revision_no
//					.append(" 		,'" 	+ jArray.get("ProcName") + "' \n") 		//process_nm
//					.append(" 		,'" 	+ jArray.get("WorkOrderIndex") + "' \n") 	//work_order_index
//					.append(" 		,'" 	+ jArray.get("ProcSeq") + "' \n") 		//process_seq
//					.append(" 		,'" 	+ jArray.get("Bigo") + "' \n") 			//bigo
//					.append(" 		,'" 	+ jArray.get("StartDate") + "' \n") 	//start_date
//					.append(" 		,'9999-12-31' \n") 								//duration_date
//					.append(" 		,'" 	+ jArray.get("user_id") + "' \n") 		//create_user_id
//					.append(" 		,SYSDATETIME					  \n") 			//create_date
//					.append(" 		,'" 	+ jArray.get("user_id") + "' \n") 		//modify_user_id
//					.append(" 		,'����' \n") 									//modify_reason
//					.append(" 		,SYSDATETIME \n")								//modify_date
//					.append(" 		,'" 	+ jArray.get("ProcessGubun") + "' \n") 	//process_gubun
//					.append(" 		) \n")		
//					.toString();

			// System.out.println(sql.toString());
				resultInt = super.excuteUpdate(con, sql.toString());
				if (resultInt < 0) {
					con.rollback();
					ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
				} else {
					con.commit();
					ioParam.setMessage(resultInt + "�� " + MessageDefine.M_INSERT_RESULT);
				}
				
		} catch(Exception e) {
			LoggingWriter.setLogError("M909S120100E102()","==== SQL ERROR ===="+ e.getMessage() + "\n" + sql.toString());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M909S120100E102()","==== finally ===="+ e.getMessage());
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

			con.setAutoCommit(false);
			
			// ������ ������ ���� ������
			String sql_update = new StringBuilder()
				.append("UPDATE tbm_process SET											\n")
				.append("	delyn = 'Y',												\n")
				.append("	duration_date = TO_CHAR(SYSDATE,'YYYY-MM-DD')				\n")
				.append("WHERE proc_cd = '" + jArray.get("proc_cd") + "'				\n")
				.append("AND member_key = '" + jArray.get("member_key") + "'			\n")
				//.append("AND revision_no = '" + jArray.get("RevisionNo_Target") + "'	\n")
				.toString();
			
			System.out.println(sql_update.toString());
					
				resultInt = super.excuteUpdate(con, sql_update.toString());
				if (resultInt < 0) {
					con.rollback();
					ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
				} else {
					con.commit();
					ioParam.setMessage(resultInt + "�� " + MessageDefine.M_INSERT_RESULT);
				}				
		} catch(Exception e) {
			LoggingWriter.setLogError("M909S120100E103()","==== SQL ERROR ===="+ e.getMessage() + "\n" + sql.toString());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M909S120100E103()","==== finally ===="+ e.getMessage());
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
			
			String sql = new StringBuilder()
					.append("SELECT																		\n")
					.append("	DISTINCT 																\n")
					.append("		process_gubun,														\n")
					.append("		B.code_name,														\n")
					.append("		proc_code_gb_big,													\n")
					.append("		C.code_name,														\n")
					.append("       proc_cd,															\n")
					.append("       revision_no,														\n")
					.append("       process_nm,															\n")
					.append("       work_order_index,													\n")
					.append("       process_seq,														\n")
					.append("       product_process_yn,													\n")
					.append("       packing_process_yn,													\n")
					.append("       bigo,																\n")
					.append("       start_date,															\n")
					.append("       duration_date 														\n")
					.append("FROM tbm_process A															\n")
					.append("			INNER JOIN v_process_gubun  B									\n")
					.append("				ON A.process_gubun = B.code_value							\n")
					.append("				AND A.member_key = B.member_key								\n")
					.append("			INNER JOIN v_process_gubun_big C								\n")
					.append("				ON A.proc_code_gb_big = C.code_value						\n")
					.append("				AND A.process_gubun = C.code_cd								\n")
					.append("				AND A.member_key = C.member_key								\n")
					.append("WHERE process_gubun like '%" + jArray.get("PROCESS_GUBUN") + "%'			\n")
					.append("	AND proc_code_gb_big like '%" + jArray.get("PROCESS_GUBUN_BIG") + "%'	\n")
					.append("	AND delyn = 'N'															\n")
					.append(" 	AND A.member_key = '" + jArray.get("member_key") + "' 					\n")
					.append("ORDER BY proc_cd ASC, revision_no DESC										\n")
					.toString();

			resultString = super.excuteQueryString(con, sql.toString());
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M909S120100E104()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M909S120100E104()","==== finally ===="+ e.getMessage());
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
	
	public int E105(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			System.out.println("JSONObject jArray rcvData="+ jArray.toString());
			
			String sql = new StringBuilder()
					.append("SELECT																		\n")
					.append("	DISTINCT 																\n")
					.append("        process_gubun,														\n")
					.append("        B.code_name,														\n")
					.append("		 proc_code_gb_big,													\n")
					.append("		 C.code_name,														\n")
					.append("        proc_cd,															\n")
					.append("        revision_no,														\n")
					.append("        process_nm,														\n")
					.append("        work_order_index,													\n")
					.append("        process_seq,														\n")
					.append("        product_process_yn,												\n")
					.append("        packing_process_yn,												\n")
					.append("        bigo,																\n")
					.append("        start_date,														\n")
					.append("        duration_date 														\n")
					.append("FROM tbm_process A															\n")
					.append("	INNER JOIN v_process_gubun B											\n")
					.append("		ON A.process_gubun = B.code_value									\n")
					.append("		AND A.member_key = B.member_key										\n")
					.append("	INNER JOIN v_process_gubun_big C										\n")
					.append("		ON A.proc_code_gb_big 	= C.code_value								\n")
					.append("		AND A.process_gubun 	= C.code_cd									\n")
					.append("		AND A.member_key = C.member_key										\n")
					.append("WHERE process_gubun like '%" + jArray.get("PROCESS_GUBUN") + "%'			\n")
					.append("	AND proc_code_gb_big like '%" + jArray.get("PROCESS_GUBUN_BIG") + "%'	\n")
					.append("	AND A.start_date != A.duration_date										\n")
					.append("	AND TO_CHAR(SYSDATE,'YYYY-MM-DD') BETWEEN  start_date AND duration_date	\n")
					.append("	AND delyn = 'N'															\n")
					.append(" 	AND A.member_key = '" + jArray.get("member_key") + "' 					\n")
					.append("ORDER BY proc_cd ASC, revision_no DESC										\n")
					.toString();

			resultString = super.excuteQueryString(con, sql.toString());
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M909S120100E105()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M909S120100E105()","==== finally ===="+ e.getMessage());
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


	// ProcessView.jsp. 
	public int E194(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			System.out.println("JSONObject jArray rcvData="+ jArray.toString());
			
			String sql = new StringBuilder()
					.append("SELECT\n")
					.append("	process_gubun,\n")
					.append("	process_gubun_rev,\n")
					.append("	proc_code_gb_big,\n")
					.append("	proc_code_gb_mid,\n")
					.append("	proc_cd,\n")
					.append("	revision_no,\n")
					.append("	process_nm,\n")
					.append("	work_order_index,\n")
					.append("	process_seq,\n")
					.append("	bigo,\n")
					.append("	start_date,\n")
					.append("	create_date,\n")
					.append("	create_user_id,\n")
					.append("	modify_date,\n")
					.append("	modify_user_id,\n")
					.append("	duration_date,\n")
					.append("	modify_reason,\n")
					.append("	check_data_type,\n")
					.append("	dept_gubun,\n")
					.append("	delyn,\n")
					.append("	product_process_yn,\n")
					.append("	packing_process_yn\n")
					.append("FROM\n")
					.append("	tbm_process A \n")
					//.append("WHERE A.process_gubun 	= '" + jArray.get("processGubun") + "'	\n")
					.append("WHERE A.member_key		= '" + jArray.get("member_key") + "' \n") //member_key_select, update, delete
					.toString();  

			resultString = super.excuteQueryString(con, sql.toString());
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M909S120100E194()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M909S120100E194()","==== finally ===="+ e.getMessage());
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
					.append("	proc_cd,			\n")
					.append("	revision_no,		\n")
					.append("	process_nm,			\n")
					.append("	work_order_index,	\n")
					.append("	process_seq,		\n")
					.append("	product_process_yn,		\n")
					.append("	packing_process_yn,		\n")
					.append("	bigo,				\n")
					.append("	start_date,			\n")
					.append("	duration_date,		\n")
					.append("	create_user_id,		\n")
					.append("	create_date,		\n")
					.append("	modify_user_id,		\n")
					.append("	modify_reason,		\n")
					.append("	modify_date,		\n")
					.append("	process_gubun		\n")
					.append("FROM	tbm_process		\n")
					.append("WHERE proc_cd = '" 	+ jArray.get("PROC_CD") + "'	\n")
					.append("	AND revision_no = '" 	+ jArray.get("REVISION_NO") + "'	\n")
					.append(" 	AND member_key = '" + jArray.get("member_key") + "' \n") //member_key_select, update, delete
					.append("ORDER BY proc_cd ASC, revision_no DESC	\n")
					.toString();  

			resultString = super.excuteQueryString(con, sql.toString());
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M909S120100E204()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M909S120100E204()","==== finally ===="+ e.getMessage());
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
	

	public int E994(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			
			String sql = new StringBuilder()
					.append("SELECT\n")
					.append("	TO_CHAR(NVL(max(process_seq),0)+1,'00') AS max_process_seq \n")
					.append("FROM\n")
					.append("	tbm_process\n")
					.append("WHERE process_gubun = '" 		+ jArray.get("PROCESS_GUBUN") + "'	\n")
					.append("	AND proc_code_gb_big = '" 	+ jArray.get("PROCESS_GUBUN_BIG") + "'	\n")
					.append(" 	AND member_key = '" + jArray.get("member_key") + "' \n") //member_key_select, update, delete
					.toString();

			resultString = super.excuteQueryString(con, sql.toString());
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M909S120100E994()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M909S120100E994()","==== finally ===="+ e.getMessage());
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