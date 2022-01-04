package mes.frame.business.M353;

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


public class M353S015100 extends SqlAdapter{
	Connection con = null;
	PreparedStatement pstmt = null;
	String resultString = "";
	int resultInt = -1;
	StringBuffer sql = new StringBuffer();
	
	String[][] v_paramArray = new String[0][0]; 
	Class[] optClass = null;
	Object[] optObj = null;
	Object obj = null;
	
	public M353S015100(){
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
			
			Method method = M353S015100.class.getMethod(event,optClass);
			LoggingWriter.setLogDebug(M353S015100.class.getName(),"==== " + event + " EventMethod Create Success ====");

			obj = method.invoke(M353S015100.class.newInstance(),optObj);
			doExcute_result = CommonFunction.getInt(obj.toString());
			
	    } catch (Exception ex) {
	    	doExcute_result = EventDefine.E_DOEXCUTE_INIT;
			ioParam.setMessage(MessageDefine.M_NO_EVENTID);
			LoggingWriter.setLogError(M353S015100.class.getName(),"==== EventID Not define : EVENT ID [ " + ioParam.getEventID() + "]");
	    } finally {
	    	obj = null;
			optClass = null;
			optObj = null;
	    }
	    long endTime = System.currentTimeMillis();
		long runningTime = endTime - startTime;
		LoggingWriter.setLogAll(M353S015100.class.getName(),"==== Query [수행시간  : " + runningTime + " ms]");
		
		return doExcute_result;
	}

	public int E104(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArr = new JSONObject();
			jArr = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			
			String sql = new StringBuilder()
					.append("SELECT														\n")
					.append("	C.code_name AS gubun_b,									\n")
					.append("	D.code_name AS gubun_m,									\n")
					.append("	A.prod_cd,												\n")
					.append("	B.product_nm,											\n")
					.append("	A.prod_date,											\n")
					.append("	A.ipgo_amount,											\n")
					.append("	B.count_in_box * B.count_in_pack AS pack_count,			\n")
					.append("   B.count_unit,											\n")
					.append("	E.blending_ratio,										\n")
					.append("	A.seq_no,												\n")
					.append("	A.prod_rev_no											\n")
					.append("FROM tbi_prod_ipgo2 A										\n")
					.append("INNER JOIN tbm_product B									\n")
					.append("	ON A.prod_cd = B.prod_cd								\n")
					.append("	AND A.prod_rev_no = B.revision_no						\n")
					.append("INNER JOIN v_prodgubun_big C								\n")
					.append("	ON B.prod_gubun_b = C.code_value						\n")
					.append("INNER JOIN v_prodgubun_mid D								\n")
					.append("	ON B.prod_gubun_m = D.code_value						\n")
					.append("INNER JOIN tbm_bom_info2 E									\n")
					.append("  ON B.prod_cd = E.prod_cd									\n")
					.append(" AND B.revision_no = E.prod_rev_no							\n")
					.append("INNER JOIN tbm_part_list F									\n")
					.append("	ON F.part_cd = E.part_cd								\n")
					.append("	AND F.revision_no = E.part_rev_no						\n")
					.append("WHERE 														\n")
					.append("  prod_gubun_b LIKE '"+jArr.get("prodgubun_big")+"%'		\n")
					.append("  AND prod_gubun_m like '"+jArr.get("prodgubun_mid")+"%'	\n")
					.append("  AND A.ipgo_seq_no = (SELECT MIN(ipgo_seq_no) 			\n")
					.append("                   	FROM tbi_prod_ipgo2 A2				\n")
					.append("                   	WHERE A.prod_date = A2.prod_date	\n")
					.append("                     	AND A.seq_no = A2.seq_no			\n")
					.append("                     	AND A.prod_cd = A2.prod_cd			\n")
					.append("                     	AND A.prod_rev_no = A2.prod_rev_no)	\n")
					.append("	AND F.part_gubun_b = '01'								\n")
					.append("ORDER BY prod_date DESC									\n")
					.toString();
			
			String ActionCommand = ioParam.getActionCommand();
			if(ActionCommand.startsWith("doQueryTableFieldName")) {
				resultString = super.excuteQueryStringTableFieldName(con, sql.toString());
			} else {
				resultString = super.excuteQueryString(con, sql.toString());
			}
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M858S060100E104()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M858S060100E104()","==== finally ===="+ e.getMessage());
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

			JSONObject jObj = new JSONObject();
			jObj = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			
			String sql = new StringBuilder()
					.append("SELECT 												\n")
					.append("	B.part_nm,											\n")
					.append("	A.blending_ratio									\n")
					.append("FROM tbm_bom_info2 A									\n")
					.append("INNER JOIN tbm_part_list B								\n")
					.append("   ON A.part_cd = B.part_cd							\n")
					.append("  AND A.part_rev_no = B.revision_no					\n")
					.append("WHERE prod_cd = '" + jObj.get("prodCd") + "' 			\n")
					.append("  AND prod_rev_no = " + jObj.get("prodRevNo") + "		\n")
					.append("  AND bom_rev_no = (SELECT MAX(bom_rev_no)				\n")
					.append("   				 FROM tbm_bom_info2 A2				\n")
					.append("   				 WHERE A.prod_cd = A2.prod_cd		\n")
					.append("   				 AND A.prod_rev_no = A2.prod_rev_no)\n")
					.toString();

			String ActionCommand = ioParam.getActionCommand();
			if(ActionCommand.startsWith("doQueryTableFieldName")) {
				resultString = super.excuteQueryStringTableFieldName(con, sql);
			} else {
				resultString = super.excuteQueryString(con, sql);
			}
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M858S060100E114()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M858S060100E114()","==== finally ===="+ e.getMessage());
				}
	    	}
	    }
		ioParam.setResultString(resultString);
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
    	ioParam.setMessage(MessageDefine.M_QUERY_OK);
	    return EventDefine.E_QUERY_RESULT;
	}
}