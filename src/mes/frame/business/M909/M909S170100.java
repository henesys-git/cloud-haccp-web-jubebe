package mes.frame.business.M909;

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


public class M909S170100 extends SqlAdapter{
	Connection con = null;
	PreparedStatement pstmt = null;
	String resultString = "";
	int resultInt = -1;
	StringBuffer sql = new StringBuffer();
	
	String[][] v_paramArray = new String[0][0]; 
	Class[] optClass = null;
	Object[] optObj = null;
	Object obj = null;
	
	public M909S170100(){
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
			
			Method method = M909S170100.class.getMethod(event,optClass);
			LoggingWriter.setLogDebug(M909S170100.class.getName(),"==== " + event + " EventMethod Create Success ====");

			obj = method.invoke(M909S170100.class.newInstance(),optObj);
			doExcute_result = CommonFunction.getInt(obj.toString());
			
	    } catch (Exception ex) {
	    	doExcute_result = EventDefine.E_DOEXCUTE_INIT;
			ioParam.setMessage(MessageDefine.M_NO_EVENTID);
			LoggingWriter.setLogError(M909S170100.class.getName(),"==== EventID Not define : EVENT ID [ " + ioParam.getEventID() + "]");
	    } finally {
	    	obj = null;
			optClass = null;
			optObj = null;
	    }
	    long endTime = System.currentTimeMillis();
		long runningTime = endTime - startTime;
		LoggingWriter.setLogAll(M909S170100.class.getName(),"==== Query [수행시간  : " + runningTime + " ms]");
		
		return doExcute_result;
	}
	
	public int E101(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jObj = new JSONObject();
			jObj = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			
			String sql = new StringBuilder()
				    .append("INSERT INTO                                    \n")
				    .append("	haccp_censor_info (                         \n")
				    .append("		censor_no,                              \n")
				    .append("		censor_name,                            \n")
				    .append("		censor_type,                            \n")
				    .append("		censor_location,                        \n")
				    .append("		min_value,                              \n")
				    .append("		max_value,                              \n")
				    .append("		standard_value,                         \n")
				    .append("		collecting_period,                      \n")
				    .append("		start_date                              \n")
				    .append("	)                                           \n")
				    .append("VALUES                                         \n")
				    .append("	(                                           \n")
				    .append("	'" + jObj.get("censor_no") + "',	        \n")
				    .append("	'" + jObj.get("censor_name") + "',	        \n")
				    .append("	'" + jObj.get("censor_type") + "',	        \n")
				    .append("	'" + jObj.get("censor_location") + "',	    \n")
				    .append("	'" + jObj.get("min_value") + "',	        \n")
				    .append("	'" + jObj.get("max_value") + "',	        \n")
				    .append("	'" + jObj.get("standard_value") + "',	    \n")
				    .append("	" + jObj.get("collecting_period") + " * 60,	\n")
				    .append("		SYSDATE                                 \n")
				    .append("	);                                          \n")
				    .toString();

			resultInt = super.excuteUpdate(con, sql);
			if (resultInt < 0) {
				ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
				return resultInt;
			} else {
				ioParam.setMessage(resultInt + "건 " + MessageDefine.M_INSERT_RESULT);
			}
		} catch(Exception e) {
			LoggingWriter.setLogError("M909S170100E101()","==== SQL ERROR ===="+ e.getMessage() + "\n" + sql.toString());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M909S170100E101()","==== finally ===="+ e.getMessage());
				}
	    	} else {
	    	}
	    }
		ioParam.setResultString(resultString);
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
	    return EventDefine.E_QUERY_RESULT;
	}	

	public int E102(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			con.setAutoCommit(false);
			
			JSONObject jObj = new JSONObject();
			jObj = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));

			String sql = new StringBuilder()
					.append("INSERT INTO                                    			    \n")
					.append("	haccp_censor_info (                         			    \n")
					.append("		censor_no,                              			    \n")
					.append("		censor_rev_no,                          			    \n")
					.append("		censor_name,                            			    \n")
					.append("		censor_type,                            			    \n")
					.append("		censor_location,                        			    \n")
					.append("		min_value,                              			    \n")
					.append("		max_value,                              			    \n")
					.append("		standard_value,                         			    \n")
					.append("		collecting_period,                      			    \n")
					.append("		start_date                              			    \n")
					.append(")                                           			    	\n")
					.append("VALUES (                                         			    \n")
					.append("	'" + jObj.get("censor_no") + "',	        			    \n")
					.append("	(									        			    \n")
					.append("	 SELECT MAX(censor_rev_no)			        			    \n")
					.append("	 FROM haccp_censor_info A			        			    \n")
					.append("	 WHERE censor_no = '" + jObj.get("censor_no") + "'         	\n")
					.append("	) + 1, -- 수정이력번호 +1										\n")
					.append("	'" + jObj.get("censor_name") + "',	        				\n")
					.append("	'" + jObj.get("censor_type") + "',	        			    \n")
					.append("	'" + jObj.get("censor_location") + "',	   				    \n")
					.append("	'" + jObj.get("min_value") + "',	        			    \n")
					.append("	'" + jObj.get("max_value") + "',	        			    \n")
					.append("	'" + jObj.get("standard_value") + "',	    			    \n")
					.append("	" + jObj.get("collecting_period") + " * 60,				    \n")
					.append("	'" + jObj.get("start_date") + "'						    \n")
					.append(");                                          			    	\n")
				    .toString();

			resultInt = super.excuteUpdate(con, sql);
			if (resultInt < 0) {
				ioParam.setMessage(MessageDefine.M_UPDATE_FAILED);
				return resultInt;
			} else {
				ioParam.setMessage(resultInt + "건 " + MessageDefine.M_UPDATE_RESULT);
			}
			
			sql = new StringBuilder()
					.append("UPDATE															    \n")
					.append("	haccp_censor_info                                               \n")
					.append("SET                                                                \n")
					.append("	duration_date = SUBDATE('" + jObj.get("start_date") + "', 1)    \n")
					.append("WHERE                                                              \n")
					.append("	censor_no = '" + jObj.get("censor_no") + "'                     \n")
					.append("	AND censor_rev_no = '" + jObj.get("censor_rev_no") + "'         \n")
					.toString();

			resultInt = super.excuteUpdate(con, sql);
			if (resultInt < 0) {
				ioParam.setMessage(MessageDefine.M_UPDATE_FAILED);
				return resultInt;
			} else {
				ioParam.setMessage(resultInt + "건 " + MessageDefine.M_UPDATE_RESULT);
			}
			
			con.commit();
		} catch(Exception e) {
			LoggingWriter.setLogError("M909S170100E102()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M909S170100E102()","==== finally ===="+ e.getMessage());
				}
	    	} else {
	    	}
	    }
		ioParam.setResultString(resultString);
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
    	ioParam.setMessage(MessageDefine.M_QUERY_OK);
	    
    	return EventDefine.E_QUERY_RESULT;
	}

	public int E103(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jObj = new JSONObject();
			jObj = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));

			sql = new StringBuffer();
			sql.append("UPDATE haccp_censor_info							\n");
			sql.append("SET delyn = 'Y'										\n");
			sql.append("WHERE censor_no	= '" + jObj.get("censor_no") + "'	\n");

			resultInt = super.excuteUpdate(con, sql.toString());
			if (resultInt < 0) {
				ioParam.setMessage(MessageDefine.M_DELETE_FAILED);
				return resultInt;
			} else {
				ioParam.setMessage(resultInt + "건 " + MessageDefine.M_DELETE_RESULT);
			}
		} catch(Exception e) {
			LoggingWriter.setLogError("M909S170100E103()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M909S170100E103()","==== finally ===="+ e.getMessage());
				}
	    	} else {
	    	}
	    }
		ioParam.setResultString(resultString);
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
    	ioParam.setMessage(MessageDefine.M_QUERY_OK);
    	
	    return EventDefine.E_QUERY_RESULT;
	}

	public int E104(InoutParameter ioParam) {
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			String sql = new StringBuilder()
					.append("SELECT                                                     \n")
					.append("	censor_no,                                              \n")
					.append("	censor_rev_no,                                          \n")
					.append("	censor_name,                                            \n")
					.append("	censor_type,                                            \n")
					.append("	censor_location,                                        \n")
					.append("	min_value,                                              \n")
					.append("	max_value,                                              \n")
					.append("	standard_value,                                         \n")
					.append("	collecting_period / 60,                                 \n")
					.append("	start_date,                                             \n")
					.append("	duration_date											\n")
					.append("FROM														\n")
					.append("	haccp_censor_info A										\n")
					.append("WHERE censor_rev_no = (SELECT MAX(censor_rev_no)	        \n")
					.append("						FROM haccp_censor_info B 			\n")
					.append("						WHERE A.censor_no = B.censor_no)	\n")
					.append("  AND delyn != 'Y'											\n")
					.toString();

			resultString = super.excuteQueryString(con, sql);
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M909S170100E104()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M909S170100E104()","==== finally ===="+ e.getMessage());
				}
	    	} else {
	    	}
	    }
		ioParam.setResultString(resultString);
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
    	ioParam.setMessage(MessageDefine.M_QUERY_OK);
	    
    	return EventDefine.E_QUERY_RESULT;
	}

	public int E114(InoutParameter ioParam) {
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jObj = new JSONObject();
			jObj = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			
			String sql = new StringBuilder()
					.append("SELECT                                                 \n")
					.append("	censor_no,                                          \n")
					.append("	censor_rev_no,                                      \n")
					.append("	censor_name,                                        \n")
					.append("	censor_type,                                        \n")
					.append("	censor_location,                                    \n")
					.append("	min_value,                                          \n")
					.append("	max_value,                                          \n")
					.append("	standard_value,                                     \n")
					.append("	collecting_period / 60,								\n")
					.append("	start_date,                                         \n")
					.append("	duration_date                                       \n")
					.append("FROM                                                   \n")
					.append("	haccp_censor_info                                   \n")
					.append("WHERE censor_no = '"+jObj.get("censor_no")+"'			\n")
					.append("  AND censor_rev_no = '"+jObj.get("censor_rev_no")+"'	\n")
					.append("  AND delyn != 'Y'										\n")
					.toString();

			resultString = super.excuteQueryString(con, sql);
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M909S170100E114()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M909S170100E114()","==== finally ===="+ e.getMessage());
				}
	    	} else {
	    	}
	    }
		ioParam.setResultString(resultString);
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
    	ioParam.setMessage(MessageDefine.M_QUERY_OK);
	    
    	return EventDefine.E_QUERY_RESULT;
	}
	
	
	
	
	
	
// =============================================================================	
// ==============================아래는 태양꺼, 안씀. 나중에 지우기=======================	
// =============================================================================	
	
	
	
	
	public int E204(InoutParameter ioParam) {
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			System.out.println("JSONObject jArray rcvData="+ jArray.toString());
			
			sql = new StringBuffer();
			sql.append("SELECT \n"); 
			sql.append("	censor_no,			\n");
			sql.append("	censor_channel,		\n");
			sql.append("	censor_name,		\n");
			sql.append("	censor_type,		\n");
			sql.append("	censor_cycle,		\n");
			sql.append("	censor_loc			\n");
			sql.append("FROM haccp_censor_info	\n");  
			sql.append("WHERE member_key = '" + jArray.get("member_key") + "'	\n"); //member_key_select, update, delete
			sql.append("AND censor_no = '" + jArray.get("censor_no") + "'		\n");

			resultString = super.excuteQueryString(con, sql.toString());
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M909S180100E204()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M909S180100E204()","==== finally ===="+ e.getMessage());
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
	
	public int E994(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			
			String sql = new StringBuilder()
					.append("SELECT DISTINCT code_cd								\n")
					.append("FROM v_censor_data_type								\n")
					.append("WHERE member_key = '" + jArray.get("member_key") + "'	\n")
					.toString();

			resultString = super.excuteQueryString(con, sql.toString());
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M909S170100E994()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M909S170100E994()","==== finally ===="+ e.getMessage());
				}
	    	} else {
	    	}
	    }
		ioParam.setResultString(resultString);
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
    	ioParam.setMessage(MessageDefine.M_QUERY_OK);
	    return EventDefine.E_QUERY_RESULT;
	}
	
	public int E995(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			
			String sql = new StringBuilder()
					.append("SELECT code_value, code_name	\n")
					.append("FROM tbm_code_book	\n")
					.append("WHERE member_key = '" + jArray.get("member_key") + "'	\n")
					.append("AND code_cd = '" + jArray.get("code_cd") + "'	\n")
					.append("ORDER BY code_value ASC	\n")
					.toString();

			resultString = super.excuteQueryString(con, sql.toString());
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M909S170100E995()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M909S170100E995()","==== finally ===="+ e.getMessage());
				}
	    	} else {
	    	}
	    }
		ioParam.setResultString(resultString);
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
    	ioParam.setMessage(MessageDefine.M_QUERY_OK);
	    return EventDefine.E_QUERY_RESULT;
	}
	
	public int E996(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			
			String sql = new StringBuilder()
					.append("SELECT	code_name										\n")
					.append("FROM	tbm_code_book									\n")
					.append("WHERE	member_key = '" + jArray.get("member_key") + "'	\n")
					.append("AND	code_cd = '" + jArray.get("code_cd") + "'		\n")
					.append("AND	code_value = '" + jArray.get("code_value") + "'	\n")
					.toString();

			resultString = super.excuteQueryString(con, sql.toString());
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M909S170100E996()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M909S170100E996()","==== finally ===="+ e.getMessage());
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