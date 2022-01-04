package mes.frame.business.M858;

import java.lang.reflect.Method;
import java.sql.Connection;
import java.sql.PreparedStatement;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;

import mes.client.conf.Config;
import mes.frame.common.ApprovalActionNo;
import mes.frame.common.EventDefine;
import mes.frame.common.HashObject;
import mes.frame.common.MessageDefine;
import mes.frame.database.JDBCConnectionPool;
import mes.frame.database.SqlAdapter;
import mes.frame.serviceinterface.InoutParameter;
import mes.frame.serviceinterface.LoggingWriter;
import mes.frame.util.CommonFunction;


public class M858S020100 extends SqlAdapter{
	Connection con = null;
	PreparedStatement pstmt = null;
	String resultString = "";
	int resultInt = -1;
	StringBuffer sql = new StringBuffer();
	
	String[][] v_paramArray = new String[0][0]; 
	Class[] optClass = null;
	Object[] optObj = null;
	Object obj = null;
	
	public M858S020100(){
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
			
			Method method = M858S020100.class.getMethod(event,optClass);
			LoggingWriter.setLogDebug(M858S020100.class.getName(),"==== " + event + " EventMethod Create Success ====");

			obj = method.invoke(M858S020100.class.newInstance(),optObj);
			doExcute_result = CommonFunction.getInt(obj.toString());
			
	    } catch (Exception ex) {
	    	doExcute_result = EventDefine.E_DOEXCUTE_INIT;
			ioParam.setMessage(MessageDefine.M_NO_EVENTID);
			LoggingWriter.setLogError(M858S020100.class.getName(),"==== EventID Not define : EVENT ID [ " + ioParam.getEventID() + "]");
	    } finally {
	    	obj = null;
			optClass = null;
			optObj = null;
	    }
	    long endTime = System.currentTimeMillis();
		long runningTime = endTime - startTime;
		LoggingWriter.setLogAll(M858S020100.class.getName(),"==== Query [수행시간  : " + runningTime + " ms]");
		
		return doExcute_result;
	}
	
	// 배차등록
	public int E101(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject(); // JSONObject 선언
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			JSONArray jjArray = (JSONArray) jArray.get("param");
			JSONObject jArrayHead = (JSONObject) jArray.get("paramHead");
			
			
			con.setAutoCommit(false);
			
			ApprovalActionNo ActionNo = new ApprovalActionNo();
			String Baecha_No="";
			
    		if(jArrayHead.get("baecha_no").equals("")) {
	    		String jspPage = (String)jArrayHead.get("jsp_page");
	    		String user_id = (String)jArrayHead.get("login_id");
	    		String prefix = (String)jArrayHead.get("num_gubun");
	    		String actionGubun = "Regist";
	    		String detail_seq 	= (String)jArrayHead.get("detail_seq");
	    		String member_key 	= (String)jArrayHead.get("member_key");
				ActionNo = new ApprovalActionNo();
				Baecha_No = ActionNo.getActionNo(con,jspPage,user_id,prefix,actionGubun,detail_seq,member_key);//GV_JSPPAGE(action Page), User ID, prefix
    		} else {
    			Baecha_No = (String)jArrayHead.get("baecha_no");
    		}
    		
    		String sql = new StringBuilder()
					.append("MERGE INTO tbi_vehicle_baecha mm\n")
					.append("USING (\n")
					.append("	SELECT \n")
					.append("		'" 	+ Baecha_No 						+ "' AS baecha_no\n")
					.append("		,'" + jArrayHead.get("baecha_seq") 		+ "' AS baecha_seq\n")
					.append("		,'" + jArrayHead.get("baecha_start_dt") 	+ "' AS baecha_start_dt\n")
					.append("		,'" + jArrayHead.get("baecha_end_dt") 	+ "' AS baecha_end_dt\n")
					.append("		,'" + jArrayHead.get("vehicle_cd") 		+ "' AS vehicle_cd\n")
					.append("		,'" + jArrayHead.get("vehicle_cd_rev") 	+ "' AS vehicle_cd_rev\n")
					.append("		,'" + jArrayHead.get("vehicle_nm") 	+ "' AS vehicle_nm\n")
					.append("		,'" + jArrayHead.get("driver") 			+ "' AS driver\n")
					.append("		,'" + jArrayHead.get("bigo") 				+ "' AS bigo\n")
					.append("		,'" + jArrayHead.get("member_key") 		+ "' AS member_key\n")
					.append("	FROM db_root ) mQ\n")
					.append("ON ( \n")
					.append("	mm.baecha_no=mQ.baecha_no\n")
					.append("	AND mm.baecha_seq=mQ.baecha_seq\n")
					.append("	AND mm.member_key=mQ.member_key\n")
					.append(")\n")
					.append("WHEN MATCHED THEN\n")
					.append("	UPDATE SET \n")
					.append("		mm.baecha_no=mQ.baecha_no,\n")
					.append("		mm.baecha_seq=mQ.baecha_seq,\n")
					.append("		mm.baecha_start_dt=mQ.baecha_start_dt,\n")
					.append("		mm.baecha_end_dt=mQ.baecha_end_dt,\n")
					.append("		mm.vehicle_cd=mQ.vehicle_cd,\n")
					.append("		mm.vehicle_cd_rev=mQ.vehicle_cd_rev,\n")
					.append("		mm.vehicle_nm=mQ.vehicle_nm,\n")
					.append("		mm.driver=mQ.driver,\n")
					.append("		mm.bigo=mQ.bigo,\n")
					.append("		mm.member_key=mQ.member_key\n")
					.append("WHEN NOT MATCHED THEN\n")
					.append("	INSERT (\n")
					.append("		mm.baecha_no,\n")
					.append("		mm.baecha_seq,\n")
					.append("		mm.baecha_start_dt,\n")
					.append("		mm.baecha_end_dt,\n")
					.append("		mm.vehicle_cd,\n")
					.append("		mm.vehicle_cd_rev,\n")
					.append("		mm.vehicle_nm,\n")
					.append("		mm.driver,\n")
					.append("		mm.bigo,\n")
					.append("		mm.member_key\n")
					.append("	) VALUES (\n")
					.append("		mQ.baecha_no,\n")
					.append("		mQ.baecha_seq,\n")
					.append("		mQ.baecha_start_dt,\n")
					.append("		mQ.baecha_end_dt,\n")
					.append("		mQ.vehicle_cd,\n")
					.append("		mQ.vehicle_cd_rev,\n")
					.append("		mQ.vehicle_nm,\n")
					.append("		mQ.driver,\n")
					.append("		mQ.bigo,\n")
					.append("		mQ.member_key\n")
					.append("	)\n")
					.toString();

			resultInt = super.excuteUpdate(con, sql.toString());
    		if (resultInt < 0) {  //
				ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
				con.rollback();
				return EventDefine.E_DOEXCUTE_ERROR ;
			}

    		for(int i=0; i<jjArray.size(); i++) {   
    			JSONObject jjjArray = (JSONObject)jjArray.get(i);
    			
    			sql = new StringBuilder()
						.append("MERGE INTO tbi_vehicle_baecha_order mm\n")
						.append("USING (\n")
						.append("	SELECT \n")
						.append("		'" 	+ Baecha_No 						+ "' AS baecha_no\n")
						.append("		,'" + jjjArray.get("baecha_seq") 		+ "' AS baecha_seq\n")
						.append("		,'" + jjjArray.get("vehicle_cd") 		+ "' AS vehicle_cd\n")
						.append("		,'" + jjjArray.get("vehicle_cd_rev") 	+ "' AS vehicle_cd_rev\n")
						.append("		,'" + jjjArray.get("order_no") 			+ "' AS order_no\n")
						.append("		,'" + jjjArray.get("lotno") 			+ "' AS lotno\n")
						.append("		,'" + jjjArray.get("order_detail_seq") 	+ "' AS order_detail_seq\n")
						.append("		,'" + jjjArray.get("chulha_no") 		+ "' AS chulha_no\n")
						.append("		,'" + jjjArray.get("chulha_seq") 		+ "' AS chulha_seq\n")
						.append("		,'" + jjjArray.get("member_key") 		+ "' AS member_key\n")
						.append("	FROM db_root ) mQ\n")
						.append("ON ( \n")
						.append("	mm.baecha_no=mQ.baecha_no\n")
						.append("	AND mm.baecha_seq=mQ.baecha_seq\n")
						.append("	AND mm.order_no=mQ.order_no\n")
						.append("	AND mm.order_detail_seq=mQ.order_detail_seq\n")
						.append("	AND mm.chulha_no=mQ.chulha_no\n")
						.append("	AND mm.chulha_seq=mQ.chulha_seq\n")
						.append("	AND mm.member_key=mQ.member_key\n")
						.append(")\n")
						.append("WHEN MATCHED THEN\n")
						.append("	UPDATE SET \n")
						.append("		mm.baecha_no=mQ.baecha_no,\n")
						.append("		mm.baecha_seq=mQ.baecha_seq,\n")
						.append("		mm.vehicle_cd=mQ.vehicle_cd,\n")
						.append("		mm.vehicle_cd_rev=mQ.vehicle_cd_rev,\n")
						.append("		mm.order_no=mQ.order_no,\n")
						.append("		mm.lotno=mQ.lotno,\n")
						.append("		mm.order_detail_seq=mQ.order_detail_seq,\n")
						.append("		mm.chulha_no=mQ.chulha_no,\n")
						.append("		mm.chulha_seq=mQ.chulha_seq,\n")
						.append("		mm.member_key=mQ.member_key\n")
						.append("WHEN NOT MATCHED THEN\n")
						.append("	INSERT (\n")
						.append("		mm.baecha_no,\n")
						.append("		mm.baecha_seq,\n")
						.append("		mm.vehicle_cd,\n")
						.append("		mm.vehicle_cd_rev,\n")
						.append("		mm.order_no,\n")
						.append("		mm.lotno,\n")
						.append("		mm.order_detail_seq,\n")
						.append("		mm.chulha_no,\n")
						.append("		mm.chulha_seq,\n")
						.append("		mm.member_key\n")
						.append("	) VALUES (\n")
						.append("		mQ.baecha_no,\n")
						.append("		mQ.baecha_seq,\n")
						.append("		mQ.vehicle_cd,\n")
						.append("		mQ.vehicle_cd_rev,\n")
						.append("		mQ.order_no,\n")
						.append("		mQ.lotno,\n")
						.append("		mQ.order_detail_seq,\n")
						.append("		mQ.chulha_no,\n")
						.append("		mQ.chulha_seq,\n")
						.append("		mQ.member_key\n")
						.append("	)\n")
						.toString();

				resultInt = super.excuteUpdate(con, sql.toString());
	    		if (resultInt < 0) {  //
					ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
					con.rollback();
					return EventDefine.E_DOEXCUTE_ERROR ;
				}
			}
    		con.commit();
		} catch(Exception e) {
			LoggingWriter.setLogError("M858S020100E101()","==== SQL ERROR ===="+ e.getMessage() + "\n" + sql.toString());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M858S020100E101()","==== finally ===="+ e.getMessage());
				}
	    	} else {
	    	}
	    }
	    // 결과 전문 구성을 위한 파라미터들을 아이오 파라미터에 저장한다.
		ioParam.setResultString(resultString);
		// 수퍼에서 처리된 칼럼의 갯수를 클라이언트에게 보내기 위해 가져온다.
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
		// 잘 처리되었다는 메시지를 클라이언트에게 보내기 위해 I/O파라미터에 저장한다.
		// 위에서 저장된 넘을 보존하기 위해서 막는다.
    	// ioParam.setMessage(MessageDefine.M_QUERY_OK);
	    return EventDefine.E_QUERY_RESULT;
	}

	// 배차수정 -> 등록과 동일
	public int E102(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject(); // JSONObject 선언
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			JSONArray jjArray = (JSONArray) jArray.get("param");
			JSONObject jArrayHead = (JSONObject) jArray.get("paramHead");
			
			
			con.setAutoCommit(false);
			
			ApprovalActionNo ActionNo = new ApprovalActionNo();
			String Baecha_No="";
			
    		if(jArrayHead.get("baecha_no").equals("")) {
	    		String jspPage = (String)jArrayHead.get("jsp_page");
	    		String user_id = (String)jArrayHead.get("login_id");
	    		String prefix = (String)jArrayHead.get("num_gubun");
	    		String actionGubun = "Regist";
	    		String detail_seq 	= (String)jArrayHead.get("detail_seq");
	    		String member_key 	= (String)jArrayHead.get("member_key");
				ActionNo = new ApprovalActionNo();
				Baecha_No = ActionNo.getActionNo(con,jspPage,user_id,prefix,actionGubun,detail_seq,member_key);//GV_JSPPAGE(action Page), User ID, prefix
    		} else {
    			Baecha_No = (String)jArrayHead.get("baecha_no");
    		}
    		
    		String sql = new StringBuilder()
					.append("MERGE INTO tbi_vehicle_baecha mm\n")
					.append("USING (\n")
					.append("	SELECT \n")
					.append("		'" 	+ Baecha_No 						+ "' AS baecha_no\n")
					.append("		,'" + jArrayHead.get("baecha_seq") 		+ "' AS baecha_seq\n")
					.append("		,'" + jArrayHead.get("baecha_start_dt") 	+ "' AS baecha_start_dt\n")
					.append("		,'" + jArrayHead.get("baecha_end_dt") 	+ "' AS baecha_end_dt\n")
					.append("		,'" + jArrayHead.get("vehicle_cd") 		+ "' AS vehicle_cd\n")
					.append("		,'" + jArrayHead.get("vehicle_cd_rev") 	+ "' AS vehicle_cd_rev\n")
					.append("		,'" + jArrayHead.get("vehicle_nm") 	+ "' AS vehicle_nm\n")
					.append("		,'" + jArrayHead.get("driver") 			+ "' AS driver\n")
					.append("		,'" + jArrayHead.get("bigo") 				+ "' AS bigo\n")
					.append("		,'" + jArrayHead.get("member_key") 		+ "' AS member_key\n")
					.append("	FROM db_root ) mQ\n")
					.append("ON ( \n")
					.append("	mm.baecha_no=mQ.baecha_no\n")
					.append("	AND mm.baecha_seq=mQ.baecha_seq\n")
					.append("	AND mm.member_key=mQ.member_key\n")
					.append(")\n")
					.append("WHEN MATCHED THEN\n")
					.append("	UPDATE SET \n")
					.append("		mm.baecha_no=mQ.baecha_no,\n")
					.append("		mm.baecha_seq=mQ.baecha_seq,\n")
					.append("		mm.baecha_start_dt=mQ.baecha_start_dt,\n")
					.append("		mm.baecha_end_dt=mQ.baecha_end_dt,\n")
					.append("		mm.vehicle_cd=mQ.vehicle_cd,\n")
					.append("		mm.vehicle_cd_rev=mQ.vehicle_cd_rev,\n")
					.append("		mm.vehicle_nm=mQ.vehicle_nm,\n")
					.append("		mm.driver=mQ.driver,\n")
					.append("		mm.bigo=mQ.bigo,\n")
					.append("		mm.member_key=mQ.member_key\n")
					.append("WHEN NOT MATCHED THEN\n")
					.append("	INSERT (\n")
					.append("		mm.baecha_no,\n")
					.append("		mm.baecha_seq,\n")
					.append("		mm.baecha_start_dt,\n")
					.append("		mm.baecha_end_dt,\n")
					.append("		mm.vehicle_cd,\n")
					.append("		mm.vehicle_cd_rev,\n")
					.append("		mm.vehicle_nm,\n")
					.append("		mm.driver,\n")
					.append("		mm.bigo,\n")
					.append("		mm.member_key\n")
					.append("	) VALUES (\n")
					.append("		mQ.baecha_no,\n")
					.append("		mQ.baecha_seq,\n")
					.append("		mQ.baecha_start_dt,\n")
					.append("		mQ.baecha_end_dt,\n")
					.append("		mQ.vehicle_cd,\n")
					.append("		mQ.vehicle_cd_rev,\n")
					.append("		mQ.vehicle_nm,\n")
					.append("		mQ.driver,\n")
					.append("		mQ.bigo,\n")
					.append("		mQ.member_key\n")
					.append("	)\n")
					.toString();

			resultInt = super.excuteUpdate(con, sql.toString());
    		if (resultInt < 0) {  //
				ioParam.setMessage(MessageDefine.M_UPDATE_FAILED);
				con.rollback();
				return EventDefine.E_DOEXCUTE_ERROR ;
			}

    		for(int i=0; i<jjArray.size(); i++) {   
    			JSONObject jjjArray = (JSONObject)jjArray.get(i);
    			
    			sql = new StringBuilder()
						.append("MERGE INTO tbi_vehicle_baecha_order mm\n")
						.append("USING (\n")
						.append("	SELECT \n")
						.append("		'" 	+ Baecha_No 						+ "' AS baecha_no\n")
						.append("		,'" + jjjArray.get("baecha_seq") 		+ "' AS baecha_seq\n")
						.append("		,'" + jjjArray.get("vehicle_cd") 		+ "' AS vehicle_cd\n")
						.append("		,'" + jjjArray.get("vehicle_cd_rev") 	+ "' AS vehicle_cd_rev\n")
						.append("		,'" + jjjArray.get("order_no") 			+ "' AS order_no\n")
						.append("		,'" + jjjArray.get("lotno") 			+ "' AS lotno\n")
						.append("		,'" + jjjArray.get("order_detail_seq") 	+ "' AS order_detail_seq\n")
						.append("		,'" + jjjArray.get("chulha_no") 		+ "' AS chulha_no\n")
						.append("		,'" + jjjArray.get("chulha_seq") 		+ "' AS chulha_seq\n")
						.append("		,'" + jjjArray.get("member_key") 		+ "' AS member_key\n")
						.append("	FROM db_root ) mQ\n")
						.append("ON ( \n")
						.append("	mm.baecha_no=mQ.baecha_no\n")
						.append("	AND mm.baecha_seq=mQ.baecha_seq\n")
						.append("	AND mm.order_no=mQ.order_no\n")
						.append("	AND mm.order_detail_seq=mQ.order_detail_seq\n")
						.append("	AND mm.chulha_no=mQ.chulha_no\n")
						.append("	AND mm.chulha_seq=mQ.chulha_seq\n")
						.append("	AND mm.member_key=mQ.member_key\n")
						.append(")\n")
						.append("WHEN MATCHED THEN\n")
						.append("	UPDATE SET \n")
						.append("		mm.baecha_no=mQ.baecha_no,\n")
						.append("		mm.baecha_seq=mQ.baecha_seq,\n")
						.append("		mm.vehicle_cd=mQ.vehicle_cd,\n")
						.append("		mm.vehicle_cd_rev=mQ.vehicle_cd_rev,\n")
						.append("		mm.order_no=mQ.order_no,\n")
						.append("		mm.lotno=mQ.lotno,\n")
						.append("		mm.order_detail_seq=mQ.order_detail_seq,\n")
						.append("		mm.chulha_no=mQ.chulha_no,\n")
						.append("		mm.chulha_seq=mQ.chulha_seq,\n")
						.append("		mm.member_key=mQ.member_key\n")
						.append("WHEN NOT MATCHED THEN\n")
						.append("	INSERT (\n")
						.append("		mm.baecha_no,\n")
						.append("		mm.baecha_seq,\n")
						.append("		mm.vehicle_cd,\n")
						.append("		mm.vehicle_cd_rev,\n")
						.append("		mm.order_no,\n")
						.append("		mm.lotno,\n")
						.append("		mm.order_detail_seq,\n")
						.append("		mm.chulha_no,\n")
						.append("		mm.chulha_seq,\n")
						.append("		mm.member_key\n")
						.append("	) VALUES (\n")
						.append("		mQ.baecha_no,\n")
						.append("		mQ.baecha_seq,\n")
						.append("		mQ.vehicle_cd,\n")
						.append("		mQ.vehicle_cd_rev,\n")
						.append("		mQ.order_no,\n")
						.append("		mQ.lotno,\n")
						.append("		mQ.order_detail_seq,\n")
						.append("		mQ.chulha_no,\n")
						.append("		mQ.chulha_seq,\n")
						.append("		mQ.member_key\n")
						.append("	)\n")
						.toString();

				resultInt = super.excuteUpdate(con, sql.toString());
	    		if (resultInt < 0) {  //
					ioParam.setMessage(MessageDefine.M_UPDATE_FAILED);
					con.rollback();
					return EventDefine.E_DOEXCUTE_ERROR ;
				}
			}
    		con.commit();
		} catch(Exception e) {
			LoggingWriter.setLogError("M858S020100E102()","==== SQL ERROR ===="+ e.getMessage() + "\n" + sql.toString());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M858S020100E102()","==== finally ===="+ e.getMessage());
				}
	    	} else {
	    	}
	    }
	    // 결과 전문 구성을 위한 파라미터들을 아이오 파라미터에 저장한다.
		ioParam.setResultString(resultString);
		// 수퍼에서 처리된 칼럼의 갯수를 클라이언트에게 보내기 위해 가져온다.
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
		// 잘 처리되었다는 메시지를 클라이언트에게 보내기 위해 I/O파라미터에 저장한다.
		// 위에서 저장된 넘을 보존하기 위해서 막는다.
    	// ioParam.setMessage(MessageDefine.M_QUERY_OK);
	    return EventDefine.E_QUERY_RESULT;
	}

	// 배차삭제
	public int E103(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		String sql = "";
		try {
			con = JDBCConnectionPool.getConnection();
			JSONObject jArray = new JSONObject(); // JSONObject 선언
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			JSONObject jArrayHead = (JSONObject) jArray.get("paramHead");
			JSONArray jjArray = (JSONArray) jArray.get("param");
			
			con.setAutoCommit(false);

			sql = new StringBuilder()
				.append("DELETE FROM tbi_vehicle_baecha\n")
				.append("WHERE baecha_no='" 	+ jArrayHead.get("baecha_no") + "'\n")
				.append("	AND member_key='" 	+ jArrayHead.get("member_key") + "'\n")	
				.toString();    
			resultInt = super.excuteUpdate(con, sql.toString());
			if (resultInt < 0) {  //
				ioParam.setMessage(MessageDefine.M_DELETE_FAILED);
				con.rollback();
				return EventDefine.E_DOEXCUTE_ERROR ;
			} else {
				if(jjArray.size()>0) {
					JSONObject jjjArray0 = (JSONObject)jjArray.get(0);
			    	sql = new StringBuilder()
			    			.append("DELETE FROM tbi_vehicle_baecha_order\n")
			    			.append("WHERE baecha_no='" 	+ jjjArray0.get("baecha_no") + "'\n")
							.append("	AND member_key='" 	+ jjjArray0.get("member_key") + "'\n")
							.toString();

					resultInt = super.excuteUpdate(con, sql.toString());
			    	if (resultInt < 0) {  //
						ioParam.setMessage(MessageDefine.M_DELETE_FAILED);
						con.rollback();
						return EventDefine.E_DOEXCUTE_ERROR ;
					}
				}
			}
    		
			con.commit();
		} catch(Exception e) {
			LoggingWriter.setLogError("M303S020100E103()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M303S020100E103()","==== finally ===="+ e.getMessage());
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

	// 배차목록(하단탭)
	public int E114(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			// 클라이언트로 부터 받은 파라미터를 옮겨 담는다.
			//String rcvData = (String)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			// 클라이언트로 부터 받은 파라미터를 쪼개어서 배열에 담는다.
			//{ "설비코드", "업무구분", "기관명", "수리내용", "반출일", "완료일", "담당자", "비용", "비고", "SEQ_NO"};
			
			//String[][] c_paramArray = CommonFunction.getConvString2DoubleArray(rcvData);
			
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			
			String sql = new StringBuilder()
					.append("SELECT\n")
					.append("	baecha_no,\n")
					.append("	baecha_seq,\n")
					.append("	baecha_start_dt,\n")
					.append("	baecha_end_dt,\n")
					.append("	A.vehicle_cd,\n")
					.append("	A.vehicle_cd_rev,\n")
					.append("	V.vehicle_nm,\n")
					.append("	order_no,\n")
					.append("	lotno,\n")
					.append("	driver,\n")
					.append("	A.bigo\n")
					.append("FROM tbi_vehicle_baecha A\n")
					.append("INNER JOIN tbm_vehicle V\n")
					.append("	ON A.vehicle_cd=V.vehicle_cd\n")
					.append("	AND A.vehicle_cd_rev=V.vehicle_rev_no\n")
					.append("WHERE order_no	='" + jArray.get("order_no") + "'\n")
					.append("	AND lotno	='" + jArray.get("lotno") + "'\n")
					.append("	AND A.member_key='" + jArray.get("member_key") + "'\n")
					.toString();

			resultString = super.excuteQueryString(con, sql.toString());
			
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M858S020100E114()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M858S020100E114()","==== finally ===="+ e.getMessage());
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
	
	// 배차목록(등록,수정,삭제에서 사용)
	public int E134(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			System.out.println("JSONObject jArray rcvData="+ jArray.toString());
			
			String sql = new StringBuilder() //E114와 같음 - 수정 필요하면 수정
					.append("SELECT\n")
					.append("	A.baecha_no, -- 0. (숨김)\n")
					.append("	A.order_no, 	-- 1. (숨김)\n")
					.append("	A.lotno, 		-- 2. (숨김)\n")
					.append("	C.cust_nm, 		-- 3. 주문업체\n")
					.append("	B.prod_cd, 		-- 4. (숨김)\n")
					.append("	B.prod_rev, 	-- 5. (숨김)\n")
					.append("	P.product_nm, 	-- 6. 제품명\n")
					.append("	B.lot_count, 	-- 7. 주문개수\n")
					.append("	B.order_date, 	-- 8. 주문일\n")
					.append("	B.delivery_date, -- 9. 납기일\n")
					.append("	D.chulha_cnt, 	--출하갯수\n")
					.append("	A.order_detail_seq,	--(숨김)\n")
					.append("	D.chulha_no, 	--(숨김)\n")
					.append("	D.chulha_seq 	--(숨김)\n")
					.append("FROM tbi_vehicle_baecha_order A\n")
					.append("INNER JOIN tbi_order B\n")
					.append("	ON A.order_no = B.order_no\n")
					.append("	AND A.order_detail_seq = B.order_detail_seq\n")
					.append("	AND A.member_key = B.member_key\n")
					.append("INNER JOIN tbm_customer C\n")
					.append("	ON B.cust_cd = C.cust_cd\n")
					.append("	AND B.cust_rev = C.revision_no\n")
					.append("	AND B.member_key = C.member_key\n")
					.append("INNER JOIN tbm_product P\n")
					.append("	ON B.prod_cd = P.prod_cd\n")
					.append("	AND B.prod_rev = P.revision_no\n")
					.append("	AND B.member_key = P.member_key\n")
					.append("INNER JOIN tbi_chulha_info D\n")
					.append("	ON A.order_no = D.order_no\n")
					.append("	AND A.order_detail_seq = D.order_detail_seq\n")
					.append("	AND A.lotno = D.lotno\n")
					.append("	AND A.chulha_no = D.chulha_no\n")
					.append("	AND A.chulha_seq = D.chulha_seq\n")
					.append("	AND A.member_key = D.member_key\n")
					.append("WHERE baecha_no='" + jArray.get("baecha_no") + "'\n")
					.append("	AND A.member_key='" + jArray.get("member_key") + "'\n")
					.toString();
			
			
			resultString = super.excuteQueryString(con, sql.toString());
			
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M858S020100E134()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M858S020100E134()","==== finally ===="+ e.getMessage());
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
			
			String sql = new StringBuilder()
//					.append("WITH chulha_info AS (\n")
//					.append("	SELECT\n")
//					.append("		order_no,\n")
//					.append("		order_detail_seq,\n")
//					.append("		lotno,\n")
//					.append("		prod_cd,\n")
//					.append("		prod_rev,\n")
//					.append("		SUM(chulha_cnt) AS chulha_cnt_total,\n")
//					.append("		chulha_no,\n")
//					.append("		chulha_seq,\n")
//					.append("		member_key\n")
//					.append("	FROM tbi_chulha_info\n")
//					.append("	GROUP BY order_no,lotno,order_detail_seq,prod_cd,prod_rev,chulha_no,chulha_seq\n")
//					.append(")\n")
					.append("SELECT\n")
					.append("	A.order_no, --(숨김)\n")
					.append("	A.lotno, --(숨김)\n")
					.append("	A.cust_cd, --(숨김)\n")
					.append("	A.cust_rev, --(숨김)\n")
					.append("	B.cust_nm, --주문업체\n")
					.append("	A.prod_cd, --(숨김)\n")
					.append("	A.prod_rev, --(숨김)\n")
					.append("	C.product_nm,	 --주문제품\n")
					.append("	A.lot_count, --주문제품개수\n")
					.append("	A.order_date, --주문일\n")
					.append("	A.delivery_date, --납기일\n")
//					.append("	NVL(D.chulha_cnt_total,0), --출하량\n")
					.append("	NVL(D.chulha_cnt,0), --출하량\n")
					.append("	A.order_detail_seq, --(숨김)\n")
					.append("	D.chulha_no, --(숨김)\n")
					.append("	D.chulha_seq --(숨김)\n")
					.append("FROM tbi_order A\n")
					.append("INNER JOIN tbm_customer B\n")
					.append("	ON A.cust_cd = B.cust_cd\n")
					.append("	AND A.cust_rev = B.revision_no\n")
					.append("	AND A.member_key = B.member_key\n")
					.append("INNER JOIN tbm_product C\n")
					.append("	ON A.prod_cd = C.prod_cd\n")
					.append("	AND A.prod_rev = C.revision_no\n")
					.append("	AND A.member_key = C.member_key\n")
					.append("LEFT OUTER JOIN tbi_chulha_info D\n")
					.append("	ON A.order_no = D.order_no\n")
					.append("	AND A.order_detail_seq = D.order_detail_seq\n")
					.append("	AND A.lotno = D.lotno\n")
					.append("	AND A.member_key = D.member_key\n")
					.append("LEFT OUTER JOIN tbi_vehicle_baecha_order E\n")
					.append("	ON A.order_no = E.order_no\n")
					.append("	AND A.order_detail_seq = E.order_detail_seq\n")
					.append("	AND D.chulha_no = E.chulha_no\n")
					.append("	AND D.chulha_seq = E.chulha_seq\n")
					.append("	AND A.member_key = E.member_key\n")
					.append("WHERE 1=1\n")
//					.append("	AND NVL(D.chulha_cnt_total,0) = A.lot_count \n")
					.append("	AND D.chulha_no IS NOT NULL \n")
					.append("	AND E.baecha_no IS NULL \n")
//					.append("	AND A.prod_cd = '" + jArray.get("prod_cd") + rod_cd,A.prod_r"'\n")
//					.append("	AND A.prod_rev = '" + jArray.get("prod_cd_rev") + "'\n")
					.append("	AND A.member_key = '" + jArray.get("member_key") + "'\n")
					.append("GROUP BY A.order_no,A.order_detail_seq,A.lotno,D.chulha_no,D.chulha_seq\n")
					.append("ORDER BY A.delivery_date ASC, A.order_date ASC\n")
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
			LoggingWriter.setLogError("M303S020100E124()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M303S020100E124()","==== finally ===="+ e.getMessage());
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
	
	//배차별 주문 행 삭제
	public int E113(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		try {
			con = JDBCConnectionPool.getConnection();
			JSONObject jArray = new JSONObject(); // JSONObject 선언
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			JSONArray jjArray = (JSONArray)jArray.get("param");
    		JSONObject jjjArray = (JSONObject)jjArray.get(0);
			
			con.setAutoCommit(false);

			String sql = new StringBuilder()
	    			.append("DELETE FROM tbi_vehicle_baecha_order\n")
	    			.append("WHERE baecha_no='" 	+ jjjArray.get("baecha_no") + "'\n")
					.append("	AND baecha_seq='" 	+ jjjArray.get("baecha_seq") + "'\n")
					.append("	AND vehicle_cd='" 	+ jjjArray.get("vehicle_cd") + "'\n")
					.append("	AND vehicle_cd_rev='" 	+ jjjArray.get("vehicle_cd_rev") + "'\n")
					.append("	AND order_no='" 	+ jjjArray.get("order_no") + "'\n")
					.append("	AND lotno='" 		+ jjjArray.get("lotno") + "'\n")
					.append("	AND order_detail_seq='" + jjjArray.get("order_detail_seq") + "'\n")
					.append("	AND chulha_no='" 	+ jjjArray.get("chulha_no") + "'\n")
					.append("	AND chulha_seq='" 	+ jjjArray.get("chulha_seq") + "'\n")
					.append("	AND member_key='" 	+ jjjArray.get("member_key") + "'\n")
					.toString();  
			resultInt = super.excuteUpdate(con, sql.toString());
			if (resultInt < 0) {  //
				ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
				con.rollback();
				return EventDefine.E_DOEXCUTE_ERROR ;
			}
    		
			con.commit();
		} catch(Exception e) {
			LoggingWriter.setLogError("M303S020100E113()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M303S020100E113()","==== finally ===="+ e.getMessage());
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