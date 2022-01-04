package mes.frame.business.M303;

import java.lang.reflect.Method;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.util.Vector;

import org.json.simple.JSONObject;

import mes.client.conf.Config;
import mes.frame.common.EventDefine;
import mes.frame.common.HashObject;
import mes.frame.common.MessageDefine;
import mes.frame.database.JDBCConnectionPool;
import mes.frame.database.SqlAdapter;
import mes.frame.serviceinterface.InoutParameter;
import mes.frame.serviceinterface.LoggingWriter;
import mes.frame.util.ComBaljuUpdate;
import mes.frame.util.CommonFunction;


/**
 * 개요 : 이벤트ID별 메소드 정의
 */
public  class M303S060100 extends SqlAdapter{
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
	
	public M303S060100(){
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
			
			Method method = M303S060100.class.getMethod(event,optClass);
			LoggingWriter.setLogDebug(M303S060100.class.getName(),"==== " + event + " EventMethod Create Success ====");

			obj = method.invoke(M303S060100.class.newInstance(),optObj);
			doExcute_result = CommonFunction.getInt(obj.toString());
			
	    } catch (Exception ex) {
	    	doExcute_result = EventDefine.E_DOEXCUTE_INIT;
			ioParam.setMessage(MessageDefine.M_NO_EVENTID);
			LoggingWriter.setLogError(M303S060100.class.getName(),"==== EventID Not define : EVENT ID [ " + ioParam.getEventID() + "]");
	    } finally {
	    	obj = null;
			optClass = null;
			optObj = null;
	    }
	    long endTime = System.currentTimeMillis();
		long runningTime = endTime - startTime;
		LoggingWriter.setLogAll(M303S060100.class.getName(),"==== Query [수행시간  : " + runningTime + " ms]");
		
		return doExcute_result;
	}
	//===================================================================================
	// 해당 클래스 자체를 사용하지 않음
	//===================================================================================	
	
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
					.append("	E.order_no,\n")
					.append("	E.lotno,\n")	// .append("	E.order_detail_seq,\n")
					.append("	O.project_name,\n")
					.append("	C.cust_nm,\n")
					.append("	PD.product_nm || '('||G.code_name  ||','||  H.code_name ||')',	\n")
					.append("	proc_plan_no,\n")
					.append("	proc_exec_no,\n")
					.append("	proc_info_no,\n")
					.append("	E.proc_cd,\n")
					.append("	E.proc_cd_rev,\n")
					.append("	PC.process_nm,\n")
					.append("	proc_odr,\n")
					.append("	E.product_serial_no,\n")
					.append("	rout_dt,\n")
					.append("	start_dt,\n")
					.append("	finish_dt,\n")
					.append("	inspect_yn,\n")
					.append("	inspect_request_yn,\n")
					.append("	exec_qnt,\n")
					.append("	man_amt,\n")
					.append("	delay_yn,\n")
					.append("	delay_dt_num,\n")
					.append("	delay_reason_cd,\n")
					.append("	D.code_name,\n")
					.append("	exec_note\n")
					.append("FROM\n")
					.append("	tbi_production_exec_log E\n")
					.append("INNER JOIN tbi_order O\n")
					.append("	ON E.order_no=O.order_no\n")
					.append("	AND E.lotno=O.lotno\n")
					.append("	AND E.member_key=O.member_key\n")
					.append("INNER JOIN tbm_product PD\n")
					.append("	ON O.prod_cd=PD.prod_cd\n")
					.append("	AND O.prod_rev=PD.revision_no\n")
					.append("	AND O.member_key=PD.member_key\n")
					.append("INNER JOIN tbm_process PC\n")
					.append("	ON E.proc_cd=PC.proc_cd\n")
					.append("	AND E.proc_cd_rev=PC.revision_no\n")
					.append("	AND E.member_key=PC.member_key\n")
					.append("INNER JOIN tbm_customer C\n")
					.append("	ON O.cust_cd=C.cust_cd\n")
					.append("	AND O.cust_rev=C.revision_no\n")
					.append("	AND O.member_key=C.member_key\n")
					.append("LEFT OUTER JOIN v_delay_reason D\n")
					.append("	ON E.delay_reason_cd=D.code_value\n")
					.append("	AND E.member_key=D.member_key\n")					
					.append("INNER JOIN v_prodgubun_big G			\n")
					.append("ON PD.prod_gubun_b 	= G.code_value 	\n")
					.append(" AND PD.member_key 	= G.member_key	\n")
					.append("INNER JOIN v_prodgubun_mid H			\n")
					.append("ON PD.prod_gubun_m	= H.code_value		\n")
					.append("AND PD.member_key 	= H.member_key		\n")					
					.append("WHERE rout_dt \n")
					.append("BETWEEN '" + jArray.get("fromdate") + "' 	\n")
					.append("	 AND '" + jArray.get("todate") + "'	\n")
					.append("AND E.member_key = '" + jArray.get("member_key") + "'	\n")
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
			LoggingWriter.setLogError("M303S060100E104()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M303S060100E104()","==== finally ===="+ e.getMessage());
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
	
//
	//M03S17100CheckPanelE001 "등록" MenuClass Create
	public int E001(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		try {
			con = JDBCConnectionPool.getConnection();
			// 클라이언트로 부터 받은 파라미터를 옮겨 담는다.
			String rcvData = (String)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			// 클라이언트로 부터 받은 파라미터를 쪼개어서 배열에 담는다.
			String[][] c_paramArray = CommonFunction.getConvString2DoubleArray(rcvData);
			String sql = new StringBuilder()
					.append("INSERT INTO	\n")
					.append("	tbi_import_inspect_checklist ( \n")
					.append("		part_cd,		\n")
					.append("		checklist_cd,	\n")
					.append("		item_cd,		\n")
					.append("		start_dt,		\n")
					.append("		set_dt			\n")
					.append("	) VALUES \n")
					.append("	(	'"	+ c_paramArray[0][0] + "' , 	\n")
					.append("		'"	+ c_paramArray[0][1] + "' , 	\n")
					.append("		'"	+ c_paramArray[0][2] + "' ,	\n")
					.append("		SYSDATETIME,	\n")
					.append("		SYSDATETIME	\n")
					.append(") \n")
					.toString();
			
			resultInt = super.excuteUpdate(con, sql.toString());
			if (resultInt < 0) {
				ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
				return EventDefine.E_DOEXCUTE_ERROR ;
			}
			
		} catch(Exception e) {
			LoggingWriter.setLogError("M303S060100E001", "==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M303S060100E001()","==== finally ===="+ e.getMessage());
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
//
	//M03S17010 저장 Button사용
	public int E101(InoutParameter ioParam){ 
		resultInt = EventDefine.E_DOEXCUTE_INIT;

		int listCnt=0, nextStatuscnt=0;
		try {
			con = JDBCConnectionPool.getConnection();
			String[][] c_paramArray_Head=null;
			
			String[][] c_paramArray_Detail=null;
			String rcvData = (String)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			Vector resultVector = CommonFunction.getConvStringDamogjuk(rcvData);
			con.setAutoCommit(false);
			
			c_paramArray_Head = (String[][])resultVector.get(0);//head table
    		c_paramArray_Detail=(String[][])resultVector.get(1); //data table
    		
			//import_inspect_seq 채번
			String sql = new StringBuilder()
					.append("		SELECT NVL(MAX(import_inspect_seq),0)+1 FROM tbi_import_inspect_result \n")
					.append("		where balju_no	= '" 	+ c_paramArray_Head[0][1] + "'  \n")
					.append(" 		and part_cd 	= '" 	+ c_paramArray_Head[0][2] + "'  \n")
					.append(" 		and BALJU_REQ_DATE	= TO_DATE('" + c_paramArray_Head[0][0] + "')  \n")
			.toString();
			String import_inspect_seq = super.excuteQueryString(con, sql.toString());
			
			if (E301(c_paramArray_Head,0,import_inspect_seq) < 0) {  //
				ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
				con.rollback();
				return EventDefine.E_DOEXCUTE_ERROR ;
			}
			
	    	for(int i=0; i<c_paramArray_Detail.length; i++) {    	    	
	    		if (E311(c_paramArray_Detail,i,import_inspect_seq) < 0) {  //
					ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
					con.rollback();
					return EventDefine.E_DOEXCUTE_ERROR ;
				}
	    	}
	    	
	    	if(E001_TBI_BALJU_list_Update(c_paramArray_Head) < 0){  //
				ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
				con.rollback();
				return EventDefine.E_DOEXCUTE_ERROR ;
			}
			
			//전체 발주리스트 Count
			 sql = new StringBuilder()
					.append("SELECT COUNT(*)\n")
					.append("FROM tbi_balju_list\n")
					.append("where BALJU_REQ_DATE = '" 	+ c_paramArray_Head[0][0] + "' \n")
					.append("        and BALJU_NO = '"  + c_paramArray_Head[0][1] + "' \n")
					.toString();
				// System.out.println(sql.toString());
			 listCnt = Integer.parseInt(super.excuteQueryString(con, sql.toString()).trim());
			
			//GV_NEXT_STATUS Count(수입검사완료 상태)
			 sql = new StringBuilder()
						.append("SELECT COUNT(*)\n")
						.append("FROM tbi_balju_list\n")
						.append("where BALJU_REQ_DATE = '" 	+ c_paramArray_Head[0][0] + "' \n")
						.append("  and BALJU_NO 	= '"	+ c_paramArray_Head[0][1] + "' \n")
						.append("  and balju_status = '" 	+ c_paramArray_Head[0][6] + "' \n")
						.toString();
				// System.out.println(sql.toString());
			 nextStatuscnt = Integer.parseInt(super.excuteQueryString(con, sql.toString()).trim());
			 
	    	if(listCnt==nextStatuscnt) {
		    	if(E001_TBI_BALJU_Update(c_paramArray_Head) < 0){  //
					ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
					con.rollback();
					return EventDefine.E_DOEXCUTE_ERROR ;
				}
	    	}
	    	
			con.commit();
			
		} catch(Exception e) {
			LoggingWriter.setLogError("M303S060100E101()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M303S060100E101()","==== finally ===="+ e.getMessage());
				}
	    	} else {
	    	}
	    }
		ioParam.setResultString(resultString);
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
    	ioParam.setMessage(MessageDefine.M_QUERY_OK);
	    return EventDefine.E_QUERY_RESULT;
	}	

	public int E001_TBI_BALJU_list_Update(String[][] c_paramArray){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		try {
	
			sql = new StringBuffer();
			sql.append(" update tbi_balju_list set	\n");
			sql.append("   BALJU_STATUS =  '" + c_paramArray[0][6] + "'  \n");
			sql.append("where BALJU_REQ_DATE  = '" + c_paramArray[0][0] + "'  \n");
			sql.append(" 	and BALJU_NO = '" + c_paramArray[0][1] + "'		\n");
			sql.append(" 	and part_cd  = '" + c_paramArray[0][2] + "'		\n");
			// System.out.println(sql.toString());
			resultInt = super.excuteUpdate(con, sql.toString());
			
		} catch(Exception e) {
			LoggingWriter.setLogError("M02S07000E001_TBI_BALJU_list_Update()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } 
	    return resultInt;
	}
	
	public int E001_TBI_BALJU_Update(String[][] c_paramArray){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
	
			sql = new StringBuffer();
			sql.append(" update tbi_balju set	\n");
			sql.append("   BALJU_STATUS = '"	+ c_paramArray[0][6] + "'  \n");
			sql.append("where BALJU_REQ_DATE = '" + c_paramArray[0][0] + "'  \n");
			sql.append("  and BALJU_NO = '" 	+ c_paramArray[0][1] + "' \n");
			// System.out.println(sql.toString());
			resultInt = super.excuteUpdate(con, sql.toString());
			
		} catch(Exception e) {
			LoggingWriter.setLogError("M303S17000E001_TBI_BALJU_Update()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } 
	    return resultInt;
	}	
	
	public int E301(String[][] c_paramArray,int i,String import_inspect_seq){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		try {
			
			String sql = new StringBuilder()
					.append("INSERT INTO\n")
					.append("	tbi_import_inspect_result (\n")
					.append("		BALJU_REQ_DATE,			\n")
					.append("		balju_no,			\n")
					.append("		part_cd,			\n")
					.append("		import_inspect_seq,	\n")
					.append("		import_inspect_dt,	\n")
					.append("		user_id,			\n")
					.append("		sample_cnt,		\n")
					.append("		error_cnt,			\n")
					.append("		bigo 				\n")
					.append("	)\n")
					.append("VALUES( \n")
					.append(" 	'"	+ c_paramArray[i][0] + "',	 \n")//BALJU_REQ_DATE
					.append("	'"	+ c_paramArray[i][1] + "',	 \n")//balju_no
					.append("	'"	+ c_paramArray[i][2] + "',	 \n")//part_cd
					.append("	" 	+ import_inspect_seq +  ",  \n")
					.append("		SYSDATETIME, \n")				//import_inspect_dt
					.append("	'"	+ c_paramArray[i][3] + "',	\n")//user_id
					.append("	'"	+ c_paramArray[i][4] + "',	\n")//sample_cnt
					.append("	0,	\n")//error_cnt
					.append("		' ') \n")						//bigo
					.toString();
					
			
			// System.out.println(sql.toString());
			
			resultInt = super.excuteUpdate(con, sql.toString());
			
		} catch(Exception e) {
			LoggingWriter.setLogError("M303S17000E301", "==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } 
	    return resultInt;
	}
	
	public int E311(String[][] c_paramArray,int i ,String import_inspect_seq){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		try {		
			String sql = new StringBuilder()
					.append("INSERT INTO\n")
					.append("	tbi_import_inspect_result_dt (\n")
					.append("		balju_no,			\n")
					.append("		part_cd,			\n")
					.append("		BALJU_REQ_DATE,			\n")
					.append("		import_inspect_seq,	\n")
					.append("		import_inspect_dt,	\n")
					.append("		checklist_cd,		\n")
					.append("		item_cd,			\n")
					.append("		error_cnt,	\n")
					.append("		inspect_result	\n")
					.append("	)\n")
					.append("VALUES( \n")
					//    	발주일자","발주번호", "검사일자", "발주수량", "검수수량","단위코드", "원부자재명", "확인내용" ,"확인",  "불량수량",
//						"원부자재코드", "문항코드","항목코드", "문항내용", "확인내용"	,LOGIN_ID
					.append("	'"	+ c_paramArray[i][1] + "',	 \n")//balju_no
					.append("	'"	+ c_paramArray[i][10] + "',	 \n")//part_cd
					.append("   '"	+ c_paramArray[i][0] + "',	 \n")//BALJU_REQ_DATE
					.append("	" 	+ import_inspect_seq  +  ",  \n")
					.append("		SYSDATETIME, \n")				//import_inspect_dt
					.append("	'"	+ c_paramArray[i][11] + "',	\n")//checklist_cd
					.append("	'"	+ c_paramArray[i][12] + "',	\n")//item_cd
					.append("	'"	+ c_paramArray[i][9] + "',	\n")//error_cnt
					.toString();
					if(c_paramArray[i][8].equals("true"))
						sql += "	'Y' ";
					else
						sql += "	'N'	 ";  //inspect_result
					sql += "	)";
			
			// System.out.println(sql.toString());
			
			resultInt = super.excuteUpdate(con, sql.toString());
			
			
		} catch(Exception e) {
			LoggingWriter.setLogError("M303S17000E311", "==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } 
	    return resultInt;
	}


	public int E102(InoutParameter ioParam){ 
		resultInt = EventDefine.E_DOEXCUTE_INIT;

		int listCnt=0, nextStatuscnt=0;
		try {
			con = JDBCConnectionPool.getConnection();
			String[][] c_paramArray_Head=null;
			
			String[][] c_paramArray_Detail=null;
			String rcvData = (String)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			Vector resultVector = CommonFunction.getConvStringDamogjuk(rcvData);
			con.setAutoCommit(false);
			
			c_paramArray_Head = (String[][])resultVector.get(0);//head table
			
			if (E102_tbi_import_inspect_result_Update(c_paramArray_Head) < 0) {  //
				ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
				con.rollback();
				return EventDefine.E_DOEXCUTE_ERROR ;
			}
    		c_paramArray_Detail=(String[][])resultVector.get(1); //data table
	    	for(int i=0; i<c_paramArray_Detail.length; i++) {    	    	
	    		if (E102_tbi_import_inspect_result_dt_Update(c_paramArray_Detail,i) < 0) {  //
					ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
					con.rollback();
					return EventDefine.E_DOEXCUTE_ERROR ;
				}
	    	}    	
	    	

	    	if(E001_TBI_BALJU_list_Update(c_paramArray_Head) < 0){  //
				ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
				con.rollback();
				return EventDefine.E_DOEXCUTE_ERROR ;
			}
			
			//전체 발주리스트 Count
			String sql = new StringBuilder()
					.append("SELECT COUNT(*)\n")
					.append("FROM tbi_balju_list\n")
					.append("where BALJU_REQ_DATE = '" 	+ c_paramArray_Head[0][0] + "' \n")
					.append("        and BALJU_NO = '"  + c_paramArray_Head[0][1] + "' \n")
					.toString();
				// System.out.println(sql.toString());
			 listCnt = Integer.parseInt(super.excuteQueryString(con, sql.toString()).trim());
			
			//GV_NEXT_STATUS Count(수입검사확인완료 상태)
			 sql = new StringBuilder()
						.append("SELECT COUNT(*)\n")
						.append("FROM tbi_balju_list\n")
						.append("where BALJU_REQ_DATE = '" 	+ c_paramArray_Head[0][0] + "' \n")
						.append("  and BALJU_NO 	= '"	+ c_paramArray_Head[0][1] + "' \n")
						.append("  and balju_status = '" 	+ c_paramArray_Head[0][6] + "' \n")
						.toString();
				// System.out.println(sql.toString());
			 nextStatuscnt = Integer.parseInt(super.excuteQueryString(con, sql.toString()).trim());
			 
	    	if(listCnt==nextStatuscnt) {
		    	if(E001_TBI_BALJU_Update(c_paramArray_Head) < 0){  //
					ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
					con.rollback();
					return EventDefine.E_DOEXCUTE_ERROR ;
				}
	    	}
	    	
			con.commit();
			
		} catch(Exception e) {
			LoggingWriter.setLogError("M303S060100E102()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M303S060100E102()","==== finally ===="+ e.getMessage());
				}
	    	} else {
	    	}
	    }
		ioParam.setResultString(resultString);
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
    	ioParam.setMessage(MessageDefine.M_QUERY_OK);
	    return EventDefine.E_QUERY_RESULT;
	}	
	

	public int E102_tbi_import_inspect_result_Update(String[][] c_paramArray){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			
			sql = new StringBuffer();
			sql.append(" update tbi_import_inspect_result set 				\n");
			sql.append("   error_cnt 		= '" + c_paramArray[0][7] + "'			\n");
			sql.append("where BALJU_REQ_DATE= '" + c_paramArray[0][0] + "'  \n");
			sql.append("  and BALJU_NO 		= '" + c_paramArray[0][1] + "' 	\n");
			sql.append("  and part_cd 		= '" + c_paramArray[0][2] + "' 		\n");
			// System.out.println(sql.toString());
			resultInt = super.excuteUpdate(con, sql.toString());
			
		} catch(Exception e) {
			LoggingWriter.setLogError("M02S07000E102_tbi_import_inspect_result_Update()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } 
	    return resultInt;
	}

	public int E102_tbi_import_inspect_result_dt_Update(String[][] c_paramArray, int i){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			sql = new StringBuffer();
			sql.append(" update tbi_import_inspect_result_dt set	\n");

			if(c_paramArray[i][8].equals("true"))
				sql.append("   inspect_result = 'Y'		\n");
			else
				sql.append("   inspect_result = 'N'		\n");

			sql.append("  , error_cnt = '" + c_paramArray[i][9] + "'					\n");
			sql.append("where BALJU_REQ_DATE  	= '" 	+ c_paramArray[i][0] + "'  		\n");
			sql.append(" 	and BALJU_NO = '" 	+ c_paramArray[i][1] + "' 			\n");
			sql.append(" 	and part_cd = '" 	+ c_paramArray[i][10] + "' 			\n");
			sql.append(" 	and import_inspect_seq = '" + c_paramArray[i][15] + "'	\n");
			sql.append(" 	and TO_CHAR(import_inspect_dt,'YYYY-MM-DD HH24:MI:SS') = '" + c_paramArray[i][2] + "'	\n");
			sql.append(" 	and checklist_cd = '" 	+ c_paramArray[i][11] + "' 		\n");
			sql.append(" 	and item_cd = '" 		+ c_paramArray[i][12] + "'		\n");
			// System.out.println(sql.toString());
			resultInt = super.excuteUpdate(con, sql.toString());
//	    	{"발주일자","발주번호", "검사일자", "발주수량", "검수수량","단위코드", "원부자재명", "확인내용" ,"확인",  "불량수량",
//				"원부자재코드", "문항코드","항목코드", "문항내용", "확인내용","검사번호"	+= Session.LOGIN_ID + "|";
		} catch(Exception e) {
			LoggingWriter.setLogError("M02S17000E102_tbi_import_inspect_result_dt_Update()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } 
	    return resultInt;
	}

	////M03S17100CheckPanel 삭제버튼
	public int E003(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		try {
			con = JDBCConnectionPool.getConnection();
			// 클라이언트로 부터 받은 파라미터를 옮겨 담는다.
			String rcvData = (String)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			// 클라이언트로 부터 받은 파라미터를 쪼개어서 배열에 담는다.
			String[][] c_paramArray = CommonFunction.getConvString2DoubleArray(rcvData);

			String sql = new StringBuilder()
					.append("DELETE FROM					\n")
					.append("	tbi_import_inspect_checklist 	\n")
					.append("	where part_cd 			= '" + c_paramArray[0][0] + "'  \n")
					.append(" 	and checklist_cd	= '" + c_paramArray[0][1] + "'  \n")
					.append(" 	and item_cd 		= '" + c_paramArray[0][2] + "'  \n")
					.toString();
			
			// System.out.println(sql.toString());
			// super의 excuteUpdate는 3가지가 있다.
			// 첫째는 super.excuteUpdate(con, sql.toString(), v_paramArray)형태 이며,
			// PreparedStatement를 사용하기 위해 파라미터들을 배열에 담아 보내면 체크를 해서 수행하는 구조이다. 그리고
			// 두번째는 super.excuteUpdate(con, Vector)인데, 멀티 로우를 등록하기 위해 마련된 장치이다.
			// 세번째는 하나의 SQL을 String으로 받아서 처리하는 경우이다.
			// 현재 위의 SQL형태라면.. 당연히 1개의 로우에 해당되므로 세번째 메쏘드를 사용하는 것이 편하다.
			
			resultInt = super.excuteUpdate(con, sql.toString());
			if (resultInt < 0) {
				ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
				return EventDefine.E_DOEXCUTE_ERROR ;
			}
			
		} catch(Exception e) {
			LoggingWriter.setLogError("M303S060100E003", "==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M303S060100E003()","==== finally ===="+ e.getMessage());
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

	
	
	//Client: M03S17000CheckPanel 원부자재별체크리스트
	public int E014(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			// 클라이언트로 부터 받은 파라미터를 옮겨 담는다.
			String rcvData = (String)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			// 클라이언트로 부터 받은 파라미터를 쪼개어서 배열에 담는다.
			String[][] c_paramArray = CommonFunction.getConvString2DoubleArray(rcvData);

			String sql = new StringBuilder()
					.append("SELECT	\n")
					.append(	"	a.part_cd,			--원부자재코드\n")
					.append(	"	b.part_nm,		\n")
					.append("		a.checklist_cd, 	--체크문항코드\n")
					.append(	"	c.check_note,	\n")
					.append(	"	a.item_cd,		--체크항목코드\n")
					.append("		d.item_desc,		\n")
					.append("		a.start_dt,			--적용일\n")
					.append("		a.set_dt			--생성일\n")
					.append("FROM\n")
					.append("		tbi_import_inspect_checklist A, tb_partlist B,	\n")
					.append("		tbm_checklist C, tbm_check_item D	\n")
					.append("WHERE 1=1	\n")
					.append("AND a.part_cd 		= b.part_cd		\n")
					.append("AND a.checklist_cd = c.checklist_cd	\n")
					.append("AND a.item_cd 		= c.item_cd		\n")
					.append("AND a.item_cd 		= d.item_cd		\n")
			        .append("AND A.part_cd		= '" + c_paramArray[0][0] + "'	\n")
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
			LoggingWriter.setLogError("M303S060100E014()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M303S060100E014()","==== finally ===="+ e.getMessage());
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
	
	//Client: M03S17300 원부자재발주정보
		public int E024(InoutParameter ioParam){ //
			resultInt = EventDefine.E_DOEXCUTE_INIT;
			try {
				con = JDBCConnectionPool.getConnection();
				
				// 클라이언트로 부터 받은 파라미터를 옮겨 담는다.
				String rcvData = (String)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
				// 클라이언트로 부터 받은 파라미터를 쪼개어서 배열에 담는다.
				String[][] c_paramArray = CommonFunction.getConvString2DoubleArray(rcvData);
				String sql = new StringBuilder()
						.append("SELECT    \n")
						.append("		B.order_no, 		--주문번호 	\n")
						.append("		A.balju_no, 		--발주번호 	\n")
						.append("		A.BALJU_REQ_DATE ,			--발주일자\n")
						.append("		g.cust_nm,			--원부자재업체명 \n")
						.append("		e.part_nm,			--원부자재명 		\n")
						.append("		A.balju_amt,		--발주수량 	\n")
						.append("		V.CODE_NAME,		--상태 \n")
						.append("		A.unit_cd	,		--단위 		\n")
						.append("		B.balju_delivery_date,		--입고예정일\n")
						.append("		B.cust_cd,			--원부자재업체코드 \n")
						.append("		A.part_cd,  		--원부자재번호 	\n")
						.append("		A.unit_cd	,		--단위코드 	\n")
						.append("		B.order_detail_seq, --주문상세\n")
						.append("		A.balju_status		-- 	\n")
						.append("FROM  \n")
						.append("		tbi_balju_list A,	tbi_balju B, 	\n")
						.append("		tb_partlist e,		vtbm_customer g, v_balju_status v \n")
						.append("WHERE 1=1	\n")
						.append("AND A.balju_no 	= b.balju_no \n")
						.append("AND A.BALJU_REQ_DATE		= b.BALJU_REQ_DATE \n")
						.append("AND A.part_cd 		= E.part_cd	\n")
						.append("AND A.balju_status = V.code_cd	\n")
						.append("AND b.cust_cd 		= g.cust_cd  \n")
						.append("AND a.balju_status = '" 	+ c_paramArray[0][0] + "' \n")
						.append("AND b.cust_cd  like '" 	+ c_paramArray[0][1] + "%' \n")
						.append("AND (B.BALJU_DELIVERY_DATE >= '" 	+ c_paramArray[0][2] + "' and B.BALJU_DELIVERY_DATE <= '" + c_paramArray[0][3] + "') \n")
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
				LoggingWriter.setLogError("M303S060100E024()","==== SQL ERROR ===="+ e.getMessage());
				return EventDefine.E_DOEXCUTE_ERROR ;
		    } finally {
		    	if (Config.useDataSource) {
					try {
						if (con != null) con.close();
					} catch (Exception e) {
						LoggingWriter.setLogError("M303S060100E024()","==== finally ===="+ e.getMessage());
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
	
	//Client: M303S17000 발주원부자재정보
	public int E114(InoutParameter ioParam){ //
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		try {
			con = JDBCConnectionPool.getConnection();
			
			// 클라이언트로 부터 받은 파라미터를 옮겨 담는다.
			String rcvData = (String)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			// 클라이언트로 부터 받은 파라미터를 쪼개어서 배열에 담는다.
			String[][] c_paramArray = CommonFunction.getConvString2DoubleArray(rcvData);
			String sql = new StringBuilder()
					.append("SELECT    \n")
					.append("		B.order_no, 		--주문번호 	\n")
					.append("		A.balju_no, 		--발주번호 	\n")
					.append("		A.BALJU_REQ_DATE ,			--발주일자\n")
					.append("		g.cust_nm,			--원부자재업체명 \n")
					.append("		e.part_nm,			--원부자재명 		\n")
					.append("		A.balju_amt,		--발주수량 	\n")
					.append("		V.CODE_NAME,		--상태 \n")
					.append("		A.unit_cd	,		--단위 		\n")
					.append("		B.balju_delivery_date,		--입고예정일\n")
					.append("		B.cust_cd,			--원부자재업체코드 \n")
					.append("		A.part_cd,  		--원부자재번호 	\n")
					.append("		A.unit_cd	,		--단위코드 	\n")
					.append("		B.order_detail_seq, --주문상세\n")
					.append("		A.balju_status		-- 	\n")
					.append("FROM  \n")
					.append("		tbi_balju_list A,	tbi_balju B, 	\n")
					.append("		tb_partlist e,		vtbm_customer g, v_balju_status v \n")
					.append("WHERE 1=1	\n")
					.append("AND A.balju_no 	= b.balju_no \n")
					.append("AND A.BALJU_REQ_DATE		= b.BALJU_REQ_DATE \n")
					.append("AND A.part_cd 		= E.part_cd	\n")
					.append("AND A.balju_status = V.code_cd	\n")
					.append("AND b.cust_cd 		= g.cust_cd  \n")
					.append("AND a.balju_status = '" 	+ c_paramArray[0][0] + "' \n")
					.append("AND b.cust_cd  like '" 	+ c_paramArray[0][1] + "%' \n")
					.append("AND (B.BALJU_DELIVERY_DATE >= '" 	+ c_paramArray[0][2] + "' and B.BALJU_DELIVERY_DATE <= '" + c_paramArray[0][3] + "') \n")
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
			LoggingWriter.setLogError("M303S060100E114()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M303S060100E114()","==== finally ===="+ e.getMessage());
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
	
	//Client: M303S17000 수입검사(Head)
		public int E124(InoutParameter ioParam){ //
			resultInt = EventDefine.E_DOEXCUTE_INIT;
			try {
				con = JDBCConnectionPool.getConnection();
				
				// 클라이언트로 부터 받은 파라미터를 옮겨 담는다.
				String rcvData = (String)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
				// 클라이언트로 부터 받은 파라미터를 쪼개어서 배열에 담는다.
				String[][] c_paramArray = CommonFunction.getConvString2DoubleArray(rcvData);
				String sql = new StringBuilder()
//				{"발주번호",  "발주요청일자","원부자재명", "원부자재업제명","발주수량", "수입검사수량", "불량수량","검사수행일","검사담당자","확인일자","확인자",   
//					"비고", "원부자재코드", "고객사코드", "검사번호","주문번호", "주문번호상세"};						
						.append("SELECT\n")
						.append("		A.balju_no,								--발주번호\n")
						.append("		A.BALJU_REQ_DATE,	--발주요청일자\n")
						.append("		F.part_nm,								--원부자재명\n")
						.append("		G.cust_nm,								--원부자재업제명\n")
						.append("		C.balju_amt,							--발주수량\n")
						.append("		A.sample_cnt,							--검사수량\n")
						.append("		A.error_cnt,							--불량수량\n")
						.append("		TO_CHAR(A.import_inspect_dt,'YYYY-MM-DD'),  --검사수행일\n")
						.append("		A.user_id,									--검사담당자\n")
						.append("		TO_CHAR(A.confirm_dt,'YYYY-MM-DD'),  		--검사수행일\n")
						.append("		A.confirm_user_id,							--검사담당자\n")
						.append("		A.bigo,				--비고\n")
						.append("		A.part_cd,			--원부자재코드\n")
						.append("		B.cust_cd,			--고객사코드\n")
						.append("		A.import_inspect_seq,--검사번호\n")
						.append("		B.order_no,			--주분번호\n")
						.append("		B.order_detail_seq	--주문번호상세\n")
						.append("FROM\n")
						.append("		tbi_import_inspect_result  A,	\n")
						.append("		tbi_balju B,			\n")
						.append("		tbi_balju_list C,	\n")
						.append("		tb_partlist F,		\n")
						.append("		vtbm_customer G		\n")
						.append("WHERE 1=1\n")
						.append("AND A.balju_no 	= b.balju_no			\n")
						.append("AND A.BALJU_REQ_DATE  	= B.BALJU_REQ_DATE	\n")
						.append("AND A.balju_no 	= C.balju_no			\n")
						.append("AND A.BALJU_REQ_DATE  	= C.BALJU_REQ_DATE	\n")
						.append("AND A.part_cd		= c.part_cd				\n")
						.append("AND A.part_cd 		= F.part_cd				\n")
						.append("AND B.cust_cd 		= G.cust_cd				\n")

						.append("AND A.balju_no  	= '" 	+ c_paramArray[0][0] + "'  \n")
						.append("AND A.BALJU_REQ_DATE  	= '" 	+ c_paramArray[0][1] + "'  \n")
						.append("AND A.part_cd  	= '" 	+ c_paramArray[0][2] + "'  \n")
//						.append("AND b.cust_cd  = '" 	+ c_paramArray[0][3] + "' \n")
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
				LoggingWriter.setLogError("M303S060100E124()","==== SQL ERROR ===="+ e.getMessage());
				return EventDefine.E_DOEXCUTE_ERROR ;
		    } finally {
		    	if (Config.useDataSource) {
					try {
						if (con != null) con.close();
					} catch (Exception e) {
						LoggingWriter.setLogError("M303S060100E124()","==== finally ===="+ e.getMessage());
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
		
	//Client: M03S17100CheckPanelE001 체크리스트
		public int E134(InoutParameter ioParam){ //
			resultInt = EventDefine.E_DOEXCUTE_INIT;
			try {
				con = JDBCConnectionPool.getConnection();
				
				// 클라이언트로 부터 받은 파라미터를 옮겨 담는다.
				String rcvData = (String)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
				// 클라이언트로 부터 받은 파라미터를 쪼개어서 배열에 담는다.
				String[][] c_paramArray = CommonFunction.getConvString2DoubleArray(rcvData);

				sql = new StringBuffer();		
				sql.append(" SELECT \n");
				sql.append(" 	CHECK_NOTE  \n");
				sql.append(" 	,CHECKLIST_CD \n");
				sql.append(" 	,CHECKLIST_SEQ \n");
				sql.append(" 	,item_desc \n");
				sql.append(" 	,A.item_cd \n");
				sql.append(" 	,C.code_name AS item_type_name \n");
				sql.append(" 	,item_type   \n"); 		//2
				sql.append(" 	,USE_YN   \n"); 		//2
				sql.append(" 	,START_DT	\n"); 		//4 
				sql.append(" 	,SET_DT	\n"); 			//3
				sql.append(" FROM 	 \n");
				sql.append(" 	TB_CHECKLIST A,  tbm_check_item B, tbm_code_book C \n");
				sql.append(" WHERE  A.item_cd 	= B.item_cd \n");  
				sql.append("    AND  B.item_type 	= C.CODE_VALUE \n");  
				sql.append("    AND  SUBSTR(C.code_cd, 1,4) = 'GCHK' \n"); 
				sql.append("    AND  A.item_cd IN ('F000001') \n"); 
	            sql.append("    AND  B.item_type 	like '%" + c_paramArray[0][0] + "%' \n");  
				sql.append(" ORDER BY CHECKLIST_CD \n");
				
				String ActionCommand = ioParam.getActionCommand();
				if(ActionCommand.startsWith("doQueryTableFieldName")) {
					resultString = super.excuteQueryStringTableFieldName(con, sql.toString());
				}
				else {;
					resultString = super.excuteQueryString(con, sql.toString());
				}
			} catch(Exception e) {
				e.printStackTrace();
				LoggingWriter.setLogError("M303S060100E134()","==== SQL ERROR ===="+ e.getMessage());
				return EventDefine.E_DOEXCUTE_ERROR ;
		    } finally {
		    	if (Config.useDataSource) {
					try {
						if (con != null) con.close();
					} catch (Exception e) {
						LoggingWriter.setLogError("M303S060100E134()","==== finally ===="+ e.getMessage());
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
	
		
		//Client: M303S17000 수입검사상세내역
			public int E144(InoutParameter ioParam){ //
				resultInt = EventDefine.E_DOEXCUTE_INIT;
				try {
					con = JDBCConnectionPool.getConnection();
					
					// 클라이언트로 부터 받은 파라미터를 옮겨 담는다.
					String rcvData = (String)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
					// 클라이언트로 부터 받은 파라미터를 쪼개어서 배열에 담는다.
					String[][] c_paramArray = CommonFunction.getConvString2DoubleArray(rcvData);
					String sql = new StringBuilder()
							.append("SELECT\n")
							.append("		TO_CHAR(A.import_inspect_dt,'YYYY-MM-DD HH24:MI:SS'),	--검사일자\n")
							.append("		D.check_note,			--문항내용\n")
							.append("		E.item_desc,			--항목명\n")
							.append("		A.inspect_result,		--검사결과\n")
							.append("		A.import_inspect_seq,	--검사번호\n")
							.append("		A.checklist_cd,			--문항코드\n")
							.append("		A.item_cd				--항목코드\n")
							.append("FROM\n")
							.append("		tbi_import_inspect_result_dt A,	\n")
							.append("		tbm_checklist D,	\n")
							.append("		tbm_check_item E \n")
							.append("WHERE 1=1	\n")
							.append("AND A.checklist_cd = D.checklist_cd	\n")
							.append("AND A.item_cd 		= D.item_cd	\n")
							.append("AND A.item_cd 		= E.item_cd	\n")
							.append("AND A.balju_no  	= '" 	+ c_paramArray[0][0] + "'  \n")
							.append("AND A.BALJU_REQ_DATE  	= '" 	+ c_paramArray[0][1] + "'  \n")
							.append("AND A.part_cd  	= '" 	+ c_paramArray[0][2] + "'  \n")
							.append("AND A.import_inspect_seq  	like '" + c_paramArray[0][3] + "%'  \n")
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
					LoggingWriter.setLogError("M303S060100E144()","==== SQL ERROR ===="+ e.getMessage());
					return EventDefine.E_DOEXCUTE_ERROR ;
			    } finally {
			    	if (Config.useDataSource) {
						try {
							if (con != null) con.close();
						} catch (Exception e) {
							LoggingWriter.setLogError("M303S060100E144()","==== finally ===="+ e.getMessage());
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
			
			// 클라이언트로 부터 받은 파라미터를 옮겨 담는다.
			String rcvData = (String)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			// 클라이언트로 부터 받은 파라미터를 쪼개어서 배열에 담는다.
			// rcvData = [위경도]
			String[][] c_paramArray = CommonFunction.getConvString2DoubleArray(rcvData);
//					strColumnBalju = {"접수일","발주요청자","고객","Project","납품계약일","실납품일","발주일자","발주업체","발주내용",
//								"발주담당자",  "진행상태","입고예정일", "BALJU_NO","REQ_USER", "CUST_CD","BALJU_UPCHE","USER_ID", "BALJU_STATUS" };
			String sql = new StringBuilder()
					.append("select    \n")
					.append("        A.BALJU_REQ_DATE AS BALJU_REQ_DATE,	--발주요청일    \n")
					.append("        E.USER_NM AS REQ_USER_NM,									--발주요청자    \n")
					.append("        D.CUST_NM as CUST_NM,				--주문고객    	\n")
					.append("        I.CODE_NAME AS PROJECT, 			--GIJONG_NM    	\n")
					.append("        A.CONTRACTUAL_DATE,				--납품계약일    \n")
					.append("        A.ACTUAL_DATE,						--최종납품일    \n")
					.append("        A.balju_date,						--발주일    	\n")
					.append("        G.USER_NM AS BALJU_USER_NM,		--발주담당자    \n")
					.append("        A.balju_confirm_date,				--발주확인일    \n")
					.append("        K.USER_NM AS BALJU_CONFIRM_USER_NM, --발주확인담당	\n")
					.append("        F.CUST_NM as CUST_NM,				--발주업체 명	\n")
					.append("        A.BALJU_TEXT,						--발주내용    	\n")
					.append("        v.CODE_NAME AS BALJU_STATUS_NAME,	--진행상태    	\n")
					.append("        to_char(A.balju_delivery_date, 'YYYY-MM-DD') as balju_delivery_date, --입고예정일    \n")
					.append("        a.balju_no,    \n")
					.append("        A.REQ_USER_ID,		\n")
					.append("        A.CUST_CD,			--주문고객		\n")
					.append("        A.BALJU_UPCHE_CD,	--발주업체코드	\n")
					.append("        A.balju_user_id,	--발주담당자	\n")
					.append("        A.MANAGER_USER_ID,	\n")
					.append("        A.BALJU_STATUS,    \n")
					.append("        A.ORDER_NO,    	\n")
					.append("		 A.ORDER_DETAIL_SEQ	\n")
					.append("   from    \n")
					.append("        TBI_BALJU A     \n")
					.append("        INNER JOIN 	tb_orderinfo_detail B    	\n")
					.append("        	ON  A.ORDER_NO = B.ORDER_NO     		\n")
					.append("        	AND A.ORDER_DETAIL_SEQ = B.ORDER_DETAIL_SEQ    \n")
					.append("        INNER JOIN 			tbm_product H    	\n")
					.append("        	ON B.PROD_CD = H.PROD_CD    			\n")
					.append("        INNER JOIN  	tbm_code_book I 	--기종명    \n")
					.append("        	ON H.GIJONG = I.CODE_CD    				\n")
					.append("        INNER JOIN  vtbm_customer D		--주문고객	\n")
					.append("        	ON A.CUST_CD = D.CUST_CD    			\n")
					.append("        INNER JOIN tbm_users E 			--요청담당	\n")
					.append("        	ON A.REQ_USER_ID = E.USER_ID    		\n")
					.append("        INNER JOIN vtbm_customer F		--발주고객	\n")
					.append("        	ON A.BALJU_UPCHE_CD = F.CUST_CD    		\n")
					.append("        left outer JOIN tbm_users G 	--발주담당	\n")
					.append("        	ON A.balju_user_id = G.USER_ID    		\n")
					.append("        left outer JOIN tbm_users K    				\n")
					.append("        	ON A.MANAGER_USER_ID = K.USER_ID	\n")
					.append("        INNER JOIN v_balju_status v    		\n")
					.append("        	ON BALJU_STATUS = V.CODE_CD			\n")
					.append("   where   1=1    								\n")
					.append("        and A.BALJU_REQ_DATE >= '" + c_paramArray[0][0] + "'    \n")
					.append("        and A.BALJU_REQ_DATE <= '" + c_paramArray[0][1] + "'    \n")
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
			LoggingWriter.setLogError("M303S060100E154()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M303S060100E154()","==== finally ===="+ e.getMessage());
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
	
	public int E202_TBI_BALJU_list_Status_Update(String[][] c_paramArray, String sPart_cd){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		try {
//			GV_BALJU_NO + "|" + GV_BALJU_REQ_DATE + "|" + GV_BALJU_STATUS + "|"
			sql = new StringBuffer();
			sql.append(" update tbi_balju_list set	\n");
			sql.append("   BALJU_STATUS 		= '" + c_paramArray[0][2] + "'   \n");
			sql.append("where BALJU_REQ_DATE  	= '" + c_paramArray[0][1] + "' 	\n");
			sql.append(" 	and BALJU_NO 		= '" + c_paramArray[0][0] + "'		\n");
			sql.append(" 	and part_cd  		= '" + sPart_cd + "'				\n");
			// System.out.println(sql.toString());
			resultInt = super.excuteUpdate(con, sql.toString());
			
		} catch(Exception e) {
			LoggingWriter.setLogError("M303S17000E202_TBI_BALJU_list_Status_Update()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } 
	    return resultInt;
	}
	
	public int E202_TBI_BALJU_Status_Update(String[][] c_paramArray){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
	
			sql = new StringBuffer();
			sql.append(" update tbi_balju set					\n");
			sql.append("   BALJU_STATUS = '"	+ c_paramArray[0][2] + "'  \n");
			sql.append("where BALJU_REQ_DATE = '" + c_paramArray[0][1] + "'  \n");
			sql.append("  and BALJU_NO = '" 	+ c_paramArray[0][0] + "' \n");
			// System.out.println(sql.toString());
			resultInt = super.excuteUpdate(con, sql.toString());
			
		} catch(Exception e) {
			LoggingWriter.setLogError("M303S17000E202_TBI_BALJU_Status_Update()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } 
	    return resultInt;
	}	

	public int E202_tbi_import_inspect_result_Update(String[][] c_paramArray, int i){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
//	    	{"발주번호",  "발주요청일자","원부자재명", "원부자재업제명","발주수량", "수입검사수량", "불량수량","검사수행일","검사담당자","확인일자","확인자",   
//				"비고", "원부자재코드", "고객사코드", "검사번호","주문번호", "주문번호상세"};
			sql = new StringBuffer();
			sql.append(" update tbi_import_inspect_result set 				\n");
			sql.append("   return_confirm 		= 'Y',			\n");
			sql.append("   return_dt 		= SYSDATETIME			\n");
			sql.append("where BALJU_REQ_DATE= '" + c_paramArray[i][1] + "'  \n");
			sql.append("  and BALJU_NO 		= '" + c_paramArray[i][0] + "' 	\n");
			sql.append("  and part_cd 		= '" + c_paramArray[i][12] + "' 		\n");
			// System.out.println(sql.toString());
			resultInt = super.excuteUpdate(con, sql.toString());
			
		} catch(Exception e) {
			LoggingWriter.setLogError("M303S17000E202_tbi_import_inspect_result_Update()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } 
	    return resultInt;
	}
	//환송 반려
	public int E202(InoutParameter ioParam){ 
		resultInt = EventDefine.E_DOEXCUTE_INIT;

		int listCnt=0, nextStatuscnt=0;
		try {
			con = JDBCConnectionPool.getConnection();
			String[][] c_paramArray_Head=null;
			
			String[][] c_paramArray_Detail=null;
			String rcvData = (String)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			Vector resultVector = CommonFunction.getConvStringDamogjuk(rcvData);
			con.setAutoCommit(false);
			
			c_paramArray_Head = (String[][])resultVector.get(0);//head table
    		c_paramArray_Detail=(String[][])resultVector.get(1); //data table
    		
	    	for(int i=0; i<c_paramArray_Detail.length; i++) {  
    	    	if(E202_TBI_BALJU_list_Status_Update(c_paramArray_Head, c_paramArray_Detail[i][12]) < 0){  //
    				ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
    				con.rollback();
    				return EventDefine.E_DOEXCUTE_ERROR ;
    			}
    	    	
	    		if (E202_tbi_import_inspect_result_Update(c_paramArray_Detail,i) <= 0) {  //
					ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
					con.rollback();
					return EventDefine.E_DOEXCUTE_ERROR ;
				}
	    	}
	    	
	    	if(E202_TBI_BALJU_Status_Update(c_paramArray_Head) < 0){  //
				ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
				con.rollback();
				return EventDefine.E_DOEXCUTE_ERROR ;
			}
			con.commit();
			
		} catch(Exception e) {
			LoggingWriter.setLogError("M303S060100E202()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M303S060100E202()","==== finally ===="+ e.getMessage());
				}
	    	} else {
	    	}
	    }
		ioParam.setResultString(resultString);
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
    	ioParam.setMessage(MessageDefine.M_QUERY_OK);
	    return EventDefine.E_QUERY_RESULT;
	}	
	
	//Client: M03S17010 수입검사등록 목록
	public int E204(InoutParameter ioParam){ //
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		try {
			con = JDBCConnectionPool.getConnection();
			
			// 클라이언트로 부터 받은 파라미터를 옮겨 담는다.
			String rcvData = (String)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			// 클라이언트로 부터 받은 파라미터를 쪼개어서 배열에 담는다.
			String[][] c_paramArray = CommonFunction.getConvString2DoubleArray(rcvData);
			String sql = new StringBuilder()
					
/*				{"발주일자","발주번호", "검사일자", "발주수량", "검수수량", "불량수량","단위코드", "원부자재명", 
					"확인내용" ,"확인", "원부자재코드", "문항코드","항목코드", "문항내용", "확인내용"	
	*/				
					.append("SELECT 		\n")
					.append("	A.BALJU_REQ_DATE	--발주일자\n")
					.append("   ,A.balju_no		--0발주번호 	 	\n")
					.append("	,SYSDATETIME	--2검수일자		\n")
					.append("	,a.balju_amt		--3발주수량		\n")
					.append("	,a.balju_amt		--4검수수량		\n")
					.append("	,A.unit_cd			--6단위코드		\n")
					.append("	,C.part_nm		--7원부자재명		\n")
					.append("	,E.check_note || '[' || F.item_desc || ']'	--8확인내용	\n")
					.append("	,'N'					--9 확인	\n")
					.append("	,0					--5불량수량		\n")
					.append("	,A.part_cd		--10원부자재코드		\n")
					.append("	,D.checklist_cd	--11문항코드		\n")
					.append("	,E.item_cd		--12항목코드		\n")
					.append("	,E.check_note	--13문항내용	\n")
					.append("	,F.item_desc		--14항목내용	\n")
					.append("   ,'' as  import_inspect_seq           --15 import_inspect_seq\n")
					.append("FROM	 tbi_balju_list A, tb_partlist C, 		\n")
					.append("	       tbi_import_inspect_checklist D, tbm_checklist E, tbm_check_item F	\n")
					.append("WHERE 1=1	\n")
					.append("    AND A.part_cd 			= c.part_cd	\n")
					.append("    AND a.part_cd 			= d.part_cd	\n")
					.append(" 	 AND D.checklist_cd 	= E.checklist_cd		\n")
					.append("	 AND E.item_cd 			= F.item_cd			\n")
					.append("    AND A.part_cd			= '" + c_paramArray[0][0] + "' \n")
					.append("    AND A.balju_no			= '" + c_paramArray[0][1] + "' \n")
					.append("    AND A.BALJU_REQ_DATE			= '" + c_paramArray[0][2] + "' \n")
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
			LoggingWriter.setLogError("M303S060100E204()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M303S060100E204()","==== finally ===="+ e.getMessage());
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

	//Client: M03S17010 수입검사등록 목록
	public int E214(InoutParameter ioParam){ //
	resultInt = EventDefine.E_DOEXCUTE_INIT;
	try {
		con = JDBCConnectionPool.getConnection();
		
		// 클라이언트로 부터 받은 파라미터를 옮겨 담는다.
		String rcvData = (String)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
		// 클라이언트로 부터 받은 파라미터를 쪼개어서 배열에 담는다.
		String[][] c_paramArray = CommonFunction.getConvString2DoubleArray(rcvData);
				
	/*				{"발주일자","발주번호", "검사일자", "발주수량", "검수수량", "불량수량","단위코드", "원부자재명", 
				"확인내용" ,"확인", "원부자재코드", "문항코드","항목코드", "문항내용", "확인내용"	
	*/				
		String sql = new StringBuilder()
				.append("SELECT\n")
				.append("         d.BALJU_REQ_DATE      	--발주일자\n")
				.append("        ,d.balju_no          	--0발주번호\n")
				.append("        ,TO_CHAR(d.import_inspect_dt,'YYYY-MM-DD HH24:MI:SS')    --2검수일자\n")
				.append("        ,a.balju_amt            --3발주수량\n")
				.append("        ,d.sample_cnt        	--4검수수량\n")
				.append("        ,A.unit_cd      		--6단위코드\n")
				.append("        ,C.part_nm              --7원부자재명\n")
				.append("        ,E.check_note || '[' || F.item_desc || ']' --8 확인내용\n")
				.append("        ,g.inspect_result	--9 확인\n")
				.append("        ,G.error_cnt    	--5 불량수량\n")
				.append("        ,d.part_cd       	--10원부자재코드\n")
				.append("        ,g.checklist_cd 	--11문항코드\n")
				.append("        ,g.item_cd       	--12항목코드\n")
				.append("        ,E.check_note   	--13문항내용\n")
				.append("        ,F.item_desc     	--14항목내용\n")
				.append("        ,d.import_inspect_seq            --15import_inspect_seq\n")
				.append("FROM	tbi_import_inspect_result D\n")
				.append("		INNER JOIN tbi_balju_list A\n")
				.append("			ON d.balju_no     		= a.balju_no\n")
				.append("	    	AND d.BALJU_REQ_DATE	= a.BALJU_REQ_DATE\n")
				.append("	    	AND d.part_cd       	= a.part_cd\n")
				.append("    	INNER JOIN tbi_import_inspect_result_dt G\n")
				.append("	    	ON  d.balju_no          = g.balju_no\n")
				.append("	    	AND d.BALJU_REQ_DATE    = g.BALJU_REQ_DATE\n")
				.append("	    	AND d.part_cd       	= g.part_cd\n")
				.append("	    	AND d.import_inspect_seq= g.import_inspect_seq\n")
				.append("    	INNER JOIN tbm_checklist E\n")
				.append("    		ON g.checklist_cd  = E.checklist_cd\n")
				.append("    	INNER JOIN tbm_check_item F\n")
				.append("    		ON E.item_cd               = F.item_cd\n")
				.append("    	INNER JOIN  tb_partlist C\n")
				.append("          	ON d.part_cd = C.part_cd\n")
				.append("WHERE 1=1\n")
				.append("    AND d.part_cd			= '" + c_paramArray[0][0] + "' \n")
				.append("    AND TO_CHAR(d.import_inspect_dt,'YYYY-MM-DD')  ='" + c_paramArray[0][1] + "' \n")
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
		LoggingWriter.setLogError("M303S060100E214()","==== SQL ERROR ===="+ e.getMessage());
		return EventDefine.E_DOEXCUTE_ERROR ;
	} finally {
		if (Config.useDataSource) {
			try {
				if (con != null) con.close();
			} catch (Exception e) {
				LoggingWriter.setLogError("M303S060100E214()","==== finally ===="+ e.getMessage());
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
	
	public int E604(InoutParameter ioParam){
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
					.append("SELECT DISTINCT\n")
					.append("        chulha_no,\n")
					.append("        A.order_no,\n")
					.append("        A.lotno,\n")
					.append("        A.prod_cd,\n")
					.append("        A.prod_rev,\n")
					.append("        C.cust_nm,\n")
					.append("        B.product_nm || '('||D.code_name  ||','|| E.code_name ||')',\n")
					.append("        project_name,\n")
					.append("        cust_pono,\n")
					.append("        to_char(chuha_dt,'YYYY-MM-DD'),\n")
//					.append("        chulha_cnt,\n")
//					.append("        chulha_unit_price,\n")
					.append("        chulha_user_id\n")
//					.append("        project_cnt,\n")
//					.append("        order_count,\n")
//					.append("        A.bigo,\n")
//					.append("        order_date,\n")
//					.append("        A.cust_cd,\n")
//					.append("        A.cust_rev,\n")
//					.append("        A.product_serial_no,\n")
//					.append("        lot_count\n")
					.append("FROM tbi_order A\n")
					.append("INNER JOIN tbi_chulha_info h\n")
					.append("	ON A.order_no = h.order_no\n")
					.append("	AND A.lotno = h.lotno\n")
					.append("	AND A.product_serial_no = h.product_serial_no\n")
					.append("	AND A.member_key = h.member_key\n")
					.append("INNER JOIN tbm_customer C\n")
					.append("	ON A.cust_cd = C.cust_cd\n")
					.append("	AND A.cust_rev = C.revision_no\n")
					.append("	AND A.member_key = C.member_key\n")
					.append("INNER JOIN tbm_product B\n")
					.append("	ON A.prod_cd = B.prod_cd\n")
					.append("	AND  A.prod_rev = B.revision_no\n")
					.append("	AND A.member_key = B.member_key\n")					
					.append("INNER JOIN v_prodgubun_big D				\n")
					.append("		 ON B.prod_gubun_b 	= D.code_value 	\n")
					.append("		AND B.member_key 	= D.member_key	\n")
					.append("INNER JOIN v_prodgubun_mid E				\n")
					.append("	 	 ON B.prod_gubun_m	= E.code_value	\n")
					.append("		AND B.member_key 	= E.member_key	\n")					
					.append("WHERE A.cust_cd like '%"+ jArray.get("custcode") +"'	\n")
					.append("	AND order_date BETWEEN '" + jArray.get("fromdate") +"'  AND '"+ jArray.get("todate") +"'	\n")
					.append("AND A.member_key = '" + jArray.get("member_key") + "' 	\n")
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
			LoggingWriter.setLogError("M303S060100E604()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M303S060100E604()","==== finally ===="+ e.getMessage());
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

