package mes.frame.database;

import java.io.*;
import java.sql.*;

import org.apache.log4j.Logger;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;

import mes.client.conf.Config;

public class JDBCConnectionPool {
	
	static final Logger logger = Logger.getLogger(JDBCConnectionPool.class.getName());
    //static private String bizNo = "";
	
	public static Connection getConnection(String bizNo) {
	      Connection conn = null;
	      
	      try {
	           Class.forName("org.mariadb.jdbc.Driver");
	           
	           String url = "jdbc:mariadb://103.60.126.81:3306/" + bizNo;
	           
	           logger.debug("DB URL: " + url);
	           
	           conn = DriverManager.getConnection(url, "root", "henesys0728!");
	           
	           conn.setAutoCommit (true);
	      } catch ( Exception e ) {
	    	   logger.error("DB Connection ERROR : \n" + e.getMessage());
	      }
	      
	      return conn;
	}
	
	public static Connection getConnectionMasterDb() {
	      Connection conn = null;
	      try {
//	    	   String jsonFilePath = Config.sysConfigPath + "SysConfig.conf";
//	   		   logger.debug(jsonFilePath);
//	    	   
//	  		   JSONParser parser = new JSONParser();
//	 		   Object obj = parser.parse(new FileReader(jsonFilePath));
//	  		   JSONObject jsonObject = (JSONObject) obj;
//	  		   String JDBCStr = (String)jsonObject.get("jdbc_zip");
	  		   
	           Class.forName("org.mariadb.jdbc.Driver");
	           conn = DriverManager.getConnection("jdbc:mariadb://103.60.126.81:3306/test", "root", "henesys0728!");
	           conn.setAutoCommit (true);
	      } catch ( Exception e ) {
	    	  logger.error("Master DB Connection ERROR : " + e.getMessage());
	      }
	      return conn;
	}
	
	public static Connection getConnection_Mysql() {
	      Connection conn = null;
	      try {
	   		   String jsonFilePath = Config.sysConfigPath + "SysConfig.conf";
	   		   logger.debug("[Mysql] json file path : " + jsonFilePath);
	    	   
	  		   JSONParser parser = new JSONParser();
	  		   Object obj = parser.parse(new FileReader(jsonFilePath));
	  		   JSONObject jsonObject = (JSONObject) obj;
	  		   
	  		   String JDBCStr = "";
	  		   if(jsonObject.get("jdbc_mysql") == null) {
	  			   logger.debug("[Mysql] 연동 안함");
	  		   } else {
	  			   JDBCStr = (String)jsonObject.get("jdbc_mysql");
	  			 
		           Class.forName("com.mysql.cj.jdbc.Driver");
		           conn = DriverManager.getConnection(JDBCStr);

		  		   logger.debug("[Mysql] JDBC Str : " + JDBCStr.toString());
		  		   
		           conn.setAutoCommit (true) ;
	  		   }
	      } catch ( Exception e ) {
	    	  logger.error("[Mysql] HCP_JDBC_Mysql Connection ERROR : \n" + e.getMessage());
	      }
	      return conn;
	}
	
	public static Connection getConnection_Mysql_Menu() {
	      Connection conn = null;
	      try {
	   		   String jsonFilePath = Config.sysConfigPath + "SysConfig.conf";
	   		   logger.debug("[Mysql_Menu] " + jsonFilePath);
	    	   
	  		   JSONParser parser = new JSONParser();
	  		   Object obj = parser.parse(new FileReader(jsonFilePath));
	  		   JSONObject jsonObject = (JSONObject) obj;
	  		   
	  		   String JDBCStr = "";
	  		   if(jsonObject.get("jdbc_mysql_menu") == null) {
	  			   logger.debug("[Mysql_Menu] 연동 안함");
	  		   } else {
	  			   JDBCStr = (String)jsonObject.get("jdbc_mysql_menu");
	  			 
		           Class.forName("com.mysql.cj.jdbc.Driver");
		           conn = DriverManager.getConnection(JDBCStr);
		           
		           logger.debug("[Mysql_Menu] " + JDBCStr.toString());
		  		   
		           conn.setAutoCommit (true) ;
	  		   }
	      } catch ( Exception e ) {
	    	  logger.error("[Mysql_Menu] HCP_JDBC_Mysql_Menu Connection ERROR : \n" + e.getMessage());
	      }
	      return conn;
	}
	
//	public static void setBizNo(String bizNo) {
//		if(JDBCConnectionPool.bizNo == "") {
//			JDBCConnectionPool.bizNo = bizNo;
//		}
//	}
}