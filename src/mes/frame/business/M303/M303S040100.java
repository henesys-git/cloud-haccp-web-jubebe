package mes.frame.business.M303;

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


public class M303S040100 extends SqlAdapter{
	Connection con = null;
	PreparedStatement pstmt = null;
	String resultString = "";
	int resultInt = -1;
	StringBuffer sql = new StringBuffer();
	
	String[][] v_paramArray = new String[0][0]; 
	Class[] optClass = null;
	Object[] optObj = null;
	Object obj = null;
	
	public M303S040100(){
	}
	
	public int custParamCheck(InoutParameter ioParam, StringBuffer p_sql){
		int paramInt = 0;
		return paramInt;
	}
	
	public int paramCheck(InoutParameter ioParam, StringBuffer p_sql){
		v_paramArray = super.getParamCheck(ioParam,p_sql);
		return v_paramArray[0].length;
	}
	
	public int doExcute(InoutParameter ioParam){
		long startTime = System.currentTimeMillis();
		int doExcute_result = EventDefine.E_DOEXCUTE_INIT;;
		String event = ioParam.getEventSubID();
		
	    try{
            optClass = new Class[1];
			optClass[0] = ioParam.getClass() ;
			optObj = new Object[1];
			optObj[0] = ioParam;
			
			Method method = M303S040100.class.getMethod(event,optClass);
			LoggingWriter.setLogDebug(M303S040100.class.getName(),"==== " + event + " EventMethod Create Success ====");

			obj = method.invoke(M303S040100.class.newInstance(),optObj);
			doExcute_result = CommonFunction.getInt(obj.toString());
			
	    } catch (Exception ex) {
	    	doExcute_result = EventDefine.E_DOEXCUTE_INIT;
			ioParam.setMessage(MessageDefine.M_NO_EVENTID);
			LoggingWriter.setLogError(M303S040100.class.getName(),"==== EventID Not define : EVENT ID [ " + ioParam.getEventID() + "]");
	    } finally {
	    	obj = null;
			optClass = null;
			optObj = null;
	    }
	    long endTime = System.currentTimeMillis();
		long runningTime = endTime - startTime;
		LoggingWriter.setLogAll(M303S040100.class.getName(),"==== Query [수행시간  : " + runningTime + " ms]");
		
		return doExcute_result;
	}
	
	//작업지시 등록
	//yumsam
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
						.append("		'"+jArrayHead.get("prodPlanDate")+"',		\n")
						.append("		'"+jArrayHead.get("planRevNo")+"',			\n")
						.append("		'"+jArrayHead.get("prodCd")+"',				\n")
						.append("		'"+jArrayHead.get("prodRevNo")+"',			\n")
						.append("		'"+jArrayHead.get("dateExpiration")+"',		\n")
						.append("		'"+jArrayHead.get("lossRate")+"',			\n")
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
								.append("		'"+jArrayHead.get("prodPlanDate")+"',	\n")
								.append("		"+jArrayHead.get("planRevNo")+",		\n")
								.append("		'"+jArrayHead.get("prodCd")+"',			\n")
								.append("		"+jArrayHead.get("prodRevNo")+",		\n")
								.append("		'"+jArrSubBody.get("partCd")+"',		\n")
								.append("		"+jArrSubBody.get("partRevNo")+",		\n")
								.append("		"+jArrSubBody.get("bomRevNo")+",		\n")
								.append("		'"+jArrSubBody.get("ttlBlendAmt")+"',	\n")
								.append("		''										\n")
								.append("	);											\n")
								.toString();

						resultInt = super.excuteUpdate(con, sql);
						if (resultInt < 0) {
							ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
							con.rollback();
							return EventDefine.E_DOEXCUTE_ERROR ;
						} else {
							sql = new StringBuilder()
								.append("UPDATE														\n")
								.append("	tbi_production_plan_daily_detail						\n")
								.append("SET														\n")
								.append("	work_ordered_yn = 'Y'									\n")
								.append("WHERE														\n")
								.append("	prod_plan_date = '"+jArrayHead.get("prodPlanDate")+"'	\n")
								.append("	AND plan_rev_no = '"+jArrayHead.get("planRevNo")+"'		\n")
								.append("	AND prod_cd = '"+jArrayHead.get("prodCd")+"'			\n")
								.append("	AND prod_rev_no = '"+jArrayHead.get("prodRevNo")+"'		\n")
								.append("   AND plan_type = '"+jArrayHead.get("planType")+"' 		\n")
								.toString();
							
							resultInt = super.excuteUpdate(con, sql);
							if (resultInt < 0) {
								ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
								con.rollback();
								return EventDefine.E_DOEXCUTE_ERROR;
							}
						}
					}
				}
	    		
				con.commit();
			} catch(Exception e) {
				LoggingWriter.setLogError("M303S040100E101()","==== SQL ERROR ===="+ e.getMessage());
				return EventDefine.E_DOEXCUTE_ERROR ;
		    } finally {
		    	if (Config.useDataSource) {
					try {
						if (con != null) con.close();
					} catch (Exception e) {
						LoggingWriter.setLogError("M303S040100E101()","==== finally ===="+ e.getMessage());
					}
		    	}
		    }
			ioParam.setResultString(resultString);
			ioParam.setColumnCount("" + super.COLUMN_COUNT);
	    	ioParam.setMessage(MessageDefine.M_QUERY_OK);
		    return EventDefine.E_QUERY_RESULT;
	} 
	
	//작업지시서 수정
	//yumsam
	public int E102(InoutParameter ioParam){ 
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
						.append("		'"+jArrayHead.get("manufacturing_date")+"',	\n")
						.append("		'"+jArrayHead.get("request_rev_no")+"' + 1,	\n")
						.append("		'"+jArrayHead.get("prod_plan_date")+"',		\n")
						.append("		'"+jArrayHead.get("plan_rev_no")+"',		\n")
						.append("		'"+jArrayHead.get("prod_cd")+"',			\n")
						.append("		'"+jArrayHead.get("prod_rev_no")+"',		\n")
						.append("		'"+jArrayHead.get("expiration_date")+"',	\n")
						.append("		"+jArrayHead.get("loss_rate")+",			\n")
						.append("		'요청',										\n")
						.append("		'"+jArrayHead.get("note")+"'				\n")
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
								.append("	tbi_production_request_detail (				\n")
								.append("		manufacturing_date,						\n")
								.append("		request_rev_no,							\n")
								.append("		prod_plan_date,							\n")
								.append("		plan_rev_no,							\n")
								.append("		prod_cd,								\n")
								.append("		prod_rev_no,							\n")
								.append("		part_cd,								\n")
								.append("		part_rev_no,							\n")
								.append("		bom_rev_no,								\n")
								.append("		blending_amount_plan,					\n")
								.append("		reason_diff								\n")
								.append(")												\n")
								.append("VALUES (										\n")
								.append("		'"+jArrayHead.get("manufacturing_date")+"',\n")
								.append("		'"+jArrayHead.get("request_rev_no")+"' + 1,		\n")
								.append("		'"+jArrayHead.get("prod_plan_date")+"',			\n")
								.append("		'"+jArrayHead.get("plan_rev_no")+"',			\n")
								.append("		'"+jArrayHead.get("prod_cd")+"',				\n")
								.append("		'"+jArrayHead.get("prod_rev_no")+"',			\n")
								.append("		'"+jArrSubBody.get("part_cd")+"',				\n")
								.append("		'"+jArrSubBody.get("part_rev_no")+"',			\n")
								.append("		'"+jArrSubBody.get("bom_rev_no")+"',			\n")
								.append("		'"+jArrSubBody.get("blending_amount_plan")+"',	\n")
								.append("		''												\n")
								.append("	);													\n")
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
				LoggingWriter.setLogError("M303S040100E102()","==== SQL ERROR ===="+ e.getMessage());
				return EventDefine.E_DOEXCUTE_ERROR ;
		    } finally {
		    	if (Config.useDataSource) {
					try {
						if (con != null) con.close();
					} catch (Exception e) {
						LoggingWriter.setLogError("M303S040100E102()","==== finally ===="+ e.getMessage());
					}
		    	}
		    }
			ioParam.setResultString(resultString);
			ioParam.setColumnCount("" + super.COLUMN_COUNT);
	    	ioParam.setMessage(MessageDefine.M_QUERY_OK);
		    return EventDefine.E_QUERY_RESULT;
	}	
	
	//작업지시 삭제 
	//yumsam
	public int E103(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject();
    		jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
    		System.out.println("JSONObject jArray rcvData="+ jArray.toString());
			
			con.setAutoCommit(false);
					
    		String sql = new StringBuilder()
    					.append("DELETE FROM tbi_production_request \n")
    					.append("WHERE prod_plan_date='" + jArray.get("prod_plan_date") + "'\n")
    					.append("AND prod_cd='" + jArray.get("prod_cd") + "'\n")
    					.append("AND plan_rev_no='" + jArray.get("plan_rev_no") + "'\n")
    					.append("AND prod_rev_no='" + jArray.get("prod_rev_no") +"' \n")
    					.toString();
			
    		resultInt = super.excuteUpdate(con, sql.toString());
    		if (resultInt < 0) {  
				ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
				con.rollback();
				return EventDefine.E_DOEXCUTE_ERROR ;
			} else {
				sql = new StringBuilder()
    					.append("DELETE FROM tbi_production_request_detail \n")
    					.append("WHERE prod_plan_date='" + jArray.get("prod_plan_date") + "'\n")
    					.append("  AND prod_cd='" + jArray.get("prod_cd") + "'\n")
    					.append("  AND plan_rev_no='" + jArray.get("plan_rev_no") + "'\n")
    					.append("  AND prod_rev_no='" + jArray.get("prod_rev_no") +"' \n")
    					.toString();
				
				resultInt = super.excuteUpdate(con, sql.toString());
	    		if (resultInt < 0) {
					ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
					con.rollback();
					return EventDefine.E_DOEXCUTE_ERROR ;
				} else {
				//work_ordered_yn = 'N' 변경
				  sql = new StringBuilder()
						  .append("UPDATE tbi_production_plan_daily_detail \n")
						  .append("SET work_ordered_yn = 'N'  			   \n")
						  .append("WHERE prod_plan_date = '" + jArray.get("prod_plan_date") + "' \n")
						  .append("  AND prod_cd = '" + jArray.get("prod_cd") + "' \n")
						  .append("  AND plan_rev_no='" + jArray.get("plan_rev_no") + "'\n")
						  .append("  AND prod_rev_no='" + jArray.get("prod_rev_no") +"' \n")
						  .toString();
				  
				  resultInt = super.excuteUpdate(con, sql.toString());
					if (resultInt < 0) {
						ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
						con.rollback();
						return EventDefine.E_DOEXCUTE_ERROR ;
					}
				}
			} 
			con.commit();
		} catch(Exception e) {
			LoggingWriter.setLogError("M303S040100E103()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M303S040100E103()","==== finally ===="+ e.getMessage());
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
			
			String sql = new StringBuilder()
					.append("SELECT																\n")
					.append("    C.product_nm, 													\n")
					.append("    C.gugyuk,	 													\n")
					.append("    A.manufacturing_date, 											\n")
					.append("    B.plan_amount, 												\n")
					.append("    A.expiration_date, 											\n")
					.append("    A.loss_rate, 													\n")
					.append("    B.plan_amount / A.loss_rate * 100 AS total_blending_amount, 	\n")
					.append("    -- 아래는는 서브테이블을 부르기 위한 데이터들	  								\n")
					.append("    A.request_rev_no, 												\n")
					.append("    A.prod_plan_date, 												\n")
					.append("    A.plan_rev_no, 												\n")
					.append("    A.prod_cd, 													\n")
					.append("    A.prod_rev_no, 												\n")
					.append("    A.work_status,  												\n")
					.append("	 A.note  														\n")
					.append("FROM tbi_production_request A 										\n")
					.append("INNER JOIN tbi_production_plan_daily_detail B 						\n")
					.append("    ON A.prod_plan_date = B.prod_plan_date 						\n")
					.append("    AND A.plan_rev_no = B.plan_rev_no 								\n")
					.append("    AND A.prod_cd = B.prod_cd 										\n")
					.append("INNER JOIN tbm_product C 											\n")
					.append("    ON A.prod_cd = C.prod_cd 										\n")
					.append("    AND A.prod_rev_no = C.revision_no 								\n")
					.append("WHERE A.manufacturing_date 										\n")
					.append("		BETWEEN '" + jArray.get("fromdate") + "' 					\n")
					.append("	 		AND '" + jArray.get("todate") + "'						\n")
					.append("    AND A.request_rev_no = (SELECT MAX(request_rev_no)      		\n")
					.append("       				FROM tbi_production_request D       		\n")
					.append("      					WHERE A.prod_cd = D.prod_cd 				\n")
					.append("      					  AND A.prod_rev_no = D.prod_rev_no 		\n")
					.append("      					  AND A.prod_plan_date = D.prod_plan_date 	\n")
					.append("      					  AND A.plan_rev_no = D.plan_rev_no) 		\n")
					.append("   AND B.work_ordered_yn = 'Y' 									\n")
					.toString();

			String ActionCommand = ioParam.getActionCommand();
			if(ActionCommand.startsWith("doQueryTableFieldName")) {
				resultString = super.excuteQueryStringTableFieldName(con, sql);
			} else {
				resultString = super.excuteQueryString(con, sql);
			}
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M303S040100E104()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M303S040100E104()","==== finally ===="+ e.getMessage());
				}
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
					.append("	C.packing_qtty || C.unit_type,										\n")
					.append("	D.blending_ratio,													\n")
					.append("	A.blending_amount_plan												\n")
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
					.append("   AND D.start_date <= A.manufacturing_date							\n")
					.append("   AND D.duration_date >= A.manufacturing_date							\n")
					.append("WHERE A.manufacturing_date = '" + jArray.get("manufacturingDate") + "'	\n")
					.append("	AND A.request_rev_no = " + jArray.get("requestRevNo") + "			\n")
					.append("	AND A.prod_plan_date = '" + jArray.get("prodPlanDate") + "'			\n")
					.append("	AND A.plan_rev_no = " + jArray.get("planRevNo") + "					\n")
					.append("	AND A.prod_cd = '" + jArray.get("prodCd") + "'						\n")
					.append("	AND A.prod_rev_no = " + jArray.get("prodRevNo") + "					\n")
					.append("   AND D.bom_rev_no = (SELECT MAX(bom_rev_no) 							\n")
					.append("						 FROM tbm_bom_info2 E 							\n")
					.append("						 WHERE D.prod_cd = E.prod_cd					\n")
					.append("						 AND D.part_cd = E.part_cd)						\n")
					.toString();

			String ActionCommand = ioParam.getActionCommand();
			if(ActionCommand.startsWith("doQueryTableFieldName")) {
				resultString = super.excuteQueryStringTableFieldName(con, sql.toString());
			} else {
				resultString = super.excuteQueryString(con, sql.toString());
			}
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M303S040100E114()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M303S040100E114()","==== finally ===="+ e.getMessage());
				}
	    	}
	    }
		ioParam.setResultString(resultString);
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
    	ioParam.setMessage(MessageDefine.M_QUERY_OK);

    	return EventDefine.E_QUERY_RESULT;
	}
	
	// 선택된 날짜의 생산계획에 등록되었고 
	// 아직 요청 지시가 안된 완제품 목록을 불러온다
	// yumsam
	public int E174(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			
			String sql = new StringBuilder()
					.append("SELECT                                                 			\n")
					.append("	A.prod_plan_date,                                     			\n")
					.append("   A.plan_type, 													\n")
					.append("	C.code_name,	                                     			\n")
					.append("	B.product_nm,                                         			\n")
					.append("	A.plan_amount,                                        			\n")
					.append("	A.plan_rev_no,                                        			\n")
					.append("	A.prod_cd,                                            			\n")
					.append("	A.prod_rev_no,                                        			\n")
					.append("	B.expiration_date,                                     			\n")
					.append("	B.gugyuk		                                     			\n")
					.append("FROM                                                   			\n")
					.append("	tbi_production_plan_daily_detail A                    			\n")
					.append("INNER JOIN tbm_product B                               			\n")
					.append("	ON A.prod_cd = B.prod_cd                              			\n")
					.append("	AND A.prod_rev_no = B.revision_no                     			\n")
					.append("INNER JOIN tbm_code_book C                               			\n")
					.append("	ON A.plan_type = C.code_value                          			\n")
					.append("WHERE                                                  			\n")
					.append("	prod_plan_date = '" + jArray.get("selectedDate") + "' 			\n")
					.append("	AND plan_rev_no = (SELECT MAX(plan_rev_no)            			\n")
					.append("					   FROM tbi_production_plan_daily_detail C    	\n")
					.append("					   WHERE C.prod_plan_date = A.prod_plan_date) 	\n")
					.append("	AND work_ordered_yn != 'Y'                            			\n")
					.toString();
			
			String ActionCommand = ioParam.getActionCommand();
			if(ActionCommand.startsWith("doQueryTableFieldName")) {
				resultString = super.excuteQueryStringTableFieldName(con, sql);
			} else {
				resultString = super.excuteQueryString(con, sql);
			}
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M303S040100E174()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M303S040100E174()","==== finally ===="+ e.getMessage());
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
					.append("	C.packing_qtty || ' ' || C.unit_type,						\n")
					.append("	TO_CHAR(A.blending_ratio) AS blending_ratio,				\n")
					.append("	NULL AS blending_amount_plan,								\n")
					.append("	C.part_cd,													\n")
					.append("	C.revision_no,												\n")
					.append("	A.bom_rev_no												\n")
					.append("FROM tbm_bom_info2 A											\n")
					.append("INNER JOIN tbm_product B										\n")
					.append("	ON A.prod_cd = B.prod_cd									\n")
					.append("	AND A.prod_rev_no = B.revision_no							\n")
					.append("INNER JOIN tbm_part_list C										\n")
					.append("	ON A.part_cd = C.part_cd									\n")
					.append("	AND A.part_rev_no = C.revision_no							\n")
					.append("WHERE A.prod_cd = '" + jArray.get("prodCd") + "'				\n")
					.append("	AND A.prod_rev_no = " + jArray.get("prodRevNo") + "			\n")
					.append("	AND A.delyn != 'Y'											\n")
					.append("   AND A.bom_rev_no = (SELECT MAX(bom_rev_no) 					\n")
					.append("						FROM tbm_bom_info2 E 					\n")
					.append("						WHERE A.prod_cd = E.prod_cd				\n")
					.append("						AND A.part_cd = E.part_cd)				\n")
					.toString();
			
			String ActionCommand = ioParam.getActionCommand();
			if(ActionCommand.startsWith("doQueryTableFieldName")) {
				resultString = super.excuteQueryStringTableFieldName(con, sql);
			} else {
				resultString = super.excuteQueryString(con, sql);
			}
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M303S040100E184()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M303S040100E184()","==== finally ===="+ e.getMessage());
				}
	    	}
	    }
		ioParam.setResultString(resultString);
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
    	ioParam.setMessage(MessageDefine.M_QUERY_OK);

    	return EventDefine.E_QUERY_RESULT;
	}
	
	// 지시서 수정에서 완제품 목록을 불러온다.
	// yumsam
	public int E194(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArr = new JSONObject();
			jArr = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			
			String sql = new StringBuilder()
					.append("SELECT 																\n")
					.append("	C.part_nm,															\n")
					.append("	C.gyugyeok,															\n")
					.append("	B.blending_ratio,													\n")
					.append("	A.blending_amount_plan,												\n")
					.append("	C.part_cd,															\n")
					.append("	C.revision_no,														\n")
					.append("	B.bom_rev_no														\n")
					.append("FROM tbi_production_request_detail A									\n")
					.append("INNER JOIN tbm_bom_info2 B												\n")
					.append("	ON A.prod_cd = B.prod_cd											\n")
					.append("	AND A.prod_rev_no = B.prod_rev_no									\n")
					.append("	AND A.part_cd = B.part_cd											\n")
					.append("	AND A.part_rev_no = B.part_rev_no									\n")
					.append("	AND A.bom_rev_no = B.bom_rev_no										\n")
					.append("INNER JOIN tbm_part_list C												\n")
					.append("	ON B.part_cd = C.part_cd											\n")
					.append("	AND B.part_rev_no = C.revision_no									\n")
					.append("WHERE A.manufacturing_date = '" + jArr.get("manufacturing_date") + "'	\n")
					.append("	AND A.request_rev_no = " + jArr.get("request_rev_no") + "			\n")
					.append("	AND A.prod_plan_date = '" + jArr.get("prod_plan_date") + "'			\n")
					.append("	AND A.plan_rev_no = " + jArr.get("plan_rev_no") + "					\n")
					.append("	AND A.prod_cd = '" + jArr.get("prod_cd") + "'						\n")
					.append("   AND A.prod_rev_no = " + jArr.get("prod_rev_no") + "					\n")
					.toString();
		
			resultString = super.excuteQueryString(con, sql);
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M303S040100E194()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M303S040100E194()","==== finally ===="+ e.getMessage());
				}
	    	}
	    }
		ioParam.setResultString(resultString);
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
    	ioParam.setMessage(MessageDefine.M_QUERY_OK);

    	return EventDefine.E_QUERY_RESULT;
	}
}