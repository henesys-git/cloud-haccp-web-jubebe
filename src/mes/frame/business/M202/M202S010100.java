package mes.frame.business.M202;

import java.lang.reflect.Method;
import java.sql.Connection;
import java.sql.PreparedStatement;

import org.apache.log4j.Logger;
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

public class M202S010100 extends SqlAdapter {
	static final Logger logger = Logger.getLogger(M202S010100.class.getName());
	
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
	
	public M202S010100(){
	}
	
	/**
	 * ����ڰ� �����ؼ� �Ķ���� �����ϴ� method.
	 * @param	ioParam , p_sql
	 * @return the desired integer.
	 */
	public int custParamCheck(InoutParameter ioParam, StringBuffer p_sql){
		int paramInt = 0;
		return paramInt;
	}
	/**
	 * �Է��Ķ��Ÿ�� 2���� �����ΰ�� �Ķ���� �����ϴ� method.
	 * @param	ioParam , p_sql
	 * @return the desired integer.
	 */
	public int paramCheck(InoutParameter ioParam, StringBuffer p_sql){
		v_paramArray = super.getParamCheck(ioParam,p_sql);
		return v_paramArray[0].length;
	}
	/**
	 * �Է��Ķ��Ÿ���� �̺�ƮID���� �޼ҵ� ȣ���ϴ� method.
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
			
			Method method = M202S010100.class.getMethod(event,optClass);
			LoggingWriter.setLogDebug(M202S010100.class.getName(),"==== " + event + " EventMethod Create Success ====");

			obj = method.invoke(M202S010100.class.newInstance(),optObj);
			doExcute_result = CommonFunction.getInt(obj.toString());
			
	    } catch (Exception ex) {
	    	doExcute_result = EventDefine.E_DOEXCUTE_INIT;
			ioParam.setMessage(MessageDefine.M_NO_EVENTID);
			LoggingWriter.setLogError(M202S010100.class.getName(),"==== EventID Not define : EVENT ID [ " + ioParam.getEventID() + "]");
	    } finally {
	    	obj = null;
			optClass = null;
			optObj = null;
	    }
	    long endTime = System.currentTimeMillis();
		long runningTime = endTime - startTime;
		logger.debug("Query [����ð�  : " + runningTime + " ms]");
		
		return doExcute_result;
	}
	
	//���ּ� ���
	public int E101(InoutParameter ioParam){ 
			resultInt = EventDefine.E_DOEXCUTE_INIT;
			String sql ="";
			ApprovalActionNo ActionNo;
			String Order_Balju_No="";
			
			try {
				con = JDBCConnectionPool.getConnection();
	    		JSONObject jArray = new JSONObject();
	    		jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));

	    		// ���ּ� ������ ��� �迭
	    		JSONObject jArrayHead = (JSONObject) jArray.get("paramHead");
	    		JSONArray jjArray = (JSONArray) jArray.get("param");
	    		
	    		String jspPage = (String)jArrayHead.get("jsp_page");
	    		String user_id = (String)jArrayHead.get("user_id");
	    		String prefix = (String)jArrayHead.get("prefix");
	    		String actionGubun = "Regist";
	    		String detail_seq = (String)jArrayHead.get("detail_seq");
	    		String member_key = (String)jArrayHead.get("member_key");
	    		
				ActionNo = new ApprovalActionNo();
				Order_Balju_No = ActionNo.getActionNo(con,jspPage,user_id,prefix,actionGubun,detail_seq,member_key);//GV_JSPPAGE(action Page), User ID, prefix

				sql = new StringBuilder()
						.append("INSERT INTO tbi_balju (\n")
						.append("	order_no,\n")
						.append("	order_detail_seq,\n")
						.append("	balju_no,\n")
						.append("	balju_text,\n")
						.append("	balju_send_date,\n")
						.append("	balju_nabgi_date,\n")
						.append("	cust_cd,\n")
						.append("	cust_damdang,\n")
						.append("	tell_no,\n")
						.append("	fax_no,\n")
						.append("	nabpoom_location,\n")
						.append("	qa_ter_condtion, \n")
						.append("	cust_cd_rev, \n")
						.append("	lotno \n")
						.append(" 	,member_key	\n") // member_key_insert
						.append(")\n")
						.append("VALUES(\n")
						.append(" 	'" + jArrayHead.get("order_no") + "',	\n") //order_no
						.append(" 	'" + jArrayHead.get("order_detail_seq") + "',	\n") //order_detail_seq
						.append(" 	'" + Order_Balju_No + "',     \n")	//balju_no
						.append(" 	'" + jArrayHead.get("balju_text") + "',	\n") // balju_text
						.append(" 	'" + jArrayHead.get("balju_send_date") + "', 	\n") // balju_send_date			
						.append(" 	'" + jArrayHead.get("balju_nabgi_date") + "',	\n") // balju_nabgi_date 
						.append(" 	'" + jArrayHead.get("cust_cd") + "',	\n") //	cust_cd
						.append(" 	'" + jArrayHead.get("cust_damdang") + "',	\n") // cust_damdang
						.append(" 	'" + jArrayHead.get("tell_no") + "',	\n") //	tell_no
						.append(" 	'" + jArrayHead.get("fax_no") + "',	\n") // fax_no
						.append(" 	'" + jArrayHead.get("nabpoom_location") + "',	\n") // nabpoom_location
						.append(" 	'" + jArrayHead.get("qa_ter_condtion") + "', \n") //qa_ter_condtion
						.append(" 	'" + jArrayHead.get("cust_cd_rev") + "', \n") //cust_cd_rev
						.append(" 	'" + jArrayHead.get("lotno") + "', \n") //lotno
						.append(" 	'" + jArrayHead.get("member_key") + "' \n") //member_key
						.append(");\n")
						.toString();

					resultInt = super.excuteUpdate(con, sql.toString());
		    		if (resultInt < 0) {  //
						ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
						con.rollback();
						return EventDefine.E_DOEXCUTE_ERROR ;
					}
		    		else {
		    			System.out.println("c_paramArray_Detail[i][4]=" + jjArray.size());
				    	for(int i=0; i<jjArray.size(); i++) {  
				    		// BOM �����Ͱ� ��� �迭
				    		JSONObject jjjArray = (JSONObject)jjArray.get(i);

				    		sql = new StringBuilder()
			    				.append("INSERT INTO tbi_balju_list (\n")
			    				.append("	balju_no,\n")
			    				.append("	balju_seq,\n")
			    				.append("	bom_nm,\n") //���� jaryo_irum���� ����
			    				.append("	bom_cd,\n") //���� jaryo_bunho
//			    				.append("	bupum_bunho,\n") // part_cd�� ��ü
			    				.append("	part_cd,\n")
			    				.append("	gyugeok,\n")
			    				.append("	balju_count,\n")
			    				.append("	list_price,\n")
			    				.append("	balju_amt,\n")
			    				.append("	rev_no, \n")
			    				.append("	part_cd_rev \n")
			    				.append(" 	,member_key	\n") // member_key_insert
			    				.append(")\n")
			    				.append("VALUES (\n")
								.append(" 	'" + Order_Balju_No + "',     \n")	//balju_no
								.append(" 	'" + jjjArray.get("balju_seq") 	+ "',	\n") //balju_seq
								.append(" 	'" + jjjArray.get("bom_nm") 	+ "',	\n") //jaryo_irum
								.append(" 	'" + jjjArray.get("bom_cd") 	+ "', 	\n") //jaryo_bunho			
//								.append(" 	'" + jjjArray.get("bupum_bunho") 	+ "',	\n") //bupum_bunho
								.append(" 	'" + jjjArray.get("part_cd") 		+ "',	\n") //part_cd	
								.append(" 	'" + jjjArray.get("gyugeok") 		+ "',	\n") //gyugeok
								.append(" 	'" + jjjArray.get("balju_count") 	+ "',	\n") //balju_count	
								.append(" 	'" + jjjArray.get("list_price") 	+ "',	\n") //list_price 
								.append(" 	'" + jjjArray.get("balju_amt") 	+ "',	\n") //balju_amt
								.append(" 	'" + jjjArray.get("rev_no") 		+ "',	\n") //rev_no
								.append(" 	'" + jjjArray.get("part_cd_rev") 	+ "',	\n") //part_cd_rev
								.append(" 	'" + jjjArray.get("member_key") 	+ "' 	\n") //member_key
			    				.append(");\n")
			    				.toString();

								resultInt = super.excuteUpdate(con, sql.toString());
					    		if (resultInt < 0) {  //
									ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
									con.rollback();
									return EventDefine.E_DOEXCUTE_ERROR ;
								}
				    	}
		    		}
				
				con.commit();
				
			} catch(Exception e) {
				LoggingWriter.setLogError("M202S010100E101()","==== SQL ERROR ===="+ e.getMessage());
				return EventDefine.E_DOEXCUTE_ERROR ;
		    } finally {
		    	if (Config.useDataSource) {
					try {
						if (con != null) con.close();
					} catch (Exception e) {
						LoggingWriter.setLogError("M202S010100E101()","==== finally ===="+ e.getMessage());
					}
		    	} else {
		    	}
		    }
			ioParam.setResultString(resultString);
			ioParam.setColumnCount("" + super.COLUMN_COUNT);
	    	ioParam.setMessage(MessageDefine.M_QUERY_OK);
		    return EventDefine.E_QUERY_RESULT;
	}	
	
	public int E102(InoutParameter ioParam){
		
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		String sql ="";
		ApprovalActionNo ActionNo;
		String Order_Balju_No = "";
		
		try {
			con = JDBCConnectionPool.getConnection();
			con.setAutoCommit(false);
			
    		// insert_update_delete_json.jsp���� �޾ƿ� JSON������ ó��
    		JSONObject jArray = new JSONObject();
    		jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
    		System.out.println("JSONObject jArray rcvData="+ jArray.toString());
    		
    		// Object�����Ϳ��� Ű��(param)���� JSONArray�����͸� ������. (�����͹��� �ϳ��϶� ����)
    		JSONObject jArrayHead = (JSONObject) jArray.get("paramHead");
    		JSONArray jjArray = (JSONArray) jArray.get("param");
			
    		String jspPage = (String)jArrayHead.get("jsp_page");
    		String user_id = (String)jArrayHead.get("user_id");
 
    		String prefix = (String)jArrayHead.get("order_no");
    		String actionGubun = "Regist";
    		String detail_seq = (String)jArrayHead.get("balju_no");
    		String member_key = (String)jArrayHead.get("member_key");
    		
			ActionNo = new ApprovalActionNo();
			Order_Balju_No = ActionNo.getActionNo(con,jspPage,user_id,prefix,actionGubun,detail_seq,member_key);//GV_JSPPAGE(action Page), User ID, prefix
					
			 sql = new StringBuilder()
					.append("UPDATE\n")
					.append("	tbi_balju\n")
					.append("SET\n")
					.append("	order_no = '"			+ jArrayHead.get("order_no") 			+ "',	\n")
					.append("	balju_no = '" 			+ jArrayHead.get("balju_no") 			+ "',	\n")
					.append("	balju_text = '" 		+ jArrayHead.get("balju_text") 			+ "',	\n")					
					.append("	balju_send_date	= '" 	+ jArrayHead.get("balju_send_date") 	+ "',	\n")
					.append("	balju_nabgi_date = '" 	+ jArrayHead.get("balju_nabgi_date") 	+ "',	\n")
				//	.append("	cust_cd = '" + c_paramArray_Head[0][9] + "'	,\n")
					.append("	cust_damdang = '" 		+ jArrayHead.get("cust_damdang") 		+ "',	\n")
					.append("	tell_no = '" 			+ jArrayHead.get("tell_no") 			+ "',	\n")
					.append("	fax_no = '" 			+ jArrayHead.get("fax_no") 				+ "',	\n")			
					.append("	nabpoom_location = '" 	+ jArrayHead.get("nabpoom_location") 	+ "',	\n")
					.append("	qa_ter_condtion = '" 	+ jArrayHead.get("qa_ter_condtion") 	+ "',	\n")
					.append("	lotno = '" 				+ jArrayHead.get("lotno") 				+ "'	\n")
					.append(" 	,member_key = '" 		+ jArrayHead.get("member_key") + "'		\n") //member_key_update
					.append("WHERE order_no = '"		+ jArrayHead.get("order_no") 			+ "'	\n")
					.append("	AND lotno = '" 			+ jArrayHead.get("lotno") 				+ "'	\n")
					.append("	AND balju_no = '" 		+ jArrayHead.get("balju_no") 			+ "'	\n")
					.append("	AND member_key = '" 	+ jArrayHead.get("member_key") 			+ "'	\n")
					.toString();
			 
				resultInt = super.excuteUpdate(con, sql.toString());
	    		if (resultInt < 0) {  //
					ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
					con.rollback();
					return EventDefine.E_DOEXCUTE_ERROR ;
				}
	    		else {
	    			for(int i=0; i<jjArray.size(); i++) {  
			    		JSONObject jjjArray = (JSONObject)jjArray.get(i);

			    		sql = new StringBuilder()
								.append("MERGE  INTO tbi_balju_list  mm     \n")
								.append("USING ( SELECT     \n")
								.append("	'" + jjjArray.get("balju_no")  	 + "' AS balju_no,		\n")
								.append("	'" + jjjArray.get("balju_seq") 	 + "' AS balju_seq,		\n")
								.append("	'" + jjjArray.get("bom_nm")  + "' AS bom_nm,	\n")
								.append("	'" + jjjArray.get("bom_cd") + "' AS bom_cd,	\n")
								.append("	'" + jjjArray.get("part_cd") 	 + "' AS part_cd,		\n")
								.append("	'" + jjjArray.get("gyugeok") 	 + "' AS gyugeok,		\n")
								.append("	'" + jjjArray.get("balju_count") + "' AS balju_count,	\n")
								.append("	'" + jjjArray.get("list_price")  + "' AS list_price, 	\n")
								.append("	'" + jjjArray.get("balju_amt") 	 + "' AS balju_amt,  	\n")
								.append("	'" + jjjArray.get("rev_no") 	 + "' AS rev_no,  		\n")
								.append("	'" + jjjArray.get("part_cd_rev") + "' AS part_cd_rev,	\n")
								.append("	'" + jjjArray.get("member_key")  + "' AS member_key		\n")
								.append(")  mQ    \n")
								.append("ON (mm.balju_no = mQ.balju_no AND mm.balju_seq = mQ.balju_seq AND mm.bom_cd = mQ.bom_cd  AND mm.part_cd = mQ.part_cd  AND mm.member_key=mQ.member_key)    \n")
								.append("WHEN MATCHED THEN     \n")
								.append("		UPDATE SET     \n")
								.append("			mm.balju_no		= mQ.balju_no,		mm.balju_seq 	= mQ.balju_seq,	mm.bom_nm	= mQ.bom_nm, mm.bom_cd	= mQ.bom_cd,	    \n")
								.append("			mm.part_cd 		= mQ.part_cd, 	mm.gyugeok		= mQ.gyugeok,   mm.balju_count 	= mQ.balju_count,	    \n")
								.append("			mm.list_price	= mQ.list_price,	mm.balju_amt	= mQ.balju_amt,	mm.rev_no		= mQ.rev_no,	mm.part_cd_rev	= mQ.part_cd_rev, mm.member_key=mQ.member_key   	\n")
								.append("WHEN NOT MATCHED THEN \n")
								.append("	INSERT  (mm.balju_no, mm.balju_seq, mm.bom_nm, mm.bom_cd, mm.part_cd,	mm.gyugeok, mm.balju_count,	mm.list_price, mm.balju_amt, mm.rev_no, mm.part_cd_rev, mm.member_key)    \n")
								.append("	VALUES  (mQ.balju_no, mQ.balju_seq, mQ.bom_nm, mQ.bom_cd, mQ.part_cd, 	mQ.gyugeok, mQ.balju_count, mQ.list_price, mQ.balju_amt, mQ.rev_no, mQ.part_cd_rev, mQ.member_key)    \n")
								.append(";    \n")
								.toString();
							resultInt = super.excuteUpdate(con, sql.toString());
				    		if (resultInt < 0) {  //
								ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
								con.rollback();
								return EventDefine.E_DOEXCUTE_ERROR ;
							}
			    	}
	    		}
			
			con.commit();
			
		} catch(Exception e) {
			LoggingWriter.setLogError("M202S010100E102()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M202S010100E102()","==== finally ===="+ e.getMessage());
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
	
			// Ŭ���̾�Ʈ�� ���� ���� �Ķ���͸� �Ű� ��´�.
			String rcvData = (String)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			String[][] c_paramArray = CommonFunction.getConvString2DoubleArray(rcvData);
	
				
				String review_action_no="",confirm_action_no="";//������ ���´�� ����
				String jspPage 			= c_paramArray[0][0];
				String order_detail_seq = c_paramArray[0][3];
				String gOrderNo 		= c_paramArray[0][2];
				String main_action_no 	= c_paramArray[0][2];
				String indGb			= c_paramArray[0][4];
				String lotno			= c_paramArray[0][5];
				String member_key			= c_paramArray[0][6];
				if(Queue.setQueue(con, jspPage, gOrderNo, order_detail_seq, main_action_no, review_action_no, confirm_action_no
						,indGb,lotno,member_key)<0) {
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
					LoggingWriter.setLogError("M202S010100E122()","==== finally ===="+ e.getMessage());
				}
	    	} else {
	    	}
	    }
	    // ��� ���� ������ ���� �Ķ���͵��� ���̿� �Ķ���Ϳ� �����Ѵ�.
		ioParam.setResultString(resultString);
		// ���ۿ��� ó���� Į���� ������ Ŭ���̾�Ʈ���� ������ ���� �����´�.
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
		// �� ó���Ǿ��ٴ� �޽����� Ŭ���̾�Ʈ���� ������ ���� I/O�Ķ���Ϳ� �����Ѵ�.
		ioParam.setMessage(MessageDefine.M_QUERY_OK);
	    return EventDefine.E_QUERY_RESULT;
	}


	//���ּ� ����
	public int E103(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
    		JSONObject jArray = new JSONObject();
    		jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
    		System.out.println("JSONObject jArray rcvData="+ jArray.toString());
			
			// Ŭ���̾�Ʈ�� ���� ���� �Ķ���͸� �ɰ�� �迭�� ��´�.
			
			String sql = new StringBuilder()
					.append("DELETE FROM tbi_balju \n")
					.append("WHERE balju_no = '" + jArray.get("balju_no") + "'\n")
					.append("AND member_key = '" + jArray.get("member_key") + "'\n")
					.toString();

			// super�� excuteUpdate�� 3������ �ִ�.
			// ù°�� super.excuteUpdate(con, sql.toString(), v_paramArray)���� �̸�,
			// PreparedStatement�� ����ϱ� ���� �Ķ���͵��� ��ɿ� ��� ������ üũ�� �ؼ� �����ϴ� �����̴�. �׸���
			// �ι�°�� super.excuteUpdate(con, Vector)�ε�, ��Ƽ �ο츦 ����ϱ� ���� ���õ� ��ġ�̴�.
			// ����°�� �ϳ��� SQL�� String���� �޾Ƽ� ó���ϴ� ����̴�.
			// ���� ���� SQL���¶��.. �翬�� 1���� �ο쿡 �ش�ǹǷ� ����° �޽�带 ����ϴ� ���� ���ϴ�.
			resultInt = super.excuteUpdate(con, sql.toString());

		} catch(Exception e) {
			LoggingWriter.setLogError("M202S010100E103()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M202S010100E103()","==== finally ===="+ e.getMessage());
				}
	    	} else {
	    	}
	    }
	    // ��� ���� ������ ���� �Ķ���͵��� ���̿� �Ķ���Ϳ� �����Ѵ�.
		ioParam.setResultString(resultString);
		// ���ۿ��� ó���� Į���� ������ Ŭ���̾�Ʈ���� ������ ���� �����´�.
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
		// �� ó���Ǿ��ٴ� �޽����� Ŭ���̾�Ʈ���� ������ ���� I/O�Ķ���Ϳ� �����Ѵ�.
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
					.append("	C.cust_nm,  		--����\n")
					.append("	B.product_nm || '('||D.code_name  ||','||  E.code_name ||')',	--��ǰ��\n")
					.append("	cust_pono,			--PO��ȣ\n")
        			.append("	product_gubun,		--��ǰ����\n")
        			.append("	part_source,   		--�����������\n")
					.append("	order_date,      	--�ֹ���\n")
					.append("	A.lotno,           	--lot��ȣ\n")
					.append("	lot_count,    		--lot����\n")
					.append("	part_chulgo_date,	--ȸ�����������\n")
					.append("	rohs,				--rohs\n")
					.append("	order_note,			--Ư�̻���\n")
					.append("	delivery_date,   	--������\n")
					.append("	bom_version,		\n")
					.append("	A.order_no,    		--�ֹ���ȣ\n")
					.append("	' ' AS process_name,--�����¸�\n")
//					.append("	S.process_name,		--�����¸�\n")
					.append("	A.bigo,         	--���\n")
					.append("	product_serial_no, 		--�Ϸù�ȣ\n")
					.append("	product_serial_no_end, 	--�Ϸù�ȣ��  \n")
					.append("	A.cust_cd,\n")
					.append("	A.cust_rev,\n")
					.append("	A.prod_cd,\n")
					.append("	A.prod_rev,\n")
					.append("	' ' AS order_status,\n")
//					.append("	Q.order_status,\n")
        			.append("	DECODE(product_gubun,'0','���ǰ','1','����ǰ') AS product_gubun,	--��ǰ����\n")
        			.append("	DECODE(part_source,'01','���','02','����','03','���&����') AS part_source,   		--�����������\n")
					.append("	DECODE(rohs,'0','Pb Free','1','Pb') AS rohs					--rohs\n")
					.append("FROM tbi_order A\n")
					.append("INNER JOIN tbm_customer C\n")
					.append("    ON A.cust_cd = C.cust_cd\n")
					.append("    AND A.cust_rev = C.revision_no\n")
					.append("    AND A.member_key = C.member_key\n")
//					.append("INNER JOIN tbi_queue Q\n")
//					.append("        ON A.order_no = Q.order_no\n")
//					.append("        AND A.lotno = Q.lotno\n")
//					.append("INNER JOIN tbm_systemcode S\n")
//					.append("        ON Q.order_status = S.status_code\n")
//					.append("        AND Q.process_gubun = S.process_gubun\n")
					.append("INNER JOIN tbm_product B\n")
					.append("	ON A.prod_cd = B.prod_cd\n")
					.append("	AND A.prod_rev = B.revision_no\n")
					.append("   AND A.member_key = B.member_key\n")					
					.append("	INNER JOIN v_prodgubun_big D 									\n")
					.append("	   ON B.prod_gubun_b = D.code_value 							\n")
					.append("     AND B.member_key = D.member_key 								\n")
					.append("	INNER JOIN v_prodgubun_mid E 									\n")
					.append("	   ON B.prod_gubun_m = E.code_value 							\n")
					.append("     AND B.member_key = E.member_key 								\n")					
					.append("WHERE A.cust_cd LIKE '%" 	+ jArray.get("custcode") + "'	\n")
//					.append("AND S.class_id = '" 		+ jArray.get("jsppage") + "' 	\n")
					.append("AND A.member_key = '"+ jArray.get("member_key") + "'\n")
					.append("AND order_date \n")					
					.append("BETWEEN '" + jArray.get("fromdate") + "' 	\n")
					.append("AND '" + jArray.get("todate") + "'	\n")
					
					.toString();

			String ActionCommand = ioParam.getActionCommand();
			if(ActionCommand.startsWith("doQueryTableFieldName")) {
				resultString = super.excuteQueryStringTableFieldName(con, sql.toString());
			} //�����信�������ϱ����ؼ� ������ �ͽ�ťƮ������Ʈ�����̺��ʵ����
			else {;
				resultString = super.excuteQueryString(con, sql.toString());
			}
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M202S010100E104()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M202S010100E104()","==== finally ===="+ e.getMessage());
				}
	    	} else {
	    	}
	    }
	    // ��� ���� ������ ���� �Ķ���͵��� ���̿� �Ķ���Ϳ� �����Ѵ�.
		ioParam.setResultString(resultString);
		// ���ۿ��� ó���� Į���� ������ Ŭ���̾�Ʈ���� ������ ���� �����´�.
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
		// �� ó���Ǿ��ٴ� �޽����� Ŭ���̾�Ʈ���� ������ ���� I/O�Ķ���Ϳ� �����Ѵ�.
    	ioParam.setMessage(MessageDefine.M_QUERY_OK);
	    return EventDefine.E_QUERY_RESULT;
	}	

	//��������(S202S010110_select_date)
	public int E114(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			
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
					.append("WHERE order_no = '" + jArray.get("order_no") + "'\n")
//					.append("	AND lotno = '" 		+ c_paramArray[0][1] + "'\n")
					.append("	AND lotno = '" + jArray.get("lotno") + "'\n")
					.append("AND A.member_key = '" + jArray.get("member_key") + "' \n")
					.toString();
//s202s010110����÷� ������ �����ֱ� 12��31�� 12��40��
			String ActionCommand = ioParam.getActionCommand();
			if(ActionCommand.startsWith("doQueryTableFieldName")) {
				resultString = super.excuteQueryStringTableFieldName(con, sql.toString());
			}
			else {;
				resultString = super.excuteQueryString(con, sql.toString());
			}
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M202S010100E114()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M202S010100E114()","==== finally ===="+ e.getMessage());
				}
	    	} else {
	    	}
	    }
	    // ��� ���� ������ ���� �Ķ���͵��� ���̿� �Ķ���Ϳ� �����Ѵ�.
		ioParam.setResultString(resultString);
		// ���ۿ��� ó���� Į���� ������ Ŭ���̾�Ʈ���� ������ ���� �����´�.
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
		// �� ó���Ǿ��ٴ� �޽����� Ŭ���̾�Ʈ���� ������ ���� I/O�Ķ���Ϳ� �����Ѵ�.
    	ioParam.setMessage(MessageDefine.M_QUERY_OK);
	    return EventDefine.E_QUERY_RESULT;
	}

	//����BOM��ȸ S02S010120.jspww
	public int E124(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();				
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			
			String sql = new StringBuilder()
					.append("SELECT DISTINCT\n")
					.append("        A.order_no,\n")
					.append("        A.bom_cd,\n")
					.append("        A.bom_name,\n")
					.append("        sys_bom_id,\n")
					.append("        C.part_nm || '('||E.code_name  ||','||  F.code_name ||')',\n")
					.append("        A.part_cd,\n")
					.append("        C.gyugyeok,\n")
					.append("        A.part_cnt,\n")
					.append("        TO_CHAR (C.unit_price, '999,999,999,999'),\n")
					.append("        TO_CHAR (A.part_cnt * C.unit_price, '999,999,999,999') AS part_amt,\n")
					.append("        A.bom_cd_rev,\n")
					.append("        A.part_cd_rev,\n")
					.append("        SUM(NVL(D.post_amt,0))\n")
					.append("FROM tbi_order_bomlist A\n")
					.append("        LEFT OUTER JOIN tbm_part_list C\n")
					.append("        ON A.part_cd = C.part_cd\n")
					.append("        AND A.part_cd_rev = C.revision_no\n")
					.append("		AND A.member_key = C.member_key\n")
					.append("		LEFT OUTER JOIN tbi_part_storage D\n")
					.append("		ON A.part_Cd = D.part_cd\n")
					.append("		AND A.part_cd_rev = D.part_cd_rev\n")
					.append("		AND A.member_key = D.member_key\n")
					.append("		INNER JOIN v_partgubun_big E\n")
					.append("           ON C.part_gubun_b = E.code_value\n")
					.append("     		AND C.member_key = E.member_key\n")
					.append("        INNER JOIN v_partgubun_mid F\n")
					.append("           ON C.part_gubun_m = F.code_value\n")
					.append("     		AND C.member_key = F.member_key\n")		
					.append("WHERE A.order_no = '" + jArray.get("order_no") + "' \n")
					.append("AND A.lotno = '" + jArray.get("lotno") + "' \n")
					.append("AND A.member_key = '" + jArray.get("member_key") + "' 	\n")
					.append("GROUP BY A.part_cd \n")
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
			LoggingWriter.setLogError("M202S010100E124()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M202S010100E124()","==== finally ===="+ e.getMessage());
				}
	    	} else {
	    	}
	    }
		ioParam.setResultString(resultString);
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
    	ioParam.setMessage(MessageDefine.M_QUERY_OK);
	    return EventDefine.E_QUERY_RESULT;
	}
		
	//��������(Balju_form_view.jsp)
	public int E134(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			
			String sql = new StringBuilder()
					.append("SELECT DISTINCT\n")
					.append("	order_no,\n")
					.append("	balju_no,\n")
					.append("	balju_text,\n")
					.append("	balju_send_date,\n")
					.append("	b.cust_nm,\n")
					.append("	cust_damdang,\n")
					.append("	tell_no,\n")
					.append("	fax_no,\n")
					.append("	balju_nabgi_date,\n")
					.append("	nabpoom_location,\n")
					.append("	qa_ter_condtion,\n")
					.append("	balju_status,\n")
					.append("	review_no,\n")
					.append("	confirm_no\n")
					.append("FROM tbi_balju A \n")
					.append("	INNER JOIN vtbm_customer B \n")
					.append("	ON A.cust_cd = b.cust_cd\n")
					.append("   AND A.member_key = B.member_key\n")
					.append("WHERE order_no = '" + jArray.get("order_no") + "' \n")
					.append("AND A.balju_no = '" + jArray.get("baljuno") + "' \n")
					.append("AND A.member_key = '" + jArray.get("member_key") + "' \n")
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
			LoggingWriter.setLogError("M202S010100E134()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M202S010100E134()","==== finally ===="+ e.getMessage());
				}
	    	} else {
	    	}
	    }
	    // ��� ���� ������ ���� �Ķ���͵��� ���̿� �Ķ���Ϳ� �����Ѵ�.
		ioParam.setResultString(resultString);
		// ���ۿ��� ó���� Į���� ������ Ŭ���̾�Ʈ���� ������ ���� �����´�.
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
		// �� ó���Ǿ��ٴ� �޽����� Ŭ���̾�Ʈ���� ������ ���� I/O�Ķ���Ϳ� �����Ѵ�.
    	ioParam.setMessage(MessageDefine.M_QUERY_OK);
	    return EventDefine.E_QUERY_RESULT;
	}
	
	
	
	
	//��������(Balju_form_view.jsp) ����������
	public int E144(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			
			String sql = new StringBuilder()
					.append("SELECT\n")
					.append("	B.order_no ,\n")
					.append("	A.balju_no,\n")
					.append("	A.balju_seq,\n")
					.append("	A.bom_nm,\n")
					.append("	A.bom_cd,\n")
					.append("	A.part_cd,\n")
					.append("	A.gyugeok,\n")
					.append("	A.balju_count,	\n")
					.append("	A.list_price, \n")
					.append("	A.balju_amt, \n")
					.append("	A.rev_no,\n")
					.append("	A.part_cd_rev, '' as butn \n")
					.append("FROM tbi_balju B\n")
					.append("	INNER JOIN tbi_balju_list A\n")
					.append("	ON B.balju_no = A.balju_no\n")
					.append("   AND B.member_key = A.member_key\n")
					.append("WHERE order_no = '" + jArray.get("order_no") + "' \n")
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
			LoggingWriter.setLogError("M202S010100E144()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M202S010100E144()","==== finally ===="+ e.getMessage());
				}
	    	} else {
	    	}
	    }
	    // ��� ���� ������ ���� �Ķ���͵��� ���̿� �Ķ���Ϳ� �����Ѵ�.
		ioParam.setResultString(resultString);
		// ���ۿ��� ó���� Į���� ������ Ŭ���̾�Ʈ���� ������ ���� �����´�.
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
		// �� ó���Ǿ��ٴ� �޽����� Ŭ���̾�Ʈ���� ������ ���� I/O�Ķ���Ϳ� �����Ѵ�.
		ioParam.setMessage(MessageDefine.M_QUERY_OK);
	    return EventDefine.E_QUERY_RESULT;
	}
	
	// â����� Ȯ��(S202S010180.jsp)
	public int E184(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			System.out.println("JSONObject jArray rcvData="+ jArray.toString());
			
			String sql = new StringBuilder()
					.append("SELECT \n")
					.append("	A.part_cd,\n")
					.append("	A.revision_no,\n")
					.append("	A.part_nm,\n")
					.append("	NVL(S.post_amt, 0) AS jaego,\n")
					.append("	A.safety_jaego\n")
					.append("FROM tbm_part_list A\n")
					.append("LEFT OUTER JOIN tbi_part_storage S\n")
					.append("	ON A.part_cd=S.part_cd\n")
					.append("	AND A.revision_no=S.part_cd_rev\n")
					.append("	AND A.member_key=S.member_key\n")
					.append(jArray.get("gv_where"))
					.append("ORDER BY A.part_cd\n")
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
			LoggingWriter.setLogError("M202S010100E184()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M202S010100E184()","==== finally ===="+ e.getMessage());
				}
	    	} else {
	    	}
	    }
	    // ��� ���� ������ ���� �Ķ���͵��� ���̿� �Ķ���Ϳ� �����Ѵ�.
		ioParam.setResultString(resultString);
		// ���ۿ��� ó���� Į���� ������ Ŭ���̾�Ʈ���� ������ ���� �����´�.
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
		// �� ó���Ǿ��ٴ� �޽����� Ŭ���̾�Ʈ���� ������ ���� I/O�Ķ���Ϳ� �����Ѵ�.
		ioParam.setMessage(MessageDefine.M_QUERY_OK);
	    return EventDefine.E_QUERY_RESULT;
	}
	
	// ���ּ� ���
	// yumsam
	public int E201(InoutParameter ioParam){ 
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		String sql ="";
		ApprovalActionNo ActionNo;
		String Order_Balju_No="";
			
		try {
			con = JDBCConnectionPool.getConnection();
			
    		JSONObject jArray = new JSONObject();
    		jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));

    		// ���ּ� ������ ��� �迭
    		JSONObject jArrayHead = (JSONObject) jArray.get("paramHead");
    		JSONArray jjArray = (JSONArray) jArray.get("param");
    		
    		String user_id = (String)jArrayHead.get("user_id");
    		String prefix = (String)jArrayHead.get("prefix");
    		String actionGubun = "Regist";
    		String detail_seq = (String) jArrayHead.get("detail_seq");
    		String member_key = (String) jArrayHead.get("member_key");
    		String trace_key = (String) jArrayHead.get("trace_key");
    		
			ActionNo = new ApprovalActionNo();
			Order_Balju_No = ActionNo.getActionNo(con, "M202S010100.jsp", user_id, 
												  prefix, actionGubun, detail_seq, 
												  member_key);

			sql = new StringBuilder()
				.append("INSERT INTO tbi_balju2 (	\n")
				.append("		balju_no,			\n")
				.append("		trace_key,			\n")
				.append("		balju_status,		\n")
				.append("		balju_send_date,	\n")
				.append("		balju_nabgi_date,	\n")
				.append("		note,				\n")
				.append("		cust_cd,			\n")
				.append("		cust_rev_no			\n")
				.append(")							\n")
				.append("VALUES (												\n")
				.append("		'" + Order_Balju_No + "',						\n")
				.append("		" + trace_key + ",								\n")
				.append("		'���',											\n")
				.append("		'" + jArrayHead.get("balju_send_date") + "',	\n")
				.append("		'" + jArrayHead.get("balju_nabgi_date") + "',	\n")
				.append("		'" + jArrayHead.get("balju_text") + "',			\n")
				.append("		'" + jArrayHead.get("cust_cd") + "',			\n")
				.append("		'" + jArrayHead.get("cust_cd_rev") + "'			\n")
				.append("	);													\n")
				.toString();
			
			resultInt = super.excuteUpdate(con, sql.toString());
    		if (resultInt < 0) {
				ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
				con.rollback();
				return EventDefine.E_DOEXCUTE_ERROR ;
			} else {
		    	for(int i = 0; i < jjArray.size(); i++) {  
		    		// ���� �� �����Ͱ� ��� �迭
		    		JSONObject jjjArray = (JSONObject)jjArray.get(i);
		    		
		    		sql = new StringBuilder()
	    				.append("INSERT INTO tbi_balju_list2 (	\n")
	    				.append("	part_cd,					\n")
	    				.append("	part_rev_no,				\n")
	    				.append("	balju_no,					\n")
	    				.append("	balju_rev_no,				\n")
	    				.append("	trace_key,					\n")
	    				.append("	balju_status,				\n")
	    				.append("	balju_amt					\n")
	    				.append(")								\n")
	    				.append("VALUES (										\n")
	    				.append("	'" + jjjArray.get("part_cd") + "',			\n")
	    				.append("	'" + jjjArray.get("part_cd_rev") 	+ "',	\n")
	    				.append("	'" + Order_Balju_No + "',					\n")
	    				.append("	0,											\n")
	    				.append("	" + trace_key + ",							\n")
	    				.append("	'���',										\n")
	    				.append("	'" + jjjArray.get("balju_count") 	+ "'	\n")
	    				.append(");												\n")
	    				.toString();

					resultInt = super.excuteUpdate(con, sql.toString());
		    		if (resultInt < 0) {
						ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
						con.rollback();
						return EventDefine.E_DOEXCUTE_ERROR ;
					}
		    	}
    		}
			
			con.commit();
		} catch(Exception e) {
			LoggingWriter.setLogError("M202S010100E201()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M202S010100E201()","==== finally ===="+ e.getMessage());
				}
	    	}
	    }
		ioParam.setResultString(resultString);
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
    	ioParam.setMessage(MessageDefine.M_QUERY_OK);
	    return EventDefine.E_QUERY_RESULT;
	}
	
	
	// �������� ���ּ� ���� yumsam
	public int E202(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		String sql ="";
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject();
    		jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			
			// ���ּ� ������ ��� �迭
    		JSONObject jArrayHead = (JSONObject) jArray.get("paramHead");
    		JSONArray jjArray = (JSONArray) jArray.get("param");
    		
			 sql = new StringBuilder()
					 .append("INSERT INTO tbi_balju2 (	\n")
						.append("		balju_no,			\n")
						.append("		trace_key,			\n")
						.append("		balju_rev_no,			\n")
						.append("		balju_status,		\n")
						.append("		balju_send_date,	\n")
						.append("		balju_nabgi_date,	\n")
						.append("		note,				\n")
						.append("		cust_cd,			\n")
						.append("		cust_rev_no			\n")
						.append(")							\n")
						.append("VALUES (												\n")
						.append("		'" + jArrayHead.get("balju_no") + "',			\n")
						.append("		'" + jArrayHead.get("trace_key") + "',			\n")
						.append("		'" + jArrayHead.get("balju_rev_no")+"' +1 ,		\n")
						.append("		'���',											\n")
						.append("		'" + jArrayHead.get("balju_send_date") + "',	\n")
						.append("		'" + jArrayHead.get("balju_nabgi_date") + "',	\n")
						.append("		'" + jArrayHead.get("balju_text") + "',			\n")
						.append("		'" + jArrayHead.get("cust_cd") + "',			\n")
						.append("		'" + jArrayHead.get("cust_cd_rev") + "'			\n")
						.append("	);													\n")
						.toString();
			 
			 resultInt = super.excuteUpdate(con, sql.toString());
	    		if (resultInt < 0) {
					ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
					con.rollback();
					return EventDefine.E_DOEXCUTE_ERROR ;
				} else {
			    	for(int i = 0; i < jjArray.size(); i++) {  
			    		// ���� �� �����Ͱ� ��� �迭
			    		JSONObject jjjArray = (JSONObject)jjArray.get(i);
			    		
			    		sql = new StringBuilder()
		    				.append("INSERT INTO tbi_balju_list2 (	\n")
		    				.append("	part_cd,					\n")
		    				.append("	part_rev_no,				\n")
		    				.append("	balju_no,					\n")
		    				.append("	balju_rev_no,				\n")
		    				.append("	trace_key,					\n")
		    				.append("	balju_status,				\n")
		    				.append("	balju_amt					\n")
		    				.append(")								\n")
		    				.append("VALUES (										\n")
		    				.append("	'" + jjjArray.get("part_cd") + "',			\n")
		    				.append("	'" + jjjArray.get("part_cd_rev") + "',		\n")
		    				.append("	'" + jArrayHead.get("balju_no") + "',			\n")
		    				.append("	'" + jjjArray.get("rev_no") + "' +1,		\n")
		    				.append("	'" + jArrayHead.get("trace_key") + "',			\n")
		    				.append("	'���',										\n")
		    				.append("	'" + jjjArray.get("balju_count") 	+ "'	\n")
		    				.append(");												\n")
		    				.toString();

						resultInt = super.excuteUpdate(con, sql.toString());
			    		if (resultInt < 0) {
							ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
							con.rollback();
							return EventDefine.E_DOEXCUTE_ERROR ;
						}
			    	}
	    		}
				
				con.commit();
			} catch(Exception e) {
				LoggingWriter.setLogError("M202S010100E202()","==== SQL ERROR ===="+ e.getMessage());
				return EventDefine.E_DOEXCUTE_ERROR ;
		    } finally {
		    	if (Config.useDataSource) {
					try {
						if (con != null) con.close();
					} catch (Exception e) {
						LoggingWriter.setLogError("M202S010100E202()","==== finally ===="+ e.getMessage());
					}
		    	}
		    }
			ioParam.setResultString(resultString);
			ioParam.setColumnCount("" + super.COLUMN_COUNT);
	    	ioParam.setMessage(MessageDefine.M_QUERY_OK);
		    return EventDefine.E_QUERY_RESULT;
		}
	
	
	//�������� ���ְ��� ���� yumsam
		public int E203(InoutParameter ioParam){
			resultInt = EventDefine.E_DOEXCUTE_INIT;
			
			try {
				con = JDBCConnectionPool.getConnection();
				
	    		JSONObject jArray = new JSONObject();
	    		jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
	    		System.out.println("JSONObject jArray rcvData="+ jArray.toString());
				
				// Ŭ���̾�Ʈ�� ���� ���� �Ķ���͸� �ɰ�� �迭�� ��´�.
				
				String sql = new StringBuilder()
						.append("UPDATE tbi_balju2 \n")
						.append("SET delyn='Y' \n")
						.append("WHERE balju_no = '" + jArray.get("balju_no") + "'\n")
						.toString();

				// super�� excuteUpdate�� 3������ �ִ�.
				// ù°�� super.excuteUpdate(con, sql.toString(), v_paramArray)���� �̸�,
				// PreparedStatement�� ����ϱ� ���� �Ķ���͵��� ��ɿ� ��� ������ üũ�� �ؼ� �����ϴ� �����̴�. �׸���
				// �ι�°�� super.excuteUpdate(con, Vector)�ε�, ��Ƽ �ο츦 ����ϱ� ���� ���õ� ��ġ�̴�.
				// ����°�� �ϳ��� SQL�� String���� �޾Ƽ� ó���ϴ� ����̴�.
				// ���� ���� SQL���¶��.. �翬�� 1���� �ο쿡 �ش�ǹǷ� ����° �޽�带 ����ϴ� ���� ���ϴ�.
				resultInt = super.excuteUpdate(con, sql.toString());
			
			} catch(Exception e) {
				LoggingWriter.setLogError("M202S010100E203()","==== SQL ERROR ===="+ e.getMessage());
				return EventDefine.E_DOEXCUTE_ERROR ;
		    } finally {
		    	if (Config.useDataSource) {
					try {
						if (con != null) con.close();
					} catch (Exception e) {
						LoggingWriter.setLogError("M202S010100E203()","==== finally ===="+ e.getMessage());
					}
		    	} else {
		    	}
		    }
		    // ��� ���� ������ ���� �Ķ���͵��� ���̿� �Ķ���Ϳ� �����Ѵ�.
			ioParam.setResultString(resultString);
			// ���ۿ��� ó���� Į���� ������ Ŭ���̾�Ʈ���� ������ ���� �����´�.
			ioParam.setColumnCount("" + super.COLUMN_COUNT);
			// �� ó���Ǿ��ٴ� �޽����� Ŭ���̾�Ʈ���� ������ ���� I/O�Ķ���Ϳ� �����Ѵ�.
	    	ioParam.setMessage(MessageDefine.M_QUERY_OK);
		    return EventDefine.E_QUERY_RESULT;
		}	

	//����������ְ��� ���������� yumsam
	public int E204(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			
			String sql = new StringBuilder()
					.append("SELECT															\n")
					.append("	A.balju_no,													\n")
					.append("	B.cust_nm,													\n")
					.append("	A.balju_rev_no,												\n")
					.append("	A.trace_key,												\n")
					.append("	A.balju_send_date,											\n")
					.append("	A.balju_nabgi_date,											\n")
					.append("	A.note,														\n")
					.append("   A.balju_status,  											\n")
					.append("   B.telno,  													\n")
					.append("   A.cust_cd,  												\n")
					.append("   A.cust_rev_no  												\n")
					.append("FROM tbi_balju2 A												\n")
					.append("INNER JOIN tbm_customer B										\n")
					.append("	ON A.cust_cd = b.cust_cd									\n")
					.append("	AND A.cust_rev_no = b.revision_no							\n")
					.append("WHERE A.balju_rev_no = (SELECT MAX(balju_rev_no) 				\n")
					.append("						 FROM tbi_balju2 C 						\n")
					.append("						 WHERE A.balju_no = C.balju_no)			\n")
					.append("  AND balju_send_date BETWEEN '" + jArray.get("fromdate") + "'	\n")
					.append("						   AND '" + jArray.get("todate") + "'	\n")
					.append("  AND A.delyn = 'N'  											\n")
					.append("ORDER BY A.balju_status,balju_send_date DESC,balju_no DESC		\n")
					.toString();

			String ActionCommand = ioParam.getActionCommand();
			if(ActionCommand.startsWith("doQueryTableFieldName")) {
				resultString = super.excuteQueryStringTableFieldName(con, sql);
			} else {
				resultString = super.excuteQueryString(con, sql);
			}
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M202S010100E204()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M202S010100E204()","==== finally ===="+ e.getMessage());
				}
	    	} else {
	    	}
	    }
		ioParam.setResultString(resultString);
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
    	ioParam.setMessage(MessageDefine.M_QUERY_OK);
	    return EventDefine.E_QUERY_RESULT;
	}	
	
	//����������ְ��� ���������� yumsam
	public int E214(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			
			String sql = new StringBuilder()
					.append("SELECT 														\n")
					.append("	A.part_cd,													\n")
					.append("	C.part_nm,													\n")
					.append("	NVL(C.packing_qtty || ' ' || C.unit_type, C.unit_type),		\n")
					.append("	A.balju_amt													\n")
					.append("FROM tbi_balju_list2 A											\n")
					.append("INNER JOIN tbi_balju2 B										\n")
					.append("	ON A.balju_no = B.balju_no									\n")
					.append("	AND A.balju_rev_no = B.balju_rev_no							\n")
					.append("	AND A.trace_key = B.trace_key								\n")
					.append("INNER JOIN tbm_part_list C										\n")
					.append("	ON A.part_cd = C.part_cd									\n")
					.append("	AND A.part_rev_no = C.revision_no							\n")
					.append("WHERE A.balju_no = '" + jArray.get("balju_no") + "'			\n")
					//.append("  AND A.balju_rev_no = '" + jArray.get("balju_rev_no") + "'	\n")
					.append("  AND A.trace_key = '" + jArray.get("trace_key") + "'			\n")
					.append("  AND A.balju_rev_no = (SELECT MAX(balju_rev_no)				\n")
					.append("  FROM tbi_balju_list2 D 										\n")
					.append("  WHERE D.part_cd = A.part_cd  								\n")
					.append("  AND D.part_rev_no = A.part_rev_no   							\n")
					.append("  AND D.balju_no = A.balju_no)  								\n")
					.toString();
			
			String ActionCommand = ioParam.getActionCommand();
			if(ActionCommand.startsWith("doQueryTableFieldName")) {
				resultString = super.excuteQueryStringTableFieldName(con, sql.toString());
			} else {
				resultString = super.excuteQueryString(con, sql.toString());
			}
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M202S010100E214()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M202S010100E214()","==== finally ===="+ e.getMessage());
				}
	    	}
	    }
		ioParam.setResultString(resultString);
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
    	ioParam.setMessage(MessageDefine.M_QUERY_OK);

    	return EventDefine.E_QUERY_RESULT;
	}
	
	public int E222(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		Queue = new QueueProcessing();
		try {
			con = JDBCConnectionPool.getConnection();
	
			// Ŭ���̾�Ʈ�� ���� ���� �Ķ���͸� �Ű� ��´�.
			String rcvData = (String)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			String[][] c_paramArray = CommonFunction.getConvString2DoubleArray(rcvData);
	
				
				String review_action_no="",confirm_action_no="";//������ ���´�� ����
				String jspPage 			= c_paramArray[0][0];
				String order_detail_seq = c_paramArray[0][3];
				String gOrderNo 		= c_paramArray[0][2];
				String main_action_no 	= c_paramArray[0][2];
				String indGb			= c_paramArray[0][4];
				String lotno			= c_paramArray[0][5];
				String member_key			= c_paramArray[0][6];
				if(Queue.setQueue(con, jspPage, gOrderNo, order_detail_seq, main_action_no, review_action_no, confirm_action_no
						,indGb,lotno,member_key)<0) {
					return EventDefine.E_DOEXCUTE_ERROR ;
				}
				
			
		} catch(Exception e) {
			LoggingWriter.setLogError("M202S010100E222()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M202S010100E222()","==== finally ===="+ e.getMessage());
				}
	    	} else {
	    	}
	    }
	    // ��� ���� ������ ���� �Ķ���͵��� ���̿� �Ķ���Ϳ� �����Ѵ�.
		ioParam.setResultString(resultString);
		// ���ۿ��� ó���� Į���� ������ Ŭ���̾�Ʈ���� ������ ���� �����´�.
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
		// �� ó���Ǿ��ٴ� �޽����� Ŭ���̾�Ʈ���� ������ ���� I/O�Ķ���Ϳ� �����Ѵ�.
		ioParam.setMessage(MessageDefine.M_QUERY_OK);
	    return EventDefine.E_QUERY_RESULT;
	}
	

	//����BOM��ȸ S02S010120.jspww
	public int E224(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();				
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			
			String sql = new StringBuilder()
					.append("SELECT\n")
					.append("	A.order_no,\n")
					.append("	A.bom_cd,\n")
					.append("	A.bom_name,\n")
					.append("	sys_bom_id,\n")
					.append("	C.part_nm,\n")
					.append("	A.part_cd,\n")
					.append("	C.gyugyeok,\n")
					.append("	A.part_cnt,	\n")
					.append("	TO_CHAR (C.unit_price, '999,999,999,999'),\n")
					.append("	TO_CHAR (A.part_cnt * C.unit_price, '999,999,999,999') AS part_amt,\n")
					.append("	A.bom_cd_rev, \n")
					.append("	A.part_cd_rev \n")
					.append("FROM tbi_order_bomlist A\n")
					.append("	LEFT OUTER JOIN vtbm_part_list C\n")
					.append("	ON A.part_cd = C.part_cd\n")
					.append("	AND A.part_cd_rev = C.revision_no\n")
					.append("   AND A.member_key = C.member_key\n")
					.append("WHERE A.order_no = '" + jArray.get("order_no") + "' \n")
					.append("AND A.lotno = '" + jArray.get("lotno") + "' \n")
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
			LoggingWriter.setLogError("M202S010100E224()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M202S010100E224()","==== finally ===="+ e.getMessage());
				}
	    	} else {
	    	}
	    }
		ioParam.setResultString(resultString);
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
    	ioParam.setMessage(MessageDefine.M_QUERY_OK);
	    return EventDefine.E_QUERY_RESULT;
	}
		
	//��������(Balju_form_view.jsp)
	public int E234(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			
			String sql = new StringBuilder()
					.append("SELECT DISTINCT\n")
					.append("	order_no,\n")
					.append("	balju_no,\n")
					.append("	balju_text,\n")
					.append("	balju_send_date,\n")
					.append("	b.cust_nm,\n")
					.append("	cust_damdang,\n")
					.append("	tell_no,\n")
					.append("	fax_no,\n")
					.append("	balju_nabgi_date,\n")
					.append("	nabpoom_location,\n")
					.append("	qa_ter_condtion,\n")
					.append("	balju_status,\n")
					.append("	review_no,\n")
					.append("	confirm_no\n")
					.append("FROM tbi_balju A \n")
					.append("	INNER JOIN vtbm_customer B \n")
					.append("	ON A.cust_cd = b.cust_cd\n")
					.append("   AND A.member_key = B.member_key\n")
					.append("WHERE order_no = '" + jArray.get("order_no") + "' \n")
					.append("AND A.balju_no = '" + jArray.get("baljuno") + "' \n")
					.append("AND A.member_key = '" + jArray.get("member_key") + "' \n")
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
			LoggingWriter.setLogError("M202S010100E234()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M202S010100E234()","==== finally ===="+ e.getMessage());
				}
	    	} else {
	    	}
	    }
		ioParam.setResultString(resultString);
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
    	ioParam.setMessage(MessageDefine.M_QUERY_OK);

    	return EventDefine.E_QUERY_RESULT;
	}
	/*
	//��������(Balju_form_view.jsp) ����������
	public int E244(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			
			String sql = new StringBuilder()
					.append("SELECT\n")
					.append("	B.order_no ,\n")
					.append("	A.balju_no,\n")
					.append("	A.balju_seq,\n")
					.append("	A.bom_nm,\n")
					.append("	A.bom_cd,\n")
					.append("	A.part_cd,\n")
					.append("	A.gyugeok,\n")
					.append("	A.balju_count,	\n")
					.append("	A.list_price, \n")
					.append("	A.balju_amt, \n")
					.append("	A.rev_no,\n")
					.append("	A.part_cd_rev, '' as butn \n")
					.append("FROM tbi_balju B\n")
					.append("	INNER JOIN tbi_balju_list A\n")
					.append("	ON B.balju_no = A.balju_no\n")
					.append("   AND B.member_key = A.member_key\n")
					.append("WHERE order_no = '" + jArray.get("order_no") + "' \n")
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
			LoggingWriter.setLogError("M202S010100E244()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M202S010100E244()","==== finally ===="+ e.getMessage());
				}
	    	} else {
	    	}
	    }
	    // ��� ���� ������ ���� �Ķ���͵��� ���̿� �Ķ���Ϳ� �����Ѵ�.
		ioParam.setResultString(resultString);
		// ���ۿ��� ó���� Į���� ������ Ŭ���̾�Ʈ���� ������ ���� �����´�.
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
		// �� ó���Ǿ��ٴ� �޽����� Ŭ���̾�Ʈ���� ������ ���� I/O�Ķ���Ϳ� �����Ѵ�.
		ioParam.setMessage(MessageDefine.M_QUERY_OK);
	    return EventDefine.E_QUERY_RESULT;
	}
	*/
	
	public int E244(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			
			String sql = new StringBuilder()
					.append("SELECT\n")
					.append("	B.order_no ,\n")
					.append("	A.balju_no,\n")
					.append("	A.balju_seq,\n")
					.append("	A.bom_nm,\n")
					.append("	A.bom_cd,\n")
					.append("	A.part_cd,\n")
					.append("	A.gyugeok,\n")
					.append("	A.balju_count,	\n")
					.append("	A.list_price, \n")
					.append("	A.balju_amt, \n")
					.append("	A.rev_no,\n")
					.append("	A.part_cd_rev, '' as butn \n")
					.append("FROM tbi_balju B\n")
					.append("	INNER JOIN tbi_balju_list A\n")
					.append("	ON B.balju_no = A.balju_no\n")
					.append("   AND B.member_key = A.member_key\n")
					.append("WHERE order_no = '" + jArray.get("order_no") + "' \n")
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
			LoggingWriter.setLogError("M202S010100E244()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M202S010100E244()","==== finally ===="+ e.getMessage());
				}
	    	} else {
	    	}
	    }
	    // ��� ���� ������ ���� �Ķ���͵��� ���̿� �Ķ���Ϳ� �����Ѵ�.
		ioParam.setResultString(resultString);
		// ���ۿ��� ó���� Į���� ������ Ŭ���̾�Ʈ���� ������ ���� �����´�.
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
		// �� ó���Ǿ��ٴ� �޽����� Ŭ���̾�Ʈ���� ������ ���� I/O�Ķ���Ϳ� �����Ѵ�.
		ioParam.setMessage(MessageDefine.M_QUERY_OK);
	    return EventDefine.E_QUERY_RESULT;
	}
	
	
	//���ּ���ϰ��� ���
	public int E304(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			
			String sql = new StringBuilder()
					.append("--���� xxxxx.jsp���α׷��� �����ϴ� STATUS�� ã�Ƽ� tbi_queue tbi_balju�� join�ϱ����Ͽ�\n")
					.append("--�ʼ������� GET_STATUS, GET_PREV�� JOIN ���Ѿ� �Ѵ�.\n")
					.append("WITH GET_STATUS AS (\n")
					.append("	SELECT\n")
					.append("		class_id,\n")
					.append("		prev_status,\n")
					.append("		status_code,\n")
					.append("		next_status\n")
					.append("	FROM tbm_systemcode A \n")
					.append("	WHERE class_id='" + jArray.get("jsppage") + "' \n")
					.append("	AND A.member_key = '" + jArray.get("member_key") + "' \n")
					.append(")\n")
					.append(",GET_PREV AS (\n")
					.append("	SELECT \n")
					.append("		B.class_id AS curr_page,\n")
					.append("		A.class_id AS prev_page,\n")
					.append("		A.prev_status AS prev_status,\n")
					.append("		B.status_code AS curr_status,\n")
					.append("		A.status_code,\n")
					.append("		A.next_status\n")
					.append("	FROM  tbm_systemcode A \n")
					.append("	INNER JOIN GET_STATUS B \n")
					.append("	ON A.status_code = B.prev_status\n")
					.append("   AND A.member_key = B.member_key\n")
					.append(")\n")
					.append("SELECT\n")
					.append("        A.ORDER_NO,\n")
					.append("        a.balju_no,        \n")
					.append("        P.action_date,									--���ֵ����\n")
					.append("        p.user_id,										--���ֵ����\n")
					.append("        A.balju_send_date,                             --���ֹ߼���\n")
					.append("        A.BALJU_UPCHE_CD,       						--����ó�ڵ�\n")
					.append("        F.CUST_NM as CUST_NM,                          --����ó��\n")
					.append("        A.BALJU_TEXT,                                  --����\n")
					.append("        v.CODE_NAME AS BALJU_STATUS_NAME,       		--�������\n")
					.append("        TO_CHAR(A.balju_nabgi_date, 'YYYY-MM-DD') AS balju_nabgi_date, --�԰�����\n")
					.append("        A.nabpoom_location,							--�԰����		\n")
					.append("        A.qa_ter_condtion,								--ǰ������\n")
					.append("        A.BALJU_STATUS,	\n")
					.append("        p.action_process,\n")
					.append("        p.action_lebel\n")
					.append("FROM tbi_queue Q\n")
					.append("   	INNER JOIN TBI_BALJU A\n")
					.append("   		ON Q.ORDER_NO = A.ORDER_NO\n")
					.append("   		AND Q.member_key = A.member_key\n")
					.append("   	INNER JOIN GET_PREV G \n")
					.append("   		ON Q.order_status = G.curr_status\n")
					.append("  			AND Q.member_key = G.member_key\n")
					.append("       INNER JOIN tb_orderinfo_head B\n")
					.append("           ON  A.ORDER_NO = B.ORDER_NO\n")
					.append("   		AND A.member_key = B.member_key\n")
					.append("       INNER JOIN vtbm_customer F                --���ְ�\n")
					.append("       	ON A.BALJU_UPCHE_CD = F.CUST_CD\n")
					.append("   		AND A.member_key = F.member_key\n")
					.append("       INNER JOIN v_balju_status v\n")
					.append("           ON A.BALJU_STATUS = V.CODE_CD\n")
					.append("  			AND A.member_key = V.member_key\n")
					.append("       INNER JOIN tbi_approval_action P\n")
					.append("        	ON A.balju_no = P.actionno\n")
					.append("   		AND A.member_key = P.member_key\n")
					.append("WHERE 1=1\n")
					.append("       AND p.action_date >= '" + jArray.get("fromdate") + "'    \n")
					.append("       AND p.action_date <= '" + jArray.get("todate") + "'    \n")
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
			LoggingWriter.setLogError("M202S010100E304()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M202S010100E304()","==== finally ===="+ e.getMessage());
				}
	    	} else {
	    	}
	    }
		ioParam.setResultString(resultString);
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
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
					.append("SELECT DISTINCT\n")
					.append("		B.order_no ,\n")
					.append("		A.balju_no,\n")
					.append("		A.balju_seq,\n")
					.append("		A.bom_nm,\n")
					.append("		A.bom_cd,\n")
					.append("		A.part_cd,\n")
					.append("		A.gyugeok,\n")
					.append("		A.balju_count,\n")
					.append("		A.list_price,\n")
					.append("		A.balju_amt,\n")
					.append("		A.rev_no,\n")
					.append("		A.part_cd_rev, '' as butn\n")
					.append("FROM tbi_balju B\n")
					.append("        INNER JOIN tbi_balju_list A\n")
					.append("        ON B.balju_no = A.balju_no\n")
					.append("   AND B.member_key = A.member_key\n")
					.append("WHERE order_no = '" + jArray.get("order_no") + "'\n")
					.append("	AND A.balju_no = '" + jArray.get("balju_no") + "'\n")
					.append("AND A.member_key = '" + jArray.get("member_key") + "' \n")
					.toString();
			
			//s202s010110����÷� ������ �����ֱ� 12��31�� 12��40��
			String ActionCommand = ioParam.getActionCommand();
			if(ActionCommand.startsWith("doQueryTableFieldName")) {
				resultString = super.excuteQueryStringTableFieldName(con, sql.toString());
			}
			else {;
				resultString = super.excuteQueryString(con, sql.toString());
			}
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M202S010100E314()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M202S010100E314()","==== finally ===="+ e.getMessage());
				}
	    	} else {
	    	}
	    }
		ioParam.setResultString(resultString);
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
    	ioParam.setMessage(MessageDefine.M_QUERY_OK);
	    return EventDefine.E_QUERY_RESULT;
	}
		

	public int E504(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			System.out.println("JSONObject jArray rcvData="+ jArray.toString());
			
			// 20201214 ������ ����. ���� �ѰŶ� �ٽ� ���ð� Ʋ���ų� ������ ���� �Ǵ� �ڵ� ���� ��Ź�帳�ϴ�
			// with���� ���̺�� ���..
			// Ʋ���� ������ ������ ��Ź�帳�ϴ�
			String sql = new StringBuilder()
					.append("WITH total_part_amt AS (								\n")
					.append("SELECT SUM(A.post_amt) AS ttl, A.part_cd, A.part_rev_no\n")
					.append("FROM tbi_part_storage2 A								\n")
					.append("INNER JOIN tbm_part_list B								\n")
					.append("		 ON A.part_cd = B.part_cd						\n")
					.append("       AND A.part_rev_no = B.revision_no				\n")
					.append("GROUP BY A.part_cd)									\n")
					.append("SELECT 												\n")
					.append("	D.code_name,										\n")
					.append("	E.code_name,										\n")
					.append("	A.part_cd,											\n")
					.append("	B.part_nm,											\n")
					.append("	B.packing_qtty || ' ' || B.unit_type,				\n")
					.append("	B.manufacturer,										\n")
					.append("	B.supplier,											\n")
					.append("	B.safety_jaego,										\n")
					.append("	CAST(SUM(A.post_amt) AS INT)						\n")
					.append("FROM tbi_part_storage2 A								\n")
					.append("INNER JOIN tbm_part_list B								\n")
					.append("		 ON A.part_cd = B.part_cd						\n")
					.append("       AND A.part_rev_no = B.revision_no				\n")
					.append("INNER JOIN total_part_amt C							\n")
					.append("	ON A.part_cd = C.part_cd							\n")
					.append("	AND A.part_rev_no = C.part_rev_no					\n")
					.append("LEFT OUTER JOIN v_partgubun_big D						\n")
					.append("	ON B.part_gubun_b = D.code_value					\n")
					.append("LEFT OUTER JOIN v_partgubun_mid E						\n")
					.append("	ON B.part_gubun_m = E.code_value					\n")
					.append("WHERE													\n")
					.append("A.part_rev_no = (SELECT MAX(part_rev_no)				\n")
					.append("						FROM tbi_part_storage2 B		\n")
					.append("						WHERE A.part_cd = B.part_cd)	\n")
					.append("	AND C.ttl <= NVL(B.safety_jaego, 0)					\n")
					.append("AND B.part_gubun_b like '" + jArray.get("partgubun_big") + "%'" +
					" AND B.part_gubun_m like '" + jArray.get("partgubun_mid") + "%'\n")
					.append("GROUP BY A.part_cd										\n")
					.toString();

			String ActionCommand = ioParam.getActionCommand();
			if(ActionCommand.startsWith("doQueryTableFieldName")) {
				resultString = super.excuteQueryStringTableFieldName(con, sql);
			} else {
				resultString = super.excuteQueryString(con, sql.toString());
			}
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M202S010100E504()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M202S010100E504()","==== finally ===="+ e.getMessage());
				}
	    	} else {
	    	}
	    }
		ioParam.setResultString(resultString);
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
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
			
			// {"����", "������ġ", "���������ڵ�", "��ǰ�ڵ�", "���������", "���(��)", "�԰�(��)", "��ġ���", "�������" };  
			String sql = new StringBuilder()
					.append("SELECT\n")
					.append("	machineno,\n")
					.append("	rakes,\n")
					.append("	plate,\n")
					.append("	colm,\n")
					.append("	A.part_cd,\n")
					.append("	part_nm,\n")
					.append("	machineno || '-'|| rakes || '-'|| plate || '-'|| colm AS part_loc,\n")
					.append("	io_amt,\n")
					.append("	pre_amt,\n")
					.append("	post_amt,\n")
					.append("	NVL(safety_jaego,0) AS safety_jaego,\n")
					.append("	part_cd_rev,\n")
					.append("	bigo\n")
					.append("FROM tbi_part_storage A \n")
					.append("	INNER JOIN tbm_part_list B \n")
					.append("	ON A.part_cd = B.alt_part_cd\n")
					.append("	AND A.part_cd_rev = B.alt_revision_no\n")
					.append("   AND A.member_key = B.member_key\n")
					.append("	WHERE A.part_cd>'' \n")
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
			LoggingWriter.setLogError("M202S010100E604()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M202S010100E604()","==== finally ===="+ e.getMessage());
				}
	    	} else {
	    	}
	    }
	    // ��� ���� ������ ���� �Ķ���͵��� ���̿� �Ķ���Ϳ� �����Ѵ�.
		ioParam.setResultString(resultString);
		// ���ۿ��� ó���� Į���� ������ Ŭ���̾�Ʈ���� ������ ���� �����´�.
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
		// �� ó���Ǿ��ٴ� �޽����� Ŭ���̾�Ʈ���� ������ ���� I/O�Ķ���Ϳ� �����Ѵ�.
    	ioParam.setMessage(MessageDefine.M_QUERY_OK);
	    return EventDefine.E_QUERY_RESULT;
	}		
	
	// ����� �ҿ䷮(�������-����ҿ䷮)
	public int E704(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			System.out.println("JSONObject jArray rcvData="+ jArray.toString());
			
			String sql = new StringBuilder()
					.append("WITH part_storage AS ( -- �������\n")
					.append("	SELECT\n")
					.append("		part_cd,part_cd_rev,member_key,\n")
					.append("		SUM(post_amt) AS jaego\n")
					.append("	FROM tbi_part_storage\n")
					.append("	GROUP BY part_cd,part_cd_rev,member_key\n")
					.append("), production_exec AS ( --���� �ҿ䷮ ����\n")
					.append("	SELECT proc_plan_no,prod_cd,prod_cd_rev,member_key,MAX(finish_dt) AS finish_dt,\n")
					.append("		SUM(NVL(mix_recipe_cnt_completed,0)) AS mix_recipe_cnt_completed\n")
					.append("	FROM tbi_production_exec\n")
					.append("	GROUP BY proc_plan_no,prod_cd,prod_cd_rev,member_key\n")
					.append("), production_cnt AS (\n")
					.append("	SELECT \n")
					.append("		A.prod_cd,A.prod_cd_rev,A.member_key,\n")
					.append("		SUM(A.mix_recipe_cnt - NVL(E.mix_recipe_cnt_completed,0)) AS mix_cnt_plan\n")
					.append("	FROM tbi_production_head A\n")
					.append("	LEFT OUTER JOIN production_exec E\n")
					.append("        ON A.proc_plan_no = E.proc_plan_no\n")
					.append("        AND A.prod_cd = E.prod_cd\n")
					.append("        AND A.prod_cd_rev = E.prod_cd_rev\n")
					.append("        AND A.member_key = E.member_key\n")
					.append("	WHERE A.mix_recipe_cnt > NVL(E.mix_recipe_cnt_completed,0)\n")
					.append("	GROUP BY A.prod_cd, A.prod_cd_rev, A.member_key\n")
					.append("), part_soyo_cnt AS (\n")
					.append("	SELECT\n")
					.append("		B.part_cd,B.part_cd_rev,	A.member_key,\n")
					.append("		CAST((A.mix_cnt_plan * B.part_count)/C.detail_gyugyeok AS NUMERIC(15,3)) AS soyo_cnt\n")
					.append("	FROM production_cnt A\n")
					.append("	INNER JOIN tbm_bom_info B\n")
					.append("		ON A.prod_cd = B.bom_cd\n")
					.append("		AND A.prod_cd_rev = B.bom_cd_rev\n")
					.append("		AND A.member_key = B.member_key\n")
					.append("	INNER JOIN tbm_part_list C\n")
					.append("		ON B.part_cd = C.part_cd\n")
					.append("		AND B.part_cd_rev = C.revision_no\n")
					.append("		AND B.member_key = C.member_key\n")
					.append("), part_soyo_cnt_sum AS (\n")
					.append("	SELECT\n")
					.append("		part_cd,part_cd_rev,member_key,\n")
					.append("		SUM(soyo_cnt) AS production_part_soyo\n")
					.append("	FROM part_soyo_cnt\n")
					.append("	GROUP BY part_cd, part_cd_rev, member_key\n")
					.append("),  --���� �ҿ䷮ ��\n")
					.append("production_package AS ( -- ���� �ҿ䷮ ����\n")
					.append("	SELECT order_no,lotno,order_detail_seq,prod_cd,prod_cd_rev,member_key,\n")
					.append("		SUM(NVL(package_count,0)) AS package_count_sum\n")
					.append("	FROM tbi_production_package_info\n")
					.append("	GROUP BY order_no,lotno,order_detail_seq,prod_cd,prod_cd_rev,member_key\n")
					.append("), package_cnt AS (\n")
					.append("	SELECT \n")
					.append("		A.prod_cd,A.prod_rev,A.member_key,\n")
					.append("		A.lot_count, NVL(B.package_count_sum,0),\n")
					.append("		SUM(A.lot_count - NVL(B.package_count_sum,0)) AS pack_cnt_plan\n")
					.append("	FROM tbi_order A\n")
					.append("	LEFT OUTER JOIN production_package B\n")
					.append("        ON A.order_no = B.order_no\n")
					.append("        AND A.order_detail_seq = B.order_detail_seq\n")
					.append("        AND A.member_key = B.member_key\n")
					.append("	WHERE A.lot_count > NVL(B.package_count_sum,0)\n")
					.append("	GROUP BY A.prod_cd, A.prod_rev, A.member_key\n")
					.append("), pack_soyo_cnt AS (\n")
					.append("	SELECT\n")
					.append("		B.part_cd,B.part_cd_rev,	A.member_key,\n")
					.append("		(A.pack_cnt_plan * B.sub_part_cnt) AS soyo_cnt\n")
					.append("	FROM package_cnt A\n")
					.append("	INNER JOIN tbm_product_subpart B\n")
					.append("		ON A.prod_cd = B.prod_cd\n")
					.append("		AND A.prod_rev = B.prod_cd_rev\n")
					.append("		AND A.member_key = B.member_key\n")
					.append("), pack_soyo_cnt_sum AS (\n")
					.append("	SELECT\n")
					.append("		part_cd,part_cd_rev,member_key,\n")
					.append("		SUM(soyo_cnt) AS package_part_soyo\n")
					.append("	FROM pack_soyo_cnt\n")
					.append("	GROUP BY part_cd, part_cd_rev, member_key\n")
					.append(") -- ���� �ҿ䷮ ��\n")
					.append("-- ���⼭���� ��������\n")
					.append("SELECT\n")
					.append("	D.code_name,\n")
					.append("	E.code_name,\n")
					.append("	C.part_cd,\n")
					.append("	C.revision_no,\n")
					.append("	C.part_nm,\n")
					.append("	C.gyugyeok,\n")
					.append("	NVL(B.jaego,0) AS jaego, -- ���� ���\n")
					.append("	NVL(A.production_part_soyo,0) AS production_part_soyo, -- ���� �ҿ䷮\n")
					.append("	NVL(F.package_part_soyo,0) AS package_part_soyo, -- ���� �ҿ䷮\n")
					.append("	NVL(C.safety_jaego,0) AS safety_jaego, -- �������\n")
					.append("	NVL(B.jaego,0) - ( NVL(A.production_part_soyo,0) + NVL(F.package_part_soyo,0) ) AS after_jaego, -- ��������� = ������� - (����ҿ䷮+����ҿ䷮)\n")
					.append("	GREATEST(( (NVL(A.production_part_soyo,0) + NVL(F.package_part_soyo,0)) - NVL(B.jaego,0) ),0) AS soyo1, -- ������1 = (����ҿ䷮+����ҿ䷮) - �������\n") // ��갪�� 0���� ������ 0���� ���
//					.append("	(NVL(A.production_part_soyo,0) + NVL(F.package_part_soyo,0)) - NVL(B.jaego,0) AS soyo1, -- ������1 = (����ҿ䷮+����ҿ䷮) - �������\n")
					.append("	(NVL(C.safety_jaego,0) + NVL(A.production_part_soyo,0)) + NVL(F.package_part_soyo,0) - NVL(B.jaego,0) AS soyo2 -- ������2 = (������� + (����ҿ䷮+����ҿ䷮)) - �������\n")
					.append("FROM tbm_part_list C\n")
					.append("LEFT OUTER JOIN part_soyo_cnt_sum A\n")
					.append("	ON C.part_cd = A.part_cd\n")
					.append("	AND C.revision_no = A.part_cd_rev\n")
					.append("	AND C.member_key = A.member_key\n")
					.append("	AND C.part_gubun = 'IMPORT'\n")
					.append("LEFT OUTER JOIN pack_soyo_cnt_sum F\n")
					.append("	ON C.part_cd = F.part_cd\n")
					.append("	AND C.revision_no = F.part_cd_rev\n")
					.append("	AND C.member_key = F.member_key\n")
					.append("	AND C.part_gubun = 'IMPORT2'\n")
					.append("LEFT OUTER JOIN part_storage B\n")
					.append("	ON C.part_cd = B.part_cd\n")
					.append("	AND C.revision_no = B.part_cd_rev\n")
					.append("	AND C.member_key = B.member_key\n")
					.append("INNER JOIN v_partgubun_big D\n")
					.append("	ON C.part_gubun_b = D.code_value\n")
					.append("	AND C.member_key = D.member_key\n")
					.append("INNER JOIN v_partgubun_mid E\n")
					.append("	ON C.part_gubun_m = E.code_value\n")
					.append("	AND C.member_key = E.member_key\n")
					.append("WHERE C.member_key = '" + jArray.get("member_key") + "'\n")
					.append("	AND C.duration_date='9999-12-31'\n")
					.append("ORDER BY C.part_cd\n")
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
			LoggingWriter.setLogError("M202S010100E704()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M202S010100E704()","==== finally ===="+ e.getMessage());
				}
	    	} else {
	    	}
	    }
	    // ��� ���� ������ ���� �Ķ���͵��� ���̿� �Ķ���Ϳ� �����Ѵ�.
		ioParam.setResultString(resultString);
		// ���ۿ��� ó���� Į���� ������ Ŭ���̾�Ʈ���� ������ ���� �����´�.
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
		// �� ó���Ǿ��ٴ� �޽����� Ŭ���̾�Ʈ���� ������ ���� I/O�Ķ���Ϳ� �����Ѵ�.
    	ioParam.setMessage(MessageDefine.M_QUERY_OK);
	    return EventDefine.E_QUERY_RESULT;
	}


	public int E514(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			System.out.println("JSONObject jArray rcvData="+ jArray.toString());
			
			String sql = new StringBuilder()
					.append("SELECT\n")
					.append("   part_gubun_b,\n")
					.append("   B.code_name,\n")
					.append("   part_gubun_m,\n")
					.append("   C.code_name,\n")
					.append("   part_cd,\n")
					.append("   part_nm || '('||E.code_name  ||','||  F.code_name ||')',\n")
					.append("   revision_no,\n")
					.append("   alt_part_cd,\n")
					.append("   gyugyeok,\n")
					.append("   part_level,\n")
					.append("   part_type,\n")
					.append("   unit_price,\n")
					.append("   safety_jaego\n")
					.append("FROM tbm_part_list A\n")
					.append("LEFT OUTER JOIN v_partgubun_big B\n")
					.append("   ON A.part_gubun_b = B.code_value\n")
					.append("   AND A.member_key = B.member_key\n")
					.append("LEFT OUTER JOIN v_partgubun_mid C\n")
					.append("   ON A.part_gubun_m = C.code_value\n")
					.append("   AND A.member_key = C.member_key\n")
					.append("INNER JOIN v_partgubun_big E\n")
					.append("             ON A.part_gubun_b = E.code_value\n")
					.append("     		AND A.member_key = E.member_key\n")
					.append("INNER JOIN v_partgubun_mid F\n")
					.append("	           ON A.part_gubun_m = F.code_value\n")
					.append("     		 AND A.member_key = F.member_key\n")
					.append("WHERE delYn = 'N' \n")
//							.append("	AND part_cd = '" 	+ c_paramArray[0][0] + "' \n")
					.append("	AND part_cd = '" + jArray.get("PartNo") + "' \n")
//							.append("	AND revision_no = '" + c_paramArray[0][1] + "' \n")
//							.append("	AND revision_no = '" + jArray.get("PartRev") + "' \n")
					.append("	AND A.member_key = '" + jArray.get("member_key") + "' 	\n")	
					.append("ORDER BY part_cd\n")
					.append(";\n")
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
			LoggingWriter.setLogError("M202S010100E514()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M202S010100E514()","==== finally ===="+ e.getMessage());
				}
	    	} else {
	    	}
	    }
	    // ��� ���� ������ ���� �Ķ���͵��� ���̿� �Ķ���Ϳ� �����Ѵ�.
		ioParam.setResultString(resultString);
		// ���ۿ��� ó���� Į���� ������ Ŭ���̾�Ʈ���� ������ ���� �����´�.
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
		// �� ó���Ǿ��ٴ� �޽����� Ŭ���̾�Ʈ���� ������ ���� I/O�Ķ���Ϳ� �����Ѵ�.
    	ioParam.setMessage(MessageDefine.M_QUERY_OK);
	    return EventDefine.E_QUERY_RESULT;
	}	

/*
	S202S010101.jsp
	���ּ� ���
*/
	// ����ϴ� jsp ����
	public int E714(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			String rcvData = (String)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			String[][] c_paramArray = CommonFunction.getConvString2DoubleArray(rcvData);
			
			
			String sql = new StringBuilder()
					.append("SELECT \n")
					.append("	A.order_no,\n")
					.append("	A.prod_cd,\n")
					.append("	d.product_nm,\n")
					.append("	bom_cd,\n")
					.append("	A.order_detail_seq,\n")
					.append("	project_name,\n")
					.append("	product_serial_no,\n")
					.append("	cust_pono,\n")
					.append("	delivery_date,\n")
					.append("	lotno,\n")
					.append("	lot_count,\n")
					.append("	E.sys_bom_id\n")
					.append("FROM tbi_order A\n")
					.append("	INNER JOIN vtbm_product D\n")
					.append("	ON A.prod_cd = D.prod_cd\n")
					.append("   AND A.member_key = D.member_key\n")
					.append("	LEFT OUTER JOIN tbi_order_bomlist E\n")
					.append("	ON A.order_no = E.order_no\n")
					.append("   AND A.member_key = E.member_key\n")
					.append("WHERE A.order_no  ='" + c_paramArray[0][0] + "'\n")
					.append("AND E.sys_bom_id=1\n")
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
			LoggingWriter.setLogError("M202S010100E714()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M202S010100E714()","==== finally ===="+ e.getMessage());
				}
	    	} else {
	    	}
	    }
	    // ��� ���� ������ ���� �Ķ���͵��� ���̿� �Ķ���Ϳ� �����Ѵ�.
		ioParam.setResultString(resultString);
		// ���ۿ��� ó���� Į���� ������ Ŭ���̾�Ʈ���� ������ ���� �����´�.
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
		// �� ó���Ǿ��ٴ� �޽����� Ŭ���̾�Ʈ���� ������ ���� I/O�Ķ���Ϳ� �����Ѵ�.
    	ioParam.setMessage(MessageDefine.M_QUERY_OK);
	    return EventDefine.E_QUERY_RESULT;
	}
	
	//2020.12.03 �������������Ȳ�� �߰�.(�Ź���)
	public int E010(InoutParameter ioParam){		
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			System.out.println("JSONObject jArray rcvData="+ jArray.toString());
			
			String sql = new StringBuilder()
					.append("SELECT\n")
					.append("   part_gubun_b,						\n")
					.append("   B.code_name,						\n")
					.append("   part_gubun_m,						\n")
					.append("   C.code_name,						\n")
					.append("   A.part_cd,							\n")
					.append("   A.part_nm,							\n")
					.append("   A.unit_type, 						\n")
					.append("   A.revision_no,						\n")
					.append("   G.warehousing_date,					\n")
					.append("   G.post_amt,							\n")
					.append("   G.expiration_date, 					\n")
					.append("   G.note, 							\n")
					.append("   part_level,							\n")
					.append("   part_type,							\n")
					.append("   unit_price							\n")
					.append("FROM tbm_part_list A 							   \n")
					.append("LEFT OUTER JOIN v_partgubun_big B 				   \n")
					.append("   ON A.part_gubun_b = B.code_value 			   \n")
					.append("   AND A.member_key = B.member_key  			   \n")
					.append("LEFT OUTER JOIN v_partgubun_mid C  			   \n")
					.append("   ON A.part_gubun_m = C.code_value 			   \n")
					.append("   AND A.member_key = C.member_key 			   \n")
					.append("INNER JOIN v_partgubun_big E     				   \n")
					.append("	ON A.part_gubun_b = E.code_value 			   \n")
					.append("	AND A.member_key = E.member_key 			   \n")
					.append("INNER JOIN v_partgubun_mid F 					   \n")
					.append("	ON A.part_gubun_m = F.code_value   			   \n")
					.append("	AND A.member_key = F.member_key				   \n")
					.append("INNER JOIN tbi_part_storage2 G					   \n")
					.append("	ON A.part_cd = G.part_cd 					   \n")
					.append("WHERE delYn = 'N' 								   \n")
					.append("	AND A.part_cd = '" + jArray.get("PartNo") + "' \n")
					.append("ORDER BY G.warehousing_date DESC 				   \n")
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
			LoggingWriter.setLogError("M202S010100E010()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M202S010100E010()","==== finally ===="+ e.getMessage());
				}
	    	} else {
	    	}
	    }
	    // ��� ���� ������ ���� �Ķ���͵��� ���̿� �Ķ���Ϳ� �����Ѵ�.
		ioParam.setResultString(resultString);
		// ���ۿ��� ó���� Į���� ������ Ŭ���̾�Ʈ���� ������ ���� �����´�.
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
		// �� ó���Ǿ��ٴ� �޽����� Ŭ���̾�Ʈ���� ������ ���� I/O�Ķ���Ϳ� �����Ѵ�.
    	ioParam.setMessage(MessageDefine.M_QUERY_OK);
	    return EventDefine.E_QUERY_RESULT;
	}
	
	public int E020(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			System.out.println("JSONObject jArray rcvData="+ jArray.toString());
			
			// Ŭ���̾�Ʈ�� ���� ���� �Ķ���͸� �Ű� ��´�.
//			String rcvData = (String)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			// Ŭ���̾�Ʈ�� ���� ���� �Ķ���͸� �ɰ�� �迭�� ��´�.
			// rcvData = [���浵]
//			String[][] c_paramArray = CommonFunction.getConvString2DoubleArray(rcvData);

			
			String sql = new StringBuilder()
					.append("SELECT \n")
					.append("	B.part_nm,			\n")
					.append("	B.unit_type,		\n")
					.append("   A.balju_amt,        \n")
					.append("   B.unit_price,		\n")
					.append("   B.part_cd,			\n")
					.append("   B.revision_no,		\n")
					.append("   MAX(A.balju_rev_no) 		\n")
					.append("FROM tbi_balju_list2 A			\n")
					.append("INNER JOIN tbm_part_list B						    \n")
					.append("	ON A.part_cd=B.part_cd							\n")
					.append("	AND A.part_rev_no= B.revision_no				\n")
					.append("WHERE A.balju_rev_no = (SELECT MAX(balju_rev_no) 	\n") 
					.append("FROM tbi_balju_list2 D 							\n") 		
					.append("WHERE D.part_cd = A.part_cd 						\n") 
					.append("AND D.part_rev_no = A.part_rev_no 					\n") 
					.append("AND D.balju_no = A.balju_no) 				   		\n")
					.append("AND	A.balju_no = '"+jArray.get("BaljuNo")+"'   	\n")
					.append("AND	A.trace_key = '"+jArray.get("TraceKey")+"'  \n")
					.append("GROUP BY A.part_cd								   	\n")
					.append("ORDER BY A.part_cd								   	\n")
					.toString(); 
			
			resultString = super.excuteQueryString(con, sql.toString());
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M909S010100E004()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M909S010100E004()","==== finally ===="+ e.getMessage());
				}
	    	} else {
	    	}
	    }
	    // ��� ���� ������ ���� �Ķ���͵��� ���̿� �Ķ���Ϳ� �����Ѵ�.
		ioParam.setResultString(resultString);
		// ���ۿ��� ó���� Į���� ������ Ŭ���̾�Ʈ���� ������ ���� �����´�.
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
		// �� ó���Ǿ��ٴ� �޽����� Ŭ���̾�Ʈ���� ������ ���� I/O�Ķ���Ϳ� �����Ѵ�.
    	ioParam.setMessage(MessageDefine.M_QUERY_OK);
	    return EventDefine.E_QUERY_RESULT;
	}
	
}