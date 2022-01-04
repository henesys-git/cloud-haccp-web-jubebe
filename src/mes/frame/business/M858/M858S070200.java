package mes.frame.business.M858;

import java.lang.reflect.Method;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.util.Vector;

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


public class M858S070200 extends SqlAdapter{
	Connection con = null;
	PreparedStatement pstmt = null;
	String resultString = "";
	int resultInt = -1;
	StringBuffer sql = new StringBuffer();
	
	String[][] v_paramArray = new String[0][0]; 
	Class[] optClass = null;
	Object[] optObj = null;
	Object obj = null;
	
	public M858S070200(){
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
			
			Method method = M858S070200.class.getMethod(event,optClass);
			LoggingWriter.setLogDebug(M858S070200.class.getName(),"==== " + event + " EventMethod Create Success ====");

			obj = method.invoke(M858S070200.class.newInstance(),optObj);
			doExcute_result = CommonFunction.getInt(obj.toString());
			
	    } catch (Exception ex) {
	    	doExcute_result = EventDefine.E_DOEXCUTE_INIT;
			ioParam.setMessage(MessageDefine.M_NO_EVENTID);
			LoggingWriter.setLogError(M858S070200.class.getName(),"==== EventID Not define : EVENT ID [ " + ioParam.getEventID() + "]");
	    } finally {
	    	obj = null;
			optClass = null;
			optObj = null;
	    }
	    long endTime = System.currentTimeMillis();
		long runningTime = endTime - startTime;
		LoggingWriter.setLogAll(M858S070200.class.getName(),"==== Query [수행시간  : " + runningTime + " ms]");
		
		return doExcute_result;
	}
	

	public int E104(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();		
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			System.out.println("JSONObject jArray rcvData="+ jArray.toString());
			
			String sql = new StringBuilder()
					.append("SELECT\n")
					.append("	order_no,\n")
					.append("	balju_no,\n")
					.append("	balju_text,\n")
					.append("	TO_CHAR(balju_send_date,'YYYY-MM-DD') AS balju_send_date,\n")
					.append("	A.cust_cd,\n")
					.append("	C.cust_nm,\n")
					.append("	cust_cd_rev,\n")
					.append("	cust_damdang,\n")
					.append("	tell_no,\n")
					.append("	fax_no,\n")
					.append("	TO_CHAR(balju_nabgi_date,'YYYY-MM-DD') AS balju_nabgi_date,\n")
					.append("	nabpoom_location,\n")
					.append("	qa_ter_condtion	\n")
					.append("FROM tbi_balju A \n")
					.append("	INNER JOIN tbm_customer C \n")
					.append("	ON A.cust_cd = C.cust_cd\n")
					.append("	AND A.cust_cd_rev = C.revision_no\n")
					.append("	AND A.member_key = C.member_key\n")
					.append("WHERE  TO_CHAR(balju_send_date,'YYYY-MM-DD') BETWEEN '" + jArray.get("fromdate") + "' AND '" + jArray.get("todate") + "' \n")
					.append(" 	AND A.member_key = '" + jArray.get("member_key") + "' \n") //member_key_select, update, delete
					.append("	AND company_type_b='type02' \n")
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
			LoggingWriter.setLogError("M858S070200E104()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M858S070200E104()","==== finally ===="+ e.getMessage());
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


	public int E204(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();		
			
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			
			String sql = new StringBuilder()
					.append("SELECT\n")
					.append("	D.code_name,												\n")
					.append("	E.code_name,												\n")
					.append("	A.prod_cd,													\n")	// 완제품 코드
					.append("	B.product_nm,												\n")	// 완제품명
					.append("	A.prod_rev_no,												\n")	// 완제품 수정이력번호
					.append("   B.safe_stock, 												\n")
					.append("	SUM(post_amt) AS post_amt									\n")	// 현재 재고
					.append("FROM															\n")
					.append("	tbi_prod_storage2 A											\n")
					.append("INNER JOIN tbm_product B 										\n")
					.append("	ON A.prod_cd = B.prod_cd 									\n")
					.append("  AND A.prod_rev_no = B.revision_no							\n")
					.append("INNER JOIN v_prodgubun_big D									\n")
					.append("	ON B.prod_gubun_b = D.code_value							\n")
					.append("INNER JOIN v_prodgubun_mid E									\n")
					.append("	ON B.prod_gubun_m = E.code_value							\n")
					.append("WHERE prod_gubun_b like '" + jArray.get("prodgubun_big") + "%'" +
							 " AND prod_gubun_m like '" + jArray.get("prodgubun_mid") + "%'	\n")
					.append("GROUP BY A.prod_cd, A.prod_rev_no								\n")
					.append("ORDER BY B.product_nm											\n")
					.append(";																\n")
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
			LoggingWriter.setLogError("M858S070200E204()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M858S070200E204()","==== finally ===="+ e.getMessage());
				}
	    	} else {
	    	}
	    }
		ioParam.setResultString(resultString);
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
    	ioParam.setMessage(MessageDefine.M_QUERY_OK);

    	return EventDefine.E_QUERY_RESULT;
	}		
	
	public int E214(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			
			String sql = new StringBuilder()
				.append("SELECT													\n")
				.append("	A.prod_date,										\n")
				.append("	A.prod_cd,											\n")
				.append("	B.product_nm,										\n")
				.append("	B.gugyuk,											\n")
				.append("	A.prod_rev_no,										\n")
				.append("	A.post_amt,											\n")
				.append("	A.expiration_date,									\n")
				.append("	A.note												\n")
				.append("FROM													\n")
				.append("	tbi_prod_storage2 A									\n")
				.append("INNER JOIN tbm_product B 								\n")
				.append("	ON A.prod_cd = B.prod_cd							\n")
				.append("	AND A.prod_rev_no = B.revision_no					\n")
				.append("WHERE A.prod_cd = '" + jArray.get("prod_cd") + "'		\n")
				.append("	AND A.prod_rev_no = " + jArray.get("prod_rev") + "	\n")
				.append("	AND A.post_amt > 0									\n")
				.append("ORDER BY A.prod_date DESC								\n")
				.append(";														\n")
				.toString();

			String ActionCommand = ioParam.getActionCommand();
			if(ActionCommand.startsWith("doQueryTableFieldName")) {
				resultString = super.excuteQueryStringTableFieldName(con, sql);
			} else {
				resultString = super.excuteQueryString(con, sql.toString());
			}
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M858S070200E214()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M858S070200E214()","==== finally ===="+ e.getMessage());
				}
	    	}
	    }
		ioParam.setResultString(resultString);
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
    	ioParam.setMessage(MessageDefine.M_QUERY_OK);

    	return EventDefine.E_QUERY_RESULT;
	}

	
	public int E504(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			System.out.println("JSONObject jArray rcvData="+ jArray.toString());
			
			
			
			// 클라이언트로 부터 받은 파라미터를 옮겨 담는다.
//			String rcvData = (String)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
//			String[][] c_paramArray = CommonFunction.getConvString2DoubleArray(rcvData);
			
			String sql = new StringBuilder()
					.append("SELECT DISTINCT \n")
					.append("	order_no,\n")
					.append("	order_detail_seq,\n")
					.append("	A.balju_no,\n")
					.append("	A.cust_cd,\n")
					.append("	D.cust_nm,\n")
					.append("	C.part_cd,\n")
					.append("	E.part_nm,\n")
					.append("	C.pass_yn,\n")
					.append("	C.standard_value,\n")
					.append("	C.inspect_result,\n")
					.append("	part_cd_rev,\n")
					.append("	cust_cd_rev,\n")
					.append("	TO_CHAR(C.create_date,'YYYY-MM-DD')\n")
					.append("FROM\n")
					.append("	tbi_balju A \n")
					.append("	INNER JOIN tbm_customer D\n")
					.append("	ON A.cust_cd = D.cust_cd\n")
					.append("	AND A.cust_cd_rev = D.revision_no \n")
					.append("	AND A.member_key = D.member_key\n")
					.append("	INNER JOIN tbi_import_inspect_result_dt C \n")
					.append("	ON A.balju_no = C.balju_no\n")
					.append("	AND A.member_key = C.member_key\n")
					.append("	INNER JOIN tbm_part_list E \n")
					.append("	ON C.part_cd = E.part_cd\n")
					.append("	AND C.part_cd_rev = E.revision_no\n")
					.append("	AND C.member_key = E.member_key\n")
					.append("WHERE TO_CHAR(C.create_date,'YYYY-MM-DD') BETWEEN '" + jArray.get("fromdate") + "' AND '" + jArray.get("todate") + "' \n")
					.append("	AND A.cust_cd like '" + jArray.get("custcode") + "%'\n")
					.append("	AND A.cust_cd_rev like '" + jArray.get("custcode_rev") + "%'\n")
					.append(" 	AND A.member_key = '" + jArray.get("member_key") + "' \n") //member_key_select, update, delete
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
			LoggingWriter.setLogError("M858S070200E504()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M858S070200E504()","==== finally ===="+ e.getMessage());
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
	
	public int E604(InoutParameter ioParam){
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
					.append("SELECT\n")
					.append("	machineno,\n")
					.append("	rakes,\n")
					.append("	plate,\n")
					.append("	colm,\n")
					.append("	A.part_cd,\n")
					.append("	part_nm,\n")
					.append("	pre_amt,\n")
					.append("	post_amt,\n")
					.append("	io_amt,\n")
					.append("	NVL(safety_jaego,0) AS safety_jaego,\n")
					.append("	part_cd_rev,\n")
					.append("	bigo\n")
					.append("FROM\n")
					.append("	tbi_part_storage A \n")
					.append("	INNER JOIN tbm_part_list B \n")
					.append("	ON A.part_cd = B.alt_part_cd\n")
					.append("	AND A.part_cd_rev = B.alt_revision_no\n")
					.append("	AND A.member_key = B.member_key\n")
//					.append("	WHERE machineno	like 	'" + c_paramArray[0][0] + "%' \n")
					.append(" 	WHERE A.member_key = '" + c_paramArray[0][0] + "' \n") //member_key_select, update, delete
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
			LoggingWriter.setLogError("M858S070200E604()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M858S070200E604()","==== finally ===="+ e.getMessage());
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

