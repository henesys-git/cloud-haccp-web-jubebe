package mes.frame.database;

import java.math.BigDecimal;
import java.sql.Clob;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Types;
import java.util.Arrays;
import java.util.Vector;

import org.apache.log4j.Logger;

import mes.frame.common.EventDefine;
import mes.frame.serviceinterface.InoutParameter;
import mes.frame.util.CommonFunction;

public abstract class SqlAdapter {
	
	static final Logger logger = Logger.getLogger(SqlAdapter.class.getName());
	
	public int COLUMN_COUNT = 0;
	
	public SqlAdapter(){
	}
	
	/** ������ sql ���� �����Ҷ�, ��ӹ޴� class���� �����Ѵ�.*/
	protected abstract int doExcute(InoutParameter ioParam);
	/** ����ڰ� �����ؾ��� �Ķ��Ÿ ���� �� �迭�� ������ */
	protected abstract int custParamCheck(InoutParameter ioParam,StringBuffer p_sql);
	
	/**
	* ���� : �Է��Ķ��Ÿ�� 2���迭 ������ ���ö� �Ķ���Ͱ����ϰ� 2���迭�� �����Ѵ�.
	* @param  ioParam,sql��
	* @return the desired String[][]
	* @exception  Exception
	*/
	protected String[][] getParamCheck(InoutParameter ioParam, StringBuffer p_sql) {
		String[][] v_paramArray = ioParam.getInputArray();
		
		int paramRowSize = 0;
		int paramColSize = 0;
		String v_param = "";
		if (v_paramArray != null) {
			try {
				paramRowSize = v_paramArray.length;
				paramColSize = v_paramArray[0].length;
				
				logger.debug("Parameter Row Size=" + paramRowSize + ": Col Size=" + paramColSize);
			
				for(int j=0; j < paramRowSize ; j++){
					v_param = "";
					for(int h=0; h < paramColSize; h++){
						v_param += "[ " + v_paramArray[j][h].trim() + " ]";
					}
					logger.debug("Parameter : " + v_param);
				}
			} catch(Exception e) {
				logger.error("No Parameters");
			}
			
			int paramCount = CommonFunction.getParamCount(p_sql);
			
			if(paramCount != paramColSize){
				logger.error("Number of Parameters not matched : " + p_sql);
			}
		} else {
			logger.error("No Parameters");
		}
		
		return v_paramArray;
	}
	/**
	* ���� : �Է��Ķ��Ÿ�� ���� query�� �� �����ϰ� ������� ���ͷ� �����Ѵ�.
	* @param  ioParam, sql��, p_boolPageFlag(������ �������ΰ� �����ϴ� ��)
	* @return the desired Vector
	* @exception  SQLException,Exception
	*/
	protected Vector excuteQuery(Connection con, String p_strSql, boolean p_boolPageFlag){

		logger.debug("SELECT SQL : \n\n" + p_strSql +";\n");
		
		ResultSet l_rsResult = null;
		Vector l_vtResult = null;

		if (null == p_strSql || p_strSql.length() <= 0)
			return l_vtResult;

		PreparedStatement l_dbPrepareStatement = null;
		
		try{
			l_dbPrepareStatement = con.prepareStatement(p_strSql, ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
			l_dbPrepareStatement.clearParameters();
			l_rsResult = l_dbPrepareStatement.executeQuery();
		
			if (null != l_rsResult) {
				l_vtResult = extractResult(l_rsResult, p_boolPageFlag);
			}
		} catch (SQLException e) {
			logger.error("SELECT SQL ERROR : \n" + e.getMessage());

			l_vtResult = null;
		}

		try {
			if (null != l_dbPrepareStatement) l_dbPrepareStatement.close();
			if (null != l_rsResult) l_rsResult.close();
			logger.debug("Statement, ResultSet Close");
		} catch (Exception e) {
			logger.error("Start Statement, ResultSet Close ERROR : " + e.getMessage());
		}
		
		return l_vtResult;
	}
	
	protected String excuteQueryString(Connection con, String p_strSql) {
		
		logger.debug("SELECT SQL : \n\n" + p_strSql +";\n");
		
		ResultSet l_rsResult = null;
		String resultString = "";

		if (null == p_strSql || p_strSql.length() <= 0) {
			return resultString;
		}

		PreparedStatement l_dbPrepareStatement = null;
		
		try{
			l_dbPrepareStatement = con.prepareStatement(p_strSql, ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
			l_dbPrepareStatement.clearParameters();
			l_rsResult = l_dbPrepareStatement.executeQuery();
			if (null != l_rsResult) {
				resultString = extractResultString(l_rsResult);
			}
		} catch (SQLException e) {
			logger.error("SELECT SQL ERROR : \n" + e.getMessage());
			resultString = null;
		}

		try {
			if (null != l_dbPrepareStatement) l_dbPrepareStatement.close();
			if (null != l_rsResult) l_rsResult.close();
			logger.debug("Statement, ResultSet Close");
		} catch (Exception e) {
			logger.error("Start Statement, ResultSet Close ERROR : " + e.getMessage());
		}
		
		return resultString;
	}
	
	protected String excuteQueryStringTableFieldName(Connection con, String p_strSql) {
		
		logger.debug("SELECT SQL : \n\n" + p_strSql +";\n");
		
		ResultSet l_rsResult = null;
		String resultString = "";

		if (null == p_strSql || p_strSql.length() <= 0) {
			return resultString;
		}

		PreparedStatement l_dbPrepareStatement = null;
		
		try{
			l_dbPrepareStatement = con.prepareStatement(p_strSql, ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
			l_dbPrepareStatement.clearParameters();
			l_rsResult = l_dbPrepareStatement.executeQuery();
		
			if (null != l_rsResult) {
				resultString = extractResultStringTableFieldName(l_rsResult);
			}
		} catch (SQLException e) {
			logger.error("SELECT SQL ERROR : \n" + e.getMessage());
			resultString = null;
		}

		try {
			if (null != l_dbPrepareStatement) l_dbPrepareStatement.close();
			if (null != l_rsResult) l_rsResult.close();
			logger.debug("Statement, ResultSet Close");
		} catch (Exception e) {
			logger.error("Start Statement, ResultSet Close ERROR : " + e.getMessage());
		}
		
		return resultString;
	}	
	protected String excuteQueryFile(Connection con, String p_strSql) {

		logger.debug("SELECT SQL : \n\n" + p_strSql +";\n");
		
		ResultSet l_rsResult = null;
		String resultString = "";

		if (null == p_strSql || p_strSql.length() <= 0) {
			return resultString;
		}

		PreparedStatement l_dbPrepareStatement = null;
		
		try{
			l_dbPrepareStatement = con.prepareStatement(p_strSql, ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
			l_dbPrepareStatement.clearParameters();
			l_rsResult = l_dbPrepareStatement.executeQuery();
		
			if (null != l_rsResult) {
				resultString = extractResultFile(l_rsResult);
			}
		} catch (SQLException e) {
			logger.error("SELECT SQL ERROR : \n" + e.getMessage());
			resultString = null;
		}

		try {
			if (null != l_dbPrepareStatement) l_dbPrepareStatement.close();
			if (null != l_rsResult) l_rsResult.close();
			logger.debug("Statement, ResultSet Close");
		} catch (Exception e) {
			logger.error("Start Statement, ResultSet Close ERROR : " + e.getMessage());
		}
		
		return resultString;
	}
	
	/**
	* ���� : �Է��Ķ��Ÿ�� 2���迭������ query���� �����ϰ� ������� ���ͷ� �����Ѵ�.
	* @param  ioParam,sql��, p_boolPageFlag(������ �������ΰ� �����ϴ� ��),param
	* @return the desired Vector
	* @exception  SQLException,Exception
	*/
	protected Vector excuteQuery(Connection con, String p_strSql, boolean p_boolPageFlag, String[][] param){
		logger.debug("SELECT SQL : \n\n" + p_strSql +";\n");
		
		ResultSet l_rsResult = null;
		Vector l_vtResult = null;

		if (null == p_strSql || p_strSql.length() <= 0) return l_vtResult;

		PreparedStatement l_dbPrepareStatement = null;
		
		try {
			l_dbPrepareStatement = con.prepareStatement(p_strSql, ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);

			if (param == null) {
				l_dbPrepareStatement.clearParameters();
				logger.debug("param " + param);
				
			} else {
				int rowSize = param.length ;
				int colSize = param[0].length ;

				String v_param = "";
				
				for (int i=0; i < rowSize; i++) {
					v_param = "";
					l_dbPrepareStatement.clearParameters();
					for (int j=0; j < colSize; j++) {
						l_dbPrepareStatement.setString(j+1, param[i][j].trim());
						v_param += param[i][j] + ",";
					}
					logger.debug("PARAMETERS (" + v_param + ")");
				}
			}
			
			l_rsResult = l_dbPrepareStatement.executeQuery();
			if (null != l_rsResult) {
				l_vtResult = extractResult(l_rsResult, p_boolPageFlag);
			}
		} catch (SQLException e) {
			logger.error("SELECT SQL ERROR : \n" + e.getMessage());
			l_vtResult = null;
		}

		try {
			if (null != l_dbPrepareStatement) l_dbPrepareStatement.close();
			if (null != l_rsResult) l_rsResult.close();
			logger.debug("Statement, ResultSet Close");
		} catch (Exception e) {
			logger.error("Start Statement, ResultSet Close ERROR : " + e.getMessage());
		}
		//
		return l_vtResult;
	}

	protected String excuteQueryString(Connection con, String p_strSql, boolean p_boolPageFlag, String[][] param){
		logger.debug("SELECT SQL : \n\n" + p_strSql +";\n");
		
		ResultSet l_rsResult = null;
		String resultString = "";

		if (null == p_strSql || p_strSql.length() <= 0) return resultString;

		PreparedStatement l_dbPrepareStatement = null;
		
		try {
			l_dbPrepareStatement = con.prepareStatement(p_strSql, ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);

			if (param == null) {
				l_dbPrepareStatement.clearParameters();
			} else {
				int rowSize = param.length ;
				int colSize = param[0].length ;

				String v_param = "";
				
				for (int i=0; i < rowSize; i++) {
					v_param = "";
					l_dbPrepareStatement.clearParameters();
					for (int j=0; j < colSize; j++) {
						l_dbPrepareStatement.setString(j+1, param[i][j].trim());
						v_param += param[i][j] + ",";
					}
					logger.debug("PARAMETERS (" + v_param + ")");
				}
			}
			
			l_rsResult = l_dbPrepareStatement.executeQuery();
			if (null != l_rsResult) {
				resultString = extractResultString(l_rsResult);
			}
		} catch (SQLException e) {
			logger.error("SELECT SQL ERROR : \n" + e.getMessage());
			resultString = "";
		}

		try {
			if (null != l_dbPrepareStatement) l_dbPrepareStatement.close();
			if (null != l_rsResult) l_rsResult.close();
			logger.debug("Statement, ResultSet Close");
		} catch (Exception e) {
			logger.error("Start Statement, ResultSet Close ERROR : " + e.getMessage());
		}
		//
		return resultString;
	}

	/**
	* ���� : update,insert,delete ���� �����ϰ� ���ڷ� ������� �����Ѵ�. �Է��Ķ���Ͱ� 2���迭
	* @param  con , ioParam , p_strSql , param
	* @return the desired integer. �����ϸ� ���,����,������ ���ڵ� ����, �����ϸ� -1
	* @exception  SQLException,Exception
	*/
	public int excuteUpdate(Connection con, String p_strSql, String[][] param) {
		int l_nResult =0;
		logger.debug("EXCUTE SQL : " + p_strSql + ";");
		
		if (null == p_strSql || p_strSql.length() <= 0) return EventDefine.E_SQL_ERROR;;

		PreparedStatement l_dbPrepareStatement = null;
		try {
			l_dbPrepareStatement = con.prepareStatement(p_strSql);
			
			int rowSize = param.length ;
			int colSize = param[0].length ;
			String v_param = "";
			for (int i=0; i < rowSize; i++) {
				v_param = "";
				l_dbPrepareStatement.clearParameters();
				for (int j=0; j < colSize; j++) {
					l_dbPrepareStatement.setString(j+1, param[i][j].trim());
					v_param += param[i][j] + ",";
				}
				l_nResult += l_dbPrepareStatement.executeUpdate();
			}
		} catch (SQLException e) {
			logger.error("EXCUTE SQL ERROR : " + e.getMessage());
			l_nResult = EventDefine.E_DOEXCUTE_ERROR;
		} catch (Exception ex) {
			logger.error("Parameter ERROR : " + ex.getMessage());
			l_nResult = EventDefine.E_DOEXCUTE_ERROR;
		}
		try{
			if (null != l_dbPrepareStatement) l_dbPrepareStatement.close();
			logger.debug("Statement Close");
		} catch (Exception e) {
			logger.error("Statement Close ERROR : " + e.getMessage());
		}
		return l_nResult;
	}

    /**
     * Update, Insert, Delete ���� Query ���� �����ϴ� Method
     * @param  p_vtSql Database query statment
     * @return  int >= 0:success(#i), == -1:fail
     * @exception  None
     */
    public int excuteUpdate(Connection con, Vector p_vtSql) {
        int l_nResult = -1;

        // �Ķ���� ���� ����
        if (null == p_vtSql || p_vtSql.size() <= 0) return l_nResult;

        Statement l_dbStatement = null;

        try {
           // Get Database Statement
           l_dbStatement = con.createStatement();

           String	l_strSql = "";
           for (int i=0; i<p_vtSql.size(); i++) {
           		l_strSql = (String) p_vtSql.get(i); 
           		l_nResult += l_dbStatement.executeUpdate(l_strSql);
           }
        } catch(Exception e) {
        }

        // ���� ���ҽ� �ݴ� ��
        try {
            if (null != l_dbStatement) l_dbStatement.close();
  			logger.debug("Statement Close");
        } catch (Exception e) {
        }

        return l_nResult;
    }

    public int excuteUpdate(Connection con, String p_Sql) {
        int l_nResult = -1;

        // �Ķ���� ���� ����
        if (null == p_Sql || p_Sql.length() <= 0) return l_nResult;

        Statement l_dbStatement = null;
        try {
           // Get Database Statement
           l_dbStatement = con.createStatement();

           logger.debug("SQL : \n\n" + p_Sql + "\n");
           l_nResult = l_dbStatement.executeUpdate(p_Sql);
        } catch(Exception e) {

        }

        // ���� ���ҽ� �ݴ� ��
        try {
            if (null != l_dbStatement) l_dbStatement.close();
  			logger.debug("Statement Close");
        } catch (Exception e) {
        
        }

        return l_nResult;
    }

	 /**
     * �����ͺ��̽����� ����� ���ڵ带 ������ ��� ���͸� �����ϴ� �޼ҵ�.
     * @param p_dbResultSet ResultSet (�����ͺ��̽��� ���� ����� ���ڵ��)
     * @param p_boolPageFlag boolean (������ ���� ����)
     * @return Vector (��� ����)
     */
    protected Vector extractResult(ResultSet p_dbResultSet, boolean p_boolPageFlag) {
		/**
		* ResultSet Meta ���� ������
		* -. colTypes[]�� index 0�� ������� ����.
		*/
		ResultSetMetaData l_rsmdMetaData = null;
		int l_nColumnCount = 0;
		int[] l_arColumnTypes = null;
		Vector l_vtResultTable = new Vector();
		Vector l_vtColumnName = new Vector();

		try {
			l_rsmdMetaData = p_dbResultSet.getMetaData();
			l_nColumnCount = l_rsmdMetaData.getColumnCount();
			l_arColumnTypes = new int[l_nColumnCount+1];
			for (int i=1; i <= l_nColumnCount; i++) {
				l_arColumnTypes[i] = l_rsmdMetaData.getColumnType(i);
				l_vtColumnName.addElement( l_rsmdMetaData.getColumnName(i) );
			}
		} catch (Exception e) {
			e.printStackTrace();
			return null;
		}

		/** Result Set���� ������ ������ ���Ϳ� �����ϱ� */
		Vector l_vtResultRow = null;
		String l_strTemp = "";
		BigDecimal decimal = null;
		Clob l_dbClob = null;
		int	l_nCoumnCnt = 0;

		try {
			while (p_dbResultSet.next()) {
				l_vtResultRow = new Vector();
				for (l_nCoumnCnt = 1; l_nCoumnCnt <= l_nColumnCount; l_nCoumnCnt++) {
					l_strTemp = "";
					// Check whether the SQL value is null.
					if (null == p_dbResultSet.getObject(l_nCoumnCnt)) {
						l_vtResultRow.addElement(l_strTemp);
						continue ;
					}

					switch (l_arColumnTypes[l_nCoumnCnt]) {
						case Types.SMALLINT :
							l_strTemp = p_dbResultSet.getShort(l_nCoumnCnt) + "";
							break;

						case Types.INTEGER :
							l_strTemp = p_dbResultSet.getLong(l_nCoumnCnt) + "";
							break;
						case Types.NUMERIC :
							l_strTemp = p_dbResultSet.getDouble(l_nCoumnCnt) + "";
							break;

						case Types.DECIMAL :
							decimal = p_dbResultSet.getBigDecimal(l_nCoumnCnt);
							l_strTemp = decimal.floatValue() + "";
							break;

						case Types.BIGINT :
							l_strTemp = p_dbResultSet.getLong(l_nCoumnCnt) + "";
							break;

						case Types.REAL :
							l_strTemp = p_dbResultSet.getFloat(l_nCoumnCnt) + "";
							break;

						case Types.FLOAT :
						case Types.DOUBLE :
							l_strTemp = p_dbResultSet.getDouble(l_nCoumnCnt) + "";
							break;

						case Types.VARCHAR :
						case Types.LONGVARCHAR : // DataType�� LONG �� ��� : LONGVARCHAR
							l_strTemp = p_dbResultSet.getString(l_nCoumnCnt);
							break;

						case Types.DATE :
							l_strTemp = p_dbResultSet.getDate(l_nCoumnCnt).toString();
							break;

						case Types.TIME :
							l_strTemp = p_dbResultSet.getTime(l_nCoumnCnt).toString();
							break;

						case Types.TIMESTAMP :
							l_strTemp = p_dbResultSet.getTimestamp(l_nCoumnCnt).toString();
							break;

						case Types.CHAR :	// Enumeration Type �� ���
							l_strTemp = p_dbResultSet.getString(l_nCoumnCnt);
							break;

						case Types.CLOB :	// CLOB Type �� ���
							l_dbClob = p_dbResultSet.getClob(l_nCoumnCnt);
							l_strTemp = l_dbClob.getSubString( (long) 1, (int) l_dbClob.length() );
							break;

						default :
							l_strTemp = l_arColumnTypes[l_nCoumnCnt]+":UNKNOWN";
							break;
					}

					// REQ_PAGE �� ROWNUM�� return Į������ �ѱ��� �ʱ� ���� : 2004.12.13
					if( (l_nCoumnCnt == l_nColumnCount) && p_boolPageFlag ) break;

					// TRIM �߰� : 2004.12.11
					l_vtResultRow.addElement(l_strTemp.trim());

				} // END-FOR

				l_vtResultTable.addElement(l_vtResultRow);

			} // END-WHILE
		} catch(Exception e) {
			logger.error("ExtractResult Make Error = " + e.getMessage());
			l_vtResultTable = null;
			e.printStackTrace();
		}

		logger.debug("Query Result Size = " + l_vtResultTable.size() + "");
		return l_vtResultTable;
	}

	 /**
     * �����ͺ��̽����� ����� ���ڵ带 ������ ��� ���͸� �����ϴ� �޼ҵ�.
     * @param p_dbResultSet ResultSet (�����ͺ��̽��� ���� ����� ���ڵ��)
     * @return String (��� String)
     */
    protected String extractResultString(ResultSet p_dbResultSet) {
		/**
		* ResultSet Meta ���� ������
		* -. colTypes[]�� index 0�� ������� ����.
		*/
		ResultSetMetaData l_rsmdMetaData = null;
		int rowCount = 0;
		int l_nColumnCount = 0;
		int[] l_arColumnTypes = null;
		// ��� �����͸� ���� ��Ʈ������
		StringBuffer resultStringBuffer = new StringBuffer();
		String resultString = "";
		// Į���̸��� ��� ���� --- �Ƹ��� ����� �ȵɲ�����...
		Vector l_vtColumnName = new Vector();

		try {
			l_rsmdMetaData = p_dbResultSet.getMetaData();
			l_nColumnCount = l_rsmdMetaData.getColumnCount();
			COLUMN_COUNT = l_nColumnCount;
			l_arColumnTypes = new int[l_nColumnCount+1];
			for (int i=1; i <= l_nColumnCount; i++) {
				l_arColumnTypes[i] = l_rsmdMetaData.getColumnType(i);
				l_vtColumnName.addElement( l_rsmdMetaData.getColumnName(i));
			}
		} catch (Exception e) {
			e.printStackTrace();
			return null;
		}

		/** Result Set���� ������ ������ ��Ʈ������ �����. */
		//Vector l_vtResultRow = null;
		String l_strTemp = "";
		BigDecimal decimal = null;
		Clob l_dbClob = null;
		int	l_nCoumnCnt = 0;

		try {
			while (p_dbResultSet.next()) {
				for (l_nCoumnCnt = 1; l_nCoumnCnt <= l_nColumnCount; l_nCoumnCnt++) {
					l_strTemp = "";
					// �ʵ��� ���� ���� ��쿡�� �� ���� �־��ش�.
					if (null == p_dbResultSet.getObject(l_nCoumnCnt)) {
						resultStringBuffer.append(" \t");
						continue ;
					}

					switch (l_arColumnTypes[l_nCoumnCnt]) {
						case Types.SMALLINT :
							l_strTemp = p_dbResultSet.getShort(l_nCoumnCnt) + "";
							break;

						case Types.INTEGER :
							l_strTemp = p_dbResultSet.getLong(l_nCoumnCnt) + "";
							break;
						case Types.NUMERIC :
							l_strTemp = p_dbResultSet.getDouble(l_nCoumnCnt) + "";
							break;

						case Types.DECIMAL :
							decimal = p_dbResultSet.getBigDecimal(l_nCoumnCnt);
							l_strTemp = decimal.floatValue() + "";
							break;

						case Types.BIGINT :
							l_strTemp = p_dbResultSet.getLong(l_nCoumnCnt) + "";
							break;

						case Types.REAL :
							l_strTemp = p_dbResultSet.getFloat(l_nCoumnCnt) + "";
							break;

						case Types.FLOAT :
						case Types.DOUBLE :
							l_strTemp = p_dbResultSet.getDouble(l_nCoumnCnt) + "";
							break;

						case Types.VARCHAR :
						case Types.LONGVARCHAR : // DataType�� LONG �� ��� : LONGVARCHAR
							l_strTemp = p_dbResultSet.getString(l_nCoumnCnt);
							break;

						case Types.DATE :
							l_strTemp = p_dbResultSet.getDate(l_nCoumnCnt).toString();
							break;

						case Types.TIME :
							l_strTemp = p_dbResultSet.getTime(l_nCoumnCnt).toString();
							break;

						case Types.TIMESTAMP :
							l_strTemp = p_dbResultSet.getTimestamp(l_nCoumnCnt).toString();
							break;

						case Types.CHAR :	// Enumeration Type �� ���
							l_strTemp = p_dbResultSet.getString(l_nCoumnCnt);
							break;

						case Types.CLOB :	// CLOB Type �� ���
							l_dbClob = p_dbResultSet.getClob(l_nCoumnCnt);
							l_strTemp = l_dbClob.getSubString( (long) 1, (int) l_dbClob.length() );
							break;
							
						case Types.OTHER :	// Cubrid Colletions(LIST)�� ���
							String l_dbArr = Arrays.toString((Object[]) p_dbResultSet.getObject(l_nCoumnCnt));
							l_strTemp = l_dbArr;
							
						default :
							//l_strTemp = l_arColumnTypes[l_nCoumnCnt]+":UNKNOWN";
							break;
					}

					// Ŭ���̾�Ʈ���� ������ ��ū�� ���� �� �߰� ���� ������ ���������� ó������ �����Ƿ� �����̽��� �־��ش�.
					// �ݸ� Ŭ���̾�Ʈ������ �����̽��� Ʈ���ϰ� �ȴ�.
					if ("".equals(l_strTemp)) {
						l_strTemp = " ";
					}
					resultStringBuffer.append(l_strTemp + "\t");
				} // END-FOR
				rowCount++;
			} // END-WHILE
		} catch(Exception e) {
			logger.error("ExtractResult Make Error = " + e.getMessage());
			
			resultString = "";
			e.printStackTrace();
		}
		logger.debug("Query Result Size = " + rowCount + "");
		return resultStringBuffer.toString();
	}

        
	 /**
     * �����ͺ��̽����� ����� ���ڵ带 ������ ��� ���͸� �����ϴ� �޼ҵ�.
     * @param p_dbResultSet ResultSet (�����ͺ��̽��� ���� ����� ���ڵ��)
     * @return String (��� String)
     */
    protected String extractResultStringTableFieldName(ResultSet p_dbResultSet) {
		/**
		* ResultSet Meta ���� ������
		* -. colTypes[]�� index 0�� ������� ����.
		*/
		ResultSetMetaData l_rsmdMetaData = null;
//		�̹��� doQueryTableFieldName�� EDMS�� ����Ҷ� �̳� ��(0->1)�� �����Ѵ�. 2018.06.26 ���밡...����
		int rowCount = 1;
		int l_nColumnCount = 0;
		int[] l_arColumnTypes = null;
		// ��� �����͸� ���� ��Ʈ������
		StringBuffer resultStringBuffer = new StringBuffer();
		String resultString = "";
		// Į���̸��� ��� ���� --- �Ƹ��� ����� �ȵɲ�����...
//		�̹��� doQueryTableFieldName�� EDMS�� ����Ҷ� �̳�(l_stColumnName)�� �����Ѵ�. 2018.06.26 ���밡...����
		String l_stColumnName = "";

		try {
			l_rsmdMetaData = p_dbResultSet.getMetaData();
			l_nColumnCount = l_rsmdMetaData.getColumnCount();
			COLUMN_COUNT = l_nColumnCount;
			l_arColumnTypes = new int[l_nColumnCount+1];
			for (int i=1; i <= l_nColumnCount; i++) {
				l_arColumnTypes[i] = l_rsmdMetaData.getColumnType(i);
				l_stColumnName +=  l_rsmdMetaData.getColumnName(i) + "\t";
			}
		} catch (Exception e) {
			e.printStackTrace();
			return null;
		}

		/** Result Set���� ������ ������ ��Ʈ������ �����. */
		//Vector l_vtResultRow = null;
		String l_strTemp = "";
		BigDecimal decimal = null;
		Clob l_dbClob = null;
		int	l_nCoumnCnt = 0;

		try {
			while (p_dbResultSet.next()) {
				for (l_nCoumnCnt = 1; l_nCoumnCnt <= l_nColumnCount; l_nCoumnCnt++) {
					l_strTemp = "";
					// �ʵ��� ���� ���� ��쿡�� �� ���� �־��ش�.
					if (null == p_dbResultSet.getObject(l_nCoumnCnt)) {
						resultStringBuffer.append(" \t");
						continue ;
					}

					switch (l_arColumnTypes[l_nCoumnCnt]) {
						case Types.SMALLINT :
							l_strTemp = p_dbResultSet.getShort(l_nCoumnCnt) + "";
							break;

						case Types.INTEGER :
							l_strTemp = p_dbResultSet.getLong(l_nCoumnCnt) + "";
							break;
						case Types.NUMERIC :
							l_strTemp = p_dbResultSet.getDouble(l_nCoumnCnt) + "";
							break;

						case Types.DECIMAL :
							decimal = p_dbResultSet.getBigDecimal(l_nCoumnCnt);
							l_strTemp = decimal.floatValue() + "";
							break;

						case Types.BIGINT :
							l_strTemp = p_dbResultSet.getLong(l_nCoumnCnt) + "";
							break;

						case Types.REAL :
							l_strTemp = p_dbResultSet.getFloat(l_nCoumnCnt) + "";
							break;

						case Types.FLOAT :
						case Types.DOUBLE :
							l_strTemp = p_dbResultSet.getDouble(l_nCoumnCnt) + "";
							break;

						case Types.VARCHAR :
						case Types.LONGVARCHAR : // DataType�� LONG �� ��� : LONGVARCHAR
							l_strTemp = p_dbResultSet.getString(l_nCoumnCnt);
							break;

						case Types.DATE :
							l_strTemp = p_dbResultSet.getDate(l_nCoumnCnt).toString();
							break;

						case Types.TIME :
							l_strTemp = p_dbResultSet.getTime(l_nCoumnCnt).toString();
							break;

						case Types.TIMESTAMP :
							l_strTemp = p_dbResultSet.getTimestamp(l_nCoumnCnt).toString();
							break;

						case Types.CHAR :	// Enumeration Type �� ���
							l_strTemp = p_dbResultSet.getString(l_nCoumnCnt);
							break;

						case Types.CLOB :	// CLOB Type �� ���
							l_dbClob = p_dbResultSet.getClob(l_nCoumnCnt);
							l_strTemp = l_dbClob.getSubString( (long) 1, (int) l_dbClob.length() );
							break;

						default :
							l_strTemp = l_arColumnTypes[l_nCoumnCnt]+":UNKNOWN";
							break;
					}

					// Ŭ���̾�Ʈ���� ������ ��ū�� ���� �� �߰� ���� ������ ���������� ó������ �����Ƿ� �����̽��� �־��ش�.
					// �ݸ� Ŭ���̾�Ʈ������ �����̽��� Ʈ���ϰ� �ȴ�.
					if ("".equals(l_strTemp)) l_strTemp = " ";
					resultStringBuffer.append(l_strTemp + "\t");
					
				} // END-FOR
				rowCount++;
				
			} // END-WHILE
		} catch(Exception e) {
			logger.error("ExtractResult Make Error = " + e.getMessage());
			resultString = "";
			e.printStackTrace();
		}
		logger.debug("Query Result Size = " + rowCount + "");
		// �̹��� doQueryTableFieldName�� EDMS�� ����Ҷ� �̳�(l_stColumnName)�� �߰��Ѵ�. 2018.06.26 ���밡...����
		return l_stColumnName + resultStringBuffer.toString(); //l_stColumnName 
	}   
    
	 /**
     * �����ͺ��̽����� ����� ���ڵ带 ������ ��� ���͸� �����ϴ� �޼ҵ�.
     * @param p_dbResultSet ResultSet (�����ͺ��̽��� ���� ����� ���ڵ��)
     * @return String (��� String)
     */
    protected String extractResultFile(ResultSet p_dbResultSet) {
		/**
		* ResultSet Meta ���� ������
		* -. colTypes[]�� index 0�� ������� ����.
		*/
		ResultSetMetaData l_rsmdMetaData = null;
		int rowCount = 0;
		int l_nColumnCount = 0;
		int[] l_arColumnTypes = null;
		// ��� �����͸� ���� ��Ʈ������
		StringBuffer resultStringBuffer = new StringBuffer();
		String resultString = "";
		// Į���̸��� ��� ���� --- �Ƹ��� ����� �ȵɲ�����...
		Vector l_vtColumnName = new Vector();

		try {
			l_rsmdMetaData = p_dbResultSet.getMetaData();
			l_nColumnCount = l_rsmdMetaData.getColumnCount();
			COLUMN_COUNT = l_nColumnCount;
			l_arColumnTypes = new int[l_nColumnCount+1];
			for (int i=1; i <= l_nColumnCount; i++) {
				l_arColumnTypes[i] = l_rsmdMetaData.getColumnType(i);
				l_vtColumnName.addElement( l_rsmdMetaData.getColumnName(i) );
			}
		} catch (Exception e) {
			e.printStackTrace();
			return null;
		}

		/** Result Set���� ������ ������ ��Ʈ������ �����. */
		//Vector l_vtResultRow = null;
		String l_strTemp = "";
		BigDecimal decimal = null;
		Clob l_dbClob = null;
		int	l_nCoumnCnt = 0;

		try {
			while (p_dbResultSet.next()) {
				for (l_nCoumnCnt = 1; l_nCoumnCnt <= l_nColumnCount; l_nCoumnCnt++) {
					l_strTemp = "";
					// �ʵ��� ���� ���� ��쿡�� �� ���� �־��ش�.
					if (null == p_dbResultSet.getObject(l_nCoumnCnt)) {
						resultStringBuffer.append(" \t");
						continue ;
					}

					switch (l_arColumnTypes[l_nCoumnCnt]) {
						case Types.SMALLINT :
							l_strTemp = p_dbResultSet.getShort(l_nCoumnCnt) + "";
							break;

						case Types.INTEGER :
							l_strTemp = p_dbResultSet.getLong(l_nCoumnCnt) + "";
							break;
						case Types.NUMERIC :
							l_strTemp = p_dbResultSet.getDouble(l_nCoumnCnt) + "";
							break;

						case Types.DECIMAL :
							decimal = p_dbResultSet.getBigDecimal(l_nCoumnCnt);
							l_strTemp = decimal.floatValue() + "";
							break;

						case Types.BIGINT :
							l_strTemp = p_dbResultSet.getLong(l_nCoumnCnt) + "";
							break;

						case Types.REAL :
							l_strTemp = p_dbResultSet.getFloat(l_nCoumnCnt) + "";
							break;

						case Types.FLOAT :
						case Types.DOUBLE :
							l_strTemp = p_dbResultSet.getDouble(l_nCoumnCnt) + "";
							break;

						case Types.VARCHAR :
						case Types.LONGVARCHAR : // DataType�� LONG �� ��� : LONGVARCHAR
							l_strTemp = p_dbResultSet.getString(l_nCoumnCnt);
							break;

						case Types.DATE :
							l_strTemp = p_dbResultSet.getDate(l_nCoumnCnt).toString();
							break;

						case Types.TIME :
							l_strTemp = p_dbResultSet.getTime(l_nCoumnCnt).toString();
							break;

						case Types.TIMESTAMP :
							l_strTemp = p_dbResultSet.getTimestamp(l_nCoumnCnt).toString();
							break;

						case Types.CHAR :	// Enumeration Type �� ���
							l_strTemp = p_dbResultSet.getString(l_nCoumnCnt);
							break;

						case Types.CLOB :	// CLOB Type �� ���
							l_dbClob = p_dbResultSet.getClob(l_nCoumnCnt);
							l_strTemp = l_dbClob.getSubString( (long) 1, (int) l_dbClob.length() );
							break;

						default :
							l_strTemp = l_arColumnTypes[l_nCoumnCnt]+":UNKNOWN";
							break;
					}

					// Ŭ���̾�Ʈ���� ������ ��ū�� ���� �� �߰� ���� ������ ���������� ó������ �����Ƿ� �����̽��� �־��ش�.
					// �ݸ� Ŭ���̾�Ʈ������ �����̽��� Ʈ���ϰ� �ȴ�.
					if ("".equals(l_strTemp)) l_strTemp = " ";
					// enter�� ���� ���������� �νĵǹǷ�..�������� ó���Ѵ�.(�����ε��)
					l_strTemp = l_strTemp.replaceAll("\n", " ");
					if (l_nCoumnCnt == l_nColumnCount) {
						resultStringBuffer.append(l_strTemp);
					} else {
						resultStringBuffer.append(l_strTemp+"\t");
					}
					
				} // END-FOR
				rowCount++;
				resultStringBuffer.append("\r\n");
				
			} // END-WHILE
		} catch(Exception e) {
			logger.error("ExtractResult Make Error = " + e.getMessage());
			resultString = "";
			e.printStackTrace();
		}
		
		logger.debug("Query Result Size = " + rowCount + "");
		return resultStringBuffer.toString();
	}

    /**
	* ���ڵ� ���� �����Ѵ�.
	* @return  ���ڵ� ��
	*/
	public int getRowCount() {
		int l_nResult = 0;
		
		return l_nResult;
	}
	
	// Ʈ����� ���� 
	public void startTransaction(Connection con) {
		//
		try {
			if (null == con) return;

			con.setAutoCommit(false);

			logger.debug("##################### TRANSACTION - START #########################");
		} catch (Exception e) {
			logger.error("=== Transaction Start Error" + e.getMessage());
		}
	}

	// Ʈ����� Ŀ��
	public void commitTransaction(Connection con) {
		try {
			if (null == con) return;

			con.commit();
			logger.debug("##################### TRANSACTION - COMMIT #########################");
		} catch (Exception e) {
			logger.error("=== Transaction Commit Error" + e.getMessage());
		}

		try {
			con.setAutoCommit(true);
		} catch (Exception e) {
			logger.error("=== Transaction Commit Error" + e.getMessage());
		}
	}

	// Ʈ����� �ѹ�
	public void rollbackTransaction(Connection con) {
		try {
			if (null == con) return;

			con.rollback();

			logger.debug("##################### TRANSACTION - ROLLBACK ######################");
		} catch (Exception e) {
			logger.error("=== Transaction Rollback Error" + e.getMessage());
		}

		try {
			con.setAutoCommit(true);
		} catch (Exception e) {
			logger.error("=== Transaction Rollback Error" + e.getMessage());
		}
	}
}
