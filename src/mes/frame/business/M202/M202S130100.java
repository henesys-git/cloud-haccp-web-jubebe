package mes.frame.business.M202;

/*BOM코드*/
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
import mes.frame.database.JDBCConnectionPool;
import mes.frame.database.SqlAdapter;
import mes.frame.serviceinterface.InoutParameter;
import mes.frame.serviceinterface.LoggingWriter;
import mes.frame.util.CommonFunction;

/**
 * 개요 : 이벤트ID별 메소드 정의
 */
public class M202S130100 extends SqlAdapter {
	Connection con = null;
	PreparedStatement pstmt = null;
	String resultString = "";
	int resultInt = -1;
	StringBuffer sql = new StringBuffer();

	String[][] v_paramArray = new String[0][0];
	Class[] optClass = null;
	Object[] optObj = null;
	Object obj = null;

	public M202S130100() {
	}

	/**
	 * 사용자가 정의해서 파라메터 검증하는 method.
	 * 
	 * @param ioParam , p_sql
	 * @return the desired integer.
	 */
	public int custParamCheck(InoutParameter ioParam, StringBuffer p_sql) {
		int paramInt = 0;
		return paramInt;
	}

	/**
	 * 입력파라메타가 2차원 구조인경우 파라메터 검증하는 method.
	 * 
	 * @param ioParam , p_sql
	 * @return the desired integer.
	 */
	public int paramCheck(InoutParameter ioParam, StringBuffer p_sql) {
		v_paramArray = super.getParamCheck(ioParam, p_sql);
		return v_paramArray[0].length;
	}

	/**
	 * 입력파라메타에서 이벤트ID별로 메소드 호출하는 method.
	 * 
	 * @param ioParam
	 * @return the desired integer.
	 */
	public int doExcute(InoutParameter ioParam) {
		long startTime = System.currentTimeMillis();
		int doExcute_result = EventDefine.E_DOEXCUTE_INIT;
		;
		String event = ioParam.getEventSubID();

		try {
			optClass = new Class[1];
			optClass[0] = ioParam.getClass();
			optObj = new Object[1];
			optObj[0] = ioParam;

			Method method = M202S130100.class.getMethod(event, optClass);
			LoggingWriter.setLogDebug(M202S130100.class.getName(),
					"==== " + event + " EventMethod Create Success ====");

			obj = method.invoke(M202S130100.class.newInstance(), optObj);
			doExcute_result = CommonFunction.getInt(obj.toString());

		} catch (Exception ex) {
			doExcute_result = EventDefine.E_DOEXCUTE_INIT;
			ioParam.setMessage(MessageDefine.M_NO_EVENTID);
			LoggingWriter.setLogError(M202S130100.class.getName(),
					"==== EventID Not define : EVENT ID [ " + ioParam.getEventID() + "]");
		} finally {
			obj = null;
			optClass = null;
			optObj = null;
		}
		long endTime = System.currentTimeMillis();
		long runningTime = endTime - startTime;
		LoggingWriter.setLogAll(M202S130100.class.getName(), "==== Query [수행시간  : " + runningTime + " ms]");

		return doExcute_result;
	}

	public int E104(InoutParameter ioParam) {
		resultInt = EventDefine.E_DOEXCUTE_INIT;

		try {
			con = JDBCConnectionPool.getConnection();

			JSONObject jArray = new JSONObject();
			jArray = (JSONObject) ((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			System.out.println("JSONObject jArray rcvData=" + jArray.toString());

			String sql = new StringBuilder().append("SELECT DISTINCT\n")
					.append("	C.cust_nm,  		--고객사\n")
					.append("	B.product_nm,  		--제품명\n")
					.append("	cust_pono,			--PO번호\n")
					.append("	product_gubun,		--제품구분\n")
					.append("	part_source,   		--원부자재공급\n")
					.append("	order_date,      	--주문일\n")
					.append("	A.lotno,           	--lot번호\n")
					.append("	lot_count,    		--lot수량\n")
					.append("	part_chulgo_date,	--회로자재출고일\n")
					.append("	rohs,				--rohs\n")
					.append("	order_note,			--특이사항\n")
					.append("	delivery_date,   	--납기일\n")
					.append("	bom_version,		\n")
					.append("	A.order_no,    		--주문번호\n")
					.append("	'', 				\n") 
					// .append("							// --현상태명\n")
					.append("	A.bigo,         	--비고\n")
					.append("	product_serial_no, 		--일련번호\n")
					.append("	product_serial_no_end, 	--일련번호끝  \n")
					.append("	A.cust_cd,\n")
					.append("	A.cust_rev,\n")
					.append("	A.prod_cd,\n")
					.append("	A.prod_rev,\n")
					.append("	Q.order_status,\n")
					.append("	DECODE(product_gubun,'0','양산품','1','개발품') AS product_gubun,	--제품구분\n")
					.append("	DECODE(part_source,'01','사급','02','도급') AS part_source,   		--원부자재공급\n")
					.append("	DECODE(rohs,'0','Pb Free','1','Pb') AS rohs					--rohs\n")
					.append("FROM\n")
					.append("   tbi_order A\n")
					.append("INNER JOIN tbm_customer C\n")
					.append("        ON A.cust_cd = C.cust_cd\n")
					.append("        and A.cust_rev = C.revision_no\n")
					.append("  		 AND A.member_key = C.member_key\n")
					.append("INNER JOIN tbi_queue Q\n")
					.append("        ON A.order_no = Q.order_no\n")
					.append("        AND A.lotno = Q.lotno\n")
					.append("   	 AND A.member_key = Q.member_key\n")
//					.append("INNER JOIN tbm_systemcode S\n")
//					.append("        ON Q.order_status = S.status_code\n")
//					.append("        AND Q.process_gubun = S.process_gubun\n")
					.append("INNER JOIN tbm_product B\n")
					.append("        ON A.prod_cd = B.prod_cd\n")
					.append("        and  A.prod_rev = B.revision_no\n")
					.append("   	 AND A.member_key = B.member_key\n")
					.append("WHERE A.cust_cd LIKE '%" + jArray.get("custcode") + "'	\n")
//					.append("AND S.class_id = '" 		+ c_paramArray[0][3] + "' 	\n")
					.append("AND Q.order_status = 'COMPLETE'\n")
					.append("AND order_date \n")
					.append("BETWEEN '" + jArray.get("fromdate") + "' 	\n")
					.append("	 AND '" + jArray.get("todate") + "'	\n")
					.append("	AND A.member_key = '" + jArray.get("member_key") + "'\n")
					.toString();
			String ActionCommand = ioParam.getActionCommand();
			if (ActionCommand.startsWith("doQueryTableFieldName")) {
				resultString = super.excuteQueryStringTableFieldName(con, sql.toString());
			} else {
				;
				resultString = super.excuteQueryString(con, sql.toString());
			}
		} catch (Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M202S130100E104()", "==== SQL ERROR ====" + e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR;
		} finally {
			if (Config.useDataSource) {
				try {
					if (con != null)
						con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M202S130100E104()", "==== finally ====" + e.getMessage());
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

	public int E101(InoutParameter ioParam) {
		resultInt = EventDefine.E_DOEXCUTE_INIT;

		ApprovalActionNo ActionNo;
		String AS_NO = "";

		try {
			con = JDBCConnectionPool.getConnection();

			JSONObject jArray = new JSONObject();
			jArray = (JSONObject) ((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			System.out.println("JSONObject jArray rcvData=" + jArray.toString());

//			String[][] c_paramArray_Head=null;
//			String[][] c_paramArray_Detail=null;

//			String rcvData = (String)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
//			Vector resultVector = CommonFunction.getConvStringDamogjuk(rcvData);
			con.setAutoCommit(false);

//			c_paramArray_Head = (String[][])resultVector.get(0);//head table
//    		c_paramArray_Detail=(String[][])resultVector.get(1); //data table

			String jspPage = (String) jArray.get("jsppage");
			String user_id = (String) jArray.get("user_id");
			String prefix = (String) jArray.get("prefix");
			String actionGubun = "Regist";
			String detail_seq = (String) jArray.get("order_detail_seq");
			String member_key = (String) jArray.get("member_key");
			ActionNo = new ApprovalActionNo();
			AS_NO = ActionNo.getActionNo(con, jspPage, user_id, prefix, actionGubun, detail_seq,member_key);// GV_JSPPAGE(action
																									// Page), User ID,
																									// prefix

			String sql = new StringBuilder()
					.append("INSERT INTO tbi_as_request (\n")
					.append("		as_request_no,\n")
					.append("		revision_no,\n")
					.append("		order_no,\n")
					.append("		lotno,\n")
					.append("		reg_date,\n")
					.append("		reg_user_id,\n")
					.append("		req_channel,\n")
					.append("		req_man_name,\n")
					.append("		work_hope_date,\n")
					.append("		as_status_cd,\n")
					.append("		as_count,\n")
					.append("		recept_date,\n")
					.append("		req_contents,\n")
					.append("		product_cd,\n")
					.append("		product_nm,\n")
					.append("		cust_cd,\n")
					.append("		member_key\n")
					.append("	)\n")
					.append("VALUES (\n")
					.append("		'" + AS_NO + "',\n")
					.append("		'" + jArray.get("RevisionNo") + "',\n")
					.append("		'" + jArray.get("order_no") + "',\n")
					.append("		'" + jArray.get("lotno") + "',\n")
					.append("		'" + jArray.get("req_date") + "',\n")
					.append("		'" + jArray.get("req_user") + "',\n")
					.append("		'" + jArray.get("req_channel") + "',\n")
					.append("		'" + jArray.get("man") + "',\n")
					.append("		'" + jArray.get("work_date") + "',\n")
					.append("		'" + jArray.get("as_cd") + "',\n")
					.append("		'" + jArray.get("as_count") + "',\n")
					.append("		'" + jArray.get("recept_date") + "',\n")
					.append("		'" + jArray.get("req_contents") + "',\n")
					.append("		'" + jArray.get("product_cd") + "',\n")
					.append("		'" + jArray.get("product_nm") + "',\n")
					.append("		'" + jArray.get("cust_nm") + "',\n")
					.append("		'" + jArray.get("member_key") + "')\n")
					.toString();

			// System.out.println(sql.toString());
			resultInt = super.excuteUpdate(con, sql.toString());
			if (resultInt < 0) { //
				ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
				con.rollback();
				return EventDefine.E_DOEXCUTE_ERROR;
			}
			con.commit();
		} catch (Exception e) {
			LoggingWriter.setLogError("M202S130100E101()", "==== SQL ERROR ====" + e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR;
		} finally {
			if (Config.useDataSource) {
				try {
					if (con != null)
						con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M202S130100E101()", "==== finally ====" + e.getMessage());
				}
			} else {
			}
		}
		ioParam.setResultString(resultString);
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
		ioParam.setMessage(MessageDefine.M_QUERY_OK);
		return EventDefine.E_QUERY_RESULT;
	}

	public int E102(InoutParameter ioParam) {
		resultInt = EventDefine.E_DOEXCUTE_INIT;

		ApprovalActionNo ActionNo;
		String AS_NO = "";

		try {
			con = JDBCConnectionPool.getConnection();

			JSONObject jArray = new JSONObject();
			jArray = (JSONObject) ((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			System.out.println("JSONObject jArray rcvData=" + jArray.toString());

//			String[][] c_paramArray_Head=null;
//			String[][] c_paramArray_Detail=null;
//			
//			String rcvData = (String)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
//			Vector resultVector = CommonFunction.getConvStringDamogjuk(rcvData);
			con.setAutoCommit(false);

//			c_paramArray_Head = (String[][])resultVector.get(0);//head table
//    		c_paramArray_Detail=(String[][])resultVector.get(1); //data table

			String sql = new StringBuilder()
					.append("UPDATE tbi_as_request\n")
					.append("SET\n")
					.append("	as_request_no = '" + jArray.get("as_no") + "',\n")
					.append("	revision_no = '" + jArray.get("RevisionNo") + "',\n")
					.append("	order_no = '" + jArray.get("order_no") + "',\n")
					.append("	lotno = '" + jArray.get("lotno") + "',\n")
					.append("	reg_date = '" + jArray.get("req_date") + "',\n")
					.append("	reg_user_id = '" + jArray.get("req_user") + "',\n")
					.append("	req_channel = '" + jArray.get("req_channel") + "',\n")
					.append("	req_man_name = '" + jArray.get("man") + "',\n")
					.append("	work_hope_date = '" + jArray.get("work_date") + "',\n")
					.append("	as_status_cd = '" + jArray.get("as_cd") + "',\n")
					.append("	as_count = '" + jArray.get("as_count") + "',\n")
					.append("	recept_date = '" + jArray.get("recept_date") + "',\n")
					.append("	req_contents = '" + jArray.get("req_contents") + "',\n")
					.append("	product_cd = '" + jArray.get("product_cd") + "',\n")
					.append("	product_nm = '" + jArray.get("product_nm") + "',\n")
					.append("	cust_cd = '" + jArray.get("cust_nm") + "'\n")
					.append("WHERE as_request_no = '" + jArray.get("as_no") + "'\n")
					.append("	AND revision_no = '" + jArray.get("RevisionNo") + "'\n")
					.append("	AND order_no = '" + jArray.get("order_no") + "'\n")
					.append("	AND lotno = '" + jArray.get("lotno") + "'\n")
					.append("	AND member_key = '" + jArray.get("member_key") + "'\n")
					.toString();
			// System.out.println(sql.toString());
			resultInt = super.excuteUpdate(con, sql.toString());
			if (resultInt < 0) { //
				ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
				con.rollback();
				return EventDefine.E_DOEXCUTE_ERROR;
			}
			con.commit();
		} catch (Exception e) {
			LoggingWriter.setLogError("M202S130100E102()", "==== SQL ERROR ====" + e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR;
		} finally {
			if (Config.useDataSource) {
				try {
					if (con != null)
						con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M202S130100E102()", "==== finally ====" + e.getMessage());
				}
			} else {
			}
		}
		ioParam.setResultString(resultString);
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
		ioParam.setMessage(MessageDefine.M_QUERY_OK);
		return EventDefine.E_QUERY_RESULT;
	}

	public int E103(InoutParameter ioParam) {
		resultInt = EventDefine.E_DOEXCUTE_INIT;

		ApprovalActionNo ActionNo;
		String AS_NO = "";

		try {
			con = JDBCConnectionPool.getConnection();

			JSONObject jArray = new JSONObject();
			jArray = (JSONObject) ((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			System.out.println("JSONObject jArray rcvData=" + jArray.toString());

//			String[][] c_paramArray_Head=null;
//			String[][] c_paramArray_Detail=null;
//			
//			String rcvData = (String)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
//			Vector resultVector = CommonFunction.getConvStringDamogjuk(rcvData);
			con.setAutoCommit(false);

//			c_paramArray_Head = (String[][])resultVector.get(0);//head table
//    		c_paramArray_Detail=(String[][])resultVector.get(1); //data table

			String sql = new StringBuilder()

					.append("DELETE FROM tbi_as_request\n")
					.append("WHERE as_request_no = '" + jArray.get("as_no") + "'\n")
					.append("	AND revision_no = '" + jArray.get("RevisionNo") + "'\n")
					.append("	AND order_no = '" + jArray.get("order_no") + "'\n")
					.append("	AND lotno = '" + jArray.get("lotno") + "'\n")
					.append("	AND member_key = '" + jArray.get("member_key") + "'\n")
					.toString();

			// System.out.println(sql.toString());
			resultInt = super.excuteUpdate(con, sql.toString());
			if (resultInt < 0) { //
				ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
				con.rollback();
				return EventDefine.E_DOEXCUTE_ERROR;
			}
			con.commit();
		} catch (Exception e) {
			LoggingWriter.setLogError("M202S130100E103()", "==== SQL ERROR ====" + e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR;
		} finally {
			if (Config.useDataSource) {
				try {
					if (con != null)
						con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M202S130100E103()", "==== finally ====" + e.getMessage());
				}
			} else {
			}
		}
		ioParam.setResultString(resultString);
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
		ioParam.setMessage(MessageDefine.M_QUERY_OK);
		return EventDefine.E_QUERY_RESULT;
	}

	public int E114(InoutParameter ioParam) {
		resultInt = EventDefine.E_DOEXCUTE_INIT;

		try {
			con = JDBCConnectionPool.getConnection();

			JSONObject jArray = new JSONObject();
			jArray = (JSONObject) ((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			System.out.println("JSONObject jArray rcvData=" + jArray.toString());

			// 클라이언트로 부터 받은 파라미터를 옮겨 담는다.
//			String rcvData = (String)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			// 클라이언트로 부터 받은 파라미터를 쪼개어서 배열에 담는다.
			// rcvData = [위경도]
//			String[][] c_paramArray = CommonFunction.getConvString2DoubleArray(rcvData);

			String sql = new StringBuilder()
					.append("SELECT\n")
					.append("	as_request_no,\n")
					.append("	order_no,\n")
					.append("	revision_no,\n")
					.append("TO_CHAR(reg_date,'YYYY-MM-DD') AS reg_date,\n")
					.append("	reg_user_id,\n")
					.append("	req_channel,\n")
					.append("	req_man_name,\n")
					.append("	work_hope_date,\n")
					.append("	as_status_cd,\n")
					.append("	as_count,\n")
					.append("	recept_date,\n")
					.append("	req_contents,\n")
					.append("	product_cd,\n")
					.append("	product_nm,\n")
					.append("	cust_cd,\n")
					.append("	lotno\n")
					.append("FROM tbi_as_request\n")
					.append("WHERE order_no='" + jArray.get("ORDERNO") + "'\n")
					.append("AND lotno = '" + jArray.get("LOTNO") + "'\n")
					.append("AND member_key = '" + jArray.get("member_key") + "'\n")
					.toString();
					
			String ActionCommand = ioParam.getActionCommand();
			if (ActionCommand.startsWith("doQueryTableFieldName")) {
				resultString = super.excuteQueryStringTableFieldName(con, sql.toString());
			} else {
				resultString = super.excuteQueryString(con, sql.toString());
			}
		} catch (Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M202S130100E114()", "==== SQL ERROR ====" + e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR;
		} finally {
			if (Config.useDataSource) {
				try {
					if (con != null)
						con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M202S130100E114()", "==== finally ====" + e.getMessage());
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

	public int E124(InoutParameter ioParam) {
		resultInt = EventDefine.E_DOEXCUTE_INIT;

		try {
			con = JDBCConnectionPool.getConnection();

			JSONObject jArray = new JSONObject();
			jArray = (JSONObject) ((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			System.out.println("JSONObject jArray rcvData=" + jArray.toString());

			// 클라이언트로 부터 받은 파라미터를 옮겨 담는다.
//			String rcvData = (String)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			// 클라이언트로 부터 받은 파라미터를 쪼개어서 배열에 담는다.
			// rcvData = [위경도]
//			String[][] c_paramArray = CommonFunction.getConvString2DoubleArray(rcvData);
			String sql = new StringBuilder()
					.append("SELECT \n")
					.append("B.product_nm,\n")
					.append("C.cust_nm\n")
					.append("FROM tbi_order A\n")
					.append("INNER JOIN tbm_product B\n")
					.append("	ON A.prod_cd = B.prod_cd\n")
					.append("	AND A.prod_rev = B.revision_no\n")
					.append("   AND A.member_key = B.member_key\n")
					.append("INNER JOIN tbm_customer C\n")
					.append("	ON A.cust_cd = C.cust_cd\n")
					.append("	AND A.cust_rev = C.revision_no\n")
					.append("   AND A.member_key = C.member_key\n")
					.append("WHERE order_no = '" + jArray.get("ORDERNO") + "'\n")
					.append("	AND lotno = '" + jArray.get("LOTNO") + "'\n")
					.append("	AND B.prod_cd ='" + jArray.get("PRODUCTNO") + "'\n")
					.append("	AND A.member_key = '" + jArray.get("member_key") + "'\n")
					.toString();

			String ActionCommand = ioParam.getActionCommand();
			if (ActionCommand.startsWith("doQueryTableFieldName")) {
				resultString = super.excuteQueryStringTableFieldName(con, sql.toString());
			} else {
				;
				resultString = super.excuteQueryString(con, sql.toString());
			}
		} catch (Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M202S130100E124()", "==== SQL ERROR ====" + e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR;
		} finally {
			if (Config.useDataSource) {
				try {
					if (con != null)
						con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M202S130100E124()", "==== finally ====" + e.getMessage());
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

	public int E134(InoutParameter ioParam) {
		resultInt = EventDefine.E_DOEXCUTE_INIT;

		try {
			con = JDBCConnectionPool.getConnection();

			JSONObject jArray = new JSONObject();
			jArray = (JSONObject) ((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			System.out.println("JSONObject jArray rcvData=" + jArray.toString());

			// 클라이언트로 부터 받은 파라미터를 옮겨 담는다.
//		String rcvData = (String)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			// 클라이언트로 부터 받은 파라미터를 쪼개어서 배열에 담는다.
			// rcvData = [위경도]
//		String[][] c_paramArray = CommonFunction.getConvString2DoubleArray(rcvData);
			String sql = new StringBuilder()
					.append("SELECT\n")
					.append("	as_request_no,\n")
					.append("	revision_no,\n")
					.append("	order_no,\n")
					.append("	lotno,\n")
					.append("TO_CHAR(reg_date,'YYYY-MM-DD') AS reg_date,\n")
					.append("	reg_user_id,\n")
					.append("	req_channel,\n")
					.append("	req_man_name,\n")
					.append("	work_hope_date,\n")
					.append("	as_status_cd,\n")
					.append("	as_count,\n")
					.append("	recept_date,\n")
					.append("	req_contents,\n")
					.append("	product_cd,\n")
					.append("	product_nm,\n")
					.append("	cust_cd\n")
					.append("FROM tbi_as_request\n")
					.append("WHERE as_request_no = '" + jArray.get("ASNO") + "'\n")
					.append("	AND order_no = '" + jArray.get("ORDERNO") + "'\n")
					.append("	AND lotno = '" + jArray.get("LOTNO") + "'\n")
					.append("	AND member_key = '" + jArray.get("member_key") + "'\n")
					.toString();

			String ActionCommand = ioParam.getActionCommand();
			if (ActionCommand.startsWith("doQueryTableFieldName")) {
				resultString = super.excuteQueryStringTableFieldName(con, sql.toString());
			} else {
				;
				resultString = super.excuteQueryString(con, sql.toString());
			}
		} catch (Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M202S130100E134()", "==== SQL ERROR ====" + e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR;
		} finally {
			if (Config.useDataSource) {
				try {
					if (con != null)
						con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M202S130100E134()", "==== finally ====" + e.getMessage());
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

	public int E144(InoutParameter ioParam) {
		resultInt = EventDefine.E_DOEXCUTE_INIT;

		try {
			con = JDBCConnectionPool.getConnection();

			JSONObject jArray = new JSONObject();
			jArray = (JSONObject) ((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			System.out.println("JSONObject jArray rcvData=" + jArray.toString());

			// 클라이언트로 부터 받은 파라미터를 옮겨 담는다.
//		String rcvData = (String)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			// 클라이언트로 부터 받은 파라미터를 쪼개어서 배열에 담는다.
			// rcvData = [위경도]
//		String[][] c_paramArray = CommonFunction.getConvString2DoubleArray(rcvData);
			String sql = new StringBuilder()
					.append("SELECT\n")
					.append("	as_request_no,\n")
					.append("	revision_no,\n")
					.append("	order_no,\n")
					.append("	lotno,\n")
					.append("TO_CHAR(reg_date,'YYYY-MM-DD') AS reg_date,\n").append("	reg_user_id,\n")
					.append("	req_channel,\n")
					.append("	req_man_name,\n")
					.append("	work_hope_date,\n")
					.append("	as_status_cd,\n")
					.append("	as_count,\n")
					.append("	recept_date,\n")
					.append("	req_contents,\n")
					.append("	product_cd,\n")
					.append("	product_nm,\n")
					.append("	cust_cd\n")
					.append("FROM tbi_as_request\n")
					.append("WHERE as_request_no = '" + jArray.get("ASNO") + "'\n")
					.append("	AND order_no = '" + jArray.get("ORDERNO") + "'\n")
					.append("	AND lotno = '" + jArray.get("LOTNO") + "'\n")
					.append("	AND member_key = '" + jArray.get("member_key") + "'\n")
					.toString();

			String ActionCommand = ioParam.getActionCommand();
			if (ActionCommand.startsWith("doQueryTableFieldName")) {
				resultString = super.excuteQueryStringTableFieldName(con, sql.toString());
			} else {
				;
				resultString = super.excuteQueryString(con, sql.toString());
			}
		} catch (Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M202S130100E144()", "==== SQL ERROR ====" + e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR;
		} finally {
			if (Config.useDataSource) {
				try {
					if (con != null)
						con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M202S130100E144()", "==== finally ====" + e.getMessage());
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