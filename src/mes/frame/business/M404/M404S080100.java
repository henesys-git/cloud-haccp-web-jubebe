package mes.frame.business.M404;

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
import mes.frame.util.ComBaljuUpdate;
import mes.frame.util.CommonFunction;


/**
 * ���� : �̺�ƮID�� �޼ҵ� ����
 */
public  class M404S080100 extends SqlAdapter{
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
	
	public M404S080100(){
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
			
			Method method = M404S080100.class.getMethod(event,optClass);
			LoggingWriter.setLogDebug(M404S080100.class.getName(),"==== " + event + " EventMethod Create Success ====");

			obj = method.invoke(M404S080100.class.newInstance(),optObj);
			doExcute_result = CommonFunction.getInt(obj.toString());
			
	    } catch (Exception ex) {
	    	doExcute_result = EventDefine.E_DOEXCUTE_INIT;
			ioParam.setMessage(MessageDefine.M_NO_EVENTID);
			LoggingWriter.setLogError(M404S080100.class.getName(),"==== EventID Not define : EVENT ID [ " + ioParam.getEventID() + "]");
	    } finally {
	    	obj = null;
			optClass = null;
			optObj = null;
	    }
	    long endTime = System.currentTimeMillis();
		long runningTime = endTime - startTime;
		LoggingWriter.setLogAll(M404S080100.class.getName(),"==== Query [����ð�  : " + runningTime + " ms]");
		
		return doExcute_result;
	}

	public int E884(InoutParameter ioParam){
	      resultInt = EventDefine.E_DOEXCUTE_INIT;
	      
	      try {
	         con = JDBCConnectionPool.getConnection();
	         
	         // Ŭ���̾�Ʈ�� ���� ���� �Ķ���͸� �Ű� ��´�.
//	         String rcvData = (String)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));

			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
	         // Ŭ���̾�Ʈ�� ���� ���� �Ķ���͸� �ɰ�� �迭�� ��´�.
	         // rcvData = [���浵]
//	         String[][] c_paramArray = CommonFunction.getConvString2DoubleArray(rcvData);
	         String sql = new StringBuilder()
	        			.append("SELECT DISTINCT\n")
	        			.append("        C.cust_nm,              --����\n")
	        			.append("        B.product_nm,           --��ǰ��\n")
	        			.append("        cust_pono,              --PO��ȣ\n")
	        			.append("        product_gubun,          --��ǰ����\n")
	        			.append("        part_source,            --�����������\n")
	        			.append("        order_date,             --�ֹ���\n")
	        			.append("        A.lotno,                --lot��ȣ\n")
	        			.append("        lot_count,              --lot����\n")
	        			.append("        part_chulgo_date,       --���������\n")
	        			.append("        rohs,\n")
	        			.append("        order_note,             --Ư�̻���\n")
	        			.append("        delivery_date,          --������\n")
	        			.append("        bom_version,\n")
	        			.append("        A.order_no,             --�ֹ���ȣ\n")
	        			.append("        S.process_name,         --�����¸�\n")
	        			.append("        A.bigo,                 --���\n")
	        			.append("        product_serial_no,      --�Ϸù�ȣ\n")
	        			.append("        product_serial_no_end,  --�Ϸù�ȣ��\n")
	        			.append("        A.cust_cd,\n")
	        			.append("        A.cust_rev,\n")
	        			.append("        A.prod_cd,\n")
	        			.append("        A.prod_rev,\n")
	        			.append("        Q.order_status\n")
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
	        			.append(" " + jArray.get("where") + "\n" )	//where ���� ���ԵǾ� query ��û��

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
	         LoggingWriter.setLogError("M404S080100E884()","==== SQL ERROR ===="+ e.getMessage());
	         return EventDefine.E_DOEXCUTE_ERROR ;
	       } finally {
	          if (Config.useDataSource) {
	            try {
	               if (con != null) con.close();
	            } catch (Exception e) {
	            	LoggingWriter.setLogError("M404S080100E884()","==== finally ===="+ e.getMessage());
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

	public int E894(InoutParameter ioParam){
	      resultInt = EventDefine.E_DOEXCUTE_INIT;
	      
	      try {
	         con = JDBCConnectionPool.getConnection();
	         
	         // Ŭ���̾�Ʈ�� ���� ���� �Ķ���͸� �Ű� ��´�.
//	         String rcvData = (String)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));

			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
	         // Ŭ���̾�Ʈ�� ���� ���� �Ķ���͸� �ɰ�� �迭�� ��´�.
	         // rcvData = [���浵]
//	         String[][] c_paramArray = CommonFunction.getConvString2DoubleArray(rcvData);
	         String sql = new StringBuilder()
	        			.append("SELECT DISTINCT\n")
	        			.append("        C.cust_nm,              --����\n")
	        			.append("        B.product_nm || '('||D.code_name  ||','|| E.code_name ||')',	--��ǰ��\n")
	        			.append("        cust_pono,              --PO��ȣ\n")
	        			.append("        product_gubun,          --��ǰ����\n")
	        			.append("        part_source,            --�����������\n")
	        			.append("        order_date,             --�ֹ���\n")
	        			.append("        A.lotno,                --lot��ȣ\n")
	        			.append("        lot_count,              --lot����\n")
	        			.append("        part_chulgo_date,       --���������\n")
	        			.append("        rohs,\n")
	        			.append("        order_note,             --Ư�̻���\n")
	        			.append("        delivery_date,          --������\n")
	        			.append("        bom_version,\n")
	        			.append("        A.order_no,             --�ֹ���ȣ\n")
	        			.append("        S.process_name,         --�����¸�\n")
	        			.append("        A.bigo,                 --���\n")
	        			.append("        product_serial_no,      --�Ϸù�ȣ\n")
	        			.append("        product_serial_no_end,  --�Ϸù�ȣ��\n")
	        			.append("        A.cust_cd,\n")
	        			.append("        A.cust_rev,\n")
	        			.append("        A.prod_cd,\n")
	        			.append("        A.prod_rev,\n")
	        			.append("        Q.order_status\n")
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
	        			.append("   	 AND B.member_key 	= D.member_key	\n")
	        			.append(" INNER JOIN v_prodgubun_mid E				\n")
	        			.append("		  ON B.prod_gubun_m	= E.code_value	\n")
	        			.append("   	 AND B.member_key 	= E.member_key	\n")	        			
						.append("WHERE 1=1	\n")
						.append("AND order_date \n")
						.append("	BETWEEN '" + jArray.get("fromdate") + "' 	\n")
						.append("		AND '" + jArray.get("todate") + "'	\n")
						.append("AND A.member_key = '" + jArray.get("member_key") + "'  \n")						
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
	         LoggingWriter.setLogError("M404S080100E894()","==== SQL ERROR ===="+ e.getMessage());
	         return EventDefine.E_DOEXCUTE_ERROR ;
	       } finally {
	          if (Config.useDataSource) {
	            try {
	               if (con != null) con.close();
	            } catch (Exception e) {
	            	LoggingWriter.setLogError("M404S080100E894()","==== finally ===="+ e.getMessage());
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

