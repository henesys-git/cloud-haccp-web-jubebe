package mes.frame.business.M838;

import java.lang.reflect.Method;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.util.Vector;

import org.json.simple.JSONObject;

import mes.frame.common.ApprovalActionNo;
import mes.client.conf.Config;
import mes.frame.common.EventDefine;
import mes.frame.common.HashObject;
import mes.frame.common.MessageDefine;
import mes.frame.common.QueueProcessing;
import mes.frame.database.JDBCConnectionPool;
import mes.frame.database.SqlAdapter;
import mes.frame.serviceinterface.InoutParameter;
import mes.frame.serviceinterface.LoggingWriter;
import mes.frame.util.CommonFunction;


public class M838S070300 extends SqlAdapter{
	Connection con = null;
	PreparedStatement pstmt = null;
	String resultString = "";
	int resultInt = -1;
	StringBuffer sql = new StringBuffer();
	
	String[][] v_paramArray = new String[0][0]; 
	Class[] optClass = null;
	Object[] optObj = null;
	Object obj = null;
	
	public M838S070300(){
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
			
			Method method = M838S070300.class.getMethod(event,optClass);
			LoggingWriter.setLogDebug(M838S070300.class.getName(),"==== " + event + " EventMethod Create Success ====");

			obj = method.invoke(M838S070300.class.newInstance(),optObj);
			doExcute_result = CommonFunction.getInt(obj.toString());
			
	    } catch (Exception ex) {
	    	doExcute_result = EventDefine.E_DOEXCUTE_INIT;
			ioParam.setMessage(MessageDefine.M_NO_EVENTID);
			LoggingWriter.setLogError(M838S070300.class.getName(),"==== EventID Not define : EVENT ID [ " + ioParam.getEventID() + "]");
	    } finally {
	    	obj = null;
			optClass = null;
			optObj = null;
	    }
	    long endTime = System.currentTimeMillis();
		long runningTime = endTime - startTime;
		LoggingWriter.setLogAll(M838S070300.class.getName(),"==== Query [수행시간  : " + runningTime + " ms]");
		
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
    				.append("INSERT INTO\n")
    				.append("	haccp_correction (\n")
    				.append("		check_date,\n")
    				.append("		checklist_id,\n")
    				.append("		checklist_rev_no,\n")
    				.append("		person_write_id\n")
    				.append("	)\n")
    				.append("VALUES\n")
    				.append("	(\n")
    				.append("		'"+check_date+"',\n")
    				.append("		'"+checklist_id+"',\n")
    				.append("		(SELECT MAX(checklist_rev_no) 				\n")
    				.append("		 FROM checklist								\n")
    				.append("		 WHERE checklist_id = '"+ checklist_id +"'),\n")
    				.append("		'"+jObj.get("person_write_id").toString()+"'\n")
    				.append("	);\n")
    				.toString();

    		resultInt = super.excuteUpdate(con, sql);
	    	if(resultInt < 0) {
				ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
				con.rollback();
				return EventDefine.E_DOEXCUTE_ERROR ;
			}

    		JSONObject form = (JSONObject) jObj.get("form");
    		System.out.println(form);
    		
    		for(int i = 0; i < 13; i++) {
    			
    			String facility_id = form.get("facility_id_"+i).toString();
    			String place_id = form.get("place_id_"+i).toString();
    			String standard_value = form.get("standard_value_"+i).toString();
    			String check_value = form.get("check_value_"+i).toString();
    			String judge = form.get("judge_"+i).toString();
    			String improve_action = form.get("improve_action_"+i).toString();
    			
    			sql = new StringBuilder()
    	    			.append("INSERT INTO\n")
    	    			.append("	haccp_correction_result (\n")
    	    			.append("		check_date,\n")
    	    			.append("		facility_id,\n")
    	    			.append("		facility_rev_no,\n")
    	    			.append("		place_id,\n")
    	    			.append("		standard_value,\n")
    	    			.append("		check_value,\n")
    	    			.append("		judge,\n")
    	    			.append("		improve_action\n")
    	    			.append("	)\n")
    	    			.append("VALUES\n")
    	    			.append("	(\n")
    	    			.append("		'"+check_date+"',\n")
    	    			.append("		'"+facility_id+"',\n")
    	    			.append("		(SELECT MAX(facility_rev_no)\n")
    	    		   	.append("		 FROM haccp_correction_seolbi\n")
    	    		   	.append("		 WHERE facility_id = '"+ facility_id +"'),\n")
    	    			.append("		'"+place_id+"',\n")
    	    			.append("		'"+standard_value+"',\n")
    	    			.append("		'"+check_value+"',\n")
    	    			.append("		'"+judge+"',\n")
    	    			.append("		'"+improve_action+"'\n")
    	    			.append("	);\n")
    	    			.toString();

        		resultInt = super.excuteUpdate(con, sql);
    	    	if(resultInt < 0) {
    				ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
    				con.rollback();
    				return EventDefine.E_DOEXCUTE_ERROR ;
    			}
    			
    		}
    		
			con.commit();
		} catch(Exception e) {
			e.getStackTrace();
			LoggingWriter.setLogError("M838S070300E101()","==== SQL ERROR ===="+ e.getMessage());
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
	
	// 수정 (delete 후 재 등록)
	public int E102(InoutParameter ioParam){ 
		resultInt = EventDefine.E_DOEXCUTE_INIT;

		try {
			con = JDBCConnectionPool.getConnection();
			con.setAutoCommit(false);
			
    		JSONObject jObj = new JSONObject();
    		jObj = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
    		
    		String check_date = jObj.get("check_date").toString();
    		
    		String sql = new StringBuilder()
    				.append("DELETE FROM haccp_correction_result\n")
    				.append("WHERE check_date = '"+check_date+"'\n")
    				.toString();

    		resultInt = super.excuteUpdate(con, sql);
	    	if(resultInt < 0) {
				ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
				con.rollback();
				return EventDefine.E_DOEXCUTE_ERROR ;
			}
	    	
	    	JSONObject form = (JSONObject) jObj.get("form");
    		System.out.println(form);
    		
    		for(int i = 0; i < 13; i++) {
    			
    			String facility_id = form.get("facility_id_"+i).toString();
    			String place_id = form.get("place_id_"+i).toString();
    			String standard_value = form.get("standard_value_"+i).toString();
    			String check_value = form.get("check_value_"+i).toString();
    			String judge = form.get("judge_"+i).toString();
    			String improve_action = form.get("improve_action_"+i).toString();
    			
    			sql = new StringBuilder()
    	    			.append("INSERT INTO\n")
    	    			.append("	haccp_correction_result (\n")
    	    			.append("		check_date,\n")
    	    			.append("		facility_id,\n")
    	    			.append("		facility_rev_no,\n")
    	    			.append("		place_id,\n")
    	    			.append("		standard_value,\n")
    	    			.append("		check_value,\n")
    	    			.append("		judge,\n")
    	    			.append("		improve_action\n")
    	    			.append("	)\n")
    	    			.append("VALUES\n")
    	    			.append("	(\n")
    	    			.append("		'"+check_date+"',\n")
    	    			.append("		'"+facility_id+"',\n")
    	    			.append("		(SELECT MAX(facility_rev_no)\n")
    	    		   	.append("		 FROM haccp_correction_seolbi\n")
    	    		   	.append("		 WHERE facility_id = '"+ facility_id +"'),\n")
    	    			.append("		'"+place_id+"',\n")
    	    			.append("		'"+standard_value+"',\n")
    	    			.append("		'"+check_value+"',\n")
    	    			.append("		'"+judge+"',\n")
    	    			.append("		'"+improve_action+"'\n")
    	    			.append("	);\n")
    	    			.toString();

        		resultInt = super.excuteUpdate(con, sql);
    	    	if(resultInt < 0) {
    				ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
    				con.rollback();
    				return EventDefine.E_DOEXCUTE_ERROR ;
    			}
    			
    		}
    		
    		sql = new StringBuilder()
    				.append("UPDATE\n")
    				.append("	haccp_correction\n")
    				.append("SET\n")
    				.append("	person_write_id = '"+jObj.get("person_write_id").toString()+"',\n")
    				.append("	person_approve_id = '',\n")
    				.append("	person_check_id = ''\n")
    				.append("WHERE\n")
    				.append("	check_date = '"+check_date+"'\n")
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
			LoggingWriter.setLogError("M838S070300E102()","==== SQL ERROR ===="+ e.getMessage());
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
    				.append("DELETE FROM\n")
    				.append("	haccp_correction_result \n")
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
    				.append("	haccp_correction \n")
    				.append("WHERE\n")
    				.append("	check_date = '"+check_date+"'\n")
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
			LoggingWriter.setLogError("M838S070300E103()","==== SQL ERROR ===="+ e.getMessage());
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
	
	// 조회
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
					.append("	B.user_nm AS person_write_id,\n")
					.append("	B2.user_nm AS person_check_id,\n")
					.append("	B3.user_nm AS person_approve_id\n")
					.append("FROM\n")
					.append("	haccp_correction A\n")
					.append("	LEFT JOIN tbm_users B\n")
					.append("	ON A.person_write_id = B.user_id\n")
					.append("	AND A.check_date BETWEEN B.start_date AND B.duration_date\n")
					.append("	LEFT JOIN tbm_users B2\n")
					.append("	ON A.person_check_id = B2.user_id\n")
					.append("	AND A.check_date BETWEEN B2.start_date AND B2.duration_date\n")
					.append("	LEFT JOIN tbm_users B3\n")
					.append("	ON A.person_approve_id = B3.user_id\n")
					.append("	AND check_date BETWEEN B3.start_date AND B3.duration_date\n")
					.append("ORDER BY check_date DESC\n")
					.toString();

			String ActionCommand = ioParam.getActionCommand();
			if(ActionCommand.startsWith("doQueryTableFieldName")) {
				resultString = super.excuteQueryStringTableFieldName(con, sql.toString());
			}
			else {;
				resultString = super.excuteQueryString(con, sql.toString());
			}
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M838S070300E104()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M838S070300E104()","==== finally ===="+ e.getMessage());
				}
	    	} else {
	    	}
	    }
		ioParam.setResultString(resultString);
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
    	ioParam.setMessage(MessageDefine.M_QUERY_OK);
	    
    	return EventDefine.E_QUERY_RESULT;
	}
	
	// 점검표 데이터 불러오기
	public int E144(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));

			String check_date = jArray.get("check_date").toString();
			
//			//censor_info랑 연동
//			String sql = new StringBuilder()
//					.append("SELECT\n")
//					.append("	checklist_id,\n")
//					.append("	checklist_rev_no,\n")
//					.append("	A.check_date,\n")
//					.append("	P.facility_id,\n")
//					.append("	S.facility_nm,\n")
//					.append("	P.place_id,\n")
//					.append("	P.place_detail,\n")
//					.append("	C.censor_no,\n")
//					.append("	C.censor_location,\n")
//					.append("	CAST(C.standard_value AS NUMERIC(10,1)),\n")
//					.append("	CAST(R.result AS NUMERIC(10,1)),\n")
//					.append("	CAST(R.result AS NUMERIC(10,1)) - CAST(C.standard_value AS NUMERIC(10,1)) AS stdev_temp,\n")
//					.append("	R.judge,\n")
//					.append("	R.improve_action,\n")
//					.append("	B.user_nm AS person_write_id,\n")
//					.append("	B2.user_nm AS person_approve_id,\n")
//					.append("	B3.user_nm AS person_check_id\n")
//					.append("FROM\n")
//					.append("	haccp_correction A\n")
//					.append("	JOIN haccp_correction_result R\n")
//					.append("		ON A.check_date = R.check_date\n")
//					.append("	JOIN	haccp_correction_place P\n")
//					.append("		ON P.place_id = R.place_id\n")
//					.append("		AND P.facility_id = R.facility_id\n")
//					.append("	JOIN haccp_correction_seolbi S\n")
//					.append("		ON P.facility_id = S.facility_id\n")
//					.append("	LEFT JOIN haccp_censor_info C\n")
//					.append("		ON ( P.place_detail LIKE '%' || DECODE(C.censor_location, '출고냉장실', '완제품  냉장실', '원재료냉장실', '원료육  냉장실', C.censor_location) || '%' )\n")
//					.append("		AND censor_type = 'TEMPERATURE'\n")
//					.append("	LEFT JOIN tbm_users B\n")
//					.append("		ON A.person_write_id = B.user_id\n")
//					.append("		AND A.check_date BETWEEN B.start_date AND B.duration_date\n")
//					.append("	LEFT JOIN tbm_users B2\n")
//					.append("		ON A.person_check_id = B2.user_id\n")
//					.append("		AND A.check_date BETWEEN B2.start_date AND B2.duration_date\n")
//					.append("	LEFT JOIN tbm_users B3\n")
//					.append("		ON A.person_write_id = B3.user_id\n")
//					.append("		AND person_approve_id BETWEEN B3.start_date AND B3.duration_date\n")
//					.append("WHERE R.check_date = '"+check_date+"'\n")
//					.append("ORDER BY A.check_date DESC\n")
//					.toString();

			String sql = new StringBuilder()
					.append("SELECT\n")
					.append("	checklist_id,\n")
					.append("	checklist_rev_no,\n")
					.append("	A.check_date,\n")
					.append("	P.facility_id,\n")
					.append("	S.facility_nm,\n")
					.append("	P.place_id,\n")
					.append("	P.place_detail,\n")
					.append("	CAST(R.standard_value AS NUMERIC(10,1)) AS result1,\n")
					.append("	CAST(R.check_value AS NUMERIC(10,1)) AS result2,\n")
					.append("	CAST(R.check_value - R.standard_value AS NUMERIC(10,1)) AS result3,\n")
					.append("	R.judge,\n")
					.append("	R.improve_action,\n")
					.append("	B.user_nm AS person_write_id,\n")
					.append("	B2.user_nm AS person_check_id,\n")
					.append("	B3.user_nm AS person_check_id\n")
					.append("FROM\n")
					.append("	haccp_correction A\n")
					.append("	JOIN haccp_correction_result R\n")
					.append("		ON A.check_date = R.check_date\n")
					.append("	JOIN	haccp_correction_place P\n")
					.append("		ON P.place_id = R.place_id\n")
					.append("		AND P.facility_id = R.facility_id\n")
					.append("	JOIN haccp_correction_seolbi S\n")
					.append("		ON P.facility_id = S.facility_id\n")
					.append("	LEFT JOIN tbm_users B\n")
					.append("		ON A.person_write_id = B.user_id\n")
					.append("		AND A.check_date BETWEEN B.start_date AND B.duration_date\n")
					.append("	LEFT JOIN tbm_users B2\n")
					.append("		ON A.person_check_id = B2.user_id\n")
					.append("		AND A.check_date BETWEEN B2.start_date AND B2.duration_date\n")
					.append("	LEFT JOIN tbm_users B3\n")
					.append("		ON A.person_approve_id = B3.user_id\n")
					.append("		AND A.check_date BETWEEN B3.start_date AND B3.duration_date\n")
					.append("WHERE R.check_date = '"+check_date+"'\n")
					.append("ORDER BY A.check_date DESC\n")
					.toString();
			
			String ActionCommand = ioParam.getActionCommand();
			if(ActionCommand.startsWith("doQueryTableFieldName")) {
				resultString = super.excuteQueryStringTableFieldName(con, sql.toString());
			}
			else {;
				resultString = super.excuteQueryString(con, sql.toString());
			}
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M838S070300E144()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M838S070300E144()","==== finally ===="+ e.getMessage());
				}
	    	} else {
	    	}
	    }
		ioParam.setResultString(resultString);
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
    	ioParam.setMessage(MessageDefine.M_QUERY_OK);
	    
    	return EventDefine.E_QUERY_RESULT;
	}
	
	// 등록페이지 데이터 불러오기
	public int E154(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));

			String sql = new StringBuilder()
					.append("SELECT\n")
					.append("	ROWNUM,\n")
					.append("	P.facility_id,\n")
					.append("	facility_nm,\n")
					.append("	place_id,\n")
					.append("	place_detail,\n")
					.append("	censor_no,\n")
					.append("	censor_location,\n")
					.append("	standard_value\n")
					.append("FROM\n")
					.append("	haccp_correction_place P\n")
					.append("	JOIN haccp_correction_seolbi S\n")
					.append("	ON P.facility_id = S.facility_id\n")
					.append("	LEFT JOIN haccp_censor_info C\n")
					.append("	ON ( P.place_detail LIKE '%' || DECODE(C.censor_location, '출고냉장실', '완제품  냉장실', '원재료냉장실', '원료육  냉장실', C.censor_location) || '%' )\n")
					.append("--			OR  P.place_detail LIKE '%' || SUBSTR(C.censor_location, -3) || '%' )\n")
					.append("	AND censor_type = 'TEMPERATURE'\n")
					.append("WHERE ROWNUM < 14\n")
					.append("ORDER BY P.place_id\n")
					.toString();

			String ActionCommand = ioParam.getActionCommand();
			if(ActionCommand.startsWith("doQueryTableFieldName")) {
				resultString = super.excuteQueryStringTableFieldName(con, sql.toString());
			}
			else {;
				resultString = super.excuteQueryString(con, sql.toString());
			}
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M838S070300E154()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M838S070300E154()","==== finally ===="+ e.getMessage());
				}
	    	} else {
	    	}
	    }
		ioParam.setResultString(resultString);
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
    	ioParam.setMessage(MessageDefine.M_QUERY_OK);
	    
    	return EventDefine.E_QUERY_RESULT;
	}
	
	// 수정할 데이터 불러오기
	public int E164(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));

			String check_date = jArray.get("check_date").toString();

			// censor_info 랑 연동했을때			
//			String sql = new StringBuilder()
//					.append("SELECT\n")
//					.append("	ROWNUM,\n")
//					.append("	P.facility_id,\n")
//					.append("	S.facility_nm,\n")
//					.append("	P.place_id,\n")
//					.append("	P.place_detail,\n")
//					.append("	C.censor_no,\n")
//					.append("	C.censor_location,\n")
//					.append("	CAST(C.standard_value AS NUMERIC(10,1)),\n")
//					.append("	CAST(R.result AS NUMERIC(10,1)),\n")
//					.append("	CAST(R.result AS NUMERIC(10,1)) - CAST(C.standard_value AS NUMERIC(10,1)) AS stdev_temp,\n")
//					.append("	R.judge,\n")
//					.append("	R.improve_action\n")
//					.append("FROM\n")
//					.append("	haccp_correction_place P\n")
//					.append("	JOIN haccp_correction_seolbi S\n")
//					.append("	ON P.facility_id = S.facility_id\n")
//					.append("	LEFT JOIN haccp_censor_info C\n")
//					.append("	ON ( P.place_detail LIKE '%' || DECODE(C.censor_location, '출고냉장실', '완제품  냉장실', '원재료냉장실', '원료육  냉장실', C.censor_location) || '%' )\n")
//					.append("	AND censor_type = 'TEMPERATURE'\n")
//					.append("	JOIN haccp_correction_result R\n")
//					.append("	ON P.facility_id = R.facility_id\n")
//					.append("	AND P.place_id = R.place_id\n")
//					.append("WHERE R.check_date = '"+check_date+"'\n")
//					.append("ORDER BY P.place_id\n")
//					.toString();

			String sql = new StringBuilder()
					.append("SELECT\n")
					.append("	ROWNUM,\n")
					.append("	P.facility_id,\n")
					.append("	S.facility_nm,\n")
					.append("	P.place_id,\n")
					.append("	P.place_detail,\n")
					.append("	CAST(R.standard_value AS NUMERIC(10,1)),\n")
					.append("	CAST(R.check_value AS NUMERIC(10,1)),\n")
					.append("	CAST(R.check_value - R.standard_value AS NUMERIC(10,1)) AS stdev_temp,\n")
					.append("	R.judge,\n")
					.append("	R.improve_action\n")
					.append("FROM\n")
					.append("	haccp_correction_place P\n")
					.append("	JOIN haccp_correction_seolbi S\n")
					.append("	ON P.facility_id = S.facility_id\n")
					.append("	JOIN haccp_correction_result R\n")
					.append("	ON P.facility_id = R.facility_id\n")
					.append("	AND P.place_id = R.place_id\n")
					.append("WHERE R.check_date = '"+check_date+"'\n")
					.append("ORDER BY P.place_id\n")
					.toString();

			String ActionCommand = ioParam.getActionCommand();
			if(ActionCommand.startsWith("doQueryTableFieldName")) {
				resultString = super.excuteQueryStringTableFieldName(con, sql.toString());
			}
			else {;
				resultString = super.excuteQueryString(con, sql.toString());
			}
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M838S070300E164()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M838S070300E164()","==== finally ===="+ e.getMessage());
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
    				.append("UPDATE haccp_correction										\n")
    				.append("SET															\n")
    				.append("	person_approve_id = '" + jObj.get("userId") + "'			\n")
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
			LoggingWriter.setLogError("M838S070300E502()","==== SQL ERROR ===="+ e.getMessage());
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
    				.append("UPDATE haccp_correction										\n")
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
			LoggingWriter.setLogError("M838S070300E522()","==== SQL ERROR ===="+ e.getMessage());
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