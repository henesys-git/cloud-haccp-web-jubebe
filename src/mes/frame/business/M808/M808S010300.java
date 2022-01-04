package mes.frame.business.M808;
/*BOM코드*/
import java.lang.reflect.Method;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.util.Vector;

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
public  class M808S010300 extends SqlAdapter{
	Connection con = null;
	PreparedStatement pstmt = null;
	String resultString = "";
	int resultInt = -1;
	StringBuffer sql = new StringBuffer();
	
	String[][] v_paramArray = new String[0][0]; 
	Class[] optClass = null;
	Object[] optObj = null;
	Object obj = null;
	
	public M808S010300(){
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
			
			Method method = M808S010300.class.getMethod(event,optClass);
			LoggingWriter.setLogDebug(M808S010300.class.getName(),"==== " + event + " EventMethod Create Success ====");

			obj = method.invoke(M808S010300.class.newInstance(),optObj);
			doExcute_result = CommonFunction.getInt(obj.toString());
			
	    } catch (Exception ex) {
	    	doExcute_result = EventDefine.E_DOEXCUTE_INIT;
			ioParam.setMessage(MessageDefine.M_NO_EVENTID);
			LoggingWriter.setLogError(M808S010300.class.getName(),"==== EventID Not define : EVENT ID [ " + ioParam.getEventID() + "]");
	    } finally {
	    	obj = null;
			optClass = null;
			optObj = null;
	    }
	    long endTime = System.currentTimeMillis();
		long runningTime = endTime - startTime;
		LoggingWriter.setLogAll(M808S010300.class.getName(),"==== Query [수행시간  : " + runningTime + " ms]");
		
		return doExcute_result;
	}
	public int E104(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			System.out.println("JSONObject jArray rcvData="+ jArray.toString());
			
			// 클라이언트로 부터 받은 파라미터를 옮겨 담는다.
//			String rcvData = (String)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			// 클라이언트로 부터 받은 파라미터를 쪼개어서 배열에 담는다.
			// rcvData = [위경도]
//			String[][] c_paramArray = CommonFunction.getConvString2DoubleArray(rcvData);

			String sql = new StringBuilder()
					.append("SELECT\n")
					.append("	A.as_request_no,\n")
					.append("	A.order_no,\n")
					.append("	A.revision_no,\n")
					.append("	A.reg_date,\n")
					.append("	A.reg_user_id,\n")
					.append("	A.req_channel,\n")
					.append("	A.req_man_name,\n")
					.append("	A.work_hope_date,\n")
					.append("	A.as_status_cd,\n")
					.append("	A.as_count,\n")
					.append("	A.recept_date,\n")
					.append("	A.req_contents,\n")
					.append("	A.product_cd,\n")
					.append("	A.product_nm,\n")
					.append("	A.cust_cd,\n")
					.append("	A.lotno,\n")
					.append("	B.as_result_no,\n")
					.append("	B.jemok\n")
					.append("FROM\n")
					.append("	tbi_as_request A\n")
					.append("LEFT OUTER JOIN tbi_as_result B\n")
					.append("ON A.as_request_no = B.as_request_no\n")
					.append("	AND A.member_key = B.member_key\n")
					.append("WHERE A.reg_date \n")
					.append("BETWEEN '" + jArray.get("fromdate") + "' 	\n")
					.append("	 AND '" + jArray.get("todate") + "'	\n")
					.append(" 	AND A.member_key = '" + jArray.get("member_key") + "' \n") //member_key_select, update, delete
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
			LoggingWriter.setLogError("M808S010300E104()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M808S010300E104()","==== finally ===="+ e.getMessage());
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
	
	public int E101(InoutParameter ioParam){ 
		resultInt = EventDefine.E_DOEXCUTE_INIT;

		ApprovalActionNo ActionNo;
		String AS_NO="";
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			System.out.println("JSONObject jArray rcvData="+ jArray.toString());
			
//			String[][] c_paramArray_Head=null;
//			String[][] c_paramArray_Detail=null;
			
//			String rcvData = (String)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
//			Vector resultVector = CommonFunction.getConvStringDamogjuk(rcvData);
			con.setAutoCommit(false);

//			c_paramArray_Head = (String[][])resultVector.get(0);//head table
//    		c_paramArray_Detail=(String[][])resultVector.get(1); //data table
    		
    		String jspPage = (String) jArray.get("jsppage");
	    	String user_id = (String) jArray.get("user_id");
	    	String prefix = (String) jArray.get("prefix");
	    	String actionGubun = "Regist";
	    	String detail_seq = (String) jArray.get("order_detail_seq");
	    	String member_key = (String) jArray.get("member_key");
			ActionNo = new ApprovalActionNo();
			AS_NO = ActionNo.getActionNo(con,jspPage,user_id,prefix,actionGubun,detail_seq,member_key);//GV_JSPPAGE(action Page), User ID, prefix
			
			String sql = new StringBuilder()
					.append("INSERT INTO\n")
					.append("	tbi_as_result (\n")
					.append("		as_request_no,\n")
					.append("		as_result_no,\n")
					.append("		revision_no,\n")
					.append("		order_no,\n")
					.append("		lotno,\n")
					.append("		reg_date,\n")
					.append("		reg_user_id,\n")
					.append("		req_channel,\n")
					.append("		req_man_name,\n")
					.append("		work_hope_date,\n")
					.append("		as_status_cd,\n")
					.append("		as_count,\n")
					.append("		recept_date,\n")
					.append("		req_contents,\n")
					.append("		product_cd,\n")
					.append("		product_nm,\n")
					.append("		cust_cd,\n")
					.append("		repare_date,\n")
					.append("		chulgo_date,\n")
					.append("		req_review_note,\n")
					.append("		repare_note,\n")
					.append("		repare_inspect,\n")
					.append("		result_bigo, \n")
					.append("		jemok \n")
					.append(" 		,member_key	\n") // member_key_insert
					.append("	)\n")
					.append("VALUES\n")
					.append("	(\n")
					.append("		'" + jArray.get("as_no") + "',\n")
					.append("		'" + AS_NO + "',\n")
					.append("		'" + jArray.get("revision_no") + "',\n")
					.append("		'" + jArray.get("order_no") + "',\n")
					.append("		'" + jArray.get("lotno") + "',\n")
					.append("		'" + jArray.get("reg_date") + "',\n")
					.append("		'" + jArray.get("reg_user") + "',\n")
					.append("		'" + jArray.get("req_channel") + "',\n")
					.append("		'" + jArray.get("req_man") + "',\n")
					.append("		'" + jArray.get("work_date") + "',\n")
					.append("		'" + jArray.get("as_status") + "',\n")
					.append("		'" + jArray.get("as_count") + "',\n")
					.append("		'" + jArray.get("recept_date") + "',\n")
					.append("		'" + jArray.get("content") + "',\n")
					.append("		'" + jArray.get("product_cd") + "',\n")
					.append("		'" + jArray.get("product_nm") + "',\n")
					.append("		'" + jArray.get("cust_cd") + "',\n")
					.append("		'" + jArray.get("repare_date") + "',\n")
					.append("		'" + jArray.get("chulgo_date") + "',\n")
					.append("		'" + jArray.get("review_note") + "',\n")
					.append("		'" + jArray.get("note") + "',\n")
					.append("		'" + jArray.get("inspect") + "',\n")
					.append("		'" + jArray.get("bigo") + "',\n")
					.append("		'" + jArray.get("jemok") + "'\n")
					.append(" 		,'" + jArray.get("member_key") + "' \n") //member_key_values
					.append("	)\n")
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
			LoggingWriter.setLogError("M808S010300E101()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M808S010300E101()","==== finally ===="+ e.getMessage());
				}
	    	} else {
	    	}
	    }
		ioParam.setResultString(resultString);
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
    	ioParam.setMessage(MessageDefine.M_QUERY_OK);
	    return EventDefine.E_QUERY_RESULT;
}	
	
	public int E102(InoutParameter ioParam){ 
		resultInt = EventDefine.E_DOEXCUTE_INIT;

		ApprovalActionNo ActionNo;
		String AS_NO="";
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			System.out.println("JSONObject jArray rcvData="+ jArray.toString());
			
//			String[][] c_paramArray_Head=null;
//			String[][] c_paramArray_Detail=null;
//			
//			String rcvData = (String)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
//			Vector resultVector = CommonFunction.getConvStringDamogjuk(rcvData);
			con.setAutoCommit(false);

//			c_paramArray_Head = (String[][])resultVector.get(0);//head table
//    		c_paramArray_Detail=(String[][])resultVector.get(1); //data table
					
    		
    		String sql = new StringBuilder()
    				.append("UPDATE\n")
    				.append("	tbi_as_result\n")
    				.append("SET\n")
    				.append("	as_request_no = '" + jArray.get("as_no") + "',\n")
    				.append("	as_result_no = '" + jArray.get("as_nos") + "',\n")
    				.append("	revision_no = '" + jArray.get("revision_no") + "',\n")
    				.append("	order_no = '" + jArray.get("order_no") + "',\n")
    				.append("	lotno = '" + jArray.get("lotno") + "',\n")
    				.append("	reg_date = '" + jArray.get("reg_date") + "',\n")
    				.append("	reg_user_id = '" +jArray.get("reg_user") + "',\n")
    				.append("	req_channel = '" + jArray.get("req_channel") + "',\n")
    				.append("	req_man_name = '" + jArray.get("req_man") + "',\n")
    				.append("	work_hope_date = '" + jArray.get("work_date") + "',\n")
    				.append("	as_status_cd = '" + jArray.get("as_status") + "',\n")
    				.append("	as_count = '" + jArray.get("as_count") + "',\n")
    				.append("	recept_date = '" + jArray.get("recept_date") + "',\n")
    				.append("	req_contents = '" + jArray.get("content") + "',\n")
    				.append("	product_cd = '" + jArray.get("product_cd") + "',\n")
    				.append("	product_nm = '" + jArray.get("product_nm") + "',\n")
    				.append("	cust_cd = '" + jArray.get("cust_cd") + "',\n")
    				.append("	repare_date = '" + jArray.get("repare_date") + "',\n")
    				.append("	chulgo_date = '" + jArray.get("chulgo_date") + "',\n")
    				.append("	req_review_note = '" + jArray.get("review") + "',\n")
    				.append("	repare_note = '" + jArray.get("note") + "',\n")
    				.append("	repare_inspect = '" + jArray.get("inspect") + "'\n")
    				.append(" 	,member_key = 	'" + jArray.get("member_key") + "'		\n") //member_key_update
    				.append("WHERE\n")
    				.append("	as_result_no = '" + jArray.get("as_nos") + "'\n")
    				.append("	AND as_request_no = '" + jArray.get("as_no") + "'\n")
    				.append("	AND revision_no = '" + jArray.get("revision_no") + "'\n")
    				.append("	AND order_no = '" + jArray.get("order_no") + "'\n")
    				.append("	AND lotno = '" + jArray.get("lotno") + "'\n")
    				.append(" 	AND member_key = '" + jArray.get("member_key") + "' \n") //member_key_select, update, delete
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
			LoggingWriter.setLogError("M808S010300E102()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M808S010300E102()","==== finally ===="+ e.getMessage());
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

		ApprovalActionNo ActionNo;
		String AS_NO="";
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			System.out.println("JSONObject jArray rcvData="+ jArray.toString());
			
//			String[][] c_paramArray_Head=null;
//			String[][] c_paramArray_Detail=null;
//			
//			String rcvData = (String)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
//			Vector resultVector = CommonFunction.getConvStringDamogjuk(rcvData);
			con.setAutoCommit(false);

//			c_paramArray_Head = (String[][])resultVector.get(0);//head table
//    		c_paramArray_Detail=(String[][])resultVector.get(1); //data table
					
    		
    		String sql = new StringBuilder()
    				.append("DELETE FROM\n")
    				.append("	tbi_as_result\n")
    				.append("WHERE\n")
    				.append("	as_request_no = '" + jArray.get("as_no") + "'\n")
    				.append("	AND as_result_no = '" + jArray.get("as_nos") + "'\n")
    				.append("	AND revision_no = '" + jArray.get("revision_no") + "'\n")
    				.append("	AND order_no = '" + jArray.get("order_no") + "'\n")
    				.append("	AND lotno = '" + jArray.get("lotno") + "'\n")
    				.append(" 	AND member_key = '" + jArray.get("member_key") + "' \n") //member_key_select, update, delete
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
			LoggingWriter.setLogError("M808S010300E103()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M808S010300E103()","==== finally ===="+ e.getMessage());
				}
	    	} else {
	    	}
	    }
		ioParam.setResultString(resultString);
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
    	ioParam.setMessage(MessageDefine.M_QUERY_OK);
	    return EventDefine.E_QUERY_RESULT;
}
	
	public int E114(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			System.out.println("JSONObject jArray rcvData="+ jArray.toString());
			
			// 클라이언트로 부터 받은 파라미터를 옮겨 담는다.
//			String rcvData = (String)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			// 클라이언트로 부터 받은 파라미터를 쪼개어서 배열에 담는다.
			// rcvData = [위경도]
//			String[][] c_paramArray = CommonFunction.getConvString2DoubleArray(rcvData);

			String sql = new StringBuilder()
					.append("SELECT\n")
					.append("	as_request_no,\n")
					.append("   as_result_no,\n")
					.append("   order_no,\n")
					.append("   lotno,\n")
					.append("   revision_no,\n")
					.append("   req_contents,\n")
					.append("   product_cd,\n")
					.append("   product_nm,\n")
					.append("   cust_cd,\n")
					.append("   repare_date,\n")
					.append("	chulgo_date,\n")
					.append("	jemok,\n")
					.append("	req_review_note,\n")
					.append("	repare_note,\n")
					.append("	repare_inspect,\n")
					.append("	result_bigo\n")
					.append("FROM\n")
					.append("	tbi_as_result\n")
					.append("WHERE\n")
					.append("as_result_no =	'" + jArray.get("ASNOS") + "'\n")
					.append(" 	AND member_key = '" + jArray.get("member_key") + "' \n") //member_key_select, update, delete
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
			LoggingWriter.setLogError("M808S010300E114()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M808S010300E114()","==== finally ===="+ e.getMessage());
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
	
	public int E124(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			System.out.println("JSONObject jArray rcvData="+ jArray.toString());
			
			// 클라이언트로 부터 받은 파라미터를 옮겨 담는다.
//			String rcvData = (String)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			// 클라이언트로 부터 받은 파라미터를 쪼개어서 배열에 담는다.
			// rcvData = [위경도]
//			String[][] c_paramArray = CommonFunction.getConvString2DoubleArray(rcvData);
			String sql = new StringBuilder()
					.append("SELECT\n")
					.append("	as_request_no,\n")
					.append("	revision_no,\n")
					.append("	order_no,\n")
					.append("	lotno,\n")
					.append("TO_CHAR(reg_date,'YYYY-MM-DD') AS reg_date,\n")
					.append("	reg_user_id,\n")
					.append("	req_channel,\n")
					.append("	req_man_name,\n")
					.append("TO_CHAR(work_hope_date,'YYYY-MM-DD') AS work_hope_date,\n")
					.append("	as_status_cd,\n")
					.append("	as_count,\n")
					.append("TO_CHAR(recept_date,'YYYY-MM-DD') AS recept_date,\n")
					.append("	req_contents,\n")
					.append("	product_cd,\n")
					.append("	product_nm,\n")
					.append("	cust_cd\n")
					.append("FROM\n")
					.append("	tbi_as_request\n")
					.append("WHERE\n")
					.append("	as_request_no = '" +  jArray.get("GV_ASNO") + "'\n")
					.append(" 	AND member_key = '" + jArray.get("member_key") + "' \n") //member_key_select, update, delete
					
					.toString();



			String ActionCommand = ioParam.getActionCommand();
			if(ActionCommand.startsWith("doQueryTableFieldName")) {
				resultString = super.excuteQueryStringTableFieldName(con, sql.toString());
			}
			else {;
				resultString = super.excuteQueryString(con, sql.toString());
			}
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M808S010300E124()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M808S010300E124()","==== finally ===="+ e.getMessage());
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



public int E134(InoutParameter ioParam){
	resultInt = EventDefine.E_DOEXCUTE_INIT;
	
	try {
		con = JDBCConnectionPool.getConnection();
		
		JSONObject jArray = new JSONObject();
		jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
		System.out.println("JSONObject jArray rcvData="+ jArray.toString());
		
		// 클라이언트로 부터 받은 파라미터를 옮겨 담는다.
//		String rcvData = (String)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
		// 클라이언트로 부터 받은 파라미터를 쪼개어서 배열에 담는다.
		// rcvData = [위경도]
//		String[][] c_paramArray = CommonFunction.getConvString2DoubleArray(rcvData);
		String sql = new StringBuilder()
				.append("SELECT\n")
				.append("	A.as_request_no,\n")
				.append("	A.revision_no,\n")
				.append("	A.order_no,\n")
				.append("	A.lotno,\n")
				.append("	A.reg_date,\n")
				.append("	A.reg_user_id,\n")
				.append("	A.req_channel,\n")
				.append("	A.req_man_name,\n")
				.append("	A.work_hope_date,\n")
				.append("	A.as_status_cd,\n")
				.append("	A.as_count,\n")
				.append("	A.recept_date,\n")
				.append("	A.req_contents,\n")
				.append("	A.product_cd,\n")
				.append("	A.product_nm,\n")
				.append("	A.cust_cd,\n")
				.append("	B.repare_date,\n")
				.append("	B.chulgo_date,\n")
				.append("	B.req_review_note,\n")
				.append("	B.repare_note,\n")
				.append("	B.repare_inspect,\n")
				.append("	B.as_result_no,\n")
				.append("	B.jemok\n")
				.append("FROM\n")
				.append("	tbi_as_request A\n")
				.append("INNER JOIN tbi_as_result B\n")
				.append("ON A.as_request_no = B.as_request_no\n")
				.append("	AND A.member_key = B.member_key\n")
				.append("WHERE \n")
				.append("as_result_no = '" +  jArray.get("GV_ASNOS") + "'\n")
				.append(" 	AND A.member_key = '" + jArray.get("member_key") + "' \n") //member_key_select, update, delete
				.toString();

		String ActionCommand = ioParam.getActionCommand();
		if(ActionCommand.startsWith("doQueryTableFieldName")) {
			resultString = super.excuteQueryStringTableFieldName(con, sql.toString());
		}
		else {;
			resultString = super.excuteQueryString(con, sql.toString());
		}
	} catch(Exception e) {
		e.printStackTrace();
		LoggingWriter.setLogError("M808S010300E134()","==== SQL ERROR ===="+ e.getMessage());
		return EventDefine.E_DOEXCUTE_ERROR ;
    } finally {
    	if (Config.useDataSource) {
			try {
				if (con != null) con.close();
			} catch (Exception e) {
				LoggingWriter.setLogError("M808S010300E134()","==== finally ===="+ e.getMessage());
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

public int E144(InoutParameter ioParam){
	resultInt = EventDefine.E_DOEXCUTE_INIT;
	
	try {
		con = JDBCConnectionPool.getConnection();
		
		JSONObject jArray = new JSONObject();
		jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
		System.out.println("JSONObject jArray rcvData="+ jArray.toString());
		
		// 클라이언트로 부터 받은 파라미터를 옮겨 담는다.
//		String rcvData = (String)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
		// 클라이언트로 부터 받은 파라미터를 쪼개어서 배열에 담는다.
		// rcvData = [위경도]
//		String[][] c_paramArray = CommonFunction.getConvString2DoubleArray(rcvData);
		String sql = new StringBuilder()
				.append("SELECT\n")
				.append("	A.as_request_no,\n")
				.append("	A.revision_no,\n")
				.append("	A.order_no,\n")
				.append("	A.lotno,\n")
				.append("	A.reg_date,\n")
				.append("	A.reg_user_id,\n")
				.append("	A.req_channel,\n")
				.append("	A.req_man_name,\n")
				.append("	A.work_hope_date,\n")
				.append("	A.as_status_cd,\n")
				.append("	A.as_count,\n")
				.append("	A.recept_date,\n")
				.append("	A.req_contents,\n")
				.append("	A.product_cd,\n")
				.append("	A.product_nm,\n")
				.append("	A.cust_cd,\n")
				.append("	B.repare_date,\n")
				.append("	B.chulgo_date,\n")
				.append("	B.req_review_note,\n")
				.append("	B.repare_note,\n")
				.append("	B.repare_inspect,\n")
				.append("	B.as_result_no,\n")
				.append("	B.jemok\n")
				.append("FROM\n")
				.append("	tbi_as_request A\n")
				.append("INNER JOIN tbi_as_result B\n")
				.append("ON A.as_request_no = B.as_request_no\n")
				.append("	AND A.member_key = B.member_key\n")
				.append("WHERE \n")
				.append("as_result_no = '" +  jArray.get("GV_ASNOS") + "'\n")
				.append(" 	AND A.member_key = '" + jArray.get("member_key") + "' \n") //member_key_select, update, delete
				.toString();



		String ActionCommand = ioParam.getActionCommand();
		if(ActionCommand.startsWith("doQueryTableFieldName")) {
			resultString = super.excuteQueryStringTableFieldName(con, sql.toString());
		}
		else {;
			resultString = super.excuteQueryString(con, sql.toString());
		}
	} catch(Exception e) {
		e.printStackTrace();
		LoggingWriter.setLogError("M808S010300E144()","==== SQL ERROR ===="+ e.getMessage());
		return EventDefine.E_DOEXCUTE_ERROR ;
    } finally {
    	if (Config.useDataSource) {
			try {
				if (con != null) con.close();
			} catch (Exception e) {
				LoggingWriter.setLogError("M808S010300E144()","==== finally ===="+ e.getMessage());
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

//수리보고서 조회쿼리
public int E154(InoutParameter ioParam){
	resultInt = EventDefine.E_DOEXCUTE_INIT;
	
	try {
		con = JDBCConnectionPool.getConnection();
		
		JSONObject jArray = new JSONObject();
		jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
		System.out.println("JSONObject jArray rcvData="+ jArray.toString());
		
		// 클라이언트로 부터 받은 파라미터를 옮겨 담는다.
//		String rcvData = (String)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
		// 클라이언트로 부터 받은 파라미터를 쪼개어서 배열에 담는다.
		// rcvData = [위경도]
//		String[][] c_paramArray = CommonFunction.getConvString2DoubleArray(rcvData);
		String sql = new StringBuilder()
				.append("SELECT\n")
				.append("	A.as_request_no,\n")
				.append("	A.revision_no,\n")
				.append("	A.order_no,\n")
				.append("	A.order_detail_seq,\n")
				.append("	A.reg_date,\n")
				.append("	A.reg_user_id,\n")
				.append("	A.req_channel,\n")
				.append("	A.req_man_name,\n")
				.append("	A.work_hope_date,\n")
				.append("	A.as_status_cd,\n")
				.append("	A.as_count,\n")
				.append("	A.recept_date,\n")
				.append("	A.req_contents,\n")
				.append("	A.product_cd,\n")
				.append("	A.product_nm,\n")
				.append("	A.cust_cd,\n")
				.append("	B.repare_date,\n")
				.append("	B.chulgo_date,\n")
				.append("	B.result_bigo,\n")
				.append("	B.repare_note,\n")
				.append("	B.repare_inspect,\n")
				.append("	B.as_result_no,\n")
				.append("	B.req_review_note,\n")
				.append("	B.jemok\n")
				.append("FROM\n")
				.append("	tbi_as_request A\n")
				.append("INNER JOIN tbi_as_result B\n")
				.append("ON A.as_request_no = B.as_request_no\n")
				.append("	AND A.member_key = B.member_key\n")
				.append("WHERE \n")
				.append("as_result_no = '" +  jArray.get("GV_ASNOS") + "'\n")
				.append(" 	AND A.member_key = '" + jArray.get("member_key") + "' \n") //member_key_select, update, delete
				.toString();

		String ActionCommand = ioParam.getActionCommand();
		if(ActionCommand.startsWith("doQueryTableFieldName")) {
			resultString = super.excuteQueryStringTableFieldName(con, sql.toString());
		}
		else {;
			resultString = super.excuteQueryString(con, sql.toString());
		}
	} catch(Exception e) {
		e.printStackTrace();
		LoggingWriter.setLogError("M101S030100E154()","==== SQL ERROR ===="+ e.getMessage());
		return EventDefine.E_DOEXCUTE_ERROR ;
    } finally {
    	if (Config.useDataSource) {
			try {
				if (con != null) con.close();
			} catch (Exception e) {
				LoggingWriter.setLogError("M101S030100E154()","==== finally ===="+ e.getMessage());
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