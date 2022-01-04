package mes.frame.business.M909;

import java.lang.reflect.Method;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.util.Vector;

import org.json.simple.JSONObject;

import mes.client.common.Common;
import mes.client.conf.Config;
import mes.frame.common.EventDefine;
import mes.frame.common.HashObject;
import mes.frame.common.MessageDefine;
import mes.frame.database.JDBCConnectionPool;
import mes.frame.database.SqlAdapter;
import mes.frame.serviceinterface.InoutParameter;
import mes.frame.serviceinterface.LoggingWriter;
import mes.frame.util.CommonFunction;


public class M909S030100 extends SqlAdapter{
	Connection con = null;
	PreparedStatement pstmt = null;
	String resultString = "";
	int resultInt = -1;
	StringBuffer sql = new StringBuffer();
	
	String[][] v_paramArray = new String[0][0]; 
	Class[] optClass = null;
	Object[] optObj = null;
	Object obj = null;
	
	public M909S030100(){
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

			Method method = M909S030100.class.getMethod(event,optClass);
			LoggingWriter.setLogDebug(M909S030100.class.getName(),"==== " + event + " EventMethod Create Success ====");

			obj = method.invoke(M909S030100.class.newInstance(),optObj);
			doExcute_result = CommonFunction.getInt(obj.toString());
			
	    } catch (Exception ex) {
	    	doExcute_result = EventDefine.E_DOEXCUTE_INIT;
			ioParam.setMessage(MessageDefine.M_NO_EVENTID);
			LoggingWriter.setLogError(M909S030100.class.getName(),"==== EventID Not define : EVENT ID [ " + ioParam.getEventID() + "]");
	    } finally {
	    	obj = null;
			optClass = null;
			optObj = null;
	    }
	    long endTime = System.currentTimeMillis();
		long runningTime = endTime - startTime;
		LoggingWriter.setLogAll(M909S030100.class.getName(),"==== Query [수행시간  : " + runningTime + " ms]");
		
		return doExcute_result;
	}
	

	public int E101(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			System.out.println("JSONObject jArray rcvData="+ jArray.toString());
			
			// 클라이언트로 부터 받은 파라미터를 옮겨 담는다.
//			String rcvData = (String)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			
			// 클라이언트로 부터 받은 파라미터를 쪼개어서 배열에 담는다.
//			String[][] c_paramArray = CommonFunction.getConvString2DoubleArray(rcvData);
			
			// 클라이언트에서 받은 데이터로 미리 문항코드를 만든다.
			String munhangSeq = innerSql001((String) jArray.get("CheckGubun")); // (String)
			System.out.println("munhangSeq===" + munhangSeq);
			String PLUS_MUNHANG_CODE = jArray.get("CheckGubun") + "-" + jArray.get("CheckGubunSm") + "-" + Common.getFormatData(munhangSeq, "0000");
			System.out.println("PLUS_MUNHANG_CODE===" + PLUS_MUNHANG_CODE);
			
			String sql = new StringBuilder()
				.append("INSERT INTO tbm_checklist ( "
						+ "check_gubun, 	\n"
						+ "checklist_cd, 	\n"
						+ "checklist_seq, 	\n"
						+ "check_note, 		\n"
						+ "standard_guide, 	\n"
						+ "standard_value, 	\n"
						+ "revision_no, 	\n"
						+ "item_cd, 		\n"
						+ "item_seq, 		\n"
						+ "item_cd_rev, 	\n"
						+ "start_date, 		\n"
						+ "duration_date, 	\n"
						+ "create_user_id, 	\n"
						+ "create_date, 	\n"
						+ "modify_user_id, 	\n"
						+ "modify_reason, 	\n"
						+ "modify_date, 	\n"
						+ "double_check_yn, \n"
						+ "	check_gubun_mid,\n"
						+ "check_gubun_sm,  \n"
						+ "member_key ) \n")	
				.append(" VALUES (							 			\n")
				.append(" 		'" + jArray.get("CheckGubun") 		+ "',	\n") 	//select_CheckGubun
				.append(" 		'" + PLUS_MUNHANG_CODE 				+ "', 	\n") 	//txt_MunhangCode
				.append(" 		'" + munhangSeq.trim() 				+ "',	\n") 	//txt_MunhangSeq
				.append(" 		'" + jArray.get("MunhangNote") 		+ "', 	\n") 	//txt_MunhangNote
				.append(" 		'" + jArray.get("StandardProc") 	+ "', 	\n") 	//txt_StandardProc
				.append(" 		'" + jArray.get("StandardValue") 	+ "',	\n") 	//txt_StandardValue
				.append("	 	'" + jArray.get("RevisionNo") 		+ "',	\n") 	//txt_RevisionNo
				.append("	 	'" + jArray.get("partItemCode") 	+ "',	\n") 	//select_ItemCode 
				.append("	 	'" + jArray.get("partItemSeq") 		+ "',	\n") 	//select_ItemCodeSeq
				.append("	 	'" + jArray.get("partItemRevNo") 	+ "',	\n") 	//txt_ItemRevisionNo
				.append("	 	'" + jArray.get("StartDate") 		+ "',	\n") 	//txt_StartDate
				.append("	 	'9999-12-31',	\n") 								//duration_date
				.append("	 	'" + jArray.get("user_id") 			+ "',	\n") 	//create_user_id
				.append("	 	SYSDATETIME,	\n") 								//create_date
				.append("	 	'" + jArray.get("user_id") 			+ "',	\n") 	//modify_user_id
				.append("	 	'최초등록',		\n") 									//modify_reason
				.append("	 	SYSDATETIME,	\n") 								//modify_date
				.append("	 	'" + jArray.get("doubleCheckYN") 	+ "',	\n") 	//double_check_yn
				.append("	 	'" + jArray.get("CheckGubunMid") 	+ "',	\n") 	//double_check_yn
				.append("	 	'" + jArray.get("CheckGubunSm") 	+ "'	\n") 	//double_check_yn
				.append(" 		,'" + jArray.get("member_key") + "' \n") //member_key_values
				.append("	)	\n")
				.toString();
            
			
				resultInt = super.excuteUpdate(con, sql.toString());
				if (resultInt < 0) {
					ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
				} else {
					ioParam.setMessage(resultInt + "건 " + MessageDefine.M_INSERT_RESULT);
				}
				
		} catch(Exception e) {
			LoggingWriter.setLogError("M909S030100E101()","==== SQL ERROR ===="+ e.getMessage() + "\n" + sql.toString());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M909S030100E101()","==== finally ===="+ e.getMessage());
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
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			System.out.println("JSONObject jArray rcvData="+ jArray.toString());
			
			// 클라이언트로 부터 받은 파라미터를 옮겨 담는다.
//			String rcvData = (String)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			// 클라이언트로 부터 받은 파라미터를 쪼개어서 배열에 담는다.
//			String[][] c_paramArray = CommonFunction.getConvString2DoubleArray(rcvData);
			
			con.setAutoCommit(false);
			
			// 먼저 이전 리비전에 대한 적용종료일자를 이번의 적용일자에서 하루를 뺀 날짜로 변경한다.
			String sqlPre = new StringBuilder()
					.append("UPDATE tbm_checklist SET	\n")
					.append(" duration_date = to_char(TO_DATE('" + jArray.get("StartDate") + "', 'YYYY-MM-DD')-1 , 'YYYY-MM-DD')	\n")
					.append(" 	,member_key = 	'" + jArray.get("member_key") + "'		\n")
					.append("WHERE checklist_cd = '" + jArray.get("MunhangCode") + "'\n")
					// 13번째는 이전의 리비전코드가 들어온다.
					.append("	AND revision_no = '" + jArray.get("RevisionNo_Target") + "'\n")
					.append(" 	AND member_key = '" + jArray.get("member_key") + "' \n") //member_key_select, update, delete
					.toString();
//			String sqlPre = new StringBuilder()
//					.append("UPDATE tbm_checklist SET\n")
//					.append("check_note = '" + c_paramArray[0][3] + "'\n")
//					.append(",standard_guide = '" + c_paramArray[0][4] + "'\n")
//					.append(",standard_value = '" + c_paramArray[0][5] + "'\n")
//					.append(",item_cd = '" + c_paramArray[0][7] + "'\n")
//					.append(",modify_date = to_char(TO_DATE('" + c_paramArray[0][10] + "', 'YYYY-MM-DD')-1 , 'YYYY-MM-DD')	\n")
//					.append("WHERE checklist_cd = '" + c_paramArray[0][1] + "'\n")
//					// 13번째는 이전의 리비전코드가 들어온다.
//					.append("	AND revision_no = '" + c_paramArray[0][17] + "'\n")
//				.toString();
			
			//System.out.println(sqlPre.toString());
			
			resultInt = super.excuteUpdate(con, sqlPre.toString());
			if (resultInt < 0) {
				con.rollback();
				ioParam.setMessage(MessageDefine.M_UPDATE_FAILED);
				return resultInt;
			} else {
				ioParam.setMessage(resultInt + "건 " + MessageDefine.M_UPDATE_RESULT);
			}

			String sql = new StringBuilder()
					.append("INSERT INTO  tbm_checklist ( "
							+ "check_gubun, 	\n"
							+ "checklist_cd, 	\n"
							+ "checklist_seq, 	\n"
							+ "check_note, 		\n"
							+ "standard_guide,	\n"
							+ "standard_value,	\n"
							+ "revision_no, 	\n"
							+ "item_cd, 		\n"
							+ "item_seq, 		\n"
							+ "item_cd_rev, 	\n"
							+ "start_date,		\n"
							+ "check_gubun_mid,	\n"
							+ "check_gubun_sm,	\n"
							+ "duration_date, 	\n"
							+ "create_user_id,	\n"
							+ "create_date, 	\n"
							+ "modify_user_id,	\n"
							+ "modify_reason, 	\n"
							+ "modify_date, 	\n"
							+ "double_check_yn, \n"
							+ "member_key )\n"
							)
					.append(" VALUES (							 				\n")
					.append(" 		'" + jArray.get("CheckGubun") 		+ "', 	\n") 	//1. select_CheckGubun
					.append(" 		'" + jArray.get("MunhangCode") 		+ "', 	\n") 	//2. txt_MunhangCode
					.append(" 		'" + jArray.get("MunhangSeq") 		+ "',	\n") 	//3. txt_MunhangSeq
					.append(" 		'" + jArray.get("MunhangNote") 		+ "', 	\n") 	//4. txt_MunhangNote
					.append(" 		'" + jArray.get("StandardProc") 	+ "', 	\n") 	//5. txt_StandardProc
					.append(" 		'" + jArray.get("StandardValue") 	+ "',	\n") 	//6. txt_StandardValue
					.append("	 	'" + jArray.get("RevisionNo") 		+ "',	\n") 	//7. txt_RevisionNo
					.append("	 	'" + jArray.get("partItemCode") 	+ "',	\n") 	//8. select_ItemCode 
					.append("	 	'" + jArray.get("partItemSeq") 		+ "',	\n") 	//9. select_ItemCodeSeq
					.append("	 	'" + jArray.get("partItemRevNo") 	+ "',	\n") 	//10. txt_ItemRevisionNo
					.append("	 	'" + jArray.get("StartDate") 		+ "',	\n") 	//11. txt_StartDate
					.append("	 	'" + jArray.get("CheckGubunMid") 	+ "',	\n") 	//12. CheckGubunMid
					.append("	 	'" + jArray.get("CheckGubunSm") 	+ "',	\n") 	//13. CheckGubunSm
					.append("	 	'9999-12-31',	\n") 								//14. duration_date
					.append("	 	'" + jArray.get("user_id") 			+ "',	\n") 	//15. create_user_id
					.append("	 	SYSDATETIME,					\n") 				//16. create_date
					.append("	 	'" + jArray.get("user_id") 			+ "',	\n") 	//17. modify_user_id
					.append("	 	'수정',							\n") 				//18. modify_reason
					.append("	 	SYSDATETIME,					\n") 				//19. modify_date
					.append("	 	'" + jArray.get("doubleCheckYN") 	+ "'	\n") 	//20. double_check_yn
					.append(" 		,'" + jArray.get("member_key") + "' \n") //member_key_values
					.append("	)									\n")
					.toString();
					
			//// System.out.println(sql.toString());
			
				resultInt = super.excuteUpdate(con, sql.toString());
				if (resultInt < 0) {
					con.rollback();
					ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
				} else {
					ioParam.setMessage(resultInt + "건 " + MessageDefine.M_INSERT_RESULT);
				}
				
				con.commit();
		} catch(Exception e) {
			LoggingWriter.setLogError("M09S030100E102()","==== SQL ERROR ===="+ e.getMessage() + "\n" + sql.toString());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M09S030100E102()","==== finally ===="+ e.getMessage());
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
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			System.out.println("JSONObject jArray rcvData="+ jArray.toString());
			
			// 클라이언트로 부터 받은 파라미터를 옮겨 담는다.
//			String rcvData = (String)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			
			// 클라이언트로 부터 받은 파라미터를 쪼개어서 배열에 담는다.
//			String[][] c_paramArray = CommonFunction.getConvString2DoubleArray(rcvData);

			String sql = new StringBuilder()
				.append("DELETE FROM tbm_checklist \n")	//menu_id
				.append("WHERE  checklist_cd = '" 		+ jArray.get("MunhangCode") + "' \n")
				.append("AND checklist_seq = '" 	+ jArray.get("MunhangSeq") 	+ "' \n")
				.append(" 	AND member_key = '" + jArray.get("member_key") + "' \n") //member_key_select, update, delete
//				.append(" AND revision_no = '" 	+ c_paramArray[0][6] + "' \n")
				.toString();
					
				resultInt = super.excuteUpdate(con, sql.toString());
				if (resultInt < 0) {
					ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
				} else {
					ioParam.setMessage(resultInt + "건 " + MessageDefine.M_INSERT_RESULT);
				}
				
		} catch(Exception e) {
			LoggingWriter.setLogError("M09S030100E103()","==== SQL ERROR ===="+ e.getMessage() + "\n" + sql.toString());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M09S030100E103()","==== finally ===="+ e.getMessage());
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

	// 헤드메뉴 
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
			String sql = "";
			if(jArray.get("CHECK_GUBUN").toString().length()<1) {
				sql = new StringBuilder()
						.append("select\n")
						.append("	check_gubun, 			\n")
						.append("	code_name,				\n")
						.append("	CG.chk_lst_gb_mid,		\n")
						.append("	CG.chk_lst_gb_mid_name,	\n")
						.append("	CG.chk_lst_gb_sm,		\n")
						.append("	CG.chk_lst_gb_sm_name,	\n")
						.append("	checklist_cd,			\n")
						.append("	revision_no,			\n")
						.append("	checklist_seq,			\n")
						.append("	check_note,				\n")
						.append("	standard_guide,			\n")
						.append("	standard_value,			\n")
						.append("	double_check_yn,		\n")
						.append("	item_cd,				\n")
						.append("	item_seq,				\n")
						.append("	item_cd_rev,			\n")
						.append("	start_date,				\n")
						.append("	duration_date,			\n")
						.append("	create_user_id,			\n")
						.append("	create_date,			\n")
						.append("	modify_user_id,			\n")
						.append("	modify_reason,			\n")
						.append("	modify_date				\n")					
						.append("FROM tbm_checklist A 		\n")
						.append("LEFT OUTER JOIN tbm_checklist_gubun CG		\n")
						.append("ON check_gubun 		= CG.chk_lst_gb_big	\n")
						.append("AND check_gubun_mid 	= CG.chk_lst_gb_mid	\n")
						.append("AND check_gubun_sm 	= CG.chk_lst_gb_sm	\n")
						.append("AND A.member_key = CG.member_key\n")
						.append("INNER JOIN v_checklist_gubun \n")
						.append("ON code_value = A.check_gubun\n")	
						.append("AND A.member_key = CG.member_key\n")
						.append("WHERE check_gubun like '" + jArray.get("CHECK_GUBUN") + "%' 	\n") 
						.append(" 	AND A.member_key = '" + jArray.get("member_key") + "' \n") //member_key_select, update, delete
						.toString();
			} else {
				sql = new StringBuilder()
						.append("select\n")
						.append("	check_gubun, 			\n")
						.append("	code_name,				\n")
						.append("	CG.chk_lst_gb_mid,		\n")
						.append("	CG.chk_lst_gb_mid_name,	\n")
						.append("	CG.chk_lst_gb_sm,		\n")
						.append("	CG.chk_lst_gb_sm_name,	\n")
						.append("	checklist_cd,			\n")
						.append("	revision_no,			\n")
						.append("	checklist_seq,			\n")
						.append("	check_note,				\n")
						.append("	standard_guide,			\n")
						.append("	standard_value,			\n")
						.append("	double_check_yn,		\n")
						.append("	item_cd,				\n")
						.append("	item_seq,				\n")
						.append("	item_cd_rev,			\n")
						.append("	start_date,				\n")
						.append("	duration_date,			\n")
						.append("	create_user_id,			\n")
						.append("	create_date,			\n")
						.append("	modify_user_id,			\n")
						.append("	modify_reason,			\n")
						.append("	modify_date				\n")					
						.append("FROM tbm_checklist A 		\n")
						.append("LEFT OUTER JOIN tbm_checklist_gubun CG		\n")
						.append("ON check_gubun 		= CG.chk_lst_gb_big	\n")
						.append("AND check_gubun_mid 	= CG.chk_lst_gb_mid	\n")
						.append("AND check_gubun_sm 	= CG.chk_lst_gb_sm	\n")
						.append("AND A.member_key = CG.member_key\n")
						.append("INNER JOIN v_checklist_gubun \n")
						.append("ON code_value = A.check_gubun\n")
						.append("AND A.member_key = CG.member_key\n")
						.append("WHERE check_gubun = '" + jArray.get("CHECK_GUBUN") + "' 	\n") 
						.append(" 	AND A.member_key = '" + jArray.get("member_key") + "' \n") //member_key_select, update, delete
						.toString();
			}
			resultString = super.excuteQueryString(con, sql.toString());
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M909S030100E104()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M909S030100E104()","==== finally ===="+ e.getMessage());
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
			
			String sql = "";
			
			if(jArray.get("CHECK_GUBUN").toString().length() < 1) {
				sql = new StringBuilder()
						.append("SELECT\n")
						.append("	check_gubun, 			\n")
						.append("	code_name,				\n")
						.append("	CG.chk_lst_gb_mid,		\n")
						.append("	CG.chk_lst_gb_mid_name,	\n")
						.append("	CG.chk_lst_gb_sm,		\n")
						.append("	CG.chk_lst_gb_sm_name,	\n")
						.append("	checklist_cd,			\n")
						.append("	revision_no,			\n")
						.append("	checklist_seq,			\n")
						.append("	check_note,				\n")
						.append("	standard_guide,			\n")
						.append("	standard_value,			\n")
						.append("	double_check_yn,		\n")
						.append("	item_cd,				\n")
						.append("	item_seq,				\n")
						.append("	item_cd_rev,			\n")
						.append("	start_date,				\n")
						.append("	duration_date,			\n")
						.append("	create_user_id,			\n")
						.append("	create_date,			\n")
						.append("	modify_user_id,			\n")
						.append("	modify_reason,			\n")
						.append("	modify_date				\n")					
						.append("FROM tbm_checklist A 		\n")
						.append("INNER JOIN tbm_checklist_gubun CG\n")
						.append("	ON A.check_gubun          = CG.chk_lst_gb_big\n")
						.append("	AND A.check_gubun_mid     = CG.chk_lst_gb_mid\n")
						.append("	AND A.check_gubun_sm      = CG.chk_lst_gb_sm\n")
						.append("	AND A.member_key = CG.member_key\n")
						.append("INNER JOIN v_checklist_gubun G\n")
						.append("	ON A.check_gubun = G.code_value \n")
						.append("	AND A.member_key = G.member_key\n")
						.append("WHERE check_gubun like '" + jArray.get("CHECK_GUBUN") + "%' 	\n") 
						.append("	AND TO_CHAR(SYSDATE,'YYYY-MM-DD') BETWEEN start_date AND duration_date\n")
						.append(" 	AND A.member_key = '" + jArray.get("member_key") + "' \n")
						.toString();
			} else {
				sql = new StringBuilder()
						.append("select\n")
						.append("	check_gubun, 			\n")
						.append("	code_name,				\n")
						.append("	CG.chk_lst_gb_mid,		\n")
						.append("	CG.chk_lst_gb_mid_name,	\n")
						.append("	CG.chk_lst_gb_sm,		\n")
						.append("	CG.chk_lst_gb_sm_name,	\n")
						.append("	checklist_cd,			\n")
						.append("	revision_no,			\n")
						.append("	checklist_seq,			\n")
						.append("	check_note,				\n")
						.append("	standard_guide,			\n")
						.append("	standard_value,			\n")
						.append("	double_check_yn,		\n")
						.append("	item_cd,				\n")
						.append("	item_seq,				\n")
						.append("	item_cd_rev,			\n")
						.append("	start_date,				\n")
						.append("	duration_date,			\n")
						.append("	create_user_id,			\n")
						.append("	create_date,			\n")
						.append("	modify_user_id,			\n")
						.append("	modify_reason,			\n")
						.append("	modify_date				\n")					
						.append("FROM tbm_checklist A 		\n")
						.append("INNER JOIN tbm_checklist_gubun CG\n")
						.append("	ON A.check_gubun          = CG.chk_lst_gb_big\n")
						.append("	AND A.check_gubun_mid     = CG.chk_lst_gb_mid\n")
						.append("	AND A.check_gubun_sm      = CG.chk_lst_gb_sm\n")
						.append("	AND A.member_key = CG.member_key\n")
						.append("INNER JOIN v_checklist_gubun G\n")
						.append("	ON A.check_gubun = G.code_value \n")
						.append("	AND A.member_key = G.member_key\n")
						.append("WHERE check_gubun = '" + jArray.get("CHECK_GUBUN") + "' 	\n") 
						.append("	AND TO_CHAR(SYSDATE,'YYYY-MM-DD') BETWEEN start_date AND duration_date\n")
						.append(" 	AND A.member_key = '" + jArray.get("member_key") + "' \n")
						.toString();
			}

			resultString = super.excuteQueryString(con, sql.toString());
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M909S030100E105()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M909S030100E105()","==== finally ===="+ e.getMessage());
				}
	    	} else {
	    	}
	    }
		ioParam.setResultString(resultString);
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
    	ioParam.setMessage(MessageDefine.M_QUERY_OK);
	    
    	return EventDefine.E_QUERY_RESULT;
	}
	
	//법중(체크문항 중분류 중복체크)
	public int E107(InoutParameter ioParam){
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
					.append("chk_lst_gb_mid_name\n")
					.append("FROM\n")
					.append("        tbm_checklist_gubun\n")
					.append("WHERE chk_lst_gb_big = '"+jArray.get("check_big")+"'  \n")
					.append("        AND chk_lst_gb_mid_name = '"+jArray.get("check_mid_name")+"'\n")
					.append("        AND member_key='"+jArray.get("member_key")+"'\n")
					.toString();


			resultString = super.excuteQueryString(con, sql.toString());
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M909S110100E107()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M909S110100E107()","==== finally ===="+ e.getMessage());
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
	
	
	//법중(체크문항 소분류 중복체크)
		public int E108(InoutParameter ioParam){
			resultInt = EventDefine.E_DOEXCUTE_INIT;
			
			try {
				con = JDBCConnectionPool.getConnection();
				
				JSONObject jArray = new JSONObject();
				jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
				System.out.println("JSONObject jArray rcvData="+ jArray.toString());
				
				// 클라이언트로 부터 받은 파라미터를 옮겨 담는다.
//				String rcvData = (String)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
				// 클라이언트로 부터 받은 파라미터를 쪼개어서 배열에 담는다.
				// rcvData = [위경도]
				
//				String[][] c_paramArray = CommonFunction.getConvString2DoubleArray(rcvData);			
				String sql = new StringBuilder()
						.append("SELECT\n")
						.append("chk_lst_gb_sm_name\n")
						.append("FROM\n")
						.append("        tbm_checklist_gubun\n")
						.append("WHERE chk_lst_gb_big = '"+jArray.get("check_big")+"'  \n")
						.append("        AND chk_lst_gb_mid = '"+jArray.get("check_mid")+"'\n")
						.append("        AND chk_lst_gb_sm_name = '"+jArray.get("check_sm_name")+"'\n")
						.append("        AND member_key='"+jArray.get("member_key")+"'\n")
						.toString();


				resultString = super.excuteQueryString(con, sql.toString());
			} catch(Exception e) {
				e.printStackTrace();
				LoggingWriter.setLogError("M909S110100E108()","==== SQL ERROR ===="+ e.getMessage());
				return EventDefine.E_DOEXCUTE_ERROR ;
		    } finally {
		    	if (Config.useDataSource) {
					try {
						if (con != null) con.close();
					} catch (Exception e) {
						LoggingWriter.setLogError("M909S110100E108()","==== finally ===="+ e.getMessage());
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
	
		
		public int E111(InoutParameter ioParam){
			resultInt = EventDefine.E_DOEXCUTE_INIT;
			
			try {
				con = JDBCConnectionPool.getConnection();
				
				JSONObject jArray = new JSONObject();
				jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
				System.out.println("JSONObject jArray rcvData="+ jArray.toString());
				
				// 클라이언트로 부터 받은 파라미터를 옮겨 담는다.
//				String rcvData = (String)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
				
				// 클라이언트로 부터 받은 파라미터를 쪼개어서 배열에 담는다.
//				String[][] c_paramArray = CommonFunction.getConvString2DoubleArray(rcvData);
				
				
				String sql = new StringBuilder()
						.append("INSERT INTO tbm_checklist_gubun(\n")
						.append("chk_lst_gb_big,\n")
						.append("chk_lst_gb_big_name,\n")
						.append("chk_lst_gb_mid,\n")
						.append("chk_lst_gb_mid_name,\n")
						.append("chk_lst_gb_sm,\n")
						.append("chk_lst_gb_sm_name,\n")
						.append("order_index,\n")
						.append("bigo,\n")
						.append("member_key\n")
						.append(")\n")
						.append("VALUES (\n")
						.append("'" + jArray.get("Check_big") + "',\n")
						.append("'" + jArray.get("Check_big_name") + "',\n")
						.append("SELECT TO_CHAR(NVL(max(chk_lst_gb_mid),0)+1,'00') FROM tbm_checklist_gubun WHERE chk_lst_gb_big='" + jArray.get("Check_big") + "' AND member_key='" + jArray.get("member_key") + "',\n")
						.append("'" + jArray.get("Check_mid_name") + "',\n")
						.append("SELECT TO_CHAR(NVL(max(chk_lst_gb_mid),0)+1,'00')+'00' FROM tbm_checklist_gubun WHERE chk_lst_gb_big='" + jArray.get("Check_big") + "' AND member_key='" + jArray.get("member_key") + "',\n")
						.append("'',\n")
						.append("0,\n")
						.append("'',\n")
						.append("'" + jArray.get("member_key") + "'\n")
						.append(")\n")
					.toString();

	            
				
					resultInt = super.excuteUpdate(con, sql.toString());
					if (resultInt < 0) {
						ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
					} else {
						ioParam.setMessage(resultInt + "건 " + MessageDefine.M_INSERT_RESULT);
					}
					
			} catch(Exception e) {
				LoggingWriter.setLogError("M909S030100E111()","==== SQL ERROR ===="+ e.getMessage() + "\n" + sql.toString());
				return EventDefine.E_DOEXCUTE_ERROR ;
		    } finally {
		    	if (Config.useDataSource) {
					try {
						if (con != null) con.close();
					} catch (Exception e) {
						LoggingWriter.setLogError("M909S030100E111()","==== finally ===="+ e.getMessage());
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
		
		public int E121(InoutParameter ioParam){
			resultInt = EventDefine.E_DOEXCUTE_INIT;
			
			try {
				con = JDBCConnectionPool.getConnection();
				
				JSONObject jArray = new JSONObject();
				jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
				System.out.println("JSONObject jArray rcvData="+ jArray.toString());
				
				// 클라이언트로 부터 받은 파라미터를 옮겨 담는다.
//				String rcvData = (String)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
				
				// 클라이언트로 부터 받은 파라미터를 쪼개어서 배열에 담는다.
//				String[][] c_paramArray = CommonFunction.getConvString2DoubleArray(rcvData);
				
				
				String sql = new StringBuilder()
						.append("INSERT INTO tbm_checklist_gubun(\n")
						.append("chk_lst_gb_big,\n")
						.append("chk_lst_gb_big_name,\n")
						.append("chk_lst_gb_mid,\n")
						.append("chk_lst_gb_mid_name,\n")
						.append("chk_lst_gb_sm,\n")
						.append("chk_lst_gb_sm_name,\n")
						.append("order_index,\n")
						.append("bigo,\n")
						.append("member_key\n")
						.append(")\n")
						.append("VALUES (\n")
						.append("'" + jArray.get("Check_big") + "',\n")
						.append("'" + jArray.get("Check_big_name") + "',\n")
						.append("'" + jArray.get("Check_mid") + "',\n")
						.append("'" + jArray.get("Check_mid_name") + "',\n")
						.append("SELECT TO_CHAR(NVL(max(chk_lst_gb_sm),0)+1,'0000') FROM tbm_checklist_gubun WHERE chk_lst_gb_big='" + jArray.get("Check_big") + "' AND chk_lst_gb_mid='" + jArray.get("Check_mid") + "' AND member_key='" + jArray.get("member_key") + "',\n")
						.append("'" + jArray.get("Check_sm_name") + "',\n")
						.append("SELECT COALESCE(MAX(order_index),0)+1 FROM tbm_checklist_gubun WHERE chk_lst_gb_big='" + jArray.get("Check_big") + "' AND chk_lst_gb_mid='" + jArray.get("Check_mid") + "' AND member_key='" + jArray.get("member_key") + "',\n")
						.append("'',\n")
						.append("'" + jArray.get("member_key") + "'\n")
						.append(")\n")
						.toString();

				
					resultInt = super.excuteUpdate(con, sql.toString());
					if (resultInt < 0) {
						ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
					} else {
						ioParam.setMessage(resultInt + "건 " + MessageDefine.M_INSERT_RESULT);
					}
					
			} catch(Exception e) {
				LoggingWriter.setLogError("M909S030100E121()","==== SQL ERROR ===="+ e.getMessage() + "\n" + sql.toString());
				return EventDefine.E_DOEXCUTE_ERROR ;
		    } finally {
		    	if (Config.useDataSource) {
					try {
						if (con != null) con.close();
					} catch (Exception e) {
						LoggingWriter.setLogError("M909S030100E121()","==== finally ===="+ e.getMessage());
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
	

	//메뉴 의 특정프로그램
	public int E204(InoutParameter ioParam){
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
					.append("SELECT						\n")
					.append(" 		check_gubun,		\n")
					.append(" 		checklist_cd,		\n")
					.append(" 		checklist_seq,		\n") 
					.append(" 		check_note,			\n") 
					.append(" 		standard_guide,		\n") 
					.append(" 		standard_value,		\n") 
					.append(" 		revision_no,		\n") 
					.append(" 		item_cd,			\n") 
					.append("		item_seq,			\n")
					.append("		item_cd_rev,		\n")
					.append("		start_date,			\n")
					.append("		duration_date,		\n")
					.append("		create_user_id,		\n")
					.append("		create_date,		\n")
					.append("		modify_user_id,		\n")
					.append("		modify_reason,		\n")
					.append("		modify_date,		\n")
					.append("		double_check_yn,	\n")
					.append("		check_gubun_mid,	\n")
					.append("(SELECT code_name AS code_name_mid		\n")
					.append(" FROM v_checklist_gubun_mid			\n")
					.append(" WHERE code_cd 	= '" + jArray.get("Check_Gubun") 		+  "'	\n")
					.append(" AND member_key = '" + jArray.get("member_key") + "' \n") //member_key_select, update, delete
					.append(" AND code_value 	= '" + jArray.get("Check_Gubun_Mid") 	+ "'),	\n")
//					.append("		VCM.code_name,		\n")
					.append("		check_gubun_sm,		\n")
//					.append("		VCS.code_name		\n")
					.append("(SELECT code_name AS code_name_sm		\n")
					.append(" FROM v_checklist_gubun_sm\n")
					.append(" WHERE code_cd_big = '" + jArray.get("Check_Gubun") 		+ "'	\n")
					.append(" AND code_cd 		= '" + jArray.get("Check_Gubun_Mid")	+ "'	\n")
					.append(" AND code_value 	= '" + jArray.get("Check_Gubun_Sm") 	+ "'	\n")
					.append(" AND member_key 	= '" + jArray.get("member_key") 		+ "') \n") //member_key_select, update, delete
					.append("FROM						\n")
					.append("	tbm_checklist TC		\n")
//					.append("INNER JOIN v_checklist_gubun_mid VCM		\n")
//					.append("ON (TC.check_gubun = VCM.code_cd)			\n")
//					.append("AND (TC.check_gubun_mid = VCM.code_value)	\n")
//					.append("INNER JOIN v_checklist_gubun_sm VCS		\n")
//					.append("ON (TC.check_gubun = VCS.code_cd_big)		\n")
//					.append("AND (TC.check_gubun_mid = VCS.code_cd)		\n")
//					.append("AND (TC.check_gubun_sm = VCS.code_value)	\n")
					.append("WHERE  1=1									\n")
					.append("AND checklist_cd LIKE '" 	+ jArray.get("CHECKLIST_CD") 	+ "%'\n") 
					.append("AND checklist_seq = '" 	+ jArray.get("CHECKLIST_SEQ") 	+ "' \n") 
					.append("AND revision_no = '" 		+ jArray.get("CHECKLIST_REVNO") + "' \n") 
					.append("AND member_key = '" + jArray.get("member_key") + "' \n") //member_key_select, update, delete
					.append("ORDER BY checklist_cd	\n")
					.toString();
			resultString = super.excuteQueryString(con, sql.toString());
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M909S030100E204()","==== SQL ERROR ===="+ e.getMessage());
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
	    // 결과 전문 구성을 위한 파라미터들을 아이오 파라미터에 저장한다.
		ioParam.setResultString(resultString);
		// 수퍼에서 처리된 칼럼의 갯수를 클라이언트에게 보내기 위해 가져온다.
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
		// 잘 처리되었다는 메시지를 클라이언트에게 보내기 위해 I/O파라미터에 저장한다.
    	ioParam.setMessage(MessageDefine.M_QUERY_OK);
	    return EventDefine.E_QUERY_RESULT;
	}
	
//CheckListView.jsp?check_gubun= c_paramArray[0][0]
	public int E194(InoutParameter ioParam){
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
					.append("	check_gubun,	\n")
					.append("	checklist_cd,	\n")
					.append("	checklist_seq,	\n")
					.append("	A.revision_no,	\n")
					.append("	A.item_cd,		\n")
					.append("	B.item_desc,	\n")
					.append("	A.item_seq,		\n")
					.append("	A.item_cd_rev,	\n")
					.append("	standard_guide,	\n")
					.append("	check_note,		\n")
					.append("	standard_value,	\n")
					.append("	 '<input type='''  ||  item_type || ''' id=''' || item_type || '1'''  || ' /input>' AS html_tag,\n")
					.append("	B.item_type,	\n")
					.append("	B.item_bigo,	\n")
					.append("	C.code_name		\n")
					.append("FROM\n")
					.append("	vtbm_checklist A \n")
					.append("INNER JOIN vtbm_check_item B \n")
					.append("	ON A.item_cd = B.item_cd\n")
					.append("	AND A.item_seq = B.item_seq\n")
					.append("	AND A.item_cd_rev = B.revision_no\n")
					.append("	AND A.member_key = B.member_key\n")
					.append("INNER JOIN 	v_checklist_gubun C \n")
					.append("	ON A.check_gubun = C.code_value \n")
					.append("	AND A.member_key = C.member_key \n")
					.append("WHERE  1=1					\n")
					.append("AND check_gubun = '" + jArray.get("check_gubun") + "' \n") 
					.append("AND A.member_key = '" + jArray.get("member_key") + "' \n") 
					.toString();
			resultString = super.excuteQueryString(con, sql.toString());
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M09S030100E194()","==== SQL ERROR ===="+ e.getMessage());
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
	    // 결과 전문 구성을 위한 파라미터들을 아이오 파라미터에 저장한다.
		ioParam.setResultString(resultString);
		// 수퍼에서 처리된 칼럼의 갯수를 클라이언트에게 보내기 위해 가져온다.
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
		// 잘 처리되었다는 메시지를 클라이언트에게 보내기 위해 I/O파라미터에 저장한다.
    	ioParam.setMessage(MessageDefine.M_QUERY_OK);
	    return EventDefine.E_QUERY_RESULT;
	}
	
	public int E304(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			// 클라이언트로 부터 받은 파라미터를 옮겨 담는다.
			String rcvData = (String)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			// 클라이언트로 부터 받은 파라미터를 쪼개어서 배열에 담는다.
			// rcvData = [위경도]
			String[][] c_paramArray = CommonFunction.getConvString2DoubleArray(rcvData);
			
			String sql = new StringBuilder()
					.append("SELECT																					\n")
//					.append("	item_cd||'['||item_desc||' : '||item_bigo||']'||'.'||item_seq||'.'||revision_no		\n")
					.append("	item_cd,																			\n")
					.append("	item_desc,																			\n")
					.append("	item_bigo,																			\n")
					.append("	item_seq,																			\n")
					.append("	revision_no																			\n")
					.append("FROM																					\n")
					.append("	vtbm_check_item																		\n")
					.append("WHERE member_key='"+ c_paramArray[0][0]+"'	\n")
					.append("ORDER BY item_cd, item_seq																\n")
					.toString();
			resultString = super.excuteQueryString(con, sql.toString());
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M09S030100E304()","==== SQL ERROR ===="+ e.getMessage());
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
	    // 결과 전문 구성을 위한 파라미터들을 아이오 파라미터에 저장한다.
		ioParam.setResultString(resultString);
		// 수퍼에서 처리된 칼럼의 갯수를 클라이언트에게 보내기 위해 가져온다.
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
		// 잘 처리되었다는 메시지를 클라이언트에게 보내기 위해 I/O파라미터에 저장한다.
    	ioParam.setMessage(MessageDefine.M_QUERY_OK);
	    return EventDefine.E_QUERY_RESULT;
	}

	
	public String innerSql001(String checkListCode){
		String myResultString = "";
		try {
			String sql = new StringBuilder()
					.append("SELECT											\n")
					.append("	coalesce(MAX(checklist_seq),0)+1			\n")
					.append("FROM											\n")
					.append("	tbm_checklist								\n")
					.append("WHERE checklist_cd like '" + checkListCode + "%'	\n") //'CHK-002'
					.toString();
			System.out.println("\n\n"+ sql.toString() +"\n\n");
			myResultString = super.excuteQueryString(con, sql.toString());
		} catch(Exception e) {
			myResultString = "";
	    }
	    return myResultString;
	}
}