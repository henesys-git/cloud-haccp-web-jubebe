package mes.frame.business.M838;
/*BOM코드*/
import java.lang.reflect.Method;
import java.sql.Connection;
import java.sql.PreparedStatement;

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
public  class M838S020600 extends SqlAdapter{
	Connection con = null;
	PreparedStatement pstmt = null;
	String resultString = "";
	int resultInt = -1;
	StringBuffer sql = new StringBuffer();
	
	String[][] v_paramArray = new String[0][0]; 
	Class[] optClass = null;
	Object[] optObj = null;
	Object obj = null;
	
	public M838S020600(){
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
	public  int doExcute(InoutParameter ioParam){
		long startTime = System.currentTimeMillis();
		int doExcute_result = EventDefine.E_DOEXCUTE_INIT;;
		String event = ioParam.getEventSubID();

	    try{
            optClass = new Class[1];
			optClass[0] = ioParam.getClass() ;
			optObj = new Object[1];
			optObj[0] = ioParam;
			
			Method method = M838S020600.class.getMethod(event,optClass);
			LoggingWriter.setLogDebug(M838S020600.class.getName(),"==== " + event + " EventMethod Create Success ====");

			obj = method.invoke(M838S020600.class.newInstance(),optObj);
			doExcute_result = CommonFunction.getInt(obj.toString());
			
	    } catch (Exception ex) {
	    	doExcute_result = EventDefine.E_DOEXCUTE_INIT;
			ioParam.setMessage(MessageDefine.M_NO_EVENTID);
			LoggingWriter.setLogError(M838S020600.class.getName(),"==== EventID Not define : EVENT ID [ " + ioParam.getEventID() + "]");
	    } finally {
	    	obj = null;
			optClass = null;
			optObj = null;
	    }
	    long endTime = System.currentTimeMillis();
		long runningTime = endTime - startTime;
		LoggingWriter.setLogAll(M838S020600.class.getName(),"==== Query [수행시간  : " + runningTime + " ms]");
		
		return doExcute_result;
	}
	
	// S838S020600.jsp

	// 점검표 등록
	public int E101(InoutParameter ioParam){ 
		resultInt = EventDefine.E_DOEXCUTE_INIT;

		try {
			con = JDBCConnectionPool.getConnection();
			con.setAutoCommit(false);
			
			/*
			 * // insert_update_delete_json.jsp에서 받아온 JSON데이터 처리 JSONObject jArray = new
			 * JSONObject(); jArray =
			 * (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			 * System.out.println("JSONObject jArray rcvData="+ jArray.toString()); //
			 * Object데이터에서 키값(param)으로 JSONArray데이터를 꺼낸다. (데이터묶음 하나일땐 생략) JSONArray jjArray
			 * = (JSONArray) jArray.get("param");
			 */
    		JSONObject jObj = new JSONObject();
    		jObj = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
    		
    		String checklist_id = jObj.get("checklist_id").toString();
    		String regist_date = jObj.get("regist_date").toString();
    		
    		String sql = new StringBuilder()
    				.append("SELECT * \n")
    				.append("FROM\n")
    				.append("	haccp_process_management\n")
    				.append("	WHERE regist_date = '"+regist_date+"'\n")
    				.toString();
    		
    		resultString = super.excuteQueryString(con, sql);
    		
    		if(resultString.length() == 0) {
    			
    			sql = new StringBuilder()
    					.append("INSERT INTO\n")
    					.append("	haccp_process_management (\n")
    					.append("		regist_date,\n")
    					.append("		checklist_id,\n")
    					.append("		checklist_rev_no,\n")
    					.append("		unsuit_detail,\n")
    					.append("		improve_action,\n")
    					.append("		person_write_id\n")
    					.append("	)\n")
    					.append("VALUES\n")
    					.append("	(\n")
    					.append("		'"+regist_date+"',\n")
    					.append("		'"+checklist_id+"',\n")
        				.append("    	(SELECT MAX(checklist_rev_no)				 \n")
        				.append("    	FROM checklist								 \n")
        				.append("    	WHERE checklist_id = '"+checklist_id+"'),	 \n")
        				.append("		'"+jObj.get("unsuit_detail").toString()+"',\n")
    					.append("		'"+jObj.get("improve_action").toString()+"',\n")
    					.append("		'"+jObj.get("person_write_id").toString()+"'\n")
    					.append("	) \n")
    					.toString();

    			resultInt = super.excuteUpdate(con, sql.toString());
		    	if(resultInt < 0){  //
					ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
					con.rollback();
					return EventDefine.E_DOEXCUTE_ERROR;
				}
				
    		}
    		
			sql = new StringBuilder()
					.append("INSERT INTO\n")
					.append("	haccp_process_management_detail (\n")
					.append("		regist_date,\n")
					.append("		ampm_gubun,\n")
					.append("		check_time,\n")			//
					.append("		temp_processing1,\n")	
					.append("		temp_processing2,\n")
					.append("		temp_packing,\n")
					.append("		temp_prod,\n")
					.append("		mixing_hour_yn,\n")		//
					.append("		clean_status_yn,\n")	
					.append("		appearance_yn,\n")
					.append("		packing_hour_yn,\n")
					.append("		packing_status_yn,\n")
					.append("		indication_comply_yn,\n")	//
					.append("		expiration_date_yn,\n")
					.append("		temp_defrosting,\n")
					.append("		defrosting_yn,\n")
					.append("		temp_frosting\n")
					.append("	)\n")
					.append("VALUES\n")
					.append("	(\n")
					.append("		'"+regist_date+"',\n")
    				.append("		CASE WHEN TO_CHAR('"+jObj.get("check_time").toString()+"','HH24MI') > TO_CHAR('12:00','HH24MI') THEN 'pm' ELSE 'am' END,\n")
    				.append("		TO_TIMESTAMP('"+jObj.get("regist_date").toString()+" "+jObj.get("check_time").toString()+"'),\n")				//
    				.append("		'"+jObj.get("temp_processing1").toString()+"',\n")
    				.append("		'"+jObj.get("temp_processing2").toString()+"',\n")
    				.append("		'"+jObj.get("temp_packing").toString()+"',\n")
    				.append("		'"+jObj.get("temp_prod").toString()+"',\n")
    				.append("		'"+jObj.get("mixing_hour_yn").toString()+"',\n")		//
    				.append("		'"+jObj.get("clean_status_yn").toString()+"',\n")
    				.append("		'"+jObj.get("appearance_yn").toString()+"',\n")
    				.append("		'"+jObj.get("packing_hour_yn").toString()+"',\n")
    				.append("		'"+jObj.get("packing_status_yn").toString()+"',\n")
    				.append("		'"+jObj.get("indication_comply_yn").toString()+"',\n")	//
    				.append("		'"+jObj.get("expiration_date_yn").toString()+"',\n")	
    				.append("		'"+jObj.get("temp_defrosting").toString()+"',\n")
    				.append("		'"+jObj.get("defrosting_yn").toString()+"',\n")
    				.append("		'"+jObj.get("temp_frosting").toString()+"'\n")
					.append("	) \n")
					.toString();

	    			resultInt = super.excuteUpdate(con, sql.toString());
			    	if(resultInt < 0){  //
						ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
						con.rollback();
						return EventDefine.E_DOEXCUTE_ERROR ;
					}
			
			con.commit();
		} catch(Exception e) {
			e.getStackTrace();
			LoggingWriter.setLogError("M838S020600E101()","==== SQL ERROR ===="+ e.getMessage());
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
	
	// 점검표 수정
	public int E102(InoutParameter ioParam){ 
		resultInt = EventDefine.E_DOEXCUTE_INIT;

		try {
			con = JDBCConnectionPool.getConnection();
			con.setAutoCommit(false);
			
    		JSONObject jObj = new JSONObject();
    		jObj = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
    		
    		String checklist_id = jObj.get("checklist_id").toString();
    		String regist_date = jObj.get("regist_date").toString();
    		String checklist_rev_no = jObj.get("checklist_rev_no").toString();
    		    		
    		String sql = new StringBuilder()
    				.append("UPDATE																\n")
    				.append("	haccp_process_management										\n")
    				.append("SET																\n")
    				.append("	unsuit_detail = '"+jObj.get("unsuit_detail").toString()+"',		\n")
    				.append("	improve_action = '"+jObj.get("improve_action").toString()+"',	\n")
    				.append("	person_write_id = '"+jObj.get("person_write_id").toString()+"',	\n")
    				.append("	person_check_id = '',	\n")
    				.append("	person_approve_id = ''	\n")
    				.append("WHERE																\n")
    				.append("	regist_date = '"+regist_date+"'									\n")
    				.append("	AND checklist_id = '"+checklist_id+"'							\n")
    				.append("	AND checklist_rev_no = '"+checklist_rev_no+"'					\n")
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
			LoggingWriter.setLogError("M838S020600E102()","==== SQL ERROR ===="+ e.getMessage());
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
    				.append("	haccp_process_management_detail					\n")
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
    				.append("	haccp_process_management \n")
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
			LoggingWriter.setLogError("M838S020600E103()","==== SQL ERROR ===="+ e.getMessage());
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
	
	// 점검표 메인 조회
	public int E104(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			System.out.println("JSONObject jArray rcvData="+ jArray.toString());
    		
			String sql = new StringBuilder()
					.append("SELECT  	 DISTINCT		 \n")
					.append("		  	 A.checklist_id, \n")
					.append("			 A.checklist_rev_no,\n")
					.append("			 A.regist_date,\n")
					.append("			 A.unsuit_detail,\n")
					.append("			 A.improve_action,\n")
					.append("			 C.user_nm AS person_write_id,\n")
					.append("			 D.user_nm AS person_check_id,\n")
					.append("			 E.user_nm AS person_approve_id\n")
					.append("FROM haccp_process_management A\n")
					.append("LEFT JOIN haccp_process_management_detail B\n")
					.append("		ON	A.regist_date = B.regist_date\n")
					.append("LEFT JOIN tbm_users C										\n")
					.append("		ON 	A.person_write_id = C.user_id						\n")
					.append("		AND  A.regist_date BETWEEN CAST(C.start_date AS DATE) AND CAST(C.duration_date AS DATE) \n")
					.append("LEFT JOIN tbm_users D										\n")
					.append("		ON 	A.person_check_id = D.user_id						\n")
					.append("		AND  A.regist_date BETWEEN CAST(D.start_date AS DATE) AND CAST(D.duration_date AS DATE) \n")
					.append("LEFT JOIN tbm_users E										\n")
					.append("		ON 	A.person_approve_id = E.user_id						\n")
					.append("		AND  A.regist_date BETWEEN CAST(E.start_date AS DATE) AND CAST(E.duration_date AS DATE)\n")
					.append("WHERE A.regist_date BETWEEN '"+ jArray.get("fromdate") + "' 	\n")  
					.append("                     AND '"+ jArray.get("todate") + "' 	\n")
					.append("ORDER BY A.regist_date DESC 	\n")
					.toString();

			String ActionCommand = ioParam.getActionCommand();
			if(ActionCommand.startsWith("doQueryTableFieldName")) {
				resultString = super.excuteQueryStringTableFieldName(con, sql.toString());
			}
			else {
				resultString = super.excuteQueryString(con, sql.toString());
			}
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M838S020600E104()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M838S020600E104()","==== finally ===="+ e.getMessage());
				}
	    	} else {
	    	}
	    }
	    // 결과 전문 구성을 위한 파라미터들을 아이오 파라미터에 저장한다.
		ioParam.setResultString(resultString);
		// 수퍼에서 처리된 칼럼의 갯수를 클라이언트에게 보내기 위해 가져온다.
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
		// 잘 처리되었다는 메시지를 클라이언트에게 보내기 위해 I/O파라미터에 저장한다.
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
    		
    		String sql = new StringBuilder()
    					.append("INSERT INTO\n")
    					.append("	haccp_process_management_detail (\n")
    					.append("		regist_date,\n")
    					.append("		ampm_gubun,\n")
    					.append("		check_time,\n")			
    					.append("		temp_processing1,\n")	
    					.append("		temp_processing2,\n")
    					.append("		temp_packing,\n")
    					.append("		temp_prod,\n")
    					.append("		mixing_hour_yn,\n")		
    					.append("		clean_status_yn,\n")	
    					.append("		appearance_yn,\n")
    					.append("		packing_hour_yn,\n")
    					.append("		packing_status_yn,\n")
    					.append("		indication_comply_yn,\n")	
    					.append("		expiration_date_yn,\n")
    					.append("		temp_defrosting,\n")
    					.append("		defrosting_yn,\n")
    					.append("		temp_frosting\n")
    					.append("	)\n")
    					.append("VALUES\n")
    					.append("	(\n")
    					.append("		'"+regist_date+"',\n")
        				.append("		CASE WHEN TO_CHAR('"+jObj.get("check_time").toString()+"','HH24MI') > TO_CHAR('12:00','HH24MI') THEN 'pm' ELSE 'am' END,\n")
        				.append("		TO_TIMESTAMP('"+jObj.get("regist_date").toString()+" "+jObj.get("check_time").toString()+"'),\n")				
        				.append("		'"+jObj.get("temp_processing1").toString()+"',\n")
        				.append("		'"+jObj.get("temp_processing2").toString()+"',\n")
        				.append("		'"+jObj.get("temp_packing").toString()+"',\n")
        				.append("		'"+jObj.get("temp_prod").toString()+"',\n")
        				.append("		'"+jObj.get("mixing_hour_yn").toString()+"',\n")		
        				.append("		'"+jObj.get("clean_status_yn").toString()+"',\n")
        				.append("		'"+jObj.get("appearance_yn").toString()+"',\n")
        				.append("		'"+jObj.get("packing_hour_yn").toString()+"',\n")
        				.append("		'"+jObj.get("packing_status_yn").toString()+"',\n")
        				.append("		'"+jObj.get("indication_comply_yn").toString()+"',\n")	
        				.append("		'"+jObj.get("expiration_date_yn").toString()+"',\n")	
        				.append("		'"+jObj.get("temp_defrosting").toString()+"',\n")
        				.append("		'"+jObj.get("defrosting_yn").toString()+"',\n")
        				.append("		'"+jObj.get("temp_frosting").toString()+"'\n")
    					.append("	) \n")
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
			LoggingWriter.setLogError("M838S020600E111()","==== SQL ERROR ===="+ e.getMessage());
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
    		
    		String sql = new StringBuilder()
    				.append("DELETE FROM												\n")
    				.append("	haccp_process_management_detail							\n")
    				.append("WHERE														\n")
    				.append("		 seq_no = '"+jObj.get("seq_no").toString()+"'		\n")
    				.toString();
    				
    		resultInt = super.excuteUpdate(con, sql);
	    	if(resultInt < 0) {
				ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
				con.rollback();
				return EventDefine.E_DOEXCUTE_ERROR ;
			}
    		
	    	sql = new StringBuilder()
					.append("INSERT INTO\n")
					.append("	haccp_process_management_detail (\n")
					.append("		regist_date,\n")
					.append("		ampm_gubun,\n")
					.append("		check_time,\n")			
					.append("		temp_processing1,\n")	
					.append("		temp_processing2,\n")
					.append("		temp_packing,\n")
					.append("		temp_prod,\n")
					.append("		mixing_hour_yn,\n")		
					.append("		clean_status_yn,\n")	
					.append("		appearance_yn,\n")
					.append("		packing_hour_yn,\n")
					.append("		packing_status_yn,\n")
					.append("		indication_comply_yn,\n")	
					.append("		expiration_date_yn,\n")
					.append("		temp_defrosting,\n")
					.append("		defrosting_yn,\n")
					.append("		temp_frosting\n")
					.append("	)\n")
					.append("VALUES\n")
					.append("	(\n")
					.append("		'"+regist_date+"',\n")
    				.append("		CASE WHEN TO_CHAR('"+jObj.get("check_time").toString()+"','HH24MI') > TO_CHAR('12:00','HH24MI') THEN 'pm' ELSE 'am' END,\n")
    				.append("		TO_TIMESTAMP('"+jObj.get("regist_date").toString()+" "+jObj.get("check_time").toString()+"'),\n")			//	
    				.append("		'"+jObj.get("temp_processing1").toString()+"',\n")
    				.append("		'"+jObj.get("temp_processing2").toString()+"',\n")
    				.append("		'"+jObj.get("temp_packing").toString()+"',\n")
    				.append("		'"+jObj.get("temp_prod").toString()+"',\n")
    				.append("		'"+jObj.get("mixing_hour_yn").toString()+"',\n")		//
    				.append("		'"+jObj.get("clean_status_yn").toString()+"',\n")
    				.append("		'"+jObj.get("appearance_yn").toString()+"',\n")
    				.append("		'"+jObj.get("packing_hour_yn").toString()+"',\n")
    				.append("		'"+jObj.get("packing_status_yn").toString()+"',\n")
    				.append("		'"+jObj.get("indication_comply_yn").toString()+"',\n")	//
    				.append("		'"+jObj.get("expiration_date_yn").toString()+"',\n")	
    				.append("		'"+jObj.get("temp_defrosting").toString()+"',\n")
    				.append("		'"+jObj.get("defrosting_yn").toString()+"',\n")
    				.append("		'"+jObj.get("temp_frosting").toString()+"'\n")
					.append("	) \n")
					.toString();

			resultInt = super.excuteUpdate(con, sql.toString());
	    	if(resultInt < 0){  //
				ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
				con.rollback();
				return EventDefine.E_DOEXCUTE_ERROR ;
			}
	    	
	    	sql = new StringBuilder()
	    			.append("UPDATE haccp_process_management 						\n")
	    			.append("SET 	person_check_id='', person_approve_id='' 	\n")
	    			.append("WHERE  regist_date='"+regist_date+"'				\n")
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
			LoggingWriter.setLogError("M838S020600E112()","==== SQL ERROR ===="+ e.getMessage());
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
    		
    		String seq_no = jObj.get("seq_no").toString();
    		
    		String sql = new StringBuilder()
    				.append("DELETE FROM							\n")
    				.append("	haccp_process_management_detail		\n")
    				.append("WHERE									\n")
    				.append("		 seq_no = '"+seq_no+"'			\n")
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
			LoggingWriter.setLogError("M838S020600E113()","==== SQL ERROR ===="+ e.getMessage());
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
	
	// 서브테이블 조회
	public int E114(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));

			String sql = new StringBuilder()
					.append("SELECT\n")
					.append("	seq_no,\n")
					.append("	regist_date,\n")
					.append("	ampm_gubun,\n")
					.append("	TO_CHAR(check_time,'YY/MM/DD HH24:MI') as checkTime,\n")
					.append("	temp_processing1,\n")
					.append("	temp_processing2,\n")
					.append("	temp_packing,\n")
					.append("	temp_prod,\n")
					.append("	temp_defrosting,\n")
					.append("	temp_frosting\n")
					.append("FROM\n")
					.append("	haccp_process_management_detail\n")
					.append("WHERE\n")
					.append("	regist_date = '"+jArray.get("regist_date")+"'\n")
					.append("ORDER BY seq_no DESC \n")
					.toString();
						
			resultString = super.excuteQueryString(con, sql);
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M838S020600E114()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) {
						con.close();
					}
				} catch (Exception e) {
					LoggingWriter.setLogError("M838S020600E114()","==== finally ===="+ e.getMessage());
				}
	    	}
	    }

		ioParam.setResultString(resultString);
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
    	ioParam.setMessage(MessageDefine.M_QUERY_OK);

    	return EventDefine.E_QUERY_RESULT;
	}
	
	// 온도 값 가져오기
	public int E124(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));

			String sql = new StringBuilder()
					.append("SELECT\n")
					.append("	D.censor_no,\n")
					.append("	D.censor_rev_no,\n")
					.append("	censor_date,\n")
					.append("	MIN(censor_data_create_time),\n")
					.append("	censor_value0\n")
					.append("FROM\n")
					.append("	haccp_censor_data D\n")
					.append("	JOIN haccp_censor_info I\n")
					.append("	ON D.censor_no = I.censor_no\n")
					.append("WHERE censor_date = '"+jArray.get("check_date").toString()+"'\n")
					.append("	AND ABS(TIME '"+jArray.get("check_time").toString()+"' - censor_data_create_time) \n")
					.append("			IN (SELECT MIN(ABS(TIME'"+jArray.get("check_time").toString()+"' - censor_data_create_time)) \n")
					.append("				FROM haccp_censor_data\n")
					.append("				WHERE censor_date = '"+jArray.get("check_date").toString()+"'\n")
					.append("				GROUP BY censor_no)\n")
					.append("GROUP BY D.censor_no\n")
					.append("HAVING I.censor_type = 'TEMPERATURE'\n")
					.append("ORDER BY D.censor_no ASC\n")
					.toString();

			resultString = super.excuteQueryString(con, sql);
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M838S020600E124()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) {
						con.close();
					}
				} catch (Exception e) {
					LoggingWriter.setLogError("M838S020600E124()","==== finally ===="+ e.getMessage());
				}
	    	}
	    }

		ioParam.setResultString(resultString);
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
    	ioParam.setMessage(MessageDefine.M_QUERY_OK);

    	return EventDefine.E_QUERY_RESULT;
	}
	
	
	// 점검표 조회
	public int E144(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			System.out.println("JSONObject jArray rcvData="+ jArray.toString());
    		
			String sql = new StringBuilder()
					.append("SELECT  A.checklist_id,           			 				\n")
					.append("			 A.checklist_rev_no,           					\n")
					.append("			 A.regist_date,           						\n")
					.append("			 TO_CHAR(A.regist_date, 'YY') AS YY,           	\n")
					.append(" 			 TO_CHAR(A.regist_date, 'MM') AS MM,           	\n")
					.append(" 			 TO_CHAR(A.regist_date, 'DD') AS DD,           	\n")
					.append("			 B.ampm_gubun,           						\n")
					.append("			 TO_CHAR(B.check_time, 'YYYY-MM-DD HH24:MI') AS check_time,           \n")
					.append(" 			 TO_CHAR(B.check_time, 'HH24:MI') AS cktime,    \n")
					.append(" 			 TO_CHAR(B.check_time, 'HH24') AS HH,           \n")
					.append(" 			 TO_CHAR(B.check_time, 'MI') AS MI,           	\n")
					.append("			 B.temp_processing1,           					\n")
					.append("			 B.temp_processing2,        				    \n")
					.append("			 B.temp_packing,       						    \n")
					.append("			 B.temp_prod,         						  	\n")
					.append("			 B.mixing_hour_yn,   				       		\n")
					.append("			 B.clean_status_yn,     				      	\n")
					.append("			 B.appearance_yn,          					 	\n")
					.append("			 B.packing_hour_yn,      						\n")
					.append("			 B.packing_status_yn,       				    \n")
					.append("			 B.indication_comply_yn,  				        \n")
					.append("			 B.expiration_date_yn,  				        \n")
					.append("			 B.temp_defrosting,          					\n")
					.append("			 B.defrosting_yn,         						\n")
					.append("			 B.temp_frosting,   					        \n")
					.append("			 A.unsuit_detail,   					        \n")
					.append("			 A.improve_action,   					        \n")
					.append("			 C.user_nm AS person_write_id,     			    \n")
					.append("			 D.user_nm AS person_check_id,     		      	\n")
					.append("			 E.user_nm AS person_approve_id 	            \n")
					.append("FROM haccp_process_management A           					\n")
					.append("LEFT JOIN haccp_process_management_detail B           		\n")
					.append("		ON	A.regist_date = B.regist_date           		\n")
					.append("LEFT JOIN tbm_users C										\n")
					.append("		ON 	A.person_write_id = C.user_id					\n")
					.append("		AND  A.regist_date BETWEEN CAST(C.start_date AS DATE) AND CAST(C.duration_date AS DATE) \n")
					.append("LEFT JOIN tbm_users D										\n")
					.append("		ON 	A.person_check_id = D.user_id					\n")
					.append("		AND  A.regist_date BETWEEN CAST(D.start_date AS DATE) AND CAST(D.duration_date AS DATE) \n")
					.append("LEFT JOIN tbm_users E										\n")
					.append("		ON 	A.person_approve_id = E.user_id					\n")
					.append("		AND  A.regist_date BETWEEN CAST(E.start_date AS DATE) AND CAST(E.duration_date AS DATE)	\n")
					.append("WHERE A.regist_date = '"+jArray.get("regist_date").toString()+"'							  	\n")
					.append("ORDER BY 	ampm_gubun ASC						  			\n")
					.toString();


			String ActionCommand = ioParam.getActionCommand();
			if(ActionCommand.startsWith("doQueryTableFieldName")) {
				resultString = super.excuteQueryStringTableFieldName(con, sql.toString());
			}
			else {
				resultString = super.excuteQueryString(con, sql.toString());
			}
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M838S020600E144()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M838S020600E144()","==== finally ===="+ e.getMessage());
				}
	    	} else {
	    	}
	    }
	    // 결과 전문 구성을 위한 파라미터들을 아이오 파라미터에 저장한다.
		ioParam.setResultString(resultString);
		// 수퍼에서 처리된 칼럼의 갯수를 클라이언트에게 보내기 위해 가져온다.
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
		// 잘 처리되었다는 메시지를 클라이언트에게 보내기 위해 I/O파라미터에 저장한다.
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
					.append("	seq_no,\n")
					.append("	D.regist_date,\n")
					.append("	ampm_gubun,\n")
					.append("	CASE WHEN ampm_gubun = 'am' THEN '오전' ELSE '오후' END AS 오전오후,\n")
					.append("	TO_CHAR(check_time,'YY/MM/DD HH24:MI') as check_time,\n")
					.append("	TO_CHAR(check_time,'HH24:MI') AS timezz,\n")
					.append("	temp_processing1,\n")
					.append("	temp_processing2,\n")
					.append("	temp_packing,\n")
					.append("	temp_prod,\n")
					.append("	mixing_hour_yn,\n")
					.append("	clean_status_yn,\n")
					.append("	appearance_yn,\n")
					.append("	packing_hour_yn,\n")
					.append("	packing_status_yn,\n")
					.append("	indication_comply_yn,\n")
					.append("	expiration_date_yn,\n")
					.append("	temp_defrosting,\n")
					.append("	defrosting_yn,\n")
					.append("	temp_frosting\n")
					.append("FROM\n")
					.append("	haccp_process_management_detail D JOIN haccp_process_management M \n")
					.append("	ON D.regist_date = M.regist_date \n")
					.append("WHERE\n")
					.append("	seq_no = '"+jArray.get("seq_no")+"'\n")
					.toString();

			
			resultString = super.excuteQueryString(con, sql);
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M838S020600E154()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) {
						con.close();
					}
				} catch (Exception e) {
					LoggingWriter.setLogError("M838S020600E154()","==== finally ===="+ e.getMessage());
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
    				.append("UPDATE haccp_process_management								\n")
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
			LoggingWriter.setLogError("M838S020600E502()","==== SQL ERROR ===="+ e.getMessage());
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
    				.append("UPDATE haccp_process_management								\n")
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
			LoggingWriter.setLogError("M838S020600E522()","==== SQL ERROR ===="+ e.getMessage());
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