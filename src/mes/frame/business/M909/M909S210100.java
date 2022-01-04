/*
 * 선반정보관리
 * 
 * */


package mes.frame.business.M909;

import java.lang.reflect.Method;
import java.sql.Connection;
import java.sql.PreparedStatement;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;

import mes.client.conf.Config;
import mes.client.util.ChulhaNumberGenerator;
import mes.frame.common.EventDefine;
import mes.frame.common.HashObject;
import mes.frame.common.MessageDefine;
import mes.frame.database.JDBCConnectionPool;
import mes.frame.database.SqlAdapter;
import mes.frame.serviceinterface.InoutParameter;
import mes.frame.serviceinterface.LoggingWriter;
import mes.frame.util.CommonFunction;


public class M909S210100 extends SqlAdapter{
	Connection con = null;
	PreparedStatement pstmt = null;
	String resultString = "";
	int resultInt = -1;
	StringBuffer sql = new StringBuffer();
	
	String[][] v_paramArray = new String[0][0]; 
	Class[] optClass = null;
	Object[] optObj = null;
	Object obj = null;
	
	public M909S210100(){
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
	 * 입력파라메타에서 이벤트ID별로 메소드 호선반는 method.
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
			
			Method method = M909S210100.class.getMethod(event,optClass);
			LoggingWriter.setLogDebug(M909S210100.class.getName(),"==== " + event + " EventMethod Create Success ====");

			obj = method.invoke(M909S210100.class.newInstance(),optObj);
			doExcute_result = CommonFunction.getInt(obj.toString());
			
	    } catch (Exception ex) {
	    	doExcute_result = EventDefine.E_DOEXCUTE_INIT;
			ioParam.setMessage(MessageDefine.M_NO_EVENTID);
			LoggingWriter.setLogError(M909S210100.class.getName(),"==== EventID Not define : EVENT ID [ " + ioParam.getEventID() + "]");
	    } finally {
	    	obj = null;
			optClass = null;
			optObj = null;
	    }
	    long endTime = System.currentTimeMillis();
		long runningTime = endTime - startTime;
		LoggingWriter.setLogAll(M909S210100.class.getName(),"==== Query [수행시간  : " + runningTime + " ms]");
		
		return doExcute_result;
	}
	
	// yumsam
	// 선반 등록
	public int E101(InoutParameter ioParam) {
		resultInt = EventDefine.E_DOEXCUTE_INIT;

		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jObj = new JSONObject();
			jObj = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			
    		String sql = new StringBuilder()
    				.append("INSERT INTO\n")
    				.append("	tbm_facility_shelf (\n")
    				.append("		shelf_type,\n")
    				.append("		shelf_row,\n")
    				.append("		shelf_column\n")
    				.append("	)\n")
    				.append("VALUES\n")
    				.append("	(\n")
    				.append("		'"+jObj.get("shelf_type")+"',	\n")
    				.append("		'"+jObj.get("shelf_row")+"',	\n")
    				.append("		'"+jObj.get("shelf_column")+"'	\n")
    				.append("	);\n")
    				.toString();

			resultInt = super.excuteUpdate(con, sql);
    		if (resultInt < 0) {
				ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
				return EventDefine.E_DOEXCUTE_ERROR ;
			}
		    	
			con.commit();
		} catch(Exception e) {
			LoggingWriter.setLogError("M909S210100E101()","==== SQL ERROR ===="+ e.getMessage());
			e.printStackTrace();
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M909S210100E101()","==== finally ===="+ e.getMessage());
				}
	    	}
	    }
		ioParam.setResultString(resultString);
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
    	ioParam.setMessage(MessageDefine.M_QUERY_OK);
    	System.out.println("E101 최종 리턴값: " + EventDefine.E_QUERY_RESULT);
	    return EventDefine.E_QUERY_RESULT;
	}
	
	
	// yumsam
	// 선반 수정
	public int E102(InoutParameter ioParam) {
		resultInt = EventDefine.E_DOEXCUTE_INIT;

		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jObj = new JSONObject();
    		jObj = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			
    		String sql = new StringBuilder()
    				.append("UPDATE\n")
    				.append("	tbm_facility_shelf\n")
    				.append("SET\n")
    				.append("	shelf_row = '"+jObj.get("shelf_row")+"',\n")
    				.append("	shelf_column = '"+jObj.get("shelf_column")+"'\n")
    				.append("WHERE\n")
    				.append("	shelf_type = '"+jObj.get("shelf_type")+"'\n")
    				.toString();

			resultInt = super.excuteUpdate(con, sql);
    		
			if (resultInt < 0) {
				ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
				con.rollback();
				return EventDefine.E_DOEXCUTE_ERROR;
			}
    		
			con.commit();
		} catch(Exception e) {
			LoggingWriter.setLogError("M909S210100E102()","==== SQL ERROR ===="+ e.getMessage());
			e.printStackTrace();
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M909S210100E102()","==== finally ===="+ e.getMessage());
				}
	    	}
	    }
		ioParam.setResultString(resultString);
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
    	ioParam.setMessage(MessageDefine.M_QUERY_OK);
    	System.out.println("E102 최종 리턴값: " + EventDefine.E_QUERY_RESULT);
	    return EventDefine.E_QUERY_RESULT;
	}

	// yumsam
	// 선반
	public int E103(InoutParameter ioParam) {
		resultInt = EventDefine.E_DOEXCUTE_INIT;

		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jObj = new JSONObject();
    		jObj = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			
    		String sql = new StringBuilder()
    				.append("DELETE FROM\n")
    				.append("	tbm_facility_shelf\n")
    				.append("WHERE\n")
    				.append("	shelf_type = '"+jObj.get("shelf_type")+"'\n")
    				.toString();
        		
	    	resultInt = super.excuteUpdate(con, sql);
	    	
	    	if (resultInt < 0) {
				ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
				con.rollback();
				return EventDefine.E_DOEXCUTE_ERROR;
			}
			
			con.commit();
		} catch(Exception e) {
			LoggingWriter.setLogError("M909S210100E103()","==== SQL ERROR ===="+ e.getMessage());
			e.printStackTrace();
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M909S210100E103()","==== finally ===="+ e.getMessage());
				}
	    	}
	    }
		ioParam.setResultString(resultString);
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
    	ioParam.setMessage(MessageDefine.M_QUERY_OK);
    	System.out.println("E103 최종 리턴값: " + EventDefine.E_QUERY_RESULT);
	    return EventDefine.E_QUERY_RESULT;
	}
	
	// 선반 메인 정보 조회
	public int E104(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			String sql = new StringBuilder()
					.append("SELECT\n")
					.append("	shelf_type,\n")
					.append("	shelf_row,\n")
					.append("	shelf_column\n")
					.append("FROM\n")
					.append("	tbm_facility_shelf;\n")
					.toString();

			resultString = super.excuteQueryString(con, sql);
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M909S210100E104()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M909S210100E104()","==== finally ===="+ e.getMessage());
				}
	    	}
	    }
		ioParam.setResultString(resultString);
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
    	ioParam.setMessage(MessageDefine.M_QUERY_OK);
	    return EventDefine.E_QUERY_RESULT;
	}
	
	// yumsam
	// 선반별 제품 등록
	public int E111(InoutParameter ioParam) {
		resultInt = EventDefine.E_DOEXCUTE_INIT;

		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jObj = new JSONObject();
			jObj = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			
			String sql = new StringBuilder()
					.append("INSERT INTO\n")
					.append("	tbm_product_shelf (\n")
					.append("		shelf_type,\n")
					.append("		prod_cd,\n")
					.append("		prod_rev_no,\n")
					.append("		tray_prod_count\n")
					.append("	)\n")
					.append("VALUES\n")
					.append("	(\n")
    				.append("		'"+jObj.get("shelf_type")+"',		\n")
    				.append("		'"+jObj.get("prod_cd")+"',			\n")
    				.append("		'"+jObj.get("prod_rev_no")+"',		\n")
    				.append("		'"+jObj.get("tray_prod_count")+"'	\n")
					.append("	);\n")
					.toString();

			resultInt = super.excuteUpdate(con, sql);
    		if (resultInt < 0) {
				ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
				return EventDefine.E_DOEXCUTE_ERROR ;
			}
		    	
			con.commit();
		} catch(Exception e) {
			LoggingWriter.setLogError("M909S210100E111()","==== SQL ERROR ===="+ e.getMessage());
			e.printStackTrace();
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M909S210100E111()","==== finally ===="+ e.getMessage());
				}
	    	}
	    }
		ioParam.setResultString(resultString);
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
    	ioParam.setMessage(MessageDefine.M_QUERY_OK);
    	System.out.println("E101 최종 리턴값: " + EventDefine.E_QUERY_RESULT);
	    return EventDefine.E_QUERY_RESULT;
	}
	
	
	// yumsam
	// 선반별 제품 수정
	public int E112(InoutParameter ioParam) {
		resultInt = EventDefine.E_DOEXCUTE_INIT;

		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jObj = new JSONObject();
    		jObj = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			
    		String sql = new StringBuilder()
    				.append("UPDATE\n")
    				.append("	tbm_product_shelf\n")
    				.append("SET\n")
    				.append("	tray_prod_count = '"+jObj.get("tray_prod_count")+"'\n")
    				.append("WHERE\n")
    				.append("	shelf_type = '"+jObj.get("shelf_type")+"'\n")
    				.append("	AND prod_cd = '"+jObj.get("prod_cd")+"'\n")
    				.toString();

			resultInt = super.excuteUpdate(con, sql);
    		
			if (resultInt < 0) {
				ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
				con.rollback();
				return EventDefine.E_DOEXCUTE_ERROR;
			}
    		
			con.commit();
		} catch(Exception e) {
			LoggingWriter.setLogError("M909S210100E112()","==== SQL ERROR ===="+ e.getMessage());
			e.printStackTrace();
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M909S210100E112()","==== finally ===="+ e.getMessage());
				}
	    	}
	    }
		ioParam.setResultString(resultString);
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
    	ioParam.setMessage(MessageDefine.M_QUERY_OK);
    	System.out.println("E102 최종 리턴값: " + EventDefine.E_QUERY_RESULT);
	    return EventDefine.E_QUERY_RESULT;
	}

	// yumsam
	// 선반별 제품 삭제
	public int E113(InoutParameter ioParam) {
		resultInt = EventDefine.E_DOEXCUTE_INIT;

		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jObj = new JSONObject();
    		jObj = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			
    		String sql = new StringBuilder()
    				.append("DELETE \n")
    				.append("FROM\n")
    				.append("	tbm_product_shelf\n")
    				.append("WHERE shelf_type = '"+jObj.get("shelf_type")+"'\n")
    				.append("	AND prod_cd = '"+jObj.get("prod_cd")+"'\n")
    				.toString();
        		
	    	resultInt = super.excuteUpdate(con, sql);
	    	
	    	if (resultInt < 0) {
				ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
				con.rollback();
				return EventDefine.E_DOEXCUTE_ERROR;
			}
			
			con.commit();
		} catch(Exception e) {
			LoggingWriter.setLogError("M909S210100E113()","==== SQL ERROR ===="+ e.getMessage());
			e.printStackTrace();
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M909S210100E113()","==== finally ===="+ e.getMessage());
				}
	    	}
	    }
		ioParam.setResultString(resultString);
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
    	ioParam.setMessage(MessageDefine.M_QUERY_OK);
    	System.out.println("E103 최종 리턴값: " + EventDefine.E_QUERY_RESULT);
	    return EventDefine.E_QUERY_RESULT;
	}
	
	// 선반별 제품 정보 조회
	public int E114(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jObj = new JSONObject();
    		jObj = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			
    		String sql = new StringBuilder()
    				.append("SELECT\n")
    				.append("	A.shelf_type,\n")
    				.append("	A.prod_cd,\n")
    				.append("	A.prod_rev_no,\n")
    				.append("	B.product_nm,\n")
    				.append("	A.tray_prod_count\n")
    				.append("FROM\n")
    				.append("	tbm_product_shelf A\n")
    				.append("INNER JOIN tbm_product B \n")
    				.append("	ON A.prod_cd = B.prod_cd\n")
    				.append("	AND A.prod_rev_no = B.revision_no\n")
    				.append("WHERE A.shelf_type = '"+jObj.get("shelf_type")+"'\n")
					.toString();

			resultString = super.excuteQueryString(con, sql);
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M909S210100E114()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M909S210100E114()","==== finally ===="+ e.getMessage());
				}
	    	}
	    }
		ioParam.setResultString(resultString);
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
    	ioParam.setMessage(MessageDefine.M_QUERY_OK);
	    return EventDefine.E_QUERY_RESULT;
	}
	
	// 특정 선반 정보 조회
	public int E124(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jObj = new JSONObject();
    		jObj = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			
			String sql = new StringBuilder()
					.append("SELECT\n")
					.append("	shelf_type,\n")
					.append("	shelf_row,\n")
					.append("	shelf_column\n")
					.append("FROM\n")
					.append("	tbm_facility_shelf\n")
					.append("WHERE\n")
					.append("   shelf_type = '"+jObj.get("shelf_type")+"'\n")
					.toString();

			resultString = super.excuteQueryString(con, sql);
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M909S210100E124()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M909S210100E124()","==== finally ===="+ e.getMessage());
				}
	    	}
	    }
		ioParam.setResultString(resultString);
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
    	ioParam.setMessage(MessageDefine.M_QUERY_OK);
	    return EventDefine.E_QUERY_RESULT;
	}
	
	// 특정 선반별 제품 조회
	public int E134(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jObj = new JSONObject();
    		jObj = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			
    		String sql = new StringBuilder()
    				.append("SELECT\n")
    				.append("	A.shelf_type,\n")
    				.append("	A.prod_cd,\n")
    				.append("	A.prod_rev_no,\n")
    				.append("	B.product_nm,\n")
    				.append("	A.tray_prod_count\n")
    				.append("FROM\n")
    				.append("	tbm_product_shelf A\n")
    				.append("INNER JOIN tbm_product B\n")
    				.append("	ON A.prod_cd = B.prod_cd\n")
    				.append("	AND A.prod_rev_no = B.revision_no\n")
    				.append("WHERE \n")
    				.append("   A.shelf_type = '"+jObj.get("shelf_type")+"'		\n")
    				.append("   AND A.prod_cd = '"+jObj.get("prod_cd")+"'		\n")
    				.append("   AND A.prod_rev_no = "+jObj.get("prod_rev_no")+"	\n")
    				.toString();

			resultString = super.excuteQueryString(con, sql);
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M909S210100E134()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M909S210100E134()","==== finally ===="+ e.getMessage());
				}
	    	}
	    }
		ioParam.setResultString(resultString);
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
    	ioParam.setMessage(MessageDefine.M_QUERY_OK);
	    return EventDefine.E_QUERY_RESULT;
	}
}