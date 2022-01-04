package mes.frame.business.M353;

import java.lang.reflect.Method;
import java.sql.Connection;
import java.sql.PreparedStatement;

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


public class M353S020100 extends SqlAdapter{
	Connection con = null;
	PreparedStatement pstmt = null;
	String resultString = "";
	int resultInt = -1;
	StringBuffer sql = new StringBuffer();
	
	String[][] v_paramArray = new String[0][0]; 
	Class[] optClass = null;
	Object[] optObj = null;
	Object obj = null;
	
	public M353S020100(){
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
			
			Method method = M353S020100.class.getMethod(event,optClass);
			LoggingWriter.setLogDebug(M353S020100.class.getName(),"==== " + event + " EventMethod Create Success ====");

			obj = method.invoke(M353S020100.class.newInstance(),optObj);
			doExcute_result = CommonFunction.getInt(obj.toString());
			
	    } catch (Exception ex) {
	    	doExcute_result = EventDefine.E_DOEXCUTE_INIT;
			ioParam.setMessage(MessageDefine.M_NO_EVENTID);
			LoggingWriter.setLogError(M353S020100.class.getName(),"==== EventID Not define : EVENT ID [ " + ioParam.getEventID() + "]");
	    } finally {
	    	obj = null;
			optClass = null;
			optObj = null;
	    }
	    long endTime = System.currentTimeMillis();
		long runningTime = endTime - startTime;
		LoggingWriter.setLogAll(M353S020100.class.getName(),"==== Query [����ð�  : " + runningTime + " ms]");
		
		return doExcute_result;
	}
	
	//������ ���ó���κ�
	public int E101(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject(); // JSONObject ����
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			
			sql = new StringBuffer();
			sql.append(" INSERT INTO tbi_seolbi_repare ( \n");
			sql.append(" 		seolbi_cd,	\n"); 
			sql.append(" 		seq_no,		\n"); 
			sql.append(" 		reason_cd,	\n"); 
			sql.append(" 		start_dt,	\n"); 
			sql.append(" 		end_dt,		\n"); 
			sql.append(" 		user_id,	\n"); 
			sql.append(" 		biyong,		\n"); 
			sql.append(" 		gigwan_nm,	\n"); 
			sql.append(" 		work_memo,	\n"); 
			sql.append(" 		bigo,		\n");
			sql.append(" 		member_key	\n");
			sql.append(" 	) VALUES ( 		\n");
			sql.append(" 		'" + jArray.get("seolbi_code") + "', \n"); 	//seolbi_cd
			sql.append(" 		(SELECT coalesce(MAX(seq_no),0)+1 "
							+ 	"FROM tbi_seolbi_repare "
							+ "	 WHERE seolbi_cd='" + jArray.get("seolbi_code") + "'), \n"); 	//sys_bom_id
			sql.append(" 		'" + jArray.get("job_gubun") + "', 	\n"); 	//reason_cd
			sql.append(" 		'" + jArray.get("start_date") + "', \n"); 	//start_dt
			sql.append(" 		'" + jArray.get("end_date") + "',	\n"); 	//end_dt
			sql.append(" 		'" + jArray.get("damdangja") + "', 	\n"); 	//user_id
			sql.append(" 		'" + jArray.get("biyong") + "', 	\n"); 	//biyong
			sql.append(" 		'" + jArray.get("gigwan_name") + "',\n"); 	//gigwan_nm
			sql.append(" 		'" + jArray.get("work_memo") + "', 	\n"); 	//work_memo
			sql.append(" 		'" + jArray.get("bigo") + "',		\n"); 	//bigo
			sql.append(" 		'" + jArray.get("member_key") + "'	\n"); 	//member_key
			sql.append(" 	) 										\n");

			// super�� excuteUpdate�� 3������ �ִ�.
			// ù°�� super.excuteUpdate(con, sql.toString(), v_paramArray)���� �̸�,
			// PreparedStatement�� ����ϱ� ���� �Ķ���͵��� ��ɿ� ��� ������ üũ�� �ؼ� �����ϴ� �����̴�. �׸���
			// �ι�°�� super.excuteUpdate(con, Vector)�ε�, ��Ƽ �ο츦 ����ϱ� ���� ���õ� ��ġ�̴�.
			// ����°�� �ϳ��� SQL�� String���� �޾Ƽ� ó���ϴ� ����̴�.
			// ���� ���� SQL���¶��.. �翬�� 1���� �ο쿡 �ش�ǹǷ� ����° �޽�带 ����ϴ� ���� ���ϴ�.
			
			resultInt = super.excuteUpdate(con, sql.toString());
			if (resultInt < 0) {
				ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
			} else {
				ioParam.setMessage(resultInt + "�� " + MessageDefine.M_INSERT_RESULT);
			}
		} catch(Exception e) {
			LoggingWriter.setLogError("M353S020100E101()","==== SQL ERROR ===="+ e.getMessage() + "\n" + sql.toString());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M353S020100E101()","==== finally ===="+ e.getMessage());
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
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject(); // JSONObject ����
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));

			sql = new StringBuffer();
			sql.append(" UPDATE tbi_seolbi_repare set 						\n");
			sql.append(" 	reason_cd, = 	'" + jArray.get("job_gubun") + "'	\n"); 
			sql.append(" 	start_dt, = 	'" + jArray.get("start_date") + "'	\n"); 
			sql.append(" 	end_dt, = 		'" + jArray.get("end_date") + "'	\n"); 
			sql.append(" 	user_id, = 		'" + jArray.get("damdangja") + "'	\n"); 
			sql.append(" 	biyong, = 		'" + jArray.get("biyong") + "'		\n"); 
			sql.append(" 	gigwan_nm, = 	'" + jArray.get("gigwan_name") + "'	\n"); 
			sql.append(" 	work_memo, = 	'" + jArray.get("work_memo") + "'	\n"); 
			sql.append(" 	bigo = 		'" + jArray.get("bigo") + "'		\n"); 
			sql.append(" 	,member_key = 	'" + jArray.get("member_key") + "'		\n");  // member_key_update
			sql.append(" WHERE seolbi_cd = 	'" + jArray.get("seolbi_code") + "' \n");
			sql.append(" 	AND seq_no = '"    + jArray.get("seq_no") + "' 		\n");
			sql.append(" 	AND member_key = '"    + jArray.get("member_key") + "' 		\n");

			// super�� excuteUpdate�� 3������ �ִ�.
			// ù°�� super.excuteUpdate(con, sql.toString(), v_paramArray)���� �̸�,
			// PreparedStatement�� ����ϱ� ���� �Ķ���͵��� �迭�� ��� ������ üũ�� �ؼ� �����ϴ� �����̴�. �׸���
			// �ι�°�� super.excuteUpdate(con, Vector)�ε�, ��Ƽ �ο츦 ����ϱ� ���� ���õ� ��ġ�̴�.
			// ����°�� �ϳ��� SQL�� String���� �޾Ƽ� ó���ϴ� ����̴�.
			// ���� ���� SQL���¶��.. �翬�� 1���� �ο쿡 �ش�ǹǷ� ����° �޽�带 ����ϴ� ���� ���ϴ�.
			resultInt = super.excuteUpdate(con, sql.toString());
			if (resultInt < 0) {
				ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
				return resultInt;
			} else {
				ioParam.setMessage(resultInt + "�� " + MessageDefine.M_INSERT_RESULT);
			}
		} catch(Exception e) {
			LoggingWriter.setLogError("M353S020100E102()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M353S020100E102()","==== finally ===="+ e.getMessage());
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

	public int E104(InoutParameter ioParam) {
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			System.out.println("JSONObject jArray rcvData="+ jArray.toString());
			
			String sql = new StringBuilder()
					.append("SELECT\n")
					.append("	proc_plan_no, 			-- 0. (����)\n")
					.append("	A.prod_cd, 				-- 1. (����)\n")
					.append("	A.prod_cd_rev, 			-- 2. (����)\n")
					.append("	P.product_nm, 			-- 3. ��ǰ��\n")
					.append("	mix_recipe_cnt, 		-- 4. ���ռ�(�Ҽ����Էµǰ�)\n")					
					.append("	start_dt, 				-- 5. ��������Ͻ�\n")
					.append("	end_dt, 				-- 6. ����Ϸ��Ͻ�\n")
					.append("	A.production_status, 	-- 7. (����)\n")
					.append("	PS.code_name 			-- 8. �������\n")
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

			resultString = super.excuteQueryString(con, sql.toString());
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M353S020100E104()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M353S020100E104()","==== finally ===="+ e.getMessage());
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
	
	public int E105(InoutParameter ioParam) {
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			System.out.println("JSONObject jArray rcvData="+ jArray.toString());
			
			
			String sql = new StringBuilder()
					.append("SELECT\n")
					.append("        A.sys_bom_id,\n")
					.append("        A.part_cd,\n")
					.append("        A.part_cd_rev,\n")
					.append("        A.bom_name,\n")
					.append("        B.part_nm  || '('||D.code_name  ||','||  E.code_name ||')' AS part_nm,\n")
					.append("        A.part_cnt,\n")
					.append("        F.meterage1,\n")
					.append("        F.meterage2,\n")
					.append("        F.meterage3,\n")
					.append("        F.meterage4,\n")
					.append("        F.meterage5,\n")
					.append("        F.meterage6,\n")
					.append("        F.meterage7,\n")
					.append("        F.meterage8,\n")
					.append("        F.meterage9,\n")
					.append("        F.meterage10,\n")
					.append("        F.production_date\n")
					.append("FROM tbi_order_bomlist A\n")
					.append("INNER JOIN tbm_part_list B\n")
					.append("       ON A.part_cd = B.part_cd\n")
					.append("        AND A.part_cd_rev = B.revision_no\n")
					.append("        AND A.member_key = B.member_key\n")
					.append("INNER JOIN v_partgubun_big D\n")
					.append("             ON B.part_gubun_b = D.code_value\n")
					.append("           AND B.member_key = D.member_key\n")
					.append("INNER JOIN v_partgubun_mid E\n")
					.append("             ON B.part_gubun_m = E.code_value\n")
					.append("           AND B.member_key = E.member_key\n")
					.append("LEFT OUTER JOIN tbi_order_bomlist_result F           \n")
					.append("			 ON A.proc_plan_no = F.proc_plan_no\n")
					.append("		   AND A.bom_cd = F.bom_cd\n")
					.append("		   AND A.bom_cd_rev = F.bom_cd_rev\n")
					.append("			AND A.part_cd = F.part_cd\n")
					.append("			AND A.part_cd_rev = F.part_cd_rev\n")
					.append("          AND A.member_key = F.member_key\n")
					.append("WHERE A.proc_plan_no='"+jArray.get("proc_plan_no") +"'\n")
					.append("	AND A.bom_cd = '"+jArray.get("bom_cd")+"'\n")
					.append("	AND A.bom_cd_rev = '"+jArray.get("bom_cd_rev")+"'\n")
					.append("	AND A.member_key = '"+jArray.get("member_key")+"'\n")
//					.append("WHERE\n")
//					.append("         lotno = (SELECT MAX(lotno) FROM  tbi_order_bomlist WHERE  order_no='"+jArray.get("order_no")+"')\n")
					.append("ORDER BY A.order_no\n")
					.append(";\n")
					.toString();


			resultString = super.excuteQueryString(con, sql.toString());
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M353S020100E105()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
		} finally {
			if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M353S020100E105()","==== finally ===="+ e.getMessage());
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
	
	public int E145(InoutParameter ioParam) {
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			System.out.println("JSONObject jArray rcvData="+ jArray.toString());
			
			
			String sql = new StringBuilder()
					.append("SELECT\n")
					.append("        A.sys_bom_id,\n")
					.append("        A.part_cd,\n")
					.append("        A.part_cd_rev,\n")
					.append("        A.bom_name,\n")
					.append("        B.part_nm  || '('||D.code_name  ||','||  E.code_name ||')' AS part_nm,\n")
					.append("        A.part_cnt,\n")
					.append("        F.meterage1,\n")
					.append("        F.meterage2,\n")
					.append("        F.meterage3,\n")
					.append("        F.meterage4,\n")
					.append("        F.meterage5,\n")
					.append("        F.meterage6,\n")
					.append("        F.meterage7,\n")
					.append("        F.meterage8,\n")
					.append("        F.meterage9,\n")
					.append("        F.meterage10,\n")
					.append("        F.production_date\n")
					.append("FROM tbi_order_bomlist A\n")
					.append("INNER JOIN tbm_part_list B\n")
					.append("       ON A.part_cd = B.part_cd\n")
					.append("        AND A.part_cd_rev = B.revision_no\n")
					.append("        AND A.member_key = B.member_key\n")
					.append("INNER JOIN v_partgubun_big D\n")
					.append("             ON B.part_gubun_b = D.code_value\n")
					.append("           AND B.member_key = D.member_key\n")
					.append("INNER JOIN v_partgubun_mid E\n")
					.append("             ON B.part_gubun_m = E.code_value\n")
					.append("           AND B.member_key = E.member_key\n")
					.append("INNER JOIN tbi_order_bomlist_result F           \n")
					.append("			 ON A.proc_plan_no = F.proc_plan_no\n")
					.append("		   AND A.bom_cd = F.bom_cd\n")
					.append("		   AND A.bom_cd_rev = F.bom_cd_rev\n")
					.append("			AND A.part_cd = F.part_cd\n")
					.append("			AND A.part_cd_rev = F.part_cd_rev\n")
					.append("          AND A.member_key = F.member_key\n")
					.append("WHERE A.proc_plan_no='"+jArray.get("proc_plan_no") +"'\n")
					.append("	AND A.bom_cd = '"+jArray.get("bom_cd")+"'\n")
					.append("	AND A.bom_cd_rev = '"+jArray.get("bom_cd_rev")+"'\n")
					.append("	AND A.member_key = '"+jArray.get("member_key")+"'\n")
//					.append("WHERE\n")
//					.append("         lotno = (SELECT MAX(lotno) FROM  tbi_order_bomlist WHERE  order_no='"+jArray.get("order_no")+"')\n")
					.append("ORDER BY A.order_no\n")
					.append(";\n")
					.toString();


			resultString = super.excuteQueryString(con, sql.toString());
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M353S020100E105()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
		} finally {
			if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M353S020100E105()","==== finally ===="+ e.getMessage());
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
	
	public int E111(InoutParameter ioParam){

		String sql ="";
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		ApprovalActionNo ActionNo;
		String gOrderNo="";
		try {
			con = JDBCConnectionPool.getConnection();
			con.setAutoCommit(false);
			
    		// insert_update_delete_json.jsp���� �޾ƿ� JSON������ ó��
    		JSONObject jArray = new JSONObject();
    		jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
    		System.out.println("JSONObject jArray rcvData="+ jArray.toString());
    		// Object�����Ϳ��� Ű��(param)���� JSONArray�����͸� ������. (�����͹��� �ϳ��϶� ����)
    		JSONArray jjArray = (JSONArray) jArray.get("param");
    		System.out.println("������ ���� ���� :::: " + jjArray.size());
    		
    		
    		JSONObject jjjArray0 = (JSONObject)jjArray.get(0); // 0��° �����͹���
			
			for(int i=0; i<jjArray.size(); i++) {
				JSONObject jjjArray = (JSONObject)jjArray.get(i); // i��° �����͹���
					sql = new StringBuilder()
							.append("MERGE  INTO tbi_order_bomlist_result  mm\n")
							.append("USING ( SELECT\n")
							.append("						'" + jjjArray.get("proc_plan_no") 	 + "'	AS proc_plan_no,\n")
							.append("						'" + jjjArray.get("production_date") 	 + "'	AS production_date,\n")
							.append("						'" + jjjArray.get("bom_cd") 	 + "'	AS bom_cd,\n")
							.append("						'" + jjjArray.get("bom_cd_rev") 	 + "'	AS bom_cd_rev,\n")
							.append("						'" + jjjArray.get("bom_result_seq") 	 + "'	AS bom_result_seq,\n")
							.append("						'" + jjjArray.get("bom_name") 	 + "'	AS bom_name,\n")
							.append("						'" + jjjArray.get("sys_bom_id") 	 + "'	AS sys_bom_id,\n")
							.append("						'" + jjjArray.get("approval") 	 + "'	AS approval,\n")
							.append("						'" + jjjArray.get("part_cd") 	 + "'	AS part_cd,\n")
							.append("						'" + jjjArray.get("part_cd_rev") 	 + "'	AS part_cd_rev,\n")
							.append("						'" + jjjArray.get("part_nm") 	 + "'	AS part_nm,\n")
							.append("						'" + jjjArray.get("part_cnt") 	 + "'	AS part_cnt,\n")
							.append("						'" + jjjArray.get("bigo") 	 + "'	AS bigo,\n")
							.append("						'Y'	AS result,\n")
							.append("						'" + jjjArray.get("member_key") 	 + "'	AS member_key,\n")
							.append("						'g'	AS unit,\n")
							.append("						'" + jjjArray.get("meterage1") 	 + "'	AS meterage1,\n")
							.append("						'" + jjjArray.get("meterage2") 	 + "'	AS meterage2,\n")
							.append("						'" + jjjArray.get("meterage3") 	 + "'	AS meterage3,\n")
							.append("						'" + jjjArray.get("meterage4") 	 + "'	AS meterage4,\n")
							.append("						'" + jjjArray.get("meterage5") 	 + "'	AS meterage5,\n")
							.append("						'" + jjjArray.get("meterage6") 	 + "'	AS meterage6,\n")
							.append("						'" + jjjArray.get("meterage7") 	 + "'	AS meterage7,\n")
							.append("						'" + jjjArray.get("meterage8") 	 + "'	AS meterage8,\n")
							.append("						'" + jjjArray.get("meterage9") 	 + "'	AS meterage9,\n")
							.append("						'" + jjjArray.get("meterage10") 	 + "'	AS meterage10\n")
							.append(")  mQ\n")
							.append("ON ( mm.proc_plan_no = mQ.proc_plan_no AND mm.member_key = mQ.member_key \n")
							.append("		AND mm.bom_cd = mQ.bom_cd  AND mm.bom_cd_rev = mQ.bom_cd_rev AND mm.bom_result_seq = mQ.bom_result_seq \n")
							.append("		AND mm.sys_bom_id = mQ.sys_bom_id AND mm.part_cd = mQ.part_cd AND mm.part_cd_rev = mQ.part_cd_rev )\n")
							.append("WHEN MATCHED THEN\n")
							.append("                UPDATE SET\n")
							.append("					mm.proc_plan_no = mQ.proc_plan_no,\n")
							.append("					mm.production_date = mQ.production_date,\n")
							.append("					mm.bom_cd = mQ.bom_cd,\n")
							.append("					mm.bom_cd_rev = mQ.bom_cd_rev,\n")
							.append("					mm.bom_result_seq = mQ.bom_result_seq,\n")
							.append("					mm.bom_name = mQ.bom_name,\n")
							.append("					mm.sys_bom_id = mQ.sys_bom_id,\n")
							.append("					mm.approval = mQ.approval,\n")
							.append("					mm.part_cd = mQ.part_cd,\n")
							.append("					mm.part_cd_rev = mQ.part_cd_rev,\n")
							.append("					mm.part_nm = mQ.part_nm,\n")
							.append("					mm.part_cnt = mQ.part_cnt,\n")
							.append("					mm.bigo = mQ.bigo,\n")
							.append("					mm.result = mQ.result,\n")
							.append("					mm.member_key = mQ.member_key,\n")
							.append("					mm.unit = mQ.unit,\n")
							.append("					mm.meterage1 = mQ.meterage1,\n")
							.append("					mm.meterage2 = mQ.meterage2,\n")
							.append("					mm.meterage3 = mQ.meterage3,\n")
							.append("					mm.meterage4 = mQ.meterage4,\n")
							.append("					mm.meterage5 = mQ.meterage5,\n")
							.append("					mm.meterage6 = mQ.meterage6,\n")
							.append("					mm.meterage7 = mQ.meterage7,\n")
							.append("					mm.meterage8 = mQ.meterage8,\n")
							.append("					mm.meterage9 = mQ.meterage9,\n")
							.append("					mm.meterage10 = mQ.meterage10\n")
							.append("WHEN NOT MATCHED THEN\n")
							.append("        INSERT  (		mm.proc_plan_no,\n")
							.append("						mm.production_date,\n")
							.append("						mm.bom_cd,\n")
							.append("						mm.bom_cd_rev,\n")
							.append("						mm.bom_result_seq,\n")
							.append("						mm.bom_name,\n")
							.append("						mm.sys_bom_id,\n")
							.append("						mm.approval,\n")
							.append("						mm.part_cd,\n")
							.append("						mm.part_cd_rev,\n")
							.append("						mm.part_nm,\n")
							.append("						mm.part_cnt,\n")
							.append("						mm.bigo,\n")
							.append("						mm.result,\n")
							.append("						mm.member_key,\n")
							.append("						mm.unit,\n")
							.append("						mm.meterage1,\n")
							.append("						mm.meterage2,\n")
							.append("						mm.meterage3,\n")
							.append("						mm.meterage4,\n")
							.append("						mm.meterage5,\n")
							.append("						mm.meterage6,\n")
							.append("						mm.meterage7,\n")
							.append("						mm.meterage8,\n")
							.append("						mm.meterage9,\n")
							.append("						mm.meterage10)\n")
							.append("        VALUES  (		mQ.proc_plan_no,\n")
							.append("						mQ.production_date,\n")
							.append("						mQ.bom_cd,\n")
							.append("						mQ.bom_cd_rev,\n")
							.append("						mQ.bom_result_seq,\n")
							.append("						mQ.bom_name,\n")
							.append("						mQ.sys_bom_id,\n")
							.append("						mQ.approval,\n")
							.append("						mQ.part_cd,\n")
							.append("						mQ.part_cd_rev,\n")
							.append("						mQ.part_nm,\n")
							.append("						mQ.part_cnt,\n")
							.append("						mQ.bigo,\n")
							.append("						mQ.result,\n")
							.append("						mQ.member_key,\n")
							.append("						mQ.unit,\n")
							.append("						mQ.meterage1,\n")
							.append("						mQ.meterage2,\n")
							.append("						mQ.meterage3,\n")
							.append("						mQ.meterage4,\n")
							.append("						mQ.meterage5,\n")
							.append("						mQ.meterage6,\n")
							.append("						mQ.meterage7,\n")
							.append("						mQ.meterage8,\n")
							.append("						mQ.meterage9,\n")
							.append("						mQ.meterage10)\n")
							.toString();
				
				 
//				 // System.out.println(sql.toString());
				resultInt = super.excuteUpdate(con, sql.toString());
				if (resultInt < 0) {
					con.rollback();
					return EventDefine.E_DOEXCUTE_ERROR ;
				}
				String main_action_no="", review_action_no="",confirm_action_no="";//������ ���´�� ����
				main_action_no = gOrderNo;
				
//				if(Queue.setQueue(con,c_paramArray_Detail[0][0],gOrderNo,c_paramArray_Detail[i][3],main_action_no,review_action_no,confirm_action_no)<0) {
//					con.rollback();
//					return EventDefine.E_DOEXCUTE_ERROR ;
//				}
				
			}
			con.commit();
			
			
		} catch(Exception e) {
			LoggingWriter.setLogError("M353S020100E111()","==== SQL ERROR ===="+ e.getMessage() + "\n" + sql.toString());
			e.printStackTrace();
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M353S020100E111()","==== finally ===="+ e.getMessage());
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
	
	
	public int E112(InoutParameter ioParam){

		String sql ="";
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		ApprovalActionNo ActionNo;
		String gOrderNo="";
		try {
			con = JDBCConnectionPool.getConnection();
			con.setAutoCommit(false);
			
    		// insert_update_delete_json.jsp���� �޾ƿ� JSON������ ó��
    		JSONObject jArray = new JSONObject();
    		jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
    		System.out.println("JSONObject jArray rcvData="+ jArray.toString());
    		// Object�����Ϳ��� Ű��(param)���� JSONArray�����͸� ������. (�����͹��� �ϳ��϶� ����)
    		JSONArray jjArray = (JSONArray) jArray.get("param");
    		System.out.println("������ ���� ���� :::: " + jjArray.size());
    		
    		
    		JSONObject jjjArray0 = (JSONObject)jjArray.get(0); // 0��° �����͹���
			
			for(int i=0; i<jjArray.size(); i++) {
				JSONObject jjjArray = (JSONObject)jjArray.get(i); // i��° �����͹���
				//if(jjjArray.get("part_chulgo_date").equals("")) { // ������� ������� ���� ���
					sql = new StringBuilder()
						.append("UPDATE  tbi_order_bomlist_result\n")
						.append("	SET part_cnt='"+jjjArray.get("part_cnt")+"'\n")
						.append("	WHERE order_no ='"+jjjArray.get("order_no")+"' AND part_cd ='"+jjjArray.get("part_cd")+"' AND member_key='"+jjjArray.get("member_key")+"'\n")
						.toString();
								 
//				 // System.out.println(sql.toString());
				resultInt = super.excuteUpdate(con, sql.toString());
				if (resultInt < 0) {
					con.rollback();
					return EventDefine.E_DOEXCUTE_ERROR ;
				}
				String main_action_no="", review_action_no="",confirm_action_no="";//������ ���´�� ����
				main_action_no = gOrderNo;
				
//				if(Queue.setQueue(con,c_paramArray_Detail[0][0],gOrderNo,c_paramArray_Detail[i][3],main_action_no,review_action_no,confirm_action_no)<0) {
//					con.rollback();
//					return EventDefine.E_DOEXCUTE_ERROR ;
//				}
				
			}
			con.commit();
			
			
		} catch(Exception e) {
			LoggingWriter.setLogError("M353S020100E112()","==== SQL ERROR ===="+ e.getMessage() + "\n" + sql.toString());
			e.printStackTrace();
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M353S020100E112()","==== finally ===="+ e.getMessage());
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
	
	public int E114(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			
			String sql = new StringBuilder()
					.append("SELECT\n")
					.append("A.part_cd,\n")
					.append("        A.bom_name,\n")
					.append("        B.part_nm,\n")
					.append("        A.bigo,\n")
					.append("        A.bom_cd,\n")
					.append("        A.part_cnt,\n")
					.append("        A.meterage1,\n")
					.append("        A.meterage2,\n")
					.append("        A.meterage3,\n")
					.append("        A.meterage4,\n")
					.append("        A.meterage5,\n")
					.append("        A.meterage6,\n")
					.append("        A.meterage7,\n")
					.append("        A.meterage8,\n")
					.append("        A.meterage9,\n")
					.append("        A.meterage10\n")
					.append("FROM\n")
					.append("        tbi_order_bomlist_result A\n")
					.append("        INNER JOIN  tbm_part_list B\n")
					.append("         ON A.part_cd = B.part_cd\n")
					.append("        AND A.part_cd_rev = B.revision_no\n")
					.append("        AND A.member_key = B.member_key\n")
					.append("WHERE A.proc_plan_no='"+jArray.get("proc_plan_no") +"'\n")
					.append("	AND A.bom_cd = '"+jArray.get("bom_cd")+"'\n")
					.append("	AND A.bom_cd_rev = '"+jArray.get("bom_cd_rev")+"'\n")
					.append("	AND A.member_key = '"+jArray.get("member_key")+"'\n")
					.toString();

			
			resultString = super.excuteQueryString(con, sql.toString());
			
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M353S020100E114()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M353S020100E114()","==== finally ===="+ e.getMessage());
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

	public int E214(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			System.out.println("JSONObject jArray rcvData="+ jArray.toString());
			
			// Ŭ���̾�Ʈ�� ���� ���� �Ķ���͸� �Ű� ��´�.
//			String rcvData = (String)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			// Ŭ���̾�Ʈ�� ���� ���� �Ķ���͸� �ɰ�� �迭�� ��´�.
			//{ "�����ڵ�", "��������", "�����", "��������", "������", "�Ϸ���", "�����", "���", "���", "SEQ_NO"};
			
//			String[][] c_paramArray = CommonFunction.getConvString2DoubleArray(rcvData);
			String sql = new StringBuilder()
					.append(" SELECT 	\n")
					.append("	 seolbi_cd, \n")
					.append("	 reason_cd, \n")
					.append("	 gigwan_nm, \n")
					.append("	 work_memo, \n")
					.append("	 start_dt,  \n")
					.append("	 end_dt,  	\n")
					.append("	 user_id,  	\n")
					.append("	 TO_CHAR (biyong, '999,999,999,999') AS biyong, \n")
					.append("	 bigo,		\n")
					.append("	 seq_no  	\n")
					.append(" FROM tbi_seolbi_repare \n")
					.append(" WHERE seolbi_cd = '" + jArray.get("sulbi_cd") + "' \n")
					.append(" AND seq_no = '" + jArray.get("seq_no") + "' \n")
					.append(" AND member_key = '" + jArray.get("member_key") + "' \n")
					.toString();
			
			resultString = super.excuteQueryString(con, sql.toString());
			
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M353S020100E214()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M353S020100E214()","==== finally ===="+ e.getMessage());
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

	public int E103(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject(); // JSONObject ����
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
	
			
			String sql = new StringBuilder()
					.append("DELETE FROM tbi_order_bomlist_result \n")
					.append("WHERE proc_plan_no='"+jArray.get("proc_plan_no") +"'\n")
					.append("	AND bom_cd = '"+jArray.get("bom_cd")+"'\n")
					.append("	AND bom_cd_rev = '"+jArray.get("bom_cd_rev")+"'\n")
					.append("	AND member_key = '"+jArray.get("member_key")+"'\n")
					.toString();

			
			// super�� excuteUpdate�� 3������ �ִ�.
			// ù°�� super.excuteUpdate(con, sql.toString(), v_paramArray)���� �̸�,
			// PreparedStatement�� ����ϱ� ���� �Ķ���͵��� �迭�� ��� ������ üũ�� �ؼ� �����ϴ� �����̴�. �׸���
			// �ι�°�� super.excuteUpdate(con, Vector)�ε�, ��Ƽ �ο츦 ����ϱ� ���� ���õ� ��ġ�̴�.
			// ����°�� �ϳ��� SQL�� String���� �޾Ƽ� ó���ϴ� ����̴�.
			// ���� ���� SQL���¶��.. �翬�� 1���� �ο쿡 �ش�ǹǷ� ����° �޽�带 ����ϴ� ���� ���ϴ�.
			resultInt = super.excuteUpdate(con, sql.toString());
			if (resultInt < 0) {
				ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
				return resultInt;
			} else {
				ioParam.setMessage(resultInt + "�� " + MessageDefine.M_INSERT_RESULT);
			}
		} catch(Exception e) {
			LoggingWriter.setLogError("M353S020100E103()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M353S020100E103()","==== finally ===="+ e.getMessage());
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