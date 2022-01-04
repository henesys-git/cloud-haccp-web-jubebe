package mes.frame.business.M808;

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
public class M808S010100 extends SqlAdapter{
	Connection con = null;
	PreparedStatement pstmt = null;
	String resultString = "";
	int resultInt = -1;
	StringBuffer sql = new StringBuffer();
	
	String[][] v_paramArray = new String[0][0]; 
	Class[] optClass = null;
	Object[] optObj = null;
	Object obj = null;
	
	public M808S010100(){
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
			
			Method method = M808S010100.class.getMethod(event,optClass);
			LoggingWriter.setLogDebug(M808S010100.class.getName(),"==== " + event + " EventMethod Create Success ====");

			obj = method.invoke(M808S010100.class.newInstance(),optObj);
			doExcute_result = CommonFunction.getInt(obj.toString());
			
	    } catch (Exception ex) {
	    	doExcute_result = EventDefine.E_DOEXCUTE_INIT;
			ioParam.setMessage(MessageDefine.M_NO_EVENTID);
			LoggingWriter.setLogError(M808S010100.class.getName(),"==== EventID Not define : EVENT ID [ " + ioParam.getEventID() + "]");
	    } finally {
	    	obj = null;
			optClass = null;
			optObj = null;
	    }
	    long endTime = System.currentTimeMillis();
		long runningTime = endTime - startTime;
		LoggingWriter.setLogAll(M808S010100.class.getName(),"==== Query [수행시간  : " + runningTime + " ms]");
		
		return doExcute_result;
	}
	
	// ccp 데이터 조회
	public int E104(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jObj = new JSONObject();
			jObj = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			
			String breakVal = jObj.get("CheckGubunBreakaway").toString().trim();
			String improve_action = ", c.code_name AS improve_action, \n u.user_nm AS person_approve_id \n";
			if("0".equals(breakVal)) {	// 정상
				breakVal = "AND a.censor_value0 BETWEEN b.min_value AND b.max_value";
				improve_action = "";	
			} else if("1".equals(breakVal)) {	// 이탈
				breakVal = "AND !a.censor_value0 BETWEEN b.min_value AND b.max_value";
			} else {	// 전체
				improve_action = ",DECODE(a.censor_value0 BETWEEN b.min_value AND b.max_value, TRUE, '정상', '이탈')"; //status
			}
			
			String sql = new StringBuilder()
					.append("SELECT																\n")
					.append("	a.censor_no,													\n")
					.append("	a.censor_rev_no,												\n")
					.append("	b.censor_name,													\n")
					.append("	b.censor_type,													\n")
					.append("	b.censor_location,												\n")
					.append("	a.censor_date,													\n")
					.append("	a.censor_data_create_time,										\n")
					.append("	b.min_value,													\n")
					.append("	b.max_value,													\n")
					.append("	a.censor_value0													\n")	
					.append("	"+improve_action+"												\n")
					.append("FROM																\n")
					.append("	haccp_censor_data a												\n")
					.append("INNER JOIN haccp_censor_info b										\n")
					.append("	ON a.censor_no = b.censor_no									\n")
					.append("	AND a.censor_rev_no = b.censor_rev_no							\n")
					.append("LEFT JOIN tbm_code_book c											\n")
					.append("	ON a.improve_action = c.code_value   							\n")
					.append("LEFT JOIN tbm_users u												\n")
					.append("	ON a.person_approve_id = u.user_id								\n")
					.append("	AND a.censor_date BETWEEN u.start_date AND u.duration_date    	\n")
					.append("WHERE b.delyn != 'Y'												\n")
					.append("	AND (censor_date BETWEEN '"+jObj.get("fromdate")+"'				\n")
					.append("		 AND '"+jObj.get("todate")+"')								\n")
					.append("   AND b.censor_name like '"+jObj.get("CheckGubunName")+"%' 		\n")
					.append("   AND b.censor_type like '"+jObj.get("CheckGubunType")+"%' 		\n")
					.append("   AND b.censor_location like '"+jObj.get("CheckGubunLocation")+"%'\n")
					.append("   "+breakVal+" 													\n")
					.toString();

			resultString = super.excuteQueryString(con, sql);
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M808S010100E104()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M808S010100E104()","==== finally ===="+ e.getMessage());
				}
	    	} else {
	    	}
	    }
		ioParam.setResultString(resultString);
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
    	ioParam.setMessage(MessageDefine.M_QUERY_OK);
	    
    	return EventDefine.E_QUERY_RESULT;
	}
	
	public int E111(InoutParameter ioParam){ 
		resultInt = EventDefine.E_DOEXCUTE_INIT;

		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			System.out.println("JSONObject jArray rcvData="+ jArray.toString());

			
			String sql = new StringBuilder()
					.append("INSERT INTO\n")
					.append("	haccp_ccp_check (\n")
					.append("		product_name,\n")
					.append("		record_date,\n")
					.append("		entry_top_value,\n")
					.append("		entry_bottom_value,\n")
					.append("		mid_top_value,\n")
					.append("		mid_bottom_value,\n")
					.append("		exit_top_value,\n")
					.append("		exit_bottom_value,\n")
					.append("		rpm,\n")
					.append("		material_value,\n")
					.append("		decision,\n")
					.append("		signature,\n")
					.append("		writer,\n")
					.append("		grantor,\n")
					.append("		write_date,\n")
					.append("		checker,\n")
					.append("		breakaway_content,\n")
					.append("		remedial_action,\n")
					.append("		measurer,\n")
					.append("		content_check\n")
					.append("	)\n")
					.append("VALUES\n")
					.append("	(\n")
					.append("		'"+jArray.get("product_name")+"',\n")
					.append("		SYSDATETIME,\n")
					.append("		'"+jArray.get("entry_top")+"',\n")
					.append("		'"+jArray.get("entry_bottom")+"',\n")
					.append("		'"+jArray.get("mid_top")+"',\n")
					.append("		'"+jArray.get("mid_bottom")+"',\n")
					.append("		'"+jArray.get("exit_top")+"',\n")
					.append("		'"+jArray.get("exit_bottom")+"',\n")
					.append("		'"+jArray.get("rpm")+"',\n")
					.append("		'"+jArray.get("material")+"',\n")
					.append("		'"+jArray.get("decision")+"',\n")
					.append("		'"+jArray.get("writer")+"',\n")
					.append("		'"+jArray.get("writer")+"',\n")
					.append("		'"+jArray.get("grantor")+"',\n")
					.append("		SYSDATETIME,\n")
					.append("		'"+jArray.get("checker")+"',\n")
					.append("		'',\n")
					.append("		'',\n")
					.append("		'',\n")
					.append("		''\n")
					.append("	);\n")
					.toString();

			// System.out.println(sql.toString());
			resultInt = super.excuteUpdate(con, sql.toString());
    		if (resultInt < 0) {  //
				ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
				con.rollback();
				return EventDefine.E_DOEXCUTE_ERROR ;
			} 
			con.commit();
		} catch(Exception e) {
			LoggingWriter.setLogError("M808S010100E111()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M808S010100E111()","==== finally ===="+ e.getMessage());
				}
	    	} else {
	    	}
	    }
		ioParam.setResultString(resultString);
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
    	ioParam.setMessage(MessageDefine.M_QUERY_OK);
	    return EventDefine.E_QUERY_RESULT;
	}
	
	// ccp 확인 서명(개선조치사항)
	public int E502(InoutParameter ioParam){ 
		
		resultInt = EventDefine.E_DOEXCUTE_INIT;

		try {
			con = JDBCConnectionPool.getConnection();
			con.setAutoCommit(false);
			
    		JSONObject jObj = new JSONObject();
    		jObj = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));

    		String sql = new StringBuilder()
    				.append("UPDATE haccp_censor_data										\n")
    				.append("SET															\n")
    				.append("	person_approve_id = '" + jObj.get("userId") + "',			\n")
    				.append("	improve_action = '" + jObj.get("improve_cd") + "'			\n")
    				.append("WHERE censor_no = '"+ jObj.get("censor_no") + "'				\n")
    				.append("  AND censor_rev_no = '"+ jObj.get("censor_rev_no") + "'		\n")
    				.append("  AND censor_date = '"+ jObj.get("ccp_date") + "'				\n")
    				.append("  AND censor_data_create_time = '"+ jObj.get("ccp_time") + "'	\n")
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
			LoggingWriter.setLogError("M808S010100E502()","==== SQL ERROR ===="+ e.getMessage());
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