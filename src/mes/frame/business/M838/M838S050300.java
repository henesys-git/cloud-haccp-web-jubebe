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
public  class M838S050300 extends SqlAdapter{
	Connection con = null;
	PreparedStatement pstmt = null;
	String resultString = "";
	int resultInt = -1;
	StringBuffer sql = new StringBuffer();
	
	String[][] v_paramArray = new String[0][0]; 
	Class[] optClass = null;
	Object[] optObj = null;
	Object obj = null;
	
	public M838S050300(){
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
			
			Method method = M838S050300.class.getMethod(event,optClass);
			LoggingWriter.setLogDebug(M838S050300.class.getName(),"==== " + event + " EventMethod Create Success ====");

			obj = method.invoke(M838S050300.class.newInstance(),optObj);
			doExcute_result = CommonFunction.getInt(obj.toString());
			
	    } catch (Exception ex) {
	    	doExcute_result = EventDefine.E_DOEXCUTE_INIT;
			ioParam.setMessage(MessageDefine.M_NO_EVENTID);
			LoggingWriter.setLogError(M838S050300.class.getName(),"==== EventID Not define : EVENT ID [ " + ioParam.getEventID() + "]");
	    } finally {
	    	obj = null;
			optClass = null;
			optObj = null;
	    }
	    long endTime = System.currentTimeMillis();
		long runningTime = endTime - startTime;
		LoggingWriter.setLogAll(M838S050300.class.getName(),"==== Query [수행시간  : " + runningTime + " ms]");
		
		return doExcute_result;
	}
	
	// S838S050300.jsp
	public int E104(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			System.out.println("JSONObject jArray rcvData="+ jArray.toString());
    		
			String sql = new StringBuilder()
					.append("SELECT DISTINCT\n")
					.append("	check_date,\n")
					.append("	check_time,\n")
					.append("	check_gubun,\n")
					.append("	E.code_name,\n")
					
					.append("	cust_cd,\n")
					.append("	cust_cd_rev,\n")
					.append("	cust_nm,\n")
					.append("	boss_name,\n")
					.append("	jongmok,\n")
					.append("	bizno,\n")
					.append("	address,\n")
					.append("	telno,\n")
					.append("	check_object,\n")
					
					.append("	checker_dept,\n")
					.append("	D.code_name,\n")
					.append("	checker_title,\n")
					.append("	checker_main,\n")
					.append("	checker_main_rev,\n")
					.append("	U1.user_nm,\n")
					.append("	checker_dept_2,\n")
					.append("	checker_title_2,\n")
					.append("	checker_second,\n")
					.append("	checker_second_rev,\n")
					.append("	U2.user_nm,\n")
					.append("	confirm_dept,\n")
					.append("	confirm_title,\n")
					.append("	confirm_user,\n")
					.append("	confirm_user_rev,\n")
					.append("	U3.user_nm,\n")
					
					.append("	write_date\n")
					
					.append("FROM\n")
					.append("	haccp_inout_check_result A\n")
					
					.append("INNER JOIN v_checklist_gubun E\n")
					.append("	ON A.check_gubun = E.code_value\n")
					.append("	AND A.member_key = E.member_key\n")
					.append("LEFT OUTER JOIN v_dept_code D\n")
					.append("	ON A.checker_dept = D.code_value\n")
					.append("	AND A.member_key = D.member_key\n")
					
					.append("INNER JOIN tbm_users U1\n")
					.append("	ON A.checker_main=U1.user_id\n")
					.append("	AND A.checker_main_rev=U1.revision_no\n")
					.append("	AND A.member_key=U1.member_key\n")
					.append("LEFT OUTER JOIN tbm_users U2\n")
					.append("	ON A.checker_second=U2.user_id\n")
					.append("	AND A.checker_second_rev=U2.revision_no\n")
					.append("	AND A.member_key=U2.member_key\n")
					.append("LEFT OUTER JOIN tbm_users U3\n")
					.append("	ON A.confirm_user=U3.user_id\n")
					.append("	AND A.confirm_user_rev=U3.revision_no\n")
					.append("	AND A.member_key=U3.member_key\n")
					
					.append("WHERE write_date \n")
					.append("BETWEEN '" + jArray.get("fromdate") + "' 	\n")
					.append("	 AND '" + jArray.get("todate") + "'	\n")
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
			LoggingWriter.setLogError("M838S050300E104()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M838S050300E104()","==== finally ===="+ e.getMessage());
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
	
	// S838S050310.jsp
	public int E114(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			System.out.println("JSONObject jArray rcvData="+ jArray.toString());
    		
			String sql = new StringBuilder()
					.append("SELECT\n")
					
					.append("	check_date,\n")
					.append("	check_time,\n")
					.append("	cust_cd,\n")
					.append("	cust_cd_rev,\n")
					.append("	cust_nm,\n")
					
					.append("	checklist_cd,\n")
					.append("	cheklist_cd_rev,\n")
					.append("	checklist_seq,\n")
					.append("	item_cd,\n")
					.append("	item_seq,\n")
					.append("	item_cd_rev,\n")
					.append("	check_note,\n")
					.append("	check_value,\n")
					.append("	standard_guide,\n")
					.append("	standard_value\n")
					
					.append("FROM\n")
					.append("	haccp_inout_check_result\n")
					.append("WHERE check_date='" + jArray.get("check_date") + "'\n")
					.append("	AND check_time='" 	 + jArray.get("check_time") + "'\n")
					.append("	AND cust_cd='" 	 + jArray.get("cust_cd") + "'\n")
					.append("	AND cust_cd_rev='" 	 + jArray.get("cust_cd_rev") + "'\n")
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
			LoggingWriter.setLogError("M838S050300E114()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M838S050300E114()","==== finally ===="+ e.getMessage());
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
	
	// S838S050302.jsp 수정 // S838S050303.jsp 삭제
	public int E124(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			System.out.println("JSONObject jArray rcvData="+ jArray.toString());
    		
			String sql = new StringBuilder()
					.append("SELECT\n")
					.append("	checklist_cd,\n") //0
					.append("	cheklist_cd_rev,\n")
					.append("	checklist_seq,\n")
					.append("	A.item_cd,\n")
					.append("	A.item_seq,\n")
					.append("	A.item_cd_rev,\n")
					.append("	check_note,\n")
					.append("	check_value,\n")
					.append("	standard_guide,\n")
					.append("	standard_value,\n")
					.append("	check_gubun,\n") //10
					.append("	B.item_type,\n")
					.append("	check_date,\n")
					.append("	check_time,\n")
					.append("	checker_main,\n")
					.append("	checker_main_rev,\n")
					.append("	checker_second,\n")
					.append("	checker_second_rev,\n")
					.append("	confirm_user,\n")
					.append("	confirm_user_rev,\n")
					.append("	write_date,\n") //20
					.append("	cust_cd,\n")
					.append("	cust_cd_rev,\n")
					.append("	check_object,\n")
					.append("	cust_nm,\n")
					.append("	boss_name,\n")
					.append("	jongmok,\n")
					.append("	bizno,\n")
					.append("	address,\n")
					.append("	telno,\n")
					.append("	checker_dept,\n") //30
					.append("	checker_dept_2,\n")
					.append("	confirm_dept,\n")
					.append("	checker_title,\n")
					.append("	checker_title_2,\n")
					.append("	confirm_title\n")
					.append("FROM\n")
					.append("	haccp_inout_check_result A\n")
					.append("INNER JOIN tbm_check_item B\n")
					.append("	ON A.item_cd = B.item_cd\n")
					.append("	AND A.item_seq = B.item_seq\n")
					.append("	AND A.item_cd_rev = B.revision_no\n")
					.append("	AND A.member_key = B.member_key\n")
					.append("WHERE check_date='" 	+ jArray.get("check_date") + "'\n")
					.append("	AND check_time='" 	+ jArray.get("check_time") + "'\n")
					.append("	AND cust_cd='" 		+ jArray.get("cust_cd") + "'\n")
					.append("	AND cust_cd_rev='" 	+ jArray.get("cust_cd_rev") + "'\n")
					.append("	AND A.member_key = '" + jArray.get("member_key") + "'\n")
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
			LoggingWriter.setLogError("M838S050300E124()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M838S020400E124()","==== finally ===="+ e.getMessage());
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
	
	// T838S050300.jsp 등록화면(Tablet) // S838S050301.jsp 등록
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
					.append("	A.duration_date\n")
					.append("FROM vtbm_checklist A\n")
					.append("INNER JOIN tbm_check_item B\n")
					.append("	ON A.item_cd = B.item_cd\n")
					.append("	AND A.item_seq = B.item_seq\n")
					.append("	AND A.item_cd_rev = B.revision_no\n")
					.append("	AND A.member_key = B.member_key\n")
					.append("INNER JOIN v_checklist_gubun E\n")
					.append("	ON A.check_gubun = E.code_value\n")
					.append("	AND A.member_key = E.member_key\n")
					.append("where A.check_gubun like '" + jArray.get("check_gubun") + "%'\n")
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
			LoggingWriter.setLogError("M838S050300E134()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M838S050300E134()","==== finally ===="+ e.getMessage());
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
	
	// S838S050300_canvas.jsp
	public int E144(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			System.out.println("JSONObject jArray rcvData="+ jArray.toString());
			
			String sql = new StringBuilder()
					.append("SELECT\n")
					.append("	check_date,\n")
					.append("	check_time,\n")
					.append("	check_gubun,\n")
					.append("	E.code_name,\n")
					.append("	checklist_cd,\n")
					.append("	cheklist_cd_rev,\n")
					.append("	checklist_seq,\n")
					.append("	item_cd,\n")
					.append("	item_seq,\n")
					.append("	item_cd_rev,\n")
					.append("	check_value,\n") // 10 
					.append("	checker_main,\n")
					.append("	checker_main_rev,\n")
					.append("	U1.user_nm,\n")
					.append("	checker_second,\n")
					.append("	checker_second_rev,\n")
					.append("	confirm_user,\n")
					.append("	confirm_user_rev,\n")
					.append("	standard_guide,\n")
					.append("	standard_value,\n")
					.append("	check_note,\n") // 20
					.append("	write_date,\n")
					.append("	cust_cd,\n")
					.append("	cust_cd_rev,\n")
					.append("	check_object,\n")
					.append("	cust_nm,\n")
					.append("	boss_name,\n")
					.append("	jongmok,\n")
					.append("	bizno,\n")
					.append("	address,\n")
					.append("	telno,\n")
					.append("	checker_dept,\n")
					.append("	D.code_name,\n")
					.append("	checker_dept_2,\n")
					.append("	confirm_dept,\n")
					.append("	checker_title,\n")
					.append("	checker_title_2,\n")
					.append("	confirm_title\n")
					.append("FROM\n")
					.append("	haccp_inout_check_result A\n")
					.append("INNER JOIN v_checklist_gubun E\n")
					.append("	ON A.check_gubun = E.code_value\n")
					.append("	AND A.member_key = E.member_key\n")
					.append("LEFT OUTER JOIN v_dept_code D\n")
					.append("	ON A.checker_dept = D.code_value\n")
					.append("	AND A.member_key = D.member_key\n")
					.append("INNER JOIN tbm_users U1\n")
					.append("	ON A.checker_main=U1.user_id\n")
					.append("	AND A.checker_main_rev=U1.revision_no	\n")
					.append("	AND A.member_key=U1.member_key	\n")
					.append("WHERE check_date='" + jArray.get("check_date") + "'\n")
					.append("	AND check_time='" + jArray.get("check_time") + "'\n")
					.append("	AND cust_cd='" + jArray.get("cust_cd") + "'\n")
					.append("	AND cust_cd_rev='" + jArray.get("cust_cd_rev") + "'\n")
					.append(" 	AND A.member_key = '" + jArray.get("member_key") + "' \n") //member_key_select, update, delete
					.append("ORDER BY check_date, check_time, checklist_cd, checklist_seq  \n")
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
			LoggingWriter.setLogError("M838S050300E144()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M838S050300E144()","==== finally ===="+ e.getMessage());
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
	
	// T838S050300.jsp 등록화면(Tablet)
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
					.append("INSERT INTO \n")
					.append("	haccp_inout_check_result ( \n")
					.append("		check_date,\n")
					.append("		check_time,\n")
					.append("		check_gubun,\n")
					.append("		checklist_cd,\n")
					.append("		cheklist_cd_rev,\n")
					.append("		checklist_seq,\n")
					.append("		item_cd,\n")
					.append("		item_seq,\n")
					.append("		item_cd_rev,\n")
					.append("		check_note,\n")
					.append("		standard_guide,\n")
					.append("		standard_value,\n")
					.append("		check_value,\n")
					
					.append("		checker_dept,\n")
					.append("		checker_title,\n")
					.append("		checker_main,\n")
					.append("		checker_main_rev,\n")
					.append("		checker_dept_2,\n")
					.append("		checker_title_2,\n")
					.append("		checker_second,\n")
					.append("		checker_second_rev,\n")
					.append("		confirm_dept,\n")
					.append("		confirm_title,\n")
					.append("		confirm_user,\n")
					.append("		confirm_user_rev,\n")
					
					.append("		cust_cd,\n")
					.append("		cust_cd_rev,\n")
					.append("		cust_nm,\n")
					.append("		boss_name,\n")
					.append("		jongmok,\n")
					.append("		bizno,\n")
					.append("		address,\n")
					.append("		telno,\n")
					.append("		check_object,\n")
					.append("		write_date\n")
					.append(" 		,member_key	\n") // member_key_insert

					.append("	) VALUES ( \n")
 					.append(" 		'"	+ jjjArray.get("check_date") 		+ "',	\n")
 					.append(" 		'"	+ jjjArray.get("check_time") 		+ "',	\n")
 					.append(" 		'"	+ jjjArray.get("check_gubun") 		+ "',	\n")
 					.append(" 		'"	+ jjjArray.get("checklist_cd") 		+ "',	\n")
 					.append(" 		'"	+ jjjArray.get("cheklist_cd_rev") 	+ "',	\n")
 					.append(" 		'"	+ jjjArray.get("checklist_seq") 	+ "',	\n")
 					.append(" 		'"	+ jjjArray.get("item_cd") 			+ "',	\n")
 					.append(" 		'"	+ jjjArray.get("item_seq") 			+ "',	\n")
 					.append(" 		'"	+ jjjArray.get("item_cd_rev") 		+ "',	\n")
 					.append(" 		'"	+ jjjArray.get("check_note") 		+ "',	\n")
 					.append(" 		'"	+ jjjArray.get("standard_guide") 	+ "',	\n")
 					.append(" 		'"	+ jjjArray.get("standard_value") 	+ "',	\n")
 					.append(" 		'"	+ jjjArray.get("check_value") 		+ "',	\n")
 					
 					.append(" 		'"	+ jjjArray.get("checker_dept") 		 + "',	\n")
 					.append(" 		'"	+ jjjArray.get("checker_title") 	 + "',	\n")
 					.append(" 		'"	+ jjjArray.get("checker_main")		 + "',	\n")
 					.append(" 		'"	+ jjjArray.get("checker_main_rev") 	 + "',	\n")
 					.append(" 		'"	+ jjjArray.get("checker_dept_2") 	 + "',	\n")
 					.append(" 		'"	+ jjjArray.get("checker_title_2") 	 + "',	\n")
 					.append(" 		'"	+ jjjArray.get("checker_second") 	 + "',	\n")
 					.append(" 		'"	+ jjjArray.get("checker_second_rev") + "',	\n")
 					.append(" 		'"	+ jjjArray.get("confirm_dept") 		 + "',	\n")
 					.append(" 		'"	+ jjjArray.get("confirm_title") 	 + "',	\n")
 					.append(" 		'"	+ jjjArray.get("confirm_user") 		 + "',	\n")
 					.append(" 		'"	+ jjjArray.get("confirm_user_rev") 	 + "',	\n")
 					
 					.append(" 		'"	+ jjjArray.get("cust_cd") + "',	\n")
 					.append(" 		'"	+ jjjArray.get("cust_cd_rev") + "',	\n")
 					.append(" 		'"	+ jjjArray.get("cust_nm") + "',	\n")
 					.append(" 		'"	+ jjjArray.get("boss_name") + "',	\n")
 					.append(" 		'"	+ jjjArray.get("jongmok") + "',	\n")
 					.append(" 		'"	+ jjjArray.get("bizno") + "',	\n")
 					.append(" 		'"	+ jjjArray.get("address") + "',	\n")
 					.append(" 		'"	+ jjjArray.get("telno") + "',	\n")
 					.append(" 		'"	+ jjjArray.get("check_object") + "',	\n")
 					.append(" 		'"	+ jjjArray.get("write_date") + "'	\n")
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
			LoggingWriter.setLogError("M838S050300E101()","==== SQL ERROR ===="+ e.getMessage());
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
	
	// S838S050302.jsp 수정
	public int E102(InoutParameter ioParam){ 
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
					.append("UPDATE\n")
					.append("	haccp_inout_check_result\n")
					.append("SET\n")
					.append("	check_date='" 		+ jjjArray.get("check_date") + "',\n")
					.append("	check_time='" 		+ jjjArray.get("check_time") + "',\n")
					.append("	check_gubun='" 		+ jjjArray.get("check_gubun") + "',\n")
					.append("	checklist_cd='" 	+ jjjArray.get("checklist_cd") + "',\n")
					.append("	cheklist_cd_rev='" 	+ jjjArray.get("cheklist_cd_rev") + "',\n")
					.append("	checklist_seq='" 	+ jjjArray.get("checklist_seq") + "',\n")
					.append("	item_cd='" 			+ jjjArray.get("item_cd") + "',\n")
					.append("	item_seq='" 		+ jjjArray.get("item_seq") + "',\n")
					.append("	item_cd_rev='" 		+ jjjArray.get("item_cd_rev") + "',\n")
					.append("	check_note='" 		+ jjjArray.get("check_note") + "',\n")
					.append("	standard_guide='" 	+ jjjArray.get("standard_guide") + "',\n")
					.append("	standard_value='" 	+ jjjArray.get("standard_value") + "',\n")
					.append("	check_value='" 		+ jjjArray.get("check_value") + "',\n")
					
					.append("	checker_dept='" 	+ jjjArray.get("checker_dept") + "',\n")
					.append("	checker_title='" 	+ jjjArray.get("checker_title") + "',\n")
					.append("	checker_main='" 	+ jjjArray.get("checker_main") + "',\n")
					.append("	checker_main_rev='" + jjjArray.get("checker_main_rev") + "',\n")
					.append("	checker_dept_2='" 	+ jjjArray.get("checker_dept_2") + "',\n")
					.append("	checker_title_2='" 	+ jjjArray.get("checker_title_2") + "',\n")
					.append("	checker_second='" 	+ jjjArray.get("checker_second") + "',\n")
					.append("	checker_second_rev='" + jjjArray.get("checker_second_rev") + "',\n")
					.append("	confirm_dept='" 	+ jjjArray.get("confirm_dept") + "',\n")
					.append("	confirm_title='" 	+ jjjArray.get("confirm_title") + "',\n")
					.append("	confirm_user='" 	+ jjjArray.get("confirm_user") + "',\n")
					.append("	confirm_user_rev='" + jjjArray.get("confirm_user_rev") + "',\n")
					
					.append("	cust_cd='" 			+ jjjArray.get("cust_cd") + "',\n")
					.append("	cust_cd_rev='" 		+ jjjArray.get("cust_cd_rev") + "',\n")
					.append("	cust_nm='" 			+ jjjArray.get("cust_nm") + "',\n")
					.append("	boss_name='" 		+ jjjArray.get("boss_name") + "',\n")
					.append("	jongmok='" 			+ jjjArray.get("jongmok") + "',\n")
					.append("	bizno='" 			+ jjjArray.get("bizno") + "',\n")
					.append("	address='" 			+ jjjArray.get("address") + "',\n")
					.append("	telno='" 			+ jjjArray.get("telno") + "',\n")
					.append("	check_object='" 	+ jjjArray.get("check_object") + "',\n")
					.append("	write_date='" 		+ jjjArray.get("write_date") + "',\n")
					.append(" 	member_key='" 		+ jjjArray.get("member_key") + "'\n")
					
					.append("WHERE check_date='" 	+ jjjArray.get("check_date") + "'\n")
					.append("	AND check_time='" 	+ jjjArray.get("check_time") + "'\n")
//					.append("	AND cust_cd='" 		+ jjjArray.get("cust_cd") + "'\n")
//					.append("	AND cust_cd_rev='" 	+ jjjArray.get("cust_cd_rev") + "'\n")
					.append("	AND checklist_cd='" 	+ jjjArray.get("checklist_cd") + "'\n")
					.append("	AND cheklist_cd_rev='" 	+ jjjArray.get("cheklist_cd_rev") + "'\n")
					.append("	AND checklist_seq='" 	+ jjjArray.get("checklist_seq") + "'\n")
					.append("	AND member_key = '" + jjjArray.get("member_key") + "'\n")
					
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
			LoggingWriter.setLogError("M838S050300E102()","==== SQL ERROR ===="+ e.getMessage());
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
	
	// S838S050303.jsp 삭제
	public int E103(InoutParameter ioParam){ 
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
    		JSONObject jjjArray0 = (JSONObject) jjArray.get(0);
    		
    		
			String sql = new StringBuilder()
				.append("DELETE FROM haccp_inout_check_result \n")
				.append("WHERE check_date='" 	+ jjjArray0.get("check_date") + "'\n")
				.append("	AND check_time='" 	+ jjjArray0.get("check_time") + "'\n")
				.append("	AND cust_cd='" 		+ jjjArray0.get("cust_cd") + "'\n")
				.append("	AND cust_cd_rev='" 	+ jjjArray0.get("cust_cd_rev") + "'\n")
				.append("	AND member_key = '" + jjjArray0.get("member_key") + "'\n")
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
			LoggingWriter.setLogError("M838S050300E103()","==== SQL ERROR ===="+ e.getMessage());
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