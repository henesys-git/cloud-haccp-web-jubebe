package mes.frame.business.M707;

import java.lang.reflect.Method;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Vector;

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
import mes.frame.util.*;
import mes.frame.util.StringUtil;

public class M707S020200 extends SqlAdapter{
	Connection con = null;
	PreparedStatement pstmt = null;
	String resultString = "";
	int resultInt = -1;
	StringBuffer sql = new StringBuffer();
	
	String[][] v_paramArray = new String[0][0]; 
	Class[] optClass = null;
	Object[] optObj = null;
	Object obj = null;
	
	public M707S020200(){
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
			
			Method method = M707S020200.class.getMethod(event,optClass);
			LoggingWriter.setLogDebug(M707S020200.class.getName(),"==== " + event + " EventMethod Create Success ====");

			obj = method.invoke(M707S020200.class.newInstance(),optObj);
			doExcute_result = CommonFunction.getInt(obj.toString());
			
	    } catch (Exception ex) {
	    	doExcute_result = EventDefine.E_DOEXCUTE_INIT;
			ioParam.setMessage(MessageDefine.M_NO_EVENTID);
			LoggingWriter.setLogError(M707S020200.class.getName(),"==== EventID Not define : EVENT ID [ " + ioParam.getEventID() + "]");
	    } finally {
	    	obj = null;
			optClass = null;
			optObj = null;
	    }
	    long endTime = System.currentTimeMillis();
		long runningTime = endTime - startTime;
		LoggingWriter.setLogAll(M707S020200.class.getName(),"==== Query [수행시간  : " + runningTime + " ms]");
		
		return doExcute_result;
	}
	
	// 월별 반품 현황 조회
	public int E104(InoutParameter ioParam) {
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();			
			
			JSONObject jObj = new JSONObject();
			jObj = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));

			String sql = new StringBuilder()
					.append("SELECT \n")
					.append("	A.discard_type,\n")
					.append("	A.discard_seq_no,\n")
					.append("	A.discard_date,\n")
					.append("	C.product_nm,\n")
					.append("	B.chulha_count,\n")
					.append("	A.amount,\n")
					.append("	A.note,\n")
					.append("	A.chulha_no,\n")
					.append("	A.chulha_rev_no,\n")
					.append("	A.prod_date,\n")
					.append("	A.seq_no,\n")
					.append("	A.prod_cd,\n")
					.append("	A.prod_rev_no\n")
					.append("FROM tbi_prod_discard A\n")
					.append("INNER JOIN tbi_chulha_detail B\n")
					.append("	ON A.chulha_no = B.chulha_no\n")
					.append("	AND A.chulha_rev_no = B.chulha_rev_no\n")
					.append("	AND A.prod_date = B.prod_date\n")
					.append("	AND A.seq_no = B.seq_no\n")
					.append("	AND A.prod_cd = B.prod_cd\n")
					.append("	AND A.prod_rev_no = B.prod_rev_no\n")
					.append("INNER JOIN tbm_product C\n")
					.append("	ON A.prod_cd = C.prod_cd\n")
					.append("	AND A.prod_rev_no = C.revision_no\n")
					.append("WHERE DATE_FORMAT(A.prod_date, '%Y-%m') = '"+jObj.get("yearMonth")+"'\n")
					.toString();
			
			resultString = super.excuteQueryString(con, sql);
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M707S020200E104()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
		} finally {
			if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M707S020200E104()","==== finally ===="+ e.getMessage());
				}
			} else {
			}
		}
		ioParam.setResultString(resultString);
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
		ioParam.setMessage(MessageDefine.M_QUERY_OK);

		return EventDefine.E_QUERY_RESULT;
	}
	
	// 월별 반품 건수 조회 (선택된 월 기점으로 지난 1년 동안의 데이터)
	public int E114(InoutParameter ioParam) {
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();			
			
			JSONObject jObj = new JSONObject();
			jObj = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));

			String sql = new StringBuilder()
					.append("SELECT \n")
					.append("	A.discard_type,\n")
					.append("	A.discard_seq_no,\n")
					.append("	A.discard_date,\n")
					.append("	C.product_nm,\n")
					.append("	B.chulha_count,\n")
					.append("	A.amount,\n")
					.append("	A.note,\n")
					.append("	A.chulha_no,\n")
					.append("	A.chulha_rev_no,\n")
					.append("	A.prod_date,\n")
					.append("	A.seq_no,\n")
					.append("	A.prod_cd,\n")
					.append("	A.prod_rev_no\n")
					.append("FROM tbi_prod_discard A\n")
					.append("INNER JOIN tbi_chulha_detail B\n")
					.append("	ON A.chulha_no = B.chulha_no\n")
					.append("	AND A.chulha_rev_no = B.chulha_rev_no\n")
					.append("	AND A.prod_date = B.prod_date\n")
					.append("	AND A.seq_no = B.seq_no\n")
					.append("	AND A.prod_cd = B.prod_cd\n")
					.append("	AND A.prod_rev_no = B.prod_rev_no\n")
					.append("INNER JOIN tbm_product C\n")
					.append("	ON A.prod_cd = C.prod_cd\n")
					.append("	AND A.prod_rev_no = C.revision_no\n")
					.append("WHERE YEAR(A.prod_date) || '-' || MONTH(A.prod_date) = '"+jObj.get("month")+"'\n")
					.toString();
			
			resultString = super.excuteQueryString(con, sql);
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M707S020200E104()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
		} finally {
			if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M707S020200E104()","==== finally ===="+ e.getMessage());
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
