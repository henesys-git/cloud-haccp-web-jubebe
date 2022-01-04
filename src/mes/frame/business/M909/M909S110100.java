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


public class M909S110100 extends SqlAdapter{
	Connection con = null;
	PreparedStatement pstmt = null;
	String resultString = "";
	int resultInt = -1;
	StringBuffer sql = new StringBuffer();
	
	String[][] v_paramArray = new String[0][0]; 
	Class[] optClass = null;
	Object[] optObj = null;
	Object obj = null;
	
	public M909S110100(){
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
			optClass[0] = ioParam.getClass() ;
			optObj = new Object[1];
			optObj[0] = ioParam;

			Method method = M909S110100.class.getMethod(event,optClass);
			LoggingWriter.setLogDebug(M909S110100.class.getName(),"==== " + event + " EventMethod Create Success ====");

			obj = method.invoke(M909S110100.class.newInstance(),optObj);
			doExcute_result = CommonFunction.getInt(obj.toString());
			
	    } catch (Exception ex) {
	    	doExcute_result = EventDefine.E_DOEXCUTE_INIT;
			ioParam.setMessage(MessageDefine.M_NO_EVENTID);
			LoggingWriter.setLogError(M909S110100.class.getName(),"==== EventID Not define : EVENT ID [ " + ioParam.getEventID() + "]");
	    } finally {
	    	obj = null;
			optClass = null;
			optObj = null;
	    }
	    long endTime = System.currentTimeMillis();
		long runningTime = endTime - startTime;
		LoggingWriter.setLogAll(M909S110100.class.getName(),"==== Query [수행시간  : " + runningTime + " ms]");
		
		return doExcute_result;
	}
	
	//원석(원자재정보 출력 - JSON)
	public int E104(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			
			String sqlTotal = new StringBuilder()
					.append("       (	SELECT COUNT(*) \n")
					.append("			FROM tbm_part_list A \n")
					.append("        	INNER JOIN v_partgubun_big C \n")
					.append("				ON A.part_gubun_b = C.code_value \n")
					.append("				AND A.member_key = C.member_key \n")
					.append("			INNER JOIN v_partgubun_mid D \n")
					.append("				ON A.part_gubun_m = D.code_value \n")
					.append("				AND A.member_key = D.member_key \n")		
					.append(" 			" + jArray.get("g_where") + "\n" ) // where조건 - 대분류,중분류,유효날짜,멤버키
					.append(" 			" + jArray.get("g_search") + "\n" ) // where조건 - 검색어
					.append("		) ")
					.toString();
			
			String sql = new StringBuilder()
					.append("SELECT\n")
					.append("	C.code_name AS gubun_b,				\n")
					.append("   D.code_name AS gubun_m,				\n")
					.append("   A.serial_num,						\n")
					.append("   A.gyugyeok || A.unit_type,			\n")
					.append("   A.part_level,						\n")
					.append("   A.part_cd,							\n")
					.append("   A.revision_no,						\n")
					.append("   A.part_nm,							\n")
					.append("   A.unit_price,						\n")
					.append("   A.safety_jaego,						\n")
					.append("   A.duration_date, 					\n")
					.append("   A.part_gubun, 						\n")
					.append("   C.code_name AS part_gubun, 			\n")
					.append("   " + sqlTotal + " AS total 			\n")
					.append("FROM									\n")
					.append("	tbm_part_list A						\n")
					.append("	INNER JOIN v_partgubun_big C		\n")
					.append("	   ON A.part_gubun_b = C.code_value	\n")
					.append("	  AND A.member_key = C.member_key	\n")
					.append("	INNER JOIN v_partgubun_mid D		\n")
					.append("	   ON A.part_gubun_m = D.code_value	\n")
					.append("	  AND A.member_key = D.member_key	\n")
					.append(" " + jArray.get("g_where") + "			\n") // where조건 - 대분류,중분류,유효날짜,멤버키
					.append(" " + jArray.get("g_search") + "		\n") // where조건 - 검색어
					.append("   		AND A.delyn='N'   			\n")
					.append(" " + jArray.get("g_orderby") + "		\n") // order by 조건
					.append(" " + jArray.get("g_limit") + "			\n") // limit 조건(페이지)
					.toString();  
			
			resultString = super.excuteQueryString(con, sql.toString());
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M909S110100E104()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M909S110100E104()","==== finally ===="+ e.getMessage());
				}
	    	} else {
	    	}
	    }
		ioParam.setResultString(resultString);
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
    	ioParam.setMessage(MessageDefine.M_QUERY_OK);
	    return EventDefine.E_QUERY_RESULT;
	}
		
	//원석 (원자재 코드 중복체크)
	public int E107(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
					
			String sql = new StringBuilder()
				.append("SELECT																								\n")
				.append("	code_cd																							\n")
				.append("FROM																								\n")
				.append("	tbm_part_code_book																				\n")
				.append("WHERE code_cd LIKE '" + jArray.get("CODE_CD") + "%' AND code_value='"+jArray.get("CODE_VALUE")+"'	\n")
				.append("AND order_index > 0																				\n")
				.append("	AND member_key = '" + jArray.get("member_key") + "' 											\n")
				.toString();

			resultString = super.excuteQueryString(con, sql.toString());
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M909S110100E107()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M909S110100E107()","==== finally ===="+ e.getMessage());
				}
	    	}
	    }
		ioParam.setResultString(resultString);
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
    	ioParam.setMessage(MessageDefine.M_QUERY_OK);
	    return EventDefine.E_QUERY_RESULT;
	}
	
	//원석(원자재 중복체크)
	public int E108(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
					
			String sql = new StringBuilder()
					.append("SELECT\n")
					.append("	part_cd\n")
					.append("FROM\n")
					.append("   tbm_part_list\n")
					.append("WHERE part_cd LIKE '" + jArray.get("PART_CD") + "%'\n")
					.append(" 	AND member_key = '" + jArray.get("member_key") + "' \n") //member_key_select, update, delete
					.append(";\n")
					.toString();

			resultString = super.excuteQueryString(con, sql.toString());
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M909S110100E108()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M909S110100E108()","==== finally ===="+ e.getMessage());
				}
	    	} else {
	    	}
	    }
		ioParam.setResultString(resultString);
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
    	ioParam.setMessage(MessageDefine.M_QUERY_OK);
	    return EventDefine.E_QUERY_RESULT;
	}
		
	// insert part list
	public int E111(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));

			String sql = new StringBuilder()
				.append("INSERT INTO\n")
				.append("	tbm_part_list (		\n")
				.append("		part_gubun_b,	\n")
				.append("		part_gubun_m,	\n")
				.append("		packing_qtty,	\n")
				.append("		gyugyeok,		\n")
				.append("		unit_type,		\n")
				.append("		part_cd,		\n")
				.append("		part_nm,		\n")
				.append("		unit_price,		\n")
				.append("		safety_jaego,	\n")
				.append("		start_date,		\n")
				.append("		create_user_id,	\n")
				.append(" 		member_key,		\n")
				.append(" 		part_gubun		\n")
				.append("	)					\n")
				.append(" values (										\n")
				.append(" 		'" 	+ jArray.get("partgubun_big") + "',	\n")
				.append(" 		'" 	+ jArray.get("partgubun_mid") + "', \n")
				.append(" 		'" 	+ jArray.get("packing_qtty") + "',	\n")
				.append(" 		'" 	+ jArray.get("gyugyeok") + "',		\n")
				.append(" 		'" 	+ jArray.get("unit_type") + "',		\n")
				.append(" 		'" 	+ jArray.get("PartCd") + "' , 		\n")
				.append(" 		'" 	+ jArray.get("PartName") + "', 		\n")
				.append(" 		'" 	+ jArray.get("UnitPrice") + "', 	\n")
				.append(" 		'" 	+ jArray.get("saftyCount") + "', 	\n")
				.append(" 		SYSDATE,							 	\n")
				.append(" 		'" 	+ jArray.get("user_id") + "', 		\n")
				.append(" 		'" 	+ jArray.get("member_key") + "',	\n")
				.append(" 		'IMPORT'				 				\n")
				.append(" 		);			  							\n")
				.toString();
			
			resultInt = super.excuteUpdate(con, sql.toString());
			if (resultInt < 0) {
				ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
				con.rollback();
				return EventDefine.E_DOEXCUTE_ERROR ;
			} else {
				ioParam.setMessage(resultInt + "건 " + MessageDefine.M_INSERT_RESULT);
			}
		} catch(Exception e) {
			LoggingWriter.setLogError("M909S110100E111()","==== SQL ERROR ===="+ e.getMessage() + "\n" + sql.toString());
			e.printStackTrace();
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M909S110100E111()","==== finally ===="+ e.getMessage());
				}
	    	}
	    }
		ioParam.setResultString(resultString);
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
		ioParam.setMessage(MessageDefine.M_QUERY_OK);
	    return EventDefine.E_QUERY_RESULT;
	}
		
	// update part list
	public int E112(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			String sql;
			
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			
			con.setAutoCommit(false);
			
			// original part list, duration date update
			sql = new StringBuilder()
					.append("UPDATE tbm_part_list  										\n")
					.append("SET 														\n")
					.append("	duration_date = SYSDATE - 1, 		\n")
					.append("	modify_user_id = '" + jArray.get("user_id") + "', 		\n")
					.append("	modify_date = SYSDATETIME 					  	 		\n")
					.append("WHERE part_cd = '" + jArray.get("PartCd") + "' 			\n")
					.append("  AND revision_no = '" + jArray.get("revision_no") + "' 	\n")
					.toString();
			
			resultInt = super.excuteUpdate(con, sql.toString());
			if (resultInt < 0) {
				ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
				con.rollback();
				return EventDefine.E_DOEXCUTE_ERROR;
			} else {
				ioParam.setMessage(resultInt + "건 " + MessageDefine.M_UPDATE_RESULT);
			}
			
			// insert updated part list information
			sql = new StringBuilder()
					.append("INSERT INTO								\n")
					.append("	tbm_part_list (							\n")
					.append("	member_key,								\n")
					.append("	part_cd,								\n")
					.append("	revision_no,							\n")
					.append("	part_gubun,								\n")
					.append("	part_nm,								\n")
					.append("	part_gubun_b,							\n")
					.append("	part_gubun_m,							\n")
					.append("	gyugyeok,								\n")
					.append("	packing_qtty,							\n")
					.append("	unit_type,								\n")
					.append("	unit_price,								\n")
					.append("	safety_jaego,							\n")
					.append("	delyn,									\n")
					.append("	start_date,								\n")
					.append("	create_date,							\n")
					.append("	create_user_id,							\n")
					.append("	duration_date							\n")
					.append(")											\n")
					.append("VALUES (									\n")
					.append("	'" + jArray.get("member_key") + "', 	\n")
					.append(" 	'" + jArray.get("PartCd") + "', 		\n")
					.append(" 	" + jArray.get("revision_no") + " + 1, 	\n")
					.append(" 	'IMPORT', 								\n")
					.append(" 	'" + jArray.get("PartName") + "', 		\n")
					.append(" 	'" + jArray.get("partgubun_big") + "',	\n")
					.append(" 	'" + jArray.get("partgubun_mid") + "', 	\n")
					.append(" 	'" + jArray.get("gyugyeok") + "',	 	\n")
					.append(" 	'" + jArray.get("packing_qtty") + "'  ,	\n")
					.append(" 	'" + jArray.get("unit_type") + "'     ,	\n")
					.append(" 	'" + jArray.get("UnitPrice") + "', 		\n")
					.append(" 	'" + jArray.get("saftyCount") + "', 	\n")
					.append("	'N',									\n")
					.append(" 	SYSDATE, 								\n")
					.append("	SYSDATE,								\n")
					.append(" 	'" + jArray.get("user_id") + "', 		\n")
					.append("	'9999-12-31'							\n")
					.append(");\n")
					.toString();
		
			resultInt = super.excuteUpdate(con, sql.toString());
			if (resultInt < 0) {
				ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
				con.rollback();
				return EventDefine.E_DOEXCUTE_ERROR;
			} else {
				ioParam.setMessage(resultInt + "건 " + MessageDefine.M_INSERT_RESULT);
			}
			
			con.commit();
		} catch(Exception e) {
			LoggingWriter.setLogError("M909S110100E112()","==== SQL ERROR ===="+ e.getMessage() + "\n" + sql.toString());
			e.printStackTrace();
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M909S110100E112()","==== finally ===="+ e.getMessage());
				}
	    	} else {
	    	}
	    }
		ioParam.setResultString(resultString);
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
		ioParam.setMessage(MessageDefine.M_QUERY_OK);
	    return EventDefine.E_QUERY_RESULT;
	}

	// delete part list
	public int E113(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			
			String sql = new StringBuilder()
					.append("UPDATE tbm_part_list SET						\n")
					.append(" 	delyn = 'Y'									\n")
					.append("WHERE part_cd = '" + jArray.get("partCd") + "'	\n")
					.toString();
			
			resultInt = super.excuteUpdate(con, sql.toString());
			if (resultInt < 0) {
				ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
				con.rollback();
				return EventDefine.E_DOEXCUTE_ERROR ;
			} else {
				ioParam.setMessage(resultInt + "건 " + MessageDefine.M_INSERT_RESULT);
			}
		} catch(Exception e) {
			LoggingWriter.setLogError("M909S110100E113()","==== SQL ERROR ===="+ e.getMessage() + "\n" + sql.toString());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M909S110100E113()","==== finally ===="+ e.getMessage());
				}
	    	}
	    }
		ioParam.setResultString(resultString);
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
		ioParam.setMessage(MessageDefine.M_QUERY_OK);
	    return EventDefine.E_QUERY_RESULT;
	}	
		
	// select entire part list
	// yamsam used
	public int E114(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			
			String sqlTotal = new StringBuilder()
					.append("(SELECT COUNT(*) 						\n")
					.append(" FROM tbm_part_list A 					\n")
					.append(" INNER JOIN v_partgubun_big C 			\n")
					.append(" 	ON A.part_gubun_b = C.code_value 	\n")
					.append("	AND A.member_key = C.member_key 	\n")
					.append("INNER JOIN v_partgubun_mid D 			\n")
					.append("	ON A.part_gubun_m = D.code_value 	\n")
					.append("	AND A.member_key = D.member_key 	\n")
					.append("	" + jArray.get("g_where") + "		\n") // where조건 - 대분류,중분류,유효날짜,멤버키
					.append("	" + jArray.get("g_search") + "		\n") // where조건 - 검색어
					.append(") 										\n")
					.toString();
			
			String sql = new StringBuilder()
			        .append("SELECT                                 			\n")
			        .append("	C.code_name AS gubun_b,             			\n")
			        .append("	D.code_name AS gubun_m,             			\n")
			        .append("	A.unit_type,                        			\n")
			        .append("	A.part_level,                       			\n")
			        .append("	A.part_cd,                          			\n")
			        .append("	A.revision_no,                     			 	\n")
			        .append("	A.part_nm,                          			\n")
			        .append("	A.unit_price,                       			\n")
			        .append("   A.safety_jaego,                     			\n")
			        .append("   A.source_barcode,                   			\n")
			        .append("   A.alt_part_cd,                      			\n")
			        .append("   A.part_nm,	                         			\n")
			        .append("   A.alt_revision_no,                  			\n")
			        .append("   A.start_date,                       			\n")
			        .append("   A.duration_date,                    			\n")
			        .append("   A.part_gubun_b,                     			\n")
			        .append("   A.part_gubun_m,                     			\n")
			        .append("   " + sqlTotal + " AS total,          			\n")
			        .append("   A.wonsanji,                         			\n")
			        .append("   CAST(SUM(NVL(S.post_amt,0)) AS NUMERIC(15,3)),	\n")
			        .append("   A.detail_gyugyeok                   			\n")
			        .append("FROM                                   			\n")
			        .append("   tbm_part_list A                     			\n")
			        .append("INNER JOIN v_partgubun_big C           			\n")
			        .append("   ON A.part_gubun_b = C.code_value    			\n")
			        .append("   AND A.member_key = C.member_key    			 	\n")
			        .append("INNER JOIN v_partgubun_mid D           			\n")
			        .append("   ON A.part_gubun_m = D.code_value    			\n")
			        .append("	AND A.member_key = D.member_key     			\n")
			        .append("LEFT OUTER JOIN tbi_part_storage2 S    			\n")
			        .append("	ON A.part_cd = S.part_cd            			\n")
			        .append("	AND A.revision_no = S.part_rev_no   			\n")
			        .append("LEFT OUTER JOIN tbm_mapping_customer_partlist M    \n")
			        .append("   ON A.part_cd = M.part_cd 	   					\n")
			        .append(" " + jArray.get("g_where") + "         			\n") // where조건 - 대분류,중분류,유효날짜,멤버키
			        .append(" " + jArray.get("g_search") + "        			\n") // where조건 - 검색어
			        .append("GROUP BY A.part_cd                     			\n")
			        .append(" " + jArray.get("g_orderby") + "       			\n") // order by 조건
			        .append(" " + jArray.get("g_limit") + "         			\n") // limit 조건(페이지)
			        .toString();
			
			resultString = super.excuteQueryString(con, sql.toString());
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M909S110100E114()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M909S110100E114()","==== finally ===="+ e.getMessage());
				}
	    	} else {
	    	}
	    }
		ioParam.setResultString(resultString);
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
    	ioParam.setMessage(MessageDefine.M_QUERY_OK);
	    return EventDefine.E_QUERY_RESULT;
	}
	
	public int E124(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			
			String sqlTotal = new StringBuilder()
					.append("       (	SELECT COUNT(*) \n")
					.append("			FROM tbm_part_list A \n")
					.append("        	INNER JOIN v_partgubun_big C \n")
					.append("				ON A.part_gubun_b = C.code_value \n")
					.append("				AND A.member_key = C.member_key \n")
					.append("			INNER JOIN v_partgubun_mid D \n")
					.append("				ON A.part_gubun_m = D.code_value \n")
					.append("				AND A.member_key = D.member_key \n")
					.append("			LEFT OUTER JOIN tbi_part_storage S\n")
					.append("				ON A.part_Cd = S.part_cd\n")
					.append("				AND A.revision_no = S.part_cd_rev\n")
					.append("				AND A.member_key = S.member_key\n")
					.append(" 			" + jArray.get("g_where") + "\n" ) // where조건 - 대분류,중분류,유효날짜,멤버키
					.append(" 			" + jArray.get("g_search") + "\n" ) // where조건 - 검색어
					.append("		) \n")
					.toString();
			
			String sql = new StringBuilder()
					.append("SELECT\n")
					.append("        C.code_name AS gubun_b,\n")
					.append("        D.code_name AS gubun_m,\n")
					.append("        A.gyugyeok,\n")
					.append("        A.part_level,\n")
					.append("        A.part_cd,\n")
					.append("        A.revision_no,\n")
					.append("        A.part_nm,\n")
					.append("        A.unit_price,\n")
					.append("        A.safety_jaego,\n")
					.append("        A.source_barcode,\n")
					.append("        A.alt_part_cd,\n")
					.append("        A.part_nm ,\n")
					.append("        A.alt_revision_no,\n")
					.append("        A.start_date,\n")
					.append("        A.duration_date,\n")
					.append("        A.part_gubun_b,\n")
					.append("        A.part_gubun_m,\n")
					.append("        " + sqlTotal + " AS total, \n")
					.append("        A.wonsanji,\n")
					.append("		 SUM(NVL(S.post_amt,0))\n")
					.append("FROM\n")
					.append("        tbm_part_list A\n")
					.append("       INNER JOIN v_partgubun_big C\n")
					.append("          ON A.part_gubun_b = C.code_value\n")
					.append("			AND A.member_key = C.member_key\n")
					.append("       INNER JOIN v_partgubun_mid D\n")
					.append("          ON A.part_gubun_m = D.code_value\n")
					.append("			AND A.member_key = D.member_key\n")
					.append("		LEFT OUTER JOIN tbi_part_storage S\n")
					.append("			ON A.part_Cd = S.part_cd\n")
					.append("			AND A.revision_no = S.part_cd_rev\n")
					.append("			AND A.member_key = S.member_key\n")
					.append(" " + jArray.get("g_where") + "\n" ) // where조건 - 대분류,중분류,유효날짜,멤버키
					.append(" " + jArray.get("g_search") + "\n" ) // where조건 - 검색어
					.append("GROUP BY A.part_cd\n")
					.append(" " + jArray.get("g_orderby") + "\n" ) // order by 조건
					.append(" " + jArray.get("g_limit") + "\n" ) // limit 조건(페이지)
					.toString();

			resultString = super.excuteQueryString(con, sql.toString());
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M909S110100E124()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M909S110100E124()","==== finally ===="+ e.getMessage());
				}
	    	} else {
	    	}
	    }
		ioParam.setResultString(resultString);
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
    	ioParam.setMessage(MessageDefine.M_QUERY_OK);
	    return EventDefine.E_QUERY_RESULT;
	}
	
	//원석 (원자재수정용 조회)
	public int E116(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			
			String sql = new StringBuilder()
					.append("SELECT 			\n")
					.append("	 part_gubun_b,	\n")
					.append("	 part_gubun_m,	\n")
					.append("	 part_cd,		\n")
					.append("	 part_nm,		\n")
					.append("	 packing_qtty,	\n")
					.append("	 unit_type,		\n")
					.append("	 unit_price,	\n")
					.append("	 safety_jaego,	\n")
					.append("	 revision_no,	\n")
					.append("	 start_date,	\n")
					.append("	 gyugyeok		\n")
					.append("FROM 				\n")
					.append("	tbm_part_list 	\n")
					.append("WHERE 				\n")
					.append("	part_cd = '"+ jArray.get("PART_CD") +"' 			\n")
					.append(" 	AND revision_no = "+ jArray.get("REVISION_NO") +" 	\n")
					.toString();
			resultString = super.excuteQueryString(con, sql.toString());
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M909S110100E116()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
		} finally {
			if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M909S110100E116()","==== finally ===="+ e.getMessage());
				}
			}
		}
		ioParam.setResultString(resultString);
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
		ioParam.setMessage(MessageDefine.M_QUERY_OK);

		return EventDefine.E_QUERY_RESULT;
	}
	
	//원석 (원자재수정용 조회)
	public int E117(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));

			String sql = new StringBuilder()
					.append("SELECT														\n")
					.append("  NVL(max(part_cd),'0000')									\n")
					.append("FROM														\n")
					.append("        tbm_part_list										\n")
					.append("WHERE part_gubun_b = '"+jArray.get("big")+"'				\n")
					.append("        AND part_gubun_m = '"+jArray.get("mid")+"'			\n")
					.append("        AND member_key = '"+jArray.get("member_key")+"'	\n")
					.toString();
			resultString = super.excuteQueryString(con, sql.toString());
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M909S110100E117()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
		} finally {
			if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M909S110100E117()","==== finally ===="+ e.getMessage());
				}
			}
		}
		ioParam.setResultString(resultString);
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
		ioParam.setMessage(MessageDefine.M_QUERY_OK);
		return EventDefine.E_QUERY_RESULT;
	}
	
	// 원석(원자재 코드 등록)
	public int E201(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			String codevalue = jArray.get("PartGubun").toString().substring(0,2); 
			
			String sql = new StringBuilder()
					.append("INSERT INTO tbm_part_code_book (	\n")
					.append("		code_cd					\n")
					.append("		,code_value				\n")
					.append("		,code_name				\n")
					.append("		,start_date				\n")
					.append("		,duration_date			\n")
					.append("		,create_user_id			\n")
					.append("		,order_index			\n")
					.append("		,create_date			\n")
					.append("		,modify_user_id			\n")
					.append("		,modify_reason			\n")
					.append("		,modify_date			\n")
					.append(" 		,member_key				\n")
					.append("	)							\n")
					.append("VALUES							\n")
					.append("	(							\n")
					.append("	 '"  + jArray.get("CodeGroupGubun") + "'			\n")
					.append("	 ,'"  + jArray.get("PartGubun") + "'				\n")
					.append("	 ,'"  + jArray.get("CodeName") + "'					\n")
					.append("	 ,'"  + jArray.get("StartDate1") + "'				\n")
					.append("	 ,'9999-12-31'										\n")
					.append("	 ,'"  + jArray.get("user_id") + "'					\n")
					.append(",(SELECT												\n")
					.append("   NVL(MAX(order_index)+1, 1)							\n")
					.append("FROM tbm_part_code_book								\n")
					.append(" WHERE code_cd='"  + jArray.get("CodeGroupGubun") + "' \n")
					.append(" AND code_value LIKE '"+ codevalue +"%') 				\n")
					.append("	 ,SYSDATETIME										\n")
					.append("	 ,'" + jArray.get("user_id") + "'					\n")
					.append("	 ,'최초등록'											\n")
					.append("	 ,SYSDATETIME										\n")
					.append(" 		,'" + jArray.get("member_key") + "' 			\n")
					.append("	)\n")
					.toString();
			
			resultInt = super.excuteUpdate(con, sql.toString());
			if (resultInt < 0) {
				ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
				con.rollback();
				return EventDefine.E_DOEXCUTE_ERROR ;
			} else {
				ioParam.setMessage(resultInt + "건 " + MessageDefine.M_INSERT_RESULT);
			}
		} catch(Exception e) {
			LoggingWriter.setLogError("M909S110100E201()","==== SQL ERROR ===="+ e.getMessage() + "\n" + sql.toString());
			return EventDefine.E_DOEXCUTE_ERROR ;
		} finally {
			if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M909S110100E201()","==== finally ===="+ e.getMessage());
				}
			}
		}
		ioParam.setResultString(resultString);
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
		ioParam.setMessage(MessageDefine.M_QUERY_OK);
	    return EventDefine.E_QUERY_RESULT;
	}
	
	public int E204(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			
			String sql = new StringBuilder()
				.append("SELECT '0' + TO_CHAR(TO_NUMBER(SUBSTR(MAX(A.code_value), 3, 2)) +1)	\n")
				.append("FROM tbm_part_code_book A												\n")
				.append("WHERE LENGTH(code_value) = 4											\n")
				.append("AND A.code_value LIKE '"+jArray.get("part_gubun")+"%'					\n")
				.append("AND A.member_key = '"+jArray.get("member_key")+"'						\n")
				.toString();

			resultString = super.excuteQueryString(con, sql.toString());
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M909S110100E204()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
		} finally {
			if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M909S110100E204()","==== finally ===="+ e.getMessage());
				}
			} else {
			}
		}
		ioParam.setResultString(resultString);
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
		ioParam.setMessage(MessageDefine.M_QUERY_OK);
		return EventDefine.E_QUERY_RESULT;
	}
	
	// 원부재료 조회
	// yamsam used
	public int E214(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			
			String sqlTotal = new StringBuilder()
					.append("(SELECT COUNT(*) 						\n")
					.append(" FROM tbm_part_list A 					\n")
					.append(" INNER JOIN v_partgubun_big C 			\n")
					.append(" 	ON A.part_gubun_b = C.code_value 	\n")
					.append("	AND A.member_key = C.member_key 	\n")
					.append("INNER JOIN v_partgubun_mid D 			\n")
					.append("	ON A.part_gubun_m = D.code_value 	\n")
					.append("	AND A.member_key = D.member_key 	\n")
					.append("WHERE C.code_value like '" + jArray.get("partgubun_big") + "%' \n")
					.append("AND D.code_value like '" + jArray.get("partgubun_mid") + "%' 	\n")
					.append(") 																\n")
					.toString();
			
			String sql = new StringBuilder()
			        .append("SELECT                                 			\n")
			        .append("	C.code_name AS gubun_b,             			\n")
			        .append("	D.code_name AS gubun_m,             			\n")
			        .append("	A.part_cd,                          			\n")
			        .append("	A.part_nm,                          			\n")
			        .append("	A.unit_type,                        			\n")
			        .append("	A.part_level,                       			\n")
			        .append("	A.revision_no,                     			 	\n")
			        .append("	A.unit_price,                       			\n")
			        .append("   A.safety_jaego,                     			\n")
			        .append("   A.source_barcode,                   			\n")
			        .append("   A.alt_part_cd,                      			\n")
			        .append("   A.part_nm,                         				\n")
			        .append("   A.alt_revision_no,                  			\n")
			        .append("   A.start_date,                       			\n")
			        .append("   A.duration_date,                    			\n")
			        .append("   A.part_gubun_b,                     			\n")
			        .append("   A.part_gubun_m,                     			\n")
			        .append("   " + sqlTotal + " AS total,          			\n")
			        .append("   A.wonsanji,                         			\n")
			        .append("   CAST(SUM(NVL(S.post_amt,0)) AS NUMERIC(15,3)),	\n")
			        .append("   A.detail_gyugyeok                   			\n")
			        .append("FROM                                   			\n")
			        .append("   tbm_part_list A                     			\n")
			        .append("LEFT OUTER JOIN v_partgubun_big C           		\n")
			        .append("   ON A.part_gubun_b = C.code_value    			\n")
			        .append("   AND A.member_key = C.member_key    			 	\n")
			        .append("LEFT OUTER JOIN v_partgubun_mid D           		\n")
			        .append("   ON A.part_gubun_m = D.code_value    			\n")
			        .append("	AND A.member_key = D.member_key     			\n")
			        .append("LEFT OUTER JOIN tbi_part_storage2 S    			\n")
			        .append("	ON A.part_cd = S.part_cd            			\n")
			        .append("	AND A.revision_no = S.part_rev_no   			\n")
			        .append("LEFT OUTER JOIN tbm_mapping_customer_partlist M    \n")
			        .append("   ON A.part_cd = M.part_cd 	   					\n")
			        .append("WHERE C.code_value like '" + jArray.get("partgubun_big") + "%' \n")
					.append("AND D.code_value like '" + jArray.get("partgubun_mid") + "%' 	\n")
					.append("AND M.cust_cd like '" + jArray.get("cust_code") + "%' 			\n")
					.append("GROUP BY A.part_cd                     						\n")
			        .toString();
			
			resultString = super.excuteQueryString(con, sql.toString());
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M909S110100E114()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M909S110100E114()","==== finally ===="+ e.getMessage());
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