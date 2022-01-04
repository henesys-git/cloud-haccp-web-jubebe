package mes.frame.business.M858;

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

public class M858S060100 extends SqlAdapter{
	Connection con = null;
	PreparedStatement pstmt = null;
	String resultString = "";
	int resultInt = -1;
	StringBuffer sql = new StringBuffer();
	
	String[][] v_paramArray = new String[0][0]; 
	Class[] optClass = null;
	Object[] optObj = null;
	Object obj = null;
	
	public M858S060100(){
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
			
			Method method = M858S060100.class.getMethod(event,optClass);
			LoggingWriter.setLogDebug(M858S060100.class.getName(),"==== " + event + " EventMethod Create Success ====");

			obj = method.invoke(M858S060100.class.newInstance(),optObj);
			doExcute_result = CommonFunction.getInt(obj.toString());
			
	    } catch (Exception ex) {
	    	doExcute_result = EventDefine.E_DOEXCUTE_INIT;
			ioParam.setMessage(MessageDefine.M_NO_EVENTID);
			LoggingWriter.setLogError(M858S060100.class.getName(),"==== EventID Not define : EVENT ID [ " + ioParam.getEventID() + "]");
	    } finally {
	    	obj = null;
			optClass = null;
			optObj = null;
	    }
	    long endTime = System.currentTimeMillis();
		long runningTime = endTime - startTime;
		LoggingWriter.setLogAll(M858S060100.class.getName(),"==== Query [수행시간  : " + runningTime + " ms]");
		
		return doExcute_result;
	}

	/* 
	 * 역할 : 자재입고 직접 등록 (발주 없이) 
	 * 설명 : 재고 테이블의 재고를 늘림 (tbi_prod_ipgo, tbi_prod_storage)
	 * */
	public int E101(InoutParameter ioParam) {
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
				.append("INSERT INTO tbi_prod_storage2 (		\n")
				.append("	prod_date,							\n")
				.append("	seq_no,								\n")
				.append("	prod_cd, 							\n")
				.append("	prod_rev_no, 						\n")
				.append("	pre_amt, 							\n")
				.append("	io_amt, 							\n")
				.append("	post_amt, 							\n")
				.append("	expiration_date, 					\n")
				.append("	note 								\n")
				.append(")										\n")
				.append("VALUES (								\n")
				.append("	'"+jo.get("ipgo_date")+"',			\n")
				.append("	(SELECT MAX(seq_no) + 1 			\n")
				.append("	FROM tbi_prod_storage2),			\n")
				.append("	'"+jo.get("prod_cd")+"',			\n")
				.append("	"+jo.get("prod_rev_no")+",			\n")
				.append("	0,									\n")
				.append("	'"+jo.get("io_count")+"',			\n")
				.append("	'"+jo.get("io_count")+"',			\n")
				.append("	'"+jo.get("expiration_date")+"',	\n")
				.append("	'"+jo.get("ipgo")+"'				\n")
				.append(");\n")
				.toString();

			resultInt = super.excuteUpdate(con, sql.toString());
    		if (resultInt < 0) {
				ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
				con.rollback();
				return EventDefine.E_DOEXCUTE_ERROR ;
			}
	    		
    		sql = new StringBuilder()
				.append("INSERT INTO tbi_prod_ipgo2 (	\n")
				.append("	prod_date,					\n")
				.append("	seq_no,						\n")
				.append("	prod_cd,					\n")
				.append("	prod_rev_no,				\n")
				.append("	ipgo_date,					\n")
				.append("	ipgo_time,					\n")
				.append("	ipgo_amount,				\n")
				.append("	ipgo_type,					\n")
				.append("	note						\n")
				.append(")								\n")
				.append("VALUES (						\n")
				.append("	'"+jo.get("ipgo_date")+"',	\n")
				.append("	(SELECT MAX(seq_no)		 	\n")
				.append("	FROM tbi_prod_storage2),	\n")
				.append("	'"+jo.get("prod_cd")+"',	\n")
				.append("	"+jo.get("prod_rev_no")+",	\n")
				.append("	SYSDATE,					\n")
				.append("	SYSTIME,					\n")
				.append("	'"+jo.get("io_count")+"',	\n")
				.append("	'"+jo.get("ipgo_type")+"',	\n")
				.append("	'"+jo.get("bigo")+"'		\n")
				.append(");\n")
				.toString();

	    	resultInt = super.excuteUpdate(con, sql);
	    	if (resultInt < 0) {
				ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
				con.rollback();
				return EventDefine.E_DOEXCUTE_ERROR;
			}
	    	
			con.commit();
		} catch(Exception e) {
			LoggingWriter.setLogError("M858S060100E101()","==== SQL ERROR ===="+ e.getMessage());
			e.printStackTrace();
			return EventDefine.E_DOEXCUTE_ERROR;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M858S060100E101()","==== finally ===="+ e.getMessage());
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
	 * 설명 : 재고 테이블의 재고를 늘림 (tbi_prod_ipgo, tbi_prod_storage)
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
					.append("UPDATE tbi_prod_storage2							\n")
					.append("SET 												\n")
					.append("	pre_amt = post_amt,								\n")
					.append("	io_amt = "+jo.get("io_count")+",				\n")
					.append("	post_amt = post_amt + "+jo.get("io_count")+"	\n")
					.append("WHERE prod_date = '"+jo.get("prod_date")+"'		\n")
					.append("  AND seq_no = "+jo.get("seq_no")+"				\n")
					.append("  AND prod_cd = '"+jo.get("prod_cd")+"'			\n")
					.append("  AND prod_rev_no = "+jo.get("prod_rev_no")+"		\n")
					.toString();

				resultInt = super.excuteUpdate(con, sql);
	    		if (resultInt < 0) {
					ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
					con.rollback();
					return EventDefine.E_DOEXCUTE_ERROR;
				}
		    		
	    		sql = new StringBuilder()
					.append("INSERT INTO tbi_prod_ipgo2 (			\n")
					.append("		prod_date,						\n")
					.append("		seq_no,							\n")
					.append("		prod_cd,						\n")
					.append("		prod_rev_no,					\n")
					.append("		ipgo_date,						\n")
					.append("		ipgo_time,						\n")
					.append("		ipgo_amount,					\n")
					.append("		ipgo_type,						\n")
					.append("		note							\n")
					.append(")										\n")
					.append("VALUES (								\n")
					.append("		'"+jo.get("prod_date")+"',		\n")
					.append("		"+jo.get("seq_no")+",			\n")
					.append("		'"+jo.get("prod_cd")+"',		\n")
					.append("		"+jo.get("prod_rev_no")+",		\n")
					.append("		'"+jo.get("ipgo_date")+"',		\n")
					.append("		SYSTIME,						\n")
					.append("		"+jo.get("io_count")+",			\n")
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
			LoggingWriter.setLogError("M858S060100E111()","==== SQL ERROR ===="+ e.getMessage());
			e.printStackTrace();
			return EventDefine.E_DOEXCUTE_ERROR;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M858S060100E111()","==== finally ===="+ e.getMessage());
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
	 * 설명 : 재고 테이블의 재고를 수동으로 줄임 (tbi_prod_ipgo, tbi_prod_storage)
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
				.append("UPDATE tbi_prod_storage2							\n")
				.append("SET 												\n")
				.append("	pre_amt = post_amt,								\n")
				.append("	io_amt = "+jo.get("io_count")+",				\n")
				.append("	post_amt = post_amt + "+jo.get("io_count")+"	\n")
				.append("WHERE prod_date = '"+jo.get("prod_date")+"'		\n")
				.append("  AND seq_no = "+jo.get("seq_no")+"				\n")
				.append("  AND prod_cd = '"+jo.get("prod_cd")+"'			\n")
				.append("  AND prod_rev_no = "+jo.get("prod_rev_no")+"		\n")
				.toString();

			resultInt = super.excuteUpdate(con, sql);
    		if (resultInt < 0) {
				ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
				con.rollback();
				return EventDefine.E_DOEXCUTE_ERROR;
			}
	    	
    		sql = new StringBuilder()
					.append("INSERT INTO tbi_prod_ipgo2 (			\n")
					.append("		prod_date,						\n")
					.append("		seq_no,							\n")
					.append("		prod_cd,						\n")
					.append("		prod_rev_no,					\n")
					.append("		ipgo_date,						\n")
					.append("		ipgo_time,						\n")
					.append("		ipgo_amount,					\n")
					.append("		note							\n")
					.append(")										\n")
					.append("VALUES (								\n")
					.append("		'"+jo.get("prod_date")+"',		\n")
					.append("		"+jo.get("seq_no")+",			\n")
					.append("		'"+jo.get("prod_cd")+"',		\n")
					.append("		"+jo.get("prod_rev_no")+",		\n")
					.append("		SYSDATE,						\n")
					.append("		SYSTIME,						\n")
					.append("		"+jo.get("io_count")+",			\n")
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
			LoggingWriter.setLogError("M858S060100E201()","==== SQL ERROR ===="+ e.getMessage());
			e.printStackTrace();
			return EventDefine.E_DOEXCUTE_ERROR;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M858S060100E201()","==== finally ===="+ e.getMessage());
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
			
			JSONObject jArr = new JSONObject();
			jArr = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			
			String sql = new StringBuilder()
					.append("SELECT														\n")
					.append("	C.code_name AS gubun_b,									\n")
					.append("	D.code_name AS gubun_m,									\n")
					.append("	A.prod_cd,												\n")
					.append("	B.product_nm,											\n")
					.append("	A.prod_date,											\n")
					.append("	A.expiration_date,										\n")
					.append("	A.post_amt,												\n")
					.append("	A.note,													\n")
					.append("	A.seq_no,												\n")
					.append("	A.prod_rev_no											\n")
					.append("FROM tbi_prod_storage2 A									\n")
					.append("INNER JOIN tbm_product B									\n")
					.append("	ON A.prod_cd = B.prod_cd								\n")
					.append("	AND A.prod_rev_no = B.revision_no						\n")
					.append("INNER JOIN v_prodgubun_big C								\n")
					.append("	ON B.prod_gubun_b = C.code_value						\n")
					.append("INNER JOIN v_prodgubun_mid D								\n")
					.append("	ON B.prod_gubun_m = D.code_value						\n")
					.append("WHERE post_amt >= 0										\n")
					.append("  AND prod_gubun_b LIKE '"+jArr.get("prodgubun_big")+"%'	\n")
					.append("  AND prod_gubun_m like '"+jArr.get("prodgubun_mid")+"%'	\n")
					.append("ORDER BY prod_date DESC\n")
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
			LoggingWriter.setLogError("M858S060100E104()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M858S060100E104()","==== finally ===="+ e.getMessage());
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
					.append("	C.product_nm,											\n")
					.append("	C.gugyuk,												\n")
					.append("	A.ipgo_date AS io_date,									\n")
					.append("	A.ipgo_time AS io_time,									\n")
					.append("	A.ipgo_amount AS io_amount,								\n")
					.append("	A.note,													\n")
					.append("	'1' AS sortation										\n")
					.append("FROM tbi_prod_ipgo2 A										\n")
					.append("INNER JOIN tbi_prod_storage2 B								\n")
					.append("	ON A.prod_date = B.prod_date							\n")
					.append("	AND A.seq_no = B.seq_no									\n")
					.append("	AND A.prod_cd = B.prod_cd								\n")
					.append("	AND A.prod_rev_no = B.prod_rev_no						\n")
					.append("INNER JOIN tbm_product C									\n")
					.append("	ON A.prod_cd = C.prod_cd								\n")
					.append("	AND A.prod_rev_no = C.revision_no						\n")
					.append("WHERE A.prod_date = '" + jArray.get("prod_date") + "'		\n")
					.append("	AND A.seq_no = " + jArray.get("seq_no") + "				\n")
					.append("	AND A.prod_cd = '" + jArray.get("prod_cd") + "'			\n")
					.append("	AND A.prod_rev_no = " + jArray.get("prod_rev_no") + "	\n")
					
					.append("UNION ALL													\n")
					
					.append("SELECT														\n")
					.append("	C.product_nm,											\n")
					.append("	C.gugyuk,												\n")
					.append("	A.chulgo_date AS io_date,								\n")
					.append("	A.chulgo_time AS io_time,								\n")
					.append("	A.chulgo_amount AS io_amount,							\n")
					.append("	A.note,													\n")
					.append("	'2' AS sortation										\n")
					.append("FROM tbi_prod_chulgo2 A									\n")
					.append("INNER JOIN tbi_prod_storage2 B								\n")
					.append("	ON A.prod_date = B.prod_date							\n")
					.append("	AND A.seq_no = B.seq_no									\n")
					.append("	AND A.prod_cd = B.prod_cd								\n")
					.append("	AND A.prod_rev_no = B.prod_rev_no						\n")
					.append("INNER JOIN tbm_product C									\n")
					.append("	ON A.prod_cd = C.prod_cd								\n")
					.append("	AND A.prod_rev_no = C.revision_no						\n")
					.append("WHERE A.prod_date = '" + jArray.get("prod_date") + "'		\n")
					.append("	AND A.seq_no = " + jArray.get("seq_no") + "				\n")
					.append("	AND A.prod_cd = '" + jArray.get("prod_cd") + "'			\n")
					.append("	AND A.prod_rev_no = " + jArray.get("prod_rev_no") + "	\n")
					.append("   AND A.chulgo_amount > 0 								\n")
					.append("ORDER BY io_date DESC, io_time DESC						\n")
					.toString();

			String ActionCommand = ioParam.getActionCommand();
			if(ActionCommand.startsWith("doQueryTableFieldName")) {
				resultString = super.excuteQueryStringTableFieldName(con, sql);
			} else {
				resultString = super.excuteQueryString(con, sql);
			}
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M858S060100E114()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M858S060100E114()","==== finally ===="+ e.getMessage());
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