package mes.frame.business.M909;

import java.lang.reflect.Method;
import java.sql.Connection;
import java.sql.PreparedStatement;
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


public class M909S100100 extends SqlAdapter{
	Connection con = null;
	PreparedStatement pstmt = null;
	String resultString = "";
	int resultInt = -1;
	StringBuffer sql = new StringBuffer();
	
	String[][] v_paramArray = new String[0][0]; 
	Class[] optClass = null;
	Object[] optObj = null;
	Object obj = null;
	
	public M909S100100(){
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
	public int doExcute(InoutParameter ioParam){
		long startTime = System.currentTimeMillis();
		int doExcute_result = EventDefine.E_DOEXCUTE_INIT;;
		String event = ioParam.getEventSubID();

	    try{
            optClass = new Class[1];
			optClass[0] = ioParam.getClass() ;
			optObj = new Object[1];
			optObj[0] = ioParam;

			Method method = M909S100100.class.getMethod(event,optClass);
			LoggingWriter.setLogDebug(M909S100100.class.getName(),"==== " + event + " EventMethod Create Success ====");

			obj = method.invoke(M909S100100.class.newInstance(),optObj);
			doExcute_result = CommonFunction.getInt(obj.toString());
			
	    } catch (Exception ex) {
	    	doExcute_result = EventDefine.E_DOEXCUTE_INIT;
			ioParam.setMessage(MessageDefine.M_NO_EVENTID);
			LoggingWriter.setLogError(M909S100100.class.getName(),"==== EventID Not define : EVENT ID [ " + ioParam.getEventID() + "]");
	    } finally {
	    	obj = null;
			optClass = null;
			optObj = null;
	    }
	    long endTime = System.currentTimeMillis();
		long runningTime = endTime - startTime;
		LoggingWriter.setLogAll(M909S100100.class.getName(),"==== Query [����ð�  : " + runningTime + " ms]");
		
		return doExcute_result;
	}
	

	public int E101(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			System.out.println("JSONObject jArray rcvData="+ jArray.toString());
			
			String sql = new StringBuilder()
				.append("INSERT INTO tbm_menu ( "
						+ "class_id "
						+ ",menu_id "
						+ ",menu_name "
						+ ",menu_level "
						+ ",order_index "
						+ ",delyn "
						+ ",parent_menu_id "
						+ ",program_id "
						+ ",update_user "
						+ ",updatedate  \n"
						+ ",member_key ) \n")
				.append(" values ('"	+ ((String) jArray.get("MenuId")).substring(0, 4) + "' \n")	//class_id
				.append(" 		,'" 	+ jArray.get("MenuId") + "' \n") 	//menu_id
				.append(" 		,'" 	+ jArray.get("MenuName") + "' \n") 	//menu_name
				.append(" 		,'" 	+ jArray.get("MenuLevel") + "' \n") 	//menu_level
				.append(" 		,'" 	+ jArray.get("OrderIndex") + "' \n") 	//order_index
				.append(" 		,'" 	+ jArray.get("DelYn") + "' \n") 	//delyn
				.append(" 		,'" 	+ jArray.get("UpMenu") + "' \n") 	//parent_menu_id
				.append(" 		,'" 	+ jArray.get("ProgramId") + "' \n") 	//program_id
				.append(" 		,'" 	+ jArray.get("user_id") + "' \n") 	//update_user
				.append(" 		,SYSDATETIME \n")						//updatedate
				.append(" 		,'" + jArray.get("member_key") + "' \n") //member_key_values
				.append("	)\n")
				.toString();
			
				resultInt = super.excuteUpdate(con, sql.toString());
				if (resultInt < 0) {
					ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
				} else {
					ioParam.setMessage(resultInt + "�� " + MessageDefine.M_INSERT_RESULT);
				}
				
		} catch(Exception e) {
			LoggingWriter.setLogError("M909S100100E101()","==== SQL ERROR ===="+ e.getMessage() + "\n" + sql.toString());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M909S100100E101"
							+ "()","==== finally ===="+ e.getMessage());
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

	public int E111(InoutParameter ioParam) {
		return this.E101(ioParam);
	}
	public int E112(InoutParameter ioParam) {
		return this.E102(ioParam);
	}
	public int E113(InoutParameter ioParam) {
		return this.E103(ioParam);
	}
	
	public int E102(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			System.out.println("JSONObject jArray rcvData="+ jArray.toString());

			String sql = new StringBuilder()
				.append("UPDATE tbm_menu SET \n" ) 
//				.append("	 menu_id= '" + c_paramArray[0][0] + "' \n")
				.append("	 menu_name= '" + jArray.get("MenuName") + "' \n")
				.append("	,menu_level= '" + jArray.get("MenuLevel") + "' \n")
				.append("	,order_index= '" + jArray.get("OrderIndex") + "' \n")
				.append("	,delyn= '" + jArray.get("DelYn") + "' \n")
				.append("	,parent_menu_id= '" + jArray.get("UpMenu") + "' \n")
				.append("	,program_id= '" + jArray.get("ProgramId") + "' \n")
				.append("	,update_user= '" + jArray.get("user_id") + "' \n")
				.append("	,updatedate= SYSDATETIME \n")
				.append(" 	,member_key = 	'" + jArray.get("member_key") + "'		\n")
				.append(" WHERE \n")	//menu_id
				.append(" 	program_id='" 	+ jArray.get("ProgramId") + "' \n")
				.append(" 	AND member_key = '" + jArray.get("member_key") + "' \n") //member_key_select, update, delete
				.toString();
			
				resultInt = super.excuteUpdate(con, sql.toString());
				if (resultInt < 0) {
					ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
				} else {
					ioParam.setMessage(resultInt + "�� " + MessageDefine.M_INSERT_RESULT);
				}
				
		} catch(Exception e) {
			LoggingWriter.setLogError("M909S100100E102()","==== SQL ERROR ===="+ e.getMessage() + "\n" + sql.toString());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M909S100100E102()","==== finally ===="+ e.getMessage());
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


	public int E103(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			System.out.println("JSONObject jArray rcvData="+ jArray.toString());
			
			String sql = new StringBuilder()
				.append("DELETE FROM tbm_menu WHERE \n")	//menu_id
				.append(" 	program_id='" 	+ jArray.get("ProgramId") + "' \n")
				.append(" 	AND member_key = '" + jArray.get("member_key") + "' \n") //member_key_select, update, delete
				.toString();
					
				resultInt = super.excuteUpdate(con, sql.toString());
				if (resultInt < 0) {
					ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
				} else {
					ioParam.setMessage(resultInt + "�� " + MessageDefine.M_INSERT_RESULT);
				}
				
		} catch(Exception e) {
			LoggingWriter.setLogError("M909S100100E103()","==== SQL ERROR ===="+ e.getMessage() + "\n" + sql.toString());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M909S100100E103()","==== finally ===="+ e.getMessage());
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

	// ���޴� 
	public int E104(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			System.out.println("JSONObject jArray rcvData="+ jArray.toString());
			
			String sql = new StringBuilder()
					.append("SELECT				\n")
					.append("	SUBSTRING(menu_id,1,4),	\n")
					.append("	menu_id,		\n")
					.append("	menu_name,		\n")
					.append("	menu_level,		\n")
					.append("	order_index,	\n")
					.append("	delyn,			\n")
					.append("	parent_menu_id,	\n")
					.append("	program_id		\n")
					.append("FROM				\n")
					.append("	tbm_menu			\n")
					.append("WHERE menu_level<2	\n")
					.append(" 	AND member_key = '" + jArray.get("member_key") + "' \n") //member_key_select, update, delete
					.append("ORDER BY menu_id	\n")
					.toString();

			resultString = super.excuteQueryString(con, sql.toString());
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M909S100100E104()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M909S100100E104()","==== finally ===="+ e.getMessage());
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
	
	// �޴��� ���α׷� ���
	public int E114(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			System.out.println("JSONObject jArray rcvData="+ jArray.toString());

			String sql = new StringBuilder()
					.append("SELECT\n")
					.append("	parent_menu_id,	\n")
					.append("	menu_id,		\n")
					.append("	menu_name,		\n")
					.append("	menu_level,		\n")
					.append("	program_id,		\n")
					.append("	order_index,	\n")
					.append("	updatedate,		\n")
					.append("	update_user,	\n")
					.append("	delyn			\n")
					.append("FROM				\n")
					.append("	tbm_menu			\n")
					.append("WHERE  menu_level = 2	\n")
					.append("AND parent_menu_id LIKE '" + jArray.get("FOLDER_MENU_ID") + "%' \n")
					.append(" 	AND member_key = '" + jArray.get("member_key") + "' \n") //member_key_select, update, delete
					.append("ORDER BY menu_id\n")
					.toString();
			resultString = super.excuteQueryString(con, sql.toString());
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M09S100100E104.E114()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
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

	//�޴��� Ư�� ���α׷�
	public int E214(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			System.out.println("JSONObject jArray rcvData="+ jArray.toString());

			String sql = new StringBuilder()
					.append("SELECT\n")
					.append("	parent_menu_id,	\n")
					.append("	menu_id,		\n")
					.append("	menu_name,		\n")
					.append("	menu_level,		\n")
					.append("	program_id,		\n")
					.append("	order_index,	\n")
					.append("	updatedate,		\n")
					.append("	update_user,	\n")
					.append("	delyn			\n")
					.append("FROM				\n")
					.append("	tbm_menu			\n")
					.append("WHERE  menu_level > 0	\n")
					.append("AND  program_id = '" + jArray.get("PROGRAM_ID") + "' \n") 
					.append(" 	AND member_key = '" + jArray.get("member_key") + "' \n") //member_key_select, update, delete
					.toString();
			resultString = super.excuteQueryString(con, sql.toString());
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M09S100100E214.E214()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M09S100100E214()","==== finally ===="+ e.getMessage());
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