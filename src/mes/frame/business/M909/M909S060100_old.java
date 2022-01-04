package mes.frame.business.M909;

import java.lang.reflect.Method;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.util.Vector;

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


public class M909S060100_old extends SqlAdapter{
	Connection con = null;
	PreparedStatement pstmt = null;
	String resultString = "";
	int resultInt = -1;
	StringBuffer sql = new StringBuffer();
	
	String[][] v_paramArray = new String[0][0]; 
	Class[] optClass = null;
	Object[] optObj = null;
	Object obj = null;
	
	public M909S060100_old(){
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

			Method method = M909S060100_old.class.getMethod(event,optClass);
			LoggingWriter.setLogDebug(M909S060100_old.class.getName(),"==== " + event + " EventMethod Create Success ====");

			obj = method.invoke(M909S060100_old.class.newInstance(),optObj);
			doExcute_result = CommonFunction.getInt(obj.toString());
			
	    } catch (Exception ex) {
	    	doExcute_result = EventDefine.E_DOEXCUTE_INIT;
			ioParam.setMessage(MessageDefine.M_NO_EVENTID);
			LoggingWriter.setLogError(M909S060100_old.class.getName(),"==== EventID Not define : EVENT ID [ " + ioParam.getEventID() + "]");
	    } finally {
	    	obj = null;
			optClass = null;
			optObj = null;
	    }
	    long endTime = System.currentTimeMillis();
		long runningTime = endTime - startTime;
		LoggingWriter.setLogAll(M909S060100_old.class.getName(),"==== Query [수행시간  : " + runningTime + " ms]");
		
		return doExcute_result;
	}
	

	public int E101(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jObj = new JSONObject();
			jObj = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));

			String sql = new StringBuilder()
					.append("INSERT INTO\n")
					.append("	tbm_product (\n")
					.append("		prod_cd,\n")
					.append("		product_nm,\n")
					.append("		prod_sub_cd,\n")
					.append("		gugyuk,\n")
					.append("		count_in_pack,\n")
					.append("		count_in_box,\n")
					.append("		prod_gubun_b,\n")
					.append("		prod_gubun_m,\n")
					.append("		start_date,\n")
					.append("		create_date,\n")
					.append("		expiration_date,\n")
					.append("		safe_stock,\n")
					.append("		packing_cost\n")
					.append("	)\n")
					.append("VALUES\n")
					.append("	(\n")
					.append("		'"+jObj.get("prod_cd")+"',\n")
					.append("		'"+jObj.get("product_nm")+"',\n")
					.append("		'"+jObj.get("prod_sub_cd")+"',\n")
					.append("		'"+jObj.get("gugyuk")+"',\n")
					.append("		'"+jObj.get("count_in_pack")+"',\n")
					.append("		'"+jObj.get("count_in_box")+"',\n")
					.append("		'"+jObj.get("prod_gubun_b")+"',\n")
					.append("		'"+jObj.get("prod_gubun_m")+"',\n")
					.append("		'"+jObj.get("start_date")+"',\n")
					.append("		SYSDATE,\n")
					.append("		'"+jObj.get("expiration_date")+"',\n")
					.append("		'"+jObj.get("safe_stock")+"',\n")
					.append("		'"+jObj.get("packing_cost")+"'\n")
					.append("	);\n")
					.toString();
			
				resultInt = super.excuteUpdate(con, sql.toString());
				if (resultInt < 0) {
					ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
					return resultInt;
				} else {
					ioParam.setMessage(resultInt + "건 " + MessageDefine.M_INSERT_RESULT);
				}
		} catch(Exception e) {
			LoggingWriter.setLogError("M909S060100E101()","==== SQL ERROR ===="
										+ e.getMessage() + "\n" + sql.toString());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M909S060100E101()","==== finally ====" + e.getMessage());
				}
	    	}
	    }
		ioParam.setResultString(resultString);
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
	   
		return EventDefine.E_QUERY_RESULT;
	}

	public int E102(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			con.setAutoCommit(false);
			
			JSONObject jObj = new JSONObject();
			jObj = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			
			String sql = new StringBuilder()
					.append("MERGE INTO tbm_product tt\n")
					.append("USING (\n")
					.append("	SELECT \n")
					.append("		'"+jObj.get("prod_cd")+"' AS prod_cd,\n")
					.append("		"+jObj.get("revision_no")+" + 1 AS revision_no,\n")
					.append("       '"+jObj.get("product_nm")+"' AS product_nm,\n")
					.append("       '"+jObj.get("prod_sub_cd")+"' AS prod_sub_cd,\n")
					.append("       '"+jObj.get("gugyuk")+"' AS gugyuk,\n")
					.append("       '"+jObj.get("count_in_pack")+"' AS count_in_pack,\n")
					.append("       '"+jObj.get("count_in_box")+"' AS count_in_box,\n")
					.append("       '"+jObj.get("code_value_b")+"' AS prod_gubun_b,\n")
					.append("       '"+jObj.get("code_value_m")+"' AS prod_gubun_m,\n")
					.append("       '"+jObj.get("start_date")+"' AS start_date,\n")
					.append("       '"+jObj.get("expiration_date")+"' AS expiration_date,\n")
					.append("       '"+jObj.get("safe_stock")+"' AS safe_stock,\n")
					.append("       '"+jObj.get("packing_cost")+"' AS packing_cost\n")
					.append(") st\n")
					.append("ON (tt.prod_cd = st.prod_cd AND tt.revision_no = st.revision_no)\n")
					.append("WHEN MATCHED THEN \n")
					.append("	UPDATE SET\n")
					.append("		tt.product_nm = st.product_nm,\n")
					.append("		tt.prod_sub_cd = st.prod_sub_cd,\n")
					.append("		tt.gugyuk = st.gugyuk,\n")
					.append("		tt.count_in_pack = st.count_in_pack,\n")
					.append("		tt.count_in_box = st.count_in_box,\n")
					.append("		tt.start_date = st.start_date,\n")
					.append("		tt.expiration_date = st.expiration_date,\n")
					.append("		tt.safe_stock = st.safe_stock,\n")
					.append("		tt.packing_cost = st.packing_cost\n")
					.append("WHEN NOT MATCHED THEN \n")
					.append("	INSERT (\n")
					.append("		tt.prod_cd,\n")
					.append("		tt.revision_no,\n")
					.append("		tt.product_nm,\n")
					.append("		tt.prod_sub_cd,\n")
					.append("		tt.gugyuk,\n")
					.append("		tt.count_in_pack,\n")
					.append("		tt.count_in_box,\n")
					.append("		tt.prod_gubun_b,\n")
					.append("		tt.prod_gubun_m,\n")
					.append("		tt.start_date,\n")
					.append("		tt.create_date,\n")
					.append("		tt.expiration_date,\n")
					.append("		tt.safe_stock,\n")
					.append("		tt.packing_cost\n")
					.append("	)\n")
					.append("	VALUES (\n")
					.append("		st.prod_cd,\n")
					.append("		st.revision_no,\n")
					.append("		st.product_nm,\n")
					.append("		st.prod_sub_cd,\n")
					.append("		st.gugyuk,\n")
					.append("		st.count_in_pack,\n")
					.append("		st.count_in_box,\n")
					.append("		st.prod_gubun_b,\n")
					.append("		st.prod_gubun_m,\n")
					.append("		st.start_date,\n")
					.append("		SYSDATETIME,\n")
					.append("		st.expiration_date,\n")
					.append("		st.safe_stock,\n")
					.append("		st.packing_cost\n")
					.append("	)\n")
					.toString();

			resultInt = super.excuteUpdate(con, sql.toString());
			if (resultInt < 0) {
				ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
				return resultInt;
			} else {
				ioParam.setMessage(resultInt + "건 " + MessageDefine.M_INSERT_RESULT);
			}
				
			sql = new StringBuilder()
					.append("UPDATE\n")
					.append("	tbm_product\n")
					.append("SET\n")
					.append("	modify_date = SYSDATE,\n")
					.append("	modify_user_id = '',\n")
					.append("	duration_date = DATE_FORMAT(SUBDATE('"+jObj.get("start_date")+"', 1), '%Y-%m-%d'), \n")
					.append("	modify_reason = ''\n")
					.append("WHERE\n")
					.append("	prod_cd = '"+jObj.get("prod_cd")+"'\n")
					.append("	AND revision_no = "+jObj.get("revision_no")+" \n")
					.toString();

				resultInt = super.excuteUpdate(con, sql.toString());
				if (resultInt < 0) {
					ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
					return resultInt;
				} else {
					ioParam.setMessage(resultInt + "건 " + MessageDefine.M_INSERT_RESULT);
				}
			con.commit();
		} catch(Exception e) {
			LoggingWriter.setLogError("M909S060100E102()","==== SQL ERROR ===="+ e.getMessage() + "\n" + sql.toString());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M909S060100E102()","==== finally ===="+ e.getMessage());
				}
	    	} else {
	    	}
	    }
		ioParam.setResultString(resultString);
		ioParam.setColumnCount("" + super.COLUMN_COUNT);

		return EventDefine.E_QUERY_RESULT;
	}
	
	// yumsam
	// 제품 정보 삭제
	public int E103(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jObj = new JSONObject();
			jObj = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			
			String Delete_sql = new StringBuilder()
					.append("UPDATE									\n")
					.append("	tbm_product							\n")
					.append("SET									\n")
					.append("	delyn = 'Y'							\n")
					.append("WHERE									\n")
					.append("	prod_cd = '"+jObj.get("prod_cd")+"'	\n")
					.toString();
					
			resultInt = super.excuteUpdate(con, Delete_sql);
			if (resultInt < 0) {
				ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
				return resultInt;
			} else {
				ioParam.setMessage(resultInt + "건 " + MessageDefine.M_INSERT_RESULT);
			}
		} catch(Exception e) {
			LoggingWriter.setLogError("M909S060100E103()","==== SQL ERROR ===="+ e.getMessage() + "\n" + sql.toString());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M909S060100E103()","==== finally ===="+ e.getMessage());
				}
	    	} else {
	    	}
	    }
		ioParam.setResultString(resultString);
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
	    
		return EventDefine.E_QUERY_RESULT;
	}

	// yumsam
	// 완제품 정보, 삭제된 것까지 다 조회
	public int E104(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			System.out.println("JSONObject jArray rcvData="+ jArray.toString());
			
			String sql = new StringBuilder()
					.append("SELECT																	\n")
					.append("	B.code_name,														\n")
					.append("	B.code_value,														\n")
					.append("	M.code_name,														\n")
					.append("	M.code_value,														\n")
					.append("	P.prod_cd,															\n")
					.append("	P.revision_no,														\n")
					.append("	P.prod_sub_cd,														\n")
					.append("	P.product_nm,														\n")
					.append("	P.gugyuk,															\n")
					.append("	P.count_in_pack,													\n")
					.append("	P.count_in_box,														\n")
					.append("	P.safe_stock,														\n")
					.append("	P.packing_cost,														\n")
					.append("	P.expiration_date,													\n")
					.append("	P.start_date,													    \n")
					.append("	P.duration_date														\n")
					.append("FROM tbm_product P														\n")
					.append("	INNER JOIN v_prodgubun_big B										\n")
					.append("	ON P.prod_gubun_b = B.code_value --AND P.member_key = B.member_key	\n")
					.append("	INNER JOIN v_prodgubun_mid M										\n")
					.append("	ON P.prod_gubun_m = M.code_value --AND P.member_key = M.member_key	\n")
					.append("WHERE prod_gubun_b like '" + jArray.get("prodgubun_big") + "%'			\n")
					.append("  AND prod_gubun_m like '" + jArray.get("prodgubun_mid") + "%'			\n")
					.append("ORDER BY prod_cd ASC, revision_no DESC									\n")
					.toString();

			resultString = super.excuteQueryString(con, sql);
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M909S060100E104()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M909S060100E104()","==== finally ===="+ e.getMessage());
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
	
	// yumsam
	// 완제품 정보, 삭제된 것은 제외하고 조회
	public int E105(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			
			String sql = new StringBuilder()
					.append("SELECT																	\n")
					.append("	B.code_name,														\n")
					.append("	B.code_value,														\n")
					.append("	M.code_name,														\n")
					.append("	M.code_value,														\n")
					.append("	P.prod_cd,															\n")
					.append("	P.revision_no,														\n")
					.append("	P.prod_sub_cd,														\n")
					.append("	P.product_nm,														\n")
					.append("	P.gugyuk,															\n")
					.append("	P.count_in_pack,													\n")
					.append("	P.count_in_box,														\n")
					.append("	P.safe_stock,														\n")
					.append("	P.packing_cost,														\n")
					.append("	P.expiration_date,													\n")
					.append("	P.start_date,													    \n")
					.append("	P.duration_date													    \n")
					.append("FROM tbm_product P														\n")
					.append("	INNER JOIN v_prodgubun_big B										\n")
					.append("	ON P.prod_gubun_b = B.code_value --AND P.member_key = B.member_key	\n")
					.append("	INNER JOIN v_prodgubun_mid M										\n")
					.append("	ON P.prod_gubun_m = M.code_value --AND P.member_key = M.member_key	\n")
					.append("WHERE prod_gubun_b like '" + jArray.get("prodgubun_big") + "%' 		\n")
					.append("	AND prod_gubun_m like '" + jArray.get("prodgubun_mid") + "%' 		\n")
					.append("	AND P.start_date != P.duration_date									\n")
					.append("	AND SYSDATE BETWEEN start_date AND duration_date					\n")
					.append("	AND delyn = 'N'														\n")
					.append("ORDER BY prod_cd ASC, revision_no DESC									\n")
					.toString();

			resultString = super.excuteQueryString(con, sql);
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M909S060100E105()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M909S060100E105()","==== finally ===="+ e.getMessage());
				}
	    	} else {
	    	}
	    }
		ioParam.setResultString(resultString);
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
    	ioParam.setMessage(MessageDefine.M_QUERY_OK);
	    return EventDefine.E_QUERY_RESULT;
	}
	
	/* 배합정보관리 조회 */
	// yumsam
	public int E106(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			
			String sql = new StringBuilder()
					.append("SELECT						\n")
					.append("        D.code_name,		\n")
					.append("        E.code_name,		\n")
					.append("        A.prod_cd,			\n")
					.append("        A.revision_no,		\n")
					.append("        A.product_nm,		\n")
					.append("        A.gugyuk,			\n")
					.append("        A.start_date,		\n")
					.append("        A.duration_date,	\n")
					.append("        create_user_id,	\n")
					.append("        create_date,		\n")
					.append("        modify_user_id,	\n")
					.append("        modify_reason,		\n")
					.append("        modify_date		\n")
					.append("FROM    tbm_product A		\n")
					.append("	INNER JOIN v_prodgubun_big D			\n")
					.append("   	ON A.prod_gubun_b = D.code_value 	\n")
					.append("   	AND A.member_key = D.member_key 	\n")
					.append("	INNER JOIN v_prodgubun_mid E			\n")
					.append("		ON A.prod_gubun_m = E.code_value 	\n")
					.append("		AND A.member_key = E.member_key  	\n")
					.append("WHERE prod_gubun_b like '" + jArray.get("prodgubun_big") + 
						   "%' AND prod_gubun_m like '" + jArray.get("prodgubun_mid") + "%' 	\n")
					.append("	AND SYSDATE BETWEEN A.start_date AND A.duration_date			\n")
					.append("	AND A.member_key = '" + jArray.get("member_key") + "' 			\n")
					.append("	AND A.delyn != 'Y' 												\n")
					.append("   AND A.revision_no = (SELECT MAX(revision_no) FROM 				\n")
					.append("   					 			  tbm_product G	  				\n")
					.append("   					 WHERE A.prod_cd = G.prod_cd  				\n")
					.append("                        AND A.revision_no = G.revision_no) 		\n")
					.append("GROUP BY A.prod_cd 												\n")
					.append("ORDER BY A.prod_cd ASC, A.revision_no DESC							\n")
					.toString();  

			resultString = super.excuteQueryString(con, sql);
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M909S060100E106()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M909S060100E106()","==== finally ===="+ e.getMessage());
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
	
	
	// yumsam에 쓰이는건지 모르겠음 (2021 01 27 최현수)
	public int E107(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			System.out.println("JSONObject jArray rcvData="+ jArray.toString());
			
			String sql = new StringBuilder()
					.append("SELECT\n")
					.append("        D.code_name,\n")
					.append("        E.code_name,\n")
					.append("        A.prod_cd,\n")
					.append("        A.revision_no,\n")
					.append("        A.product_nm,\n")
					.append("        A.gugyuk,\n")
					.append("        option_cd,\n")
					.append("        A.start_date,\n")
					.append("        A.duration_date,\n")
					.append("        create_user_id,\n")
					.append("        create_date,\n")
					.append("        modify_user_id,\n")
					.append("        modify_reason,\n")
					.append("        modify_date\n")
					.append("FROM    tbm_product A\n")
					.append("	INNER JOIN v_prodgubun_big D\n")
					.append("   	ON A.prod_gubun_b = D.code_value\n")
					.append("   	AND A.member_key = D.member_key\n")
					.append("	INNER JOIN v_prodgubun_mid E\n")
					.append("		ON A.prod_gubun_m = E.code_value\n")
					.append("		AND A.member_key = E.member_key\n")
					.append("WHERE prod_gubun_b like '" + jArray.get("prodgubun_big") + "%' AND prod_gubun_m like '" + jArray.get("prodgubun_mid") + "%' \n")
					.append("	AND A.member_key = '" + jArray.get("member_key") + "' \n")
					.append("ORDER BY A.prod_cd        ASC, A.revision_no DESC\n")
					.toString();  

			resultString = super.excuteQueryString(con, sql.toString());
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M909S060100E107()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M909S060100E107()","==== finally ===="+ e.getMessage());
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
	
	// yumsam
	// 완제품 정보 수정 시 기초 데이터 가져오는 쿼리
	public int E114(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			
			String sql = new StringBuilder()
					.append("SELECT													\n")
					.append("	B.code_name,										\n")
					.append("	B.code_value,										\n")
					.append("	M.code_name,										\n")
					.append("	M.code_value,										\n")
					.append("	prod_cd,											\n")
					.append("	revision_no,										\n")
					.append("	prod_sub_cd,										\n")
					.append("	product_nm,											\n")
					.append("	gugyuk,												\n")
					.append("	count_in_pack,										\n")
					.append("	count_in_box,										\n")
					.append("	safe_stock,											\n")
					.append("	packing_cost,										\n")
					.append("	expiration_date,									\n")
					.append("	start_date											\n")
					.append("FROM tbm_product P										\n")
					.append("	INNER JOIN v_prodgubun_big B						\n")
					.append("	ON P.prod_gubun_b = B.code_value					\n")
					.append("	INNER JOIN v_prodgubun_mid M						\n")
					.append("	ON P.prod_gubun_m = M.code_value					\n")
					.append("WHERE prod_cd = '" + jArray.get("prod_cd") + "'		\n")
					.append("  AND revision_no = " + jArray.get("revision_no") + "	\n")
					.append("ORDER BY prod_cd ASC, revision_no DESC					\n")
					.toString();

			resultString = super.excuteQueryString(con, sql);
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M909S060100E114()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M909S060100E114()","==== finally ===="+ e.getMessage());
				}
	    	} else {
	    	}
	    }
		ioParam.setResultString(resultString);
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
    	ioParam.setMessage(MessageDefine.M_QUERY_OK);

    	return EventDefine.E_QUERY_RESULT;
	}
	
	
	// ChulgoProductView.jsp. 
	// yumsam used
	public int E174(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));

			String sql = new StringBuilder()
					.append("SELECT																		\n")
					.append("	B.code_name AS gubun_b,													\n")
					.append("	M.code_name AS gubun_m,													\n")
					.append("	product_nm,																\n")
					.append("   C.prod_date, 															\n")
					.append("   C.chulgo_date, 															\n")
					.append("   D.expiration_date,  													\n")
					.append("	P.prod_cd,																\n")
					.append("	P.revision_no,															\n")
					.append("   C.chulgo_seq_no,														\n")
					.append("   C.seq_no 																\n")
					.append("FROM vtbm_product P														\n")
					.append("INNER JOIN v_prodgubun_big B												\n")
					.append("	ON P.prod_gubun_b = B.code_value AND P.member_key = B.member_key		\n")
					.append("INNER JOIN v_prodgubun_mid M												\n")
					.append("	ON P.prod_gubun_m = M.code_value AND P.member_key = M.member_key		\n")
					.append("INNER JOIN tbi_prod_chulgo2 C 												\n")
					.append("   ON P.prod_cd = C.prod_cd 												\n")
					.append("   AND P.revision_no = C.prod_rev_no 										\n")
					.append("INNER JOIN tbi_prod_storage2 D 											\n")
					.append("   ON P.prod_cd = D.prod_cd 												\n")
					.append("   AND P.revision_no = D.prod_rev_no 										\n")
					.append("   AND C.prod_date= D.prod_date											\n")
					.append("WHERE																		\n")
					.append("	delyn != 'Y'															\n")
					.append("	AND prod_gubun_b like '" + jArray.get("prodgubun_big") + "%'			\n")
					.append("	AND prod_gubun_m like '" + jArray.get("prodgubun_mid") + "%'			\n")
					.append("	AND SYS_DATE BETWEEN start_date AND duration_date						\n")
					.append("	AND revision_no = (SELECT MAX(revision_no) 								\n")
					.append("					   FROM vtbm_product P2 								\n")
					.append("					   WHERE P.prod_cd = P2.prod_cd							\n")
					.append("						 AND P.revision_no = P2.revision_no)				\n")
					.append("   AND C.chulgo_amount > 0 												\n")
					.append("ORDER BY product_nm ASC;													\n")
					.toString();

			resultString = super.excuteQueryString(con, sql.toString());
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M909S060100E174()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M909S060100E174()","==== finally ===="+ e.getMessage());
				}
	    	} else {
	    	}
	    }
		ioParam.setResultString(resultString);
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
    	ioParam.setMessage(MessageDefine.M_QUERY_OK);
	    return EventDefine.E_QUERY_RESULT;
	}
	
	// ViewProductStorage.jsp. 
	// yumsam used
	public int E184(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			String sql = new StringBuilder()
					.append("SELECT												\n")
					.append("	B.product_nm,									\n")
					.append("	A.prod_cd,										\n")
					.append("	A.prod_rev_no,									\n")
					.append("	A.prod_date,									\n")
					.append("	A.seq_no,										\n")
					.append("	B.safe_stock,									\n")
					.append("	A.post_amt,										\n")
					.append("	A.expiration_date,								\n")
					.append("	A.note											\n")
					.append("FROM												\n")
					.append("	tbi_prod_storage2 A								\n")
					.append("INNER JOIN tbm_product B 							\n")
					.append("	ON A.prod_cd = B.prod_cd						\n")
					.append("	AND A.prod_rev_no = B.revision_no				\n")
					.append("	WHERE A.post_amt > 0							\n")
					.append("ORDER BY B.product_nm ASC, A.expiration_date desc	\n")
					.append(";													\n")
					.toString();

			resultString = super.excuteQueryString(con, sql);
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M909S060100E184()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M909S060100E184()","==== finally ===="+ e.getMessage());
				}
	    	} else {
	    	}
	    }
		ioParam.setResultString(resultString);
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
    	ioParam.setMessage(MessageDefine.M_QUERY_OK);
	    return EventDefine.E_QUERY_RESULT;
	}
	
	// ProductView.jsp. 
	// yumsam used
	public int E194(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));

			String sql = new StringBuilder()
					.append("SELECT																		\n")
					.append("	B.code_name AS gubun_b,													\n")
					.append("	M.code_name AS gubun_m,													\n")
					.append("	product_nm,																\n")
					.append("	P.prod_cd,																\n")
					.append("	P.revision_no,															\n")
					.append("	P.gugyuk,																\n")
					.append("	P.safe_stock,															\n")
					.append("	NVL(S.total_amount, 0) as total_amount									\n")
					.append("FROM vtbm_product P														\n")
					.append("INNER JOIN v_prodgubun_big B												\n")
					.append("	ON P.prod_gubun_b = B.code_value AND P.member_key = B.member_key		\n")
					.append("INNER JOIN v_prodgubun_mid M												\n")
					.append("	ON P.prod_gubun_m = M.code_value AND P.member_key = M.member_key		\n")
					.append("LEFT JOIN v_prod_storage_sum S												\n")
					.append("	ON P.prod_cd = S.prod_cd												\n")
					.append("	AND P.revision_no = S.prod_rev_no										\n")
					.append("WHERE																		\n")
					.append("	delyn != 'Y'															\n")
					.append("	AND prod_gubun_b like '" + jArray.get("prodgubun_big") + "%'			\n")
					.append("	AND prod_gubun_m like '" + jArray.get("prodgubun_mid") + "%'			\n")
					.append("	AND SYS_DATE BETWEEN start_date AND duration_date						\n")
					.append("	AND revision_no = (SELECT MAX(revision_no) 								\n")
					.append("					   FROM vtbm_product P2 								\n")
					.append("					   WHERE P.prod_cd = P2.prod_cd							\n")
					.append("						 AND P.revision_no = P2.revision_no)				\n")
					.append("ORDER BY product_nm ASC;													\n")
					.toString();

			resultString = super.excuteQueryString(con, sql.toString());
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M909S060100E194()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M909S060100E194()","==== finally ===="+ e.getMessage());
				}
	    	} else {
	    	}
	    }
		ioParam.setResultString(resultString);
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
    	ioParam.setMessage(MessageDefine.M_QUERY_OK);
	    return EventDefine.E_QUERY_RESULT;
	}
	
	// ProdChulhaList.jsp.
	// yumsam used
	public int E214(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			String sql = new StringBuilder()
					.append("SELECT				\n")
					.append("A.chulha_no,		\n")
					.append("A.chulha_rev_no,	\n")
					.append("A.chulha_date,		\n")
					.append("C.cust_nm,			\n")
					.append("A.order_no,		\n")
					.append("A.order_rev_no,	\n")
					.append("A.note				\n")
					.append("FROM				\n")
					.append("tbi_chulha A		\n")
					.append("INNER JOIN tbi_order2 B 			 \n")
					.append("ON A.order_no = B.order_no 		 \n")
					.append("AND A.order_rev_no = B.order_rev_no \n")
					.append("INNER JOIN tbm_customer C			 \n")
					.append("ON B.cust_cd = C.cust_cd 			 \n")
					.append("AND B.cust_rev_no = C.revision_no   \n")
					.append("WHERE A.delyn = 'N'				 \n")
					.toString();
					

			resultString = super.excuteQueryString(con, sql);
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M909S060100E214()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M909S060100E214()","==== finally ===="+ e.getMessage());
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
			
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			System.out.println("JSONObject jArray rcvData="+ jArray.toString());
			
			String sql = new StringBuilder()
					.append("SELECT														\n")					
					.append("	prod_cd,												\n")					
					.append("	product_nm,												\n")					
					.append("	gugyuk,													\n")					
					.append("	revision_no,											\n")					
					.append("	start_date,												\n")
					.append("	member_key												\n")
					.append("FROM tbm_product											\n")
					.append("WHERE prod_cd = '" + jArray.get("PROD_CD") + "'			\n")
					.append("	AND revision_no = '" + jArray.get("REVISION_NO") + "'	\n")
					.append("	AND member_key = '" + jArray.get("member_key") + "'		\n")
					.append("ORDER BY prod_cd ASC, revision_no DESC						\n")
					.toString();  

			resultString = super.excuteQueryString(con, sql.toString());
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M909S060100E204()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M909S060100E204()","==== finally ===="+ e.getMessage());
				}
	    	}
	    }
		
		ioParam.setResultString(resultString);
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
    	ioParam.setMessage(MessageDefine.M_QUERY_OK);

    	return EventDefine.E_QUERY_RESULT;
	}
	
	public int E205(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			
			String sql = new StringBuilder()
					.append("SELECT																			\n")					
					.append("	prod_cd,																	\n")					
					.append("	product_nm,																	\n")					
					.append("	gugyuk,																		\n")					
					.append("	revision_no,																\n")					
					.append("	start_date,																	\n")
					.append("	member_key																	\n")
					.append("FROM tbm_product																\n")
					.append("WHERE prod_cd = '" 	+ jArray.get("PROD_CD") + "'							\n")
					.append("	AND revision_no = '" 	+ jArray.get("REVISION_NO") + "'					\n")
					.append("	AND member_key = '" + jArray.get("member_key") + "'							\n")					
					.append("ORDER BY prod_cd ASC, revision_no DESC											\n")
					
					.toString();  

			resultString = super.excuteQueryString(con, sql.toString());
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M909S060100E204()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M909S060100E204()","==== finally ===="+ e.getMessage());
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
	
	public int E994(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			System.out.println("JSONObject jArray rcvData="+ jArray.toString());
			
			String sql = new StringBuilder()
					.append("SELECT		code_value, code_name							\n")
					.append("FROM		tbm_product_code_book							\n")
					.append("WHERE		member_key = '" + jArray.get("member_key") + "'	\n") //member_key_select, update, delete
					.append("AND		code_value LIKE '__'							\n")
					.append("ORDER BY	code_value ASC									\n")
					.toString();

			resultString = super.excuteQueryString(con, sql.toString());
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M909S060100E994()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M909S060100E994()","==== finally ===="+ e.getMessage());
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
	
	public int E995(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			System.out.println("JSONObject jArray rcvData="+ jArray.toString());
			
			String sql = new StringBuilder()
					.append("SELECT		code_value, code_name							\n")
					.append("FROM		tbm_product_code_book							\n")
					.append("WHERE		member_key = '" + jArray.get("member_key") + "'	\n") //member_key_select, update, delete
					.append("AND		code_value LIKE '____'							\n")
//					.append("AND		code_value NOT LIKE '0000'						\n")
					.append("ORDER BY	code_value ASC									\n")
					.toString();

			resultString = super.excuteQueryString(con, sql.toString());
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M909S060100E995()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M909S060100E995()","==== finally ===="+ e.getMessage());
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
	
	public int E996(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			
			String sql = new StringBuilder()
					.append("SELECT														\n")
					.append("	TO_CHAR(NVL(MAX(code_value),0)+1,'00') AS NewCodeNumber	\n")
					.append("FROM														\n")
					.append("	tbm_code_book											\n")
					.append("WHERE														\n")
					.append("	code_cd = 'PRODB'										\n")
					.append("	AND member_key = '" + jArray.get("member_key") + "'		\n")
					.toString();

			resultString = super.excuteQueryString(con, sql.toString());
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M909S060100E996()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M909S060100E996()","==== finally ===="+ e.getMessage());
				}
	    	} else {
	    	}
	    }
		ioParam.setResultString(resultString);
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
    	ioParam.setMessage(MessageDefine.M_QUERY_OK);
	    return EventDefine.E_QUERY_RESULT;
	}
	
	public int E997(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			
			String sql = new StringBuilder()
					.append("SELECT																											\n")
					.append("	'" + jArray.get("Big_Gubun") + "' || SUBSTR(TO_CHAR(NVL(MAX(code_value),0)+1,'0000'),3,2) AS NewCodeNumber	\n")
					.append("FROM																											\n")
					.append("	tbm_code_book																								\n")
					.append("WHERE																											\n")
					.append("	code_cd = 'PRODM'																							\n")
					.append("	AND code_value LIKE '" + jArray.get("Big_Gubun") + "' || '__'												\n")
					.append("	AND member_key = '" + jArray.get("member_key") + "'															\n") //member_key_select, update, delete
					.toString();

			resultString = super.excuteQueryString(con, sql.toString());
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M909S060100E997()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M909S060100E997()","==== finally ===="+ e.getMessage());
				}
	    	} else {
	    	}
	    }
		ioParam.setResultString(resultString);
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
    	ioParam.setMessage(MessageDefine.M_QUERY_OK);
	    return EventDefine.E_QUERY_RESULT;
	}
	
	public int E998(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			
			String sql = new StringBuilder()
					.append("SELECT																\n")
					.append("	code_value														\n")
					.append("FROM																\n")
					.append("	tbm_code_book													\n")
					.append("WHERE																\n")
					.append("	code_value LIKE '" + jArray.get("Big_Gubun") + "' || '__'		\n")
					.append("	AND member_key = '" + jArray.get("member_key") + "'				\n") //member_key_select, update, delete
					.toString();

			resultString = super.excuteQueryString(con, sql.toString());
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M909S060100E998()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M909S060100E998()","==== finally ===="+ e.getMessage());
				}
	    	} else {
	    	}
	    }
		ioParam.setResultString(resultString);
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
    	ioParam.setMessage(MessageDefine.M_QUERY_OK);
	    return EventDefine.E_QUERY_RESULT;
	}
	
	public int E999(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			
			String sql = new StringBuilder()
					.append("SELECT																	\n")
					.append("	TO_CHAR(NVL(MAX(SUBSTR(prod_cd,6,4)),0)+1,'0000') AS NewCodeNumber	\n")
					.append("FROM																	\n")
					.append("	tbm_product															\n")
					.append("WHERE																	\n")
					.append("	prod_cd LIKE '" + jArray.get("Mid_Gubun") + "' || '-' || '____'		\n")
					.append("	AND member_key = '" + jArray.get("member_key") + "'					\n") //member_key_select, update, delete
					.toString();

			resultString = super.excuteQueryString(con, sql.toString());
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M909S060100E999()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M909S060100E999()","==== finally ===="+ e.getMessage());
				}
	    	} else {
	    	}
	    }
		ioParam.setResultString(resultString);
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
    	ioParam.setMessage(MessageDefine.M_QUERY_OK);
	    return EventDefine.E_QUERY_RESULT;
	}
	
	public int E1001(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));

			String sql = new StringBuilder()
					.append("INSERT INTO tbm_code_book					\n")
					.append("(											\n")
					.append("	code_cd,								\n")
					.append("	code_value,								\n")
					.append("	code_name,								\n")
					.append("	order_index,							\n")
					.append("	bigo,									\n")
					.append("	start_date,								\n")
					.append("	create_user_id,							\n")
					.append("	member_key								\n")
					.append(")											\n")
					.append("VALUES										\n")
					.append("(											\n")
					.append("	'" + jArray.get("code_cd") + "',		\n")
					.append("	'" + jArray.get("code_value") + "',		\n")
					.append("	'" + jArray.get("code_name") + "',		\n")
					.append("	'" + jArray.get("order_index") + "',	\n")
					.append("	'',										\n")
					.append("	SYSDATE,								\n")
					.append("	'" + jArray.get("create_user_id") + "',	\n")
					.append("	'" + jArray.get("member_key") + "'		\n")
					.append(")											\n")
					.toString();

			resultInt = super.excuteUpdate(con, sql.toString());
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M909S060100E1001()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M909S060100E1001()","==== finally ===="+ e.getMessage());
				}
	    	} else {
	    	}
	    }
		ioParam.setResultString(resultString);
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
    	ioParam.setMessage(MessageDefine.M_QUERY_OK);
	    return EventDefine.E_QUERY_RESULT;
	}
	
	public int E1002(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			
			String sql = new StringBuilder()
					.append("SELECT																\n")
					.append("	prod_cd															\n")
					.append("FROM																\n")
					.append("	tbm_product														\n")
					.append("WHERE																\n")
					.append("	prod_gubun_b = '" + jArray.get("Big_Gubun") + "'				\n")
					.append("	AND prod_gubun_m = '" + jArray.get("Mid_Gubun") + "'			\n")
					.append("	AND member_key = '" + jArray.get("member_key") + "'				\n") //member_key_select, update, delete
					.toString();

			resultString = super.excuteQueryString(con, sql.toString());
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M909S060100E1002()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M909S060100E1002()","==== finally ===="+ e.getMessage());
				}
	    	} else {
	    	}
	    }
		ioParam.setResultString(resultString);
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
    	ioParam.setMessage(MessageDefine.M_QUERY_OK);
	    return EventDefine.E_QUERY_RESULT;
	}
	
}