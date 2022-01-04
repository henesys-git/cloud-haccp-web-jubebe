package mes.frame.business.M404;

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
import mes.frame.common.QueueProcessing;
import mes.frame.database.JDBCConnectionPool;
import mes.frame.database.SqlAdapter;
import mes.frame.serviceinterface.InoutParameter;
import mes.frame.serviceinterface.LoggingWriter;
import mes.frame.util.ComBaljuUpdate;
import mes.frame.util.CommonFunction;

/*
 * 품질관리 - 제품검사 - 자주검사관리
 * yumsam
 * 
 * */

/**
 * 개요 : 이벤트ID별 메소드 정의
 */
public class M404S030100 extends SqlAdapter{
	Connection con = null;
	PreparedStatement pstmt = null;
	String resultString = "";
	int resultInt = -1;
	StringBuffer sql = new StringBuffer();
	QueueProcessing Queue = new QueueProcessing();
	String[][] v_paramArray = new String[0][0]; 
	Class[] optClass = null;
	Object[] optObj = null;
	Object obj = null;
	ComBaljuUpdate varBaljuUpdate = new ComBaljuUpdate(); 
	
	public M404S030100(){
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
			
			Method method = M404S030100.class.getMethod(event,optClass);
			LoggingWriter.setLogDebug(M404S030100.class.getName(),"==== " + event + " EventMethod Create Success ====");

			obj = method.invoke(M404S030100.class.newInstance(),optObj);
			doExcute_result = CommonFunction.getInt(obj.toString());
			
	    } catch (Exception ex) {
	    	doExcute_result = EventDefine.E_DOEXCUTE_INIT;
			ioParam.setMessage(MessageDefine.M_NO_EVENTID);
			LoggingWriter.setLogError(M404S030100.class.getName(),"==== EventID Not define : EVENT ID [ " + ioParam.getEventID() + "]");
	    } finally {
	    	obj = null;
			optClass = null;
			optObj = null;
	    }
	    long endTime = System.currentTimeMillis();
		long runningTime = endTime - startTime;
		LoggingWriter.setLogAll(M404S030100.class.getName(),"==== Query [수행시간  : " + runningTime + " ms]");
		
		return doExcute_result;
	}

	// 중량 선별기 결과 등록
	public int E101(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jObj = new JSONObject();
			jObj = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			
			String sql;
			
			// get prod_cd(완제품 코드)
			sql = new StringBuilder()
				.append("SELECT											\n")
				.append("	code_name									\n")
				.append("FROM											\n")
				.append("	tbm_code_book								\n")
				.append("WHERE code_cd = 'WEIGHT_CHECKER_PROD_CD'		\n")
				.append("	AND code_value = " + jObj.get("prodId") + "	\n")
				.toString();
			
			String[] resultStr = excuteQueryString(con, sql).split("\t");
			int prod_cd = Integer.parseInt(resultStr[0]);
			
			// insert weight_checker result into db
			sql = new StringBuilder()
				.append("INSERT INTO\n")
				.append("	haccp_censor_data (\n")
				.append("		censor_no,\n")
				.append("		censor_rev_no,\n")
				.append("		censor_date,\n")
				.append("		censor_data_create_time,\n")
				.append("		censor_value0,\n")
				.append("		censor_value1,\n")
				.append("		censor_value2,\n")
				.append("		censor_value3\n")
				.append("	)\n")
				.append("VALUES\n")
				.append("	(\n")
				.append("		'" + jObj.get("censor_no") + "',\n")
				.append("		0,\n")
				.append("		SYSDATE,\n")
				.append("		SYSTIME,\n")
				.append("		'" + jObj.get("censor_value0") + "',\n")
				.append("		'" + jObj.get("censor_value1") + "',\n")
				.append("		" + prod_cd + ",\n")
				.append("		''\n")
				.append("	);\n")
				.toString();

			resultInt = super.excuteUpdate(con, sql);
			if (resultInt < 0) {
				ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
				return resultInt;
			} else {
				ioParam.setMessage(resultInt + "건 " + MessageDefine.M_INSERT_RESULT);
			}
		} catch(Exception e) {
			LoggingWriter.setLogError("M909S170100E101()","==== SQL ERROR ===="+ e.getMessage() + "\n" + sql.toString());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M909S170100E101()","==== finally ===="+ e.getMessage());
				}
	    	} else {
	    	}
	    }
		ioParam.setResultString(resultString);
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
	    return EventDefine.E_QUERY_RESULT;
	}
	
	public int E104(InoutParameter ioParam){ //
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jObj = new JSONObject();
			jObj = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			
			String sql = new StringBuilder()
					.append("SELECT														\n")
					.append("	A.censor_no,											\n")
					.append("	A.censor_rev_no,										\n")
					.append("	B.product_nm,											\n")
					.append("	A.censor_date,											\n")
					.append("	A.censor_data_create_time,								\n")
					.append("	CAST(A.censor_value0 AS INT) AS censor_value0,			\n")
					.append("	A.censor_value1,										\n")
					.append("	A.censor_value2,										\n")
					.append("	A.censor_value3											\n")
					.append("FROM														\n")
					.append("	haccp_censor_data A										\n")
					.append("INNER JOIN tbm_product B									\n")
					.append("	ON A.censor_value2 = B.prod_cd							\n")
					.append("	AND B.start_date <= '" + jObj.get("fromdate") + "'		\n")
					.append("	AND B.duration_date >= '" + jObj.get("todate") + "'		\n")
					.append("WHERE	censor_no = 'weight_checker01'						\n")
					.append("	AND censor_date BETWEEN '" + jObj.get("fromdate") + "'	\n")
					.append("						AND '" + jObj.get("todate") + "'	\n")
					.toString();
			
			resultString = super.excuteQueryString(con, sql);
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M404S030100E104()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M404S030100E104()","==== finally ===="+ e.getMessage());
				}
	    	} else {
	    	}
	    }
		ioParam.setResultString(resultString);
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
    	ioParam.setMessage(MessageDefine.M_QUERY_OK);

    	return EventDefine.E_QUERY_RESULT;
	}
	
	
	
	
	
	
// ===========================================================================================
//	아래는 태양에서 쓰던 쿼리
// ===========================================================================================
	
	
	
	
	
	
	
	
	public int E122(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;

		Queue = new QueueProcessing();
		try {
			con = JDBCConnectionPool.getConnection();
    		
    		JSONObject jArray = new JSONObject(); // JSONObject 선언
    		jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
    					
			for(int i=0;i<jArray.size();i++) {

				String review_action_no="",confirm_action_no="";//없으면 없는대로 전달
				String jspPage 			= jArray.get("jsp_page").toString();
				String order_detail_seq = jArray.get("order_detail").toString();
				String gOrderNo 		= jArray.get("order_no").toString();
				String main_action_no 	= jArray.get("jsp_page").toString();
				String indGb			= jArray.get("ind_gb").toString();
				String lotno			= jArray.get("lotno").toString();
				String member_key			= jArray.get("member_key").toString();
				if(Queue.setQueue(con, jspPage, gOrderNo, order_detail_seq, main_action_no, review_action_no, 
						confirm_action_no,indGb,lotno,member_key)<0) {
					con.rollback();
					return EventDefine.E_DOEXCUTE_ERROR ;
				}	
//				String sql = new StringBuilder()
//						.append("UPDATE\n")
//						.append("	tbi_order_product_inpect_request\n")
//						.append("SET\n")
//						.append("	result_input_yn = 'Y' \n")
//						.append("WHERE\n")
//						.append("	order_no = '"+ gOrderNo + "' \n")
//						.append("	AND lotno = '"+ lotno + "' \n")
//						.append("	AND inspect_gubun = '" + c_paramArray_Detail[i][5] + "' \n")
//						.append("	AND inspect_req_no = '" + c_paramArray_Detail[i][6] + "' \n")
//						.toString();
//				resultInt = super.excuteUpdate(con, sql.toString());
//				if(resultInt < 0){  //
//					ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
//					con.rollback();
//					return EventDefine.E_DOEXCUTE_ERROR ;
//				}
			}
			con.commit();
			
		} catch(Exception e) {
			LoggingWriter.setLogError("M404S030100E122()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} 
				catch (Exception e) {
					LoggingWriter.setLogError("M404S030100E122()","==== finally ===="+ e.getMessage());
				}
	    	} 
	    	else {
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
	
	
	//품질검사결과삭제 S04S010103.jsp
	public int E103(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		try {
			con = JDBCConnectionPool.getConnection();
			// 클라이언트로 부터 받은 파라미터를 옮겨 담는다.
			JSONObject jArray = new JSONObject(); // JSONObject 선언
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));

			String sql = new StringBuilder()
					.append("DELETE FROM					\n")
					.append("	tbi_order_product_inspect_result 	\n")
					.append("	where order_no 			= '" + jArray.get("order_no") + "'  \n")
					.append(" 	and lotno	= '" + jArray.get("lotno") + "'  \n")
					.append(" 	and inspect_no 		= '" + jArray.get("inspect_no") + "'  \n")
					.append(" 	and checklist_cd 		= '" + jArray.get("checklist_cd") + "'  \n")
					.append(" 	and inspect_seq 		= '" + jArray.get("inspect_seq") + "'  \n")
					.append(" 	and member_key		= '" + jArray.get("member_key") + "'  \n")
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
			LoggingWriter.setLogError("M404S030100E103", "==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M404S030100E103()","==== finally ===="+ e.getMessage());
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
	
	
	//Client: M404S030100 품질검사(Head) 
	public int E104_OLD(InoutParameter ioParam){ //
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			System.out.println("JSONObject jArray rcvData="+ jArray.toString());
			
			// 클라이언트로 부터 받은 파라미터를 옮겨 담는다.
//			String rcvData = (String)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			// 클라이언트로 부터 받은 파라미터를 쪼개어서 배열에 담는다.
//			String[][] c_paramArray = CommonFunction.getConvString2DoubleArray(rcvData);
			String sql = new StringBuilder()
					.append("SELECT DISTINCT\n")
					.append("	C.cust_nm,  													--0. 고객사		\n")
					.append("	B.product_nm || '('||D.code_name  ||','|| E.code_name ||')',	--1. 제품명		\n")
					.append("	cust_pono,														--2. PO번호		\n")
        			.append("	product_gubun,													--3. 제품구분		\n")
        			.append("	part_source,   													--4. 원부자재공급	\n")
					.append("	order_date,      												--5. 주문일		\n")
					.append("	A.lotno,           												--6. lot번호		\n")
					.append("	lot_count,    													--7. lot수량		\n")
					.append("	part_chulgo_date,												--8. 회로자재출고일\n")
					.append("	rohs,															--9. rohs		\n")
					.append("	B.gugyuk,														--10. 규격 		\n")			        
					.append("	order_note,														--11. 특이사항		\n")
					.append("	delivery_date,   												--12. 납기일		\n")
					.append("	bom_version,																\n")
					.append("	A.order_no,    													--14. 주문번호		\n")
					.append("	S.process_name,													--15. 현상태명		\n")
					.append("	A.bigo,         												--16. 비고		\n")
					.append("	product_serial_no, 		--일련번호\n")
					.append("	product_serial_no_end, 	--일련번호끝  \n")
					.append("	A.cust_cd,\n")
					.append("	A.cust_rev,\n")
					.append("	A.prod_cd,\n")
					.append("	A.prod_rev,\n")
					.append("	Q.order_status,\n")
        			.append("	DECODE(product_gubun,'0','양산품','1','개발품') AS product_gubun,	--제품구분\n")
        			.append("	DECODE(part_source,'01','사급','02','도급','03','사급&도급') AS part_source,   		--원부자재공급\n")
					.append("	DECODE(rohs,'0','Pb Free','1','Pb') AS rohs					--rohs\n")
					.append("FROM\n")
					.append("   tbi_order A\n")
					.append("INNER JOIN tbm_customer C\n")
					.append("        ON A.cust_cd = C.cust_cd\n")
					.append("        and A.cust_rev = C.revision_no\n")
					.append("   	 AND A.member_key = C.member_key\n")
					.append("INNER JOIN tbi_queue Q\n")
					.append("        ON A.order_no = Q.order_no\n")
					.append("        AND A.lotno = Q.lotno\n")
					.append("   	 AND A.member_key = Q.member_key\n")
					.append("INNER JOIN tbm_systemcode S\n")
					.append("        ON Q.order_status = S.status_code\n")
					.append("        AND Q.process_gubun = S.process_gubun\n")
					.append("   	 AND Q.member_key = S.member_key\n")
					.append("INNER JOIN tbm_product B\n")
					.append("        ON A.prod_cd = B.prod_cd\n")
					.append("        and  A.prod_rev = B.revision_no\n")
					.append("   	 AND A.member_key = B.member_key\n")
					.append("INNER JOIN v_prodgubun_big D				\n")
					.append("        ON B.prod_gubun_b 	= D.code_value 	\n")
					.append("         AND B.member_key 	= D.member_key	\n")
					.append("INNER JOIN v_prodgubun_mid E				\n")
					.append("		 ON B.prod_gubun_m	= E.code_value	\n")
					.append("       AND B.member_key 	= E.member_key	\n")
					.append("WHERE A.cust_cd LIKE '%" 	+ jArray.get("custcode") + "'	\n")
					.append("AND order_date \n")
					.append("	BETWEEN '" + jArray.get("fromdate") + "' 	\n")
					.append("		AND '" + jArray.get("todate") + "'	\n")
					.append("AND A.member_key = '" + jArray.get("member_key") + "'  \n")
//					.append("SELECT DISTINCT\n")
//					.append("        A.order_no,\n")
//					.append("        A.lotno,\n")
//					.append("        A.inspect_req_no,\n")
//					.append("        A.proc_info_no,\n")
//					.append("        A.proc_cd,\n")
//					.append("        A.proc_cd_rev,\n")
//					.append("        B.process_nm,\n")
//					.append("        e.code_name,\n")
//					.append("        A.request_date,\n")
//					.append("        A.inspect_desire_date,\n")
//					.append("        A.req_seq,\n")
//					.append("        A.prod_cd,\n")
//					.append("        C.product_nm,\n")
//					.append("        A.prod_cd_rev,\n")
//					.append("        A.order_count,\n")
//					.append("        A.delivery_date,\n")
//					.append("        A.bigo,\n")
//					.append("        D.project_name,\n")
//					.append("        D.lot_count,\n")
//					.append("        D.product_serial_no,\n")
//					.append("        A.inspect_gubun \n")
//					.append("FROM\n")
//					.append("        tbi_order_product_inpect_request A\n")
//					.append("        INNER JOIN tbm_process B\n")
//					.append("        ON A.proc_cd = B.proc_cd\n")
//					.append("        AND A.proc_cd_rev = B.revision_no\n")
//					.append("        INNER JOIN tbm_product C\n")
//					.append("        ON A.prod_cd = C.prod_cd\n")
//					.append("        AND A.prod_cd_rev = C.revision_no\n")
//					.append("        INNER JOIN tbi_order D\n")
//					.append("        ON A.order_no = D.order_no\n")
//					.append("        AND A.lotno = D.lotno\n")
//					.append("        INNER JOIN tbi_queue Q\n")
//					.append("                ON A.order_no = Q.order_no\n")
//					.append("                AND A.lotno = Q.lotno\n")
//					.append("                AND A.inspect_req_no = Q.main_action_no\n")
//					.append("        INNER JOIN tbm_systemcode S\n")
//					.append("                ON Q.order_status = S.status_code\n")
//					.append("                AND Q.process_gubun = S.process_gubun\n")
//					.append("        INNER JOIN v_inspect_gubun_code E\n")
//					.append("        ON A.inspect_gubun = E.code_value\n")
//					.append("WHERE\n")
//					.append("	request_date  \n")
//					.append("BETWEEN '" + c_paramArray[0][0] + "' 	\n")
//					.append("	 AND '" + c_paramArray[0][1] + "'	\n")
//					.append("AND A.inspect_gubun like '" 	+ c_paramArray[0][2] + "%'	\n")
//					.append("AND S.class_id = '" 	+ c_paramArray[0][3] + "'	\n")
////					.append("AND A.result_input_yn ='N'	\n")
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
			LoggingWriter.setLogError("M404S030100E104()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M404S030100E104()","==== finally ===="+ e.getMessage());
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

	//Client: M404S070300, M404S070400 품질검사(Head) 	 
		public int E304(InoutParameter ioParam){ //
			resultInt = EventDefine.E_DOEXCUTE_INIT;
			try {
				con = JDBCConnectionPool.getConnection();
				
				JSONObject jArray = new JSONObject();
				jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
				System.out.println("JSONObject jArray rcvData="+ jArray.toString());
				
				// 클라이언트로 부터 받은 파라미터를 옮겨 담는다.
//				String rcvData = (String)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
				// 클라이언트로 부터 받은 파라미터를 쪼개어서 배열에 담는다.
//				String[][] c_paramArray = CommonFunction.getConvString2DoubleArray(rcvData);

				String sql = new StringBuilder()
						.append("SELECT DISTINCT \n")
						.append("	A.order_no,\n")
						.append("	A.lotno,\n")
						.append("	A.inspect_req_no,\n")
						.append("	A.proc_info_no,\n")
						.append("	A.proc_cd,\n")
						.append("	A.proc_cd_rev,\n")
						.append("	B.process_nm, \n")
						.append("	e.code_name,\n")
						.append("	A.request_date,\n")
						.append("	A.inspect_desire_date,\n")
						.append("	A.req_seq,\n")
						.append("	A.prod_cd,\n")
						.append("	C.product_nm,\n")
						.append("	A.prod_cd_rev,\n")
						.append("	A.order_count,\n")
						.append("	A.delivery_date,\n")
						.append("	A.bigo, \n")
						.append("	D.project_name, \n")
						.append("	D.lot_count, \n")
						.append("	D.product_serial_no, \n")
						.append("	A.inspect_gubun \n")
						.append("FROM\n")
						.append("	tbi_order_product_inpect_request A \n")
						.append("	INNER JOIN tbm_process B \n")
						.append("	ON A.proc_cd = B.proc_cd\n")
						.append("	AND A.proc_cd_rev = B.revision_no\n")
						.append("   AND A.member_key = B.member_key\n")
						.append("	INNER JOIN tbm_product C \n")
						.append("	ON A.prod_cd = C.prod_cd\n")
						.append("	AND A.prod_cd_rev = C.revision_no\n")
						.append("   AND A.member_key = C.member_key\n")
						.append("	INNER JOIN tbi_order D  \n" )
						.append("	ON A.order_no = D.order_no \n")
						.append("   AND A.member_key = D.member_key\n")
						.append("	INNER JOIN tbi_queue Q\n")
						.append("		ON A.order_no = Q.order_no\n")
						.append("		AND A.lotno = Q.lotno \n")
						.append("		AND A.inspect_req_no = Q.main_action_no \n")
						.append("   	AND A.member_key = Q.member_key\n")
						.append("	INNER JOIN tbm_systemcode S\n")
						.append("		ON Q.order_status = S.status_code    \n")
						.append("		AND Q.process_gubun = S.process_gubun\n")
						.append("   	AND Q.member_key = S.member_key\n")
						.append("	INNER JOIN v_inspect_gubun_code E  \n" )
						.append("	ON A.inspect_gubun = E.code_value \n")
						.append("   AND A.member_key = E.member_key\n")
						.append("WHERE\n")
						.append("	request_date  \n")
						.append("BETWEEN '" + jArray.get("fromdate") + "' 	\n")
						.append("	 AND '" + jArray.get("todate") + "'	\n")
						.append("AND A.inspect_gubun like '" 	+ jArray.get("inspect_gubun") + "%'	\n")
						.append("AND S.class_id = '" 			+ jArray.get("jsppage") + "'	\n")
						.append("AND A.member_key = '" 			+ jArray.get("member_key") + "'  \n")
//						.append("AND A.result_input_yn ='Y'	\n") tbi_order_doclist
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
				LoggingWriter.setLogError("M404S030100E304()","==== SQL ERROR ===="+ e.getMessage());
				return EventDefine.E_DOEXCUTE_ERROR ;
		    } finally {
		    	if (Config.useDataSource) {
					try {
						if (con != null) con.close();
					} catch (Exception e) {
						LoggingWriter.setLogError("M404S030100E304()","==== finally ===="+ e.getMessage());
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
	
		//Client: M404S070110 품질검사내역
	public int E114(InoutParameter ioParam){ //
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			System.out.println("JSONObject jArray rcvData="+ jArray.toString());
			
			// 클라이언트로 부터 받은 파라미터를 옮겨 담는다.
//			String rcvData = (String)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			// 클라이언트로 부터 받은 파라미터를 쪼개어서 배열에 담는다.
//			String[][] c_paramArray = CommonFunction.getConvString2DoubleArray(rcvData);
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
					.append("A.standard_value\n")
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
					.append("AND  	A.lotno = '" + jArray.get("lotno") + "' \n")
//					.append("AND  	A.inspect_gubun like '%" + jArray.get("gubun_code") + "' \n")
					.append("AND  	A.inspect_gubun = 'PIN' \n")
					.append("AND	A.product_serial_no like '%" + jArray.get("product_serial_no") + "'\n")
					.append("AND	A.product_serial_no_end like '%" + jArray.get("product_serial_no_end") + "'\n")
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
			LoggingWriter.setLogError("M404S030100E114()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M404S030100E114()","==== finally ===="+ e.getMessage());
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
	
	
	// 제품검사 여부
	public int E125(InoutParameter ioParam) { //
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		try {
			con = JDBCConnectionPool.getConnection();

			// 클라이언트로 부터 받은 파라미터를 옮겨 담는다.
			String rcvData = (String) ((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			// 클라이언트로 부터 받은 파라미터를 쪼개어서 배열에 담는다.
			String[][] c_paramArray = CommonFunction.getConvString2DoubleArray(rcvData);
			String sql = new StringBuilder()
					.append("SELECT COUNT(*)\n")
					.append("FROM  db_root\n")
					.append("WHERE (\n")
					.append("  SELECT COUNT(*)\n")
					.append("FROM    (\n")
					.append("   SELECT DISTINCT B.product_serial_no\n")
					.append("   FROM tbi_order_product_inpect_request A\n")
					.append("   INNER JOIN tbi_order B\n")
					.append("      ON A.lotno=B.lotno\n")
					.append("        AND     A.order_no=B.order_no\n")
					.append("   	 AND A.member_key = B.member_key\n")
					.append("	WHERE  A.order_no = '" + c_paramArray[0][0] + "' \n")
					.append("		AND  	A.lotno = '" + c_paramArray[0][1] + "' \n")
					.append("		AND 	A.member_key = '" + c_paramArray[0][2] + "'  \n")
					.append("        )\n")
					.append(") = (\n")
					.append("    SELECT COUNT(*)\n")
					.append("   FROM (\n")
					.append("         SELECT DISTINCT inspect_no\n")
					.append("      FROM tbi_order_product_inpect_request A\n")
					.append("      INNER JOIN tbi_order_product_inspect_result B\n")
					.append("         ON A.lotno=B.lotno\n")
					.append("           AND     A.order_no=B.order_no\n")
					.append("           AND     A.inspect_gubun=B.inspect_gubun\n")
					.append("   		AND A.member_key = B.member_key\n")
					.append("	WHERE  A.order_no = '" + c_paramArray[0][0] + "' \n")
					.append("		AND  	A.lotno = '" + c_paramArray[0][1] + "' \n")
					.append("		AND 	A.member_key = '" + c_paramArray[0][2] + "'  \n")
					.append("   ) \n")
					.append(")\n")
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
			LoggingWriter.setLogError("M404S030100E125()", "==== SQL ERROR ====" + e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR;
		} finally {
			if (Config.useDataSource) {
				try {
					if (con != null)
						con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M404S030100E125()","==== finally ===="+ e.getMessage());
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
		

//			제품 품질검사체크리스트 S04S010130.jsp
	public int E134(InoutParameter ioParam){
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
					.append("        D.order_no,\n")
					.append("        D.project_name,\n")
					.append("        D.product_serial_no,\n")
					.append("        D.lotno,\n")
					.append("        D.lot_count,\n")
					.append("        K.pic_seq,\n")
					.append("        K.prod_cd,\n")
					.append("        P.product_nm,\n")
					.append("        O.order_check_no,\n")
					.append("        A.checklist_seq,\n")
					.append("        A.checklist_cd,\n")
					.append("        O.standard_guide,\n")
					.append("        O.check_note,\n")
					.append("        O.standard_value,\n")
					.append("        B.item_type,\n")
					.append("        B.item_bigo,\n")
					.append("        K.prod_cd_rev,\n")
					.append("        K.checklist_cd_rev,\n")
					.append("        A.item_cd,\n")
					.append("        B.item_desc,\n")
					.append("        A.item_seq,\n")
					.append("        A.item_cd_rev,\n")
					.append("        'N' AS pass_yn,\n")
					.append("        O.inspect_gubun,\n")
					.append("        E.code_name\n")
//					.append("        F.inspect_no,\n")
//					.append("        F.inspect_seq\n")
					.append("FROM\n")
					.append("        tbi_order D\n")
					.append("        INNER JOIN tbi_order_product_inspect_checklist O\n")
					.append("        ON D.order_no = O.order_no\n")
					.append("   	 AND D.member_key = O.member_key\n")
					.append("        INNER JOIN tbm_product_inspect_checklist K\n")
					.append("        ON O.prod_cd = K.prod_cd\n")
					.append("        AND O.prod_rev = K.prod_cd_rev\n")
					.append("        AND O.checklist_cd = K.checklist_cd\n")
					.append("        AND O.checklist_seq = K.checklist_seq\n")
					.append("        AND O.checklist_rev = K.checklist_cd_rev\n")
					.append("        AND O.inspect_gubun = K.inspect_gubun\n")
					.append("   	 AND O.member_key = K.member_key\n")
					.append("        INNER JOIN tbm_checklist A\n")
					.append("        ON K.checklist_cd = A.checklist_cd\n")
					.append("        AND K.checklist_seq = A.checklist_seq\n")
					.append("        AND K.checklist_cd_rev = A.revision_no\n")
					.append("   	 AND K.member_key = A.member_key\n")
					.append("        INNER JOIN tbm_check_item B\n")
					.append("        ON A.item_cd = B.item_cd\n")
					.append("        AND A.item_seq = B.item_seq\n")
					.append("        AND A.item_cd_rev = B.revision_no\n")
					.append("   	 AND A.member_key = B.member_key\n")
					.append("        INNER JOIN tbm_product P\n")
					.append("        ON K.prod_cd = P.prod_cd\n")
					.append("        AND K.prod_cd_rev = P.revision_no\n")
					.append("   	 AND K.member_key = P.member_key\n")
					.append("        INNER JOIN v_checklist_gubun E\n")
					.append("        ON O.inspect_gubun = E.code_value\n")
					.append("   	 AND O.member_key = E.member_key\n")
//					.append("        LEFT OUTER JOIN tbi_order_product_inspect_result F\n")
//					.append("        ON D.order_no = F.order_no\n")
//					.append("        AND O.checklist_cd=F.checklist_cd\n")
//					.append("   	 AND O.member_key = F.member_key\n")
					.append("where   D.order_no like '%" + jArray.get("order_no") + "' \n")
					.append("AND  	 D.lotno like '%" + jArray.get("lotno") + "' \n")
					.append("AND  	 O.inspect_gubun = 'PIN' \n")
					.append("AND 	 D.member_key = '" + jArray.get("member_key") + "'  \n")
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
			LoggingWriter.setLogError("M404S030100E134()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M404S030100E134()","==== finally ===="+ e.getMessage());
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
	
	public int E144(InoutParameter ioParam){ //
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			System.out.println("JSONObject jArray rcvData="+ jArray.toString());
			
			// 클라이언트로 부터 받은 파라미터를 옮겨 담는다.
//			String rcvData = (String)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			// 클라이언트로 부터 받은 파라미터를 쪼개어서 배열에 담는다.
//			String[][] c_paramArray = CommonFunction.getConvString2DoubleArray(rcvData);
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
					.append("A.standard_value\n")
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
					.append("AND  	A.lotno = '" + jArray.get("lotno") + "' \n")
//					.append("AND  	A.inspect_gubun like '%" + jArray.get("gubun_code") + "' \n")
					.append("AND  	A.inspect_gubun = 'PIN' \n")
					.append("AND	A.product_serial_no like '%" + jArray.get("product_serial_no") + "'\n")
					.append("AND	A.product_serial_no_end like '%" + jArray.get("product_serial_no_end") + "'\n")
					.append("AND	A.inspect_seq = '" + jArray.get("inspect_seq") + "'\n")
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
			LoggingWriter.setLogError("M404S030100E144()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M404S030100E144()","==== finally ===="+ e.getMessage());
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

	// S404S030201.jsp
	public int E201(InoutParameter ioParam){ 
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
				.append("	haccp_product_weight (\n")
				.append("		proc_plan_no, 	\n")
				.append("		prod_cd, 		\n")
				.append("		prod_cd_rev, 	\n")
				.append("		product_nm, 	\n")
				.append("		seolbi_nm, 		\n")
				.append("		default_weight, \n")
				.append("		check_date,		\n")
				.append("		manager,		\n")
				.append("		approver,		\n")
				.append("		weight1,		\n")
				.append("		weight2,		\n")
				.append("		weight3,		\n")
				.append("		weight4,		\n")
				.append("		weight5,		\n")
				.append("		weight6,		\n")
				.append("		weight7,		\n")
				.append("		weight8,		\n")
				.append("		weight9,		\n")
				.append("		weight10,		\n")
				.append("		weight11,		\n")
				.append("		weight12,		\n")
				.append("		weight13,		\n")
				.append("		weight14,		\n")
				.append("		weight15,		\n")
				.append("		weight16,		\n")
				.append("		weight17,		\n")
				.append("		weight18,		\n")
				.append("		weight19,		\n")
				.append("		weight20,		\n")
				.append("		weight21,		\n")
				.append("		weight22,		\n")
				.append("		weight23,		\n")
				.append("		weight24,		\n")
				.append("		weight25,		\n")
				.append("		weight26,		\n")
				.append("		weight27,		\n")
				.append("		weight28,		\n")
				.append("		weight29,		\n")
				.append("		weight30,		\n")
				.append("		weight31,		\n")
				.append("		weight32,		\n")
				.append("		weight33,		\n")
				.append("		weight34,		\n")
				.append("		weight35,		\n")
				.append("		weight36,		\n")
				.append("		weight37,		\n")
				.append("		weight38,		\n")
				.append("		weight39,		\n")
				.append("		weight40,		\n")
				.append("		weight41,		\n")
				.append("		weight42,		\n")
				.append("		weight43,		\n")
				.append("		weight44,		\n")
				.append("		weight45,		\n")
				.append("		weight46,		\n")
				.append("		weight47,		\n")
				.append("		weight48,		\n")
				.append("		weight49,		\n")
				.append("		weight50,		\n")
				.append("		weight51,		\n")
				.append("		member_key		\n")
				.append("	)\n")
				.append("VALUES\n")
				.append("	(\n")				
				.append("		'"+ jjjArray.get("proc_plan_no") 	+ "', -- 0. \n")
				.append("		'"+ jjjArray.get("prod_cd") 		+ "', -- 1. \n")
				.append("		'"+ jjjArray.get("prod_cd_rev") 	+ "', -- 2. \n")
				.append("		'"+ jjjArray.get("product_nm") 		+ "', -- 3. \n")
				.append("		'"+ jjjArray.get("seolbi_nm") 		+ "', -- 4. \n")
				.append("		'"+ jjjArray.get("default_weight") 	+ "', -- 5. \n")
				.append("		'"+ jjjArray.get("check_date") 		+ "', -- 6. \n")
				.append("		'"+ jjjArray.get("manager") 		+ "', -- 7. \n")
				.append("		'"+ jjjArray.get("approver") 		+ "', -- 8. \n")
				.append("		 "+ jjjArray.get("weight1") 		+ ",  -- 9. \n")
				.append("		 "+ jjjArray.get("weight2") 		+ ", -- 10. \n")
				.append("		 "+ jjjArray.get("weight3") 		+ ", -- 11. \n")
				.append("		 "+ jjjArray.get("weight4") 		+ ", -- 12. \n")
				.append("		 "+ jjjArray.get("weight5") 		+ ", -- 13. \n")
				.append("		 "+ jjjArray.get("weight6") 		+ ", -- 14. \n")
				.append("		 "+ jjjArray.get("weight7") 		+ ", -- 15. \n")
				.append("		 "+ jjjArray.get("weight8") 		+ ", -- 16. \n")
				.append("		 "+ jjjArray.get("weight9") 		+ ", -- 17. \n")
				.append("		 "+ jjjArray.get("weight10") 		+ ", -- 18. \n")
				.append("		 "+ jjjArray.get("weight11") 		+ ", -- 19. \n")
				.append("		 "+ jjjArray.get("weight12") 		+ ", -- 20. \n")
				.append("		 "+ jjjArray.get("weight13") 		+ ", -- 21. \n")
				.append("		 "+ jjjArray.get("weight14") 		+ ", -- 22. \n")
				.append("		 "+ jjjArray.get("weight15") 		+ ", -- 23. \n")
				.append("		 "+ jjjArray.get("weight16") 		+ ", -- 24. \n")
				.append("		 "+ jjjArray.get("weight17") 		+ ", -- 25. \n")
				.append("		 "+ jjjArray.get("weight18") 		+ ", -- 26. \n")
				.append("		 "+ jjjArray.get("weight19") 		+ ", -- 27. \n")
				.append("		 "+ jjjArray.get("weight20") 		+ ", -- 28. \n")
				.append("		 "+ jjjArray.get("weight21") 		+ ", -- 29. \n")
				.append("		 "+ jjjArray.get("weight22") 		+ ", -- 30. \n")
				.append("		 "+ jjjArray.get("weight23") 		+ ", -- 31. \n")
				.append("		 "+ jjjArray.get("weight24") 		+ ", -- 32. \n")
				.append("		 "+ jjjArray.get("weight25") 		+ ", -- 33. \n")
				.append("		 "+ jjjArray.get("weight26") 		+ ", -- 34. \n")
				.append("		 "+ jjjArray.get("weight27") 		+ ", -- 35. \n")
				.append("		 "+ jjjArray.get("weight28") 		+ ", -- 36. \n")
				.append("		 "+ jjjArray.get("weight29") 		+ ", -- 37. \n")
				.append("		 "+ jjjArray.get("weight30") 		+ ", -- 38. \n")
				.append("		 "+ jjjArray.get("weight31") 		+ ", -- 39. \n")
				.append("		 "+ jjjArray.get("weight32") 		+ ", -- 40. \n")
				.append("		 "+ jjjArray.get("weight33") 		+ ", -- 41. \n")
				.append("		 "+ jjjArray.get("weight34") 		+ ", -- 42. \n")
				.append("		 "+ jjjArray.get("weight35") 		+ ", -- 43. \n")
				.append("		 "+ jjjArray.get("weight36") 		+ ", -- 44. \n")
				.append("		 "+ jjjArray.get("weight37") 		+ ", -- 45. \n")
				.append("		 "+ jjjArray.get("weight38") 		+ ", -- 46. \n")
				.append("		 "+ jjjArray.get("weight39") 		+ ", -- 47. \n")
				.append("		 "+ jjjArray.get("weight40") 		+ ", -- 48. \n")
				.append("		 "+ jjjArray.get("weight41") 		+ ", -- 49. \n")
				.append("		 "+ jjjArray.get("weight42") 		+ ", -- 50. \n")
				.append("		 "+ jjjArray.get("weight43") 		+ ", -- 51. \n")
				.append("		 "+ jjjArray.get("weight44") 		+ ", -- 52. \n")
				.append("		 "+ jjjArray.get("weight45") 		+ ", -- 53. \n")
				.append("		 "+ jjjArray.get("weight46") 		+ ", -- 54. \n")
				.append("		 "+ jjjArray.get("weight47") 		+ ", -- 55. \n")
				.append("		 "+ jjjArray.get("weight48") 		+ ", -- 56. \n")
				.append("		 "+ jjjArray.get("weight49") 		+ ", -- 57. \n")
				.append("		 "+ jjjArray.get("weight50") 		+ ", -- 58. \n")
				.append("		 "+ jjjArray.get("weight51") 		+ ", -- 59. \n")
				.append("		'"+ jjjArray.get("member_key") 		+ "' -- 60. \n")
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
			LoggingWriter.setLogError("M404S030100E201()","==== SQL ERROR ===="+ e.getMessage());
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
	
	// S404S030202.jsp
	public int E202(InoutParameter ioParam){ 
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
				.append("	haccp_product_weight A \n")
				.append("SET\n")
				.append("	weight1  = " + jjjArray.get("weight1") + ",\n")
				.append("	weight2  = " + jjjArray.get("weight2") + ",\n")
				.append("	weight3  = " + jjjArray.get("weight3") + ",\n")
				.append("	weight4  = " + jjjArray.get("weight4") + ",\n")
				.append("	weight5  = " + jjjArray.get("weight5") + ",\n")
				.append("	weight6  = " + jjjArray.get("weight6") + ",\n")
				.append("	weight7  = " + jjjArray.get("weight7") + ",\n")
				.append("	weight8  = " + jjjArray.get("weight8") + ",\n")
				.append("	weight9  = " + jjjArray.get("weight9") + ",\n")
				.append("	weight10 = " + jjjArray.get("weight10") + ",\n")
				.append("	weight11 = " + jjjArray.get("weight11") + ",\n")
				.append("	weight12 = " + jjjArray.get("weight12") + ",\n")
				.append("	weight13 = " + jjjArray.get("weight13") + ",\n")
				.append("	weight14 = " + jjjArray.get("weight14") + ",\n")
				.append("	weight15 = " + jjjArray.get("weight15") + ",\n")
				.append("	weight16 = " + jjjArray.get("weight16") + ",\n")
				.append("	weight17 = " + jjjArray.get("weight17") + ",\n")
				.append("	weight18 = " + jjjArray.get("weight18") + ",\n")
				.append("	weight19 = " + jjjArray.get("weight19") + ",\n")
				.append("	weight20 = " + jjjArray.get("weight20") + ",\n")
				.append("	weight21 = " + jjjArray.get("weight21") + ",\n")
				.append("	weight22 = " + jjjArray.get("weight22") + ",\n")
				.append("	weight23 = " + jjjArray.get("weight23") + ",\n")
				.append("	weight24 = " + jjjArray.get("weight24") + ",\n")
				.append("	weight25 = " + jjjArray.get("weight25") + ",\n")
				.append("	weight26 = " + jjjArray.get("weight26") + ",\n")
				.append("	weight27 = " + jjjArray.get("weight27") + ",\n")
				.append("	weight28 = " + jjjArray.get("weight28") + ",\n")
				.append("	weight29 = " + jjjArray.get("weight29") + ",\n")
				.append("	weight30 = " + jjjArray.get("weight30") + ",\n")
				.append("	weight31 = " + jjjArray.get("weight31") + ",\n")
				.append("	weight32 = " + jjjArray.get("weight32") + ",\n")
				.append("	weight33 = " + jjjArray.get("weight33") + ",\n")
				.append("	weight34 = " + jjjArray.get("weight34") + ",\n")
				.append("	weight35 = " + jjjArray.get("weight35") + ",\n")
				.append("	weight36 = " + jjjArray.get("weight36") + ",\n")
				.append("	weight37 = " + jjjArray.get("weight37") + ",\n")
				.append("	weight38 = " + jjjArray.get("weight38") + ",\n")
				.append("	weight39 = " + jjjArray.get("weight39") + ",\n")
				.append("	weight40 = " + jjjArray.get("weight40") + ",\n")
				.append("	weight41 = " + jjjArray.get("weight41") + ",\n")
				.append("	weight42 = " + jjjArray.get("weight42") + ",\n")
				.append("	weight43 = " + jjjArray.get("weight43") + ",\n")
				.append("	weight44 = " + jjjArray.get("weight44") + ",\n")
				.append("	weight45 = " + jjjArray.get("weight45") + ",\n")
				.append("	weight46 = " + jjjArray.get("weight46") + ",\n")
				.append("	weight47 = " + jjjArray.get("weight47") + ",\n")
				.append("	weight48 = " + jjjArray.get("weight48") + ",\n")
				.append("	weight49 = " + jjjArray.get("weight49") + ",\n")
				.append("	weight50 = " + jjjArray.get("weight50") + ",\n")
				.append("	weight51 = " + jjjArray.get("weight51") + "\n")
				.append("WHERE A.proc_plan_no 	= '"+ jjjArray.get("proc_plan_no")+"' \n")
				.append("AND A.prod_cd 	= '"+ jjjArray.get("prod_cd")+"' \n")
				.append("AND A.prod_cd_rev 	= '"+ jjjArray.get("prod_cd_rev")+"' \n")
				.append("AND A.seolbi_nm 	= '"+ jjjArray.get("seolbi_nm")+"' \n")
				.append("AND A.check_date 	= '"+ jjjArray.get("check_date")+"' \n")
				.append("AND A.member_key 	= '"+ jjjArray.get("member_key") + "'  \n")
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
			LoggingWriter.setLogError("M404S030100E203()","==== SQL ERROR ===="+ e.getMessage());
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
	
	// S404S030203.jsp
	public int E203(InoutParameter ioParam){ 
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
				.append("	haccp_product_weight A \n")
				.append("WHERE A.proc_plan_no = '"+ jjjArray.get("proc_plan_no")+"' \n")
				.append("WHERE A.prod_cd 	= '"+ jjjArray.get("prod_cd")+"' \n")
				.append("AND A.prod_cd_rev 	= '"+ jjjArray.get("prod_cd_rev")+"' \n")
				.append("AND A.check_date 	= '"+ jjjArray.get("check_date")+"' \n")
				.append("AND A.member_key 	= '"+ jjjArray.get("member_key") + "'  \n")
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
			LoggingWriter.setLogError("M404S030100E203()","==== SQL ERROR ===="+ e.getMessage());
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
	
	
	
	// 완제품 중량검사 조회용 쿼리
	public int E204(InoutParameter ioParam){ //
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			System.out.println("JSONObject jArray rcvData="+ jArray.toString());
			
			String sql = new StringBuilder()
					.append("SELECT\n")
					.append("	proc_plan_no, 			-- 0. (숨김)\n")
					.append("	A.prod_cd, 				-- 1. (숨김)\n")
					.append("	A.prod_cd_rev, 			-- 2. (숨김)\n")
					.append("	P.product_nm, 			-- 3. 제품명\n")
					.append("	mix_recipe_cnt, 		-- 4. 배합수(소수점입력되게)\n")					
					.append("	start_dt, 				-- 5. 생산시작일시\n")
					.append("	end_dt, 				-- 6. 생산완료일시\n")
					.append("	A.production_status, 	-- 7. (숨김)\n")
					.append("	PS.code_name, 			-- 8. 생산상태\n")
					.append("	P.gugyuk 				-- 9. 규격\n")
					.append("FROM tbi_production_head A\n")
					.append("INNER JOIN tbm_product P\n")
					.append("	ON A.prod_cd = P.prod_cd\n")
					.append("	AND A.prod_cd_rev = P.revision_no\n")
					.append("	AND A.member_key = P.member_key\n")
					.append("LEFT OUTER JOIN v_prod_processing_status PS\n")
					.append("	ON A.production_status = PS.code_value\n")
					.append("	AND A.member_key = PS.member_key\n")
					.append("WHERE 1=1\n")
					.append("	AND A.member_key = '" + jArray.get("member_key") + "'\n")
					.append("	AND TO_CHAR(start_dt,'YYYY-MM-DD') BETWEEN '" + jArray.get("fromdate") + "' AND '" + jArray.get("todate") + "'\n")
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
			LoggingWriter.setLogError("M404S030100E204()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M404S030100E204()","==== finally ===="+ e.getMessage());
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
	
	// S404S030210.jsp 완제품 중량점검 내역조회
	public int E214(InoutParameter ioParam){ //
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			System.out.println("JSONObject jArray rcvData="+ jArray.toString());
			
			// 클라이언트로 부터 받은 파라미터를 옮겨 담는다.
//			String rcvData = (String)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			// 클라이언트로 부터 받은 파라미터를 쪼개어서 배열에 담는다.
//			String[][] c_paramArray = CommonFunction.getConvString2DoubleArray(rcvData);
			String sql = new StringBuilder()
				.append("SELECT\n")
				.append("	proc_plan_no, 	-- 0. \n")
				.append("	prod_cd,		-- 1. \n")
				.append("	prod_cd_rev,	-- 2. \n")
				.append("	product_nm,		-- 3. \n")
				.append("	seolbi_nm,		-- 4. \n")
				.append("	default_weight,	-- 5. \n")
				.append("	check_date,		-- 6. \n")
				.append("	manager,		-- 7. \n")
				.append("	approver		-- 8. \n")
				.append("FROM haccp_product_weight A \n")				
				.append("WHERE A.proc_plan_no = '"+ jArray.get("proc_plan_no")+"' \n")
				.append("AND A.prod_cd = '"+ jArray.get("prod_cd")+"' \n")
				.append("AND A.prod_cd_rev = '"+ jArray.get("prod_cd_rev")+"' \n")
				.append("AND A.member_key = '" + jArray.get("member_key") + "'  \n")
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
			LoggingWriter.setLogError("M404S030100E214()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M404S030100E214()","==== finally ===="+ e.getMessage());
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
	
	// 완제품 중량점검 수정 삭제시 내용조회
	public int E224(InoutParameter ioParam){ //
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			System.out.println("JSONObject jArray rcvData="+ jArray.toString());
			
			// 클라이언트로 부터 받은 파라미터를 옮겨 담는다.
//			String rcvData = (String)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			// 클라이언트로 부터 받은 파라미터를 쪼개어서 배열에 담는다.
//			String[][] c_paramArray = CommonFunction.getConvString2DoubleArray(rcvData);
			String sql = new StringBuilder()
				.append("SELECT\n")
				.append("	proc_plan_no,	-- 0. \n")
				.append("	prod_cd,		-- 1. \n")
				.append("	prod_cd_rev,	-- 2. \n")
				.append("	seolbi_nm,		-- 3. \n")
				.append("	product_nm,		-- 4. \n")
				.append("	default_weight,	-- 5. \n")
				.append("	check_date,		-- 6. \n")
				.append("	manager,		-- 7. \n")
				.append("	approver,		-- 8. \n")
				.append("	weight1,		-- 9. \n")
				.append("	weight2,		-- 10. \n")
				.append("	weight3,		-- 11. \n")
				.append("	weight4,		-- 12. \n")
				.append("	weight5,		-- 13. \n")
				.append("	weight6,		-- 14. \n")
				.append("	weight7,		-- 15. \n")
				.append("	weight8,		-- 16. \n")
				.append("	weight9,		-- 17. \n")
				.append("	weight10,		-- 18. \n")
				.append("	weight11,		-- 19. \n")
				.append("	weight12,		-- 20. \n")
				.append("	weight13,		-- 21. \n")
				.append("	weight14,		-- 22. \n")
				.append("	weight15,		-- 23. \n")
				.append("	weight16,		-- 24. \n")
				.append("	weight17,		-- 25. \n")
				.append("	weight18,		-- 26. \n")
				.append("	weight19,		-- 27. \n")
				.append("	weight20,		-- 28. \n")
				.append("	weight21,		-- 29. \n")
				.append("	weight22,		-- 20. \n")
				.append("	weight23,		-- 31. \n")
				.append("	weight24,		-- 32. \n")
				.append("	weight25,		-- 33. \n")
				.append("	weight26,		-- 34. \n")
				.append("	weight27,		-- 35. \n")
				.append("	weight28,		-- 36. \n")
				.append("	weight29,		-- 37. \n")
				.append("	weight30,		-- 38. \n")
				.append("	weight31,		-- 39. \n")
				.append("	weight32,		-- 40. \n")
				.append("	weight33,		-- 41. \n")
				.append("	weight34,		-- 42. \n")
				.append("	weight35,		-- 43. \n")
				.append("	weight36,		-- 44. \n")
				.append("	weight37,		-- 45. \n")
				.append("	weight38,		-- 46. \n")
				.append("	weight39,		-- 47. \n")
				.append("	weight40,		-- 48. \n")
				.append("	weight41,		-- 49. \n")
				.append("	weight42,		-- 50. \n")
				.append("	weight43,		-- 51. \n")
				.append("	weight44,		-- 52. \n")
				.append("	weight45,		-- 53. \n")
				.append("	weight46,		-- 54. \n")
				.append("	weight47,		-- 55. \n")
				.append("	weight48,		-- 56. \n")
				.append("	weight49,		-- 57. \n")
				.append("	weight50,		-- 58. \n")
				.append("	weight51		-- 59. \n")
				.append("FROM haccp_product_weight A \n")
				.append("WHERE A.proc_plan_no = '"+ jArray.get("proc_plan_no")+"' \n")
				.append("AND A.prod_cd = '"+ jArray.get("prod_cd")+"' \n")
				.append("AND A.prod_cd_rev = '"+ jArray.get("prod_cd_rev")+"' \n")
				.append("AND A.member_key = '" + jArray.get("member_key") + "'  \n")
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
			LoggingWriter.setLogError("M404S030100E224()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M404S030100E224()","==== finally ===="+ e.getMessage());
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
	
	// 완제품 중량점검 점검표 조회용 쿼리
	public int E234(InoutParameter ioParam){ //
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			System.out.println("JSONObject jArray rcvData="+ jArray.toString());
			
			// 클라이언트로 부터 받은 파라미터를 옮겨 담는다.
//			String rcvData = (String)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			// 클라이언트로 부터 받은 파라미터를 쪼개어서 배열에 담는다.
//			String[][] c_paramArray = CommonFunction.getConvString2DoubleArray(rcvData);
			String sql = new StringBuilder()
				.append("SELECT\n")
				.append("	proc_plan_no,	-- 0. \n")
				.append("	prod_cd,		-- 1. \n")
				.append("	prod_cd_rev,	-- 2. \n")
				.append("	seolbi_nm,		-- 3. \n")
				.append("	product_nm,		-- 4. \n")
				.append("	default_weight,	-- 5. \n")
				.append("	check_date,		-- 6. \n")
				.append("	manager,		-- 7. \n")
				.append("	approver,		-- 8. \n")
				.append("	weight1,		-- 9. \n")
				.append("	weight2,		-- 10. \n")
				.append("	weight3,		-- 11. \n")
				.append("	weight4,		-- 12. \n")
				.append("	weight5,		-- 13. \n")
				.append("	weight6,		-- 14. \n")
				.append("	weight7,		-- 15. \n")
				.append("	weight8,		-- 16. \n")
				.append("	weight9,		-- 17. \n")
				.append("	weight10,		-- 18. \n")
				.append("	weight11,		-- 19. \n")
				.append("	weight12,		-- 20. \n")
				.append("	weight13,		-- 21. \n")
				.append("	weight14,		-- 22. \n")
				.append("	weight15,		-- 23. \n")
				.append("	weight16,		-- 24. \n")
				.append("	weight17,		-- 25. \n")
				.append("	weight18,		-- 26. \n")
				.append("	weight19,		-- 27. \n")
				.append("	weight20,		-- 28. \n")
				.append("	weight21,		-- 29. \n")
				.append("	weight22,		-- 20. \n")
				.append("	weight23,		-- 31. \n")
				.append("	weight24,		-- 32. \n")
				.append("	weight25,		-- 33. \n")
				.append("	weight26,		-- 34. \n")
				.append("	weight27,		-- 35. \n")
				.append("	weight28,		-- 36. \n")
				.append("	weight29,		-- 37. \n")
				.append("	weight30,		-- 38. \n")
				.append("	weight31,		-- 39. \n")
				.append("	weight32,		-- 40. \n")
				.append("	weight33,		-- 41. \n")
				.append("	weight34,		-- 42. \n")
				.append("	weight35,		-- 43. \n")
				.append("	weight36,		-- 44. \n")
				.append("	weight37,		-- 45. \n")
				.append("	weight38,		-- 46. \n")
				.append("	weight39,		-- 47. \n")
				.append("	weight40,		-- 48. \n")
				.append("	weight41,		-- 49. \n")
				.append("	weight42,		-- 50. \n")
				.append("	weight43,		-- 51. \n")
				.append("	weight44,		-- 52. \n")
				.append("	weight45,		-- 53. \n")
				.append("	weight46,		-- 54. \n")
				.append("	weight47,		-- 55. \n")
				.append("	weight48,		-- 56. \n")
				.append("	weight49,		-- 57. \n")
				.append("	weight50,		-- 58. \n")
				.append("	weight51		-- 59. \n")
				.append("FROM haccp_product_weight A \n")
				.append("WHERE A.check_date = '"+ jArray.get("check_date")+"' \n")
				.append("AND A.member_key = '" + jArray.get("member_key") + "'  \n")
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
			LoggingWriter.setLogError("M404S030100E234()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M404S030100E234()","==== finally ===="+ e.getMessage());
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

