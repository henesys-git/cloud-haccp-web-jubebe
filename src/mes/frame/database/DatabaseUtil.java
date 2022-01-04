package mes.frame.database;

import java.sql.*;
import java.util.*;

import org.apache.log4j.Logger;

import java.text.*;

public class DatabaseUtil {
	
	static final Logger logger = Logger.getLogger(DatabaseUtil.class.getName());
	
	private String dbDriver = "oracle.jdbc.OracleDriver";
	private String dbJDBC = "jdbc:oracle:thin:@localhost:1521:orcl11g";
	private String dbUserID = "scott";
	private String dbUserPassword = "Doyosae1";

	Statement stat = null;
	ResultSet rs = null;
	
	// SQL
	int resultValue = 0;
	Vector resultVector = null;
	int actCount = 0;
	
	boolean debug = false;

	public static void main(String args[]) throws Exception {
		DatabaseUtil database = new DatabaseUtil();
		Connection con = JDBCConnectionPool.getConnection();
		//Vector tv = database.doQuery(con, "select * from partlist");
		Vector tv = database.doQuery(con, "select  USER_ID ,PWD ,USER_NAME ,HPNO ,EMAIL from AS_USER au where USER_ID='doyosae' and PWD='doyosae1'" );
		logger.debug("tv.size()===>"+tv.size());
		for (int i=0; i<tv.size(); i++) {
			Vector tmp = (Vector)(tv.elementAt(i));
			for (int m=0; m<tmp.size(); m++) {
				System.out.print( tmp.elementAt(m).toString() + "\t");
			}
			System.out.print( "\n" );
		}
		logger.debug("H-SIZE=" + tv.size());
	}

	public void dbTest(Connection con, String SQL) {
		logger.debug("Connection222="+ con);
		Vector tv = this.doQuery(con, SQL);
		for (int i=0; i<tv.size(); i++) {
			Vector tmp = (Vector)(tv.elementAt(i));
			for (int m=0; m<tmp.size(); m++) {
				System.out.print( (String)(tmp.elementAt(m)) + "\t");
			}
			System.out.print( "\n" );
		}
		logger.debug("H-SIZE=" + tv.size());
	}

	public Connection getConnection() {
		Connection con = null;
		try {
			Class.forName( dbDriver); 
			con = DriverManager.getConnection(dbJDBC, dbUserID, dbUserPassword);
			con.setAutoCommit(true);
		} catch (Exception ex) {
			logger.debug(" Database.getConnection() : " + ex.getMessage());
		}
		logger.debug("Connection="+ con);
		return con;
	}

	public void closeConnection(Connection con) {
		try {
			con.close();
		} catch (SQLException se) {
			logger.debug(se);
		}
	}

	public Vector doQuery(Connection con, String query) {
		if (debug) logger.debug("[doQuery]="+query);
		boolean colCount = true;
		int colSize = 0;
		resultValue = 0;
		Vector table = new Vector();

		try {
			stat = con.createStatement();
			rs = stat.executeQuery(query);
			colSize = rs.getMetaData().getColumnCount();

			while ( rs.next() ) {
				Vector row = new Vector();
				for (int i=0; i<colSize; i++) {
					String rsStr ="";
					try {
						rsStr = (new String((rs.getString(i+1)).getBytes(), "EUC_KR"));
					} catch(Exception ext) {
						// rsStr = "null";		    
						rsStr = "";		    
					}
					if (rsStr.equals("null")) rsStr = "";
					row.addElement (rsStr);
				}

				table.addElement(row);
			}
			stat.close();
			rs.close();
		} catch ( Exception ex ) {
			resultValue = -1;
			logger.debug("DB Query Execution error : " + ex + "\n" + query);
		}
		return table;
	}

	public Vector doQueryWithColumn(Connection con, String query) {
		if (debug) logger.debug("[doQuery]="+query);
		int colSize = 0;
		resultValue = 0;
		Vector table = new Vector();

		try {
			stat = con.createStatement();
			rs = stat.executeQuery(query);
			colSize = rs.getMetaData().getColumnCount();
			Vector columnNames = new Vector();
			for (int i=0; i<colSize; i++) {
				columnNames.add( rs.getMetaData().getColumnLabel(i+1) );
			}
			table.addElement(columnNames);

			while ( rs.next() ) {
				Vector row = new Vector();
				for (int i=0; i<colSize; i++) {
					String rsStr ="";
					try {
						rsStr = (new String((rs.getString(i+1)).getBytes(), "EUC_KR"));
					} catch(Exception ext) {
						rsStr = "null";		    
					}
					if (rsStr.equals("null")) rsStr = "";
					row.addElement (rsStr);
				}
				
				table.addElement(row);
			}
			stat.close();
			rs.close();
		} catch ( Exception ex ) {
			resultValue = -1;
			logger.debug("DB Query Execution error : " + ex + "\n" + query);
		}
		return table;
	}

	public int doUpdate(Connection con, String query) {
		if (debug) logger.debug("[doUpdate]="+query);
		resultValue = 0;
		
		try {
			stat = con.createStatement();
			actCount = stat.executeUpdate(query);
			stat.close();
		} catch ( Exception ex ) {
			resultValue = -1;	
			logger.debug("DB Update Execution error : " + ex + "\n" + query);
		}

		return resultValue;
	}

	public Vector getSingleVector(Connection con, String query) {
		if (debug) logger.debug("[getSigleVector]="+query);
		Vector table = new Vector();
		resultValue = 0;
		
		try {
			stat = con.createStatement();
			rs = stat.executeQuery(query);
			while ( rs.next() ) {
				table.addElement ( (rs.getString(1)).trim() );
			}
			stat.close();
		} catch ( Exception ex ) {
			resultValue = -1;
			logger.debug("DB Execution error : " + ex + "\n" + query);
		}

		return table;
	}

	public String getColumnValue(Connection con, String query) {
		if (debug) logger.debug("[getColumnValue]=" +query);
		String retValue = "";

		Vector temp = getSingleVector(con, query);
		if (temp.size() > 0) retValue = (String)temp.elementAt(0);
		return retValue;
	}
	
	public int getColumnValueInt(Connection con, String query) {
		int retValue = -1;

		Vector temp = getSingleVector(con, query);
		if (temp.size() > 0) {
			try {
				retValue = Integer.parseInt((String)temp.elementAt(0));
			} catch (Exception e) {
				retValue = -1;
			}
		}
		return retValue;
	}
	
	public void startTransaction(Connection con) {
		if (null == con) return;
		try {
			con.setAutoCommit(false);
		} catch (Exception e) {
		}
	}

	public void rollback(Connection con) {
		try {
			con.rollback();
		} catch (SQLException e) {}
		try {
			con.setAutoCommit(true);
		} catch (SQLException e) {}
	}
	
	public void commit(Connection con) {
		try {
			con.commit();
		} catch (SQLException e) {}
		try {
			con.setAutoCommit(true);
		} catch (SQLException e) {}
	}
	
	public int getResultValue() {
		return resultValue; 
	}
	public int getActCount() {
		return actCount;
	}
	public String getDbDate() {
		Calendar       date    = Calendar.getInstance();
		DecimalFormat  dfYYYY  = new DecimalFormat("0000");
		DecimalFormat  dfMD    = new DecimalFormat("00");
		return (dfYYYY.format(date.get(Calendar.YEAR)) + 
				dfMD.format(date.get(Calendar.MONTH)+1) + 
				dfMD.format(date.get(Calendar.DAY_OF_MONTH)) );
	}
	public String getDbTime() {
		Calendar date = Calendar.getInstance();
		DecimalFormat df = new DecimalFormat("00");
		return (df.format(date.get(Calendar.HOUR_OF_DAY)) + 
				df.format(date.get(Calendar.MINUTE)) + 
				df.format(date.get(Calendar.SECOND) ) );
	}
	public String getDbDate(boolean gbn) {
		String retStr = "";
		Calendar       date    = Calendar.getInstance();
		DecimalFormat  dfYYYY  = new DecimalFormat("0000");
		DecimalFormat  dfMD    = new DecimalFormat("00");
		if (gbn) {
			retStr = dfYYYY.format(date.get(Calendar.YEAR)) + "." + 
					dfMD.format(date.get(Calendar.MONTH)+1) + "." + 
					dfMD.format(date.get(Calendar.DAY_OF_MONTH));
		} else {
			retStr = dfYYYY.format(date.get(Calendar.YEAR)) +  
					dfMD.format(date.get(Calendar.MONTH)+1) +  
					dfMD.format(date.get(Calendar.DAY_OF_MONTH));
		}
		return retStr;
	}
	public String getDbTime(boolean gbn) {
		String retStr = "";
		Calendar date = Calendar.getInstance();
		DecimalFormat df = new DecimalFormat("00");
		if (gbn) {
			retStr = df.format(date.get(Calendar.HOUR_OF_DAY)) + ":" + 
					df.format(date.get(Calendar.MINUTE)) + ":" +
					df.format(date.get(Calendar.SECOND));
		} else {
			retStr = df.format(date.get(Calendar.HOUR_OF_DAY)) +  
					df.format(date.get(Calendar.MINUTE)) + 
					df.format(date.get(Calendar.SECOND));
		}
		return retStr;
	}
}

