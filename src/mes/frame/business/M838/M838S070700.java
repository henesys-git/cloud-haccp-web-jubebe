package mes.frame.business.M838;

import java.lang.reflect.Method;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.util.ArrayList;

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

/**
 * 개요 : 이벤트ID별 메소드 정의
 */
public class M838S070700 extends SqlAdapter {
	
	static final Logger logger = Logger.getLogger(M838S070700.class.getName());
	
	Connection con = null;
	PreparedStatement pstmt = null;
	String resultString = "";
	int resultInt = -1;
	StringBuffer sql = new StringBuffer();
	
	String[][] v_paramArray = new String[0][0]; 
	Class[] optClass = null;
	Object[] optObj = null;
	Object obj = null;
	
	public M838S070700(){
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
			
			Method method = M838S070700.class.getMethod(event,optClass);
			logger.debug(event + " EventMethod Create Success");

			obj = method.invoke(M838S070700.class.newInstance(),optObj);
			doExcute_result = CommonFunction.getInt(obj.toString());
			
	    } catch (Exception ex) {
	    	doExcute_result = EventDefine.E_DOEXCUTE_INIT;
			ioParam.setMessage(MessageDefine.M_NO_EVENTID);
			logger.debug("EventID Not define : EVENT ID [ " + ioParam.getEventID() + "]");
	    } finally {
	    	obj = null;
			optClass = null;
			optObj = null;
	    }
	    long endTime = System.currentTimeMillis();
		long runningTime = endTime - startTime;
		logger.debug("Query [수행시간  : " + runningTime + " ms]");
		
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
    		int cnt = 0;
    		
    		JSONObject input = (JSONObject) jObj.get("input");

    		String sql = new StringBuilder()
    				.append("SELECT regist_seq_no\n")
    				.append("FROM haccp_meat\n")
    				.append("ORDER BY regist_seq_no DESC FOR ORDERBY_NUM()  = 1\n")
    				.toString();

    		resultString = excuteQueryString(con, sql.toString());
    		
    		if(resultString.length() > 0) {
    			
    			regist_seq_no = resultString.trim();
    			
    			sql = new StringBuilder()
    					.append("SELECT COUNT(seq_no)\n")
    					.append("FROM haccp_meat_detail\n")
    					.append("WHERE regist_seq_no = "+regist_seq_no+"\n")
    					.toString();

    			resultString = excuteQueryString(con, sql.toString());
    			
    			if(resultString.length() > 0) {
    				cnt = Integer.parseInt(resultString.trim());
    				
    				logger.debug("카운트 개수 : " + cnt);
    			}
    			
    		}
    		
    		if(resultString.length() == 0 || cnt == 3) {
    			
    			sql = new StringBuilder()
    					.append("INSERT INTO\n")
    					.append("	haccp_meat (\n")
    					.append("		checklist_id,\n")
    					.append("		checklist_rev_no\n")
    					.append("	)\n")
    					.append("VALUES\n")
    					.append("	(\n")
    					.append("		'"+checklist_id+"',\n")
        				.append("		(SELECT MAX(checklist_rev_no) 				\n")
        				.append("		 FROM checklist								\n")
        				.append("		 WHERE checklist_id = '"+ checklist_id +"')\n")
    					.append("	)\n")
    					.toString();

        		resultInt = super.excuteUpdate(con, sql);
    	    	if(resultInt < 0) {
    				ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
    				con.rollback();
    				return EventDefine.E_DOEXCUTE_ERROR ;
    			}
    			
    	    	sql = new StringBuilder()
        				.append("SELECT regist_seq_no\n")
        				.append("FROM haccp_meat\n")
        				.append("ORDER BY regist_seq_no DESC FOR ORDERBY_NUM()  = 1\n")
        				.toString();

        		resultString = excuteQueryString(con, sql.toString());
        		
        		regist_seq_no = resultString.trim();
    	    	
    		}
    		
    		sql = new StringBuilder()
    				.append("INSERT INTO\n")
    				.append("	haccp_meat_detail (\n")
    				.append("		regist_seq_no,\n")
    				.append("		check_date,\n")
    				.append("		balju_no,\n")
    				.append("		part_cd,\n")
    				.append("		cust_nm,\n")
    				.append("		part_nm,\n")
    				.append("		part_origin,\n")
    				.append("		keep_way,\n")
    				.append("		ipgo_amount,\n")
    				.append("		check_amount,\n")
    				.append("		ipgo_start_time,\n")
    				.append("		ipgo_complete_time,\n")
    				.append("		color_yn,\n")
    				.append("		foreign_matter_yn,\n")
    				.append("		smell_yn,\n")
    				.append("		destroy_yn,\n")
    				.append("		meat_juice_yn,\n")
    				.append("		temp_part,\n")
    				.append("		temp_car,\n")
    				.append("		document1_yn,\n")
    				.append("		document2_yn,\n")
    				.append("		result,\n")
    				.append("		unsuit_detail,\n")
    				.append("		improve_action,\n")
    				.append("		person_write_id\n")
    				.append("	)\n")
    				.append("VALUES\n")
    				.append("	(\n")
    				.append("		"+regist_seq_no+",\n")
    				.append(" 		'"	+ input.get("check_date").toString() + "',		\n")
    				.append(" 		'"	+ jObj.get("balju_no").toString() + "',		\n")
    				.append(" 		'"	+ jObj.get("part_cd").toString() + "',		\n")
    				.append(" 		'"	+ input.get("cust_nm").toString() + "',		\n")
    				.append(" 		'"	+ input.get("part_nm").toString() + "',		\n")
    				.append(" 		'"	+ input.get("part_origin").toString() + "',		\n")
    				.append(" 		'"	+ input.get("keep_way").toString()+ "',		\n")
    				.append(" 		'"	+ input.get("ipgo_amount").toString() + "',		\n")
    				.append(" 		'"	+ input.get("check_amount").toString() + "',		\n")
    				.append(" 		'"	+ input.get("ipgo_start_time").toString() + "',		\n")
    				.append(" 		'"	+ input.get("ipgo_complete_time").toString() + "',		\n")
    				.append(" 		'"	+ input.get("color_yn").toString() + "',		\n")
    				.append(" 		'"	+ input.get("foreign_matter_yn").toString() + "',		\n")
    				.append(" 		'"	+ input.get("smell_yn").toString() + "',		\n")
    				.append(" 		'"	+ input.get("destroy_yn").toString() + "',		\n")
    				.append(" 		'"	+ input.get("meat_juice_yn").toString() + "',		\n")
    				.append(" 		'"	+ input.get("temp_part").toString() + "',		\n")
    				.append(" 		'"	+ input.get("temp_car").toString() + "',		\n")
    				.append(" 		'"	+ input.get("document1_yn").toString() + "',		\n")
    				.append(" 		'"	+ input.get("document2_yn").toString() + "',		\n")
    				.append(" 		'"	+ input.get("result").toString() + "',		\n")
    				.append(" 		'"	+ input.get("unsuit_detail").toString() + "',		\n")
    				.append(" 		'"	+ input.get("improve_action").toString() + "',		\n")
    				.append(" 		'"	+ jObj.get("person_write_id").toString() + "'		\n")
    				.append("	)\n")
    				.toString();

    		resultInt = super.excuteUpdate(con, sql);
	    	if(resultInt < 0) {
				ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
				con.rollback();
				return EventDefine.E_DOEXCUTE_ERROR ;
			}

	    	// 입고검사완료
	    	sql = new StringBuilder()
	    			.append("UPDATE\n")
	    			.append("	tbi_balju_list2\n")
	    			.append("SET\n")
	    			.append("	doc_regist_yn = 'Y'\n")
	    			.append("WHERE\n")
	    			.append("	part_cd = '"+jObj.get("part_cd").toString()+"'\n")
	    			.append("	AND balju_no = '"+jObj.get("balju_no").toString()+"'\n")
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
			LoggingWriter.setLogError("M838S070700E101()","==== SQL ERROR ===="+ e.getMessage());
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
    		
    		String seq_no = jObj.get("seq_no").toString();
    		
    		JSONObject input = (JSONObject) jObj.get("input");
    		
    		String sql = new StringBuilder()
    				.append("UPDATE\n")
    				.append("	haccp_meat_detail\n")
    				.append("SET\n")
    				.append("	ipgo_amount = '"+input.get("ipgo_amount").toString()+"',\n")
    				.append("	check_amount = '"+input.get("check_amount").toString()+"',\n")
    				.append("	ipgo_start_time = '"+input.get("ipgo_start_time").toString()+"',\n")
    				.append("	ipgo_complete_time = '"+input.get("ipgo_complete_time").toString()+"',\n")
    				.append("	color_yn = '"+input.get("color_yn").toString()+"',\n")
    				.append("	foreign_matter_yn = '"+input.get("foreign_matter_yn").toString()+"',\n")
    				.append("	smell_yn = '"+input.get("smell_yn").toString()+"',\n")
    				.append("	destroy_yn = '"+input.get("destroy_yn").toString()+"',\n")
    				.append("	meat_juice_yn = '"+input.get("meat_juice_yn").toString()+"',\n")
    				.append("	temp_part = '"+input.get("temp_part").toString()+"',\n")
    				.append("	temp_car = '"+input.get("temp_car").toString()+"',\n")
    				.append("	document1_yn = '"+input.get("document1_yn").toString()+"',\n")
    				.append("	document2_yn = '"+input.get("document2_yn").toString()+"',\n")
    				.append("	result = '"+input.get("result").toString()+"',\n")
    				.append("	unsuit_detail = '"+input.get("unsuit_detail").toString()+"',\n")
    				.append("	improve_action = '"+input.get("improve_action").toString()+"',\n")
    				.append("	person_write_id = '"+jObj.get("person_write_id").toString()+"',\n")
    				.append("	person_check_id = '',\n")
    				.append("	person_approve_id = ''\n")
    				.append("WHERE\n")
    				.append("	seq_no = "+seq_no+"\n")
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
			LoggingWriter.setLogError("M838S070700E102()","==== SQL ERROR ===="+ e.getMessage());
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
    		
    		String seq_no = jObj.get("seq_no").toString();
    		
    		String sql = new StringBuilder()
    				.append("DELETE FROM\n")
    				.append("	haccp_meat_detail \n")
    				.append("WHERE\n")
    				.append("	seq_no = '"+seq_no+"'\n")
    				.toString();
    		
    		resultInt = super.excuteUpdate(con, sql);
	    	if(resultInt < 0) {
				ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
				con.rollback();
				return EventDefine.E_DOEXCUTE_ERROR ;
			}
	    	
	    	// 입고검사삭제 - N
	    	sql = new StringBuilder()
	    			.append("UPDATE\n")
	    			.append("	tbi_balju_list2\n")
	    			.append("SET\n")
	    			.append("	doc_regist_yn = 'N'\n")
	    			.append("WHERE\n")
	    			.append("	part_cd = '"+jObj.get("part_cd").toString()+"'\n")
	    			.append("	AND balju_no = '"+jObj.get("balju_no").toString()+"'\n")
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
			LoggingWriter.setLogError("M838S070700E103()","==== SQL ERROR ===="+ e.getMessage());
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
					.append("	A2.check_date,											\n")
					.append("	seq_no,													\n")
					.append("	A.regist_seq_no,										\n")
					.append("	balju_no,												\n")
					.append("	part_cd,												\n")
					.append("	cust_nm,												\n")
					.append("	part_nm,												\n")
					.append("	part_origin,											\n")
					.append("	keep_way,												\n")
					.append("	B.user_nm AS person_write,								\n")
					.append("	C.user_nm AS person_check,								\n")
					.append("	D.user_nm AS person_approve								\n")
					.append("FROM haccp_meat A											\n")
					.append("JOIN haccp_meat_detail A2									\n")
					.append("	ON A.regist_seq_no = A2.regist_seq_no					\n")
					.append("LEFT JOIN tbm_users B										\n")
					.append("	ON A2.person_write_id = B.user_id						\n")
					.append("	AND A2.check_date BETWEEN CAST(B.start_date AS DATE) AND CAST(B.duration_date AS DATE) \n")
					.append("LEFT JOIN tbm_users C										\n")
					.append("	ON A2.person_check_id = C.user_id						\n")
					.append("	AND A2.check_date BETWEEN CAST(C.start_date AS DATE) AND CAST(C.duration_date AS DATE) \n")
					.append("LEFT JOIN tbm_users D										\n")
					.append("	ON A2.person_approve_id = D.user_id						\n")
					.append("	AND A2.check_date BETWEEN CAST(D.start_date AS DATE) AND CAST(D.duration_date AS DATE)\n")
					.append("WHERE check_date BETWEEN '"+ jArray.get("fromdate") + "' 	\n")
					.append("                     AND '"+ jArray.get("todate") + "' 	\n")
					.append("ORDER BY check_date DESC, seq_no DESC						\n")
					.toString();

			resultString = super.excuteQueryString(con, sql);
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M838S070700E104()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) {
						con.close();
					}
				} catch (Exception e) {
					LoggingWriter.setLogError("M838S070700E104()","==== finally ===="+ e.getMessage());
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
    				.append("	seq_no\n")
    				.append("FROM\n")
    				.append("	haccp_meat_detail\n")
    				.append("ORDER BY seq_no DESC FOR ORDERBY_NUM()  = 1\n")
    				.toString();

			resultString = super.excuteQueryString(con, sql.toString());
    		
			sql = new StringBuilder()
					.append("UPDATE haccp_meat_detail		  			  \n")
					.append("   SET file_name = '"+c_paramArray[0][10]+"',\n")	//file_view_name
					.append("   	file_path = '"+c_paramArray[0][11]+"',\n")	//file_path
					.append("   	regist_no = '"+c_paramArray[0][19]+"' \n")	//regist_no
					.append(" WHERE seq_no = "+resultString.trim()+"	  \n")
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
			LoggingWriter.setLogError("M838S070700E111()","==== SQL ERROR ===="+ e.getMessage());
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
					.append("UPDATE haccp_meat_detail					\n")
					.append("   SET file_name = '"+c_paramArray[0][10]+"',\n")	//file_view_name
					.append("   	file_path = '"+c_paramArray[0][11].replaceAll("//", "/")+"',\n")	//file_path
					.append("   	file_rev_no = '"+c_paramArray[0][8]+"',\n")	//file_rev_no
					.append("   	regist_no = '"+c_paramArray[0][18]+"'\n")	//regist_no
					.append(" WHERE seq_no = "+c_paramArray[0][24]+"\n")
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
			LoggingWriter.setLogError("M838S070700E112()","==== SQL ERROR ===="+ e.getMessage());
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
					.append("UPDATE haccp_meat_detail				\n")
					.append("   SET file_name = '',\n")	//file_view_name
					.append("   	file_path = ''\n")	//file_path
					.append(" WHERE seq_no = "+jArray.get("seq_no").toString()+"\n")
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
			LoggingWriter.setLogError("M838S070700E113()","==== SQL ERROR ===="+ e.getMessage());
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
		
	// 상세 테이블 조회
	public int E114(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));

			String sql = new StringBuilder()
					.append("SELECT\n")
					.append("	ipgo_amount,\n")
					.append("	check_amount,\n")
					.append("	TO_CHAR(ipgo_start_time, 'HH24:MI'),\n")
					.append("	TO_CHAR(ipgo_complete_time, 'HH24:MI'),\n")
					.append("	result,\n")
					.append("	unsuit_detail,\n")
					.append("	improve_action,				\n")
					.append("	regist_no,						\n")
					.append("	file_name,						\n")
					.append("	file_path,						\n")
					.append("	file_rev_no						\n")
					.append("FROM haccp_meat A	\n")
					.append("JOIN haccp_meat_detail A2\n")
					.append("	ON A.regist_seq_no = A2.regist_seq_no\n")
					.append("WHERE\n")
					.append("	 seq_no = '"+jArray.get("seq_no").toString()+"'\n")
					.toString();
			
			resultString = super.excuteQueryString(con, sql);
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M838S070700E114()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) {
						con.close();
					}
				} catch (Exception e) {
					LoggingWriter.setLogError("M838S070700E114()","==== finally ===="+ e.getMessage());
				}
	    	}
	    }

		ioParam.setResultString(resultString);
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
    	ioParam.setMessage(MessageDefine.M_QUERY_OK);

    	return EventDefine.E_QUERY_RESULT;
	}

	// 점검표 쿼리
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
					.append("	M.regist_seq_no,\n")
					.append("	seq_no,\n")
					.append("	check_date,\n")
					.append("	cust_nm,\n")
					.append("	part_nm,\n")
					.append("	part_origin,\n")
					.append("	keep_way,\n")
					.append("	ipgo_amount,\n")
					.append("	check_amount,\n")
					.append("	TO_CHAR(ipgo_start_time, 'HH24:MI'),\n")
					.append("	TO_CHAR(ipgo_complete_time, 'HH24:MI'),\n")
					.append("	color_yn,\n")
					.append("	foreign_matter_yn,\n")
					.append("	smell_yn,\n")
					.append("	destroy_yn,\n")
					.append("	meat_juice_yn,\n")
					.append("	temp_part,\n")
					.append("	temp_car,\n")
					.append("	document1_yn,\n")
					.append("	document2_yn,\n")
					.append("	result,\n")
					.append("	unsuit_detail,\n")
					.append("	improve_action,\n")
					.append("	B.user_nm AS person_write_id,\n")
					.append("	C.user_nm AS person_check_id,\n")
					.append("	D.user_nm AS person_approve_id\n")
					.append("FROM\n")
					.append("	haccp_meat M JOIN haccp_meat_detail M2\n")
					.append("	ON M.regist_seq_no = M2.regist_seq_no\n")
					.append("	LEFT JOIN tbm_users B										\n")
					.append("	ON M2.person_write_id = B.user_id						\n")
					.append("	AND M2.check_date BETWEEN CAST(B.start_date AS DATE) AND CAST(B.duration_date AS DATE) \n")
					.append("	LEFT JOIN tbm_users C										\n")
					.append("	ON M2.person_check_id = C.user_id						\n")
					.append("	AND M2.check_date BETWEEN CAST(C.start_date AS DATE) AND CAST(C.duration_date AS DATE) \n")
					.append("	LEFT JOIN tbm_users D										\n")
					.append("	ON M2.person_approve_id = D.user_id						\n")
					.append("	AND M2.check_date BETWEEN CAST(D.start_date AS DATE) AND CAST(D.duration_date AS DATE)\n")
					.append("WHERE\n")
					.append("	M.regist_seq_no = "+regist_seq_no+"\n")
					.append("ORDER BY seq_no ASC \n")
					.toString();

			resultString = super.excuteQueryString(con, sql);
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M838S070700E144()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M838S070700E144()","==== finally ===="+ e.getMessage());
				}
	    	} else {
	    	}
	    }
		ioParam.setResultString(resultString);
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
    	ioParam.setMessage(MessageDefine.M_QUERY_OK);

    	return EventDefine.E_QUERY_RESULT;
	}
	
	// 수정 시 기존 데이터 넣기 위한 쿼리
	public int E154(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			
			String seq_no = jArray.get("seq_no").toString();
			
			String sql = new StringBuilder()
					.append("SELECT\n")
					.append("	checklist_id,\n")
					.append("	checklist_rev_no,\n")
					.append("	M.regist_seq_no,\n")
					.append("	seq_no,\n")
					.append("	check_date,\n")
					.append("	cust_nm,\n")
					.append("	part_nm,\n")
					.append("	part_origin,\n")
					.append("	keep_way,\n")
					.append("	ipgo_amount,\n")
					.append("	check_amount,\n")
					.append("	TO_CHAR(ipgo_start_time, 'HH24:MI'),\n")
					.append("	TO_CHAR(ipgo_complete_time, 'HH24:MI'),\n")
					.append("	color_yn,\n")
					.append("	foreign_matter_yn,\n")
					.append("	smell_yn,\n")
					.append("	destroy_yn,\n")
					.append("	meat_juice_yn,\n")
					.append("	document1_yn,\n")
					.append("	document2_yn,\n")
					.append("	temp_part,\n")
					.append("	temp_car,\n")
					.append("	result,\n")
					.append("	unsuit_detail,\n")
					.append("	improve_action,\n")
					.append("	regist_no,						\n")
					.append("	file_name,						\n")
					.append("	file_path,						\n")
					.append("	file_rev_no						\n")
					.append("FROM\n")
					.append("	haccp_meat M JOIN haccp_meat_detail M2\n")
					.append("	ON M.regist_seq_no = M2.regist_seq_no\n")
					.append("WHERE\n")
					.append("	seq_no = "+seq_no+"\n")
					.toString();

			resultString = super.excuteQueryString(con, sql);
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M838S070700E144()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M838S070700E144()","==== finally ===="+ e.getMessage());
				}
	    	} else {
	    	}
	    }
		ioParam.setResultString(resultString);
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
    	ioParam.setMessage(MessageDefine.M_QUERY_OK);

    	return EventDefine.E_QUERY_RESULT;
	}
	
	// 등록할때 데이터 가져오기
	public int E164(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			
			String balju_no = jArray.get("balju_no").toString();
			String part_cd = jArray.get("part_cd").toString();
			
			String sql = new StringBuilder()
					.append("SELECT\n")
					.append("	B.balju_no,\n")
					.append("	B.balju_rev_no,\n")
					.append("	B.trace_key,\n")
					.append("	B.balju_status,\n")
					.append("	B.balju_send_date,\n")
					.append("	B.balju_nabgi_date,\n")
					.append("	B.note,\n")
					.append("	B.cust_cd,\n")
					.append("	B.cust_rev_no,\n")
					.append("	B.delyn,\n")
					.append("	B2.part_cd,\n")
					.append("	B2.part_rev_no,\n")
					.append("	B2.balju_amt,\n")
					.append("	B2.balju_status,\n")
					.append("	B2.doc_regist_yn,\n")
					.append("	C.cust_nm AS 거래처,\n")
					.append("	P.part_nm AS 제품명,\n")
					.append("	P.wonsanji AS 원산지,\n")
					.append("	P2.code_name AS 보관방법,\n")
					.append("	I.ipgo_date AS 입고날짜,\n")
					.append("	I.ipgo_time AS 입고시간,\n")
					.append("	TO_NUMBER(I.ipgo_amount) AS 입고수량,\n")
					.append("	I.seq_no AS 입고일련번호\n")
					.append("FROM\n")
					.append("	tbi_balju2 B JOIN tbi_balju_list2 B2\n")
					.append("	ON B.balju_no = B2.balju_no\n")
					.append("	JOIN tbm_customer C\n")
					.append("	ON B.cust_cd = C.cust_cd\n")
					.append("	JOIN tbm_part_list P\n")
					.append("	ON B2.part_cd = P.part_cd\n")
					.append("	JOIN tbm_part_code_book P2\n")
					.append("	ON P.part_gubun_m = P2.code_value\n")
					.append("	LEFT JOIN tbi_part_ipgo2 I\n")
					.append("	ON B.trace_key = I.trace_key\n")
					.append("WHERE\n")
					.append("	B.balju_no = '"+balju_no+"' \n")
					.append("	AND B2.part_cd = '"+part_cd+"' \n")
					.append("	AND I.ipgo_type = '정상입고'\n")
					.append("	-- 	AND I.ipgo_type = 'PART_IPGO_TYPE001'\n") // 서승헌이거 수정해야함
					.toString();

			resultString = super.excuteQueryString(con, sql);
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M838S070700E164()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M838S070700E164()","==== finally ===="+ e.getMessage());
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
    				.append("UPDATE haccp_meat_detail										\n")
    				.append("SET															\n")
    				.append("	person_approve_id = '" + jObj.get("userId") + "'			\n")
    				.append("WHERE check_date = '"+ jObj.get("checklistDate") + "'			\n")
    				.append("  AND seq_no = '"+ jObj.get("seq_no") + "'						\n")
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
			LoggingWriter.setLogError("M838S070700E502()","==== SQL ERROR ===="+ e.getMessage());
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
    				.append("UPDATE haccp_meat_detail										\n")
    				.append("SET															\n")
    				.append("	person_check_id = '" + jObj.get("userId") + "'				\n")
    				.append("WHERE check_date = '"+ jObj.get("checklistDate") + "'			\n")
    				.append("  AND seq_no = '"+ jObj.get("seq_no") + "'						\n")
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
			LoggingWriter.setLogError("M838S070700E522()","==== SQL ERROR ===="+ e.getMessage());
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