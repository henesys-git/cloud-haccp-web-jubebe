package mes.frame.business.M303;

import java.lang.reflect.Method;
import java.sql.Connection;
import java.sql.PreparedStatement;

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


public class M303S020100 extends SqlAdapter{
	Connection con = null;
	PreparedStatement pstmt = null;
	String resultString = "";
	int resultInt = -1;
	StringBuffer sql = new StringBuffer();
	
	String[][] v_paramArray = new String[0][0]; 
	Class[] optClass = null;
	Object[] optObj = null;
	Object obj = null;
	
	public M303S020100(){
	}
	
	public int custParamCheck(InoutParameter ioParam, StringBuffer p_sql){
		int paramInt = 0;
		return paramInt;
	}

	public int paramCheck(InoutParameter ioParam, StringBuffer p_sql){
		v_paramArray = super.getParamCheck(ioParam,p_sql);
		return v_paramArray[0].length;
	}

	public int doExcute(InoutParameter ioParam){
		long startTime = System.currentTimeMillis();
		int doExcute_result = EventDefine.E_DOEXCUTE_INIT;;
		String event = ioParam.getEventSubID();
		
	    try{
            optClass = new Class[1];
			optClass[0] = ioParam.getClass();
			optObj = new Object[1];
			optObj[0] = ioParam;
			
			Method method = M303S020100.class.getMethod(event,optClass);
			LoggingWriter.setLogDebug(M303S020100.class.getName(),"==== " + event + " EventMethod Create Success ====");
			
			obj = method.invoke(M303S020100.class.newInstance(),optObj);
			doExcute_result = CommonFunction.getInt(obj.toString());
			
	    } catch (Exception ex) {
	    	doExcute_result = EventDefine.E_DOEXCUTE_INIT;
			ioParam.setMessage(MessageDefine.M_NO_EVENTID);
			LoggingWriter.setLogError(M303S020100.class.getName(),"==== EventID Not define : EVENT ID [ " + ioParam.getEventID() + "]");
	    } finally {
	    	obj = null;
			optClass = null;
			optObj = null;
	    }
	    long endTime = System.currentTimeMillis();
		long runningTime = endTime - startTime;
		LoggingWriter.setLogAll(M303S020100.class.getName(),"==== Query [수행시간  : " + runningTime + " ms]");
		
		return doExcute_result;
	}
	
	public int E001(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		int i = 0;
		String sql = "";
		
		try {
			con = JDBCConnectionPool.getConnection();
			con.setAutoCommit(false);
			
			JSONObject jObject = new JSONObject();
    		jObject = (JSONObject) ioParam.getInputHashObject().get("rcvData", HashObject.YES);
    		
    		// 생산계획일자
    		JSONArray tHead = (JSONArray) jObject.get("tHead");
    		JSONObject tHeadRow = (JSONObject) tHead.get(0);
    		String datePlan = (String) tHeadRow.get("datePlan");
    		
    		// 테이블 별 데이터 배열
			JSONArray tData1 = (JSONArray) jObject.get("tData1"); // 오전생산계획
			JSONArray tData2 = (JSONArray) jObject.get("tData2"); // 오후생산계획
			
			// 각 테이블 안의 데이터 Row
			JSONObject tData1Row;
			JSONObject tData2Row;
			
			sql = new StringBuilder()
					.append("INSERT INTO					\n")
					.append("	tbi_production_plan_daily (	\n")
					.append("		prod_plan_date,			\n")
					.append("		delyn					\n")
					.append("	)							\n")
					.append("VALUES							\n")
					.append("	(							\n")
					.append("		'" + datePlan + "',		\n")
					.append("		'N'						\n")
					.append("	);							\n")
					.toString();

			resultInt = super.excuteUpdate(con, sql);
			if (resultInt < 0) {
				ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
				con.rollback();
				return EventDefine.E_DOEXCUTE_ERROR;
			} 
			
			for(i = 0; i < tData1.size(); i++) {
				tData1Row = (JSONObject) tData1.get(i);
				
				sql = new StringBuilder()
						.append("INSERT INTO							\n")
						.append("	tbi_production_plan_daily_detail (	\n")
						.append("		prod_plan_date,					\n")
						.append("		prod_cd,						\n")
						.append("		prod_rev_no,					\n")
						.append("		plan_amount,					\n")
						.append("		plan_type						\n")
						.append("	)									\n")
						.append("VALUES									\n")
						.append("	(									\n")
						.append("		'" + datePlan + "',				\n")
						.append("		'" + tData1Row.get("col1") + "',\n")
						.append("		" + tData1Row.get("col2") + ",	\n")
						.append("		" + tData1Row.get("col4") + ",	\n")
						.append("   	(SELECT code_value			  	\n") 	//오전생산계획 코드
						.append("   	 FROM vtbm_code_book  			\n")
						.append("        WHERE code_cd ='PROD_PLAN_TYPE'\n")
						.append("    	   AND order_index = 1) 		\n")
						.append("	);									\n")
						.toString();

				resultInt = super.excuteUpdate(con, sql);
				if (resultInt < 0) {
					ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
					con.rollback();
					return EventDefine.E_DOEXCUTE_ERROR;
				} 
			}
			
			for(i = 0; i < tData2.size(); i++) {
				tData2Row = (JSONObject) tData2.get(i);
				
				sql = new StringBuilder()
						.append("INSERT INTO							\n")
						.append("	tbi_production_plan_daily_detail (	\n")
						.append("		prod_plan_date,					\n")
						.append("		prod_cd,						\n")
						.append("		prod_rev_no,					\n")
						.append("		plan_amount,					\n")
						.append("		plan_type						\n")
						.append(") VALUES (								\n")
						.append("		'" + datePlan + "',				\n")
						.append("		'" + tData2Row.get("col1") + "',\n")
						.append("		" + tData2Row.get("col2") + ",	\n")
						.append("		" + tData2Row.get("col4") + ",	\n")
						.append("   	(SELECT code_value  			\n") 	//오후생산계획 코드
						.append("    	 FROM vtbm_code_book  			\n")
						.append("        WHERE code_cd ='PROD_PLAN_TYPE'\n")
						.append(" 		   AND order_index = 2) 		\n")
						.append("	);									\n")
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
			LoggingWriter.setLogError("M303S020100.E001()","==== SQL ERROR ===="+ 
									  e.getMessage() + "\n" + sql);
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
			try {
				if (con != null) con.close();
			} catch (Exception e) {
			}
	    }
		ioParam.setResultString(resultString);
	    return EventDefine.E_QUERY_RESULT;
	}
	
	public int E002(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		int i = 0;
		String sql = "";
		
		try {
			con = JDBCConnectionPool.getConnection();
			con.setAutoCommit(false);
			
			JSONObject jObject = new JSONObject();
    		jObject = (JSONObject) ioParam.getInputHashObject().get("rcvData", HashObject.YES);
    		
    		// 생산계획일자 & 수정이력번호
    		JSONArray tHead = (JSONArray) jObject.get("tHead");
    		
    		JSONObject tHeadRow = (JSONObject) tHead.get(0);
    		JSONObject tHeadRow2 = (JSONObject) tHead.get(1);
    		
    		String datePlan = (String) tHeadRow.get("datePlan");
    		int planRevNo = Integer.parseInt((String) tHeadRow2.get("planRevNo"));
    		int addedPlanRevNo = planRevNo + 1;
    		System.out.println("생산계획수정이력번호: " + addedPlanRevNo);
    		
    		// 테이블 별 데이터 배열
			JSONArray tData1 = (JSONArray) jObject.get("tData1"); // 오전생산계획
			JSONArray tData2 = (JSONArray) jObject.get("tData2"); // 오후생산계획
			
			// 각 테이블 안의 데이터 Row
			JSONObject tData1Row;
			JSONObject tData2Row;
			
			sql = new StringBuilder()
					.append("INSERT INTO					\n")
					.append("	tbi_production_plan_daily (	\n")
					.append("		prod_plan_date,			\n")
					.append("		plan_rev_no,			\n")
					.append("		delyn					\n")
					.append("	)							\n")
					.append("VALUES							\n")
					.append("	(							\n")
					.append("		'" + datePlan + "',		\n")
					.append("		" + addedPlanRevNo + ",	\n")
					.append("		'N'						\n")
					.append("	);							\n")
					.toString();

			resultInt = super.excuteUpdate(con, sql);
			if (resultInt < 0) {
				ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
				con.rollback();
				return EventDefine.E_DOEXCUTE_ERROR;
			} 
			
			for(i = 0; i < tData1.size(); i++) {
				tData1Row = (JSONObject) tData1.get(i);
				
				sql = new StringBuilder()
						.append("INSERT INTO							\n")
						.append("	tbi_production_plan_daily_detail (	\n")
						.append("		prod_plan_date,					\n")
						.append("		plan_rev_no,					\n")
						.append("		prod_cd,						\n")
						.append("		prod_rev_no,					\n")
						.append("		plan_amount,					\n")
						.append("       plan_type						\n")
						.append("	)									\n")
						.append("VALUES									\n")
						.append("	(									\n")
						.append("		'" + datePlan + "',				\n")
						.append("		" + addedPlanRevNo + ",			\n")
						.append("		'" + tData1Row.get("col1") + "',\n")
						.append("		" + tData1Row.get("col2") + ",	\n")
						.append("		" + tData1Row.get("col4") + ",	\n")
						.append("   	(SELECT code_value			  	\n") 	//오전생산계획 코드
						.append("        FROM vtbm_code_book 			\n")
						.append("        WHERE code_cd ='PROD_PLAN_TYPE'\n")
						.append("    	   AND order_index = 1) 		\n")
						.append("	);									\n")
						.toString();

				resultInt = super.excuteUpdate(con, sql);
				if (resultInt < 0) {
					ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
					con.rollback();
					return EventDefine.E_DOEXCUTE_ERROR;
				} 
			}
			
			for(i = 0; i < tData2.size(); i++) {
				tData2Row = (JSONObject) tData2.get(i);
				
				sql = new StringBuilder()
						.append("INSERT INTO							\n")
						.append("	tbi_production_plan_daily_detail (	\n")
						.append("		prod_plan_date,					\n")
						.append("		plan_rev_no,					\n")
						.append("		prod_cd,						\n")
						.append("		prod_rev_no,					\n")
						.append("		plan_amount,					\n")
						.append("       plan_type						\n")
						.append(") VALUES (								\n")
						.append("		'" + datePlan + "',				\n")
						.append("		" + addedPlanRevNo + ",			\n")
						.append("		'" + tData2Row.get("col1") + "',\n")
						.append("		" + tData2Row.get("col2") + ",	\n")
						.append("		" + tData2Row.get("col4") + ",	\n")
						.append("   	(SELECT code_value				\n")	//오후생산계획 코드
						.append("   	 FROM vtbm_code_book  			\n")
						.append("        WHERE code_cd ='PROD_PLAN_TYPE'\n")
						.append("   	   AND order_index = 2) 		\n")
						.append("	);									\n")
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
			LoggingWriter.setLogError("M303S020100.E002()","==== SQL ERROR ===="+ 
									  e.getMessage() + "\n" + sql);
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
			try {
				if (con != null) con.close();
			} catch (Exception e) {
			}
	    }
		ioParam.setResultString(resultString);
	    return EventDefine.E_QUERY_RESULT;
	}
	
	public int E003(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		String sql = "";
		
		try {
			con = JDBCConnectionPool.getConnection();
			con.setAutoCommit(false);
			
			JSONObject jObj = new JSONObject();
    		jObj = (JSONObject) ioParam.getInputHashObject().get("rcvData", HashObject.YES);
    		
    		sql = new StringBuilder()
    				.append("DELETE FROM								\n")
    				.append("	tbi_production_plan_daily				\n")
    				.append("WHERE										\n")
    				.append("	prod_plan_date = '" + jObj.get("prodPlanDate") + "'	\n")
    				.toString();

			resultInt = super.excuteUpdate(con, sql);
			if (resultInt < 0) {
				ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
				con.rollback();
				return EventDefine.E_DOEXCUTE_ERROR;
			}
			
			sql = new StringBuilder()
    				.append("DELETE FROM								\n")
    				.append("	tbi_production_plan_daily_detail		\n")
    				.append("WHERE										\n")
    				.append("	prod_plan_date = '" + jObj.get("prodPlanDate") + "'	\n")
    				.toString();

			resultInt = super.excuteUpdate(con, sql);
			if (resultInt < 0) {
				ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
				con.rollback();
				return EventDefine.E_DOEXCUTE_ERROR;
			} 
			
			
			con.commit();
		} catch(Exception e) {
			LoggingWriter.setLogError("M303S020100.E003()","==== SQL ERROR ===="+ 
									  e.getMessage() + "\n" + sql);
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
			try {
				if (con != null) con.close();
			} catch (Exception e) {
			}
	    }
		ioParam.setResultString(resultString);
	    return EventDefine.E_QUERY_RESULT;
	}
	
	// yumsam, 메인 화면 조회
	public int E104(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArr = new JSONObject();
			jArr = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			
			String sql = new StringBuilder()
					.append("WITH data1 AS 													\n")
					.append("(																\n")
					.append("	SELECT 														\n")
					.append("	'오전생산계획' AS title,											\n")
					.append("	prod_plan_date,												\n")
					.append("	B.product_nm || ' : ' || plan_amount || '(ea)' AS content	\n")
					.append("	FROM tbi_production_plan_daily_detail a						\n")
					.append("	INNER JOIN tbm_product b									\n")
					.append("		ON  a.prod_cd = b.prod_cd								\n")
					.append("		AND a.prod_rev_no = b.revision_no						\n")
					.append("	WHERE plan_rev_no = (SELECT MAX(plan_rev_no) 				\n")
					.append("	       				 FROM tbi_production_plan_daily_detail c 	\n")
					.append("	       				 WHERE a.prod_plan_date = c.prod_plan_date)	\n")
					.append("   AND plan_type = (SELECT code_value FROM vtbm_code_book  	\n") 	//오전생산계획 코드
					.append("                       WHERE code_cd ='PROD_PLAN_TYPE' 	   	\n")
					.append("                       AND order_index = 1) 				   	\n")
					.append("UNION ALL														\n")
					.append("	SELECT 														\n")
					.append("	'오후생산계획' AS title,											\n")
					.append("	prod_plan_date,												\n")
					.append("	B.product_nm || ' : ' || plan_amount || '(ea)' AS content	\n")
					.append("	FROM tbi_production_plan_daily_detail a						\n")
					.append("	INNER JOIN tbm_product b									\n")
					.append("		ON  a.prod_cd = b.prod_cd								\n")
					.append("		AND a.prod_rev_no = b.revision_no						\n")
					.append("	WHERE plan_rev_no = (SELECT MAX(plan_rev_no) 				\n")
					.append("	       				 FROM tbi_production_plan_daily_detail c    \n")
					.append("	       				 WHERE a.prod_plan_date = c.prod_plan_date)	\n")
					.append("   AND plan_type = (SELECT code_value FROM vtbm_code_book  	\n") 	//오후생산계획 코드
					.append("                       WHERE code_cd ='PROD_PLAN_TYPE' 	   	\n")
					.append("                       AND order_index = 2) 				   	\n")
					.append("),																\n")
					.append("data2 AS 														\n")
					.append("(																\n")
					.append("	SELECT 														\n")
					.append("		'오전생산계획' AS title,									\n")
					.append("		prod_plan_date,											\n")
					.append("		plan_rev_no												\n")
					.append("	FROM tbi_production_plan_daily_detail a						\n")
					.append("	WHERE plan_rev_no = (SELECT MAX(plan_rev_no) 				\n")
					.append("	       							FROM tbi_production_plan_daily_detail b 					\n")
					.append("	       							WHERE a.prod_plan_date = b.prod_plan_date)					\n")
					.append("   AND plan_type = (SELECT code_value FROM vtbm_code_book  	\n") 	//오전생산계획 코드
					.append("                       WHERE code_cd ='PROD_PLAN_TYPE' 	   	\n")
					.append("                       AND order_index = 1) 				   	\n")
					.append("UNION ALL														\n")
					.append("	SELECT 														\n")
					.append("		'오후생산계획' AS title,									\n")
					.append("		prod_plan_date,											\n")
					.append("		plan_rev_no												\n")
					.append("	FROM tbi_production_plan_daily_detail a						\n")
					.append("	WHERE plan_rev_no = (SELECT MAX(plan_rev_no) 				\n")
					.append("	       							FROM tbi_production_plan_daily_detail b \n")
					.append("	       							WHERE a.prod_plan_date = b.prod_plan_date)	\n")
					.append("   AND plan_type = (SELECT code_value FROM vtbm_code_book  	\n") 	//오후생산계획 코드
					.append("                       WHERE code_cd ='PROD_PLAN_TYPE' 	   	\n")
					.append("                       AND order_index = 2) 				   	\n")
					.append("),																\n")
					.append("finaldata AS													\n")
					.append("(																\n")
					.append("SELECT 														\n")
					.append("	prod_plan_date,												\n")
					.append("	plan_rev_no,												\n")
					.append("	'오전생산계획' AS title,										\n")
					.append("	LIST(SELECT content FROM data1 a WHERE a.title = '오전생산계획' AND a.prod_plan_date = b.prod_plan_date) AS description\n")
					.append("FROM data2 b\n")
					.append("WHERE prod_plan_date BETWEEN '"+jArr.get("start")+"' AND '"+jArr.get("end")+"'	\n")
					.append("GROUP BY prod_plan_date										\n")
					.append("UNION ALL														\n")
					.append("SELECT 														\n")
					.append("	prod_plan_date,												\n")
					.append("	plan_rev_no,												\n")
					.append("	'오후생산계획' AS title,										\n")
					.append("	LIST(SELECT content FROM data1 a WHERE a.title = '오후생산계획' AND a.prod_plan_date = b.prod_plan_date) AS description\n")
					.append("FROM data2 b													\n")
					.append("WHERE prod_plan_date BETWEEN '"+jArr.get("start")+"' AND '"+jArr.get("end")+"'	\n")
					.append("GROUP BY prod_plan_date\n")
					//.append("ORDER BY prod_plan_date\n")
					.append(")\n")
					// 여기까지 WITH절 끝 (data1, data2, finaldata)
					.append("SELECT a.* 									\n")
					.append("FROM finaldata a								\n")
					.append("INNER JOIN tbi_production_plan_daily b			\n")
					.append("	ON a.prod_plan_date = b.prod_plan_date		\n")
					.append("	AND a.plan_rev_no = b.plan_rev_no			\n")
					.append("WHERE b.delyn != 'Y'							\n")
					.append(";												\n")
					.toString();
			
			String ActionCommand = ioParam.getActionCommand();
			if(ActionCommand.startsWith("doQueryTableFieldName")) {
				resultString = super.excuteQueryStringTableFieldName(con, sql);
			} else {
				resultString = super.excuteQueryString(con, sql);
			}
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M303S020100E104()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M303S020100E104()","==== finally ===="+ e.getMessage());
				}
	    	}
	    }
		ioParam.setResultString(resultString);
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
    	ioParam.setMessage(MessageDefine.M_QUERY_OK);
	    return EventDefine.E_QUERY_RESULT;
	}
	
	// yumsam, 수정할 생산계획 정보 조회
	public int E124(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArr = new JSONObject();
			jArr = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			
			String sql = new StringBuilder()
					.append("SELECT \n")
					.append("	't1' AS table_no,											\n")
					.append("	a1.prod_plan_date,											\n")
					.append("	a1.plan_rev_no,												\n")
					.append("	a3.product_nm AS content1,									\n")
					.append("	a1.prod_cd AS subkey1,										\n")
					.append("	a1.prod_rev_no AS subkey2,									\n")
					.append("	a3.gugyuk AS content2,										\n")
					.append("	TO_CHAR(a1.plan_amount) AS content3,						\n")
					.append("	NULL AS content4											\n")
					.append("FROM tbi_production_plan_daily_detail a1						\n")
					.append("INNER JOIN tbi_production_plan_daily a2						\n")
					.append("	ON a1.prod_plan_date = a2.prod_plan_date					\n")
					.append("	AND a1.plan_rev_no = a2.plan_rev_no							\n")
					.append("INNER JOIN tbm_product a3										\n")
					.append("	ON a3.prod_cd = a1.prod_cd									\n")
					.append("	AND a3.revision_no = a1.prod_rev_no							\n")
					.append("WHERE a1.prod_plan_date = '"+jArr.get("selectedDate")+"'		\n")
//					.append("	AND a1.plan_rev_no = (SELECT MAX(plan_rev_no) \n")
//					.append("						  FROM tbi_production_plan_daily_detail a4 \n")
//					.append("						  WHERE a4.prod_plan_date = a1.prod_plan_date)\n")
					.append("	AND a1.plan_rev_no = "+jArr.get("planRevNo")+" 				\n")
					.append("   AND a1.plan_type = (SELECT code_value FROM vtbm_code_book  	\n") //오전생산계획 코드
					.append("                       WHERE code_cd ='PROD_PLAN_TYPE' 	   	\n")
					.append("                       AND order_index = 1) 				   	\n")
					.append("UNION ALL														\n")
					.append("SELECT															\n")
					.append("	't2' AS table_no,											\n")
					.append("	a1.prod_plan_date,											\n")
					.append("	a1.plan_rev_no,												\n")
					.append("	a3.product_nm AS content1,									\n")
					.append("	a1.prod_cd AS subkey1,										\n")
					.append("	a1.prod_rev_no AS subkey2,									\n")
					.append("	a3.gugyuk AS content2,										\n")
					.append("	TO_CHAR(a1.plan_amount) AS content3,						\n")
					.append("	NULL AS content4											\n")
					.append("FROM tbi_production_plan_daily_detail a1						\n")
					.append("INNER JOIN tbi_production_plan_daily a2						\n")
					.append("	ON a1.prod_plan_date = a2.prod_plan_date					\n")
					.append("	AND a1.plan_rev_no = a2.plan_rev_no							\n")
					.append("INNER JOIN tbm_product a3										\n")
					.append("	ON a3.prod_cd = a1.prod_cd									\n")
					.append("	AND a3.revision_no = a1.prod_rev_no							\n")
					.append("WHERE a1.prod_plan_date = '"+jArr.get("selectedDate")+"'		\n")
//					.append("	AND a1.plan_rev_no = (SELECT MAX(plan_rev_no) \n")
//					.append("						  FROM tbi_production_plan_daily_detail a4 \n")
//					.append("						  WHERE a4.prod_plan_date = a1.prod_plan_date)\n")
					.append("	AND a1.plan_rev_no = "+jArr.get("planRevNo")+" 				\n")
					.append("   AND a1.plan_type = (SELECT code_value FROM vtbm_code_book  	\n") //오후생산계획 코드
					.append("                       WHERE code_cd ='PROD_PLAN_TYPE' 	   	\n")
					.append("                       AND order_index = 2) 				   	\n")
					.append(";																\n")
					.toString();
			
			String ActionCommand = ioParam.getActionCommand();
			if(ActionCommand.startsWith("doQueryTableFieldName")) {
				resultString = super.excuteQueryStringTableFieldName(con, sql);
			} else {
				resultString = super.excuteQueryString(con, sql);
			}
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M303S020100E124()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M303S020100E124()","==== finally ===="+ e.getMessage());
				}
	    	} else {
	    	}
	    }
		ioParam.setResultString(resultString);
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
    	ioParam.setMessage(MessageDefine.M_QUERY_OK);
	    return EventDefine.E_QUERY_RESULT;
	}
	
	// yumsam, 
	// 해당 날짜에 등록된 생산계획 있는지 여부 조회
	public int E134(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArr = new JSONObject();
			jArr = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			
			String sql = new StringBuilder()
					.append("SELECT\n")
					.append("	COUNT(*)\n")
					.append("FROM\n")
					.append("	tbi_production_plan_daily\n")
					.append("WHERE\n")
					.append("	prod_plan_date = '" + jArr.get("selectedDate") + "'\n")
					.toString();
			
			resultString = super.excuteQueryString(con, sql);
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M303S020100E134()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M303S020100E134()","==== finally ===="+ e.getMessage());
				}
	    	} else {
	    	}
	    }
		ioParam.setResultString(resultString);
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
    	ioParam.setMessage(MessageDefine.M_QUERY_OK);
	    return EventDefine.E_QUERY_RESULT;
	}
	
	//현재고량 조회 페이지
	public int E010(InoutParameter ioParam) {
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			
			String sql = new StringBuilder()
							.append("SELECT								\n")
							.append("A.product_nm, 						\n")
							.append("A.safe_stock, 						\n")
							.append("SUM(B.post_amt) AS post_amt 		\n")
							.append("FROM								\n")
							.append("		 tbm_product A 				\n")
							.append("INNER JOIN tbi_prod_storage2 B		\n")
							.append("ON A.prod_cd = B.prod_cd 			\n")
							.append("GROUP BY A.product_nm  			\n")
							.toString();
			
			resultString = super.excuteQueryString(con, sql.toString());
		} catch(Exception e){
			e.printStackTrace();
			LoggingWriter.setLogError("M303S020100E010()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR;
		} finally {
			if(Config.useDataSource) {
				try {
					if(con != null) con.close();
				}catch(Exception e) {
					LoggingWriter.setLogError("M303S020100E010()","==== finally ====" + e.getMessage());
				}
			} else {
			}
		}
		
		ioParam.setResultString(resultString);
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
		ioParam.setMessage(MessageDefine.M_QUERY_OK);
	    return EventDefine.E_QUERY_RESULT;
	}
	
	//원료배합일지 메인페이지
	public int E020(InoutParameter ioParam) {
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			
			String sql = new StringBuilder()
				.append("SELECT														\n")
				.append("	B.product_nm, 											\n")
				.append("	A.prod_cd,												\n")
				.append("	A.manufacturing_date, 									\n")
				.append("	D.user_nm, 												\n")
				.append("	SUM(C.blending_amount_real),							\n")
				.append(" 	'',														\n")
				.append(" 	''														\n")
				.append("FROM														\n")
				.append("	tbi_production_request A								\n")
				.append("INNER JOIN tbm_product B									\n")
				.append("	ON A.prod_cd = B.prod_cd 								\n")
				.append("INNER JOIN tbi_production_request_detail C 				\n")
				.append("	ON A.prod_cd = C.prod_cd 								\n")
				.append("	AND A.prod_rev_no = C.prod_rev_no 						\n")
				.append("	AND A.manufacturing_date = C.manufacturing_date 		\n")
				.append("INNER JOIN tbm_users D 									\n")
				.append("	ON A.user_id = D.user_id 								\n")
				.append("WHERE A.manufacturing_date = '"+ jArray.get("toDate") + "'	\n")
				.append("	AND A.work_status = '확인' 								\n")
				.append("GROUP BY A.prod_cd 										\n")
				.append("ORDER BY A.prod_cd 										\n")
				.toString();
			
			resultString = super.excuteQueryString(con, sql.toString());
		} catch(Exception e){
			e.printStackTrace();
			LoggingWriter.setLogError("M303S020100E020()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR;
		} finally {
			if(Config.useDataSource) {
				try {
					if(con != null) con.close();
				}catch(Exception e) {
					LoggingWriter.setLogError("M303S020100E020()","==== finally ====" + e.getMessage());
				}
			} else {
			}
		}
		
		ioParam.setResultString(resultString);
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
		ioParam.setMessage(MessageDefine.M_QUERY_OK);
	    return EventDefine.E_QUERY_RESULT;
	}
	
	//원료배합일지 상세페이지
	public int E030(InoutParameter ioParam) {
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			
			String sql = new StringBuilder()
				.append("SELECT																		\n")
				.append("	b.part_nm, 																\n")
				.append("	A.blending_amount_real, 												\n")
				.append("	A.reason_diff 															\n")
				.append("FROM tbi_production_request_detail A 										\n")
				.append("INNER JOIN tbm_part_list B													\n")
				.append("	ON A.part_cd = B.part_cd 												\n")
				.append("INNER JOIN tbi_production_request C										\n")
				.append("	ON A.prod_cd = C.prod_cd												\n")
				.append("   AND A.prod_rev_no = C.prod_rev_no 										\n")
				.append(" 	AND A.manufacturing_date = C.manufacturing_date 						\n")
				.append("WHERE A.prod_cd = '"+ jArray.get("prod_cd")+ "' 							\n")
				.append("	AND A.manufacturing_date = '" + jArray.get("manufacturing_date") +"'	\n")
				.append("GROUP BY B.part_nm 														\n")
				.append("ORDER BY A.prod_cd 														\n")
				.toString();
			
			resultString = super.excuteQueryString(con, sql.toString());
		} catch(Exception e){
			e.printStackTrace();
			LoggingWriter.setLogError("M303S020100E030()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR;
		} finally {
			if(Config.useDataSource) {
				try {
					if(con != null) con.close();
				}catch(Exception e) {
					LoggingWriter.setLogError("M303S020100E030()","==== finally ====" + e.getMessage());
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