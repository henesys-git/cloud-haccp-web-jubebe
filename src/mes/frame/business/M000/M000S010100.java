package mes.frame.business.M000;

import java.lang.reflect.Method;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.text.SimpleDateFormat;
import java.util.Date;

import org.apache.log4j.Logger;

import mes.frame.common.EventDefine;
import mes.frame.common.HashObject;
import mes.frame.common.MessageDefine;
import mes.frame.database.JDBCConnectionPool;
import mes.frame.database.SqlAdapter;
import mes.frame.serviceinterface.InoutParameter;
import mes.frame.serviceinterface.LoggingWriter;
import mes.frame.util.CommonFunction;


public class M000S010100 extends SqlAdapter {
	
	static final Logger logger = Logger.getLogger(M000S010100.class.getName());
	
	Connection con = null;
	PreparedStatement pstmt = null;
	String resultString = "";
	int resultInt = -1;
	StringBuffer sql = new StringBuffer();
	
	String[][] v_paramArray = new String[0][0]; 
	Class[] optClass = null;
	Object[] optObj = null;
	Object obj = null;
	
	public M000S010100(){
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

	public String getCurrentDate(String format) {
        Date d = new Date();
        SimpleDateFormat sdf = new SimpleDateFormat(format);
        return sdf.format(d);
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
		
	    try {
            optClass = new Class[1];
			optClass[0] = ioParam.getClass() ;
			optObj = new Object[1];
			optObj[0] = ioParam;
			
			Method method = M000S010100.class.getMethod(event,optClass);
			LoggingWriter.setLogDebug(M000S010100.class.getName(),"==== " + event + " EventMethod Create Success ====");

			obj = method.invoke(M000S010100.class.newInstance(),optObj);
			doExcute_result = CommonFunction.getInt(obj.toString());
			
	    } catch (Exception ex) {
	    	doExcute_result = EventDefine.E_DOEXCUTE_INIT;
			ioParam.setMessage(MessageDefine.M_NO_EVENTID);
			LoggingWriter.setLogError(M000S010100.class.getName(),"==== EventID Not define : EVENT ID [ " + ioParam.getEventID() + "]");
	    } finally {
	    	obj = null;
			optClass = null;
			optObj = null;
	    }
	    
	    long endTime = System.currentTimeMillis();
		long runningTime = endTime - startTime;
		logger.debug("Query [수행시간  : " + runningTime + " ms]");
		
		return doExcute_result;
	}
	
	// 완제품 입고 타입
	public int E004(InoutParameter ioParam){		
				
		try {
			con = JDBCConnectionPool.getConnection();
			
			String sql = new StringBuilder()
					.append("SELECT							\n")
					.append("	code_cd,					\n")
					.append("	code_value,					\n")
					.append("	code_name					\n")
					.append("FROM 							\n")
					.append("	vtbm_code_book				\n")
					.append("WHERE							\n")
					.append("	code_cd = 'PROD_IPGO_TYPE'	\n")
					.append("	AND order_index > 0			\n")
					.toString();

			resultString = super.excuteQueryString(con, sql);
			
		} catch(Exception e) {
			LoggingWriter.setLogError("M000S010100E004()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
			try {
				if (con != null) con.close();
			} catch (Exception e) {
				LoggingWriter.setLogError("M000S010100E004()","==== finally ===="+ e.getMessage());
			}
	    }

		ioParam.setResultString(resultString);
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
    	ioParam.setMessage(MessageDefine.M_QUERY_OK);
	    return EventDefine.E_QUERY_RESULT;
	}
	
	// 완제품 출고 타입
	public int E014(InoutParameter ioParam){		
				
		try {
			con = JDBCConnectionPool.getConnection();
			
			String sql = new StringBuilder()
					.append("SELECT								\n")
					.append("	code_cd,						\n")
					.append("	code_value,						\n")
					.append("	code_name						\n")
					.append("FROM 								\n")
					.append("	vtbm_code_book					\n")
					.append("WHERE								\n")
					.append("	code_cd = 'PROD_CHULGO_TYPE'	\n")
					.append("	AND order_index > 0				\n")
					.toString();

			resultString = super.excuteQueryString(con, sql);
			
		} catch(Exception e) {
			LoggingWriter.setLogError("M000S010100E014()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
			try {
				if (con != null) con.close();
			} catch (Exception e) {
				LoggingWriter.setLogError("M000S010100E014()","==== finally ===="+ e.getMessage());
			}
	    }

		ioParam.setResultString(resultString);
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
    	ioParam.setMessage(MessageDefine.M_QUERY_OK);
	    return EventDefine.E_QUERY_RESULT;
	}
	
	// 원부자재 입고 타입
	public int E024(InoutParameter ioParam){		
				
		try {
			con = JDBCConnectionPool.getConnection();
			
			String sql = new StringBuilder()
					.append("SELECT							\n")
					.append("	code_cd,					\n")
					.append("	code_value,					\n")
					.append("	code_name					\n")
					.append("FROM 							\n")
					.append("	vtbm_code_book				\n")
					.append("WHERE							\n")
					.append("	code_cd = 'PART_IPGO_TYPE'	\n")
					.append("	AND order_index > 0			\n")
					.toString();

			resultString = super.excuteQueryString(con, sql);
			
		} catch(Exception e) {
			LoggingWriter.setLogError("M000S010100E024()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
			try {
				if (con != null) con.close();
			} catch (Exception e) {
				LoggingWriter.setLogError("M000S010100E024()","==== finally ===="+ e.getMessage());
			}
	    }

		ioParam.setResultString(resultString);
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
    	ioParam.setMessage(MessageDefine.M_QUERY_OK);
	    return EventDefine.E_QUERY_RESULT;
	}
	
	// 원부자재 출고 타입
	public int E034(InoutParameter ioParam){		
				
		try {
			con = JDBCConnectionPool.getConnection();
			
			String sql = new StringBuilder()
					.append("SELECT								\n")
					.append("	code_cd,						\n")
					.append("	code_value,						\n")
					.append("	code_name						\n")
					.append("FROM 								\n")
					.append("	vtbm_code_book					\n")
					.append("WHERE								\n")
					.append("	code_cd = 'PART_CHULGO_TYPE'	\n")
					.append("	AND order_index > 0				\n")
					.toString();

			resultString = super.excuteQueryString(con, sql);
			
		} catch(Exception e) {
			LoggingWriter.setLogError("M000S010100E034()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
			try {
				if (con != null) con.close();
			} catch (Exception e) {
				LoggingWriter.setLogError("M000S010100E034()","==== finally ===="+ e.getMessage());
			}
	    }

		ioParam.setResultString(resultString);
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
    	ioParam.setMessage(MessageDefine.M_QUERY_OK);
	    return EventDefine.E_QUERY_RESULT;
	}
	
	// 주문 타입
	public int E044(InoutParameter ioParam){		
				
		try {
			con = JDBCConnectionPool.getConnection();
			
			String sql = new StringBuilder()
					.append("SELECT						\n")
					.append("	code_cd,				\n")
					.append("	code_value,				\n")
					.append("	code_name				\n")
					.append("FROM 						\n")
					.append("	vtbm_code_book			\n")
					.append("WHERE						\n")
					.append("	code_cd = 'ORDER_TYPE'	\n")
					.append("	AND order_index > 0		\n")
					.toString();

			resultString = super.excuteQueryString(con, sql);
			
		} catch(Exception e) {
			LoggingWriter.setLogError("M000S010100E044()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
			try {
				if (con != null) con.close();
			} catch (Exception e) {
				LoggingWriter.setLogError("M000S010100E044()","==== finally ===="+ e.getMessage());
			}
	    }

		ioParam.setResultString(resultString);
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
    	ioParam.setMessage(MessageDefine.M_QUERY_OK);
	    return EventDefine.E_QUERY_RESULT;
	}
	
	// 생산계획 타입
	public int E054(InoutParameter ioParam){		
				
		try {
			con = JDBCConnectionPool.getConnection();
			
			String sql = new StringBuilder()
					.append("SELECT						\n")
					.append("	code_cd,				\n")
					.append("	code_value,				\n")
					.append("	code_name				\n")
					.append("FROM 						\n")
					.append("	vtbm_code_book			\n")
					.append("WHERE						\n")
					.append("	code_cd = 'PROD_PLAN_TYPE'	\n")
					.append("	AND order_index > 0		\n")
					.toString();

			resultString = super.excuteQueryString(con, sql);
			
		} catch(Exception e) {
			LoggingWriter.setLogError("M000S010100E054()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
			try {
				if (con != null) con.close();
			} catch (Exception e) {
				LoggingWriter.setLogError("M000S010100E054()","==== finally ===="+ e.getMessage());
			}
	    }

		ioParam.setResultString(resultString);
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
    	ioParam.setMessage(MessageDefine.M_QUERY_OK);
	    return EventDefine.E_QUERY_RESULT;
	}
	
	// 배송차량 종류
	public int E064(InoutParameter ioParam){		
				
		try {
			con = JDBCConnectionPool.getConnection();
			
			String sql = new StringBuilder()
					.append("SELECT\n")
					.append("	vehicle_cd,			\n")
					.append("	vehicle_nm,			\n")
					.append("	vehicle_rev_no		\n")
					.append("FROM\n")
					.append("	tbm_vehicle A\n")
					.append("WHERE\n")
					.append("	vehicle_rev_no = (SELECT MAX(vehicle_rev_no)\n")
					.append("					  FROM tbm_vehicle B\n")
					.append("					  WHERE B.vehicle_cd = A.vehicle_cd)\n")
					.toString();
	
			resultString = super.excuteQueryString(con, sql);
			
		} catch(Exception e) {
			LoggingWriter.setLogError("M000S010100E064()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
			try {
				if (con != null) con.close();
			} catch (Exception e) {
				LoggingWriter.setLogError("M000S010100E064()","==== finally ===="+ e.getMessage());
			}
	    }
	
		ioParam.setResultString(resultString);
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
		ioParam.setMessage(MessageDefine.M_QUERY_OK);
	    return EventDefine.E_QUERY_RESULT;
	}
	
	// 배송기사 목록
	public int E074(InoutParameter ioParam){		
				
		try {
			con = JDBCConnectionPool.getConnection();
			
			String sql = new StringBuilder()
					.append("SELECT						\n")
					.append("	user_id,				\n")
					.append("	user_nm,				\n")
					.append("	revision_no				\n")
					.append("FROM						\n")
					.append("	tbm_users A				\n")
					.append("WHERE						\n")
					.append("	group_cd = 'GRCD010'	\n")
					.append("AND A.revision_no = (SELECT MAX(revision_no) FROM 	 \n")
					.append("	 				   	 		tbm_users B WHERE 	 \n")
					.append("                        	A.user_id = B.user_id)	 \n")
					.toString();
	
			resultString = super.excuteQueryString(con, sql);
			
		} catch(Exception e) {
			LoggingWriter.setLogError("M000S010100E074()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
			try {
				if (con != null) con.close();
			} catch (Exception e) {
				LoggingWriter.setLogError("M000S010100E074()","==== finally ===="+ e.getMessage());
			}
	    }
	
		ioParam.setResultString(resultString);
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
		ioParam.setMessage(MessageDefine.M_QUERY_OK);
	    return EventDefine.E_QUERY_RESULT;
	}
	
	// 배송지역 목록
	public int E084(InoutParameter ioParam){		
				
		try {
			con = JDBCConnectionPool.getConnection();
			
			String sql = new StringBuilder()
					.append("SELECT						\n")
					.append("	code_cd,				\n")
					.append("	code_value,				\n")
					.append("   code_name				\n")
					.append("FROM						\n")
					.append("	tbm_code_book			\n")
					.append("WHERE						\n")
					.append("	code_cd = 'CUSTOMER_GUBUN_MID02'	\n")
					.append("	AND order_index > 0		\n")
					.toString();
	
			resultString = super.excuteQueryString(con, sql);
			
		} catch(Exception e) {
			LoggingWriter.setLogError("M000S010100E084()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
			try {
				if (con != null) con.close();
			} catch (Exception e) {
				LoggingWriter.setLogError("M000S010100E084()","==== finally ===="+ e.getMessage());
			}
	    }
	
		ioParam.setResultString(resultString);
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
		ioParam.setMessage(MessageDefine.M_QUERY_OK);
	    return EventDefine.E_QUERY_RESULT;
	}
	
	// 협력업체 구분 목록
	public int E094(InoutParameter ioParam){		
				
		try {
			con = JDBCConnectionPool.getConnection();
			
			String sql = new StringBuilder()
					.append("SELECT						\n")
					.append("	code_value,				\n")
					.append("   code_name				\n")
					.append("FROM						\n")
					.append("	tbm_code_book			\n")
					.append("WHERE						\n")
					.append("	code_cd = 'CUSTOMER_GUBUN_BIG'	\n")
					.append("	AND order_index > 0		\n")
					.toString();
	
			resultString = super.excuteQueryString(con, sql);
			
		} catch(Exception e) {
			LoggingWriter.setLogError("M000S010100E094()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
			try {
				if (con != null) con.close();
			} catch (Exception e) {
				LoggingWriter.setLogError("M000S010100E094()","==== finally ===="+ e.getMessage());
			}
	    }
	
		ioParam.setResultString(resultString);
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
		ioParam.setMessage(MessageDefine.M_QUERY_OK);
	    return EventDefine.E_QUERY_RESULT;
	}
	
	//// 0607 서승헌
	// 금속검출기 리스트 
	public int E104(InoutParameter ioParam){		
				
		try {
			con = JDBCConnectionPool.getConnection();
			
			String sql = new StringBuilder()
					.append("SELECT\n")
					.append("	censor_no,\n")
					.append("	censor_name,\n")
					.append("	censor_location \n")
					.append("FROM\n")
					.append("	haccp_censor_info\n")
					.append("WHERE\n")
					.append("	censor_type LIKE 'METAL'\n")
					.append("	AND delyn = 'N'\n")
					.append("	AND SYSDATE BETWEEN start_date AND duration_date\n")
					.toString();
	
			resultString = super.excuteQueryString(con, sql);
			
		} catch(Exception e) {
			LoggingWriter.setLogError("M000S010100E104()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
			try {
				if (con != null) con.close();
			} catch (Exception e) {
				LoggingWriter.setLogError("M000S010100E104()","==== finally ===="+ e.getMessage());
			}
	    }
	
		ioParam.setResultString(resultString);
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
		ioParam.setMessage(MessageDefine.M_QUERY_OK);
	    return EventDefine.E_QUERY_RESULT;
	}
		
	// 완제품 리스트 
	public int E114(InoutParameter ioParam){		
				
		try {
			con = JDBCConnectionPool.getConnection();
			
			String sql = new StringBuilder()
					.append("SELECT\n")
					.append("	prod_cd,\n")
					.append("	product_nm\n")
					.append("FROM\n")
					.append("	tbm_product\n")
					.append("WHERE\n")
					.append("	SUBSTR(prod_gubun_m, -2, 2) IN ('01', '02')\n")
					.append("	AND delyn = 'N' \n")
					.append("	AND SYSDATE BETWEEN start_date AND duration_date\n")
					.append("ORDER BY product_nm ASC\n")
					.toString();
	
			resultString = super.excuteQueryString(con, sql);
			
		} catch(Exception e) {
			LoggingWriter.setLogError("M000S010100E114()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
			try {
				if (con != null) con.close();
			} catch (Exception e) {
				LoggingWriter.setLogError("M000S010100E114()","==== finally ===="+ e.getMessage());
			}
	    }
	
		ioParam.setResultString(resultString);
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
		ioParam.setMessage(MessageDefine.M_QUERY_OK);
	    return EventDefine.E_QUERY_RESULT;
	}
	
	// 코드목록 getCodeList()
	public int E124(InoutParameter ioParam){		
		
		try {
			con = JDBCConnectionPool.getConnection();
			String code_cd = (String)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			
			String sql = new StringBuilder()
					.append("SELECT\n")
					.append("	code_cd,\n")
					.append("	code_value,\n")
					.append("	code_name\n")
					.append("FROM\n")
					.append("	vtbm_code_book\n")
					.append("WHERE code_cd = UPPER('"+code_cd+"')\n")
					.append("	AND order_index > 0\n")
					.toString();

			resultString = super.excuteQueryString(con, sql);
			
		} catch(Exception e) {
			LoggingWriter.setLogError("M000S010100E124()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
			try {
				if (con != null) con.close();
			} catch (Exception e) {
				LoggingWriter.setLogError("M000S010100E124()","==== finally ===="+ e.getMessage());
			}
	    }
	
		ioParam.setResultString(resultString);
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
		ioParam.setMessage(MessageDefine.M_QUERY_OK);
	    return EventDefine.E_QUERY_RESULT;
	}
}