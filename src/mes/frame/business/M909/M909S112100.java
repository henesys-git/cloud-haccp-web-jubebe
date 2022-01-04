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


public class M909S112100 extends SqlAdapter{
	Connection con = null;
	PreparedStatement pstmt = null;
	String resultString = "";
	int resultInt = -1;
	StringBuffer sql = new StringBuffer();
	
	String[][] v_paramArray = new String[0][0]; 
	Class[] optClass = null;
	Object[] optObj = null;
	Object obj = null;
	
	public M909S112100(){
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

			Method method = M909S112100.class.getMethod(event,optClass);
			LoggingWriter.setLogDebug(M909S112100.class.getName(),"==== " + event + " EventMethod Create Success ====");

			obj = method.invoke(M909S112100.class.newInstance(),optObj);
			doExcute_result = CommonFunction.getInt(obj.toString());
			
	    } catch (Exception ex) {
	    	doExcute_result = EventDefine.E_DOEXCUTE_INIT;
			ioParam.setMessage(MessageDefine.M_NO_EVENTID);
			LoggingWriter.setLogError(M909S112100.class.getName(),"==== EventID Not define : EVENT ID [ " + ioParam.getEventID() + "]");
	    } finally {
	    	obj = null;
			optClass = null;
			optObj = null;
	    }
	    long endTime = System.currentTimeMillis();
		long runningTime = endTime - startTime;
		LoggingWriter.setLogAll(M909S112100.class.getName(),"==== Query [����ð�  : " + runningTime + " ms]");
		
		return doExcute_result;
	}
	

	public int E101(InoutParameter ioParam){
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

			String sql = new StringBuilder()
					.append("INSERT INTO\n")
					.append("	tbm_storage (		\n")
					.append("		storage_no,	\n")
					.append("		rake_no,	\n")
					.append("		plate_no,		\n")
					.append("		col_no		\n")
					.append(" 		,member_key						\n") // member_key_insert

				.append("	)			\n")
				.append(" values ('"	+ jArray.get("storage_no") + "' \n")	//storage_no
				.append(" 		,'" 	+ jArray.get("rake_no") + "' \n") 	//rake_no
				.append(" 		,'" 	+ jArray.get("plate_no") + "' \n") 	//plate_no
				.append(" 		,'" 	+ jArray.get("col_no") + "' \n") 	//col_no
				.append(" 		,'" + jArray.get("member_key") + "' \n") //member_key_values
				.append(" 		);			  \n") 	//create_date				
				.toString();
			
			// System.out.println(sql.toString());
				resultInt = super.excuteUpdate(con, sql.toString());
				if (resultInt < 0) {
					ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
				} else {
					ioParam.setMessage(resultInt + "�� " + MessageDefine.M_INSERT_RESULT);
				}
				
		} catch(Exception e) {
			LoggingWriter.setLogError("M909S112100E101()","==== SQL ERROR ===="+ e.getMessage() + "\n" + sql.toString());
			e.printStackTrace();
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M909S112100E101()","==== finally ===="+ e.getMessage());
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

	public int E111(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();

			con.setAutoCommit(false);
			
			JSONObject jArray = new JSONObject();
			jArray = (JSONObject)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			System.out.println("JSONObject jArray rcvData="+ jArray.toString());
			
			// Ŭ���̾�Ʈ�� ���� ���� �Ķ���͸� �Ű� ��´�.
//			String rcvData = (String)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			
			// Ŭ���̾�Ʈ�� ���� ���� �Ķ���͸� �ɰ�� �迭�� ��´�.
//			String[][] c_paramArray = CommonFunction.getConvString2DoubleArray(rcvData);
			String storage_no=(String) jArray.get("vstorage_no");
			int rake_no	= Integer.parseInt((String) jArray.get("vrake_no"));
			int plate_no= Integer.parseInt((String) jArray.get("vplate_no"));
			int col_no	= Integer.parseInt((String) jArray.get("vcol_no"));
			for(int r=1;r<rake_no+1;r++) {
				for(int p=1;p<plate_no+1;p++) {
					for(int c=1;c<col_no+1;c++) {
				
						String sql = new StringBuilder()
							.append("INSERT INTO\n")
							.append("	tbm_part_storage_conf (\n")
							.append("		machineno,	\n")
							.append("		rakes,	\n")
							.append("		plate,		\n")
							.append("		colm,		\n")
//							.append("		pre_amt,		\n")
//							.append("		post_amt,	\n")
//							.append("		io_amt		\n")
							.append(" 		member_key						\n") // member_key_insert
							.append("	)			\n")
							.append(" values ('"	+ storage_no + "' \n")	//storage_no
							.append(" 		,'" 	+ r + "' \n") 	//rakes
							.append(" 		,'" 	+ p + "' \n") 	//plate
							.append(" 		,'" 	+ c + "' \n") 	//colm
//							.append(" 		,0 \n") 	//pre_amt
//							.append(" 		,0 \n") 	//post_amt
//							.append(" 		,0 \n") 	//io_amt
							.append(" 		,'" + jArray.get("member_key") + "' \n") //member_key_values
							.append(" 		)			  \n") 				
							.toString();
						
							resultInt = super.excuteUpdate(con, sql.toString());
							if (resultInt < 0) {
								con.rollback();
								ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
								return resultInt;
							} else {
								ioParam.setMessage(resultInt + "�� " + MessageDefine.M_INSERT_RESULT);
							}
					}
				}
			}
			
			String sqlPre = new StringBuilder()
					.append("UPDATE tbm_storage SET	\n")
					.append(" config_process = 'Y'	\n")
					.append(" 	,member_key = 	'" + jArray.get("member_key") + "'		\n")
					.append("WHERE storage_no = '" 	+ storage_no + "'\n")
					.append(" 	AND member_key = '" + jArray.get("member_key") + "' \n") //member_key_select, update, delete
					.toString();
						
			resultInt = super.excuteUpdate(con, sqlPre.toString());
			if (resultInt < 0) {
				con.rollback();
				ioParam.setMessage(MessageDefine.M_UPDATE_FAILED);
				return resultInt;
			} else {
				ioParam.setMessage(resultInt + "�� " + MessageDefine.M_UPDATE_RESULT);
			}
			
			con.commit();	
		} catch(Exception e) {
			LoggingWriter.setLogError("M909S112100E111()","==== SQL ERROR ===="+ e.getMessage() + "\n" + sql.toString());
			e.printStackTrace();
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M909S112100E111()","==== finally ===="+ e.getMessage());
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
			
			// Ŭ���̾�Ʈ�� ���� ���� �Ķ���͸� �Ű� ��´�.
//			String rcvData = (String)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			// Ŭ���̾�Ʈ�� ���� ���� �Ķ���͸� �ɰ�� �迭�� ��´�.
//			String[][] c_paramArray = CommonFunction.getConvString2DoubleArray(rcvData);
			
			con.setAutoCommit(false);
			
			// ���� ���� �������� ���� �����������ڸ� �̹��� �������ڿ��� �Ϸ縦 �� ��¥�� �����Ѵ�.
			String sqlPre = new StringBuilder()
					.append("UPDATE tbm_storage SET	\n")
					.append(" rake_no = '" 	+ jArray.get("rake_no") + "',	\n")
					.append(" plate_no = '" + jArray.get("plate_no") + "',	\n")
					.append(" col_no = '" 	+ jArray.get("col_no") + "'	\n")
					.append(" 	,member_key = 	'" + jArray.get("member_key") + "'		\n")
					.append("WHERE storage_no = '" 	+ jArray.get("storage_no") + "'\n")
					.append(" 	AND member_key = '" + jArray.get("member_key") + "' \n") //member_key_select, update, delete
					.toString();
						
			resultInt = super.excuteUpdate(con, sqlPre.toString());
			if (resultInt < 0) {
				con.rollback();
				ioParam.setMessage(MessageDefine.M_UPDATE_FAILED);
				return resultInt;
			} else {
				ioParam.setMessage(resultInt + "�� " + MessageDefine.M_UPDATE_RESULT);
			}

				
			con.commit();
		} catch(Exception e) {
			LoggingWriter.setLogError("M909S112100E102()","==== SQL ERROR ===="+ e.getMessage() + "\n" + sql.toString());
			e.printStackTrace();
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M909S112100E102()","==== finally ===="+ e.getMessage());
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
			
			// Ŭ���̾�Ʈ�� ���� ���� �Ķ���͸� �Ű� ��´�.
//			String rcvData = (String)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			
			// Ŭ���̾�Ʈ�� ���� ���� �Ķ���͸� �ɰ�� �迭�� ��´�.
//			String[][] c_paramArray = CommonFunction.getConvString2DoubleArray(rcvData);

			String sql = new StringBuilder()
				.append("DELETE FROM tbm_storage  \n")
				.append("WHERE storage_no = '" 	+ jArray.get("storage_no") + "'\n")
				.append(" 	AND member_key = '" + jArray.get("member_key") + "' \n") //member_key_select, update, delete
				.toString();
					
				resultInt = super.excuteUpdate(con, sql.toString());
				if (resultInt < 0) {
					ioParam.setMessage(MessageDefine.M_INSERT_FAILED);
				} else {
					ioParam.setMessage(resultInt + "�� " + MessageDefine.M_INSERT_RESULT);
				}
				
		} catch(Exception e) {
			LoggingWriter.setLogError("M909S112100E103()","==== SQL ERROR ===="+ e.getMessage() + "\n" + sql.toString());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M909S112100E103()","==== finally ===="+ e.getMessage());
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
	public int E104(InoutParameter ioParam){
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
			String sql = new StringBuilder()
					.append("SELECT\n")
					.append("	storage_no,\n")
					.append("	rake_no,\n")
					.append("	plate_no,\n")
					.append("	col_no, \n")
					.append("	config_process\n")
					.append("FROM\n")
					.append("	tbm_storage\n")
					.append(" 	WHERE member_key = '" + jArray.get("member_key") + "' \n") //member_key_select, update, delete
					.toString();  

			resultString = super.excuteQueryString(con, sql.toString());
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M909S112100E104()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M909S112100E104()","==== finally ===="+ e.getMessage());
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

	public int E114(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			con = JDBCConnectionPool.getConnection();
			
			// Ŭ���̾�Ʈ�� ���� ���� �Ķ���͸� �Ű� ��´�.
			String rcvData = (String)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			// Ŭ���̾�Ʈ�� ���� ���� �Ķ���͸� �ɰ�� �迭�� ��´�.
			// rcvData = [���浵]
			
			String[][] c_paramArray = CommonFunction.getConvString2DoubleArray(rcvData);
			String sql = new StringBuilder()
					.append("SELECT\n")
					.append("	machineno,\n")
					.append("	rakes,\n")
					.append("	plate,\n")
					.append("	colm,\n")
//					.append("	pre_amt,\n")
//					.append("	post_amt,\n")
//					.append("	io_amt,\n")
					.append("	use_yn\n")
					.append("FROM\n")
					.append("	tbm_part_storage_conf\n")

					.append(" " + c_paramArray[0][0] + "\n" )
					.toString();

			resultString = super.excuteQueryString(con, sql.toString());
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M909S112100E114()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M909S112100E114()","==== finally ===="+ e.getMessage());
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


	public int E204(InoutParameter ioParam){
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
			String sql = new StringBuilder()
					.append("SELECT \n")
					.append("	storage_no,\n")
					.append("	rake_no,\n")
					.append("	plate_no,\n")
					.append("	col_no, \n")
					.append("	config_process\n")
					.append("FROM\n")
					.append("	tbm_storage \n")
					.append("WHERE 1=1	\n")
					.append("	AND storage_no = '" 	+ jArray.get("STORAGE_NO") + "'	\n")
					.append(" 	AND member_key = '" + jArray.get("member_key") + "' \n") //member_key_select, update, delete
					.toString();  

			resultString = super.excuteQueryString(con, sql.toString());
		} catch(Exception e) {
			e.printStackTrace();
			LoggingWriter.setLogError("M909S112100E204()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
	    	if (Config.useDataSource) {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M909S112100E204()","==== finally ===="+ e.getMessage());
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