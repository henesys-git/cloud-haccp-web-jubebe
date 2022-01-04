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
 * 소독약품 관리대장
 * 
 * 작성자: 서승헌
 * 일시: 2021-04-08
 * 
 * */


/**
 * 개요 : 이벤트ID별 메소드 정의
 */
public class M838S020800 extends SqlAdapter{
	Connection con = null;
	PreparedStatement pstmt = null;
	String resultString = "";
	int resultInt = -1;
	StringBuffer sql = new StringBuffer();
	
	String[][] v_paramArray = new String[0][0]; 
	Class[] optClass = null;
	Object[] optObj = null;
	Object obj = null;
	
	public M838S020800(){
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
			
			Method method = M838S020800.class.getMethod(event,optClass);
			LoggingWriter.setLogDebug(M838S020800.class.getName(),"==== " + event + " EventMethod Create Success ====");

			obj = method.invoke(M838S020800.class.newInstance(),optObj);
			doExcute_result = CommonFunction.getInt(obj.toString());
			
	    } catch (Exception ex) {
	    	doExcute_result = EventDefine.E_DOEXCUTE_INIT;
			ioParam.setMessage(MessageDefine.M_NO_EVENTID);
			LoggingWriter.setLogError(M838S020800.class.getName(),"==== EventID Not define : EVENT ID [ " + ioParam.getEventID() + "]");
	    } finally {
	    	obj = null;
			optClass = null;
			optObj = null;
	    }
	    long endTime = System.currentTimeMillis();
		long runningTime = endTime - startTime;
		LoggingWriter.setLogAll(M838S020800.class.getName(),"==== Query [수행시간  : " + runningTime + " ms]");
		
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
    		String check_date = jObj.get("check_date").toString();
    		String regist_seq_no = "";


    		String sql = new StringBuilder()
	    			.append("SELECT\n")
	    			.append("	regist_seq_no\n")
	    			.append("FROM\n")
	    			.append("	haccp_disinfectant\n")
	    			.append("WHERE\n")
	    			.append("	ROWNUM= 1\n")
	    			.append("ORDER BY regist_seq_no desc\n")
	    			.toString();

	    	resultString = super.excuteQueryString(con, sql);
    		
	    	int length = resultString.length();
	    	
	    	int cnt = 0;
	    	
	    	if(length != 0) {
	    		
	    		regist_seq_no = resultString.trim();
	    		
	    		sql = new StringBuilder()
	    				.append("SELECT COUNT(*)\n")
	    				.append("FROM\n")
	    				.append("	haccp_disinfectant_detail\n")
	    				.append("WHERE\n")
	    				.append("	regist_seq_no = '"+regist_seq_no+"'\n")
	    				.toString();

	    		resultString = super.excuteQueryString(con, sql);
	    		
	    		cnt = Integer.parseInt(resultString.trim());
	    		
	    	} 
	    	
	    	
	    	if(length == 0 || cnt == 40){
	    		
	    		sql = new StringBuilder()
	    				.append("INSERT INTO\n")
	    				.append("	haccp_disinfectant (\n")
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
	    				.append("		'"+regist_date+"',\n")
	    				.append("		'"+ jObj.get("person_write_id") + "' \n")
	    				.append("	)\n")
	    				.toString();

	    		resultInt = super.excuteUpdate(con, sql);
		    	if(resultInt < 0) {
					ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
					con.rollback();
					return EventDefine.E_DOEXCUTE_ERROR;
				}
		    	
		    	sql = new StringBuilder()
		    			.append("SELECT\n")
		    			.append("	regist_seq_no\n")
		    			.append("FROM\n")
		    			.append("	haccp_disinfectant\n")
		    			.append("WHERE\n")
		    			.append("	ROWNUM= 1\n")
		    			.append("ORDER BY regist_seq_no desc\n")
		    			.toString();

		    	resultString = super.excuteQueryString(con, sql);
		    	
		    	regist_seq_no = resultString.trim();
	    		
	    	}
	    	
	    	
    		JSONArray form = new JSONArray();
    		form = (JSONArray) jObj.get("form");
    		
    		System.out.println(form);
    		
    		ArrayList<String> namearr = new ArrayList<String>();
    		ArrayList<String> valuearr = new ArrayList<String>();
    		
    		for(int i = 1; i <= 24; i++) {
    			
    			JSONObject result = (JSONObject) form.get(i-1);
				String name = result.get("name").toString(); 
				namearr.add(name);
				String value = result.get("value").toString();
				valuearr.add(value);
    			
    			if(i%6 == 0) {
    				
    				sql = new StringBuilder()
    						.append("INSERT INTO\n")
    						.append("	haccp_disinfectant_detail (\n")
    						.append("		check_date,\n")
    						.append("		disinfectant_id,\n")
    						.append("		regist_seq_no,\n")
    						.append("		purchase_amount,\n")
    						.append("		use_amount,\n")
    						.append("		stock_amount,\n")
    						.append("		check_detail,\n")
    						.append("		result\n")
    						.append("	)\n")
    						.append("VALUES\n")
    						.append("	(\n")
    						.append("		'"+check_date+"',\n")
    						.append("		'"+valuearr.get(0)+"',\n")
    						.append("		'"+regist_seq_no+"',\n")
    						.append("		'"+valuearr.get(1)+"',\n")
    						.append("		'"+valuearr.get(2)+"',\n")
    						.append("		'"+valuearr.get(3)+"',\n")
    						.append("		'"+valuearr.get(4)+"',\n")
    						.append("		'"+valuearr.get(5)+"'\n")
    						.append("	)\n")
    						.toString();

    				resultInt = super.excuteUpdate(con, sql);
    		    	if(resultInt < 0) {
    					ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
    					con.rollback();
    					return EventDefine.E_DOEXCUTE_ERROR;
    				}
    				
    				namearr = new ArrayList<String>();
    				valuearr = new ArrayList<String>();
    			}
    				
    		}
    		
    		System.out.println("namearrnamearrnamearrnamearrnamearr : "+namearr);
    		System.out.println("valuearrvaluearrvaluearrvaluearrvaluearr : "+valuearr);
			
			con.commit();
			 
		} catch(Exception e) {
			e.getStackTrace();
			LoggingWriter.setLogError("M838S020800E101()","==== SQL ERROR ===="+ e.getMessage());
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
    		
    		String seq_no = jObj.get("seq_no").toString();
    		String regist_seq_no = jObj.get("regist_seq_no").toString();
    		
    		String sql = new StringBuilder()
    				.append("UPDATE\n")
    				.append("	haccp_waste_detail\n")
    				.append("SET\n")
    				.append("	regist_date = TO_CHAR(SYSDATE, 'YYYY-MM-DD'),\n")
    				.append("	occur_date = '"+jObj.get("occur_date")+"',\n")
    				.append("	waste_nm = '"+jObj.get("waste_nm")+"',\n")
    				.append("	weight = '"+jObj.get("weight")+"',\n")
    				.append("	content = '"+jObj.get("content")+"',\n")
    				.append("	check_yn = '"+jObj.get("check_yn")+"',\n")
    				.append("	person_write_id = '"+jObj.get("person_write_id")+"',\n")
    				.append("	person_check_id = '',	\n")
    				.append("	person_approve_id = ''	\n")
    				.append("WHERE\n")
    				.append("	seq_no = '"+seq_no+"' and regist_seq_no = '"+regist_seq_no+"'\n")
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
			LoggingWriter.setLogError("M838S020800E102()","==== SQL ERROR ===="+ e.getMessage());
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
    				.append("	haccp_disinfectant_detail 							\n")
    				.append("WHERE											\n")
    				.append("		 regist_seq_no = '"+regist_seq_no+"'		\n")
    				.toString();
    						
    		resultInt = super.excuteUpdate(con, sql);
	    	if(resultInt < 0) {
				ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
				con.rollback();
				return EventDefine.E_DOEXCUTE_ERROR ;
			}
    		
    		sql = new StringBuilder()
    				.append("DELETE FROM									\n")
    				.append("	haccp_disinfectant 							\n")
    				.append("WHERE											\n")
    				.append("		 regist_seq_no = '"+regist_seq_no+"'		\n")
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
			LoggingWriter.setLogError("M838S020800E103()","==== SQL ERROR ===="+ e.getMessage());
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
					.append("	regist_date,\n")
					.append("	regist_seq_no,\n")
					.append("	B.user_nm AS person_write_id,\n")
					.append("	C.user_nm AS person_check_id,\n")
					.append("	D.user_nm AS person_approve_id\n")
					.append("FROM\n")
					.append("	haccp_disinfectant A \n")
					.append("	LEFT JOIN tbm_users B\n")
					.append("	ON person_write_id = B.user_id\n")
					.append("	AND regist_date BETWEEN TO_DATE(B.start_date) AND  TO_DATE(B.duration_date) \n")
					.append("	LEFT JOIN tbm_users C\n")
					.append("	ON person_check_id = C.user_id\n")
					.append("	AND regist_date BETWEEN TO_DATE(C.start_date) AND  TO_DATE(C.duration_date) \n")
					.append("	LEFT JOIN tbm_users D\n")
					.append("	ON person_approve_id = D.user_id\n")
					.append("	AND regist_date BETWEEN TO_DATE(D.start_date) AND  TO_DATE(D.duration_date) \n")
					.append("WHERE regist_date BETWEEN '"+ jArray.get("fromdate") + "' 	\n")  
					.append("                     AND '"+ jArray.get("todate") + "' 	\n")
					.append("ORDER BY regist_date DESC \n")
					.toString();

					

			resultString = super.excuteQueryString(con, sql);
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M838S020800E104()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) {
						con.close();
					}
				} catch (Exception e) {
					LoggingWriter.setLogError("M838S020800E104()","==== finally ===="+ e.getMessage());
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
    		
    		String regist_seq_no = jObj.get("regist_seq_no").toString();
    		String check_date = jObj.get("check_date").toString();
    		
    		int cnt = 0;
	    	
	    	String sql = new StringBuilder()
	    				.append("SELECT COUNT(*)\n")
	    				.append("FROM\n")
	    				.append("	haccp_disinfectant_detail\n")
	    				.append("WHERE\n")
	    				.append("	regist_seq_no = '"+regist_seq_no+"'\n")
	    				.toString();

    		resultString = super.excuteQueryString(con, sql);
    		
    		cnt = Integer.parseInt(resultString.trim());
	    	
    		if(cnt == 40) {
    			
    			sql = new StringBuilder()
	    				.append("INSERT INTO\n")
	    				.append("	haccp_disinfectant (\n")
	    				.append("		checklist_id,\n")
	    				.append("		checklist_rev_no,\n")
	    				.append("		regist_date,\n")
	    				.append("		person_write_id\n")
	    				.append("	)\n")
	    				.append("VALUES\n")
	    				.append("	(\n")
	    				.append("		'"+jObj.get("checklist_id").toString()+"',\n")
  					    .append("    	(SELECT MAX(checklist_rev_no)				 \n")
  					    .append("    	FROM checklist								 \n")
  					    .append("    	WHERE checklist_id = '"+jObj.get("checklist_id").toString()+"'),	 \n")
	    				.append("		TO_CHAR(SYSDATE, 'YYYY-MM-DD'),\n")
	    				.append("		'admin'\n")
	    				.append("	)\n")
	    				.toString();

	    		resultInt = super.excuteUpdate(con, sql);
		    	if(resultInt < 0) {
					ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
					con.rollback();
					return EventDefine.E_DOEXCUTE_ERROR;
				}
		    	
		    	sql = new StringBuilder()
		    			.append("SELECT\n")
		    			.append("	regist_seq_no\n")
		    			.append("FROM\n")
		    			.append("	haccp_disinfectant\n")
		    			.append("WHERE\n")
		    			.append("	ROWNUM= 1\n")
		    			.append("ORDER BY regist_seq_no desc\n")
		    			.toString();

		    	resultString = super.excuteQueryString(con, sql);
		    	
		    	regist_seq_no = resultString.trim();
    			
    			
    		}
    		
    		
    		JSONArray form = new JSONArray();
    		form = (JSONArray) jObj.get("form");
    		
    		System.out.println(form);
    		
    		ArrayList<String> namearr = new ArrayList<String>();
    		ArrayList<String> valuearr = new ArrayList<String>();
    		
    		for(int i = 1; i <= 24; i++) {
    			
    			JSONObject result = (JSONObject) form.get(i-1);
				String name = result.get("name").toString(); 
				namearr.add(name);
				String value = result.get("value").toString();
				valuearr.add(value);
    			
    			if(i%6 == 0) {
    				
	    			sql = new StringBuilder()
							.append("INSERT INTO\n")
							.append("	haccp_disinfectant_detail (\n")
							.append("		check_date,\n")
							.append("		disinfectant_id,\n")
							.append("		regist_seq_no,\n")
							.append("		purchase_amount,\n")
							.append("		use_amount,\n")
							.append("		stock_amount,\n")
							.append("		check_detail,\n")
							.append("		result\n")
							.append("	)\n")
							.append("VALUES\n")
							.append("	(\n")
							.append("		'"+check_date+"',\n")
							.append("		'"+valuearr.get(0)+"',\n")
							.append("		'"+regist_seq_no+"',\n")
							.append("		'"+valuearr.get(1)+"',\n")
							.append("		'"+valuearr.get(2)+"',\n")
							.append("		'"+valuearr.get(3)+"',\n")
							.append("		'"+valuearr.get(4)+"',\n")
							.append("		'"+valuearr.get(5)+"'\n")
							.append("	)\n")
							.toString();
	
					resultInt = super.excuteUpdate(con, sql);
			    	if(resultInt < 0) {
						ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
						con.rollback();
						return EventDefine.E_DOEXCUTE_ERROR;
					}
					
					namearr = new ArrayList<String>();
					valuearr = new ArrayList<String>();
    			}
    				
    		}
    		
    		System.out.println("namearrnamearrnamearrnamearrnamearr : "+namearr);
    		System.out.println("valuearrvaluearrvaluearrvaluearrvaluearr : "+valuearr);
    			
			con.commit();
		} catch(Exception e) {
			e.getStackTrace();
			LoggingWriter.setLogError("M838S020800E111()","==== SQL ERROR ===="+ e.getMessage());
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
	// 삭제 후 다시 등록
	public int E112(InoutParameter ioParam){ 
		resultInt = EventDefine.E_DOEXCUTE_INIT;

		try {
			con = JDBCConnectionPool.getConnection();
			con.setAutoCommit(false);
			
			
			JSONObject jObj = new JSONObject();
    		jObj = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
    		
    		String regist_seq_no = jObj.get("regist_seq_no").toString();
    		String check_date = jObj.get("check_date").toString();
    		
    		String sql = new StringBuilder()
    				.append("DELETE FROM												\n")
    				.append("	haccp_disinfectant_detail								\n")
    				.append("WHERE														\n")
    				.append("	regist_seq_no = '"+jObj.get("regist_seq_no").toString()+"'		\n")
    				.append("	AND check_date = '"+jObj.get("check_date").toString()+"'		\n")
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
    		
    		ArrayList<String> namearr = new ArrayList<String>();
    		ArrayList<String> valuearr = new ArrayList<String>();
    		
    		for(int i = 1; i <= 24; i++) {
    			
    			JSONObject result = (JSONObject) form.get(i-1);
				String name = result.get("name").toString(); 
				namearr.add(name);
				String value = result.get("value").toString();
				valuearr.add(value);
    			
    			if(i%6 == 0) {
    				
	    			sql = new StringBuilder()
							.append("INSERT INTO\n")
							.append("	haccp_disinfectant_detail (\n")
							.append("		check_date,\n")
							.append("		disinfectant_id,\n")
							.append("		regist_seq_no,\n")
							.append("		purchase_amount,\n")
							.append("		use_amount,\n")
							.append("		stock_amount,\n")
							.append("		check_detail,\n")
							.append("		result\n")
							.append("	)\n")
							.append("VALUES\n")
							.append("	(\n")
							.append("		'"+check_date+"',\n")
							.append("		'"+valuearr.get(0)+"',\n")
							.append("		'"+regist_seq_no+"',\n")
							.append("		'"+valuearr.get(1)+"',\n")
							.append("		'"+valuearr.get(2)+"',\n")
							.append("		'"+valuearr.get(3)+"',\n")
							.append("		'"+valuearr.get(4)+"',\n")
							.append("		'"+valuearr.get(5)+"'\n")
							.append("	)\n")
							.toString();
	
					resultInt = super.excuteUpdate(con, sql);
			    	if(resultInt < 0) {
						ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
						con.rollback();
						return EventDefine.E_DOEXCUTE_ERROR;
					}
					
					namearr = new ArrayList<String>();
					valuearr = new ArrayList<String>();
    			}
    				
    		}
    		
    		System.out.println("namearrnamearrnamearrnamearrnamearr : "+namearr);
    		System.out.println("valuearrvaluearrvaluearrvaluearrvaluearr : "+valuearr);
	    	
	    	sql = new StringBuilder()
	    			.append("UPDATE haccp_disinfectant 							\n")
	    			.append("SET 	person_check_id='', person_approve_id='' 	\n")
	    			.append("WHERE  regist_seq_no='"+regist_seq_no+"'			\n")
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
			LoggingWriter.setLogError("M838S020800E112()","==== SQL ERROR ===="+ e.getMessage());
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
    		
    		String regist_seq_no = jObj.get("regist_seq_no").toString();
    		String check_date = jObj.get("check_date").toString();
    		
    		String sql = new StringBuilder()
    				.append("DELETE FROM							\n")
    				.append("	haccp_disinfectant_detail			\n")
    				.append("WHERE									\n")
    				.append("		 regist_seq_no = '"+regist_seq_no+"'	\n")
    				.append("	AND	 check_date = '"+check_date+"'	\n")
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
			LoggingWriter.setLogError("M838S020800E113()","==== SQL ERROR ===="+ e.getMessage());
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
	
	// 싱세 테이블 조회
	public int E114(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			
			String sql = new StringBuilder()
					.append("SELECT\n")
					.append("	regist_seq_no,\n")
					.append("	check_date,\n")
					.append("	A.disinfectant_id,\n")
					.append("	B.disinfectant_nm,\n")
					.append("	purchase_amount,\n")
					.append("	use_amount,\n")
					.append("	stock_amount,\n")
					.append("	check_detail,\n")
					.append("	result\n")
					.append("FROM\n")
					.append("	haccp_disinfectant_detail A JOIN haccp_disinfectant_info B\n")
					.append("	ON A.disinfectant_id = B.disinfectant_id\n")
					.append("WHERE\n")
					.append("	regist_seq_no = '"+jArray.get("regist_seq_no").toString()+"'\n")
					.append("ORDER BY check_date DESC, A.disinfectant_id ASC \n")
					.toString();

			resultString = super.excuteQueryString(con, sql);
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M838S020800E114()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) {
						con.close();
					}
				} catch (Exception e) {
					LoggingWriter.setLogError("M838S020800E114()","==== finally ===="+ e.getMessage());
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
					.append("	check_date,\n")
					.append("	LIST(SELECT purchase_amount,use_amount,stock_amount, check_detail,result\n")
					.append("	 FROM haccp_disinfectant_detail A2			\n")
					.append("	 WHERE A.check_date = A2.check_date			\n")
					.append("	 ORDER BY check_date ASC ,disinfectant_id ASC ) AS result,		\n")
					.append("	C.user_nm AS person_write_id,\n")
					.append("	D.user_nm AS person_check_id,\n")
					.append("	E.user_nm AS person_approve_id\n")
					.append("FROM\n")
					.append("	haccp_disinfectant_detail A JOIN haccp_disinfectant B \n")
					.append("	ON A. regist_seq_no = B.regist_seq_no\n")
					.append("	LEFT JOIN tbm_users C\n")
					.append("	ON B.person_write_id = C.user_id\n")
					.append("	AND B.regist_date BETWEEN (C.start_date) AND (C.duration_date)\n")
					.append("	LEFT JOIN tbm_users D\n")
					.append("	ON B.person_check_id = D.user_id\n")
					.append("	AND B.regist_date BETWEEN (D.start_date) AND (D.duration_date)\n")
					.append("	LEFT JOIN tbm_users E\n")
					.append("	ON B.person_approve_id = E.user_id\n")
					.append("	AND B.regist_date BETWEEN (E.start_date) AND (E.duration_date)\n")
					.append("group by check_date\n")
					.append("HAVING A.regist_seq_no = '"+regist_seq_no+"'\n")
					.append("ORDER BY check_date asc\n")
					.toString();

			resultString = super.excuteQueryString(con, sql);
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M838S020800E144()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M838S020800E144()","==== finally ===="+ e.getMessage());
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
					.append("	check_date,\n")
					.append("	disinfectant_id,\n")
					.append("	regist_seq_no,\n")
					.append("	purchase_amount,\n")
					.append("	use_amount,\n")
					.append("	stock_amount,\n")
					.append("	check_detail,\n")
					.append("	result\n")
					.append("FROM\n")
					.append("	haccp_disinfectant_detail\n")
					.append("WHERE\n")
					.append("	check_date = '"+jArray.get("check_date").toString()+"' \n")
					.append("	AND regist_seq_no = '"+jArray.get("regist_seq_no").toString()+"'\n")
					.append("ORDER BY disinfectant_id ASC \n")
					.toString();
			
			resultString = super.excuteQueryString(con, sql);
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M838S020800E154()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) {
						con.close();
					}
				} catch (Exception e) {
					LoggingWriter.setLogError("M838S020800E154()","==== finally ===="+ e.getMessage());
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
    				.append("UPDATE haccp_disinfectant										\n")
    				.append("SET															\n")
    				.append("	person_approve_id = '" + jObj.get("userId") + "'				\n")
    				.append("WHERE regist_seq_no = '"+ jObj.get("seq_no") + "'		\n")
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
			LoggingWriter.setLogError("M838S020800E502()","==== SQL ERROR ===="+ e.getMessage());
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
    				.append("UPDATE haccp_disinfectant										\n")
    				.append("SET															\n")
    				.append("	person_check_id = '" + jObj.get("userId") + "'				\n")
    				.append("WHERE regist_seq_no = '"+ jObj.get("seq_no") + "'		\n")
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
			LoggingWriter.setLogError("M838S020800E522()","==== SQL ERROR ===="+ e.getMessage());
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