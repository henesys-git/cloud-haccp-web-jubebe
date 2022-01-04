package mes.frame.business.M838;

import java.lang.reflect.Method;
import java.sql.Connection;
import java.sql.PreparedStatement;

import org.apache.log4j.Logger;
import org.json.simple.JSONObject;

import mes.client.conf.Config;
import mes.frame.business.M707.M707S010600;
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
public class M838S015100 extends SqlAdapter{
	
	static final Logger logger = Logger.getLogger(M838S015100.class.getName());
	
	Connection con = null;
	PreparedStatement pstmt = null;
	String resultString = "";
	int resultInt = -1;
	StringBuffer sql = new StringBuffer();
	
	String[][] v_paramArray = new String[0][0]; 
	Class[] optClass = null;
	Object[] optObj = null;
	Object obj = null;
	
	public M838S015100(){
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
	public int doExcute(InoutParameter ioParam){
		long startTime = System.currentTimeMillis();
		int doExcute_result = EventDefine.E_DOEXCUTE_INIT;;
		String event = ioParam.getEventSubID();

	    try{
            optClass = new Class[1];
			optClass[0] = ioParam.getClass() ;
			optObj = new Object[1];
			optObj[0] = ioParam;
			
			Method method = M838S015100.class.getMethod(event,optClass);
			LoggingWriter.setLogDebug(M838S015100.class.getName(),"==== " + event + " EventMethod Create Success ====");

			obj = method.invoke(M838S015100.class.newInstance(),optObj);
			doExcute_result = CommonFunction.getInt(obj.toString());
			
	    } catch (Exception ex) {
	    	doExcute_result = EventDefine.E_DOEXCUTE_INIT;
			ioParam.setMessage(MessageDefine.M_NO_EVENTID);
			LoggingWriter.setLogError(M838S015100.class.getName(),"==== EventID Not define : EVENT ID [ " + ioParam.getEventID() + "]");
	    } finally {
	    	obj = null;
			optClass = null;
			optObj = null;
	    }
	    long endTime = System.currentTimeMillis();
		long runningTime = endTime - startTime;
		logger.debug("Query [수행시간  : " + runningTime + " ms]");
		
		return doExcute_result;
	}
	
	// 모니터링 일지 등록
	public int E101(InoutParameter ioParam){ 
		
		String sql = "";
		
		resultInt = EventDefine.E_DOEXCUTE_INIT;

		try {
			con = JDBCConnectionPool.getConnection();
			con.setAutoCommit(false);
			
    		JSONObject jArray = new JSONObject();
    		jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
    			
    			sql = new StringBuilder()
    				.append("INSERT INTO					\n")
    				.append("	haccp_ccp_1b (				\n")
    				.append("		checklist_id,			\n")
    				.append("		checklist_rev_no,		\n")
    				.append("		ccp_date,				\n")
    				.append("       person_write_id, 		\n")
    				.append("       limit_unsuit,			\n")
    				.append("       improve_action_result	\n")
    				.append(" 		)						\n")
    				.append("VALUES (											\n")
					.append(" 		'"	+ jArray.get("checklist_id") + "',		\n")
					.append(" 		'"	+ jArray.get("checklist_rev_no") + "',	\n")
					.append(" 		'"	+ jArray.get("ccp_date") + "',			\n")
					.append(" 		'"	+ jArray.get("person_write_id") + "',	\n")
					.append(" 		'"	+ jArray.get("limit_unsuit") + "',		\n")
					.append(" 		'"	+ jArray.get("improve_action_result") + "' \n")
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
			LoggingWriter.setLogError("M838S015100E101()","==== SQL ERROR ===="+ e.getMessage());
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
		
	// 측정일지 등록
	public int E111(InoutParameter ioParam){ 
		
		String sql = "";
		
		resultInt = EventDefine.E_DOEXCUTE_INIT;

		try {
			con = JDBCConnectionPool.getConnection();
			con.setAutoCommit(false);
			
    		JSONObject jArray = new JSONObject();
    		jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
    		
    			sql = new StringBuilder()
    				.append("INSERT INTO					\n")
    				.append("	haccp_ccp_1b_detail (		\n")
    				.append(" 		ccp_date,				\n")
    				.append("		check_time,				\n")
    				.append("		prod_cd,				\n")
    				.append("       revision_no, 			\n")
    				.append("       temp_place, 			\n")
    				.append(" 		temp_prod,				\n")
    				.append(" 		quick_cooling_time,		\n")
    				.append(" 		result					\n")
    				.append(" 		)						\n")
    				.append("VALUES (											\n")
					.append(" 		'"	+ jArray.get("ccp_date") + "',			\n")
					.append(" 		'"	+ jArray.get("check_time") + "',		\n")
					.append(" 		'"	+ jArray.get("prod_cd") + "',			\n")
					.append(" 		'"	+ jArray.get("revision_no") + "',		\n")
					.append(" 		'"	+ jArray.get("temp_place") + "',		\n")
					.append(" 		'"	+ jArray.get("temp_prod") + "',			\n")
					.append(" 		'"	+ jArray.get("quick_cooling_time") + "',\n")
					.append(" 		'"	+ jArray.get("result") + "'			\n")
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
			LoggingWriter.setLogError("M838S015100E111()","==== SQL ERROR ===="+ e.getMessage());
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
		
	
	// 모니터링 일지 수정
	public int E102(InoutParameter ioParam){ 
		
		String sql = "";
		
		resultInt = EventDefine.E_DOEXCUTE_INIT;

		try {
			con = JDBCConnectionPool.getConnection();
			con.setAutoCommit(false);
			
    		JSONObject jArray = new JSONObject();
    		jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
    		
    		sql = new StringBuilder()
    				.append("UPDATE																\n")
    				.append("	haccp_ccp_1b SET									  			\n")
    				.append("       record_time = '" + jArray.get("record_time") + "', 			\n")
    				.append("       person_qm_id = '' 											\n")
    				.append("WHERE ccp_date =  '"+ jArray.get("ccp_date") + "'					\n")
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
			LoggingWriter.setLogError("M838S015100E102()","==== SQL ERROR ===="+ e.getMessage());
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
				
	// 측정일지 수정
	public int E112(InoutParameter ioParam){ 
		
		String sql = "";
		
		resultInt = EventDefine.E_DOEXCUTE_INIT;

		try {
			con = JDBCConnectionPool.getConnection();
			con.setAutoCommit(false);
			
    		JSONObject jArray = new JSONObject();
    		jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));

    		sql = new StringBuilder()
    				.append("UPDATE													  \n")
    				.append("	haccp_ccp_1b_detail SET								  \n")
    				.append("		remarks = '"	+ jArray.get("remarks") + "', 	  \n")
    				.append("       person_inspect_id = '' 			  				  \n")
    				.append("WHERE seq_no =  "+ jArray.get("seq_no") + " 		  	  \n")
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
			LoggingWriter.setLogError("M838S015100E112()","==== SQL ERROR ===="+ e.getMessage());
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
				
	// 모니터링 일지 삭제
	public int E103(InoutParameter ioParam){ 
		resultInt = EventDefine.E_DOEXCUTE_INIT;

		try {
			con = JDBCConnectionPool.getConnection();
			con.setAutoCommit(false);
			
    		JSONObject jArray = new JSONObject();
    		jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));

    		String sql = new StringBuilder()
    				.append("DELETE FROM										\n")
    				.append("	haccp_ccp_1b									\n")
    				.append("WHERE ccp_date = '"+ jArray.get("ccp_date") + "'	\n")
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
			LoggingWriter.setLogError("M838S015100E103()","==== SQL ERROR ===="+ e.getMessage());
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
	
	
	// 모니터링 일지 내 측정일지 삭제
	public int E113(InoutParameter ioParam){ 
		resultInt = EventDefine.E_DOEXCUTE_INIT;

		try {
			con = JDBCConnectionPool.getConnection();
			con.setAutoCommit(false);
			
    		JSONObject jArray = new JSONObject();
    		jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));

    		String sql = new StringBuilder()
    				.append("DELETE FROM													 \n")
    				.append("	haccp_ccp_1b_detail 										 \n")
    				.append("WHERE check_time =  '"+ jArray.get("check_time") + "'			 \n")
    				.append("AND ccp_date =  '"+ jArray.get("check_time") + "' 				 \n")
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
			LoggingWriter.setLogError("M838S015100E113()","==== SQL ERROR ===="+ e.getMessage());
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
	
	
	// CCP-1B 모니터링일지 메인 테이블 조회
	public int E104(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
/*			
			String sql = new StringBuilder()
					.append("SELECT						\n")
					.append("	A.checklist_id,			\n")
					.append("	A.checklist_rev_no,		\n")
					.append("   A.ccp_date, 			\n")
					.append("   A.limit_unsuit, 		\n")
					.append("   A.improve_action_result,\n")
					.append("   C.user_nm, 				\n")
					.append("   A.person_write_id, 		\n")
					.append("   C2.user_nm, 			\n")
					.append("   A.person_approve_id, 	\n")
					.append("   C3.user_nm,				\n")
					.append("   A.person_improve_id, 	\n")
					.append("   C4.user_nm,				\n")
					.append("   A.person_check_id 		\n")
					.append("FROM											\n")
					.append("	haccp_ccp_1b A								\n")
					.append("INNER JOIN tbm_users C							\n")
					.append("	ON A.person_write_id = C.user_id			\n")
					.append("LEFT JOIN tbm_users C2																		\n")
					.append("	ON A.person_approve_id = C2.user_id														\n")
					.append("	AND A.ccp_date BETWEEN CAST(C2.start_date AS DATE) AND CAST(C2.duration_date AS DATE) 	\n")
					.append("LEFT JOIN tbm_users C3																		\n")
					.append("	ON A.person_improve_id = C3.user_id														\n")
					.append("	AND A.ccp_date BETWEEN CAST(C3.start_date AS DATE) AND CAST(C3.duration_date AS DATE) 	\n")
					.append("LEFT JOIN tbm_users C4																		\n")
					.append("	ON A.person_check_id = C4.user_id														\n")
					.append("	AND A.ccp_date BETWEEN CAST(C4.start_date AS DATE) AND CAST(C4.duration_date AS DATE) 	\n")
					.append("WHERE A.ccp_date BETWEEN '"+ jArray.get("fromdate") + "' AND '"+ jArray.get("todate") + "' \n")
					.append("  AND A.ccp_date BETWEEN CAST(C.start_date AS DATE) AND CAST(C.duration_date AS DATE)		\n")
					.append("GROUP BY A.ccp_date																		\n")
					.toString();
*/
			String sql = new StringBuilder()
					.append("SELECT\n")
					.append("	checklist_id,\n")
					.append("	checklist_rev_no,\n")
					.append("	ccp_date,\n")
					.append("	TO_CHAR(record_time, 'HH24:MI') as record_time,\n")
					.append("	C.user_nm AS person_monitoring_id,\n")
					.append("	C.user_nm AS person_write_id,\n")
					.append("	D.user_nm AS person_check_id,\n")
					.append("	E.user_nm AS person_approve_id,\n")
					.append("	F.user_nm AS person_qm_id\n")
					.append("FROM\n")
					.append("	haccp_ccp_1b A\n")
					.append("	LEFT JOIN tbm_users C\n")
					.append("		ON A.person_write_id = C.user_id\n")
					.append("		AND A.ccp_date BETWEEN C.start_date AND C.duration_date\n")
					.append("	LEFT JOIN tbm_users D\n")
					.append("		ON A.person_check_id = D.user_id\n")
					.append("		AND A.ccp_date BETWEEN D.start_date AND D.duration_date\n")
					.append("	LEFT JOIN tbm_users E\n")
					.append("		ON A.person_approve_id = E.user_id\n")
					.append("		AND A.ccp_date BETWEEN E.start_date AND E.duration_date\n")
					.append("	LEFT JOIN tbm_users F\n")
					.append("		ON A.person_qm_id = F.user_id\n")
					.append("		AND A.ccp_date BETWEEN F.start_date AND F.duration_date\n")
					.append("WHERE A.ccp_date BETWEEN '"+ jArray.get("fromdate") + "' AND '"+ jArray.get("todate") + "' \n")
					.append("ORDER BY ccp_date DESC \n")
					.toString();

			String ActionCommand = ioParam.getActionCommand();
			if(ActionCommand.startsWith("doQueryTableFieldName")) {
				resultString = super.excuteQueryStringTableFieldName(con, sql);
			} else {
				resultString = super.excuteQueryString(con, sql);
			}
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M838S015100E104()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) {
						con.close();
					}
				} catch (Exception e) {
					LoggingWriter.setLogError("M838S015100E104()","==== finally ===="+ e.getMessage());
				}
	    	}
	    }

		ioParam.setResultString(resultString);
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
    	ioParam.setMessage(MessageDefine.M_QUERY_OK);

    	return EventDefine.E_QUERY_RESULT;
	}
	
	// 모니터링 일지 서브 테이블 조회
	public int E114(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));

			String sql = new StringBuilder()
					.append("SELECT\n")
					.append("	checklist_id,\n")
					.append("	checklist_rev_no,\n")
					.append("	D.ccp_date,\n")
					.append("	seq_no,\n")
					.append("	check_time,\n")
					.append("	result,\n")
					.append("	U.user_nm AS person_inspect_id,\n")
					.append("	remarks\n")
					.append("FROM\n")
					.append("	haccp_ccp_1b_detail D JOIN haccp_ccp_1b C\n")
					.append("	ON D.ccp_date = C.ccp_date\n")
					.append("	LEFT JOIN tbm_users U\n")
					.append("	ON D.person_inspect_id = U.user_id\n")
					.append("	AND D.ccp_date BETWEEN U.start_date AND U.duration_date\n")
					.append("WHERE D.ccp_date = '"+jArray.get("ccp_date").toString()+"'\n")
					.append("ORDER BY check_time DESC\n")
					.toString();

			String ActionCommand = ioParam.getActionCommand();
			if(ActionCommand.startsWith("doQueryTableFieldName")) {
				resultString = super.excuteQueryStringTableFieldName(con, sql.toString());
			} else {
				resultString = super.excuteQueryString(con, sql.toString());
			}
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M838S015100E114()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) {
						con.close();
					}
				} catch (Exception e) {
					LoggingWriter.setLogError("M838S015100E114()","==== finally ===="+ e.getMessage());
				}
	    	}
	    }

		ioParam.setResultString(resultString);
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
    	ioParam.setMessage(MessageDefine.M_QUERY_OK);

    	return EventDefine.E_QUERY_RESULT;
	}
	
	// CCP 1B 점검표 헤드 조회
	public int E144(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
/*			
			String sql = new StringBuilder()
					.append("SELECT																					\n")
					.append("	A.checklist_id,																		\n")
					.append("	A.checklist_rev_no,																	\n")
					.append("   A.ccp_date, 																		\n")
					.append("   A.limit_unsuit, 																	\n")
					.append("   A.improve_action_result,															\n")
					.append("   C.user_nm, 																			\n")
					.append("   C2.user_nm, 																		\n")
					.append("   C3.user_nm,																			\n")
					.append("   C4.user_nm																			\n")
					.append("FROM																					\n")
					.append("	haccp_ccp_1b A																		\n")
					.append("INNER JOIN tbm_users C																	\n")
					.append("	ON A.person_write_id = C.user_id														\n")
					.append("	AND A.ccp_date BETWEEN CAST(C.start_date AS DATE) AND CAST(C.duration_date AS DATE)		\n")
					.append("LEFT JOIN tbm_users C2																		\n")
					.append("	ON A.person_approve_id = C2.user_id														\n")
					.append("	AND A.ccp_date BETWEEN CAST(C2.start_date AS DATE) AND CAST(C2.duration_date AS DATE) 	\n")
					.append("LEFT JOIN tbm_users C3																		\n")
					.append("	ON A.person_improve_id = C3.user_id														\n")
					.append("	 AND A.ccp_date BETWEEN CAST(C3.start_date AS DATE) AND CAST(C3.duration_date AS DATE) 	\n")
					.append("LEFT JOIN tbm_users C4																		\n")
					.append("	ON A.person_check_id = C4.user_id														\n")
					.append("	  AND A.ccp_date BETWEEN CAST(C4.start_date AS DATE) AND CAST(C4.duration_date AS DATE) \n")
					.append("WHERE A.ccp_date = '"+ jArray.get("ccp_date") + "'											\n")
					.toString();
*/
			
			String sql = new StringBuilder()
					.append("SELECT DISTINCT\n")
					.append("	checklist_id,\n")
					.append("	checklist_rev_no,\n")
					.append("	A.ccp_date,\n")
					.append("	TO_CHAR(A.ccp_date, 'YY') AS YY,\n")
					.append("	TO_CHAR(A.ccp_date, 'MM') AS MM,\n")
					.append("	TO_CHAR(A.ccp_date, 'DD') AS DD,\n")
					.append("	C.user_nm AS person_monitoring_id,\n")
					.append("	C.user_nm AS person_write_id,\n")
					.append("	D.user_nm AS person_check_id,\n")
					.append("	E.user_nm AS person_approve_id,\n")
					.append("	record_time,\n")
					.append("	TO_CHAR(record_time, 'HH24') AS HH,\n")
					.append("	TO_CHAR(record_time, 'MI') AS MI,\n")
					.append("	F.user_nm AS person_qm_id\n")
					.append("FROM\n")
					.append("	haccp_ccp_1b A \n")
					.append("	LEFT JOIN haccp_ccp_1b_detail B\n")
					.append("		ON A.ccp_date = B.ccp_date\n")
					.append("	LEFT JOIN tbm_users C\n")
					.append("		ON A.person_write_id = C.user_id\n")
					.append("		AND A.ccp_date BETWEEN C.start_date AND C.duration_date\n")
					.append("	LEFT JOIN tbm_users D\n")
					.append("		ON A.person_check_id = D.user_id\n")
					.append("		AND A.ccp_date BETWEEN D.start_date AND D.duration_date\n")
					.append("	LEFT JOIN tbm_users E\n")
					.append("		ON A.person_approve_id = E.user_id\n")
					.append("		AND A.ccp_date BETWEEN E.start_date AND E.duration_date\n")
					.append("	LEFT JOIN tbm_users F\n")
					.append("		ON A.person_qm_id = F.user_id\n")
					.append("		AND A.ccp_date BETWEEN F.start_date AND F.duration_date\n")
					.append("WHERE\n")
					.append("		A.ccp_date = '"+ jArray.get("ccp_date") + "'	\n")
					.toString();
			
			resultString = super.excuteQueryString(con, sql);
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M838S015100E144()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M838S015100E144()","==== finally ===="+ e.getMessage());
				}
	    	} else {
	    	}
	    }
		ioParam.setResultString(resultString);
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
    	ioParam.setMessage(MessageDefine.M_QUERY_OK);
    	
	    return EventDefine.E_QUERY_RESULT;
	}

	// CCP 1B 점검표 바디 조회
	public int E145(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			
			String sql = new StringBuilder()
					.append("SELECT\n")
					.append("	seq_no,\n")
					.append("	TO_CHAR(check_time, 'HH24:MI') AS check_time,\n")
					.append("	result,\n")
					.append("	C.user_nm AS person_inspect_id,\n")
					.append("	remarks\n")
					.append("FROM\n")
					.append("	haccp_ccp_1b A \n")
					.append("	JOIN haccp_ccp_1b_detail B\n")
					.append("		ON A.ccp_date = B.ccp_date\n")
					.append("	LEFT JOIN tbm_users C\n")
					.append("		ON B.person_inspect_id = C.user_id\n")
					.append("		AND A.ccp_date BETWEEN C.start_date AND C.duration_date\n")
					.append("WHERE\n")
					.append("	A.ccp_date = '"+ jArray.get("ccp_date") + "'\n")
					.append("ORDER BY check_time ASC \n")
					.toString();

			resultString = super.excuteQueryString(con, sql);
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M838S015100E145()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M838S015100E145()","==== finally ===="+ e.getMessage());
				}
	    	} else {
	    	}
	    }
		ioParam.setResultString(resultString);
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
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
    				.append("UPDATE haccp_ccp_1b											\n")
    				.append("SET															\n")
    				.append("	person_approve_id = '" + jObj.get("userId") + "'			\n")
    				.append("WHERE ccp_date = '"+ jObj.get("checklistDate") + "'			\n")
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
			LoggingWriter.setLogError("M838S015100E502()","==== SQL ERROR ===="+ e.getMessage());
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
	
	// 검토자 서명
	public int E512(InoutParameter ioParam){ 
		
		resultInt = EventDefine.E_DOEXCUTE_INIT;

		try {
			con = JDBCConnectionPool.getConnection();
			con.setAutoCommit(false);
			
			JSONObject jObj = new JSONObject();
    		jObj = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
    		
    		String sql = new StringBuilder()
    				.append("UPDATE haccp_ccp_1b											\n")
    				.append("SET															\n")
    				.append("	person_check_id = '" + jObj.get("userId") + "'				\n")
    				.append("WHERE ccp_date = '"+ jObj.get("checklistDate") + "'			\n")
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
			LoggingWriter.setLogError("M838S015100E512()","==== SQL ERROR ===="+ e.getMessage());
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
	
	// 품질관리팀장 서명
	public int E522(InoutParameter ioParam){ 
		
		resultInt = EventDefine.E_DOEXCUTE_INIT;

		try {
			con = JDBCConnectionPool.getConnection();
			con.setAutoCommit(false);
			
			JSONObject jObj = new JSONObject();
    		jObj = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
    		
    		String sql = new StringBuilder()
    				.append("UPDATE haccp_ccp_1b											\n")
    				.append("SET															\n")
    				.append("	person_qm_id = '" + jObj.get("userId") + "',				\n")
    				.append("	record_time = TIME '" + jObj.get("recordTime") + "'			\n")
    				.append("WHERE ccp_date = '"+ jObj.get("checklistDate") + "'			\n")
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
			LoggingWriter.setLogError("M838S015100E522()","==== SQL ERROR ===="+ e.getMessage());
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
	
	// 측정일지 점검자 서명
	public int E532(InoutParameter ioParam){ 
		
		resultInt = EventDefine.E_DOEXCUTE_INIT;

		try {
			con = JDBCConnectionPool.getConnection();
			con.setAutoCommit(false);
			
			JSONObject jObj = new JSONObject();
    		jObj = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
    		
    		String sql = new StringBuilder()
    				.append("UPDATE haccp_ccp_1b_detail								\n")
    				.append("SET													\n")
    				.append("	person_inspect_id = '" + jObj.get("userId") + "'	\n")
    				.append("WHERE ccp_date = '"+ jObj.get("checklistDate") + "'	\n")
    				.append("  AND seq_no = '"+ jObj.get("seq_no") + "'				\n")
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
			LoggingWriter.setLogError("M838S015100E522()","==== SQL ERROR ===="+ e.getMessage());
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
		
	// 측정일지 점검자  일괄서명
	public int E542(InoutParameter ioParam){ 
		
		resultInt = EventDefine.E_DOEXCUTE_INIT;

		try {
			con = JDBCConnectionPool.getConnection();
			con.setAutoCommit(false);
			
			JSONObject jObj = new JSONObject();
    		jObj = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
    		
    		String sql = new StringBuilder()
    				.append("UPDATE haccp_ccp_1b_detail										\n")
    				.append("SET															\n")
    				.append("	person_inspect_id = '" + jObj.get("userId") + "'			\n")
    				.append("WHERE ccp_date = '"+ jObj.get("ccp_date") + "'					\n")
    				.append("  AND ( person_inspect_id IS NULL OR person_inspect_id = '' )	\n")
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
			LoggingWriter.setLogError("M838S015100E522()","==== SQL ERROR ===="+ e.getMessage());
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