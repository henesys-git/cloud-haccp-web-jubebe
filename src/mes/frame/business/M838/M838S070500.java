package mes.frame.business.M838;

import java.lang.reflect.Method;
import java.sql.Connection;
import java.sql.PreparedStatement;

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




/**
 * 개요 : 이벤트ID별 메소드 정의
 */
public class M838S070500 extends SqlAdapter{
	Connection con = null;
	PreparedStatement pstmt = null;
	String resultString = "";
	int resultInt = -1;
	StringBuffer sql = new StringBuffer();
	
	String[][] v_paramArray = new String[0][0]; 
	Class[] optClass = null;
	Object[] optObj = null;
	Object obj = null;
	
	public M838S070500(){
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
			
			Method method = M838S070500.class.getMethod(event,optClass);
			LoggingWriter.setLogDebug(M838S070500.class.getName(),"==== " + event + " EventMethod Create Success ====");

			obj = method.invoke(M838S070500.class.newInstance(),optObj);
			doExcute_result = CommonFunction.getInt(obj.toString());
			
	    } catch (Exception ex) {
	    	doExcute_result = EventDefine.E_DOEXCUTE_INIT;
			ioParam.setMessage(MessageDefine.M_NO_EVENTID);
			LoggingWriter.setLogError(M838S070500.class.getName(),"==== EventID Not define : EVENT ID [ " + ioParam.getEventID() + "]");
	    } finally {
	    	obj = null;
			optClass = null;
			optObj = null;
	    }
	    long endTime = System.currentTimeMillis();
		long runningTime = endTime - startTime;
		LoggingWriter.setLogAll(M838S070500.class.getName(),"==== Query [수행시간  : " + runningTime + " ms]");
		
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
    		
    		//String checklist_id = jObj.get("checklist_id").toString();
    		//String check_date = jObj.get("check_date").toString();
    		
    		String sql = new StringBuilder()
    				.append("INSERT INTO										\n")
    				.append("	haccp_ccp_verification (						\n")
    				.append("		check_date,									\n")
    				.append("		checklist_id,								\n")
    				.append("		checklist_rev_no,							\n")
    				.append("		person_write_id,							\n")
    				.append("		check1,										\n")
    				.append("		check1_detail,								\n")
    				.append("		check2,										\n")
    				.append("		check2_detail,								\n")
    				.append("		check3,										\n")
    				.append("		check3_detail,								\n")
    				.append("		check4,										\n")
    				.append("		check4_detail,								\n")
    				.append("		check5,										\n")
    				.append("		check5_detail,								\n")
    				.append("		check6,										\n")
    				.append("		check6_detail,								\n")
    				.append("		check7,										\n")
    				.append("		check7_detail,								\n")
    				.append("		check8,										\n")
    				.append("		check8_detail,								\n")
    				.append("		limit_unsuit,								\n")
    				.append("		action_result,								\n")
    				.append("		action_yn,									\n")
    				.append("		check_yn									\n")
    				.append(") VALUES (											\n")
    				.append("		'"+jObj.get("check_date")+"',				\n")
    				.append("		'"+jObj.get("checklist_id")+"',				\n")
    				.append("		(SELECT MAX(checklist_rev_no)				\n")
    				.append("		FROM checklist								\n")
    				.append("		WHERE checklist_id = '"+jObj.get("checklist_id")+"'),\n")
    				.append("		'"+jObj.get("person_write_id")+"',			\n")
    				.append("		'"+jObj.get("check1")+"',					\n")
    				.append("		'"+jObj.get("check1_detail")+"',			\n")
    				.append("		'"+jObj.get("check2")+"',					\n")
    				.append("		'"+jObj.get("check2_detail")+"',			\n")
    				.append("		'"+jObj.get("check3")+"',					\n")
    				.append("		'"+jObj.get("check3_detail")+"',			\n")
    				.append("		'"+jObj.get("check4")+"',					\n")
    				.append("		'"+jObj.get("check4_detail")+"',			\n")
    				.append("		'"+jObj.get("check5")+"',					\n")
    				.append("		'"+jObj.get("check5_detail")+"',			\n")
    				.append("		'"+jObj.get("check6")+"',					\n")
    				.append("		'"+jObj.get("check6_detail")+"',			\n")
    				.append("		'"+jObj.get("check7")+"',					\n")
    				.append("		'"+jObj.get("check7_detail")+"',			\n")
    				.append("		'"+jObj.get("check8")+"',					\n")
    				.append("		'"+jObj.get("check8_detail")+"',			\n")
    				.append("		'"+jObj.get("limit_unsuit")+"',				\n")
    				.append("		'"+jObj.get("action_result")+"',			\n")
    				.append("		'"+jObj.get("action_yn")+"',				\n")
    				.append("		'"+jObj.get("check_yn")+"'					\n")
    				.append(");													\n")
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
			LoggingWriter.setLogError("M838S070500E101()","==== SQL ERROR ===="+ e.getMessage());
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
	public int E102(InoutParameter ioParam){ 
		resultInt = EventDefine.E_DOEXCUTE_INIT;

		try {
			con = JDBCConnectionPool.getConnection();
			con.setAutoCommit(false);
			
    		JSONObject jObj = new JSONObject();
    		jObj = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
    		
    		String checklist_id = jObj.get("checklist_id").toString();
    		String check_date = jObj.get("check_date").toString();
    		
    		String sql = new StringBuilder()
    				.append("UPDATE																	\n")
    				.append("	haccp_ccp_verification SET											\n")
    				.append("		check_date = '"+check_date+"',									\n")
    				.append("		checklist_id = '"+checklist_id+"',								\n")
    				.append("		checklist_rev_no = (SELECT MAX(checklist_rev_no)					\n")
    				.append("       				   FROM checklist 								\n")
    				.append("       				   WHERE checklist_id = '"+checklist_id+"'), 	\n")
    				.append("		person_write_id = '"+jObj.get("person_write_id")+"',			\n")
    				.append("		limit_unsuit ='"+jObj.get("limit_unsuit")+"',					\n")
    				.append("		action_result ='"+jObj.get("action_result")+"',					\n")
    				.append("		action_yn ='"+jObj.get("action_yn")+"',							\n")
    				.append("		check_yn ='"+jObj.get("check_yn")+"',							\n")
    				.append("		check1 ='"+jObj.get("check1")+"',								\n")
    				.append("		check1_detail ='"+jObj.get("check1_detail")+"',					\n")
    				.append("		check2 ='"+jObj.get("check2")+"',								\n")
    				.append("		check2_detail ='"+jObj.get("check2_detail")+"',					\n")
    				.append("		check3 ='"+jObj.get("check3")+"',								\n")
    				.append("		check3_detail ='"+jObj.get("check3_detail")+"',					\n")
    				.append("		check4 ='"+jObj.get("check4")+"',								\n")
    				.append("		check4_detail ='"+jObj.get("check4_detail")+"',					\n")
    				.append("		check5 ='"+jObj.get("check5")+"',								\n")
    				.append("		check5_detail ='"+jObj.get("check5_detail")+"',					\n")
    				.append("		check6 ='"+jObj.get("check6")+"',								\n")
    				.append("		check6_detail ='"+jObj.get("check6_detail")+"',					\n")
    				.append("		check7 ='"+jObj.get("check7")+"',								\n")
    				.append("		check7_detail ='"+jObj.get("check7_detail")+"',					\n")
    				.append("		check8 ='"+jObj.get("check8")+"',								\n")
    				.append("		check8_detail ='"+jObj.get("check8_detail")+"'					\n")
    				.append("WHERE check_date = '"+check_date+"' 									\n")
    				.append(";																		\n")
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
			LoggingWriter.setLogError("M838S070500E102()","==== SQL ERROR ===="+ e.getMessage());
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
    				.append("	haccp_ccp_verification \n")
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
			LoggingWriter.setLogError("M838S070500E103()","==== SQL ERROR ===="+ e.getMessage());
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
	// yumsam 
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
					.append("	A.limit_unsuit,											\n")
					.append("	A.action_result,										\n")
					.append("	A.action_yn,											\n")
					.append("	A.check_yn,												\n")
					.append("	B.user_nm AS person_write,								\n")
					.append("	C.user_nm AS person_approve,							\n")
					.append("		A.check1,											\n")
    				.append("		A.check1_detail,									\n")
    				.append("		A.check2,											\n")
    				.append("		A.check2_detail,									\n")
    				.append("		A.check3,											\n")
    				.append("		A.check3_detail,									\n")
    				.append("		A.check4,											\n")
    				.append("		A.check4_detail,									\n")
    				.append("		A.check5,											\n")
    				.append("		A.check5_detail,									\n")
    				.append("		A.check6,											\n")
    				.append("		A.check6_detail,									\n")
    				.append("		A.check7,											\n")
    				.append("		A.check7_detail,									\n")
    				.append("		A.check8,											\n")
    				.append("		A.check8_detail										\n")
					.append("FROM haccp_ccp_verification A								\n")
					.append("LEFT JOIN tbm_users B										\n")
					.append("	ON A.person_write_id = B.user_id						\n")
					.append("AND  A.check_date BETWEEN CAST(B.start_date AS DATE) AND CAST(B.duration_date AS DATE) \n")
					.append("LEFT JOIN tbm_users C										\n")
					.append("	ON A.person_approve_id = C.user_id						\n")
					.append("AND  A.check_date BETWEEN CAST(C.start_date AS DATE) AND CAST(C.duration_date AS DATE) \n")
					.append("WHERE check_date BETWEEN '"+ jArray.get("fromdate") + "' 	\n")
					.append("                     AND '"+ jArray.get("todate") + "' 	\n")
					.toString();

			resultString = super.excuteQueryString(con, sql);
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M838S070500E104()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) {
						con.close();
					}
				} catch (Exception e) {
					LoggingWriter.setLogError("M838S070500E104()","==== finally ===="+ e.getMessage());
				}
	    	}
	    }

		ioParam.setResultString(resultString);
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
    	ioParam.setMessage(MessageDefine.M_QUERY_OK);

    	return EventDefine.E_QUERY_RESULT;
	}
	
	// 체크리스트 질문 목록 조회 쿼리
	public int E114(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			
			String checkDate = jArray.get("check_date").toString();
			
			String sql = new StringBuilder()
					.append("WITH table1 AS														\n")
					.append("(																	\n")
					.append("SELECT																\n")
					.append("	B.type_id,														\n")
					.append("	B.type_name,													\n")
					.append("	A.question_detail												\n")
					.append("FROM																\n")
					.append("	haccp_auto_system_question A									\n")
					.append("INNER JOIN haccp_auto_system_check_type B							\n")
					.append("	ON A.type_id = B.type_id										\n")
					.append("	AND A.type_rev_no = B.type_rev_no								\n")
					//.append("WHERE																\n")
					//.append("	check_date <= '"+checkDate+"'									\n")
					.append(")																	\n")
					.append("-- WITH절 끝															\n")
					.append("SELECT 															\n")
					.append("	DISTINCT type_name,												\n")
					.append("	type_id,														\n")
					.append("	LIST(SELECT REPLACE(question_detail, ',', 'comma')		\n")
					.append("	-- 리스트 시 구분자가 콤마여서, 질문 안의 콤마는 comma 문자열로 대체, 클라이언트에서 재변환	\n")
					.append("		 FROM table1 t1												\n")
					.append("		 WHERE t1.type_name = t2.type_name)							\n")
					.append("FROM table1 t2														\n")
					.append("ORDER BY t2.type_id ASC											\n")
					.toString();
			
			resultString = super.excuteQueryString(con, sql);
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M838S070500E114()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M838S070500E114()","==== finally ===="+ e.getMessage());
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
			
			
			String sql = new StringBuilder()
					.append("SELECT 													\n")
					.append("	A.check_date,											\n")
					.append("	A.checklist_id,											\n")
					.append("	A.checklist_rev_no,										\n")
					.append("	A.check1,												\n")
					.append("	A.check1_detail,										\n")
					.append("	A.check2,												\n")
					.append("	A.check2_detail,										\n")
					.append("	A.check3,												\n")
					.append("	A.check3_detail,										\n")
					.append("	A.check4,												\n")
					.append("	A.check4_detail,										\n")
					.append("	A.check5,												\n")
					.append("	A.check5_detail,										\n")
					.append("	A.check6,												\n")
					.append("	A.check6_detail,										\n")
					.append("	A.check7,												\n")
					.append("	A.check7_detail,										\n")
					.append("	A.check8,												\n")
					.append("	A.check8_detail,										\n")
					.append("	A.limit_unsuit,											\n")
					.append("	A.action_result,										\n")
					.append("	A.action_yn,											\n")
					.append("	A.check_yn,												\n")
					.append("	B.user_nm AS person_write,								\n")
					.append("	C.user_nm AS person_approve								\n")
					.append("FROM haccp_ccp_verification A								\n")
					.append("LEFT JOIN tbm_users B										\n")
					.append("	ON A.person_write_id = B.user_id						\n")
					.append("AND  A.check_date BETWEEN CAST(B.start_date AS DATE) AND CAST(B.duration_date AS DATE) \n")
					.append("LEFT JOIN tbm_users C										\n")
					.append("	ON A.person_approve_id = C.user_id						\n")
					.append("AND  A.check_date BETWEEN CAST(C.start_date AS DATE) AND CAST(C.duration_date AS DATE) \n")
					.append("WHERE A.check_date = '"+ jArray.get("checklist_date") + "' \n")
					.toString();
			
			resultString = super.excuteQueryString(con, sql);
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M838S070500E144()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M838S070500E144()","==== finally ===="+ e.getMessage());
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
		    				.append("UPDATE haccp_ccp_verification											\n")
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
					LoggingWriter.setLogError("M838S070500E502()","==== SQL ERROR ===="+ e.getMessage());
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