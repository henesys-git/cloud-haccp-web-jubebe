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
 * 작업장 낙하세균 검사 기록
 * 
 * 작성자: 서승헌
 * 일시: 2021-04-12
 * 
 * */


/**
 * 개요 : 이벤트ID별 메소드 정의
 */
public class M838S020850 extends SqlAdapter{
	Connection con = null;
	PreparedStatement pstmt = null;
	String resultString = "";
	int resultInt = -1;
	StringBuffer sql = new StringBuffer();
	
	String[][] v_paramArray = new String[0][0]; 
	Class[] optClass = null;
	Object[] optObj = null;
	Object obj = null;
	
	public M838S020850(){
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
			
			Method method = M838S020850.class.getMethod(event,optClass);
			LoggingWriter.setLogDebug(M838S020850.class.getName(),"==== " + event + " EventMethod Create Success ====");

			obj = method.invoke(M838S020850.class.newInstance(),optObj);
			doExcute_result = CommonFunction.getInt(obj.toString());
			
	    } catch (Exception ex) {
	    	doExcute_result = EventDefine.E_DOEXCUTE_INIT;
			ioParam.setMessage(MessageDefine.M_NO_EVENTID);
			LoggingWriter.setLogError(M838S020850.class.getName(),"==== EventID Not define : EVENT ID [ " + ioParam.getEventID() + "]");
	    } finally {
	    	obj = null;
			optClass = null;
			optObj = null;
	    }
	    long endTime = System.currentTimeMillis();
		long runningTime = endTime - startTime;
		LoggingWriter.setLogAll(M838S020850.class.getName(),"==== Query [수행시간  : " + runningTime + " ms]");
		
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
    		String judge_date = jObj.get("judge_date").toString();
  		    		
    		String sql = new StringBuilder()
    				.append("INSERT INTO\n")
    				.append("	haccp_germ (\n")
    				.append("		check_date,\n")
    				.append("		checklist_id,\n")
    				.append("		checklist_rev_no,\n")
    				.append("		judge_date\n")
    				.append("	)\n")
    				.append("VALUES\n")
    				.append("	(\n")
    				.append("		'"+check_date+"',\n")
    				.append("		'"+checklist_id+"',\n")
					.append("    	(SELECT MAX(checklist_rev_no)				 \n")
					.append("    	FROM checklist								 \n")
					.append("    	WHERE checklist_id = '"+checklist_id+"'),	 \n")
					.append("		'"+judge_date+"'\n")
    				.append("	)\n")
    				.toString();
    		
    	   resultInt = super.excuteUpdate(con, sql); 
			  
		   if(resultInt < 0) {
			   ioParam.setMessage(MessageDefine.M_INSERT_FAILED); 
			   con.rollback(); return
			   EventDefine.E_DOEXCUTE_ERROR;
		   }

			JSONArray form = new JSONArray();
			form = (JSONArray) jObj.get("form");
			
			System.out.println(form);
			// 순서 : type_id, LOCATION, result, evaluation, bigo_detail :: 5
			
			ArrayList<String> valuearr = new ArrayList<String>();
			
			for(int i=1; i<=form.size(); i++) {
				
				JSONObject result = (JSONObject) form.get(i-1);
				
				String value = result.get("value").toString();
				valuearr.add(value);
				
				if(i%5 == 0) {
					
					sql = new StringBuilder()
							.append("INSERT INTO\n")
							.append("	haccp_germ_result (\n")
							.append("		check_date,\n")
							.append("		type_id,\n")
							.append("		LOCATION,\n")
							.append("		result,\n")
							.append("		evaluation,\n")
							.append("		bigo_detail\n")
							.append("	)\n")
							.append("VALUES\n")
							.append("	(\n")
							.append("		'"+check_date+"',\n")
    						.append("		'"+valuearr.get(0)+"',\n")
    						.append("		'"+valuearr.get(1)+"',\n")
    						.append("		'"+valuearr.get(2)+"',\n")
    						.append("		'"+valuearr.get(3)+"',\n")
    						.append("		'"+valuearr.get(4)+"'\n")
							.append("	)	\n")
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
			LoggingWriter.setLogError("M838S020850E101()","==== SQL ERROR ===="+ e.getMessage());
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
	// UPDATE & DELETE 후 등록 쿼리 그대로 재사용
	public int E102(InoutParameter ioParam){ 
		resultInt = EventDefine.E_DOEXCUTE_INIT;

		try {
			con = JDBCConnectionPool.getConnection();
			con.setAutoCommit(false);
			
    		JSONObject jObj = new JSONObject();
    		jObj = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
    		
    		String check_date = jObj.get("check_date").toString();
    		
    		String sql = new StringBuilder()
    				.append("UPDATE\n")
    				.append("	haccp_germ\n")
    				.append("SET\n")
    				.append("	judge_date = '"+jObj.get("judge_date")+"',\n")
    				.append("	person_inspect_id = '',\n")
    				.append("	person_check_id = '',	\n")
    				.append("	person_approve_id = ''	\n")
    				.append("WHERE\n")
    				.append("	check_date = '"+check_date+"' \n")
    				.toString();

    		resultInt = super.excuteUpdate(con, sql);
	    	if(resultInt < 0) {
				ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
				con.rollback();
				return EventDefine.E_DOEXCUTE_ERROR ;
			}
	
	    	sql = new StringBuilder()
    				.append("DELETE FROM									\n")
    				.append("	haccp_germ_result 							\n")
    				.append("WHERE											\n")
    				.append("		 check_date = '"+check_date+"'			\n")
    				.toString();

    		resultInt = super.excuteUpdate(con, sql);
	    	if(resultInt < 0) {
				ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
				con.rollback();
				return EventDefine.E_DOEXCUTE_ERROR ;
			}
	    	
			JSONArray form = new JSONArray();
			form = (JSONArray) jObj.get("form");
			
			System.out.println(form);
			// 순서 : type_id, LOCATION, result, evaluation, bigo_detail :: 5
			
			ArrayList<String> valuearr = new ArrayList<String>();
			
			for(int i=1; i<=form.size(); i++) {
				
				JSONObject result = (JSONObject) form.get(i-1);
				
				String value = result.get("value").toString();
				valuearr.add(value);
				
				if(i%5 == 0) {
					
					sql = new StringBuilder()
							.append("INSERT INTO\n")
							.append("	haccp_germ_result (\n")
							.append("		check_date,\n")
							.append("		type_id,\n")
							.append("		LOCATION,\n")
							.append("		result,\n")
							.append("		evaluation,\n")
							.append("		bigo_detail\n")
							.append("	)\n")
							.append("VALUES\n")
							.append("	(\n")
							.append("		'"+check_date+"',\n")
    						.append("		'"+valuearr.get(0)+"',\n")
    						.append("		'"+valuearr.get(1)+"',\n")
    						.append("		'"+valuearr.get(2)+"',\n")
    						.append("		'"+valuearr.get(3)+"',\n")
    						.append("		'"+valuearr.get(4)+"'\n")
							.append("	)	\n")
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
			LoggingWriter.setLogError("M838S020850E102()","==== SQL ERROR ===="+ e.getMessage());
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
    		
    		String check_date = jObj.get("check_date").toString();
    		
    		String sql = new StringBuilder()
    				.append("DELETE FROM									\n")
    				.append("	haccp_germ_result 							\n")
    				.append("WHERE											\n")
    				.append("		 check_date = '"+check_date+"'			\n")
    				.toString();
    		
    		resultInt = super.excuteUpdate(con, sql);
	    	if(resultInt < 0) {
				ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
				con.rollback();
				return EventDefine.E_DOEXCUTE_ERROR ;
			}
	    	
	    	sql = new StringBuilder()
    			.append("DELETE FROM									\n")
    			.append("	haccp_germ		 							\n")
    			.append("WHERE											\n")
    			.append("		 check_date = '"+check_date+"'			\n")
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
			LoggingWriter.setLogError("M838S020850E103()","==== SQL ERROR ===="+ e.getMessage());
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
					.append("	check_date,\n")
					.append("	judge_date,\n")
					.append("	C.user_nm as person_check_id,\n")
					.append("	D.user_nm as person_inspect_id,\n")
					.append("	E.user_nm as person_approve_id,\n")
					.append("	regist_no,						\n")
					.append("	file_name,						\n")
					.append("	file_path,						\n")
					.append("	file_rev_no,					\n")
					.append("	file_path						\n")
					.append("FROM\n")
					.append("	haccp_germ A											\n")
					.append("	LEFT JOIN tbm_users C									\n")
					.append("			ON A.person_check_id = C.user_id				\n")
					.append("			AND  A.check_date BETWEEN CAST(C.start_date AS DATE) AND CAST(C.duration_date AS DATE) \n")
					.append("	LEFT JOIN tbm_users D									\n")
					.append("			ON A.person_inspect_id = D.user_id				\n")
					.append("			AND  A.judge_date BETWEEN CAST(D.start_date AS DATE) AND CAST(D.duration_date AS DATE) \n")
					.append("	LEFT JOIN tbm_users E									\n")
					.append("			ON A.person_approve_id = E.user_id				\n")
					.append("			AND  A.judge_date BETWEEN CAST(E.start_date AS DATE) AND CAST(E.duration_date AS DATE)\n")
					.append("WHERE check_date BETWEEN '"+ jArray.get("fromdate") + "' 	\n")  
					.append("                     AND '"+ jArray.get("todate") + "' 	\n")
					.append("ORDER BY check_date DESC \n")
					.toString();

			resultString = super.excuteQueryString(con, sql);
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M838S020850E104()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) {
						con.close();
					}
				} catch (Exception e) {
					LoggingWriter.setLogError("M838S020850E104()","==== finally ===="+ e.getMessage());
				}
	    	}
	    }

		ioParam.setResultString(resultString);
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
    	ioParam.setMessage(MessageDefine.M_QUERY_OK);

    	return EventDefine.E_QUERY_RESULT;
	}
		
	// 파일 등록
	public int E111(InoutParameter ioParam){ 
		resultInt = EventDefine.E_DOEXCUTE_INIT;

		try {
			con = JDBCConnectionPool.getConnection();

			// 클라이언트로 부터 받은 파라미터를 옮겨 담는다.
			String rcvData = (String)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));

			con.setAutoCommit(false);
    		
    		// 클라이언트로 부터 받은 파라미터를 쪼개어서 배열에 담는다. returnStringBuffer
			String[][] c_paramArray = CommonFunction.getConvString2DoubleArray(rcvData);
			
			System.out.println(rcvData);
			System.out.println(c_paramArray);
			System.out.println(c_paramArray.toString());
			
    		String sql = new StringBuilder()
    				.append("SELECT\n")
    				.append("	check_date\n")
    				.append("FROM\n")
    				.append("	haccp_germ\n")
    				.append("ORDER BY check_date DESC FOR ORDERBY_NUM() = 1\n")
    				.toString();

			resultString = super.excuteQueryString(con, sql.toString());
    		
			sql = new StringBuilder()
					.append("UPDATE haccp_germ		  			  		  \n")
					.append("   SET file_name = '"+c_paramArray[0][10]+"',\n")	//file_view_name
					.append("   	file_path = '"+c_paramArray[0][11]+"',\n")	//file_path
					.append("   	regist_no = '"+c_paramArray[0][19]+"' \n")	//regist_no
					.append(" WHERE check_date = '"+resultString.trim()+"'\n")
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
			LoggingWriter.setLogError("M838S020850E111()","==== SQL ERROR ===="+ e.getMessage());
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
	
	// 파일 수정
	public int E112(InoutParameter ioParam){ 
		resultInt = EventDefine.E_DOEXCUTE_INIT;

		try {
			con = JDBCConnectionPool.getConnection();

			// 클라이언트로 부터 받은 파라미터를 옮겨 담는다.
			String rcvData = (String)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));

			con.setAutoCommit(false);
    		
    		// 클라이언트로 부터 받은 파라미터를 쪼개어서 배열에 담는다. returnStringBuffer
			String[][] c_paramArray = CommonFunction.getConvString2DoubleArray(rcvData);
    		
			String sql = new StringBuilder()
					.append("UPDATE haccp_germ					\n")
					.append("   SET file_name = '"+c_paramArray[0][10]+"',\n")	//file_view_name
					.append("   	file_path = '"+c_paramArray[0][11].replaceAll("//", "/")+"',\n")	//file_path
					.append("   	file_rev_no = '"+c_paramArray[0][8]+"',\n")	//file_rev_no
					.append("   	regist_no = '"+c_paramArray[0][18]+"'\n")	//regist_no
					.append(" WHERE check_date = '"+c_paramArray[0][24]+"'\n")
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
			LoggingWriter.setLogError("M838S020850E112()","==== SQL ERROR ===="+ e.getMessage());
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
	
	// 파일 삭제(실제 파일 삭제 x DB 만 변경)
	public int E113(InoutParameter ioParam){ 
		resultInt = EventDefine.E_DOEXCUTE_INIT;

		try {
			
			con = JDBCConnectionPool.getConnection();
			
    		JSONObject jArray = new JSONObject();
    		jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
    		System.out.println("JSONObject jArray rcvData="+ jArray.toString());
    		
			String sql = new StringBuilder()
					.append("UPDATE haccp_germ				\n")
					.append("   SET file_name = '',\n")	//file_view_name
					.append("   	file_path = ''\n")	//file_path
					.append(" WHERE check_date = '"+jArray.get("seq_no").toString()+"'\n")
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
			LoggingWriter.setLogError("M838S020850E113()","==== SQL ERROR ===="+ e.getMessage());
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
					.append("	A.check_date,\n")
					.append("	TO_CHAR(A.check_date,'YY') AS check_YY,\n")
					.append("	TO_CHAR(A.check_date,'MM') AS check_MM,\n")
					.append("	TO_CHAR(A.check_date,'DD') AS check_DD,\n")
					.append("	TO_CHAR(judge_date,'YY') AS judge_YY,\n")
					.append("	TO_CHAR(judge_date,'MM') AS judge_MM,\n")
					.append("	TO_CHAR(judge_date,'DD') AS judge_DD,\n")
					.append("	judge_date,\n")
					.append("	type_id,\n")
					.append("	seq_no,\n")
					.append("	B.LOCATION,\n")
					.append("	result,\n")
					.append("	evaluation,\n")
					.append("	bigo_detail,\n")
					.append("	C.user_nm as person_check_id,\n")
					.append("	D.user_nm as person_inspect_id,\n")
					.append("	E.user_nm as person_approve_id\n")
					.append("FROM\n")
					.append("	haccp_germ A \n")
					.append("	JOIN haccp_germ_result B\n")
					.append("	ON 	A.check_date = B.check_date							\n")
					.append("	LEFT JOIN tbm_users C									\n")
					.append("			ON A.person_check_id = C.user_id				\n")
					.append("			AND  A.check_date BETWEEN CAST(C.start_date AS DATE) AND CAST(C.duration_date AS DATE) \n")
					.append("	LEFT JOIN tbm_users D									\n")
					.append("			ON A.person_inspect_id = D.user_id				\n")
					.append("			AND  A.judge_date BETWEEN CAST(D.start_date AS DATE) AND CAST(D.duration_date AS DATE) \n")
					.append("	LEFT JOIN tbm_users E									\n")
					.append("			ON A.person_approve_id = E.user_id				\n")
					.append("			AND  A.judge_date BETWEEN CAST(E.start_date AS DATE) AND CAST(E.duration_date AS DATE)\n")
					.append("WHERE A.check_date = '"+check_date+"' \n")
					.append("ORDER BY seq_no ASC\n")
					.toString();

			resultString = super.excuteQueryString(con, sql);
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M838S020850E144()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M838S020850E144()","==== finally ===="+ e.getMessage());
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
					.append("	A.check_date,\n")
					.append("	judge_date,\n")
					.append("	A.type_id,\n")
					.append(" 	type_nm,\n")
					.append("	seq_no,\n")
					.append("	LOCATION,\n")
					.append("	result,\n")
					.append("	evaluation,\n")
					.append("	bigo_detail,\n")
					.append("	regist_no,\n")
					.append("	file_name,\n")
					.append("	file_path,\n")
					.append("	file_rev_no\n")
					.append("FROM\n")
					.append("	haccp_germ_result A JOIN haccp_germ B \n")
					.append("	ON A.check_date = B.check_date\n")
					.append("	JOIN haccp_germ_check_type C\n")
					.append("	ON A.type_id = C.type_id\n")
					.append("WHERE A.check_date = '"+jArray.get("check_date")+"'\n")
					.append("ORDER BY seq_no ASC \n")
					.toString();

			resultString = super.excuteQueryString(con, sql);
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M838S020850E154()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) {
						con.close();
					}
				} catch (Exception e) {
					LoggingWriter.setLogError("M838S020850E154()","==== finally ===="+ e.getMessage());
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
    				.append("UPDATE haccp_germ										\n")
    				.append("SET													\n")
    				.append("	person_approve_id = '" + jObj.get("userId") + "'	\n")
    				.append("WHERE check_date = '"+ jObj.get("checklistDate") + "'	\n")
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
			LoggingWriter.setLogError("M838S020850E502()","==== SQL ERROR ===="+ e.getMessage());
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
    				.append("UPDATE haccp_germ												\n")
    				.append("SET															\n")
    				.append("	person_check_id = '" + jObj.get("userId") + "'				\n")
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
			LoggingWriter.setLogError("M838S020850E522()","==== SQL ERROR ===="+ e.getMessage());
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
	
	// 점검표 검사자 서명
	public int E532(InoutParameter ioParam){ 
		
		resultInt = EventDefine.E_DOEXCUTE_INIT;

		try {
			con = JDBCConnectionPool.getConnection();
			con.setAutoCommit(false);
			
    		JSONObject jObj = new JSONObject();
    		jObj = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
    		
    		String sql = new StringBuilder()
    				.append("UPDATE haccp_germ												\n")
    				.append("SET															\n")
    				.append("	person_inspect_id = '" + jObj.get("userId") + "'			\n")
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
			LoggingWriter.setLogError("M838S020850E532()","==== SQL ERROR ===="+ e.getMessage());
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