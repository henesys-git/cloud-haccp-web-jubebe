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
import mes.frame.common.QueueProcessing;
import mes.frame.database.JDBCConnectionPool;
import mes.frame.database.SqlAdapter;
import mes.frame.serviceinterface.InoutParameter;
import mes.frame.serviceinterface.LoggingWriter;
import mes.frame.util.CommonFunction;


/**
 * ���� : �̺�ƮID�� �޼ҵ� ����
 */
public  class M838S050100 extends SqlAdapter{
	Connection con = null;
	PreparedStatement pstmt = null;
	String resultString = "";
	int resultInt = -1;
	QueueProcessing Queue = new QueueProcessing();
	StringBuffer sql = new StringBuffer();
	
	String[][] v_paramArray = new String[0][0]; 
	Class[] optClass = null;
	Object[] optObj = null;
	Object obj = null;
	
	public M838S050100(){
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
			
			Method method = M838S050100.class.getMethod(event,optClass);
			LoggingWriter.setLogDebug(M838S050100.class.getName(),"==== " + event + " EventMethod Create Success ====");

			obj = method.invoke(M838S050100.class.newInstance(),optObj);
			doExcute_result = CommonFunction.getInt(obj.toString());
			
	    } catch (Exception ex) {
	    	doExcute_result = EventDefine.E_DOEXCUTE_INIT;
			ioParam.setMessage(MessageDefine.M_NO_EVENTID);
			LoggingWriter.setLogError(M838S050100.class.getName(),"==== EventID Not define : EVENT ID [ " + ioParam.getEventID() + "]");
	    } finally {
	    	obj = null;
			optClass = null;
			optObj = null;
	    }
	    long endTime = System.currentTimeMillis();
		long runningTime = endTime - startTime;
		LoggingWriter.setLogAll(M838S050100.class.getName(),"==== Query [����ð�  : " + runningTime + " ms]");
		
		return doExcute_result;
	}
	
	// S838S050100.jsp
	public int E104(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			System.out.println("JSONObject jArray rcvData="+ jArray.toString());
    		
			String sql = new StringBuilder()
					.append("SELECT DISTINCT\n")
					.append("	A.check_duration,\n")
					.append("	A.check_gubun,\n")
					.append("	E.code_name,\n")
					.append("	A.writor_main,\n")
					.append("	U1.user_nm\n")
					.append("FROM\n")
					.append("	haccp_hygine_check_result A\n")
					
					.append("INNER JOIN v_checklist_gubun E\n")
					.append("	ON A.check_gubun = E.code_value\n")
					.append("	AND A.member_key = E.member_key\n")
					.append("INNER JOIN tbm_users U1\n")
					.append("	ON A.writor_main=U1.user_id\n")
					.append("	AND A.writor_main_rev=U1.revision_no\n")
					.append("	AND A.member_key=U1.member_key\n")
					
					.append("WHERE check_date \n")
					.append("BETWEEN '" + jArray.get("fromdate") + "' 	\n")
					.append("	 AND '" + jArray.get("todate") + "'	\n")
					.append(" 	AND A.member_key = '" + jArray.get("member_key") + "' \n") //member_key_select, update, delete
			        
//					.append("GROUP BY A.check_duration\n")
					
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
			LoggingWriter.setLogError("M838S050100E104()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M838S050100E104()","==== finally ===="+ e.getMessage());
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
	
	// S838S050110.jsp
	
	
	
	
	public int E114(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			System.out.println("JSONObject jArray rcvData="+ jArray.toString());
    		
			String sql = new StringBuilder()
					.append("SELECT DISTINCT\n")
					.append("	A.check_duration,\n")
					.append("	A.check_date,\n")
					.append("	A.check_time,\n")
					.append("	A.check_gubun,\n")
					.append("	E.code_name,\n")
					.append("	A.write_date,\n")
					.append("	A.writor_main,\n")
					.append("	A.write_approval,\n")
					.append("	A.incong_note,\n")
					.append("	A.improve_note\n")
					.append("FROM\n")
					.append("	haccp_hygine_check_result A\n")
					
					.append("INNER JOIN v_checklist_gubun E\n")
					.append("	ON A.check_gubun = E.code_value\n")
					.append("	AND A.member_key = E.member_key\n")
					
					.append("WHERE check_duration = '" + jArray.get("check_duration") + "'\n")
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
			LoggingWriter.setLogError("M838S050100E114()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M838S050100E114()","==== finally ===="+ e.getMessage());
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
	
	// S838S050120.jsp
	public int E124(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			System.out.println("JSONObject jArray rcvData="+ jArray.toString());
    		
			String sql = new StringBuilder()
					.append("SELECT\n")
					.append("	check_duration,\n")
					.append("	check_date,\n")
					.append("	check_time,\n")
					.append("	check_gubun,\n")
					.append("	check_gubun_mid,\n")
					.append("	M.code_name,\n")
					.append("	check_gubun_sm,\n")
					.append("	S.code_name,\n")
					.append("	checklist_cd,\n")
					.append("	cheklist_cd_rev,\n")
					.append("	checklist_seq,\n")
					.append("	item_cd,\n")
					.append("	item_seq,\n")
					.append("	item_cd_rev,\n")
					.append("	check_note,\n")
					.append("	check_value,\n")
					.append("	write_date,\n")
					.append("	writor_main,\n")
					.append("	write_approval,\n")
					.append("	incong_note,\n")
					.append("	improve_note,\n")
					.append("	standard_guide,\n")
					.append("	standard_value\n")
					.append("FROM\n")
					.append("	haccp_hygine_check_result A\n")
					.append("INNER JOIN v_checklist_gubun_mid M\n")
					.append("	ON A.check_gubun = M.code_cd\n")
					.append("	AND A.check_gubun_mid = M.code_value\n")
					.append("	AND A.member_key = M.member_key\n")
					.append("INNER JOIN v_checklist_gubun_sm S\n")
					.append("	ON A.check_gubun = S.code_cd_big\n")
					.append("	AND A.check_gubun_mid = S.code_cd\n")
					.append("   AND A.check_gubun_sm = S.code_value\n")
					.append("   AND A.member_key = S.member_key\n")
					.append("WHERE check_duration='" + jArray.get("check_duration") + "'\n")
					.append("	AND check_date='" 	 + jArray.get("check_date") + "'\n")
					.append("	AND check_time='" 	 + jArray.get("check_time") + "'\n")
					.append(" 	AND A.member_key = '" + jArray.get("member_key") + "' \n") //member_key_select, update, delete
					.append("ORDER BY A.checklist_cd\n") // order by �����ָ� Ÿ�Ӿƿ� ��
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
			LoggingWriter.setLogError("M838S050100E124()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M838S050100E124()","==== finally ===="+ e.getMessage());
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
	
	// T838S050100.jsp ���ȭ��(Tablet)
	public int E134(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			System.out.println("JSONObject jArray rcvData="+ jArray.toString());
    		
			String sql = new StringBuilder()
					.append("select\n")
					.append("	A.check_gubun,\n")
					.append("	E.code_name,\n")
					.append("	A.checklist_cd,\n")
					.append("	A.revision_no,\n")
					.append("	A.checklist_seq,\n")
					.append("	A.check_note,\n")
					.append("	A.standard_guide,\n")
					.append("	A.standard_value,\n")
					.append("	A.double_check_yn,\n")
					.append("	A.item_cd,\n")
					.append("	A.item_seq,\n")
					.append("	A.item_cd_rev,\n")
					.append("	B.item_type,\n")
					.append("	B.item_bigo,\n")
					.append("	B.item_desc,\n")
					.append("	A.start_date,\n")
					.append("	A.duration_date,\n")
					.append("	A.check_gubun_mid,\n")
					.append("	F.code_name,\n")
					.append("	A.check_gubun_sm,\n")
					.append("	G.code_name\n")
					.append("FROM vtbm_checklist A\n")
					.append("INNER JOIN tbm_check_item B\n")
					.append("	ON A.item_cd = B.item_cd\n")
					.append("	AND A.item_seq = B.item_seq\n")
					.append("	AND A.item_cd_rev = B.revision_no\n")
					.append("	AND A.member_key = B.member_key\n")
					.append("INNER JOIN v_checklist_gubun E\n")
					.append("	ON A.check_gubun = E.code_value\n")
					.append("	AND A.member_key = E.member_key\n")
					.append("INNER JOIN v_checklist_gubun_mid F\n")
					.append("	ON A.check_gubun = F.code_cd\n")
					.append("	AND A.check_gubun_mid = F.code_value\n")
					.append("	AND A.member_key = F.member_key\n")
					.append("INNER JOIN v_checklist_gubun_sm G\n")
					.append("	ON A.check_gubun = G.code_cd_big\n")
					.append("	AND A.check_gubun_mid = G.code_cd\n")
					.append("	AND A.check_gubun_sm = G.code_value\n")
					.append("	AND A.member_key = G.member_key\n")
					.append("where A.check_gubun like '" + jArray.get("check_gubun") + "%'\n")
					.append(" 	AND A.member_key = '" + jArray.get("member_key") + "' \n") //member_key_select, update, delete
					.append("ORDER BY A.checklist_cd\n") // order by �����ָ� Ÿ�Ӿƿ� ��
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
			LoggingWriter.setLogError("M838S050100E134()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M838S050100E134()","==== finally ===="+ e.getMessage());
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
	
	// S838S050100_canvas.jsp
	public int E144(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			System.out.println("JSONObject jArray rcvData="+ jArray.toString());
    		
			String sql = new StringBuilder()
					.append("SELECT\n")
					.append("	check_duration,\n")
					.append("	check_date,\n")
					.append("	check_time,\n")
					.append("	check_gubun,\n")
					.append("	M.code_name,\n") // .append("	check_gubun_mid,\n")
					.append("	S.code_name,\n") // .append("	check_gubun_sm,\n")
					.append("	checklist_cd,\n")
					.append("	cheklist_cd_rev,\n")
					.append("	checklist_seq,\n")
					.append("	item_cd,\n")
					.append("	item_seq,\n")
					.append("	item_cd_rev,\n")
					.append("	check_note,\n")
					.append("	check_value,\n")
					.append("	write_date,\n")
					.append("	U1.user_nm,\n")
					.append("	write_approval,\n")
					.append("	incong_note,\n")
					.append("	improve_note,\n")
					.append("	standard_guide,\n")
					.append("	standard_value\n")
					.append("FROM\n")
					.append("	haccp_hygine_check_result A \n")
					.append("INNER JOIN v_checklist_gubun_mid M\n")
					.append("	ON A.check_gubun = M.code_cd\n")
					.append("	AND A.check_gubun_mid = M.code_value\n")
					.append("	AND A.member_key = M.member_key\n")
					.append("INNER JOIN v_checklist_gubun_sm S\n")
					.append("	ON A.check_gubun = S.code_cd_big\n")
					.append("	AND A.check_gubun_mid = S.code_cd\n")
					.append("   AND A.check_gubun_sm = S.code_value\n")
					.append("   AND A.member_key = S.member_key\n")
					.append("INNER JOIN tbm_users U1\n")
					.append("	ON A.writor_main=U1.user_id\n")
					.append("	AND A.writor_main_rev=U1.revision_no\n")
					.append("	AND A.member_key=U1.member_key\n")
					.append("WHERE check_duration='" + jArray.get("check_duration") + "'\n")
					.append(" 	AND A.member_key = '" + jArray.get("member_key") + "' \n") //member_key_select, update, delete
					.append("ORDER BY check_date, check_time, checklist_cd, checklist_seq  \n")
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
			LoggingWriter.setLogError("M838S050100E144()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M838S050100E144()","==== finally ===="+ e.getMessage());
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

	// CommonView/UserListView.jsp
	public int E154(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			System.out.println("JSONObject jArray rcvData="+ jArray.toString());
    		
			String sql = new StringBuilder()
					.append("SELECT				\n")
					.append("	user_id,		\n")
					.append("	MAX(revision_no),\n")
					.append("	user_nm,		\n")
					.append("	group_cd,		\n")
					.append("	dept_cd,		\n")
//					.append("	user_pwd,		\n")
//					.append("	user_pwd_setting,\n")
					.append("	jikwi,			\n")
					.append("	LOCATION,		\n")
					.append("	hpno,			\n")
					.append("	email,			\n")
					.append("	hour_pay,		\n")
					.append("	delyn,			\n")
					.append("	start_date,		\n")
					.append("	create_user_id,	\n")
					.append("	create_date,	\n")
					.append("	modify_user_id,	\n")
					.append("	modify_date,	\n")
					.append("	modify_reason,	\n")
					.append("	duration_date	\n")
					.append("FROM				\n")
					.append("	tbm_users		\n")
					.append("WHERE delyn = 'N' 	\n")
					.append(" 	AND member_key = '" + jArray.get("member_key") + "' \n") //member_key_select, update, delete
					.append("GROUP BY user_id	\n")
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
			LoggingWriter.setLogError("M838S050100E154()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M838S050100E154()","==== finally ===="+ e.getMessage());
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
		
	
	// T838S050100.jsp ���ȭ��(Tablet)
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
    		JSONArray jjArray = (JSONArray) jArray.get("param");
			

			
			for(int i=0; i<jjArray.size(); i++) {	
				JSONObject jjjArray = (JSONObject)jjArray.get(i); // i��° �����͹���
				
				String sql = new StringBuilder()
					.append("INSERT INTO \n")
					.append("	haccp_hygine_check_result ( \n")
					.append("		check_duration, \n")
					.append("		check_date, \n")
					.append("		check_time, \n")
					.append("		check_gubun, \n")
					.append("		check_gubun_mid, \n")
					.append("		check_gubun_sm, \n")
					.append("		checklist_cd, \n")
					.append("		cheklist_cd_rev, \n")
					.append("		checklist_seq, \n")
					.append("		item_cd, \n")
					.append("		item_seq, \n")
					.append("		item_cd_rev, \n")
					.append("		check_note, \n")
					.append("		check_value, \n")
					.append("		write_date, \n")
					.append("		writor_main, \n")
					.append("		writor_main_rev, \n")
					.append("		write_approval,\n")
					.append("		incong_note, \n")
					.append("		improve_note, \n")
					.append("		standard_guide, \n")
					.append("		standard_value \n")
					.append(" 		,member_key	\n") // member_key_insert
					.append("	) VALUES ( \n")
 					.append(" 		'"	+ jjjArray.get("check_duration") + "',	\n")
 					.append(" 		'"	+ jjjArray.get("check_date") + "',	\n")
 					.append(" 		'"	+ jjjArray.get("check_time") + "',	\n")
 					.append(" 		'"	+ jjjArray.get("check_gubun") + "',	\n")
 					.append(" 		'"	+ jjjArray.get("check_gubun_mid") + "',	\n")
 					.append(" 		'"	+ jjjArray.get("check_gubun_sm") + "',	\n")
 					.append(" 		'"	+ jjjArray.get("checklist_cd") + "',	\n")
 					.append(" 		'"	+ jjjArray.get("cheklist_cd_rev") + "',	\n")
 					.append(" 		'"	+ jjjArray.get("checklist_seq") + "',	\n")
 					.append(" 		'"	+ jjjArray.get("item_cd") + "',	\n")
 					.append(" 		'"	+ jjjArray.get("item_seq") + "',	\n")
 					.append(" 		'"	+ jjjArray.get("item_cd_rev") + "',	\n")
 					.append(" 		'"	+ jjjArray.get("check_note") + "',	\n")
 					.append(" 		'"	+ jjjArray.get("check_value") + "',	\n")
 					.append(" 		'"	+ jjjArray.get("write_date") + "',	\n")
 					.append(" 		'"	+ jjjArray.get("writor_main") + "',	\n")
 					.append(" 		'"	+ jjjArray.get("writor_main_rev") + "',	\n")
 					.append(" 		'"	+ jjjArray.get("write_approval") + "',	\n")
 					.append(" 		'"	+ jjjArray.get("incong_note") + "',	\n")
 					.append(" 		'"	+ jjjArray.get("improve_note") + "',	\n")
 					.append(" 		'"	+ jjjArray.get("standard_guide") + "',	\n")
 					.append(" 		'"	+ jjjArray.get("standard_value") + "'	\n")
 					.append(" 		,'" + jjjArray.get("member_key") + "' \n") //member_key_values
 					.append("	) \n")
					.toString();
			
				resultInt = super.excuteUpdate(con, sql.toString());
		    	if(resultInt < 0){  //
					ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
					con.rollback();
					return EventDefine.E_DOEXCUTE_ERROR ;
				}
			}
			con.commit();
		} catch(Exception e) {
			e.getStackTrace();
			LoggingWriter.setLogError("M838S050100E101()","==== SQL ERROR ===="+ e.getMessage());
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