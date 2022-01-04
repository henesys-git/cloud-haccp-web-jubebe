package mes.frame.business.M838;

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


public class M838S060200 extends SqlAdapter{
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
	
	public M838S060200(){
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
		int doExcute_result = EventDefine.E_DOEXCUTE_INIT;;
		String event = ioParam.getEventSubID();
		
	    try{
            optClass = new Class[1];
			optClass[0] = ioParam.getClass() ;
			optObj = new Object[1];
			optObj[0] = ioParam;
			
			Method method = M838S060200.class.getMethod(event,optClass);
			LoggingWriter.setLogDebug(M838S060200.class.getName(),"==== " + event + " EventMethod Create Success ====");

			obj = method.invoke(M838S060200.class.newInstance(),optObj);
			doExcute_result = CommonFunction.getInt(obj.toString());
			
	    } catch (Exception ex) {
	    	doExcute_result = EventDefine.E_DOEXCUTE_INIT;
			ioParam.setMessage(MessageDefine.M_NO_EVENTID);
			LoggingWriter.setLogError(M838S060200.class.getName(),"==== EventID Not define : EVENT ID [ " + ioParam.getEventID() + "]");
	    } finally {
	    	obj = null;
			optClass = null;
			optObj = null;
	    }
	    long endTime = System.currentTimeMillis();
		long runningTime = endTime - startTime;
		LoggingWriter.setLogAll(M838S060200.class.getName(),"==== Query [����ð�  : " + runningTime + " ms]");
		
		return doExcute_result;
	}

	public int E101(InoutParameter ioParam){
		String sql ="";
		resultInt = EventDefine.E_DOEXCUTE_INIT;

		try {
			con = JDBCConnectionPool.getConnection();
			con.setAutoCommit(false);
			
    		// insert_update_delete_json.jsp���� �޾ƿ� JSON������ ó��
    		JSONObject jArray = new JSONObject();
    		jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
    		System.out.println("JSONObject jArray rcvData E101 = "+ jArray.toString());
    		System.out.println("���⵵�� E101");
    		// Object�����Ϳ��� Ű��(param)���� JSONArray�����͸� ������. (�����͹��� �ϳ��϶� ����)
    		JSONArray personArray = (JSONArray) jArray.get("person");
    		JSONArray productArray = (JSONArray) jArray.get("product");
    		JSONArray permissionArray = (JSONArray) jArray.get("permission");
    		JSONArray equipmentArray = (JSONArray) jArray.get("equipment");   
    		System.out.println("������ ���� ���� : �ο� - " + personArray.size() + " : ����ɷ� - "+ productArray.size() + " : �㰡���� - "+ permissionArray.size() + " : �������� - "+ equipmentArray.size() + " : ");
//			.append("		'" + jArray.get("") 	+ "', -- .  	\n")	
			sql = new StringBuilder()
				.append("INSERT INTO\n")
				.append("	tbm_customer (\n")
				.append("		cust_cd,			-- 0. \n")
				.append("		revision_no,		-- 1. \n")
				.append("		cust_nm,			-- 2. \n")
				.append("		address,			-- 3. \n")
				.append("		telno,				-- 4. \n")
				.append("		boss_name,			-- 5. \n")
				.append("		bizno,				-- 6. \n")
				.append("		uptae,				-- 7. \n")
				.append("		jongmok,			-- 8. \n")
				.append("		faxno,				-- 9. \n")
				.append("		homepage,			-- 10. \n")
				.append("		zipno,				-- 11. \n")
				.append("		dangsa_damdangja,	-- 12. \n")
				.append("		cust_damdangja,		-- 13. \n")
				.append("		damdangja_dno,		-- 14. \n")
				.append("		damdangja_hpno,		-- 15. \n")
				.append("		damdangja_email,	-- 16. \n")
				.append("		visit_jugi_day,		-- 17. \n")
				.append("		company_type_b,		-- 18. \n")
				.append("		old_cust_cd,		-- 19. \n")
				.append("		start_date,			-- 20. \n")
				.append("		create_date,		-- 21. \n")
				.append("		create_user_id,		-- 22. \n")
//				.append("		modify_date,		-- 23. \n")
//				.append("		modify_user_id,		-- 24. \n")
				.append("		duration_date,		-- 25. \n")
				.append("		modify_reason,		-- 26. \n")
				.append("		refno,				-- 27. \n")
				.append("		member_key			-- 28. \n")
				.append("	)\n")
				.append("VALUES\n")
				.append("	(\n")
				.append("		'" + jArray.get("subcontractor_no") 				+ "', -- 0. ��Ϲ�ȣ \n")
				.append("		'" + jArray.get("subcontractor_rev") 				+ "', -- 1. ���¾�ürev \n")
				.append("		'" + jArray.get("subcontractor_name") 				+ "', -- 2. ����� \n")
				.append("		'" + jArray.get("subcontractor_headoffice_address") + "', -- 3. �����ּ� \n")
				.append("		'" + jArray.get("subcontractor_headoffice_phone") 	+ "', -- 4. �����ȣ \n")
				.append("		'" + jArray.get("subcontractor_ceo") 				+ "', -- 5. ��ǥ�� \n")
				.append("		'" + jArray.get("bizno") 							+ "', -- 6. ����ڹ�ȣ 	\n")
				.append("		'" + jArray.get("uptae") 							+ "', -- 7. ���� \n")
				.append("		'" + jArray.get("jongmok") 							+ "', -- 8. ���� \n")
				.append("		'" + jArray.get("faxno") 							+ "', -- 9. �ѽ���ȣ \n")
				.append("		'" + jArray.get("homepage") 						+ "', -- 10. Ȩ������ 	\n")
				.append("		'" + jArray.get("zipno") 							+ "', -- 11. �����ȣ  	\n")
				.append("		'" + jArray.get("dangsa_damdangja") 				+ "', -- 12. ������� \n")
				.append("		'" + jArray.get("cust_damdangja") 					+ "', -- 13. �������� \n")
				.append("		'" + jArray.get("damdangja_dno") 					+ "', -- 14. �������ȭ��ȣ \n")
				.append("		'" + jArray.get("damdangja_hpno") 					+ "', -- 15. ������޴���ȭ 	\n")
				.append("		'" + jArray.get("damdangja_email") 					+ "', -- 16. ������̸��� 	\n")
				.append("		'" + jArray.get("visit_jugi_day") 					+ "', -- 17. �湮�ֱ� \n")
				.append("		'" + jArray.get("io_gb") 							+ "', -- 18. ���Ը��ⱸ�� 	\n")
				.append("		'" + jArray.get("old_cust_cd") 						+ "', -- 19. ��ȸ��� \n")
				.append("		'" + jArray.get("start_date") 						+ "', -- 20. �������� \n")
				.append("		'" + jArray.get("write_date") 						+ "', -- 21. �������� \n")
				.append("		'" + jArray.get("writor") 							+ "', -- 22. ������ 	\n")
//				.append("		'" + jArray.get("modify_date") 						+ "', -- 23. �������� \n")
//				.append("		'" + jArray.get("modify_user_id") 					+ "', -- 24. ������ 	\n")
				.append("		'" + jArray.get("duration_date") 					+ "', -- 25. ���ӱⰣ \n")				
				.append("		'" + jArray.get("modify_reason") 					+ "', -- 26. �������� \n")
				.append("		'" + jArray.get("refno") 							+ "', -- 27. �̷��� ����������ȣ \n")
				.append("		'" + jArray.get("member_key") 						+ "'  -- 28. ���Ű \n")
				.append("	);\n")
				.toString();
				resultInt = super.excuteUpdate(con, sql.toString());
	    		if (resultInt < 0) {  //
					ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
					con.rollback();
					return EventDefine.E_DOEXCUTE_ERROR ;
				}
	    		
			sql = new StringBuilder()
				.append("INSERT INTO\n")
				.append("	haccp_subcontractor_present (\n")
				.append("		subcontractor_no,	\n")
				.append("		subcontractor_rev,	\n")
				.append("		subcontractor_seq,	\n")
				.append("		subcontractor_factory_address, \n")
				.append("		subcontractor_factory_phone,   \n")
				.append("		establish_date, 	\n")
				.append("		factory_scale, 		\n")
				.append("		checker, 			\n")
				.append("		check_date, 		\n")
				.append("		approval, 			\n")
				.append("		approve_date, 		\n")
				.append("		appraisal_means,	\n")
				.append("		member_key,			\n")
				.append("		present_rev			\n")
				.append("	)\n")
				.append("VALUES\n")
				.append("	(\n")
				.append("		'" + jArray.get("subcontractor_no") 	+ "', -- 0. ��Ϲ�ȣ 	\n")
				.append("		'" + jArray.get("subcontractor_rev") 	+ "', -- 1. ���¾�ürev 	\n")
				.append("		'" + jArray.get("subcontractor_seq") 	+ "', -- 2. seq		\n")
				.append("		'" + jArray.get("subcontractor_factory_address") + "', -- 3. �����ּ�	\n")
				.append("		'" + jArray.get("subcontractor_factory_phone") 	 + "', -- 4. �����ȣ	\n")
				.append("		'" + jArray.get("establish_date") 		+ "', -- 5. ������	\n")
				.append("		'" + jArray.get("factory_scale") 		+ "', -- 6. ����Ը�	\n")
				.append("		'" + jArray.get("checker") 				+ "', -- 7. ������	\n")
				.append("		'" + jArray.get("check_date") 			+ "', -- 8. ������	\n")
				.append("		'" + jArray.get("approval") 			+ "', -- 9. ������	\n")
				.append("		'" + jArray.get("approve_date") 		+ "', -- 10. ������	\n")
				.append("		'" + jArray.get("appraisal_means") 		+ "', -- 11. �򰡹��	\n")
				.append("		'" + jArray.get("member_key") 			+ "', -- 12. ���Ű	\n")
				.append("		'" + jArray.get("present_rev") 			+ "'  -- 13. ��rev	\n")
				.append("	);\n")
				.toString();
				resultInt = super.excuteUpdate(con, sql.toString());
	    		if (resultInt < 0) {  //
					ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
					con.rollback();
					return EventDefine.E_DOEXCUTE_ERROR ;
				}			    					 	    		
				
			for(int i=0; i<personArray.size(); i++) {
				JSONObject personArrayDetail = (JSONObject)personArray.get(i); // i��° �����͹���
				sql = new StringBuilder()
					.append("INSERT INTO\n")
					.append("	haccp_subcontractor_person ( \n")
					.append("		subcontractor_no, 	\n")		
					.append("		subcontractor_rev, 	\n")
					.append("		person_division, 	\n")
					.append("		person_people, 		\n")
					.append("		person_desk, 		\n")
					.append("		person_technical, 	\n")
					.append("		person_product, 	\n")
					.append("		person_etc, 		\n")
					.append("		person_sum, 		\n")
					.append("		person_bigo, 		\n")
					.append("		member_key, 		\n")
					.append("		person_rev,			\n")
					.append("		person_seq			\n")
					.append("	)	\n")
					.append("VALUES\n")
					.append("	(	\n")
					.append("		'" + jArray.get("subcontractor_no") 			+ "', -- 0. ��Ϲ�ȣ 	\n")
					.append("		'" + jArray.get("subcontractor_rev") 			+ "', -- 1. rev		\n")
					.append("		'" + personArrayDetail.get("person_division") 	+ "', -- 2. ���� 		\n")
					.append("		'" + personArrayDetail.get("person_people") 	+ "', -- 3. �ο� 		\n")
					.append("		'" + personArrayDetail.get("person_desk") 		+ "', -- 4. �繫�� 	\n")
					.append("		'" + personArrayDetail.get("person_technical") 	+ "', -- 5. ����� 	\n")
					.append("		'" + personArrayDetail.get("person_product") 	+ "', -- 6. ������ 	\n")
					.append("		'" + personArrayDetail.get("person_etc") 		+ "', -- 7. ��Ÿ 		\n")
					.append("		'" + personArrayDetail.get("person_sum") 		+ "', -- 8. �� 		\n")
					.append("		'" + personArrayDetail.get("person_bigo") 		+ "', -- 9. ���	 	\n")
					.append("		'" + jArray.get("member_key") 					+ "', -- 10. �ɹ�Ű 	\n")
					.append("		'" + personArrayDetail.get("person_rev") 		+ "', -- 11. rev 	\n")
					.append("		'" + personArrayDetail.get("person_seq") 		+ "'  -- 12. seq 	\n")
					.append("	);\n")
					.toString();
					resultInt = super.excuteUpdate(con, sql.toString());
		    		if (resultInt < 0) {  //
						ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
						con.rollback();
						return EventDefine.E_DOEXCUTE_ERROR ;
					}
			}
			
			for(int i=0; i<productArray.size(); i++) {
				JSONObject productArrayDetail = (JSONObject)productArray.get(i); // i��° �����͹���
				sql = new StringBuilder()
					.append("INSERT INTO\n")
					.append("	haccp_subcontractor_product ( \n")
					.append("		subcontractor_no, 	\n")
					.append("		subcontractor_rev, 	\n")
					.append("		product_division, 	\n")
					.append("		product_measure,	\n")
					.append("		product_capacity, 	\n")
					.append("		product_bigo, 		\n")
					.append("		member_key, 		\n")
					.append("		product_rev,		\n")
					.append("		product_seq			\n")
					.append("	)	\n")
					.append("VALUES	\n")
					.append("	(\n")
					.append("		'" + jArray.get("subcontractor_no") 			+ "', -- 0. ��Ϲ�ȣ 	\n")
					.append("		'" + jArray.get("subcontractor_rev") 			+ "', -- 1. rev		\n")
					.append("		'" + productArrayDetail.get("product_division") + "', -- 2. ��ǰ��	\n")
					.append("		'" + productArrayDetail.get("product_measure") 	+ "', -- 3. ����		\n")
					.append("		'" + productArrayDetail.get("product_capacity") + "', -- 4. ����ɷ�	\n")
					.append("		'" + productArrayDetail.get("product_bigo") 	+ "', -- 5. ���		\n")
					.append("		'" + jArray.get("member_key") 					+ "', -- 6. �ɹ�Ű 	\n")
					.append("		'" + productArrayDetail.get("product_rev") 		+ "', -- 7. rev 	\n")
					.append("		'" + productArrayDetail.get("product_seq") 		+ "'  -- 8. seq 	\n")
					.append("	);\n")
					.toString();
					resultInt = super.excuteUpdate(con, sql.toString());
		    		if (resultInt < 0) {  //
						ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
						con.rollback();
						return EventDefine.E_DOEXCUTE_ERROR ;
					}
			}	

			for(int i=0; i<permissionArray.size(); i++) {
				JSONObject permissionArrayDetail = (JSONObject)permissionArray.get(i); // i��° �����͹���
				sql = new StringBuilder()
					.append("INSERT INTO\n")
					.append("	haccp_subcontractor_permission ( \n")
					.append("		subcontractor_no, 		\n")
					.append("		subcontractor_rev, 		\n")
					.append("		permission_division, 	\n")
					.append("		permission_name, 		\n")
					.append("		permission_institute, 	\n")
					.append("		permission_date, 		\n")
					.append("		permission_bigo, 		\n")
					.append("		member_key, 			\n")
					.append("		permission_rev,	 		\n")
					.append("		permission_seq	 		\n")
					.append("	)\n")
					.append("VALUES\n")
					.append("	(\n")
					.append("		'" + jArray.get("subcontractor_no") 					+ "', -- 0. ��Ϲ�ȣ 	\n")
					.append("		'" + jArray.get("subcontractor_rev") 					+ "', -- 1. rev		\n")
					.append("		'" + permissionArrayDetail.get("permission_division") 	+ "', -- 2. ���� 		\n")
					.append("		'" + permissionArrayDetail.get("permission_name") 		+ "', -- 3. ǰ�� 		\n")
					.append("		'" + permissionArrayDetail.get("permission_institute") 	+ "', -- 4. ������� 	\n")
					.append("		'" + permissionArrayDetail.get("permission_date") 		+ "', -- 5. ��������	\n")
					.append("		'" + permissionArrayDetail.get("permission_bigo") 		+ "', -- 6. ���		\n")
					.append("		'" + jArray.get("member_key") 							+ "', -- 7. �ɹ�Ű 	\n")
					.append("		'" + permissionArrayDetail.get("permission_rev") 		+ "', -- 8. rev		\n")
					.append("		'" + permissionArrayDetail.get("permission_seq") 		+ "'  -- 9. seq		\n")
					.append("	);\n")
					.toString();
					resultInt = super.excuteUpdate(con, sql.toString());
		    		if (resultInt < 0) {  //
						ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
						con.rollback();
						return EventDefine.E_DOEXCUTE_ERROR ;
					}
			}	
			
			for(int i=0; i<equipmentArray.size(); i++) {
				JSONObject equipmentArrayDetail = (JSONObject)equipmentArray.get(i); // i��° �����͹���
				sql = new StringBuilder()
					.append("INSERT INTO\n")
					.append("	haccp_subcontractor_equipment ( \n")
					.append("		subcontractor_no, 	\n")		
					.append("		subcontractor_rev, 	\n")
					.append("		equipment_name, 	\n")
					.append("		equipment_standard, \n")
					.append("		equipment_manufacturer, \n")
					.append("		equipment_have, 	\n")
					.append("		equipment_bigo, 	\n")
					.append("		member_key,			\n")
					.append("		equipment_rev, 		\n")
					.append("		equipment_seq 		\n")
					.append("	)\n")
					.append("VALUES\n")
					.append("	(\n")
					.append("		'" + jArray.get("subcontractor_no") 					+ "', -- 0. ��Ϲ�ȣ 		\n")
					.append("		'" + jArray.get("subcontractor_rev") 					+ "', -- 1. rev			\n")
					.append("		'" + equipmentArrayDetail.get("equipment_name") 		+ "', -- 2. �����		\n")
					.append("		'" + equipmentArrayDetail.get("equipment_standard") 	+ "', -- 3. ���� �� �԰�	\n")
					.append("		'" + equipmentArrayDetail.get("equipment_manufacturer") + "', -- 4. ����ȸ�� 		\n")
					.append("		'" + equipmentArrayDetail.get("equipment_have") 		+ "', -- 5. ��������		\n")
					.append("		'" + equipmentArrayDetail.get("equipment_bigo") 		+ "', -- 6. ��� 			\n")
					.append("		'" + jArray.get("member_key") 							+ "', -- 7.�ɹ�Ű 			\n")
					.append("		'" + equipmentArrayDetail.get("equipment_rev") 			+ "', -- 8. rev 		\n")
					.append("		'" + equipmentArrayDetail.get("equipment_seq") 			+ "'  -- 9. seq 		\n")						
					.append("	);\n")
					.toString();
					resultInt = super.excuteUpdate(con, sql.toString());
		    		if (resultInt < 0) {  //
						ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
						con.rollback();
						return EventDefine.E_DOEXCUTE_ERROR ;
					}
			}	
//				System.out.println(sql.toString());
			
			if (resultInt < 0) {
				con.rollback();
				return EventDefine.E_DOEXCUTE_ERROR ;
			}
			
			con.commit();			
			
		} catch(Exception e) {
			LoggingWriter.setLogError("M838S060200E101()","==== SQL ERROR ===="+ e.getMessage() + "\n" + sql.toString());
			e.printStackTrace();
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M838S060200E101()","==== finally ===="+ e.getMessage());
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

	public int E102(InoutParameter ioParam){
		String sql ="";
		resultInt = EventDefine.E_DOEXCUTE_INIT;

		try {
			con = JDBCConnectionPool.getConnection();
			con.setAutoCommit(false);
			
    		// insert_update_delete_json.jsp���� �޾ƿ� JSON������ ó��
    		JSONObject jArray = new JSONObject();
    		jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
    		System.out.println("JSONObject jArray rcvData E102 = "+ jArray.toString());
    		// Object�����Ϳ��� Ű��(param)���� JSONArray�����͸� ������. (�����͹��� �ϳ��϶� ����)
    		JSONArray personArray = (JSONArray) jArray.get("person");
    		JSONArray productArray = (JSONArray) jArray.get("product");
    		JSONArray permissionArray = (JSONArray) jArray.get("permission");
    		JSONArray equipmentArray = (JSONArray) jArray.get("equipment");   
    		System.out.println("������ ���� ���� : �ο� - " + personArray.size() + " : ����ɷ� - "+ productArray.size() + " : �㰡���� - "+ permissionArray.size() + " : �������� - "+ equipmentArray.size() + " : ");
				
			sql = new StringBuilder()
				.append("MERGE INTO tbm_customer HSP  \n")	
				.append("USING ( SELECT     \n")	
				.append("	'" + jArray.get("subcontractor_no") 				+ "' AS cust_cd,			-- 0. ��Ϲ�ȣ \n")
				.append("	'" + jArray.get("subcontractor_rev") 				+ "' AS revision_no,		-- 1. ���¾�ürev \n")
				.append("	'" + jArray.get("subcontractor_name") 				+ "' AS cust_nm,			-- 2. ����� \n")
				.append("	'" + jArray.get("subcontractor_headoffice_address") + "' AS address,			-- 3. �����ּ� \n")
				.append("	'" + jArray.get("subcontractor_headoffice_phone") 	+ "' AS telno,				-- 4. �����ȣ \n")
				.append("	'" + jArray.get("subcontractor_ceo") 				+ "' AS boss_name,			-- 5. ��ǥ�� \n")
				.append("	'" + jArray.get("bizno") 							+ "' AS bizno,				-- 6. ����ڹ�ȣ 	\n")
				.append("	'" + jArray.get("uptae") 							+ "' AS uptae,				-- 7. ���� \n")
				.append("	'" + jArray.get("jongmok") 							+ "' AS jongmok,			-- 8. ���� \n")
				.append("	'" + jArray.get("faxno") 							+ "' AS faxno,				-- 9. �ѽ���ȣ \n")
				.append("	'" + jArray.get("homepage") 						+ "' AS homepage,			-- 10. Ȩ������ 	\n")
				.append("	'" + jArray.get("zipno") 							+ "' AS zipno,				-- 11. �����ȣ  	\n")
				.append("	'" + jArray.get("dangsa_damdangja") 				+ "' AS dangsa_damdangja,	-- 12. ������� \n")
				.append("	'" + jArray.get("cust_damdangja") 					+ "' AS cust_damdangja,		-- 13. �������� \n")
				.append("	'" + jArray.get("damdangja_dno") 					+ "' AS damdangja_dno,		-- 14. �������ȭ��ȣ \n")
				.append("	'" + jArray.get("damdangja_hpno") 					+ "' AS damdangja_hpno,		-- 15. ������޴���ȭ 	\n")
				.append("	'" + jArray.get("damdangja_email") 					+ "' AS damdangja_email,	-- 16. ������̸��� 	\n")
				.append("	'" + jArray.get("visit_jugi_day") 					+ "' AS visit_jugi_day,		-- 17. �湮�ֱ� \n")
				.append("	'" + jArray.get("io_gb") 							+ "' AS io_gb,				-- 18. ���Ը��ⱸ�� 	\n")
				.append("	'" + jArray.get("old_cust_cd") 						+ "' AS old_cust_cd,		-- 19. ��ȸ��� \n")
				.append("	'" + jArray.get("start_date") 						+ "' AS start_date,			-- 20. �������� \n")
//				.append("	'" + jArray.get("write_date") 						+ "' AS create_date,		-- 21. �������� \n")
				.append("	'" + jArray.get("writor") 							+ "' AS create_user_id,		-- 22. ������ 	\n")
				.append("	SYSDATE AS modify_date,		-- 23. �������� \n")
				.append("	'" + jArray.get("modify_user_id") 					+ "' AS modify_user_id,		-- 24. ������ 	\n")
				.append("	'" + jArray.get("duration_date") 					+ "' AS duration_date,		-- 25. ���ӱⰣ \n")
				.append("	'" + jArray.get("modify_reason") 					+ "' AS modify_reason,		-- 26. �������� \n")
				.append("	'" + jArray.get("refno") 							+ "' AS refno,				-- 27. �̷��� ����������ȣ \n")
				.append("	'" + jArray.get("member_key") 						+ "' AS member_key			-- 28. ���Ű \n")
				.append("	FROM db_root )  mQ \n")
				.append("ON (HSP.cust_cd 	 	= mQ.cust_cd 	\n")
				.append("AND HSP.revision_no 	= mQ.revision_no \n")
				.append("AND HSP.io_gb 			= mQ.io_gb 	\n")
				.append("AND HSP.member_key 	= mQ.member_key ) \n")				
				.append("WHEN MATCHED THEN \n")
				.append("	UPDATE SET \n")
				.append("		HSP.cust_cd 			= mQ.cust_cd, 			\n")
				.append("		HSP.revision_no 		= mQ.revision_no, 		\n")
				.append("		HSP.cust_nm 			= mQ.cust_nm, 			\n")
				.append("		HSP.address 			= mQ.address, 			\n")
				.append("		HSP.telno 				= mQ.telno, 			\n")
				.append("		HSP.boss_name 			= mQ.boss_name, 		\n")
				.append("		HSP.bizno 				= mQ.bizno, 			\n")
				.append("		HSP.uptae 				= mQ.uptae,				\n")
				.append("		HSP.jongmok 			= mQ.jongmok, 			\n")
				.append("		HSP.faxno 				= mQ.faxno, 			\n")
				.append("		HSP.homepage 			= mQ.homepage, 			\n")
				.append("		HSP.zipno 				= mQ.zipno, 			\n")
				.append("		HSP.dangsa_damdangja 	= mQ.dangsa_damdangja, 	\n")
				.append("		HSP.cust_damdangja 		= mQ.cust_damdangja, 	\n")
				.append("		HSP.damdangja_dno 		= mQ.damdangja_dno, 	\n")
				.append("		HSP.damdangja_hpno 		= mQ.damdangja_hpno, 	\n")
				.append("		HSP.damdangja_email 	= mQ.damdangja_email, 	\n")
				.append("		HSP.visit_jugi_day 		= mQ.visit_jugi_day, 	\n")
				.append("		HSP.io_gb 				= mQ.io_gb, 			\n")
				.append("		HSP.old_cust_cd 		= mQ.old_cust_cd, 		\n")
				.append("		HSP.start_date 			= mQ.start_date, 		\n")
//				.append("		HSP.create_date 		= mQ.create_date, 		\n")
				.append("		HSP.create_user_id 		= mQ.create_user_id, 	\n")
				.append("		HSP.modify_date 		= mQ.modify_date, 		\n")
				.append("		HSP.modify_user_id 		= mQ.modify_user_id,	\n")
				.append("		HSP.duration_date 		= mQ.duration_date,		\n")
				.append("		HSP.modify_reason 		= mQ.modify_reason, 	\n")
				.append("		HSP.refno 				= mQ.refno, 			\n")
				.append("		HSP.member_key 			= mQ.member_key 		\n")
				.append("WHEN NOT MATCHED THEN \n")
				.append("	INSERT (	\n")
				.append("		HSP.cust_cd,			-- 0. \n")
				.append("		HSP.revision_no,		-- 1. \n")
				.append("		HSP.cust_nm,			-- 2. \n")
				.append("		HSP.address,			-- 3. \n")
				.append("		HSP.telno,				-- 4. \n")
				.append("		HSP.boss_name,			-- 5. \n")
				.append("		HSP.bizno,				-- 6. \n")
				.append("		HSP.uptae,				-- 7. \n")
				.append("		HSP.jongmok,			-- 8. \n")
				.append("		HSP.faxno,				-- 9. \n")
				.append("		HSP.homepage,			-- 10. \n")
				.append("		HSP.zipno,				-- 11. \n")
				.append("		HSP.dangsa_damdangja,	-- 12. \n")
				.append("		HSP.cust_damdangja,		-- 13. \n")
				.append("		HSP.damdangja_dno,		-- 14. \n")
				.append("		HSP.damdangja_hpno,		-- 15. \n")
				.append("		HSP.damdangja_email,	-- 16. \n")
				.append("		HSP.visit_jugi_day,		-- 17. \n")
				.append("		HSP.io_gb,				-- 18. \n")
				.append("		HSP.old_cust_cd,		-- 19. \n")
				.append("		HSP.start_date,			-- 20. \n")
//				.append("		HSP.create_date,		-- 21. \n")
				.append("		HSP.create_user_id,		-- 22. \n")
				.append("		HSP.modify_date,		-- 23. \n")
				.append("		HSP.modify_user_id,		-- 24. \n")
				.append("		HSP.duration_date,		-- 25. \n")
				.append("		HSP.modify_reason,		-- 26. \n")
				.append("		HSP.refno,				-- 27. \n")
				.append("		HSP.member_key			-- 28. \n")
				.append(")	\n")
				.append("	VALUES	(	\n")
				.append("		mQ.cust_cd,				-- 0. \n")
				.append("		mQ.revision_no,			-- 1. \n")
				.append("		mQ.cust_nm,				-- 2. \n")
				.append("		mQ.address,				-- 3. \n")
				.append("		mQ.telno,				-- 4. \n")
				.append("		mQ.boss_name,			-- 5. \n")
				.append("		mQ.bizno,				-- 6. \n")
				.append("		mQ.uptae,				-- 7. \n")
				.append("		mQ.jongmok,				-- 8. \n")
				.append("		mQ.faxno,				-- 9. \n")
				.append("		mQ.homepage,			-- 10. \n")
				.append("		mQ.zipno,				-- 11. \n")
				.append("		mQ.dangsa_damdangja,	-- 12. \n")
				.append("		mQ.cust_damdangja,		-- 13. \n")
				.append("		mQ.damdangja_dno,		-- 14. \n")
				.append("		mQ.damdangja_hpno,		-- 15. \n")
				.append("		mQ.damdangja_email,		-- 16. \n")
				.append("		mQ.visit_jugi_day,		-- 17. \n")
				.append("		mQ.io_gb,				-- 18. \n")
				.append("		mQ.old_cust_cd,			-- 19. \n")
				.append("		mQ.start_date,			-- 20. \n")
//				.append("		mQ.create_date,			-- 21. \n")
				.append("		mQ.create_user_id,		-- 22. \n")
				.append("		mQ.modify_date,			-- 23. \n")
				.append("		mQ.modify_user_id,		-- 24. \n")
				.append("		mQ.duration_date,		-- 25. \n")
				.append("		mQ.modify_reason,		-- 26. \n")
				.append("		mQ.refno,				-- 27. \n")
				.append("		mQ.member_key			-- 28. \n")
				.append("	);\n")
				.toString();
				resultInt = super.excuteUpdate(con, sql.toString());
	    		if (resultInt < 0) {  //
					ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
					con.rollback();
					return EventDefine.E_DOEXCUTE_ERROR ;
				}
				
				sql = new StringBuilder()
						.append("MERGE INTO haccp_subcontractor_present HSP  \n")	
						.append("USING ( SELECT     \n")		
						.append("	'" + jArray.get("subcontractor_no") 				+ "' AS subcontractor_no, 				-- 0. ��Ϲ�ȣ \n")
						.append("	'" + jArray.get("subcontractor_rev") 				+ "' AS subcontractor_rev, 				-- 1. ���¾�ürev 	\n")
						.append("	'" + jArray.get("subcontractor_seq") 				+ "' AS subcontractor_seq, 				-- 2. seq \n")
						.append("	'" + jArray.get("subcontractor_factory_address") 	+ "' AS subcontractor_factory_address, 	-- 3. �����ּ�	\n")
						.append("	'" + jArray.get("subcontractor_factory_phone") 	 	+ "' AS subcontractor_factory_phone, 	-- 4. �����ȣ	\n")
						.append("	'" + jArray.get("establish_date") 					+ "' AS establish_date, 				-- 5. ������	\n")
						.append("	'" + jArray.get("factory_scale") 					+ "' AS factory_scale, 					-- 6. ����Ը�	\n")
						.append("	'" + jArray.get("checker") 							+ "' AS checker, 						-- 7. ������	\n")
						.append("	'" + jArray.get("check_date") 						+ "' AS check_date, 					-- 8. ������	\n")
						.append("	'" + jArray.get("approval") 						+ "' AS approval, 						-- 9. ������	\n")
						.append("	'" + jArray.get("approve_date") 					+ "' AS approve_date, 					-- 10. ������	\n")
						.append("	'" + jArray.get("appraisal_means") 					+ "' AS appraisal_means, 				-- 11. �򰡹�� \n")
						.append("	'" + jArray.get("member_key") 						+ "' AS member_key, 					-- 12. ���Ű	\n")
						.append("	'" + jArray.get("present_rev") 						+ "' AS present_rev 					-- 13. ���� rev \n")
						.append("	FROM db_root ) mQ \n")
						.append("ON (HSP.subcontractor_no 	 = mQ.subcontractor_no 	\n")
						.append("AND HSP.subcontractor_rev = mQ.subcontractor_rev \n")
						.append("AND HSP.subcontractor_seq 		 = mQ.subcontractor_seq 	\n")
						.append("AND HSP.member_key  = mQ.member_key) \n")				
						.append("WHEN MATCHED THEN     \n")
						.append("	UPDATE SET \n")
						.append("		HSP.subcontractor_no				= mQ.subcontractor_no, \n")
						.append("		HSP.subcontractor_rev				= mQ.subcontractor_rev, \n")
						.append("		HSP.subcontractor_seq				= mQ.subcontractor_seq, \n")
						.append("		HSP.subcontractor_factory_address	= mQ.subcontractor_factory_address, \n")
						.append("		HSP.subcontractor_factory_phone		= mQ.subcontractor_factory_phone, \n")
						.append("		HSP.establish_date					= mQ.establish_date, \n")
						.append("		HSP.factory_scale					= mQ.factory_scale, \n")
						.append("		HSP.checker							= mQ.checker, \n")
						.append("		HSP.check_date						= mQ.check_date, \n")
						.append("		HSP.approval						= mQ.approval, \n")
						.append("		HSP.approve_date					= mQ.approve_date, \n")
						.append("		HSP.appraisal_means					= mQ.appraisal_means, \n")
						.append("		HSP.member_key						= mQ.member_key, \n")
						.append("		HSP.present_rev						= (mQ.present_rev+1) \n")						
						.append("WHEN NOT MATCHED THEN \n")
						.append("	INSERT (	\n")
						.append("		HSP.subcontractor_no,	\n")
						.append("		HSP.subcontractor_rev,	\n")
						.append("		HSP.subcontractor_seq,	\n")
						.append("		HSP.subcontractor_factory_address, \n")
						.append("		HSP.subcontractor_factory_phone,   \n")
						.append("		HSP.establish_date, 	\n")
						.append("		HSP.factory_scale, 		\n")
						.append("		HSP.checker, 			\n")
						.append("		HSP.check_date, 		\n")
						.append("		HSP.approval, 			\n")
						.append("		HSP.approve_date, 		\n")
						.append("		HSP.appraisal_means,	\n")
						.append("		HSP.member_key,			\n")
						.append("		HSP.present_rev			\n")
						.append(")	\n")
						.append("	VALUES	(	\n")
						.append("		mQ.subcontractor_no,	\n")
						.append("		mQ.subcontractor_rev,	\n")
						.append("		mQ.subcontractor_seq,	\n")
						.append("		mQ.subcontractor_factory_address, \n")
						.append("		mQ.subcontractor_factory_phone,   \n")
						.append("		mQ.establish_date, 	\n")
						.append("		mQ.factory_scale, 		\n")
						.append("		mQ.checker, 			\n")
						.append("		mQ.check_date, 		\n")
						.append("		mQ.approval, 			\n")
						.append("		mQ.approve_date, 		\n")
						.append("		mQ.appraisal_means,	\n")
						.append("		mQ.member_key,			\n")
						.append("		mQ.present_rev			\n")
						.append("	);\n")
						.toString();
						resultInt = super.excuteUpdate(con, sql.toString());
			    		if (resultInt < 0) {  //
							ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
							con.rollback();
							return EventDefine.E_DOEXCUTE_ERROR ;
						}
	    		
				for(int i=0; i<personArray.size(); i++) {
					JSONObject personArrayDetail = (JSONObject)personArray.get(i); // i��° �����͹���
					sql = new StringBuilder()
						.append("MERGE INTO haccp_subcontractor_person HSP  \n")
						.append("	USING ( SELECT     \n")
						.append("		'" + jArray.get("subcontractor_no") 			+ "' AS subcontractor_no, 	-- 0. ��Ϲ�ȣ	\n")
						.append("		'" + jArray.get("subcontractor_rev") 			+ "' AS subcontractor_rev, 	-- 1. rev	\n")
						.append("		'" + personArrayDetail.get("person_division") 	+ "' AS person_division, 	-- 2. ���� 	\n")
						.append("		'" + personArrayDetail.get("person_people") 	+ "' AS person_people, 		-- 3. �ο� 	\n")
						.append("		'" + personArrayDetail.get("person_desk") 		+ "' AS person_desk, 		-- 4. �繫�� 	\n")
						.append("		'" + personArrayDetail.get("person_technical") 	+ "' AS person_technical, 	-- 5. ����� 	\n")
						.append("		'" + personArrayDetail.get("person_product") 	+ "' AS person_product, 	-- 6. ������ 	\n")
						.append("		'" + personArrayDetail.get("person_etc") 		+ "' AS person_etc, 		-- 7. ��Ÿ 	\n")
						.append("		'" + personArrayDetail.get("person_sum") 		+ "' AS person_sum, 		-- 8. �� 	\n")
						.append("		'" + personArrayDetail.get("person_bigo") 		+ "' AS person_bigo, 		-- 9. ��� 	\n")
						.append("		'" + jArray.get("member_key") 					+ "' AS member_key, 		-- 10. �ɹ�Ű 	\n")
						.append("		'" + personArrayDetail.get("person_rev") 		+ "' AS person_rev,  		-- 11. rev 	\n")
						.append("		'" + personArrayDetail.get("person_seq") 		+ "' AS person_seq  		-- 12. seq 	\n")
						.append("	  		FROM db_root )  mQ    \n")
						.append("ON (HSP.subcontractor_no 	= mQ.subcontractor_no 	\n")
						.append("AND HSP.subcontractor_rev 	= mQ.subcontractor_rev   \n")
						.append("AND HSP.person_rev 		= mQ.person_rev   \n")
						.append("AND HSP.person_seq 		= mQ.person_seq)   \n")
						.append("WHEN MATCHED THEN     \n")
						.append("	UPDATE SET \n")
						.append("		HSP.subcontractor_no  = mQ.subcontractor_no,  \n")
						.append("		HSP.subcontractor_rev = mQ.subcontractor_rev, \n")
						.append("		HSP.person_division   = mQ.person_division,   \n")
						.append("		HSP.person_people     = mQ.person_people,     \n")
						.append("		HSP.person_desk       = mQ.person_desk,       \n")
						.append("		HSP.person_technical  = mQ.person_technical,  \n")
						.append("		HSP.person_product    = mQ.person_product,    \n")
						.append("		HSP.person_etc        = mQ.person_etc,        \n")
						.append("		HSP.person_sum        = mQ.person_sum,        \n")
						.append("		HSP.person_bigo       = mQ.person_bigo,       \n")
						.append("		HSP.member_key        = mQ.member_key,        \n")
						.append("		HSP.person_rev        = (mQ.person_rev+1),    \n")
						.append("		HSP.person_seq        = mQ.person_seq	      \n")
						.append("WHEN NOT MATCHED THEN \n")
						.append("	INSERT (	\n")            	
						.append("		HSP.subcontractor_no, 	\n")	
						.append("		HSP.subcontractor_rev, 	\n")
						.append("		HSP.person_division, 	\n")
						.append("		HSP.person_people, 		\n")
						.append("		HSP.person_desk, 		\n")
						.append("		HSP.person_technical, 	\n")
						.append("		HSP.person_product, 	\n")
						.append("		HSP.person_etc, 		\n")
						.append("		HSP.person_sum, 		\n")
						.append("		HSP.person_bigo, 		\n")
						.append("		HSP.member_key, 		\n")
						.append("		HSP.person_rev,			\n")
						.append("		HSP.person_seq 			\n")
						.append("	)	\n")     
						.append("	VALUES	(	\n")
						.append("		mQ.subcontractor_no, 	\n")		
						.append("		mQ.subcontractor_rev, 	\n")
						.append("		mQ.person_division, 	\n")
						.append("		mQ.person_people, 		\n")
						.append("		mQ.person_desk, 		\n")
						.append("		mQ.person_technical, 	\n")
						.append("		mQ.person_product, 		\n")
						.append("		mQ.person_etc, 			\n")
						.append("		mQ.person_sum, 			\n")
						.append("		mQ.person_bigo, 		\n")
						.append("		mQ.member_key, 			\n")
						.append("		mQ.person_rev, 			\n")
						.append("		mQ.person_seq 			\n")
						.append("	);\n")
						.toString();
						resultInt = super.excuteUpdate(con, sql.toString());
			    		if (resultInt < 0) {  //
							ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
							con.rollback();
							return EventDefine.E_DOEXCUTE_ERROR ;
						}
				}
				
				for(int i=0; i<productArray.size(); i++) {
					JSONObject productArrayDetail = (JSONObject)productArray.get(i); // i��° �����͹���
					sql = new StringBuilder()
						.append("MERGE INTO haccp_subcontractor_product HSP  \n")
						.append("	USING ( SELECT     \n")	
						.append("		'" + jArray.get("subcontractor_no") 			+ "' AS subcontractor_no, 	-- 0. ��Ϲ�ȣ 	\n")
						.append("		'" + jArray.get("subcontractor_rev") 			+ "' AS subcontractor_rev, 	-- 1. rev		\n")
						.append("		'" + productArrayDetail.get("product_division") + "' AS product_division, 	-- 2. ��ǰ��		\n")
						.append("		'" + productArrayDetail.get("product_measure") 	+ "' AS product_measure, 	-- 3. ����		\n")
						.append("		'" + productArrayDetail.get("product_capacity") + "' AS product_capacity, 	-- 4. ����ɷ�	 	\n")
						.append("		'" + productArrayDetail.get("product_bigo") 	+ "' AS product_bigo, 		-- 5. ���		\n")
						.append("		'" + jArray.get("member_key") 					+ "' AS member_key, 		-- 6. �ɹ�Ű 		\n")
						.append("		'" + productArrayDetail.get("product_rev") 		+ "' AS product_rev, 		-- 7. rev 		\n")
						.append("		'" + productArrayDetail.get("product_seq") 		+ "' AS product_seq  		-- 8. seq 		\n")
						.append("	  		FROM db_root )  mQ    \n")
						.append("ON (HSP.subcontractor_no = mQ.subcontractor_no 	\n")
						.append("AND HSP.subcontractor_rev = mQ.subcontractor_rev   \n")
						.append("AND HSP.product_rev = mQ.product_rev   \n")
						.append("AND HSP.product_seq = mQ.product_seq)   \n")
						.append("WHEN MATCHED THEN     \n")
						.append("	UPDATE SET \n")
						.append("		HSP.subcontractor_no  = mQ.subcontractor_no,  \n ")
						.append("		HSP.subcontractor_rev = mQ.subcontractor_rev, \n ")
						.append("		HSP.product_division  = mQ.product_division,  \n ")
						.append("		HSP.product_measure   = mQ.product_measure,   \n ")
						.append("		HSP.product_capacity  = mQ.product_capacity,  \n ")
						.append("		HSP.product_bigo      = mQ.product_bigo,      \n ")
						.append("		HSP.member_key        = mQ.member_key,        \n ")
						.append("		HSP.product_rev       = (mQ.product_rev+1),   \n ")
						.append("		HSP.product_seq       = mQ.product_seq 	   	  \n ")
						.append("WHEN NOT MATCHED THEN \n")                                  
						.append("	INSERT ( 	\n")
						.append("		HSP.subcontractor_no, 	\n")		
						.append("		HSP.subcontractor_rev, 	\n")
						.append("		HSP.product_division, 	\n")
						.append("		HSP.product_measure,	\n")
						.append("		HSP.product_capacity, 	\n")
						.append("		HSP.product_bigo, 		\n")
						.append("		HSP.member_key, 		\n")
						.append("		HSP.product_rev,		\n")
						.append("		HSP.product_seq			\n")
						.append("	)	\n")
						.append("VALUES	\n")
						.append("	(\n")
						.append("		mQ.subcontractor_no, 	\n")		
						.append("		mQ.subcontractor_rev, 	\n")
						.append("		mQ.product_division, 	\n")
						.append("		mQ.product_measure,		\n")
						.append("		mQ.product_capacity, 	\n")
						.append("		mQ.product_bigo, 		\n")
						.append("		mQ.member_key, 			\n")
						.append("		mQ.product_rev,			\n")
						.append("		mQ.product_seq			\n")
						.append("	);\n")
						.toString();
						resultInt = super.excuteUpdate(con, sql.toString());
			    		if (resultInt < 0) {  //
							ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
							con.rollback();
							return EventDefine.E_DOEXCUTE_ERROR ;
						}
				}	

				for(int i=0; i<permissionArray.size(); i++) {
					JSONObject permissionArrayDetail = (JSONObject)permissionArray.get(i); // i��° �����͹���
					sql = new StringBuilder()
						.append("MERGE INTO haccp_subcontractor_permission HSP  \n")
						.append("	USING ( SELECT     \n")				
						.append("		'" + jArray.get("subcontractor_no") 					+ "' AS subcontractor_no, 		-- 0. ��Ϲ�ȣ 	\n")
						.append("		'" + jArray.get("subcontractor_rev") 					+ "' AS subcontractor_rev, 		-- 1. rev		\n")
						.append("		'" + permissionArrayDetail.get("permission_division") 	+ "' AS permission_division, 	-- 2. ���� 		\n")
						.append("		'" + permissionArrayDetail.get("permission_name") 		+ "' AS permission_name, 		-- 3. ǰ�� 		\n")
						.append("		'" + permissionArrayDetail.get("permission_institute") 	+ "' AS permission_institute, 	-- 4. ������� 	\n")
						.append("		'" + permissionArrayDetail.get("permission_date") 		+ "' AS permission_date, 		-- 5. ��������		\n")
						.append("		'" + permissionArrayDetail.get("permission_bigo") 		+ "' AS permission_bigo, 		-- 6. ��� 		\n")
						.append("		'" + jArray.get("member_key") 							+ "' AS member_key, 			-- 7. �ɹ�Ű 		\n")
						.append("		'" + permissionArrayDetail.get("permission_rev") 		+ "' AS permission_rev,  		-- 8. rev		\n")
						.append("		'" + permissionArrayDetail.get("permission_seq") 		+ "' AS permission_seq  		-- 9. seq		\n")
						.append("	  		FROM db_root )  mQ    \n")
						.append("ON (HSP.subcontractor_no = mQ.subcontractor_no 	\n")
						.append("AND HSP.subcontractor_rev = mQ.subcontractor_rev   \n")
						.append("AND HSP.permission_rev = mQ.permission_rev   \n")
						.append("AND HSP.permission_seq = mQ.permission_seq)   \n")
						.append("WHEN MATCHED THEN     \n")
						.append("	UPDATE SET \n")
						.append("		HSP.subcontractor_no     = mQ.subcontractor_no,     \n")
						.append("		HSP.subcontractor_rev    = mQ.subcontractor_rev,    \n")
						.append("		HSP.permission_division  = mQ.permission_division,  \n")
						.append("		HSP.permission_name      = mQ.permission_name,      \n")
						.append("		HSP.permission_institute = mQ.permission_institute, \n")
						.append("		HSP.permission_date      = mQ.permission_date,      \n")
						.append("		HSP.permission_bigo      = mQ.permission_bigo,      \n")
						.append("		HSP.member_key           = mQ.member_key,           \n")
						.append("		HSP.permission_rev       = (mQ.permission_rev+1),    \n")
						.append("		HSP.permission_seq       = mQ.permission_seq	    \n")
						.append("WHEN NOT MATCHED THEN \n")   
						.append("	INSERT ( 	\n")
						.append("		HSP.subcontractor_no, 		\n")		
						.append("		HSP.subcontractor_rev, 		\n")
						.append("		HSP.permission_division, 	\n")
						.append("		HSP.permission_name, 		\n")
						.append("		HSP.permission_institute, 	\n")
						.append("		HSP.permission_date, 		\n")
						.append("		HSP.permission_bigo, 		\n")
						.append("		HSP.member_key, 			\n")
						.append("		HSP.permission_rev,	 		\n")
						.append("		HSP.permission_seq	 		\n")
						.append("	)	\n")
						.append("VALUES	\n")
						.append("	(\n")
						.append("		mQ.subcontractor_no, 		\n")		
						.append("		mQ.subcontractor_rev, 		\n")
						.append("		mQ.permission_division, 	\n")
						.append("		mQ.permission_name, 		\n")
						.append("		mQ.permission_institute, 	\n")
						.append("		mQ.permission_date, 		\n")
						.append("		mQ.permission_bigo, 		\n")
						.append("		mQ.member_key, 				\n")
						.append("		mQ.permission_rev,	 		\n")
						.append("		mQ.permission_seq	 		\n")
						.append("	);\n")
						.toString();
						resultInt = super.excuteUpdate(con, sql.toString());
			    		if (resultInt < 0) {  //
							ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
							con.rollback();
							return EventDefine.E_DOEXCUTE_ERROR ;
						}
				}	
				
				for(int i=0; i<equipmentArray.size(); i++) {
					JSONObject equipmentArrayDetail = (JSONObject)equipmentArray.get(i); // i��° �����͹���
					sql = new StringBuilder()
						.append("MERGE INTO haccp_subcontractor_equipment HSP  \n")
						.append("	USING ( SELECT     \n")		
						.append("		'" + jArray.get("subcontractor_no") 					+ "' AS subcontractor_no, 		-- 0. ��Ϲ�ȣ 	\n")
						.append("		'" + jArray.get("subcontractor_rev") 					+ "' AS subcontractor_rev, 		-- 1. rev		\n")
						.append("		'" + equipmentArrayDetail.get("equipment_name") 		+ "' AS equipment_name, 		-- 2. �����		\n")
						.append("		'" + equipmentArrayDetail.get("equipment_standard") 	+ "' AS equipment_standard, 	-- 3. ���� �� �԰�	\n")
						.append("		'" + equipmentArrayDetail.get("equipment_manufacturer") + "' AS equipment_manufacturer, -- 4. ����ȸ�� 	\n")
						.append("		'" + equipmentArrayDetail.get("equipment_have") 		+ "' AS equipment_have, 		-- 5. ��������		\n")
						.append("		'" + equipmentArrayDetail.get("equipment_bigo") 		+ "' AS equipment_bigo, 		-- 6. ��� 		\n")
						.append("		'" + jArray.get("member_key") 							+ "' AS member_key, 			-- 7. �ɹ�Ű 		\n")
						.append("		'" + equipmentArrayDetail.get("equipment_rev") 			+ "' AS equipment_rev, 			-- 8. rev 		\n")
						.append("		'" + equipmentArrayDetail.get("equipment_seq") 			+ "' AS equipment_seq 			-- 9. seq		\n")
						.append("	  		FROM db_root )  mQ    \n")
						.append("ON (HSP.subcontractor_no = mQ.subcontractor_no 	\n")
						.append("AND HSP.subcontractor_rev = mQ.subcontractor_rev   \n")
						.append("AND HSP.equipment_rev = mQ.equipment_rev   \n")
						.append("AND HSP.equipment_seq = mQ.equipment_seq)   \n")
						.append("WHEN MATCHED THEN     \n")
						.append("	UPDATE SET \n")
						.append("		HSP.subcontractor_no       = mQ.subcontractor_no,       \n")
						.append("		HSP.subcontractor_rev	   = mQ.subcontractor_rev,      \n")
						.append("		HSP.equipment_name		   = mQ.equipment_name,         \n")
						.append("		HSP.equipment_standard	   = mQ.equipment_standard,     \n")
						.append("		HSP.equipment_manufacturer = mQ.equipment_manufacturer, \n")	
						.append("		HSP.equipment_have		   = mQ.equipment_have,         \n")
						.append("		HSP.equipment_bigo		   = mQ.equipment_bigo,         \n")
						.append("		HSP.member_key		       = mQ.member_key,             \n")
						.append("		HSP.equipment_rev		   = (mQ.equipment_rev+1),      \n")
						.append("		HSP.equipment_seq		   = mQ.equipment_seq       	\n")
						.append("WHEN NOT MATCHED THEN \n")   
						.append("	INSERT ( 	\n")	
						.append("		HSP.subcontractor_no, 	\n")		
						.append("		HSP.subcontractor_rev, 	\n")
						.append("		HSP.equipment_name, 	\n")
						.append("		HSP.equipment_standard, \n")
						.append("		HSP.equipment_manufacturer, \n")
						.append("		HSP.equipment_have, 	\n")
						.append("		HSP.equipment_bigo, 	\n")
						.append("		HSP.member_key,			\n")
						.append("		HSP.equipment_rev,		\n")
						.append("		HSP.equipment_seq 		\n")
						.append("	)	\n")
						.append("VALUES	\n")
						.append("	(\n")
						.append("		mQ.subcontractor_no, 	\n")	
						.append("		mQ.subcontractor_rev, 	\n")
						.append("		mQ.equipment_name, 		\n")
						.append("		mQ.equipment_standard, 	\n")
						.append("		mQ.equipment_manufacturer, \n")
						.append("		mQ.equipment_have, 		\n")
						.append("		mQ.equipment_bigo, 		\n")
						.append("		mQ.member_key,			\n")
						.append("		mQ.equipment_rev,		\n")
						.append("		mQ.equipment_seq 		\n")
						.append("	);\n")
						.toString();
						resultInt = super.excuteUpdate(con, sql.toString());
			    		if (resultInt < 0) {  //
							ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
							con.rollback();
							return EventDefine.E_DOEXCUTE_ERROR ;
						}
				}	
//				System.out.println(sql.toString());
				
				if (resultInt < 0) {
					con.rollback();
					return EventDefine.E_DOEXCUTE_ERROR ;
				}
				
				con.commit();			
			
		} catch(Exception e) {
			LoggingWriter.setLogError("M838S060200E102()","==== SQL ERROR ===="+ e.getMessage() + "\n" + sql.toString());
			e.printStackTrace();
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M838S060200E102()","==== finally ===="+ e.getMessage());
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

	public int E103(InoutParameter ioParam){
		String sql ="";
		resultInt = EventDefine.E_DOEXCUTE_INIT;

		try {
			con = JDBCConnectionPool.getConnection();
			con.setAutoCommit(false);
			
    		// insert_update_delete_json.jsp���� �޾ƿ� JSON������ ó��
    		JSONObject jArray = new JSONObject();
    		jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
    		System.out.println("JSONObject jArray rcvData E103 = "+ jArray.toString());
    		// Object�����Ϳ��� Ű��(param)���� JSONArray�����͸� ������. (�����͹��� �ϳ��϶� ����)
    		JSONArray personArray = (JSONArray) jArray.get("person");
    		JSONArray productArray = (JSONArray) jArray.get("product");
    		JSONArray permissionArray = (JSONArray) jArray.get("permission");
    		JSONArray equipmentArray = (JSONArray) jArray.get("equipment");   
    		System.out.println("������ ���� ���� : �ο� - " + personArray.size() + " : ����ɷ� - "+ productArray.size() + " : �㰡���� - "+ permissionArray.size() + " : �������� - "+ equipmentArray.size() + " : ");
    		
			sql = new StringBuilder()
					.append("MERGE INTO tbm_customer HSP  \n")	
					.append("USING ( SELECT     \n")
					.append("		'" + jArray.get("subcontractor_no") 				+ "' AS cust_cd,			-- 0. ��Ϲ�ȣ \n")
					.append("		'" + jArray.get("subcontractor_rev") 				+ "' AS revision_no,		-- 1. ���¾�ürev \n")
					.append("		'" + jArray.get("subcontractor_name") 				+ "' AS cust_nm,			-- 2. ����� \n")
					.append("		'" + jArray.get("subcontractor_headoffice_address") + "' AS address,			-- 3. �����ּ� \n")
					.append("		'" + jArray.get("subcontractor_headoffice_phone") 	+ "' AS telno,				-- 4. �����ȣ \n")
					.append("		'" + jArray.get("subcontractor_ceo") 				+ "' AS boss_name,			-- 5. ��ǥ�� \n")
					.append("		'" + jArray.get("bizno") 							+ "' AS bizno,				-- 6. ����ڹ�ȣ 	\n")
					.append("		'" + jArray.get("uptae") 							+ "' AS uptae,				-- 7. ���� \n")
					.append("		'" + jArray.get("jongmok") 							+ "' AS jongmok,			-- 8. ���� \n")
					.append("		'" + jArray.get("faxno") 							+ "' AS faxno,				-- 9. �ѽ���ȣ \n")
					.append("		'" + jArray.get("homepage") 						+ "' AS homepage,			-- 10. Ȩ������ 	\n")
					.append("		'" + jArray.get("zipno") 							+ "' AS zipno,				-- 11. �����ȣ  	\n")
					.append("		'" + jArray.get("dangsa_damdangja") 				+ "' AS dangsa_damdangja,	-- 12. ������� \n")
					.append("		'" + jArray.get("cust_damdangja") 					+ "' AS cust_damdangja,		-- 13. �������� \n")
					.append("		'" + jArray.get("damdangja_dno") 					+ "' AS damdangja_dno,		-- 14. �������ȭ��ȣ \n")
					.append("		'" + jArray.get("damdangja_hpno") 					+ "' AS damdangja_hpno,		-- 15. ������޴���ȭ 	\n")
					.append("		'" + jArray.get("damdangja_email") 					+ "' AS damdangja_email,	-- 16. ������̸��� 	\n")
					.append("		'" + jArray.get("visit_jugi_day") 					+ "' AS visit_jugi_day,		-- 17. �湮�ֱ� \n")
					.append("		'" + jArray.get("io_gb") 							+ "' AS io_gb,				-- 18. ���Ը��ⱸ�� 	\n")
					.append("		'" + jArray.get("old_cust_cd") 						+ "' AS old_cust_cd,		-- 19. ��ȸ��� \n")
					.append("		'" + jArray.get("start_date") 						+ "' AS start_date,			-- 20. �������� \n")
					.append("		'" + jArray.get("write_date") 						+ "' AS create_date,		-- 21. �������� \n")
					.append("		'" + jArray.get("writor") 							+ "' AS create_user_id,		-- 22. ������ 	\n")
					.append("		'" + jArray.get("modify_date") 						+ "' AS modify_date,		-- 23. �������� \n")
					.append("		'" + jArray.get("modify_user_id") 					+ "' AS modify_user_id,		-- 24. ������ 	\n")
					.append("		'" + jArray.get("duration_date") 					+ "' AS duration_date,		-- 25. ���ӱⰣ \n")
					.append("		'" + jArray.get("modify_reason") 					+ "' AS modify_reason,		-- 26. �������� \n")
					.append("		'" + jArray.get("refno") 							+ "' AS refno,				-- 27. �̷��� ����������ȣ \n")
					.append("		'" + jArray.get("member_key") 						+ "' AS member_key			-- 28. ���Ű \n")			
					.append("	  	FROM db_root ) mQ    \n")
					.append("ON (HSP.cust_cd 	= mQ.cust_cd 	\n")
					.append("AND HSP.revision_no 	= mQ.revision_no \n")
					.append("AND HSP.io_gb 	= mQ.io_gb 	\n")
					.append("AND HSP.member_key 	= mQ.member_key \n")	
					.append("	UPDATE SET \n")
					.append("		HSP.cust_cd 			= mQ.cust_cd, 			\n")
					.append("		HSP.revision_no 		= mQ.revision_no, 		\n")
					.append("		HSP.cust_nm 			= mQ.cust_nm 			\n")
					.append("		HSP.address 			= mQ.address, 			\n")
					.append("		HSP.telno 				= mQ.telno, 			\n")
					.append("		HSP.boss_name 			= mQ.boss_name, 		\n")
					.append("		HSP.bizno 				= mQ.bizno, 			\n")
					.append("		HSP.uptae 				= mQ.uptae,				\n")
					.append("		HSP.jongmok 			= mQ.jongmok, 			\n")
					.append("		HSP.faxno 				= mQ.faxno, 			\n")
					.append("		HSP.homepage 			= mQ.homepage, 			\n")
					.append("		HSP.zipno 				= mQ.zipno, 			\n")
					.append("		HSP.dangsa_damdangja 	= mQ.dangsa_damdangja, 	\n")
					.append("		HSP.cust_damdangja 		= mQ.cust_damdangja, 	\n")
					.append("		HSP.damdangja_dno 		= mQ.damdangja_dno, 	\n")
					.append("		HSP.damdangja_hpno 		= mQ.damdangja_hpno, 	\n")
					.append("		HSP.damdangja_email 	= mQ.damdangja_email, 	\n")
					.append("		HSP.visit_jugi_day 		= mQ.visit_jugi_day, 	\n")
					.append("		HSP.io_gb 				= mQ.io_gb, 			\n")
					.append("		HSP.old_cust_cd 		= mQ.old_cust_cd, 		\n")
					.append("		HSP.start_date 			= mQ.start_date, 		\n")
					.append("		HSP.create_date 		= mQ.create_date, 		\n")
					.append("		HSP.create_user_id 		= mQ.create_user_id, 	\n")
					.append("		HSP.modify_date 		= mQ.modify_date, 		\n")
					.append("		HSP.modify_user_id 		= mQ.modify_user_id,	\n")
					.append("		HSP.duration_date 		= SYSDATE,				\n")	// ����
					.append("		HSP.modify_reason 		= mQ.modify_reason, 	\n")
					.append("		HSP.refno 				= mQ.refno, 			\n")
					.append("		HSP.member_key 			= mQ.member_key 		\n")
					.append("WHEN NOT MATCHED THEN \n")
					.append("	INSERT (	\n")
					.append("		HSP.cust_cd,			-- 0. \n")
					.append("		HSP.revision_no,		-- 1. \n")
					.append("		HSP.cust_nm,			-- 2. \n")
					.append("		HSP.address,			-- 3. \n")
					.append("		HSP.telno,				-- 4. \n")
					.append("		HSP.boss_name,			-- 5. \n")
					.append("		HSP.bizno,				-- 6. \n")
					.append("		HSP.uptae,				-- 7. \n")
					.append("		HSP.jongmok,			-- 8. \n")
					.append("		HSP.faxno,				-- 9. \n")
					.append("		HSP.homepage,			-- 10. \n")
					.append("		HSP.zipno,				-- 11. \n")
					.append("		HSP.dangsa_damdangja,	-- 12. \n")
					.append("		HSP.cust_damdangja,		-- 13. \n")
					.append("		HSP.damdangja_dno,		-- 14. \n")
					.append("		HSP.damdangja_hpno,		-- 15. \n")
					.append("		HSP.damdangja_email,	-- 16. \n")
					.append("		HSP.visit_jugi_day,		-- 17. \n")
					.append("		HSP.io_gb,				-- 18. \n")
					.append("		HSP.old_cust_cd,		-- 19. \n")
					.append("		HSP.start_date,			-- 20. \n")
					.append("		HSP.create_date,		-- 21. \n")
					.append("		HSP.create_user_id,		-- 22. \n")
					.append("		HSP.modify_date,		-- 23. \n")
					.append("		HSP.modify_user_id,		-- 24. \n")
					.append("		HSP.duration_date,		-- 25. \n")
					.append("		HSP.modify_reason,		-- 26. \n")
					.append("		HSP.refno,				-- 27. \n")
					.append("		HSP.member_key			-- 28. \n")
					.append(")	\n")
					.append("	VALUES	(	\n")
					.append("		mQ.cust_cd,				-- 0. \n")
					.append("		mQ.revision_no,			-- 1. \n")
					.append("		mQ.cust_nm,				-- 2. \n")
					.append("		mQ.address,				-- 3. \n")
					.append("		mQ.telno,				-- 4. \n")
					.append("		mQ.boss_name,			-- 5. \n")
					.append("		mQ.bizno,				-- 6. \n")
					.append("		mQ.uptae,				-- 7. \n")
					.append("		mQ.jongmok,				-- 8. \n")
					.append("		mQ.faxno,				-- 9. \n")
					.append("		mQ.homepage,			-- 10. \n")
					.append("		mQ.zipno,				-- 11. \n")
					.append("		mQ.dangsa_damdangja,	-- 12. \n")
					.append("		mQ.cust_damdangja,		-- 13. \n")
					.append("		mQ.damdangja_dno,		-- 14. \n")
					.append("		mQ.damdangja_hpno,		-- 15. \n")
					.append("		mQ.damdangja_email,		-- 16. \n")
					.append("		mQ.visit_jugi_day,		-- 17. \n")
					.append("		mQ.io_gb,				-- 18. \n")
					.append("		mQ.old_cust_cd,			-- 19. \n")
					.append("		mQ.start_date,			-- 20. \n")
					.append("		mQ.create_date,			-- 21. \n")
					.append("		mQ.create_user_id,		-- 22. \n")
					.append("		mQ.modify_date,			-- 23. \n")
					.append("		mQ.modify_user_id,		-- 24. \n")
					.append("		mQ.duration_date,		-- 25. \n")
					.append("		mQ.modify_reason,		-- 26. \n")
					.append("		mQ.refno,				-- 27. \n")
					.append("		mQ.member_key			-- 28. \n")
					.append("	);\n")
					.toString();
					resultInt = super.excuteUpdate(con, sql.toString());
		    		if (resultInt < 0) {  //
						ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
						con.rollback();
						return EventDefine.E_DOEXCUTE_ERROR ;
					}
    		
			sql = new StringBuilder()
				.append("MERGE INTO haccp_subcontractor_present HSP  \n")	
				.append("USING ( SELECT     \n")
				.append("	'" + jArray.get("subcontractor_no") 				+ "' AS subcontractor_no, 				-- 0. ��Ϲ�ȣ \n")
				.append("	'" + jArray.get("subcontractor_rev") 				+ "' AS subcontractor_rev, 				-- 1. ���¾�ürev 	\n")
				.append("	'" + jArray.get("subcontractor_seq") 				+ "' AS subcontractor_seq, 				-- 2. seq \n")
				.append("	'" + jArray.get("subcontractor_factory_address") 	+ "' AS subcontractor_factory_address, 	-- 3. �����ּ�	\n")
				.append("	'" + jArray.get("subcontractor_factory_phone") 	 	+ "' AS subcontractor_factory_phone, 	-- 4. �����ȣ	\n")
				.append("	'" + jArray.get("establish_date") 					+ "' AS establish_date, 				-- 5. ������	\n")
				.append("	'" + jArray.get("factory_scale") 					+ "' AS factory_scale, 					-- 6. ����Ը�	\n")
				.append("	'" + jArray.get("checker") 							+ "' AS checker, 						-- 7. ������	\n")
				.append("	'" + jArray.get("check_date") 						+ "' AS check_date, 					-- 8. ������	\n")
				.append("	'" + jArray.get("approval") 						+ "' AS approval, 						-- 9. ������	\n")
				.append("	'" + jArray.get("approve_date") 					+ "' AS approve_date, 					-- 10. ������	\n")
				.append("	'" + jArray.get("appraisal_means") 					+ "' AS appraisal_means, 				-- 11. �򰡹�� \n")
				.append("	'" + jArray.get("member_key") 						+ "' AS member_key 						-- 12. ���Ű	\n")
				.append("	'" + jArray.get("present_rev") 						+ "' AS present_rev 					-- 13. ���� rev \n")
				.append("	FROM db_root ) mQ    \n")
				.append("ON (HSP.subcontractor_no  = mQ.subcontractor_no 	\n")
				.append("AND HSP.subcontractor_rev = mQ.subcontractor_rev \n")
				.append("AND HSP.subcontractor_seq = mQ.subcontractor_seq 	\n")
				.append("AND HSP.member_key = mQ.member_key \n")	
				.append("WHEN MATCHED THEN \n")
				.append("	UPDATE SET \n")
				.append("		HSP.subcontractor_no				= mQ.subcontractor_no, \n")
				.append("		HSP.subcontractor_rev				= mQ.subcontractor_rev, \n")
				.append("		HSP.subcontractor_seq				= 9, \n")	// ����
				.append("		HSP.subcontractor_factory_address	= mQ.subcontractor_factory_address, \n")
				.append("		HSP.subcontractor_factory_phone		= mQ.subcontractor_factory_phone, \n")
				.append("		HSP.establish_date					= mQ.establish_date, \n")
				.append("		HSP.factory_scale					= mQ.factory_scale, \n")
				.append("		HSP.checker							= mQ.checker, \n")
				.append("		HSP.check_date						= mQ.check_date, \n")
				.append("		HSP.approval						= mQ.approval, \n")
				.append("		HSP.approve_date					= mQ.approve_date, \n")
				.append("		HSP.appraisal_means					= mQ.appraisal_means, \n")
				.append("		HSP.member_key						= mQ.member_key, \n")
				.append("		HSP.present_rev						= mQ.present_rev \n")
				.append("WHEN NOT MATCHED THEN \n")
				.append("	INSERT (	\n")
				.append("		HSP.subcontractor_no,	\n")
				.append("		HSP.subcontractor_rev,	\n")
				.append("		HSP.subcontractor_seq,	\n")
				.append("		HSP.subcontractor_factory_address, \n")
				.append("		HSP.subcontractor_factory_phone,   \n")
				.append("		HSP.establish_date, 	\n")
				.append("		HSP.factory_scale, 		\n")
				.append("		HSP.checker, 			\n")
				.append("		HSP.check_date, 		\n")
				.append("		HSP.approval, 			\n")
				.append("		HSP.approve_date, 		\n")
				.append("		HSP.appraisal_means,	\n")
				.append("		HSP.member_key,			\n")
				.append("		HSP.present_rev			\n")
				.append(")	\n")
				.append("	VALUES	(	\n")
				.append("		mQ.subcontractor_no,	\n")
				.append("		mQ.subcontractor_rev,	\n")
				.append("		mQ.subcontractor_seq,	\n")
				.append("		mQ.subcontractor_factory_address, \n")
				.append("		mQ.subcontractor_factory_phone,   \n")
				.append("		mQ.establish_date, 	\n")
				.append("		mQ.factory_scale, 		\n")
				.append("		mQ.checker, 			\n")
				.append("		mQ.check_date, 		\n")
				.append("		mQ.approval, 			\n")
				.append("		mQ.approve_date, 		\n")
				.append("		mQ.appraisal_means,	\n")
				.append("		mQ.member_key,			\n")
				.append("		mQ.present_rev			\n")
				.append("	);\n")
				.toString();
				resultInt = super.excuteUpdate(con, sql.toString());
	    		if (resultInt < 0) {  //
					ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
					con.rollback();
					return EventDefine.E_DOEXCUTE_ERROR ;
				}
				
				for(int i=0; i<personArray.size(); i++) {
					JSONObject personArrayDetail = (JSONObject)personArray.get(i); // i��° �����͹���
					sql = new StringBuilder()
						.append("MERGE INTO haccp_subcontractor_person HSP  \n")
						.append("	USING ( SELECT     \n")
						.append("		'" + jArray.get("subcontractor_no") 			+ "' AS subcontractor_no, 	-- 0. ��Ϲ�ȣ	\n")
						.append("		'" + jArray.get("subcontractor_rev") 			+ "' AS subcontractor_rev, 	-- 1. rev	\n")
						.append("		'" + personArrayDetail.get("person_division") 	+ "' AS person_division, 	-- 2. ���� 	\n")
						.append("		'" + personArrayDetail.get("person_people") 	+ "' AS person_people, 		-- 3. �ο� 	\n")
						.append("		'" + personArrayDetail.get("person_desk") 		+ "' AS person_desk, 		-- 4. �繫�� 	\n")
						.append("		'" + personArrayDetail.get("person_technical") 	+ "' AS person_technical, 	-- 5. ����� 	\n")
						.append("		'" + personArrayDetail.get("person_product") 	+ "' AS person_product, 		-- 6. ������ 	\n")
						.append("		'" + personArrayDetail.get("person_etc") 		+ "' AS person_etc, 			-- 7. ��Ÿ 	\n")
						.append("		'" + personArrayDetail.get("person_sum") 		+ "' AS person_sum, 			-- 8. �� 	\n")
						.append("		'" + personArrayDetail.get("person_bigo") 		+ "' AS person_bigo, 		-- 9. ��� 	\n")
						.append("		'" + jArray.get("member_key") 					+ "' AS member_key, 			-- 10. �ɹ�Ű 	\n")
						.append("		'" + personArrayDetail.get("person_rev") 		+ "' AS person_rev,  		-- 11. rev 	\n")
						.append("		'" + personArrayDetail.get("person_seq") 		+ "' AS person_seq  			-- 12. seq 	\n")
						.append("	  		FROM db_root )  mQ    \n")
						.append("ON (HSP.subcontractor_no 	= mQ.subcontractor_no 	\n")
						.append("AND HSP.subcontractor_rev 	= mQ.subcontractor_rev   \n")
						.append("AND HSP.person_rev 		= mQ.person_rev   \n")
						.append("AND HSP.person_seq 		= mQ.person_seq)   \n")
						.append("WHEN MATCHED THEN     \n")
						.append("	UPDATE SET \n")
						.append("		HSP.subcontractor_no  = mQ.subcontractor_no,  \n")
						.append("		HSP.subcontractor_rev = 9, \n")		// ����
						.append("		HSP.person_division   = mQ.person_division,   \n")
						.append("		HSP.person_people     = mQ.person_people,     \n")
						.append("		HSP.person_desk       = mQ.person_desk,       \n")
						.append("		HSP.person_technical  = mQ.person_technical,  \n")
						.append("		HSP.person_product    = mQ.person_product,    \n")
						.append("		HSP.person_etc        = mQ.person_etc,        \n")
						.append("		HSP.person_sum        = mQ.person_sum,        \n")
						.append("		HSP.person_bigo       = mQ.person_bigo,       \n")
						.append("		HSP.member_key        = mQ.member_key,        \n")
						.append("		HSP.person_rev        = mQ.person_rev,    \n")
						.append("		HSP.person_seq        = mQ.person_seq	      \n")
						.append("WHEN NOT MATCHED THEN \n")
						.append("	INSERT (	\n")            	
						.append("		HSP.subcontractor_no, 	\n")	
						.append("		HSP.subcontractor_rev, 	\n")
						.append("		HSP.person_division, 	\n")
						.append("		HSP.person_people, 		\n")
						.append("		HSP.person_desk, 		\n")
						.append("		HSP.person_technical, 	\n")
						.append("		HSP.person_product, 	\n")
						.append("		HSP.person_etc, 		\n")
						.append("		HSP.person_sum, 		\n")
						.append("		HSP.person_bigo, 		\n")
						.append("		HSP.member_key, 		\n")
						.append("		HSP.person_rev,			\n")
						.append("		HSP.person_seq 			\n")
						.append("	)	\n")     
						.append("	VALUES	(	\n")
						.append("		mQ.subcontractor_no, 	\n")		
						.append("		mQ.subcontractor_rev, 	\n")
						.append("		mQ.person_division, 	\n")
						.append("		mQ.person_people, 		\n")
						.append("		mQ.person_desk, 		\n")
						.append("		mQ.person_technical, 	\n")
						.append("		mQ.person_product, 		\n")
						.append("		mQ.person_etc, 			\n")
						.append("		mQ.person_sum, 			\n")
						.append("		mQ.person_bigo, 		\n")
						.append("		mQ.member_key, 			\n")
						.append("		mQ.person_rev, 			\n")
						.append("		mQ.person_seq 			\n")
						.append("	);\n")
						.toString();
						resultInt = super.excuteUpdate(con, sql.toString());
			    		if (resultInt < 0) {  //
							ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
							con.rollback();
							return EventDefine.E_DOEXCUTE_ERROR ;
						}
				}
				
				for(int i=0; i<productArray.size(); i++) {
					JSONObject productArrayDetail = (JSONObject)productArray.get(i); // i��° �����͹���
					sql = new StringBuilder()
						.append("MERGE INTO haccp_subcontractor_product HSP  \n")
						.append("	USING ( SELECT     \n")	
						.append("		'" + jArray.get("subcontractor_no") 			+ "' AS subcontractor_no, 	-- 0. ��Ϲ�ȣ 	\n")
						.append("		'" + jArray.get("subcontractor_rev") 			+ "' AS subcontractor_rev, 	-- 1. seq		\n")
						.append("		'" + productArrayDetail.get("product_division") + "' AS product_division, 	-- 2. ��ǰ��		\n")
						.append("		'" + productArrayDetail.get("product_measure") 	+ "' AS product_measure, 	-- 3. ����		\n")
						.append("		'" + productArrayDetail.get("product_capacity") + "' AS product_capacity, 	-- 4. ����ɷ�	 	\n")
						.append("		'" + productArrayDetail.get("product_bigo") 	+ "' AS product_bigo, 		-- 5. ���		\n")
						.append("		'" + jArray.get("member_key") 					+ "' AS member_key, 		-- 6. �ɹ�Ű 		\n")
						.append("		'" + productArrayDetail.get("product_rev") 		+ "' AS product_rev, 		-- 7. rev 		\n")
						.append("		'" + productArrayDetail.get("product_seq") 		+ "' AS product_seq  		-- 8. seq 		\n")
						.append("	  		FROM db_root )  mQ    \n")
						.append("ON (HSP.subcontractor_no = mQ.subcontractor_no 	\n")
						.append("AND HSP.subcontractor_rev = mQ.subcontractor_rev   \n")
						.append("AND HSP.product_rev = mQ.product_rev   \n")
						.append("AND HSP.product_seq = mQ.product_seq)   \n")
						.append("WHEN MATCHED THEN     \n")
						.append("	UPDATE SET \n")
						.append("		HSP.subcontractor_no  = mQ.subcontractor_no,  \n ")
						.append("		HSP.subcontractor_rev = 9, \n ")
						.append("		HSP.product_division  = mQ.product_division,  \n ")
						.append("		HSP.product_measure   = mQ.product_measure,   \n ")
						.append("		HSP.product_capacity  = mQ.product_capacity,  \n ")
						.append("		HSP.product_bigo      = mQ.product_bigo,      \n ")
						.append("		HSP.member_key        = mQ.member_key,        \n ")
						.append("		HSP.product_rev       = mQ.product_rev, 	  \n ")
						.append("		HSP.product_seq       = mQ.product_seq 	   	  \n ")
						.append("WHEN NOT MATCHED THEN \n")                                  
						.append("	INSERT ( 	\n")
						.append("		HSP.subcontractor_no, 	\n")		
						.append("		HSP.subcontractor_rev, 	\n")
						.append("		HSP.product_division, 	\n")
						.append("		HSP.product_measure,	\n")
						.append("		HSP.product_capacity, 	\n")
						.append("		HSP.product_bigo, 		\n")
						.append("		HSP.member_key, 		\n")
						.append("		HSP.product_rev,		\n")
						.append("		HSP.product_seq			\n")
						.append("	)	\n")
						.append("VALUES	\n")
						.append("	(\n")
						.append("		mQ.subcontractor_no, 	\n")		
						.append("		mQ.subcontractor_rev, 	\n")
						.append("		mQ.product_division, 	\n")
						.append("		mQ.product_measure,		\n")
						.append("		mQ.product_capacity, 	\n")
						.append("		mQ.product_bigo, 		\n")
						.append("		mQ.member_key, 			\n")
						.append("		mQ.product_rev,			\n")
						.append("		mQ.product_seq			\n")
						.append("	);\n")
						.toString();
						resultInt = super.excuteUpdate(con, sql.toString());
			    		if (resultInt < 0) {  //
							ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
							con.rollback();
							return EventDefine.E_DOEXCUTE_ERROR ;
						}
				}	

				for(int i=0; i<permissionArray.size(); i++) {
					JSONObject permissionArrayDetail = (JSONObject)permissionArray.get(i); // i��° �����͹���
					sql = new StringBuilder()
						.append("MERGE INTO haccp_subcontractor_permission HSP  \n")
						.append("	USING ( SELECT     \n")				
						.append("		'" + jArray.get("subcontractor_no") 					+ "' AS subcontractor_no, 		-- 0. ��Ϲ�ȣ 	\n")
						.append("		'" + jArray.get("subcontractor_rev") 					+ "' AS subcontractor_rev, 		-- 1. seq		\n")
						.append("		'" + permissionArrayDetail.get("permission_division") 	+ "' AS permission_division, 	-- 2. ���� 		\n")
						.append("		'" + permissionArrayDetail.get("permission_name") 		+ "' AS permission_name, 		-- 3. ǰ�� 		\n")
						.append("		'" + permissionArrayDetail.get("permission_institute") 	+ "' AS permission_institute, 	-- 4. ������� 	\n")
						.append("		'" + permissionArrayDetail.get("permission_date") 		+ "' AS permission_date, 		-- 5. ��������		\n")
						.append("		'" + permissionArrayDetail.get("permission_bigo") 		+ "' AS permission_bigo, 		-- 6. ��� 		\n")
						.append("		'" + jArray.get("member_key") 							+ "' AS member_key, 			-- 7. �ɹ�Ű 		\n")
						.append("		'" + permissionArrayDetail.get("permission_rev") 		+ "' AS permission_rev,  		-- 8. rev		\n")
						.append("		'" + permissionArrayDetail.get("permission_seq") 		+ "' AS permission_seq  		-- 9. seq		\n")
						.append("	  		FROM db_root )  mQ    \n")
						.append("ON (HSP.subcontractor_no = mQ.subcontractor_no 	\n")
						.append("AND HSP.subcontractor_rev = mQ.subcontractor_rev   \n")
						.append("AND HSP.permission_rev = mQ.permission_rev   \n")
						.append("AND HSP.permission_seq = mQ.permission_seq)   \n")
						.append("WHEN MATCHED THEN     \n")
						.append("	UPDATE SET \n")
						.append("		HSP.subcontractor_no     = mQ.subcontractor_no,     \n")
						.append("		HSP.subcontractor_rev    = 9,    \n")
						.append("		HSP.permission_division  = mQ.permission_division,  \n")
						.append("		HSP.permission_name      = mQ.permission_name,      \n")
						.append("		HSP.permission_institute = mQ.permission_institute, \n")
						.append("		HSP.permission_date      = mQ.permission_date,      \n")
						.append("		HSP.permission_bigo      = mQ.permission_bigo,      \n")
						.append("		HSP.member_key           = mQ.member_key,           \n")
						.append("		HSP.permission_rev       = mQ.permission_rev,    \n")
						.append("		HSP.permission_seq       = mQ.permission_seq	    \n")
						.append("WHEN NOT MATCHED THEN \n")   
						.append("	INSERT ( 	\n")
						.append("		HSP.subcontractor_no, 		\n")		
						.append("		HSP.subcontractor_rev, 		\n")
						.append("		HSP.permission_division, 	\n")
						.append("		HSP.permission_name, 		\n")
						.append("		HSP.permission_institute, 	\n")
						.append("		HSP.permission_date, 		\n")
						.append("		HSP.permission_bigo, 		\n")
						.append("		HSP.member_key, 			\n")
						.append("		HSP.permission_rev,	 		\n")
						.append("		HSP.permission_seq	 		\n")
						.append("	)	\n")
						.append("VALUES	\n")
						.append("	(\n")
						.append("		mQ.subcontractor_no, 		\n")		
						.append("		mQ.subcontractor_rev, 		\n")
						.append("		mQ.permission_division, 	\n")
						.append("		mQ.permission_name, 		\n")
						.append("		mQ.permission_institute, 	\n")
						.append("		mQ.permission_date, 		\n")
						.append("		mQ.permission_bigo, 		\n")
						.append("		mQ.member_key, 				\n")
						.append("		mQ.permission_rev,	 		\n")
						.append("		mQ.permission_seq	 		\n")
						.append("	);\n")
						.toString();
						resultInt = super.excuteUpdate(con, sql.toString());
			    		if (resultInt < 0) {  //
							ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
							con.rollback();
							return EventDefine.E_DOEXCUTE_ERROR ;
						}
				}	
				
				for(int i=0; i<equipmentArray.size(); i++) {
					JSONObject equipmentArrayDetail = (JSONObject)equipmentArray.get(i); // i��° �����͹���
					sql = new StringBuilder()
						.append("MERGE INTO haccp_subcontractor_equipment HSP  \n")
						.append("	USING ( SELECT     \n")		
						.append("		'" + jArray.get("subcontractor_no") 					+ "' AS subcontractor_no, 		-- 0. ��Ϲ�ȣ 	\n")
						.append("		'" + jArray.get("subcontractor_rev") 					+ "' AS subcontractor_rev, 		-- 1. rev		\n")
						.append("		'" + equipmentArrayDetail.get("equipment_name") 		+ "' AS equipment_name, 		-- 2. �����		\n")
						.append("		'" + equipmentArrayDetail.get("equipment_standard") 	+ "' AS equipment_standard, 	-- 3. ���� �� �԰�	\n")
						.append("		'" + equipmentArrayDetail.get("equipment_manufacturer") + "' AS equipment_manufacturer, -- 4. ����ȸ�� 	\n")
						.append("		'" + equipmentArrayDetail.get("equipment_have") 		+ "' AS equipment_have, 		-- 5. ��������		\n")
						.append("		'" + equipmentArrayDetail.get("equipment_bigo") 		+ "' AS equipment_bigo, 		-- 6. ��� 		\n")
						.append("		'" + jArray.get("member_key") 							+ "' AS member_key, 			-- 7. �ɹ�Ű 		\n")
						.append("		'" + equipmentArrayDetail.get("equipment_rev") 			+ "' AS equipment_rev, 			-- 8. rev 		\n")
						.append("		'" + equipmentArrayDetail.get("equipment_seq") 			+ "' AS equipment_seq 			-- 9. seq		\n")
						.append("	  		FROM db_root )  mQ    \n")
						.append("ON (HSP.subcontractor_no = mQ.subcontractor_no 	\n")
						.append("AND HSP.subcontractor_rev = mQ.subcontractor_rev   \n")
						.append("AND HSP.equipment_rev = mQ.equipment_rev   \n")
						.append("AND HSP.equipment_seq = mQ.equipment_seq)   \n")
						.append("WHEN MATCHED THEN     \n")
						.append("	UPDATE SET \n")
						.append("		HSP.subcontractor_no       = mQ.subcontractor_no,       \n")
						.append("		HSP.subcontractor_rev	   = 9,      \n")
						.append("		HSP.equipment_name		   = mQ.equipment_name,         \n")
						.append("		HSP.equipment_standard	   = mQ.equipment_standard,     \n")
						.append("		HSP.equipment_manufacturer = mQ.equipment_manufacturer, \n")	
						.append("		HSP.equipment_have		   = mQ.equipment_have,         \n")
						.append("		HSP.equipment_bigo		   = mQ.equipment_bigo,         \n")
						.append("		HSP.member_key		       = mQ.member_key,             \n")
						.append("		HSP.equipment_rev		   = mQ.equipment_rev,      \n")
						.append("		HSP.equipment_seq		   = mQ.equipment_seq       	\n")
						.append("WHEN NOT MATCHED THEN \n")   
						.append("	INSERT ( 	\n")	
						.append("		HSP.subcontractor_no, 	\n")		
						.append("		HSP.subcontractor_rev, 	\n")
						.append("		HSP.equipment_name, 	\n")
						.append("		HSP.equipment_standard, \n")
						.append("		HSP.equipment_manufacturer, \n")
						.append("		HSP.equipment_have, 	\n")
						.append("		HSP.equipment_bigo, 	\n")
						.append("		HSP.member_key,			\n")
						.append("		HSP.equipment_rev,		\n")
						.append("		HSP.equipment_seq 		\n")
						.append("	)	\n")
						.append("VALUES	\n")
						.append("	(\n")
						.append("		mQ.subcontractor_no, 	\n")	
						.append("		mQ.subcontractor_rev, 	\n")
						.append("		mQ.equipment_name, 		\n")
						.append("		mQ.equipment_standard, 	\n")
						.append("		mQ.equipment_manufacturer, \n")
						.append("		mQ.equipment_have, 		\n")
						.append("		mQ.equipment_bigo, 		\n")
						.append("		mQ.member_key,			\n")
						.append("		mQ.equipment_rev,		\n")
						.append("		mQ.equipment_seq 		\n")
						.append("	);\n")
						.toString();
						resultInt = super.excuteUpdate(con, sql.toString());
			    		if (resultInt < 0) {  //
							ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
							con.rollback();
							return EventDefine.E_DOEXCUTE_ERROR ;
						}
				}	
//				System.out.println(sql.toString());
				
				if (resultInt < 0) {
					con.rollback();
					return EventDefine.E_DOEXCUTE_ERROR ;
				}
				
				con.commit();			
			
		} catch(Exception e) {
			LoggingWriter.setLogError("M838S060200E103()","==== SQL ERROR ===="+ e.getMessage() + "\n" + sql.toString());
			e.printStackTrace();
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M838S060200E103()","==== finally ===="+ e.getMessage());
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

	// �̷����ǿ� �ش��ϴ� �ŷ�ó ����� GROUP BY �˻��Ѵ�. 
	
	public int E104(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
//			// Ŭ���̾�Ʈ�� ���� ���� �Ķ���͸� �Ű� ��´�.
//			String rcvData = (String)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));

			String sql = new StringBuilder()
					
/*					
  					.append("SELECT\n")
					.append("	subcontractor_no,\n")
					.append("	subcontractor_rev,\n")
					.append("	subcontractor_seq,\n")
					.append("	subcontractor_name,\n")
					.append("	subcontractor_ceo,\n")
					.append("	subcontractor_headoffice_address,\n")
					.append("	subcontractor_headoffice_phone,\n")
					.append("	subcontractor_factory_address,\n")
					.append("	subcontractor_factory_phone,\n")
					.append("	establish_date,\n")
					.append("	factory_scale,\n")
					.append("	account_start_date,\n")
					.append("	writor,\n")
					.append("	writor_rev,\n")
					.append("	write_date,\n")
					.append("	checker,\n")
					.append("	checker_rev,\n")
					.append("	check_date,\n")
					.append("	approval,\n")
					.append("	approval_rev,\n")
					.append("	approve_date,\n")
					.append("	appraisal_means,\n")
					.append("	member_key\n")
					.append("FROM haccp_subcontractor_present A\n")
					.append("WHERE check_date \n")
					.append("BETWEEN '" + jArray.get("fromdate") + "' 	\n")
					.append("	 AND '" + jArray.get("todate") + "'	\n")
					.append("AND A.member_key = '" + jArray.get("member_key") + "' \n")
					.append("AND B.subcontractor_seq != 9 \n")
					.append("GROUP BY A.subcontractor_no, A.subcontractor_rev, A.subcontractor_seq \n")
					.append("ORDER BY A.write_date, A.check_date ASC \n")
*/
					
					.append("SELECT DISTINCT \n")
					.append("	cust_cd,\n")
					.append("	revision_no,\n")
					.append("	B.subcontractor_seq, \n")
					.append("	cust_nm,\n")
					.append("	boss_name,\n")
					.append("	uptae,\n")
					.append("	jongmok,\n")
					.append("	io_gb,\n")
					.append("	start_date,\n")
					.append("	create_date,\n")
					.append("	create_user_id,\n")
					.append("	modify_date,\n")
					.append("	modify_user_id,\n")
					.append("	duration_date\n")
					.append("FROM \n")
					.append("	tbm_customer A \n")
					.append("LEFT OUTER JOIN haccp_subcontractor_present B\n")
					.append("ON B.subcontractor_no = A.cust_cd\n")
					.append("WHERE create_date \n")
					.append("BETWEEN '" + jArray.get("fromdate") + "' \n")
					.append("	 AND '" + jArray.get("todate") + "'	\n")
					.append("AND A.member_key = '" + jArray.get("member_key") + "' \n")
					.append("AND A.duration_date = '9999-12-31' \n")
//					.append("AND B.subcontractor_seq != 9 \n")
					.append("GROUP BY A.cust_cd, A.revision_no  \n")
					.append("ORDER BY A.create_date, A.cust_cd ASC \n")
					
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
			LoggingWriter.setLogError("M838S060200E104()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M838S060200E104()","==== finally ===="+ e.getMessage());
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

	// �����Ȱ� ��ȸ�� 
	public int E105(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
//			// Ŭ���̾�Ʈ�� ���� ���� �Ķ���͸� �Ű� ��´�.
//			String rcvData = (String)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));

			String sql = new StringBuilder()
/*					
					.append("SELECT\n")
					.append("	subcontractor_no,\n")
					.append("	subcontractor_rev,\n")
					.append("	subcontractor_seq,\n")
					.append("	subcontractor_name,\n")
					.append("	subcontractor_ceo,\n")
					.append("	subcontractor_headoffice_address,\n")
					.append("	subcontractor_headoffice_phone,\n")
					.append("	subcontractor_factory_address,\n")
					.append("	subcontractor_factory_phone,\n")
					.append("	establish_date,\n")
					.append("	factory_scale,\n")
					.append("	account_start_date,\n")
					.append("	writor,\n")
					.append("	writor_rev,\n")
					.append("	write_date,\n")
					.append("	checker,\n")
					.append("	checker_rev,\n")
					.append("	check_date,\n")
					.append("	approval,\n")
					.append("	approval_rev,\n")
					.append("	approve_date,\n")
					.append("	appraisal_means,\n")
					.append("	member_key\n")
					.append("FROM haccp_subcontractor_present A\n")
					.append("WHERE check_date \n")
					.append("BETWEEN '" + jArray.get("fromdate") + "' 	\n")
					.append("	 AND '" + jArray.get("todate") + "'	\n")
					.append("AND A.member_key = '" + jArray.get("member_key") + "' \n")
					.append("AND A.subcontractor_seq = 9 \n")
					.append("GROUP BY A.subcontractor_no, A.subcontractor_rev, A.subcontractor_seq \n")
					.append("ORDER BY A.write_date, A.check_date ASC \n")
*/					
					.append("SELECT DISTINCT\n")
					.append("	cust_cd,\n")
					.append("	revision_no,\n")
					.append("	B.subcontractor_seq, \n")
					.append("	cust_nm,\n")
					.append("	boss_name,\n")
					.append("	uptae,\n")
					.append("	jongmok,\n")
					.append("	io_gb,\n")
					.append("	start_date,\n")
					.append("	create_date,\n")
					.append("	create_user_id,\n")
					.append("	modify_date,\n")
					.append("	modify_user_id,\n")
					.append("	duration_date\n")
					.append("FROM \n")
					.append("	tbm_customer A \n")
					.append("JOIN haccp_subcontractor_present B\n")
					.append("ON B.subcontractor_no = A.cust_cd\n")
					.append("WHERE create_date \n")
					.append("BETWEEN '" + jArray.get("fromdate") + "' 	\n")
					.append("	 AND '" + jArray.get("todate") + "'	\n")
					.append("AND A.member_key = '" + jArray.get("member_key") + "' \n")
					.append("AND A.duration_date != '9999-12-31' \n")
					.append("GROUP BY A.cust_cd, A.revision_no  \n")
					.append("ORDER BY A.create_date, A.cust_cd ASC \n")
					
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
			LoggingWriter.setLogError("M838S060200E105()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M838S060200E105()","==== finally ===="+ e.getMessage());
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
	
	// �ο���Ȳ
	public int E114(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			System.out.println("JSONObject jArray rcvData="+ jArray.toString());	
			
			String sql = new StringBuilder()
				.append("SELECT\n")
				.append("	subcontractor_no,\n")
				.append("	subcontractor_rev,\n")
				.append("	person_division,\n")
				.append("	person_people,\n")
				.append("	person_desk,\n")
				.append("	person_technical,\n")
				.append("	person_product,\n")
				.append("	person_etc,\n")
				.append("	person_sum,\n")
				.append("	person_bigo,\n")
				.append("	member_key,\n")
				.append("	person_rev,\n")
				.append("	person_seq\n")
				.append("FROM haccp_subcontractor_person A\n")
				.append("WHERE A.subcontractor_no = '" + jArray.get("subcontractor_no") + "' \n")
				.append("AND A.subcontractor_rev = '" + jArray.get("subcontractor_rev") + "' \n")
				.append("AND A.member_key = '" + jArray.get("member_key") + "' \n")
				.append("ORDER BY A.person_seq ASC \n")
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
				LoggingWriter.setLogError("M838S060200E114()","==== SQL ERROR ===="+ e.getMessage());
				return EventDefine.E_DOEXCUTE_ERROR ;
		    } finally {
		    	if (Config.useDataSource) {
					try {
						if (con != null) con.close();
					} catch (Exception e) {
						LoggingWriter.setLogError("M838S060200E114()","==== finally ===="+ e.getMessage());
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
	
	// ǰ�� ����ɷ�
	public int E124(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			System.out.println("JSONObject jArray rcvData="+ jArray.toString());	
			
			String sql = new StringBuilder()
				.append("SELECT\n")
				.append("	subcontractor_no,\n")
				.append("	subcontractor_rev,\n")
				.append("	product_division,\n")
				.append("	product_measure,\n")
				.append("	product_capacity,\n")
				.append("	product_bigo,\n")
				.append("	member_key,\n")
				.append("	product_rev,\n")
				.append("	product_seq\n")
				.append("FROM\n")
				.append("	haccp_subcontractor_product A \n")
				.append("WHERE A.subcontractor_no = '" + jArray.get("subcontractor_no") + "' \n")
				.append("AND A.subcontractor_rev = '" + jArray.get("subcontractor_rev") + "' \n")
				.append("AND A.member_key = '" + jArray.get("member_key") + "' \n")
				.append("ORDER BY A.product_seq ASC \n")
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
				LoggingWriter.setLogError("M838S060200E124()","==== SQL ERROR ===="+ e.getMessage());
				return EventDefine.E_DOEXCUTE_ERROR ;
		    } finally {
		    	if (Config.useDataSource) {
					try {
						if (con != null) con.close();
					} catch (Exception e) {
						LoggingWriter.setLogError("M838S060200E124()","==== finally ===="+ e.getMessage());
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
	
	// ��ǰ�����㰡����
	public int E134(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			System.out.println("JSONObject jArray rcvData="+ jArray.toString());	
			
			String sql = new StringBuilder()
				.append("SELECT\n")
				.append("	subcontractor_no,\n")
				.append("	subcontractor_rev,\n")
				.append("	permission_division,\n")
				.append("	permission_name,\n")
				.append("	permission_institute,\n")
				.append("	permission_date,\n")
				.append("	permission_bigo,\n")
				.append("	member_key,\n")
				.append("	permission_rev,\n")
				.append("	permission_seq\n")
				.append("FROM\n")
				.append("	haccp_subcontractor_permission A \n")
				.append("WHERE A.subcontractor_no = '" + jArray.get("subcontractor_no") + "' \n")
				.append("AND A.subcontractor_rev = '" + jArray.get("subcontractor_rev") + "' \n")
				.append("AND A.member_key = '" + jArray.get("member_key") + "' \n")
				.append("ORDER BY A.permission_seq ASC \n")
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
				LoggingWriter.setLogError("M838S060200E134()","==== SQL ERROR ===="+ e.getMessage());
				return EventDefine.E_DOEXCUTE_ERROR ;
		    } finally {
		    	if (Config.useDataSource) {
					try {
						if (con != null) con.close();
					} catch (Exception e) {
						LoggingWriter.setLogError("M838S060200E134()","==== finally ===="+ e.getMessage());
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
	
	// ������Ȳ
	public int E144(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			System.out.println("JSONObject jArray rcvData="+ jArray.toString());	
			
			String sql = new StringBuilder()
				.append("SELECT\n")
				.append("	subcontractor_no,\n")
				.append("	subcontractor_rev,\n")
				.append("	equipment_name,\n")
				.append("	equipment_standard,\n")
				.append("	equipment_manufacturer,\n")
				.append("	equipment_have,\n")
				.append("	equipment_bigo,\n")
				.append("	member_key,\n")
				.append("	equipment_rev,\n")
				.append("	equipment_seq\n")
				.append("FROM\n")
				.append("	haccp_subcontractor_equipment A \n")
				.append("WHERE A.subcontractor_no = '" + jArray.get("subcontractor_no") + "' \n")
				.append("AND A.subcontractor_rev = '" + jArray.get("subcontractor_rev") + "' \n")
				.append("AND A.member_key = '" + jArray.get("member_key") + "' \n")
				.append("ORDER BY A.equipment_seq ASC \n")
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
				LoggingWriter.setLogError("M838S060200E144()","==== SQL ERROR ===="+ e.getMessage());
				return EventDefine.E_DOEXCUTE_ERROR ;
		    } finally {
		    	if (Config.useDataSource) {
					try {
						if (con != null) con.close();
					} catch (Exception e) {
						LoggingWriter.setLogError("M838S060200E144()","==== finally ===="+ e.getMessage());
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
	
	// ȸ������ ��ȸ 
	public int E154(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
//			// Ŭ���̾�Ʈ�� ���� ���� �Ķ���͸� �Ű� ��´�.
//			String rcvData = (String)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));

			String sql = new StringBuilder()
				.append("SELECT\n")
				.append("	cust_cd,\n")
				.append("	revision_no,\n")
				.append("	cust_nm,\n")
				.append("	address,\n")
				.append("	telno,\n")
				.append("	boss_name,\n")
				.append("	bizno,\n")
				.append("	uptae,\n")
				.append("	jongmok,\n")
				.append("	faxno,\n")
				.append("	homepage,\n")
				.append("	zipno,\n")
				.append("	dangsa_damdangja,\n")
				.append("	cust_damdangja,\n")
				.append("	damdangja_dno,\n")
				.append("	damdangja_hpno,\n")
				.append("	damdangja_email,\n")
				.append("	visit_jugi_day,\n")
				.append("	io_gb,\n")
				.append("	old_cust_cd,\n")
				.append("	start_date,\n")
				.append("	create_date,\n")
				.append("	create_user_id,\n")
				.append("	modify_date,\n")
				.append("	modify_user_id,\n")
				.append("	duration_date,\n")
				.append("	modify_reason,\n")
				.append("	refno,\n")
				.append("	member_key\n")
				.append("FROM\n")
				.append("	tbm_customer A \n")			
				.append("WHERE A.cust_cd 	= '" + jArray.get("subcontractor_no") + "' \n")
				.append("AND A.revision_no 	= '" + jArray.get("subcontractor_rev") + "' \n")
				.append("AND A.io_gb 		= '" + jArray.get("io_gb") + "' \n")
				.append("AND A.member_key 	= '" + jArray.get("member_key") + "' \n")
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
			LoggingWriter.setLogError("M838S060200E154()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M838S060200E154()","==== finally ===="+ e.getMessage());
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
	// ĵ���� ��Ÿ���̺� ��ȸ 
	public int E164(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
//			// Ŭ���̾�Ʈ�� ���� ���� �Ķ���͸� �Ű� ��´�.
//			String rcvData = (String)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));

			String sql = new StringBuilder()
				.append("SELECT\n")
				.append("	subcontractor_no,\n")
				.append("	subcontractor_rev,\n")
				.append("	subcontractor_seq,\n")
				.append("	subcontractor_factory_address,\n")
				.append("	subcontractor_factory_phone,\n")
				.append("	establish_date,\n")
				.append("	factory_scale,\n")
				.append("	checker,\n")
				.append("	check_date,\n")
				.append("	approval,\n")
				.append("	approve_date,\n")
				.append("	appraisal_means,\n")
				.append("	member_key,\n")
				.append("	present_rev\n")
				.append("FROM\n")
				.append("	haccp_subcontractor_present A \n")
				.append("WHERE A.subcontractor_no 	= '" + jArray.get("subcontractor_no") + "' \n")
				.append("AND A.subcontractor_rev 	= '" + jArray.get("subcontractor_rev") + "' \n")
				.append("AND A.subcontractor_seq 	= '" + jArray.get("subcontractor_seq") + "' \n")
				.append("AND A.member_key 			= '" + jArray.get("member_key") + "' \n")
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
			LoggingWriter.setLogError("M838S060200E164()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M838S060200E164()","==== finally ===="+ e.getMessage());
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