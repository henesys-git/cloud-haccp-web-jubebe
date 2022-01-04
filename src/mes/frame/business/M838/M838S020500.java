package mes.frame.business.M838;

import java.lang.reflect.Method;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.util.ArrayList;

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
public  class M838S020500 extends SqlAdapter{
	Connection con = null;
	PreparedStatement pstmt = null;
	String resultString = "";
	int resultInt = -1;
	StringBuffer sql = new StringBuffer();
	
	String[][] v_paramArray = new String[0][0]; 
	Class[] optClass = null;
	Object[] optObj = null;
	Object obj = null;
	
	public M838S020500(){
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
			
			Method method = M838S020500.class.getMethod(event,optClass);
			LoggingWriter.setLogDebug(M838S020500.class.getName(),"==== " + event + " EventMethod Create Success ====");

			obj = method.invoke(M838S020500.class.newInstance(),optObj);
			doExcute_result = CommonFunction.getInt(obj.toString());
			
	    } catch (Exception ex) {
	    	doExcute_result = EventDefine.E_DOEXCUTE_INIT;
			ioParam.setMessage(MessageDefine.M_NO_EVENTID);
			LoggingWriter.setLogError(M838S020500.class.getName(),"==== EventID Not define : EVENT ID [ " + ioParam.getEventID() + "]");
	    } finally {
	    	obj = null;
			optClass = null;
			optObj = null;
	    }
	    long endTime = System.currentTimeMillis();
		long runningTime = endTime - startTime;
		LoggingWriter.setLogAll(M838S020500.class.getName(),"==== Query [수행시간  : " + runningTime + " ms]");
		
		return doExcute_result;
	}
	
	// 외부인출입자 관리대장 등록
	public int E101(InoutParameter ioParam){ 
		
		resultInt = EventDefine.E_DOEXCUTE_INIT;

		try {
			con = JDBCConnectionPool.getConnection();
			con.setAutoCommit(false);
			
    		JSONObject jArray = new JSONObject();
    		jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
    		System.out.println("JSONObject jArray rcvData="+ jArray.toString());
    		
    		String checklist_id = jArray.get("checklist_id").toString();
    		//String person_write_id = "cb5027";
    		String person_write_id = jArray.get("person_write_id").toString();
    		int regist_seq_no = 0, cnt = 0;
    		
    		String sql = new StringBuilder()
    				.append("SELECT COUNT(regist_seq_no) AS cnt, regist_seq_no\n")
    				.append("FROM\n")
    				.append("	haccp_outsider_detail\n")
    				.append("GROUP BY regist_seq_no\n")
    				.append("HAVING GROUPBY_NUM() = 1\n")
    				.append("ORDER BY regist_seq_no DESC\n")
    				.toString();

    		resultString = super.excuteQueryString(con, sql.toString());
    		
    		if(resultString.length() > 0) {
    			
    			char[] char2 =  resultString.trim().toCharArray();
        		// [0] : cnt, [2] : regist_seq_no
        		
        		cnt = Integer.parseInt(String.valueOf(char2[0]));
        		regist_seq_no = Integer.parseInt(String.valueOf(char2[2]));
    			
    		}
    		
    		if(resultString.length() == 0 || cnt == 20) {
    			
    			sql = new StringBuilder()
        				.append("INSERT INTO\n")
        				.append("	haccp_outsider_record (\n")
        				.append("		checklist_id,\n")
        				.append("		checklist_rev_no,\n")
        				.append("		regist_date,\n")
        				.append("		person_write_id\n")
        				.append("	)\n")
        				.append("VALUES\n")
        				.append("	(\n")
        				.append("		'"+checklist_id+"',\n")
    				    .append("    	(SELECT MAX(checklist_rev_no)				 \n")
    				    .append("    	FROM checklist								 \n")
    				    .append("    	WHERE checklist_id = '"+checklist_id+"'),	 \n")
        				.append("		TO_CHAR(SYSDATE, 'YYYY-MM-DD'),\n")
        				.append("		'"+person_write_id+"'\n")
        				.append("	);\n")
        				.toString();
        		
    			resultInt = super.excuteUpdate(con, sql.toString());
    			
    	    	if(resultInt < 0){
    				ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
    				con.rollback();
    				return EventDefine.E_DOEXCUTE_ERROR ;
    			}
    			
    	    	sql = new StringBuilder()
        				.append("SELECT regist_seq_no\n")
        				.append("FROM\n")
        				.append("	haccp_outsider_record \n")
        				.append("WHERE ROWNUM = 1\n")
        				.append("ORDER BY regist_seq_no DESC\n")
        				.toString();

        		resultString = super.excuteQueryString(con, sql.toString());
    	    	
        		regist_seq_no = Integer.parseInt(resultString.trim());
        		
    		}
    		
    		sql = new StringBuilder()
	    			.append("INSERT INTO\n")
	    			.append("	haccp_outsider_detail (\n")
	    			.append("		regist_seq_no,\n")
	    			.append("		visit_date,\n")
	    			.append("		company,\n")
	    			.append("		visitor_name,\n")
	    			.append("		visit_purpose,\n")
	    			.append("		visit_time,\n")
	    			.append("		disease_checkyn,\n")
	    			.append("		confirm_check\n")
	    			.append("	)\n")
	    			.append("VALUES\n")
	    			.append("	(\n")
	    			.append("		'"+regist_seq_no+"',              			   \n")
	    			.append("		'"+jArray.get("visit_date").toString()+"',     \n")
	    			.append("		'"+jArray.get("company").toString()+"',        \n")
	    			.append("		'"+jArray.get("visitor_name").toString()+"',   \n")
	    			.append("		'"+jArray.get("visit_purpose").toString()+"',  \n")
	    			.append("		'"+jArray.get("visit_time").toString()+"',     \n")
	    			.append("		'"+jArray.get("disease_checkyn").toString()+"',\n")
	    			.append("		'"+jArray.get("confirm_check").toString()+"'   \n")
	    			.append("	) \n")
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
			LoggingWriter.setLogError("M838S020500E101()","==== SQL ERROR ===="+ e.getMessage());
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
		
	// 외부인출입자 관리대장 수정
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
    				.append("	haccp_outsider_record SET									  		\n")
    				.append("       person_write_id   = 'cb5027', 	\n")
    				.append("WHERE dept = 		'"+ jArray.get("dept") + "'							\n")
    				
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
			LoggingWriter.setLogError("M838S020500E102()","==== SQL ERROR ===="+ e.getMessage());
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
	
	// 외부인출입자 관리대장 삭제
	public int E103(InoutParameter ioParam){ 
		resultInt = EventDefine.E_DOEXCUTE_INIT;

		try {
			con = JDBCConnectionPool.getConnection();
			con.setAutoCommit(false);
			
    		JSONObject jArray = new JSONObject();
    		jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
    		System.out.println("JSONObject jArray rcvData="+ jArray.toString());

    		String sql = new StringBuilder()		
    				.append("DELETE FROM														 \n")
    				.append("	haccp_outsider_detail											 \n")
    				.append("WHERE regist_seq_no = 	'"+ jArray.get("regist_seq_no") + "'	 	 \n")
					.toString();
		
			resultInt = super.excuteUpdate(con, sql.toString());
	    	if(resultInt < 0){
				ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
				con.rollback();
				return EventDefine.E_DOEXCUTE_ERROR ;
			}
	    	
	    	sql = new StringBuilder()		
				.append("DELETE FROM														 \n")
				.append("	haccp_outsider_record											 \n")
				.append("WHERE regist_seq_no = 	'"+ jArray.get("regist_seq_no") + "'	 	 \n")
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
			LoggingWriter.setLogError("M838S020500E103()","==== SQL ERROR ===="+ e.getMessage());
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
	
	// 외부인출입자 관리대장 메인 테이블 조회
	public int E104(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));

			String sql = new StringBuilder()
					.append("SELECT  DISTINCT \n")
					.append("	checklist_id, \n")
					.append("	checklist_rev_no,\n")
					.append("	regist_date,\n")
					.append("	A.regist_seq_no,\n")
					.append("	TO_CHAR(MIN(B.visit_date), 'YYYY-MM-DD') || ' ~ ' || TO_CHAR(MAX(B.visit_date), 'YYYY-MM-DD') AS visit_dates,\n")
					.append("	C.user_nm AS person_write_id,\n")
					.append("	D.user_nm AS person_check_id,\n")
					.append("	E.user_nm AS 	person_approve_id\n")
					.append("FROM\n")
					.append("	haccp_outsider_record A \n")
					.append("	INNER JOIN haccp_outsider_detail B\n")
					.append("		ON A.regist_seq_no = B.regist_seq_no\n")
					.append("	LEFT JOIN tbm_users C							\n")
					.append("		ON A.person_write_id = C.user_id				\n")
					.append("		AND regist_date BETWEEN CAST(C.start_date AS DATE) AND CAST(C.duration_date AS DATE) \n")
					.append("	LEFT JOIN tbm_users D							\n")
					.append("		ON A.person_check_id = D.user_id			\n")
					.append("		AND  A.regist_date BETWEEN CAST(D.start_date AS DATE) AND CAST(D.duration_date AS DATE) \n")
					.append("	LEFT JOIN tbm_users E					\n")
					.append("		ON A.person_approve_id = E.user_id			\n")
					.append("		AND  A.regist_date BETWEEN CAST(E.start_date AS DATE) AND CAST(E.duration_date AS DATE)\n")
					.append("GROUP BY A.regist_seq_no\n")
					.append("HAVING A.regist_date Between '"+ jArray.get("fromdate") + "' \n")
					.append("      				     AND '"+ jArray.get("todate") + "' 		\n")
					.append("ORDER BY A.regist_seq_no DESC\n")
					.toString();

			String ActionCommand = ioParam.getActionCommand();
			if(ActionCommand.startsWith("doQueryTableFieldName")) {
				resultString = super.excuteQueryStringTableFieldName(con, sql.toString());
			} else {
				resultString = super.excuteQueryString(con, sql.toString());
			}
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M838S020500E104()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) {
						con.close();
					}
				} catch (Exception e) {
					LoggingWriter.setLogError("M838S020500E104()","==== finally ===="+ e.getMessage());
				}
	    	}
	    }

		ioParam.setResultString(resultString);
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
    	ioParam.setMessage(MessageDefine.M_QUERY_OK);

    	return EventDefine.E_QUERY_RESULT;
	}

	// 외부인출입자 관리대장 명단 수정
	public int E112(InoutParameter ioParam){ 
		
		resultInt = EventDefine.E_DOEXCUTE_INIT;

		try {
			con = JDBCConnectionPool.getConnection();
			con.setAutoCommit(false);
			
    		JSONObject jArray = new JSONObject();
    		jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
    		System.out.println("JSONObject jArray rcvData="+ jArray.toString());
    		
    		String sql = new StringBuilder()
    				.append("UPDATE														 \n")
    				.append("	haccp_outsider_detail SET								 \n")
    				.append("		visit_date 	 = '"+ jArray.get("visit_date") + "', 	 \n")
    				.append("		company 	 = '"+ jArray.get("company") + "',	 	 \n")
    				.append("       visitor_name = '"+ jArray.get("visitor_name") + "',	 \n")
    				.append(" 		visit_purpose = '"+ jArray.get("visit_purpose") + "',\n")
    				.append("       visit_time 	 = '"+ jArray.get("visit_time") + "', 	 \n")
    				.append(" 		disease_checkyn = '"+ jArray.get("disease_checkyn") + "',	 \n")
    				.append(" 		confirm_check = '"+ jArray.get("confirm_check") + "'		 \n")
    				.append("WHERE seq_no =  "+ jArray.get("seq_no") + " 				 \n")
					.toString();
		
			resultInt = super.excuteUpdate(con, sql.toString());
	    	if(resultInt < 0){
				ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
				con.rollback();
				return EventDefine.E_DOEXCUTE_ERROR ;
			}
	    	
	    	sql = new StringBuilder()
    				.append("UPDATE														 \n")
    				.append("	haccp_outsider_record SET								 \n")
    				.append("		person_check_id  = '',	 	 \n")
    				.append("       person_approve_id = ''	 \n")
    				.append("WHERE regist_seq_no =  "+ jArray.get("regist_seq_no") + " 	 \n")
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
			LoggingWriter.setLogError("M838S020500E112()","==== SQL ERROR ===="+ e.getMessage());
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
	
	// 외부인출입자 관리대장 명단 삭제
	public int E113(InoutParameter ioParam){ 
		resultInt = EventDefine.E_DOEXCUTE_INIT;

		try {
			con = JDBCConnectionPool.getConnection();
			con.setAutoCommit(false);
			
    		JSONObject jArray = new JSONObject();
    		jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
    		System.out.println("JSONObject jArray rcvData="+ jArray.toString());

    		String sql = new StringBuilder()
    				.append("DELETE FROM													 \n")
    				.append("	haccp_outsider_detail 										 \n")
    				.append("WHERE seq_no =  '"+ jArray.get("seq_no") + "'					 \n")
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
			LoggingWriter.setLogError("M838S020500E113()","==== SQL ERROR ===="+ e.getMessage());
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
		
	// 외부인출입자 관리대장 서브 테이블 조회
	public int E114(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));

			String sql = new StringBuilder()
					.append("SELECT\n")
					.append("	seq_no,\n")
					.append("	regist_seq_no,\n")
					.append("	visit_date,\n")
					.append("	company,\n")
					.append("	visitor_name,\n")
					.append("	visit_purpose,\n")
					.append("	TO_CHAR(visit_time, 'HH24:MI') as visit_time,\n")
					.append("	CASE WHEN disease_checkyn = 'O' THEN '양호' ELSE '이상있음' END as disease_checkyn, \n")
					.append("	confirm_check\n")
					.append("FROM\n")
					.append("	haccp_outsider_detail\n")
					.append("WHERE regist_seq_no = '"+jArray.get("regist_seq_no")+"'\n")
					.append("ORDER BY seq_no DESC \n")
					.toString();

			String ActionCommand = ioParam.getActionCommand();
			if(ActionCommand.startsWith("doQueryTableFieldName")) {
				resultString = super.excuteQueryStringTableFieldName(con, sql.toString());
			} else {
				resultString = super.excuteQueryString(con, sql.toString());
			}
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M838S020500E114()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) {
						con.close();
					}
				} catch (Exception e) {
					LoggingWriter.setLogError("M838S020500E114()","==== finally ===="+ e.getMessage());
				}
	    	}
	    }

		ioParam.setResultString(resultString);
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
    	ioParam.setMessage(MessageDefine.M_QUERY_OK);

    	return EventDefine.E_QUERY_RESULT;
	}

	// checklist10_20210420.jsp
	public int E144(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			
			String regist_seq_no = jArray.get("regist_seq_no").toString();
			
			String sql = new StringBuilder()
					.append("SELECT\n")
					.append("	A.checklist_id,\n")
					.append("	A.checklist_rev_no,\n")
					.append("	A.regist_seq_no,\n")
					.append("	C.user_nm AS person_write_id,\n")
					.append("	D.user_nm AS person_check_id,\n")
					.append("	E.user_nm AS 	person_approve_id,\n")
					.append("	B.seq_no,\n")
					.append("	B.visit_date,\n")
					.append("	B.company,\n")
					.append("	B.visitor_name,\n")
					.append("	B.visit_purpose,\n")
					.append("	TO_CHAR(B.visit_time, 'HH24:MI') as visit_time,\n")
					.append("	CASE WHEN B.disease_checkyn = 'O' THEN '양호' ELSE '이상있음' END AS disease_checkyn,\n")
					.append("	B.confirm_check\n")
					.append("FROM\n")
					.append("	haccp_outsider_record A \n")
					.append("	JOIN haccp_outsider_detail B\n")
					.append("		ON A.regist_seq_no = B.regist_seq_no\n")
					.append("	LEFT JOIN tbm_users C							\n")
					.append("		ON A.person_write_id = C.user_id				\n")
					.append("		AND regist_date BETWEEN CAST(C.start_date AS DATE) AND CAST(C.duration_date AS DATE) \n")
					.append("	LEFT JOIN tbm_users D							\n")
					.append("		ON A.person_check_id = D.user_id			\n")
					.append("		AND  A.regist_date BETWEEN CAST(D.start_date AS DATE) AND CAST(D.duration_date AS DATE) \n")
					.append("	LEFT JOIN tbm_users E					\n")
					.append("		ON A.person_approve_id = E.user_id			\n")
					.append("		AND  A.regist_date BETWEEN CAST(E.start_date AS DATE) AND CAST(E.duration_date AS DATE)\n")
					.append("WHERE A.regist_seq_no = '"+regist_seq_no+"'\n")
					.append("ORDER BY seq_no ASC \n")
					.toString();
			
			String ActionCommand = ioParam.getActionCommand();
			if(ActionCommand.startsWith("doQueryTableFieldName")) {
				resultString = super.excuteQueryStringTableFieldName(con, sql.toString());
			} else {
				resultString = super.excuteQueryString(con, sql.toString());
			}
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M838S020500E144()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M838S020500E144()","==== finally ===="+ e.getMessage());
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
				.append("UPDATE haccp_outsider_record									\n")
				.append("SET															\n")
				.append("	person_approve_id = '" + jObj.get("userId") + "'			\n")
				.append("WHERE regist_seq_no = '"+ jObj.get("seq_no") + "'				\n")
				.append("  AND checklist_id = '"+ jObj.get("checklistId") + "'			\n")
				.append("  AND checklist_rev_no = '"+ jObj.get("checklistRevNo") + "'	\n")
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
		LoggingWriter.setLogError("M838S015300E502()","==== SQL ERROR ===="+ e.getMessage());
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
	    			.append("UPDATE haccp_outsider_record									\n")
	    			.append("SET															\n")
	    			.append("	person_check_id = '" + jObj.get("userId") + "'				\n")
	    			.append("WHERE regist_seq_no = '"+ jObj.get("seq_no") + "'				\n")
	    			.append("  AND checklist_id = '"+ jObj.get("checklistId") + "'			\n")
	    			.append("  AND checklist_rev_no = '"+ jObj.get("checklistRevNo") + "'	\n")
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
				LoggingWriter.setLogError("M838S015300E522()","==== SQL ERROR ===="+ e.getMessage());
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