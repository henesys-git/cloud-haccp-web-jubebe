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


/**
 * ���� : �̺�ƮID�� �޼ҵ� ����
 */
public  class M909S070100 extends SqlAdapter{
	Connection con = null;
	PreparedStatement pstmt = null;
	String resultString = "";
	int resultInt = -1;
	StringBuffer sql = new StringBuffer();
	
	String[][] v_paramArray = new String[0][0]; 
	Class[] optClass = null;
	Object[] optObj = null;
	Object obj = null;
	
	public M909S070100(){
	}
	
	/**
	 * ����ڰ� �����ؼ� �Ķ���� �����ϴ� method.
	 * @param	ioParam , p_sql
	 * @return the desired integer.
	 */
	public int custParamCheck(InoutParameter ioParam, StringBuffer p_sql){
		int paramInt = 0;
		return paramInt;
	}
	/**
	 * �Է��Ķ��Ÿ�� 2���� �����ΰ�� �Ķ���� �����ϴ� method.
	 * @param	ioParam , p_sql
	 * @return the desired integer.
	 */
	public int paramCheck(InoutParameter ioParam, StringBuffer p_sql){
		v_paramArray = super.getParamCheck(ioParam,p_sql);
		return v_paramArray[0].length;
	}
	/**
	 * �Է��Ķ��Ÿ���� �̺�ƮID���� �޼ҵ� ȣ���ϴ� method.
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
			
			Method method = M909S070100.class.getMethod(event,optClass);
			LoggingWriter.setLogDebug(M909S070100.class.getName(),"==== " + event + " EventMethod Create Success ====");

			obj = method.invoke(M909S070100.class.newInstance(),optObj);
			doExcute_result = CommonFunction.getInt(obj.toString());
			
	    } catch (Exception ex) {
	    	doExcute_result = EventDefine.E_DOEXCUTE_INIT;
			ioParam.setMessage(MessageDefine.M_NO_EVENTID);
			LoggingWriter.setLogError(M909S070100.class.getName(),"==== EventID Not define : EVENT ID [ " + ioParam.getEventID() + "]");
	    } finally {
	    	obj = null;
			optClass = null;
			optObj = null;
	    }
	    long endTime = System.currentTimeMillis();
		long runningTime = endTime - startTime;
		LoggingWriter.setLogAll(M909S070100.class.getName(),"==== Query [����ð�  : " + runningTime + " ms]");
		
		return doExcute_result;
	}

	public int E101(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			
			sql = new StringBuffer();
			sql.append(" insert into tbm_customer ( 	\n");
			sql.append(" 		CUST_CD					\n"); 
			sql.append(" 		,revision_no			\n"); 
			sql.append(" 		,CUST_NM				\n"); 
			sql.append(" 		,bizno					\n"); 
			sql.append(" 		,telno					\n"); 
			sql.append(" 		,address				\n"); 
			sql.append(" 		,company_type_b			\n");
			sql.append(" 		,company_type_m			\n"); 
			sql.append(" 		,uptae					\n"); 
			sql.append(" 		,jongmok				\n"); 
			sql.append(" 		,boss_name				\n"); 
			//sql.append(" 		,refno					\n"); //����������ȣ(�̷���)�ʿ��� ȭ�鿡 �߰��Ͽ� ó���ؾ��� 2019-10-21 JH�߰�
			sql.append("		,start_date				\n");
			sql.append("		,duration_date			\n");
			sql.append("		,create_user_id			\n");
			sql.append("		,create_date			\n");
			sql.append("		,modify_user_id			\n");
			sql.append("		,modify_reason			\n");
			sql.append("		,modify_date			\n");
			sql.append(" 		,member_key				\n"); // member_key_insert
			sql.append(" 	) values ( 					\n");
			sql.append(" 		 '" + jArray.get("cust_cd") + "' 	\n"); //CUST_CD = BIZNO
			sql.append(" 		,'" + jArray.get("RevisionNo") + "' 	\n"); //revision_no
			sql.append(" 		,'" + jArray.get("CustName") + "' 	\n"); //CUST_NM
			sql.append(" 		,'" + jArray.get("BizNo") + "' 	\n"); //BIZNO
			sql.append(" 		,'" + jArray.get("TelNo") + "' 	\n"); //telno
			sql.append(" 		,'" + jArray.get("Juso") + "'	\n"); //address
			sql.append(" 		,'" + jArray.get("IoGubun") + "' 	\n"); //IO_GB
			sql.append(" 		,'" + jArray.get("LocationNm") + "' 	\n"); //��������
			sql.append(" 		,'" + jArray.get("Uptae") + "' 	\n"); //uptae
			sql.append(" 		,'" + jArray.get("Jongmok") + "' 	\n"); //jongmok
			sql.append(" 		,'" + jArray.get("BossName") + "' 	\n"); //boss_name
			//sql.append(" 		,'" + jArray.get("Log_refno") + "' 	\n"); ////����������ȣ(�̷���)�ʿ��� ȭ�鿡 �߰��Ͽ� ó���ؾ��� 2019-10-21 JH�߰�
			sql.append("	 	,'" + jArray.get("StartDate") + "'	\n"); //start_date
			sql.append("	 	,'9999-12-31'	\n"); //duration_date
			sql.append("	 	,'" + jArray.get("user_id") + "'	\n"); //create_user_id
			sql.append("	 	,SYSDATETIME					\n"); //create_date
			sql.append("	 	,'" + jArray.get("user_id") + "'	\n"); //modify_user_id
			sql.append("	 	,'���ʵ��'	\n"); //modify_reason
			sql.append("	 	,SYSDATETIME					\n"); //modify_date
			sql.append(" 		,'" + jArray.get("member_key") + "' \n"); //member_key_values
			sql.append("	)									\n");

			// super�� excuteUpdate�� 3������ �ִ�.
			// ù°�� super.excuteUpdate(con, sql.toString(), v_paramArray)���� �̸�,
			// PreparedStatement�� ����ϱ� ���� �Ķ���͵��� ��ɿ� ��� ������ üũ�� �ؼ� �����ϴ� �����̴�. �׸���
			// �ι�°�� super.excuteUpdate(con, Vector)�ε�, ��Ƽ �ο츦 ����ϱ� ���� ���õ� ��ġ�̴�.
			// ����°�� �ϳ��� SQL�� String���� �޾Ƽ� ó���ϴ� ����̴�.
			// ���� ���� SQL���¶��.. �翬�� 1���� �ο쿡 �ش�ǹǷ� ����° �޽�带 ����ϴ� ���� ���ϴ�.
			resultInt = super.excuteUpdate(con, sql.toString());
			if (resultInt < 0) {
				ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
			} else {
				ioParam.setMessage(resultInt + "�� " + MessageDefine.M_INSERT_RESULT);
			}
		} catch(Exception e) {
			LoggingWriter.setLogError("M909S070100E101()","==== SQL ERROR ===="+ e.getMessage() + "\n" + sql.toString());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M909S070100E101()","==== finally ===="+ e.getMessage());
				}
	    	} else {
	    	}
	    }
	    // ��� ���� ������ ���� �Ķ���͵��� ���̿� �Ķ���Ϳ� �����Ѵ�.
		ioParam.setResultString(resultString);
		// ���ۿ��� ó���� Į���� ������ Ŭ���̾�Ʈ���� ������ ���� �����´�.
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
		// �� ó���Ǿ��ٴ� �޽����� Ŭ���̾�Ʈ���� ������ ���� I/O�Ķ���Ϳ� �����Ѵ�.
		// ������ ����� ���� �����ϱ� ���ؼ� ���´�.
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
			
			con.setAutoCommit(false);
			
			// ���� ���� �������� ���� �����������ڸ� �̹��� �������ڿ��� �Ϸ縦 �� ��¥�� �����Ѵ�.
			String sqlPre = new StringBuilder()
					.append("UPDATE tbm_customer SET	\n")
					.append(" duration_date = to_char(TO_DATE('" + jArray.get("StartDate") + "', 'YYYY-MM-DD')-1 , 'YYYY-MM-DD')	\n")
					.append(" 	,member_key = 	'" + jArray.get("member_key") + "'		\n")
					.append("WHERE CUST_CD = '" + jArray.get("BizNo") + "'\n")
					// 13��°�� ������ �������ڵ尡 ���´�.
					.append("	AND revision_no = '" + jArray.get("RevisionNo_Target") + "'\n")
					.append(" 	AND member_key = '" + jArray.get("member_key") + "' \n") //sql.member_key_select, update, delete
					.toString();
			
			System.out.println(sqlPre.toString());
			
			resultInt = super.excuteUpdate(con, sqlPre.toString());
			if (resultInt < 0) {
				con.rollback();
				ioParam.setMessage(MessageDefine.M_UPDATE_FAILED);
				return resultInt;
			} else {
				ioParam.setMessage(resultInt + "�� " + MessageDefine.M_UPDATE_RESULT);
			}

			sql = new StringBuffer();
			sql.append(" insert into tbm_customer ( 	\n");
			sql.append(" 		CUST_CD					\n"); 
			sql.append(" 		,revision_no			\n"); 
			sql.append(" 		,CUST_NM				\n"); 
			sql.append(" 		,bizno					\n"); 
			sql.append(" 		,telno					\n"); 
			sql.append(" 		,address				\n"); 
			sql.append(" 		,company_type_b			\n");
			sql.append(" 		,company_type_m			\n"); 
			sql.append(" 		,uptae					\n"); 
			sql.append(" 		,jongmok				\n"); 
			sql.append(" 		,boss_name				\n"); 
			sql.append(" 		,refno				\n"); //����������ȣ(�̷���)�ʿ��� ȭ�鿡 �߰��Ͽ� ó���ؾ��� 2019-10-21 JH�߰�
			sql.append("		,start_date				\n");
			sql.append("		,duration_date			\n");
			sql.append("		,create_user_id			\n");
			sql.append("		,create_date			\n");
			sql.append("		,modify_user_id			\n");
			sql.append("		,modify_reason			\n");
			sql.append("		,modify_date			\n");
			sql.append(" 		,member_key				\n"); // member_key_insert
			sql.append(" 	) values ( 					\n");
			sql.append(" 		 '" + jArray.get("cust_cd") + "' 	\n"); //CUST_CD = BIZNO
			sql.append(" 		,'" + jArray.get("RevisionNo") + "' 	\n"); //revision_no
			sql.append(" 		,'" + jArray.get("CustName") + "' 	\n"); //CUST_NM
			sql.append(" 		,'" + jArray.get("BizNo") + "' 	\n"); //BIZNO
			sql.append(" 		,'" + jArray.get("TelNo") + "' 	\n"); //telno
			sql.append(" 		,'" + jArray.get("Juso") + "'	\n"); //address
			sql.append(" 		,'" + jArray.get("IoGubun") + "' 	\n"); //IO_GB
			sql.append(" 		,'" + jArray.get("LocationNm") + "' 	\n"); //������ ��������
			sql.append(" 		,'" + jArray.get("Uptae") + "' 	\n"); //uptae
			sql.append(" 		,'" + jArray.get("Jongmok") + "' 	\n"); //jongmok
			sql.append(" 		,'" + jArray.get("BossName") + "' 	\n"); //boss_name
			sql.append(" 		,'" + jArray.get("Log_refno") + "' 	\n"); ////����������ȣ(�̷���)�ʿ��� ȭ�鿡 �߰��Ͽ� ó���ؾ��� 2019-10-21 JH�߰�
			sql.append("	 	,'" + jArray.get("StartDate") + "'	\n"); //start_date
			sql.append("	 	,'9999-12-31'	\n"); //duration_date
			sql.append("	 	,'" + jArray.get("user_id") + "'	\n"); //create_user_id
			sql.append("	 	,SYSDATETIME					\n"); //create_date
			sql.append("	 	,'" + jArray.get("user_id") + "'	\n"); //modify_user_id
			sql.append("	 	,'����'	\n"); //modify_reason
			sql.append("	 	,SYSDATETIME					\n"); //modify_date
			sql.append(" 		,'" + jArray.get("member_key") + "' \n"); //member_key_values
			sql.append("	)									\n");

			// super�� excuteUpdate�� 3������ �ִ�.
			// ù°�� super.excuteUpdate(con, sql.toString(), v_paramArray)���� �̸�,
			// PreparedStatement�� ����ϱ� ���� �Ķ���͵��� �迭�� ��� ������ üũ�� �ؼ� �����ϴ� �����̴�. �׸���
			// �ι�°�� super.excuteUpdate(con, Vector)�ε�, ��Ƽ �ο츦 ����ϱ� ���� ���õ� ��ġ�̴�.
			// ����°�� �ϳ��� SQL�� String���� �޾Ƽ� ó���ϴ� ����̴�.
			// ���� ���� SQL���¶��.. �翬�� 1���� �ο쿡 �ش�ǹǷ� ����° �޽�带 ����ϴ� ���� ���ϴ�.
			resultInt = super.excuteUpdate(con, sql.toString());
			if (resultInt < 0) {
				con.rollback();
				ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
				return resultInt;
			} else {
				ioParam.setMessage(resultInt + "�� " + MessageDefine.M_INSERT_RESULT);
			}
			
			con.commit();
		} catch(Exception e) {
			LoggingWriter.setLogError("M909S070100E102()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M909S070100E102()","==== finally ===="+ e.getMessage());
				}
	    	} else {
	    	}
	    }
	    // ��� ���� ������ ���� �Ķ���͵��� ���̿� �Ķ���Ϳ� �����Ѵ�.
		ioParam.setResultString(resultString);
		// ���ۿ��� ó���� Į���� ������ Ŭ���̾�Ʈ���� ������ ���� �����´�.
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
		// �� ó���Ǿ��ٴ� �޽����� Ŭ���̾�Ʈ���� ������ ���� I/O�Ķ���Ϳ� �����Ѵ�.
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
			
			// Ŭ���̾�Ʈ�� ���� ���� �Ķ���͸� �Ű� ��´�.
//			String rcvData = (String)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			
			// Ŭ���̾�Ʈ�� ���� ���� �Ķ���͸� �ɰ�� �迭�� ��´�.
//			String[][] c_paramArray = CommonFunction.getConvString2DoubleArray(rcvData);

			sql = new StringBuffer();
			sql.append(" delete from TBM_CUSTOMER \n");
			sql.append(" where CUST_CD = '" + jArray.get("cust_cd") + "' \n");
			//sql.append(" 	AND revision_no = '" + jArray.get("RevisionNo") + "' \n");
			sql.append(" 	AND company_type_b = '" + jArray.get("IoGubun") + "' \n");
			sql.append(" 	AND member_key = '" + jArray.get("member_key") + "' \n"); //sql.member_key_select, update, delete

			// super�� excuteUpdate�� 3������ �ִ�.
			// ù°�� super.excuteUpdate(con, sql.toString(), v_paramArray)���� �̸�,
			// PreparedStatement�� ����ϱ� ���� �Ķ���͵��� �迭�� ��� ������ üũ�� �ؼ� �����ϴ� �����̴�. �׸���
			// �ι�°�� super.excuteUpdate(con, Vector)�ε�, ��Ƽ �ο츦 ����ϱ� ���� ���õ� ��ġ�̴�.
			// ����°�� �ϳ��� SQL�� String���� �޾Ƽ� ó���ϴ� ����̴�.
			// ���� ���� SQL���¶��.. �翬�� 1���� �ο쿡 �ش�ǹǷ� ����° �޽�带 ����ϴ� ���� ���ϴ�.
			resultInt = super.excuteUpdate(con, sql.toString());
			if (resultInt < 0) {
				ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
				return resultInt;
			} else {
				ioParam.setMessage(resultInt + "�� " + MessageDefine.M_INSERT_RESULT);
			}
		} catch(Exception e) {
			LoggingWriter.setLogError("M909S070100E103()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M909S070100E103()","==== finally ===="+ e.getMessage());
				}
	    	} else {
	    	}
	    }
	    // ��� ���� ������ ���� �Ķ���͵��� ���̿� �Ķ���Ϳ� �����Ѵ�.
		ioParam.setResultString(resultString);
		// ���ۿ��� ó���� Į���� ������ Ŭ���̾�Ʈ���� ������ ���� �����´�.
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
		// �� ó���Ǿ��ٴ� �޽����� Ŭ���̾�Ʈ���� ������ ���� I/O�Ķ���Ϳ� �����Ѵ�.
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
			
			// Ŭ���̾�Ʈ�� ���� ���� �Ķ���͸� �Ű� ��´�.
//			String rcvData = (String)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			// Ŭ���̾�Ʈ�� ���� ���� �Ķ���͸� �ɰ�� �迭�� ��´�.
			// rcvData = [���浵]
//			String[][] c_paramArray = CommonFunction.getConvString2DoubleArray(rcvData);

			sql = new StringBuffer();
			sql.append(" select \n"); 
			sql.append(" 		CUST_CD					\n"); 
			sql.append(" 		,revision_no			\n"); 
			sql.append(" 		,CUST_NM				\n"); 
			sql.append(" 		,bizno					\n"); 
			sql.append(" 		,telno					\n"); 
			sql.append(" 		,address				\n"); 
			sql.append(" 		,company_type_b			\n"); 
			sql.append(" 		,(case when company_type_b='CUSTOMER_GUBUN_BIG01' then '���԰ŷ�ó'"
								   + " when company_type_b='CUSTOMER_GUBUN_BIG02' then '����ŷ�ó'"
								   + " else '���¾�ü' end) \n");
			sql.append(" 		,uptae					\n"); 
			sql.append(" 		,jongmok				\n"); 
			sql.append(" 		,boss_name				\n"); 
			sql.append("		,start_date				\n");
			sql.append("		,duration_date			\n");
			sql.append("		,create_user_id			\n");
			sql.append("		,create_date			\n");
			sql.append("		,modify_user_id			\n");
			sql.append("		,modify_reason			\n");
			sql.append("		,modify_date			\n");
			sql.append("		,refno					\n");//�̷��� ����������ȣ//����������ȣ(�̷���)�ʿ��� ȭ�鿡 �߰��Ͽ� ó���ؾ��� 2019-10-21 JH�߰�
			sql.append(" 		,company_type_m			\n");
			sql.append(" from tbm_customer \n"); 
			sql.append(" where  CUST_CD like '%%' \n"); 
			sql.append(" 		and company_type_b like '%%' \n"); 
			sql.append(" 	AND member_key = '" + jArray.get("member_key") + "' \n"); //sql.member_key_select, update, delete
			sql.append(" 	order by CUST_NM \n");

			resultString = super.excuteQueryString(con, sql.toString());
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M909S070100E104()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M909S070100E104()","==== finally ===="+ e.getMessage());
				}
	    	} else {
	    	}
	    }
	    // ��� ���� ������ ���� �Ķ���͵��� ���̿� �Ķ���Ϳ� �����Ѵ�.
		ioParam.setResultString(resultString);
		// ���ۿ��� ó���� Į���� ������ Ŭ���̾�Ʈ���� ������ ���� �����´�.
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
		// �� ó���Ǿ��ٴ� �޽����� Ŭ���̾�Ʈ���� ������ ���� I/O�Ķ���Ϳ� �����Ѵ�.
    	ioParam.setMessage(MessageDefine.M_QUERY_OK);
	    return EventDefine.E_QUERY_RESULT;
	}
	
	public int E105(InoutParameter ioParam) {
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));

			sql = new StringBuffer();
			sql.append(" select \n"); 
			sql.append(" 		CUST_CD					\n"); 
			sql.append(" 		,revision_no			\n"); 
			sql.append(" 		,CUST_NM				\n"); 
			sql.append(" 		,bizno					\n"); 
			sql.append(" 		,telno					\n"); 
			sql.append(" 		,address				\n"); 
			sql.append(" 		,company_type_b					\n"); 
			sql.append(" 		,(case when company_type_b='CUSTOMER_GUBUN_BIG01' then '���԰ŷ�ó'"
								   + " when company_type_b='CUSTOMER_GUBUN_BIG02' then '����ŷ�ó'"
								   + " else '���¾�ü' end) \n");
			sql.append(" 		,uptae					\n"); 
			sql.append(" 		,jongmok				\n"); 
			sql.append(" 		,boss_name				\n"); 
			sql.append("		,start_date				\n");
			sql.append("		,duration_date			\n");
			sql.append("		,create_user_id			\n");
			sql.append("		,create_date			\n");
			sql.append("		,modify_user_id			\n");
			sql.append("		,modify_reason			\n");
			sql.append("		,modify_date			\n");
			sql.append("		,refno			\n");//�̷��� ����������ȣ//����������ȣ(�̷���)�ʿ��� ȭ�鿡 �߰��Ͽ� ó���ؾ��� 2019-10-21 JH�߰�
			sql.append(" 		,company_type_m			\n");
			sql.append(" from tbm_customer A1\n"); 
			sql.append(" where  CUST_CD like '%%' \n"); 
			sql.append(" 		and company_type_b like '%%' \n");
			sql.append(" 		and TO_CHAR(SYSDATE,'YYYY-MM-DD') BETWEEN  start_date AND duration_date\n");
			sql.append(" 	AND member_key = '" + jArray.get("member_key") + "' \n"); //sql.member_key_select, update, delete
			sql.append("	AND A1.revision_no = (SELECT MAX(revision_no) \n");
			sql.append("						  FROM tbm_customer A2 \n");
			sql.append("						  WHERE A2.cust_cd = A1.cust_cd) \n");
			sql.append(" 	order by CUST_NM \n");

			resultString = super.excuteQueryString(con, sql.toString());
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M909S070100E105()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M909S070100E105()","==== finally ===="+ e.getMessage());
				}
	    	} else {
	    	}
	    }
	    // ��� ���� ������ ���� �Ķ���͵��� ���̿� �Ķ���Ϳ� �����Ѵ�.
		ioParam.setResultString(resultString);
		// ���ۿ��� ó���� Į���� ������ Ŭ���̾�Ʈ���� ������ ���� �����´�.
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
		// �� ó���Ǿ��ٴ� �޽����� Ŭ���̾�Ʈ���� ������ ���� I/O�Ķ���Ϳ� �����Ѵ�.
    	ioParam.setMessage(MessageDefine.M_QUERY_OK);
	    return EventDefine.E_QUERY_RESULT;
	}
	
	//���ּ���� ����ó ��ȸ �˾�������
	public int E114(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));

			sql = new StringBuffer();
			sql.append("SELECT 				\n"); 
			sql.append("	cust_nm, 		\n");  
			sql.append(" 	cust_cd, 		\n"); 
			sql.append(" 	revision_no, 	\n"); 
			sql.append(" 	uptae, 			\n"); 
			sql.append(" 	jongmok, 		\n");
			sql.append(" 	address, 		\n"); 
			sql.append(" 	bizno, 			\n"); 
			sql.append(" 	boss_name, 		\n"); 
			sql.append(" 	telno,	 		\n"); 
			sql.append(" 	refno	 		\n"); 
			sql.append("FROM vtbm_customer \n"); 
			sql.append("WHERE  CUST_NM like '%" + jArray.get("CUST_NM") + "%' 	\n"); 
			sql.append("  AND company_type_b like '%" + jArray.get("Custom_gubun") + "%' \n"); 
			sql.append("ORDER BY CUST_NM \n");

			resultString = super.excuteQueryString(con, sql.toString());
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M909S070100E114()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M909S070100E114()","==== finally ===="+ e.getMessage());
				}
	    	} else {
	    	}
	    }
	    // ��� ���� ������ ���� �Ķ���͵��� ���̿� �Ķ���Ϳ� �����Ѵ�.
		ioParam.setResultString(resultString);
		// ���ۿ��� ó���� Į���� ������ Ŭ���̾�Ʈ���� ������ ���� �����´�.
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
		// �� ó���Ǿ��ٴ� �޽����� Ŭ���̾�Ʈ���� ������ ���� I/O�Ķ���Ϳ� �����Ѵ�.
    	ioParam.setMessage(MessageDefine.M_QUERY_OK);
	    return EventDefine.E_QUERY_RESULT;
	}
	public int E204(InoutParameter ioParam) {
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			System.out.println("JSONObject jArray rcvData="+ jArray.toString());

			sql = new StringBuffer();
			sql.append(" select \n"); 
			sql.append(" 		CUST_CD					\n"); 
			sql.append(" 		,revision_no			\n"); 
			sql.append(" 		,CUST_NM				\n"); 
			sql.append(" 		,bizno					\n"); 
			sql.append(" 		,telno					\n"); 
			sql.append(" 		,address				\n"); 
			sql.append(" 		,(case when company_type_b='CUSTOMER_GUBUN_BIG02' then '����ŷ�ó'"
								   + " when company_type_b='CUSTOMER_GUBUN_BIG01' then '���԰ŷ�ó'"
								   + " else '���¾�ü' end) \n");
			sql.append(" 		,uptae					\n"); 
			sql.append(" 		,jongmok				\n"); 
			sql.append(" 		,boss_name				\n"); 
			sql.append("		,refno			\n");//�̷��� ����������ȣ//����������ȣ(�̷���)�ʿ��� ȭ�鿡 �߰��Ͽ� ó���ؾ��� 2019-10-21 JH�߰�
			sql.append("		,start_date				\n");
			sql.append("		,duration_date			\n");
			sql.append("		,create_user_id			\n");
			sql.append("		,create_date			\n");
			sql.append("		,modify_user_id			\n");
			sql.append("		,modify_reason			\n");
			sql.append("		,modify_date			\n");
			sql.append(" from tbm_customer 				\n"); 
			sql.append(" where  CUST_CD = '" + jArray.get("CUST_CD") + "' 			\n"); 
			sql.append(" 		and revision_no = '" + jArray.get("REVISION_NO") + "' 	\n");
			sql.append(" 		and company_type_b like '%" + jArray.get("IO_GB") + "%' \n");
			sql.append(" 	AND member_key = '" + jArray.get("member_key") + "' \n"); //sql.member_key_select, update, delete

			resultString = super.excuteQueryString(con, sql.toString());
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M909S070100E204()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M909S070100E204()","==== finally ===="+ e.getMessage());
				}
	    	} else {
	    	}
	    }
	    // ��� ���� ������ ���� �Ķ���͵��� ���̿� �Ķ���Ϳ� �����Ѵ�.
		ioParam.setResultString(resultString);
		// ���ۿ��� ó���� Į���� ������ Ŭ���̾�Ʈ���� ������ ���� �����´�.
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
		// �� ó���Ǿ��ٴ� �޽����� Ŭ���̾�Ʈ���� ������ ���� I/O�Ķ���Ϳ� �����Ѵ�.
    	ioParam.setMessage(MessageDefine.M_QUERY_OK);
	    return EventDefine.E_QUERY_RESULT;
	}
	
	public int E214(InoutParameter ioParam) {
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			System.out.println("JSONObject jArray rcvData="+ jArray.toString());
			
			String sql = new StringBuilder()
					.append("SELECT \n")
					.append("	COUNT(cust_cd)\n")
					.append("FROM tbm_customer A\n")
					.append("WHERE A.cust_cd LIKE '" + jArray.get("cust_cd") + "%' \n") 
					.append("AND A.member_key = '" + jArray.get("member_key") + "' 	\n")
					.toString();

			resultString = super.excuteQueryString(con, sql.toString());
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M909S070100E214()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M909S070100E214()","==== finally ===="+ e.getMessage());
				}
	    	} else {
	    	}
	    }
	    // ��� ���� ������ ���� �Ķ���͵��� ���̿� �Ķ���Ϳ� �����Ѵ�.
		ioParam.setResultString(resultString);
		// ���ۿ��� ó���� Į���� ������ Ŭ���̾�Ʈ���� ������ ���� �����´�.
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
		// �� ó���Ǿ��ٴ� �޽����� Ŭ���̾�Ʈ���� ������ ���� I/O�Ķ���Ϳ� �����Ѵ�.
    	ioParam.setMessage(MessageDefine.M_QUERY_OK);
	    return EventDefine.E_QUERY_RESULT;
	}
}