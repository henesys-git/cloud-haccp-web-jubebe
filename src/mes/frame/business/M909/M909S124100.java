package mes.frame.business.M909;

import java.lang.reflect.Method;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.util.Vector;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;

import mes.client.conf.Config;
import mes.frame.common.EventDefine;
import mes.frame.common.HashObject;
import mes.frame.common.MessageDefine;
import mes.frame.database.JDBCConnectionPool;
import mes.frame.database.SqlAdapter;
import mes.frame.serviceinterface.InoutParameter;
import mes.frame.serviceinterface.LoggingWriter;
import mes.frame.util.CommonFunction;


public class M909S124100 extends SqlAdapter{
	Connection con = null;
	PreparedStatement pstmt = null;
	String resultString = "";
	int resultInt = -1;
	StringBuffer sql = new StringBuffer();
	
	String[][] v_paramArray = new String[0][0]; 
	Class[] optClass = null;
	Object[] optObj = null;
	Object obj = null;
	
	public M909S124100(){
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

			Method method = M909S124100.class.getMethod(event,optClass);
			LoggingWriter.setLogDebug(M909S124100.class.getName(),"==== " + event + " EventMethod Create Success ====");

			obj = method.invoke(M909S124100.class.newInstance(),optObj);
			doExcute_result = CommonFunction.getInt(obj.toString());
			
	    } catch (Exception ex) {
	    	doExcute_result = EventDefine.E_DOEXCUTE_INIT;
			ioParam.setMessage(MessageDefine.M_NO_EVENTID);
			LoggingWriter.setLogError(M909S124100.class.getName(),"==== EventID Not define : EVENT ID [ " + ioParam.getEventID() + "]");
	    } finally {
	    	obj = null;
			optClass = null;
			optObj = null;
	    }
	    long endTime = System.currentTimeMillis();
		long runningTime = endTime - startTime;
		LoggingWriter.setLogAll(M909S124100.class.getName(),"==== Query [수행시간  : " + runningTime + " ms]");
		
		return doExcute_result;
	}
	

	public int E101(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
    		// insert_update_delete_json.jsp에서 받아온 JSON데이터 처리
    		JSONObject jArray = new JSONObject();
    		jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
    		System.out.println("JSONObject jArray rcvData="+ jArray.toString());
    		// Object데이터에서 키값(param)으로 JSONArray데이터를 꺼낸다. (데이터묶음 하나일땐 생략)
    		JSONArray jjArray = (JSONArray) jArray.get("param");
    		System.out.println("데이터 묶음 개수 :::: " + jjArray.size());
    		
			
//			String[][] c_paramArray_Head=null;
//			String[][] c_paramArray_Detail=null;
			// 클라이언트로 부터 받은 파라미터를 옮겨 담는다.
//			String rcvData = (String)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
//			Vector resultVector = CommonFunction.getConvStringDamogjuk(rcvData);

			con.setAutoCommit(false);
			
//			c_paramArray_Head = (String[][])resultVector.get(0);//head table
//    		c_paramArray_Detail=(String[][])resultVector.get(1); //data table
			
			// 클라이언트로 부터 받은 파라미터를 쪼개어서 배열에 담는다. MAX
//			String[][] c_paramArray = CommonFunction.getConvString2DoubleArray(rcvData);
    		
			for(int i=0; i<jjArray.size(); i++) {   
				JSONObject jjjArray = (JSONObject)jjArray.get(i); // i번째 데이터묶음
//				String sql = new StringBuilder()
//					.append("INSERT INTO\n")
//					.append("	tbm_import_inspect_checklist (\n")
//					.append("	create_user_id,\n")
//					.append("	part_cd,\n")
//					.append("	part_cd_rev,\n")
//					.append("	pic_seq,\n")
//					.append("	checklist_cd,\n")
//					.append("	checklist_cd_rev,\n")
//					.append("	checklist_seq,\n")
//					.append("	item_cd,\n")
//					.append("	item_cd_rev,\n")
//					.append("	item_seq,\n")
//					.append("	standard_guide,\n")
//					.append("	standard_value,\n")
//					.append("	check_note,\n")
//					.append("	start_date\n")
//					.append(" 		,member_key						\n") // member_key_insert
//					.append("	)\n")
//					.append("VALUES	(\n")
//					.append(" 		'" 		+ jjjArray.get("user_id") + "' \n") 	//create_user_id
//					.append(" 		,'" 	+ jjjArray.get("part_cd") + "' \n") 	//part_cd
//					.append(" 		, '" 	+ jjjArray.get("part_cd_rev") + "' \n") 	//part_cd_rev
//					.append(" 		, SELECT NVL(MAX(pic_seq),0)+1 FROM tbm_import_inspect_checklist where part_cd ='" + jjjArray.get("part_cd") + "' \n") 	//pic_seq 채번
//					.append(" 		,'" 	+ jjjArray.get("checklist_cd") + "' \n") 	//checklist_cd
//					.append(" 		,'" 	+ jjjArray.get("checklist_cd_rev") + "' \n") 	//checklist_cd_rev
//					.append(" 		,'" 	+ jjjArray.get("checklist_seq") + "' \n") 	//checklist_seq
//					.append(" 		,'" 	+ jjjArray.get("item_cd") + "' \n") 	//item_cd
//					.append(" 		,'" 	+ jjjArray.get("item_cd_rev") + "' \n") 	//item_cd_rev
//					.append(" 		,'" 	+ jjjArray.get("item_seq") + "' \n") 	//item_seq
//					.append(" 		,'" 	+ jjjArray.get("standard_guide") + "' \n") 	//standard_guide
//					.append(" 		,'" 	+ jjjArray.get("standard_value") + "' \n") 	//standard_value
//					.append(" 		,'" 	+ jjjArray.get("check_note") + "' \n") 	//check_note
//					.append(" 		, to_char(SYSDATE,'YYYY-MM-DD')   \n") 	//start_date
//					.append(" 		,'" + jjjArray.get("member_key") + "' \n") //member_key_values
//					.append("	)\n")
//				.toString();
					
				
				String sql = new StringBuilder()
						.append("MERGE  INTO  tbm_import_inspect_checklist mm\n")
						.append("USING ( SELECT      \n")
						.append("        '" 		+ jjjArray.get("user_id") + "' AS create_user_id,\n")
						.append("        '" 	    + jjjArray.get("part_cd") + "' AS part_cd,\n")
						.append("        '" 	    + jjjArray.get("part_cd_rev") + "' AS part_cd_rev,\n")
						.append("        (SELECT NVL(MAX(pic_seq),0)+1 FROM tbm_import_inspect_checklist where part_cd = '" + jjjArray.get("part_cd") + "') AS pic_seq,\n")
						.append("        '" 	    + jjjArray.get("checklist_cd") + "' AS checklist_cd,\n")
						.append("        '" 	    + jjjArray.get("checklist_cd_rev") + "' AS checklist_cd_rev,\n")
						.append("        '" 	    + jjjArray.get("checklist_seq") + "' AS checklist_seq,\n")
						.append("        '" 	    + jjjArray.get("item_cd") + "' AS item_cd,\n")
						.append("        '" 	    + jjjArray.get("item_cd_rev") + "' AS item_cd_rev,\n")
						.append("        '" 	    + jjjArray.get("item_seq") + "' AS item_seq,\n")
						.append("        '" 	    + jjjArray.get("standard_guide") + "' AS standard_guide,\n")
						.append("        '" 	    + jjjArray.get("standard_value") + "' AS standard_value,\n")
						.append("        '" 	    + jjjArray.get("check_note") + "' AS check_note,\n")
						.append("        to_char(SYSDATE,'YYYY-MM-DD') AS start_date,\n")
						.append("        '" 	    + jjjArray.get("member_key") + "' AS member_key\n")
						.append(" )  mQ\n")
						.append("ON (\n")
						.append("mm.part_cd_rev = mQ.part_cd_rev AND	\n")
						.append("mm.checklist_cd_rev = mQ.checklist_cd_rev AND	\n")
						.append("mm.item_cd_rev = mQ.item_cd_rev AND	\n")
						.append("mm.part_cd = mQ.part_cd AND	\n")
						.append("mm.checklist_cd = mQ.checklist_cd AND\n")
						.append("mm.checklist_seq = mQ.checklist_seq AND	\n")
						.append("mm.item_cd = mQ.item_cd AND\n")
						.append("mm.item_seq = mQ.item_seq AND\n")
						.append("mm.member_key = mQ.member_key\n")
						.append(") \n")
						.append("WHEN MATCHED THEN\n")
						.append("UPDATE SET\n")
						.append("mm.create_user_id = mQ.create_user_id,\n")
						.append("mm.part_cd = mQ.part_cd,\n")
						.append("mm.part_cd_rev = mQ.part_cd_rev,\n")
						.append("mm.pic_seq = mQ.pic_seq,\n")
						.append("mm.checklist_cd = mQ.checklist_cd,\n")
						.append("mm.checklist_cd_rev = mQ.checklist_cd_rev,\n")
						.append("mm.checklist_seq = mQ.checklist_seq,\n")
						.append("mm.item_cd = mQ.item_cd,\n")
						.append("mm.item_cd_rev = mQ.item_cd_rev,\n")
						.append("mm.item_seq = mQ.item_seq,\n")
						.append("mm.standard_guide = mQ.standard_guide,\n")
						.append("mm.standard_value = mQ.standard_value,\n")
						.append("mm.check_note = mQ.check_note,\n")
						.append("mm.start_date = mQ.start_date,\n")
						.append("mm.member_key = mQ.member_key\n")
						.append("WHEN NOT MATCHED THEN\n")
						.append("INSERT  (\n")
						.append("mm.create_user_id,\n")
						.append("mm.part_cd,\n")
						.append("mm.part_cd_rev,\n")
						.append("mm.pic_seq,\n")
						.append("mm.checklist_cd,\n")
						.append("mm.checklist_cd_rev,\n")
						.append("mm.checklist_seq,\n")
						.append("mm.item_cd,\n")
						.append("mm.item_cd_rev,\n")
						.append("mm.item_seq,\n")
						.append("mm.standard_guide,\n")
						.append("mm.standard_value,\n")
						.append("mm.check_note,\n")
						.append("mm.start_date,\n")
						.append("mm.member_key\n")
						.append(")\n")
						.append("VALUES  (\n")
						.append("mQ.create_user_id,\n")
						.append("mQ.part_cd,\n")
						.append("mQ.part_cd_rev,\n")
						.append("mQ.pic_seq,\n")
						.append("mQ.checklist_cd,\n")
						.append("mQ.checklist_cd_rev,\n")
						.append("mQ.checklist_seq,\n")
						.append("mQ.item_cd,\n")
						.append("mQ.item_cd_rev,\n")
						.append("mQ.item_seq,\n")
						.append("mQ.standard_guide,\n")
						.append("mQ.standard_value,\n")
						.append("mQ.check_note,\n")
						.append("mQ.start_date,\n")
						.append("mQ.member_key\n")
						.append(")\n")
						.toString();

				
				resultInt = super.excuteUpdate(con, sql.toString());
				if (resultInt < 0) {
					con.rollback();
					return EventDefine.E_DOEXCUTE_ERROR ;
				}
			}
			con.commit();
		} catch(Exception e) {
			LoggingWriter.setLogError("M909S124100E101()","==== SQL ERROR ===="+ e.getMessage() + "\n" + sql.toString());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M909S124100E101()","==== finally ===="+ e.getMessage());
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

	public int E111(InoutParameter ioParam){
		return this.E101(ioParam);
	}
	public int E112(InoutParameter ioParam){
		return this.E102(ioParam);
	}
	public int E113(InoutParameter ioParam){
		return this.E103(ioParam);
	}
	
	public int E102(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			// 클라이언트로 부터 받은 파라미터를 옮겨 담는다.
			String rcvData = (String)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			
			// 클라이언트로 부터 받은 파라미터를 쪼개어서 배열에 담는다.
			String[][] c_paramArray = CommonFunction.getConvString2DoubleArray(rcvData);

			String sql = new StringBuilder()
				.append("UPDATE tbm_menu SET \n" ) 
//				.append("	 menu_id= '" + c_paramArray[0][0] + "' \n")
				.append("	 menu_name= '" + c_paramArray[0][1] + "' \n")
				.append("	,menu_level= '" + c_paramArray[0][2] + "' \n")
				.append("	,order_index= '" + c_paramArray[0][3] + "' \n")
				.append("	,delyn= '" + c_paramArray[0][4] + "' \n")
				.append("	,parent_menu_id= '" + c_paramArray[0][5] + "' \n")
				.append("	,program_id= '" + c_paramArray[0][6] + "' \n")
				.append("	,update_user= '" + c_paramArray[0][7] + "' \n")
				.append("	,updatedate= SYSDATETIME \n")
				.append(" 	,member_key = 	'" + c_paramArray[0][8] + "'		\n")
				.append(" WHERE \n")	//menu_id
				.append(" 	program_id='" 	+ c_paramArray[0][6] + "' \n")
				.append(" 	AND member_key = '" + c_paramArray[0][8] + "' \n") //member_key_select, update, delete
				.toString();
					
			// System.out.println(sql.toString());
			
				resultInt = super.excuteUpdate(con, sql.toString());
				if (resultInt < 0) {
					ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
				} else {
					ioParam.setMessage(resultInt + "건 " + MessageDefine.M_INSERT_RESULT);
				}
				
		} catch(Exception e) {
			LoggingWriter.setLogError("M909S124100E102()","==== SQL ERROR ===="+ e.getMessage() + "\n" + sql.toString());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M909S124100E102()","==== finally ===="+ e.getMessage());
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
					.append("DELETE FROM tbm_import_inspect_checklist WHERE \n")	//menu_id
					.append(" 	part_cd='" 	+ jArray.get("part_cd") + "' \n")
					.append(" 	AND checklist_cd='" + jArray.get("checklist_cd") + "' \n")
					.append(" 	AND member_key = '" + jArray.get("member_key") + "' \n") //member_key_select, update, delete
				.toString();
					
				resultInt = super.excuteUpdate(con, sql.toString());
				if (resultInt < 0) {
					ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
				} else {
					ioParam.setMessage(resultInt + "건 " + MessageDefine.M_INSERT_RESULT);
				}
				
		} catch(Exception e) {
			LoggingWriter.setLogError("M909S124100E103()","==== SQL ERROR ===="+ e.getMessage() + "\n" + sql.toString());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M909S124100E103()","==== finally ===="+ e.getMessage());
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
			
			// 클라이언트로 부터 받은 파라미터를 옮겨 담는다.
			String rcvData = (String)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			// 클라이언트로 부터 받은 파라미터를 쪼개어서 배열에 담는다.
			// rcvData = [위경도]
			String[][] c_paramArray = CommonFunction.getConvString2DoubleArray(rcvData);
			String sql = new StringBuilder()
					.append("SELECT\n")
					.append("	A.part_cd,\n")
					.append("	A.revision_no,\n")
					.append("	A.part_nm,\n")
					.append("	A.gyugyeok,\n")
					.append("	A.unit_weight,\n")
					.append("	A.safety_jaego,\n")
					.append("	A.file_2d,\n")
					.append("	A.unit_price,\n")
					.append("	A.start_date,\n")
					.append("	A.alt_part_cd,\n")
					.append("	B.part_nm AS alt_part_nm\n")
					.append("FROM\n")
					.append("	tbm_part_list A \n")
					.append("	LEFT OUTER JOIN tbm_part_list B \n")
					.append("	ON A.alt_part_cd = B.part_cd\n")
					.append("	AND A.alt_revision_no = B.revision_no\n")
					.append("	AND A.member_key = B.member_key\n")
					.append(" " + c_paramArray[0][0] + "\n" )
					.append(" 	AND A.member_key = '" + c_paramArray[0][1] + "' \n") //member_key_select, update, delete
					.toString();

			resultString = super.excuteQueryString(con, sql.toString());
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M909S124100E104()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M909S124100E104()","==== finally ===="+ e.getMessage());
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
	
	// 헤드메뉴 
	public int E105(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			// 클라이언트로 부터 받은 파라미터를 옮겨 담는다.
			String rcvData = (String)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			// 클라이언트로 부터 받은 파라미터를 쪼개어서 배열에 담는다.
			// rcvData = [위경도]
			String[][] c_paramArray = CommonFunction.getConvString2DoubleArray(rcvData);
			String sql = new StringBuilder()
					.append("SELECT\n")
					.append("	A.part_cd,\n")
					.append("	A.revision_no,\n")
					.append("	A.part_nm,\n")
					.append("	A.gyugyeok,\n")
					.append("	A.unit_weight,\n")
					.append("	A.safety_jaego,\n")
					.append("	A.file_2d,\n")
					.append("	A.unit_price,\n")
					.append("	A.start_date,\n")
					.append("	A.alt_part_cd,\n")
					.append("	B.part_nm AS alt_part_nm\n")
					.append("FROM\n")
					.append("	tbm_part_list A \n")
					.append("	LEFT OUTER JOIN tbm_part_list B \n")
					.append("	ON A.alt_part_cd = B.part_cd\n")
					.append("	AND A.alt_revision_no = B.revision_no\n")
					.append("	AND A.member_key = B.member_key\n")
					.append(" " + c_paramArray[0][0] + "\n" )
					.append("WHERE TO_CHAR(SYSDATE,'YYYY-MM-DD') BETWEEN  start_date AND duration_date\n")
					.append(" 	AND A.member_key = '" + c_paramArray[0][1] + "' \n") //member_key_select, update, delete
					.toString();

			resultString = super.excuteQueryString(con, sql.toString());
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M909S124100E105()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M909S124100E105()","==== finally ===="+ e.getMessage());
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
//메뉴 의 프로그램 목록
	public int E114(InoutParameter ioParam){
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
					.append("        K.pic_seq,\n")
					.append("        K.part_cd,\n")
					.append("        P.part_nm,\n")
					.append("        K.checklist_cd,\n")
					.append("        K.checklist_seq,\n")
					.append("        K.checklist_cd_rev,\n")
					.append("        k.item_cd,\n")
					.append("        B.item_desc,\n")
					.append("        K.item_seq,\n")
					.append("        K.item_cd_rev,\n")
					.append("        K.standard_guide,\n")
					.append("        K.check_note,\n")
					.append("        K.standard_value,\n")
					.append("         '<input type='  ||  item_type || ' id=' || item_type || '1'  || ' /input>' AS html_tag,\n")
					.append("        B.item_type,\n")
					.append("        B.item_bigo\n")
					.append("FROM\n")
					.append("		tbm_import_inspect_checklist K\n")
//					.append("        INNER JOIN      tbm_checklist A\n")
//					.append("        ON K.checklist_cd = A.checklist_cd\n")
//					.append("        AND K.checklist_seq = A.checklist_seq\n")
//					.append("        AND K.checklist_cd_rev = A.revision_no\n")
					.append("        INNER JOIN tbm_check_item B\n")
					.append("        ON K.item_cd = B.item_cd\n")
					.append("        AND K.item_seq = B.item_seq\n")
					.append("        AND K.item_cd_rev = B.revision_no\n")
					.append("		 AND K.member_key = B.member_key\n")
					.append("        INNER JOIN tbm_part_list P\n")
					.append("        ON K.part_cd = P.part_cd\n")
					.append("        AND K.part_cd_rev = P.revision_no\n")
					.append("		 AND K.member_key = P.member_key\n")
					.append(" where \n")
					.append("	K.part_cd = '" + jArray.get("PART_CD") + "' \n") 
					.append(" 	AND K.member_key = '" + jArray.get("member_key") + "' \n") //member_key_select, update, delete
					.toString();
			
			resultString = super.excuteQueryString(con, sql.toString());
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M909S124100E114()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M909S124100E114()","==== finally ===="+ e.getMessage());
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
	
	public int E174(InoutParameter ioParam){
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
					.append("SELECT \n")
					.append("		checklist_seq,\n")
					.append("		B.part_nm,\n")
					.append("		A.part_cd,\n")
					.append("		A.part_cd_rev,\n")
					.append("		pic_seq,\n")
					.append("		checklist_cd,\n")
					.append("		checklist_cd_rev,\n")
					.append("		item_cd,\n")
					.append("		item_cd_rev,\n")
					.append("		item_seq,\n")
					.append("		standard_guide,\n")
					.append("		standard_value,\n")
					.append("		check_note,\n")
					.append("		A.start_date\n")
					.append("FROM 	tbm_import_inspect_checklist A\n")
					.append("		INNER JOIN vtbm_part_list B\n")
					.append("		ON A.part_cd = B.part_cd\n")
					.append("		AND A.part_cd_rev = B.revision_no\n")
					.append("		AND A.member_key = B.member_key\n")
					.append("WHERE	A.part_cd = '" + jArray.get("PART_CD") + "' \n") 
					.append("AND	A.part_cd_rev = '" + jArray.get("PART_CD_REV") + "' \n")
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
			LoggingWriter.setLogError("M909S124100E174()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M909S124100E174()","==== finally ===="+ e.getMessage());
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