package mes.frame.business.M838;

import java.lang.reflect.Method;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.util.ArrayList;

import org.apache.log4j.Logger;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;

import mes.client.conf.Config;
import mes.frame.business.M707.M707S010600;
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
public class M838S070750 extends SqlAdapter {
	
	static final Logger logger = Logger.getLogger(M838S070750.class.getName());
	
	Connection con = null;
	PreparedStatement pstmt = null;
	String resultString = "";
	int resultInt = -1;
	StringBuffer sql = new StringBuffer();
	
	String[][] v_paramArray = new String[0][0]; 
	Class[] optClass = null;
	Object[] optObj = null;
	Object obj = null;
	
	public M838S070750(){
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
			
			Method method = M838S070750.class.getMethod(event,optClass);
			logger.debug(event + " EventMethod Create Success");

			obj = method.invoke(M838S070750.class.newInstance(),optObj);
			doExcute_result = CommonFunction.getInt(obj.toString());
			
	    } catch (Exception ex) {
	    	doExcute_result = EventDefine.E_DOEXCUTE_INIT;
			ioParam.setMessage(MessageDefine.M_NO_EVENTID);
			logger.error("EventID Not define : EVENT ID [ " + ioParam.getEventID() + "]");
	    } finally {
	    	obj = null;
			optClass = null;
			optObj = null;
	    }
	    long endTime = System.currentTimeMillis();
		long runningTime = endTime - startTime;
		logger.debug("Query 수행시간  : " + runningTime + " ms");
		
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
    				.append("INSERT INTO										\n")
    				.append("	haccp_microbe (									\n")
    				.append("		check_date,									\n")
    				.append("		checklist_id,								\n")
    				.append("		checklist_rev_no,							\n")
    				.append("		judge_date									\n")
    				.append(") VALUES (											\n")
    				.append("		'"+check_date+"',							\n")
    				.append("		'"+checklist_id+"',							\n")
    				.append("		(SELECT MAX(checklist_rev_no)				\n")
    				.append("		FROM checklist								\n")
    				.append("		WHERE checklist_id = '"+checklist_id+"'),	\n")
    				.append("		'"+jObj.get("judge_date")+"'				\n")
    				.append(");													\n")
    				.toString();
    		
    		resultInt = super.excuteUpdate(con, sql);
	    	if(resultInt < 0) {
				ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
				con.rollback();
				return EventDefine.E_DOEXCUTE_ERROR ;
			}

    		JSONArray data = new JSONArray();
    		data = (JSONArray) jObj.get("result");
    		// type_id, specimen_nm, status_gubun, result1, result2, result3, evaluation -- 7

    		ArrayList<String> valuearr = new ArrayList<String>();
    		
	    	logger.debug("just before loop");
	    	for(int i = 1; i <= data.size(); i++) {
	    		logger.debug("##loop entered!");
	    		logger.debug(data);
	    		
	    		JSONObject result = (JSONObject) data.get(i-1);
	    		
				String value = result.get("value").toString().trim();
				valuearr.add(value);
				
				if(i % 7 == 0) {
					
					sql = new StringBuilder()
							.append("INSERT INTO									\n")
							.append("	haccp_microbe_detail (						\n")
							.append("		check_date,								\n")
							.append("		type_id,								\n")
							.append("		specimen_nm,							\n")
							.append("		status_gubun,							\n")
							.append("    	result1,								\n")
							.append("    	result2,								\n")
							.append("    	result3,								\n")
							.append("    	evaluation								\n")
							.append("	)											\n")
							.append("VALUES											\n")
							.append("	(											\n")
							.append("		'"+check_date+"',						\n")
							.append("		'"+valuearr.get(0)+"',					\n")
							.append("		'"+valuearr.get(1)+"',					\n")
							.append("		'"+valuearr.get(2)+"',					\n")
							.append("		'"+valuearr.get(3)+"',					\n")
							.append("		'"+valuearr.get(4)+"',					\n")
							.append("		'"+valuearr.get(5)+"',					\n")
							.append("		'"+valuearr.get(6)+"'					\n")
							.append("	)\n")
							.toString();
					
					resultInt = super.excuteUpdate(con, sql);
					if(resultInt < 0) {
						ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
						con.rollback();
						return EventDefine.E_DOEXCUTE_ERROR;
					}
				
					valuearr = new ArrayList<String>();
					
				}
				
	    	}
			con.commit();
		} catch(Exception e) {
			e.getStackTrace();
			LoggingWriter.setLogError("M838S070750E101()","==== SQL ERROR ===="+ e.getMessage());
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
    		
    		String check_date = jObj.get("check_date").toString();
    		
    		String sql = new StringBuilder()
    				.append("DELETE FROM\n")
    				.append("	haccp_microbe_detail \n")
    				.append("WHERE\n")
    				.append("	check_date = '"+check_date+"'\n")
    				.toString();
    		
    		resultInt = super.excuteUpdate(con, sql);
	    	if(resultInt < 0) {
				ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
				con.rollback();
				return EventDefine.E_DOEXCUTE_ERROR ;
			}
	    	
	    	JSONArray data = new JSONArray();
    		data = (JSONArray) jObj.get("result");
    		// type_id, specimen_nm, status_gubun, result1, result2, result3, evaluation -- 7

    		ArrayList<String> valuearr = new ArrayList<String>();
    		
	    	logger.debug("just before loop");
	    	for(int i = 1; i <= data.size(); i++) {
	    		logger.debug("##loop entered!");
	    		logger.debug(data);
	    		
	    		JSONObject result = (JSONObject) data.get(i-1);
	    		
				String value = result.get("value").toString().trim();
				valuearr.add(value);
				
				if(i % 7 == 0) {
					
					sql = new StringBuilder()
							.append("INSERT INTO									\n")
							.append("	haccp_microbe_detail (						\n")
							.append("		check_date,								\n")
							.append("		type_id,								\n")
							.append("		specimen_nm,							\n")
							.append("		status_gubun,							\n")
							.append("    	result1,								\n")
							.append("    	result2,								\n")
							.append("    	result3,								\n")
							.append("    	evaluation								\n")
							.append("	)											\n")
							.append("VALUES											\n")
							.append("	(											\n")
							.append("		'"+check_date+"',						\n")
							.append("		'"+valuearr.get(0)+"',					\n")
							.append("		'"+valuearr.get(1)+"',					\n")
							.append("		'"+valuearr.get(2)+"',					\n")
							.append("		'"+valuearr.get(3)+"',					\n")
							.append("		'"+valuearr.get(4)+"',					\n")
							.append("		'"+valuearr.get(5)+"',					\n")
							.append("		'"+valuearr.get(6)+"'					\n")
							.append("	)\n")
							.toString();
					
					resultInt = super.excuteUpdate(con, sql);
					if(resultInt < 0) {
						ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
						con.rollback();
						return EventDefine.E_DOEXCUTE_ERROR;
					}
				
					valuearr = new ArrayList<String>();
					
				}
				
	    	}
	    	
	    	sql = new StringBuilder()
    				.append("UPDATE haccp_microbe \n")
    				.append("	SET person_check_id = '',\n")
    				.append("	    person_inspect_id = '',\n")
    				.append("	    person_approve_id = ''\n")
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
			LoggingWriter.setLogError("M838S070750E102()","==== SQL ERROR ===="+ e.getMessage());
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
    				.append("	haccp_microbe_detail \n")
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
    				.append("	haccp_microbe \n")
    				.append("WHERE\n")
    				.append("	check_date = '"+check_date+"'\n")
    				.append("	AND checklist_id = '"+checklist_id+"'\n")
    				.append("	AND checklist_rev_no = '"+checklist_rev_no+"'\n")
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
			LoggingWriter.setLogError("M838S070750E103()","==== SQL ERROR ===="+ e.getMessage());
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
					.append("	A.check_date,											\n")
					.append("	A.judge_date,											\n")
					.append("	B.user_nm AS person_check,								\n")
					.append("	C.user_nm AS person_inspect,							\n")
					.append("	D.user_nm AS person_approve,							\n")
					.append("	regist_no,\n")
					.append("	file_name,\n")
					.append("	file_path,\n")
					.append("	file_rev_no,\n")
					.append("	file_path\n")
					.append("FROM haccp_microbe A										\n")
					.append("LEFT JOIN tbm_users B										\n")
					.append("ON A.person_check_id = B.user_id							\n")
					.append("AND  A.check_date BETWEEN CAST(B.start_date AS DATE) AND CAST(B.duration_date AS DATE) \n")
					.append("LEFT JOIN tbm_users C										\n")
					.append("ON A.person_inspect_id = C.user_id							\n")
					.append("AND  A.check_date BETWEEN CAST(C.start_date AS DATE) AND CAST(C.duration_date AS DATE) \n")
					.append("LEFT JOIN tbm_users D										\n")
					.append("ON A.person_approve_id = D.user_id							\n")
					.append("AND  A.check_date BETWEEN CAST(D.start_date AS DATE) AND CAST(D.duration_date AS DATE) \n")
					.append("WHERE check_date BETWEEN '"+ jArray.get("fromdate") + "' 	\n")
					.append("                     AND '"+ jArray.get("todate") + "' 	\n")
					.append("ORDER BY check_date DESC									\n")
					.toString();

			resultString = super.excuteQueryString(con, sql);
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M838S070750E104()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) {
						con.close();
					}
				} catch (Exception e) {
					LoggingWriter.setLogError("M838S070750E104()","==== finally ===="+ e.getMessage());
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
			
			logger.debug(rcvData);
			logger.debug(c_paramArray);
			logger.debug(c_paramArray.toString());
			
    		String sql = new StringBuilder()
    				.append("SELECT\n")
    				.append("	check_date\n")
    				.append("FROM\n")
    				.append("	haccp_microbe\n")
    				.append("ORDER BY check_date DESC FOR ORDERBY_NUM() = 1\n")
    				.toString();

			resultString = super.excuteQueryString(con, sql.toString());
    		
			sql = new StringBuilder()
					.append("UPDATE haccp_microbe				  		  \n")
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
			LoggingWriter.setLogError("M838S070750E111()","==== SQL ERROR ===="+ e.getMessage());
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
					.append("UPDATE haccp_microbe							\n")
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
			LoggingWriter.setLogError("M838S070750E112()","==== SQL ERROR ===="+ e.getMessage());
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
	public int E123(InoutParameter ioParam){ 
		resultInt = EventDefine.E_DOEXCUTE_INIT;

		try {
			
			con = JDBCConnectionPool.getConnection();
			
    		JSONObject jArray = new JSONObject();
    		jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
    		logger.debug("JSONObject jArray rcvData="+ jArray.toString());
    		
			String sql = new StringBuilder()
					.append("UPDATE haccp_microbe					\n")
					.append("   SET file_name = '',\n")	//file_view_name
					.append("   	file_path = ''\n")	//file_path
					.append(" WHERE check_date = '"+jArray.get("check_date").toString()+"'\n")
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
			LoggingWriter.setLogError("M838S070750E123()","==== SQL ERROR ===="+ e.getMessage());
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
	
	// 상세 점검표 기록 삭제
	public int E113(InoutParameter ioParam){ 
		resultInt = EventDefine.E_DOEXCUTE_INIT;

		try {
			con = JDBCConnectionPool.getConnection();
			con.setAutoCommit(false);
			
    		JSONObject jObj = new JSONObject();
    		jObj = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
    		
    		String seq_no = jObj.get("seq_no").toString();
    		
    		String sql = new StringBuilder()
    				.append("DELETE FROM				\n")
    				.append("	haccp_microbe_detail	\n")
    				.append("WHERE						\n")
    				.append("	seq_no = '"+seq_no+"'	\n")
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
			LoggingWriter.setLogError("M838S070750E113()","==== SQL ERROR ===="+ e.getMessage());
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
					.append("SELECT\n")
					.append("	seq_no,\n")
					.append("	check_date,\n")
					.append("	A.type_id,\n")
					.append("	type_nm,\n")
					.append("	specimen_nm,\n")
					.append("	DECODE(status_gubun, '1', '냉장', '냉동') as status_gubun,\n")
					.append("	result1,\n")
					.append("	result2,\n")
					.append("	DECODE(result3, 'O', '검출', '불검출') as result3,\n")
					.append("	DECODE(evaluation, 'O', '적합', '부적합') as evaluation,\n")
					.append("	'<i class=\"fas fa-minus-circle seq_no_delete\"></i>'\n")
					.append("FROM\n")
					.append("	haccp_microbe_detail A\n")
					.append("	JOIN haccp_microbe_check_type B\n")
					.append("	ON A.type_id = B.type_id\n")
					.append("WHERE\n")
					.append("	check_date = '"+jArray.get("check_date").toString()+"'\n")
					.append("ORDER BY A.type_id DESC, seq_no ASC \n")
					.toString();

			resultString = super.excuteQueryString(con, sql);
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M838S070750E114()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) {
						con.close();
					}
				} catch (Exception e) {
					LoggingWriter.setLogError("M838S070750E114()","==== finally ===="+ e.getMessage());
				}
	    	}
	    }

		ioParam.setResultString(resultString);
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
    	ioParam.setMessage(MessageDefine.M_QUERY_OK);

    	return EventDefine.E_QUERY_RESULT;
	}

	// 수정 시 기존 데이터 넣기 위한 쿼리 & 점검표 쿼리
	public int E144(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			
			String check_date = jArray.get("check_date").toString();
			
			String sql = new StringBuilder()
					.append("SELECT				\n")
					.append("	A.checklist_id,											\n")
					.append("	A.checklist_rev_no,										\n")
					.append("	A.check_date,											\n")
					.append("	A.judge_date,\n")
					.append("	M.seq_no,\n")
					.append("	T.type_nm,\n")
					.append("	M.type_id,\n")
					.append("	M.specimen_nm,\n")
					.append("	M.status_gubun,\n")
					.append("	M.result1,\n")
					.append("	M.result2,\n")
					.append("	M.result3,\n")
					.append("	M.evaluation,\n")
					.append("	DECODE(M.status_gubun, '1', '냉장', '냉동') AS status_gubun,\n")
					.append("	DECODE(M.result3, 'O', '검출', '불검출') AS result3,\n")
					.append("	DECODE(M.evaluation, 'O', '적합', '부적합') AS evaluation,\n")
					.append("	TO_CHAR(A.check_date,'YY') AS checkYY,\n")
					.append("	TO_CHAR(A.check_date,'MM') AS checkMM,\n")
					.append("	TO_CHAR(A.check_date,'DD') AS checkDD,\n")
					.append("	B.user_nm AS person_check,								\n")
					.append("	TO_CHAR(A.judge_date,'YY') AS judgeYY,\n")
					.append("	TO_CHAR(A.judge_date,'MM') AS judgeMM,\n")
					.append("	TO_CHAR(A.judge_date,'DD') AS judgeDD,\n")
					.append("	C.user_nm AS person_inspect,							\n")
					.append("	D.user_nm AS person_approve,							\n")
					.append("	regist_no,\n")
					.append("	file_name,\n")
					.append("	file_path,\n")
					.append("	file_rev_no\n")
					.append("FROM haccp_microbe A \n")
					.append("JOIN haccp_microbe_detail M\n")
					.append("ON A.check_date = M.check_date\n")
					.append("JOIN haccp_microbe_check_type T\n")
					.append("ON M.type_id = T.type_id\n")
					.append("LEFT JOIN tbm_users B										\n")
					.append("ON A.person_check_id = B.user_id							\n")
					.append("AND  A.check_date BETWEEN CAST(B.start_date AS DATE) AND CAST(B.duration_date AS DATE) \n")
					.append("LEFT JOIN tbm_users C										\n")
					.append("ON A.person_inspect_id = C.user_id							\n")
					.append("AND  A.check_date BETWEEN CAST(C.start_date AS DATE) AND CAST(C.duration_date AS DATE) \n")
					.append("LEFT JOIN tbm_users D										\n")
					.append("ON A.person_approve_id = D.user_id							\n")
					.append("AND  A.check_date BETWEEN CAST(D.start_date AS DATE) AND CAST(D.duration_date AS DATE) \n")
					.append("WHERE A.check_date = '"+check_date+"' AND ROWNUM <= 12\n")
					.append("ORDER BY A.check_date DESC\n")
					.toString();


			resultString = super.excuteQueryString(con, sql);
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M838S070750E144()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M838S070750E144()","==== finally ===="+ e.getMessage());
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
    				.append("UPDATE haccp_microbe											\n")
    				.append("SET															\n")
    				.append("	person_approve_id = '" + jObj.get("userId") + "'			\n")
    				.append("WHERE check_date = '"+ jObj.get("checklistDate") + "'			\n")
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
			LoggingWriter.setLogError("M838S070750E502()","==== SQL ERROR ===="+ e.getMessage());
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
    				.append("UPDATE haccp_microbe											\n")
    				.append("SET															\n")
    				.append("	person_check_id = '" + jObj.get("userId") + "'				\n")
    				.append("WHERE check_date = '"+ jObj.get("checklistDate") + "'			\n")
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
			LoggingWriter.setLogError("M838S070750E522()","==== SQL ERROR ===="+ e.getMessage());
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
	public int E532(InoutParameter ioParam){ 
		
		resultInt = EventDefine.E_DOEXCUTE_INIT;

		try {
			con = JDBCConnectionPool.getConnection();
			con.setAutoCommit(false);
			
    		JSONObject jObj = new JSONObject();
    		jObj = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
    		
    		String sql = new StringBuilder()
    				.append("UPDATE haccp_microbe											\n")
    				.append("SET															\n")
    				.append("	person_inspect_id = '" + jObj.get("userId") + "'			\n")
    				.append("WHERE check_date = '"+ jObj.get("checklistDate") + "'			\n")
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
			LoggingWriter.setLogError("M838S070750E522()","==== SQL ERROR ===="+ e.getMessage());
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