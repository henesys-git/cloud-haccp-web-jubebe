package mes.frame.business.M838;

import java.lang.reflect.Method;
import java.sql.Connection;
import java.sql.PreparedStatement;

import org.apache.log4j.Logger;
import org.json.simple.JSONArray;
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


/*
 * 일일위생점검일지
 * 
 * 작성자: 최현수
 * 일시: 2021-01-18
 * 
 * */


/**
 * 개요 : 이벤트ID별 메소드 정의
 */
public class M838S020100 extends SqlAdapter {
	
	static final Logger logger = Logger.getLogger(M838S020100.class.getName());
	
	Connection con = null;
	PreparedStatement pstmt = null;
	String resultString = "";
	int resultInt = -1;
	StringBuffer sql = new StringBuffer();
	
	String[][] v_paramArray = new String[0][0]; 
	Class[] optClass = null;
	Object[] optObj = null;
	Object obj = null;
	
	public M838S020100(){
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
			
			Method method = M838S020100.class.getMethod(event,optClass);
			logger.debug(event + " EventMethod Create Success");

			obj = method.invoke(M838S020100.class.newInstance(),optObj);
			doExcute_result = CommonFunction.getInt(obj.toString());
			
	    } catch (Exception ex) {
	    	doExcute_result = EventDefine.E_DOEXCUTE_INIT;
			ioParam.setMessage(MessageDefine.M_NO_EVENTID);
			logger.error("EventID Not define : EVENT ID [ " + ioParam.getEventID() + "]");
	    } finally {
	    	obj = null;
			optClass = null;
			optObj = null;
	    }
	    long endTime = System.currentTimeMillis();
		long runningTime = endTime - startTime;
		logger.debug("Query 수행시간  : " + runningTime + " ms");
		
		return doExcute_result;
	}
	
	// 등록
	public int E101(InoutParameter ioParam){ 
		resultInt = EventDefine.E_DOEXCUTE_INIT;

		try {
			con = JDBCConnectionPool.getConnection();
			con.setAutoCommit(false);
			
    		JSONObject jObj = new JSONObject();
    		jObj = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
    		
    		String checklist_id = jObj.get("checklist_id").toString();
    		String check_date = jObj.get("check_date").toString();
    		
    		String sql = new StringBuilder()
    				.append("INSERT INTO										\n")
    				.append("	haccp_check_daily (								\n")
    				.append("		check_date,									\n")
    				.append("		regist_date,								\n")
    				.append("		checklist_id,								\n")
    				.append("		checklist_rev_no,							\n")
    				.append("		person_write_id,							\n")
    				.append("		unsuit_detail,								\n")
    				.append("		improve_action								\n")
    				.append(") VALUES (											\n")
    				.append("		'"+check_date+"',							\n")
    				.append("		TO_CHAR(SYSDATE,'YYYY-MM-DD'),				\n")
    				.append("		'"+checklist_id+"',							\n")
    				.append("		(SELECT MAX(checklist_rev_no)				\n")
    				.append("		FROM checklist								\n")
    				.append("		WHERE checklist_id = '"+checklist_id+"'),	\n")
    				.append("		'"+jObj.get("person_write_id").toString()+"',\n")
    				.append("		'"+jObj.get("unsuit_detail").toString()+"',	\n")
    				.append("		'"+jObj.get("improve_action").toString()+"'	\n")
    				.append(")													\n")
    				.toString();
    		
    		resultInt = super.excuteUpdate(con, sql);
	    	if(resultInt < 0) {
				ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
				con.rollback();
				return EventDefine.E_DOEXCUTE_ERROR ;
			}
			
    		JSONArray form = new JSONArray();
    		form = (JSONArray) jObj.get("form");
    		
	    	logger.debug("just before loop");
	    	for(int i = 0; i < form.size(); i++) {
	    		logger.debug("##loop entered!");
	    		logger.debug(form);
	    		
	    		JSONObject result = (JSONObject) form.get(i);
	    		logger.debug(result);
	    		
				String check_type_id = result.get("check_type_id").toString(); 
				String check_detail_id = result.get("check_detail_id").toString(); 
				String value = result.get("value").toString();
				
				sql = new StringBuilder()
						.append("INSERT INTO										\n")
						.append("	haccp_check_daily_result (						\n")
						.append("		check_date,									\n")
						.append("		check_type_id,								\n")
						.append("		check_type_rev_no,							\n")
						.append("		check_detail_id,							\n")
						.append("		check_detail_result							\n")
						.append("	)												\n")
						.append("VALUES												\n")
						.append("	(												\n")
						.append("		'"+check_date+"',							\n")
						.append("		'"+check_type_id+"',						\n")
						.append("		(SELECT MAX(check_type_rev_no)				\n")
						.append("		 FROM haccp_check_daily_type				\n")
						.append("		 WHERE check_type_id = '"+check_type_id+"'),\n")
						.append("		'"+check_detail_id+"',						\n")
						.append("		'"+value+"'									\n")
						.append("	)\n")
						.toString();
				
				resultInt = super.excuteUpdate(con, sql);
				if(resultInt < 0) {
					ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
					con.rollback();
					return EventDefine.E_DOEXCUTE_ERROR;
				}
	    	}
	    	
			con.commit();
		} catch(Exception e) {
			e.getStackTrace();
			LoggingWriter.setLogError("M838S020100E101()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR;
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
	
	// 수정
	// DELETE 후 등록 쿼리 그대로 재사용
	public int E102(InoutParameter ioParam){ 
		resultInt = EventDefine.E_DOEXCUTE_INIT;

		try {
			con = JDBCConnectionPool.getConnection();
			con.setAutoCommit(false);
			
    		JSONObject jObj = new JSONObject();
    		jObj = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
    		
    		String checklist_id = jObj.get("checklist_id").toString();
    		String checklist_rev_no = jObj.get("checklist_rev_no").toString();
    		String check_date = jObj.get("check_date").toString();
    		
    		String sql = new StringBuilder()
    				.append("DELETE FROM\n")
    				.append("	haccp_check_daily_result	\n")
    				.append("WHERE\n")
    				.append("	check_date = '"+check_date+"'\n")
    				.toString();
    		
    		resultInt = super.excuteUpdate(con, sql);
	    	if(resultInt < 0) {
				ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
				con.rollback();
				return EventDefine.E_DOEXCUTE_ERROR ;
			}
	    	
	    	sql = new StringBuilder()
    				.append("UPDATE haccp_check_daily \n")
    				.append("	SET	\n")
    				.append("		unsuit_detail = '"+jObj.get("unsuit_detail").toString()+"',	\n")
    				.append("		improve_action = '"+jObj.get("improve_action").toString()+"',	\n")
    				.append("		person_check_id = '',	\n")
    				.append("		person_approve_id = ''	\n")
    				.append("WHERE\n")
    				.append("	check_date = '"+check_date+"'\n")
    				.append("	AND checklist_id = '"+checklist_id+"'\n")
    				.append("	AND checklist_rev_no = '"+checklist_rev_no+"'\n")
    				.toString();
    		
    		resultInt = super.excuteUpdate(con, sql);
	    	if(resultInt < 0) {
				ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
				con.rollback();
				return EventDefine.E_DOEXCUTE_ERROR ;
			}
	    	 
	    	JSONArray form = new JSONArray();
    		form = (JSONArray) jObj.get("form");
	    	
    		logger.debug("just before loop");
	    	for(int i = 0; i < form.size(); i++) {
	    		logger.debug("##loop entered!");
	    		logger.debug(form);
	    		
	    		JSONObject result = (JSONObject) form.get(i);
	    		logger.debug(result);
	    		
				String check_type_id = result.get("check_type_id").toString(); 
				String check_detail_id = result.get("check_detail_id").toString(); 
				String value = result.get("value").toString();
				
				sql = new StringBuilder()
						.append("INSERT INTO										\n")
						.append("	haccp_check_daily_result (						\n")
						.append("		check_date,									\n")
						.append("		check_type_id,								\n")
						.append("		check_type_rev_no,							\n")
						.append("		check_detail_id,							\n")
						.append("		check_detail_result							\n")
						.append("	)												\n")
						.append("VALUES												\n")
						.append("	(												\n")
						.append("		'"+check_date+"',							\n")
						.append("		'"+check_type_id+"',						\n")
						.append("		(SELECT MAX(check_type_rev_no)				\n")
						.append("		 FROM haccp_check_daily_type				\n")
						.append("		 WHERE check_type_id = '"+check_type_id+"'),\n")
						.append("		'"+check_detail_id+"',						\n")
						.append("		'"+value+"'									\n")
						.append("	)\n")
						.toString();
				
				resultInt = super.excuteUpdate(con, sql);
				if(resultInt < 0) {
					ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
					con.rollback();
					return EventDefine.E_DOEXCUTE_ERROR;
				}
	    	}
	    	
			con.commit();
		} catch(Exception e) {
			e.getStackTrace();
			LoggingWriter.setLogError("M838S020100E101()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR;
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
	
	// 삭제
	public int E103(InoutParameter ioParam){ 
		resultInt = EventDefine.E_DOEXCUTE_INIT;

		try {
			con = JDBCConnectionPool.getConnection();
			con.setAutoCommit(false);
			
    		JSONObject jObj = new JSONObject();
    		jObj = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
    		
    		String checklist_id = jObj.get("checklist_id").toString();
    		int checklist_rev_no = Integer.parseInt(jObj.get("checklist_rev_no").toString());
    		String check_date = jObj.get("check_date").toString();
    		
    		String sql = new StringBuilder()
    				.append("DELETE FROM\n")
    				.append("	haccp_check_daily_result\n")
    				.append("WHERE\n")
    				.append("	check_date = '"+check_date+"'\n")
    				.toString();
    		
    		resultInt = super.excuteUpdate(con, sql);
	    	if(resultInt < 0) {
				ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
				con.rollback();
				return EventDefine.E_DOEXCUTE_ERROR ;
			}
	    	
	    	sql = new StringBuilder()
    				.append("DELETE FROM\n")
    				.append("	haccp_check_daily\n")
    				.append("WHERE\n")
    				.append("	checklist_id = '"+checklist_id+"'\n")
    				.append("	AND checklist_rev_no = "+checklist_rev_no+"\n")
    				.append("	AND check_date = '"+check_date+"'\n")
    				.toString();
    		
    		resultInt = super.excuteUpdate(con, sql);
	    	if(resultInt < 0) {
				ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
				con.rollback();
				return EventDefine.E_DOEXCUTE_ERROR ;
			}
	    	
			con.commit();
		} catch(Exception e) {
			e.getStackTrace();
			LoggingWriter.setLogError("M838S020100E103()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR;
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
	
	// 메인 테이블 조회
	public int E104(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			
			String sql = new StringBuilder()
					.append("SELECT 													\n")
					.append("	A.checklist_id,											\n")
					.append("	A.checklist_rev_no,										\n")
					.append("	A.check_date,											\n")
					.append("	A.unsuit_detail,										\n")
					.append("	A.improve_action,										\n")
					.append("	B.user_nm AS person_write,								\n")
					.append("	C.user_nm AS person_check,								\n")
					.append("	D.user_nm AS person_approve								\n")
					.append("FROM haccp_check_daily A									\n")
					.append("LEFT JOIN tbm_users B										\n")
					.append("	ON A.person_write_id = B.user_id						\n")
					.append("AND  regist_date BETWEEN CAST(B.start_date AS DATE) AND CAST(B.duration_date AS DATE) \n")
					.append("LEFT JOIN tbm_users C										\n")
					.append("	ON A.person_check_id = C.user_id						\n")
					.append("AND  regist_date BETWEEN CAST(C.start_date AS DATE) AND CAST(C.duration_date AS DATE) \n")
					.append("LEFT JOIN tbm_users D										\n")
					.append("	ON A.person_approve_id = D.user_id						\n")
					.append("AND  regist_date BETWEEN CAST(D.start_date AS DATE) AND CAST(D.duration_date AS DATE) \n")
					.append("WHERE check_date BETWEEN '"+ jArray.get("fromdate") + "' 	\n")
					.append("                     AND '"+ jArray.get("todate") + "' 	\n")
					.append("ORDER BY check_date DESC 									\n")
					.toString();

			resultString = super.excuteQueryString(con, sql);
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M838S020100E104()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) {
						con.close();
					}
				} catch (Exception e) {
					LoggingWriter.setLogError("M838S020100E104()","==== finally ===="+ e.getMessage());
				}
	    	}
	    }

		ioParam.setResultString(resultString);
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
    	ioParam.setMessage(MessageDefine.M_QUERY_OK);

    	return EventDefine.E_QUERY_RESULT;
	}
	
	// 체크리스트 질문 ID 조회 쿼리
	public int E114(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			String sql = new StringBuilder()
					.append("SELECT\n")
					.append("	check_type_id,\n")
					.append("	check_detail_id,\n")
					.append("	check_type_rev_no,\n")
					.append("	check_detail_question\n")
					.append("FROM\n")
					.append("	haccp_check_daily_detail\n")
					.append("ORDER BY check_type_id, check_detail_id\n")
					.toString();
			
			resultString = super.excuteQueryString(con, sql);
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M838S020100E114()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M838S020100E114()","==== finally ===="+ e.getMessage());
				}
	    	} else {
	    	}
	    }
		ioParam.setResultString(resultString);
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
    	ioParam.setMessage(MessageDefine.M_QUERY_OK);

    	return EventDefine.E_QUERY_RESULT;
	}
	
	// 점검표 캔버스 조회용 쿼리
	public int E144(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			
			String check_date = jArray.get("check_date").toString();
			
			String sql = new StringBuilder()
					.append("SELECT\n")
					.append("	checklist_id,\n")
					.append("	checklist_rev_no,\n")
					.append("	check_date,\n")
					.append("	TO_CHAR(check_date, 'MM') as MM,\n")
					.append("	TO_CHAR(check_date, 'DD') as DD,\n")
					.append("	LIST(\n")
					.append("		SELECT check_detail_result\n")
					.append("		FROM haccp_check_daily_result R\n")
					.append("		WHERE R.check_date = A.check_date\n")
					.append("		ORDER BY check_type_id, check_detail_id\n")
					.append("	) AS results,\n")
					.append("	unsuit_detail,\n")
					.append("	improve_action,\n")
					.append("	B.user_nm AS person_write_id,\n")
					.append("	C.user_nm AS 	person_check_id,\n")
					.append("	D.user_nm AS person_approve_id\n")
					.append("FROM\n")
					.append("	haccp_check_daily A\n")
					.append("	LEFT JOIN tbm_users B										\n")
					.append("		ON A.person_write_id = B.user_id						\n")
					.append("		AND  regist_date BETWEEN CAST(B.start_date AS DATE) AND CAST(B.duration_date AS DATE) \n")
					.append("	LEFT JOIN tbm_users C										\n")
					.append("		ON A.person_check_id = C.user_id						\n")
					.append("		AND  regist_date BETWEEN CAST(C.start_date AS DATE) AND CAST(C.duration_date AS DATE) \n")
					.append("	LEFT JOIN tbm_users D										\n")
					.append("		ON A.person_approve_id = D.user_id						\n")
					.append("		AND  regist_date BETWEEN CAST(D.start_date AS DATE) AND CAST(D.duration_date AS DATE) \n")
					.append("WHERE\n")
					.append("	check_date = '"+check_date+"'\n")
					.toString();
			
			resultString = super.excuteQueryString(con, sql);
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M838S020100E144()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M838S020100E144()","==== finally ===="+ e.getMessage());
				}
	    	} else {
	    	}
	    }
		ioParam.setResultString(resultString);
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
    	ioParam.setMessage(MessageDefine.M_QUERY_OK);

    	return EventDefine.E_QUERY_RESULT;
	}
/*	
	// 수정 시 기존 데이터 넣기 위한 쿼리
	public int E154(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			
			String checkDate = jArray.get("check_date").toString();
			
			String sql = new StringBuilder()
					.append("SELECT 												\n")
					.append("	DISTINCT A.check_date,								\n")
					.append("	LIST(SELECT check_detail_result 					\n")
					.append("		 FROM haccp_check_daily_result A2				\n")
					.append("		 WHERE A2.check_date = A.check_date				\n")
					.append("		 ORDER BY check_detail_id ASC) AS result,		\n")
					.append("	B.unsuit_detail,									\n")
					.append("	B.improve_action,									\n")
					.append("	C.user_nm AS person_write,							\n")
					.append("	D.user_nm AS person_approve							\n")
					.append("FROM haccp_check_daily_result A						\n")
					.append("INNER JOIN haccp_check_daily B							\n")
					.append("	ON A.check_date = B.check_date						\n")
					.append("	AND A.checklist_id = B.checklist_id					\n")
					.append("	AND A.checklist_rev_no = B.checklist_rev_no			\n")
					.append("LEFT JOIN tbm_users C									\n")
					.append("ON B.person_write_id = C.user_id						\n")
					.append("AND  A.check_date BETWEEN CAST(C.start_date AS DATE) AND CAST(C.duration_date AS DATE) \n")
					.append("LEFT JOIN tbm_users D									\n")
					.append("ON B.person_approve_id = D.user_id						\n")
					.append("AND  A.check_date BETWEEN CAST(D.start_date AS DATE) AND CAST(D.duration_date AS DATE) \n")
					.append("WHERE A.check_date = '"+checkDate+"'					\n")
					.toString();
			
			resultString = super.excuteQueryString(con, sql);
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M838S020100E144()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M838S020100E144()","==== finally ===="+ e.getMessage());
				}
	    	} else {
	    	}
	    }
		ioParam.setResultString(resultString);
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
    	ioParam.setMessage(MessageDefine.M_QUERY_OK);

    	return EventDefine.E_QUERY_RESULT;
	}
*/	
	// 점검표 승인자 서명
	public int E502(InoutParameter ioParam){ 
		
		resultInt = EventDefine.E_DOEXCUTE_INIT;

		try {
			con = JDBCConnectionPool.getConnection();
			con.setAutoCommit(false);
			
    		JSONObject jObj = new JSONObject();
    		jObj = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
    		
    		String sql = new StringBuilder()
    				.append("UPDATE haccp_check_daily										\n")
    				.append("SET															\n")
    				.append("	person_approve_id = '" + jObj.get("userId") + "'			\n")
    				.append("WHERE check_date = '"+ jObj.get("checklistDate") + "'			\n")
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
			LoggingWriter.setLogError("M838S020100E502()","==== SQL ERROR ===="+ e.getMessage());
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
	
	// 점검표 승인자 서명
	public int E522(InoutParameter ioParam){ 
		
		resultInt = EventDefine.E_DOEXCUTE_INIT;

		try {
			con = JDBCConnectionPool.getConnection();
			con.setAutoCommit(false);
			
    		JSONObject jObj = new JSONObject();
    		jObj = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
    		
    		String sql = new StringBuilder()
    				.append("UPDATE haccp_check_daily										\n")
    				.append("SET															\n")
    				.append("	person_check_id = '" + jObj.get("userId") + "'				\n")
    				.append("WHERE check_date = '"+ jObj.get("checklistDate") + "'			\n")
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
			LoggingWriter.setLogError("M838S020100E522()","==== SQL ERROR ===="+ e.getMessage());
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