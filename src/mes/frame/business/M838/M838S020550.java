package mes.frame.business.M838;
/*BOM코드*/
import java.lang.reflect.Method;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.util.ArrayList;
import java.util.Vector;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;

import mes.frame.common.ApprovalActionNo;
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
public  class M838S020550 extends SqlAdapter{
	Connection con = null;
	PreparedStatement pstmt = null;
	String resultString = "";
	int resultInt = -1;
	StringBuffer sql = new StringBuffer();
	
	String[][] v_paramArray = new String[0][0]; 
	Class[] optClass = null;
	Object[] optObj = null;
	Object obj = null;
	
	public M838S020550(){
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
			
			Method method = M838S020550.class.getMethod(event,optClass);
			LoggingWriter.setLogDebug(M838S020550.class.getName(),"==== " + event + " EventMethod Create Success ====");

			obj = method.invoke(M838S020550.class.newInstance(),optObj);
			doExcute_result = CommonFunction.getInt(obj.toString());
			
	    } catch (Exception ex) {
	    	doExcute_result = EventDefine.E_DOEXCUTE_INIT;
			ioParam.setMessage(MessageDefine.M_NO_EVENTID);
			LoggingWriter.setLogError(M838S020550.class.getName(),"==== EventID Not define : EVENT ID [ " + ioParam.getEventID() + "]");
	    } finally {
	    	obj = null;
			optClass = null;
			optObj = null;
	    }
	    long endTime = System.currentTimeMillis();
		long runningTime = endTime - startTime;
		LoggingWriter.setLogAll(M838S020550.class.getName(),"==== Query [수행시간  : " + runningTime + " ms]");
		
		return doExcute_result;
	}
	
	// S838S020550.jsp
	// 점검표 등록
	public int E101(InoutParameter ioParam){ 
		resultInt = EventDefine.E_DOEXCUTE_INIT;

		try {
			con = JDBCConnectionPool.getConnection();
			con.setAutoCommit(false);
			
    		JSONObject jObj = new JSONObject();
    		jObj = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
    		
    		String checklist_id = jObj.get("checklist_id").toString();
    		String check_date = jObj.get("check_date").toString();
    		
			String sql = new StringBuilder()
					.append("INSERT INTO\n")
					.append("	haccp_illuminance (\n")
					.append("		check_date,\n")
					.append("		checklist_id,\n")
					.append("		checklist_rev_no,\n")
					.append("		person_write_id\n")
					.append("	)\n")
					.append("VALUES\n")
					.append("	(\n")
					.append("		'"+check_date+"',\n")
					.append("		'"+checklist_id+"',\n")
    				.append("    	(SELECT MAX(checklist_rev_no)				 \n")
    				.append("    	FROM checklist								 \n")
    				.append("    	WHERE checklist_id = '"+checklist_id+"'),	 \n")
					.append("		'"+jObj.get("person_write_id").toString()+"'\n")
					.append("	)\n")
					.toString();

			resultInt = super.excuteUpdate(con, sql.toString());
	    	if(resultInt < 0){  //
				ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
				con.rollback();
				return EventDefine.E_DOEXCUTE_ERROR;
			}
			
    		JSONArray form = new JSONArray();
			form = (JSONArray) jObj.get("form");
			
			System.out.println(form);
			// type_id, type_rev_no, place_id, result, judge : 5
			
			ArrayList<String> valuearr = new ArrayList<String>();
			
			for(int i=1; i<=form.size(); i++) {
				
				JSONObject result = (JSONObject) form.get(i-1);
				
				String value = result.get("value").toString();
				valuearr.add(value);
				
				if(i%5 == 0) {
					
					sql = new StringBuilder()
							.append("INSERT INTO\n")
							.append("	haccp_illuminance_result (\n")
							.append("		check_date,\n")
							.append("		type_id,\n")
							.append("		type_rev_no,\n")
							.append("		place_id,\n")
							.append("		result,\n")
							.append("		judge\n")
							.append("	)\n")
							.append("VALUES\n")
							.append("	(\n")
							.append("		'"+check_date+"',\n")
    						.append("		'"+valuearr.get(0)+"',\n")
    						.append("		'"+valuearr.get(1)+"',\n")
    						.append("		'"+valuearr.get(2)+"',\n")
    						.append("		'"+valuearr.get(3)+"',\n")
    						.append("		'"+valuearr.get(4)+"'\n")
							.append("	)	\n")
							.toString();

		    	   resultInt = super.excuteUpdate(con, sql); 
					  
				   if(resultInt < 0) {
					   ioParam.setMessage(MessageDefine.M_INSERT_FAILED); 
					   con.rollback(); return
					   EventDefine.E_DOEXCUTE_ERROR;
				   }
				   
   					valuearr = new ArrayList<String>();

				}
				
			}	
			con.commit();
		} catch(Exception e) {
			e.getStackTrace();
			LoggingWriter.setLogError("M838S020550E101()","==== SQL ERROR ===="+ e.getMessage());
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
	
	// 점검표 수정
	public int E102(InoutParameter ioParam){ 
		resultInt = EventDefine.E_DOEXCUTE_INIT;

		try {
			con = JDBCConnectionPool.getConnection();
			con.setAutoCommit(false);
			
    		JSONObject jObj = new JSONObject();
    		jObj = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
    		
    		String checklist_id = jObj.get("checklist_id").toString();
    		String check_date = jObj.get("check_date").toString();
    		String checklist_rev_no = jObj.get("checklist_rev_no").toString();
    		    		
    		String sql = new StringBuilder()
    				.append("UPDATE																\n")
    				.append("	haccp_illuminance												\n")
    				.append("SET																\n")
    				.append("	person_check_id = '',	\n")
    				.append("	person_approve_id = ''	\n")
    				.append("WHERE																\n")
    				.append("	check_date = '"+check_date+"'									\n")
    				.append("	AND checklist_id = '"+checklist_id+"'							\n")
    				.append("	AND checklist_rev_no = '"+checklist_rev_no+"'					\n")
    				.toString();
    		
    		resultInt = super.excuteUpdate(con, sql);
	    	if(resultInt < 0) {
				ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
				con.rollback();
				return EventDefine.E_DOEXCUTE_ERROR ;
			}
	    	
	    	sql = new StringBuilder()
    				.append("DELETE FROM														\n")
    				.append("	haccp_illuminance_result										\n")
    				.append("WHERE																\n")
    				.append("	check_date = '"+check_date+"'									\n")
    				.toString();
    		
    		resultInt = super.excuteUpdate(con, sql);
	    	if(resultInt < 0) {
				ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
				con.rollback();
				return EventDefine.E_DOEXCUTE_ERROR ;
			}
		
	    	JSONArray form = new JSONArray();
			form = (JSONArray) jObj.get("form");
			
			System.out.println(form);
			// type_id, type_rev_no, place_id, result, judge : 5
			
			ArrayList<String> valuearr = new ArrayList<String>();
			
			for(int i=1; i<=form.size(); i++) {
				
				JSONObject result = (JSONObject) form.get(i-1);
				
				String value = result.get("value").toString();
				valuearr.add(value);
				
				if(i%5 == 0) {
					
					sql = new StringBuilder()
							.append("INSERT INTO\n")
							.append("	haccp_illuminance_result (\n")
							.append("		check_date,\n")
							.append("		type_id,\n")
							.append("		type_rev_no,\n")
							.append("		place_id,\n")
							.append("		result,\n")
							.append("		judge\n")
							.append("	)\n")
							.append("VALUES\n")
							.append("	(\n")
							.append("		'"+check_date+"',\n")
    						.append("		'"+valuearr.get(0)+"',\n")
    						.append("		'"+valuearr.get(1)+"',\n")
    						.append("		'"+valuearr.get(2)+"',\n")
    						.append("		'"+valuearr.get(3)+"',\n")
    						.append("		'"+valuearr.get(4)+"'\n")
							.append("	)	\n")
							.toString();

		    	   resultInt = super.excuteUpdate(con, sql); 
					  
				   if(resultInt < 0) {
					   ioParam.setMessage(MessageDefine.M_INSERT_FAILED); 
					   con.rollback(); return
					   EventDefine.E_DOEXCUTE_ERROR;
				   }
				   
   					valuearr = new ArrayList<String>();

				}
				
			}	
			
			con.commit();
		} catch(Exception e) {
			e.getStackTrace();
			LoggingWriter.setLogError("M838S020550E102()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR;
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
	
	// 점검표 삭제
	public int E103(InoutParameter ioParam){ 
		resultInt = EventDefine.E_DOEXCUTE_INIT;

		try {
			con = JDBCConnectionPool.getConnection();
			con.setAutoCommit(false);
			
    		JSONObject jObj = new JSONObject();
    		jObj = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
    		
    		String checklist_id = jObj.get("checklist_id").toString();
    		int checklist_rev_no = Integer.parseInt(jObj.get("checklist_rev_no").toString());
    		String check_date = jObj.get("check_date").toString();
    		
    		String sql = new StringBuilder()
    				.append("DELETE FROM									\n")
    				.append("	haccp_illuminance_result					\n")
    				.append("WHERE											\n")
    				.append("		 check_date = '"+check_date+"'			\n")
    				.toString();
    		
    		resultInt = super.excuteUpdate(con, sql);
	    	if(resultInt < 0) {
				ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
				con.rollback();
				return EventDefine.E_DOEXCUTE_ERROR ;
			}
    		
    		sql = new StringBuilder()
    				.append("DELETE FROM\n")
    				.append("	haccp_illuminance \n")
    				.append("WHERE\n")
    				.append("	checklist_id = '"+checklist_id+"'\n")
    				.append("	AND checklist_rev_no = "+checklist_rev_no+"\n")
    				.append("	AND check_date = '"+check_date+"'\n")
    				.toString();
    		
    		resultInt = super.excuteUpdate(con, sql);
	    	if(resultInt < 0) {
				ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
				con.rollback();
				return EventDefine.E_DOEXCUTE_ERROR ;
			}
	    	
			con.commit();
		} catch(Exception e) {
			e.getStackTrace();
			LoggingWriter.setLogError("M838S020550E103()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR;
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
	
	// 점검표 메인 조회
	public int E104(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			System.out.println("JSONObject jArray rcvData="+ jArray.toString());

			String sql = new StringBuilder()
					.append("SELECT\n")
					.append("	checklist_id,\n")
					.append("	checklist_rev_no,\n")
					.append("	check_date,\n")
					.append("	C.user_nm AS person_write_id,\n")
					.append("	D.user_nm AS person_check_id,\n")
					.append("	E.user_nm AS person_approve_id\n")
					.append("FROM\n")
					.append("	haccp_illuminance A \n")
					.append("	LEFT JOIN tbm_users C\n")
					.append("	ON A.person_write_id = C.user_id\n")
					.append("	AND A.check_date BETWEEN C.start_date AND C.duration_date\n")
					.append("	LEFT JOIN tbm_users D\n")
					.append("	ON A.person_check_id = D.user_id\n")
					.append("	AND A.check_date BETWEEN D.start_date AND D.duration_date\n")
					.append("	LEFT JOIN tbm_users E\n")
					.append("	ON A.person_approve_id = E.user_id\n")
					.append("	AND A.check_date BETWEEN E.start_date AND E.duration_date\n")
					.append("WHERE A.check_date BETWEEN '"+ jArray.get("fromdate") + "' \n")  
					.append("                     AND '"+ jArray.get("todate") + "' 	\n")
					.append("ORDER BY A.check_date DESC \n")  
					.toString();

			String ActionCommand = ioParam.getActionCommand();
			if(ActionCommand.startsWith("doQueryTableFieldName")) {
				resultString = super.excuteQueryStringTableFieldName(con, sql.toString());
			}
			else {
				resultString = super.excuteQueryString(con, sql.toString());
			}
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M838S020550E104()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M838S020550E104()","==== finally ===="+ e.getMessage());
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

	// checklist 항목 select
	public int E114(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));

			String sql = new StringBuilder()
					.append("SELECT\n")
					.append("	A.type_id,\n")
					.append("	A.type_rev_no,\n")
					.append("	A.type_nm,\n")
					.append("	B.place_id,\n")
					.append("	B.place_detail\n")
					.append("FROM\n")
					.append("	haccp_illuminance_type A JOIN haccp_illuminance_place B\n")
					.append("	ON A.type_id = B.type_id\n")
					.append("ORDER BY B.place_id ASC \n")
					.toString();

			resultString = super.excuteQueryString(con, sql);
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M838S020550E114()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) {
						con.close();
					}
				} catch (Exception e) {
					LoggingWriter.setLogError("M838S020550E114()","==== finally ===="+ e.getMessage());
				}
	    	}
	    }

		ioParam.setResultString(resultString);
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
    	ioParam.setMessage(MessageDefine.M_QUERY_OK);

    	return EventDefine.E_QUERY_RESULT;
	}
	
	// 점검표 조회
	public int E144(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			System.out.println("JSONObject jArray rcvData="+ jArray.toString());
    		
			String sql = new StringBuilder()
					.append("SELECT\n")
					.append("	A.check_date,\n")
					.append("	TO_CHAR(A.check_date, 'YY') AS YY,\n")
					.append("	TO_CHAR(A.check_date, 'MM') AS MM,\n")
					.append("	TO_CHAR(A.check_date, 'DD') AS DD,\n")
					.append("	type_id,\n")
					.append("	type_rev_no,\n")
					.append("	place_id,\n")
					.append("	result,\n")
					.append("	judge,\n")
					.append("	C.user_nm AS person_write_id,\n")
					.append("	D.user_nm AS person_check_id,\n")
					.append("	E.user_nm AS person_approve_id\n")
					.append("FROM\n")
					.append("	haccp_illuminance_result A JOIN haccp_illuminance B\n")
					.append("	ON A.check_date = B.check_date\n")
					.append("	LEFT JOIN tbm_users C\n")
					.append("	ON B.person_write_id = C.user_id\n")
					.append("	AND A.check_date BETWEEN C.start_date AND C.duration_date\n")
					.append("	LEFT JOIN tbm_users D\n")
					.append("	ON B.person_check_id = D.user_id\n")
					.append("	AND A.check_date BETWEEN D.start_date AND D.duration_date\n")
					.append("	LEFT JOIN tbm_users E\n")
					.append("	ON B.person_approve_id = E.user_id\n")
					.append("	AND A.check_date BETWEEN E.start_date AND E.duration_date\n")
					.append("WHERE A.check_date = '"+jArray.get("check_date").toString()+"'	\n")
					.append("ORDER BY place_id ASC\n")
					.toString();

			String ActionCommand = ioParam.getActionCommand();
			if(ActionCommand.startsWith("doQueryTableFieldName")) {
				resultString = super.excuteQueryStringTableFieldName(con, sql.toString());
			}
			else {
				resultString = super.excuteQueryString(con, sql.toString());
			}
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M838S020550E144()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M838S020550E144()","==== finally ===="+ e.getMessage());
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
	
	// 수정하기전 가져오는 데이터
	public int E154(InoutParameter ioParam){
		
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));

			String sql = new StringBuilder()
					.append("SELECT\n")
					.append("	check_date,\n")
					.append("	result,\n")
					.append("	judge\n")
					.append("FROM\n")
					.append("	haccp_illuminance_result\n")
					.append("WHERE\n")
					.append("	check_date = '"+jArray.get("check_date")+"'\n")
					.append("ORDER BY place_id ASC \n")
					.toString();

			resultString = super.excuteQueryString(con, sql);
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M838S020550E154()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) {
						con.close();
					}
				} catch (Exception e) {
					LoggingWriter.setLogError("M838S020550E154()","==== finally ===="+ e.getMessage());
				}
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
    				.append("UPDATE haccp_illuminance										\n")
    				.append("SET															\n")
    				.append("	person_approve_id = '" + jObj.get("userId") + "'			\n")
    				.append("WHERE check_date = '"+ jObj.get("checklistDate") + "'			\n")
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
			LoggingWriter.setLogError("M838S020550E502()","==== SQL ERROR ===="+ e.getMessage());
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
    				.append("UPDATE haccp_illuminance										\n")
    				.append("SET															\n")
    				.append("	person_check_id = '" + jObj.get("userId") + "'				\n")
    				.append("WHERE check_date = '"+ jObj.get("checklistDate") + "'			\n")
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
			LoggingWriter.setLogError("M838S020550E522()","==== SQL ERROR ===="+ e.getMessage());
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