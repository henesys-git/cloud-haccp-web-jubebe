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


/**
 * 개요 : 이벤트ID별 메소드 정의
 */
public  class M838S015300 extends SqlAdapter{
	Connection con = null;
	PreparedStatement pstmt = null;
	String resultString = "";
	int resultInt = -1;
	StringBuffer sql = new StringBuffer();
	
	String[][] v_paramArray = new String[0][0]; 
	Class[] optClass = null;
	Object[] optObj = null;
	Object obj = null;
	
	public M838S015300(){
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
			
			Method method = M838S015300.class.getMethod(event,optClass);
			LoggingWriter.setLogDebug(M838S015300.class.getName(),"==== " + event + " EventMethod Create Success ====");

			obj = method.invoke(M838S015300.class.newInstance(),optObj);
			doExcute_result = CommonFunction.getInt(obj.toString());
			
	    } catch (Exception ex) {
	    	doExcute_result = EventDefine.E_DOEXCUTE_INIT;
			ioParam.setMessage(MessageDefine.M_NO_EVENTID);
			LoggingWriter.setLogError(M838S015300.class.getName(),"==== EventID Not define : EVENT ID [ " + ioParam.getEventID() + "]");
	    } finally {
	    	obj = null;
			optClass = null;
			optObj = null;
	    }
	    long endTime = System.currentTimeMillis();
		long runningTime = endTime - startTime;
		LoggingWriter.setLogAll(M838S015300.class.getName(),"==== Query [수행시간  : " + runningTime + " ms]");
		
		return doExcute_result;
	}
	
	// 모니터링 일지 등록
	public int E101(InoutParameter ioParam){ 
		
		String sql = "";
		
		resultInt = EventDefine.E_DOEXCUTE_INIT;

		try {
			con = JDBCConnectionPool.getConnection();
			con.setAutoCommit(false);
			
    		JSONObject jArray = new JSONObject();
    		jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
    		System.out.println("JSONObject jArray rcvData="+ jArray.toString());
    			
    			sql = new StringBuilder()
    				.append("INSERT INTO					\n")
    				.append("	haccp_ccp_2p (				\n")
    				.append("		checklist_id,			\n")
    				.append("		checklist_rev_no,		\n")
    				.append("		ccp_date,				\n")
    				.append("       person_write_id, 		\n")
    				.append("       unsuit_detail,			\n")
    				.append("       improve_action_result	\n")
    				.append(" 		)						\n")
    				.append("VALUES (											\n")
					.append(" 		'"	+ jArray.get("checklist_id") + "',		\n")
					.append(" 		'"	+ jArray.get("checklist_rev_no") + "',	\n")
					.append(" 		'"	+ jArray.get("ccp_date") + "',			\n")
					.append(" 		'"	+ jArray.get("person_write_id") + "',	\n")
					.append(" 		'"	+ jArray.get("unsuit_detail") + "',		\n")
					.append(" 		'"	+ jArray.get("improve_action_result") + "' \n")
					.append("	) 												\n")
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
			LoggingWriter.setLogError("M838S015300E101()","==== SQL ERROR ===="+ e.getMessage());
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
	
	// 모니터링 일지 수정
	public int E102(InoutParameter ioParam){ 
		
		String sql = "";
		
		resultInt = EventDefine.E_DOEXCUTE_INIT;

		try {
			con = JDBCConnectionPool.getConnection();
			con.setAutoCommit(false);
			
    		JSONObject jArray = new JSONObject();
    		jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
    		System.out.println("JSONObject jArray rcvData="+ jArray.toString());
    		
    		sql = new StringBuilder()
    				.append("UPDATE																	\n")
    				.append("	haccp_ccp_2p SET									  				\n")
    				.append("       unsuit_detail   = '" + jArray.get("unsuit_detail") + "', 		\n")
    				.append("       improve_action_result   = '" + jArray.get("improve_action_result") + "', \n")
    				.append("       person_write_id   = '" + jArray.get("person_write_id") + "' 	\n")
    				.append("WHERE ccp_date = 		'"+ jArray.get("ccp_date") + "'					\n")
    				
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
			LoggingWriter.setLogError("M838S015300E102()","==== SQL ERROR ===="+ e.getMessage());
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
	
	// 측정일지 수정
	public int E112(InoutParameter ioParam){ 
		
		resultInt = EventDefine.E_DOEXCUTE_INIT;

		try {
			con = JDBCConnectionPool.getConnection();
			con.setAutoCommit(false);
			
    		JSONObject jArray = new JSONObject();
    		jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));

    		String sql = new StringBuilder()
    				.append("UPDATE\n")
    				.append("	haccp_ccp_2p_detail\n")
    				.append("SET\n")
    				.append("	person_sign_id = '',\n")
    				.append("	remarks = '"+jArray.get("remarks").toString()+"'\n")
    				.append("WHERE\n")
    				.append("	check_time = TIME '"+jArray.get("check_time").toString()+"'\n")
    				.append("	AND seq_no = "+jArray.get("seq_no").toString().trim()+"\n")
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
			LoggingWriter.setLogError("M838S015300E112()","==== SQL ERROR ===="+ e.getMessage());
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
	

	// 모니터링 일지 삭제
	public int E103(InoutParameter ioParam){ 
		resultInt = EventDefine.E_DOEXCUTE_INIT;

		try {
			con = JDBCConnectionPool.getConnection();
			con.setAutoCommit(false);
			
    		JSONObject jArray = new JSONObject();
    		jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
    		System.out.println("JSONObject jArray rcvData="+ jArray.toString());

    		String sql = new StringBuilder()
    				.append("DELETE FROM										\n")
    				.append("	haccp_ccp_2p									\n")
    				.append("WHERE ccp_date = '"+ jArray.get("ccp_date") + "'	\n")
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
			LoggingWriter.setLogError("M838S015300E103()","==== SQL ERROR ===="+ e.getMessage());
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
	
	
	// 모니터링 일지 내 측정일지 삭제
	public int E113(InoutParameter ioParam){ 
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		String sql = "";

		try {
			con = JDBCConnectionPool.getConnection();
			con.setAutoCommit(false);
			
    		JSONObject jArray = new JSONObject();
    		jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
    		System.out.println("JSONObject jArray rcvData="+ jArray.toString());
    		
    		sql = new StringBuilder()
    				.append("DELETE FROM													 \n")
    				.append("	haccp_ccp_2p_head										 	 \n")
    				.append("WHERE ccp_date=  '"+ jArray.get("ccp_date") + "'			 	 \n")
    				.append("AND prod_cd =  '"+ jArray.get("prod_cd") + "' 				 	 \n")
    				.append("AND revision_no =  '"+ jArray.get("revision_no") + "' 			 \n")
					.toString();
		
			resultInt = super.excuteUpdate(con, sql.toString());
	    	if(resultInt < 0){
				ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
				con.rollback();
				return EventDefine.E_DOEXCUTE_ERROR ;
			}
    		
    		sql = new StringBuilder()
    				.append("DELETE FROM													 \n")
    				.append("	haccp_ccp_2p_detail 										 \n")
    				.append("WHERE check_time =  '"+ jArray.get("check_time") + "'			 \n")
    				.append("AND ccp_date =  '"+ jArray.get("ccp_date") + "' 				 \n")
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
			LoggingWriter.setLogError("M838S015300E113()","==== SQL ERROR ===="+ e.getMessage());
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
	
	
	// CCP-2P 모니터링일지 메인 테이블 조회
	public int E104(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));

			String sql = new StringBuilder()
					.append("SELECT\n")
					.append("	checklist_id,\n")
					.append("	checklist_rev_no,\n")
					.append("	ccp_date,\n")
					.append("	C.user_nm AS person_monitoring_id,\n")
					.append("	C.user_nm AS person_write_id,\n")
					.append("	D.user_nm AS person_check_id,\n")
					.append("	E.user_nm AS person_approve_id,\n")
					.append("	TO_CHAR(record_time, 'HH24:MI') as record_time,\n")
					.append("	F.user_nm AS record_qm_id,\n")
					.append("	TO_CHAR(inspect_time, 'HH24:MI') as inspect_time,\n")
					.append("	G.user_nm AS inspect_qm_id\n")
					.append("FROM\n")
					.append("	haccp_ccp_2p A\n")
					.append("	LEFT JOIN tbm_users C\n")
					.append("		ON A.person_write_id = C.user_id\n")
					.append("		AND A.ccp_date BETWEEN C.start_date AND C.duration_date\n")
					.append("	LEFT JOIN tbm_users D\n")
					.append("		ON A.person_check_id = D.user_id\n")
					.append("		AND A.ccp_date BETWEEN D.start_date AND D.duration_date\n")
					.append("	LEFT JOIN tbm_users E\n")
					.append("		ON A.person_approve_id = E.user_id\n")
					.append("		AND A.ccp_date BETWEEN E.start_date AND E.duration_date\n")
					.append("	LEFT JOIN tbm_users F\n")
					.append("		ON A.record_qm_id = F.user_id\n")
					.append("		AND A.ccp_date BETWEEN F.start_date AND F.duration_date\n")
					.append("	LEFT JOIN tbm_users G\n")
					.append("		ON A.inspect_qm_id = G.user_id\n")
					.append("		AND A.ccp_date BETWEEN G.start_date AND G.duration_date\n")
					.append("WHERE A.ccp_date BETWEEN '"+ jArray.get("fromdate") + "' AND '"+ jArray.get("todate") + "' \n")
					.append("ORDER BY ccp_date DESC \n")
					.toString();

			String ActionCommand = ioParam.getActionCommand();
			if(ActionCommand.startsWith("doQueryTableFieldName")) {
				resultString = super.excuteQueryStringTableFieldName(con, sql.toString());
			} else {
				resultString = super.excuteQueryString(con, sql.toString());
			}
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M838S015300E104()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) {
						con.close();
					}
				} catch (Exception e) {
					LoggingWriter.setLogError("M838S015300E104()","==== finally ===="+ e.getMessage());
				}
	    	}
	    }

		ioParam.setResultString(resultString);
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
    	ioParam.setMessage(MessageDefine.M_QUERY_OK);

    	return EventDefine.E_QUERY_RESULT;
	}
	
	// 모니터링 일지 서브 테이블 조회
	public int E114(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));

			String sql = new StringBuilder()
					.append("SELECT\n")
					.append("	checklist_id,\n")
					.append("	checklist_rev_no,\n")
					.append("	D.ccp_date,\n")
					.append("	seq_no,\n")
					.append("	check_time,\n")
					.append("	prod_nm,\n")
					.append("	fe_result,\n")
					.append("	sus_result,\n")
					.append("	U.user_nm AS person_sign_id,\n")
					.append("	remarks\n")
					.append("FROM\n")
					.append("	haccp_ccp_2p_detail D JOIN haccp_ccp_2p C\n")
					.append("	ON D.ccp_date = C.ccp_date\n")
					.append("	LEFT JOIN tbm_users U\n")
					.append("	ON D.person_sign_id = U.user_id\n")
					.append("	AND D.ccp_date BETWEEN U.start_date AND U.duration_date\n")
					.append("WHERE D.ccp_date = '"+jArray.get("ccp_date").toString()+"'\n")
					.append("ORDER BY check_time DESC\n")
					.toString();

			String ActionCommand = ioParam.getActionCommand();
			if(ActionCommand.startsWith("doQueryTableFieldName")) {
				resultString = super.excuteQueryStringTableFieldName(con, sql.toString());
			} else {
				resultString = super.excuteQueryString(con, sql.toString());
			}
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M838S015300E114()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) {
						con.close();
					}
				} catch (Exception e) {
					LoggingWriter.setLogError("M838S015300E114()","==== finally ===="+ e.getMessage());
				}
	    	}
	    }

		ioParam.setResultString(resultString);
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
    	ioParam.setMessage(MessageDefine.M_QUERY_OK);

    	return EventDefine.E_QUERY_RESULT;
	}
	
	
	// checklist03_20210420.jsp_headData
	public int E144(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			
			String sql = new StringBuilder()
					.append("SELECT\n")
					.append("	checklist_id,\n")
					.append("	checklist_rev_no,\n")
					.append("	TO_CHAR(A.ccp_date, 'YYYY\"년 \"MM\"월 \"DD\"일 \"' ) AS ccp_date,\n")
					.append("	C.user_nm AS person_monitoring_id,\n")
					.append("	C.user_nm AS person_write_id,\n")
					.append("	D.user_nm AS person_check_id,\n")
					.append("	E.user_nm AS person_approve_id,\n")
					.append("	TO_CHAR(record_time, 'HH24\"시 \"MI\"분\" ') as record_time,\n")
					.append("	F.user_nm AS record_qm_id,\n")
					.append("	TO_CHAR(inspect_time, 'HH24\"시 \"MI\"분\" ') as inspect_time,\n")
					.append("	G.user_nm AS inspect_qm_id\n")
					.append("FROM\n")
					.append("	haccp_ccp_2p A\n")
					.append("	LEFT JOIN tbm_users C\n")
					.append("		ON A.person_write_id = C.user_id\n")
					.append("		AND A.ccp_date BETWEEN C.start_date AND C.duration_date\n")
					.append("	LEFT JOIN tbm_users D\n")
					.append("		ON A.person_check_id = D.user_id\n")
					.append("		AND A.ccp_date BETWEEN D.start_date AND D.duration_date\n")
					.append("	LEFT JOIN tbm_users E\n")
					.append("		ON A.person_approve_id = E.user_id\n")
					.append("		AND A.ccp_date BETWEEN E.start_date AND E.duration_date\n")
					.append("	LEFT JOIN tbm_users F\n")
					.append("		ON A.record_qm_id = F.user_id\n")
					.append("		AND A.ccp_date BETWEEN F.start_date AND F.duration_date\n")
					.append("	LEFT JOIN tbm_users G\n")
					.append("		ON A.inspect_qm_id = G.user_id\n")
					.append("		AND A.ccp_date BETWEEN G.start_date AND G.duration_date\n")
					.append("WHERE A.ccp_date = '"+ jArray.get("ccp_date") + "' \n")
					.toString();

			String ActionCommand = ioParam.getActionCommand();
			if(ActionCommand.startsWith("doQueryTableFieldName")) {
				resultString = super.excuteQueryStringTableFieldName(con, sql.toString());
			} else {
				resultString = super.excuteQueryString(con, sql.toString());
			}
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M838S015300E144()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M838S015300E144()","==== finally ===="+ e.getMessage());
				}
	    	} else {
	    	}
	    }
	    // 결과 전문 구성을 위한 파라미터들을 아이오 파라미터에 저장한다.
		ioParam.setResultString(resultString);
		// 수퍼에서 처리된 칼럼의 갯수를 클라이언트에게 보내기 위해 가져온다.
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
		// 잘 처리되었다는 메시지를 클라이언트에게 보내기 위해 I/O파라미터에 저장한다.
    	ioParam.setMessage(MessageDefine.M_QUERY_OK);
	    return EventDefine.E_QUERY_RESULT;
	}
	
	// checklist03_20210420.jsp_mainData
	public int E154(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			
			
			String sql = new StringBuilder()
					.append("SELECT\n")
					.append("	seq_no,\n")
					.append("	TO_CHAR(check_time, 'HH24:MI') AS check_time,\n")
					.append("	prod_nm,\n")
					.append("	fe_result,\n")
					.append("	sus_result,\n")
					.append("	U.user_nm AS person_sign_id,\n")
					.append("	remarks\n")
					.append("FROM\n")
					.append("	haccp_ccp_2p_detail D\n")
					.append("	LEFT JOIN tbm_users U\n")
					.append("	ON D.person_sign_id = U.user_id\n")
					.append("	AND ccp_date BETWEEN DATE(U.start_date) AND DATE(U.duration_date)\n")
					.append("WHERE\n")
					.append("	ccp_date = '"+jArray.get("ccp_date")+"' AND ROWNUM < 9\n")
					.append("ORDER BY check_time ASC\n")
					.toString();

			String ActionCommand = ioParam.getActionCommand();
			if(ActionCommand.startsWith("doQueryTableFieldName")) {
				resultString = super.excuteQueryStringTableFieldName(con, sql.toString());
			} else {
				resultString = super.excuteQueryString(con, sql.toString());
			}
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M838S015300E154()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M838S015300E154()","==== finally ===="+ e.getMessage());
				}
	    	} else {
	    	}
	    }
	    // 결과 전문 구성을 위한 파라미터들을 아이오 파라미터에 저장한다.
		ioParam.setResultString(resultString);
		// 수퍼에서 처리된 칼럼의 갯수를 클라이언트에게 보내기 위해 가져온다.
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
		// 잘 처리되었다는 메시지를 클라이언트에게 보내기 위해 I/O파라미터에 저장한다.
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
    				.append("UPDATE haccp_ccp_2p											\n")
    				.append("SET															\n")
    				.append("	person_approve_id = '" + jObj.get("userId") + "'			\n")
    				.append("WHERE ccp_date = '"+ jObj.get("checklistDate") + "'			\n")
    				.append("  AND checklist_id = '"+ jObj.get("checklistId") + "'			\n")
    				.append("  AND checklist_rev_no = '"+ jObj.get("checklistRevNo") + "'	\n")
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
			LoggingWriter.setLogError("M838S015300E502()","==== SQL ERROR ===="+ e.getMessage());
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
	
	// 검토자 서명
	public int E512(InoutParameter ioParam){ 
		
		resultInt = EventDefine.E_DOEXCUTE_INIT;

		try {
			con = JDBCConnectionPool.getConnection();
			con.setAutoCommit(false);
			
			JSONObject jObj = new JSONObject();
    		jObj = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
    		
    		String sql = new StringBuilder()
    				.append("UPDATE haccp_ccp_2p											\n")
    				.append("SET															\n")
    				.append("	person_check_id = '" + jObj.get("userId") + "'				\n")
    				.append("WHERE ccp_date = '"+ jObj.get("checklistDate") + "'			\n")
    				.append("  AND checklist_id = '"+ jObj.get("checklistId") + "'			\n")
    				.append("  AND checklist_rev_no = '"+ jObj.get("checklistRevNo") + "'	\n")
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
			LoggingWriter.setLogError("M838S015300E512()","==== SQL ERROR ===="+ e.getMessage());
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
	
	// 품질관리팀장 서명
	public int E522(InoutParameter ioParam){ 
		
		resultInt = EventDefine.E_DOEXCUTE_INIT;

		try {
			con = JDBCConnectionPool.getConnection();
			con.setAutoCommit(false);
			
			JSONObject jObj = new JSONObject();
    		jObj = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
    		
    		String sql = new StringBuilder()
    				.append("UPDATE haccp_ccp_2p											\n")
    				.append("SET															\n")
    				.append("	record_qm_id = '" + jObj.get("userId") + "',				\n")
    				.append("	record_time = TIME '" + jObj.get("recordTime") + "'			\n")
    				.append("WHERE ccp_date = '"+ jObj.get("checklistDate") + "'			\n")
    				.append("  AND checklist_id = '"+ jObj.get("checklistId") + "'			\n")
    				.append("  AND checklist_rev_no = '"+ jObj.get("checklistRevNo") + "'	\n")
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
			LoggingWriter.setLogError("M838S015300E522()","==== SQL ERROR ===="+ e.getMessage());
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
	
	// 품질관리팀장 서명
	public int E532(InoutParameter ioParam){ 
		
		resultInt = EventDefine.E_DOEXCUTE_INIT;

		try {
			con = JDBCConnectionPool.getConnection();
			con.setAutoCommit(false);
			
			JSONObject jObj = new JSONObject();
    		jObj = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
    		
    		String sql = new StringBuilder()
    				.append("UPDATE haccp_ccp_2p											\n")
    				.append("SET															\n")
    				.append("	inspect_qm_id = '" + jObj.get("userId") + "',				\n")
    				.append("	inspect_time = TIME '" + jObj.get("recordTime") + "'		\n")
    				.append("WHERE ccp_date = '"+ jObj.get("checklistDate") + "'			\n")
    				.append("  AND checklist_id = '"+ jObj.get("checklistId") + "'			\n")
    				.append("  AND checklist_rev_no = '"+ jObj.get("checklistRevNo") + "'	\n")
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
			LoggingWriter.setLogError("M838S015300E532()","==== SQL ERROR ===="+ e.getMessage());
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
	
	// 측정일지 점검자 서명
	public int E542(InoutParameter ioParam){ 
		
		resultInt = EventDefine.E_DOEXCUTE_INIT;

		try {
			con = JDBCConnectionPool.getConnection();
			con.setAutoCommit(false);
			
			JSONObject jObj = new JSONObject();
    		jObj = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
    		
    		String sql = new StringBuilder()
    				.append("UPDATE haccp_ccp_2p_detail								\n")
    				.append("SET													\n")
    				.append("	person_sign_id = '" + jObj.get("userId") + "'		\n")
    				.append("WHERE ccp_date = '"+ jObj.get("checklistDate") + "'	\n")
    				.append("  AND seq_no = '"+ jObj.get("seq_no") + "'				\n")
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
			LoggingWriter.setLogError("M838S015300E522()","==== SQL ERROR ===="+ e.getMessage());
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
		
	// 측정일지 점검자 일괄서명
	public int E552(InoutParameter ioParam){ 
		
		resultInt = EventDefine.E_DOEXCUTE_INIT;

		try {
			con = JDBCConnectionPool.getConnection();
			con.setAutoCommit(false);
			
			JSONObject jObj = new JSONObject();
    		jObj = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
    		
    		String sql = new StringBuilder()
    				.append("UPDATE haccp_ccp_2p_detail								 	\n")
    				.append("SET														\n")
    				.append("	person_sign_id = '" + jObj.get("userId") + "'			\n")
    				.append("WHERE ccp_date = '"+ jObj.get("ccp_date") + "'				\n")
    				.append("  AND ( person_sign_id IS NULL OR person_sign_id = '' )	\n")
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
			LoggingWriter.setLogError("M838S015300E522()","==== SQL ERROR ===="+ e.getMessage());
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