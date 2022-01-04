package mes.frame.business.M303;

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
import mes.frame.util.ComBaljuUpdate;
import mes.frame.util.CommonFunction;


/**
 * 개요 : 이벤트ID별 메소드 정의
 */
public class M303S050100 extends SqlAdapter{
	Connection con = null;
	PreparedStatement pstmt = null;
	String resultString = "";
	int resultInt = -1;
	StringBuffer sql = new StringBuffer();
	
	String[][] v_paramArray = new String[0][0]; 
	Class[] optClass = null;
	Object[] optObj = null;
	Object obj = null;
	ComBaljuUpdate varBaljuUpdate = new ComBaljuUpdate(); 
	
	public M303S050100(){
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
			
			Method method = M303S050100.class.getMethod(event,optClass);
			LoggingWriter.setLogDebug(M303S050100.class.getName(),"==== " + event + " EventMethod Create Success ====");

			obj = method.invoke(M303S050100.class.newInstance(),optObj);
			doExcute_result = CommonFunction.getInt(obj.toString());
			
	    } catch (Exception ex) {
	    	doExcute_result = EventDefine.E_DOEXCUTE_INIT;
			ioParam.setMessage(MessageDefine.M_NO_EVENTID);
			LoggingWriter.setLogError(M303S050100.class.getName(),"==== EventID Not define : EVENT ID [ " + ioParam.getEventID() + "]");
	    } finally {
	    	obj = null;
			optClass = null;
			optObj = null;
	    }
	    long endTime = System.currentTimeMillis();
		long runningTime = endTime - startTime;
		LoggingWriter.setLogAll(M303S050100.class.getName(),"==== Query [수행시간  : " + runningTime + " ms]");
		
		return doExcute_result;
	}

	// 생산 실적 '확인'으로 변경
	public int E102(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			con.setAutoCommit(false);
			
			JSONObject jArr = new JSONObject();
    		jArr = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
    		
			String sql = new StringBuilder()
					.append("UPDATE															\n")
					.append("	tbi_production_request										\n")
					.append("SET															\n")
					.append("	work_status = '확인'											\n")
					.append("WHERE															\n")
					.append("	manufacturing_date = '"+jArr.get("manufacturingDate")+"'	\n")
					.append("	AND request_rev_no = '"+jArr.get("requestRevNo")+"'			\n")
					.append("	AND prod_plan_date = '"+jArr.get("prodPlanDate")+"'			\n")
					.append("	AND plan_rev_no = '"+jArr.get("planRevNo")+"'				\n")
					.append("	AND prod_cd = '"+jArr.get("prodCd")+"'						\n")
					.append("	AND prod_rev_no = '"+jArr.get("prodRevNo")+"'				\n")
					.toString();

			resultInt = super.excuteUpdate(con, sql);
			
    		if (resultInt < 0) {
				ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
				con.rollback();
				return EventDefine.E_DOEXCUTE_ERROR ;
			}
    		
			con.commit();
		} catch(Exception e) {
			LoggingWriter.setLogError("M303S020200E102()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M303S020200E102()","==== finally ===="+ e.getMessage());
				}
	    	}
	    }
		ioParam.setResultString(resultString);
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
    	ioParam.setMessage(MessageDefine.M_QUERY_OK);

    	return EventDefine.E_QUERY_RESULT;
	}
	
	// yumsam
	// 생산실적관리 메인테이블 조회
	public int E104(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			
			String sql = new StringBuilder()
					.append("SELECT																\n")
					.append("    A.manufacturing_date, 											\n")
					.append("    C.gugyuk,	 													\n")
					.append("    C.product_nm, 													\n")
					.append("    B.plan_amount, 												\n")
					.append("    B.real_amount, 												\n")
					.append("    A.expiration_date, 											\n")
					.append("    A.loss_rate, 													\n")
					.append("    A.work_status,	 												\n")
					.append("    B.prod_journal_note,	-- 생산일지 비고란							\n")
					.append("    B.plan_storage_mapper,											\n")
					.append("    -- 아래는 서브테이블을 부르기 위한 데이터들	  								\n")
					.append("    A.request_rev_no, 												\n")
					.append("    A.prod_plan_date, 												\n")
					.append("    A.plan_rev_no, 												\n")
					.append("    A.prod_cd, 													\n")
					.append("    A.prod_rev_no 													\n")
					.append("FROM tbi_production_request A 										\n")
					.append("INNER JOIN tbi_production_plan_daily_detail B 						\n")
					.append("    ON A.prod_plan_date = B.prod_plan_date 						\n")
					.append("    AND A.plan_rev_no = B.plan_rev_no 								\n")
					.append("    AND A.prod_cd = B.prod_cd 										\n")
					.append("INNER JOIN tbm_product C 											\n")
					.append("    ON A.prod_cd = C.prod_cd 										\n")
					.append("    AND A.prod_rev_no = C.revision_no 								\n")
					.append("WHERE A.manufacturing_date BETWEEN 								\n")
					.append("	'"+jArray.get("startDate")+"' AND '"+jArray.get("endDate")+"'	\n")
					.append("  AND (work_status = '제출'											\n")
					.append("  OR work_status = '확인')											\n")
					.append("ORDER BY manufacturing_date DESC									\n")
					.toString();

			String ActionCommand = ioParam.getActionCommand();
			if(ActionCommand.startsWith("doQueryTableFieldName")) {
				resultString = super.excuteQueryStringTableFieldName(con, sql);
			} else {
				resultString = super.excuteQueryString(con, sql);
			}
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M303S050100E104()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M303S050100E104()","==== finally ===="+ e.getMessage());
				}
	    	}
	    }
		ioParam.setResultString(resultString);
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
    	ioParam.setMessage(MessageDefine.M_QUERY_OK);

    	return EventDefine.E_QUERY_RESULT;
	}
	
	// 생산 실적 수정
	public int E112(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			con.setAutoCommit(false);
			
			JSONObject jArr = new JSONObject();
    		jArr = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			
    		// 완제품재고 테이블의 '재고일련번호'를 구한다
    		String sql = new StringBuilder()
    				.append("SELECT seq_no								\n")
    				.append("FROM tbi_prod_storage2						\n")
    				.append("WHERE plan_storage_mapper					\n")
    				.append("	= '"+jArr.get("planStorageMapper")+"'	\n")
    				.toString();
    		
    		String storageSeqNo = super.excuteQueryString(con, sql).trim();
    		
    		// 수정생산량 - 기존생산량
    		int setoffAmount = Integer.parseInt(jArr.get("modifyAmount").toString()) 
    							- Integer.parseInt(jArr.get("realAmount").toString());
    		
    		sql = new StringBuilder()
    				.append("UPDATE												\n")
    				.append("	tbi_production_plan_daily_detail				\n")
    				.append("SET												\n")
    				.append("	real_amount = "+jArr.get("modifyAmount")+"		\n")
    				.append("WHERE												\n")
    				.append("	prod_plan_date = '"+jArr.get("prodPlanDate")+"'	\n")
    				.append("	AND plan_rev_no = "+jArr.get("planRevNo")+"		\n")
    				.append("	AND prod_cd = "+jArr.get("prodCd")+"			\n")
    				.append("	AND prod_rev_no = "+jArr.get("prodRevNo")+"		\n")
    				.toString();
    		
    		resultInt = super.excuteUpdate(con, sql);
    		if (resultInt < 0) {
				ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
				con.rollback();
				return EventDefine.E_DOEXCUTE_ERROR ;
			}
    		
    		sql = new StringBuilder()
					.append("INSERT INTO							\n")
					.append("	tbi_prod_ipgo2 (					\n")
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
					.append("	'"+jArr.get("manufacturingDate")+"',\n")
					.append("	"+storageSeqNo+",					\n")
					.append("	'"+jArr.get("prodCd")+"',			\n")
					.append("	"+jArr.get("prodRevNo")+",			\n")
					.append("	SYSDATE,							\n")
					.append("	SYSTIME,							\n")
					.append("	" + setoffAmount + ",				\n")
					.append("	'생산실적수정'							\n")
					.append("	);									\n")
					.toString();
    		
    		resultInt = super.excuteUpdate(con, sql);
    		if (resultInt < 0) {
				ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
				con.rollback();
				return EventDefine.E_DOEXCUTE_ERROR;
			}
    		
    		sql = new StringBuilder()
    				.append("UPDATE													\n")
    				.append("	tbi_prod_storage2									\n")
    				.append("SET													\n")
    				.append("	pre_amt = post_amt,									\n")
    				.append("	io_amt = "+setoffAmount+",							\n")
    				.append("	post_amt = post_amt + ("+setoffAmount+")			\n")
    				.append("WHERE prod_date = '"+jArr.get("manufacturingDate")+"'	\n")
    				.append("  AND seq_no = " + storageSeqNo + "					\n")
    				.append("  AND prod_cd = '"+jArr.get("prodCd")+"'				\n")
    				.append("  AND prod_rev_no = "+jArr.get("prodRevNo")+"			\n")
    				.toString();
    		
    		resultInt = super.excuteUpdate(con, sql);
    		if (resultInt < 0) {
				ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
				con.rollback();
				return EventDefine.E_DOEXCUTE_ERROR;
			}
    		
			sql = new StringBuilder()
				.append("UPDATE															\n")
				.append("	tbi_production_request										\n")
				.append("SET															\n")
				.append("	note = '"+jArr.get("note")+"'								\n")
				.append("WHERE															\n")
				.append("	manufacturing_date = '"+jArr.get("manufacturingDate")+"'	\n")
				.append("	AND request_rev_no = '"+jArr.get("requestRevNo")+"'			\n")
				.append("	AND prod_plan_date = '"+jArr.get("prodPlanDate")+"'			\n")
				.append("	AND plan_rev_no = '"+jArr.get("planRevNo")+"'				\n")
				.append("	AND prod_cd = '"+jArr.get("prodCd")+"'						\n")
				.append("	AND prod_rev_no = '"+jArr.get("prodRevNo")+"'				\n")
				.toString();
			 
			resultInt = super.excuteUpdate(con, sql);
			 
			if (resultInt < 0) { 
				ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
				con.rollback(); return EventDefine.E_DOEXCUTE_ERROR ; 
			}
    		
			con.commit();
		} catch(Exception e) {
			LoggingWriter.setLogError("M303S020200E112()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M303S020200E112()","==== finally ===="+ e.getMessage());
				}
	    	}
	    }
		ioParam.setResultString(resultString);
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
    	ioParam.setMessage(MessageDefine.M_QUERY_OK);

    	return EventDefine.E_QUERY_RESULT;
	}
	
	// 생산 실적 삭제
	public int E113(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		try {
			con = JDBCConnectionPool.getConnection();
			con.setAutoCommit(false);
			
			String sql;
			
			JSONObject jArr = new JSONObject();
    		jArr = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			
    		// 완제품재고 테이블의 '재고일련번호'를 구한다
    		sql = new StringBuilder()
    				.append("SELECT seq_no								\n")
    				.append("FROM tbi_prod_storage2						\n")
    				.append("WHERE plan_storage_mapper					\n")
    				.append("	= '"+jArr.get("planStorageMapper")+"'	\n")
    				.toString();
    		
    		String storageSeqNo = super.excuteQueryString(con, sql).trim();
    		
    		// 생산작업요청서 삭제
    		sql = new StringBuilder()
    				.append("DELETE FROM													\n")
    				.append("	tbi_production_request										\n")
    				.append("WHERE															\n")
    				.append("	manufacturing_date = '"+jArr.get("manufacturingDate")+"'	\n")
    				//.append("	AND request_rev_no = '"+jArr.get("requestRevNo")+"'			\n")
    				.append("	AND prod_plan_date = '"+jArr.get("prodPlanDate")+"'			\n")
    				.append("	AND plan_rev_no = '"+jArr.get("planRevNo")+"'				\n")
    				.append("	AND prod_cd = '"+jArr.get("prodCd")+"'						\n")
    				.append("	AND prod_rev_no = '"+jArr.get("prodRevNo")+"'				\n")
    				.toString();
    			 
			resultInt = super.excuteUpdate(con, sql);
			 
			if (resultInt < 0) { 
				ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
				con.rollback(); return EventDefine.E_DOEXCUTE_ERROR ; 
			}
    		
			// 일일생산계획_상세, 실제생산량 & 작업요청서 등록여부 초기화
			sql = new StringBuilder()
    				.append("UPDATE												\n")
    				.append("	tbi_production_plan_daily_detail				\n")
    				.append("SET												\n")
    				.append("	real_amount = 0,								\n")
    				.append("	work_ordered_yn = 'N'							\n")
    				.append("WHERE												\n")
    				.append("	prod_plan_date = '"+jArr.get("prodPlanDate")+"'	\n")
    				.append("	AND plan_rev_no = "+jArr.get("planRevNo")+"		\n")
    				.append("	AND prod_cd = "+jArr.get("prodCd")+"			\n")
    				.append("	AND prod_rev_no = "+jArr.get("prodRevNo")+"		\n")
    				.toString();
    		
    		resultInt = super.excuteUpdate(con, sql);
    		if (resultInt < 0) {
				ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
				con.rollback();
				return EventDefine.E_DOEXCUTE_ERROR;
			}
    		
    		// 마이너스 입고량 추가
    		sql = new StringBuilder()
					.append("INSERT INTO							\n")
					.append("	tbi_prod_ipgo2 (					\n")
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
					.append("	'"+jArr.get("manufacturingDate")+"',\n")
					.append("	"+storageSeqNo+",					\n")
					.append("	'"+jArr.get("prodCd")+"',			\n")
					.append("	"+jArr.get("prodRevNo")+",			\n")
					.append("	SYSDATE,							\n")
					.append("	SYSTIME,							\n")
					.append("	-"+jArr.get("realAmount")+",		\n")
					.append("	'생산실적삭제'							\n")
					.append("	);									\n")
					.toString();
    		
    		resultInt = super.excuteUpdate(con, sql);
    		if (resultInt < 0) {
				ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
				con.rollback();
				return EventDefine.E_DOEXCUTE_ERROR;
			}
    		
    		// 재고 테이블에서 에서 실적 수량 차감
    		/*
    		sql = new StringBuilder()
    				.append("UPDATE													\n")
    				.append("	tbi_prod_storage2									\n")
    				.append("SET													\n")
    				.append("	pre_amt = post_amt,									\n")
    				.append("	io_amt = "+jArr.get("realAmount")+",				\n")
    				.append("	post_amt = post_amt - ("+jArr.get("realAmount")+")	\n")
    				.append("WHERE prod_date = '"+jArr.get("manufacturingDate")+"'	\n")
    				.append("  AND seq_no = " + storageSeqNo + "					\n")
    				.append("  AND prod_cd = '"+jArr.get("prodCd")+"'				\n")
    				.append("  AND prod_rev_no = "+jArr.get("prodRevNo")+"			\n")
    				.toString();
    		*/
    		sql = new StringBuilder()
    				.append("DELETE FROM											\n")
    				.append("	tbi_prod_storage2									\n")
    				.append("WHERE prod_date = '"+jArr.get("manufacturingDate")+"'	\n")
    				.append("  AND seq_no = " + storageSeqNo + "					\n")
    				.append("  AND prod_cd = '"+jArr.get("prodCd")+"'				\n")
    				.append("  AND prod_rev_no = "+jArr.get("prodRevNo")+"			\n")
    				.toString();
    		
    		resultInt = super.excuteUpdate(con, sql);
    		if (resultInt < 0) {
				ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
				con.rollback();
				return EventDefine.E_DOEXCUTE_ERROR;
			}
			
			con.commit();
		} catch(Exception e) {
			LoggingWriter.setLogError("M303S020200E113()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M303S020200E113()","==== finally ===="+ e.getMessage());
				}
	    	}
	    }
		ioParam.setResultString(resultString);
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
    	ioParam.setMessage(MessageDefine.M_QUERY_OK);

    	return EventDefine.E_QUERY_RESULT;
	}
	
	// 생산일지조회 메인페이지
	// yumsam
	public int E204(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			
			String sql = new StringBuilder()
					.append("SELECT 													\n")
					.append("	C.product_nm,											\n")
					.append("	C.gugyuk,												\n")
					.append("	B.real_amount,											\n")
					.append("	A.expiration_date,										\n")
					.append("	B.prod_journal_note										\n")
					.append("FROM tbi_production_request A								\n")
					.append("INNER JOIN tbi_production_plan_daily_detail B				\n")
					.append("	ON  A.prod_plan_date = B.prod_plan_date					\n")
					.append("   AND A.plan_rev_no = B.plan_rev_no 						\n")
					.append("   AND A.prod_cd = B.prod_cd 								\n")
					.append("	AND A.prod_rev_no = B.prod_rev_no						\n")
					.append("INNER JOIN tbm_product C									\n")
					.append("	ON A.prod_cd = C.prod_cd								\n")
					.append("	AND A.prod_rev_no = C.revision_no						\n")
					.append("WHERE A.manufacturing_date = '"+ jArray.get("toDate") + "'	\n")
					.append(" AND A.request_rev_no = (SELECT MAX(request_rev_no)  		\n")
					.append("                    	  FROM tbi_production_request D 	\n")
					.append("                         WHERE D.prod_cd = A.prod_cd 		\n")
					.append(" 						  AND D.prod_rev_no = A.prod_rev_no \n")
					.append("                         AND D.prod_plan_date = A.prod_plan_date \n")
					.append("                         AND D.plan_rev_no = A.plan_rev_no) \n")
					.append("AND A.work_status = '확인' \n")
					.toString();
			
			String ActionCommand = ioParam.getActionCommand();
			if(ActionCommand.startsWith("doQueryTableFieldName")) {
				resultString = super.excuteQueryStringTableFieldName(con, sql);
			} else {
				resultString = super.excuteQueryString(con, sql);
			}
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M303S050100E204()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M303S050100E204()","==== finally ===="+ e.getMessage());
				}
	    	}
	    }
		ioParam.setResultString(resultString);
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
    	ioParam.setMessage(MessageDefine.M_QUERY_OK);

    	return EventDefine.E_QUERY_RESULT;
	}
	
}