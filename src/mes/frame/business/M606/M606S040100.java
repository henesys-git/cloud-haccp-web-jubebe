package mes.frame.business.M606;

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

public class M606S040100 extends SqlAdapter {
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

	public M606S040100() {
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

			Method method = M606S040100.class.getMethod(event, optClass);
			LoggingWriter.setLogDebug(M606S040100.class.getName(),
					"==== " + event + " EventMethod Create Success ====");

			obj = method.invoke(M606S040100.class.newInstance(), optObj);
			doExcute_result = CommonFunction.getInt(obj.toString());

		} catch (Exception ex) {
			doExcute_result = EventDefine.E_DOEXCUTE_INIT;
			ioParam.setMessage(MessageDefine.M_NO_EVENTID);
			LoggingWriter.setLogError(M606S040100.class.getName(),
					"==== EventID Not define : EVENT ID [ " + ioParam.getEventID() + "]");
		} finally {
			obj = null;
			optClass = null;
			optObj = null;
		}
		long endTime = System.currentTimeMillis();
		long runningTime = endTime - startTime;
		LoggingWriter.setLogAll(M606S040100.class.getName(), "==== Query [수행시간  : " + runningTime + " ms]");

		return doExcute_result;
	}

	// 문서 배포 등록
	public int E101(InoutParameter ioParam) {
		
		resultInt = EventDefine.E_DOEXCUTE_INIT;
	
		try {
			con = JDBCConnectionPool.getConnection();

			// 클라이언트로 부터 받은 파라미터를 옮겨 담는다.
			String rcvData = (String)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));

			con.setAutoCommit(false);
			    		
			// 클라이언트로 부터 받은 파라미터를 쪼개어서 배열에 담는다. returnStringBuffer
			String[][] c_paramArray = CommonFunction.getConvString2DoubleArray(rcvData);

			ApprovalActionNo ActionNo = new ApprovalActionNo();
			String gRegNo = ActionNo.getActionNo(con, c_paramArray[0][0], c_paramArray[0][1], c_paramArray[0][2], "Regist",
					"0",c_paramArray[0][11]);// GV_JSPPAGE(action Page), User ID, prefix
//							getActionNo(Connection  con, String jspPage,String user_id, String prefix, String actionGubun,String detail_seq)

			String sql = new StringBuilder()
					.append("INSERT INTO tbi_doc_distribut_info(\n")
					.append("	gubun,\n")
					.append("	distribute_no,\n")
					.append("	document_no,\n")
					.append("	file_view_name,\n")
					.append("	regist_no,\n")
					.append("	regist_no_rev,\n")
					.append("	dist_date,\n")
					.append("	due_date,\n")
					.append("	dist_target,\n")
					.append("	dept_cd, \n")
					.append("	member_key \n")
					.append(") VALUES ( \n")
					.append("	'" + c_paramArray[0][3] + "',\n")
					.append("	'" + gRegNo + "',\n")
					.append("	'" + c_paramArray[0][4] + "',\n")
					.append("	'" + c_paramArray[0][5] + "',\n")
					.append("	'" + c_paramArray[0][6] + "',\n")
					.append("	'" + c_paramArray[0][7] + "',\n")
					.append("	   SYSDATE ,\n")
					.append("	'" + c_paramArray[0][8] + "',\n")
					.append("	'" + c_paramArray[0][9] + "',\n")
					.append("	'" + c_paramArray[0][10] + "',\n")
					.append("	'" + c_paramArray[0][11] + "'\n")
					.append(")\n")
					.toString();

			//// System.out.println(sql.toString());
			resultInt = super.excuteUpdate(con, sql.toString());
			if (resultInt < 0) {
				con.rollback();
				return EventDefine.E_DOEXCUTE_ERROR ;
			}
			
			con.commit();
			
			} catch(Exception e) {
				LoggingWriter.setLogError("M606S040100E101()","==== SQL ERROR ===="+ e.getMessage() + "\n" + sql.toString());
				return EventDefine.E_DOEXCUTE_ERROR ;
		    } finally {
		    	if (Config.useDataSource) {
					try {
						if (con != null) con.close();
					} catch (Exception e) {
						LoggingWriter.setLogError("M606S040100E101()","==== finally ===="+ e.getMessage());
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
		ApprovalActionNo ActionNo;
		QueueProcessing Queue = new QueueProcessing();
		String gRegNo="";
		try {
			con = JDBCConnectionPool.getConnection();

			// 클라이언트로 부터 받은 파라미터를 옮겨 담는다.
			String rcvData = (String)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			
			// 클라이언트로 부터 받은 파라미터를 쪼개어서 배열에 담는다. returnStringBuffer
			String[][] c_paramArray = CommonFunction.getConvString2DoubleArray(rcvData);
			
//			ActionNo = new ApprovalActionNo();
//			gRegNo = ActionNo.getActionNo(con,c_paramArray[0][0],c_paramArray[0][1],c_paramArray[0][2], "Regist",c_paramArray[0][4]);	//GV_JSPPAGE(action Page), User ID, prefix
//			getActionNo(Connection  con, String jspPage, String user_id, String prefix, String actionGubun, String detail_seq)

			String sql = new StringBuilder()
					.append("UPDATE \n")
					.append("	tbi_doc_distribut_info\n")
					.append("SET\n")
					.append("	due_date = '"			+ c_paramArray[0][5] +"' ,\n")
					.append("	dist_target = '"		+ c_paramArray[0][6] + "' ,\n")
					.append("	dept_cd = '"		+ c_paramArray[0][7] + "'\n")
					.append("WHERE \n")
					.append("	gubun = '"				+ c_paramArray[0][0] + "' AND\n")
					.append("	distribute_no = '"		+ c_paramArray[0][1] + "' AND\n")
					.append("	document_no = '"		+ c_paramArray[0][2]+"' AND\n")
					.append("	regist_no = '"			+ c_paramArray[0][3]+ "' AND\n")
					.append("	regist_no_rev = '"		+ c_paramArray[0][4] + "' AND\n")
					.append("	member_key = '"			+ c_paramArray[0][8] + "' \n")
					.toString();

			resultInt = super.excuteUpdate(con, sql.toString());
			if (resultInt < 0) {
				return EventDefine.E_DOEXCUTE_ERROR ;
			}
			
		} catch(Exception e) {
			LoggingWriter.setLogError("M606S040100E102()","==== SQL ERROR ===="+ e.getMessage() + "\n" + sql.toString());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M606S040100E102()","==== finally ===="+ e.getMessage());
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
		ApprovalActionNo ActionNo;
		QueueProcessing Queue = new QueueProcessing();
		String gRegNo="";
		try {
			con = JDBCConnectionPool.getConnection();

			// 클라이언트로 부터 받은 파라미터를 옮겨 담는다.
			String rcvData = (String)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			
			// 클라이언트로 부터 받은 파라미터를 쪼개어서 배열에 담는다. returnStringBuffer
			String[][] c_paramArray = CommonFunction.getConvString2DoubleArray(rcvData);
			
//			ActionNo = new ApprovalActionNo();
//			gRegNo = ActionNo.getActionNo(con,c_paramArray[0][0],c_paramArray[0][1],c_paramArray[0][2], "Regist",c_paramArray[0][4]);	//GV_JSPPAGE(action Page), User ID, prefix
//			getActionNo(Connection  con, String jspPage, String user_id, String prefix, String actionGubun, String detail_seq)

			String sql = new StringBuilder()
					.append("DELETE FROM \n")
					.append("	tbi_doc_distribut_info\n")
					.append("WHERE \n")
					.append("	gubun = '" + c_paramArray[0][0] + "' AND\n")
					.append("	distribute_no = '" + c_paramArray[0][1] + "' AND\n")
					.append("	document_no = '" + c_paramArray[0][2] + "' AND\n")
					.append("	regist_no = '" + c_paramArray[0][3] + "' AND\n")
					.append("	regist_no_rev = '" + c_paramArray[0][4] + "' AND\n")
					.append("	member_key = '" + c_paramArray[0][5] + "'\n")
					.toString();

			resultInt = super.excuteUpdate(con, sql.toString());
			if (resultInt < 0) {
				return EventDefine.E_DOEXCUTE_ERROR ;
			}
			
		} catch(Exception e) {
			LoggingWriter.setLogError("M606S040100E103()","==== SQL ERROR ===="+ e.getMessage() + "\n" + sql.toString());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M606S040100E103()","==== finally ===="+ e.getMessage());
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
	
	// 배포된 문서 조회
	public int E104(InoutParameter ioParam) {
		resultInt = EventDefine.E_DOEXCUTE_INIT;

		try {
			con = JDBCConnectionPool.getConnection();

			// 클라이언트로 부터 받은 파라미터를 옮겨 담는다.
			String rcvData = (String) ((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			// 클라이언트로 부터 받은 파라미터를 쪼개어서 배열에 담는다. 
			// rcvData = [위경도]
			String[][] c_paramArray = CommonFunction.getConvString2DoubleArray(rcvData);

			String sql = new StringBuilder()
					.append("SELECT \n")
					.append("B.gubun_code,\n")
					.append("A.document_no,\n")
					.append("B.document_name,\n")
					.append("A.file_view_name,\n")
					.append("distribute_no,\n")
					.append("A.regist_no,\n")
					.append("A.regist_no_rev,\n")
					.append("dist_date,\n")
					.append("due_date,\n")
					.append("dist_target,\n")
					.append("dept_cd, \n")
					.append("A.document_no_rev, \n")
					.append("C.file_real_name \n")
					.append("FROM tbi_doc_distribut_info A \n")
					.append("INNER JOIN tbm_doc_base B\n")
					.append("	ON A.document_no = B.document_no\n")
					.append("	AND A.document_no_rev = B.revision_no\n")
					.append("	AND A.member_key = B.member_key\n")
					.append("INNER JOIN tbi_order_doclist C\n")
					.append("	ON A.regist_no = C.regist_no\n")
					.append("   AND A.regist_no_rev = C.regist_no_rev\n")
					.append("   AND A.document_no = C.document_no\n")
					.append("   AND A.document_no_rev = C.document_no_rev\n")
					.append("	AND A.member_key = C.member_key\n")
					.append("WHERE gubun like '" + c_paramArray[0][0] + "%' \n"
							+ "AND A.member_key = '" + c_paramArray[0][1] + "' \n"
							+ "AND due_date >= ( SELECT TO_CHAR (SYSDATE,  'yyyy-mm-dd') )\n")
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
			LoggingWriter.setLogError("M606S040100E104()", "==== SQL ERROR ====" + e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR;
		} finally {
			if (Config.useDataSource) {
				try {
					if (con != null)
						con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M606S040100E104()","==== finally ===="+ e.getMessage());
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

	//등록 페이지가 조회할 메소드 
	public int E105(InoutParameter ioParam) {
		resultInt = EventDefine.E_DOEXCUTE_INIT;

		try {
			con = JDBCConnectionPool.getConnection();

//			// 클라이언트로 부터 받은 파라미터를 옮겨 담는다.
//			String rcvData = (String) ((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
//			// 클라이언트로 부터 받은 파라미터를 쪼개어서 배열에 담는다.
//			// rcvData = [위경도]
//			String[][] c_paramArray = CommonFunction.getConvString2DoubleArray(rcvData);

			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			
			String sql = new StringBuilder()
					.append("SELECT * FROM\n")
					.append("        ( SELECT        C.gubun_code,\n")
					.append("                                A.document_no,\n")
					.append("                                C.document_name,\n")
					.append("                                A.file_view_name,\n")
					.append("                                '' AS distribute_no ,\n")
					.append("                                B.regist_no,\n")
					.append("                                B.revision_no,\n")
					.append("                                '' AS dist_date,\n")
					.append("                                '' AS due_date,\n")
					.append("                                '' AS dist_target,\n")
					.append("                                '' AS dept_cd,\n")
					.append("                                A.document_no_rev,\n")
					.append("                                A.file_real_name,\n")
					.append("                                A.member_key\n")
					.append("                FROM tbi_order_doclist A   INNER JOIN           tbi_doc_regist_info B\n")
					.append("                        ON              A.regist_no = B.regist_no\n")
					.append("                        AND             A.regist_no_rev = B.revision_no\n")
					.append("                        AND             A.document_no = B.document_no\n")
					.append("                        AND                     A.member_key = B.member_key\n")
					.append("                                          INNER JOIN tbm_doc_base C\n")
					.append("                        ON              A.document_no = C.document_no\n")
					.append("                        AND                     A.member_key = C.member_key\n")
					.append("                WHERE   ( A.order_no NOT IN (SELECT DISTINCT A.order_no\n")
					.append("                                                   FROM  tbi_order_doclist A INNER JOIN tbi_doc_distribut_info B\n")
					.append("                                                                ON A.regist_no = B.regist_no\n")
					.append("                                                                AND A.document_no = B.document_no\n")
					.append("                                                                AND A.regist_no_rev = B.regist_no_rev\n")
					.append("                                                                                AND A.member_key = B.member_key\n")
					.append("                                                   WHERE B.due_date  >=  ( SELECT TO_CHAR (SYSDATE,  'yyyy-mm-dd') )\n")
					.append("                                                                         AND A.member_key = '" + jArray.get("member_key") + "'\n")
					.append("                                                   )\n")
					.append("                                 AND   A.member_key = '" + jArray.get("member_key") + "'\n")
					.append("                   ) OR (   A.regist_no NOT IN (SELECT DISTINCT A.regist_no\n")
					.append("                                                    FROM  tbi_order_doclist A INNER JOIN tbi_doc_distribut_info B\n")
					.append("                                                        ON A.regist_no = B.regist_no\n")
					.append("                                                        AND A.document_no = B.document_no\n")
					.append("                                                        AND A.regist_no_rev = B.regist_no_rev\n")
					.append("                                                                                AND A.member_key = B.member_key\n")
					.append("                                                    WHERE B.due_date  >=  ( SELECT TO_CHAR (SYSDATE,  'yyyy-mm-dd') )\n")
					.append("                                                                         AND A.member_key = '" + jArray.get("member_key") + "'\n")
					.append("                                                   )\n")
					.append("                              AND   A.member_key = '" + jArray.get("member_key") + "'\n")
					.append("                     )\n")
					.append("                ORDER BY B.revision_no) AS AA\n")
					.append("GROUP BY AA.gubun_code , AA.document_no , AA.regist_no\n")
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
			LoggingWriter.setLogError("M606S040100E105()", "==== SQL ERROR ====" + e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR;
		} finally {
			if (Config.useDataSource) {
				try {
					if (con != null)
						con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M606S040100E105()","==== finally ===="+ e.getMessage());
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
	
	//삭제 , 수정을 위해 가져와야할 쿼리
	public int E106(InoutParameter ioParam) {
		resultInt = EventDefine.E_DOEXCUTE_INIT;

		try {
			con = JDBCConnectionPool.getConnection();

			// 클라이언트로 부터 받은 파라미터를 옮겨 담는다.
			String rcvData = (String) ((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			// 클라이언트로 부터 받은 파라미터를 쪼개어서 배열에 담는다.
			// rcvData = [위경도]
			String[][] c_paramArray = CommonFunction.getConvString2DoubleArray(rcvData);

			String sql = new StringBuilder()
					.append("SELECT \n")
					.append("	gubun,\n")
					.append("	distribute_no,\n")
					.append("	A.document_no,\n")
					.append("	B.document_name,\n")
					.append("	file_view_name,\n")
					.append("	regist_no,\n")
					.append("	regist_no_rev,\n")
					.append("	dist_date,\n")
					.append("	due_date,\n")
					.append("	dist_target,\n")
					.append("	dept_cd\n")
					.append("FROM tbi_doc_distribut_info A \n")
					.append("INNER JOIN tbm_doc_base B \n")
					.append("	ON A.document_no=B.document_no\n")
					.append("	AND A.document_no_rev=B.revision_no\n")
					.append("	AND A.member_key=B.member_key\n")
					.append("WHERE \n")
					.append("	distribute_no =	'"+ c_paramArray[0][0] +"' AND \n")
					.append("	gubun =			'"+ c_paramArray[0][1] +"' AND \n")
					.append("	A.document_no =	'"+ c_paramArray[0][2] +"' AND \n")
					.append("	regist_no =		'"+ c_paramArray[0][3] +"' AND \n")
					.append("	regist_no_rev =	'"+ c_paramArray[0][4] +"' AND \n")
					.append("	A.member_key =	'"+ c_paramArray[0][5] +"'\n")
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
			LoggingWriter.setLogError("M606S040100E106()", "==== SQL ERROR ====" + e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR;
		} finally {
			if (Config.useDataSource) {
				try {
					if (con != null)
						con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M606S040100E106()","==== finally ===="+ e.getMessage());
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

	
	// 배포된 문서 조회
		public int E804(InoutParameter ioParam) {
			resultInt = EventDefine.E_DOEXCUTE_INIT;

			try {
				con = JDBCConnectionPool.getConnection();

				// 클라이언트로 부터 받은 파라미터를 옮겨 담는다.
				String rcvData = (String) ((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
				// 클라이언트로 부터 받은 파라미터를 쪼개어서 배열에 담는다. 
				// rcvData = [위경도]
				String[][] c_paramArray = CommonFunction.getConvString2DoubleArray(rcvData);

				String sql = new StringBuilder()
						.append("SELECT \n")
						.append("B.gubun_code,\n")
						.append("A.document_no,\n")
						.append("B.document_name,\n")
						.append("file_view_name,\n")
						.append("distribute_no,\n")
						.append("regist_no,\n")
						.append("regist_no_rev,\n")
						.append("dist_date,\n")
						.append("due_date,\n")
						.append("dist_target,\n")
						.append("dept_cd, \n")
						.append("A.document_no_rev, \n")
						.append("file_real_name \n")
						.append("FROM\n")
						.append("tbi_doc_distribut_info A INNER JOIN tbm_doc_base B\n")
						.append("ON A.document_no = B.document_no\n")
						.append("WHERE gubun like '" + c_paramArray[0][0] + "%' \n"
								+ " AND member_key = '" + c_paramArray[0][1] + "' \n"
								+ " AND due_date >= ( SELECT TO_CHAR (SYSDATE,  'yyyy-mm-dd') )\n")
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
				LoggingWriter.setLogError("M606S040100E804()", "==== SQL ERROR ====" + e.getMessage());
				return EventDefine.E_DOEXCUTE_ERROR;
			} finally {
				if (Config.useDataSource) {
					try {
						if (con != null)
							con.close();
					} catch (Exception e) {
						LoggingWriter.setLogError("M606S040100E804()","==== finally ===="+ e.getMessage());
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