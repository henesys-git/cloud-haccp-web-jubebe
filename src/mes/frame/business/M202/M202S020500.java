package mes.frame.business.M202;

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
import mes.frame.util.CommonFunction;


public class M202S020500 extends SqlAdapter{
	Connection con = null;
	PreparedStatement pstmt = null;
	String resultString = "";
	int resultInt = -1;
	StringBuffer sql = new StringBuffer();
	
	String[][] v_paramArray = new String[0][0]; 
	Class[] optClass = null;
	Object[] optObj = null;
	Object obj = null;
	
	public M202S020500(){
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
			
			Method method = M202S020500.class.getMethod(event,optClass);
			LoggingWriter.setLogDebug(M202S020500.class.getName(),"==== " + event + " EventMethod Create Success ====");

			obj = method.invoke(M202S020500.class.newInstance(),optObj);
			doExcute_result = CommonFunction.getInt(obj.toString());
			
	    } catch (Exception ex) {
	    	doExcute_result = EventDefine.E_DOEXCUTE_INIT;
			ioParam.setMessage(MessageDefine.M_NO_EVENTID);
			LoggingWriter.setLogError(M202S020500.class.getName(),"==== EventID Not define : EVENT ID [ " + ioParam.getEventID() + "]");
	    } finally {
	    	obj = null;
			optClass = null;
			optObj = null;
	    }
	    long endTime = System.currentTimeMillis();
		long runningTime = endTime - startTime;
		LoggingWriter.setLogAll(M202S020500.class.getName(),"==== Query [수행시간  : " + runningTime + " ms]");
		
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
    		
    		String jspPage = (String)jArrayHead.get("jsp_page");
    		String user_id = (String)jArrayHead.get("user_id");
    		String prefix = (String)jArrayHead.get("prefix");
    		String actionGubun = "Regist";
    		String detail_seq = (String)jArrayHead.get("detail_seq");
    		String member_key = (String)jArrayHead.get("member_key");
    		
	    	for(int i=0; i<jjArray.size(); i++) { 
	    		JSONObject jjjArray = (JSONObject)jjArray.get(i);
	    		 sql = new StringBuilder()
					.append("MERGE  INTO tbi_balju_list_inspect  mm     \n")
					.append("USING ( SELECT     \n")
					.append(" 		 '" + jArrayHead.get("order_no") + "'  as order_no		\n") //order_no
					.append(" 		,'" + jjjArray.get("balju_no") + "'  as balju_no		\n") //balju_no
					.append(" 		,'" + jjjArray.get("balju_seq") + "'  as balju_seq		\n") //balju_seq
//					.append(" 		,'" + balju_inspect_no + "'     	  as balju_inspect_no	\n") //balju_inspect_no
					.append(" 		,'" + jjjArray.get("bom_nm") + "'  as bom_nm		\n") //bom_nm			
					.append(" 		,'" + jjjArray.get("bom_cd") + "'  as bom_cd	\n") //bom_cd
					.append(" 		,'" + jjjArray.get("part_cd") + "'  as part_cd		\n") //part_cd
					.append(" 		,'" + jjjArray.get("gyugeok") + "'  as gyugeok		\n") //gyugeok	
					.append(" 		,'" + jjjArray.get("balju_count") + "'  as balju_count	\n") //balju_count 
					.append(" 		,'" + jjjArray.get("inspect_count") + "'  as inspect_count	\n") //inspect_count
					.append(" 		,'" + jjjArray.get("list_price") + "'  as list_price 	\n") //list_price
					.append(" 		,'" + jjjArray.get("balju_amt") + "' as balju_amt 		\n") //balju_amt
					.append(" 		,'" + jjjArray.get("rev_no") + "' as rev_no 		\n") //rev_no
					.append(" 		,'" + jjjArray.get("part_cd_rev") + "' as part_cd_rev 	\n") //part_cd_rev
					.append(" 		,'" + jjjArray.get("inspect_seq") + "' as inspect_seq 	\n") //part_cd_rev
					.append(" 		,'" + jjjArray.get("lotno") + "' as lotno 	\n") //part_cd_rev
					.append(" 		,'" + jArrayHead.get("member_key") + "' as member_key 	\n") //member_key
					.append("	  )  mQ    \n")	
					.append("ON (mm.inspect_seq = mQ.inspect_seq  "
							+ " AND mm.bom_cd = mQ.bom_cd  "
							+ " AND mm.part_cd = mQ.part_cd  "
							+ " AND mm.part_cd_rev = mQ.part_cd_rev"
							+ " AND mm.lotno = mQ.lotno "
							+ " AND mm.order_no=mQ.order_no "
							+ " AND mm.balju_no=mQ.balju_no "
							+ " AND mm.balju_seq=mQ.balju_seq "		
							+ " AND mm.member_key=mQ.member_key)\n")		
					.append("WHEN MATCHED THEN     \n")
					.append("		UPDATE SET     \n")
					.append("			mm.order_no		= mQ.order_no,		mm.balju_no		= mQ.balju_no,		mm.balju_seq 		= mQ.balju_seq,		"
							+ "mm.bom_nm	= mQ.bom_nm,	\n")
					.append("			mm.bom_cd	= mQ.bom_cd,	 	mm.part_cd			= mQ.part_cd,   		mm.gyugeok 		= mQ.gyugeok,	    \n")
					.append("			mm.balju_count	= mQ.balju_count,	mm.inspect_count	= mQ.inspect_count,	mm.list_price		= mQ.list_price,   		mm.balju_amt 	= mQ.balju_amt,	    \n")
					.append("			mm.rev_no		= mQ.rev_no,		mm.part_cd_rev		= mQ.part_cd_rev, mm.lotno = mQ.lotno, mm.member_key=mQ.member_key	\n")
					.append("WHEN NOT MATCHED THEN     \n")
					.append("	INSERT  (mm.order_no, mm.balju_no, mm.balju_seq, "
							+ " mm.bom_nm, mm.bom_cd, mm.part_cd, mm.gyugeok,	mm.balju_count, mm.inspect_count,mm.inspect_seq,"
							+ " mm.list_price, mm.balju_amt, mm.rev_no, mm.part_cd_rev, mm.lotno, mm.member_key)    \n")
					.append("	VALUES  ( mQ.order_no, mQ.balju_no, mQ.balju_seq, "
							+ " mQ.bom_nm, mQ.bom_cd, mQ.part_cd, mQ.gyugeok, mQ.balju_count, mQ.inspect_count,mQ.inspect_seq,"
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
			LoggingWriter.setLogError("M202S020500E101()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M202S020500E101()","==== finally ===="+ e.getMessage());
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
    		
	    	for(int i=0; i<c_paramArray_Detail.length; i++) { 

	    		 sql = new StringBuilder()
					.append("MERGE  INTO tbi_import_inspect_request  mm     \n")
					.append("USING ( SELECT     \n")
					.append(" 		 '" + c_paramArray_Detail[i][0] + "'  as order_no		\n") 	//order_no
					.append(" 		,'" + c_paramArray_Detail[i][1] + "'  as balju_no		\n") 	//balju_no
					.append(" 		,nvl(" + c_paramArray_Detail[i][2] + ",0)  as order_detail_seq \n") 	//order_detail_seq			
					.append(" 		,'" + c_paramArray_Detail[i][3] + "'  as balju_seq		\n") 	//balju_seq
					.append(" 		,'" + c_paramArray_Detail[i][4] + "'  as bom_cd	\n") 	//bom_cd	
					.append(" 		,'" + c_paramArray_Detail[i][5] + "'  as bom_nm		\n") 	//bom_nm	
					.append(" 		,'" + c_paramArray_Detail[i][7] + "'  as part_cd		\n") 	//part_cd 
					.append(" 		,'" + c_paramArray_Detail[i][8] + "'  as write_date		\n") 	//write_date
					.append(" 		,'" + c_paramArray_Detail[i][9] + "'  as ipgo_date 		\n") 	//ipgo_date
					.append(" 		,'" + c_paramArray_Detail[i][10] + "' as ingae_date 	\n") 	//ingae_date
					.append(" 		,'" + c_paramArray_Detail[i][11] + "' as inspect_report_yn	\n") //inspect_report_yn
					.append(" 		,'" + c_paramArray_Detail[i][12] + "' as inspect_end_date	\n") //inspect_end_date
					.append(" 		,'" + c_paramArray_Detail[i][13] + "' as txt_inspect_note	\n") //txt_inspect_note
					.append(" 		," + c_paramArray_Detail[i][14] + " as req_count 			\n") //req_count
					.append(" 		," + c_paramArray_Detail[i][15] + " as part_cd_rev 		\n") //part_cd_rev
					.append(" 		,'" + c_paramArray_Detail[i][16] + "' as member_key 	\n") //member_key
					.append("	  )  mQ    \n")
					.append("ON (mm.order_no = mQ.order_no AND mm.balju_no = mQ.balju_no AND mm.balju_seq = mQ.balju_seq AND mm.bom_cd = mQ.bom_cd "
							+ "AND mm.part_cd = mQ.part_cd  AND mm.part_cd_rev = mQ.part_cd_rev AND mm.member_key=mQ.member_key)    \n")
					.append("WHEN MATCHED THEN     \n")
					.append("	UPDATE SET     \n")
					.append("		mm.order_no		= mQ.order_no,		mm.balju_no		= mQ.balju_no,		mm.balju_seq 		= mQ.balju_seq,			mm.bom_nm		= mQ.bom_nm,	\n")
					.append("		mm.bom_cd	= mQ.bom_cd,			mm.part_cd		= mQ.part_cd,		mm.write_date 		= mQ.write_date,	\n")
					.append("		mm.ipgo_date	= mQ.ipgo_date,		mm.ingae_date	= mQ.ingae_date,	mm.inspect_report_yn= mQ.inspect_report_yn,	mm.inspect_end_date	= mQ.inspect_end_date,	\n")
					.append("		mm.req_count	= mQ.req_count,		mm.part_cd_rev	= mQ.part_cd_rev,	mm.order_detail_seq	= mQ.order_detail_seq, mm.member_key=mQ.member_key	\n")
					.append("WHEN NOT MATCHED THEN     \n")
					.append("	INSERT  (mm.order_no, mm.balju_no, 			mm.balju_seq, mm.order_detail_seq, 	mm.bom_nm, mm.bom_cd, mm.part_cd, mm.write_date,	mm.ipgo_date, mm.ingae_date,"
							+ " mm.inspect_report_yn, mm.inspect_end_date, 	mm.req_count, mm.part_cd_rev, mm.member_key)    	\n")
					.append("	VALUES  (mQ.order_no, mQ.balju_no, 			mQ.balju_seq, mQ.order_detail_seq, 	mQ.bom_nm, mQ.bom_cd, mQ.part_cd, mQ.write_date,	mQ.ipgo_date, mQ.ingae_date,"
							+ " mQ.inspect_report_yn, mQ.inspect_end_date, 	mQ.req_count, mQ.part_cd_rev, mQ.member_key)    	\n")
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
			LoggingWriter.setLogError("M202S020500E111()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M202S020500E111()","==== finally ===="+ e.getMessage());
				}
	    	} else {
	    	}
	    }
		ioParam.setResultString(resultString);
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
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
			
			String sql = new StringBuilder()
					.append("SELECT DISTINCT\n")
					.append("	C.cust_nm,  		--고객사\n")
					.append("	B.product_nm || '('||D.code_name  ||','||  E.code_name ||')',  		--제품명\n")
					.append("	cust_pono,			--PO번호\n")
        			.append("	product_gubun,		--제품구분\n")
        			.append("	part_source,   		--원부자재공급\n")
					.append("	order_date,      	--주문일\n")
					.append("	A.lotno,           	--lot번호\n")
					.append("	lot_count,    		--lot수량\n")
					.append("	part_chulgo_date,	--회로자재출고일\n")
					.append("	rohs,				--rohs\n")
					.append("	order_note,			--특이사항\n")
					.append("	delivery_date,   	--납기일\n")
					.append("	bom_version,		\n")
					.append("	A.order_no,    		--주문번호\n")
					.append("	S.process_name,		--현상태명\n")
					.append("	A.bigo,         	--비고\n")
					.append("	product_serial_no, 		--일련번호\n")
					.append("	product_serial_no_end, 	--일련번호끝  \n")
					.append("	A.cust_cd,\n")
					.append("	A.cust_rev,\n")
					.append("	A.prod_cd,\n")
					.append("	A.prod_rev,\n")
					.append("	Q.order_status,\n")
        			.append("	DECODE(product_gubun,'0','양산품','1','개발품') AS product_gubun,	--제품구분\n")
        			.append("	DECODE(part_source,'01','사급','02','도급','03','사급&도급') AS part_source,   		--원부자재공급\n")
					.append("	DECODE(rohs,'0','Pb Free','1','Pb') AS rohs,					--rohs\n")
					.append("	L.balju_no\n")
					.append("FROM tbi_order A\n")
					.append("INNER JOIN tbm_customer C\n")
					.append("        ON A.cust_cd = C.cust_cd\n")
					.append("        and A.cust_rev = C.revision_no\n")
					.append("  		AND A.member_key = C.member_key\n")
					.append("INNER JOIN tbi_queue Q\n")
					.append("        ON A.order_no = Q.order_no\n")
					.append("        AND A.lotno = Q.lotno\n")
					.append("   	AND A.member_key = Q.member_key\n")
					.append("INNER JOIN tbm_systemcode S\n")
					.append("        ON Q.order_status = S.status_code\n")
					.append("        AND Q.process_gubun = S.process_gubun\n")
					.append("  		 AND Q.member_key = S.member_key\n")
					.append("INNER JOIN tbm_product B\n")
					.append("        ON A.prod_cd = B.prod_cd\n")
					.append("        and  A.prod_rev = B.revision_no\n")
					.append("  		 AND A.member_key = B.member_key\n")
					.append("INNER JOIN tbi_balju L \n")
					.append("		 ON A.order_no = L.order_no\n")
					.append("        AND A.lotno = L.lotno\n")
					.append("  		 AND A.member_key = L.member_key\n")
					
					.append("INNER JOIN v_prodgubun_big D 				\n")
					.append("  		  ON B.prod_gubun_b = D.code_value 	\n")
					.append("  		 AND B.member_key = D.member_key 	\n")
					.append("INNER JOIN v_prodgubun_mid E 				\n")
					.append("  		ON B.prod_gubun_m = E.code_value	\n")
					.append("  		 AND B.member_key = E.member_key 	\n")
					.append("WHERE A.cust_cd LIKE '%" 	+ jArray.get("custcode") + "'	\n")
					.append("  AND order_date \n")
					.append("BETWEEN '" + jArray.get("fromdate") + "' 	\n")
					.append("	 AND '" + jArray.get("todate") + "'	\n")
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
			LoggingWriter.setLogError("M202S020500E104()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M202S020500E104()","==== finally ===="+ e.getMessage());
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
					.append("	rev_no, \n")
					.append("	part_cd_rev\n")
					.append("FROM tbi_balju_list_inspect A \n")
					.append("	INNER JOIN tbi_balju B \n")
					.append("	ON B.balju_no = A.balju_no\n")
					.append("   AND B.member_key = A.member_key\n")
					.append("WHERE A.ORDER_NO = '" + jArray.get("order_no") + "' \n")
					.append("AND A.order_detail_seq = '" + jArray.get("order_detail_seq") + "' \n")
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
			LoggingWriter.setLogError("M202S020500E114()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M202S020500E114()","==== finally ===="+ e.getMessage());
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
			
			String sql = new StringBuilder()
					.append("WITH inspect_sum AS (\n")
					.append("	SELECT \n")
					.append("		balju_no,\n")
					.append("        balju_seq,\n")
					.append("        bom_nm,\n")
					.append("        bom_cd,\n")
					.append("        part_cd,\n")
					.append("        gyugeok,\n")
					.append("        balju_count,\n")
					.append("		SUM(inspect_count) AS inspect_count,\n")
					.append("        list_price,\n")
					.append("        balju_amt,\n")
					.append("        rev_no,\n")
					.append("        part_cd_rev,\n")
					.append("        order_no,\n")
					.append("        order_detail_seq,\n")
					.append("        MAX(inspect_seq) AS inspect_seq,\n")
					.append("        lotno,\n")
					.append("        member_key\n")
					.append("	FROM tbi_balju_list_inspect\n")
					.append("	GROUP BY order_no,lotno,balju_no,balju_seq,bom_cd,part_cd,part_cd_rev\n")
					.append(")\n")
					.append("SELECT\n")
					.append("	B.balju_no,\n")
					.append("	balju_seq,\n")
					.append("	bom_nm,\n")
					.append("	bom_cd,\n")
					.append("	part_cd,\n")
					.append("	gyugeok,\n")
					.append("	balju_count,\n")
					.append("	A.inspect_count,\n")
					.append("	list_price,\n")
					.append("	balju_amt,\n")
					.append("	rev_no,\n")
					.append("	part_cd_rev,\n")
					.append("	B.order_no,\n")
					.append("	B.order_detail_seq,\n")
					.append("	A.inspect_seq,\n")
					.append("	B.lotno, \n")
					.append("	A.member_key \n")
					.append("FROM inspect_sum A\n")
					.append("INNER JOIN tbi_balju B\n")
					.append("	ON B.balju_no = A.balju_no\n")
					.append("	AND B.order_no = A.order_no\n")
					.append("	AND B.lotno = A.lotno\n")
					.append("   AND B.member_key = A.member_key\n")
					.append("WHERE\n")
					.append("	balju_count > A.inspect_count\n") // >= 에서 = 뻄
					.append("	AND B.order_no = '" + jArray.get("order_no") + "' 	\n")
					.append("	AND B.lotno = '" 	+ jArray.get("lotno") + "' 		\n")
					.append("	AND B.balju_no = '" + jArray.get("baljuno") + "' 	\n")
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
			LoggingWriter.setLogError("M202S020500E124()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M202S020500E124()","==== finally ===="+ e.getMessage());
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
					.append("AND B.order_detail_seq = '" + jArray.get("order_detail_seq") + "' \n")
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
			LoggingWriter.setLogError("M202S020500E125()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M202S020500E125()","==== finally ===="+ e.getMessage());
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
					.append("AND member_key = '" + jArray.get("member_key") + "' 	\n")
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
			LoggingWriter.setLogError("M202S020500E134()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M202S020500E134()","==== finally ===="+ e.getMessage());
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
			
			String sql = new StringBuilder()
					.append("SELECT\n")
					.append("	balju_no,\n")
					.append("	balju_seq,\n")
					.append("	bom_nm,\n")
					.append("	bom_cd,\n")
					.append("	part_cd,\n")
					.append("	req_count,\n")
					.append("	part_cd_rev\n")
					.append("FROM tbi_import_inspect_request\n")
					.append("WHERE\n")
					.append(" order_no = '" + jArray.get("order_no") + "' \n")
					.append("AND member_key = '" + jArray.get("member_key") + "' 	\n")
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
			LoggingWriter.setLogError("M202S020500E135()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M202S020500E135()","==== finally ===="+ e.getMessage());
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
			LoggingWriter.setLogError("M202S020500E136()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M202S020500E136()","==== finally ===="+ e.getMessage());
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
					.append("WHERE\n")
					.append(" B.order_no = '" + jArray.get("order_no") + "' \n")
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
			LoggingWriter.setLogError("M202S020500E137()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M202S020500E137()","==== finally ===="+ e.getMessage());
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
	
	// 사용여부 모호함
	public int E504(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			String rcvData = (String)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			String[][] c_paramArray = CommonFunction.getConvString2DoubleArray(rcvData);
			
			//  {"순번", "보관위치", "원부자재코드", "구품코드", "원부자재명", "출고량(합)", "입고량(합)", "위치재고량", "안전재고"};  
			String sql = new StringBuilder()
					.append("WITH STORAGE_HIST AS(\n")
					.append("	SELECT machineno, SAVE_LOCATION, PARTCODE,OLD_PARTCODE, PART_NM, SAFETY_JAEGO, POST_AMT,IO_AMT, IO_GUBUN, IO_DATE ,IO_SEQNO,\n")
					.append("	SUM(CASE WHEN IO_GUBUN='O' THEN NVL(IO_AMT,0) END) OVER(PARTITION BY SAVE_LOCATION,PARTCODE)  as SUM_OUT,\n")
					.append("	SUM(CASE WHEN IO_GUBUN='I' THEN NVL(IO_AMT,0) END) OVER(PARTITION BY SAVE_LOCATION,PARTCODE)  as SUM_IN\n")
					/* .append("	from tbi_part_storage_hist A\n") */
					 .append("	from tbi_part_storage A\n") 
					.append("		INNER JOIN TB_PARTLIST B\n")
					.append("		ON A.PARTCODE = PART_CD\n")
					.append("   	AND A.member_key = B.member_key\n")
					.append("	WHERE machineno	= 	'" + c_paramArray[0][0] + "' \n")
					.append("	and   IO_DATE 	>=	'" + c_paramArray[0][1] + "' \n")
					.append("	and   IO_DATE 	<=	'" + c_paramArray[0][2] + "' \n")
					.append(" 	and A.member_key =  '" + c_paramArray[0][3] + "' \n") //member_key
					.append("),\n")
					.append("STORAGE_HIST_RANK AS(\n")
					.append("	SELECT machineno, SAVE_LOCATION, PARTCODE,OLD_PARTCODE, PART_NM, NVL(SAFETY_JAEGO,0) AS SAFETY_JAEGO, IO_AMT,POST_AMT, IO_GUBUN, IO_DATE ,IO_SEQNO,SUM_OUT,SUM_IN,\n")
					.append("	RANK() OVER (PARTITION BY SAVE_LOCATION,PARTCODE ORDER BY SAVE_LOCATION, PARTCODE DESC, IO_DATE DESC,IO_SEQNO DESC) as rk\n")
					.append("	from STORAGE_HIST\n")
					.append("),\n")
					.append("STORAGE_HIST_TOP AS (\n")
					.append("	SELECT machineno, SAVE_LOCATION, PARTCODE,OLD_PARTCODE, PART_NM, SAFETY_JAEGO, IO_AMT, POST_AMT, IO_GUBUN, IO_DATE ,IO_SEQNO ,nvl(SUM_OUT,0) AS SUM_OUT ,nvl(SUM_IN,0) AS SUM_IN\n")
					.append("	FROM STORAGE_HIST_RANK \n")
					.append("	WHERE rk=1 \n")
//					.append("	ORDER BY SAVE_LOCATION,PARTCODE\n")
					.append(")\n")
					.append("SELECT\n")
					.append("	SAVE_LOCATION\n")
					.append("	,PARTCODE\n")
					.append("	,OLD_PARTCODE\n")
					.append("	,PART_NM\n")
					.append("	,SUM_OUT\n")
					.append("	,SUM_IN\n")
					.append("	,POST_AMT\n")
					.append("	,SAFETY_JAEGO\n")
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
			LoggingWriter.setLogError("M202S020500E504()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M202S020500E504()","==== finally ===="+ e.getMessage());
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

	// 사용여부 모호함 테이블도 없음
	public int E514(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			// 클라이언트로 부터 받은 파라미터를 옮겨 담는다.
			String rcvData = (String)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			// 클라이언트로 부터 받은 파라미터를 쪼개어서 배열에 담는다.
			// rcvData = [위경도]
			String[][] c_paramArray = CommonFunction.getConvString2DoubleArray(rcvData);
			/*{ "원부자재코드", "원부자재명", "구품번", "구도면","단위무게","규격","안전재고","열처리", "재질","후처리"}; */
			String sql = new StringBuilder()
					.append("SELECT\n")
					.append("	PART_CD\n")
					.append("	coalesce(PART_NM, ' ') 		AS PARTNAME,		\n")
					.append("	coalesce(OLD_PARTCODE, ' ') 	AS OLD_PARTCODE,	\n")
					.append(" 	coalesce(OLD_DWG, ' ') 		AS OLD_DRAWCODE,	\n")
					.append(" 	coalesce(UNIT_WEIGHT, '0') 	AS UNIT_WEIGHT,	\n")
					.append("  	coalesce(GYUGYEOK, ' ') 		AS GYUGYEOK,		\n")
					.append(" 	coalesce(SAFETY_JAEGO, '0') 	AS SAFETY_JAEGO,	\n")
					.append(" 	coalesce(P_HEAT, ' ') 			AS HEAT_TREAT,	\n")
					.append(" 	coalesce(P_MATERIAL, ' ') 		AS MATERIAL,	\n")
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
					LoggingWriter.setLogError("M202S020500E514()","==== finally ===="+ e.getMessage());
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
			
			// 클라이언트로 부터 받은 파라미터를 옮겨 담는다.
			String rcvData = (String)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			// 클라이언트로 부터 받은 파라미터를 쪼개어서 배열에 담는다.
			// rcvData = [위경도]
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
					.append("        TO_CHAR(A.balju_nabgi_date, 'YYYY-MM-DD') as balju_nabgi_date, --입고예정일\n")
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
					.append("   		     AND A.member_key = F.member_key\n")
					.append("        INNER JOIN v_balju_status v\n")
					.append("                ON A.BALJU_STATUS = V.CODE_CD\n")
					.append("   			 AND A.member_key = V.member_key\n")
					.append("        INNER JOIN tbi_approval_action P\n")
					.append("        		ON A.ORDER_NO = P.actionno\n")
					.append("   			AND A.member_key = P.member_key\n")
					.append("   WHERE   1=1\n")

					.append("        AND A.balju_send_date >= '" + c_paramArray[0][0] + "'    \n")
					.append("        AND A.balju_send_date <= '" + c_paramArray[0][1] + "'    \n")
					.append("        AND A.member_key 		= '" + c_paramArray[0][2] + "'    \n")
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
			LoggingWriter.setLogError("M202S020500E904()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M202S020500E904()","==== finally ===="+ e.getMessage());
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
			String rcvData = (String)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			String[][] c_paramArray = CommonFunction.getConvString2DoubleArray(rcvData);
			String sql = new StringBuilder()
					.append("WITH order_balju AS(\n")
					.append("	SELECT balju_no FROM tbi_balju WHERE order_no = '" + c_paramArray[0][0] + "'\n")
					.append("),\n")
					.append("balju_list_cnt AS(\n")
					.append("SELECT COUNT(*)   AS balju_list_Count FROM tbi_balju_list A, order_balju  WHERE A.balju_no= order_balju.balju_no\n")
					.append("),\n")
					.append("balju_Inspect_cnt AS(\n")
					.append("SELECT  COUNT(*) AS balju_Inspect_Count FROM tbi_balju_list_inspect B, order_balju WHERE B.balju_no=order_balju.balju_no\n")
					.append("),\n")
					.append("import_request_cnt AS(\n")
					.append("SELECT  COUNT(*) AS import_request_Count FROM tbi_import_inspect_request C, order_balju WHERE order_no ='" + c_paramArray[0][0] + "' AND C.balju_no=order_balju.balju_no\n")
					.append(")\n")
					.append("SELECT  ' 주문번호: " + c_paramArray[0][0] + "의 발주원부자재 수: ' || balju_list_Count || '건,'  || \n")
					.append("		' 발주원부자재 검수 수:' || balju_Inspect_Count || '건,'  || \n")
					.append("		' 발주원부자재 수입검사 신청 수:' || import_request_Count || '건' , \n")
					.append("		balju_list_Count,\n")
					.append("		balju_Inspect_Count ,\n")
					.append("		import_request_Count \n")
					.append("FROM balju_list_cnt, balju_Inspect_cnt, import_request_cnt;\n")
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
			LoggingWriter.setLogError("M202S020500E999()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M202S020500E999()","==== finally ===="+ e.getMessage());
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

