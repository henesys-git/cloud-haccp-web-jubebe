package mes.frame.business.M808;

import java.lang.reflect.Method;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.util.Iterator;

import org.apache.log4j.Logger;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;

import mes.client.conf.Config;
import mes.client.conf.ProjectConstants;
import mes.frame.common.EventDefine;
import mes.frame.common.HashObject;
import mes.frame.common.MessageDefine;
import mes.frame.database.JDBCConnectionPool;
import mes.frame.database.SqlAdapter;
import mes.frame.serviceinterface.InoutParameter;
import mes.frame.serviceinterface.LoggingWriter;
import mes.frame.util.CommonFunction;


/**
 * 개요 : 이벤트ID별 메소드 정의
 */
public class M808S010200 extends SqlAdapter {
	static final Logger logger = Logger.getLogger(M808S010200.class.getName());
	
	Connection con = null;
	PreparedStatement pstmt = null;
	String resultString = "";
	int resultInt = -1;
	StringBuffer sql = new StringBuffer();
	
	String[][] v_paramArray = new String[0][0]; 
	Class[] optClass = null;
	Object[] optObj = null;
	Object obj = null;
	
	public M808S010200(){
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
	public int doExcute(InoutParameter ioParam){
		long startTime = System.currentTimeMillis();
		int doExcute_result = EventDefine.E_DOEXCUTE_INIT;;
		String event = ioParam.getEventSubID();

	    try{
            optClass = new Class[1];
			optClass[0] = ioParam.getClass() ;
			optObj = new Object[1];
			optObj[0] = ioParam;
			
			Method method = M808S010200.class.getMethod(event,optClass);
			LoggingWriter.setLogDebug(M808S010200.class.getName(),"==== " + event + " EventMethod Create Success ====");

			obj = method.invoke(M808S010200.class.newInstance(),optObj);
			doExcute_result = CommonFunction.getInt(obj.toString());
			
	    } catch (Exception ex) {
	    	doExcute_result = EventDefine.E_DOEXCUTE_INIT;
			ioParam.setMessage(MessageDefine.M_NO_EVENTID);
			LoggingWriter.setLogError(M808S010200.class.getName(),"==== EventID Not define : EVENT ID [ " + ioParam.getEventID() + "]");
	    } finally {
	    	obj = null;
			optClass = null;
			optObj = null;
	    }
	    long endTime = System.currentTimeMillis();
		long runningTime = endTime - startTime;
		logger.debug("Query [수행시간  : " + runningTime + " ms]");
		
		return doExcute_result;
	}
	
	// yumsam
	// 금속검출기 테스트 헤드 데이터 조회
	public int E104(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jo = new JSONObject();
			jo = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			
			String sql = new StringBuilder()
					.append("SELECT                                           \n")
					.append("	P.product_nm,                                 \n")
					.append("	M.detect_time,                                \n")
					.append("	U.user_nm                                     \n")
					.append("FROM haccp_censor_metal M                        \n")
					.append("INNER JOIN haccp_censor_metal_detail MD          \n")
					.append("	ON M.detect_date = MD.detect_date             \n")
					.append("	AND M.detect_time = MD.detect_time            \n")
					.append("INNER JOIN tbm_product P                         \n")
					.append("	ON M.prod_cd = P.prod_cd                      \n")
					.append("	AND M.prod_rev_no = P.revision_no             \n")
					.append("LEFT JOIN tbm_users U                            \n")
					.append("	ON U.user_id = MD.user_id                     \n")
					.append("	AND U.revision_no = MD.user_rev_no            \n")
					.append("WHERE M.detect_date = '"+jo.get("ccp_date")+"'   \n")
					.append("GROUP BY M.detect_time                           \n")
					.append("ORDER BY M.detect_time ASC;                      \n")
					.toString();

			resultString = super.excuteQueryString(con, sql);
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M808S010200E104()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M808S010200E104()","==== finally ===="+ e.getMessage());
				}
	    	} else {
	    	}
	    }
		ioParam.setResultString(resultString);
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
    	ioParam.setMessage(MessageDefine.M_QUERY_OK);
	    
    	return EventDefine.E_QUERY_RESULT;
	}
	
	// yumsam
	// 금속검출기 테스트 상세 데이터 조회
	public int E105(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jo = new JSONObject();
			jo = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			
			String sql = new StringBuilder()
					.append("SELECT                                               \n")
					.append("	DISTINCT(time_format(detect_time, '%H : %i')),    \n")
					.append("	LIST(		                                      \n")
					.append("		   SELECT test_result                         \n")
					.append("		   FROM haccp_censor_metal_detail t1          \n")
					.append("		   WHERE t1.detect_time = t0.detect_time      \n")
					.append("		  	   AND t1.test_type = 'FE'                \n")
					.append("		   UNION ALL                                  \n")
					.append("		   SELECT test_result                         \n")
					.append("		   FROM haccp_censor_metal_detail t1          \n")
					.append("		   WHERE t1.detect_time = t0.detect_time      \n")
					.append("		  	   AND t1.test_type = 'SUS'               \n")
					.append("		   UNION ALL                                  \n")
					.append("		   SELECT test_result                         \n")
					.append("		   FROM haccp_censor_metal_detail t1          \n")
					.append("		   WHERE t1.detect_time = t0.detect_time      \n")
					.append("		  	   AND t1.test_type = 'PROD'              \n")
					.append("		   UNION ALL                                  \n")
					.append("		   SELECT test_result                         \n")
					.append("		   FROM haccp_censor_metal_detail t1          \n")
					.append("		   WHERE t1.detect_time = t0.detect_time      \n")
					.append("		  	   AND t1.test_type = 'FE+PROD'           \n")
					.append("		   UNION ALL                                  \n")
					.append("		   SELECT test_result                         \n")
					.append("		   FROM haccp_censor_metal_detail t1          \n")
					.append("		   WHERE t1.detect_time = t0.detect_time      \n")
					.append("		  	   AND t1.test_type = 'SUS+PROD'          \n")
					.append("		  )                                           \n")
					.append("FROM haccp_censor_metal_detail t0                    \n")
					.append("WHERE detect_date = '"+jo.get("ccp_date")+"';  	  \n")
					.toString();
			
			resultString = super.excuteQueryString(con, sql);
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M808S010200E105()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR;
		} finally {
			if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M808S010200E105()","==== finally ===="+ e.getMessage());
				}
			} else {
			}
		}
		ioParam.setResultString(resultString);
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
		ioParam.setMessage(MessageDefine.M_QUERY_OK);
		
		return EventDefine.E_QUERY_RESULT;
	}
	
	// 금속검출기 테스트 데이터 입력
	public int E101(InoutParameter ioParam){ 
		resultInt = EventDefine.E_DOEXCUTE_INIT;

		try {
			con = JDBCConnectionPool.getConnection();
			con.setAutoCommit(false);
			
			String sql;
			
			JSONParser parser = new JSONParser();
			JSONObject jHead = new JSONObject();
			jHead = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			
			JSONArray jBody = (JSONArray) parser.parse(jHead.get("body").toString());
			String userId = jHead.get("userId").toString(); 
			
			sql = new StringBuilder()
					.append("INSERT INTO														\n")
					.append("	haccp_censor_metal (											\n")
					.append("		detect_date,												\n")
					.append("		detect_time,												\n")
					.append("		censor_no,													\n")
					.append("		censor_rev_no,												\n")
					.append("		prod_cd,													\n")
					.append("		prod_rev_no,												\n")
					.append("		detect_type													\n")
					.append("	)																\n")
					.append("VALUES																\n")
					.append("	(																\n")
					.append("		SYSDATE,													\n")
					.append("		'"+jHead.get("startTime")+"',								\n")
					.append("		'"+ProjectConstants.METAL_DETECTOR+"',						\n")
					.append("		(SELECT MAX(censor_rev_no)									\n")
					.append("		 FROM haccp_censor_info										\n")
					.append("		 WHERE censor_no = '"+ProjectConstants.METAL_DETECTOR+"'),	\n")
					.append("		'"+jHead.get("prodCd")+"',									\n")
					.append("		(SELECT MAX(revision_no)									\n")
					.append("		 FROM tbm_product											\n")
					.append("		 WHERE prod_cd = '"+jHead.get("prodCd")+"'),				\n")
					.append("		'"+jHead.get("isTest")+"'									\n")
					.append("	);																\n")
					.toString();
			
			resultInt = super.excuteUpdate(con, sql);
    		if (resultInt < 0) {
				ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
				con.rollback();
				return EventDefine.E_DOEXCUTE_ERROR ;
			}
    		
	        Iterator<?> it = jBody.iterator();
	        
	        // body의  키 값들이 1씩 증가 되어서 필요한 값
	        // testmaterial1, testmaterial2 ...
	        // position1, position2, position3 ...
	        int num = 0;
	        
	        // haccp_censor_metal_detail의 키 값 중 하나
	        // 검출일자, 검출시간이 같은 데이터의 중복 방지용
	        int seqNo = 0;
	        
	        while (it.hasNext()) {
	        	JSONObject jo = (JSONObject) it.next();
	            
	        	String testType = (String) jo.get("testmaterial" + num);
	            String position = (String) jo.get("position" + num);
	            String result = (String) jo.get("result" + num);
	            
	            sql = new StringBuilder()
						.append("INSERT INTO								\n")
						.append("	haccp_censor_metal_detail (				\n")
						.append("		detect_date,						\n")
						.append("		detect_time,						\n")
						.append("		seq_no,								\n")
						.append("		test_type,							\n")
						.append("		test_position,						\n")
						.append("		test_result,						\n")
						.append("		user_id,							\n")
						.append("		user_rev_no							\n")
						.append("	)										\n")
						.append("VALUES										\n")
						.append("	(										\n")
						.append("		SYSDATE,							\n")
						.append("		'" + jHead.get("startTime")+"',		\n")
						.append("		" + seqNo + ",						\n")
						.append("		'" + testType +"',					\n")
						.append("		'" + position +"',					\n")
						.append("		'" + result +"',					\n")
						.append("		'" + userId +"',					\n")
						.append("		(SELECT MAX(revision_no)			\n")
						.append("		 FROM tbm_users						\n")
						.append("		 WHERE user_id = '" + userId + "')	\n")
						.append("	);										\n")
						.toString();
	    			
    			resultInt = super.excuteUpdate(con, sql);
        		if (resultInt < 0) {
    				ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
    				con.rollback();
    				return EventDefine.E_DOEXCUTE_ERROR ;
    			}
        		
        		seqNo++;
	        	num++;
	        }
    		
			con.commit();
		} catch(Exception e) {
			LoggingWriter.setLogError("M808S010200E101()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M808S010200E101()","==== finally ===="+ e.getMessage());
				}
	    	} else {
	    	}
	    }
		ioParam.setResultString(resultString);
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
    	ioParam.setMessage(MessageDefine.M_QUERY_OK);
	    return EventDefine.E_QUERY_RESULT;
	}
	
	// 금속검출기 테스트 헤드 데이터 조회
	public int E114(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jo = new JSONObject();
			jo = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			
			String breakVal = jo.get("checkBreakaway").toString().trim();
			String improve_action = ", E.code_name AS improve_action, \n U.user_nm AS person_approve_id \n";
			
			if("0".equals(breakVal)) {	// 정상
				breakVal = "AND test_result = 'O'";
				improve_action = "";
			} else if("1".equals(breakVal)) {	// 이탈
				breakVal = "AND test_result = 'X'";
			} else {	// 전체
				improve_action = ",DECODE(test_result, 'O', '정상', '이탈')"; //status
			}
			
			String sql = new StringBuilder()
					.append("SELECT 														\n")
					.append("	A.detect_date,												\n")
					.append("	A.detect_time,												\n")
					.append("	D.seq_no,													\n")
					.append("	B.censor_name,												\n")
					.append("	A.prod_nm,													\n")
					.append("	A.detect_type,												\n")
					.append("	D.test_type,												\n")
					.append("	D.test_position,											\n")
					.append("	D.test_result												\n")
					.append("	"+improve_action+"											\n")
					.append("FROM haccp_censor_metal A										\n")
					.append("INNER JOIN haccp_censor_info B									\n")
					.append("	ON A.censor_no = B.censor_no								\n")
					.append("	AND A.censor_rev_no = B.censor_rev_no						\n")
					.append("INNER JOIN haccp_censor_metal_detail D							\n")
					.append("	ON A.detect_date = D.detect_date							\n")
					.append("	AND A.detect_time = D.detect_time							\n")
					.append("LEFT JOIN tbm_code_book E										\n")
					.append("	ON D.improve_action = E.code_value							\n")
					.append("LEFT JOIN tbm_users U											\n")
					.append("	ON D.person_approve_id = U.user_id							\n")
					.append("	AND A.detect_date BETWEEN U.start_date AND U.duration_date	\n")
					.append("WHERE A.detect_date BETWEEN '"+ jo.get("startDate") +"'		\n")
					.append("						 AND '"+ jo.get("endDate") +"'			\n")
					.append("  AND B.censor_name LIKE '"+ jo.get("metalName") +"%'			\n")
					.append(" 	"+ breakVal +"												\n")
					.toString();

			resultString = super.excuteQueryString(con, sql);
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M808S010200E114()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M808S010200E114()","==== finally ===="+ e.getMessage());
				}
	    	} else {
	    	}
	    }
		ioParam.setResultString(resultString);
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
    	ioParam.setMessage(MessageDefine.M_QUERY_OK);
	    
    	return EventDefine.E_QUERY_RESULT;
	}
	
	// 0607 서승헌
	// 금속검출기 테스트 데이터 수동 입력
	public int E111(InoutParameter ioParam){ 
		resultInt = EventDefine.E_DOEXCUTE_INIT;

		try {
			con = JDBCConnectionPool.getConnection();
			con.setAutoCommit(false);
			
			String sql;
			
			JSONObject jObj = new JSONObject();
    		jObj = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
						
    		String startTime = jObj.get("dateTime").toString().substring(11);
    		System.out.println("ProjectConstants.METAL_DETECTOR : " + ProjectConstants.METAL_DETECTOR);
    		String isTest = jObj.get("isTest").toString();
    		String metalDetectorId = jObj.get("metalDetectorId").toString();
    		
			sql = new StringBuilder()
					.append("INSERT INTO														\n")
					.append("	haccp_censor_metal (											\n")
					.append("		detect_date,												\n")
					.append("		detect_time,												\n")
					.append("		censor_no,													\n")
					.append("		censor_rev_no,												\n")
					.append("		prod_nm,													\n")
					.append("		detect_type													\n")
					.append("	)																\n")
					.append("VALUES																\n")
					.append("	(																\n")
					.append("		SYSDATE,													\n")
					.append("		'" + startTime + "',										\n")
					.append("		'" + metalDetectorId + "',			\n")
					.append("		(SELECT MAX(censor_rev_no)									\n")
					.append("		 FROM haccp_censor_info										\n")
					.append("		 WHERE censor_no = '" + jObj.get("metalDetectorId").toString() + "'),	\n")
					.append("		'" + jObj.get("prodName").toString() + "',					\n")
					.append("		'" + isTest + "'						\n")
					.append("	);																\n")
					.toString();
			
			resultInt = super.excuteUpdate(con, sql);
    		if (resultInt < 0) {
				ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
				con.rollback();
				return EventDefine.E_DOEXCUTE_ERROR ;
			}
    		
    		sql = new StringBuilder()
				.append("SELECT ccp_date\n")
				.append("FROM haccp_ccp_2p\n")
				.append("WHERE ccp_date = SYSDATE\n")
				.append("ORDER BY ccp_date DESC FOR ORDERBY_NUM() = 1\n")
				.toString();

    		resultString = super.excuteQueryString(con, sql);
    		
    		if(resultString.length() == 0 
    				&& "metal_detector01".equals(metalDetectorId)
    				&& isTest.equals("T")) {
    			
    			sql = new StringBuilder()
					.append("INSERT INTO\n")
					.append("	haccp_ccp_2p (\n")
					.append("		ccp_date,\n")
					.append("		checklist_id,\n")
					.append("		checklist_rev_no,\n")
					.append("		person_write_id\n")
					.append("	)\n")
					.append("VALUES\n")
					.append("	(\n")
					.append("		SYSDATE,\n")
					.append("		'checklist03',\n")
					.append("		(SELECT MAX(checklist_rev_no)\n")
					.append("		 FROM checklist	\n")
					.append("		 WHERE checklist_id = 'checklist03'),\n")
					.append("		'" + jObj.get("userId").toString() +"'\n")
					.append("	)\n")
					.toString();

    			resultInt = super.excuteUpdate(con, sql);
        		if (resultInt < 0) {
    				ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
    				con.rollback();
    				return EventDefine.E_DOEXCUTE_ERROR ;
    			}
    			
    		}
    		
			JSONArray row = new JSONArray();
			row = (JSONArray) jObj.get("row");
    		
			String ccpData = "";
			for(int i = 0; i < row.size(); i++) {
				
				int seqNo = i;
				
				JSONObject rowData = (JSONObject) row.get(i);
				
				String testType = (String) rowData.get("type" + (row.size()-(i+1)));
	            String position = (String) rowData.get("position" + (row.size()-(i+1)));
	            String result = (String) rowData.get("result" + (row.size()-(i+1)));

	            sql = new StringBuilder()
						.append("INSERT INTO								\n")
						.append("	haccp_censor_metal_detail (				\n")
						.append("		detect_date,						\n")
						.append("		detect_time,						\n")
						.append("		seq_no,								\n")
						.append("		test_type,							\n")
						.append("		test_position,						\n")
						.append("		test_result,						\n")
						.append("		user_id,							\n")
						.append("		user_rev_no							\n")
						.append("	)										\n")
						.append("VALUES										\n")
						.append("	(										\n")
						.append("		SYSDATE,							\n")
						.append("		'" + startTime +"',					\n")
						.append("		'" + seqNo +"',						\n")
						.append("		'" + testType +"',					\n")
						.append("		'" + position +"',					\n")
						.append("		'" + result +"',					\n")
						.append("		'" + jObj.get("userId").toString() +"',			\n")
						.append("		(SELECT MAX(revision_no)			\n")
						.append("		 FROM tbm_users						\n")
						.append("		 WHERE user_id = '" + jObj.get("userId").toString() + "')	\n")
						.append("	)										\n")
						.toString();
	    			
    			resultInt = super.excuteUpdate(con, sql);
        		if (resultInt < 0) {
    				ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
    				con.rollback();
    				return EventDefine.E_DOEXCUTE_ERROR ;
    			}
	            
        		ccpData += result.trim();
        		String ccpResult = "O";
        		
        		if("metal_detector01".equals(metalDetectorId) && isTest.equals("T")) {
        			if((i+1) == row.size()/2) {
            			String[] strArr = ccpData.split("");
            			for(String str : strArr) {
            				if("X".equals(str)) { ccpResult = "X"; }
            			}
            			sql = new StringBuilder()
        					.append("INSERT INTO\n")
        					.append("	haccp_ccp_2p_detail (\n")
        					.append("		check_time,\n")
        					.append("		ccp_date,\n")
        					.append("		prod_nm,\n")
        					.append("		"+testType.toLowerCase().split("_")[0]+"_result,\n")
        					.append("		censor_no\n")
        					.append("	)\n")
        					.append("VALUES\n")
        					.append("	(\n")
        					.append("		TIME '" + startTime + "',\n")
        					.append("		SYSDATE,\n")
        					.append("		'" + jObj.get("prodName").toString() + "',\n")
    						.append("		'" + ccpResult +"',					\n")
        					.append("		'" + jObj.get("metalDetectorId").toString() + "'\n")
        					.append("	)\n")
        					.toString();

            			resultInt = super.excuteUpdate(con, sql);
                		if (resultInt < 0) {
            				ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
            				con.rollback();
            				return EventDefine.E_DOEXCUTE_ERROR ;
            			}
                		ccpData = "";
            		} else if((i+1) == row.size()) {
            			String[] strArr = ccpData.split("");
            			for(String str : strArr) {
            				if("X".equals(str)) { ccpResult = "X"; }
            			}
            			sql = new StringBuilder()
        					.append("UPDATE\n")
        					.append("	haccp_ccp_2p_detail\n")
        					.append("SET\n")
        					.append("	"+testType.toLowerCase().split("_")[0]+"_result = '"+ccpResult+"'\n")
        					.append("WHERE\n")
        					.append("	check_time = '"+startTime+"'\n")
        					.append("	AND ccp_date = SYSDATE\n")
        					.toString();
            			
            			resultInt = super.excuteUpdate(con, sql);
                		if (resultInt < 0) {
            				ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
            				con.rollback();
            				return EventDefine.E_DOEXCUTE_ERROR ;
            			}
            			
            		}
        			
        		} // 금속검출기_엑트라 일때만 ccp_2p
        		
			}
			con.commit();
		} catch(Exception e) {
			LoggingWriter.setLogError("M808S010200E111()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M808S010200E111()","==== finally ===="+ e.getMessage());
				}
	    	} else {
	    	}
	    }
		ioParam.setResultString(resultString);
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
    	ioParam.setMessage(MessageDefine.M_QUERY_OK);
	    return EventDefine.E_QUERY_RESULT;
	}
	
	// 금속검출기 개선조치 확인 서명
	public int E502(InoutParameter ioParam){ 
		
		resultInt = EventDefine.E_DOEXCUTE_INIT;

		try {
			con = JDBCConnectionPool.getConnection();
			con.setAutoCommit(false);
			
    		JSONObject jObj = new JSONObject();
    		jObj = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));

    		String sql = new StringBuilder()
    				.append("UPDATE haccp_censor_metal_detail							\n")
    				.append("SET														\n")
    				.append("	person_approve_id = '" + jObj.get("userId") + "',		\n")
    				.append("	improve_action = '" + jObj.get("improve_cd") + "'		\n")
    				.append("WHERE seq_no = '"+ jObj.get("seq_no") + "'					\n")
    				.append("  AND detect_date = '"+ jObj.get("detect_date") + "'		\n")
    				.append("  AND detect_time = '"+ jObj.get("detect_time") + "'		\n")
					.toString();
    		
			resultInt = super.excuteUpdate(con, sql);
	    	if(resultInt < 0){
				ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
				con.rollback();
				return EventDefine.E_DOEXCUTE_ERROR ;
			}
			con.commit();
		} catch(Exception e) {
			e.getStackTrace();
			LoggingWriter.setLogError("M808S010200E502()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
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