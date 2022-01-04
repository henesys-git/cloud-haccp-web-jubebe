package mes.frame.business.M909;

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


public class M909S200100 extends SqlAdapter{
	Connection con = null;
	PreparedStatement pstmt = null;
	String resultString = "";
	int resultInt = -1;
	StringBuffer sql = new StringBuffer();
	
	String[][] v_paramArray = new String[0][0]; 
	Class[] optClass = null;
	Object[] optObj = null;
	Object obj = null;
	
	public M909S200100(){
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
			
			Method method = M909S200100.class.getMethod(event,optClass);
			LoggingWriter.setLogDebug(M909S200100.class.getName(),"==== " + event + " EventMethod Create Success ====");

			obj = method.invoke(M909S200100.class.newInstance(),optObj);
			doExcute_result = CommonFunction.getInt(obj.toString());
			
	    } catch (Exception ex) {
	    	doExcute_result = EventDefine.E_DOEXCUTE_INIT;
			ioParam.setMessage(MessageDefine.M_NO_EVENTID);
			LoggingWriter.setLogError(M909S200100.class.getName(),"==== EventID Not define : EVENT ID [ " + ioParam.getEventID() + "]");
	    } finally {
	    	obj = null;
			optClass = null;
			optObj = null;
	    }
	    long endTime = System.currentTimeMillis();
		long runningTime = endTime - startTime;
		LoggingWriter.setLogAll(M909S200100.class.getName(),"==== Query [수행시간  : " + runningTime + " ms]");
		
		return doExcute_result;
	}
	//노무정보 등록
	public int E101(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		String sql = "";
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject(); // JSONObject 선언
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			
			
			sql = new StringBuilder()
					.append(" INSERT INTO tbi_working_info(						\n")
					.append(" 		working_rev_no,								\n") //노무정보 수정이력번호
					.append(" 		worker_count,								\n") //총 노무인원
					.append(" 		working_day_count,							\n") //월 근무일수
					.append(" 		produce_cost_all, 							\n") //제조경비총계
					.append(" 		indirect_cost,  							\n") //간접비
					.append(" 		working_info_date,     				  		\n") //기준일자
					.append(" 	    working_cost_all_real, 						\n") //실 노무비 총계
					.append("		register_date,								\n") //등록일자
					.append("       bigo 	 									\n") //비고
					.append("       ) 											\n")
					.append("		VALUES(	  									\n")
					.append("   	0, 											\n")
					.append("		'"+jArray.get("WorkerCount")+"',			\n")
					.append("		'"+jArray.get("WorkingDayCount")+"',		\n")
					.append("		'"+jArray.get("ProdCost")+"',				\n")
					.append("		'"+jArray.get("IndirectCost")+"',			\n")
					.append("		'"+jArray.get("StandardDate")+"',			\n")
					.append("		'"+jArray.get("WorkingCost")+"',			\n")
					.append("       SYSDATE, 									\n")
					.append("  		'"+jArray.get("Bigo")+"' 					\n")
					.append("       ) 											\n")
					.toString();

			resultInt = super.excuteUpdate(con, sql.toString());
			if (resultInt < 0) {
				ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
				con.rollback();
				return EventDefine.E_DOEXCUTE_ERROR;
			}
		
		con.commit();
		} catch(Exception e) {
			LoggingWriter.setLogError("M909S200100E101()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M909S200100E101()","==== finally ===="+ e.getMessage());
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

	//노무정보 수정
	public int E102(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		String sql = "";
		
		try {
			con = JDBCConnectionPool.getConnection();
			con.setAutoCommit(false);
			
			JSONObject jArray = new JSONObject(); // JSONObject 선언
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			
			//tbi_working_info 테이블의 데이터를 수정하면서 rev_no에 + 1 시켜준다.
			sql = new StringBuilder()
					.append(" INSERT INTO tbi_working_info(						\n")
					.append(" 		working_rev_no,								\n") //노무정보 수정이력번호
					.append(" 		worker_count,								\n") //총 노무인원
					.append(" 		working_day_count,							\n") //월 근무일수
					.append(" 		produce_cost_all, 							\n") //제조경비총계
					.append(" 		indirect_cost,  							\n") //간접비
					.append(" 		working_info_date,     				  		\n") //기준일자
					.append(" 	    working_cost_all_real, 						\n") //실 노무비 총계
					.append("		register_date,								\n") //등록일자
					.append("       bigo 	 									\n") //비고
					.append("       ) 											\n")
					.append("		VALUES(	  									\n")
					.append("   	'"+jArray.get("WorkingRevNo")+"' + 1, 		\n")
					.append("		'"+jArray.get("WorkerCount")+"',			\n")
					.append("		'"+jArray.get("WorkingDayCount")+"',		\n")
					.append("		'"+jArray.get("ProdCost")+"',				\n")
					.append("		'"+jArray.get("IndirectCost")+"',			\n")
					.append("		'"+jArray.get("StandardDate")+"',			\n")
					.append("		'"+jArray.get("WorkingCost")+"',			\n")
					.append("       SYSDATE, 									\n")
					.append("  		'"+jArray.get("Bigo")+"' 					\n")
					.append("       ); 											\n")
					.toString();

			resultInt = super.excuteUpdate(con, sql);
			if (resultInt < 0) {
				ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
				con.rollback();
				return EventDefine.E_DOEXCUTE_ERROR;
			}
			
			//tbi_working_info_detail 테이블 rev_no에 + 1 시켜준다.
			sql = new StringBuilder()
					.append(" UPDATE tbi_working_info_detail						 	 \n")
					.append(" SET working_rev_no = '"+jArray.get("WorkingRevNo")+"' + 1  \n")
					.append(" WHERE MONTH(working_info_date) = MONTH('"+jArray.get("StandardDate")+"') \n")
					.append(" ; 													 	 \n")
					.toString();

			resultInt = super.excuteUpdate(con, sql);
			if (resultInt < 0) {
				ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
				con.rollback();
				return EventDefine.E_DOEXCUTE_ERROR;
			} 
			
			con.commit();
		} catch(Exception e) {
			LoggingWriter.setLogError("M909S200100E102()","==== SQL ERROR ===="+ e.getMessage());
			e.printStackTrace();
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M909S200100E102()","==== finally ===="+ e.getMessage());
				}
	    	} else {
	    	}
	    }
		ioParam.setResultString(resultString);
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
    	ioParam.setMessage(MessageDefine.M_QUERY_OK);
	    return EventDefine.E_QUERY_RESULT;
	}

	
	//노무정보 삭제
	public int E103(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		String sql = "";
		
		try {
			con = JDBCConnectionPool.getConnection();
			con.setAutoCommit(false);
			
			JSONObject jArray = new JSONObject(); // JSONObject 선언
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			
			//tbi_working_info 테이블 데이터를 삭제한다.
			sql = new StringBuilder()
					.append(" DELETE FROM tbi_working_info						    	  \n")
					.append(" WHERE TO_CHAR(working_info_date, 'YYYY-MM') = '"+jArray.get("Standard_Yearmonth")+"' \n")
					.toString();

			resultInt = super.excuteUpdate(con, sql);
			if (resultInt < 0) {
				ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
				con.rollback();
				return EventDefine.E_DOEXCUTE_ERROR;
			} 
			
			// 그리고 tbi_working_info_detail 테이블  working_rev_no를 다시 0으로 update
			sql = new StringBuilder()
					.append(" UPDATE tbi_working_info_detail						 	 \n")
					.append(" SET working_rev_no = 0  									 \n")
					.append(" WHERE working_info_date = '"+jArray.get("StandardDate")+"' \n")
					.append("  ; 											 		 	 \n")
					.toString();

			resultInt = super.excuteUpdate(con, sql);
			if (resultInt < 0) {
				ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
				con.rollback();
				return EventDefine.E_DOEXCUTE_ERROR;
			} 
		
			con.commit();
		} catch(Exception e) {
			LoggingWriter.setLogError("M909S200100E103()","==== SQL ERROR ===="+ e.getMessage());
			e.printStackTrace();
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M909S200100E103()","==== finally ===="+ e.getMessage());
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

	
	//노무정보 메인페이지
	public int E104(InoutParameter ioParam) {
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			System.out.println("JSONObject jArray rcvData="+ jArray.toString());

			
			String sql = new StringBuilder()
			.append(" SELECT													  \n")
			.append(" 		TO_CHAR(A.working_info_date, 'YYYY-MM') AS standard_yearmonth, \n") //기준연월
			.append("       A.working_info_date, 								  \n") //기준일자
			.append(" 		A.worker_count,										  \n") //총 노무인원
			.append(" 		A.working_day_count,								  \n") //월 근무일수
			.append(" 		(A.produce_cost_all - A.indirect_cost)/A.worker_count/A.working_day_count/8 AS working_cost_per_hour, \n") //인당 인건비(시간)
			.append(" 		(A.produce_cost_all - A.indirect_cost)/A.worker_count/A.working_day_count   AS working_cost_per_day,  \n") //인당 인건비(일)
			.append(" 		(A.produce_cost_all - A.indirect_cost)/A.worker_count AS working_cost_per_month,     				  \n") //인당 인건비(월)
			.append(" 		SUM(B.working_time) AS duration_time,				  \n") //소요시간 총계
			.append(" 	    (A.produce_cost_all - A.indirect_cost)/A.worker_count/A.working_day_count/8*SUM(B.working_time) AS working_cost_real, \n") //노무비 총계
			.append("		A.working_cost_all_real,							  \n") //실제 노무비 총계
			.append("		A.indirect_cost,									  \n") //간접비
			.append("		A.produce_cost_all-A.indirect_cost AS direct_cost,	  \n") //직접비
			.append("		A.produce_cost_all,									  \n") //제조경비총계
			.append(" 		A.bigo,												  \n") //비고
			.append("       A.working_rev_no 									  \n") //노무정보 수정이력번호
			.append(" FROM tbi_working_info A									  \n")
			.append(" INNER JOIN tbi_working_info_detail B 						  \n")
			.append(" ON A.working_rev_no = B.working_rev_no 					  \n")
			.append(" AND MONTH(A.working_info_date) = MONTH(B.working_info_date) \n")
			.append(" WHERE A.working_rev_no = (SELECT MAX(working_rev_no) FROM   \n")
			.append("    						tbi_working_info C  			  \n")
			.append("                           WHERE A.working_info_date = C.working_info_date)\n")
			.append(" AND A.working_info_date BETWEEN '"+jArray.get("fromDate")+"' \n")
			.append(" AND '"+jArray.get("toDate")+"' 							  \n")
			.append(" GROUP BY A.working_info_date  							  \n")
			.append(" ORDER BY A.working_info_date DESC  						  \n")
			.toString();

			resultString = super.excuteQueryString(con, sql.toString());
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M909S200100E104()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M909S200100E104()","==== finally ===="+ e.getMessage());
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
	
	//노무정보 서브페이지
	public int E114(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			// 클라이언트로 부터 받은 파라미터를 옮겨 담는다.
			//String rcvData = (String)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			// 클라이언트로 부터 받은 파라미터를 쪼개어서 배열에 담는다.
			//{ "설비코드", "업무구분", "기관명", "수리내용", "반출일", "완료일", "담당자", "비용", "비고", "SEQ_NO"};
			
			//String[][] c_paramArray = CommonFunction.getConvString2DoubleArray(rcvData);
			
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			
			String sql = new StringBuilder()
					.append(" SELECT 										\n") 
					.append("       A.working_info_date,  					\n") //날짜
					.append(" 		A.prod_cd,								\n") //완제품코드
					.append(" 		B.product_nm,							\n") //완제품명
					.append("       A.working_time, 						\n") //소요시간
					.append("       A.working_rev_no    					\n") //노무정보 수정이력번호
					.append(" FROM tbi_working_info_detail A			 	\n")
					.append(" INNER JOIN tbm_product B						\n")
					.append(" ON A.prod_cd = B.prod_cd  					\n")
					.append(" AND A.prod_rev_no = B.revision_no  			\n")
					.append(" WHERE TO_CHAR(A.Working_info_date,'YYYY-MM') = '"+ jArray.get("standard_yearmonth")+"'  \n")
					.append(" AND   A.working_rev_no = '"+ jArray.get("working_rev_no")+"' 					\n")
					.append(" ORDER BY A.working_info_date ASC, A.prod_cd DESC 								\n")
					.toString();
			
			resultString = super.excuteQueryString(con, sql.toString());
			
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M909S200100E114()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M909S200100E114()","==== finally ===="+ e.getMessage());
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