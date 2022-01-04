package mes.frame.business.M707;

import java.lang.reflect.Method;
import java.sql.Connection;
import java.sql.PreparedStatement;

import mes.client.conf.Config;
import mes.frame.common.EventDefine;
import mes.frame.common.HashObject;
import mes.frame.common.MessageDefine;
import mes.frame.database.JDBCConnectionPool;
import mes.frame.database.SqlAdapter;
import mes.frame.serviceinterface.InoutParameter;
import mes.frame.serviceinterface.LoggingWriter;
import mes.frame.util.CommonFunction;

public class M707S32100 extends SqlAdapter{
	Connection con = null;
	PreparedStatement pstmt = null;
	String resultString = "";
	int resultInt = -1;
	StringBuffer sql = new StringBuffer();
	
	String[][] v_paramArray = new String[0][0]; 
	Class[] optClass = null;
	Object[] optObj = null;
	Object obj = null;
	
	public M707S32100(){
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
			
			Method method = M707S32100.class.getMethod(event,optClass);
			LoggingWriter.setLogDebug(M707S32100.class.getName(),"==== " + event + " EventMethod Create Success ====");

			obj = method.invoke(M707S32100.class.newInstance(),optObj);
			doExcute_result = CommonFunction.getInt(obj.toString());
			
	    } catch (Exception ex) {
	    	doExcute_result = EventDefine.E_DOEXCUTE_INIT;
			ioParam.setMessage(MessageDefine.M_NO_EVENTID);
			LoggingWriter.setLogError(M707S32100.class.getName(),"==== EventID Not define : EVENT ID [ " + ioParam.getEventID() + "]");
	    } finally {
	    	obj = null;
			optClass = null;
			optObj = null;
	    }
	    long endTime = System.currentTimeMillis();
		long runningTime = endTime - startTime;
		LoggingWriter.setLogAll(M707S32100.class.getName(),"==== Query [수행시간  : " + runningTime + " ms]");
		
		return doExcute_result;
	}
	
	// autoDepotIoHistInsert
	// autoDepotIoHistInsert
	public int E001(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			// 클라이언트로 부터 받은 파라미터를 옮겨 담는다.
			String rcvData = (String)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			
			// 클라이언트로 부터 받은 파라미터를 쪼개어서 배열에 담는다.
			String[][] c_paramArray = CommonFunction.getConvString2DoubleArray(rcvData);

			String sql = new StringBuilder()
					.append("INSERT INTO tb_change_parthist 	\n")
					.append("	(								\n")
					.append("		req_date,					\n")
					.append("		req_seqno,					\n")
					.append("		req_task_seqno,				\n")
					.append("		part_code,					\n")
					.append("		suryang,					\n")
					.append("		real_danga,					\n")
					.append("		real_gongim,				\n")
					.append("		bigo,						\n")
					.append("		member_key					\n")
					.append(") VALUES (							\n")
					.append("	'" + c_paramArray[0][0] + "'	\n") //req_date
					.append("	,'" + c_paramArray[0][1] + "'	\n") //req_seqno
					//.append("	,(select coalesce(MAX(req_task_seqno),0)+1 from TB_CHANGE_PARTHIST where REQ_DATE='" + c_paramArray[0][0] + "' and REQ_SEQNO='" + c_paramArray[0][1] + "')	\n") //req_task_seqno
					.append("	,'" + c_paramArray[0][2] + "'	\n") //req_task_seqno
					.append("	,'" + c_paramArray[0][3] + "'	\n") //part_code
					.append("	,'" + c_paramArray[0][4] + "'	\n") //suryang
					.append("	,'0'	\n") //real_danga
					.append("	,'0'	\n") //real_gongim
					.append("	,'')	\n") //bigo
					.append("	,'" + c_paramArray[0][5] + "'	\n") //member_key
					.toString();

			// System.out.println(sql.toString());

			// super의 excuteUpdate는 3가지가 있다.
			// 첫째는 super.excuteUpdate(con, sql.toString(), v_paramArray)형태 이며,
			// PreparedStatement를 사용하기 위해 파라미터들을 배령에 담아 보낸면 체크를 해서 수행하는 구조이다. 그리고
			// 두번째는 super.excuteUpdate(con, Vector)인데, 멀티 로우를 등록하기 위해 마련된 장치이다.
			// 세번째는 하나의 SQL을 String으로 받아서 처리하는 경우이다.
			// 현재 위의 SQL형태라면.. 당연히 1개의 로우에 해당되므로 세번째 메쏘드를 사용하는 것이 편하다.
			
			resultInt = super.excuteUpdate(con, sql.toString());
			if (resultInt <= 0) {
				ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
			} else {
				ioParam.setMessage(resultInt + "건 " + MessageDefine.M_INSERT_RESULT);
			}
		} catch(Exception e) {
			LoggingWriter.setLogError("M707S32100E001()","==== SQL ERROR ===="+ e.getMessage() + "\n" + sql.toString());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M707S32100E001()","==== finally ===="+ e.getMessage());
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

	public int E003(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			// 클라이언트로 부터 받은 파라미터를 옮겨 담는다.
			String rcvData = (String)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			
			// 클라이언트로 부터 받은 파라미터를 쪼개어서 배열에 담는다.
			String[][] c_paramArray = CommonFunction.getConvString2DoubleArray(rcvData);

			sql = new StringBuffer();
			sql.append(" delete from TB_CHANGE_PARTHIST 	\n");
			sql.append(" 	where REQ_DATE = '" + c_paramArray[0][0] + "' \n"); 
			sql.append(" 		and REQ_SEQNO = '" + c_paramArray[0][1] + "' \n"); 
			sql.append(" 		and REQ_TASK_SEQNO = '" + c_paramArray[0][2] + "' \n"); 
			sql.append(" 		and member_key = '" + c_paramArray[0][3] + "' \n"); 

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
			LoggingWriter.setLogError("M707S32100E003()","==== SQL ERROR ===="+ e.getMessage() + "\n" + sql.toString());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M707S32100E003()","==== finally ===="+ e.getMessage());
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

	// 이력조건에 해당하는 거래처 목록을 GROUP BY 검색한다. 
	public int E004(InoutParameter ioParam){ // 안쓰는 메소드	안쓰는 메소드	안쓰는 메소드	
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			// 클라이언트로 부터 받은 파라미터를 옮겨 담는다.
			String rcvData = (String)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			// 클라이언트로 부터 받은 파라미터를 쪼개어서 배열에 담는다.
			// rcvData = [위경도]
			String[][] c_paramArray = CommonFunction.getConvString2DoubleArray(rcvData);
			
			// {"원부자재코드", "원부자재명", "구품번", "구도번", "단위중량", "규격", "안전재고", "열처리", "재질", "후처리"  }
			
			sql = new StringBuffer();
			sql.append(" 	select \n"); 
			sql.append(" 				PART_CD \n"); 
			sql.append(" 				,coalesce(PART_NM, ' ') as PART_NM \n"); 
			sql.append(" 				,coalesce(OLD_PARTCODE, ' ') as OLD_PARTCODE \n"); 
			sql.append(" 				,coalesce(OLD_DWG, ' ') as OLD_DWG \n"); 
			sql.append(" 				,coalesce(UNIT_WEIGHT, '0') as UNIT_WEIGHT \n"); 
			sql.append(" 				,coalesce(GYUGYEOK, ' ') as GYUGYEOK \n"); 
			sql.append(" 				,coalesce(SAFETY_JAEGO, '0') as SAFETY_JAEGO \n"); 
			sql.append(" 				,coalesce(P_HEAT, ' ') as P_HEAT \n"); 
			sql.append(" 				,coalesce(P_MATERIAL, ' ') as P_MATERIAL \n"); 
			sql.append(" 				,coalesce(P_AFTER_TREAT, ' ') as P_AFTER_TREAT \n"); 
			sql.append(" 				-- ,coalesce(SAVE_MACHINE, 0)+'-'+coalesce(SAVE_CARRIER, 0)+'-'+coalesce(SAVE_BEANS, 0)+'-'+coalesce(SAVE_BEAN, 0) as SAVE_POSITION \n"); 
			sql.append(" 				-- ,coalesce( (select POST_AMT from AD_IO_HIST where rownum=1 and PARTCODE=pl.PARTCODE order by IO_DATE desc, IO_SEQNO desc), 0.0 ) as SAVE_AMT \n"); 
			sql.append(" 			from TB_PARTLIST pl \n"); 
			sql.append(" 			where " + c_paramArray[0][0] + "  \n"); 
			
			String ActionCommand = ioParam.getActionCommand();
			if(ActionCommand.startsWith("doQueryTableFieldName")) {
				resultString = super.excuteQueryStringTableFieldName(con, sql.toString());
			}
			else {;
				resultString = super.excuteQueryString(con, sql.toString());
			}
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M707S32100E004()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M707S32100E004()","==== finally ===="+ e.getMessage());
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

	public int E014(InoutParameter ioParam){ // 안쓰는 메소드	안쓰는 메소드	안쓰는 메소드
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			// 클라이언트로 부터 받은 파라미터를 옮겨 담는다.
			String rcvData = (String)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			// 클라이언트로 부터 받은 파라미터를 쪼개어서 배열에 담는다.
			// rcvData = [위경도]
			String[][] c_paramArray = CommonFunction.getConvString2DoubleArray(rcvData);
			
			sql = new StringBuffer();
			sql.append(" 			select  \n"); 
			sql.append(" 		 		A.SAVE_LOCATION as SAVE_LOCATION  \n"); 
			sql.append(" 		 		,(select POST_AMT from tbi_part_storage_hist where PARTCODE=A.PARTCODE and SAVE_LOCATION=A.SAVE_LOCATION and rownum=1 order by IO_DATE desc, IO_SEQNO desc) as POST_AMT  \n"); 
			sql.append(" 		 		,(select IO_DATE from tbi_part_storage_hist where PARTCODE=A.PARTCODE and SAVE_LOCATION=A.SAVE_LOCATION and rownum=1 order by IO_DATE desc, IO_SEQNO desc) as IO_DATE  \n"); 
			sql.append(" 		 		,(select IO_TIME from tbi_part_storage_hist where PARTCODE=A.PARTCODE and SAVE_LOCATION=A.SAVE_LOCATION and rownum=1 order by IO_DATE desc, IO_SEQNO desc) as IO_TIME  \n"); 
			sql.append(" 		 		,(select PRE_AMT from tbi_part_storage_hist where PARTCODE=A.PARTCODE and SAVE_LOCATION=A.SAVE_LOCATION and rownum=1 order by IO_DATE desc, IO_SEQNO desc) as PRE_AMT  \n"); 
			sql.append(" 		 		,(select coalesce(decode(IO_GUBUN, 'I', '입고', 'O', '출고'), '뭐지') from tbi_part_storage_hist where PARTCODE=A.PARTCODE and SAVE_LOCATION=A.SAVE_LOCATION and rownum=1 order by IO_DATE desc, IO_SEQNO desc) as IO_GUBUN  \n"); 
			sql.append(" 		 		,(select IO_AMT from tbi_part_storage_hist where PARTCODE=A.PARTCODE and SAVE_LOCATION=A.SAVE_LOCATION and rownum=1 order by IO_DATE desc, IO_SEQNO desc) as IO_AMT  \n"); 
			sql.append(" 		 		,(select BIGO_TXT from tbi_part_storage_hist where PARTCODE=A.PARTCODE and SAVE_LOCATION=A.SAVE_LOCATION and rownum=1 order by IO_DATE desc, IO_SEQNO desc) as BIGO  \n"); 
			sql.append(" 		 		,(select IO_SEQNO from tbi_part_storage_hist where PARTCODE=A.PARTCODE and SAVE_LOCATION=A.SAVE_LOCATION and rownum=1 order by IO_DATE desc, IO_SEQNO desc) as IO_SEQNO  \n"); 
			sql.append(" 		 	from tbi_part_storage_hist A  \n"); 
			sql.append(" 		 	where  A.PARTCODE = '" + c_paramArray[0][0] + "'  \n"); 
			sql.append(" 		 	group by  A.SAVE_LOCATION, A.PARTCODE  \n"); 
			
			String ActionCommand = ioParam.getActionCommand();
			if(ActionCommand.startsWith("doQueryTableFieldName")) {
				resultString = super.excuteQueryStringTableFieldName(con, sql.toString());
			}
			else {;
				resultString = super.excuteQueryString(con, sql.toString());
			}
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M707S32100E014()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M707S32100E014()","==== finally ===="+ e.getMessage());
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

	public int E024(InoutParameter ioParam){ // 안쓰는 메소드	안쓰는 메소드	안쓰는 메소드
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			// 클라이언트로 부터 받은 파라미터를 옮겨 담는다.
			String rcvData = (String)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			// 클라이언트로 부터 받은 파라미터를 쪼개어서 배열에 담는다.
			// rcvData = [위경도]
			String[][] c_paramArray = CommonFunction.getConvString2DoubleArray(rcvData);
			
			// {"원부자재코드", "원부자재명", "구품번", "구도번", "단위중량", "규격", "안전재고", "열처리", "재질", "후처리"  }
			
			sql = new StringBuffer();
			sql.append(" 	select \n"); 
			sql.append(" 		MAX(REQ_TASK_SEQNO)  				\n"); 
			sql.append(" 	from TB_REQ_TASKHIST pl 							\n"); 
			sql.append(" 	where REQ_DATE = '" + c_paramArray[0][0] + "' 		\n"); 
			sql.append(" 		and REQ_SEQNO = '" + c_paramArray[0][1] + "' 	\n"); 
			
			String ActionCommand = ioParam.getActionCommand();
			if(ActionCommand.startsWith("doQueryTableFieldName")) {
				resultString = super.excuteQueryStringTableFieldName(con, sql.toString());
			}
			else {;
				resultString = super.excuteQueryString(con, sql.toString());
			}
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M707S32100E024()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M707S32100E024()","==== finally ===="+ e.getMessage());
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