package mes.frame.business.M838;

import java.lang.reflect.Method;
import java.sql.Connection;
import java.sql.PreparedStatement;

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


/*
 * 거래처 관리 목록
 * 
 * 작성자: 서승헌
 * 일시: 2021-03-29
 * 
 * */


/**
 * 개요 : 이벤트ID별 메소드 정의
 */
public class M838S090100 extends SqlAdapter{
	Connection con = null;
	PreparedStatement pstmt = null;
	String resultString = "";
	int resultInt = -1;
	StringBuffer sql = new StringBuffer();
	
	String[][] v_paramArray = new String[0][0]; 
	Class[] optClass = null;
	Object[] optObj = null;
	Object obj = null;
	
	public M838S090100(){
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
			
			Method method = M838S090100.class.getMethod(event,optClass);
			LoggingWriter.setLogDebug(M838S090100.class.getName(),"==== " + event + " EventMethod Create Success ====");

			obj = method.invoke(M838S090100.class.newInstance(),optObj);
			doExcute_result = CommonFunction.getInt(obj.toString());
			
	    } catch (Exception ex) {
	    	doExcute_result = EventDefine.E_DOEXCUTE_INIT;
			ioParam.setMessage(MessageDefine.M_NO_EVENTID);
			LoggingWriter.setLogError(M838S090100.class.getName(),"==== EventID Not define : EVENT ID [ " + ioParam.getEventID() + "]");
	    } finally {
	    	obj = null;
			optClass = null;
			optObj = null;
	    }
	    long endTime = System.currentTimeMillis();
		long runningTime = endTime - startTime;
		LoggingWriter.setLogAll(M838S090100.class.getName(),"==== Query [수행시간  : " + runningTime + " ms]");
		
		return doExcute_result;
	}
	
	// 등록
	public int E101(InoutParameter ioParam){ 
		resultInt = EventDefine.E_DOEXCUTE_INIT;

		try {
			con = JDBCConnectionPool.getConnection();
			con.setAutoCommit(false);
			
    		JSONObject jObj = new JSONObject();
    		jObj = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
    		
    		String checklist_id = jObj.get("checklist_id").toString();
    		
    		String sql = new StringBuilder()
    				.append("INSERT INTO										 \n")
    				.append("	haccp_recall (									 \n")
    				.append("    	checklist_id,								 \n")
    				.append("   	checklist_rev_no,							 \n")
    				.append("   	prod_date,									 \n")
    				.append("   	prod_cd,									 \n")
    				.append("   	action_result,								 \n")
    				.append("   	action_plan,								 \n")
    				.append("    	person_write_id		 						 \n")
    				.append(") VALUES (									 		 \n")
    				.append("		'"+checklist_id+"',							 \n")
    				.append("    	(SELECT MAX(checklist_rev_no)				 \n")
    				.append("    	FROM checklist								 \n")
    				.append("    	WHERE checklist_id = '"+checklist_id+"'),	 \n")
    				.append("		'"+jObj.get("prod_date").toString()+"',		 \n")
    				.append("		'"+jObj.get("prod_cd").toString()+"',	 	 \n")
    				.append("		'"+jObj.get("action_result").toString()+"',  \n")
    				.append("		'"+jObj.get("action_plan").toString()+"',	 \n")
    				.append("		'"+jObj.get("person_write_id")+"'		 	 \n")
    				.append(")													 \n")
    				.toString();
			
			resultInt = super.excuteUpdate(con, sql);
	    	if(resultInt < 0) {
				ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
				con.rollback();
				return EventDefine.E_DOEXCUTE_ERROR ;
			}
    		
			con.commit();	
		} catch(Exception e) {
			e.getStackTrace();
			LoggingWriter.setLogError("M838S090100E101()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR;
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
	
	// 수정
	public int E102(InoutParameter ioParam){ 
		resultInt = EventDefine.E_DOEXCUTE_INIT;

		try {
			con = JDBCConnectionPool.getConnection();
			con.setAutoCommit(false);
			
    		JSONObject jObj = new JSONObject();
    		jObj = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
    		
    		String regist_seq_no = jObj.get("regist_seq_no").toString();
    		String prod_date = jObj.get("prod_date").toString();
    		String prod_cd = jObj.get("prod_cd").toString();

    		String sql = new StringBuilder()
    				.append("UPDATE\n")
    				.append("	haccp_recall\n")
    				.append("SET\n")
    				.append("	action_result = '"+jObj.get("action_result").toString()+"',\n")
    				.append("	action_plan = '"+jObj.get("action_plan").toString()+"',\n")
    				.append("	person_check_id = '',\n")
    				.append("	person_approve_id = ''\n")
    				.append("WHERE\n")
    				.append("	regist_seq_no = '"+regist_seq_no+"'\n")
    				.append("	AND prod_date = '"+prod_date+"'\n")
    				.append("	AND prod_cd = '"+prod_cd+"'\n")
    				.toString();

    		resultInt = super.excuteUpdate(con, sql);
	    	if(resultInt < 0) {
				ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
				con.rollback();
				return EventDefine.E_DOEXCUTE_ERROR ;
			}
			con.commit();
		} catch(Exception e) {
			e.getStackTrace();
			LoggingWriter.setLogError("M838S090100E102()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR;
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
	
	// 삭제
	public int E103(InoutParameter ioParam){ 
		resultInt = EventDefine.E_DOEXCUTE_INIT;

		try {
			con = JDBCConnectionPool.getConnection();
			con.setAutoCommit(false);
			
    		JSONObject jObj = new JSONObject();
    		jObj = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
    		
    		String regist_seq_no = jObj.get("regist_seq_no").toString();
    		
    		String sql = new StringBuilder()
    				.append("DELETE FROM haccp_recall						\n")
    				.append("WHERE regist_seq_no = "+regist_seq_no+"		\n")
    				.toString();
    		
    		resultInt = super.excuteUpdate(con, sql);
	    	if(resultInt < 0) {
				ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
				con.rollback();
				return EventDefine.E_DOEXCUTE_ERROR ;
			}
			con.commit();
		} catch(Exception e) {
			e.getStackTrace();
			LoggingWriter.setLogError("M838S090100E103()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR;
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
	
	// 메인 테이블 조회
	public int E104(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			
			String sql = new StringBuilder()
					.append("SELECT\n")
					.append("	checklist_id,\n")
					.append("	checklist_rev_no,\n")
					.append("	prod_date,\n")
					.append("	regist_seq_no,\n")
					.append("	P.product_nm,\n")
					.append("	A.prod_cd,\n")
					.append("	(\n")
					.append("		SELECT SUM(ipgo_amount)\n")
					.append("		FROM tbi_prod_ipgo2\n")
					.append("		GROUP BY prod_date, prod_cd\n")
					.append("		HAVING prod_date = A.prod_date AND prod_cd = A.prod_cd\n")
					.append("			  AND ipgo_type IN ('PROD_IPGO_TYPE001', 'PROD_IPGO_TYPE002')\n")
					.append("	) AS 입고량,\n")
					.append("	(\n")
					.append("		SELECT SUM(chulgo_amount)\n")
					.append("		FROM tbi_prod_chulgo2\n")
					.append("		GROUP BY prod_date, prod_cd\n")
					.append("		HAVING prod_date = A.prod_date AND prod_cd = A.prod_cd\n")
					.append("			 AND chulgo_type IN ('PROD_CHULGO_TYPE001', 'PROD_CHULGO_TYPE002')\n")
					.append("	) AS 출고량,\n")
					.append("	P.gugyuk,\n")
					.append("	U.user_nm AS person_write_id,\n")
					.append("	U2.user_nm AS person_check_id,\n")
					.append("	U3.user_nm AS person_approve_id\n")
					.append("FROM\n")
					.append("	haccp_recall A\n")
					.append("	JOIN tbm_product P\n")
					.append("	ON A.prod_cd = P.prod_cd\n")
					.append("	LEFT JOIN tbm_users U\n")
					.append("	ON A.person_write_id = U.user_id\n")
					.append("	AND A.prod_date BETWEEN CAST(U.start_date AS DATE) AND CAST(U.duration_date AS DATE) \n")
					.append("	LEFT JOIN tbm_users U2\n")
					.append("	ON A.person_check_id = U2.user_id\n")
					.append("	AND A.prod_date BETWEEN CAST(U2.start_date AS DATE) AND CAST(U2.duration_date AS DATE) \n")
					.append("	LEFT JOIN tbm_users U3\n")
					.append("	ON A.person_approve_id = U3.user_id\n")
					.append("	AND A.prod_date BETWEEN CAST(U3.start_date AS DATE) AND CAST(U3.duration_date AS DATE) \n")
					.append("WHERE A.prod_date BETWEEN '"+ jArray.get("fromdate") + "'	\n")  
					.append("                     AND '"+ jArray.get("todate") + "' 	\n")
					.toString();

			resultString = super.excuteQueryString(con, sql);
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M838S090100E104()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) {
						con.close();
					}
				} catch (Exception e) {
					LoggingWriter.setLogError("M838S090100E104()","==== finally ===="+ e.getMessage());
				}
	    	}
	    }

		ioParam.setResultString(resultString);
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
    	ioParam.setMessage(MessageDefine.M_QUERY_OK);

    	return EventDefine.E_QUERY_RESULT;
	}

	// 서브 테이블 조회
	public int E114(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			
			String sql = new StringBuilder()
					.append("SELECT\n")
					.append("	A.regist_seq_no,\n")
					.append("	A.drive_date,\n")
					.append("	seq_no,\n")
					.append("	drive_course_start || ' ~ ' || drive_course_end,\n")
					.append("	TO_CHAR(departure_time, 'HH24:MI'),\n")
					.append("	TO_CHAR(arrive_time, 'HH24:MI'),\n")
					.append("	V2.vehicle_nm || '/' || U.user_nm,\n")
					.append("	temp_gubun\n")
					.append("FROM\n")
					.append("	haccp_car_detail A \n")
					.append("	JOIN haccp_car C\n")
					.append("	ON A.regist_seq_no = C.regist_seq_no\n")
					.append("	JOIN tbm_users U\n")
					.append("	ON A.vehicle_id = U.user_id\n")
					.append("	JOIN tbm_vehicle_users V\n")
					.append("	ON A.vehicle_id = V.user_id\n")
					.append("	JOIN tbm_vehicle V2\n")
					.append("	ON V.vehicle_cd = V2.vehicle_cd\n")
					.append("WHERE\n")
					.append("	A.regist_seq_no = "+jArray.get("regist_seq_no").toString().trim()+"\n")
					.append("	AND A.drive_date = DATE '"+jArray.get("drive_date").toString()+"'\n")
					.append("	AND drive_course_start IS NOT NULL AND drive_course_start != ''\n")
					.toString();

			resultString = super.excuteQueryString(con, sql);
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M838S090100E114()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) {
						con.close();
					}
				} catch (Exception e) {
					LoggingWriter.setLogError("M838S090100E114()","==== finally ===="+ e.getMessage());
				}
	    	}
	    }

		ioParam.setResultString(resultString);
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
    	ioParam.setMessage(MessageDefine.M_QUERY_OK);

    	return EventDefine.E_QUERY_RESULT;
	}
	
	// 반품 목록 조회
	public int E124(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			String sql = new StringBuilder()
					.append("SELECT\n")
					.append("	A.discard_seq_no,\n")
					.append("	A.discard_date,\n")
					.append("	B.product_nm,\n")
					.append("	A.prod_date,\n")
					.append("	A.chulha_no,\n")
					.append("	A.chulha_rev_no,\n")
					.append("	A.prod_cd,\n")
					.append("	A.prod_rev_no\n")
					.append("FROM\n")
					.append("	tbi_prod_discard A\n")
					.append("	JOIN tbm_product B\n")
					.append("	ON A.prod_cd = B.prod_cd\n")
					.append("	LEFT JOIN haccp_recall C\n")
					.append("	ON A.prod_cd = C.prod_cd\n")
					.append("	AND A.prod_date = C.prod_date\n")
					.append("GROUP BY A.prod_date, A.prod_cd\n")
					.append("HAVING C.prod_date IS NULL\n")
					.toString();

			resultString = super.excuteQueryString(con, sql);
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M838S090100E124()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) {
						con.close();
					}
				} catch (Exception e) {
					LoggingWriter.setLogError("M838S090100E124()","==== finally ===="+ e.getMessage());
				}
	    	}
	    }

		ioParam.setResultString(resultString);
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
    	ioParam.setMessage(MessageDefine.M_QUERY_OK);

    	return EventDefine.E_QUERY_RESULT;
	}
	
	// 출고/반품내역 가져오기
	public int E134(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			
			String sql = new StringBuilder()
					.append("SELECT\n")
					.append("	A.chulha_no,\n")
					.append("	A.chulha_rev_no,\n")
					.append("	A.chulha_date,\n")
					.append("	A.order_no,\n")
					.append("	A.order_rev_no,\n")
					.append("	B.prod_date AS 생산일자,\n")
					.append("	P.product_nm,\n")
					.append("	B.prod_cd,\n")
					.append("	B.prod_rev_no,\n")
					.append("	(\n")
					.append("		SELECT SUM(ipgo_amount)\n")
					.append("		FROM tbi_prod_ipgo2\n")
					.append("		GROUP BY prod_date, prod_cd\n")
					.append("		HAVING prod_date = B.prod_date AND prod_cd = B.prod_cd\n")
					.append("			  AND ipgo_type IN ('PROD_IPGO_TYPE001', 'PROD_IPGO_TYPE002')\n")
					.append("	) AS 입고량,\n")
					.append("	(\n")
					.append("		SELECT SUM(chulgo_amount)\n")
					.append("		FROM tbi_prod_chulgo2\n")
					.append("		GROUP BY prod_date, prod_cd\n")
					.append("		HAVING prod_date = B.prod_date AND prod_cd = B.prod_cd\n")
					.append("			 AND chulgo_type IN ('PROD_CHULGO_TYPE001', 'PROD_CHULGO_TYPE002')\n")
					.append("	) AS 출고량,\n")
					.append("	CS.cust_nm,\n")
					.append("	D.cust_cd,\n")
					.append("	D.cust_rev_no,\n")
					.append("	SUM(B.chulha_count) / CASE WHEN COUNT(B.chulha_count) > 1 THEN COUNT(B.chulha_count)/2 ELSE COUNT(B.chulha_count) END AS 출하량,\n")
				//	.append("	SUM(B.chulha_count),\n")
					.append("	SUM(DC.amount) / CASE WHEN COUNT(DC.amount) > 1 THEN COUNT(DC.amount)/2 ELSE COUNT(DC.amount) END  AS 반품량,\n")
					.append("	P.gugyuk,\n")
					.append("	U.user_nm\n")
					.append("FROM\n")
					.append("	tbi_chulha A\n")
					.append("	JOIN tbi_chulha_detail B\n")
					.append("		ON A.chulha_no = B.chulha_no\n")
					.append("		AND A.chulha_rev_no = B.chulha_rev_no\n")
					.append("	JOIN tbi_order2 D\n")
					.append("		ON A.order_no = D.order_no\n")
					.append("		AND D.delivery_yn = 'Y'\n")
					.append("	JOIN tbi_order_detail2 D2\n")
					.append("		ON D2.order_no = D.order_no\n")
					.append("		AND B.prod_cd = D2.prod_cd\n")
					.append("	JOIN tbm_customer CS\n")
					.append("		ON D.cust_cd = CS.cust_cd\n")
					.append("	JOIN tbi_vehicle_log_detail VL\n")
					.append("		ON VL.chulha_no = A.chulha_no\n")
					.append("	JOIN tbm_users U\n")
					.append("		ON VL.user_id = U.user_id\n")
					.append("	JOIN tbm_product P\n")
					.append("		ON B.prod_cd = P.prod_cd\n")
					.append("	LEFT JOIN tbi_prod_discard DC\n")
					.append("		ON B.chulha_no = DC.chulha_no\n")
					.append("		AND DC.chulha_rev_no = B.chulha_rev_no\n")
					.append("		AND B.prod_date = DC.prod_date\n")
					.append("		AND DC.prod_cd = B.prod_cd\n")
					.append("GROUP BY B.chulha_no, B.prod_cd\n")
					.append("HAVING B.prod_date = '"+jArray.get("prod_date").toString()+"' AND B.prod_cd = '"+jArray.get("prod_cd").toString()+"'\n")
					.append("ORDER BY A.chulha_no ASC\n")
					.toString();

			resultString = super.excuteQueryString(con, sql);
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M838S090100E134()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) {
						con.close();
					}
				} catch (Exception e) {
					LoggingWriter.setLogError("M838S090100E134()","==== finally ===="+ e.getMessage());
				}
	    	}
	    }

		ioParam.setResultString(resultString);
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
    	ioParam.setMessage(MessageDefine.M_QUERY_OK);

    	return EventDefine.E_QUERY_RESULT;
	}

	// 점검표 캔버스 조회용 쿼리  
	public int E144(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			
			String sql = new StringBuilder()
					.append("SELECT\n")
					.append("	A.checklist_id,\n")
					.append("	A.checklist_rev_no,	\n")
					.append("	A.drive_date,\n")
					.append("	A.regist_seq_no,\n")
					.append("	TO_CHAR(A.drive_date, ' YYYY \"년 \" MM \"월 \" DD \"일 \"'),\n")
					.append("	DECODE(DAYOFWEEK(A.drive_date), 1, '일', 2, '월', 3, '화', 4, '수', 5, '목', 6, '금', '토') || '요일',				\n")
					.append("	DECODE(SUBSTR(T2.cust_gubun,-1), '1', '강서', '2', '강동', '지방') AS cust_gubun,\n")
					.append("	check_yn1,\n")
					.append("	check_yn2,\n")
					.append("	A.unsuit_detail,\n")
					.append("	A.improve_action,\n")
					.append("	A.bigo,	\n")
					.append("	drive_course_start || ' ~ ' || drive_course_end,\n")
					.append("	TO_CHAR(departure_time, 'HH24:MI'),\n")
					.append("	TO_CHAR(arrive_time, 'HH24:MI'),\n")
					.append("	V2.vehicle_nm || '/' || U.user_nm,\n")
					.append("	DECODE(temp_gubun, 1, '냉장/냉동', 2, '냉장', '냉동'),		\n")
					.append("	B.user_nm AS person_write_id,							\n")
					.append("	C.user_nm AS person_check_id,							\n")
					.append("	D.user_nm AS person_approve_id,							\n")
					.append("	E.user_nm AS improve_action_check\n")
					.append("FROM haccp_car A		\n")
					.append("INNER JOIN haccp_car_detail T\n")
					.append("	ON A.regist_seq_no = T.regist_seq_no\n")
					.append("	AND A.drive_date = T.drive_date\n")
					.append("INNER JOIN tbm_vehicle_users T2\n")
					.append("	ON T.vehicle_id = T2.user_id\n")
					.append("LEFT JOIN tbm_users B										\n")
					.append("	ON A.person_write_id = B.user_id						\n")
					.append("	AND A.drive_date BETWEEN CAST(B.start_date AS DATE) AND CAST(B.duration_date AS DATE) \n")
					.append("LEFT JOIN tbm_users C										\n")
					.append("	ON A.person_check_id = C.user_id						\n")
					.append("	AND A.drive_date BETWEEN CAST(C.start_date AS DATE) AND CAST(C.duration_date AS DATE) \n")
					.append("LEFT JOIN tbm_users D										\n")
					.append("	ON A.person_approve_id = D.user_id						\n")
					.append("	AND A.drive_date BETWEEN CAST(D.start_date AS DATE) AND CAST(D.duration_date AS DATE) \n")
					.append("LEFT JOIN tbm_users E\n")
					.append("	ON A.improve_action_check = E.user_id					\n")
					.append("	AND A.drive_date BETWEEN CAST(E.start_date AS DATE) AND CAST(E.duration_date AS DATE) \n")
					.append("INNER JOIN tbm_users U\n")
					.append("	ON T.vehicle_id = U.user_id\n")
					.append("INNER JOIN tbm_vehicle_users V\n")
					.append("	ON T.vehicle_id = V.user_id\n")
					.append("INNER JOIN tbm_vehicle V2\n")
					.append("	ON V.vehicle_cd = V2.vehicle_cd\n")
					.append("WHERE\n")
					.append("	A.regist_seq_no = "+jArray.get("regist_seq_no").toString().trim()+"\n")
					.append("	AND A.drive_date = DATE '"+jArray.get("drive_date").toString()+"'\n")
					.append("	AND drive_course_end IS NOT NULL AND drive_course_end != ''\n")
					.append("ORDER BY seq_no ASC;\n")
					.toString();
			
			resultString = super.excuteQueryString(con, sql);
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M838S090100E144()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M838S090100E144()","==== finally ===="+ e.getMessage());
				}
	    	} else {
	    	}
	    }
		ioParam.setResultString(resultString);
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
    	ioParam.setMessage(MessageDefine.M_QUERY_OK);

    	return EventDefine.E_QUERY_RESULT;
	}
	
	// 수정용 쿼리  [recall]
	public int E154(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			
			String sql = new StringBuilder()
					.append("SELECT\n")
					.append("	checklist_id,\n")
					.append("	checklist_rev_no,\n")
					.append("	prod_cd,\n")
					.append("	prod_date,\n")
					.append("	regist_seq_no,\n")
					.append("	action_result,\n")
					.append("	action_plan,\n")
					.append("	U.user_nm AS person_write_id,\n")
					.append("	U2.user_nm AS person_check_id,\n")
					.append("	U3.user_nm AS person_approve_id\n")
					.append("FROM\n")
					.append("	haccp_recall A\n")
					.append("	LEFT JOIN tbm_users U\n")
					.append("	ON A.person_write_id = U.user_id\n")
					.append("	AND A.prod_date BETWEEN CAST(U.start_date AS DATE) AND CAST(U.duration_date AS DATE) \n")
					.append("	LEFT JOIN tbm_users U2\n")
					.append("	ON A.person_check_id = U2.user_id\n")
					.append("	AND A.prod_date BETWEEN CAST(U2.start_date AS DATE) AND CAST(U2.duration_date AS DATE) \n")
					.append("	LEFT JOIN tbm_users U3\n")
					.append("	ON A.person_approve_id = U3.user_id\n")
					.append("	AND A.prod_date BETWEEN CAST(U3.start_date AS DATE) AND CAST(U3.duration_date AS DATE) \n")
					.append("WHERE\n")
					.append("	regist_seq_no = "+jArray.get("regist_seq_no").toString().trim()+"\n")
					.toString();
			
			resultString = super.excuteQueryString(con, sql);
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M838S090100E144()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M838S090100E144()","==== finally ===="+ e.getMessage());
				}
	    	} else {
	    	}
	    }
		ioParam.setResultString(resultString);
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
    	ioParam.setMessage(MessageDefine.M_QUERY_OK);

    	return EventDefine.E_QUERY_RESULT;
	}
	
	// 점검표 승인자 서명 
	public int E502(InoutParameter ioParam){ 
		
		resultInt = EventDefine.E_DOEXCUTE_INIT;

		try {
			con = JDBCConnectionPool.getConnection();
			con.setAutoCommit(false);
			
    		JSONObject jObj = new JSONObject();
    		jObj = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
    		
    		String sql = new StringBuilder()
    				.append("UPDATE haccp_recall									\n")
    				.append("SET													\n")
    				.append("	person_approve_id = '" + jObj.get("userId") + "'	\n")
    				.append("WHERE prod_date = '"+ jObj.get("checklistDate") + "'	\n")
    				.append("  AND regist_seq_no = '"+ jObj.get("seq_no") + "'		\n")
					.toString();
		
			resultInt = super.excuteUpdate(con, sql);
	    	if(resultInt < 0){
				ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
				con.rollback();
				return EventDefine.E_DOEXCUTE_ERROR ;
			}
			con.commit();
		} catch(Exception e) {
			e.getStackTrace();
			LoggingWriter.setLogError("M838S090100E502()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
				}
	    	}
	    }
		ioParam.setResultString(resultString);
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
    	ioParam.setMessage(MessageDefine.M_QUERY_OK);
	    return EventDefine.E_QUERY_RESULT;
	}
	
	// 점검표 확인자 서명 
	public int E522(InoutParameter ioParam){ 
		
		resultInt = EventDefine.E_DOEXCUTE_INIT;

		try {
			con = JDBCConnectionPool.getConnection();
			con.setAutoCommit(false);
			
    		JSONObject jObj = new JSONObject();
    		jObj = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
    		
    		String sql = new StringBuilder()
    				.append("UPDATE haccp_recall									\n")
    				.append("SET													\n")
    				.append("	person_check_id = '" + jObj.get("userId") + "'		\n")
    				.append("WHERE prod_date = '"+ jObj.get("checklistDate") + "'	\n")
    				.append("  AND regist_seq_no = '"+ jObj.get("seq_no") + "'		\n")
					.toString();
		
			resultInt = super.excuteUpdate(con, sql);
	    	if(resultInt < 0){
				ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
				con.rollback();
				return EventDefine.E_DOEXCUTE_ERROR ;
			}
			con.commit();
		} catch(Exception e) {
			e.getStackTrace();
			LoggingWriter.setLogError("M838S090100E522()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
				}
	    	}
	    }
		ioParam.setResultString(resultString);
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
	    	ioParam.setMessage(MessageDefine.M_QUERY_OK);
		    return EventDefine.E_QUERY_RESULT;
	}

}