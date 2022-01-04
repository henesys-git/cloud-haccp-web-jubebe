package mes.frame.business.M101;

import java.lang.reflect.Method;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.util.Vector;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;

import mes.frame.business.product.ProductCountCalculator;
import mes.frame.common.ApprovalActionNo;
import mes.client.conf.Config;
import mes.client.util.OrderNumberGenerator;
import mes.frame.common.EventDefine;
import mes.frame.common.HashObject;
import mes.frame.common.MessageDefine;
import mes.frame.common.QueueProcessing;
import mes.frame.database.JDBCConnectionPool;
import mes.frame.database.SqlAdapter;
import mes.frame.serviceinterface.InoutParameter;
import mes.frame.serviceinterface.LoggingWriter;
import mes.frame.util.CommonFunction;




public class M101S020100 extends SqlAdapter{
	Connection con = null;
	PreparedStatement pstmt = null;
	String resultString = "";
	int resultInt = -1;
	QueueProcessing Queue = new QueueProcessing();
	
	StringBuffer sql = new StringBuffer();
	String[][] v_paramArray = new String[0][0]; 
	Class[] optClass = null;
	Object[] optObj = null;
	Object obj = null;
	
	public M101S020100(){
	}
	
	/**
	 * 사용자가 정의해서 파라메터 검증하는 method.tb_orderinfo_detail
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
			
			Method method = M101S020100.class.getMethod(event,optClass);
			LoggingWriter.setLogDebug(M101S020100.class.getName(),"==== " + event + " EventMethod Create Success ====");

			obj = method.invoke(M101S020100.class.newInstance(),optObj);
			doExcute_result = CommonFunction.getInt(obj.toString());
			
	    } catch (Exception ex) {
	    	doExcute_result = EventDefine.E_DOEXCUTE_INIT;
			ioParam.setMessage(MessageDefine.M_NO_EVENTID);
			LoggingWriter.setLogError(M101S020100.class.getName(),"==== EventID Not define : EVENT ID [ " + ioParam.getEventID() + "]");
	    } finally {
	    	obj = null;
			optClass = null;
			optObj = null;
	    }
	    long endTime = System.currentTimeMillis();
		long runningTime = endTime - startTime;
		LoggingWriter.setLogAll(M101S020100.class.getName(),"==== Query [수행시간  : " + runningTime + " ms]");
		
		return doExcute_result;
	}
	
	/* yumsam */
	public int E101(InoutParameter ioParam) {
		resultInt = EventDefine.E_DOEXCUTE_INIT;

		String sql = "";
		
		try {
			con = JDBCConnectionPool.getConnection();
			con.setAutoCommit(false);
			
			JSONObject rcvData = new JSONObject();
    		rcvData = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			
    		JSONObject rcvHead = (JSONObject) rcvData.get("paramHead");
    		JSONArray rcvBody = (JSONArray) rcvData.get("param");
    		
    		String orderNum = OrderNumberGenerator.generateOdrNum();
    		
			sql = new StringBuilder()
					.append("INSERT INTO tbi_order2	(					\n")
					.append("	order_no,								\n")
					.append("	order_rev_no,							\n")
					.append("	order_type,								\n")
					.append("	order_date,								\n")
					.append("	delivery_date,							\n")
					.append("	note,									\n")
					.append("	cust_cd,								\n")
					.append("	cust_rev_no								\n")
					.append(")											\n")
					.append("VALUES ( 									\n")
					.append("	'" + orderNum + "',						\n")
					.append("	0,										\n")
					.append("	'" + rcvHead.get("order_type") + "',	\n")
					.append("	'" + rcvHead.get("order_date") + "',	\n")
					.append("	'" + rcvHead.get("delivery_date") + "',	\n")
					.append("	'" + rcvHead.get("bigo") + "',			\n")
					.append("	'" + rcvHead.get("cust_cd") + "',		\n")
					.append("	'" + rcvHead.get("cust_rev") + "'		\n")
					.append(");											\n")
					.toString();
    		 
			resultInt = super.excuteUpdate(con, sql);
    		if (resultInt < 0) {
				ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
				con.rollback();
				return EventDefine.E_DOEXCUTE_ERROR ;
			}
	    		
			for(int i = 0; i < rcvBody.size(); i++) {
				JSONObject eachRow = (JSONObject) rcvBody.get(i); // i번째 데이터묶음
				
				String prodCd = (String) eachRow.get("prod_cd");
				int revNo = Integer.parseInt(eachRow.get("prod_rev").toString());
				int count = Integer.parseInt(eachRow.get("order_count").toString());
				/* 
				 * 낱개,내포장,외포장 구분에 따라 주문 개수를 다르게 저장하려 했는데 일단 보류 
				 * needtocheck
				 * */
//				String unitType = (String) eachRow.get("unit_type");
//				
//				ProductCountCalculator cal = new ProductCountCalculator(prodCd, revNo, count, unitType);
//				int orderCount = cal.calculate();
				
				sql = new StringBuilder()
					.append("INSERT INTO tbi_order_detail2 (		\n")
					.append("	prod_cd,							\n")
					.append("	prod_rev_no,						\n")
					.append("	order_no,							\n")
					.append("	order_count,						\n")
					.append("	note								\n")
					.append(")										\n")
					.append("VALUES (								\n")
					.append("	'" + prodCd + "',					\n")
					.append("	'" + revNo + "',					\n")
					.append("	'" + orderNum + "',					\n")
					.append("	" + count + ",						\n")
					.append("	'" + eachRow.get("order_note") + "' \n")
					.append(");										\n")
					.toString();
				 
				resultInt = super.excuteUpdate(con, sql);
				if (resultInt < 0) {
					ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
					con.rollback();
					return EventDefine.E_DOEXCUTE_ERROR ;
				}
			}
		    	
			con.commit();
		} catch(Exception e) {
			LoggingWriter.setLogError("M101S020100E101()","==== SQL ERROR ===="+ e.getMessage());
			e.printStackTrace();
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M101S020100E101()","==== finally ===="+ e.getMessage());
				}
	    	}
	    }
		ioParam.setResultString(resultString);
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
    	ioParam.setMessage(MessageDefine.M_QUERY_OK);
	    return EventDefine.E_QUERY_RESULT;
	}
	
	/* yumsam */
	public int E102(InoutParameter ioParam) {
		resultInt = EventDefine.E_DOEXCUTE_INIT;

		String sql = "";
		
		try {
			con = JDBCConnectionPool.getConnection();
			con.setAutoCommit(false);
			
			JSONObject rcvData = new JSONObject();
    		rcvData = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			
    		JSONObject rcvHead = (JSONObject) rcvData.get("paramHead");
    		JSONArray rcvBody = (JSONArray) rcvData.get("param");
    		
    		String orderNo = (String) rcvHead.get("order_no");
    		String orderRevNo = (String) rcvHead.get("order_rev_no");
    		int newOrderRevNo = Integer.parseInt(orderRevNo) + 1;
    		
			sql = new StringBuilder()
					.append("INSERT INTO tbi_order2	(					\n")
					.append("	order_no,								\n")
					.append("	order_rev_no,							\n")
					.append("	order_type,								\n")
					.append("	order_date,								\n")
					.append("	delivery_date,							\n")
					.append("	note,									\n")
					.append("	cust_cd,								\n")
					.append("	cust_rev_no								\n")
					.append(")											\n")
					.append("VALUES ( 									\n")
					.append("	'" + orderNo + "',						\n")
					.append("	" + newOrderRevNo + ",					\n")
					.append("	'" + rcvHead.get("order_type") + "',	\n")
					.append("	'" + rcvHead.get("order_date") + "',	\n")
					.append("	'" + rcvHead.get("delivery_date") + "',	\n")
					.append("	'" + rcvHead.get("bigo") + "',			\n")
					.append("	'" + rcvHead.get("cust_cd") + "',		\n")
					.append("	'" + rcvHead.get("cust_rev") + "'		\n")
					.append(");											\n")
					.toString();
    		 
			resultInt = super.excuteUpdate(con, sql);
    		if (resultInt < 0) {
				ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
				con.rollback();
				return EventDefine.E_DOEXCUTE_ERROR ;
			}
	    		
			for(int i = 0; i < rcvBody.size(); i++) {
				JSONObject eachRow = (JSONObject) rcvBody.get(i); // i번째 데이터묶음
				
				sql = new StringBuilder()
					.append("INSERT INTO tbi_order_detail2 (		\n")
					.append("	prod_cd,							\n")
					.append("	prod_rev_no,						\n")
					.append("	order_no,							\n")
					.append("	order_rev_no,						\n")
					.append("	order_count,						\n")
					.append("	note								\n")
					.append(")										\n")
					.append("VALUES (								\n")
					.append("	'" + eachRow.get("prod_cd") + "',	\n")
					.append("	'" + eachRow.get("prod_rev") + "',	\n")
					.append("	'" + orderNo + "',					\n")
					.append("	'" + newOrderRevNo + "',			\n")
					.append("	" + eachRow.get("order_count") + ",	\n")
					.append("	'" + eachRow.get("order_note") + "' \n")
					.append(");										\n")
					.toString();
				 
				resultInt = super.excuteUpdate(con, sql);
				if (resultInt < 0) {
					ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
					con.rollback();
					return EventDefine.E_DOEXCUTE_ERROR ;
				}
			}
		    	
			con.commit();
		} catch(Exception e) {
			LoggingWriter.setLogError("M101S020100E102()","==== SQL ERROR ===="+ e.getMessage());
			e.printStackTrace();
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M101S020100E102()","==== finally ===="+ e.getMessage());
				}
	    	}
	    }
		ioParam.setResultString(resultString);
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
    	ioParam.setMessage(MessageDefine.M_QUERY_OK);
	    return EventDefine.E_QUERY_RESULT;
	}
	
	// 주문정보 삭제 (yumsam)
	public int E103(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();

			JSONObject jArr = new JSONObject();
			jArr = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			
			String sql = new StringBuilder()
					.append("UPDATE tbi_order2								\n")
					.append("SET delyn = 'Y'								\n")
					.append("WHERE order_no = '" + jArr.get("orderNo") + "'	\n")
					.toString();
			
			resultInt = super.excuteUpdate(con, sql);
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M101S020100E103()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M101S020100E103()","==== finally ===="+ e.getMessage());
				}
	    	}
	    }
		ioParam.setResultString(resultString);
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
    	ioParam.setMessage(MessageDefine.M_QUERY_OK);
	    return EventDefine.E_QUERY_RESULT;
	}
	
	// 주문정보 조회 (yumsam)
	public int E104(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jo = new JSONObject();
			jo = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			
			String sql = new StringBuilder()
					.append("SELECT 											        \n")
					.append("	CB.code_name,									        \n")
					.append("	A.order_date,									        \n")
					.append("	A.order_no,										        \n")
					.append("	B.cust_nm,										        \n")
					.append("	A.delivery_date,								        \n")
					.append("	A.note,											        \n")
					.append("	A.delivery_yn,									        \n")
					.append("	A.order_rev_no,									        \n")
					.append("	A.cust_cd,										        \n")
					.append("	A.cust_rev_no,									        \n")
					.append("	B.company_type_m									    \n")
					.append("FROM tbi_order2 A									        \n")
					.append("INNER JOIN tbm_customer B							        \n")
					.append("	ON A.cust_cd = B.cust_cd						        \n")
					.append("	AND A.cust_rev_no = B.revision_no				        \n")
					.append("INNER JOIN tbm_code_book CB						        \n")
					.append("	ON A.order_type = CB.code_value			        		\n")
					.append("WHERE														\n")
					.append("	A.order_date BETWEEN '" + jo.get("fromdate") + "'		\n")
					.append("					 AND '" + jo.get("todate") + "'			\n")
					.append("	AND A.order_rev_no = (SELECT MAX(order_rev_no) 			\n")
					.append("					      FROM tbi_order2 C					\n")
					.append("						  WHERE A.order_no = C.order_no)	\n")
					.append("	AND A.delyn != 'Y'										\n")
					.append("	AND A.order_type LIKE '" + jo.get("orderType") + "%'	\n")
					.append("ORDER BY order_date DESC, delivery_yn ASC					\n")
					.toString();
			
			String ActionCommand = ioParam.getActionCommand();
			if(ActionCommand.startsWith("doQueryTableFieldName")) {
				resultString = super.excuteQueryStringTableFieldName(con, sql);
			} else {
				resultString = super.excuteQueryString(con, sql.toString());
			}
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M101S020100E104()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M101S020100E104()","==== finally ===="+ e.getMessage());
				}
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
					.append("SELECT 														\n")
					.append("	A.prod_cd,													\n")
					.append("	A.prod_rev_no,												\n")
					.append("	C.product_nm,												\n")
					.append("	C.gugyuk,													\n")
					.append("	A.order_count,												\n")
					.append("	A.note														\n")
					.append("FROM tbi_order_detail2 A										\n")
					.append("INNER JOIN tbi_order2 B										\n")
					.append("	ON A.order_no = B.order_no									\n")
					.append("	AND A.order_rev_no = B.order_rev_no							\n")
					.append("INNER JOIN tbm_product C										\n")
					.append("	ON A.prod_cd = C.prod_cd									\n")
					.append("	AND A.prod_rev_no = C.revision_no							\n")
					.append("WHERE A.order_no = '" + jArray.get("order_no") + "'			\n")
					.append("  AND A.order_rev_no = '" + jArray.get("order_rev_no") + "'	\n")
					.toString();
			
			String ActionCommand = ioParam.getActionCommand();
			if(ActionCommand.startsWith("doQueryTableFieldName")) {
				resultString = super.excuteQueryStringTableFieldName(con, sql.toString());
			} else {
				resultString = super.excuteQueryString(con, sql);
			}
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M101S020100E114()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M101S020100E114()","==== finally ===="+ e.getMessage());
				}
	    	}
	    }
		ioParam.setResultString(resultString);
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
    	ioParam.setMessage(MessageDefine.M_QUERY_OK);
	    return EventDefine.E_QUERY_RESULT;
	}
	
	// 제품별 주문 수량 합계 조회
	public int E124(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jo = new JSONObject();
			jo = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));

			String sql = new StringBuilder()
					.append("SELECT 													\n")
					.append("	C.product_nm,											\n")
					.append("	C.gugyuk,												\n")
					.append("	SUM(order_count)										\n")
					.append("FROM tbi_order_detail2 A									\n")
					.append("INNER JOIN tbi_order2 B									\n")
					.append("	ON A.order_no = B.order_no								\n")
					.append("	AND A.order_rev_no = B.order_rev_no						\n")
					.append("INNER JOIN tbm_product C									\n")
					.append("	ON A.prod_cd = C.prod_cd								\n")
					.append("	AND A.prod_rev_no = C.revision_no						\n")
					.append("WHERE 														\n")
					.append("	B.order_date BETWEEN '"+jo.get("startDate")+"' 			\n")
					.append("					 AND '"+jo.get("endDate")+"'			\n")
					.append("	AND B.order_type LIKE '" + jo.get("orderType") + "%'	\n")
					.append("	AND B.order_rev_no = (SELECT MAX(order_rev_no)			\n")
					.append("						  FROM tbi_order2 B2				\n")
					.append("						  WHERE B.order_no = B2.order_no)	\n")
					.append("	AND B.delyn != 'Y'										\n")
					.append("GROUP BY A.prod_cd;										\n")
					.toString();
			
			String ActionCommand = ioParam.getActionCommand();
			if(ActionCommand.startsWith("doQueryTableFieldName")) {
				resultString = super.excuteQueryStringTableFieldName(con, sql.toString());
			} else {
				resultString = super.excuteQueryString(con, sql);
			}
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M101S020100E114()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M101S020100E114()","==== finally ===="+ e.getMessage());
				}
	    	}
	    }
		ioParam.setResultString(resultString);
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
    	ioParam.setMessage(MessageDefine.M_QUERY_OK);
	    return EventDefine.E_QUERY_RESULT;
	}
	
	/*
	 * yumsam
	 * 
	 * */
	
	// 발주등록시 주문정보 조회 : OrderInforView.jsp
	public int E614(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
		
		JSONObject jObj = new JSONObject();
			jObj = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));

			
			String sql = new StringBuilder()
					.append("SELECT \n")
					.append("	A.order_no,			\n")
					.append("	A.order_rev_no,		\n")
					.append("	B.cust_nm,			\n")
					.append("	A.order_date,		\n")
					.append("	A.delivery_date,	\n")
					.append("	A.note,				\n")
					.append("   A.cust_cd,			\n")
					.append("   A.cust_rev_no 		\n")
					.append("FROM tbi_order2 A		\n")
					.append("INNER JOIN tbm_customer B			 \n")
					.append("	ON A.cust_cd = B.cust_cd		 \n")
					.append("	AND A.cust_rev_no = B.revision_no\n")
					.append("WHERE A.delivery_yn != 'Y'			 \n")
					.append("AND A.order_rev_no = (SELECT MAX(order_rev_no)       	\n")
					.append("       				FROM tbi_order2 D        		\n")
					.append("      					WHERE A.order_no = D.order_no 	\n")
					.append("      					AND A.order_date = D.order_date)\n")
					.append("AND A.delyn = 'N' 										\n")
					.append("AND B.company_type_m like '" + jObj.get("location_type") + "%' \n")
					.toString();

			String ActionCommand = ioParam.getActionCommand();
			if(ActionCommand.startsWith("doQueryTableFieldName")) {
				resultString = super.excuteQueryStringTableFieldName(con, sql);
			} else {
				resultString = super.excuteQueryString(con, sql);
			}
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M101S020100E614()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M101S020100E614()","==== finally ===="+ e.getMessage());
				}
	    	}
	    }
		ioParam.setResultString(resultString);
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
    	ioParam.setMessage(MessageDefine.M_QUERY_OK);

    	return EventDefine.E_QUERY_RESULT;
	}
	
	// 생산계획 주문량 조회 팝업페이지 : OrderCountView.jsp
	public int E714(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			
			String sql = new StringBuilder()
					.append("SELECT \n")
					.append("	A.order_no,			\n")
					.append("	A.order_date,		\n")
					.append("	B.cust_nm,			\n")
					.append("	A.delivery_date,	\n")
					.append("   D.product_nm, 		\n")
					.append("   C.order_count, 		\n")
					.append("	C.note				\n")
					.append("FROM tbi_order2 A		\n")
					.append("INNER JOIN tbm_customer B			 	\n")
					.append("	ON A.cust_cd = B.cust_cd		 	\n")
					.append("	AND A.cust_rev_no = B.revision_no	\n")
					.append("INNER JOIN tbi_order_detail2 C 	 	\n")
					.append("   ON A.order_no = C.order_no       	\n")
					.append("   AND A.order_rev_no = C.order_rev_no \n")
					.append("INNER JOIN tbm_product D 				\n")
					.append("   ON C.prod_cd = D.prod_cd 			\n")
					.append("   AND C.prod_rev_no = D.revision_no 	\n")
					.append("WHERE A.delivery_yn != 'Y'			 	\n")
					.append("AND A.order_rev_no = (SELECT MAX(order_rev_no)       	\n")
					.append("       				FROM tbi_order2 D        		\n")
					.append("      					WHERE A.order_no = D.order_no 	\n")
					.append("      					AND A.order_date = D.order_date)\n")
					.append("AND A.delyn = 'N' 										\n")
					.append("AND A.order_date = '"+ jArray.get("toDate") + "' 		\n")
					.append("ORDER BY A.order_date DESC 							\n")
					.toString();

			String ActionCommand = ioParam.getActionCommand();
			if(ActionCommand.startsWith("doQueryTableFieldName")) {
				resultString = super.excuteQueryStringTableFieldName(con, sql);
			} else {
				resultString = super.excuteQueryString(con, sql);
			}
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M101S020100E714()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M101S020100E714()","==== finally ===="+ e.getMessage());
				}
	    	}
	    }
		ioParam.setResultString(resultString);
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
    	ioParam.setMessage(MessageDefine.M_QUERY_OK);

    	return EventDefine.E_QUERY_RESULT;
	}
}