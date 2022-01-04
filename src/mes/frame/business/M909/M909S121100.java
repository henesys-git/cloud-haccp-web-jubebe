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


public class M909S121100 extends SqlAdapter{
	Connection con = null;
	PreparedStatement pstmt = null;
	String resultString = "";
	int resultInt = -1;
	StringBuffer sql = new StringBuffer();
	
	String[][] v_paramArray = new String[0][0]; 
	Class[] optClass = null;
	Object[] optObj = null;
	Object obj = null;
	
	public M909S121100(){
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

			Method method = M909S121100.class.getMethod(event,optClass);
			LoggingWriter.setLogDebug(M909S121100.class.getName(),"==== " + event + " EventMethod Create Success ====");

			obj = method.invoke(M909S121100.class.newInstance(),optObj);
			doExcute_result = CommonFunction.getInt(obj.toString());
			
	    } catch (Exception ex) {
	    	doExcute_result = EventDefine.E_DOEXCUTE_INIT;
			ioParam.setMessage(MessageDefine.M_NO_EVENTID);
			LoggingWriter.setLogError(M909S121100.class.getName(),"==== EventID Not define : EVENT ID [ " + ioParam.getEventID() + "]");
	    } finally {
	    	obj = null;
			optClass = null;
			optObj = null;
	    }
	    long endTime = System.currentTimeMillis();
		long runningTime = endTime - startTime;
		LoggingWriter.setLogAll(M909S121100.class.getName(),"==== Query [수행시간  : " + runningTime + " ms]");
		
		return doExcute_result;
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
    		System.out.println("데이터 묶음 개수 :::: " + jjArray.size());
    		
    		JSONObject jjjArray0 = (JSONObject)jjArray.get(0); // 0번째 데이터묶음    		


			// 먼저 이전 리비전에 대한 적용종료일자를 이번의 적용일자에서 하루를 뺀 날짜로 변경한다.
			for(int i=0; i<jjArray.size(); i++) {
				JSONObject jjjArray = (JSONObject)jjArray.get(i); // i번째 데이터묶음
				
				String sql = new StringBuilder()
					.append("MERGE INTO tbm_process_package mm\n")
					.append("USING ( 	\n")
					.append("	SELECT 	\n")
					.append("	'" + jjjArray.get("member_key") 		+ "' AS member_key, 		-- 0.member_key \n")
					.append("	'" + jjjArray.get("process_gubun") 		+ "' AS process_gubun, 		-- 1. process_gubun\n")       
					.append("	'" + jjjArray.get("process_gubun_rev") 	+ "' AS process_gubun_rev, 	-- 2. process_gubun_rev\n")   
					.append("	'" + jjjArray.get("proc_code_gb_big") 	+ "' AS proc_code_gb_big, 	-- 3. proc_code_gb_big\n")    
					.append("	'" + jjjArray.get("proc_code_gb_mid") 	+ "' AS proc_code_gb_mid, 	-- 4. proc_code_gb_mid\n")    
					.append("	'" + jjjArray.get("proc_cd") 			+ "' AS proc_cd, 			-- 5. proc_cd\n")             
					.append("	'" + jjjArray.get("proc_cd_rev") 		+ "' AS proc_cd_rev, 		-- 6. proc_cd_rev\n")         
					.append("	'" + jjjArray.get("process_nm") 		+ "' AS process_nm, 		-- 7. process_nm\n")          
					.append("	'" + jjjArray.get("process_seq") 		+ "' AS process_seq, 		-- 8. process_seq\n")         
					.append("	'" + jjjArray.get("dept_gubun") 		+ "' AS dept_gubun, 		-- 9. dept_gubun\n")          
					.append("	'" + jjjArray.get("prod_cd") 			+ "' AS prod_cd, 			-- 10. prod_cd\n")            
					.append("	'" + jjjArray.get("prod_cd_rev") 		+ "' AS prod_cd_rev, 		-- 11. prod_cd_rev\n")        
					.append("	'" + jjjArray.get("std_proc_qnt") 		+ "' AS std_proc_qnt, 		-- 12. std_proc_qnt\n")       
					.append("	'" + jjjArray.get("std_man_amt") 		+ "' AS std_man_amt, 		-- 13. std_man_amt\n")        
					.append("	'" + jjjArray.get("seolbi_cd") 			+ "' AS seolbi_cd, 			-- 14. seolbi_cd\n")          
					.append("	'" + jjjArray.get("seolbi_cd_rev") 		+ "' AS seolbi_cd_rev, 		-- 15. seolbi_cd_rev\n")      
					.append("	'" + jjjArray.get("seolbi_line") 		+ "' AS seolbi_line, 		-- 16. seolbi_line\n")        
					.append("	'" + jjjArray.get("work_order_index") 	+ "' AS work_order_index, 	-- 17. work_order_index\n")   
					.append("	'" + jjjArray.get("bigo") 				+ "' AS bigo, 				-- 18. bigo\n")               
					.append("	'" + jjjArray.get("start_date") 		+ "' AS start_date, 		-- 19. start_date\n")         
					.append("	'" + jjjArray.get("create_date") 		+ "' AS create_date, 		-- 20. create_date\n")        
					.append("	'" + jjjArray.get("create_user_id") 	+ "' AS create_user_id, 	-- 21. create_user_id\n")     
					.append("	'" + jjjArray.get("modify_date") 		+ "' AS modify_date, 		-- 22. modify_date\n")        
					.append("	'" + jjjArray.get("modify_user_id") 	+ "' AS modify_user_id, 	-- 23. modify_user_id\n")     
					.append("	'" + jjjArray.get("duration_date") 		+ "' AS duration_date, 		-- 24. duration_date\n")      
					.append("	'" + jjjArray.get("modify_reason") 		+ "' AS modify_reason, 		-- 25. modify_reason\n")      
					.append("	'" + jjjArray.get("check_data_type") 	+ "' AS check_data_type, 	-- 26. check_data_type\n")    
					.append("	'" + jjjArray.get("delyn") 				+ "' AS delyn, 				-- 27. delyn\n")              
					.append("	'" + jjjArray.get("product_process_yn") + "' AS product_process_yn, -- 28. product_process_yn\n") 
					.append("	'" + jjjArray.get("packing_process_yn") + "' AS packing_process_yn	-- 29. packing_process_yn\n") 
					.append("	FROM db_root ) mQ\n")
					.append("ON ( \n")
					.append("	 mm.member_key         = mQ.member_key 			\n")
					.append("AND mm.process_gubun      = mQ.process_gubun 		\n")
					.append("AND mm.process_gubun_rev  = mQ.process_gubun_rev 	\n")
					.append("AND mm.proc_code_gb_big   = mQ.proc_code_gb_big 	\n")
					.append("AND mm.proc_code_gb_mid   = mQ.proc_code_gb_mid 	\n")
					.append("AND mm.proc_cd            = mQ.proc_cd 			\n")
					.append("AND mm.proc_cd_rev        = mQ.proc_cd_rev 		\n")
//					.append("AND mm.process_nm         = mQ.process_nm 			\n")
//					.append("AND mm.process_seq        = mQ.process_seq 		\n")
//					.append("AND mm.dept_gubun         = mQ.dept_gubun 			\n")
					.append("AND mm.prod_cd            = mQ.prod_cd 			\n")
					.append("AND mm.prod_cd_rev        = mQ.prod_cd_rev 		\n")
//					.append("AND mm.std_proc_qnt       = mQ.std_proc_qnt 		\n")
//					.append("AND mm.std_man_amt        = mQ.std_man_amt 		\n")
					.append("AND mm.seolbi_cd          = mQ.seolbi_cd 			\n")
					.append("AND mm.seolbi_cd_rev      = mQ.seolbi_cd_rev 		\n")
//					.append("AND mm.seolbi_line        = mQ.seolbi_line 		\n")
					.append("AND mm.work_order_index   = mQ.work_order_index 	\n")
//					.append("AND mm.bigo               = mQ.bigo 				\n")
//					.append("AND mm.start_date         = mQ.start_date 			\n")
//					.append("AND mm.create_date        = mQ.create_date 		\n")
//					.append("AND mm.create_user_id     = mQ.create_user_id 		\n")
//					.append("AND mm.modify_date        = mQ.modify_date 		\n")
//					.append("AND mm.modify_user_id     = mQ.modify_user_id 		\n")
//					.append("AND mm.duration_date      = mQ.duration_date 		\n")
//					.append("AND mm.modify_reason      = mQ.modify_reason 		\n")
//					.append("AND mm.check_data_type    = mQ.check_data_type 	\n")
//					.append("AND mm.delyn              = mQ.delyn 				\n")
//					.append("AND mm.product_process_yn = mQ.product_process_yn 	\n")
//					.append("AND mm.packing_process_yn = mQ.packing_process_yn 	\n")
					.append(")	\n")
					// 수정시
					.append("WHEN MATCHED THEN \n")
					.append("	UPDATE SET \n")
                    .append("		mm.member_key         = mQ.member_key, 			\n")
					.append("		mm.process_gubun      = mQ.process_gubun, 		\n")
					.append("		mm.process_gubun_rev  = mQ.process_gubun_rev, 	\n")
					.append("		mm.proc_code_gb_big   = mQ.proc_code_gb_big, 	\n")
					.append("		mm.proc_code_gb_mid   = mQ.proc_code_gb_mid, 	\n")
					.append("		mm.proc_cd            = mQ.proc_cd, 			\n")
					.append("		mm.proc_cd_rev        = mQ.proc_cd_rev, 		\n")
					.append("		mm.process_nm         = mQ.process_nm, 			\n")
					.append("		mm.process_seq        = mQ.process_seq, 		\n")
					.append("		mm.dept_gubun         = mQ.dept_gubun, 			\n")
					.append("		mm.prod_cd            = mQ.prod_cd, 			\n")
					.append("		mm.prod_cd_rev        = mQ.prod_cd_rev, 		\n")
					.append("		mm.std_proc_qnt       = mQ.std_proc_qnt, 		\n")
					.append("		mm.std_man_amt        = mQ.std_man_amt, 		\n")
					.append("		mm.seolbi_cd          = mQ.seolbi_cd, 			\n")
					.append("		mm.seolbi_cd_rev      = mQ.seolbi_cd_rev, 		\n")
					.append("		mm.seolbi_line        = mQ.seolbi_line, 		\n")
					.append("		mm.work_order_index   = mQ.work_order_index, 	\n")
					.append("		mm.bigo               = mQ.bigo, 				\n")
					.append("		mm.create_user_id     = mQ.create_user_id, 		\n")
					.append("		mm.modify_date        = TO_CHAR(SYSDATE,'YYYY-MM-DD'), \n")
					.append("		mm.modify_user_id     = '"+ jjjArray.get("create_user_id") +"', 		\n")
					.append("		mm.duration_date      = mQ.duration_date, 		\n")
					.append("		mm.modify_reason      = mQ.modify_reason, 		\n")
					.append("		mm.check_data_type    = mQ.check_data_type, 	\n")
					.append("		mm.delyn              = mQ.delyn, 				\n")
					.append("		mm.product_process_yn = mQ.product_process_yn, 	\n")
					.append("		mm.packing_process_yn = mQ.packing_process_yn 	\n")
					// 입력시
					.append("WHEN NOT MATCHED THEN\n")
					.append("	INSERT ( 					\n")
					.append("		mm.member_key,         	\n")
					.append("		mm.process_gubun,      	\n")
					.append("		mm.process_gubun_rev,  	\n")
					.append("		mm.proc_code_gb_big,   	\n")
					.append("		mm.proc_code_gb_mid,   	\n")
					.append("		mm.proc_cd,            	\n")
					.append("		mm.proc_cd_rev,        	\n")
					.append("		mm.process_nm,         	\n")
					.append("		mm.process_seq,        	\n")
					.append("		mm.dept_gubun,         	\n")
					.append("		mm.prod_cd,            	\n")
					.append("		mm.prod_cd_rev,        	\n")
					.append("		mm.std_proc_qnt,       	\n")
					.append("		mm.std_man_amt,        	\n")
					.append("		mm.seolbi_cd,          	\n")
					.append("		mm.seolbi_cd_rev,      	\n")
					.append("		mm.seolbi_line,        	\n")
					.append("		mm.work_order_index,   	\n")
					.append("		mm.bigo,               	\n")
					.append("		mm.start_date,         	\n")
					.append("		mm.create_date,        	\n")
					.append("		mm.create_user_id,     	\n")
					.append("		mm.modify_date,        	\n")
					.append("		mm.modify_user_id,     	\n")
					.append("		mm.duration_date, 		\n")
					.append("		mm.modify_reason, 		\n")					
					.append("		mm.check_data_type, 	\n")
					.append("		mm.delyn, 				\n")
					.append("		mm.product_process_yn, 	\n")
					.append("		mm.packing_process_yn 	\n")
					.append("	) VALUES ( 					\n")
					.append("		mQ.member_key,         	\n")
					.append("		mQ.process_gubun,      	\n")
					.append("		mQ.process_gubun_rev,  	\n")
					.append("		mQ.proc_code_gb_big,   	\n")
					.append("		mQ.proc_code_gb_mid,   	\n")
					.append("		mQ.proc_cd,            	\n")
					.append("		mQ.proc_cd_rev,        	\n")
					.append("		mQ.process_nm,         	\n")
					.append("		mQ.process_seq,        	\n")
					.append("		mQ.dept_gubun,         	\n")
					.append("		mQ.prod_cd,            	\n")
					.append("		mQ.prod_cd_rev,        	\n")
					.append("		mQ.std_proc_qnt,       	\n")
					.append("		mQ.std_man_amt,        	\n")
					.append("		mQ.seolbi_cd,          	\n")
					.append("		mQ.seolbi_cd_rev,      	\n")
					.append("		mQ.seolbi_line,        	\n")
					.append("		mQ.work_order_index,   	\n")
					.append("		mQ.bigo,               	\n")
					.append("		TO_CHAR(SYSDATE,'YYYY-MM-DD'), \n")
					.append("		TO_CHAR(SYSDATE,'YYYY-MM-DD'), \n")
					.append("		mQ.create_user_id,     	\n")
					.append("		null,  			      	\n")
					.append("		null,     				\n")					
					.append("		'9999-12-31', 			\n")
					.append("		'최초작성',     			\n")
					.append("		mQ.check_data_type, 	\n")
					.append("		mQ.delyn, 				\n")
					.append("		mQ.product_process_yn, 	\n")
					.append("		mQ.packing_process_yn 	\n")
					.append("	); \n")	
					.toString();			
				//System.out.println(sql.toString());			
				resultInt = super.excuteUpdate(con, sql.toString());
				if (resultInt < 0) {
					con.rollback();
					ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
				} else {
					
					ioParam.setMessage(resultInt + "건 " + MessageDefine.M_INSERT_RESULT);
				}
			}	
			
			con.commit();
		} catch(Exception e) {
			LoggingWriter.setLogError("M909S121100E102()","==== SQL ERROR ===="+ e.getMessage() + "\n" + sql.toString());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M909S121100E102()","==== finally ===="+ e.getMessage());
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

			con.setAutoCommit(false);

			String sql = new StringBuilder()
					.append("DELETE FROM tbm_process_package A \n")				
					.append("WHERE prod_cd = '" + jArray.get("prod_cd") + "'	\n")
					.append("AND prod_cd_rev = '" + jArray.get("prod_cd_rev") + "'	\n")
					.append("AND A.member_key = '" 	+ jArray.get("member_key") + "' \n")
					.toString();
				resultInt = super.excuteUpdate(con, sql.toString());
				if (resultInt < 0) {
					con.rollback();
					ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
				} else {
					con.commit();
					ioParam.setMessage(resultInt + "건 " + MessageDefine.M_INSERT_RESULT);
				}
				
		} catch(Exception e) {
			LoggingWriter.setLogError("M909S121100E103()","==== SQL ERROR ===="+ e.getMessage() + "\n" + sql.toString());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M909S121100E103()","==== finally ===="+ e.getMessage());
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

	// 공정없는 REV 전체보기
	public int E104(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			System.out.println("JSONObject jArray rcvData="+ jArray.toString());
			
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
				.append("FROM tbm_product	A	\n")
				.append("WHERE prod_cd like '%%'	\n")
				.append("AND A.member_key = '" + jArray.get("member_key") + "' \n") //member_key_select, update, delete
				.append("GROUP BY A.prod_cd, A.revision_no	\n")
				.append("ORDER BY prod_cd	ASC, revision_no DESC	\n")
				.toString();


			resultString = super.excuteQueryString(con, sql.toString());
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M909S121100E104()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M909S121100E104()","==== finally ===="+ e.getMessage());
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
	
	// 공정없는 REV 일부보기 
	public int E105(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			System.out.println("JSONObject jArray rcvData="+ jArray.toString());
			
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
				.append("FROM tbm_product A		\n")
				.append("WHERE prod_cd like '%%'	\n")
				.append("AND TO_CHAR(SYSDATE,'YYYY-MM-DD') BETWEEN  start_date AND duration_date\n")
				.append("AND A.member_key = '" + jArray.get("member_key") + "' \n") //member_key_select, update, delete
				.append("GROUP BY A.prod_cd	\n")
				.append("ORDER BY prod_cd	ASC, revision_no DESC	\n")
				.toString();

			resultString = super.excuteQueryString(con, sql.toString());
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M909S121100E105()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M909S121100E105()","==== finally ===="+ e.getMessage());
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

	// 공정 있는 REV 전체보기
	public int E106(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			System.out.println("JSONObject jArray rcvData="+ jArray.toString());
			
			String sql = new StringBuilder()
				.append("SELECT\n")
				.append("	A.prod_cd,			\n")
				.append("	A.revision_no,		\n")
				.append("	A.product_nm,		\n")
				.append("	A.gugyuk,			\n")
				.append("	A.option_cd,		\n")
				.append("	A.start_date,		\n")
				.append("	A.duration_date,	\n")
				.append("	A.create_user_id,	\n")
				.append("	A.create_date,		\n")
				.append("	A.modify_user_id,	\n")
				.append("	A.modify_reason,	\n")
				.append("	A.modify_date		\n")
				.append("FROM tbm_product A	\n")
				.append("JOIN tbm_process_package B ON (B.prod_cd = A.prod_cd)\n")
				.append("WHERE A.prod_cd like '%%'	\n")
				.append("AND A.member_key = '" + jArray.get("member_key") + "' \n")
				.append("GROUP BY A.prod_cd, A.revision_no	\n")
				.append("ORDER BY A.prod_cd	ASC, A.revision_no DESC	\n")				
				.toString();
			resultString = super.excuteQueryString(con, sql.toString());
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M909S121100E106()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M909S121100E106()","==== finally ===="+ e.getMessage());
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
	
	// 공정 있는 REV 일부보기
	public int E107(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			System.out.println("JSONObject jArray rcvData="+ jArray.toString());
			
			String sql = new StringBuilder()
				.append("SELECT\n")
				.append("	A.prod_cd,			\n")
				.append("	A.revision_no,		\n")
				.append("	A.product_nm,		\n")
				.append("	A.gugyuk,			\n")
				.append("	A.option_cd,		\n")
				.append("	A.start_date,		\n")
				.append("	A.duration_date,	\n")
				.append("	A.create_user_id,	\n")
				.append("	A.create_date,		\n")
				.append("	A.modify_user_id,	\n")
				.append("	A.modify_reason,	\n")
				.append("	A.modify_date		\n")
				.append("FROM tbm_product A		\n")
				.append("JOIN tbm_process_package B ON (B.prod_cd = A.prod_cd)\n")
				.append("WHERE A.prod_cd like '%%'	\n")
				.append("AND TO_CHAR(SYSDATE,'YYYY-MM-DD') BETWEEN A.start_date AND A.duration_date\n")
				.append("AND A.member_key = '" + jArray.get("member_key") + "' \n")
				.append("GROUP BY A.prod_cd	\n")
				.append("ORDER BY A.prod_cd	ASC, A.revision_no DESC	\n")
				.toString();

			resultString = super.excuteQueryString(con, sql.toString());
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M909S121100E107()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M909S121100E107()","==== finally ===="+ e.getMessage());
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
	
	
	// 이력조건에 해당하는 거래처 목록을 GROUP BY 검색한다. 
	public int E114(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			System.out.println("JSONObject jArray rcvData="+ jArray.toString());
			
			String sql = new StringBuilder()
					.append("SELECT	\n")
//					.append("	member_key,\n")
//					.append("	process_gubun,\n")
//					.append("	process_gubun_rev,\n")
//					.append("	proc_code_gb_big,\n")
//					.append("	proc_code_gb_mid,\n")
					.append("	proc_cd,		-- 공정코드	\n")
					.append("	proc_cd_rev,	-- 공정 rev	\n")
					.append("	process_nm,		-- 공정명		\n")
					.append("	process_seq,	-- 공정 seq 	\n")
					.append("	dept_gubun,		-- 부서구분	\n")
//					.append("	prod_cd,		-- 제품코드	\n")
//					.append("	prod_cd_rev,	-- 제품rev	\n")
					.append("	std_proc_qnt,	-- 표준공수	\n")
					.append("	std_man_amt,	-- 필요인원수	\n")
					.append("	seolbi_cd,		-- 설비코드	\n")
					.append("	seolbi_cd_rev,	-- 설비 rev	\n")
					.append("	seolbi_line,	-- 설비라인	\n")
//					.append("	work_order_index,			\n") 
					.append("	bigo,			-- 비고		\n")
 					.append("	start_date,		-- 시작일		\n")
					.append("	create_date,	-- 생성일		\n")
					.append("	create_user_id,	-- 생성자		\n")
					.append("	modify_date,	-- 수정일자	\n")
					.append("	modify_user_id,	-- 수정자 		\n")
					.append("	duration_date,	-- 지속기간	\n")
					.append("	modify_reason,	-- 수정사유	\n")
					.append("	check_data_type, 			\n")
					.append("	delyn,			-- 삭제여부	\n")
					.append("	product_process_yn,	-- 생산공정 여부 \n")
					.append("	packing_process_yn	-- 종합공정 여부 \n")
					.append("FROM tbm_process_package A		\n")
					.append("WHERE A.prod_cd 	 = '" + jArray.get("prod_cd")	  + "' \n")
					.append("AND A.prod_cd_rev	 = '" + jArray.get("prod_cd_rev") + "' \n")
					.append("AND A.member_key 	 = '" + jArray.get("member_key")   + "' \n") //member_key_select, update, delete					
					.append("ORDER BY A.process_seq ASC, A.start_date ASC, A.create_date ASC \n")
					.toString();

			resultString = super.excuteQueryString(con, sql.toString());
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M909S121100E114()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M909S121100E114()","==== finally ===="+ e.getMessage());
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
					.append("SELECT DISTINCT \n")
					.append("	member_key,			\n")
					.append("	process_gubun,		\n")
					.append("	process_gubun_rev,	\n")
					.append("	proc_code_gb_big,	\n")
					.append("	proc_code_gb_mid,	\n")
					.append("	proc_cd,			\n")
					.append("	proc_cd_rev,		\n")
					.append("	process_nm,			\n")
					.append("	process_seq,		\n")
					.append("	dept_gubun,			\n")
					.append("	prod_cd,			\n")
					.append("	prod_cd_rev,		\n")
					.append("	std_proc_qnt,		\n")
					.append("	std_man_amt,		\n")
					.append("	seolbi_cd,			\n")
					.append("	seolbi_cd_rev,		\n")
					.append("	seolbi_line,		\n")
					.append("	work_order_index,	\n")
					.append("	bigo,				\n")
					.append("	start_date,			\n")
					.append("	create_date,		\n")
					.append("	create_user_id,		\n")
					.append("	modify_date,		\n")
					.append("	modify_user_id,		\n")
					.append("	duration_date,		\n")
					.append("	modify_reason,		\n")
					.append("	check_data_type,	\n")
					.append("	delyn,				\n")
					.append("	product_process_yn,	\n")
					.append("	packing_process_yn	\n")
					.append("FROM tbm_process_package A	\n")
					.append("WHERE A.prod_cd = '" 	+ jArray.get("prod_cd") + "' \n")
					.append("AND A.prod_cd_rev = '" + jArray.get("prod_cd_rev") + "' \n")
					.append("AND A.member_key = '" 	+ jArray.get("member_key") + "' \n")
					.append("ORDER BY A.process_seq ASC, A.start_date ASC, A.create_date ASC \n")
					.toString();

			resultString = super.excuteQueryString(con, sql.toString());
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M909S121100E124()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M909S121100E124()","==== finally ===="+ e.getMessage());
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