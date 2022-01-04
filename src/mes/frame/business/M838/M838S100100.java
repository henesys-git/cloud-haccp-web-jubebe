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
 * 거래처 관리 목록
 * 
 * 작성자: 서승헌
 * 일시: 2021-03-29
 * 
 * */


/**
 * 개요 : 이벤트ID별 메소드 정의
 */
public class M838S100100 extends SqlAdapter{
	Connection con = null;
	PreparedStatement pstmt = null;
	String resultString = "";
	int resultInt = -1;
	StringBuffer sql = new StringBuffer();
	
	String[][] v_paramArray = new String[0][0]; 
	Class[] optClass = null;
	Object[] optObj = null;
	Object obj = null;
	
	public M838S100100(){
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
			
			Method method = M838S100100.class.getMethod(event,optClass);
			LoggingWriter.setLogDebug(M838S100100.class.getName(),"==== " + event + " EventMethod Create Success ====");

			obj = method.invoke(M838S100100.class.newInstance(),optObj);
			doExcute_result = CommonFunction.getInt(obj.toString());
			
	    } catch (Exception ex) {
	    	doExcute_result = EventDefine.E_DOEXCUTE_INIT;
			ioParam.setMessage(MessageDefine.M_NO_EVENTID);
			LoggingWriter.setLogError(M838S100100.class.getName(),"==== EventID Not define : EVENT ID [ " + ioParam.getEventID() + "]");
	    } finally {
	    	obj = null;
			optClass = null;
			optObj = null;
	    }
	    long endTime = System.currentTimeMillis();
		long runningTime = endTime - startTime;
		LoggingWriter.setLogAll(M838S100100.class.getName(),"==== Query [수행시간  : " + runningTime + " ms]");
		
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
    		String regist_date = jObj.get("regist_date").toString();

    		String sql = new StringBuilder()
    				.append("SELECT * 							\n")
    				.append("FROM haccp_customer_list			\n")
    				.append("WHERE								\n")
    				.append("	regist_date = '"+regist_date+"' \n")
    				.toString();
    		
    		resultString = super.excuteQueryString(con, sql);
    		
    		// 해당되는 작성일자가 이미 list 테이블이 있는지 없는지 (0 : 없음 / 1 : 있음)
    		int length = resultString.length();

    		System.out.println("FAGHKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKK : " + length);
    		int cnt = 0;
    		
    		if(length > 0) {
    		
	    		sql = new StringBuilder()
	    				.append("SELECT COUNT(*)\n")
	    				.append("	FROM haccp_customer_list_detail	\n")
	    				.append("	GROUP BY (regist_date)			\n")
	    				.append("	HAVING regist_date = '"+regist_date+"' \n")
	    				.toString();
	    		
	    		resultString = super.excuteQueryString(con, sql);
	    		
	    		// 해당되는 작성일자 detail 테이블에 점검표 기록이 몇개 있는지 count    	
	    		cnt = Integer.parseInt(resultString.trim());
    		}
    		
    		regist_date = "'"+regist_date+"'";
    		
    		if(cnt >= 9) {	regist_date = "ADDDATE(SYSDATE,1)";	}
    		
    		if(length == 0 || cnt == 9) {
    			
    			sql = new StringBuilder()
        				.append("INSERT INTO										 \n")
        				.append("	haccp_customer_list (	 						 \n")
        				.append("		regist_date,								 \n")
        				.append("    	checklist_id,								 \n")
        				.append("   	checklist_rev_no,							 \n")
        				.append("    	person_write_id		 						 \n")
        				.append(") VALUES (									 		 \n")
        				.append("		"+regist_date+",							 \n")
        				.append("		'"+checklist_id+"',							 \n")
        				.append("    	(SELECT MAX(checklist_rev_no)				 \n")
        				.append("    	FROM checklist								 \n")
        				.append("    	WHERE checklist_id = '"+checklist_id+"'),	 \n")
        				.append("		'"+jObj.get("person_write_id")+"'		 	 \n")
        				.append(")													 \n")
        				.toString();
    			
    			resultInt = super.excuteUpdate(con, sql);
    	    	if(resultInt < 0) {
    				ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
    				con.rollback();
    				return EventDefine.E_DOEXCUTE_ERROR ;
    			}
    	    	
    		}
    		
	    	sql = new StringBuilder()
	    			.append("INSERT INTO										 \n")
	    			.append("	haccp_customer_list_detail (					 \n")
	    			.append("		regist_date,								 \n")
	    			.append("		approve_date,								 \n")
	    			.append("		supply_item,							 	 \n")
	    			.append("		cust_nm,									 \n")
	    			.append("		cust_address,							 	 \n")
	    			.append("		cust_telno,									 \n")
	    			.append("		approve_reason							 	 \n")
	    			.append("	)												 \n")
	    			.append("VALUES												 \n")
	    			.append("	(												 \n")
	    			.append("		 "+regist_date+", 							 \n")
	    			.append("		 '"+jObj.get("approve_date")+"', 			 \n")
	    			.append("		 '"+jObj.get("supply_item")+"',			 	 \n")
	    			.append("		 '"+jObj.get( "cust_nm")+"', 	 			 \n")
	    			.append("		 '"+jObj.get( "cust_address")+"',		  	 \n")
	    			.append("		 '"+jObj.get( "cust_telno")+"', 	 		 \n")
	    			.append("		 '"+jObj.get( "approve_reason")+"' 			 \n")
	    			.append("	) 												 \n")
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
			LoggingWriter.setLogError("M838S100100E101()","==== SQL ERROR ===="+ e.getMessage());
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
		
	/*
	 * // 수정 ==> 안씀 // DELETE 후 등록 쿼리 그대로 재사용 public int E102(InoutParameter
	 * ioParam){ resultInt = EventDefine.E_DOEXCUTE_INIT;
	 * 
	 * try { con = JDBCConnectionPool.getConnection(); con.setAutoCommit(false);
	 * 
	 * JSONObject jObj = new JSONObject(); jObj =
	 * (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
	 * 
	 * String checklist_id = jObj.get("checklist_id").toString(); String regist_date
	 * = jObj.get("regist_date").toString();
	 * 
	 * JSONArray types = new JSONArray(); types = (JSONArray) jObj.get("types");
	 * 
	 * String sql = new StringBuilder() .append("DELETE FROM\n")
	 * .append("	haccp_waste \n") .append("WHERE\n")
	 * .append("	regist_date = '"+regist_date+"'\n") .toString();
	 * 
	 * resultInt = super.excuteUpdate(con, sql); if(resultInt < 0) {
	 * ioParam.setMessage(MessageDefine.M_INSERT_FAILED); con.rollback(); return
	 * EventDefine.E_DOEXCUTE_ERROR ; }
	 * 
	 * sql = new StringBuilder()
	 * .append("INSERT INTO										\n")
	 * .append("	haccp_waste  (									\n")
	 * .append("		regist_date,									\n")
	 * .append("		checklist_id,								\n")
	 * .append("		checklist_rev_no,							\n")
	 * .append("		waste_nm,									\n")
	 * .append("		weight,										\n")
	 * .append("		content,									\n")
	 * .append("		check_yn,									\n")
	 * .append("		person_write_id								\n")
	 * .append(") VALUES (											\n")
	 * .append("		'"+regist_date+"',							\n")
	 * .append("		'"+checklist_id+"',							\n")
	 * .append("		(SELECT MAX(checklist_rev_no)				\n")
	 * .append("		FROM checklist								\n")
	 * .append("		WHERE checklist_id = '"+checklist_id+"'),	\n")
	 * .append("		'"+jObj.get("waste_nm")+"',					\n")
	 * .append("		'"+jObj.get("weight")+"',					\n")
	 * .append("		'"+jObj.get("content")+"',					\n")
	 * .append("		'"+jObj.get("check_yn")+"',					\n")
	 * .append("		'"+jObj.get("person_write_id")+"'			\n")
	 * .append(")													\n")
	 * .toString();
	 * 
	 * resultInt = super.excuteUpdate(con, sql); if(resultInt < 0) {
	 * ioParam.setMessage(MessageDefine.M_INSERT_FAILED); con.rollback(); return
	 * EventDefine.E_DOEXCUTE_ERROR ; }
	 * 
	 * con.commit(); } catch(Exception e) { e.getStackTrace();
	 * LoggingWriter.setLogError("M838S100100E102()","==== SQL ERROR ===="+
	 * e.getMessage()); return EventDefine.E_DOEXCUTE_ERROR; } finally { if
	 * (Config.useDataSource) { try { if (con != null) con.close(); } catch
	 * (Exception e) { } } else { } } ioParam.setResultString(resultString);
	 * ioParam.setColumnCount("" + super.COLUMN_COUNT);
	 * ioParam.setMessage(MessageDefine.M_QUERY_OK); return
	 * EventDefine.E_QUERY_RESULT; }
	 */

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
    		String regist_date = jObj.get("regist_date").toString();
    		
    		String sql = new StringBuilder()
    				.append("DELETE FROM									\n")
    				.append("	haccp_customer_list_detail					\n")
    				.append("WHERE											\n")
    				.append("		 regist_date = '"+regist_date+"'		\n")
    				.toString();
    		
    		resultInt = super.excuteUpdate(con, sql);
	    	if(resultInt < 0) {
				ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
				con.rollback();
				return EventDefine.E_DOEXCUTE_ERROR ;
			}
    		
    		sql = new StringBuilder()
    				.append("DELETE FROM\n")
    				.append("	haccp_customer_list \n")
    				.append("WHERE\n")
    				.append("	checklist_id = '"+checklist_id+"'\n")
    				.append("	AND checklist_rev_no = "+checklist_rev_no+"\n")
    				.append("	AND regist_date = '"+regist_date+"'\n")
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
			LoggingWriter.setLogError("M838S100100E103()","==== SQL ERROR ===="+ e.getMessage());
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
					.append("	A.regist_date,											\n")
					.append("	B.user_nm AS person_write_id,							\n")
					.append("	C.user_nm AS person_check_id,							\n")
					.append("	D.user_nm AS person_approve_id							\n")
					.append("FROM haccp_customer_list A									\n")
					.append("LEFT JOIN tbm_users B										\n")
					.append("	ON A.person_write_id = B.user_id						\n")
					.append("AND  regist_date BETWEEN CAST(B.start_date AS DATE) AND CAST(B.duration_date AS DATE) \n")
					.append("LEFT JOIN tbm_users C										\n")
					.append("	ON A.person_check_id = C.user_id						\n")
					.append("AND  regist_date BETWEEN CAST(C.start_date AS DATE) AND CAST(C.duration_date AS DATE) \n")
					.append("LEFT JOIN tbm_users D										\n")
					.append("	ON A.person_approve_id = D.user_id						\n")
					.append("AND  regist_date BETWEEN CAST(D.start_date AS DATE) AND CAST(D.duration_date AS DATE) \n")
					.append("WHERE regist_date BETWEEN '"+ jArray.get("fromdate") + "' 	\n")  
					.append("                     AND '"+ jArray.get("todate") + "' 	\n")
					.append("ORDER BY regist_date DESC \n")
					.toString();

			resultString = super.excuteQueryString(con, sql);
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M838S100100E104()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) {
						con.close();
					}
				} catch (Exception e) {
					LoggingWriter.setLogError("M838S100100E104()","==== finally ===="+ e.getMessage());
				}
	    	}
	    }

		ioParam.setResultString(resultString);
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
    	ioParam.setMessage(MessageDefine.M_QUERY_OK);

    	return EventDefine.E_QUERY_RESULT;
	}
		
	// 서브 테이블 등록
	public int E111(InoutParameter ioParam){ 
		resultInt = EventDefine.E_DOEXCUTE_INIT;

		try {
			con = JDBCConnectionPool.getConnection();
			con.setAutoCommit(false);
			
    		JSONObject jObj = new JSONObject();
    		jObj = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
    		
    		String regist_date = jObj.get("regist_date").toString();
    		
    		regist_date = "'"+regist_date+"'";

    		int cnt = 0;
    		
	    	String	sql = new StringBuilder()
	    				.append("SELECT COUNT(*)						  \n")
	    				.append("	FROM haccp_customer_list_detail		  \n")
	    				.append("	GROUP BY (regist_date)				  \n")
	    				.append("	HAVING regist_date = "+regist_date+"  \n")
	    				.toString();
    		
    		resultString = super.excuteQueryString(con, sql);
    		
    		if(resultString.length() != 0) {
	    		// 해당되는 작성일자 detail 테이블에 점검표 기록이 몇개 있는지 count    	
	    		cnt = Integer.parseInt(resultString.trim());
    		}
    		
    		if(cnt == 9) {
    			
    			regist_date = "ADDDATE(SYSDATE,1)";
    			
    			sql = new StringBuilder()
        				.append("INSERT INTO										 \n")
        				.append("	haccp_customer_list (	 						 \n")
        				.append("		regist_date,								 \n")
        				.append("    	checklist_id,								 \n")
        				.append("   	checklist_rev_no,							 \n")
        				.append("    	person_write_id		 						 \n")
        				.append(") VALUES (									 		 \n")
        				.append("		"+regist_date+",							 \n")
        				.append("		'"+jObj.get("checklist_id")+"',			 	 \n")
        				.append("    	(SELECT MAX(checklist_rev_no)				 \n")
        				.append("    	FROM checklist								 \n")
        				.append("    	WHERE checklist_id = '"+jObj.get("checklist_id")+"'),	 \n")
        				.append("		'"+jObj.get("person_write_id")+"'		 	 \n")
        				.append(")													 \n")
        				.toString();
    			
    			resultInt = super.excuteUpdate(con, sql);
    	    	if(resultInt < 0) {
    				ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
    				con.rollback();
    				return EventDefine.E_DOEXCUTE_ERROR ;
    			}
    	    	
    		}
    		
    		
    		sql = new StringBuilder()
	    			.append("INSERT INTO										 \n")
	    			.append("	haccp_customer_list_detail (					 \n")
	    			.append("		regist_date,								 \n")
	    			.append("		approve_date,								 \n")
	    			.append("		supply_item,							 	 \n")
	    			.append("		cust_nm,									 \n")
	    			.append("		cust_address,							 	 \n")
	    			.append("		cust_telno,									 \n")
	    			.append("		approve_reason							 	 \n")
	    			.append("	)												 \n")
	    			.append("VALUES												 \n")
	    			.append("	(												 \n")
	    			.append("		 "+regist_date+", 				 			 \n")
	    			.append("		 '"+jObj.get("approve_date")+"', 			 \n")
	    			.append("		 '"+jObj.get("supply_item")+"',			 	 \n")
	    			.append("		 '"+jObj.get("cust_nm")+"', 	 			 \n")
	    			.append("		 '"+jObj.get("cust_address")+"',		  	 \n")
	    			.append("		 '"+jObj.get("cust_telno")+"', 	 		 	 \n")
	    			.append("		 '"+jObj.get("approve_reason")+"' 			 \n")
	    			.append("	) 												 \n")
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
			LoggingWriter.setLogError("M838S100100111()","==== SQL ERROR ===="+ e.getMessage());
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
	
	// 거래처 관리 처리 명단 수정
	public int E112(InoutParameter ioParam){ 
		resultInt = EventDefine.E_DOEXCUTE_INIT;

		try {
			con = JDBCConnectionPool.getConnection();
			con.setAutoCommit(false);
			
			JSONObject jObj = new JSONObject();
    		jObj = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
    		
    		String checklist_id = jObj.get("checklist_id").toString();
    		String checklist_rev_no = jObj.get("checklist_rev_no").toString();
    		String regist_date = jObj.get("regist_date").toString();
    		
    		String sql = new StringBuilder()
    				.append("UPDATE haccp_customer_list_detail									    \n")
    				.append("SET 																	\n")
    				.append("	  approve_date='"+jObj.get("approve_date").toString()+"',			\n")
    				.append("	  supply_item='"+jObj.get("supply_item").toString()+"',				\n")
    				.append("	  cust_nm='"+jObj.get("cust_nm").toString()+"',						\n")
    				.append("	  cust_address='"+jObj.get("cust_address").toString()+"',			\n")
    				.append("	  cust_telno='"+jObj.get("cust_telno").toString()+"',				\n")
    				.append("	  approve_reason='"+jObj.get("approve_reason").toString()+"'		\n")			
    				.append("WHERE seq_no="+jObj.get("seq_no").toString()+"							\n")
    				.toString();

    		resultInt = super.excuteUpdate(con, sql);
	    	if(resultInt < 0) {
				ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
				con.rollback();
				return EventDefine.E_DOEXCUTE_ERROR ;
			}
	    	
	    	sql = new StringBuilder()
	    			.append("UPDATE haccp_customer_list 						\n")
	    			.append("SET 	person_check_id='', person_approve_id='' 	\n")
	    			.append("WHERE  regist_date='"+regist_date+"' 				\n")
	    			.append("AND	checklist_id='"+checklist_id+"' 			\n")
	    			.append("AND	checklist_rev_no='"+checklist_rev_no+"' 	\n")
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
			LoggingWriter.setLogError("M838S100100E112()","==== SQL ERROR ===="+ e.getMessage());
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
	
	// 거래처 관리 처리 명단 삭제
	public int E113(InoutParameter ioParam){ 
		resultInt = EventDefine.E_DOEXCUTE_INIT;

		try {
			con = JDBCConnectionPool.getConnection();
			con.setAutoCommit(false);
			
    		JSONObject jObj = new JSONObject();
    		jObj = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
    		
    		String seq_no = jObj.get("seq_no").toString();
    		
    		String sql = new StringBuilder()
    				.append("DELETE FROM									\n")
    				.append("	haccp_customer_list_detail 					\n")
    				.append("WHERE											\n")
    				.append("		 seq_no = '"+seq_no+"'					\n")
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
			LoggingWriter.setLogError("M838S100100E113()","==== SQL ERROR ===="+ e.getMessage());
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
	
	// 서브 테이블 조회
	public int E114(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			
			String sql = new StringBuilder()
					.append("SELECT														\n")
					.append("	seq_no,													\n")
					.append("	regist_date,											\n")
					.append("	approve_date,											\n")
					.append("	supply_item,											\n")
					.append("	cust_nm,												\n")
					.append("	cust_address,											\n")
					.append("	cust_telno,												\n")
					.append("	approve_reason											\n")
					.append("FROM														\n")
					.append("	haccp_customer_list_detail								\n")
					.append("WHERE														\n")
					.append("	regist_date = '"+jArray.get("regist_date")+"' 			\n")
					.append("ORDER BY seq_no DESC										\n")
					.toString();

			resultString = super.excuteQueryString(con, sql);
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M838S10010E114()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) {
						con.close();
					}
				} catch (Exception e) {
					LoggingWriter.setLogError("M838S10010E114()","==== finally ===="+ e.getMessage());
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
			
			String regist_date = jArray.get("regist_date").toString();

			String sql = new StringBuilder()
					.append("SELECT  	A.checklist_id, 											\n")
					.append("			A.checklist_rev_no,											\n")
					.append("			B.approve_date,												\n")
					.append("			B.supply_item, 												\n")
					.append("			B.cust_nm,													\n")
					.append("			B.cust_address,												\n")
					.append("			B.cust_telno,												\n")
					.append("			B.approve_reason,											\n")
					.append("			C.user_nm AS person_write_id,			 					\n")
					.append("			D.user_nm AS person_check_id,  								\n")
					.append("			E.user_nm AS person_approve_id								\n")
					.append("FROM haccp_customer_list A 											\n")
					.append("JOIN haccp_customer_list_detail B 										\n")
					.append("ON A.regist_date = B.regist_date										\n")
					.append("LEFT JOIN tbm_users C													\n")
					.append("		ON A.person_write_id = C.user_id								\n")
					.append("		AND  A.regist_date BETWEEN CAST(C.start_date AS DATE) AND CAST(C.duration_date AS DATE)  \n")
					.append("LEFT JOIN tbm_users D													\n")
					.append("		ON A.person_check_id = D.user_id								\n")
					.append("		AND  A.regist_date BETWEEN CAST(D.start_date AS DATE) AND CAST(D.duration_date AS DATE)  \n")
					.append("LEFT JOIN tbm_users E													\n")
					.append("		ON A.person_approve_id = E.user_id								\n")
					.append("		AND  A.regist_date BETWEEN CAST(E.start_date AS DATE) AND CAST(E.duration_date AS DATE)  \n")
					.append("WHERE A.regist_date = '"+regist_date+"'								\n")
					.toString();

			resultString = super.excuteQueryString(con, sql);
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M838S100100E144()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M838S100100E144()","==== finally ===="+ e.getMessage());
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
    				.append("UPDATE haccp_customer_list										\n")
    				.append("SET															\n")
    				.append("	person_approve_id = '" + jObj.get("userId") + "'			\n")
    				.append("WHERE regist_date = '"+ jObj.get("checklistDate") + "'			\n")
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
			LoggingWriter.setLogError("M838S100100E502()","==== SQL ERROR ===="+ e.getMessage());
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
    				.append("UPDATE haccp_customer_list										\n")
    				.append("SET															\n")
    				.append("	person_check_id = '" + jObj.get("userId") + "'				\n")
    				.append("WHERE regist_date = '"+ jObj.get("checklistDate") + "'			\n")
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
			LoggingWriter.setLogError("M838S100100E522()","==== SQL ERROR ===="+ e.getMessage());
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