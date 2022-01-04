package mes.frame.business.M707;

import java.lang.reflect.Method;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.text.SimpleDateFormat;

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

public class M707S010100 extends SqlAdapter{
	Connection con = null;
	PreparedStatement pstmt = null;
	String resultString = "";
	int resultInt = -1;
	StringBuffer sql = new StringBuffer();
	
	String[][] v_paramArray = new String[0][0]; 
	Class[] optClass = null;
	Object[] optObj = null;
	Object obj = null;
	
	public M707S010100(){
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
			
			Method method = M707S010100.class.getMethod(event,optClass);
			LoggingWriter.setLogDebug(M707S010100.class.getName(),"==== " + event + " EventMethod Create Success ====");

			obj = method.invoke(M707S010100.class.newInstance(),optObj);
			doExcute_result = CommonFunction.getInt(obj.toString());
			
	    } catch (Exception ex) {
	    	doExcute_result = EventDefine.E_DOEXCUTE_INIT;
			ioParam.setMessage(MessageDefine.M_NO_EVENTID);
			LoggingWriter.setLogError(M707S010100.class.getName(),"==== EventID Not define : EVENT ID [ " + ioParam.getEventID() + "]");
	    } finally {
	    	obj = null;
			optClass = null;
			optObj = null;
	    }
	    long endTime = System.currentTimeMillis();
		long runningTime = endTime - startTime;
		LoggingWriter.setLogAll(M707S010100.class.getName(),"==== Query [수행시간  : " + runningTime + " ms]");
		
		return doExcute_result;
	}
	
	//	문서열람
	public int E204(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			
			SimpleDateFormat format = new SimpleDateFormat("yyyymmdd");
	        // date1, date2 두 날짜를 parse()를 통해 Date형으로 변환.
			String[] syyy = ((String) jArray.get("fromdate")).split("-");
			String[] eyyy = ((String) jArray.get("todate")).split("-");
			int dis_y = Integer.parseInt(eyyy[0]) - Integer.parseInt(syyy[0]);
			int dis_m = Integer.parseInt(eyyy[1]) - Integer.parseInt(syyy[1]);
			int dis_d = Integer.parseInt(eyyy[2]) - Integer.parseInt(syyy[2]);
			int distan_Mday;
			int distan_Yday = dis_y*365;
			switch (Integer.parseInt(syyy[1])) {
				case 1:
				case 3:
				case 5:
				case 7:
				case 8:
				case 10:
				case 12:
					distan_Mday = dis_m * 31;
					break;
				case 2:
					distan_Mday = dis_m * 28;
					break;
				default:
					distan_Mday = dis_m * 30;
					break;
			}

			String sql = new StringBuilder()
					.append("WITH open_doc AS(\n")
					.append("SELECT DISTINCT\n")
					.append("                A.regist_no,\n")
					.append("                A.document_no,\n")
					.append("                B.file_view_name,\n")
					.append("				C.document_name,\n")
					.append("				A.member_key\n")
					.append("        FROM\n")
					.append("                tbi_doc_openview_info A \n")
					.append("				INNER JOIN tbi_doc_regist_info B \n")
					.append("				ON A.regist_no = B.regist_no\n")
					.append("				AND A.regist_no_rev = B.revision_no\n")
					.append("				AND A.document_no=B.document_no\n")
					.append("				AND A.member_key = B.member_key\n")
					.append("				INNER JOIN tbm_doc_base C \n")
					.append("				ON B.document_no = C.document_no\n")
					.append("				AND B.document_no_rev = C.revision_no\n")
					.append("				AND B.member_key = C.member_key\n")
					.append("	WHERE TO_CHAR(open_date,'YYYY-MM-DD') BETWEEN '" + jArray.get("fromdate") + "' AND '" + jArray.get("todate") + "'\n")
					.append("     AND A.member_key ='" + jArray.get("member_key") + "' \n")
					.append(")\n")
					.append(", vOpen_date AS(\n")
					
					// 파라미터로 받아온 날짜기간 사이의 모든날짜 - 20190328 진욱추가
					.append("		SELECT TO_CHAR(TO_DATE('" + jArray.get("fromdate") + "', 'YYYY-MM-DD') + LEVEL - 1, 'YYYY-MM-DD') AS D1 \n")
					.append("       FROM db_root CONNECT BY LEVEL <= TO_DATE('" + jArray.get("todate") + "', 'YYYY-MM-DD') - TO_DATE('" + jArray.get("fromdate") + "', 'YYYY-MM-DD') + 1 \n")
					
					.append(")\n")
					.append(", pre_open_doc_list AS(	\n")
					.append("	SELECT \n")
					.append("		D1,\n")
					.append("		NVL(regist_no,'') AS regist_no,\n")
					.append("		NVL(document_no,'') AS document_no,\n")
					.append("		NVL(document_name,'') AS document_name,\n")
					.append("		NVL(file_view_name,'') AS file_view_name,\n")
					.append("		member_key\n")
					.append("	FROM vOpen_date D , open_doc E \n")
					.append(")\n")
					.append(", calc_cnt AS(\n")
					.append("	SELECT DISTINCT\n")
					.append("		A.regist_no,\n")
					.append("		COUNT(*) over(PARTITION BY A.regist_no, A.document_no, A.file_view_name,TO_CHAR(A.open_date,'YYYY-MM-DD')) AS view_cnt,\n")
					.append("		A.document_no,\n")
					.append("		B.file_view_name,\n")
					.append("		TO_CHAR(A.open_date,'YYYY-MM-DD') AS open_date,\n")
					.append("		A.open_user_id,\n")
					.append("		A.open_ip,\n")
					.append("		A.regist_no_rev,\n")
					.append("		A.member_key\n")
					.append("	FROM\n")
					.append("		tbi_doc_openview_info A \n")
					.append("	INNER JOIN tbi_doc_regist_info B\n")
					.append("       ON A.regist_no = B.regist_no\n")
					.append("       AND A.regist_no_rev = B.revision_no\n")
					.append("       AND A.document_no=B.document_no\n")
					.append("		AND A.member_key = B.member_key\n")
					.append("	WHERE TO_CHAR(open_date,'YYYY-MM-DD') BETWEEN '" + jArray.get("fromdate") + "' AND '" + jArray.get("todate") + "'\n")
					.append("     AND A.member_key ='" + jArray.get("member_key") + "' \n")
					.append(")\n")
					.append("	SELECT DISTINCT \n")
					.append("		D1,\n")
					.append("		A.regist_no,\n")
					.append("		A.document_no,\n")
					.append("		A.document_name,\n")
					.append("		A.file_view_name,\n")
					.append("		NVL(view_cnt,0) AS view_cnt\n")
					.append("	FROM pre_open_doc_list A \n")
					.append("	LEFT OUTER JOIN calc_cnt B \n")
					.append("	ON  D1 = open_date\n")
					.append("	AND A.regist_no = B.regist_no \n")
					.append("	AND A.document_no = B.document_no\n")
					.append("	AND A.file_view_name = B.file_view_name\n")
					.append("	AND A.member_key = B.member_key\n")
					.append("	ORDER BY A.regist_no asc , A.document_no ASC, A.file_view_name ASC, D1 asc \n")
					.toString();
			String zSql =sql;

			String ActionCommand = ioParam.getActionCommand();
			if(ActionCommand.startsWith("doQueryTableFieldName")) {
				resultString = super.excuteQueryStringTableFieldName(con, zSql);
			} else {
				resultString = super.excuteQueryString(con, zSql);
			}
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M707S010100E204()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M707S010100E204()","==== finally ===="+ e.getMessage());
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
	
	//S-ONE 운송모니터링 
	public int E505(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			
			String sql = new StringBuilder()
					.append("SELECT\n")
					.append("	vehicle_cd,\n")
					.append("	censor_no,\n")
					.append("	x_position,\n")
					.append("	y_position,\n")
					.append("	signal_a,\n")
					.append("	signal_b,\n")
					.append("	degree_a,\n")
					.append("	degree_b,\n")
					.append("	min_temp_a,\n")
					.append("	max_temp_a,\n")
					.append("	min_temp_b,\n")
					.append("	max_temp_b,\n")
					.append("	receive_date,\n")
					.append("	turn_on_off,\n")
					.append("	location\n")
					.append("FROM\n")
					.append("	haccp_transit_data\n")
					.append("WHERE\n")
					.append("	receive_date BETWEEN  '"+jArray.get("fromdate")+"' AND '"+jArray.get("todate")+" 23:59:59'\n")
					.append("	ORDER BY receive_date desc\n")
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
			LoggingWriter.setLogError("M707S010100E505()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M707S010100E505()","==== finally ===="+ e.getMessage());
				}
	    	}
	    }
		ioParam.setResultString(resultString);
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
    	ioParam.setMessage(MessageDefine.M_QUERY_OK);
	    return EventDefine.E_QUERY_RESULT;
	}
	
}
