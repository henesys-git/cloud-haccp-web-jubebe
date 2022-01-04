package mes.frame.business.M838;
/*BOM코드*/
import java.lang.reflect.Method;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.util.Vector;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;

import mes.frame.common.ApprovalActionNo;
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
public  class M838S070200 extends SqlAdapter{
	Connection con = null;
	PreparedStatement pstmt = null;
	String resultString = "";
	int resultInt = -1;
	StringBuffer sql = new StringBuffer();
	
	String[][] v_paramArray = new String[0][0]; 
	Class[] optClass = null;
	Object[] optObj = null;
	Object obj = null;
	
	public M838S070200(){
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
			
			Method method = M838S070200.class.getMethod(event,optClass);
			LoggingWriter.setLogDebug(M838S070200.class.getName(),"==== " + event + " EventMethod Create Success ====");

			obj = method.invoke(M838S070200.class.newInstance(),optObj);
			doExcute_result = CommonFunction.getInt(obj.toString());
			
	    } catch (Exception ex) {
	    	doExcute_result = EventDefine.E_DOEXCUTE_INIT;
			ioParam.setMessage(MessageDefine.M_NO_EVENTID);
			LoggingWriter.setLogError(M838S070200.class.getName(),"==== EventID Not define : EVENT ID [ " + ioParam.getEventID() + "]");
	    } finally {
	    	obj = null;
			optClass = null;
			optObj = null;
	    }
	    long endTime = System.currentTimeMillis();
		long runningTime = endTime - startTime;
		LoggingWriter.setLogAll(M838S070200.class.getName(),"==== Query [수행시간  : " + runningTime + " ms]");
		
		return doExcute_result;
	}
	
	// 부자재입고검사 관리대장 등록
			public int E101(InoutParameter ioParam){ 
				
				String sql = "";
				
				resultInt = EventDefine.E_DOEXCUTE_INIT;

				try {
					con = JDBCConnectionPool.getConnection();
					con.setAutoCommit(false);
					
		    		JSONObject jArray = new JSONObject();
		    		jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
		    		System.out.println("JSONObject jArray rcvData="+ jArray.toString());
		    			
		    			sql = new StringBuilder()
		    					.append("INSERT INTO					\n")
			    				.append("	haccp_check_ipgo_part2 (	\n")
			    				.append("		checklist_id,			\n")
			    				.append("		checklist_rev_no,		\n")
			    				.append("       ipgo_date, 				\n")
			    				.append("		unsuit_detail,			\n")
			    				.append("		improve_action,			\n")
			    				.append("		person_write_id		\n")
			    				.append(" 		)						\n")
			    				.append("VALUES (											\n")
								.append(" 		'"	+ jArray.get("checklist_id") + "',		\n")
								.append(" 		'"	+ jArray.get("checklist_rev_no") + "',	\n")
								.append(" 		'"	+ jArray.get("ipgo_date") + "',			\n")
								.append(" 		'"	+ jArray.get("unsuit_detail") + "',		\n")
								.append(" 		'"	+ jArray.get("improve_action") + "',	\n")
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
					LoggingWriter.setLogError("M838S070200E101()","==== SQL ERROR ===="+ e.getMessage());
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
			
			// 부자재입고검사 관리대장 상세 등록
			public int E111(InoutParameter ioParam){ 
				
				String sql = "";
				
				resultInt = EventDefine.E_DOEXCUTE_INIT;

				try {
					con = JDBCConnectionPool.getConnection();
					con.setAutoCommit(false);
					
		    		JSONObject jArray = new JSONObject();
		    		jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
		    		System.out.println("JSONObject jArray rcvData="+ jArray.toString());
		    		
		    			sql = new StringBuilder()
		    				.append("INSERT INTO						\n")
		    				.append("	haccp_check_ipgo_part2_detail (	\n")
		    				.append("		checklist_id,				\n")
		    				.append("		checklist_rev_no,			\n")
		    				.append("       ipgo_date, 					\n")
		    				.append("		part_cd,					\n")
		    				.append("       part_rev_no, 				\n")
		    				.append(" 		trace_key,					\n")
		    				.append("       standard_yn, 				\n")
		    				.append(" 		packing_status,				\n")
		    				.append("		visual_inspection,			\n")
		    				.append("		car_clean,					\n")
		    				.append("		docs_yn,					\n")
		    				.append("		unsuit_action,				\n")
		    				.append("		check_yn					\n")
		    				.append(" 		)							\n")
		    				.append("VALUES (											\n")
							.append(" 		'"	+ jArray.get("checklist_id") + "',		\n")
							.append(" 		'"	+ jArray.get("checklist_rev_no") + "',	\n")
							.append(" 		'"	+ jArray.get("ipgo_date") + "',			\n")
							.append(" 		'"	+ jArray.get("part_cd") + "',			\n")
							.append(" 		'"	+ jArray.get("part_rev_no") + "',		\n")
							.append(" 		"	+ jArray.get("trace_key") + ",			\n")
							.append(" 		'"	+ jArray.get("standard_yn") + "',		\n")
							.append(" 		'"	+ jArray.get("packing_status") + "',	\n")
							.append(" 		'"	+ jArray.get("visual_inspection") + "',	\n")
							.append(" 		'"	+ jArray.get("car_clean") + "',			\n")
							.append(" 		'"	+ jArray.get("docs_yn") + "',			\n")
							.append(" 		'"	+ jArray.get("unsuit_action") + "',		\n")
							.append(" 		'"	+ jArray.get("check_yn") + "'			\n")
							.append("	) 												\n")
							.toString();
				
					resultInt = super.excuteUpdate(con, sql.toString());
			    	if(resultInt < 0){
						ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
						con.rollback();
						return EventDefine.E_DOEXCUTE_ERROR ;
					}
			    	
			    	//발주상세내역 테이블의 입고검사대장 등록 여부 확인을 'Y'으로 수정한다.
			    	sql = new StringBuilder()
		    				.append("UPDATE								\n")
		    				.append("	tbi_balju_list2 SET				\n")
		    				.append("		doc_regist_yn = 'Y'			\n")
		    				.append("	WHERE trace_key = "	+ jArray.get("trace_key") + " 		\n")
		    				.append("    AND part_cd = 	'" + jArray.get("part_cd") + "'  		\n")
		    				.append("    AND part_rev_no = '"+ jArray.get("part_rev_no") + "' 	\n")
		    				.append("    AND balju_no = '"+ jArray.get("balju_no") + "' 		\n")
		    				.append("    AND balju_rev_no = '"+ jArray.get("balju_rev_no") + "' \n")
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
					LoggingWriter.setLogError("M838S070200E111()","==== SQL ERROR ===="+ e.getMessage());
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
			
			// 원부재료입고검사 관리대장 수정
			public int E102(InoutParameter ioParam){ 
				
				String sql = "";
				
				resultInt = EventDefine.E_DOEXCUTE_INIT;

				try {
					con = JDBCConnectionPool.getConnection();
					con.setAutoCommit(false);
					
		    		JSONObject jArray = new JSONObject();
		    		jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
		    		System.out.println("JSONObject jArray rcvData="+ jArray.toString());
		    		
		    		sql = new StringBuilder()
		    				.append("UPDATE																	\n")
		    				.append("	haccp_check_ipgo_part2 SET									  		\n")
		    				.append("       unsuit_detail   = '"+ jArray.get("unsuit_detail") + "', 		\n")
		    				.append("       improve_action   = '"+ jArray.get("improve_action") + "', 		\n")
		    				.append("       person_write_id   = '"+ jArray.get("person_write_id") + "', 	\n")
		    				.append(" 		ipgo_date = '"	+ jArray.get("ipgo_date") + "'	\n")
		    				.append("WHERE ipgo_date = 		'"+ jArray.get("ipgo_date2") + "'				\n")
		    				
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
					LoggingWriter.setLogError("M838S070200E102()","==== SQL ERROR ===="+ e.getMessage());
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
			
			// 원부재료입고검사 관리대장 상세 수정
			public int E112(InoutParameter ioParam){ 
				
				String sql = "";
				
				resultInt = EventDefine.E_DOEXCUTE_INIT;

				try {
					con = JDBCConnectionPool.getConnection();
					con.setAutoCommit(false);
					
		    		JSONObject jArray = new JSONObject();
		    		jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
		    		System.out.println("JSONObject jArray rcvData="+ jArray.toString());
		    		
		    		sql = new StringBuilder()
		    				.append("UPDATE														 \n")
		    				.append("	haccp_check_ipgo_part2_detail SET						 \n")
		    				.append("		part_cd 	 = '"	+ jArray.get("part_cd") + "', 	 \n")
		    				.append("		part_rev_no  = '"	+ jArray.get("part_rev_no") + "', \n")
		    				.append("       standard_yn = '"	+ jArray.get("standard_yn") + "',\n")
		    				.append("       packing_status = '"	+ jArray.get("packing_status") + "',\n")
		    				.append("       visual_inspection = '"+ jArray.get("visual_inspection") + "',\n")
		    				.append("       car_clean = '"+ jArray.get("car_clean") + "',		 \n")
		    				.append("       docs_yn = '"+ jArray.get("docs_yn") + "',			 \n")
		    				.append("       unsuit_action = '"+ jArray.get("unsuit_action") + "', \n")
		    				.append("       ipgo_date = '"+ jArray.get("ipgo_date") + "' \n")
		    				.append("WHERE seq_no =  "+ jArray.get("seq_no") + " 				 \n")
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
					LoggingWriter.setLogError("M838S070200E112()","==== SQL ERROR ===="+ e.getMessage());
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
			
	
			// 원부재료입고검사 관리대장 삭제
			public int E103(InoutParameter ioParam){ 
				resultInt = EventDefine.E_DOEXCUTE_INIT;
				String sql = "";
				try {
					con = JDBCConnectionPool.getConnection();
					con.setAutoCommit(false);
					
		    		JSONObject jArray = new JSONObject();
		    		jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
		    		System.out.println("JSONObject jArray rcvData="+ jArray.toString());

		    		sql = new StringBuilder()
		    				.append("DELETE FROM											\n")
		    				.append("	haccp_check_ipgo_part2								\n")
		    				.append("WHERE ipgo_date = 	'"+ jArray.get("ipgo_date") + "'	\n")
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
					LoggingWriter.setLogError("M838S070200E103()","==== SQL ERROR ===="+ e.getMessage());
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
			
			
			// 원부재료입고검사 관리대장 상세 삭제
			public int E113(InoutParameter ioParam){ 
				resultInt = EventDefine.E_DOEXCUTE_INIT;

				try {
					con = JDBCConnectionPool.getConnection();
					con.setAutoCommit(false);
					
		    		JSONObject jArray = new JSONObject();
		    		jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
		    		System.out.println("JSONObject jArray rcvData="+ jArray.toString());

		    		String sql = new StringBuilder()
		    				.append("DELETE FROM									\n")
		    				.append("	haccp_check_ipgo_part2_detail 				\n")
		    				.append("WHERE seq_no =  '"+ jArray.get("seq_no") + "'	\n")
							.toString();
				
					resultInt = super.excuteUpdate(con, sql.toString());
			    	if(resultInt < 0){
						ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
						con.rollback();
						return EventDefine.E_DOEXCUTE_ERROR ;
					}
			    	
			    	//발주상세내역 테이블의 입고검사대장 등록 여부 확인을 다시 'N'으로 수정한다.
			    	sql = new StringBuilder()
		    				.append("UPDATE								\n")
		    				.append("	tbi_balju_list2 SET				\n")
		    				.append("		doc_regist_yn = 'N'			\n")
		    				.append("	WHERE trace_key = "	+ jArray.get("trace_key") + " 		\n")
		    				.append("    AND part_cd = 	'" + jArray.get("part_cd") + "'  		\n")
		    				.append("    AND part_rev_no = '"+ jArray.get("part_rev_no") + "' 	\n")
		    				.append("    AND balju_no = '"+ jArray.get("balju_no") + "' 		\n")
		    				.append("    AND balju_rev_no = '"+ jArray.get("balju_rev_no") + "' \n")
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
					LoggingWriter.setLogError("M838S070200E113()","==== SQL ERROR ===="+ e.getMessage());
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
	
	// 부자재 입고검사 관리대장 메인 테이블 조회
		// yumsam 
		public int E104(InoutParameter ioParam){
			resultInt = EventDefine.E_DOEXCUTE_INIT;
			
			try {
				con = JDBCConnectionPool.getConnection();
				
				JSONObject jArray = new JSONObject();
				jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));

				String sql = new StringBuilder()
						.append("SELECT\n")
						.append("	A.checklist_id,				 \n")
						.append("	A.checklist_rev_no,			 \n")
						.append("   A.ipgo_date, 				 \n")
						.append("   (SELECT COUNT(*) from haccp_check_ipgo_part2_detail  \n")
						.append("   WHERE ipgo_date = '"+jArray.get("ipgo_date")+"') AS ipgo_part_count,\n")
						.append("   A.person_write_id, 			 \n")
						.append("   C.user_nm, 					 \n")
						.append("   A.person_approve_id, 		 \n")
						.append("   C2.user_nm,				 	 \n")
						.append("   A.unsuit_detail, 		 	 \n")
						.append("   A.improve_action 		 	 \n")
						.append("FROM											\n")
						.append("	haccp_check_ipgo_part2 A					\n")
						.append("INNER JOIN tbm_users C							\n")
						.append("ON A.person_write_id = C.user_id				\n")
						.append("AND  A.ipgo_date BETWEEN CAST(C.start_date AS DATE) AND CAST(C.duration_date AS DATE) \n")
						.append("LEFT JOIN tbm_users C2							\n")
						.append("ON A.person_approve_id = C2.user_id			\n")
						.append("AND  A.ipgo_date BETWEEN CAST(C2.start_date AS DATE) AND CAST(C2.duration_date AS DATE) \n")
						.append("WHERE A.ipgo_date = '"+ jArray.get("ipgo_date") + "' 	\n")
						.append("GROUP BY A.ipgo_date \n")
						.toString();

				String ActionCommand = ioParam.getActionCommand();
				if(ActionCommand.startsWith("doQueryTableFieldName")) {
					resultString = super.excuteQueryStringTableFieldName(con, sql.toString());
				} else {
					resultString = super.excuteQueryString(con, sql.toString());
				}
			} catch(Exception e) {
				e.printStackTrace();
				LoggingWriter.setLogError("M838S070200E104()","==== SQL ERROR ===="+ e.getMessage());
				return EventDefine.E_DOEXCUTE_ERROR ;
		    } finally {
		    	if (Config.useDataSource) {
					try {
						if (con != null) {
							con.close();
						}
					} catch (Exception e) {
						LoggingWriter.setLogError("M838S070200E104()","==== finally ===="+ e.getMessage());
					}
		    	}
		    }

			ioParam.setResultString(resultString);
			ioParam.setColumnCount("" + super.COLUMN_COUNT);
	    	ioParam.setMessage(MessageDefine.M_QUERY_OK);

	    	return EventDefine.E_QUERY_RESULT;
		}
	
		// 원부재료 입고검사 관리대장 서브 테이블 조회
				// yumsam 
				public int E114(InoutParameter ioParam){
					resultInt = EventDefine.E_DOEXCUTE_INIT;
					
					try {
						con = JDBCConnectionPool.getConnection();
						
						JSONObject jArray = new JSONObject();
						jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));

						String sql = new StringBuilder()
								.append("SELECT\n")
								.append("	A.checklist_id,				 \n")
								.append("	A.checklist_rev_no,			 \n")
								.append("	A.seq_no,			 		 \n")
								.append("   A.ipgo_date, 				 \n")
								.append("   A.part_cd, 			 		 \n")
								.append("   A.part_rev_no, 				 \n")
								.append("   D.part_nm,					 \n")
								.append("   D.supplier,					 \n")
								.append("   B.ipgo_amount, 				 \n")
								.append("   E.expiration_date,			 \n")
								.append("   A.trace_key, 			 	 \n")
								.append("   A.standard_yn, 			 	 \n")
								.append("   A.packing_status, 			 \n")
								.append("   A.visual_inspection, 		 \n")
								.append("   A.car_clean, 		 		 \n")
								.append("   A.docs_yn,					 \n")
								.append("   A.unsuit_action, 		 	 \n")
								.append("   A.check_yn, 		 		 \n")
								.append("   F.balju_no, 				 \n")
								.append("   F.balju_rev_no 				 \n")
								.append("FROM											\n")
								.append("	haccp_check_ipgo_part2_detail A				\n")
								.append("INNER JOIN tbi_part_ipgo2 B 					\n")
								.append("ON A.part_cd = B.part_cd 						\n")
								.append("AND A.part_rev_no = B.part_rev_no 				\n")
								.append("AND A.ipgo_date = B.ipgo_date                  \n")
								.append("INNER JOIN tbm_part_list D 					\n")
								.append("ON A.part_cd = D.part_cd 						\n")
								.append("AND A.part_rev_no = D.revision_no 				\n")
								.append("INNER JOIN tbi_part_storage2 E 				\n")
								.append("ON A.part_cd = E.part_cd 						\n")
								.append("AND A.part_rev_no = E.part_rev_no 				\n")
								.append("INNER JOIN tbi_balju_list2 F 					\n")
								.append("ON B.part_cd = F.part_cd 						\n")
								.append("AND B.part_rev_no = F.part_rev_no 				\n")
								.append("AND B.trace_key = F.trace_key 					\n")
								.append("WHERE A.ipgo_date = '" + jArray.get("ipgo_date") + "' \n")
								.append("GROUP BY A.part_cd \n")
								.toString();

						String ActionCommand = ioParam.getActionCommand();
						if(ActionCommand.startsWith("doQueryTableFieldName")) {
							resultString = super.excuteQueryStringTableFieldName(con, sql.toString());
						} else {
							resultString = super.excuteQueryString(con, sql.toString());
						}
					} catch(Exception e) {
						e.printStackTrace();
						LoggingWriter.setLogError("M838S070200E114()","==== SQL ERROR ===="+ e.getMessage());
						return EventDefine.E_DOEXCUTE_ERROR ;
				    } finally {
				    	if (Config.useDataSource) {
							try {
								if (con != null) {
									con.close();
								}
							} catch (Exception e) {
								LoggingWriter.setLogError("M838S070200E114()","==== finally ===="+ e.getMessage());
							}
				    	}
				    }

					ioParam.setResultString(resultString);
					ioParam.setColumnCount("" + super.COLUMN_COUNT);
			    	ioParam.setMessage(MessageDefine.M_QUERY_OK);

			    	return EventDefine.E_QUERY_RESULT;
				}
	
	// T838S070200.jsp 등록화면(Tablet)
	public int E134(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			System.out.println("JSONObject jArray rcvData="+ jArray.toString());
    		
			String sql = new StringBuilder()
					.append("select\n")
					.append("	A.check_gubun,\n")
					.append("	E.code_name,\n")
					.append("	A.checklist_cd,\n")
					.append("	A.revision_no,\n")
					.append("	A.checklist_seq,\n")
					.append("	A.check_note,\n")
					.append("	A.standard_guide,\n")
					.append("	A.standard_value,\n")
					.append("	A.double_check_yn,\n")
					.append("	A.item_cd,\n")
					.append("	A.item_seq,\n")
					.append("	A.item_cd_rev,\n")
					.append("	B.item_type,\n")
					.append("	B.item_bigo,\n")
					.append("	B.item_desc,\n")
					.append("	A.start_date,\n")
					.append("	A.duration_date,\n")
					.append("	A.check_gubun_mid,\n")
					.append("	F.code_name,\n")
					.append("	A.check_gubun_sm,\n")
					.append("	G.code_name\n")
					.append("FROM vtbm_checklist A\n")
					.append("INNER JOIN tbm_check_item B\n")
					.append("	ON A.item_cd = B.item_cd\n")
					.append("	AND A.item_seq = B.item_seq\n")
					.append("	AND A.item_cd_rev = B.revision_no\n")
					.append("	AND A.member_key = B.member_key\n")
					.append("INNER JOIN v_checklist_gubun E\n")
					.append("	ON A.check_gubun = E.code_value\n")
					.append("	AND A.member_key = E.member_key\n")
					.append("LEFT OUTER JOIN v_checklist_gubun_mid F\n")
//						.append("INNER JOIN v_checklist_gubun_mid F\n")
					.append("	ON A.check_gubun = F.code_cd\n")
					.append("	AND A.check_gubun_mid = F.code_value\n")
					.append("	AND A.member_key = F.member_key\n")
					.append("LEFT OUTER JOIN v_checklist_gubun_sm G\n")
//						.append("INNER JOIN v_checklist_gubun_sm G\n")
					.append("	ON A.check_gubun = G.code_cd_big\n")
					.append("	AND A.check_gubun_mid = G.code_cd\n")
					.append("	AND A.check_gubun_sm = G.code_value\n")
					.append("	AND A.member_key = G.member_key\n")
					.append("where A.check_gubun = '" + jArray.get("IMPORT") + "'\n")
					.append(" 	AND A.member_key = '" + jArray.get("member_key") + "' \n") //member_key_select, update, delete
					.append("ORDER BY A.checklist_seq\n") // order by 안해주면 타임아웃 됨
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
			LoggingWriter.setLogError("M838S070200E134()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M838S070200E134()","==== finally ===="+ e.getMessage());
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
	
	// S838S070200_canvas.jsp
	public int E144(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			System.out.println("JSONObject jArray rcvData="+ jArray.toString());
			
			String sql = new StringBuilder()
					.append("SELECT\n")
					.append("	A.checklist_id,				 \n")
					.append("	A.checklist_rev_no,			 \n")
					.append("   A.person_write_id, 			 \n")
					.append("   C.user_nm, 					 \n")
					.append("   A.person_approve_id, 		 \n")
					.append("   C2.user_nm,				 	 \n")
					.append("   A.unsuit_detail, 		 	 \n")
					.append("   A.improve_action 		 	 \n")
					.append("FROM											\n")
					.append("	haccp_check_ipgo_part2 A					\n")
					.append("INNER JOIN tbm_users C							\n")
					.append("ON A.person_write_id = C.user_id				\n")
					.append("AND  A.ipgo_date BETWEEN CAST(C.start_date AS DATE) AND CAST(C.duration_date AS DATE) \n")
					.append("LEFT JOIN tbm_users C2							\n")
					.append("ON A.person_approve_id = C2.user_id			\n")
					.append("AND  A.ipgo_date BETWEEN CAST(C2.start_date AS DATE) AND CAST(C2.duration_date AS DATE) \n")
					.append("WHERE A.ipgo_date = '" + jArray.get("ipgo_date") + "' \n")
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
			LoggingWriter.setLogError("M838S070200E144()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M838S070200E144()","==== finally ===="+ e.getMessage());
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
	
	// S838S070200_canvas.jsp_detail
		public int E154(InoutParameter ioParam){
			resultInt = EventDefine.E_DOEXCUTE_INIT;
			
			try {
				con = JDBCConnectionPool.getConnection();
				
				JSONObject jArray = new JSONObject();
				jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
				System.out.println("JSONObject jArray rcvData="+ jArray.toString());
				
				String sql = new StringBuilder()
						.append("SELECT\n")
						.append("	F.seq_no,			 		 \n")
						.append("   F.ipgo_date, 				 \n")
						.append("   F.part_cd, 			 		 \n")
						.append("   F.part_rev_no, 				 \n")
						.append("   D.part_nm,					 \n")
						.append("   D.supplier,					 \n")
						.append("   B.ipgo_amount, 				 \n")
						.append("   E.expiration_date,			 \n")
						.append("   F.trace_key, 			 	 \n")
						.append("   F.standard_yn, 			 	 \n")
						.append("   F.packing_status, 			 \n")
						.append("   F.visual_inspection, 		 \n")
						.append("   F.car_clean, 		 		 \n")
						.append("   F.docs_yn,					 \n")
						.append("   F.unsuit_action, 		 	 \n")
						.append("   F.check_yn 		 		 	 \n")
						.append("FROM											\n")
						.append("haccp_check_ipgo_part2_detail F 				\n")
						//.append("ON A.ipgo_date = F.ipgo_date 					\n")
						.append("INNER JOIN tbi_part_ipgo2 B 					\n")
						.append("ON F.part_cd = B.part_cd 						\n")
						.append("AND F.part_rev_no = B.part_rev_no 				\n")
						.append("INNER JOIN tbm_part_list D 					\n")
						.append("ON F.part_cd = D.part_cd 						\n")
						.append("AND F.part_rev_no = D.revision_no 				\n")
						.append("INNER JOIN tbi_part_storage2 E 				\n")
						.append("ON F.part_cd = E.part_cd 						\n")
						.append("AND F.part_rev_no = E.part_rev_no 				\n")
						.append("WHERE F.ipgo_date = '" + jArray.get("ipgo_date") + "' \n")
						.append("AND D.part_gubun_b = '02' 						\n") //대분류번호 : 부자재(02)
						.append("GROUP BY F.part_cd \n")
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
				LoggingWriter.setLogError("M838S070200E144()","==== SQL ERROR ===="+ e.getMessage());
				return EventDefine.E_DOEXCUTE_ERROR ;
		    } finally {
		    	if (Config.useDataSource) {
					try {
						if (con != null) con.close();
					} catch (Exception e) {
						LoggingWriter.setLogError("M838S070200E144()","==== finally ===="+ e.getMessage());
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
			    				.append("UPDATE haccp_check_ipgo_part2											\n")
			    				.append("SET															\n")
			    				.append("	person_approve_id = '" + jObj.get("userId") + "'			\n")
			    				.append("WHERE ccp_date = '"+ jObj.get("checklistDate") + "'			\n")
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
	
}