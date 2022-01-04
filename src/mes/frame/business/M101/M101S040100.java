package mes.frame.business.M101;

import java.lang.reflect.Method;
import java.sql.Connection;
import java.sql.PreparedStatement;

import org.apache.log4j.Logger;
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

public class M101S040100 extends SqlAdapter {
	
	static final Logger logger = Logger.getLogger(M101S040100.class.getName());
	
	Connection con = null;
	PreparedStatement pstmt = null;
	String resultString = "";
	int resultInt = -1;
	StringBuffer sql = new StringBuffer();
	
	String[][] v_paramArray = new String[0][0]; 
	Class[] optClass = null;
	Object[] optObj = null;
	Object obj = null;
	
	public M101S040100() {
		// TODO Auto-generated constructor stub
	}

	@Override
	protected int custParamCheck(InoutParameter ioParam, StringBuffer p_sql) {
		// TODO Auto-generated method stub
		return 0;
	}

	@Override
	public int doExcute(InoutParameter ioParam){
		long startTime = System.currentTimeMillis();
		int doExcute_result = EventDefine.E_DOEXCUTE_INIT;;
		String event = ioParam.getEventSubID();
		
	    try{
            optClass = new Class[1];
			optClass[0] = ioParam.getClass() ;
			optObj = new Object[1];
			optObj[0] = ioParam;
			
			Method method = M101S040100.class.getMethod(event,optClass);
			logger.debug(event + " EventMethod Create Success");

			obj = method.invoke(M101S040100.class.newInstance(),optObj);
			doExcute_result = CommonFunction.getInt(obj.toString());
			
	    } catch (Exception ex) {
	    	doExcute_result = EventDefine.E_DOEXCUTE_INIT;
			ioParam.setMessage(MessageDefine.M_NO_EVENTID);
			logger.debug("EventID Not define : EVENT ID [ " + ioParam.getEventID() + "]");
	    } finally {
	    	obj = null;
			optClass = null;
			optObj = null;
	    }
	    long endTime = System.currentTimeMillis();
		long runningTime = endTime - startTime;
		logger.debug("Query [수행시간  : " + runningTime + " ms]");
		
		return doExcute_result;
	}


	//S101S040100.jsp
	public int E104(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			
			String sql = new StringBuilder()
					.append("WITH w_tbi_chulha_info AS(\n")
					.append("	SELECT DISTINCT \n")
					.append("		order_no,\n")
					.append("		lotno,\n")
					.append("		order_detail_seq,\n")
					.append("		SUM(NVL(chulha_cnt,0)) over(PARTITION BY order_no,lotno) AS chulha_cnt\n")
					.append("	FROM tbi_chulha_info\n")
					.append(")\n")
					.append("SELECT DISTINCT\n")
					.append("		C.cust_nm,\n")
					.append("		B.product_nm,\n")
					.append("		project_name,\n")
					.append("		A.lotno,\n")
					.append("		delivery_date,\n")
					.append("		cust_pono,\n")
					.append("		project_cnt,\n")
					.append("		order_count,\n")
					.append("		NVL(chulha_cnt,0),\n")
					.append("		(order_count - NVL(chulha_cnt,0) ) AS remin_cnt,\n")
					.append("		S.process_name,\n")
					.append("		A.bigo, \n")
					.append("		A.order_no,\n")
					.append("		'',\n")	// .append("        A.order_detail_seq,\n")
					.append("		order_date,\n")
					.append("		A.cust_cd,\n")
					.append("		A.cust_rev,\n")
					.append("		'',\n")	// .append("        A.product_serial_no,\n") 
					.append("		A.prod_cd,\n")
					.append("		lot_count,\n")
					.append("		Q.order_status\n")
					.append("FROM tbi_order A\n")
					.append("LEFT OUTER JOIN w_tbi_chulha_info h \n")
					.append("	ON A.order_no = h.order_no\n")
					.append("	AND A.lotno = h.lotno\n")
					.append("	AND A.member_key = h.member_key\n")
					.append("INNER JOIN tbm_customer C		\n")
					.append("	ON A.cust_cd = C.cust_cd		\n")
					.append("	AND A.cust_rev = C.revision_no \n")
					.append("	AND A.member_key = C.member_key\n")
					.append("INNER JOIN tbi_queue Q			\n")
					.append("	ON A.order_no = Q.order_no		\n")
					.append("	AND A.lotno = Q.lotno	\n")
					.append("	AND A.member_key = Q.member_key\n")
					.append("INNER JOIN tbm_systemcode S		\n")
					.append("	ON Q.order_status = S.status_code 	\n")
					.append("	AND  Q.member_key = S.member_key\n")
					.append("INNER JOIN tbm_product B			\n")
					.append("	ON A.prod_cd = B.prod_cd		\n")
					.append("	AND  A.prod_rev = B.revision_no\n")
					.append("	AND  A.member_key = B.member_key\n")
					.append("WHERE A.cust_cd LIKE '%" 	+ jArray.get("custcode") + "'	\n")
					.append("	AND S.class_id = '" + jArray.get("jsppage") + "' 	\n")
					.append("	AND order_date \n")
					.append("		BETWEEN '" + jArray.get("fromdate") + "' 	\n")
					.append("	AND '" + jArray.get("todate") + "'	\n")
					.append("	AND A.member_key = '" + jArray.get("member_key") + "' 	\n")
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
			LoggingWriter.setLogError("M101S040100E104()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M101S040100E104()","==== finally ===="+ e.getMessage());
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

	public int E114(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			
			String sql = new StringBuilder()
					.append("SELECT\n")
					.append("DISTINCT \n")
					.append("	order_no,\n")
					.append("	A.prod_cd,\n")
					.append("	B.product_nm,\n")
					.append("	order_detail_seq,\n")
					.append("	product_serial_no,\n")
					.append("	order_count,\n")
					.append("	lotno,\n")
					.append("	lot_count,\n")
					.append("	A.bigo\n")
					.append("FROM\n")
					.append("	tbi_order A \n")
					.append("INNER JOIN tbm_product B \n")
					.append("	ON A.prod_cd = B.prod_cd\n")
					.append("	and A.prod_rev = B.revision_no\n")
					.append("	and A.member_key = B.member_key\n")
					.append("WHERE A.order_no = '" + jArray.get("order_no") + "'\n")
//					.append("	AND A.order_detail_seq = '" + jArray.get("order_detail_seq") + "'\n")
					.append("	AND A.lotno = '" + jArray.get("lotno") + "'\n")
					.append("AND A.member_key = '" + jArray.get("member_key") + "' \n")
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
			LoggingWriter.setLogError("M101S040100E114()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M101S040100E114()","==== finally ===="+ e.getMessage());
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

	public int E124(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			
			String sql = new StringBuilder()
					.append("SELECT\n")
//					.append("	chulha_seq,\n")
					.append("	ROWNUM,	\n")
					.append("	C.product_serial_no,\n")	// .append("	C.prod_cd,	\n")
					.append("	P.product_nm,\n")
					.append("	chulha_unit,\n")
					.append("	chulha_cnt,\n")
					.append("	TO_CHAR (chulha_unit_price, '999,999,999,999'),\n")
					.append("	TO_CHAR (chulha_cnt * chulha_unit_price, '999,999,999,999') AS chulha_amount,\n")
//					.append("	'' AS bigo,\n")
					.append("	chulha_bigo,\n")
					.append("	chuha_dt,\n")
					.append("	O.cust_pono,\n")
					.append("	C.cust_cd,\n")
					.append("	CM.cust_nm,\n")
					.append("	CM.boss_name,\n")
					.append("	CM.address\n")
					.append("FROM tbi_chulha_info C\n")
					.append("INNER JOIN tbm_product P\n")
					.append("	ON C.prod_cd=P.prod_cd\n")
					.append("	AND C.prod_rev=P.revision_no\n")
					.append("	AND C.member_key=P.member_key\n")
					.append("INNER JOIN tbm_customer CM\n")
					.append("	ON C.cust_cd=CM.cust_cd\n")
					.append("	AND C.cust_rev=CM.revision_no\n")
					.append("	AND C.member_key=CM.member_key\n")
					.append("INNER JOIN tbi_order O\n")
					.append("	ON C.order_no=O.order_no\n")
//					.append("	AND C.order_detail_seq=O.order_detail_seq\n")
					.append("	AND C.lotno=O.lotno\n")
					.append("	AND C.prod_cd=O.prod_cd\n")
					.append("	AND C.prod_rev=O.prod_rev\n")
					.append("	AND C.product_serial_no=O.product_serial_no\n")
					.append("	AND C.member_key=O.member_key\n")
					.append("WHERE C.cust_cd ='" +  jArray.get("cust_cd") + "'\n")
					.append("AND C.chuha_dt ='" +  jArray.get("chuha_dt") + "'\n")
					.append("AND C.member_key = '" + jArray.get("member_key") + "' 	\n")
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
			LoggingWriter.setLogError("M101S040100E124()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M101S040100E124()","==== finally ===="+ e.getMessage());
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
	
	public int E125(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			
			String sql = new StringBuilder()
					.append("SELECT\n")
					.append("	bizno,\n")
					.append("	revision_no,\n")
					.append("	cust_nm,\n")
					.append("	address,\n")
					.append("	telno,\n")
					.append("	boss_name,\n")
					.append("	uptae,\n")
					.append("	jongmok,\n")
					.append("	faxno,\n")
					.append("	homepage,\n")
					.append("	zipno,\n")
					.append("	start_date,\n")
					.append("	create_date,\n")
					.append("	create_user_id,\n")
					.append("	modify_date,\n")
					.append("	modify_user_id,\n")
					.append("	modify_reason,\n")
					.append("	duration_date,\n")
					.append("	seal_img_filename,\n")
					.append("	history_yn\n")
					.append("FROM tbm_our_company_info\n")
					.append("WHERE\n")
					.append("	TO_CHAR(SYSDATE,'YYYY-MM-DD') BETWEEN start_date AND duration_date\n")
					.append("AND member_key = '" + jArray.get("member_key") + "' 	\n")
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
			LoggingWriter.setLogError("M101S040100E125()","==== SQL ERROR  ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M101S040100E125()","==== finally ===="+ e.getMessage());
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
			
			String sql = new StringBuilder()
					.append("SELECT\n")
					.append("	ROWNUM,\n")
					.append("	P.product_nm,\n")
					.append("	O.prod_cd,\n")
					.append("	lotno,\n")
					.append("	lot_count,\n")
					.append("	project_name,\n")
					.append("	C.cust_nm,\n")
					.append("	product_serial_no,\n")
					.append("	cust_pono,\n")
					.append("	project_cnt,\n")
					.append("	order_count,\n")
					.append("	order_no,\n")
					.append("	O.bigo,\n")
					.append("	order_detail_seq,\n")
					.append("	prod_rev,\n")
					.append("	O.cust_cd,\n")
					.append("	cust_rev,\n")
					.append("	order_date,\n")
					.append("	delivery_date,\n")
					.append("	product_serial_no_end\n")
					.append("FROM tbi_order O\n")
					.append("INNER JOIN tbm_customer C\n")
					.append("	ON O.cust_cd=C.cust_cd\n")
					.append("	AND O.cust_rev=C.revision_no\n")
					.append("	AND O.member_key=C.member_key\n")
					.append("INNER JOIN tbm_product P\n")
					.append("	ON O.prod_cd=P.prod_cd\n")
					.append("	AND O.prod_rev=P.revision_no\n")
					.append("	AND O.member_key=P.member_key\n")
					.append("WHERE order_no = '" + jArray.get("order_no") + "'\n")
					.append("and order_detail_seq = '" +  jArray.get("order_detail_seq") + "'\n")
					.append("and lotno = '" + jArray.get("lotno") + "'\n")
					.append("and O.prod_cd = '" + jArray.get("prod_cd") + "'\n")
					.append("and O.prod_rev = '" + jArray.get("prod_rev") + "'\n")
					
					.append("AND O.member_key = '" + jArray.get("member_key") + "' 	\n")
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
			LoggingWriter.setLogError("M101S040100E144()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M101S040100E144()","==== finally ===="+ e.getMessage());
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
	
	public int E145(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			
			StringBuilder sqlWrap = new StringBuilder()
					.append("SELECT\n")
					.append("	ROWNUM,\n")
					.append("	P.product_nm,\n")
					.append("	C.prod_cd,\n")
					.append("	O.lotno,\n")
					.append("	chulha_cnt,\n")
					.append("	chulha_unit,\n")
					.append("	TO_CHAR (chulha_unit_price, '999,999,999,999'),\n")
					.append("	TO_CHAR (chulha_cnt * chulha_unit_price, '999,999,999,999') AS chulha_amount,\n")
					.append("	chulha_no,\n")
					.append("	C.order_no,\n")
					.append("	C.order_detail_seq,\n")
					.append("	C.cust_cd,\n")
					.append("	C.cust_rev,\n")
					.append("	C.product_serial_no,\n")
					.append("	C.prod_rev,\n")
					.append("	chuha_dt,\n")
					.append("	chulha_user_id,   \n")
					.append("	O.delivery_date,\n")
					.append("	O.project_name,\n")
					.append("	O.project_cnt,\n")
					.append("	O.cust_pono,\n")
					.append("	CM.cust_nm,\n")
					.append("	O.lot_count,\n")
					.append("	O.order_date,\n")
					.append("	O.order_count,\n")
					.append("	O.bigo,\n")
					.append("	chulha_seq,\n")
					.append("	C.product_serial_no_end,\n")
					.append("	C.chulha_bigo\n")
					.append("FROM tbi_chulha_info C\n")
					.append("INNER JOIN tbm_product P\n")
					.append("	ON C.prod_cd=P.prod_cd\n")
					.append("	AND C.prod_rev=P.revision_no\n")
					.append("	AND C.member_key=P.member_key\n")
					.append("INNER JOIN tbm_customer CM\n")
					.append("	ON C.cust_cd=CM.cust_cd\n")
					.append("	AND C.cust_rev=CM.revision_no\n")
					.append("	AND C.member_key=CM.member_key\n")
					.append("INNER JOIN tbi_order O\n")
					.append("	ON C.order_no=O.order_no\n")
					.append("	AND C.order_detail_seq=O.order_detail_seq\n")
					.append("	AND C.lotno=O.lotno\n")
					.append("	AND C.prod_cd=O.prod_cd\n")
					.append("	AND C.prod_rev=O.prod_rev\n")
					.append("	AND C.product_serial_no=O.product_serial_no\n")
					.append("	AND C.member_key=O.member_key\n")
					.append("WHERE C.order_no = '" +  jArray.get("order_no") + "'\n")
					.append("and C.order_detail_seq = '" +  jArray.get("order_detail_seq") + "'\n")
					.append("AND C.lotno = '" +  jArray.get("lotno") + "'\n")
					.append("AND C.prod_cd = '" +  jArray.get("prod_cd") + "'\n")
					.append("AND C.prod_rev = '" +  jArray.get("prod_rev") + "'\n")
					.append("AND C.member_key = '" + jArray.get("member_key") + "' 	\n");
			if(!jArray.get("mode").equals("complete")) {
				sqlWrap = sqlWrap.append("AND C.chulha_no like '" +  jArray.get("chulhano") + "%'\n");
			}
			String sql = sqlWrap.toString(); 		

			String ActionCommand = ioParam.getActionCommand();
			if(ActionCommand.startsWith("doQueryTableFieldName")) {
				resultString = super.excuteQueryStringTableFieldName(con, sql.toString());
			}
			else {;
				resultString = super.excuteQueryString(con, sql.toString());
			}
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M101S040100E145()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M101S040100E145()","==== finally ===="+ e.getMessage());
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
	
	public int E146(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
						
			String sql = new StringBuilder()
					.append("SELECT DISTINCT\n")
					.append("        chulha_no,\n")
					.append("        C.order_no,\n")
					.append("        C.lotno,\n")
					.append("        C.prod_cd,\n")
					.append("        C.prod_rev,\n")
					.append("        CM.cust_nm,\n")
					.append("        C.cust_cd,\n")
					.append("        chuha_dt,\n")
					.append("        chulha_user_id,\n")
					.append("        chulha_bigo,\n")
					.append("        chulha_seq\n")
					.append("FROM tbi_chulha_info C\n")
					.append("INNER JOIN tbm_customer CM\n")
					.append("	ON C.cust_cd=CM.cust_cd\n")
					.append("	AND C.cust_rev=CM.revision_no\n")
					.append("	AND C.member_key=CM.member_key\n")
					.append("WHERE C.order_no = '" +  jArray.get("order_no") + "'\n")
					.append("	AND C.lotno = '" +  jArray.get("lotno") + "'\n")
					.append("	AND C.prod_cd = '"  + jArray.get("prod_cd") + "'  \n")
					.append("	AND C.prod_rev = '"  + jArray.get("prod_rev") + "'  \n")
					.append("	AND C.member_key = '" + jArray.get("member_key") + "' 	\n")
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
			LoggingWriter.setLogError("M101S040100E146()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M101S040100E146()","==== finally ===="+ e.getMessage());
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
	
	public int E101(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		String bom_no = "";
		ApprovalActionNo ActionNo;
		String gChulhaNo = "";
		try {
			con = JDBCConnectionPool.getConnection();

			JSONObject jArray = new JSONObject();
    		jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			
    		JSONObject jArrayHead = (JSONObject) jArray.get("paramHead");
    		JSONArray jjArray = (JSONArray) jArray.get("param");
    		JSONObject jjjArray0 = (JSONObject)jjArray.get(0);

			con.setAutoCommit(false);
    		
    		if(jjjArray0.get("chulha_no").equals("ㅋ")) {
	    		String jspPage = (String)jArrayHead.get("jsp_page");
	    		String user_id = (String)jArrayHead.get("login_id");
	    		String prefix = (String)jArrayHead.get("num_gubun");
	    		String actionGubun = "Regist";
	    		String detail_seq 	= (String)jArrayHead.get("order_detail_seq");
	    		String member_key 	= (String)jjjArray0.get("member_key");
    			ActionNo = new ApprovalActionNo();
        		gChulhaNo = ActionNo.getActionNo(con,jspPage,user_id,prefix,actionGubun,detail_seq,member_key);
    		} else {
    			gChulhaNo = (String)jjjArray0.get("chulha_no");;
    		}
    		
    		for(int i=0; i<jjArray.size(); i++) {
    			JSONObject jjjArray = (JSONObject)jjArray.get(i);
    			
    			String sql = new StringBuilder()
						.append("MERGE INTO tbi_chulha_info mm\n")
						.append("USING (\n")
						.append("	SELECT \n")
						.append("		'" + gChulhaNo 						+ "' AS chulha_no, 	\n")
						.append("		'" + jjjArray.get("chulha_seq") 	+ "' AS chulha_seq, \n")
						.append("		'" + jjjArray.get("order_no") 		+ "' AS order_no, 	\n")
						.append("		'" + jjjArray.get("order_detail_seq") + "' AS order_detail_seq, \n")
						.append("		'" + jjjArray.get("lotno") 			+ "' AS lotno, 		\n")
						.append("		'" + jjjArray.get("cust_cd") 		+ "' AS cust_cd, 	\n")
						.append("		'" + jjjArray.get("cust_rev") 		+ "' AS cust_rev, 	\n")
						.append("		'" + jjjArray.get("product_serial_no") + "' AS product_serial_no, \n")
						.append("		'" + jjjArray.get("prod_cd") 		+ "' AS prod_cd, 	\n")
						.append("		'" + jjjArray.get("prod_rev") 		+ "' AS prod_rev, 	\n")
						.append("		'" + jjjArray.get("chulha_cnt") 	+ "' AS chulha_cnt, \n")
						.append("		'" + jjjArray.get("chulha_unit") 	+ "' AS chulha_unit,\n")
						.append("		'" + jjjArray.get("chulha_unit_price") + "' AS chulha_unit_price, \n")
						.append("		SYSDATE AS chuha_dt, \n")
						.append("		'" + jjjArray.get("chulha_user_id") + "' AS chulha_user_id, \n")
						.append("		'" + jjjArray.get("product_serial_no_end") + "' AS product_serial_no_end,\n")
						.append("		'" + jjjArray.get("member_key") + "' AS member_key,\n")
						.append("		'" + jjjArray.get("chulha_bigo") + "' AS chulha_bigo\n")
						.append("	FROM db_root ) mQ\n")
						.append("ON ( \n")
						.append("	mm.chulha_no=mQ.chulha_no\n")
						.append("	AND mm.chulha_seq=mQ.chulha_seq\n")
						.append("	AND mm.order_no=mQ.order_no\n")
						.append("	AND mm.order_detail_seq=mQ.order_detail_seq\n")
						.append("	AND mm.lotno=mQ.lotno\n")
						.append("	AND mm.prod_cd=mQ.prod_cd\n")
						.append("	AND mm.prod_rev=mQ.prod_rev\n")
						.append("	AND mm.member_key=mQ.member_key\n")
						.append(")\n")
						.append("WHEN MATCHED THEN\n")
						.append("	UPDATE SET \n")
						.append("		mm.chulha_no=mQ.chulha_no,\n")
						.append("		mm.chulha_seq=mQ.chulha_seq,\n")
						.append("		mm.order_no=mQ.order_no,\n")
						.append("		mm.order_detail_seq=mQ.order_detail_seq,\n")
						.append("		mm.lotno=mQ.lotno,\n")
						.append("		mm.cust_cd=mQ.cust_cd,\n")
						.append("		mm.cust_rev=mQ.cust_rev,\n")
						.append("		mm.product_serial_no=mQ.product_serial_no,\n")
						.append("		mm.prod_cd=mQ.prod_cd,\n")
						.append("		mm.prod_rev=mQ.prod_rev,\n")
						.append("		mm.chulha_cnt=mQ.chulha_cnt,\n")
						.append("		mm.chulha_unit=mQ.chulha_unit,\n")
						.append("		mm.chulha_unit_price=mQ.chulha_unit_price,\n")
						.append("		mm.chuha_dt=mQ.chuha_dt,\n")
						.append("		mm.chulha_user_id=mQ.chulha_user_id,\n")
						.append("		mm.product_serial_no_end=mQ.product_serial_no_end,\n")
						.append("		mm.member_key=mQ.member_key,\n")
						.append("		mm.chulha_bigo=mQ.chulha_bigo\n")
						.append("WHEN NOT MATCHED THEN\n")
						.append("	INSERT (\n")
						.append("		mm.chulha_no,\n")
						.append("		mm.chulha_seq,\n")
						.append("		mm.order_no,\n")
						.append("		mm.order_detail_seq,\n")
						.append("		mm.lotno,\n")
						.append("		mm.cust_cd,\n")
						.append("		mm.cust_rev,\n")
						.append("		mm.product_serial_no,\n")
						.append("		mm.prod_cd,\n")
						.append("		mm.prod_rev,\n")
						.append("		mm.chulha_cnt,\n")
						.append("		mm.chulha_unit,\n")
						.append("		mm.chulha_unit_price,\n")
						.append("		mm.chuha_dt,\n")
						.append("		mm.chulha_user_id,\n")
						.append("		mm.product_serial_no_end,\n")
						.append("		mm.member_key,\n")
						.append("		mm.chulha_bigo\n")
						.append("	) VALUES (\n")
						.append("		mQ.chulha_no,\n")
						.append("		mQ.chulha_seq,\n")
						.append("		mQ.order_no,\n")
						.append("		mQ.order_detail_seq,\n")
						.append("		mQ.lotno,\n")
						.append("		mQ.cust_cd,\n")
						.append("		mQ.cust_rev,\n")
						.append("		mQ.product_serial_no,\n")
						.append("		mQ.prod_cd,\n")
						.append("		mQ.prod_rev,\n")
						.append("		mQ.chulha_cnt,\n")
						.append("		mQ.chulha_unit,\n")
						.append("		mQ.chulha_unit_price,\n")
						.append("		mQ.chuha_dt,\n")
						.append("		mQ.chulha_user_id,\n")
						.append("		mQ.product_serial_no_end,\n")
						.append("		mQ.member_key,\n") 
						.append("		mQ.chulha_bigo\n")
						.append("	)\n")
						.toString();

				resultInt = super.excuteUpdate(con, sql.toString());
				if (resultInt < 0) {
					con.rollback();
					return EventDefine.E_DOEXCUTE_ERROR ;
				}
			}
			con.commit();
		} catch(Exception e) {
			LoggingWriter.setLogError("M101S040100E101()","==== SQL ERROR ===="+ e.getMessage() + "\n" + sql.toString());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M101S040100E101()","==== finally ===="+ e.getMessage());
				}
	    	} else {
	    	}
	    }
	    // 결과 전문 구성을 위한 파라미터들을 아이오 파라미터에 저장한다.
		ioParam.setResultString(resultString);
		// 수퍼에서 처리된 칼럼의 갯수를 클라이언트에게 보내기 위해 가져온다.
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
		// 잘 처리되었다는 메시지를 클라이언트에게 보내기 위해 I/O파라미터에 저장한다.
		// 위에서 저장된 넘을 보존하기 위해서 막는다.
    	// ioParam.setMessage(MessageDefine.M_QUERY_OK);
	    return EventDefine.E_QUERY_RESULT;
	}
	
	public int E102(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
//		QueueProcessing Queue = new QueueProcessing();
		try {
			con = JDBCConnectionPool.getConnection();

			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			
			JSONArray jjArray = (JSONArray) jArray.get("param");

			con.setAutoCommit(false);
			
    		for(int i=0;i<jjArray.size();i++) {
    			JSONObject jjjArray = (JSONObject)jjArray.get(i);
    			
				String sql = new StringBuilder()
						.append("UPDATE tbi_chulha_info\n")
						.append("SET \n")
						.append("	order_no='" 		+ jjjArray.get("order_no") + "',\n")
						.append("	lotno='" 			+ jjjArray.get("lotno") + "',\n")
						.append("	order_detail_seq='" + jjjArray.get("order_detail_seq") + "',\n")
						.append("	cust_cd='" 			+ jjjArray.get("cust_cd") + "',\n")
						.append("	cust_rev='" 		+ jjjArray.get("cust_rev") + "',\n")
						.append("	product_serial_no='"+ jjjArray.get("product_serial_no") + "',\n")
						.append("	prod_cd='" 			+ jjjArray.get("prod_cd") + "',\n")
						.append("	prod_rev='" 		+ jjjArray.get("prod_rev") + "',\n")
						.append("	chulha_cnt='" 		+ jjjArray.get("chulha_cnt") + "',\n")
						.append("	chulha_unit='" 		+ jjjArray.get("chulha_unit") + "',\n")
						.append("	chulha_unit_price='" + jjjArray.get("chulha_unit_price") + "',\n")
						.append("	chuha_dt=SYSDATE,\n")
						.append("	chulha_user_id='" 	+ jjjArray.get("chulha_user_id") + "',\n")
						.append("	product_serial_no_end='" + jjjArray.get("product_serial_no_end") + "'\n")
						.append(" 	,member_key = 	'" + jjjArray.get("member_key") + "'		\n") //member_key_update
						.append(" 	,chulha_bigo = 	'" + jjjArray.get("chulha_bigo") + "'		\n") //member_key_update
						.append("WHERE chulha_no='" 	+ jjjArray.get("chulha_no") + "'\n")
						.append("	AND chulha_seq='" 	+ jjjArray.get("chulha_seq") + "'\n")
						.append("	AND order_no='" 	+ jjjArray.get("order_no") + "'\n")
						.append("	AND order_detail_seq='" + jjjArray.get("order_detail_seq") + "'\n")
						.append("	AND lotno='" 		+ jjjArray.get("lotno") + "'\n")
						.append("	AND prod_cd='" 		+ jjjArray.get("prod_cd") + "'\n")
						.append("	AND prod_rev='" 	+ jjjArray.get("prod_rev") + "'\n")
						.append(" 	AND member_key = '" + jjjArray.get("member_key") + "' \n") //member_key_select, update, delete
						.toString();

				resultInt = super.excuteUpdate(con, sql.toString());
				if (resultInt < 0) {
					con.rollback();
					return EventDefine.E_DOEXCUTE_ERROR ;
				}
			}
			con.commit();
		} catch(Exception e) {
			LoggingWriter.setLogError("M101S040100E102()","==== SQL ERROR ===="+ e.getMessage() + "\n" + sql.toString());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M101S040100E102()","==== finally ===="+ e.getMessage());
				}
	    	} else {
	    	}
	    }
	    // 결과 전문 구성을 위한 파라미터들을 아이오 파라미터에 저장한다.
		ioParam.setResultString(resultString);
		// 수퍼에서 처리된 칼럼의 갯수를 클라이언트에게 보내기 위해 가져온다.
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
		// 잘 처리되었다는 메시지를 클라이언트에게 보내기 위해 I/O파라미터에 저장한다.
		// 위에서 저장된 넘을 보존하기 위해서 막는다.
    	// ioParam.setMessage(MessageDefine.M_QUERY_OK);
	    return EventDefine.E_QUERY_RESULT;
	}
	
	public int E103(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
//		QueueProcessing Queue = new QueueProcessing();
		try {
			con = JDBCConnectionPool.getConnection();

			JSONObject jArray = new JSONObject(); // JSONObject 선언
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			
    		for(int i=0;i<jArray.size();i++) {
    			String sql = new StringBuilder()
    					.append("DELETE FROM tbi_chulha_info\n")
    					.append("	WHERE chulha_no='" + jArray.get("chulha_no") + "'\n")
    					.append("		AND order_no='" + jArray.get("order_no") +"'\n")
    					.append("		AND order_detail_seq='" + jArray.get("order_detail_seq") + "'\n")
    					.append("		AND lotno='" + jArray.get("lotno") + "'\n")
    					.append("		AND prod_cd='" + jArray.get("prod_cd") + "'\n")
    					.append("		AND prod_rev='" + jArray.get("prod_rev") + "'\n")
    					.append("		AND product_serial_no='" + jArray.get("product_serial_no") + "'\n")
    					.append("		AND chulha_seq='" + jArray.get("chulha_seq") + "'\n")
    					.append(" 		AND member_key = '" + jArray.get("member_key") + "' \n") //member_key_select, update, delete
    					.toString();

				resultInt = super.excuteUpdate(con, sql.toString());
				if (resultInt < 0) {
					con.rollback();
					return EventDefine.E_DOEXCUTE_ERROR ;
				}
			}
			con.commit();
		} catch(Exception e) {
			LoggingWriter.setLogError("M101S040100E103()","==== SQL ERROR ===="+ e.getMessage() + "\n" + sql.toString());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M101S040100E103()","==== finally ===="+ e.getMessage());
				}
	    	} else {
	    	}
	    }
	    // 결과 전문 구성을 위한 파라미터들을 아이오 파라미터에 저장한다.
		ioParam.setResultString(resultString);
		// 수퍼에서 처리된 칼럼의 갯수를 클라이언트에게 보내기 위해 가져온다.
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
		// 잘 처리되었다는 메시지를 클라이언트에게 보내기 위해 I/O파라미터에 저장한다.
		// 위에서 저장된 넘을 보존하기 위해서 막는다.
    	// ioParam.setMessage(MessageDefine.M_QUERY_OK);
	    return EventDefine.E_QUERY_RESULT;
	}

			
	public int E804(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			
			String sql = new StringBuilder()
					.append("SELECT DISTINCT\n")
					.append("        chulha_no,\n")
					.append("        A.order_no,\n")
					.append("        A.lotno,\n")
					.append("        A.prod_cd,\n")
					.append("        A.prod_rev,\n")
					.append("        C.cust_nm,\n")
					.append("        C.cust_cd,\n")
					.append("        chuha_dt,\n")
					.append("        chulha_user_id,\n")
					.append("        chulha_bigo,\n")
					.append("        chulha_seq,\n")
					.append("        B.product_nm || '('||D.code_name  ||','|| E.code_name ||')',\n")
					.append("        project_name,\n")
					.append("        cust_pono \n")
//					.append("        chulha_cnt,\n")
//					.append("        chulha_unit_price,\n")
//					.append("        project_cnt,\n")
//					.append("        order_count,\n")
//					.append("        A.bigo,\n")
//					.append("        order_date,\n")
//					.append("        A.cust_cd,\n")
//					.append("        A.cust_rev,\n")
//					.append("        A.product_serial_no,\n")
//					.append("        lot_count\n")
					.append("FROM tbi_order A\n")
					.append("INNER JOIN tbi_chulha_info h\n")
					.append("	ON A.order_no = h.order_no\n")
					.append("	AND A.lotno = h.lotno\n")
					.append("	AND A.product_serial_no = h.product_serial_no\n")
					.append("	AND A.member_key = h.member_key\n")
					.append("INNER JOIN tbm_customer C\n")
					.append("	ON A.cust_cd = C.cust_cd\n")
					.append("	AND A.cust_rev = C.revision_no\n")
					.append("	AND A.member_key = C.member_key\n")
					.append("INNER JOIN tbm_product B\n")
					.append("	ON A.prod_cd = B.prod_cd\n")
					.append("	AND  A.prod_rev = B.revision_no\n")
					.append("	AND A.member_key = B.member_key\n")					
					.append("INNER JOIN v_prodgubun_big D				\n")
					.append("		 ON B.prod_gubun_b 	= D.code_value 	\n")
					.append("		AND B.member_key 	= D.member_key	\n")
					.append("INNER JOIN v_prodgubun_mid E				\n")
					.append("	 	 ON B.prod_gubun_m	= E.code_value	\n")
					.append("		AND B.member_key 	= E.member_key	\n")					
					.append("WHERE A.cust_cd like '%"+ jArray.get("custcode") +"'	\n")
					.append("	AND order_date BETWEEN '" + jArray.get("fromdate") +"'  AND '"+ jArray.get("todate") +"'	\n")
					.append("AND A.member_key = '" + jArray.get("member_key") + "' 	\n")
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
			LoggingWriter.setLogError("M101S040100E804()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M101S040100E804()","==== finally ===="+ e.getMessage());
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
