package mes.frame.business.M909;

import java.lang.reflect.Method;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.util.Vector;

import org.json.simple.JSONObject;

import mes.client.conf.Config;
import mes.client.conf.ProjectConstants;
import mes.frame.common.EventDefine;
import mes.frame.common.HashObject;
import mes.frame.common.MessageDefine;
import mes.frame.database.JDBCConnectionPool;
import mes.frame.database.SqlAdapter;
import mes.frame.serviceinterface.InoutParameter;
import mes.frame.serviceinterface.LoggingWriter;
import mes.frame.util.CommonFunction;
import mes.frame.util.PasswordHash;


public class M909S115100 extends SqlAdapter{
	Connection con = null;
	Connection con_Mysql = null;
	PreparedStatement pstmt = null;
	String resultString = "";
	int resultInt = -1;
	StringBuffer sql = new StringBuffer();
	
	String[][] v_paramArray = new String[0][0]; 
	Class[] optClass = null;
	Object[] optObj = null;
	Object obj = null;
	
	public M909S115100(){
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

			Method method = M909S115100.class.getMethod(event,optClass);
			LoggingWriter.setLogDebug(M909S115100.class.getName(),"==== " + event + " EventMethod Create Success ====");

			obj = method.invoke(M909S115100.class.newInstance(),optObj);
			doExcute_result = CommonFunction.getInt(obj.toString());
			
	    } catch (Exception ex) {
	    	doExcute_result = EventDefine.E_DOEXCUTE_INIT;
			ioParam.setMessage(MessageDefine.M_NO_EVENTID);
			LoggingWriter.setLogError(M909S115100.class.getName(),"==== EventID Not define : EVENT ID [ " + ioParam.getEventID() + "]");
	    } finally {
	    	obj = null;
			optClass = null;
			optObj = null;
	    }
	    long endTime = System.currentTimeMillis();
		long runningTime = endTime - startTime;
		LoggingWriter.setLogAll(M909S115100.class.getName(),"==== Query [수행시간  : " + runningTime + " ms]");
		
		return doExcute_result;
	}
	
	// 배송기사 정보 등록
	public int E101(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jObj = new JSONObject();
			jObj = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			
			String sql = new StringBuilder()
				.append("INSERT INTO tbm_vehicle_users ( 			\n")
				.append("	user_id,								\n")
				.append("	user_rev_no,							\n")
				.append("	cust_gubun,								\n")
				.append("	vehicle_cd,								\n")
				.append("	vehicle_rev_no,							\n")
				.append("	start_date,								\n")
				.append("	create_date,							\n")
				.append("	create_user_id,							\n")
				.append("	modify_date,							\n")
				.append("	modify_user_id,							\n")
				.append("	duration_date							\n")
				.append(")											\n")
				.append("VALUES (			 						\n")
				.append(" 	'" + jObj.get("driver_id") + "', 		\n")
				.append(" 	'" + jObj.get("driver_rev_no") + "', 	\n")
				.append(" 	'" + jObj.get("location_cd") + "', 		\n")
				.append(" 	'" + jObj.get("vehicle_cd") + "',		\n")
				.append(" 	'" + jObj.get("vehicle_rev_no") + "',	\n")
				.append(" 	SYSDATE,								\n")
				.append(" 	SYSDATETIME, 							\n")
				.append(" 	'" + jObj.get("user_id") + "', 			\n")
				.append("	SYSDATETIME,							\n")
				.append(" 	'" + jObj.get("user_id") + "', 			\n")
				.append("	'9999-12-31'							\n")
				.append(")											\n")
				.toString();
					
			resultInt = super.excuteUpdate(con, sql);
			
			if (resultInt < 0) {
				ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
				con.rollback();
		    	System.out.println("E101 에러 리턴값: " + EventDefine.E_DOEXCUTE_ERROR);
				return EventDefine.E_DOEXCUTE_ERROR ;
			}
			con.commit();
			
		} catch(Exception e) {
			LoggingWriter.setLogError("M909S115100E101()","==== SQL ERROR ===="+ e.getMessage() + "\n" + sql.toString());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M909S115100E101()","==== finally ===="+ e.getMessage());
				}
	    	} else {
	    	}
	    }
		ioParam.setResultString(resultString);
		ioParam.setColumnCount("" + super.COLUMN_COUNT);

		return EventDefine.E_QUERY_RESULT;
	}
	
	// 가맹점 배송순서 신규등록
		public int E111(InoutParameter ioParam){
			resultInt = EventDefine.E_DOEXCUTE_INIT;
			String sql = "";
			
			try {
				con = JDBCConnectionPool.getConnection();
				
				JSONObject jObj = new JSONObject();
				jObj = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
				
				String aa = jObj.get("deliver_index").toString();
				String bb = jObj.get("deliver_index_max").toString();
				
				int deliver_index = Integer.parseInt(aa);
				int deliver_index_max = Integer.parseInt(bb);
				
				if(deliver_index <= deliver_index_max) {
				
				// ex) 순번 1,2,3이 있을 때 
				//  순번 1으로 등록시 
				// 기존 순번들을 찾아 + 1 해준다.	
					
				sql = new StringBuilder()
					.append("UPDATE tbm_customer SET 							\n")
					.append("	refno = refno + 1								\n")
					.append(" WHERE company_type_m = '" + jObj.get("location_nm") + "' 	\n")
					.append(" AND refno >= '" + jObj.get("deliver_index") + "'  \n")
					.append(" AND refno <  '" + jObj.get("deliver_index_max") + "'    \n")
					.append("													\n")
					.toString();
						
				resultInt = super.excuteUpdate(con, sql);
				
				if (resultInt < 0) {
					ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
					con.rollback();
			    	System.out.println("E111 에러 리턴값: " + EventDefine.E_DOEXCUTE_ERROR);
					return EventDefine.E_DOEXCUTE_ERROR ;
				 }
			  }
				// ex) 순번 1,2,3이 있을 때 
				//  순번 2으로 등록시 2,3만 바뀌면 되므로
				// 해당 순번들을 찾아 + 1 해준다.		
				
				else {
					sql = new StringBuilder()
						.append("UPDATE tbm_customer SET 							\n")
						.append("	refno = refno - 1								\n")
						.append(" WHERE company_type_m = '" + jObj.get("location_nm") + "' 	\n")
						.append(" AND refno =< '" + jObj.get("deliver_index") + "'  \n")
						.append(" AND refno > '" + jObj.get("deliver_index_max") + "'    \n")
						.append("													\n")
						.toString();
					
					resultInt = super.excuteUpdate(con, sql);
					
					if (resultInt < 0) {
						ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
						con.rollback();
				    	System.out.println("E111 에러 리턴값: " + EventDefine.E_DOEXCUTE_ERROR);
						return EventDefine.E_DOEXCUTE_ERROR ;
					 }
					
				}
				// 해당 가맹점 순번을 update 한다.	
				
					sql = new StringBuilder()
					.append("UPDATE tbm_customer SET 							\n")
					.append("	refno = '" + jObj.get("deliver_index") + "',	\n")
					.append("	modify_date = SYSDATETIME,						\n")
					.append("	modify_user_id = '" + jObj.get("user_id") + "', \n")
					.append("	modify_reason = '배송순서등록'						\n")
					.append(" WHERE cust_cd = '" + jObj.get("cust_cd") + "' 	\n")
					.append("													\n")
					.toString();
					
				resultInt = super.excuteUpdate(con, sql);
					
				if (resultInt < 0) {
					ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
					con.rollback();
				    System.out.println("E111 에러 리턴값: " + EventDefine.E_DOEXCUTE_ERROR);
					return EventDefine.E_DOEXCUTE_ERROR ;
				}
				
				con.commit();
				
			} catch(Exception e) {
				LoggingWriter.setLogError("M909S115100E111()","==== SQL ERROR ===="+ e.getMessage() + "\n" + sql.toString());
				return EventDefine.E_DOEXCUTE_ERROR ;
		    } finally {
		    	if (Config.useDataSource) {
					try {
						if (con != null) con.close();
					} catch (Exception e) {
						LoggingWriter.setLogError("M909S115100E111()","==== finally ===="+ e.getMessage());
					}
		    	} else {
		    	}
		    }
			ioParam.setResultString(resultString);
			ioParam.setColumnCount("" + super.COLUMN_COUNT);

			return EventDefine.E_QUERY_RESULT;
		}
		
		// 차량정보 등록
		public int E121(InoutParameter ioParam){
			resultInt = EventDefine.E_DOEXCUTE_INIT;
			
			try {
				con = JDBCConnectionPool.getConnection();
				
				JSONObject jObj = new JSONObject();
				jObj = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
				
				String sql = new StringBuilder()
					.append("INSERT INTO tbm_vehicle ( 					\n")
					.append("	vehicle_cd,								\n")
					.append("	vehicle_rev_no,							\n")
					.append("	vehicle_nm,								\n")
					.append("	vehicle_model,							\n")
					.append("	vehicle_maker,							\n")
					.append("	vehicle_type,							\n")
					.append("	bigo,									\n")
					.append("	start_date,								\n")
					.append("	create_date,							\n")
					.append("	create_user_id,							\n")
					.append("	modify_date,							\n")
					.append("   modify_reason, 							\n")
					.append("	duration_date							\n")
					.append(")											\n")
					.append("VALUES (			 						\n")
					.append(" 	'" + jObj.get("vehicle_cd") + "', 		\n")
					.append(" 	'" + jObj.get("vehicle_rev_no") + "', 	\n")
					.append(" 	'" + jObj.get("vehicle_nm") + "', 		\n")
					.append(" 	'" + jObj.get("vehicle_model") + "',	\n")
					.append(" 	'" + jObj.get("vehicle_maker") + "',	\n")
					.append(" 	'" + jObj.get("vehicle_type") + "',		\n")
					.append(" 	'" + jObj.get("bigo") + "',				\n")
					.append(" 	SYSDATE,								\n")
					.append(" 	SYSDATETIME, 							\n")
					.append(" 	'" + jObj.get("user_id") + "', 			\n")
					.append("	SYSDATETIME,							\n")
					.append("	'최초등록',								\n")
					.append("	'9999-12-31'							\n")
					.append(")											\n")
					.toString();
						
				resultInt = super.excuteUpdate(con, sql);
				
				if (resultInt < 0) {
					ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
					con.rollback();
			    	System.out.println("E121 에러 리턴값: " + EventDefine.E_DOEXCUTE_ERROR);
					return EventDefine.E_DOEXCUTE_ERROR ;
				}
				con.commit();
				
			} catch(Exception e) {
				LoggingWriter.setLogError("M909S115100E121()","==== SQL ERROR ===="+ e.getMessage() + "\n" + sql.toString());
				return EventDefine.E_DOEXCUTE_ERROR ;
		    } finally {
		    	if (Config.useDataSource) {
					try {
						if (con != null) con.close();
					} catch (Exception e) {
						LoggingWriter.setLogError("M909S115100E121()","==== finally ===="+ e.getMessage());
					}
		    	} else {
		    	}
		    }
			ioParam.setResultString(resultString);
			ioParam.setColumnCount("" + super.COLUMN_COUNT);

			return EventDefine.E_QUERY_RESULT;
		}	
	
	
	//배송기사 정보 수정
	public int E102(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jObj = new JSONObject();
			jObj = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));

			String sql = new StringBuilder()
					.append("UPDATE tbm_vehicle_users SET  								\n")
					.append("	user_id = '" + jObj.get("driver_id") +"',				\n")
					.append("	cust_gubun = '" + jObj.get("location_cd") +"',			\n")
					.append("	vehicle_cd = '" + jObj.get("vehicle_cd") +"',			\n")
					.append("	modify_date = SYSDATETIME,								\n")
					.append("	modify_user_id = '" + jObj.get("user_id") +"'			\n")
					.append("WHERE user_id = '" + jObj.get("driver_id") +"'				\n")
					.toString();
					
			resultInt = super.excuteUpdate(con, sql);
			
			if (resultInt < 0) {
				ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
				con.rollback();
		    	System.out.println("E102 에러 리턴값: " + EventDefine.E_DOEXCUTE_ERROR);
				return EventDefine.E_DOEXCUTE_ERROR ;
			}
			con.commit();
			
		} catch(Exception e) {
			LoggingWriter.setLogError("M909S115100E102()","==== SQL ERROR ===="+ e.getMessage() + "\n" + sql.toString());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M909S115100E102()","==== finally ===="+ e.getMessage());
				}
	    	} else {
	    	}
	    }

		ioParam.setResultString(resultString);
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
		
	    return EventDefine.E_QUERY_RESULT;
	}
	
	// 가맹점 배송순서 수정
			public int E112(InoutParameter ioParam){
				resultInt = EventDefine.E_DOEXCUTE_INIT;
				String sql = "";
				
				try {
					con = JDBCConnectionPool.getConnection();
					
					JSONObject jObj = new JSONObject();
					jObj = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
					
					String aa = jObj.get("deliver_index").toString();
					String bb = jObj.get("deliver_index_before").toString();
					
					int deliver_index = Integer.parseInt(aa);
					int deliver_index_before = Integer.parseInt(bb);
					
					if(deliver_index <= deliver_index_before) {
					
					// ex) 순번 10 -> 8으로 변경시 
				    // 기존 8~9만 9 ~10으로 변경되면 되므로
					// 찾아서 + 1 해준다.
					sql = new StringBuilder()
							.append("UPDATE tbm_customer SET 							\n")
							.append("	refno = refno + 1								\n")
							.append(" WHERE company_type_m = '" + jObj.get("location_nm") + "' 	\n")
							.append(" AND refno >= '" + jObj.get("deliver_index") + "'  \n")
							.append(" AND refno <  '" + jObj.get("deliver_index_before") + "'    \n")
							.append("													\n")
							.toString();
								
						resultInt = super.excuteUpdate(con, sql);
						
						if (resultInt < 0) {
							ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
							con.rollback();
					    	System.out.println("E112 에러 리턴값: " + EventDefine.E_DOEXCUTE_ERROR);
							return EventDefine.E_DOEXCUTE_ERROR ;
						}
					}
					
					// ex) 순번 8 -> 10으로 변경시 
				    // 기존 9~10만  8~9으로 변경되면 되므로
					// 찾아서 -1 해준다.
					
					else {
					sql = new StringBuilder()
							.append("UPDATE tbm_customer SET 							\n")
							.append("	refno = refno - 1								\n")
							.append(" WHERE company_type_m = '" + jObj.get("location_nm") + "' 	\n")
							.append(" AND refno <= '" + jObj.get("deliver_index") + "'  \n")
							.append(" AND refno > '" + jObj.get("deliver_index_before") + "'  \n")
							.append("													\n")
							.toString();
									
						resultInt = super.excuteUpdate(con, sql);
							
						if (resultInt < 0) {
							ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
							con.rollback();
						    System.out.println("E112 에러 리턴값: " + EventDefine.E_DOEXCUTE_ERROR);
							return EventDefine.E_DOEXCUTE_ERROR ;
							}
					}
					
					// 해당 순번으로 변경해준다.
					sql = new StringBuilder()
						.append("UPDATE tbm_customer SET 							\n")
						.append("	refno = '" + jObj.get("deliver_index") + "',	\n")
						.append("	modify_date = SYSDATETIME,						\n")
						.append("	modify_user_id = '" + jObj.get("user_id") + "', \n")
						.append("	modify_reason = '배송순서수정'						\n")
						.append(" WHERE cust_cd = '" + jObj.get("cust_cd") + "' 	\n")
						.append("													\n")
						.toString();
							
					resultInt = super.excuteUpdate(con, sql);
					
					if (resultInt < 0) {
						ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
						con.rollback();
				    	System.out.println("E102 에러 리턴값: " + EventDefine.E_DOEXCUTE_ERROR);
						return EventDefine.E_DOEXCUTE_ERROR ;
					}
					con.commit();
					
				} catch(Exception e) {
					LoggingWriter.setLogError("M909S115100E112()","==== SQL ERROR ===="+ e.getMessage() + "\n" + sql.toString());
					return EventDefine.E_DOEXCUTE_ERROR ;
			    } finally {
			    	if (Config.useDataSource) {
						try {
							if (con != null) con.close();
						} catch (Exception e) {
							LoggingWriter.setLogError("M909S115100E112()","==== finally ===="+ e.getMessage());
						}
			    	} else {
			    	}
			    }
				ioParam.setResultString(resultString);
				ioParam.setColumnCount("" + super.COLUMN_COUNT);

				return EventDefine.E_QUERY_RESULT;
			}

	//배송기사 정보 삭제
	public int E103(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jObj = new JSONObject();
			jObj = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			
			String sql = new StringBuilder()
					.append("DELETE FROM tbm_vehicle_users  						\n")
					.append("WHERE user_id = '" + jObj.get("user_id") + "'			\n")
					.append("AND user_rev_no = '" + jObj.get("user_rev_no") + "'	\n")
					.toString();
				
			resultInt = super.excuteUpdate(con, sql);
			
			if (resultInt < 0) {
				ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
				con.rollback();
		    	System.out.println("E103 에러 리턴값: " + EventDefine.E_DOEXCUTE_ERROR);
				return EventDefine.E_DOEXCUTE_ERROR ;
			}
			con.commit();
			
		} catch(Exception e) {
			LoggingWriter.setLogError("M909S115100E103()","==== SQL ERROR ===="+ e.getMessage() + "\n" + sql.toString());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M909S115100E103()","==== finally ===="+ e.getMessage());
				}
	    	} else {
	    	}
	    }

		ioParam.setResultString(resultString);
		ioParam.setColumnCount("" + super.COLUMN_COUNT);

		return EventDefine.E_QUERY_RESULT;
	}
	
	//배송기사 정보 삭제
		public int E123(InoutParameter ioParam){
			resultInt = EventDefine.E_DOEXCUTE_INIT;
			
			try {
				con = JDBCConnectionPool.getConnection();
				
				JSONObject jObj = new JSONObject();
				jObj = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
				
				String sql = new StringBuilder()
						.append("DELETE FROM tbm_vehicle  									\n")
						.append("WHERE vehicle_cd = '" + jObj.get("vehicle_cd") + "'		\n")
						.append("AND vehicle_rev_no = '" + jObj.get("vehicle_rev_no") + "'	\n")
						.toString();
					
				resultInt = super.excuteUpdate(con, sql);
				
				if (resultInt < 0) {
					ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
					con.rollback();
			    	System.out.println("E103 에러 리턴값: " + EventDefine.E_DOEXCUTE_ERROR);
					return EventDefine.E_DOEXCUTE_ERROR ;
				}
				con.commit();
				
			} catch(Exception e) {
				LoggingWriter.setLogError("M909S115100E123()","==== SQL ERROR ===="+ e.getMessage() + "\n" + sql.toString());
				return EventDefine.E_DOEXCUTE_ERROR ;
		    } finally {
		    	if (Config.useDataSource) {
					try {
						if (con != null) con.close();
					} catch (Exception e) {
						LoggingWriter.setLogError("M909S115100E123()","==== finally ===="+ e.getMessage());
					}
		    	} else {
		    	}
		    }

			ioParam.setResultString(resultString);
			ioParam.setColumnCount("" + super.COLUMN_COUNT);

			return EventDefine.E_QUERY_RESULT;
		}

	// 배송기사 정보조회
	public int E104(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jObj = new JSONObject();
			jObj = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			
			String sql = new StringBuilder()
					.append("SELECT					\n")
					.append("	A.user_id,			\n")
					.append("	A.user_rev_no,		\n")
					.append("	B.user_nm,			\n")
					.append("	code_name,			\n")
					.append("	cust_gubun,			\n")
					.append("	C.vehicle_nm,			\n")
					.append("	A.vehicle_cd,			\n")
					.append("	A.vehicle_rev_no,		\n")
					.append("	A.start_date,			\n")
					.append("	A.duration_date,		\n")
					.append("	A.create_user_id,		\n")
					.append("	A.create_date,			\n")
					.append("	A.modify_user_id,		\n")
					.append("	A.modify_reason,		\n")
					.append("	A.modify_date			\n")
					.append("FROM tbm_vehicle_users A						\n")
					.append("LEFT OUTER JOIN tbm_users B					\n")
					.append("	ON A.user_id = B.user_id					\n")
					.append("	AND A.user_rev_no = B.revision_no			\n")
					.append("LEFT OUTER JOIN tbm_vehicle C					\n")
					.append("	ON A.vehicle_cd = C.vehicle_cd				\n")
					.append("	AND A.vehicle_rev_no = C.vehicle_rev_no 	\n")
					.append("LEFT OUTER JOIN tbm_code_book D				\n")
					.append("	ON A.cust_gubun = D.code_value				\n")
					.append("WHERE TO_CHAR(SYSDATE,'YYYY-MM-DD') BETWEEN A.start_date AND A.duration_date\n")
					.append("ORDER BY A.user_id ASC, A.user_rev_no DESC			\n")
					.toString();  

			resultString = super.excuteQueryString(con, sql);
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M909S115100E104()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M909S115100E104()","==== finally ===="+ e.getMessage());
				}
	    	} else {
	    	}
	    }
		
		ioParam.setResultString(resultString);
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
    	ioParam.setMessage(MessageDefine.M_QUERY_OK);
	    
    	return EventDefine.E_QUERY_RESULT;
	}
	
	// 가맹점 배송순서 정보조회
		public int E114(InoutParameter ioParam){
			resultInt = EventDefine.E_DOEXCUTE_INIT;
			
			try {
				con = JDBCConnectionPool.getConnection();
				
				JSONObject jObj = new JSONObject();
				jObj = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
				
				String sql = new StringBuilder()
						.append("SELECT					\n")
						.append("	A.cust_cd,			\n")
						.append("	A.revision_no,		\n")
						.append("	A.cust_nm,			\n")
						.append("   A.refno,    		\n")
						.append("	A.start_date		\n")
						.append("FROM tbm_customer A 	\n")
						.append("WHERE TO_CHAR(SYSDATE,'YYYY-MM-DD') BETWEEN A.start_date AND A.duration_date \n")
						.append("AND company_type_b = 'CUSTOMER_GUBUN_BIG02' 								  \n")
						.append("AND company_type_m =  '"+ jObj.get("location_nm") +"' 						  \n")
						//.append("AND refno is not null  													  \n")
						.append("ORDER BY A.refno asc NULLS LAST \n")
						.toString();  

				resultString = super.excuteQueryString(con, sql);
			} catch(Exception e) {
				e.printStackTrace();
				LoggingWriter.setLogError("M909S115100E114()","==== SQL ERROR ===="+ e.getMessage());
				return EventDefine.E_DOEXCUTE_ERROR ;
		    } finally {
		    	if (Config.useDataSource) {
					try {
						if (con != null) con.close();
					} catch (Exception e) {
						LoggingWriter.setLogError("M909S115100E114()","==== finally ===="+ e.getMessage());
					}
		    	} else {
		    	}
		    }
			
			ioParam.setResultString(resultString);
			ioParam.setColumnCount("" + super.COLUMN_COUNT);
	    	ioParam.setMessage(MessageDefine.M_QUERY_OK);
		    
	    	return EventDefine.E_QUERY_RESULT;
		}
		
		// 배송순번이 등록안된 지역별 가맹점 내역 조회
				public int E124(InoutParameter ioParam){
					resultInt = EventDefine.E_DOEXCUTE_INIT;
					
					try {
						con = JDBCConnectionPool.getConnection();
						
						JSONObject jObj = new JSONObject();
						jObj = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
						
						String sql = new StringBuilder()
								.append("SELECT					\n")
								.append("	A.cust_cd,			\n")
								.append("	A.cust_nm			\n")
								.append("FROM tbm_customer A 	\n")
								.append("WHERE TO_CHAR(SYSDATE,'YYYY-MM-DD') BETWEEN A.start_date AND A.duration_date \n")
								.append("AND company_type_b = 'CUSTOMER_GUBUN_BIG02' 								  \n")
								.append("AND company_type_m =  '"+ jObj.get("location_nm") +"' 						  \n")
								.append("AND refno IS NULL														  	  \n")
								.append("ORDER BY A.refno DESC \n")
								.toString();  

						resultString = super.excuteQueryString(con, sql);
					} catch(Exception e) {
						e.printStackTrace();
						LoggingWriter.setLogError("M909S115100E114()","==== SQL ERROR ===="+ e.getMessage());
						return EventDefine.E_DOEXCUTE_ERROR ;
				    } finally {
				    	if (Config.useDataSource) {
							try {
								if (con != null) con.close();
							} catch (Exception e) {
								LoggingWriter.setLogError("M909S115100E114()","==== finally ===="+ e.getMessage());
							}
				    	} else {
				    	}
				    }
					
					ioParam.setResultString(resultString);
					ioParam.setColumnCount("" + super.COLUMN_COUNT);
			    	ioParam.setMessage(MessageDefine.M_QUERY_OK);
				    
			    	return EventDefine.E_QUERY_RESULT;
				}
		// 전체 지역별 가맹점 내역 조회	
				public int E134(InoutParameter ioParam){
					resultInt = EventDefine.E_DOEXCUTE_INIT;
					
					try {
						con = JDBCConnectionPool.getConnection();
						
						JSONObject jObj = new JSONObject();
						jObj = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
						
						String sql = new StringBuilder()
								.append("SELECT					\n")
								.append("	A.cust_cd,			\n")
								.append("	A.cust_nm			\n")
								.append("FROM tbm_customer A 	\n")
								.append("WHERE TO_CHAR(SYSDATE,'YYYY-MM-DD') BETWEEN A.start_date AND A.duration_date \n")
								.append("AND company_type_b = 'CUSTOMER_GUBUN_BIG02' 								  \n")
								.append("AND company_type_m =  '"+ jObj.get("location_nm") +"' 						  \n")
								.append("ORDER BY A.refno ASC \n")
								.toString();  

						resultString = super.excuteQueryString(con, sql);
					} catch(Exception e) {
						e.printStackTrace();
						LoggingWriter.setLogError("M909S115100E134()","==== SQL ERROR ===="+ e.getMessage());
						return EventDefine.E_DOEXCUTE_ERROR ;
				    } finally {
				    	if (Config.useDataSource) {
							try {
								if (con != null) con.close();
							} catch (Exception e) {
								LoggingWriter.setLogError("M909S115100E134()","==== finally ===="+ e.getMessage());
							}
				    	} else {
				    	}
				    }
					
					ioParam.setResultString(resultString);
					ioParam.setColumnCount("" + super.COLUMN_COUNT);
			    	ioParam.setMessage(MessageDefine.M_QUERY_OK);
				    
			    	return EventDefine.E_QUERY_RESULT;
				}
				
				// 지역별 배송 순번 최대값 + 1로 자동순번 부여용	
				public int E144(InoutParameter ioParam){
					resultInt = EventDefine.E_DOEXCUTE_INIT;
					
					try {
						con = JDBCConnectionPool.getConnection();
						
						JSONObject jObj = new JSONObject();
						jObj = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
						
						String sql = new StringBuilder()
								.append("SELECT							\n")
								.append("IF(ISNULL(MAX(refno)), 1 , FORMAT(MAX(refno)+ 1, 00) )		\n") //최대값 존재하면 최대값 + 1, null이면 1
								.append("FROM tbm_customer A  			\n")
								.append("WHERE TO_CHAR(SYSDATE,'YYYY-MM-DD') BETWEEN A.start_date AND A.duration_date \n")
								.append("AND company_type_b = 'CUSTOMER_GUBUN_BIG02' 								  \n")
								.append("AND company_type_m =  '"+ jObj.get("location_nm") +"' 						  \n")
								.append("ORDER BY A.refno ASC \n")
								.toString();  

						resultString = super.excuteQueryString(con, sql);
					} catch(Exception e) {
						e.printStackTrace();
						LoggingWriter.setLogError("M909S115100E144()","==== SQL ERROR ===="+ e.getMessage());
						return EventDefine.E_DOEXCUTE_ERROR ;
				    } finally {
				    	if (Config.useDataSource) {
							try {
								if (con != null) con.close();
							} catch (Exception e) {
								LoggingWriter.setLogError("M909S115100E144()","==== finally ===="+ e.getMessage());
							}
				    	} else {
				    	}
				    }
					
					ioParam.setResultString(resultString);
					ioParam.setColumnCount("" + super.COLUMN_COUNT);
			    	ioParam.setMessage(MessageDefine.M_QUERY_OK);
				    
			    	return EventDefine.E_QUERY_RESULT;
				}
				
				
				// 차량정보 삭제 데이터 조회용	
				public int E154(InoutParameter ioParam){
					resultInt = EventDefine.E_DOEXCUTE_INIT;
					
					try {
						con = JDBCConnectionPool.getConnection();
						
						JSONObject jObj = new JSONObject();
						jObj = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
						
						String sql = new StringBuilder()
								.append("SELECT							\n")
								.append("vehicle_cd,					\n")
								.append("vehicle_rev_no,   				\n")
								.append("vehicle_nm,  					\n")
								.append("vehicle_model, 				\n")
								.append("vehicle_maker, 				\n")
								.append("vehicle_type, 					\n")
								.append("bigo 							\n")
								.append("FROM tbm_vehicle A				\n")
								.append("WHERE A.vehicle_cd = '"+jObj.get("vehicle_cd") + "' \n")
								.append("AND   A.vehicle_rev_no = (SELECT MAX(vehicle_rev_no)\n")
								.append("					      FROM tbm_vehicle B\n")
								.append("					      WHERE B.vehicle_cd = A.vehicle_cd)\n")
								.toString();  

						resultString = super.excuteQueryString(con, sql);
					} catch(Exception e) {
						e.printStackTrace();
						LoggingWriter.setLogError("M909S115100E154()","==== SQL ERROR ===="+ e.getMessage());
						return EventDefine.E_DOEXCUTE_ERROR ;
				    } finally {
				    	if (Config.useDataSource) {
							try {
								if (con != null) con.close();
							} catch (Exception e) {
								LoggingWriter.setLogError("M909S115100E154()","==== finally ===="+ e.getMessage());
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