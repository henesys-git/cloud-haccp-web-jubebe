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
public class M838S020400 extends SqlAdapter{
	
	static final Logger logger = Logger.getLogger(M838S020400.class.getName());
	
	Connection con = null;
	PreparedStatement pstmt = null;
	String resultString = "";
	int resultInt = -1;
	StringBuffer sql = new StringBuffer();
	
	String[][] v_paramArray = new String[0][0]; 
	Class[] optClass = null;
	Object[] optObj = null;
	Object obj = null;
	
	public M838S020400(){
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
			
			Method method = M838S020400.class.getMethod(event,optClass);
			logger.debug(event + " EventMethod Create Success");

			obj = method.invoke(M838S020400.class.newInstance(),optObj);
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
    		String regist_date = jObj.get("regist_date").toString();
    		
    		String sql = new StringBuilder()
    				.append("INSERT INTO										\n")
    				.append("	haccp_insect (									\n")
    				.append("		regist_date,								\n")
    				.append("		checklist_id,								\n")
    				.append("		checklist_rev_no,							\n")
    				.append("		person_write_id								\n")
    				.append(") VALUES (											\n")
    				.append("		'"+regist_date+"',							\n")
    				.append("		'"+checklist_id+"',							\n")
    				.append("		(SELECT MAX(checklist_rev_no)				\n")
    				.append("		FROM checklist								\n")
    				.append("		WHERE checklist_id = '"+checklist_id+"'),	\n")
    				.append("		'"+jObj.get("person_write_id")+"'			\n")
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
    		
    		JSONArray position = new JSONArray();
    		position = (JSONArray) jObj.get("position");
    		
    		int cnt = 0;
    		
	    	logger.debug("just before loop");
	    	for(int i = 0; i < data.size(); i++) {
	    		logger.debug("##loop entered!");
	    		logger.debug(data);
	    		
	    		JSONObject result = (JSONObject) data.get(i);
	    		
				String facility_id = result.get("facility_id").toString();
				String insect_id = result.get("insect_id").toString(); 
				String value = result.get("value").toString().trim();
				
				sql = new StringBuilder()
						.append("INSERT INTO										\n")
						.append("	haccp_insect_result (							\n")
						.append("		regist_date,								\n")
						.append("		facility_id,								\n")
						.append("		facility_rev_no,							\n")
						.append("		insect_id,									\n")
						.append("    	insect_count								\n")
						.append("	)												\n")
						.append("VALUES												\n")
						.append("	(												\n")
						.append("		'"+regist_date+"',							\n")
						.append("		'"+facility_id+"',							\n")
						.append("		(SELECT MAX(facility_rev_no)				\n")
						.append("		 FROM haccp_insect_facility					\n")
						.append("		 WHERE facility_id = '"+facility_id+"'),	\n")
						.append("		'"+insect_id+"',							\n")
						.append("        "+value+"									\n")
						.append("	)\n")
						.toString();
				
				resultInt = super.excuteUpdate(con, sql);
				if(resultInt < 0) {
					ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
					con.rollback();
					return EventDefine.E_DOEXCUTE_ERROR;
				}
				
				if(position.size() > 0) {
				
					if(Integer.parseInt(facility_id.substring(8)) >= 7) {
												
						sql = new StringBuilder()
								.append("UPDATE haccp_insect_result 						\n")
								.append("  SET facility_position = '"+position.get(cnt)+"'	\n")
								.append("WHERE												\n")
								.append("		regist_date = '"+regist_date+"' AND			\n")
								.append("		facility_id = '"+facility_id+"' AND			\n")
								.append("		insect_id = '"+insect_id+"'					\n")
								.toString();
						
						resultInt = super.excuteUpdate(con, sql);
						if(resultInt < 0) {
							ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
							con.rollback();
							return EventDefine.E_DOEXCUTE_ERROR;
						}
						
						cnt++;
						
					}

				} // position
								
	    	}
	    	
	    	if(!"false".equals(jObj.get("detail").toString())) {
	    		
	    		data = (JSONArray) jObj.get("detail");
	    		
	    		if(data.size() > 0) {
		    		
		    		logger.debug("just before loop2");
			    	ArrayList<String> valuearr = new ArrayList<String>();
			    	for(int i = 0; i < data.size(); i++) {
			    		logger.debug("##loop2 entered!");
			    		logger.debug(data);
			    		
			    		JSONObject detail = (JSONObject) data.get(i);
			    		
						String value = detail.get("value").toString();
						valuearr.add(value);
						
						if((i+1)%4==0) {
							
							sql = new StringBuilder()
									.append("INSERT INTO										\n")
									.append("	haccp_insect_detail (							\n")
									.append("		regist_date,								\n")
									.append("		unsuit_place,								\n")
									.append("		standard_unsuit,							\n")
									.append("		improve_action,								\n")
									.append("    	action_result								\n")
									.append("	)												\n")
									.append("VALUES												\n")
									.append("	(												\n")
									.append("		'"+regist_date+"',							\n")
		    						.append("		'"+valuearr.get(0)+"',						\n")
		    						.append("		'"+valuearr.get(1)+"',						\n")
		    						.append("		'"+valuearr.get(2)+"',						\n")
		    						.append("		'"+valuearr.get(3)+"'						\n")
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
		    		
		    	}
	    	}

			con.commit();
		} catch(Exception e) {
			e.getStackTrace();
			LoggingWriter.setLogError("M838S020400E101()","==== SQL ERROR ===="+ e.getMessage());
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
    				.append("DELETE FROM\n")
    				.append("	haccp_insect_result \n")
    				.append("WHERE\n")
    				.append("	regist_date = '"+regist_date+"'\n")
    				.toString();
    		
    		resultInt = super.excuteUpdate(con, sql);
	    	if(resultInt < 0) {
				ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
				con.rollback();
				return EventDefine.E_DOEXCUTE_ERROR ;
			}
	    	
	    	sql = new StringBuilder()
    				.append("DELETE FROM\n")
    				.append("	haccp_insect_detail \n")
    				.append("WHERE\n")
    				.append("	regist_date = '"+regist_date+"'\n")
    				.toString();
    		
    		resultInt = super.excuteUpdate(con, sql);
	    	if(resultInt < 0) {
				ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
				con.rollback();
				return EventDefine.E_DOEXCUTE_ERROR ;
			}
    		
	    	JSONArray data = new JSONArray();
    		data = (JSONArray) jObj.get("result");
    		
    		JSONArray position = new JSONArray();
    		position = (JSONArray) jObj.get("position");
    		
    		int cnt = 0;
    		
	    	logger.debug("just before loop");
	    	for(int i = 0; i < data.size(); i++) {
	    		logger.debug("##loop entered!");
	    		logger.debug(data);
	    		
	    		JSONObject result = (JSONObject) data.get(i);
	    		
				String facility_id = result.get("facility_id").toString();
				String insect_id = result.get("insect_id").toString(); 
				String value = result.get("value").toString().trim();
				
				sql = new StringBuilder()
						.append("INSERT INTO										\n")
						.append("	haccp_insect_result (							\n")
						.append("		regist_date,								\n")
						.append("		facility_id,								\n")
						.append("		facility_rev_no,							\n")
						.append("		insect_id,									\n")
						.append("    	insect_count								\n")
						.append("	)												\n")
						.append("VALUES												\n")
						.append("	(												\n")
						.append("		'"+regist_date+"',							\n")
						.append("		'"+facility_id+"',							\n")
						.append("		(SELECT MAX(facility_rev_no)				\n")
						.append("		 FROM haccp_insect_facility					\n")
						.append("		 WHERE facility_id = '"+facility_id+"'),	\n")
						.append("		'"+insect_id+"',							\n")
						.append("        "+value+"									\n")
						.append("	)\n")
						.toString();
				
				resultInt = super.excuteUpdate(con, sql);
				if(resultInt < 0) {
					ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
					con.rollback();
					return EventDefine.E_DOEXCUTE_ERROR;
				}
				
				if(position.size() > 0) {
				
					if(Integer.parseInt(facility_id.substring(8)) >= 7) {
						
						sql = new StringBuilder()
								.append("UPDATE haccp_insect_result 						\n")
								.append("  SET facility_position = '"+position.get(cnt)+"'	\n")
								.append("WHERE												\n")
								.append("		regist_date = '"+regist_date+"' AND			\n")
								.append("		facility_id = '"+facility_id+"' AND			\n")
								.append("		insect_id = '"+insect_id+"'					\n")
								.toString();
						
						resultInt = super.excuteUpdate(con, sql);
						if(resultInt < 0) {
							ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
							con.rollback();
							return EventDefine.E_DOEXCUTE_ERROR;
						}
						
						cnt++;
						
					}

				} // position
								
	    	}
	    	
	    	if(!"false".equals(jObj.get("detail").toString())) {
	    		
	    		data = (JSONArray) jObj.get("detail");
	    		
	    		if(data.size() > 0) {
		    		
		    		logger.debug("just before loop2");
			    	ArrayList<String> valuearr = new ArrayList<String>();
			    	for(int i = 0; i < data.size(); i++) {
			    		logger.debug("##loop2 entered!");
			    		logger.debug(data);
			    		
			    		JSONObject detail = (JSONObject) data.get(i);
			    		
						String value = detail.get("value").toString();
						valuearr.add(value);
						
						if((i+1)%4==0) {
							
							sql = new StringBuilder()
									.append("INSERT INTO										\n")
									.append("	haccp_insect_detail (							\n")
									.append("		regist_date,								\n")
									.append("		unsuit_place,								\n")
									.append("		standard_unsuit,							\n")
									.append("		improve_action,								\n")
									.append("    	action_result								\n")
									.append("	)												\n")
									.append("VALUES												\n")
									.append("	(												\n")
									.append("		'"+regist_date+"',							\n")
		    						.append("		'"+valuearr.get(0)+"',						\n")
		    						.append("		'"+valuearr.get(1)+"',						\n")
		    						.append("		'"+valuearr.get(2)+"',						\n")
		    						.append("		'"+valuearr.get(3)+"'						\n")
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
		    		
		    	}
	    	
	    	}
	    	
	    	sql = new StringBuilder()
    				.append("UPDATE haccp_insect \n")
    				.append("	SET person_check_id = '',\n")
    				.append("	    person_approve_id = ''\n")
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
			LoggingWriter.setLogError("M838S020400E102()","==== SQL ERROR ===="+ e.getMessage());
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
    		String regist_date = jObj.get("regist_date").toString();
    		
    		String sql = new StringBuilder()
    				.append("DELETE FROM\n")
    				.append("	haccp_insect_detail \n")
    				.append("WHERE\n")
    				.append("	regist_date = '"+regist_date+"'\n")
    				.toString();
    		
    		resultInt = super.excuteUpdate(con, sql);
	    	if(resultInt < 0) {
				ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
				con.rollback();
				return EventDefine.E_DOEXCUTE_ERROR ;
			}
	    	
	    	sql = new StringBuilder()
    				.append("DELETE FROM\n")
    				.append("	haccp_insect_result\n")
    				.append("WHERE\n")
    				.append("	regist_date = '"+regist_date+"'\n")
    				.toString();
    		
    		resultInt = super.excuteUpdate(con, sql);
	    	if(resultInt < 0) {
				ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
				con.rollback();
				return EventDefine.E_DOEXCUTE_ERROR ;
			}
	    	
	    	sql = new StringBuilder()
    				.append("DELETE FROM\n")
    				.append("	haccp_insect\n")
    				.append("WHERE\n")
    				.append("	regist_date = '"+regist_date+"'\n")
    				.append("	AND checklist_id = '"+checklist_id+"'\n")
    				.append("	AND checklist_rev_no = "+checklist_rev_no+"\n")
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
			LoggingWriter.setLogError("M838S020400E103()","==== SQL ERROR ===="+ e.getMessage());
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
					.append("	B.user_nm AS person_write,								\n")
					.append("	C.user_nm AS person_check,								\n")
					.append("	D.user_nm AS person_approve								\n")
					.append("FROM haccp_insect A										\n")
					.append("LEFT JOIN tbm_users B										\n")
					.append("ON A.person_write_id = B.user_id							\n")
					.append("AND  A.regist_date BETWEEN CAST(B.start_date AS DATE) AND CAST(B.duration_date AS DATE) \n")
					.append("LEFT JOIN tbm_users C										\n")
					.append("ON A.person_check_id = C.user_id							\n")
					.append("AND  A.regist_date BETWEEN CAST(C.start_date AS DATE) AND CAST(C.duration_date AS DATE) \n")
					.append("LEFT JOIN tbm_users D										\n")
					.append("ON A.person_approve_id = D.user_id							\n")
					.append("AND  A.regist_date BETWEEN CAST(D.start_date AS DATE) AND CAST(D.duration_date AS DATE) \n")
					.append("WHERE regist_date BETWEEN '"+ jArray.get("fromdate") + "' 	\n")
					.append("                     AND '"+ jArray.get("todate") + "' 	\n")
					.append("ORDER BY regist_date DESC									\n")
					.toString();

			resultString = super.excuteQueryString(con, sql);
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M838S020400E104()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) {
						con.close();
					}
				} catch (Exception e) {
					LoggingWriter.setLogError("M838S020400E104()","==== finally ===="+ e.getMessage());
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
    		
    		String sql = new StringBuilder()
					.append("INSERT INTO										\n")
					.append("	haccp_insect_detail (							\n")
					.append("		regist_date,								\n")
					.append("		unsuit_place,								\n")
					.append("		standard_unsuit,							\n")
					.append("		improve_action,								\n")
					.append("    	action_result								\n")
					.append("	)												\n")
					.append("VALUES												\n")
					.append("	(												\n")
					.append("		'"+regist_date+"',							\n")
					.append("		'"+jObj.get("unsuit_place").toString()+"',	\n")
					.append("		'"+jObj.get("standard_unsuit").toString()+"',\n")
					.append("		'"+jObj.get("improve_action").toString()+"',\n")
					.append("		'"+jObj.get("action_result").toString()+"'	\n")
					.append("	)\n")
					.toString();
			
			resultInt = super.excuteUpdate(con, sql);
			if(resultInt < 0) {
				ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
				con.rollback();
				return EventDefine.E_DOEXCUTE_ERROR;
			}
    			
			con.commit();
		} catch(Exception e) {
			e.getStackTrace();
			LoggingWriter.setLogError("M838S020400E111()","==== SQL ERROR ===="+ e.getMessage());
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
    		String seq_no = jObj.get("seq_no").toString();

    		String sql = new StringBuilder()
    				.append("UPDATE\n")
    				.append("	haccp_insect_detail\n")
    				.append("SET\n")
    				.append("	unsuit_place = '"+jObj.get("unsuit_place").toString()+"',\n")
    				.append("	standard_unsuit = '"+jObj.get("standard_unsuit").toString()+"',\n")
    				.append("	improve_action = '"+jObj.get("improve_action").toString()+"',\n")
    				.append("	action_result = '"+jObj.get("action_result").toString()+"'\n")
    				.append("WHERE\n")
    				.append("	regist_date = '"+regist_date+"'\n")
    				.append("	AND seq_no = '"+seq_no+"'\n")
    				.toString();
    		
			resultInt = super.excuteUpdate(con, sql);
			
			if(resultInt < 0) {
				ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
				con.rollback();
				return EventDefine.E_DOEXCUTE_ERROR;
			}
			
			 sql = new StringBuilder()
	    				.append("UPDATE\n")
	    				.append("	haccp_insect\n")
	    				.append("SET\n")
	    				.append("	person_check_id = '',\n")
	    				.append("	person_approve_id = ''\n")
	    				.append("WHERE\n")
	    				.append("	regist_date = '"+regist_date+"'\n")
	    				.toString();
			 
			resultInt = super.excuteUpdate(con, sql);
			
			if(resultInt < 0) {
				ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
				con.rollback();
				return EventDefine.E_DOEXCUTE_ERROR;
			}	
			
			con.commit();
		} catch(Exception e) {
			e.getStackTrace();
			LoggingWriter.setLogError("M838S020400E112()","==== SQL ERROR ===="+ e.getMessage());
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
    				.append("	haccp_insect_detail		\n")
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
			LoggingWriter.setLogError("M838S020400E113()","==== SQL ERROR ===="+ e.getMessage());
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
					.append("	regist_date,\n")
					.append("	seq_no,\n")
					.append("	unsuit_place,\n")
					.append("	standard_unsuit,\n")
					.append("	improve_action,\n")
					.append("	action_result\n")
					.append("FROM\n")
					.append("	haccp_insect_detail\n")
					.append("WHERE\n")
					.append("	regist_date = '"+jArray.get("regist_date").toString()+"'\n")
					.append("ORDER BY seq_no ASC \n")
					.toString();

			resultString = super.excuteQueryString(con, sql);
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M838S020400E114()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) {
						con.close();
					}
				} catch (Exception e) {
					LoggingWriter.setLogError("M838S020400E114()","==== finally ===="+ e.getMessage());
				}
	    	}
	    }

		ioParam.setResultString(resultString);
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
    	ioParam.setMessage(MessageDefine.M_QUERY_OK);

    	return EventDefine.E_QUERY_RESULT;
	}

/*	
	// 점검표 캔버스 조회용 쿼리
	public int E144(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			
			String checkDate = jArray.get("checklistDate").toString();
			
			String sql = new StringBuilder()
					.append("SELECT 												\n")
					.append("	A.regist_date,										\n")
					.append("	A.check_point,										\n")
					.append("	A.standard_unsuit,									\n")
					.append("	A.improve_action,									\n")
					.append("	C.user_nm AS person_write,							\n")
					.append("	D.user_nm AS person_approve,						\n")
					.append("   B.insect_count,										\n")
					.append("   E.facility_position									\n")
					.append("FROM haccp_insect A									\n")
					.append("INNER JOIN haccp_insect_detail B						\n")
					.append("	ON A.regist_date = B.regist_date						\n")
					.append("	AND A.checklist_id = B.checklist_id					\n")
					.append("	AND A.checklist_rev_no = B.checklist_rev_no			\n")
					.append("INNER JOIN haccp_insect_facility E						\n")
					.append("   ON B.facility_id = E.facility_id 					\n")
					.append("   AND B.facility_rev_no = E.facility_rev_no 			\n")
					.append("LEFT JOIN tbm_users C									\n")
					.append("ON A.person_write_id = C.user_id						\n")
					.append("AND  A.regist_date BETWEEN CAST(C.start_date AS DATE) AND CAST(C.duration_date AS DATE) \n")
					.append("LEFT JOIN tbm_users D									\n")
					.append("ON A.person_approve_id = D.user_id						\n")
					.append("AND  A.regist_date BETWEEN CAST(D.start_date AS DATE) AND CAST(D.duration_date AS DATE) \n")
					.append("WHERE A.regist_date = '"+checkDate+"'					\n")
					.toString();
			
			resultString = super.excuteQueryString(con, sql);
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M838S020400E144()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M838S020400E144()","==== finally ===="+ e.getMessage());
				}
	    	} else {
	    	}
	    }
		ioParam.setResultString(resultString);
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
    	ioParam.setMessage(MessageDefine.M_QUERY_OK);

    	return EventDefine.E_QUERY_RESULT;
	}
*/	
	// 수정 시 기존 데이터 넣기 위한 쿼리 & 점검표 쿼리
	public int E144(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			
			String regist_date = jArray.get("regist_date").toString();
			
			String sql = new StringBuilder()
					.append("SELECT DISTINCT\n")
					.append("	checklist_id,\n")
					.append("	checklist_rev_no,\n")
					.append("	A.regist_date,\n")
					.append("	LIST(\n")
					.append("		SELECT\n")
					.append("			GROUP_CONCAT(insect_count) || ',' || SUM(insect_count)\n")
					.append("		FROM\n")
					.append("			haccp_insect_result B2 JOIN haccp_insect_info BI\n")
					.append("			ON B2.insect_id = BI.insect_id\n")
					.append("		GROUP BY B2.regist_date, facility_id, insect_type\n")
					.append("		HAVING B2.regist_date = A.regist_date\n")
					.append("		ORDER BY facility_id, insect_type\n")
					.append("	) AS results,	\n")
					.append("	LIST(\n")
					.append("		SELECT\n")
					.append("			R.facility_position\n")
					.append("		FROM\n")
					.append("			haccp_insect_result R\n")
					.append("		WHERE R.regist_date = A.regist_date AND R.facility_position IS NOT NULL\n")
					.append("		ORDER BY R.facility_id\n")
					.append("	) AS positions,\n")
					.append("	LIST(\n")
					.append("		SELECT\n")
					.append("			unsuit_place,\n")
					.append("			standard_unsuit,\n")
					.append("			improve_action,\n")
					.append("			action_result\n")
					.append("		FROM\n")
					.append("			haccp_insect_detail B3\n")
					.append("		WHERE B3.regist_date = B.regist_date\n")
					.append("		ORDER BY seq_no ASC \n")
					.append("	) AS details,\n")
					.append("	C.user_nm AS person_write_id,\n")
					.append("	D.user_nm AS person_check_id,\n")
					.append("	E.user_nm AS 	person_approve_id\n")
					.append("FROM\n")
					.append("	haccp_insect A \n")
					.append("	JOIN haccp_insect_result B \n")
					.append("		ON A.regist_date = B.regist_date\n")
					.append("	LEFT JOIN tbm_users C										\n")
					.append("		ON A.person_write_id = C.user_id						\n")
					.append("		AND  A.regist_date BETWEEN CAST(C.start_date AS DATE) AND CAST(C.duration_date AS DATE) \n")
					.append("	LEFT JOIN tbm_users D										\n")
					.append("		ON person_check_id = D.user_id							\n")
					.append("		AND  A.regist_date BETWEEN CAST(D.start_date AS DATE) AND CAST(D.duration_date AS DATE) \n")
					.append("	LEFT JOIN tbm_users E										\n")
					.append("		ON person_approve_id = E.user_id						\n")
					.append("		AND  A.regist_date BETWEEN CAST(E.start_date AS DATE) AND CAST(E.duration_date AS DATE) \n")
					.append("WHERE\n")
					.append("	A.regist_date = '"+regist_date+"'\n")
					.toString();
			
			resultString = super.excuteQueryString(con, sql);
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M838S020400E144()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M838S020400E144()","==== finally ===="+ e.getMessage());
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
    				.append("UPDATE haccp_insect											\n")
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
			LoggingWriter.setLogError("M838S020400E502()","==== SQL ERROR ===="+ e.getMessage());
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
    				.append("UPDATE haccp_insect											\n")
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
			LoggingWriter.setLogError("M838S020400E522()","==== SQL ERROR ===="+ e.getMessage());
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