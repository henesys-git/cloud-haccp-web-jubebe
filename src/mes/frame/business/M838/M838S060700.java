package mes.frame.business.M838;

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
import mes.frame.common.QueueProcessing;
import mes.frame.database.JDBCConnectionPool;
import mes.frame.database.SqlAdapter;
import mes.frame.serviceinterface.InoutParameter;
import mes.frame.serviceinterface.LoggingWriter;
import mes.frame.util.CommonFunction;


public class M838S060700 extends SqlAdapter{
	Connection con = null;
	PreparedStatement pstmt = null;
	String resultString = "";
	int resultInt = -1;
	StringBuffer sql = new StringBuffer();
	QueueProcessing Queue = new QueueProcessing();
	
	String[][] v_paramArray = new String[0][0]; 
	Class[] optClass = null;
	Object[] optObj = null;
	Object obj = null;
	
	public M838S060700(){
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
			
			Method method = M838S060700.class.getMethod(event,optClass);
			LoggingWriter.setLogDebug(M838S060700.class.getName(),"==== " + event + " EventMethod Create Success ====");

			obj = method.invoke(M838S060700.class.newInstance(),optObj);
			doExcute_result = CommonFunction.getInt(obj.toString());
			
	    } catch (Exception ex) {
	    	doExcute_result = EventDefine.E_DOEXCUTE_INIT;
			ioParam.setMessage(MessageDefine.M_NO_EVENTID);
			LoggingWriter.setLogError(M838S060700.class.getName(),"==== EventID Not define : EVENT ID [ " + ioParam.getEventID() + "]");
	    } finally {
	    	obj = null;
			optClass = null;
			optObj = null;
	    }
	    long endTime = System.currentTimeMillis();
		long runningTime = endTime - startTime;
		LoggingWriter.setLogAll(M838S060700.class.getName(),"==== Query [수행시간  : " + runningTime + " ms]");
		
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
    		JSONArray jjArray = (JSONArray) jArray.get("param");
			
			for(int i=0; i<jjArray.size(); i++) {	
				JSONObject jjjArray = (JSONObject)jjArray.get(i); // i번째 데이터묶음
				
				String sql = new StringBuilder()
					.append("MERGE INTO haccp_part_company_list mm																								\n")
					.append("USING (																															\n")
					.append("	SELECT																															\n")
					.append("		'" + jjjArray.get("part_code_value")				+ "' AS part_code_value,												\n")
 					.append("		'" + jjjArray.get("part_name_value")				+ "' AS part_name_value,												\n")
 					.append("		'" + jjjArray.get("company_code_value")				+ "' AS company_code_value,												\n")
 					.append("		'" + jjjArray.get("company_name_value")				+ "' AS company_name_value,												\n")
 					.append("		'" + jjjArray.get("company_address_value")			+ "' AS company_address_value,											\n")
 					.append("		'" + jjjArray.get("company_revision_number_value")	+ "' AS company_revision_number_value,									\n")
 					.append("		'" + jjjArray.get("member_key")						+ "' AS member_key,														\n")
 					.append("		'" + jjjArray.get("part_check_value")				+ "' AS part_check_value,												\n")
 					.append("		'" + jjjArray.get("check_date")						+ "' AS check_date														\n")
					.append("	FROM db_root ) mQ																												\n")
					.append("ON ( mm.part_code_value = mQ.part_code_value			\n")
					.append("	AND mm.company_code_value = mQ.company_code_value	\n")
					.append("	AND mm.member_key = mQ.member_key					\n")
					.append("	AND mm.check_date = mQ.check_date )					\n")
					.append("WHEN MATCHED THEN																\n")
					.append("	UPDATE SET																	\n")
					.append("		mm.part_code_value					= mQ.part_code_value,				\n")
					.append("		mm.part_name_value					= mQ.part_name_value,				\n")
					.append("		mm.company_code_value				= mQ.company_code_value,			\n")
					.append("		mm.company_name_value				= mQ.company_name_value,			\n")
					.append("		mm.company_address_value			= mQ.company_address_value,			\n")
					.append("		mm.company_revision_number_value	= mQ.company_revision_number_value,	\n")
					.append("		mm.member_key						= mQ.member_key,					\n")
					.append("		mm.part_check_value					= mQ.part_check_value,				\n")
					.append("		mm.check_date						= mQ.check_date						\n")
					.append("WHEN NOT MATCHED THEN						\n")
					.append("	INSERT (								\n")
					.append("		mm.part_code_value,					\n")
					.append("		mm.part_name_value,					\n")
					.append("		mm.company_code_value,				\n")
					.append("		mm.company_name_value,				\n")
					.append("		mm.company_address_value,			\n")
					.append("		mm.company_revision_number_value,	\n")
					.append("		mm.member_key,						\n")
					.append("		mm.part_check_value,				\n")
					.append("		mm.check_date						\n")
					.append("		) VALUES (							\n")
					.append("		mQ.part_code_value,					\n")
					.append("		mQ.part_name_value,					\n")
					.append("		mQ.company_code_value,				\n")
					.append("		mQ.company_name_value,				\n")
					.append("		mQ.company_address_value,			\n")
					.append("		mQ.company_revision_number_value,	\n")
					.append("		mQ.member_key,						\n")
					.append("		mQ.part_check_value,				\n")
					.append("		mQ.check_date						\n")
					.append("	)										\n")
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
			LoggingWriter.setLogError("M838S060700E101()","==== SQL ERROR ===="+ e.getMessage());
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

	public int E102(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject(); // JSONObject 선언
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));

			String sql = new StringBuilder()
					.append("UPDATE																	\n")
					.append("	haccp_part_company_list												\n")
					.append("SET																	\n")
					.append("	part_check_value = '" + jArray.get("part_check_value") + "'			\n")
					.append("WHERE																	\n")
					.append("	part_code_value = '" + jArray.get("part_code_value") + "'			\n")
					.append("	AND company_code_value = '" + jArray.get("company_code_value") + "'	\n")
					.append("	AND check_date = '" + jArray.get("check_date") + "'					\n")
					.append("	AND member_key = '" + jArray.get("member_key") + "'					\n")
					.toString();


			// super의 excuteUpdate는 3가지가 있다.
			// 첫째는 super.excuteUpdate(con, sql.toString(), v_paramArray)형태 이며,
			// PreparedStatement를 사용하기 위해 파라미터들을 배열에 담아 보내면 체크를 해서 수행하는 구조이다. 그리고
			// 두번째는 super.excuteUpdate(con, Vector)인데, 멀티 로우를 등록하기 위해 마련된 장치이다.
			// 세번째는 하나의 SQL을 String으로 받아서 처리하는 경우이다.
			// 현재 위의 SQL형태라면.. 당연히 1개의 로우에 해당되므로 세번째 메쏘드를 사용하는 것이 편하다.
			resultInt = super.excuteUpdate(con, sql.toString());
			if (resultInt < 0) {
				ioParam.setMessage(MessageDefine.M_UPDATE_FAILED);
				return resultInt;
			} else {
				ioParam.setMessage(resultInt + "건 " + MessageDefine.M_UPDATE_RESULT);
			}
		} catch(Exception e) {
			LoggingWriter.setLogError("M838S060700E102()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M838S060700E102()","==== finally ===="+ e.getMessage());
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
	
	public int E104(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
//			// 클라이언트로 부터 받은 파라미터를 옮겨 담는다.
//			String rcvData = (String)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));

			String sql = new StringBuilder()
					.append("SELECT													\n")
					.append("	part_code_value,									\n")
					.append("	part_name_value,									\n")
					.append("	company_code_value,									\n")
					.append("	company_name_value,									\n")
					.append("	company_address_value,								\n")
					.append("	part_check_value,									\n")
					.append("	check_date,											\n")
					.append("	member_key											\n")
					.append("FROM													\n")
					.append("	haccp_part_company_list								\n")
					.append("WHERE													\n")
					.append("	member_key = '" + jArray.get("member_key") + "'		\n")
					.append("	AND check_date = '" + jArray.get("check_date") + "'	\n")
					.toString();


			String ActionCommand = ioParam.getActionCommand();
			if(ActionCommand.startsWith("doQueryTableFieldName")) {
				resultString = super.excuteQueryStringTableFieldName(con, sql.toString());
			}
			else {;
				resultString = super.excuteQueryString(con, sql.toString());
			}
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M838S060700E104()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M838S060700E104()","==== finally ===="+ e.getMessage());
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
	
	// 원재료 조회
	public int E904(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
//			// 클라이언트로 부터 받은 파라미터를 옮겨 담는다.
//			String rcvData = (String)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));

			String sql = new StringBuilder()
					.append("SELECT DISTINCT\n")
					.append("	C.part_cd,\n")
					.append("	C.part_nm,\n")
					.append("	D.cust_cd,\n")
					.append("	D.cust_nm,\n")
					.append("	D.address,\n")
					.append("	D.revision_no,\n")
					.append("	A.member_key\n")
					.append("FROM\n")
					.append("   tbi_balju_list A INNER JOIN tbi_balju B \n")
					.append("   ON A.balju_no = B.balju_no\n")
					.append("   INNER JOIN tbm_part_list C \n")
					.append("   ON A.part_cd = C.part_cd\n")
					.append("   AND A.part_cd_rev=C.revision_no\n")
					.append("   INNER JOIN tbm_customer D \n")
					.append("   ON B.cust_cd = D.cust_cd\n")
					.append("   AND B.cust_cd_rev = D.revision_no\n")
					.append("ORDER BY D.cust_nm ASC, C.part_cd ASC;\n")
					.toString();

			String ActionCommand = ioParam.getActionCommand();
			if(ActionCommand.startsWith("doQueryTableFieldName")) {
				resultString = super.excuteQueryStringTableFieldName(con, sql.toString());
			}
			else {;
				resultString = super.excuteQueryString(con, sql.toString());
			}
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M838S060700E904()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M838S060700E904()","==== finally ===="+ e.getMessage());
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
	
	public int E914(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
//			// 클라이언트로 부터 받은 파라미터를 옮겨 담는다.
//			String rcvData = (String)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));

			String sql = new StringBuilder()
					.append("SELECT\n")
					.append("	part_code_value,\n")
					.append("	part_name_value,\n")
					.append("	company_code_value,\n")
					.append("	company_name_value,\n")
					.append("	company_address_value,\n")
					.append("	part_check_value\n")
					.append("FROM\n")
					.append("	haccp_part_company_list\n")
					.append("WHERE\n")
					.append("	part_code_value = '" + jArray.get("part_code_value") + "'		\n")
					.append("	AND company_code_value = '" + jArray.get("company_code_value") + "'		\n")
					.append("	AND check_date = '" + jArray.get("check_date") + "'		\n")
					.append("	AND member_key = '" + jArray.get("member_key") + "'		\n")
					.toString();


			String ActionCommand = ioParam.getActionCommand();
			if(ActionCommand.startsWith("doQueryTableFieldName")) {
				resultString = super.excuteQueryStringTableFieldName(con, sql.toString());
			}
			else {;
				resultString = super.excuteQueryString(con, sql.toString());
			}
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M838S060700E914()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M838S060700E914()","==== finally ===="+ e.getMessage());
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
	
	public int E995(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
//			// 클라이언트로 부터 받은 파라미터를 옮겨 담는다.
//			String rcvData = (String)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));

			String sql = new StringBuilder()
					.append("SELECT													\n")
					.append("	cust_nm,											\n")
					.append("	address,											\n")
					.append("	MAX(revision_no) AS MRN								\n")
					.append("FROM													\n")
					.append("	tbm_customer										\n")
					.append("WHERE													\n")
					.append("	cust_cd = '" + jArray.get("cust_cd") + "'			\n")
					.append("	AND member_key = '" + jArray.get("member_key") + "'	\n")
					.append("GROUP BY cust_cd										\n")
					.toString();

			String ActionCommand = ioParam.getActionCommand();
			if(ActionCommand.startsWith("doQueryTableFieldName")) {
				resultString = super.excuteQueryStringTableFieldName(con, sql.toString());
			}
			else {;
				resultString = super.excuteQueryString(con, sql.toString());
			}
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M838S060700E995()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M838S060700E995()","==== finally ===="+ e.getMessage());
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