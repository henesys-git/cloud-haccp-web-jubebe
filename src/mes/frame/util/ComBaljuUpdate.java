package mes.frame.util;

import java.lang.reflect.Method;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.util.Vector;

import mes.frame.common.EventDefine;
import mes.frame.common.HashObject;
import mes.frame.common.MessageDefine;
import mes.frame.database.JDBCConnectionPool;
import mes.frame.database.SqlAdapter;
import mes.frame.serviceinterface.InoutParameter;
import mes.frame.serviceinterface.LoggingWriter;
import mes.frame.util.CommonFunction;


public class ComBaljuUpdate extends SqlAdapter{
//	Connection con = null;
	PreparedStatement pstmt = null;
	String resultString = "";
	int resultInt = -1;
	StringBuffer sql = new StringBuffer();
	
	String[][] v_paramArray = new String[0][0]; 
	Class[] optClass = null;
	Object[] optObj = null;
	Object obj = null;
	
	public ComBaljuUpdate(){
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
			
			Method method = ComBaljuUpdate.class.getMethod(event,optClass);
			LoggingWriter.setLogDebug(ComBaljuUpdate.class.getName(),"==== " + event + " EventMethod Create Success ====");

			obj = method.invoke(ComBaljuUpdate.class.newInstance(),optObj);
			doExcute_result = CommonFunction.getInt(obj.toString());
			
	    } catch (Exception ex) {
	    	doExcute_result = EventDefine.E_DOEXCUTE_INIT;
			ioParam.setMessage(MessageDefine.M_NO_EVENTID);
			LoggingWriter.setLogError(ComBaljuUpdate.class.getName(),"==== EventID Not define : EVENT ID [ " + ioParam.getEventID() + "]");
	    } finally {
	    	obj = null;
			optClass = null;
			optObj = null;
	    }
	    long endTime = System.currentTimeMillis();
		long runningTime = endTime - startTime;
		LoggingWriter.setLogAll(ComBaljuUpdate.class.getName(),"==== Query [수행시간  : " + runningTime + " ms]");
		
		return doExcute_result;
	}
	

	public int comTBI_BALJU_list_Status_Update(Connection mCon, String mBALJU_REQ_DATE, String mBALJU_NO, String mStatus, String sPart_cd){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		try {
//			GV_BALJU_NO + "|" + GV_BALJU_REQ_DATE + "|" + GV_BALJU_STATUS + "|"
			sql = new StringBuffer();
			sql.append(" update tbi_balju_list set	\n");
			sql.append("   BALJU_STATUS = "
					+ "(SELECT	MIN(code_cd) FROM v_balju_status WHERE code_cd > '" + mStatus + "')  \n");
			sql.append("where "
					+ "	BALJU_REQ_DATE  = '" + mBALJU_REQ_DATE + "' 	\n");
			sql.append(" 	and BALJU_NO = '" + mBALJU_NO + "'		\n");
			sql.append(" 	and part_cd  = '" + sPart_cd + "'				\n");
			resultInt = super.excuteUpdate(mCon, sql.toString());
			
		} catch(Exception e) {
			LoggingWriter.setLogError("ComBaljuUpdate.E001_TBI_BALJU_list_Update()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } 
	    return resultInt;
	}
	
	public int TBI_BALJU_Status_Update(Connection mCon, String mBALJU_REQ_DATE, String mBALJU_NO, String mStatus){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			sql = new StringBuffer();
			sql.append(" update tbi_balju set					\n");
			sql.append("   BALJU_STATUS = '"	+ mStatus + "'  \n");
			sql.append("where BALJU_REQ_DATE = '" + mBALJU_REQ_DATE + "'  \n");
			sql.append("  and BALJU_NO = '" 	+ mBALJU_NO + "' \n");
			resultInt = super.excuteUpdate(mCon, sql.toString());
			
		} catch(Exception e) {
			LoggingWriter.setLogError("ComBaljuUpdate.E001_TBI_BALJU_Update()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } 
	    return resultInt;
	}	
	
	public int comTBI_BALJU_Status_Update(Connection mCon, String mBALJU_REQ_DATE, String mBALJU_NO, String mStatus){ 
			resultInt = EventDefine.E_DOEXCUTE_INIT;

			int listCnt=0, nextStatuscnt=0;
			try {

				//전체 발주리스트 Count
				String sql = new StringBuilder()
						.append("SELECT COUNT(*)		\n")
						.append("FROM tbi_balju_list		\n")
						.append("where BALJU_REQ_DATE = '"	+ mBALJU_REQ_DATE + "' \n")
						.append("        and BALJU_NO = '" 							+ mBALJU_NO + "' \n")
						.toString();
				 listCnt = Integer.parseInt(super.excuteQueryString(mCon, sql.toString()).trim());
				
				//GV_NEXT_STATUS Count(수입검사완료 상태)
				 sql = new StringBuilder()
							.append("SELECT COUNT(*)		\n")
							.append("FROM tbi_balju_list		\n")
							.append("where BALJU_REQ_DATE = '"	+ mBALJU_REQ_DATE + "' 	\n")
							.append("        and BALJU_NO = '" 							+ mBALJU_NO + "'	\n")
							.append("        and BALJU_STATUS = '" 						+ mStatus + "' 			\n")
							.toString();
				 nextStatuscnt = Integer.parseInt(super.excuteQueryString(mCon, sql.toString()).trim());
				 
		    	if(listCnt==nextStatuscnt) {
		    		resultInt = TBI_BALJU_Status_Update(mCon, mBALJU_REQ_DATE, mBALJU_NO, mStatus);
			    	if(resultInt < 0){  //
			    		LoggingWriter.setLogError("ComBaljuUpdate.comTBI_BALJU_Update()","==== ERROR ===="+ MessageDefine.M_INSERT_FAILED);
						
			    		mCon.rollback();
						return EventDefine.E_DOEXCUTE_ERROR ;
					}
		    	}
		    	else {
		    		resultInt = 0;
		    	}
		    	
			} catch(Exception e) {
				LoggingWriter.setLogError("ComBaljuUpdate.comTBI_BALJU_Update()","==== SQL ERROR ===="+ e.getMessage());
				return EventDefine.E_DOEXCUTE_ERROR ;
		    } 
		    return resultInt;
	}	
	
}

