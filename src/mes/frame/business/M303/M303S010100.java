package mes.frame.business.M303;

import java.lang.reflect.Method;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.util.Vector;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;

import mes.frame.common.ApprovalActionNo;
import mes.client.conf.Config;
import mes.frame.common.EventDefine;
import mes.frame.common.HashObject;
import mes.frame.common.MessageDefine;
import mes.frame.database.JDBCConnectionPool;
import mes.frame.database.SqlAdapter;
import mes.frame.serviceinterface.InoutParameter;
import mes.frame.serviceinterface.LoggingWriter;
import mes.frame.util.CommonFunction;


public class M303S010100 extends SqlAdapter{
	Connection con = null;
	PreparedStatement pstmt = null;
	String resultString = "";
	int resultInt = -1;
	StringBuffer sql = new StringBuffer();
	
	String[][] v_paramArray = new String[0][0]; 
	Class[] optClass = null;
	Object[] optObj = null;
	Object obj = null;
	
	public M303S010100(){
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
			
			Method method = M303S010100.class.getMethod(event,optClass);
			LoggingWriter.setLogDebug(M303S010100.class.getName(),"==== " + event + " EventMethod Create Success ====");

			obj = method.invoke(M303S010100.class.newInstance(),optObj);
			doExcute_result = CommonFunction.getInt(obj.toString());
			
	    } catch (Exception ex) {
	    	doExcute_result = EventDefine.E_DOEXCUTE_INIT;
			ioParam.setMessage(MessageDefine.M_NO_EVENTID);
			LoggingWriter.setLogError(M303S010100.class.getName(),"==== EventID Not define : EVENT ID [ " + ioParam.getEventID() + "]");
	    } finally {
	    	obj = null;
			optClass = null;
			optObj = null;
	    }
	    long endTime = System.currentTimeMillis();
		long runningTime = endTime - startTime;
		LoggingWriter.setLogAll(M303S010100.class.getName(),"==== Query [수행시간  : " + runningTime + " ms]");
		
		return doExcute_result;
	}
	
	public int E104(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			
			String sql = new StringBuilder()
					.append("SELECT \n")
					.append("A.order_date,\n")
					.append("A.order_no,\n")
					.append("B.cust_nm,\n")
					.append("A.delivery_date,\n")
					.append("A.note,\n")
					.append("A.delivery_yn										\n")
					.append("FROM tbi_order2 A									\n")
					.append("INNER JOIN tbm_customer B							\n")
					.append("	ON A.cust_cd = B.cust_cd						\n")
					.append("	AND A.cust_rev_no = B.revision_no				\n")
					.append("WHERE A.order_date									\n")
					.append("		BETWEEN '" + jArray.get("fromdate") + "' 	\n")
					.append("			AND '" + jArray.get("todate") + "'		\n")
					.append("	AND A.delivery_yn = 'N'							\n")
					.toString();
			
			String ActionCommand = ioParam.getActionCommand();
			if(ActionCommand.startsWith("doQueryTableFieldName")) {
				resultString = super.excuteQueryStringTableFieldName(con, sql.toString());
			} else {
				resultString = super.excuteQueryString(con, sql.toString());
			}
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M303S010100E104()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M303S010100E104()","==== finally ===="+ e.getMessage());
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
					.append("	AND A.order_rev_no = '" + jArray.get("order_rev_no") + "'	\n")
					.toString();
			
			String ActionCommand = ioParam.getActionCommand();
			if(ActionCommand.startsWith("doQueryTableFieldName")) {
				resultString = super.excuteQueryStringTableFieldName(con, sql.toString());
			} else {
				resultString = super.excuteQueryString(con, sql.toString());
			}
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M303S010100E114()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M303S010100E114()","==== finally ===="+ e.getMessage());
				}
	    	}
	    }
		
		ioParam.setResultString(resultString);
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
    	ioParam.setMessage(MessageDefine.M_QUERY_OK);

    	return EventDefine.E_QUERY_RESULT;
	}
	
	// 거래명세표 조회 head (원우)
	public int E144(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jo = new JSONObject();
			jo = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			
			String sql = new StringBuilder()
					.append("SELECT 											        \n")
					.append("	B.cust_nm,										        \n")
					.append("	A.cust_cd,										        \n")
					.append("	B.boss_name,									        \n")
					.append("	B.address,									       	 	\n")
					.append("	B.uptae,									        	\n")
					.append("	B.jongmok									        	\n")
					.append("FROM tbi_order2 A									        \n")
					.append("INNER JOIN tbm_customer B							        \n")
					.append("	ON A.cust_cd = B.cust_cd						        \n")
					.append("	AND A.cust_rev_no = B.revision_no				        \n")
					.append("WHERE														\n")
					.append("	A.order_date = '" + jo.get("order_date") + "'			\n")
					.append("	AND A.order_no = '" + jo.get("order_no") + "' 			\n")
					.append("	AND A.order_rev_no = '" + jo.get("order_rev_no") + "' 	\n")
					.append("	AND A.delyn != 'Y'										\n")
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
			LoggingWriter.setLogError("M303S010100E144()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M303S010100E144()","==== finally ===="+ e.getMessage());
				}
	    	}
	    }
		ioParam.setResultString(resultString);
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
    	ioParam.setMessage(MessageDefine.M_QUERY_OK);
	    return EventDefine.E_QUERY_RESULT;
	}
		
	//거래명세표 조회 body(원우)
	public int E154(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));

			String sql = new StringBuilder()
					.append("SELECT 														\n")
					.append("	C.product_nm,												\n")
					.append("	C.gugyuk,													\n")
					.append("	A.order_count,												\n")
					.append("   C.unit_price AS unit_price,												\n")
					.append("   (C.unit_price*0.9) AS supply_price, 						\n")
					.append("   (C.unit_price*0.1) AS tax 									\n")
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
			LoggingWriter.setLogError("M303S010100E154()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M303S010100E154()","==== finally ===="+ e.getMessage());
				}
	    	}
	    }
		ioParam.setResultString(resultString);
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
    	ioParam.setMessage(MessageDefine.M_QUERY_OK);
	    return EventDefine.E_QUERY_RESULT;
	}
		
	//거래명세표 배송기사 정보 조회(원우)
	public int E164(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));

			String sql = new StringBuilder()
					.append("SELECT 														\n")
					.append("	A.user_nm,													\n")
					.append("	A.hpno,														\n")
					.append("   C.code_name													\n")
					.append("FROM tbm_users A												\n")
					.append("INNER JOIN tbm_vehicle_users B									\n")
					.append("	ON A.user_id = B.user_id									\n")
					.append("	AND A.revision_no = B.user_rev_no							\n")
					.append("LEFT JOIN tbm_code_book C										\n")
					.append("ON B.cust_gubun = C.code_value									\n")
					.append("WHERE B.cust_gubun = '" + jArray.get("location_type") + "'		\n")
					.toString();
			
			String ActionCommand = ioParam.getActionCommand();
			if(ActionCommand.startsWith("doQueryTableFieldName")) {
				resultString = super.excuteQueryStringTableFieldName(con, sql.toString());
			} else {
				resultString = super.excuteQueryString(con, sql);
			}
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M303S010100E164()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M303S010100E164()","==== finally ===="+ e.getMessage());
				}
	    	}
	    }
		ioParam.setResultString(resultString);
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
    	ioParam.setMessage(MessageDefine.M_QUERY_OK);
	    return EventDefine.E_QUERY_RESULT;
	}
	
}