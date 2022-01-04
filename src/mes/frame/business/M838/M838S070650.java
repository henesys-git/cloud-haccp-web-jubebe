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


/*
 * 폐기물처리기록부
 * 
 * 작성자: 서승헌
 * 일시: 2021-03-23
 * 
 * */


/**
 * 개요 : 이벤트ID별 메소드 정의
 */
public class M838S070650 extends SqlAdapter{
	Connection con = null;
	PreparedStatement pstmt = null;
	String resultString = "";
	int resultInt = -1;
	StringBuffer sql = new StringBuffer();
	
	String[][] v_paramArray = new String[0][0]; 
	Class[] optClass = null;
	Object[] optObj = null;
	Object obj = null;
	
	public M838S070650(){
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
			
			Method method = M838S070650.class.getMethod(event,optClass);
			LoggingWriter.setLogDebug(M838S070650.class.getName(),"==== " + event + " EventMethod Create Success ====");

			obj = method.invoke(M838S070650.class.newInstance(),optObj);
			doExcute_result = CommonFunction.getInt(obj.toString());
			
	    } catch (Exception ex) {
	    	doExcute_result = EventDefine.E_DOEXCUTE_INIT;
			ioParam.setMessage(MessageDefine.M_NO_EVENTID);
			LoggingWriter.setLogError(M838S070650.class.getName(),"==== EventID Not define : EVENT ID [ " + ioParam.getEventID() + "]");
	    } finally {
	    	obj = null;
			optClass = null;
			optObj = null;
	    }
	    long endTime = System.currentTimeMillis();
		long runningTime = endTime - startTime;
		LoggingWriter.setLogAll(M838S070650.class.getName(),"==== Query [수행시간  : " + runningTime + " ms]");
		
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
    		String regist_seq_no = "";
    		
    		String  sql = new StringBuilder()
    					  .append("INSERT INTO										 \n")
    					  .append("	haccp_inferior_regist (	 						 \n")
    					  .append("    	checklist_id,								 \n")
    					  .append("   	checklist_rev_no,							 \n")
    					  .append("   	regist_date,								 \n")
    					  .append("   	person_write_id								 \n")
    					  .append(") VALUES (									 	 \n")
    					  .append("		'"+checklist_id+"',							 \n")
    					  .append("    	(SELECT MAX(checklist_rev_no)				 \n")
    					  .append("    	FROM checklist								 \n")
    					  .append("    	WHERE checklist_id = '"+checklist_id+"'),	 \n")
    					  .append("		'"+jObj.get("regist_date").toString()+"',	 \n")
    					  .append("		'"+jObj.get("person_write_id").toString()+"' \n")
    					  .append(")												 \n")
    					  .toString();
    					  
			  resultInt = super.excuteUpdate(con, sql); 
			  
			  if(resultInt < 0) {
				  ioParam.setMessage(MessageDefine.M_INSERT_FAILED); 
				  con.rollback(); return
				  EventDefine.E_DOEXCUTE_ERROR;
			  }
		
			  sql = new StringBuilder()
						.append("SELECT\n")
						.append("	regist_seq_no\n")
						.append("FROM\n")
						.append("	haccp_inferior_regist\n")
						.append("WHERE ROWNUM = 1\n")
						.append("ORDER BY regist_seq_no DESC\n")
						.toString();

			  resultString = super.excuteQueryString(con, sql);
			
			  System.out.println("GGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGG : "+resultString.trim());
			  
			  sql = new StringBuilder()
						.append("INSERT INTO											\n")
						.append("	haccp_inferior_regist_detail (						\n")
						.append("		regist_seq_no,									\n")
						.append("		inferior_nm,									\n")
						.append("		inferior_gubun,									\n")
						.append("		occur_date,										\n")
						.append("		occur_place,									\n")	//
						.append("		inferior_quantity,								\n")
						.append("		inferior_content,								\n")
						.append("		inferior_reason,								\n")
						.append("		inferior_solution,								\n")
						.append("		action_gubun,									\n")	//
						.append("		action_date,									\n")
						.append("		action_quantity,								\n")
						.append("		action_detail,									\n")
						.append("		result_check_yn									\n")	//14
						.append("	)													\n")
						.append("VALUES													\n")
						.append("	(													\n")
						.append("		'"+resultString.trim()+"',						\n")
						.append("		'"+jObj.get("inferior_nm").toString()+"',		\n")
						.append("		'"+jObj.get("inferior_gubun").toString()+"',	\n")
						.append("		'"+jObj.get("occur_date").toString()+"',		\n")
						.append("		'"+jObj.get("occur_place").toString()+"',		\n")	//
						.append("		'"+jObj.get("inferior_quantity").toString()+"',	\n")
						.append("		'"+jObj.get("inferior_content").toString()+"',	\n")
						.append("		'"+jObj.get("inferior_reason").toString()+"',	\n")
						.append("		'"+jObj.get("inferior_solution").toString()+"',	\n")
						.append("		'"+jObj.get("action_gubun").toString()+"',		\n")	//
						.append("		'"+jObj.get("action_date").toString()+"',		\n")
						.append("		'"+jObj.get("action_quantity").toString()+"',	\n")
						.append("		'"+jObj.get("action_detail").toString()+"',		\n")
						.append("		'"+jObj.get("result_check_yn").toString()+"'	\n")	//14
						.append("	);\n")
						.toString();

			  
			  resultInt = super.excuteUpdate(con, sql); 
			  
			  if(resultInt < 0) {
				  ioParam.setMessage(MessageDefine.M_INSERT_FAILED); 
				  con.rollback(); return
				  EventDefine.E_DOEXCUTE_ERROR;
			  }
			  
			  con.commit();
			 
		} catch(Exception e) {
			e.getStackTrace();
			LoggingWriter.setLogError("M838S070650E101()","==== SQL ERROR ===="+ e.getMessage());
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
    		
    		String regist_seq_no = jObj.get("regist_seq_no").toString();
    		
    		String sql = new StringBuilder()
    				.append("DELETE FROM haccp_inferior_regist_detail\n")
    				.append("WHERE regist_seq_no = '"+regist_seq_no+"'\n")
    				.toString();
    		
    		resultInt = super.excuteUpdate(con, sql);
    		if(resultInt < 0) {
				ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
				con.rollback();
				return EventDefine.E_DOEXCUTE_ERROR ;
			}
    		
    		sql = new StringBuilder()
					.append("INSERT INTO											\n")
					.append("	haccp_inferior_regist_detail (						\n")
					.append("		regist_seq_no,									\n")
					.append("		inferior_nm,									\n")
					.append("		inferior_gubun,									\n")
					.append("		occur_date,										\n")
					.append("		occur_place,									\n")	//
					.append("		inferior_quantity,								\n")
					.append("		inferior_content,								\n")
					.append("		inferior_reason,								\n")
					.append("		inferior_solution,								\n")
					.append("		action_gubun,									\n")	//
					.append("		action_date,									\n")
					.append("		action_quantity,								\n")
					.append("		action_detail,									\n")
					.append("		result_check_yn									\n")	//14
					.append("	)													\n")
					.append("VALUES													\n")
					.append("	(													\n")
					.append("		'"+regist_seq_no+"',							\n")
					.append("		'"+jObj.get("inferior_nm").toString()+"',		\n")
					.append("		'"+jObj.get("inferior_gubun").toString()+"',	\n")
					.append("		'"+jObj.get("occur_date").toString()+"',		\n")
					.append("		'"+jObj.get("occur_place").toString()+"',		\n")	//
					.append("		'"+jObj.get("inferior_quantity").toString()+"',	\n")
					.append("		'"+jObj.get("inferior_content").toString()+"',	\n")
					.append("		'"+jObj.get("inferior_reason").toString()+"',	\n")
					.append("		'"+jObj.get("inferior_solution").toString()+"',	\n")
					.append("		'"+jObj.get("action_gubun").toString()+"',		\n")	//
					.append("		'"+jObj.get("action_date").toString()+"',		\n")
					.append("		'"+jObj.get("action_quantity").toString()+"',	\n")
					.append("		'"+jObj.get("action_detail").toString()+"',		\n")
					.append("		'"+jObj.get("result_check_yn").toString()+"'	\n")	//14
					.append("	)													\n")
					.toString();

		  resultInt = super.excuteUpdate(con, sql); 
		  
		  if(resultInt < 0) {
			  ioParam.setMessage(MessageDefine.M_INSERT_FAILED); 
			  con.rollback(); return
			  EventDefine.E_DOEXCUTE_ERROR;
		  }
		  
		  sql = new StringBuilder()
	    			.append("UPDATE haccp_inferior_regist 						\n")
	    			.append("SET 	person_check_id='', person_approve_id='' 	\n")
	    			.append("WHERE  regist_seq_no='"+regist_seq_no+"'			\n")
	    			.toString();

		  resultInt = super.excuteUpdate(con, sql); 
		  
		  if(resultInt < 0) {
			  ioParam.setMessage(MessageDefine.M_INSERT_FAILED); 
			  con.rollback(); return
			  EventDefine.E_DOEXCUTE_ERROR;
		  }
		  
		  con.commit();
		} catch(Exception e) {
			e.getStackTrace();
			LoggingWriter.setLogError("M838S070650E102()","==== SQL ERROR ===="+ e.getMessage());
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
    		
    		String regist_seq_no = jObj.get("regist_seq_no").toString();
    		
    		String sql = new StringBuilder()
    				.append("DELETE FROM									\n")
    				.append("	haccp_inferior_regist_detail 				\n")
    				.append("WHERE											\n")
    				.append("		 regist_seq_no = '"+regist_seq_no+"'	\n")
    				.toString();
    		
    		resultInt = super.excuteUpdate(con, sql);
	    	if(resultInt < 0) {
				ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
				con.rollback();
				return EventDefine.E_DOEXCUTE_ERROR ;
			}
	    	
	    	sql = new StringBuilder()
    				.append("DELETE FROM									\n")
    				.append("	haccp_inferior_regist		 				\n")
    				.append("WHERE											\n")
    				.append("		regist_seq_no = '"+regist_seq_no+"'		\n")
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
			LoggingWriter.setLogError("M838S070650E103()","==== SQL ERROR ===="+ e.getMessage());
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
					.append("SELECT\n")
					.append("	checklist_id,\n")
					.append("	checklist_rev_no,\n")
					.append("	regist_date,\n")
					.append("	A.regist_seq_no,\n")
					.append("	inferior_nm,\n")
					.append("	inferior_gubun,\n")
					.append("	occur_date,\n")
					.append("	occur_place,\n")
					.append("	inferior_quantity,\n")
					.append("	inferior_content,\n")
					.append("	C.user_nm AS person_write_id,							\n")
					.append("	D.user_nm AS person_check_id,							\n")
					.append("	E.user_nm AS person_approve_id							\n")
					.append("FROM\n")
					.append("	haccp_inferior_regist A JOIN haccp_inferior_regist_detail B\n")
					.append("	ON A.regist_seq_no = B.regist_seq_no\n")
					.append("	LEFT JOIN tbm_users C									\n")
					.append("			ON A.person_write_id = C.user_id				\n")
					.append("			AND  A.regist_date BETWEEN CAST(C.start_date AS DATE) AND CAST(C.duration_date AS DATE) \n")
					.append("	LEFT JOIN tbm_users D									\n")
					.append("			ON A.person_check_id = D.user_id				\n")
					.append("			AND  A.regist_date BETWEEN CAST(D.start_date AS DATE) AND CAST(D.duration_date AS DATE) \n")
					.append("	LEFT JOIN tbm_users E									\n")
					.append("			ON A.person_approve_id = E.user_id				\n")
					.append("			AND  A.regist_date BETWEEN CAST(E.start_date AS DATE) AND CAST(E.duration_date AS DATE)\n")
					.append("WHERE regist_date BETWEEN '"+ jArray.get("fromdate") + "' 	\n")  
					.append("                     AND '"+ jArray.get("todate") + "' 	\n")
					.append("ORDER BY A.regist_seq_no DESC							 	\n")  
					.toString();

			resultString = super.excuteQueryString(con, sql);
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M838S070650E104()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) {
						con.close();
					}
				} catch (Exception e) {
					LoggingWriter.setLogError("M838S070650E104()","==== finally ===="+ e.getMessage());
				}
	    	}
	    }

		ioParam.setResultString(resultString);
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
    	ioParam.setMessage(MessageDefine.M_QUERY_OK);

    	return EventDefine.E_QUERY_RESULT;
	}
	
	// 상세 테이블 조회
	public int E114(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			
			String div = jArray.get("div").toString().trim();
			
			String sql = "";
			
			if("1".equals(div)) {
				
				sql = new StringBuilder()
						.append("SELECT\n")
						.append("	regist_seq_no,\n")
						.append("	inferior_reason,\n")
						.append("	inferior_solution\n")
						.append("FROM\n")
						.append("	haccp_inferior_regist_detail\n")
						.append("WHERE\n")
						.append("	regist_seq_no = '"+jArray.get("regist_seq_no").toString()+"'\n")
						.append("ORDER BY regist_seq_no DESC \n")
						.toString();
				
			} else if("2".equals(div)) {
				
				sql = new StringBuilder()
						.append("SELECT\n")
						.append("	regist_seq_no,\n")
						.append("	action_gubun,\n")
						.append("	action_date,\n")
						.append("	action_quantity,\n")
						.append("	action_detail,\n")
						.append("	result_check_yn\n")
						.append("FROM\n")
						.append("	haccp_inferior_regist_detail\n")
						.append("WHERE\n")
						.append("	regist_seq_no = '"+jArray.get("regist_seq_no").toString()+"'\n")
						.append("ORDER BY regist_seq_no DESC \n")
						.toString();
	
			}
			
			resultString = super.excuteQueryString(con, sql);
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M838S070650E114()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) {
						con.close();
					}
				} catch (Exception e) {
					LoggingWriter.setLogError("M838S070650E114()","==== finally ===="+ e.getMessage());
				}
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
			
			String regist_seq_no = jArray.get("regist_seq_no").toString();

			String sql = new StringBuilder()
					.append("SELECT\n")
					.append("	checklist_id,\n")
					.append("	checklist_rev_no,\n")
					.append("	A.regist_seq_no,\n")
					.append("	regist_date,\n")
					.append("	inferior_nm,\n")
					.append("	inferior_gubun,\n")
					.append("	occur_date,\n")
					.append("	occur_place,\n")
					.append("	inferior_quantity,\n")
					.append("	inferior_content,\n")
					.append("	inferior_reason,\n")
					.append("	inferior_solution,\n")
					.append("	action_gubun,\n")
					.append("	action_date,\n")
					.append("	action_quantity,\n")
					.append("	action_detail,\n")
					.append("	result_check_yn,\n")
					.append("	C.user_nm AS person_write_id,							\n")
					.append("	D.user_nm AS person_check_id,							\n")
					.append("	E.user_nm AS person_approve_id							\n")
					.append("FROM\n")
					.append("	haccp_inferior_regist A JOIN haccp_inferior_regist_detail B\n")
					.append("	ON A.regist_seq_no = B.regist_seq_no\n")
					.append("	LEFT JOIN tbm_users C									\n")
					.append("			ON A.person_write_id = C.user_id				\n")
					.append("			AND  A.regist_date BETWEEN CAST(C.start_date AS DATE) AND CAST(C.duration_date AS DATE) \n")
					.append("	LEFT JOIN tbm_users D									\n")
					.append("			ON A.person_check_id = D.user_id				\n")
					.append("			AND  A.regist_date BETWEEN CAST(D.start_date AS DATE) AND CAST(D.duration_date AS DATE) \n")
					.append("	LEFT JOIN tbm_users E									\n")
					.append("			ON A.person_approve_id = E.user_id				\n")
					.append("			AND  A.regist_date BETWEEN CAST(E.start_date AS DATE) AND CAST(E.duration_date AS DATE)\n")
					.append("WHERE A.regist_seq_no = '"+regist_seq_no+"'\n")
					.append("ORDER BY A.regist_seq_no DESC\n")
					.toString();

			resultString = super.excuteQueryString(con, sql);
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M838S070650E144()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M838S070650E144()","==== finally ===="+ e.getMessage());
				}
	    	} else {
	    	}
	    }
		ioParam.setResultString(resultString);
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
    	ioParam.setMessage(MessageDefine.M_QUERY_OK);

    	return EventDefine.E_QUERY_RESULT;
	}
	
	// 수정하기전 가져오는 데이터
	public int E154(InoutParameter ioParam){
		
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));

			String sql = new StringBuilder()
					.append("SELECT\n")
					.append("	checklist_id,\n")
					.append("	checklist_rev_no,\n")
					.append("	A.regist_seq_no,\n")
					.append("	regist_date,\n")
					.append("	inferior_nm,\n")
					.append("	inferior_gubun,\n")
					.append("	occur_date,\n")
					.append("	occur_place,\n")
					.append("	inferior_quantity,\n")
					.append("	inferior_content,\n")
					.append("	inferior_reason,\n")
					.append("	inferior_solution,\n")
					.append("	action_gubun,\n")
					.append("	action_date,\n")
					.append("	action_quantity,\n")
					.append("	action_detail,\n")
					.append("	result_check_yn \n")
					.append("FROM\n")
					.append("	haccp_inferior_regist A JOIN haccp_inferior_regist_detail B\n")
					.append("	ON A.regist_seq_no = B.regist_seq_no\n")
					.append("	WHERE A.regist_seq_no = '"+jArray.get("regist_seq_no")+"'\n")
					.toString();
						
			resultString = super.excuteQueryString(con, sql);
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M838S070650E154()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) {
						con.close();
					}
				} catch (Exception e) {
					LoggingWriter.setLogError("M838S070650E154()","==== finally ===="+ e.getMessage());
				}
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
    				.append("UPDATE haccp_inferior_regist									\n")
    				.append("SET															\n")
    				.append("	person_approve_id = '" + jObj.get("userId") + "'			\n")
    				.append("WHERE regist_seq_no = '"+ jObj.get("seq_no") + "'				\n")
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
			LoggingWriter.setLogError("M838S070650E502()","==== SQL ERROR ===="+ e.getMessage());
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
	
	// 점검표 확인자 서명 --> 원래 있던거에서 수정
	public int E522(InoutParameter ioParam){ 
		
		resultInt = EventDefine.E_DOEXCUTE_INIT;

		try {
			con = JDBCConnectionPool.getConnection();
			con.setAutoCommit(false);
			
    		JSONObject jObj = new JSONObject();
    		jObj = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
    		
    		String sql = new StringBuilder()
    				.append("UPDATE haccp_inferior_regist									\n")
    				.append("SET															\n")
    				.append("	person_check_id = '" + jObj.get("userId") + "'				\n")
    				.append("WHERE regist_seq_no = '"+ jObj.get("seq_no") + "'				\n")
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
			LoggingWriter.setLogError("M838S070650E522()","==== SQL ERROR ===="+ e.getMessage());
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