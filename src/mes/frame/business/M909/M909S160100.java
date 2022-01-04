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


public class M909S160100 extends SqlAdapter{
	Connection con = null;
	PreparedStatement pstmt = null;
	String resultString = "";
	int resultInt = -1;
	StringBuffer sql = new StringBuffer();
	
	String[][] v_paramArray = new String[0][0]; 
	Class[] optClass = null;
	Object[] optObj = null;
	Object obj = null;
	
	public M909S160100(){
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
			
			Method method = M909S160100.class.getMethod(event,optClass);
			LoggingWriter.setLogDebug(M909S160100.class.getName(),"==== " + event + " EventMethod Create Success ====");

			obj = method.invoke(M909S160100.class.newInstance(),optObj);
			doExcute_result = CommonFunction.getInt(obj.toString());
			
	    } catch (Exception ex) {
	    	doExcute_result = EventDefine.E_DOEXCUTE_INIT;
			ioParam.setMessage(MessageDefine.M_NO_EVENTID);
			LoggingWriter.setLogError(M909S160100.class.getName(),"==== EventID Not define : EVENT ID [ " + ioParam.getEventID() + "]");
	    } finally {
	    	obj = null;
			optClass = null;
			optObj = null;
	    }
	    long endTime = System.currentTimeMillis();
		long runningTime = endTime - startTime;
		LoggingWriter.setLogAll(M909S160100.class.getName(),"==== Query [수행시간  : " + runningTime + " ms]");
		
		return doExcute_result;
	}
	// CCP 정보 등록
	public int E101(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject(); // JSONObject 선언
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			
			
			sql = new StringBuffer();
			sql.append("INSERT INTO haccp_ccp_info	\n");
			sql.append("(							\n");
			sql.append("	censor_no,				\n");
			sql.append("	censor_channel,			\n");
//			sql.append("	censor_name,			\n");
			sql.append("	ccp_no,					\n");
			sql.append("	ccp_name,				\n");
			sql.append("	ccp_type,				\n");
			sql.append("	ccp_value,				\n");
			sql.append("	ccp_yn,				\n");
			sql.append("	get_auto_yn,				\n");
			sql.append("	temp_record,				\n");
			sql.append("	monitor_yn,				\n");
			sql.append("	member_key				\n");
			sql.append(")							\n");
			sql.append("VALUES										\n");
			sql.append("(											\n");
			sql.append("	'" + jArray.get("censor_no") + "',		\n");
			sql.append("	'" + jArray.get("censor_channel") + "',	\n");
//			sql.append("	'" + jArray.get("censor_name") + "',	\n");
			sql.append("	'" + jArray.get("ccp_no") + "',			\n");
			sql.append("	'" + jArray.get("ccp_name") + "',		\n");
			sql.append("	'" + jArray.get("ccp_type") + "',		\n");
			sql.append("	'" + jArray.get("ccp_value") + "',		\n");
			sql.append("	'" + jArray.get("ccp_yn") + "',		\n");
			sql.append("	'" + jArray.get("get_auto_yn") + "',		\n");
			sql.append("	'" + jArray.get("record_yn") + "',		\n");
			sql.append("	'" + jArray.get("monitor_yn") + "',		\n");
			sql.append("	'" + jArray.get("member_key") + "'		\n");
			sql.append(")											\n");

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
			LoggingWriter.setLogError("M909S160100E101()","==== SQL ERROR ===="+ e.getMessage() + "\n" + sql.toString());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M909S160100E101()","==== finally ===="+ e.getMessage());
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
	// CCP 정보 수정
	public int E102(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject(); // JSONObject 선언
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));

			sql = new StringBuffer();
			sql.append("UPDATE haccp_ccp_info SET										\n");
			sql.append("	ccp_name		= '" + jArray.get("ccp_name") + "',			\n");
			sql.append("	ccp_type		= '" + jArray.get("ccp_type") + "',			\n");
			sql.append("	ccp_value		= '" + jArray.get("ccp_value") + "',			\n");
			sql.append("	ccp_yn			= '" + jArray.get("ccp_yn") + "',			\n");
			sql.append("	get_auto_yn		= '" + jArray.get("get_auto_yn") + "',			\n");
			sql.append("	monitor_yn		= '" + jArray.get("monitor_yn") + "',			\n");
			sql.append("	temp_record		= '" + jArray.get("record_yn") + "'			\n");
			sql.append("WHERE member_key	= '" + jArray.get("member_key") + "'		\n");
			sql.append("AND ccp_no			= '" + jArray.get("ccp_no") + "'			\n");
			sql.append("AND censor_no		= '" + jArray.get("censor_no") + "'			\n");
			sql.append("AND censor_channel	= '" + jArray.get("censor_channel") + "'	\n");

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
		} catch(Exception e) {
			LoggingWriter.setLogError("M909S160100E102()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M909S160100E102()","==== finally ===="+ e.getMessage());
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
	// CCP 정보 삭제
	public int E103(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject(); // JSONObject 선언
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));

			sql = new StringBuffer();
			sql.append("DELETE FROM haccp_ccp_info										\n");
			sql.append("WHERE member_key	= '" + jArray.get("member_key") + "'		\n");
			sql.append("AND ccp_no			= '" + jArray.get("ccp_no") + "'			\n");
			sql.append("AND censor_no		= '" + jArray.get("censor_no") + "'			\n");
			sql.append("AND censor_channel	= '" + jArray.get("censor_channel") + "'	\n");

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
		} catch(Exception e) {
			LoggingWriter.setLogError("M909S160100E103()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M909S160100E103()","==== finally ===="+ e.getMessage());
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
	// CCP 정보 조회
	public int E104(InoutParameter ioParam) {
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			System.out.println("JSONObject jArray rcvData="+ jArray.toString());
			
			
			String sql = new StringBuilder()
					.append("SELECT														\n")
					.append("	censor_no,												\n")
					.append("	censor_channel,											\n")
					.append("	ccp_no,													\n")
					.append("	ccp_name,												\n")
					.append("	ccp_type,												\n")
					.append("	code_name,												\n")
					.append("	ccp_value,												\n")
					.append("	ccp_yn,												\n")
					.append("	get_auto_yn,												\n")
					.append("	A.member_key											\n")
					.append("FROM														\n")
					.append("	haccp_ccp_info A										\n")
					.append("	INNER JOIN v_censor_data_type B							\n")
					.append("	ON A.ccp_type = B.code_value								\n")
					.append("	AND A.member_key = B.member_key\n")
					.append("WHERE A.member_key	= '" + jArray.get("member_key") + "'	\n")
					.append("ORDER BY ccp_no ASC, censor_no ASC							\n")
					.toString();

			resultString = super.excuteQueryString(con, sql.toString());
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M909S160100E104()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M909S160100E104()","==== finally ===="+ e.getMessage());
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
	
	public int E114(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
		
			
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			
			String sql = new StringBuilder()
					.append("SELECT												\n")
					.append("	censor_no,										\n")
					.append("	censor_channel,									\n")
					.append("	censor_name,									\n")
					.append("	censor_type,									\n")
					.append("	censor_cycle,									\n")
					.append("	censor_loc,										\n")
					.append("	member_key										\n")
					.append("FROM												\n")
					.append("	haccp_censor_info								\n")
					.append("WHERE												\n")
					.append("	member_key = '" + jArray.get("member_key") + "'	\n")
					.append("ORDER BY											\n")
					.append("	censor_no DESC									\n")
					.toString();
			
			resultString = super.excuteQueryString(con, sql.toString());
			
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M909S160100E114()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M909S160100E114()","==== finally ===="+ e.getMessage());
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

	public int E115(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			System.out.println("JSONObject jArray rcvData="+ jArray.toString());
			
			// 클라이언트로 부터 받은 파라미터를 옮겨 담는다.
//			String rcvData = (String)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			// 클라이언트로 부터 받은 파라미터를 쪼개어서 배열에 담는다.
			//{ "설비코드", "업무구분", "기관명", "수리내용", "반출일", "완료일", "담당자", "비용", "비고", "SEQ_NO"};
			
//			String[][] c_paramArray = CommonFunction.getConvString2DoubleArray(rcvData);
			String sql = new StringBuilder()
					.append("SELECT														\n")
					.append("	censor_no,												\n")
					.append("	censor_channel,											\n")
//					.append("	censor_name,											\n")
					.append("	ccp_no,													\n")
					.append("	ccp_name,												\n")
					.append("	ccp_type,												\n")
					.append("	ccp_value,												\n")
					.append("	ccp_yn,													\n")
					.append("	get_auto_yn,											\n")
					.append("	temp_record,											\n")
					.append("	monitor_yn,											\n")
					.append("	member_key												\n")
					.append("FROM														\n")
					.append("	haccp_ccp_info											\n")
					.append("WHERE member_key	= '" + jArray.get("member_key") + "'	\n")
					.append("AND censor_no	= '" + jArray.get("censor_no") + "'			\n")
					.append("AND ccp_no		= '" + jArray.get("ccp_no") + "'			\n")
					.append("ORDER BY ccp_no ASC, censor_no ASC							\n")
					.toString();
			
			resultString = super.excuteQueryString(con, sql.toString());
			
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M909S160100E115()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M909S160100E115()","==== finally ===="+ e.getMessage());
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
	
	public int E201(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject(); // JSONObject 선언
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			
			
			sql = new StringBuffer();
			sql.append(" insert into tbi_seolbi_repare ( 		\n");
			sql.append(" 		seolbi_cd						\n"); 
			sql.append(" 		,seq_no							\n"); 
			sql.append(" 		,reason_cd						\n"); 
			sql.append(" 		,start_dt						\n"); 
			sql.append(" 		,end_dt							\n"); 
			sql.append(" 		,user_id						\n"); 
			sql.append(" 		,biyong							\n"); 
			sql.append(" 		,gigwan_nm						\n"); 
			sql.append(" 		,work_memo						\n"); 
			sql.append(" 		,bigo							\n"); 
			sql.append(" 		,member_key						\n"); // member_key_insert
			sql.append(" 	) values ( 							\n");
			sql.append(" 		'" + jArray.get("seolbi_code") + "' 	\n"); 	//seolbi_cd
			sql.append(" 		,(select coalesce(max(seq_no),0)+1 from tbi_seolbi_repare where \n"); 	//sys_bom_id
			sql.append(" 		 	seolbi_cd='" + jArray.get("seolbi_code") + "') \n");
			sql.append(" 		,'" + jArray.get("job_gubun") + "' 	\n"); 	//reason_cd
			sql.append(" 		,'" + jArray.get("start_date") + "' \n"); 	//start_dt
			sql.append(" 		,'" + jArray.get("end_date") + "'	\n"); 	//end_dt
			sql.append(" 		,'" + jArray.get("damdangja") + "' 	\n"); 	//user_id
			sql.append(" 		,'" + jArray.get("biyong") + "' 	\n"); 	//biyong
			sql.append(" 		,'" + jArray.get("gigwan_name") + "'\n"); 	//gigwan_nm
			sql.append(" 		,'" + jArray.get("work_memo") + "' \n"); 	//work_memo
			sql.append(" 		,'" + jArray.get("bigo") + "'		\n"); 	//bigo
			sql.append(" 		,'" + jArray.get("member_key") + "' \n"); //member_key_values
			sql.append(" 	) 										\n");

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
			LoggingWriter.setLogError("M909S180100E201()","==== SQL ERROR ===="+ e.getMessage() + "\n" + sql.toString());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M909S180100E201()","==== finally ===="+ e.getMessage());
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

	public int E202(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject(); // JSONObject 선언
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));

			sql = new StringBuffer();
			sql.append(" update tbi_seolbi_repare set 						\n");
			sql.append(" 	reason_cd = 	'" + jArray.get("job_gubun") + "'	\n"); 
			sql.append(" 	,start_dt = 	'" + jArray.get("start_date") + "'	\n"); 
			sql.append(" 	,end_dt = 		'" + jArray.get("end_date") + "'	\n"); 
			sql.append(" 	,user_id = 		'" + jArray.get("damdangja") + "'	\n"); 
			sql.append(" 	,biyong = 		'" + jArray.get("biyong") + "'		\n"); 
			sql.append(" 	,gigwan_nm = 	'" + jArray.get("gigwan_name") + "'	\n"); 
			sql.append(" 	,work_memo = 	'" + jArray.get("work_memo") + "'	\n"); 
			sql.append(" 	,bigo = 		'" + jArray.get("bigo") + "'		\n"); 
			sql.append(" 	,member_key = 	'" + jArray.get("member_key") + "'		\n"); 
			sql.append(" where seolbi_cd = 	'" + jArray.get("seolbi_code") + "' \n");
			sql.append(" 	AND seq_no = '"    + jArray.get("seq_no") + "' 		\n");
			sql.append(" 	AND member_key = '" + jArray.get("member_key") + "' \n"); //member_key_select, update, delete

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
		} catch(Exception e) {
			LoggingWriter.setLogError("M909S180100E202()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M909S180100E202()","==== finally ===="+ e.getMessage());
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

	public int E203(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject(); // JSONObject 선언
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));

			sql = new StringBuffer();
			sql.append(" delete from tbi_seolbi_repare 						\n");
			sql.append(" where seolbi_cd = 	'" + jArray.get("seolbi_code") + "' 	\n");
			sql.append(" 	AND seq_no = 	'" + jArray.get("seq_no") + "' 			\n");
			sql.append(" 	AND member_key = '" + jArray.get("member_key") + "' \n"); //member_key_select, update, delete

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
		} catch(Exception e) {
			LoggingWriter.setLogError("M909S180100E203()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M909S180100E203()","==== finally ===="+ e.getMessage());
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
			sql.append(" select \n"); 
			sql.append(" 		seolbi_cd				\n"); 
			sql.append(" 		,seolbi_nm				\n"); 
			sql.append(" 		,doip_date				\n"); 
			sql.append(" 		,gugyuk					\n"); 
			sql.append(" 		,seolbi_maker			\n"); 
			sql.append(" 		,gigi_bunho				\n");
			sql.append("		,use_buseo				\n");
			sql.append("		,admin_id				\n");
			sql.append("		,checkim_id				\n");
			sql.append("		,gyojung_damdang		\n");
			sql.append(" 		,yuhyo_date				\n");
			sql.append("		,gyojung_jugi			\n");
			sql.append("		,gyojung_date			\n");
			sql.append("		,bigo					\n");
			sql.append(" 		,img_filename			\n"); 
			sql.append(" 		,revision_no			\n"); 
			sql.append("		,start_date				\n");
			sql.append("		,duration_date			\n");
			sql.append("		,create_user_id			\n");
			sql.append("		,create_date			\n");
			sql.append("		,modify_date			\n");
			sql.append("		,modify_user_id			\n");
			sql.append("		,modify_reason			\n");
			sql.append("		,sulbi_gubun			\n");
			sql.append(" from tbm_seolbi 				\n"); 
			sql.append(" where  sulbi_gubun = 'SLB001' 	\n"); 
			sql.append(" 	AND member_key = '" + jArray.get("member_key") + "' \n"); //member_key_select, update, delete
			sql.append(" 	order by seolbi_cd ASC, revision_no DESC 			\n");

			resultString = super.excuteQueryString(con, sql.toString());
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M909S180100E204()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M909S180100E204()","==== finally ===="+ e.getMessage());
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
	
	public int E214(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			// 클라이언트로 부터 받은 파라미터를 옮겨 담는다.
			//String rcvData = (String)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			// 클라이언트로 부터 받은 파라미터를 쪼개어서 배열에 담는다.
			//{ "설비코드", "업무구분", "기관명", "수리내용", "반출일", "완료일", "담당자", "비용", "비고", "SEQ_NO"};
			
			//String[][] c_paramArray = CommonFunction.getConvString2DoubleArray(rcvData);
			
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			
			String sql = new StringBuilder()
					.append(" SELECT 				\n")
					.append("	 seolbi_cd  		\n")
					.append("	 ,B.code_name AS reason_cd  		\n")
					.append("	 ,gigwan_nm  		\n")
					.append("	 ,work_memo  		\n")
					.append("	 ,start_dt  		\n")
					.append("	 ,end_dt  			\n")
					.append("	 ,user_id  			\n")
					.append("	 ,TO_CHAR (biyong, '999,999,999,999') AS biyong  			\n")
					.append("	 ,A.bigo  			\n")
					.append("	 ,seq_no  			\n")
					.append(" FROM 					\n")
					.append("	tbi_seolbi_repare A	\n")
					.append("INNER JOIN tbm_code_book B\n")
					.append("	ON A.reason_cd = B.code_value\n")
					.append("	AND A.member_key = B.member_key\n")
					.append(" WHERE seolbi_cd = '" + jArray.get("seolbi_cd") + "' \n")
					.append(" 	AND A.member_key = '" + jArray.get("member_key") + "' \n") //member_key_select, update, delete
					.append(" ORDER BY seq_no DESC							 \n")
					.toString();
			
			resultString = super.excuteQueryString(con, sql.toString());
			
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M909S180100E214()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M909S180100E214()","==== finally ===="+ e.getMessage());
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
	
	public int E215(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			System.out.println("JSONObject jArray rcvData="+ jArray.toString());
			
			// 클라이언트로 부터 받은 파라미터를 옮겨 담는다.
//			String rcvData = (String)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			// 클라이언트로 부터 받은 파라미터를 쪼개어서 배열에 담는다.
			//{ "설비코드", "업무구분", "기관명", "수리내용", "반출일", "완료일", "담당자", "비용", "비고", "SEQ_NO"};
			
//			String[][] c_paramArray = CommonFunction.getConvString2DoubleArray(rcvData);
			String sql = new StringBuilder()
					.append("SELECT														\n")
					.append("	censor_no,												\n")
					.append("	censor_channel,											\n")
//					.append("	censor_name,											\n")
					.append("	ccp_no,													\n")
					.append("	ccp_name,												\n")
					.append("	ccp_type,												\n")
					.append("	ccp_value,												\n")
					.append("	member_key												\n")
					.append("FROM														\n")
					.append("	haccp_ccp_info											\n")
					.append("WHERE member_key	= '" + jArray.get("member_key") + "'	\n")
					.append("AND censor_no	= '" + jArray.get("censor_no") + "'			\n")
					.append("AND ccp_no		= '" + jArray.get("ccp_no") + "'			\n")
					.append("ORDER BY ccp_no ASC, censor_no ASC							\n")
					.toString();
			
			resultString = super.excuteQueryString(con, sql.toString());
			
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M909S160100E215()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M909S160100E215()","==== finally ===="+ e.getMessage());
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
	
	public int E401(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject(); // JSONObject 선언
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			
			
			sql = new StringBuffer();
			sql.append(" insert into tbi_seolbi_repare ( 		\n");
			sql.append(" 		seolbi_cd						\n"); 
			sql.append(" 		,seq_no							\n"); 
			sql.append(" 		,reason_cd						\n"); 
			sql.append(" 		,start_dt						\n"); 
			sql.append(" 		,end_dt							\n"); 
			sql.append(" 		,user_id						\n"); 
			sql.append(" 		,biyong							\n"); 
			sql.append(" 		,gigwan_nm						\n"); 
			sql.append(" 		,work_memo						\n"); 
			sql.append(" 		,bigo							\n"); 
			sql.append(" 		,member_key						\n"); // member_key_insert
			sql.append(" 	) values ( 							\n");
			sql.append(" 		'" + jArray.get("seolbi_code") + "' 	\n"); 	//seolbi_cd
			sql.append(" 		,(select coalesce(max(seq_no),0)+1 from tbi_seolbi_repare where \n"); 	//sys_bom_id
			sql.append(" 		 	seolbi_cd='" + jArray.get("seolbi_code") + "') \n");
			sql.append(" 		,'" + jArray.get("job_gubun") + "' 	\n"); 	//reason_cd
			sql.append(" 		,'" + jArray.get("start_date") + "' \n"); 	//start_dt
			sql.append(" 		,'" + jArray.get("end_date") + "'	\n"); 	//end_dt
			sql.append(" 		,'" + jArray.get("damdangja") + "' 	\n"); 	//user_id
			sql.append(" 		,'" + jArray.get("biyong") + "' 	\n"); 	//biyong
			sql.append(" 		,'" + jArray.get("gigwan_name") + "'\n"); 	//gigwan_nm
			sql.append(" 		,'" + jArray.get("work_memo") + "' \n"); 	//work_memo
			sql.append(" 		,'" + jArray.get("bigo") + "'		\n"); 	//bigo
			sql.append(" 		,'" + jArray.get("member_key") + "' \n"); //member_key_values
			sql.append(" 	) 										\n");

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
			LoggingWriter.setLogError("M909S180100E401()","==== SQL ERROR ===="+ e.getMessage() + "\n" + sql.toString());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M909S180100E401()","==== finally ===="+ e.getMessage());
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

	public int E402(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject(); // JSONObject 선언
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));

			sql = new StringBuffer();
			sql.append(" update tbi_seolbi_repare set 						\n");
			sql.append(" 	reason_cd = 	'" + jArray.get("job_gubun") + "'	\n"); 
			sql.append(" 	,start_dt = 	'" + jArray.get("start_date") + "'	\n"); 
			sql.append(" 	,end_dt = 		'" + jArray.get("end_date") + "'	\n"); 
			sql.append(" 	,user_id = 		'" + jArray.get("damdangja") + "'	\n"); 
			sql.append(" 	,biyong = 		'" + jArray.get("biyong") + "'		\n"); 
			sql.append(" 	,gigwan_nm = 	'" + jArray.get("gigwan_name") + "'	\n"); 
			sql.append(" 	,work_memo = 	'" + jArray.get("work_memo") + "'	\n"); 
			sql.append(" 	,bigo = 		'" + jArray.get("bigo") + "'		\n"); 
			sql.append(" 	,member_key = 	'" + jArray.get("member_key") + "'		\n"); 
			sql.append(" where seolbi_cd = 	'" + jArray.get("seolbi_code") + "' \n");
			sql.append(" 	AND seq_no = '"    + jArray.get("seq_no") + "' 		\n");
			sql.append(" 	AND member_key = '" + jArray.get("member_key") + "' \n"); //member_key_select, update, delete

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
		} catch(Exception e) {
			LoggingWriter.setLogError("M909S180100E402()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M909S180100E402()","==== finally ===="+ e.getMessage());
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

	public int E403(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject(); // JSONObject 선언
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));

			sql = new StringBuffer();
			sql.append(" delete from tbi_seolbi_repare 						\n");
			sql.append(" where seolbi_cd = 	'" + jArray.get("seolbi_code") + "' 	\n");
			sql.append(" 	AND seq_no = 	'" + jArray.get("seq_no") + "' 			\n");
			sql.append(" 	AND member_key = '" + jArray.get("member_key") + "' \n"); //member_key_select, update, delete

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
		} catch(Exception e) {
			LoggingWriter.setLogError("M909S180100E403()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M909S180100E403()","==== finally ===="+ e.getMessage());
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

	public int E404(InoutParameter ioParam) {
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
			sql.append(" select \n"); 
			sql.append(" 		seolbi_cd				\n"); 
			sql.append(" 		,seolbi_nm				\n"); 
			sql.append(" 		,doip_date				\n"); 
			sql.append(" 		,gugyuk					\n"); 
			sql.append(" 		,seolbi_maker			\n"); 
			sql.append(" 		,gigi_bunho				\n");
			sql.append("		,use_buseo				\n");
			sql.append("		,admin_id				\n");
			sql.append("		,checkim_id				\n");
			sql.append("		,gyojung_damdang		\n");
			sql.append(" 		,yuhyo_date				\n");
			sql.append("		,gyojung_jugi			\n");
			sql.append("		,gyojung_date			\n");
			sql.append("		,bigo					\n");
			sql.append(" 		,img_filename			\n"); 
			sql.append(" 		,revision_no			\n"); 
			sql.append("		,start_date				\n");
			sql.append("		,duration_date			\n");
			sql.append("		,create_user_id			\n");
			sql.append("		,create_date			\n");
			sql.append("		,modify_date			\n");
			sql.append("		,modify_user_id			\n");
			sql.append("		,modify_reason			\n");
			sql.append("		,sulbi_gubun			\n");
			sql.append(" from tbm_seolbi 				\n"); 
			sql.append(" where  sulbi_gubun = 'SLB001' 	\n"); 
			sql.append(" 	AND member_key = '" + jArray.get("member_key") + "' \n"); //member_key_select, update, delete
			sql.append(" 	order by seolbi_cd ASC, revision_no DESC 			\n");

			resultString = super.excuteQueryString(con, sql.toString());
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M909S180100E404()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M909S180100E404()","==== finally ===="+ e.getMessage());
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
	
	public int E414(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			// 클라이언트로 부터 받은 파라미터를 옮겨 담는다.
			//String rcvData = (String)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			// 클라이언트로 부터 받은 파라미터를 쪼개어서 배열에 담는다.
			//{ "설비코드", "업무구분", "기관명", "수리내용", "반출일", "완료일", "담당자", "비용", "비고", "SEQ_NO"};
			
			//String[][] c_paramArray = CommonFunction.getConvString2DoubleArray(rcvData);
			
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			
			String sql = new StringBuilder()
					.append(" SELECT 				\n")
					.append("	 seolbi_cd  		\n")
					.append("	 ,B.code_name AS reason_cd  		\n")
					.append("	 ,gigwan_nm  		\n")
					.append("	 ,work_memo  		\n")
					.append("	 ,start_dt  		\n")
					.append("	 ,end_dt  			\n")
					.append("	 ,user_id  			\n")
					.append("	 ,TO_CHAR (biyong, '999,999,999,999') AS biyong  			\n")
					.append("	 ,A.bigo  			\n")
					.append("	 ,seq_no  			\n")
					.append(" FROM 					\n")
					.append("	tbi_seolbi_repare A	\n")
					.append("INNER JOIN tbm_code_book B\n")
					.append("	ON A.reason_cd = B.code_value\n")
					.append("	AND A.member_key = B.member_key\n")
					.append(" WHERE seolbi_cd = '" + jArray.get("seolbi_cd") + "' \n")
					.append(" 	AND A.member_key = '" + jArray.get("member_key") + "' \n") //member_key_select, update, delete
					.append(" ORDER BY seq_no DESC							 \n")
					.toString();
			
			resultString = super.excuteQueryString(con, sql.toString());
			
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M909S180100E414()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M909S180100E414()","==== finally ===="+ e.getMessage());
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
	
	public int E501(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject(); // JSONObject 선언
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			
			
			sql = new StringBuffer();
			sql.append(" insert into tbi_seolbi_repare ( 		\n");
			sql.append(" 		seolbi_cd						\n"); 
			sql.append(" 		,seq_no							\n"); 
			sql.append(" 		,reason_cd						\n"); 
			sql.append(" 		,start_dt						\n"); 
			sql.append(" 		,end_dt							\n"); 
			sql.append(" 		,user_id						\n"); 
			sql.append(" 		,biyong							\n"); 
			sql.append(" 		,gigwan_nm						\n"); 
			sql.append(" 		,work_memo						\n"); 
			sql.append(" 		,bigo							\n"); 
			sql.append(" 		,member_key						\n"); // member_key_insert
			sql.append(" 	) values ( 							\n");
			sql.append(" 		'" + jArray.get("seolbi_code") + "' 	\n"); 	//seolbi_cd
			sql.append(" 		,(select coalesce(max(seq_no),0)+1 from tbi_seolbi_repare where \n"); 	//sys_bom_id
			sql.append(" 		 	seolbi_cd='" + jArray.get("seolbi_code") + "') \n");
			sql.append(" 		,'" + jArray.get("job_gubun") + "' 	\n"); 	//reason_cd
			sql.append(" 		,'" + jArray.get("start_date") + "' \n"); 	//start_dt
			sql.append(" 		,'" + jArray.get("end_date") + "'	\n"); 	//end_dt
			sql.append(" 		,'" + jArray.get("damdangja") + "' 	\n"); 	//user_id
			sql.append(" 		,'" + jArray.get("biyong") + "' 	\n"); 	//biyong
			sql.append(" 		,'" + jArray.get("gigwan_name") + "'\n"); 	//gigwan_nm
			sql.append(" 		,'" + jArray.get("work_memo") + "' \n"); 	//work_memo
			sql.append(" 		,'" + jArray.get("bigo") + "'		\n"); 	//bigo
			sql.append(" 		,'" + jArray.get("member_key") + "' \n"); //member_key_values
			sql.append(" 	) 										\n");

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
			LoggingWriter.setLogError("M909S180100E501()","==== SQL ERROR ===="+ e.getMessage() + "\n" + sql.toString());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M909S180100E501()","==== finally ===="+ e.getMessage());
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

	public int E502(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject(); // JSONObject 선언
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));

			sql = new StringBuffer();
			sql.append(" update tbi_seolbi_repare set 						\n");
			sql.append(" 	reason_cd = 	'" + jArray.get("job_gubun") + "'	\n"); 
			sql.append(" 	,start_dt = 	'" + jArray.get("start_date") + "'	\n"); 
			sql.append(" 	,end_dt = 		'" + jArray.get("end_date") + "'	\n"); 
			sql.append(" 	,user_id = 		'" + jArray.get("damdangja") + "'	\n"); 
			sql.append(" 	,biyong = 		'" + jArray.get("biyong") + "'		\n"); 
			sql.append(" 	,gigwan_nm = 	'" + jArray.get("gigwan_name") + "'	\n"); 
			sql.append(" 	,work_memo = 	'" + jArray.get("work_memo") + "'	\n"); 
			sql.append(" 	,bigo = 		'" + jArray.get("bigo") + "'		\n"); 
			sql.append(" 	,member_key = 	'" + jArray.get("member_key") + "'		\n"); 
			sql.append(" where seolbi_cd = 	'" + jArray.get("seolbi_code") + "' \n");
			sql.append(" 	AND seq_no = '"    + jArray.get("seq_no") + "' 		\n");
			sql.append(" 	AND member_key = '" + jArray.get("member_key") + "' \n"); //member_key_select, update, delete

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
		} catch(Exception e) {
			LoggingWriter.setLogError("M909S180100E502()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M909S180100E502()","==== finally ===="+ e.getMessage());
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

	public int E503(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject(); // JSONObject 선언
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));

			sql = new StringBuffer();
			sql.append(" delete from tbi_seolbi_repare 						\n");
			sql.append(" where seolbi_cd = 	'" + jArray.get("seolbi_code") + "' 	\n");
			sql.append(" 	AND seq_no = 	'" + jArray.get("seq_no") + "' 			\n");
			sql.append(" 	AND member_key = '" + jArray.get("member_key") + "' \n"); //member_key_select, update, delete

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
		} catch(Exception e) {
			LoggingWriter.setLogError("M909S180100E503()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M909S180100E503()","==== finally ===="+ e.getMessage());
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

	public int E504(InoutParameter ioParam) {
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
			sql.append(" select \n"); 
			sql.append(" 		seolbi_cd				\n"); 
			sql.append(" 		,seolbi_nm				\n"); 
			sql.append(" 		,doip_date				\n"); 
			sql.append(" 		,gugyuk					\n"); 
			sql.append(" 		,seolbi_maker			\n"); 
			sql.append(" 		,gigi_bunho				\n");
			sql.append("		,use_buseo				\n");
			sql.append("		,admin_id				\n");
			sql.append("		,checkim_id				\n");
			sql.append("		,gyojung_damdang		\n");
			sql.append(" 		,yuhyo_date				\n");
			sql.append("		,gyojung_jugi			\n");
			sql.append("		,gyojung_date			\n");
			sql.append("		,bigo					\n");
			sql.append(" 		,img_filename			\n"); 
			sql.append(" 		,revision_no			\n"); 
			sql.append("		,start_date				\n");
			sql.append("		,duration_date			\n");
			sql.append("		,create_user_id			\n");
			sql.append("		,create_date			\n");
			sql.append("		,modify_date			\n");
			sql.append("		,modify_user_id			\n");
			sql.append("		,modify_reason			\n");
			sql.append("		,sulbi_gubun			\n");
			sql.append(" from tbm_seolbi 				\n"); 
			sql.append(" where  sulbi_gubun = 'SLB001' 	\n"); 
			sql.append(" 	AND member_key = '" + jArray.get("member_key") + "' \n"); //member_key_select, update, delete
			sql.append(" 	order by seolbi_cd ASC, revision_no DESC 			\n");

			resultString = super.excuteQueryString(con, sql.toString());
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M909S180100E504()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M909S180100E504()","==== finally ===="+ e.getMessage());
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
	
	public int E514(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			// 클라이언트로 부터 받은 파라미터를 옮겨 담는다.
			//String rcvData = (String)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			// 클라이언트로 부터 받은 파라미터를 쪼개어서 배열에 담는다.
			//{ "설비코드", "업무구분", "기관명", "수리내용", "반출일", "완료일", "담당자", "비용", "비고", "SEQ_NO"};
			
			//String[][] c_paramArray = CommonFunction.getConvString2DoubleArray(rcvData);
			
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			
			String sql = new StringBuilder()
					.append(" SELECT 				\n")
					.append("	 seolbi_cd  		\n")
					.append("	 ,B.code_name AS reason_cd  		\n")
					.append("	 ,gigwan_nm  		\n")
					.append("	 ,work_memo  		\n")
					.append("	 ,start_dt  		\n")
					.append("	 ,end_dt  			\n")
					.append("	 ,user_id  			\n")
					.append("	 ,TO_CHAR (biyong, '999,999,999,999') AS biyong  			\n")
					.append("	 ,A.bigo  			\n")
					.append("	 ,seq_no  			\n")
					.append(" FROM 					\n")
					.append("	tbi_seolbi_repare A	\n")
					.append("INNER JOIN tbm_code_book B\n")
					.append("	ON A.reason_cd = B.code_value\n")
					.append("	AND A.member_key = B.member_key\n")
					.append(" WHERE seolbi_cd = '" + jArray.get("seolbi_cd") + "' \n")
					.append(" 	AND A.member_key = '" + jArray.get("member_key") + "' \n") //member_key_select, update, delete
					.append(" ORDER BY seq_no DESC							 \n")
					.toString();
			
			resultString = super.excuteQueryString(con, sql.toString());
			
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M909S180100E514()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M909S180100E514()","==== finally ===="+ e.getMessage());
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
	
	public int E601(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject(); // JSONObject 선언
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			
			
			sql = new StringBuffer();
			sql.append(" insert into tbi_seolbi_repare ( 		\n");
			sql.append(" 		seolbi_cd						\n"); 
			sql.append(" 		,seq_no							\n"); 
			sql.append(" 		,reason_cd						\n"); 
			sql.append(" 		,start_dt						\n"); 
			sql.append(" 		,end_dt							\n"); 
			sql.append(" 		,user_id						\n"); 
			sql.append(" 		,biyong							\n"); 
			sql.append(" 		,gigwan_nm						\n"); 
			sql.append(" 		,work_memo						\n"); 
			sql.append(" 		,bigo							\n"); 
			sql.append(" 		,member_key						\n"); // member_key_insert
			sql.append(" 	) values ( 							\n");
			sql.append(" 		'" + jArray.get("seolbi_code") + "' 	\n"); 	//seolbi_cd
			sql.append(" 		,(select coalesce(max(seq_no),0)+1 from tbi_seolbi_repare where \n"); 	//sys_bom_id
			sql.append(" 		 	seolbi_cd='" + jArray.get("seolbi_code") + "') \n");
			sql.append(" 		,'" + jArray.get("job_gubun") + "' 	\n"); 	//reason_cd
			sql.append(" 		,'" + jArray.get("start_date") + "' \n"); 	//start_dt
			sql.append(" 		,'" + jArray.get("end_date") + "'	\n"); 	//end_dt
			sql.append(" 		,'" + jArray.get("damdangja") + "' 	\n"); 	//user_id
			sql.append(" 		,'" + jArray.get("biyong") + "' 	\n"); 	//biyong
			sql.append(" 		,'" + jArray.get("gigwan_name") + "'\n"); 	//gigwan_nm
			sql.append(" 		,'" + jArray.get("work_memo") + "' \n"); 	//work_memo
			sql.append(" 		,'" + jArray.get("bigo") + "'		\n"); 	//bigo
			sql.append(" 		,'" + jArray.get("member_key") + "' \n"); //member_key_values
			sql.append(" 	) 										\n");

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
			LoggingWriter.setLogError("M909S180100E601()","==== SQL ERROR ===="+ e.getMessage() + "\n" + sql.toString());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M909S180100E601()","==== finally ===="+ e.getMessage());
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

	public int E602(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject(); // JSONObject 선언
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));

			sql = new StringBuffer();
			sql.append(" update tbi_seolbi_repare set 						\n");
			sql.append(" 	reason_cd = 	'" + jArray.get("job_gubun") + "'	\n"); 
			sql.append(" 	,start_dt = 	'" + jArray.get("start_date") + "'	\n"); 
			sql.append(" 	,end_dt = 		'" + jArray.get("end_date") + "'	\n"); 
			sql.append(" 	,user_id = 		'" + jArray.get("damdangja") + "'	\n"); 
			sql.append(" 	,biyong = 		'" + jArray.get("biyong") + "'		\n"); 
			sql.append(" 	,gigwan_nm = 	'" + jArray.get("gigwan_name") + "'	\n"); 
			sql.append(" 	,work_memo = 	'" + jArray.get("work_memo") + "'	\n"); 
			sql.append(" 	,bigo = 		'" + jArray.get("bigo") + "'		\n"); 
			sql.append(" 	,member_key = 	'" + jArray.get("member_key") + "'		\n"); 
			sql.append(" where seolbi_cd = 	'" + jArray.get("seolbi_code") + "' \n");
			sql.append(" 	AND seq_no = '"    + jArray.get("seq_no") + "' 		\n");
			sql.append(" 	AND member_key = '" + jArray.get("member_key") + "' \n"); //member_key_select, update, delete

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
		} catch(Exception e) {
			LoggingWriter.setLogError("M909S180100E602()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M909S180100E602()","==== finally ===="+ e.getMessage());
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

	public int E603(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject(); // JSONObject 선언
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));

			sql = new StringBuffer();
			sql.append(" delete from tbi_seolbi_repare 						\n");
			sql.append(" where seolbi_cd = 	'" + jArray.get("seolbi_code") + "' 	\n");
			sql.append(" 	AND seq_no = 	'" + jArray.get("seq_no") + "' 			\n");
			sql.append(" 	AND member_key = '" + jArray.get("member_key") + "' \n"); //member_key_select, update, delete

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
		} catch(Exception e) {
			LoggingWriter.setLogError("M909S180100E603()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M909S180100E603()","==== finally ===="+ e.getMessage());
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

	public int E604(InoutParameter ioParam) {
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
			sql.append(" select \n"); 
			sql.append(" 		seolbi_cd				\n"); 
			sql.append(" 		,seolbi_nm				\n"); 
			sql.append(" 		,doip_date				\n"); 
			sql.append(" 		,gugyuk					\n"); 
			sql.append(" 		,seolbi_maker			\n"); 
			sql.append(" 		,gigi_bunho				\n");
			sql.append("		,use_buseo				\n");
			sql.append("		,admin_id				\n");
			sql.append("		,checkim_id				\n");
			sql.append("		,gyojung_damdang		\n");
			sql.append(" 		,yuhyo_date				\n");
			sql.append("		,gyojung_jugi			\n");
			sql.append("		,gyojung_date			\n");
			sql.append("		,bigo					\n");
			sql.append(" 		,img_filename			\n"); 
			sql.append(" 		,revision_no			\n"); 
			sql.append("		,start_date				\n");
			sql.append("		,duration_date			\n");
			sql.append("		,create_user_id			\n");
			sql.append("		,create_date			\n");
			sql.append("		,modify_date			\n");
			sql.append("		,modify_user_id			\n");
			sql.append("		,modify_reason			\n");
			sql.append("		,sulbi_gubun			\n");
			sql.append(" from tbm_seolbi 				\n"); 
			sql.append(" where  sulbi_gubun = 'SLB001' 	\n"); 
			sql.append(" 	AND member_key = '" + jArray.get("member_key") + "' \n"); //member_key_select, update, delete
			sql.append(" 	order by seolbi_cd ASC, revision_no DESC 			\n");

			resultString = super.excuteQueryString(con, sql.toString());
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M909S180100E604()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M909S180100E604()","==== finally ===="+ e.getMessage());
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
	
	public int E614(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			// 클라이언트로 부터 받은 파라미터를 옮겨 담는다.
			//String rcvData = (String)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			// 클라이언트로 부터 받은 파라미터를 쪼개어서 배열에 담는다.
			//{ "설비코드", "업무구분", "기관명", "수리내용", "반출일", "완료일", "담당자", "비용", "비고", "SEQ_NO"};
			
			//String[][] c_paramArray = CommonFunction.getConvString2DoubleArray(rcvData);
			
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			
			String sql = new StringBuilder()
					.append(" SELECT 				\n")
					.append("	 seolbi_cd  		\n")
					.append("	 ,B.code_name AS reason_cd  		\n")
					.append("	 ,gigwan_nm  		\n")
					.append("	 ,work_memo  		\n")
					.append("	 ,start_dt  		\n")
					.append("	 ,end_dt  			\n")
					.append("	 ,user_id  			\n")
					.append("	 ,TO_CHAR (biyong, '999,999,999,999') AS biyong  			\n")
					.append("	 ,A.bigo  			\n")
					.append("	 ,seq_no  			\n")
					.append(" FROM 					\n")
					.append("	tbi_seolbi_repare A	\n")
					.append("INNER JOIN tbm_code_book B\n")
					.append("	ON A.reason_cd = B.code_value\n")
					.append("	AND A.member_key = B.member_key\n")
					.append(" WHERE seolbi_cd = '" + jArray.get("seolbi_cd") + "' \n")
					.append(" 	AND A.member_key = '" + jArray.get("member_key") + "' \n") //member_key_select, update, delete
					.append(" ORDER BY seq_no DESC							 \n")
					.toString();
			
			resultString = super.excuteQueryString(con, sql.toString());
			
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M909S180100E614()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M909S180100E614()","==== finally ===="+ e.getMessage());
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
			
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			
			String sql = new StringBuilder()
					.append("SELECT		code_value, code_name							\n")
					.append("FROM		tbm_code_book									\n")
					.append("WHERE		member_key = '" + jArray.get("member_key") + "'	\n")
					.append("AND		code_cd = '" + jArray.get("code_cd") + "'		\n")
					.append("ORDER BY	code_value ASC									\n")
					.toString();

			resultString = super.excuteQueryString(con, sql.toString());
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M909S160100E995()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M909S160100E995()","==== finally ===="+ e.getMessage());
				}
	    	} else {
	    	}
	    }
		ioParam.setResultString(resultString);
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
    	ioParam.setMessage(MessageDefine.M_QUERY_OK);
	    return EventDefine.E_QUERY_RESULT;
	}
	
	public int E996(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			
			String sql = new StringBuilder()
					.append("SELECT	code_name												\n")
					.append("FROM	tbm_code_book											\n")
					.append("WHERE	member_key		= '" + jArray.get("member_key") + "'	\n")
					.append("AND	code_cd			= '" + jArray.get("code_cd") + "'		\n")
					.append("AND	code_value		= '" + jArray.get("code_value") + "'	\n")
					.toString();

			resultString = super.excuteQueryString(con, sql.toString());
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M909S160100E996()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M909S160100E996()","==== finally ===="+ e.getMessage());
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