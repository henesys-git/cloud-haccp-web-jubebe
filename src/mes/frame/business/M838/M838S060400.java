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
public  class M838S060400 extends SqlAdapter{
	Connection con = null;
	PreparedStatement pstmt = null;
	String resultString = "";
	int resultInt = -1;
	StringBuffer sql = new StringBuffer();
	
	String[][] v_paramArray = new String[0][0]; 
	Class[] optClass = null;
	Object[] optObj = null;
	Object obj = null;
	
	public M838S060400(){
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
			
			Method method = M838S060400.class.getMethod(event,optClass);
			LoggingWriter.setLogDebug(M838S060400.class.getName(),"==== " + event + " EventMethod Create Success ====");

			obj = method.invoke(M838S060400.class.newInstance(),optObj);
			doExcute_result = CommonFunction.getInt(obj.toString());
			
	    } catch (Exception ex) {
	    	doExcute_result = EventDefine.E_DOEXCUTE_INIT;
			ioParam.setMessage(MessageDefine.M_NO_EVENTID);
			LoggingWriter.setLogError(M838S060400.class.getName(),"==== EventID Not define : EVENT ID [ " + ioParam.getEventID() + "]");
	    } finally {
	    	obj = null;
			optClass = null;
			optObj = null;
	    }
	    long endTime = System.currentTimeMillis();
		long runningTime = endTime - startTime;
		LoggingWriter.setLogAll(M838S060400.class.getName(),"==== Query [수행시간  : " + runningTime + " ms]");
		
		return doExcute_result;
	}
	
	// S838S015100.jsp
	public int E104(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			System.out.println("JSONObject jArray rcvData="+ jArray.toString());
    		
			String sql = new StringBuilder()
				.append("SELECT DISTINCT\n")
				.append("	A.cust_cd AS subcontractor_no,\n")
				.append("	B.subcontractor_rev,\n")
				.append("	B.subcontractor_seq,\n")
				.append("	C.product_division,\n")
				.append("	A.cust_nm,\n")
				.append("	A.boss_name,\n")
				.append("	A.telno,\n")
				.append("	B.appraisal_means,\n")
				.append("	B.approve_date,\n")
				.append("	B.approval,\n")
				.append("	C.product_bigo,\n")
				.append("	A.member_key\n")
				.append("FROM tbm_customer A\n")
				.append("LEFT OUTER JOIN haccp_subcontractor_present B\n")
				.append("	ON (A.cust_cd = B.subcontractor_no)\n")
				.append("LEFT OUTER JOIN haccp_subcontractor_product C\n")
				.append("	ON (A.cust_cd = C.subcontractor_no)\n")
				.append("WHERE A.member_key = '" + jArray.get("member_key") + "' \n")
				.append("GROUP BY A.cust_cd, B.subcontractor_rev, B.subcontractor_seq, C.product_division\n")
				.append("ORDER BY B.approve_date\n")
				.toString();
		
			/*
			 * .append("SELECT\n") .append("	A.subcontractor_no,\n")
			 * .append("	A.subcontractor_rev,\n") .append("	A.subcontractor_seq,\n")
			 * .append("	B.product_division,\n") .append("	C.cust_nm,\n")
			 * .append("	C.boss_name,\n") .append("	C.telno,\n")
			 * .append("	A.appraisal_means,\n") .append("	A.approve_date,\n")
			 * .append("	A.approval,\n") .append("	B.product_bigo,\n")
			 * .append("	A.member_key\n") .append("FROM\n")
			 * .append("	haccp_subcontractor_present A\n")
			 * .append("JOIN haccp_subcontractor_product B ON (B.subcontractor_no = A.subcontractor_no)\n"
			 * ) .append("JOIN tbm_customer C ON (C.cust_cd = A.subcontractor_no)\n")
			 * .append("WHERE A.member_key = '" + jArray.get("member_key") + "' \n")
			 * .append("GROUP BY A.subcontractor_no, A.subcontractor_rev, A.subcontractor_seq, B.product_division\n"
			 * ) .append("ORDER BY A.approve_date\n") .toString();
			 */
			String ActionCommand = ioParam.getActionCommand();
			if(ActionCommand.startsWith("doQueryTableFieldName")) {
				resultString = super.excuteQueryStringTableFieldName(con, sql.toString());
			}
			else {
				resultString = super.excuteQueryString(con, sql.toString());
			}
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M838S060400E104()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M838S060400E104()","==== finally ===="+ e.getMessage());
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
	
	// S838S015100_canvas.jsp
	public int E144(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			System.out.println("JSONObject jArray rcvData="+ jArray.toString());
    		
			String sql = new StringBuilder()
					.append("SELECT DISTINCT\n")
					.append("	A.cust_cd AS subcontractor_no,\n")
					.append("	B.subcontractor_rev,\n")
					.append("	B.subcontractor_seq,\n")
					.append("	C.product_division,\n")
					.append("	A.cust_nm,\n")
					.append("	A.boss_name,\n")
					.append("	A.telno,\n")
					.append("	B.appraisal_means,\n")
					.append("	B.approve_date,\n")
					.append("	B.approval,\n")
					.append("	C.product_bigo,\n")
					.append("	A.member_key,\n")
					.append("	A.faxno\n")
					.append("FROM tbm_customer A\n")
					.append("LEFT OUTER JOIN haccp_subcontractor_present B\n")
					.append("	ON (A.cust_cd = B.subcontractor_no)\n")
					.append("LEFT OUTER JOIN haccp_subcontractor_product C\n")
					.append("	ON (A.cust_cd = C.subcontractor_no)\n")
					.append("WHERE A.member_key = '" + jArray.get("member_key") + "' \n")
					.append("GROUP BY A.cust_cd, B.subcontractor_rev, B.subcontractor_seq, C.product_division\n")
					.append("ORDER BY B.approve_date\n")
					.toString();
			
					
					
/*					.append("SELECT\n")
					.append("	A.subcontractor_no,\n")
					.append("	A.subcontractor_rev,\n")
					.append("	A.subcontractor_seq,\n")
					.append("	B.product_division,\n")
					.append("	C.cust_nm,\n")
					.append("	C.boss_name,\n")
					.append("	C.telno,\n")
					.append("	A.appraisal_means,\n")
					.append("	A.approve_date,\n")
					.append("	A.approval,\n")
					.append("	B.product_bigo,\n")
					.append("	A.member_key,\n")
					.append("	C.faxno\n")
					.append("FROM\n")
					.append("	haccp_subcontractor_present A\n")
					.append("JOIN haccp_subcontractor_product B ON (B.subcontractor_no = A.subcontractor_no)\n")
					.append("JOIN tbm_customer C ON (C.cust_cd = A.subcontractor_no)\n")
					.append("WHERE A.member_key = '" + jArray.get("member_key") + "' \n")
					.append("GROUP BY A.subcontractor_no, A.subcontractor_rev, A.subcontractor_seq, B.product_division\n")
					.append("ORDER BY A.approve_date\n")
					.toString();*/
			
			String ActionCommand = ioParam.getActionCommand();
			if(ActionCommand.startsWith("doQueryTableFieldName")) {
				resultString = super.excuteQueryStringTableFieldName(con, sql.toString());
			}
			else {
				resultString = super.excuteQueryString(con, sql.toString());
			}
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M838S060400E144()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M838S060400E144()","==== finally ===="+ e.getMessage());
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