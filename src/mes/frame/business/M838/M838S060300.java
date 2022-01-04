package mes.frame.business.M838;
/*BOM코드*/
import java.lang.reflect.Method;
import java.sql.Connection;
import java.sql.PreparedStatement;
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
public  class M838S060300 extends SqlAdapter{
	Connection con = null;
	PreparedStatement pstmt = null;
	String resultString = "";
	int resultInt = -1;
	StringBuffer sql = new StringBuffer();
	
	String[][] v_paramArray = new String[0][0]; 
	Class[] optClass = null;
	Object[] optObj = null;
	Object obj = null;
	
	public M838S060300(){
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
			
			Method method = M838S060300.class.getMethod(event,optClass);
			LoggingWriter.setLogDebug(M838S060300.class.getName(),"==== " + event + " EventMethod Create Success ====");

			obj = method.invoke(M838S060300.class.newInstance(),optObj);
			doExcute_result = CommonFunction.getInt(obj.toString());
			
	    } catch (Exception ex) {
	    	doExcute_result = EventDefine.E_DOEXCUTE_INIT;
			ioParam.setMessage(MessageDefine.M_NO_EVENTID);
			LoggingWriter.setLogError(M838S060300.class.getName(),"==== EventID Not define : EVENT ID [ " + ioParam.getEventID() + "]");
	    } finally {
	    	obj = null;
			optClass = null;
			optObj = null;
	    }
	    long endTime = System.currentTimeMillis();
		long runningTime = endTime - startTime;
		LoggingWriter.setLogAll(M838S060300.class.getName(),"==== Query [수행시간  : " + runningTime + " ms]");
		
		return doExcute_result;
	}
	
	// 838S060300.jsp 등록화면
	public int E101(InoutParameter ioParam){ 
		resultInt = EventDefine.E_DOEXCUTE_INIT;

		try {
			con = JDBCConnectionPool.getConnection();
			con.setAutoCommit(false);
			
			// insert_update_delete_json.jsp에서 받아온 JSON데이터 처리
    		JSONObject jArray = new JSONObject();
    		jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
    		System.out.println("JSONObject jArray rcvData="+ jArray.toString());
    		// Object데이터에서 키값(param)으로 JSONArray데이터를 꺼낸다. (데이터묶음 하나일땐 생략)
    		JSONArray jjArray = (JSONArray) jArray.get("assessment");
						
			for(int i=0; i<jjArray.size(); i++) {
				JSONObject jjjArray = (JSONObject)jjArray.get(i); // i번째 데이터묶음
				StringBuffer sql = new StringBuffer();
					sql.append("INSERT INTO\n");
					sql.append("	haccp_subcontractor_assessment (\n");
					sql.append("		subcontractor_no,\n");
					sql.append("		subcontractor_rev,\n");
					sql.append("		subcontractor_seq,\n");
					sql.append("		subcontractor_name,\n");
					sql.append("		inspector,\n");
					sql.append("		inspector_rev,\n");
					sql.append("		uptae,\n");
					sql.append("		assessment_no,\n");
					sql.append("		assessment_rev,\n");
					sql.append("		assessment_date,\n");
					sql.append("		assessment_division,\n");
					sql.append("		assessment_article,\n");
					sql.append("		assessment_standard,\n");
					sql.append("		assessment_result,\n");
					sql.append("		assessment_bigo,\n");
					sql.append("		writor,\n");
					sql.append("		writor_rev,\n");
					sql.append("		write_date,\n");
					sql.append("		checker,\n");
					sql.append("		checker_rev,\n");
					sql.append("		check_date,\n");
					sql.append("		approval,\n");
					sql.append("		approval_rev,\n");
					sql.append("		approve_date,\n");
					sql.append("		member_key\n");
					sql.append("	)\n");
					sql.append("VALUES\n");
					sql.append("	(\n");
					sql.append("		'" + jArray.get("subcontractor_no") 	 + "', \n");
					sql.append("		'" + jArray.get("subcontractor_rev") 	 + "', \n");
					if(i == 0) {
						sql.append("		NVL((SELECT MAX(subcontractor_seq)+1 \n");			
						sql.append("		 FROM haccp_subcontractor_assessment B \n");
						sql.append("		 WHERE B.subcontractor_no 	= '" + jArray.get("subcontractor_no") + "' \n");
						sql.append("		 AND B.subcontractor_rev 	= '" + jArray.get("subcontractor_rev") + "' \n");
						sql.append("		 AND B.member_key 		 	= '" + jArray.get("member_key") + "'), 0), \n");	
					} else {
						sql.append("		NVL((SELECT MAX(subcontractor_seq) \n");			
						sql.append("		 FROM haccp_subcontractor_assessment B \n");
						sql.append("		 WHERE B.subcontractor_no 	= '" + jArray.get("subcontractor_no") + "' \n");
						sql.append("		 AND B.subcontractor_rev 	= '" + jArray.get("subcontractor_rev") + "' \n");
						sql.append("		 AND B.member_key 		 	= '" + jArray.get("member_key") + "'), 0), \n");
					}
					sql.append("		'" + jArray.get("subcontractor_name") 	 + "', \n");
					sql.append("		'" + jArray.get("inspector") 			 + "', \n");
					sql.append("		'" + jArray.get("inspector_rev") 		 + "', \n");
					sql.append("		'" + jArray.get("uptae") 				 + "', \n");
					sql.append("		'" + jjjArray.get("assessment_no") 		 + "', \n");
					sql.append("		'" + jjjArray.get("assessment_rev") 	 + "', \n");
					sql.append("		'" + jArray.get("assessment_date") 		 + "', \n");
					sql.append("		'" + jjjArray.get("assessment_division") + "', \n");
					sql.append("		'" + jjjArray.get("assessment_article")  + "', \n");
					sql.append("		'" + jjjArray.get("assessment_standard") + "', \n");
					sql.append("		'" + jjjArray.get("assessment_result") 	 + "', \n");
					sql.append("		'" + jjjArray.get("assessment_bigo") 	 + "', \n");
					sql.append("		'" + jArray.get("writor") 				 + "', \n");
					sql.append("		'" + jArray.get("writor_rev") 			 + "', \n");
					sql.append("		'" + jArray.get("write_date") 			 + "', \n");
					sql.append("		'" + jArray.get("checker") 				 + "', \n");
					sql.append("		'" + jArray.get("checker_rev") 			 + "', \n");
					sql.append("		'" + jArray.get("check_date") 			 + "', \n");
					sql.append("		'" + jArray.get("approval") 			 + "', \n");
					sql.append("		'" + jArray.get("approval_rev") 		 + "', \n");
					sql.append("		'" + jArray.get("approve_date") 		 + "', \n");
					sql.append("		'" + jArray.get("member_key") 			 + "'  \n");
					sql.append("	);\n");                                                 
					sql.toString();			                                             
				resultInt = super.excuteUpdate(con, sql.toString());
		    	if(resultInt < 0){  //
					ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
					con.rollback();
					return EventDefine.E_DOEXCUTE_ERROR ;
				}
			}
			con.commit();
		} catch(Exception e) {
			e.getStackTrace();
			LoggingWriter.setLogError("M838S060300E101()","==== SQL ERROR ===="+ e.getMessage());
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
	
	// S838S060302.jsp
	public int E102(InoutParameter ioParam){ 
		resultInt = EventDefine.E_DOEXCUTE_INIT;

		try {
			con = JDBCConnectionPool.getConnection();
			con.setAutoCommit(false);
			
			// insert_update_delete_json.jsp에서 받아온 JSON데이터 처리
    		JSONObject jArray = new JSONObject();
    		jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
    		System.out.println("JSONObject jArray rcvData="+ jArray.toString());
    		// Object데이터에서 키값(param)으로 JSONArray데이터를 꺼낸다. (데이터묶음 하나일땐 생략)
    		JSONArray jjArray = (JSONArray) jArray.get("assessment");
			
    		for(int i=0; i<jjArray.size(); i++) {
				JSONObject jjjArray = (JSONObject)jjArray.get(i); // i번째 데이터묶음
				String sql = new StringBuilder()
					.append("UPDATE\n")
					.append("	haccp_subcontractor_assessment A \n")
					.append("SET\n")
					.append("		subcontractor_no 	= '" + jArray.get("subcontractor_no") 	 + "', \n")
					.append("		subcontractor_rev 	= '" + jArray.get("subcontractor_rev") 	 + "', \n")
					.append("		subcontractor_seq 	= '" + jArray.get("subcontractor_seq") 	 + "', \n")
					.append("		subcontractor_name 	= '" + jArray.get("subcontractor_name") 	 + "', \n")
					.append("		inspector 			= '" + jArray.get("inspector") 			 + "', \n")
					.append("		inspector_rev 		= '" + jArray.get("inspector_rev") 		 + "', \n")
					.append("		uptae 				= '" + jArray.get("uptae") 				 + "', \n")
					.append("		assessment_no 		= '" + jjjArray.get("assessment_no") 		 + "', \n")
					.append("		assessment_rev 		= '" + jjjArray.get("assessment_rev") 	 + "', \n")
					.append("		assessment_date 	= '" + jArray.get("assessment_date") 		 + "', \n")
					.append("		assessment_division = '" + jjjArray.get("assessment_division") + "', \n")
					.append("		assessment_article 	= '" + jjjArray.get("assessment_article")  + "', \n")
					.append("		assessment_standard = '" + jjjArray.get("assessment_standard") + "', \n")
					.append("		assessment_result 	= '" + jjjArray.get("assessment_result") 	 + "', \n")
					.append("		assessment_bigo 	= '" + jjjArray.get("assessment_bigo") 	 + "', \n")
					.append("		writor 				= '" + jArray.get("writor") 				 + "', \n")
					.append("		writor_rev 			= '" + jArray.get("writor_rev") 			 + "', \n")
					.append("		write_date 			= '" + jArray.get("write_date") 			 + "', \n")
					.append("		checker 			= '" + jArray.get("checker") 				 + "', \n")
					.append("		checker_rev 		= '" + jArray.get("checker_rev") 			 + "', \n")
					.append("		check_date 			= '" + jArray.get("check_date") 			 + "', \n")
					.append("		approval 			= '" + jArray.get("approval") 			 + "', \n")
					.append("		approval_rev 		= '" + jArray.get("approval_rev") 		 + "', \n")
					.append("		approve_date 		= '" + jArray.get("approve_date") 		 + "', \n")
					.append("		member_key 			= '" + jArray.get("member_key") 			 + "'  \n")
					.append("WHERE A.subcontractor_no 	= '" + jArray.get("subcontractor_no") 	+ "' \n")
					.append("AND A.subcontractor_rev 	= '" + jArray.get("subcontractor_rev") 	+ "' \n")
					.append("AND A.subcontractor_seq 	= '" + jArray.get("subcontractor_seq") 	+ "' \n")
					.append("AND A.assessment_no 		= '" + jjjArray.get("assessment_no") 	+ "' \n")
					.append("AND A.assessment_rev 		= '" + jjjArray.get("exist_rev") 	+ "' \n")
					.append("AND A.member_key 		 	= '" + jArray.get("member_key") 		+ "' \n")
					.toString();
				resultInt = super.excuteUpdate(con, sql.toString());
		    	if(resultInt < 0){  //
					ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
					con.rollback();
					return EventDefine.E_DOEXCUTE_ERROR ;
				}
			}
			con.commit();
		} catch(Exception e) {
			e.getStackTrace();
			LoggingWriter.setLogError("M838S060300E102()","==== SQL ERROR ===="+ e.getMessage());
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

	// S838S060303.jsp
	public int E103(InoutParameter ioParam){ 
		resultInt = EventDefine.E_DOEXCUTE_INIT;

		try {
			con = JDBCConnectionPool.getConnection();
			con.setAutoCommit(false);
			
			// insert_update_delete_json.jsp에서 받아온 JSON데이터 처리
    		JSONObject jArray = new JSONObject();
    		jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
    		System.out.println("JSONObject jArray rcvData="+ jArray.toString());
    		// Object데이터에서 키값(param)으로 JSONArray데이터를 꺼낸다. (데이터묶음 하나일땐 생략)
    		JSONArray jjArray = (JSONArray) jArray.get("assessment");
			
    		for(int i=0; i<jjArray.size(); i++) {
				JSONObject jjjArray = (JSONObject)jjArray.get(i); // i번째 데이터묶음
				String sql = new StringBuilder()
					.append("DELETE FROM \n")
					.append("	haccp_subcontractor_assessment A \n")
					.append("WHERE A.subcontractor_no 	= '" + jArray.get("subcontractor_no") 	+ "' \n")
					.append("AND A.subcontractor_rev 	= '" + jArray.get("subcontractor_rev") 	+ "' \n")
					.append("AND A.subcontractor_seq 	= '" + jArray.get("subcontractor_seq") 	+ "' \n")
					.append("AND A.assessment_no 		= '" + jjjArray.get("assessment_no") 	+ "' \n")
					.append("AND A.member_key 		 	= '" + jArray.get("member_key") 		+ "' \n")
					.toString();
				resultInt = super.excuteUpdate(con, sql.toString());
		    	if(resultInt < 0){  //
					ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
					con.rollback();
					return EventDefine.E_DOEXCUTE_ERROR ;
				}
			}
			con.commit();
		} catch(Exception e) {
			e.getStackTrace();
			LoggingWriter.setLogError("M838S060300E103()","==== SQL ERROR ===="+ e.getMessage());
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
	
	// S838S060300.jsp
	public int E104(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			System.out.println("JSONObject jArray rcvData="+ jArray.toString());
    		
				String sql = new StringBuilder()
					.append("SELECT\n")
					.append("	subcontractor_no,\n")
					.append("	subcontractor_rev,\n")
					.append("	subcontractor_seq,\n")
					.append("	subcontractor_name,\n")
					.append("	inspector,\n")
					.append("	inspector_rev,\n")					
					.append("	A.uptae,\n")
					.append("	assessment_date,\n")
					.append("	writor,\n")
					.append("	writor_rev,\n")
					.append("	write_date,\n")
					.append("	company_type_b\n")
					.append("FROM haccp_subcontractor_assessment A \n")
					.append("JOIN tbm_customer B ON (A.subcontractor_no = B.cust_cd) \n")
					.append("WHERE A.check_date \n")
					.append("BETWEEN '" + jArray.get("fromdate") + "' 	\n")
					.append("AND '" + jArray.get("todate") + "'	\n")
					.append("AND A.member_key = '" + jArray.get("member_key") + "' \n") //member_key_select, update, delete
					.append("GROUP BY A.subcontractor_no, A.subcontractor_rev, A.subcontractor_seq ;\n")					
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
			LoggingWriter.setLogError("M838S060300E104()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M838S060300E104()","==== finally ===="+ e.getMessage());
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
	
	// S838S060310.jsp
	public int E114(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			System.out.println("JSONObject jArray rcvData="+ jArray.toString());
    		
			String sql = new StringBuilder()
				.append("SELECT\n")
				.append("	subcontractor_no,\n")
				.append("	subcontractor_rev,\n")
				.append("	subcontractor_seq,\n")
				.append("	assessment_no,\n")
				.append("	assessment_division,\n")
				.append("	assessment_article,\n")
				.append("	assessment_standard,\n")
				.append("	assessment_result,\n")
				.append("	assessment_bigo\n")
				.append("FROM\n")
				.append("	haccp_subcontractor_assessment A \n")
				.append("WHERE A.subcontractor_no 	= '" + jArray.get("subcontractor_no") + "' \n")
				.append("AND A.subcontractor_rev 	= '" + jArray.get("subcontractor_rev") + "' \n")
				.append("AND A.subcontractor_seq 	= '" + jArray.get("subcontractor_seq") + "' \n")
				.append("AND A.member_key 		 	= '" + jArray.get("member_key") + "' \n")
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
			LoggingWriter.setLogError("M838S060300E114()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M838S060300E114()","==== finally ===="+ e.getMessage());
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
	// 수정, 삭제시 조회용
	public int E124(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			System.out.println("JSONObject jArray rcvData="+ jArray.toString());
    		
			String sql = new StringBuilder()
				.append("SELECT\n")
				.append("	subcontractor_no,\n")    //0
				.append("	subcontractor_rev,\n")   //1
				.append("	subcontractor_seq,\n")   //2
				.append("	subcontractor_name,\n")  //3
				.append("	inspector,\n")           //4
				.append("	inspector_rev,\n")       //5
				.append("	uptae,\n")               //6
				.append("	assessment_no,\n")       //7
				.append("	assessment_rev,\n")      //8
				.append("	assessment_date,\n")     //9
				.append("	assessment_division,\n") //10
				.append("	assessment_article,\n")  //11
				.append("	assessment_standard,\n") //12
				.append("	assessment_result,\n")   //13
				.append("	assessment_bigo,\n")     //14
				.append("	writor,\n")              //15
				.append("	writor_rev,\n")          //16
				.append("	write_date,\n")          //17
				.append("	checker,\n")             //18
				.append("	checker_rev,\n")         //19
				.append("	check_date,\n")          //20
				.append("	approval,\n")            //21
				.append("	approval_rev,\n")        //22
				.append("	approve_date,\n")        //23
				.append("	member_key\n")           //24
				.append("FROM\n")
				.append("	haccp_subcontractor_assessment A \n")
				.append("WHERE A.subcontractor_no 	= '" + jArray.get("subcontractor_no") + "' \n")
				.append("AND A.subcontractor_rev 	= '" + jArray.get("subcontractor_rev") + "' \n")
				.append("AND A.subcontractor_seq 	= '" + jArray.get("subcontractor_seq") + "' \n")
				.append("AND A.member_key 		 	= '" + jArray.get("member_key") + "' \n")
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
			LoggingWriter.setLogError("M838S060300E124()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M838S060300E124()","==== finally ===="+ e.getMessage());
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

	
	// 태양 캔버스 조회용
	public int E134(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			System.out.println("JSONObject jArray rcvData="+ jArray.toString());
    		
			String sql = new StringBuilder()
				.append("SELECT DISTINCT\n")
				.append("	A.subcontractor_no,\n")
				.append("	A.subcontractor_rev,\n")
				.append("	A.subcontractor_seq,\n")
				.append("	B.boss_name,	-- 대표자\n")
				.append("	B.address,		-- 사업장소재지\n")
				.append("	B.jongmok, -- 종목\n")
				.append("	B.refno, 		-- 사업장등록번호\n")
				.append("	B.company_type_b,		-- 입출고구분\n")
				.append("	D.code_name,	-- 작성부서\n")
				.append("	A.writor,\n")
				.append("	A.write_date,\n")
				.append("	A.checker,\n")
				.append("	A.check_date,\n")
				.append("	A.approval,\n")
				.append("	A.approve_date,	\n")
				.append("	A.subcontractor_name,\n")
				.append("	A.inspector, -- 점검자\n")
				.append("	A.uptae,\n")
				.append("	A.assessment_date,	\n")
				.append("	A.assessment_no,\n")
				.append("	A.assessment_rev,\n")
				.append("	A.assessment_division,\n")
				.append("	A.assessment_article,\n")
				.append("	A.assessment_standard,\n")
				.append("	A.assessment_result,\n")
				.append("	A.assessment_bigo\n")
				.append("FROM\n")
				.append("        haccp_subcontractor_assessment A\n")
				.append("JOIN tbm_customer B \n")
				.append("	ON (B.cust_cd = A.subcontractor_no) \n")
				.append("	AND (B.revision_no = A.subcontractor_rev)\n")
				.append("JOIN tbm_users C ON (A.writor = C.user_nm)\n")
				.append("JOIN v_dept_code D ON (C.dept_cd = D.code_value)\n")
				.append("WHERE A.subcontractor_no 	= '" + jArray.get("subcontractor_no") + "' \n")
				.append("AND A.subcontractor_rev 	= '" + jArray.get("subcontractor_rev") + "' \n")
				.append("AND A.subcontractor_seq 	= '" + jArray.get("subcontractor_seq") + "' \n")
				.append("AND B.company_type_b 	= '" + jArray.get("io_gb") + "' \n")
				.append("AND B.duration_date = '9999-12-31'\n")
				.append("AND A.member_key 		 	= '" + jArray.get("member_key") + "' \n")
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
			LoggingWriter.setLogError("M838S060300E134()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M838S060300E134()","==== finally ===="+ e.getMessage());
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

	
	// 중복컬럼명 조회용 쿼리
	public int E135(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			System.out.println("JSONObject jArray rcvData="+ jArray.toString());
    		
			String sql = new StringBuilder()
				.append("SELECT \n")
				.append("	COUNT(A.assessment_division),\n")
				.append("	A.assessment_division\n")
				.append("FROM\n")
				.append("        haccp_subcontractor_assessment A\n")
				.append("JOIN tbm_customer B \n")
				.append("	ON (B.cust_cd = A.subcontractor_no) \n")
				.append("	AND (B.revision_no = A.subcontractor_rev)\n")
				.append("WHERE A.subcontractor_no 	= '" + jArray.get("subcontractor_no") + "' \n")
				.append("AND A.subcontractor_rev 	= '" + jArray.get("subcontractor_rev") + "' \n")
				.append("AND A.subcontractor_seq 	= '" + jArray.get("subcontractor_seq") + "' \n")
				.append("AND B.company_type_b 	= '" + jArray.get("io_gb") + "' \n")
				.append("AND B.duration_date = '9999-12-31'\n")
				.append("AND A.member_key 		 	= '" + jArray.get("member_key") + "' \n")
				.append("GROUP BY A.assessment_division\n")
				.append("ORDER BY A.assessment_no asc\n")
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
			LoggingWriter.setLogError("M838S060300E135()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M838S060300E135()","==== finally ===="+ e.getMessage());
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
}