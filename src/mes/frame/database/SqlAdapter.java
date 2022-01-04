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
	
	/** 마지막 sql 문을 수행할때, 상속받는 class에서 정의한다.*/
	protected abstract int doExcute(InoutParameter ioParam);
	/** 사용자가 정의해야할 파라메타 검증 및 배열에 담을때 */
	protected abstract int custParamCheck(InoutParameter ioParam,StringBuffer p_sql);
	
	/**
	* 정의 : 입력파라메타가 2차배열 구조로 들어올때 파라메터검증하고 2차배열로 리턴한다.
	* @param  ioParam,sql문
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
	* 정의 : 입력파라메타가 없는 query문 을 실행하고 결과값을 벡터로 리턴한다.
	* @param  ioParam, sql문, p_boolPageFlag(페이지 나눌것인가 결정하는 값)
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
	* 정의 : 입력파라메타가 2차배열구조로 query문을 실행하고 결과값을 벡터로 리턴한다.
	* @param  ioParam,sql문, p_boolPageFlag(페이지 나눌것인가 결정하는 값),param
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
	* 정의 : update,insert,delete 문을 실행하고 숫자로 결과값을 리턴한다. 입력파라메터가 2차배열
	* @param  con , ioParam , p_strSql , param
	* @return the desired integer. 성공하면 등록,수정,삭제된 레코드 숫자, 실패하면 -1
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
     * Update, Insert, Delete 등의 Query 문을 수행하는 Method
     * @param  p_vtSql Database query statment
     * @return  int >= 0:success(#i), == -1:fail
     * @exception  None
     */
    public int excuteUpdate(Connection con, Vector p_vtSql) {
        int l_nResult = -1;

        // 파라메터 에러 검증
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

        // 각종 리소스 닫는 블럭
        try {
            if (null != l_dbStatement) l_dbStatement.close();
  			logger.debug("Statement Close");
        } catch (Exception e) {
        }

        return l_nResult;
    }

    public int excuteUpdate(Connection con, String p_Sql) {
        int l_nResult = -1;

        // 파라메터 에러 검증
        if (null == p_Sql || p_Sql.length() <= 0) return l_nResult;

        Statement l_dbStatement = null;
        try {
           // Get Database Statement
           l_dbStatement = con.createStatement();

           logger.debug("SQL : \n\n" + p_Sql + "\n");
           l_nResult = l_dbStatement.executeUpdate(p_Sql);
        } catch(Exception e) {

        }

        // 각종 리소스 닫는 블럭
        try {
            if (null != l_dbStatement) l_dbStatement.close();
  			logger.debug("Statement Close");
        } catch (Exception e) {
        
        }

        return l_nResult;
    }

	 /**
     * 데이터베이스에서 취득한 레코드를 가지고 결과 벡터를 생성하는 메소드.
     * @param p_dbResultSet ResultSet (데이터베이스로 부터 취득한 레코드셋)
     * @param p_boolPageFlag boolean (페이지 지정 유무)
     * @return Vector (결과 벡터)
     */
    protected Vector extractResult(ResultSet p_dbResultSet, boolean p_boolPageFlag) {
		/**
		* ResultSet Meta 정보 얻어오기
		* -. colTypes[]의 index 0는 사용하지 않음.
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

		/** Result Set에서 데이터 꺼내서 벡터에 삽입하기 */
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
						case Types.LONGVARCHAR : // DataType이 LONG 인 경우 : LONGVARCHAR
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

						case Types.CHAR :	// Enumeration Type 인 경우
							l_strTemp = p_dbResultSet.getString(l_nCoumnCnt);
							break;

						case Types.CLOB :	// CLOB Type 인 경우
							l_dbClob = p_dbResultSet.getClob(l_nCoumnCnt);
							l_strTemp = l_dbClob.getSubString( (long) 1, (int) l_dbClob.length() );
							break;

						default :
							l_strTemp = l_arColumnTypes[l_nCoumnCnt]+":UNKNOWN";
							break;
					}

					// REQ_PAGE 때 ROWNUM을 return 칼럼으로 넘기지 않기 위해 : 2004.12.13
					if( (l_nCoumnCnt == l_nColumnCount) && p_boolPageFlag ) break;

					// TRIM 추가 : 2004.12.11
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
     * 데이터베이스에서 취득한 레코드를 가지고 결과 벡터를 생성하는 메소드.
     * @param p_dbResultSet ResultSet (데이터베이스로 부터 취득한 레코드셋)
     * @return String (결과 String)
     */
    protected String extractResultString(ResultSet p_dbResultSet) {
		/**
		* ResultSet Meta 정보 얻어오기
		* -. colTypes[]의 index 0는 사용하지 않음.
		*/
		ResultSetMetaData l_rsmdMetaData = null;
		int rowCount = 0;
		int l_nColumnCount = 0;
		int[] l_arColumnTypes = null;
		// 결과 데이터를 담을 스트링버퍼
		StringBuffer resultStringBuffer = new StringBuffer();
		String resultString = "";
		// 칼럼이름을 담는 벡터 --- 아마도 사용이 안될꺼구먼...
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

		/** Result Set에서 데이터 꺼내서 스트링으로 만든다. */
		//Vector l_vtResultRow = null;
		String l_strTemp = "";
		BigDecimal decimal = null;
		Clob l_dbClob = null;
		int	l_nCoumnCnt = 0;

		try {
			while (p_dbResultSet.next()) {
				for (l_nCoumnCnt = 1; l_nCoumnCnt <= l_nColumnCount; l_nCoumnCnt++) {
					l_strTemp = "";
					// 필드의 값이 널일 경우에는 빈 값을 넣어준다.
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
						case Types.LONGVARCHAR : // DataType이 LONG 인 경우 : LONGVARCHAR
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

						case Types.CHAR :	// Enumeration Type 인 경우
							l_strTemp = p_dbResultSet.getString(l_nCoumnCnt);
							break;

						case Types.CLOB :	// CLOB Type 인 경우
							l_dbClob = p_dbResultSet.getClob(l_nCoumnCnt);
							l_strTemp = l_dbClob.getSubString( (long) 1, (int) l_dbClob.length() );
							break;
							
						case Types.OTHER :	// Cubrid Colletions(LIST)인 경우
							String l_dbArr = Arrays.toString((Object[]) p_dbResultSet.getObject(l_nCoumnCnt));
							l_strTemp = l_dbArr;
							
						default :
							//l_strTemp = l_arColumnTypes[l_nCoumnCnt]+":UNKNOWN";
							break;
					}

					// 클라이언트에서 탭으로 토큰을 나눌 때 중간 값이 없으면 정상적으로 처리되지 않으므로 스페이스를 넣어준다.
					// 반면 클라이언트에서는 스페이스를 트림하게 된다.
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
     * 데이터베이스에서 취득한 레코드를 가지고 결과 벡터를 생성하는 메소드.
     * @param p_dbResultSet ResultSet (데이터베이스로 부터 취득한 레코드셋)
     * @return String (결과 String)
     */
    protected String extractResultStringTableFieldName(ResultSet p_dbResultSet) {
		/**
		* ResultSet Meta 정보 얻어오기
		* -. colTypes[]의 index 0는 사용하지 않음.
		*/
		ResultSetMetaData l_rsmdMetaData = null;
//		이번에 doQueryTableFieldName을 EDMS에 사용할라꼬 이넘 만(0->1)을 변경한다. 2018.06.26 지노가...ㅎㅎ
		int rowCount = 1;
		int l_nColumnCount = 0;
		int[] l_arColumnTypes = null;
		// 결과 데이터를 담을 스트링버퍼
		StringBuffer resultStringBuffer = new StringBuffer();
		String resultString = "";
		// 칼럼이름을 담는 벡터 --- 아마도 사용이 안될꺼구먼...
//		이번에 doQueryTableFieldName을 EDMS에 사용할라꼬 이넘(l_stColumnName)을 변경한다. 2018.06.26 지노가...ㅎㅎ
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

		/** Result Set에서 데이터 꺼내서 스트링으로 만든다. */
		//Vector l_vtResultRow = null;
		String l_strTemp = "";
		BigDecimal decimal = null;
		Clob l_dbClob = null;
		int	l_nCoumnCnt = 0;

		try {
			while (p_dbResultSet.next()) {
				for (l_nCoumnCnt = 1; l_nCoumnCnt <= l_nColumnCount; l_nCoumnCnt++) {
					l_strTemp = "";
					// 필드의 값이 널일 경우에는 빈 값을 넣어준다.
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
						case Types.LONGVARCHAR : // DataType이 LONG 인 경우 : LONGVARCHAR
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

						case Types.CHAR :	// Enumeration Type 인 경우
							l_strTemp = p_dbResultSet.getString(l_nCoumnCnt);
							break;

						case Types.CLOB :	// CLOB Type 인 경우
							l_dbClob = p_dbResultSet.getClob(l_nCoumnCnt);
							l_strTemp = l_dbClob.getSubString( (long) 1, (int) l_dbClob.length() );
							break;

						default :
							l_strTemp = l_arColumnTypes[l_nCoumnCnt]+":UNKNOWN";
							break;
					}

					// 클라이언트에서 탭으로 토큰을 나눌 때 중간 값이 없으면 정상적으로 처리되지 않으므로 스페이스를 넣어준다.
					// 반면 클라이언트에서는 스페이스를 트림하게 된다.
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
		// 이번에 doQueryTableFieldName을 EDMS에 사용할라꼬 이넘(l_stColumnName)을 추가한다. 2018.06.26 지노가...ㅎㅎ
		return l_stColumnName + resultStringBuffer.toString(); //l_stColumnName 
	}   
    
	 /**
     * 데이터베이스에서 취득한 레코드를 가지고 결과 벡터를 생성하는 메소드.
     * @param p_dbResultSet ResultSet (데이터베이스로 부터 취득한 레코드셋)
     * @return String (결과 String)
     */
    protected String extractResultFile(ResultSet p_dbResultSet) {
		/**
		* ResultSet Meta 정보 얻어오기
		* -. colTypes[]의 index 0는 사용하지 않음.
		*/
		ResultSetMetaData l_rsmdMetaData = null;
		int rowCount = 0;
		int l_nColumnCount = 0;
		int[] l_arColumnTypes = null;
		// 결과 데이터를 담을 스트링버퍼
		StringBuffer resultStringBuffer = new StringBuffer();
		String resultString = "";
		// 칼럼이름을 담는 벡터 --- 아마도 사용이 안될꺼구먼...
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

		/** Result Set에서 데이터 꺼내서 스트링으로 만든다. */
		//Vector l_vtResultRow = null;
		String l_strTemp = "";
		BigDecimal decimal = null;
		Clob l_dbClob = null;
		int	l_nCoumnCnt = 0;

		try {
			while (p_dbResultSet.next()) {
				for (l_nCoumnCnt = 1; l_nCoumnCnt <= l_nColumnCount; l_nCoumnCnt++) {
					l_strTemp = "";
					// 필드의 값이 널일 경우에는 빈 값을 넣어준다.
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
						case Types.LONGVARCHAR : // DataType이 LONG 인 경우 : LONGVARCHAR
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

						case Types.CHAR :	// Enumeration Type 인 경우
							l_strTemp = p_dbResultSet.getString(l_nCoumnCnt);
							break;

						case Types.CLOB :	// CLOB Type 인 경우
							l_dbClob = p_dbResultSet.getClob(l_nCoumnCnt);
							l_strTemp = l_dbClob.getSubString( (long) 1, (int) l_dbClob.length() );
							break;

						default :
							l_strTemp = l_arColumnTypes[l_nCoumnCnt]+":UNKNOWN";
							break;
					}

					// 클라이언트에서 탭으로 토큰을 나눌 때 중간 값이 없으면 정상적으로 처리되지 않으므로 스페이스를 넣어준다.
					// 반면 클라이언트에서는 스페이스를 트림하게 된다.
					if ("".equals(l_strTemp)) l_strTemp = " ";
					// enter가 들어가면 다음행으로 인식되므로..공백으로 처리한다.(엑셀로드시)
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
	* 레코드 수를 산출한다.
	* @return  레코드 수
	*/
	public int getRowCount() {
		int l_nResult = 0;
		
		return l_nResult;
	}
	
	// 트랙잭션 시작 
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

	// 트랙잭션 커밋
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

	// 트랙잭션 롤백
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
