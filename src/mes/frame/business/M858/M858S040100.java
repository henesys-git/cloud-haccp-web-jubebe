package mes.frame.business.M858;

import java.lang.reflect.Method;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.util.ArrayList;
import java.util.List;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;

import mes.client.conf.Config;
import mes.client.util.ChulhaNumberGenerator;
import mes.frame.common.EventDefine;
import mes.frame.common.HashObject;
import mes.frame.common.MessageDefine;
import mes.frame.database.JDBCConnectionPool;
import mes.frame.database.SqlAdapter;
import mes.frame.serviceinterface.InoutParameter;
import mes.frame.serviceinterface.LoggingWriter;
import mes.frame.util.CommonFunction;


/*
 * ����ǰ ��ǰ ����
 * yumsam
 * */

public class M858S040100 extends SqlAdapter{
	Connection con = null;
	PreparedStatement pstmt = null;
	String resultString = "";
	int resultInt = -1;
	StringBuffer sql = new StringBuffer();
	
	String[][] v_paramArray = new String[0][0]; 
	Class[] optClass = null;
	Object[] optObj = null;
	Object obj = null;
	
	public M858S040100(){
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
			
			Method method = M858S040100.class.getMethod(event,optClass);
			LoggingWriter.setLogDebug(M858S040100.class.getName(),"==== " + event + " EventMethod Create Success ====");

			obj = method.invoke(M858S040100.class.newInstance(),optObj);
			doExcute_result = CommonFunction.getInt(obj.toString());
			
	    } catch (Exception ex) {
	    	doExcute_result = EventDefine.E_DOEXCUTE_INIT;
			ioParam.setMessage(MessageDefine.M_NO_EVENTID);
			LoggingWriter.setLogError(M858S040100.class.getName(),"==== EventID Not define : EVENT ID [ " + ioParam.getEventID() + "]");
	    } finally {
	    	obj = null;
			optClass = null;
			optObj = null;
	    }
	    long endTime = System.currentTimeMillis();
		long runningTime = endTime - startTime;
		LoggingWriter.setLogAll(M858S040100.class.getName(),"==== Query [����ð�  : " + runningTime + " ms]");
		
		return doExcute_result;
	}
	
	// yumsam
	// ��ǰ ���
	public int E101(InoutParameter ioParam) {
		resultInt = EventDefine.E_DOEXCUTE_INIT;

		try {
			con = JDBCConnectionPool.getConnection();
			con.setAutoCommit(false);
			
			JSONObject jObj = new JSONObject();
    		jObj = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			
    		int len = Integer.parseInt(jObj.get("length").toString());
    		
    		for(int i = 0; i < len; i++) {
    			List<String> list = new ArrayList<String>();
    			list = (JSONArray) jObj.get(String.valueOf(i));
    			
    			// ��ǰ Ÿ�� Ȯ�� �� 
    			// 1. ��ǰ�� ���, ��ǰ/��� ���̺� ���� & ����ǰ ��� ���̺� ���� �ݿ�
    			// 2. ����� ���, ��ǰ/��� ���̺� ����
    			
    			String type = list.get(11);
    			
    			if(type.equals("return")) {
    				String sql = new StringBuilder()
        					.append("INSERT INTO\n")
        					.append("	tbi_prod_discard (\n")
        					.append("		chulha_no,\n")
        					.append("		chulha_rev_no,\n")
        					.append("		prod_date,\n")
        					.append("		seq_no,\n")
        					.append("		prod_cd,\n")
        					.append("		prod_rev_no,\n")
        					.append("		discard_type,\n")
        					.append("		amount,\n")
        					.append("		discard_date,\n")
        					.append("		note,\n")
        					.append("		order_no,\n")
        					.append("		order_rev_no \n")
        					.append("	)\n")
        					.append("VALUES\n")
        					.append("	(\n")
        					.append("		'"+list.get(0)+"',\n")
        					.append("		'"+list.get(1)+"',\n")
        					.append("		'"+list.get(2)+"',\n")
        					.append("		'"+list.get(3)+"',\n")
        					.append("		'"+list.get(5)+"',\n")
        					.append("		'"+list.get(6)+"',\n")
        					.append("		'��ǰ',\n")
        					.append("		'"+list.get(10)+"',\n")
        					.append("		SYSDATE,\n")
        					.append("		'"+list.get(12)+"',\n")
        					.append("		'"+list.get(8)+"',\n")
        					.append("		'"+list.get(9)+"'\n")
        					.append("	);\n")
        					.toString();
        			
        			resultInt = super.excuteUpdate(con, sql);
            		if (resultInt < 0) {
        				ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
        				con.rollback();
        				return EventDefine.E_DOEXCUTE_ERROR;
        			}
            		
            		sql = new StringBuilder()
            				.append("UPDATE										\n")
            				.append("	tbi_prod_storage2						\n")
            				.append("SET										\n")
            				.append("	pre_amt = post_amt,						\n")
            				.append("	io_amt = "+list.get(10)+",				\n")
            				.append("	post_amt = post_amt + "+list.get(10)+"	\n")
            				.append("WHERE										\n")
            				.append("	prod_date = '"+list.get(2)+"'			\n")
            				.append("	AND seq_no = "+list.get(3)+"			\n")
            				.append("	AND prod_cd = '"+list.get(5)+"'			\n")
            				.append("	AND prod_rev_no = "+list.get(6)+"		\n")
            				.toString();
            		
            		resultInt = super.excuteUpdate(con, sql);
            		if (resultInt < 0) {
        				ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
        				con.rollback();
        				return EventDefine.E_DOEXCUTE_ERROR;
        			}
            		
            		sql = new StringBuilder()
            				.append("UPDATE tbi_chulha_detail 							\n")
            				.append("SET 												\n")
            				.append("	chulha_count = chulha_count - "+list.get(10)+"	\n")
            				.append("WHERE chulha_no = '"+list.get(0)+"' 				\n")
            				.append("	AND chulha_rev_no = "+list.get(1)+" 			\n")
            				.append("	AND prod_date = '"+list.get(2)+"' 				\n")
            				.append("	AND seq_no = '"+list.get(3)+"' 					\n")
            				.append("	AND prod_cd = '"+list.get(5)+"' 				\n")
            				.append("	AND prod_rev_no = '"+list.get(6)+"';			\n")
            				.toString();
            		
            		resultInt = super.excuteUpdate(con, sql);
            		if (resultInt < 0) {
        				ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
        				con.rollback();
        				return EventDefine.E_DOEXCUTE_ERROR;
        			}
    			} else if(type.equals("discard")) {
    				String sql = new StringBuilder()
        					.append("INSERT INTO\n")
        					.append("	tbi_prod_discard (\n")
        					.append("		chulha_no,\n")
        					.append("		chulha_rev_no,\n")
        					.append("		prod_date,\n")
        					.append("		seq_no,\n")
        					.append("		prod_cd,\n")
        					.append("		prod_rev_no,\n")
        					.append("		discard_type,\n")
        					.append("		amount,\n")
        					.append("		discard_date,\n")
        					.append("		note,\n")
        					.append("		order_no,\n")
        					.append("		order_rev_no \n")
        					.append("	)\n")
        					.append("VALUES\n")
        					.append("	(\n")
        					.append("		'"+list.get(0)+"',\n")
        					.append("		'"+list.get(1)+"',\n")
        					.append("		'"+list.get(2)+"',\n")
        					.append("		'"+list.get(3)+"',\n")
        					.append("		'"+list.get(5)+"',\n")
        					.append("		'"+list.get(6)+"',\n")
        					.append("		'���',\n")
        					.append("		'"+list.get(10)+"',\n")
        					.append("		SYSDATE,\n")
        					.append("		'"+list.get(12)+"',\n")
        					.append("		'"+list.get(8)+"',\n")
        					.append("		'"+list.get(9)+"'\n")
        					.append("	);\n")
        					.toString();
    				
    				resultInt = super.excuteUpdate(con, sql);
            		if (resultInt < 0) {
        				ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
        				con.rollback();
        				return EventDefine.E_DOEXCUTE_ERROR ;
        			}
            		
            		sql = new StringBuilder()
            				.append("UPDATE tbi_chulha_detail 							\n")
            				.append("SET 												\n")
            				.append("	chulha_count = chulha_count - "+list.get(10)+"	\n")
            				.append("WHERE chulha_no = '"+list.get(0)+"' 				\n")
            				.append("	AND chulha_rev_no = "+list.get(1)+" 			\n")
            				.append("	AND prod_date = '"+list.get(2)+"' 				\n")
            				.append("	AND seq_no = '"+list.get(3)+"' 					\n")
            				.append("	AND prod_cd = '"+list.get(5)+"' 				\n")
            				.append("	AND prod_rev_no = '"+list.get(6)+"';			\n")
            				.toString();
            		
            		resultInt = super.excuteUpdate(con, sql);
            		if (resultInt < 0) {
        				ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
        				con.rollback();
        				return EventDefine.E_DOEXCUTE_ERROR ;
        			}
    			}
    		}
		    	
			con.commit();
		} catch(Exception e) {
			LoggingWriter.setLogError("M858S040100E101()","==== SQL ERROR ===="+ e.getMessage());
			e.printStackTrace();
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M858S040100E101()","==== finally ===="+ e.getMessage());
				}
	    	}
	    }
		ioParam.setResultString(resultString);
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
    	ioParam.setMessage(MessageDefine.M_QUERY_OK);
    	System.out.println("E101 ���� ���ϰ�: " + EventDefine.E_QUERY_RESULT);
	    return EventDefine.E_QUERY_RESULT;
	}
	
	
	// yumsam
	// ���� ����
	public int E102(InoutParameter ioParam) {
		resultInt = EventDefine.E_DOEXCUTE_INIT;

		String sql = "";
		
		try {
			con = JDBCConnectionPool.getConnection();
			con.setAutoCommit(false);
			
			JSONObject rcvData = new JSONObject();
    		rcvData = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			
    		JSONObject rcvHead = (JSONObject) rcvData.get("paramHead");
    		JSONArray rcvBody = (JSONArray) rcvData.get("param");
    		
    		sql = new StringBuilder()
				.append("INSERT INTO tbi_chulha (					    \n")
				.append("	chulha_no,								    \n")
				.append("	chulha_rev_no,							    \n")
				.append("	chulha_date,							    \n")
				.append("	order_no,								    \n")
				.append("	order_rev_no,							    \n")
				.append("	note,									    \n")
				.append("	delyn									    \n")
				.append(")											    \n")
				.append("VALUES (									    \n")
				.append("	'" + rcvHead.get("chulhaNo") + "',		    \n")
				.append("	'" + rcvHead.get("chulhaRevNo") + "' + 1,	\n")
				.append("	SYSDATE,								    \n")
				.append("	'" + rcvHead.get("orderNo") + "',		    \n")
				.append("	'" + rcvHead.get("orderRevNo") + "',	    \n")
				.append("	'" + rcvHead.get("chulhaNote") + "',	    \n")
				.append("	'N'										    \n")
				.append(");											    \n")
				.toString();
    		
			resultInt = super.excuteUpdate(con, sql);
    		if (resultInt < 0) {
				ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
				con.rollback();
				return EventDefine.E_DOEXCUTE_ERROR ;
			}
	    		
			for(int i = 0; i < rcvBody.size(); i++) {
				JSONObject eachRow = (JSONObject) rcvBody.get(i); // i��° �����͹���
				
				// ���� ��� - ���� ���
				int setoffChulhaCount = Integer.parseInt((String)eachRow.get("chulhaCount")) 
										- Integer.parseInt((String)eachRow.get("orgChulhaCount"));
				
				sql = new StringBuilder()
					.append("INSERT INTO tbi_chulha_detail (			    \n")
					.append("	chulha_no,								    \n")
					.append("	chulha_rev_no,							    \n")
					.append("	prod_date,								    \n")
					.append("	seq_no,									    \n")
					.append("	prod_cd,								    \n")
					.append("	prod_rev_no,							    \n")
					.append("	chulha_count,							    \n")
					.append("	note									    \n")
					.append(")											    \n")
					.append("VALUES ( 									    \n")
					.append("	'" + rcvHead.get("chulhaNo") + "',		    \n")
					.append("	'" + rcvHead.get("chulhaRevNo") + "' + 1,	\n")
					.append("	'" + eachRow.get("prodDate") + "',		    \n")
					.append("	'" + eachRow.get("seqNo") + "',			    \n")
					.append("	'" + eachRow.get("prodCd") + "',		    \n")
					.append("	'" + eachRow.get("prodRevNo") + "',		    \n")
					.append("	'" + eachRow.get("chulhaCount") + "',	    \n")
					.append("	'" + eachRow.get("note") + "'			    \n")
					.append(");											    \n")
					.toString();
				 
				resultInt = super.excuteUpdate(con, sql);
				if (resultInt < 0) {
					ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
					con.rollback();
					return EventDefine.E_DOEXCUTE_ERROR ;
				}
				
				sql = new StringBuilder()
	    				.append("INSERT INTO tbi_prod_chulgo2 (			\n")
	    				.append("	prod_date,							\n")
	    				.append("	seq_no,								\n")
	    				.append("	prod_cd,							\n")
	    				.append("	prod_rev_no,						\n")
	    				.append("	chulgo_date,						\n")
	    				.append("	chulgo_time,						\n")
	    				.append("	chulgo_amount,						\n")
	    				.append("	note								\n")
	    				.append(")										\n")
	    				.append("VALUES (								\n")
	    				.append("	'"+eachRow.get("prodDate")+"',		\n")
	    				.append("	"+eachRow.get("seqNo")+",			\n")
	    				.append("	'"+eachRow.get("prodCd")+"',		\n")
	    				.append("	"+eachRow.get("prodRevNo")+",		\n")
	    				.append("	SYSDATE,							\n")
	    				.append("	SYSTIME,							\n")
	    				.append("	"+setoffChulhaCount+",				\n")
	    				.append("	'������'								\n")
	    				.append(");										\n")
	    				.toString();
        		
    	    	resultInt = super.excuteUpdate(con, sql);
    	    	if (resultInt < 0) {
    				ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
    				con.rollback();
    				return EventDefine.E_DOEXCUTE_ERROR;
    			}
    	    	
    	    	sql = new StringBuilder()
	    				.append("UPDATE tbi_prod_storage2							\n")
	    				.append("SET 												\n")
	    				.append("	pre_amt = "+eachRow.get("chulhaCount")+",		\n")
	    				.append("	io_amt = "+setoffChulhaCount+",					\n")
	    				.append("	post_amt = post_amt + "+setoffChulhaCount+"		\n")
	    				.append("WHERE prod_date = '"+eachRow.get("prodDate")+"'	\n")
	    				.append("  AND seq_no = "+eachRow.get("seqNo")+"			\n")
	    				.append("  AND prod_cd = '"+eachRow.get("prodCd")+"'		\n")
	    				.append("  AND prod_rev_no = "+eachRow.get("prodRevNo")+"	\n")
	    				.toString();

				resultInt = super.excuteUpdate(con, sql);
	    		if (resultInt < 0) {
					ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
					con.rollback();
					return EventDefine.E_DOEXCUTE_ERROR;
				}
			}
		    	
			con.commit();
		} catch(Exception e) {
			LoggingWriter.setLogError("M858S040100E102()","==== SQL ERROR ===="+ e.getMessage());
			e.printStackTrace();
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M858S040100E102()","==== finally ===="+ e.getMessage());
				}
	    	}
	    }
		ioParam.setResultString(resultString);
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
    	ioParam.setMessage(MessageDefine.M_QUERY_OK);
    	System.out.println("E102 ���� ���ϰ�: " + EventDefine.E_QUERY_RESULT);
	    return EventDefine.E_QUERY_RESULT;
	}

	// yumsam
	// ���� ����
	public int E103(InoutParameter ioParam) {
		resultInt = EventDefine.E_DOEXCUTE_INIT;

		String sql = "";
		
		try {
			con = JDBCConnectionPool.getConnection();
			con.setAutoCommit(false);
			
			JSONObject rcvData = new JSONObject();
    		rcvData = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			
    		JSONObject rcvHead = (JSONObject) rcvData.get("paramHead");
    		JSONArray rcvBody = (JSONArray) rcvData.get("param");
    		
    		sql = new StringBuilder()
    				.append("INSERT INTO tbi_order2( 								\n")
    				.append("  order_no,											\n")
    				.append("  order_rev_no,										\n")
    				.append("  order_date,											\n")
    				.append("  delivery_date,										\n")
    				.append("  delivery_yn,											\n")
    				.append("  note,												\n")
    				.append("  cust_cd,												\n")
    				.append("  cust_rev_no,											\n")
    				.append("  delyn												\n")
    				.append(")														\n")
    				.append("VALUES( 												\n")
    				.append(" '"+ rcvHead.get("orderNo") +"',    					\n")
    				.append(" "+ rcvHead.get("orderRevNo") +" + 1,    				\n")
    				.append(" '"+ rcvHead.get("orderDate") +"',    					\n")
    				.append(" '"+ rcvHead.get("deliveryDate") +"',    				\n")
    				.append(" 'N',			    									\n")
    				.append(" '"+ rcvHead.get("orderNote") +"', 					\n")
    				.append(" '"+ rcvHead.get("custCd") +"', 						\n")
    				.append(" '"+ rcvHead.get("custRevNo") +"', 					\n")
    				.append(" 'N'			   										\n")
    				.append(");   													\n")
    				.toString();

    			resultInt = super.excuteUpdate(con, sql);
        		if (resultInt < 0) {
    				ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
    				con.rollback();
    		    	System.out.println("E103 ���� ���ϰ�: " + EventDefine.E_DOEXCUTE_ERROR);
    				return EventDefine.E_DOEXCUTE_ERROR ;
    			}
    		
			for(int i = 0; i < rcvBody.size(); i++) {
				JSONObject eachRow = (JSONObject) rcvBody.get(i); // i��° �����͹���
				
				// ���� ��� - ���� ��� (�����ϸ� 0�̴� ���� ����� 0���� �Ѵ�)
				int setoffChulhaCount = 0 - Integer.parseInt((String)eachRow.get("chulhaCount"));
				
				sql = new StringBuilder()
	    				.append("INSERT INTO tbi_prod_chulgo2 (			\n")
	    				.append("	prod_date,							\n")
	    				.append("	seq_no,								\n")
	    				.append("	prod_cd,							\n")
	    				.append("	prod_rev_no,						\n")
	    				.append("	chulgo_date,						\n")
	    				.append("	chulgo_time,						\n")
	    				.append("	chulgo_amount,						\n")
	    				.append("	note								\n")
	    				.append(")										\n")
	    				.append("VALUES (								\n")
	    				.append("	'"+eachRow.get("prodDate")+"',		\n")
	    				.append("	"+eachRow.get("seqNo")+",			\n")
	    				.append("	'"+eachRow.get("prodCd")+"',		\n")
	    				.append("	"+eachRow.get("prodRevNo")+",		\n")
	    				.append("	SYSDATE,							\n")
	    				.append("	SYSTIME,							\n")
	    				.append("	"+setoffChulhaCount+",				\n")
	    				.append("	'���ϻ���'								\n")
	    				.append(");										\n")
	    				.toString();
	        		
	    	    	resultInt = super.excuteUpdate(con, sql);
	    	    	if (resultInt < 0) {
	    				ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
	    				con.rollback();
	    				return EventDefine.E_DOEXCUTE_ERROR;
	    			}
				
	    		sql = new StringBuilder()
    				.append("UPDATE tbi_prod_storage2									\n")
    				.append("SET 														\n")
    				.append("	pre_amt = post_amt,										\n")
    				.append("	io_amt = "+eachRow.get("chulhaCount")+",				\n")
    				.append("	post_amt = post_amt + "+eachRow.get("chulhaCount")+"  	\n")
    				.append("WHERE prod_date = '"+eachRow.get("prodDate")+"'			\n")
    				.append("  AND seq_no = "+eachRow.get("seqNo")+"					\n")
    				.append("  AND prod_cd = '"+eachRow.get("prodCd")+"'				\n")
    				.append("  AND prod_rev_no = "+eachRow.get("prodRevNo")+"			\n")
    				.toString();

				resultInt = super.excuteUpdate(con, sql);
	    		if (resultInt < 0) {
					ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
					con.rollback();
					return EventDefine.E_DOEXCUTE_ERROR;
				}
	    		
	    		sql = new StringBuilder()
	    				.append("DELETE FROM tbi_chulha_detail						\n")
	    				.append("WHERE prod_date = '"+eachRow.get("prodDate")+"'	\n")
	    				.append("  AND seq_no = "+eachRow.get("seqNo")+"			\n")
	    				.append("  AND prod_cd = '"+eachRow.get("prodCd")+"'		\n")
	    				.append("  AND prod_rev_no = "+eachRow.get("prodRevNo")+"	\n")
	    				.append("  AND chulha_no = "+ rcvHead.get("chulhaNo") +"	\n")
	    				.toString();

				resultInt = super.excuteUpdate(con, sql);
	    		if (resultInt < 0) {
					ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
					con.rollback();
					return EventDefine.E_DOEXCUTE_ERROR;
				}
    	    	
			}
			
			sql = new StringBuilder()
	    			.append("UPDATE tbi_chulha 									\n")
	    			.append("SET delyn = 'Y'  									\n")
	    			.append("WHERE chulha_no = '"+rcvHead.get("chulhaNo")+"' 	\n")
	    			.append("AND order_no = "+rcvHead.get("orderNo")+"   		\n")
	    			.toString();
        		
	    	resultInt = super.excuteUpdate(con, sql);
	    	if (resultInt < 0) {
				ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
				con.rollback();
				return EventDefine.E_DOEXCUTE_ERROR;
			}
			
			con.commit();
		} catch(Exception e) {
			LoggingWriter.setLogError("M858S040100E103()","==== SQL ERROR ===="+ e.getMessage());
			e.printStackTrace();
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M858S040100E103()","==== finally ===="+ e.getMessage());
				}
	    	}
	    }
		ioParam.setResultString(resultString);
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
    	ioParam.setMessage(MessageDefine.M_QUERY_OK);
    	System.out.println("E103 ���� ���ϰ�: " + EventDefine.E_QUERY_RESULT);
	    return EventDefine.E_QUERY_RESULT;
	}
	
	// ��ǰ ���� ��ȸ
	public int E104(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArr = new JSONObject();
			jArr = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			
			String sql = new StringBuilder()
					.append("SELECT DISTINCT						\n")
					.append("	a.discard_type,						\n")
					.append("	a.discard_seq_no,					\n")
					.append("	a.discard_date,						\n")
					.append("	e.cust_nm,							\n")
					.append("	b.product_nm,						\n")
					.append("	a.amount,							\n")
					.append("	a.prod_date,						\n")
					.append("	a.note,								\n")
					.append("	a.chulha_no,						\n")
					.append("	a.chulha_rev_no,					\n")
					.append("	a.seq_no,							\n")
					.append("	a.prod_cd,							\n")
					.append("	a.prod_rev_no,						\n")
					.append("	a.order_no,							\n")
					.append("	a.order_rev_no						\n")
					.append("FROM									\n")
					.append("	tbi_prod_discard a					\n")
					.append("INNER JOIN tbm_product b				\n")
					.append("	ON a.prod_cd = b.prod_cd			\n")
					.append("	AND a.prod_rev_no = b.revision_no	\n")
					.append("INNER JOIN tbi_chulha_detail c			\n")
					.append("	ON a.chulha_no = c.chulha_no		\n")
					.append("	AND a.chulha_rev_no = c.chulha_rev_no\n")
					.append("INNER JOIN tbi_order2 d				\n")
					.append("	ON a.order_no = d.order_no			\n")
					.append("	AND a.order_rev_no = d.order_rev_no	\n")
					.append("INNER JOIN tbm_customer e				\n")
					.append("	ON d.cust_cd = e.cust_cd			\n")
					.append("	AND d.cust_rev_no = e.revision_no	\n")
					.append("WHERE									\n")
					.append("	a.discard_date BETWEEN '"+jArr.get("startDate")+"'	\n")
					.append("					   AND '"+jArr.get("endDate")+"'	\n")
					.append("GROUP BY a.discard_seq_no				\n")
					.append("ORDER BY discard_date DESC				\n")
					.toString();

			resultString = super.excuteQueryString(con, sql);
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M858S040100E104()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M858S040100E104()","==== finally ===="+ e.getMessage());
				}
	    	}
	    }
		ioParam.setResultString(resultString);
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
    	ioParam.setMessage(MessageDefine.M_QUERY_OK);
	    return EventDefine.E_QUERY_RESULT;
	}
	
	// ���� �� ���� ��ȸ
	public int E114(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArr = new JSONObject();
			jArr = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			
			String sql = new StringBuilder()
					.append("SELECT 												\n")
					.append("	A.prod_date,										\n")
					.append("	C.product_nm,										\n")
					.append("	A.prod_cd,											\n")
					.append("	A.prod_rev_no,										\n")
					.append("	A.chulha_count,										\n")
					.append("	A.note												\n")
					.append("FROM tbi_chulha_detail A								\n")
					.append("INNER JOIN tbi_chulha B								\n")
					.append("	ON A.chulha_no = B.chulha_no						\n")
					.append("	AND A.chulha_rev_no = B.chulha_rev_no				\n")
					.append("INNER JOIN tbm_product C								\n")
					.append("	ON A.prod_cd = C.prod_cd							\n")
					.append("	AND A.prod_rev_no = C.revision_no					\n")
					.append("WHERE A.chulha_no = '"+jArr.get("chulhaNo")+"'			\n")
					.append("AND A.chulha_rev_no = (SELECT MAX(chulha_rev_no)       \n")
					.append("       				FROM tbi_chulha_detail D        \n")
					.append("      					WHERE A.prod_cd = D.prod_cd 	\n")
					.append("      					AND A.chulha_no = D.chulha_no   \n")
					.append("      					AND A.prod_rev_no = D.prod_rev_no) \n")
					.toString();

			String ActionCommand = ioParam.getActionCommand();
			if(ActionCommand.startsWith("doQueryTableFieldName")) {
				resultString = super.excuteQueryStringTableFieldName(con, sql);
			} else {
				resultString = super.excuteQueryString(con, sql);
			}
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M858S040100E114()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M858S040100E114()","==== finally ===="+ e.getMessage());
				}
	    	}
	    }
		ioParam.setResultString(resultString);
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
    	ioParam.setMessage(MessageDefine.M_QUERY_OK);
	    return EventDefine.E_QUERY_RESULT;
	}
	
	// ����ǰ ���� �󼼳��� ��ȸ
	public int E124(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArr = new JSONObject();
			jArr = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			
			String sql = new StringBuilder()
					.append("SELECT\n")
					.append("	a.chulha_no,\n")
					.append("	a.chulha_rev_no,\n")
					.append("	a.prod_date,\n")
					.append("	a.seq_no,\n")
					.append("	b.product_nm,\n")
					.append("	a.prod_cd,\n")
					.append("	a.prod_rev_no,\n")
					.append("	a.chulha_count,\n")
					.append("	a.order_no,\n")
					.append("	a.order_rev_no,\n")
					.append("	a.note\n")
					.append("FROM\n")
					.append("	tbi_chulha_detail a\n")
					.append("INNER JOIN tbm_product b\n")
					.append("	ON a.prod_cd = b.prod_cd\n")
					.append("  AND a.prod_rev_no = b.revision_no\n")
					.append("WHERE a.chulha_no = '"+jArr.get("chulha_no")+"'\n")
					.append("  AND a.chulha_rev_no = '"+jArr.get("chulha_rev_no")+"'\n")
					.append("  AND a.order_no = '"+jArr.get("order_no")+"'\n")
					.append("  AND a.order_rev_no = '"+jArr.get("order_rev_no")+"'\n")
					.append("  AND a.chulha_count > 0 								\n")
					.append(";\n")
					.toString();

			resultString = super.excuteQueryString(con, sql);
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M858S040100E124()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M858S040100E124()","==== finally ===="+ e.getMessage());
				}
	    	}
	    }
		ioParam.setResultString(resultString);
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
    	ioParam.setMessage(MessageDefine.M_QUERY_OK);
	    return EventDefine.E_QUERY_RESULT;
	}
	
	// ���� �� ���� (����ǰ ����Ʈ) ��ȸ
	public int E134(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArr = new JSONObject();
			jArr = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			
			String sql = new StringBuilder()
					.append("SELECT 											\n")
					.append("   B.product_nm, 									\n")
					.append("   A.prod_date, 									\n")
					.append("   A.seq_no, 										\n")
					.append("   A.prod_cd, 										\n")
					.append("   A.prod_rev_no, 									\n")
					.append("   A.chulha_count, 								\n")
					.append("   A.note     										\n")
					.append("FROM tbi_chulha_detail A  							\n")
					.append("INNER JOIN tbm_product B  							\n")
					.append("	ON A.prod_cd = B.prod_cd						\n")
					.append("	AND A.prod_rev_no = B.revision_no				\n")
					.append("WHERE chulha_no = '"+jArr.get("chulhaNo")+"'		\n")
					.append("AND A.chulha_rev_no = (SELECT MAX(chulha_rev_no)       \n")
					.append("       				FROM tbi_chulha_detail D        \n")
					.append("      					WHERE A.prod_cd = D.prod_cd 	\n")
					.append("      					AND A.chulha_no = D.chulha_no   \n")
					.append("      					AND A.prod_rev_no = D.prod_rev_no) \n")
					.toString();

			String ActionCommand = ioParam.getActionCommand();
			if(ActionCommand.startsWith("doQueryTableFieldName")) {
				resultString = super.excuteQueryStringTableFieldName(con, sql);
			} else {
				resultString = super.excuteQueryString(con, sql);
			}
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M858S040100E124()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M858S040100E124()","==== finally ===="+ e.getMessage());
				}
	    	}
	    }
		ioParam.setResultString(resultString);
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
    	ioParam.setMessage(MessageDefine.M_QUERY_OK);
	    return EventDefine.E_QUERY_RESULT;
	}
	
	// yumsam
	// ��ǰ���� - ��ǰ ����
	public int E202(InoutParameter ioParam) {
		resultInt = EventDefine.E_DOEXCUTE_INIT;

		String sql = "";
		
		try {
			con = JDBCConnectionPool.getConnection();
			con.setAutoCommit(false);
			
			JSONObject jObj = new JSONObject();
    		jObj = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			
    		int modified_amount = Integer.parseInt(jObj.get("modified_amount").toString());	// ����� ����
    		int amount = Integer.parseInt(jObj.get("amount").toString());					// ���� ����
    		int io_amt = modified_amount - amount;											// ����� ���� - ��������
    		
    		sql = new StringBuilder()
				.append("UPDATE													\n")
				.append("	tbi_prod_storage2									\n")
				.append("SET													\n")
				.append("	pre_amt = post_amt,									\n")
				.append("	io_amt = " + io_amt + ",							\n")
				.append("	post_amt = post_amt + " + io_amt + "				\n")
				.append("WHERE													\n")
				.append("	prod_date = '" + jObj.get("prod_date") + "'			\n")
				.append("	AND seq_no = " + jObj.get("seq_no") + "				\n")
				.append("	AND prod_cd = '" + jObj.get("prod_cd") + "'			\n")
				.append("	AND prod_rev_no = " + jObj.get("prod_rev_no") + "	\n")
				.toString();
    		
			resultInt = super.excuteUpdate(con, sql);
    		if (resultInt < 0) {
				ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
				con.rollback();
				return EventDefine.E_DOEXCUTE_ERROR ;
			}
	    		
    		sql = new StringBuilder()
				.append("UPDATE														\n")
				.append("	tbi_prod_discard										\n")
				.append("SET														\n")
				.append("	amount = " + modified_amount + "						\n")
				.append("WHERE														\n")
				.append("	discard_type = '" + jObj.get("discard_type") + "'		\n")
				.append("	AND discard_seq_no = " + jObj.get("discard_seq_no") + "	\n")
				.toString();
        		
			resultInt = super.excuteUpdate(con, sql);
    		if (resultInt < 0) {
				ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
				con.rollback();
				return EventDefine.E_DOEXCUTE_ERROR ;
			}
    		
    		sql = new StringBuilder()
    				.append("UPDATE														\n")
    				.append("	tbi_chulha_detail										\n")
    				.append("SET														\n")
    				.append("	chulha_count = chulha_count - " + io_amt + "			\n")
    				.append("WHERE														\n")
    				.append("	chulha_no = '" + jObj.get("chulha_no") + "'				\n")
    				.append("	AND chulha_rev_no = '" + jObj.get("chulha_rev_no") + "'	\n")
    				.append("	AND prod_date = '" + jObj.get("prod_date") + "'			\n")
    				.append("	AND seq_no = " + jObj.get("seq_no") + "					\n")
    				.append("	AND prod_cd = '" + jObj.get("prod_cd") + "'				\n")
    				.append("	AND prod_rev_no = " + jObj.get("prod_rev_no") + "		\n")
    				.toString();
		    
    		resultInt = super.excuteUpdate(con, sql);
    		if (resultInt < 0) {
				ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
				con.rollback();
				return EventDefine.E_DOEXCUTE_ERROR ;
			}
    		
			con.commit();
		} catch(Exception e) {
			LoggingWriter.setLogError("M858S040100E202()","==== SQL ERROR ===="+ e.getMessage());
			e.printStackTrace();
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M858S040100E202()","==== finally ===="+ e.getMessage());
				}
	    	}
	    }
		ioParam.setResultString(resultString);
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
    	ioParam.setMessage(MessageDefine.M_QUERY_OK);
    	System.out.println("E202 ���� ���ϰ�: " + EventDefine.E_QUERY_RESULT);
	    return EventDefine.E_QUERY_RESULT;
	}
	
	// yumsam
	// ��ǰ���� - ��� ����
	public int E212(InoutParameter ioParam) {
		resultInt = EventDefine.E_DOEXCUTE_INIT;

		try {
			con = JDBCConnectionPool.getConnection();
			con.setAutoCommit(false);
			
			JSONObject jObj = new JSONObject();
    		jObj = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			
    		int modified_amount = Integer.parseInt(jObj.get("modified_amount").toString());
    		int amount = Integer.parseInt(jObj.get("amount").toString());
    		int io_amt = modified_amount - amount;
    		
    		String sql = new StringBuilder()
				.append("UPDATE														\n")
				.append("	tbi_prod_discard										\n")
				.append("SET														\n")
				.append("	amount = " + jObj.get("modified_amount") + "			\n")
				.append("WHERE														\n")
				.append("	discard_type = '" + jObj.get("discard_type") + "'		\n")
				.append("	AND discard_seq_no = " + jObj.get("discard_seq_no") + "	\n")
				.toString();
        		
			resultInt = super.excuteUpdate(con, sql);
    		if (resultInt < 0) {
				ioParam.setMessage(MessageDefine.M_UPDATE_FAILED);
				con.rollback();
				return EventDefine.E_DOEXCUTE_ERROR ;
			}
		    
    		sql = new StringBuilder()
    				.append("UPDATE														\n")
    				.append("	tbi_chulha_detail										\n")
    				.append("SET														\n")
    				.append("	chulha_count = chulha_count - " + io_amt + "			\n")
    				.append("WHERE														\n")
    				.append("	chulha_no = '" + jObj.get("chulha_no") + "'				\n")
    				.append("	AND chulha_rev_no = '" + jObj.get("chulha_rev_no") + "'	\n")
    				.append("	AND prod_date = '" + jObj.get("prod_date") + "'			\n")
    				.append("	AND seq_no = " + jObj.get("seq_no") + "					\n")
    				.append("	AND prod_cd = '" + jObj.get("prod_cd") + "'				\n")
    				.append("	AND prod_rev_no = " + jObj.get("prod_rev_no") + "		\n")
    				.toString();
		    
    		resultInt = super.excuteUpdate(con, sql);
    		if (resultInt < 0) {
				ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
				con.rollback();
				return EventDefine.E_DOEXCUTE_ERROR ;
			}
    		
			con.commit();
		} catch(Exception e) {
			LoggingWriter.setLogError("M858S040100E222()","==== SQL ERROR ===="+ e.getMessage());
			e.printStackTrace();
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M858S040100E222()","==== finally ===="+ e.getMessage());
				}
	    	}
	    }
		ioParam.setResultString(resultString);
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
    	ioParam.setMessage(MessageDefine.M_QUERY_OK);
    	System.out.println("E222 ���� ���ϰ�: " + EventDefine.E_QUERY_RESULT);
	    return EventDefine.E_QUERY_RESULT;
	}
	
	// ��ǰ���� ���� �� �ʱ� ������ ��ȸ
	public int E204(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArr = new JSONObject();
			jArr = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			
			String sql = new StringBuilder()
					.append("SELECT										\n")
					.append("	a.discard_type,							\n")
					.append("	a.discard_seq_no,						\n")
					.append("	b.product_nm,							\n")
					.append("	a.prod_cd,								\n")
					.append("	a.prod_rev_no,							\n")
					.append("	a.discard_date,							\n")
					.append("	a.amount,				--������ǰ����		\n")
					.append("	0 as amount_modify,		--�����ɹ�ǰ����		\n")
					.append("	a.note,									\n")
					.append("	a.chulha_no,							\n")
					.append("	a.chulha_rev_no,						\n")
					.append("	a.prod_date,							\n")
					.append("	a.seq_no,				--����Ϸù�ȣ		\n")
					.append("	c.chulha_count,			--���Ϸ�			\n")
					.append("	d.post_amt				--�����			\n")
					.append("FROM										\n")
					.append("	tbi_prod_discard a						\n")
					.append("INNER JOIN tbm_product b					\n")
					.append("	ON a.prod_cd = b.prod_cd				\n")
					.append("	AND a.prod_rev_no = b.revision_no		\n")
					.append("INNER JOIN tbi_chulha_detail c				\n")
					.append("	ON a.chulha_no = c.chulha_no			\n")
					.append("	AND a.chulha_rev_no = c.chulha_rev_no	\n")
					.append("	AND a.prod_date = c.prod_date			\n")
					.append("	AND a.seq_no = c.seq_no					\n")
					.append("	AND a.prod_cd = c.prod_cd				\n")
					.append("	AND a.prod_rev_no = c.prod_rev_no		\n")
					.append("INNER JOIN tbi_prod_storage2 d				\n")
					.append("	ON a.prod_date = d.prod_date			\n")
					.append("	AND a.seq_no = d.seq_no					\n")
					.append("	AND a.prod_cd = d.prod_cd				\n")
					.append("	AND a.prod_rev_no = d.prod_rev_no		\n")
					.append("WHERE A.discard_seq_no = '"+jArr.get("discard_seq_no")+"'\n")
					.toString();

			resultString = super.excuteQueryString(con, sql);
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M858S040100E204()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M858S040100E204()","==== finally ===="+ e.getMessage());
				}
	    	}
	    }
		ioParam.setResultString(resultString);
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
    	ioParam.setMessage(MessageDefine.M_QUERY_OK);
	    return EventDefine.E_QUERY_RESULT;
	}
		
	// yumsam
	// ��ǰ���� ����
	public int E203(InoutParameter ioParam) {
		resultInt = EventDefine.E_DOEXCUTE_INIT;

		String sql = "";
		
		try {
			con = JDBCConnectionPool.getConnection();
			con.setAutoCommit(false);
			
			JSONObject jObj = new JSONObject();
    		jObj = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			
    		// ��ǰ ����
    		int amount = Integer.parseInt(jObj.get("amount").toString());
    		
    		sql = new StringBuilder()
				.append("UPDATE													\n")
				.append("	tbi_prod_storage2									\n")
				.append("SET													\n")
				.append("	pre_amt = post_amt,									\n")
				.append("	io_amt = " + amount + ",							\n")
				.append("	post_amt = post_amt - " + amount + "				\n")
				.append("WHERE													\n")
				.append("	prod_date = '" + jObj.get("prod_date") + "'			\n")
				.append("	AND seq_no = " + jObj.get("seq_no") + "				\n")
				.append("	AND prod_cd = '" + jObj.get("prod_cd") + "'			\n")
				.append("	AND prod_rev_no = " + jObj.get("prod_rev_no") + "	\n")
				.toString();
    		
			resultInt = super.excuteUpdate(con, sql);
    		if (resultInt < 0) {
				ioParam.setMessage(MessageDefine.M_UPDATE_FAILED);
				con.rollback();
				return EventDefine.E_DOEXCUTE_ERROR;
			}
	    	
    		sql = new StringBuilder()
				.append("DELETE FROM												\n")
				.append("	tbi_prod_discard										\n")
				.append("WHERE														\n")
				.append("	discard_type = '" + jObj.get("discard_type") + "'		\n")
				.append("	AND discard_seq_no = " + jObj.get("discard_seq_no") + "	\n")
				.toString();
        		
			resultInt = super.excuteUpdate(con, sql);
    		if (resultInt < 0) {
				ioParam.setMessage(MessageDefine.M_UPDATE_FAILED);
				con.rollback();
				return EventDefine.E_DOEXCUTE_ERROR ;
			}
    		
    		sql = new StringBuilder()
    				.append("UPDATE														\n")
    				.append("	tbi_chulha_detail										\n")
    				.append("SET														\n")
    				.append("	chulha_count = chulha_count + " + amount + "			\n")
    				.append("WHERE														\n")
    				.append("	chulha_no = '" + jObj.get("chulha_no") + "'				\n")
    				.append("	AND chulha_rev_no = '" + jObj.get("chulha_rev_no") + "'	\n")
    				.append("	AND prod_date = '" + jObj.get("prod_date") + "'			\n")
    				.append("	AND seq_no = " + jObj.get("seq_no") + "					\n")
    				.append("	AND prod_cd = '" + jObj.get("prod_cd") + "'				\n")
    				.append("	AND prod_rev_no = " + jObj.get("prod_rev_no") + "		\n")
    				.toString();
		    
    		resultInt = super.excuteUpdate(con, sql);
    		if (resultInt < 0) {
				ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
				con.rollback();
				return EventDefine.E_DOEXCUTE_ERROR ;
			}
		    	
			con.commit();
		} catch(Exception e) {
			LoggingWriter.setLogError("M858S040100E203()","==== SQL ERROR ===="+ e.getMessage());
			e.printStackTrace();
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M858S040100E203()","==== finally ===="+ e.getMessage());
				}
	    	}
	    }
		ioParam.setResultString(resultString);
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
    	ioParam.setMessage(MessageDefine.M_QUERY_OK);
    	System.out.println("E203 ���� ���ϰ�: " + EventDefine.E_QUERY_RESULT);
	    return EventDefine.E_QUERY_RESULT;
	}	
		
	// yumsam
	// ������� ����
	public int E213(InoutParameter ioParam) {
		resultInt = EventDefine.E_DOEXCUTE_INIT;

		String sql = "";
		
		try {
			con = JDBCConnectionPool.getConnection();
			con.setAutoCommit(false);
			
			JSONObject jObj = new JSONObject();
    		jObj = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			
    		// ��� ����
    		int amount = Integer.parseInt(jObj.get("amount").toString());
    		
    		sql = new StringBuilder()
				.append("DELETE FROM												\n")
				.append("	tbi_prod_discard										\n")
				.append("WHERE														\n")
				.append("	discard_type = '" + jObj.get("discard_type") + "'		\n")
				.append("	AND discard_seq_no = " + jObj.get("discard_seq_no") + "	\n")
				.toString();
        		
			resultInt = super.excuteUpdate(con, sql);
    		if (resultInt < 0) {
				ioParam.setMessage(MessageDefine.M_UPDATE_FAILED);
				con.rollback();
				return EventDefine.E_DOEXCUTE_ERROR ;
			}
	    	
    		sql = new StringBuilder()
    				.append("UPDATE														\n")
    				.append("	tbi_chulha_detail										\n")
    				.append("SET														\n")
    				.append("	chulha_count = chulha_count + " + amount + "			\n")
    				.append("WHERE														\n")
    				.append("	chulha_no = '" + jObj.get("chulha_no") + "'				\n")
    				.append("	AND chulha_rev_no = '" + jObj.get("chulha_rev_no") + "'	\n")
    				.append("	AND prod_date = '" + jObj.get("prod_date") + "'			\n")
    				.append("	AND seq_no = " + jObj.get("seq_no") + "					\n")
    				.append("	AND prod_cd = '" + jObj.get("prod_cd") + "'				\n")
    				.append("	AND prod_rev_no = " + jObj.get("prod_rev_no") + "		\n")
    				.toString();
		    
    		resultInt = super.excuteUpdate(con, sql);
    		if (resultInt < 0) {
				ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
				con.rollback();
				return EventDefine.E_DOEXCUTE_ERROR ;
			}
    		
			con.commit();
		} catch(Exception e) {
			LoggingWriter.setLogError("M858S040100E213()","==== SQL ERROR ===="+ e.getMessage());
			e.printStackTrace();
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M858S040100E213()","==== finally ===="+ e.getMessage());
				}
	    	}
	    }
		ioParam.setResultString(resultString);
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
    	ioParam.setMessage(MessageDefine.M_QUERY_OK);
    	System.out.println("E213 ���� ���ϰ�: " + EventDefine.E_QUERY_RESULT);
	    return EventDefine.E_QUERY_RESULT;
	}	
		
	
	
	
	
	/* 
	 * 
	 * 
	 * 
	 * 
	 * 
	 * 
	 * �Ʒ��� ������ ������ �� ������, 
	 * M858S010300���� �Űܾ��� �� 
	 * 
	 * 
	 * 
	 * 
	 * 
	 * 
	 * 
	 * */
	
	
	
	//������ ���ó���κ�
	public int E301(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject(); // JSONObject ����
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			
			
			sql = new StringBuffer();
			sql.append(" insert into tbi_seolbi_repare ( 		\n");
			sql.append(" 		seolbi_cd						\n"); 
			sql.append(" 		,seq_no							\n"); 
			sql.append(" 		,reason_cd						\n"); 
			sql.append(" 		,start_dt						\n"); 
			sql.append(" 		,end_dt							\n"); 
			sql.append(" 		,user_id						\n"); 
			sql.append(" 		,biyong							\n"); 
			sql.append(" 		,gigwan_nm						\n"); 
			sql.append(" 		,work_memo						\n"); 
			sql.append(" 		,bigo							\n"); 
			sql.append(" 		,member_key						\n"); // sql.member_key_insert
			sql.append(" 	) values ( 							\n");
			sql.append(" 		'" + jArray.get("seolbi_code") + "' 	\n"); 	//seolbi_cd
			sql.append(" 		,(select coalesce(max(seq_no),0)+1 from tbi_seolbi_repare where \n"); 	//sys_bom_id
			sql.append(" 		 	seolbi_cd='" + jArray.get("seolbi_code") + "') \n");
			sql.append(" 		,'" + jArray.get("job_gubun") + "' 	\n"); 	//reason_cd
			sql.append(" 		,'" + jArray.get("start_date") + "' \n"); 	//start_dt
			sql.append(" 		,'" + jArray.get("end_date") + "'	\n"); 	//end_dt
			sql.append(" 		,'" + jArray.get("damdangja") + "' 	\n"); 	//user_id
			sql.append(" 		,'" + jArray.get("biyong") + "' 	\n"); 	//biyong
			sql.append(" 		,'" + jArray.get("gigwan_name") + "'\n"); 	//gigwan_nm
			sql.append(" 		,'" + jArray.get("work_memo") + "' \n"); 	//work_memo
			sql.append(" 		,'" + jArray.get("bigo") + "'		\n"); 	//bigo
			sql.append(" 		,'" + jArray.get("member_key") + "' \n"); // sql.member_key_values
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
			LoggingWriter.setLogError("M858S040100E301()","==== SQL ERROR ===="+ e.getMessage() + "\n" + sql.toString());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M858S040100E301()","==== finally ===="+ e.getMessage());
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

	public int E302(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject(); // JSONObject ����
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));

			sql = new StringBuffer();
			sql.append(" update tbi_seolbi_repare set 						\n");
			sql.append(" 	reason_cd = 	'" + jArray.get("job_gubun") + "'	\n"); 
			sql.append(" 	,start_dt = 	'" + jArray.get("start_date") + "'	\n"); 
			sql.append(" 	,end_dt = 		'" + jArray.get("end_date") + "'	\n"); 
			sql.append(" 	,user_id = 		'" + jArray.get("damdangja") + "'	\n"); 
			sql.append(" 	,biyong = 		'" + jArray.get("biyong") + "'		\n"); 
			sql.append(" 	,gigwan_nm = 	'" + jArray.get("gigwan_name") + "'	\n"); 
			sql.append(" 	,work_memo = 	'" + jArray.get("work_memo") + "'	\n"); 
			sql.append(" 	,bigo = 		'" + jArray.get("bigo") + "'		\n"); 
			sql.append(" 	,member_key = 	'" + jArray.get("member_key") + "'		\n");  // member_key_update
			sql.append(" where seolbi_cd = 	'" + jArray.get("seolbi_code") + "' \n");
			sql.append(" 	AND seq_no = '"    + jArray.get("seq_no") + "' 		\n");
			sql.append(" 	AND member_key = '" + jArray.get("member_key") + "' \n"); // sql.member_key_select, update, delete

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
			LoggingWriter.setLogError("M858S040100E302()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M858S040100E302()","==== finally ===="+ e.getMessage());
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

	public int E303(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject(); // JSONObject ����
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));

			sql = new StringBuffer();
			sql.append(" delete from tbi_seolbi_repare 						\n");
			sql.append(" where seolbi_cd = 	'" + jArray.get("seolbi_code") + "' 	\n");
			sql.append(" 	AND seq_no = 	'" + jArray.get("seq_no") + "' 			\n");
			sql.append(" 	AND member_key = '" + jArray.get("member_key") + "' \n"); // sql.member_key_select, update, delete

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
			LoggingWriter.setLogError("M858S040100E303()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M858S040100E303()","==== finally ===="+ e.getMessage());
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

	public int E304(InoutParameter ioParam) {
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
					.append("	C.code_name,\n")
					.append("	D.code_name,\n")
					.append("	B.product_nm,\n")
					.append("	order_no,\n")
					.append("	lotno,\n")
					.append("	chulha_no,\n")
					.append("	chulha_seq,\n")
					.append("	cust_cd,\n")
					.append("	cust_rev,\n")
					.append("	product_serial_no,\n")
					.append("	product_serial_no_end,\n")
					.append("	chulha_cnt,\n")
					.append("	chulha_unit,\n")
					.append("	chulha_unit_price,\n")
					.append("	chuha_dt,\n")
					.append("	chulha_user_id,\n")
					.append("	A.prod_cd,\n")
					.append("	prod_rev,\n")
					.append("	review_no,\n")
					.append("	confirm_no,\n")
					.append("	order_detail_seq,\n")
					.append("	A.member_key\n")
					.append("FROM tbi_chulha_info A\n")
					.append("	INNER JOIN tbm_product B\n")
					.append("	ON A.prod_cd = B.prod_cd\n")
					.append("	AND A.prod_rev = B.revision_no\n")
					.append("	AND A.member_key = B.member_key\n")
					.append("	INNER JOIN v_prodgubun_big C\n")
					.append("	ON B.prod_gubun_b = C.code_value\n")
					.append("	AND B.member_key = C.member_key\n")
					.append("	INNER JOIN v_prodgubun_mid D\n")
					.append("	ON B.prod_gubun_m = D.code_value\n")
					.append("	AND B.member_key = D.member_key\n")
					.append("WHERE  TO_CHAR(A.chuha_dt,'YYYY-MM-DD') BETWEEN '" + jArray.get("fromdate") + "' AND '" + jArray.get("todate") + "'\n")
					.append("	AND A.member_key = '" + jArray.get("member_key") + "'\n")
					.append("ORDER BY A.chuha_dt DESC\n")
					.toString();


			resultString = super.excuteQueryString(con, sql.toString());
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M858S040100E304()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M858S040100E304()","==== finally ===="+ e.getMessage());
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
	
	public int E314(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			// Ŭ���̾�Ʈ�� ���� ���� �Ķ���͸� �Ű� ��´�.
			//String rcvData = (String)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			// Ŭ���̾�Ʈ�� ���� ���� �Ķ���͸� �ɰ�� �迭�� ��´�.
			//{ "�����ڵ�", "��������", "�����", "��������", "������", "�Ϸ���", "�����", "���", "���", "SEQ_NO"};
			
			//String[][] c_paramArray = CommonFunction.getConvString2DoubleArray(rcvData);
			
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			
			String sql = new StringBuilder()
					.append(" SELECT 				\n")
					.append("	 seolbi_cd  		\n")
					.append("	 ,B.code_name AS reason_cd  		\n")
					.append("	 ,gigwan_nm  		\n")
					.append("	 ,work_memo  		\n")
					.append("	 ,start_dt  		\n")
					.append("	 ,end_dt  			\n")
					.append("	 ,user_id  			\n")
					.append("	 ,TO_CHAR (biyong, '999,999,999,999') AS biyong  			\n")
					.append("	 ,A.bigo  			\n")
					.append("	 ,seq_no  			\n")
					.append(" FROM 					\n")
					.append("	tbi_seolbi_repare A	\n")
					.append("INNER JOIN tbm_code_book B\n")
					.append("	ON A.reason_cd = B.code_value\n")
					.append("	AND A.member_key = B.member_key\n")
					.append(" WHERE seolbi_cd = '" + jArray.get("seolbi_cd") + "' \n")
					.append(" 	AND A.member_key = '" + jArray.get("member_key") + "' \n") // sql.member_key_select, update, delete
					.append(" ORDER BY seq_no DESC							 \n")
					.toString();
			
			resultString = super.excuteQueryString(con, sql.toString());
			
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M858S040100E314()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M858S040100E114()","==== finally ===="+ e.getMessage());
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

	public int E115(InoutParameter ioParam){
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
					.append(" SELECT 				\n")
					.append("	 seolbi_cd  		\n")
					.append("	 ,reason_cd  		\n")
					.append("	 ,gigwan_nm  		\n")
					.append("	 ,work_memo  		\n")
					.append("	 ,start_dt  		\n")
					.append("	 ,end_dt  			\n")
					.append("	 ,user_id  			\n")
					.append("	 ,TO_CHAR (biyong, '999,999,999,999') AS biyong  			\n")
					.append("	 ,bigo  			\n")
					.append("	 ,seq_no  			\n")
					.append(" FROM 					\n")
					.append("	tbi_seolbi_repare	\n")
					.append(" WHERE seolbi_cd = '" + jArray.get("sulbi_cd") + "' \n")
					.append(" 	AND seq_no = '" + jArray.get("seq_no") + "' \n")
					.append(" 	AND member_key = '" + jArray.get("member_key") + "' \n") // sql.member_key_select, update, delete
					.toString();
			
			resultString = super.excuteQueryString(con, sql.toString());
			
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M858S040100E115()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M858S040100E115()","==== finally ===="+ e.getMessage());
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