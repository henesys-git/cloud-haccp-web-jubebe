package mes.frame.business.M909;

import java.lang.reflect.Method;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.util.Vector;

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


public class M909S055100 extends SqlAdapter{
	Connection con = null;
	PreparedStatement pstmt = null;
	String resultString = "";
	int resultInt = -1;
	StringBuffer sql = new StringBuffer();
	
	String[][] v_paramArray = new String[0][0]; 
	Class[] optClass = null;
	Object[] optObj = null;
	Object obj = null;
	
	public M909S055100(){
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

			Method method = M909S055100.class.getMethod(event,optClass);
			LoggingWriter.setLogDebug(M909S055100.class.getName(),"==== " + event + " EventMethod Create Success ====");

			obj = method.invoke(M909S055100.class.newInstance(),optObj);
			doExcute_result = CommonFunction.getInt(obj.toString());
			
	    } catch (Exception ex) {
	    	doExcute_result = EventDefine.E_DOEXCUTE_INIT;
			ioParam.setMessage(MessageDefine.M_NO_EVENTID);
			LoggingWriter.setLogError(M909S055100.class.getName(),"==== EventID Not define : EVENT ID [ " + ioParam.getEventID() + "]");
	    } finally {
	    	obj = null;
			optClass = null;
			optObj = null;
	    }
	    long endTime = System.currentTimeMillis();
		long runningTime = endTime - startTime;
		LoggingWriter.setLogAll(M909S055100.class.getName(),"==== Query [수행시간  : " + runningTime + " ms]");
		
		return doExcute_result;
	}
	

	public int E101(InoutParameter ioParam){
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

			String sql = new StringBuilder()
					.append("INSERT INTO tbm_vehicle ( 	\n")
					.append("	vehicle_cd,\n")
					.append("	vehicle_rev_no,\n")
					.append("	vehicle_nm,\n")
					.append("	vehicle_model,\n")
					.append("	vehicle_maker,\n")
					.append("	vehicle_type,\n")
					.append("	vehicle_ton_weight,\n")
					.append("	bigo,\n")
					.append("	start_date,\n")
					.append("	duration_date,\n")
					.append("	create_user_id,\n")
					.append("	create_date,\n")
					.append("	modify_user_id,\n")
					.append("	modify_reason,\n")
					.append("	modify_date\n")
					.append(") values (\n")
					.append("	 '"	+ jArray.get("vehicle_cd") 		+ "' \n")
					.append("	,'"	+ jArray.get("revision_no") 	+ "' \n")
					.append("	,'"	+ jArray.get("vehicle_nm") + "' \n")
					.append("	,'"	+ jArray.get("vehicle_model") 	+ "' \n")
					.append("	,'"	+ jArray.get("vehicle_maker") 		+ "' \n")
					.append("	,'"	+ jArray.get("vehicle_type") + "' \n")
					.append("	,'"	+ jArray.get("vehicle_ton_weight") 	+ "' \n")
					.append("	,'"	+ jArray.get("bigo") 		+ "' \n")
					.append("	,'"	+ jArray.get("StartDate") 	+ "' \n") //start_date
					.append("	,'9999-12-31' 						 \n") //duration_date
					.append("	,'" + jArray.get("user_id") 	+ "' \n") //create_user_id
					.append("	,SYSDATETIME					 	 \n") //create_date
					.append("	,'" + jArray.get("user_id") 	+ "' \n") //modify_user_id
					.append("	,'최초등록' 						 	 \n") //modify_reason
					.append("	,SYSDATETIME  					 	 \n") //modify_date
					.append(")\n")
					.toString();
			
			// System.out.println(sql.toString());
				resultInt = super.excuteUpdate(con, sql.toString());
				if (resultInt < 0) {
					ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
				} else {
					ioParam.setMessage(resultInt + "건 " + MessageDefine.M_INSERT_RESULT);
				}
				
		} catch(Exception e) {
			LoggingWriter.setLogError("M909S055100E101()","==== SQL ERROR ===="+ e.getMessage() + "\n" + sql.toString());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M909S055100E101()","==== finally ===="+ e.getMessage());
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
			
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			System.out.println("JSONObject jArray rcvData="+ jArray.toString());
			
			// 클라이언트로 부터 받은 파라미터를 옮겨 담는다.
//			String rcvData = (String)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			// 클라이언트로 부터 받은 파라미터를 쪼개어서 배열에 담는다.
//			String[][] c_paramArray = CommonFunction.getConvString2DoubleArray(rcvData);
			
			con.setAutoCommit(false);
			
			// 먼저 이전 리비전에 대한 적용종료일자를 이번의 적용일자에서 하루를 뺀 날짜로 변경한다.
			String sqlPre = new StringBuilder()
					.append("UPDATE tbm_vehicle SET	\n")
					.append(" duration_date = to_char(TO_DATE('" + jArray.get("StartDate") + "', 'YYYY-MM-DD')-1 , 'YYYY-MM-DD')	\n")
					.append("WHERE vehicle_cd = '" + jArray.get("vehicle_cd") + "'\n")
					.append("	AND vehicle_rev_no = '" + jArray.get("RevisionNo_Target") + "'\n")
					.toString();
			
			resultInt = super.excuteUpdate(con, sqlPre.toString());
			if (resultInt < 0) {
				con.rollback();
				ioParam.setMessage(MessageDefine.M_UPDATE_FAILED);
				return resultInt;
			} else {
				ioParam.setMessage(resultInt + "건 " + MessageDefine.M_UPDATE_RESULT);
			}

			String sql = new StringBuilder()
					.append("INSERT INTO tbm_vehicle ( 	\n")
					.append("	vehicle_cd,\n")
					.append("	vehicle_rev_no,\n")
					.append("	vehicle_nm,\n")
					.append("	vehicle_model,\n")
					.append("	vehicle_maker,\n")
					.append("	vehicle_type,\n")
					.append("	vehicle_ton_weight,\n")
					.append("	bigo,\n")
					.append("	start_date,\n")
					.append("	duration_date,\n")
					.append("	create_user_id,\n")
					.append("	create_date,\n")
					.append("	modify_user_id,\n")
					.append("	modify_reason,\n")
					.append("	modify_date\n")
					.append(") values (\n")
					.append("	 '"	+ jArray.get("vehicle_cd") 		+ "' \n")
					.append("	,'"	+ jArray.get("revision_no") 	+ "' \n")
					.append("	,'"	+ jArray.get("vehicle_nm") + "' \n")
					.append("	,'"	+ jArray.get("vehicle_model") 	+ "' \n")
					.append("	,'"	+ jArray.get("vehicle_maker") 		+ "' \n")
					.append("	,'"	+ jArray.get("vehicle_type") + "' \n")
					.append("	,'"	+ jArray.get("vehicle_ton_weight") 	+ "' \n")
					.append("	,'"	+ jArray.get("bigo") 		+ "' \n")
					.append("	,'"	+ jArray.get("StartDate") 	+ "' \n") //start_date
					.append("	,'9999-12-31' 						 \n") //duration_date
					.append("	,'" + jArray.get("user_id") 	+ "' \n") //create_user_id
					.append("	,SYSDATETIME					 	 \n") //create_date
					.append("	,'" + jArray.get("user_id") 	+ "' \n") //modify_user_id
					.append("	,'최초등록' 						 	 \n") //modify_reason
					.append("	,SYSDATETIME  					 	 \n") //modify_date
					.append(")\n")
					.toString();

			// System.out.println(sql.toString());
				resultInt = super.excuteUpdate(con, sql.toString());
				if (resultInt < 0) {
					ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
				} else {
					ioParam.setMessage(resultInt + "건 " + MessageDefine.M_INSERT_RESULT);
				}
				
			con.commit();
		} catch(Exception e) {
			LoggingWriter.setLogError("M909S055100E102()","==== SQL ERROR ===="+ e.getMessage() + "\n" + sql.toString());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M909S055100E102()","==== finally ===="+ e.getMessage());
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
			
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			System.out.println("JSONObject jArray rcvData="+ jArray.toString());
			
			// 클라이언트로 부터 받은 파라미터를 옮겨 담는다.
//			String rcvData = (String)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			
			// 클라이언트로 부터 받은 파라미터를 쪼개어서 배열에 담는다.
//			String[][] c_paramArray = CommonFunction.getConvString2DoubleArray(rcvData);

			String sql = new StringBuilder()
				.append("DELETE FROM tbm_vehicle  \n")
				.append(" WHERE vehicle_cd = '" 	+ jArray.get("vehicle_cd") + "'	\n")
				.toString();
					
				resultInt = super.excuteUpdate(con, sql.toString());
				if (resultInt < 0) {
					ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
				} else {
					ioParam.setMessage(resultInt + "건 " + MessageDefine.M_INSERT_RESULT);
				}
				
		} catch(Exception e) {
			LoggingWriter.setLogError("M909S055100E103()","==== SQL ERROR ===="+ e.getMessage() + "\n" + sql.toString());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M909S055100E103()","==== finally ===="+ e.getMessage());
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

	// 차량조회(모든 revision)
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
			
			String sql = new StringBuilder()
					.append("SELECT\n")
					.append("	vehicle_cd,			\n")
					.append("	vehicle_rev_no,		\n")
					.append("	vehicle_nm,			\n")
					.append("	vehicle_model,		\n")
					.append("	vehicle_maker,		\n")
					.append("	vehicle_type,		\n")
					.append("	vehicle_ton_weight,	\n")
					.append("	bigo,				\n")
					.append("	start_date,			\n")
					.append("	duration_date,		\n")
					.append("	create_user_id,		\n")
					.append("	create_date,		\n")
					.append("	modify_user_id,		\n")
					.append("	modify_reason,		\n")
					.append("	modify_date			\n")
					.append("FROM	tbm_vehicle		\n")
					.append("ORDER BY vehicle_cd ASC, vehicle_rev_no DESC	\n")
					.toString();  

			resultString = super.excuteQueryString(con, sql.toString());
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M909S055100E104()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M909S055100E104()","==== finally ===="+ e.getMessage());
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
	
	// 차량조회(최신 revision), VehicleView.jsp에서도 사용
	public int E105(InoutParameter ioParam){
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
					.append("SELECT\n")
					.append("	vehicle_cd,			\n")
					.append("	vehicle_rev_no,		\n")
					.append("	vehicle_nm,			\n")
					.append("	vehicle_model,		\n")
					.append("	vehicle_maker,		\n")
					.append("	vehicle_type,		\n")
					.append("	vehicle_ton_weight,	\n")
					.append("	bigo,				\n")
					.append("	start_date,			\n")
					.append("	duration_date,		\n")
					.append("	create_user_id,		\n")
					.append("	create_date,		\n")
					.append("	modify_user_id,		\n")
					.append("	modify_reason,		\n")
					.append("	modify_date			\n")
					.append("FROM	tbm_vehicle		\n")
					.append("WHERE TO_CHAR(SYSDATE,'YYYY-MM-DD') BETWEEN  start_date AND duration_date\n")
					.append("ORDER BY vehicle_cd ASC, vehicle_rev_no DESC	\n")
					.toString();  

			resultString = super.excuteQueryString(con, sql.toString());
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M909S055100E105()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M909S055100E105()","==== finally ===="+ e.getMessage());
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

	// 차량 수정,삭제화면에서 데이터 불러오기
	public int E124(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			System.out.println("JSONObject jArray rcvData="+ jArray.toString());
			
			String sql = new StringBuilder()
					.append("SELECT\n")
					.append("	vehicle_cd,			\n")
					.append("	vehicle_rev_no,		\n")
					.append("	vehicle_nm,			\n")
					.append("	vehicle_model,		\n")
					.append("	vehicle_maker,		\n")
					.append("	vehicle_type,		\n")
					.append("	vehicle_ton_weight,	\n")
					.append("	bigo,				\n")
					.append("	start_date,			\n")
					.append("	duration_date,		\n")
					.append("	create_user_id,		\n")
					.append("	create_date,		\n")
					.append("	modify_user_id,		\n")
					.append("	modify_reason,		\n")
					.append("	modify_date			\n")
					.append("FROM	tbm_vehicle		\n")
					.append("WHERE vehicle_cd  = '" + jArray.get("vehicle_cd")  + "' \n")
					.append("  AND revision_no = '" + jArray.get("revision_no") + "' \n")
					.append("ORDER BY vehicle_cd ASC, vehicle_rev_no DESC	\n")
					.toString();  
			
			resultString = super.excuteQueryString(con, sql.toString());
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M909S055100E204()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M909S055100E204()","==== finally ===="+ e.getMessage());
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