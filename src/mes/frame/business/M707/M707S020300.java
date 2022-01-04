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

public class M707S020300 extends SqlAdapter{
	Connection con = null;
	PreparedStatement pstmt = null;
	String resultString = "";
	int resultInt = -1;
	StringBuffer sql = new StringBuffer();
	
	String[][] v_paramArray = new String[0][0]; 
	Class[] optClass = null;
	Object[] optObj = null;
	Object obj = null;
	
	public M707S020300(){
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
			
			Method method = M707S020300.class.getMethod(event,optClass);
			LoggingWriter.setLogDebug(M707S020300.class.getName(),"==== " + event + " EventMethod Create Success ====");

			obj = method.invoke(M707S020300.class.newInstance(),optObj);
			doExcute_result = CommonFunction.getInt(obj.toString());
			
	    } catch (Exception ex) {
	    	doExcute_result = EventDefine.E_DOEXCUTE_INIT;
			ioParam.setMessage(MessageDefine.M_NO_EVENTID);
			LoggingWriter.setLogError(M707S020300.class.getName(),"==== EventID Not define : EVENT ID [ " + ioParam.getEventID() + "]");
	    } finally {
	    	obj = null;
			optClass = null;
			optObj = null;
	    }
	    long endTime = System.currentTimeMillis();
		long runningTime = endTime - startTime;
		LoggingWriter.setLogAll(M707S020300.class.getName(),"==== Query [수행시간  : " + runningTime + " ms]");
		
		return doExcute_result;
	}

//	월별재고비용현황 
	public int E304(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();			
			
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			System.out.println("JSONObject jArray rcvData="+ jArray.toString());
			
			String sql = new StringBuilder()
					.append("WITH work_date AS (\n")
					.append("SELECT DISTINCT\n")
					.append("        A.order_no,\n")
					.append("        A.lotno,\n")
					.append("        A.job_order_no,\n")
					.append("        A.prod_cd,\n")
					.append("        A.prod_cd_rev,\n")
					.append("        A.work_hour,\n")
					.append("        A.total_pay AS sum_total,\n")
					.append("        TO_CHAR(B.finish_dt,'YYYYMMDD') AS end_date,\n")
					.append("        A.member_key\n")
					.append("FROM\n")
					.append("        tbi_order_worker A\n")
					.append("INNER JOIN\n")
					.append("        tbi_production_exec B\n")
					.append("ON A.member_key = B.member_key\n")
					.append("AND A.order_no = B.order_no\n")
					.append("AND A.lotno = B.lotno\n")
					.append("AND A.prod_cd = B.prod_cd\n")
					.append("AND A.prod_cd_rev = B.prod_cd_rev\n")
					.append("),\n")
					.append("work_total AS (\n")
					.append("SELECT DISTINCT\n")
					.append("        end_date,\n")
					.append("        order_no,\n")
					.append("        lotno,\n")
					.append("        prod_cd,\n")
					.append("        prod_cd_rev,\n")
					.append("        SUM(sum_total) AS work_price_total,\n")
					.append("        member_key\n")
					.append("FROM work_date\n")
					.append("GROUP BY end_date\n")
					.append("),\n")
					.append("bom AS (\n")
					.append("SELECT DISTINCT\n")
					.append("		TO_CHAR(C.finish_dt,'YYYYMMDD') AS end_date,\n")
					.append("        B.order_no,\n")
					.append("        B.lotno,\n")
					.append("        B.bom_cd,\n")
					.append("        B.bom_cd_rev,\n")
					.append("        B.bom_name,\n")
					.append("        B.part_cd,\n")
					.append("        B.part_cd_rev,\n")
					.append("        A.part_nm,\n")
					.append("        NVL(A.unit_count,0) AS unit_count,\n")
					.append("        B.part_cnt,\n")
					.append("        A.unit_price,\n")
					.append("        ROUND(NVL(B.part_cnt,0) * NVL(A.unit_price,0)) AS price,\n")
					.append("        A.member_key\n")
					.append("FROM tbm_part_list A\n")
					.append("INNER JOIN tbi_order_bomlist B\n")
					.append("ON A.member_key = B.member_key\n")
					.append("AND A.part_cd = B.part_cd\n")
					.append("INNER JOIN tbi_production_exec C\n")
					.append("ON B.member_key = C.member_key\n")
					.append("AND B.order_no = C.order_no\n")
					.append("),\n")
					.append("bom_total AS (\n")
					.append("SELECT DISTINCT\n")
					.append("		end_date,\n")
					.append("        SUM(unit_count),\n")
					.append("        SUM(part_cnt),\n")
					.append("        SUM(price) AS bom_price_total,\n")
					.append("        member_key\n")
					.append("FROM bom \n")
					.append("GROUP BY end_date\n")
					.append(")\n")
					.append("SELECT DISTINCT\n")
					.append("        A.end_date,\n")
					.append("        FORMAT(SUM(work_price_total),0),\n")
					.append("        FORMAT(SUM(bom_price_total), 0),\n")
					.append("        SUM(work_price_total) + SUM(bom_price_total)\n")
					.append("FROM  work_total A\n")
					.append("INNER JOIN bom_total B\n")
					.append("ON A.member_key = B.member_key\n")
					.append("AND A.end_date = B.end_date\n")
					.append("WHERE  A.end_date BETWEEN '" + jArray.get("fromdate") + "' AND '" + jArray.get("todate") + "'\n")
					.append("AND A.member_key ='" + jArray.get("member_key") + "' \n")
					.append("GROUP BY A.end_date\n")
					.toString();
			
			
			String ActionCommand = ioParam.getActionCommand();
			if(ActionCommand.startsWith("doQueryTableFieldName")) {
				resultString = super.excuteQueryStringTableFieldName(con, sql.toString());
			}
			else {;
				resultString = super.excuteQueryString(con, sql.toString());
			}
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M707S020100E304()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M707S020100E304()","==== finally ===="+ e.getMessage());
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
	
	public int E314(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();			
			
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			System.out.println("JSONObject jArray rcvData="+ jArray.toString());
			String sql = new StringBuilder()
					.append("WITH bom_part_nm AS (\n")
					.append("SELECT DISTINCT\n")
					.append("	B.order_no,\n")
					.append("	B.lotno,\n")
					.append("	B.bom_cd,\n")
					.append("	B.bom_cd_rev,\n")
					.append("	B.bom_name,\n")
					.append("	B.part_cd,\n")
					.append("	B.part_cd_rev,\n")
					.append("	A.part_nm,\n")
					.append("	A.unit_price,\n")
					.append("	B.part_cnt,\n")
					.append("	ROUND(NVL(B.part_cnt,0) * NVL(A.unit_price,0)) AS price,\n")
					.append("	A.member_key\n")
					.append("FROM tbm_part_list A\n")
					.append("INNER JOIN tbi_order_bomlist B\n")
					.append("ON A.member_key	= B.member_key\n")
					.append("AND A.part_cd = B.part_cd \n")
					.append("),\n")
					.append("bom_part_list AS (\n")
					.append("SELECT DISTINCT\n")
					.append("	order_no,\n")
					.append("	lotno,\n")
					.append("	bom_cd,\n")
					.append("	bom_cd_rev,\n")
					.append("	bom_name,\n")
					.append("	part_cd,\n")
					.append("	part_cd_rev,\n")
					.append("	part_nm,\n")
					.append("	SUM(part_cnt) AS part_cnt,\n")
					.append("	unit_price,\n")
					.append("	SUM(price) AS price,\n")
					.append("	member_key\n")
					.append("FROM \n")
					.append("	bom_part_nm\n")
					.append("GROUP BY order_no,bom_cd,part_nm,lotno\n")
					.append("),\n")
					.append("work_date AS (\n")
					.append("SELECT DISTINCT\n")
					.append("	A.order_no,\n")
					.append("	A.lotno,\n")
					.append("	A.job_order_no,\n")
					.append("	A.prod_cd,\n")
					.append("	A.prod_cd_rev,\n")
					.append("	A.work_hour,\n")
					.append("	A.total_pay AS sum_total,\n")
					.append("	TO_CHAR(B.finish_dt,'YYYY-MM-DD') AS end_date,\n")
					.append("	A.member_key\n")
					.append("FROM \n")
					.append("	tbi_order_worker A\n")
					.append("INNER JOIN 	\n")
					.append("	tbi_production_exec B\n")
					.append("ON A.member_key = B.member_key\n")
					.append("AND A.order_no = B.order_no\n")
					.append("AND A.lotno = B.lotno\n")
					.append("AND A.prod_cd = B.prod_cd\n")
					.append("AND A.prod_cd_rev = B.prod_cd_rev\n")
					.append("),\n")
					.append("work_total AS (\n")
					.append("SELECT DISTINCT\n")
					.append("	end_date,\n")
					.append("	lotno,\n")
					.append("	order_no,\n")
					.append("	prod_cd,\n")
					.append("	prod_cd_rev,\n")
					.append("	SUM(sum_total) AS work_price_total,\n")
					.append("	member_key\n")
					.append("FROM work_date \n")
					.append("GROUP BY order_no,lotno,end_date\n")
					.append(")\n")
					.append("SELECT DISTINCT\n")
					.append("	A.order_no,\n")
					.append("	A.lotno,\n")
					.append("	A.bom_cd,\n")
					.append("	A.bom_cd_rev,\n")
					.append("	A.bom_name,\n")
					.append("	B.end_date,\n")
					.append("	FORMAT(SUM(B.work_price_total),0),\n")
					.append("	A.part_cd,\n")
					.append("	A.part_nm,\n")
					.append("	FORMAT(A.unit_price,0),\n")
					.append("	FORMAT(A.part_cnt,0),\n")
					.append("	FORMAT(A.price,0),\n")
					.append("	A.member_key\n")
					.append("FROM bom_part_list A\n")
					.append("INNER JOIN work_total B\n")
					.append("ON A.order_no = B.order_no\n")
					.append("AND A.lotno = B.lotno\n")
					.append("AND A.bom_cd = B.prod_cd\n")
					.append("AND A.bom_cd_rev = B.prod_cd_rev\n")
					.append("AND A.member_key = B.member_key\n")
					.append("WHERE A.member_key ='" + jArray.get("member_key") + "' \n")
					.append("AND B.end_date = '" + jArray.get("fromdate") + "'\n")
					.append("GROUP BY A.order_no, A.bom_cd, A.lotno, A.part_nm\n")
					.toString();
			
			String ActionCommand = ioParam.getActionCommand();
			if(ActionCommand.startsWith("doQueryTableFieldName")) {
				resultString = super.excuteQueryStringTableFieldName(con, sql.toString());
			}
			else {;
			resultString = super.excuteQueryString(con, sql.toString());
			}
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M707S020100E314()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
		} finally {
			if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M707S020100E314()","==== finally ===="+ e.getMessage());
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


}
