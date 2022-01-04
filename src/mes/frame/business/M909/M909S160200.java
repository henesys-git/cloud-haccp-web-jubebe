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


public class M909S160200 extends SqlAdapter{
	Connection con = null;
	PreparedStatement pstmt = null;
	String resultString = "";
	int resultInt = -1;
	StringBuffer sql = new StringBuffer();
	
	String[][] v_paramArray = new String[0][0]; 
	Class[] optClass = null;
	Object[] optObj = null;
	Object obj = null;
	
	public M909S160200(){
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
			
			Method method = M909S160200.class.getMethod(event,optClass);
			LoggingWriter.setLogDebug(M909S160200.class.getName(),"==== " + event + " EventMethod Create Success ====");

			obj = method.invoke(M909S160200.class.newInstance(),optObj);
			doExcute_result = CommonFunction.getInt(obj.toString());
			
	    } catch (Exception ex) {
	    	doExcute_result = EventDefine.E_DOEXCUTE_INIT;
			ioParam.setMessage(MessageDefine.M_NO_EVENTID);
			LoggingWriter.setLogError(M909S160200.class.getName(),"==== EventID Not define : EVENT ID [ " + ioParam.getEventID() + "]");
	    } finally {
	    	obj = null;
			optClass = null;
			optObj = null;
	    }
	    long endTime = System.currentTimeMillis();
		long runningTime = endTime - startTime;
		LoggingWriter.setLogAll(M909S160200.class.getName(),"==== Query [수행시간  : " + runningTime + " ms]");
		
		return doExcute_result;
	}
	
	public int E101(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject(); // JSONObject 선언
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			
			
			sql = new StringBuffer();
			sql.append("INSERT INTO haccp_limit_info											\n");
			sql.append("(																		\n");
			sql.append("	member_key,															\n");
			sql.append("	ccp_no,																\n");
			sql.append("	ccp_type,															\n");
			sql.append("	min_value,															\n");
			sql.append("	max_value,															\n");
			sql.append("	standard_value,														\n");
			sql.append("	bigo,																\n");
			sql.append("	start_date															\n");
			sql.append(")																		\n");
			sql.append("VALUES																	\n");
			sql.append("(																		\n");
			sql.append("	'" + jArray.get("member_key") + "',									\n");
			sql.append("	'" + jArray.get("ccp_no") + "',										\n");
			sql.append("	'" + jArray.get("ccp_type") + "',									\n");
			sql.append("	'" + jArray.get("min_value") + "',									\n");
			sql.append("	'" + jArray.get("max_value") + "',									\n");
			sql.append("	'" + jArray.get("standard_value") + "',								\n");
			sql.append("	'" + jArray.get("bigo") + "',										\n");
			sql.append("	'" + jArray.get("start_date") + "'									\n");
			sql.append(");																		\n");

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
		} catch(Exception e) {
			LoggingWriter.setLogError("M909S160200E101()","==== SQL ERROR ===="+ e.getMessage() + "\n" + sql.toString());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M909S160200E101()","==== finally ===="+ e.getMessage());
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
			
			JSONObject jArray = new JSONObject(); // JSONObject 선언
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));

			/*
			sql = new StringBuffer();
			sql.append("UPDATE haccp_limit_info SET										\n");
			sql.append("	ccp_type		= '" + jArray.get("ccp_type") + "',			\n");
			sql.append("	min_value		= '" + jArray.get("min_value") + "',		\n");
			sql.append("	max_value		= '" + jArray.get("max_value") + "',		\n");
			sql.append("	standard_value	= '" + jArray.get("standard_value") + "',	\n");
			sql.append("	bigo			= '" + jArray.get("bigo") + "'				\n");
			sql.append("WHERE member_key	= '" + jArray.get("member_key") + "'		\n");
			sql.append("AND ccp_no			= '" + jArray.get("ccp_no") + "'			\n");
			sql.append("AND ccp_seq_no		= '" + jArray.get("ccp_seq_no") + "'		\n");
			*/

			
			
			// 먼저 이전 리비전의 적용종료일자를 새로운 적용시작일자에서 하루를 뺀 날짜로 변경한다.
			// 만약 새로운 리비전의 적용시작일자 = 이전 리비전의 적용시작일자 라면 이전 리비전의 적용종료일자를 적용시작일자와 같은 날짜로 변경한다.
//			String sqlPre = new StringBuilder()
//					.append("UPDATE haccp_limit_info SET																				\n")
//					.append("	duration_date =																							\n")
//					.append("		CASE																								\n")
//					.append("			WHEN start_date = '" + jArray.get("after_start_date") + "' THEN start_date						\n")
//					.append("			ELSE TO_CHAR(TO_DATE( '" + jArray.get("after_start_date") + "','YYYY-MM-DD')-1, 'YYYY-MM-DD')	\n")
//					.append("		END																									\n")
//					.append("WHERE member_key	= '" + jArray.get("member_key") + "'													\n")
//					.append("	AND ccp_no		= '" + jArray.get("ccp_no") + "'														\n")
//					.toString();
			
			String sql = new StringBuilder()
					.append("UPDATE haccp_limit_info\n")
					.append("SET min_value = "+jArray.get("min_value")+"\n")
					.append("	  ,max_value = "+jArray.get("max_value")+"\n")
					.append("	  , standard_value = "+jArray.get("standard_value")+"\n")
					.append("	  , bigo = '"+jArray.get("bigo")+"'\n")
					.append("WHERE \n")
					.append("member_key = '"+jArray.get("member_key")+"' AND\n")
					.append("ccp_no = '"+jArray.get("ccp_no")+"' AND\n")
					.append("ccp_type = '"+jArray.get("ccp_type")+"'\n")
					.toString();

			con.setAutoCommit(true);
			
			System.out.println(sql.toString());
			
			resultInt = super.excuteUpdate(con, sql.toString());
			if (resultInt < 0) {
				con.rollback();
				ioParam.setMessage(MessageDefine.M_UPDATE_FAILED);
				return resultInt;
			} else {
				ioParam.setMessage(resultInt + "건 " + MessageDefine.M_UPDATE_RESULT);
			}
			
		} catch(Exception e) {
			LoggingWriter.setLogError("M909S160200E102()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M909S160200E102()","==== finally ===="+ e.getMessage());
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
			
			JSONObject jArray = new JSONObject(); // JSONObject 선언
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));

			sql = new StringBuffer();
			sql.append("DELETE FROM haccp_limit_info								\n");
			sql.append("WHERE member_key	= '" + jArray.get("member_key") + "'	\n");
			sql.append("AND ccp_no			= '" + jArray.get("ccp_no") + "'		\n");
			sql.append("AND ccp_seq_no		= '" + jArray.get("ccp_seq_no") + "'	\n");

			resultInt = super.excuteUpdate(con, sql.toString());
			if (resultInt < 0) {
				ioParam.setMessage(MessageDefine.M_DELETE_FAILED);
				return resultInt;
			} else {
				ioParam.setMessage(resultInt + "건 " + MessageDefine.M_DELETE_RESULT);
			}
		} catch(Exception e) {
			LoggingWriter.setLogError("M909S160200E103()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M909S160200E103()","==== finally ===="+ e.getMessage());
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

	// Revision No 상관 없이 모든 데이터 조회
	public int E104(InoutParameter ioParam) {
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			System.out.println("JSONObject jArray rcvData="+ jArray.toString());			
			
			String sql = new StringBuilder()
					.append("SELECT														\n")
					.append("	ccp_no,													\n")
					.append("	ccp_seq_no,												\n")
					.append("	ccp_type,												\n")
					.append("	code_name,												\n")
					.append("	A.revision_no,											\n")
					.append("	min_value,												\n")
					.append("	max_value,												\n")
					.append("	standard_value,											\n")
					.append("	A.bigo,													\n")
					.append("	A.start_date,											\n")
					.append("	A.duration_date,										\n")
					.append("	A.member_key											\n")
					.append("FROM haccp_limit_info A									\n")
					.append("	INNER JOIN v_censor_data_type B							\n")
					.append("	ON A.ccp_type = B.code_value							\n")
					.append("	AND A.member_key = B.member_key							\n")
					.append("	AND A.member_key = B.member_key							\n")
					.append("WHERE A.member_key = '" + jArray.get("member_key") + "'	\n") //member_key_select, update, delete
//					.append("AND A.revision_no = '" + jArray.get("revision_no") + "'	\n")
					.append("ORDER BY ccp_no											\n")
					.toString();

			

			
			
			resultString = super.excuteQueryString(con, sql.toString());
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M909S160200E104()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M909S160200E104()","==== finally ===="+ e.getMessage());
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
	
	// 가장 최근의 Revision No 데이터만 조회
		public int E105(InoutParameter ioParam) {
			resultInt = EventDefine.E_DOEXCUTE_INIT;
			
			try {
				con = JDBCConnectionPool.getConnection();
				
				JSONObject jArray = new JSONObject();
				jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
				System.out.println("JSONObject jArray rcvData="+ jArray.toString());			
				
//				String sql = new StringBuilder()
//						.append("SELECT																		\n")
//						.append("	ccp_no,																	\n")
//						.append("	ccp_seq_no,																\n")
//						.append("	ccp_type,																\n")
//						.append("	code_name,																\n")
//						.append("	A.revision_no,															\n")
//						.append("	min_value,																\n")
//						.append("	max_value,																\n")
//						.append("	standard_value,															\n")
//						.append("	A.bigo,																	\n")
//						.append("	A.start_date,															\n")
//						.append("	A.duration_date,														\n")
//						.append("	A.member_key															\n")
//						.append("FROM haccp_limit_info A													\n")
//						.append("	INNER JOIN v_censor_data_type B											\n")
//						.append("	ON A.ccp_type = B.code_value											\n")
//						.append("	AND A.member_key = B.member_key											\n")
//						.append("WHERE A.member_key = '" + jArray.get("member_key") + "'					\n") //member_key_select, update, delete
////						.append("AND A.revision_no = '" + jArray.get("revision_no") + "'					\n")
//						.append("AND A.start_date != A.duration_date										\n")
//						.append("AND TO_CHAR(SYSDATE,'YYYY-MM-DD') BETWEEN A.start_date AND A.duration_date	\n")
//						.append("ORDER BY ccp_no															\n")
//						.toString();

				String sql = new StringBuilder()
						.append("SELECT\n")
						.append("        C.ccp_no,\n")
						.append("        C.ccp_name,\n")
						.append("        C.ccp_type,\n")
						.append("        code_name,\n")
						.append("        min_value,\n")
						.append("        max_value,\n")
						.append("        standard_value,\n")
						.append("        A.bigo,\n")
						.append("        A.start_date,\n")
						.append("        A.duration_date,\n")
						.append("        A.member_key\n")
						.append("FROM haccp_limit_info A\n")
						.append("        INNER JOIN v_censor_data_type B\n")
						.append("        ON A.ccp_type = B.code_value\n")
						.append("        AND A.member_key = B.member_key\n")
						.append("		INNER JOIN haccp_ccp_info C\n")
						.append("		ON A.ccp_no =  C.ccp_no\n")
						.append("		AND A.member_key = C.member_key\n")						
						.append("WHERE A.member_key = '" + jArray.get("member_key") + "'	\n") //member_key_select, update, delete
						.append("AND A.start_date != A.duration_date\n")
						.append("AND TO_CHAR(SYSDATE,'YYYY-MM-DD') BETWEEN A.start_date AND A.duration_date\n")
						.append("ORDER BY A.ccp_no\n")
						.toString();
				
				
				
				
				resultString = super.excuteQueryString(con, sql.toString());
			} catch(Exception e) {
				e.printStackTrace();
				LoggingWriter.setLogError("M909S160200E105()","==== SQL ERROR ===="+ e.getMessage());
				return EventDefine.E_DOEXCUTE_ERROR ;
		    } finally {
		    	if (Config.useDataSource) {
					try {
						if (con != null) con.close();
					} catch (Exception e) {
						LoggingWriter.setLogError("M909S160200E105()","==== finally ===="+ e.getMessage());
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

	public int E204(InoutParameter ioParam) {
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

			sql = new StringBuffer();
			sql.append("SELECT													\n"); 
			sql.append("	ccp_no,												\n");
//			sql.append("	ccp_seq_no,											\n");
			sql.append("	ccp_type,											\n");
//			sql.append("	revision_no,										\n");
			sql.append("	min_value,											\n");
			sql.append("	max_value,											\n");
			sql.append("	standard_value,										\n");
			sql.append("	start_date,											\n");
			sql.append("	duration_date,										\n");
			sql.append("	bigo												\n");
			sql.append("FROM haccp_limit_info									\n");  
			sql.append("WHERE member_key = '" + jArray.get("member_key") + "'	\n"); //member_key_select, update, delete
			sql.append("AND ccp_no = '" + jArray.get("ccp_no") + "'				\n");

			resultString = super.excuteQueryString(con, sql.toString());
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M909S160200E204()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M909S160200E204()","==== finally ===="+ e.getMessage());
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
	public int E994(InoutParameter ioParam) {
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

			sql = new StringBuffer();
			sql.append("SELECT max(ccp_seq_no)									\n"); 
			sql.append("FROM haccp_limit_info									\n");
			sql.append("WHERE member_key = '" + jArray.get("member_key") + "'	\n");
			sql.append("AND ccp_no = '" + jArray.get("ccp_no") + "'				\n");

			resultString = super.excuteQueryString(con, sql.toString());
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M909S160200E994()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M909S160200E994()","==== finally ===="+ e.getMessage());
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