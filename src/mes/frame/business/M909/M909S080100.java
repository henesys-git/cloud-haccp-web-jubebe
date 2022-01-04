package mes.frame.business.M909;

import java.lang.reflect.Method;
import java.sql.Connection;
import java.sql.PreparedStatement;

import org.apache.log4j.Logger;
import org.json.simple.JSONArray;
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


public class M909S080100 extends SqlAdapter {
	
	static final Logger logger = Logger.getLogger(M909S080100.class.getName());
	
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
	
	public M909S080100(){
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

			Method method = M909S080100.class.getMethod(event,optClass);
			logger.debug(event + " EventMethod Create Success");

			obj = method.invoke(M909S080100.class.newInstance(),optObj);
			doExcute_result = CommonFunction.getInt(obj.toString());
			
	    } catch (Exception ex) {
	    	doExcute_result = EventDefine.E_DOEXCUTE_INIT;
			ioParam.setMessage(MessageDefine.M_NO_EVENTID);
			logger.debug("EventID Not define : EVENT ID [ " + ioParam.getEventID() + "]");
	    } finally {
	    	obj = null;
			optClass = null;
			optObj = null;
	    }
	    long endTime = System.currentTimeMillis();
		long runningTime = endTime - startTime;
		logger.debug("Query [수행시간  : " + runningTime + " ms]");
		
		return doExcute_result;
	}
	
	// 사용자 등록
	public int E101(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			//con_Mysql = JDBCConnectionPool.getConnection_Mysql();
			
			JSONObject jObj = new JSONObject();
			jObj = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			
			String password = jObj.get("password").toString();
			String hashedPassword = PasswordHash.hashPassword(password);
			
			String sql = new StringBuilder()
				.append("INSERT INTO tbm_users ( 					\n")
				.append("	user_id,								\n")
				.append("	revision_no,							\n")
				.append("	user_nm,								\n")
				.append("	hpno,									\n")
				.append("	email,									\n")
				.append("	jikwi,									\n")
				.append("	group_cd,								\n")
				.append("	user_pwd,								\n")
				.append("	LOCATION,								\n")
				.append("	dept_cd,								\n")
				.append("	hour_pay,								\n")
				.append("	delyn,									\n")
				.append("	start_date,								\n")
				.append("	duration_date,							\n")
				.append("	create_user_id,							\n")
				.append("	create_date,							\n")
				.append(" 	member_key								\n")
				.append(")											\n")
				.append("VALUES (			 						\n")
				.append(" 	'" + jObj.get("userId") + "', 			\n")
				.append(" 	0, 										\n")
				.append(" 	'" + jObj.get("name") + "', 			\n")
				.append(" 	'" + jObj.get("tel") + "',			 	\n")
				.append(" 	'" + jObj.get("email") + "', 			\n")
				.append(" 	'" + jObj.get("Jikwi") + "',			\n")
				.append(" 	'" + jObj.get("userGroupCode") + "', 	\n")
				.append(" 	'" + hashedPassword + "',		 		\n")
				.append(" 	'', 									\n")
				.append(" 	'" + jObj.get("userDeptCode") + "', 	\n")
				.append(" 	'" + jObj.get("hourPay") + "', 			\n")
				.append(" 	'N', 									\n")
				.append("	SYSDATE,								\n")
				.append("	'9999-12-31',							\n")
				.append("	'" + jObj.get("createUserId") + "',		\n")
				.append("	SYSDATETIME,							\n")
				.append(" 	'" + jObj.get("member_key") + "' 		\n")
				.append(")											\n")
				.toString();
					
			resultInt = super.excuteUpdate(con, sql);
			if (resultInt < 0) {
				ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
			} else {
				ioParam.setMessage(resultInt + "건 " + MessageDefine.M_INSERT_RESULT);
			}
		} catch(Exception e) {
			LoggingWriter.setLogError("M909S080100E101()","==== SQL ERROR ===="+ e.getMessage() + "\n" + sql.toString());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M909S080100E101()","==== finally ===="+ e.getMessage());
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
			//con_Mysql = JDBCConnectionPool.getConnection_Mysql();
			
			JSONObject jObj = new JSONObject();
			jObj = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));

			con.setAutoCommit(false);
			
			String userId = jObj.get("userId").toString();
			
			// 먼저 이전 리비전에 대한 적용종료일자를 이번의 적용일자에서 하루를 뺀 날짜로 변경한다.
			String sqlPre = new StringBuilder()
					.append("UPDATE tbm_users SET																					\n")
					.append("	duration_date = TO_CHAR(TO_DATE('" + jObj.get("startDate") + "', 'YYYY-MM-DD') - 1 , 'YYYY-MM-DD'),	\n")
					.append(" 	member_key = '" + jObj.get("member_key") + "'														\n")
					.append("WHERE user_id = '" + userId + "'																		\n")
					.append("	AND revision_no = '" + jObj.get("RevisionNo_Target") + "'											\n")
					.append(" 	AND member_key = '" + jObj.get("member_key") + "' 													\n")
					.toString();
			
			resultInt = super.excuteUpdate(con, sqlPre);
			if (resultInt < 0) {
				con.rollback();
				ioParam.setMessage(MessageDefine.M_UPDATE_FAILED);
				return resultInt;
			} else {
				ioParam.setMessage(resultInt + "건 " + MessageDefine.M_UPDATE_RESULT);
			}

			String sql = new StringBuilder()
					.append("INSERT INTO tbm_users ( 								\n")
					.append("	user_id,											\n")
					.append("	revision_no,										\n")
					.append("	user_pwd,											\n")
					.append("	user_nm,											\n")
					.append("	hpno,												\n")
					.append("	email,												\n")
					.append("	jikwi,												\n")
					.append("	group_cd,											\n")
					.append("	LOCATION,											\n")
					.append("	dept_cd,											\n")
					.append("	hour_pay,											\n")
					.append("	delyn,												\n")
					.append("	start_date,											\n")
					.append("	duration_date,										\n")
					.append("	modify_user_id,										\n")
					.append("	modify_date,										\n")
					.append(" 	member_key											\n")
					.append(")														\n")
					.append("VALUES (			 									\n")
					.append(" 	'" +userId+ "', 									\n")
					.append(" 	(SELECT MAX(revision_no) 							\n")
					.append(" 	 FROM tbm_users			 							\n")
					.append(" 	 WHERE user_id = '"+userId+"'						\n")
					.append(" 	) + 1,												\n")
					.append(" 	(SELECT user_pwd		 							\n")
					.append(" 	 FROM tbm_users			 							\n")
					.append(" 	 WHERE user_id = '"+userId+"'						\n")
					.append(" 	   AND revision_no = (SELECT MAX(revision_no)		\n")
					.append(" 						  FROM tbm_users				\n")
					.append(" 						  WHERE user_id = '"+userId+"')	\n")
					.append(" 	),													\n")
					.append(" 	'" + jObj.get("name") + "', 						\n")
					.append(" 	'" + jObj.get("tel") + "',		 					\n")
					.append(" 	'" + jObj.get("email") + "', 						\n")
					.append(" 	'" + jObj.get("Jikwi") + "',						\n")
					.append(" 	'" + jObj.get("userGroupCode") + "', 				\n")
					.append(" 	'', 												\n")
					.append(" 	'" + jObj.get("userDeptCode") + "', 				\n")
					.append(" 	'" + jObj.get("hourPay") + "', 						\n")
					.append(" 	'N', 												\n")
					.append("	'" + jObj.get("startDate") + "',					\n")
					.append("	'9999-12-31',										\n")
					.append("	'" + jObj.get("modifyUserId") + "',					\n")
					.append("	SYSDATETIME,										\n")
					.append(" 	'" + jObj.get("member_key") + "' 					\n")
					.append(")														\n")
					.toString();
					
			resultInt = super.excuteUpdate(con, sql);
			if (resultInt < 0) {
				con.rollback();
				ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
			} else {
				ioParam.setMessage(resultInt + "건 " + MessageDefine.M_INSERT_RESULT);
			}
			
			con.commit();
		} catch(Exception e) {
			LoggingWriter.setLogError("M909S080100E102()","==== SQL ERROR ===="+ e.getMessage() + "\n" + sql.toString());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M909S080100E102()","==== finally ===="+ e.getMessage());
				}
	    	} else {
	    	}
	    }

		ioParam.setResultString(resultString);
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
		
	    return EventDefine.E_QUERY_RESULT;
	}

	public int E103(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jObj = new JSONObject();
			jObj = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			
			String sql = new StringBuilder()
					.append("UPDATE tbm_users  								\n")
					.append("SET delyn = 'Y'  								\n")
					.append("WHERE user_id = '" + jObj.get("userId") + "'	\n")
					.toString();
				
			resultInt = super.excuteUpdate(con, sql);
			if (resultInt < 0) {
				ioParam.setMessage(MessageDefine.M_DELETE_FAILED);
			} else {
				ioParam.setMessage(resultInt + "건 " + MessageDefine.M_DELETE_RESULT);
			}
		} catch(Exception e) {
			LoggingWriter.setLogError("M909S080100E103()","==== SQL ERROR ===="+ e.getMessage() + "\n" + sql.toString());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M909S080100E103()","==== finally ===="+ e.getMessage());
				}
	    	} else {
	    	}
	    }

		ioParam.setResultString(resultString);
		ioParam.setColumnCount("" + super.COLUMN_COUNT);

		return EventDefine.E_QUERY_RESULT;
	}

	// 수정된 과거 이력을 포함한 사용자 조회
	public int E104(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jObj = new JSONObject();
			jObj = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			
			String sql = new StringBuilder()
					.append("SELECT					\n")
					.append("	user_id,			\n")
					.append("	revision_no,		\n")
					.append("	user_nm,			\n")
					.append("	hpno,				\n")
					.append("	email,				\n")
					.append("	jikwi,				\n")
					.append("	group_cd,			\n")
					.append("	G.code_name,		\n")
					.append("	user_pwd,			\n")
					.append("	LOCATION,			\n")
					.append("	dept_cd,			\n")
					.append("	D.code_name,		\n")
					.append("	hour_pay,			\n")
					.append("	delyn,				\n")
					.append("	start_date,			\n")
					.append("	duration_date,		\n")
					.append("	create_user_id,		\n")
					.append("	create_date,		\n")
					.append("	modify_user_id,		\n")
					.append("	modify_reason,		\n")
					.append("	modify_date			\n")
					.append("FROM tbm_users A		\n")
					.append("LEFT OUTER JOIN v_dept_code D							\n")
					.append("	ON A.dept_cd = D.code_value							\n")
					.append("	AND A.member_key = D.member_key						\n")
					.append("LEFT OUTER JOIN v_group_code G							\n")
					.append("	ON A.group_cd = G.code_value						\n")
					.append("	AND A.member_key = G.member_key						\n")
					.append("WHERE user_id like '%" + jObj.get("USER_ID") + "%'		\n")
					.append(" 	AND A.member_key = '" + jObj.get("member_key") + "' \n")
					.append("ORDER BY user_id ASC, revision_no DESC					\n")
					.toString();  

			resultString = super.excuteQueryString(con, sql);
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M909S080100E104()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M909S080100E104()","==== finally ===="+ e.getMessage());
				}
	    	} else {
	    	}
	    }
		
		ioParam.setResultString(resultString);
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
    	ioParam.setMessage(MessageDefine.M_QUERY_OK);
	    
    	return EventDefine.E_QUERY_RESULT;
	}
	
	public int E105(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jObj = new JSONObject();
			jObj = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			
			String sql = new StringBuilder()
					.append("SELECT					\n")
					.append("	user_id,			\n")
					.append("	revision_no,		\n")
					.append("	user_nm,			\n")
					.append("	hpno,				\n")
					.append("	email,				\n")
					.append("	jikwi,				\n")
					.append("	group_cd,			\n")
					.append("	G.code_name,		\n")
					.append("	user_pwd,			\n")
					.append("	LOCATION,			\n")
					.append("	dept_cd,			\n")
					.append("	D.code_name,		\n")
					.append("	hour_pay,			\n")
					.append("	delyn,				\n")
					.append("	start_date,			\n")
					.append("	duration_date,		\n")
					.append("	create_user_id,		\n")
					.append("	create_date,		\n")
					.append("	modify_user_id,		\n")
					.append("	modify_reason,		\n")
					.append("	modify_date			\n")
					.append("FROM	tbm_users A		\n")
					.append("LEFT OUTER JOIN v_dept_code D											\n")
					.append("	ON A.dept_cd = D.code_value											\n")
					.append("	AND A.member_key = D.member_key										\n")
					.append("LEFT OUTER JOIN v_group_code G											\n")
					.append("	ON A.group_cd = G.code_value										\n")
					.append("	AND A.member_key = G.member_key										\n")
					.append("WHERE user_id like '%" + jObj.get("USER_ID") + "%'						\n")
					.append("AND TO_CHAR(SYSDATE,'YYYY-MM-DD') BETWEEN start_date AND duration_date	\n")
					.append("AND A.member_key = '" + jObj.get("member_key") + "' 					\n")
					.append("AND A.revision_no = (SELECT MAX(revision_no) 							\n")
					.append("						FROM tbm_users B 								\n")
					.append("                       WHERE A.user_id = B.user_id)					\n")
					.append("AND A.delyn = 'N'														\n")
					.append("ORDER BY user_id ASC, revision_no DESC									\n")
					.toString();  

			resultString = super.excuteQueryString(con, sql.toString());
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M909S080100E105()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M909S080100E105()","==== finally ===="+ e.getMessage());
				}
	    	} else {
	    	}
	    }
		
		ioParam.setResultString(resultString);
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
    	ioParam.setMessage(MessageDefine.M_QUERY_OK);
	    
    	return EventDefine.E_QUERY_RESULT;
	}
	
	public int E107(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jObj = new JSONObject();
			jObj = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			
			String sql = new StringBuilder()
					.append("SELECT					\n")
					.append("	user_id,			\n")
					.append("	revision_no,		\n")
					.append("	user_nm,			\n")
					.append("	hpno,				\n")
					.append("	email,				\n")
					.append("	jikwi,				\n")
					.append("	group_cd,			\n")
					.append("	G.code_name,		\n")
					.append("	user_pwd,			\n")
					.append("	LOCATION,			\n")
					.append("	dept_cd,			\n")
					.append("	D.code_name,		\n")
					.append("	hour_pay,			\n") // 2019-11-28 진욱추가
					.append("	delyn,				\n")
					.append("	start_date,			\n")
					.append("	duration_date,		\n")
					.append("	create_user_id,		\n")
					.append("	create_date,		\n")
					.append("	modify_user_id,		\n")
					.append("	modify_reason,		\n")
					.append("	modify_date			\n")
					.append("FROM	tbm_users A		\n")
					.append("LEFT OUTER JOIN v_dept_code D	\n")
					.append("	ON A.dept_cd = D.code_value	\n")
					.append("	AND A.member_key = D.member_key\n")
					.append("LEFT OUTER JOIN v_group_code G	\n")
					.append("	ON A.group_cd = G.code_value\n")
					.append("	AND A.member_key = G.member_key\n")
					.append("WHERE user_id = '" 	+ jObj.get("USER_ID") + "'	\n")
					.append("AND TO_CHAR(SYSDATE,'YYYY-MM-DD') BETWEEN start_date AND duration_date\n")
					.append("ORDER BY user_id ASC, revision_no DESC					\n")
					.toString();  

			resultString = super.excuteQueryString(con, sql.toString());
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M909S080100E107()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M909S080100E107()","==== finally ===="+ e.getMessage());
				}
	    	} else {
	    	}
	    }
		
		ioParam.setResultString(resultString);
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
    	ioParam.setMessage(MessageDefine.M_QUERY_OK);
	    
    	return EventDefine.E_QUERY_RESULT;
	}
	
	
	// CommonView/UserListView.jsp
	public int E114(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jObj = new JSONObject();
			jObj = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
    		
			String sql = new StringBuilder()
					.append("SELECT				\n")
					.append("	user_id,		\n")
					.append("	revision_no,	\n")
					.append("	user_nm,		\n")
					.append("	group_cd,		\n")
					.append("	dept_cd,		\n")
					.append("	jikwi,			\n")
					.append("	LOCATION,		\n")
					.append("	hpno,			\n")
					.append("	email,			\n")
					.append("	hour_pay,		\n")
					.append("	delyn,			\n")
					.append("	start_date,		\n")
					.append("	create_user_id,	\n")
					.append("	create_date,	\n")
					.append("	modify_user_id,	\n")
					.append("	modify_date,	\n")
					.append("	modify_reason,	\n")
					.append("	duration_date	\n")
					.append("FROM				\n")
					.append("	tbm_users		\n")
					.append("WHERE TO_CHAR(SYSDATE,'YYYY-MM-DD') BETWEEN start_date AND duration_date	\n")
					.append(" 	AND member_key = '" + jObj.get("member_key") + "' 					\n")
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
			LoggingWriter.setLogError("M838S050100E154()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M838S050100E154()","==== finally ===="+ e.getMessage());
				}
	    	} else {
	    	}
	    }

		ioParam.setResultString(resultString);
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
    	ioParam.setMessage(MessageDefine.M_QUERY_OK);
	    
    	return EventDefine.E_QUERY_RESULT;
	}
	
	
	// 아이디 중복체크
	public int E106(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jObj = new JSONObject();
			jObj = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			
			String sql = new StringBuilder()
					.append("SELECT COUNT(*) user_id FROM tbm_users  			\n")
					.append(" WHERE user_id = '" + jObj.get("userId") + "'	\n")
					.toString();

			resultString = super.excuteQueryString(con, sql.toString());
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M909S080100E106()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M909S080100E106()","==== finally ===="+ e.getMessage());
				}
	    	} else {
	    	}
	    }
		
		ioParam.setResultString(resultString);
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
    	ioParam.setMessage(MessageDefine.M_QUERY_OK);
	    
    	return EventDefine.E_QUERY_RESULT;
	}

	// 이력조건에 해당하는 사용자코드 목록을 GROUP BY 검색한다. 
	public int E204(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jObj = new JSONObject();
			jObj = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			
			String sql = new StringBuilder()
					.append("SELECT					\n")
					.append("	user_id,			\n")
					.append("	revision_no,		\n")
					.append("	user_nm,			\n")
					.append("	hpno,				\n")
					.append("	email,				\n")
					.append("	jikwi,				\n")
					.append("	group_cd,			\n")
					.append("	user_pwd,			\n")
					.append("	LOCATION,			\n")
					.append("	dept_cd,			\n")
					.append("	hour_pay,			\n")
					.append("	delyn,				\n")
					.append("	start_date,			\n")
					.append("	duration_date,		\n")
					.append("	create_user_id,		\n")
					.append("	create_date,		\n")
					.append("	modify_user_id,		\n")
					.append("	modify_reason,		\n")
					.append("	modify_date			\n")
					.append("FROM tbm_users			\n")
					.append("WHERE user_id = '" + jObj.get("USER_ID") + "'			\n")
					.append("	AND revision_no = '" + jObj.get("REVISION_NO") + "'	\n")
					.append(" 	AND member_key = '" + jObj.get("member_key") + "' 	\n")
					.append("ORDER BY user_id ASC, revision_no DESC						\n")
					.toString();  

			resultString = super.excuteQueryString(con, sql.toString());
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M909S080100E204()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M909S080100E204()","==== finally ===="+ e.getMessage());
				}
	    	} else {
	    	}
	    }
		
		ioParam.setResultString(resultString);
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
    	ioParam.setMessage(MessageDefine.M_QUERY_OK);
	    
    	return EventDefine.E_QUERY_RESULT;
	}
	
	// 메인페이지 개인정보 수정 팝업페이지 조회용 쿼리
	public int E304(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jObj = new JSONObject();
			jObj = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			
			String sql = new StringBuilder()
					.append("SELECT																\n")
					.append("	user_id,														\n")
					.append("	user_nm,														\n")
					.append("	hpno,															\n")
					.append("	email															\n")
					.append("FROM tbm_users														\n")
					.append("WHERE user_id = '" 	+ jObj.get("user_id") + "'				\n")
					.append("AND member_key = '" + jObj.get("member_key") + "' 				\n")
					.append("AND revision_no = (SELECT MAX(revision_no)  		  				\n")
					.append("                   FROM tbm_users 									\n")
					.append("                   WHERE user_id ='" + jObj.get("user_id") + "') \n")
					.toString();  

			resultString = super.excuteQueryString(con, sql.toString());
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M909S080100E304()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M909S080100E304()","==== finally ===="+ e.getMessage());
				}
	    	} else {
	    	}
	    }
		
		ioParam.setResultString(resultString);
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
    	ioParam.setMessage(MessageDefine.M_QUERY_OK);
	    
    	return EventDefine.E_QUERY_RESULT;
	}
	
	// 메인페이지 카카오톡 알람 수신자 정보 페이지 목록 조회용 쿼리
		public int E404(InoutParameter ioParam){
			resultInt = EventDefine.E_DOEXCUTE_INIT;
			
			try {
				con = JDBCConnectionPool.getConnection();
				
				JSONObject jObj = new JSONObject();
				jObj = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
				
				String sql = new StringBuilder()
						.append("SELECT																\n")
						.append("	A.user_id,														\n")
						.append("   A.hpno,															\n")
						.append("   A.revision_no													\n")
						.append("FROM tbm_users A													\n")
						.append("WHERE A.ccp_alarm_index != 'N'										\n")
						.append("AND A.revision_no = (SELECT MAX(revision_no) FROM tbm_users B		\n")
						.append("					 WHERE A.user_id = B.user_id)					\n")
						.append("ORDER BY A.ccp_alarm_index											\n")
						.toString();  

				resultString = super.excuteQueryString(con, sql.toString());
			} catch(Exception e) {
				e.printStackTrace();
				LoggingWriter.setLogError("M909S080100E404()","==== SQL ERROR ===="+ e.getMessage());
				return EventDefine.E_DOEXCUTE_ERROR ;
		    } finally {
		    	if (Config.useDataSource) {
					try {
						if (con != null) con.close();
					} catch (Exception e) {
						LoggingWriter.setLogError("M909S080100E404()","==== finally ===="+ e.getMessage());
					}
		    	} else {
		    	}
		    }
			
			ioParam.setResultString(resultString);
			ioParam.setColumnCount("" + super.COLUMN_COUNT);
	    	ioParam.setMessage(MessageDefine.M_QUERY_OK);
		    
	    	return EventDefine.E_QUERY_RESULT;
		}
	
	
	//Mysql_Menu Select UTLZ_XX MAX
	public int E974(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con_Mysql = JDBCConnectionPool.getConnection_Mysql();
			
			if(con_Mysql != null) {
				String sql = new StringBuilder()
					.append("SELECT CONCAT('UTLZ_', COALESCE(MAX(CAST(SUBSTR(USE_INTT_ID,6) AS DECIMAL)))) AS UTLZ_ID FROM chnl_per_use_intt_ldgr WHERE CHNL_ID='CHNL_64';\n")
					.toString();
	
				resultString = super.excuteQueryString(con_Mysql, sql.toString());
			}
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M909S080100E974()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M909S080100E974()","==== finally ===="+ e.getMessage());
				}
	    	} else {
	    	}
	    }
		
		ioParam.setResultString(resultString);
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
    	ioParam.setMessage(MessageDefine.M_QUERY_OK);
	    
    	return EventDefine.E_QUERY_RESULT;
	}
	
	public int E010(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jObj = new JSONObject();
			jObj = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			
			con.setAutoCommit(false);
			
			// 먼저 이전 리비전에 대한 적용종료일자를 이번의 적용일자에서 하루를 뺀 날짜로 변경한다.
			String sqlPre = new StringBuilder()
					.append("UPDATE tbm_users SET	\n")
					.append("	duration_date = TO_CHAR(TO_DATE('" + jObj.get("StartDate") + "', 'YYYY-MM-DD') - 1, 'YYYY-MM-DD'),	\n")
					.append("	member_key = '" + jObj.get("member_key") + "'															\n")
					.append("WHERE user_id = '" + jObj.get("UserCode") + "'															\n")
					.append("	AND revision_no = '" + jObj.get("RevisionNo_Target") + "'												\n")
					.append(" 	AND member_key = '" + jObj.get("member_key") + "' 													\n")
					.toString();
			
			resultInt = super.excuteUpdate(con, sqlPre.toString());
			if (resultInt < 0) {
				con.rollback();
				ioParam.setMessage(MessageDefine.M_UPDATE_FAILED);
				return resultInt;
			} else {
				ioParam.setMessage(resultInt + "건 " + MessageDefine.M_UPDATE_RESULT);
			}
			
			String sql = new StringBuffer()
					.append("INSERT INTO tbm_users ( 					\n")
					.append("	user_id,								\n")
					.append("	revision_no,							\n")
					.append("	user_nm,								\n")
					.append("	hpno,									\n")
					.append("	email,									\n")
					.append("	jikwi,									\n")
					.append("	group_cd,								\n")
					.append("	user_pwd,								\n")
					.append("	LOCATION,								\n")
					.append("	dept_cd,								\n")
					.append("	hour_pay,								\n")
					.append("	delyn,									\n")
					.append("	start_date,								\n")
					.append("	duration_date,							\n")
					.append("	create_user_id,							\n")
					.append("	create_date,							\n")
					.append("	modify_user_id,							\n")
					.append("	modify_reason,							\n")
					.append("	modify_date,							\n")
					.append(" 	member_key								\n")
					.append(")											\n")
					.append("VALUES (			 						\n")
					.append(" 	'" + jObj.get("UserCode") + "', 		\n")
					.append(" 	'" + jObj.get("RevisionNo") + "', 	\n")
					.append(" 	'" + jObj.get("UserName") + "', 		\n")
					.append(" 	'" + jObj.get("HpNo") + "', 			\n")
					.append(" 	'" + jObj.get("Email") + "', 			\n")
					.append(" 	'" + jObj.get("Jikwi") + "',			\n")
					.append(" 	'" + jObj.get("UserGroupCode") + "', 	\n")
					.append(" 	'" + jObj.get("PassWord") + "', 		\n")
					.append(" 	'" + jObj.get("UserDeptCode") + "', 	\n")
					.append(" 	'" + jObj.get("hour_pay") + "',	 	\n")
					.append(" 	'N', 									\n")
					.append("	'" + jObj.get("StartDate") + "',		\n")
					.append("	'9999-12-31',							\n")
					.append("	'" + jObj.get("user_id") + "',		\n")
					.append("	SYSDATETIME,							\n")
					.append("	'" + jObj.get("user_id") + "',		\n")
					.append("	'수정',									\n")
					.append("	SYSDATETIME,							\n")
					.append(" 	'" + jObj.get("member_key") + "' 		\n")
					.append("	)										\n")
					.toString();
			
			resultInt = super.excuteUpdate(con, sql);
			if (resultInt < 0) {
				con.rollback();
				ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
				return resultInt;
			} else {
				ioParam.setMessage(resultInt + "건 " + MessageDefine.M_INSERT_RESULT);
			}
			
			con.commit();
		} catch(Exception e) {
			LoggingWriter.setLogError("M909S080100E010()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M909S080100E010()","==== finally ===="+ e.getMessage());
				}
	    	} else {
	    	}
	    }

		ioParam.setResultString(resultString);
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
    	ioParam.setMessage(MessageDefine.M_QUERY_OK);

    	return EventDefine.E_QUERY_RESULT;
	}
	
	public int E020(InoutParameter ioParam){  //2021.02.23추가. (신무승) 메인화면 개인정보 수정용
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			con.setAutoCommit(false);
			
			JSONObject jObj = new JSONObject();
			jObj = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			
			// 기존 비밀번호 암호화
			String oldPw = jObj.get("PassWord_Old").toString();
			String hashedPwOld = PasswordHash.hashPassword(oldPw);
			
			// 새로운 비밀번호 암호화
			String newPw = jObj.get("PassWord_New").toString();
			String hashedPwNew = PasswordHash.hashPassword(newPw);
			
			String sqlPre = new StringBuilder()
					.append("UPDATE tbm_users SET								 					\n")
					.append("	user_pwd = '" + hashedPwNew + "',					  				\n")
					.append("	hpno = '" + jObj.get("HpNo") + "',			  					\n")
					.append("	email = '" + jObj.get("Email") + "'	  							\n")
					.append("WHERE user_id = '" + jObj.get("user_id") + "'	  					\n")
					.append("  AND user_pwd = '" + hashedPwOld + "'					  				\n")
					.append("  AND member_key = '" + jObj.get("member_key") + "'  				\n")
					.append("  AND revision_no = (SELECT MAX(revision_no)							\n")
					.append("					  FROM tbm_users 		  							\n")
					.append("                     WHERE user_id = '" + jObj.get("user_id") + "') 	\n")
					.toString();
			
			resultInt = super.excuteUpdate(con, sqlPre.toString());
			if (resultInt < 1) {
				con.rollback();
				ioParam.setMessage(MessageDefine.M_UPDATE_FAILED);
				return resultInt;
			} else {
				ioParam.setMessage(resultInt + "건 " + MessageDefine.M_UPDATE_RESULT);
			}
			
			con.commit();
		} catch(Exception e) {
			LoggingWriter.setLogError("M909S080100E020()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M909S080100E020()","==== finally ===="+ e.getMessage());
				}
	    	} else {
	    	}
	    }

		ioParam.setResultString(resultString);
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
    	ioParam.setMessage(MessageDefine.M_QUERY_OK);
	    
    	return EventDefine.E_QUERY_RESULT;
	}
	
	//메인페이지 카카오톡 알람 수신자 정보 수정용
	public int E030(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		String sql = "";
		try {
			con = JDBCConnectionPool.getConnection();
			con.setAutoCommit(false);
			
			JSONObject jObj = new JSONObject();
			jObj = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			
			JSONObject params = (JSONObject) jObj.get("params");
			JSONArray param = (JSONArray) params.get("param");
            
			//먼저 alarm 순서 다시 'N'으로 전체 update 
			sql = new StringBuilder()
					.append("UPDATE tbm_users SET					\n")
					.append("ccp_alarm_index = 'N'					\n")
					.toString();
			
			resultInt = super.excuteUpdate(con, sql.toString());
			if (resultInt < 1) {
				con.rollback();
				ioParam.setMessage(MessageDefine.M_UPDATE_FAILED);
				return resultInt;
			} else {
				ioParam.setMessage(resultInt + "건 " + MessageDefine.M_UPDATE_RESULT);
			}
			
			//그 다음 alarm 순서 다시 update 
			for(int i = 0; i < param.size(); i++) {
			JSONObject Info = (JSONObject) param.get(i);
			
			String kakao_user_id = (String) Info.get("kakao_user_id");
     	   	String order_index = (String) Info.get("order_index");
     	   	int user_rev_no = Integer.parseInt((String) Info.get("user_rev_no"));
				
			sql = new StringBuilder()
					.append("UPDATE tbm_users SET					\n")
					.append("ccp_alarm_index = '" + order_index + "'\n")
					.append("WHERE user_id = '" + kakao_user_id + "'\n")
					.append("AND revision_no = " + user_rev_no + "	\n")
					.toString();
			
			resultInt = super.excuteUpdate(con, sql.toString());
			if (resultInt < 1) {
				con.rollback();
				ioParam.setMessage(MessageDefine.M_UPDATE_FAILED);
				return resultInt;
			} else {
				ioParam.setMessage(resultInt + "건 " + MessageDefine.M_UPDATE_RESULT);
			}
		  }	
			con.commit();
		} catch(Exception e) {
			LoggingWriter.setLogError("M909S080100E030()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M909S080100E030()","==== finally ===="+ e.getMessage());
				}
	    	} else {
	    	}
	    }

		ioParam.setResultString(resultString);
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
    	ioParam.setMessage(MessageDefine.M_QUERY_OK);
	    
    	return EventDefine.E_QUERY_RESULT;
	}
	
	public int E112(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			con.setAutoCommit(false);
			
			JSONObject jObj = new JSONObject();
			jObj = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			
			// 초기 비밀번호 암호화
			String hashedPassword = PasswordHash.hashPassword(ProjectConstants.INITIAL_PASSWORD);
			
			String sqlPre = new StringBuilder()
					.append("UPDATE tbm_users SET							\n")
					.append("	user_pwd = '" + hashedPassword + "'			\n")
					.append("WHERE user_id = '" + jObj.get("userId") + "'	\n")
					.toString();
			
			resultInt = super.excuteUpdate(con, sqlPre.toString());
			if (resultInt < 1) {
				con.rollback();
				ioParam.setMessage(MessageDefine.M_UPDATE_FAILED);
				return resultInt;
			} else {
				ioParam.setMessage(resultInt + "건 " + MessageDefine.M_UPDATE_RESULT);
			}
			
			con.commit();
		} catch(Exception e) {
			LoggingWriter.setLogError("M909S080100E112()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M909S080100E112()","==== finally ===="+ e.getMessage());
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