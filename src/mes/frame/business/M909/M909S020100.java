package mes.frame.business.M909;

import java.lang.reflect.Method;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.util.Vector;

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
public  class M909S020100 extends SqlAdapter{
	Connection con = null;
	PreparedStatement pstmt = null;
	String resultString = "";
	int resultInt = -1;
	StringBuffer sql = new StringBuffer();
	
	String[][] v_paramArray = new String[0][0]; 
	Class[] optClass = null;
	Object[] optObj = null;
	Object obj = null;
	
	public M909S020100(){
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
			
			Method method = M909S020100.class.getMethod(event,optClass);
			LoggingWriter.setLogDebug(M909S020100.class.getName(),"==== " + event + " EventMethod Create Success ====");

			obj = method.invoke(M909S020100.class.newInstance(),optObj);
			doExcute_result = CommonFunction.getInt(obj.toString());
			
	    } catch (Exception ex) {
	    	doExcute_result = EventDefine.E_DOEXCUTE_INIT;
			ioParam.setMessage(MessageDefine.M_NO_EVENTID);
			LoggingWriter.setLogError(M909S020100.class.getName(),"==== EventID Not define : EVENT ID [ " + ioParam.getEventID() + "]");
	    } finally {
	    	obj = null;
			optClass = null;
			optObj = null;
	    }
	    long endTime = System.currentTimeMillis();
		long runningTime = endTime - startTime;
		LoggingWriter.setLogAll(M909S020100.class.getName(),"==== Query [수행시간  : " + runningTime + " ms]");
		
		return doExcute_result;
	}

	// 점검표 등록
	public int E101(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jObj = new JSONObject();
			jObj = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));

			String sql = new StringBuilder()
					.append("INSERT INTO checklist (					\n")
					.append("	checklist_id, 							\n")
					.append("	checklist_rev_no, 						\n")
					.append("	checklist_name, 						\n")
					.append("	check_term, 							\n")
					.append("	create_date, 							\n")
					.append("	duration_date							\n")
					.append(") 											\n")
					.append("VALUES (									\n")
					.append("	'" + jObj.get("checklist_id") + "', 	\n")
					.append("	0, 										\n")
					.append("	'" + jObj.get("checklist_name") + "', 	\n")
					.append("	'" + jObj.get("check_term") + "', 		\n")
					.append("	SYSDATE, 								\n")
					.append("	DATE'12/31/9999'						\n")
					.append(");											\n")
					.toString();
			
				resultInt = super.excuteUpdate(con, sql);
				if (resultInt < 0) {
					ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
					return resultInt;
				} else {
					ioParam.setMessage(resultInt + "건 " + MessageDefine.M_INSERT_RESULT);
				}
		} catch(Exception e) {
			LoggingWriter.setLogError("M909S020100E101()","==== SQL ERROR ===="
										+ e.getMessage() + "\n" + sql.toString());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M909S020100E101()","==== finally ====" + e.getMessage());
				}
	    	}
	    }
		ioParam.setResultString(resultString);
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
	   
		return EventDefine.E_QUERY_RESULT;
	}
	
	// 점검표 수정
		public int E102(InoutParameter ioParam){
			resultInt = EventDefine.E_DOEXCUTE_INIT;
			
			try {
				con = JDBCConnectionPool.getConnection();
				
				JSONObject jObj = new JSONObject();
				jObj = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));

				String sql = new StringBuilder()
						.append("UPDATE checklist SET											\n")
						.append("	checklist_rev_no = 	'" + jObj.get("checklist_rev_no") + "',	\n")
						.append("	checklist_name = '" + jObj.get("checklist_name") + "', 		\n")
						.append("	check_term = '" + jObj.get("check_term") + "' 				\n")
						.append("WHERE checklist_id = '" + jObj.get("checklist_id") + "' 		\n")
						.append("AND checklist_rev_no = '" + jObj.get("checklist_rev_no") + "' 	\n")
						.toString();
				
					resultInt = super.excuteUpdate(con, sql);
					if (resultInt < 0) {
						ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
						return resultInt;
					} else {
						ioParam.setMessage(resultInt + "건 " + MessageDefine.M_INSERT_RESULT);
					}
			} catch(Exception e) {
				LoggingWriter.setLogError("M909S020100E102()","==== SQL ERROR ===="
											+ e.getMessage() + "\n" + sql.toString());
				return EventDefine.E_DOEXCUTE_ERROR ;
		    } finally {
		    	if (Config.useDataSource) {
					try {
						if (con != null) con.close();
					} catch (Exception e) {
						LoggingWriter.setLogError("M909S020100E102()","==== finally ====" + e.getMessage());
					}
		    	}
		    }
			ioParam.setResultString(resultString);
			ioParam.setColumnCount("" + super.COLUMN_COUNT);
		   
			return EventDefine.E_QUERY_RESULT;
		}
		
		// 점검표 삭제
				public int E103(InoutParameter ioParam){
					resultInt = EventDefine.E_DOEXCUTE_INIT;
					
					try {
						con = JDBCConnectionPool.getConnection();
						
						JSONObject jObj = new JSONObject();
						jObj = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));

						String sql = new StringBuilder()
								.append("DELETE FROM checklist 											\n")
								.append("WHERE checklist_id = '" + jObj.get("checklist_id") + "' 		\n")
								.append("AND checklist_rev_no =  '" + jObj.get("checklist_rev_no") + "'	\n")
								.toString();
						
							resultInt = super.excuteUpdate(con, sql);
							if (resultInt < 0) {
								ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
								return resultInt;
							} else {
								ioParam.setMessage(resultInt + "건 " + MessageDefine.M_INSERT_RESULT);
							}
					} catch(Exception e) {
						LoggingWriter.setLogError("M909S020100E103()","==== SQL ERROR ===="
													+ e.getMessage() + "\n" + sql.toString());
						return EventDefine.E_DOEXCUTE_ERROR ;
				    } finally {
				    	if (Config.useDataSource) {
							try {
								if (con != null) con.close();
							} catch (Exception e) {
								LoggingWriter.setLogError("M909S020100E103()","==== finally ====" + e.getMessage());
							}
				    	}
				    }
					ioParam.setResultString(resultString);
					ioParam.setColumnCount("" + super.COLUMN_COUNT);
				   
					return EventDefine.E_QUERY_RESULT;
				}
	
	// 점검표 목록 조회
	public int E104(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			String sql = new StringBuilder()
					.append("SELECT                                                     		\n")
					.append("	A.checklist_id,                                             	\n")
					.append("	A.checklist_rev_no,												\n")
					.append("	F.format_rev_no,                                         		\n")
					.append("	A.checklist_name,                                           	\n")
					.append("	A.check_term,                                               	\n")
					.append("	A.create_date,                                              	\n")
					.append("	A.duration_date                                             	\n")
					.append("FROM                                                       		\n")
					.append("	checklist A														\n")
					.append("LEFT JOIN checklist_format F										\n")
					.append("	ON A.checklist_id = F.checklist_id								\n")
					.append("	AND A.checklist_rev_no = F.checklist_rev_no                     \n")
					.append("WHERE                                                      		\n")
					.append("	A.checklist_rev_no = (SELECT MAX(checklist_rev_no)          	\n")
					.append("						  FROM checklist B                      	\n")
					.append("						  WHERE A.checklist_id = B.checklist_id)	\n")
					.append(";\n")
					.toString();

			resultString = super.excuteQueryString(con, sql);
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M909S020100E104()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M909S020100E104()","==== finally ===="+ e.getMessage());
				}
	    	} else {
	    	}
	    }
		ioParam.setResultString(resultString);
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
    	ioParam.setMessage(MessageDefine.M_QUERY_OK);
	    return EventDefine.E_QUERY_RESULT;
	}
	
	// 점검표 양식 등록
	public int E111(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jObj = new JSONObject();
			jObj = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));

			String sql = new StringBuilder()
					.append("INSERT INTO checklist_format (				\n")
					.append("	checklist_id, 							\n")
					.append("	checklist_rev_no, 						\n")
					.append("	format_rev_no,	 						\n")
					.append("	create_date, 							\n")
					.append("	duration_date,							\n")
					.append("	img_location,							\n")
					.append("	jsp_location							\n")
					.append(") 											\n")
					.append("VALUES (									\n")
					.append("	'" + jObj.get("checklist_id") + "', 	\n")
					.append("	'" + jObj.get("checklist_rev_no") + "',	\n")
					.append("	'" + jObj.get("format_rev_no") + "', 	\n")
					.append("	SYSDATE, 								\n")
					.append("	DATE'12/31/9999',						\n")
					.append("	'" + jObj.get("img_location") + "',		\n")
					.append("	'" + jObj.get("jsp_location") + "'		\n")
					.append(");											\n")
					.toString();
			
				resultInt = super.excuteUpdate(con, sql);
				if (resultInt < 0) {
					ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
					return resultInt;
				} else {
					ioParam.setMessage(resultInt + "건 " + MessageDefine.M_INSERT_RESULT);
				}
		} catch(Exception e) {
			LoggingWriter.setLogError("M909S020100E111()","==== SQL ERROR ===="
										+ e.getMessage() + "\n" + sql.toString());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M909S020100E111()","==== finally ====" + e.getMessage());
				}
	    	}
	    }
		ioParam.setResultString(resultString);
		ioParam.setColumnCount("" + super.COLUMN_COUNT);

		return EventDefine.E_QUERY_RESULT;
	}
	
	// 점검표 양식 변경
	public int E112(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		String sql = "";
		
		try {
			con = JDBCConnectionPool.getConnection();
			con.setAutoCommit(false);
			
			JSONObject jObj = new JSONObject();
			jObj = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			
			sql = new StringBuilder()
				.append("UPDATE checklist_format 											\n")
				.append("SET 																\n")
				.append("	create_date = SUBDATE(create_date, 1)							\n")
				.append("WHERE checklist_id = '" + jObj.get("checklist_id") + "' 			\n")
				.append("   AND checklist_rev_no = '" + jObj.get("checklist_rev_no") + "' 	\n")
				.append("   AND format_rev_no = '" + jObj.get("format_rev_no") + "'			\n")
				.toString();
			
			resultInt = super.excuteUpdate(con, sql);
			if (resultInt < 0) {
				ioParam.setMessage(MessageDefine.M_UPDATE_FAILED);
				return resultInt;
			} else {
				ioParam.setMessage(resultInt + "건 " + MessageDefine.M_UPDATE_RESULT);
			}
			
			sql = new StringBuilder()
				.append("INSERT INTO checklist_format (				\n")
				.append("	checklist_id, 							\n")
				.append("	checklist_rev_no, 						\n")
				.append("	format_rev_no,	 						\n")
				.append("	create_date, 							\n")
				.append("	duration_date,							\n")
				.append("	img_location,							\n")
				.append("	jsp_location							\n")
				.append(") 											\n")
				.append("VALUES (									\n")
				.append("	'" + jObj.get("checklist_id") + "', 	\n")
				.append("	'" + jObj.get("checklist_rev_no") + "',	\n")
				.append("	'" + jObj.get("format_rev_no") + 1 + "',\n")
				.append("	SYSDATE, 								\n")
				.append("	DATE'12/31/9999',						\n")
				.append("	'" + jObj.get("img_location") + "',		\n")
				.append("	'" + jObj.get("jsp_location") + "'		\n")
				.append(");											\n")
				.toString();
			
			resultInt = super.excuteUpdate(con, sql);
			if (resultInt < 0) {
				ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
				return resultInt;
			} else {
				ioParam.setMessage(resultInt + "건 " + MessageDefine.M_INSERT_RESULT);
			}
			
			con.commit();
		} catch(Exception e) {
			LoggingWriter.setLogError("M909S020100E112()","==== SQL ERROR ===="
										+ e.getMessage() + "\n" + sql.toString());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M909S020100E112()","==== finally ====" + e.getMessage());
				}
	    	}
	    }
		ioParam.setResultString(resultString);
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
	   
		return EventDefine.E_QUERY_RESULT;
	}
	
	// 점검표 양식 조회
	public int E114(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jObj = new JSONObject();
			jObj = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			
			String sql = new StringBuilder()
					.append("SELECT 														\n")
					.append("	A.checklist_id,												\n")
					.append("	A.checklist_rev_no,											\n")
					.append("	A.format_rev_no,											\n")
					.append("	B.checklist_name,											\n")
					.append("	A.img_location,												\n")
					.append("	A.jsp_location												\n")
					.append("FROM 															\n")
					.append("	checklist_format A											\n")
					.append("INNER JOIN checklist B											\n")
					.append("	ON A.checklist_id = B.checklist_id							\n")
					.append("	AND A.checklist_rev_no = B.checklist_rev_no					\n")
					.append("WHERE A.checklist_id = '"+jObj.get("checklist_id")+"'			\n")
					.append("	AND A.checklist_rev_no = "+jObj.get("checklist_rev_no")+"	\n")
					.append("	AND A.format_rev_no = "+jObj.get("format_rev_no")+"			\n")
					.toString();

			resultString = super.excuteQueryString(con, sql);
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M909S020100E114()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M909S020100E114()","==== finally ===="+ e.getMessage());
				}
	    	} else {
	    	}
	    }
		ioParam.setResultString(resultString);
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
    	ioParam.setMessage(MessageDefine.M_QUERY_OK);
	    return EventDefine.E_QUERY_RESULT;
	}
	
	// 점검표 양식 조회
	public int E124(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jObj = new JSONObject();
			jObj = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			
			String sql = new StringBuilder()
					.append("SELECT 														\n")
					.append("	checklist_id,												\n")
					.append("	checklist_rev_no,											\n")
					.append("	checklist_name												\n")
					.append("FROM 															\n")
					.append("	checklist													\n")
					.append("WHERE checklist_id = '"+jObj.get("checklist_id")+"'			\n")
					.append("	AND checklist_rev_no = "+jObj.get("checklist_rev_no")+"	\n")
					.toString();

			resultString = super.excuteQueryString(con, sql);
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M909S020100E124()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M909S020100E124()","==== finally ===="+ e.getMessage());
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