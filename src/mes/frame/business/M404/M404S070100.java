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


/**
 * 개요 : 이벤트ID별 메소드 정의
 */
public  class M404S070100 extends SqlAdapter{
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
	
	public M404S070100(){
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
			
			Method method = M404S070100.class.getMethod(event,optClass);
			LoggingWriter.setLogDebug(M404S070100.class.getName(),"==== " + event + " EventMethod Create Success ====");

			obj = method.invoke(M404S070100.class.newInstance(),optObj);
			doExcute_result = CommonFunction.getInt(obj.toString());
			
	    } catch (Exception ex) {
	    	doExcute_result = EventDefine.E_DOEXCUTE_INIT;
			ioParam.setMessage(MessageDefine.M_NO_EVENTID);
			LoggingWriter.setLogError(M404S070100.class.getName(),"==== EventID Not define : EVENT ID [ " + ioParam.getEventID() + "]");
	    } finally {
	    	obj = null;
			optClass = null;
			optObj = null;
	    }
	    long endTime = System.currentTimeMillis();
		long runningTime = endTime - startTime;
		LoggingWriter.setLogAll(M404S070100.class.getName(),"==== Query [수행시간  : " + runningTime + " ms]");
		
		return doExcute_result;
	}

//	//품질검사 등록 S04S010101.jsp
	public int E101(InoutParameter ioParam){ 
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

    		JSONObject jjjArray0 = (JSONObject)jjArray.get(0); // 0번째 데이터묶음
    		
    		
    		
    		
//    		if(jjjArray0.get("inspect_no").equals("")) {
//				ActionNo = new ApprovalActionNo();
//				gOrderNo = ActionNo.getActionNo(con,jjjArray0.get("jspPage").toString(),jjjArray0.get("login_id").toString(),jjjArray0.get("num_Gubun").toString(),
//						"Regist",jjjArray0.get("lotno").toString());//GV_JSPPAGE(action Page), User ID, prefix
//    		} else {
//    			gOrderNo =jjjArray0.get("inspect_no").toString();
//    		}
//    		
//    		if(jjjArray0.get("inspect_seq").equals("")) {
//				aaa="(select * from "
//						+"(select ifnull(max(inspect_seq) + 1,0) from tbi_order_product_inspect_result"
//						+ " where member_key=" + jjjArray0.get("member_key")
//						+ ")"
//					+")";
//    		} else {
//    			aaa=jjjArray0.get("inspect_seq").toString();
//    		}
    		
    		
			ActionNo = new ApprovalActionNo();
			
			gOrderNo = ActionNo.getActionNo(con,jjjArray0.get("jspPage").toString(),jjjArray0.get("login_id").toString(),jjjArray0.get("num_Gubun").toString(),
					"Regist",jjjArray0.get("lotno").toString(),jjjArray0.get("member_key").toString());//GV_JSPPAGE(action Page), User ID, prefix
			
			aaa="(select * from "
					+"(select ifnull(max(inspect_seq) + 1,0) from tbi_order_product_inspect_result"
					+ " where member_key='" + jjjArray0.get("member_key")
					+ "')"
				+")";
			
			
			for(int i=0;i<jjArray.size();i++) {		
				JSONObject jjjArray = (JSONObject)jjArray.get(i);
    		 sql = new StringBuilder()
 					.append("MERGE INTO tbi_order_product_inspect_result mm\n")
 					.append("	USING(\n")
 					.append("		SELECT \n")
 					.append("                '" + jjjArray.get("order_no")	+ "' AS order_no,\n")
 					.append("                '" + jjjArray.get("order_no") 	+ "' AS lotno,\n")
 					.append("                '" + gOrderNo + "' AS inspect_no,\n")
 					.append("                '" + jjjArray.get("gubun_code") + "' AS inspect_gubun,\n")
 					.append("                '" + jjjArray.get("prod_cd") 	 + "' AS prod_cd,\n")
 					.append("                '" + jjjArray.get("prod_rev") 	 + "' AS prod_cd_rev,\n")
 					.append("                '" + jjjArray.get("login_id") 	 + "' AS user_id,\n")
 					.append("                  SYSDATETIME AS inspect_result_dt,\n")
 					.append("                '" + jjjArray.get("checklist_cd") 		+ "' AS checklist_cd,\n")
 					.append("                '" + jjjArray.get("checklist_cd_rev") 	+ "' AS checklist_cd_rev,\n")
 					.append("                '" + jjjArray.get("item_cd") 			+ "' AS item_cd,\n")
 					.append("                '" + jjjArray.get("item_cd_rev") 		+ "' AS item_cd_rev,\n")
 					.append("                '" + jjjArray.get("standard_value") 	+ "' AS standard_value,\n")
 					.append("                '" + jjjArray.get("result_value") 		+ "' AS result_value,\n")
 					.append("                 "+ aaa +" AS inspect_seq ,\n")
 					.append("                '" + jjjArray.get("pass_yn") 				+ "' AS pass_yn,\n")
 					.append("                '" + jjjArray.get("product_serial_no") 	+ "' AS product_serial_no,\n")
 					.append("                '" + jjjArray.get("product_serial_no_end") + "' AS product_serial_no_end,\n")
 					.append("                '" + jjjArray.get("member_key") 			+ "' AS member_key\n")
 					.append("                FROM db_root ) mQ\n")
 					.append("	ON (\n")
 					.append("		mm.order_no=mQ.order_no\n")
 					.append("		AND mm.lotno=mQ.lotno\n")
 					.append("		AND mm.product_serial_no=mQ.product_serial_no\n")
 					.append("		AND mm.product_serial_no_end=mQ.product_serial_no_end\n")
 					.append("		AND mm.inspect_gubun=mQ.inspect_gubun\n")
 					.append("		AND mm.inspect_seq=mQ.inspect_seq\n")
 					.append("		AND mm.member_key=mQ.member_key\n")
 					.append("	)\n")
 					.append("WHEN MATCHED THEN\n")
 					.append("                UPDATE SET\n")
 					.append("	                mm.order_no=mQ.order_no,\n")
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
 					.append("	                mm.member_key=mQ.member_key\n")
 					.append("WHEN NOT MATCHED THEN\n")
 					.append("                INSERT(\n")
 					.append("	                mm.order_no,\n")
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
 					.append("	                mm.member_key\n")
 					.append("                ) VALUES (\n")
 					.append(" 			 		mQ.order_no,\n")
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
 					.append("	                mQ.member_key\n")
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
			LoggingWriter.setLogError("M404S070100E101()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M404S070100E101()","==== finally ===="+ e.getMessage());
				}
	    	} else {
	    	}
	    }
		ioParam.setResultString(resultString);
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
    	ioParam.setMessage(MessageDefine.M_QUERY_OK);
	    return EventDefine.E_QUERY_RESULT;
	}	
	
	public int E201(InoutParameter ioParam){ 
		resultInt = EventDefine.E_DOEXCUTE_INIT;

		String sql ="";
		ApprovalActionNo ActionNo;
		String gOrderNo="";
		String aaa="";
		
		int listCnt=0, nextStatuscnt=0;
		try {
			con = JDBCConnectionPool.getConnection();

			con.setAutoCommit(false);
			
			// insert_update_delete_json.jsp에서 받아온 JSON데이터 처리
    		JSONObject jArray = new JSONObject();
    		jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
    		// Object데이터에서 키값(param)으로 JSONArray데이터를 꺼낸다. (데이터묶음 하나일땐 생략)
    		JSONArray jjArray = (JSONArray) jArray.get("param");
    		
    		JSONObject jjjArray0 = (JSONObject)jjArray.get(0); // 0번째 데이터묶음

//			String[][] c_paramArray_Head=null;
//			String[][] c_paramArray_Detail=null;
//			String rcvData = (String)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));

//			Vector resultVector = CommonFunction.getConvStringDamogjuk(rcvData);

//			con.setAutoCommit(false);
			
//			c_paramArray_Head = (String[][])resultVector.get(0);//head table
//    		c_paramArray_Detail=(String[][])resultVector.get(1); //data table

//			ActionNo = new ApprovalActionNo();
////			getActionNo(Connection  con, String jspPage,String user_id, String prefix, String actionGubun,String detail_seq)
//			gOrderNo = ActionNo.getActionNo(con,c_paramArray_Head[0][0],c_paramArray_Head[0][1],c_paramArray_Head[0][2],
//					"Regist",c_paramArray_Detail[0][1]);//GV_JSPPAGE(action Page), User ID, prefix
			
    		
//    		if(c_paramArray_Detail[0][14].equals("")) {
//				ActionNo = new ApprovalActionNo();
//				gOrderNo = ActionNo.getActionNo(con,c_paramArray_Head[0][0],c_paramArray_Head[0][1],c_paramArray_Head[0][2],
//						"Regist",c_paramArray_Detail[0][1]);//GV_JSPPAGE(action Page), User ID, prefix
//    		} else {
//    			gOrderNo =c_paramArray_Detail[0][14];
//    		}
//    		
//    		if(c_paramArray_Detail[0][15].equals("")) {
//				aaa="(select * from (select ifnull(max(inspect_seq) + 1,0) from tbi_order_product_inspect_result))";
//    		} else {
//    			aaa=c_paramArray_Detail[0][15];
//    		}
    		
    		
//    		if(jjjArray0.get("inspect_no").equals("")) {
//				ActionNo = new ApprovalActionNo();
//				gOrderNo = ActionNo.getActionNo(con,jjjArray0.get("jsp_page").toString(),jjjArray0.get("login_id").toString(),jjjArray0.get("num_gubun").toString(),
//						"Regist",jjjArray0.get("lotno").toString());//GV_JSPPAGE(action Page), User ID, prefix
//    		} else {
//    			gOrderNo =jjjArray0.get("inspect_no").toString();
//    		}
//    		
//    		if(jjjArray0.get("inspect_seq").equals("")) {
//				aaa="(select * from (select ifnull(max(inspect_seq) + 1,0) from tbi_order_product_inspect_result"
//						+ " where member_key='" + jjjArray0.get("member_key")
//						+"'))";
//    		} else {
//    			aaa=jjjArray0.get("inspect_seq").toString();
//    		}
    		System.out.println("11111111111111111111111");
    		
			ActionNo = new ApprovalActionNo();
			gOrderNo = ActionNo.getActionNo(con,jjjArray0.get("jspPage").toString(),jjjArray0.get("login_id").toString(),jjjArray0.get("num_Gubun").toString(),
					"Regist",jjjArray0.get("lotno").toString(),jjjArray0.get("member_key").toString());//GV_JSPPAGE(action Page), User ID, prefix
			
			aaa="(select * from "
					+"(select ifnull(max(inspect_seq) + 1,0) from tbi_order_product_inspect_result"
					+ " where member_key='" + jjjArray0.get("member_key")
					+ "')"
				+")";
    		
			System.out.println(gOrderNo +"///////////////////" + aaa);
    		
			for(int i=0;i<jjArray.size();i++) {
			JSONObject jjjArray = (JSONObject)jjArray.get(i);
    		 sql = new StringBuilder()	
					.append("MERGE INTO tbi_order_product_inspect_result mm\n")
					.append("	USING(\n")
					.append("		SELECT \n")
					.append("                '" + jjjArray.get("order_no")	 + "' AS order_no,\n")
					.append("                '" + jjjArray.get("lotno") + "' AS lotno,\n")
					.append("                '" + jjjArray.get("order_detail_seq") + "' AS order_detail_seq,\n")
					.append("                '" + gOrderNo + "' AS inspect_no,\n")
					.append("                '" + jjjArray.get("gubun_code") + "' AS inspect_gubun,\n")
					.append("                '" + jjjArray.get("prod_cd") + "' AS prod_cd,\n")
					.append("                '" + jjjArray.get("prod_cd_rev") + "' AS prod_cd_rev,\n")
					.append("                '" + jjjArray.get("login_id") + "' AS user_id,\n")
					.append("                  SYSDATETIME AS inspect_result_dt,\n")
					.append("                '" + jjjArray.get("checklist_cd") + "' AS checklist_cd,\n")
					.append("                '" + jjjArray.get("checklist_cd_rev") + "' AS checklist_cd_rev,\n")
					.append("                '" + jjjArray.get("item_cd") + "' AS item_cd,\n")
					.append("                '" + jjjArray.get("item_cd_rev") + "' AS item_cd_rev,\n")
					.append("                '" + jjjArray.get("standard_value") + "' AS standard_value,\n")
					.append("                '" + jjjArray.get("result_value") + "' AS result_value,\n")
//					.append("                (select * from (select ifnull(max(inspect_seq) + 1,0) from tbi_order_product_inspect_result)) as inspect_seq ,\n")
					.append("                 "+ aaa +" AS inspect_seq ,\n")
					.append("                '" + jjjArray.get("pass_yn") + "' AS pass_yn,\n")
					.append("                '" + jjjArray.get("product_serial_no") + "' AS product_serial_no,\n")
					.append("                '" + jjjArray.get("product_serial_no_end") + "' AS product_serial_no_end,\n")
					.append("                '" + jjjArray.get("member_key") + "' AS member_key\n")
					.append("                FROM db_root ) mQ\n")
					.append("	ON (\n")
					.append("		mm.order_no=mQ.order_no\n")
					.append("		AND mm.lotno=mQ.lotno\n")
					.append("		AND mm.order_detail_seq=mQ.order_detail_seq\n")
					.append("		AND mm.product_serial_no=mQ.product_serial_no\n")
					.append("		AND mm.product_serial_no_end=mQ.product_serial_no_end\n")
					.append("		AND mm.inspect_gubun=mQ.inspect_gubun\n")
					.append("		AND mm.inspect_seq=mQ.inspect_seq\n")
					.append("		AND mm.member_key=mQ.member_key\n")
					.append("	)\n")
					.append("WHEN MATCHED THEN\n")
					.append("                UPDATE SET\n")
					.append("	                mm.order_no=mQ.order_no,\n")
					.append("	                mm.lotno=mQ.lotno,\n")
					.append("	                mm.order_detail_seq=mQ.order_detail_seq,\n")
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
					.append("	                mm.member_key=mQ.member_key\n")
					.append("WHEN NOT MATCHED THEN\n")
					.append("                INSERT(\n")
					.append("	                mm.order_no,\n")
					.append("	                mm.lotno,\n")
					.append("	                mm.order_detail_seq,\n")
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
					.append("	                mm.member_key\n")
					.append("                ) VALUES (\n")
					.append(" 			 		mQ.order_no,\n")
					.append("	                mQ.lotno,\n")
					.append("	                mQ.order_detail_seq,\n")
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
					.append("	                mQ.member_key\n")
					.append(")\n")
					.toString();
					
			
//				 System.out.println(sql.toString());
				
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
			LoggingWriter.setLogError("M404S070100E201()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M404S070100E201()","==== finally ===="+ e.getMessage());
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
			LoggingWriter.setLogError("M404S070100E122()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} 
				catch (Exception e) {
					LoggingWriter.setLogError("M404S070100E122()","==== finally ===="+ e.getMessage());
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
	
	public int E222(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;

		Queue = new QueueProcessing();
		try {
			con = JDBCConnectionPool.getConnection();

			// 클라이언트로 부터 받은 파라미터를 옮겨 담는다.
			String rcvData = (String)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			Vector resultVector = CommonFunction.getConvStringDamogjuk(rcvData);

			con.setAutoCommit(false);

    		
    		
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
			LoggingWriter.setLogError("M404S070100E222()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} 
				catch (Exception e) {
					LoggingWriter.setLogError("M404S070100E222()","==== finally ===="+ e.getMessage());
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
					.append("DELETE FROM	\n")
					.append("	tbi_order_product_inspect_result 	\n")
					.append("	where order_no		= '" + jArray.get("order_no") + "'  \n")
					.append(" 	and lotno			= '" + jArray.get("lotno") + "'  \n")
					.append(" 	and inspect_no		= '" + jArray.get("inspect_no") + "'  \n")
					.append(" 	and checklist_cd	= '" + jArray.get("checklist_cd") + "'  \n")
					.append(" 	and inspect_seq		= '" + jArray.get("inspect_seq") + "'  \n")
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
			LoggingWriter.setLogError("M404S070100E103", "==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M404S070100E103()","==== finally ===="+ e.getMessage());
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
	
	public int E203(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject(); // JSONObject 선언
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			// 클라이언트로 부터 받은 파라미터를 옮겨 담는다.

			String sql = new StringBuilder()
					.append("DELETE FROM	\n")
					.append("	tbi_order_product_inspect_result 	\n")
					.append("	where order_no 		= '" + jArray.get("order_no") + "'  \n")
					.append(" 	and lotno			= '" + jArray.get("lotno") + "'  \n")
					.append(" 	and inspect_no 		= '" + jArray.get("inspect_no") + "'  \n")
					.append(" 	and checklist_cd	= '" + jArray.get("checklist_cd") + "'  \n")
					.append(" 	and inspect_seq		= '" + jArray.get("inspect_seq") + "'  \n")
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
			LoggingWriter.setLogError("M404S070100E203", "==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M404S070100E203()","==== finally ===="+ e.getMessage());
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
	
	//Client: M404S070100 품질검사(Head) 
	public int E104(InoutParameter ioParam){ //
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			System.out.println("JSONObject jArray rcvData="+ jArray.toString());

			String sql = new StringBuilder()
					.append("SELECT DISTINCT\n")
					.append("	C.cust_nm,  		--고객사\n")
					.append("	B.product_nm,  		--제품명\n")
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
					.append("WHERE A.cust_cd LIKE '%" 	+ jArray.get("custcode") + "'	\n")
					.append("AND order_date  BETWEEN '"	+ jArray.get("fromdate") + "' 	\n")
					.append("				 AND '" 	+ jArray.get("todate") + "'	\n")
					.append("AND A.member_key = '" 		+ jArray.get("member_key") + "'  \n")
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
			LoggingWriter.setLogError("M404S070100E104()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M404S070100E104()","==== finally ===="+ e.getMessage());
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
	//Client: M404S070100 품질검사(Head) 
	public int E204(InoutParameter ioParam){ //
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
					.append("	B.product_nm || '('||D.code_name  ||','||  E.code_name ||')', --제품명\n")
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
					.append("	A.order_detail_seq\n")
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
					.append("        AND B.member_key 	= D.member_key	\n")
					.append("INNER JOIN v_prodgubun_mid E				\n")
					.append("        ON B.prod_gubun_m	= E.code_value	\n")
					.append("        AND B.member_key 	= E.member_key	\n")
					.append("WHERE A.cust_cd LIKE '%" 	+ jArray.get("custcode") + "'	\n")
//					.append("AND S.class_id = '" 		+ jArray.get("jsppage") + "' 	\n")
					.append("AND order_date BETWEEN '" 	+ jArray.get("fromdate") + "' 	\n")
					.append("	 			AND '" 		+ jArray.get("todate") + "'		\n")
					.append("AND A.member_key = '" 		+ jArray.get("member_key") + "'	\n")
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
			LoggingWriter.setLogError("M404S070100E204()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M404S070100E204()","==== finally ===="+ e.getMessage());
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
						.append("	request_date   BETWEEN '" 	+ jArray.get("fromdate") + "' 	\n")
						.append("	 				AND '" 		+ jArray.get("todate") + "'	\n")
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
				LoggingWriter.setLogError("M404S070100E304()","==== SQL ERROR ===="+ e.getMessage());
				return EventDefine.E_DOEXCUTE_ERROR ;
		    } finally {
		    	if (Config.useDataSource) {
					try {
						if (con != null) con.close();
					} catch (Exception e) {
						LoggingWriter.setLogError("M404S070100E304()","==== finally ===="+ e.getMessage());
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
					.append("AND  	A.lotno = '" 	+ jArray.get("lotno") + "' \n")
//					.append("AND  	A.inspect_gubun like '%" + jArray.get("gubun_code") + "' \n")
					.append("AND  	A.inspect_gubun = 'PRODCT' \n")
					.append("AND	A.product_serial_no like '%" 		+ jArray.get("product_serial_no") + "'\n")
					.append("AND	A.product_serial_no_end like '%" 	+ jArray.get("product_serial_no_end") + "'\n")
					.append("AND 	A.member_key = '" 					+ jArray.get("member_key") + "'  \n")
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
			LoggingWriter.setLogError("M404S070100E114()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M404S070100E114()","==== finally ===="+ e.getMessage());
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
	public int E214(InoutParameter ioParam){ //
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			System.out.println("JSONObject jArray rcvData="+ jArray.toString());
			
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
					.append("        LEFT OUTER JOIN tbm_product C\n")
					.append("        ON A.prod_cd = C.prod_cd\n")
					.append("        AND A.prod_cd_rev = C.revision_no\n")
					.append("   	 AND A.member_key = C.member_key\n")
					.append("        INNER JOIN v_checklist_gubun D\n")
					.append("        ON A.inspect_gubun = D.code_value\n")
					.append("   	 AND A.member_key = D.member_key\n")
					.append("where  A.order_no = '" + jArray.get("order_no") + "' \n")
					.append("AND  	A.lotno = '" 	+ jArray.get("lotno") + "' \n")
					.append("AND  	A.order_detail_seq = '" 	+ jArray.get("order_detail_seq") + "' \n")
//					.append("AND  	A.inspect_gubun like '%" + jArray.get("inspect_gubun") + "' \n")
					.append("AND  	A.inspect_gubun = 'SHIPMENT' \n")
					.append("AND	A.product_serial_no like '%" 	 + jArray.get("product_serial_no") + "'\n")
					.append("AND	A.product_serial_no_end like '%" + jArray.get("product_serial_no_end") + "'\n")
					.append("AND 	A.member_key = '" 				 + jArray.get("member_key") + "'  \n")
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
			LoggingWriter.setLogError("M404S070100E214()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M404S070100E214()","==== finally ===="+ e.getMessage());
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
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			System.out.println("JSONObject jArray rcvData="+ jArray.toString());
//			String rcvData = (String) ((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
//			// 클라이언트로 부터 받은 파라미터를 쪼개어서 배열에 담는다.
//			String[][] c_paramArray = CommonFunction.getConvString2DoubleArray(rcvData);
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
					.append("	WHERE  A.order_no = '" 		+ jArray.get("order_no") + "' \n")
					.append("		AND	A.lotno = '" 		+ jArray.get("lotno") + "' \n")
					.append("		AND	A.member_key = '" 	+ jArray.get("member_key") + "'  \n")
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
					.append("	WHERE  A.order_no = '" 	+ jArray.get("order_no") + "' \n")
					.append("		AND	A.lotno = '" 	+ jArray.get("lotno") + "' \n")
					.append("		AND	A.member_key = '" + jArray.get("member_key") + "'  \n")
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
			LoggingWriter.setLogError("M404S070100E125()", "==== SQL ERROR ====" + e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR;
		} finally {
			if (Config.useDataSource) {
				try {
					if (con != null)
						con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M404S070100E125()","==== finally ===="+ e.getMessage());
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
					.append("        INNER JOIN      tbi_order_product_inspect_checklist O\n")
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
					.append("        INNER JOIN      tbm_checklist A\n")
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
					.append("where   D.order_no like '%" 	+ jArray.get("order_no") + "' \n")
					.append("AND  	 D.lotno like '%" 		+ jArray.get("lotno") + "' \n")
					.append("AND  	 O.inspect_gubun = 'PRODCT' \n")
					.append("AND 	 D.member_key = '" 		+ jArray.get("member_key") + "'  \n")
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
			LoggingWriter.setLogError("M404S070100E134()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M404S070100E134()","==== finally ===="+ e.getMessage());
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
	public int E234(InoutParameter ioParam){
	resultInt = EventDefine.E_DOEXCUTE_INIT;
	
	try {
		con = JDBCConnectionPool.getConnection();
		
		JSONObject jArray = new JSONObject();
		jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
		System.out.println("JSONObject jArray rcvData="+ jArray.toString());

		String sql = new StringBuilder()
				.append("SELECT DISTINCT\n")
				.append("	D.order_no,\n")
				.append("	D.project_name,\n")
				.append("	D.product_serial_no,\n")
				.append("	D.lotno,\n")
				.append("	D.lot_count,\n")
				.append("	K.pic_seq,\n")
				.append("	K.prod_cd,\n")
				.append("	P.product_nm,\n")
				.append("	'' AS order_check_no,\n")
				.append("	A.checklist_seq,\n")
				.append("	A.checklist_cd,\n")
				.append("	A.standard_guide,\n")
				.append("	A.check_note,\n")
				.append("	A.standard_value,\n")
				.append("	B.item_type,\n")
				.append("	B.item_bigo,\n")
				.append("	K.prod_cd_rev,\n")
				.append("	K.checklist_cd_rev,\n")
				.append("	A.item_cd,\n")
				.append("	B.item_desc,\n")
				.append("	A.item_seq,\n")
				.append("	A.item_cd_rev,\n")
				.append("	'N' AS pass_yn,\n")
				.append("	K.inspect_gubun,\n")
				.append("	E.code_name,\n")
				.append("	D.order_detail_seq\n")
				.append("FROM tbi_order D\n")
				.append("INNER JOIN tbm_product P\n")
				.append("	ON D.prod_cd = P.prod_cd\n")
				.append("	AND D.prod_rev = P.revision_no\n")
				.append("	AND D.member_key = P.member_key\n")
				.append("INNER JOIN tbm_product_inspect_checklist K\n")
				.append("	ON P.prod_cd = K.prod_cd\n")
				.append("	AND P.revision_no = K.prod_cd_rev\n")
				.append("	AND P.member_key = K.member_key\n")
				.append("INNER JOIN      tbm_checklist A\n")
				.append("	ON K.checklist_cd = A.checklist_cd\n")
				.append("	AND K.checklist_seq = A.checklist_seq\n")
				.append("	AND K.checklist_cd_rev = A.revision_no\n")
				.append("	AND K.member_key = A.member_key\n")
				.append("INNER JOIN tbm_check_item B\n")
				.append("	ON A.item_cd = B.item_cd\n")
				.append("	AND A.item_seq = B.item_seq\n")
				.append("	AND A.item_cd_rev = B.revision_no\n")
				.append("	AND A.member_key = B.member_key\n")
				.append("INNER JOIN v_checklist_gubun E\n")
				.append("	ON K.inspect_gubun = E.code_value\n")
				.append("	AND K.member_key = E.member_key\n")
				.append("WHERE D.order_no like '%" + jArray.get("order_no") + "'\n")
				.append("	AND D.lotno like '%" + jArray.get("lotno") + "'\n")
				.append("	AND D.order_detail_seq = '" + jArray.get("order_detail_seq") + "'\n")
				.append("	AND K.inspect_gubun = 'SHIPMENT'\n")
				.append("	AND D.member_key = '" + jArray.get("member_key") + "'\n")
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
			LoggingWriter.setLogError("M404S070100E234()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
		} finally {
			if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M404S070100E234()","==== finally ===="+ e.getMessage());
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
	public int E244(InoutParameter ioParam){ //
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			System.out.println("JSONObject jArray rcvData="+ jArray.toString());
			
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
					.append("        LEFT OUTER JOIN tbm_product C\n")
					.append("        ON A.prod_cd = C.prod_cd\n")
					.append("        AND A.prod_cd_rev = C.revision_no\n")
					.append("   	 AND A.member_key = C.member_key\n")
					.append("        INNER JOIN v_checklist_gubun D\n")
					.append("        ON A.inspect_gubun = D.code_value\n")
					.append("   	 AND A.member_key = D.member_key\n")
					.append("where  A.order_no = '" + jArray.get("order_no") + "' \n")
					.append("AND  	A.lotno = '" 	+ jArray.get("lotno") + "' \n")
//					.append("AND  	A.inspect_gubun like '%" + jArray.get("inspect_gubun") + "' \n")
					.append("AND  	A.inspect_gubun = 'SHIPMENT' \n")
					.append("AND	A.product_serial_no like '%" 	 + jArray.get("product_serial_no") + "'\n")
					.append("AND	A.product_serial_no_end like '%" + jArray.get("product_serial_no_end") + "'\n")
					.append("AND	A.inspect_seq = '" + jArray.get("inspect_seq") + "'\n")
					.append("AND 	A.member_key = '" 				 + jArray.get("member_key") + "'  \n")
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
			LoggingWriter.setLogError("M404S070100E244()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M404S070100E244()","==== finally ===="+ e.getMessage());
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

