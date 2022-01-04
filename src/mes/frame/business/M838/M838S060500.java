package mes.frame.business.M838;

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
import mes.frame.common.QueueProcessing;
import mes.frame.database.JDBCConnectionPool;
import mes.frame.database.SqlAdapter;
import mes.frame.serviceinterface.InoutParameter;
import mes.frame.serviceinterface.LoggingWriter;
import mes.frame.util.CommonFunction;


public class M838S060500 extends SqlAdapter{
	Connection con = null;
	PreparedStatement pstmt = null;
	String resultString = "";
	int resultInt = -1;
	StringBuffer sql = new StringBuffer();
	QueueProcessing Queue = new QueueProcessing();
	
	String[][] v_paramArray = new String[0][0]; 
	Class[] optClass = null;
	Object[] optObj = null;
	Object obj = null;
	
	public M838S060500(){
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
			
			Method method = M838S060500.class.getMethod(event,optClass);
			LoggingWriter.setLogDebug(M838S060500.class.getName(),"==== " + event + " EventMethod Create Success ====");

			obj = method.invoke(M838S060500.class.newInstance(),optObj);
			doExcute_result = CommonFunction.getInt(obj.toString());
			
	    } catch (Exception ex) {
	    	doExcute_result = EventDefine.E_DOEXCUTE_INIT;
			ioParam.setMessage(MessageDefine.M_NO_EVENTID);
			LoggingWriter.setLogError(M838S060500.class.getName(),"==== EventID Not define : EVENT ID [ " + ioParam.getEventID() + "]");
	    } finally {
	    	obj = null;
			optClass = null;
			optObj = null;
	    }
	    long endTime = System.currentTimeMillis();
		long runningTime = endTime - startTime;
		LoggingWriter.setLogAll(M838S060500.class.getName(),"==== Query [수행시간  : " + runningTime + " ms]");
		
		return doExcute_result;
	}
	
	// S838S060501.jsp 등록화면(Tablet)
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
	    		JSONArray jjArray = (JSONArray) jArray.get("param");
				

				
				for(int i=0; i<jjArray.size(); i++) {	
					JSONObject jjjArray = (JSONObject)jjArray.get(i); // i번째 데이터묶음
					
					String sql = "";
					StringBuilder _sql = new StringBuilder()
							.append("MERGE INTO haccp_vhcl_clean_checklist mm \n")
							.append("USING (\n")
							.append("	SELECT\n")
							.append(" 		'"	+ jjjArray.get("vhcl_no") 			+ "' AS vhcl_no,	\n")
							.append(" 		'"	+ jjjArray.get("vhcl_no_rev") 		+ "' AS vhcl_no_rev,	\n")
							.append(" 		'"	+ jjjArray.get("service_date") 		+ "' AS service_date,	\n")
							.append(" 		'"	+ jjjArray.get("driver") 		+ "' AS driver,	\n")
							.append(" 		'"	+ jjjArray.get("check_gubun") 		+ "' AS check_gubun,	\n")
							.append(" 		'"	+ jjjArray.get("check_gubun_mid") 	+ "' AS check_gubun_mid,	\n")
	 						.append(" 		'"	+ jjjArray.get("check_gubun_sm") 	+ "' AS check_gubun_sm,	\n")
	 						.append(" 		'"	+ jjjArray.get("checklist_cd") 		+ "' AS checklist_cd,	\n")
	 						.append(" 		'"	+ jjjArray.get("cheklist_cd_rev") 	+ "' AS cheklist_cd_rev,	\n")
	 						.append(" 		'"	+ jjjArray.get("checklist_seq") 	+ "' AS checklist_seq,	\n")
	 						.append(" 		'"	+ jjjArray.get("item_cd") 			+ "' AS item_cd,	\n")
	 						.append(" 		'"	+ jjjArray.get("item_seq") 			+ "' AS item_seq,	\n")
	 						.append(" 		'"	+ jjjArray.get("item_cd_rev") 		+ "' AS item_cd_rev,	\n")
	 						.append(" 		'"	+ jjjArray.get("standard_guide") 	+ "' AS standard_guide,	\n")
	 						.append(" 		'"	+ jjjArray.get("standard_value") 	+ "' AS standard_value,	\n")
	 						.append(" 		'"	+ jjjArray.get("check_note") 		+ "' AS check_note,	\n")
	 						.append(" 		'"	+ jjjArray.get("check_value") 		+ "' AS check_value,	\n");
	 					
 					if( jjjArray.get("FLAG") != "NM" )
 					{
 						_sql.append(" 		'"	+ jjjArray.get("strange_date") 		+ "' AS strange_date,	\n")
	 						.append(" 		'"	+ jjjArray.get("strange_note") 		+ "' AS strange_note,	\n")
	 						.append(" 		'"	+ jjjArray.get("strange_result")+ "' AS strange_result,	\n")
	 						.append(" 		'"	+ jjjArray.get("strange_result_date") 		+ "' AS strange_result_date,	\n")
	 						.append(" 		'"	+ jjjArray.get("strange_result_person") 		+ "' AS strange_result_person,	\n")
	 						.append(" 		'"	+ jjjArray.get("strange_result_check") 		+ "' AS strange_result_check,	\n");
 					}
	 					
 						_sql.append(" 		'"	+ jjjArray.get("writor_main") 		+ "' AS writor_main,	\n")
	 						.append(" 		'"	+ jjjArray.get("writor_main_rev") 	+ "' AS writor_main_rev,	\n")
	 						.append(" 		'"	+ jjjArray.get("write_date") 		+ "' AS write_date,	\n")
	 					
	 						.append(" 		'"	+ jjjArray.get("check_person") 			+ "' AS check_person,	\n")
	 						.append(" 		'"	+ jjjArray.get("check_date") 		+ "' AS check_date,	\n")
	 						.append(" 		'"	+ jjjArray.get("approval") 			+ "' AS approval,	\n")
	 						.append(" 		'"	+ jjjArray.get("approval_date") 	+ "' AS approval_date,	\n")
	 						.append(" 		'"	+ jjjArray.get("member_key") 		+ "' AS member_key \n")
	 						.append("	FROM db_root  )  mQ	\n")
							.append("ON (mm.vhcl_no = mQ.vhcl_no AND mm.vhcl_no_rev = mQ.vhcl_no_rev AND mm.service_date = mQ.service_date AND mm.driver = mQ.driver	\n")
							.append("	AND mm.check_gubun = mQ.check_gubun AND mm.check_gubun_mid = mQ.check_gubun_mid	\n")
							.append("	AND mm.check_gubun_sm = mQ.check_gubun_sm AND mm.checklist_cd = mQ.checklist_cd AND mm.cheklist_cd_rev = mQ.cheklist_cd_rev	\n")
							.append("	AND mm.checklist_seq = mQ.checklist_seq AND mm.member_key=mQ.member_key	\n")
							.append("	AND mm.driver = mQ.driver )	\n")
							.append("WHEN MATCHED THEN \n")
							.append("	UPDATE SET \n")
							.append("		mm.vhcl_no = mQ.vhcl_no, \n")
							.append("		mm.vhcl_no_rev = mQ.vhcl_no_rev, \n")
							.append("		mm.service_date = mQ.service_date, \n")
							.append("		mm.driver = mQ.driver, \n")
							.append("		mm.check_gubun = mQ.check_gubun, \n")
							.append("		mm.check_gubun_mid = mQ.check_gubun_mid, \n")
							.append("		mm.check_gubun_sm = mQ.check_gubun_sm, \n")
							.append("		mm.checklist_cd = mQ.checklist_cd, \n")
							.append("		mm.cheklist_cd_rev = mQ.cheklist_cd_rev, \n")
							.append("		mm.checklist_seq = mQ.checklist_seq, \n")
							.append("		mm.item_cd = mQ.item_cd, \n")
							.append("		mm.item_seq = mQ.item_seq, \n")
							.append("		mm.item_cd_rev = mQ.item_cd_rev, \n")
							.append("		mm.standard_guide = mQ.standard_guide, \n")
							.append("		mm.standard_value = mQ.standard_value, \n")
							.append("		mm.check_note = mQ.check_note, \n")
							.append("		mm.check_value = mQ.check_value, \n");
							
					if( jjjArray.get("FLAG") != "NM" )
					{
						_sql.append("		mm.strange_date = mQ.strange_date, \n")
							.append("		mm.strange_note = mQ.strange_note, \n")
							.append("		mm.strange_result = mQ.strange_result, \n")
							.append("		mm.strange_result_date = mQ.strange_result_date, \n")
							.append("		mm.strange_result_person = mQ.strange_result_person, \n")
							.append("		mm.strange_result_check = mQ.strange_result_check, \n");
					}
						
						_sql.append("		mm.writor_main = mQ.writor_main, \n")
							.append("		mm.writor_main_rev = mQ.writor_main_rev, \n")
							.append("		mm.write_date = mQ.write_date, \n")
						
							.append("		mm.check_person = mQ.check_person, \n")
							.append("		mm.check_date = mQ.check_date, \n")
							.append("		mm.approval = mQ.approval, \n")
							.append("		mm.approval_date = mQ.approval_date, \n")
							.append("		mm.member_key = mQ.member_key \n")
							.append("WHEN NOT MATCHED THEN \n")
							.append("	INSERT (\n")
							.append("		mm.vhcl_no,\n")
							.append("		mm.vhcl_no_rev,\n")
							.append("		mm.service_date,\n")
							.append("		mm.driver,\n")
							.append("		mm.check_gubun,\n")
							.append("		mm.check_gubun_mid,\n")
							.append("		mm.check_gubun_sm,\n")
							.append("		mm.checklist_cd,\n")
							.append("		mm.cheklist_cd_rev,\n")
							.append("		mm.checklist_seq,\n")
							.append("		mm.item_cd,\n")
							.append("		mm.item_seq,\n")
							.append("		mm.item_cd_rev,\n")
							.append("		mm.standard_guide,\n")
							.append("		mm.standard_value,\n")
							.append("		mm.check_note,\n")
							.append("		mm.check_value,\n");
						
				if( jjjArray.get("FLAG") != "NM" )
				{
						_sql.append("		mm.strange_date,\n")
							.append("		mm.strange_note,\n")
							.append("		mm.strange_result,\n")
							.append("		mm.strange_result_date,\n")
							.append("		mm.strange_result_person,\n")
							.append("		mm.strange_result_check,\n");
				}
						
						_sql.append("		mm.writor_main,\n")
							.append("		mm.writor_main_rev,\n")
							.append("		mm.write_date,\n")
						
							.append("		mm.check_person,\n")
							.append("		mm.check_date,\n")
							.append("		mm.approval,\n")
							.append("		mm.approval_date,\n")
							.append("		mm.member_key\n")
							.append(" 	) VALUES (\n")
							.append("		mQ.vhcl_no,\n")
							.append("		mQ.vhcl_no_rev,\n")
							.append("		mQ.service_date,\n")
							.append("		mQ.driver,\n")
							.append("		mQ.check_gubun,\n")
							.append("		mQ.check_gubun_mid,\n")
							.append("		mQ.check_gubun_sm,\n")
							.append("		mQ.checklist_cd,\n")
							.append("		mQ.cheklist_cd_rev,\n")
							.append("		mQ.checklist_seq,\n")
							.append("		mQ.item_cd,\n")
							.append("		mQ.item_seq,\n")
							.append("		mQ.item_cd_rev,\n")
							.append("		mQ.standard_guide,\n")
							.append("		mQ.standard_value,\n")
							.append("		mQ.check_note,\n")
							.append("		mQ.check_value,\n");
						
							
						if( jjjArray.get("FLAG") != "NM" )
						{
						_sql.append("		mQ.strange_date,\n")
							.append("		mQ.strange_note,\n")
							.append("		mQ.strange_result,\n")
							.append("		mQ.strange_result_date,\n")
							.append("		mQ.strange_result_person,\n")
							.append("		mQ.strange_result_check,\n");
						}
						
						_sql.append("		mQ.writor_main,\n")
							.append("		mQ.writor_main_rev,\n")
							.append("		mQ.write_date,\n")
						
							.append("		mQ.check_person,\n")
							.append("		mQ.check_date,\n")
							.append("		mQ.approval,\n")
							.append("		mQ.approval_date,\n")
							.append("		mQ.member_key\n")
							.append("	)  \n")
						.toString();
				
					resultInt = super.excuteUpdate(con, _sql.toString());
			    	if(resultInt < 0){  //
						ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
						con.rollback();
						return EventDefine.E_DOEXCUTE_ERROR ;
					}
				}
				con.commit();
			} catch(Exception e) {
				e.getStackTrace();
				LoggingWriter.setLogError("M838S060500E101()","==== SQL ERROR ===="+ e.getMessage());
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
	    		JSONArray jjArray = (JSONArray) jArray.get("param");
				

				
				for(int i=0; i<jjArray.size(); i++) {	
					JSONObject jjjArray = (JSONObject)jjArray.get(i); // i번째 데이터묶음
					
					String sql = new StringBuilder()
							.append("UPDATE																		\n")
							.append("	haccp_vhcl_clean_checklist												\n")
							.append("SET																		\n")
							.append("	vhcl_no = '" 				+ jjjArray.get("vhcl_no") 				+"',\n")
							.append("	vhcl_no_rev = '" 			+ jjjArray.get("vhcl_no_rev") 			+"',\n")
							.append("	service_date = '"			+ jjjArray.get("service_date") 			+"',\n")
							.append("	driver = '"					+ jjjArray.get("driver") 				+"',\n")
							
							.append("	check_gubun='"				+ jjjArray.get("check_gubun") 			+"',\n")
							.append("	check_gubun_mid='"			+ jjjArray.get("check_gubun_mid") 		+"',\n")
							.append("	check_gubun_sm='"			+ jjjArray.get("check_gubun_sm") 		+"',\n")
							.append("	checklist_cd='"				+ jjjArray.get("checklist_cd") 			+"',\n")
							.append("	cheklist_cd_rev='"			+ jjjArray.get("cheklist_cd_rev") 		+"',\n")
							.append("	checklist_seq='"			+ jjjArray.get("checklist_seq") 		+"',\n")
							.append("	item_cd='"					+ jjjArray.get("item_cd") 				+"',\n")
							.append("	item_seq='"					+ jjjArray.get("item_seq") 				+"',\n")
							.append("	item_cd_rev='"				+ jjjArray.get("item_cd_rev") 			+"',\n")
							.append("	standard_guide='"			+ jjjArray.get("standard_guide") 		+"',\n")
							.append("	standard_value='"			+ jjjArray.get("standard_value") 		+"',\n")
							.append("	check_note='"				+ jjjArray.get("check_note") 			+"',\n")
							.append("	check_value='"				+ jjjArray.get("check_value") 			+"',\n")
							
							.append("	strange_date='"				+ jjjArray.get("strange_date")			+"',\n")
							.append("	strange_note='"				+ jjjArray.get("strange_note")			+"',\n")
							.append("	strange_result='"			+ jjjArray.get("strange_result")		+"',\n")
							.append("	strange_result_date='"		+ jjjArray.get("strange_result_date")	+"',\n")
							.append("	strange_result_person='"	+ jjjArray.get("strange_result_person")	+"',\n")
							.append("	strange_result_check='"		+ jjjArray.get("strange_result_check")	+"',\n")
							
							.append("	writor_main='"				+ jjjArray.get("writor_main") 			+"',\n")
							.append("	writor_main_rev='"			+ jjjArray.get("writor_main_rev") 		+"',\n")
							.append("	write_date='"				+ jjjArray.get("write_date") 			+"',\n")
							.append("	check_person='"				+ jjjArray.get("check_person") 			+"',\n")
//							.append("	check_date='"				+ jjjArray.get("check_date") 			+"',\n")
							.append("	approval='"					+ jjjArray.get("approval") 				+"',\n")
							.append("	approval_date='"			+ jjjArray.get("approval_date") 		+"',\n")
							.append("	member_key='"				+ jjjArray.get("member_key")			+"' \n")
							.append("WHERE																		\n")
							.append("	 vhcl_no='"					+ jjjArray.get("vhcl_no") 				+"' \n")
							.append("AND vhcl_no_rev ='" 			+ jjjArray.get("vhcl_no_rev") 			+"' \n")
							.append("AND service_date='"			+ jjjArray.get("service_date")	 		+"' \n")
							.append("AND check_gubun_mid='"			+ jjjArray.get("check_gubun_mid") 		+"' \n")
							.append("AND check_gubun_sm='"			+ jjjArray.get("check_gubun_sm") 		+"' \n")
							.append("AND checklist_cd='"			+ jjjArray.get("checklist_cd") 			+"' \n")
							.append("AND cheklist_cd_rev='"			+ jjjArray.get("cheklist_cd_rev") 		+"' \n")
							.append("AND checklist_seq='"			+ jjjArray.get("checklist_seq") 		+"' \n")
							.append("AND member_key='"				+ jjjArray.get("member_key") 			+"';\n")
							.toString();

					resultInt = super.excuteUpdate(con, sql.toString());
			    	if(resultInt < 0){  //
						ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
						con.rollback();
						return EventDefine.E_DOEXCUTE_ERROR ;
					}
				}
				con.commit();
			} catch(Exception e) {
				e.getStackTrace();
				LoggingWriter.setLogError("M838S060500E102()","==== SQL ERROR ===="+ e.getMessage());
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
	    		JSONArray jjArray = (JSONArray) jArray.get("param");
	    		JSONObject jjjArray0 = (JSONObject) jjArray.get(0);
	    		
	    		
	    		String sql = new StringBuilder()
						.append("DELETE FROM															\n")
						.append("	haccp_vhcl_clean_checklist											\n")
						.append("WHERE																	\n")
						.append("		vhcl_no = '" 			+ jjjArray0.get("vhcl_no") 			+"' \n")
						.append("	AND vhcl_no_rev ='" 		+ jjjArray0.get("vhcl_no_rev") 		+"' \n")
						.append("	AND service_date = '"		+ jjjArray0.get("service_date") 	+"' \n")
						.append("	AND member_key='"			+ jjjArray0.get("member_key") 		+"';\n")					
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
				LoggingWriter.setLogError("M838S060500E103()","==== SQL ERROR ===="+ e.getMessage());
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
		
		public int E104(InoutParameter ioParam){
			resultInt = EventDefine.E_DOEXCUTE_INIT;
			
			try {
				con = JDBCConnectionPool.getConnection();
				
//				// 클라이언트로 부터 받은 파라미터를 옮겨 담는다.
//				String rcvData = (String)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
				JSONObject jArray = new JSONObject();
				jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));

				String sql = new StringBuilder()
						.append("SELECT DISTINCT\n")
						.append("	A.vhcl_no,\n")
						.append("	A.vhcl_no_rev,\n")
						.append("	V.vehicle_nm,\n")
						.append("	A.service_date,\n")
						.append("	A.driver,\n")
						.append("	A.check_person,\n")
						
						.append("	A.strange_date,\n")
						.append("	A.strange_note,\n")
						.append("	A.strange_result,\n")
						.append("	A.strange_result_date,\n")
						.append("	A.strange_result_person,\n")
						.append("	A.strange_result_check,\n")
												
						.append("	A.writor_main,\n")
						.append("	A.writor_main_rev,\n")
						.append("	A.write_date,\n")
						.append("	A.check_date,\n")
						.append("	A.approval,\n")
						.append("	A.approval_date\n")
						.append("FROM haccp_vhcl_clean_checklist A\n")
						.append("INNER JOIN tbm_vehicle V\n")
						.append("	ON A.vhcl_no = V.vehicle_cd\n")
						.append("	AND A.vhcl_no_rev = v.vehicle_rev_no\n")
						.append("WHERE service_date\n")
						.append("		BETWEEN '" + jArray.get("fromdate") + "' AND '" + jArray.get("todate") + "'\n")
						.append("	AND A.member_key = '" + jArray.get("member_key") + "'\n")
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
				LoggingWriter.setLogError("M838S060500E104()","==== SQL ERROR ===="+ e.getMessage());
				return EventDefine.E_DOEXCUTE_ERROR ;
		    } finally {
		    	if (Config.useDataSource) {
					try {
						if (con != null) con.close();
					} catch (Exception e) {
						LoggingWriter.setLogError("M838S060500E104()","==== finally ===="+ e.getMessage());
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
				System.out.println("JSONObject jArray rcvData="+ jArray.toString());	
				
				String sql = new StringBuilder()
						.append("SELECT\n")
						.append("	check_gubun,\n")
						.append("	check_gubun_mid,\n")
						.append("	M.code_name,\n")
						.append("	check_gubun_sm,\n")
						.append("	S.code_name,\n")
						.append("	checklist_cd,\n")
						.append("	cheklist_cd_rev,\n")
						.append("	checklist_seq,\n")
						.append("	item_cd,\n")
						.append("	item_seq,\n")
						.append("	item_cd_rev,\n")
						.append("	standard_guide,\n")
						.append("	standard_value,\n")
						.append("	check_note,\n")
						.append("	check_value\n")
						.append("FROM haccp_vhcl_clean_checklist A\n")
						.append("LEFT OUTER JOIN v_checklist_gubun_mid M\n")
						.append("	ON A.check_gubun = M.code_cd\n")
						.append("	AND A.check_gubun_mid = M.code_value\n")
						.append("	AND A.member_key = M.member_key\n")
						.append("LEFT OUTER JOIN v_checklist_gubun_sm S\n")
						.append("	ON A.check_gubun = S.code_cd_big\n")
						.append("	AND A.check_gubun_mid = S.code_cd\n")
						.append("	AND A.check_gubun_sm = S.code_value\n")
						.append("	AND A.member_key = S.member_key\n")
						.append("WHERE vhcl_no ='" + jArray.get("vhcl_no") + "'\n")
						.append("	AND vhcl_no_rev = '" + jArray.get("vhcl_no_rev") + "'\n")
						.append("	AND service_date = '" + jArray.get("service_date") + "'\n")
						.append("	AND A.member_key = '" + jArray.get("member_key") + "'\n")
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
				LoggingWriter.setLogError("M838S060500E114()","==== SQL ERROR ===="+ e.getMessage());
				return EventDefine.E_DOEXCUTE_ERROR ;
		    } finally {
		    	if (Config.useDataSource) {
					try {
						if (con != null) con.close();
					} catch (Exception e) {
						LoggingWriter.setLogError("M838S060500E114()","==== finally ===="+ e.getMessage());
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
				System.out.println("JSONObject jArray rcvData="+ jArray.toString());	
				
				String sql = new StringBuilder()
						.append("SELECT\n")
						.append("	transport_no,\n")
						.append("	baecha_no,\n")
						.append("	baecha_seq,\n")
						.append("	transport_start_dt,\n")
						.append("	transport_end_dt,\n")
						.append("	A.vehicle_cd,\n")
						.append("	A.vehicle_cd_rev,\n")
						.append("	A.vehicle_nm,\n")
						.append("	driver,\n")
						.append("	A.order_no,\n")
						.append("	A.lotno,\n")
						.append("	B.product_nm || '('||D.code_name  ||','||  E.code_name ||')',\n")
						.append("	C.cust_nm,\n")
						.append("	C.address\n")
						.append("FROM tbi_vehicle_transport A\n")
						.append("INNER JOIN tbi_order O\n")
						.append("	ON A.order_no = O.order_no\n")
						.append("	AND A.lotno = O.lotno\n")
						.append("	AND A.order_detail_seq = O.order_detail_seq\n")
						.append("	AND A.member_key = O.member_key\n")
						.append("INNER JOIN tbm_product B\n")
						.append("	ON O.prod_cd = B.prod_cd\n")
						.append("	AND O.prod_rev = B.revision_no\n")
						.append("	AND O.member_key = B.member_key\n")
						.append("INNER JOIN v_prodgubun_big D\n")
						.append("	ON B.prod_gubun_b = D.code_value\n")
						.append("	AND B.member_key = D.member_key\n")
						.append("INNER JOIN v_prodgubun_mid E\n")
						.append("	ON B.prod_gubun_m = E.code_value\n")
						.append("	AND B.member_key = E.member_key\n")
						.append("INNER JOIN tbm_customer C\n")
						.append("	ON O.cust_cd = C.cust_cd\n")
						.append("	AND O.cust_rev = C.revision_no\n")
						.append("	AND O.member_key = C.member_key\n")
						.append("WHERE A.vehicle_cd = '" + jArray.get("vehicle_cd") + "'\n")
						.append("	AND A.vehicle_cd_rev = '" + jArray.get("vehicle_cd_rev") + "'\n")
						.append("	AND TO_CHAR(TO_DATETIME(A.transport_start_dt),'YYYY-MM-DD') = '" + jArray.get("transport_start_dt") + "'\n")
						.append("	AND A.member_key ='" + jArray.get("member_key") + "'\n")
						.append("ORDER BY A.transport_start_dt DESC\n")
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
				LoggingWriter.setLogError("M838S060500E124()","==== SQL ERROR ===="+ e.getMessage());
				return EventDefine.E_DOEXCUTE_ERROR ;
		    } finally {
		    	if (Config.useDataSource) {
					try {
						if (con != null) con.close();
					} catch (Exception e) {
						LoggingWriter.setLogError("M838S060500E124()","==== finally ===="+ e.getMessage());
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
		
		public int E134(InoutParameter ioParam){
			resultInt = EventDefine.E_DOEXCUTE_INIT;
			
			try {
				con = JDBCConnectionPool.getConnection();
				
				JSONObject jArray = new JSONObject();
				jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
				System.out.println("JSONObject jArray rcvData="+ jArray.toString());
	    		
				String sql = new StringBuilder()
						.append("select\n")
						.append("	A.check_gubun,\n")
						.append("	E.code_name,\n")
						.append("	A.checklist_cd,\n")
						.append("	A.revision_no,\n")
						.append("	A.checklist_seq,\n")
						.append("	A.check_note,\n")
						.append("	A.standard_guide,\n")
						.append("	A.standard_value,\n")
						.append("	A.double_check_yn,\n")
						.append("	A.item_cd,\n")
						.append("	A.item_seq,\n")
						.append("	A.item_cd_rev,\n")
						.append("	B.item_type,\n")
						.append("	B.item_bigo,\n")
						.append("	B.item_desc,\n")
						.append("	A.start_date,\n")
						.append("	A.duration_date,\n")
						.append("	A.check_gubun_mid,\n")
						.append("	F.code_name,\n")
						.append("	A.check_gubun_sm,\n")
						.append("	G.code_name\n")
						.append("FROM tbm_checklist A\n")
						.append("INNER JOIN tbm_check_item B\n")
						.append("	ON A.item_cd = B.item_cd\n")
						.append("	AND A.item_seq = B.item_seq\n")
						.append("	AND A.item_cd_rev = B.revision_no\n")
						.append("	AND A.member_key = B.member_key\n")
						.append("INNER JOIN v_checklist_gubun E\n")
						.append("	ON A.check_gubun = E.code_value\n")
						.append("	AND A.member_key = E.member_key\n")
						.append("LEFT OUTER JOIN v_checklist_gubun_mid F\n")
//									.append("INNER JOIN v_checklist_gubun_mid F\n")
						.append("	ON A.check_gubun = F.code_cd\n")
						.append("	AND A.check_gubun_mid = F.code_value\n")
						.append("	AND A.member_key = F.member_key\n")
						.append("LEFT OUTER JOIN v_checklist_gubun_sm G\n")
//									.append("INNER JOIN v_checklist_gubun_sm G\n")
						.append("	ON A.check_gubun = G.code_cd_big\n")
						.append("	AND A.check_gubun_mid = G.code_cd\n")
						.append("	AND A.check_gubun_sm = G.code_value\n")
						.append("	AND A.member_key = G.member_key\n")
						.append("where A.check_gubun like '" + jArray.get("check_gubun") + "%'\n")
						.append(" 	AND A.member_key = '" + jArray.get("member_key") + "' \n") //member_key_select, update, delete
						.append("ORDER BY A.checklist_cd\n") // order by 안해주면 타임아웃 됨
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
				LoggingWriter.setLogError("M838S060500E134()","==== SQL ERROR ===="+ e.getMessage());
				return EventDefine.E_DOEXCUTE_ERROR ;
		    } finally {
		    	if (Config.useDataSource) {
					try {
						if (con != null) con.close();
					} catch (Exception e) {
						LoggingWriter.setLogError("M838S060500E134()","==== finally ===="+ e.getMessage());
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
				System.out.println("JSONObject jArray rcvData="+ jArray.toString());
				
				
				String sql = new StringBuilder()
						.append("SELECT\n")
						.append("        check_gubun,\n")
						.append("        check_gubun_mid,\n")
						.append("        M.code_name,\n")
						.append("        check_gubun_sm,\n")
						.append("        S.code_name,\n")
						.append("        checklist_cd,\n")
						.append("        cheklist_cd_rev,\n")
						.append("        checklist_seq,\n")
						.append("        A.item_cd,\n")
						.append("        A.item_seq,\n")
						.append("        A.item_cd_rev,\n")
						.append("        B.item_type,\n")
						.append("        B.item_bigo,\n")
						.append("        B.item_desc,\n")
						.append("        standard_guide,\n")
						.append("        standard_value,\n")
						.append("        check_note,\n")
						.append("        check_value,\n")
						
						.append("        vhcl_no,\n")
						.append("        vhcl_no_rev,\n")
						.append("        service_date,\n")
						.append("        driver,\n")
						
						.append("        strange_date,\n")
						.append("        strange_note,\n")
						.append("        strange_result,\n")
						.append("        strange_result_date,\n")
						.append("        strange_result_person,\n")
						.append("        strange_result_check,\n")
						.append("        check_person\n")
						.append("FROM haccp_vhcl_clean_checklist A\n")
						.append("INNER JOIN tbm_check_item B\n")
						.append("        ON A.item_cd = B.item_cd\n")
						.append("        AND A.item_seq = B.item_seq\n")
						.append("        AND A.item_cd_rev = B.revision_no\n")
						.append("        AND A.member_key = B.member_key\n")
						.append("LEFT OUTER JOIN v_checklist_gubun_mid M\n")
						.append("        ON A.check_gubun = M.code_cd\n")
						.append("        AND A.check_gubun_mid = M.code_value\n")
						.append("        AND A.member_key = M.member_key\n")
						.append("LEFT OUTER JOIN v_checklist_gubun_sm S\n")
						.append("        ON A.check_gubun = S.code_cd_big\n")
						.append("        AND A.check_gubun_mid = S.code_cd\n")
						.append("        AND A.check_gubun_sm = S.code_value\n")
						.append("        AND A.member_key = S.member_key\n")
						.append("WHERE vhcl_no ='" + jArray.get("vhcl_no") +"'\n")
						.append("	AND vhcl_no_rev ='" + jArray.get("vhcl_no_rev") +"'\n")
						.append("        AND service_date = '" + jArray.get("service_date") + "'\n")
						.append("        AND A.member_key = '" + jArray.get("member_key") 	+ "'\n")
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
				LoggingWriter.setLogError("M838S060500E144()","==== SQL ERROR ===="+ e.getMessage());
				return EventDefine.E_DOEXCUTE_ERROR ;
		    } finally {
		    	if (Config.useDataSource) {
					try {
						if (con != null) con.close();
					} catch (Exception e) {
						LoggingWriter.setLogError("M838S060500E144()","==== finally ===="+ e.getMessage());
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

		public int E154(InoutParameter ioParam){
			resultInt = EventDefine.E_DOEXCUTE_INIT;
			
			try {
				con = JDBCConnectionPool.getConnection();
				
//				// 클라이언트로 부터 받은 파라미터를 옮겨 담는다.
//				String rcvData = (String)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
				JSONObject jArray = new JSONObject();
				jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));

				String sql = new StringBuilder()
						.append("SELECT DISTINCT											\n")
						.append("	driver													\n")
						.append("FROM														\n")
						.append("	haccp_vhcl_clean_checklist								\n")
						.append("WHERE														\n")
						.append("	vhcl_no = '" + jArray.get("vhcl_no") + "'				\n")
						.append("	AND vhcl_no_rev = '" + jArray.get("vhcl_no_rev") + "'	\n")
						.append("	AND service_date = '" + jArray.get("service_date") + "'	\n")
						.append("	AND member_key = '" + jArray.get("member_key") + "'		\n")					
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
				LoggingWriter.setLogError("M838S060500E154()","==== SQL ERROR ===="+ e.getMessage());
				return EventDefine.E_DOEXCUTE_ERROR ;
		    } finally {
		    	if (Config.useDataSource) {
					try {
						if (con != null) con.close();
					} catch (Exception e) {
						LoggingWriter.setLogError("M838S060500E154()","==== finally ===="+ e.getMessage());
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
		
		public int E164(InoutParameter ioParam){
			resultInt = EventDefine.E_DOEXCUTE_INIT;
			
			try {
				con = JDBCConnectionPool.getConnection();
				
//				// 클라이언트로 부터 받은 파라미터를 옮겨 담는다.
//				String rcvData = (String)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
				JSONObject jArray = new JSONObject();
				jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));

				String sql = new StringBuilder()
						.append("SELECT														\n")
						.append("	check_value												\n")
						.append("FROM														\n")
						.append("	haccp_vhcl_clean_checklist								\n")
						.append("WHERE														\n")
						.append("	vhcl_no = '" + jArray.get("vhcl_no") + "'				\n")
						.append("	AND vhcl_no_rev = '" + jArray.get("vhcl_no_rev") + "'	\n")
//						.append("	AND driver = '" + jArray.get("driver") + "'				\n")
						.append("	AND service_date = '" + jArray.get("service_date") + "'	\n")
						.append("	AND member_key = '" + jArray.get("member_key") + "'		\n")					
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
				LoggingWriter.setLogError("M838S060500E164()","==== SQL ERROR ===="+ e.getMessage());
				return EventDefine.E_DOEXCUTE_ERROR ;
		    } finally {
		    	if (Config.useDataSource) {
					try {
						if (con != null) con.close();
					} catch (Exception e) {
						LoggingWriter.setLogError("M838S060500E164()","==== finally ===="+ e.getMessage());
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
				
//				// 클라이언트로 부터 받은 파라미터를 옮겨 담는다.
//				String rcvData = (String)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
				JSONObject jArray = new JSONObject();
				jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));

				String sql = new StringBuilder()
						.append("SELECT													\n")
						.append("	check_note											\n")
						.append("FROM													\n")
						.append("	tbm_checklist										\n")
						.append("WHERE													\n")
						.append("	check_gubun = 'VHCCLN'								\n")
						.append("	AND member_key = '" + jArray.get("member_key") + "'	\n")
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
				LoggingWriter.setLogError("M838S060500E174()","==== SQL ERROR ===="+ e.getMessage());
				return EventDefine.E_DOEXCUTE_ERROR ;
		    } finally {
		    	if (Config.useDataSource) {
					try {
						if (con != null) con.close();
					} catch (Exception e) {
						LoggingWriter.setLogError("M838S060500E174()","==== finally ===="+ e.getMessage());
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
		
		public int E184(InoutParameter ioParam){
			resultInt = EventDefine.E_DOEXCUTE_INIT;
			
			try {
				con = JDBCConnectionPool.getConnection();
				
//				// 클라이언트로 부터 받은 파라미터를 옮겨 담는다.
//				String rcvData = (String)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
				JSONObject jArray = new JSONObject();
				jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));

				String sql = new StringBuilder()
						.append("SELECT DISTINCT																						\n")
						.append("	service_date,																						\n")
						.append("	strange_date,																						\n")
						.append("	strange_note,																						\n")
						.append("	strange_result,																						\n")
						.append("	strange_result_date,																				\n")
						.append("	strange_result_person,																				\n")
						.append("	strange_result_check																				\n")
						.append("FROM																									\n")
						.append("	haccp_vhcl_clean_checklist																			\n")
						.append("WHERE																									\n")
						.append("	vhcl_no = '" + jArray.get("vhcl_no") + "'															\n")
						.append("	AND vhcl_no_rev = '" + jArray.get("vhcl_no_rev") + "'												\n")
						.append("	AND member_key = '" + jArray.get("member_key") + "'													\n")
						.append("	AND strange_note IS NOT NULL																		\n")
						.append("	AND service_date BETWEEN '" + jArray.get("start_date") + "' AND '" + jArray.get("end_date") + "'	\n")
						.append("ORDER BY service_date ASC																				\n")
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
				LoggingWriter.setLogError("M838S060500E184()","==== SQL ERROR ===="+ e.getMessage());
				return EventDefine.E_DOEXCUTE_ERROR ;
		    } finally {
		    	if (Config.useDataSource) {
					try {
						if (con != null) con.close();
					} catch (Exception e) {
						LoggingWriter.setLogError("M838S060500E184()","==== finally ===="+ e.getMessage());
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