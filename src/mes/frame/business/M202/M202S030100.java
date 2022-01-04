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
import mes.client.util.TraceKeyGenerator;
import mes.frame.common.EventDefine;
import mes.frame.common.HashObject;
import mes.frame.common.MessageDefine;
import mes.frame.database.JDBCConnectionPool;
import mes.frame.database.SqlAdapter;
import mes.frame.serviceinterface.InoutParameter;
import mes.frame.serviceinterface.LoggingWriter;
import mes.frame.util.CommonFunction;

public class M202S030100 extends SqlAdapter{
	Connection con = null;
	PreparedStatement pstmt = null;
	String resultString = "";
	int resultInt = -1;
	StringBuffer sql = new StringBuffer();
	
	String[][] v_paramArray = new String[0][0]; 
	Class[] optClass = null;
	Object[] optObj = null;
	Object obj = null;
	
	public M202S030100(){
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
			
			Method method = M202S030100.class.getMethod(event,optClass);
			LoggingWriter.setLogDebug(M202S030100.class.getName(),"==== " + event + " EventMethod Create Success ====");

			obj = method.invoke(M202S030100.class.newInstance(),optObj);
			doExcute_result = CommonFunction.getInt(obj.toString());
			
	    } catch (Exception ex) {
	    	doExcute_result = EventDefine.E_DOEXCUTE_INIT;
			ioParam.setMessage(MessageDefine.M_NO_EVENTID);
			LoggingWriter.setLogError(M202S030100.class.getName(),"==== EventID Not define : EVENT ID [ " + ioParam.getEventID() + "]");
	    } finally {
	    	obj = null;
			optClass = null;
			optObj = null;
	    }
	    long endTime = System.currentTimeMillis();
		long runningTime = endTime - startTime;
		LoggingWriter.setLogAll(M202S030100.class.getName(),"==== Query [수행시간  : " + runningTime + " ms]");
		
		return doExcute_result;
	}
	
	/* 
	 * 역할 : 자재입고등록 
	 * 설명 :
	 * 1. 발주상태를 입고완료로 변경
	 * 2. 재고 테이블의 재고를 늘림 (tbi_part_ipgo, tbi_part_storage)
	 * */
	public int E101(InoutParameter ioParam) {
		resultInt = EventDefine.E_DOEXCUTE_INIT;

		String sql ="";
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArr = new JSONObject();
    		jArr = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			
			con.setAutoCommit(false);
    		
    		sql = new StringBuilder()
				.append("UPDATE tbi_balju_list2 								\n")
				.append("SET balju_status = '입고완료'								\n")
				.append("WHERE part_cd = '"+jArr.get("part_cd")+"'				\n")
				.append("	AND part_rev_no = '"+jArr.get("part_rev_no")+"'		\n")
				.append("	AND balju_no = '"+jArr.get("balju_no")+"'			\n")
				.append("	AND	balju_rev_no = '"+jArr.get("balju_rev_no")+"'	\n")
				.append("	AND trace_key = '" + jArr.get("trace_key") + "'		\n")
				.toString();
    		 
				resultInt = super.excuteUpdate(con, sql);
	    		if (resultInt < 0) {
					ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
					con.rollback();
					return EventDefine.E_DOEXCUTE_ERROR ;
				}
	    	
	    	// 해당 발주의 다른 품목의 발주상태가 '대기'인 개수 조회
    		sql = new StringBuilder()
    				.append("SELECT												\n")
    				.append("	COUNT(*)										\n")
    				.append("FROM												\n")
    				.append("	tbi_balju_list2									\n")
    				.append("WHERE balju_no = '"+jArr.get("balju_no")+"'		\n")
    				.append("	AND balju_rev_no = "+jArr.get("balju_rev_no")+"	\n")
    				.append("	AND trace_key = '" + jArr.get("trace_key") + "'	\n")
    				.append("	AND part_cd != '"+jArr.get("part_cd")+"'		\n")
    				.append("	AND balju_status = '대기'							\n")
    				.toString();
    		
    		resultString = super.excuteQueryString(con, sql).trim();
    		
    		if(resultString.equals("0")) {
    			// 해당 발주의 다른 품목 중 '대기' 상태가 없을 경우
    			// 발주 메인 테이블 '입고완료'로 변경
    			// '대기' 상태가 하나라도 있을 경우 '부분입고'로 변경
    			sql = new StringBuilder()
    		    		.append("UPDATE tbi_balju2 										\n")
    					.append("SET balju_status = '입고완료'								\n")
    					.append("	WHERE balju_no = '"+jArr.get("balju_no")+"'			\n")
    					.append("	AND	balju_rev_no = '"+jArr.get("balju_rev_no")+"'	\n")
    					.append("	AND trace_key = '" + jArr.get("trace_key") + "'		\n")
    					.toString();
    	    		 
				resultInt = super.excuteUpdate(con, sql);
	    		if (resultInt < 0) {
					ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
					con.rollback();
					return EventDefine.E_DOEXCUTE_ERROR ;
				}
    		} else {
    			sql = new StringBuilder()
    		    		.append("UPDATE tbi_balju2 										\n")
    					.append("SET balju_status = '부분입고'								\n")
    					.append("	WHERE balju_no = '"+jArr.get("balju_no")+"'			\n")
    					.append("	AND	balju_rev_no = '"+jArr.get("balju_rev_no")+"'	\n")
    					.append("	AND trace_key = '" + jArr.get("trace_key") + "'		\n")
    					.toString();
    	    		 
				resultInt = super.excuteUpdate(con, sql);
	    		if (resultInt < 0) {
					ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
					con.rollback();
					return EventDefine.E_DOEXCUTE_ERROR ;
				}
    		}
    			
    		sql = new StringBuilder()
				.append("INSERT INTO tbi_part_storage2(				\n")
				.append("		trace_key,							\n")
				.append("		part_cd, 							\n")
				.append("		part_rev_no, 						\n")
				.append("		pre_amt, 							\n")
				.append("		io_amt, 							\n")
				.append("		post_amt, 							\n")
				.append("		warehousing_date, 					\n")
				.append("		expiration_date, 					\n")
				.append("		note 								\n")
				.append("	)										\n")
				.append("VALUES(									\n")
				.append("		'"+jArr.get("trace_key")+"',		\n")
				.append("		'"+jArr.get("part_cd")+"',			\n")
				.append("		'"+jArr.get("part_rev_no")+"',		\n")
				.append("		0,									\n")
				.append("		'"+jArr.get("io_count")+"',			\n")
				.append("		'"+jArr.get("io_count")+"',			\n")
				.append("		'"+jArr.get("warehousing_date")+"',	\n")
				.append("		'"+jArr.get("expiration_date")+"',	\n")
				.append("		'"+jArr.get("bigo")+"'				\n")
				.append("	);\n")
				.toString();

			resultInt = super.excuteUpdate(con, sql.toString());
    		if (resultInt < 0) {
				ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
				con.rollback();
				return EventDefine.E_DOEXCUTE_ERROR ;
			}
    		
    		sql = new StringBuilder()
				.append("INSERT INTO tbi_part_ipgo2 (				\n")
				.append("		trace_key,							\n")
				.append("		part_cd,							\n")
				.append("		part_rev_no,						\n")
				.append("		ipgo_date,							\n")
				.append("		ipgo_time,							\n")
				.append("		ipgo_amount,						\n")
				.append("		ipgo_type,							\n")
				.append("		note								\n")
				.append(")											\n")
				.append("VALUES (									\n")
				.append("		'"+jArr.get("trace_key")+"',		\n")
				.append("		'"+jArr.get("part_cd")+"',			\n")
				.append("		'"+jArr.get("part_rev_no")+"',		\n")
				.append("		'"+jArr.get("warehousing_date")+"',	\n")
				.append("		SYSTIME,							\n")
				.append("		'"+jArr.get("io_count")+"',			\n")
				.append("		'"+jArr.get("ipgo_type")+"',		\n")
				.append("		'"+jArr.get("bigo")+"'				\n")
				.append(");\n")
				.toString();

	    	resultInt = super.excuteUpdate(con, sql);
	    	if (resultInt < 0) {
				ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
				con.rollback();
				return EventDefine.E_DOEXCUTE_ERROR ;
			}
		    	
			con.commit();
		} catch(Exception e) {
			LoggingWriter.setLogError("M202S030100E101()","==== SQL ERROR ===="+ e.getMessage());
			e.printStackTrace();
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M202S030100E101()","==== finally ===="+ e.getMessage());
				}
	    	}
	    }
		ioParam.setResultString(resultString);
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
    	ioParam.setMessage(MessageDefine.M_QUERY_OK);
	    return EventDefine.E_QUERY_RESULT;
	}
		
	public int E121(InoutParameter ioParam){ 
		resultInt = EventDefine.E_DOEXCUTE_INIT;

		String sql ="";

		ApprovalActionNo ActionNo;
		String ipgo_no="";
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject();
    		jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			
    		JSONObject jArrayHead = (JSONObject) jArray.get("paramHead");
    		JSONArray jjArray = (JSONArray) jArray.get("param");
    		JSONObject jjjArray = (JSONObject)jjArray.get(0);
			
			con.setAutoCommit(false);

    		String jspPage = (String)jArrayHead.get("jsp_page");
    		String user_id = (String)jArrayHead.get("login_id");
    		String prefix = (String)jArrayHead.get("prefix");
    		String actionGubun = "Regist";
    		String detail_seq 	= "1";
    		String member_key = (String)jjjArray.get("member_key");
			ActionNo = new ApprovalActionNo();
			ipgo_no = ActionNo.getActionNo(con,jspPage,user_id,prefix,actionGubun,detail_seq,member_key);
			
    		sql = new StringBuilder()
    				.append("SELECT NVL(MAX(io_seqno),0)+1\n")
    				.append("FROM tbi_part_ipgo\n")
    				.append("WHERE 1=1\n")
    				.append("	AND order_no ='" 	+ jjjArray.get("order_no") + "'\n")
    				.append("	AND lotno ='" 		+ jjjArray.get("lotno") + "'\n")
    				.append("	AND part_cd = '" 	+ jjjArray.get("part_cd") + "'\n")
    				.append("	AND part_cd_rev = " + jjjArray.get("part_cd_rev") + "\n")
    				.append("	AND member_key = '" + jjjArray.get("member_key") + "'\n")
    				.toString();
    		String io_seqno = excuteQueryString(con, sql.toString()).trim();
		
    		String IO_GUBUN =  (String)jjjArray.get("ipgo_no");//입고번호 있는지 여부
    		
    		String IO_sql="";
    		if(IO_GUBUN.equals("1")){
    			IO_sql  = ipgo_no;	    			
    		}else{
    			IO_sql = IO_GUBUN;
    		}
    		BigDecimal pre_stack = new BigDecimal(String.valueOf(jjjArray.get("post_stack"))); // BigDecimal 소수점계산
    		BigDecimal io_count = new BigDecimal(String.valueOf(jjjArray.get("io_count"))); // 소수점계산
    		BigDecimal post_stack 	= pre_stack.add(io_count);							//계산후 재고수량
    		
    		
			sql = new StringBuilder()
	 			.append("MERGE INTO tbi_part_ipgo	mm\n")
				.append("USING (SELECT	\n")
				.append(" 		'" + jjjArray.get("order_no") 		+ "' AS order_no,	\n") //
				.append(" 		 '" + IO_sql 						+ "' AS ipgo_no,	\n")
				.append(" 		'" + jjjArray.get("ipgo_date") 	+ "'  AS io_date, \n") //
				.append(" 		'" + io_seqno 						+ "' AS io_seqno,	\n") //
				.append("       TO_CHAR(SYSTIME,'HH24:MI:SS')  AS io_time,	\n") //
				.append(" 		'" + jjjArray.get("io_user_id") 	+ "'  AS io_user_id, \n") //			
				.append(" 		'" + jjjArray.get("part_cd") 		+ "'  AS part_cd,	\n") //
				.append(" 		'" + jjjArray.get("part_cd_rev") 	+ "'  AS part_cd_rev, \n") //
				.append(" 		'" + jjjArray.get("store_no") 		+ "'  AS store_no,	\n") //	
				.append(" 		'" + jjjArray.get("reakes") 			+ "'  AS rakes,		\n") //	
				.append(" 		'" + jjjArray.get("plate") 			+ "'  AS plate,		\n") //
				.append(" 		'" + jjjArray.get("colm") 			+ "'  AS colm,		\n") //	
				.append(" 		'" + pre_stack 						+ "'  AS pre_stack,	\n") // 현재고가 이전재고로 가고
				.append(" 		'" + post_stack 					+ "'  AS post_stack,\n") //현재고 + 입출고가 합쳐서서 재고로 바뀜
				.append(" 		'" + jjjArray.get("io_count") 		+ "' AS io_count,	\n") //
				.append(" 		'" + jjjArray.get("bigo") 			+ "' AS bigo,		\n") //
				.append(" 		'" + jjjArray.get("lotno") 			+ "' AS lotno,		\n") //
				.append(" 		'" + jjjArray.get("hist_no") 		+ "' AS hist_no,		\n") //
				.append(" 		'" + jjjArray.get("member_key") 	+ "' AS member_key	\n") //
				.append(" FROM db_root\n")
				.append(" )	mQ\n")
				.append(" ON (mm.order_no = mQ.order_no AND mm.lotno = mQ.lotno AND mm.part_cd = mQ.part_cd AND "
						+ " mm.part_cd_rev = mQ.part_cd_rev AND mm.io_seqno = mQ.io_seqno AND mm.ipgo_no = mQ.ipgo_no AND mm.member_key=mQ.member_key )\n")
				.append(" WHEN MATCHED THEN\n")
				.append(" 		UPDATE SET\n")
				.append(" mm.order_no 		= mQ.order_no,	mm.ipgo_no	= mQ.ipgo_no,	mm.io_date		= mQ.io_date,"
						+ "	mm.io_seqno		= mQ.io_seqno,	mm.io_time	= mQ.io_time,	mm.io_user_id	= mQ.io_user_id,"
						+ " mm.part_cd		= mQ.part_cd, 	mm.part_cd_rev	= mQ.part_cd_rev, mm.store_no = mQ.store_no, "
						+ " mm.rakes		= mQ.rakes,		mm.plate	= mQ.plate,	 	mm.colm			= mQ.colm,"
						+ " mm.pre_stack 	= mQ.pre_stack,	mm.post_stack= mQ.post_stack,	mm.io_count	= mQ.io_count,	"
						+ " mm.bigo			=	mQ.bigo, 	mm.lotno 	= mQ.lotno, mm.hist_no 	= mQ.hist_no, mm.member_key=mQ.member_key\n")
				.append(" WHEN NOT MATCHED THEN \n")
				.append(" 	INSERT (mm.order_no,mm.ipgo_no, mm.io_date, mm.io_seqno, mm.io_time,mm.io_user_id,"
						+ " mm.part_cd,mm.part_cd_rev, mm.store_no, mm.rakes, mm.plate, mm.colm, mm.pre_stack, mm.post_stack, mm.io_count, mm.bigo,	mm.lotno, mm.hist_no, mm.member_key)\n")
				.append(" 	VALUES (mQ.order_no,mQ.ipgo_no, mQ.io_date, mQ.io_seqno, mQ.io_time,mQ.io_user_id,"
						+ " mQ.part_cd,mQ.part_cd_rev, mQ.store_no, mQ.rakes, mQ.plate, mQ.colm, mQ.pre_stack, mQ.post_stack, mQ.io_count, mQ.bigo,	mQ.lotno, mQ.hist_no, mQ.member_key)\n")
				.toString();
    		 
				resultInt = super.excuteUpdate(con, sql.toString());
	    		if (resultInt < 0) {  //
					ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
					con.rollback();
					return EventDefine.E_DOEXCUTE_ERROR ;
				}
    			
			 sql = new StringBuilder()
			 .append("MERGE INTO tbi_part_storage	mm\n")
				.append("USING (SELECT	\n")
				.append("	'" + jjjArray.get("store_no") 	+ "' AS machineno,	\n")		
				.append("	'" + jjjArray.get("part_cd") 	+ "' AS part_cd,		\n") //
				.append("	'" + jjjArray.get("part_cd_rev")+ "' AS part_cd_rev, \n") //
				.append("	'" + jjjArray.get("reakes") 		+ "' AS rakes,		\n") //
				.append("   '" + jjjArray.get("plate") 		+ "' AS plate,		\n") //
				.append("	'" + jjjArray.get("colm") 		+ "' AS colm,		\n") //			
				.append("	'" + pre_stack 					+ "' AS pre_amt,		\n") //현재고가 이전재고로 가고
				.append("	'" + post_stack 				+ "' AS post_amt,	\n") //현재고 + 입출고가 합쳐서서 재고로 바뀜
				.append("	'" + jjjArray.get("io_count") 	+ "' AS io_amt,		\n") //	
				.append(" 	'" + jjjArray.get("member_key") + "' AS member_key,	\n") //
				.append(" 	'" + jjjArray.get("part_nm") 			+ "'  as part_nm,			\n") //	
				.append(" 	TO_CHAR(sysdate,'YYYY-MM-DD') 				  as warehousing_date,			\n") //	
				.append(" 	'" + jjjArray.get("expiration_date") 	+ "'  as expiration_date,			\n") //
				.append(" 	'" + jjjArray.get("bigo") 				+ "'  as bigo,			\n") //
				.append(" 	'" + jjjArray.get("hist_no") 			+ "'  as hist_no			\n") //	
				.append(" FROM db_root\n")
				.append(" )	mQ\n")
				.append(" ON (mm.part_cd = mQ.part_cd AND mm.part_cd_rev = mQ.part_cd_rev AND mm.machineno = mQ.machineno AND "
						+ " mm.rakes = mQ.rakes AND mm.plate = mQ.plate AND mm.colm = mQ.colm AND mm.member_key=mQ.member_key)\n")
				.append(" WHEN MATCHED THEN\n")
				.append("	UPDATE SET\n")
				.append(" mm.machineno 	= mQ.machineno,	mm.part_cd	= mQ.part_cd, 	mm.part_cd_rev	= mQ.part_cd_rev,	mm.rakes	= mQ.rakes,\n")
				.append("mm.plate     	= mQ.plate,  	mm.colm 	= mQ.colm,		mm.pre_amt		= mQ.pre_amt, 		mm.post_amt	= mQ.post_amt, mm.io_amt = mQ.io_amt, mm.member_key=mQ.member_key, mm.part_nm = mQ.part_nm, mm.warehousing_date = mQ.warehousing_date, mm.expiration_date = mQ.expiration_date, mm.bigo = mQ.bigo, mm.hist_no = mQ.hist_no   \n")
				.append("WHEN NOT MATCHED THEN\n")
				.append("	INSERT (mm.machineno,mm.part_cd, mm.part_cd_rev, mm.rakes, mm.plate,mm.colm, mm.pre_amt,mm.post_amt,mm.io_amt, mm.member_key, mm.part_nm, mm.warehousing_date, mm.expiration_date, mm.bigo, mm.hist_no)\n")
				.append("	VALUES (mQ.machineno,mQ.part_cd, mQ.part_cd_rev, mQ.rakes,mQ.plate,mQ.colm, mQ.pre_amt,mQ.post_amt, mQ.io_amt, mQ.member_key, mQ.part_nm, mQ.warehousing_date, mQ.expiration_date, mQ.bigo, mQ.hist_no)\n")
				.toString();

				resultInt = super.excuteUpdate(con, sql.toString());
	    		if (resultInt < 0) {  //
					ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
					con.rollback();
					return EventDefine.E_DOEXCUTE_ERROR ;
				}
	    		
	    		sql = new StringBuilder()
	    				.append("UPDATE \n")
	    				.append("	tbm_part_storage_conf\n")
	    				.append("	SET\n")
	    				.append("	use_yn='Y'\n")
	    				.append("WHERE\n")
	    				.append("	machineno='"	+ jjjArray.get("store_no") + "'\n")
	    				.append("AND rakes='" 		+ jjjArray.get("reakes") 	+ "'\n")
	    				.append("AND plate='" 		+ jjjArray.get("plate") 	+ "'\n")
	    				.append("AND colm='" 		+ jjjArray.get("colm") 	+ "'\n")
	    				.append("AND member_key='" 	+ jjjArray.get("member_key") 	+ "'\n")
	    				.toString();
				resultInt = super.excuteUpdate(con, sql.toString());
	    		if (resultInt < 0) {  //
					ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
					con.rollback();
					return EventDefine.E_DOEXCUTE_ERROR ;
				}
	    		
    		//원재료수불일보 용 이론상 재고 테이블(20-03-31 진욱추가)
	    	sql = new StringBuilder()
	    			.append("MERGE INTO tbi_production_part_storage mm\n")
	    			.append("USING (\n")
	    			.append("	WITH production_part_storage AS (\n")
	    			.append("		SELECT\n")
	    			.append("			A.part_cd,\n")
	    			.append("			A.part_cd_rev,\n")
	    			.append("			A.warehousing_datetime,\n")
	    			.append("			A.post_amt,\n")
	    			.append("			A.expiration_date,\n")
	    			.append("			A.member_key\n")
	    			.append("		FROM tbi_production_part_storage A\n")
	    			.append("		INNER JOIN (\n")
	    			.append("			SELECT\n")
	    			.append("				part_cd,\n")
	    			.append("				part_cd_rev,\n")
	    			.append("				expiration_date,\n")
	    			.append("				MAX(warehousing_datetime) AS max_warehousing_datetime,\n")
	    			.append("				member_key\n")
	    			.append("			FROM tbi_production_part_storage\n")
	    			.append("			GROUP BY part_cd,part_cd_rev,expiration_date,member_key\n")
	    			.append("		) B\n")
	    			.append("		ON A.part_cd = B.part_cd\n")
	    			.append("		AND A.part_cd_rev = B.part_cd_rev\n")
	    			.append("		AND A.expiration_date = B.expiration_date\n")
	    			.append("		AND A.member_key = B.member_key\n")
	    			.append("		AND A.warehousing_datetime=B.max_warehousing_datetime\n")
	    			.append("	), select_input AS (\n")
	    			.append("		SELECT\n")
	    			.append("			'" + jjjArray.get("ipgo_date") + "'||' '||TO_CHAR(SYSTIME,'HH24:MI:SS') AS warehousing_datetime\n")
	    			.append("			,'I' AS io_gubun\n")
	    			.append("			,'" + jjjArray.get("expiration_date") + "'  as expiration_date\n")
	    			.append("			,'" + jjjArray.get("part_cd") + "' AS part_cd\n")
	    			.append("			,'" + jjjArray.get("part_cd_rev") + "' AS part_cd_rev\n")
	    			.append("			,'" + jjjArray.get("part_nm") + "'  as part_nm\n")
	    			.append("			,'" + pre_stack + "' AS pre_amt\n")
	    			.append("			,'" + post_stack + "' AS post_amt\n")
	    			.append("			,'" + jjjArray.get("io_count") + "' AS io_amt\n")
	    			.append("			,'' AS prod_cd\n") // 제품코드 : 빈값
	    			.append("			,0 AS prod_cd_rev\n") // 제품코드rev : 빈값
	    			.append("			,'' AS prod_nm\n") // 제품명 : 빈값
	    			.append("			,'검수된 원재료 입고' AS bigo\n")
	    			.append("			,'" + jjjArray.get("member_key") + "' AS member_key\n")
	    			.append("		FROM db_root\n")
	    			.append("	)\n")
	    			.append("	SELECT\n")
	    			.append("		A.warehousing_datetime,\n")
	    			.append("		A.io_gubun,\n")
	    			.append("		A.expiration_date,\n")
	    			.append("		A.part_cd,\n")
	    			.append("		A.part_cd_rev,\n")
	    			.append("		A.part_nm,\n")
	    			.append("		NVL(B.post_amt,0) AS pre_amt,\n")
	    			.append("		(CAST(NVL(B.post_amt,0) AS NUMERIC(15,3)) + CAST(A.io_amt AS NUMERIC(15,3))) AS post_amt,\n")
	    			.append("		A.io_amt,\n")
	    			.append("		A.prod_cd,\n")
	    			.append("		A.prod_cd_rev,\n")
	    			.append("		A.prod_nm,\n")
	    			.append("		A.bigo,\n")
	    			.append("		A.member_key\n")
	    			.append("	FROM select_input A\n")
	    			.append("	LEFT OUTER JOIN production_part_storage B\n")
	    			.append("		ON A.part_cd = B.part_cd\n")
	    			.append("		AND A.part_cd_rev = B.part_cd_rev\n")
	    			.append("		AND A.expiration_date = B.expiration_date\n")
	    			.append("		AND A.member_key = B.member_key\n")
	    			.append(") mQ\n")
	    			.append("ON (mm.warehousing_datetime=mQ.warehousing_datetime AND mm.io_gubun=mQ.io_gubun\n")
	    			.append("	AND mm.expiration_date=mQ.expiration_date AND mm.part_cd=mQ.part_cd\n")
	    			.append("	AND mm.part_cd_rev=mQ.part_cd_rev AND mm.member_key=mQ.member_key)\n")
	    			.append("WHEN MATCHED THEN\n")
	    			.append("	UPDATE SET mm.warehousing_datetime=mQ.warehousing_datetime, mm.io_gubun=mQ.io_gubun, mm.expiration_date=mQ.expiration_date,\n")
	    			.append("		mm.part_cd=mQ.part_cd, mm.part_cd_rev=mQ.part_cd_rev, mm.part_nm=mQ.part_nm, mm.pre_amt=mQ.pre_amt, mm.post_amt=mQ.post_amt,\n")
	    			.append("		mm.io_amt=mQ.io_amt, mm.prod_cd=mQ.prod_cd, mm.prod_cd_rev=mQ.prod_cd_rev, mm.prod_nm=mQ.prod_nm, mm.bigo=mQ.bigo, mm.member_key=mQ.member_key\n")
	    			.append("WHEN NOT MATCHED THEN\n")
	    			.append("	INSERT (mm.warehousing_datetime, mm.io_gubun, mm.expiration_date, mm.part_cd, mm.part_cd_rev, mm.part_nm,\n")
	    			.append("		mm.pre_amt, mm.post_amt, mm.io_amt, mm.prod_cd, mm.prod_cd_rev, mm.prod_nm, mm.bigo, mm.member_key)\n")
	    			.append("	VALUES (mQ.warehousing_datetime, mQ.io_gubun, mQ.expiration_date, mQ.part_cd, mQ.part_cd_rev, mQ.part_nm,\n")
	    			.append("		mQ.pre_amt, mQ.post_amt, mQ.io_amt, mQ.prod_cd, mQ.prod_cd_rev, mQ.prod_nm, mQ.bigo, mQ.member_key)\n")
	    			.toString();	
	    		
	    	resultInt = super.excuteUpdate(con, sql.toString());
	    	if (resultInt < 0) { 
				ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
				con.rollback();
				return EventDefine.E_DOEXCUTE_ERROR ;
			} 
	    		
	    	//커밋
			con.commit();
		} catch(Exception e) {
			LoggingWriter.setLogError("M202S030100E121()","==== SQL ERROR ===="+ e.getMessage());
			e.printStackTrace();
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M202S030100E121()","==== finally ===="+ e.getMessage());
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
			
			try {
				con = JDBCConnectionPool.getConnection();
				
				JSONObject jArray = new JSONObject();
				jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));

				String sql = new StringBuilder()
						.append("MERGE INTO haccp_hysteretic_system mm \n")
						.append("USING (SELECT \n")
						.append("	'" 	+ jArray.get("order_no") + "' AS order_no,\n")
						.append("	'" 	+ jArray.get("lotno") + "' AS lotno,\n")
						.append("	'" 	+ jArray.get("hist_no") + "' AS hist_no,\n")
						.append("	'" 	+ jArray.get("member_key") + "' AS member_key,\n")
						.append("	'" 	+ jArray.get("create_date") + "' AS create_date\n")
						.append("	FROM db_root\n")
						.append("	) mQ\n")
						.append("	ON (mm.order_no = mQ.order_no AND mm.lotno = mQ.lotno AND mm.hist_no = mQ.hist_no AND mm.member_key = mQ.member_key)\n")
						.append("	WHEN MATCHED THEN\n")
						.append("	UPDATE SET \n")
						.append("	mm.order_no = mQ.order_no, mm.lotno = mQ.lotno, mm.hist_no = mQ.hist_no, mm.member_key = mQ.member_key, mm.create_date = mQ.create_date\n")
						.append("	WHEN NOT MATCHED THEN\n")
						.append("	INSERT (mm.order_no, mm.lotno, mm.hist_no, mm.member_key, mm.create_date)\n")
						.append("	VALUES (mQ.order_no, mQ.lotno, mQ.hist_no, mQ.member_key, mQ.create_date)\n")
						.toString();


				resultInt = super.excuteUpdate(con, sql.toString());
				if (resultInt < 0) {
					ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
				} else {
					ioParam.setMessage(resultInt + "건 " + MessageDefine.M_INSERT_RESULT);
				}
				
		} catch(Exception e) {
			LoggingWriter.setLogError("M202S030100E111()","==== SQL ERROR ===="+ e.getMessage() + "\n" + sql.toString());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M202S030100E111()","==== finally ===="+ e.getMessage());
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

	
	//자재 입고 수정
			public int E102(InoutParameter ioParam){ 
				resultInt = EventDefine.E_DOEXCUTE_INIT;

				String sql ="";

				ApprovalActionNo ActionNo;
				String ipgo_no="";
				
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
		    		String member_key 	= c_paramArray_Detail[0][16];
		    		
		    		
						ActionNo = new ApprovalActionNo();
						ipgo_no = ActionNo.getActionNo(con,jspPage,user_id,prefix,actionGubun,detail_seq,member_key);
		    		
		    		
			    	for(int i=0; i<c_paramArray_Detail.length; i++) { 

			    		 sql = new StringBuilder()
			    				.append("UPDATE tbi_part_ipgo \n")
			    				.append("SET\n")
			    				.append("	order_no = '" + c_paramArray_Detail[i][0] + "',\n")
			    				.append("	ipgo_no = '" + c_paramArray_Detail[i][1] + "',\n")
			    				.append("	io_date = TO_CHAR(sysdate,'YYYY-MM-DD'),\n")
			    				.append("	io_seqno = '" + c_paramArray_Detail[i][3] + "',\n")
			    				.append("	io_time = to_char(SYSTIME,'HH24:MI:SS'),\n")
			    				.append("	io_user_id = '" + c_paramArray_Detail[i][5] + "',\n")
			    				.append("	part_cd = '" + c_paramArray_Detail[i][7] + "',\n")
			    				.append("	part_cd_rev = '" + c_paramArray_Detail[i][8] + "',\n")
			    				.append("	store_no = '" + c_paramArray_Detail[i][9] + "',\n")
			    				.append("	rakes = '" + c_paramArray_Detail[i][10] + "',\n")
			    				.append("	plate = '" + c_paramArray_Detail[i][11] + "',\n")
			    				.append("	colm = '" + c_paramArray_Detail[i][12] + "',\n")
			    				.append("	pre_stack = '" + c_paramArray_Detail[i][13] + "',\n")
			    				.append("	io_count = '" + c_paramArray_Detail[i][14] + "',\n")
			    				.append("	post_stack = '" + c_paramArray_Detail[i][15] + "'\n")
			    				.append("WHERE ipgo_no='"	 + c_paramArray_Detail[i][1] + "'\n")
			    				.append("AND order_no='" 		 + c_paramArray_Detail[i][0] + "'\n")
								.append("AND io_seqno='" 		 + c_paramArray_Detail[i][3] + "'\n")
								.append("AND part_cd='" 		 + c_paramArray_Detail[i][7] + "'\n")
								.append("AND part_cd_rev='" + c_paramArray_Detail[i][8] + "'\n")
								.append("AND member_key='" + c_paramArray_Detail[i][16] + "'\n")
			    				.toString();
			    		 	
							resultInt = super.excuteUpdate(con, sql.toString());
				    		if (resultInt < 0) {  //
								ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
								con.rollback();
								return EventDefine.E_DOEXCUTE_ERROR ;
							}
			    	}			
			    	
					con.commit();
					for(int i=0; i<c_paramArray_Detail.length; i++) { 

						 sql = new StringBuilder()
	    				 .append("MERGE INTO tbi_part_storage	mm\n")
	    					.append("USING (SELECT	\n")
	    					.append("	'" + c_paramArray_Detail[i][9] + "' AS machineno,		\n")
	    					.append("	'" + c_paramArray_Detail[i][7] + "' AS part_cd,			\n") //
	    					.append("	'" + c_paramArray_Detail[i][8] + "' AS part_cd_rev,		\n") //
	    					.append("	'" + c_paramArray_Detail[i][10] + "' AS rakes,			\n") //
	    					.append("	'" + c_paramArray_Detail[i][11] + "' AS plate,			\n") //
	    					.append("	'" + c_paramArray_Detail[i][12] + "' AS colm,			\n") //			
	    					.append(" 	'" + c_paramArray_Detail[i][13] + "' AS pre_amt,		\n") //
	    					.append(" 	'" + c_paramArray_Detail[i][15] + "' AS post_amt,		\n") //
	    					.append(" 	'" + c_paramArray_Detail[i][14] + "' AS io_amt,			\n") //	
	    					.append(" 	'" + c_paramArray_Detail[i][15] + "' AS member_key			\n") //	
	    					.append(" FROM db_root\n")
	    					.append(" )	mQ\n")
	    					.append(" ON (mm.machineno = mQ.machineno AND mm.part_cd = mQ.part_cd AND mm.part_cd_rev = mQ.part_cd_rev AND mm.rakes = mQ.rakes AND mm.plate = mQ.plate AND mm.colm = mQ.colm AND mm.member_key=mQ.member_key )\n")
	    					.append(" WHEN MATCHED THEN\n")
	    					.append("	UPDATE SET\n")
	    					.append(" mm.machineno = mQ.machineno,   mm.part_cd              = mQ.part_cd,           mm.part_cd_rev      = mQ.part_cd_rev,           mm.rakes                = mQ.rakes,\n")
	    					.append("mm.plate        = mQ.plate,  mm.colm                 = mQ.colm,      mm.pre_amt                  = mQ.post_amt, mm.post_amt    = mQ.post_amt, mm.member_key=mQ.member_key\n")
	    					.append("WHEN NOT MATCHED THEN\n")
	    					.append("	INSERT (mm.machineno,mm.part_cd, mm.part_cd_rev, mm.rakes, mm.plate,mm.colm, mm.pre_amt,mm.post_amt,mm.io_amt, mm.member_key)\n")
	    					.append("	VALUES (mQ.machineno,mQ.part_cd, mQ.part_cd_rev, mQ.rakes,mQ.plate,mQ.colm, mQ.post_amt,mQ.post_amt, mQ.io_amt, mQ.member_key)\n")
	    					
	    					.toString();

//머지문으로변경할것
			    		
							resultInt = super.excuteUpdate(con, sql.toString());
				    		if (resultInt < 0) {  //
								ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
								con.rollback();
								return EventDefine.E_DOEXCUTE_ERROR ;
							}
			    	}
					con.commit();
					
					
				} catch(Exception e) {
					LoggingWriter.setLogError("M202S030100E102()","==== SQL ERROR ===="+ e.getMessage());
					return EventDefine.E_DOEXCUTE_ERROR ;
			    } finally {
			    	if (Config.useDataSource) {
						try {
							if (con != null) con.close();
						} catch (Exception e) {
							LoggingWriter.setLogError("M202S030100E102()","==== finally ===="+ e.getMessage());
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

				try {
					con = JDBCConnectionPool.getConnection();
					
					String[][] c_paramArray_Head=null;
					String[][] c_paramArray_Detail=null;
					
					String rcvData = (String)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
					Vector resultVector = CommonFunction.getConvStringDamogjuk(rcvData);
					con.setAutoCommit(false);

					c_paramArray_Head = (String[][])resultVector.get(0);//head table
		    		c_paramArray_Detail=(String[][])resultVector.get(1); //data table

					String sql = new StringBuilder()
							.append("UPDATE tbi_import_inspect_result\n")
							.append("SET storage_ipgo_yn = 'Y'\n")
							.append("WHERE order_no = '" + c_paramArray_Head[0][0] + "'\n")
							.append("AND part_cd = '" + c_paramArray_Head[0][1] + "'\n")
							.append("AND part_cd_rev ='" + c_paramArray_Head[0][2] + "'\n")
							.append("AND member_key ='" + c_paramArray_Head[0][3] + "'\n")
							.toString();

					resultInt = super.excuteUpdate(con, sql.toString());
		    		if (resultInt < 0) {
						ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
						con.rollback();
						return EventDefine.E_DOEXCUTE_ERROR ;
					} 
					con.commit();
				} catch(Exception e) {
					LoggingWriter.setLogError("M202S030100E122()","==== SQL ERROR ===="+ e.getMessage());
					return EventDefine.E_DOEXCUTE_ERROR ;
			    } finally {
			    	if (Config.useDataSource) {
						try {
							if (con != null) con.close();
						} catch (Exception e) {
							LoggingWriter.setLogError("M202S030100E122()","==== finally ===="+ e.getMessage());
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
				String sql = "";
				try {
					con = JDBCConnectionPool.getConnection();

					String[][] c_paramArray_Head=null;
					String[][] c_paramArray_Detail=null;
					// 클라이언트로 부터 받은 파라미터를 옮겨 담는다.
					String rcvData = (String)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
					Vector resultVector = CommonFunction.getConvStringDamogjuk(rcvData);

					con.setAutoCommit(false);
					
					c_paramArray_Head = (String[][])resultVector.get(0);//head table
		    		c_paramArray_Detail=(String[][])resultVector.get(1); //data table
		    		for(int i=0;i<c_paramArray_Head.length;i++) {
		    			 sql = new StringBuilder()
								.append("DELETE FROM tbi_part_ipgo\n")
								.append("WHERE order_no = '"  + c_paramArray_Head[0][0] + "'\n")
								.append("	AND ipgo_no = '"  + c_paramArray_Head[0][1] + "'\n")
								.append("	AND part_cd = '"  + c_paramArray_Head[0][2] + "'\n")
								.append("	AND part_cd_rev = '"  + c_paramArray_Head[0][3] + "'\n")
								.toString();
		    			
						resultInt = super.excuteUpdate(con, sql.toString());
						if(resultInt < 0) {
							ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
							return resultInt;
						}else{
							ioParam.setMessage(resultInt + "건 " + MessageDefine.M_INSERT_RESULT);
						}
		    		}
					con.commit();
					for(int i=0; i<c_paramArray_Head.length; i++) { 

						 sql = new StringBuilder()
								.append("UPDATE tbi_part_storage mm\n")
								.append("SET\n")
								.append("	machineno = '" + c_paramArray_Head[0][6] + "',\n")
								.append("	part_cd = '" + c_paramArray_Head[0][4] + "',\n")
								.append("	part_cd_rev = '" + c_paramArray_Head[0][5] + "',\n")
								.append("	rakes = '" + c_paramArray_Head[0][7] + "',\n")
								.append("	plate = '" + c_paramArray_Head[0][8] + "',\n")
								.append("	colm = '" + c_paramArray_Head[0][9] + "',\n")
								.append("	pre_amt = '" + c_paramArray_Head[0][12] + "',\n")
								.append("	post_amt = mm.post_amt-'" + c_paramArray_Head[0][11] + "',\n")
								.append("	io_amt = '" + c_paramArray_Head[0][11] + "'\n")
								.append("WHERE machineno = '" + c_paramArray_Head[0][6] + "'\n")
								.append("	AND part_cd = '" + c_paramArray_Head[0][4] + "'\n")
								.append("	AND part_cd_rev = '" + c_paramArray_Head[0][5] + "'\n")
								.append("	AND rakes = '" + c_paramArray_Head[0][7] + "'\n")
								.append("	AND plate = '" + c_paramArray_Head[0][8] + "'\n")
								.append("	AND colm = '" + c_paramArray_Head[0][9] + "'\n")
								.append("	AND member_key = '" + c_paramArray_Head[0][13] + "'\n")
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
					LoggingWriter.setLogError("M202S030100E103()","==== SQL ERROR ===="+ e.getMessage());
					return EventDefine.E_DOEXCUTE_ERROR ;
			    } finally {
			    	if (Config.useDataSource) {
						try {
							if (con != null) con.close();
						} catch (Exception e) {
							LoggingWriter.setLogError("M202S030100E103()","==== finally ===="+ e.getMessage());
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

			String sql = new StringBuilder()
					.append("SELECT 											\n")
					.append("	A.balju_no,										\n")
					.append("	B.balju_send_date,								\n")
					.append("	B.balju_nabgi_date,								\n")
					.append("	C.part_nm,										\n")
					.append("	A.balju_amt,									\n")
					.append("	A.balju_status,									\n")
					.append("	A.part_cd,										\n")
					.append("	A.part_rev_no,									\n")
					.append("	A.balju_rev_no,									\n")
					.append("	A.trace_key,									\n")
					.append("	A.doc_regist_yn									\n")
					.append("FROM tbi_balju_list2 A								\n")
					.append("INNER JOIN tbi_balju2 B							\n")
					.append("	ON A.balju_no = B.balju_no						\n")
					.append("	AND A.balju_rev_no = B.balju_rev_no				\n")
					.append("	AND A.trace_key = B.trace_key					\n")
					.append("INNER JOIN tbm_part_list C							\n")
					.append("	ON A.part_cd = C.part_cd						\n")
					.append("	AND A.part_rev_no = C.revision_no				\n")
					.append("WHERE 												\n")
			//		.append("	A.balju_status = '대기'							\n") 원래 있던거
			//		.append("	AND A.doc_regist_yn = 'N'						\n") 서승헌이 넣은거
			//		.append("   AND B.delyn = 'N' 								\n") 
					.append("   B.delyn = 'N'	 								\n")
					.append("	AND B.balju_send_date							\n")
					.append("		BETWEEN '" + jArray.get("fromdate") + "' 	\n")
					.append("			AND '" + jArray.get("todate") + "'		\n")
					.append("   AND A.balju_rev_no = (SELECT MAX(balju_rev_no)  \n")
					.append("   						 FROM tbi_balju_list2 D \n")
					.append("   					     WHERE D.balju_no = A.balju_no) \n")
					.append("ORDER BY B.balju_send_date DESC 					\n")
					.toString();
			
			String ActionCommand = ioParam.getActionCommand();
			if(ActionCommand.startsWith("doQueryTableFieldName")) {
				resultString = super.excuteQueryStringTableFieldName(con, sql.toString());
			} else {
				resultString = super.excuteQueryString(con, sql.toString());
			}
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M202S030100E104()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M202S030100E104()","==== finally ===="+ e.getMessage());
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
			
			String sql = new StringBuilder()
					.append("SELECT \n")
					.append("	A.part_cd,\n")
					.append("	C.part_nm,\n")
					.append("	C.packing_qtty || ' ' || C.unit_type AS unit,\n")
					.append("	A.balju_amt\n")
					.append("FROM tbi_balju_list2 A\n")
					.append("INNER JOIN tbi_balju2 B\n")
					.append("	ON A.balju_no = B.balju_no\n")
					.append("	AND A.balju_rev_no = B.balju_rev_no\n")
					.append("	AND A.lotno = B.lotno\n")
					.append("INNER JOIN tbm_part_list C\n")
					.append("	ON A.part_cd = C.part_cd\n")
					.append("	AND A.part_rev_no = C.revision_no\n")
					.append("WHERE A.balju_no = 'BLJ20-000034'\n")
					.append("	AND A.balju_rev_no = 0\n")
					.toString();
		
			String ActionCommand = ioParam.getActionCommand();
			if(ActionCommand.startsWith("doQueryTableFieldName")) {
				resultString = super.excuteQueryStringTableFieldName(con, sql.toString());
			} else {
				resultString = super.excuteQueryString(con, sql.toString());
			}
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M202S030100E114()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M202S030100E114()","==== finally ===="+ e.getMessage());
				}
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
	
	// 이력번호 조회
	public int E115(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));

			String sql = new StringBuilder()
					.append("SELECT\n")
					.append("	order_no,\n")
					.append("	lotno,\n")
					.append("	hist_no,\n")
					.append("	create_date\n")
					.append("FROM haccp_hysteretic_system\n")
					.append("WHERE order_no = '"  + jArray.get("order_no") + "'\n")
					.append("AND lotno = '" + jArray.get("lotno") + "'\n")
					.append("AND member_key = '" + jArray.get("member_key") + "' 	\n")			
					.append("ORDER BY HIST_NO ASC 	\n")	
					.toString();

			String ActionCommand = ioParam.getActionCommand();
			if(ActionCommand.startsWith("doQueryTableFieldName")) {
				resultString = super.excuteQueryStringTableFieldName(con, sql.toString());
			} else {
				resultString = super.excuteQueryString(con, sql.toString());
			}
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M202S030100E115()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M202S030100E115()","==== finally ===="+ e.getMessage());
				}
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
	
	//수입검사결과목록  S202S030120.jsp
	public int E124(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
		
			String sql = new StringBuilder()
					.append("SELECT DISTINCT\n")
					.append("		A.order_no,\n")
					.append("		A.lotno,\n")
					.append("		A.part_cd,\n")
					.append("		A.part_cd_rev,\n")
					.append("		B.part_nm || '('||E.code_name  ||','||  F.code_name ||')',\n")
					.append("		A.inspect_count,\n")
					.append("		D.machineno,\n")
					.append("		D.rakes,\n")
					.append("		D.plate,\n")
					.append("		D.colm,\n")
					.append("		D.machineno || '-' || D.rakes  || '-' ||  D.plate  || '-' ||  D.colm AS part_loc,\n")
					.append("		CAST(TO_CHAR (NVL(D.pre_amt,0), '999,999,999,999') AS NUMERIC(15,3)) as pre_amt,\n")
					.append("		CAST(TO_CHAR (NVL(D.io_amt,0), '999,999,999,999') AS NUMERIC(15,3)) as io_amt,\n")
					.append("		CAST(TO_CHAR (NVL(D.post_amt,0), '999,999,999,999') AS NUMERIC(15,3)) as post_amt,\n")
					.append("		B.safety_jaego,\n")
					.append("		E.code_name AS gubun_b,\n")
					.append("		B.part_gubun_b,\n")
					.append("		F.code_name AS gubun_m,\n")
					.append("		B.part_gubun_m,\n")
					.append("		A.balju_count,\n")
					.append("		NVL(A.balju_count-A.inspect_count,0)\n")
					.append("FROM tbi_balju_list_inspect A\n")
					.append("INNER JOIN tbm_part_list B\n")
					.append("		ON A.part_cd = B.part_cd\n")
					.append("		AND A.part_cd_rev = B.revision_no\n")
					.append("		AND A.member_key = B.member_key\n")
					.append("LEFT OUTER JOIN tbi_order C\n")
					.append("		ON A.order_no=C.order_no\n")
					.append("		AND A.lotno=C.lotno\n")
					.append("		AND A.member_key = C.member_key\n")
					.append("LEFT OUTER JOIN tbi_part_storage D\n")
					.append("		ON A.part_cd = D.part_cd\n")
					.append("		AND A.part_cd_rev = D.part_cd_rev\n")
					.append("		AND A.member_key = D.member_key\n")
					.append("LEFT OUTER JOIN v_partgubun_big E\n")
					.append("		ON B.part_gubun_b = E.code_value\n")
					.append("		AND B.member_key = E.member_key\n")
					.append("LEFT OUTER JOIN v_partgubun_mid F\n")
					.append("		ON B.part_gubun_m = F.code_value\n")
					.append("		AND B.member_key = F.member_key\n")
					.append("WHERE\n")
					.append("		A.order_no = '" + jArray.get("order_no") + "' \n")
					.append("		AND A.lotno = '" + jArray.get("lotno") + "' \n")
					.append("		AND A.balju_no = '" + jArray.get("baljuNo") + "' \n")
					.append("		AND A.member_key = '" + jArray.get("member_key") + "' 	\n")
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
			LoggingWriter.setLogError("M202S030100E124()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M202S030100E124()","==== finally ===="+ e.getMessage());
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
	
	// 사용중인 jsp 없음
	public int E134(InoutParameter ioParam){
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
//					.append("	bupum_bunho,\n") // part_cd로 대체
					.append("	part_cd,\n")
					.append("	req_count,\n")
					.append("	part_cd_rev\n")
					.append("FROM tbi_import_inspect_request\n")
					.append("WHERE order_no = '" + c_paramArray[0][0] + "' \n")
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
			LoggingWriter.setLogError("M202S030100E134()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M202S030100E134()","==== finally ===="+ e.getMessage());
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
	// 사용중인 jsp 없음
	public int E144(InoutParameter ioParam){
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
					.append("	A.order_no,\n")
					.append("	ipgo_no,\n")
					.append("	io_date,\n")
					.append("	io_seqno,\n")
					.append("	io_time,\n")
					.append("	io_user_id,\n")
					.append("	B.part_nm,\n")
					.append("	A.part_cd,\n")
					.append("	A.part_cd_rev,\n")
					.append("	store_no,\n")
					.append("	rakes,\n")
					.append("	plate,\n")
					.append("	colm,\n")
					.append("	pre_stack,\n")
					.append("	io_count,\n")
					.append("	post_stack,\n")
					.append("	SUM(io_count) over(PARTITION  BY A.order_no,A.part_cd) AS  sumio_count,\n")
					.append("	A.lotno\n")
					.append("FROM tbi_part_ipgo A\n")
					.append("	INNER JOIN vtbm_part_list B\n")
					.append("	ON A.part_cd = B.part_cd\n")
					.append("   AND A.member_key = B.member_key\n")
					.append("WHERE A.order_no = '" + c_paramArray[0][0] + "'\n")
					.append("AND A.part_cd = '" + c_paramArray[0][1] + "'\n")
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
			LoggingWriter.setLogError("M202S030100E144()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M202S030100E144()","==== finally ===="+ e.getMessage());
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
	// 사용중인 jsp 없음
	//E144와 같은쿼리 업데이트 수정을부르기위해 사용
	public int E154(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			
			String sql = new StringBuilder()
					.append("SELECT\n")
					.append("	A.order_no,\n")		//주문번호
					.append("	ipgo_no,\n")		//입고번호
					.append("	io_date,\n")		//입고일자
					.append("	io_seqno,\n")		//입고일련번호
					.append("	io_time,\n")		//입고시간
					.append("	io_user_id,\n")		//입고담당자
					.append("	B.part_nm,\n")		//원부자재명
					.append("	A.part_cd,\n")		//원부자재코드
					.append("	A.part_cd_rev,\n")	//원부자재코드개정번호
					.append("	store_no,\n")		//창고번호
					.append("	rakes,\n")			//렉번호
					.append("	plate,\n")			//선반번호
					.append("	colm,\n")			//칸번호
					.append("	pre_stack,\n")		//입고전 재고량
					.append("	io_count,\n")		//입고수량
					.append("	post_stack \n")		//입고후 재고량
					.append("FROM tbi_part_ipgo A\n")
					.append("	INNER JOIN vtbm_part_list B\n")
					.append("	ON A.part_cd = B.part_cd\n")
					.append("   AND A.member_key = B.member_key\n")
					.append("WHERE order_no = '" + jArray.get("order_no") + "'\n")
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
			LoggingWriter.setLogError("M202S030100E154()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M202S030100E154()","==== finally ===="+ e.getMessage());
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
	
	//E114와 같은쿼리 업데이트 삭제를부르기위해 사용
	public int E164(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));

			String sql = new StringBuilder()
					.append("SELECT		\n")
					.append("	order_no,		\n")
					.append("	ipgo_no,		\n")
					.append("	io_seqno,		\n")
					.append("	io_date,		\n")
					.append("	io_time,		\n")
					.append("	io_user_id,		\n")
					.append("	part_cd,		\n")
					.append("	part_cd_rev,	\n")
					.append("	store_no,		\n")
					.append("	rakes,			\n")
					.append("	plate,			\n")
					.append("	colm,			\n")
					.append("	pre_stack,		\n")
					.append("	io_count,		\n")
					.append("	post_stack,		\n")
					.append("	gubun,			\n")
					.append("	bigo			\n")
					.append("FROM tbi_part_ipgo\n")
					.append("WHERE order_no = '" + jArray.get("order_no") + "'\n")
					.append("AND part_cd =  '" + jArray.get("part_cd") + "'\n")
					.append("AND A.member_key = '" + jArray.get("member_key") + "' \n")
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
			LoggingWriter.setLogError("M202S030100E164()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M202S030100E164()","==== finally ===="+ e.getMessage());
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
	
	public int E174(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			String rcvData = (String)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			String[][] c_paramArray = CommonFunction.getConvString2DoubleArray(rcvData);

			String sql = new StringBuilder()
					.append("SELECT\n")
					.append("	order_no,\n")
					.append("	ipgo_no,\n")
					.append("	io_seqno,\n")
					.append("	io_date,\n")
					.append("	io_time,\n")
					.append("	io_user_id,\n")
					.append("	part_cd,\n")
					.append("	part_cd_rev,\n")
					.append("	store_no,\n")
					.append("	rakes,\n")
					.append("	plate,\n")
					.append("	colm,\n")
					.append("	pre_stack,\n")
					.append("	io_count,\n")
					.append("	post_stack,\n")
					.append("	gubun,\n")
					.append("	bigo\n")
					.append("FROM tbi_part_ipgo\n")
					.append("WHERE order_no = '" + c_paramArray[0][0] + "'\n")
					.append("AND ipgo_no =  '" + c_paramArray[0][1] + "'\n")
					.append("AND part_cd =  '" + c_paramArray[0][2] + "'\n")
					.append("AND part_cd_rev =  '" + c_paramArray[0][3] + "'\n")
					.append("AND member_key =  '" + c_paramArray[0][13] + "'\n")
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
			LoggingWriter.setLogError("M202S030100E174()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M202S030100E174()","==== finally ===="+ e.getMessage());
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
	
	// 사용하는 jsp 없음
	public int E137(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			String rcvData = (String)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			String[][] c_paramArray = CommonFunction.getConvString2DoubleArray(rcvData);
			
			String sql = new StringBuilder()
					.append("SELECT\n")
					.append("	B.balju_no,		\n")
					.append("	balju_seq,		\n")
					.append("	bom_nm,		\n")
					.append("	bom_cd,	\n")
					.append("	part_cd,		\n")
					.append("	inspect_count,	\n")
					.append("	part_cd_rev 	\n")
					.append("FROM tbi_balju_list_inspect A \n")
					.append("INNER JOIN tbi_balju B \n")
					.append("	ON B.balju_no = A.balju_no\n")
					.append("   AND B.member_key = A.member_key\n")
					.append("WHERE B.order_no = '" + c_paramArray[0][0] + "' \n")
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
			LoggingWriter.setLogError("M202S030100E137()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M202S030100E137()","==== finally ===="+ e.getMessage());
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
	
	// 사용하는 jsp 없음	
	public int E504(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			String rcvData = (String)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
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
					.append("	AND   IO_DATE 	>=	'" + c_paramArray[0][1] + "' \n")
					.append("	AND   IO_DATE 	<=	'" + c_paramArray[0][2] + "' \n")
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
			LoggingWriter.setLogError("M202S030100E504()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M202S030100E504()","==== finally ===="+ e.getMessage());
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
	public int E314(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));

			String sql = new StringBuilder()
					.append("SELECT * FROM (\n")
					.append("	SELECT\n")
					.append("		A.machineno,\n")
					.append("		A.rakes,\n")
					.append("		A.plate,\n")
					.append("		A.colm,\n")
					.append("		A.use_yn,\n")
					.append("		A.gubun,\n")
					.append("		A.gubun_name,\n")
					.append("		A.member_key\n")
					.append("	FROM tbm_part_storage_conf A\n")
					.append("	WHERE A.member_key = '" + jArray.get("member_key") + "'\n")
					.append("		AND A.use_yn = 'N'\n")
					.append("	ORDER BY A.machineno, TO_NUMBER(A.rakes), TO_NUMBER(A.plate), TO_NUMBER(A.colm)\n")
					.append(")\n")
					.append("WHERE  ROWNUM BETWEEN 1 AND 1;\n")
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
			LoggingWriter.setLogError("M202S030100E314()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M202S030100E314()","==== finally ===="+ e.getMessage());
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
					.append("SELECT COUNT(*) AS balju_list_Count FROM tbi_balju_list A, order_balju  WHERE A.balju_no= order_balju.balju_no\n")
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
			LoggingWriter.setLogError("M202S030100E999()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M202S030100E999()","==== finally ===="+ e.getMessage());
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

