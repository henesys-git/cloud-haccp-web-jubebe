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
 * 제품운송 차량관리 기록
 * 
 * 작성자: 서승헌
 * 
 * */


/**
 * 개요 : 이벤트ID별 메소드 정의
 */
public class M838S100200 extends SqlAdapter{
	Connection con = null;
	PreparedStatement pstmt = null;
	String resultString = "";
	int resultInt = -1;
	StringBuffer sql = new StringBuffer();
	
	String[][] v_paramArray = new String[0][0]; 
	Class[] optClass = null;
	Object[] optObj = null;
	Object obj = null;
	
	public M838S100200(){
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
			
			Method method = M838S100200.class.getMethod(event,optClass);
			LoggingWriter.setLogDebug(M838S100200.class.getName(),"==== " + event + " EventMethod Create Success ====");

			obj = method.invoke(M838S100200.class.newInstance(),optObj);
			doExcute_result = CommonFunction.getInt(obj.toString());
			
	    } catch (Exception ex) {
	    	doExcute_result = EventDefine.E_DOEXCUTE_INIT;
			ioParam.setMessage(MessageDefine.M_NO_EVENTID);
			LoggingWriter.setLogError(M838S100200.class.getName(),"==== EventID Not define : EVENT ID [ " + ioParam.getEventID() + "]");
	    } finally {
	    	obj = null;
			optClass = null;
			optObj = null;
	    }
	    long endTime = System.currentTimeMillis();
		long runningTime = endTime - startTime;
		LoggingWriter.setLogAll(M838S100200.class.getName(),"==== Query [수행시간  : " + runningTime + " ms]");
		
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
    		String drive_date = jObj.get("drive_date").toString();
    		
    		JSONObject form = (JSONObject) jObj.get("form");
    		
    		String sql = new StringBuilder()
    				.append("INSERT INTO										 \n")
    				.append("	haccp_car (	 									 \n")
    				.append("		drive_date,									 \n")
    				.append("    	checklist_id,								 \n")
    				.append("   	checklist_rev_no,							 \n")
    				.append("   	check_yn1,									 \n")
    				.append("   	check_yn2,									 \n")
    				.append("   	unsuit_detail,								 \n")
    				.append("   	improve_action,								 \n")
    				.append("   	bigo,										 \n")
    				.append("    	person_write_id		 						 \n")
    				.append(") VALUES (									 		 \n")
    				.append("		'"+drive_date+"',							 \n")
    				.append("		'"+checklist_id+"',							 \n")
    				.append("    	(SELECT MAX(checklist_rev_no)				 \n")
    				.append("    	FROM checklist								 \n")
    				.append("    	WHERE checklist_id = '"+checklist_id+"'),	 \n")
    				.append("		'"+form.get("check_yn1").toString()+"',		 \n")
    				.append("		'"+form.get("check_yn2").toString()+"',		 \n")
    				.append("		'"+jObj.get("unsuit_detail").toString()+"',	 \n")
    				.append("		'"+jObj.get("improve_action").toString()+"', \n")
    				.append("		'"+jObj.get("bigo").toString()+"',			 \n")
    				.append("		'"+jObj.get("person_write_id")+"'		 	 \n")
    				.append(")													 \n")
    				.toString();
			
			resultInt = super.excuteUpdate(con, sql);
	    	if(resultInt < 0) {
				ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
				con.rollback();
				return EventDefine.E_DOEXCUTE_ERROR ;
			}
    		
    		sql = new StringBuilder()
    				.append("SELECT regist_seq_no\n")
    				.append("	FROM haccp_car	\n")
    				.append("	ORDER BY regist_seq_no DESC FOR ORDERBY_NUM() = 1 \n")
    				.toString();
    		
    		resultString = super.excuteQueryString(con, sql);
	    		 
    		if(resultString.length() > 1) {
    			
    			String regist_seq_no = resultString.trim();
    			
    			for(int i = 0; i < 8; i++) {
        			
        			sql = new StringBuilder()
        	    			.append("INSERT INTO										 \n")
        	    			.append("	haccp_car_detail (								 \n")
        	    			.append("		regist_seq_no,								 \n")
        	    			.append("		drive_date,									 \n")
        	    			.append("		drive_course_start,							 \n")
        	    			.append("		drive_course_end,						 	 \n")
        	    			.append("		departure_time,								 \n")
        	    			.append("		arrive_time,							 	 \n")
        	    			.append("		vehicle_id,									 \n")
        	    			.append("		temp_gubun								 	 \n")
        	    			.append("	)												 \n")
        	    			.append("VALUES												 \n")
        	    			.append("	(												 \n")
        	    			.append("		 "+regist_seq_no+", 						 \n")
        	    			.append("		 '"+drive_date+"', 							 \n")
        	    			.append("		 '"+form.get("drive_course_start_"+i)+"', 	 \n")
        	    			.append("		 '"+form.get("drive_course_end_"+i)+"',	 	 \n")
        	    			.append("		 TIME '"+form.get( "departure_time_"+i)+"',  \n")
        	    			.append("		 TIME '"+form.get( "arrive_time_"+i)+"',	 \n")
        	    			.append("		 '"+form.get( "vehicle_id_"+i)+"', 	 		 \n")
        	    			.append("		 '"+form.get( "temp_gubun_"+i)+"' 			 \n")
        	    			.append("	) 												 \n")
        	    			.toString();
        			
        			resultInt = super.excuteUpdate(con, sql);
        	    	if(resultInt < 0) {
        				ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
        				con.rollback();
        				return EventDefine.E_DOEXCUTE_ERROR ;
        			}
        		}
    			
    		}
			con.commit();	
		} catch(Exception e) {
			e.getStackTrace();
			LoggingWriter.setLogError("M838S100200E101()","==== SQL ERROR ===="+ e.getMessage());
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
	
	// 수정 --> DELETE 후 등록 쿼리 재사용
	public int E102(InoutParameter ioParam){ 
		resultInt = EventDefine.E_DOEXCUTE_INIT;

		try {
			con = JDBCConnectionPool.getConnection();
			con.setAutoCommit(false);
			
    		JSONObject jObj = new JSONObject();
    		jObj = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
    		
    		String regist_seq_no = jObj.get("regist_seq_no").toString();
    		String drive_date = jObj.get("drive_date").toString();

	    	JSONObject form = (JSONObject) jObj.get("form");
    		
    		String sql = new StringBuilder()
    				.append("UPDATE\n")
    				.append("	haccp_car\n")
    				.append("SET\n")
    				.append("	check_yn1 = '"+form.get("check_yn1").toString()+"',\n")
    				.append("	check_yn2 = '"+form.get("check_yn2").toString()+"',\n")
    				.append("	unsuit_detail = '"+jObj.get("unsuit_detail").toString()+"',\n")
    				.append("	improve_action = '"+jObj.get("improve_action").toString()+"',\n")
    				.append("	improve_action_check = '',\n")
    				.append("	bigo = '"+jObj.get("bigo").toString()+"',\n")
    				.append("	person_write_id = '"+jObj.get("person_write_id").toString()+"',\n")
    				.append("	person_check_id = '',\n")
    				.append("	person_approve_id = ''\n")
    				.append("WHERE\n")
    				.append("	regist_seq_no = '"+regist_seq_no+"'\n")
    				.append("	AND drive_date = '"+drive_date+"'\n")
    				.toString();

    		resultInt = super.excuteUpdate(con, sql);
	    	if(resultInt < 0) {
				ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
				con.rollback();
				return EventDefine.E_DOEXCUTE_ERROR ;
			}
    		
    		sql = new StringBuilder()
    				.append("DELETE FROM									\n")
    				.append("	haccp_car_detail							\n")
    				.append("WHERE											\n")
    				.append("	drive_date = '"+drive_date+"'				\n")
    				.append("	AND regist_seq_no = '"+regist_seq_no+"'		\n")
    				.toString();
    		
    		resultInt = super.excuteUpdate(con, sql);
	    	if(resultInt < 0) {
				ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
				con.rollback();
				return EventDefine.E_DOEXCUTE_ERROR ;
			}
    		
	    	for(int i = 0; i < 8; i++) {
    			
    			sql = new StringBuilder()
    	    			.append("INSERT INTO										 \n")
    	    			.append("	haccp_car_detail (								 \n")
    	    			.append("		regist_seq_no,								 \n")
    	    			.append("		drive_date,									 \n")
    	    			.append("		drive_course_start,							 \n")
    	    			.append("		drive_course_end,						 	 \n")
    	    			.append("		departure_time,								 \n")
    	    			.append("		arrive_time,							 	 \n")
    	    			.append("		vehicle_id,									 \n")
    	    			.append("		temp_gubun								 	 \n")
    	    			.append("	)												 \n")
    	    			.append("VALUES												 \n")
    	    			.append("	(												 \n")
    	    			.append("		 "+regist_seq_no+", 						 \n")
    	    			.append("		 '"+drive_date+"', 							 \n")
    	    			.append("		 '"+form.get("drive_course_start_"+i)+"', 	 \n")
    	    			.append("		 '"+form.get("drive_course_end_"+i)+"',	 	 \n")
    	    			.append("		 TIME '"+form.get( "departure_time_"+i)+"',  \n")
    	    			.append("		 TIME '"+form.get( "arrive_time_"+i)+"',	 \n")
    	    			.append("		 '"+form.get( "vehicle_id_"+i)+"', 	 		 \n")
    	    			.append("		 '"+form.get( "temp_gubun_"+i)+"' 			 \n")
    	    			.append("	) 												 \n")
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
			LoggingWriter.setLogError("M838S100200E102()","==== SQL ERROR ===="+ e.getMessage());
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
    		String drive_date = jObj.get("drive_date").toString();
    		
    		String sql = new StringBuilder()
    				.append("DELETE FROM									\n")
    				.append("	haccp_car									\n")
    				.append("WHERE											\n")
    				.append("	drive_date = '"+drive_date+"'				\n")
    				.append("	AND regist_seq_no = '"+regist_seq_no+"'		\n")
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
			LoggingWriter.setLogError("M838S100200E103()","==== SQL ERROR ===="+ e.getMessage());
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
					.append("SELECT DISTINCT											\n")
					.append("	A.checklist_id,											\n")
					.append("	A.checklist_rev_no,										\n")
					.append("	A.drive_date,											\n")
					.append("	A.regist_seq_no,\n")
					.append("	DECODE(SUBSTR(T2.cust_gubun,-1), '1', '강서', '2', '강동', '지방') AS cust_gubun,\n")
					.append("	A.unsuit_detail,\n")
					.append("	A.improve_action,\n")
					.append("	A.bigo,													\n")
					.append("	B.user_nm AS person_write_id,							\n")
					.append("	C.user_nm AS person_check_id,							\n")
					.append("	D.user_nm AS person_approve_id,							\n")
					.append("	E.user_nm AS improve_action_check,\n")
					.append("	A.car_temp_regist_no,\n")
					.append("	A.file_name,\n")
					.append("	A.file_path,\n")
					.append("	A.file_path,\n")
					.append("	A.file_rev_no\n")
					.append("FROM haccp_car A		\n")
					.append("JOIN haccp_car_detail T\n")
					.append("ON A.regist_seq_no = T.regist_seq_no\n")
					.append("AND A.drive_date = T.drive_date\n")
					.append("JOIN tbm_vehicle_users T2\n")
					.append("ON T.vehicle_id = T2.user_id\n")
					.append("LEFT JOIN tbm_users B										\n")
					.append("	ON A.person_write_id = B.user_id						\n")
					.append("AND A.drive_date BETWEEN CAST(B.start_date AS DATE) AND CAST(B.duration_date AS DATE) \n")
					.append("LEFT JOIN tbm_users C										\n")
					.append("	ON A.person_check_id = C.user_id						\n")
					.append("AND A.drive_date BETWEEN CAST(C.start_date AS DATE) AND CAST(C.duration_date AS DATE) \n")
					.append("LEFT JOIN tbm_users D										\n")
					.append("	ON A.person_approve_id = D.user_id						\n")
					.append("AND A.drive_date BETWEEN CAST(D.start_date AS DATE) AND CAST(D.duration_date AS DATE) \n")
					.append("LEFT JOIN tbm_users E\n")
					.append("	ON A.improve_action_check = E.user_id					\n")
					.append("AND A.drive_date BETWEEN CAST(E.start_date AS DATE) AND CAST(E.duration_date AS DATE) \n")
					.append("WHERE A.drive_date BETWEEN '"+ jArray.get("fromdate") + "'	\n")  
					.append("                     AND '"+ jArray.get("todate") + "' 	\n")
					.append("ORDER BY A.drive_date DESC, A.regist_seq_no DESC\n")
					.toString();

			resultString = super.excuteQueryString(con, sql);
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M838S100200E104()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) {
						con.close();
					}
				} catch (Exception e) {
					LoggingWriter.setLogError("M838S100200E104()","==== finally ===="+ e.getMessage());
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
    				.append("	regist_seq_no\n")
    				.append("FROM\n")
    				.append("	haccp_car\n")
    				.append("ORDER BY regist_seq_no DESC FOR ORDERBY_NUM()  = 1\n")
    				.toString();

			resultString = super.excuteQueryString(con, sql.toString());
    		
			sql = new StringBuilder()
					.append("UPDATE haccp_car		  			  \n")
					.append("   SET file_name = '"+c_paramArray[0][10]+"',\n")	//file_view_name
					.append("   	file_path = '"+c_paramArray[0][11]+"',\n")	//file_path
					.append("   	car_temp_regist_no = '"+c_paramArray[0][19]+"' \n")	//regist_no
					.append(" WHERE regist_seq_no = "+resultString.trim()+"	  \n")
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
			LoggingWriter.setLogError("M838S100200E111()","==== SQL ERROR ===="+ e.getMessage());
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
					.append("UPDATE haccp_car					\n")
					.append("   SET file_name = '"+c_paramArray[0][10]+"',\n")	//file_view_name
					.append("   	file_path = '"+c_paramArray[0][11].replaceAll("//", "/")+"',\n")	//file_path
					.append("   	file_rev_no = '"+c_paramArray[0][8]+"',\n")	//file_rev_no
					.append("   	car_temp_regist_no = '"+c_paramArray[0][18]+"'\n")	//regist_no
					.append(" WHERE regist_seq_no = "+c_paramArray[0][24]+"\n")
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
			LoggingWriter.setLogError("M838S100200E112()","==== SQL ERROR ===="+ e.getMessage());
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
					.append("UPDATE haccp_car				\n")
					.append("   SET file_name = '',\n")	//file_view_name
					.append("   	file_path = ''\n")	//file_path
					.append(" WHERE regist_seq_no = "+jArray.get("regist_seq_no").toString()+"\n")
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
			LoggingWriter.setLogError("M838S100200E113()","==== SQL ERROR ===="+ e.getMessage());
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
	
	// 서브 테이블 조회
	public int E114(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			
			String sql = new StringBuilder()
					.append("SELECT\n")
					.append("	A.regist_seq_no,\n")
					.append("	A.drive_date,\n")
					.append("	seq_no,\n")
					.append("	drive_course_start || ' ~ ' || drive_course_end,\n")
					.append("	TO_CHAR(departure_time, 'HH24:MI'),\n")
					.append("	TO_CHAR(arrive_time, 'HH24:MI'),\n")
					.append("	V2.vehicle_nm || '/' || U.user_nm,\n")
					.append("	temp_gubun\n")
					.append("FROM\n")
					.append("	haccp_car_detail A \n")
					.append("	JOIN haccp_car C\n")
					.append("	ON A.regist_seq_no = C.regist_seq_no\n")
					.append("	JOIN tbm_users U\n")
					.append("	ON A.vehicle_id = U.user_id\n")
					.append("	JOIN tbm_vehicle_users V\n")
					.append("	ON A.vehicle_id = V.user_id\n")
					.append("	JOIN tbm_vehicle V2\n")
					.append("	ON V.vehicle_cd = V2.vehicle_cd\n")
					.append("WHERE\n")
					.append("	A.regist_seq_no = "+jArray.get("regist_seq_no").toString().trim()+"\n")
					.append("	AND A.drive_date = DATE '"+jArray.get("drive_date").toString()+"'\n")
					.append("	AND drive_course_end IS NOT NULL AND drive_course_end != ''\n")
					.toString();

			resultString = super.excuteQueryString(con, sql);
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M838S10020E114()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) {
						con.close();
					}
				} catch (Exception e) {
					LoggingWriter.setLogError("M838S10020E114()","==== finally ===="+ e.getMessage());
				}
	    	}
	    }

		ioParam.setResultString(resultString);
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
    	ioParam.setMessage(MessageDefine.M_QUERY_OK);

    	return EventDefine.E_QUERY_RESULT;
	}
	
	// 운행구간 조회
	public int E124(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			
			String sql = new StringBuilder()
					.append("SELECT\n")
					.append("	cust_cd,\n")
					.append("	revision_no,\n")
					.append("	cust_nm,\n")
					.append("	address,\n")
					.append("	telno,\n")
					.append("	boss_name,\n")
					.append("	member_key\n")
					.append("FROM\n")
					.append("	tbm_customer\n")
					.append("WHERE\n")
					.append("	company_type_b = 'CUSTOMER_GUBUN_BIG02'\n")
					.append("	AND cust_nm LIKE '%' || '"+jArray.get("searchCust").toString()+"' || '%'\n")
					.append("ORDER BY cust_nm ASC\n")
					.toString();

			resultString = super.excuteQueryString(con, sql);
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M838S10020E124()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) {
						con.close();
					}
				} catch (Exception e) {
					LoggingWriter.setLogError("M838S10020E124()","==== finally ===="+ e.getMessage());
				}
	    	}
	    }

		ioParam.setResultString(resultString);
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
    	ioParam.setMessage(MessageDefine.M_QUERY_OK);

    	return EventDefine.E_QUERY_RESULT;
	}
	
	// 배송기사 조회
	public int E134(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			
			String sql = new StringBuilder()
					.append("SELECT\n")
					.append("	V.user_id, user_nm, vehicle_nm || '/' || user_nm\n")
					.append("FROM tbm_vehicle_users V\n")
					.append("    JOIN tbm_users U\n")
					.append("	ON U.user_id = V.user_id\n")
					.append("	JOIN tbm_vehicle V2\n")
					.append("	ON V.vehicle_cd = V2.vehicle_cd\n")
					.append("ORDER BY V.user_id ASC\n")
					.toString();

			resultString = super.excuteQueryString(con, sql);
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M838S10020E134()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) {
						con.close();
					}
				} catch (Exception e) {
					LoggingWriter.setLogError("M838S10020E134()","==== finally ===="+ e.getMessage());
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
			
			String sql = new StringBuilder()
					.append("SELECT\n")
					.append("	A.checklist_id,\n")
					.append("	A.checklist_rev_no,	\n")
					.append("	A.drive_date,\n")
					.append("	A.regist_seq_no,\n")
					.append("	TO_CHAR(A.drive_date, ' YYYY \"년 \" MM \"월 \" DD \"일 \"'),\n")
					.append("	DECODE(DAYOFWEEK(A.drive_date), 1, '일', 2, '월', 3, '화', 4, '수', 5, '목', 6, '금', '토') || '요일',				\n")
					.append("	DECODE(SUBSTR(T2.cust_gubun,-1), '1', '강서', '2', '강동', '지방') AS cust_gubun,\n")
					.append("	check_yn1,\n")
					.append("	check_yn2,\n")
					.append("	A.unsuit_detail,\n")
					.append("	A.improve_action,\n")
					.append("	A.bigo,	\n")
					.append("	drive_course_start || ' ~ ' || drive_course_end,\n")
					.append("	TO_CHAR(departure_time, 'HH24:MI'),\n")
					.append("	TO_CHAR(arrive_time, 'HH24:MI'),\n")
					.append("	V2.vehicle_nm || '/' || U.user_nm,\n")
					.append("	DECODE(temp_gubun, 1, '냉장/냉동', 2, '냉장', '냉동'),		\n")
					.append("	B.user_nm AS person_write_id,							\n")
					.append("	C.user_nm AS person_check_id,							\n")
					.append("	D.user_nm AS person_approve_id,							\n")
					.append("	E.user_nm AS improve_action_check\n")
					.append("FROM haccp_car A		\n")
					.append("INNER JOIN haccp_car_detail T\n")
					.append("	ON A.regist_seq_no = T.regist_seq_no\n")
					.append("	AND A.drive_date = T.drive_date\n")
					.append("INNER JOIN tbm_vehicle_users T2\n")
					.append("	ON T.vehicle_id = T2.user_id\n")
					.append("LEFT JOIN tbm_users B										\n")
					.append("	ON A.person_write_id = B.user_id						\n")
					.append("	AND A.drive_date BETWEEN CAST(B.start_date AS DATE) AND CAST(B.duration_date AS DATE) \n")
					.append("LEFT JOIN tbm_users C										\n")
					.append("	ON A.person_check_id = C.user_id						\n")
					.append("	AND A.drive_date BETWEEN CAST(C.start_date AS DATE) AND CAST(C.duration_date AS DATE) \n")
					.append("LEFT JOIN tbm_users D										\n")
					.append("	ON A.person_approve_id = D.user_id						\n")
					.append("	AND A.drive_date BETWEEN CAST(D.start_date AS DATE) AND CAST(D.duration_date AS DATE) \n")
					.append("LEFT JOIN tbm_users E\n")
					.append("	ON A.improve_action_check = E.user_id					\n")
					.append("	AND A.drive_date BETWEEN CAST(E.start_date AS DATE) AND CAST(E.duration_date AS DATE) \n")
					.append("INNER JOIN tbm_users U\n")
					.append("	ON T.vehicle_id = U.user_id\n")
					.append("INNER JOIN tbm_vehicle_users V\n")
					.append("	ON T.vehicle_id = V.user_id\n")
					.append("INNER JOIN tbm_vehicle V2\n")
					.append("	ON V.vehicle_cd = V2.vehicle_cd\n")
					.append("WHERE\n")
					.append("	A.regist_seq_no = "+jArray.get("regist_seq_no").toString().trim()+"\n")
					.append("	AND A.drive_date = DATE '"+jArray.get("drive_date").toString()+"'\n")
					.append("	AND drive_course_end IS NOT NULL AND drive_course_end != ''\n")
					.append("ORDER BY seq_no ASC;\n")
					.toString();
			
			resultString = super.excuteQueryString(con, sql);
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M838S100200E144()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M838S100200E144()","==== finally ===="+ e.getMessage());
				}
	    	} else {
	    	}
	    }
		ioParam.setResultString(resultString);
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
    	ioParam.setMessage(MessageDefine.M_QUERY_OK);

    	return EventDefine.E_QUERY_RESULT;
	}
	
	// 수정용 쿼리  
	public int E154(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			
			String sql = new StringBuilder()
					.append("SELECT\n")
					.append("	A.checklist_id,\n")
					.append("	A.checklist_rev_no,	\n")
					.append("	A.drive_date,\n")
					.append("	A.regist_seq_no,\n")
					.append("	check_yn1,\n")
					.append("	check_yn2,\n")
					.append("	A.unsuit_detail,\n")
					.append("	A.improve_action,\n")
					.append("	A.bigo,	\n")
					.append("	drive_course_start,\n")
					.append("	drive_course_end,\n")
					.append("	TO_CHAR(departure_time, 'HH24:MI'),\n")
					.append("	TO_CHAR(arrive_time, 'HH24:MI'),\n")
					.append("	T.vehicle_id,\n")
					.append("	temp_gubun,\n")
					.append("	A.car_temp_regist_no,\n")
					.append("	A.file_name,\n")
					.append("	A.file_path,\n")
					.append("	A.file_rev_no\n")
					.append("FROM haccp_car A		\n")
					.append("INNER JOIN haccp_car_detail T\n")
					.append("	ON A.regist_seq_no = T.regist_seq_no\n")
					.append("	AND A.drive_date = T.drive_date\n")
					.append("INNER JOIN tbm_vehicle_users T2\n")
					.append("	ON T.vehicle_id = T2.user_id\n")
					.append("INNER JOIN tbm_users U\n")
					.append("	ON T.vehicle_id = U.user_id\n")
					.append("INNER JOIN tbm_vehicle_users V\n")
					.append("	ON T.vehicle_id = V.user_id\n")
					.append("INNER JOIN tbm_vehicle V2\n")
					.append("	ON V.vehicle_cd = V2.vehicle_cd\n")
					.append("WHERE\n")
					.append("	A.regist_seq_no = "+jArray.get("regist_seq_no").toString().trim()+"\n")
					.append("	AND A.drive_date = DATE '"+jArray.get("drive_date").toString()+"'\n")
					.append("	AND drive_course_end IS NOT NULL AND drive_course_end != ''\n")
					.append("ORDER BY seq_no ASC;\n")
					.toString();
			
			resultString = super.excuteQueryString(con, sql);
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M838S100200E144()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M838S100200E144()","==== finally ===="+ e.getMessage());
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
    				.append("UPDATE haccp_car												\n")
    				.append("SET															\n")
    				.append("	person_approve_id = '" + jObj.get("userId") + "'			\n")
    				.append("WHERE drive_date = '"+ jObj.get("checklistDate") + "'			\n")
    				.append("  AND regist_seq_no = '"+ jObj.get("seq_no") + "'				\n")
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
			LoggingWriter.setLogError("M838S100200E502()","==== SQL ERROR ===="+ e.getMessage());
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
    				.append("UPDATE haccp_car												\n")
    				.append("SET															\n")
    				.append("	person_check_id = '" + jObj.get("userId") + "'				\n")
    				.append("WHERE drive_date = '"+ jObj.get("checklistDate") + "'			\n")
    				.append("  AND regist_seq_no = '"+ jObj.get("seq_no") + "'				\n")
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
			LoggingWriter.setLogError("M838S100200E522()","==== SQL ERROR ===="+ e.getMessage());
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
	
	// 개선조치 확인자 서명 
	public int E532(InoutParameter ioParam){ 
		
		resultInt = EventDefine.E_DOEXCUTE_INIT;

		try {
			con = JDBCConnectionPool.getConnection();
			con.setAutoCommit(false);
			
    		JSONObject jObj = new JSONObject();
    		jObj = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
    		
    		String sql = new StringBuilder()
    				.append("UPDATE haccp_car												\n")
    				.append("SET															\n")
    				.append("	improve_action_check = '" + jObj.get("userId") + "'				\n")
    				.append("WHERE drive_date = '"+ jObj.get("checklistDate") + "'			\n")
    				.append("  AND regist_seq_no = '"+ jObj.get("seq_no") + "'				\n")
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
			LoggingWriter.setLogError("M838S100200E532()","==== SQL ERROR ===="+ e.getMessage());
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