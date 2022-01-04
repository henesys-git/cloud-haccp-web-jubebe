package mes.frame.business.M606;

import java.lang.reflect.Method;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.util.Vector;

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

public class M606S060100 extends SqlAdapter {
	Connection con = null;
	PreparedStatement pstmt = null;
	String resultString = "";
	int resultInt = -1;
	StringBuffer sql = new StringBuffer();

	String[][] v_paramArray = new String[0][0];
	Class[] optClass = null;
	Object[] optObj = null;
	Object obj = null;

	QueueProcessing Queue = new QueueProcessing();

	public M606S060100() {
	}

	/**
	 * ����ڰ� �����ؼ� �Ķ���� �����ϴ� method.
	 * 
	 * @param ioParam , p_sql
	 * @return the desired integer.
	 */
	public int custParamCheck(InoutParameter ioParam, StringBuffer p_sql) {
		int paramInt = 0;
		return paramInt;
	}

	/**
	 * �Է��Ķ��Ÿ�� 2���� �����ΰ�� �Ķ���� �����ϴ� method.
	 * 
	 * @param ioParam , p_sql
	 * @return the desired integer.
	 */
	public int paramCheck(InoutParameter ioParam, StringBuffer p_sql) {
		v_paramArray = super.getParamCheck(ioParam, p_sql);
		return v_paramArray[0].length;
	}

	/**
	 * �Է��Ķ��Ÿ���� �̺�ƮID���� �޼ҵ� ȣ���ϴ� method.
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

			Method method = M606S060100.class.getMethod(event, optClass);
			LoggingWriter.setLogDebug(M606S060100.class.getName(),
					"==== " + event + " EventMethod Create Success ====");

			obj = method.invoke(M606S060100.class.newInstance(), optObj);
			doExcute_result = CommonFunction.getInt(obj.toString());

		} catch (Exception ex) {
			doExcute_result = EventDefine.E_DOEXCUTE_INIT;
			ioParam.setMessage(MessageDefine.M_NO_EVENTID);
			LoggingWriter.setLogError(M606S060100.class.getName(),
					"==== EventID Not define : EVENT ID [ " + ioParam.getEventID() + "]");
		} finally {
			obj = null;
			optClass = null;
			optObj = null;
		}
		long endTime = System.currentTimeMillis();
		long runningTime = endTime - startTime;
		LoggingWriter.setLogAll(M606S060100.class.getName(), "==== Query [����ð�  : " + runningTime + " ms]");

		return doExcute_result;
	}

	//��� ���
	public int E101(InoutParameter ioParam) {
		
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		ApprovalActionNo ActionNo;
		QueueProcessing Queue = new QueueProcessing();
		String gRegNo = "";
		try {
			con = JDBCConnectionPool.getConnection();
			con.setAutoCommit(false);
			// Ŭ���̾�Ʈ�� ���� ���� �Ķ���͸� �Ű� ��´�.
			String rcvData = (String) ((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			// Ŭ���̾�Ʈ�� ���� ���� �Ķ���͸� �ɰ�� �迭�� ��´�. returnStringBuffer
			String[][] c_paramArray = CommonFunction.getConvString2DoubleArray(rcvData);
			
			String jspPage = c_paramArray[0][0];
			String user_id = c_paramArray[0][1];
			String prefix = c_paramArray[0][2];
			String actionGubun = "Regist";
			String detail_seq = "0";
			String member_key = c_paramArray[0][20];
			
			ActionNo = new ApprovalActionNo();
			gRegNo = ActionNo.getActionNo(con, jspPage, user_id, prefix, actionGubun, detail_seq,member_key);
			
			
//			ActionNo = new ApprovalActionNo();
//			gRegNo = ActionNo.getActionNo(con,c_paramArray[0][0],c_paramArray[0][1],c_paramArray[0][2], "Regist",c_paramArray[0][4]);	//GV_JSPPAGE(action Page), User ID, prefix
//			getActionNo(Connection  con, String jspPage, String user_id, String prefix, String actionGubun, String detail_seq)

			String sql = new StringBuilder()
					.append("INSERT INTO tbi_doc_destroy_info(\n")
					.append("destroy_no				,\n")
					.append("regist_no				,\n")
					.append("regist_no_rev			,\n")
					.append("document_no			,\n")
					.append("document_no_rev		,\n")
					.append("file_view_name			,\n")
					.append("file_real_name			,\n")
					.append("external_doc_yn		,\n")
					.append("external_doc_source	,\n")
					.append("destroy_reason_code	,\n")
					.append("total_page				,\n")
					.append("gwanribon_yn			,\n")
					.append("keep_yn				,\n")
					.append("hold_yn				,\n")
					.append("delok_yn				,\n")
					.append("regist_reason_code		,\n")
					.append("destroy_yn				,\n")
					.append("reg_gubun				,\n")
					.append("member_key				\n")
					.append(")\n")
					.append("VALUES (\n")
					
					.append(" '"+ gRegNo +"' 				,\n")
					.append(" '"+ c_paramArray[0][3] +"'	,\n")
					.append(" '"+ c_paramArray[0][4] +"'	,\n")
					.append(" '"+ c_paramArray[0][5] +"'	,\n")
					.append(" '"+ c_paramArray[0][6] +"'	,\n")
					.append(" '"+ c_paramArray[0][7] +"'	,\n")
					.append(" '"+ c_paramArray[0][8] +"'	,\n")
					.append(" '"+ c_paramArray[0][9] +"'	,\n")
					.append(" '"+ c_paramArray[0][10] +"'	,\n")
					.append(" '"+ c_paramArray[0][11] +"'	,\n")//��� ���� �ڵ�
					.append(" '"+ c_paramArray[0][12] +"'	,\n")
					.append(" '"+ c_paramArray[0][13] +"'	,\n")
					.append(" '"+ c_paramArray[0][14] +"'	,\n")
					.append(" '"+ c_paramArray[0][15] +"'	,\n")
					.append(" '"+ c_paramArray[0][16] +"'	,\n")
					.append(" '"+ c_paramArray[0][17] +"'	,\n")
					.append(" '"+ c_paramArray[0][18] +"'	,\n")
					.append(" '"+ c_paramArray[0][19] +"'	,\n")
					.append(" '"+ c_paramArray[0][20] +"'	\n")
					.append(")\n")
					.toString();
			
			resultInt = super.excuteUpdate(con, sql.toString());
			if (resultInt < 0) { //
				ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
				con.rollback();
				return EventDefine.E_DOEXCUTE_ERROR;
			}
			
			sql = new StringBuilder()
					.append("DELETE FROM tbi_doc_regist_info\n")
					.append("WHERE	regist_no		= '" + c_paramArray[0][3] +"' AND\n")
					.append("		revision_no		= '" + c_paramArray[0][4] +"' AND\n")
					.append("		document_no		= '" + c_paramArray[0][5] +"' AND\n")
					.append("		document_no_rev	= '" + c_paramArray[0][6] +"' AND\n")
					.append("		file_view_name	= '" + c_paramArray[0][7] +"' AND\n")
					.append("		member_key		= '" + c_paramArray[0][20] +"'\n")
					.toString();

			resultInt = super.excuteUpdate(con, sql.toString());
			if (resultInt < 0) { //
				ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
				con.rollback();
				return EventDefine.E_DOEXCUTE_ERROR;
			}
			
			con.commit();
			
		} catch (Exception e) {
			LoggingWriter.setLogError("M606S060100E101()",
					"==== SQL ERROR ====" + e.getMessage() + "\n" + sql.toString());
			return EventDefine.E_DOEXCUTE_ERROR;
		} finally {
			if (Config.useDataSource) {
				try {
					if (con != null)
						con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M606S060100E101()","==== finally ===="+ e.getMessage());
				}
			} else {
			}
		}
		// ��� ���� ������ ���� �Ķ���͵��� ���̿� �Ķ���Ϳ� �����Ѵ�.
		ioParam.setResultString(resultString);
		// ���ۿ��� ó���� Į���� ������ Ŭ���̾�Ʈ���� ������ ���� �����´�.
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
		// �� ó���Ǿ��ٴ� �޽����� Ŭ���̾�Ʈ���� ������ ���� I/O�Ķ���Ϳ� �����Ѵ�.
		// ������ ����� ���� �����ϱ� ���ؼ� ���´�.
		// ioParam.setMessage(MessageDefine.M_QUERY_OK);
		return EventDefine.E_QUERY_RESULT;
	}
	
	//��� ����
	public int E102(InoutParameter ioParam) {
		
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		ApprovalActionNo ActionNo;
		QueueProcessing Queue = new QueueProcessing();
		String gRegNo = "";
		try {
			con = JDBCConnectionPool.getConnection();
			con.setAutoCommit(false);
			// Ŭ���̾�Ʈ�� ���� ���� �Ķ���͸� �Ű� ��´�.
			String rcvData = (String) ((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			// Ŭ���̾�Ʈ�� ���� ���� �Ķ���͸� �ɰ�� �迭�� ��´�. returnStringBuffer
			String[][] c_paramArray = CommonFunction.getConvString2DoubleArray(rcvData);
			
//			ActionNo = new ApprovalActionNo();
//			gRegNo = ActionNo.getActionNo(con,c_paramArray[0][0],c_paramArray[0][1],c_paramArray[0][2], "Regist",c_paramArray[0][4]);	//GV_JSPPAGE(action Page), User ID, prefix
//			getActionNo(Connection  con, String jspPage, String user_id, String prefix, String actionGubun, String detail_seq)
			String sql = new StringBuilder()
					.append("INSERT INTO tbi_doc_regist_info (\n")
					.append("regist_no,\n")
					.append("revision_no,\n")
					.append("document_no,\n")
					.append("document_no_rev,\n")
					.append("file_view_name,\n")
					.append("file_real_name,\n")
					.append("external_doc_yn,\n")
					.append("external_doc_source,\n")
					.append("destroy_reason_code,\n")
					.append("total_page,\n")
					.append("gwanribon_yn,\n")
					.append("keep_yn,\n")
					.append("hold_yn,\n")
					.append("delok_yn,\n")
					.append("regist_reason_code,\n")
					.append("destroy_yn ,\n")
					.append("reg_gubun ,\n")
					.append("member_key \n")
					.append(") VALUES (\n")
					
					.append("'"+ c_paramArray[0][0] +"',\n")
					.append("'"+ c_paramArray[0][1] +"',\n")
					.append("'"+ c_paramArray[0][2] +"',\n")
					.append("'"+ c_paramArray[0][3] +"',\n")
					.append("'"+ c_paramArray[0][4] +"',\n")
					.append("'"+ c_paramArray[0][5] +"',\n")
					.append("'"+ c_paramArray[0][6] +"',\n")
					.append("'"+ c_paramArray[0][7] +"',\n")
					.append("'"+ c_paramArray[0][8] +"',\n")
					.append("'"+ c_paramArray[0][9] +"',\n")
					.append("'"+ c_paramArray[0][10] +"',\n")
					.append("'"+ c_paramArray[0][11] +"',\n")
					.append("'"+ c_paramArray[0][12] +"',\n")
					.append("'"+ c_paramArray[0][13] +"',\n")
					.append("'"+ c_paramArray[0][14] +"',\n")
					.append("'"+ c_paramArray[0][15] +"',\n")
					.append("'"+ c_paramArray[0][16] +"',\n")
					.append("'"+ c_paramArray[0][18] +"'\n")
					.append(")\n")
					.toString();

				resultInt = super.excuteUpdate(con, sql.toString());
			if (resultInt < 0) { //
				ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
				con.rollback();
				return EventDefine.E_DOEXCUTE_ERROR;
			}
			
			sql = new StringBuilder()
					.append("DELETE FROM tbi_doc_destroy_info\n")
					.append("WHERE 		destroy_no = '"+ c_paramArray[0][17] +"' AND\n")
					.append("			regist_no = '"+ c_paramArray[0][0] +"' AND\n")
					.append("			regist_no_rev='"+ c_paramArray[0][1] +"' AND\n")
					.append("			document_no = '"+ c_paramArray[0][2] +"' AND\n")
					.append("			document_no_rev = '"+ c_paramArray[0][3] +"' AND\n")
					.append("			file_view_name = '"+ c_paramArray[0][4] +"' AND\n")
					.append("			member_key = '"+ c_paramArray[0][18] +"'\n")
					.toString();

				resultInt = super.excuteUpdate(con, sql.toString());
			if (resultInt < 0) { //
				ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
				con.rollback();
				return EventDefine.E_DOEXCUTE_ERROR;
			}
			
			con.commit();
			
		} catch (Exception e) {
			LoggingWriter.setLogError("M606S060100E102()",
					"==== SQL ERROR ====" + e.getMessage() + "\n" + sql.toString());
			return EventDefine.E_DOEXCUTE_ERROR;
		} finally {
			if (Config.useDataSource) {
				try {
					if (con != null)
						con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M606S060100E102()","==== finally ===="+ e.getMessage());
				}
			} else {
			}
		}
		// ��� ���� ������ ���� �Ķ���͵��� ���̿� �Ķ���Ϳ� �����Ѵ�.
		ioParam.setResultString(resultString);
		// ���ۿ��� ó���� Į���� ������ Ŭ���̾�Ʈ���� ������ ���� �����´�.
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
		// �� ó���Ǿ��ٴ� �޽����� Ŭ���̾�Ʈ���� ������ ���� I/O�Ķ���Ϳ� �����Ѵ�.
		// ������ ����� ���� �����ϱ� ���ؼ� ���´�.
		// ioParam.setMessage(MessageDefine.M_QUERY_OK);
		return EventDefine.E_QUERY_RESULT;
	}

	// ���� ���� ��ȸ
	public int E104(InoutParameter ioParam) {
		resultInt = EventDefine.E_DOEXCUTE_INIT;

		try {
			con = JDBCConnectionPool.getConnection();

			// Ŭ���̾�Ʈ�� ���� ���� �Ķ���͸� �Ű� ��´�.
			String rcvData = (String) ((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			// Ŭ���̾�Ʈ�� ���� ���� �Ķ���͸� �ɰ�� �迭�� ��´�.
			// rcvData = [���浵]
			String[][] c_paramArray = CommonFunction.getConvString2DoubleArray(rcvData);
			
			String sql = new StringBuilder()
					.append("SELECT \n")
					.append("C.code_name			,\n")
					.append("B.document_name		,\n")
					.append("A.destroy_no			,\n")
					.append("A.regist_no			,\n")
					.append("A.regist_no_rev		,\n")
					.append("A.document_no			,\n")
					.append("A.document_no_rev		,\n")
					.append("file_view_name			,\n")
					.append("file_real_name			,\n")
					.append("external_doc_yn		,\n")
					.append("external_doc_source	,\n")
					.append("destroy_reason_code	,\n")
					.append("total_page				,\n")
					.append("gwanribon_yn			,\n")
					.append("keep_yn				,\n")
					.append("hold_yn				,\n")
					.append("delok_yn				,\n")
					.append("regist_reason_code		,\n")
					.append("destroy_yn				,\n")
					.append("A.reg_gubun			,\n")
					.append("B.gubun_code\n")
					.append("FROM \n")
					.append("tbi_doc_destroy_info A INNER JOIN tbm_doc_base B\n")
					.append("ON A.document_no = B.document_no\n")
					.append("AND A.member_key = B.member_key\n")
					.append("								INNER JOIN v_doc_gubun C\n")
					.append("ON B.gubun_code = C.code_value\n")
					.append("AND B.member_key = C.member_key\n")
					.append("WHERE B.gubun_code LIKE '"  + c_paramArray[0][0] +  "%'\n")
					.append("  AND A.member_key = '"  + c_paramArray[0][1] +  "'\n")
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
			LoggingWriter.setLogError("M606S060100E104()", "==== SQL ERROR ====" + e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR;
		} finally {
			if (Config.useDataSource) {
				try {
					if (con != null)
						con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M606S060100E104()","==== finally ===="+ e.getMessage());
				}
			} else {
			}
		}
		// ��� ���� ������ ���� �Ķ���͵��� ���̿� �Ķ���Ϳ� �����Ѵ�.
		ioParam.setResultString(resultString);
		// ���ۿ��� ó���� Į���� ������ Ŭ���̾�Ʈ���� ������ ���� �����´�.
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
		// �� ó���Ǿ��ٴ� �޽����� Ŭ���̾�Ʈ���� ������ ���� I/O�Ķ���Ϳ� �����Ѵ�.
		ioParam.setMessage(MessageDefine.M_QUERY_OK);
		return EventDefine.E_QUERY_RESULT;
	}

	// ����� �Ǿ� �ִ� ������ �ı� �� ���̱� ������ tbi_doc_regist_info�� ��ȸ �Ѵ�.
	public int E105(InoutParameter ioParam) {
		resultInt = EventDefine.E_DOEXCUTE_INIT;

		try {
			con = JDBCConnectionPool.getConnection();
			// Ŭ���̾�Ʈ�� ���� ���� �Ķ���͸� �Ű� ��´�.
			String rcvData = (String) ((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			// Ŭ���̾�Ʈ�� ���� ���� �Ķ���͸� �ɰ�� �迭�� ��´�.
			// rcvData = [���浵]
			String[][] c_paramArray = CommonFunction.getConvString2DoubleArray(rcvData);

			String sql = new StringBuilder()
					.append("SELECT \n")
					.append("A.regist_no,\n")
					.append("A.revision_no,\n")
					.append("A.document_no,\n")
					.append("B.document_name,\n")
					.append("B.gubun_code,\n")
					.append("A.document_no_rev,\n")
					.append("A.file_view_name,\n")
					.append("A.file_real_name,\n")
					.append("external_doc_yn,\n")
					.append("external_doc_source,\n")
					.append("destroy_reason_code,\n")
					.append("total_page,\n")
					.append("gwanribon_yn,\n")
					.append("keep_yn,\n")
					.append("hold_yn,\n")
					.append("delok_yn,\n")
					.append("regist_reason_code,\n")
					.append("destroy_yn, \n")
					.append("reg_gubun, \n")
					.append("C.action_date AS regist_date,\n")
					.append("C.user_id AS  regist_user_id\n")
					.append("FROM \n")
					.append("tbi_doc_regist_info A INNER JOIN tbm_doc_base B\n")
					.append("ON A.document_no = B.document_no\n")
					.append("AND A.member_key = B.member_key\n")
					.append("							INNER JOIN tbi_approval_action C\n")
					.append("ON A.regist_no = C.actionno\n")
					.append("AND A.member_key = C.member_key\n")
					.append("WHERE A.member_key = '"  + c_paramArray[0][0] +  "'\n")
					
					//.append("WHERE B.gubun_code LIKE '"+ c_paramArray[0][0] + "%'\n")
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
			LoggingWriter.setLogError("M606S060100E105()", "==== SQL ERROR ====" + e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR;
		} finally {
			if (Config.useDataSource) {
				try {
					if (con != null)
						con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M606S060100E105()","==== finally ===="+ e.getMessage());
				}
			} else {
			}
		}
		// ��� ���� ������ ���� �Ķ���͵��� ���̿� �Ķ���Ϳ� �����Ѵ�.
		ioParam.setResultString(resultString);
		// ���ۿ��� ó���� Į���� ������ Ŭ���̾�Ʈ���� ������ ���� �����´�.
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
		// �� ó���Ǿ��ٴ� �޽����� Ŭ���̾�Ʈ���� ������ ���� I/O�Ķ���Ϳ� �����Ѵ�.
		ioParam.setMessage(MessageDefine.M_QUERY_OK);
		return EventDefine.E_QUERY_RESULT;
	}
	
	//��� ������ ���ؼ� �����;��� ������
	public int E106(InoutParameter ioParam) {
		resultInt = EventDefine.E_DOEXCUTE_INIT;
			try {
			con = JDBCConnectionPool.getConnection();
				// Ŭ���̾�Ʈ�� ���� ���� �Ķ���͸� �Ű� ��´�.
			String rcvData = (String) ((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			// Ŭ���̾�Ʈ�� ���� ���� �Ķ���͸� �ɰ�� �迭�� ��´�.
			// rcvData = [���浵]
			String[][] c_paramArray = CommonFunction.getConvString2DoubleArray(rcvData);
			
			String sql = new StringBuilder()
					.append("SELECT\n")
					.append(" destroy_no,\n")
					.append(" regist_no,\n")
					.append(" regist_no_rev,\n")
					.append(" document_no,\n")
					.append(" document_no_rev,\n")
					.append(" file_view_name,\n")
					.append(" file_real_name,\n")
					.append(" external_doc_yn,\n")
					.append(" external_doc_source,\n")
					.append(" destroy_reason_code,\n")
					.append(" total_page,\n")
					.append(" gwanribon_yn,\n")
					.append(" keep_yn,\n")
					.append(" hold_yn,\n")
					.append(" delok_yn,\n")
					.append(" regist_reason_code,\n")
					.append(" destroy_yn,\n")
					.append(" reg_gubun\n")
					.append(" FROM tbi_doc_destroy_info\n")
					.append("WHERE 		destroy_no = '"+ c_paramArray[0][0] +"'		AND\n")
					.append("			regist_no = '"+ c_paramArray[0][1] +"'		AND\n")
					.append("			regist_no_rev = '"+ c_paramArray[0][2] +"'	AND\n")
					.append("			document_no='"+ c_paramArray[0][3] +"'		AND\n")
					.append("			document_no_rev = '"+ c_paramArray[0][4] +"' AND\n")
					.append("			member_key = '"+ c_paramArray[0][5] +"'\n")
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
			LoggingWriter.setLogError("M606S060100E106()", "==== SQL ERROR ====" + e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR;
		} finally {
			if (Config.useDataSource) {
				try {
					if (con != null)
						con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M606S060100E106()","==== finally ===="+ e.getMessage());
				}
			} else {
			}
		}
		// ��� ���� ������ ���� �Ķ���͵��� ���̿� �Ķ���Ϳ� �����Ѵ�.
		ioParam.setResultString(resultString);
		// ���ۿ��� ó���� Į���� ������ Ŭ���̾�Ʈ���� ������ ���� �����´�.
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
		// �� ó���Ǿ��ٴ� �޽����� Ŭ���̾�Ʈ���� ������ ���� I/O�Ķ���Ϳ� �����Ѵ�.
		ioParam.setMessage(MessageDefine.M_QUERY_OK);
		return EventDefine.E_QUERY_RESULT;
	}
	
	// ���� ���� ��ȸ
	public int E804(InoutParameter ioParam) {
		resultInt = EventDefine.E_DOEXCUTE_INIT;
			try {
			con = JDBCConnectionPool.getConnection();
				// Ŭ���̾�Ʈ�� ���� ���� �Ķ���͸� �Ű� ��´�.
			String rcvData = (String) ((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			// Ŭ���̾�Ʈ�� ���� ���� �Ķ���͸� �ɰ�� �迭�� ��´�.
			// rcvData = [���浵]
			String[][] c_paramArray = CommonFunction.getConvString2DoubleArray(rcvData);
			
			String sql = new StringBuilder()
					.append("SELECT \n")
					.append("C.code_name			,\n")
					.append("B.document_name		,\n")
					.append("A.destroy_no			,\n")
					.append("A.regist_no			,\n")
					.append("A.regist_no_rev		,\n")
					.append("A.document_no			,\n")
					.append("A.document_no_rev		,\n")
					.append("file_view_name			,\n")
					.append("file_real_name			,\n")
					.append("external_doc_yn		,\n")
					.append("external_doc_source	,\n")
					.append("destroy_reason_code	,\n")
					.append("total_page				,\n")
					.append("gwanribon_yn			,\n")
					.append("keep_yn				,\n")
					.append("hold_yn				,\n")
					.append("delok_yn				,\n")
					.append("regist_reason_code		,\n")
					.append("destroy_yn				,\n")
					.append("A.reg_gubun			,\n")
					.append("B.gubun_code\n")
					.append("FROM \n")
					.append("tbi_doc_destroy_info A INNER JOIN tbm_doc_base B\n")
					.append("ON A.document_no = B.document_no\n")
					.append("	AND A.member_key = B.member_key\n")
					.append("								INNER JOIN v_doc_gubun C\n")
					.append("ON B.gubun_code = C.code_value\n")
					.append("	AND B.member_key = C.member_key\n")
					.append("WHERE B.gubun_code LIKE '"  + c_paramArray[0][0] +  "%'\n")
					.append("  AND A.member_key = '"  + c_paramArray[0][1] +  "'\n")
					.toString();
				String ActionCommand = ioParam.getActionCommand();
			if (ActionCommand.startsWith("doQueryTableFieldName")) {
				resultString = super.excuteQueryStringTableFieldName(con, sql.toString());
			} else {
				resultString = super.excuteQueryString(con, sql.toString());
			}
		} catch (Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M606S060100E804()", "==== SQL ERROR ====" + e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR;
		} finally {
			if (Config.useDataSource) {
				try {
					if (con != null)
						con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M606S060100E804()","==== finally ===="+ e.getMessage());
				}
			} else {
			}
		}
		// ��� ���� ������ ���� �Ķ���͵��� ���̿� �Ķ���Ϳ� �����Ѵ�.
		ioParam.setResultString(resultString);
		// ���ۿ��� ó���� Į���� ������ Ŭ���̾�Ʈ���� ������ ���� �����´�.
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
		// �� ó���Ǿ��ٴ� �޽����� Ŭ���̾�Ʈ���� ������ ���� I/O�Ķ���Ϳ� �����Ѵ�.
		ioParam.setMessage(MessageDefine.M_QUERY_OK);
		return EventDefine.E_QUERY_RESULT;
	}
}