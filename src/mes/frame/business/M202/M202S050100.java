package mes.frame.business.M202;

import java.lang.reflect.Method;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.util.Vector;

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


public class M202S050100 extends SqlAdapter{
	Connection con = null;
	PreparedStatement pstmt = null;
	String resultString = "";
	int resultInt = -1;
	StringBuffer sql = new StringBuffer();
	
	String[][] v_paramArray = new String[0][0]; 
	Class[] optClass = null;
	Object[] optObj = null;
	Object obj = null;
	
	public M202S050100(){
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
			
			Method method = M202S050100.class.getMethod(event,optClass);
			LoggingWriter.setLogDebug(M202S050100.class.getName(),"==== " + event + " EventMethod Create Success ====");

			obj = method.invoke(M202S050100.class.newInstance(),optObj);
			doExcute_result = CommonFunction.getInt(obj.toString());
			
	    } catch (Exception ex) {
	    	doExcute_result = EventDefine.E_DOEXCUTE_INIT;
			ioParam.setMessage(MessageDefine.M_NO_EVENTID);
			LoggingWriter.setLogError(M202S050100.class.getName(),"==== EventID Not define : EVENT ID [ " + ioParam.getEventID() + "]");
	    } finally {
	    	obj = null;
			optClass = null;
			optObj = null;
	    }
	    long endTime = System.currentTimeMillis();
		long runningTime = endTime - startTime;
		LoggingWriter.setLogAll(M202S050100.class.getName(),"==== Query [����ð�  : " + runningTime + " ms]");
		
		return doExcute_result;
	}
	

	public int E104(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();		
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			System.out.println("JSONObject jArray rcvData="+ jArray.toString());
			
			String sql = new StringBuilder()
					.append("SELECT\n")
					.append("	order_no,\n")
					.append("	balju_no,\n")
					.append("	balju_text,\n")
					.append("	TO_CHAR(balju_send_date,'YYYY-MM-DD') AS balju_send_date,\n")
					.append("	A.cust_cd,\n")
					.append("	C.cust_nm,\n")
					.append("	cust_cd_rev,\n")
					.append("	cust_damdang,\n")
					.append("	tell_no,\n")
					.append("	fax_no,\n")
					.append("	TO_CHAR(balju_nabgi_date,'YYYY-MM-DD') AS balju_nabgi_date,\n")
					.append("	nabpoom_location,\n")
					.append("	qa_ter_condtion	\n")
					.append("FROM tbi_balju A \n")
					.append("	INNER JOIN tbm_customer C \n")
					.append("	ON A.cust_cd = C.cust_cd\n")
					.append("	AND A.cust_cd_rev = C.revision_no\n")
					.append("   AND A.member_key = C.member_key\n")
					.append("WHERE  TO_CHAR(balju_send_date,'YYYY-MM-DD') BETWEEN '" + jArray.get("fromdate") + "' AND '" + jArray.get("todate") + "' \n")
					.append("AND company_type_b='type2' \n")
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
			LoggingWriter.setLogError("M202S050100E104()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M202S050100E104()","==== finally ===="+ e.getMessage());
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


	public int E204(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();		
			
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			System.out.println("JSONObject jArray rcvData="+ jArray.toString());
			
//			String rcvData = (String)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
//			String[][] c_paramArray = CommonFunction.getConvString2DoubleArray(rcvData);
			
			//  {"����", "������ġ", "���������ڵ�", "��ǰ�ڵ�", "���������", "���(��)", "�԰�(��)", "��ġ���", "�������" };  
			
			String sql = new StringBuilder()					
					.append("SELECT\n")
					.append("        machineno,\n")
					.append("        rakes,\n")
					.append("        plate,\n")
					.append("        colm,\n")
					.append("        A.part_cd,\n")
					.append("        B.part_nm || '('||E.code_name  ||','||  F.code_name ||')',\n")
					.append("        machineno || '-'|| rakes || '-'|| plate || '-'|| colm AS part_loc,\n")
					.append("        CAST(io_amt AS NUMERIC(15,3)),\n")
					.append("        CAST(pre_amt AS NUMERIC(15,3)),\n")
					.append("        CAST(post_amt AS NUMERIC(15,3)),\n")
					.append("        NVL(safety_jaego,0) AS safety_jaego,\n")
					.append("        part_cd_rev,\n")
					.append("        bigo\n")
					.append("FROM\n")
					.append("        tbi_part_storage A\n")
					.append("        INNER JOIN tbm_part_list B\n")
					.append("        ON A.part_cd = B.part_cd\n")
					.append("        AND A.part_cd_rev = B.revision_no\n")
					.append("   AND A.member_key = B.member_key\n")
					.append("INNER JOIN v_partgubun_big E\n")
					.append("             ON B.part_gubun_b = E.code_value\n")
					.append("     		AND B.member_key = E.member_key\n")
					.append("INNER JOIN v_partgubun_mid F\n")
					.append("	           ON B.part_gubun_m = F.code_value\n")
					.append("     		 AND B.member_key = F.member_key\n")
					.append("	WHERE 1=1 \n")
//					.append("	and machineno	like 	'" + jArray.get("machine_no") + "%' \n")
					.append("AND A.member_key = '" + jArray.get("member_key") + "' 	\n")
					.append("ORDER BY A.part_cd\n")
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
			LoggingWriter.setLogError("M202S050100E204()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M202S050100E204()","==== finally ===="+ e.getMessage());
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

	
	public int E504(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			System.out.println("JSONObject jArray rcvData="+ jArray.toString());
			
			
			
			// Ŭ���̾�Ʈ�� ���� ���� �Ķ���͸� �Ű� ��´�.
//			String rcvData = (String)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
//			String[][] c_paramArray = CommonFunction.getConvString2DoubleArray(rcvData);
			
			String sql = new StringBuilder()
					.append("SELECT DISTINCT\n")
					.append("        order_no,\n")
					.append("        A.balju_no,\n")
					.append("        A.balju_text,\n")
					.append("        A.cust_cd,\n")
					.append("        B.cust_nm,\n")
					.append("        A.cust_cd_rev,\n")
					.append("        TO_CHAR(A.balju_send_date,'YYYY-MM-DD'),\n")
					.append("        TO_CHAR(A.balju_nabgi_date,'YYYY-MM-DD')\n")
					.append("FROM\n")
					.append("        tbi_balju A\n")
					.append("        INNER JOIN tbm_customer B\n")
					.append("        ON A.cust_cd = B.cust_cd\n")
					.append("        AND A.cust_cd_rev = B.revision_no\n")
					.append("         AND A.member_key = B.member_key\n")
					.append("WHERE TO_CHAR(A.balju_send_date,'YYYY-MM-DD') BETWEEN '" + jArray.get("fromdate") + "' AND '" + jArray.get("todate") + "' \n")
					.append("	AND A.cust_cd like '" + jArray.get("custcode") + "%'\n")
					.append("	AND A.cust_cd_rev like '" + jArray.get("custcode_rev") + "%'\n")
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
			LoggingWriter.setLogError("M202S050100E504()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M202S050100E504()","==== finally ===="+ e.getMessage());
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
			
			
			
			// Ŭ���̾�Ʈ�� ���� ���� �Ķ���͸� �Ű� ��´�.
//			String rcvData = (String)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
//			String[][] c_paramArray = CommonFunction.getConvString2DoubleArray(rcvData);
			
			String sql = new StringBuilder()
					.append("SELECT DISTINCT\n")
					.append("		A.part_cd,\n")
					.append("		A.part_cd_rev,\n")
					.append("		B.part_nm,\n")
					.append("		A.balju_no,\n")
					.append("		A.standard_guide,\n")
					.append("		A.standard_value,\n")
					.append("		A.check_note,\n")
					.append("		A.check_value,\n")
					.append("		A.pass_yn,\n")
					.append("		TO_CHAR(A.check_date,'YYYY-MM-DD')\n")
					.append("FROM\n")
					.append("	haccp_part_ipgo_inspection A\n")
					.append("INNER JOIN tbm_part_list B\n")
					.append("	ON A.part_cd = B.part_cd\n")
					.append("	AND A.part_cd_rev = B.revision_no\n")
					.append("	AND A.member_key = B.member_key\n")
					.append("WHERE A.balju_no= '" + jArray.get("balju_no") + "'\n")
					.append("AND A.member_key = '" + jArray.get("member_key") + "'\n")
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
			LoggingWriter.setLogError("M202S050100E514()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M202S050100E514()","==== finally ===="+ e.getMessage());
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

	// ����ϴ� jsp ����
	public int E604(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			// Ŭ���̾�Ʈ�� ���� ���� �Ķ���͸� �Ű� ��´�.
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			System.out.println("JSONObject jArray rcvData="+ jArray.toString());
			
			//  {"����", "������ġ", "���������ڵ�", "��ǰ�ڵ�", "���������", "���(��)", "�԰�(��)", "��ġ���", "�������" };  
			String sql = new StringBuilder()
					.append("SELECT\n")
					.append("	machineno,\n")
					.append("	rakes,\n")
					.append("	plate,\n")
					.append("	colm,\n")
					.append("	A.part_cd,\n")
					.append("	part_nm,\n")
					.append("	pre_amt,\n")
					.append("	post_amt,\n")
					.append("	io_amt,\n")
					.append("	NVL(safety_jaego,0) AS safety_jaego,\n")
					.append("	part_cd_rev,\n")
					.append("	bigo\n")
					.append("FROM\n")
					.append("	tbi_part_storage A \n")
					.append("	INNER JOIN tbm_part_list B \n")
					.append("	ON A.part_cd = B.alt_part_cd\n")
					.append("	AND A.part_cd_rev = B.alt_revision_no\n")
					.append("   AND A.member_key = B.member_key\n")
//					.append("WHERE A.member_key = '" + jArray.get("member_key") + "' 	\n")
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
			LoggingWriter.setLogError("M202S050100E604()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M202S050100E604()","==== finally ===="+ e.getMessage());
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
	
	public int E010(InoutParameter ioParam){ 		//2020.12.03 �������� �����Ȳ�� �߰�. (�Ź���)
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();		
			
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			System.out.println("JSONObject jArray rcvData="+ jArray.toString());
			
			String sql = new StringBuilder()					
					.append("SELECT\n")
					.append("	D.code_name,												\n")
					.append("	E.code_name,												\n")
					.append("	trace_key,													\n")	// �̷� ���� Ű
					.append("	A.part_cd,													\n")	// �������/���� �ڵ�
					.append("	B.part_nm,													\n")
					.append("   B.unit_type,												\n")    //�԰�
					.append("	A.part_rev_no,												\n")	// �������/���� �����̷¹�ȣ
					.append("	TO_CHAR(SUM(TO_NUMBER(post_amt)),'99999999') AS post_amt,	\n")	// ���� ���
					.append("   B.safety_jaego 												\n")    // ���� ���
					.append("FROM															\n")
					.append("        tbi_part_storage2 A									\n")
					.append("INNER JOIN tbm_part_list B 									\n")
					.append("        ON A.part_cd = B.part_cd 								\n")
					.append("INNER JOIN v_partgubun_big D									\n")
					.append("ON B.part_gubun_b = D.code_value								\n")
					.append("INNER JOIN v_partgubun_mid E									\n")
					.append("ON B.part_gubun_m = E.code_value								\n")
					.append("WHERE part_gubun_b like '" + jArray.get("partgubun_big") + "%'" +
							 "AND part_gubun_m like '" + jArray.get("partgubun_mid") + "%'	\n")
					.append("GROUP BY A.part_cd												\n")
					.append("ORDER BY A.part_cd												\n")
					.append(";																\n")
					.toString();
			
			String ActionCommand = ioParam.getActionCommand();
			if(ActionCommand.startsWith("doQueryTableFieldName")) {
				resultString = super.excuteQueryStringTableFieldName(con, sql.toString());
			} else {
				resultString = super.excuteQueryString(con, sql.toString());
			}
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M202S050100E010()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M202S050100E010()","==== finally ===="+ e.getMessage());
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