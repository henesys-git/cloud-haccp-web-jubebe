package mes.frame.business.M858;

import java.lang.reflect.Method;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.util.Vector;

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


public class M858S030100 extends SqlAdapter{
	Connection con = null;
	PreparedStatement pstmt = null;
	String resultString = "";
	int resultInt = -1;
	StringBuffer sql = new StringBuffer();
	
	String[][] v_paramArray = new String[0][0]; 
	Class[] optClass = null;
	Object[] optObj = null;
	Object obj = null;
	
	public M858S030100(){
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
			
			Method method = M858S030100.class.getMethod(event,optClass);
			LoggingWriter.setLogDebug(M858S030100.class.getName(),"==== " + event + " EventMethod Create Success ====");

			obj = method.invoke(M858S030100.class.newInstance(),optObj);
			doExcute_result = CommonFunction.getInt(obj.toString());
			
	    } catch (Exception ex) {
	    	doExcute_result = EventDefine.E_DOEXCUTE_INIT;
			ioParam.setMessage(MessageDefine.M_NO_EVENTID);
			LoggingWriter.setLogError(M858S030100.class.getName(),"==== EventID Not define : EVENT ID [ " + ioParam.getEventID() + "]");
	    } finally {
	    	obj = null;
			optClass = null;
			optObj = null;
	    }
	    long endTime = System.currentTimeMillis();
		long runningTime = endTime - startTime;
		LoggingWriter.setLogAll(M858S030100.class.getName(),"==== Query [수행시간  : " + runningTime + " ms]");
		
		return doExcute_result;
	}

	//발주서 등록
	public int E101(InoutParameter ioParam){ 
		resultInt = EventDefine.E_DOEXCUTE_INIT;

		ApprovalActionNo ActionNo;
		String Transport_No="";
			
		try {
			con = JDBCConnectionPool.getConnection();

			JSONObject jArray = new JSONObject();
    		jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
    		System.out.println("JSONObject jArray rcvData="+ jArray.toString());
    		
			con.setAutoCommit(false);

    		JSONObject jArrayHead = (JSONObject) jArray.get("paramHead");
    		JSONArray jjArray = (JSONArray) jArray.get("param");
    		
    		if(jjArray.size()>0) {
    			JSONObject jjjArray0 = (JSONObject)jjArray.get(0);
    			
    			if(jjjArray0.get("transport_no").equals("") || jjjArray0.get("transport_no").equals(null) || jjjArray0.get("transport_no").equals("undefined")) {
        			String jspPage = (String)jArrayHead.get("jsp_page");
    	    		String user_id = (String)jArrayHead.get("login_id");
    	    		String prefix = (String)jArrayHead.get("prefix");
    	    		String actionGubun = "Regist";
    	    		String detail_seq = "1";
    	    		String member_key = (String)jjjArray0.get("member_key");
    				ActionNo = new ApprovalActionNo();
    				Transport_No = ActionNo.getActionNo(con,jspPage,user_id,prefix,actionGubun,detail_seq,member_key);//GV_JSPPAGE(action Page), User ID, prefix
        		} else {
        			Transport_No = (String)jjjArray0.get("transport_no");
        		}
    		}
			System.out.println("Transport_No 값은 = "+Transport_No);
			
			for(int i=0; i<jjArray.size(); i++) {   
				JSONObject jjjArray = (JSONObject)jjArray.get(i);
				
				String sql = new StringBuilder()
						.append("MERGE INTO tbi_vehicle_transport mm\n")
						.append("USING (\n")
						.append("	SELECT \n")
						.append("		'" + Transport_No			 	+ "' AS transport_no,\n")
						.append("		'" + jjjArray.get("baecha_no")  + "' AS baecha_no,\n")
						.append("		'" + jjjArray.get("baecha_seq") + "' AS baecha_seq,\n")
						.append("		'" + jjjArray.get("transport_start_dt") + "' AS transport_start_dt,\n")
						.append("		'" + jjjArray.get("transport_end_dt")  	+ "' AS transport_end_dt,\n")
						.append("		'" + jjjArray.get("vehicle_cd")  	+ "' AS vehicle_cd,\n")
						.append("		'" + jjjArray.get("vehicle_cd_rev") + "' AS vehicle_cd_rev,\n")
						.append("		'" + jjjArray.get("vehicle_nm") 	+ "' AS vehicle_nm,\n")
						.append("		'" + jjjArray.get("driver") 		+ "' AS driver,\n")
						.append("		'" + jjjArray.get("bigo") 			    + "' AS bigo,\n")
						.append("		'" + jjjArray.get("transport_total")  		+ "' AS transport_total, \n")
						.append("		'" + jjjArray.get("transport_distance")  	+ "' AS transport_distance, \n")
						.append("		'" + jjjArray.get("order_no") 			+ "' AS order_no,\n")
						.append("		'" + jjjArray.get("lotno") 				+ "' AS lotno,\n")
						.append("		'" + jjjArray.get("order_detail_seq") 	+ "' AS order_detail_seq,\n")
						.append("		'" + jjjArray.get("member_key") 	+ "' AS member_key\n")
						.append("	FROM db_root ) mQ\n")
						.append("ON ( \n")
						.append("	mm.transport_no=mQ.transport_no\n")
						.append("	AND mm.baecha_no=mQ.baecha_no\n")
						.append("	AND mm.baecha_seq=mQ.baecha_seq\n")
						.append("	AND mm.order_no=mQ.order_no\n")
						.append("	AND mm.lotno=mQ.lotno\n")
						.append("	AND mm.order_detail_seq=mQ.order_detail_seq\n")
						.append("	AND mm.member_key=mQ.member_key\n")
						.append(")\n")
						.append("WHEN MATCHED THEN\n")
						.append("	UPDATE SET \n")
						.append("		mm.transport_no=mQ.transport_no,\n")
						.append("		mm.baecha_no=mQ.baecha_no,\n")
						.append("		mm.baecha_seq=mQ.baecha_seq,\n")
						.append("		mm.transport_start_dt=mQ.transport_start_dt,\n")
						.append("		mm.transport_end_dt=mQ.transport_end_dt,\n")
						.append("		mm.vehicle_cd=mQ.vehicle_cd,\n")
						.append("		mm.vehicle_cd_rev=mQ.vehicle_cd_rev,\n")
						.append("		mm.vehicle_nm=mQ.vehicle_nm,\n")
						.append("		mm.driver=mQ.driver,\n")
						.append("		mm.bigo=mQ.bigo,\n")
						.append("		mm.transport_total=mQ.transport_total,\n")
						.append("		mm.transport_distance=mQ.transport_distance,\n")
						.append("		mm.order_no=mQ.order_no,\n")
						.append("		mm.lotno=mQ.lotno,\n")
						.append("		mm.order_detail_seq=mQ.order_detail_seq,\n")
						.append("		mm.member_key=mQ.member_key\n")
						.append("WHEN NOT MATCHED THEN\n")
						.append("	INSERT (\n")
						.append("		mm.transport_no,\n")
						.append("		mm.baecha_no,\n")
						.append("		mm.baecha_seq,\n")
						.append("		mm.transport_start_dt,\n")
						.append("		mm.transport_end_dt,\n")
						.append("		mm.vehicle_cd,\n")
						.append("		mm.vehicle_cd_rev,\n")
						.append("		mm.vehicle_nm,\n")
						.append("		mm.driver,\n")
						.append("		mm.bigo,\n")
						.append("		mm.transport_total,\n")
						.append("		mm.transport_distance,\n")
						.append("		mm.order_no,\n")
						.append("		mm.lotno,\n")
						.append("		mm.order_detail_seq,\n")
						.append("		mm.member_key\n")
						.append("	) VALUES (\n")
						.append("		mQ.transport_no,\n")
						.append("		mQ.baecha_no,\n")
						.append("		mQ.baecha_seq,\n")
						.append("		mQ.transport_start_dt,\n")
						.append("		mQ.transport_end_dt,\n")
						.append("		mQ.vehicle_cd,\n")
						.append("		mQ.vehicle_cd_rev,\n")
						.append("		mQ.vehicle_nm,\n")
						.append("		mQ.driver,\n")
						.append("		mQ.bigo,\n")
						.append("		mQ.transport_total,\n")
						.append("		mQ.transport_distance,\n")
						.append("		mQ.order_no,\n")
						.append("		mQ.lotno,\n")
						.append("		mQ.order_detail_seq,\n")
						.append("		mQ.member_key\n")
						.append("	)\n")
						.toString();

				// System.out.println(sql.toString());
				resultInt = super.excuteUpdate(con, sql.toString());
				if (resultInt < 0) {  //
					ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
					con.rollback();
					return EventDefine.E_DOEXCUTE_ERROR ;
				}
			}
			con.commit();
		} catch(Exception e) {
			LoggingWriter.setLogError("M858S030100E101()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M858S030100E101()","==== finally ===="+ e.getMessage());
				}
	    	} else {
	    	}
	    }
		ioParam.setResultString(resultString);
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
    	ioParam.setMessage(MessageDefine.M_QUERY_OK);
	    return EventDefine.E_QUERY_RESULT;
	}	

	//생산공정 Update
	public int E102(InoutParameter ioParam){ 
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();

			JSONObject jArray = new JSONObject();
    		jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
    		System.out.println("JSONObject jArray rcvData="+ jArray.toString());
    		
			con.setAutoCommit(false);

    		JSONObject jArrayHead = (JSONObject) jArray.get("paramHead");
    		JSONArray jjArray = (JSONArray) jArray.get("param");
    		
			for(int i=0; i<jjArray.size(); i++) {   
				JSONObject jjjArray = (JSONObject)jjArray.get(i);
				
				String sql = new StringBuilder()
						.append("MERGE INTO tbi_vehicle_transport mm\n")
						.append("USING (\n")
						.append("	SELECT \n")
						.append("		'" + jjjArray.get("transport_no")	+ "' AS transport_no,\n")
						.append("		'" + jjjArray.get("baecha_no")  + "' AS baecha_no,\n")
						.append("		'" + jjjArray.get("baecha_seq") + "' AS baecha_seq,\n")
						.append("		'" + jjjArray.get("transport_start_dt") + "' AS transport_start_dt,\n")
						.append("		'" + jjjArray.get("transport_end_dt")  	+ "' AS transport_end_dt,\n")
						.append("		'" + jjjArray.get("vehicle_cd")  	+ "' AS vehicle_cd,\n")
						.append("		'" + jjjArray.get("vehicle_cd_rev") + "' AS vehicle_cd_rev,\n")
						.append("		'" + jjjArray.get("vehicle_nm") 	+ "' AS vehicle_nm,\n")
						.append("		'" + jjjArray.get("driver") 		+ "' AS driver,\n")
						.append("		'" + jjjArray.get("bigo") 			    + "' AS bigo,\n")
						.append("		'" + jjjArray.get("transport_total")  		+ "' AS transport_total, \n")
						.append("		'" + jjjArray.get("transport_distance")  	+ "' AS transport_distance, \n")
						.append("		'" + jjjArray.get("order_no") 			+ "' AS order_no,\n")
						.append("		'" + jjjArray.get("lotno") 				+ "' AS lotno,\n")
						.append("		'" + jjjArray.get("order_detail_seq") 	+ "' AS order_detail_seq,\n")
						.append("		'" + jjjArray.get("member_key") 	+ "' AS member_key\n")
						.append("	FROM db_root ) mQ\n")
						.append("ON ( \n")
						.append("	mm.transport_no=mQ.transport_no\n")
						.append("	AND mm.baecha_no=mQ.baecha_no\n")
						.append("	AND mm.baecha_seq=mQ.baecha_seq\n")
						.append("	AND mm.order_no=mQ.order_no\n")
						.append("	AND mm.lotno=mQ.lotno\n")
						.append("	AND mm.order_detail_seq=mQ.order_detail_seq\n")
						.append("	AND mm.member_key=mQ.member_key\n")
						.append(")\n")
						.append("WHEN MATCHED THEN\n")
						.append("	UPDATE SET \n")
						.append("		mm.transport_no=mQ.transport_no,\n")
						.append("		mm.baecha_no=mQ.baecha_no,\n")
						.append("		mm.baecha_seq=mQ.baecha_seq,\n")
						.append("		mm.transport_start_dt=mQ.transport_start_dt,\n")
						.append("		mm.transport_end_dt=mQ.transport_end_dt,\n")
						.append("		mm.vehicle_cd=mQ.vehicle_cd,\n")
						.append("		mm.vehicle_cd_rev=mQ.vehicle_cd_rev,\n")
						.append("		mm.vehicle_nm=mQ.vehicle_nm,\n")
						.append("		mm.driver=mQ.driver,\n")
						.append("		mm.bigo=mQ.bigo,\n")
						.append("		mm.transport_total=mQ.transport_total,\n")
						.append("		mm.transport_distance=mQ.transport_distance,\n")
						.append("		mm.order_no=mQ.order_no,\n")
						.append("		mm.lotno=mQ.lotno,\n")
						.append("		mm.order_detail_seq=mQ.order_detail_seq,\n")
						.append("		mm.member_key=mQ.member_key\n")
						.append("WHEN NOT MATCHED THEN\n")
						.append("	INSERT (\n")
						.append("		mm.transport_no,\n")
						.append("		mm.baecha_no,\n")
						.append("		mm.baecha_seq,\n")
						.append("		mm.transport_start_dt,\n")
						.append("		mm.transport_end_dt,\n")
						.append("		mm.vehicle_cd,\n")
						.append("		mm.vehicle_cd_rev,\n")
						.append("		mm.vehicle_nm,\n")
						.append("		mm.driver,\n")
						.append("		mm.bigo,\n")
						.append("		mm.transport_total,\n")
						.append("		mm.transport_distance,\n")
						.append("		mm.order_no,\n")
						.append("		mm.lotno,\n")
						.append("		mm.order_detail_seq,\n")
						.append("		mm.member_key\n")
						.append("	) VALUES (\n")
						.append("		mQ.transport_no,\n")
						.append("		mQ.baecha_no,\n")
						.append("		mQ.baecha_seq,\n")
						.append("		mQ.transport_start_dt,\n")
						.append("		mQ.transport_end_dt,\n")
						.append("		mQ.vehicle_cd,\n")
						.append("		mQ.vehicle_cd_rev,\n")
						.append("		mQ.vehicle_nm,\n")
						.append("		mQ.driver,\n")
						.append("		mQ.bigo,\n")
						.append("		mQ.transport_total,\n")
						.append("		mQ.transport_distance,\n")
						.append("		mQ.order_no,\n")
						.append("		mQ.lotno,\n")
						.append("		mQ.order_detail_seq,\n")
						.append("		mQ.member_key\n")
						.append("	)\n")
						.toString();
						
						
				// System.out.println(sql.toString());
				resultInt = super.excuteUpdate(con, sql.toString());
				if (resultInt < 0) {  //
					ioParam.setMessage(MessageDefine.M_UPDATE_FAILED);
					con.rollback();
					return EventDefine.E_DOEXCUTE_ERROR ;
				}
			}
			con.commit();
		} catch(Exception e) {
			LoggingWriter.setLogError("M858S030100E102()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M858S030100E102()","==== finally ===="+ e.getMessage());
				}
	    	} else {
	    	}
	    }
		ioParam.setResultString(resultString);
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
    	ioParam.setMessage(MessageDefine.M_QUERY_OK);
	    return EventDefine.E_QUERY_RESULT;
	}	

	//발주서 삭제
	public int E103(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();

			JSONObject jArray = new JSONObject();
    		jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
    		System.out.println("JSONObject jArray rcvData="+ jArray.toString());
    		
			con.setAutoCommit(false);

    		JSONObject jArrayHead = (JSONObject) jArray.get("paramHead");
    		JSONArray jjArray = (JSONArray) jArray.get("param");
    		
			for(int i=0; i<jjArray.size(); i++) {   
				JSONObject jjjArray = (JSONObject)jjArray.get(i);
				
				String sql = new StringBuilder()
						.append("DELETE FROM tbi_vehicle_transport\n")
						.append("WHERE transport_no='" 	+ jjjArray.get("transport_no") + "'\n")
						.append("	AND baecha_no='" 		+ jjjArray.get("baecha_no") + "'\n")
//						.append("	AND baecha_seq='" 		+ jjjArray.get("baecha_seq") + "'\n")
						.append("	AND member_key='" 		+ jjjArray.get("member_key") + "'\n")
						.toString();

				// System.out.println(sql.toString());
				resultInt = super.excuteUpdate(con, sql.toString());
				if (resultInt < 0) {  //
					ioParam.setMessage(MessageDefine.M_DELETE_FAILED);
					con.rollback();
					return EventDefine.E_DOEXCUTE_ERROR ;
				}
			}
			con.commit();
		} catch(Exception e) {
			LoggingWriter.setLogError("M858S030100E103()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M858S030100E103()","==== finally ===="+ e.getMessage());
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
	

	public int E104(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			// 클라이언트로 부터 받은 파라미터를 옮겨 담는다.
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			System.out.println("JSONObject jArray rcvData="+ jArray.toString());
					
			
			String sql = new StringBuilder()
					.append("SELECT DISTINCT\n")
					.append("	baecha_no,\n")
					.append("	baecha_seq,\n")
					.append("	vehicle_cd,\n")
					.append("	vehicle_cd_rev,\n")
					.append("	vehicle_nm,\n")
					.append("	baecha_start_dt,\n")
					.append("	baecha_end_dt,\n")
					.append("	driver,\n")
					.append("	bigo\n")
					.append("FROM tbi_vehicle_baecha\n")
					.append("WHERE 1=1\n")
					.append("	AND member_key='" + jArray.get("member_key") + "'\n")
					.append("	AND TO_CHAR(TO_DATETIME(baecha_start_dt),'YYYY-MM-DD') \n")
					.append("		BETWEEN '" + jArray.get("fromdate") + "' AND '" + jArray.get("todate") + "'	\n")
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
			LoggingWriter.setLogError("M858S030100E104()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M858S030100E104()","==== finally ===="+ e.getMessage());
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
	
	public int E114(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
//			// 클라이언트로 부터 받은 파라미터를 옮겨 담는다.
//			String rcvData = (String)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
//			// 클라이언트로 부터 받은 파라미터를 쪼개어서 배열에 담는다.
//			// rcvData = [위경도]
//			String[][] c_paramArray = CommonFunction.getConvString2DoubleArray(rcvData);
			
			
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			
			String sql = new StringBuilder()
					.append("SELECT\n")
					.append("	transport_no,\n")
					.append("	baecha_no,\n")
					.append("	baecha_seq,\n")
					.append("	transport_start_dt,\n")
					.append("	transport_end_dt,\n")
					.append("	vehicle_cd,\n")
					.append("	vehicle_cd_rev,\n")
					.append("	vehicle_nm,\n")
					.append("	transport_total,\n")
					.append("	transport_distance,\n")
					.append("	driver,\n")
					.append("	bigo\n")
					.append("FROM tbi_vehicle_transport\n")
					.append("WHERE baecha_no ='" + jArray.get("baecha_no") + "'\n")
//					.append("	AND baecha_seq ='" + jArray.get("baecha_seq") + "'\n")
					.append("	AND member_key ='" + jArray.get("member_key") + "'\n")
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
			LoggingWriter.setLogError("M858S030100E114()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M858S030100E114()","==== finally ===="+ e.getMessage());
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
			
			// 클라이언트로 부터 받은 파라미터를 옮겨 담는다.
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			System.out.println("JSONObject jArray rcvData="+ jArray.toString());
			
			String sql = new StringBuilder()
					.append("SELECT DISTINCT\n")
					.append("	A.baecha_no,\n")
					.append("	A.baecha_seq,\n")
					.append("	A.baecha_start_dt,\n")
					.append("	A.baecha_end_dt,\n")
					.append("	A.vehicle_cd,\n")
					.append("	A.vehicle_cd_rev,\n")
					.append("	B.vehicle_nm,\n")
					.append("	A.driver,\n")
					.append("	A.bigo\n")
					.append("FROM tbi_vehicle_baecha A\n")
					.append("INNER JOIN tbm_vehicle B\n")
					.append("	ON A.vehicle_cd = B.vehicle_cd\n")
					.append("	AND A.vehicle_cd_rev = B.vehicle_rev_no\n")
					.append("WHERE order_no = '" + jArray.get("order_no") + "'\n")
					.append("	AND lotno = '" + jArray.get("lotno") + "'\n")
					.append("	AND A.baecha_seq NOT IN (\n")
					.append("		SELECT baecha_seq\n")
					.append("		FROM tbi_vehicle_transport\n")
					.append("		WHERE order_no = '" + jArray.get("order_no") + "'\n")
					.append("			AND lotno = '" + jArray.get("lotno") + "'\n")
					.append("			AND baecha_no = A.baecha_no\n")
					.append("			AND member_key ='" + jArray.get("member_key") + "'\n")
					.append("	)\n")
					.append("	AND A.member_key ='" + jArray.get("member_key") + "'\n")
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
			LoggingWriter.setLogError("M858S030100E124()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M858S030100E124()","==== finally ===="+ e.getMessage());
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
			
			// 클라이언트로 부터 받은 파라미터를 옮겨 담는다.
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			System.out.println("JSONObject jArray rcvData="+ jArray.toString());
			
			String sql = new StringBuilder()
					.append("SELECT\n")
					.append("	transport_no,\n")
					.append("	baecha_no,\n")
					.append("	baecha_seq,\n")
					.append("	transport_start_dt,\n")
					.append("	transport_end_dt,\n")
					.append("	A.vehicle_cd,\n")
					.append("	A.vehicle_cd_rev,\n")
					.append("	V.vehicle_nm,\n")
					.append("	driver,\n")
					.append("	A.bigo,\n")
					.append("	transport_total,\n")
					.append("	transport_distance\n")
					.append("FROM tbi_vehicle_transport A\n")
					.append("INNER JOIN tbm_vehicle V\n")
					.append("	ON A.vehicle_cd = V.vehicle_cd\n")
					.append("	AND A.vehicle_cd_rev = v.vehicle_rev_no\n")
					.append("WHERE order_no ='" + jArray.get("order_no") + "'\n")
					.append("	AND lotno ='" + jArray.get("lotno") + "'\n")
					.append("	AND A.member_key ='" + jArray.get("member_key") + "'\n")
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
			LoggingWriter.setLogError("M858S030100E134()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M858S030100E134()","==== finally ===="+ e.getMessage());
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
			
//			// 클라이언트로 부터 받은 파라미터를 옮겨 담는다.
//			String rcvData = (String)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
//			// 클라이언트로 부터 받은 파라미터를 쪼개어서 배열에 담는다.
//			// rcvData = [위경도]
//			String[][] c_paramArray = CommonFunction.getConvString2DoubleArray(rcvData);
			
			
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			
			String sql = new StringBuilder() 
					.append("SELECT\n")
					.append("	A.baecha_no,\n")
					.append("	A.baecha_seq,\n")
					.append("	A.order_no,\n")
					.append("	A.order_detail_seq,\n")
					.append("	C.cust_nm, 		-- 3. 주문업체\n")
					.append("	P.product_nm, 	-- 6. 제품명\n")
					.append("	B.order_date, 	-- 8. 주문일\n")
					.append("	B.lotno, 	-- 7. 주문개수\n")
					.append("	B.lot_count, 	-- 7. 주문개수\n")
					.append("	D.chulha_cnt, 	--출하갯수\n")
					.append("	B.delivery_date, -- 9. 납기일\n")
					.append("	B.expiration_date\n")
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
			
			
			String ActionCommand = ioParam.getActionCommand();
			if(ActionCommand.startsWith("doQueryTableFieldName")) {
				resultString = super.excuteQueryStringTableFieldName(con, sql.toString());
			}
			else {;
				resultString = super.excuteQueryString(con, sql.toString());
			}
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M858S030100E144()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M858S030100E144()","==== finally ===="+ e.getMessage());
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
	
	public int E204(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
//			// 클라이언트로 부터 받은 파라미터를 옮겨 담는다.
//			String rcvData = (String)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
//			// 클라이언트로 부터 받은 파라미터를 쪼개어서 배열에 담는다.
//			// rcvData = [위경도]
//			String[][] c_paramArray = CommonFunction.getConvString2DoubleArray(rcvData);
			
			
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			
			String sql = new StringBuilder()
					.append("SELECT\n")
					.append("	C.cust_nm,\n")
					.append("	B.product_nm || '('||D.code_name  ||','||  E.code_name ||')',\n")
					.append("	A.order_no,\n")
					.append("	A.lotno,\n")
					.append("	lot_count,\n")
					.append("	order_date,\n")
					.append("	delivery_date,\n")
					
					.append("	transport_no,\n")
					.append("	baecha_no,\n")
					.append("	baecha_seq,\n")
					.append("	transport_start_dt,\n")
					.append("	transport_end_dt,\n")
					.append("	T.vehicle_cd,\n")
					.append("	T.vehicle_cd_rev,\n")
					.append("	V.vehicle_nm,\n")
					.append("	driver,\n")
					.append("	T.bigo\n")
					.append("FROM tbi_order A\n")
					.append("INNER JOIN tbm_customer C\n")
					.append("	ON A.cust_cd = C.cust_cd\n")
					.append("	AND A.cust_rev = C.revision_no\n")
					.append("	AND A.member_key = C.member_key\n")
					.append("INNER JOIN tbm_product B\n")
					.append("	ON A.prod_cd = B.prod_cd\n")
					.append("	AND A.prod_rev = B.revision_no\n")
					.append("	AND A.member_key = B.member_key\n")
					.append("INNER JOIN v_prodgubun_big D\n")
					.append("	ON B.prod_gubun_b = D.code_value\n")
					.append("	AND B.member_key = D.member_key\n")
					.append("INNER JOIN v_prodgubun_mid E\n")
					.append("	ON B.prod_gubun_m = E.code_value\n")
					.append("	AND B.member_key = E.member_key\n")
					.append("INNER JOIN tbi_vehicle_transport T\n")
					.append("	ON A.order_no=T.order_no\n")
					.append("	AND A.lotno=T.lotno\n")
					.append("	AND A.member_key=T.member_key\n")
					.append("INNER JOIN tbm_vehicle V\n")
					.append("        ON T.vehicle_cd = V.vehicle_cd\n")
					.append("        AND T.vehicle_cd_rev = v.vehicle_rev_no\n")
					.append("WHERE A.member_key ='" + jArray.get("member_key") + "'\n")
					.append("	AND A.order_date \n")
					.append("		BETWEEN '" + jArray.get("fromdate") + "' 	\n")
					.append("			AND '" + jArray.get("todate") + "'	\n")
					.append("ORDER BY A.prod_cd\n")
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
			LoggingWriter.setLogError("M858S030100E204()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M858S030100E204()","==== finally ===="+ e.getMessage());
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
	
	public int E154(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
//			// 클라이언트로 부터 받은 파라미터를 옮겨 담는다.
//			String rcvData = (String)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
//			// 클라이언트로 부터 받은 파라미터를 쪼개어서 배열에 담는다.
//			// rcvData = [위경도]
//			String[][] c_paramArray = CommonFunction.getConvString2DoubleArray(rcvData);
			
			
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			
			String sql = new StringBuilder()
					.append("SELECT\n")
					.append("	transport_no,\n")
					.append("	baecha_no,\n")
					.append("	baecha_seq,\n")
					.append("	transport_start_dt,\n")
					.append("	transport_end_dt,\n")
					.append("	vehicle_cd,\n")
					.append("	vehicle_cd_rev,\n")
					.append("	vehicle_nm,\n")
					.append("	transport_total,\n")
					.append("	transport_distance,\n")
					.append("	driver,\n")
					.append("	bigo,\n")
					.append("	order_no,\n")
					.append("	lotno,\n")
					.append("	order_detail_seq\n")
					.append("FROM tbi_vehicle_transport\n")
					.append("WHERE transport_no ='" + jArray.get("transport_no") + "'\n")
					.append("	AND baecha_no ='" + jArray.get("baecha_no") + "'\n")
//					.append("	AND baecha_seq ='" + jArray.get("baecha_seq") + "'\n")
					.append("	AND member_key ='" + jArray.get("member_key") + "'\n")
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
			LoggingWriter.setLogError("M858S030100E154()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M858S030100E154()","==== finally ===="+ e.getMessage());
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

