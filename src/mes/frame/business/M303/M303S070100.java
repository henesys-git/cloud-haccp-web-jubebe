package mes.frame.business.M303;

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


public class M303S070100 extends SqlAdapter{
	Connection con = null;
	PreparedStatement pstmt = null;
	String resultString = "";
	int resultInt = -1;
	StringBuffer sql = new StringBuffer();
	
	String[][] v_paramArray = new String[0][0]; 
	Class[] optClass = null;
	Object[] optObj = null;
	Object obj = null;
	
	public M303S070100(){
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
			
			Method method = M303S070100.class.getMethod(event,optClass);
			LoggingWriter.setLogDebug(M303S070100.class.getName(),"==== " + event + " EventMethod Create Success ====");

			obj = method.invoke(M303S070100.class.newInstance(),optObj);
			doExcute_result = CommonFunction.getInt(obj.toString());
			
	    } catch (Exception ex) {
	    	doExcute_result = EventDefine.E_DOEXCUTE_INIT;
			ioParam.setMessage(MessageDefine.M_NO_EVENTID);
			LoggingWriter.setLogError(M303S070100.class.getName(),"==== EventID Not define : EVENT ID [ " + ioParam.getEventID() + "]");
	    } finally {
	    	obj = null;
			optClass = null;
			optObj = null;
	    }
	    long endTime = System.currentTimeMillis();
		long runningTime = endTime - startTime;
		LoggingWriter.setLogAll(M303S070100.class.getName(),"==== Query [수행시간  : " + runningTime + " ms]");
		
		return doExcute_result;
	}

	//발주서 등록
	public int E101(InoutParameter ioParam){ 
		resultInt = EventDefine.E_DOEXCUTE_INIT;

		ApprovalActionNo ActionNo;
		String Bulchul_Req_No="";
			
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
    			
    			if(jjjArray0.get("bulchul_req_no").equals("") || jjjArray0.get("bulchul_req_no").equals(null) || jjjArray0.get("bulchul_req_no").equals("undefined")) {
        			String jspPage = (String)jArrayHead.get("jsp_page");
    	    		String user_id = (String)jArrayHead.get("login_id");
    	    		String prefix = (String)jArrayHead.get("prefix");
    	    		String actionGubun = "Regist";
    	    		String detail_seq = "1";
    	    		String member_key = (String)jjjArray0.get("member_key");
    				ActionNo = new ApprovalActionNo();
    				Bulchul_Req_No = ActionNo.getActionNo(con,jspPage,user_id,prefix,actionGubun,detail_seq,member_key);//GV_JSPPAGE(action Page), User ID, prefix
        		} else {
        			Bulchul_Req_No = (String)jjjArray0.get("bulchul_req_no");
        		}
    		}
    			
			System.out.println("Bulchul_Req_No 값은 = "+Bulchul_Req_No);
			
			for(int i=0; i<jjArray.size(); i++) {   
				JSONObject jjjArray = (JSONObject)jjArray.get(i);
				
				String sql = new StringBuilder()
						.append("MERGE INTO tbi_part_chulgo_request mm\n")
						.append("USING (\n")
						.append("	SELECT \n")
						.append("		 '" + jjjArray.get("order_no")  + "' AS order_no,\n")
//						.append("		'" + jjjArray.get("order_detail_seq")  + "' AS order_detail_seq,\n")
						.append("		'" + jjjArray.get("lotno")  + "' AS lotno, \n")
						.append("		'" + Bulchul_Req_No			 + "' AS bulchul_req_no,\n")
						.append("		'" + jjjArray.get("part_cd")  + "' AS part_cd,\n")
						.append("		'" + jjjArray.get("part_cd_rev")  + "' AS part_cd_rev,\n")
						.append("		'" + jjjArray.get("req_date")  + "' AS req_date,\n")
						.append("		'" + jjjArray.get("dept_code")  + "' AS dept_code,\n")
						.append("		'" + jjjArray.get("yongdo")  + "' AS yongdo,\n")
						.append("		'" + jjjArray.get("gubun")  + "' AS gubun,\n")
						.append("		'" + jjjArray.get("req_count")  + "' AS req_count,\n")
						.append("		'" + jjjArray.get("unit") + "' AS unit,\n")
						.append("		'" + jjjArray.get("bigo") + "' AS bigo,\n")
						.append("		'" + jjjArray.get("bulchul_date") + "' AS bulchul_date,\n")
						.append("		'" + jjjArray.get("req_userid") + "' AS req_userid,\n")
						.append("		'" + jjjArray.get("reciept_userid") + "' AS reciept_userid,\n")
						.append("		'" + jjjArray.get("damdanja") + "' AS damdanja,\n")
						.append("		'" + jjjArray.get("member_key") + "' AS member_key\n")
						.append("	FROM db_root ) mQ\n")
						.append("ON ( \n")
						.append("	mm.order_no=mQ.order_no\n")
//						.append("	AND mm.order_detail_seq=mQ.order_detail_seq\n")
						.append("	AND mm.lotno=mQ.lotno\n")
						.append("	AND mm.bulchul_req_no=mQ.bulchul_req_no\n")
						.append("	AND mm.part_cd=mQ.part_cd\n")
						.append("	AND mm.part_cd_rev=mQ.part_cd_rev\n")
						.append("	AND mm.member_key=mQ.member_key\n")
						.append(")\n")
						.append("WHEN MATCHED THEN\n")
						.append("	UPDATE SET \n")
						.append("		mm.order_no=mQ.order_no,\n")
//						.append("		mm.order_detail_seq=mQ.order_detail_seq,\n")
						.append("		mm.lotno=mQ.lotno,\n")
						.append("		mm.bulchul_req_no=mQ.bulchul_req_no,\n")
						.append("		mm.part_cd=mQ.part_cd,\n")
						.append("		mm.part_cd_rev=mQ.part_cd_rev,\n")
						.append("		mm.req_date=mQ.req_date,\n")
						.append("		mm.dept_code=mQ.dept_code,\n")
						.append("		mm.yongdo=mQ.yongdo,\n")
						.append("		mm.gubun=mQ.gubun,\n")
						.append("		mm.req_count=mQ.req_count,\n")
						.append("		mm.unit=mQ.unit,\n")
						.append("		mm.bigo=mQ.bigo,\n")
						.append("		mm.bulchul_date=mQ.bulchul_date,\n")
						.append("		mm.req_userid=mQ.req_userid,\n")
						.append("		mm.reciept_userid=mQ.reciept_userid,\n")
						.append("		mm.damdanja=mQ.damdanja,\n")
						.append("		mm.member_key=mQ.member_key\n")
						.append("WHEN NOT MATCHED THEN\n")
						.append("	INSERT (\n")
						.append("		mm.order_no,\n")
//						.append("		mm.order_detail_seq,\n")
						.append("		mm.lotno,\n")
						.append("		mm.bulchul_req_no,\n")
						.append("		mm.part_cd,\n")
						.append("		mm.part_cd_rev,\n")
						.append("		mm.req_date,\n")
						.append("		mm.dept_code,\n")
						.append("		mm.yongdo,\n")
						.append("		mm.gubun,\n")
						.append("		mm.req_count,\n")
						.append("		mm.unit,\n")
						.append("		mm.bigo,\n")
						.append("		mm.bulchul_date,\n")
						.append("		mm.req_userid,\n")
						.append("		mm.reciept_userid,\n")
						.append("		mm.damdanja,\n")
						.append("		mm.member_key\n")
						.append("	) VALUES (\n")
						.append("		mQ.order_no,\n")
//						.append("		mQ.order_detail_seq,\n")
						.append("		mQ.lotno,\n")
						.append("		mQ.bulchul_req_no,\n")
						.append("		mQ.part_cd,\n")
						.append("		mQ.part_cd_rev,\n")
						.append("		SYSDATE,\n")
						.append("		mQ.dept_code,\n")
						.append("		mQ.yongdo,\n")
						.append("		mQ.gubun,\n")
						.append("		mQ.req_count,\n")
						.append("		mQ.unit,\n")
						.append("		mQ.bigo,\n")
						.append("		mQ.bulchul_date,\n")
						.append("		mQ.req_userid,\n")
						.append("		mQ.reciept_userid,\n")
						.append("		mQ.damdanja,\n")
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
			LoggingWriter.setLogError("M303S070100E101()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M303S070100E101()","==== finally ===="+ e.getMessage());
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
	    		
	    		/*
	    		System.out.println("test jArrayHead : "+ jArrayHead.toString());
	    		System.out.println("test jjArray : "+ jjArray.toString());
	    		System.out.println("test jjjArray : "+ jjjArray.toString());
	    		System.out.println("데이터 묶음 개수 :::: " + jjArray.size());
	    		*/
	    		for(int i=0; i<jjArray.size(); i++) {   
	    			JSONObject jjjArray = (JSONObject)jjArray.get(i);
	    			
					String sql = new StringBuilder()
							.append("UPDATE tbi_part_chulgo_request\n")
							.append("SET \n")
							.append("	order_no='" 		+ jjjArray.get("order_no")  + "',\n")
//							.append("	order_detail_seq='" + jjjArray.get("order_detail_seq")  + "',\n")
							.append("	lotno='" 			+ jjjArray.get("lotno")  + "',\n")
							.append("	bulchul_req_no='" 	+ jjjArray.get("bulchul_req_no")	 + "',\n")
							.append("	part_cd='" 			+ jjjArray.get("part_cd")  + "',\n")
							.append("	part_cd_rev='" 		+ jjjArray.get("part_cd_rev")  + "',\n")
							.append("	req_date='" 		+ jjjArray.get("req_date")  + "',\n")
							.append("	dept_code='" 		+ jjjArray.get("dept_code")  + "',\n")
							.append("	yongdo='" 			+ jjjArray.get("yongdo")  + "',\n")
							.append("	gubun='" 			+ jjjArray.get("gubun")  + "',\n")
							.append("	req_count='" 		+ jjjArray.get("req_count")  + "',\n")
							.append("	unit='" 			+ jjjArray.get("unit") + "',\n")
							.append("	bigo='" 			+ jjjArray.get("bigo") + "',\n")
							.append("	bulchul_date='" 	+ jjjArray.get("bulchul_date") + "',\n")
							.append("	req_userid='" 		+ jjjArray.get("req_userid") + "',\n")
							.append("	reciept_userid='" 	+ jjjArray.get("reciept_userid") + "',\n")
							.append("	damdanja='" 		+ jjjArray.get("damdanja") + "',\n")
							.append("	member_key='" 		+ jjjArray.get("member_key") + "'\n")
							.append("WHERE	order_no='" 		+ jjjArray.get("order_no") + "'\n")
//							.append("	AND order_detail_seq='" + jjjArray.get("order_detail_seq") + "'\n")
							.append("	AND lotno='" 			+ jjjArray.get("lotno") + "'\n")
							.append("	AND bulchul_req_no='" 	+ jjjArray.get("bulchul_req_no") + "'\n")
							.append("	AND part_cd='" 			+ jjjArray.get("part_cd") + "'\n")
							.append("	AND part_cd_rev='" 		+ jjjArray.get("part_cd_rev") + "'\n")
							.append("	AND member_key='" 		+ jjjArray.get("member_key") + "'\n")
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
				LoggingWriter.setLogError("M303S070100E102()","==== SQL ERROR ===="+ e.getMessage());
				return EventDefine.E_DOEXCUTE_ERROR ;
		    } finally {
		    	if (Config.useDataSource) {
					try {
						if (con != null) con.close();
					} catch (Exception e) {
						LoggingWriter.setLogError("M303S070100E102()","==== finally ===="+ e.getMessage());
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
    		JSONObject jjjArray = (JSONObject)jjArray.get(0);
			
			String sql = new StringBuilder()
					.append("DELETE FROM tbi_part_chulgo_request\n")
					.append("WHERE order_no='" 			+ jjjArray.get("order_no") + "'\n")
//					.append("	AND order_detail_seq='" + jjjArray.get("order_detail_seq") + "'\n")
					.append("	AND lotno='" 			+ jjjArray.get("lotno") + "'\n")
					.append("	AND bulchul_req_no='" 	+ jjjArray.get("bulchul_req_no") + "'\n")
					.append("	AND part_cd='" 			+ jjjArray.get("part_cd") + "'\n")
					.append("	AND part_cd_rev='" 		+ jjjArray.get("part_cd_rev") + "'\n")
					.append("	AND member_key='" 		+ jjjArray.get("member_key") + "'\n")
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
			LoggingWriter.setLogError("M303S070100E103()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M303S070100E103()","==== finally ===="+ e.getMessage());
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
					.append("	C.cust_nm,  		--고객사\n")
					.append("	B.product_nm || '('||D.code_name  ||','||  E.code_name ||')',  		--제품명\n")
					.append("	cust_pono,			--PO번호\n")
					.append("	product_gubun,		--제품구분\n")
					.append("	part_source,		--원부자재공급\n")
					.append("	order_date,      	--주문일\n")
					.append("	A.lotno,           	--lot번호\n")
					.append("	lot_count,    		--lot수량\n")
					.append("	part_chulgo_date,	--회로자재출고일\n")
					.append("	rohs,\n")
					.append("	order_note,			--특이사항\n")
					.append("	delivery_date,   	--납기일\n")
					.append("	bom_version,		\n")
					.append("	A.order_no,    		--주문번호\n")
					.append("	'',\n") // .append("	S.process_name,		--현상태명\n")
					.append("	A.bigo,         	--비고\n")
					.append("	A.product_serial_no, 		--일련번호\n")
					.append("	A.product_serial_no_end, 	--일련번호끝  \n")
					.append("	A.cust_cd,\n")
					.append("	A.cust_rev,\n")
					.append("	A.prod_cd,\n")
					.append("	A.prod_rev,\n")
					.append("	'',\n") // .append("	Q.order_status,\n")
					.append("	PH.production_status,\n")
					.append("	PS.code_name\n")
					.append("FROM\n")
					.append("   tbi_order A\n")
					.append("INNER JOIN tbm_customer C\n")
					.append("        ON A.cust_cd = C.cust_cd\n")
					.append("        and A.cust_rev = C.revision_no\n")
					.append("        and A.member_key = C.member_key\n")
//					.append("INNER JOIN tbi_queue Q\n")
//					.append("        ON A.order_no = Q.order_no\n")
//					.append("        AND A.lotno = Q.lotno\n")
//					.append("        AND A.member_key = Q.member_key\n")
//					.append("INNER JOIN tbm_systemcode S\n")
//					.append("        ON Q.order_status = S.status_code\n")
//					.append("        AND Q.process_gubun = S.process_gubun\n")
//					.append("        AND Q.member_key = S.member_key\n")
					.append("INNER JOIN tbm_product B\n")
					.append("        ON A.prod_cd = B.prod_cd\n")
					.append("        and  A.prod_rev = B.revision_no\n")
					.append("        and  A.member_key = B.member_key\n")
					.append("LEFT OUTER JOIN tbi_production_head PH\n")
					.append("	ON A.order_no = PH.order_no\n")
					.append("	AND A.lotno = PH.lotno\n")
					.append("	AND A.member_key = PH.member_key\n")
					.append("LEFT OUTER JOIN v_prod_processing_status PS\n")
					.append("	ON PH.production_status = PS.code_value\n")
					.append("	AND PH.member_key = PS.member_key\n")					
					.append("INNER JOIN v_prodgubun_big D			\n")
					.append("	ON B.prod_gubun_b 	= D.code_value 	\n")
					.append("	AND B.member_key 	= D.member_key	\n")
					.append("INNER JOIN v_prodgubun_mid E			\n")
					.append("	ON B.prod_gubun_m	= E.code_value	\n")
					.append("  AND B.member_key 	= E.member_key	\n")					
					.append("WHERE A.cust_cd LIKE '%" 	+ jArray.get("custcode") + "'	\n")
//					.append("AND S.process_gubun='ODPROCS'\n")
					.append("AND A.member_key='" 		+ jArray.get("member_key") + "'\n")
//					.append("AND S.status_code BETWEEN 'STUS003' AND 'STUS005'\n")
					.append("AND order_date \n")
					.append("BETWEEN '" + jArray.get("fromdate") + "' 	\n")
					.append("	 AND '" + jArray.get("todate") + "'	\n")
					
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
			LoggingWriter.setLogError("M303S070100E104()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M303S070100E104()","==== finally ===="+ e.getMessage());
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
					.append("SELECT DISTINCT\n")
					.append("	A.order_no,\n")
					.append("	B.project_name,\n")
					.append("	C.product_nm,\n")
					.append("	A.part_cd,\n")
					.append("	P.part_nm,\n")
					.append("	req_date,\n")
					.append("	bulchul_date,\n")
					.append("	req_count,\n")
					.append("	req_userid,\n")
					.append("	reciept_userid,\n")
					.append("	storage_bulchul_yn\n")
					.append("FROM tbi_part_chulgo_request A\n")
					.append("INNER JOIN tbi_order B\n")
					.append("	ON A.order_no = B.order_no\n")
//					.append("	AND A.order_detail_seq = B.order_detail_seq\n")
					.append("	AND A.lotno = B.lotno\n")
					.append("	AND A.member_key = B.member_key\n")
					.append("INNER JOIN tbm_product C\n")
					.append("	ON B.prod_cd = C.prod_cd\n")
					.append("	AND B.prod_rev = c.revision_no\n")
					.append("	AND B.member_key = c.member_key\n")
					.append("INNER JOIN tbm_part_list P\n")
					.append("	ON A.part_cd = P.part_cd\n")
					.append("	AND A.part_cd_rev = p.revision_no\n")
					.append("	AND A.member_key = p.member_key\n")
					.append("WHERE A.order_no='" +jArray.get("order_no") + "'\n")
//					.append("	AND A.order_detail_seq='" + c_paramArray[0][1] + "'\n")
					.append("	AND A.lotno='" + jArray.get("lot_no") + "'\n")
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
			LoggingWriter.setLogError("M303S070100E114()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M303S070100E114()","==== finally ===="+ e.getMessage());
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
//					.append("        A.bom_cd,\n")
//					.append("        A.bom_name,\n")
//					.append("        last_no,\n")
//					.append("        type_no,\n")
//					.append("        geukyongpoommok,\n")
//					.append("        dept_code,\n")
//					.append("        approval_date,\n")
//					.append("        approval,\n")
					.append("        A.sys_bom_id,\n")
//					.append("        A.jaryo_bunho,\n")
//					.append("        A.bupum_bunho,\n")
					.append("        A.part_cd,\n")
					.append("        B.part_nm,\n")
					.append("        A.part_cnt,\n")
//					.append("        A.mesu,\n")
//					.append("        A.gubun,\n")
//					.append("        A.qar,\n")
//					.append("        A.inspect_selbi,\n")
//					.append("        A.packing_jaryo,\n")
//					.append("        A.modify_note,\n")
//					.append("                D.cust_nm,\n")
//					.append("                A.bigo,\n")
//					.append("        cust_code,\n")
//					.append("        A.cust_rev,\n")
					.append("        A.part_cd_rev\n")
//					.append("        A.bom_cd_rev,\n")
//					.append("        A.jaryo_irum,\n")
//					.append("        X.sys_bom_parentid\n")
					.append("FROM\n")
					.append("        tbi_order_bomlist A\n")
//					.append("    LEFT OUTER JOIN tbm_customer D\n")
//					.append("        ON A.cust_code = D.cust_cd\n")
//					.append("    INNER JOIN tbm_bom_info X\n")
//					.append("        ON A.sys_bom_id = X.sys_bom_id\n")
//					.append("        AND A.bom_cd = X.bom_cd\n")
//					.append("        AND A.bom_cd_rev = X.bom_cd_rev\n")
					.append("    LEFT OUTER JOIN tbm_part_list B\n")
					.append("        ON A.part_cd = B.part_cd\n")
					.append("        AND A.part_cd_rev = B.revision_no\n")
					.append("        AND A.member_key = B.member_key\n")
					.append("WHERE order_no = '" + jArray.get("order_no") + "'\n")
//					.append(" 	AND order_detail_seq = '" +  c_paramArray[0][1] + "'\n")
					.append(" 	AND lotno = '" + jArray.get("lotno") + "'\n")
					.append("	AND A.part_cd NOT IN (\n")
					.append(" 		SELECT part_cd\n")
					.append("		FROM tbi_part_chulgo_request \n")
					.append("		WHERE order_no='" + jArray.get("order_no") + "'\n")
//					.append("       	AND order_detail_seq='" +  c_paramArray[0][1] + "'\n")
					.append("       	AND lotno='" + jArray.get("lotno") + "'\n")
					.append("	AND A.member_key ='" + jArray.get("member_key") + "'\n")
					.append(" 	)\n")

					
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
			LoggingWriter.setLogError("M303S070100E124()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M303S070100E124()","==== finally ===="+ e.getMessage());
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
					.append("        order_no,\n")
					.append("        lotno,\n")	// .append("        order_detail_seq,\n")
					.append("        bulchul_req_no,\n")
					.append("        A.part_cd,\n")
					.append("        A.part_cd_rev,\n")
					.append("        B.part_nm,\n")
					.append("        req_date,\n")
					.append("        A.dept_code,\n")
					.append("        C.code_name,\n")
					.append("        yongdo,\n")
					.append("        gubun,\n")
					.append("        req_count,\n")
					.append("        unit,\n")
					.append("        bigo,\n")
					.append("        bulchul_date,\n")
					.append("        req_userid,\n")
					.append("        reciept_userid,\n")
					.append("        damdanja\n")
					.append("FROM tbi_part_chulgo_request A\n")
					.append("INNER JOIN tbm_part_list B\n")
					.append("	ON A.part_cd=B.part_cd\n")
					.append("	AND A.part_cd_rev=B.revision_no\n")
					.append("	AND A.member_key=B.member_key\n")
					.append("INNER JOIN v_dept_code C\n")
					.append("	ON A.dept_code=C.code_value\n")
					.append("	AND A.member_key=C.member_key\n")
					.append("WHERE order_no='" + jArray.get("order_no") + "'\n")
//					.append("	AND order_detail_seq='" + c_paramArray[0][1] + "'\n")
					.append("	AND lotno='" + jArray.get("lotno") + "'\n")
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
			LoggingWriter.setLogError("M303S070100E134()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M303S070100E134()","==== finally ===="+ e.getMessage());
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

