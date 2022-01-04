package mes.frame.business.M303;

import java.lang.reflect.Method;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.util.Vector;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;

import mes.client.conf.Config;
import mes.frame.common.ApprovalActionNo;
import mes.frame.common.EventDefine;
import mes.frame.common.HashObject;
import mes.frame.common.MessageDefine;
import mes.frame.common.QueueProcessing;
import mes.frame.database.JDBCConnectionPool;
import mes.frame.database.SqlAdapter;
import mes.frame.serviceinterface.InoutParameter;
import mes.frame.serviceinterface.LoggingWriter;
import mes.frame.util.ComBaljuUpdate;
import mes.frame.util.CommonFunction;


/**
 * 개요 : 이벤트ID별 메소드 정의
 */
public  class M303S060700 extends SqlAdapter{
	Connection con = null;
	PreparedStatement pstmt = null;
	String resultString = "";
	int resultInt = -1;
	StringBuffer sql = new StringBuffer();
	
	String[][] v_paramArray = new String[0][0]; 
	Class[] optClass = null;
	Object[] optObj = null;
	Object obj = null;
	ComBaljuUpdate varBaljuUpdate = new ComBaljuUpdate(); 
	
	public M303S060700(){
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
			
			Method method = M303S060700.class.getMethod(event,optClass);
			LoggingWriter.setLogDebug(M303S060700.class.getName(),"==== " + event + " EventMethod Create Success ====");

			obj = method.invoke(M303S060700.class.newInstance(),optObj);
			doExcute_result = CommonFunction.getInt(obj.toString());
			
	    } catch (Exception ex) {
	    	doExcute_result = EventDefine.E_DOEXCUTE_INIT;
			ioParam.setMessage(MessageDefine.M_NO_EVENTID);
			LoggingWriter.setLogError(M303S060700.class.getName(),"==== EventID Not define : EVENT ID [ " + ioParam.getEventID() + "]");
	    } finally {
	    	obj = null;
			optClass = null;
			optObj = null;
	    }
	    long endTime = System.currentTimeMillis();
		long runningTime = endTime - startTime;
		LoggingWriter.setLogAll(M303S060700.class.getName(),"==== Query [수행시간  : " + runningTime + " ms]");
		
		return doExcute_result;
	}

	//포장실적등록
	public int E101(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		ApprovalActionNo ActionNo;
		String Proc_Exec_No;
		try {
			con = JDBCConnectionPool.getConnection();
			con.setAutoCommit(false);

    		// insert_update_delete_json.jsp에서 받아온 JSON데이터 처리
    		JSONObject jArray = new JSONObject();
    		jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
    		System.out.println("JSONObject jArray rcvData="+ jArray.toString());
    		// Object데이터에서 키값(param)으로 JSONArray데이터를 꺼낸다. (데이터묶음 하나일땐 생략)
    		JSONArray jjArray = (JSONArray) jArray.get("param");
    		System.out.println("데이터 묶음 개수 :::: " + jjArray.size());
    		
    		JSONObject jArrayHead = (JSONObject)jArray.get("paramHead");; // 0번째 데이터묶음
    		
    		JSONObject jjjArray = (JSONObject)jjArray.get(0); // 0번째 데이터묶음
    		
    		String jspPage = (String)jArrayHead.get("jsp_page");
    		String user_id = (String)jArrayHead.get("user_id");
    		String prefix =  (String)jArrayHead.get("prefix");
    		String actionGubun = "Regist";
    		String detail_seq =  (String)jArrayHead.get("order_detail_seq");  
    		String member_key =  (String)jjjArray.get("member_key");  
   		
			ActionNo = new ApprovalActionNo();
			Proc_Exec_No = ActionNo.getActionNo(con,jspPage,user_id,prefix,actionGubun,detail_seq,member_key);//GV_JSPPAGE(action Page), User ID, prefix
			
			
			
			String sql = new StringBuilder()
					.append("INSERT INTO tbi_production_package_info (\n")
					.append("	order_no,\n")
					.append("	order_detail_seq,\n")
					.append("	lotno,\n")
					.append("	prod_cd,\n")
					.append("	prod_cd_rev,\n")
					.append("	package_no,\n")
					.append("	start_dt,\n")
					.append("	finish_dt,\n")
					
					.append("	package_count,\n")
					
					.append("	exec_note,\n")
					.append("	member_key\n")
					.append(") VALUES (\n")				
					.append("	'" + jjjArray.get("order_no") + "',\n")
					.append("	'" + jjjArray.get("order_detail_seq") + "',\n")
					.append("	'" + jjjArray.get("lotno") + "',\n")
					.append("	'" + jjjArray.get("prod_cd") + "',\n")
					.append("	'" + jjjArray.get("prod_cd_rev") + "',\n")
					.append("	'" + Proc_Exec_No			   + "',\n")
					.append("	'" + jjjArray.get("start_dt") + "',\n")
					.append("	'" + jjjArray.get("finish_dt") + "',\n")
					
					.append("	'" + jjjArray.get("package_count") + "',\n")
					
					.append("	'" + jjjArray.get("exec_note") + "',\n")
					.append("	'" + jjjArray.get("member_key") + "'\n")
					.append(")\n")
					.toString();
			
			// System.out.println(sql.toString());
			resultInt = super.excuteUpdate(con, sql.toString());
			if (resultInt < 0) {
				ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
				con.rollback();
				return EventDefine.E_DOEXCUTE_ERROR ;
			} 
			
			con.commit();
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M303S060700E101", "==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M303S060700E101()","==== finally ===="+ e.getMessage());
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

	//포장실적수정
	public int E102(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject();
    		jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
    		System.out.println("JSONObject jArray rcvData="+ jArray.toString());
			
    		JSONObject jArrayHead = (JSONObject) jArray.get("paramHead");
    		JSONArray jjArray = (JSONArray) jArray.get("param");
    		JSONObject jjjArray = (JSONObject)jjArray.get(0);
			
			con.setAutoCommit(false);

			String sql = new StringBuilder()
					.append("UPDATE tbi_production_package_info \n")
					.append("SET \n")
					.append("	order_no='" 			+ jjjArray.get("order_no") + "',\n")
					.append("	lotno='" 				+ jjjArray.get("lotno") + "',\n")
					.append("	prod_cd='" 				+ jjjArray.get("prod_cd") + "',\n")
					.append("	prod_cd_rev='" 			+ jjjArray.get("prod_cd_rev") + "',\n")
					.append("	package_no='" 			+ jjjArray.get("package_no") + "',\n")
					.append("	start_dt='" 			+ jjjArray.get("start_dt") + "',\n")
					.append("	finish_dt='" 			+ jjjArray.get("finish_dt") + "',\n")
					
					.append("	package_count='" 		+ jjjArray.get("package_count") + "',\n")
					
					.append("	exec_note='" 			+ jjjArray.get("exec_note") + "'\n")
					.append("WHERE order_no='" 			+ jjjArray.get("order_no") + "'\n")
					.append("	AND order_detail_seq='" + jjjArray.get("order_detail_seq") + "'\n")
//					.append("	AND lotno='" 			+ jjjArray.get("lotno") + "'\n")
//					.append("	AND prod_cd='" 			+ jjjArray.get("prod_cd") + "'\n")
//					.append("	AND prod_cd_rev='" 		+ jjjArray.get("prod_cd_rev") + "'\n")
					.append("	AND package_no='" 		+ jjjArray.get("package_no") + "'\n")
					.append("	AND member_key='" 		+ jjjArray.get("member_key") + "'\n")
					.toString();
			
			// System.out.println(sql.toString());
			resultInt = super.excuteUpdate(con, sql.toString());
			if (resultInt < 0) {
				ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
				con.rollback();
				return EventDefine.E_DOEXCUTE_ERROR ;
			}
			con.commit();
		} catch(Exception e) {
			LoggingWriter.setLogError("M303S060700E102", "==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M303S060700E102()","==== finally ===="+ e.getMessage());
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
	
	
	//포장실적삭제
	public int E103(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject();
    		jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
    		System.out.println("JSONObject jArray rcvData="+ jArray.toString());
			
    		JSONObject jArrayHead = (JSONObject) jArray.get("paramHead");
    		JSONArray jjArray = (JSONArray) jArray.get("param");
    		JSONObject jjjArray = (JSONObject)jjArray.get(0);
			
			String sql = new StringBuilder()
					.append("DELETE FROM tbi_production_package_info \n")
					.append("WHERE order_no='" 			+ jjjArray.get("order_no") + "'\n")
					.append("	AND order_detail_seq='" + jjjArray.get("order_detail_seq")  + "'\n")
//					.append("	AND lotno='" 			+ jjjArray.get("lotno")  + "'\n")
//					.append("	AND prod_cd='" 			+ jjjArray.get("prod_cd")  + "'\n")
//					.append("	AND prod_cd_rev='" 		+ jjjArray.get("prod_cd_rev")  + "'\n")
					.append("	AND package_no ='" 		+ jjjArray.get("package_no")  + "'\n")
					.append("  AND member_key ='" 		+ jjjArray.get("member_key") + "' \n")
					.toString();
			
			// System.out.println(sql.toString());
			resultInt = super.excuteUpdate(con, sql.toString());
			if (resultInt < 0) {
				ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
				con.rollback();
				return EventDefine.E_DOEXCUTE_ERROR ;
			}
			
			con.commit();
		} catch(Exception e) {
			LoggingWriter.setLogError("M303S060700E103", "==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M303S060700E103()","==== finally ===="+ e.getMessage());
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

	

	//S303S060700.jsp 조회
	public int E104(InoutParameter ioParam){ //
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		try {
			con = JDBCConnectionPool.getConnection();
			
			// 클라이언트로 부터 받은 파라미터를 옮겨 담는다.
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			System.out.println("JSONObject jArray rcvData="+ jArray.toString());
			

			String sql = new StringBuilder()
					.append("SELECT DISTINCT\n")
					.append("	C.cust_nm,\n")
					.append("	B.product_nm || '('||D.code_name  ||','||  E.code_name ||')' ,\n")
					.append("	cust_pono,\n")
					.append("	product_gubun,\n")
					.append("	part_source,\n")
					.append("	order_date,\n")
					.append("	A.lotno,\n")
					.append("	lot_count,\n")
					.append("	part_chulgo_date,\n")
					.append("	rohs,\n")
					.append("	order_note,\n")
					.append("	delivery_date,\n")
					.append("	bom_version,\n")
					.append("	A.order_no,\n")
					.append("	'',\n") // .append("S.process_name,\n")
					.append("	A.bigo,\n")
					.append("	A.product_serial_no,\n")
					.append("	A.product_serial_no_end,\n")
					.append("	A.cust_cd,\n")
					.append("	A.cust_rev,\n")
					.append("	A.prod_cd,\n")
					.append("	A.prod_rev,\n")
					.append("	'',\n") // .append("Q.order_status,\n")
					.append("	A.expiration_date,\n")
					.append("	A.order_detail_seq,\n")
					.append("	DECODE(product_gubun,'0','양산품','1','개발품') AS product_gubun,	--제품구분\n")
					.append("	DECODE(part_source,'01','사급','02','도급','03','사급&도급') AS part_source,   		--원부자재공급\n")
					.append("	DECODE(rohs,'0','Pb Free','1','Pb') AS rohs,					--rohs\n")
					.append("	PH.production_status,\n")
					.append("	PS.code_name\n")
					.append("FROM\n")
					.append("   tbi_order A\n")
					.append("INNER JOIN tbm_customer C\n")
					.append("   ON A.cust_cd = C.cust_cd\n")
					.append("   AND A.cust_rev = C.revision_no\n")
					.append("	AND A.member_key = C.member_key\n")
//					.append("INNER JOIN tbi_queue Q\n")
//					.append("   ON A.order_no = Q.order_no\n")
//					.append("   AND A.lotno = Q.lotno\n")
//					.append("	AND A.member_key = Q.member_key\n")
//					.append("INNER JOIN tbm_systemcode S\n")
//					.append("   ON Q.order_status = S.status_code\n")
//					.append("   AND Q.process_gubun = S.process_gubun\n")
//					.append("	AND Q.member_key = S.member_key\n")
					.append("INNER JOIN tbm_product B\n")
					.append("   ON A.prod_cd = B.prod_cd\n")
					.append("   AND  A.prod_rev = B.revision_no\n")
					.append("	AND A.member_key = B.member_key\n")
					.append("LEFT OUTER JOIN tbi_production_plan_order PO\n")
					.append("	ON A.order_no = PO.order_no\n")
					.append("	AND A.lotno = PO.lotno\n")
					.append("	AND A.member_key = PO.member_key\n")
					.append("LEFT OUTER JOIN tbi_production_head PH\n")
					.append("	ON PO.proc_plan_no = PH.proc_plan_no\n")
					.append("	AND PO.member_key = PH.member_key\n")
					.append("LEFT OUTER JOIN v_prod_processing_status PS\n")
					.append("	ON PH.production_status = PS.code_value\n")
					.append("	AND PH.member_key = PS.member_key\n")					
					.append("INNER JOIN v_prodgubun_big D			\n")
					.append("	ON B.prod_gubun_b 	= D.code_value 	\n")
					.append("	AND B.member_key 	= D.member_key	\n")					
					.append("INNER JOIN v_prodgubun_mid E			\n")
					.append("	ON B.prod_gubun_m	= E.code_value	\n")
					.append("	AND B.member_key 	= E.member_key	\n")					
					.append("WHERE A.cust_cd LIKE '%" 	+ jArray.get("cust_cd") + "'	\n")
					.append("	AND A.member_key = '"		+  jArray.get("member_key") + "' 	\n")
					.append("	AND order_date \n")
					.append("		BETWEEN '" + jArray.get("fromdate") + "' 	\n")
					.append("	 	AND '" 	   + jArray.get("todate") + "'	\n")
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
			LoggingWriter.setLogError("M303S060700E104()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M303S060700E104()","==== finally ===="+ e.getMessage());
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
	
	//포장공정실적 TAB:S303S060710.jsp
	public int E114(InoutParameter ioParam){ //
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		try {
			con = JDBCConnectionPool.getConnection();
			
//			// 클라이언트로 부터 받은 파라미터를 옮겨 담는다.
//			String rcvData = (String)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
//			// 클라이언트로 부터 받은 파라미터를 쪼개어서 배열에 담는다.
//			String[][] c_paramArray = CommonFunction.getConvString2DoubleArray(rcvData);
			
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			
			String sql = new StringBuilder()
					.append("SELECT\n")
					.append("	P.order_no,\n")
					.append("	P.lotno,\n")
					.append("	P.package_no,\n")
					.append("	P.start_dt,\n")
					.append("	P.finish_dt,\n")
					.append("	P.package_count,\n")
					.append("	P.exec_note,\n")
					.append("	P.prod_cd,\n")
					.append("	P.prod_cd_rev\n")
					.append("FROM\n")
					.append("	tbi_production_package_info P\n")
					
					.append("WHERE P.order_no ='"			+ jArray.get("order_no") + "'  \n")
					.append("	AND P.order_detail_seq = '" + jArray.get("order_detail_seq") + "' \n")
//					.append("	AND P.lotno = '"  		  	+ jArray.get("lotno") + "'  \n")
//					.append("	AND P.prod_cd = '"  		+ jArray.get("prod_cd") + "'  \n")
//					.append("	AND P.prod_cd_rev = '"  	+ jArray.get("prod_cd_rev") + "'  \n")
					.append("	AND P.package_no LIKE '"  + jArray.get("package_no") + "%' \n")
					.append("	AND P.member_key = '"  		+ jArray.get("member_key") + "'  \n")
//					.append("   AND B.proc_cd LIKE'" 		+ "" + "%' \n")
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
			LoggingWriter.setLogError("M303S060700E114()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M303S060700E114()","==== finally ===="+ e.getMessage());
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
	
	public int E115(InoutParameter ioParam){ //
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		try {
			con = JDBCConnectionPool.getConnection();
			
//			// 클라이언트로 부터 받은 파라미터를 옮겨 담는다.
//			String rcvData = (String)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
//			// 클라이언트로 부터 받은 파라미터를 쪼개어서 배열에 담는다.
//			String[][] c_paramArray = CommonFunction.getConvString2DoubleArray(rcvData);
			
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			
			String sql = new StringBuilder()
					.append("SELECT\n")
					.append("	TO_CHAR(MAX(finish_dt),'YYYY-MM-DD'),\n")
					.append("	SUM(package_count)\n")
					.append("FROM\n")
					.append("	tbi_production_package_info\n")
					.append("WHERE order_no ='"			+ jArray.get("order_no") + "'  \n")
					.append("	AND order_detail_seq = '" + jArray.get("order_detail_seq") + "' \n")
					.append("	AND member_key = '"  		+ jArray.get("member_key") + "'  \n")
					.append("GROUP BY order_no,order_detail_seq,member_key\n")
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
			LoggingWriter.setLogError("M303S060700E115()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M303S060700E115()","==== finally ===="+ e.getMessage());
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
	
	//포장실적등록 왼쪽목록
	public int E124(InoutParameter ioParam){ //
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			
			String sql = new StringBuilder()
					.append("SELECT\n")
					.append("	'', --A.order_no,\n")
					.append("	'', --A.lotno,\n")
					.append("	'', --A.proc_plan_no,\n")
					.append("	'',  --A.proc_info_no,\n")
					.append("	'', --A.proc_odr,\n")
					.append("	C.proc_cd,\n")
					.append("	C.revision_no,\n")
					.append("	C.process_nm,\n")
					.append("	'', --B.proc_qnt,\n")
					.append("	'', --B.man_amt,\n")
					.append("	'', --B.start_dt,\n")
					.append("	'' --B.end_dt\n")
					.append("FROM tbm_process C\n")
					.append("--INNER JOIN tbi_production_plan B\n")
					.append("--	ON A.proc_plan_no=B.proc_plan_no\n")
					.append("--	AND A.member_key=B.member_key\n")
					.append("--LEFT OUTER JOIN tbi_production_head A\n")
					.append("--	ON B.proc_cd=C.proc_cd\n")
					.append("--	AND B.proc_cd_rev=C.revision_no\n")
					.append("--	AND B.member_key=C.member_key\n")
					.append("WHERE C.product_process_yn LIKE '%'\n")
					.append("	AND C.packing_process_yn LIKE 'Y%'\n")
					.append("	AND C.member_key='" + jArray.get("member_key") + "'\n")
					.append("--	AND A.order_no  = 'ODR20-000022'\n")
					.append("--	AND A.lotno  = 'box'\n")
					.append("--	AND A.prod_cd = '0101-0003'\n")
					.append("--	AND A.prod_cd_rev = '0'\n")
					.append("--	AND B.proc_cd LIKE '%'\n")
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
			LoggingWriter.setLogError("M303S060700E124()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M303S060700E124()","==== finally ===="+ e.getMessage());
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
	
	// S303S060791.jsp -> S303S060796.jsp 목록
	public int E165(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			System.out.println("JSONObject jArray rcvData="+ jArray.toString());
		
			
			String sql = new StringBuilder()
					.append("SELECT\n")
					.append("	warehousing_datetime,\n")
					.append("	io_gubun,\n")
					.append("	expiration_date,\n")
					.append("	A.part_cd,\n")
					.append("	A.part_cd_rev,\n")
					.append("	P.part_nm,\n")
					.append("	P.gyugyeok,\n")
					.append("	P.detail_gyugyeok,\n")
					.append("	CAST(pre_amt AS NUMERIC(15,3)),\n")
					.append("	CAST(post_amt AS NUMERIC(15,3)),\n")
					.append("	CAST(SUM(io_amt)*P.detail_gyugyeok AS NUMERIC(15,0)),\n")
					.append("	order_no,\n")
					.append("	order_detail_seq,\n")
					.append("	prod_cd,\n")
					.append("	prod_cd_rev,\n")
					.append("	prod_nm,\n")
					.append("	bigo,\n")
					.append("	'N' AS insert_yn\n")
					.append("FROM tbi_production_subpart_storage A\n")
					.append("INNER JOIN tbm_part_list P\n")
					.append("	ON A.part_cd = P.part_cd\n")
					.append("	AND A.part_cd_rev = P.revision_no\n")
					.append("	AND A.member_key = P.member_key\n")
					.append("WHERE order_no = '" +  jArray.get("order_no") + "'\n")
					.append("	AND order_detail_seq = '" +  jArray.get("order_detail_seq") + "'\n")
					.append("	AND prod_cd = '" +  jArray.get("prod_cd") + "'\n")
					.append("	AND prod_cd_rev = '" +  jArray.get("prod_cd_rev") + "'\n")
					.append("	AND io_gubun = 'O'\n")
					.append("	AND A.member_key = '" +  jArray.get("member_key") + "'\n")
					.append("GROUP BY A.part_cd,A.part_cd_rev,A.member_key\n")
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
			LoggingWriter.setLogError("M303S060700E165()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M303S060700E165()","==== finally ===="+ e.getMessage());
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
	
	//bomview => S303S050166.jsp
	public int E166(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			System.out.println("JSONObject jArray rcvData="+ jArray.toString());
			
			// 클라이언트로 부터 받은 파라미터를 옮겨 담는다.
//					String rcvData = (String)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			// 클라이언트로 부터 받은 파라미터를 쪼개어서 배열에 담는다.
			// rcvData = [위경도]
//					String[][] c_paramArray = CommonFunction.getConvString2DoubleArray(rcvData);

			String sql = new StringBuilder()
					.append("SELECT\n")
					.append("	A.prod_cd,\n")
					.append("	A.prod_cd_rev,\n")
					.append("	C.product_nm,\n")
					.append("	A.part_cd,\n")
					.append("	A.part_cd_rev,\n")
					.append("	B.part_nm,\n")
					.append("	A.sub_part_cnt,\n")
					.append("	A.bigo\n")
					.append("FROM tbm_product_subpart A\n")
					.append("INNER JOIN tbm_part_list B\n")
					.append("	ON A.part_cd = B.part_cd\n")
					.append("	AND A.part_cd_rev = B.revision_no\n")
					.append("	AND A.member_key = B.member_key\n")
					.append("INNER JOIN tbm_product C\n")
					.append("	ON A.prod_cd = C.prod_cd\n")
					.append("	AND A.prod_cd_rev = C.revision_no\n")
					.append("	AND A.member_key = C.member_key\n")
					.append("WHERE A.prod_cd = '" + jArray.get("prod_cd") + "'\n")
					.append("	AND A.prod_cd_rev = '" + jArray.get("prod_cd_rev") + "'\n")
					.append("	AND A.member_key = '" + jArray.get("member_key") + "'\n")
					.toString();

			resultString = super.excuteQueryString(con, sql.toString());
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M303S060700E166()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M303S060700E166()","==== finally ===="+ e.getMessage());
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
	
	public int E156(InoutParameter ioParam) {
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		try {
			con = JDBCConnectionPool.getConnection();

			// 클라이언트로 부터 받은 파라미터를 옮겨 담는다.
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			System.out.println("JSONObject jArray rcvData="+ jArray.toString());
			
			String sql = new StringBuilder()
					.append("SELECT DISTINCT\n")
					.append("	A.part_cd,\n")
					.append("	A.part_cd_rev,\n")
					.append("	A.part_nm,\n")
					.append("	A.expiration_date,\n")
					.append("	A.pre_amt,\n")
					.append("	A.post_amt,\n")
					.append("	A.io_amt,\n")
					.append("	A.member_key\n")
					.append("FROM tbi_production_subpart_storage A\n")
					.append("INNER JOIN (\n")
					.append("	SELECT\n")
					.append("		MAX(warehousing_datetime) AS warehousing_datetime,\n")
					.append("		part_cd,part_cd_rev,expiration_date,member_key\n")
					.append("	FROM tbi_production_subpart_storage\n")
					.append("	GROUP BY part_cd,part_cd_rev,expiration_date,member_key\n")
					.append(") B\n")
					.append("	ON A.part_cd=B.part_cd\n")
					.append("	AND A.part_cd_rev=B.part_cd_rev\n")
					.append("	AND A.expiration_date=B.expiration_date\n")
					.append("	AND A.member_key=B.member_key\n")
					.append("	AND A.warehousing_datetime=B.warehousing_datetime\n")
					.append("WHERE A.post_amt > 0 \n")
					.append("	AND A.part_cd = '" + jArray.get("part_cd") + "'\n")
					.append("	AND A.part_cd_rev = '" + jArray.get("part_cd_rev") + "'\n")
					.append("	AND A.member_key = '" + jArray.get("member_key") + "'\n")
					.append("	AND TO_CHAR(TO_DATETIME(A.warehousing_datetime),'YYYY-MM-DD')<='" + jArray.get("delivery_date") + "'\n")
					.append("ORDER BY A.expiration_date \n")
					.toString();

			String ActionCommand = ioParam.getActionCommand();
			if (ActionCommand.startsWith("doQueryTableFieldName")) {
				resultString = super.excuteQueryStringTableFieldName(con, sql.toString());
			} else {
				;
				resultString = super.excuteQueryString(con, sql.toString());
			}
		} catch (Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M303S060700E156()", "==== SQL ERROR ====" + e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR;
		} finally {
			if (Config.useDataSource) {
				try {
					if (con != null)
						con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M303S060700E156()","==== finally ===="+ e.getMessage());
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
	
	public int E151(InoutParameter ioParam) {
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		try {
			con = JDBCConnectionPool.getConnection();

			con.setAutoCommit(false);
			
			JSONObject jArray = new JSONObject(); // JSONObject 선언
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES)); // insert_update_delete_json.jsp에서 받아온 JSON데이터 처리
			
			String sql = new StringBuilder()
					.append("MERGE INTO tbi_production_subpart_storage mm \n")
					.append("USING (\n")
					.append("	SELECT\n")
//					.append("		TO_CHAR(SYSDATETIME,'YYYY-MM-DD HH24:MI:SS') AS warehousing_datetime\n")
					.append("		'"	+ jArray.get("warehousing_datetime") + "' AS warehousing_datetime\n")
					.append("		,'O' AS io_gubun\n")
					.append("		,'"	+ jArray.get("expiration_date") + "' AS expiration_date\n")
					.append("		,'"	+ jArray.get("part_cd") 	+ "' AS part_cd\n")
					.append("		,'"	+ jArray.get("part_cd_rev") + "' AS part_cd_rev\n")
					.append("		,'"	+ jArray.get("part_nm") + "' AS part_nm\n")
					.append("		,'"	+ jArray.get("pre_amt") + "' as pre_amt\n")
					.append("		,'"	+ jArray.get("post_amt") + "' as post_amt\n")
					.append("		,'"	+ jArray.get("io_amt") 	+ "' AS io_amt\n")
					.append("		,'"	+ jArray.get("order_no") + "' AS order_no\n")
					.append("		,'"	+ jArray.get("order_detail_seq") + "' AS order_detail_seq\n")
					.append("		,'"	+ jArray.get("prod_cd") 	+ "' AS prod_cd\n")
					.append("		,'"	+ jArray.get("prod_cd_rev") + "' AS prod_cd_rev\n")
					.append("		,'"	+ jArray.get("prod_nm") 	+ "' AS prod_nm\n")
					.append("		,'포장완료로 인한 부재료 불출' AS bigo\n")
					.append("		,'"	+ jArray.get("member_key") + "' AS member_key\n")
					.append("	FROM db_root \n")
					.append(") mQ\n")
					.append("ON (mm.warehousing_datetime=mQ.warehousing_datetime AND mm.io_gubun=mQ.io_gubun\n")
					.append("	AND mm.expiration_date=mQ.expiration_date AND mm.part_cd=mQ.part_cd\n")
					.append("	AND mm.part_cd_rev=mQ.part_cd_rev AND mm.member_key=mQ.member_key)\n")
					.append("WHEN MATCHED THEN\n")
					.append("	UPDATE SET mm.warehousing_datetime=mQ.warehousing_datetime, mm.io_gubun=mQ.io_gubun, mm.expiration_date=mQ.expiration_date, \n")
					.append("		mm.part_cd=mQ.part_cd, mm.part_cd_rev=mQ.part_cd_rev, mm.part_nm=mQ.part_nm, mm.pre_amt=mQ.pre_amt, mm.post_amt=mQ.post_amt,\n")
					.append("		mm.io_amt=mQ.io_amt, mm.order_no=mQ.order_no, mm.order_detail_seq=mQ.order_detail_seq, mm.prod_cd=mQ.prod_cd, mm.prod_cd_rev=mQ.prod_cd_rev, mm.prod_nm=mQ.prod_nm, mm.bigo=mQ.bigo, mm.member_key=mQ.member_key\n")
					.append("WHEN NOT MATCHED THEN\n")
					.append("	INSERT (mm.warehousing_datetime, mm.io_gubun, mm.expiration_date, mm.part_cd, mm.part_cd_rev, mm.part_nm,\n")
					.append("		mm.pre_amt, mm.post_amt, mm.io_amt, mm.order_no, mm.order_detail_seq, mm.prod_cd, mm.prod_cd_rev, mm.prod_nm, mm.bigo, mm.member_key)\n")
					.append("	VALUES (mQ.warehousing_datetime, mQ.io_gubun, mQ.expiration_date, mQ.part_cd, mQ.part_cd_rev, mQ.part_nm,\n")
					.append("		mQ.pre_amt, mQ.post_amt, mQ.io_amt, mQ.order_no, mQ.order_detail_seq, mQ.prod_cd, mQ.prod_cd_rev, mQ.prod_nm, mQ.bigo, mQ.member_key)\n")
					.toString();
	    	resultInt = super.excuteUpdate(con, sql.toString());
	    	if (resultInt < 0) { 
				ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
				con.rollback();
				return EventDefine.E_DOEXCUTE_ERROR ;
			} 
	    	
	    	// 커밋
			con.commit();
		} catch (Exception e) {
			LoggingWriter.setLogError("M303S060700E151()", "==== SQL ERROR ====" + e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR;
		} finally {
			if (Config.useDataSource) {
				try {
					if (con != null)
						con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M303S060700E151()","==== finally ===="+ e.getMessage());
				}
			} else {
			}
		}
		ioParam.setResultString(resultString);
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
		ioParam.setMessage(MessageDefine.M_QUERY_OK);
		return EventDefine.E_QUERY_RESULT;
	}
	
	// S303S050162.jsp 행삭제
	public int E163(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		try {
			con = JDBCConnectionPool.getConnection();

			con.setAutoCommit(false);
			    		
			
			JSONObject jArray = new JSONObject();
    		jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
    		System.out.println("JSONObject jArray rcvData="+ jArray.toString());
    		JSONArray jjArray = (JSONArray)jArray.get("param");
    		JSONObject jjjArray = (JSONObject)jjArray.get(0);
    		
			String sql = new StringBuilder()
					.append("DELETE FROM tbi_production_subpart_storage\n")
					.append("WHERE order_no = '"+ jjjArray.get("order_no") 		+ "'\n")
					.append("	AND order_detail_seq 	= '"+ jjjArray.get("order_detail_seq")	+ "'\n")
					.append("	AND prod_cd 	= '"+ jjjArray.get("prod_cd")	+ "'\n")
					.append("	AND prod_cd_rev = '"+ jjjArray.get("prod_cd_rev")	+ "'\n")
					.append("	AND warehousing_datetime = '"+ jjjArray.get("warehousing_datetime")	+ "'\n")
					.append("	AND io_gubun 	= '"+ jjjArray.get("io_gubun") + "'\n")
					.append("	AND expiration_date = '" + jjjArray.get("expiration_date") + "'\n")
					.append("	AND part_cd 	= '" + jjjArray.get("part_cd") + "'\n")
					.append("	AND part_cd_rev = '" + jjjArray.get("part_cd_rev") + "'\n")
					.append("	AND member_key 	= '" + jjjArray.get("member_key") + "'\n")
					.toString();
			
			
				resultInt = super.excuteUpdate(con, sql.toString());
				if (resultInt < 0) {
					con.rollback();
					return EventDefine.E_DOEXCUTE_ERROR ;
				}

			con.commit();
		} catch(Exception e) {
			LoggingWriter.setLogError("M303S060700E163()","==== SQL ERROR ===="+ e.getMessage() + "\n" + sql.toString());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M303S060700E163()","==== finally ===="+ e.getMessage());
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
	
	
//	//품질검사 등록 S04S010101.jsp
	public int E501(InoutParameter ioParam){ 
		resultInt = EventDefine.E_DOEXCUTE_INIT;

		String sql ="";
		ApprovalActionNo ActionNo;
		String gOrderNo="";
		
		String aaa="";
		
		int listCnt=0, nextStatuscnt=0;
		try {
			con = JDBCConnectionPool.getConnection();
    		con.setAutoCommit(false);
			
//			String[][] c_paramArray_Head=null;
//			String[][] c_paramArray_Detail=null;
//			String rcvData = (String)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
//
//			Vector resultVector = CommonFunction.getConvStringDamogjuk(rcvData);
//			
//			c_paramArray_Head = (String[][])resultVector.get(0);//head table
//    		c_paramArray_Detail=(String[][])resultVector.get(1); //data table
    		
    		// insert_update_delete_json.jsp에서 받아온 JSON데이터 처리
    		JSONObject jArray = new JSONObject();
    		jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
    		// Object데이터에서 키값(param)으로 JSONArray데이터를 꺼낸다. (데이터묶음 하나일땐 생략)
    		JSONArray jjArray = (JSONArray) jArray.get("param");
    		
//    		if(jjjArray0.get("inspect_seq").equals("")) {
//				aaa="(select * from "
//						+"(select ifnull(max(inspect_seq) + 1,0) from tbi_order_product_inspect_result"
//						+ " where member_key='" + jjjArray0.get("member_key")
//						+ "')"
//					+")";
//    		} else {
//    			aaa=jjjArray0.get("inspect_seq").toString();
//    		}
    		
			
			JSONObject jjjArray0 = (JSONObject)jjArray.get(0); // 0번째 데이터묶음
			
			if(jjjArray0.get("inspect_no").equals("")) {
				ActionNo = new ApprovalActionNo();
				gOrderNo = ActionNo.getActionNo(con,jjjArray0.get("jspPage").toString(),jjjArray0.get("login_id").toString(),jjjArray0.get("num_Gubun").toString(),
						"Regist",jjjArray0.get("lotno").toString());//GV_JSPPAGE(action Page), User ID, prefix
    		} else {
    			gOrderNo =jjjArray0.get("inspect_no").toString();
    		}
			
			for(int i=0;i<jjArray.size();i++) {		
				JSONObject jjjArray = (JSONObject)jjArray.get(i);
				sql = new StringBuilder()
 					.append("MERGE INTO tbi_order_product_inspect_result mm\n")
 					.append("	USING(\n")
 					.append("		SELECT \n")
 					.append("                '" + jjjArray.get("order_no")	+ "' AS order_no,\n")
 					.append("                '" + jjjArray.get("order_detail_seq")	+ "' AS order_detail_seq,\n")
 					.append("                '" + jjjArray.get("lotno") 	+ "' AS lotno,\n")
 					.append("                '" + gOrderNo + "' AS inspect_no,\n")
 					.append("                '" + jjjArray.get("gubun_code") + "' AS inspect_gubun,\n")
 					.append("                '" + jjjArray.get("prod_cd") 	 + "' AS prod_cd,\n")
 					.append("                '" + jjjArray.get("prod_cd_rev") 	 + "' AS prod_cd_rev,\n")
 					.append("                '" + jjjArray.get("login_id") 	 + "' AS user_id,\n")
 					.append("                  SYSDATETIME AS inspect_result_dt,\n")
 					.append("                '" + jjjArray.get("checklist_cd") 		+ "' AS checklist_cd,\n")
 					.append("                '" + jjjArray.get("checklist_cd_rev") 	+ "' AS checklist_cd_rev,\n")
 					.append("                '" + jjjArray.get("item_cd") 			+ "' AS item_cd,\n")
 					.append("                '" + jjjArray.get("item_cd_rev") 		+ "' AS item_cd_rev,\n")
 					.append("                '" + jjjArray.get("standard_value") 	+ "' AS standard_value,\n")
 					.append("                '" + jjjArray.get("result_value") 		+ "' AS result_value,\n")
 					.append("                 '" + i + "' AS inspect_seq,\n")
 					.append("                '" + jjjArray.get("pass_yn") 				+ "' AS pass_yn,\n")
 					.append("                '" + jjjArray.get("product_serial_no") 	+ "' AS product_serial_no,\n")
 					.append("                '" + jjjArray.get("product_serial_no_end") + "' AS product_serial_no_end,\n")
 					.append("                '" + jjjArray.get("member_key") 			+ "' AS member_key,\n")
 					.append("                '" + jjjArray.get("defect_cnt") 			+ "' AS defect_cnt,\n")
 					.append("                '" + jjjArray.get("incong_note") 			+ "' AS incong_note,\n")
 					.append("                '" + jjjArray.get("improve_note") 			+ "' AS improve_note\n")
 					.append("                FROM db_root ) mQ\n")
 					.append("	ON (\n")
 					.append("		mm.order_no=mQ.order_no\n")
 					.append("		AND mm.order_detail_seq=mQ.order_detail_seq\n")
 					.append("		AND mm.inspect_no=mQ.inspect_no\n")
// 					.append("		AND mm.lotno=mQ.lotno\n")
// 					.append("		AND mm.product_serial_no=mQ.product_serial_no\n")
// 					.append("		AND mm.product_serial_no_end=mQ.product_serial_no_end\n")
// 					.append("		AND mm.inspect_gubun=mQ.inspect_gubun\n")
 					.append("		AND mm.inspect_seq=mQ.inspect_seq\n")
 					.append("		AND mm.member_key=mQ.member_key\n")
 					.append("	)\n")
 					.append("WHEN MATCHED THEN\n")
 					.append("                UPDATE SET\n")
 					.append("	                mm.order_no=mQ.order_no,\n")
 					.append("	                mm.order_detail_seq=mQ.order_detail_seq,\n")
 					.append("	                mm.lotno=mQ.lotno,\n")
 					.append("	                mm.inspect_no=mQ.inspect_no,\n")
 					.append("	                mm.inspect_gubun=mQ.inspect_gubun,\n")
 					.append("	                mm.prod_cd=mQ.prod_cd,\n")
 					.append("	                mm.prod_cd_rev=mQ.prod_cd_rev,\n")
 					.append("	                mm.user_id=mQ.user_id,\n")
 					.append("	                mm.inspect_result_dt=mQ.inspect_result_dt,\n")
 					.append("	                mm.checklist_cd=mQ.checklist_cd,\n")
 					.append("	                mm.checklist_cd_rev=mQ.checklist_cd_rev,\n")
 					.append("	                mm.item_cd=mQ.item_cd,\n")
 					.append("	                mm.item_cd_rev=mQ.item_cd_rev,\n")
 					.append("	                mm.standard_value=mQ.standard_value,\n")
 					.append("	                mm.result_value=mQ.result_value,\n")
 					.append("	                mm.inspect_seq=mQ.inspect_seq,\n")
 					.append("	                mm.pass_yn=mQ.pass_yn,\n")
 					.append("	                mm.product_serial_no=mQ.product_serial_no,\n")
 					.append("	                mm.product_serial_no_end=mQ.product_serial_no_end,\n")
 					.append("	                mm.member_key=mQ.member_key,\n")
 					.append("	                mm.defect_cnt=mQ.defect_cnt,\n")
 					.append("	                mm.incong_note=mQ.incong_note,\n")
 					.append("	                mm.improve_note=mQ.improve_note\n")
 					.append("WHEN NOT MATCHED THEN\n")
 					.append("                INSERT(\n")
 					.append("	                mm.order_no,\n")
 					.append("	                mm.order_detail_seq,\n")
 					.append("	                mm.lotno,\n")
 					.append("	                mm.inspect_no,\n")
 					.append("	                mm.inspect_gubun,\n")
 					.append("	                mm.prod_cd,\n")
 					.append("	                mm.prod_cd_rev,\n")
 					.append("	                mm.user_id,\n")
 					.append("	                mm.inspect_result_dt,\n")
 					.append("	                mm.checklist_cd,\n")
 					.append("	                mm.checklist_cd_rev,\n")
 					.append("	                mm.item_cd,\n")
 					.append("	                mm.item_cd_rev,\n")
 					.append("	                mm.standard_value,\n")
 					.append("	                mm.result_value,\n")
 					.append("	                mm.inspect_seq ,\n")
 					.append("	                mm.pass_yn,\n")
 					.append("	                mm.product_serial_no,\n")
 					.append("	                mm.product_serial_no_end,\n")
 					.append("	                mm.member_key,\n")
 					.append("	                mm.defect_cnt,\n")
 					.append("	                mm.incong_note,\n")
 					.append("	                mm.improve_note\n")
 					.append("                ) VALUES (\n")
 					.append(" 			 		mQ.order_no,\n")
 					.append("	                mQ.order_detail_seq,\n")
 					.append("	                mQ.lotno,\n")
 					.append("	                mQ.inspect_no,\n")
 					.append("	                mQ.inspect_gubun,\n")
 					.append("	                mQ.prod_cd,\n")
 					.append("	                mQ.prod_cd_rev,\n")
 					.append("	                mQ.user_id,\n")
 					.append("	                mQ.inspect_result_dt,\n")
 					.append("	                mQ.checklist_cd,\n")
 					.append("	                mQ.checklist_cd_rev,\n")
 					.append("	                mQ.item_cd,\n")
 					.append("	                mQ.item_cd_rev,\n")
 					.append("	                mQ.standard_value,\n")
 					.append("	                mQ.result_value,\n")
 					.append("	                mQ.inspect_seq,\n")
 					.append("	                mQ.pass_yn,\n")
 					.append("	                mQ.product_serial_no,\n")
 					.append("	                mQ.product_serial_no_end,\n")
 					.append("	                mQ.member_key,\n")
 					.append("	                mQ.defect_cnt,\n")
 					.append("	                mQ.incong_note,\n")
 					.append("	                mQ.improve_note\n")
 					.append(")\n")
					.toString();
					
			
				// System.out.println(sql.toString());
				
				resultInt = super.excuteUpdate(con, sql.toString());
		    	if(resultInt < 0){  //
					ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
					con.rollback();
					return EventDefine.E_DOEXCUTE_ERROR ;
				}
			}
			con.commit();
			
		} catch(Exception e) {
			e.getStackTrace();
			LoggingWriter.setLogError("M303S060700E501()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M303S060700E501()","==== finally ===="+ e.getMessage());
				}
	    	} else {
	    	}
	    }
		ioParam.setResultString(resultString);
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
    	ioParam.setMessage(MessageDefine.M_QUERY_OK);
	    return EventDefine.E_QUERY_RESULT;
	}	
	
	//Client: M404S070110 품질검사내역
public int E514(InoutParameter ioParam){ //
	resultInt = EventDefine.E_DOEXCUTE_INIT;
	try {
		con = JDBCConnectionPool.getConnection();
		
		JSONObject jArray = new JSONObject();
		jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
		System.out.println("JSONObject jArray rcvData="+ jArray.toString());
		
		// 클라이언트로 부터 받은 파라미터를 옮겨 담는다.
//		String rcvData = (String)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
		// 클라이언트로 부터 받은 파라미터를 쪼개어서 배열에 담는다.
//		String[][] c_paramArray = CommonFunction.getConvString2DoubleArray(rcvData);
		String sql = new StringBuilder()
				.append("SELECT\n")
				.append("A.order_no,\n")
				.append("A.lotno,\n")
				.append("A.inspect_no,\n")
				.append("D.code_name,\n")
				.append("C.product_nm,\n")
				.append("A.prod_cd_rev,\n")
				.append("A.user_id,\n")
				.append("A.inspect_result_dt,\n")
				.append("A.checklist_cd,\n")
				.append("A.checklist_cd_rev,\n")
				.append("A.item_cd,\n")
				.append("A.item_cd_rev,\n")
				.append("A.result_value,\n")
				.append("A.inspect_seq,\n")
				.append("A.inspect_gubun,\n")
				.append("A.prod_cd,\n")
				.append("A.standard_value,\n")
				.append("A.defect_cnt\n")
				.append("FROM\n")
				.append("        tbi_order_product_inspect_result A\n")
				.append("        INNER JOIN tbm_product C\n")
				.append("        ON A.prod_cd = C.prod_cd\n")
				.append("        AND A.prod_cd_rev = C.revision_no\n")
				.append("   	 AND A.member_key = C.member_key\n")
				.append("        INNER JOIN v_checklist_gubun D\n")
				.append("        ON A.inspect_gubun = D.code_value\n")
				.append("   	 AND A.member_key = D.member_key\n")
				.append("where  A.order_no = '" + jArray.get("order_no") + "' \n")
				.append("AND  	A.order_detail_seq = '" + jArray.get("order_detail_seq") + "' \n")
//				.append("AND  	A.lotno = '" + jArray.get("lotno") + "' \n")
//				.append("AND  	A.inspect_gubun like '%" + jArray.get("gubun_code") + "' \n")
				.append("AND  	A.inspect_gubun = 'PACK' \n")
//				.append("AND	A.product_serial_no like '%" + jArray.get("product_serial_no") + "'\n")
//				.append("AND	A.product_serial_no_end like '%" + jArray.get("product_serial_no_end") + "'\n")
				.append("AND 	A.member_key = '" + jArray.get("member_key") + "'  \n")
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
		LoggingWriter.setLogError("M303S060700E514()","==== SQL ERROR ===="+ e.getMessage());
		return EventDefine.E_DOEXCUTE_ERROR ;
    } finally {
    	if (Config.useDataSource) {
			try {
				if (con != null) con.close();
			} catch (Exception e) {
				LoggingWriter.setLogError("M303S060700E514()","==== finally ===="+ e.getMessage());
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
	
	//	제품 품질검사체크리스트 S04S010130.jsp
	public int E534(InoutParameter ioParam){
	resultInt = EventDefine.E_DOEXCUTE_INIT;
	
	try {
		con = JDBCConnectionPool.getConnection();
		
		JSONObject jArray = new JSONObject();
		jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
		System.out.println("JSONObject jArray rcvData="+ jArray.toString());
		
		String sql = new StringBuilder()
				.append("SELECT DISTINCT\n")
				.append("	R.order_no,\n")
				.append("	R.order_detail_seq,\n")
				.append("	R.lotno,\n")
				.append("	R.prod_cd,\n")
				.append("	R.prod_cd_rev,\n")
				.append("	R.inspect_no,\n")
				.append("	A.check_gubun,\n")
				.append("	A.checklist_seq,\n")
				.append("	A.checklist_cd,\n")
				.append("	A.revision_no, \n")
				.append("	A.item_cd,\n")
				.append("	A.item_seq,\n")
				.append("	A.item_cd_rev,\n")
				.append("	B.item_desc,\n")
				.append("	B.item_type,\n")
				.append("	B.item_bigo,\n")
				.append("	A.standard_guide,\n")
				.append("	A.standard_value,\n")
				.append("	A.check_note,\n")
				.append("	R.result_value,\n")
				.append("	R.inspect_no\n")
				.append("FROM vtbm_checklist A\n")
				.append("INNER JOIN vtbm_check_item B\n")
				.append("	ON A.item_cd = B.item_cd\n")
				.append("	AND A.item_seq = B.item_seq\n")
				.append("	AND A.item_cd_rev = B.revision_no\n")
				.append("	AND A.member_key = B.member_key\n")
				.append("LEFT OUTER JOIN tbi_order_product_inspect_result R\n")
				.append("	ON R.inspect_gubun = A.check_gubun\n")
				.append("	AND R.checklist_cd = A.checklist_cd\n")
				.append("	AND R.checklist_cd_rev = A.revision_no\n")
				.append("	AND R.member_key = A.member_key\n")
				.append("	AND R.order_no = '" + jArray.get("order_no") + "'\n")
				.append("	AND R.order_detail_seq = '" + jArray.get("order_detail_seq") + "'\n")
				.append("WHERE A.check_gubun = '" + jArray.get("check_gubun") + "'\n")
				.append("	AND A.member_key = '" + jArray.get("member_key") + "'\n")
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
		LoggingWriter.setLogError("M303S060700E534()","==== SQL ERROR ===="+ e.getMessage());
		return EventDefine.E_DOEXCUTE_ERROR ;
	} finally {
		if (Config.useDataSource) {
			try {
				if (con != null) con.close();
			} catch (Exception e) {
				LoggingWriter.setLogError("M303S060700E534()","==== finally ===="+ e.getMessage());
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
	
	//S303S060554.jsp 조회
	public int E554(InoutParameter ioParam){ //
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		try {
			con = JDBCConnectionPool.getConnection();
			
			// 클라이언트로 부터 받은 파라미터를 옮겨 담는다.
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			System.out.println("JSONObject jArray rcvData="+ jArray.toString());
			

			String sql = new StringBuilder()
					.append("SELECT  \n")
					.append("SUM(A.defect_cnt)\n")
					.append("FROM tbi_order_product_inspect_result A\n")
					.append("INNER JOIN tbi_order B\n")
					.append("ON A.order_no = B.order_no\n")
					.append("AND A.lotno = B.lotno\n")
					.append("WHERE A.order_no='" + jArray.get("order_no") + "'\n")
					.append("AND A.lotno='" + jArray.get("lotno") + "'\n")
					.append("AND A.member_key = '" + jArray.get("member_key") + "'\n")
//					.append("AND A.defect_cnt >= B.lot_count\n")
					.append("GROUP BY A.order_no\n")
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
			LoggingWriter.setLogError("M303S060700E554()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M303S060700E554()","==== finally ===="+ e.getMessage());
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
			
			String sql = new StringBuilder()
					.append("SELECT\n")
					.append("        A.check_gubun,\n")
					.append("        E.code_name,\n")
					.append("        A.checklist_cd,\n")
					.append("        A.revision_no,\n")
					.append("        A.checklist_seq,\n")
					.append("        A.check_note,\n")
					.append("        A.standard_guide,\n")
					.append("        A.standard_value,\n")
					.append("        A.double_check_yn,\n")
					.append("        A.item_cd,\n")
					.append("        A.item_seq,\n")
					.append("        A.item_cd_rev,\n")
					.append("        B.item_type,\n")
					.append("        B.item_bigo,\n")
					.append("        B.item_desc,\n")
					.append("        A.start_date,\n")
					.append("        A.duration_date,\n")
					.append("        A.check_gubun_mid,\n")
					.append("        F.code_name,\n")
					.append("        A.check_gubun_sm,\n")
					.append("       G.code_name\n")
					.append("FROM vtbm_checklist A\n")
					.append("INNER JOIN vtbm_check_item B\n")
					.append("        ON A.item_cd = B.item_cd\n")
					.append("        AND A.item_seq = B.item_seq\n")
					.append("        AND A.item_cd_rev = B.revision_no\n")
					.append("        AND A.member_key = B.member_key\n")
					.append("INNER JOIN v_checklist_gubun E\n")
					.append("        ON A.check_gubun = E.code_value\n")
					.append("        AND A.member_key = E.member_key\n")
					.append("LEFT OUTER JOIN v_checklist_gubun_mid F\n")
					.append("        ON A.check_gubun = F.code_cd\n")
					.append("        AND A.check_gubun_mid = F.code_value\n")
					.append("        AND A.member_key = F.member_key\n")
					.append("LEFT OUTER JOIN v_checklist_gubun_sm G\n")
					.append("        ON A.check_gubun = G.code_cd_big\n")
					.append("        AND A.check_gubun_mid = G.code_cd\n")
					.append("        AND A.check_gubun_sm = G.code_value\n")
					.append("        AND A.member_key = G.member_key\n")
					.append("where A.checklist_cd LIKE '" + jArray.get("inspect_gubun") + "%'\n")
					.append(" 	AND A.member_key = '" + jArray.get("member_key") + "' \n")
					.append("ORDER BY A.checklist_cd\n")
					.append(";\n")
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
			LoggingWriter.setLogError("M303S060700E134()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M303S060700E134()","==== finally ===="+ e.getMessage());
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
	
	

	
	// 생산실적등록 데이터 뿌리기
	public int E144(InoutParameter ioParam) { //
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		try {
			con = JDBCConnectionPool.getConnection();

			// 클라이언트로 부터 받은 파라미터를 옮겨 담는다.
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			System.out.println("JSONObject jArray rcvData="+ jArray.toString());
			
			String sql = new StringBuilder()
					.append("SELECT\n")
					.append("	A.order_no,\n")
					.append("	C.cust_nm,\n")
					.append("	A.inspect_gubun,\n")
					.append("	B.product_nm,\n")
					.append("	A.prod_cd,\n")
					.append("	A.prod_cd_rev,\n")
					.append("	TO_CHAR(A.inspect_result_dt, 'HH24:MI'),\n")
					.append("	O.lot_count,\n")
					.append("	A.user_id,\n")
					.append("	A.checklist_cd,\n")
					.append("	A.checklist_cd_rev,\n")
					.append("	A.item_cd,\n")
					.append("	A.item_cd_rev,\n")
					.append("	A.standard_value,\n")
					.append("	A.result_value,\n")
					.append("	A.incong_note,\n")
					.append("	A.improve_note,\n")
					.append("	A.member_key\n")
					.append("FROM  tbi_order_product_inspect_result A\n")
					.append("INNER JOIN vtbm_product B\n")
					.append("	ON A.prod_cd = B.prod_cd\n")
					.append("	AND A.prod_cd_rev = B.revision_no\n")
					.append("	AND A.member_key = B.member_key\n")
					.append("INNER JOIN tbi_order O\n")
					.append("	ON A.order_no = O.order_no\n")
					.append("	AND A.order_detail_seq = O.order_detail_seq\n")
					.append("	AND A.prod_cd = O.prod_cd\n")
					.append("	AND A.lotno = O.lotno\n")
					.append("INNER JOIN tbm_customer C\n")
					.append("	ON O.cust_cd = C.cust_cd\n")
					.append("	AND O.cust_rev = C.revision_no\n")
					.append("where A.checklist_cd LIKE '" + jArray.get("inspect_gubun") + "%'\n")
					.append("	AND TO_CHAR(inspect_result_dt,'YYYY-MM-DD')  = '" + jArray.get("inspect_result_dt") + "' \n")
					.append("	AND A.member_key = '" + jArray.get("member_key") + "' \n")
					.append("ORDER BY A.inspect_result_dt, A.order_no, A.checklist_cd;\n")
					.toString();
			
			String ActionCommand = ioParam.getActionCommand();
			if (ActionCommand.startsWith("doQueryTableFieldName")) {
				resultString = super.excuteQueryStringTableFieldName(con, sql.toString());
			} else {
				;
				resultString = super.excuteQueryString(con, sql.toString());
			}
		} catch (Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M303S060700E144()", "==== SQL ERROR ====" + e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR;
		} finally {
			if (Config.useDataSource) {
				try {
					if (con != null)
						con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M303S060700E144()","==== finally ===="+ e.getMessage());
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
	

	
	// 포장검수일지등록
	public int E761(InoutParameter ioParam) { //
		String sql = "";
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		ApprovalActionNo ActionNo;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			// 클라이언트로 부터 받은 파라미터를 옮겨 담는다.
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			System.out.println("JSONObject jArray rcvData="+ jArray.toString());
			
			sql = new StringBuilder()
    				.append("SELECT\n")
    				.append("	NVL(MAX(package_seq),0)+1\n")
    				.append("FROM\n")
    				.append("	haccp_package_inspection_list\n")
    				.append("WHERE 1=1\n")
    				.append("	AND order_no = '" 	+ jArray.get("order_no") + "'    \n")
    				.append("	AND lotno = '" 	    + jArray.get("lotno") + "'       \n")
    				.append("	AND prod_cd = '" 	+ jArray.get("prod_cd") + "'     \n")
    				.append("	AND prod_cd_rev = '" + jArray.get("prod_cd_rev") + "'\n")
    				.append("	AND package_no = '"  + jArray.get("package_no") + "' \n")
    				.append("AND member_key = '"    + jArray.get("member_key") + "'  \n")
    				.toString();
    		String package_seq 	= excuteQueryString(con, sql.toString()).trim();
			
			sql = new StringBuilder()
					.append("INSERT INTO haccp_package_inspection_list (\n")
					.append("	order_no	,\n")
					.append("	lotno,\n")
					.append("	prod_cd,\n")
					.append("	prod_cd_rev,\n")
					.append("	package_no	,\n")
					.append("	package_seq	,\n")
					.append("	package_checktime,\n")
					.append("	package_weight,\n")
					.append("	inbox_barcode_no,\n")
					.append("	inbox_expiration_date,\n")
					.append("	outbox_barcode_no,\n")
					.append("	outbox_expiration_date,\n")
					.append("	member_key\n")
					.append(") VALUES (\n")
					.append("	'" + jArray.get("order_no") + "',\n")
					.append("	'" + jArray.get("lotno") + "',\n")
					.append("	'" + jArray.get("prod_cd") + "',\n")
					.append("	'" + jArray.get("prod_cd_rev") + "',\n")
					.append("	'" + jArray.get("package_no") + "',\n")
					.append("	'" + package_seq + "',\n")
					.append("	'" + jArray.get("package_checktime") + "',\n")
					.append("	'" + jArray.get("package_weight") + "',\n")
					.append("	'" + jArray.get("inbox_barcode_no") + "',\n")
					.append("	'" + jArray.get("inbox_expiration_date") + "',\n")
					.append("	'" + jArray.get("outbox_barcode_no") + "',\n")
					.append("	'" + jArray.get("outbox_expiration_date") + "',\n")
					.append("	'" + jArray.get("member_key") + "'\n")
					.append(") \n")
					.toString();

			resultInt = super.excuteUpdate(con, sql.toString());
    		if (resultInt < 0) {  //
				ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
				con.rollback();
				return EventDefine.E_DOEXCUTE_ERROR ;
			}
    		
		con.commit();
		} catch (Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M303S060700E761()", "==== SQL ERROR ====" + e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR;
		} finally {
			if (Config.useDataSource) {
				try {
					if (con != null)
						con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M303S060700E761()","==== finally ===="+ e.getMessage());
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
	// 생산실적등록 데이터 뿌리기
	public int E704(InoutParameter ioParam) { //
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		try {
			con = JDBCConnectionPool.getConnection();
			
			// 클라이언트로 부터 받은 파라미터를 옮겨 담는다.
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			System.out.println("JSONObject jArray rcvData="+ jArray.toString());
			
			String sql = new StringBuilder()
					.append("SELECT \n")
					.append("	P.order_no,\n")
					.append("	C.cust_nm,\n")
					.append("	P.lotno, \n")
					.append("	O.lot_count,\n")
					.append("	P.start_dt,\n")
					.append("	P.finish_dt,\n")
					.append("	P.package_count,\n")
					.append("	P.prod_cd,\n")
					.append("	P.package_no\n")
					.append("FROM tbi_production_package_info P\n")
					.append("INNER JOIN tbi_order O\n")
					.append("ON P.order_no = O.order_no\n")
					.append("AND P.prod_cd = O.prod_cd\n")
					.append("AND P.lotno = O.lotno\n")
					.append("AND P.member_key = O.member_key\n")
					.append("INNER JOIN tbm_customer C\n")
					.append("ON O.cust_cd = C.cust_cd\n")
					.append("AND O.cust_rev = C.revision_no\n")
					.append("AND P.member_key = C.member_key\n")
					.append("AND O.member_key = C.member_key\n")
					.append("WHERE P.member_key = '" + jArray.get("member_key") + "' \n")
					.append("AND P.order_no = '" + jArray.get("order_no") + "' \n")
					.append("AND P.package_no = '" + jArray.get("package_no") + "' \n")
					.append("AND P.prod_cd = '" + jArray.get("prod_cd") + "' \n")
					.append("AND P.prod_cd_rev = '" + jArray.get("prod_cd_rev") + "' \n")
					.toString();
			
			
			String ActionCommand = ioParam.getActionCommand();
			if (ActionCommand.startsWith("doQueryTableFieldName")) {
				resultString = super.excuteQueryStringTableFieldName(con, sql.toString());
			} else {
				;
				resultString = super.excuteQueryString(con, sql.toString());
			}
		} catch (Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M303S060700E704()", "==== SQL ERROR ====" + e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR;
		} finally {
			if (Config.useDataSource) {
				try {
					if (con != null)
						con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M303S060700E704()","==== finally ===="+ e.getMessage());
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
	
	// 생산실적등록 데이터 뿌리기
	public int E765(InoutParameter ioParam) { //
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		try {
			con = JDBCConnectionPool.getConnection();
			
			// 클라이언트로 부터 받은 파라미터를 옮겨 담는다.
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			System.out.println("JSONObject jArray rcvData="+ jArray.toString());
			
			String sql = new StringBuilder()
					.append("SELECT  COUNT (*)\n")
					.append("FROM \n")
					.append("	haccp_package_inspection_list\n")
					.append("WHERE member_key = '" + jArray.get("member_key") + "' \n")
					.append("AND order_no = '" + jArray.get("order_no") + "' \n")
					.append("AND lotno = '" + jArray.get("lotno") + "' \n")
					.append("AND package_no = '" + jArray.get("package_no") + "' \n")
					.append("AND prod_cd = '" + jArray.get("prod_cd") + "' \n")
					.append("AND prod_cd_rev = '" + jArray.get("prod_cd_rev") + "' \n")
					.toString();

			
			String ActionCommand = ioParam.getActionCommand();
			if (ActionCommand.startsWith("doQueryTableFieldName")) {
				resultString = super.excuteQueryStringTableFieldName(con, sql.toString());
			} else {
				;
				resultString = super.excuteQueryString(con, sql.toString());
			}
		} catch (Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M303S060700E765()", "==== SQL ERROR ====" + e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR;
		} finally {
			if (Config.useDataSource) {
				try {
					if (con != null)
						con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M303S060700E765()","==== finally ===="+ e.getMessage());
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
	
	// 생산실적등록 데이터 뿌리기
	public int E004(InoutParameter ioParam) { //
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		try {
			con = JDBCConnectionPool.getConnection();
			
			// 클라이언트로 부터 받은 파라미터를 옮겨 담는다.
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			System.out.println("JSONObject jArray rcvData="+ jArray.toString());
			
			String sql = new StringBuilder()
					.append("SELECT \n")
					.append("	COUNT (*)\n")
					.append("FROM \n")
					.append("	tbi_production_package_info\n")
					.append("WHERE member_key = '" + jArray.get("member_key") + "' \n")
					.append("AND order_no = '" + jArray.get("order_no") + "' \n")
					.append("AND lotno = '" + jArray.get("lotno") + "' \n")
					.append("AND prod_cd = '" + jArray.get("prod_cd") + "' \n")
					.append("AND prod_cd_rev = '" + jArray.get("prod_cd_rev") + "' \n")
					.toString();
			
			String ActionCommand = ioParam.getActionCommand();
			if (ActionCommand.startsWith("doQueryTableFieldName")) {
				resultString = super.excuteQueryStringTableFieldName(con, sql.toString());
			} else {
				;
				resultString = super.excuteQueryString(con, sql.toString());
			}
		} catch (Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M303S060700E004()", "==== SQL ERROR ====" + e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR;
		} finally {
			if (Config.useDataSource) {
				try {
					if (con != null)
						con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M303S060700E004()","==== finally ===="+ e.getMessage());
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
	
	// 생산실적등록 데이터 뿌리기
	public int E764(InoutParameter ioParam) { //
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		try {
			con = JDBCConnectionPool.getConnection();
			
			// 클라이언트로 부터 받은 파라미터를 옮겨 담는다.
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			System.out.println("JSONObject jArray rcvData="+ jArray.toString());
			
			String sql = new StringBuilder()
					.append("SELECT \n")
					.append("        A.order_no,\n")
					.append("        C.cust_nm,\n")
					.append("        B.product_nm,\n")
					.append("        P.package_unit_count,\n")
					.append("        O.lot_count,\n")
					.append("        NVL(TO_CHAR(S.expiration_date,'YYYY-MM-DD'),'-') AS expiration_date,\n")
					.append("        A.prod_cd,\n")
					.append("        A.prod_cd_rev,\n")
					.append("        TO_CHAR(P.start_dt,'YYYY-MM-DD HH:MI'),\n")
					.append("        TO_CHAR(P.finish_dt,'YYYY-MM-DD HH:MI'),\n")
					.append("        A.package_no,\n")
					.append("        P.package_count\n")
					.append("FROM haccp_package_inspection_list A\n")
					.append("INNER JOIN tbi_production_package_info P\n")
					.append("		ON A.member_key = P.member_key\n")
					.append("		AND A.order_no = P.order_no\n")
					.append("		AND A.lotno = P.lotno\n")
					.append("		AND A.prod_cd = P.prod_cd\n")
					.append("		AND A.prod_cd_rev = P.prod_cd_rev\n")
					.append("		AND A.package_no = P.package_no\n")
					.append("INNER JOIN vtbm_product B\n")
					.append("        ON A.prod_cd = B.prod_cd\n")
					.append("        AND A.prod_cd_rev = B.revision_no\n")
					.append("        AND A.member_key = B.member_key\n")
					.append("INNER JOIN tbi_order O\n")
					.append("        ON A.order_no = O.order_no\n")
					.append("        AND A.prod_cd = O.prod_cd\n")
					.append("        AND A.lotno = O.lotno\n")
					.append("INNER JOIN tbm_customer C\n")
					.append("        ON O.cust_cd = C.cust_cd\n")
					.append("        AND O.cust_rev = C.revision_no\n")
					.append("LEFT OUTER JOIN tbi_prod_storage S\n")
					.append("        ON A.prod_cd = S.prod_cd\n")
					.append("        AND A.prod_cd_rev = S.prod_cd_rev\n")
					.append("        AND A.member_key = S.member_key\n")
					.append("WHERE A.member_key = '" + jArray.get("member_key") + "' \n")
					.append("AND A.order_no = '" + jArray.get("order_no") + "' \n")
					.append("AND A.lotno = '" + jArray.get("lotno") + "' \n")
					.append("AND A.prod_cd = '" + jArray.get("prod_cd") + "' \n")
					.append("AND A.prod_cd_rev = '" + jArray.get("prod_cd_rev") + "' \n")
					.append("LIMIT " + jArray.get("page_start") + "," + jArray.get("page_end") + " \n")
					.toString();

			String ActionCommand = ioParam.getActionCommand();
			if (ActionCommand.startsWith("doQueryTableFieldName")) {
				resultString = super.excuteQueryStringTableFieldName(con, sql.toString());
			} else {
				;
				resultString = super.excuteQueryString(con, sql.toString());
			}
		} catch (Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M303S060700E764()", "==== SQL ERROR ====" + e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR;
		} finally {
			if (Config.useDataSource) {
				try {
					if (con != null)
						con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M303S060700E764()","==== finally ===="+ e.getMessage());
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
	
	// 생산실적등록 데이터 뿌리기
	public int E794(InoutParameter ioParam) { //
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		try {
			con = JDBCConnectionPool.getConnection();
			
			// 클라이언트로 부터 받은 파라미터를 옮겨 담는다.
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			System.out.println("JSONObject jArray rcvData="+ jArray.toString());
			
			
			String sql = new StringBuilder()
					.append("WITH aa AS (\n")
					.append("SELECT\n")
					.append("        P.package_count,\n")
					.append("        A.package_no\n")
					.append("FROM haccp_package_inspection_list A\n")
					.append("INNER JOIN tbi_production_package_info P\n")
					.append("                ON A.member_key = P.member_key\n")
					.append("                AND A.order_no = P.order_no\n")
					.append("                AND A.lotno = P.lotno\n")
					.append("                AND A.prod_cd = P.prod_cd\n")
					.append("                AND A.prod_cd_rev = P.prod_cd_rev\n")
					.append("                AND A.package_no = P.package_no\n")
					.append("INNER JOIN vtbm_product B\n")
					.append("        ON A.prod_cd = B.prod_cd\n")
					.append("        AND A.prod_cd_rev = B.revision_no\n")
					.append("        AND A.member_key = B.member_key\n")
					.append("INNER JOIN tbi_order O\n")
					.append("        ON A.order_no = O.order_no\n")
					.append("        AND A.prod_cd = O.prod_cd\n")
					.append("        AND A.lotno = O.lotno\n")
					.append("INNER JOIN tbm_customer C\n")
					.append("        ON O.cust_cd = C.cust_cd\n")
					.append("        AND O.cust_rev = C.revision_no\n")
					.append("LEFT OUTER JOIN tbi_prod_storage S\n")
					.append("        ON A.prod_cd = S.prod_cd\n")
					.append("        AND A.prod_cd_rev = S.prod_cd_rev\n")
					.append("        AND A.member_key = S.member_key\n")
					.append("WHERE A.member_key = '" + jArray.get("member_key") + "' \n")
					.append("AND A.order_no = '" + jArray.get("order_no") + "' \n")
					.append("AND A.lotno = '" + jArray.get("lotno") + "' \n")
					.append("AND A.prod_cd = '" + jArray.get("prod_cd") + "' \n")
					.append("AND A.prod_cd_rev = '" + jArray.get("prod_cd_rev") + "' \n")
					.append("LIMIT " + jArray.get("page_start") + "," + jArray.get("page_end") + " \n")
					.append(")\n")
					.append("SELECT DISTINCT\n")
					.append("         package_count\n")
					.append("FROM aa\n")
					.append("GROUP BY package_no\n")
					.append(";\n")
					.toString();

			
			String ActionCommand = ioParam.getActionCommand();
			if (ActionCommand.startsWith("doQueryTableFieldName")) {
				resultString = super.excuteQueryStringTableFieldName(con, sql.toString());
			} else {
				;
				resultString = super.excuteQueryString(con, sql.toString());
			}
		} catch (Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M303S060700E794()", "==== SQL ERROR ====" + e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR;
		} finally {
			if (Config.useDataSource) {
				try {
					if (con != null)
						con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M303S060700E794()","==== finally ===="+ e.getMessage());
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

	// 생산실적등록 데이터 뿌리기
	public int E774(InoutParameter ioParam) { //
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		try {
			con = JDBCConnectionPool.getConnection();
			
			// 클라이언트로 부터 받은 파라미터를 옮겨 담는다.
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			System.out.println("JSONObject jArray rcvData="+ jArray.toString());
			
			String sql = new StringBuilder()
					.append("SELECT \n")
					.append("	package_no,\n")
					.append("	package_checktime,\n")
					.append("	package_weight,\n")
					.append("	inbox_barcode_no,\n")
					.append("	inbox_expiration_date,\n")
					.append("	outbox_barcode_no,\n")
					.append("	outbox_expiration_date,\n")
					.append("	prod_cd,\n")
					.append("	prod_cd_rev,\n")
					.append("	member_key\n")
					.append("FROM \n")
					.append("	haccp_package_inspection_list\n")
					.append("WHERE member_key = '" + jArray.get("member_key") + "' \n")
					.append("AND order_no = '" + jArray.get("order_no") + "' \n")
					.append("AND lotno = '" + jArray.get("lotno") + "' \n")
					.append("AND prod_cd = '" + jArray.get("prod_cd") + "' \n")
					.append("AND prod_cd_rev = '" + jArray.get("prod_cd_rev") + "' \n")
					.append("LIMIT " + jArray.get("page_start") + "," + jArray.get("page_end") + " \n")
					
					.toString();

			String ActionCommand = ioParam.getActionCommand();
			if (ActionCommand.startsWith("doQueryTableFieldName")) {
				resultString = super.excuteQueryStringTableFieldName(con, sql.toString());
			} else {
				;
				resultString = super.excuteQueryString(con, sql.toString());
			}
		} catch (Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M303S060700E774()", "==== SQL ERROR ====" + e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR;
		} finally {
			if (Config.useDataSource) {
				try {
					if (con != null)
						con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M303S060700E774()","==== finally ===="+ e.getMessage());
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
	
	// 생산실적등록 데이터 뿌리기
	public int E784(InoutParameter ioParam) { //
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		try {
			con = JDBCConnectionPool.getConnection();
			
			// 클라이언트로 부터 받은 파라미터를 옮겨 담는다.
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			System.out.println("JSONObject jArray rcvData="+ jArray.toString());
			
			String sql = new StringBuilder()
					.append("WITH aa AS (\n")
					.append("SELECT \n")
					.append("	* \n")
					.append("FROM \n")
					.append("haccp_package_inspection_list\n")
					.append("WHERE member_key = '" + jArray.get("member_key") + "' \n")
					.append("AND order_no = '" + jArray.get("order_no") + "' \n")
					.append("AND lotno = '" + jArray.get("lotno") + "' \n")
					.append("AND prod_cd = '" + jArray.get("prod_cd") + "' \n")
					.append("AND prod_cd_rev = '" + jArray.get("prod_cd_rev") + "' \n")
					.append("LIMIT " + jArray.get("page_start") + "," + jArray.get("page_end") + " \n")
					.append(")\n")
					.append("SELECT DISTINCT\n")
					.append("        package_no\n")
					.append("FROM aa\n")
					.append("GROUP BY package_no\n")
					.toString();

			String ActionCommand = ioParam.getActionCommand();
			if (ActionCommand.startsWith("doQueryTableFieldName")) {
				resultString = super.excuteQueryStringTableFieldName(con, sql.toString());
			} else {
				;
				resultString = super.excuteQueryString(con, sql.toString());
			}
		} catch (Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M303S060700E784()", "==== SQL ERROR ====" + e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR;
		} finally {
			if (Config.useDataSource) {
				try {
					if (con != null)
						con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M303S060700E784()","==== finally ===="+ e.getMessage());
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
	// 생산실적등록 데이터 뿌리기
	public int E804(InoutParameter ioParam) { //
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		try {
			con = JDBCConnectionPool.getConnection();
			
			// 클라이언트로 부터 받은 파라미터를 옮겨 담는다.
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			System.out.println("JSONObject jArray rcvData="+ jArray.toString());
			
			String sql = new StringBuilder()
					.append("WITH aa AS (\n")
					.append("SELECT \n")
					.append("	* \n")
					.append("FROM \n")
					.append("haccp_package_inspection_list\n")
					.append("WHERE member_key = '" + jArray.get("member_key") + "' \n")
					.append("AND order_no = '" + jArray.get("order_no") + "' \n")
					.append("AND lotno = '" + jArray.get("lotno") + "' \n")
					.append("AND prod_cd = '" + jArray.get("prod_cd") + "' \n")
					.append("AND prod_cd_rev = '" + jArray.get("prod_cd_rev") + "' \n")
					.append("LIMIT " + jArray.get("page_start") + "," + jArray.get("page_end") + " \n")
					.append(")\n")
					.append("SELECT\n")
					.append("        COUNT(*)\n")
					.append("FROM aa\n")
					.append("WHERE package_no = '" + jArray.get("package_no") + "' \n")
					.toString();

			String ActionCommand = ioParam.getActionCommand();
			if (ActionCommand.startsWith("doQueryTableFieldName")) {
				resultString = super.excuteQueryStringTableFieldName(con, sql.toString());
			} else {
				;
				resultString = super.excuteQueryString(con, sql.toString());
			}
		} catch (Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M303S060700E804()", "==== SQL ERROR ====" + e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR;
		} finally {
			if (Config.useDataSource) {
				try {
					if (con != null)
						con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M303S060700E804()","==== finally ===="+ e.getMessage());
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