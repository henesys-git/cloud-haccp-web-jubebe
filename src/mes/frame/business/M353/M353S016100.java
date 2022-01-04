package mes.frame.business.M353;

import java.lang.reflect.Method;
import java.sql.Connection;
import java.sql.PreparedStatement;

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


public class M353S016100 extends SqlAdapter{
	Connection con = null;
	PreparedStatement pstmt = null;
	String resultString = "";
	int resultInt = -1;
	StringBuffer sql = new StringBuffer();
	
	String[][] v_paramArray = new String[0][0]; 
	Class[] optClass = null;
	Object[] optObj = null;
	Object obj = null;
	
	public M353S016100(){
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
			
			Method method = M353S016100.class.getMethod(event,optClass);
			LoggingWriter.setLogDebug(M353S016100.class.getName(),"==== " + event + " EventMethod Create Success ====");

			obj = method.invoke(M353S016100.class.newInstance(),optObj);
			doExcute_result = CommonFunction.getInt(obj.toString());
			
	    } catch (Exception ex) {
	    	doExcute_result = EventDefine.E_DOEXCUTE_INIT;
			ioParam.setMessage(MessageDefine.M_NO_EVENTID);
			LoggingWriter.setLogError(M353S016100.class.getName(),"==== EventID Not define : EVENT ID [ " + ioParam.getEventID() + "]");
	    } finally {
	    	obj = null;
			optClass = null;
			optObj = null;
	    }
	    long endTime = System.currentTimeMillis();
		long runningTime = endTime - startTime;
		LoggingWriter.setLogAll(M353S016100.class.getName(),"==== Query [수행시간  : " + runningTime + " ms]");
		
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
			sql.append(" insert into tbi_seolbi_repare ( 		\n");
			sql.append(" 		seolbi_cd,						\n"); 
			sql.append(" 		seq_no,							\n"); 
			sql.append(" 		reason_cd,						\n"); 
			sql.append(" 		start_dt,						\n"); 
			sql.append(" 		end_dt,							\n"); 
			sql.append(" 		user_id,						\n"); 
			sql.append(" 		biyong,							\n"); 
			sql.append(" 		gigwan_nm,						\n"); 
			sql.append(" 		work_memo,						\n"); 
			sql.append(" 		bigo,							\n");
			sql.append(" 		member_key						\n");
			sql.append(" 	) values ( 							\n");
			sql.append(" 		'" + jArray.get("seolbi_code") + "' 	\n"); 	//seolbi_cd
			sql.append(" 		,(select coalesce(max(seq_no),0)+1 from tbi_seolbi_repare where \n"); 	//sys_bom_id
			sql.append(" 		 	seolbi_cd='" + jArray.get("seolbi_code") + "') \n");
			sql.append(" 		,'" + jArray.get("job_gubun") + "' 	\n"); 	//reason_cd
			sql.append(" 		,'" + jArray.get("start_date") + "' \n"); 	//start_dt
			sql.append(" 		,'" + jArray.get("end_date") + "'	\n"); 	//end_dt
			sql.append(" 		,'" + jArray.get("damdangja") + "' 	\n"); 	//user_id
			sql.append(" 		,'" + jArray.get("biyong") + "' 	\n"); 	//biyong
			sql.append(" 		,'" + jArray.get("gigwan_name") + "'\n"); 	//gigwan_nm
			sql.append(" 		,'" + jArray.get("work_memo") + "' 	\n"); 	//work_memo
			sql.append(" 		,'" + jArray.get("bigo") + "'		\n"); 	//bigo
			sql.append(" 		,'" + jArray.get("member_key") + "'	\n"); 	//bigo
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
			LoggingWriter.setLogError("M353S016100E101()","==== SQL ERROR ===="+ e.getMessage() + "\n" + sql.toString());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M353S016100E101()","==== finally ===="+ e.getMessage());
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
			sql.append(" 	reason_cd = '" + jArray.get("job_gubun") + "',	\n"); 
			sql.append(" 	start_dt = 	'" + jArray.get("start_date") + "',	\n"); 
			sql.append(" 	end_dt = 	'" + jArray.get("end_date") + "',	\n"); 
			sql.append(" 	user_id = 	'" + jArray.get("damdangja") + "',	\n"); 
			sql.append(" 	biyong = 	'" + jArray.get("biyong") + "',		\n"); 
			sql.append(" 	gigwan_nm = '" + jArray.get("gigwan_name") + "',	\n"); 
			sql.append(" 	work_memo = '" + jArray.get("work_memo") + "',	\n"); 
			sql.append(" 	bigo = 		'" + jArray.get("bigo") + "',		\n"); 
			sql.append(" 	member_key = 		'" + jArray.get("member_key") + "'		\n"); 
			sql.append(" WHERE seolbi_cd = 	'" + jArray.get("seolbi_code") + "' \n");
			sql.append(" 	AND seq_no = '"    + jArray.get("seq_no") + "' 		\n");
			sql.append(" 	AND member_key = '"    + jArray.get("member_key") + "' \n");

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
			LoggingWriter.setLogError("M353S016100E102()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M353S016100E102()","==== finally ===="+ e.getMessage());
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
			sql.append(" DELETE FROM tbi_seolbi_repare 	\n");
			sql.append(" WHERE seolbi_cd = 	'" + jArray.get("seolbi_code") + "' \n");
			sql.append(" 	AND seq_no = 	'" + jArray.get("seq_no") + "' \n");
			sql.append(" 	AND member_key = 	'" + jArray.get("member_key") + "' \n");

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
			LoggingWriter.setLogError("M353S016100E103()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M353S016100E103()","==== finally ===="+ e.getMessage());
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
					.append("WITH part_storage_yesterday AS (\n")
					.append("	SELECT\n")
					.append("		A.warehousing_datetime,\n")
					.append("		A.part_cd,\n")
					.append("		A.part_cd_rev,\n")
					.append("		A.expiration_date,\n")
					.append("		A.pre_amt,\n")
					.append("		A.post_amt,\n")
					.append("		A.io_amt,\n")
					.append("		A.member_key\n")
					.append("	FROM tbi_production_subpart_storage A\n")
					.append("	INNER JOIN (\n")
					.append("		SELECT\n")
					.append("			MAX(warehousing_datetime) AS warehousing_datetime,\n")
					.append("			part_cd,part_cd_rev,expiration_date,member_key\n")
					.append("		FROM tbi_production_subpart_storage\n")
					.append("		WHERE TO_CHAR(TO_DATETIME(warehousing_datetime),'YYYY-MM-DD')<'" + jArray.get("fromdate") + "'\n")
					.append("		GROUP BY part_cd,part_cd_rev,expiration_date,member_key\n")
					.append("	) B\n")
					.append("		ON A.part_cd=B.part_cd\n")
					.append("		AND A.part_cd_rev=B.part_cd_rev\n")
					.append("		AND A.expiration_date=B.expiration_date\n")
					.append("		AND A.member_key=B.member_key\n")
					.append("		AND A.warehousing_datetime=B.warehousing_datetime\n")
					.append("), part_ipgo_today AS (\n")
					.append("	SELECT part_cd,part_cd_rev,expiration_date,member_key, SUM(io_amt) AS ipgo_amt\n")
					.append("	FROM tbi_production_subpart_storage\n")
					.append("	WHERE TO_CHAR(TO_DATETIME(warehousing_datetime),'YYYY-MM-DD')='" + jArray.get("fromdate") + "'\n")
					.append("		AND io_gubun='I'\n")
					.append("	GROUP BY part_cd,part_cd_rev,expiration_date,member_key\n")
					.append("), part_chulgo_today AS (\n")
					.append("	SELECT part_cd,part_cd_rev,expiration_date,member_key, SUM(io_amt) AS chulgo_amt\n")
					.append("	FROM tbi_production_subpart_storage\n")
					.append("	WHERE TO_CHAR(TO_DATETIME(warehousing_datetime),'YYYY-MM-DD')='" + jArray.get("fromdate") + "'\n")
					.append("		AND io_gubun='O'\n")
					.append("	GROUP BY part_cd,part_cd_rev,expiration_date,member_key\n")
					.append("), part_storage_today AS (\n")
					.append("	SELECT\n")
					.append("		A.warehousing_datetime,\n")
					.append("		A.part_cd,\n")
					.append("		A.part_cd_rev,\n")
					.append("		A.expiration_date,\n")
					.append("		A.pre_amt,\n")
					.append("		A.post_amt,\n")
					.append("		A.io_amt,\n")
					.append("		A.member_key\n")
					.append("	FROM tbi_production_subpart_storage A\n")
					.append("	INNER JOIN (\n")
					.append("		SELECT\n")
					.append(" 	       	MAX(warehousing_datetime) AS warehousing_datetime,\n")
					.append(" 	       	part_cd,part_cd_rev,expiration_date,member_key\n")
					.append("		FROM tbi_production_subpart_storage\n")
					.append("		WHERE TO_CHAR(TO_DATETIME(warehousing_datetime),'YYYY-MM-DD')<='" + jArray.get("fromdate") + "'\n")
					.append("        	GROUP BY part_cd,part_cd_rev,expiration_date,member_key\n")
					.append("	) B\n")
					.append("        	ON A.part_cd=B.part_cd\n")
					.append("        	AND A.part_cd_rev=B.part_cd_rev\n")
					.append("        	AND A.expiration_date=B.expiration_date\n")
					.append("        	AND A.member_key=B.member_key\n")
					.append("        	AND A.warehousing_datetime=B.warehousing_datetime\n")
					.append(")\n")
					.append("--여기서부터 메인\n")
					.append("SELECT\n")
					.append("	B.code_name AS gubun_b,\n")
					.append("	M.code_name AS gubun_m,\n")
					.append("	A.part_nm,\n")
					.append("	A.unit_type,\n")
					.append("	A.unit_price,\n")
					.append("	CAST(NVL(C.post_amt,'0.0') AS NUMERIC(15,3)) AS pre_amt,\n")
					.append("	CAST(NVL(D.ipgo_amt,'0.0') AS NUMERIC(15,3)) AS ipgo_amt,\n")
					.append("	CAST(NVL(E.chulgo_amt,'0.0') AS NUMERIC(15,3)) AS chulgo_amt,\n")
					.append("	CAST(NVL(F.post_amt,'0.0') AS NUMERIC(15,3)) AS post_amt,\n")
					.append("	A.unit_price * CAST(NVL(F.post_amt,'0.0') AS NUMERIC(15,0)) AS total_price,\n")
					.append("	'' AS total,\n")
					.append("	A.part_cd\n")
					.append("FROM tbm_part_list A\n")
					.append("INNER JOIN v_partgubun_big B\n")
					.append("	ON A.part_gubun_b = B.code_value\n")
					.append("	AND A.member_key = B.member_key\n")
					.append("INNER JOIN v_partgubun_mid M\n")
					.append("	ON A.part_gubun_m = M.code_value\n")
					.append("	AND A.member_key = M.member_key\n")
					.append("LEFT OUTER JOIN part_storage_today F\n")
					.append("	ON A.part_cd=F.part_cd\n")
					.append("	AND A.revision_no=F.part_cd_rev\n")
					.append("	AND F.expiration_date=F.expiration_date\n")
					.append("	AND A.member_key=F.member_key\n")
					.append("LEFT OUTER JOIN part_storage_yesterday C\n")
					.append("	ON A.part_cd=C.part_cd\n")
					.append("	AND A.revision_no=C.part_cd_rev\n")
					.append("	AND F.expiration_date=C.expiration_date\n")
					.append("	AND A.member_key=C.member_key\n")
					.append("LEFT OUTER JOIN part_ipgo_today D\n")
					.append("	ON A.part_cd=D.part_cd\n")
					.append("	AND A.revision_no=D.part_cd_rev\n")
					.append("	AND F.expiration_date=D.expiration_date\n")
					.append("	AND A.member_key=D.member_key\n")
					.append("LEFT OUTER JOIN part_chulgo_today E\n")
					.append("	ON A.part_cd=E.part_cd\n")
					.append("	AND A.revision_no=E.part_cd_rev\n")
					.append("	AND F.expiration_date=E.expiration_date\n")
					.append("	AND A.member_key=E.member_key\n")
					.append("WHERE A.part_gubun='IMPORT2'\n")
					.append("	AND (D.ipgo_amt>0 OR E.chulgo_amt>0 OR F.post_amt>0)\n")
					.append("   AND A.member_key = '" + jArray.get("member_key") + "'\n")
					.append(jArray.get("g_search")+"\n")
					.append("ORDER BY  A.part_cd\n")
					.append(jArray.get("G_limit")+"\n")
					.toString();

			resultString = super.excuteQueryString(con, sql.toString());
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M353S016100E104()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M353S016100E104()","==== finally ===="+ e.getMessage());
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
	
	public int E124(InoutParameter ioParam) {
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			System.out.println("JSONObject jArray rcvData="+ jArray.toString());
		
			String sql = new StringBuilder()
					.append("WITH part_storage_yesterday AS (\n")
					.append("	SELECT\n")
					.append("		A.warehousing_datetime,\n")
					.append("		A.part_cd,\n")
					.append("		A.part_cd_rev,\n")
					.append("		A.expiration_date,\n")
					.append("		A.pre_amt,\n")
					.append("		A.post_amt,\n")
					.append("		A.io_amt,\n")
					.append("		A.member_key\n")
					.append("	FROM tbi_production_subpart_storage A\n")
					.append("	INNER JOIN (\n")
					.append("		SELECT\n")
					.append("			MAX(warehousing_datetime) AS warehousing_datetime,\n")
					.append("			part_cd,part_cd_rev,expiration_date,member_key\n")
					.append("		FROM tbi_production_subpart_storage\n")
					.append("		WHERE TO_CHAR(TO_DATETIME(warehousing_datetime),'YYYY-MM-DD')<'" + jArray.get("fromdate") + "'\n")
					.append("		GROUP BY part_cd,part_cd_rev,expiration_date,member_key\n")
					.append("	) B\n")
					.append("		ON A.part_cd=B.part_cd\n")
					.append("		AND A.part_cd_rev=B.part_cd_rev\n")
					.append("		AND A.expiration_date=B.expiration_date\n")
					.append("		AND A.member_key=B.member_key\n")
					.append("		AND A.warehousing_datetime=B.warehousing_datetime\n")
					.append("), part_ipgo_today AS (\n")
					.append("	SELECT part_cd,part_cd_rev,expiration_date,member_key, SUM(io_amt) AS ipgo_amt\n")
					.append("	FROM tbi_production_subpart_storage\n")
					.append("	WHERE TO_CHAR(TO_DATETIME(warehousing_datetime),'YYYY-MM-DD')='" + jArray.get("fromdate") + "'\n")
					.append("		AND io_gubun='I'\n")
					.append("	GROUP BY part_cd,part_cd_rev,expiration_date,member_key\n")
					.append("), part_chulgo_today AS (\n")
					.append("	SELECT part_cd,part_cd_rev,expiration_date,member_key, SUM(io_amt) AS chulgo_amt\n")
					.append("	FROM tbi_production_subpart_storage\n")
					.append("	WHERE TO_CHAR(TO_DATETIME(warehousing_datetime),'YYYY-MM-DD')='" + jArray.get("fromdate") + "'\n")
					.append("		AND io_gubun='O'\n")
					.append("	GROUP BY part_cd,part_cd_rev,expiration_date,member_key\n")
					.append("), part_storage_today AS (\n")
					.append("	SELECT\n")
					.append("		A.warehousing_datetime,\n")
					.append("		A.part_cd,\n")
					.append("		A.part_cd_rev,\n")
					.append("		A.expiration_date,\n")
					.append("		A.pre_amt,\n")
					.append("		A.post_amt,\n")
					.append("		A.io_amt,\n")
					.append("		A.member_key\n")
					.append("	FROM tbi_production_subpart_storage A\n")
					.append("	INNER JOIN (\n")
					.append("		SELECT\n")
					.append(" 	       	MAX(warehousing_datetime) AS warehousing_datetime,\n")
					.append(" 	       	part_cd,part_cd_rev,expiration_date,member_key\n")
					.append("		FROM tbi_production_subpart_storage\n")
					.append("		WHERE TO_CHAR(TO_DATETIME(warehousing_datetime),'YYYY-MM-DD')<='" + jArray.get("fromdate") + "'\n")
					.append("        	GROUP BY part_cd,part_cd_rev,expiration_date,member_key\n")
					.append("	) B\n")
					.append("        	ON A.part_cd=B.part_cd\n")
					.append("        	AND A.part_cd_rev=B.part_cd_rev\n")
					.append("        	AND A.expiration_date=B.expiration_date\n")
					.append("        	AND A.member_key=B.member_key\n")
					.append("        	AND A.warehousing_datetime=B.warehousing_datetime\n")
					.append(")\n")
					.append("--여기서부터 메인\n")
					.append("SELECT\n")
					.append("	B.code_name AS gubun_b,\n")
					.append("	M.code_name AS gubun_m,\n")
					.append("	A.part_nm,\n")
					.append("	A.unit_type,\n")
					.append("	A.unit_price,\n")
					.append("	CAST(NVL(C.post_amt,'0.0') AS NUMERIC(15,3)) AS pre_amt,\n")
					.append("	CAST(NVL(D.ipgo_amt,'0.0') AS NUMERIC(15,3)) AS ipgo_amt,\n")
					.append("	CAST(NVL(E.chulgo_amt,'0.0') AS NUMERIC(15,3)) AS chulgo_amt,\n")
					.append("	CAST(NVL(F.post_amt,'0.0') AS NUMERIC(15,3)) AS post_amt,\n")
					.append("	A.unit_price * CAST(NVL(F.post_amt,'0.0') AS NUMERIC(15,0)) AS total_price,\n")
					.append("	'' AS total,\n")
					.append("	A.part_cd\n")
					.append("FROM tbm_part_list A\n")
					.append("INNER JOIN v_partgubun_big B\n")
					.append("	ON A.part_gubun_b = B.code_value\n")
					.append("	AND A.member_key = B.member_key\n")
					.append("INNER JOIN v_partgubun_mid M\n")
					.append("	ON A.part_gubun_m = M.code_value\n")
					.append("	AND A.member_key = M.member_key\n")
					.append("LEFT OUTER JOIN part_storage_today F\n")
					.append("	ON A.part_cd=F.part_cd\n")
					.append("	AND A.revision_no=F.part_cd_rev\n")
					.append("	AND F.expiration_date=F.expiration_date\n")
					.append("	AND A.member_key=F.member_key\n")
					.append("LEFT OUTER JOIN part_storage_yesterday C\n")
					.append("	ON A.part_cd=C.part_cd\n")
					.append("	AND A.revision_no=C.part_cd_rev\n")
					.append("	AND F.expiration_date=C.expiration_date\n")
					.append("	AND A.member_key=C.member_key\n")
					.append("LEFT OUTER JOIN part_ipgo_today D\n")
					.append("	ON A.part_cd=D.part_cd\n")
					.append("	AND A.revision_no=D.part_cd_rev\n")
					.append("	AND F.expiration_date=D.expiration_date\n")
					.append("	AND A.member_key=D.member_key\n")
					.append("LEFT OUTER JOIN part_chulgo_today E\n")
					.append("	ON A.part_cd=E.part_cd\n")
					.append("	AND A.revision_no=E.part_cd_rev\n")
					.append("	AND F.expiration_date=E.expiration_date\n")
					.append("	AND A.member_key=E.member_key\n")
					.append("WHERE A.part_gubun='IMPORT2'\n")
					.append("	AND (D.ipgo_amt>0 OR E.chulgo_amt>0 OR F.post_amt>0)\n")
					.append("   AND A.member_key = '" + jArray.get("member_key") + "'\n")
					.append("ORDER BY  A.part_cd\n")
					.toString();

			resultString = super.excuteQueryString(con, sql.toString());
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M353S016100E124()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
		} finally {
			if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M353S016100E124()","==== finally ===="+ e.getMessage());
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
					.append(" SELECT 	\n")
					.append("	 seolbi_cd, \n")
					.append("	 B.code_name AS reason_cd, \n")
					.append("	 gigwan_nm, \n")
					.append("	 work_memo, \n")
					.append("	 start_dt, 	\n")
					.append("	 end_dt, 	\n")
					.append("	 user_id, 	\n")
					.append("	 TO_CHAR (biyong, '999,999,999,999') AS biyong, \n")
					.append("	 A.bigo, 	\n")
					.append("	 seq_no  	\n")
					.append(" FROM 					\n")
					.append("	tbi_seolbi_repare A	\n")
					.append(" INNER JOIN tbm_code_book B\n")
					.append(" 	ON A.reason_cd = B.code_value\n")
					.append(" 	AND A.member_key = B.member_key\n")
					.append(" WHERE seolbi_cd = '" + jArray.get("seolbi_cd") + "' \n")
					.append(" AND A.member_key = '" + jArray.get("member_key") + "' \n")
					.append(" ORDER BY seq_no DESC \n")
					.toString();
			
			resultString = super.excuteQueryString(con, sql.toString());
			
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M353S016100E114()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M353S016100E114()","==== finally ===="+ e.getMessage());
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
					.append("	 bigo,  	\n")
					.append("	 seq_no  	\n")
					.append(" FROM 			\n")
					.append("	tbi_seolbi_repare	\n")
					.append(" WHERE seolbi_cd = '" + jArray.get("sulbi_cd") + "' \n")
					.append(" AND seq_no = '" + jArray.get("seq_no") + "' \n")
					.append(" AND member_key = '" + jArray.get("member_key") + "' \n")
					.toString();
			
			resultString = super.excuteQueryString(con, sql.toString());
			
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M353S016100E214()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M353S016100E214()","==== finally ===="+ e.getMessage());
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