package mes.frame.business.M707;

import java.lang.reflect.Method;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.text.SimpleDateFormat;
import java.util.Date;
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
import mes.frame.util.*;
import mes.frame.util.StringUtil;

public class M707S020500 extends SqlAdapter{
	Connection con = null;
	PreparedStatement pstmt = null;
	String resultString = "";
	int resultInt = -1;
	StringBuffer sql = new StringBuffer();
	
	String[][] v_paramArray = new String[0][0]; 
	Class[] optClass = null;
	Object[] optObj = null;
	Object obj = null;
	
	public M707S020500(){
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
			
			Method method = M707S020500.class.getMethod(event,optClass);
			LoggingWriter.setLogDebug(M707S020500.class.getName(),"==== " + event + " EventMethod Create Success ====");

			obj = method.invoke(M707S020500.class.newInstance(),optObj);
			doExcute_result = CommonFunction.getInt(obj.toString());
			
	    } catch (Exception ex) {
	    	doExcute_result = EventDefine.E_DOEXCUTE_INIT;
			ioParam.setMessage(MessageDefine.M_NO_EVENTID);
			LoggingWriter.setLogError(M707S020500.class.getName(),"==== EventID Not define : EVENT ID [ " + ioParam.getEventID() + "]");
	    } finally {
	    	obj = null;
			optClass = null;
			optObj = null;
	    }
	    long endTime = System.currentTimeMillis();
		long runningTime = endTime - startTime;
		LoggingWriter.setLogAll(M707S020500.class.getName(),"==== Query [수행시간  : " + runningTime + " ms]");
		
		return doExcute_result;
	}
	
	
	
	
	public int E104(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();			
			
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			System.out.println("JSONObject jArray rcvData="+ jArray.toString());
			
//			String rcvData = (String)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
//			String[][] c_paramArray = CommonFunction.getConvString2DoubleArray(rcvData);

			String sql = "";
			StringBuilder _sql = new StringBuilder()
					.append("WITH																														\n")
					.append("	_chulha AS																												\n")
					.append("	(																														\n")
					.append("		SELECT																												\n")
					.append("			order_no, lotno, SUM(chulha_cnt) AS Chulha_SUM, MAX(chuha_dt) AS Last_Chulha_Date, member_key					\n")
					.append("		FROM																												\n")
					.append("			( SELECT * FROM tbi_chulha_info WHERE member_key = '" + jArray.get("member_key") + "' ORDER BY chuha_dt ASC )	\n")
					.append("		GROUP BY order_no, lotno																							\n")
					.append("	),																														\n")
					// 주문별로 모든 (부분)출하량의 합과 제일 마지막 출하일자(이 때 모든 출하가 끝났을 수도 있고 아닐 수도 있음)를 구하는 임시 테이블
					.append("	_chulha_result AS																				\n")
					.append("	(																								\n")
					.append("		SELECT *																					\n")
					.append("		FROM																						\n")
					.append("		(																							\n")
					.append("			SELECT																					\n")
					.append("				O.order_no AS O_N, O.lotno AS L_N,													\n")
					.append("				O.order_date AS O_D, O.delivery_date AS D_D, C.Last_Chulha_Date AS L_C_D,			\n")
					.append("				IF(O.order_count = C.Chulha_SUM, C.Chulha_SUM, NULL) AS Chulha_Result,				\n")
					.append("				C.member_key																		\n")
					.append("			FROM tbi_order O																		\n")
					.append("			INNER JOIN _chulha C																	\n")
					.append("					ON O.order_no = C.order_no														\n")
					.append("					AND O.lotno = C.lotno															\n")
					.append("					AND O.member_key = C.member_key													\n")
					.append("		)																							\n")
					.append("		WHERE																						\n")
					.append("			Chulha_Result IS NOT NULL																\n");
			
			if( jArray.get("FLAG") == "avg" )
			{
				_sql.append("			AND L_C_D BETWEEN '" + jArray.get("fromdate") + "' AND '" + jArray.get("todate") + "'	\n");
			}
			else if( jArray.get("FLAG") == "list" )
			{
				_sql.append("			AND L_C_D = '" + jArray.get("_date") + "'												\n");
			}
					
				_sql.append("	),																								\n")
					// 주문별 모든 (부분)출하량의 합이 주문량과 같을때(출하 완료)와 다를때(출하 완료 X)를 판단하는 임시 테이블.
					// 출하 미완료시 출하결과(Chulha_Result) 칼럼 값이 NULL이 된다.
					// 또한 이 때의 최종출하일자가 프로그램에서 입력받은 날짜들 사이(fromdate ~ todate)에 있는 주문정보만 가져온다.
					// 즉, 선택된 범위 이내에 출하완료가 된 주문정보만 가져온다.
					.append("	_chulha_final AS									\n")
					.append("	(													\n")
					.append("		SELECT											\n")
					.append("			O_N, L_N, O_D, D_D, L_C_D, C_S,				\n")
					.append("			CASE C_S									\n")
					.append("				WHEN 'FAST' THEN 1						\n")
					.append("				WHEN 'SLOW' THEN 0						\n")
					.append("			END AS C_S_V,								\n")
					.append("			member_key									\n")
					.append("		FROM											\n")
					.append("		(												\n")
					.append("			SELECT										\n")
					.append("				O_N, L_N, O_D, D_D, L_C_D,				\n")
					.append("				IF(D_D < L_C_D,'SLOW','FAST') AS C_S,	\n")
					.append("				member_key								\n")
					.append("			FROM										\n")
					.append("				_chulha_result							\n")
					.append("		)												\n")
					.append("	)													\n");
					// 출하 완료된 주문들의 출하 속도를 판단하는 임시 테이블.
					// 실제 출하일자가 예상 출하일자보다 느릴 때 : C_S_V = 0
					// 같거나 빠를 때 : C_S_V = 1
			
			if( jArray.get("FLAG") == "avg" )
			{
				_sql.append("SELECT															\n")
					.append("		member_key, L_C_D, FORMAT( AVG(C_S_V), 2 ) AS A_C_S_V	\n")
					.append("FROM															\n")
					.append("		_chulha_final											\n")
					.append("GROUP BY L_C_D													\n")
					.toString();
				
				sql = _sql.toString();
			}
			else if( jArray.get("FLAG") == "list" )
			{
				_sql.append("SELECT O_N, L_N, O_D, D_D, L_C_D, C_S, DECODE(C_S_V,0,'지연',1,'준수'), member_key FROM _chulha_final	\n").toString();
				sql = _sql.toString();
			}
			
			String ActionCommand = ioParam.getActionCommand();
			if(ActionCommand.startsWith("doQueryTableFieldName")) {
				resultString = super.excuteQueryStringTableFieldName(con, sql.toString());
			}
			else {;
			resultString = super.excuteQueryString(con, sql.toString());
			}
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M707S020500E104()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
		} finally {
			if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M707S020500E104()","==== finally ===="+ e.getMessage());
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
