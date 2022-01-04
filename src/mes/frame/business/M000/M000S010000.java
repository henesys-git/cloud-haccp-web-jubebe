package mes.frame.business.M000;

import java.lang.reflect.Method;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.text.SimpleDateFormat;
import java.util.Date;

import org.apache.log4j.Logger;
import org.json.simple.JSONObject;

import mes.frame.common.EventDefine;
import mes.frame.common.HashObject;
import mes.frame.common.MessageDefine;
import mes.frame.database.JDBCConnectionPool;
import mes.frame.database.SqlAdapter;
import mes.frame.serviceinterface.InoutParameter;
import mes.frame.serviceinterface.LoggingWriter;
import mes.frame.util.CommonFunction;


public class M000S010000 extends SqlAdapter {
	
	static final Logger logger = Logger.getLogger(M000S010000.class.getName());
	
	Connection con = null;
	PreparedStatement pstmt = null;
	String resultString = "";
	int resultInt = -1;
	StringBuffer sql = new StringBuffer();
	
	String[][] v_paramArray = new String[0][0]; 
	Class[] optClass = null;
	Object[] optObj = null;
	Object obj = null;
	
	public M000S010000(){
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

	public String getCurrentDate(String format) {
        Date d = new Date();
        SimpleDateFormat sdf = new SimpleDateFormat(format);
        return sdf.format(d);
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
		
	    try {
            optClass = new Class[1];
			optClass[0] = ioParam.getClass() ;
			optObj = new Object[1];
			optObj[0] = ioParam;
			
			Method method = M000S010000.class.getMethod(event,optClass);
			LoggingWriter.setLogDebug(M000S010000.class.getName(),"==== " + event + " EventMethod Create Success ====");

			obj = method.invoke(M000S010000.class.newInstance(),optObj);
			doExcute_result = CommonFunction.getInt(obj.toString());
			
	    } catch (Exception ex) {
	    	doExcute_result = EventDefine.E_DOEXCUTE_INIT;
			ioParam.setMessage(MessageDefine.M_NO_EVENTID);
			LoggingWriter.setLogError(M000S010000.class.getName(),"==== EventID Not define : EVENT ID [ " + ioParam.getEventID() + "]");
	    } finally {
	    	obj = null;
			optClass = null;
			optObj = null;
	    }
	    
	    long endTime = System.currentTimeMillis();
		long runningTime = endTime - startTime;
		logger.debug("Query [����ð�  : " + runningTime + " ms]");
		
		return doExcute_result;
	}
	// ���� ����Ȱ� ����
	// ä�� 
	public int E010(InoutParameter ioParam){		
		resultInt = EventDefine.E_DOEXCUTE_INIT;
				
		try {
			String rcvData = (String)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			v_paramArray = CommonFunction.getConvString2DoubleArray(rcvData);
			
			con = JDBCConnectionPool.getConnection();
			
			// ä��(CHAN)
			sql = new StringBuffer();
			sql.append(" select CODE_VALUE, CODE_NAME \n");
			sql.append(" from TB_CODE_BOOK where substring(CODE_CD,1,4) in ('CHAN') ");

			System.out.println(sql.toString());
			resultString = super.excuteQueryString(con, sql.toString());
		} catch(Exception e) {
			LoggingWriter.setLogError("M000S010000E010()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
			try {
				if (con != null) con.close();
			} catch (Exception e) {
				LoggingWriter.setLogError("M000S010000E010()","==== finally ===="+ e.getMessage());
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

	// ���������ڵ� 
	public int E001(InoutParameter ioParam){		
		resultInt = EventDefine.E_DOEXCUTE_INIT;
				
		try {
			String rcvData = (String)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			v_paramArray = CommonFunction.getConvString2DoubleArray(rcvData);
			
			con = JDBCConnectionPool.getConnection();
			String sql = new StringBuilder()
					.append("SELECT\n")
					.append("	code_cd,\n")
					.append("	code_value,\n")
					.append("	code_name\n")
					.append("FROM\n")
					.append("	vtbm_code_book\n")
					.append("WHERE CODE_CD ='PRCSGB';\n")
					.toString();

			resultString = super.excuteQueryString(con, sql.toString());
		} catch(Exception e) {
			LoggingWriter.setLogError("M000S010000E001","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
			try {
				if (con != null) con.close();
			} catch (Exception e) {
				LoggingWriter.setLogError("M000S010000E001()","==== finally ===="+ e.getMessage());
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
	
	// Ÿ��ũ
	public int E020(InoutParameter ioParam){		
		resultInt = EventDefine.E_DOEXCUTE_INIT;
				
		try {
			String rcvData = (String)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			v_paramArray = CommonFunction.getConvString2DoubleArray(rcvData);
			
			con = JDBCConnectionPool.getConnection();
			
			// Ÿ��ũ(TASK)
			sql = new StringBuffer();
			sql.append(" select CODE_VALUE, CODE_NAME \n");
			sql.append(" from TB_CODE_BOOK where substring(CODE_CD,1,4) in ('TASK') ");

			System.out.println(sql.toString());
			resultString = super.excuteQueryString(con, sql.toString());
		} catch(Exception e) {
			LoggingWriter.setLogError("M000S010000E020()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
			try {
				if (con != null) con.close();
			} catch (Exception e) {
				LoggingWriter.setLogError("M000S010000E020()","==== finally ===="+ e.getMessage());
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

	// M101S12100 ������������
	public int E021(InoutParameter ioParam){		
		resultInt = EventDefine.E_DOEXCUTE_INIT;
				
		try {
			String rcvData = (String)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			v_paramArray = CommonFunction.getConvString2DoubleArray(rcvData);
			
			con = JDBCConnectionPool.getConnection();
			
			sql = new StringBuffer();
			sql.append(" select code_value , CODE_NAME, CODE_CD   \n");
			sql.append(" from v_delay_reason ");
			sql.append(" WHERE member_key='"+v_paramArray[0][0]+"'	\n");

			System.out.println(sql.toString());
			resultString = super.excuteQueryString(con, sql.toString());
		} catch(Exception e) {
			LoggingWriter.setLogError("M000S010000E021()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
			try {
				if (con != null) con.close();
			} catch (Exception e) {
				LoggingWriter.setLogError("M000S010000E021()","==== finally ===="+ e.getMessage());
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
	// M101S12200 �̻����߻�����
		public int E022(InoutParameter ioParam){		
			resultInt = EventDefine.E_DOEXCUTE_INIT;
					
			try {
				String rcvData = (String)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
				v_paramArray = CommonFunction.getConvString2DoubleArray(rcvData);
				
				con = JDBCConnectionPool.getConnection();
				
				sql = new StringBuffer();
				sql.append(" select code_value, CODE_NAME, CODE_CD  \n");
				sql.append(" from v_issue_reason ");

				System.out.println(sql.toString());
				resultString = super.excuteQueryString(con, sql.toString());
			} catch(Exception e) {
				LoggingWriter.setLogError("M000S010000E022()","==== SQL ERROR ===="+ e.getMessage());
				return EventDefine.E_DOEXCUTE_ERROR ;
		    } finally {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M000S010000E022()","==== finally ===="+ e.getMessage());
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
		
	// M101S09110 �����������
	public int E030(InoutParameter ioParam){		
		resultInt = EventDefine.E_DOEXCUTE_INIT;
				
		try {
			String rcvData = (String)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			v_paramArray = CommonFunction.getConvString2DoubleArray(rcvData);
			
			con = JDBCConnectionPool.getConnection();
			
			// �������(STUS)
			sql = new StringBuffer();
			sql.append(" select code_value, CODE_NAME, CODE_CD  \n");
			sql.append(" from v_order_status ");
			sql.append(" WHERE member_key='"+v_paramArray[0][0]+"'	\n");

			System.out.println(sql.toString());
			resultString = super.excuteQueryString(con, sql.toString());
		} catch(Exception e) {
			LoggingWriter.setLogError("M000S010000E030()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
			try {
				if (con != null) con.close();
			} catch (Exception e) {
				LoggingWriter.setLogError("M000S010000E030()","==== finally ===="+ e.getMessage());
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
	// M101S12000 �����������
	public int E031(InoutParameter ioParam){		
		resultInt = EventDefine.E_DOEXCUTE_INIT;
				
		try {
			String rcvData = (String)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			v_paramArray = CommonFunction.getConvString2DoubleArray(rcvData);
			
			con = JDBCConnectionPool.getConnection();
			
			// �������(STUS)
			sql = new StringBuffer();
			sql.append(" select code_value, CODE_NAME, CODE_CD  \n");
			sql.append(" from v_process_status ");

			System.out.println(sql.toString());
			resultString = super.excuteQueryString(con, sql.toString());
		} catch(Exception e) {
			LoggingWriter.setLogError("M000S010000E031()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
			try {
				if (con != null) con.close();
			} catch (Exception e) {
				LoggingWriter.setLogError("M000S010000E031()","==== finally ===="+ e.getMessage());
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
//�����������
	public int E033(InoutParameter ioParam){		
		resultInt = EventDefine.E_DOEXCUTE_INIT;
				
		try {
			String rcvData = (String)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			v_paramArray = CommonFunction.getConvString2DoubleArray(rcvData);
			
			con = JDBCConnectionPool.getConnection();
			
			// �������(STUS)
			sql = new StringBuffer();
			sql.append(" select proc_cd, process_nm, process_seq  \n");
			sql.append(" from tbm_process ");
			sql.append(" where work_class_cd='B' ");

			System.out.println(sql.toString());
			resultString = super.excuteQueryString(con, sql.toString());
		} catch(Exception e) {
			LoggingWriter.setLogError("M000S010000E033()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
			try {
				if (con != null) con.close();
			} catch (Exception e) {
				LoggingWriter.setLogError("M000S010000E033()","==== finally ===="+ e.getMessage());
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
	
	// v_balju_status ����STATUS
	public int E034(InoutParameter ioParam){		
		resultInt = EventDefine.E_DOEXCUTE_INIT;
				
		try {
			String rcvData = (String)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			v_paramArray = CommonFunction.getConvString2DoubleArray(rcvData);
			
			con = JDBCConnectionPool.getConnection();
			
			// ä��(CHAN)
			sql = new StringBuffer();
			sql.append(" select CODE_VALUE, CODE_NAME, CODE_CD \n");
			sql.append(" from v_balju_status ");
			System.out.println(sql.toString());
			resultString = super.excuteQueryString(con, sql.toString());
			
		} catch(Exception e) {
			LoggingWriter.setLogError("M000S010000E034()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
			try {
				if (con != null) con.close();
			} catch (Exception e) {
				LoggingWriter.setLogError("M000S010000E034()","==== finally ===="+ e.getMessage());
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

	// ǰ���˻籸���ڵ� v_inspect_gubun_code
	public int E035(InoutParameter ioParam){		
		resultInt = EventDefine.E_DOEXCUTE_INIT;
				
		try {
			String rcvData = (String)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			v_paramArray = CommonFunction.getConvString2DoubleArray(rcvData);
			
			con = JDBCConnectionPool.getConnection();
			
			// ä��(CHAN)
			sql = new StringBuffer();
			sql.append(" select CODE_VALUE, CODE_NAME, CODE_CD \n");
			sql.append(" from v_inspect_gubun_code ");
			System.out.println(sql.toString());
			resultString = super.excuteQueryString(con, sql.toString());
			
		} catch(Exception e) {
			LoggingWriter.setLogError("M000S010000E035()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
			try {
				if (con != null) con.close();
			} catch (Exception e) {
				LoggingWriter.setLogError("M000S010000E035()","==== finally ===="+ e.getMessage());
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
	

	// ǰ���˻籸���ڵ� v_inspect_gubun_code
	public int E036(InoutParameter ioParam){		
		resultInt = EventDefine.E_DOEXCUTE_INIT;
				
		try {
			String rcvData = (String)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			v_paramArray = CommonFunction.getConvString2DoubleArray(rcvData);
			
			con = JDBCConnectionPool.getConnection();
			
			// ä��(CHAN)
			sql = new StringBuffer();
			sql.append(" select CODE_VALUE, CODE_NAME, CODE_CD \n");
			sql.append(" from v_incongruity_code ");
			System.out.println(sql.toString());
			resultString = super.excuteQueryString(con, sql.toString());
			
		} catch(Exception e) {
			LoggingWriter.setLogError("M000S010000E036()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
			try {
				if (con != null) con.close();
			} catch (Exception e) {
				LoggingWriter.setLogError("M000S010000E036()","==== finally ===="+ e.getMessage());
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

	// üũ����Ʈ�����ڵ� getChecklistGubun_Code
	public int E037(InoutParameter ioParam){		
		resultInt = EventDefine.E_DOEXCUTE_INIT;
				
		try {
			String rcvData = (String)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			v_paramArray = CommonFunction.getConvString2DoubleArray(rcvData);
			
			con = JDBCConnectionPool.getConnection();
			
			sql = new StringBuffer();
			sql.append(" select CODE_VALUE, CODE_NAME, CODE_CD \n");
			sql.append(" from v_checklist_gubun ");
			sql.append(" WHERE member_key='"+v_paramArray[0][0]+"'	\n");
			System.out.println(sql.toString());
			
			resultString = super.excuteQueryString(con, sql.toString());
			
		} catch(Exception e) {
			LoggingWriter.setLogError("M000S010000E037()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
			try {
				if (con != null) con.close();
			} catch (Exception e) {
				LoggingWriter.setLogError("M000S010000E037()","==== finally ===="+ e.getMessage());
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

	// üũ����Ʈ�����ڵ�(���ϰ˻�,���ְ˻�) getChecklistGubun_PIN_SHIP_CodeALL
	public int E137(InoutParameter ioParam){		
		resultInt = EventDefine.E_DOEXCUTE_INIT;
				
		try {
			String rcvData = (String)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			v_paramArray = CommonFunction.getConvString2DoubleArray(rcvData);
			
			con = JDBCConnectionPool.getConnection();
			
			sql = new StringBuffer();
			//sql.append(" select CODE_VALUE, CODE_NAME, CODE_CD \n");
			sql.append(" select chk_lst_gb_big, chk_lst_gb_big_name, [cast('chkgb' AS VARCHAR(5))] \n");
			sql.append(" from v_checklist_gubun_pin_ship ");
			sql.append(" WHERE member_key='"+v_paramArray[0][0]+"'	\n");
			System.out.println(sql.toString());
			
			resultString = super.excuteQueryString(con, sql.toString());
			
		} catch(Exception e) {
			LoggingWriter.setLogError("M000S010000E137()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
			try {
				if (con != null) con.close();
			} catch (Exception e) {
				LoggingWriter.setLogError("M000S010000E137()","==== finally ===="+ e.getMessage());
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
	
	// üũ����Ʈ�����ڵ�(���԰˻�) getChecklistGubun_IMPORT_CodeALL
	public int E138(InoutParameter ioParam){		
		resultInt = EventDefine.E_DOEXCUTE_INIT;
				
		try {
			String rcvData = (String)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			v_paramArray = CommonFunction.getConvString2DoubleArray(rcvData);
			
			con = JDBCConnectionPool.getConnection();
			
			sql = new StringBuffer();
			sql.append(" select CODE_VALUE, CODE_NAME, CODE_CD \n");
			sql.append(" from v_checklist_gubun_import ");
			sql.append(" WHERE member_key='"+v_paramArray[0][0]+"'	\n");
			System.out.println(sql.toString());
			
			resultString = super.excuteQueryString(con, sql.toString());
			
		} catch(Exception e) {
			LoggingWriter.setLogError("M000S010000E138()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
			try {
				if (con != null) con.close();
			} catch (Exception e) {
				LoggingWriter.setLogError("M000S010000E138()","==== finally ===="+ e.getMessage());
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

	// üũ����Ʈ�����ڵ�getChecklistGubun_Code v_delay_reason
	public int E038(InoutParameter ioParam){		
		resultInt = EventDefine.E_DOEXCUTE_INIT;
				
		try {
			String rcvData = (String)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			v_paramArray = CommonFunction.getConvString2DoubleArray(rcvData);
			
			con = JDBCConnectionPool.getConnection();
			
			sql = new StringBuffer();
			sql.append(" select CODE_VALUE, CODE_NAME, CODE_CD \n");
			sql.append(" from v_prod_inspect_gubun ");
			System.out.println(sql.toString());
			resultString = super.excuteQueryString(con, sql.toString());
			
		} catch(Exception e) {
			LoggingWriter.setLogError("M000S010000E038()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
			try {
				if (con != null) con.close();
			} catch (Exception e) {
				LoggingWriter.setLogError("M000S010000E038()","==== finally ===="+ e.getMessage());
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


	// ������/������ġ ó���پ� getChecklistGubun_Code v_incong_method
	public int E039(InoutParameter ioParam){		
		resultInt = EventDefine.E_DOEXCUTE_INIT;
				
		try {
			String rcvData = (String)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			v_paramArray = CommonFunction.getConvString2DoubleArray(rcvData);
			
			con = JDBCConnectionPool.getConnection();
			
			sql = new StringBuffer();
			sql.append(" select CODE_VALUE, CODE_NAME, CODE_CD \n");
			sql.append(" from v_incong_method ");
			System.out.println(sql.toString());
			resultString = super.excuteQueryString(con, sql.toString());
			
		} catch(Exception e) {
			LoggingWriter.setLogError("M000S010000E039()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
			try {
				if (con != null) con.close();
			} catch (Exception e) {
				LoggingWriter.setLogError("M000S010000E039()","==== finally ===="+ e.getMessage());
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
	
	// �뵵
	public int E040(InoutParameter ioParam){		
		resultInt = EventDefine.E_DOEXCUTE_INIT;
				
		try {
			String rcvData = (String)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			v_paramArray = CommonFunction.getConvString2DoubleArray(rcvData);
			
			con = JDBCConnectionPool.getConnection();
			
			// ��ǰ�׷�(PRDG)
			sql = new StringBuffer();
			sql.append(" select CODE_CD, CODE_NAME, CODE_VALUE \n");
			sql.append(" from TB_CODE_BOOK where substring(CODE_CD,1,4) in ('PRDG') ");

			System.out.println(sql.toString());
			resultString = super.excuteQueryString(con, sql.toString());
		} catch(Exception e) {
			LoggingWriter.setLogError("M000S010E040()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
			try {
				if (con != null) con.close();
			} catch (Exception e) {
				LoggingWriter.setLogError("M000S010000E040()","==== finally ===="+ e.getMessage());
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


	// ����� �μ� get_dept_code v_dept_code
	public int E041(InoutParameter ioParam){		
		resultInt = EventDefine.E_DOEXCUTE_INIT;
				
		try {
			String rcvData = (String)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			v_paramArray = CommonFunction.getConvString2DoubleArray(rcvData);
			
			con = JDBCConnectionPool.getConnection();
			
			sql = new StringBuffer();
			sql.append(" select CODE_VALUE, CODE_NAME, CODE_CD \n");
			sql.append(" from v_dept_code ");
			sql.append(" WHERE member_key='"+v_paramArray[0][0]+"'	\n");
			System.out.println(sql.toString());
			resultString = super.excuteQueryString(con, sql.toString());
			
		} catch(Exception e) {
			LoggingWriter.setLogError("M000S010000E041()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
			try {
				if (con != null) con.close();
			} catch (Exception e) {
				LoggingWriter.setLogError("M000S010000E041()","==== finally ===="+ e.getMessage());
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
	

	// ���������� getDeptCodeAll 
	public int E042(InoutParameter ioParam){		
		resultInt = EventDefine.E_DOEXCUTE_INIT;
				
		try {
			String rcvData = (String)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			v_paramArray = CommonFunction.getConvString2DoubleArray(rcvData);
			
			con = JDBCConnectionPool.getConnection();
			
			sql = new StringBuffer();
			sql.append(" select CODE_VALUE, CODE_NAME, CODE_CD \n");
			sql.append(" from v_distroy_reason ");
			sql.append(" WHERE member_key='"+v_paramArray[0][0]+"'	\n");
			System.out.println(sql.toString());
			resultString = super.excuteQueryString(con, sql.toString());
			
		} catch(Exception e) {
			LoggingWriter.setLogError("M000S010000E042()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
			try {
				if (con != null) con.close();
			} catch (Exception e) {
				LoggingWriter.setLogError("M000S010000E042()","==== finally ===="+ e.getMessage());
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
	// ���������ڵ� process_gubun
	public int E043(InoutParameter ioParam){		
		resultInt = EventDefine.E_DOEXCUTE_INIT;
				
		try {
			String rcvData = (String)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			v_paramArray = CommonFunction.getConvString2DoubleArray(rcvData);
			
			con = JDBCConnectionPool.getConnection();
			
			sql = new StringBuffer();
			sql.append(" select CODE_VALUE, CODE_NAME, CODE_CD \n");
			sql.append(" from v_process_gubun ");
			sql.append(" where member_key='"+v_paramArray[0][0]+"'	\n");
			System.out.println(sql.toString());
			resultString = super.excuteQueryString(con, sql.toString());
			
		} catch(Exception e) {
			LoggingWriter.setLogError("M000S010000E043()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
			try {
				if (con != null) con.close();
			} catch (Exception e) {
				LoggingWriter.setLogError("M000S010000E043()","==== finally ===="+ e.getMessage());
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
	
	// // ������з��ڵ� process_gubun_big
	public int E044(InoutParameter ioParam){		
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			String rcvData = (String)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			v_paramArray = CommonFunction.getConvString2DoubleArray(rcvData);
			
			con = JDBCConnectionPool.getConnection();
			
			String sql = new StringBuilder()
					.append("SELECT\n")
					.append("	code_value,\n")
					.append("	code_name,\n")
					.append("	code_cd\n")
					.append("FROM\n")
					.append("	v_process_gubun_big\n")
					.append("WHERE\n")
					.append("	code_gubun='" + v_paramArray[0][0] + "'\n")
					.append("  AND member_key='"+v_paramArray[0][1]+"'	\n")
					.toString();

			System.out.println(sql.toString());
			resultString = super.excuteQueryString(con, sql.toString());
			
		} catch(Exception e) {
			LoggingWriter.setLogError("M000S010000E044()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
			try {
				if (con != null) con.close();
			} catch (Exception e) {
				LoggingWriter.setLogError("M000S010000E044()","==== finally ===="+ e.getMessage());
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
	// // �����ߺз��ڵ� process_gubun_mid
	public int E048(InoutParameter ioParam){		
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			String rcvData = (String)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			v_paramArray = CommonFunction.getConvString2DoubleArray(rcvData);
			
			con = JDBCConnectionPool.getConnection();
			String sql = new StringBuilder()
					.append("SELECT\n")
					.append("	code_value,\n")
					.append("	code_name,\n")
					.append("	code_cd\n")
					.append("FROM\n")
					.append("	v_process_gubun_mid\n")
					.append("WHERE\n")
					.append("	code_gubun='" 	+ v_paramArray[0][0] + "'\n")
					.append("and code_cd='" 		+ v_paramArray[0][1] + "'\n")
					.toString();

			resultString = super.excuteQueryString(con, sql.toString());
			
		} catch(Exception e) {
			LoggingWriter.setLogError("M000S010000E048()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
			try {
				if (con != null) con.close();
			} catch (Exception e) {
				LoggingWriter.setLogError("M000S010000E048()","==== finally ===="+ e.getMessage());
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

	
	// CCP���ؿ�ұ����ڵ� getccpGubun_CodeAll
	public int E045(InoutParameter ioParam){		
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			String rcvData = (String)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			v_paramArray = CommonFunction.getConvString2DoubleArray(rcvData);
			
			con = JDBCConnectionPool.getConnection();
			
			sql = new StringBuffer();
			sql.append(" select CODE_VALUE, CODE_NAME, CODE_CD \n");
			sql.append(" from v_ccpgubun_code_all ");
			System.out.println(sql.toString());
			resultString = super.excuteQueryString(con, sql.toString());
			
		} catch(Exception e) {
			LoggingWriter.setLogError("M000S010000E045()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
			try {
				if (con != null) con.close();
			} catch (Exception e) {
				LoggingWriter.setLogError("M000S010000E045()","==== finally ===="+ e.getMessage());
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

	// üũ����Ʈ�����ڵ� - �ߺз� getChecklistGubun_Code_Mid
	public int E046(InoutParameter ioParam){		
		resultInt = EventDefine.E_DOEXCUTE_INIT;
				
		try {			
			String rcvData = (String)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			v_paramArray = CommonFunction.getConvString2DoubleArray(rcvData);
			String[][] v_paramArray = CommonFunction.getConvString2DoubleArray(rcvData);
			
			con = JDBCConnectionPool.getConnection();
			
			sql = new StringBuffer();
			sql.append(" select CODE_VALUE, CODE_NAME, CODE_CD \n");
			sql.append(" from v_checklist_gubun_mid \n");
			sql.append(" where CODE_CD = '" + v_paramArray[0][0] + "'");
			sql.append("   and member_key='"+ v_paramArray[0][1]+"'	\n");
			System.out.println(sql.toString());
			
			resultString = super.excuteQueryString(con, sql.toString());
			
		} catch(Exception e) {
			LoggingWriter.setLogError("M000S010000E046()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
			try {
				if (con != null) con.close();
			} catch (Exception e) {
				LoggingWriter.setLogError("M000S010000E046()","==== finally ===="+ e.getMessage());
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
	// üũ����Ʈ�����ڵ� - �Һз� getChecklistGubun_Code_Sm
	public int E047(InoutParameter ioParam){		
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		try {
			con = JDBCConnectionPool.getConnection();			
			String rcvData = (String)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			
			String[][] v_paramArray = CommonFunction.getConvString2DoubleArray(rcvData);
			
			sql = new StringBuffer();
			sql.append(" select CODE_VALUE, CODE_NAME, CODE_CD, CODE_CD_BIG		\n");
			sql.append(" from v_checklist_gubun_sm								\n");
			sql.append(" where CODE_CD = '" + v_paramArray[0][1]		+ "' 	\n");
			sql.append("   and CODE_CD_BIG = '" + v_paramArray[0][0] 		+ "'	\n");
			sql.append("   and member_key='"+ v_paramArray[0][2]+"'	\n");
			System.out.println(sql.toString());
			
			resultString = super.excuteQueryString(con, sql.toString());
			
		} catch(Exception e) {
			LoggingWriter.setLogError("M000S010000E047()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
			try {
				if (con != null) con.close();
			} catch (Exception e) {
				LoggingWriter.setLogError("M000S010000E047()","==== finally ===="+ e.getMessage());
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
	
	// ��������
	public int E050(InoutParameter ioParam){		
		resultInt = EventDefine.E_DOEXCUTE_INIT;
				
		try {
			String rcvData = (String)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			v_paramArray = CommonFunction.getConvString2DoubleArray(rcvData);
			
			con = JDBCConnectionPool.getConnection();
			
			// �׷�(GRCD)
			sql = new StringBuffer();
			sql.append(" select USER_ID, USER_NM \n");
			//sql.append(" from USERS where USER_GROUP_CODE not in ('GRCD001') ");
			sql.append(" from tb_USERS \n ");
			sql.append(" order by USER_NM \n");

			System.out.println(sql.toString());
			resultString = super.excuteQueryString(con, sql.toString());
		} catch(Exception e) {
			LoggingWriter.setLogError("M000S010000E050()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
			try {
				if (con != null) con.close();
			} catch (Exception e) {
				LoggingWriter.setLogError("M000S010000E050()","==== finally ===="+ e.getMessage());
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
	
	// ������
	public int E051(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			String rcvData = (String)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			v_paramArray = CommonFunction.getConvString2DoubleArray(rcvData);
			
			con = JDBCConnectionPool.getConnection();
			
			// �׷�(GRCD)
			sql = new StringBuffer();
			sql.append(" select seolbi_cd, seolbi_nm \n");
			sql.append(" from tbm_seolbi \n ");
			sql.append(" WHERE TO_CHAR(SYSDATE,'YYYY-MM-DD') BETWEEN start_date AND duration_date \n"); //���ó�¥�� ��ȿ�� �����͸� ���
			sql.append(" order by seolbi_cd \n");

			System.out.println(sql.toString());
			resultString = super.excuteQueryString(con, sql.toString());
		} catch(Exception e) {
			LoggingWriter.setLogError("M000S010000E051()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
			try {
				if (con != null) con.close();
			} catch (Exception e) {
				LoggingWriter.setLogError("M000S010000E051()","==== finally ===="+ e.getMessage());
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

	// ����ڱ׷�
	public int E060(InoutParameter ioParam){		
		resultInt = EventDefine.E_DOEXCUTE_INIT;
				
		try {
			String rcvData = (String)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			v_paramArray = CommonFunction.getConvString2DoubleArray(rcvData);
			
			con = JDBCConnectionPool.getConnection();
			
			sql = new StringBuffer();
			sql.append(" select CODE_VALUE, CODE_NAME, CODE_CD \n");
			sql.append(" from v_group_code ");
			sql.append("WHERE member_key='"+v_paramArray[0][0]+"'	\n");

			System.out.println(sql.toString());
			resultString = super.excuteQueryString(con, sql.toString());
		} catch(Exception e) {
			LoggingWriter.setLogError("M000S010000E060()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
			try {
				if (con != null) con.close();
			} catch (Exception e) {
				LoggingWriter.setLogError("M000S010000E060()","==== finally ===="+ e.getMessage());
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
	
	// ����ڱ׷�(�α��� ���̵�)
	public int E061(InoutParameter ioParam){		
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			String rcvData = (String)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			String[][] c_paramArray = CommonFunction.getConvString2DoubleArray(rcvData);
			
		
			con = JDBCConnectionPool.getConnection();
			
			sql = new StringBuffer();
			sql.append(" select group_cd \n");
			sql.append(" from tbm_users  ");
			sql.append(" where user_id='" + c_paramArray[0][0] + "' ");
			sql.append("   AND member_key='"+c_paramArray[0][1]+"'	\n");
			sql.append("   AND TO_CHAR(SYSDATE,'YYYY-MM-DD') BETWEEN start_date AND duration_date\n");
			
			System.out.println(sql.toString());
			
			resultString = super.excuteQueryString(con, sql.toString());
			//System.out.println("resultString="+resultString);
		} catch(Exception e) {
			LoggingWriter.setLogError("M000S010000E061()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
			try {
				if (con != null) con.close();
			} catch (Exception e) {
				LoggingWriter.setLogError("M000S010000E061()","==== finally ===="+ e.getMessage());
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
	
	// ������̸�(�α��� ���̵�)
	public int E062(InoutParameter ioParam){	
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			String rcvData = (String)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			String[][] c_paramArray = CommonFunction.getConvString2DoubleArray(rcvData);
			
		
			con = JDBCConnectionPool.getConnection();
			
			sql = new StringBuffer();
			sql.append(" select revision_no \n");
			sql.append(" from tbm_users  ");
			sql.append(" where user_id='" + c_paramArray[0][0] + "' ");
			sql.append("   AND member_key='"+c_paramArray[0][1]+"'	\n");
			sql.append("   AND TO_CHAR(SYSDATE,'YYYY-MM-DD') BETWEEN start_date AND duration_date\n");
			
			System.out.println(sql.toString());
			
			resultString = super.excuteQueryString(con, sql.toString());
			//System.out.println("resultString="+resultString);
		} catch(Exception e) {
			LoggingWriter.setLogError("M000S010000E062()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
			try {
				if (con != null) con.close();
			} catch (Exception e) {
				LoggingWriter.setLogError("M000S010000E062()","==== finally ===="+ e.getMessage());
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
	
	// īī���� �˶��� ����ھ��̵� ���(�׷��ڵ� GRCD001, GRCD002)
		public int E063(InoutParameter ioParam){	
			resultInt = EventDefine.E_DOEXCUTE_INIT;
			
			try {
				String rcvData = (String)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
				String[][] c_paramArray = CommonFunction.getConvString2DoubleArray(rcvData);
				
			
				con = JDBCConnectionPool.getConnection();
				
				sql = new StringBuffer();
				sql.append(" SELECT user_id, \n");
				sql.append(" revision_no,    \n");
				sql.append(" user_nm     	 \n");
				sql.append(" FROM tbm_users  ");
				sql.append(" WHERE group_cd IN ('GRCD001', 'GRCD002') \n");
				sql.append(" AND user_id != 'henesys' \n"); //����Ǫ���� ��� henesys ID �����ϰ� ��ȸ�ϱ� ����
				sql.append("   AND TO_CHAR(SYSDATE,'YYYY-MM-DD') BETWEEN start_date AND duration_date\n");
				
				System.out.println(sql.toString());
				
				resultString = super.excuteQueryString(con, sql.toString());
				//System.out.println("resultString="+resultString);
			} catch(Exception e) {
				LoggingWriter.setLogError("M000S010000E063()","==== SQL ERROR ===="+ e.getMessage());
				return EventDefine.E_DOEXCUTE_ERROR ;
		    } finally {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M000S010000E063()","==== finally ===="+ e.getMessage());
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

	// ����
	public int E070(InoutParameter ioParam){		
		resultInt = EventDefine.E_DOEXCUTE_INIT;
				
		try {
			String rcvData = (String)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			v_paramArray = CommonFunction.getConvString2DoubleArray(rcvData);
			
			con = JDBCConnectionPool.getConnection();
			
			// �׷�(GRCD)
			sql = new StringBuffer();
			sql.append(" select CODE_CD, CODE_NAME \n");
			sql.append(" from TB_CODE_BOOK where substring(CODE_CD,1,4) in ('PRDU') ");
			sql.append(" order by CODE_CD ");

			System.out.println(sql.toString());
			resultString = super.excuteQueryString(con, sql.toString());
			//System.out.println("resultString="+resultString);
		} catch(Exception e) {
			LoggingWriter.setLogError("M000S010000E070()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
			try {
				if (con != null) con.close();
			} catch (Exception e) {
				LoggingWriter.setLogError("M000S010000E070()","==== finally ===="+ e.getMessage());
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
	
	// ��ǰ�����ڵ�(UNIT)
	public int E071(InoutParameter ioParam){		
		resultInt = EventDefine.E_DOEXCUTE_INIT;
				
		try {
			String rcvData = (String)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			v_paramArray = CommonFunction.getConvString2DoubleArray(rcvData);
			
			con = JDBCConnectionPool.getConnection();
			
			// �׷�(GRCD)
			sql = new StringBuffer();
			sql.append(" select CODE_VALUE, CODE_NAME, CODE_CD \n");
			sql.append(" from v_prod_unit_gubun ");
			sql.append(" where member_key='"+v_paramArray[0][0]+"'	\n");

			System.out.println(sql.toString());
			resultString = super.excuteQueryString(con, sql.toString());
			//System.out.println("resultString="+resultString);
		} catch(Exception e) {
			LoggingWriter.setLogError("M000S010000E071()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
			try {
				if (con != null) con.close();
			} catch (Exception e) {
				LoggingWriter.setLogError("M000S010000E071()","==== finally ===="+ e.getMessage());
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

	// ��ǰ�� �Ӽ� ��...
	public int E100(InoutParameter ioParam){		
		resultInt = EventDefine.E_DOEXCUTE_INIT;
				
		try {
			String rcvData = (String)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			String[][] c_paramArray = CommonFunction.getConvString2DoubleArray(rcvData);
			
			con = JDBCConnectionPool.getConnection();
			
			// �׷�(GRCD)
			sql = new StringBuffer();
			sql.append(" select CODE_CD, CODE_NAME, CODE_VALUE \n");
			sql.append(" from TB_CODE_BOOK where substring(CODE_CD,1,4) in ('" + c_paramArray[0][0] + "') ");
			sql.append(" order by CODE_CD ");
			
			System.out.println(sql.toString());
			resultString = super.excuteQueryString(con, sql.toString());
			//System.out.println("resultString="+resultString);
		} catch(Exception e) {
			LoggingWriter.setLogError("M000S010000E100()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
			try {
				if (con != null) con.close();
			} catch (Exception e) {
				LoggingWriter.setLogError("M000S010000E100()","==== finally ===="+ e.getMessage());				
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

	// �����ڵ�.
	public int E469(InoutParameter ioParam){		
		resultInt = EventDefine.E_DOEXCUTE_INIT;
				
		try {
			String rcvData = (String)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			String[][] c_paramArray = CommonFunction.getConvString2DoubleArray(rcvData);
			
			con = JDBCConnectionPool.getConnection();
			String sql = new StringBuilder()
					.append("SELECT\n")
					.append("	code_value,\n")
					.append("	code_name,\n")
					.append("	code_cd\n")
					.append("FROM\n")
					.append("	v_process_code\n")
					.toString();
			
			resultString = super.excuteQueryString(con, sql.toString());
			//System.out.println("resultString="+resultString);
		} catch(Exception e) {
			LoggingWriter.setLogError("M000S010000E469()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
			try {
				if (con != null) con.close();
			} catch (Exception e) {
				LoggingWriter.setLogError("M000S010000E469()","==== finally ===="+ e.getMessage());
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


	// �����ڵ� ��з��ڵ�.
	public int E470(InoutParameter ioParam){		
		resultInt = EventDefine.E_DOEXCUTE_INIT;
				
		try {
			String rcvData = (String)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			String[][] c_paramArray = CommonFunction.getConvString2DoubleArray(rcvData);
			
			con = JDBCConnectionPool.getConnection();
			
			// �׷�(GRCD)
			sql = new StringBuffer();
			sql.append(" select CODE_CD, CODE_NAME, CODE_VALUE \n");
			sql.append(" from TB_CODE_BOOK where substring(CODE_CD,1,3) = 'GPR' ");
			sql.append(" AND CODE_CD in ('GPR0200','GPR0300') ");
			sql.append(" order by order_index ");
			
			System.out.println(sql.toString());
			resultString = super.excuteQueryString(con, sql.toString());
		} catch(Exception e) {
			LoggingWriter.setLogError("M000S010000E470()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
			try {
				if (con != null) con.close();
			} catch (Exception e) {
				LoggingWriter.setLogError("M000S010000E470()","==== finally ===="+ e.getMessage());
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

	// �����ڵ� �ߺз��ڵ�.
	public int E471(InoutParameter ioParam){		
		resultInt = EventDefine.E_DOEXCUTE_INIT;
				
		try {
			String rcvData = (String)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			String[][] c_paramArray = CommonFunction.getConvString2DoubleArray(rcvData);
			
			String resParam = "";
			if (c_paramArray[0][0].length() >= 5) {
				resParam = c_paramArray[0][0].substring(0, 5);
			}
			con = JDBCConnectionPool.getConnection();
			
			// �׷�(GRCD)
			sql = new StringBuffer();
			sql.append(" select CODE_CD, CODE_NAME, CODE_VALUE \n");
			sql.append(" from TB_CODE_BOOK where substr(CODE_CD,1,5) = '" + resParam + "' \n");
			sql.append(" AND substring(CODE_CD,6,2) > '00' ");
			sql.append(" order by order_index ");
			
			System.out.println(sql.toString());
			resultString = super.excuteQueryString(con, sql.toString());
			//System.out.println("resultString="+resultString);
		} catch(Exception e) {
			LoggingWriter.setLogError("M000S010000E471()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
			try {
				if (con != null) con.close();
			} catch (Exception e) {
				LoggingWriter.setLogError("M000S010000E470()","==== finally ===="+ e.getMessage());
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
	
	// �����ڵ� �ߺз��ڵ�.
		public int W471(InoutParameter ioParam){		
			resultInt = EventDefine.E_DOEXCUTE_INIT;
					
			try {
				String rcvData = (String)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
				String[][] c_paramArray = CommonFunction.getConvString2DoubleArray(rcvData);

				con = JDBCConnectionPool.getConnection();
				// �׷�(GRCD)
				sql = new StringBuffer();
				sql.append(" select CODE_CD, CODE_NAME, CODE_VALUE \n");
				sql.append(" from TB_CODE_BOOK where substr(CODE_CD,1,5) in ('GPR02','GPR03') \n");
				sql.append(" AND substring(CODE_CD,6,2) > '00' ");
				sql.append(" order by order_index ");
				
				System.out.println(sql.toString());
				resultString = super.excuteQueryString(con, sql.toString());
			} catch(Exception e) {
				LoggingWriter.setLogError("M000S010000W471()","==== SQL ERROR ===="+ e.getMessage());
				return EventDefine.E_DOEXCUTE_ERROR ;
		    } finally {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M000S010000W471()","==== finally ===="+ e.getMessage());
				}
		    }
			ioParam.setResultString(resultString);
			ioParam.setColumnCount("" + super.COLUMN_COUNT);
	    	ioParam.setMessage(MessageDefine.M_QUERY_OK);
		    return EventDefine.E_QUERY_RESULT;
		}
	// �����ڵ� MAX(�Ϸù�ȣ).
	public int E472(InoutParameter ioParam){		
		resultInt = EventDefine.E_DOEXCUTE_INIT;
				
		try {
			String rcvData = (String)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			String[][] c_paramArray = CommonFunction.getConvString2DoubleArray(rcvData);
			con = JDBCConnectionPool.getConnection();
			
			// �׷�(GRCD)
			sql = new StringBuffer();
			sql.append(" select MAX(process_seq)+1 AS MAX_CD \n");
			sql.append(" from tbm_process where work_class_cd = '" + c_paramArray[0][0] + "' \n");
			sql.append(" AND  work_class_cd = '" + c_paramArray[0][1] + "' \n");
			/*
			sql.append(" AND substring(CODE_CD,6,2) = '" + c_paramArray[0][0] + "' ");
			*/
			sql.append(" order by order_index ");

			System.out.println(sql.toString());
			resultString = super.excuteQueryString(con, sql.toString());
			//System.out.println("resultString="+resultString);
		} catch(Exception e) {
			LoggingWriter.setLogError("M000S010000E472()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
			try {
				if (con != null) con.close();
			} catch (Exception e) {
				LoggingWriter.setLogError("M000S010000E472()","==== finally ===="+ e.getMessage());
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
	// �����ڵ� ��з��ڵ�.
	public int E379(InoutParameter ioParam){		
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		try {
			String rcvData = (String)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			String[][] c_paramArray = CommonFunction.getConvString2DoubleArray(rcvData);
			con = JDBCConnectionPool.getConnection();
			// �׷�(SEOL)
			sql = new StringBuffer();
			sql.append(" select CODE_CD, CODE_NAME, CODE_VALUE \n");
			sql.append(" from TB_CODE_BOOK where substring(CODE_CD,1,4) = 'SEOL' \n");
			sql.append(" AND CODE_VALUE IN('C','D') \n");
			sql.append(" AND substring(bigo,1,1) = 'B' \n");
			sql.append(" order by  CODE_CD, order_index \n");

			System.out.println(sql.toString());
			resultString = super.excuteQueryString(con, sql.toString());

		} catch(Exception e) {
			LoggingWriter.setLogError("M000S010000E379()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
			try {
				if (con != null) con.close();
			} catch (Exception e) {
				LoggingWriter.setLogError("M000S010000E379()","==== finally ===="+ e.getMessage());
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
	// �����ڵ� ��з��ڵ�.
		public int E370(InoutParameter ioParam){		
			resultInt = EventDefine.E_DOEXCUTE_INIT;
			try {
				String rcvData = (String)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
				String[][] c_paramArray = CommonFunction.getConvString2DoubleArray(rcvData);
				con = JDBCConnectionPool.getConnection();
				// �׷�(SEOL)
				sql = new StringBuffer();
				sql.append(" select CODE_CD, CODE_NAME, CODE_VALUE \n");
				sql.append(" from TB_CODE_BOOK where substring(CODE_CD,1,4) = 'SEOL' ");
				sql.append(" AND substring(bigo,1,1) = 'B' ");
				sql.append(" order by  CODE_CD, order_index ");

				System.out.println(sql.toString());
				resultString = super.excuteQueryString(con, sql.toString());

			} catch(Exception e) {
				LoggingWriter.setLogError("M000S010000E370()","==== SQL ERROR ===="+ e.getMessage());
				return EventDefine.E_DOEXCUTE_ERROR ;
		    } finally {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M000S010000E370()","==== finally ===="+ e.getMessage());
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

	// �����ڵ� �ߺз��ڵ�.
	public int E371(InoutParameter ioParam){		
		resultInt = EventDefine.E_DOEXCUTE_INIT;
				
		try {
			String rcvData = (String)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			String[][] c_paramArray = CommonFunction.getConvString2DoubleArray(rcvData);
			
			String resParam = "";
			if (c_paramArray[0][0].length() >= 5) {
				resParam = c_paramArray[0][0];
			}
			con = JDBCConnectionPool.getConnection();
			
			// �׷�(SEOL)
			sql = new StringBuffer();
			sql.append(" select CODE_CD, CODE_NAME, CODE_VALUE \n");
			sql.append(" from TB_CODE_BOOK where substring(CODE_CD,1,4) = 'SEOL' \n");
			sql.append(" AND CODE_VALUE LIKE '" + c_paramArray[0][0] + "%' \n");
			sql.append(" AND substring(bigo,1,1) = 'M' \n");
			sql.append(" order by order_index \n");
			
			System.out.println(sql.toString());
			
			resultString = super.excuteQueryString(con, sql.toString());
			//System.out.println("resultString="+resultString);
		} catch(Exception e) {
			LoggingWriter.setLogError("M000S010000E371()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
			try {
				if (con != null) con.close();
			} catch (Exception e) {
				LoggingWriter.setLogError("M000S010000E371()","==== finally ===="+ e.getMessage());
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

	// �����������ڵ�.
		public int E372(InoutParameter ioParam){		
			resultInt = EventDefine.E_DOEXCUTE_INIT;
					
			try {
				String rcvData = (String)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
				String[][] c_paramArray = CommonFunction.getConvString2DoubleArray(rcvData);
				
				String resParam = "";
				if (c_paramArray[0][0].length() >= 5) {
					resParam = c_paramArray[0][0];
				}
				con = JDBCConnectionPool.getConnection();
				
				// �׷�(SEOL)
				sql = new StringBuffer();
				sql.append(" select CODE_CD, CODE_NAME, CODE_VALUE \n");
				sql.append(" from v_seolbi_reason \n");

				System.out.println(sql.toString());
				
				resultString = super.excuteQueryString(con, sql.toString());
			} catch(Exception e) {
				LoggingWriter.setLogError("M000S010000E372()","==== SQL ERROR ===="+ e.getMessage());
				return EventDefine.E_DOEXCUTE_ERROR ;
		    } finally {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M000S010000E372()","==== finally ===="+ e.getMessage());
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
	
	// ���������׸������ڵ� .
	public int E360(InoutParameter ioParam){		
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		try {
			String rcvData = (String)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			String[][] c_paramArray = CommonFunction.getConvString2DoubleArray(rcvData);
			con = JDBCConnectionPool.getConnection();
			String sql = new StringBuilder()
					.append("SELECT		\n")
					.append("	 	code_cd		\n")
					.append("		,code_name	\n")
					.append("		,code_value 	\n")
					.append("from TBM_CODE_BOOK	\n")
					.append("where 1=1	\n")
					.append("	AND CODE_CD = 'GCHT'	\n")
					.append("	AND order_index > 0	\n")
					.append("	AND member_key='"+c_paramArray[0][0]+"'	\n")
					.append("ORDER BY order_index					\n")
					.toString();
//			sql = new StringBuffer();
//			sql.append(" select CODE_CD, CODE_NAME, CODE_VALUE \n");
//			sql.append(" from TB_CODE_BOOK where substring(CODE_CD,1,4) = 'GCHK' ");
//			sql.append(" order by order_index ");

			System.out.println(sql.toString());
			resultString = super.excuteQueryString(con, sql.toString());

		} catch(Exception e) {
			LoggingWriter.setLogError("M000S010000E360()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
			try {
				if (con != null) con.close();
			} catch (Exception e) {
				LoggingWriter.setLogError("M000S010000E360()","==== finally ===="+ e.getMessage());

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
	

	// ���԰˻��׸������ڵ� .
	public int E361(InoutParameter ioParam){		
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		try {
			String rcvData = (String)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			String[][] c_paramArray = CommonFunction.getConvString2DoubleArray(rcvData);
			con = JDBCConnectionPool.getConnection();

			String sql = new StringBuilder()
					.append("SELECT		\n")
					.append("	 	code_cd		\n")
					.append("		,code_name	\n")
					.append("		,code_value 	\n")
					.append("from TB_CODE_BOOK	\n")
					.append("where 1=1	\n")
					.append("AND SUBSTR(CODE_CD,1,4) = 'GCHK'	\n")
					.append("AND code_value IN('F')		\n")
					.append("ORDER BY order_index					\n")
					.toString();

			System.out.println(sql.toString());
			resultString = super.excuteQueryString(con, sql.toString());

		} catch(Exception e) {
			LoggingWriter.setLogError("M000S010000E361()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
			try {
				if (con != null) con.close();
			} catch (Exception e) {
				LoggingWriter.setLogError("M000S010000E361()","==== finally ===="+ e.getMessage());
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
	
		// BOM�ڵ�.
	public int E380(InoutParameter ioParam){		
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		try {
			String rcvData = (String)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			String[][] c_paramArray = CommonFunction.getConvString2DoubleArray(rcvData);
			con = JDBCConnectionPool.getConnection();
			// �׷�(SEOL)
			sql = new StringBuffer();
			sql.append(" select bom_cd, bom_nm, gijong_cd \n");
			sql.append(" from tbm_bom_code ");
			sql.append(" where  gijong_cd = '" + c_paramArray[0][0] + "' \n");
			sql.append(" order by gijong_cd,bom_no ");
			System.out.println(sql.toString());
			resultString = super.excuteQueryString(con, sql.toString());
		} catch(Exception e) {
			LoggingWriter.setLogError("M000S010000E380()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
			try {
				if (con != null) con.close();
			} catch (Exception e) {
				LoggingWriter.setLogError("M000S010000E380()","==== finally ===="+ e.getMessage());
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
	
	// DocGubun�ڵ�.
	public int E500(InoutParameter ioParam){		
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		try {
			String rcvData = (String)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			String[][] c_paramArray = CommonFunction.getConvString2DoubleArray(rcvData);
			con = JDBCConnectionPool.getConnection();
			// �׷�(SEOL)
			String sql = new StringBuilder()
					.append("SELECT\n")
					.append("	code_value,	\n")
					.append("	code_name,	\n")
					.append("	code_cd 	\n")
					.append("FROM\n")
					.append("	v_doc_gubun\n")
					.append("WHERE member_key='"+c_paramArray[0][0]+"'	\n")
					.toString();
	
			System.out.println(sql.toString());
			resultString = super.excuteQueryString(con, sql.toString());
		} catch(Exception e) {
			LoggingWriter.setLogError("M000S010000E500()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
			try {
				if (con != null) con.close();
			} catch (Exception e) {
				LoggingWriter.setLogError("M000S010000E500()","==== finally ===="+ e.getMessage());

			}
	    }
	    // ��� ���� ������ ���� �Ķ���͵��� ���̿� �Ķ���Ϳ� �����Ѵ�.M000S01000E
		ioParam.setResultString(resultString);
		// ���ۿ��� ó���� Į���� ������ Ŭ���̾�Ʈ���� ������ ���� �����´�.
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
		// �� ó���Ǿ��ٴ� �޽����� Ŭ���̾�Ʈ���� ������ ���� I/O�Ķ���Ϳ� �����Ѵ�.
		ioParam.setMessage(MessageDefine.M_QUERY_OK);
	    return EventDefine.E_QUERY_RESULT;
	}

	
	// DocGubunReg�ڵ�.
	public int E501(InoutParameter ioParam){		
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		try {
			String rcvData = (String)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			String[][] c_paramArray = CommonFunction.getConvString2DoubleArray(rcvData);
			con = JDBCConnectionPool.getConnection();
			// �׷�(SEOL)
			String sql = new StringBuilder()
					.append("SELECT\n")
					.append("	code_value,	\n")
					.append("	code_name,	\n")
					.append("	code_cd 	\n")
					.append("FROM\n")
					.append("	v_doc_reg_gubun\n")
					.append("WHERE member_key='"+c_paramArray[0][0]+"'	\n")
					.toString();
	
			System.out.println(sql.toString());
			resultString = super.excuteQueryString(con, sql.toString());
		} catch(Exception e) {
			LoggingWriter.setLogError("M000S010000E501()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
			try {
				if (con != null) con.close();
			} catch (Exception e) {
				LoggingWriter.setLogError("M000S010000E501()","==== finally ===="+ e.getMessage());
			}
	    }
	    // ��� ���� ������ ���� �Ķ���͵��� ���̿� �Ķ���Ϳ� �����Ѵ�.M000S01000E
		ioParam.setResultString(resultString);
		// ���ۿ��� ó���� Į���� ������ Ŭ���̾�Ʈ���� ������ ���� �����´�.
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
		// �� ó���Ǿ��ٴ� �޽����� Ŭ���̾�Ʈ���� ������ ���� I/O�Ķ���Ϳ� �����Ѵ�.
		ioParam.setMessage(MessageDefine.M_QUERY_OK);
	    return EventDefine.E_QUERY_RESULT;
	}

	// DocGubun�ڵ�.
	public int E502(InoutParameter ioParam){		
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		try {
			String rcvData = (String)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			String[][] c_paramArray = CommonFunction.getConvString2DoubleArray(rcvData);
			con = JDBCConnectionPool.getConnection();
			// �׷�(SEOL)
			String sql = new StringBuilder()
					.append("SELECT\n")
					.append("	code_value,	\n")
					.append("	code_name,	\n")
					.append("	code_cd 	\n")
					.append("FROM\n")
					.append("	v_hdoc_gubun\n")
					.append("WHERE member_key='"+c_paramArray[0][0]+"'	\n")
					.toString();
	
			System.out.println(sql.toString());
			resultString = super.excuteQueryString(con, sql.toString());
		} catch(Exception e) {
			LoggingWriter.setLogError("M000S010000E502()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
			try {
				if (con != null) con.close();
			} catch (Exception e) {
				LoggingWriter.setLogError("M000S010000E502()","==== finally ===="+ e.getMessage());

			}
	    }
	    // ��� ���� ������ ���� �Ķ���͵��� ���̿� �Ķ���Ϳ� �����Ѵ�.M000S01000E
		ioParam.setResultString(resultString);
		// ���ۿ��� ó���� Į���� ������ Ŭ���̾�Ʈ���� ������ ���� �����´�.
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
		// �� ó���Ǿ��ٴ� �޽����� Ŭ���̾�Ʈ���� ������ ���� I/O�Ķ���Ϳ� �����Ѵ�.
		ioParam.setMessage(MessageDefine.M_QUERY_OK);
	    return EventDefine.E_QUERY_RESULT;
	}

	
	// �ڵ�� �ڵ�׷�.
	public int E600(InoutParameter ioParam){		
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		try {
			String rcvData = (String)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			String[][] c_paramArray = CommonFunction.getConvString2DoubleArray(rcvData);
			con = JDBCConnectionPool.getConnection();
			// �׷�(SEOL)
			String sql = new StringBuilder()
					.append("SELECT\n")
					.append("        code_cd, \n")
					.append("        code_name,\n")
					.append("        code_value \n")
					.append("FROM\n")
					.append("        tbm_code_book\n")
					.append("WHERE TO_CHAR(SYSDATE,'YYYY-MM-DD') BETWEEN start_date AND duration_date\n")
					.append("  AND ORDER_INDEX = 0 \n")
					.append("  AND member_key='"+c_paramArray[0][0]+"'	\n")
					.append("GROUP BY code_cd \n")
					.append("ORDER BY code_name \n")
					.toString();

		
			System.out.println(sql.toString());
			resultString = super.excuteQueryString(con, sql.toString());
		} catch(Exception e) {
			LoggingWriter.setLogError("M000S010000E600()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
		} finally {
			try {
				if (con != null) con.close();
			} catch (Exception e) {
				LoggingWriter.setLogError("M000S010000E600()","==== finally ===="+ e.getMessage());
			}
		}
		// ��� ���� ������ ���� �Ķ���͵��� ���̿� �Ķ���Ϳ� �����Ѵ�.M000S01000E
		ioParam.setResultString(resultString);
		// ���ۿ��� ó���� Į���� ������ Ŭ���̾�Ʈ���� ������ ���� �����´�.
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
		// �� ó���Ǿ��ٴ� �޽����� Ŭ���̾�Ʈ���� ������ ���� I/O�Ķ���Ϳ� �����Ѵ�.
		ioParam.setMessage(MessageDefine.M_QUERY_OK);
		return EventDefine.E_QUERY_RESULT;
	}	

	// �ڵ�� ����׷�(������,����,����)
	public int E700(InoutParameter ioParam){		
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		try {
			String rcvData = (String)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			String[][] c_paramArray = CommonFunction.getConvString2DoubleArray(rcvData);
			con = JDBCConnectionPool.getConnection();
			// �׷�(SEOL)
			String sql = new StringBuilder()
					.append("SELECT\n")
					.append("	code_value,	\n")
					.append("	code_name,	\n")
					.append("	code_cd 	\n")
					.append("FROM\n")
					.append("	v_seolbibiggubun \n")
					.append("WHERE code_cd = 'SELB' \n")
					.append("	AND member_key='"+c_paramArray[0][0]+"'	\n")
					.append("ORDER BY code_value \n")
					.toString();
		
			System.out.println(sql.toString());
			resultString = super.excuteQueryString(con, sql.toString());
		} catch(Exception e) {
			LoggingWriter.setLogError("M000S010000E700()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
		} finally {
			try {
				if (con != null) con.close();
			} catch (Exception e) {
				LoggingWriter.setLogError("M000S010000E700()","==== finally ===="+ e.getMessage());
			}
		}
		// ��� ���� ������ ���� �Ķ���͵��� ���̿� �Ķ���Ϳ� �����Ѵ�.M000S01000E
		ioParam.setResultString(resultString);
		// ���ۿ��� ó���� Į���� ������ Ŭ���̾�Ʈ���� ������ ���� �����´�.
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
		// �� ó���Ǿ��ٴ� �޽����� Ŭ���̾�Ʈ���� ������ ���� I/O�Ķ���Ϳ� �����Ѵ�.
		ioParam.setMessage(MessageDefine.M_QUERY_OK);
		return EventDefine.E_QUERY_RESULT;
	}	

	// �ڵ�� ����׷�(������,����,����)
	public int E710(InoutParameter ioParam){		
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		try {
			String rcvData = (String)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			String[][] c_paramArray = CommonFunction.getConvString2DoubleArray(rcvData);
			con = JDBCConnectionPool.getConnection();
			// �׷�(SEOL)
			String sql = new StringBuilder()
					.append("SELECT\n")
					.append("	code_value,	\n")
					.append("	code_name,	\n")
					.append("	code_cd 	\n")
					.append("FROM\n")
					.append("	v_seolbi_reason \n")
					.append("WHERE code_cd = 'SELR' \n")
					.append("	AND member_key='"+c_paramArray[0][0]+"'	\n")
					.append("ORDER BY code_value \n")
					.toString();
		
			System.out.println(sql.toString());
			resultString = super.excuteQueryString(con, sql.toString());
		} catch(Exception e) {
			LoggingWriter.setLogError("M000S010000E710()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
		} finally {
			try {
				if (con != null) con.close();
			} catch (Exception e) {
				LoggingWriter.setLogError("M000S010000E710()","==== finally ===="+ e.getMessage());
			}
		}
		// ��� ���� ������ ���� �Ķ���͵��� ���̿� �Ķ���Ϳ� �����Ѵ�.M000S01000E
		ioParam.setResultString(resultString);
		// ���ۿ��� ó���� Į���� ������ Ŭ���̾�Ʈ���� ������ ���� �����´�.
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
		// �� ó���Ǿ��ٴ� �޽����� Ŭ���̾�Ʈ���� ������ ���� I/O�Ķ���Ϳ� �����Ѵ�.
		ioParam.setMessage(MessageDefine.M_QUERY_OK);
		return EventDefine.E_QUERY_RESULT;
	}
	
	//log Insert.
	public int E998(InoutParameter ioParam){		
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		try {
			String rcvData = (String)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			String[][] c_paramArray = CommonFunction.getConvString2DoubleArray(rcvData);
			con = JDBCConnectionPool.getConnection();
			
			String opt = c_paramArray[0][0]; // 0: tbm_production_head, 1: tbi_production_plan
			sql = new StringBuffer();
	        sql.append(" INSERT INTO                                    	\n");                                                     
            sql.append(" tbi_production_plan (                              \n");                                                      
            sql.append(" 	order_no,			--�ֹ���ȣ            	\n");                                                                
            sql.append(" 	order_detail_seq,	--�ֹ����ι�ȣ      	\n");                                                                   
            sql.append(" 	product_serial_no,	--�����ȹ�Ϸù�ȣ 	\n");                                                                      
            sql.append(" 	proc_cd,			--�����ڵ�               \n");                                                                  
            sql.append(" 	proc_info_no,		--���������Ϸù�ȣ	\n");                                                                       
            sql.append(" 	gijong_cd,			--�����ڵ�          		\n");                                                                   
            sql.append(" 	bom_no,				--BOM�Ϸù�ȣ   		\n");//                                                                     
            sql.append(" 	proc_qnt,			--�������               \n");                                                                   
            sql.append(" 	MAN_AMT,			--�����ο���            	\n");                                                                
            sql.append(" 	inspect_fl,			--�˻翩��            	\n");
            sql.append(" 	start_dt,			--���ۿ�����        		\n");                                                                        
            sql.append(" 	end_dt,				--�ϷΌ����        		\n");                                                                          
            sql.append(" 	rout_dt,			--����ÿ����Ͻ�   	\n");                                                                           
            sql.append(" 	proc_odr,			--�۾�����              	\n");  
            sql.append(" 	work_status_cd		--�۾���������ڵ�   	\n");   
            sql.append(" 	work_log_dt		    	\n");                                                                         
            sql.append(" )                                                       \n");      
			if(opt.equals("0")) {                                                 
	            sql.append(" SELECT                                        		\n");                                                        
	            sql.append(" 	order_no,			--�ֹ���ȣ            	\n");                                                                
	            sql.append(" 	order_detail_seq,	--�ֹ����ι�ȣ      	\n");                                                                   
	            sql.append(" 	product_serial_no,	--�����ȹ�Ϸù�ȣ 	\n");                                                                      
	            sql.append(" 	proc_cd,			--�����ڵ�               \n");                                                                  
	            sql.append(" 	proc_info_no,		--���������Ϸù�ȣ	\n");                                                                       
	            sql.append(" 	gijong_cd,			--�����ڵ�          		\n");                                                                   
	            sql.append(" 	bom_no,				--BOM�Ϸù�ȣ   		\n");//                                                                     
	            sql.append(" 	proc_qnt,			--�������               \n");                                                                   
	            sql.append(" 	MAN_AMT,			--�����ο���            	\n");                                                                
	            sql.append(" 	inspect_fl,			--�˻翩��            	\n");
	            sql.append(" 	start_dt,			--���ۿ�����        		\n");                                                                        
	            sql.append(" 	end_dt,				--�ϷΌ����        		\n");                                                                          
	            sql.append(" 	rout_dt,			--����ÿ����Ͻ�   	\n");                                                                           
	            sql.append(" 	proc_odr,			--�۾�����              	\n");                                                                     
	            sql.append(" 	work_status_cd		--�۾���������ڵ�   	\n");                                       
	            sql.append(" FROM tb_orderinfo_detail A, tbm_product C, tbi_process_manager D	\n");                                       
	            sql.append(" WHERE A.prod_cd = C.prod_cd  \n");              
	            sql.append("    AND C.gijong = D.gijong_cd  \n"); 
				sql.append("    AND D.gijong_cd ='" + c_paramArray[0][1] + "' \n"); //GIJONG_CODE
				sql.append("    AND A.order_no = '" + c_paramArray[0][2] + "' \n");  //JUMUN_CODE
			
				sql.append( c_paramArray[0][0] ); //�� SQL
			}
			else {
				
			}
			resultString = super.excuteQueryString(con, sql.toString());
	System.out.println(sql.toString());
		} catch(Exception e) {
			LoggingWriter.setLogError("M000S010000E998()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
			try {
				if (con != null) con.close();
			} catch (Exception e) {
				LoggingWriter.setLogError("M000S010000E998()","==== finally ===="+ e.getMessage());

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
	
	//�� SQL QUERY�����ϴ� fUNCTION;  SELECT * FROM TBtABLE WHERE.
	public int E999(InoutParameter ioParam){		
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		try {
			String rcvData = (String)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			String[][] c_paramArray = CommonFunction.getConvString2DoubleArray(rcvData);
			con = JDBCConnectionPool.getConnection();
			
			sql = new StringBuffer();				            
			sql.append(" SELECT nvl(max(PROD_SERIAL_NO), 0)+1	\n");                                                 
            sql.append(" FROM  tbi_production_head  			\n"); 
            sql.append(" WHERE ORDER_NO = '" 				+ c_paramArray[0][0] +  "' 	\n"); //GV_ORDER_NO +
			sql.append("    AND ORDER_DETAIL_SEQ = '"	+ c_paramArray[0][1]  + "' 	\n"); //GV_ORDER_DETAIL_SEQ

			resultString = super.excuteQueryString(con, sql.toString());
			System.out.println(sql.toString());
	System.out.println(sql.toString());
		} catch(Exception e) {
			LoggingWriter.setLogError("M000S010000E999()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
	    } finally {
			try {
				if (con != null) con.close();
			} catch (Exception e) {
				LoggingWriter.setLogError("M000S010000E999()","==== finally ===="+ e.getMessage());

			}
	    }
		ioParam.setResultString(resultString);
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
		ioParam.setMessage(MessageDefine.M_QUERY_OK);
	    return EventDefine.E_QUERY_RESULT;
	}
	
	// ��Ʈ�ڵ�� �ڵ�׷�(����). ��з� order_index 0���ΰ�
	public int E604(InoutParameter ioParam){		
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		try {
			con = JDBCConnectionPool.getConnection();
			// �׷�(SEOL)
			String sql = new StringBuilder()
					.append("SELECT\n")
					.append("        code_cd, \n")
					.append("        code_name,\n")
					.append("        code_value \n")
					.append("FROM\n")
					.append("        tbm_part_code_book\n")
					.append("WHERE TO_CHAR(SYSDATE,'YYYY-MM-DD') BETWEEN start_date AND duration_date\n")
					.append(" AND ORDER_INDEX = 0 \n")
					.append(" AND code_cd = 'PRDGB' \n")
					.append("ORDER BY code_name \n")
					.toString();
		
			System.out.println(sql.toString());
			resultString = super.excuteQueryString(con, sql.toString());
		} catch(Exception e) {
			LoggingWriter.setLogError("M000S010000E604()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
		} finally {
			try {
				if (con != null) con.close();
			} catch (Exception e) {
				LoggingWriter.setLogError("M000S010000E604()","==== finally ===="+ e.getMessage());
			}
		}
		// ��� ���� ������ ���� �Ķ���͵��� ���̿� �Ķ���Ϳ� �����Ѵ�.M000S01000E
		ioParam.setResultString(resultString);
		// ���ۿ��� ó���� Į���� ������ Ŭ���̾�Ʈ���� ������ ���� �����´�.
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
		// �� ó���Ǿ��ٴ� �޽����� Ŭ���̾�Ʈ���� ������ ���� I/O�Ķ���Ϳ� �����Ѵ�.
		ioParam.setMessage(MessageDefine.M_QUERY_OK);
		return EventDefine.E_QUERY_RESULT;
	}	
				
	// ��Ʈ�ڵ�� �ڵ�׷�(����). �ߺз� order_index 0���ΰ�
	public int E605(InoutParameter ioParam){		
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		try {
			con = JDBCConnectionPool.getConnection();
			// �׷�(SEOL)
			String sql = new StringBuilder()
					.append("SELECT\n")
					.append("        code_cd, \n")
					.append("        code_name,\n")
					.append("        code_value \n")
					.append("FROM\n")
					.append("        tbm_part_code_book\n")
					.append("WHERE TO_CHAR(SYSDATE,'YYYY-MM-DD') BETWEEN start_date AND duration_date\n")
					.append(" AND ORDER_INDEX = 0 \n")
					.append(" AND code_cd = 'PRDGM' \n")
					.append("ORDER BY code_name \n")
					.toString();

			System.out.println(sql.toString());
			resultString = super.excuteQueryString(con, sql.toString());
		} catch(Exception e) {
			LoggingWriter.setLogError("M000S010000E605()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
		} finally {
			try {
				if (con != null) con.close();
			} catch (Exception e) {
				LoggingWriter.setLogError("M000S010000E605()","==== finally ===="+ e.getMessage());
			}
		}
		// ��� ���� ������ ���� �Ķ���͵��� ���̿� �Ķ���Ϳ� �����Ѵ�.M000S01000E
		ioParam.setResultString(resultString);
		// ���ۿ��� ó���� Į���� ������ Ŭ���̾�Ʈ���� ������ ���� �����´�.
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
		// �� ó���Ǿ��ٴ� �޽����� Ŭ���̾�Ʈ���� ������ ���� I/O�Ķ���Ϳ� �����Ѵ�.
		ioParam.setMessage(MessageDefine.M_QUERY_OK);
		return EventDefine.E_QUERY_RESULT;
	}	

	// ��Ʈ�ڵ�� �ڵ�׷�(����). �Һз� order_index 0���ΰ�
	public int E606(InoutParameter ioParam){		
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		try {
			con = JDBCConnectionPool.getConnection();
			// �׷�(SEOL)
			String sql = new StringBuilder()
					.append("SELECT\n")
					.append("        code_cd, \n")
					.append("        code_name,\n")
					.append("        code_value \n")
					.append("FROM\n")
					.append("        tbm_part_code_book\n")
					.append("WHERE TO_CHAR(SYSDATE,'YYYY-MM-DD') BETWEEN start_date AND duration_date\n")
					.append(" AND ORDER_INDEX = 0 \n")
					.append(" AND code_cd = 'PRDGS' \n")
					.append("ORDER BY code_name \n")
					.toString();
		
			System.out.println(sql.toString());
			resultString = super.excuteQueryString(con, sql.toString());
		} catch(Exception e) {
			LoggingWriter.setLogError("M000S010000E605()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
		} finally {
			try {
				if (con != null) con.close();
			} catch (Exception e) {
				LoggingWriter.setLogError("M000S010000E605()","==== finally ===="+ e.getMessage());
			}
		}
		// ��� ���� ������ ���� �Ķ���͵��� ���̿� �Ķ���Ϳ� �����Ѵ�.M000S01000E
		ioParam.setResultString(resultString);
		// ���ۿ��� ó���� Į���� ������ Ŭ���̾�Ʈ���� ������ ���� �����´�.
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
		// �� ó���Ǿ��ٴ� �޽����� Ŭ���̾�Ʈ���� ������ ���� I/O�Ķ���Ϳ� �����Ѵ�.
		ioParam.setMessage(MessageDefine.M_QUERY_OK);
		return EventDefine.E_QUERY_RESULT;
	}	
		
	// (����)���������ڵ�� ���������з�
	public int E804(InoutParameter ioParam){		
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		try {
			String rcvData = (String)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			String[][] c_paramArray = CommonFunction.getConvString2DoubleArray(rcvData);
			con = JDBCConnectionPool.getConnection();
			// �׷�(SEOL)
			String sql = new StringBuilder()
					.append("SELECT\n")
					.append("	code_value,								\n")
					.append("	code_name,								\n")
					.append("	code_cd 								\n")
					.append("FROM										\n")
					.append("	v_partgubun_big 						\n")
					.append("WHERE member_key='"+c_paramArray[0][0]+"'	\n")
					.append("ORDER BY code_name 						\n")
					.toString();
		
			System.out.println(sql.toString());
			resultString = super.excuteQueryString(con, sql.toString());
		} catch(Exception e) {
			LoggingWriter.setLogError("M000S010000E804()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
		} finally {
			try {
				if (con != null) con.close();
			} catch (Exception e) {
				LoggingWriter.setLogError("M000S010000E804()","==== finally ===="+ e.getMessage());
			}
		}
		ioParam.setResultString(resultString);
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
		ioParam.setMessage(MessageDefine.M_QUERY_OK);
		return EventDefine.E_QUERY_RESULT;
	}
	
	// (����)���������ڵ�� ���������ߺз�
	public int E814(InoutParameter ioParam){		
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		try {
			String rcvData = (String)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			String[][] c_paramArray = CommonFunction.getConvString2DoubleArray(rcvData);
			con = JDBCConnectionPool.getConnection();
			// �׷�(SEOL)
			String sql = new StringBuilder()
					.append("SELECT\n")
					.append("	code_value,	\n")
					.append("	code_name,	\n")
					.append("	code_cd 	\n")
					.append("FROM\n")
					.append("	v_partgubun_mid \n")
					.append("WHERE code_value like '"+c_paramArray[0][0]+"%'\n")
					.append("	AND member_key='"+c_paramArray[0][1]+"'	\n")
					.append("ORDER BY code_value \n")
					.toString();
		
			resultString = super.excuteQueryString(con, sql.toString());
		} catch(Exception e) {
			LoggingWriter.setLogError("M000S010000E814()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
		} finally {
			try {
				if (con != null) con.close();
			} catch (Exception e) {
				LoggingWriter.setLogError("M000S010000E814()","==== finally ===="+ e.getMessage());
			}
		}
		ioParam.setResultString(resultString);
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
		ioParam.setMessage(MessageDefine.M_QUERY_OK);
		return EventDefine.E_QUERY_RESULT;
	}
	
	public int E824(InoutParameter ioParam){		
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		try {
			String rcvData = (String)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			String[][] c_paramArray = CommonFunction.getConvString2DoubleArray(rcvData);
			con = JDBCConnectionPool.getConnection();

			String sql = new StringBuilder()
					.append("SELECT\n")
					.append("	part_cd,\n")
					.append("	part_nm\n")
					.append("FROM\n")
					.append("	tbm_part_list\n")
					.append("WHERE part_gubun_b = '" + c_paramArray[0][0] + "'\n")
					.append("	AND part_gubun_m = '" + c_paramArray[0][1] + "'\n")
					.toString();
		
			resultString = super.excuteQueryString(con, sql.toString());
		} catch(Exception e) {
			LoggingWriter.setLogError("M000S010000E824()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
		} finally {
			try {
				if (con != null) con.close();
			} catch (Exception e) {
				LoggingWriter.setLogError("M000S010000E824()","==== finally ===="+ e.getMessage());
			}
		}
		ioParam.setResultString(resultString);
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
		ioParam.setMessage(MessageDefine.M_QUERY_OK);
		return EventDefine.E_QUERY_RESULT;
	}
	
	// ��ǰ�ڵ�� ��ǰ��з� TBM_CODE_BOOK :PRODB
	public int E904(InoutParameter ioParam){
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		
		try {
			String rcvData = (String)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			String[][] c_paramArray = CommonFunction.getConvString2DoubleArray(rcvData);
			con = JDBCConnectionPool.getConnection();
			
			// �׷�(SEOL)
			String sql = new StringBuilder()
					.append("SELECT					\n")
					.append("	code_value,			\n")
					.append("	code_name,			\n")
					.append("	code_cd				\n")
					.append("FROM					\n")
					.append("	v_prodgubun_big		\n")
					.append("WHERE member_key = '"+c_paramArray[0][0]+"'	\n")
					.append("ORDER BY code_value	\n")
					.toString();
		
			resultString = super.excuteQueryString(con, sql.toString());
		} catch(Exception e) {
			LoggingWriter.setLogError("M000S010000E904()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR;
		} finally {
			try {
				if (con != null) {
					con.close();
				}
			} catch (Exception e) {
				LoggingWriter.setLogError("M000S010000E904()","==== finally ===="+ e.getMessage());
			}
		}
		
		ioParam.setResultString(resultString);
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
		ioParam.setMessage(MessageDefine.M_QUERY_OK);
		
		return EventDefine.E_QUERY_RESULT;
	}
	
	// ��ǰ�ڵ�� ��ǰ�ߺз� TBM_PART_CODE_BOOK
	public int E914(InoutParameter ioParam){		
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		try {
			String rcvData = (String)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			String[][] c_paramArray = CommonFunction.getConvString2DoubleArray(rcvData);
			con = JDBCConnectionPool.getConnection();
			// �׷�(SEOL)
			String sql = new StringBuilder()
					.append("SELECT\n")
					.append("	code_value,	\n")
					.append("	code_name,	\n")
					.append("	code_cd 									\n")
					.append("FROM											\n")
					.append("	v_prodgubun_mid 							\n")
					.append("WHERE code_value like '"+c_paramArray[0][0]+"%'\n")
					.append("	AND member_key='"+c_paramArray[0][1]+"'		\n")
					.append("ORDER BY code_value 							\n")
					.toString();
		
			resultString = super.excuteQueryString(con, sql.toString());
		} catch(Exception e) {
			LoggingWriter.setLogError("M000S010000E914()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
		} finally {
			try {
				if (con != null) con.close();
			} catch (Exception e) {
				LoggingWriter.setLogError("M000S010000E914()","==== finally ===="+ e.getMessage());
			}
		}
		ioParam.setResultString(resultString);
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
		ioParam.setMessage(MessageDefine.M_QUERY_OK);
		return EventDefine.E_QUERY_RESULT;
	}
	
	
	// ��ǰ ��з� �ߺз��� �´� ��ǰ�� ��ȸ
		public int E924(InoutParameter ioParam){		
			resultInt = EventDefine.E_DOEXCUTE_INIT;
			try {
				String rcvData = (String)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
				String[][] c_paramArray = CommonFunction.getConvString2DoubleArray(rcvData);
				con = JDBCConnectionPool.getConnection();
				// �׷�(SEOL)
				String sql = new StringBuilder()
						.append("SELECT\n")
						.append("	prod_cd,	\n")
						.append("	product_nm	\n")
						.append("FROM											\n")
						.append("	vtbm_product								\n")
						.append("WHERE prod_gubun_b like '"+c_paramArray[0][0]+"%'\n")
						.append("   AND prod_gubun_m like '"+c_paramArray[0][1]+"%' \n")
						.append("	AND member_key='"+c_paramArray[0][2]+"'		\n")
						.append("ORDER BY prod_cd 								\n")
						.toString();
			
				resultString = super.excuteQueryString(con, sql.toString());
			} catch(Exception e) {
				LoggingWriter.setLogError("M000S010000E924()","==== SQL ERROR ===="+ e.getMessage());
				return EventDefine.E_DOEXCUTE_ERROR ;
			} finally {
				try {
					if (con != null) con.close();
				} catch (Exception e) {
					LoggingWriter.setLogError("M000S010000E924()","==== finally ===="+ e.getMessage());
				}
			}
			ioParam.setResultString(resultString);
			ioParam.setColumnCount("" + super.COLUMN_COUNT);
			ioParam.setMessage(MessageDefine.M_QUERY_OK);
			return EventDefine.E_QUERY_RESULT;
		}
	
	// ccp ������ ��� haccp_censor_info
	public int E806(InoutParameter ioParam){		
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		try {
			String rcvData = (String)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			con = JDBCConnectionPool.getConnection();
			
			// �׷�(SEOL)
			String sql = new StringBuilder()
					.append("SELECT\n")
					.append("	censor_name									\n")
					.append("FROM											\n")
					.append("	haccp_censor_info 							\n")
					.append("GROUP BY censor_no 							\n")
					.append("HAVING censor_type IN ("+rcvData+")			\n")
					.toString();
		
			resultString = super.excuteQueryString(con, sql.toString());
		} catch(Exception e) {
			LoggingWriter.setLogError("M000S010000E806()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
		} finally {
			try {
				if (con != null) con.close();
			} catch (Exception e) {
				LoggingWriter.setLogError("M000S010000E806()","==== finally ===="+ e.getMessage());
			}
		}
		ioParam.setResultString(resultString);
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
		ioParam.setMessage(MessageDefine.M_QUERY_OK);
		return EventDefine.E_QUERY_RESULT;
	}
		
	// ccp ����Ÿ�� ��� haccp_censor_info
	public int E807(InoutParameter ioParam){		
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		try {
			String rcvData = (String)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			con = JDBCConnectionPool.getConnection();
			// �׷�(SEOL)
			String sql = new StringBuilder()
					.append("SELECT\n")
					.append("	censor_type	\n")
					.append("FROM											\n")
					.append("	haccp_censor_info 							\n")
					.append("GROUP BY censor_type 							\n")
					.append("HAVING censor_type IN ("+rcvData+")			\n")
					.toString();
		
			resultString = super.excuteQueryString(con, sql.toString());
		} catch(Exception e) {
			LoggingWriter.setLogError("M000S010000E807()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
		} finally {
			try {
				if (con != null) con.close();
			} catch (Exception e) {
				LoggingWriter.setLogError("M000S010000E807()","==== finally ===="+ e.getMessage());
			}
		}
		ioParam.setResultString(resultString);
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
		ioParam.setMessage(MessageDefine.M_QUERY_OK);
		return EventDefine.E_QUERY_RESULT;
	}

	// ccp ������ġ ��� haccp_censor_info
	public int E808(InoutParameter ioParam){		
		resultInt = EventDefine.E_DOEXCUTE_INIT;
		try {
			String rcvData = (String)((ioParam.getInputHashObject()).get("rcvData", HashObject.YES));
			con = JDBCConnectionPool.getConnection();
			// �׷�(SEOL)
			String sql = new StringBuilder()
					.append("SELECT\n")
					.append("	censor_location \n")
					.append("FROM												     \n")
					.append("	haccp_censor_info a								   	 \n")
					.append("WHERE a.censor_rev_no = (SELECT MAX(censor_rev_no) FROM \n")
					.append("	 				   	 haccp_censor_info b WHERE 	   	 \n")
					.append("                        a.censor_no = b.censor_no)	     \n")
					.append("GROUP BY censor_location 							     \n")
					.append("HAVING MAX(censor_type) IN ("+rcvData+")				 \n")
					.append("ORDER BY censor_no 									 \n")
					.toString();
		
			resultString = super.excuteQueryString(con, sql.toString());
		} catch(Exception e) {
			LoggingWriter.setLogError("M000S010000E808()","==== SQL ERROR ===="+ e.getMessage());
			return EventDefine.E_DOEXCUTE_ERROR ;
		} finally {
			try {
				if (con != null) con.close();
			} catch (Exception e) {
				LoggingWriter.setLogError("M000S010000E808()","==== finally ===="+ e.getMessage());
			}
		}
		ioParam.setResultString(resultString);
		ioParam.setColumnCount("" + super.COLUMN_COUNT);
		ioParam.setMessage(MessageDefine.M_QUERY_OK);
		return EventDefine.E_QUERY_RESULT;
	}
}