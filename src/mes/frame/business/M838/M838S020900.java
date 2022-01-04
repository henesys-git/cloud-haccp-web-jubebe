package mes.frame.business.M838;

import java.lang.reflect.Method;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.util.ArrayList;

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
public class M838S020900 extends SqlAdapter{
	Connection con = null;
	PreparedStatement pstmt = null;
	String resultString = "";
	int resultInt = -1;
	StringBuffer sql = new StringBuffer();
	
	String[][] v_paramArray = new String[0][0]; 
	Class[] optClass = null;
	Object[] optObj = null;
	Object obj = null;
	
	public M838S020900(){
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
			
			Method method = M838S020900.class.getMethod(event,optClass);
			LoggingWriter.setLogDebug(M838S020900.class.getName(),"==== " + event + " EventMethod Create Success ====");

			obj = method.invoke(M838S020900.class.newInstance(),optObj);
			doExcute_result = CommonFunction.getInt(obj.toString());
			
	    } catch (Exception ex) {
	    	doExcute_result = EventDefine.E_DOEXCUTE_INIT;
			ioParam.setMessage(MessageDefine.M_NO_EVENTID);
			LoggingWriter.setLogError(M838S020900.class.getName(),"==== EventID Not define : EVENT ID [ " + ioParam.getEventID() + "]");
	    } finally {
	    	obj = null;
			optClass = null;
			optObj = null;
	    }
	    long endTime = System.currentTimeMillis();
		long runningTime = endTime - startTime;
		LoggingWriter.setLogAll(M838S020900.class.getName(),"==== Query [수행시간  : " + runningTime + " ms]");
		
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
    		String regist_date = "TO_CHAR(SYSDATE,'YYYY-MM-DD')";    		
    		
    		String sql = new StringBuilder()
    				.append("SELECT regist_date\n")
    				.append("FROM haccp_produce_facility\n")
    				.append("WHERE TO_CHAR(regist_date, 'MM') = TO_CHAR(SYSDATE,'MM')\n")
    				.toString();

    		resultString = super.excuteQueryString(con, sql);
    		
    		if(resultString.length() == 0) {
    			
    			sql = new StringBuilder()
        				.append("INSERT INTO\n")
        				.append("	haccp_produce_facility (\n")
        				.append("		regist_date,\n")
        				.append("		checklist_id,\n")
        				.append("		checklist_rev_no,\n")
        				.append("		occur_time,\n")
        				.append("		occur_place,\n")
        				.append("		unsuit_detail,\n")
        				.append("		improve_action\n")
        				.append("	)\n")
        				.append("VALUES\n")
        				.append("	(\n")
        				.append("		TO_CHAR(SYSDATE,'YYYY-MM-DD'),\n")
    				    .append("		'"+checklist_id+"',							 \n")
    				    .append("    	(SELECT MAX(checklist_rev_no)				 \n")
    				    .append("    	FROM checklist								 \n")
    				    .append("    	WHERE checklist_id = '"+checklist_id+"'),	 \n")
        				.append("		DECODE('"+jObj.get("occur_time").toString().trim()+"', '', NULL, TIME'"+jObj.get("occur_time").toString().trim()+"'),\n")
        				.append("		'"+jObj.get("occur_place")+"',\n")
        				.append("		'"+jObj.get("unsuit_detail")+"',\n")
        				.append("		'"+jObj.get("improve_action")+"' \n")
        				.append("	) \n")
        				.toString();

        		resultInt = super.excuteUpdate(con, sql); 
    			  
    		    if(resultInt < 0) {
    			    ioParam.setMessage(MessageDefine.M_INSERT_FAILED); 
    			    con.rollback(); return
    			    EventDefine.E_DOEXCUTE_ERROR;
        	    }
    		    
    		} else {  
    			regist_date = "'"+resultString.trim()+"'";
    		}
    		
    		JSONArray form = new JSONArray();
			form = (JSONArray) jObj.get("form");
			
			System.out.println("form :"+form);
			// question_id, type_id, type_id_s, result : 4
    		
			ArrayList<String> valuearr = new ArrayList<String>();
			
			for(int i=1; i<=form.size(); i++) {
				
				JSONObject result = (JSONObject) form.get(i-1);
				
				String value = result.get("value").toString();
				valuearr.add(value);
				
				if(i%4 == 0) {
					
					sql = new StringBuilder()
							.append("INSERT INTO\n")
							.append("	haccp_produce_facility_result (\n")
							.append("		regist_date,\n")
							.append("		check_date,\n")
							.append("		type_id,\n")
							.append("		type_id_s,\n")
							.append("		type_rev_no,\n")
							.append("		question_id,\n")
							.append("		question_result,\n")
							.append("		person_produce_id\n")
							.append("	)\n")
							.append("VALUES\n")
							.append("	(\n")
		    				.append("		"+regist_date+",\n")
							.append("		'"+check_date+"',\n")
    						.append("		'"+valuearr.get(1)+"',\n")
    						.append("		'"+valuearr.get(2)+"',\n")
    						.append("		(SELECT MAX(type_rev_no)				\n")
    						.append("		 FROM haccp_produce_facility_check_type	\n")
    						.append("		 WHERE type_id = '"+valuearr.get(1)+"'),\n")
    						.append("		'"+valuearr.get(0)+"',\n")
    						.append("		'"+valuearr.get(3)+"',\n")
    	    				.append("		'"+jObj.get("person_write_id")+"'\n")
							.append("	)\n")
							.toString();

		    	   resultInt = super.excuteUpdate(con, sql); 
					  
				   if(resultInt < 0) {
					   ioParam.setMessage(MessageDefine.M_INSERT_FAILED); 
					   con.rollback(); return
					   EventDefine.E_DOEXCUTE_ERROR;
				   }
				   
   					valuearr = new ArrayList<String>();
				}
			}	
  		  con.commit();
		} catch(Exception e) {
			e.getStackTrace();
			LoggingWriter.setLogError("M838S020900E101()","==== SQL ERROR ===="+ e.getMessage());
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
    		
    		String regist_date = jObj.get("regist_date").toString();
    		
    		String sql = new StringBuilder()
    				.append("UPDATE\n")
    				.append("	haccp_produce_facility\n")
    				.append("SET\n")
    				.append("	occur_time = '"+jObj.get("occur_time")+"',\n")
    				.append("	occur_place = '"+jObj.get("occur_place")+"',\n")
    				.append("	unsuit_detail = '"+jObj.get("unsuit_detail")+"',\n")
    				.append("	improve_action = '"+jObj.get("improve_action")+"',\n")
    				.append("	person_action_id = '',\n")
    				.append("	person_check_id = ''\n")
    				.append("WHERE\n")
    				.append("	regist_date = '"+regist_date+"'\n")
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
			LoggingWriter.setLogError("M838S020900E102()","==== SQL ERROR ===="+ e.getMessage());
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
    		
    		String regist_date = jObj.get("regist_date").toString();
    		
    		String sql = new StringBuilder()
    				.append("DELETE FROM									\n")
    				.append("	haccp_produce_facility_result 				\n")
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
    				.append("DELETE FROM									\n")
    				.append("	haccp_produce_facility		 				\n")
    				.append("WHERE											\n")
    				.append("		 regist_date = '"+regist_date+"'		\n")
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
			LoggingWriter.setLogError("M838S020900E103()","==== SQL ERROR ===="+ e.getMessage());
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
					.append("SELECT\n")
					.append("	checklist_id,\n")
					.append("	checklist_rev_no,\n")
					.append("	A.regist_date,\n")
					.append("	TO_CHAR(A.regist_date,'MM') || '월' as MM_gubun,\n")
					.append("	TO_CHAR(occur_time, 'HH24:MI') AS occur_time2,\n")
					.append("	occur_place,\n")
					.append("	unsuit_detail,\n")
					.append("	improve_action,\n")
					.append("	C.user_nm AS person_action_id,\n")
					.append("	D.user_nm AS person_check_id\n")
					.append("FROM\n")
					.append("	haccp_produce_facility A\n")
					.append("	LEFT JOIN tbm_users C									\n")
					.append("			ON A.person_action_id = C.user_id				\n")
					.append("			AND A.regist_date BETWEEN CAST(C.start_date AS DATE) AND CAST(C.duration_date AS DATE) \n")
					.append("	LEFT JOIN tbm_users D									\n")
					.append("			ON A.person_check_id = D.user_id				\n")
					.append("			AND A.regist_date BETWEEN CAST(D.start_date AS DATE) AND CAST(D.duration_date AS DATE) \n")
					.append("WHERE A.regist_date BETWEEN '"+ jArray.get("fromdate") + "' \n")  
					.append("                     AND '"+ jArray.get("todate") + "' 	\n")
					.append("ORDER BY A.regist_date DESC\n")
					.toString();

			resultString = super.excuteQueryString(con, sql);
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M838S020900E104()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) {
						con.close();
					}
				} catch (Exception e) {
					LoggingWriter.setLogError("M838S020900E104()","==== finally ===="+ e.getMessage());
				}
	    	}
	    }

		ioParam.setResultString(resultString);
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
    	ioParam.setMessage(MessageDefine.M_QUERY_OK);

    	return EventDefine.E_QUERY_RESULT;
	}
	

	// 상세 점검표 기록 등록
	public int E111(InoutParameter ioParam){ 
		resultInt = EventDefine.E_DOEXCUTE_INIT;

		try {
			con = JDBCConnectionPool.getConnection();
			con.setAutoCommit(false);
		
    		JSONObject jObj = new JSONObject();
    		jObj = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
    		
    		String regist_date = jObj.get("regist_date").toString();
    		String check_date = jObj.get("check_date").toString();
    		
    		JSONArray form = new JSONArray();
			form = (JSONArray) jObj.get("form");
			
			System.out.println("form :"+form);
			// question_id, type_id, type_id_s, result : 4
    		
			ArrayList<String> valuearr = new ArrayList<String>();
			
			for(int i=1; i<=form.size(); i++) {
				
				JSONObject result = (JSONObject) form.get(i-1);
				
				String value = result.get("value").toString();
				valuearr.add(value);
				
				if(i%4 == 0) {
					
					String sql = new StringBuilder()
							.append("INSERT INTO\n")
							.append("	haccp_produce_facility_result (\n")
							.append("		regist_date,\n")
							.append("		check_date,\n")
							.append("		type_id,\n")
							.append("		type_id_s,\n")
							.append("		type_rev_no,\n")
							.append("		question_id,\n")
							.append("		question_result,\n")
							.append("		person_produce_id\n")
							.append("	)\n")
							.append("VALUES\n")
							.append("	(\n")
		    				.append("		'"+regist_date+"',\n")
							.append("		'"+check_date+"',\n")
    						.append("		'"+valuearr.get(1)+"',\n")
    						.append("		'"+valuearr.get(2)+"',\n")
    						.append("		(SELECT MAX(type_rev_no)				\n")
    						.append("		 FROM haccp_produce_facility_check_type	\n")
    						.append("		 WHERE type_id = '"+valuearr.get(1)+"'),\n")
    						.append("		'"+valuearr.get(0)+"',\n")
    						.append("		'"+valuearr.get(3)+"',\n")
    	    				.append("		'"+jObj.get("person_write_id")+"'\n")
							.append("	)\n")
							.toString();

		    	   resultInt = super.excuteUpdate(con, sql); 
					  
				   if(resultInt < 0) {
					   ioParam.setMessage(MessageDefine.M_INSERT_FAILED); 
					   con.rollback(); return
					   EventDefine.E_DOEXCUTE_ERROR;
				   }
				   
   					valuearr = new ArrayList<String>();
				}
				
			}
    			
			con.commit();
		} catch(Exception e) {
			e.getStackTrace();
			LoggingWriter.setLogError("M838S020900E111()","==== SQL ERROR ===="+ e.getMessage());
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

	// 상세 점검표 기록 수정
	public int E112(InoutParameter ioParam){ 
		resultInt = EventDefine.E_DOEXCUTE_INIT;

		try {
			con = JDBCConnectionPool.getConnection();
			con.setAutoCommit(false);
			
			
			JSONObject jObj = new JSONObject();
    		jObj = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
    		
    		String regist_date = jObj.get("regist_date").toString();
    		String check_date = jObj.get("check_date").toString();
    		
    		String sql = new StringBuilder()
    				.append("DELETE FROM												\n")
    				.append("	haccp_produce_facility_result							\n")
    				.append("WHERE														\n")
    				.append("	check_date = '"+jObj.get("check_date").toString()+"'	\n")
    				.toString();
    				
    		resultInt = super.excuteUpdate(con, sql);
	    	if(resultInt < 0) {
				ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
				con.rollback();
				return EventDefine.E_DOEXCUTE_ERROR ;
			}
    		
	    	sql = new StringBuilder()
	    			.append("UPDATE haccp_produce_facility	 					\n")
	    			.append("SET 	person_check_id='', person_action_id='' 	\n")
	    			.append("WHERE  regist_date='"+regist_date+"'				\n")
	    			.toString();

		
    		resultInt = super.excuteUpdate(con, sql);
	    	if(resultInt < 0) {
				ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
				con.rollback();
				return EventDefine.E_DOEXCUTE_ERROR ;
			}
	    	
	    	JSONArray form = new JSONArray();
			form = (JSONArray) jObj.get("form");
			
			System.out.println("form :"+form);
			// question_id, type_id, type_id_s, result : 4
    		
			ArrayList<String> valuearr = new ArrayList<String>();
			
			for(int i=1; i<=form.size(); i++) {
				
				JSONObject result = (JSONObject) form.get(i-1);
				
				String value = result.get("value").toString();
				valuearr.add(value);
				
				if(i%4 == 0) {
					
					sql = new StringBuilder()
							.append("INSERT INTO\n")
							.append("	haccp_produce_facility_result (\n")
							.append("		regist_date,\n")
							.append("		check_date,\n")
							.append("		type_id,\n")
							.append("		type_id_s,\n")
							.append("		type_rev_no,\n")
							.append("		question_id,\n")
							.append("		question_result,\n")
							.append("		person_produce_id\n")
							.append("	)\n")
							.append("VALUES\n")
							.append("	(\n")
		    				.append("		'"+regist_date+"',\n")
							.append("		'"+check_date+"',\n")
    						.append("		'"+valuearr.get(1)+"',\n")
    						.append("		'"+valuearr.get(2)+"',\n")
    						.append("		(SELECT MAX(type_rev_no)				\n")
    						.append("		 FROM haccp_produce_facility_check_type	\n")
    						.append("		 WHERE type_id = '"+valuearr.get(1)+"'),\n")
    						.append("		'"+valuearr.get(0)+"',\n")
    						.append("		'"+valuearr.get(3)+"',\n")
    	    				.append("		'"+jObj.get("person_write_id")+"'\n")
							.append("	)\n")
							.toString();

		    	   resultInt = super.excuteUpdate(con, sql); 
					  
				   if(resultInt < 0) {
					   ioParam.setMessage(MessageDefine.M_INSERT_FAILED); 
					   con.rollback(); return
					   EventDefine.E_DOEXCUTE_ERROR;
				   }
				   
   					valuearr = new ArrayList<String>();

				}
				
			}
	    	
			con.commit();
		} catch(Exception e) {
			e.getStackTrace();
			LoggingWriter.setLogError("M838S020900E112()","==== SQL ERROR ===="+ e.getMessage());
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
	
	// 점검표 삭제
	public int E113(InoutParameter ioParam){ 
		resultInt = EventDefine.E_DOEXCUTE_INIT;

		try {
			con = JDBCConnectionPool.getConnection();
			con.setAutoCommit(false);
			
    		JSONObject jObj = new JSONObject();
    		jObj = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
    		
    		String check_date = jObj.get("check_date").toString();
    		
    		String sql = new StringBuilder()
    				.append("DELETE FROM							\n")
    				.append("	haccp_produce_facility_result		\n")
    				.append("WHERE									\n")
    				.append("		 check_date = '"+check_date+"'	\n")
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
			LoggingWriter.setLogError("M838S020900E113()","==== SQL ERROR ===="+ e.getMessage());
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
	
	// 상세 테이블 조회
	public int E114(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			
			String sql = new StringBuilder()
					.append("SELECT DISTINCT \n")
					.append("	checklist_id,\n")
					.append("	checklist_rev_no,\n")
					.append("	A.check_date,\n")
					.append("	D.regist_date,\n")
					.append("	B.user_nm AS person_produce_id,\n")
					.append("	C.user_nm AS person_haccp_id\n")
					.append("FROM\n")
					.append("	haccp_produce_facility_result A\n")
					.append("	JOIN haccp_produce_facility D\n")
					.append("	ON A.regist_date = D.regist_date\n")
					.append("	LEFT JOIN tbm_users B\n")
					.append("	ON A.person_produce_id = B.user_id\n")
					.append("	AND check_date BETWEEN B.start_date AND B.duration_date\n")
					.append("	LEFT JOIN tbm_users C\n")
					.append("	ON A.person_haccp_id = C.user_id\n")
					.append("	AND check_date BETWEEN C.start_date AND C.duration_date\n")
					.append("WHERE A.regist_date = '"+jArray.get("regist_date").toString()+"'\n")
					.append("ORDER BY check_date DESC \n")
					.toString();
			
			resultString = super.excuteQueryString(con, sql);
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M838S020900E114()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) {
						con.close();
					}
				} catch (Exception e) {
					LoggingWriter.setLogError("M838S020900E114()","==== finally ===="+ e.getMessage());
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
					.append("SELECT 	DISTINCT													\n")
					.append("	A.regist_date,														\n")
					.append("	A.check_date,														\n")
					.append("	MONTH(A.check_date) || '/' || DAY(A.check_date) AS dates,			\n")
					.append("	LIST(SELECT question_result											\n")
					.append("		 FROM haccp_produce_facility_result A2							\n")
					.append("		 WHERE A2.check_date = A.check_date								\n")
					.append("		 ORDER BY question_id ASC) AS result,							\n")
					.append("	E.user_nm AS person_produce_id,										\n")
					.append("	F.user_nm AS person_haccp_id,										\n")
					.append("	TO_CHAR(occur_time, 'HH24:MI') AS occur_time,						\n")
					.append("	occur_place,														\n")
					.append("	B.unsuit_detail,													\n")
					.append("	B.improve_action,													\n")
					.append("	C.user_nm AS person_action_id,										\n")
					.append("	D.user_nm AS person_check_id										\n")
					.append("FROM haccp_produce_facility_result  A									\n")
					.append("INNER JOIN haccp_produce_facility  B									\n")
					.append("	ON A.regist_date = B.regist_date									\n")
					.append("	LEFT JOIN tbm_users C												\n")
					.append("	ON B.person_action_id = C.user_id									\n")
					.append("	AND  A.check_date BETWEEN CAST(C.start_date AS DATE) AND CAST(C.duration_date AS DATE) 		\n")
					.append("	LEFT JOIN tbm_users D												\n")
					.append("		ON B.person_check_id = D.user_id								\n")
					.append("		AND  A.check_date BETWEEN CAST(D.start_date AS DATE) AND CAST(D.duration_date AS DATE)  \n")
					.append("	LEFT JOIN tbm_users E												\n")
					.append("		ON A.person_produce_id = E.user_id								\n")
					.append("		AND  A.check_date BETWEEN CAST(E.start_date AS DATE) AND CAST(E.duration_date AS DATE) 	\n")
					.append("	LEFT JOIN tbm_users F												\n")
					.append("		ON A.person_haccp_id = F.user_id								\n")
					.append("		AND  A.check_date BETWEEN CAST(F.start_date AS DATE) AND CAST(F.duration_date AS DATE) 	\n")
					.append("WHERE B.regist_date = '"+regist_date+"'								\n")
					.append("ORDER BY A.check_date ASC												\n")
					.toString();

			resultString = super.excuteQueryString(con, sql);
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M838S020900E144()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M838S020900E144()","==== finally ===="+ e.getMessage());
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
					.append("	type_id,\n")
					.append("	type_id_s,\n")
					.append("	type_rev_no,\n")
					.append("	question_id,\n")
					.append("	question_result\n")
					.append("FROM\n")
					.append("	haccp_produce_facility_result\n")
					.append("WHERE\n")
					.append("	check_date = '"+jArray.get("check_date")+"'\n")
					.append("	AND regist_date = '"+jArray.get("regist_date")+"'\n")
					.append("ORDER BY question_id ASC \n")
					.toString();

			resultString = super.excuteQueryString(con, sql);
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M838S020900E154()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) {
						con.close();
					}
				} catch (Exception e) {
					LoggingWriter.setLogError("M838S020900E154()","==== finally ===="+ e.getMessage());
				}
	    	}
	    }

		ioParam.setResultString(resultString);
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
    	ioParam.setMessage(MessageDefine.M_QUERY_OK);

    	return EventDefine.E_QUERY_RESULT;
	}

	// 점검표 개선조치자 서명
	public int E502(InoutParameter ioParam){ 
		
		resultInt = EventDefine.E_DOEXCUTE_INIT;

		try {
			con = JDBCConnectionPool.getConnection();
			con.setAutoCommit(false);
			
    		JSONObject jObj = new JSONObject();
    		jObj = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));

    		String sql = new StringBuilder()
    				.append("UPDATE haccp_produce_facility									\n")
    				.append("SET															\n")
    				.append("	person_action_id = '" + jObj.get("userId") + "'				\n")
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
			LoggingWriter.setLogError("M838S020900E502()","==== SQL ERROR ===="+ e.getMessage());
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
    				.append("UPDATE haccp_produce_facility									\n")
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
			LoggingWriter.setLogError("M838S020900E522()","==== SQL ERROR ===="+ e.getMessage());
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
	
	// 점검표 HACCP 팀장 서명
	public int E532(InoutParameter ioParam){ 
		
		resultInt = EventDefine.E_DOEXCUTE_INIT;

		try {
			con = JDBCConnectionPool.getConnection();
			con.setAutoCommit(false);
			
    		JSONObject jObj = new JSONObject();
    		jObj = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
    		
    		String sql = new StringBuilder()
    				.append("UPDATE haccp_produce_facility_result							\n")
    				.append("SET															\n")
    				.append("	person_haccp_id = '" + jObj.get("userId") + "'				\n")
    				.append("WHERE check_date = '"+ jObj.get("checklistDate") + "'			\n")
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
			LoggingWriter.setLogError("M838S020900E522()","==== SQL ERROR ===="+ e.getMessage());
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