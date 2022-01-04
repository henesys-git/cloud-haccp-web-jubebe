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


/**
 * 개요 : 이벤트ID별 메소드 정의
 */
public  class M838S020300 extends SqlAdapter{
	Connection con = null;
	PreparedStatement pstmt = null;
	String resultString = "";
	int resultInt = -1;
	StringBuffer sql = new StringBuffer();
	
	String[][] v_paramArray = new String[0][0]; 
	Class[] optClass = null;
	Object[] optObj = null;
	Object obj = null;
	
	public M838S020300(){
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
			
			Method method = M838S020300.class.getMethod(event,optClass);
			LoggingWriter.setLogDebug(M838S020300.class.getName(),"==== " + event + " EventMethod Create Success ====");

			obj = method.invoke(M838S020300.class.newInstance(),optObj);
			doExcute_result = CommonFunction.getInt(obj.toString());
			
	    } catch (Exception ex) {
	    	doExcute_result = EventDefine.E_DOEXCUTE_INIT;
			ioParam.setMessage(MessageDefine.M_NO_EVENTID);
			LoggingWriter.setLogError(M838S020300.class.getName(),"==== EventID Not define : EVENT ID [ " + ioParam.getEventID() + "]");
	    } finally {
	    	obj = null;
			optClass = null;
			optObj = null;
	    }
	    long endTime = System.currentTimeMillis();
		long runningTime = endTime - startTime;
		LoggingWriter.setLogAll(M838S020300.class.getName(),"==== Query [수행시간  : " + runningTime + " ms]");
		
		return doExcute_result;
	}
	
	// 자동기록관리 시스템 수정일지 등록
		public int E101(InoutParameter ioParam){ 
			resultInt = EventDefine.E_DOEXCUTE_INIT;

			try {
				con = JDBCConnectionPool.getConnection();
				con.setAutoCommit(false);
				
	    		JSONObject jArray = new JSONObject();
	    		jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
	    		System.out.println("JSONObject jArray rcvData="+ jArray.toString());

	    		String sql = new StringBuilder()
	    				.append("INSERT INTO					\n")
	    				.append("	haccp_auto_system_improve (	\n")
	    				.append("		checklist_id,			\n")
	    				.append("		checklist_rev_no,		\n")
	    				.append("		unsuit_date, 			\n")
	    				.append("		unsuit_detail,			\n")
	    				.append("       unsuit_reason, 			\n")
	    				.append(" 		improve_action,			\n")
	    				.append("		improve_action_check, 	\n")
	    				.append("		person_write_id 		\n")
	    				.append(" 		)						\n")
	    				.append("VALUES (											\n")
	    				.append(" 		'"	+ jArray.get("checklist_id") + "',		\n")
	    				.append(" 		'"	+ jArray.get("checklist_rev_no") + "',	\n")
						.append(" 		'"	+ jArray.get("unsuit_date") + "',		\n")
						.append(" 		'"	+ jArray.get("unsuit_detail") + "',		\n")
						.append(" 		'"	+ jArray.get("unsuit_reason") + "',		\n")
						.append(" 		'"	+ jArray.get("improve_action") + "',	\n")
						.append(" 		'"	+ jArray.get("improve_action_check") + "',	\n")
						.append(" 		'"	+ jArray.get("person_write_id") + "'	\n")
						.append("	) 												\n")
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
				LoggingWriter.setLogError("M838S020300E101()","==== SQL ERROR ===="+ e.getMessage());
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
		
	
		// 자동기록관리 시스템 수정일지 수정
				public int E102(InoutParameter ioParam){ 
					resultInt = EventDefine.E_DOEXCUTE_INIT;

					try {
						con = JDBCConnectionPool.getConnection();
						con.setAutoCommit(false);
						
			    		JSONObject jArray = new JSONObject();
			    		jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			    		System.out.println("JSONObject jArray rcvData="+ jArray.toString());

			    		String sql = new StringBuilder()
			    				.append("UPDATE																		\n")
			    				.append("	haccp_auto_system_improve SET									  		\n")
			    				.append("		unsuit_date 		 = '"	+ jArray.get("unsuit_date") + "',		\n")
			    				.append("       unsuit_detail 			 = '"	+ jArray.get("unsuit_detail") + "', \n")
			    				.append(" 		unsuit_reason 		 = '"	+ jArray.get("unsuit_reason") + "',		\n")
			    				.append("		improve_action 	 = '"	+ jArray.get("improve_action") + "', 		\n")
			    				.append("		improve_action_check 		 = '"	+ jArray.get("improve_action_check") + "' 	\n")
			    				.append("WHERE record_seq_no = 		'"+ jArray.get("record_seq_no") + "'			\n")
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
						LoggingWriter.setLogError("M838S020300E102()","==== SQL ERROR ===="+ e.getMessage());
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
				
		
				// 자동기록관리 시스템 수정일지 삭제
				public int E103(InoutParameter ioParam){ 
					resultInt = EventDefine.E_DOEXCUTE_INIT;

					try {
						con = JDBCConnectionPool.getConnection();
						con.setAutoCommit(false);
						
			    		JSONObject jArray = new JSONObject();
			    		jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			    		System.out.println("JSONObject jArray rcvData="+ jArray.toString());

			    		String sql = new StringBuilder()
			    				.append("DELETE FROM													 \n")
			    				.append("	haccp_auto_system_improve 									 \n")
			    				.append("WHERE record_seq_no = 		'"+ jArray.get("record_seq_no") + "' \n")
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
						LoggingWriter.setLogError("M838S020300E103()","==== SQL ERROR ===="+ e.getMessage());
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
	
	
	// 자동기록관리 시스템 수정일지 메인 테이블 조회
	// yumsam 
	public int E104(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));

			String sql = new StringBuilder()
					.append("SELECT\n")
					.append("	A.checklist_id,			\n")
					.append("	A.checklist_rev_no,		\n")
					.append("   A.unsuit_date, 			\n")
					.append("   A.record_seq_no, 		\n")
					.append("   A.unsuit_detail, 		\n")
					.append("   A.unsuit_reason, 		\n")
					.append("   A.improve_action, 		\n")
					.append("   A.improve_action_check,	\n")
					.append("   C.user_nm,				\n")
					.append("   A.person_write_id,  	\n")
					.append("   C2.user_nm,				\n")
					.append("   A.person_check_id,  	\n")
					.append("   C3.user_nm, 			\n")
					.append("   A.person_approve_id 	\n")
					.append("FROM									\n")
					.append("	haccp_auto_system_improve A			\n")
					.append("INNER JOIN tbm_users C					\n")
					.append("ON A.person_write_id = C.user_id		\n")
					.append("AND  A.unsuit_date BETWEEN CAST(C.start_date AS DATE) AND CAST(C.duration_date AS DATE) \n")
					.append("LEFT JOIN tbm_users C2					\n")
					.append("ON A.person_check_id = C2.user_id		\n")
					.append("AND  A.unsuit_date BETWEEN CAST(C2.start_date AS DATE) AND CAST(C2.duration_date AS DATE) \n")
					.append("LEFT JOIN tbm_users C3					\n")
					.append("ON A.person_approve_id = C3.user_id	\n")
					.append("AND  A.unsuit_date BETWEEN CAST(C3.start_date AS DATE) AND CAST(C3.duration_date AS DATE) \n")
					.append("WHERE A.unsuit_date Between '"+ jArray.get("fromdate") + "' \n")
					.append("                   AND '"+ jArray.get("todate") + "' 		\n")
					.append("GROUP BY A.record_seq_no 				\n")
					.toString();

			String ActionCommand = ioParam.getActionCommand();
			if(ActionCommand.startsWith("doQueryTableFieldName")) {
				resultString = super.excuteQueryStringTableFieldName(con, sql.toString());
			} else {
				resultString = super.excuteQueryString(con, sql.toString());
			}
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M838S020300E104()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) {
						con.close();
					}
				} catch (Exception e) {
					LoggingWriter.setLogError("M838S020300E104()","==== finally ===="+ e.getMessage());
				}
	    	}
	    }

		ioParam.setResultString(resultString);
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
    	ioParam.setMessage(MessageDefine.M_QUERY_OK);

    	return EventDefine.E_QUERY_RESULT;
	}
	
	// S838S020300_canvas.jsp
	public int E144(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			
			String sql = new StringBuilder()
					.append("SELECT\n")
					.append("	A.checklist_id,						\n")
					.append("	A.checklist_rev_no,					\n")
					.append("	A.unsuit_date,						\n")
					.append("	A.unsuit_detail,					\n")
					.append("   A.unsuit_reason, 					\n")
					.append("	A.improve_action,					\n")
					.append("	A.improve_action_check,				\n")
					.append("	C.user_nm,							\n")
					.append("	C2.user_nm,							\n")
					.append("	C3.user_nm							\n")
					.append("FROM															\n")
					.append("	haccp_auto_system_improve A									\n")
					.append("LEFT JOIN tbm_users C											\n")
					.append("ON A.person_write_id = C.user_id								\n")
					.append("AND  A.unsuit_date BETWEEN CAST(C.start_date AS DATE) AND CAST(C.duration_date AS DATE) \n")
					.append("LEFT JOIN tbm_users C2											\n")
					.append("ON A.person_check_id = C2.user_id								\n")
					.append("AND  A.unsuit_date BETWEEN CAST(C2.start_date AS DATE) AND CAST(C2.duration_date AS DATE) \n")
					.append("LEFT JOIN tbm_users C3											\n")
					.append("ON A.person_approve_id = C3.user_id							\n")
					.append("AND  A.unsuit_date BETWEEN CAST(C3.start_date AS DATE) AND CAST(C3.duration_date AS DATE) \n")
					.append("WHERE A.unsuit_date = '"+jArray.get("checklist_Date")+"'		\n")
					.append("  AND A.record_seq_no = '"+jArray.get("record_seq_no")+"'		\n")
					.toString();
			
			String ActionCommand = ioParam.getActionCommand();
			if(ActionCommand.startsWith("doQueryTableFieldName")) {
				resultString = super.excuteQueryStringTableFieldName(con, sql.toString());
			} else {
				resultString = super.excuteQueryString(con, sql.toString());
			}
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M838S020300E144()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M838S020300E144()","==== finally ===="+ e.getMessage());
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
	
	// 점검표 승인자 서명
			public int E502(InoutParameter ioParam){ 
				
				resultInt = EventDefine.E_DOEXCUTE_INIT;

				try {
					con = JDBCConnectionPool.getConnection();
					con.setAutoCommit(false);
					
		    		JSONObject jObj = new JSONObject();
		    		jObj = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
		    		
		    		String sql = new StringBuilder()
		    				.append("UPDATE haccp_auto_system_improve											\n")
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
					LoggingWriter.setLogError("M838S015300E502()","==== SQL ERROR ===="+ e.getMessage());
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
		    				.append("UPDATE haccp_auto_system_improve											\n")
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