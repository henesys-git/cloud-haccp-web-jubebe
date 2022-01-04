package mes.frame.business.M202;

import java.lang.reflect.Method;
import java.math.BigDecimal;
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
import mes.frame.util.CommonFunction;


public class M202S020100 extends SqlAdapter{
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
	
	public M202S020100(){
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
			
			Method method = M202S020100.class.getMethod(event,optClass);
			LoggingWriter.setLogDebug(M202S020100.class.getName(),"==== " + event + " EventMethod Create Success ====");

			obj = method.invoke(M202S020100.class.newInstance(),optObj);
			doExcute_result = CommonFunction.getInt(obj.toString());
			
	    } catch (Exception ex) {
	    	doExcute_result = EventDefine.E_DOEXCUTE_INIT;
			ioParam.setMessage(MessageDefine.M_NO_EVENTID);
			LoggingWriter.setLogError(M202S020100.class.getName(),"==== EventID Not define : EVENT ID [ " + ioParam.getEventID() + "]");
	    } finally {
	    	obj = null;
			optClass = null;
			optObj = null;
	    }
	    long endTime = System.currentTimeMillis();
		long runningTime = endTime - startTime;
		LoggingWriter.setLogAll(M202S020100.class.getName(),"==== Query [수행시간  : " + runningTime + " ms]");
		
		return doExcute_result;
	}
	

	//발주자재검수 등록
	public int E101(InoutParameter ioParam){ 
		resultInt = EventDefine.E_DOEXCUTE_INIT;

		String sql ="";

		ApprovalActionNo ActionNo;
		String balju_inspect_no="";
		
		try {
			con = JDBCConnectionPool.getConnection();
			
    		JSONObject jArray = new JSONObject();
    		jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
    		System.out.println("JSONObject jArray rcvData="+ jArray.toString());
			con.setAutoCommit(false);

    		JSONObject jArrayHead = (JSONObject) jArray.get("paramHead");
    		JSONArray jjArray = (JSONArray) jArray.get("param");
    		System.out.println("데이터 묶음 개수 :::: " + jjArray.size());
//    		String jspPage 		= c_paramArray_Head[0][0];
//    		String user_id 		= c_paramArray_Head[0][1];
//    		String prefix 		= c_paramArray_Head[0][2];
//    		String actionGubun 	= "Regist";
//    		String detail_seq 	= c_paramArray_Head[0][4];
    		
//    		if(balju_inspect_no.length()>10) {
//				ActionNo = new ApprovalActionNo();
//				balju_inspect_no = ActionNo.getActionNo(con,jspPage,user_id,prefix,actionGubun,detail_seq);
//    		}
    		
	    	for(int i=0; i<jjArray.size(); i++) { 
	    		JSONObject jjjArray = (JSONObject)jjArray.get(i); // i번째 데이터묶음
	    		 sql = new StringBuilder()
					.append("MERGE  INTO tbi_balju_list_inspect  mm     \n")
					.append("USING ( SELECT \n")
					.append(" 	'" + jjjArray.get("order_no") + "'  as order_no,		\n") //order_no
					.append(" 	'" + jjjArray.get("balju_no") + "'  as balju_no,		\n") //balju_no
					.append(" 	'" + jjjArray.get("balju_seq") + "'  as balju_seq,		\n") //balju_seq
//					.append(" 	'" + jjjArray.get("balju_inspect_no") + "'     	  as balju_inspect_no,	\n") //balju_inspect_no
					.append(" 	'" + jjjArray.get("bom_nm") + "'  as bom_nm,		\n") //bom_nm			
					.append(" 	'" + jjjArray.get("bom_cd") + "'  as bom_cd,	\n") //bom_cd	
					.append(" 	'" + jjjArray.get("part_cd") + "'  as part_cd,		\n") //part_cd
					.append(" 	'" + jjjArray.get("gyugeok") + "'  as gyugeok,		\n") //gyugeok	
					.append(" 	'" + jjjArray.get("balju_count") + "'  as balju_count,	\n") //balju_count 
					.append(" 	'" + jjjArray.get("inspect_count") + "'  as inspect_count,	\n") //inspect_count
					.append(" 	'" + jjjArray.get("list_price") + "'  as list_price, 	\n") //list_price
					.append(" 	'" + jjjArray.get("balju_amt") + "' as balju_amt, 		\n") //balju_amt
					.append(" 	'" + jjjArray.get("rev_no") + "' as rev_no, 		\n") //rev_no
					.append(" 	'" + jjjArray.get("part_cd_rev") + "' as part_cd_rev, 	\n") //part_cd_rev
					.append(" 	'" + jjjArray.get("lotno") + "' as lotno, 	\n") //part_cd_rev
					.append(" 	'" + jjjArray.get("member_key") + "' as member_key 	\n") //member_key
					.append(" )  mQ    \n")
					.append("ON (mm.order_no = mQ.order_no AND mm.balju_no = mQ.balju_no AND mm.balju_seq = mQ.balju_seq "
							+ " AND mm.bom_cd = mQ.bom_cd "
							+ " AND mm.part_cd = mQ.part_cd  AND mm.lotno = mQ.lotno AND mm.member_key = mQ.member_key)    \n")
					.append("WHEN MATCHED THEN     \n")
					.append("		UPDATE SET     \n")
					.append("			mm.order_no		= mQ.order_no,		mm.balju_no		= mQ.balju_no,		mm.balju_seq 		= mQ.balju_seq,		"
							+ "mm.bom_nm	= mQ.bom_nm,	\n")
					.append("			mm.bom_cd	= mQ.bom_cd,	mm.part_cd			= mQ.part_cd,   		mm.gyugeok 		= mQ.gyugeok,	    \n")
					.append("			mm.balju_count	= mQ.balju_count,	mm.inspect_count	= mQ.inspect_count,	mm.list_price		= mQ.list_price,   		mm.balju_amt 	= mQ.balju_amt,	    \n")
					.append("			mm.rev_no		= mQ.rev_no,		mm.part_cd_rev		= mQ.part_cd_rev,	mm.lotno	= mQ.lotno,  mm.member_key = mQ.member_key	\n")
					.append("WHEN NOT MATCHED THEN     \n")
					.append("	INSERT  (mm.order_no, mm.balju_no, mm.balju_seq, "
							+ " mm.bom_nm, mm.bom_cd, mm.part_cd, mm.gyugeok,	mm.balju_count, mm.inspect_count,"
							+ " mm.list_price, mm.balju_amt, mm.rev_no, mm.part_cd_rev, mm.lotno,  mm.member_key)    \n")
					.append("	VALUES  ( mQ.order_no, mQ.balju_no, mQ.balju_seq, "
							+ " mQ.bom_nm, mQ.bom_cd, mQ.part_cd, mQ.gyugeok, mQ.balju_count, mQ.inspect_count,"
							+ " mQ.list_price, mQ.balju_amt, mQ.rev_no, mQ.part_cd_rev, mQ.lotno, mQ.member_key)    \n")
					.toString();	
	    		
	    		 	System.out.println(i + "====" + sql.toString());
					resultInt = super.excuteUpdate(con, sql.toString());
		    		if (resultInt < 0) {  //
						ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
						con.rollback();
						return EventDefine.E_DOEXCUTE_ERROR ;
					}
	    	}			
			con.commit();
			
		} catch(Exception e) {
			LoggingWriter.setLogError("M202S020100E101()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M202S020100E101()","==== finally ===="+ e.getMessage());
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

		String sql ="";

		ApprovalActionNo ActionNo;
		String balju_inspect_no="";
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			String[][] c_paramArray_Head=null;
			String[][] c_paramArray_Detail=null;
			
			String rcvData = (String)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			Vector resultVector = CommonFunction.getConvStringDamogjuk(rcvData);
			con.setAutoCommit(false);

			c_paramArray_Head 	= (String[][])resultVector.get(0);//head table
    		c_paramArray_Detail	= (String[][])resultVector.get(1); //data table
    		String jspPage 		= c_paramArray_Head[0][0];
    		String user_id 		= c_paramArray_Head[0][1];
    		String prefix 		= c_paramArray_Head[0][2];
    		String actionGubun 	= "Regist";
    		String detail_seq 	= c_paramArray_Detail[0][2];
    		
//    		if(balju_inspect_no.length()>10) {
//				ActionNo = new ApprovalActionNo();
//				balju_inspect_no = ActionNo.getActionNo(con,jspPage,user_id,prefix,actionGubun,detail_seq);
//    		}
    		
	    	for(int i=0; i<c_paramArray_Detail.length; i++) { 

	    		 sql = new StringBuilder()
					.append("MERGE  INTO tbi_import_inspect_request  mm     \n")
					.append("USING ( SELECT     \n")
					.append(" 		'" + c_paramArray_Detail[i][0] + "' AS order_no,		\n") 	//order_no
					.append(" 		'" + c_paramArray_Detail[i][1] + "' AS balju_no,		\n") 	//balju_no
					.append(" 		'" + c_paramArray_Detail[i][3] + "' AS balju_seq,		\n") 	//balju_seq
					.append(" 		'" + c_paramArray_Detail[i][4] + "' AS bom_cd,	\n") 	//bom_cd	
					.append(" 		'" + c_paramArray_Detail[i][5] + "' AS bom_nm,	\n") 	//bom_nm	
					.append(" 		'" + c_paramArray_Detail[i][7] + "' AS part_cd,		\n") 	//part_cd 
					.append(" 		'" + c_paramArray_Detail[i][8] + "' AS write_date,	\n") 	//write_date
					.append(" 		'" + c_paramArray_Detail[i][9] + "' AS ipgo_date, 	\n") 	//ipgo_date
					.append(" 		'" + c_paramArray_Detail[i][10] + "' AS ingae_date, 	\n") 	//ingae_date
					.append(" 		'" + c_paramArray_Detail[i][11] + "' AS inspect_report_yn,	\n") //inspect_report_yn
					.append(" 		'" + c_paramArray_Detail[i][12] + "' AS inspect_end_date,	\n") //inspect_end_date
					.append(" 		'" + c_paramArray_Detail[i][13] + "' AS txt_inspect_note,	\n") //txt_inspect_note
					.append(" 		" + c_paramArray_Detail[i][14] + " AS req_count, 			\n") //req_count
					.append(" 		" + c_paramArray_Detail[i][15] + " AS part_cd_rev, 		\n") //part_cd_rev
					.append(" 		'" + c_paramArray_Detail[i][16] + "' as lotno, 		\n") //part_cd_rev
					.append(" 		'" + c_paramArray_Detail[i][17] + "' as member_key 	\n") //member_key
					.append("	  )  mQ    \n")
					.append("ON (mm.order_no = mQ.order_no AND mm.balju_no = mQ.balju_no AND mm.balju_seq = mQ.balju_seq AND mm.bom_cd = mQ.bom_cd "
							+ " AND mm.part_cd = mQ.part_cd  AND mm.part_cd_rev = mQ.part_cd_rev AND mm.lotno = mQ.lotno AND mm.member_key=mQ.member_key)    \n")
					.append("WHEN MATCHED THEN     \n")
					.append("	UPDATE SET     \n")
					.append("		mm.order_no		= mQ.order_no,		mm.balju_no		= mQ.balju_no,		mm.balju_seq 		= mQ.balju_seq,			mm.bom_nm		= mQ.bom_nm,	\n")
					.append("		mm.bom_cd	= mQ.bom_cd,		 	mm.part_cd			= mQ.part_cd,			mm.write_date 		= mQ.write_date,	\n")
					.append("		mm.ipgo_date	= mQ.ipgo_date,		mm.ingae_date	= mQ.ingae_date,	mm.inspect_report_yn= mQ.inspect_report_yn,	mm.inspect_end_date	= mQ.inspect_end_date,	\n")
					.append("		mm.req_count	= mQ.req_count,		mm.part_cd_rev	= mQ.part_cd_rev, mm.lotno = mQ.lotno, mm.member_key=mQ.member_key	\n")
					.append("WHEN NOT MATCHED THEN     \n")
					.append("	INSERT  (mm.order_no, mm.balju_no, 			mm.balju_seq, 	mm.bom_nm, mm.bom_cd, 	mm.part_cd, mm.write_date,	mm.ipgo_date, mm.ingae_date,"
							+ " mm.inspect_report_yn, mm.inspect_end_date, 	mm.req_count, mm.part_cd_rev, mm.lotno, mm.member_key)    	\n")
					.append("	VALUES  (mQ.order_no, mQ.balju_no, 			mQ.balju_seq, 	mQ.bom_nm, mQ.bom_cd, 	mQ.part_cd, mQ.write_date,	mQ.ipgo_date, mQ.ingae_date,"
							+ " mQ.inspect_report_yn, mQ.inspect_end_date, 	mQ.req_count, mQ.part_cd_rev, mQ.lotno, mQ.member_key)    	\n")
					.toString();	
	
	    		 	System.out.println(i + "====" + sql.toString());
					resultInt = super.excuteUpdate(con, sql.toString());
		    		if (resultInt < 0) {  //
						ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
						con.rollback();
						return EventDefine.E_DOEXCUTE_ERROR ;
					}
	    	}			
			con.commit();
			
		} catch(Exception e) {
			LoggingWriter.setLogError("M202S020100E111()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M202S020100E111()","==== finally ===="+ e.getMessage());
				}
	    	} else {
	    	}
	    }
		ioParam.setResultString(resultString);
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
    	ioParam.setMessage(MessageDefine.M_QUERY_OK);
	    return EventDefine.E_QUERY_RESULT;
}	

	public int E122(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		Queue = new QueueProcessing();
		try {
			con = JDBCConnectionPool.getConnection();

			// 클라이언트로 부터 받은 파라미터를 옮겨 담는다.
			String rcvData = (String)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			String[][] c_paramArray = CommonFunction.getConvString2DoubleArray(rcvData);

				
				String review_action_no="",confirm_action_no="";//없으면 없는대로 전달
				String jspPage 			= c_paramArray[0][0];
				String order_detail_seq = c_paramArray[0][3];
				String gOrderNo 		= c_paramArray[0][2];
				String main_action_no 	= c_paramArray[0][2];
				String indGb			= c_paramArray[0][4];
				String lotno			= c_paramArray[0][5];
				String member_key			= c_paramArray[0][6];
				if(Queue.setQueue(con, jspPage, gOrderNo, order_detail_seq, main_action_no, review_action_no, 
						confirm_action_no,indGb,lotno,member_key)<0) {
					return EventDefine.E_DOEXCUTE_ERROR ;
				}
				
			
		} catch(Exception e) {
			LoggingWriter.setLogError("M202S010100E122()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M202S020100E122()","==== finally ===="+ e.getMessage());
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
					.append("	C.cust_nm,\n")
					.append("	L.balju_text,\n")	// .append("        B.product_nm,\n")
					.append("	project_name,\n")
					.append("	A.lotno,\n")
					.append("	lot_count,\n")
					.append("	delivery_date,\n")
					.append("	cust_pono,\n")
					.append("	project_cnt,\n")
					.append("	order_count,\n")
					.append("	NVL(chulha_cnt,0),\n")
					.append("	(order_count - NVL(chulha_cnt,0) ) AS remin_cnt,\n")
					.append("	S.process_name,\n")
					.append("	A.bigo, \n")
					.append("	A.order_no,\n")
//					.append("	'',\n")	// .append("        A.order_detail_seq,\n")
					.append("	order_date,\n")
					.append("	A.cust_cd,\n")
					.append("	A.cust_rev,\n")
//					.append("	'',\n")	// .append("        A.product_serial_no,\n") 
//					.append("	'',\n")	// .append("        A.prod_cd,\n")
					.append("	Q.order_status,\n")
					.append("	L.balju_no\n")
					.append("FROM tbi_order A\n")
					.append("	LEFT OUTER JOIN tbi_chulha_info h\n")
					.append("	ON A.order_no = h.order_no\n")
					.append("	AND A.lotno = h.lotno\n")
					.append("   AND A.member_key = h.member_key\n")
					.append("	INNER JOIN tbm_customer C\n")
					.append("	ON A.cust_cd = C.cust_cd\n")
					.append("	AND A.cust_rev = C.revision_no\n")
					.append("   AND A.member_key = C.member_key\n")
					.append("	INNER JOIN tbi_queue Q\n")
					.append("	ON A.order_no = Q.order_no\n")
					.append("	AND A.lotno = Q.lotno\n")
					.append("   AND A.member_key = Q.member_key\n")
					.append("	INNER JOIN tbm_systemcode S\n")
					.append("	ON Q.order_status = S.status_code\n")
					.append("   AND Q.member_key = S.member_key\n")
//					.append("	INNER JOIN tbm_product B\n")
//					.append(" 	ON A.prod_cd = B.prod_cd\n")
//					.append(" 	and  A.prod_rev = B.revision_no\n")
					.append("	LEFT OUTER JOIN tbi_balju L \n")
					.append("	ON A.order_no = L.order_no\n")
					.append("   AND A.member_key = L.member_key\n")
//					.append("	WHERE A.cust_cd LIKE '%" 	+ c_paramArray[0][2] + "'	\n")
//					.append("	AND S.class_id = '" 		+ c_paramArray[0][3] + "' 	\n")
//					.append("	AND order_date \n")
//					.append("	BETWEEN '" + c_paramArray[0][0] + "' 	\n")
//					.append("	 AND '" + c_paramArray[0][1] + "'	\n")
					.append("WHERE A.cust_cd LIKE '%" 	+ jArray.get("custcode") + "'	\n")
					.append("	AND S.class_id = '" 		+ jArray.get("jsppage") + "' 	\n")
					.append("	AND order_date \n")
					.append("	BETWEEN '" + jArray.get("fromdate") + "' 	\n")
					.append("	AND '" + jArray.get("todate") + "'	\n")
					.append("	AND A.member_key = '" + jArray.get("member_key") + "' 	\n")
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
			LoggingWriter.setLogError("M202S020100E104()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M202S020100E104()","==== finally ===="+ e.getMessage());
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
					.append("	B.cust_nm,\n")
					.append("	A.member_key,\n")
					.append("	A.order_no,\n")
					.append("	A.lotno,\n")
					.append("	A.balju_no,\n")
					.append("	A.balju_text,\n")
					.append("	E.product_nm,\n")
					.append("	A.balju_send_date,\n")
					.append("	A.cust_cd,\n")
					.append("	A.cust_cd_rev,\n")
					.append("	A.cust_damdang,\n")
					.append("	A.tell_no,\n")
					.append("	A.fax_no,\n")
					.append("	A.balju_nabgi_date,\n")
					.append("	A.nabpoom_location,\n")
					.append("	A.qa_ter_condtion,\n")
					.append("	A.balju_status,\n")
					.append("	A.review_no,\n")
					.append("	A.confirm_no,\n")
					.append("	D.lot_count,\n")
					.append("	NVL(F.ipgo_date, '미검수')\n")
					.append("FROM\n")
					.append("   tbi_balju A\n")
					.append("INNER JOIN tbm_customer B\n")
					.append("	ON A.cust_cd = B.cust_cd\n")
					.append("	AND A.cust_cd_rev = B.revision_no\n")
					.append("	AND A.member_key = B.member_key\n")
					.append("LEFT OUTER JOIN tbi_order D\n")
					.append("	ON A.order_no = D.order_no\n")
					.append("	AND A.lotno = D.lotno\n")
					.append("	AND A.member_key = D.member_key\n")
					.append("LEFT OUTER JOIN tbm_product E\n")
					.append("	ON D.prod_cd = E.prod_cd\n")
					.append("	AND D.prod_rev = E.revision_no\n")
					.append("	AND D.member_key = E.member_key\n")
					.append("LEFT OUTER JOIN haccp_part_ipgo_inspection F\n")
					.append("	ON A.member_key = F.member_key\n")
					.append("	AND A.balju_no = F.balju_no\n")
					.append("WHERE A.cust_cd LIKE '%" 	+ jArray.get("custcode") + "'	\n")
//					.append("AND S.class_id = '" 		+ jArray.get("jsppage") + "' 	\n")
					.append("AND A.balju_send_date \n")
					.append("BETWEEN '" + jArray.get("fromdate") + "' 	\n")
					.append("AND '" + jArray.get("todate") + "'	\n")
					.append("AND A.member_key = '" + jArray.get("member_key") + "' 	\n")
					.append("ORDER BY A.balju_no DESC \n")
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
			LoggingWriter.setLogError("M202S020100E204()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M202S020100E204()","==== finally ===="+ e.getMessage());
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
	
	//자재검수정보
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
//			String[][] c_paramArray = CommonFunction.getConvString2DoubleArray(rcvData);
			
			String sql = new StringBuilder()
					.append("SELECT DISTINCT\n")
					.append("	B.balju_no,		-- 0.\n")
					.append("	A.balju_seq,	-- 1.\n")
					.append("	A.bom_nm,		-- 2.\n")
					.append("	A.bom_cd,		-- 3.\n")
					.append("	A.part_cd,		-- 4.\n")
					.append("	A.gyugeok,		-- 5.\n")
					.append("	A.balju_count,	-- 6.\n")
					.append("	A.inspect_count,-- 7.\n")
					.append("	A.list_price,	-- 8.\n")
					.append("	A.balju_amt,	-- 9.\n")
					.append("	A.rev_no,		-- 10.\n")
					.append("	A.part_cd_rev,	-- 11.\n")
					.append("	(A.balju_count-A.inspect_count) AS chk_yn,\n")
					.append("	C.part_nm,		-- 13.\n")
					.append("	B.cust_cd, 		-- 14.\n")
					.append("	B.cust_cd_rev, 	-- 15.\n")
					.append("	NVL2(D.check_date, '수입검사완료', '미검사'), -- 16.\n")
					.append("	IF ((A.balju_count-A.inspect_count) = 0, 'Y', 'N') AS pass_yn --17.\n")
					.append("FROM tbi_balju_list_inspect A\n")
					.append("INNER JOIN tbi_balju B\n")
					.append("	ON B.balju_no = A.balju_no\n")
					.append("	AND B.member_key = A.member_key\n")
					.append("INNER JOIN tbm_part_list C\n")
					.append("	ON A.part_cd = C.part_cd\n")
					.append("	AND A.part_cd_rev = C.revision_no\n")
					.append("	AND A.member_key = C.member_key\n")
					.append("LEFT OUTER JOIN haccp_part_ipgo_inspection D\n")
					.append("	ON A.balju_no = D.balju_no\n")
					.append("	AND A.part_cd = D.part_cd\n")
					.append("	AND A.member_key = D.member_key\n")
					.append("WHERE A.ORDER_NO = '" + jArray.get("order_no") + "' \n")
					.append("AND A.lotno = '" + jArray.get("lotno") + "' \n")
					.append("AND A.balju_no = '" + jArray.get("baljuno") + "' \n")
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
			LoggingWriter.setLogError("M202S020100E114()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M202S020100E114()","==== finally ===="+ e.getMessage());
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

	// 검수원부자재입고관리 입고관리 선택테이터
	public int E115(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			System.out.println("JSONObject jArray rcvData="+ jArray.toString());
			String sql = new StringBuilder()
				.append("SELECT DISTINCT\n")
				.append("	A.order_no,		-- 01. \n")
				.append("	A.lotno,		-- 02. \n")
				.append("	A.part_cd,		-- 03. \n")
				.append("	A.part_cd_rev,	-- 04. \n")
				.append("	B.part_nm, 		-- 05. \n")
				.append("	A.inspect_count,	-- 06. \n")
				.append("	D.machineno,		-- 07. \n")
				.append("	D.rakes, 			-- 08. \n")
				.append("	D.plate,			-- 09. \n")
				.append("	D.colm, 			-- 10. \n")
				.append("	D.machineno || '-' || D.rakes  || '-' ||  D.plate  || '-' ||  D.colm AS part_loc, 	-- 11. \n")
				.append("	CAST(NVL(D.pre_amt,0) AS NUMERIC(15,3)) as pre_amt, 	-- 12. \n")
				.append("	CAST(NVL(D.io_amt,0) AS NUMERIC(15,3)) as io_amt, 		-- 13. \n")
				.append("	CAST(NVL(D.post_amt,0) AS NUMERIC(15,3)) as post_amt, 	-- 14. \n")
				.append("	B.safety_jaego, 	-- 15. \n")
				.append("	A.balju_count, 			-- 20. \n")
				.append("	NVL(A.balju_count-A.inspect_count,0) AS uninspect_count	-- 21. \n")
				.append("FROM tbi_balju_list_inspect A\n")
				.append("INNER JOIN tbm_part_list B\n")
				.append("	ON A.part_cd = B.part_cd\n")
				.append("	AND A.part_cd_rev = B.revision_no\n")
				.append("	AND A.member_key = B.member_key\n")
				.append("LEFT OUTER JOIN tbi_part_storage D\n")
				.append("	ON A.part_cd = D.part_cd\n")
				.append("	AND A.part_cd_rev = D.part_cd_rev\n")
				.append("	AND A.member_key = D.member_key\n")
				.append("WHERE A.order_no = '" + jArray.get("order_no") + "' \n")
				.append("AND A.lotno = '" + jArray.get("lotno") + "' \n")
				.append("AND A.part_cd = '" + jArray.get("part_cd") + "' \n")
				.append("AND A.part_cd_rev = '" + jArray.get("part_cd_rev") + "' \n")
				.append("AND D.expiration_date = '" + jArray.get("expiration_date") + "' \n")
				.append("AND A.balju_no = '" + jArray.get("balju_no") + "' \n")
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
			LoggingWriter.setLogError("M202S020100E115()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M202S020100E115()","==== finally ===="+ e.getMessage());
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

	// 검수원부자재입고관리 입고관리 선택테이터
	public int E116(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			System.out.println("JSONObject jArray rcvData="+ jArray.toString());
			String sql = new StringBuilder()
				.append("SELECT DISTINCT\n")
				.append("	A.order_no,		-- 01. \n")
				.append("	A.lotno,		-- 02. \n")
				.append("	A.part_cd,		-- 03. \n")
				.append("	A.part_cd_rev,	-- 04. \n")
				.append("	B.part_nm, 		-- 05. \n")
				.append("	A.inspect_count,	-- 06. \n")
				.append("	D.machineno,		-- 07. \n")
				.append("	D.rakes, 			-- 08. \n")
				.append("	D.plate,			-- 09. \n")
				.append("	D.colm, 			-- 10. \n")
				.append("	D.machineno || '-' || D.rakes  || '-' ||  D.plate  || '-' ||  D.colm AS part_loc, 	-- 11. \n")
				.append("	CAST(NVL(D.pre_amt,0) AS NUMERIC(15,3)) as pre_amt, 	-- 12. \n")
				.append("	CAST(NVL(D.io_amt,0) AS NUMERIC(15,3)) as io_amt, 		-- 13. \n")
				.append("	CAST(NVL(D.post_amt,0) AS NUMERIC(15,3)) as post_amt, 	-- 14. \n")
				.append("	B.safety_jaego, 	-- 15. \n")
				.append("	A.balju_count, 			-- 20. \n")
				.append("	NVL(A.balju_count-A.inspect_count,0) AS uninspect_count	-- 21. \n")
				.append("FROM tbi_balju_list_inspect A\n")
				.append("INNER JOIN tbm_part_list B\n")
				.append("	ON A.part_cd = B.part_cd\n")
				.append("	AND A.part_cd_rev = B.revision_no\n")
				.append("	AND A.member_key = B.member_key\n")
				.append("LEFT OUTER JOIN tbi_part_storage D\n")
				.append("	ON A.part_cd = D.part_cd\n")
				.append("	AND A.part_cd_rev = D.part_cd_rev\n")
				.append("	AND A.member_key = D.member_key\n")
				.append("WHERE A.order_no = '" + jArray.get("order_no") + "' \n")
				.append("AND A.lotno = '" + jArray.get("lotno") + "' \n")
				.append("AND A.part_cd = '" + jArray.get("part_cd") + "' \n")
				.append("AND A.part_cd_rev = '" + jArray.get("part_cd_rev") + "' \n")
				.append("AND A.balju_no = '" + jArray.get("balju_no") + "' \n")
//					.append("AND A.part_cd = '" + jArray.get("part_cd") + "' \n")
//					.append("AND A.part_cd_rev = '" + jArray.get("part_cd_rev") + "' \n")
//					.append("AND A.balju_no = '" + jArray.get("balju_no") + "' \n")
				
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
			LoggingWriter.setLogError("M202S020100E116()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M202S020100E116()","==== finally ===="+ e.getMessage());
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
	
	
	// 수입검사 생략
	public int E201(InoutParameter ioParam){ 
		resultInt = EventDefine.E_DOEXCUTE_INIT;

		try {
			con = JDBCConnectionPool.getConnection();
			con.setAutoCommit(false);
			
			// insert_update_delete_json.jsp에서 받아온 JSON데이터 처리
    		JSONObject jArray = new JSONObject();
    		jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
    		System.out.println("JSONObject jArray rcvData="+ jArray.toString());
    		// Object데이터에서 키값(param)으로 JSONArray데이터를 꺼낸다. (데이터묶음 하나일땐 생략)
    		JSONArray jjArray = (JSONArray) jArray.get("param");
						
			for(int i=0; i<jjArray.size(); i++) {
				JSONObject jjjArray = (JSONObject)jjArray.get(i); // i번째 데이터묶음
				String sql = new StringBuilder()
					.append("INSERT INTO haccp_part_ipgo_inspection (\n")
					.append("	check_date,		 --0. \n")
					.append("	check_time,		 --1. \n")
					.append("	ipgo_date,		 --2. \n")
					.append("	cust_cd,		 --3. \n")
					.append("	cust_cd_rev,	 --4. \n")
					.append("	part_cd,		 --5. \n")
					.append("	part_cd_rev,	 --6. \n")
					.append("	part_gyugyeok,	 --7. \n")
					.append("	part_cnt,		 --8. \n")
					.append("	check_gubun,	 --9. \n")
					.append("	check_gubun_mid, --10. \n")
					.append("	check_gubun_sm,	 --11. \n")
					.append("	checklist_cd,	 --12. \n")
					.append("	cheklist_cd_rev, --13. \n")
					.append("	checklist_seq,	 --14. \n")
					.append("	item_cd,		 --15. \n")
					.append("	item_seq,		 --16. \n")
					.append("	item_cd_rev,	 --17. \n")
					.append("	write_date,		 --18. \n")
					.append("	writor_main,	 --19. \n")
					.append("	member_key,		 --20. \n")
					.append("	pass_yn,		 --21. \n")
					.append("	balju_no,		 --21. \n")
					.append("	balju_seq		 --23. \n")
					.append(")\n")
					.append("VALUES\n")
					.append("(\n")
					.append("	TO_CHAR(sysdate,'YYYY-MM-DD'), --0. \n")
					.append("	TO_CHAR(SYSDATETIME, 'HH:MI:SS'), --1. \n")
					.append("	TO_CHAR(sysdate,'YYYY-MM-DD'), --2. \n")
					.append("	'"+ jjjArray.get("cust_cd") + "',		--3. \n")
					.append("	'"+ jjjArray.get("cust_cd_rev") + "',	--4. \n")
					.append("	'"+ jjjArray.get("part_cd") + "',		--5. \n")
					.append("	'"+ jjjArray.get("part_cd_rev") + "',	--6. \n")
					.append("	'"+ jjjArray.get("part_gyugyeok") + "',	--7. \n")
					.append("	'"+ jjjArray.get("part_cnt") + "',		--8. \n")
					.append("	'', --9. \n")                            
					.append("	'', --10. \n")
					.append("	'', --11. \n")
					.append("	'', --12. \n")
					.append("	0,	--13. \n")
					.append("	0,	--14. \n")
					.append("	'',	--15. \n")
					.append("	0,	--16. \n")
					.append("	0,	--17. \n")
					.append("	TO_CHAR(sysdate,'YYYY-MM-DD'),	--18. \n")
					.append("	'"+ jjjArray.get("writor_main") + "',	--19. \n")
					.append("	'"+ jjjArray.get("member_key") + "',	--20. \n")
					.append("	'Y',	--21. \n")
					.append("	'"+ jjjArray.get("balju_no") + "',	--22. \n")
					.append("	'"+ jjjArray.get("balju_seq") + "'	--23. \n")
					.append("	)\n")
					.toString();          		                                             
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
			LoggingWriter.setLogError("M202S020100E201()","==== SQL ERROR ===="+ e.getMessage());
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
	
	
//발주목록조회 S02S020120.jsp
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
					.append("SELECT distinct \n")
					.append("        A.order_no,\n")
					.append("        A.lotno,\n")
					.append("        A.balju_no,\n")
					.append("        B.balju_seq,\n")
					.append("        B.bom_nm,\n")
					.append("        B.part_cd,\n")
					.append("        B.part_cd_rev,\n")
					.append("        B.balju_seq AS inspect_seq,\n")
					.append("        gyugeok,\n")
					.append("        B.balju_count,\n")
					.append("        B.balju_count AS inspect_count,\n")
					.append("        list_price,\n")
					.append("        balju_amt,\n")
					.append("        rev_no,\n")
					.append("        review_no,\n")
					.append("        confirm_no,\n")
					.append("        order_detail_seq,\n")
					.append("        A.member_key,\n")
					.append("        D.part_gubun\n")
					.append("FROM tbi_balju A\n")
					.append("INNER JOIN tbi_balju_list B\n")
					.append("	ON A.balju_no = B.balju_no\n")
					.append("	AND A.member_key = B.member_key\n")
					.append("inner JOIN vtbm_customer C \n")
					.append("	ON A.cust_cd = C.cust_cd\n")
					.append("	AND A.cust_cd_rev = C.revision_no\n") 
					.append("	AND A.member_key = C.member_key\n")
					.append("INNER JOIN tbm_part_list d\n")
					.append("	ON B.part_cd = D.part_cd\n")
					.append("	AND B.part_cd_rev = D.revision_no\n")
					.append("	AND B.member_key = D.member_key\n")
					.append("WHERE order_no = '" + jArray.get("order_no") + "'\n")
//					.append("	AND A.lotno = '" + jArray.get("lotno") + "'\n")
					.append("	AND A.balju_no = '" + jArray.get("balju_no") + "'\n")
					.append("	AND A.member_key = '" + jArray.get("member_key") + "'\n")
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
			LoggingWriter.setLogError("M202S020100E124()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M202S020100E124()","==== finally ===="+ e.getMessage());
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
	
	//발주자재검수 전체등록 페이지전용
	public int E126(InoutParameter ioParam){
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
					.append("SELECT distinct\n")
					.append("	A.order_no,\n")
					.append("	B.balju_no,\n")
					.append("	B.balju_seq,\n")
					.append("	B.bom_nm,\n")
					.append("	B.bom_cd,\n")
					.append("	B.part_cd,\n")
					.append("	B.gyugeok,\n")
					.append("	B.balju_count,\n")
					.append("	B.list_price,\n")
					.append("	B.balju_amt,\n")
					.append("	B.rev_no,\n")
					.append("	B.part_cd_rev,\n")
					.append("	D.inspect_count,\n")
					.append("	A.lotno,\n")
					.append("	NVL(B.balju_count-D.inspect_count,0)\n")
					.append("FROM tbi_balju A\n")
					.append("INNER JOIN tbi_balju_list B\n")
					.append("	ON A.balju_no = B.balju_no\n")
					.append("   AND A.member_key = B.member_key\n")
					.append("INNER JOIN vtbm_customer C\n")
					.append("	ON A.cust_cd = C.cust_cd\n")
					.append("	AND A.cust_cd_rev = C.revision_no\n")
					.append("   AND A.member_key = C.member_key\n")
					.append("LEFT OUTER JOIN tbi_balju_list_inspect D\n")
					.append("	ON A.order_no = D.order_no\n")
					.append("	AND A.lotno = D.lotno\n")
					.append("	AND B.balju_no=D.balju_no\n")
					.append("	AND B.balju_seq=D.balju_seq\n")
					.append("	AND B.part_cd=D.part_cd\n")
					.append("	AND B.part_cd_rev=D.part_cd_rev\n")
					.append("	AND A.member_key = D.member_key\n")
					.append("WHERE A.order_no = '" + jArray.get("order_no") + "' \n")
					.append("AND A.lotno = '" + jArray.get("lotno") + "' \n")
					.append("AND A.balju_no = '" + jArray.get("baljuno") + "' \n")
					.append("AND A.member_key = '" + jArray.get("member_key") + "' 	\n")
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
			LoggingWriter.setLogError("M202S020100E126()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M202S020100E126()","==== finally ===="+ e.getMessage());
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

	public int E125(InoutParameter ioParam){
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
					.append("	B.balju_no,\n")
					.append("	balju_seq,\n")
					.append("	bom_nm,\n")
					.append("	bom_cd,\n")
					.append("	part_cd,\n")
					.append("	gyugeok,\n")
					.append("	balju_count,\n")
					.append("	inspect_count,\n")
					.append("	list_price,\n")
					.append("	balju_amt,\n")
					.append("	rev_no,\n")
					.append("	part_cd_rev, \n")
					.append("	inspect_seq, \n")
					.append("	B.lotno \n")
					.append("FROM tbi_balju_list_inspect A \n")
					.append("	INNER JOIN tbi_balju B \n")
					.append("	ON B.balju_no = A.balju_no\n")
					.append("   AND B.member_key = A.member_key\n")
					.append("WHERE B.order_no = '" + jArray.get("order_no") + "' \n")
					.append("AND B.lotno = '" + jArray.get("lotno") + "' \n")
					.append("AND B.balju_no = '" + jArray.get("baljuno") + "' \n")
					.append("AND A.member_key = '" + jArray.get("member_key") + "' 	\n")
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
			LoggingWriter.setLogError("M202S020100E125()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M202S020100E125()","==== finally ===="+ e.getMessage());
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
//			String rcvData = (String)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			// 클라이언트로 부터 받은 파라미터를 쪼개어서 배열에 담는다.
			// rcvData = [위경도]
//			String[][] c_paramArray = CommonFunction.getConvString2DoubleArray(rcvData);
			
			String sql = new StringBuilder()
					.append("SELECT\n")
					.append("	order_no,\n")
					.append("	order_detail_seq,\n")
					.append("	write_date,\n")
					.append("	ipgo_date,\n")
					.append("	ingae_date,\n")
					.append("	inspect_report_yn,\n")
					.append("	inspect_end_date,\n")
					.append("	inspect_note,\n")
					.append("	balju_no,\n")
					.append("	balju_seq,\n")
					.append("	bom_nm,\n")
					.append("	bom_cd,\n")
					.append("	part_cd,\n")
					.append("	req_count,\n")
					.append("	part_cd_rev\n")
					.append("FROM tbi_import_inspect_request\n")
					.append("WHERE order_no = '" + jArray.get("order_no") + "' \n")
					.append("AND balju_no = '" + jArray.get("baljuno") + "' \n")
					.append("AND A.member_key = '" + jArray.get("member_key") + "' 	\n")
					
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
			LoggingWriter.setLogError("M202S020100E134()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M202S020100E134()","==== finally ===="+ e.getMessage());
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

	public int E135(InoutParameter ioParam){
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
//					.append("	order_no,\n")
//					.append("	order_detail_seq,\n")
//					.append("	write_date,\n")
//					.append("	ipgo_date,\n")
//					.append("	ingae_date,\n")
//					.append("	inspect_report_yn,\n")
//					.append("	inspect_end_date,\n")
//					.append("	inspect_note,\n")
					.append("	balju_no,\n")
					.append("	balju_seq,\n")
					.append("	bom_nm,\n")
					.append("	bom_cd,\n")
					.append("	part_cd,\n")
					.append("	req_count,\n")
					.append("	part_cd_rev\n")
					.append("FROM tbi_import_inspect_request\n")
					.append("WHERE order_no = '" + jArray.get("order_no") + "' \n")
					.append("AND balju_no = '" + jArray.get("baljuno") + "' \n")
					.append("AND A.member_key = '" + jArray.get("member_key") + "' 	\n")
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
			LoggingWriter.setLogError("M202S020100E135()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M202S020100E135()","==== finally ===="+ e.getMessage());
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

	public int E136(InoutParameter ioParam){
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
					.append("	B.balju_no,\n")
					.append("	balju_seq,\n")
					.append("	bom_nm,\n")
					.append("	bom_cd,\n")
					.append("	part_cd,\n")
					.append("	gyugeok,\n")
					.append("	balju_count,\n")
					.append("	inspect_count,\n")
					.append("	list_price,\n")
					.append("	balju_amt,\n")
					.append("	rev_no,\n")
					.append("	part_cd_rev \n")
					.append("FROM tbi_balju_list_inspect A \n")
					.append("	INNER JOIN tbi_balju B \n")
					.append("	ON B.balju_no = A.balju_no\n")
					.append("   AND B.member_key = A.member_key\n")
					.append("WHERE B.order_no = '" + jArray.get("order_no") + "' \n")
					.append("AND B.balju_no = '" + jArray.get("baljuno") + "' \n")
					.append("AND A.member_key = '" + jArray.get("member_key") + "' 	\n")
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
			LoggingWriter.setLogError("M202S020100E136()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M202S020100E136()","==== finally ===="+ e.getMessage());
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

	public int E137(InoutParameter ioParam){
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
					.append("	B.balju_no,\n")
					.append("	balju_seq,\n")
					.append("	bom_nm,\n")
					.append("	bom_cd,\n")
					.append("	part_cd,\n")
					.append("	inspect_count,\n")
					.append("	part_cd_rev \n")
					.append("FROM tbi_balju_list_inspect A \n")
					.append("	INNER JOIN tbi_balju B \n")
					.append("	ON B.balju_no = A.balju_no\n")
					.append("   AND B.member_key = A.member_key\n")
					.append("WHERE B.order_no = '" + jArray.get("order_no") + "' \n")
					.append("AND B.balju_no = '" + jArray.get("baljuno") + "' \n")
					.append("AND A.member_key = '" + jArray.get("member_key") + "' 	\n")
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
			LoggingWriter.setLogError("M202S020100E137()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M202S020100E137()","==== finally ===="+ e.getMessage());
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
	
	//자재검수페이지의 발주정보
	public int E154(InoutParameter ioParam){
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
					.append("	order_no,\n")
					.append("	balju_no,\n")
					.append("	balju_text,\n")
					.append("	balju_send_date,\n")
					.append("	b.cust_nm,\n")
//					.append("	cust_damdang,\n")
					.append("	tell_no,\n")
					.append("	fax_no,\n")
					.append("	balju_nabgi_date,\n")
					.append("	nabpoom_location,\n")
					.append("	qa_ter_condtion,\n")
					.append("	balju_status,\n")
					.append("	review_no,\n")
					.append("	confirm_no,\n")
					.append("	lotno\n")
					.append("FROM tbi_balju A\n")
					.append("	INNER JOIN tbm_customer B\n")
					.append("	ON A.cust_cd = b.cust_cd\n")
					.append("	AND A.cust_cd_rev = b.revision_no\n")	
					.append("   AND A.member_key = b.member_key\n")
//					.append("WHERE order_no = '" 	+ c_paramArray[0][0] + "'\n")
//					.append("	AND lotno = '" 		+ c_paramArray[0][1] + "'\n")
//					.append("	AND balju_no = '" 	+ c_paramArray[0][2] + "'\n") 
					.append("WHERE order_no = '" 	+ jArray.get("order_no") + "'\n")
					.append("	AND lotno = '" 		+ jArray.get("lotno") + "'\n")
					.append("	AND balju_no = '" 	+ jArray.get("baljuno") + "'\n") 
					.append("AND A.member_key = '" + jArray.get("member_key") + "' \n")
					.toString();
//s202s010110헤드컬럼 쿼리랑 맞춰주기 12월31일 12시40분
			String ActionCommand = ioParam.getActionCommand();
			if(ActionCommand.startsWith("doQueryTableFieldName")) {
				resultString = super.excuteQueryStringTableFieldName(con, sql.toString());
			}
			else {;
				resultString = super.excuteQueryString(con, sql.toString());
			}
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M202S020100E154()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M202S020100E154()","==== finally ===="+ e.getMessage());
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
		
	public int E504(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
//			JSONObject jArray = new JSONObject();
//			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
//			System.out.println("JSONObject jArray rcvData="+ jArray.toString());
			
			// 클라이언트로 부터 받은 파라미터를 옮겨 담는다.
			String rcvData = (String)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			// 클라이언트로 부터 받은 파라미터를 쪼개어서 배열에 담는다.
			// rcvData = [위경도]
			String[][] c_paramArray = CommonFunction.getConvString2DoubleArray(rcvData);
			
			//  {"순번", "보관위치", "원부자재코드", "구품코드", "원부자재명", "출고량(합)", "입고량(합)", "위치재고량", "안전재고" };  
			String sql = new StringBuilder()
					.append("WITH STORAGE_HIST AS(\n")
					.append("	SELECT machineno, SAVE_LOCATION, PARTCODE,OLD_PARTCODE, PART_NM, SAFETY_JAEGO, POST_AMT,IO_AMT, IO_GUBUN, IO_DATE ,IO_SEQNO,\n")
					.append("	SUM(CASE WHEN IO_GUBUN='O' THEN NVL(IO_AMT,0) END) OVER(PARTITION BY SAVE_LOCATION,PARTCODE)  as SUM_OUT,\n")
					.append("	SUM(CASE WHEN IO_GUBUN='I' THEN NVL(IO_AMT,0) END) OVER(PARTITION BY SAVE_LOCATION,PARTCODE)  as SUM_IN\n")
					.append("	FROM tbi_part_storage_hist A\n")
					.append("		INNER JOIN TB_PARTLIST B\n")
					.append("		ON A.PARTCODE = PART_CD\n")
					.append("   	AND A.member_key = B.member_key\n")
					.append("	WHERE machineno	= 	'" + c_paramArray[0][0] + "' \n")
					.append("	AND IO_DATE 	>=	'" + c_paramArray[0][1] + "' \n")
					.append("	AND IO_DATE 	<=	'" + c_paramArray[0][2] + "' \n")
					.append("),\n")
					.append("STORAGE_HIST_RANK AS(\n")
					.append("	SELECT machineno, SAVE_LOCATION, PARTCODE,OLD_PARTCODE, PART_NM, NVL(SAFETY_JAEGO,0) AS SAFETY_JAEGO, IO_AMT,POST_AMT, IO_GUBUN, IO_DATE ,IO_SEQNO,SUM_OUT,SUM_IN,\n")
					.append("	RANK() OVER (PARTITION BY SAVE_LOCATION,PARTCODE ORDER BY SAVE_LOCATION, PARTCODE DESC, IO_DATE DESC,IO_SEQNO DESC) as rk\n")
					.append("	FROM STORAGE_HIST\n")
					.append("),\n")
					.append("STORAGE_HIST_TOP AS (\n")
					.append("	SELECT machineno, SAVE_LOCATION, PARTCODE,OLD_PARTCODE, PART_NM, SAFETY_JAEGO, IO_AMT, POST_AMT, IO_GUBUN, IO_DATE ,IO_SEQNO ,nvl(SUM_OUT,0) AS SUM_OUT ,nvl(SUM_IN,0) AS SUM_IN\n")
					.append("	FROM STORAGE_HIST_RANK \n")
					.append("	WHERE rk=1 \n")
//					.append("	ORDER BY SAVE_LOCATION,PARTCODE\n")
					.append(")\n")
					.append("SELECT\n")
					.append("	SAVE_LOCATION,\n")
					.append("	PARTCODE,\n")
					.append("	OLD_PARTCODE,\n")
					.append("	PART_NM,\n")
					.append("	SUM_OUT,\n")
					.append("	SUM_IN,\n")
					.append("	POST_AMT,\n")
					.append("	SAFETY_JAEGO\n")
					.append("FROM STORAGE_HIST_TOP\n")
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
			LoggingWriter.setLogError("M202S020100E504()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M202S020100E504()","==== finally ===="+ e.getMessage());
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


	public int E514(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
//			JSONObject jArray = new JSONObject();
//			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
//			System.out.println("JSONObject jArray rcvData="+ jArray.toString());
			
			// 클라이언트로 부터 받은 파라미터를 옮겨 담는다.
			String rcvData = (String)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			// 클라이언트로 부터 받은 파라미터를 쪼개어서 배열에 담는다.
			// rcvData = [위경도]
			String[][] c_paramArray = CommonFunction.getConvString2DoubleArray(rcvData);
			/*{ "원부자재코드", "원부자재명", "구품번", "구도면","단위무게","규격","안전재고","열처리", "재질","후처리"}; */
			String sql = new StringBuilder()
					.append("select\n")
					.append("	PART_CD\n")
					.append("	coalesce(PART_NM, ' ') 		AS PARTNAME,		\n")
					.append("	coalesce(OLD_PARTCODE, ' ') 	AS OLD_PARTCODE,	\n")
					.append(" 	coalesce(OLD_DWG, ' ') 		AS OLD_DRAWCODE,	\n")
					.append(" 	coalesce(UNIT_WEIGHT, '0') 	AS UNIT_WEIGHT,	\n")
					.append("  	coalesce(GYUGYEOK, ' ') 		AS GYUGYEOK,		\n")
					.append(" 	coalesce(SAFETY_JAEGO, '0') 	AS SAFETY_JAEGO,	\n")
					.append(" 	coalesce(P_HEAT, ' ') 			AS HEAT_TREAT,	\n")
					.append(" 	coalesce(P_MATERIAL, ' ') 		AS MATERIAL,		\n")
					.append("	coalesce(P_AFTER_TREAT, ' ') 	AS AFTER_TREAT	\n")
					.append("FROM TB_PARTLIST pl	\n")
					.append("WHERE  delYn = 'N' AND PART_CD LIKE '" + c_paramArray[0][0] + "%' \n")
					.append("ORDER BY PART_CD\n")
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
			LoggingWriter.setLogError("M202S020100E514()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M202S020100E514()","==== finally ===="+ e.getMessage());
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
	
	
//이력번호 등록
	public int E161(InoutParameter ioParam){

		String sql ="";
		String ref_no ="";

		ApprovalActionNo ActionNo;
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		try {
			con = JDBCConnectionPool.getConnection();
			con.setAutoCommit(false);
			
    		// insert_update_delete_json.jsp에서 받아온 JSON데이터 처리
    		JSONObject jArray = new JSONObject();
    		jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
    		System.out.println("JSONObject jArray rcvData="+ jArray.toString());
    		// Object데이터에서 키값(param)으로 JSONArray데이터를 꺼낸다. (데이터묶음 하나일땐 생략)
    		
    		String jspPage = (String)jArray.get("jsp_page");
    		String user_id = (String)jArray.get("user_id");
    		String prefix = (String)jArray.get("prefix");
    		String actionGubun = "Regist";
    		String detail_seq = (String)jArray.get("detail_seq");
    		String member_key = (String)jArray.get("member_key");
    		
    		
			ActionNo = new ApprovalActionNo();
			ref_no = ActionNo.getActionNo(con,jspPage,user_id,prefix,actionGubun,detail_seq,member_key);//GV_JSPPAGE(action Page), User ID, prefix
    		
    		
			if(jArray.get("Gubun").equals("0")) { // 소고기일경우
	    		// seq_no 등록번호(MAX+1)
	    		sql = new StringBuilder()
	    				.append("SELECT NVL(MAX(seq_no),0) FROM tbi_declaration_cattle_purchase WHERE lotno='" + jArray.get("lotno") +"'\n")
	    				.toString();
	    		String resultString = excuteQueryString(con, sql).trim();
//	    		BigDecimal seq_no = new BigDecimal(String.valueOf(resultString) + 1); // 소수점계산
	    		int seq_no = Integer.parseInt(resultString) + 1;
	    		
				 sql = new StringBuilder()
						.append("INSERT INTO tbi_declaration_cattle_purchase(\n")
						.append("	seq_no,\n")
						.append("	member_key,\n")
						.append("	refno,\n")
						.append("	inymd,\n")
						.append("	returnyn,\n")
						.append("	cattlelottype,\n")
						.append("	cattleno,\n")
						.append("	lotno,\n")
						.append("	partcd,\n")
						.append("	partnm,\n")
						.append("	inweight,\n")
						.append("	incorpno,\n")
						.append("	incorpnm,\n")
						.append("	incorpaddr,\n")
						.append("	incorptp,\n")
						.append("	bigo\n")
						.append(")VALUES (\n")
						.append("	" + seq_no + ",\n")
						.append("	'" + jArray.get("member_key") + "',\n")
						.append("	'" + ref_no + "',\n")
						.append("	'" + jArray.get("inymd") + "',\n")
						.append("	'" + jArray.get("returnyn") + "',\n")
						.append("	'" + jArray.get("cattlelottype") + "',\n")
						.append("	'" + jArray.get("cattleno") + "',\n")
						.append("	'" + jArray.get("lotno") + "',\n")
						.append("	'" + jArray.get("partcd") + "',\n")
						.append("	'" + jArray.get("partnm") + "',\n")
						.append("	'" + jArray.get("inweight") + "',\n")
						.append("	REPLACE('" + jArray.get("incorpno") + "','-',''),\n")
						.append("	'" + jArray.get("incorpnm") + "',\n")
						.append("	'" + jArray.get("incorpaddr") + "',\n")
						.append("	'" + jArray.get("incorptp") + "',\n")
						.append("	'" + jArray.get("bigo") + "'\n")
						.append(")\n")
					.toString();
				 
				 	resultInt = super.excuteUpdate(con, sql.toString());	
					if (resultInt < 0) {
						con.rollback();
					}
					sql = new StringBuilder()
							.append("MERGE INTO haccp_hysteretic_system mm \n")
							.append("USING (SELECT \n")
							.append("	'" 	+ jArray.get("order_no") + "' AS order_no,\n")
							.append("	'" 	+ jArray.get("lotno_henesys") + "' AS lotno,\n")
							.append("	'" 	+ jArray.get("cattleno") + "' AS hist_no,\n")
							.append("	'" 	+ jArray.get("member_key") + "' AS member_key,\n")
							.append("	'" 	+ jArray.get("inymd") + "' AS create_date,\n")
							.append("	'" 	+ jArray.get("lotno") + "' AS bundle_no,\n")
							.append("	'" 	+ jArray.get("partcd") + "' AS part_cd,\n")
							.append("	'" 	+ jArray.get("cattlelottype") + "' AS hist_type\n")
							.append("	FROM db_root\n")
							.append("	) mQ\n")
							.append("	ON (mm.order_no = mQ.order_no AND mm.lotno = mQ.lotno AND mm.hist_no = mQ.hist_no AND mm.member_key = mQ.member_key AND mm.bundle_no = mQ.bundle_no AND mm.part_cd = mQ.part_cd AND mm.hist_type = mQ.hist_type)\n")
							.append("	WHEN MATCHED THEN\n")
							.append("	UPDATE SET \n")
							.append("	mm.order_no = mQ.order_no, mm.lotno = mQ.lotno, mm.hist_no = mQ.hist_no, mm.member_key = mQ.member_key, mm.create_date = mQ.create_date, mm.bundle_no = mQ.bundle_no, mm.part_cd = mQ.part_cd, mm.hist_type = mQ.hist_type\n")
							.append("	WHEN NOT MATCHED THEN\n")
							.append("	INSERT (mm.order_no, mm.lotno, mm.hist_no, mm.member_key, mm.create_date, mm.bundle_no, mm.part_cd, mm.hist_type)\n")
							.append("	VALUES (mQ.order_no, mQ.lotno, mQ.hist_no, mQ.member_key, mQ.create_date, mQ.bundle_no, mQ.part_cd, mQ.hist_type)\n")
							.toString();
						
			}else {
	    		// seq_no 등록번호(MAX+1)
	    		sql = new StringBuilder()
	    				.append("SELECT NVL(MAX(seq_no),0) FROM tbi_declaration_pig_purchase WHERE lotno='" + jArray.get("lotno") +"'\n")
	    				.toString();
	    		String resultString = excuteQueryString(con, sql).trim();
//	    		BigDecimal seq_no = new BigDecimal(String.valueOf(resultString) + 1); // 소수점계산
	    		int seq_no = Integer.parseInt(resultString) + 1;
	    		
				 sql = new StringBuilder()
							.append("INSERT INTO tbi_declaration_pig_purchase(\n")
							.append("	seq_no,\n")
							.append("	member_key,\n")
							.append("	refno,\n")
							.append("	parttype,\n")
							.append("	returnyn,\n")
							.append("	inymd,\n")
							.append("	incorpno,\n")
							.append("	incorpnm,\n")
							.append("	incorpownernm,\n")
							.append("	incorptel,\n")
							.append("	incorpaddr,\n")
							.append("	inplacenm,\n")
							.append("	intypenm,\n")
							.append("	totweight,\n")
							.append("	piglottype,\n")
							.append("	lotno,\n")
							.append("	pigno,\n")
							.append("	butcheryno,\n")
							.append("	partcd,\n")
							.append("	partnm,\n")
							.append("	inweight,\n")
							.append("	gradecd\n")
							.append(")VALUES (\n") 
							.append("	" + seq_no + ",\n")
							.append("	'" + jArray.get("member_key") + "',\n")
							.append("	'" + ref_no + "',\n")
							.append("	'" + jArray.get("parttype") + "',\n")
							.append("	'" + jArray.get("returnyn") + "',\n")
							.append("	'" + jArray.get("inymd") + "',\n")
							.append("	REPLACE('" + jArray.get("incorpno") + "','-',''),\n")
							.append("	'" + jArray.get("incorpnm") + "',\n")
							.append("	'" + jArray.get("incorpownernm") + "',\n")
							.append("	'" + jArray.get("incorptel") + "',\n")
							.append("	'" + jArray.get("incorpaddr") + "',\n")
							.append("	'" + jArray.get("inplacenm") + "',\n")
							.append("	'" + jArray.get("intypenm") + "',\n")
							.append("	'" + jArray.get("totweight") + "',\n")
							.append("	'" + jArray.get("piglottype") + "',\n")
							.append("	'" + jArray.get("lotno") + "',\n")
							.append("	'" + jArray.get("pigno") + "',\n")
							.append("	'" + jArray.get("butcheryno") + "',\n")
							.append("	'" + jArray.get("partcd") + "',\n")
							.append("	'" + jArray.get("partnm") + "',\n")
							.append("	'" + jArray.get("inweight") + "',\n")
							.append("	'" + jArray.get("gradecd") + "'\n")
							.append(")\n")
						.toString();
				 
				 	resultInt = super.excuteUpdate(con, sql.toString());	
					if (resultInt < 0) {
						con.rollback();
					}
					sql = new StringBuilder()
							.append("MERGE INTO haccp_hysteretic_system mm \n")
							.append("USING (SELECT \n")
							.append("	'" 	+ jArray.get("order_no") + "' AS order_no,\n")
							.append("	'" 	+ jArray.get("lotno_henesys") + "' AS lotno,\n")
							.append("	'" 	+ jArray.get("pigno") + "' AS hist_no,\n")
							.append("	'" 	+ jArray.get("member_key") + "' AS member_key,\n")
							.append("	'" 	+ jArray.get("inymd") + "' AS create_date,\n")
							.append("	'" 	+ jArray.get("lotno") + "' AS bundle_no,\n")
							.append("	'" 	+ jArray.get("partcd") + "' AS part_cd,\n")
							.append("	'" 	+ jArray.get("piglottype") + "' AS hist_type\n")
							.append("	FROM db_root\n")
							.append("	) mQ\n")
							.append("	ON (mm.order_no = mQ.order_no AND mm.lotno = mQ.lotno AND mm.hist_no = mQ.hist_no AND mm.member_key = mQ.member_key AND mm.bundle_no = mQ.bundle_no AND mm.part_cd = mQ.part_cd AND mm.hist_type = mQ.hist_type)\n")
							.append("	WHEN MATCHED THEN\n")
							.append("	UPDATE SET \n")
							.append("	mm.order_no = mQ.order_no, mm.lotno = mQ.lotno, mm.hist_no = mQ.hist_no, mm.member_key = mQ.member_key, mm.create_date = mQ.create_date, mm.bundle_no = mQ.bundle_no, mm.part_cd = mQ.part_cd, mm.hist_type = mQ.hist_type\n")
							.append("	WHEN NOT MATCHED THEN\n")
							.append("	INSERT (mm.order_no, mm.lotno, mm.hist_no, mm.member_key, mm.create_date, mm.bundle_no, mm.part_cd, mm.hist_type)\n")
							.append("	VALUES (mQ.order_no, mQ.lotno, mQ.hist_no, mQ.member_key, mQ.create_date, mQ.bundle_no, mQ.part_cd, mQ.hist_type)\n")
							.toString();
					
			}
				
			// System.out.println(sql.toString());
			resultInt = super.excuteUpdate(con, sql.toString());
			if (resultInt < 0) {
				con.rollback();
				return EventDefine.E_DOEXCUTE_ERROR ;
			}
			con.commit();
			
			
		} catch(Exception e) {
			LoggingWriter.setLogError("M202S020100E161()","==== SQL ERROR ===="+ e.getMessage() + "\n" + sql.toString());
			e.printStackTrace();
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M202S020100E161()","==== finally ===="+ e.getMessage());
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
	
	//이력번호정보(소고기)
	public int E164(InoutParameter ioParam){
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
					.append("		A.member_key,\n")
					.append("		userid,\n")
					.append("		apikey,\n")
					.append("		calltype,\n")
					.append("		proctype,\n")
					.append("		seq_no,\n")
					.append("		refno,\n")
					.append("		inymd,\n")
					.append("		returnyn,\n")
					.append("		DECODE(returnyn,'Y','반품입고','N','일반매입') AS returnyn,\n")
					.append("		cattlelottype AS 이력타입,\n")
					.append("		DECODE(cattlelottype,'C','이력','L','묶음') AS cattlelottype,\n")
					.append("		cattleno AS 이력번호,\n")
					.append("		A.lotno,\n")
					.append("		partcd,\n")
					.append("		partnm,\n")
					.append("		inweight,\n")
					.append("		incorpno,\n")
					.append("		incorpnm,\n")
					.append("		incorpaddr,\n")
					.append("		requestdate,\n")
					.append("		requestyn,\n")
					.append("		erroryn,\n")
					.append("		errorcontents,\n")
					.append("		revno,\n")
					.append("		B.create_date,\n")
					.append("		incorptp,\n")
					.append("		DECODE(incorptp,'077001','도축장','077010','가공장','077020','판매장') AS incorptp,\n")
					.append("		bigo,\n")
					.append("		'' AS	parttype,\n")
					.append("		'' AS	parttype_nm,\n")
					.append("		'' AS	incorpownernm,\n")
					.append("		'' AS	incorptel,\n")
					.append("		'' AS	inplacenm,\n")
					.append("		'' AS	inplacenm_nm,\n")
					.append("		'' AS 	intypenm,\n")
					.append("		'' AS 	intypenm_nm,\n")
					.append("		'' AS 	totweight,\n")
					.append("		'' AS 	butcheryno,\n")
					.append("		'' AS 	gradecd\n")
					.append("FROM\n")
					.append("		tbi_declaration_cattle_purchase A\n")
					.append("		INNER JOIN haccp_hysteretic_system B\n")
					.append("		ON A.cattleno = B.hist_no\n")
					.append("		AND A.member_key = B.member_key\n")
					.append("WHERE\n")
					.append("		B.order_no = '" + jArray.get("order_no") + "' \n")
					.append("		and B.lotno = '" + jArray.get("lotno") + "' \n")
					.append("AND A.member_key = '" + jArray.get("member_key") + "' 	\n")
					.append("UNION ALL\n")
					.append("SELECT \n")
					.append("		A.member_key,\n")
					.append("		userid,\n")
					.append("		apikey,\n")
					.append("		calltype,\n")
					.append("		proctype,\n")
					.append("		seq_no,\n")
					.append("		refno,\n")
					.append("		inymd,\n")
					.append("		returnyn,\n")
					.append("		DECODE(returnyn,'Y','반품입고','N','일반매입') AS returnyn,\n")
					.append("		piglottype,\n")
					.append("		DECODE(piglottype,'C','이력','L','묶음') AS piglottype,\n")
					.append("		pigno,\n")
					.append("		A.lotno,\n")
					.append("		partcd,\n")
					.append("		partnm,\n")
					.append("		inweight,\n")
					.append("		incorpno,\n")
					.append("		incorpnm,\n")
					.append("		incorpaddr,\n")
					.append("		requestdate,\n")
					.append("		requestyn,\n")
					.append("		erroryn,\n")
					.append("		errorcontents,\n")
					.append("		revno,\n")
					.append("		B.create_date,\n")
					.append("		'',\n")
					.append("		'',\n")
					.append("		'',\n")
					.append("		parttype,\n")
					.append("		DECODE(parttype,'T','지육','P','정육') AS parttype,\n")
					.append("		incorpownernm,\n")
					.append("		incorptel,\n")
					.append("		inplacenm,\n")
					.append("		DECODE(inplacenm,'503010','도축장','503020','가공장','503030','판매장') AS inplacenm,\n")
					.append("		intypenm,\n")
					.append("		DECODE(intypenm,'511010','자체매입분','511020','외부매입분') AS intypenm,\n")
					.append("		totweight,\n")
					.append("		butcheryno,\n")
					.append("		gradecd\n")
					.append("FROM\n")
					.append("		tbi_declaration_pig_purchase A\n")
					.append("		INNER JOIN haccp_hysteretic_system B\n")
					.append("		ON A.pigno = B.hist_no\n")
					.append("		AND A.member_key = B.member_key\n")
					.append("WHERE\n")
					.append("		B.order_no = '" + jArray.get("order_no") + "' \n")
					.append("		and B.lotno = '" + jArray.get("lotno") + "' \n")
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
			LoggingWriter.setLogError("M202S020100E164()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M202S020100E164()","==== finally ===="+ e.getMessage());
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
	
	//이력번호정보(돼지고기)
	public int E165(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			System.out.println("JSONObject jArray rcvData="+ jArray.toString());
			
			String sql = new StringBuilder()
					.append("SELECT DISTINCT\n")
					.append("        userid,\n")
					.append("        apikey,\n")
					.append("        calltype,\n")
					.append("        proctype,\n")
					.append("        A.member_key,\n")
					.append("        seq_no,\n")
					.append("        refno,\n")
					.append("        parttype,\n")
					.append("        DECODE(parttype,'T','지육','P','정육') AS parttype,\n")
					.append("        returnyn,\n")
					.append("        DECODE(returnyn,'Y','반품입고','N','일반매입') AS returnyn,\n")
					.append("        inymd,\n")
					.append("        incorpno,\n")
					.append("        incorpnm,\n")
					.append("        incorpownernm,\n")
					.append("        incorptel,\n")
					.append("        incorpaddr,\n")
					.append("        inplacenm,\n")
					.append("        DECODE(inplacenm,'503010','도축장','503020','가공장','503030','판매장') AS inplacenm,\n")
					.append("        intypenm,\n")
					.append("        DECODE(intypenm,'511010','자체매입분','511020','외부매입분') AS intypenm,\n")
					.append("        totweight,\n")
					.append("        piglottype,\n")
					.append("        DECODE(piglottype,'P','이력','L','묶음') AS piglottype,\n")
					.append("        A.lotno,\n")
					.append("        pigno,\n")
					.append("        butcheryno,\n")
					.append("        partcd,\n")
					.append("        partnm,\n")
					.append("        inweight,\n")
					.append("        gradecd,\n")
					.append("        requestdate,\n")
					.append("        requestyn,\n")
					.append("        erroryn,\n")
					.append("        errorcontents,\n")
					.append("        revno,\n")
					.append("        B.create_date\n")
					.append("FROM\n")
					.append("	tbi_declaration_pig_purchase A\n")
					.append("	INNER JOIN haccp_hysteretic_system B\n")
					.append("	ON A.pigno = B.hist_no\n")
					.append("	AND A.member_key = B.member_key\n")
					.append("WHERE A.member_key = '" + jArray.get("member_key") + "'\n")
					.append("	AND B.order_no= '" + jArray.get("order_no") + "'\n")
					.append("	AND B.lotno= '" + jArray.get("lotno") + "'\n")
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
			LoggingWriter.setLogError("M202S020100E165()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M202S020100E165()","==== finally ===="+ e.getMessage());
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
	
	//이력번호 연계테이블 조회
	public int E166(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			System.out.println("JSONObject jArray rcvData="+ jArray.toString());
			
			String sql = new StringBuilder()
					.append("SELECT DISTINCT\n")
					.append("	B.part_nm,\n")
					.append("	order_no,\n")
					.append("	lotno,\n")
					.append("	hist_no,\n")
					.append("	A.member_key,\n")
					.append("	A.create_date,\n")
					.append("	bundle_no,\n")
					.append("	A.part_cd,\n")
					.append("	hist_type,\n")
					.append("	DECODE(hist_type,'C','이력','P','이력','L','묶음') AS hist_type\n")
					.append("FROM\n")
					.append("	haccp_hysteretic_system A\n")
					.append("	INNER JOIN tbm_part_list B\n")
					.append("	ON A.part_cd = B.part_cd\n")
					.append("WHERE A.part_cd= '" + jArray.get("part_cd") + "'\n")
					.append("AND A.order_no= '" + jArray.get("order_no") + "'\n")
					.append("AND A.lotno= '" + jArray.get("lotno") + "'\n")
					.append("AND A.member_key= '" + jArray.get("member_key") + "'\n")
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
			LoggingWriter.setLogError("M202S020100E166()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M202S020100E166()","==== finally ===="+ e.getMessage());
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

	//발주자재검수목록
	public int E904(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			String rcvData = (String)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			String[][] c_paramArray = CommonFunction.getConvString2DoubleArray(rcvData);
			
			String sql = new StringBuilder()
					.append("SELECT\n")
					.append("        A.ORDER_NO,\n")
					.append("        a.balju_no,        \n")
					.append("        P.action_date,									--발주등록일\n")
					.append("        p.user_id,										--발주등록자\n")
					.append("        A.balju_send_date,                              --발주발송일\n")
					.append("        A.BALJU_UPCHE_CD,       						--수신처코드\n")
					.append("        F.CUST_NM as CUST_NM,                           --수신처명\n")
					.append("        A.BALJU_TEXT,                                   --제목\n")
					.append("        v.CODE_NAME AS BALJU_STATUS_NAME,       		--진행상태\n")
					.append("        TO_CHAR(A.balju_nabgi_date, 'YYYY-MM-DD') AS balju_nabgi_date, --입고예정일\n")
					.append("        A.nabpoom_location,								--입고장소		\n")
					.append("        A.qa_ter_condtion,								--품질조건\n")
					.append("        A.BALJU_STATUS,	\n")
					.append("        p.action_process,\n")
					.append("        p.action_lebel\n")
					.append("   FROM   TBI_BALJU A\n")
					.append("        INNER JOIN      tbi_order B	\n")
					.append("                ON  A.ORDER_NO = B.ORDER_NO\n")
					.append("   			 AND A.member_key = B.member_key\n")
					.append("        INNER JOIN vtbm_customer F                --발주고객\n")
					.append("                ON A.BALJU_UPCHE_CD = F.CUST_CD\n")
					.append("   			 AND A.member_key = F.member_key\n")
					.append("        INNER JOIN v_balju_status v\n")
					.append("                ON A.BALJU_STATUS = V.CODE_CD\n")
					.append("   			AND A.member_key = V.member_key\n")
					.append("        INNER JOIN tbi_approval_action P\n")
					.append("        		ON A.ORDER_NO = P.actionno\n")
					.append("   			AND A.member_key = P.member_key\n")
					.append("   WHERE   1=1\n")
					.append("        AND A.balju_send_date >= '" + c_paramArray[0][0] + "'    \n")
					.append("        AND A.balju_send_date <= '" + c_paramArray[0][1] + "'    \n")
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
			LoggingWriter.setLogError("M202S020100E904()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M202S020100E904()","==== finally ===="+ e.getMessage());
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

	public int E999(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			System.out.println("JSONObject jArray rcvData="+ jArray.toString());
			String sql = new StringBuilder()
					.append("WITH order_balju AS(\n")
					.append("	SELECT balju_no FROM tbi_balju WHERE order_no = '" + jArray.get("order_no") + "' AND lotno='" + jArray.get("lotno") + "'\n")
					.append("),\n")
					.append("balju_list_cnt AS(\n")
					.append("SELECT COUNT(*)   AS balju_list_Count FROM tbi_balju_list A, order_balju  WHERE A.balju_no= order_balju.balju_no\n")
					.append("),\n")
					.append("balju_Inspect_cnt AS(\n")
					.append("SELECT  COUNT(*) AS balju_Inspect_Count FROM tbi_balju_list_inspect B, order_balju WHERE B.balju_no=order_balju.balju_no\n")
					.append(")\n")
					.append("SELECT  ' 주문번호: " + jArray.get("order_no") + ",Lot No: " + jArray.get("lotno") + "의 발주원부자재 수: ' || balju_list_Count || '건,'  || \n")
					.append("		' 발주원부자재 검수 수:' || balju_Inspect_Count || '건,'  , \n")
					.append("		balju_list_Count,\n")
					.append("		balju_Inspect_Count \n")
					.append("FROM balju_list_cnt, balju_Inspect_cnt;\n")
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
			LoggingWriter.setLogError("M202S020100E999()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M202S020100E999()","==== finally ===="+ e.getMessage());
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