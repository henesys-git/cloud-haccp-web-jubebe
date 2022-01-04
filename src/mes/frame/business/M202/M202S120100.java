package mes.frame.business.M202;

import java.lang.reflect.Method;
import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.util.Vector;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;

import mes.frame.common.ApprovalActionNo;
import mes.client.conf.Config;
import mes.client.util.TraceKeyGenerator;
import mes.frame.common.EventDefine;
import mes.frame.common.HashObject;
import mes.frame.common.MessageDefine;
import mes.frame.common.QueueProcessing;
import mes.frame.database.JDBCConnectionPool;
import mes.frame.database.SqlAdapter;
import mes.frame.serviceinterface.InoutParameter;
import mes.frame.serviceinterface.LoggingWriter;
import mes.frame.util.CommonFunction;

public class M202S120100 extends SqlAdapter{
	Connection con = null;
	PreparedStatement pstmt = null;
	String resultString = "";
	int resultInt = -1;
	StringBuffer sql = new StringBuffer();
	
	String[][] v_paramArray = new String[0][0]; 
	Class[] optClass = null;
	Object[] optObj = null;
	Object obj = null;
	
	public M202S120100(){
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
			
			Method method = M202S120100.class.getMethod(event,optClass);
			LoggingWriter.setLogDebug(M202S120100.class.getName(),"==== " + event + " EventMethod Create Success ====");

			obj = method.invoke(M202S120100.class.newInstance(),optObj);
			doExcute_result = CommonFunction.getInt(obj.toString());
			
	    } catch (Exception ex) {
	    	doExcute_result = EventDefine.E_DOEXCUTE_INIT;
			ioParam.setMessage(MessageDefine.M_NO_EVENTID);
			LoggingWriter.setLogError(M202S120100.class.getName(),"==== EventID Not define : EVENT ID [ " + ioParam.getEventID() + "]");
	    } finally {
	    	obj = null;
			optClass = null;
			optObj = null;
	    }
	    long endTime = System.currentTimeMillis();
		long runningTime = endTime - startTime;
		LoggingWriter.setLogAll(M202S120100.class.getName(),"==== Query [수행시간  : " + runningTime + " ms]");
		
		return doExcute_result;
	}

	/* 
	 * 역할 : 자재입고 직접 등록 (발주 없이) 
	 * 설명 : 재고 테이블의 재고를 늘림 (tbi_part_ipgo, tbi_part_storage)
	 * */
	public int E101(InoutParameter ioParam) {
		resultInt = EventDefine.E_DOEXCUTE_INIT;

		String sql = "";
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArr = new JSONObject();
    		jArr = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
    		JSONArray jArrBody = (JSONArray) jArr.get("param");
    		JSONObject jo = (JSONObject) jArrBody.get(0);
    		
			con.setAutoCommit(false);

			String trace_key = TraceKeyGenerator.generateTraceKey();
			
    		sql = new StringBuilder()
				.append("INSERT INTO tbi_part_storage2 (			\n")
				.append("		trace_key,							\n")
				.append("		part_cd, 							\n")
				.append("		part_rev_no, 						\n")
				.append("		pre_amt, 							\n")
				.append("		io_amt, 							\n")
				.append("		post_amt, 							\n")
				.append("		warehousing_date, 					\n")
				.append("		expiration_date, 					\n")
				.append("		note 								\n")
				.append("	)										\n")
				.append("VALUES(									\n")
				.append("		'"+trace_key+"',					\n")
				.append("		'"+jo.get("part_cd")+"',			\n")
				.append("		'"+jo.get("part_rev_no")+"',		\n")
				.append("		0,									\n")
				.append("		'"+jo.get("io_count")+"',			\n")
				.append("		'"+jo.get("io_count")+"',			\n")
				.append("		'"+jo.get("warehousing_date")+"',	\n")
				.append("		'"+jo.get("expiration_date")+"',	\n")
				.append("		'"+jo.get("bigo")+"'				\n")
				.append("	);\n")
				.toString();

			resultInt = super.excuteUpdate(con, sql.toString());
    		if (resultInt < 0) {
				ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
				con.rollback();
				return EventDefine.E_DOEXCUTE_ERROR ;
			}
	    		
    		sql = new StringBuilder()
				.append("INSERT INTO tbi_part_ipgo2 (				\n")
				.append("		trace_key,							\n")
				.append("		part_cd,							\n")
				.append("		part_rev_no,						\n")
				.append("		ipgo_date,							\n")
				.append("		ipgo_time,							\n")
				.append("		ipgo_amount,						\n")
				.append("		ipgo_type,							\n")
				.append("		note								\n")
				.append(")											\n")
				.append("VALUES (									\n")
				.append("		'"+trace_key+"',					\n")
				.append("		'"+jo.get("part_cd")+"',			\n")
				.append("		'"+jo.get("part_rev_no")+"',		\n")
				.append("		'"+jo.get("warehousing_date")+"',	\n")
				.append("		SYSTIME,							\n")
				.append("		'"+jo.get("io_count")+"',			\n")
				.append("		'"+jo.get("ipgo_type")+"',			\n")
				.append("		'"+jo.get("bigo")+"'				\n")
				.append(");											\n")
				.toString();

	    	resultInt = super.excuteUpdate(con, sql);
	    	if (resultInt < 0) {
				ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
				con.rollback();
				return EventDefine.E_DOEXCUTE_ERROR;
			}
	    	
			con.commit();
		} catch(Exception e) {
			LoggingWriter.setLogError("M202S120100E101()","==== SQL ERROR ===="+ e.getMessage());
			e.printStackTrace();
			return EventDefine.E_DOEXCUTE_ERROR;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M202S120100E101()","==== finally ===="+ e.getMessage());
				}
	    	}
	    }
		ioParam.setResultString(resultString);
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
    	ioParam.setMessage(MessageDefine.M_QUERY_OK);
    	
	    return EventDefine.E_QUERY_RESULT;
	}
	
	/* 
	 * 역할 : 재고보정(PLUS)
	 * 설명 : 재고 테이블의 재고를 늘림 (tbi_part_ipgo, tbi_part_storage)
	 * */
	public int E111(InoutParameter ioParam) {
		resultInt = EventDefine.E_DOEXCUTE_INIT;

		String sql ="";
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArr = new JSONObject();
    		jArr = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
    		JSONArray jArrBody = (JSONArray) jArr.get("param");
    		JSONObject jo = (JSONObject) jArrBody.get(0);
    		
			con.setAutoCommit(false);
			
			sql = new StringBuilder()
					.append("UPDATE tbi_part_storage2							\n")
					.append("SET 												\n")
					.append("	pre_amt = post_amt,								\n")
					.append("	io_amt = "+jo.get("io_count")+",				\n")
					.append("	post_amt = post_amt + "+jo.get("io_count")+"	\n")
					.append("WHERE trace_key = "+jo.get("trace_key")+"			\n")
					.append("  AND part_cd = '"+jo.get("part_cd")+"'			\n")
					.append("  AND part_rev_no = "+jo.get("part_rev_no")+"		\n")
					.toString();

				resultInt = super.excuteUpdate(con, sql);
	    		if (resultInt < 0) {
					ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
					con.rollback();
					return EventDefine.E_DOEXCUTE_ERROR;
				}
		    		
	    		sql = new StringBuilder()
					.append("INSERT INTO tbi_part_ipgo2 (			\n")
					.append("		trace_key,						\n")
					.append("		part_cd,						\n")
					.append("		part_rev_no,					\n")
					.append("		ipgo_date,						\n")
					.append("		ipgo_time,						\n")
					.append("		ipgo_amount,					\n")
					.append("		ipgo_type,						\n")
					.append("		note							\n")
					.append(")										\n")
					.append("VALUES (								\n")
					.append("		"+jo.get("trace_key")+",		\n")
					.append("		'"+jo.get("part_cd")+"',		\n")
					.append("		"+jo.get("part_rev_no")+",		\n")
					.append("		'"+jo.get("ipgo_date")+"',		\n")
					.append("		SYSTIME,						\n")
					.append("		'"+jo.get("io_count")+"',		\n")
					.append("		'"+jo.get("ipgo_type")+"',		\n")
					.append("		'"+jo.get("bigo")+"'			\n")
					.append(");										\n")
					.toString();

	    	resultInt = super.excuteUpdate(con, sql);
	    	if (resultInt < 0) {
				ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
				con.rollback();
				return EventDefine.E_DOEXCUTE_ERROR;
			}
	    	
			con.commit();
		} catch(Exception e) {
			LoggingWriter.setLogError("M202S120100E111()","==== SQL ERROR ===="+ e.getMessage());
			e.printStackTrace();
			return EventDefine.E_DOEXCUTE_ERROR;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M202S120100E111()","==== finally ===="+ e.getMessage());
				}
	    	}
	    }
		ioParam.setResultString(resultString);
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
    	ioParam.setMessage(MessageDefine.M_QUERY_OK);
    	
	    return EventDefine.E_QUERY_RESULT;
	}
	
	/* 
	 * 역할 : 재고보정(MINUS)
	 * 설명 : 재고 테이블의 재고를 수동으로 줄임 (tbi_part_chulgo, tbi_part_storage)
	 * */
	public int E201(InoutParameter ioParam) {
		resultInt = EventDefine.E_DOEXCUTE_INIT;

		String sql ="";
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArr = new JSONObject();
    		jArr = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
    		JSONArray jArrBody = (JSONArray) jArr.get("param");
    		JSONObject jo = (JSONObject) jArrBody.get(0);
    		
			con.setAutoCommit(false);
			
    		sql = new StringBuilder()
				.append("UPDATE tbi_part_storage2							\n")
				.append("SET 												\n")
				.append("	pre_amt = post_amt,								\n")
				.append("	io_amt = "+jo.get("io_count")+",				\n")
				.append("	post_amt = post_amt - "+jo.get("io_count")+"	\n")
				.append("WHERE trace_key = "+jo.get("trace_key")+"			\n")
				.append("  AND part_cd = '"+jo.get("part_cd")+"'			\n")
				.append("  AND part_rev_no = "+jo.get("part_rev_no")+"		\n")
				.toString();

			resultInt = super.excuteUpdate(con, sql);
    		if (resultInt < 0) {
				ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
				con.rollback();
				return EventDefine.E_DOEXCUTE_ERROR;
			}
	    		
    		sql = new StringBuilder()
				.append("INSERT INTO tbi_part_chulgo2 (			\n")
				.append("		trace_key,						\n")
				.append("		part_cd,						\n")
				.append("		part_rev_no,					\n")
				.append("		chulgo_date,					\n")
				.append("		chulgo_time,					\n")
				.append("		chulgo_amount,					\n")
				.append("		chulgo_type,					\n")
				.append("		note							\n")
				.append(")										\n")
				.append("VALUES (								\n")
				.append("		"+jo.get("trace_key")+",		\n")
				.append("		'"+jo.get("part_cd")+"',		\n")
				.append("		"+jo.get("part_rev_no")+",		\n")
				.append("		'"+jo.get("chulgo_date")+"',	\n")
				.append("		SYSTIME,						\n")
				.append("		'"+jo.get("io_count")+"',		\n")
				.append("		'"+jo.get("chulgo_type")+"',	\n")
				.append("		'"+jo.get("bigo")+"'			\n")
				.append(");										\n")
				.toString();
    		
	    	resultInt = super.excuteUpdate(con, sql);
	    	if (resultInt < 0) {
				ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
				con.rollback();
				return EventDefine.E_DOEXCUTE_ERROR;
			}
	    	
			con.commit();
		} catch(Exception e) {
			LoggingWriter.setLogError("M202S120100E201()","==== SQL ERROR ===="+ e.getMessage());
			e.printStackTrace();
			return EventDefine.E_DOEXCUTE_ERROR;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M202S120100E201()","==== finally ===="+ e.getMessage());
				}
	    	}
	    }
		ioParam.setResultString(resultString);
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
    	ioParam.setMessage(MessageDefine.M_QUERY_OK);
    	
	    return EventDefine.E_QUERY_RESULT;
	}
	
	/* 
	 * 역할 : 원부자재 입고
	 * 설명 : 재고 테이블의 재고를 늘림 (tbi_part_ipgo, tbi_part_storage)
	 * */
	public int E121(InoutParameter ioParam) {
		resultInt = EventDefine.E_DOEXCUTE_INIT;

		String sql ="";
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArr = new JSONObject();
    		jArr = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
    		JSONArray jArrBody = (JSONArray) jArr.get("param");
    		JSONObject jo = (JSONObject) jArrBody.get(0);
    		
			con.setAutoCommit(false);
			
			sql = new StringBuilder()
					.append("UPDATE tbi_part_storage2							\n")
					.append("SET 												\n")
					.append("	pre_amt = post_amt,								\n")
					.append("	io_amt = "+jo.get("io_count")+",				\n")
					.append("	post_amt = post_amt + "+jo.get("io_count")+"	\n")
					.append("WHERE trace_key = "+jo.get("trace_key")+"			\n")
					.append("  AND part_cd = '"+jo.get("part_cd")+"'			\n")
					.append("  AND part_rev_no = "+jo.get("part_rev_no")+"		\n")
					.toString();

				resultInt = super.excuteUpdate(con, sql);
	    		if (resultInt < 0) {
					ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
					con.rollback();
					return EventDefine.E_DOEXCUTE_ERROR;
				}
		    		
	    		sql = new StringBuilder()
					.append("INSERT INTO tbi_part_ipgo2 (			\n")
					.append("		trace_key,						\n")
					.append("		part_cd,						\n")
					.append("		part_rev_no,					\n")
					.append("		ipgo_date,						\n")
					.append("		ipgo_time,						\n")
					.append("		ipgo_amount,					\n")
					.append("		ipgo_type,						\n")
					.append("		note							\n")
					.append(")										\n")
					.append("VALUES (								\n")
					.append("		"+jo.get("trace_key")+",		\n")
					.append("		'"+jo.get("part_cd")+"',		\n")
					.append("		"+jo.get("part_rev_no")+",		\n")
					.append("		'"+jo.get("ipgo_date")+"',		\n")
					.append("		SYSTIME,						\n")
					.append("		'"+jo.get("io_count")+"',		\n")
					.append("		'"+jo.get("ipgo_type")+"',		\n")
					.append("		'"+jo.get("bigo")+"'			\n")
					.append(");										\n")
					.toString();

	    	resultInt = super.excuteUpdate(con, sql);
	    	if (resultInt < 0) {
				ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
				con.rollback();
				return EventDefine.E_DOEXCUTE_ERROR;
			}
	    	
			con.commit();
		} catch(Exception e) {
			LoggingWriter.setLogError("M202S120100E121()","==== SQL ERROR ===="+ e.getMessage());
			e.printStackTrace();
			return EventDefine.E_DOEXCUTE_ERROR;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M202S120100E121()","==== finally ===="+ e.getMessage());
				}
	    	}
	    }
		ioParam.setResultString(resultString);
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
    	ioParam.setMessage(MessageDefine.M_QUERY_OK);
    	
	    return EventDefine.E_QUERY_RESULT;
	}
	
	/* 
	 * 역할 : 원부자재 출고
	 * 설명 : 재고 테이블의 재고를 차감 (tbi_part_chulgo, tbi_part_storage)
	 * */
	public int E131(InoutParameter ioParam) {
		resultInt = EventDefine.E_DOEXCUTE_INIT;

		String sql ="";
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArr = new JSONObject();
    		jArr = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
    		JSONArray jArrBody = (JSONArray) jArr.get("param");
    		JSONObject jo = (JSONObject) jArrBody.get(0);
    		
			con.setAutoCommit(false);
			
    		sql = new StringBuilder()
				.append("UPDATE tbi_part_storage2							\n")
				.append("SET 												\n")
				.append("	pre_amt = post_amt,								\n")
				.append("	io_amt = "+jo.get("io_count")+",				\n")
				.append("	post_amt = post_amt - "+jo.get("io_count")+"	\n")
				.append("WHERE trace_key = "+jo.get("trace_key")+"			\n")
				.append("  AND part_cd = '"+jo.get("part_cd")+"'			\n")
				.append("  AND part_rev_no = "+jo.get("part_rev_no")+"		\n")
				.toString();

			resultInt = super.excuteUpdate(con, sql);
    		if (resultInt < 0) {
				ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
				con.rollback();
				return EventDefine.E_DOEXCUTE_ERROR;
			}
	    		
    		sql = new StringBuilder()
				.append("INSERT INTO tbi_part_chulgo2 (			\n")
				.append("		trace_key,						\n")
				.append("		part_cd,						\n")
				.append("		part_rev_no,					\n")
				.append("		chulgo_date,					\n")
				.append("		chulgo_time,					\n")
				.append("		chulgo_amount,					\n")
				.append("		chulgo_type,					\n")
				.append("		note							\n")
				.append(")										\n")
				.append("VALUES (								\n")
				.append("		"+jo.get("trace_key")+",		\n")
				.append("		'"+jo.get("part_cd")+"',		\n")
				.append("		"+jo.get("part_rev_no")+",		\n")
				.append("		'"+jo.get("chulgo_date")+"',	\n")
				.append("		SYSTIME,						\n")
				.append("		'"+jo.get("io_count")+"',		\n")
				.append("		'"+jo.get("chulgo_type")+"',	\n")
				.append("		'"+jo.get("bigo")+"'			\n")
				.append(");										\n")
				.toString();
    		
	    	resultInt = super.excuteUpdate(con, sql);
	    	if (resultInt < 0) {
				ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
				con.rollback();
				return EventDefine.E_DOEXCUTE_ERROR;
			}
	    	
			con.commit();
		} catch(Exception e) {
			LoggingWriter.setLogError("M202S120100E131()","==== SQL ERROR ===="+ e.getMessage());
			e.printStackTrace();
			return EventDefine.E_DOEXCUTE_ERROR;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M202S120100E131()","==== finally ===="+ e.getMessage());
				}
	    	}
	    }
		ioParam.setResultString(resultString);
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
    	ioParam.setMessage(MessageDefine.M_QUERY_OK);
    	
	    return EventDefine.E_QUERY_RESULT;
	}
	
	public int E104(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			System.out.println("JSONObject jArray rcvData="+ jArray.toString());
			
			String sql = new StringBuilder()
					.append("SELECT\n")
					.append("	C.code_name AS gubun_b,\n")
					.append("	D.code_name AS gubun_m,\n")
					.append("	A.part_cd,\n")
					.append("	B.part_nm,\n")
					.append("	A.warehousing_date,\n")
					.append("	A.expiration_date,\n")
					.append("	A.post_amt,\n")
					.append("	A.note,\n")
					.append("	A.trace_key,\n")
					.append("	A.part_rev_no\n")
					.append("FROM tbi_part_storage2 A\n")
					.append("INNER JOIN tbm_part_list B\n")
					.append("	ON A.part_cd = B.part_cd\n")
					.append("INNER JOIN v_partgubun_big C\n")
					.append("	ON B.part_gubun_b = C.code_value\n")
					.append("INNER JOIN v_partgubun_mid D\n")
					.append("	ON B.part_gubun_m = D.code_value\n")
					.append("WHERE post_amt > 0												\n")
					.append("AND part_gubun_b like '" + jArray.get("partgubun_big") + "%' " +
							"AND part_gubun_m like '" + jArray.get("partgubun_mid") + "%'	\n")
					.append("ORDER BY warehousing_date DESC									\n")
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
			LoggingWriter.setLogError("M202S120100E104()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M202S120100E104()","==== finally ===="+ e.getMessage());
				}
	    	} else {
	    	}
	    }
		ioParam.setResultString(resultString);
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
    	ioParam.setMessage(MessageDefine.M_QUERY_OK);
    	
	    return EventDefine.E_QUERY_RESULT;
	}
	
	//원부재료 입고 정보 팝업페이지 조회용
	public int E106(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			System.out.println("JSONObject jArray rcvData="+ jArray.toString());
			
			String sql = new StringBuilder()
					.append("SELECT\n")
					.append("	C.code_name AS gubun_b,	\n")
					.append("	D.code_name AS gubun_m,	\n")
					.append("	A.part_cd,				\n")
					.append("	B.part_nm,				\n")
					.append("	A.warehousing_date,		\n")
					.append("	A.expiration_date,		\n")
					.append("	A.io_amt,				\n")
					.append("	A.note,					\n")
					.append("	A.trace_key,			\n")
					.append("	A.part_rev_no,			\n")
					.append("   E.balju_no, 			\n")
					.append("   E.balju_rev_no 			\n")
					.append("FROM tbi_part_storage2 A							\n")
					.append("INNER JOIN tbm_part_list B							\n")
					.append("	ON A.part_cd = B.part_cd						\n")
					.append("	AND A.part_rev_no = B.revision_no				\n")
					.append("INNER JOIN v_partgubun_big C						\n")
					.append("	ON B.part_gubun_b = C.code_value				\n")
					.append("INNER JOIN v_partgubun_mid D						\n")
					.append("	ON B.part_gubun_m = D.code_value				\n")
					.append("INNER JOIN tbi_balju_list2 E						\n")
					.append("   ON A.part_cd = E.part_cd 						\n")
					.append("   AND A.part_rev_no = E.part_rev_no 				\n")
					.append("   AND A.trace_key = E.trace_key  					\n")
					.append("WHERE io_amt > 0									\n")
					.append("AND A.warehousing_date = '" + jArray.get("ipgo_date") + "' \n")
					.append("AND C.code_name = '재료' 								\n")
					.append("AND E.balju_status = '입고완료' 							\n")
					.append("AND E.doc_regist_yn = 'N' 								\n")
					.append("ORDER BY A.warehousing_date DESC						 \n")
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
			LoggingWriter.setLogError("M202S120100E106()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M202S120100E106()","==== finally ===="+ e.getMessage());
				}
	    	} else {
	    	}
	    }
		ioParam.setResultString(resultString);
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
    	ioParam.setMessage(MessageDefine.M_QUERY_OK);
    	
	    return EventDefine.E_QUERY_RESULT;
	}
	
	
	//부자재 입고 정보 팝업페이지 조회용
		public int E107(InoutParameter ioParam){
			resultInt = EventDefine.E_DOEXCUTE_INIT;
			try {
				con = JDBCConnectionPool.getConnection();
				
				JSONObject jArray = new JSONObject();
				jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
				System.out.println("JSONObject jArray rcvData="+ jArray.toString());
				
				String sql = new StringBuilder()
						.append("SELECT\n")
						.append("	C.code_name AS gubun_b,		\n")
						.append("	D.code_name AS gubun_m,		\n")
						.append("	A.part_cd,					\n")
						.append("	B.part_nm,					\n")
						.append("	A.warehousing_date,			\n")
						.append("	A.expiration_date,			\n")
						.append("	A.io_amt,					\n")
						.append("	A.note,						\n")
						.append("	A.trace_key,				\n")
						.append("	A.part_rev_no,				\n")
						.append("   E.balju_no, 				\n")
						.append("   E.balju_rev_no 				\n")
						.append("FROM tbi_part_storage2 A							\n")
						.append("INNER JOIN tbm_part_list B							\n")
						.append("	ON A.part_cd = B.part_cd						\n")
						.append("	AND A.part_rev_no = B.revision_no				\n")
						.append("INNER JOIN v_partgubun_big C						\n")
						.append("	ON B.part_gubun_b = C.code_value				\n")
						.append("INNER JOIN v_partgubun_mid D						\n")
						.append("	ON B.part_gubun_m = D.code_value				\n")
						.append("INNER JOIN tbi_balju_list2 E						\n")
						.append("   ON A.part_cd = E.part_cd 						\n")
						.append("   AND A.part_rev_no = E.part_rev_no 				\n")
						.append("   AND A.trace_key = E.trace_key  					\n")
						.append("WHERE io_amt > 0									\n")
						.append("AND A.warehousing_date = '" + jArray.get("ipgo_date") + "' \n")
						.append("AND C.code_name = '부자재' 							\n")
						.append("AND E.balju_status = '입고완료' 						\n")
						.append("AND E.doc_regist_yn = 'N' 							\n")
						.append("ORDER BY A.warehousing_date DESC					\n")
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
				LoggingWriter.setLogError("M202S120100E107()","==== SQL ERROR ===="+ e.getMessage());
				return EventDefine.E_DOEXCUTE_ERROR ;
		    } finally {
		    	if (Config.useDataSource) {
					try {
						if (con != null) con.close();
					} catch (Exception e) {
						LoggingWriter.setLogError("M202S120100E106()","==== finally ===="+ e.getMessage());
					}
		    	} else {
		    	}
		    }
			ioParam.setResultString(resultString);
			ioParam.setColumnCount("" + super.COLUMN_COUNT);
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
					.append("SELECT														\n")
					.append("	C.part_nm,												\n")
					.append("	A.ipgo_date AS io_date,									\n")
					.append("	A.ipgo_time AS io_time,									\n")
					.append("	A.ipgo_amount AS io_amount,								\n")
					.append("	A.ipgo_type AS io_type,									\n")
					.append("	A.note,													\n")
					.append("	'1' AS sortation										\n")
					.append("FROM tbi_part_ipgo2 A										\n")
					.append("INNER JOIN tbi_part_storage2 B								\n")
					.append("	ON A.trace_key = B.trace_key							\n")
					.append("	AND A.part_cd = B.part_cd								\n")
					.append("	AND A.part_rev_no = B.part_rev_no						\n")
					.append("INNER JOIN tbm_part_list C									\n")
					.append("	ON A.part_cd = C.part_cd								\n")
					.append("	AND A.part_rev_no = C.revision_no						\n")
					.append("WHERE A.trace_key = " + jArray.get("trace_key") + "		\n")
					.append("	AND A.part_cd = '" + jArray.get("part_cd") + "'			\n")
					.append("	AND A.part_rev_no = " + jArray.get("part_rev_no") + "	\n")
					
					.append("UNION ALL													\n")
					
					.append("SELECT														\n")
					.append("	C.part_nm,												\n")
					.append("	A.chulgo_date AS io_date,								\n")
					.append("	A.chulgo_time AS io_time,								\n")
					.append("	A.chulgo_amount AS io_amount,							\n")
					.append("	A.chulgo_type AS io_type,								\n")
					.append("	A.note,													\n")
					.append("	'2' AS sortation										\n")
					.append("FROM tbi_part_chulgo2 A									\n")
					.append("INNER JOIN tbi_part_storage2 B								\n")
					.append("	ON A.trace_key = B.trace_key							\n")
					.append("	AND A.part_cd = B.part_cd								\n")
					.append("	AND A.part_rev_no = B.part_rev_no						\n")
					.append("INNER JOIN tbm_part_list C									\n")
					.append("	ON A.part_cd = C.part_cd								\n")
					.append("	AND A.part_rev_no = C.revision_no						\n")
					.append("WHERE A.trace_key = " + jArray.get("trace_key") + "		\n")
					.append("	AND A.part_cd = '" + jArray.get("part_cd") + "'			\n")
					.append("	AND A.part_rev_no = " + jArray.get("part_rev_no") + "	\n")
					.append("ORDER BY io_date DESC, io_time DESC						\n")
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
			LoggingWriter.setLogError("M202S120100E114()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M202S120100E114()","==== finally ===="+ e.getMessage());
				}
	    	} else {
	    	}
	    }
		ioParam.setResultString(resultString);
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
    	ioParam.setMessage(MessageDefine.M_QUERY_OK);
	    return EventDefine.E_QUERY_RESULT;
	}
	
	public int E999(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			String rcvData = (String)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			String[][] c_paramArray = CommonFunction.getConvString2DoubleArray(rcvData);
			String sql = new StringBuilder()
					.append("WITH order_balju AS(\n")
					.append("	SELECT balju_no FROM tbi_balju WHERE order_no = '" + c_paramArray[0][0] + "'\n")
					.append("),\n")
					.append("balju_list_cnt AS(\n")
					.append("SELECT COUNT(*)   AS balju_list_Count FROM tbi_balju_list A, order_balju  WHERE A.balju_no= order_balju.balju_no\n")
					.append("),\n")
					.append("balju_Inspect_cnt AS(\n")
					.append("SELECT  COUNT(*) AS balju_Inspect_Count FROM tbi_balju_list_inspect B, order_balju WHERE B.balju_no=order_balju.balju_no\n")
					.append("),\n")
					.append("import_request_cnt AS(\n")
					.append("SELECT  COUNT(*) AS import_request_Count FROM tbi_import_inspect_request C, order_balju WHERE order_no ='" + c_paramArray[0][0] + "' AND C.balju_no=order_balju.balju_no\n")
					.append(")\n")
					.append("SELECT  ' 주문번호: " + c_paramArray[0][0] + "의 발주원부자재 수: ' || balju_list_Count || '건,'  || \n")
					.append("		' 발주원부자재 검수 수:' || balju_Inspect_Count || '건,'  || \n")
					.append("		' 발주원부자재 수입검사 신청 수:' || import_request_Count || '건' , \n")
					.append("		balju_list_Count,\n")
					.append("		balju_Inspect_Count ,\n")
					.append("		import_request_Count \n")
					.append("FROM balju_list_cnt, balju_Inspect_cnt, import_request_cnt;\n")
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
			LoggingWriter.setLogError("M202S120100E999()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M202S120100E999()","==== finally ===="+ e.getMessage());
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