package mes.frame.business.M303;

import java.lang.reflect.Method;
import java.sql.Connection;
import java.sql.PreparedStatement;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;

import mes.client.conf.Config;
import mes.client.util.GeneratorPlanStorageMapper;
import mes.frame.common.EventDefine;
import mes.frame.common.HashObject;
import mes.frame.common.MessageDefine;
import mes.frame.database.JDBCConnectionPool;
import mes.frame.database.SqlAdapter;
import mes.frame.serviceinterface.InoutParameter;
import mes.frame.serviceinterface.LoggingWriter;
import mes.frame.util.CommonFunction;


public class M303S020200 extends SqlAdapter{
	Connection con = null;
	PreparedStatement pstmt = null;
	String resultString = "";
	int resultInt = -1;
	StringBuffer sql = new StringBuffer();
	
	String[][] v_paramArray = new String[0][0]; 
	Class[] optClass = null;
	Object[] optObj = null;
	Object obj = null;
	
	public M303S020200(){
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
			
			Method method = M303S020200.class.getMethod(event,optClass);
			LoggingWriter.setLogDebug(M303S020200.class.getName(),"==== " + event + " EventMethod Create Success ====");

			obj = method.invoke(M303S020200.class.newInstance(),optObj);
			doExcute_result = CommonFunction.getInt(obj.toString());
			
	    } catch (Exception ex) {
	    	doExcute_result = EventDefine.E_DOEXCUTE_INIT;
			ioParam.setMessage(MessageDefine.M_NO_EVENTID);
			LoggingWriter.setLogError(M303S020200.class.getName(),"==== EventID Not define : EVENT ID [ " + ioParam.getEventID() + "]");
	    } finally {
	    	obj = null;
			optClass = null;
			optObj = null;
	    }
	    long endTime = System.currentTimeMillis();
		long runningTime = endTime - startTime;
		LoggingWriter.setLogAll(M303S020200.class.getName(),"==== Query [수행시간  : " + runningTime + " ms]");
		
		return doExcute_result;
	}
	
	//작업지시 등록
	public int E101(InoutParameter ioParam){ 
			resultInt = EventDefine.E_DOEXCUTE_INIT;
			
			try {
				con = JDBCConnectionPool.getConnection();
				
				con.setAutoCommit(false);
				
				JSONObject jArray = new JSONObject();
	    		jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
	    		System.out.println("JSONObject jArray rcvData="+ jArray.toString());
				
	    		JSONObject jArrayHead = (JSONObject) jArray.get("paramHead");
	    		JSONArray jArrayBody = (JSONArray) jArray.get("param");
				
				String sql = new StringBuilder()
						.append("INSERT INTO\n")
						.append("	tbi_production_request (\n")
						.append("		manufacturing_date,\n")
						.append("		request_rev_no,\n")
						.append("		prod_plan_date,\n")
						.append("		plan_rev_no,\n")
						.append("		prod_cd,\n")
						.append("		prod_rev_no,\n")
						.append("		expiration_date,\n")
						.append("		loss_rate,\n")
						.append("		work_status,\n")
						.append("		note\n")
						.append("	)\n")
						.append("VALUES (											\n")
						.append("		'"+jArrayHead.get("dateManufacture")+"',	\n")
						.append("		0,											\n")
						.append("		'"+jArrayHead.get("date_prod_plan")+"',		\n")
						.append("		'"+jArrayHead.get("prod_plan_rev")+"',		\n")
						.append("		'"+jArrayHead.get("prodCd")+"',				\n")
						.append("		'"+jArrayHead.get("prodRevNo")+"',			\n")
						.append("		'"+jArrayHead.get("dateExpiration")+"',		\n")
						.append("		"+jArrayHead.get("loss_rate")+",			\n")
						.append("		'요청',										\n")
						.append("		'"+jArrayHead.get("bigo")+"'				\n")
						.append("	);												\n")
						.toString();

				resultInt = super.excuteUpdate(con, sql);
	    		if (resultInt < 0) {
					ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
					con.rollback();
					return EventDefine.E_DOEXCUTE_ERROR ;
				} else {
					for(int i = 0; i < jArrayBody.size(); i++) {
						
						JSONObject jArrSubBody = (JSONObject)jArrayBody.get(i);
						
						sql = new StringBuilder()
								.append("INSERT INTO\n")
								.append("	tbi_production_request_detail (\n")
								.append("		manufacturing_date,\n")
								.append("		request_rev_no,\n")
								.append("		prod_plan_date,\n")
								.append("		plan_rev_no,\n")
								.append("		prod_cd,\n")
								.append("		prod_rev_no,\n")
								.append("		part_cd,\n")
								.append("		part_rev_no,\n")
								.append("		bom_rev_no,\n")
								.append("		blending_amount_plan,					\n")
								.append("		reason_diff								\n")
								.append(")												\n")
								.append("VALUES (										\n")
								.append("		'"+jArrayHead.get("dateManufacture")+"',\n")
								.append("		0,										\n")
								.append("		'"+jArrayHead.get("date_prod_plan")+"',	\n")
								.append("		"+jArrayHead.get("prod_plan_rev")+",	\n")
								.append("		'"+jArrayHead.get("prodCd")+"',			\n")
								.append("		"+jArrayHead.get("prodRevNo")+",		\n")
								.append("		'"+jArrSubBody.get("partCd")+"',		\n")
								.append("		"+jArrSubBody.get("partRevNo")+",		\n")
								.append("		0,										\n")
								.append("		"+jArrSubBody.get("ttlBlendAmt")+",		\n")
								.append("		''										\n")
								.append("	);											\n")
								.toString();

						resultInt = super.excuteUpdate(con, sql);
						if (resultInt < 0) {
							ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
							con.rollback();
							return EventDefine.E_DOEXCUTE_ERROR ;
						}
					}
				}
	    		
				con.commit();
			} catch(Exception e) {
				LoggingWriter.setLogError("M303S020200E101()","==== SQL ERROR ===="+ e.getMessage());
				return EventDefine.E_DOEXCUTE_ERROR ;
		    } finally {
		    	if (Config.useDataSource) {
					try {
						if (con != null) con.close();
					} catch (Exception e) {
						LoggingWriter.setLogError("M303S020200E101()","==== finally ===="+ e.getMessage());
					}
		    	}
		    }
			ioParam.setResultString(resultString);
			ioParam.setColumnCount("" + super.COLUMN_COUNT);
	    	ioParam.setMessage(MessageDefine.M_QUERY_OK);
		    return EventDefine.E_QUERY_RESULT;
	}	
		
	// 현장에서 작업 상태를 '작업중'으로 변경 (작업시작)
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
					.append("	work_status = '작업중',										\n")
					.append("	work_start_time = SYSDATETIME								\n")
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
	    	} else {
	    	}
	    }
		ioParam.setResultString(resultString);
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
    	ioParam.setMessage(MessageDefine.M_QUERY_OK);

    	return EventDefine.E_QUERY_RESULT;
	}
	
	// 현장생산관리 메인테이블 조회
	public int E104(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			
			String sql = new StringBuilder()
					.append("SELECT																			\n")
					.append("    C.product_nm, 																\n")
					.append("    A.manufacturing_date, 														\n")
					.append("    B.plan_amount, 															\n")
					.append("    B.real_amount, 															\n")
					.append("    A.expiration_date, 														\n")
					.append("    A.loss_rate, 																\n")
					.append("    FORMAT(B.plan_amount / A.loss_rate * 100, 6) AS total_blending_amount, 	\n")
					.append("    DATE_FORMAT(A.work_start_time, '%Y-%m-%d %H:%i'), 							\n")
					.append("    DATE_FORMAT(A.work_end_time, '%Y-%m-%d %H:%i'),							\n")
					.append("    A.work_status,	 															\n")
					.append("    -- 아래는는 서브테이블을 부르기 위한 데이터들	  										\n")
					.append("    A.request_rev_no, 															\n")
					.append("    A.prod_plan_date, 															\n")
					.append("    A.plan_rev_no, 															\n")
					.append("    A.prod_cd, 																\n")
					.append("    A.prod_rev_no, 															\n")
					.append("    HOUR(A.work_end_time) - HOUR(A.work_start_time) +							\n")
					.append("    (MINUTE(A.work_end_time) - MINUTE(A.work_start_time))*1/60					\n")
					.append("FROM tbi_production_request A 													\n")
					.append("INNER JOIN tbi_production_plan_daily_detail B 									\n")
					.append("    ON A.prod_plan_date = B.prod_plan_date 									\n")
					.append("    AND A.plan_rev_no = B.plan_rev_no 											\n")
					.append("    AND A.prod_cd = B.prod_cd 													\n")
					.append("INNER JOIN tbm_product C 														\n")
					.append("    ON A.prod_cd = C.prod_cd 													\n")
					.append("    AND A.prod_rev_no = C.revision_no 											\n")
					.append("WHERE A.manufacturing_date 													\n")
					.append("		= '" + jArray.get("date") + "' 											\n")
					.append("  AND work_status != '제출'														\n")
					.append("  AND work_status != '확인'														\n")
					.append("AND A.request_rev_no = (SELECT MAX(request_rev_no)								\n")
					.append("  						 FROM tbi_production_request D							\n")
					.append("  						 WHERE D.manufacturing_date = A.manufacturing_date		\n")
					.append("  						   AND D.prod_plan_date = A.prod_plan_date				\n")
					.append("  						   AND D.plan_rev_no = A.plan_rev_no					\n")
					.append("  						   AND D.prod_cd = A.prod_cd							\n")
					.append("  						   AND D.prod_rev_no = A.prod_rev_no)					\n")
					.append("AND B.work_ordered_yn = 'Y' 													\n")
					.toString();

			resultString = super.excuteQueryString(con, sql);
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M303S020200E104()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M303S020200E104()","==== finally ===="+ e.getMessage());
				}
	    	}
	    }
		ioParam.setResultString(resultString);
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
    	ioParam.setMessage(MessageDefine.M_QUERY_OK);

    	return EventDefine.E_QUERY_RESULT;
	}
	
	// 현장에서 작업 상태를 '정지'로 변경 (작업정지)
	public int E112(InoutParameter ioParam) {
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
					.append("	work_status = '정지'											\n")
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
			LoggingWriter.setLogError("M303S020200E112()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M303S020200E112()","==== finally ===="+ e.getMessage());
				}
	    	} else {
	    	}
	    }
		ioParam.setResultString(resultString);
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
    	ioParam.setMessage(MessageDefine.M_QUERY_OK);

    	return EventDefine.E_QUERY_RESULT;
	}
	
	/*
	 * 현장에서 작업 상태를 '완료'로 변경 (작업종료) 
	 * - 생산작업요청서 : 
	 * 1. 사원 아이디 사원 수정이력번호 추가 
	 * 2. 작업진행상태 : 완료
	 * 
	 * - 일일생산계획_상세 
	 * 1. 실제생산수량 업데이트
	 * 
	 * - tbi_prod_storage / tbi_prod_ipgo 
	 * 1. 신규 입고 저장
	 * 
	 * -tbi_working_info_detail 
	 * 1. 노무정보상세 노무시간 입력
	 */
	public int E122(InoutParameter ioParam) {
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		String planStorageMapper = GeneratorPlanStorageMapper.generateMappingValue();
		
		try {
			con = JDBCConnectionPool.getConnection();
			con.setAutoCommit(false);
			
			JSONObject jArr = new JSONObject();
    		jArr = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			
			String sql = new StringBuilder()
					.append("UPDATE															\n")
					.append("	tbi_production_request										\n")
					.append("SET															\n")
					.append("	work_status = '완료',											\n")
					.append("	work_end_time = SYSDATETIME,								\n")
					.append("	user_id = '" + jArr.get("userId") + "',						\n")
					.append("	user_rev_no = '" + jArr.get("userRevNo") + "'				\n")
					.append("WHERE															\n")
					.append("	manufacturing_date = '"+jArr.get("manufacturingDate")+"'	\n")
					.append("	AND request_rev_no = '"+jArr.get("requestRevNo")+"'			\n")
					.append("	AND prod_plan_date = '"+jArr.get("prodPlanDate")+"'			\n")
					.append("	AND plan_rev_no = '"+jArr.get("planRevNo")+"'				\n")
					.append("	AND prod_cd = '"+jArr.get("prodCd")+"'						\n")
					.append("	AND prod_rev_no = '"+jArr.get("prodRevNo")+"'				\n")
					.append(";																\n")
					.toString();

			resultInt = super.excuteUpdate(con, sql);
			
    		if (resultInt < 0) {
				ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
				con.rollback();
				return EventDefine.E_DOEXCUTE_ERROR ;
			} else {
				sql = new StringBuilder()
					.append("UPDATE															\n")
					.append("	tbi_production_plan_daily_detail							\n")
					.append("SET															\n")
					.append("	real_amount = "+ jArr.get("realAmount") +",					\n")
					.append("	plan_storage_mapper = '" + planStorageMapper + "'			\n")
					.append("WHERE	prod_plan_date = '"+jArr.get("prodPlanDate")+"'			\n")
					.append("  AND plan_rev_no = "+jArr.get("planRevNo")+"					\n")
					.append("  AND prod_cd = '"+jArr.get("prodCd")+"'						\n")
					.append("  AND prod_rev_no = "+jArr.get("prodRevNo")+"					\n")
					.append(";																\n")
					.toString();

				resultInt = super.excuteUpdate(con, sql);
				
	    		if (resultInt < 0) {
					ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
					con.rollback();
					return EventDefine.E_DOEXCUTE_ERROR ;
				} else {
					sql = new StringBuilder()
						.append("INSERT INTO tbi_prod_storage2 (			\n")
						.append("	prod_date,								\n")
						.append("	seq_no,									\n")
						.append("	prod_cd,								\n")
						.append("	prod_rev_no,							\n")
						.append("	pre_amt,								\n")
						.append("	io_amt,									\n")
						.append("	post_amt,								\n")
						.append("	expiration_date,						\n")
						.append("	note,									\n")
						.append("	plan_storage_mapper						\n")
						.append(")											\n")
						.append("VALUES (									\n")
						.append("	'"+jArr.get("manufacturingDate")+"',	\n")
						.append("	(SELECT MAX(seq_no) + 1 				\n")
						.append("	FROM tbi_prod_storage2),				\n")
						.append("	'"+jArr.get("prodCd")+"',				\n")
						.append("	"+jArr.get("prodRevNo")+",				\n")
						.append("	0,										\n")
						.append("	'" + jArr.get("realAmount") + "',		\n")
						.append("	'" + jArr.get("realAmount") + "',		\n")
						.append("	'" + jArr.get("expirationDate") + "',	\n")
						.append("	'생산최초입고',								\n")
						.append("	'" + planStorageMapper + "'				\n")
						.append(");											\n")
						.toString();

					resultInt = super.excuteUpdate(con, sql);
					
		    		if (resultInt < 0) {
						ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
						con.rollback();
						return EventDefine.E_DOEXCUTE_ERROR;
					} else {
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
							.append("		ipgo_type,						\n")
							.append("		note							\n")
							.append(")										\n")
							.append("VALUES (								\n")
							.append("	'"+jArr.get("manufacturingDate")+"',\n")
							.append("	(SELECT MAX(seq_no)		 			\n")
							.append("	FROM tbi_prod_storage2),			\n")
							.append("	'"+jArr.get("prodCd")+"',			\n")
							.append("	"+jArr.get("prodRevNo")+",			\n")
							.append("	SYSDATE,							\n")
							.append("	SYSTIME,							\n")
							.append("	" + jArr.get("realAmount") + ",		\n")
							.append("	'"+jArr.get("ipgo_type")+"',		\n")
							.append("	'"+jArr.get("prod_journal_note")+"'	\n")
							.append(");										\n")
							.toString();
						
						resultInt = super.excuteUpdate(con, sql);

						if (resultInt < 0) {
							ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
							con.rollback();
							return EventDefine.E_DOEXCUTE_ERROR ;
						} else {
							sql = new StringBuilder()
									.append("INSERT INTO															\n")
									.append("	tbi_working_info_detail (											\n")
									.append("		working_rev_no,													\n")
									.append("		prod_cd,														\n")
									.append("		prod_rev_no,													\n")
									.append("		working_info_date,												\n")
									.append("		working_time													\n")
									.append(")																		\n")
									.append("VALUES (																\n")
									.append("	NVL((SELECT MAX(working_rev_no)	    								\n")
									.append("   FROM tbi_working_info_detail										\n")
									.append("   WHERE prod_cd = '"+jArr.get("prodCd")+"'), 0),						\n")
									.append("	'"+jArr.get("prodCd")+"',											\n")
									.append("	"+jArr.get("prodRevNo")+",											\n")
									.append("	'"+jArr.get("manufacturingDate")+"',								\n")
									.append("   (DAY(SYSDATE) - DAY('"+jArr.get("workStartTime")+"'))*24 +   		\n")
									.append("   HOUR(SYSTIME) - HOUR('"+jArr.get("workStartTime")+"') +				\n")
									.append("   (MINUTE(SYSTIME) - MINUTE('"+jArr.get("workStartTime")+"'))*1/60	\n")
									.append(");																		\n")
									.toString();
								
							resultInt = super.excuteUpdate(con, sql);

							if (resultInt < 0) {
								ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
								con.rollback();
								return EventDefine.E_DOEXCUTE_ERROR ;
							}
						}
					}
				}
			}
    		
			con.commit();
		} catch(Exception e) {
			LoggingWriter.setLogError("M303S020200E122()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M303S020200E122()","==== finally ===="+ e.getMessage());
				}
	    	}
	    }
		ioParam.setResultString(resultString);
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
    	ioParam.setMessage(MessageDefine.M_QUERY_OK);

    	return EventDefine.E_QUERY_RESULT;
	}
	
	// 원료배합일지 사무 관리자에게 제출
	// yumsam
	public int E132(InoutParameter ioParam) {
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
					.append("	work_status = '제출'											\n")
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
			LoggingWriter.setLogError("M303S020200E132()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M303S020200E132()","==== finally ===="+ e.getMessage());
				}
	    	} else {
	    	}
	    }
		ioParam.setResultString(resultString);
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
    	ioParam.setMessage(MessageDefine.M_QUERY_OK);

    	return EventDefine.E_QUERY_RESULT;
	}
	
	// 생산작업지시서 상세 조회
	public int E114(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			
			String sql = new StringBuilder()
					.append("SELECT 																\n")
					.append("	C.part_nm,															\n")
//					.append("	FORMAT(D.blending_ratio, 6),										\n")
//					.append("	FORMAT(A.blending_amount_plan, 6),									\n")
//					.append("	FORMAT(A.blending_amount_real, 6),									\n")
					.append("	D.blending_ratio,													\n")
					.append("	A.blending_amount_plan,												\n")
					.append("	A.blending_amount_real,												\n")
					.append("	A.reason_diff,														\n")
					.append("	A.part_cd,															\n")
					.append("	A.part_rev_no,														\n")
					.append("	A.bom_rev_no														\n")
					.append("FROM tbi_production_request_detail A									\n")
					.append("INNER JOIN tbi_production_request B									\n")
					.append("	ON A.manufacturing_date = B.manufacturing_date						\n")
					.append("	AND A.request_rev_no = B.request_rev_no								\n")
					.append("	AND A.prod_plan_date = B.prod_plan_date								\n")
					.append("   AND A.plan_rev_no = B.plan_rev_no 									\n")
					.append("   AND A.prod_cd = B.prod_cd 											\n")
					.append("	AND A.prod_rev_no = B.prod_rev_no									\n")
					.append("INNER JOIN tbm_part_list C												\n")
					.append("	ON A.part_cd = C.part_cd											\n")
					.append("	AND A.part_rev_no = C.revision_no									\n")
					.append("INNER JOIN tbm_bom_info2 D												\n")
					.append("	ON A.prod_cd = D.prod_cd 											\n")
					.append("	AND A.prod_rev_no = D.prod_rev_no									\n")
					.append("   AND A.part_cd = D.part_cd											\n")
					.append("   AND A.part_rev_no = D.part_rev_no									\n")
					.append("   AND A.bom_rev_no = D.bom_rev_no										\n")
					.append("   AND D.start_date <= A.manufacturing_date							\n")
					.append("   AND D.duration_date >= A.manufacturing_date							\n")
					.append("WHERE A.manufacturing_date = '" + jArray.get("manufacturingDate") + "'	\n")
					.append("	AND A.request_rev_no = " + jArray.get("requestRevNo") + "			\n")
					.append("	AND A.prod_plan_date = '" + jArray.get("prodPlanDate") + "'			\n")
					.append("	AND A.plan_rev_no = " + jArray.get("planRevNo") + "					\n")
					.append("	AND A.prod_cd = '" + jArray.get("prodCd") + "'						\n")
					.append("	AND A.prod_rev_no = " + jArray.get("prodRevNo") + "					\n")
					.toString();

			String ActionCommand = ioParam.getActionCommand();
			if(ActionCommand.startsWith("doQueryTableFieldName")) {
				resultString = super.excuteQueryStringTableFieldName(con, sql.toString());
			} else {
				resultString = super.excuteQueryString(con, sql.toString());
			}
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M303S020200E114()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M303S020200E114()","==== finally ===="+ e.getMessage());
				}
	    	}
	    }
		ioParam.setResultString(resultString);
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
    	ioParam.setMessage(MessageDefine.M_QUERY_OK);

    	return EventDefine.E_QUERY_RESULT;
	}
		
	// 선택된 날짜의 생산계획에 등록된 완제품 목록을 불러온다
	// yumsam
	public int E174(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			
			String sql = new StringBuilder()
					.append("SELECT\n")
					.append("	A.prod_plan_date,\n")
					.append("	B.product_nm,\n")
					.append("	A.plan_amount,\n")
					.append("	A.plan_rev_no,\n")
					.append("	A.prod_cd,\n")
					.append("	A.prod_rev_no,\n")
					.append("	A.prod_plan_date + B.expiration_date AS expiration_date\n")
					.append("FROM\n")
					.append("	tbi_production_plan_daily_detail A\n")
					.append("INNER JOIN tbm_product B\n")
					.append("	ON A.prod_cd = B.prod_cd\n")
					.append("	AND A.prod_rev_no = B.revision_no\n")
					.append("WHERE\n")
					.append("	prod_plan_date = '" + jArray.get("selectedDate") + "'\n")
					.toString();
			
			String ActionCommand = ioParam.getActionCommand();
			if(ActionCommand.startsWith("doQueryTableFieldName")) {
				resultString = super.excuteQueryStringTableFieldName(con, sql);
			} else {
				resultString = super.excuteQueryString(con, sql);
			}
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M303S020200E174()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M303S020200E174()","==== finally ===="+ e.getMessage());
				}
	    	}
	    }
		ioParam.setResultString(resultString);
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
    	ioParam.setMessage(MessageDefine.M_QUERY_OK);

    	return EventDefine.E_QUERY_RESULT;
	}
	
	// 선택된 날짜의 생산계획에 등록된 완제품 목록을 불러온다
	// yumsam
	public int E184(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			
			String sql = new StringBuilder()
					.append("SELECT 														\n")
					.append("	C.part_nm,													\n")
					.append("	A.blending_ratio,											\n")
					.append("	NULL AS blending_amount_plan,								\n")
					.append("	C.part_cd,													\n")
					.append("	C.revision_no												\n")
					.append("FROM tbm_bom_info2 A											\n")
					.append("INNER JOIN tbm_product B										\n")
					.append("	ON A.prod_cd = B.prod_cd									\n")
					.append("	AND A.prod_rev_no = B.revision_no							\n")
					.append("INNER JOIN tbm_part_list C										\n")
					.append("	ON A.part_cd = C.part_cd									\n")
					.append("	AND A.part_rev_no = C.revision_no							\n")
					.append("WHERE A.prod_cd = '" + jArray.get("prodCd") + "'				\n")
					.append("	AND A.prod_rev_no = " + jArray.get("prodRevNo") + "			\n")
					.append("	AND A.start_date <= '" + jArray.get("selectedDate") + "' 	\n")
					.append("	AND A.duration_date >= '" + jArray.get("selectedDate") + "'	\n")
					.append("	AND A.delyn != 'Y'											\n")
					.toString();
			
			String ActionCommand = ioParam.getActionCommand();
			if(ActionCommand.startsWith("doQueryTableFieldName")) {
				resultString = super.excuteQueryStringTableFieldName(con, sql);
			} else {
				resultString = super.excuteQueryString(con, sql);
			}
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M303S020200E174()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M303S020200E174()","==== finally ===="+ e.getMessage());
				}
	    	}
	    }
		ioParam.setResultString(resultString);
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
    	ioParam.setMessage(MessageDefine.M_QUERY_OK);

    	return EventDefine.E_QUERY_RESULT;
	}
	
	// 현장에서 원료배합일지를 작성
	public int E202(InoutParameter ioParam) {
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		try {
			con = JDBCConnectionPool.getConnection();
			con.setAutoCommit(false);
			
			JSONObject jArr = new JSONObject();
    		jArr = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));

    		String sql = new StringBuilder()
    				.append("UPDATE\n")
    				.append("	tbi_production_request_detail\n")
    				.append("SET\n")
    				.append("	blending_amount_real = "+jArr.get("blendingAmtReal")+",\n")
    				.append("	reason_diff = '"+jArr.get("reasonDiff")+"'\n")
    				.append("WHERE\n")
    				.append("	manufacturing_date = '"+jArr.get("manufacturingDate")+"'\n")
    				.append("	AND request_rev_no = "+jArr.get("requestRevNo")+"\n")
    				.append("	AND prod_plan_date = '"+jArr.get("prodPlanDate")+"'\n")
    				.append("	AND plan_rev_no = "+jArr.get("planRevNo")+"\n")
    				.append("	AND prod_cd = '"+jArr.get("prodCd")+"'\n")
    				.append("	AND prod_rev_no = "+jArr.get("prodRevNo")+"\n")
    				.append("	AND part_cd = '"+jArr.get("partCd")+"'\n")
    				.append("	AND part_rev_no = "+jArr.get("partRevNo")+"\n")
    				.append("	AND bom_rev_no = "+jArr.get("bomRevNo")+"\n")
    				.toString();

			resultInt = super.excuteUpdate(con, sql);
			
    		if (resultInt < 0) {
				ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
				con.rollback();
				return EventDefine.E_DOEXCUTE_ERROR ;
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
	    	} else {
	    	}
	    }
		ioParam.setResultString(resultString);
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
    	ioParam.setMessage(MessageDefine.M_QUERY_OK);

    	return EventDefine.E_QUERY_RESULT;
	}
	
	
	
}