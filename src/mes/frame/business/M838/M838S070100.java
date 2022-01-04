package mes.frame.business.M838;

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


/**
 * 개요 : 이벤트ID별 메소드 정의
 */
public  class M838S070100 extends SqlAdapter{
	Connection con = null;
	PreparedStatement pstmt = null;
	String resultString = "";
	int resultInt = -1;
	StringBuffer sql = new StringBuffer();
	
	String[][] v_paramArray = new String[0][0]; 
	Class[] optClass = null;
	Object[] optObj = null;
	Object obj = null;
	
	public M838S070100(){
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
			
			Method method = M838S070100.class.getMethod(event,optClass);
			LoggingWriter.setLogDebug(M838S070100.class.getName(),"==== " + event + " EventMethod Create Success ====");

			obj = method.invoke(M838S070100.class.newInstance(),optObj);
			doExcute_result = CommonFunction.getInt(obj.toString());
			
	    } catch (Exception ex) {
	    	doExcute_result = EventDefine.E_DOEXCUTE_INIT;
			ioParam.setMessage(MessageDefine.M_NO_EVENTID);
			LoggingWriter.setLogError(M838S070100.class.getName(),"==== EventID Not define : EVENT ID [ " + ioParam.getEventID() + "]");
	    } finally {
	    	obj = null;
			optClass = null;
			optObj = null;
	    }
	    long endTime = System.currentTimeMillis();
		long runningTime = endTime - startTime;
		LoggingWriter.setLogAll(M838S070100.class.getName(),"==== Query [수행시간  : " + runningTime + " ms]");
		
		return doExcute_result;
	}
	
	// 부자재·부재료 입고검사기록 등록
	public int E101(InoutParameter ioParam){ 
		
		String sql = "";
		
		resultInt = EventDefine.E_DOEXCUTE_INIT;

		try {
			con = JDBCConnectionPool.getConnection();
			con.setAutoCommit(false);
			
    		JSONObject jArray = new JSONObject();
    		jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
    		System.out.println("JSONObject jArray rcvData="+ jArray.toString());
    			
    		String checklist_id = jArray.get("checklist_id").toString();
    		String regist_seq_no = "";
    		int cnt = 0;
    		
    		JSONObject data = (JSONObject) jArray.get("input_data");

    		sql = new StringBuilder()
    				.append("SELECT regist_seq_no\n")
    				.append("FROM haccp_check_ipgo_part \n")
    				.append("ORDER BY regist_seq_no DESC FOR ORDERBY_NUM() = 1\n")
    				.toString();

    		resultString = excuteQueryString(con, sql.toString());
    		
    		if(resultString.length() > 0) {
    			
    			regist_seq_no = resultString.trim();
    			
    			sql = new StringBuilder()
    					.append("SELECT COUNT(seq_no)\n")
    					.append("FROM haccp_check_ipgo_part_detail\n")
    					.append("WHERE regist_seq_no = "+regist_seq_no+"\n")
    					.toString();

    			resultString = excuteQueryString(con, sql.toString());
    			
    			if(resultString.length() > 0) {
    				cnt = Integer.parseInt(resultString.trim());
    			}
    			
    		}
    		
    		if(resultString.length() == 0 || cnt == 5) {
    			
    			sql = new StringBuilder()
    					.append("INSERT INTO\n")
    					.append("	haccp_check_ipgo_part (\n")
    					.append("		checklist_id,\n")
    					.append("		checklist_rev_no\n")
    					.append("	)\n")
    					.append("VALUES\n")
    					.append("	(\n")
    					.append("		'"+checklist_id+"',\n")
        				.append("		(SELECT MAX(checklist_rev_no) 				\n")
        				.append("		 FROM checklist								\n")
        				.append("		 WHERE checklist_id = '"+ checklist_id +"')\n")
    					.append("	)\n")
    					.toString();

        		resultInt = super.excuteUpdate(con, sql);
    	    	if(resultInt < 0) {
    				ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
    				con.rollback();
    				return EventDefine.E_DOEXCUTE_ERROR ;
    			}
    			
    	    	sql = new StringBuilder()
        				.append("SELECT regist_seq_no\n")
        				.append("FROM haccp_check_ipgo_part\n")
        				.append("ORDER BY regist_seq_no DESC FOR ORDERBY_NUM()  = 1\n")
        				.toString();

        		resultString = excuteQueryString(con, sql.toString());
        		
        		regist_seq_no = resultString.trim();
    	    	
    		}
    		
    		sql = new StringBuilder()
    				.append("INSERT INTO\n")
    				.append("	haccp_check_ipgo_part_detail (\n")
    				.append("		regist_seq_no,\n")
    				.append("		ipgo_date,\n")
    				.append("		cust_cd,\n")
    				.append("		cust_rev_no,\n")
    				.append("		part_cd,\n")
    				.append("		part_rev_no,\n")
    				.append("		trace_key,\n")
    				.append("		car_clean,\n")
    				.append("		visual_color,\n")
    				.append("		visual_smell,\n")
    				.append("		etc,\n")
    				.append("		docs_yn,\n")
    				.append("		bigo,\n")
    				.append("		person_write_id\n")
    				.append("	)\n")
    				.append("VALUES\n")
    				.append("	(\n")
    				.append("		 "  +regist_seq_no + ",\n")
    				.append(" 		'"	+ data.get("ipgo_date").toString() + "',		\n")
    				.append(" 		'"	+ data.get("cust_cd").toString() + "',			\n")
    				.append(" 		'"	+ data.get("cust_rev_no").toString() + "',		\n")
    				.append(" 		'"	+ data.get("part_cd").toString() + "',			\n")
    				.append(" 		'"	+ data.get("part_rev_no").toString() + "',		\n")
    				.append(" 		'"	+ data.get("trace_key").toString() + "',		\n")
    				.append(" 		'"	+ data.get("car_clean").toString()+ "',			\n")
    				.append(" 		'"	+ data.get("visual_color").toString() + "',		\n")
    				.append(" 		'"	+ data.get("visual_smell").toString() + "',		\n")
    				.append(" 		'"	+ data.get("etc").toString() + "',				\n")
    				.append(" 		'"	+ data.get("docs_yn").toString() + "',			\n")
    				.append(" 		'"	+ data.get("bigo").toString() + "',				\n")
    				.append(" 		'"	+ jArray.get("person_write_id").toString() + "'	\n")
    				.append("	)\n")
    				.toString();

    		resultInt = super.excuteUpdate(con, sql);
	    	if(resultInt < 0) {
				ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
				con.rollback();
				return EventDefine.E_DOEXCUTE_ERROR ;
			}

	    	// 입고검사완료
	    	sql = new StringBuilder()
	    			.append("UPDATE\n")
	    			.append("	tbi_balju_list2\n")
	    			.append("SET\n")
	    			.append("	doc_regist_yn = 'Y'\n")
	    			.append("WHERE\n")
	    			.append("	part_cd = '"+data.get("part_cd").toString()+"'\n")
	    			.append("	AND balju_no = '"+jArray.get("balju_no").toString()+"'\n")
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
			LoggingWriter.setLogError("M838S070100E101()","==== SQL ERROR ===="+ e.getMessage());
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
//		
//	// 원부재료입고검사 관리대장 상세 등록
//	public int E111(InoutParameter ioParam){ 
//		
//		String sql = "";
//		
//		resultInt = EventDefine.E_DOEXCUTE_INIT;
//
//		try {
//			con = JDBCConnectionPool.getConnection();
//			con.setAutoCommit(false);
//			
//    		JSONObject jArray = new JSONObject();
//    		jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
//    		System.out.println("JSONObject jArray rcvData="+ jArray.toString());
//    		
//    			sql = new StringBuilder()
//    				.append("INSERT INTO						\n")
//    				.append("	haccp_check_ipgo_part1_detail (	\n")
//    				.append("		checklist_id,				\n")
//    				.append("		checklist_rev_no,			\n")
//    				.append("       ipgo_date, 					\n")
//    				.append("		part_cd,					\n")
//    				.append("       part_rev_no, 				\n")
//    				.append(" 		trace_key,					\n")
//    				.append("       standard_yn, 				\n")
//    				.append(" 		packing_status,				\n")
//    				.append("		visual_inspection,			\n")
//    				.append("		temp_cold,					\n")
//    				.append("		temp_freeze,				\n")
//    				.append("		temp_room,					\n")
//    				.append("		car_clean,					\n")
//    				.append("		docs_yn,					\n")
//    				.append("		unsuit_action,				\n")
//    				.append("		check_yn					\n")
//    				.append(" 		)							\n")
//    				.append("VALUES (											\n")
//					.append(" 		'"	+ jArray.get("checklist_id") + "',		\n")
//					.append(" 		'"	+ jArray.get("checklist_rev_no") + "',	\n")
//					.append(" 		'"	+ jArray.get("ipgo_date") + "',			\n")
//					.append(" 		'"	+ jArray.get("part_cd") + "',			\n")
//					.append(" 		'"	+ jArray.get("part_rev_no") + "',		\n")
//					.append(" 		"	+ jArray.get("trace_key") + ",			\n")
//					.append(" 		'"	+ jArray.get("standard_yn") + "',		\n")
//					.append(" 		'"	+ jArray.get("packing_status") + "',	\n")
//					.append(" 		'"	+ jArray.get("visual_inspection") + "',	\n")
//					.append(" 		'"	+ jArray.get("temp_cold") + "',			\n")
//					.append(" 		'"	+ jArray.get("temp_freeze") + "',		\n")
//					.append(" 		'"	+ jArray.get("temp_room") + "',			\n")
//					.append(" 		'"	+ jArray.get("car_clean") + "',			\n")
//					.append(" 		'"	+ jArray.get("docs_yn") + "',			\n")
//					.append(" 		'"	+ jArray.get("unsuit_action") + "',		\n")
//					.append(" 		'"	+ jArray.get("check_yn") + "'			\n")
//					.append("	) 												\n")
//					.toString();
//		
//			resultInt = super.excuteUpdate(con, sql);
//	    	if(resultInt < 0){
//				ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
//				con.rollback();
//				return EventDefine.E_DOEXCUTE_ERROR ;
//			}
//	    	
//	    	//발주상세내역 테이블의 입고검사대장 등록 여부 확인을 'Y'으로 수정한다.
//	    	sql = new StringBuilder()
//    				.append("UPDATE								\n")
//    				.append("	tbi_balju_list2 SET				\n")
//    				.append("		doc_regist_yn = 'Y'			\n")
//    				.append("	WHERE trace_key = "	+ jArray.get("trace_key") + " 		\n")
//    				.append("    AND part_cd = 	'" + jArray.get("part_cd") + "'  		\n")
//    				.append("    AND part_rev_no = '"+ jArray.get("part_rev_no") + "' 	\n")
//    				.append("    AND balju_no = '"+ jArray.get("balju_no") + "' 		\n")
//    				.append("    AND balju_rev_no = '"+ jArray.get("balju_rev_no") + "' \n")
//					.toString();
//	    	
//	    	resultInt = super.excuteUpdate(con, sql);
//	    	if(resultInt < 0){
//				ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
//				con.rollback();
//				return EventDefine.E_DOEXCUTE_ERROR ;
//			}
//	    	
//			con.commit();
//    		
//		} catch(Exception e) {
//			e.getStackTrace();
//			LoggingWriter.setLogError("M838S070100E111()","==== SQL ERROR ===="+ e.getMessage());
//			return EventDefine.E_DOEXCUTE_ERROR ;
//	    } finally {
//	    	if (Config.useDataSource) {
//				try {
//					if (con != null) con.close();
//				} catch (Exception e) {
//				}
//	    	} else {
//	    	}
//	    }
//		ioParam.setResultString(resultString);
//		ioParam.setColumnCount("" + super.COLUMN_COUNT);
//    	ioParam.setMessage(MessageDefine.M_QUERY_OK);
//	    return EventDefine.E_QUERY_RESULT;
//	}
		
	
	// 원부재료입고검사 관리대장 수정
	public int E102(InoutParameter ioParam){ 
		
		String sql = "";
		
		resultInt = EventDefine.E_DOEXCUTE_INIT;

		try {
			con = JDBCConnectionPool.getConnection();
			con.setAutoCommit(false);
			
    		JSONObject jArray = new JSONObject();
    		jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
    		System.out.println("JSONObject jArray rcvData="+ jArray.toString());
    		
    		JSONObject data = (JSONObject) jArray.get("input_data");
    		
    		sql = new StringBuilder()
    				.append("UPDATE																		\n")
    				.append("	haccp_check_ipgo_part_detail SET							  			\n")
    				.append("       car_clean       = '" + data.get("car_clean").toString() + "', 	\n")
    				.append("       visual_color    = '" + data.get("visual_color").toString() + "', 	\n")
    				.append("       visual_smell    = '" + data.get("visual_smell").toString() + "', 	\n")
    				.append(" 		etc 		    = '" + data.get("etc").toString() + "',			\n")
    				.append(" 		docs_yn 	    = '" + data.get("docs_yn").toString() + "',		\n")
    				.append(" 		bigo 		    = '" + data.get("bigo").toString() + "',			\n")
    				.append(" 		person_write_id 	= '" + jArray.get("person_write_id").toString() + "',\n")
    				.append(" 		person_check_id 	= '',			\n")
    				.append(" 		person_approve_id 	= ''			\n")
    				.append("WHERE  seq_no 		    = '" + jArray.get("seq_no").toString() + "'			\n")
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
			LoggingWriter.setLogError("M838S070100E102()","==== SQL ERROR ===="+ e.getMessage());
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
//
//	// 원부재료입고검사 관리대장 상세 수정
//	public int E112(InoutParameter ioParam){ 
//		
//		String sql = "";
//		
//		resultInt = EventDefine.E_DOEXCUTE_INIT;
//	
//		try {
//			con = JDBCConnectionPool.getConnection();
//			con.setAutoCommit(false);
//			
//			JSONObject jArray = new JSONObject();
//			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
//			System.out.println("JSONObject jArray rcvData="+ jArray.toString());
//			
//			sql = new StringBuilder()
//					.append("UPDATE														 			\n")
//					.append("	haccp_check_ipgo_part1_detail SET						 			\n")
//					.append("		part_cd 	 = '"	+ jArray.get("part_cd") + "', 	 			\n")
//					.append("		part_rev_no  = '"	+ jArray.get("part_rev_no") + "', 			\n")
//					.append("       standard_yn = '"	+ jArray.get("standard_yn") + "',			\n")
//					.append("       packing_status = '"	+ jArray.get("packing_status") + "',		\n")
//					.append("       visual_inspection = '"+ jArray.get("visual_inspection") + "',	\n")
//					.append("       temp_cold = '"+ jArray.get("temp_cold") + "',		 			\n")
//					.append("       temp_freeze = '"+ jArray.get("temp_freeze") + "',		 		\n")
//					.append("       temp_room = '"+ jArray.get("temp_room") + "',		 			\n")
//					.append("       car_clean = '"+ jArray.get("car_clean") + "',		 			\n")
//					.append("       docs_yn = '"+ jArray.get("docs_yn") + "',			 			\n")
//					.append("       unsuit_action = '"+ jArray.get("unsuit_action") + "', 			\n")
//					.append("       ipgo_date = '"+ jArray.get("ipgo_date") + "' 					\n")
//					.append("WHERE seq_no =  "+ jArray.get("seq_no") + " 				 			\n")
//					.toString();
//		
//			resultInt = super.excuteUpdate(con, sql);
//	    	if(resultInt < 0){
//				ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
//				con.rollback();
//				return EventDefine.E_DOEXCUTE_ERROR ;
//			}
//			con.commit();
//			
//		} catch(Exception e) {
//			e.getStackTrace();
//			LoggingWriter.setLogError("M838S070100E112()","==== SQL ERROR ===="+ e.getMessage());
//			return EventDefine.E_DOEXCUTE_ERROR ;
//	    } finally {
//	    	if (Config.useDataSource) {
//				try {
//					if (con != null) con.close();
//				} catch (Exception e) {
//				}
//	    	} else {
//	    	}
//	    }
//		ioParam.setResultString(resultString);
//		ioParam.setColumnCount("" + super.COLUMN_COUNT);
//		ioParam.setMessage(MessageDefine.M_QUERY_OK);
//	    return EventDefine.E_QUERY_RESULT;
//	}
//	
	
	// 원부재료입고검사 관리대장 삭제
	public int E103(InoutParameter ioParam){ 
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		String sql = "";
		try {
			con = JDBCConnectionPool.getConnection();
			con.setAutoCommit(false);
			
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			System.out.println("JSONObject jArray rcvData="+ jArray.toString());
	
			sql = new StringBuilder()
					.append("DELETE FROM									\n")
					.append("	haccp_check_ipgo_part_detail				\n")
					.append("WHERE seq_no = '"+ jArray.get("seq_no") + "'	\n")
					.toString();
		
			resultInt = super.excuteUpdate(con, sql.toString());
	    	if(resultInt < 0){
				ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
				con.rollback();
				return EventDefine.E_DOEXCUTE_ERROR ;
			}
	    	
	    	// 입고검사기록 삭제
	    	sql = new StringBuilder()
	    			.append("UPDATE\n")
	    			.append("	tbi_balju_list2\n")
	    			.append("SET\n")
	    			.append("	doc_regist_yn = 'N'\n")
	    			.append("WHERE\n")
	    			.append("	part_cd = '"+jArray.get("part_cd").toString()+"'\n")
	    			.append("	AND trace_key = '"+jArray.get("trace_key").toString()+"'\n")
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
			LoggingWriter.setLogError("M838S070100E103()","==== SQL ERROR ===="+ e.getMessage());
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
	
//	
//	// 원부재료입고검사 관리대장 상세 삭제
//	public int E113(InoutParameter ioParam){ 
//		resultInt = EventDefine.E_DOEXCUTE_INIT;
//	
//		try {
//			con = JDBCConnectionPool.getConnection();
//			con.setAutoCommit(false);
//			
//			JSONObject jArray = new JSONObject();
//			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
//			System.out.println("JSONObject jArray rcvData="+ jArray.toString());
//	
//			String sql = new StringBuilder()
//					.append("DELETE FROM									\n")
//					.append("	haccp_check_ipgo_part1_detail 				\n")
//					.append("WHERE seq_no =  '"+ jArray.get("seq_no") + "'	\n")
//					.toString();
//		
//			resultInt = super.excuteUpdate(con, sql.toString());
//	    	if(resultInt < 0){
//				ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
//				con.rollback();
//				return EventDefine.E_DOEXCUTE_ERROR ;
//			}
//	    	
//	    	//발주상세내역 테이블의 입고검사대장 등록 여부 확인을 다시 'N'으로 수정한다.
//	    	sql = new StringBuilder()
//					.append("UPDATE														\n")
//					.append("	tbi_balju_list2 SET										\n")
//					.append("		doc_regist_yn = 'N'									\n")
//					.append("	WHERE trace_key = "	+ jArray.get("trace_key") + " 	  	\n")
//					.append("    AND part_cd = 	'" + jArray.get("part_cd") + "'  	  	\n")
//					.append("    AND part_rev_no = '"+ jArray.get("part_rev_no") + "' 	\n")
//					.append("    AND balju_no = '"+ jArray.get("balju_no") + "' 		\n")
//					.append("    AND balju_rev_no = '"+ jArray.get("balju_rev_no") + "' \n")
//					.toString();
//	    	
//	    	resultInt = super.excuteUpdate(con, sql);
//	    	if(resultInt < 0){
//				ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
//				con.rollback();
//				return EventDefine.E_DOEXCUTE_ERROR ;
//			}
//	    	
//			con.commit();
//		} catch(Exception e) {
//			e.getStackTrace();
//			LoggingWriter.setLogError("M838S070100E113()","==== SQL ERROR ===="+ e.getMessage());
//			return EventDefine.E_DOEXCUTE_ERROR ;
//	    } finally {
//	    	if (Config.useDataSource) {
//				try {
//					if (con != null) con.close();
//				} catch (Exception e) {
//				}
//	    	} else {
//	    	}
//	    }
//		ioParam.setResultString(resultString);
//		ioParam.setColumnCount("" + super.COLUMN_COUNT);
//		ioParam.setMessage(MessageDefine.M_QUERY_OK);
//	    return EventDefine.E_QUERY_RESULT;
//	}
//	
	
	// 부자재·부재료 입고검사기록 메인 테이블 조회
	public int E104(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));

			String sql = new StringBuilder()
					.append("SELECT\n")
					.append("	A2.checklist_id,\n")
					.append("	A2.checklist_rev_no,\n")
					.append("	A.ipgo_date,\n")
					.append("	A.seq_no,\n")
					.append("	A.regist_seq_no,\n")
					.append("	A.cust_cd,\n")
					.append("	A.cust_rev_no,\n")
					.append("	A.part_cd,\n")
					.append("	A.part_rev_no,\n")
					.append("	A.trace_key,\n")
					.append("	I.ipgo_date,\n")
					.append("	C.cust_nm,\n")
					.append("	P.part_nm,\n")
					.append("	TO_NUMBER(I.ipgo_amount),\n")
					.append("	U.user_nm AS person_write_id,\n")
					.append("	U2.user_nm AS person_check_id,\n")
					.append("	U3.user_nm AS person_approve_id\n")
					.append("FROM\n")
					.append("	haccp_check_ipgo_part_detail A \n")
					.append("	JOIN haccp_check_ipgo_part A2\n")
					.append("	ON A.regist_seq_no = A2.regist_seq_no\n")
					.append("	JOIN tbi_part_ipgo2 I\n")
					.append("	ON A.trace_key = I.trace_key\n")
					.append("	AND A.part_cd = I.part_cd\n")
					.append("	AND I.ipgo_type = '정상입고'\n")
					.append("	JOIN tbm_part_list P\n")
					.append("	ON A.part_cd = P.part_cd\n")
					.append("	JOIN tbm_customer C\n")
					.append("	ON A.cust_cd = C.cust_cd\n")
					.append("	LEFT JOIN tbm_users U\n")
					.append("	ON A.person_write_id = U.user_id\n")
					.append("	AND A.ipgo_date BETWEEN U.start_date AND U.duration_date\n")
					.append("	LEFT JOIN tbm_users U2\n")
					.append("	ON A.person_check_id = U2.user_id\n")
					.append("	AND A.ipgo_date BETWEEN U2.start_date AND U2.duration_date\n")
					.append("	LEFT JOIN tbm_users U3\n")
					.append("	ON A.person_approve_id = U3.user_id\n")
					.append("	AND A.ipgo_date BETWEEN U3.start_date AND U3.duration_date\n")
					.append("WHERE						                            \n")
					.append("	I.ipgo_date = '"+ jArray.get("ipgo_date") + "' \n")
					.append("ORDER BY I.ipgo_date DESC, A.seq_no DESC   \n")
					.toString();

			String ActionCommand = ioParam.getActionCommand();
			if(ActionCommand.startsWith("doQueryTableFieldName")) {
				resultString = super.excuteQueryStringTableFieldName(con, sql);
			} else {
				resultString = super.excuteQueryString(con, sql.toString());
			}
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M838S070100E104()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) {
						con.close();
					}
				} catch (Exception e) {
					LoggingWriter.setLogError("M838S070100E104()","==== finally ===="+ e.getMessage());
				}
	    	}
	    }

		ioParam.setResultString(resultString);
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
    	ioParam.setMessage(MessageDefine.M_QUERY_OK);

    	return EventDefine.E_QUERY_RESULT;
	}
	
	// 파일 등록
	public int E111(InoutParameter ioParam){ 
		resultInt = EventDefine.E_DOEXCUTE_INIT;

		try {
			con = JDBCConnectionPool.getConnection();

			// 클라이언트로 부터 받은 파라미터를 옮겨 담는다.
			String rcvData = (String)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));

			con.setAutoCommit(false);
    		
    		// 클라이언트로 부터 받은 파라미터를 쪼개어서 배열에 담는다. returnStringBuffer
			String[][] c_paramArray = CommonFunction.getConvString2DoubleArray(rcvData);
			
			System.out.println(rcvData);
			System.out.println(c_paramArray);
			System.out.println(c_paramArray.toString());
			
    		String sql = new StringBuilder()
    				.append("SELECT\n")
    				.append("	seq_no\n")
    				.append("FROM\n")
    				.append("	haccp_check_ipgo_part_detail\n")
    				.append("ORDER BY seq_no DESC FOR ORDERBY_NUM()  = 1\n")
    				.toString();

			resultString = super.excuteQueryString(con, sql.toString());
    		
			sql = new StringBuilder()
					.append("UPDATE haccp_check_ipgo_part_detail		  			  \n")
					.append("   SET file_name = '"+c_paramArray[0][10]+"',\n")	//file_view_name
					.append("   	file_path = '"+c_paramArray[0][11]+"',\n")	//file_path
					.append("   	regist_no = '"+c_paramArray[0][19]+"' \n")	//regist_no
					.append(" WHERE seq_no = "+resultString.trim()+"	  \n")
					.toString();

			resultInt = super.excuteUpdate(con, sql.toString());
	    	if(resultInt < 0){
				ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
				con.rollback();
				return EventDefine.E_DOEXCUTE_ERROR ;
			}
			con.commit();
		} catch(Exception e) {
			e.getStackTrace();
			LoggingWriter.setLogError("M838S070100E111()","==== SQL ERROR ===="+ e.getMessage());
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
	
	// 파일 수정
	public int E112(InoutParameter ioParam){ 
		resultInt = EventDefine.E_DOEXCUTE_INIT;

		try {
			con = JDBCConnectionPool.getConnection();

			// 클라이언트로 부터 받은 파라미터를 옮겨 담는다.
			String rcvData = (String)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));

			con.setAutoCommit(false);
    		
    		// 클라이언트로 부터 받은 파라미터를 쪼개어서 배열에 담는다. returnStringBuffer
			String[][] c_paramArray = CommonFunction.getConvString2DoubleArray(rcvData);
    		
			String sql = new StringBuilder()
					.append("UPDATE haccp_check_ipgo_part_detail					\n")
					.append("   SET file_name = '"+c_paramArray[0][10]+"',\n")	//file_view_name
					.append("   	file_path = '"+c_paramArray[0][11].replaceAll("//", "/")+"',\n")	//file_path
					.append("   	file_rev_no = '"+c_paramArray[0][8]+"',\n")	//file_rev_no
					.append("   	regist_no = '"+c_paramArray[0][18]+"'\n")	//regist_no
					.append(" WHERE seq_no = "+c_paramArray[0][24]+"\n")
					.toString();

			resultInt = super.excuteUpdate(con, sql.toString());
	    	if(resultInt < 0){
				ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
				con.rollback();
				return EventDefine.E_DOEXCUTE_ERROR ;
			}
			con.commit();
		} catch(Exception e) {
			e.getStackTrace();
			LoggingWriter.setLogError("M838S070100E112()","==== SQL ERROR ===="+ e.getMessage());
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
	
	// 파일 삭제(실제 파일 삭제 x DB 만 변경)
	public int E113(InoutParameter ioParam){ 
		resultInt = EventDefine.E_DOEXCUTE_INIT;

		try {
			
			con = JDBCConnectionPool.getConnection();
			
    		JSONObject jArray = new JSONObject();
    		jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
    		System.out.println("JSONObject jArray rcvData="+ jArray.toString());
    		
			String sql = new StringBuilder()
					.append("UPDATE haccp_check_ipgo_part_detail				\n")
					.append("   SET file_name = '',\n")	//file_view_name
					.append("   	file_path = ''\n")	//file_path
					.append(" WHERE seq_no = "+jArray.get("seq_no").toString()+"\n")
					.toString();

			resultInt = super.excuteUpdate(con, sql.toString());
	    	if(resultInt < 0){
				ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
				con.rollback();
				return EventDefine.E_DOEXCUTE_ERROR ;
			}
			con.commit();
		} catch(Exception e) {
			e.getStackTrace();
			LoggingWriter.setLogError("M838S070100E113()","==== SQL ERROR ===="+ e.getMessage());
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
	
	// 부자재·부재료 입고검사기록 서브 테이블 조회
	public int E114(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
//
//			String sql = new StringBuilder()
//					.append("SELECT\n")
//					.append("	A.checklist_id,				 \n")
//					.append("	A.checklist_rev_no,			 \n")
//					.append("	A.seq_no,			 		 \n")
//					.append("   A.ipgo_date, 				 \n")
//					.append("   A.part_cd, 			 		 \n")
//					.append("   A.part_rev_no, 				 \n")
//					.append("   D.part_nm,					 \n")
//					.append("   D.supplier,					 \n")
//					.append("   B.ipgo_amount, 				 \n")
//					.append("   E.expiration_date,			 \n")
//					.append("   A.trace_key, 			 	 \n")
//					.append("   A.standard_yn, 			 	 \n")
//					.append("   A.packing_status, 			 \n")
//					.append("   A.visual_inspection, 		 \n")
//					.append("   A.temp_cold, 		 		 \n")
//					.append("   A.temp_freeze, 		 		 \n")
//					.append("   A.temp_room, 		 		 \n")
//					.append("   A.car_clean, 		 		 \n")
//					.append("   A.docs_yn,					 \n")
//					.append("   A.unsuit_action, 		 	 \n")
//					.append("   A.check_yn, 		 		 \n")
//					.append("   F.balju_no, 				 \n")
//					.append("   F.balju_rev_no 				 \n")
//					.append("FROM											\n")
//					.append("	haccp_check_ipgo_part1_detail A				\n")
//					.append("INNER JOIN tbi_part_ipgo2 B 					\n")
//					.append("ON A.part_cd = B.part_cd 						\n")
//					.append("AND A.part_rev_no = B.part_rev_no 				\n")
//					.append("AND A.ipgo_date = B.ipgo_date                  \n")
//					.append("INNER JOIN tbm_part_list D 					\n")
//					.append("ON A.part_cd = D.part_cd 						\n")
//					.append("AND A.part_rev_no = D.revision_no 				\n")
//					.append("INNER JOIN tbi_part_storage2 E 				\n")
//					.append("ON A.part_cd = E.part_cd 						\n")
//					.append("AND A.part_rev_no = E.part_rev_no 				\n")
//					.append("INNER JOIN tbi_balju_list2 F 					\n")
//					.append("ON B.part_cd = F.part_cd 						\n")
//					.append("AND B.part_rev_no = F.part_rev_no 				\n")
//					.append("AND B.trace_key = F.trace_key 					\n")
//					.append("WHERE A.ipgo_date = '" + jArray.get("ipgo_date") + "' \n")
//					.append("GROUP BY A.part_cd \n")
//					.toString();

			String sql = new StringBuilder()
					.append("SELECT\n")
					.append("	seq_no,\n")
					.append("	ipgo_date,\n")
					.append("	car_clean,\n")
					.append("	visual_color,\n")
					.append("	visual_smell,\n")
					.append("	etc,\n")
					.append("	docs_yn,\n")
					.append("	bigo,\n")
					.append("	regist_no,\n")
					.append("	file_name,\n")
					.append("	file_path,\n")
					.append("	file_rev_no\n")
					.append("FROM\n")
					.append("	haccp_check_ipgo_part_detail \n")
					.append("WHERE\n")
					.append("	seq_no = '" + jArray.get("seq_no") + "' \n")
					.toString();
			
			String ActionCommand = ioParam.getActionCommand();
			if(ActionCommand.startsWith("doQueryTableFieldName")) {
				resultString = super.excuteQueryStringTableFieldName(con, sql);
			} else {
				resultString = super.excuteQueryString(con, sql.toString());
			}
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M838S070100E114()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) {
						con.close();
					}
				} catch (Exception e) {
					LoggingWriter.setLogError("M838S070100E114()","==== finally ===="+ e.getMessage());
				}
	    	}
	    }

		ioParam.setResultString(resultString);
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
    	ioParam.setMessage(MessageDefine.M_QUERY_OK);

    	return EventDefine.E_QUERY_RESULT;
	}
	
	
	// S838S070100_canvas.jsp
	public int E144(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			
			String sql = new StringBuilder()
					.append("SELECT\n")
					.append("	A2.checklist_id,\n")
					.append("	A2.checklist_rev_no,\n")
					.append("	A.seq_no,\n")
					.append("	A.regist_seq_no,\n")
					.append("	I.ipgo_date,\n")
					.append("	C.cust_nm,\n")
					.append("	P.part_nm,\n")
					.append("	TO_NUMBER(I.ipgo_amount),\n")
					.append("	car_clean,\n")
					.append("	visual_color,\n")
					.append("	visual_smell,\n")
					.append("	etc,\n")
					.append("	docs_yn,\n")
					.append("	bigo,\n")
					.append("	U.user_nm AS person_write_id,\n")
					.append("	U2.user_nm AS person_check_id,\n")
					.append("	U3.user_nm AS person_approve_id\n")
					.append("FROM\n")
					.append("	haccp_check_ipgo_part_detail A \n")
					.append("	JOIN haccp_check_ipgo_part A2\n")
					.append("	ON A.regist_seq_no = A2.regist_seq_no\n")
					.append("	JOIN tbi_part_ipgo2 I\n")
					.append("	ON A.trace_key = I.trace_key\n")
					.append("	AND A.part_cd = I.part_cd\n")
					.append("	AND I.ipgo_type = '정상입고'\n")
					.append("	JOIN tbm_part_list P\n")
					.append("	ON A.part_cd = P.part_cd\n")
					.append("	JOIN tbm_customer C\n")
					.append("	ON A.cust_cd = C.cust_cd\n")
					.append("	LEFT JOIN tbm_users U\n")
					.append("	ON A.person_write_id = U.user_id\n")
					.append("	AND A.ipgo_date BETWEEN U.start_date AND U.duration_date\n")
					.append("	LEFT JOIN tbm_users U2\n")
					.append("	ON A.person_check_id = U2.user_id\n")
					.append("	AND A.ipgo_date BETWEEN U2.start_date AND U2.duration_date\n")
					.append("	LEFT JOIN tbm_users U3\n")
					.append("	ON A.person_approve_id = U3.user_id\n")
					.append("	AND A.ipgo_date BETWEEN U3.start_date AND U3.duration_date\n")
					.append("WHERE A.regist_seq_no = "+jArray.get("regist_seq_no")+"\n")
					.toString();

			String ActionCommand = ioParam.getActionCommand();
			if(ActionCommand.startsWith("doQueryTableFieldName")) {
				resultString = super.excuteQueryStringTableFieldName(con, sql);
			} else {
				resultString = super.excuteQueryString(con, sql.toString());
			}
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M838S070100E144()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M838S070100E144()","==== finally ===="+ e.getMessage());
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
	
	// 수정하기 전 기존 데이터 불러오기
	public int E154(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			
			String sql = new StringBuilder()
					.append("SELECT\n")
					.append("	regist_seq_no,\n")
					.append("	seq_no,\n")
					.append("	ipgo_date,\n")
					.append("	trace_key,\n")
					.append("	cust_cd,\n")
					.append("	cust_rev_no,\n")
					.append("	part_cd,\n")
					.append("	part_rev_no,\n")
					.append("	car_clean,\n")
					.append("	visual_color,\n")
					.append("	visual_smell,\n")
					.append("	etc,\n")
					.append("	docs_yn,\n")
					.append("	bigo,\n")
					.append("	regist_no,\n")
					.append("	file_name,\n")
					.append("	file_path,\n")
					.append("	file_rev_no\n")
					.append("FROM\n")
					.append("	haccp_check_ipgo_part_detail A\n")
					.append("WHERE seq_no = "+jArray.get("seq_no").toString()+"\n")
					.toString();
			
//			String sql = new StringBuilder()
//					.append("SELECT\n")
//					.append("	F.seq_no,			 		 \n")
//					.append("   F.ipgo_date, 				 \n")
//					.append("   F.part_cd, 			 		 \n")
//					.append("   F.part_rev_no, 				 \n")
//					.append("   D.part_nm,					 \n")
//					.append("   D.supplier,					 \n")
//					.append("   B.ipgo_amount, 				 \n")
//					.append("   E.expiration_date,			 \n")
//					.append("   F.trace_key, 			 	 \n")
//					.append("   F.standard_yn, 			 	 \n")
//					.append("   F.packing_status, 			 \n")
//					.append("   F.visual_inspection, 		 \n")
//					.append("   F.temp_cold, 		 		 \n")
//					.append("   F.temp_freeze, 		 		 \n")
//					.append("   F.temp_room, 		 		 \n")
//					.append("   F.car_clean, 		 		 \n")
//					.append("   F.docs_yn,					 \n")
//					.append("   F.unsuit_action, 		 	 \n")
//					.append("   F.check_yn 		 		 	 \n")
//					.append("FROM											\n")
//					.append("haccp_check_ipgo_part1_detail F 				\n")
//					//.append("ON A.ipgo_date = F.ipgo_date 					\n")
//					.append("INNER JOIN tbi_part_ipgo2 B 					\n")
//					.append("ON F.part_cd = B.part_cd 						\n")
//					.append("AND F.part_rev_no = B.part_rev_no 				\n")
//					.append("INNER JOIN tbm_part_list D 					\n")
//					.append("ON F.part_cd = D.part_cd 						\n")
//					.append("AND F.part_rev_no = D.revision_no 				\n")
//					.append("INNER JOIN tbi_part_storage2 E 				\n")
//					.append("ON F.part_cd = E.part_cd 						\n")
//					.append("AND F.part_rev_no = E.part_rev_no 				\n")
//					.append("WHERE F.ipgo_date = '" + jArray.get("ipgo_date") + "' \n")
//					.append("AND D.part_gubun_b = '01' 						\n") //대분류번호 : 재료(01)
//					.append("GROUP BY F.part_cd \n")
//					.toString();
			String ActionCommand = ioParam.getActionCommand();
			if(ActionCommand.startsWith("doQueryTableFieldName")) {
				resultString = super.excuteQueryStringTableFieldName(con, sql.toString());
			} else {
				resultString = super.excuteQueryString(con, sql.toString());
			}
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M838S070100E154()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M838S070100E154()","==== finally ===="+ e.getMessage());
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
		
	// 점검표 승인자 서명
	public int E502(InoutParameter ioParam){ 
		
		resultInt = EventDefine.E_DOEXCUTE_INIT;

		try {
			con = JDBCConnectionPool.getConnection();
			con.setAutoCommit(false);
			
    		JSONObject jObj = new JSONObject();
    		jObj = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
    		
    		String sql = new StringBuilder()
    				.append("UPDATE haccp_check_ipgo_part_detail					\n")
    				.append("SET													\n")
    				.append("	person_approve_id = '" + jObj.get("userId") + "'	\n")
    				.append("WHERE seq_no = '"+ jObj.get("seq_no") + "'				\n")
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
			LoggingWriter.setLogError("M838S070100E502()","==== SQL ERROR ===="+ e.getMessage());
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
	
	// 점검표 확인자 서명
	public int E522(InoutParameter ioParam){ 
		
		resultInt = EventDefine.E_DOEXCUTE_INIT;

		try {
			con = JDBCConnectionPool.getConnection();
			con.setAutoCommit(false);
			
    		JSONObject jObj = new JSONObject();
    		jObj = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
    		
    		String sql = new StringBuilder()
    				.append("UPDATE haccp_check_ipgo_part_detail					\n")
    				.append("SET													\n")
    				.append("	person_check_id = '" + jObj.get("userId") + "'		\n")
    				.append("WHERE seq_no = '"+ jObj.get("seq_no") + "'				\n")
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
			LoggingWriter.setLogError("M838S070100E522()","==== SQL ERROR ===="+ e.getMessage());
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
}