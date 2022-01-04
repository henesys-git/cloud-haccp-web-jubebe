package mes.frame.business.M909;

import java.lang.reflect.Method;
import java.sql.Connection;
import java.sql.PreparedStatement;

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


/**
 * 개요 : 이벤트ID별 메소드 정의
 */
public  class M909S010100 extends SqlAdapter{
	Connection con = null;
	PreparedStatement pstmt = null;
	String resultString = "";
	int resultInt = -1;
	StringBuffer sql = new StringBuffer();
	
	String[][] v_paramArray = new String[0][0]; 
	Class[] optClass = null;
	Object[] optObj = null;
	Object obj = null;
	
	public M909S010100(){
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
			
			Method method = M909S010100.class.getMethod(event,optClass);
			LoggingWriter.setLogDebug(M909S010100.class.getName(),"==== " + event + " EventMethod Create Success ====");

			obj = method.invoke(M909S010100.class.newInstance(),optObj);
			doExcute_result = CommonFunction.getInt(obj.toString());
			
	    } catch (Exception ex) {
	    	doExcute_result = EventDefine.E_DOEXCUTE_INIT;
			ioParam.setMessage(MessageDefine.M_NO_EVENTID);
			LoggingWriter.setLogError(M909S010100.class.getName(),"==== EventID Not define : EVENT ID [ " + ioParam.getEventID() + "]");
	    } finally {
	    	obj = null;
			optClass = null;
			optObj = null;
	    }
	    long endTime = System.currentTimeMillis();
		long runningTime = endTime - startTime;
		LoggingWriter.setLogAll(M909S010100.class.getName(),"==== Query [수행시간  : " + runningTime + " ms]");
		
		return doExcute_result;
	}
	
	//배합정보 등록
	public int E001(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		int i = 0;
		String sql = "";
		
		try {
			con = JDBCConnectionPool.getConnection();
			con.setAutoCommit(false);
			
			JSONObject jObject = new JSONObject();
    		jObject = (JSONObject) ioParam.getInputHashObject().get("rcvData", HashObject.YES);
    		
    		// 테이블 데이터 배열
			JSONArray tData1 = (JSONArray) jObject.get("tData1"); // 배합비율
			
			// 테이블 안의 데이터 Row
			JSONObject tData1Row;
			
			for(i = 0; i < tData1.size(); i++) {
				tData1Row = (JSONObject) tData1.get(i);
				
				sql = new StringBuilder()
						.append("INSERT INTO							\n")
						.append("	tbm_bom_info2 					(	\n")
						.append("		prod_cd,						\n")
						.append("		prod_rev_no,					\n")
						.append("		part_cd,						\n")
						.append("		part_rev_no,					\n")
						.append("		blending_ratio,					\n")
						.append("       start_date,						\n")
						.append("    	duration_date 					\n")
						.append("	)									\n")
						.append("VALUES									\n")
						.append("	(									\n")
						.append("		'" + tData1Row.get("col4") + "',\n")
						.append("		'" + tData1Row.get("col5") + "',\n")
						.append("		'" + tData1Row.get("col1") + "',\n")
						.append("		'" + tData1Row.get("col2") + "',\n")
						.append("		'" + tData1Row.get("col6") + "',\n")
						.append(" 			SYSDATE,					\n")
						.append(" 		'9999-12-31'					\n")
						.append("	);									\n")
						.toString();

				resultInt = super.excuteUpdate(con, sql);
				if (resultInt < 0) {
					ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
					con.rollback();
					return EventDefine.E_DOEXCUTE_ERROR;
				} 
			}
			con.commit();
		} catch(Exception e) {
			LoggingWriter.setLogError("M909S010100.E001()","==== SQL ERROR ===="+ 
									  e.getMessage() + "\n" + sql);
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
			try {
				if (con != null) con.close();
			} catch (Exception e) {
			}
	    }
		ioParam.setResultString(resultString);
	    return EventDefine.E_QUERY_RESULT;
	}
	
	//배합정보 수정
	public int E002(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		int i = 0;
		String sql = "";
		
		try {
			con = JDBCConnectionPool.getConnection();
			con.setAutoCommit(false);
			
			JSONObject jObject = new JSONObject();
    		jObject = (JSONObject) ioParam.getInputHashObject().get("rcvData", HashObject.YES);
    		
    		// 테이블 데이터 배열
			JSONArray tData1 = (JSONArray) jObject.get("tData1"); // 배합비율
			
			// 테이블 안의 데이터 Row
			JSONObject tData1Row;
			
			for(i = 0; i < tData1.size(); i++) {
				tData1Row = (JSONObject) tData1.get(i);
				
				sql = new StringBuilder()
						.append("INSERT INTO							\n")
						.append("	tbm_bom_info2 					(	\n")
						.append("		prod_cd,						\n")
						.append("		prod_rev_no,					\n")
						.append("		part_cd,						\n")
						.append("		part_rev_no,					\n")
						.append("		blending_ratio,					\n")
						.append("       start_date,						\n")
						.append("    	duration_date, 					\n")
						.append("  		bom_rev_no						\n")
						.append("	)									\n")
						.append("VALUES									\n")
						.append("	(									\n")
						.append("		'" + tData1Row.get("col3") + "',\n")
						.append("		'" + tData1Row.get("col4") + "',\n")
						.append("		'" + tData1Row.get("col1") + "',\n")
						.append("		'" + tData1Row.get("col2") + "',\n")
						.append("		'" + tData1Row.get("col6") + "',\n")
						.append(" 			SYSDATE,					\n")
						.append(" 		'9999-12-31',					\n")
						.append("	'" + tData1Row.get("col5") + "'+1	\n")
						.append("	);									\n")
						.toString();

				resultInt = super.excuteUpdate(con, sql);
				if (resultInt < 0) {
					ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
					con.rollback();
					return EventDefine.E_DOEXCUTE_ERROR;
				} 
			}
			con.commit();
		} catch(Exception e) {
			LoggingWriter.setLogError("M909S010100.E002()","==== SQL ERROR ===="+ 
									  e.getMessage() + "\n" + sql);
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
			try {
				if (con != null) con.close();
			} catch (Exception e) {
			}
	    }
		ioParam.setResultString(resultString);
	    return EventDefine.E_QUERY_RESULT;
	}
	/*
	//배합정보 삭제 - old
	public int E003(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		int i = 0;
		String sql = "";
		
		try {
			con = JDBCConnectionPool.getConnection();
			con.setAutoCommit(false);
			
			JSONObject jObject = new JSONObject();
    		jObject = (JSONObject) ioParam.getInputHashObject().get("rcvData", HashObject.YES);
    		
    		// 테이블 데이터 배열
			JSONArray tData1 = (JSONArray) jObject.get("tData1"); // 배합비율
			
			// 테이블 안의 데이터 Row
			JSONObject tData1Row;
			
			for(i = 0; i < tData1.size(); i++) {
				tData1Row = (JSONObject) tData1.get(i);
				
				sql = new StringBuilder()
						.append("UPDATE 											   \n")
						.append("	tbm_bom_info2 SET 								   \n")
						.append("		delyn = 'Y'									   \n")
						.append(" WHERE part_cd	=	'" + tData1Row.get("col1") + 	 "'\n")
						.append(" AND bom_rev_no	=	'" + tData1Row.get("col5") + "'\n")
						.append("	;												   \n")
						.toString();

				resultInt = super.excuteUpdate(con, sql);
				if (resultInt < 0) {
					ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
					con.rollback();
					return EventDefine.E_DOEXCUTE_ERROR;
				} 
			}
			con.commit();
		} catch(Exception e) {
			LoggingWriter.setLogError("M909S010100.E003()","==== SQL ERROR ===="+ 
									  e.getMessage() + "\n" + sql);
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
			try {
				if (con != null) con.close();
			} catch (Exception e) {
			}
	    }
		ioParam.setResultString(resultString);
	    return EventDefine.E_QUERY_RESULT;
	}
	*/
	
	//배합정보 삭제
		public int E003(InoutParameter ioParam){
			resultInt = EventDefine.E_DOEXCUTE_INIT;
			String sql = "";
			
			try {
				con = JDBCConnectionPool.getConnection();
				con.setAutoCommit(false);
				
				JSONObject jObject = new JSONObject();
	    		jObject = (JSONObject) ioParam.getInputHashObject().get("rcvData", HashObject.YES);
					
					sql = new StringBuilder()
							.append("DELETE FROM										   		  \n")
							.append("	tbm_bom_info2 								   	   		  \n")
							.append(" WHERE prod_cd	=	'" + jObject.get("prod_cd") + 	 "'	   	  \n")
							.append("	;												   		  \n")
							.toString();

					resultInt = super.excuteUpdate(con, sql);
					if (resultInt < 0) {
						ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
						con.rollback();
						return EventDefine.E_DOEXCUTE_ERROR;
					} 
				con.commit();
			} catch(Exception e) {
				LoggingWriter.setLogError("M909S010100E003()","==== SQL ERROR ===="+ 
										  e.getMessage() + "\n" + sql);
				return EventDefine.E_DOEXCUTE_ERROR ;
		    } finally {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
				}
		    }
			ioParam.setResultString(resultString);
		    return EventDefine.E_QUERY_RESULT;
		}
/*	
	//배합정보 수정삭제 목록 불러오기 -old
	public int E004(InoutParameter ioParam){
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
					.append("	A.part_cd,			\n")
					.append("	B.part_nm,			\n")
					.append("   A.prod_cd,          \n")
					.append("   C.product_nm,		\n")
					.append("	part_rev_no,		\n")	
					.append("	bom_rev_no,			\n")
					.append("	TO_CHAR(blending_ratio),		\n")
					.append("	A.start_date,		\n")
					.append("	A.duration_date,	\n")
					.append("	A.delyn,			\n")
					.append("	A.prod_rev_no		\n")
					.append("FROM tbm_bom_info2 A	\n")
					.append("INNER JOIN tbm_part_list B						    \n")
					.append("	ON A.part_cd=B.part_cd							\n")
					.append("	AND A.part_rev_no=B.revision_no					\n")
					.append("INNER JOIN tbm_product C 							\n")
					.append("	ON A.prod_cd = C.prod_cd						\n")
					.append("WHERE bom_rev_no = (SELECT MAX(bom_rev_no) "
							   + "FROM tbm_bom_info2 D "
							   + "WHERE D.prod_cd = A.prod_cd "
							   + "AND D.prod_rev_no = A.prod_rev_no "
							   + "AND D.part_cd = A.part_cd "
							   + "AND D.part_rev_no = A.part_rev_no)		   \n")
					.append("AND	A.delyn = 'N' 						   	   \n")
					.append("AND C.product_nm = '" + jArray.get("prod_nm") +"' \n")
					.append("GROUP BY A.part_cd								   \n")
					.append("ORDER BY A.part_cd								   \n")
					.toString(); 
			
			resultString = super.excuteQueryString(con, sql.toString());
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M909S010100E004()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M909S010100E004()","==== finally ===="+ e.getMessage());
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
*/
		
	//배합정보 수정 페이지 데이터 불러오기
		public int E004(InoutParameter ioParam){
			resultInt = EventDefine.E_DOEXCUTE_INIT;
			
			try {
				con = JDBCConnectionPool.getConnection();
				
				JSONObject jArray = new JSONObject();
				jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
				System.out.println("JSONObject jArray rcvData="+ jArray.toString());
				
				String sql = new StringBuilder()
						.append("SELECT \n")
						.append("	B.part_nm,			\n")
						.append("	A.part_cd,			\n")
						.append("	A.part_rev_no,		\n")	
						.append("   A.prod_cd,          \n")
						.append("	A.prod_rev_no,		\n")
						.append("	A.bom_rev_no,		\n")
						.append("	TO_CHAR(blending_ratio)	\n")
						.append("FROM tbm_bom_info2 A	\n")
						.append("INNER JOIN tbm_part_list B						    \n")
						.append("	ON A.part_cd=B.part_cd							\n")
						.append("	AND A.part_rev_no=B.revision_no					\n")
						.append("WHERE bom_rev_no = (SELECT MAX(bom_rev_no) 		\n")
						.append("                    FROM tbm_bom_info2 D          	\n")
						.append("					 WHERE D.prod_cd = A.prod_cd) 	\n")
						.append("AND	A.delyn = 'N' 						   	   	\n")
						.append("AND A.prod_cd = '" + jArray.get("prod_cd") +"'		\n")
						.append("AND A.prod_rev_no = (SELECT MAX(prod_rev_no)   	\n")
						.append("					 FROM tbm_bom_info2 E   	   	\n")
						.append("					 WHERE A.prod_cd = E.prod_cd)  	\n")
						.append("GROUP BY A.part_cd								   	\n")
						.append("ORDER BY A.part_cd								   	\n")
						.toString(); 
				
				resultString = super.excuteQueryString(con, sql.toString());
			} catch(Exception e) {
				e.printStackTrace();
				LoggingWriter.setLogError("M909S010100E004()","==== SQL ERROR ===="+ e.getMessage());
				return EventDefine.E_DOEXCUTE_ERROR ;
		    } finally {
		    	if (Config.useDataSource) {
					try {
						if (con != null) con.close();
					} catch (Exception e) {
						LoggingWriter.setLogError("M909S010100E004()","==== finally ===="+ e.getMessage());
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
			
			sql = new StringBuffer();
			sql.append("INSERT INTO tbm_bom_code ( 	\n");
			sql.append("	bom_cd,				\n"); 
			sql.append("	revision_no,		\n"); 
			sql.append("	bom_nm,				\n"); 
			sql.append("	bigo,				\n"); 
			sql.append("	parent_code,		\n"); 
			sql.append("	start_date,			\n");
			sql.append("	duration_date,		\n");
			sql.append("	create_user_id,		\n");
			sql.append("	create_date,		\n");
			sql.append("	modify_user_id,		\n");
			sql.append("	modify_reason,		\n");
			sql.append("	modify_date,		\n");
			sql.append("	member_key	)		\n"); // sql.member_key_insert
			sql.append("VALUES ( \n");
			sql.append("	'" + jArray.get("BomCode") 		+ "', 	\n"); //bom_cd
			sql.append("	'" + jArray.get("RevisionNo") 	+ "', 	\n"); //revision_no
			sql.append("	'" + jArray.get("BomName") 		+ "', 	\n"); //bom_nm
			sql.append("	'" + jArray.get("Bigo") 		+ "', 	\n"); //bigo
			sql.append("	'" + jArray.get("ParentCode") 	+ "', 	\n"); //parent_code
			sql.append("	'" + jArray.get("StartDate") 	+ "',	\n"); //start_date
			sql.append("	'9999-12-31',							\n"); //duration_date
			sql.append("	'" + jArray.get("user_id") 		+ "',	\n"); //create_user_id
			sql.append("	SYSDATETIME,							\n"); //create_date
			sql.append("	'" + jArray.get("user_id") 		+ "',	\n"); //modify_user_id
			sql.append("	'최초등록',								\n"); //modify_reason
			sql.append("	SYSDATETIME,							\n"); //modify_date
			sql.append("	'" + jArray.get("member_key") 	+ "' 	\n"); //sql.member_key_values
			sql.append("	)										\n");

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
			LoggingWriter.setLogError("M909S010100E101()","==== SQL ERROR ===="+ e.getMessage() + "\n" + sql.toString());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M909S010100E101()","==== finally ===="+ e.getMessage());
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
					.append("UPDATE tbm_bom_code SET	\n")
					.append(" duration_date = to_char(TO_DATE('" + jArray.get("StartDate") + "', 'YYYY-MM-DD')-1 , 'YYYY-MM-DD')	\n")
					.append(" 	,member_key = 	'" + jArray.get("member_key") + "'		\n")
					.append("WHERE bom_cd = '" + jArray.get("BomCode") + "'\n")
					// 13번째는 이전의 리비전코드가 들어온다.
					.append("	AND revision_no = '" + jArray.get("RevisionNo_Target") + "'\n")
					.append(" 	AND member_key = '" + jArray.get("member_key") + "' \n") // sql.member_key_select, update, delete
					.toString();
			
			
			resultInt = super.excuteUpdate(con, sqlPre.toString());
			if (resultInt < 0) {
				con.rollback();
				ioParam.setMessage(MessageDefine.M_UPDATE_FAILED);
				return resultInt;
			} else {
				ioParam.setMessage(resultInt + "건 " + MessageDefine.M_UPDATE_RESULT);
			}

			sql = new StringBuffer();
			sql.append("INSERT INTO tbm_bom_code ( 	\n");
			sql.append("	bom_cd				\n"); 
			sql.append("	,revision_no		\n"); 
			sql.append("	,bom_nm				\n"); 
			sql.append("	,bigo				\n"); 
			sql.append("	,parent_code		\n"); 
			sql.append("	,start_date			\n");
			sql.append("	,duration_date		\n");
			sql.append("	,create_user_id		\n");
			sql.append("	,create_date		\n");
			sql.append("	,modify_user_id		\n");
			sql.append("	,modify_reason		\n");
			sql.append("	,modify_date		\n");
			sql.append("	,member_key			\n"); // member_key_insert
			sql.append(" 	) values ( 			\n");
			sql.append("	'" + jArray.get("BomCode") 		+ "',	\n"); 	//bom_cd
			sql.append("	'" + jArray.get("RevisionNo") 	+ "',	\n"); 	//revision_no
			sql.append("	'" + jArray.get("BomName") 		+ "',	\n");	//bom_nm
			sql.append("	'" + jArray.get("Bigo") 		+ "', 	\n");	//bigo
			sql.append("	'" + jArray.get("ParentCode") 	+ "', 	\n");	//parent_code
			sql.append("	'" + jArray.get("StartDate") 	+ "',	\n"); 	//start_date
			sql.append("	'9999-12-31',							\n"); 	//duration_date
			sql.append("	'" + jArray.get("user_id") 		+ "',	\n"); 	//create_user_id
			sql.append("	SYSDATETIME,							\n"); 	//create_date
			sql.append("	'" + jArray.get("user_id") 		+ "',	\n"); 	//modify_user_id
			sql.append("	'최초등록', 								\n");	//modify_reason
			sql.append("	SYSDATETIME,							\n"); 			//modify_date
			sql.append("	'" + jArray.get("member_key") 	+ "' 	\n"); // member_key_values
			sql.append("	)										\n");
			

			// super의 excuteUpdate는 3가지가 있다.
			// 첫째는 super.excuteUpdate(con, sql.toString(), v_paramArray)형태 이며,
			// PreparedStatement를 사용하기 위해 파라미터들을 배열에 담아 보내면 체크를 해서 수행하는 구조이다. 그리고
			// 두번째는 super.excuteUpdate(con, Vector)인데, 멀티 로우를 등록하기 위해 마련된 장치이다.
			// 세번째는 하나의 SQL을 String으로 받아서 처리하는 경우이다.
			// 현재 위의 SQL형태라면.. 당연히 1개의 로우에 해당되므로 세번째 메쏘드를 사용하는 것이 편하다.
			resultInt = super.excuteUpdate(con, sql.toString());
			if (resultInt < 0) {
				con.rollback();
				ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
				return resultInt;
			} else {
				ioParam.setMessage(resultInt + "건 " + MessageDefine.M_INSERT_RESULT);
			}
			
			con.commit();
		} catch(Exception e) {
			LoggingWriter.setLogError("M909S010100E102()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M909S010100E102()","==== finally ===="+ e.getMessage());
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
			
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			System.out.println("JSONObject jArray rcvData="+ jArray.toString());
			
			// 클라이언트로 부터 받은 파라미터를 옮겨 담는다.
//			String rcvData = (String)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			
			// 클라이언트로 부터 받은 파라미터를 쪼개어서 배열에 담는다.
//			String[][] c_paramArray = CommonFunction.getConvString2DoubleArray(rcvData);

			sql = new StringBuffer();
			sql.append("DELETE FROM tbm_bom_code \n");
			sql.append("WHERE bom_cd = '" + jArray.get("BomCode") + "' \n");
			sql.append("AND member_key = '" + jArray.get("member_key") + "' \n"); // sql.member_key_select, update, delete
//			sql.append("AND revision_no = '" + jArray.get("RevisionNo") + "' \n");

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
			LoggingWriter.setLogError("M909S010100E103()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M909S010100E103()","==== finally ===="+ e.getMessage());
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
			
			// 클라이언트로 부터 받은 파라미터를 옮겨 담는다.
//			String rcvData = (String)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			// 클라이언트로 부터 받은 파라미터를 쪼개어서 배열에 담는다.
			// rcvData = [위경도]
//			String[][] c_paramArray = CommonFunction.getConvString2DoubleArray(rcvData);

			sql = new StringBuffer();
			sql.append("SELECT \n"); 
			sql.append("	bom_cd,			\n"); 
			sql.append("	revision_no,	\n"); 
			sql.append("	bom_nm,			\n"); 
			sql.append("	bigo,			\n"); 
			sql.append("	parent_code,	\n"); 
			sql.append("	start_date,		\n");
			sql.append("	duration_date,	\n");
			sql.append("	create_user_id,	\n");
			sql.append("	create_date,	\n");
			sql.append("	modify_user_id,	\n");
			sql.append("	modify_reason,	\n");
			sql.append("	modify_date		\n");
			sql.append("FROM tbm_bom_code 	\n"); 
//			sql.append("WHERE bom_cd LIKE '%" + jArray.get("") + "%' 	\n"); 
			sql.append("WHERE bom_cd LIKE '%%' 	\n"); 
			sql.append("AND member_key = '" + jArray.get("member_key") + "' \n"); // sql.member_key_select, update, delete
			sql.append("ORDER BY bom_cd ASC, revision_no DESC 			\n");

			resultString = super.excuteQueryString(con, sql.toString());
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M909S010100E104()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M909S010100E104()","==== finally ===="+ e.getMessage());
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
			
			// 클라이언트로 부터 받은 파라미터를 옮겨 담는다.
//			String rcvData = (String)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			// 클라이언트로 부터 받은 파라미터를 쪼개어서 배열에 담는다.
			// rcvData = [위경도]
//			String[][] c_paramArray = CommonFunction.getConvString2DoubleArray(rcvData);

			sql = new StringBuffer();
			sql.append("SELECT \n"); 
			sql.append("	bom_cd,			\n"); 
			sql.append("	revision_no,	\n"); 
			sql.append("	bom_nm,			\n"); 
			sql.append("	bigo,			\n"); 
			sql.append("	parent_code,	\n"); 
			sql.append("	start_date,		\n");
			sql.append("	duration_date,	\n");
			sql.append("	create_user_id,	\n");
			sql.append("	create_date,	\n");
			sql.append("	modify_user_id,	\n");
			sql.append("	modify_reason,	\n");
			sql.append("	modify_date		\n");
			sql.append("FROM tbm_bom_code 	\n"); 
//			sql.append("WHERE  bom_cd LIKE '%" + jArray.get("") + "%' 	\n"); 
			sql.append("WHERE  bom_cd LIKE '%%' 	\n"); 
			sql.append("AND TO_CHAR(SYSDATE,'YYYY-MM-DD') BETWEEN  start_date AND duration_date\n");
			sql.append("AND member_key = '" + jArray.get("member_key") + "' \n"); // sql.member_key_select, update, delete
			sql.append("ORDER BY bom_cd ASC, revision_no DESC 			\n");

			resultString = super.excuteQueryString(con, sql.toString());
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M909S010100E105()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M909S010100E105()","==== finally ===="+ e.getMessage());
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

	public int E106(InoutParameter ioParam) {
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

			sql = new StringBuffer();
			sql.append("SELECT \n"); 
			sql.append("	bom_cd,				\n"); 
			sql.append("	revision_no,		\n"); 
			sql.append("	bom_nm,				\n"); 
			sql.append("	bigo,				\n"); 
			sql.append("	parent_code,		\n"); 
			sql.append("	start_date,			\n");
			sql.append("	duration_date,		\n");
			sql.append("	create_user_id,		\n");
			sql.append("	create_date,		\n");
			sql.append("	modify_user_id,		\n");
			sql.append("	modify_reason,		\n");
			sql.append("	modify_date			\n");
			sql.append("FROM tbm_bom_code 		\n"); 
			sql.append("WHERE bom_cd = '" + jArray.get("BOM_CD") + "'	\n"); 
			sql.append(" 	AND revision_no = '" + jArray.get("REVISION_NO") + "' 	\n"); 
			sql.append(" 	AND member_key = '" + jArray.get("member_key") + "' \n"); // sql.member_key_select, update, delete

			resultString = super.excuteQueryString(con, sql.toString());
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M909S010100E106()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M909S010100E106()","==== finally ===="+ e.getMessage());
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
	
	public int E201(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			// 클라이언트로 부터 받은 파라미터를 옮겨 담는다.
			String rcvData = (String)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			
			// 클라이언트로 부터 받은 파라미터를 쪼개어서 배열에 담는다.
			String[][] c_paramArray = CommonFunction.getConvString2DoubleArray(rcvData);
			
			sql = new StringBuffer();
			sql.append("INSERT INTO tbm_bom_info ( 		\n");
			sql.append("	sys_bom_id,			\n"); 
			sql.append("	bom_nm,			\n"); 
			sql.append("	part_count,			\n"); 
			sql.append("	maesu,				\n"); 
			sql.append("	gumae_cheo,			\n"); 
			sql.append("	bigo,				\n"); 
			sql.append("	bom_cd,				\n"); 
			sql.append("	bom_cd_rev,			\n"); 
			sql.append("	sys_bom_parentid,	\n"); 
			sql.append("	part_cd,			\n"); 
			sql.append("	part_cd_rev,		\n"); 
			sql.append("	level_gubun,		\n"); 
			sql.append("	modify_hist,		\n"); 
			sql.append("	member_key			\n"); // sql.member_key_insert
			sql.append(") values ( 				\n");
			sql.append("	(SELECT coalesce(max(sys_bom_id),0)+1 "
						  + "FROM tbm_bom_info \n"); 	//sys_bom_id
			sql.append("	 WHERE bom_cd='" + c_paramArray[0][8] + "' \n "
						  + "AND bom_cd_rev='" + c_paramArray[0][9] + "'), \n");
			sql.append("	'" + c_paramArray[0][3] + "',	\n"); 	//bom_nm
			sql.append("	'" + c_paramArray[0][4] + "', 	\n"); 	//part_count
			sql.append("	'" + c_paramArray[0][5] + "', 	\n"); 	//maesu
			sql.append("	'" + c_paramArray[0][6] + "', 	\n"); 	//gumae_cheo
			sql.append("	'" + c_paramArray[0][7] + "', 	\n"); 	//bigo
			sql.append("	'" + c_paramArray[0][8] + "',	\n"); 	//bom_cd
			sql.append("	'" + c_paramArray[0][9] + "',	\n"); 	//bom_cd_rev
			sql.append("	'" + c_paramArray[0][10] + "', 	\n"); 	//sys_bom_parentid
			sql.append("	'" + c_paramArray[0][11] + "', 	\n"); 	//part_cd
			sql.append("	'" + c_paramArray[0][12] + "', 	\n"); 	//part_cd_rev
			sql.append("	'" + c_paramArray[0][13] + "', 	\n"); 	//level_gubun
			sql.append("	'" + c_paramArray[0][14] + "', 	\n"); 	//modify_hist
			sql.append("	'" + c_paramArray[0][15] + "' 	\n"); // sql.member_key_values
			sql.append(" 	) 								\n");

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
			LoggingWriter.setLogError("M909S010100E201()","==== SQL ERROR ===="+ e.getMessage() + "\n" + sql.toString());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M909S010100E201()","==== finally ===="+ e.getMessage());
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
	
	public int E211(InoutParameter ioParam){
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
			
			sql = new StringBuffer();
			sql.append("INSERT into tbm_bom_info ( 		\n");
			sql.append("	sys_bom_id,			\n"); 
			sql.append("	bom_nm,			\n"); 
			sql.append("	part_count,			\n"); 
			sql.append("	maesu,				\n"); 
			sql.append("	gumae_cheo,			\n"); 
			sql.append("	bigo,				\n"); 
			sql.append("	bom_cd,				\n"); 
			sql.append("	bom_cd_rev,			\n"); 
			sql.append("	sys_bom_parentid,	\n"); 
			sql.append("	part_cd,			\n"); 
			sql.append("	part_cd_rev,		\n"); 
			sql.append("	level_gubun,		\n"); 
			sql.append("	modify_hist,		\n");
			sql.append("	location_xy,		\n");
			sql.append("	member_key			\n"); // sql.member_key_insert
			sql.append(") values ( 				\n");
			sql.append("	(SELECT coalesce(max(sys_bom_id),0)+1 FROM tbm_bom_info WHERE \n"); 	//sys_bom_id
			sql.append("	bom_cd='" + jArray.get("BOM_CODE") + "' AND bom_cd_rev='" + jArray.get("REVISION_NO") + "'), \n");
			sql.append("	'" + jArray.get("Bom_Nm") + "',	\n"); 	//bom_nm
			sql.append("	'" + jArray.get("PartCount") + "', 	\n"); 	//part_count
			sql.append("	'" + jArray.get("Maesu") + "', 	\n"); 	//maesu
			sql.append("	'" + jArray.get("GumaeCheo") + "', 	\n"); 	//gumae_cheo
			sql.append("	'" + jArray.get("Bigo") + "', 	\n"); 	//bigo
			sql.append("	'" + jArray.get("BOM_CODE") + "',	\n"); 	//bom_cd
			sql.append("	'" + jArray.get("REVISION_NO") + "', 	\n"); 	//bom_cd_rev
			sql.append("	'0', \n"); 	//sys_bom_parentid
			sql.append("	'" + jArray.get("PartCode") + "', 	\n"); 	//part_cd
			sql.append("	'" + jArray.get("PartRevNo") + "', 	\n"); 	//part_cd_rev
			sql.append("	'" + jArray.get("CHILD_LEVEL") + "', 	\n"); 	//level_gubun
			sql.append("	'', 	\n"); 	//modify_hist
			sql.append("	'" + jArray.get("Location_XY") + "', 	\n"); 	//location_xy
			sql.append("	'" + jArray.get("member_key") + "') \n"); // sql.member_key_values
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
			LoggingWriter.setLogError("M909S010100E211()","==== SQL ERROR ===="+ e.getMessage() + "\n" + sql.toString());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M909S010100E211()","==== finally ===="+ e.getMessage());
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

	public int E212(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			// 클라이언트로 부터 받은 파라미터를 옮겨 담는다.
			String rcvData = (String)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			
			// 클라이언트로 부터 받은 파라미터를 쪼개어서 배열에 담는다.
			String[][] c_paramArray = CommonFunction.getConvString2DoubleArray(rcvData);

			
			sql = new StringBuffer();
			sql.append("UPDATE tbm_bom_info set \n");
			sql.append("	bom_cd = 	'" + c_paramArray[0][8] + "',	\n"); 
			sql.append("	bom_nm = 	'" + c_paramArray[0][3] + "',	\n"); 
			sql.append("	part_count = 	'" + c_paramArray[0][4] + "',	\n"); 
			sql.append("	maesu = 		'" + c_paramArray[0][5] + "',	\n"); 
			sql.append("	gumae_cheo = 	'" + c_paramArray[0][6] + "',	\n"); 
			sql.append("	bigo = 			'" + c_paramArray[0][7] + "',	\n"); 
			sql.append("	part_cd = 		'" + c_paramArray[0][11] + "',	\n"); 
			sql.append("	part_cd_rev = 	'" + c_paramArray[0][12] + "',	\n"); 
			sql.append("	modify_hist = 	'" + c_paramArray[0][14] + "',	\n"); 
			sql.append("	location_xy = 	'" + c_paramArray[0][15] + "',	\n"); 
			sql.append("	member_key = 	'" + c_paramArray[0][16] + "'	\n"); 
			sql.append("WHERE bom_cd   = '" + c_paramArray[0][8] + "' 	\n");
			sql.append("AND bom_cd_rev = '" + c_paramArray[0][9] + "' 	\n");
			sql.append("AND sys_bom_id = '" + c_paramArray[0][0] + "' 	\n");
			sql.append("AND member_key = '" + c_paramArray[0][16] + "' \n"); // sql.member_key_select, update, delete

			System.out.println( sql.toString() );
			
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
			LoggingWriter.setLogError("M909S010100E212()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M909S010100E212()","==== finally ===="+ e.getMessage());
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

	public int E213(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;

		try {
			con = JDBCConnectionPool.getConnection();
			
			// 클라이언트로 부터 받은 파라미터를 옮겨 담는다.
			String rcvData = (String)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			
			// 클라이언트로 부터 받은 파라미터를 쪼개어서 배열에 담는다.
			String[][] c_paramArray = CommonFunction.getConvString2DoubleArray(rcvData);

			sql = new StringBuffer();
			sql.append("DELETE FROM tbm_bom_info 									\n");
			sql.append("WHERE bom_cd = '" + c_paramArray[0][8] + "' 		\n");
			sql.append("AND bom_cd_rev = '" + c_paramArray[0][9] + "' 	\n");
			sql.append("AND sys_bom_id = '" + c_paramArray[0][0] + "' 	\n");
			sql.append("AND member_key = '" +  c_paramArray[0][16] + "' \n"); // sql.member_key_select, update, delete

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
			LoggingWriter.setLogError("M909S010100E213()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M909S010100E213()","==== finally ===="+ e.getMessage());
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
					.append("SELELCT \n")
					.append("	bom_cd				\n")
					.append("	,revision_no			\n")
					.append("	,bom_nm					\n")
					.append("	,bigo					\n")
					.append("	,start_date				\n")
					.append("	,duration_date			\n")
					.append("	,create_user_id			\n")
					.append("	,create_date			\n")
					.append("	,modify_user_id			\n")
					.append("	,modify_date			\n")
					.append("FROM vtbm_bom_code 				\n")
					.append("WHERE  bom_cd like '%%' 	\n")
//					.append("WHERE  bom_cd like '%" + jArray.get("") + "%' 	\n")
					.append("AND member_key = '" + jArray.get("member_key") + "' \n") //member_key_select, update, delete
					.append("ORDER BY bom_cd ASC, revision_no DESC 			\n")
					.toString();

			resultString = super.excuteQueryString(con, sql.toString());
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M909S010100E204()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M909S010100E204()","==== finally ===="+ e.getMessage());
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
	
	//배합 상세정보
	public int E214(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			System.out.println("JSONObject jArray rcvData="+ jArray.toString());
			
			String sql = new StringBuilder()
					.append("SELECT \n")
					.append("	A.part_cd,									\n")
					.append("	B.part_nm,									\n")
					.append("   A.prod_cd,          						\n")
					.append("   C.product_nm,								\n")
					.append("	part_rev_no,								\n")	
					.append("	bom_rev_no,									\n")
					.append("	TO_CHAR(blending_ratio) as blending_ratio,	\n")
					.append("	A.start_date,								\n")
					.append("	A.duration_date,							\n")
					.append("	A.delyn										\n")
					.append("FROM tbm_bom_info2 A 							\n")
					.append("INNER JOIN tbm_part_list B						\n")
					.append("	ON A.part_cd=B.part_cd						\n")
					.append("	AND A.part_rev_no=B.revision_no				\n")
					.append("INNER JOIN tbm_product C 						\n")
					.append("	ON A.prod_cd = C.prod_cd					\n")
					.append("	AND A.prod_rev_no = C.revision_no			\n")
					.append("WHERE bom_rev_no = (SELECT MAX(bom_rev_no) 		\n")
					.append("                    FROM tbm_bom_info2 D          	\n")
					.append("					 WHERE D.prod_cd = A.prod_cd) 	\n")
					.append("AND	A.delyn = 'N' 						   		\n")
					.append("AND A.prod_cd = '" + jArray.get("prod_cd") +"'		\n")
					.append("AND A.prod_rev_no = (SELECT MAX(prod_rev_no)   	\n")
					.append("					 FROM tbm_bom_info2 E   	   	\n")
					.append("					 WHERE A.prod_cd = E.prod_cd)  	\n")
					.append("GROUP BY A.part_cd							   \n")
					.append("ORDER BY A.part_cd							   \n")
					.toString(); 
			
			resultString = super.excuteQueryString(con, sql.toString());
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M909S010100E214()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M909S010100E214()","==== finally ===="+ e.getMessage());
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
	
	public int E215(InoutParameter ioParam){
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

			/*
			String sql = new StringBuilder()
					.append("SELECT \n")
					.append("	sys_bom_id,			\n")
					.append("	A.part_cd,			\n")
					.append("	B.part_nm,			\n") // .append("bom_nm,\n")
					.append("	part_count,			\n")
					.append("	maesu,				\n")
					.append("	gumae_cheo,			\n")
					.append("	location_xy,		\n")
					.append("	bigo,				\n")
					.append("	bom_cd,				\n")	
					.append("	bom_cd_rev,			\n")
					.append("	sys_bom_parentid,	\n")
					.append("	A.part_cd_rev,		\n")
					.append("	level_gubun,		\n")
					.append("	modify_hist			\n")
					.append("FROM tbm_bom_info A	\n")
					.append("INNER JOIN tbm_part_list B\n")
					.append("	ON A.part_cd=B.part_cd\n")
					.append("	AND A.part_cd_rev=B.revision_no\n")
					.append("	AND A.member_key=B.member_key\n")
					.append("WHERE bom_cd = '"+jArray.get("BOM_CODE")+"'\n")
					.append("	AND bom_cd_rev = '" + jArray.get("REVISION_NO") + "'\n")
					.append("	AND A.part_cd = '" + jArray.get("part_cd") + "'\n")
					.append("	AND sys_bom_id = '" + jArray.get("sys_bom_id") + "'\n")
					.append("	AND A.member_key = '" + jArray.get("member_key") + "' \n") //member_key_select, update, delete
					.append("ORDER BY sys_bom_id ASC\n")
					.toString();
			*/
				
			String sql = new StringBuilder()
					.append("SELECT \n")
					.append("	C.product_nm,				\n")
					.append("	A.part_cd,					\n")
					.append("	B.part_nm,					\n") 
					.append("	A.blending_ratio,			\n")
					.append("	A.bom_rev_no				\n")
					.append("FROM tbm_bom_info2 A			\n")
					.append("INNER JOIN tbm_part_list B				\n")
					.append("	ON A.part_cd=B.part_cd				\n")
					.append("	AND A.part_rev_no=B.revision_no		\n")
					.append("INNER JOIN tbm_product C 				\n")
					.append("   ON A.prod_cd=C.prod_cd				\n")
					.append("   AND A.prod_rev_no=C.revision_no		\n")
					.append("WHERE A.part_cd = '"+jArray.get("part_cd")+"'\n")
					.append("	AND bom_rev_no = '" + jArray.get("Bom_Rev_No") + "'\n")
					.append("ORDER BY A.part_cd ASC\n")
					.toString(); 
			
			resultString = super.excuteQueryString(con, sql.toString());
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M909S010100E215()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M909S010100E215()","==== finally ===="+ e.getMessage());
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

	public int E314(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			// 클라이언트로 부터 받은 파라미터를 옮겨 담는다.
			String rcvData = (String)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			// 클라이언트로 부터 받은 파라미터를 쪼개어서 배열에 담는다.
			// rcvData = [위경도]
			String[][] c_paramArray = CommonFunction.getConvString2DoubleArray(rcvData);

			String sql = new StringBuilder()
					.append("SELECT						\n")
					.append("	sys_bom_id,			\n")
					.append("	bom_nm,			\n")
					.append("	part_count,			\n")
					.append("	maesu,				\n")
					.append("	gumae_cheo,			\n")
					.append("	bigo,				\n")
					.append("	bom_cd,				\n")
					.append("	bom_cd_rev,			\n")
					.append("	sys_bom_parentid,	\n")
					.append("	part_cd,			\n")
					.append("	part_cd_rev,		\n")
					.append("	level_gubun,		\n")
					.append("	modify_hist,		\n")
					.append("	location_xy			\n")
					.append("FROM tbm_bom_info 		\n")
					.append("WHERE bom_cd = '" + c_paramArray[0][0] + "' 	\n")
					.append("AND bom_cd_rev = '" + c_paramArray[0][1] + "' 	\n")
					.append("AND sys_bom_id = '" + c_paramArray[0][2] + "' 	\n")
					.append("AND member_key = '" + c_paramArray[0][3] + "' \n") //member_key_select, update, delete
					.toString();
			
			resultString = super.excuteQueryString(con, sql.toString());
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M909S010100E314()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M909S010100E314()","==== finally ===="+ e.getMessage());
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
	
	//bomview.jsp
	public int E245(InoutParameter ioParam){
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
					.append("        sys_bom_id,\n")
					.append("        bom_cd,\n")
					.append("        bom_cd_rev,\n")
					.append("        A.part_cd,\n")
					.append("        bom_nm,\n")
					.append("        B.part_nm || '('||E.code_name  ||','||  F.code_name ||')' AS part_nm,\n")
					.append("        A.part_cd_rev,\n")
					.append("        part_count,\n")
					.append("        maesu,\n")
					.append("        level_gubun,\n")
					.append("        '' AS qar,\n")
					.append("        '' AS inspect,\n")
					.append("        '' AS package,\n")
					.append("        modify_hist,\n")
					.append("        cust_cd,\n")
					.append("        gumae_cheo,\n")
					.append("        cust_rev,\n")
					.append("        A.bigo,\n")
					.append("		 SUM(NVL(S.post_amt,0))\n")
					.append("FROM tbm_bom_info A\n")
					.append("        INNER JOIN tbm_part_list B\n")
					.append("        ON A.part_cd = B.part_cd\n")
					.append("        AND A.part_cd_rev = B.revision_no\n")
					.append("        AND A.member_key = B.member_key\n")
					.append("INNER JOIN v_partgubun_big E\n")
					.append("        ON B.part_gubun_b = E.code_value\n")
					.append("       AND B.member_key = E.member_key\n")
					.append("INNER JOIN v_partgubun_mid F\n")
					.append("        ON B.part_gubun_m = F.code_value\n")
					.append("       AND B.member_key = F.member_key\n")
					.append("LEFT OUTER JOIN tbi_part_storage S\n")
					.append("	ON A.part_Cd = S.part_cd\n")
					.append("	AND A.part_cd_rev = S.part_cd_rev\n")
					.append("	AND A.member_key = S.member_key\n")
					.append("WHERE 1=1 \n")
					.append(" AND  bom_cd like '%" + jArray.get("bom_cd") + "' \n")
					.append(" AND  bom_cd_rev like '%" + jArray.get("bom_cd_rev") + "' \n")
					.append(" 	AND A.member_key = '" + jArray.get("member_key") + "' \n") //member_key_select, update, delete
					.append("GROUP BY A.part_cd\n")
					.append("ORDER BY A.part_cd\n")
					.toString();

			resultString = super.excuteQueryString(con, sql.toString());
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M909S010100E245()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M909S010100E245()","==== finally ===="+ e.getMessage());
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
	public int E294(InoutParameter ioParam){
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
//					.append("SELECT\n")
//					.append("	sys_bom_id,\n")
//					.append("	bom_cd,\n")
//					.append("	bom_cd_rev,\n")
//					.append("	part_cd,\n")
//					.append("	B.part_nm,\n")
//					.append("	part_cd_rev,\n")
//					.append("	part_count,\n")
//					.append("	maesu,\n")
//					.append("	level_gubun,\n")
//
//					.append("	'' as qar,\n")
//					.append("	'' as inspect,\n")
//					.append("	'' as package,\n")
//					
//					.append("	modify_hist,\n")
//					.append("	cust_cd,\n")
//					.append("	gumae_cheo,\n")
//					.append("	cust_rev,\n")
//					.append("	bigo\n")
//					.append("FROM\n")
//					.append("	tbm_bom_info A \n")
//					.append("	INNER JOIN tbm_part_list B \n")
//					.append("	ON part_cd = part_cd\n")
//					.append("	AND part_cd_rev = B.revision_no\n")
//					.append("WHERE sys_bom_id = '" + c_paramArray[0][0] + "' \n")
//					.append("AND  bom_cd like '" + c_paramArray[0][1] + "%' \n")
					.append("SELECT\n")
					.append("        B.sys_bom_id,\n")
					.append("        B.bom_cd,\n")
					.append("        B.bom_cd_rev,\n")
					.append("        B.part_cd,\n")
					.append("        B.bom_nm,\n")
					.append("        C.part_nm,\n")
					.append("        B.part_cd_rev,\n")
					.append("        B.part_count,\n")
					.append("        B.maesu,\n")
					.append("        B.level_gubun,\n")
					.append("        '' AS qar,\n")
					.append("        '' AS inspect,\n")
					.append("        '' AS package,\n")
					.append("        B.modify_hist,\n")
					.append("        B.cust_cd,\n")
					.append("        B.gumae_cheo,\n")
					.append("        B.cust_rev,\n")
					.append("        B.bigo\n")
					.append("FROM\n")
					.append("		vtbm_bom_code A\n")
					.append("		INNER JOIN tbm_bom_info B\n")
					.append("		ON A.bom_cd = B.bom_cd\n")
					.append("		AND A.revision_no = B.bom_cd_rev\n")
					.append("		AND A.member_key = B.member_key\n")
					.append("		INNER JOIN vtbm_part_list C\n")
					.append("		ON B.part_cd= C.part_cd\n")
					.append("		AND B.part_cd_rev = C.revision_no\n")
					.append("		AND A.member_key = C.member_key\n")
					.append("WHERE B.sys_bom_id='1'\n")
					.append(" 	AND A.member_key = '" + jArray.get("member_key") + "' \n") //member_key_select, update, delete
					.toString();

			resultString = super.excuteQueryString(con, sql.toString());
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M909S010100E294()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M909S010100E294()","==== finally ===="+ e.getMessage());
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

