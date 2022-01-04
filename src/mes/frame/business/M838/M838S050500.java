package mes.frame.business.M838;
/*BOM코드*/
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


/**
 * 개요 : 이벤트ID별 메소드 정의
 */
public  class M838S050500 extends SqlAdapter{
	Connection con = null;
	PreparedStatement pstmt = null;
	String resultString = "";
	int resultInt = -1;
	StringBuffer sql = new StringBuffer();
	
	String[][] v_paramArray = new String[0][0]; 
	Class[] optClass = null;
	Object[] optObj = null;
	Object obj = null;
	
	public M838S050500(){
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
			
			Method method = M838S050500.class.getMethod(event,optClass);
			LoggingWriter.setLogDebug(M838S050500.class.getName(),"==== " + event + " EventMethod Create Success ====");

			obj = method.invoke(M838S050500.class.newInstance(),optObj);
			doExcute_result = CommonFunction.getInt(obj.toString());
			
	    } catch (Exception ex) {
	    	doExcute_result = EventDefine.E_DOEXCUTE_INIT;
			ioParam.setMessage(MessageDefine.M_NO_EVENTID);
			LoggingWriter.setLogError(M838S050500.class.getName(),"==== EventID Not define : EVENT ID [ " + ioParam.getEventID() + "]");
	    } finally {
	    	obj = null;
			optClass = null;
			optObj = null;
	    }
	    long endTime = System.currentTimeMillis();
		long runningTime = endTime - startTime;
		LoggingWriter.setLogAll(M838S050500.class.getName(),"==== Query [수행시간  : " + runningTime + " ms]");
		
		return doExcute_result;
	}
	
	// S838S050500.jsp
	public int E104(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			System.out.println("JSONObject jArray rcvData="+ jArray.toString());
    		
			String sql = new StringBuilder()
					.append("SELECT DISTINCT\n")
					.append("	cleaner_reg_no,\n")
					.append("	cleaner_reg_rev,\n")
					.append("	cleaner_reg_date,\n")
					.append("	A.part_cd,\n")
					.append("	A.part_cd_rev,\n")
					.append("	P.part_nm,\n")
					.append("	cleaner_usage,\n")
					.append("	ipgo_amt,\n")
					.append("	usage_amt,\n")
					.append("	store_amt,\n")
					.append("	write_dept,\n")
					.append("	D.code_name,\n")
					.append("	writor_main,\n")
					.append("	writor_main_rev,\n")
					.append("	U1.user_nm,\n")
					.append("	approval,\n")
					.append("	approval_date,\n")
					.append("	bigo\n")
					.append("FROM\n")
					.append("	haccp_cleaner_mgr_list A\n")
					.append("LEFT OUTER JOIN v_dept_code D\n")
					.append("	ON A.write_dept = D.code_value\n")
					.append("	AND A.member_key = D.member_key\n")
					.append("INNER JOIN tbm_users U1\n")
					.append("	ON A.writor_main=U1.user_id\n")
					.append("	AND A.writor_main_rev=U1.revision_no\n")
					.append("	AND A.member_key=U1.member_key\n")
					.append("INNER JOIN tbm_part_list P \n")
					.append("	ON A.part_cd = P.part_cd\n")
					.append("	AND A.part_cd_rev = P.revision_no\n")
					.append("	AND A.member_key = P.member_key\n")
					.append("WHERE cleaner_reg_date \n")
					.append("BETWEEN '" + jArray.get("fromdate") + "' 	\n")
					.append("	 AND '" + jArray.get("todate") + "'	\n")
					.append(" 	 AND A.member_key = '" + jArray.get("member_key") + "' \n") //member_key_select, update, delete
					.append("GROUP BY cleaner_reg_date,P.part_nm,ipgo_amt,store_amt\n")
					.append("ORDER BY cleaner_reg_date\n")
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
			LoggingWriter.setLogError("M838S050500E104()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M838S050500E104()","==== finally ===="+ e.getMessage());
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
	
	// S838S050502.jsp 수정 // S838S050503.jsp 삭제
	public int E114(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			System.out.println("JSONObject jArray rcvData="+ jArray.toString());
    		
			String sql = new StringBuilder()
					.append("SELECT DISTINCT\n")
					.append("	cleaner_reg_no,\n")
					.append("	cleaner_reg_rev,\n")
					.append("	cleaner_reg_date,\n")
					.append("	A.part_cd,\n")
					.append("	A.part_cd_rev,\n")
					.append("	P.part_nm,\n")
					.append("	cleaner_usage,\n")
					.append("	ipgo_amt,\n")
					.append("	usage_amt,\n")
					.append("	store_amt,\n")
					.append("	write_dept,\n")
					.append("	writor_main,\n")
					.append("	writor_main_rev,\n")
					.append("	approval,\n")
					.append("	approval_date,\n")
					.append("	bigo\n")
					.append("FROM\n")
					.append("	haccp_cleaner_mgr_list A\n")
					.append("INNER JOIN tbm_part_list P \n")
					.append("	ON A.part_cd = P.part_cd\n")
					.append("	AND A.part_cd_rev = P.revision_no\n")
					.append("	AND A.member_key = P.member_key\n")
					.append("WHERE cleaner_reg_no='" + jArray.get("cleaner_reg_no") + "' \n")
					.append("	AND cleaner_reg_rev='" + jArray.get("cleaner_reg_rev") + "' 	\n")
					.append("	AND cleaner_reg_date='" + jArray.get("cleaner_reg_date") + "' 	\n")
					.append(" 	AND A.member_key = '" + jArray.get("member_key") + "' \n") //member_key_select, update, delete
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
			LoggingWriter.setLogError("M838S050500E114()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M838S050500E114()","==== finally ===="+ e.getMessage());
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

	// T838S050520.jsp 세척제 입고정보 조회(Tablet)
	public int E124(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			System.out.println("JSONObject jArray rcvData="+ jArray.toString());
    		
			String sql = new StringBuilder()
					.append("SELECT DISTINCT\n")
					.append("        A.part_cd,\n")
					.append("        A.part_cd_rev,\n")
					.append("        B.part_nm,\n")
					.append("        A.machineno,\n")
					.append("        A.rakes,\n")
					.append("        A.plate,\n")
					.append("        A.colm,\n")
					.append("        TO_CHAR (A.pre_amt, '999,999,999,999') as pre_stack,\n")
					.append("        TO_CHAR (A.io_amt, '999,999,999,999') as io_count,\n")
					.append("        TO_CHAR (A.post_amt, '999,999,999,999') as post_stack,\n")
					.append("        A.bigo\n")
					.append("FROM\n")
					.append("        tbi_part_storage A\n")
					.append("        INNER JOIN tbm_part_list B\n")
					.append("        ON A.part_cd = B.part_cd\n")
					.append("        AND A.part_cd_rev = B.revision_no\n")
					.append("        AND A.member_key = B.member_key\n")
					.append("WHERE B.part_gubun_b LIKE '" + jArray.get("part_gubun_b") + "%'\n")
					.append("	AND B.part_gubun_m LIKE '" + jArray.get("part_gubun_b") + "%'\n")
					.append("	AND B.part_gubun_s LIKE '" + jArray.get("part_gubun_b") + "%'\n")
					.append("	AND A.post_amt > 0 \n")
					.append(" 	AND A.member_key = '" + jArray.get("member_key") + "' \n") //member_key_select, update, delete
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
			LoggingWriter.setLogError("M838S050500E124()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M838S050500E124()","==== finally ===="+ e.getMessage());
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
	
	// S838S050500_canvas.jsp
	public int E144(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			System.out.println("JSONObject jArray rcvData="+ jArray.toString());
			
			String sql = new StringBuilder()
					.append("SELECT\n")
					.append("	A.cleaner_reg_no,\n")
					.append("	A.cleaner_reg_rev,\n")
					.append("	A.cleaner_reg_date,\n")
					.append("	SUBSTRING(A.cleaner_reg_date,0,4),\n")
					.append("   SUBSTRING(A.cleaner_reg_date,6,2),\n")
					.append("   SUBSTRING(A.cleaner_reg_date,9,2),\n")
					.append("	P.part_nm,\n")
					.append("	A.part_cd,\n")
					.append("	A.part_cd_rev,\n")
					.append("	A.cleaner_usage,\n")
					.append("	A.ipgo_amt,\n")
					.append("	A.usage_amt,\n")
					.append("	A.store_amt,\n")
					.append("	A.write_dept,\n")
					.append("	A.writor_main,\n")
					.append("	A.writor_main_rev,\n")
					.append("	U1.user_nm,\n")
					.append("	A.approval,\n")
					.append("	A.approval_date,\n")
					.append("	A.bigo,\n")
					.append("	A.member_key\n")
					.append("FROM haccp_cleaner_mgr_list A\n")
					.append("	INNER JOIN tbm_part_list P \n")
					.append("	ON A.member_key = P.member_key\n")
					.append("	AND A.part_cd = P.part_cd\n")
					.append("	AND A.part_cd_rev = P.revision_no\n")
					.append("	INNER JOIN tbm_users U1 \n")
					.append("	ON A.writor_main = U1.user_id\n")
					.append("	AND A.writor_main_rev = U1.revision_no\n")
					.append("	AND A.member_key = U1.member_key\n")
					.append("WHERE A.member_key = '" + jArray.get("member_key") + "' 	\n")
					.append("AND SUBSTRING(A.cleaner_reg_date,0,4) = '" + jArray.get("cleaner_reg_date_year") + "' 	\n")
					.append("AND SUBSTRING(A.cleaner_reg_date,6,2) = '" + jArray.get("cleaner_reg_date_month") + "' 	\n")
					.append("AND NOT bigo='입고'\n")
					.append("ORDER BY A.cleaner_reg_date,A.part_cd,A.part_cd_rev ;\n")
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
			LoggingWriter.setLogError("M838S050500E144()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M838S050500E144()","==== finally ===="+ e.getMessage());
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
	
	// S838S050500_canvas.jsp
	public int E154(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			System.out.println("JSONObject jArray rcvData="+ jArray.toString());
			
			String sql = new StringBuilder()
					.append("SELECT DISTINCT\n")
					.append("        P.part_nm,\n")
					.append("        A.part_cd,\n")
					.append("        A.part_cd_rev,\n")
					.append("        A.cleaner_usage,\n")
					.append("      	 A.cleaner_reg_date,\n")
					.append("        A.member_key\n")
					.append("FROM haccp_cleaner_mgr_list A\n")
					.append("        INNER JOIN tbm_part_list P\n")
					.append("        ON A.member_key = P.member_key\n")
					.append("        AND A.part_cd = P.part_cd\n")
					.append("        AND A.part_cd_rev = P.revision_no\n")
					.append("        INNER JOIN tbm_users U1\n")
					.append("        ON A.writor_main = U1.user_id\n")
					.append("        AND A.writor_main_rev = U1.revision_no\n")
					.append("        AND A.member_key = U1.member_key\n")
					.append("WHERE A.member_key = '" + jArray.get("member_key") + "' 	\n")
					.append("AND SUBSTRING(A.cleaner_reg_date,0,4) = '" + jArray.get("cleaner_reg_date_year") + "' 	\n")
					.append("AND SUBSTRING(A.cleaner_reg_date,6,2) = '" + jArray.get("cleaner_reg_date_month") + "' 	\n")
					.append("AND NOT A.bigo = '입고'\n")
					.append("GROUP BY A.part_cd,A.part_cd_rev\n")
					.append("ORDER BY A.cleaner_reg_date,A.part_cd,A.part_cd_rev\n")
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
			LoggingWriter.setLogError("M838S050500E154()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
		} finally {
			if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M838S050500E154()","==== finally ===="+ e.getMessage());
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
	
	// T838S050500.jsp 등록화면(Tablet) // S838S050501.jsp 등록화면(PC)
	public int E101(InoutParameter ioParam){ 
		resultInt = EventDefine.E_DOEXCUTE_INIT;

		try {
			con = JDBCConnectionPool.getConnection();
			con.setAutoCommit(false);
			
			// insert_update_delete_json.jsp에서 받아온 JSON데이터 처리
    		JSONObject jArray = new JSONObject();
    		jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
    		System.out.println("JSONObject jArray rcvData="+ jArray.toString());
    		// Object데이터에서 키값(param)으로 JSONArray데이터를 꺼낸다. (데이터묶음 하나일땐 생략)

    		// cleaner_reg_no 등록번호(MAX+1)
    		String sql = new StringBuilder()
    				.append("SELECT\n")
    				.append("	NVL( MAX( CAST(cleaner_reg_no AS INTEGER) ), 0 )\n")
    				.append("FROM\n")
    				.append("	haccp_cleaner_mgr_list\n")
    				.append("WHERE member_key = '" + jArray.get("member_key") + "'\n")
    				.toString();
    		String resultString = excuteQueryString(con, sql.toString()).trim();
    		int cleaner_reg_no = Integer.parseInt(resultString) + 1 ;
    		
    		sql = new StringBuilder()
    				.append("SELECT\n")
    				.append("	order_no,\n")
    				.append("	lotno,\n")
    				.append("	ipgo_no,\n")
    				.append("	io_seqno,\n")
    				.append("	io_date,\n")
    				.append("	io_time,\n")
    				.append("	io_user_id,\n")
    				.append("	A.part_cd,\n")
    				.append("	B.part_nm,\n")
    				.append("	part_cd_rev,\n")
    				.append("	store_no,\n")
    				.append("	rakes,\n")
    				.append("	plate,\n")
    				.append("	colm,\n")
    				.append("	pre_stack,\n")
    				.append("	io_count,\n")
    				.append("	post_stack,\n")
    				.append("	gubun,\n")
    				.append("	bigo\n")
    				.append("FROM tbi_part_ipgo A\n")
    				.append("INNER JOIN tbm_part_list B\n")
    				.append("	ON A.part_cd = B.part_cd\n")
    				.append("	AND A.part_cd_rev = B.revision_no\n")
    				.append("	AND A.member_key = B.member_key\n")
    				.append("WHERE A.part_cd = '" + jArray.get("part_cd") + "'\n")
    				.append("	AND A.part_cd_rev = '" + jArray.get("part_cd_rev") + "'\n")
    				.append(" 	AND A.member_key = '" + jArray.get("member_key") + "' \n") //member_key_select, update, delete
    				.append("ORDER BY io_seqno DESC, io_date DESC, io_time DESC\n")
    				.append("LIMIT 1 \n")
    				.toString();
    		String[] reultStingArray = excuteQueryString(con, sql.toString()).split("\t");
    		String io_date = reultStingArray[4];
    		String ipgo_amt = reultStingArray[15];
    		String store_amt = reultStingArray[16];
    		
    		// 입고 insert
			sql = new StringBuilder()
				.append("INSERT INTO \n")
				.append("	haccp_cleaner_mgr_list ( \n")
				.append("		cleaner_reg_no,\n")
				.append("		cleaner_reg_rev,\n")
				.append("		cleaner_reg_date,\n")
				.append("		part_cd,\n")
				.append("		part_cd_rev,\n")
				.append("		cleaner_usage,\n")
				.append("		ipgo_amt,\n")
				.append("		usage_amt,\n")
				.append("		store_amt,\n")
				.append("		write_dept,\n")
				.append("		writor_main,\n")
				.append("		writor_main_rev,\n")
				.append("		approval,\n")
				.append("		approval_date,\n")
				.append("		bigo\n")
				.append(" 		,member_key	\n") // member_key_insert
				.append("	) VALUES ( \n")
				.append(" 		'"	+ cleaner_reg_no + "',	\n")
				.append(" 		'"	+ jArray.get("cleaner_reg_rev") + "',	\n") // 0
				.append(" 		'"	+ io_date + "',	\n")
				.append(" 		'"	+ jArray.get("part_cd") + "',	\n")
				.append(" 		'"	+ jArray.get("part_cd_rev") + "',	\n")
				.append(" 		'"	+ "-" + "',	\n")
				.append(" 		'"	+ ipgo_amt + "',	\n")
				.append(" 		'"	+ 0 + "',	\n")
				.append(" 		'"	+ store_amt + "',	\n")
				.append(" 		'"	+ jArray.get("write_dept") + "',	\n")
				.append(" 		'"	+ jArray.get("writor_main") + "',	\n")
				.append(" 		'"	+ jArray.get("writor_main_rev") + "',	\n")
				.append(" 		'"	+ jArray.get("approval") + "',	\n")
				.append(" 		'"	+ jArray.get("approval_date") + "',	\n")
				.append(" 		'"	+ "입고" + "'	\n")
				.append(" 		,'" + jArray.get("member_key") + "' \n") //member_key_values
				.append("	) \n")
				.toString();
			resultInt = super.excuteUpdate(con, sql.toString());
	    	if(resultInt < 0){  //
				ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
				con.rollback();
				return EventDefine.E_DOEXCUTE_ERROR ;
			}
	    	
	    	// 사용 insert
	    	sql = new StringBuilder()
				.append("INSERT INTO \n")
				.append("	haccp_cleaner_mgr_list ( \n")
				.append("		cleaner_reg_no,\n")
				.append("		cleaner_reg_rev,\n")
				.append("		cleaner_reg_date,\n")
				.append("		part_cd,\n")
				.append("		part_cd_rev,\n")
				.append("		cleaner_usage,\n")
				.append("		ipgo_amt,\n")
				.append("		usage_amt,\n")
				.append("		store_amt,\n")
				.append("		write_dept,\n")
				.append("		writor_main,\n")
				.append("		writor_main_rev,\n")
				.append("		approval,\n")
				.append("		approval_date,\n")
				.append("		bigo\n")
				.append(" 		,member_key	\n") // member_key_insert
				.append("	) VALUES ( \n")
				.append(" 		'"	+ (cleaner_reg_no + 1) + "',	\n")
				.append(" 		'"	+ jArray.get("cleaner_reg_rev") + "',	\n")
				.append(" 		'"	+ jArray.get("cleaner_reg_date") + "',	\n")
				.append(" 		'"	+ jArray.get("part_cd") + "',	\n")
				.append(" 		'"	+ jArray.get("part_cd_rev") + "',	\n")
				.append(" 		'"	+ jArray.get("cleaner_usage") + "',	\n")
				.append(" 		'"	+ 0 + "',	\n")
				.append(" 		'"	+ jArray.get("usage_amt") + "',	\n")
				.append(" 		'"	+ (Integer.parseInt(store_amt) - Integer.parseInt(jArray.get("usage_amt").toString())) + "',	\n")
				.append(" 		'"	+ jArray.get("write_dept") + "',	\n")
				.append(" 		'"	+ jArray.get("writor_main") + "',	\n")
				.append(" 		'"	+ jArray.get("writor_main_rev") + "',	\n")
				.append(" 		'"	+ jArray.get("approval") + "',	\n")
				.append(" 		'"	+ jArray.get("approval_date") + "',	\n")
				.append(" 		'"	+ jArray.get("bigo") + "'	\n")
				.append(" 		,'" + jArray.get("member_key") + "' \n") //member_key_values
				.append("	) \n")
				.toString();
			resultInt = super.excuteUpdate(con, sql.toString());
	    	if(resultInt < 0){  //
				ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
				con.rollback();
				return EventDefine.E_DOEXCUTE_ERROR ;
			}
	    	
			con.commit();
		} catch(Exception e) {
			e.getStackTrace();
			LoggingWriter.setLogError("M838S050500E101()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
				}
	    	} else {
	    	}
	    }
		ioParam.setResultString(resultString);
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
    	ioParam.setMessage(MessageDefine.M_QUERY_OK);
	    return EventDefine.E_QUERY_RESULT;
	}	
	
	// S838S050502.jsp 수정화면
	public int E102(InoutParameter ioParam){ 
		resultInt = EventDefine.E_DOEXCUTE_INIT;

		try {
			con = JDBCConnectionPool.getConnection();
			con.setAutoCommit(false);
			
			// insert_update_delete_json.jsp에서 받아온 JSON데이터 처리
    		JSONObject jArray = new JSONObject();
    		jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
    		System.out.println("JSONObject jArray rcvData="+ jArray.toString());
    		// Object데이터에서 키값(param)으로 JSONArray데이터를 꺼낸다. (데이터묶음 하나일땐 생략)

    		int cleaner_reg_no = Integer.parseInt(jArray.get("cleaner_reg_no").toString()) ;
    		
    		String sql = new StringBuilder()
    				.append("SELECT\n")
    				.append("	order_no,\n")
    				.append("	lotno,\n")
    				.append("	ipgo_no,\n")
    				.append("	io_seqno,\n")
    				.append("	io_date,\n")
    				.append("	io_time,\n")
    				.append("	io_user_id,\n")
    				.append("	A.part_cd,\n")
    				.append("	B.part_nm,\n")
    				.append("	part_cd_rev,\n")
    				.append("	store_no,\n")
    				.append("	rakes,\n")
    				.append("	plate,\n")
    				.append("	colm,\n")
    				.append("	pre_stack,\n")
    				.append("	io_count,\n")
    				.append("	post_stack,\n")
    				.append("	gubun,\n")
    				.append("	bigo\n")
    				.append("FROM tbi_part_ipgo A\n")
    				.append("INNER JOIN tbm_part_list B\n")
    				.append("	ON A.part_cd = B.part_cd\n")
    				.append("	AND A.part_cd_rev = B.revision_no\n")
    				.append("	AND A.member_key = B.member_key\n")
    				.append("WHERE A.part_cd = '" + jArray.get("part_cd") + "'\n")
    				.append("	AND A.part_cd_rev = '" + jArray.get("part_cd_rev") + "'\n")
    				.append(" 	AND A.member_key = '" + jArray.get("member_key") + "' \n") //member_key_select, update, delete
    				.append("ORDER BY io_seqno DESC, io_date DESC, io_time DESC\n")
    				.append("LIMIT 1 \n")
    				.toString();
    		String[] reultStingArray = excuteQueryString(con, sql.toString()).split("\t");
    		String io_date = reultStingArray[4];
    		String ipgo_amt = reultStingArray[15];
    		String store_amt = reultStingArray[16];
    		
    		// 입고 update
			sql = new StringBuilder()
				.append("UPDATE haccp_cleaner_mgr_list \n")
				.append("SET \n")
				.append("	cleaner_reg_no='"	+ (cleaner_reg_no-1) +"',\n")
				.append("	cleaner_reg_rev='"	+ jArray.get("cleaner_reg_rev") +"',\n")
				.append("	cleaner_reg_date='"	+ io_date +"',\n")
				.append("	part_cd='"		+ jArray.get("part_cd") +"',\n")
				.append("	part_cd_rev='"	+ jArray.get("part_cd_rev") +"',\n")
				.append("	cleaner_usage='"+ "-" + "',\n")
				.append("	ipgo_amt='"		+ ipgo_amt + "',\n")
				.append("	usage_amt='"	+ "0" + "',\n")
				.append("	store_amt='" 	+ store_amt + "',\n")
				.append("	write_dept='" 	+ jArray.get("write_dept") + "',\n")
				.append("	writor_main='" 	+ jArray.get("writor_main") + "',\n")
				.append("	writor_main_rev='" 	+ jArray.get("writor_main_rev") + "',\n")
				.append("	approval='" 		+ jArray.get("approval") + "',\n")
				.append("	approval_date='" 	+ jArray.get("approval_date") + "',\n")
				.append("	bigo='" 		+ "입고" + "',\n")
				.append(" 	member_key='" 	+ jArray.get("member_key") + "'	\n")
				.append("WHERE cleaner_reg_no = '" 	 + (cleaner_reg_no-1) + "'\n")
				.append(" 	AND cleaner_reg_rev = '" + jArray.get("cleaner_reg_rev") + "' \n")
				.append(" 	AND member_key = '" 	 + jArray.get("member_key") + "' \n")
				.toString();
			resultInt = super.excuteUpdate(con, sql.toString());
	    	if(resultInt < 0){  //
				ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
				con.rollback();
				return EventDefine.E_DOEXCUTE_ERROR ;
			}
	    	
	    	// 사용 update
	    	sql = new StringBuilder()
					.append("UPDATE haccp_cleaner_mgr_list \n")
					.append("SET \n")
					.append("	cleaner_reg_no='"	+ cleaner_reg_no +"',\n")
					.append("	cleaner_reg_rev='"	+ jArray.get("cleaner_reg_rev") +"',\n")
					.append("	cleaner_reg_date='"	+ jArray.get("cleaner_reg_date") +"',\n")
					.append("	part_cd='"		+ jArray.get("part_cd") +"',\n")
					.append("	part_cd_rev='"	+ jArray.get("part_cd_rev") +"',\n")
					.append("	cleaner_usage='"+ jArray.get("cleaner_usage") + "',\n")
					.append("	ipgo_amt='"		+ "0" + "',\n")
					.append("	usage_amt='"	+ jArray.get("usage_amt") + "',\n")
					.append("	store_amt='" 	+ (Integer.parseInt(store_amt) - Integer.parseInt(jArray.get("usage_amt").toString())) + "',\n")
					.append("	write_dept='" 	+ jArray.get("write_dept") + "',\n")
					.append("	writor_main='" 	+ jArray.get("writor_main") + "',\n")
					.append("	writor_main_rev='" 	+ jArray.get("writor_main_rev") + "',\n")
					.append("	approval='" 		+ jArray.get("approval") + "',\n")
					.append("	approval_date='" 	+ jArray.get("approval_date") + "',\n")
					.append("	bigo='" 		+ jArray.get("bigo") + "',\n")
					.append(" 	member_key='" 	+ jArray.get("member_key") + "'	\n")
					.append("WHERE cleaner_reg_no = '" 	 + cleaner_reg_no + "'\n")
					.append(" 	AND cleaner_reg_rev = '" + jArray.get("cleaner_reg_rev") + "' \n")
					.append(" 	AND member_key = '" 	 + jArray.get("member_key") + "' \n")
					.toString();
			resultInt = super.excuteUpdate(con, sql.toString());
	    	if(resultInt < 0){  //
				ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
				con.rollback();
				return EventDefine.E_DOEXCUTE_ERROR ;
			}
	    	
			con.commit();
		} catch(Exception e) {
			e.getStackTrace();
			LoggingWriter.setLogError("M838S050500E102()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
				}
	    	} else {
	    	}
	    }
		ioParam.setResultString(resultString);
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
    	ioParam.setMessage(MessageDefine.M_QUERY_OK);
	    return EventDefine.E_QUERY_RESULT;
	}
	
	// S838S050503.jsp 삭제화면
	public int E103(InoutParameter ioParam){ 
		resultInt = EventDefine.E_DOEXCUTE_INIT;

		try {
			con = JDBCConnectionPool.getConnection();
			con.setAutoCommit(false);
			
			// insert_update_delete_json.jsp에서 받아온 JSON데이터 처리
    		JSONObject jArray = new JSONObject();
    		jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
    		System.out.println("JSONObject jArray rcvData="+ jArray.toString());
    		// Object데이터에서 키값(param)으로 JSONArray데이터를 꺼낸다. (데이터묶음 하나일땐 생략)

    		int cleaner_reg_no = Integer.parseInt(jArray.get("cleaner_reg_no").toString()) ;
    		
    		// 입고 delete
			String sql = new StringBuilder()
				.append("DELETE FROM haccp_cleaner_mgr_list \n")
				.append("WHERE cleaner_reg_no = '" 	 + (cleaner_reg_no-1) + "'\n")
				.append(" 	AND cleaner_reg_rev = '" + jArray.get("cleaner_reg_rev") + "' \n")
				.append(" 	AND member_key = '" 	 + jArray.get("member_key") + "' \n")
				.toString();
			resultInt = super.excuteUpdate(con, sql.toString());
	    	if(resultInt < 0){  //
				ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
				con.rollback();
				return EventDefine.E_DOEXCUTE_ERROR ;
			}
	    	
	    	// 사용 delete
	    	sql = new StringBuilder()
					.append("DELETE FROM haccp_cleaner_mgr_list \n")
					.append("WHERE cleaner_reg_no = '" 	 + cleaner_reg_no + "'\n")
					.append(" 	AND cleaner_reg_rev = '" + jArray.get("cleaner_reg_rev") + "' \n")
					.append(" 	AND member_key = '" 	 + jArray.get("member_key") + "' \n")
					.toString();
			resultInt = super.excuteUpdate(con, sql.toString());
	    	if(resultInt < 0){  //
				ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
				con.rollback();
				return EventDefine.E_DOEXCUTE_ERROR ;
			}
	    	
			con.commit();
		} catch(Exception e) {
			e.getStackTrace();
			LoggingWriter.setLogError("M838S050500E103()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
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