package mes.frame.business.M909;
/*공정코드*/
import java.lang.reflect.Method;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.util.Vector;

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
public  class M909S140100 extends SqlAdapter{
	Connection con = null;
	PreparedStatement pstmt = null;
	String resultString = "";
	int resultInt = -1;
	StringBuffer sql = new StringBuffer();
	
	String[][] v_paramArray = new String[0][0]; 
	Class[] optClass = null;
	Object[] optObj = null;
	Object obj = null;
	
	public M909S140100(){
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
			
			Method method = M909S140100.class.getMethod(event,optClass);
			LoggingWriter.setLogDebug(M909S140100.class.getName(),"==== " + event + " EventMethod Create Success ====");

			obj = method.invoke(M909S140100.class.newInstance(),optObj);
			doExcute_result = CommonFunction.getInt(obj.toString());
			
	    } catch (Exception ex) {
	    	doExcute_result = EventDefine.E_DOEXCUTE_INIT;
			ioParam.setMessage(MessageDefine.M_NO_EVENTID);
			LoggingWriter.setLogError(M909S140100.class.getName(),"==== EventID Not define : EVENT ID [ " + ioParam.getEventID() + "]");
	    } finally {
	    	obj = null;
			optClass = null;
			optObj = null;
	    }
	    long endTime = System.currentTimeMillis();
		long runningTime = endTime - startTime;
		LoggingWriter.setLogAll(M909S140100.class.getName(),"==== Query [수행시간  : " + runningTime + " ms]");
		
		return doExcute_result;
	}

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

			// 꺼낸 데이터의 값을 쿼리문에 집어넣는다.
									
				String sql = new StringBuilder()
						.append("INSERT INTO tbm_code_book (	\n")
						.append("		code_cd,					\n")
						.append("		code_value,				\n")
						.append("		code_name,				\n")
						.append("		revision_no,			\n")
						.append("		bigo,					\n")
						.append("		start_date,				\n")
						.append("		duration_date,			\n")
						.append("		create_user_id,			\n")
						.append("		order_index,			\n")
						.append("		create_date,			\n")
						.append("		modify_user_id,			\n") // 
						.append("		modify_reason,			\n") //
						.append("		modify_date,			\n") //
						.append(" 		member_key				\n") // member_key_insert
						.append("	)							\n")
						.append("VALUES							\n")
						.append("	(							\n")
						.append("	 '" + jArray.get("code_cd") + "',		\n") //code_cd
						.append("	 '" + jArray.get("code_value") + "',		\n") //code_value
						.append("	 '" + jArray.get("code_name") + "',		\n") //code_name
						.append("	 '" + jArray.get("revision_no") + "',		\n") //revision_no
						.append("	 '" + jArray.get("bigo") + "',		\n") //bigo
						.append("	 '" + jArray.get("start_date") + "',		\n") //start_date
						.append("	 '" + jArray.get("duration_date") + "',		\n") //duration_date
						.append("	 '" + jArray.get("create_user_id") + "',		\n") //create_user_id
						
						.append("		   (SELECT MAX(order_index)  +1		\n")
						.append("			FROM vtbm_code_book			\n")
						.append("			WHERE code_cd = '"+ jArray.get("code_cd") +"'), \n")	// code_cd
		
						.append("	 SYSDATETIME,						\n") //create_date
						.append("	 '" + jArray.get("modify_user_id") + "',		\n") //modify_user_id
						.append("	 '" + jArray.get("modify_reason") + "',		\n") //modify_reason
						.append("	 SYSDATETIME,						\n") //modify_date
						.append(" 	 '" + jArray.get("member_key") + "' \n") //member_key_values
						.append("	);\n")
						.toString();

				//System.out.println("=================================================================\n" + sql.toString());
				// super의 excuteUpdate는 3가지가 있다.
				// 첫째는 super.excuteUpdate(con, sql.toString(), v_paramArray)형태 이며,
				// PreparedStatement를 사용하기 위해 파라미터들을 배령에 담아 보낸면 체크를 해서 수행하는 구조이다. 그리고
				// 두번째는 super.excuteUpdate(con, Vector)인데, 멀티 로우를 등록하기 위해 마련된 장치이다.
				// 세번째는 하나의 SQL을 String으로 받아서 처리하는 경우이다.
				// 현재 위의 SQL형태라면.. 당연히 1개의 로우에 해당되므로 세번째 메쏘드를 사용하는 것이 편하다.
				
				resultInt = super.excuteUpdate(con, sql.toString());
				if (resultInt < 0) {
					ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
				} else {
					ioParam.setMessage(resultInt + "건 " + MessageDefine.M_INSERT_RESULT);
				}
			con.commit();
		} catch(Exception e) {
			LoggingWriter.setLogError("M909S140100E101()","==== SQL ERROR ===="+ e.getMessage() + "\n" + sql.toString());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M909S140100E101()","==== finally ===="+ e.getMessage());
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
			con.setAutoCommit(false);
			
			// insert_update_delete_json.jsp에서 받아온 JSON데이터 처리
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			System.out.println("JSONObject jArray rcvData="+ jArray.toString());
			// Object데이터에서 키값(param)으로 JSONArray데이터를 꺼낸다. (데이터묶음 하나일땐 생략)
			JSONArray jjArray = (JSONArray) jArray.get("param");
			System.out.println("데이터 묶음 개수 :::: " + jjArray.size());
			// 꺼낸 데이터의 값을 쿼리문에 집어넣는다. (데이터묶음 하나일땐 for문 생략)
			for(int i=0; i<jjArray.size(); i++) {
				JSONObject jjjArray = (JSONObject)jjArray.get(i);
				
				// 먼저 이전 리비전에 대한 적용종료일자를 이번의 적용일자에서 하루를 뺀 날짜로 변경한다.
				String sqlPre = new StringBuilder()
						.append("UPDATE tbm_code_book SET	\n")
						.append(" duration_date = to_char(TO_DATE('" + jjjArray.get("start_date") + "', 'YYYY-MM-DD')-1 , 'YYYY-MM-DD')	\n")
						.append(" 	,member_key = 	'" + jjjArray.get("member_key") + "'		\n") 
						.append("WHERE code_value = '" + jjjArray.get("code_value") + "'\n")
						// 13번째는 이전의 리비전코드가 들어온다.
						.append("	AND revision_no = '" + (Integer.parseInt((jjjArray.get("revision_no").toString()))-1) + "'\n")
						.append(" 	AND member_key = '" + jjjArray.get("member_key") + "' \n") //member_key_select, update, delete
						.toString();
				
				//System.out.println(sqlPre.toString());
				resultInt = super.excuteUpdate(con, sqlPre.toString());
				if (resultInt < 0) {
					con.rollback();
					ioParam.setMessage(MessageDefine.M_UPDATE_FAILED);
					return resultInt;
				} else {
					ioParam.setMessage(resultInt + "건 " + MessageDefine.M_UPDATE_RESULT);
				}
				
				String sql = new StringBuilder()
						.append("INSERT INTO tbm_code_book (	\n")
						.append("		code_cd,				\n")
						.append("		code_value,				\n")
						.append("		code_name,				\n")
						.append("		revision_no,			\n")
						.append("		bigo,					\n")
						.append("		start_date,				\n")
						.append("		duration_date,			\n")
						.append("		create_user_id,			\n")
						.append("		order_index,			\n")
						.append("		create_date,			\n")
						.append("		modify_user_id,			\n") // 
						.append("		modify_reason,			\n") //
						.append("		modify_date				\n") //
						.append(" 		,member_key						\n") // member_key_insert
						.append("	)							\n")
						.append("VALUES							\n")
						.append("	(							\n")
						.append("	 '" + jjjArray.get("code_cd") + "',					\n") //code_cd
						.append("	 '" + jjjArray.get("code_value") + "',				\n") //code_value
						.append("	 '" + jjjArray.get("code_name") + "',				\n") //code_name
						.append("	 '" + jjjArray.get("revision_no") + "',				\n") //revision_no
						.append("	 '" + jjjArray.get("bigo") + "',					\n") //bigo
						.append("	 '" + jjjArray.get("start_date") + "',				\n") //start_date
						.append("	 '" + jjjArray.get("duration_date") + "',			\n") //duration_date
						.append("	 '" + jjjArray.get("create_user_id") + "',			\n") //create_user_id

						//.append("	 ,'" + c_paramArray[0][8] + "'				\n") //order_index					
						.append(" (SELECT order_index\n")
						.append("	FROM tbm_code_book\n")
						.append("	WHERE code_cd = '" + jjjArray.get("code_cd") + "'\n")
						.append("	AND code_value = '" + jjjArray.get("code_value") + "'\n")
						.append("	AND member_key = '" + jjjArray.get("member_key") + "'\n")
						.append("	AND revision_no = '" + (Integer.parseInt((jjjArray.get("revision_no").toString()))-1) + "'),\n")
						
						.append("	 SYSDATETIME,								\n") //create_date
						.append("	 '" + jjjArray.get("modify_user_id") + "',	\n") //modify_user_id
						.append("	 '" + jjjArray.get("modify_reason") + "',	\n") //modify_reason
						.append("	 SYSDATETIME								\n") //modify_date
						.append(" 		,'" + jjjArray.get("member_key") + "' \n") //member_key_values
						.append("	);\n")
						.toString();
	            
				//// System.out.println(sql.toString());
				resultInt = super.excuteUpdate(con, sql.toString());
				if (resultInt < 0) {
					con.rollback();
					ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
					return resultInt;
				} else {
					ioParam.setMessage(resultInt + "건 " + MessageDefine.M_INSERT_RESULT);
				}
			}
			con.commit();
		} catch(Exception e) {
			LoggingWriter.setLogError("M909S140100E102()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M909S140100E102()","==== finally ===="+ e.getMessage());
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
			JSONArray jjArray = (JSONArray) jArray.get("param");
			System.out.println("데이터 묶음 개수 :::: " + jjArray.size());
			// 꺼낸 데이터의 값을 쿼리문에 집어넣는다. (데이터묶음 하나일땐 for문 생략)
			for(int i=0; i<jjArray.size(); i++) {
				JSONObject jjjArray = (JSONObject)jjArray.get(i);
				
				sql = new StringBuffer();
				sql.append("UPDATE tbm_code_book SET	\n")
				.append(" duration_date = to_char(TO_DATE('" + jjjArray.get("start_date") + "', 'YYYY-MM-DD')-1 , 'YYYY-MM-DD'),	\n")
//				.append(" 	member_key = 	'" + jjjArray.get("member_key") + "',		\n")
				.append(" modify_reason = '삭제',\n")
				.append(" delyn = 'Y'\n")
				
				.append("WHERE code_value = '" + jjjArray.get("code_value") + "'\n")
				
				// 13번째는 이전의 리비전코드가 들어온다.
				.append("	AND revision_no = '" + (Integer.parseInt((jjjArray.get("revision_no").toString())) + "'\n"))
				.append(" 	AND member_key = '" + jjjArray.get("member_key") + "' \n") //member_key_select, update, delete
				.toString();
				
				//// System.out.println(sql.toString());

				// super의 excuteUpdate는 3가지가 있다.
				// 첫째는 super.excuteUpdate(con, sql.toString(), v_paramArray)형태 이며,
				// PreparedStatement를 사용하기 위해 파라미터들을 배열에 담아 보내면 체크를 해서 수행하는 구조이다. 그리고
				// 두번째는 super.excuteUpdate(con, Vector)인데, 멀티 로우를 등록하기 위해 마련된 장치이다.
				// 세번째는 하나의 SQL을 String으로 받아서 처리하는 경우이다.
				// 현재 위의 SQL형태라면.. 당연히 1개의 로우에 해당되므로 세번째 메쏘드를 사용하는 것이 편하다.
				resultInt = super.excuteUpdate(con, sql.toString());
				if (resultInt < 0) {
					ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
					return resultInt;
				} else {
					ioParam.setMessage(resultInt + "건 " + MessageDefine.M_INSERT_RESULT);
				}
			}
			con.commit();
		} catch(Exception e) {
			LoggingWriter.setLogError("M909S140100E103()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M909S140100E103()","==== finally ===="+ e.getMessage());
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
	
	// vtbm_code_book 테이블의 구분코드 등록을 위한 쿼리
	public int E111(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));

			String sql = new StringBuilder()
					.append("INSERT INTO tbm_code_book (	\n")
					.append("		code_cd,				\n")
					.append("		code_value,				\n")
					.append("		code_name,				\n")
					.append("		revision_no,			\n")
					.append("		bigo,					\n")
					.append("		start_date,				\n")
					.append("		duration_date,			\n")
					.append("		create_user_id,			\n")
					.append("		order_index,			\n")
					.append("		create_date,			\n")
					.append("		modify_user_id,			\n")
					.append("		modify_reason,			\n")
					.append("		modify_date,			\n")
					.append(" 		member_key				\n")
					.append("	)							\n")
					.append("VALUES							\n")
					.append("	(							\n")
					.append("	 '" + jArray.get("CodeGroupGubun") + "',	\n") //code_cd
					.append("	 '" + jArray.get("CodeGroupGubun_000") + "',\n") //code_value
					.append("	 '" + jArray.get("CodeName") + "',			\n") //code_name
					.append("	 '" + jArray.get("RevisionNo") + "',		\n") //revision_no
					.append("	 '" + jArray.get("Bigo") + "',				\n") //bigo
					.append("	 '" + jArray.get("StartDate") + "',			\n") //start_date
					.append("	 '9999-12-31',								\n") //duration_date
					.append("	 '" + jArray.get("user_id") + "',			\n") //create_user_id
					.append("	 '0',										\n") //order_index
					.append("	 SYSDATETIME,								\n") //create_date
					.append("	 '" + jArray.get("user_id") + "',			\n") //modify_user_id
					.append("	 '최초작성',									\n") //modify_reason
					.append("	 SYSDATETIME								\n") //modify_date
					.append(" 		,'" + jArray.get("member_key") + "' 	\n") //member_key_values
					.append("	)											\n")
					.toString();

			resultInt = super.excuteUpdate(con, sql);
			
			if (resultInt < 0) {
				ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
			} else {
				ioParam.setMessage(resultInt + "건 " + MessageDefine.M_INSERT_RESULT);
			}
		} catch(Exception e) {
			LoggingWriter.setLogError("M909S140100E111()","==== SQL ERROR ===="+ e.getMessage() + "\n" + sql.toString());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M909S140100E111()","==== finally ===="+ e.getMessage());
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

	public int E194(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			System.out.println("JSONObject jArray rcvData="+ jArray.toString());
			// 클라이언트로 부터 받은 파라미터를 옮겨 담는다.
//			String rcvData = (String)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			// 클라이언트로 부터 받은 파라미터를 쪼개어서 배열에 담는다.
//			String[][] c_paramArray = CommonFunction.getConvString2DoubleArray(rcvData);

//			String[] CodeColumn ={"코드", "코드이름" ,"코드값","정열순서", "비고"} ;	
			String sql = new StringBuilder()
					.append("SELECT\n")
					.append("        code_cd,			\n")
					.append("        code_value,		\n")
					.append("        code_name,			\n")
					.append("        revision_no,		\n")
					.append("        bigo,				\n")
					.append("        start_date,		\n")
					.append("        duration_date,		\n")
					.append("        create_user_id,	\n")
					.append("        order_index,		\n")
					.append("        create_date,		\n")
					.append("        modify_user_id,	\n")
					.append("        modify_reason,		\n")
					.append("        modify_date		\n")
					.append("FROM\n")
					.append("        tbm_code_book\n")
					.append("WHERE order_index = 0\n")
					.append(" 	AND member_key = '" + jArray.get("member_key") + "' \n") //member_key_select, update, delete
					.toString();

			resultString = super.excuteQueryString(con, sql.toString());
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M909S140100E194()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M909S140100E194()","==== finally ===="+ e.getMessage());
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
	

		public int E195(InoutParameter ioParam){
			resultInt = EventDefine.E_DOEXCUTE_INIT;
			
			try {
				con = JDBCConnectionPool.getConnection();
				
				JSONObject jArray = new JSONObject();
				jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));

				String sql = new StringBuilder()
						.append("SELECT													\n")
						.append("        code_cd,										\n")
						.append("        code_value,									\n")
						.append("        code_name,										\n")
						.append("        revision_no,									\n")
						.append("        bigo,											\n")
						.append("        start_date,									\n")
						.append("        duration_date,									\n")
						.append("        create_user_id,								\n")
						.append("        order_index,									\n")
						.append("        create_date,									\n")
						.append("        modify_user_id,								\n")
						.append("        modify_reason,									\n")
						.append("        modify_date									\n")
						.append("FROM													\n")
						.append("        vtbm_code_book									\n")
						.append("WHERE SYSDATE BETWEEN start_date AND duration_date		\n")
						.append("  AND order_index = 0									\n")
						.append("  AND member_key = '" + jArray.get("member_key") + "' 	\n")
						.toString();
				
				resultString = super.excuteQueryString(con, sql);
			} catch(Exception e) {
				e.printStackTrace();
				LoggingWriter.setLogError("M909S140100E195()","==== SQL ERROR ===="+ e.getMessage());
				return EventDefine.E_DOEXCUTE_ERROR ;
		    } finally {
		    	if (Config.useDataSource) {
					try {
						if (con != null) con.close();
					} catch (Exception e) {
						LoggingWriter.setLogError("M909S140100E195()","==== finally ===="+ e.getMessage());
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

		public int E196(InoutParameter ioParam){
			resultInt = EventDefine.E_DOEXCUTE_INIT;
			
			try {
				con = JDBCConnectionPool.getConnection();
				
				JSONObject jArray = new JSONObject();
				jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
				System.out.println("JSONObject jArray rcvData="+ jArray.toString());
				
				// 클라이언트로 부터 받은 파라미터를 옮겨 담는다.
//				String rcvData = (String)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
				// 클라이언트로 부터 받은 파라미터를 쪼개어서 배열에 담는다.
//				String[][] c_paramArray = CommonFunction.getConvString2DoubleArray(rcvData);

//				String[] CodeColumn ={"코드", "코드이름" ,"코드값","정열순서", "비고"} ;	
				String sql = new StringBuilder()
						.append("SELECT\n")
						.append("        code_cd,			\n")
						.append("        code_value,		\n")
						.append("        code_name,			\n")
						.append("        revision_no,		\n")
						.append("        bigo,				\n")
						.append("        start_date,		\n")
						.append("        duration_date,		\n")
						.append("        create_user_id,	\n")
						.append("        order_index,		\n")
						.append("        create_date,		\n")
						.append("        modify_user_id,	\n")
						.append("        modify_reason,		\n")
						.append("        modify_date		\n")
						.append("FROM						\n")
						.append("	tbm_code_book			\n")
						.append("WHERE code_cd LIKE '" + jArray.get("CODE_CD") + "%' \n")
						.append("AND order_index > 0 \n")
						.append(" 	AND member_key = '" + jArray.get("member_key") + "' \n") //member_key_select, update, delete
						.append("ORDER BY code_value ASC \n")
						.toString();
				

				resultString = super.excuteQueryString(con, sql.toString());
			} catch(Exception e) {
				e.printStackTrace();
				LoggingWriter.setLogError("M909S140100E196()","==== SQL ERROR ===="+ e.getMessage());
				return EventDefine.E_DOEXCUTE_ERROR ;
		    } finally {
		    	if (Config.useDataSource) {
					try {
						if (con != null) con.close();
					} catch (Exception e) {
						LoggingWriter.setLogError("M909S140100E196()","==== finally ===="+ e.getMessage());
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

		public int E197(InoutParameter ioParam){
			resultInt = EventDefine.E_DOEXCUTE_INIT;
			
			try {
				con = JDBCConnectionPool.getConnection();
				
				JSONObject jArray = new JSONObject();
				jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
				System.out.println("JSONObject jArray rcvData="+ jArray.toString());
				
				// 클라이언트로 부터 받은 파라미터를 옮겨 담는다.
//				String rcvData = (String)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
				// 클라이언트로 부터 받은 파라미터를 쪼개어서 배열에 담는다.
//				String[][] c_paramArray = CommonFunction.getConvString2DoubleArray(rcvData);

//				String[] CodeColumn ={"코드", "코드이름" ,"코드값","정열순서", "비고"} ;	
				String sql = new StringBuilder()
						.append("SELECT\n")
						.append("        code_cd,			\n")
						.append("        code_value,		\n")
						.append("        code_name,			\n")
						.append("        revision_no,		\n")
						.append("        bigo,				\n")
						.append("        start_date,		\n")
						.append("        duration_date,		\n")
						.append("        create_user_id,	\n")
						.append("        order_index,		\n")
						.append("        create_date,		\n")
						.append("        modify_user_id,	\n")
						.append("        modify_reason,		\n")
						.append("        modify_date		\n")
						.append("FROM						\n")
						.append("	vtbm_code_book			\n")
						.append("WHERE code_cd LIKE '" + jArray.get("CODE_CD") + "%' 	\n")
						.append("AND order_index > 0 									\n")
						.append("AND SYSDATE BETWEEN start_date AND duration_date\n")
						.append(" 	AND member_key = '" + jArray.get("member_key") + "' \n") //member_key_select, update, delete
						.append("ORDER BY code_value ASC \n")
						.toString();
				

				resultString = super.excuteQueryString(con, sql.toString());
			} catch(Exception e) {
				e.printStackTrace();
				LoggingWriter.setLogError("M909S140100E197()","==== SQL ERROR ===="+ e.getMessage());
				return EventDefine.E_DOEXCUTE_ERROR ;
		    } finally {
		    	if (Config.useDataSource) {
					try {
						if (con != null) con.close();
					} catch (Exception e) {
						LoggingWriter.setLogError("M909S140100E197()","==== finally ===="+ e.getMessage());
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
		
	public int E204(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			
			String sql = new StringBuilder()
					.append("SELECT\n")
					.append("        code_cd,			\n")
					.append("        code_value,		\n")
					.append("        code_name,			\n")
					.append("        revision_no,		\n")
					.append("        bigo,				\n")
					.append("        start_date,		\n")
					.append("        duration_date,		\n")
					.append("        create_user_id,	\n")
					.append("        order_index,		\n")
					.append("        create_date,		\n")
					.append("        modify_user_id,	\n")
					.append("        modify_reason,		\n")
					.append("        modify_date		\n")
					.append("FROM						\n")
					.append("	tbm_code_book			\n")
					.append("WHERE code_value = '" + jArray.get("CODE_VALUE") + "'		\n")
					.append("	AND revision_no = '" + jArray.get("REVISION_NO") + "'	\n")
					.append(" 	AND member_key = '" + jArray.get("member_key") + "' 	\n")
					.toString();

			resultString = super.excuteQueryString(con, sql.toString());
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M909S140100E204()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M909S140100E204()","==== finally ===="+ e.getMessage());
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


//CodeBookView.jsp
	public int E214(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			// 클라이언트로 부터 받은 파라미터를 옮겨 담는다.
			String rcvData = (String)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			// 클라이언트로 부터 받은 파라미터를 쪼개어서 배열에 담는다.
			String[][] c_paramArray = CommonFunction.getConvString2DoubleArray(rcvData);

//			String[] CodeColumn ={"코드", "코드이름" ,"코드값","정열순서", "비고"} ;	
			String sql = new StringBuilder()
					.append("SELECT\n")
					.append("        code_cd,			\n")
					.append("        code_value,		\n")
					.append("        code_name,			\n")
					.append("        revision_no,		\n")
					.append("        bigo,				\n")
					.append("        start_date,		\n")
					.append("        duration_date,		\n")
					.append("        create_user_id,	\n")
					.append("        order_index,		\n")
					.append("        create_date,		\n")
					.append("        modify_user_id,	\n")
					.append("        modify_reason,		\n")
					.append("        modify_date		\n")
					.append("FROM\n")
					.append("        vtbm_code_book\n")
					.append("WHERE order_index = 0;\n")
					.append(" 	AND member_key = '" + c_paramArray[0][1] + "' \n") //member_key_select, update, delete
					.toString();

			resultString = super.excuteQueryString(con, sql.toString());
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M909S140100E214()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M909S140100E214()","==== finally ===="+ e.getMessage());
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
