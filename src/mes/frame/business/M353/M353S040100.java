package mes.frame.business.M353;

import java.lang.reflect.Method;
import java.sql.Connection;
import java.sql.PreparedStatement;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;

import mes.client.conf.Config;
import mes.frame.common.ApprovalActionNo;
import mes.frame.common.EventDefine;
import mes.frame.common.HashObject;
import mes.frame.common.MessageDefine;
import mes.frame.database.JDBCConnectionPool;
import mes.frame.database.SqlAdapter;
import mes.frame.serviceinterface.InoutParameter;
import mes.frame.serviceinterface.LoggingWriter;
import mes.frame.util.CommonFunction;


public class M353S040100 extends SqlAdapter{
	Connection con = null;
	PreparedStatement pstmt = null;
	String resultString = "";
	int resultInt = -1;
	StringBuffer sql = new StringBuffer();
	
	String[][] v_paramArray = new String[0][0]; 
	Class[] optClass = null;
	Object[] optObj = null;
	Object obj = null;
	
	public M353S040100(){
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
			
			Method method = M353S040100.class.getMethod(event,optClass);
			LoggingWriter.setLogDebug(M353S040100.class.getName(),"==== " + event + " EventMethod Create Success ====");

			obj = method.invoke(M353S040100.class.newInstance(),optObj);
			doExcute_result = CommonFunction.getInt(obj.toString());
			
	    } catch (Exception ex) {
	    	doExcute_result = EventDefine.E_DOEXCUTE_INIT;
			ioParam.setMessage(MessageDefine.M_NO_EVENTID);
			LoggingWriter.setLogError(M353S040100.class.getName(),"==== EventID Not define : EVENT ID [ " + ioParam.getEventID() + "]");
	    } finally {
	    	obj = null;
			optClass = null;
			optObj = null;
	    }
	    long endTime = System.currentTimeMillis();
		long runningTime = endTime - startTime;
		LoggingWriter.setLogAll(M353S040100.class.getName(),"==== Query [수행시간  : " + runningTime + " ms]");
		
		return doExcute_result;
	}
	//계측기 등록처리부분
	public int E101(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject(); // JSONObject 선언
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			
			
			sql = new StringBuffer();
			sql.append(" INSERT INTO tbi_seolbi_repare ( \n");
			sql.append(" 		seolbi_cd,	\n"); 
			sql.append(" 		seq_no,		\n"); 
			sql.append(" 		reason_cd,	\n"); 
			sql.append(" 		start_dt,	\n"); 
			sql.append(" 		end_dt,		\n"); 
			sql.append(" 		user_id,	\n"); 
			sql.append(" 		biyong,		\n"); 
			sql.append(" 		gigwan_nm,	\n"); 
			sql.append(" 		work_memo,	\n"); 
			sql.append(" 		bigo,		\n");
			sql.append(" 		member_key	\n");
			sql.append(" 	) VALUES ( 		\n");
			sql.append(" 		'" + jArray.get("seolbi_code") + "', \n"); 	//seolbi_cd
			sql.append(" 		(SELECT coalesce(MAX(seq_no),0)+1 "
							+ 	"FROM tbi_seolbi_repare "
							+ "	 WHERE seolbi_cd='" + jArray.get("seolbi_code") + "'), \n"); 	//sys_bom_id
			sql.append(" 		'" + jArray.get("job_gubun") + "', 	\n"); 	//reason_cd
			sql.append(" 		'" + jArray.get("start_date") + "', \n"); 	//start_dt
			sql.append(" 		'" + jArray.get("end_date") + "',	\n"); 	//end_dt
			sql.append(" 		'" + jArray.get("damdangja") + "', 	\n"); 	//user_id
			sql.append(" 		'" + jArray.get("biyong") + "', 	\n"); 	//biyong
			sql.append(" 		'" + jArray.get("gigwan_name") + "',\n"); 	//gigwan_nm
			sql.append(" 		'" + jArray.get("work_memo") + "', 	\n"); 	//work_memo
			sql.append(" 		'" + jArray.get("bigo") + "',		\n"); 	//bigo
			sql.append(" 		'" + jArray.get("member_key") + "'	\n"); 	//member_key
			sql.append(" 	) 										\n");

			// super의 excuteUpdate는 3가지가 있다.
			// 첫째는 super.excuteUpdate(con, sql.toString(), v_paramArray)형태 이며,
			// PreparedStatement를 사용하기 위해 파라미터들을 배령에 담아 보낸면 체크를 해서 수행하는 구조이다. 그리고
			// 두번째는 super.excuteUpdate(con, Vector)인데, 멀티 로우를 등록하기 위해 마련된 장치이다.
			// 세번째는 하나의 SQL을 String으로 받아서 처리하는 경우이다.
			// 현재 위의 SQL형태라면.. 당연히 1개의 로우에 해당되므로 세번째 메쏘드를 사용하는 것이 편하다.
			
			resultInt = super.excuteUpdate(con, sql.toString());
			if (resultInt < 0) {
				ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
			} else {
				ioParam.setMessage(resultInt + "건 " + MessageDefine.M_INSERT_RESULT);
			}
		} catch(Exception e) {
			LoggingWriter.setLogError("M353S040100E101()","==== SQL ERROR ===="+ e.getMessage() + "\n" + sql.toString());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M353S040100E101()","==== finally ===="+ e.getMessage());
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
			
			JSONObject jArray = new JSONObject(); // JSONObject 선언
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));

			sql = new StringBuffer();
			sql.append(" UPDATE tbi_seolbi_repare set 						\n");
			sql.append(" 	reason_cd, = 	'" + jArray.get("job_gubun") + "'	\n"); 
			sql.append(" 	start_dt, = 	'" + jArray.get("start_date") + "'	\n"); 
			sql.append(" 	end_dt, = 		'" + jArray.get("end_date") + "'	\n"); 
			sql.append(" 	user_id, = 		'" + jArray.get("damdangja") + "'	\n"); 
			sql.append(" 	biyong, = 		'" + jArray.get("biyong") + "'		\n"); 
			sql.append(" 	gigwan_nm, = 	'" + jArray.get("gigwan_name") + "'	\n"); 
			sql.append(" 	work_memo, = 	'" + jArray.get("work_memo") + "'	\n"); 
			sql.append(" 	bigo = 		'" + jArray.get("bigo") + "'		\n"); 
			sql.append(" 	,member_key = 	'" + jArray.get("member_key") + "'		\n");  // member_key_update
			sql.append(" WHERE seolbi_cd = 	'" + jArray.get("seolbi_code") + "' \n");
			sql.append(" 	AND seq_no = '"    + jArray.get("seq_no") + "' 		\n");
			sql.append(" 	AND member_key = '"    + jArray.get("member_key") + "' 		\n");

			// super의 excuteUpdate는 3가지가 있다.
			// 첫째는 super.excuteUpdate(con, sql.toString(), v_paramArray)형태 이며,
			// PreparedStatement를 사용하기 위해 파라미터들을 배열에 담아 보내면 체크를 해서 수행하는 구조이다. 그리고
			// 두번째는 super.excuteUpdate(con, Vector)인데, 멀티 로우를 등록하기 위해 마련된 장치이다.
			// 세번째는 하나의 SQL을 String으로 받아서 처리하는 경우이다.
			// 현재 위의 SQL형태라면.. 당연히 1개의 로우에 해당되므로 세번째 메쏘드를 사용하는 것이 편하다.
			resultInt = super.excuteUpdate(con, sql.toString());
			if (resultInt < 0) {
				ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
				return resultInt;
			} else {
				ioParam.setMessage(resultInt + "건 " + MessageDefine.M_INSERT_RESULT);
			}
		} catch(Exception e) {
			LoggingWriter.setLogError("M353S040100E102()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M353S040100E102()","==== finally ===="+ e.getMessage());
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

	public int E103(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject(); // JSONObject 선언
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));

			sql = new StringBuffer();
			sql.append(" DELETE FROM tbi_seolbi_repare \n");
			sql.append(" WHERE seolbi_cd = '" 	+ jArray.get("seolbi_code") + "' 	\n");
			sql.append(" AND seq_no = '" 		+ jArray.get("seq_no") + "' \n");
			sql.append(" AND member_key = '" 	+ jArray.get("member_key") + "' \n");

			// super의 excuteUpdate는 3가지가 있다.
			// 첫째는 super.excuteUpdate(con, sql.toString(), v_paramArray)형태 이며,
			// PreparedStatement를 사용하기 위해 파라미터들을 배열에 담아 보내면 체크를 해서 수행하는 구조이다. 그리고
			// 두번째는 super.excuteUpdate(con, Vector)인데, 멀티 로우를 등록하기 위해 마련된 장치이다.
			// 세번째는 하나의 SQL을 String으로 받아서 처리하는 경우이다.
			// 현재 위의 SQL형태라면.. 당연히 1개의 로우에 해당되므로 세번째 메쏘드를 사용하는 것이 편하다.
			resultInt = super.excuteUpdate(con, sql.toString());
			if (resultInt < 0) {
				ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
				return resultInt;
			} else {
				ioParam.setMessage(resultInt + "건 " + MessageDefine.M_INSERT_RESULT);
			}
		} catch(Exception e) {
			LoggingWriter.setLogError("M353S040100E103()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M353S040100E103()","==== finally ===="+ e.getMessage());
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

	public int E104(InoutParameter ioParam) {
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			System.out.println("JSONObject jArray rcvData="+ jArray.toString());
			String sql = new StringBuilder()
					.append("SELECT\n")
					.append("   A.member_key,\n")
					.append("   A.order_no,\n")
					.append("   A.lotno,\n")
					.append("   B.cust_cd,\n")
					.append("   B.cust_rev,\n")
					.append("   D.cust_nm,\n")
					.append("   B.prod_cd,\n")
					.append("   B.prod_rev,\n")
					.append("   C.product_nm || '(' ||E.code_name  || ',' || F.code_name || ')',	\n")
					.append("   A.revision_no,\n")
					.append("   A.bom_cd,\n")
					.append("   A.bom_cd_rev,\n")
					.append("   A.bom_name,\n")
					.append("   A.last_no,\n")
					.append("   A.sys_bom_id\n")
					.append("FROM\n")
					.append("   tbi_order_bomlist A \n")
					.append("INNER JOIN tbi_order B \n")
					.append("   ON A.member_key = B.member_key\n")
					.append("   AND A.order_no = B.order_no\n")
					.append("   AND A.lotno = B.lotno\n")
					.append("INNER JOIN tbm_product C \n")
					.append("   ON B.prod_cd = C.prod_cd\n")
					.append("   AND B.prod_rev= C.revision_no\n")
					.append("   AND B.member_key= C.member_key\n")
					.append("INNER JOIN tbm_customer D \n")
					.append("   ON B.cust_cd = D.cust_cd\n")
					.append("   AND B.cust_rev= D.revision_no\n")
					.append("   AND B.member_key= D.member_key\n")					
					.append("INNER JOIN v_prodgubun_big E	 		\n")
					.append("   ON C.prod_gubun_b 	= E.code_value 	\n")
					.append("  AND C.member_key 	= E.member_key	\n")
					.append("INNER JOIN v_prodgubun_mid F	 		\n")
					.append("   ON C.prod_gubun_m	= F.code_value	\n")
					.append("  AND C.member_key 	= F.member_key	\n")					
					.append("WHERE\n")
					.append("   sys_bom_id = last_no AND A.member_key='"+jArray.get("member_key")+"' \n")					
					.append("ORDER BY A.order_no\n")
					.toString();



			resultString = super.excuteQueryString(con, sql.toString());
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M353S040100E104()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M353S040100E104()","==== finally ===="+ e.getMessage());
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
	public int E105(InoutParameter ioParam) {
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			System.out.println("JSONObject jArray rcvData="+ jArray.toString());
			String sql = new StringBuilder()
					.append("SELECT\n")
					.append("order_no,\n")
					.append("        lotno,\n")
					.append("        A.revision_no,\n")
					.append("        bom_cd,\n")
					.append("        bom_cd_rev,\n")
					.append("        last_no,\n")
					.append("        sys_bom_id,\n")
					.append("        type_no,\n")
					.append("        geukyongpoommok,\n")
					.append("        dept_code,\n")
					.append("        approval_date,\n")
					.append("        approval,\n")
					.append("        A.part_cd,\n")
					.append("        A.part_cd_rev,\n")
					.append("        bom_name,\n")
					.append("        B.part_nm,\n")
					.append("        part_cnt,\n")
					.append("        mesu,\n")
					.append("        gubun,\n")
					.append("        qar,\n")
					.append("        inspect_selbi,\n")
					.append("        packing_jaryo,\n")
					.append("        modify_note,\n")
					.append("        cust_code,\n")
					.append("        cust_rev,\n")
					.append("        bigo,\n")
					.append("        A.create_user_id,\n")
					.append("        A.create_date,\n")
					.append("        A.modify_user_id,\n")
					.append("        A.modify_date,\n")
					.append("        A.modify_reason,\n")
					.append("        review_no,\n")
					.append("        confirm_no,\n")
					.append("        order_detail_seq,\n")
					.append("        A.member_key\n")
					.append("FROM tbi_order_bomlist A\n")
					.append("INNER JOIN tbm_part_list B\n")
					.append("       ON A.part_cd = B.part_cd\n")
					.append("    	AND A.part_cd_rev = B.revision_no\n")
					.append("    	AND A.member_key = B.member_key\n")
					.append("WHERE order_no='"+jArray.get("order_no") +"'\n")
					.append("	AND lotno = '"+jArray.get("lotno")+"'\n")
					.append("	AND bom_cd = '"+jArray.get("bom_cd")+"'\n")
					.append("	AND bom_cd_rev = '"+jArray.get("bom_cd_rev")+"'\n")
					.append("	AND A.member_key = '"+jArray.get("member_key")+"';\n")
//					.append("WHERE\n")
//					.append("         lotno = (SELECT MAX(lotno) FROM  tbi_order_bomlist WHERE  order_no='"+jArray.get("order_no")+"')\n")
					.toString();

			resultString = super.excuteQueryString(con, sql.toString());
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M353S040100E105()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
		} finally {
			if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M353S040100E105()","==== finally ===="+ e.getMessage());
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

		String sql ="";
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		ApprovalActionNo ActionNo;
		String gOrderNo="";
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
			
			for(int i=0; i<jjArray.size(); i++) {
				JSONObject jjjArray = (JSONObject)jjArray.get(i); // i번째 데이터묶음
				//if(jjjArray.get("part_chulgo_date").equals("")) { // 사급자재 출고일이 없을 경우
					sql = new StringBuilder()
//							.append("INSERT INTO\n")
//							.append("	tbi_order_bomlist_result (				\n")
//							.append("        order_no,\n")
//							.append("        lotno,\n")
//							.append("        revision_no,\n")
//							.append("        bom_cd,\n")
//							.append("        bom_cd_rev,\n")
//							.append("        last_no,\n")
//							.append("        sys_bom_id,\n")
//							.append("        type_no,\n")
//							.append("        geukyongpoommok,\n")
//							.append("        dept_code,\n")
//							.append("        approval_date,\n")
//							.append("        approval,\n")
//							.append("        part_cd,\n")
//							.append("        part_cd_rev,\n")
//							.append("        bom_name,\n")
//							.append("        part_nm,\n")
//							.append("        part_cnt,\n")
//							.append("        mesu,\n")
//							.append("        gubun,\n")
//							.append("        qar,\n")
//							.append("        inspect_selbi,\n")
//							.append("        packing_jaryo,\n")
//							.append("        modify_note,\n")
//							.append("        cust_code,\n")
//							.append("        cust_rev,\n")
//							.append("        bigo,\n")
//							.append("        create_user_id,\n")
//							.append("        create_date,\n")
//							.append("        modify_user_id,\n")
//							.append("        modify_date,\n")
//							.append("        modify_reason,\n")
//							.append("        review_no,\n")
//							.append("        confirm_no,\n")
//							.append("        order_detail_seq,\n")
//							.append("        result,\n")
//							.append("        member_key,\n")
//							.append("        unit\n")
//							.append("	)\n")
//							.append("VALUES ( \n")
//							.append(" 		'" + jjjArray.get("order_no") 	 + "', \n") //order_no
//							.append(" 		'" + jjjArray.get("lotno") 		 + "', \n") //lotno							
//							.append(" 		'" + jjjArray.get("revision_no") + "', \n") //revision_no
//							.append(" 		'" + jjjArray.get("bom_cd") 	 + "', \n") //bom_cd
//							.append(" 		'" + jjjArray.get("bom_cd_rev")  + "', \n") //bom_cd_rev
//							.append(" 		'" + jjjArray.get("last_no") 	 + "', \n") //last_no							
//							.append(" 		'" + jjjArray.get("sys_bom_id")  + "', \n") //sys_bom_id
//							.append(" 		'" + jjjArray.get("type_no") 	 + "', \n") //type_no
//							.append(" 		'" + jjjArray.get("geukyongpoommok") + "', \n") //geukyongpoommok
//							.append(" 		'" + jjjArray.get("dept_code") 	 + "', \n") //dept_code
//							.append(" 		'" + jjjArray.get("approval_date") + "', \n") //approval_date							
//							.append(" 		'" + jjjArray.get("approval") 	   + "', \n") //approval
//							.append(" 		'" + jjjArray.get("part_cd") 	   + "', \n") //part_cd
//							.append(" 		'" + jjjArray.get("part_cd_rev")   + "', \n") //part_cd_rev	
//							.append(" 		'" + jjjArray.get("bom_name") 	   + "', \n") //bom_name
//							.append(" 		'" + jjjArray.get("part_nm") 	   + "', \n") //bom_name
//							.append(" 		'" + jjjArray.get("part_cnt") 	   + "', \n") //part_cnt							
//							.append(" 		'" + jjjArray.get("mesu") 		   + "', \n") //mesu
//							.append(" 		'" + jjjArray.get("gubun") 		   + "', \n") //gubun
//							.append(" 		'" + jjjArray.get("qar") 		   + "', \n") //qar
//							.append(" 		'" + jjjArray.get("inspect_selbi") 	+ "', \n") //inspect_selbi
//							.append(" 		'" + jjjArray.get("packing_jaryo") 	+ "', \n") //packing_jaryo							
//							.append(" 		'" + jjjArray.get("modify_note") 	+ "', \n") //modify_note
//							.append(" 		'" + jjjArray.get("cust_code") 		+ "', \n") //cust_code
//							.append(" 		'" + jjjArray.get("cust_rev") 				+ "', \n") //cust_rev
//							.append(" 		'" + jjjArray.get("bigo") 			+ "', \n") //bigo
//							.append(" 		'" + jjjArray.get("create_user_id") + "', \n") //create_user_id							
//							.append(" 		'" + jjjArray.get("create_date") 	+ "', \n") //create_date
//							.append(" 		'" + jjjArray.get("modify_user_id") + "', \n") //modify_user_id
//							.append(" 		'" + jjjArray.get("modify_date") 	+ "', \n") //modify_date
//							.append(" 		'" + jjjArray.get("modify_reason") 	+ "', \n") //modify_reason
//							.append(" 		'" + jjjArray.get("review_no") 		+ "' ,\n") //review_no	
//							.append(" 		'" + jjjArray.get("confirm_no") 	+ "', \n") //confirm_no
//							.append(" 		'" + jjjArray.get("order_detail_seq") + "', \n") //order_detail_seq
//							.append(" 		'y', \n") 										//result
//							.append(" 		'" + jjjArray.get("member_key") 	+ "', \n")
//							.append(" 		'" + jjjArray.get("unit") 	+ "' \n")	
//							.append("	)\n")
							.append("MERGE  INTO tbi_order_bomlist_result  mm\n")
							.append("USING ( SELECT\n")
							.append("						'" + jjjArray.get("order_no") 	 + "'	AS order_no,\n")
							.append("						'" + jjjArray.get("lotno") 	 + "'	AS lotno,\n")
							.append("						'" + jjjArray.get("revision_no") 	 + "'	AS revision_no,\n")
							.append("						'" + jjjArray.get("bom_cd") 	 + "'	AS bom_cd,\n")
							.append("						'" + jjjArray.get("bom_cd_rev") 	 + "'	AS bom_cd_rev,\n")
							.append("						'" + jjjArray.get("last_no") 	 + "'	AS last_no,\n")
							.append("						'" + jjjArray.get("sys_bom_id") 	 + "'	AS sys_bom_id,\n")
							.append("						'" + jjjArray.get("type_no") 	 + "'	AS type_no,\n")
							.append("						'" + jjjArray.get("geukyongpoommok") 	 + "'	AS geukyongpoommok,\n")
							.append("						'" + jjjArray.get("dept_code") 	 + "'	AS dept_code,\n")
							.append("						'" + jjjArray.get("approval_date") 	 + "'	AS approval_date,\n")
							.append("						'" + jjjArray.get("approval") 	 + "'	AS approval,\n")
							.append("						'" + jjjArray.get("part_cd") 	 + "'	AS part_cd,\n")
							.append("						'" + jjjArray.get("part_cd_rev") 	 + "'	AS part_cd_rev,\n")
							.append("						'" + jjjArray.get("bom_name") 	 + "'	AS bom_name,\n")
							.append("						'" + jjjArray.get("part_nm") 	 + "'	AS part_nm,\n")
							.append("						'" + jjjArray.get("part_cnt") 	 + "'	AS part_cnt,\n")
							.append("						'" + jjjArray.get("mesu") 	 + "'	AS mesu,\n")
							.append("						'" + jjjArray.get("gubun") 	 + "'	AS gubun,\n")
							.append("						'" + jjjArray.get("qar") 	 + "'	AS qar,\n")
							.append("						'" + jjjArray.get("inspect_selbi") 	 + "'	AS inspect_selbi,\n")
							.append("						'" + jjjArray.get("packing_jaryo") 	 + "'	AS packing_jaryo,\n")
							.append("						'" + jjjArray.get("modify_note") 	 + "'	AS modify_note,\n")
							.append("						'" + jjjArray.get("cust_code") 	 + "'	AS cust_code,\n")
							.append("						'" + jjjArray.get("cust_rev") 	 + "'	AS cust_rev,\n")
							.append("						'" + jjjArray.get("bigo") 	 + "'	AS bigo,\n")
							.append("						'" + jjjArray.get("create_user_id") 	 + "'	AS create_user_id,\n")
							.append("						'" + jjjArray.get("create_date") 	 + "'	AS create_date,\n")
							.append("						'" + jjjArray.get("modify_user_id") 	 + "'	AS modify_user_id,\n")
							.append("						'" + jjjArray.get("modify_date") 	 + "'	AS modify_date,\n")
							.append("						'" + jjjArray.get("modify_reason") 	 + "'	AS modify_reason,\n")
							.append("						'" + jjjArray.get("review_no") 	 + "'	AS review_no,\n")
							.append("						'" + jjjArray.get("confirm_no") 	 + "'	AS confirm_no,\n")
							.append("						'" + jjjArray.get("order_detail_seq") 	 + "'	AS order_detail_seq,\n")
							.append("						'Y'	AS result,\n")
							.append("						'" + jjjArray.get("member_key") 	 + "'	AS member_key,\n")
							.append("						'" + jjjArray.get("unit") 	 + "'	AS unit\n")
							.append(")  mQ\n")
							.append("ON (mm.order_no = mQ.order_no AND mm.lotno = mQ.lotno AND mm.revision_no = mQ.revision_no  AND mm.bom_cd = mQ.bom_cd  AND mm.bom_cd_rev = mQ.bom_cd_rev AND mm.sys_bom_id = mQ.sys_bom_id AND mm.part_cd = mQ.part_cd AND mm.part_cd_rev = mQ.part_cd_rev AND mm.member_key = mQ.member_key)\n")
							.append("WHEN MATCHED THEN\n")
							.append("                UPDATE SET\n")
							.append("					mm.order_no = mQ.order_no,\n")
							.append("					mm.lotno = mQ.lotno,\n")
							.append("					mm.revision_no = mQ.revision_no,\n")
							.append("					mm.bom_cd = mQ.bom_cd,\n")
							.append("					mm.bom_cd_rev = mQ.bom_cd_rev,\n")
							.append("					mm.bom_name = mQ.bom_name,\n")
							.append("					mm.last_no = mQ.last_no,\n")
							.append("					mm.sys_bom_id = mQ.sys_bom_id,\n")
							.append("					mm.type_no = mQ.type_no,\n")
							.append("					mm.geukyongpoommok = mQ.geukyongpoommok,\n")
							.append("					mm.dept_code = mQ.dept_code,\n")
							.append("					mm.approval_date = mQ.approval_date,\n")
							.append("					mm.approval = mQ.approval,\n")
							.append("					mm.part_cd = mQ.part_cd,\n")
							.append("					mm.part_cd_rev = mQ.part_cd_rev,\n")
							.append("					mm.part_nm = mQ.part_nm,\n")
							.append("					mm.part_cnt = mQ.part_cnt,\n")
							.append("					mm.mesu = mQ.mesu,\n")
							.append("					mm.gubun = mQ.gubun,\n")
							.append("					mm.qar = mQ.qar,\n")
							.append("					mm.inspect_selbi = mQ.inspect_selbi,\n")
							.append("					mm.packing_jaryo = mQ.packing_jaryo,\n")
							.append("					mm.modify_note = mQ.modify_note,\n")
							.append("					mm.cust_code = mQ.cust_code,\n")
							.append("					mm.cust_rev = mQ.cust_rev,\n")
							.append("					mm.bigo = mQ.bigo,\n")
							.append("					mm.create_user_id = mQ.create_user_id,\n")
							.append("					mm.create_date = mQ.create_date,\n")
							.append("					mm.modify_user_id = mQ.modify_user_id,\n")
							.append("					mm.modify_date = mQ.modify_date,\n")
							.append("					mm.modify_reason = mQ.modify_reason,\n")
							.append("					mm.review_no = mQ.review_no,\n")
							.append("					mm.confirm_no = mQ.confirm_no,\n")
							.append("					mm.order_detail_seq = mQ.order_detail_seq,\n")
							.append("					mm.result = mQ.result,\n")
							.append("					mm.member_key = mQ.member_key,\n")
							.append("					mm.unit = mQ.unit\n")
							.append("WHEN NOT MATCHED THEN\n")
							.append("        INSERT  (		mm.order_no,\n")
							.append("						mm.lotno,\n")
							.append("						mm.revision_no,\n")
							.append("						mm.bom_cd,\n")
							.append("						mm.bom_cd_rev,\n")
							.append("						mm.bom_name,\n")
							.append("						mm.last_no,\n")
							.append("						mm.sys_bom_id,\n")
							.append("						mm.type_no,\n")
							.append("						mm.geukyongpoommok,\n")
							.append("						mm.dept_code,\n")
							.append("						mm.approval_date,\n")
							.append("						mm.approval,\n")
							.append("						mm.part_cd,\n")
							.append("						mm.part_cd_rev,\n")
							.append("						mm.part_nm,\n")
							.append("						mm.part_cnt,\n")
							.append("						mm.mesu,\n")
							.append("						mm.gubun,\n")
							.append("						mm.qar,\n")
							.append("						mm.inspect_selbi,\n")
							.append("						mm.packing_jaryo,\n")
							.append("						mm.modify_note,\n")
							.append("						mm.cust_code,\n")
							.append("						mm.cust_rev,\n")
							.append("						mm.bigo,\n")
							.append("						mm.create_user_id,\n")
							.append("						mm.create_date,\n")
							.append("						mm.modify_user_id,\n")
							.append("						mm.modify_date,\n")
							.append("						mm.modify_reason,\n")
							.append("						mm.review_no,\n")
							.append("						mm.confirm_no,\n")
							.append("						mm.order_detail_seq,\n")
							.append("						mm.result,\n")
							.append("						mm.member_key,\n")
							.append("						mm.unit)\n")
							.append("        VALUES  (		mQ.order_no,\n")
							.append("						mQ.lotno,\n")
							.append("						mQ.revision_no,\n")
							.append("						mQ.bom_cd,\n")
							.append("						mQ.bom_cd_rev,\n")
							.append("						mQ.bom_name,\n")
							.append("						mQ.last_no,\n")
							.append("						mQ.sys_bom_id,\n")
							.append("						mQ.type_no,\n")
							.append("						mQ.geukyongpoommok,\n")
							.append("						mQ.dept_code,\n")
							.append("						mQ.approval_date,\n")
							.append("						mQ.approval,\n")
							.append("						mQ.part_cd,\n")
							.append("						mQ.part_cd_rev,\n")
							.append("						mQ.part_nm,\n")
							.append("						mQ.part_cnt,\n")
							.append("						mQ.mesu,\n")
							.append("						mQ.gubun,\n")
							.append("						mQ.qar,\n")
							.append("						mQ.inspect_selbi,\n")
							.append("						mQ.packing_jaryo,\n")
							.append("						mQ.modify_note,\n")
							.append("						mQ.cust_code,\n")
							.append("						mQ.cust_rev,\n")
							.append("						mQ.bigo,\n")
							.append("						mQ.create_user_id,\n")
							.append("						mQ.create_date,\n")
							.append("						mQ.modify_user_id,\n")
							.append("						mQ.modify_date,\n")
							.append("						mQ.modify_reason,\n")
							.append("						mQ.review_no,\n")
							.append("						mQ.confirm_no,\n")
							.append("						mQ.order_detail_seq,\n")
							.append("						mQ.result,\n")
							.append("						mQ.member_key,\n")
							.append("						mQ.unit)\n")
							.toString();
				
				 
//				 // System.out.println(sql.toString());
				resultInt = super.excuteUpdate(con, sql.toString());
				if (resultInt < 0) {
					con.rollback();
					return EventDefine.E_DOEXCUTE_ERROR ;
				}
				String main_action_no="", review_action_no="",confirm_action_no="";//없으면 없는대로 전달
				main_action_no = gOrderNo;
				
//				if(Queue.setQueue(con,c_paramArray_Detail[0][0],gOrderNo,c_paramArray_Detail[i][3],main_action_no,review_action_no,confirm_action_no)<0) {
//					con.rollback();
//					return EventDefine.E_DOEXCUTE_ERROR ;
//				}
				
			}
			con.commit();
			
			
		} catch(Exception e) {
			LoggingWriter.setLogError("M353S040100E111()","==== SQL ERROR ===="+ e.getMessage() + "\n" + sql.toString());
			e.printStackTrace();
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M353S040100E111()","==== finally ===="+ e.getMessage());
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
	
	
	public int E112(InoutParameter ioParam){

		String sql ="";
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		ApprovalActionNo ActionNo;
		String gOrderNo="";
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
			
			for(int i=0; i<jjArray.size(); i++) {
				JSONObject jjjArray = (JSONObject)jjArray.get(i); // i번째 데이터묶음
				//if(jjjArray.get("part_chulgo_date").equals("")) { // 사급자재 출고일이 없을 경우
					sql = new StringBuilder()
						.append("UPDATE  tbi_order_bomlist_result\n")
						.append("	SET part_cnt='"+jjjArray.get("part_cnt")+"'\n")
						.append("	WHERE order_no ='"+jjjArray.get("order_no")+"' AND part_cd ='"+jjjArray.get("part_cd")+"' AND member_key='"+jjjArray.get("member_key")+"'\n")
						.toString();
								 
//				 // System.out.println(sql.toString());
				resultInt = super.excuteUpdate(con, sql.toString());
				if (resultInt < 0) {
					con.rollback();
					return EventDefine.E_DOEXCUTE_ERROR ;
				}
				String main_action_no="", review_action_no="",confirm_action_no="";//없으면 없는대로 전달
				main_action_no = gOrderNo;
				
//				if(Queue.setQueue(con,c_paramArray_Detail[0][0],gOrderNo,c_paramArray_Detail[i][3],main_action_no,review_action_no,confirm_action_no)<0) {
//					con.rollback();
//					return EventDefine.E_DOEXCUTE_ERROR ;
//				}
				
			}
			con.commit();
			
			
		} catch(Exception e) {
			LoggingWriter.setLogError("M353S040100E112()","==== SQL ERROR ===="+ e.getMessage() + "\n" + sql.toString());
			e.printStackTrace();
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M353S040100E112()","==== finally ===="+ e.getMessage());
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
	
	public int E114(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			
			String sql = new StringBuilder()
					.append("SELECT \n")
					.append("	part_cd,\n")
					.append("	bom_name,\n") 
					.append("	part_cnt,\n")
					.append("	bigo,\n")
					.append("	bom_cd, \n")
					.append("	unit \n")
					.append("FROM \n")
					.append("	tbi_order_bomlist_result\n")
					.append("WHERE order_no='"+jArray.get("order_no") +"'\n")
					.append("	AND lotno = '"+jArray.get("lotno")+"'\n")
					.append("	AND bom_cd = '"+jArray.get("bom_cd")+"'\n")
					.append("	AND bom_cd_rev = '"+jArray.get("bom_cd_rev")+"'\n")
					.append("	AND member_key = '"+jArray.get("member_key")+"';\n")
					.toString();

			
			resultString = super.excuteQueryString(con, sql.toString());
			
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M353S040100E114()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M353S040100E114()","==== finally ===="+ e.getMessage());
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

	public int E214(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			System.out.println("JSONObject jArray rcvData="+ jArray.toString());
			
			// 클라이언트로 부터 받은 파라미터를 옮겨 담는다.
//			String rcvData = (String)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			// 클라이언트로 부터 받은 파라미터를 쪼개어서 배열에 담는다.
			//{ "설비코드", "업무구분", "기관명", "수리내용", "반출일", "완료일", "담당자", "비용", "비고", "SEQ_NO"};
			
//			String[][] c_paramArray = CommonFunction.getConvString2DoubleArray(rcvData);
			String sql = new StringBuilder()
					.append(" SELECT 	\n")
					.append("	 seolbi_cd, \n")
					.append("	 reason_cd, \n")
					.append("	 gigwan_nm, \n")
					.append("	 work_memo, \n")
					.append("	 start_dt,  \n")
					.append("	 end_dt,  	\n")
					.append("	 user_id,  	\n")
					.append("	 TO_CHAR (biyong, '999,999,999,999') AS biyong, \n")
					.append("	 bigo,		\n")
					.append("	 seq_no  	\n")
					.append(" FROM tbi_seolbi_repare \n")
					.append(" WHERE seolbi_cd = '" + jArray.get("sulbi_cd") + "' \n")
					.append(" AND seq_no = '" + jArray.get("seq_no") + "' \n")
					.append(" AND member_key = '" + jArray.get("member_key") + "' \n")
					.toString();
			
			resultString = super.excuteQueryString(con, sql.toString());
			
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M353S040100E214()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M353S040100E214()","==== finally ===="+ e.getMessage());
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