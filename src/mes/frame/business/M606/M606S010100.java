package mes.frame.business.M606;

import java.lang.reflect.Method;
import java.sql.Connection;
import java.sql.PreparedStatement;

import org.json.simple.JSONObject;

import mes.client.conf.Config;
import mes.frame.common.ApprovalActionNo;
import mes.frame.common.EventDefine;
import mes.frame.common.HashObject;
import mes.frame.common.MessageDefine;
import mes.frame.common.QueueProcessing;
import mes.frame.database.JDBCConnectionPool;
import mes.frame.database.SqlAdapter;
import mes.frame.serviceinterface.InoutParameter;
import mes.frame.serviceinterface.LoggingWriter;
import mes.frame.util.CommonFunction;


public class M606S010100 extends SqlAdapter{
	Connection con = null;
	PreparedStatement pstmt = null;
	String resultString = "";
	int resultInt = -1;
	StringBuffer sql = new StringBuffer();
	
	String[][] v_paramArray = new String[0][0]; 
	Class[] optClass = null;
	Object[] optObj = null;
	Object obj = null;
	
	public M606S010100(){
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
	public int doExcute(InoutParameter ioParam){
		long startTime = System.currentTimeMillis();
		int doExcute_result = EventDefine.E_DOEXCUTE_INIT;;
		String event = ioParam.getEventSubID();
		
	    try{
            optClass = new Class[1];
			optClass[0] = ioParam.getClass() ;
			optObj = new Object[1];
			optObj[0] = ioParam;
			
			Method method = M606S010100.class.getMethod(event,optClass);
			LoggingWriter.setLogDebug(M606S010100.class.getName(),"==== " + event + " EventMethod Create Success ====");

			obj = method.invoke(M606S010100.class.newInstance(),optObj);
			doExcute_result = CommonFunction.getInt(obj.toString());
			
	    } catch (Exception ex) {
	    	doExcute_result = EventDefine.E_DOEXCUTE_INIT;
			ioParam.setMessage(MessageDefine.M_NO_EVENTID);
			LoggingWriter.setLogError(M606S010100.class.getName(),"==== EventID Not define : EVENT ID [ " + ioParam.getEventID() + "]");
	    } finally {
	    	obj = null;
			optClass = null;
			optObj = null;
	    }
	    long endTime = System.currentTimeMillis();
		long runningTime = endTime - startTime;
		LoggingWriter.setLogAll(M606S010100.class.getName(),"==== Query [수행시간  : " + runningTime + " ms]");
		
		return doExcute_result;
	}

	public int E101(InoutParameter ioParam){

		String sql = "";
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			con.setAutoCommit(false);

			String rcvData = (String)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			String[][] c_paramArray = CommonFunction.getConvString2DoubleArray(rcvData);

			/*
			1.jspPage
			2.user_id
			3.getnum_prefix
			4.orderno
			5.lotno
			6.reg_reason
			7.docname
			8.doccode
			9.rev_no
			10.doc_gubun
			11.external_doc
			12.total_page
			13.keep_yn
			14.gwanribon_yn
			15.DocGubunReg
			16.external_doc_source
			17.member_key
			*/
			
			sql = new StringBuilder()
					.append("INSERT INTO							\n")
					.append("	tbi_doc_regist_info (		        \n")
					.append("		reg_gubun,				        \n")
					.append("		regist_no,				        \n")
					.append("		document_no,			        \n")
					.append("		file_view_name,			        \n")
					.append("		regist_reason_code,		        \n")
					.append("		document_no_rev,		        \n")
					.append("		file_real_name,			        \n")
					.append("		external_doc_yn,		        \n")
					.append("		total_page,				        \n")
					.append("		keep_yn,				        \n")
					.append("		gwanribon_yn,			        \n")
					.append("		external_doc_source,	        \n")
					.append("		member_key				        \n")
					.append("	)									\n")
					.append("VALUES ( 								\n")
					.append(" 		'" + c_paramArray[0][16] + "', 	\n")	//reg_gubun
					.append(" 		'" + c_paramArray[0][19] + "', 	\n") 	//regist_no
					.append(" 		'" + c_paramArray[0][7] + "', 	\n")	//document_no
					.append(" 		'" + c_paramArray[0][10] + "',	\n") 	//file_view_name 
					.append(" 		'" + c_paramArray[0][5] + "', 	\n") 	//regist_reason_code
					.append(" 		'" + c_paramArray[0][8] + "', 	\n") 	//Doc_code_revision_no
					.append(" 		'" + c_paramArray[0][11] + "', 	\n") 	//file_real_name
					.append(" 		'" + c_paramArray[0][12] + "', 	\n") 	//external_doc_yn
					.append(" 		" + c_paramArray[0][13] + ", 	\n") 	//total_page
					.append(" 		'" + c_paramArray[0][14] + "', 	\n") 	//keep_yn
					.append(" 		'" + c_paramArray[0][15] + "', 	\n") 	//gwanribon_yn
					.append(" 		'" + c_paramArray[0][17] + "', 	\n") 	//external_doc_source
					.append(" 		'" + c_paramArray[0][18] + "' 	\n") 	//member_key
					.append(" 	) 									\n")
					.toString();
			
			resultInt = super.excuteUpdate(con, sql);
			if (resultInt < 0) {
				con.rollback();
				return EventDefine.E_DOEXCUTE_ERROR ;
			}
			
			con.commit();
		} catch(Exception e) {
			LoggingWriter.setLogError("M606S010100E101()","==== SQL ERROR ===="+ e.getMessage() + "\n" + sql.toString());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M606S010100E101()","==== finally ===="+ e.getMessage());
				}
	    	} else {
	    	}
	    }
		ioParam.setResultString(resultString);
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
	    return EventDefine.E_QUERY_RESULT;
	}	

	public int E102(InoutParameter ioParam){

		String sql ="";
		resultInt = EventDefine.E_DOEXCUTE_INIT;

		try {
			con = JDBCConnectionPool.getConnection();
			String rcvData = (String)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			String[][] c_paramArray = CommonFunction.getConvString2DoubleArray(rcvData);
			
			sql = new StringBuilder()
				.append(" UPDATE					\n")
				.append("	tbi_doc_regist_info		\n")
				.append(" SET						\n")
				.append("		external_doc_yn = 		'" 	+ c_paramArray[0][4] + "'	\n")
				.append("		,keep_yn = 				'" 	+ c_paramArray[0][5] + "'	\n")
				.append("		,gwanribon_yn = 		'" 	+ c_paramArray[0][6] + "'	\n")
				.append("		,total_page = 			'" 	+ c_paramArray[0][7] + "'	\n")
				.append("		,modify_user_id = 		'" 	+ c_paramArray[0][8] + "'	\n")
				.append("		,external_doc_source = 	'" 	+ c_paramArray[0][10] + "'	\n")
				.append("		,reg_gubun = 			'" 	+ c_paramArray[0][11] + "'	\n")
				.append("		,modify_reason = 		'" 	+ c_paramArray[0][12] + "'	\n")
				.append("		,modify_date = 			SYSDATETIME	\n")
				.append(" WHERE regist_no = 			'" 	+ c_paramArray[0][0] + "'	\n") //'DOC18-000011'
				.append(" 	AND revision_no =		 	'" 	+ c_paramArray[0][1] + "'	\n") //'0'
				.append(" 	AND document_no = 			'" 	+ c_paramArray[0][2] + "'	\n") //'PSQM-01'
				.append(" 	AND reg_gubun = 			'"  + c_paramArray[0][9] + "'	\n")
				.append(" 	AND member_key = 			'"  + c_paramArray[0][13] + "'	\n")
				 //'PSQM-01'
				//.append(" 	AND A.file_view_name = '" 	+ c_paramArray[0][3] + "'	\n") //'A80A80708801 회로카드조립체(AMLCD용) QC공정도 Rev.02.xls'
				.toString();
			
			resultInt = super.excuteUpdate(con, sql.toString());
			if (resultInt < 0) {
				return EventDefine.E_DOEXCUTE_ERROR ;
			}
			
		} catch(Exception e) {
			LoggingWriter.setLogError("M606S010100E102()","==== SQL ERROR ===="+ e.getMessage() + "\n" + sql.toString());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M606S010100E102()","==== finally ===="+ e.getMessage());
				}
	    	} else {
	    	}
	    }
		ioParam.setResultString(resultString);
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
	    return EventDefine.E_QUERY_RESULT;
	}	

	public int E122(InoutParameter ioParam){

		String sql = "";
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		try {
			con = JDBCConnectionPool.getConnection();
			con.setAutoCommit(false);

			String rcvData = (String)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			String[][] c_paramArray = CommonFunction.getConvString2DoubleArray(rcvData);
			
			sql = new StringBuilder()
				.append("INSERT INTO\n")
				.append("	tbi_doc_regist_info (	\n")
				.append("		reg_gubun,			\n")//0
				.append("		regist_no,			\n")//1
				.append("		revision_no,		\n")//2
				.append("		document_no,		\n")//3
				.append("		document_no_rev,	\n")//4
				.append("		file_view_name,		\n")//5
				.append("		file_real_name,		\n")//6
				.append("		external_doc_yn,	\n")//7
				.append("		external_doc_source,\n")//8
				.append("		total_page,			\n")//9
				.append("		gwanribon_yn,		\n")//10
				.append("		keep_yn,			\n")//11
				.append("		regist_reason_code,	\n")//12
				.append("		modify_user_id,		\n")//13
				.append("		modify_date,		\n")//14
				.append("		member_key			\n")//15
				.append("	)		\n")
				.append("VALUES ( 	\n")
				.append(" 		 '" + c_paramArray[0][16] + "' 	\n")//0
				.append(" 		,'" + c_paramArray[0][18] + "' 	\n")//1
				.append(" 		,'" + c_paramArray[0][19] + "' 	\n")	
				.append(" 		,'" + c_paramArray[0][20] + "' 	\n")//3
				.append(" 		,'" + c_paramArray[0][8]  + "'	\n")//4
				.append(" 		,'" + c_paramArray[0][21] + "' 	\n")//5
				.append(" 		,'" + c_paramArray[0][11] + "' 	\n")//6
				.append(" 		,'" + c_paramArray[0][12] + "' 	\n")//7
				.append(" 		,'" + c_paramArray[0][17] + "' 	\n")//8
				.append(" 		,'" + c_paramArray[0][13] + "' 	\n")//9
				.append(" 		,'" + c_paramArray[0][15] + "' 	\n")//10
				.append(" 		,'" + c_paramArray[0][14] + "' 	\n")//11
				.append(" 		,'" + c_paramArray[0][5]  + "' 	\n")//12
				.append(" 		,'" + c_paramArray[0][1]  + "' 	\n")//13
				.append(" 		, SYSDATETIME 	\n")//14
				.append(" 		,'" + c_paramArray[0][23]  + "' \n")//15
				.append(" 	) \n")
				.toString();
						
			resultInt = super.excuteUpdate(con, sql);
			if (resultInt < 0) {
				con.rollback();
				return EventDefine.E_DOEXCUTE_ERROR ;
			}
			if(c_paramArray[0][3].length()>10) {
				sql = new StringBuilder()
					.append("UPDATE					\n")
					.append("	tbi_order_doclist	\n")
					.append("SET regist_no_rev = '" 		+ c_paramArray[0][19] +"' \n")
					.append(" 	,file_real_name = '" 		+ c_paramArray[0][11] +"' \n")
					.append("WHERE  reg_gubun = '" 			+ c_paramArray[0][16] + "'\n")
					.append("	AND order_no = '" 			+ c_paramArray[0][3]  + "'\n")
					.append("	AND lotno = '" 				+ c_paramArray[0][4]  + "'\n")
					.append("	AND regist_no = '" 			+ c_paramArray[0][18] + "'\n")
					.append("	AND regist_no_rev = '" 		+ c_paramArray[0][22] + "'\n") //pre_revision_no개정전 개정번호
					.append("	AND document_no = '" 		+ c_paramArray[0][20] + "'\n")
					.append("	AND document_no_rev = '" 	+ c_paramArray[0][8]  + "'\n")
					.append("	AND member_key = '" 		+ c_paramArray[0][23]  + "'\n")
					.toString();

				resultInt = super.excuteUpdate(con, sql);
				if (resultInt < 0) {
					con.rollback();
					return EventDefine.E_DOEXCUTE_ERROR ;
				}
			}
			con.commit();
			
		} catch(Exception e) {
			e.getStackTrace();
			LoggingWriter.setLogError("M606S010100E122()","==== SQL ERROR ===="+ e.getMessage() + "\n" + sql.toString());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M606S010100E122()","==== finally ===="+ e.getMessage());
				}
	    	} else {
	    	}
	    }
		ioParam.setResultString(resultString);
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
	    return EventDefine.E_QUERY_RESULT;
	}	

	public int E103(InoutParameter ioParam){

		String sql ="";
		resultInt = EventDefine.E_DOEXCUTE_INIT;

		try {
			con = JDBCConnectionPool.getConnection();

			con.setAutoCommit(false);
			String rcvData = (String)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			    		
			String[][] c_paramArray = CommonFunction.getConvString2DoubleArray(rcvData);

			sql = new StringBuilder()
				.append(" DELETE FROM											\n")
				.append("	tbi_doc_regist_info									\n")
				.append(" WHERE regist_no = '" 	+ c_paramArray[0][0] + "'		\n") //'DOC18-000011'
				.append(" 	AND document_no = '" 	+ c_paramArray[0][2] + "'	\n") //'PSQM-01'
				.append(" 	AND reg_gubun = '" 		+ c_paramArray[0][9] + "'	\n") //'DOCREG01'
				.append(" 	AND member_key = '" 	+ c_paramArray[0][11] + "'	\n") 
				.toString();
			
			resultInt = super.excuteUpdate(con, sql.toString());
			if (resultInt < 0) {
				con.rollback();
				return EventDefine.E_DOEXCUTE_ERROR ;
			}
			sql = new StringBuilder()
				.append(" DELETE FROM											\n")
				.append("	tbi_order_doclist									\n")
				.append(" WHERE regist_no = '" 	+ c_paramArray[0][0] + "'		\n") //'DOC18-000011'
				.append(" 	AND member_key = '" 	+ c_paramArray[0][11] + "'	\n") 
				.toString();
			
			resultInt = super.excuteUpdate(con, sql.toString());
			if (resultInt < 0) {
				con.rollback();
				return EventDefine.E_DOEXCUTE_ERROR ;
			}
			con.commit();		
		} catch(Exception e) {
			LoggingWriter.setLogError("M606S010100E103()","==== SQL ERROR ===="+ e.getMessage() + "\n" + sql.toString());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M606S010100E103()","==== finally ===="+ e.getMessage());
				}
	    	} else {
	    	}
	    }
		ioParam.setResultString(resultString);
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
	    return EventDefine.E_QUERY_RESULT;
	}	

	public int E111(InoutParameter ioParam){

		String sql ="";
		resultInt = EventDefine.E_DOEXCUTE_INIT;

		try {
			con = JDBCConnectionPool.getConnection();
			con.setAutoCommit(false);

			String rcvData = (String)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			String[][] c_paramArray = CommonFunction.getConvString2DoubleArray(rcvData);

			sql = new StringBuilder()
				.append("INSERT INTO\n")
				.append("	tbi_doc_regist_info (	\n")
				.append("		reg_gubun,		\n")
				.append("		regist_no,			\n")
				.append("		document_no,		\n")
				.append("		file_view_name,		\n")
				.append("		regist_reason_code,	\n")
				.append("		document_no_rev,	\n")
				.append("		file_real_name,		\n")
				.append("		member_key			\n")
				.append("	)		\n")
				.append("VALUES ( 	\n")
				.append(" 		 '" + c_paramArray[0][16] + "' 	\n") 	//file_real_name
				.append(" 		,'" + c_paramArray[0][19] + "' 	\n") 	//regist_no
				.append(" 		,'" + c_paramArray[0][7] + "' 	\n")	//document_no
				.append(" 		,'" + c_paramArray[0][10] + "'	\n") 	//file_view_name 
				.append(" 		,'" + c_paramArray[0][5] + "' 	\n") 	//regist_reason_code
				.append(" 		,'" + c_paramArray[0][8] + "' 	\n") 	//Doc_code_revision_no
				.append(" 		,'" + c_paramArray[0][11] + "' 	\n") 	//file_real_name
				.append(" 		,'" + c_paramArray[0][18] + "' 	\n") 	//member_key
				.append(" 	) \n")
				.toString();

			resultInt = super.excuteUpdate(con, sql.toString());
			if (resultInt < 0) {
				con.rollback();
				return EventDefine.E_DOEXCUTE_ERROR ;
			}
			
			sql = new StringBuilder()
				.append("INSERT INTO\n")
				.append("	tbi_order_doclist (	\n")
				.append("		reg_gubun,		\n")
				.append("		order_no,		\n")
				.append("		lotno,			\n")
				.append("		regist_no,		\n")
				.append("		document_no,	\n")
				.append("		document_no_rev,	\n")
				.append("		file_real_name,	\n")
				.append("		file_view_name,	\n")
				.append("		member_key	 	\n")
				.append("	)\n")
				.append("VALUES\n")
				.append("	(\n")
				.append(" 		 '" + c_paramArray[0][16] + "' 	\n") //reg_gubun 
				.append(" 		,'" + c_paramArray[0][3] + "' 	\n") //order_no
				.append(" 		,'" + c_paramArray[0][4] + "' 	\n") //lotno
				.append(" 		,'" + c_paramArray[0][19] + "' 	\n") //regist_no
		//		.append(" 		,'" + gRegNo + "' 				\n") //regist_no
				.append(" 		,'" + c_paramArray[0][7] + "' 	\n") //document_no
				.append(" 		,'" + c_paramArray[0][8] + "' 	\n") 	//Doc_code_revision_no
				.append(" 		,'" + c_paramArray[0][11] + "' 	\n") //file_real_name
				.append(" 		,'" + c_paramArray[0][10] + "' 	\n") //file_view_name
				.append(" 		,'" + c_paramArray[0][18] + "' 	\n") //member_key
				.append("	);\n")
				.toString();

			resultInt = super.excuteUpdate(con, sql.toString());
			if (resultInt < 0) {
				con.rollback();
				return EventDefine.E_DOEXCUTE_ERROR ;
			}
			con.commit();
			
		} catch(Exception e) {
			LoggingWriter.setLogError("M606S010100E111()","==== SQL ERROR ===="+ e.getMessage() + "\n" + sql.toString());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M606S010100E111()","==== finally ===="+ e.getMessage());
				}
	    	} else {
	    	}
	    }
		ioParam.setResultString(resultString);
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
	    return EventDefine.E_QUERY_RESULT;
	}	

	// 이력조건에 해당하는 거래처 목록을 GROUP BY 검색한다. 
	public int E104(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject(); // JSONObject 선언
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			
			String sql = new StringBuilder()
					.append("SELECT * FROM                                                          \n")                
					.append("(SELECT	A.reg_gubun,                                                \n")
					.append("        	A.document_no,                                              \n")
					.append("        	B.document_name,                                            \n")
					.append("        	B.gubun_code,                                               \n")
					.append("        	V.code_name,                                                \n")
					.append("        	file_view_name,                                             \n")
					.append("        	A.regist_no,                                                \n")
					.append("        	A.revision_no,                                              \n")
					.append("	        file_real_name,                                             \n")
					.append("	        external_doc_yn,                                            \n")
					.append("	        regist_reason_code,                                         \n")
					.append("	        destroy_reason_code,                                        \n")
					.append("	        total_page,                                                 \n")
					.append("	        gwanribon_yn,                                               \n")
					.append("	        keep_yn,                                                    \n")
					.append("	        hold_yn,                                                    \n")
					.append("	        D.action_date AS regist_date,                               \n")
					.append("	        D.user_id AS regist_user_id,                                \n")
					.append("	        A.document_no_rev                                           \n")
					.append("			FROM tbi_doc_regist_info A                                  \n")
					.append("			INNER JOIN tbm_doc_base B                                   \n")
					.append("         		ON A.document_no = B.document_no                        \n")
					.append("         		AND A.member_key = B.member_key                         \n")
					.append("        	INNER JOIN tbi_approval_action D                            \n")
					.append("          		ON A.regist_no = D.actionno								\n")
					.append("         		AND A.member_key = D.member_key							\n")
					.append("        	INNER JOIN v_doc_gubun V									\n")
					.append("        		ON B.gubun_code = V.code_value							\n")
					.append("         		AND B.member_key = V.member_key							\n")
					.append("        	WHERE B.gubun_code like '" + jArray.get("DocGubun") + "%'	\n")
					.append("        	  AND A.member_key = '" + jArray.get("member_key") + "'		\n")
					.append("        	ORDER BY A.revision_no DESC ) AS AA							\n")
					.append("GROUP BY AA.reg_gubun , AA.regist_no									\n")
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
			LoggingWriter.setLogError("M606S010100E104()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M606S010100E104()","==== finally ===="+ e.getMessage());
				}
	    	} else {
	    	}
	    }
		ioParam.setResultString(resultString);
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
    	ioParam.setMessage(MessageDefine.M_QUERY_OK);
	    return EventDefine.E_QUERY_RESULT;
	}
	
	//문서 수정을 위한 메소드
	public int E106(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			String rcvData = (String)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			String[][] c_paramArray = CommonFunction.getConvString2DoubleArray(rcvData);

			String sql = new StringBuilder()
					.append("SELECT\n")
					.append("        A.document_no,\n")
					.append("        B.document_name,\n")
					.append("        B.gubun_code,\n")
					.append("        V.code_name,\n")
					.append("        A.file_view_name as file_view_name,\n")
					.append("        A.regist_no,\n")
					.append("        A.revision_no,\n")
					.append("        file_real_name,\n")
					.append("        external_doc_yn,\n")
					.append("        regist_reason_code,\n")
					.append("        destroy_reason_code,\n")
					.append("        total_page,\n")
					.append("        gwanribon_yn,\n")
					.append("        keep_yn,\n")
					.append("        hold_yn,\n")
					.append("        d.action_date AS regist_date, \n")
					.append("        d.user_id AS  regist_user_id, \n")
					.append("        A.document_no_rev, \n")
					.append("        A.reg_gubun,\n")
					.append("        A.external_doc_source\n")
					.append(" FROM\n")
					.append("        tbi_doc_regist_info A\n")
					.append("        INNER JOIN tbm_doc_base B\n")
					.append("         ON A.document_no       	= B.document_no\n")
					.append("         AND A.member_key = B.member_key\n")
					.append("        INNER JOIN tbi_approval_action D \n")
					.append("         ON A.regist_no = D.actionno\n")
					.append("         AND A.member_key = D.member_key\n")
					.append("        INNER JOIN v_doc_gubun V\n")
					.append("     	  ON B.gubun_code = V.code_value\n")
					.append("         AND B.member_key = V.member_key\n")
					.append(" 	where A.regist_no = '" 	+ c_paramArray[0][0] + "'	\n") //'DOC18-000011'
					.append(" 	AND A.revision_no = '" 	+ c_paramArray[0][1] + "'	\n") //'0'
					.append(" 	AND A.document_no = '" 	+ c_paramArray[0][2] + "'	\n") //'PSQM-01'
					.append(" 	AND A.member_key = '" 	+ c_paramArray[0][4] + "'	\n") 
					//.append(" 	AND A.file_view_name = '" 	+ c_paramArray[0][3] + "'	\n") //'A80A80708801 회로카드조립체(AMLCD용) QC공정도 Rev.02.xls'
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
			LoggingWriter.setLogError("M606S010100E106()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M606S010100E106()","==== finally ===="+ e.getMessage());
				}
	    	} else {
	    	}
	    }
		ioParam.setResultString(resultString);
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
    	ioParam.setMessage(MessageDefine.M_QUERY_OK);
	    return EventDefine.E_QUERY_RESULT;
	}
	
	

	public int E204(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			String rcvData = (String)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			String[][] c_paramArray = CommonFunction.getConvString2DoubleArray(rcvData);
			
			String v_hdoc = "";
			if("838".equals(c_paramArray[0][4])) {
				v_hdoc="        INNER JOIN v_hdoc_gubun V\n";
			}
			else {
				v_hdoc="        INNER JOIN v_doc_gubun V\n";
			}
			
			String sql = new StringBuilder()
					.append("SELECT\n")
					.append("        A.document_no,\n")
					.append("        B.document_name,\n")
					.append("        B.gubun_code,\n")
					.append("        V.code_name,\n")
					.append("        A.file_view_name as file_view_name,\n")
					.append("        A.regist_no,\n")
					.append("        A.revision_no,\n")
					.append("        file_real_name,\n")
					.append("        external_doc_yn,\n")
					.append("        regist_reason_code,\n")
					.append("        destroy_reason_code,\n")
					.append("        total_page,\n")
					.append("        gwanribon_yn,\n")
					.append("        keep_yn,\n")
					.append("        hold_yn,\n")
					.append("        d.action_date AS regist_date, \n")
					.append("        d.user_id AS  regist_user_id, \n")
					.append("        A.document_no_rev, \n")
					.append("        A.reg_gubun,\n")
					.append("        A.external_doc_source\n")
					.append(" FROM\n")
					.append("        tbi_doc_regist_info A\n")
					.append("        INNER JOIN tbm_doc_base B\n")
					.append("         ON A.document_no = B.document_no\n")
					.append("         AND A.member_key = B.member_key\n")
					.append("        INNER JOIN tbi_approval_action D \n")
					.append("         ON A.regist_no = D.actionno\n")
					.append("         AND A.member_key = D.member_key\n")
					.append( v_hdoc )				
					.append("     ON B.gubun_code = V.code_value\n")
					.append(" where A.regist_no = '" 	+ c_paramArray[0][0] + "'	\n") //'DOC18-000011'
					.append(" 	AND A.revision_no = '" 	+ c_paramArray[0][1] + "'	\n") //'0'
					.append(" 	AND A.document_no = '" 	+ c_paramArray[0][2] + "'	\n") //'PSQM-01'
					.append(" 	AND A.member_key = '" 	+ c_paramArray[0][4] + "'	\n") 
					.toString();  

			resultString = super.excuteQueryString(con, sql.toString());
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M606S010100E204()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M606S010100E204()","==== finally ===="+ e.getMessage());
				}
	    	} else {
	    	}
	    }
		ioParam.setResultString(resultString);
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
    	ioParam.setMessage(MessageDefine.M_QUERY_OK);
	    return EventDefine.E_QUERY_RESULT;
	}

	public int E304(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			String rcvData = (String)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			String[][] c_paramArray = CommonFunction.getConvString2DoubleArray(rcvData);

			String sql = new StringBuilder()
					.append("SELECT\n")
					.append("        A.document_no,\n")
					.append("        B.document_name,\n")
					.append("        B.gubun_code,\n")
					.append("        V.code_name,\n")
					.append("        A.file_view_name,\n")
					.append("        A.regist_no,\n")
					.append("        A.revision_no,\n")
					.append("        file_real_name,\n")
					.append("        external_doc_yn,\n")
					.append("        regist_reason_code,\n")
					.append("        destroy_reason_code,\n")
					.append("        total_page,\n")
					.append("        gwanribon_yn,\n")
					.append("        keep_yn,\n")
					.append("        hold_yn,\n")
					.append("        d.action_date AS regist_date,\n") 
					.append("        d.user_id AS  regist_user_id, \n")
					.append("        A.document_no_rev \n")
					.append("FROM\n")
					.append("        tbi_doc_regist_info A\n")
					.append("        INNER JOIN tbm_doc_base B\n")
					.append("         ON A.document_no       	= B.document_no\n")
					.append("         AND A.member_key = B.member_key\n")
					.append("        INNER JOIN tbi_approval_action D \n")
					.append("          ON A.review_action_no = D.actionno\n")
					.append("         AND A.member_key = D.member_key\n")
					.append("        INNER JOIN v_doc_gubun V\n")
					.append("     ON B.gubun_code = V.code_value\n")
					.append("         AND B.member_key = V.member_key\n")

					.append("where B.gubun_code like '" 	+ c_paramArray[0][0] + "%'	\n")
					.append("and   D.action_process like '" 	+ c_paramArray[0][1] + "%'	\n")
					.append("and   A.member_key = '" 	+ c_paramArray[0][2] + "'	\n")
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
			LoggingWriter.setLogError("M606S010100E304()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M606S010100E304()","==== finally ===="+ e.getMessage());
				}
	    	} else {
	    	}
	    }
		ioParam.setResultString(resultString);
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
    	ioParam.setMessage(MessageDefine.M_QUERY_OK);
	    return EventDefine.E_QUERY_RESULT;
	}


	public int E404(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			String rcvData = (String)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			String[][] c_paramArray = CommonFunction.getConvString2DoubleArray(rcvData);

			String sql = new StringBuilder()
					.append("SELECT\n")
					.append("        A.document_no,\n")
					.append("        B.document_name,\n")
					.append("        B.gubun_code,\n")
					.append("        V.code_name,\n")
					.append("        A.file_view_name,\n")
					.append("        A.regist_no,\n")
					.append("        A.revision_no,\n")
					.append("        file_real_name,\n")
					.append("        external_doc_yn,\n")
					.append("        regist_reason_code,\n")
					.append("        destroy_reason_code,\n")
					.append("        total_page,\n")
					.append("        gwanribon_yn,\n")
					.append("        keep_yn,\n")
					.append("        hold_yn,\n")
					.append("        d.action_date AS regist_date,\n")
					.append("        d.user_id AS  regist_user_id, \n")
					.append("        A.document_no_rev \n")
					.append("FROM\n")
					.append("        tbi_doc_regist_info A\n")
					.append("        INNER JOIN tbm_doc_base B\n")
					.append("         ON A.document_no       	= B.document_no\n")
					.append("         AND A.member_key = B.member_key\n")
					.append("        INNER JOIN tbi_approval_action D \n")
					.append("         ON A.confirm_action_no = D.actionno\n")
					.append("         AND A.member_key = D.member_key\n")
					.append("        INNER JOIN v_doc_gubun V\n")
					.append("    	  ON B.gubun_code = V.code_value\n")
					.append("         AND B.member_key = V.member_key\n")
					.append("where B.gubun_code like '" 	+ c_paramArray[0][0] + "%'	\n")
					.append("and   D.action_process like '" 	+ c_paramArray[0][1] + "%'	\n")
					.append("and   A.member_key = '" 	+ c_paramArray[0][2] + "'	\n")
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
			LoggingWriter.setLogError("M606S010100E404()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M606S010100E404()","==== finally ===="+ e.getMessage());
				}
	    	} else {
	    	}
	    }
		ioParam.setResultString(resultString);
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
    	ioParam.setMessage(MessageDefine.M_QUERY_OK);
	    return EventDefine.E_QUERY_RESULT;
	}

 
	public int E804(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			
			String sql = new StringBuilder()
					.append("SELECT * FROM\n")
					.append("(SELECT A.document_no,\n")
					.append("        B.document_name,\n")
					.append("        B.gubun_code,\n")
					.append("        V.code_name,\n")
					.append("	     A.file_view_name,\n")
					.append("	     A.regist_no,\n")
					.append("	     A.revision_no,\n")
					.append("	     file_real_name,\n")
					.append("	     external_doc_yn,\n")
					.append("	     regist_reason_code,\n")
					.append("	     destroy_reason_code,\n")
					.append("	     total_page,\n")
					.append("	     gwanribon_yn,\n")
					.append("	     keep_yn,\n")
					.append("	     hold_yn,\n")
					.append("	     d.action_date AS regist_date,\n")
					.append("	     d.user_id AS  regist_user_id, \n")
					.append("        document_no_rev \n")
					.append("	FROM\n")
					.append("		tbi_doc_regist_info A\n")
					.append("	INNER JOIN tbm_doc_base B\n")
					.append("		ON A.document_no = B.document_no\n")
					.append("		AND A.member_key = B.member_key\n")
					.append("	INNER JOIN tbi_approval_action D\n")
					.append("		ON A.regist_no = D.actionno\n")
					.append("		AND A.member_key = D.member_key\n")
					.append("	INNER JOIN v_doc_gubun V								\n")
					.append("		ON B.gubun_code = V.code_value						\n")
					.append("		AND B.member_key = V.member_key						\n")
					.append("	WHERE B.gubun_code like '%'								\n")
					.append("	ORDER BY A.revision_no DESC) AS AA						\n")
					.append("WHERE A.member_key = '" + jArray.get("member_key") + "'	\n")
					.append("GROUP BY AA.regist_no										\n")
					.toString();

			String ActionCommand = ioParam.getActionCommand();
			if(ActionCommand.startsWith("doQueryTableFieldName")) {
				resultString = super.excuteQueryStringTableFieldName(con, sql.toString());
			} else {
				resultString = super.excuteQueryString(con, sql.toString());
			}
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M606S010100E804()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M606S010100E804()","==== finally ===="+ e.getMessage());
				}
	    	} else {
	    	}
	    }
		ioParam.setResultString(resultString);
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
    	ioParam.setMessage(MessageDefine.M_QUERY_OK);
	    return EventDefine.E_QUERY_RESULT;
	}
	
	public int E010(InoutParameter ioParam) {
	
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject(); // JSONObject 선언
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			
			sql = new StringBuffer();
				sql.append("INSERT INTO\n");
				sql.append("	tbi_doc_regist_info (	\n");
				sql.append("		reg_gubun,			\n");
				sql.append("		regist_no,			\n");
				sql.append("		document_no,		\n");
				sql.append("		file_view_name,		\n");
				sql.append("		regist_reason_code,	\n");
				sql.append("		document_no_rev,	\n");
				sql.append("		file_real_name,		\n");
				sql.append("		external_doc_yn,	\n");
				sql.append("		total_page,			\n");
				sql.append("		keep_yn,			\n");
				sql.append("		gwanribon_yn,		\n");
				sql.append("		external_doc_source,	\n");
				sql.append("		member_key			\n");
				sql.append("	)		\n");
				sql.append("VALUES ( 	\n");
				sql.append(" 		 '" + jArray.get("DocGubunReg") + "' 	\n");	//reg_gubun
				sql.append(" 		,'" + jArray.get("") + "' 				\n");	//regist_no
				sql.append(" 		,'" + jArray.get("doccode") + "' 		\n");	//document_no
				sql.append(" 		,'" + jArray.get("idFilename") + "'		\n"); 	//file_view_name 
				sql.append(" 		,'" + jArray.get("") + "' 				\n"); 	//regist_reason_code
				sql.append(" 		,'" + jArray.get("") + "' 				\n"); 	//Doc_code_revision_no
			    sql.append(" 		,'" + jArray.get("") + "' 				\n"); 	//file_real_name
				sql.append(" 		,'" + jArray.get("external_doc_yn") + "'\n"); 	//external_doc_yn
				sql.append(" 		,'" + jArray.get("total_page") + "' 	\n"); 	//total_page
				sql.append(" 		,'" + jArray.get("keep_yn") + "' 		\n"); 	//keep_yn
				sql.append(" 		,'" + jArray.get("gwanribon_yn") + "' 	\n"); 	//gwanribon_yn
				sql.append(" 		,'" + jArray.get("external_doc_source") + "'	\n"); 	//external_doc_source
				sql.append(" 		,'" + jArray.get("member_key") + "' 	\n"); 	//member_key
				sql.append(" 	) \n");
				
				resultInt = super.excuteUpdate(con, sql.toString());
				if (resultInt < 0) {
					con.rollback();
					return EventDefine.E_DOEXCUTE_ERROR ;
				}
				
				con.commit();
			} catch(Exception e) {
				LoggingWriter.setLogError("M606S010100E010()","==== SQL ERROR ===="+ e.getMessage() + "\n" + sql.toString());
				return EventDefine.E_DOEXCUTE_ERROR ;
		    } finally {
		    	if (Config.useDataSource) {
					try {
						if (con != null) con.close();
					} catch (Exception e) {
						LoggingWriter.setLogError("M606S010100E010()","==== finally ===="+ e.getMessage());
					}
		    	} else {
		    	}
		    }
			ioParam.setResultString(resultString);
			ioParam.setColumnCount("" + super.COLUMN_COUNT);
		    return EventDefine.E_QUERY_RESULT;
		}
}