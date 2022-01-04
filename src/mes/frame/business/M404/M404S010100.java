package mes.frame.business.M404;

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
public  class M404S010100 extends SqlAdapter{
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
	
	public M404S010100(){
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
			
			Method method = M404S010100.class.getMethod(event,optClass);
			LoggingWriter.setLogDebug(M404S010100.class.getName(),"==== " + event + " EventMethod Create Success ====");

			obj = method.invoke(M404S010100.class.newInstance(),optObj);
			doExcute_result = CommonFunction.getInt(obj.toString());
			
	    } catch (Exception ex) {
	    	doExcute_result = EventDefine.E_DOEXCUTE_INIT;
			ioParam.setMessage(MessageDefine.M_NO_EVENTID);
			LoggingWriter.setLogError(M404S010100.class.getName(),"==== EventID Not define : EVENT ID [ " + ioParam.getEventID() + "]");
	    } finally {
	    	obj = null;
			optClass = null;
			optObj = null;
	    }
	    long endTime = System.currentTimeMillis();
		long runningTime = endTime - startTime;
		LoggingWriter.setLogAll(M404S010100.class.getName(),"==== Query [수행시간  : " + runningTime + " ms]");
		
		return doExcute_result;
	}
	
	public int E104(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jObj = new JSONObject();
			jObj = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			
			String sql = new StringBuilder()
					.append("SELECT													 \n")
					.append("   'checklist11' AS checklist_id, 				 		 \n")
					.append("   A.ipgo_date, 				 						 \n")
					.append("   A.person_write_id, 			 						 \n")
					.append("   C.user_nm, 					 						 \n")
					.append("   A.person_approve_id, 		 						 \n")
					.append("   C2.user_nm,				 	 						 \n")
					.append("   '' AS unsuit_detail, 		 	 					 \n")
					.append("   '' AS improve_action 		 	 					 \n")
					.append("FROM													 \n")
					.append("	haccp_check_ipgo_part_detail A							 \n")
					.append("INNER JOIN tbm_users C									 \n")
					.append("ON A.person_write_id = C.user_id						 \n")
					.append("AND  A.ipgo_date BETWEEN CAST(C.start_date AS DATE) AND CAST(C.duration_date AS DATE) \n")
					.append("LEFT JOIN tbm_users C2									 \n")
					.append("ON A.person_approve_id = C2.user_id					 \n")
					.append("AND  A.ipgo_date BETWEEN CAST(C2.start_date AS DATE) AND CAST(C2.duration_date AS DATE) \n")
					.append("WHERE A.ipgo_date BETWEEN '"+jObj.get("fromdate")+"' 	 \n")
					.append("					   AND '"+jObj.get("todate")+"' 	 \n")
					.append("GROUP BY A.ipgo_date 									\n")
					.append("UNION ALL									 	\n")
					.append("SELECT											\n")
					.append("   'checklist12' AS checklist_id, 				\n")
					.append("   A.check_date, 				 				\n")
					.append("   A.person_write_id, 			 				\n")
					.append("   C.user_nm, 					 				\n")
					.append("   A.person_approve_id, 		 				\n")
					.append("   C2.user_nm,				 	 				\n")
					.append("   A.unsuit_detail, 		 	 				\n")
					.append("   A.improve_action 		 	 				\n")
					.append("FROM											\n")
					.append("	haccp_meat_detail A							\n")
					.append("INNER JOIN tbm_users C							\n")
					.append("ON A.person_write_id = C.user_id				\n")
					.append("AND  A.check_date BETWEEN CAST(C.start_date AS DATE) AND CAST(C.duration_date AS DATE) \n")
					.append("LEFT JOIN tbm_users C2									\n")
					.append("ON A.person_approve_id = C2.user_id					\n")
					.append("AND  A.check_date BETWEEN CAST(C2.start_date AS DATE) AND CAST(C2.duration_date AS DATE) \n")
					.append("WHERE A.check_date BETWEEN '"+jObj.get("fromdate")+"' 	\n")
					.append("					   AND '"+jObj.get("todate")+"' 	\n")
					.append("GROUP BY A.check_date									\n")
					.toString();
			
			resultString = super.excuteQueryString(con, sql);
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M404S010100E104()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M404S010100E104()","==== finally ===="+ e.getMessage());
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
			
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			
			String checklist_id = jArray.get("checklist_id").toString();
			String sql = "";
			
			if(checklist_id.equals("checklist11")) {
				sql = new StringBuilder()
						.append("SELECT\n")
						.append("	A.seq_no,			 		 \n")
						.append("   A.ipgo_date, 				 \n")
						.append("   A.part_cd, 			 		 \n")
						.append("   A.part_rev_no, 				 \n")
						.append("   D.part_nm,					 \n")
						.append("   D.supplier,					 \n")
						.append("   E.expiration_date,			 \n")
						.append("   A.trace_key, 			 	 \n")
						.append("   A.visual_color, 			 \n")
						.append("   A.visual_smell, 			 \n")
						.append("   A.etc, 		 				 \n")
						.append("   A.car_clean, 		 		 \n")
						.append("   A.docs_yn,					 \n")
						.append("   A.bigo 		 	 			 \n")
						.append("FROM													\n")
						.append("	haccp_check_ipgo_part_detail A						\n")
						.append("INNER JOIN tbm_part_list D 							\n")
						.append("	ON A.part_cd = D.part_cd 							\n")
						.append("	AND A.part_rev_no = D.revision_no 					\n")
						.append("INNER JOIN tbi_part_storage2 E 						\n")
						.append("	ON A.part_cd = E.part_cd 							\n")
						.append("	AND A.part_rev_no = E.part_rev_no 					\n")
						.append("	AND A.trace_key = E.trace_key 						\n")
						.append("WHERE A.ipgo_date = '" + jArray.get("ipgo_date") + "' 	\n")
						.append("GROUP BY A.part_cd \n")
						.toString();
			}
			
			if(checklist_id.equals("checklist12")) {
				sql = new StringBuilder()
						.append("SELECT\n")
						.append("	A.seq_no,			 		 \n")
						.append("   A.check_date, 				 \n")
						.append("   A.part_cd, 			 		 \n")
						.append("   A.part_nm,					 \n")
						.append("   A.cust_nm, 				 	 \n")
						.append("   A.ipgo_amount, 				 \n")
						.append("   A.check_amount, 			 \n")
						.append("   A.color_yn, 			 	 \n")
						.append("   A.foreign_matter_yn, 		 \n")
						.append("   A.smell_yn, 			 	 \n")
						.append("   A.destroy_yn, 			 	 \n")
						.append("   A.meat_juice_yn, 			 \n")
						.append("   A.temp_part, 			 	 \n")
						.append("   A.temp_car, 			 	 \n")
						.append("   A.document1_yn,				 \n")
						.append("   A.document2_yn,				 \n")
						.append("   A.result,				 	 \n")
						.append("   A.unsuit_detail, 		 	 \n")
						.append("   A.improve_action 		 	 \n")
						.append("FROM													\n")
						.append("	haccp_meat_detail A									\n")
						.append("WHERE A.check_date = '" + jArray.get("ipgo_date") + "' \n")
						.append("GROUP BY A.part_cd \n")
						.toString();
			}

			resultString = super.excuteQueryString(con, sql);
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M838S070100E114()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) {
						con.close();
					}
				} catch (Exception e) {
					LoggingWriter.setLogError("M838S070100E114()","==== finally ===="+ e.getMessage());
				}
	    	}
	    }

		ioParam.setResultString(resultString);
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
    	ioParam.setMessage(MessageDefine.M_QUERY_OK);

    	return EventDefine.E_QUERY_RESULT;
	}
}

