package mes.frame.business.M838;
/*BOM코드*/
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
 * 개요 : 이벤트ID별 메소드 정의
 */
public  class M838S015250 extends SqlAdapter{
	Connection con = null;
	PreparedStatement pstmt = null;
	String resultString = "";
	int resultInt = -1;
	StringBuffer sql = new StringBuffer();
	
	String[][] v_paramArray = new String[0][0]; 
	Class[] optClass = null;
	Object[] optObj = null;
	Object obj = null;
	
	public M838S015250(){
	}
	
	/**
	 * 사용자가 정의해서 파라메터 검증하는 method.
	 * @param	ioParam , p_sql
	 * @return the desired integer.
	 */
	public int custParamCheck(InoutParameter ioParam, StringBuffer p_sql){
		int paramInt = 0;
		return paramInt;
	}
	/**
	 * 입력파라메타가 2차원 구조인경우 파라메터 검증하는 method.
	 * @param	ioParam , p_sql
	 * @return the desired integer.
	 */
	public int paramCheck(InoutParameter ioParam, StringBuffer p_sql){
		v_paramArray = super.getParamCheck(ioParam,p_sql);
		return v_paramArray[0].length;
	}
	/**
	 * 입력파라메타에서 이벤트ID별로 메소드 호출하는 method.
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
			
			Method method = M838S015250.class.getMethod(event,optClass);
			LoggingWriter.setLogDebug(M838S015250.class.getName(),"==== " + event + " EventMethod Create Success ====");

			obj = method.invoke(M838S015250.class.newInstance(),optObj);
			doExcute_result = CommonFunction.getInt(obj.toString());
			
	    } catch (Exception ex) {
	    	doExcute_result = EventDefine.E_DOEXCUTE_INIT;
			ioParam.setMessage(MessageDefine.M_NO_EVENTID);
			LoggingWriter.setLogError(M838S015250.class.getName(),"==== EventID Not define : EVENT ID [ " + ioParam.getEventID() + "]");
	    } finally {
	    	obj = null;
			optClass = null;
			optObj = null;
	    }
	    long endTime = System.currentTimeMillis();
		long runningTime = endTime - startTime;
		LoggingWriter.setLogAll(M838S015250.class.getName(),"==== Query [수행시간  : " + runningTime + " ms]");
		
		return doExcute_result;
	}
	
	// S838S070100.jsp
	public int E104(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			System.out.println("JSONObject jArray rcvData="+ jArray.toString());
    		
			String sql = new StringBuilder()
					.append("SELECT DISTINCT\n")
					.append("		 A.check_date,\n")
					.append("        A.checker,\n")
					.append("        A.check_gubun,\n")
					.append("        E.code_name,\n")
					.append("        A.incong_note,\n")
					.append("        A.improve_note,\n")
					.append("        A.write_date,\n")
					.append("        A.writor,\n")
					.append("        A.writor_rev,\n")
					.append("        U1.user_nm,\n")
					.append("        A.approval,\n")
					.append("        A.approval_rev,\n")
					.append("        A.action_worker,\n")
					.append("        A.confirm_worker\n")
					.append("FROM\n")
					.append("	haccp_ccp_verify_check A\n")
					.append("INNER JOIN v_checklist_gubun E\n")
					.append("	ON A.check_gubun = E.code_value\n")
					.append("	AND A.member_key = E.member_key\n")
					.append("LEFT OUTER JOIN tbm_users U1\n")
					.append("	ON A.writor=U1.user_id\n")
					.append("	AND A.writor_rev=U1.revision_no\n")
					.append("	AND A.member_key=U1.member_key\n")
					.append("WHERE check_date \n")
					.append("		BETWEEN '" + jArray.get("fromdate") + "' 	\n")
					.append("			AND '" + jArray.get("todate") + "'	\n")
					.append("	AND A.check_gubun = '" + jArray.get("check_gubun") + "'\n")
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
			LoggingWriter.setLogError("M838S015250E104()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M838S015250E104()","==== finally ===="+ e.getMessage());
				}
	    	} else {
	    	}
	    }
	    // 결과 전문 구성을 위한 파라미터들을 아이오 파라미터에 저장한다.
		ioParam.setResultString(resultString);
		// 수퍼에서 처리된 칼럼의 갯수를 클라이언트에게 보내기 위해 가져온다.
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
		// 잘 처리되었다는 메시지를 클라이언트에게 보내기 위해 I/O파라미터에 저장한다.
    	ioParam.setMessage(MessageDefine.M_QUERY_OK);
	    return EventDefine.E_QUERY_RESULT;
	}
	
	// S838S070110.jsp
	public int E114(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			System.out.println("JSONObject jArray rcvData="+ jArray.toString());
    		
			String sql = new StringBuilder()
					.append("SELECT\n")
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
					.append("	standard_guide,\n")
					.append("	standard_value,\n")
					.append("	check_value\n")
					.append("FROM\n")
					.append("	haccp_ccp_verify_check A\n")
					.append("LEFT OUTER JOIN v_checklist_gubun_mid M\n")
					.append("	ON A.check_gubun = M.code_cd\n")
					.append("	AND A.check_gubun_mid = M.code_value\n")
					.append("	AND A.member_key = M.member_key\n")
					.append("LEFT OUTER JOIN v_checklist_gubun_sm S\n")
					.append("	ON A.check_gubun = S.code_cd_big\n")
					.append("	AND A.check_gubun_mid = S.code_cd\n")
					.append("   AND A.check_gubun_sm = S.code_value\n")
					.append("   AND A.member_key = S.member_key\n")
					.append("WHERE check_date='" + jArray.get("check_date") + "'\n")
					.append("	AND A.check_gubun = '" + jArray.get("check_gubun") + "'\n")
					.append(" 	AND A.member_key = '" + jArray.get("member_key") + "' \n") //member_key_select, update, delete
					.append("ORDER BY A.checklist_cd\n") // order by 안해주면 타임아웃 됨
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
			LoggingWriter.setLogError("M838S015250E114()","==== SQL ERROR ===="+ e.getMessage());
			
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M838S015250E114()","==== finally ===="+ e.getMessage());
				}
	    	} else {
	    	}
	    }
	    // 결과 전문 구성을 위한 파라미터들을 아이오 파라미터에 저장한다.
		ioParam.setResultString(resultString);
		// 수퍼에서 처리된 칼럼의 갯수를 클라이언트에게 보내기 위해 가져온다.
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
		// 잘 처리되었다는 메시지를 클라이언트에게 보내기 위해 I/O파라미터에 저장한다.
    	ioParam.setMessage(MessageDefine.M_QUERY_OK);
	    return EventDefine.E_QUERY_RESULT;
	}
	
	// T838S070100.jsp 등록화면(Tablet)
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
					.append("FROM tbm_checklist A\n")
					.append("INNER JOIN tbm_check_item B\n")
					.append("	ON A.item_cd = B.item_cd\n")
					.append("	AND A.item_seq = B.item_seq\n")
					.append("	AND A.item_cd_rev = B.revision_no\n")
					.append("	AND A.member_key = B.member_key\n")
					.append("INNER JOIN v_checklist_gubun E\n")
					.append("	ON A.check_gubun = E.code_value\n")
					.append("	AND A.member_key = E.member_key\n")
					.append("LEFT OUTER JOIN v_checklist_gubun_mid F\n")
					.append("	ON A.check_gubun = F.code_cd\n")
					.append("	AND A.check_gubun_mid = F.code_value\n")
					.append("	AND A.member_key = F.member_key\n")
					.append("LEFT OUTER JOIN v_checklist_gubun_sm G\n")
					.append("	ON A.check_gubun = G.code_cd_big\n")
					.append("	AND A.check_gubun_mid = G.code_cd\n")
					.append("	AND A.check_gubun_sm = G.code_value\n")
					.append("	AND A.member_key = G.member_key\n")
					.append("where A.check_gubun = '" + jArray.get("check_gubun") + "'\n")
					.append(" 	AND A.member_key = '" + jArray.get("member_key") + "' \n") //member_key_select, update, delete
					.append("ORDER BY A.checklist_seq\n") // order by 안해주면 타임아웃 됨
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
			LoggingWriter.setLogError("M838S015250E134()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M838S015250E134()","==== finally ===="+ e.getMessage());
				}
	    	} else {
	    	}
	    }
	    // 결과 전문 구성을 위한 파라미터들을 아이오 파라미터에 저장한다.
		ioParam.setResultString(resultString);
		// 수퍼에서 처리된 칼럼의 갯수를 클라이언트에게 보내기 위해 가져온다.
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
		// 잘 처리되었다는 메시지를 클라이언트에게 보내기 위해 I/O파라미터에 저장한다.
    	ioParam.setMessage(MessageDefine.M_QUERY_OK);
	    return EventDefine.E_QUERY_RESULT;
	}
	
	// S838S070100_canvas.jsp
	public int E144(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			System.out.println("JSONObject jArray rcvData="+ jArray.toString());
    		
			String sql = new StringBuilder()
					.append("SELECT\n")
					.append("		 check_date,\n")
					.append("        checker,\n")
					.append("        check_gubun,\n")
					.append("        M.code_name,\n")
					.append("        S.code_name,\n")
					.append("        standard_guide,\n")
					.append("        standard_value,\n")
					.append("        check_note,\n")
					.append("        check_value,\n")
					.append("        U1.user_nm,\n")
					.append("        incong_note,\n")
					.append("        improve_note,\n")
					.append("        write_date,\n")
					.append("        action_worker,\n")
					.append("        confirm_worker\n")
					.append("FROM\n")
					.append("	haccp_ccp_verify_check A\n")
					.append("LEFT OUTER JOIN v_checklist_gubun_mid M\n")
					.append("	ON A.check_gubun = M.code_cd\n")
					.append("	AND A.check_gubun_mid = M.code_value\n")
					.append("	AND A.member_key = M.member_key\n")
					.append("LEFT OUTER JOIN v_checklist_gubun_sm S\n")
					.append("	ON A.check_gubun = S.code_cd_big\n")
					.append("	AND A.check_gubun_mid = S.code_cd\n")
					.append("	AND A.check_gubun_sm = S.code_value\n")
					.append("	AND A.member_key = S.member_key\n")
					.append("INNER JOIN tbm_users U1\n")
					.append("	ON A.writor=U1.user_id\n")
					.append("	AND A.writor_rev=U1.revision_no\n")
					.append("	AND A.member_key=U1.member_key\n")
					.append("WHERE A.member_key = '" + jArray.get("member_key") + "' \n")
					.append("	AND A.check_gubun = '" + jArray.get("check_gubun") + "'\n")
					.append("	AND check_date = '" + jArray.get("check_date") + "'\n")
					.append("ORDER BY check_date, checklist_cd, checklist_seq \n")
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
			LoggingWriter.setLogError("M838S015250E144()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M838S015250E144()","==== finally ===="+ e.getMessage());
				}
	    	} else {
	    	}
	    }
	    // 결과 전문 구성을 위한 파라미터들을 아이오 파라미터에 저장한다.
		ioParam.setResultString(resultString);
		// 수퍼에서 처리된 칼럼의 갯수를 클라이언트에게 보내기 위해 가져온다.
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
		// 잘 처리되었다는 메시지를 클라이언트에게 보내기 위해 I/O파라미터에 저장한다.
    	ioParam.setMessage(MessageDefine.M_QUERY_OK);
	    return EventDefine.E_QUERY_RESULT;
	}
	
	// S838S070100_canvas.jsp
	public int E154(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			System.out.println("JSONObject jArray rcvData="+ jArray.toString());
			
			String sql = new StringBuilder()
					.append("SELECT\n")
					.append("	check_value,\n")
					.append("	SUBSTR(check_value,0,4),\n")
					.append("	SUBSTR(check_value,6,2),\n")
					.append("	SUBSTR(check_value,9,2),\n")
					.append("	SUBSTR(check_value,12,2),\n")
					.append("	SUBSTR(check_value,15,2)\n")
					.append("FROM\n")
					.append("	haccp_ccp_verify_check A\n")
					.append("	LEFT OUTER JOIN v_checklist_gubun_mid M \n")
					.append("	ON A.check_gubun = M.code_cd\n")
					.append("	AND A.check_gubun_mid = M.code_value\n")
					.append("	AND A.member_key = M.member_key\n")
					.append("	LEFT OUTER JOIN v_checklist_gubun_sm S \n")
					.append("	ON A.check_gubun = S.code_cd_big\n")
					.append("	AND A.check_gubun_mid = S.code_cd\n")
					.append("	AND A.check_gubun_sm = S.code_value\n")
					.append("	AND A.member_key = S.member_key\n")
					.append("	INNER JOIN tbm_users U1 \n")
					.append("	ON A.writor = U1.user_id\n")
					.append("	AND A.writor_rev = U1.revision_no\n")
					.append("	AND A.member_key = U1.member_key\n")
					.append("WHERE A.member_key = '" + jArray.get("member_key") + "' \n")
					.append("	AND A.check_gubun = '" + jArray.get("check_gubun") + "'\n")
					.append("	AND check_date = '" + jArray.get("check_date") + "'\n")
					.append("	AND NOT (check_value = 'Y' OR check_value = 'N' )\n")
					.append("ORDER BY\n")
					.append("	check_date,\n")
					.append("	checklist_cd,\n")
					.append("	checklist_seq\n")
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
			LoggingWriter.setLogError("M838S015250E154()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
		} finally {
			if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M838S015250E154()","==== finally ===="+ e.getMessage());
				}
			} else {
			}
		}
		// 결과 전문 구성을 위한 파라미터들을 아이오 파라미터에 저장한다.
		ioParam.setResultString(resultString);
		// 수퍼에서 처리된 칼럼의 갯수를 클라이언트에게 보내기 위해 가져온다.
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
		// 잘 처리되었다는 메시지를 클라이언트에게 보내기 위해 I/O파라미터에 저장한다.
		ioParam.setMessage(MessageDefine.M_QUERY_OK);
		return EventDefine.E_QUERY_RESULT;
	}
	
	// T838S070100.jsp 등록화면(Tablet)
	public int E101(InoutParameter ioParam){ 
		resultInt = EventDefine.E_DOEXCUTE_INIT;

		try {
			con = JDBCConnectionPool.getConnection();
			con.setAutoCommit(false);
			
			// insert_update_delete_json.jsp에서 받아온 JSON데이터 처리
    		JSONObject jArray = new JSONObject();
    		jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
    		System.out.println("JSONObject jArray rcvData="+ jArray.toString());
    		// Object데이터에서 키값(param)으로 JSONArray데이터를 꺼낸다. (데이터묶음 하나일땐 생략)
    		JSONArray jjArray = (JSONArray) jArray.get("param");
			
			for(int i=0; i<jjArray.size(); i++) {	
				JSONObject jjjArray = (JSONObject)jjArray.get(i); // i번째 데이터묶음
				
				String sql = new StringBuilder()
						.append("MERGE INTO haccp_ccp_verify_check mm\n")
						.append("USING\n")
						.append("	(\n")
						.append("		SELECT\n")
						
						.append(" 		'" + jjjArray.get("check_date") 		+ "' AS check_date,	\n")
	 					.append(" 		'" + jjjArray.get("checker") 			+ "' AS checker,	\n")
	 					.append(" 		'" + jjjArray.get("check_gubun") 		+ "' AS check_gubun,	\n")
	 					.append(" 		'" + jjjArray.get("check_gubun_mid") 	+ "' AS check_gubun_mid,	\n")
	 					.append(" 		'" + jjjArray.get("check_gubun_sm") 	+ "' AS check_gubun_sm,	\n")
	 					.append(" 		'" + jjjArray.get("checklist_cd") 		+ "' AS checklist_cd,	\n")
	 					.append(" 		'" + jjjArray.get("cheklist_cd_rev") 	+ "' AS cheklist_cd_rev,	\n")
	 					.append(" 		'" + jjjArray.get("checklist_seq") 		+ "' AS checklist_seq,	\n")
	 					.append(" 		'" + jjjArray.get("item_cd") 			+ "' AS item_cd,	\n")
	 					.append(" 		'" + jjjArray.get("item_seq") 			+ "' AS item_seq,	\n")
	 					.append(" 		'" + jjjArray.get("item_cd_rev") 		+ "' AS item_cd_rev,	\n")
	 					.append(" 		'" + jjjArray.get("standard_guide") 	+ "' AS standard_guide,	\n")
	 					.append(" 		'" + jjjArray.get("standard_value") 	+ "' AS standard_value,	\n")
	 					.append(" 		'" + jjjArray.get("check_note") 		+ "' AS check_note,	\n")
	 					.append(" 		'" + jjjArray.get("check_value") 		+ "' AS check_value,	\n")
	 					.append(" 		'" + jjjArray.get("write_date") 		+ "' AS write_date,	\n")
	 					.append(" 		'" + jjjArray.get("writor") 			+ "' AS writor,	\n")
	 					.append(" 		'" + jjjArray.get("writor_rev") 		+ "' AS writor_rev,	\n")
	 					.append(" 		'" + jjjArray.get("approval") 			+ "' AS approval,	\n")
	 					.append(" 		'" + jjjArray.get("approval_rev") 		+ "' AS approval_rev,	\n")
	 					.append(" 		'" + jjjArray.get("incong_note") 		+ "' AS incong_note,	\n")
	 					.append(" 		'" + jjjArray.get("improve_note")	 	+ "' AS improve_note,	\n")
	 					.append(" 		'" + jjjArray.get("action_worker") 		+ "' AS action_worker,	\n")
	 					.append(" 		'" + jjjArray.get("confirm_worker") 	+ "' AS confirm_worker,	\n")
	 					.append(" 		'" + jjjArray.get("member_key") 		+ "' AS member_key 	\n")
						.append("	) mQ \n")
						.append("		ON ( mm.check_date = mQ.check_date\n")
						.append("		AND mm.check_gubun = mQ.check_gubun\n")
						.append("		AND mm.check_gubun_mid = mQ.check_gubun_mid\n")
						.append("		AND mm.check_gubun_sm = mQ.check_gubun_sm\n")
						.append("		AND mm.checklist_cd = mQ.checklist_cd\n")
						.append("		AND mm.cheklist_cd_rev = mQ.cheklist_cd_rev\n")
						.append("		AND mm.checklist_seq = mQ.checklist_seq\n")
						.append("		AND mm.member_key = mQ.member_key\n")
						.append("	)\n")
						.append("	WHEN MATCHED THEN\n")
						.append("		UPDATE SET\n")
						.append("			mm.check_date = mQ.check_date,\n")
						.append("			mm.checker = mQ.checker,\n")
						.append("			mm.check_gubun = mQ.check_gubun,\n")
						.append("			mm.check_gubun_mid = mQ.check_gubun_mid,\n")
						.append("			mm.check_gubun_sm = mQ.check_gubun_sm,\n")
						.append("			mm.checklist_cd = mQ.checklist_cd,\n")
						.append("			mm.cheklist_cd_rev = mQ.cheklist_cd_rev,\n")
						.append("			mm.checklist_seq = mQ.checklist_seq,\n")
						.append("			mm.item_cd = mQ.item_cd,\n")
						.append("			mm.item_seq = mQ.item_seq,\n")
						.append("			mm.item_cd_rev = mQ.item_cd_rev,\n")
						.append("			mm.standard_guide = mQ.standard_guide,\n")
						.append("			mm.standard_value = mQ.standard_value,\n")
						.append("			mm.check_note = mQ.check_note,\n")
						.append("			mm.check_value = mQ.check_value,\n")
						.append("			mm.write_date = mQ.write_date,\n")
						.append("			mm.writor = mQ.writor,\n")
						.append("			mm.writor_rev = mQ.writor_rev,\n")
						.append("			mm.approval = mQ.approval,\n")
						.append("			mm.approval_rev = mQ.approval_rev,\n")
						.append("			mm.incong_note = mQ.incong_note,\n")
						.append("			mm.improve_note = mQ.improve_note,\n")
						.append("			mm.action_worker = mQ.action_worker,\n")
						.append("			mm.confirm_worker = mQ.confirm_worker,\n")
						.append("			mm.member_key = mQ.member_key\n")
						.append("	WHEN NOT MATCHED THEN\n")
						.append("		INSERT\n")
						.append("			(mm.check_date, mm.checker, mm.check_gubun, mm.check_gubun_mid, mm.check_gubun_sm, mm.checklist_cd, mm.cheklist_cd_rev, mm.checklist_seq, mm.item_cd, mm.item_seq, mm.item_cd_rev, mm.standard_guide, mm.standard_value, mm.check_note, mm.check_value, mm.write_date, mm.writor, mm.writor_rev, mm.approval, mm.approval_rev, mm.incong_note, mm.improve_note, mm.action_worker, mm.confirm_worker, mm.member_key)\n")
						.append("		VALUES\n")
						.append("			(mQ.check_date, mQ.checker, mQ.check_gubun, mQ.check_gubun_mid, mQ.check_gubun_sm, mQ.checklist_cd, mQ.cheklist_cd_rev, mQ.checklist_seq, mQ.item_cd, mQ.item_seq, mQ.item_cd_rev, mQ.standard_guide, mQ.standard_value, mQ.check_note, mQ.check_value, mQ.write_date, mQ.writor, mQ.writor_rev, mQ.approval, mQ.approval_rev, mQ.incong_note, mQ.improve_note, mQ.action_worker, mQ.confirm_worker, mQ.member_key);\n")
						.toString();

//				
//				String sql = new StringBuilder()
//						.append("INSERT INTO\n")
//						.append("	haccp_ccp_verify_check (\n")
//						.append("		check_date,				-- 점검일자\n")
//						.append("		checker,				-- 점검자\n")
//						.append("		check_gubun,			-- 체크리스트\n")
//						.append("		check_gubun_mid,		-- 체크리스트\n")
//						.append("		check_gubun_sm,			-- 체크리스트\n")
//						.append("		checklist_cd,			-- 체크리스트\n")
//						.append("		cheklist_cd_rev,		-- 체크리스트\n")
//						.append("		checklist_seq,			-- 체크리스트\n")
//						.append("		item_cd,				-- 체크리스트\n")
//						.append("		item_seq,				-- 체크리스트\n")
//						.append("		item_cd_rev,			-- 체크리스트\n")
//						.append("		standard_guide,			-- 체크리스트\n")
//						.append("		standard_value,			-- 체크리스트\n")
//						.append("		check_note,				-- 체크리스트\n")
//						.append("		check_value,			-- 체크리스트\n")
//						.append("		write_date,				-- 작성날짜\n")
//						.append("		writor,					-- 작성 (login id)\n")
//						.append("		writor_rev,				-- 작성 rev (login id_Rev == 0)\n")
//						.append("		approval,				-- 승인자\n")
//						.append("		approval_rev,			-- 승인자 rev\n")
//						.append("		incong_note,			-- 한계기준 이탈내용\n")
//						.append("		improve_note,			-- 개선조치 및 결과\n")
//						.append("		action_worker,			-- 조치자\n")
//						.append("		confirm_worker,			-- 확인자\n")
//						.append("		member_key			\n")
//						.append(")\n")
//						.append("VALUES (\n")
//						.append(" 		'" + jjjArray.get("check_date") 		+ "',	\n")
//	 					.append(" 		'" + jjjArray.get("checker") 			+ "',	\n")
//	 					.append(" 		'" + jjjArray.get("check_gubun") 		+ "',	\n")
//	 					.append(" 		'" + jjjArray.get("check_gubun_mid") 	+ "',	\n")
//	 					.append(" 		'" + jjjArray.get("check_gubun_sm") 	+ "',	\n")
//	 					.append(" 		'" + jjjArray.get("checklist_cd") 		+ "',	\n")
//	 					.append(" 		'" + jjjArray.get("cheklist_cd_rev") 	+ "',	\n")
//	 					.append(" 		'" + jjjArray.get("checklist_seq") 		+ "',	\n")
//	 					.append(" 		'" + jjjArray.get("item_cd") 			+ "',	\n")
//	 					.append(" 		'" + jjjArray.get("item_seq") 			+ "',	\n")
//	 					.append(" 		'" + jjjArray.get("item_cd_rev") 		+ "',	\n")
//	 					.append(" 		'" + jjjArray.get("standard_guide") 	+ "',	\n")
//	 					.append(" 		'" + jjjArray.get("standard_value") 	+ "',	\n")
//	 					.append(" 		'" + jjjArray.get("check_note") 		+ "',	\n")
//	 					.append(" 		'" + jjjArray.get("check_value") 		+ "',	\n")
//	 					.append(" 		'" + jjjArray.get("write_date") 		+ "',	\n")
//	 					.append(" 		'" + jjjArray.get("writor") 			+ "',	\n")
//	 					.append(" 		'" + jjjArray.get("writor_rev") 		+ "',	\n")
//	 					.append(" 		'" + jjjArray.get("approval") 			+ "',	\n")
//	 					.append(" 		'" + jjjArray.get("approval_rev") 		+ "',	\n")
//	 					.append(" 		'" + jjjArray.get("incong_note") 		+ "',	\n")
//	 					.append(" 		'" + jjjArray.get("improve_note")	 	+ "',	\n")
//	 					.append(" 		'" + jjjArray.get("action_worker") 		+ "',	\n")
//	 					.append(" 		'" + jjjArray.get("confirm_worker") 	+ "',	\n")
//	 					.append(" 		'" + jjjArray.get("member_key") 		+ "' 	\n")
//	 					.append("	) \n")
//						.toString();
			
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
			LoggingWriter.setLogError("M838S015250E101()","==== SQL ERROR ===="+ e.getMessage());
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