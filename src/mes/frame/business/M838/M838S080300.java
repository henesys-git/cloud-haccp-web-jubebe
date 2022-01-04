package mes.frame.business.M838;

import java.lang.reflect.Method;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.util.ArrayList;

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


/**
 * 개요 : 이벤트ID별 메소드 정의
 */
public  class M838S080300 extends SqlAdapter{
	Connection con = null;
	PreparedStatement pstmt = null;
	String resultString = "";
	int resultInt = -1;
	StringBuffer sql = new StringBuffer();
	
	String[][] v_paramArray = new String[0][0]; 
	Class[] optClass = null;
	Object[] optObj = null;
	Object obj = null;
	
	public M838S080300(){
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
			
			Method method = M838S080300.class.getMethod(event,optClass);
			LoggingWriter.setLogDebug(M838S080300.class.getName(),"==== " + event + " EventMethod Create Success ====");

			obj = method.invoke(M838S080300.class.newInstance(),optObj);
			doExcute_result = CommonFunction.getInt(obj.toString());
			
	    } catch (Exception ex) {
	    	doExcute_result = EventDefine.E_DOEXCUTE_INIT;
			ioParam.setMessage(MessageDefine.M_NO_EVENTID);
			LoggingWriter.setLogError(M838S080300.class.getName(),"==== EventID Not define : EVENT ID [ " + ioParam.getEventID() + "]");
	    } finally {
	    	obj = null;
			optClass = null;
			optObj = null;
	    }
	    long endTime = System.currentTimeMillis();
		long runningTime = endTime - startTime;
		LoggingWriter.setLogAll(M838S080300.class.getName(),"==== Query [수행시간  : " + runningTime + " ms]");
		
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
    		System.out.println("JSONObject jArray rcvData="+ jArray.toString());

    		String checklist_id = jArray.get("checklist_id").toString();
    		
    		ArrayList<String> valueArr = new ArrayList<String>(); 
    		
    		JSONArray formData = (JSONArray) jArray.get("form");
    		
    		for(int i = 0; i < formData.size(); i++) {
    			
    			JSONObject data = (JSONObject) formData.get(i); 
    			
    			valueArr.add(data.get("value").toString());
    			
    		}
    		
    		String sql = new StringBuilder()
    				.append("INSERT INTO					\n")
    				.append("	haccp_edu (					\n")
    				.append("		checklist_id,			\n")
    				.append("		checklist_rev_no,		\n")
    				.append("		edu_date,				\n")
    				.append("       edu_start_time,			\n")
    				.append(" 		edu_end_time,			\n")
    				.append("		edu_lecturer, 			\n")
    				.append("		edu_place, 				\n")
    				.append("		edu_target, 			\n")
    				.append("		edu_person_count, 		\n")
    				.append("		non_edu_person_count, 	\n")
    				.append("		edu_type, 				\n")
    				.append("		edu_topic, 				\n")
    				.append("		edu_detail, 			\n")
    				.append("		absentee_action, 		\n")
    				.append("		person_write_id 		\n")
    				.append(" 		)						\n")
    				.append("VALUES (											\n")
    				.append("		'"+checklist_id+"',							\n")
    				.append("		(SELECT MAX(checklist_rev_no)				\n")
    				.append("		FROM checklist								\n")
    				.append("		WHERE checklist_id = '"+checklist_id+"'),	\n")
					.append(" 		'"	+ valueArr.get(0) + "',					\n")
					.append(" 		'"	+ valueArr.get(1) + "',					\n")
					.append(" 		'"	+ valueArr.get(2) + "',					\n")
					.append(" 		'"	+ valueArr.get(3) + "',					\n")
					.append(" 		'"	+ valueArr.get(4) + "',					\n")
					.append(" 		'"	+ valueArr.get(5) + "',					\n")
					.append(" 		'"	+ valueArr.get(6) + "',					\n")
					.append(" 		'"	+ valueArr.get(7) + "',					\n")
					.append(" 		'"	+ valueArr.get(8) + "',					\n")
					.append(" 		'"	+ valueArr.get(9) + "',					\n")
					.append(" 		'"	+ valueArr.get(10) + "',				\n")
					.append(" 		'"	+ valueArr.get(11) + "',				\n")
					.append(" 		'"	+ jArray.get("person_write_id") + "'	\n")
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
			LoggingWriter.setLogError("M838S080300E101()","==== SQL ERROR ===="+ e.getMessage());
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

    		String seq_no = jArray.get("seq_no").toString().trim();
    		
    		ArrayList<String> valueArr = new ArrayList<String>(); 
    		
    		JSONArray formData = (JSONArray) jArray.get("form");
    		
    		for(int i = 0; i < formData.size(); i++) {
    			
    			JSONObject data = (JSONObject) formData.get(i); 
    			
    			valueArr.add(data.get("value").toString());
    			
    		}
    		
    		String sql = new StringBuilder()
    				.append("UPDATE\n")
    				.append("	haccp_edu\n")
    				.append("SET\n")
    				.append("	edu_date = '"+valueArr.get(0)+"',\n")
    				.append("	edu_start_time = '"+valueArr.get(1)+"',\n")
    				.append("	edu_end_time = '"+valueArr.get(2)+"',\n")
    				.append("	edu_lecturer = '"+valueArr.get(3)+"',\n")
    				.append("	edu_place = '"+valueArr.get(4)+"',\n")
    				.append("	edu_target = '"+valueArr.get(5)+"',\n")
    				.append("	edu_person_count = '"+valueArr.get(6)+"',\n")
    				.append("	non_edu_person_count = '"+valueArr.get(7)+"',\n")
    				.append("	edu_type = '"+valueArr.get(8)+"',\n")
    				.append("	edu_topic = '"+valueArr.get(9)+"',\n")
    				.append("	edu_detail = '"+valueArr.get(10)+"',\n")
    				.append("	absentee_action = '"+valueArr.get(11)+"',\n")
    				.append("	person_write_id = '"+jArray.get("person_write_id")+"',\n")
    				.append("	person_check_id = '',\n")
    				.append("	person_approve_id = ''\n")
    				.append("WHERE\n")
    				.append("	seq_no = "+seq_no+"\n")
    				.append("	AND checklist_id = '"+jArray.get("checklist_id").toString()+"'\n")
    				.append("	AND checklist_rev_no = "+jArray.get("checklist_rev_no").toString()+"\n")
    				.append("	AND edu_date = '"+jArray.get("org_edu_date").toString()+"' \n")
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
			LoggingWriter.setLogError("M838S080300E102()","==== SQL ERROR ===="+ e.getMessage());
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
	

	// 삭제
	public int E103(InoutParameter ioParam){ 
		resultInt = EventDefine.E_DOEXCUTE_INIT;

		try {
			con = JDBCConnectionPool.getConnection();
			con.setAutoCommit(false);
			
    		JSONObject jArray = new JSONObject();
    		jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
    		System.out.println("JSONObject jArray rcvData="+ jArray.toString());

	    	String sql = new StringBuilder()
    				.append("DELETE FROM haccp_edu 								 	 	 \n")
    				.append("WHERE seq_no = '"+ jArray.get("seq_no").toString() + "'	 \n")
    				.append("AND edu_date = '"+ jArray.get("edu_date").toString() + "'	 \n")
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
			LoggingWriter.setLogError("M838S080300E103()","==== SQL ERROR ===="+ e.getMessage());
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
	
	
	// 교육·훈련 기록부 메인 테이블 조회
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
					.append("	edu_date,\n")
					.append("	seq_no,\n")
					.append("	TO_CHAR(edu_start_time, 'HH24:MI') || ' ~ ' || TO_CHAR(edu_end_time, 'HH24:MI') AS edu_time,\n")
					.append("	edu_lecturer,\n")
					.append("	edu_place,\n")
					.append("	edu_target,\n")
					.append("	edu_person_count,\n")
					.append("	non_edu_person_count,\n")
					.append("	DECODE(edu_type,'1', '위생교육','2', 'HACCP교육','3', '직무교육','4', '보관운반교육', '기타'),\n")
					.append("	edu_topic,\n")
					.append("	REPLACE(REPLACE(edu_detail, CHR(13), ' '), CHR(10), ' ') AS edu_detail,\n")
					.append("	absentee_action,\n")
					.append("	C.user_nm AS person_write_id,\n")
					.append("	C2.user_nm AS person_check_id,\n")
					.append("	C3.user_nm AS person_approve_id,\n")
					.append("	parent_seq_no,\n")
					.append("	regist_no,\n")
					.append("	file_name,\n")
					.append("	file_path,\n")
					.append("	file_rev_no,\n")
					.append("	file_path\n")
					.append("FROM\n")
					.append("	haccp_edu A\n")
					.append("	LEFT JOIN tbm_users C					\n")
					.append("		ON A.person_write_id = C.user_id	\n")
					.append("		AND  A.edu_date BETWEEN CAST(C.start_date AS DATE) AND CAST(C.duration_date AS DATE) \n")
					.append("	LEFT JOIN tbm_users C2											\n")
					.append("		ON A.person_check_id = C2.user_id							\n")
					.append("		AND  A.edu_date BETWEEN CAST(C2.start_date AS DATE) AND CAST(C2.duration_date AS DATE) \n")
					.append("	LEFT JOIN tbm_users C3											\n")
					.append("		ON A.person_approve_id = C3.user_id							\n")
					.append("		AND  A.edu_date BETWEEN CAST(C3.start_date AS DATE) AND CAST(C3.duration_date AS DATE) \n")
					.append("WHERE A.edu_date Between '"+ jArray.get("fromdate") + "' \n")
					.append("                     AND '"+ jArray.get("todate") + "'   \n")
					.append("ORDER BY edu_date DESC, seq_no ASC \n")
					.toString();

			String ActionCommand = ioParam.getActionCommand();
			if(ActionCommand.startsWith("doQueryTableFieldName")) {
				resultString = super.excuteQueryStringTableFieldName(con, sql.toString());
			} else {
				resultString = super.excuteQueryString(con, sql.toString());
			}
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M838S080300E104()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) {
						con.close();
					}
				} catch (Exception e) {
					LoggingWriter.setLogError("M838S080300E104()","==== finally ===="+ e.getMessage());
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
    				.append("	haccp_edu\n")
    				.append("ORDER BY seq_no DESC FOR ORDERBY_NUM() = 1\n")
    				.toString();

			resultString = super.excuteQueryString(con, sql.toString());
    		
			sql = new StringBuilder()
					.append("UPDATE haccp_edu				  			  \n")
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
			LoggingWriter.setLogError("M838S080300E111()","==== SQL ERROR ===="+ e.getMessage());
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
					.append("UPDATE haccp_edu							\n")
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
			LoggingWriter.setLogError("M838S080300E112()","==== SQL ERROR ===="+ e.getMessage());
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
					.append("UPDATE haccp_edu					\n")
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
			LoggingWriter.setLogError("M838S080300E113()","==== SQL ERROR ===="+ e.getMessage());
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

	// 참석차 명단 추가를 위한 쿼리
	public int E124(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));

			String sql = new StringBuilder()
					.append("SELECT\n")
					.append("	' ',\n")
					.append("	user_id,\n")
					.append("	revision_no,\n")
					.append("	user_nm,\n")
					.append("	group_cd,\n")
					.append("	dept_cd,\n")
					.append("	jikwi\n")
					.append("FROM\n")
					.append("	tbm_users	\n")
					.append("WHERE\n")
					.append("	group_cd IN('GRCD001','GRCD002')\n")
					.append("	AND ! user_id IN( 'henesys', 'tester') \n")
					.append("	AND DATE'"+jArray.get("date").toString()+"' BETWEEN start_date AND duration_date\n")
					.append("ORDER BY user_nm ASC \n")
					.toString();

			String ActionCommand = ioParam.getActionCommand();
			if(ActionCommand.startsWith("doQueryTableFieldName")) {
				resultString = super.excuteQueryStringTableFieldName(con, sql.toString());
			} else {
				resultString = super.excuteQueryString(con, sql.toString());
			}
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M838S080300E124()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) {
						con.close();
					}
				} catch (Exception e) {
					LoggingWriter.setLogError("M838S080300E124()","==== finally ===="+ e.getMessage());
				}
	    	}
	    }

		ioParam.setResultString(resultString);
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
    	ioParam.setMessage(MessageDefine.M_QUERY_OK);

    	return EventDefine.E_QUERY_RESULT;
	}
	
	// S838S080300_canvas.jsp
	public int E144(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			
			String sql = new StringBuilder()
					.append("SELECT DISTINCT\n")
					.append("	checklist_id,\n")
					.append("	checklist_rev_no,\n")
					.append("	edu_date,\n")
					.append("	A.seq_no,\n")
					.append("	TO_CHAR(edu_date, 'YYYY') || '년 ' || TO_CHAR(edu_date, 'MM') || '월 ' || TO_CHAR(edu_date, 'DD') || '일' AS edu_date2,\n")
					.append("	TO_CHAR(edu_start_time, 'HH24') || '시 ' || TO_CHAR(edu_start_time, 'MI') || '분 ~ ' || TO_CHAR(edu_end_time, 'HH24') || '시 ' || TO_CHAR(edu_end_time, 'MI') || '분',\n")
					.append("	TO_CHAR(edu_start_time, 'HH24:MI') as edu_start_time, \n")
					.append("	TO_CHAR(edu_end_time, 'HH24:MI') AS edu_end_time,\n")
					.append("	edu_lecturer,\n")
					.append("	edu_place,\n")
					.append("	edu_target,\n")
					.append("	edu_person_count,\n")
					.append("	non_edu_person_count,\n")
					.append("	edu_type,\n")
					.append("	DECODE(edu_type,'1', '위생교육','2', 'HACCP교육','3', '직무교육','4', '보관운반교육', '기타') AS decode_edu_type,\n")
					.append("	edu_topic,\n")
					.append("	REPLACE(REPLACE(edu_detail, CHR(13), ' '), CHR(10), ' ') AS edu_detail,\n")
					.append("	absentee_action,\n")
					.append("	C.user_nm AS person_write_id,\n")
					.append("	C2.user_nm AS person_check_id,\n")
					.append("	C3.user_nm AS person_approve_id,\n")
					.append("	parent_seq_no,\n")	
					.append("	regist_no,\n")
					.append("	file_name,\n")
					.append("	file_path,\n")
					.append("	file_rev_no\n")
					.append("FROM\n")
					.append("	haccp_edu A \n")
					.append("	LEFT JOIN tbm_users C					\n")
					.append("		ON A.person_write_id = C.user_id		\n")
					.append("		AND  A.edu_date BETWEEN CAST(C.start_date AS DATE) AND CAST(C.duration_date AS DATE) \n")
					.append("	LEFT JOIN tbm_users C2											\n")
					.append("		ON A.person_check_id = C2.user_id							\n")
					.append("		AND  A.edu_date BETWEEN CAST(C2.start_date AS DATE) AND CAST(C2.duration_date AS DATE) \n")
					.append("	LEFT JOIN tbm_users C3											\n")
					.append("		ON A.person_approve_id = C3.user_id							\n")
					.append("		AND  A.edu_date BETWEEN CAST(C3.start_date AS DATE) AND CAST(C3.duration_date AS DATE) \n")
					.append("WHERE A.edu_date = '"+jArray.get("edu_date")+"' \n")
					.append("  AND A.seq_no = "+jArray.get("seq_no")+"   \n")
					.toString();

			String ActionCommand = ioParam.getActionCommand();
			if(ActionCommand.startsWith("doQueryTableFieldName")) {
				resultString = super.excuteQueryStringTableFieldName(con, sql.toString());
			} else {
				resultString = super.excuteQueryString(con, sql.toString());
			}
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M838S080300E144()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M838S080300E144()","==== finally ===="+ e.getMessage());
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
    				.append("UPDATE haccp_edu												\n")
    				.append("SET															\n")
    				.append("	person_approve_id = '" + jObj.get("userId") + "'			\n")
    				.append("WHERE edu_date = '"+ jObj.get("checklistDate") + "'			\n")
    				.append("  AND checklist_id = '"+ jObj.get("checklistId") + "'			\n")
    				.append("  AND checklist_rev_no = '"+ jObj.get("checklistRevNo") + "'	\n")
    				.append("  AND seq_no = '"+ jObj.get("seq_no") + "'						\n")
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
			LoggingWriter.setLogError("M838S080300E502()","==== SQL ERROR ===="+ e.getMessage());
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
	public int E522(InoutParameter ioParam){ 
		
		resultInt = EventDefine.E_DOEXCUTE_INIT;

		try {
			con = JDBCConnectionPool.getConnection();
			con.setAutoCommit(false);
			
			JSONObject jObj = new JSONObject();
    		jObj = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
    		
    		String sql = new StringBuilder()
    				.append("UPDATE haccp_edu												\n")
    				.append("SET															\n")
    				.append("	person_check_id = '" + jObj.get("userId") + "'				\n")
    				.append("WHERE edu_date = '"+ jObj.get("checklistDate") + "'			\n")
    				.append("  AND checklist_id = '"+ jObj.get("checklistId") + "'			\n")
    				.append("  AND checklist_rev_no = '"+ jObj.get("checklistRevNo") + "'	\n")
    				.append("  AND seq_no = '"+ jObj.get("seq_no") + "'						\n")
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
			LoggingWriter.setLogError("M838S080300E522()","==== SQL ERROR ===="+ e.getMessage());
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