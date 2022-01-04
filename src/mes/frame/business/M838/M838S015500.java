package mes.frame.business.M838;

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


/*
 * 개선조치기록부(HACCP관리)
 * 
 * 작성자: 최현수
 * 일시: 2021-01-14
 * 
 * */


/**
 * 개요 : 이벤트ID별 메소드 정의
 */
public  class M838S015500 extends SqlAdapter{
	Connection con = null;
	PreparedStatement pstmt = null;
	String resultString = "";
	int resultInt = -1;
	StringBuffer sql = new StringBuffer();
	
	String[][] v_paramArray = new String[0][0]; 
	Class[] optClass = null;
	Object[] optObj = null;
	Object obj = null;
	
	public M838S015500(){
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
			
			Method method = M838S015500.class.getMethod(event,optClass);
			LoggingWriter.setLogDebug(M838S015500.class.getName(),"==== " + event + " EventMethod Create Success ====");

			obj = method.invoke(M838S015500.class.newInstance(),optObj);
			doExcute_result = CommonFunction.getInt(obj.toString());
			
	    } catch (Exception ex) {
	    	doExcute_result = EventDefine.E_DOEXCUTE_INIT;
			ioParam.setMessage(MessageDefine.M_NO_EVENTID);
			LoggingWriter.setLogError(M838S015500.class.getName(),"==== EventID Not define : EVENT ID [ " + ioParam.getEventID() + "]");
	    } finally {
	    	obj = null;
			optClass = null;
			optObj = null;
	    }
	    long endTime = System.currentTimeMillis();
		long runningTime = endTime - startTime;
		LoggingWriter.setLogAll(M838S015500.class.getName(),"==== Query [수행시간  : " + runningTime + " ms]");
		
		return doExcute_result;
	}
	
	// 등록
	public int E101(InoutParameter ioParam){ 
		resultInt = EventDefine.E_DOEXCUTE_INIT;

		try {
			con = JDBCConnectionPool.getConnection();
			con.setAutoCommit(false);
			
    		JSONObject jArray = new JSONObject();
    		jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
    		
    		String checklist_id = jArray.get("checklist_id").toString();
    		String unsuit_date = jArray.get("unsuit_date").toString();
    		
    		String sql = new StringBuilder()
    				.append("INSERT INTO										\n")
    				.append("	haccp_improve_record2 (							\n")
    				.append("		checklist_id,								\n")
    				.append("		checklist_rev_no,							\n")
    				.append("		unsuit_date,								\n")
    				.append("		unsuit_detail,								\n")
    				.append("		unsuit_reason,								\n")
    				.append("		improve_action1,							\n")
    				.append("		improve_action2,							\n")
    				.append("		improve_action3,							\n")
    				.append("		improve_action4,							\n")
    				.append("		person_write_id								\n")
    				.append("	)												\n")
    				.append("VALUES												\n")
    				.append("	(												\n")
    				.append(" 		'"	+ checklist_id + "',					\n")
    				.append("		(SELECT 									\n")
    				.append("		 	checklist_rev_no 						\n")
    				.append("		 FROM checklist_format						\n")
    				.append("		 WHERE 										\n")
    				.append("			checklist_id = '"+ checklist_id +"'		\n")
    				.append("			AND create_date <= '"+unsuit_date+"'		\n")
    				.append("			AND duration_date >= '"+unsuit_date+"'),	\n")
    				.append(" 		'"	+ jArray.get("unsuit_date") + "',		\n")
    				.append(" 		'"	+ jArray.get("unsuit_detail") + "',		\n")
    				.append(" 		'"	+ jArray.get("unsuit_reason") + "',		\n")
    				.append(" 		'"	+ jArray.get("improve_action1") + "',	\n")
    				.append(" 		'"	+ jArray.get("improve_action2") + "',	\n")
    				.append(" 		'"	+ jArray.get("improve_action3") + "',	\n")
    				.append(" 		'"	+ jArray.get("improve_action4") + "',	\n")
    				.append(" 		'"	+ jArray.get("person_write_id") + "'	\n")
    				.append("       ) 											\n")
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
			LoggingWriter.setLogError("M838S015500E101()","==== SQL ERROR ===="+ e.getMessage());
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
		
	
	// 수정
	public int E102(InoutParameter ioParam){ 
		resultInt = EventDefine.E_DOEXCUTE_INIT;

		try {
			con = JDBCConnectionPool.getConnection();
			con.setAutoCommit(false);
			
    		JSONObject jArray = new JSONObject();
    		jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
    		System.out.println("JSONObject jArray rcvData="+ jArray.toString());

    		String sql = new StringBuilder()
    				.append("UPDATE															\n")
    				.append("	haccp_improve_record2										\n")
    				.append("SET															\n")
    				.append("	unsuit_date = '" + jArray.get("unsuit_date") + "',			\n")
    				.append("	unsuit_detail = '" + jArray.get("unsuit_detail") + "',		\n")
    				.append("	unsuit_reason = '" + jArray.get("unsuit_reason") + "',		\n")
    				.append("	improve_action1 = '" + jArray.get("improve_action1") + "',	\n")
    				.append("	improve_action2 = '" + jArray.get("improve_action2") + "',	\n")
    				.append("	improve_action3 = '" + jArray.get("improve_action3") + "',	\n")
    				.append("	improve_action4 = '" + jArray.get("improve_action4") + "',	\n")
    				.append("	person_write_id = '" + jArray.get("person_write_id") + "',	\n")
    				.append("	person_check_id = '" + jArray.get("person_check_id") + "',	\n")
    				.append("	person_approve_id = '" + jArray.get("person_approve_id") + "' \n")
    				.append("WHERE															\n")
    				.append("	record_seq_no = '" + jArray.get("seq_no") + "'				\n")
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
			LoggingWriter.setLogError("M838S015500E102()","==== SQL ERROR ===="+ e.getMessage());
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
	

	// 클레임 일지 삭제
	public int E103(InoutParameter ioParam){ 
		resultInt = EventDefine.E_DOEXCUTE_INIT;

		try {
			con = JDBCConnectionPool.getConnection();
			
    		JSONObject jArray = new JSONObject();
    		jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
    		System.out.println("JSONObject jArray rcvData="+ jArray.toString());

    		String sql = new StringBuilder()
    				.append("DELETE FROM									 	\n")
    				.append("	haccp_improve_record2							\n")
    				.append("WHERE record_seq_no = '"+ jArray.get("seq_no") + "'	\n")
					.toString();
		
			resultInt = super.excuteUpdate(con, sql.toString());
	    	if(resultInt < 0){
				ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
				con.rollback();
				return EventDefine.E_DOEXCUTE_ERROR ;
			}

		} catch(Exception e) {
			e.getStackTrace();
			LoggingWriter.setLogError("M838S015500E103()","==== SQL ERROR ===="+ e.getMessage());
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
	
	// 메인 테이블 조회
	// yumsam 
	public int E104(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));

			String sql = new StringBuilder()
					.append("SELECT						                            \n")
					.append("	A.checklist_id,			                            \n")
					.append("	A.checklist_rev_no,		                            \n")
					.append("	A.unsuit_date,			                            \n")
					.append("	A.record_seq_no,		                            \n")
					.append("	A.unsuit_detail,		                            \n")
					.append("	A.unsuit_reason,		                            \n")
					.append("	A.improve_action1,		                            \n")
					.append("	A.improve_action2,		                            \n")
					.append("	A.improve_action3,		                            \n")
					.append("	A.improve_action4,		                            \n")
					.append("	A.person_write_id,		                            \n")
					.append("	B.user_nm,				                            \n")
					.append("	A.person_check_id,		                            \n")
					.append("	B2.user_nm,				                            \n")
					.append("	A.person_approve_id,		                        \n")
					.append("	B3.user_nm				                            \n")
					.append("FROM						                            \n")
					.append("	haccp_improve_record2 A	                            \n")
					.append("INNER JOIN tbm_users B					                \n")
					.append("ON A.person_write_id = B.user_id		                \n")
					.append("AND  A.unsuit_date BETWEEN CAST(B.start_date AS DATE) AND CAST(B.duration_date AS DATE) \n")
					.append("LEFT JOIN tbm_users B2					                \n")
					.append("ON A.person_check_id = B2.user_id		                \n")
					.append("AND  A.unsuit_date BETWEEN CAST(B2.start_date AS DATE) AND CAST(B2.duration_date AS DATE) \n")
					.append("LEFT JOIN tbm_users B3					                \n")
					.append("ON A.person_approve_id = B3.user_id	                \n")
					.append("AND  A.unsuit_date BETWEEN CAST(B3.start_date AS DATE) AND CAST(B3.duration_date AS DATE) \n")
					.append("WHERE						                            \n")
					.append("	unsuit_date BETWEEN '"+ jArray.get("fromdate") + "' \n")
					.append("                   AND '"+ jArray.get("todate") + "' 	\n")
					.toString();

			resultString = super.excuteQueryString(con, sql.toString());
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M838S015500E104()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) {
						con.close();
					}
				} catch (Exception e) {
					LoggingWriter.setLogError("M838S015500E104()","==== finally ===="+ e.getMessage());
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
					.append("SELECT						                    \n")
					.append("	A.unsuit_date,			                    \n")
					.append("	A.unsuit_detail,		                    \n")
					.append("	A.unsuit_reason,		                    \n")
					.append("	A.improve_action1,		                    \n")
					.append("	A.improve_action2,		                    \n")
					.append("	A.improve_action3,						    \n")
					.append("	A.improve_action3,						    \n")
					.append("	A.improve_action4,						    \n")
					.append("	B.user_nm,								    \n")
					.append("	B2.user_nm,								    \n")
					.append("	B3.user_nm								    \n")
					.append("FROM										    \n")
					.append("	haccp_improve_record2 A					    \n")
					.append("INNER JOIN tbm_users B						    \n")
					.append("ON A.person_write_id = B.user_id			    \n")
					.append("AND  A.unsuit_date BETWEEN CAST(B.start_date AS DATE) AND CAST(B.duration_date AS DATE) \n")
					.append("LEFT JOIN tbm_users B2						    \n")
					.append("ON A.person_check_id = B2.user_id			    \n")
					.append("AND  A.unsuit_date BETWEEN CAST(B2.start_date AS DATE) AND CAST(B2.duration_date AS DATE) \n")
					.append("LEFT JOIN tbm_users B3						    \n")
					.append("ON A.person_approve_id = B3.user_id		    \n")
					.append("AND  A.unsuit_date BETWEEN CAST(B3.start_date AS DATE) AND CAST(B3.duration_date AS DATE) \n")
					.append("WHERE										    \n")
					.append("	record_seq_no = "+ jArray.get("seq_no") + "	\n")
					.toString();
			
			resultString = super.excuteQueryString(con, sql);
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M838S015500E144()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M838S015500E144()","==== finally ===="+ e.getMessage());
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
		    				.append("UPDATE haccp_improve_record2											\n")
		    				.append("SET															\n")
		    				.append("	person_approve_id = '" + jObj.get("userId") + "'			\n")
		    				.append("WHERE unsuit_date = '"+ jObj.get("checklistDate") + "'			\n")
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
					LoggingWriter.setLogError("M838S015500E502()","==== SQL ERROR ===="+ e.getMessage());
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
			
			
			// 점검표 검토자 서명
						public int E522(InoutParameter ioParam){ 
							
							resultInt = EventDefine.E_DOEXCUTE_INIT;

							try {
								con = JDBCConnectionPool.getConnection();
								con.setAutoCommit(false);
								
								JSONObject jObj = new JSONObject();
					    		jObj = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
					    		
					    		String sql = new StringBuilder()
					    				.append("UPDATE haccp_improve_record2											\n")
					    				.append("SET															\n")
					    				.append("	person_check_id = '" + jObj.get("userId") + "'				\n")
					    				.append("WHERE unsuit_date = '"+ jObj.get("checklistDate") + "'			\n")
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
								LoggingWriter.setLogError("M838S015300E522()","==== SQL ERROR ===="+ e.getMessage());
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