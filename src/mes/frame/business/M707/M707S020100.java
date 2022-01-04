package mes.frame.business.M707;

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

public class M707S020100 extends SqlAdapter{
	Connection con = null;
	PreparedStatement pstmt = null;
	String resultString = "";
	int resultInt = -1;
	StringBuffer sql = new StringBuffer();
	
	String[][] v_paramArray = new String[0][0]; 
	Class[] optClass = null;
	Object[] optObj = null;
	Object obj = null;
	
	public M707S020100(){
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
			
			Method method = M707S020100.class.getMethod(event,optClass);
			LoggingWriter.setLogDebug(M707S020100.class.getName(),"==== " + event + " EventMethod Create Success ====");

			obj = method.invoke(M707S020100.class.newInstance(),optObj);
			doExcute_result = CommonFunction.getInt(obj.toString());
			
	    } catch (Exception ex) {
	    	doExcute_result = EventDefine.E_DOEXCUTE_INIT;
			ioParam.setMessage(MessageDefine.M_NO_EVENTID);
			LoggingWriter.setLogError(M707S020100.class.getName(),"==== EventID Not define : EVENT ID [ " + ioParam.getEventID() + "]");
	    } finally {
	    	obj = null;
			optClass = null;
			optObj = null;
	    }
	    long endTime = System.currentTimeMillis();
		long runningTime = endTime - startTime;
		LoggingWriter.setLogAll(M707S020100.class.getName(),"==== Query [수행시간  : " + runningTime + " ms]");
		
		return doExcute_result;
	}
	
	// 일&주별 모니터링 조회
	public int E104(InoutParameter ioParam) {
		
		String sql = "";
		
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();			
			
			JSONObject jObj = new JSONObject();
			jObj = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));

			String selectDate = jObj.get("selectDate").toString();
			String selectWeek = jObj.get("selectWeek").toString();
			
			if(!"".equals(selectDate) && selectDate != null && (selectWeek == null || "".equals(selectWeek))) {

				sql = new StringBuilder()
					.append("SELECT I.censor_no, I.censor_location, F.censor_date, NVL(F.sumcnt,0) AS fval\n")
					.append("FROM (SELECT V.censor_no, V.censor_location, V.censor_date, SUM(NVL(V.cnt, 0)) AS sumcnt\n")
					.append("			FROM (SELECT\n")
					.append("							A.censor_no,\n")
					.append("							A.censor_location,\n")
					.append("							B.censor_date,\n")
					.append("							TO_CHAR(B.censor_data_create_time, 'HH24'),\n")
					.append("							COUNT(NVL(B.censor_value0,0)) AS cnt\n")
					.append("						FROM\n")
					.append("							haccp_censor_info A\n")
					.append("							LEFT JOIN haccp_censor_data B\n")
					.append("							ON A.censor_no = B.censor_no\n")
					.append("						 GROUP BY B.censor_date, B.censor_no,TO_CHAR(B.censor_data_create_time, 'HH24')\n")
					.append("						HAVING  B.censor_date = '"+selectDate+"'\n")
					.append("							  AND TO_CHAR(B.censor_data_create_time, 'HH24:MI') BETWEEN '09:00' AND '17:00') V\n")
					.append("			GROUP BY V.censor_no, V.censor_date ) F 	\n")
					.append("RIGHT JOIN haccp_censor_info I\n")
					.append("ON F.censor_no = I.censor_no\n")
					.append("WHERE I.censor_type = 'TEMPERATURE'\n")
					.append("ORDER BY I.censor_no\n")
					.toString();
				
			} else if(selectWeek != null && !"".equals(selectWeek)){
				
				sql = new StringBuilder()
					.append("SELECT I.censor_no, I.censor_location, F.weekends, NVL(F.sumval, 0)\n")
					.append("FROM (SELECT V.censor_no, V.censor_location, V.weekends, SUM(NVL(V.cnt, 0)) AS sumval\n")
					.append("			FROM (SELECT\n")
					.append("							A.censor_no,\n")
					.append("							A.censor_location,\n")
					.append("							B.censor_date,\n")
					.append("							WEEK(B.censor_date) AS weekends,\n")
					.append("							TO_CHAR(B.censor_data_create_time, 'HH24'),\n")
					.append("							COUNT(NVL(B.censor_value0, 0)) AS cnt\n")
					.append("						FROM\n")
					.append("							haccp_censor_info A\n")
					.append("							LEFT JOIN haccp_censor_data B\n")
					.append("							ON A.censor_no = B.censor_no\n")
					.append("						 GROUP BY WEEK(B.censor_date), B.censor_no,TO_CHAR(B.censor_data_create_time, 'HH24'), B.censor_date\n")
					.append("						HAVING TO_CHAR(B.censor_date, 'YYYY') || '-W' || WEEK(B.censor_date) = '"+selectWeek+"' \n")
					.append("									AND TO_CHAR(B.censor_data_create_time, 'HH24:MI') BETWEEN '09:00' AND '17:00'\n")
					.append("									AND DAYOFWEEK(B.censor_date) BETWEEN 2 AND 6\n")
					.append("						ORDER BY B.censor_no ASC) V\n")
					.append("			GROUP BY V.censor_no ) F\n")
					.append("RIGHT JOIN haccp_censor_info I\n")
					.append("ON F.censor_no = I.censor_no\n")
					.append("WHERE I.censor_type = 'TEMPERATURE'\n")
					.append("ORDER BY I.censor_no\n")
					.toString();

			}

			resultString = super.excuteQueryString(con, sql);
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M707S020100E104()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
		} finally {
			if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M707S020100E104()","==== finally ===="+ e.getMessage());
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