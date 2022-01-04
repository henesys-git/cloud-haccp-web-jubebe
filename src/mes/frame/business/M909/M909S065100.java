package mes.frame.business.M909;

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


public class M909S065100 extends SqlAdapter{
	Connection con = null;
	PreparedStatement pstmt = null;
	String resultString = "";
	int resultInt = -1;
	StringBuffer sql = new StringBuffer();
	
	String[][] v_paramArray = new String[0][0]; 
	Class[] optClass = null;
	Object[] optObj = null;
	Object obj = null;
	
	public M909S065100(){
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

			Method method = M909S065100.class.getMethod(event,optClass);
			LoggingWriter.setLogDebug(M909S065100.class.getName(),"==== " + event + " EventMethod Create Success ====");

			obj = method.invoke(M909S065100.class.newInstance(),optObj);
			doExcute_result = CommonFunction.getInt(obj.toString());
			
	    } catch (Exception ex) {
	    	doExcute_result = EventDefine.E_DOEXCUTE_INIT;
			ioParam.setMessage(MessageDefine.M_NO_EVENTID);
			LoggingWriter.setLogError(M909S065100.class.getName(),"==== EventID Not define : EVENT ID [ " + ioParam.getEventID() + "]");
	    } finally {
	    	obj = null;
			optClass = null;
			optObj = null;
	    }
	    long endTime = System.currentTimeMillis();
		long runningTime = endTime - startTime;
		LoggingWriter.setLogAll(M909S065100.class.getName(),"==== Query [수행시간  : " + runningTime + " ms]");
		
		return doExcute_result;
	}
	
	// S909S065101.jsp
	public int E101(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;

		ApprovalActionNo ActionNo;
		String Prod_Doc_No="";
			
		try {
			con = JDBCConnectionPool.getConnection();
			
//			String[][] c_paramArray_Head=null;
//			String[][] c_paramArray_Detail=null;
			
    		// insert_update_delete_json.jsp에서 받아온 JSON데이터 처리
    		JSONObject jArray = new JSONObject();
    		jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
    		System.out.println("JSONObject jArray rcvData="+ jArray.toString());
    		// Object데이터에서 키값(param)으로 JSONArray데이터를 꺼낸다. (데이터묶음 하나일땐 생략)
    		JSONArray jjArray = (JSONArray) jArray.get("param");
    		System.out.println("데이터 묶음 개수 :::: " + jjArray.size());
    		
    		JSONObject jjjArray0 = (JSONObject)jjArray.get(0); // 0번째 데이터묶음
    		
			
//			String rcvData = (String)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
//			Vector resultVector = CommonFunction.getConvStringDamogjuk(rcvData);
			con.setAutoCommit(false);

//			c_paramArray_Head = (String[][])resultVector.get(0);//head table
//    		c_paramArray_Detail=(String[][])resultVector.get(1); //data table
    		
			
			if(jjjArray0.get("prod_doc_no").equals("ㅋ")) {
    			String jspPage = (String) jjjArray0.get("jsp_page");
	    		String user_id = (String) jjjArray0.get("user_id");
	    		String prefix = (String) jjjArray0.get("prefix");
	    		String actionGubun = "Regist";
	    		String detail_seq = (String) jjjArray0.get("detail_seq");
	    		String member_key = (String) jjjArray0.get("member_key");
				ActionNo = new ApprovalActionNo();
				Prod_Doc_No = ActionNo.getActionNo(con,jspPage,user_id,prefix,actionGubun,detail_seq,member_key);//GV_JSPPAGE(action Page), User ID, prefix
    		} else {
    			Prod_Doc_No = (String) jjjArray0.get("prod_doc_no");
    		}
			
			System.out.println("Prod_Doc_No 값은 = "+Prod_Doc_No);
			
			for(int i=0; i<jjArray.size(); i++) {   
				JSONObject jjjArray = (JSONObject)jjArray.get(i); // i번째 데이터묶음
				String sql = new StringBuilder()
						.append("MERGE INTO tbm_product_doc_master mm\n")
						.append("USING (\n")
						.append("	SELECT \n")
						.append("		 '" + Prod_Doc_No  				 + "' AS prod_doc_no\n")
						.append("		,'" + jjjArray.get("revision_no")  + "' AS revision_no\n")
						.append("		,'" + jjjArray.get("prod_cd")	 + "' AS prod_cd\n")
						.append("		,'" + jjjArray.get("prod_cd_rev")  + "' AS prod_cd_rev\n")
						.append("		,'" + jjjArray.get("document_no")  + "' AS document_no\n")
						.append("		,'" + jjjArray.get("document_no_rev")  + "' AS document_rev\n")
						.append("		,'" + jjjArray.get("reg_gubun")  + "' AS reg_gubun\n")
						.append("		,'" + jjjArray.get("regist_no")  + "' AS regist_no\n")
						.append("		,'" + jjjArray.get("regist_no_rev")  + "' AS regist_no_rev\n")
						.append("		,'" + jjjArray.get("file_view_name")  + "' AS file_view_name\n")
						.append("		,'" + jjjArray.get("file_real_name") + "' AS file_real_name\n")
						.append("		,'" + jjjArray.get("member_key") + "' AS member_key\n")
						.append("	FROM db_root ) mQ\n")
						.append("ON ( \n")
						.append("	mm.prod_doc_no=mQ.prod_doc_no\n")
						.append("	AND mm.revision_no=mQ.revision_no\n")
						.append("	AND mm.prod_cd=mQ.prod_cd\n")
						.append("	AND mm.prod_cd_rev=mQ.prod_cd_rev\n")
						.append("	AND mm.document_no=mQ.document_no\n")
						.append("	AND mm.document_rev=mQ.document_rev\n")
						.append("	AND mm.reg_gubun=mQ.reg_gubun\n")
						.append("	AND mm.regist_no=mQ.regist_no\n")
						.append("	AND mm.regist_no_rev=mQ.regist_no_rev\n")
						.append("	AND mm.member_key=mQ.member_key\n")
						.append(")\n")
						.append("WHEN MATCHED THEN\n")
						.append("	UPDATE SET \n")
						.append("		mm.prod_doc_no=mQ.prod_doc_no,\n")
						.append("		mm.revision_no=mQ.revision_no,\n")
						.append("		mm.prod_cd=mQ.prod_cd,\n")
						.append("		mm.prod_cd_rev=mQ.prod_cd_rev,\n")
						.append("		mm.document_no=mQ.document_no,\n")
						.append("		mm.document_rev=mQ.document_rev,\n")
						.append("		mm.reg_gubun=mQ.reg_gubun,\n")
						.append("		mm.regist_no=mQ.regist_no,\n")
						.append("		mm.regist_no_rev=mQ.regist_no_rev,\n")
						.append("		mm.file_view_name=mQ.file_view_name,\n")
						.append("		mm.file_real_name=mQ.file_real_name,\n")
						.append("		mm.member_key=mQ.member_key\n")
						.append("WHEN NOT MATCHED THEN\n")
						.append("	INSERT (\n")
						.append("		mm.prod_doc_no,\n")
						.append("		mm.revision_no,\n")
						.append("		mm.prod_cd,\n")
						.append("		mm.prod_cd_rev,\n")
						.append("		mm.document_no,\n")
						.append("		mm.document_rev,\n")
						.append("		mm.reg_gubun,\n")
						.append("		mm.regist_no,\n")
						.append("		mm.regist_no_rev,\n")
						.append("		mm.file_view_name,\n")
						.append("		mm.file_real_name,\n")
						.append("		mm.member_key\n")
						.append("	) VALUES (\n")
						.append("		mQ.prod_doc_no,\n")
						.append("		mQ.revision_no,\n")
						.append("		mQ.prod_cd,\n")
						.append("		mQ.prod_cd_rev,\n")
						.append("		mQ.document_no,\n")
						.append("		mQ.document_rev,\n")
						.append("		mQ.reg_gubun,\n")
						.append("		mQ.regist_no,\n")
						.append("		mQ.regist_no_rev,\n")
						.append("		mQ.file_view_name,\n")
						.append("		mQ.file_real_name,\n")
						.append("		mQ.member_key\n")
						.append("	)\n")
						.toString();

				// System.out.println(sql.toString());
				resultInt = super.excuteUpdate(con, sql.toString());
				if (resultInt < 0) {  //
					ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
					con.rollback();
					return EventDefine.E_DOEXCUTE_ERROR ;
				}
			}
			con.commit();
		} catch(Exception e) {
			LoggingWriter.setLogError("M909S065100E101()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M909S065100E101()","==== finally ===="+ e.getMessage());
				}
	    	} else {
	    	}
	    }
		ioParam.setResultString(resultString);
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
    	ioParam.setMessage(MessageDefine.M_QUERY_OK);
	    return EventDefine.E_QUERY_RESULT;
	}
	
	// S909S065103.jsp 
	public int E103(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;

		try {
			con = JDBCConnectionPool.getConnection();
			
//			String[][] c_paramArray_Head=null;
//			String[][] c_paramArray_Detail=null;
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			System.out.println("JSONObject jArray rcvData="+ jArray.toString());
			
	   		JSONArray jjArray = (JSONArray) jArray.get("param");
    		System.out.println("데이터 묶음 개수 :::: " + jjArray.size());
			
//			String rcvData = (String)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
//			Vector resultVector = CommonFunction.getConvStringDamogjuk(rcvData);
			con.setAutoCommit(false);

//			c_paramArray_Head = (String[][])resultVector.get(0);//head table
//    		c_paramArray_Detail=(String[][])resultVector.get(1); //data table

				
			for(int i=0; i<jjArray.size(); i++) {   
				JSONObject jjjArray = (JSONObject)jjArray.get(i); // i번째 데이터묶음
				String sql = new StringBuilder()
						.append("DELETE FROM tbm_product_doc_master\n")
						.append("WHERE prod_doc_no='" 	 + jjjArray.get("prod_doc_no") + "'\n")
						.append("	AND revision_no='" 	 + jjjArray.get("revision_no") + "'\n")
						.append("	AND prod_cd='" 	 	 + jjjArray.get("prod_cd") + "'\n")
						.append("	AND prod_cd_rev='" 	 + jjjArray.get("prod_cd_rev") + "'\n")
						.append("	AND document_no='" 	 + jjjArray.get("document_no") + "'\n")
						.append("	AND document_rev='"  + jjjArray.get("document_no_rev") + "'\n")
						.append("	AND reg_gubun='" 	 + jjjArray.get("reg_gubun") + "'\n")
						.append("	AND regist_no='" 	 + jjjArray.get("regist_no") + "'\n")
						.append("	AND regist_no_rev='" + jjjArray.get("regist_no_rev") + "'\n")
						.append(" 	AND member_key = '" + jjjArray.get("member_key") + "' \n") //member_key_select, update, delete
						.toString();

				// System.out.println(sql.toString());
				resultInt = super.excuteUpdate(con, sql.toString());
				if (resultInt < 0) {  //
					ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
					con.rollback();
					return EventDefine.E_DOEXCUTE_ERROR ;
				}
			}
			con.commit();
		} catch(Exception e) {
			LoggingWriter.setLogError("M909S065100E103()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M909S065100E103()","==== finally ===="+ e.getMessage());
				}
	    	} else {
	    	}
	    }
		ioParam.setResultString(resultString);
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
    	ioParam.setMessage(MessageDefine.M_QUERY_OK);
	    return EventDefine.E_QUERY_RESULT;
	}
	
	// S909S065100.jsp 
	public int E104(InoutParameter ioParam){
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
					.append("	prod_cd,			\n")
					.append("	revision_no,		\n")
					.append("	product_nm,			\n")
					.append("	gugyuk,				\n")
					.append("	option_cd,			\n")
					.append("	start_date,			\n")
					.append("	duration_date,		\n")
					.append("	create_user_id,		\n")
					.append("	create_date,		\n")
					.append("	modify_user_id,		\n")
					.append("	modify_reason,		\n")
					.append("	modify_date			\n")
					.append("FROM	tbm_product		\n")
					.append("WHERE prod_cd like '%%'	\n")
					.append(" 	AND member_key = '" + jArray.get("member_key") + "' \n") //member_key_select, update, delete
					.append("ORDER BY prod_cd	ASC, revision_no DESC	\n")
					.toString();

			resultString = super.excuteQueryString(con, sql.toString());
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M909S065100E104()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M909S065100E104()","==== finally ===="+ e.getMessage());
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
	
	public int E105(InoutParameter ioParam){
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
					.append("	prod_cd,			\n")
					.append("	revision_no,		\n")
					.append("	product_nm,			\n")
					.append("	gugyuk,				\n")
					.append("	option_cd,			\n")
					.append("	start_date,			\n")
					.append("	duration_date,		\n")
					.append("	create_user_id,		\n")
					.append("	create_date,		\n")
					.append("	modify_user_id,		\n")
					.append("	modify_reason,		\n")
					.append("	modify_date			\n")
					.append("FROM	tbm_product		\n")
					.append("WHERE prod_cd like '%%'	\n")
					.append(" 	and TO_CHAR(SYSDATE,'YYYY-MM-DD') BETWEEN  start_date AND duration_date\n")
					.append(" 	AND member_key = '" + jArray.get("member_key") + "' \n") //member_key_select, update, delete
					.append("ORDER BY prod_cd	ASC, revision_no DESC	\n")
					.toString();

			resultString = super.excuteQueryString(con, sql.toString());
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M909S065100E105()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M909S065100E105()","==== finally ===="+ e.getMessage());
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
	
	// S909S065110.jsp
	public int E114(InoutParameter ioParam) {
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
					.append("SELECT DISTINCT\n")
					.append("	prod_doc_no,\n")
					.append("	A.revision_no,\n")
					.append("	A.prod_cd,\n")
					.append("	A.prod_cd_rev,\n")
					.append("	P.product_nm,\n")
					.append("	A.document_no,\n")
					.append("	A.document_rev,\n")
					.append("	B.document_name,\n")
					.append("	A.reg_gubun,\n")
					.append("	V.code_name,\n")
					.append("	A.regist_no,\n")
					.append("	A.regist_no_rev,\n")
					.append("	A.file_view_name,\n")
					.append("	A.file_real_name\n")
					.append("FROM tbm_product_doc_master A\n")
					.append("INNER JOIN tbm_doc_base B\n")
					.append("	ON A.document_no=B.document_no\n")
					.append("	AND A.document_rev=B.revision_no\n")
					.append("	AND A.member_key = B.member_key\n")
					.append("INNER JOIN v_doc_gubun V\n")
					.append("	ON B.gubun_code = V.code_value\n")
					.append("	AND B.member_key = V.member_key\n")
					.append("INNER JOIN tbm_product P\n")
					.append("	ON A.prod_cd=P.prod_cd\n")
					.append("	AND A.prod_cd_rev=P.revision_no\n")
					.append("	AND A.member_key = P.member_key\n")
					.append("INNER JOIN tbi_doc_regist_info C\n")
					.append("   ON A.document_no=C.document_no\n")
					.append("   AND A.document_rev=C.document_no_rev\n")
					.append("   AND A.regist_no=C.regist_no\n")
					.append("   AND A.regist_no_rev=C.revision_no\n")
					.append("	AND A.member_key = C.member_key\n")
					.append("WHERE A.prod_cd='" + jArray.get("PROD_CD") + "'\n")
					.append("	AND A.prod_cd_rev='" + jArray.get("PROD_CD_REV") + "'\n")
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
			LoggingWriter.setLogError("M909S065100E114()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M909S065100E114()","==== finally ===="+ e.getMessage());
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

	// S909S065120.jsp
	public int E124(InoutParameter ioParam) {
		resultInt = EventDefine.E_DOEXCUTE_INIT;

		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			System.out.println("JSONObject jArray rcvData="+ jArray.toString());

			// 클라이언트로 부터 받은 파라미터를 옮겨 담는다.
//			String rcvData = (String) ((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			// 클라이언트로 부터 받은 파라미터를 쪼개어서 배열에 담는다.
			// rcvData = [위경도]

//			String[][] c_paramArray = CommonFunction.getConvString2DoubleArray(rcvData);
			String sql = new StringBuilder()
					.append("SELECT DISTINCT\n")
					.append("	A.reg_gubun,\n")
					.append("   A.document_no,\n")
					.append("   A.document_no_rev,\n")
					.append("	B.document_name,\n")
					.append("	B.gubun_code,\n")
					.append("	V.code_name,\n")
					.append("	file_view_name,\n")
					.append("	file_real_name,\n")
					.append("	A.regist_no,\n")
					.append("	MAX(A.revision_no) over (PARTITION BY A.regist_no) AS regist_rev,\n")
					.append("	external_doc_yn,\n")
					.append("	regist_reason_code,\n")
					.append("	destroy_reason_code,\n")
					.append("	total_page,\n")
					.append("	gwanribon_yn,\n")
					.append("	keep_yn,\n")
					.append("	hold_yn,\n")
					.append("	d.action_date AS regist_date,\n")
					.append("	d.user_id AS  regist_user_id\n")
					.append("FROM tbi_doc_regist_info A\n")
					.append("INNER JOIN tbm_doc_base B\n")
					.append("	ON A.document_no=B.document_no\n")
					.append("	AND A.document_no_rev=B.revision_no\n")
					.append("	AND A.member_key = B.member_key\n")
					.append("INNER JOIN tbi_approval_action D\n")
					.append("	ON A.regist_no = D.actionno\n")
					.append("	AND A.member_key = D.member_key\n")
					.append("INNER JOIN v_doc_gubun V\n")
					.append("	ON B.gubun_code = V.code_value\n")
					.append("	AND B.member_key = V.member_key\n")
					.append("WHERE regist_reason_code LIKE 'M606%'\n")
					.append("	AND A.regist_no NOT IN (\n")
					.append("		SELECT regist_no\n")
					.append("		FROM tbm_product_doc_master\n")
					.append("		WHERE prod_cd='" + jArray.get("PROD_CD") + "'\n")
					.append("	        AND prod_cd_rev='" + jArray.get("PROD_CD_REV") + "'\n")
					.append(" 			AND A.member_key = '" + jArray.get("member_key") + "' \n") //member_key_select, update, delete
					.append("	)\n")
					.toString();

			resultString = super.excuteQueryString(con, sql.toString());
		} catch (Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M909S065100E124()", "==== SQL ERROR ====" + e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR;
		} finally {
			if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M909S065100E124()","==== finally ===="+ e.getMessage());
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

	// S909S065130.jsp
	public int E134(InoutParameter ioParam) {
		resultInt = EventDefine.E_DOEXCUTE_INIT;

		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			System.out.println("JSONObject jArray rcvData="+ jArray.toString());

			// 클라이언트로 부터 받은 파라미터를 옮겨 담는다.
//			String rcvData = (String) ((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			// 클라이언트로 부터 받은 파라미터를 쪼개어서 배열에 담는다.
			// rcvData = [위경도]

//			String[][] c_paramArray = CommonFunction.getConvString2DoubleArray(rcvData);
			
			String sql = new StringBuilder()
					.append("SELECT DISTINCT\n")
					.append("	prod_doc_no,\n")
					.append("	A.revision_no,\n")
					.append("	A.prod_cd,\n")
					.append("	A.prod_cd_rev,\n")
					.append("	P.product_nm,\n")
					.append("	A.document_no,\n")
					.append("	A.document_rev,\n")
					.append("	B.document_name,\n")
					.append("	reg_gubun,\n")
					.append("	V.code_name,\n")
					.append("	regist_no,\n")
					.append("	regist_no_rev,\n")
					.append("	file_view_name,\n")
					.append("	file_real_name\n")
					.append("FROM tbm_product_doc_master A\n")
					.append("INNER JOIN tbm_doc_base B\n")
					.append("	ON A.document_no=B.document_no\n")
					.append("	AND A.document_rev=B.revision_no\n")
					.append("	AND A.member_key = B.member_key\n")
					.append("INNER JOIN v_doc_gubun V\n")
					.append("	ON B.gubun_code = V.code_value\n")
					.append("	AND B.member_key = V.member_key\n")
					.append("INNER JOIN tbm_product P\n")
					.append("	ON A.prod_cd=P.prod_cd\n")
					.append("	AND A.prod_cd_rev=P.revision_no\n")
					.append("	AND A.member_key = P.member_key\n")
					.append("WHERE A.prod_cd='" + jArray.get("PROD_CD") + "'\n")
					.append("	AND A.prod_cd_rev='" + jArray.get("PROD_CD_REV") + "'\n")
					.append(" 	AND A.member_key = '" + jArray.get("member_key") + "' \n") //member_key_select, update, delete
					.toString();

			resultString = super.excuteQueryString(con, sql.toString());
		} catch (Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M909S065100E134()", "==== SQL ERROR ====" + e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR;
		} finally {
			if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M909S065100E134()","==== finally ===="+ e.getMessage());
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