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

public class M707S010600 extends SqlAdapter{
	
	static final Logger logger = Logger.getLogger(M707S010600.class.getName());

	Connection con = null;
	PreparedStatement pstmt = null;
	String resultString = "";
	int resultInt = -1;
	StringBuffer sql = new StringBuffer();
	
	String[][] v_paramArray = new String[0][0]; 
	Class[] optClass = null;
	Object[] optObj = null;
	Object obj = null;
	
	public M707S010600(){
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
			
			Method method = M707S010600.class.getMethod(event,optClass);
			logger.debug(event + " EventMethod Create Success");

			obj = method.invoke(M707S010600.class.newInstance(),optObj);
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
		logger.debug("Query 수행시간  : " + runningTime + " ms");
		
		return doExcute_result;
	}
	
	public int E034(InoutParameter ioParam) {
		
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
						
			con = JDBCConnectionPool.getConnection();

			String sql = new StringBuilder()
					.append("WITH narrow_data AS 															\n")
					.append("(																				\n")
					.append("	SELECT * FROM haccp_censor_data												\n")
					.append("	WHERE censor_no like 'temp_dev%'											\n")
					.append("	ORDER BY censor_date DESC, censor_data_create_time DESC						\n")
					.append("	LIMIT 50																	\n")
					.append(")																				\n")
					.append("SELECT																			\n")
					.append("	a.censor_no, 																\n")
					.append("	a.censor_value0,															\n")
					.append("	i.censor_location,															\n")
					.append("	i.min_value,																\n")
					.append("	i.max_value,																\n")
					.append("	a.censor_date,																\n")
					.append("	a.censor_data_create_time													\n")
					.append("FROM narrow_data a																\n")
					.append("INNER JOIN haccp_censor_info i													\n")
					.append("	ON a.censor_no = i.censor_no												\n")
					.append("	AND a.censor_rev_no = i.censor_rev_no										\n")
					.append("WHERE a.censor_data_create_time = (SELECT MAX(censor_data_create_time)			\n")
					.append("								   	FROM haccp_censor_data a2					\n")
					.append("								   	WHERE a.censor_no = a2.censor_no			\n")
					.append("								   	  AND a.censor_rev_no = a2.censor_rev_no	\n")
					.append("								   	  AND a.censor_date = a2.censor_date)		\n")
					.append("  AND i.censor_type = 'TEMPERATURE'											\n")
					.append("GROUP BY a.censor_no															\n")
					.append("ORDER BY a.censor_no ASC														\n")
					.toString();
			
			resultString = super.excuteQueryString(con, sql);
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M707S010600E034()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M707S010600E034()","==== finally ===="+ e.getMessage());
				}
	    	} else {
	    	}
	    }
		ioParam.setResultString(resultString);
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
    	ioParam.setMessage(MessageDefine.M_QUERY_OK);
    	
	    return EventDefine.E_QUERY_RESULT;
	}	
		

	
	
	
	
	
	
	

	
	
	
	

	
	
	
	
	

	
// ================================================================
// ========================== 태양꺼 ================================


//	CCP 모니터링(M707S010600.jsp) 
	public int E104(InoutParameter ioParam){
		
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
						
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			
//			String sql = new StringBuilder()
//					.append("WITH censordata AS (\n")
//					.append("        SELECT\n")
//					.append("           DISTINCT        \n")
//					.append("           censor_no,\n")
////					.append("            MAX(censor_data_create_time) over(PARTITION BY censor_no) AS censor_data_create_time\n")
//					.append("            MAX(censor_data_create_time) AS censor_data_create_time\n")
//					.append("        FROM\n")
//					.append("           haccp_censor_data\n")
////					.append("        WHERE  member_key = '"+jArray.get("member_key")+"'\n")
//					.append("        GROUP BY    \n")
//					.append("           censor_no\n")
//					.append(")\n")
//					.append("SELECT\n")
//					.append("        ci.ccp_name,\n")
//					.append("        cd.censor_value,\n")
//					.append("        li.min_value,\n")
//					.append("        li.max_value,\n")
//					.append("        cd.censor_data_create_time,\n")
//					.append("        ci.ccp_type\n")
//					.append("FROM censordata A \n")
//					.append("INNER JOIN  haccp_censor_data cd \n")
//					.append("        ON A.censor_no = cd.censor_no  AND A. censor_data_create_time = cd.censor_data_create_time\n")
////					.append("		AND A.member_key = cd.member_key\n")
//					.append("        INNER JOIN haccp_ccp_info ci ON cd.censor_no = ci.censor_no\n")
////					.append("		AND cd.member_key = ci.member_key\n")
//					.append("        INNER JOIN haccp_limit_info li ON ci.ccp_no = li.ccp_no\n")
//					.append("		AND ci.member_key = li.member_key\n")
//					.append("WHERE \n")
////					.append("cd.member_key = '"+jArray.get("member_key")+"'\n")
//					.append("ci.member_key = '"+jArray.get("member_key")+"'\n")
//					.toString();
			
			
			String sql = new StringBuilder()
					.append("WITH censordata AS (\n")
					.append("        SELECT\n")
					.append("           DISTINCT\n")
					.append("           censor_no,\n")
					.append("            MAX(censor_data_create_time) AS censor_data_create_time\n")
					.append("        FROM\n")
					.append("           haccp_censor_data\n")
					.append("        GROUP BY\n")
					.append("           censor_no\n")
					.append(")\n")
					.append("SELECT\n")
					.append("        hci.censor_name,\n")
					.append("        cd.censor_value,\n")
					.append("        li.min_value,\n")
					.append("        li.max_value,\n")
					.append("        cd.censor_data_create_time,\n")
					.append("        hci.censor_type\n")
					.append("FROM censordata A\n")
					.append("INNER JOIN  haccp_censor_data cd\n")
					.append("        ON A.censor_no = cd.censor_no  AND A. censor_data_create_time = cd.censor_data_create_time\n")
					.append("        INNER JOIN haccp_censor_info hci ON  hci.censor_no = cd.censor_no\n")
					.append("        RIGHT OUTER JOIN haccp_ccp_info ci\n")
					.append("        ON cd.censor_no = ci.censor_no \n")
					.append("        LEFT OUTER JOIN haccp_limit_info li ON ci.ccp_no = li.ccp_no\n")
					.append("WHERE\n")
					.append("cd.member_key = '"+jArray.get("member_key")+"' \n")
					.append("AND hci.censor_type ='temperature'  \n")
					.append("AND ci.monitor_yn ='Y'  \n")
					.append("ORDER BY  min_value desc \n")
					.append(";\n")
					.toString();







			resultString = super.excuteQueryString(con, sql.toString());
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M707S010600E104()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M707S010600E104()","==== finally ===="+ e.getMessage());
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
	
	
	
	public int E105(InoutParameter ioParam){
	
		
		String serial;			
		String measured_at;			
		int  channel;			
		String type;			
		String value;			
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			
//			JSONArray resultArr = (JSONArray)jArray.get("measurements");
			//JSONObject tmp = (JSONObject)resultArr.get(0);
			//JSONArray valueArr = (JSONArray)tmp.get("params");
			//JSONObject param = (JSONObject)valueArr.get(0);
			System.out.println("결과표 ===========================================================================================================");
//			System.out.println("길이 : "+resultArr.size());
//			System.out.println(resultArr);
			
//			for(int i=0; i<resultArr.size(); i++) {
//				JSONObject innerArr = (JSONObject)resultArr.get(i);
//				JSONArray valueArr = (JSONArray)innerArr.get("params");
//				JSONObject params = (JSONObject)valueArr.get(0);
//				serial = innerArr.get("serial").toString();
//				measured_at = innerArr.get("measured_at").toString();
//				channel = Integer.parseInt(params.get("channel").toString());
//				type = params.get("type").toString();
//				value = params.get("value").toString();
				serial = jArray.get("serial").toString();
				measured_at = jArray.get("measured_at").toString();
				channel = Integer.parseInt(jArray.get("channel").toString());
				type = jArray.get("type").toString();
				value = jArray.get("value").toString();
				
				System.out.println("시리얼 번호 : "+serial);
				System.out.println("데이터 발생시간 : "+measured_at);
				
				System.out.println("채널번호 : " +channel);
				System.out.println("타입 : " +type);
				System.out.println("데이터값 : " +value);
				
				String sql = new StringBuilder()
						.append("MERGE  INTO haccp_censor_data  mm     \n")
						.append("USING ( SELECT     \n")
						.append("	'"+serial+"'  	  AS censor_no,		\n")
						.append("	'"+channel+"' AS censor_channel_no,		\n")
						.append("	'"+type+"' AS censor_data_type,	\n")
						.append("	'"+value+"'AS censor_value,	\n")
						.append("	  SYSDATETIME AS censor_data_create_time,	\n")
						.append("	'"+measured_at+"' AS censor_date, \n")
						.append("	'"+jArray.get("member_key").toString()+"' AS member_key\n")
						.append(")  mQ    \n")
//						.append("ON (mm.censor_no = mQ.censor_no AND mm.censor_channel_no = mQ.censor_channel_no AND mm.censor_data_create_time = mQ.censor_data_create_time)    \n")
						.append("ON (mm.censor_no = mQ.censor_no AND mm.censor_channel_no = mQ.censor_channel_no  AND mm.censor_data_create_time = mQ.censor_data_create_time)  \n")
						.append("WHEN MATCHED THEN     \n")
						.append("		UPDATE SET     \n")
						.append("			mm.censor_no		= mQ.censor_no,		mm.censor_channel_no 	= mQ.censor_channel_no,	mm.censor_data_type	= mQ.censor_data_type,mm.censor_value	= mQ.censor_value,	    \n")
						.append("			mm.censor_data_create_time	= mQ.censor_data_create_time,	mm.censor_date		= mQ.censor_date	\n")
						.append("WHEN NOT MATCHED THEN \n")
//						.append("	INSERT  (mm.censor_no, mm.censor_channel_no, mm.censor_data_type, mm.censor_value, mm.censor_data_create_time, mm.censor_date, mm.member_key)    \n")
//						.append("	VALUES  (mQ.censor_no, mQ.censor_channel_no, mQ.censor_data_type, mQ.censor_value, mQ.censor_data_create_time, mQ.censor_date, mQ.member_key)    \n")
						.append("	INSERT  (mm.censor_no, mm.censor_channel_no, mm.censor_data_type, mm.censor_value, mm.censor_data_create_time, mm.censor_date, mm.member_key)    \n")
						.append("	VALUES  (mQ.censor_no, mQ.censor_channel_no, mQ.censor_data_type, mQ.censor_value, mQ.censor_data_create_time, mQ.censor_date, mQ.member_key)    \n")
						.append(";\n")
						.toString();
	
	
	
				resultInt = super.excuteUpdate(con, sql.toString());
				
				
//			}
//			for(int i=0; i<resultArr.size(); i++) {
//				serial = tmp.get("serial").toString();
//				measured_at = tmp.get("measured_at").toString();
//				channel = Integer.parseInt(param.get("channel").toString());
//				type = param.get("type").toString();
//				value = param.get("value").toString();
//			
//				System.out.println("시리얼 번호 : "+serial);
//				System.out.println("데이터 발생시간 : "+measured_at);
//				
//				System.out.println("채널번호 : " +channel);
//				System.out.println("타입 : " +type);
//				System.out.println("데이터값 : " +value);
//				
//			}
		
//			
			
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M707S010600E105()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M707S010600E105()","==== finally ===="+ e.getMessage());
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
	
	
	public int E106(InoutParameter ioParam){
		
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
						
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));

			String sql = new StringBuilder()
					.append("SELECT\n")
					.append("	hzrd_cd,\n")
					.append("	hzrd_nm\n")
					.append("FROM\n")
					.append("	tbm_hzrd_info\n")
					.append("WHERE \n")
					.append("	ccp_name = '"+jArray.get("name")+"' AND\n")
					.append("	member_key = '"+jArray.get("member_key")+"'\n")
					.append(";\n")
					.toString();

			resultString = super.excuteQueryString(con, sql.toString());
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M707S010600E106()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M707S010600E106()","==== finally ===="+ e.getMessage());
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
	
	
	public int E107(InoutParameter ioParam){
		
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
						
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));

			String sql = new StringBuilder()
					.append("SELECT \n")
					.append("  DATE_ADD(MAX(censor_data_create_time),INTERVAL "+jArray.get("time_cycle")+" MINUTE) < SYSDATETIME \n")
					.append("FROM haccp_censor_data\n")
					.append("WHERE \n")
					.append("	censor_no = '"+jArray.get("serial")+"'\n")
					.toString();


			resultString = super.excuteQueryString(con, sql.toString());
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M707S010600E107()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M707S010600E107()","==== finally ===="+ e.getMessage());
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
	
	
	public int E108(InoutParameter ioParam){
		
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
						
			con = JDBCConnectionPool.getConnection();

			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));

			String sql = new StringBuilder()
					.append("SELECT \n")
					.append("  member_key \n")
					.append("FROM haccp_censor_info\n")
					.append("WHERE \n")
					.append("	censor_no = '"+jArray.get("serial")+"'\n")
					.toString();


			resultString = super.excuteQueryString(con, sql.toString());
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M707S010600E108()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M707S010600E108()","==== finally ===="+ e.getMessage());
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
	
	
	public int E109(InoutParameter ioParam){
		
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
						
			con = JDBCConnectionPool.getConnection();
			System.out.println("E108 들어옴");
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));

			String sql = new StringBuilder()
					.append("SELECT\n")
					.append("	CAST(censor_value AS INT) <= "+jArray.get("censor_value")+"\n")
					.append("FROM\n")
					.append("	haccp_censor_data\n")
					.append("WHERE \n")
					.append("	censor_no = '"+jArray.get("censor_no")+"' AND\n")
					.append("	censor_data_create_time = (SELECT \n")
					.append("											MAX(censor_data_create_time)\n")
					.append("										 FROM \n")
					.append("										 haccp_censor_data\n")
					.append("										 WHERE \n")
					.append("										 censor_no = '"+jArray.get("censor_no")+"')\n")
					.toString();

			resultString = super.excuteQueryString(con, sql.toString());
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M707S010600E109()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M707S010600E109()","==== finally ===="+ e.getMessage());
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
	
	
	
	
	
public int E111(InoutParameter ioParam){
	
		
		String serial;			
		String measured_at;			
		int  channel;			
		String type;			
		String value;			
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));

				
				String sql = new StringBuilder()
						.append("MERGE  INTO haccp_censor_data  mm     \n")
						.append("USING ( SELECT     \n")
						.append("	'"+jArray.get("censor_no")+"' AS censor_no,		\n")
						.append("	'"+jArray.get("censor_channel_no")+"' AS censor_channel_no,		\n")
						.append("	'"+jArray.get("censor_data_type")+"' AS censor_data_type,	\n")
						.append("	'"+jArray.get("censor_value")+"' AS censor_value,	\n")
						.append("	  SYSDATETIME AS censor_data_create_time,	\n")
						.append("	  SYSDATETIME AS censor_date, \n")
						.append("	'137-86-07935' AS member_key\n")
						.append(")  mQ    \n")
//						.append("ON (mm.censor_no = mQ.censor_no AND mm.censor_channel_no = mQ.censor_channel_no AND mm.censor_data_create_time = mQ.censor_data_create_time)    \n")
						.append("ON (mm.censor_no = mQ.censor_no AND mm.censor_channel_no = mQ.censor_channel_no  AND mm.censor_data_create_time = mQ.censor_data_create_time)  \n")
						.append("WHEN MATCHED THEN     \n")
						.append("		UPDATE SET     \n")
						.append("			mm.censor_no		= mQ.censor_no,		mm.censor_channel_no 	= mQ.censor_channel_no,	mm.censor_data_type	= mQ.censor_data_type,mm.censor_value	= mQ.censor_value,	    \n")
						.append("			mm.censor_data_create_time	= mQ.censor_data_create_time,	mm.censor_date		= mQ.censor_date	\n")
						.append("WHEN NOT MATCHED THEN \n")
//						.append("	INSERT  (mm.censor_no, mm.censor_channel_no, mm.censor_data_type, mm.censor_value, mm.censor_data_create_time, mm.censor_date, mm.member_key)    \n")
//						.append("	VALUES  (mQ.censor_no, mQ.censor_channel_no, mQ.censor_data_type, mQ.censor_value, mQ.censor_data_create_time, mQ.censor_date, mQ.member_key)    \n")
						.append("	INSERT  (mm.censor_no, mm.censor_channel_no, mm.censor_data_type, mm.censor_value, mm.censor_data_create_time, mm.censor_date, mm.member_key)    \n")
						.append("	VALUES  (mQ.censor_no, mQ.censor_channel_no, mQ.censor_data_type, mQ.censor_value, mQ.censor_data_create_time, mQ.censor_date, mQ.member_key)    \n")
						.append(";\n")
						.toString();
	
	
	
				resultInt = super.excuteUpdate(con, sql.toString());
				
				
//			}
//			for(int i=0; i<resultArr.size(); i++) {
//				serial = tmp.get("serial").toString();
//				measured_at = tmp.get("measured_at").toString();
//				channel = Integer.parseInt(param.get("channel").toString());
//				type = param.get("type").toString();
//				value = param.get("value").toString();
//			
//				System.out.println("시리얼 번호 : "+serial);
//				System.out.println("데이터 발생시간 : "+measured_at);
//				
//				System.out.println("채널번호 : " +channel);
//				System.out.println("타입 : " +type);
//				System.out.println("데이터값 : " +value);
//				
//			}
		
//			
			
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M707S010600E105()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M707S010600E105()","==== finally ===="+ e.getMessage());
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
	
}



