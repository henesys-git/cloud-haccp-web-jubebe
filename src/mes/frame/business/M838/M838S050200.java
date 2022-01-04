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
public  class M838S050200 extends SqlAdapter{
	Connection con = null;
	PreparedStatement pstmt = null;
	String resultString = "";
	int resultInt = -1;
	StringBuffer sql = new StringBuffer();
	
	String[][] v_paramArray = new String[0][0]; 
	Class[] optClass = null;
	Object[] optObj = null;
	Object obj = null;
	
	public M838S050200(){
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
			
			Method method = M838S050200.class.getMethod(event,optClass);
			LoggingWriter.setLogDebug(M838S050200.class.getName(),"==== " + event + " EventMethod Create Success ====");

			obj = method.invoke(M838S050200.class.newInstance(),optObj);
			doExcute_result = CommonFunction.getInt(obj.toString());
			
	    } catch (Exception ex) {
	    	doExcute_result = EventDefine.E_DOEXCUTE_INIT;
			ioParam.setMessage(MessageDefine.M_NO_EVENTID);
			LoggingWriter.setLogError(M838S050200.class.getName(),"==== EventID Not define : EVENT ID [ " + ioParam.getEventID() + "]");
	    } finally {
	    	obj = null;
			optClass = null;
			optObj = null;
	    }
	    long endTime = System.currentTimeMillis();
		long runningTime = endTime - startTime;
		LoggingWriter.setLogAll(M838S050200.class.getName(),"==== Query [수행시간  : " + runningTime + " ms]");
		
		return doExcute_result;
	}
	
	// S838S050200.jsp
	public int E104(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			System.out.println("JSONObject jArray rcvData="+ jArray.toString());
    		
			String sql = new StringBuilder()
					.append("SELECT DISTINCT			\n")
					.append("	SUBSTR(write_date, 0, 4),\n")
					.append("	quat_1,					\n")
					.append("	quat_2,					\n")
					.append("	quat_3,					\n")
					.append("	quat_4,					\n")
					.append("	check_date,				\n")
					.append("	checker_name,			\n")
					.append("	checker_name_rev,		\n")
					.append("	U1.user_nm,				\n")
					.append("	approval_date,			\n")
					.append("	approval_name,			\n")
					.append("	approval_name_rev,		\n")
					.append("	U2.user_nm,				\n")
					.append("	write_date,				\n")
					.append("	writor_main,			\n")
					.append("	writor_main_rev,		\n")
					.append("	U3.user_nm				\n")					
					.append("FROM						\n")
					.append("	haccp_health_check_result A\n")					
					.append("LEFT OUTER JOIN tbm_users U1		\n")
					.append("	ON A.checker_name=U1.user_nm	\n")
					.append("	AND A.checker_name_rev=U1.revision_no\n")
					.append("	AND A.member_key=U1.member_key\n")
					.append("LEFT OUTER JOIN tbm_users U2		\n")
					.append("	ON A.approval_name=U2.user_nm	\n")
					.append("	AND A.approval_name_rev=U2.revision_no\n")
					.append("	AND A.member_key=U2.member_key\n")
					.append("LEFT OUTER JOIN tbm_users U3\n")
					.append("	ON A.writor_main=U3.user_nm		\n")
					.append("	AND A.writor_main_rev=U3.revision_no\n")
					.append("	AND A.member_key=U3.member_key\n")
					.append("WHERE write_date \n")
					.append("BETWEEN '" + jArray.get("fromdate") + "' \n")
					.append("	 AND '" + jArray.get("todate") + "'	\n")
					.append(" 	AND A.member_key = '" + jArray.get("member_key") + "' \n") //member_key_select, update, delete
					.append("GROUP BY SUBSTR(write_date, 0, 4), quat_1, quat_2, quat_3, quat_4, writor_main;\n")
					
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
			LoggingWriter.setLogError("M838S050200E104()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M838S050200E104()","==== finally ===="+ e.getMessage());
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


	// S838S050202 건강진단관리대장 수정부 조회
	public int E114(InoutParameter ioParam) {
		resultInt = EventDefine.E_DOEXCUTE_INIT;

		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			System.out.println("JSONObject jArray rcvData="+ jArray.toString());

			String sql = new StringBuilder()
					.append("SELECT DISTINCT\n")
					.append("	health_exm_name,\n")
					.append("	health_exm_date,\n")
					.append("	health_exm_next_date,\n")
					.append("	quat_1,\n")
					.append("	quat_2,\n")
					.append("	quat_3,\n")
					.append("	quat_4,\n")
					.append("	check_date,\n")
					.append("	checker_name,\n")
					.append("	checker_name_rev,\n")
					.append("	U1.user_nm,\n")
					.append("	approval_date,\n")
					.append("	approval_name,\n")
					.append("	approval_name_rev,\n")
					.append("	U2.user_nm,\n")
					.append("	write_date,\n")
					.append("	writor_main,\n")
					.append("	writor_main_rev,\n")
					.append("	U3.user_nm,\n")
					.append("	uniqueness, \n")
					.append("	bigo \n")
					.append("FROM\n")
					.append("	haccp_health_check_result A\n")
					.append("LEFT OUTER JOIN tbm_users U1\n")
					.append("	ON A.checker_name=U1.user_nm\n")
					.append("	AND A.checker_name_rev=U1.revision_no\n")
					.append("	AND A.member_key=U1.member_key\n")
					.append("LEFT OUTER JOIN tbm_users U2\n")
					.append("	ON A.approval_name=U2.user_nm\n")
					.append("	AND A.approval_name_rev=U2.revision_no\n")
					.append("	AND A.member_key=U2.member_key\n")
					.append("LEFT OUTER JOIN tbm_users U3\n")
					.append("	ON A.writor_main=U3.user_nm\n")
					.append("	AND A.writor_main_rev=U3.revision_no\n")
					.append("	AND A.member_key=U3.member_key\n")
					.append("WHERE writor_main = '"+ jArray.get("writorName") +"'\n")
					.append("AND quat_1 = '"+ jArray.get("quat1") +"'\n")
					.append("AND quat_2 = '"+ jArray.get("quat2") +"'\n")
					.append("AND quat_3 = '"+ jArray.get("quat3") +"'\n")
					.append("AND quat_4 = '"+ jArray.get("quat4") +"'\n")
					.append("AND SUBSTR(write_date, 0, 4) = "+  jArray.get("healthExmYear") +"\n")
					.append("AND A.member_key = '" + jArray.get("member_key") + "' \n") //member_key_select, update, delete
					.toString();
			resultString = super.excuteQueryString(con, sql.toString());
		} catch (Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M838S050200E114()", "==== SQL ERROR ====" + e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR;
		} finally {
			if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M838S050200E114()","==== finally ===="+ e.getMessage());
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
	
	// T838S050200.jsp 등록화면(Tablet)
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

			String sql = new StringBuilder()
				.append("INSERT INTO \n")
				.append("	haccp_health_check_result ( \n")
				.append("		health_exm_name,\n")
				.append("		health_exm_date,\n")
				.append("		health_exm_next_date,\n")
				.append("		quat_1,\n")
				.append("		quat_2,\n")
				.append("		quat_3,\n")
				.append("		quat_4,\n")
				.append("		bigo,\n")
				.append("		check_date,\n")
				.append("		checker_name,\n")
				.append("		checker_name_rev,\n")
				.append("		approval_date,\n")
				.append("		approval_name,\n")
				.append("		approval_name_rev,\n")
				.append("		uniqueness,\n")
				.append("		writor_main,\n")
				.append("		writor_main_rev,\n")
				.append("		write_date,\n")
				.append(" 		member_key	\n") // member_key_insert
				.append("	) VALUES ( \n")
				.append(" 		'"	+ jArray.get("health_exm_name") + "',	\n")
				.append(" 		'"	+ jArray.get("health_exm_date") + "',	\n")
				.append(" 		'"	+ jArray.get("health_exm_next_date") + "',	\n")
				.append(" 		'"	+ jArray.get("quat_1") + "',	\n")
				.append(" 		'"	+ jArray.get("quat_2") + "',	\n")
				.append(" 		'"	+ jArray.get("quat_3") + "',	\n")
				.append(" 		'"	+ jArray.get("quat_4") + "',	\n")
				.append(" 		'"	+ jArray.get("bigo") + "',	\n")
				.append(" 		'"	+ jArray.get("check_date") + "',	\n")
				.append(" 		'"	+ jArray.get("checker_name") + "',	\n")
				.append(" 		'"	+ jArray.get("checker_name_rev") + "',	\n")
				.append(" 		'"	+ jArray.get("approval_date") + "',	\n")
				.append(" 		'"	+ jArray.get("approval_name") + "',	\n")
				.append(" 		'"	+ jArray.get("approval_name_rev") + "',	\n")
				.append(" 		'"	+ jArray.get("uniqueness") + "',	\n")
				.append(" 		'"	+ jArray.get("writor_main") + "',	\n")
				.append(" 		'"	+ jArray.get("writor_main_rev") + "',	\n")
				.append(" 		'"	+ jArray.get("write_date") + "',	\n")
				.append(" 		'" + jArray.get("member_key") + "' \n") //member_key_values
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
			LoggingWriter.setLogError("M838S050200E101()","==== SQL ERROR ===="+ e.getMessage());
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
	// S838S050201 PC등록
	public int E111(InoutParameter ioParam){

		String sql ="";
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		ApprovalActionNo ActionNo;
		String gOrderNo="";
		try {
			con = JDBCConnectionPool.getConnection();
			con.setAutoCommit(false);
			
    		// insert_update_delete_json.jsp에서 받아온 JSON데이터 처리
    		JSONObject jArray = new JSONObject();
    		jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
    		System.out.println("JSONObject jArray rcvData="+ jArray.toString());
    		// Object데이터에서 키값(param)으로 JSONArray데이터를 꺼낸다. (데이터묶음 하나일땐 생략)
    		JSONArray jjArray = (JSONArray) jArray.get("param");
    		System.out.println("데이터 묶음 개수 :::: " + jjArray.size());
			
			for(int i=0; i<jjArray.size(); i++) {
				JSONObject jjjArray = (JSONObject)jjArray.get(i); // i번째 데이터묶음
						sql = new StringBuilder()
							.append("INSERT INTO haccp_health_check_result\n")
							.append("	(health_exm_name,		\n")
							.append("	 health_exm_date,		\n")
							.append("	 health_exm_next_date,	\n")
							.append("	 quat_1,				\n")
							.append("	 quat_2,				\n")
							.append("	 quat_3,				\n")
							.append("	 quat_4,				\n")
							.append("	 bigo,					\n")
							.append("	 check_date,			\n")
							.append("	 checker_name,			\n")
							.append("	 checker_name_rev,		\n")
							.append("	 approval_date,			\n")
							.append("	 approval_name,			\n")
							.append("	 approval_name_rev,		\n")
							.append("	 uniqueness,			\n")
							.append("	 writor_main,			\n")
							.append("	 writor_main_rev,		\n")
							.append("	 write_date			\n")
							.append(" 	,member_key	\n") // member_key_insert
							.append("	)\n")
							.append("VALUES						\n")
							.append("	('" + jjjArray.get("health_exm_name") + "', 		-- 검진자명	\n")
							.append("	 '" + jjjArray.get("health_exm_date") + "', 		-- 검진일		\n")
							.append("	 '" + jjjArray.get("health_exm_next_date") + "', 	-- 차기검진일	\n")
							.append("	 '" + jjjArray.get("quat_1") + "', 					-- 1/4분기	\n")
							.append("	 '" + jjjArray.get("quat_2") + "', 					-- 2/4분기	\n")
							.append("	 '" + jjjArray.get("quat_3") + "', 					-- 3/4분기	\n")
							.append("	 '" + jjjArray.get("quat_4") + "', 					-- 4/4분기	\n")
							.append("	 '" + jjjArray.get("bigo")	+ "', 					-- 비고		\n")
							.append("	 '" + jjjArray.get("check_date") + "', 				-- 확인일		\n")
							.append("	(SELECT user_id	\n")
							.append("	 FROM tbm_users		\n")
							.append("	 WHERE user_nm 	 = '" + jjjArray.get("checker_name") + "'\n")
							.append("	 AND user_id 	 = '" + jjjArray.get("checker_cd") + "'\n")
							.append("	 AND revision_no = '" + jjjArray.get("checker_name_rev") + "'\n")
							.append("	 GROUP BY user_id),  -- 점검자명	\n")							
							.append("	(SELECT MAX(revision_no)\n")
							.append("	 FROM tbm_users		\n")
							.append("	 WHERE user_nm 	 = '" + jjjArray.get("checker_name") + "'\n")
							.append("	 AND user_id 	 = '" + jjjArray.get("checker_cd") + "'\n")
							.append("	 AND revision_no = '" + jjjArray.get("checker_name_rev") + "'\n")
							.append("	 GROUP BY user_id),  -- 점검rev	\n")
							.append("	 '" + jjjArray.get("approval_date")	+ "',	-- 확인일 	\n")
							.append("	(SELECT user_id	\n")
							.append("	 FROM tbm_users		\n")
							.append("	 WHERE user_nm 	 = '" + jjjArray.get("approval_name") + "'\n")
							.append("	 AND user_id 	 = '" + jjjArray.get("approval_cd") + "'\n")
							.append("	 AND revision_no = '" + jjjArray.get("approval_name_rev") + "'\n")
							.append("	 GROUP BY user_id),  -- 승인자명	\n")
							.append("	(SELECT MAX(revision_no) \n")
							.append("	 FROM tbm_users		\n")
							.append("	 WHERE user_nm 	 = '" + jjjArray.get("approval_name") + "'\n")
							.append("	 AND user_id 	 = '" + jjjArray.get("approval_cd") + "'\n")
							.append("	 AND revision_no = '" + jjjArray.get("approval_name_rev") + "'\n")
							.append("	 GROUP BY user_id),	-- 승인rev \n")
							.append("	 '" + jjjArray.get("uniqueness") + "', 		-- 특이사항 \n")
							.append("	(SELECT user_id	\n")
							.append("	 FROM tbm_users		\n")
							.append("	 WHERE user_nm 	 = '" + jjjArray.get("writor_main") + "'\n")
							.append("	 AND user_id 	 = '" + jjjArray.get("writor_cd") + "'\n")
							.append("	 AND revision_no = '" + jjjArray.get("writor_main_rev") + "'\n")
							.append("	 GROUP BY user_id),  -- 작성자명	\n")
							.append("	(SELECT MAX(revision_no) \n")
							.append("	 FROM tbm_users		\n")
							.append("	 WHERE user_nm 	 = '" + jjjArray.get("writor_main") + "'\n")
							.append("	 AND user_id 	 = '" + jjjArray.get("writor_cd") + "'\n")
							.append("	 AND revision_no = '" + jjjArray.get("writor_main_rev") + "'\n")
							.append("	 GROUP BY user_id),  -- 작성rev		\n")
							.append("	 '" + jjjArray.get("write_date") + "'		-- 작성일	\n")
							.append(" 	,'" + jjjArray.get("member_key") + "' \n") //member_key_values
							.append("	)\n")
							.toString();				 
				resultInt = super.excuteUpdate(con, sql.toString());
				
				if (resultInt < 0) {
					con.rollback();
					return EventDefine.E_DOEXCUTE_ERROR ;
				}
				/*String main_action_no="", review_action_no="",confirm_action_no="";//없으면 없는대로 전달
				main_action_no = gOrderNo;						*/
			}			
			con.commit();			
			
		} catch(Exception e) {
			LoggingWriter.setLogError("M838S050200E111()","==== SQL ERROR ===="+ e.getMessage() + "\n" + sql.toString());
			e.printStackTrace();
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M838S050200E111()","==== finally ===="+ e.getMessage());
				}
	    	} else {
	    	}
	    }
	    // 결과 전문 구성을 위한 파라미터들을 아이오 파라미터에 저장한다.
		ioParam.setResultString(resultString);
		// 수퍼에서 처리된 칼럼의 갯수를 클라이언트에게 보내기 위해 가져온다.
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
		// 잘 처리되었다는 메시지를 클라이언트에게 보내기 위해 I/O파라미터에 저장한다.
		// 위에서 저장된 넘을 보존하기 위해서 막는다.
    	// ioParam.setMessage(MessageDefine.M_QUERY_OK);
	    return EventDefine.E_QUERY_RESULT;
	}
	// S838S050202 PC 수정부
	public int E112(InoutParameter ioParam){
		String sqlPre = "";
		String sql ="";
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		ApprovalActionNo ActionNo;
		String gOrderNo="";
		try {
			con = JDBCConnectionPool.getConnection();
			con.setAutoCommit(false);
			
    		// insert_update_delete_json.jsp에서 받아온 JSON데이터 처리
    		JSONObject jArray = new JSONObject();
    		jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
    		System.out.println("JSONObject jArray rcvData="+ jArray.toString());
    		// Object데이터에서 키값(param)으로 JSONArray데이터를 꺼낸다. (데이터묶음 하나일땐 생략)
    		JSONArray jjArray = (JSONArray) jArray.get("param");
    		JSONObject jjjArray0 = (JSONObject)jjArray.get(0); // 0번째 데이터묶음
    		
    		String jspPage = (String)jjjArray0.get("jsp_page");
			for(int i=0; i<jjArray.size(); i++) {
				JSONObject jjjArray = (JSONObject)jjArray.get(i); // i번째 데이터묶음
				sql = new StringBuilder()
						.append("MERGE INTO haccp_health_check_result HSP  \n")
						.append("	USING ( SELECT     \n")	
						.append("		'" + jjjArray.get("health_exm_name") 		+ "' AS health_exm_name, 		-- 0. health_exm_name     	\n") // health_exm_name
						.append("		'" + jjjArray.get("health_exm_date") 		+ "' AS health_exm_date, 		-- 1. health_exm_date     	\n") // health_exm_date
						.append("		'" + jjjArray.get("health_exm_next_date") 	+ "' AS health_exm_next_date, 	-- 2. health_exm_next_date	\n") // health_exm_next_date
						.append("		'" + jjjArray.get("quat_1") 				+ "' AS quat_1, 				-- 3. quat_1              	\n") // quat_1
						.append("		'" + jjjArray.get("quat_2") 				+ "' AS quat_2, 				-- 4. quat_2              	\n") // quat_2
						.append("		'" + jjjArray.get("quat_3") 				+ "' AS quat_3, 				-- 5. quat_3              	\n") // quat_3
						.append("		'" + jjjArray.get("quat_4") 				+ "' AS quat_4, 				-- 6. quat_4              	\n") // quat_4
						.append("		'" + jjjArray.get("bigo") 					+ "' AS bigo, 					-- 7. bigo                	\n") // bigo
						.append("		'" + jjjArray.get("check_date") 			+ "' AS check_date, 			-- 8. check_date          	\n") // check_date
						.append("		'" + jjjArray.get("checker_name") 			+ "' AS checker_name, 			-- 9. checker_name        	\n") // checker_name
						.append("		'" + jjjArray.get("checker_name_rev") 		+ "' AS checker_name_rev, 		-- 10. checker_name_rev     \n") // checker_name_rev
						.append("		'" + jjjArray.get("approval_date") 			+ "' AS approval_date, 			-- 11. approval_date        \n") // approval_date
						.append("		'" + jjjArray.get("approval_name") 			+ "' AS approval_name, 			-- 12. approval_name        \n") // approval_name
						.append("		'" + jjjArray.get("approval_name_rev") 		+ "' AS approval_name_rev, 		-- 13. approval_name_rev    \n") // approval_name_rev
						.append("		'" + jjjArray.get("uniqueness") 			+ "' AS uniqueness, 			-- 14. uniqueness           \n") // uniqueness
						.append("		'" + jjjArray.get("writor_main") 			+ "' AS writor_main, 			-- 15. writor_main          \n") // writor_main
						.append("		'" + jjjArray.get("writor_main_rev") 		+ "' AS writor_main_rev, 		-- 16. writor_main_rev      \n") // writor_main_rev
						.append("		'" + jjjArray.get("write_date") 			+ "' AS write_date, 			-- 17. write_date           \n") // write_date
						.append("		'" + jjjArray.get("member_key") 			+ "' AS member_key 				-- 18. member_key           \n") // member_key
						.append("	  		FROM db_root )  mQ    \n")
						.append("ON (HSP.health_exm_name = mQ.health_exm_name 	\n")
						.append("AND HSP.health_exm_date = mQ.health_exm_date   \n")
						.append("AND HSP.health_exm_next_date = mQ.health_exm_next_date   \n")
						.append("AND HSP.quat_1 = mQ.quat_1   \n")
						.append("AND HSP.quat_2 = mQ.quat_2   \n")
						.append("AND HSP.quat_3 = mQ.quat_3   \n")
						.append("AND HSP.quat_4 = mQ.quat_4   \n")
						.append("AND HSP.member_key = mQ.member_key)   \n")
						.append("WHEN MATCHED THEN     \n")
						.append("	UPDATE SET \n")
						.append("		HSP.health_exm_name       = mQ.health_exm_name,     \n ")
						.append("		HSP.health_exm_date       = mQ.health_exm_date,     \n ")
						.append("		HSP.health_exm_next_date  = mQ.health_exm_next_date,\n ")
						.append("		HSP.quat_1                = mQ.quat_1,              \n ")
						.append("		HSP.quat_2                = mQ.quat_2,              \n ")
						.append("		HSP.quat_3                = mQ.quat_3,              \n ")
						.append("		HSP.quat_4                = mQ.quat_4,              \n ")
						.append("		HSP.bigo                  = mQ.bigo,                \n ")
						.append("		HSP.check_date            = mQ.check_date,          \n ")
						.append("		HSP.checker_name          = mQ.checker_name,        \n ")
						.append("		HSP.checker_name_rev      = mQ.checker_name_rev,    \n ")
						.append("		HSP.approval_date         = mQ.approval_date,       \n ")
						.append("		HSP.approval_name         = mQ.approval_name,       \n ")
						.append("		HSP.approval_name_rev     = mQ.approval_name_rev,   \n ")
						.append("		HSP.uniqueness            = mQ.uniqueness,          \n ")
						.append("		HSP.writor_main           = mQ.writor_main,         \n ")
						.append("		HSP.writor_main_rev       = mQ.writor_main_rev,     \n ")
						.append("		HSP.write_date            = mQ.write_date,          \n ")
						.append("		HSP.member_key            = mQ.member_key           \n ")
						.append("WHEN NOT MATCHED THEN \n")                                  
						.append("	INSERT ( 	\n")
						.append("		HSP.health_exm_name, 		\n")		
						.append("		HSP.health_exm_date, 		\n")		
						.append("		HSP.health_exm_next_date, 	\n")
						.append("		HSP.quat_1, 				\n")
						.append("		HSP.quat_2, 				\n")
						.append("		HSP.quat_3, 				\n")
						.append("		HSP.quat_4, 				\n")
						.append("		HSP.bigo, 					\n")
						.append("		HSP.check_date, 			\n")
						.append("		HSP.checker_name, 			\n")
						.append("		HSP.checker_name_rev, 		\n")		
						.append("		HSP.approval_date, 			\n")
						.append("		HSP.approval_name, 			\n")
						.append("		HSP.approval_name_rev, 		\n")
						.append("		HSP.uniqueness, 			\n")
						.append("		HSP.writor_main, 			\n")
						.append("		HSP.writor_main_rev, 		\n")
						.append("		HSP.write_date, 			\n")
						.append("		HSP.member_key 				\n")
						.append("	)	\n")
						.append("VALUES	\n")
						.append("	(\n")
						.append("		mQ.health_exm_name, 		\n")		
						.append("		mQ.health_exm_date, 		\n")		
						.append("		mQ.health_exm_next_date,	\n")
						.append("		mQ.quat_1, 					\n")
						.append("		mQ.quat_2, 					\n")
						.append("		mQ.quat_3, 					\n")
						.append("		mQ.quat_4, 					\n")
						.append("		mQ.bigo, 					\n")
						.append("		mQ.check_date, 				\n")
						.append("		mQ.checker_name, 			\n")
						.append("		mQ.checker_name_rev, 		\n")		
						.append("		mQ.approval_date, 			\n")
						.append("		mQ.approval_name, 			\n")
						.append("		mQ.approval_name_rev, 		\n")
						.append("		mQ.uniqueness, 				\n")
						.append("		mQ.writor_main, 			\n")
						.append("		mQ.writor_main_rev, 		\n")
						.append("		mQ.write_date, 				\n")
						.append("		mQ.member_key 				\n")
						.append("	);\n")
						.toString();				

				resultInt = super.excuteUpdate(con, sql.toString());
				
				if (resultInt < 0) {
					con.rollback();
					return EventDefine.E_DOEXCUTE_ERROR ;
				}
				/*String main_action_no="", review_action_no="",confirm_action_no="";//없으면 없는대로 전달
				main_action_no = gOrderNo;						*/
			}			
			con.commit();			
			
		} catch(Exception e) {
			LoggingWriter.setLogError("M838S050200E112()","==== SQL ERROR ===="+ e.getMessage() + "\n" + sql.toString());
			e.printStackTrace();
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M838S050200E112()","==== finally ===="+ e.getMessage());
				}
	    	} else {
	    	}
	    }
	    // 결과 전문 구성을 위한 파라미터들을 아이오 파라미터에 저장한다.
		ioParam.setResultString(resultString);
		// 수퍼에서 처리된 칼럼의 갯수를 클라이언트에게 보내기 위해 가져온다.
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
		// 잘 처리되었다는 메시지를 클라이언트에게 보내기 위해 I/O파라미터에 저장한다.
		// 위에서 저장된 넘을 보존하기 위해서 막는다.
    	// ioParam.setMessage(MessageDefine.M_QUERY_OK);
	    return EventDefine.E_QUERY_RESULT;
	}	
	
	// S838S050202 PC 삭제부
	public int E113(InoutParameter ioParam){
		String sqlPre = "";
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		ApprovalActionNo ActionNo;
		String gOrderNo="";
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			System.out.println("JSONObject jArray rcvData="+ jArray.toString());

			String sql = new StringBuilder()
				.append("DELETE FROM haccp_health_check_result	\n")
				.append("WHERE writor_main = '"+ jArray.get("writor_main") +"'\n")
				.append("AND quat_1 = '"+ jArray.get("quat_1") +"'\n")
				.append("AND quat_2 = '"+ jArray.get("quat_2") +"'\n")
				.append("AND quat_3 = '"+ jArray.get("quat_3") +"'\n")
				.append("AND quat_4 = '"+ jArray.get("quat_4") +"'\n")
				.append("AND SUBSTR(write_date, 0, 4) = SUBSTR('"+  jArray.get("write_date") +"', 0, 4)\n")
				.toString();
 
				resultInt = super.excuteUpdate(con, sql.toString());
				
			if (resultInt < 0) {
				con.rollback();
				return EventDefine.E_DOEXCUTE_ERROR ;
			}
			/*String main_action_no="", review_action_no="",confirm_action_no="";//없으면 없는대로 전달
			main_action_no = gOrderNo;						*/
					
			con.commit();			
			
		} catch(Exception e) {
			LoggingWriter.setLogError("M838S050200E113()","==== SQL ERROR ===="+ e.getMessage() + "\n" + sql.toString());
			e.printStackTrace();
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M838S050200E113()","==== finally ===="+ e.getMessage());
				}
	    	} else {
	    	}
	    }
	    // 결과 전문 구성을 위한 파라미터들을 아이오 파라미터에 저장한다.
		ioParam.setResultString(resultString);
		// 수퍼에서 처리된 칼럼의 갯수를 클라이언트에게 보내기 위해 가져온다.
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
		// 잘 처리되었다는 메시지를 클라이언트에게 보내기 위해 I/O파라미터에 저장한다.
		// 위에서 저장된 넘을 보존하기 위해서 막는다.
    	// ioParam.setMessage(MessageDefine.M_QUERY_OK);
	    return EventDefine.E_QUERY_RESULT;
	}	
}