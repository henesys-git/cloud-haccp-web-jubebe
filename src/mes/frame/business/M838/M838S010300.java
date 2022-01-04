package mes.frame.business.M838;
/*BOM코드*/
import java.lang.reflect.Method;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.util.Vector;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;

import mes.frame.common.ApprovalActionNo;
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
public  class M838S010300 extends SqlAdapter{
	Connection con = null;
	PreparedStatement pstmt = null;
	String resultString = "";
	int resultInt = -1;
	StringBuffer sql = new StringBuffer();
	
	String[][] v_paramArray = new String[0][0]; 
	Class[] optClass = null;
	Object[] optObj = null;
	Object obj = null;
	
	public M838S010300(){
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
			
			Method method = M838S010300.class.getMethod(event,optClass);
			LoggingWriter.setLogDebug(M838S010300.class.getName(),"==== " + event + " EventMethod Create Success ====");

			obj = method.invoke(M838S010300.class.newInstance(),optObj);
			doExcute_result = CommonFunction.getInt(obj.toString());
			
	    } catch (Exception ex) {
	    	doExcute_result = EventDefine.E_DOEXCUTE_INIT;
			ioParam.setMessage(MessageDefine.M_NO_EVENTID);
			LoggingWriter.setLogError(M838S010300.class.getName(),"==== EventID Not define : EVENT ID [ " + ioParam.getEventID() + "]");
	    } finally {
	    	obj = null;
			optClass = null;
			optObj = null;
	    }
	    long endTime = System.currentTimeMillis();
		long runningTime = endTime - startTime;
		LoggingWriter.setLogAll(M838S010300.class.getName(),"==== Query [수행시간  : " + runningTime + " ms]");
		
		return doExcute_result;
	}
	
	// S838S010301.jsp
	public int E101(InoutParameter ioParam){ 
		resultInt = EventDefine.E_DOEXCUTE_INIT;

		try {
			con = JDBCConnectionPool.getConnection();
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			System.out.println("JSONObject jArray rcvData="+ jArray.toString());
    		JSONArray jjArray = (JSONArray) jArray.get("param");
    		JSONObject jjjArray = (JSONObject)jjArray.get(0);
			
    		String sql = new StringBuilder()
				.append("INSERT INTO\n")
				.append("	haccp_transfer_duties_report (\n")
				.append("		handover_name,\n")
				.append("		handover_rev,\n")
				.append("		handover_date,\n")
				.append("		handover_dept,\n")
				.append("		handover_position,\n")
				.append("		accept_period_start,\n")
				.append("		accept_period_end,\n")
				.append("		accept_cause,\n")
				.append("		accept_contents,\n")
				.append("		acceptor,\n")
				.append("		acceptor_rev,\n")
				.append("		accept_date,\n")
				.append("		acceptor_dept,\n")
				.append("		acceptor_position,\n")
				.append("		writor,\n")
				.append("		writor_rev,\n")
				.append("		write_date,\n")
				.append("		approval,\n")
				.append("		approval_rev,\n")
				.append("		approve_date,\n")
				.append("		member_key\n")
				.append("	)\n")
				.append("VALUES\n")
				.append("	(\n")
				.append("		'"+ jjjArray.get("handover_name") + "',\n")
				.append("		'"+ jjjArray.get("handover_rev") + "',\n")
				.append("		'"+ jjjArray.get("handover_date") + "',\n")
				.append("		'"+ jjjArray.get("handover_dept") + "',\n")
				.append("		'"+ jjjArray.get("handover_position") + "',\n")
				.append("		'"+ jjjArray.get("accept_period_start") + "',\n")
				.append("		'"+ jjjArray.get("accept_period_end") + "',\n")
				.append("		'"+ jjjArray.get("accept_cause") + "',\n")
				.append("		'"+ jjjArray.get("accept_contents") + "',\n")
				.append("		'"+ jjjArray.get("acceptor") + "',\n")
				.append("		'"+ jjjArray.get("acceptor_rev") + "',\n")
				.append("		'"+ jjjArray.get("accept_date") + "',\n")
				.append("		'"+ jjjArray.get("acceptor_dept") + "',\n")
				.append("		'"+ jjjArray.get("acceptor_position") + "',\n")
				.append("		'"+ jjjArray.get("writor") + "',\n")
				.append("		'"+ jjjArray.get("writor_rev") + "',\n")
				.append("		'"+ jjjArray.get("write_date") + "',\n")
				.append("		'"+ jjjArray.get("approval") + "',\n")
				.append("		'"+ jjjArray.get("approval_rev") + "',\n")
				.append("		'"+ jjjArray.get("approve_date") + "',\n")
				.append("		'"+ jjjArray.get("member_key") + "' \n") 
				.append("	);\n")
				.toString();
			
			resultInt = super.excuteUpdate(con, sql.toString());
	    	if(resultInt < 0){  //
				ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
				con.rollback();
				return EventDefine.E_DOEXCUTE_ERROR ;
			}		
			con.commit();
		} catch(Exception e) {
			e.getStackTrace();
			LoggingWriter.setLogError("M838S010300E101()","==== SQL ERROR ===="+ e.getMessage());
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
	
	// S838S010302.jsp
	public int E102(InoutParameter ioParam){ 
		resultInt = EventDefine.E_DOEXCUTE_INIT;

		try {
			con = JDBCConnectionPool.getConnection();
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			System.out.println("JSONObject jArray rcvData="+ jArray.toString());
    		JSONArray jjArray = (JSONArray) jArray.get("param");
    		JSONObject jjjArray = (JSONObject)jjArray.get(0);
    		String sql = new StringBuilder()
				.append("UPDATE\n")
				.append("	haccp_transfer_duties_report A \n")
				.append("SET\n")
				.append("		handover_name		= '" + jjjArray.get("handover_name") + "',\n")
				.append("		handover_rev		= '" + jjjArray.get("handover_rev") + "',\n")
				.append("		handover_date		= '" + jjjArray.get("handover_date") + "',\n")
				.append("		handover_dept		= '" + jjjArray.get("handover_dept") + "',\n")
				.append("		handover_position	= '" + jjjArray.get("handover_position") + "',\n")
				.append("		accept_period_start	= '" + jjjArray.get("accept_period_start") + "',\n")
				.append("		accept_period_end	= '" + jjjArray.get("accept_period_end") + "',\n")
				.append("		accept_cause		= '" + jjjArray.get("accept_cause") + "',\n")
				.append("		accept_contents		= '" + jjjArray.get("accept_contents") + "',\n")
				.append("		acceptor			= '" + jjjArray.get("acceptor") + "',\n")
				.append("		acceptor_rev		= '" + jjjArray.get("acceptor_rev") + "',\n")
				.append("		accept_date			= '" + jjjArray.get("accept_date") + "',\n")
				.append("		acceptor_dept		= '" + jjjArray.get("acceptor_dept") + "',\n")
				.append("		acceptor_position	= '" + jjjArray.get("acceptor_position") + "',\n")
				.append("		writor				= '" + jjjArray.get("writor") + "',\n")
				.append("		writor_rev			= '" + jjjArray.get("writor_rev") + "',\n")
				.append("		write_date			= '" + jjjArray.get("write_date") + "',\n")
				.append("		approval			= '" + jjjArray.get("approval") + "',\n")
				.append("		approval_rev		= '" + jjjArray.get("approval_rev") + "',\n")
				.append("		approve_date		= '" + jjjArray.get("approve_date") + "',\n")
				.append("		member_key			= '" + jjjArray.get("member_key") + "'\n")
				.append("WHERE A.handover_name 		= '" + jjjArray.get("exist_hname") 	+ "' \n")
				.append("AND A.handover_rev 		= '" + jjjArray.get("exist_hname_rev") 	+ "' \n")
				.append("AND A.acceptor 			= '" + jjjArray.get("exist_aname") 	+ "' \n")
				.append("AND A.acceptor_rev 		= '" + jjjArray.get("exist_aname_rev") + "' \n")
				.append("AND A.accept_cause 		= '" + jjjArray.get("exist_acause") + "' \n")					
				.append("AND A.member_key 			= '" + jjjArray.get("member_key") + "' \n") 
				.toString();

			resultInt = super.excuteUpdate(con, sql.toString());
	    	if(resultInt < 0){  //
				ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
				con.rollback();
				return EventDefine.E_DOEXCUTE_ERROR ;
			}		
			con.commit();
		} catch(Exception e) {
			e.getStackTrace();
			LoggingWriter.setLogError("M838S010300E102()","==== SQL ERROR ===="+ e.getMessage());
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

	// S838S010303.jsp
	public int E103(InoutParameter ioParam){ 
		resultInt = EventDefine.E_DOEXCUTE_INIT;

		try {
			con = JDBCConnectionPool.getConnection();
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			System.out.println("JSONObject jArray rcvData="+ jArray.toString());
    		JSONArray jjArray = (JSONArray) jArray.get("param");
    		JSONObject jjjArray = (JSONObject)jjArray.get(0);
    		String sql = new StringBuilder()
				.append("DELETE FROM\n")
				.append("	haccp_transfer_duties_report A \n")
				.append("WHERE A.handover_name 		= '" + jjjArray.get("exist_hname") 	+ "' \n")
				.append("AND A.handover_rev 		= '" + jjjArray.get("exist_hname_rev") 	+ "' \n")
				.append("AND A.acceptor 			= '" + jjjArray.get("exist_aname") 	+ "' \n")
				.append("AND A.acceptor_rev 		= '" + jjjArray.get("exist_aname_rev") + "' \n")
				.append("AND A.accept_cause 		= '" + jjjArray.get("exist_acause") + "' \n")					
				.append("AND A.member_key 			= '" + jjjArray.get("member_key") + "' \n") 
				.toString();

			resultInt = super.excuteUpdate(con, sql.toString());
	    	if(resultInt < 0){  //
				ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
				con.rollback();
				return EventDefine.E_DOEXCUTE_ERROR ;
			}		
			con.commit();
		} catch(Exception e) {
			e.getStackTrace();
			LoggingWriter.setLogError("M838S010300E103()","==== SQL ERROR ===="+ e.getMessage());
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
	
	// S838S010300.jsp
	public int E104(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			System.out.println("JSONObject jArray rcvData="+ jArray.toString());
    		
			String sql = new StringBuilder()
					.append("SELECT\n")
					.append("	handover_name,\n")
					.append("	handover_rev,\n")
					.append("	handover_date,\n")
					.append("	handover_dept,\n")
					.append("	handover_position,\n")
					.append("	accept_period_start,\n")
					.append("	accept_period_end,\n")
					.append("	accept_cause,\n")
					.append("	accept_contents,\n")
					.append("	acceptor,\n")
					.append("	acceptor_rev,\n")
					.append("	accept_date,\n")
					.append("	acceptor_dept,\n")
					.append("	acceptor_position,\n")
					.append("	writor,\n")
					.append("	writor_rev,\n")
					.append("	write_date,\n")
					.append("	approval,\n")
					.append("	approval_rev,\n")
					.append("	approve_date,\n")
					.append("	member_key\n")
					.append("FROM\n")
					.append("	haccp_transfer_duties_report A \n")
					.append("WHERE write_date \n")
					.append("BETWEEN '" + jArray.get("fromdate") + "' 	\n")
					.append("	 AND '" + jArray.get("todate") + "'	\n")
					.append(" 	AND A.member_key = '" + jArray.get("member_key") + "' \n") 
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
			LoggingWriter.setLogError("M838S010300E104()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M838S010300E104()","==== finally ===="+ e.getMessage());
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
	
	// S838S010300.jsp
	public int E114(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			System.out.println("JSONObject jArray rcvData="+ jArray.toString());
    		
			String sql = new StringBuilder()
					.append("SELECT\n")
					.append("	handover_name,\n")
					.append("	handover_rev,\n")
					.append("	handover_date,\n")
					.append("	handover_dept,\n")
					.append("	handover_position,\n")
					.append("	accept_period_start,\n")
					.append("	accept_period_end,\n")
					.append("	accept_cause,\n")
					.append("	accept_contents,\n")
					.append("	acceptor,\n")
					.append("	acceptor_rev,\n")
					.append("	accept_date,\n")
					.append("	acceptor_dept,\n")
					.append("	acceptor_position,\n")
					.append("	writor,\n")
					.append("	writor_rev,\n")
					.append("	write_date,\n")
					.append("	approval,\n")
					.append("	approval_rev,\n")
					.append("	approve_date,\n")
					.append("	member_key\n")
					.append("FROM\n")
					.append("	haccp_transfer_duties_report A \n")
					.append("WHERE A.handover_name 	= '" + jArray.get("handover_name") 	+ "' \n")
					.append("AND A.handover_rev 	= '" + jArray.get("handover_rev") 	+ "' \n")
					.append("AND A.acceptor 	= '" + jArray.get("acceptor") 	+ "' \n")
					.append("AND A.acceptor_rev 	= '" + jArray.get("acceptor_rev") 	+ "' \n")
					.append("AND A.accept_cause 	= '" + jArray.get("accept_cause") 	+ "' \n")					
					.append("AND A.member_key 	= '" + jArray.get("member_key") 	+ "' \n") 
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
			LoggingWriter.setLogError("M838S010300E104()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M838S010300E104()","==== finally ===="+ e.getMessage());
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