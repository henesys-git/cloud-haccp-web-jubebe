package mes.frame.business.M838;

import java.lang.reflect.Method;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.util.Vector;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;

import mes.frame.common.ApprovalActionNo;
import mes.client.conf.Config;
import mes.frame.common.EventDefine;
import mes.frame.common.HashObject;
import mes.frame.common.MessageDefine;
import mes.frame.common.QueueProcessing;
import mes.frame.database.JDBCConnectionPool;
import mes.frame.database.SqlAdapter;
import mes.frame.serviceinterface.InoutParameter;
import mes.frame.serviceinterface.LoggingWriter;
import mes.frame.util.CommonFunction;


public class M838S030100 extends SqlAdapter{
	Connection con = null;
	PreparedStatement pstmt = null;
	String resultString = "";
	int resultInt = -1;
	StringBuffer sql = new StringBuffer();
	QueueProcessing Queue = new QueueProcessing();
	
	String[][] v_paramArray = new String[0][0]; 
	Class[] optClass = null;
	Object[] optObj = null;
	Object obj = null;
	
	public M838S030100(){
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
			
			Method method = M838S030100.class.getMethod(event,optClass);
			LoggingWriter.setLogDebug(M838S030100.class.getName(),"==== " + event + " EventMethod Create Success ====");

			obj = method.invoke(M838S030100.class.newInstance(),optObj);
			doExcute_result = CommonFunction.getInt(obj.toString());
			
	    } catch (Exception ex) {
	    	doExcute_result = EventDefine.E_DOEXCUTE_INIT;
			ioParam.setMessage(MessageDefine.M_NO_EVENTID);
			LoggingWriter.setLogError(M838S030100.class.getName(),"==== EventID Not define : EVENT ID [ " + ioParam.getEventID() + "]");
	    } finally {
	    	obj = null;
			optClass = null;
			optObj = null;
	    }
	    long endTime = System.currentTimeMillis();
		long runningTime = endTime - startTime;
		LoggingWriter.setLogAll(M838S030100.class.getName(),"==== Query [����ð�  : " + runningTime + " ms]");
		
		return doExcute_result;
	}

	// ������
	public int E104(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
//			// Ŭ���̾�Ʈ�� ���� ���� �Ķ���͸� �Ű� ��´�.
//			String rcvData = (String)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));

			String sql = new StringBuilder()
					.append(" select \n")
					.append(" 		seolbi_cd				\n") 
					.append(" 		,seolbi_nm				\n") 
					.append(" 		,doip_date				\n") 
					.append(" 		,gugyuk					\n") 
					.append(" 		,seolbi_maker			\n") 
					.append(" 		,gigi_bunho				\n")
					.append("		,use_buseo				\n")
					.append("		,admin_id				\n")
					.append("		,checkim_id				\n")
					.append("		,gyojung_damdang		\n")
					.append(" 		,yuhyo_date				\n")
					.append("		,gyojung_jugi			\n")
					.append("		,gyojung_date			\n")
					.append("		,bigo					\n")
					.append(" 		,img_filename			\n") 
					.append(" 		,revision_no			\n") 
					.append("		,start_date				\n")
					.append("		,duration_date			\n")
					.append("		,create_user_id			\n")
					.append("		,create_date			\n")
					.append("		,modify_date			\n")
					.append("		,modify_user_id			\n")
					.append("		,modify_reason			\n")
					.append("		,sulbi_gubun			\n")
					.append(" from tbm_seolbi 				\n") 
					.append(" where  sulbi_gubun = 'SLB001' 	\n")
					.append("   AND  member_key = '" + jArray.get("member_key") + "'	\n")
					.append(" 	order by seolbi_cd ASC, revision_no DESC 			\n")
					.toString();
					
			String ActionCommand = ioParam.getActionCommand();
			if(ActionCommand.startsWith("doQueryTableFieldName")) {
				resultString = super.excuteQueryStringTableFieldName(con, sql.toString());
			}
			else {;
				resultString = super.excuteQueryString(con, sql.toString());
			}
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M838S030100E104()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M838S030100E104()","==== finally ===="+ e.getMessage());
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
	
	//��������̷�
	public int E114(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			// Ŭ���̾�Ʈ�� ���� ���� �Ķ���͸� �Ű� ��´�.
			//String rcvData = (String)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			// Ŭ���̾�Ʈ�� ���� ���� �Ķ���͸� �ɰ�� �迭�� ��´�.
			//{ "�����ڵ�", "��������", "�����", "��������", "������", "�Ϸ���", "�����", "���", "���", "SEQ_NO"};
			
			//String[][] c_paramArray = CommonFunction.getConvString2DoubleArray(rcvData);
			
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			
			String sql = new StringBuilder()
					.append(" SELECT 				\n")
					.append("	 seolbi_cd  		\n")
					.append("	 ,B.code_name AS reason_cd  		\n")
					.append("	 ,gigwan_nm  		\n")
					.append("	 ,work_memo  		\n")
					.append("	 ,start_dt  		\n")
					.append("	 ,end_dt  			\n")
					.append("	 ,user_id  			\n")
					.append("	 ,TO_CHAR (biyong, '999,999,999,999') AS biyong  			\n")
					.append("	 ,A.bigo  			\n")
					.append("	 ,seq_no  			\n")
					.append(" FROM 					\n")
					.append("	tbi_seolbi_repare A	\n")
					.append("INNER JOIN tbm_code_book B\n")
					.append("	ON A.reason_cd = B.code_value\n")
					.append("	AND A.member_key = B.member_key\n")
					.append(" WHERE seolbi_cd = '" + jArray.get("seolbi_cd") + "' \n")
					.append("   AND A.member_key = '" + jArray.get("member_key") + "' \n")
					.append(" ORDER BY seq_no DESC							 \n")
					.toString();
			
			resultString = super.excuteQueryString(con, sql.toString());
			
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M505S250100E114()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M505S250100E114()","==== finally ===="+ e.getMessage());
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
	
	
	// ����ǥ
	public int E144(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			System.out.println("JSONObject jArray rcvData="+ jArray.toString());	
			
			String sql = new StringBuilder()
					.append("SELECT DISTINCT\n")
					.append("	A.seolbi_nm,\n")
					.append("	A.seolbi_cd,\n")
					.append("	'' AS model_nm,\n")
					.append("	A.gugyuk,\n")
					.append("	A.seolbi_maker,\n")
					.append("	A.doip_date,\n")
					.append("	'' AS power_type,\n")
					.append("	A.use_buseo,\n")
					.append("	'' AS as_tel_no1,\n")
					.append("	'' AS as_tel_no2,\n")
					.append("	A.img_filename,\n")
					.append("	A.bigo,\n")
					.append("	B.start_dt, -- �̹����� �̷°��� ����\n")
					.append("	C.code_name AS reason_cd,\n")
					.append("	work_memo, -- ��������(������ ��ġ����)\n")
					.append("	B.end_dt\n")
					.append("FROM  tbm_seolbi A\n")
					.append("LEFT OUTER JOIN tbi_seolbi_repare B\n")
					.append("	ON A.seolbi_cd = B.seolbi_cd\n")
					.append("	AND A.member_key = B.member_key\n")
					.append("LEFT OUTER JOIN tbm_code_book C\n")
					.append("	ON B.reason_cd = C.code_value\n")
					.append("	AND B.member_key = C.member_key\n")
					.append("WHERE A.seolbi_cd = '" + jArray.get("seolbi_cd") + "'\n")
					.append("	AND A.revision_no = '" + jArray.get("revision_no") + "'\n")
//					.append("	AND A.sulbi_gubun = 'SLB001'\n")
					.append("	AND  A.member_key = '" + jArray.get("member_key") + "'\n")
					.append("ORDER BY A.seolbi_cd ASC\n")
					.toString();

			String ActionCommand = ioParam.getActionCommand();
			if(ActionCommand.startsWith("doQueryTableFieldName")) {
				resultString = super.excuteQueryStringTableFieldName(con, sql.toString());
			}
			else {
				resultString = super.excuteQueryString(con, sql.toString());
			}
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M838S030100E144()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M838S030100E144()","==== finally ===="+ e.getMessage());
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