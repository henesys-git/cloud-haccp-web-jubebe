package mes.frame.business.M838;

import java.lang.reflect.Method;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.util.ArrayList;

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
public  class M838S080400 extends SqlAdapter{
	Connection con = null;
	PreparedStatement pstmt = null;
	String resultString = "";
	int resultInt = -1;
	StringBuffer sql = new StringBuffer();
	
	String[][] v_paramArray = new String[0][0]; 
	Class[] optClass = null;
	Object[] optObj = null;
	Object obj = null;
	
	public M838S080400(){
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
			
			Method method = M838S080400.class.getMethod(event,optClass);
			LoggingWriter.setLogDebug(M838S080400.class.getName(),"==== " + event + " EventMethod Create Success ====");

			obj = method.invoke(M838S080400.class.newInstance(),optObj);
			doExcute_result = CommonFunction.getInt(obj.toString());
			
	    } catch (Exception ex) {
	    	doExcute_result = EventDefine.E_DOEXCUTE_INIT;
			ioParam.setMessage(MessageDefine.M_NO_EVENTID);
			LoggingWriter.setLogError(M838S080400.class.getName(),"==== EventID Not define : EVENT ID [ " + ioParam.getEventID() + "]");
	    } finally {
	    	obj = null;
			optClass = null;
			optObj = null;
	    }
	    long endTime = System.currentTimeMillis();
		long runningTime = endTime - startTime;
		LoggingWriter.setLogAll(M838S080400.class.getName(),"==== Query [수행시간  : " + runningTime + " ms]");
		
		return doExcute_result;
	}
	
	// 건강검진 관리대장 등록
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
    				.append("SELECT A.regist_seq_no\n")
    				.append("	FROM\n")
    				.append("		haccp_health A \n")
    				.append("WHERE ROWNUM = 1\n")
    				.append("ORDER BY A.regist_seq_no DESC\n")
    				.toString();

			resultString = super.excuteQueryString(con, sql.toString());
	    	int cnt = 0, regist_seq_no = 0;
	    	
    		if(resultString.length() > 0) {
    			
    			regist_seq_no = Integer.parseInt(resultString.trim());
    			
    			sql = new StringBuilder()
    					.append("SELECT COUNT(seq_no)\n")
    					.append("	FROM\n")
    					.append("		haccp_health_employee \n")
    					.append("WHERE regist_seq_no = "+regist_seq_no+"\n")
    					.toString();

    			resultString = super.excuteQueryString(con, sql.toString());
    			
        		cnt = Integer.parseInt(resultString.trim());
        		
    		} 
    			
    		if(resultString.length() == 0 || cnt >= 18) {
    			
    			sql = new StringBuilder()
					.append("INSERT INTO										\n")
					.append("	haccp_health (									\n")
					.append("		checklist_id,								\n")
					.append("		checklist_rev_no							\n")
					.append(" 		)											\n")
					.append("VALUES (											\n")
					.append(" 		'checklist21',								\n")
					.append("		(SELECT MAX(checklist_rev_no)				\n")
					.append("		FROM checklist								\n")
					.append("		WHERE checklist_id = 'checklist21')			\n")
					.append("		)											\n")
					.toString();
			
				resultInt = super.excuteUpdate(con, sql.toString());
		    	if(resultInt < 0){
					ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
					con.rollback();
					return EventDefine.E_DOEXCUTE_ERROR ;
				}
    		    	
		    	sql = new StringBuilder()
        				.append("SELECT regist_seq_no\n")
        				.append("FROM\n")
        				.append("	haccp_health \n")
        				.append("WHERE ROWNUM = 1\n")
        				.append("ORDER BY regist_seq_no DESC\n")
        				.toString();

        		resultString = super.excuteQueryString(con, sql.toString());
    	    	
        		regist_seq_no = Integer.parseInt(resultString.trim());
		    	
    		}
    		
    		sql = new StringBuilder()
				.append("INSERT INTO\n")
				.append("	haccp_health_employee (\n")
				.append("		regist_seq_no,\n")
				.append("		user_id,\n")
				.append("		revision_no,\n")
				.append("		checkup_date,\n")
				.append("		next_checkup_date,\n")
				.append("		person_write_id\n")
				.append("	)\n")
				.append("VALUES\n")
				.append("	(\n")
				.append("		"+regist_seq_no+",\n")
				.append("		'"+jArray.get("checkup_id").toString()+"',\n")
				.append("		(SELECT MAX(revision_no)				\n")
				.append("		FROM tbm_users							\n")
				.append("		WHERE user_id = '"+jArray.get("checkup_id").toString()+"'),\n")
				.append("		'"+jArray.get("checkup_date").toString()+"',\n")
				.append("		'"+jArray.get("next_checkup_date").toString()+"',\n")
				.append("		'"+jArray.get("person_write_id").toString()+"'\n")
				.append("	);\n")
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
			LoggingWriter.setLogError("M838S080400E101()","==== SQL ERROR ===="+ e.getMessage());
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

	// 건강검진 관리대장 수정
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
    				.append("UPDATE																\n")
    				.append("	haccp_health_employee SET							  			\n")
    				.append("		checkup_date = '"	+ jArray.get("checkup_date") + "',		\n")
//    				.append("		user_id = '"	+ jArray.get("checkup_id") + "',			\n")
//    				.append("		revision_no = (SELECT MAX(revision_no)						\n")
//    				.append("						FROM tbm_users								\n")
//    				.append("						WHERE user_id = '"+jArray.get("checkup_id").toString()+"'),	\n")
    				.append("		next_checkup_date = '"	+ jArray.get("next_checkup_date") + "',	\n")
    				.append("		person_write_id = '"	+ jArray.get("person_write_id") + "',\n")
    				.append("		person_check_id = '',\n")
    				.append("		person_approve_id = ''\n")
    				.append("WHERE checkup_date = 		'"+ jArray.get("checkup_date2") + "'	\n")
    				.append("AND seq_no =  '"+ jArray.get("seq_no") + "' 						\n")
    				.append("AND regist_seq_no =  "+ jArray.get("regist_seq_no") + " 			\n")
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
			LoggingWriter.setLogError("M838S080400E102()","==== SQL ERROR ===="+ e.getMessage());
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

	// 건강검진 관리대장 삭제
	public int E103(InoutParameter ioParam){ 
		resultInt = EventDefine.E_DOEXCUTE_INIT;

		try {
			con = JDBCConnectionPool.getConnection();
			con.setAutoCommit(false);
			
    		JSONObject jArray = new JSONObject();
    		jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
    		System.out.println("JSONObject jArray rcvData="+ jArray.toString());

    		String sql = new StringBuilder()
    				.append("DELETE FROM													 	 \n")
    				.append("	haccp_health_employee 											 \n")
    				.append("WHERE regist_seq_no = '"+ jArray.get("regist_seq_no") + "'	 \n")
    				.append("  AND seq_no = '"+ jArray.get("seq_no") + "'	 \n")
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
			LoggingWriter.setLogError("M838S080400E103()","==== SQL ERROR ===="+ e.getMessage());
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

	// 건강검진 관리대장 메인 테이블 조회
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
					.append("	checkup_date,\n")
					.append("	seq_no,\n")
					.append("	A.regist_seq_no,\n")
					.append("	C.user_nm AS checkup_nm,\n")
					.append("	B.user_id,\n")
					.append("	B.revision_no,\n")
					.append("	next_checkup_date,\n")
					.append("	D.user_nm AS person_write_id,\n")
					.append("	D2.user_nm AS person_check_id,\n")
					.append("	D3.user_nm AS person_approve_id,\n")
					.append("	regist_no,						\n")
					.append("	file_name,						\n")
					.append("	file_path,						\n")
					.append("	file_rev_no,					\n")
					.append("	file_path						\n")
					.append("FROM\n")
					.append("	haccp_health A \n")
					.append("	JOIN haccp_health_employee B\n")
					.append("		ON A.regist_seq_no = B.regist_seq_no\n")
					.append("	LEFT JOIN tbm_users C\n")
					.append("		ON B.user_id = C.user_id\n")
					.append("	LEFT JOIN tbm_users D\n")
					.append("		ON B.person_write_id = D.user_id\n")
					.append("		AND B.checkup_date BETWEEN D.start_date AND D.duration_date\n")
					.append("	LEFT JOIN tbm_users D2\n")
					.append("		ON B.person_check_id = D2.user_id\n")
					.append("		AND B.checkup_date BETWEEN D2.start_date AND D2.duration_date\n")
					.append("	LEFT JOIN tbm_users D3\n")
					.append("		ON B.person_approve_id = D3.user_id\n")
					.append("		AND B.checkup_date BETWEEN D3.start_date AND D3.duration_date\n")
					.append("WHERE B.checkup_date Between '"+ jArray.get("fromdate") + "' \n")
					.append("                 		  AND '"+ jArray.get("todate") + "'   \n")
					.append("ORDER BY checkup_date DESC, seq_no DESC\n")
					.toString();
			
			String ActionCommand = ioParam.getActionCommand();
			if(ActionCommand.startsWith("doQueryTableFieldName")) {
				resultString = super.excuteQueryStringTableFieldName(con, sql.toString());
			} else {
				resultString = super.excuteQueryString(con, sql.toString());
			}
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M838S080400E104()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) {
						con.close();
					}
				} catch (Exception e) {
					LoggingWriter.setLogError("M838S080400E104()","==== finally ===="+ e.getMessage());
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
    				.append("	haccp_health_employee\n")
    				.append("ORDER BY seq_no DESC FOR ORDERBY_NUM()  = 1\n")
    				.toString();

			resultString = super.excuteQueryString(con, sql.toString());
    		
			sql = new StringBuilder()
					.append("UPDATE haccp_health_employee		  			  \n")
					.append("   SET file_name = '"+c_paramArray[0][10]+"',\n")	//file_view_name
					.append("   	file_path = '"+c_paramArray[0][11]+"',\n")	//file_path
					.append("   	regist_no = '"+c_paramArray[0][19]+"' \n")	//regist_no
					.append(" WHERE seq_no = "+resultString.trim()+"	  \n")
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
			LoggingWriter.setLogError("M838S080400E111()","==== SQL ERROR ===="+ e.getMessage());
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
					.append("UPDATE haccp_health_employee					\n")
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
			LoggingWriter.setLogError("M838S080400E112()","==== SQL ERROR ===="+ e.getMessage());
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
					.append("UPDATE haccp_health_employee				\n")
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
			LoggingWriter.setLogError("M838S080400E113()","==== SQL ERROR ===="+ e.getMessage());
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
	
	// checklist21_20210510.jsp
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
					.append("	seq_no,\n")
					.append("	A.regist_seq_no,\n")
					.append("	B.user_id,\n")
					.append("	B.revision_no,\n")
					.append("	C.user_nm AS checkup_nm,\n")
					.append("	checkup_date,\n")
					.append("	next_checkup_date,\n")
					.append("	D.user_nm AS person_write_id,\n")
					.append("	D2.user_nm AS person_check_id,\n")
					.append("	D3.user_nm AS person_approve_id\n")
					.append("FROM\n")
					.append("	haccp_health A \n")
					.append("	JOIN haccp_health_employee B\n")
					.append("		ON A.regist_seq_no = B.regist_seq_no\n")
					.append("	LEFT JOIN tbm_users C\n")
					.append("		ON B.user_id = C.user_id\n")
					.append("	LEFT JOIN tbm_users D\n")
					.append("		ON B.person_write_id = D.user_id\n")
					.append("		AND B.checkup_date BETWEEN D.start_date AND D.duration_date\n")
					.append("	LEFT JOIN tbm_users D2\n")
					.append("		ON B.person_check_id = D2.user_id\n")
					.append("		AND B.checkup_date BETWEEN D2.start_date AND D2.duration_date\n")
					.append("	LEFT JOIN tbm_users D3\n")
					.append("		ON B.person_approve_id = D3.user_id\n")
					.append("		AND B.checkup_date BETWEEN D3.start_date AND D3.duration_date\n")
					.append("WHERE A.regist_seq_no = '"+jArray.get("regist_seq_no")+"'\n")
					.append("  AND A.checklist_id = '"+jArray.get("checklist_id")+"'	\n")
					.append("  AND A.checklist_rev_no = '"+jArray.get("checklist_rev_no")+"'	\n")
					.append("ORDER BY checkup_date ASC, seq_no ASC\n")
					.toString();
			
			String ActionCommand = ioParam.getActionCommand();
			if(ActionCommand.startsWith("doQueryTableFieldName")) {
				resultString = super.excuteQueryStringTableFieldName(con, sql.toString());
			} else {
				resultString = super.excuteQueryString(con, sql.toString());
			}
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M838S080400E144()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M838S080400E144()","==== finally ===="+ e.getMessage());
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
	
	// 승인자 서명
	public int E502(InoutParameter ioParam){ 
		
		resultInt = EventDefine.E_DOEXCUTE_INIT;

		try {
			con = JDBCConnectionPool.getConnection();
			con.setAutoCommit(false);
			
    		JSONObject jObj = new JSONObject();
    		jObj = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
    		
    		String sql = new StringBuilder()
    				.append("UPDATE haccp_health_employee								\n")
    				.append("SET														\n")
    				.append("	person_approve_id = '" + jObj.get("userId") + "'		\n")
    				.append("WHERE checkup_date = '"+ jObj.get("checklistDate") + "'	\n")
    				.append("  AND seq_no = '"+ jObj.get("seq_no") + "'					\n")
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
			LoggingWriter.setLogError("M838S080400E502()","==== SQL ERROR ===="+ e.getMessage());
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
	
	// 확인자 서명
	public int E512(InoutParameter ioParam){ 
		
		resultInt = EventDefine.E_DOEXCUTE_INIT;

		try {
			con = JDBCConnectionPool.getConnection();
			con.setAutoCommit(false);
			
    		JSONObject jObj = new JSONObject();
    		jObj = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
    		
    		String sql = new StringBuilder()
    				.append("UPDATE haccp_health_employee								\n")
    				.append("SET														\n")
    				.append("	person_check_id = '" + jObj.get("userId") + "'			\n")
    				.append("WHERE checkup_date = '"+ jObj.get("checklistDate") + "'	\n")
    				.append("  AND seq_no = '"+ jObj.get("seq_no") + "'					\n")
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
			LoggingWriter.setLogError("M838S80400E512()","==== SQL ERROR ===="+ e.getMessage());
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