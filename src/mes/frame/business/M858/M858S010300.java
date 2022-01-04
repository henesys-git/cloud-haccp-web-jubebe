package mes.frame.business.M858;

import java.lang.reflect.Method;
import java.sql.Connection;
import java.sql.PreparedStatement;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;

import mes.client.conf.Config;
import mes.client.util.ChulhaNumberGenerator;
import mes.frame.common.EventDefine;
import mes.frame.common.HashObject;
import mes.frame.common.MessageDefine;
import mes.frame.database.JDBCConnectionPool;
import mes.frame.database.SqlAdapter;
import mes.frame.serviceinterface.InoutParameter;
import mes.frame.serviceinterface.LoggingWriter;
import mes.frame.util.CommonFunction;


public class M858S010300 extends SqlAdapter{
	Connection con = null;
	PreparedStatement pstmt = null;
	String resultString = "";
	int resultInt = -1;
	StringBuffer sql = new StringBuffer();
	
	String[][] v_paramArray = new String[0][0]; 
	Class[] optClass = null;
	Object[] optObj = null;
	Object obj = null;
	
	public M858S010300(){
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
			
			Method method = M858S010300.class.getMethod(event,optClass);
			LoggingWriter.setLogDebug(M858S010300.class.getName(),"==== " + event + " EventMethod Create Success ====");

			obj = method.invoke(M858S010300.class.newInstance(),optObj);
			doExcute_result = CommonFunction.getInt(obj.toString());
			
	    } catch (Exception ex) {
	    	doExcute_result = EventDefine.E_DOEXCUTE_INIT;
			ioParam.setMessage(MessageDefine.M_NO_EVENTID);
			LoggingWriter.setLogError(M858S010300.class.getName(),"==== EventID Not define : EVENT ID [ " + ioParam.getEventID() + "]");
	    } finally {
	    	obj = null;
			optClass = null;
			optObj = null;
	    }
	    long endTime = System.currentTimeMillis();
		long runningTime = endTime - startTime;
		LoggingWriter.setLogAll(M858S010300.class.getName(),"==== Query [수행시간  : " + runningTime + " ms]");
		
		return doExcute_result;
	}
	/*
	// 연도별 제품 총 생산/출하량 조회
	public int E104(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArr = new JSONObject();
			jArr = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			
			String sql = new StringBuilder()
					.append("WITH														\n")
					.append("   month_ipgo AS(											\n")
					.append("	SELECT DATE_FORMAT(ipgo_date, '%Y-%m') AS io_month_ipgo,\n")
					.append("	prod_cd,												\n")
					.append("	SUM(ipgo_amount) AS io_amt_ipgo							\n")
					.append("FROM tbi_prod_ipgo2										\n")
					.append("WHERE DATE_FORMAT(ipgo_date, '%Y') = '"+jArr.get("year")+"' \n")
					.append("	GROUP BY prod_cd, io_month_ipgo							\n")
					.append("),															\n")
					.append("	month_chulgo AS(										\n")
					.append("	SELECT	DATE_FORMAT(chulgo_date, '%Y-%m') AS io_month_chulgo, \n")
					.append("	prod_cd,												\n")
					.append("	SUM(chulgo_amount) AS io_amt_chulgo						\n")
					.append("FROM tbi_prod_chulgo2 										\n")
					.append("WHERE DATE_FORMAT(chulgo_date, '%Y') = '"+jArr.get("year")+"' \n")
					.append("	GROUP BY prod_cd, io_month_chulgo						\n")
					.append(") 															\n")
					.append("	SELECT DISTINCT											\n")
					.append("	A.io_month_ipgo,										\n")
					.append("   C.prod_cd, 												\n")
					.append("   C.product_nm, 											\n")
					.append("   A.io_amt_ipgo, 											\n")
					.append("   B.io_amt_chulgo 										\n")
					.append("   FROM month_ipgo A										\n")
					.append("   LEFT JOIN month_chulgo B 								\n")
					.append("   ON A.prod_cd = B.prod_cd 								\n")
					.append("   INNER JOIN tbm_product C 								\n")
					.append("   ON A.prod_cd = C.prod_cd 								\n")
					.append("   WHERE C.prod_cd like '"+jArr.get("prod_cd")+"%'			\n")
					.append("   GROUP BY A.prod_cd, io_month_ipgo						\n")
					.append("   ORDER BY io_month_ipgo DESC, C.prod_cd					\n")
					.toString();

			String ActionCommand = ioParam.getActionCommand();
			if(ActionCommand.startsWith("doQueryTableFieldName")) {
				resultString = super.excuteQueryStringTableFieldName(con, sql);
			} else {
				resultString = super.excuteQueryString(con, sql);
			}
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M858S010300E104()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M858S010300E104()","==== finally ===="+ e.getMessage());
				}
	    	}
	    }
		ioParam.setResultString(resultString);
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
    	ioParam.setMessage(MessageDefine.M_QUERY_OK);
	    return EventDefine.E_QUERY_RESULT;
	}
	*/
	
	
	//완제품 출하현황 메인
	public int E104(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArr = new JSONObject();
			jArr = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			
			String sql = new StringBuilder()
					.append("SELECT	DISTINCT																  \n")
					.append("(SELECT '출하량') AS gubun,														  \n")
					.append("(SELECT IFNULL(SUM(chulgo_amount),0) FROM tbi_prod_chulgo2 WHERE DATE_FORMAT(chulgo_date, '%Y-%m') = '"+jArr.get("year")+"'+'-'+'01' \n")
					.append("  AND prod_cd LIKE '"+jArr.get("prod_cd")+"%') AS io_amt_chulgo_1,								  \n")
					.append("(SELECT IFNULL(SUM(chulgo_amount),0) FROM tbi_prod_chulgo2 WHERE DATE_FORMAT(chulgo_date, '%Y-%m') = '"+jArr.get("year")+"'+'-'+'02' \n")
					.append("  AND prod_cd LIKE '"+jArr.get("prod_cd")+"%') AS io_amt_chulgo_2,								  \n")
					.append("(SELECT IFNULL(SUM(chulgo_amount),0) FROM tbi_prod_chulgo2 WHERE DATE_FORMAT(chulgo_date, '%Y-%m') = '"+jArr.get("year")+"'+'-'+'03' \n")
					.append("  AND prod_cd LIKE '"+jArr.get("prod_cd")+"%') AS io_amt_chulgo_3,								  \n")
					.append("(SELECT IFNULL(SUM(chulgo_amount),0) FROM tbi_prod_chulgo2 WHERE DATE_FORMAT(chulgo_date, '%Y-%m') = '"+jArr.get("year")+"'+'-'+'04' \n")
					.append("  AND prod_cd LIKE '"+jArr.get("prod_cd")+"%') AS io_amt_chulgo_4,								  \n")
					.append("(SELECT IFNULL(SUM(chulgo_amount),0) FROM tbi_prod_chulgo2 WHERE DATE_FORMAT(chulgo_date, '%Y-%m') = '"+jArr.get("year")+"'+'-'+'05' \n")
					.append("  AND prod_cd LIKE '"+jArr.get("prod_cd")+"%') AS io_amt_chulgo_5,								  \n")
					.append("(SELECT IFNULL(SUM(chulgo_amount),0) FROM tbi_prod_chulgo2 WHERE DATE_FORMAT(chulgo_date, '%Y-%m') = '"+jArr.get("year")+"'+'-'+'06' \n")
					.append("  AND prod_cd LIKE '"+jArr.get("prod_cd")+"%') AS io_amt_chulgo_6,								  \n")
					.append("(SELECT IFNULL(SUM(chulgo_amount),0) FROM tbi_prod_chulgo2 WHERE DATE_FORMAT(chulgo_date, '%Y-%m') = '"+jArr.get("year")+"'+'-'+'07' \n")
					.append("  AND prod_cd LIKE '"+jArr.get("prod_cd")+"%') AS io_amt_chulgo_7,								  \n")
					.append("(SELECT IFNULL(SUM(chulgo_amount),0) FROM tbi_prod_chulgo2 WHERE DATE_FORMAT(chulgo_date, '%Y-%m') = '"+jArr.get("year")+"'+'-'+'08' \n")
					.append("  AND prod_cd LIKE '"+jArr.get("prod_cd")+"%') AS io_amt_chulgo_8,								  \n")
					.append("(SELECT IFNULL(SUM(chulgo_amount),0) FROM tbi_prod_chulgo2 WHERE DATE_FORMAT(chulgo_date, '%Y-%m') = '"+jArr.get("year")+"'+'-'+'09' \n")
					.append("  AND prod_cd LIKE '"+jArr.get("prod_cd")+"%') AS io_amt_chulgo_9,								  \n")
					.append("(SELECT IFNULL(SUM(chulgo_amount),0) FROM tbi_prod_chulgo2 WHERE DATE_FORMAT(chulgo_date, '%Y-%m') = '"+jArr.get("year")+"'+'-'+'10' \n")
					.append("  AND prod_cd LIKE '"+jArr.get("prod_cd")+"%') AS io_amt_chulgo_10,								  \n")
					.append("(SELECT IFNULL(SUM(chulgo_amount),0) FROM tbi_prod_chulgo2 WHERE DATE_FORMAT(chulgo_date, '%Y-%m') = '"+jArr.get("year")+"'+'-'+'11' \n")
					.append("  AND prod_cd LIKE '"+jArr.get("prod_cd")+"%') AS io_amt_chulgo_11,								  \n")
					.append("(SELECT IFNULL(SUM(chulgo_amount),0) FROM tbi_prod_chulgo2 WHERE DATE_FORMAT(chulgo_date, '%Y-%m') = '"+jArr.get("year")+"'+'-'+'12' \n")
					.append("  AND prod_cd LIKE '"+jArr.get("prod_cd")+"%') AS io_amt_chulgo_12,								  \n")
					.append("(SELECT IFNULL(SUM(chulgo_amount),0) FROM tbi_prod_chulgo2 WHERE DATE_FORMAT(chulgo_date, '%Y') = '"+jArr.get("year")+"' \n")
					.append(" AND prod_cd LIKE '"+jArr.get("prod_cd")+"%') AS io_amt_chulgo_total							  \n")
					.append("UNION ALL 																		  \n")
					.append("SELECT	DISTINCT																  \n")
					.append("(SELECT '입고량') AS gubun,														  \n")
					.append("(SELECT IFNULL(SUM(ipgo_amount),0) FROM tbi_prod_ipgo2 WHERE DATE_FORMAT(ipgo_date, '%Y-%m') = '"+jArr.get("year")+"'+'-'+'01' \n")
					.append("  AND prod_cd LIKE '"+jArr.get("prod_cd")+"%') AS io_amt_ipgo_1,								  \n")
					.append("(SELECT IFNULL(SUM(ipgo_amount),0) FROM tbi_prod_ipgo2 WHERE DATE_FORMAT(ipgo_date, '%Y-%m') = '"+jArr.get("year")+"'+'-'+'02' \n")
					.append("  AND prod_cd LIKE '"+jArr.get("prod_cd")+"%') AS io_amt_ipgo_2,								  \n")
					.append("(SELECT IFNULL(SUM(ipgo_amount),0) FROM tbi_prod_ipgo2 WHERE DATE_FORMAT(ipgo_date, '%Y-%m') = '"+jArr.get("year")+"'+'-'+'03' \n")
					.append("  AND prod_cd LIKE '"+jArr.get("prod_cd")+"%') AS io_amt_ipgo_3,								  \n")
					.append("(SELECT IFNULL(SUM(ipgo_amount),0) FROM tbi_prod_ipgo2 WHERE DATE_FORMAT(ipgo_date, '%Y-%m') = '"+jArr.get("year")+"'+'-'+'04' \n")
					.append("  AND prod_cd LIKE '"+jArr.get("prod_cd")+"%') AS io_amt_ipgo_4,								  \n")
					.append("(SELECT IFNULL(SUM(ipgo_amount),0) FROM tbi_prod_ipgo2 WHERE DATE_FORMAT(ipgo_date, '%Y-%m') = '"+jArr.get("year")+"'+'-'+'05' \n")
					.append("  AND prod_cd LIKE '"+jArr.get("prod_cd")+"%') AS io_amt_ipgo_5,								  \n")
					.append("(SELECT IFNULL(SUM(ipgo_amount),0) FROM tbi_prod_ipgo2 WHERE DATE_FORMAT(ipgo_date, '%Y-%m') = '"+jArr.get("year")+"'+'-'+'06' \n")
					.append("  AND prod_cd LIKE '"+jArr.get("prod_cd")+"%') AS io_amt_ipgo_6,								  \n")
					.append("(SELECT IFNULL(SUM(ipgo_amount),0) FROM tbi_prod_ipgo2 WHERE DATE_FORMAT(ipgo_date, '%Y-%m') = '"+jArr.get("year")+"'+'-'+'07' \n")
					.append("  AND prod_cd LIKE '"+jArr.get("prod_cd")+"%') AS io_amt_ipgo_7,								  \n")
					.append("(SELECT IFNULL(SUM(ipgo_amount),0) FROM tbi_prod_ipgo2 WHERE DATE_FORMAT(ipgo_date, '%Y-%m') = '"+jArr.get("year")+"'+'-'+'08' \n")
					.append("  AND prod_cd LIKE '"+jArr.get("prod_cd")+"%') AS io_amt_ipgo_8,								  \n")
					.append("(SELECT IFNULL(SUM(ipgo_amount),0) FROM tbi_prod_ipgo2 WHERE DATE_FORMAT(ipgo_date, '%Y-%m') = '"+jArr.get("year")+"'+'-'+'09' \n")
					.append("  AND prod_cd LIKE '"+jArr.get("prod_cd")+"%') AS io_amt_ipgo_9,								  \n")
					.append("(SELECT IFNULL(SUM(ipgo_amount),0) FROM tbi_prod_ipgo2 WHERE DATE_FORMAT(ipgo_date, '%Y-%m') = '"+jArr.get("year")+"'+'-'+'10' \n")
					.append("  AND prod_cd LIKE '"+jArr.get("prod_cd")+"%') AS io_amt_ipgo_10,								  \n")
					.append("(SELECT IFNULL(SUM(ipgo_amount),0) FROM tbi_prod_ipgo2 WHERE DATE_FORMAT(ipgo_date, '%Y-%m') = '"+jArr.get("year")+"'+'-'+'11' \n")
					.append("  AND prod_cd LIKE '"+jArr.get("prod_cd")+"%') AS io_amt_ipgo_11,								  \n")
					.append("(SELECT IFNULL(SUM(ipgo_amount),0) FROM tbi_prod_ipgo2 WHERE DATE_FORMAT(ipgo_date, '%Y-%m') = '"+jArr.get("year")+"'+'-'+'12' \n")
					.append("  AND prod_cd LIKE '"+jArr.get("prod_cd")+"%') AS io_amt_ipgo_12,								  \n")
					.append("(SELECT IFNULL(SUM(ipgo_amount),0) FROM tbi_prod_ipgo2 WHERE DATE_FORMAT(ipgo_date, '%Y') = '"+jArr.get("year")+"' \n")
					.append(" AND prod_cd LIKE '"+jArr.get("prod_cd")+"%') AS io_amt_ipgo_total							  \n")
					.toString();

			String ActionCommand = ioParam.getActionCommand();
			if(ActionCommand.startsWith("doQueryTableFieldName")) {
				resultString = super.excuteQueryStringTableFieldName(con, sql);
			} else {
				resultString = super.excuteQueryString(con, sql);
			}
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M858S010300E104()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M858S010300E104()","==== finally ===="+ e.getMessage());
				}
	    	}
	    }
		ioParam.setResultString(resultString);
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
    	ioParam.setMessage(MessageDefine.M_QUERY_OK);
	    return EventDefine.E_QUERY_RESULT;
	}
	
	
	
	// 월별 제품 총 생산/출하량 조회
		public int E114(InoutParameter ioParam){
			resultInt = EventDefine.E_DOEXCUTE_INIT;
			
			try {
				con = JDBCConnectionPool.getConnection();
				
				JSONObject jArr = new JSONObject();
				jArr = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
				
				String sql = new StringBuilder()
						.append("SELECT -- 해당 품목의 생산량 계산									\n")
						.append("	A.ipgo_date AS io_date,									\n")
						.append("	A.prod_cd,												\n")
						.append("	B.product_nm,											\n")
						.append("	'입고 : ' || SUM(A.ipgo_amount) AS io_amt					\n")
						.append("FROM tbi_prod_ipgo2 A										\n")
						.append("INNER JOIN tbm_product B									\n")
						.append("	ON A.prod_cd = B.prod_cd								\n")
						.append("WHERE A.ipgo_date BETWEEN 									\n")
						.append("	'"+jArr.get("start")+"' AND '"+jArr.get("end")+"'		\n")
						.append("	AND A.prod_cd = '"+jArr.get("prodCd")+"'				\n")
						.append("GROUP BY A.prod_cd, A.ipgo_date							\n")
		
						.append("UNION ALL													\n")
						
						.append("SELECT	-- 해당 품목의 출하량 계산									\n")
						.append("	A.chulgo_date AS io_date,								\n")
						.append("	A.prod_cd,												\n")
						.append("	B.product_nm,											\n")
						.append("	'출하 : ' || SUM(A.chulgo_amount) AS io_amt				\n")
						.append("FROM tbi_prod_chulgo2 A									\n")
						.append("INNER JOIN tbm_product B									\n")
						.append("	ON A.prod_cd = B.prod_cd								\n")
						.append("WHERE A.chulgo_date BETWEEN 								\n")
						.append("	'"+jArr.get("start")+"' AND '"+jArr.get("end")+"'		\n")
						.append("	AND A.prod_cd = '"+jArr.get("prodCd")+"'				\n")
						.append("GROUP BY A.prod_cd, A.chulgo_date							\n")
						.toString();

				String ActionCommand = ioParam.getActionCommand();
				if(ActionCommand.startsWith("doQueryTableFieldName")) {
					resultString = super.excuteQueryStringTableFieldName(con, sql);
				} else {
					resultString = super.excuteQueryString(con, sql);
				}
			} catch(Exception e) {
				e.printStackTrace();
				LoggingWriter.setLogError("M858S010300E104()","==== SQL ERROR ===="+ e.getMessage());
				return EventDefine.E_DOEXCUTE_ERROR ;
		    } finally {
		    	if (Config.useDataSource) {
					try {
						if (con != null) con.close();
					} catch (Exception e) {
						LoggingWriter.setLogError("M858S010300E104()","==== finally ===="+ e.getMessage());
					}
		    	}
		    }
			ioParam.setResultString(resultString);
			ioParam.setColumnCount("" + super.COLUMN_COUNT);
	    	ioParam.setMessage(MessageDefine.M_QUERY_OK);
		    return EventDefine.E_QUERY_RESULT;
		}
	
	
	
	/* 
	 * 완제품명, 코드 조회 
	 * for select tag
	 * */
	public int E204(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			String sql = new StringBuilder()
					.append("SELECT 											\n")
					.append("prod_cd, 											\n")
					.append("product_nm 										\n")
					.append("FROM tbm_product A									\n")
					.append("WHERE delyn != 'Y'									\n")
					.append("    AND revision_no = (SELECT MAX(revision_no) 	\n")
					.append("    					FROM tbm_product B 			\n")
					.append("    					WHERE A.prod_cd = B.prod_cd)\n")
					.toString();

			String ActionCommand = ioParam.getActionCommand();
			if(ActionCommand.startsWith("doQueryTableFieldName")) {
				resultString = super.excuteQueryStringTableFieldName(con, sql);
			} else {
				resultString = super.excuteQueryString(con, sql);
			}
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M858S010300E204()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M858S010300E204()","==== finally ===="+ e.getMessage());
				}
	    	}
	    }
		
		ioParam.setResultString(resultString);
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
    	ioParam.setMessage(MessageDefine.M_QUERY_OK);
	    
    	return EventDefine.E_QUERY_RESULT;
	}
}