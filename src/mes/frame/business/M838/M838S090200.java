package mes.frame.business.M838;

import java.lang.reflect.Method;
import java.sql.Connection;
import java.sql.PreparedStatement;

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

/**
 * 개요 : 이벤트ID별 메소드 정의
 */
public  class M838S090200 extends SqlAdapter{
	Connection con = null;
	PreparedStatement pstmt = null;
	String resultString = "";
	int resultInt = -1;
	StringBuffer sql = new StringBuffer();
	
	String[][] v_paramArray = new String[0][0]; 
	Class[] optClass = null;
	Object[] optObj = null;
	Object obj = null;
	
	public M838S090200(){
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
			
			Method method = M838S090200.class.getMethod(event,optClass);
			LoggingWriter.setLogDebug(M838S090200.class.getName(),"==== " + event + " EventMethod Create Success ====");

			obj = method.invoke(M838S090200.class.newInstance(),optObj);
			doExcute_result = CommonFunction.getInt(obj.toString());
			
	    } catch (Exception ex) {
	    	doExcute_result = EventDefine.E_DOEXCUTE_INIT;
			ioParam.setMessage(MessageDefine.M_NO_EVENTID);
			LoggingWriter.setLogError(M838S090200.class.getName(),"==== EventID Not define : EVENT ID [ " + ioParam.getEventID() + "]");
	    } finally {
	    	obj = null;
			optClass = null;
			optObj = null;
	    }
	    long endTime = System.currentTimeMillis();
		long runningTime = endTime - startTime;
		LoggingWriter.setLogAll(M838S090200.class.getName(),"==== Query [수행시간  : " + runningTime + " ms]");
		
		return doExcute_result;
	}
	
	// 클레임 일지 등록
	public int E101(InoutParameter ioParam){ 
		resultInt = EventDefine.E_DOEXCUTE_INIT;

		try {
			con = JDBCConnectionPool.getConnection();
			con.setAutoCommit(false);
			
    		JSONObject jArray = new JSONObject();
    		jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
    		System.out.println("JSONObject jArray rcvData="+ jArray.toString());

    		String checklist_id = jArray.get("checklist_id").toString().trim();
    		
    		String sql = new StringBuilder()
    				.append("INSERT INTO										\n")
    				.append("	haccp_claim (									\n")
    				.append("		checklist_id,								\n")
    				.append("		checklist_rev_no,							\n")
    				.append("		claim_date,									\n")
    				.append(" 		person_receipt,								\n")
    				.append("		claim_detail, 								\n")
    				.append("		person_report, 								\n")
    				.append("		person_report_addr, 						\n")
    				.append("		company_action, 			 	 			\n")
    				.append("		customer_action, 	 				 		\n")
    				.append("		person_write_id 		 		 			\n")
    				.append(" 		)						 		 			\n")
    				.append("VALUES (											\n")
					.append(" 		'"+checklist_id+"',							\n")
    				.append("		(SELECT MAX(checklist_rev_no)				\n")
    				.append("		FROM checklist								\n")
    				.append("		WHERE checklist_id = '"+checklist_id+"'),	\n")
					.append(" 		'"	+ jArray.get("claim_date") + "',		\n")
					.append(" 		'"	+ jArray.get("person_receipt") + "',	\n")
					.append(" 		'"	+ jArray.get("claim_detail") + "',		\n")
					.append(" 		'"	+ jArray.get("person_report") + "',		\n")
					.append(" 		'"	+ jArray.get("person_report_addr") + "',\n")
					.append(" 		'"	+ jArray.get("company_action") + "',	\n")
					.append(" 		'"	+ jArray.get("customer_action") + "',	\n")
					.append(" 		'" + jArray.get("person_write_id") + "' 	\n")
					.append("	) 												\n")
					.toString();
		
			resultInt = super.excuteUpdate(con, sql.toString());
	    	if(resultInt < 0){
				ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
				con.rollback();
				return EventDefine.E_DOEXCUTE_ERROR ;
			}
			con.commit();
		} catch(Exception e) {
			e.getStackTrace();
			LoggingWriter.setLogError("M838S090200E101()","==== SQL ERROR ===="+ e.getMessage());
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
	
	// 클레임 일지 수정
	public int E102(InoutParameter ioParam){ 
		resultInt = EventDefine.E_DOEXCUTE_INIT;

		try {
			con = JDBCConnectionPool.getConnection();
			con.setAutoCommit(false);
			
    		JSONObject jArray = new JSONObject();
    		jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
    		System.out.println("JSONObject jArray rcvData="+ jArray.toString());

    		String sql = new StringBuilder()
    				.append("UPDATE																	\n")
    				.append("	haccp_claim SET									  					\n")
    				.append("		claim_date 		 = '"	+ jArray.get("claim_date") + "', 		\n")
    				.append("		person_receipt 	 = '"	+ jArray.get("person_receipt") + "', 	\n")
    				.append("		claim_detail 	 = '"	+ jArray.get("claim_detail") + "',		\n")
    				.append("		person_report 	 = '"	+ jArray.get("person_report") + "', 	\n")
    				.append("		person_report_addr = '"	+ jArray.get("person_report_addr") + "',\n")
    				.append("		company_action   = '"	+ jArray.get("company_action") + "', 	\n")
    				.append("		customer_action   = '"	+ jArray.get("customer_action") + "', 	\n")
    				.append("		person_write_id  = '" + jArray.get("person_write_id") + "', 	\n")
    				.append("		person_check_id  = '', 		\n")
    				.append("		person_approve_id  = '' 		\n")
    				.append("WHERE seq_no = 		'"+ jArray.get("seq_no") + "'				\n")
    				.append("  AND checklist_id =  	'" + jArray.get("checklist_id") + "'		\n")
    				.append("  AND checklist_rev_no =  	" + jArray.get("checklist_rev_no") + " 	\n")
    				.append("  AND claim_date =  	'" + jArray.get("org_claim_date") + "' 		\n")
					.toString();
		
			resultInt = super.excuteUpdate(con, sql.toString());
	    	if(resultInt < 0){
				ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
				con.rollback();
				return EventDefine.E_DOEXCUTE_ERROR ;
			}
			con.commit();
		} catch(Exception e) {
			e.getStackTrace();
			LoggingWriter.setLogError("M838S090200E102()","==== SQL ERROR ===="+ e.getMessage());
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
	
	// 클레임 일지 삭제
	public int E103(InoutParameter ioParam){ 
		resultInt = EventDefine.E_DOEXCUTE_INIT;

		try {
			con = JDBCConnectionPool.getConnection();
			con.setAutoCommit(false);
			
    		JSONObject jArray = new JSONObject();
    		jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
    		System.out.println("JSONObject jArray rcvData="+ jArray.toString());
			
    		String sql = new StringBuilder()
    				.append("DELETE FROM													 \n")
    				.append("	haccp_claim 												 \n")
    				.append("WHERE seq_no = 		'"+ jArray.get("seq_no") + "'			 \n")
    				.append("AND   checklist_id =  	'"+ jArray.get("checklist_id") + "' 		\n")
    				.append("AND   checklist_rev_no =  	'"+ jArray.get("checklist_rev_no") + "' \n")
					.toString();
		
			resultInt = super.excuteUpdate(con, sql.toString());
	    	if(resultInt < 0){
				ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
				con.rollback();
				return EventDefine.E_DOEXCUTE_ERROR ;
			}
			con.commit();
		} catch(Exception e) {
			e.getStackTrace();
			LoggingWriter.setLogError("M838S090200E103()","==== SQL ERROR ===="+ e.getMessage());
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

	// 고객 불평·불만 접수 및 처리 기록부 메인 조회
	public int E104(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));

			String sql = new StringBuilder()
					.append("SELECT\n")
					.append("	checklist_id,\n")
					.append("	checklist_rev_no,\n")
					.append("	claim_date,\n")
					.append("	seq_no,\n")
					.append("	person_receipt,\n")
					.append("	REPLACE(REPLACE(claim_detail, CHR(13), ' '), CHR(10), ' '),\n")
					.append("	person_report,\n")
					.append("	person_report_addr,\n")
					.append("	company_action,\n")
					.append("	customer_action,\n")
					.append("	B.user_nm AS person_write_id,\n")
					.append("	B2.user_nm AS person_check_id,\n")
					.append("	B3.user_nm AS person_approve_id\n")
					.append("FROM\n")
					.append("	haccp_claim A\n")
					.append("	LEFT JOIN tbm_users B\n")
					.append("	ON A.person_write_id = B.user_id\n")
					.append("	AND A.claim_date BETWEEN B.start_date AND B.duration_date\n")
					.append("	LEFT 	JOIN tbm_users B2\n")
					.append("	ON A.person_check_id = B2.user_id\n")
					.append("	AND A.claim_date BETWEEN B2.start_date AND B2.duration_date	\n")
					.append("	LEFT 	JOIN tbm_users B3\n")
					.append("	ON A.person_approve_id = B3.user_id\n")
					.append("	AND A.claim_date BETWEEN B3.start_date AND B3.duration_date\n")
					.append("WHERE A.claim_date Between '"+ jArray.get("fromdate") + "' \n")
					.append("                   AND '"+ jArray.get("todate") + "' 		\n")
					.append("ORDER BY claim_date DESC, seq_no DESC\n")
					.toString();

			String ActionCommand = ioParam.getActionCommand();
			if(ActionCommand.startsWith("doQueryTableFieldName")) {
				resultString = super.excuteQueryStringTableFieldName(con, sql.toString());
			} else {
				resultString = super.excuteQueryString(con, sql.toString());
			}
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M838S090200E104()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) {
						con.close();
					}
				} catch (Exception e) {
					LoggingWriter.setLogError("M838S090200E104()","==== finally ===="+ e.getMessage());
				}
	    	}
	    }

		ioParam.setResultString(resultString);
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
    	ioParam.setMessage(MessageDefine.M_QUERY_OK);

    	return EventDefine.E_QUERY_RESULT;
	}
	
	// 캔버스 조회 겸 수정하기 전 데이터
	public int E144(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			
			String sql = new StringBuilder()
					.append("SELECT\n")
					.append("	checklist_id,\n")
					.append("	checklist_rev_no,\n")
					.append("	seq_no,\n")
					.append("	claim_date,\n")
					.append("	person_receipt,\n")
					.append("	claim_detail,\n")
					.append("	person_report,\n")
					.append("	person_report_addr,\n")
					.append("	company_action,\n")
					.append("	customer_action,\n")
					.append("	B.user_nm AS person_write_id,\n")
					.append("	B2.user_nm AS person_check_id,\n")
					.append("	B3.user_nm AS person_approve_id\n")
					.append("FROM\n")
					.append("	haccp_claim A\n")
					.append("	LEFT JOIN tbm_users B\n")
					.append("	ON A.person_write_id = B.user_id\n")
					.append("	AND A.claim_date BETWEEN B.start_date AND B.duration_date\n")
					.append("	LEFT 	JOIN tbm_users B2\n")
					.append("	ON A.person_check_id = B2.user_id\n")
					.append("	AND A.claim_date BETWEEN B2.start_date AND B2.duration_date	\n")
					.append("	LEFT 	JOIN tbm_users B3\n")
					.append("	ON A.person_approve_id = B3.user_id\n")
					.append("	AND A.claim_date BETWEEN B3.start_date AND B3.duration_date\n")
					.append("WHERE\n")
					.append("	seq_no = "+jArray.get("seq_no").toString()+"\n")
					.append("	AND checklist_id = '"+jArray.get("checklist_id").toString()+"'\n")
					.append("	AND checklist_rev_no = "+jArray.get("checklist_rev_no").toString()+"\n")
					.toString();
			
			String ActionCommand = ioParam.getActionCommand();
			if(ActionCommand.startsWith("doQueryTableFieldName")) {
				resultString = super.excuteQueryStringTableFieldName(con, sql.toString());
			} else {
				resultString = super.excuteQueryString(con, sql.toString());
			}
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M838S090200E144()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M838S090200E144()","==== finally ===="+ e.getMessage());
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
	
	// 점검표 승인자 서명
	public int E502(InoutParameter ioParam){ 
		
		resultInt = EventDefine.E_DOEXCUTE_INIT;

		try {
			con = JDBCConnectionPool.getConnection();
			con.setAutoCommit(false);
			
    		JSONObject jObj = new JSONObject();
    		jObj = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
    		
    		String sql = new StringBuilder()
    				.append("UPDATE haccp_claim											\n")
    				.append("SET														\n")
    				.append("	person_approve_id = '" + jObj.get("userId") + "'		\n")
    				.append("WHERE claim_date = '"+ jObj.get("checklistDate") + "'		\n")
    				.append("  AND checklist_id = '"+ jObj.get("checklistId") + "'		\n")
    				.append("  AND checklist_rev_no = '"+ jObj.get("checklistRevNo") + "'\n")
    				.append("  AND seq_no = '"+ jObj.get("seq_no") + "'					\n")
					.toString();
		
			resultInt = super.excuteUpdate(con, sql);
	    	if(resultInt < 0){
				ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
				con.rollback();
				return EventDefine.E_DOEXCUTE_ERROR ;
			}
			con.commit();
		} catch(Exception e) {
			e.getStackTrace();
			LoggingWriter.setLogError("M838S090200E502()","==== SQL ERROR ===="+ e.getMessage());
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

	// 점검표 확인자 서명
	public int E522(InoutParameter ioParam){ 
		
		resultInt = EventDefine.E_DOEXCUTE_INIT;

		try {
			con = JDBCConnectionPool.getConnection();
			con.setAutoCommit(false);
			
    		JSONObject jObj = new JSONObject();
    		jObj = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
    		
    		String sql = new StringBuilder()
    				.append("UPDATE haccp_claim											\n")
    				.append("SET														\n")
    				.append("	person_check_id = '" + jObj.get("userId") + "'			\n")
    				.append("WHERE claim_date = '"+ jObj.get("checklistDate") + "'		\n")
    				.append("  AND checklist_id = '"+ jObj.get("checklistId") + "'		\n")
    				.append("  AND checklist_rev_no = '"+ jObj.get("checklistRevNo") + "'	\n")
    				.append("  AND seq_no = '"+ jObj.get("seq_no") + "'					\n")
					.toString();
		
			resultInt = super.excuteUpdate(con, sql);
	    	if(resultInt < 0){
				ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
				con.rollback();
				return EventDefine.E_DOEXCUTE_ERROR ;
			}
			con.commit();
		} catch(Exception e) {
			e.getStackTrace();
			LoggingWriter.setLogError("M838S090200E502()","==== SQL ERROR ===="+ e.getMessage());
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