package mes.frame.business.M707;

import java.lang.reflect.Method;
import java.sql.Connection;
import java.sql.PreparedStatement;

import org.apache.log4j.Logger;
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

public class M707S010800 extends SqlAdapter{
	
	static final Logger logger = Logger.getLogger(M707S010800.class.getName());
	
	Connection con = null;
	PreparedStatement pstmt = null;
	String resultString = "";
	int resultInt = -1;
	StringBuffer sql = new StringBuffer();
	
	String[][] v_paramArray = new String[0][0]; 
	Class[] optClass = null;
	Object[] optObj = null;
	Object obj = null;
	
	public M707S010800(){
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
			
			Method method = M707S010800.class.getMethod(event,optClass);
			logger.debug(event + " EventMethod Create Success ====");
			
			obj = method.invoke(M707S010800.class.newInstance(),optObj);
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
		logger.debug("Query [수행시간  : " + runningTime + " ms]");
		
		return doExcute_result;
	}
	
	// 인터페이스 데이터 insert
	public int E001(InoutParameter ioParam){
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));

			sql.append("INSERT INTO haccp_censor_data (                             \n");
			sql.append("        censor_no,                                          \n");
			sql.append("        censor_rev_no,                                      \n");
			sql.append("        censor_date,                                        \n");
			sql.append("        censor_data_create_time,                            \n");
			sql.append("        censor_value0                                       \n");
			sql.append(") VALUES (                                                  \n");
			sql.append("        '"+jArray.get("censor_no")+"',                      \n");
			sql.append("        (SELECT MAX(censor_rev_no)                          \n");
			sql.append("         FROM haccp_censor_info                             \n");
			sql.append("         WHERE censor_no = '"+jArray.get("censor_no")+"'),  \n");
			sql.append("        SYSDATE,                                            \n");
			sql.append("        SYSTIME,                                            \n");
			sql.append("        '"+jArray.get("censor_value")+"'                    \n");
			sql.append(");                                                          \n");

			resultInt = super.excuteUpdate(con, sql.toString());
			if (resultInt < 0) {
				ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
				return EventDefine.E_DOEXCUTE_ERROR;
			}
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M050S010000E001()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M050S010000E001()","==== finally ===="+ e.getMessage());
				}
	    	} else {
	    	}
	    }
	    
		ioParam.setResultString(resultString);
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
		ioParam.setMessage(MessageDefine.M_QUERY_OK);
    	
	    return EventDefine.E_QUERY_RESULT;
	}
	
	public int E004(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArr = new JSONObject();
			jArr = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			
			String sql = new StringBuilder()
					.append("SELECT																\n")
					.append("	A.censor_no, B.censor_name, A.eachhour, MAX(A.censor_value0)	\n")
					.append("FROM																\n")
					.append("	(																\n")
					.append("	SELECT															\n")
					.append("	       censor_no,												\n")
					.append("	       censor_rev_no,											\n")
					.append("	       EXTRACT(HOUR FROM censor_data_create_time) AS eachhour,	\n")
					.append("	       censor_value0											\n")
					.append("	FROM															\n")
					.append("	       haccp_censor_data										\n")
					.append("	WHERE															\n")
					.append("	       censor_date = '" + jArr.get("date") + "'					\n")
					.append("	       AND censor_no LIKE 'temp_dev%'							\n")
					.append("	) A																\n")
					.append("INNER JOIN haccp_censor_info b										\n")
					.append("	ON A.censor_no = B.censor_no									\n")
					.append("	AND A.censor_rev_no = B.censor_rev_no							\n")
					.append("GROUP by A.censor_no, A.eachhour;									\n")
					.toString();

			resultString = super.excuteQueryString(con, sql);
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M707S010800E004()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M707S010800E004()","==== finally ===="+ e.getMessage());
				}
	    	}
	    }
		ioParam.setResultString(resultString);
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
    	ioParam.setMessage(MessageDefine.M_QUERY_OK);

    	return EventDefine.E_QUERY_RESULT;
	}

	// 온도계 장소 이름 가져오기
	public int E005(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArr = new JSONObject();
			jArr = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			
			String sql = new StringBuilder()
					.append("SELECT\n")
					.append("	censor_no,\n")
					.append("	censor_rev_no,\n")
					.append("	censor_name,\n")
					.append("	censor_location\n")
					.append("FROM\n")
					.append("	haccp_censor_info\n")
					.append("WHERE\n")
					.append("	censor_no LIKE 'temp_dev%'			\n")
					.append("	AND SYSDATE BETWEEN start_date AND duration_date\n")
					.append("ORDER BY censor_no ASC\n")
					.toString();

			resultString = super.excuteQueryString(con, sql);
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M707S010800E005()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M707S010800E005()","==== finally ===="+ e.getMessage());
				}
	    	}
	    }
		ioParam.setResultString(resultString);
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
    	ioParam.setMessage(MessageDefine.M_QUERY_OK);

    	return EventDefine.E_QUERY_RESULT;
	}
	
}