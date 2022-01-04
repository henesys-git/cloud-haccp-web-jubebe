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
		LoggingWriter.setLogAll(M707S32100.class.getName(),"==== Query [����ð�  : " + runningTime + " ms]");
		
		return doExcute_result;
	}
	
	// autoDepotIoHistInsert
	// autoDepotIoHistInsert
	public int E001(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			// Ŭ���̾�Ʈ�� ���� ���� �Ķ���͸� �Ű� ��´�.
			String rcvData = (String)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			
			// Ŭ���̾�Ʈ�� ���� ���� �Ķ���͸� �ɰ�� �迭�� ��´�.
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

			// super�� excuteUpdate�� 3������ �ִ�.
			// ù°�� super.excuteUpdate(con, sql.toString(), v_paramArray)���� �̸�,
			// PreparedStatement�� ����ϱ� ���� �Ķ���͵��� ��ɿ� ��� ������ üũ�� �ؼ� �����ϴ� �����̴�. �׸���
			// �ι�°�� super.excuteUpdate(con, Vector)�ε�, ��Ƽ �ο츦 ����ϱ� ���� ���õ� ��ġ�̴�.
			// ����°�� �ϳ��� SQL�� String���� �޾Ƽ� ó���ϴ� ����̴�.
			// ���� ���� SQL���¶��.. �翬�� 1���� �ο쿡 �ش�ǹǷ� ����° �޽�带 ����ϴ� ���� ���ϴ�.
			
			resultInt = super.excuteUpdate(con, sql.toString());
			if (resultInt <= 0) {
				ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
			} else {
				ioParam.setMessage(resultInt + "�� " + MessageDefine.M_INSERT_RESULT);
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
	    // ��� ���� ������ ���� �Ķ���͵��� ���̿� �Ķ���Ϳ� �����Ѵ�.
		ioParam.setResultString(resultString);
		// ���ۿ��� ó���� Į���� ������ Ŭ���̾�Ʈ���� ������ ���� �����´�.
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
		// �� ó���Ǿ��ٴ� �޽����� Ŭ���̾�Ʈ���� ������ ���� I/O�Ķ���Ϳ� �����Ѵ�.
		// ������ ����� ���� �����ϱ� ���ؼ� ���´�.
    	// ioParam.setMessage(MessageDefine.M_QUERY_OK);
	    return EventDefine.E_QUERY_RESULT;
	}

	public int E003(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			// Ŭ���̾�Ʈ�� ���� ���� �Ķ���͸� �Ű� ��´�.
			String rcvData = (String)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			
			// Ŭ���̾�Ʈ�� ���� ���� �Ķ���͸� �ɰ�� �迭�� ��´�.
			String[][] c_paramArray = CommonFunction.getConvString2DoubleArray(rcvData);

			sql = new StringBuffer();
			sql.append(" delete from TB_CHANGE_PARTHIST 	\n");
			sql.append(" 	where REQ_DATE = '" + c_paramArray[0][0] + "' \n"); 
			sql.append(" 		and REQ_SEQNO = '" + c_paramArray[0][1] + "' \n"); 
			sql.append(" 		and REQ_TASK_SEQNO = '" + c_paramArray[0][2] + "' \n"); 
			sql.append(" 		and member_key = '" + c_paramArray[0][3] + "' \n"); 

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
	    // ��� ���� ������ ���� �Ķ���͵��� ���̿� �Ķ���Ϳ� �����Ѵ�.
		ioParam.setResultString(resultString);
		// ���ۿ��� ó���� Į���� ������ Ŭ���̾�Ʈ���� ������ ���� �����´�.
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
		// �� ó���Ǿ��ٴ� �޽����� Ŭ���̾�Ʈ���� ������ ���� I/O�Ķ���Ϳ� �����Ѵ�.
		// ������ ����� ���� �����ϱ� ���ؼ� ���´�.
    	// ioParam.setMessage(MessageDefine.M_QUERY_OK);
	    return EventDefine.E_QUERY_RESULT;
	}

	// �̷����ǿ� �ش��ϴ� �ŷ�ó ����� GROUP BY �˻��Ѵ�. 
	public int E004(InoutParameter ioParam){ // �Ⱦ��� �޼ҵ�	�Ⱦ��� �޼ҵ�	�Ⱦ��� �޼ҵ�	
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			// Ŭ���̾�Ʈ�� ���� ���� �Ķ���͸� �Ű� ��´�.
			String rcvData = (String)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			// Ŭ���̾�Ʈ�� ���� ���� �Ķ���͸� �ɰ�� �迭�� ��´�.
			// rcvData = [���浵]
			String[][] c_paramArray = CommonFunction.getConvString2DoubleArray(rcvData);
			
			// {"���������ڵ�", "���������", "��ǰ��", "������", "�����߷�", "�԰�", "�������", "��ó��", "����", "��ó��"  }
			
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
	    // ��� ���� ������ ���� �Ķ���͵��� ���̿� �Ķ���Ϳ� �����Ѵ�.
		ioParam.setResultString(resultString);
		// ���ۿ��� ó���� Į���� ������ Ŭ���̾�Ʈ���� ������ ���� �����´�.
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
		// �� ó���Ǿ��ٴ� �޽����� Ŭ���̾�Ʈ���� ������ ���� I/O�Ķ���Ϳ� �����Ѵ�.
    	ioParam.setMessage(MessageDefine.M_QUERY_OK);
	    return EventDefine.E_QUERY_RESULT;
	}

	public int E014(InoutParameter ioParam){ // �Ⱦ��� �޼ҵ�	�Ⱦ��� �޼ҵ�	�Ⱦ��� �޼ҵ�
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			// Ŭ���̾�Ʈ�� ���� ���� �Ķ���͸� �Ű� ��´�.
			String rcvData = (String)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			// Ŭ���̾�Ʈ�� ���� ���� �Ķ���͸� �ɰ�� �迭�� ��´�.
			// rcvData = [���浵]
			String[][] c_paramArray = CommonFunction.getConvString2DoubleArray(rcvData);
			
			sql = new StringBuffer();
			sql.append(" 			select  \n"); 
			sql.append(" 		 		A.SAVE_LOCATION as SAVE_LOCATION  \n"); 
			sql.append(" 		 		,(select POST_AMT from tbi_part_storage_hist where PARTCODE=A.PARTCODE and SAVE_LOCATION=A.SAVE_LOCATION and rownum=1 order by IO_DATE desc, IO_SEQNO desc) as POST_AMT  \n"); 
			sql.append(" 		 		,(select IO_DATE from tbi_part_storage_hist where PARTCODE=A.PARTCODE and SAVE_LOCATION=A.SAVE_LOCATION and rownum=1 order by IO_DATE desc, IO_SEQNO desc) as IO_DATE  \n"); 
			sql.append(" 		 		,(select IO_TIME from tbi_part_storage_hist where PARTCODE=A.PARTCODE and SAVE_LOCATION=A.SAVE_LOCATION and rownum=1 order by IO_DATE desc, IO_SEQNO desc) as IO_TIME  \n"); 
			sql.append(" 		 		,(select PRE_AMT from tbi_part_storage_hist where PARTCODE=A.PARTCODE and SAVE_LOCATION=A.SAVE_LOCATION and rownum=1 order by IO_DATE desc, IO_SEQNO desc) as PRE_AMT  \n"); 
			sql.append(" 		 		,(select coalesce(decode(IO_GUBUN, 'I', '�԰�', 'O', '���'), '����') from tbi_part_storage_hist where PARTCODE=A.PARTCODE and SAVE_LOCATION=A.SAVE_LOCATION and rownum=1 order by IO_DATE desc, IO_SEQNO desc) as IO_GUBUN  \n"); 
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
	    // ��� ���� ������ ���� �Ķ���͵��� ���̿� �Ķ���Ϳ� �����Ѵ�.
		ioParam.setResultString(resultString);
		// ���ۿ��� ó���� Į���� ������ Ŭ���̾�Ʈ���� ������ ���� �����´�.
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
		// �� ó���Ǿ��ٴ� �޽����� Ŭ���̾�Ʈ���� ������ ���� I/O�Ķ���Ϳ� �����Ѵ�.
    	ioParam.setMessage(MessageDefine.M_QUERY_OK);
	    return EventDefine.E_QUERY_RESULT;
	}

	public int E024(InoutParameter ioParam){ // �Ⱦ��� �޼ҵ�	�Ⱦ��� �޼ҵ�	�Ⱦ��� �޼ҵ�
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			// Ŭ���̾�Ʈ�� ���� ���� �Ķ���͸� �Ű� ��´�.
			String rcvData = (String)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			// Ŭ���̾�Ʈ�� ���� ���� �Ķ���͸� �ɰ�� �迭�� ��´�.
			// rcvData = [���浵]
			String[][] c_paramArray = CommonFunction.getConvString2DoubleArray(rcvData);
			
			// {"���������ڵ�", "���������", "��ǰ��", "������", "�����߷�", "�԰�", "�������", "��ó��", "����", "��ó��"  }
			
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
	    // ��� ���� ������ ���� �Ķ���͵��� ���̿� �Ķ���Ϳ� �����Ѵ�.
		ioParam.setResultString(resultString);
		// ���ۿ��� ó���� Į���� ������ Ŭ���̾�Ʈ���� ������ ���� �����´�.
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
		// �� ó���Ǿ��ٴ� �޽����� Ŭ���̾�Ʈ���� ������ ���� I/O�Ķ���Ϳ� �����Ѵ�.
    	ioParam.setMessage(MessageDefine.M_QUERY_OK);
	    return EventDefine.E_QUERY_RESULT;
	}
}