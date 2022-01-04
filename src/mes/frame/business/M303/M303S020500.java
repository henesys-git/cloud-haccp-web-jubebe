package mes.frame.business.M303;

import java.lang.reflect.Method;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.util.Vector;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;

import mes.client.conf.Config;
import mes.frame.common.ApprovalActionNo;
import mes.frame.common.EventDefine;
import mes.frame.common.HashObject;
import mes.frame.common.MessageDefine;
import mes.frame.common.QueueProcessing;
import mes.frame.database.JDBCConnectionPool;
import mes.frame.database.SqlAdapter;
import mes.frame.serviceinterface.InoutParameter;
import mes.frame.serviceinterface.LoggingWriter;
import mes.frame.util.CommonFunction;


public class M303S020500 extends SqlAdapter{
	Connection con = null;
	PreparedStatement pstmt = null;
	String resultString = "";
	int resultInt = -1;
	StringBuffer sql = new StringBuffer();
	
	String[][] v_paramArray = new String[0][0]; 
	Class[] optClass = null;
	Object[] optObj = null;
	Object obj = null;
	
	public M303S020500(){
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
			
			Method method = M303S020500.class.getMethod(event,optClass);
			LoggingWriter.setLogDebug(M303S020500.class.getName(),"==== " + event + " EventMethod Create Success ====");

			obj = method.invoke(M303S020500.class.newInstance(),optObj);
			doExcute_result = CommonFunction.getInt(obj.toString());
			
	    } catch (Exception ex) {
	    	doExcute_result = EventDefine.E_DOEXCUTE_INIT;
			ioParam.setMessage(MessageDefine.M_NO_EVENTID);
			LoggingWriter.setLogError(M303S020500.class.getName(),"==== EventID Not define : EVENT ID [ " + ioParam.getEventID() + "]");
	    } finally {
	    	obj = null;
			optClass = null;
			optObj = null;
	    }
	    long endTime = System.currentTimeMillis();
		long runningTime = endTime - startTime;
		LoggingWriter.setLogAll(M303S020500.class.getName(),"==== Query [수행시간  : " + runningTime + " ms]");
		
		return doExcute_result;
	}
	
	// 선반 입고 등록 yumsam
	public int E101(InoutParameter ioParam){ 
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			con.setAutoCommit(false);
			
			JSONObject jArr = new JSONObject();
    		jArr = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			
    		String sql = new StringBuilder()
    				.append("INSERT INTO tbi_production_rapid_freezer (		\n")
    				.append("	barcode,									\n")
    				.append("	barcode_name,								\n")
    				.append("	manufacturing_date,							\n")
    				.append("	request_rev_no,								\n")
    				.append("	prod_plan_date,								\n")
    				.append("	plan_rev_no,								\n")
    				.append("	prod_cd,									\n")
    				.append("	prod_rev_no,								\n")
    				.append("	prod_count_on_shelf,						\n")
    				.append("	start_time_freeze,							\n")
    				.append("	note,										\n")
    				.append("	inout_status								\n")
    				.append(") VALUES (										\n")
    				.append("	'"+jArr.get("barcode")+"',					\n")
    				.append("	(SELECT barcode_name 						\n")
    				.append("	 FROM tbi_production_rapid_freezer 			\n")
    				.append("	 WHERE barcode = '"+jArr.get("barcode")+"'),\n")
    				.append("	'"+jArr.get("manufacturing_date")+"',		\n")
    				.append("	'"+jArr.get("request_rev_no")+"',			\n")
    				.append("	'"+jArr.get("prod_plan_date")+"',			\n")
    				.append("	'"+jArr.get("plan_rev_no")+"',				\n")
    				.append("	'"+jArr.get("prod_cd")+"',					\n")
    				.append("	'"+jArr.get("prod_rev_no")+"',				\n")
    				.append("	"+jArr.get("prod_count_on_shelf")+",		\n")
    				.append("	SYSTIMESTAMP,								\n")
    				.append("	'"+jArr.get("note")+"',						\n")
    				.append("	'in'										\n")
    				.append(");												\n")
    				.toString();

			resultInt = super.excuteUpdate(con, sql);
    		if (resultInt < 0) {
				ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
				con.rollback();
				return EventDefine.E_DOEXCUTE_ERROR ;
			}
    		
			con.commit();
		} catch(Exception e) {
			LoggingWriter.setLogError("M303S020500E101()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M303S020500E101()","==== finally ===="+ e.getMessage());
				}
	    	}
	    }
		ioParam.setResultString(resultString);
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
    	ioParam.setMessage(MessageDefine.M_QUERY_OK);
	    return EventDefine.E_QUERY_RESULT;
	}
	
	// 선반 입고 수정
	public int E102(InoutParameter ioParam){ 
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArr = new JSONObject();
    		jArr = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			
    		String startTimeFreeze = jArr.get("start_date_freeze") + 
    							     " " + 
    							     jArr.get("start_time_freeze");
    		
    		String sql = new StringBuilder()
    				.append("UPDATE tbi_production_rapid_freezer 							\n")
    				.append("SET					 										\n")
    				.append("	start_time_freeze = '"+startTimeFreeze+"', 					\n")
    				.append("	prod_count_on_shelf= '"+jArr.get("prod_count_on_shelf")+"',	\n")
    				.append("	note = '"+jArr.get("note")+"' 								\n")
    				.append("WHERE barcode='"+jArr.get("barcode")+"';						\n")
    				.toString();

			resultInt = super.excuteUpdate(con, sql);
    		if (resultInt < 0) {
				ioParam.setMessage(MessageDefine.M_UPDATE_FAILED);
				con.rollback();
				return EventDefine.E_DOEXCUTE_ERROR ;
			}
    		
			con.commit();
		} catch(Exception e) {
			LoggingWriter.setLogError("M303S020500E112()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M303S020500E112()","==== finally ===="+ e.getMessage());
				}
	    	}
	    }
		ioParam.setResultString(resultString);
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
    	ioParam.setMessage(MessageDefine.M_QUERY_OK);
	    return EventDefine.E_QUERY_RESULT;
	}
	
	// 최초 바코드 출력 시 바코드 정보 저장
	public int E111(InoutParameter ioParam) {
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			con.setAutoCommit(false);
			
			JSONObject jArr = new JSONObject();
    		jArr = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			
    		String sql = new StringBuilder()
    				.append("INSERT INTO tbi_production_rapid_freezer (	\n")
    				.append("	barcode, 								\n")
    				.append("	barcode_name							\n")
    				.append(") 											\n")
    				.append("VALUES 									\n")
    				.append("(											\n")
    				.append("	'"+jArr.get("barcodeValue")+"', 		\n")
    				.append("	'"+jArr.get("prodName")+"'				\n")
    				.append(")											\n")
    				.toString();
    		
			resultInt = super.excuteUpdate(con, sql);
    		if (resultInt < 0) {
				ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
				con.rollback();
				return EventDefine.E_DOEXCUTE_ERROR ;
			}
    		
			con.commit();
		} catch(Exception e) {
			LoggingWriter.setLogError("M303S020500E111()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M303S020500E111()","==== finally ===="+ e.getMessage());
				}
	    	}
	    }
		ioParam.setResultString(resultString);
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
    	ioParam.setMessage(MessageDefine.M_QUERY_OK);
	    return EventDefine.E_QUERY_RESULT;
	}
	
	// 선반 출고
	public int E112(InoutParameter ioParam){ 
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArr = new JSONObject();
    		jArr = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			
    		String sql = new StringBuilder()
    				.append("UPDATE tbi_production_rapid_freezer a						\n")
    				.append("SET 														\n")
    				.append("	inout_status = 'out', 									\n")
    				.append("	finish_time_freeze = SYSTIMESTAMP,						\n")
    				.append("	prod_temperature = '"+jArr.get("prodTemperature")+"'	\n")
    				.append("WHERE barcode = '"+jArr.get("barcode")+"'					\n")
    				.append("  AND seq_no = (SELECT MAX(seq_no)							\n")
    				.append("  				 FROM tbi_production_rapid_freezer b		\n")
    				.append("  				 WHERE a.barcode = b.barcode)				\n")
    				.toString();

			resultInt = super.excuteUpdate(con, sql);
    		if (resultInt < 0) {
				ioParam.setMessage(MessageDefine.M_UPDATE_FAILED);
				con.rollback();
				return EventDefine.E_DOEXCUTE_ERROR ;
			}
    		
			con.commit();
		} catch(Exception e) {
			LoggingWriter.setLogError("M303S020500E112()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M303S020500E112()","==== finally ===="+ e.getMessage());
				}
	    	}
	    }
		ioParam.setResultString(resultString);
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
    	ioParam.setMessage(MessageDefine.M_QUERY_OK);
	    return EventDefine.E_QUERY_RESULT;
	}
	
	// 선반 입고 삭제 yumsam
	public int E103(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArr = new JSONObject();
    		jArr = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
					
    		String sql = new StringBuilder()
    					.append("DELETE FROM tbi_production_rapid_freezer 				\n")
        				.append("WHERE barcode='"+jArr.get("barcode")+"'				\n")
        				.append("  AND seq_no = (SELECT MAX(seq_no)						\n")
        				.append("  				 FROM tbi_production_rapid_freezer b	\n")
        				.append("  				 WHERE a.barcode = b.barcode)			\n")
    					.toString();
			
    		resultInt = super.excuteUpdate(con, sql);
    		if (resultInt < 0) {  
				ioParam.setMessage(MessageDefine.M_DELETE_FAILED);
				con.rollback();
				return EventDefine.E_DOEXCUTE_ERROR ;
			}
    		
		} catch(Exception e) {
			LoggingWriter.setLogError("M303S020500E103()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M303S020500E103()","==== finally ===="+ e.getMessage());
				}
	    	}
	    }
		
		ioParam.setResultString(resultString);
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
    	ioParam.setMessage(MessageDefine.M_QUERY_OK);

    	return EventDefine.E_QUERY_RESULT;
	}	
	
	// 선반 입고 조회
	public int E104(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			String sql = new StringBuilder()
					.append("SELECT													\n")
					.append("	A.manufacturing_date,								\n")	//0
					.append("	A.request_rev_no,									\n")	//1
					.append("	A.prod_plan_date,									\n")	//2
					.append("	A.plan_rev_no,										\n")	//3
					.append("	A.barcode_name,										\n")	//4
					.append("	A.prod_cd,											\n")	//5
					.append("	A.prod_rev_no,										\n")	//6
					.append("	A.prod_count_on_shelf,								\n")	//7
					.append("	TO_CHAR(A.start_time_freeze, 'YYYY-MM-DD HH24:MI'),	\n")	//8
		//			.append("	B.proper_freeze_time / 60 AS proper_time,			\n")
		//			.append("	TO_CHAR(											\n")
		//			.append("		ADDTIME(										\n")
		//			.append("			A.start_time_freeze, 						\n")
		//			.append("			MAKETIME(B.proper_freeze_time / 60, 0, 0)	\n")
		//			.append("		), 												\n")
		//			.append("		'YYYY-MM-DD HH24:MI'							\n")
		//			.append("	) AS expected_finish_time,							\n")
					.append("	NULL AS freezing_complete,							\n")	//9
					.append("	A.inout_status,										\n")	//10
					.append("	A.note,												\n")	//11
					.append("	A.barcode											\n")	//12
					.append("FROM													\n")
					.append("	tbi_production_rapid_freezer A						\n")
					.append("INNER JOIN tbm_product B								\n")
					.append("	ON A.prod_cd = B.prod_cd							\n")
					.append("	AND A.prod_rev_no = B.revision_no					\n")
					.append("WHERE inout_status = 'in'								\n")
					.toString();

			resultString = super.excuteQueryString(con, sql);
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M303S020500E104()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M303S020500E104()","==== finally ===="+ e.getMessage());
				}
	    	}
	    }
		ioParam.setResultString(resultString);
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
    	ioParam.setMessage(MessageDefine.M_QUERY_OK);

    	return EventDefine.E_QUERY_RESULT;
	}
	
	// 해당 제품코드와 오늘 날짜에 해당하는 생산작업요청서 조회
	public int E114(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArr = new JSONObject();
			jArr = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			
			String sql = new StringBuilder()
					.append("WITH table1 AS\n")
					.append("(\n")
					.append("SELECT\n")
					.append("	manufacturing_date,\n")
					.append("	request_rev_no,\n")
					.append("	prod_plan_date,\n")
					.append("	plan_rev_no,\n")
					.append("	prod_cd,\n")
					.append("	prod_rev_no\n")
					.append("FROM\n")
					.append("	tbi_production_request\n")
					.append("WHERE manufacturing_date = '" + jArr.get("manufacturing_date") +"'\n")
					.append("	AND prod_cd = '" + jArr.get("prod_cd") +"'\n")
					.append(")\n")
					.append("SELECT\n")
					.append("	t1.manufacturing_date,\n")
					.append("	t1.request_rev_no,\n")
					.append("	t1.prod_plan_date,\n")
					.append("	t1.plan_rev_no,\n")
					.append("	t1.prod_cd,\n")
					.append("	t1.prod_rev_no,\n")
					.append("	C.product_nm,\n")
					.append("	B.shelf_row,\n")
					.append("	B.shelf_column,\n")
					.append("	A.tray_prod_count\n")
					.append("FROM tbm_product_shelf A\n")
					.append("INNER JOIN tbm_facility_shelf B\n")
					.append("	ON A.shelf_type = B.shelf_type\n")
					.append("INNER JOIN tbm_product C\n")
					.append("	ON A.prod_cd = C.prod_cd\n")
					.append("	AND A.prod_rev_no = C.revision_no\n")
					.append("INNER JOIN table1 t1\n")
					.append("	ON A.prod_cd = t1.prod_cd\n")
					.append("	AND A.prod_rev_no = t1.prod_rev_no\n")
					.append("WHERE A.prod_cd = '" + jArr.get("prod_cd") +"'\n")
					.append("	AND A.prod_rev_no = t1.prod_rev_no\n")
					.append("	AND A.shelf_type = 'shelf1'\n")
					.toString();

			resultString = super.excuteQueryString(con, sql);
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M303S020500E114()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M303S020500E114()","==== finally ===="+ e.getMessage());
				}
	    	}
	    }
		ioParam.setResultString(resultString);
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
    	ioParam.setMessage(MessageDefine.M_QUERY_OK);

    	return EventDefine.E_QUERY_RESULT;
	}
	
	// 가져온 바코드에 해당하는 선반 조회
	public int E124(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArr = new JSONObject();
			jArr = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			
			String sql = new StringBuilder()
					.append("SELECT\n")
					.append("	A.manufacturing_date,\n")
					.append("	A.request_rev_no,\n")
					.append("	A.prod_plan_date,\n")
					.append("	A.plan_rev_no,\n")
					.append("	B.product_nm,\n")
					.append("	A.prod_cd,\n")
					.append("	A.prod_rev_no,\n")
					.append("	A.barcode,\n")
					.append("	A.prod_count_on_shelf,\n")
					.append("	DATE_FORMAT(DATE(A.start_time_freeze), '%Y-%m-%d') AS start_date_freeze,\n")
					.append("	TIME(A.start_time_freeze) AS start_time_freeze,\n")
					.append("	A.inout_status,\n")
					.append("	A.note,\n")
					.append("	D.shelf_row,\n")
					.append("	D.shelf_column,\n")
					.append("	C.tray_prod_count\n")
					.append("FROM\n")
					.append("	tbi_production_rapid_freezer A\n")
					.append("INNER JOIN tbm_product B\n")
					.append("	ON A.prod_cd = B.prod_cd\n")
					.append("	AND A.prod_rev_no = B.revision_no\n")
					.append("INNER JOIN tbm_product_shelf C\n")
					.append("	ON A.prod_cd = C.prod_cd\n")
					.append("	AND A.prod_rev_no = C.prod_rev_no\n")
					.append("INNER JOIN tbm_facility_shelf D\n")
					.append("	ON C.shelf_type = D.shelf_type\n")
					.append("WHERE\n")
					.append("	barcode = '" + jArr.get("barcode") +"'\n")
					.toString();

			resultString = super.excuteQueryString(con, sql);
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M303S020500E124()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M303S020500E124()","==== finally ===="+ e.getMessage());
				}
	    	}
	    }
		ioParam.setResultString(resultString);
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
    	ioParam.setMessage(MessageDefine.M_QUERY_OK);

    	return EventDefine.E_QUERY_RESULT;
	}
}