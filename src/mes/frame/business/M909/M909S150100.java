package mes.frame.business.M909;

import java.lang.reflect.Method;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;

import org.apache.log4j.Logger;
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


public class M909S150100 extends SqlAdapter {
	
	static final Logger logger = Logger.getLogger(M909S150100.class.getName());
	
	Connection con = null;
	Connection con_zip = null;
	Connection con_Mysql = null;
	PreparedStatement pstmt = null;
	String resultString = "";
	int resultInt = -1;
	StringBuffer sql = new StringBuffer();
	
	String[][] v_paramArray = new String[0][0]; 
	Class[] optClass = null;
	Object[] optObj = null;
	Object obj = null;
	
	public M909S150100(){
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

			Method method = M909S150100.class.getMethod(event,optClass);
			logger.debug(event + " EventMethod Create Success");

			obj = method.invoke(M909S150100.class.newInstance(),optObj);
			doExcute_result = CommonFunction.getInt(obj.toString());
			
	    } catch (Exception ex) {
	    	doExcute_result = EventDefine.E_DOEXCUTE_INIT;
			ioParam.setMessage(MessageDefine.M_NO_EVENTID);
			logger.debug("EventID Not define : EVENT ID [ " + ioParam.getEventID() + "]");
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
	

	public int E101(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			//con_Mysql = JDBCConnectionPool.getConnection_Mysql();
			
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			
			String sql = new StringBuilder()
					.append("INSERT INTO tbm_our_company_info(\n")
					.append("	bizno,\n")
					.append("	revision_no,\n")
					.append("	cust_nm,\n")
					.append("	address,\n")
					.append("	telno,\n")
					.append("	boss_name,\n")
					.append("	uptae,\n")
					.append("	jongmok,\n")
					.append("	faxno,\n")
					.append("	homepage,\n")
					.append("	zipno,\n")
					.append("	start_date,\n")
					.append("	create_date,\n")
					.append("	create_user_id,\n")
					.append("	duration_date,\n")
					.append("	seal_img_filename,\n")
					.append("	logo_img_filename,\n")
					.append("	haccp_no,\n")
					.append("	kape_openapi_userid,\n")
					.append("	kape_openapi_apikey,\n")
					.append(" 	member_key,	\n") // member_key_insert
					.append(" 	history_yn	\n") 
					.append(")VALUES (\n")
					.append("	'" + jArray.get("BizNo") + "',\n") //BizNo
					.append("	" + jArray.get("RevisionNo") + ",\n") //RevisionNo
					.append("	'" + jArray.get("Cust_nm") + "',\n") //Cust_nm
					.append("	'" + jArray.get("Juso") + "',\n") //Juso
					.append("	'" + jArray.get("TelNo") + "',\n") //TelNo
					.append("	'" + jArray.get("BossName") + "',\n") //BossName
					.append("	'" + jArray.get("Uptae") + "',\n") //Uptae
					.append("	'" + jArray.get("Jongmok") + "',\n") //Jongmok
					.append("	'" + jArray.get("Fax") + "',\n") //Fax
					.append("	'" + jArray.get("HomePage") + "',\n") //HomePage
					.append("	'" + jArray.get("Zipno") + "',\n") //Zipno
					.append("	'" + jArray.get("StartDate") + "',\n") //StartDate
					.append("	SYSDATE,\n")//SYSDATE
					.append("	'" + jArray.get("user_id") + "',\n") //user_id
					.append("	'9999-12-31',\n")
					.append("	'" + jArray.get("SealImageFileName") + "',\n") //SealImageFileName
					.append("	'" + jArray.get("LogoImageFileName") + "',\n") //LogoImageFileName
					.append("	'" + jArray.get("haccp_no") + "',\n") //haccp_no
					.append("	'" + jArray.get("kape_openapi_userid") + "',\n") //kape_openapi_userid
					.append("	'" + jArray.get("kape_openapi_apikey") + "',\n") //LogoImageFileName
					//.append(" 	'" + jArray.get("BizNo") + "', \n") //member_key_values
					.append(" 	'" + jArray.get("member_key") + "', \n")
					.append(" 	'" + jArray.get("hist_yn") + "' \n") //hist_yn
					.append(")\n")
					.toString();


					
				resultInt = super.excuteUpdate(con, sql.toString());
				if (resultInt < 0) {
					ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
				} else {
					ioParam.setMessage(resultInt + "건 " + MessageDefine.M_INSERT_RESULT);
				}
				
				if(con_Mysql == null) {
					System.out.println("Mysql 회사가입 이력남기기 사용 안함");
				} else { 
				
				sql = new StringBuilder()
						.append("insert into chnl_per_use_intt_ldgr (\n")
						.append("	CHNL_ID, \n")
						.append("	USE_INTT_ID, \n")
						.append("	PWD_INIT_USE_YN, \n")
						.append("	INIT_PWD, \n")
						.append("	APLC_DT, \n")
						.append("	ATHZ_DT, \n")
						.append("	STTS, \n")
						.append("	JNNG_ATHZ_DSNC, \n")
						.append("	RGSN_DTTM, \n")
						.append("	RGSR_ID, \n")
						.append("	AMNN_DTTM, \n")
						.append("	EDTR_ID\n")
						.append(") \n")
						.append("VALUES( \n")
						.append("	'CHNL_64', \n")
//						.append("	CONCAT('UTLZ', '_', IFNULL((REGEXP_REPLACE(MAX(USE_INTT_ID),'[A-Z_]','')+1) ,1)) ,\n")
//						.append("	CONCAT('UTLZ_', IFNULL(MAX(CAST(SUBSTRING(USE_INTT_ID,6,100) as UNSIGNED)),'UTLZ_1')+1),\n")
//						.append("	(SELECT CONCAT('UTLZ_', COALESCE(MAX(CAST(SUBSTR(USE_INTT_ID,6) AS DECIMAL))+ 1,1)) AS UTLZ_ID FROM CHNL_PER_USE_INTT_LDGR WHERE CHNL_ID = 'CHNL_64'),\n")
						.append("	'" + jArray.get("use_intt_id") +"',\n")
						.append("	'Y', \n")
						.append("	'qwer1234!', \n")
						.append("	DATE_FORMAT( NOW(), '%Y%m%d'), \n")
						.append("	DATE_FORMAT( NOW(), '%Y%m%d'), \n")
						.append("	'1', \n")
						.append("	'1', \n")
						.append("	DATE_FORMAT( NOW(), '%Y%m%d%H%i%s'),\n")
						.append("	'admin',\n")
						.append("	DATE_FORMAT( NOW(), '%Y%m%d%H%i%s'),\n")
						.append("	'admin' \n")
						.append(")\n")
						.toString();


					resultInt = super.excuteUpdate(con_Mysql, sql.toString());
					
					if (resultInt < 0) {
						ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
					} else {
						ioParam.setMessage(resultInt + "건 " + MessageDefine.M_INSERT_RESULT);
					}
					
					sql = new StringBuilder()
						.append("INSERT INTO use_intt_infm\n")
						.append(" ( CHNL_ID, \n")
						.append("	USE_INTT_ID, \n")
						.append("	BSNN_NO, \n")
						.append("	USE_INTT_DSNC, \n")
						.append("	BSUN_DSNC, \n")
						.append("	RPRS_TLNO, \n")
						.append("	FAX_NO, \n")
						.append("	MNGR_ID, \n")
						.append("	ACVT_YN, \n")
						.append("	RGSR_ID, \n")
						.append("	RGSN_DTTM, \n")
						.append("	EDTR_ID, \n")
						.append("	AMNN_DTTM, \n")
						.append("	BSNN_NM, \n")
						.append("	RPPR_NM, \n")
						.append("	BSST, \n")
						.append("	TPBS, \n")
						.append("	ZPCD, \n")
						.append("	ADRS, \n")
						.append("	EMPL_CNT, \n")
						.append("	RGEM_CNT, \n")
						.append("	BSNN_DSNC, \n")
						.append("	MMCR_YN\n")
						.append(") \n")
						.append("VALUES(\n")
						.append("	'CHNL_64', \n")
//						.append("	CONCAT('UTLZ', '_', IFNULL((REGEXP_REPLACE(MAX(USE_INTT_ID),'[A-Z_]','')+1) ,1)) ,\n")
//						.append("	CONCAT('UTLZ_', IFNULL(MAX(CAST(SUBSTRING(USE_INTT_ID,6,100) as UNSIGNED)),'UTLZ_1')+1),\n")
//						.append("	(SELECT CONCAT('UTLZ_', COALESCE(MAX(CAST(SUBSTR(USE_INTT_ID,6) AS DECIMAL))+ 1,1)) AS UTLZ_ID FROM USE_INTT_INFM WHERE CHNL_ID = 'CHNL_64'),\n")
						.append("	'" + jArray.get("use_intt_id") +"',\n")
						.append("	REPLACE('" + jArray.get("BizNo") + "','-',''), \n")
						.append("	'C', \n")
						.append("	'0', \n")
						.append("	'" + jArray.get("TelNo") + "',\n")
						.append("	'" + jArray.get("Fax") + "',\n")
						.append("	'admin',\n")
						.append("	'Y', \n")
						.append("	'admin',\n")
						.append("	DATE_FORMAT( NOW(), '%Y%m%d%H%i%s'),\n")
						.append("	'admin', \n")
						.append("	DATE_FORMAT( NOW(), '%Y%m%d%H%i%s'), \n")
						.append("	'" + jArray.get("Cust_nm") + "', \n")
						.append("	'" + jArray.get("BossName") + "', \n")
						.append("	'SH4999', \n")
						.append("	'SH3999',\n")
						.append("	'" + jArray.get("Zipno") + "', \n")
						.append("	'" + jArray.get("Juso") + "', \n")
						.append("	'1',\n")
						.append("	'1',\n")
						.append("	'5',\n")
						.append("	'N'\n")
						.append(")\n")
						.toString();

					resultInt = super.excuteUpdate(con_Mysql, sql.toString());
					
					if (resultInt < 0) {
						ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
					} else {
						ioParam.setMessage(resultInt + "건 " + MessageDefine.M_INSERT_RESULT);
					}
				}
		} catch(Exception e) {
			LoggingWriter.setLogError("M909S150100E101()","==== SQL ERROR ===="+ e.getMessage() + "\n" + sql.toString());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M909S150100E101()","==== finally ===="+ e.getMessage());
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
			//con_Mysql = JDBCConnectionPool.getConnection_Mysql();
			con.setAutoCommit(false);
			
			
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			System.out.println("JSONObject jArray rcvData="+ jArray.toString());
			
			// 클라이언트로 부터 받은 파라미터를 옮겨 담는다.
//			String rcvData = (String)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			
			// 클라이언트로 부터 받은 파라미터를 쪼개어서 배열에 담는다.
//			String[][] c_paramArray = CommonFunction.getConvString2DoubleArray(rcvData);
			
			// duration_date 설정 
			SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
			Date date = sdf.parse((String) jArray.get("StartDate"));
			Calendar cal = Calendar.getInstance();
			cal.setTime(date);
			cal.add(Calendar.DATE, -1);
			sdf.format(cal.getTime());

			
			String sql = new StringBuilder()
					.append("INSERT INTO tbm_our_company_info \n")
					.append(" ( bizno,\n")
					.append("	revision_no,\n")
					.append("	cust_nm,\n")
					.append("	address,\n")
					.append("	telno,\n")
					.append("	boss_name,\n")
					.append("	uptae,\n")
					.append("	jongmok,\n")
					.append("	faxno,\n")
					.append("	homepage,\n")
					.append("	zipno,\n")
					.append("	start_date,\n")
					.append("	create_date,\n")
					.append("	create_user_id,\n")
					.append("	modify_date,\n")
					.append("	modify_user_id,\n")
					.append("	modify_reason,\n")
					.append("	duration_date,\n")
					.append("	seal_img_filename,\n")
					.append("	logo_img_filename,\n")
					.append("	haccp_no,\n")
					.append("	kape_openapi_userid,\n")
					.append("	kape_openapi_apikey,\n")
					.append(" 	member_key, \n") // member_key_insert
					.append(" 	history_yn \n") // history_yn
					.append(") \n")
					.append("VALUES \n")
					.append("  ('" + jArray.get("BizNo") + "',\n") //BizNo
					.append("	COALESCE( (SELECT  MAX(revision_no)+1 FROM tbm_our_company_info "
											+ " WHERE bizno='" + jArray.get("BizNo") + "' ), 1) ,\n")
					.append("	'" + jArray.get("Cust_nm") + "',\n") //Cust_nm
					.append("	'" + jArray.get("Juso") + "',\n") //Juso
					.append("	'" + jArray.get("TelNo") + "',\n") //TelNo
					.append("	'" + jArray.get("BossName") + "',\n") //BossName
					.append("	'" + jArray.get("Uptae") + "',\n") //Uptae
					.append("	'" + jArray.get("Jongmok") + "',\n") //Jongmok
					.append("	'" + jArray.get("Fax") + "',\n") //Fax
					.append("	'" + jArray.get("HomePage") + "',\n") //HomePage
					.append("	'" + jArray.get("Zipno") + "',\n") //Zipno
					.append("	'" + jArray.get("StartDate") + "',\n") //StartDate
					.append("	SYSDATE,\n") //create_date
					.append("	'" + jArray.get("user_id") + "',\n") //create_user_id
					.append("	SYSDATE,\n") //modify_date
					.append("	'" + jArray.get("user_id") + "',\n") //modify_user_id
					.append("	'" + jArray.get("modify_reason") + "',\n") //modify_reason
					.append("	'9999-12-31',\n") //duration_date
					.append("	'" + jArray.get("SealImageFileName") + "',\n") //seal_img_filename
					.append("	'" + jArray.get("LogoImageFileName") + "',\n") //logo_img_filename
					.append("	'" + jArray.get("haccp_no") + "',\n") //haccp_no
					.append("	'" + jArray.get("kape_openapi_userid") + "',\n") //kape_openapi_userid
					.append("	'" + jArray.get("kape_openapi_apikey") + "',\n") //LogoImageFileName
					//.append(" 	'" + jArray.get("BizNo") + "', \n") //member_key_values
					.append(" 	'" + jArray.get("member_key") + "', \n") //member_key_values
					.append(" 	'" + jArray.get("hist_yn") + "' \n") //history_yn
					.append(")\n")
					.toString();
			
			resultInt = super.excuteUpdate(con, sql.toString());
			if (resultInt < 0) { //
				ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
				con.rollback();
				return EventDefine.E_DOEXCUTE_ERROR;
			}
				 
			sql = new StringBuilder()
					.append("UPDATE tbm_our_company_info \n")
					.append("SET	 	 \n")
					.append("			duration_date= '"+ sdf.format(cal.getTime()) +"' \n")
					.append(" 	,member_key = 	'" + jArray.get("BizNo") + "'		\n")
					.append("WHERE		bizno= '" + jArray.get("BizNo") + "' AND\n")
					.append("			revision_no =" + jArray.get("RevisionNo") + " \n")
					.append(" 	AND member_key = '" + jArray.get("BizNo") + "' \n") //member_key_select, update, delete
					.toString();
				
				resultInt = super.excuteUpdate(con, sql.toString());
			if (resultInt < 0) { //
				ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
				con.rollback();
				return EventDefine.E_DOEXCUTE_ERROR;
			}
			con.commit();
			
			if(con_Mysql == null) {
				System.out.println("Mysql 회사가입 이력남기기 사용 안함");
			}else { 
				con_Mysql.setAutoCommit(false);
				sql = new StringBuilder()
						.append("UPDATE use_intt_infm SET \n")
						.append("	RPRS_TLNO = '" + jArray.get("TelNo")  + "',\n")
						.append("	FAX_NO = '" + jArray.get("Fax")  + "',\n")
						.append("	AMNN_DTTM = DATE_FORMAT( NOW(), '%Y%m%d%H%i%s'),\n")
						.append("	BSNN_NM = '" + jArray.get("Cust_nm")  + "',\n")
						.append("	RPPR_NM = '" + jArray.get("BossName")  + "',\n")
						.append("	ZPCD = '" + jArray.get("Zipno")  + "',\n")
						.append("	ADRS = '" + jArray.get("Juso")  + "'\n")
						.append("WHERE \n")
						.append("	BSNN_NO = '" + jArray.get("BizNo")  + "'\n")
						.append("	AND CHNL_ID='CHNL_64'\n")
						.toString();

				resultInt = super.excuteUpdate(con_Mysql, sql.toString());
				
				if (resultInt < 0) { //
					ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
					con.rollback();
					return EventDefine.E_DOEXCUTE_ERROR;
				}
				
				con_Mysql.commit();
			} // else
				
		} catch(Exception e) {
			LoggingWriter.setLogError("M909S150100E102()","==== SQL ERROR ===="+ e.getMessage() + "\n" + sql.toString());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M909S150100E102()","==== finally ===="+ e.getMessage());
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

	public int E104(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			
			String sql = new StringBuilder()
					.append("SELECT\n")
					.append("bizno,\n")
					.append("revision_no,\n")
					.append("cust_nm,\n")
					.append("address,\n")
					.append("telno,\n")
					.append("boss_name,\n")
					.append("uptae,\n")
					.append("jongmok,\n")
					.append("faxno,\n")
					.append("homepage,\n")
					.append("zipno,\n")
					.append("	haccp_no,\n")
					.append("	kape_openapi_userid,\n")
					.append("	kape_openapi_apikey\n")
					.append(" FROM tbm_our_company_info\n")
					.append(" 	WHERE member_key = '" + jArray.get("member_key") + "' \n") //member_key_select, update, delete
					.toString();

			resultString = super.excuteQueryString(con, sql.toString());
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M909S150100E104()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M909S150100E104()","==== finally ===="+ e.getMessage());
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
	
	public int E105(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			
			String sql = new StringBuilder()
					.append("SELECT				\n")
					.append("bizno,				\n")
					.append("revision_no,		\n")
					.append("cust_nm,			\n")
					.append("address,			\n")
					.append("telno,				\n")
					.append("boss_name,			\n")
					.append("uptae,				\n")
					.append("jongmok,			\n")
					.append("faxno,				\n")
					.append("homepage,			\n")
					.append("zipno,				\n")
					.append("seal_img_filename,	\n")
					.append("logo_img_filename,	\n")
					.append("start_date,			\n")
					.append("	haccp_no,\n")
					.append("	kape_openapi_userid,\n")
					.append("	kape_openapi_apikey,\n")
					.append("	history_yn\n")
					.append(" FROM tbm_our_company_info\n")
					.append("WHERE bizno = '" + jArray.get("BIZNO") + "'\n")
					.append("AND revision_no = '" + jArray.get("REV") + "'\n")
//					.append("AND member_key = '" + jArray.get("member_key") + "' \n") //member_key_select, update, delete
					.toString();

			resultString = super.excuteQueryString(con, sql.toString());
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M909S150100E105()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M909S150100E105()","==== finally ===="+ e.getMessage());
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
	
	// duration
	public int E106(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			
			String sql = new StringBuilder()
					.append("SELECT\n")
					.append("bizno,\n")
					.append("revision_no,\n")
					.append("cust_nm,\n")
					.append("address,\n")
					.append("telno,\n")
					.append("boss_name,\n")
					.append("uptae,\n")
					.append("jongmok,\n")
					.append("faxno,\n")
					.append("homepage,\n")
					.append("zipno, \n")
					.append("	haccp_no,\n")
					.append("	kape_openapi_userid,\n")
					.append("	kape_openapi_apikey\n")
					.append(" FROM tbm_our_company_info\n")
					.append("WHERE TO_CHAR(SYSDATE,'YYYY-MM-DD') BETWEEN  start_date AND duration_date\n")
					.append(" 	AND member_key = '" + jArray.get("member_key") + "' \n") //member_key_select, update, delete ??원래 주석이었음??
					.append("   AND revision_no = (SELECT MAX(B.revision_no) 	  \n")
					.append("    				  FROM tbm_our_company_info B \n")
					.append("                     WHERE member_key = '" + jArray.get("member_key") + "')  \n")
					.toString();

			resultString = super.excuteQueryString(con, sql.toString());
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M909S150100E106()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M909S150100E106()","==== finally ===="+ e.getMessage());
				}
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
	
	//헤드메뉴 우즉의 회사 정보
	public int E114(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			
			String sql = new StringBuilder()
					.append("SELECT\n")
					.append("	bizno,\n")
					.append("	revision_no,\n")
					.append("	cust_nm,\n")
					.append("	address,\n")
					.append("	telno,\n")
					.append("	boss_name,\n")
					.append("	uptae,\n")
					.append("	jongmok,\n")
					.append("	faxno,\n")
					.append("	homepage,\n")
					.append("	zipno,\n")
					.append("	logo_img_filename\n")
					.append("FROM tbm_our_company_info\n")
					.append("WHERE TO_CHAR(SYSDATE,'YYYY-MM-DD') BETWEEN start_date AND duration_date\n")
					.append(" 	AND member_key = '" + jArray.get("member_key") + "' \n")
					.append(";\n")
					.toString();

			resultString = super.excuteQueryString(con, sql.toString());
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M909S150100E114()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M909S150100E114()","==== finally ===="+ e.getMessage());
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
	
	//Mysql_Menu Select UTLZ_XX + 1 
	public int E964(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con_Mysql = JDBCConnectionPool.getConnection_Mysql();
			
			// 클라이언트로 부터 받은 파라미터를 옮겨 담는다.
			String rcvData = (String)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			// 클라이언트로 부터 받은 파라미터를 쪼개어서 배열에 담는다. UPPER
			String[][] c_paramArray = CommonFunction.getConvString2DoubleArray(rcvData);
			
			if(con_Mysql == null) {
				System.out.println("Mysql 회사가입 이력남기기 사용 안함");
			}else { 
			
			String sql = new StringBuilder()
				.append("SELECT CONCAT('UTLZ_', COALESCE(MAX(CAST(SUBSTR(USE_INTT_ID,6) AS DECIMAL))+ 1,1)) AS UTLZ_ID FROM chnl_per_use_intt_ldgr WHERE CHNL_ID = 'CHNL_64'\n")
				.toString();

			resultString = super.excuteQueryString(con_Mysql, sql.toString());
			} //else
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M909S150100E964()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M909S150100E964()","==== finally ===="+ e.getMessage());
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