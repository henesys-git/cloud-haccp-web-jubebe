package mes.frame.serviceinterface;

import java.io.File;
import java.io.FileOutputStream;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.ResourceBundle;

public class LoggingWriter {
	private static String m_log_level_all	= "NO"; //YES,NO
	private static String m_log_level_debug	= "NO"; //YES,NO
	private static String m_log_level_info	= "NO"; //YES,NO
	private static String m_log_level_sql	= "NO"; //YES,NO
	private static String m_log_level_conn	= "NO"; //YES,NO
	private static String m_class_log		= "NO"; //YES,NO
	private static String m_file_make		= "NO";
	
	// public static String m_strLogPath="/tmp";    // UNIX ¿ë
	public static String m_strLogPath="D:\\";       // WIN ¿ë
	
	public static String m_strLogFile="Log.conf";
	public static String m_nUserId = "";
	
	public static String currentDate = new SimpleDateFormat("yy-MM-dd").format(new java.util.Date());
	
	public void getFilePath(String userId) {
		ResourceBundle  resourceBundle = ResourceBundle.getBundle("Log_conf");
			
		m_nUserId 			= userId;
		m_strLogPath  		= resourceBundle.getString("LOG_FILE_PATH");
		m_strLogFile  		= resourceBundle.getString("LOG_CONF_FILE");
		m_log_level_debug  	= resourceBundle.getString("LOG_LEVEL_DEBUG");
		m_log_level_info 	= resourceBundle.getString("LOG_LEVEL_INFO");
		m_log_level_sql  	= resourceBundle.getString("LOG_LEVEL_SQL");
		m_log_level_conn 	= resourceBundle.getString("LOG_LEVEL_CONN");
		m_class_log  		= resourceBundle.getString("LOG_CLASS_LOG");
		m_file_make  		= resourceBundle.getString("LOG_FILE_MAKE");
		
	}

	public LoggingWriter(String userId){
		getFilePath(userId);
	}
	
	public static void setLogAll(String className,String str) {
		if(m_log_level_all.equals("YES") ) writeLog("ALL  ",className,str);
	}
	
	public static void setLogInfo(String className,String str){
		if(m_log_level_info.equals("YES") ) writeLog("INFO ",className,str);
	}
	
	public static void setLogDebug(String className,String str){
		if(m_log_level_debug.equals("YES")) writeLog("DEBUG",className,str);
	}
	
	public static void setLogConn(String className,String str){
		if(m_log_level_conn.equals("YES")) writeLog("CONN ",className,str);
	}
	
	public static void setLogSql(String className,String str){
		if(m_log_level_sql.equals("YES")) writeLog("SQL  ",className,str);
	}
	
	public static void setLogError(String className,String str){
		writeErrorLog(className,str);
	}
	
	private static void writeLog(String debug , String className,String str){
		if(m_class_log.equals("NO")) className = "";
		System.out.println(debug + " [DATE:" + currentDate + " " + currentTime() + "] : " + m_nUserId + " : " + str + ":" + className);
		
		if(m_file_make.equals("YES")) writeFileLog(debug + " [DATE:" + currentDate + " " + currentTime() + "] : " + m_nUserId + " : " + str + ":" + className + "\n");
	}
	
	private static void writeErrorLog(String className,String str){
		System.out.println("*ERROR" + " [DATE:" + currentDate + " " + currentTime() + "] : " + m_nUserId + " : " + str + ":" + className);
	}
	
	private static void writeFileLog(String str){
		FileOutputStream outFile = null;
		try {
			String fileName = m_strLogPath + m_strLogFile;
			
			File file = new File(fileName);
			outFile = new FileOutputStream(fileName,true);
			if (file.exists()) {
				outFile. write(str.getBytes());
				outFile.flush();
			} else {
				if (!file.createNewFile()) {
					return;
				}
				outFile.write(str.getBytes());
				outFile.flush();
			}
			outFile.close();
		} catch(Exception e){ 
		}
	}
	
	public static String currentTime() {
		String timeStr = "";
		Calendar rightNow = Calendar.getInstance();   
		int hour = rightNow.get(Calendar.HOUR);     
		int min = rightNow.get(Calendar.MINUTE);    
		int sec = rightNow.get(Calendar.SECOND);    
		int ampm = rightNow.get(Calendar.AM_PM);
		String ampmStr = "";
		
		if(ampm==0)
		{
			ampmStr = "AM";
		}
		else 
		{
			ampmStr = "PM";
		}
		
		timeStr = ampmStr + "-" + hour + ":" + min + ":" + sec;
		
		return timeStr;
	} 
	
	public static void main(String[] args) {
	}
}
