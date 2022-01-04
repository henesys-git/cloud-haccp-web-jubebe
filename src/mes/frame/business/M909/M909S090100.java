package mes.frame.business.M909;

import java.lang.reflect.Method;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.util.Arrays;
import java.util.Vector;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;

import mes.frame.common.ApprovalActionNo;
import mes.client.conf.Config;
import mes.frame.common.EventDefine;
import mes.frame.common.HashObject;
import mes.frame.common.MessageDefine;
import mes.frame.common.QueueProcessing;
import mes.frame.database.JDBCConnectionPool;
import mes.frame.database.SqlAdapter;
import mes.frame.serviceinterface.InoutParameter;
import mes.frame.serviceinterface.LoggingWriter;
import mes.frame.util.CommonFunction;


public class M909S090100 extends SqlAdapter{
	Connection con = null;
	PreparedStatement pstmt = null;
	String resultString = "";
	int resultInt = -1;
	StringBuffer sql = new StringBuffer();
	
	String[][] v_paramArray = new String[0][0]; 
	Class[] optClass = null;
	Object[] optObj = null;
	Object obj = null;
	
	public M909S090100(){
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

			Method method = M909S090100.class.getMethod(event,optClass);
			LoggingWriter.setLogDebug(M909S090100.class.getName(),"==== " + event + " EventMethod Create Success ====");

			obj = method.invoke(M909S090100.class.newInstance(),optObj);
			doExcute_result = CommonFunction.getInt(obj.toString());
			
	    } catch (Exception ex) {
	    	doExcute_result = EventDefine.E_DOEXCUTE_INIT;
			ioParam.setMessage(MessageDefine.M_NO_EVENTID);
			LoggingWriter.setLogError(M909S090100.class.getName(),"==== EventID Not define : EVENT ID [ " + ioParam.getEventID() + "]");
	    } finally {
	    	obj = null;
			optClass = null;
			optObj = null;
	    }
	    long endTime = System.currentTimeMillis();
		long runningTime = endTime - startTime;
		LoggingWriter.setLogAll(M909S090100.class.getName(),"==== Query [수행시간  : " + runningTime + " ms]");
		
		return doExcute_result;
	}
	

	public int E101(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			// 클라이언트로 부터 받은 파라미터를 옮겨 담는다.
			String rcvData = (String)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			
			// 클라이언트로 부터 받은 파라미터를 쪼개어서 배열에 담는다.
			String[][] c_paramArray = CommonFunction.getConvString2DoubleArray(rcvData);

			String sql = new StringBuilder()
				.append("INSERT INTO tbm_menu ( "
						+ "class_id "
						+ ",menu_id "
						+ ",menu_name "
						+ ",menu_level "
						+ ",order_index "
						+ ",delyn "
						+ ",parent_menu_id "
						+ ",program_id "
						+ ",update_user "
						+ ",updatedate "
						+ ",member_key ) \n")
				.append(" values ('"	+ c_paramArray[0][0].substring(0, 4) + "' \n")	//class_id
				.append(" 		,'" 	+ c_paramArray[0][0] + "' \n") 	//menu_id
				.append(" 		,'" 	+ c_paramArray[0][1] + "' \n") 	//menu_name
				.append(" 		,'" 	+ c_paramArray[0][2] + "' \n") 	//menu_level
				.append(" 		,'" 	+ c_paramArray[0][3] + "' \n") 	//order_index
				.append(" 		,'" 	+ c_paramArray[0][4] + "' \n") 	//delyn
				.append(" 		,'" 	+ c_paramArray[0][5] + "' \n") 	//parent_menu_id
				.append(" 		,'" 	+ c_paramArray[0][6] + "' \n") 	//program_id
				.append(" 		,'" 	+ c_paramArray[0][7] + "' \n") 	//update_user
				.append(" 		,SYSDATETIME \n")						//updatedate
				.append(" 		,'" + c_paramArray[0][8] + "' \n") //member_key_values
				.append("	)\n")
				.toString();
					
			// System.out.println(sql.toString());
			
				resultInt = super.excuteUpdate(con, sql.toString());
				if (resultInt < 0) {
					ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
				} else {
					ioParam.setMessage(resultInt + "건 " + MessageDefine.M_INSERT_RESULT);
				}
				
		} catch(Exception e) {
			LoggingWriter.setLogError("M909S090100E101()","==== SQL ERROR ===="+ e.getMessage() + "\n" + sql.toString());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M909S090100E101()","==== finally ===="+ e.getMessage());
				}
	    	} else {
	    	}
	    }
	    // 결과 전문 구성을 위한 파라미터들을 아이오 파라미터에 저장한다.
		ioParam.setResultString(resultString);
		// 수퍼에서 처리된 칼럼의 갯수를 클라이언트에게 보내기 위해 가져온다.
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
		// 잘 처리되었다는 메시지를 클라이언트에게 보내기 위해 I/O파라미터에 저장한다.
		// 위에서 저장된 넘을 보존하기 위해서 막는다.
    	// ioParam.setMessage(MessageDefine.M_QUERY_OK);
	    return EventDefine.E_QUERY_RESULT;
	}
	
	public int E102(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			// 클라이언트로 부터 받은 파라미터를 옮겨 담는다.
			String rcvData = (String)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			
			// 클라이언트로 부터 받은 파라미터를 쪼개어서 배열에 담는다.
			String[][] c_paramArray = CommonFunction.getConvString2DoubleArray(rcvData);

			String sql = new StringBuilder()
				.append("UPDATE tbm_menu SET \n" ) 
//				.append("	 menu_id= '" + c_paramArray[0][0] + "' \n")
				.append("	 menu_name= '" + c_paramArray[0][1] + "' \n")
				.append("	,menu_level= '" + c_paramArray[0][2] + "' \n")
				.append("	,order_index= '" + c_paramArray[0][3] + "' \n")
				.append("	,delyn= '" + c_paramArray[0][4] + "' \n")
				.append("	,parent_menu_id= '" + c_paramArray[0][5] + "' \n")
				.append("	,program_id= '" + c_paramArray[0][6] + "' \n")
				.append("	,update_user= '" + c_paramArray[0][7] + "' \n")
				.append("	,updatedate= SYSDATETIME \n")
				.append(" 	,member_key = 	'" + c_paramArray[0][8] + "'		\n")
				.append(" WHERE \n")	//menu_id
				.append(" 	program_id='" 	+ c_paramArray[0][6] + "' \n")
				.append(" 	AND member_key = '" + c_paramArray[0][8] + "' \n") //member_key_select, update, delete
				.toString();
					
			// System.out.println(sql.toString());
			
				resultInt = super.excuteUpdate(con, sql.toString());
				if (resultInt < 0) {
					ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
				} else {
					ioParam.setMessage(resultInt + "건 " + MessageDefine.M_INSERT_RESULT);
				}
				
		} catch(Exception e) {
			LoggingWriter.setLogError("M909S090100E102()","==== SQL ERROR ===="+ e.getMessage() + "\n" + sql.toString());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M909S090100E102()","==== finally ===="+ e.getMessage());
				}
	    	} else {
	    	}
	    }
	    // 결과 전문 구성을 위한 파라미터들을 아이오 파라미터에 저장한다.
		ioParam.setResultString(resultString);
		// 수퍼에서 처리된 칼럼의 갯수를 클라이언트에게 보내기 위해 가져온다.
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
		// 잘 처리되었다는 메시지를 클라이언트에게 보내기 위해 I/O파라미터에 저장한다.
		// 위에서 저장된 넘을 보존하기 위해서 막는다.
    	// ioParam.setMessage(MessageDefine.M_QUERY_OK);
	    return EventDefine.E_QUERY_RESULT;
	}


	public int E103(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			// 클라이언트로 부터 받은 파라미터를 옮겨 담는다.
			String rcvData = (String)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			
			// 클라이언트로 부터 받은 파라미터를 쪼개어서 배열에 담는다.
			String[][] c_paramArray = CommonFunction.getConvString2DoubleArray(rcvData);

			String sql = new StringBuilder()
				.append("DELETE FROM tbm_menu WHERE \n")	//menu_id
				.append(" 	program_id='" 	+ c_paramArray[0][6] + "' \n")
				.append(" 	AND member_key = '" + c_paramArray[0][8] + "' \n") //member_key_select, update, delete
				.toString();
					
				resultInt = super.excuteUpdate(con, sql.toString());
				if (resultInt < 0) {
					ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
				} else {
					ioParam.setMessage(resultInt + "건 " + MessageDefine.M_INSERT_RESULT);
				}
				
		} catch(Exception e) {
			LoggingWriter.setLogError("M909S090100E103()","==== SQL ERROR ===="+ e.getMessage() + "\n" + sql.toString());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M909S090100E103()","==== finally ===="+ e.getMessage());
				}
	    	} else {
	    	}
	    }
	    // 결과 전문 구성을 위한 파라미터들을 아이오 파라미터에 저장한다.
		ioParam.setResultString(resultString);
		// 수퍼에서 처리된 칼럼의 갯수를 클라이언트에게 보내기 위해 가져온다.
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
		// 잘 처리되었다는 메시지를 클라이언트에게 보내기 위해 I/O파라미터에 저장한다.
		// 위에서 저장된 넘을 보존하기 위해서 막는다.
    	// ioParam.setMessage(MessageDefine.M_QUERY_OK);
	    return EventDefine.E_QUERY_RESULT;
	}

	// 헤드메뉴 
	public int E104(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			System.out.println("JSONObject jArray rcvData="+ jArray.toString());
			
			// 클라이언트로 부터 받은 파라미터를 옮겨 담는다.
//			String rcvData = (String)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			// 클라이언트로 부터 받은 파라미터를 쪼개어서 배열에 담는다.
			// rcvData = [위경도]
//			String[][] c_paramArray = CommonFunction.getConvString2DoubleArray(rcvData);
			// {"사용자ID", "사용자명", "그룹코드", "부서코드", "휴대폰번호","이메일주소", "직위", "위치", "패스워드", 
			// "revision_no", "delyn", "start_date"} ;	
			String sql = new StringBuilder()
//					.append("SELECT\n")
//					.append("	user_id,		\n")
//					.append("	user_nm,		\n")
//					.append("	group_cd,		\n")
//					.append("	dept_cd,	\n")
//					.append("	hpno,		\n")
//					.append("	email,		\n")
//					.append("	jikwi,			\n")
//					.append("	LOCATION,			\n")
//					.append("	user_pwd,			\n")
//					.append("	revision_no,			\n")
//					.append("	delyn,			\n")
//					.append("	start_date			\n")
//					.append("FROM	tbm_users		\n")
//					.append("WHERE user_id like '%" 	+ c_paramArray[0][0] + "%'	\n")
					.append("SELECT\n")
					.append("        user_id,\n")
					.append("        user_nm,\n")
					.append("        group_cd,\n")
					.append("        dept_cd,\n")
					.append("        hpno,\n")
					.append("        email,\n")
					.append("        jikwi,\n")
					.append("        LOCATION,\n")
					.append("        user_pwd,\n")
					.append("        revision_no,\n")
					.append("        delyn,\n")
					.append("        start_date\n")
					.append("FROM    tbm_users A \n")
					.append("WHERE user_id like '%" 	+ jArray.get("USER_ID") + "%'\n")
					.append("AND TO_CHAR(SYSDATE,'YYYY-MM-DD') BETWEEN start_date AND duration_date\n")
					.append(" 	AND member_key = '" + jArray.get("member_key") + "' \n") //member_key_select, update, delete
					.append("AND A.revision_no = (SELECT MAX(revision_no) 							\n")
					.append("						FROM tbm_users B 								\n")
					.append("                       WHERE A.user_id = B.user_id)						\n")
					.toString();  

			resultString = super.excuteQueryString(con, sql.toString());
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M909S090100E104()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M909S090100E104()","==== finally ===="+ e.getMessage());
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
	
	


	// 추가
	public int E111(InoutParameter ioParam){
		String sql ="";
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();

    		// insert_update_delete_json.jsp에서 받아온 JSON데이터 처리
    		JSONObject jArray = new JSONObject();
    		jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
    		System.out.println("JSONObject jArray rcvData="+ jArray.toString());
    		// Object데이터에서 키값(param)으로 JSONArray데이터를 꺼낸다. (데이터묶음 하나일땐 생략)
    		JSONArray jjArray = (JSONArray) jArray.get("param");
    		System.out.println("데이터 묶음 개수 :::: " + jjArray.size());
    		
    		
//    		JSONObject jjjArray0 = (JSONObject)jjArray.get(0); // 0번째 데이터묶음
    		
//			String[][] c_paramArray_Head=null;
//			String[][] c_paramArray_Detail=null;
			// 클라이언트로 부터 받은 파라미터를 옮겨 담는다.
//			String rcvData = (String)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
//			Vector resultVector = CommonFunction.getConvStringDamogjuk(rcvData);

			con.setAutoCommit(false);
			
//			c_paramArray_Head = (String[][])resultVector.get(0);//head table
//    		c_paramArray_Detail=(String[][])resultVector.get(1); //data table
    		
			// 클라이언트로 부터 받은 파라미터를 쪼개어서 배열에 담는다. returnStringBuffer
			// String[][] c_paramArray = CommonFunction.getConvString2DoubleArray(rcvData);
    	
			for(int i=0;i<jjArray.size();i++) {
				JSONObject jjjArray = (JSONObject)jjArray.get(i); // i번째 데이터묶음 
				sql = new StringBuilder()
					.append("INSERT INTO\n")
					.append("	tbm_group_menu (		\n")
					.append("		group_cd,			\n")
					.append("		user_id,			\n")
					.append("		menu_id,			\n")
//					.append("		delyn,				\n")
					.append("		autho_menu,			\n")
					.append("		autho_insert,		\n")
					.append("		autho_update,		\n")
					.append("		autho_delete,		\n")
					.append("		autho_select		\n")
					.append(" 		,member_key			\n") // member_key_insert
					.append("	)\n")
					.append("VALUES ( \n")
					.append(" 		'" + jjjArray.get("group_cd") + "' \n") //group_cd
					.append(" 		,'" + jjjArray.get("user_id") + "' \n") //user_id
					.append(" 		,'" + jjjArray.get("menu_id") + "' \n") //menu_id
//					.append(" 		,'" + jjjArray.get("delyn") + "' \n") //delyn
					.append(" 		,'" + jjjArray.get("autho_menu") + "' \n") //autho_menu
					.append(" 		,'" + jjjArray.get("autho_insert") + "' \n") //autho_insert
					.append(" 		,'" + jjjArray.get("autho_update") + "' \n") //autho_update
					.append(" 		,'" + jjjArray.get("autho_delete") + "' \n") //autho_delete
					.append(" 		,'" + jjjArray.get("autho_select") + "' \n") //autho_select
					.append(" 		,'" + jjjArray.get("member_key") + "' \n") //member_key
					.append(" 	) \n")
					.toString();
				 
				// System.out.println(sql.toString());
				
				resultInt = super.excuteUpdate(con, sql.toString());
				if (resultInt < 0) {
					con.rollback();
					return EventDefine.E_DOEXCUTE_ERROR ;
				}
			}
			con.commit();
			
		} catch(Exception e) {
			LoggingWriter.setLogError("M909S090100E111()","==== SQL ERROR ===="+ e.getMessage() + "\n" + sql.toString());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M909S090100E111()","==== finally ===="+ e.getMessage());
				}
	    	} else {
	    	}
	    }
	    // 결과 전문 구성을 위한 파라미터들을 아이오 파라미터에 저장한다.
		ioParam.setResultString(resultString);
		// 수퍼에서 처리된 칼럼의 갯수를 클라이언트에게 보내기 위해 가져온다.
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
		// 잘 처리되었다는 메시지를 클라이언트에게 보내기 위해 I/O파라미터에 저장한다.
		// 위에서 저장된 넘을 보존하기 위해서 막는다.
    	// ioParam.setMessage(MessageDefine.M_QUERY_OK);
	    return EventDefine.E_QUERY_RESULT;
	}
	
	// 갱신
	public int E112(InoutParameter ioParam){
		String sql ="";
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();

			String[][] c_paramArray_Head=null;
			String[][] c_paramArray_Detail=null;
			// 클라이언트로 부터 받은 파라미터를 옮겨 담는다.
			String rcvData = (String)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			Vector resultVector = CommonFunction.getConvStringDamogjuk(rcvData);

			con.setAutoCommit(false);
			
			c_paramArray_Head = (String[][])resultVector.get(0);//head table
    		c_paramArray_Detail=(String[][])resultVector.get(1); //data table
    		
			// 클라이언트로 부터 받은 파라미터를 쪼개어서 배열에 담는다. returnStringBuffer
			// String[][] c_paramArray = CommonFunction.getConvString2DoubleArray(rcvData);

			for(int i=0;i<c_paramArray_Detail.length;i++) {
				 sql = new StringBuilder()
					.append(" UPDATE tbm_group_menu SET		\n")
					.append("		autho_menu = '" + c_paramArray_Detail[i][3] + "' \n")
					.append("		,autho_insert = '" + c_paramArray_Detail[i][4] + "' \n")
					.append("		,autho_update = '" + c_paramArray_Detail[i][5] + "' \n")
					.append("		,autho_delete = '" + c_paramArray_Detail[i][6] + "' \n")
					.append("		,autho_select = '" + c_paramArray_Detail[i][7] + "' \n")
					.append(" 		,member_key = 	'" + c_paramArray_Detail[i][8] + "'		\n")
					.append(" WHERE group_cd = '" + c_paramArray_Detail[i][0] + "' \n") //group_cd
					.append(" 	AND	user_id = '" + c_paramArray_Detail[i][1] + "' \n") //user_id
					.append(" 	AND	menu_id = '" + c_paramArray_Detail[i][2] + "' \n") //menu_id
					.append(" 	AND	member_key = '" + c_paramArray_Detail[i][8] + "' \n") //member_key
					.toString();
				resultInt = super.excuteUpdate(con, sql.toString());
				if (resultInt < 0) {
					con.rollback();
					return EventDefine.E_DOEXCUTE_ERROR ;
				}
			}
			// System.out.println(sql.toString());
			con.commit();
			
		} catch(Exception e) {
			LoggingWriter.setLogError("M909S090100E112()","==== SQL ERROR ===="+ e.getMessage() + "\n" + sql.toString());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M909S090100E112()","==== finally ===="+ e.getMessage());
				}
	    	} else {
	    	}
	    }
	    // 결과 전문 구성을 위한 파라미터들을 아이오 파라미터에 저장한다.
		ioParam.setResultString(resultString);
		// 수퍼에서 처리된 칼럼의 갯수를 클라이언트에게 보내기 위해 가져온다.
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
		// 잘 처리되었다는 메시지를 클라이언트에게 보내기 위해 I/O파라미터에 저장한다.
		// 위에서 저장된 넘을 보존하기 위해서 막는다.
    	// ioParam.setMessage(MessageDefine.M_QUERY_OK);
	    return EventDefine.E_QUERY_RESULT;
	}

	// 제거
	public int E113(InoutParameter ioParam){
		String sql ="";
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();

    		// insert_update_delete_json.jsp에서 받아온 JSON데이터 처리
    		JSONObject jArray = new JSONObject();
    		jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
    		System.out.println("JSONObject jArray rcvData="+ jArray.toString());
    		// Object데이터에서 키값(param)으로 JSONArray데이터를 꺼낸다. (데이터묶음 하나일땐 생략)
    		JSONArray jjArray = (JSONArray) jArray.get("param");
    		System.out.println("데이터 묶음 개수 :::: " + jjArray.size());

			con.setAutoCommit(false);
			
//			c_paramArray_Head = (String[][])resultVector.get(0);//head table
//    		c_paramArray_Detail=(String[][])resultVector.get(1); //data table
    		
			// 클라이언트로 부터 받은 파라미터를 쪼개어서 배열에 담는다. returnStringBuffer
			//String[][] c_paramArray = CommonFunction.getConvString2DoubleArray(rcvData);

			for(int i=0;i<jjArray.size();i++) {
				JSONObject jjjArray = (JSONObject)jjArray.get(i); // i번째 데이터묶음 
				 sql = new StringBuilder()
					.append(" DELETE FROM  tbm_group_menu 	\n")
					.append(" WHERE group_cd = '" + jjjArray.get("group_cd") + "' \n")
					.append(" AND	user_id = '" + jjjArray.get("user_id") + "' \n")
					.append(" AND 	menu_id = '" + jjjArray.get("menu_id") + "' \n")
					.append(" AND member_key = '" +  jjjArray.get("member_key") + "' \n") //member_key_select, update, delete
					.toString();
				 
				 // System.out.println(sql.toString());
				resultInt = super.excuteUpdate(con, sql.toString());
				if (resultInt < 0) {
					con.rollback();
					return EventDefine.E_DOEXCUTE_ERROR ;
				}
			}
//			// System.out.println(sql.toString());
			con.commit();
			
		} catch(Exception e) {
			LoggingWriter.setLogError("M909S090100E113()","==== SQL ERROR ===="+ e.getMessage() + "\n" + sql.toString());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M909S090100E113()","==== finally ===="+ e.getMessage());
				}
	    	} else {
	    	}
	    }
	    // 결과 전문 구성을 위한 파라미터들을 아이오 파라미터에 저장한다.
		ioParam.setResultString(resultString);
		// 수퍼에서 처리된 칼럼의 갯수를 클라이언트에게 보내기 위해 가져온다.
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
		// 잘 처리되었다는 메시지를 클라이언트에게 보내기 위해 I/O파라미터에 저장한다.
		// 위에서 저장된 넘을 보존하기 위해서 막는다.
    	// ioParam.setMessage(MessageDefine.M_QUERY_OK);
	    return EventDefine.E_QUERY_RESULT;
	}
	
//메뉴 의 프로그램 목록
	public int E114(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			System.out.println("JSONObject jArray rcvData="+ jArray.toString());
			
			// 클라이언트로 부터 받은 파라미터를 옮겨 담는다.
//			String rcvData = (String)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			// 클라이언트로 부터 받은 파라미터를 쪼개어서 배열에 담는다.
			// rcvData = [위경도]
//			String[][] c_paramArray = CommonFunction.getConvString2DoubleArray(rcvData);

			String sql = new StringBuilder()
					.append("SELECT								\n")
					.append("	M.menu_id						\n")
					.append("	,M.menu_name					\n")
					.append("	,M.program_id					\n")
					.append("	,M.menu_level					\n")
					.append("	,GM.group_cd					\n")
					.append("	,GM.user_id						\n")
					.append("FROM								\n")
					.append("	tbm_group_menu GM, tbm_menu M						\n")
					.append("WHERE GM.menu_id = M.menu_id							\n")
					.append("	AND GM.member_key = M.member_key							\n")
					.append("	AND GM.user_id = '" + jArray.get("USER_ID") + "' 		\n")
					.append("	AND GM.group_cd = '" + jArray.get("GROUP_CD") + "' 		\n")
					.append(" 	AND GM.member_key = '" + jArray.get("member_key") + "' \n") //member_key_select, update, delete
					.append("ORDER BY M.menu_id 									\n")
					.toString();
			resultString = super.excuteQueryString(con, sql.toString());
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M909S090100E114()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M909S090100E114()","==== finally ===="+ e.getMessage());
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
	
	// 프로그램 권한 OK
		public int E122(InoutParameter ioParam){
			String sql ="";
			resultInt = EventDefine.E_DOEXCUTE_INIT;
			
			try {
				con = JDBCConnectionPool.getConnection();

	    		// insert_update_delete_json.jsp에서 받아온 JSON데이터 처리
	    		JSONObject jArray = new JSONObject();
	    		jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
	    		System.out.println("JSONObject jArray rcvData="+ jArray.toString());
	    		// Object데이터에서 키값(param)으로 JSONArray데이터를 꺼낸다. (데이터묶음 하나일땐 생략)
	    		JSONArray jjArray = (JSONArray) jArray.get("param");
	    		System.out.println("데이터 묶음 개수 :::: " + jjArray.size());

				con.setAutoCommit(false);
				
//				c_paramArray_Head = (String[][])resultVector.get(0);//head table
//	    		c_paramArray_Detail=(String[][])resultVector.get(1); //data table
	    		
				// 클라이언트로 부터 받은 파라미터를 쪼개어서 배열에 담는다. returnStringBuffer
				//String[][] c_paramArray = CommonFunction.getConvString2DoubleArray(rcvData);

				for(int i=0;i<jjArray.size();i++) {
					JSONObject jjjArray = (JSONObject)jjArray.get(i); // i번째 데이터묶음 
					sql = new StringBuilder()
							.append(" UPDATE tbm_group_menu SET		\n")
							.append("autho_menu = '" + jjjArray.get("autho_menu") + "' \n")
							.append(",autho_insert = '" + jjjArray.get("autho_insert") + "' \n")
							.append(",autho_update = '" + jjjArray.get("autho_update") + "' \n")
							.append(",autho_delete = '" + jjjArray.get("autho_delete") + "' \n")
							.append(",autho_select = '" + jjjArray.get("autho_select") + "' \n")
							.append(",member_key = '" + jjjArray.get("member_key") + "'\n")
							.append(" WHERE group_cd = '" + jjjArray.get("group_cd") + "' \n")
							.append(" AND user_id = '" + jjjArray.get("user_id") + "' \n")
							.append(" AND menu_id = '" + jjjArray.get("menu_id") + "' \n")
							.append(" AND member_key = '" +  jjjArray.get("member_key") + "' \n")
							.toString();	 
							 
					 // System.out.println(sql.toString());
					resultInt = super.excuteUpdate(con, sql.toString());
					if (resultInt < 0) {
						con.rollback();
						return EventDefine.E_DOEXCUTE_ERROR ;
					}
				}
//				// System.out.println(sql.toString());
				con.commit();
				
			} catch(Exception e) {
				LoggingWriter.setLogError("M909S090100E122()","==== SQL ERROR ===="+ e.getMessage() + "\n" + sql.toString());
				return EventDefine.E_DOEXCUTE_ERROR ;
		    } finally {
		    	if (Config.useDataSource) {
					try {
						if (con != null) con.close();
					} catch (Exception e) {
						LoggingWriter.setLogError("M909S090100E122()","==== finally ===="+ e.getMessage());
					}
		    	} else {
		    	}
		    }
		    // 결과 전문 구성을 위한 파라미터들을 아이오 파라미터에 저장한다.
			ioParam.setResultString(resultString);
			// 수퍼에서 처리된 칼럼의 갯수를 클라이언트에게 보내기 위해 가져온다.
			ioParam.setColumnCount("" + super.COLUMN_COUNT);
			// 잘 처리되었다는 메시지를 클라이언트에게 보내기 위해 I/O파라미터에 저장한다.
			// 위에서 저장된 넘을 보존하기 위해서 막는다.
	    	// ioParam.setMessage(MessageDefine.M_QUERY_OK);
		    return EventDefine.E_QUERY_RESULT;
		}
		
		// 프로그램 권한 NO
		public int E132(InoutParameter ioParam){
			String sql ="";
			resultInt = EventDefine.E_DOEXCUTE_INIT;
			
			try {
				con = JDBCConnectionPool.getConnection();

	    		// insert_update_delete_json.jsp에서 받아온 JSON데이터 처리
	    		JSONObject jArray = new JSONObject();
	    		jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
	    		System.out.println("JSONObject jArray rcvData="+ jArray.toString());
	    		// Object데이터에서 키값(param)으로 JSONArray데이터를 꺼낸다. (데이터묶음 하나일땐 생략)
	    		JSONArray jjArray = (JSONArray) jArray.get("param");
	    		System.out.println("데이터 묶음 개수 :::: " + jjArray.size());

				con.setAutoCommit(false);
				
//				c_paramArray_Head = (String[][])resultVector.get(0);//head table
//	    		c_paramArray_Detail=(String[][])resultVector.get(1); //data table
	    		
				// 클라이언트로 부터 받은 파라미터를 쪼개어서 배열에 담는다. returnStringBuffer
				//String[][] c_paramArray = CommonFunction.getConvString2DoubleArray(rcvData);

				for(int i=0;i<jjArray.size();i++) {
					JSONObject jjjArray = (JSONObject)jjArray.get(i); // i번째 데이터묶음 
					sql = new StringBuilder()
						.append(" UPDATE tbm_group_menu SET		\n")
						.append("autho_menu = '" + jjjArray.get("autho_menu") + "' \n")
						.append(",autho_insert = '" + jjjArray.get("autho_insert") + "' \n")
						.append(",autho_update = '" + jjjArray.get("autho_update") + "' \n")
						.append(",autho_delete = '" + jjjArray.get("autho_delete") + "' \n")
						.append(",autho_select = '" + jjjArray.get("autho_select") + "' \n")
						.append(" ,member_key = '" + jjjArray.get("member_key") + "'\n")
						.append(" WHERE group_cd = '" + jjjArray.get("group_cd") + "' \n")
						.append(" AND user_id = '" + jjjArray.get("user_id") + "' \n")
						.append(" AND menu_id = '" + jjjArray.get("menu_id") + "' \n")
						.append(" AND member_key = '" +  jjjArray.get("member_key") + "' \n")
						.toString();
					 
					 // System.out.println(sql.toString());
					resultInt = super.excuteUpdate(con, sql.toString());
					if (resultInt < 0) {
						con.rollback();
						return EventDefine.E_DOEXCUTE_ERROR ;
					}
				}
//				// System.out.println(sql.toString());
				con.commit();
				
			} catch(Exception e) {
				LoggingWriter.setLogError("M909S090100E132()","==== SQL ERROR ===="+ e.getMessage() + "\n" + sql.toString());
				return EventDefine.E_DOEXCUTE_ERROR ;
		    } finally {
		    	if (Config.useDataSource) {
					try {
						if (con != null) con.close();
					} catch (Exception e) {
						LoggingWriter.setLogError("M909S090100E132()","==== finally ===="+ e.getMessage());
					}
		    	} else {
		    	}
		    }
		    // 결과 전문 구성을 위한 파라미터들을 아이오 파라미터에 저장한다.
			ioParam.setResultString(resultString);
			// 수퍼에서 처리된 칼럼의 갯수를 클라이언트에게 보내기 위해 가져온다.
			ioParam.setColumnCount("" + super.COLUMN_COUNT);
			// 잘 처리되었다는 메시지를 클라이언트에게 보내기 위해 I/O파라미터에 저장한다.
			// 위에서 저장된 넘을 보존하기 위해서 막는다.
	    	// ioParam.setMessage(MessageDefine.M_QUERY_OK);
		    return EventDefine.E_QUERY_RESULT;
		}


	
	public int E124(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			System.out.println("JSONObject jArray rcvData="+ jArray.toString());
			
			// 클라이언트로 부터 받은 파라미터를 옮겨 담는다.
//			String rcvData = (String)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			// 클라이언트로 부터 받은 파라미터를 쪼개어서 배열에 담는다.
			// rcvData = [위경도]
//			String[][] c_paramArray = CommonFunction.getConvString2DoubleArray(rcvData);
			
			String sql = new StringBuilder()
					.append("SELECT								\n")
					.append("	M.menu_id						\n")
					.append("	,M.menu_name					\n")
					.append("	,GM.autho_insert				\n")
					.append("	,GM.autho_update				\n")
					.append("	,GM.autho_delete				\n")
					.append("	,GM.autho_select				\n")
					.append("	,GM.autho_menu					\n")
					.append("	,M.program_id					\n")
					.append("	,M.menu_level					\n")
					.append("	,GM.group_cd					\n")
					.append("	,GM.user_id						\n")
					.append("FROM								\n")
					.append("	tbm_group_menu GM, tbm_menu M						\n")
					.append("WHERE GM.menu_id = M.menu_id							\n")
					.append("	AND GM.member_key = M.member_key							\n")
					.append("	AND GM.user_id = '" + jArray.get("USER_ID") + "' 		\n")
					.append("	AND GM.group_cd = '" + jArray.get("GROUP_CD") + "' 		\n")
					.append(" 	AND GM.member_key = '" + jArray.get("member_key") + "' \n") //member_key_select, update, delete
					.append("ORDER BY M.menu_id 									\n")
					.toString();

			resultString = super.excuteQueryString(con, sql.toString());
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M909S090100E124()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M909S090100E124()","==== finally ===="+ e.getMessage());
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

	public int E134(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			System.out.println("JSONObject jArray rcvData="+ jArray.toString());
			
			// 클라이언트로 부터 받은 파라미터를 옮겨 담는다.
//			String rcvData = (String)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			// 클라이언트로 부터 받은 파라미터를 쪼개어서 배열에 담는다.
			// rcvData = [위경도]
//			String[][] c_paramArray = CommonFunction.getConvString2DoubleArray(rcvData);	
			
			String sql = new StringBuilder()
					.append("SELECT DISTINCT									\n")
					.append("	M.menu_id										\n")
					.append("	,M.menu_name									\n")
					.append("	,NVL(GM.autho_insert,0) AS autho_insert			\n")
					.append("	,NVL(GM.autho_update,0) AS autho_update			\n")
					.append("	,NVL(GM.autho_delete,0) AS autho_delete			\n")
					.append("	,NVL(GM.autho_select,0) AS autho_select			\n")
					.append("	,NVL(GM.autho_menu,0) AS autho_menu				\n")
					.append("FROM tbm_menu M									\n")
					.append("LEFT OUTER JOIN tbm_group_menu GM					\n")
					.append("	ON M.menu_id=GM.menu_id							\n")
					.append("	AND M.member_key = GM.member_key\n")
					.append("	AND GM.user_id = '" + jArray.get("USER_ID") + "'	\n")
					.append("	AND GM.group_cd = '" + jArray.get("GROUP_CD") + "' 		\n")
					.append("WHERE M.menu_id NOT IN (							\n")
					.append("	SELECT menu_id									\n")
					.append("	FROM tbm_group_menu								\n")
					.append("	WHERE user_id = '" + jArray.get("USER_ID") + "'	\n")
					.append("	AND group_cd = '" + jArray.get("GROUP_CD") + "' 		\n")
					.append(" 	AND member_key = '" + jArray.get("member_key") + "' \n") //member_key_select, update, delete
					.append(")													\n")
					.append(" 	AND M.member_key = '" + jArray.get("member_key") + "' \n") //member_key_select, update, delete
					.append("ORDER BY M.menu_id									\n")
					.toString();

			
			resultString = super.excuteQueryString(con, sql.toString());
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M909S090100E134()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M909S090100E134()","==== finally ===="+ e.getMessage());
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

	/*
	//메뉴 의 특정프로그램
		public int E214(InoutParameter ioParam){
			resultInt = EventDefine.E_DOEXCUTE_INIT;
			
			try {
				con = JDBCConnectionPool.getConnection();
				
				// 클라이언트로 부터 받은 파라미터를 옮겨 담는다.
				String rcvData = (String)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
				// 클라이언트로 부터 받은 파라미터를 쪼개어서 배열에 담는다.
				// rcvData = [위경도]
				String[][] c_paramArray = CommonFunction.getConvString2DoubleArray(rcvData);

				String sql = new StringBuilder()
						.append("SELECT\n")
						.append("	parent_menu_id,	\n")
						.append("	menu_id,		\n")
						.append("	menu_name,		\n")
						.append("	menu_level,		\n")
						.append("	program_id,		\n")
						.append("	order_index,	\n")
						.append("	updatedate,		\n")
						.append("	update_user,	\n")
						.append("	delyn			\n")
						.append("FROM				\n")
						.append("	tbm_menu			\n")
						.append("WHERE  menu_level > 0	\n")
						.append("AND  program_id = '" + c_paramArray[0][0] + "' \n") 
						.toString();
				resultString = super.excuteQueryString(con, sql.toString());
			} catch(Exception e) {
				e.printStackTrace();
				LoggingWriter.setLogError("M909S090100E214()","==== SQL ERROR ===="+ e.getMessage());
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
		    // 결과 전문 구성을 위한 파라미터들을 아이오 파라미터에 저장한다.
			ioParam.setResultString(resultString);
			// 수퍼에서 처리된 칼럼의 갯수를 클라이언트에게 보내기 위해 가져온다.
			ioParam.setColumnCount("" + super.COLUMN_COUNT);
			// 잘 처리되었다는 메시지를 클라이언트에게 보내기 위해 I/O파라미터에 저장한다.
	    	ioParam.setMessage(MessageDefine.M_QUERY_OK);
		    return EventDefine.E_QUERY_RESULT;
		}
		*/
}