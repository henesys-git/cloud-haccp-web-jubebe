package mes.frame.business.M838;

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


/*
 * 개선조치기록부
 * 
 * 
 * */


/**
 * 개요 : 이벤트ID별 메소드 정의
 */
public  class M838S070600 extends SqlAdapter{
	Connection con = null;
	PreparedStatement pstmt = null;
	String resultString = "";
	int resultInt = -1;
	StringBuffer sql = new StringBuffer();
	
	String[][] v_paramArray = new String[0][0]; 
	Class[] optClass = null;
	Object[] optObj = null;
	Object obj = null;
	
	public M838S070600(){
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
			
			Method method = M838S070600.class.getMethod(event,optClass);
			LoggingWriter.setLogDebug(M838S070600.class.getName(),"==== " + event + " EventMethod Create Success ====");

			obj = method.invoke(M838S070600.class.newInstance(),optObj);
			doExcute_result = CommonFunction.getInt(obj.toString());
			
	    } catch (Exception ex) {
	    	doExcute_result = EventDefine.E_DOEXCUTE_INIT;
			ioParam.setMessage(MessageDefine.M_NO_EVENTID);
			LoggingWriter.setLogError(M838S070600.class.getName(),"==== EventID Not define : EVENT ID [ " + ioParam.getEventID() + "]");
	    } finally {
	    	obj = null;
			optClass = null;
			optObj = null;
	    }
	    long endTime = System.currentTimeMillis();
		long runningTime = endTime - startTime;
		LoggingWriter.setLogAll(M838S070600.class.getName(),"==== Query [수행시간  : " + runningTime + " ms]");
		
		return doExcute_result;
	}
	
	// 등록
	public int E101(InoutParameter ioParam){ 
		resultInt = EventDefine.E_DOEXCUTE_INIT;

		try {
			con = JDBCConnectionPool.getConnection();
			con.setAutoCommit(false);
			
    		JSONObject jArray = new JSONObject();
    		jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
    		
    		String checklist_id = jArray.get("checklist_id").toString();    		
    		JSONObject input = (JSONObject) jArray.get("input");

    		String sql = new StringBuilder()
    				.append("INSERT INTO										\n")
    				.append("	haccp_improve_record (							\n")
    				.append("		checklist_id,								\n")
    				.append("		checklist_rev_no,							\n")
    				.append("		regist_date,								\n")
    				.append("		defect_date,								\n")
    				.append("		unsuit,										\n")
    				.append("		defect_detail,								\n")
    				.append("		defect_result,								\n")
    				.append("		improve_action,								\n")
    				.append("		person_improve_id,							\n")
    				.append("		verify_result,								\n")
    				.append("		person_verify_id,							\n")
    				.append("		attached_document,							\n")
    				.append("		person_write_id								\n")
    				.append("	)												\n")
    				.append("VALUES												\n")
    				.append("	(												\n")
    				.append(" 		'"	+ checklist_id + "',					\n")
    				.append("		(SELECT MAX(checklist_rev_no) 				\n")
    				.append("		 FROM checklist								\n")
    				.append("		 WHERE checklist_id = '"+ checklist_id +"'),\n")
    				.append(" 		TO_CHAR(SYSDATE, 'YYYY-MM-DD'),				\n")
    				.append(" 		'"	+ input.get("defect_date") + "',		\n")
    				.append(" 		'"	+ input.get("unsuit") + "',				\n")
    				.append(" 		'"	+ input.get("defect_detail") + "',		\n")
    				.append(" 		'"	+ input.get("defect_result") + "',		\n")
    				.append(" 		'"	+ jArray.get("improve_action") + "',	\n")
    				.append(" 		'"	+ input.get("person_improve_id") + "',	\n")
    				.append(" 		'"	+ input.get("verify_result") + "',		\n")
    				.append(" 		'"	+ input.get("person_verify_id") + "',	\n")
    				.append(" 		'"	+ jArray.get("attached_document") + "',	\n")
    				.append(" 		'"	+ jArray.get("person_write_id") + "'	\n")
    				.append("	);												\n")
    				.toString();

			resultInt = super.excuteUpdate(con, sql.toString());
	    	if(resultInt < 0){
				ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
				con.rollback();
				return EventDefine.E_DOEXCUTE_ERROR ;
			}
			con.commit();
		} catch(Exception e) {
			e.getStackTrace();
			LoggingWriter.setLogError("M838S070600E101()","==== SQL ERROR ===="+ e.getMessage());
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
	
	// 수정
	public int E102(InoutParameter ioParam){ 
		resultInt = EventDefine.E_DOEXCUTE_INIT;

		try {
			con = JDBCConnectionPool.getConnection();
			con.setAutoCommit(false);
			
    		JSONObject jArray = new JSONObject();
    		jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
    		System.out.println("JSONObject jArray rcvData="+ jArray.toString());

    		String seq_no = jArray.get("seq_no").toString();    	
    		JSONObject input = (JSONObject) jArray.get("input");

    		String sql = new StringBuilder()
					.append("UPDATE															 \n")
					.append("	haccp_improve_record										 \n")
					.append("SET														 	 \n")
					.append("	unsuit = '" + input.get("unsuit") + "',						 \n")
					.append("	defect_date = '" + input.get("defect_date") + "',			 \n")
					.append("	defect_detail = '" + input.get("defect_detail") + "',		 \n")
					.append("	defect_result = '" + input.get("defect_result") + "',		 \n")
					.append("	improve_action = '" + jArray.get("improve_action") + "',	 \n")
					.append("	person_improve_id = '" + input.get("person_improve_id") + "',\n")
					.append("	verify_result = '" + input.get("verify_result") + "', 		 \n")
					.append("	person_verify_id = '" + input.get("person_verify_id") + "',  \n")
					.append("	attached_document = '" + jArray.get("attached_document") + "',\n")
					.append("	person_write_id = '" + jArray.get("person_write_id") + "',   \n")
					.append("	person_check_id = '',                                        \n")
					.append("	person_approve_id = ''                                       \n")
					.append("WHERE															 \n")
					.append("	seq_no = '" + seq_no + "'								 	 \n")
					.toString();
    		
			resultInt = super.excuteUpdate(con, sql.toString());
	    	if(resultInt < 0){
				ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
				con.rollback();
				return EventDefine.E_DOEXCUTE_ERROR ;
			}
			con.commit();
		} catch(Exception e) {
			e.getStackTrace();
			LoggingWriter.setLogError("M838S070600E102()","==== SQL ERROR ===="+ e.getMessage());
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
	
	// 클레임 일지 삭제
	public int E103(InoutParameter ioParam){ 
		resultInt = EventDefine.E_DOEXCUTE_INIT;

		try {
			con = JDBCConnectionPool.getConnection();
			
    		JSONObject jArray = new JSONObject();
    		jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
    		System.out.println("JSONObject jArray rcvData="+ jArray.toString());

	    	String sql = new StringBuilder()
    				.append("DELETE FROM									 	\n")
    				.append("	haccp_improve_record							\n")
    				.append("WHERE seq_no = '"+ jArray.get("seq_no") + "'		\n")
					.toString();
		
			resultInt = super.excuteUpdate(con, sql.toString());
	    	if(resultInt < 0){
				ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
				con.rollback();
				return EventDefine.E_DOEXCUTE_ERROR ;
			}

		} catch(Exception e) {
			e.getStackTrace();
			LoggingWriter.setLogError("M838S070600E103()","==== SQL ERROR ===="+ e.getMessage());
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
	
	// 메인 테이블 조회
	public int E104(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));

			String sql = new StringBuilder()
					.append("SELECT						                            \n")
					.append("	A.checklist_id,			                            \n")
					.append("	A.checklist_rev_no,		                            \n")
					.append("	A.regist_date,			                   	        \n")
					.append("	A.seq_no,		                           			\n")
					.append("	A.unsuit,			                   	    	    \n")
					.append("	A.defect_date,			                   	        \n")
					.append("	A.defect_detail,		                            \n")
					.append("	A.defect_result,		                            \n")
					.append("	B.user_nm as person_write_id,                       \n")
					.append("	B2.user_nm as person_check_id,                      \n")
					.append("	B3.user_nm as person_approve_id,                   	\n")
					.append("	file_name,						                  	\n")
					.append("	file_path,						                 	\n")
					.append("	file_rev_no,						                \n")
					.append("	regist_no							                \n")
					.append("FROM						                            \n")
					.append("	haccp_improve_record A	                            \n")
					.append("INNER JOIN tbm_users B					                \n")
					.append("ON A.person_write_id = B.user_id		                \n")
					.append("AND  A.regist_date BETWEEN CAST(B.start_date AS DATE) AND CAST(B.duration_date AS DATE) \n")
					.append("LEFT JOIN tbm_users B2					                \n")
					.append("ON A.person_check_id = B2.user_id		                \n")
					.append("AND  A.regist_date BETWEEN CAST(B2.start_date AS DATE) AND CAST(B2.duration_date AS DATE) \n")
					.append("LEFT JOIN tbm_users B3					                \n")
					.append("ON A.person_approve_id = B3.user_id	                \n")
					.append("AND  A.regist_date BETWEEN CAST(B3.start_date AS DATE) AND CAST(B3.duration_date AS DATE) \n")
					.append("WHERE						                            \n")
					.append("	A.defect_date BETWEEN '"+ jArray.get("fromdate") + "' \n")
					.append("                   AND '"+ jArray.get("todate") + "' 	\n")
					.append("ORDER BY A.regist_date DESC, A.defect_date DESC, seq_no DESC   \n")
					.toString();

			resultString = super.excuteQueryString(con, sql.toString());
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M838S070600E104()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) {
						con.close();
					}
				} catch (Exception e) {
					LoggingWriter.setLogError("M838S070600E104()","==== finally ===="+ e.getMessage());
				}
	    	}
	    }

		ioParam.setResultString(resultString);
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
    	ioParam.setMessage(MessageDefine.M_QUERY_OK);

    	return EventDefine.E_QUERY_RESULT;
	}
	
	// 파일 등록
	public int E111(InoutParameter ioParam){ 
		resultInt = EventDefine.E_DOEXCUTE_INIT;

		try {
			con = JDBCConnectionPool.getConnection();

			// 클라이언트로 부터 받은 파라미터를 옮겨 담는다.
			String rcvData = (String)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));

			con.setAutoCommit(false);
    		
    		// 클라이언트로 부터 받은 파라미터를 쪼개어서 배열에 담는다. returnStringBuffer
			String[][] c_paramArray = CommonFunction.getConvString2DoubleArray(rcvData);
			
			System.out.println(rcvData);
			System.out.println(c_paramArray);
			System.out.println(c_paramArray.toString());
			
    		String sql = new StringBuilder()
    				.append("SELECT\n")
    				.append("	seq_no\n")
    				.append("FROM\n")
    				.append("	haccp_improve_record\n")
    				.append("WHERE\n")
    				.append("	ROWNUM = 1 \n")
    				.append("ORDER BY seq_no DESC;\n")
    				.toString();

			resultString = super.excuteQueryString(con, sql.toString());
    		
			sql = new StringBuilder()
					.append("UPDATE haccp_improve_record				\n")
					.append("   SET file_name = '"+c_paramArray[0][10]+"',\n")	//file_view_name
					.append("   	file_path = '"+c_paramArray[0][11]+"',\n")	//file_path
					.append("   	regist_no = '"+c_paramArray[0][19]+"'\n")	//regist_no
					.append(" WHERE seq_no = "+resultString.trim()+"\n")
					.toString();

			resultInt = super.excuteUpdate(con, sql.toString());
	    	if(resultInt < 0){
				ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
				con.rollback();
				return EventDefine.E_DOEXCUTE_ERROR ;
			}
			con.commit();
		} catch(Exception e) {
			e.getStackTrace();
			LoggingWriter.setLogError("M838S070600E111()","==== SQL ERROR ===="+ e.getMessage());
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
	
	// 파일 수정
	public int E112(InoutParameter ioParam){ 
		resultInt = EventDefine.E_DOEXCUTE_INIT;

		try {
			con = JDBCConnectionPool.getConnection();

			// 클라이언트로 부터 받은 파라미터를 옮겨 담는다.
			String rcvData = (String)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));

			con.setAutoCommit(false);
    		
    		// 클라이언트로 부터 받은 파라미터를 쪼개어서 배열에 담는다. returnStringBuffer
			String[][] c_paramArray = CommonFunction.getConvString2DoubleArray(rcvData);
    		
			String sql = new StringBuilder()
					.append("UPDATE haccp_improve_record				\n")
					.append("   SET file_name = '"+c_paramArray[0][10]+"',\n")	//file_view_name
					.append("   	file_path = '"+c_paramArray[0][11].replaceAll("//", "/")+"',\n")	//file_path
					.append("   	file_rev_no = '"+c_paramArray[0][8]+"',\n")	//file_rev_no
					.append("   	regist_no = '"+c_paramArray[0][18]+"'\n")	//regist_no
					.append(" WHERE seq_no = "+c_paramArray[0][24]+"\n")
					.toString();

			resultInt = super.excuteUpdate(con, sql.toString());
	    	if(resultInt < 0){
				ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
				con.rollback();
				return EventDefine.E_DOEXCUTE_ERROR ;
			}
			con.commit();
		} catch(Exception e) {
			e.getStackTrace();
			LoggingWriter.setLogError("M838S070600E112()","==== SQL ERROR ===="+ e.getMessage());
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
	
	// 파일 삭제(실제 파일 삭제 x DB 만 변경)
	public int E113(InoutParameter ioParam){ 
		resultInt = EventDefine.E_DOEXCUTE_INIT;

		try {
			
			con = JDBCConnectionPool.getConnection();
			
    		JSONObject jArray = new JSONObject();
    		jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
    		System.out.println("JSONObject jArray rcvData="+ jArray.toString());
    		
			String sql = new StringBuilder()
					.append("UPDATE haccp_improve_record				\n")
					.append("   SET file_name = '',\n")	//file_view_name
					.append("   	file_path = ''\n")	//file_path
					.append(" WHERE seq_no = "+jArray.get("seq_no").toString()+"\n")
					.toString();

			resultInt = super.excuteUpdate(con, sql.toString());
	    	if(resultInt < 0){
				ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
				con.rollback();
				return EventDefine.E_DOEXCUTE_ERROR ;
			}
			con.commit();
		} catch(Exception e) {
			e.getStackTrace();
			LoggingWriter.setLogError("M838S070600E113()","==== SQL ERROR ===="+ e.getMessage());
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
	
	// 점검표 캔버스 조회용 쿼리
	public int E144(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			
			String sql = new StringBuilder()
					.append("SELECT						                            \n")
					.append("	A.checklist_id,			                            \n")
					.append("	A.checklist_rev_no,		                            \n")
					.append("	A.regist_date,			                   	        \n")
					.append("	A.seq_no,		                           			\n")
					.append("	A.unsuit,			                   	    	    \n")
					.append("	A.defect_date,			                   	        \n")
					.append("	A.defect_detail,		                            \n")
					.append("	A.defect_result,									\n")
					.append("	improve_action,										\n")
					.append("	person_improve_id,									\n")
					.append("	verify_result,										\n")
					.append("	person_verify_id,		                            \n")
					.append("	B.user_nm as person_write_id,                       \n")
					.append("	B2.user_nm as person_check_id,                      \n")
					.append("	B3.user_nm as person_approve_id,              	    \n")
					.append("	file_name,						              	    \n")
					.append("	file_path,						             	    \n")
					.append("	file_rev_no,					             	    \n")
					.append("	regist_no						             	    \n")
					.append("FROM						                            \n")
					.append("	haccp_improve_record A	                            \n")
					.append("	INNER JOIN tbm_users B					            \n")
					.append("		ON A.person_write_id = B.user_id		        \n")
					.append("		AND  A.regist_date BETWEEN CAST(B.start_date AS DATE) AND CAST(B.duration_date AS DATE) \n")
					.append("	LEFT JOIN tbm_users B2					            \n")
					.append("		ON A.person_check_id = B2.user_id		        \n")
					.append("		AND  A.regist_date BETWEEN CAST(B2.start_date AS DATE) AND CAST(B2.duration_date AS DATE) \n")
					.append("	LEFT JOIN tbm_users B3					            \n")
					.append("		ON A.person_approve_id = B3.user_id	            \n")
					.append("		AND  A.regist_date BETWEEN CAST(B3.start_date AS DATE) AND CAST(B3.duration_date AS DATE) \n")
					.append("WHERE seq_no = "+ jArray.get("seq_no") + "				\n")
					.toString();

			resultString = super.excuteQueryString(con, sql);
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M838S070600E144()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M838S070600E144()","==== finally ===="+ e.getMessage());
				}
	    	} else {
	    	}
	    }
		ioParam.setResultString(resultString);
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
    	ioParam.setMessage(MessageDefine.M_QUERY_OK);

    	return EventDefine.E_QUERY_RESULT;
	}
	
	// 점검표 승인자 서명
	public int E502(InoutParameter ioParam){ 
		
		resultInt = EventDefine.E_DOEXCUTE_INIT;

		try {
			con = JDBCConnectionPool.getConnection();
			con.setAutoCommit(false);
			
    		JSONObject jObj = new JSONObject();
    		jObj = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
    		
    		String sql = new StringBuilder()
    				.append("UPDATE haccp_improve_record							\n")
    				.append("SET													\n")
    				.append("	person_approve_id = '" + jObj.get("userId") + "'	\n")
    				.append("WHERE seq_no = '"+ jObj.get("seq_no") + "'				\n")
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
			LoggingWriter.setLogError("M838S070600E502()","==== SQL ERROR ===="+ e.getMessage());
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
	
	// 점검표 확인자 서명
	public int E522(InoutParameter ioParam){ 
				
		resultInt = EventDefine.E_DOEXCUTE_INIT;

		try {
			con = JDBCConnectionPool.getConnection();
			con.setAutoCommit(false);
				
			JSONObject jObj = new JSONObject();
	    	jObj = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
	    		
	    	String sql = new StringBuilder()
	    			.append("UPDATE haccp_improve_record							\n")
	    			.append("SET													\n")
	    			.append("	person_check_id = '" + jObj.get("userId") + "'		\n")
	    			.append("WHERE seq_no = '"+ jObj.get("seq_no") + "'				\n")
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
				LoggingWriter.setLogError("M838S070600E522()","==== SQL ERROR ===="+ e.getMessage());
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