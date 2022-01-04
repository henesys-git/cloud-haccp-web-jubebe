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
public  class M838S015400 extends SqlAdapter{
	Connection con = null;
	PreparedStatement pstmt = null;
	String resultString = "";
	int resultInt = -1;
	StringBuffer sql = new StringBuffer();
	
	String[][] v_paramArray = new String[0][0]; 
	Class[] optClass = null;
	Object[] optObj = null;
	Object obj = null;
	
	public M838S015400(){
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
			
			Method method = M838S015400.class.getMethod(event,optClass);
			LoggingWriter.setLogDebug(M838S015400.class.getName(),"==== " + event + " EventMethod Create Success ====");

			obj = method.invoke(M838S015400.class.newInstance(),optObj);
			doExcute_result = CommonFunction.getInt(obj.toString());
			
	    } catch (Exception ex) {
	    	doExcute_result = EventDefine.E_DOEXCUTE_INIT;
			ioParam.setMessage(MessageDefine.M_NO_EVENTID);
			LoggingWriter.setLogError(M838S015400.class.getName(),"==== EventID Not define : EVENT ID [ " + ioParam.getEventID() + "]");
	    } finally {
	    	obj = null;
			optClass = null;
			optObj = null;
	    }
	    long endTime = System.currentTimeMillis();
		long runningTime = endTime - startTime;
		LoggingWriter.setLogAll(M838S015400.class.getName(),"==== Query [수행시간  : " + runningTime + " ms]");
		
		return doExcute_result;
	}
	
	// 모니터링 일지 등록
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
	    				.append("	haccp_ccp_4p (				\n")
	    				.append("		checklist_id,			\n")
	    				.append("		checklist_rev_no,		\n")
	    				.append("		ccp_date,				\n")
	    				.append("       person_write_id, 		\n")
	    				.append("       unsuit_detail,			\n")
	    				.append("       improve_action_result	\n")
	    				.append(" 		)						\n")
	    				.append("VALUES (											\n")
						.append(" 		'"	+ jArray.get("checklist_id") + "',		\n")
						.append(" 		'"	+ jArray.get("checklist_rev_no") + "',	\n")
						.append(" 		'"	+ jArray.get("ccp_date") + "',			\n")
						.append(" 		'"	+ jArray.get("person_write_id") + "',	\n")
						.append(" 		'"	+ jArray.get("unsuit_detail") + "',		\n")
						.append(" 		'"	+ jArray.get("improve_action_result") + "' \n")
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
				LoggingWriter.setLogError("M838S015400E101()","==== SQL ERROR ===="+ e.getMessage());
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
		
		// 측정일지 등록
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
			    				.append("INSERT INTO					\n")
			    				.append("	haccp_ccp_4p_head (			\n")
			    				.append("		checklist_id,			\n")
			    				.append("		checklist_rev_no,		\n")
			    				.append(" 		ccp_date,				\n")
			    				.append("		prod_cd,				\n")
			    				.append("       revision_no, 			\n")
			    				.append(" 		note_unusual			\n")
			    				.append(" 		)						\n")
			    				.append("VALUES (											\n")
			    				.append(" 		'"	+ jArray.get("checklist_id") + "',		\n")
								.append(" 		'"	+ jArray.get("checklist_rev_no") + "',	\n")
								.append(" 		'"	+ jArray.get("ccp_date") + "',			\n")
								.append(" 		'"	+ jArray.get("prod_cd") + "',			\n")
								.append(" 		'"	+ jArray.get("revision_no") + "',		\n")
								.append(" 		'"	+ jArray.get("note_unusual") + "'		\n")
								.append("	) 												\n")
								.toString();
					
						resultInt = super.excuteUpdate(con, sql.toString());
				    	if(resultInt < 0){
							ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
							con.rollback();
							return EventDefine.E_DOEXCUTE_ERROR ;
						}
			    		
			    		
			    		String fe_only1 = jArray.get("fe_only_1").toString();
			    		String fe_only2 = jArray.get("fe_only_2").toString();
			    		String fe_only3 = jArray.get("fe_only_3").toString();
			    		String fe_only = fe_only1+fe_only2 +fe_only3; 
			    		
			    		String sus_only1 = jArray.get("sus_only_1").toString();
			    		String sus_only2 = jArray.get("sus_only_2").toString();
			    		String sus_only3 = jArray.get("sus_only_3").toString();
			    		String sus_only = sus_only1+sus_only2 +sus_only3; 
			    		
			    		String prod_only1 = jArray.get("prod_only_1").toString();
			    		String prod_only2 = jArray.get("prod_only_2").toString();
			    		String prod_only3 = jArray.get("prod_only_3").toString();
			    		String prod_only = prod_only1+prod_only2 +prod_only3; 
			    		
			    		String fe_with_prod1 = jArray.get("fe_with_prod_1").toString();
			    		String fe_with_prod2 = jArray.get("fe_with_prod_2").toString();
			    		String fe_with_prod3 = jArray.get("fe_with_prod_3").toString();
			    		String fe_with_prod4 = jArray.get("fe_with_prod_4").toString();
			    		String fe_with_prod5 = jArray.get("fe_with_prod_5").toString();
			    		String fe_with_prod = fe_with_prod1+fe_with_prod2 +fe_with_prod3
			    							  + fe_with_prod4 + fe_with_prod5;
			    		
			    		String sus_with_prod1 = jArray.get("sus_with_prod_1").toString();
			    		String sus_with_prod2 = jArray.get("sus_with_prod_2").toString();
			    		String sus_with_prod3 = jArray.get("sus_with_prod_3").toString();
			    		String sus_with_prod4 = jArray.get("sus_with_prod_4").toString();
			    		String sus_with_prod5 = jArray.get("sus_with_prod_5").toString();
			    		String sus_with_prod = sus_with_prod1+sus_with_prod2 +sus_with_prod3
			    							  + sus_with_prod4 + sus_with_prod5;
			    		
			    			sql = new StringBuilder()
			    				.append("INSERT INTO					\n")
			    				.append("	haccp_ccp_4p_detail (			\n")
			    				.append("		checklist_id,			\n")
			    				.append("		checklist_rev_no,		\n")
			    				.append(" 		ccp_date,				\n")
			    				.append("		check_time,				\n")
			    				.append("		prod_cd,				\n")
			    				.append("       revision_no, 			\n")
			    				.append("		fe_only,				\n")
			    				.append("		sus_only,				\n")
			    				.append("		prod_only,				\n")
			    				.append("		fe_with_prod,			\n")
			    				.append("		sus_with_prod,			\n")
			    				.append(" 		result					\n")
			    				.append(" 		)						\n")
			    				.append("VALUES (											\n")
			    				.append(" 		'"	+ jArray.get("checklist_id") + "',		\n")
								.append(" 		'"	+ jArray.get("checklist_rev_no") + "',	\n")
								.append(" 		'"	+ jArray.get("ccp_date") + "',			\n")
								.append(" 		'"	+ jArray.get("check_time") + "',		\n")
								.append(" 		'"	+ jArray.get("prod_cd") + "',			\n")
								.append(" 		'"	+ jArray.get("revision_no") + "',		\n")
								.append(" 		'"	+ fe_only + "',			\n")
								.append(" 		'"	+ sus_only + "',			\n")
								.append(" 		'"	+ prod_only + "',			\n")
								.append(" 		'"	+ fe_with_prod + "',		\n")
								.append(" 		'"	+ sus_with_prod + "',		\n")
								.append(" 		'"	+ jArray.get("result") + "'			\n")
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
						LoggingWriter.setLogError("M838S015400E111()","==== SQL ERROR ===="+ e.getMessage());
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
		
	
		// 모니터링 일지 수정
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
			    				.append("	haccp_ccp_4p SET									  				\n")
			    				.append("       unsuit_detail   = '" + jArray.get("unsuit_detail") + "', 		\n")
			    				.append("       improve_action_result   = '" + jArray.get("improve_action_result") + "', \n")
			    				.append("       person_write_id   = '" + jArray.get("person_write_id") + "', 	\n")
			    				.append("WHERE ccp_date = 		'"+ jArray.get("ccp_date") + "'					\n")
			    				
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
						LoggingWriter.setLogError("M838S015400E102()","==== SQL ERROR ===="+ e.getMessage());
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
				
				// 측정일지 수정
				public int E112(InoutParameter ioParam){ 
					
					String sql = "";
					
					resultInt = EventDefine.E_DOEXCUTE_INIT;

					try {
						con = JDBCConnectionPool.getConnection();
						con.setAutoCommit(false);
						
			    		JSONObject jArray = new JSONObject();
			    		jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			    		System.out.println("JSONObject jArray rcvData="+ jArray.toString());
			    		
			    		String fe_only1 = jArray.get("fe_only_1").toString();
			    		String fe_only2 = jArray.get("fe_only_2").toString();
			    		String fe_only3 = jArray.get("fe_only_3").toString();
			    		String fe_only = fe_only1+fe_only2 +fe_only3; 
			    		
			    		String sus_only1 = jArray.get("sus_only_1").toString();
			    		String sus_only2 = jArray.get("sus_only_2").toString();
			    		String sus_only3 = jArray.get("sus_only_3").toString();
			    		String sus_only = sus_only1+sus_only2 +sus_only3; 
			    		
			    		String prod_only1 = jArray.get("prod_only_1").toString();
			    		String prod_only2 = jArray.get("prod_only_2").toString();
			    		String prod_only3 = jArray.get("prod_only_3").toString();
			    		String prod_only = prod_only1+prod_only2 +prod_only3; 
			    		
			    		String fe_with_prod1 = jArray.get("fe_with_prod_1").toString();
			    		String fe_with_prod2 = jArray.get("fe_with_prod_2").toString();
			    		String fe_with_prod3 = jArray.get("fe_with_prod_3").toString();
			    		String fe_with_prod4 = jArray.get("fe_with_prod_4").toString();
			    		String fe_with_prod5 = jArray.get("fe_with_prod_5").toString();
			    		String fe_with_prod = fe_with_prod1+fe_with_prod2 +fe_with_prod3
			    							  + fe_with_prod4 + fe_with_prod5;
			    		
			    		String sus_with_prod1 = jArray.get("sus_with_prod_1").toString();
			    		String sus_with_prod2 = jArray.get("sus_with_prod_2").toString();
			    		String sus_with_prod3 = jArray.get("sus_with_prod_3").toString();
			    		String sus_with_prod4 = jArray.get("sus_with_prod_4").toString();
			    		String sus_with_prod5 = jArray.get("sus_with_prod_5").toString();
			    		String sus_with_prod = sus_with_prod1+sus_with_prod2 +sus_with_prod3
			    							  + sus_with_prod4 + sus_with_prod5;
			    		
			    		sql = new StringBuilder()
			    				.append("UPDATE														  \n")
			    				.append("	haccp_ccp_4p_detail SET								 	  \n")
			    				.append("		check_time 	 = '"	+ jArray.get("check_time") + "',  \n")
			    				.append("		prod_cd 	 = '"	+ jArray.get("prod_cd") + "', 	  \n")
			    				.append("		revision_no  = '"	+ jArray.get("revision_no") + "', \n")
			    				.append("       fe_only 	 = '"	+ fe_only + "',	  	  			  \n")
			    				.append("       sus_only 	 = '"	+ sus_only + "',		  	 	  \n")
			    				.append("       prod_only 	 = '"	+ prod_only + "',		  		  \n")
			    				.append("       fe_with_prod = '"	+ fe_with_prod + "', 			  \n")
			    				.append(" 		sus_with_prod  = '"	+ sus_with_prod + "', 			  \n")
			    				.append("       result = '"	+ jArray.get("result") + "' 			  \n")
			    				.append("WHERE check_time =  '"+ jArray.get("check_time") + "' 		  \n")
								.toString();
					
						resultInt = super.excuteUpdate(con, sql.toString());
				    	if(resultInt < 0){
							ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
							con.rollback();
							return EventDefine.E_DOEXCUTE_ERROR ;
						}
				    	
				    	sql = new StringBuilder()
			    				.append("UPDATE														  \n")
			    				.append("	haccp_ccp_4p_head SET								 	  \n")
			    				.append("		checklist_id 	 = '"	+ jArray.get("checklist_id") + "', \n")
			    				.append("       checklist_rev_no = (SELECT MAX(checklist_rev_no) 	  \n")
			    				.append("                          	FROM checklist  	  			  \n")
			    				.append("                           WHERE checklist_id = '"	+ jArray.get("checklist_id") + "'), \n")
			    				.append("		prod_cd 	 = '"	+ jArray.get("prod_cd") + "', 	  \n")
			    				.append("		revision_no  = "	+ jArray.get("revision_no") + ",  \n")
			    				.append(" 		note_unusual = '"	+ jArray.get("note_unusual") + "' \n")
			    				.append("WHERE ccp_date =  '"+ jArray.get("ccp_date") + "' 		  \n")
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
						LoggingWriter.setLogError("M838S015400E112()","==== SQL ERROR ===="+ e.getMessage());
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
				
		
				// 모니터링 일지 삭제
				public int E103(InoutParameter ioParam){ 
					resultInt = EventDefine.E_DOEXCUTE_INIT;

					try {
						con = JDBCConnectionPool.getConnection();
						con.setAutoCommit(false);
						
			    		JSONObject jArray = new JSONObject();
			    		jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			    		System.out.println("JSONObject jArray rcvData="+ jArray.toString());

			    		String sql = new StringBuilder()
			    				.append("DELETE FROM										\n")
			    				.append("	haccp_ccp_4p									\n")
			    				.append("WHERE ccp_date = '"+ jArray.get("ccp_date") + "'	\n")
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
						LoggingWriter.setLogError("M838S015400E103()","==== SQL ERROR ===="+ e.getMessage());
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
				
				
				// 모니터링 일지 내 측정일지 삭제
				public int E113(InoutParameter ioParam){ 
					resultInt = EventDefine.E_DOEXCUTE_INIT;
					
					String sql = "";

					try {
						con = JDBCConnectionPool.getConnection();
						con.setAutoCommit(false);
						
			    		JSONObject jArray = new JSONObject();
			    		jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			    		System.out.println("JSONObject jArray rcvData="+ jArray.toString());
			    		
			    		sql = new StringBuilder()
			    				.append("DELETE FROM													 \n")
			    				.append("	haccp_ccp_4p_head										 	 \n")
			    				.append("WHERE ccp_date=  '"+ jArray.get("ccp_date") + "'			 	 \n")
			    				.append("AND prod_cd =  '"+ jArray.get("prod_cd") + "' 				 	 \n")
			    				.append("AND revision_no =  '"+ jArray.get("revision_no") + "' 			 \n")
								.toString();
					
						resultInt = super.excuteUpdate(con, sql.toString());
				    	if(resultInt < 0){
							ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
							con.rollback();
							return EventDefine.E_DOEXCUTE_ERROR ;
						}
			    		
			    		sql = new StringBuilder()
			    				.append("DELETE FROM													 \n")
			    				.append("	haccp_ccp_4p_detail 										 \n")
			    				.append("WHERE check_time =  '"+ jArray.get("check_time") + "'			 \n")
			    				.append("AND ccp_date =  '"+ jArray.get("ccp_date") + "' 				 \n")
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
						LoggingWriter.setLogError("M838S015400E113()","==== SQL ERROR ===="+ e.getMessage());
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
	
	
	// CCP-2P 모니터링일지 메인 테이블 조회
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
					.append("   A.ccp_date, 			\n")
					.append("   A.unsuit_detail, 		\n")
					.append("   A.improve_action_result,\n")
					.append("   C.user_nm, 				\n")
					.append("   A.person_write_id, 		\n")
					.append("   C2.user_nm, 			\n")
					.append("   A.person_action_id, 	\n")
					.append("   C3.user_nm,				\n")
					.append("   A.person_check_id, 		\n")
					.append("   C4.user_nm,				\n")
					.append("   A.person_approve_id 		\n")
					.append("FROM											\n")
					.append("	haccp_ccp_4p A								\n")
					.append("INNER JOIN tbm_users C							\n")
					.append("ON A.person_write_id = C.user_id				\n")
					.append("AND  A.ccp_date BETWEEN CAST(C.start_date AS DATE) AND CAST(C.duration_date AS DATE) \n")
					.append("LEFT JOIN tbm_users C2							\n")
					.append("ON A.person_action_id = C2.user_id			\n")
					.append("AND  A.ccp_date BETWEEN CAST(C2.start_date AS DATE) AND CAST(C2.duration_date AS DATE) \n")
					.append("LEFT JOIN tbm_users C3							\n")
					.append("ON A.person_action_id = C3.user_id			\n")
					.append("AND  A.ccp_date BETWEEN CAST(C3.start_date AS DATE) AND CAST(C3.duration_date AS DATE) \n")
					.append("LEFT JOIN tbm_users C4							\n")
					.append("ON A.person_check_id = C4.user_id			\n")
					.append("AND  A.ccp_date BETWEEN CAST(C4.start_date AS DATE) AND CAST(C4.duration_date AS DATE) \n")
					.append("WHERE A.ccp_date Between '"+ jArray.get("fromdate") + "' \n")
					.append("                   AND '"+ jArray.get("todate") + "' 		\n")
					
					
					
					
					.append("GROUP BY A.ccp_date 										\n")
					.toString();

			String ActionCommand = ioParam.getActionCommand();
			if(ActionCommand.startsWith("doQueryTableFieldName")) {
				resultString = super.excuteQueryStringTableFieldName(con, sql.toString());
			} else {
				resultString = super.excuteQueryString(con, sql.toString());
			}
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M838S015400E104()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) {
						con.close();
					}
				} catch (Exception e) {
					LoggingWriter.setLogError("M838S015400E104()","==== finally ===="+ e.getMessage());
				}
	    	}
	    }

		ioParam.setResultString(resultString);
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
    	ioParam.setMessage(MessageDefine.M_QUERY_OK);

    	return EventDefine.E_QUERY_RESULT;
	}
	
	// 모니터링 일지 서브 테이블 조회
		// yumsam 
		public int E114(InoutParameter ioParam){
			resultInt = EventDefine.E_DOEXCUTE_INIT;
			
			try {
				con = JDBCConnectionPool.getConnection();
				
				JSONObject jArray = new JSONObject();
				jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));

				String sql = new StringBuilder()
						.append("SELECT\n")
						.append("   A.ccp_date, 				   \n")
						.append("   A.check_time,				   \n")
						.append("   D.product_nm, 				   \n")
						.append("   A.prod_cd, 					   \n")
						.append("   A.revision_no, 				   \n")
						.append("   A.fe_only, 				   	   \n")
						.append("   A.sus_only, 				   \n")
						.append("   A.prod_only, 				   \n")
						.append("   A.fe_with_prod, 			   \n")
						.append("   A.sus_with_prod, 			   \n")
						.append("   A.result,  					   \n")
						.append("   C.user_nm, 					   \n")
						.append("   A.person_sign_id, 			   \n")
						.append("   B.note_unusual			   	   \n")
						.append("FROM haccp_ccp_4p_detail A  	   \n")
						.append("INNER JOIN haccp_ccp_4p_head B    \n")
						.append("ON A.prod_cd = B.prod_cd 		   \n")
						.append("AND A.revision_no = B.revision_no \n")
						.append("AND A.ccp_date = B.ccp_date 	   \n")
						.append("INNER JOIN tbm_product D 		   \n")
						.append("ON A.prod_cd = D.prod_cd 		   \n")
						.append("AND A.revision_no = D.revision_no \n")
						.append("LEFT JOIN tbm_users C								  \n")
						.append("ON A.person_sign_id = C.user_id					  \n")
						.append("AND  A.ccp_date BETWEEN CAST(C.start_date AS DATE) AND CAST(C.duration_date AS DATE) \n")
						.append("WHERE A.ccp_date = '"+ jArray.get("ccp_date") + "'   \n")
						.append("ORDER BY A.check_time 								  \n")
						.toString();

				String ActionCommand = ioParam.getActionCommand();
				if(ActionCommand.startsWith("doQueryTableFieldName")) {
					resultString = super.excuteQueryStringTableFieldName(con, sql.toString());
				} else {
					resultString = super.excuteQueryString(con, sql.toString());
				}
			} catch(Exception e) {
				e.printStackTrace();
				LoggingWriter.setLogError("M838S015400E114()","==== SQL ERROR ===="+ e.getMessage());
				return EventDefine.E_DOEXCUTE_ERROR ;
		    } finally {
		    	if (Config.useDataSource) {
					try {
						if (con != null) {
							con.close();
						}
					} catch (Exception e) {
						LoggingWriter.setLogError("M838S015400E114()","==== finally ===="+ e.getMessage());
					}
		    	}
		    }

			ioParam.setResultString(resultString);
			ioParam.setColumnCount("" + super.COLUMN_COUNT);
	    	ioParam.setMessage(MessageDefine.M_QUERY_OK);

	    	return EventDefine.E_QUERY_RESULT;
		}
	
	
	// S838S015300_canvas.jsp
	public int E144(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			
			String sql = new StringBuilder()
					.append("SELECT\n")
					.append("	A.checklist_id,			\n")
					.append("	A.checklist_rev_no,		\n")
					.append("   A.ccp_date, 			\n")
					.append("   A.unsuit_detail, 		\n")
					.append("   A.improve_action_result,\n")
					.append("   C.user_nm, 				\n")
					.append("   C2.user_nm, 			\n")
					.append("   C3.user_nm,				\n")
					.append("   C4.user_nm,				\n")
					.append("   B.check_time, 			\n")
					.append("   E.product_nm, 			\n")
					.append("   B.fe_only, 				\n")
					.append("   B.sus_only, 			\n")
					.append("   B.prod_only, 			\n")
					.append("   B.fe_with_prod, 		\n")
					.append("   B.sus_with_prod, 		\n")
					.append("   B.result, 				\n")
					.append("   C5.user_nm				\n")
					.append("FROM											\n")
					.append("	haccp_ccp_4p A								\n")
					.append("INNER JOIN haccp_ccp_4p_detail B				\n")
					.append("ON A.ccp_date = B.ccp_date						\n")
					.append("INNER JOIN tbm_product E 						\n")
					.append("ON B.prod_cd = E.prod_cd 						\n")
					.append("AND B.revision_no = E.revision_no				\n")
					.append("INNER JOIN tbm_users C							\n")
					.append("ON A.person_write_id = C.user_id				\n")
					.append("AND  A.ccp_date BETWEEN CAST(C.start_date AS DATE) AND CAST(C.duration_date AS DATE) \n")
					.append("LEFT JOIN tbm_users C2							\n")
					.append("ON A.person_approve_id = C2.user_id			\n")
					.append("AND  A.ccp_date BETWEEN CAST(C2.start_date AS DATE) AND CAST(C2.duration_date AS DATE) \n")
					.append("LEFT JOIN tbm_users C3							\n")
					.append("ON A.person_action_id = C3.user_id				\n")
					.append("AND  A.ccp_date BETWEEN CAST(C3.start_date AS DATE) AND CAST(C3.duration_date AS DATE) \n")
					.append("LEFT JOIN tbm_users C4							\n")
					.append("ON A.person_check_id = C4.user_id				\n")
					.append("AND  A.ccp_date BETWEEN CAST(C4.start_date AS DATE) AND CAST(C4.duration_date AS DATE) \n")
					.append("LEFT JOIN tbm_users C5							\n")
					.append("ON B.person_sign_id = C5.user_id				\n")
					.append("AND  A.ccp_date BETWEEN CAST(C5.start_date AS DATE) AND CAST(C5.duration_date AS DATE) \n")
					.append("WHERE A.ccp_date = '"+ jArray.get("ccp_date") + "' \n")
					.append("GROUP BY B.check_time 								\n")
					.toString();
			
			String ActionCommand = ioParam.getActionCommand();
			if(ActionCommand.startsWith("doQueryTableFieldName")) {
				resultString = super.excuteQueryStringTableFieldName(con, sql.toString());
			} else {
				resultString = super.excuteQueryString(con, sql.toString());
			}
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M838S015400E144()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M838S015400E144()","==== finally ===="+ e.getMessage());
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
	
	
	// S838S015300_canvas.jsp
		public int E154(InoutParameter ioParam){
			resultInt = EventDefine.E_DOEXCUTE_INIT;
			
			try {
				con = JDBCConnectionPool.getConnection();
				
				JSONObject jArray = new JSONObject();
				jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
				
				String sql = new StringBuilder()
						.append("SELECT\n")
						.append("   A.ccp_date, 			\n")
						.append("   E.product_nm, 			\n")
						.append("   A.fe_only, 				\n")
						.append("   A.sus_only, 			\n")
						.append("   A.prod_only, 			\n")
						.append("   A.fe_with_prod, 		\n")
						.append("   A.sus_with_prod, 		\n")
						.append("   B.note_unusual 			\n")
						.append("FROM											\n")
						.append("	haccp_ccp_4p_detail A						\n")
						.append("INNER JOIN haccp_ccp_4p_head B					\n")
						.append("ON A.ccp_date = B.ccp_date						\n")
						.append("AND A.prod_cd = B.prod_cd						\n")
						.append("AND A.revision_no = B.revision_no				\n")
						.append("INNER JOIN tbm_product E 						\n")
						.append("ON A.prod_cd = E.prod_cd 						\n")
						.append("AND B.revision_no = E.revision_no				\n")
						.append("WHERE A.ccp_date = '"+ jArray.get("ccp_date") + "' \n")
						.append("GROUP BY A.prod_cd 								\n")
						.toString();
				
				String ActionCommand = ioParam.getActionCommand();
				if(ActionCommand.startsWith("doQueryTableFieldName")) {
					resultString = super.excuteQueryStringTableFieldName(con, sql.toString());
				} else {
					resultString = super.excuteQueryString(con, sql.toString());
				}
			} catch(Exception e) {
				e.printStackTrace();
				LoggingWriter.setLogError("M838S015400E154()","==== SQL ERROR ===="+ e.getMessage());
				return EventDefine.E_DOEXCUTE_ERROR ;
		    } finally {
		    	if (Config.useDataSource) {
					try {
						if (con != null) con.close();
					} catch (Exception e) {
						LoggingWriter.setLogError("M838S015400E154()","==== finally ===="+ e.getMessage());
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
			    				.append("UPDATE haccp_ccp_4p											\n")
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
				
				// 점검표 조치자 서명
				public int E512(InoutParameter ioParam){ 
					
					resultInt = EventDefine.E_DOEXCUTE_INIT;

					try {
						con = JDBCConnectionPool.getConnection();
						con.setAutoCommit(false);
						
						JSONObject jObj = new JSONObject();
			    		jObj = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			    		
			    		String sql = new StringBuilder()
			    				.append("UPDATE haccp_ccp_4p											\n")
			    				.append("SET															\n")
			    				.append("	person_action_id = '" + jObj.get("userId") + "'				\n")
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
						LoggingWriter.setLogError("M838S015300E512()","==== SQL ERROR ===="+ e.getMessage());
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
				    				.append("UPDATE haccp_ccp_4p											\n")
				    				.append("SET															\n")
				    				.append("	person_check_id = '" + jObj.get("userId") + "'				\n")
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
					
					// 측정일지 서명인 서명
					public int E532(InoutParameter ioParam){ 
						
						resultInt = EventDefine.E_DOEXCUTE_INIT;

						try {
							con = JDBCConnectionPool.getConnection();
							con.setAutoCommit(false);
							
							JSONObject jObj = new JSONObject();
				    		jObj = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
				    		
				    		String sql = new StringBuilder()
				    				.append("UPDATE haccp_ccp_4p_detail										\n")
				    				.append("SET															\n")
				    				.append("	person_sign_id = '" + jObj.get("userId") + "'				\n")
				    				.append("WHERE ccp_date = '"+ jObj.get("checklistDate") + "'			\n")
				    				.append("  AND check_time = '"+ jObj.get("checkTime") + "'				\n")
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
							LoggingWriter.setLogError("M838S015100E532()","==== SQL ERROR ===="+ e.getMessage());
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