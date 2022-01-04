package mes.frame.business.M707;

import java.lang.reflect.Method;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.util.Vector;

import mes.client.conf.Config;
import mes.frame.common.EventDefine;
import mes.frame.common.HashObject;
import mes.frame.common.MessageDefine;
import mes.frame.database.JDBCConnectionPool;
import mes.frame.database.SqlAdapter;
import mes.frame.serviceinterface.InoutParameter;
import mes.frame.serviceinterface.LoggingWriter;
import mes.frame.util.CommonFunction;

/* �������̺�
-- AS��������
CREATE TABLE TB_AS_REQLIST (
       REQ_DATE             VARCHAR(10) NOT NULL,	-- ��������
       REQ_SEQNO            INTEGER(15) NOT NULL,	-- �Ϸù�ȣ
       REQ_TIME             VARCHAR(8) NULL,		-- �����ð�
       USER_ID              VARCHAR(30) NULL,		-- �����ID
       REQ_CHANNEL          VARCHAR(7) NULL,		-- ����ä��
       REQ_MAN_NAME         VARCHAR(100) NULL,		-- AS��û��
       REQ_CONTENTS         VARCHAR(2000) NULL,		-- AS��û����
       WORK_HOPE_DATE       VARCHAR(10) NULL,		-- ó���������
       OT_ID                VARCHAR(30) NOT NULL,	-- ����ID
       GEORAESA_CD          VARCHAR(20) NULL,		-- �ŷ�ó�ڵ�
       GIGONG_CD           	VARCHAR(50) NULL		-- �����ڵ�
);
ALTER TABLE TB_AS_REQLIST
       ADD  ( PRIMARY KEY (REQ_DATE, REQ_SEQNO) ) ;

-- �ŷ�ó���������
CREATE TABLE TB_GEORAESA_PROD_INFO (
       GEORAESA_CD          VARCHAR(20) NOT NULL,	-- �ŷ�ó�ڵ�
       PRODUCT_SERIAL_NO    VARCHAR(30) NOT NULL,	-- ��ǰ�Ϸù�ȣ
       GIJONG_CD           	VARCHAR(20) NULL,		-- �����ڵ�
       PROD_MODEL        	VARCHAR(20) NULL,		-- ��ǰ��
       DELIVERY_DT        	VARCHAR(10) NULL,		-- �������
       BELT_CODE            VARCHAR(7)  NULL,		-- �ǿ��ڵ�
       LATITUDE             VARCHAR(30) NULL,		-- ����
       LONGITUDE            VARCHAR(30) NULL		-- �浵
);
ALTER TABLE TB_GEORAESA_PROD_INFO
       ADD  ( PRIMARY KEY (GEORAESA_CD, PRODUCT_SERIAL_NO) ) ;


-- �������米ü�̷�
CREATE TABLE TB_CHANGE_PARTHIST (
       REQ_DATE             VARCHAR(10) NOT NULL,	-- ��������
       REQ_SEQNO            INTEGER NOT NULL,		-- �Ϸù�ȣ
       REQ_TASK_SEQNO       INTEGER NOT NULL,		-- AS�����Ϸù�ȣ
       PART_CODE            VARCHAR(56) NOT NULL,	-- ���������ڵ�
       SURYANG              DECIMAL(15,2) NULL,		-- ����
       REAL_DANGA           DECIMAL(15,2) NULL,		-- �ܰ�
       REAL_GONGIM          DECIMAL(15,2) NULL,		-- ����
       BIGO                 VARCHAR(2000) NULL		-- ���
);
ALTER TABLE TB_CHANGE_PARTHIST
       ADD  ( PRIMARY KEY (REQ_DATE, REQ_SEQNO, REQ_TASK_SEQNO, PART_CODE) ) ;


-- ó������̷�
CREATE TABLE TB_REQ_TASKHIST (
       REQ_DATE             VARCHAR(10) NOT NULL,	-- ��������
       REQ_SEQNO            INTEGER NOT NULL,		-- �Ϸù�ȣ
       REQ_TASK_SEQNO       INTEGER NOT NULL,		-- AS�۾������Ϸù�ȣ
       TASK_START_DATE      VARCHAR(10) NULL,		-- �۾���������
       TASK_START_TIME      VARCHAR(8) NULL,		-- �۾����۽ð�
       TASK_CONTENTS        VARCHAR(2000) NULL,		-- �۾�����
       PROC_DAMDANG_MAN     VARCHAR(30) NULL,		-- ó�������
       PAY_OR_NOPAY         VARCHAR(7) NULL,		-- ������������ڵ�
       IGWAN_MAN            VARCHAR(30) NULL,		-- �����̰���
       B_L_NO               VARCHAR(30) NULL,		-- 
       INVOICE_NO           VARCHAR(30) NULL,		-- 
       SERIAL_NO            VARCHAR(30) NULL,		-- ����Ϸù�ȣ[FK]
       COWORK_CODE          VARCHAR(7) NULL,		-- �����ڵ�
       PROC_STATUS_CODE     VARCHAR(7) NULL,		-- ��������ڵ�
       TASK_TYPE_CODE       VARCHAR(7) NULL,		-- ��������
       TASK_TEAM_CODE       VARCHAR(7) NULL,		-- ó�����ڵ�
       TASK_END_DATE        VARCHAR(10) NULL,		-- �۾���������
       TASK_END_TIME        VARCHAR(8) NULL			-- �۾�����ð�
);
ALTER TABLE TB_REQ_TASKHIST
       ADD  ( PRIMARY KEY (REQ_DATE, REQ_SEQNO, REQ_TASK_SEQNO) ) ;
*/

public class M707S31000 extends SqlAdapter{
	Connection con = null;
	PreparedStatement pstmt = null;
	String resultString = "";
	int resultInt = -1;
	StringBuffer sql = new StringBuffer();
	
	String[][] v_paramArray = new String[0][0]; 
	Class[] optClass = null;
	Object[] optObj = null;
	Object obj = null;
	
	public M707S31000(){
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
			
			Method method = M707S31000.class.getMethod(event,optClass);
			LoggingWriter.setLogDebug(M707S31000.class.getName(),"==== " + event + " EventMethod Create Success ====");

			obj = method.invoke(M707S31000.class.newInstance(),optObj);
			doExcute_result = CommonFunction.getInt(obj.toString());
			
	    } catch (Exception ex) {
	    	doExcute_result = EventDefine.E_DOEXCUTE_INIT;
			ioParam.setMessage(MessageDefine.M_NO_EVENTID);
			LoggingWriter.setLogError(M707S31000.class.getName(),"==== EventID Not define : EVENT ID [ " + ioParam.getEventID() + "]");
	    } finally {
	    	obj = null;
			optClass = null;
			optObj = null;
	    }
	    long endTime = System.currentTimeMillis();
		long runningTime = endTime - startTime;
		LoggingWriter.setLogAll(M707S31000.class.getName(),"==== Query [����ð�  : " + runningTime + " ms]");
		
		return doExcute_result;
	}
	
	public int E001(InoutParameter ioParam){ // 	�Ⱦ��� �޼ҵ�	�Ⱦ��� �޼ҵ�	�Ⱦ��� �޼ҵ�	�Ⱦ��� �޼ҵ�
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			// Ŭ���̾�Ʈ�� ���� ���� �Ķ���͸� �Ű� ��´�.
			String rcvData = (String)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			
			// Ŭ���̾�Ʈ�� ���� ���� �Ķ���͸� �ɰ�� �迭�� ��´�.
			String[][] c_paramArray = CommonFunction.getConvString2DoubleArray(rcvData);

			/*
req_date,
	req_seqno,
	req_time,
	user_id,
	req_channel,
	req_man_name,
	req_contents,
	work_hope_date,
	as_status_cd,
	georaesa_cd,
	product_cd			 */
			
			sql = new StringBuffer();
			sql.append(" insert into TB_AS_REQLIST ( 	\n");
			sql.append("		REQ_DATE					\n");
			sql.append("		,REQ_SEQNO					\n");
			sql.append("		,REQ_TIME					\n");
			sql.append("		,USER_ID			\n");
			sql.append("		,REQ_CHANNEL						\n");
			sql.append("		,REQ_MAN_NAME			\n");
			sql.append("		,REQ_CONTENTS			\n");
			sql.append("		,WORK_HOPE_DATE			\n");
			sql.append("		,AS_STATUS_CD			\n");
			sql.append("		,GEORAESA_CD			\n");
			sql.append("		,PRODUCT_CD			\n");
			sql.append(" 	) values ( \n");
			sql.append(" 		'" + c_paramArray[0][0] + "' \n"); //REQ_DATE
			sql.append(" 		,(select coalesce(max(REQ_SEQNO)+1,1) from TB_AS_REQLIST where REQ_DATE='" + c_paramArray[0][0] + "') \n");
			sql.append(" 		,TO_CHAR(SYSDATETIME, 'HH24:MI:SS') \n"); //REQ_TIME
			sql.append(" 		,'" + c_paramArray[0][1] + "' \n"); //USER_ID
			sql.append(" 		,'" + c_paramArray[0][2] + "' \n"); //REQ_CHANNEL
			sql.append(" 		,'" + c_paramArray[0][3] + "' \n"); //REQ_MAN_NAME
			sql.append(" 		,'" + c_paramArray[0][4] + "' \n"); //REQ_CONTENTS
			sql.append(" 		,'" + c_paramArray[0][5] + "' \n"); //WORK_HOPE_DATE
			sql.append(" 		,'" + c_paramArray[0][6] + "' \n"); //AS_STATUS_CD
			sql.append(" 		,'" + c_paramArray[0][7] + "' \n"); //GEORAESA_CD
			sql.append(" 		,'" + c_paramArray[0][8] + "' \n"); //PRODUCT_CD
			sql.append(" 	) \n");

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
			LoggingWriter.setLogError("M707S31000E001()","==== SQL ERROR ===="+ e.getMessage() + "\n" + sql.toString());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M707S31000E001()","==== finally ===="+ e.getMessage());
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

	public int E002(InoutParameter ioParam){ // 	�Ⱦ��� �޼ҵ�	�Ⱦ��� �޼ҵ�	�Ⱦ��� �޼ҵ�	�Ⱦ��� �޼ҵ�
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			// Ŭ���̾�Ʈ�� ���� ���� �Ķ���͸� �Ű� ��´�.
			String rcvData = (String)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			
			// Ŭ���̾�Ʈ�� ���� ���� �Ķ���͸� �ɰ�� �迭�� ��´�.
			String[][] c_paramArray = CommonFunction.getConvString2DoubleArray(rcvData);

	    	/* REQ_DATE[0][0] / REQ_SEQNO[0][1]
	    	 * 			sql.append(" 		'" + c_paramArray[0][2] + "' \n"); //REQ_DATE
				sql.append(" 		,(select coalesce(max(REQ_SEQNO)+1,1) from TB_AS_REQLIST where REQ_DATE='" + c_paramArray[0][2] + "') \n");
				sql.append(" 		,TO_CHAR(SYSDATETIME, 'HH24:MI:SS') \n"); //REQ_TIME
				sql.append(" 		,'" + c_paramArray[0][3] + "' \n"); //USER_ID
				sql.append(" 		,'" + c_paramArray[0][4] + "' \n"); //REQ_CHANNEL
				sql.append(" 		,'" + c_paramArray[0][5] + "' \n"); //REQ_MAN_NAME
				sql.append(" 		,'" + c_paramArray[0][6] + "' \n"); //REQ_CONTENTS
				sql.append(" 		,'" + c_paramArray[0][7] + "' \n"); //WORK_HOPE_DATE
				sql.append(" 		,'" + c_paramArray[0][8] + "' \n"); //AS_STATUS_CD
				sql.append(" 		,'" + c_paramArray[0][9] + "' \n"); //GEORAESA_CD
				sql.append(" 		,'" + c_paramArray[0][10] + "' \n"); //PRODUCT_CD

	    	 */

			sql = new StringBuffer();
			sql.append(" update TB_AS_REQLIST set \n");
			sql.append("		REQ_CHANNEL = '" + c_paramArray[0][4] + "' 			\n");
			sql.append("		,REQ_CONTENTS = '" + c_paramArray[0][6] + "' 	\n");
			sql.append("		,REQ_MAN_NAME = '" + c_paramArray[0][5] + "' 	\n");
			sql.append("		,WORK_HOPE_DATE = '" + c_paramArray[0][7] + "' 			\n");
			sql.append("		,PRODUCT_CD = '" + c_paramArray[0][10] + "' 	\n");
			sql.append(" where REQ_DATE = '" + c_paramArray[0][0] + "' 				\n");
			sql.append(" 	and REQ_SEQNO = '" + c_paramArray[0][1] + "' 				\n");
			// System.out.println(sql.toString());

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
			LoggingWriter.setLogError("M707S31000E002()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M707S31000E002()","==== finally ===="+ e.getMessage());
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

	public int E003(InoutParameter ioParam){ // 	�Ⱦ��� �޼ҵ�	�Ⱦ��� �޼ҵ�	�Ⱦ��� �޼ҵ�	�Ⱦ��� �޼ҵ�
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			// Ŭ���̾�Ʈ�� ���� ���� �Ķ���͸� �Ű� ��´�.
			String rcvData = (String)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			
			// Ŭ���̾�Ʈ�� ���� ���� �Ķ���͸� �ɰ�� �迭�� ��´�.
			String[][] c_paramArray = CommonFunction.getConvString2DoubleArray(rcvData);
			
			sql = new StringBuffer();
			sql.append(" delete from TB_AS_REQLIST \n");
			sql.append(" where REQ_DATE = '" + c_paramArray[0][0] + "' 				\n");
			sql.append(" 	and REQ_SEQNO = '" + c_paramArray[0][1] + "' 				\n");

			// super�� excuteUpdate�� 3������ �ִ�.
			// ù°�� super.excuteUpdate(con, sql.toString(), v_paramArray)���� �̸�,
			// PreparedStatement�� ����ϱ� ���� �Ķ���͵��� ��ɿ� ��� ������ üũ�� �ؼ� �����ϴ� �����̴�. �׸���
			// �ι�°�� super.excuteUpdate(con, Vector)�ε�, ��Ƽ �ο츦 ����ϱ� ���� ���õ� ��ġ�̴�.
			// ����°�� �ϳ��� SQL�� String���� �޾Ƽ� ó���ϴ� ����̴�.
			// ���� ���� SQL���¶��.. �翬�� 1���� �ο쿡 �ش�ǹǷ� ����° �޽�带 ����ϴ� ���� ���ϴ�.
			resultInt = super.excuteUpdate(con, sql.toString());
			if(resultInt < 0) {
				ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
				return resultInt;
			}else{
				ioParam.setMessage(resultInt + "�� " + MessageDefine.M_INSERT_RESULT);
			}

		} catch(Exception e) {
			LoggingWriter.setLogError("M707S31000E003()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M707S31000E003()","==== finally ===="+ e.getMessage());
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

	public int E004(InoutParameter ioParam){ // 	�Ⱦ��� �޼ҵ�	�Ⱦ��� �޼ҵ�	�Ⱦ��� �޼ҵ�	�Ⱦ��� �޼ҵ�
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			// Ŭ���̾�Ʈ�� ���� ���� �Ķ���͸� �Ű� ��´�.
			String rcvData = (String)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			// Ŭ���̾�Ʈ�� ���� ���� �Ķ���͸� �ɰ�� �迭�� ��´�.
			// rcvData = [���浵]
			String[][] c_paramArray = CommonFunction.getConvString2DoubleArray(rcvData);
			
			//{"����", "��ǰ��", "��������", "ó���������", "ó������", "AS��û��", 
			// 	"�������", "������", "AS��û����", "REQ_SEQNO", "GEORAESA_CD", "PRODUCT_CD", "USER_ID", "AS_STATUS_CD", "REQ_CHANNEL", "REQ_TIME" };
			
			sql = new StringBuffer();
			sql.append("	select	\n"); 
			sql.append("		(select CUST_NM from vtbm_customer where CUST_CD=QL.GEORAESA_CD) as CUST_NM,	\n"); 
			sql.append("		(select 	\n"); 
			sql.append("				(SELECT CODE_NAME FROM tbm_code_book WHERE CODE_CD=gpi.GIJONG_CD) ||'.'||PROD_MODEL	\n"); 
			sql.append("			from TB_GEORAESA_PROD_INFO gpi where PRODUCT_SERIAL_NO=QL.PRODUCT_CD limit 1) as PRODUCT_MODEL,	\n"); 
			sql.append("		REQ_DATE,	\n"); 
			sql.append("		WORK_HOPE_DATE,	\n"); 
			sql.append("		(select CODE_NAME from TB_CODE_BOOK where CODE_CD=QL.AS_STATUS_CD) as WORK_STATUS,	\n"); 
			sql.append("		REQ_MAN_NAME,	\n"); 
			sql.append("		(select CODE_NAME from TB_CODE_BOOK where CODE_CD=QL.REQ_CHANNEL) as CHANNEL_NM,	\n"); 
			sql.append("		(select USER_NM from tbm_users where USER_ID=QL.USER_ID) as USER_NM,	\n"); 
			sql.append("		REQ_CONTENTS,	\n"); 
			sql.append("		REQ_SEQNO,	\n"); 
			sql.append("		GEORAESA_CD,	\n"); 
			sql.append("		PRODUCT_CD,	\n"); 
			sql.append("		USER_ID,	\n"); 
			sql.append("		AS_STATUS_CD,	\n"); 
			sql.append("		REQ_CHANNEL,	\n"); 
			sql.append("		REQ_TIME	\n"); 
			sql.append("	from	\n"); 
			sql.append("		TB_AS_REQLIST QL	\n"); 
			sql.append("	where	1=1	\n"); 
			sql.append(" 		and REQ_DATE >= '" + c_paramArray[0][0] + "' \n"); 
			sql.append(" 		and REQ_DATE <= '" + c_paramArray[0][1] + "' \n"); 
			
			String ActionCommand = ioParam.getActionCommand();
			if(ActionCommand.startsWith("doQueryTableFieldName")) {
				resultString = super.excuteQueryStringTableFieldName(con, sql.toString());
			}
			else {;
				resultString = super.excuteQueryString(con, sql.toString());
			}
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M707S31000E004()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M707S31000E004()","==== finally ===="+ e.getMessage());
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
	
	public int E014(InoutParameter ioParam){ // 	�Ⱦ��� �޼ҵ�	�Ⱦ��� �޼ҵ�	�Ⱦ��� �޼ҵ�	�Ⱦ��� �޼ҵ�
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			// Ŭ���̾�Ʈ�� ���� ���� �Ķ���͸� �Ű� ��´�.
			String rcvData = (String)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			// Ŭ���̾�Ʈ�� ���� ���� �Ķ���͸� �ɰ�� �迭�� ��´�.
			// rcvData = [���浵]
			String[][] c_paramArray = CommonFunction.getConvString2DoubleArray(rcvData);
			
			//{"����", "��ǰ��", "��������", "ó���������", "ó������", "AS��û��", 
			// 	"�������", "������", "AS��û����", "REQ_SEQNO", "GEORAESA_CD", "PRODUCT_CD", "USER_ID", "AS_STATUS_CD", "REQ_CHANNEL", "REQ_TIME" };
			
			sql = new StringBuffer();
			sql.append("	select	\n"); 
			sql.append("		(select CUST_NM from vtbm_customer where CUST_CD=QL.GEORAESA_CD) as CUST_NM,	\n"); 
			sql.append("		(select 	\n"); 
			sql.append("				(SELECT CODE_NAME FROM tbm_code_book WHERE CODE_CD=gpi.GIJONG_CD) ||'.'||PROD_MODEL	\n"); 
			sql.append("			from TB_GEORAESA_PROD_INFO gpi where PRODUCT_SERIAL_NO=QL.PRODUCT_CD ) as PRODUCT_MODEL,	\n"); 
			sql.append("		REQ_DATE,	\n"); 
			sql.append("		WORK_HOPE_DATE,	\n"); 
			sql.append("		(select CODE_NAME from TB_CODE_BOOK where CODE_CD=QL.AS_STATUS_CD) as WORK_STATUS,	\n"); 
			sql.append("		REQ_MAN_NAME,	\n"); 
			sql.append("		(select CODE_NAME from TB_CODE_BOOK where CODE_CD=QL.REQ_CHANNEL) as CHANNEL_NM,	\n"); 
			sql.append("		(select USER_NM from tbm_users where USER_ID=QL.USER_ID) as USER_NM,	\n"); 
			sql.append("		REQ_CONTENTS,	\n"); 
			sql.append("		REQ_SEQNO,	\n"); 
			sql.append("		GEORAESA_CD,	\n"); 
			sql.append("		PRODUCT_CD,	\n"); 
			sql.append("		USER_ID,	\n"); 
			sql.append("		AS_STATUS_CD,	\n"); 
			sql.append("		REQ_CHANNEL,	\n"); 
			sql.append("		REQ_TIME	\n"); 
			sql.append("	from	\n"); 
			sql.append("		TB_AS_REQLIST QL	\n"); 
			sql.append("	where	1=1	\n"); 
			sql.append(" 		and GEORAESA_CD = '" + c_paramArray[0][0] + "' \n"); 
			
			String ActionCommand = ioParam.getActionCommand();
			if(ActionCommand.startsWith("doQueryTableFieldName")) {
				resultString = super.excuteQueryStringTableFieldName(con, sql.toString());
			}
			else {;
				resultString = super.excuteQueryString(con, sql.toString());
			}
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M707S31000E014()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M707S31000E014()","==== finally ===="+ e.getMessage());
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

	/*
	{"����","��ǰ�Ϸù�ȣ", "��ǰ��","�������", "GIJONG_CD", "MODEL_NO"};
	*/
	public int E024(InoutParameter ioParam){ // 	�Ⱦ��� �޼ҵ�	�Ⱦ��� �޼ҵ�	�Ⱦ��� �޼ҵ�	�Ⱦ��� �޼ҵ�
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			// Ŭ���̾�Ʈ�� ���� ���� �Ķ���͸� �Ű� ��´�.
			String rcvData = (String)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			// Ŭ���̾�Ʈ�� ���� ���� �Ķ���͸� �ɰ�� �迭�� ��´�.
			String[][] c_paramArray = CommonFunction.getConvString2DoubleArray(rcvData);

			//{"����","��ǰ�Ϸù�ȣ", "��ǰ��","�������", "GIJONG_CD", "MODEL_NO","seqno"};

			sql = new StringBuffer();
			sql.append(" select	\n"); 
			sql.append(" 	gijong_cd	\n"); 
			sql.append(" 	,product_serial_no	\n"); 
			sql.append(" 	,prod_model	\n"); 
			sql.append(" 	,delivery_dt	\n"); 
			sql.append(" 	,gijong_cd	\n"); 
			sql.append(" 	,prod_model	\n"); 
			sql.append(" 	,seqno	\n"); 
			sql.append(" from TB_GEORAESA_PROD_INFO	\n"); 
			sql.append(" where 1=1			\n"); 	
			sql.append(" 	and GEORAESA_CD = '" + c_paramArray[0][0] + "'	\n"); 	
			
			String ActionCommand = ioParam.getActionCommand();
			if(ActionCommand.startsWith("doQueryTableFieldName")) {
				resultString = super.excuteQueryStringTableFieldName(con, sql.toString());
			}
			else {;
				resultString = super.excuteQueryString(con, sql.toString());
			}
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M707S31000E024()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M707S31000E024()","==== finally ===="+ e.getMessage());
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

	/*
	{"��������", "�۾�������", "�۾�������", "�۾���", "�۾�����" };
	*/
	public int E034(InoutParameter ioParam){  // 	�Ⱦ��� �޼ҵ�	�Ⱦ��� �޼ҵ�	�Ⱦ��� �޼ҵ�	�Ⱦ��� �޼ҵ�
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			// Ŭ���̾�Ʈ�� ���� ���� �Ķ���͸� �Ű� ��´�.
			String rcvData = (String)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			// Ŭ���̾�Ʈ�� ���� ���� �Ķ���͸� �ɰ�� �迭�� ��´�.
			String[][] c_paramArray = CommonFunction.getConvString2DoubleArray(rcvData);

			//{"����","��ǰ�Ϸù�ȣ", "��ǰ��","�������", "GIJONG_CD", "MODEL_NO"};

			sql = new StringBuffer();
			sql.append(" select	\n"); 
			sql.append(" 	REQ_DATE	\n"); 
			sql.append(" 	,TASK_START_DATE	\n"); 
			sql.append(" 	,TASK_END_DATE	\n"); 
			sql.append(" 	,(select USER_NM from tbm_users where USER_ID = trim(PROC_DAMDANG_MAN)) as PROC_DAMDANG_MAN_NAME	\n"); 
			sql.append(" 	,TASK_CONTENTS	\n"); 
			sql.append(" 	,PROC_DAMDANG_MAN	\n"); 
			sql.append(" from TB_REQ_TASKHIST	\n"); 
			sql.append(" where 1=1			\n"); 	
			sql.append(" 	and SERIAL_NO = '" + c_paramArray[0][0] + "'	\n"); 
			
			String ActionCommand = ioParam.getActionCommand();
			if(ActionCommand.startsWith("doQueryTableFieldName")) {
				resultString = super.excuteQueryStringTableFieldName(con, sql.toString());
			}
			else {;
				resultString = super.excuteQueryString(con, sql.toString());
			}
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M707S31000E034()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M707S31000E034()","==== finally ===="+ e.getMessage());
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
