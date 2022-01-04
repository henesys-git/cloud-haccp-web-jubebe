package mes.frame.business.M909;

import java.lang.reflect.Method;
import java.sql.Connection;
import java.sql.PreparedStatement;

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


public class M909S190100 extends SqlAdapter{
	Connection con = null;
	PreparedStatement pstmt = null;
	String resultString = "";
	int resultInt = -1;
	StringBuffer sql = new StringBuffer();
	
	String[][] v_paramArray = new String[0][0]; 
	Class[] optClass = null;
	Object[] optObj = null;
	Object obj = null;
	
	public M909S190100(){
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
			
			Method method = M909S190100.class.getMethod(event,optClass);
			LoggingWriter.setLogDebug(M909S190100.class.getName(),"==== " + event + " EventMethod Create Success ====");

			obj = method.invoke(M909S190100.class.newInstance(),optObj);
			doExcute_result = CommonFunction.getInt(obj.toString());
			
	    } catch (Exception ex) {
	    	doExcute_result = EventDefine.E_DOEXCUTE_INIT;
			ioParam.setMessage(MessageDefine.M_NO_EVENTID);
			LoggingWriter.setLogError(M909S190100.class.getName(),"==== EventID Not define : EVENT ID [ " + ioParam.getEventID() + "]");
	    } finally {
	    	obj = null;
			optClass = null;
			optObj = null;
	    }
	    long endTime = System.currentTimeMillis();
		long runningTime = endTime - startTime;
		LoggingWriter.setLogAll(M909S190100.class.getName(),"==== Query [����ð�  : " + runningTime + " ms]");
		
		return doExcute_result;
	}
	/*
	//�������� ����������
	public int E104(InoutParameter ioParam) {
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
			.append(" SELECT 																\n") 
			.append(" 		A.prod_cd,														\n") //����ǰ�ڵ�
			.append(" 		A.product_nm,													\n") //����ǰ��
			.append(" 		A.gugyuk,														\n") //�԰�kg
			.append(" 		A.unit_price,													\n") //�ǸŰ�
			.append(" 		A.unit_price/1.1 AS VAT_price,									\n") //������
			.append(" 		(A.unit_price*0.7)/1.1 AS chulgo_price,							\n") //���
			.append("		SUM(B.chulgo_amount) AS month_chulgo_amount,					\n") //���
			.append("		SUM(C.real_amount) AS month_prod_amount,						\n") //���귮
			.append("		A.packing_cost,													\n") //�����
			.append("		(A.packing_cost*C.real_amount) AS all_packing_price,			\n") //����ݾ�
			.append(" 		(A.unit_price*SUM(B.chulgo_amount))/1.1	AS all_sale_price,		\n") //���ǸŰ�
			.append("		((A.unit_price*0.7)/1.1*SUM(B.chulgo_amount)) AS month_chulgo_price, 		\n") //�� �����
			.append("		((A.unit_price*0.7)/1.1*SUM(C.real_amount)) AS month_prod_price,			\n") //�� �ѻ��갡
			.append("       SUM(D.unit_price/D.packing_qtty*E.blending_amount_real*A.gugyuk/C.real_amount) " // ����
					+ "AS part_cost, \n")  															
			.append("		SUM(B.chulgo_amount)*SUM(D.unit_price/D.packing_qtty*E.blending_amount_real*A.gugyuk/C.real_amount) AS all_chulgo_amount_part_cost,	\n") //����� ������
			.append("		SUM(C.real_amount)*SUM(D.unit_price/D.packing_qtty*E.blending_amount_real*A.gugyuk/C.real_amount) AS all_prod_amount_part_cost,		\n") //�ѻ��� ������
			.append(" 		SUM(B.chulgo_amount)+I.working_cost_all_real * I.working_cost_all*"
					+ "G.work_time/sum(G.work_time)/I.working_cast_all + I.produce_cost_all*"
					+ "I.working_cost_all * G.work_time/sum(G.work_time) AS prod_origin_cost, \n") //��������(����+�ΰǺ�+�������)
			.append(" 		A.prod_rev_no			 										\n") //����ǰ �����̷¹�ȣ
			.append(" FROM tbm_product A											\n")
			.append(" INNER JOIN tbi_prod_chulgo2 B    								\n")
			.append(" ON A.prod_cd = B.prod_cd  									\n")
			.append(" AND A.revision_no = B.prod_rev_no   							\n")
			.append(" INNER JOIN tbi_production_plan_daily_detail C    				\n")
			.append(" ON A.prod_cd = B.prod_cd  									\n")
			.append(" AND A.revision_no = B.prod_rev_no   							\n")
			.append(" INNER JOIN tbm_part_list D    								\n")
			.append(" ON C.part_cd = D.part_cd  									\n")
			.append(" AND C.part_rev_no = D.part_rev_no   							\n")
			.append(" INNER JOIN tbi_production_request_detail E	    			\n")
			.append(" ON C.part_cd = E.part_cd  									\n")
			.append(" AND C.part_rev_no = E.part_rev_no   							\n")
			.append(" AND C.plan_rev_no = E.plan_rev_no   							\n")
			.append(" AND A.prod_cd =  E.prod_cd  									\n")
			.append(" AND A.revision_no =  E.prod_rev_no  							\n")
			.append(" INNER JOIN tbm_bom_info2 F	    							\n")
			.append(" ON C.part_cd = F.part_cd  									\n")
			.append(" AND C.part_rev_no = F.part_rev_no   							\n")
			.append(" AND A.prod_cd =  	F.prod_cd  									\n")
			.append(" AND A.revision_no =  F.prod_rev_no  							\n")
			.append(" AND E.bom_rev_no = F.bom_rev_no   							\n")
			.append(" INNER JOIN tbi_working_info_detail G   						\n")
			.append(" ON A.prod_cd =G.prod_cd  										\n")
			.append(" AND A.prod_rev_no = G.prod_rev_no   							\n")
			.append(" INNER JOIN tbi_working_info I    								\n")
			.append(" ON G.working_seq_no = I.working_seq_no   						\n")
			.append(" AND G.working_rev_no = I.working_rev_no      					\n")
			.append(" WHERE A.revision_no = (SELECT MAX(revision_no)       			\n")
			.append("       				FROM tbm_product J                  	\n")
			.append("      					WHERE A.prod_cd = J.prod_cd)    		\n")
			.toString();

			resultString = super.excuteQueryString(con, sql.toString());
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M909S190100E104()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M909S190100E104()","==== finally ===="+ e.getMessage());
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
	
	//�������� ����������
	public int E104(InoutParameter ioParam) {
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			System.out.println("JSONObject jArray rcvData="+ jArray.toString());
			

			String sql = new StringBuilder()
			.append(" WITH table1 AS (   												   \n") 
			.append(" SELECT 															   \n")
			.append(" DATE_FORMAT(A.chulgo_date, '%Y-%M') AS standard_date, 				   \n")
			.append(" SUM((B.unit_price*0.7)/1.1 * A.chulgo_amount) AS month_chulgo_price, \n") //�� �����(���*���)
			.append(" SUM((B.unit_price*0.7)/1.1 * C.real_amount) AS month_prod_price, 	   \n") //�� �ѻ��갡(���*���귮)
			.append(" SUM(C.real_amount * (B.part_cost)) AS all_prod_amount_part_cost, 	   \n") //����*���귮
			.append(" SUM(A.chulgo_amount * (B.part_cost)) AS all_chulgo_amount_part_cost  \n") //����*���
			.append(" FROM tbi_prod_chulgo2 A 											   \n")
			.append(" INNER JOIN tbm_product B 											   \n")
			.append(" ON A.prod_cd = B.prod_cd 											   \n")
			.append(" AND A.prod_rev_no = B.revision_no 								   \n")
			.append(" INNER JOIN tbi_production_plan_daily_detail C 					   \n")
			.append(" ON A.prod_cd = C.prod_cd 											   \n")
			.append(" AND A.prod_rev_no = C.prod_rev_no 								   \n")
			.append(" INNER JOIN tbi_production_request_detail D 						   \n")
			.append(" ON C.plan_rev_no = D.plan_rev_no 									   \n")
			.append(" AND B.prod_cd = D.prod_cd 										   \n")
			.append(" AND B.revision_no = D.prod_rev_no 								   \n")
			.append(" INNER JOIN tbm_part_list E 										   \n")
			.append(" ON D.part_cd = E.part_cd 											   \n")
			.append(" AND D.part_rev_no = E.revision_no 								   \n")
			.append(" WHERE DATE_FORMAT(A.prod_date, '%Y-%M') = +'"+jArray.get("yearMonth")+"' 		   \n")
			.append(" AND   DATE_FORMAT(C.prod_plan_date, '%Y-%M') = +'"+jArray.get("yearMonth")+"'       \n")
			.append(" AND   DATE_FORMAT(D.prod_plan_date, '%Y-%M') = +'"+jArray.get("yearMonth")+"' 	   \n")
			.append("GROUP BY MONTH(A.chulgo_date)  	 								   \n")
			.append(" ),   																   \n")
			.append(" table2 AS (														   \n")
			.append(" SELECT 															   \n")
			.append(" month_prod_price - all_prod_amount_part_cost - working_cost_all_real - "
					+ "produce_cost_all + indirect_cost AS prod_increase, 				   \n")
			.append(" month_chulgo_price - all_chulgo_amount_part_cost - working_cost_all_real - "
					+ "produce_cost_all + indirect_cost AS chulgo_increase 				   \n")
			.append(" FROM tbi_working_info, table1 									   \n")
			.append(" ) 																   \n")
			.append(" SELECT 															   \n")
			.append(" standard_date, 												   	   \n")
			.append(" month_chulgo_price, 												   \n")
			.append(" month_prod_price, 												   \n")
			.append(" all_prod_amount_part_cost, 										   \n")
			.append(" working_cost_all_real,											   \n")											
		 	.append(" produce_cost_all - indirect_cost AS direct_cost,					   \n")
		 	.append(" indirect_cost, 													   \n")
		 	.append(" produce_cost_all, 												   \n")
		 	.append(" prod_increase, 													   \n")
		 	.append(" prod_increase / month_prod_price, 								   \n")
		 	.append(" chulgo_increase, 													   \n")
		 	.append(" chulgo_increase / month_prod_price 								   \n")
		 	.append(" FROM tbi_working_info, table1, table2 							   \n")
			.toString();

			resultString = super.excuteQueryString(con, sql.toString());
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M909S190100E104()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M909S190100E104()","==== finally ===="+ e.getMessage());
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
	
	
	
	//�������� ����������
	public int E114(InoutParameter ioParam) {
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			System.out.println("JSONObject jArray rcvData="+ jArray.toString());

			String sql = new StringBuilder()
			.append(" WITH table1 AS (   												   \n") 
			.append(" SELECT 															   \n")
			.append(" B.product_nm AS prod_nm, 											   \n") //����ǰ��
			.append(" B.prod_cd AS prod_cd,  											   \n") //����ǰ�ڵ�
			.append(" B.gugyuk AS prod_gugyuk, 											   \n") //����ǰ�԰�
			.append(" B.unit_price AS sale_price,   									   \n") //�ǸŰ�
			.append(" B.unit_price/1.1 AS VAT_price, 									   \n") //������(VAT��)
			.append(" (B.unit_price*0.7)/1.1 AS chulgo_price, 							   \n") //���
			.append(" SUM(A.chulgo_amount) AS chulgo_amount, 								   \n") //���
			.append(" SUM(C.real_amount) AS prod_amount, 									   \n") //���귮
			.append(" B.packing_cost AS packing_cost, 									   \n") //�����
			.append(" B.packing_cost*C.real_amount AS packing_price, 					   \n") //����ݾ�
			.append(" (B.unit_price*A.chulgo_amount)/1.1 AS all_sale_price, 			   \n") //���ǸŰ�
			.append(" (B.unit_price*0.7)/1.1 * A.chulgo_amount AS month_chulgo_price, 	   \n") //�� �����(���*���)
			.append(" (B.unit_price*0.7)/1.1 * C.real_amount AS month_prod_price, 	   	   \n") //�� �ѻ��갡(���*���귮)
			.append(" E.unit_price/E.packing_qtty*D.blending_amount_real*B.gugyuk/C.real_amount AS part_cost,\n") // ����
			.append(" A.chulgo_amount*E.unit_price/E.packing_qtty*D.blending_amount_real*B.gugyuk/C.real_amount AS all_chulgo_amount_part_cost, \n") //����� ������(����*���)
			.append(" C.real_amount  *E.unit_price/E.packing_qtty*D.blending_amount_real*B.gugyuk/C.real_amount AS all_prod_amount_part_cost  \n") //�ѻ��귮 ������(����*���귮)
			.append(" FROM tbi_prod_chulgo2 A 											   \n")
			.append(" INNER JOIN tbm_product B 											   \n")
			.append(" ON A.prod_cd = B.prod_cd 											   \n")
			.append(" AND A.prod_rev_no = B.revision_no 								   \n")
			.append(" INNER JOIN tbi_production_plan_daily_detail C 					   \n")
			.append(" ON A.prod_cd = C.prod_cd 											   \n")
			.append(" AND A.prod_rev_no = C.prod_rev_no 								   \n")
			.append(" INNER JOIN tbi_production_request_detail D 						   \n")
			.append(" ON C.plan_rev_no = D.plan_rev_no 									   \n")
			.append(" AND B.prod_cd = D.prod_cd 										   \n")
			.append(" AND B.revision_no = D.prod_rev_no 								   \n")
			.append(" INNER JOIN tbm_part_list E 										   \n")
			.append(" ON D.part_cd = E.part_cd 											   \n")
			.append(" AND D.part_rev_no = E.revision_no 								   \n")
			.append(" WHERE TO_CHAR(A.prod_date,'YYYY-MM') = '"+jArray.get("standard_date")+"'  		\n")
			.append(" AND  TO_CHAR(C.prod_plan_date, 'YYYY-MM') = '"+jArray.get("standard_date")+"' 	\n")
			.append(" AND  TO_CHAR(D.prod_plan_date, 'YYYY-MM') = '"+jArray.get("standard_date")+"' 	\n")
			.append("GROUP BY A.prod_cd  	 						   					   \n")
			.append(" ),   																   \n")
			.append(" table2 AS (														   \n")
			.append(" SELECT 															   \n")
			.append(" produce_cost_all - indirect_cost AS direct_cost, 					   \n") //������(�������)
			.append(" working_cost_all_real/worker_count AS individ_working_cost_per_month,\n") //�δ� �� ��� �ΰǺ�
			.append(" working_cost_all_real/worker_count/working_day_count AS individ_working_cost_per_day,\n") //�δ� �� ��� �ΰǺ�
			.append(" working_cost_all_real/worker_count/working_day_count/8 AS individ_working_cost_per_hour,\n") //�δ� �ð� ��� �ΰǺ�
			.append(" month_prod_price - all_prod_amount_part_cost - working_cost_all_real - "
					+ "produce_cost_all + indirect_cost AS prod_increase, 				   \n") //���귮���� ����
			.append(" month_chulgo_price - all_chulgo_amount_part_cost - working_cost_all_real - "
					+ "produce_cost_all + indirect_cost AS chulgo_increase 				   \n") //������� ����
			.append(" FROM tbi_working_info, table1 					   				   \n")
			.append(" ), 												   				   \n")
			.append(" table3 AS (														   \n")
			.append(" SELECT 															   \n")
			.append(" prod_cd AS table3_prod_cd,  										   \n")
			.append(" SUM(working_time) AS per_prod_working_time 					   	   \n")
			.append(" FROM tbi_working_info_detail 					   	   				   \n")
			.append(" GROUP BY prod_cd 													   \n")
			.append(" ), 																   \n")
			.append(" table4 AS (														   \n")
			.append(" SELECT 															   \n")
			.append(" SUM(working_time) AS all_working_time 					   	   	   \n")
			.append(" FROM tbi_working_info_detail 					   	   				   \n")
			.append(" ), 																   \n")
			.append(" table5 AS (														   \n")
			.append(" SELECT 															   \n")
			.append(" prod_cd AS table5_prod_cd, 										   \n")
			.append(" individ_working_cost_per_hour*per_prod_working_time AS working_ratio \n")
			.append(" FROM tbi_working_info_detail ,table2, table3 					   	   \n")
			.append(" ) 																   \n")	
			.append(" SELECT 									\n")
			.append(" prod_nm,									\n") //����ǰ��
			.append(" prod_cd, 									\n") //����ǰ�ڵ�
			.append(" prod_gugyuk, 								\n") //����ǰ�԰�
			.append(" sale_price, 								\n") //�ǸŰ�
			.append(" VAT_price, 								\n") //������(VAT��)
			.append(" chulgo_price, 							\n") //���
			.append(" chulgo_amount, 							\n") //���
			.append(" prod_amount, 								\n") //���귮
			.append(" packing_cost, 							\n") //�����
			.append(" packing_price, 							\n") //����ݾ�
			.append(" all_sale_price, 							\n") //���ǸŰ�
			.append(" month_chulgo_price, 						\n") //�� �����
			.append(" month_prod_price, 						\n") //�� �ѻ��갡
			.append(" part_cost, 								\n") //����
			.append(" all_chulgo_amount_part_cost, 				\n") //����� ������
			.append(" all_prod_amount_part_cost, 				\n") //�ѻ��귮 ������
			.append(" working_ratio/prod_amount/chulgo_price*working_cost_all_real + direct_cost +all_chulgo_amount_part_cost,\n") //��������
			.append(" working_ratio/prod_amount, 				\n") //�ҿ�ð���� 1���� �빫�� 
			.append(" per_prod_working_time, 					\n") //�ҿ�ð�
			.append(" working_ratio, 							\n") //�ҿ�ð� ��� �빫��
			.append(" working_ratio/prod_amount/chulgo_price, 	\n") //��� ��� �빫����
			.append(" working_ratio/(all_working_time*individ_working_cost_per_hour), 		\n") //ǰ��� �ҿ� �빫����
			.append(" working_ratio/prod_amount, 											\n") //�������� 1���� �빫�� 
			.append(" working_ratio/prod_amount/chulgo_price*working_cost_all_real,			\n") //���� ���� �빫��										
		 	.append(" working_ratio/(all_working_time*individ_working_cost_per_hour),		\n") //�ҿ�ð��� ������
		 	.append(" working_ratio/(all_working_time*individ_working_cost_per_hour)*indirect_cost/prod_amount, \n") //1���� �������
		 	.append(" working_ratio/(all_working_time*individ_working_cost_per_hour)*indirect_cost, \n") //�������
		 	.append(" prod_increase, 													\n") //������� ����
		 	.append(" prod_increase / month_prod_price, 								\n") //������� ������
		 	.append(" chulgo_increase, 													\n") //������ ����
		 	.append(" chulgo_increase / month_prod_price 								\n") //������ ������
		 	.append(" FROM tbi_working_info F, table1, table2, table3, table4, table5 	\n")
		 	.append(" WHERE TO_CHAR(working_info_date,'YYYY-MM') = '"+jArray.get("standard_date")+"'\n")
		 	.append(" AND prod_cd = table3_prod_cd 										\n")
		 	.append(" AND prod_cd = table5_prod_cd 										\n")
		 	.append(" GROUP BY prod_cd 													\n")
			.toString();

			resultString = super.excuteQueryString(con, sql.toString());
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M909S190100E114()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M909S190100E114()","==== finally ===="+ e.getMessage());
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
	//�������� ����������
	public int E114(InoutParameter ioParam){
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
					.append(" SELECT 																						 \n") 
					.append(" 		A.prod_cd,																				 \n") //����ǰ�ڵ�
					.append(" 		A.product_nm,																			 \n") //����ǰ��
					.append(" 		A.gugyuk,																				 \n") //�԰�kg
					.append(" 		A.unit_price,																			 \n") //�ǸŰ�
					.append(" 		A.unit_price/1.1 AS VAT_price,															 \n") //������
					.append(" 		(A.unit_price*0.7)/1.1 AS chulgo_price,													 \n") //���
					.append("		SUM(B.chulgo_amount) AS month_chulgo_amount,											 \n") //���
					.append("		SUM(C.real_amount) AS month_prod_amount,												 \n") //���귮
					.append("		A.packing_cost,																			 \n") //�����
					.append("		(A.packing_cost*C.real_amount) AS all_packing_price,									 \n") //����ݾ�
					.append(" 		(A.unit_price*SUM(B.chulgo_amount))/1.1	AS all_sale_price,								 \n") //���ǸŰ�
					.append("		((A.unit_price*0.7)/1.1*SUM(B.chulgo_amount)) AS month_chulgo_price, 					 \n") //�� �����
					.append("		((A.unit_price*0.7)/1.1*SUM(C.real_amount)) AS month_prod_price,						 \n") //�� �ѻ��갡
					.append("       SUM(D.unit_price/D.packing_qtty*E.blending_amount_real*A.gugyuk/C.real_amount) AS part_cost, \n") //���� 															
					.append("		SUM(B.chulgo_amount)*SUM(D.unit_price/D.packing_qtty*E.blending_amount_real*A.gugyuk/C.real_amount) AS all_chulgo_amount_part_cost,	\n") //����� ������
					.append("		SUM(C.real_amount)*SUM(D.unit_price/D.packing_qtty*E.blending_amount_real*A.gugyuk/C.real_amount) AS all_prod_amount_part_cost,		\n") //�ѻ��� ������
					.append(" 		SUM(B.chulgo_amount)+I.working_cost_all_real * I.working_cost_all*"
							+ "G.work_time/sum(G.work_time)/I.working_cast_all + I.produce_cost_all*"
							+ "I.working_cost_all * G.work_time/sum(G.work_time) AS prod_origin_cost, \n") //��������(����+�ΰǺ�+�������)
					.append(" 		I.working_cost_all*G.working_time/SUM(G.working_time)/C.real_amount AS per_working_cost, \n") //�ҿ�ð���� 1���� �빫��
					.append(" 		G.working_time,													                         \n") //�ҿ�ð�
					.append(" 		I.working_cost_all_real*G.working_time/SUM(G.working_time) AS working_time_all,		     \n") //�ҿ�ð� �Ұ�(�빫)
					.append(" 		I.working_cost_all*G.working_time/SUM(G.working_time)/C.real_amount/A.unit_price*0.7/1.1 AS per_chulgo_price_working_ratio, 				 \n") //������ �빫����
					.append("		I.working_cost_all_real*G.working_time/SUM(G.working_time)/I.working_cost_all AS per_prod_working_ratio, 					 		 \n") //ǰ��� �ҿ� �빫����(����)
					.append("		I.working_cost_all_real*I.working_cost_all_real*G.working_time/SUM(G.working_time)/I.working_cost_all/SUM(C.real_amount) AS per_working_cost_real, \n") //���� ���� 1���� �빫��
					.append("		I.working_cost_all_real*I.working_cost_all_real*G.working_time/SUM(G.working_time)/I.working_cost_all AS working_cost_real,					 \n") //���� ���� �빫��
					.append("		I.working_cost_all_real*G.working_time/SUM(G.working_time)/I.working_cost_all,																	 \n") //�ҿ�ð��� ������(%)
					.append(" 		I.working_cost_all_real*G.working_time/SUM(G.working_time)/I.working_cost_all*(I.produce_cost_all-I.indirect_cost)/SUM(C.real_amount)	AS per_prod_cost,		\n") //1���� �������
					.append("		I.working_cost_all_real*G.working_time/SUM(G.working_time)/I.working_cost_all*(I.produce_cost_all-I.indirect_cost) AS prod_cost, 				 \n") //�������
					.append("		(A.unit_price*0.7)/1.1*SUM(C.real_amount) - SUM(E.unit_price/E.packing_qtty*D.blending_amount_real*"
							+ "A.gugyuk/C.real_amount)*SUM(C.real_amount)- I.working_cost_all_real*I.working_cost_all_real*G.working_time/SUM(G.working_time)/(SUM(G.working_time)*(I.produce_cost_all - I.indirect_cost)/I.worker_count/I.working_day_count/8) - I.working_cost_all_real*G.working_time/SUM(G.working_time)/(SUM(G.working_time)*(I.produce_cost_all - I.indirect_cost)/I.worker_count/I.working_day_count/8)*(I.produce_cost_all-I.indirect_cost) AS prod_increase, \n") //���귮���� ����
					.append("       (A.unit_price*0.7)/1.1*SUM(C.real_amount) - SUM(E.unit_price/E.packing_qtty*D.blending_amount_real*A.gugyuk/C.real_amount)*SUM(C.real_amount)- I.working_cost_all_real*I.working_cost_all_real*G.working_time/SUM(G.working_time)/(SUM(G.working_time)*(I.produce_cost_all - I.indirect_cost)/I.worker_count/I.working_day_count/8) - I.working_cost_all_real*G.working_time/SUM(G.working_time)/(SUM(G.working_time)*(I.produce_cost_all - I.indirect_cost)/I.worker_count/I.working_day_count/8)*(I.produce_cost_all-I.indirect_cost) /(A.unit_price*0.7)/1.1 * SUM(C.real_amount) AS prod_increase_ratio,  		 \n") //���귮���� ������
					.append("       (A.unit_price*0.7)/1.1*SUM(B.chulgo_amount) - SUM(E.unit_price/E.packing_qtty*D.blending_amount_real*"
							+ "A.gugyuk/C.real_amount)*SUM(B.chulgo_amount)- I.working_cost_all_real*I.working_cost_all_real*G.working_time/SUM(G.working_time)/(SUM(G.working_time)*(I.produce_cost_all - I.indirect_cost)/I.worker_count/I.working_day_count/8) - I.working_cost_all_real*G.working_time/SUM(G.working_time)/(SUM(G.working_time)*(I.produce_cost_all - I.indirect_cost)/I.worker_count/I.working_day_count/8)*(I.produce_cost_all-I.indirect_cost) AS chulgo_increase, \n") //������� ����
					.append("       (A.unit_price*0.7)/1.1*SUM(B.chulgo_amount) - SUM(E.unit_price/E.packing_qtty*D.blending_amount_real*A.gugyuk/C.real_amount)*SUM(B.chulgo_amount)- I.working_cost_all_real*I.working_cost_all_real*G.working_time/SUM(G.working_time)/(SUM(G.working_time)*(I.produce_cost_all - I.indirect_cost)/I.worker_count/I.working_day_count/8) - I.working_cost_all_real*G.working_time/SUM(G.working_time)/(SUM(G.working_time)*(I.produce_cost_all - I.indirect_cost)/I.worker_count/I.working_day_count/8)*(I.produce_cost_all-I.indirect_cost)/(A.unit_price*0.7)/1.1*SUM(B.chulgo_amount) AS chulgo_increase_ratio,		 \n") //��� ���� ������
					.append(" FROM tbm_product A											\n")
					.append(" INNER JOIN tbi_prod_chulgo2 B    								\n")
					.append(" ON A.prod_cd = B.prod_cd  									\n")
					.append(" AND A.revision_no = B.prod_rev_no   							\n")
					.append(" INNER JOIN tbi_production_plan_daily_detail C    				\n")
					.append(" ON A.prod_cd = B.prod_cd  									\n")
					.append(" AND A.revision_no = B.prod_rev_no   							\n")
					.append(" INNER JOIN tbm_part_list D    								\n")
					.append(" ON C.part_cd = D.part_cd  									\n")
					.append(" AND C.part_rev_no = D.part_rev_no   							\n")
					.append(" INNER JOIN tbi_production_request_detail E	    			\n")
					.append(" ON C.part_cd = E.part_cd  									\n")
					.append(" AND C.part_rev_no = E.part_rev_no   							\n")
					.append(" AND C.plan_rev_no = E.plan_rev_no   							\n")
					.append(" AND A.prod_cd =  E.prod_cd  									\n")
					.append(" AND A.revision_no =  E.prod_rev_no  							\n")
					.append(" INNER JOIN tbm_bom_info2 F	    							\n")
					.append(" ON C.part_cd = F.part_cd  									\n")
					.append(" AND C.part_rev_no = F.part_rev_no   							\n")
					.append(" AND A.prod_cd =  	F.prod_cd  									\n")
					.append(" AND A.revision_no =  F.prod_rev_no  							\n")
					.append(" AND E.bom_rev_no = F.bom_rev_no   							\n")
					.append(" INNER JOIN tbi_working_info_detail G   						\n")
					.append(" ON A.prod_cd =G.prod_cd  										\n")
					.append(" AND A.revision_no = G.prod_rev_no   							\n")
					.append(" INNER JOIN tbi_working_info I    								\n")
					.append(" ON G.working_seq_no = I.working_seq_no   						\n")
					.append(" AND G.working_rev_no = I.working_rev_no      					\n")
					.append(" WHERE A.revision_no = (SELECT MAX(rev_no)       			\n")
					.append("       				FROM tbm_product J                  	\n")
					.append("      					WHERE A.prod_cd = J.prod_cd    			\n")
					.toString();
			
			resultString = super.excuteQueryString(con, sql.toString());
			
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M909S180100E114()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M909S180100E114()","==== finally ===="+ e.getMessage());
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
}