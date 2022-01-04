package mes.frame.business.M202;

import java.lang.reflect.Method;
import java.math.BigDecimal;
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
import mes.frame.common.QueueProcessing;
import mes.frame.database.JDBCConnectionPool;
import mes.frame.database.SqlAdapter;
import mes.frame.serviceinterface.InoutParameter;
import mes.frame.serviceinterface.LoggingWriter;
import mes.frame.util.CommonFunction;


public class M202S040100 extends SqlAdapter{
	Connection con = null;
	PreparedStatement pstmt = null;
	String resultString = "";
	int resultInt = -1;
	StringBuffer sql = new StringBuffer();
	
	String[][] v_paramArray = new String[0][0]; 
	Class[] optClass = null;
	Object[] optObj = null;
	Object obj = null;
	
	public M202S040100(){
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
			
			Method method = M202S040100.class.getMethod(event,optClass);
			LoggingWriter.setLogDebug(M202S040100.class.getName(),"==== " + event + " EventMethod Create Success ====");

			obj = method.invoke(M202S040100.class.newInstance(),optObj);
			doExcute_result = CommonFunction.getInt(obj.toString());
			
	    } catch (Exception ex) {
	    	doExcute_result = EventDefine.E_DOEXCUTE_INIT;
			ioParam.setMessage(MessageDefine.M_NO_EVENTID);
			LoggingWriter.setLogError(M202S040100.class.getName(),"==== EventID Not define : EVENT ID [ " + ioParam.getEventID() + "]");
	    } finally {
	    	obj = null;
			optClass = null;
			optObj = null;
	    }
	    long endTime = System.currentTimeMillis();
		long runningTime = endTime - startTime;
		LoggingWriter.setLogAll(M202S040100.class.getName(),"==== Query [수행시간  : " + runningTime + " ms]");
		
		return doExcute_result;
	}
	
//수입검사결과목록  S202S040120.jsp
	public int E124(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			System.out.println("JSONObject jArray rcvData="+ jArray.toString());
			
			String sql = new StringBuilder()
					.append("SELECT DISTINCT\n")
					.append("        A.order_no,\n")
					.append("        A.lotno,\n")
					.append("        A.part_cd,\n")
					.append("        A.part_cd_rev,\n")
//					.append("        B.part_nm || '('||E.code_name  ||','||  F.code_name ||')' AS part_nm,\n")
					.append("        B.part_nm,\n")
					.append("        A.inspect_count,\n")
					.append("        D.machineno,\n")
					.append("        D.rakes,\n")
					.append("        D.plate,\n")
					.append("        D.colm,\n")
					.append("        D.machineno || '-' || D.rakes  || '-' ||  D.plate  || '-' ||  D.colm AS part_loc,\n")
					.append("        CAST(TO_CHAR (NVL(D.pre_amt,0), '999,999,999,999') AS NUMERIC(15,3)) as pre_amt,\n")
					.append("        CAST(TO_CHAR (NVL(D.io_amt,0), '999,999,999,999') AS NUMERIC(15,3)) as io_amt,\n")
					.append("        CAST(TO_CHAR (NVL(D.post_amt,0), '999,999,999,999') AS NUMERIC(15,3)) as post_amt,\n")
					.append("   B.safety_jaego,\n")
					.append("        E.code_name AS gubun_b,\n")
					.append("   B.part_gubun_b,\n")
					.append("   F.code_name AS gubun_m,\n")
					.append("   B.part_gubun_m,\n")
					.append("   D.expiration_date,\n")
					.append("   D.hist_no\n")
					.append("FROM tbi_balju_list_inspect A\n")
					.append("INNER JOIN tbm_part_list B\n")
					.append("	ON A.part_cd = B.part_cd\n")
					.append("	AND A.part_cd_rev = B.revision_no\n")
					.append("	AND A.member_key = B.member_key\n")
					.append("LEFT OUTER JOIN tbi_part_storage D\n")
					.append("        ON A.part_cd = D.part_cd\n")
					.append("        AND A.part_cd_rev = D.part_cd_rev\n")
					.append("   AND A.member_key = D.member_key\n")
					.append("LEFT OUTER JOIN v_partgubun_big E\n")
					.append("        ON B.part_gubun_b = E.code_value\n")
					.append("   AND B.member_key = E.member_key\n")
					.append("LEFT OUTER JOIN v_partgubun_mid F\n")
					.append("        ON B.part_gubun_m = F.code_value\n")
					.append("   AND B.member_key = F.member_key\n")
					
					.append("WHERE A.order_no = '" + jArray.get("order_no") + "' \n")
					.append("	AND A.lotno = '" + jArray.get("lotno") + "' \n")
					.append("	AND A.balju_no = '" + jArray.get("baljuNo") + "' \n")
					.append("	AND A.member_key = '"+ jArray.get("member_key") +"'\n")
					.append("	AND CAST(D.post_amt AS INTEGER) > 0\n")
					.toString();
					
			String ActionCommand = ioParam.getActionCommand();
			if(ActionCommand.startsWith("doQueryTableFieldName")) {
				resultString = super.excuteQueryStringTableFieldName(con, sql.toString());
			}
			else {
				resultString = super.excuteQueryString(con, sql.toString());
			}
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M202S040100E124()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M202S040100E124()","==== finally ===="+ e.getMessage());
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

	public int E134(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			System.out.println("JSONObject jArray rcvData="+ jArray.toString());
			
			// 클라이언트로 부터 받은 파라미터를 옮겨 담는다.
//			String rcvData = (String)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			// 클라이언트로 부터 받은 파라미터를 쪼개어서 배열에 담는다.
			// rcvData = [위경도]
//			String[][] c_paramArray = CommonFunction.getConvString2DoubleArray(rcvData);
			
			String sql = new StringBuilder()
					.append("SELECT\n")
					.append("	order_no,\n")
					.append("	order_detail_seq,\n")
					.append("	write_date,\n")
					.append("	ipgo_date,\n")
					.append("	ingae_date,\n")
					.append("	inspect_report_yn,\n")
					.append("	inspect_end_date,\n")
					.append("	inspect_note,\n")
					.append("	balju_no,\n")
					.append("	balju_seq,\n")
					.append("	bom_nm,\n")
					.append("	bom_cd,\n")
//					.append("	bupum_bunho,\n")//part_cd로 대체
					.append("	part_cd,\n")
					.append("	req_count,\n")
					.append("	part_cd_rev\n")
					.append("FROM tbi_import_inspect_request\n")
					.append("WHERE order_no = '" + jArray.get("order_no") + "' \n")
					.append("AND A.member_key = '"+ jArray.get("member_key") +"'\n")
					.toString();
			String ActionCommand = ioParam.getActionCommand();
			if(ActionCommand.startsWith("doQueryTableFieldName")) {
				resultString = super.excuteQueryStringTableFieldName(con, sql.toString());
			}
			else {
				resultString = super.excuteQueryString(con, sql.toString());
			}
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M202S040100E134()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M202S040100E134()","==== finally ===="+ e.getMessage());
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
	
	public int E144(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			System.out.println("JSONObject jArray rcvData="+ jArray.toString());
			
			String sql = new StringBuilder()
					.append("SELECT DISTINCT\n")
					.append("        A.order_no,\n")
					.append("        A.lotno,\n")
					.append("        A.part_cd,\n")
					.append("        A.part_cd_rev,\n")
					.append("        B.part_nm,\n")
					.append("        A.inspect_count,\n")
					.append("        D.machineno,\n")
					.append("        D.rakes,\n")
					.append("        D.plate,\n")
					.append("        D.colm,\n")
					.append("        D.machineno || '-' || D.rakes  || '-' ||  D.plate  || '-' ||  D.colm AS part_loc,\n")
					.append("        CAST(TO_CHAR (NVL(D.pre_amt,0), '999,999,999,999') AS NUMERIC(15,3)) as pre_amt,\n")
					.append("        CAST(TO_CHAR (NVL(D.io_amt,0), '999,999,999,999') AS NUMERIC(15,3)) as io_amt,\n")
					.append("        CAST(TO_CHAR (NVL(D.post_amt,0), '999,999,999,999') AS NUMERIC(15,3)) as post_amt,\n")
					.append("   B.safety_jaego,\n")
					.append("        E.code_name AS gubun_b,\n")
					.append("   B.part_gubun_b,\n")
					.append("   F.code_name AS gubun_m,\n")
					.append("   B.part_gubun_m,\n")
					.append("   D.expiration_date,\n")
					.append("   D.hist_no\n")
					.append("FROM tbi_balju_list_inspect A\n")
					.append("INNER JOIN tbm_part_list B\n")
					.append("	ON A.part_cd = B.part_cd\n")
					.append("	AND A.part_cd_rev = B.revision_no\n")
					.append("	AND A.member_key = B.member_key\n")
					.append("LEFT OUTER JOIN tbi_part_storage D\n")
					.append("        ON A.part_cd = D.part_cd\n")
					.append("        AND A.part_cd_rev = D.part_cd_rev\n")
					.append("   AND A.member_key = D.member_key\n")
					.append("LEFT OUTER JOIN v_partgubun_big E\n")
					.append("        ON B.part_gubun_b = E.code_value\n")
					.append("   AND B.member_key = E.member_key\n")
					.append("LEFT OUTER JOIN v_partgubun_mid F\n")
					.append("        ON B.part_gubun_m = F.code_value\n")
					.append("   AND B.member_key = F.member_key\n")
					
					.append("WHERE A.order_no = '" + jArray.get("order_no") + "' \n")
					.append("	AND A.lotno = '" + jArray.get("lotno") + "' \n")
					.append("	AND A.balju_no = '" + jArray.get("baljuNo") + "' \n")
					.append("	AND A.member_key = '"+ jArray.get("member_key") +"'\n")
					.append("	AND CAST(D.post_amt AS INTEGER) > 0\n")
					.toString();
			
			String ActionCommand = ioParam.getActionCommand();
			if(ActionCommand.startsWith("doQueryTableFieldName")) {
				resultString = super.excuteQueryStringTableFieldName(con, sql.toString());
			}
			else {
				resultString = super.excuteQueryString(con, sql.toString());
			}
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M202S040100E144()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M202S040100E144()","==== finally ===="+ e.getMessage());
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
	
	public int E137(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			
			String sql = new StringBuilder()
					.append("SELECT\n")
					.append("	B.balju_no,\n")
					.append("	balju_seq,\n")
					.append("	bom_nm,\n")
					.append("	bom_cd,\n")
//					.append("	bupum_bunho,\n") // part_cd로 대체
					.append("	part_cd,\n")
					.append("	inspect_count,\n")
					.append("	part_cd_rev \n")
					.append("FROM tbi_balju_list_inspect A \n")
					.append("	INNER JOIN tbi_balju B \n")
					.append("	ON B.balju_no = A.balju_no\n")
					.append("	AND B.member_key = A.member_key\n")
					.append("WHERE B.order_no = '" + jArray.get("order_no") + "' \n")
					.append("AND A.member_key = '"+ jArray.get("member_key") +"'\n")
					.toString();
			String ActionCommand = ioParam.getActionCommand();
			if(ActionCommand.startsWith("doQueryTableFieldName")) {
				resultString = super.excuteQueryStringTableFieldName(con, sql.toString());
			}
			else {
				resultString = super.excuteQueryString(con, sql.toString());
			}
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M202S040100E137()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M202S040100E137()","==== finally ===="+ e.getMessage());
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
	// 사용하는 jsp 없음	
	public int E504(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			// 클라이언트로 부터 받은 파라미터를 옮겨 담는다.
			String rcvData = (String)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			// 클라이언트로 부터 받은 파라미터를 쪼개어서 배열에 담는다.
			// rcvData = [위경도]
			String[][] c_paramArray = CommonFunction.getConvString2DoubleArray(rcvData);
			
			//  {"순번", "보관위치", "원부자재코드", "구품코드", "원부자재명", "출고량(합)", "입고량(합)", "위치재고량", "안전재고" };  
			String sql = new StringBuilder()
					.append("WITH STORAGE_HIST AS(\n")
					.append("	SELECT machineno, SAVE_LOCATION, PARTCODE,OLD_PARTCODE, PART_NM, SAFETY_JAEGO, POST_AMT,IO_AMT, IO_GUBUN, IO_DATE ,IO_SEQNO,\n")
					.append("	SUM(CASE WHEN IO_GUBUN='O' THEN NVL(IO_AMT,0) END) OVER(PARTITION BY SAVE_LOCATION,PARTCODE)  as SUM_OUT,\n")
					.append("	SUM(CASE WHEN IO_GUBUN='I' THEN NVL(IO_AMT,0) END) OVER(PARTITION BY SAVE_LOCATION,PARTCODE)  as SUM_IN\n")
					.append("	FROM tbi_part_storage_hist A\n")
					.append("		INNER JOIN TB_PARTLIST B\n")
					.append("		ON A.PARTCODE = PART_CD\n")
					.append("		AND A.member_key = member_key\n")
					.append("	WHERE machineno	= 	'" + c_paramArray[0][0] + "' \n")
					.append("	AND   IO_DATE 	>=	'" + c_paramArray[0][1] + "' \n")
					.append("	AND   IO_DATE 	<=	'" + c_paramArray[0][2] + "' \n")
					.append("),\n")
					.append("STORAGE_HIST_RANK AS(\n")
					.append("	SELECT machineno, SAVE_LOCATION, PARTCODE,OLD_PARTCODE, PART_NM, NVL(SAFETY_JAEGO,0) AS SAFETY_JAEGO, IO_AMT,POST_AMT, IO_GUBUN, IO_DATE ,IO_SEQNO,SUM_OUT,SUM_IN,\n")
					.append("	RANK() OVER (PARTITION BY SAVE_LOCATION,PARTCODE ORDER BY SAVE_LOCATION, PARTCODE DESC, IO_DATE DESC,IO_SEQNO DESC) as rk\n")
					.append("	FROM STORAGE_HIST\n")
					.append("),\n")
					.append("STORAGE_HIST_TOP AS (\n")
					.append("	SELECT machineno, SAVE_LOCATION, PARTCODE,OLD_PARTCODE, PART_NM, SAFETY_JAEGO, IO_AMT, POST_AMT, IO_GUBUN, IO_DATE ,IO_SEQNO ,nvl(SUM_OUT,0) AS SUM_OUT ,nvl(SUM_IN,0) AS SUM_IN\n")
					.append("	FROM STORAGE_HIST_RANK \n")
					.append("	WHERE rk=1 \n")
//					.append("	ORDER BY SAVE_LOCATION,PARTCODE\n")
					.append(")\n")
					.append("SELECT\n")
					.append("	SAVE_LOCATION,\n")
					.append("	PARTCODE,\n")
					.append("	OLD_PARTCODE,\n")
					.append("	PART_NM,\n")
					.append("	SUM_OUT,\n")
					.append("	SUM_IN,\n")
					.append("	POST_AMT,\n")
					.append("	SAFETY_JAEGO\n")
					.append("FROM STORAGE_HIST_TOP\n")
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
			LoggingWriter.setLogError("M202S040100E504()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M202S040100E504()","==== finally ===="+ e.getMessage());
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



	public int E999(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			String rcvData = (String)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			String[][] c_paramArray = CommonFunction.getConvString2DoubleArray(rcvData);
			String sql = new StringBuilder()
					.append("WITH order_balju AS(\n")
					.append("	SELECT balju_no FROM tbi_balju WHERE order_no = '" + c_paramArray[0][0] + "'\n")
					.append("),\n")
					.append("balju_list_cnt AS(\n")
					.append("SELECT COUNT(*)   AS balju_list_Count FROM tbi_balju_list A, order_balju  WHERE A.balju_no= order_balju.balju_no\n")
					.append("),\n")
					.append("balju_Inspect_cnt AS(\n")
					.append("SELECT  COUNT(*) AS balju_Inspect_Count FROM tbi_balju_list_inspect B, order_balju WHERE B.balju_no=order_balju.balju_no\n")
					.append("),\n")
					.append("import_request_cnt AS(\n")
					.append("SELECT  COUNT(*) AS import_request_Count FROM tbi_import_inspect_request C, order_balju WHERE order_no ='" + c_paramArray[0][0] + "' AND C.balju_no=order_balju.balju_no\n")
					.append(")\n")
					.append("SELECT  ' 주문번호: " + c_paramArray[0][0] + "의 발주원부자재 수: ' || balju_list_Count || '건,'  || \n")
					.append("		' 발주원부자재 검수 수:' || balju_Inspect_Count || '건,'  || \n")
					.append("		' 발주원부자재 수입검사 신청 수:' || import_request_Count || '건' , \n")
					.append("		balju_list_Count,\n")
					.append("		balju_Inspect_Count ,\n")
					.append("		import_request_Count \n")
					.append("FROM balju_list_cnt, balju_Inspect_cnt, import_request_cnt;\n")
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
			LoggingWriter.setLogError("M202S040100E999()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M202S040100E999()","==== finally ===="+ e.getMessage());
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

