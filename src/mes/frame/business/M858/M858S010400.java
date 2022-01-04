package mes.frame.business.M858;

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


public class M858S010400 extends SqlAdapter{
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
	
	public M858S010400(){
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

			Method method = M858S010400.class.getMethod(event,optClass);
			LoggingWriter.setLogDebug(M858S010400.class.getName(),"==== " + event + " EventMethod Create Success ====");

			obj = method.invoke(M858S010400.class.newInstance(),optObj);
			doExcute_result = CommonFunction.getInt(obj.toString());
			
	    } catch (Exception ex) {
	    	doExcute_result = EventDefine.E_DOEXCUTE_INIT;
			ioParam.setMessage(MessageDefine.M_NO_EVENTID);
			LoggingWriter.setLogError(M858S010400.class.getName(),"==== EventID Not define : EVENT ID [ " + ioParam.getEventID() + "]");
	    } finally {
	    	obj = null;
			optClass = null;
			optObj = null;
	    }
	    long endTime = System.currentTimeMillis();
		long runningTime = endTime - startTime;
		LoggingWriter.setLogAll(M858S010400.class.getName(),"==== Query [수행시간  : " + runningTime + " ms]");
		
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
			LoggingWriter.setLogError("M858S010400E101()","==== SQL ERROR ===="+ e.getMessage() + "\n" + sql.toString());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M858S010400E101()","==== finally ===="+ e.getMessage());
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
			LoggingWriter.setLogError("M858S010400E102()","==== SQL ERROR ===="+ e.getMessage() + "\n" + sql.toString());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M858S010400E102()","==== finally ===="+ e.getMessage());
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
			LoggingWriter.setLogError("M858S010400E103()","==== SQL ERROR ===="+ e.getMessage() + "\n" + sql.toString());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M858S010400E103()","==== finally ===="+ e.getMessage());
				}
	    	} else {
	    	}
	    }

		ioParam.setResultString(resultString);
		ioParam.setColumnCount("" + super.COLUMN_COUNT);

		return EventDefine.E_QUERY_RESULT;
	}

	// 집계표 페이지 메인 정보 조회
	public int E104(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jObj = new JSONObject();
			jObj = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			
			String sql = new StringBuilder()
					.append("SELECT 								                    \n")
					.append("	A.chulha_no,						                    \n")
					.append("	A.chulha_rev_no,					                    \n")
					.append("	A.chulha_date,						                    \n")
					.append("	A.order_no,							                    \n")
					.append("	A.order_rev_no,						                    \n")
					.append("	C.cust_nm,							                    \n")
					.append("	A.note,								                    \n")
					.append("   B.order_date,						                    \n")
					.append("   B.delivery_date,					                    \n")
					.append("   B.note,  							                    \n")
					.append("   E.product_nm, 						                    \n")
					.append("   D.chulha_count, 					                    \n")
					.append("   D.note,     						                    \n")
					.append("   B.cust_cd, 							                    \n")
					.append("   B.cust_rev_no, 						                    \n")
					.append("   W.code_name 						                    \n")
					.append("FROM tbi_chulha A						                    \n")
					.append("INNER JOIN tbi_order2 B				                    \n")
					.append("	ON A.order_no = B.order_no			                    \n")
					.append("	AND A.order_rev_no = B.order_rev_no	                    \n")
					.append("INNER JOIN tbm_customer C				                    \n")
					.append("	ON B.cust_cd = C.cust_cd			                    \n")
					.append("	AND B.cust_rev_no = C.revision_no	                    \n")
					.append("INNER JOIN tbi_chulha_detail D  		                    \n")
					.append("   ON A.chulha_no = D.chulha_no  		                    \n")
					.append("   AND A.chulha_rev_no = D.chulha_rev_no                   \n")
					.append("INNER JOIN tbm_product E  				                    \n")
					.append("	ON D.prod_cd = E.prod_cd			                    \n")
					.append("	AND D.prod_rev_no = E.revision_no	                    \n")
					.append("INNER JOIN tbi_vehicle_log_detail V						\n")
					.append("	ON V.chulha_no = A.chulha_no							\n")
					.append("	AND V.chulha_rev_no = A.chulha_rev_no					\n")
					.append("INNER JOIN tbm_code_book W									\n")
					.append("	ON C.company_type_m = W.code_value						\n")
					.append("WHERE 									                    \n")
					.append("		A.chulha_date =	'"+jObj.get("toDate")+"'			\n")
					.append("	AND A.delyn != 'Y'										\n")
					.append("   AND A.chulha_rev_no = (SELECT MAX(chulha_rev_no)       	\n")
					.append("       				FROM tbi_chulha F                  	\n")
					.append("      					WHERE A.chulha_no = F.chulha_no)   	\n")
					.append("   AND C.company_type_m = '"+jObj.get("location_type")+"' 	\n")
					.append("GROUP BY A.order_no    				   				   	\n")
					.toString();


			resultString = super.excuteQueryString(con, sql);
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M858S010400E104()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M858S010400E104()","==== finally ===="+ e.getMessage());
				}
	    	} else {
	    	}
	    }
		
		ioParam.setResultString(resultString);
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
    	ioParam.setMessage(MessageDefine.M_QUERY_OK);
	    
    	return EventDefine.E_QUERY_RESULT;
	}
	
	// 집계표 페이지 상세정보 조회
		public int E114(InoutParameter ioParam){
			resultInt = EventDefine.E_DOEXCUTE_INIT;
			
			try {
				con = JDBCConnectionPool.getConnection();
				
				JSONObject jArr = new JSONObject();
				jArr = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
				
				String sql = new StringBuilder()
						.append("SELECT 												\n")
						//.append("	A.prod_date,										\n")
						.append("	C.product_nm,										\n")
						.append("	A.prod_cd,											\n")
						.append("	A.prod_rev_no,										\n")
						.append("	SUM(A.chulha_count),										\n")
						.append("	A.note												\n")
						.append("FROM tbi_chulha_detail A								\n")
						//.append("INNER JOIN tbi_chulha B								\n")
						//.append("	ON A.chu lha_no = B.chulha_no						\n")
						//.append("	AND A.chulha_rev_no = B.chulha_rev_no				\n")
						.append("INNER JOIN tbm_product C								\n")
						.append("	ON A.prod_cd = C.prod_cd							\n")
						.append("	AND A.prod_rev_no = C.revision_no					\n")
						.append("WHERE A.chulha_no = '"+jArr.get("chulhaNo")+"'			\n")
						.append("AND A.chulha_rev_no = (SELECT MAX(chulha_rev_no)       \n")
						.append("       				FROM tbi_chulha_detail D        \n")
						.append("      					WHERE A.prod_cd = D.prod_cd 	\n")
						.append("      					AND A.chulha_no = D.chulha_no   \n")
						.append("      					AND A.prod_rev_no = D.prod_rev_no) \n")
						.append("AND A.order_no = '"+jArr.get("orderNo")+"'				\n")
						.append("GROUP BY A.prod_cd										\n")
						.toString();

				String ActionCommand = ioParam.getActionCommand();
				if(ActionCommand.startsWith("doQueryTableFieldName")) {
					resultString = super.excuteQueryStringTableFieldName(con, sql);
				} else {
					resultString = super.excuteQueryString(con, sql);
				}
			} catch(Exception e) {
				e.printStackTrace();
				LoggingWriter.setLogError("M858S010400E114()","==== SQL ERROR ===="+ e.getMessage());
				return EventDefine.E_DOEXCUTE_ERROR ;
		    } finally {
		    	if (Config.useDataSource) {
					try {
						if (con != null) con.close();
					} catch (Exception e) {
						LoggingWriter.setLogError("M858S010400E114()","==== finally ===="+ e.getMessage());
					}
		    	}
		    }
			ioParam.setResultString(resultString);
			ioParam.setColumnCount("" + super.COLUMN_COUNT);
	    	ioParam.setMessage(MessageDefine.M_QUERY_OK);
		    return EventDefine.E_QUERY_RESULT;
		}
		
		//집계표 가맹점별 출고량 조회
		public int E144(InoutParameter ioParam){
			resultInt = EventDefine.E_DOEXCUTE_INIT;
			
			try {
				con = JDBCConnectionPool.getConnection();
				
				JSONObject jObj = new JSONObject();
				jObj = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
				
				String sql = new StringBuilder()
						.append("SELECT 								                    \n")
						.append("	A.chulha_date,						                    \n")
						.append("	C.cust_nm,							                    \n")
						.append("   B.order_date,						                    \n")
						.append("   E.product_nm, 						                    \n")
						.append("   E.prod_cd, 						                    	\n")
						.append("   D.chulha_count, 					                    \n")
						.append("   C.cust_cd    											\n")
						.append("FROM tbi_chulha A						                    \n")
						.append("INNER JOIN tbi_order2 B				                    \n")
						.append("	ON A.order_no = B.order_no			                    \n")
						.append("	AND A.order_rev_no = B.order_rev_no	                    \n")
						.append("INNER JOIN tbm_customer C				                    \n")
						.append("	ON B.cust_cd = C.cust_cd			                    \n")
						.append("	AND B.cust_rev_no = C.revision_no	                    \n")
						.append("INNER JOIN tbi_chulha_detail D  		                    \n")
						.append("   ON A.chulha_no = D.chulha_no  		                    \n")
						.append("   AND A.chulha_rev_no = D.chulha_rev_no                   \n")
						.append("   AND A.order_no = D.order_no                   			\n")
						.append("   AND A.order_rev_no = D.order_rev_no                   	\n")
						.append("INNER JOIN tbm_product E  				                    \n")
						.append("	ON D.prod_cd = E.prod_cd			                    \n")
						.append("	AND D.prod_rev_no = E.revision_no	                    \n")
						.append("INNER JOIN tbi_vehicle_log_detail V						\n")
						.append("	ON V.chulha_no = A.chulha_no							\n")
						.append("	AND V.chulha_rev_no = A.chulha_rev_no					\n")
						.append("WHERE 									                    \n")
						.append("		A.chulha_date =	'"+jObj.get("chulha_date")+"'		\n")
						.append("	AND A.delyn != 'Y'										\n")
						.append("   AND A.chulha_rev_no = (SELECT MAX(chulha_rev_no)       	\n")
						.append("       				FROM tbi_chulha F                  	\n")
						.append("      					WHERE A.chulha_no = F.chulha_no)   	\n")
						.append("   AND C.company_type_m = '"+jObj.get("location_type")+"' 	\n")
						.append("   AND B.delivery_yn = 'Y' 								\n")
						//.append("GROUP BY A.chulha_no    				   				   	\n")
						.append("ORDER BY C.refno											\n")
						.toString();
				
				String ActionCommand = ioParam.getActionCommand();
				if(ActionCommand.startsWith("doQueryTableFieldName")) {
					resultString = super.excuteQueryStringTableFieldName(con, sql.toString());
				} else {
					resultString = super.excuteQueryString(con, sql.toString());
				}
			} catch(Exception e) {
				e.printStackTrace();
				LoggingWriter.setLogError("M858S010400E144()","==== SQL ERROR ===="+ e.getMessage());
				return EventDefine.E_DOEXCUTE_ERROR ;
		    } finally {
		    	if (Config.useDataSource) {
					try {
						if (con != null) con.close();
					} catch (Exception e) {
						LoggingWriter.setLogError("M858S010400E144()","==== finally ===="+ e.getMessage());
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
		
		
		// 집계표 총 출고량 조회
				public int E154(InoutParameter ioParam){
					resultInt = EventDefine.E_DOEXCUTE_INIT;
					
					try {
						con = JDBCConnectionPool.getConnection();
						
						JSONObject jObj = new JSONObject();
						jObj = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
						
						String sql = new StringBuilder()
								.append("SELECT 														\n")
								.append("	A.prod_cd,													\n")
								.append("	A.prod_rev_no,												\n")
								.append("	C.product_nm,												\n")
								.append("	SUM(A.chulha_count)											\n")
								.append("FROM tbi_chulha_detail A										\n")
								.append("INNER JOIN tbi_chulha B										\n")
								.append("	ON A.chulha_no = B.chulha_no								\n")
								.append("	AND A.chulha_rev_no = B.chulha_rev_no						\n")
								.append("	AND A.order_no = B.order_no									\n")
								.append("	AND A.order_rev_no = B.order_rev_no							\n")
								.append("INNER JOIN tbm_product C										\n")
								.append("	ON A.prod_cd = C.prod_cd									\n")
								.append("	AND A.prod_rev_no = C.revision_no							\n")								
								.append("INNER JOIN tbi_order2 D				                    	\n")
								.append("	ON A.order_no = D.order_no			                    	\n")
								.append("	AND A.order_rev_no = D.order_rev_no	                    	\n")
								.append("INNER JOIN tbm_customer E				                    	\n")
								.append("	ON D.cust_cd = E.cust_cd			                    	\n")
								.append("	AND D.cust_rev_no = E.revision_no	                    	\n")
								.append("WHERE B.chulha_date = '" + jObj.get("chulha_date") + "' 		\n")
								.append("  AND E.company_type_m = '"+jObj.get("location_type")+"' 		\n")
								.append(" GROUP BY A.prod_cd 											\n")
								.toString();

						String ActionCommand = ioParam.getActionCommand();
						if(ActionCommand.startsWith("doQueryTableFieldName")) {
							resultString = super.excuteQueryStringTableFieldName(con, sql);
						} else {
							resultString = super.excuteQueryString(con, sql);
						}
					} catch(Exception e) {
						e.printStackTrace();
						LoggingWriter.setLogError("M858S010400E154()","==== SQL ERROR ===="+ e.getMessage());
						return EventDefine.E_DOEXCUTE_ERROR ;
				    } finally {
				    	if (Config.useDataSource) {
							try {
								if (con != null) con.close();
							} catch (Exception e) {
								LoggingWriter.setLogError("M858S010400E154()","==== finally ===="+ e.getMessage());
							}
				    	}
				    }
					ioParam.setResultString(resultString);
					ioParam.setColumnCount("" + super.COLUMN_COUNT);
			    	ioParam.setMessage(MessageDefine.M_QUERY_OK);
				    return EventDefine.E_QUERY_RESULT;
				}
				
				// 집계표 배송 지역 조회
				public int E164(InoutParameter ioParam){
					resultInt = EventDefine.E_DOEXCUTE_INIT;
					
					try {
						con = JDBCConnectionPool.getConnection();
						
						JSONObject jObj = new JSONObject();
						jObj = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
						
						String sql = new StringBuilder()
								.append("SELECT 														\n")
								.append("	code_name													\n")
								.append("FROM tbm_code_book A											\n")
								.append("  WHERE code_value = '" + jObj.get("location_type") + "' 		\n")
								.toString();

						String ActionCommand = ioParam.getActionCommand();
						if(ActionCommand.startsWith("doQueryTableFieldName")) {
							resultString = super.excuteQueryStringTableFieldName(con, sql);
						} else {
							resultString = super.excuteQueryString(con, sql);
						}
					} catch(Exception e) {
						e.printStackTrace();
						LoggingWriter.setLogError("M858S010400E164()","==== SQL ERROR ===="+ e.getMessage());
						return EventDefine.E_DOEXCUTE_ERROR ;
				    } finally {
				    	if (Config.useDataSource) {
							try {
								if (con != null) con.close();
							} catch (Exception e) {
								LoggingWriter.setLogError("M858S010400E164()","==== finally ===="+ e.getMessage());
							}
				    	}
				    }
					ioParam.setResultString(resultString);
					ioParam.setColumnCount("" + super.COLUMN_COUNT);
			    	ioParam.setMessage(MessageDefine.M_QUERY_OK);
				    return EventDefine.E_QUERY_RESULT;
				}
				
				// 가맹점당 출하 완제품 개수 조회
				public int E174(InoutParameter ioParam){
					resultInt = EventDefine.E_DOEXCUTE_INIT;
					
					try {
						con = JDBCConnectionPool.getConnection();
						
						JSONObject jObj = new JSONObject();
						jObj = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
						
						String sql = new StringBuilder()
								.append("SELECT COUNT(*) 											\n")
								.append("FROM tbi_chulha A						                    \n")
								.append("INNER JOIN tbi_order2 B				                    \n")
								.append("	ON A.order_no = B.order_no			                    \n")
								.append("	AND A.order_rev_no = B.order_rev_no	                    \n")
								.append("INNER JOIN tbm_customer C				                    \n")
								.append("	ON B.cust_cd = C.cust_cd			                    \n")
								.append("	AND B.cust_rev_no = C.revision_no	                    \n")
								.append("INNER JOIN tbi_chulha_detail D  		                    \n")
								.append("   ON A.chulha_no = D.chulha_no  		                    \n")
								.append("   AND A.chulha_rev_no = D.chulha_rev_no                   \n")
								.append("   AND A.order_no = D.order_no                   			\n")
								.append("   AND A.order_rev_no = D.order_rev_no                   	\n")
								.append("INNER JOIN tbm_product E  				                    \n")
								.append("	ON D.prod_cd = E.prod_cd			                    \n")
								.append("	AND D.prod_rev_no = E.revision_no	                    \n")
								.append("INNER JOIN tbi_vehicle_log_detail V						\n")
								.append("	ON V.chulha_no = A.chulha_no							\n")
								.append("	AND V.chulha_rev_no = A.chulha_rev_no					\n")
								.append("WHERE 									                    \n")
								.append("		A.chulha_date =	'"+jObj.get("chulha_date")+"'		\n")
								.append("	AND A.delyn != 'Y'										\n")
								.append("   AND A.chulha_rev_no = (SELECT MAX(chulha_rev_no)       	\n")
								.append("       				FROM tbi_chulha F                  	\n")
								.append("      					WHERE A.chulha_no = F.chulha_no)   	\n")
								.append("   AND C.company_type_m = '"+jObj.get("location_type")+"' 	\n")
								.append("   AND B.delivery_yn = 'Y' 								\n")
								.append("   AND C.cust_cd = '"+jObj.get("cust_cd")+"' 				\n")
								.toString();

						String ActionCommand = ioParam.getActionCommand();
						if(ActionCommand.startsWith("doQueryTableFieldName")) {
							resultString = super.excuteQueryStringTableFieldName(con, sql);
						} else {
							resultString = super.excuteQueryString(con, sql);
						}
					} catch(Exception e) {
						e.printStackTrace();
						LoggingWriter.setLogError("M858S010400E174()","==== SQL ERROR ===="+ e.getMessage());
						return EventDefine.E_DOEXCUTE_ERROR ;
				    } finally {
				    	if (Config.useDataSource) {
							try {
								if (con != null) con.close();
							} catch (Exception e) {
								LoggingWriter.setLogError("M858S010400E174()","==== finally ===="+ e.getMessage());
							}
				    	}
				    }
					ioParam.setResultString(resultString);
					ioParam.setColumnCount("" + super.COLUMN_COUNT);
			    	ioParam.setMessage(MessageDefine.M_QUERY_OK);
				    return EventDefine.E_QUERY_RESULT;
				}
				
				// 가맹점명 조회용
				public int E184(InoutParameter ioParam){
					resultInt = EventDefine.E_DOEXCUTE_INIT;
					
					try {
						con = JDBCConnectionPool.getConnection();
						
						JSONObject jObj = new JSONObject();
						jObj = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
						
						String sql = new StringBuilder()
								.append("SELECT DISTINCT 											\n")
								.append("C.cust_nm, 												\n")
								.append("C.cust_cd, 												\n")
								.append("C.refno													\n")
								.append("FROM tbi_chulha A						                    \n")
								.append("INNER JOIN tbi_order2 B				                    \n")
								.append("	ON A.order_no = B.order_no			                    \n")
								.append("	AND A.order_rev_no = B.order_rev_no	                    \n")
								.append("INNER JOIN tbm_customer C				                    \n")
								.append("	ON B.cust_cd = C.cust_cd			                    \n")
								.append("	AND B.cust_rev_no = C.revision_no	                    \n")
								.append("INNER JOIN tbi_chulha_detail D  		                    \n")
								.append("   ON A.chulha_no = D.chulha_no  		                    \n")
								.append("   AND A.chulha_rev_no = D.chulha_rev_no                   \n")
								.append("   AND A.order_no = D.order_no                   			\n")
								.append("   AND A.order_rev_no = D.order_rev_no                   	\n")
								.append("INNER JOIN tbm_product E  				                    \n")
								.append("	ON D.prod_cd = E.prod_cd			                    \n")
								.append("	AND D.prod_rev_no = E.revision_no	                    \n")
								.append("INNER JOIN tbi_vehicle_log_detail V						\n")
								.append("	ON V.chulha_no = A.chulha_no							\n")
								.append("	AND V.chulha_rev_no = A.chulha_rev_no					\n")
								.append("WHERE 									                    \n")
								.append("		A.chulha_date =	'"+jObj.get("chulha_date")+"'		\n")
								.append("	AND A.delyn != 'Y'										\n")
								.append("   AND A.chulha_rev_no = (SELECT MAX(chulha_rev_no)       	\n")
								.append("       				FROM tbi_chulha F                  	\n")
								.append("      					WHERE A.chulha_no = F.chulha_no)   	\n")
								.append("   AND C.company_type_m = '"+jObj.get("location_type")+"' 	\n")
								.append("   AND B.delivery_yn = 'Y' 								\n")
								.append("ORDER BY C.refno											\n")
								.toString();

						String ActionCommand = ioParam.getActionCommand();
						if(ActionCommand.startsWith("doQueryTableFieldName")) {
							resultString = super.excuteQueryStringTableFieldName(con, sql);
						} else {
							resultString = super.excuteQueryString(con, sql);
						}
					} catch(Exception e) {
						e.printStackTrace();
						LoggingWriter.setLogError("M858S010400E184()","==== SQL ERROR ===="+ e.getMessage());
						return EventDefine.E_DOEXCUTE_ERROR ;
				    } finally {
				    	if (Config.useDataSource) {
							try {
								if (con != null) con.close();
							} catch (Exception e) {
								LoggingWriter.setLogError("M858S010400E184()","==== finally ===="+ e.getMessage());
							}
				    	}
				    }
					ioParam.setResultString(resultString);
					ioParam.setColumnCount("" + super.COLUMN_COUNT);
			    	ioParam.setMessage(MessageDefine.M_QUERY_OK);
				    return EventDefine.E_QUERY_RESULT;
				}
				
				// 가맹점별 완제품 출하량 조회용
				public int E194(InoutParameter ioParam){
					resultInt = EventDefine.E_DOEXCUTE_INIT;
					
					try {
						con = JDBCConnectionPool.getConnection();
						
						JSONObject jObj = new JSONObject();
						jObj = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
						
						String sql = new StringBuilder()
								.append("SELECT  													\n")
								.append("E.prod_cd, 												\n")
								.append("E.product_nm, 												\n")
								.append("SUM(D.chulha_count), 											\n")
								.append("C.refno													\n")
								.append("FROM tbi_chulha A						                    \n")
								.append("INNER JOIN tbi_order2 B				                    \n")
								.append("	ON A.order_no = B.order_no			                    \n")
								.append("	AND A.order_rev_no = B.order_rev_no	                    \n")
								.append("INNER JOIN tbm_customer C				                    \n")
								.append("	ON B.cust_cd = C.cust_cd			                    \n")
								.append("	AND B.cust_rev_no = C.revision_no	                    \n")
								.append("INNER JOIN tbi_chulha_detail D  		                    \n")
								.append("   ON A.chulha_no = D.chulha_no  		                    \n")
								.append("   AND A.chulha_rev_no = D.chulha_rev_no                   \n")
								.append("   AND A.order_no = D.order_no                   			\n")
								.append("   AND A.order_rev_no = D.order_rev_no                   	\n")
								.append("INNER JOIN tbm_product E  				                    \n")
								.append("	ON D.prod_cd = E.prod_cd			                    \n")
								.append("	AND D.prod_rev_no = E.revision_no	                    \n")
								.append("INNER JOIN tbi_vehicle_log_detail V						\n")
								.append("	ON V.chulha_no = A.chulha_no							\n")
								.append("	AND V.chulha_rev_no = A.chulha_rev_no					\n")
								.append("WHERE 									                    \n")
								.append("		A.chulha_date =	'"+jObj.get("chulha_date")+"'		\n")
								.append("	AND A.delyn != 'Y'										\n")
								.append("   AND A.chulha_rev_no = (SELECT MAX(chulha_rev_no)       	\n")
								.append("       				FROM tbi_chulha F                  	\n")
								.append("      					WHERE A.chulha_no = F.chulha_no)   	\n")
								.append("   AND C.company_type_m = '"+jObj.get("location_type")+"' 	\n")
								.append("   AND B.delivery_yn = 'Y' 								\n")
								.append("   AND C.cust_cd = '"+jObj.get("cust_cd")+"' 				\n")
								.append("GROUP BY E.prod_cd 										\n")
								.toString();

						String ActionCommand = ioParam.getActionCommand();
						if(ActionCommand.startsWith("doQueryTableFieldName")) {
							resultString = super.excuteQueryStringTableFieldName(con, sql);
						} else {
							resultString = super.excuteQueryString(con, sql);
						}
					} catch(Exception e) {
						e.printStackTrace();
						LoggingWriter.setLogError("M858S010400E194()","==== SQL ERROR ===="+ e.getMessage());
						return EventDefine.E_DOEXCUTE_ERROR ;
				    } finally {
				    	if (Config.useDataSource) {
							try {
								if (con != null) con.close();
							} catch (Exception e) {
								LoggingWriter.setLogError("M858S010400E194()","==== finally ===="+ e.getMessage());
							}
				    	}
				    }
					ioParam.setResultString(resultString);
					ioParam.setColumnCount("" + super.COLUMN_COUNT);
			    	ioParam.setMessage(MessageDefine.M_QUERY_OK);
				    return EventDefine.E_QUERY_RESULT;
				}
				
				// 출고집계표 p박스 출고량 조회용
				public int E204(InoutParameter ioParam){
					resultInt = EventDefine.E_DOEXCUTE_INIT;
					
					try {
						con = JDBCConnectionPool.getConnection();
						
						JSONObject jObj = new JSONObject();
						jObj = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
						
						String sql = new StringBuilder()
								.append("SELECT 														\n")
								.append("	FORMAT(SUM(F.chulgo_amount), '0') 							\n")
								.append("FROM tbi_part_chulgo2 F										\n")
								.append("WHERE F.chulgo_date = '" + jObj.get("chulha_date") + "' 		\n")
								.append("AND   F.part_rev_no = 0										\n")
								.append("  AND F.chulgo_type = '제품출하_' +'"+jObj.get("location_nm")+"' 	\n")
								.append("  AND F.trace_key = '20210512105110' 							\n")
								.append(" GROUP BY F.part_cd 											\n")
								.toString();

						String ActionCommand = ioParam.getActionCommand();
						if(ActionCommand.startsWith("doQueryTableFieldName")) {
							resultString = super.excuteQueryStringTableFieldName(con, sql);
						} else {
							resultString = super.excuteQueryString(con, sql);
						}
					} catch(Exception e) {
						e.printStackTrace();
						LoggingWriter.setLogError("M858S010400E204()","==== SQL ERROR ===="+ e.getMessage());
						return EventDefine.E_DOEXCUTE_ERROR ;
				    } finally {
				    	if (Config.useDataSource) {
							try {
								if (con != null) con.close();
							} catch (Exception e) {
								LoggingWriter.setLogError("M858S010400E204()","==== finally ===="+ e.getMessage());
							}
				    	}
				    }
					ioParam.setResultString(resultString);
					ioParam.setColumnCount("" + super.COLUMN_COUNT);
			    	ioParam.setMessage(MessageDefine.M_QUERY_OK);
				    return EventDefine.E_QUERY_RESULT;
				}
				
	
	
}