package mes.frame.business.M909;

import java.lang.reflect.Method;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.util.Vector;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;

import mes.client.conf.Config;
import mes.frame.common.EventDefine;
import mes.frame.common.HashObject;
import mes.frame.common.MessageDefine;
import mes.frame.database.JDBCConnectionPool;
import mes.frame.database.SqlAdapter;
import mes.frame.serviceinterface.InoutParameter;
import mes.frame.serviceinterface.LoggingWriter;
import mes.frame.util.CommonFunction;


public class M909S123100 extends SqlAdapter{
	Connection con = null;
	PreparedStatement pstmt = null;
	String resultString = "";
	int resultInt = -1;
	StringBuffer sql = new StringBuffer();
	
	String[][] v_paramArray = new String[0][0]; 
	Class[] optClass = null;
	Object[] optObj = null;
	Object obj = null;
	
	public M909S123100(){
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
	public  int doExcute(InoutParameter ioParam){
		long startTime = System.currentTimeMillis();
		int doExcute_result = EventDefine.E_DOEXCUTE_INIT;
		String event = ioParam.getEventSubID();

	    try{
            optClass = new Class[1];
			optClass[0] = ioParam.getClass() ;
			optObj = new Object[1];
			optObj[0] = ioParam;

			Method method = M909S123100.class.getMethod(event,optClass);
			LoggingWriter.setLogDebug(M909S123100.class.getName(),"==== " + event + " EventMethod Create Success ====");

			obj = method.invoke(M909S123100.class.newInstance(),optObj);
			doExcute_result = CommonFunction.getInt(obj.toString());
			
	    } catch (Exception ex) {
	    	doExcute_result = EventDefine.E_DOEXCUTE_INIT;
			ioParam.setMessage(MessageDefine.M_NO_EVENTID);
			LoggingWriter.setLogError(M909S123100.class.getName(),"==== EventID Not define : EVENT ID [ " + ioParam.getEventID() + "]");
	    } finally {
	    	obj = null;
			optClass = null;
			optObj = null;
	    }
	    long endTime = System.currentTimeMillis();
		long runningTime = endTime - startTime;
		LoggingWriter.setLogAll(M909S123100.class.getName(),"==== Query [����ð�  : " + runningTime + " ms]");
		
		return doExcute_result;
	}
	

	public int E101(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
    		// insert_update_delete_json.jsp���� �޾ƿ� JSON������ ó��
    		JSONObject jArray = new JSONObject();
    		jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
    		System.out.println("JSONObject jArray rcvData="+ jArray.toString());
    		// Object�����Ϳ��� Ű��(param)���� JSONArray�����͸� ������. (�����͹��� �ϳ��϶� ����)
    		JSONArray jjArray = (JSONArray) jArray.get("param");
    		System.out.println("������ ���� ���� :::: " + jjArray.size());
			
//			String[][] c_paramArray_Head=null;
//			String[][] c_paramArray_Detail=null;
			// Ŭ���̾�Ʈ�� ���� ���� �Ķ���͸� �Ű� ��´�.
//			String rcvData = (String)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
//			Vector resultVector = CommonFunction.getConvStringDamogjuk(rcvData);

			con.setAutoCommit(false);
			
//			c_paramArray_Head = (String[][])resultVector.get(0);//head table
//    		c_paramArray_Detail=(String[][])resultVector.get(1); //data table
			
			// Ŭ���̾�Ʈ�� ���� ���� �Ķ���͸� �ɰ�� �迭�� ��´�. MAX
//			String[][] c_paramArray = CommonFunction.getConvString2DoubleArray(rcvData);
    		
			for(int i=0; i<jjArray.size(); i++) {  
				JSONObject jjjArray = (JSONObject)jjArray.get(i); // i��° �����͹���
//				String sql = new StringBuilder()
//						.append("INSERT INTO\n")
//						.append("	tbm_product_inspect_checklist (\n")
//						.append("		inspect_gubun,		\n")
//						.append("		prod_cd,		\n")
//						.append("		prod_cd_rev,		\n")
//						.append("		pic_seq,		\n")
//						.append("		checklist_cd,	\n")
//						.append("		checklist_cd_rev,\n")
//						.append("		checklist_seq,	\n")
//						.append("		hangmok_code,	\n")
//						.append("		create_user_id,	\n")
//						.append("		start_date,		\n")
//						.append("		create_date 	\n")
//						.append(" 		,member_key						\n") // member_key_insert
//						.append("	)\n")
//						.append("VALUES	(\n")
//					.append(" 		 '" 	+ jjjArray.get("inspect_gubun") + "' \n") 	//inspect_gubun
//					.append(" 		, '" 	+ jjjArray.get("PROD_CD") + "' \n") 	//prod_cd
//					.append(" 		, '" 	+ jjjArray.get("PROD_CD_REV") + "' \n") 	//prod_cd_rev
//					.append(" 		, SELECT NVL(MAX(pic_seq),0)+1 FROM tbm_product_inspect_checklist where prod_cd ='" + jjjArray.get("PROD_CD") + "' \n")
//					.append(" 		,'" 	+ jjjArray.get("checklist_cd") + "' \n") 	//checklist_cd
//					.append(" 		,'" 	+ jjjArray.get("checklist_cd_rev") + "' \n") 	//checklist_cd_rev
//					.append(" 		,'" 	+ jjjArray.get("checklist_seq") + "' \n") 	//checklist_seq
//					.append(" 		,'" 	+ jjjArray.get("PIC_KUH") + "' \n") 	//hangmok_code
//					.append(" 		,'" 	+ jjjArray.get("user_id") + "' \n") 	//create_user_id
//					.append(" 		, to_char(SYSDATE,'YYYY-MM-DD')   \n") 	//start_date
//					.append(" 		, SYSDATETIME  \n")					//create_date
//					.append(" 		,'" + jjjArray.get("member_key") + "' \n") //member_key_values
//					.append("	)\n")
//					.toString();
				
				String sql = new StringBuilder()
						.append("MERGE INTO tbm_product_inspect_checklist A\n")
						.append("USING ( \n")
						.append("	SELECT\n")
						.append("		'" 	+ jjjArray.get("inspect_gubun") + "' AS inspect_gubun,\n")
						.append("		'" 	+ jjjArray.get("PROD_CD") + "' AS prod_cd,\n")
						.append("		'" 	+ jjjArray.get("PROD_CD_REV") + "' AS prod_cd_rev,\n")
						.append("		(SELECT NVL(MAX(pic_seq),0)+1 FROM tbm_product_inspect_checklist where prod_cd ='" + jjjArray.get("PROD_CD") + "') AS pic_seq,\n")
						.append("		'" 	+ jjjArray.get("checklist_cd") + "' AS checklist_cd,\n")
						.append("		'" 	+ jjjArray.get("checklist_cd_rev") + "' AS checklist_cd_rev,\n")
						.append("		'" 	+ jjjArray.get("checklist_seq") + "' AS checklist_seq,\n")
						.append("		'" 	+ jjjArray.get("PIC_KUH") + "' AS hangmok_code,\n")
						.append("		'" 	+ jjjArray.get("user_id") + "' AS create_user_id,\n")
						.append("		to_char(SYSDATE,'YYYY-MM-DD') AS start_date,\n")
						.append("		SYSDATETIME AS create_date,\n")
						.append("		'" 	+ jjjArray.get("member_key") + "' AS member_key\n")
						.append("	) B\n")
						.append("ON (A.prod_cd = B.prod_cd \n")
						.append("	AND A.inspect_gubun = B.inspect_gubun \n")
						.append("	AND A.prod_cd_rev = B.prod_cd_rev \n")
						.append("	AND A.checklist_cd = B.checklist_cd \n")
						.append("	AND A.checklist_seq = B.checklist_seq \n")
						.append("	AND A.member_key = B.member_key)	\n")
						.append("WHEN MATCHED THEN UPDATE SET \n")
						.append("	A.inspect_gubun = B.inspect_gubun, \n")
						.append("	A.prod_cd=B.prod_cd,\n")
						.append("	A.prod_cd_rev = B.prod_cd_rev,\n")
						.append("	A.pic_seq = B.pic_seq,\n")
						.append("	A.checklist_cd = B.checklist_cd,\n")
						.append("	A.checklist_cd_rev = B.checklist_cd_rev,\n")
						.append("	A.checklist_seq = B.checklist_seq,\n")
						.append("	A.hangmok_code = B.hangmok_code,\n")
						.append("	A.create_user_id = B.create_user_id,\n")
						.append("	A.start_date = B.start_date,\n")
						.append("	A.create_date = B.create_date,\n")
						.append("	A.member_key = B.member_key\n")
						.append("WHEN NOT MATCHED THEN \n")
						.append("INSERT (\n")
						.append("	A.inspect_gubun,\n")
						.append("	A.prod_cd,\n")
						.append("	A.prod_cd_rev,\n")
						.append("	A.pic_seq,\n")
						.append("	A.checklist_cd,\n")
						.append("	A.checklist_cd_rev,\n")
						.append("	A.checklist_seq,\n")
						.append("	A.hangmok_code,\n")
						.append("	A.create_user_id,\n")
						.append("	A.start_date,\n")
						.append("	A.create_date,\n")
						.append("	A.member_key )\n")
						.append("VALUES (\n")
						.append("	B.inspect_gubun,\n")
						.append("	B.prod_cd,\n")
						.append("	B.prod_cd_rev,\n")
						.append("	B.pic_seq,\n")
						.append("	B.checklist_cd,\n")
						.append("	B.checklist_cd_rev,\n")
						.append("	B.checklist_seq,\n")
						.append("	B.hangmok_code,\n")
						.append("	B.create_user_id,\n")
						.append("	B.start_date,\n")
						.append("	B.create_date,\n")
						.append("	B.member_key \n")
						.append(");\n")
						.toString();

				resultInt = super.excuteUpdate(con, sql.toString());
				if (resultInt < 0) {
					con.rollback();
					return EventDefine.E_DOEXCUTE_ERROR ;
				}
			}
			con.commit();
		} catch(Exception e) {
			LoggingWriter.setLogError("M909S123100E101()","==== SQL ERROR ===="+ e.getMessage() + "\n" + sql.toString());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M909S123100E101()","==== finally ===="+ e.getMessage());
				}
	    	} else {
	    	}
	    }
	    // ��� ���� ������ ���� �Ķ���͵��� ���̿� �Ķ���Ϳ� �����Ѵ�.
		ioParam.setResultString(resultString);
		// ���ۿ��� ó���� Į���� ������ Ŭ���̾�Ʈ���� ������ ���� �����´�.
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
		// �� ó���Ǿ��ٴ� �޽����� Ŭ���̾�Ʈ���� ������ ���� I/O�Ķ���Ϳ� �����Ѵ�.
		// ������ ����� ���� �����ϱ� ���ؼ� ���´�.
    	// ioParam.setMessage(MessageDefine.M_QUERY_OK);
	    return EventDefine.E_QUERY_RESULT;
	}

	public int E111(InoutParameter ioParam){
		return this.E101(ioParam);
	}
//	public int E112(InoutParameter ioParam){
//		return this.E102(ioParam);
//	}
	public int E113(InoutParameter ioParam){
		return this.E103(ioParam);
	}
	


	public int E103(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
    		JSONObject jArray = new JSONObject();
    		jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
    		

			String sql = new StringBuilder()
				.append("DELETE FROM tbm_product_inspect_checklist \n")	//menu_id
				.append("WHERE  inspect_gubun='" 	+ jArray.get("CheckGubun") + "' \n")
				.append(" 	AND prod_cd='" 			+ jArray.get("PROD_CD") + "' \n")
				.append(" 	AND prod_cd_rev='" 		+ jArray.get("PROD_CD_REV") + "' \n")
				.append(" 	AND pic_seq='" 			+ jArray.get("PIC_SEQ") + "' \n")
				.append(" 	AND revision_no='" 		+ jArray.get("revision_no") + "' \n")
				.append(" 	AND checklist_cd='" 	+ jArray.get("checklist_cd") + "' \n")
				.append(" 	AND checklist_cd_rev='" + jArray.get("CHECKLIST_CD_REV") + "' \n")
				.append(" 	AND checklist_seq='" 	+ jArray.get("checklist_seq") + "' \n")
				.append(" 	AND member_key = '" + jArray.get("member_key") + "' \n") //member_key_select, update, delete
				.toString();
					
				resultInt = super.excuteUpdate(con, sql.toString());
				if (resultInt < 0) {
					ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
				} else {
					ioParam.setMessage(resultInt + "�� " + MessageDefine.M_INSERT_RESULT);
				}
				
		} catch(Exception e) {
			LoggingWriter.setLogError("M909S123100E103()","==== SQL ERROR ===="+ e.getMessage() + "\n" + sql.toString());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M909S123100E103()","==== finally ===="+ e.getMessage());
				}
	    	} else {
	    	}
	    }
		ioParam.setResultString(resultString);
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
	    return EventDefine.E_QUERY_RESULT;
	}

	// ���޴� 
	public int E104(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			
			String sql = new StringBuilder()
					.append("SELECT\n")
					.append("	prod_cd,			\n")
					.append("	revision_no,		\n")
					.append("	product_nm,			\n")
					.append("	gugyuk,				\n")
					.append("	'' AS option_cd,	\n") //������ ������ �÷��ε�, �켱 ����Ʈ ���� ���߱� ���� ���鰪�� ����
					.append("	start_date,			\n")
					.append("	duration_date,		\n")
					.append("	create_user_id,		\n")
					.append("	create_date,		\n")
					.append("	modify_user_id,		\n")
					.append("	modify_reason,		\n")
					.append("	modify_date			\n")
					.append("FROM	vtbm_product		\n")
					.append(" 	WHERE member_key = '" + jArray.get("member_key") + "' \n")
					.toString();  

			resultString = super.excuteQueryString(con, sql);
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M909S123100E104()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M909S123100E104()","==== finally ===="+ e.getMessage());
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
	
//�޴� �� ���α׷� ���
	public int E114(InoutParameter ioParam){
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
					.append("SELECT\n")
					.append("	inspect_gubun,\n")					
					.append("	C.code_name,\n")
					.append("	pic_seq,\n")					
					.append("	K.prod_cd,\n")
					.append("	P.product_nm,\n")
					.append("	K.checklist_cd,\n")
					.append("	K.checklist_seq,\n")
					.append("	K.checklist_cd_rev,\n")
					.append("	A.item_cd,\n")
					.append("	B.item_desc,\n")
					.append("	A.item_seq,\n")
					.append("	A.item_cd_rev,\n")
					.append("	standard_guide,\n")
					.append("	check_note,\n")
					.append("	standard_value,\n")
					.append("	 '<input type='''  ||  item_type || ''' id=''' || item_type || '1'''  || ' /input>' AS html_tag,\n")
					.append("	B.item_type,\n")
					.append("	B.item_bigo\n")
					.append("FROM \n")
					.append("	tbm_product_inspect_checklist K \n")
					.append("	INNER JOIN 	v_checklist_gubun C \n")
					.append("	ON inspect_gubun = C.code_value \n")
					.append("	AND K.member_key = C.member_key\n")
					.append("	INNER JOIN 	tbm_checklist A \n")
					.append("	ON K.checklist_cd = A.checklist_cd\n")
					.append("	AND K.checklist_seq = A.checklist_seq\n")
					.append("	AND K.checklist_cd_rev = A.revision_no\n")
					.append("	AND K.member_key = A.member_key\n")
					.append("	INNER JOIN tbm_check_item B \n")
					.append("	ON A.item_cd = B.item_cd\n")
					.append("	AND A.item_seq = B.item_seq\n")
					.append("	AND A.item_cd_rev = B.revision_no\n")
					.append("	AND A.member_key = B.member_key\n")
					.append("	INNER JOIN tbm_product P \n")
					.append("	ON K.prod_cd = P.prod_cd\n")
					.append("	AND K.prod_cd_rev = P.revision_no\n")
					.append("	AND K.member_key = P.member_key\n")
					.append("WHERE \n")
					.append("	inspect_gubun  	LIKE '" + jArray.get("CHECKGUBUN") + "%' \n")
					.append(" and K.prod_cd 	= '" + jArray.get("PROD_CD") + "' \n")
					.append(" and K.prod_cd_rev = '" + jArray.get("REVISION_NO") + "' \n") 
					.append(" 	AND K.member_key = '" + jArray.get("member_key") + "' \n") //member_key_select, update, delete
					.toString();
			
			resultString = super.excuteQueryString(con, sql.toString());
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M909S123100E114()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M909S123100E114()","==== finally ===="+ e.getMessage());
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
	
	public int E174(InoutParameter ioParam){
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
					.append("		A.checklist_seq,\n")
					.append("		B.product_nm,\n")
					.append("		A.prod_cd,\n")
					.append("		A.prod_cd_rev,\n")
					.append("		A.pic_seq,\n")
					.append("		A.checklist_cd,\n")
					.append("		A.checklist_cd_rev,\n")
					.append("		C.item_cd,\n")
					.append("		C.item_cd_rev,\n")
					.append("		C.item_seq,\n")
					.append("		C.standard_guide,\n")
					.append("		C.standard_value,\n")
					.append("		C.check_note,\n")
					.append("		A.start_date,\n")
					.append("		A.inspect_gubun,\n")
					.append("		D.code_name\n")
					.append("FROM 	tbm_product_inspect_checklist A\n")
					.append("	INNER JOIN vtbm_product B\n")
					.append("		ON A.prod_cd = B.prod_cd\n")
					.append("		AND A.prod_cd_rev = B.revision_no\n")
					.append("		AND A.member_key = B.member_key\n")
					.append("	INNER JOIN tbm_checklist C\n")
					.append("        ON A.checklist_cd = C.checklist_cd\n")
					.append("        AND A.checklist_seq = C.checklist_seq\n")
					.append("        AND A.checklist_cd_rev = C.revision_no\n")
					.append("		 AND A.member_key = C.member_key\n")
					.append("	INNER JOIN 	v_checklist_gubun D \n")
					.append("		ON A.inspect_gubun = D.code_value \n")
					.append("		AND A.member_key = D.member_key\n")
					.append("WHERE	A.prod_cd = '" + jArray.get("PROD_CD") + "' \n") 
					.append("AND	A.prod_cd_rev = '" + jArray.get("PROD_CD_REV") + "' \n")
					.append(" 	AND A.member_key = '" + jArray.get("member_key") + "' \n") //member_key_select, update, delete
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
			LoggingWriter.setLogError("M909S123100E174()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M909S123100E174()","==== finally ===="+ e.getMessage());
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