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
public  class M838S070800 extends SqlAdapter{
	Connection con = null;
	PreparedStatement pstmt = null;
	String resultString = "";
	int resultInt = -1;
	StringBuffer sql = new StringBuffer();
	
	String[][] v_paramArray = new String[0][0]; 
	Class[] optClass = null;
	Object[] optObj = null;
	Object obj = null;
	
	public M838S070800(){
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
			
			Method method = M838S070800.class.getMethod(event,optClass);
			LoggingWriter.setLogDebug(M838S070800.class.getName(),"==== " + event + " EventMethod Create Success ====");

			obj = method.invoke(M838S070800.class.newInstance(),optObj);
			doExcute_result = CommonFunction.getInt(obj.toString());
			
	    } catch (Exception ex) {
	    	doExcute_result = EventDefine.E_DOEXCUTE_INIT;
			ioParam.setMessage(MessageDefine.M_NO_EVENTID);
			LoggingWriter.setLogError(M838S070800.class.getName(),"==== EventID Not define : EVENT ID [ " + ioParam.getEventID() + "]");
	    } finally {
	    	obj = null;
			optClass = null;
			optObj = null;
	    }
	    long endTime = System.currentTimeMillis();
		long runningTime = endTime - startTime;
		LoggingWriter.setLogAll(M838S070800.class.getName(),"==== Query [수행시간  : " + runningTime + " ms]");
		
		return doExcute_result;
	}
	
	// S838S070800.jsp
	public int E104(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			System.out.println("JSONObject jArray rcvData="+ jArray.toString());
    		
			String sql = new StringBuilder()
					.append("SELECT DISTINCT\n")
					.append("	A.check_gubun,\n")
					.append("	check_date,\n")
					.append("	deviations_subject,\n")
					.append("	improvement,\n")
					.append("	total_bigo,\n")
					.append("	A.writor,\n")
					.append("	A.writor_rev,\n")
					.append("	U1.user_nm,\n")
					.append("	write_date,\n")
					.append("	A.approval,\n")
					.append("	A.approval_rev,\n")
					.append("	U2.user_nm,\n")
					.append("	approve_date\n")
					.append("FROM\n")
					.append("	haccp_nonmetal_foreign_manage A\n")
					.append("INNER JOIN v_checklist_gubun E\n")
					.append("	ON A.check_gubun = E.code_value\n")
					.append("	AND A.member_key = E.member_key\n")
					.append("INNER JOIN tbm_users U1\n")
					.append("	ON A.writor=U1.user_id\n")
					.append("	AND A.writor_rev=U1.revision_no\n")
					.append("	AND A.member_key=U1.member_key\n")
					.append("LEFT OUTER JOIN tbm_users U2\n")
					.append("	ON A.approval=U2.user_id\n")
					.append("	AND A.approval_rev=U2.revision_no\n")
					.append("	AND A.member_key=U2.member_key\n")
					.append("WHERE check_date \n")
					.append("		BETWEEN '" + jArray.get("fromdate") + "' 	\n")
					.append("			AND '" + jArray.get("todate") + "'	\n")
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
			LoggingWriter.setLogError("M838S070800E104()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M838S070800E104()","==== finally ===="+ e.getMessage());
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
	
	// S838S070810.jsp
	public int E114(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			System.out.println("JSONObject jArray rcvData="+ jArray.toString());
    		
			String sql = new StringBuilder()
					.append("SELECT\n")
					.append("	checklist_seq,\n")
					.append("	A.working_process,\n")
					.append("	M.code_name,\n")
					.append("	A.inspection_point,\n")
					.append("	S.code_name,\n")
					.append("	latent_foreign_possiblity,\n")
					.append("	measure,\n")
					.append("	measure_yn,\n")
					.append("	inspection_result,\n")
					.append("	bigo\n")
					.append("FROM\n")
					.append("	haccp_nonmetal_foreign_manage A\n")
					.append("INNER JOIN v_checklist_gubun E\n")
					.append("	ON A.check_gubun = E.code_value\n")
					.append("	AND A.member_key = E.member_key\n")
					.append("INNER JOIN v_checklist_gubun_mid M\n")
					.append("	ON A.check_gubun = M.code_cd\n")
					.append("	AND A.working_process = M.code_value\n") // check_gubun_mid
					.append("	AND A.member_key = M.member_key\n")
					.append("INNER JOIN v_checklist_gubun_sm S\n")
					.append("	ON A.check_gubun = S.code_cd_big\n")
					.append("	AND A.working_process = S.code_cd\n") // check_gubun_mid
					.append("	AND A.inspection_point = S.code_value\n") // check_gubun_sm
					.append("	AND A.member_key = S.member_key\n")
					.append("WHERE check_date='" + jArray.get("check_date") + "'\n")
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
			LoggingWriter.setLogError("M838S070800E114()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M838S070800E114()","==== finally ===="+ e.getMessage());
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
	
	// T838S070800.jsp 등록화면(Tablet)
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
					.append("LEFT OUTER JOIN v_checklist_gubun_mid F\n")
//						.append("INNER JOIN v_checklist_gubun_mid F\n")
					.append("	ON A.check_gubun = F.code_cd\n")
					.append("	AND A.check_gubun_mid = F.code_value\n")
					.append("	AND A.member_key = F.member_key\n")
					.append("LEFT OUTER JOIN v_checklist_gubun_sm G\n")
//						.append("INNER JOIN v_checklist_gubun_sm G\n")
					.append("	ON A.check_gubun = G.code_cd_big\n")
					.append("	AND A.check_gubun_mid = G.code_cd\n")
					.append("	AND A.check_gubun_sm = G.code_value\n")
					.append("	AND A.member_key = G.member_key\n")
					.append("where A.check_gubun like '" + jArray.get("check_gubun") + "%'\n")
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
			LoggingWriter.setLogError("M838S070800E134()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M838S070800E134()","==== finally ===="+ e.getMessage());
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
	
	// S838S070800_canvas.jsp
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
					.append("	deviations_subject,\n")
					.append("	improvement,\n")
					.append("	total_bigo,\n")
					.append("	U1.user_nm,\n") // .append("A.writor,\n").append("A.writor_rev,\n")
					.append("	write_date,\n")
					.append("	U2.user_nm,\n") // .append("A.approval,\n").append("A.approval_rev,\n")
					.append("	approve_date,\n")
					.append("	M.code_name,\n") // .append("A.working_process,\n")
					.append("	S.code_name,\n") // .append("A.inspection_point,\n")
					.append("	latent_foreign_possiblity,\n")
					.append("	measure,\n")
					.append("	measure_yn,\n")
					.append("	inspection_result,\n")
					.append("	bigo\n")
					.append("FROM\n")
					.append("	haccp_nonmetal_foreign_manage A\n")
					.append("INNER JOIN tbm_users U1\n")
					.append("	ON A.writor=U1.user_id\n")
					.append("	AND A.writor_rev=U1.revision_no\n")
					.append("	AND A.member_key=U1.member_key\n")
					.append("LEFT OUTER JOIN tbm_users U2\n")
					.append("	ON A.approval=U2.user_id\n")
					.append("	AND A.approval_rev=U2.revision_no\n")
					.append("	AND A.member_key=U2.member_key\n")
					.append("INNER JOIN v_checklist_gubun_mid M\n")
					.append("	ON A.check_gubun = M.code_cd\n")
					.append("	AND A.working_process = M.code_value\n")
					.append("	AND A.member_key = M.member_key\n")
					.append("INNER JOIN v_checklist_gubun_sm S\n")
					.append("	ON A.check_gubun = S.code_cd_big\n")
					.append("	AND A.working_process = S.code_cd\n")
					.append("	AND A.inspection_point = S.code_value\n")
					.append("	AND A.member_key = S.member_key\n")
					.append("WHERE A.check_date='" + jArray.get("check_date") + "'\n")
					.append("	AND A.member_key = '" + jArray.get("member_key") + "' \n")
					.append("ORDER BY A.checklist_seq\n")
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
			LoggingWriter.setLogError("M838S070800E144()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M838S070800E144()","==== finally ===="+ e.getMessage());
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
	
	// T838S070800.jsp 등록화면(Tablet)
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
						.append("MERGE INTO haccp_nonmetal_foreign_manage mm \n")
						.append("USING ( \n")
						.append("	SELECT \n")
						.append(" 		'"	+ jjjArray.get("check_date") 		+ "' AS check_date, \n")
	 					.append(" 		'"	+ jjjArray.get("check_gubun") 		+ "' AS check_gubun, \n")
	 					.append(" 		'"	+ jjjArray.get("checklist_seq") 	+ "' AS checklist_seq, \n")
	 					.append(" 		'"	+ jjjArray.get("working_process") 	+ "' AS working_process, \n") // check_gubun_mid
	 					.append(" 		'"	+ jjjArray.get("inspection_point") 	+ "' AS inspection_point, \n") // check_gubun_sm
	 					.append(" 		'"	+ jjjArray.get("latent_foreign_possiblity") + "' AS latent_foreign_possiblity, \n") // check_note
	 					.append(" 		'"	+ jjjArray.get("measure") 			+ "' AS measure, \n") // standard_guide
	 					.append(" 		'"	+ jjjArray.get("measure_yn") 		+ "' AS measure_yn, \n")
	 					.append(" 		'"	+ jjjArray.get("inspection_result") + "' AS inspection_result, \n")
	 					.append(" 		'"	+ jjjArray.get("bigo") 				+ "' AS bigo, \n")
	 					.append(" 		'"	+ jjjArray.get("deviations_subject")+ "' AS deviations_subject, \n")
	 					.append(" 		'"	+ jjjArray.get("improvement") 		+ "' AS improvement, \n")
	 					.append(" 		'"	+ jjjArray.get("total_bigo") 		+ "' AS total_bigo, \n")
	 					.append(" 		'"	+ jjjArray.get("writor") 			+ "' AS writor, \n")
	 					.append(" 		'"	+ jjjArray.get("writor_rev") 		+ "' AS writor_rev, \n")
	 					.append(" 		'"	+ jjjArray.get("write_date") 		+ "' AS write_date, \n")
	 					.append(" 		'"	+ jjjArray.get("approval") 			+ "' AS approval, \n")
	 					.append(" 		'"	+ jjjArray.get("approval_rev") 		+ "' AS approval_rev, \n")
	 					.append(" 		'"	+ jjjArray.get("approve_date") 		+ "' AS approve_date, \n")
	 					.append(" 		'" + jjjArray.get("member_key") 		+ "' AS member_key \n")
	 					.append("	FROM db_root ) mQ \n")
						.append("ON ( mm.check_date = mQ.check_date AND mm.check_gubun = mQ.check_gubun \n")
						.append("	  AND mm.checklist_seq = mQ.checklist_seq AND mm.member_key = mQ.member_key ) \n")
						.append("WHEN MATCHED THEN \n")
						.append("	UPDATE SET \n")
						.append("		mm.check_date = mQ.check_date, \n")
						.append("		mm.check_gubun = mQ.check_gubun, \n")
						.append("		mm.checklist_seq = mQ.checklist_seq, \n")
						.append("		mm.working_process = mQ.working_process, \n")
						.append("		mm.inspection_point = mQ.inspection_point, \n")
						.append("		mm.latent_foreign_possiblity = mQ.latent_foreign_possiblity, \n")
						.append("		mm.measure = mQ.measure, \n")
						.append("		mm.measure_yn = mQ.measure_yn, \n")
						.append("		mm.inspection_result = mQ.inspection_result, \n")
						.append("		mm.bigo = mQ.bigo, \n")
						.append("		mm.deviations_subject = mQ.deviations_subject, \n")
						.append("		mm.improvement = mQ.improvement, \n")
						.append("		mm.total_bigo = mQ.total_bigo, \n")
						.append("		mm.writor = mQ.writor, \n")
						.append("		mm.writor_rev = mQ.writor_rev, \n")
						.append("		mm.write_date = mQ.write_date, \n")
						.append("		mm.approval = mQ.approval, \n")
						.append("		mm.approval_rev = mQ.approval_rev, \n")
						.append("		mm.approve_date = mQ.approve_date, \n")
						.append("		mm.member_key = mQ.member_key \n")
						.append("WHEN NOT MATCHED THEN \n")
						.append("	INSERT ( \n")
						.append("		mm.check_date, mm.check_gubun, mm.checklist_seq, \n")
						.append("		mm.working_process, mm.inspection_point, \n")
						.append("		mm.latent_foreign_possiblity, mm.measure, \n")
						.append("		mm.measure_yn, mm.inspection_result, mm.bigo, \n")
						.append("		mm.deviations_subject, mm.improvement, mm.total_bigo, \n")
						.append("		mm.writor, mm.writor_rev, mm.write_date, \n")
						.append("		mm.approval, mm.approval_rev, mm.approve_date, \n")
						.append("		mm.member_key \n")
						.append("	) VALUES ( \n")
						.append("		mQ.check_date, mQ.check_gubun, mQ.checklist_seq, \n")
						.append("		mQ.working_process, mQ.inspection_point, \n")
						.append("		mQ.latent_foreign_possiblity, mQ.measure, \n")
						.append("		mQ.measure_yn, mQ.inspection_result, mQ.bigo, \n")
						.append("		mQ.deviations_subject, mQ.improvement, mQ.total_bigo, \n")
						.append("		mQ.writor, mQ.writor_rev, mQ.write_date, \n")
						.append("		mQ.approval, mQ.approval_rev, mQ.approve_date, \n")
						.append("		mQ.member_key \n")
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
			LoggingWriter.setLogError("M838S070800E101()","==== SQL ERROR ===="+ e.getMessage());
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