package mes.frame.business.M000;

import java.lang.reflect.Method;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Vector;

import org.apache.log4j.Logger;
import org.json.simple.JSONObject;

import mes.client.util.ProcesStatusCheck;
import mes.frame.common.ApprovalActionNo;
import mes.client.conf.Config;
import mes.client.conf.SysConfig;
import mes.frame.common.EventDefine;
import mes.frame.common.HashObject;
import mes.frame.common.MessageDefine;
import mes.frame.common.QueueProcessing;
import mes.frame.database.JDBCConnectionPool;
import mes.frame.database.SqlAdapter;
import mes.frame.serviceinterface.InoutParameter;
import mes.frame.serviceinterface.LoggingWriter;
import mes.frame.util.CommonFunction;

import mes.frame.util.PasswordHash;


public class M000S100000 extends SqlAdapter {
	static final Logger logger = Logger.getLogger(M000S100000.class.getName());
	
	Connection con = null;
	Connection con_Mysql = null;
	PreparedStatement pstmt = null;
	String resultString = "";
	int resultInt = -1;
	StringBuffer sql = new StringBuffer();
	
	String[][] v_paramArray = new String[0][0]; 
	Class[] optClass = null;
	Object[] optObj = null;
	Object obj = null;
	
	public M000S100000(){
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
			
			Method method = M000S100000.class.getMethod(event,optClass);
			LoggingWriter.setLogDebug(M000S100000.class.getName(),"==== " + event + " EventMethod Create Success ====");

			obj = method.invoke(M000S100000.class.newInstance(),optObj);
			doExcute_result = CommonFunction.getInt(obj.toString());
			
	    } catch (Exception ex) {
	    	doExcute_result = EventDefine.E_DOEXCUTE_INIT;
			ioParam.setMessage(MessageDefine.M_NO_EVENTID);
			LoggingWriter.setLogError(M000S100000.class.getName(),"==== EventID Not define : EVENT ID [ " + ioParam.getEventID() + "]");
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

	// 데몬 스타트
	public void E000(){
		
	}
	
	// 로그인 체크
	public int E001(InoutParameter ioParam){		
		// 로그인 시에 각종 데몬들을 점검해서 시작되지 않은 넘들이 있으면 시작시킨다.
		E000();
		// 로그인 체크
		resultInt = EventDefine.E_DOEXCUTE_INIT;
				
		try {
			String rcvData = (String)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			v_paramArray = CommonFunction.getConvString2DoubleArray(rcvData);
			
			con = JDBCConnectionPool.getConnection();
			
			// 우선 해당 아이디가 있는지 확인한다.
			sql = new StringBuffer();
			sql.append(" select GROUP_CD, USER_ID, USER_NM, USER_PWD, MEMBER_KEY \n");
			sql.append(" from tbm_users where USER_ID='" + v_paramArray[0][0] + "' ");
			
			resultString = super.excuteQueryString(con, sql.toString());
		} catch(Exception e) {
			LoggingWriter.setLogError("M000S100000E001()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
			try {
				if (con != null) con.close();
			} catch (Exception e) {
				LoggingWriter.setLogError("M000S100000E001()","==== finally ===="+ e.getMessage());
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
	
	// 로그인 체크
	public int E104(InoutParameter ioParam){
		
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		String sql = "";
		
		try {
			String rcvData = (String)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			v_paramArray = CommonFunction.getConvString2DoubleArray(rcvData);
			
			con = JDBCConnectionPool.getConnection();
			con.setAutoCommit(false);
			
			String password = v_paramArray[0][1].toString();
			String hashedPassword = PasswordHash.hashPassword(password);
			
			sql = new StringBuilder()
					.append("SELECT												\n")
					.append("	group_cd,										\n")
					.append("	user_id,										\n")
					.append("	user_nm,										\n")
					.append("	user_pwd,										\n")
					.append("	NVL(user_pwd_setting, ''),						\n")
					.append("	member_key										\n")
					.append("FROM												\n")
					.append("	tbm_users										\n")
					.append("WHERE user_id = '" + v_paramArray[0][0] + "' 		\n")
					.append("AND user_pwd = '" + hashedPassword + "' 			\n")
					.append("AND TO_CHAR(SYSDATE,'YYYY-MM-DD') BETWEEN			\n")
					.append("					start_date AND duration_date	\n")
					.toString();
			
			resultString = super.excuteQueryString(con, sql);
			
			con.commit();
		} catch(Exception e) {
			LoggingWriter.setLogError("M000S100000E104()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
			try {
				if (con != null) {
					con.close();
				}
			} catch (Exception e) {
				LoggingWriter.setLogError("M000S100000E104()","==== finally ===="+ e.getMessage());
			}
	    }

		ioParam.setResultString(resultString);
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
    	ioParam.setMessage(MessageDefine.M_QUERY_OK);

    	return EventDefine.E_QUERY_RESULT;
	}
	
	// 로그인 일시 session 추가하기 위한 조회용
	public int E114(InoutParameter ioParam){
		
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		String sql = "";
		
		try {
			
			String rcvData = (String)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			v_paramArray = CommonFunction.getConvString2DoubleArray(rcvData);
			
			con = JDBCConnectionPool.getConnection();
			con.setAutoCommit(false);
			
			sql = new StringBuilder()
					.append("SELECT 								\n")
					.append("MAX(login_date) 						\n")
					.append("FROM tbi_login_log 					\n")
					.append("WHERE									\n")
					.append(" login_user_id	 = '" +  v_paramArray[0][0] + "' 	\n")
					.append(" AND login_ip  = '" +  v_paramArray[0][2] + "' 	\n")
					.toString();

			resultString = super.excuteQueryString(con, sql);
			
			con.commit();
			
		} catch(Exception e) {
			LoggingWriter.setLogError("M000S100000E114()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
			try {
				if (con != null) {
					con.close();
				}
			} catch (Exception e) {
				LoggingWriter.setLogError("M000S100000E114()","==== finally ===="+ e.getMessage());
			}
	    }

		ioParam.setResultString(resultString);
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
    	ioParam.setMessage(MessageDefine.M_QUERY_OK);

    	return EventDefine.E_QUERY_RESULT;
	}

	// 로그인 성공시 로그 insert
	public int E111(InoutParameter ioParam){
		
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		String sql = "";
		
		try {
			
			String rcvData = (String)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			v_paramArray = CommonFunction.getConvString2DoubleArray(rcvData);
			
			con = JDBCConnectionPool.getConnection();
			con.setAutoCommit(false);
			
			// 로그인 로그를 남긴다.
			sql = new StringBuilder()
					.append("INSERT INTO						\n")
					.append("	tbi_login_log (					\n")
					.append("		login_ip,					\n")
					.append("		login_user_id				\n")
					.append("	)								\n")
					.append("VALUES								\n")
					.append("	( 								\n")
					.append("	'" + v_paramArray[0][2] + "', 	\n")
					.append("	'" + v_paramArray[0][0] + "' 	\n")
					.append("	) 								\n")
					.toString();

			resultInt = super.excuteUpdate(con, sql);
			if (resultInt < 0) {
				ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
				con.rollback();
				return EventDefine.E_DOEXCUTE_ERROR;
			}
			con.commit();
			
		} catch(Exception e) {
			LoggingWriter.setLogError("M000S100000E111()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
			try {
				if (con != null) {
					con.close();
				}
			} catch (Exception e) {
				LoggingWriter.setLogError("M000S100000E111()","==== finally ===="+ e.getMessage());
			}
	    }

		ioParam.setResultString(resultString);
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
    	ioParam.setMessage(MessageDefine.M_QUERY_OK);

    	return EventDefine.E_QUERY_RESULT;
	}		
			
	// 로그아웃시 해당 로그 업데이트
	public int E122(InoutParameter ioParam){
		
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		String sql = "";
		
		try {
			
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			
			// 로그인 로그를 남긴다.
			sql = new StringBuilder()
					.append("UPDATE tbi_login_log SET			\n")
					.append("logout_date = SYS_DATETIME 		\n")
					.append("WHERE								\n")
					.append(" login_user_id	 = '" + jArray.get("login_id") + "' 	\n")
					.append(" AND login_ip	 = '" + jArray.get("login_ip") + "' 	\n")
					.append(" AND login_date  = '" + jArray.get("login_date") + "' 	\n")
					.toString();

			resultInt = super.excuteUpdate(con, sql);
			if (resultInt < 0) {
				ioParam.setMessage(MessageDefine.M_UPDATE_FAILED);
				con.rollback();
				return EventDefine.E_DOEXCUTE_ERROR;
			}
			con.commit();
			
		} catch(Exception e) {
			LoggingWriter.setLogError("M000S100000E122()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
			try {
				if (con != null) {
					con.close();
				}
			} catch (Exception e) {
				LoggingWriter.setLogError("M000S100000E122()","==== finally ===="+ e.getMessage());
			}
	    }

		ioParam.setResultString(resultString);
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
    	ioParam.setMessage(MessageDefine.M_QUERY_OK);

    	return EventDefine.E_QUERY_RESULT;
	}
	
	// mysql 이력 남기기
	public int E105(InoutParameter ioParam){
		
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		String sql="";		
		SysConfig sys_config = new SysConfig();
		
		try {
			String rcvData = (String)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			v_paramArray = CommonFunction.getConvString2DoubleArray(rcvData);
			
			con = JDBCConnectionPool.getConnection();
			con_Mysql = JDBCConnectionPool.getConnection_Mysql();
			
			if(con_Mysql == null) {
				logger.debug("Mysql 로그인 이력 남기기 사용 안함");
			} else {
				con_Mysql.setAutoCommit (false) ;

				// 우선 해당 아이디가 있는지 확인한다.
				sql = new StringBuilder()
						.append("SELECT\n")
						.append("	group_cd,\n")
						.append("	user_id,\n")
						.append("	user_nm,\n")
						.append("	user_pwd,\n")
						.append("	NVL(user_pwd_setting,''),\n")
						.append("	member_key\n")
						.append("FROM\n")
						.append("	tbm_users\n")
						.append("WHERE user_id = '" + v_paramArray[0][0] + "' \n")
						.append("AND user_pwd = '" + v_paramArray[0][1] + "' \n") // 사용자 지정 비밀번호 체크 (2018-12-10 진욱수정)
						.append("AND TO_CHAR(SYSDATE,'YYYY-MM-DD') BETWEEN  start_date AND duration_date \n") 
						.toString();
				
				resultString = super.excuteQueryString(con, sql.toString());
				
				String loginUser[]=	resultString.split("\t");
				
				try {
					sql = new StringBuilder()
							.append("INSERT INTO \n")
							.append("	lgn_prhs_sp (\n")
							.append("	CHNL_ID, \n")
							.append("	USE_INTT_ID, \n")
							.append("	USER_ID, \n")
							.append("	LGN_DT, \n")
							.append("	LGN_TMD, \n")
							.append("	USER_OS, \n")
							.append("	USER_IP, \n")
							.append("	USER_BR, \n")
							.append("	USER_BR_VER, \n")
							.append("	SVR_NO\n")
							.append(") \n")
							.append("VALUES (\n")
							.append("	'CHNL_64', \n")
							.append("	'" + sys_config.UTLZ + "', \n")
							.append("	'" + v_paramArray[0][0] + "', \n")
							.append("	DATE_FORMAT(now(), '%Y%m%d'), \n")
							.append("	DATE_FORMAT(now(), '%H%i%s'), \n")
							.append("	'" + System.getProperty("os.name") + "', \n")
							.append("	'" + v_paramArray[0][2] + "', \n")
							.append("	'"+ v_paramArray[0][3] + "', \n")
							.append("	'"+ v_paramArray[0][4] + "', \n")
							.append("	'" + v_paramArray[0][7] + "'\n")  //server_ip
							.append(")\n")
							.toString();
					
					resultInt = super.excuteUpdate(con_Mysql, sql);
					
					logger.debug("resultInt================"+ resultInt);
					
					if (resultInt < 0) {
						con_Mysql.rollback();
					}
					
					sql = new StringBuilder()
						.append("INSERT INTO wa_crtc_prhs_sp(\n")
						.append("	PTL_ID, \n")
						.append("	CNTS_ID, \n")
						.append("	USER_ID, \n")
						.append("	CRTC_DT, \n")
						.append("	CRTC_TMD, \n")
						.append("	RNDM_KEY, \n")
						.append("	BSNN_NO, \n")
						.append("	MNGR_DSNC, \n")
						.append("	LNGG_DSNC, \n")
						.append("	USER_DATA, \n")
						.append("	CRTC_STTS, \n")
						.append("	RSVD1, \n")
						.append("	RSVD2, \n")
						.append("	RSVD3, \n")
						.append("	SVC_PTRN, \n")
						.append("	USE_INTT_ID,\n")
						.append("	BSNN_NM, \n")
						.append("	USER_NM\n")
						.append(") \n")
						.append("VALUES (\n")
						.append("	'PTL_SP', \n")
						.append("	'CNTS_168', \n")
						.append("	'" + v_paramArray[0][0] + "', \n")
						.append("	DATE_FORMAT(now(), '%Y%m%d'),\n")
						.append("	DATE_FORMAT(now(), '%H%i%s'),\n")
						.append("	'df98f4bf-3833-42c1-8a8d-1521419491232', \n")
						.append("	REPLACE('" + v_paramArray[0][5] + "','-',''), \n")
						.append("	'C', \n")
						.append("	'DF',\n")
						.append("	'{}', \n")
						.append("	'1', \n")
						.append("	'', \n")
						.append("	'', \n")
						.append("	'', \n")
						.append("	'W', \n")
						.append("	'" + sys_config.UTLZ + "', \n")
						.append("	'" + v_paramArray[0][6] + "', \n")
						.append("	'" + loginUser[2] + "' \n")		//User Name
						.append(")\n")
						.toString();
					resultInt = super.excuteUpdate(con_Mysql, sql);
					
					if (resultInt < 0) {
						con_Mysql.rollback();
					}
					
					con_Mysql.commit();
				} catch(Exception e) {
					e.printStackTrace();
					LoggingWriter.setLogError("M000S100000E105()","==== con_Mysql SQL ERROR ===="+ e.getMessage());
					return EventDefine.E_DOEXCUTE_ERROR ;
				}
	
			}
		}catch(Exception e) {
			LoggingWriter.setLogError("M000S100000E105()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
			try {
				if (con != null) {
					con.close();
				}
				if (con_Mysql != null) {
					con_Mysql.close();
				}
			} catch (Exception e) {
				LoggingWriter.setLogError("M000S100000E105()","==== finally ===="+ e.getMessage());
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
	
	// 로그인 체크
	public int W001(InoutParameter ioParam){
		// 로그인 시에 각종 데몬들을 점검해서 시작되지 않은 넘들이 있으면 시작시킨다.
		E000();
		
		// 로그인 체크
		resultInt = EventDefine.E_DOEXCUTE_INIT;
				
		try {
			String rcvData = (String)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			v_paramArray = CommonFunction.getConvString2DoubleArray(rcvData);
			
			con = JDBCConnectionPool.getConnection();
			
			// 우선 해당 아이디가 있는지 확인한다.
			sql = new StringBuffer();
			sql.append(" select GROUP_CD, USER_ID, USER_NM, USER_PWD, MEMBER_KEY \n");
			sql.append(" from tbm_users where USER_ID='" + v_paramArray[0][0] + "'");
			resultString = super.excuteQueryString(con, sql.toString());
		} catch(Exception e) {
			LoggingWriter.setLogError("M000S100000W001()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
			try {
				if (con != null) con.close();
			} catch (Exception e) {
				LoggingWriter.setLogError("M000S100000W001()","==== finally ===="+ e.getMessage());
			}
	    }
		ioParam.setResultString(resultString);
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
    	ioParam.setMessage(MessageDefine.M_QUERY_OK);
	    return EventDefine.E_QUERY_RESULT;
	}
		
	// 시스템 Config IP 확인
	public int E204(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		try {
			String rcvData = (String)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			v_paramArray = CommonFunction.getConvString2DoubleArray(rcvData);
			
			con = JDBCConnectionPool.getConnection();
			
			// 우선 해당 아이디가 있는지 확인한다.
			String sql = new StringBuilder()
					.append("SELECT\n")
					.append("	sub_server_ip,\n")
					.append("	barcode_print_ip,\n")
					.append("	vision_camera_ip,\n")
					.append("	humidity_gage_ip,\n")
					.append("	pressure_gage_ip,\n")
					.append("	temprature_gage_ip\n")
					.append("FROM\n")
					.append("	tbm_sys_config\n")
					.append("WHERE\n")
					.append("	sys_config_key LIKE '" + v_paramArray[0][0] + "%'\n")
					.toString();

			resultString = super.excuteQueryString(con, sql.toString());
		} catch(Exception e) {
			LoggingWriter.setLogError("M000S100000E204()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
			try {
				if (con != null) con.close();
			} catch (Exception e) {
				LoggingWriter.setLogError("M000S100000E204()","==== finally ===="+ e.getMessage());
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
	
	// 로그인 당사자 그룹별 메뉴구성
	public int E002(InoutParameter ioParam){
		// 로그인 체크
		resultInt = EventDefine.E_DOEXCUTE_INIT;
				
		try {
			String rcvData = (String)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			v_paramArray = CommonFunction.getConvString2DoubleArray(rcvData);
			
			con = JDBCConnectionPool.getConnection();
			
			// 우선 해당 아이디가 있는지 확인한다.
			String sql = new StringBuilder()
					.append("select \n")
					.append("	 	am.class_id,  		\n")
					.append("	 	am.MENU_ID,  		\n")
					.append("		am.MENU_NAME,  		\n")
					.append("	  	gm.autho_menu,  	\n")
					.append("		gm.autho_insert,  	\n")
					.append("		gm.autho_update,  	\n")
					.append("		gm.autho_delete,  	\n")
					.append("		gm.autho_select,	\n")
					.append("	 	am.menu_level,		\n")
					.append("	 	am.parent_menu_id,	\n")
					.append("	 	am.program_id		\n")
					.append("	from tbm_menu am, TBM_GROUP_MENU gm \n")
					.append(" 	where gm.autho_menu = 1 \n")
					.append(" 		and am.delyn 	= 'N' \n")
					.append(" 		AND am.MENU_ID	= gm.MENU_ID\n")
					.append(" 		AND user_id		= '" + v_paramArray[0][0] + "' \n")
					.append("		AND gm.group_cd = '" + v_paramArray[0][3] + "' 		\n")
					.append(" 		AND am.MENU_ID LIKE '" + v_paramArray[0][1] + "%' \n")
					.append(" 		AND am.member_key = '" + v_paramArray[0][2] + "' \n")
					.append(" 		AND gm.member_key = '" + v_paramArray[0][2] + "' \n")
					.append(" 	ORDER BY am.order_index \n")
					.toString();
			resultString = super.excuteQueryString(con, sql.toString());
		} catch(Exception e) {
			LoggingWriter.setLogError("M000S100000E002()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
			try {
				if (con != null) con.close();
			} catch (Exception e) {
				LoggingWriter.setLogError("M000S100000E002()","==== finally ===="+ e.getMessage());
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
	
	

	// 로그인 당사자 프로그램 권한
	public int E302(InoutParameter ioParam){
		// 로그인 체크
		resultInt = EventDefine.E_DOEXCUTE_INIT;
				
		try {
//			String rcvData = (String)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
//			v_paramArray = CommonFunction.getConvString2DoubleArray(rcvData);
			
			con = JDBCConnectionPool.getConnection();
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			
			String sql = new StringBuilder()
					.append("select \n")
					.append("	 	am.class_id,  		\n")
					.append("	 	am.MENU_ID,  		\n")
					.append("		am.MENU_NAME,  		\n")
					.append("	  	gm.autho_menu,  	\n")
					.append("		gm.autho_insert,  	\n")
					.append("		gm.autho_update,  	\n")
					.append("		gm.autho_delete,  	\n")
					.append("		gm.autho_select,	\n")
					.append("	 	am.menu_level,		\n")
					.append("	 	am.parent_menu_id,	\n")
					.append("	 	am.program_id		\n")
					.append("	from tbm_menu am, TBM_GROUP_MENU gm \n")
					.append(" 	where gm.autho_menu = 1 \n")
					.append(" 		and am.delyn 	= 'N' \n")
					.append(" 		AND am.MENU_ID	= gm.MENU_ID\n")
					.append(" 		AND user_id		= '" + jArray.get("user_id") + "' \n")
					.append("		AND gm.group_cd = '" + jArray.get("group_cd") + "' 		\n")
					.append(" 		AND am.program_id = '" + jArray.get("program_id") + "' \n")
					.append(" 	ORDER BY am.order_index \n")
					.toString();

			resultString = super.excuteQueryString(con, sql.toString());
		} catch(Exception e) {
			LoggingWriter.setLogError("M000S100000E302()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
			try {
				if (con != null) con.close();
			} catch (Exception e) {
				LoggingWriter.setLogError("M000S100000E302()","==== finally ===="+ e.getMessage());
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
	//DOC CODE
	public int E004(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			String sql = new StringBuilder()
					.append("SELECT				\n")
					.append("	document_no,	\n")
					.append("	document_name,	\n")
					.append("	security_doc_yn,\n")
					.append("	hold_period,	\n")
					.append("	create_date,	\n")
					.append("	code_name,		\n")
					.append("	gubun_code		\n")
					.append("FROM tbm_doc_base A\n")
					.append("INNER JOIN v_doc_gubun C		\n")
					.append("ON A.gubun_code = C.code_cd	\n")
					.toString();

			resultString = super.excuteQueryString(con, sql.toString());
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M000S100000E004()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M000S100000E004()","==== finally ===="+ e.getMessage());
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

		String sql ="";
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		ApprovalActionNo cActionNo;
		QueueProcessing Queue = new QueueProcessing();
		String gActionNo="";
		String IndGB="";
		try {
			con = JDBCConnectionPool.getConnection();
			
			// 클라이언트로 부터 받은 파라미터를 옮겨 담는다.
			String rcvData = (String)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));  
			String[][] c_paramArray = CommonFunction.getConvString2DoubleArray(rcvData);
			con.setAutoCommit(false);
			String actionGubun = c_paramArray[0][3].trim();
			String Process_Gubun =c_paramArray[0][10];
			String member_key =c_paramArray[0][12];
			
			cActionNo = new ApprovalActionNo();
			if(c_paramArray[0][2].length()==3) {
				gActionNo = cActionNo.getActionNo(con,c_paramArray[0][0],c_paramArray[0][1],c_paramArray[0][2],actionGubun,c_paramArray[0][6],member_key);//GV_JSPPAGE(action Page), User ID, prefix
				ProcesStatusCheck prcStatusCheck = new ProcesStatusCheck(c_paramArray[0][0]+ "|" + Process_Gubun +"|");
				IndGB = c_paramArray[0][9];
				
				String acSql = "UPDATE "+ prcStatusCheck.GV_PROCESS_TABLE + " SET \n";
				if(actionGubun.equals("Review")) {
					if(IndGB.equals("0"))		// 0: Next, 1: prev
						acSql += " review_no = '" + gActionNo + "' ";
					else 
						acSql += " review_no = '' ";
				}
				else if(actionGubun.equals("Confirm")){			
					if(IndGB.equals("0"))
						acSql += " confirm_no = '" + gActionNo + "' ";
					else 
						acSql += " confirm_no = '' ";
				}	
				
				acSql += " where order_no = '" 			+ c_paramArray[0][5] + "' ";
				acSql += " and lotno  = '" 	+ c_paramArray[0][11] + "' ";
	
				if(!c_paramArray[0][7].equals("")) {		//inspect_no, balju_no etc .....
					acSql += " and  " 	+ c_paramArray[0][7]  ;
				}
				if(!c_paramArray[0][8].equals("")) {		//inspect_no, balju_no etc .....
					acSql += " and  " 	+ c_paramArray[0][8]  ;
				}
				logger.debug(acSql);
				resultInt = super.excuteUpdate(con, acSql);
				if (resultInt < 0) {
					con.rollback();
					return EventDefine.E_DOEXCUTE_ERROR ;
				}
			}
			String main_action_no="", review_action_no="",confirm_action_no="";//없으면 없는대로 전달

			if(actionGubun.equals("Review")) {
				review_action_no = gActionNo;
			}
			else if(actionGubun.equals("Confirm")){
				confirm_action_no = gActionNo;
			}	
			String[] mainAction = c_paramArray[0][7].split("="); //inspect_no = 
			main_action_no = mainAction[1].trim().replaceAll("'", "");
			
			if(Queue.setQueue(con,c_paramArray[0][0],c_paramArray[0][5],c_paramArray[0][6],main_action_no,review_action_no,confirm_action_no
					,c_paramArray[0][9],c_paramArray[0][11], member_key)<0) {
				con.rollback();
				return EventDefine.E_DOEXCUTE_ERROR ;
			}
			
			con.commit();
		} catch(Exception e) {
			LoggingWriter.setLogError("M000S100000E101()","==== SQL ERROR ===="+ e.getMessage() + "\n" + sql.toString());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M000S100000E101()","==== finally ===="+ e.getMessage());
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

	
	//사용자 지정 비밀번호 생성
	public int E102(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		try {
			con = JDBCConnectionPool.getConnection();
			String[][] c_paramArray_Head=null;
			String[][] c_paramArray_Detail=null;
			
			String rcvData = (String)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			Vector resultVector = CommonFunction.getConvStringDamogjuk(rcvData);
			con.setAutoCommit(false);
			
			c_paramArray_Head = (String[][])resultVector.get(0);//head table
			c_paramArray_Detail=(String[][])resultVector.get(1); //data table
    		
			for(int i=0; i<c_paramArray_Detail.length; i++) {  
				
				String sql = new StringBuilder()
						.append("UPDATE\n")
						.append("	tbm_users\n")
						.append("SET\n")
						.append("	user_pwd='" 		+ c_paramArray_Detail[i][1] + "',\n")
						.append("	user_pwd_setting='" + c_paramArray_Detail[i][1] + "'\n")
						.append("WHERE\n")
						.append("	user_id='" 		 	+ c_paramArray_Detail[i][0] + "'\n")
						.toString();

				logger.debug(sql.toString());
				resultInt = super.excuteUpdate(con, sql.toString());
				if (resultInt < 0) {  //
					ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
					con.rollback();
					return EventDefine.E_DOEXCUTE_ERROR ;
				}
			}
				
			con.commit();
			
		} catch(Exception e) {
			LoggingWriter.setLogError("M000S100000E102()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M000S100000E102()","==== finally ===="+ e.getMessage());
				}
	    	} else {
	    	}
	    }
		ioParam.setResultString(resultString);
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
    	ioParam.setMessage(MessageDefine.M_QUERY_OK);
	    return EventDefine.E_QUERY_RESULT;
	}
	
	public int E201(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;

		try {
			con = JDBCConnectionPool.getConnection();

			String[][] c_paramArray=null;
			
			// 클라이언트로 부터 받은 파라미터를 옮겨 담는다.
			String rcvData = (String)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			
			
			c_paramArray = CommonFunction.getConvString2DoubleArray(rcvData);
			con.setAutoCommit(false);

			String sql = new StringBuilder()
					.append("MERGE  INTO tbm_sys_config  mm\n")
					.append("USING (\n")
					.append("  SELECT '" + c_paramArray[0][0] + "' as sub_server_ip		\n")
					.append("		,'" + c_paramArray[0][1] + "'	 	as barcode_print_ip	\n")
					.append("		,'" + c_paramArray[0][2] + "' 		as vision_camera_ip			\n")
					.append("		,'" + c_paramArray[0][3] + "' 		as humidity_gage_ip	\n")
					.append("		,'" + c_paramArray[0][4] + "' 		as pressure_gage_ip	\n")
					.append("		,'" + c_paramArray[0][5] + "'		as temprature_gage_ip	\n")
					.append("		,'henesys'				AS sys_config_key\n")
					.append("FROM db_root  )  mQ\n")
					.append("ON (mm.sys_config_key = mQ.sys_config_key)\n")
					.append("WHEN MATCHED THEN\n")
					.append("                UPDATE SET\n")
					.append("                        mm.sub_server_ip                = mQ.sub_server_ip,\n")
					.append("                        mm.barcode_print_ip			= mQ.barcode_print_ip,\n")
					.append("                        mm.vision_camera_ip           = mQ.vision_camera_ip,\n")
					.append("                        mm.humidity_gage_ip          = mQ.humidity_gage_ip,\n")
					.append("                        mm.pressure_gage_ip           = mQ.pressure_gage_ip,\n")
					.append("                        mm.temprature_gage_ip       = mQ.temprature_gage_ip\n")
					.append("WHEN NOT MATCHED THEN\n")
					.append("        INSERT  (\n")
					.append("        mm.sub_server_ip, \n")
					.append("        mm.barcode_print_ip, \n")
					.append("        mm.vision_camera_ip, \n")
					.append("        mm.humidity_gage_ip,       \n")
					.append("        mm.pressure_gage_ip, \n")
					.append("        mm.temprature_gage_ip\n")
					.append("        )\n")
					.append("		VALUES  (\n")
					.append("		mQ.sub_server_ip, \n")
					.append("		mQ.barcode_print_ip, \n")
					.append("		mQ.vision_camera_ip, \n")
					.append("		mQ.humidity_gage_ip,   \n")
					.append("		mQ.pressure_gage_ip,\n")
					.append("		mQ.temprature_gage_ip\n")
					.append("		)\n")
					.append("       ;\n")
					.toString();

			logger.debug(sql.toString());
			resultInt = super.excuteUpdate(con, sql.toString());
			if (resultInt < 0) {
				con.rollback();
				return EventDefine.E_DOEXCUTE_ERROR ;
			}
			
			con.commit();
		} catch(Exception e) {
			LoggingWriter.setLogError("M000S100000201()","==== SQL ERROR ===="+ e.getMessage() + "\n" + sql.toString());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M000S100000E201()","==== finally ===="+ e.getMessage());
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
	
	public int E301(InoutParameter ioParam){

		String sql ="";
		resultInt = EventDefine.E_DOEXCUTE_INIT;

		try {
			con = JDBCConnectionPool.getConnection();
			// 클라이언트로 부터 받은 파라미터를 옮겨 담는다.
			String rcvData = (String)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			con.setAutoCommit(false);
			    		
			// 클라이언트로 부터 받은 파라미터를 쪼개어서 배열에 담는다. returnStringBuffer
			String[][] c_paramArray = CommonFunction.getConvString2DoubleArray(rcvData);

			 sql = new StringBuilder()
					.append("INSERT INTO\n")
					.append("	tbi_doc_openview_info (\n")
					.append("		regist_no,\n")
					.append("		document_no,\n")
					.append("		file_view_name,\n")
					.append("		open_reason_code,\n")
					.append("		open_user_id,\n")
					.append("		open_ip, \n")
					.append("		regist_no_rev,\n")
					.append("		document_no_rev,\n")
					.append("		member_key\n")
					.append("	)\n")
					.append("VALUES\n")
					.append("	(\n")
					.append(" 		 '" + c_paramArray[0][0] + "' 	\n") 	//regist_no
					.append(" 		,'" + c_paramArray[0][1] + "' 	\n")	//document_no
					.append(" 		,'" + c_paramArray[0][2] + "'	\n") 	//file_view_name 
					.append(" 		,'" + c_paramArray[0][3] + "' 	\n") 	//regist_reason_code
					.append(" 		,'" + c_paramArray[0][4] + "' 	\n") 	//UserId 
					.append(" 		,'" + c_paramArray[0][5] + "' 	\n") 	//IP_addr
					.append(" 		,'" + c_paramArray[0][6] + "' 	\n") 	//regist_no_rev
					.append(" 		,'" + c_paramArray[0][7] + "' 	\n") 	//document_no_rev
					.append(" 		,'" + c_paramArray[0][8] + "' 	\n") 	//member_key
					.append(" 	) \n")
					.toString();

			resultInt = super.excuteUpdate(con, sql.toString());
			if (resultInt < 0) {
				con.rollback();
				return EventDefine.E_DOEXCUTE_ERROR ;
			}
			
			con.commit();
			
		} catch(Exception e) {
			LoggingWriter.setLogError("M000S100000E301()","==== SQL ERROR ===="+ e.getMessage() + "\n" + sql.toString());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M000S100000E301()","==== finally ===="+ e.getMessage());
				}
	    	} else {
	    	}
	    }
		ioParam.setResultString(resultString);
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
	    return EventDefine.E_QUERY_RESULT;
	}	

	
	//버턴의 클릭제한을 위한 STATUS
	public int E704(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			// 클라이언트로 부터 받은 파라미터를 옮겨 담는다.
			String rcvData = (String)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			// 클라이언트로 부터 받은 파라미터를 쪼개어서 배열에 담는다.
			String[][] c_paramArray = CommonFunction.getConvString2DoubleArray(rcvData);
			
			String sql = new StringBuilder()
					.append("SELECT\n")
					.append("	prev_status,\n")
					.append("	status_code,\n")
					.append("	next_status,\n")
					.append("	modify_status,\n")
					.append("	dlete_status,\n")
					.append("	plan_status,\n")
					.append("	start_status,\n")
					.append("	process_name,\n")
					.append("	main_db_table,\n")
					.append("	number_gubun,\n")
					.append("	class_id,		\n")
					.append("	process_gubun	\n")
					.append("FROM\n")
					.append("	vtbm_systemcode \n")
					.append("WHERE 1=1				\n")
					.append("	AND class_id = '" + c_paramArray[0][0] + "' \n") // M02S050100.JSP
					.append("	AND process_gubun like '" + c_paramArray[0][1] + "%' \n") // M02S050100.JSP process_gubun
					.toString();
			
			resultString = super.excuteQueryString(con, sql.toString());
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M000S100000E704()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M000S100000E704()","==== finally ===="+ e.getMessage());
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


	public int E904(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			// 클라이언트로 부터 받은 파라미터를 옮겨 담는다.
			String rcvData = (String)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			// 클라이언트로 부터 받은 파라미터를 쪼개어서 배열에 담는다.
			String[][] c_paramArray = CommonFunction.getConvString2DoubleArray(rcvData);

			String sql = new StringBuilder()
					.append("WITH GET_STATUS AS (			\n")
					.append("	SELECT						\n")
					.append("		class_id,				\n")
					.append("		prev_status,			\n")
					.append("		status_code,			\n")
					.append("		next_status				\n")
					.append("	FROM tbm_systemcode			\n")
					.append("	WHERE class_id = '" + c_paramArray[0][0] + "' \n") // M02S050100.JSP
					.append(")								\n")
					.append(",GET_PREV AS (					\n")
					.append("	SELECT 						\n")
					.append("		B.class_id AS curr_page,\n")
					.append("		A.class_id AS prev_page,\n")
					.append("		A.prev_status AS prev_status,	\n")
					.append("		B.status_code AS curr_status,	\n")
					.append("		A.status_code,			\n")
					.append("		A.next_status			\n")
					.append("	FROM  tbm_systemcode A 		\n")
					.append("	INNER JOIN GET_STATUS B 	\n")
					.append("	ON A.status_code = B.prev_status	\n")
					.append(")				\n")
					.append("SELECT			\n")
					.append("	Q.order_no,			--이 오더번호\n")
					.append("	C.cust_nm,			\n")
					.append("	D.product_nm,		\n")
					.append("	order_detail,		--이 디테일번호\n")
					.append("	order_status,		\n")
					.append("	prev_status,		\n")
					.append("	curr_status,		--현재 상태\n")
					.append("	curr_page,			--현재페이지\n")
					.append("	prev_page			\n")
					.append("FROM tbi_queue Q \n")
					.append("INNER JOIN GET_PREV P \n")
					.append("ON Q.order_status = P.curr_status\n")
					.append("INNER JOIN tbi_order O \n")
					.append("ON Q.order_no = O.order_no\n")
					.append("INNER JOIN vtbm_customer C \n")
					.append("ON O.cust_cd = C.cust_cd\n")
					.append("INNER JOIN tbm_product D \n")
					.append("ON O.prod_cd = D.prod_cd\n")
					.toString();
			
			resultString = super.excuteQueryString(con, sql.toString());
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M000S100000E904()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M000S100000E904()","==== finally ===="+ e.getMessage());
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
	
	//온도 한계기준이탈 값 찾아서 알림톡 전송
	public int E992(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			logger.debug("JSONObject jArray rcvData="+ jArray.toString());
			
			//한계기준이탈시
		//				String sql = new StringBuilder()
		//						.append("WITH censordata AS (\n")
		//						.append("        SELECT\n")
		//						.append("           DISTINCT\n")
		//						.append("           censor_no,\n")
		//						.append("            MAX(censor_data_create_time) AS censor_data_create_time\n")
		//						.append("        FROM\n")
		//						.append("           haccp_censor_data\n")
		//						.append("        GROUP BY\n")
		//						.append("           censor_no\n")
		//						.append(")\n")
		//						.append("SELECT\n")
		//						.append("        hci.censor_name,\n")
		//						.append("        cd.censor_value,\n")
		//						.append("        li.min_value,\n")
		//						.append("        li.max_value,\n")
		//						.append("        cd.censor_data_create_time,\n")
		//						.append("        hci.censor_type\n")
		//						.append("FROM censordata A\n")
		//						.append("INNER JOIN  haccp_censor_data cd\n")
		//						.append("        ON A.censor_no = cd.censor_no  AND A. censor_data_create_time = cd.censor_data_create_time\n")
		//						.append("        INNER JOIN haccp_censor_info hci ON  hci.censor_no = cd.censor_no\n")
		//						.append("        RIGHT OUTER JOIN haccp_ccp_info ci\n")
		//						.append("        ON cd.censor_no = ci.censor_no\n")
		//						.append("        LEFT OUTER JOIN haccp_limit_info li ON ci.ccp_no = li.ccp_no\n")
		//						.append("WHERE\n")
		//						.append("cd.member_key = '605-86-32975'\n")
		//						.append("AND hci.censor_type ='temperature'\n")
		//						.append("AND ci.monitor_yn ='Y'\n")
		//						.append("ORDER BY  min_value desc\n")
		//						.toString();
			
			//한계기준 두번 연속 이탈시
			String sql = new StringBuilder()
					.append("WITH censordata AS (   						\n")
					.append("        SELECT DISTINCT    					\n")
					.append("           censor_no,							\n")
					.append("           censor_value0, 						\n")
					.append("           censor_rev_no,						\n")
					.append("           censor_date, 						\n")
					.append("           censor_data_create_time 			\n")
					.append("        FROM									\n")
					.append("           (SELECT * FROM haccp_censor_data a			 					  \n")
					.append("           WHERE censor_date = (SELECT MAX(censor_date) 					  \n")
					.append("           FROM haccp_censor_data)       			 					  	  \n")
					.append("  			) b 															  \n")
					.append("        WHERE censor_data_create_time = (SELECT MAX(censor_data_create_time) \n")
					.append("        											 FROM haccp_censor_data c \n")
					.append("                                        WHERE b.censor_no = c.censor_no 	  \n")
					.append(" 										 AND b.censor_date = c.censor_date)   \n")
					.append("		  AND censor_no != 'temp_dev06'\n")
					.append(" 		  AND ! TO_CHAR(censor_data_create_time, 'HH24:MI') BETWEEN TIME '08:00' AND TIME '17:00'\n")
					.append("), 											\n")
					.append("ex_value AS (									\n")
					.append("		SELECT DISTINCT 						\n")
					.append("			censor_no, 							\n")
					.append("			censor_value0,						\n")
					.append("           censor_rev_no,	 					\n")
					.append("           censor_data_create_time 			\n")
					.append("        FROM									\n")
					.append("           (SELECT * FROM haccp_censor_data a			 					  \n")
					.append("           WHERE censor_date = (SELECT MAX(censor_date) 					  \n")
					.append("           FROM haccp_censor_data)        								  	  \n")
					.append("  			) d 															  \n")
					.append("        WHERE censor_data_create_time = (SELECT MAX(censor_data_create_time) \n")
					.append("        											 FROM haccp_censor_data e \n")
					.append("                                        WHERE d.censor_no = e.censor_no 	  \n")
					.append(" 										 AND d.censor_date = e.censor_date   \n")
					.append("  										 AND censor_data_create_time NOT IN   \n")
					.append(" 										 (SELECT MAX(censor_data_create_time) \n")
					.append(" 										 FROM haccp_censor_data f			  \n")
					.append("  										 WHERE censor_date = (SELECT MAX(censor_date) \n")
					.append("  										 FROM haccp_censor_data)  GROUP BY censor_no) \n")
					.append("  										 GROUP BY censor_no) 				  \n")
					.append("		  AND censor_no != 'temp_dev06'\n")
					.append(" 		  AND ! TO_CHAR(censor_data_create_time, 'HH24:MI') BETWEEN TIME '08:00' AND TIME '17:00'\n")
					.append(") 										\n")
					.append("SELECT									\n")
					.append("        hci.censor_name,				\n")
					.append("        A.censor_value0,				\n")
					.append("        hci.min_value,					\n")
					.append("        hci.max_value,					\n")
					.append("        EX.censor_value0,				\n")
					.append("        A.censor_data_create_time,		\n")
					.append("        EX.censor_data_create_time,	\n")
					.append("        hci.censor_type				\n")
					.append("FROM censordata A						\n")
					.append("INNER JOIN haccp_censor_info hci    	\n")
					.append("ON hci.censor_no = A.censor_no 	   	\n")
					.append("AND hci.censor_rev_no = A.censor_rev_no\n")
					.append("INNER JOIN ex_value EX 			   	\n")
					.append("ON A.censor_no = EX.censor_no       	\n")
					.append("AND A.censor_rev_no = EX.censor_rev_no \n")
					.append("WHERE hci.censor_type ='TEMPERATURE'	\n")
					.append("AND  hci.power_onoff = 'Y' 			\n")
					.append("AND  A.censor_date = SYSDATE 			\n")
					.append("ORDER BY min_value desc				\n")
					.toString();
			
			resultString = super.excuteQueryString(con, sql.toString());
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M000S100000E992()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
		} finally {
			if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M000S100000E992()","==== finally ===="+ e.getMessage());
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

	//카톡 알람기능 on
	public int E993(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			logger.debug("JSONObject jArray rcvData="+ jArray.toString());
			
			String sql = new StringBuilder()
					.append("UPDATE haccp_censor_info \n")
					.append("SET power_onoff = 'Y' 	  \n")
					.toString();
			
			resultInt = super.excuteUpdate(con, sql);
			
			if (resultInt < 0) {
				ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
				con.rollback();
				return EventDefine.E_DOEXCUTE_ERROR ;
			}
    		
			con.commit();
			
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M000S100000E993()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M000S100000E993()","==== finally ===="+ e.getMessage());
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
	
	//카톡 알람기능 off
	public int E994(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			logger.debug("JSONObject jArray rcvData="+ jArray.toString());
			
			String sql = new StringBuilder()
					.append("UPDATE haccp_censor_info \n")
					.append("SET power_onoff = 'N' 	  \n")
					.toString();
			
			resultInt = super.excuteUpdate(con, sql);
			
			if (resultInt < 0) {
				ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
				con.rollback();
				return EventDefine.E_DOEXCUTE_ERROR ;
			}
    		
			con.commit();
			
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M000S100000E994()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M000S100000E994()","==== finally ===="+ e.getMessage());
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
	
	//페이지 로드시 현재 알람 on/off 여부 조회
	public int E995(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			String sql = new StringBuilder()
					.append("SELECT	DISTINCT		  \n")
					.append("power_onoff			  \n")
					.append("FROM haccp_censor_info   \n")
					.toString();
			
			resultString = super.excuteQueryString(con, sql.toString());
			
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M000S100000E992()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M000S100000E992()","==== finally ===="+ e.getMessage());
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
	
	//Table의 특정 조건의 Row건수 Return
	public int E999(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			// 클라이언트로 부터 받은 파라미터를 옮겨 담는다.
			String rcvData = (String)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			// 클라이언트로 부터 받은 파라미터를 쪼개어서 배열에 담는다.
			String[][] c_paramArray = CommonFunction.getConvString2DoubleArray(rcvData);
			
			String sql = new StringBuilder()
					.append("SELECT\n")
					.append("	count(*) as toTalRows \n")
					.append("FROM " + c_paramArray[0][0] + "\n")
					.append("WHERE 1=1 " + c_paramArray[0][1] + "		\n")
					.toString();
			
			resultString = super.excuteQueryString(con, sql.toString());
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M000S100000E999()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M000S100000E999()","==== finally ===="+ e.getMessage());
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