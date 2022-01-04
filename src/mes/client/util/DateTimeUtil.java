/*
 * 작성된 날짜: 2006. 12. 21
 *
 * TODO 생성된 파일에 대한 템플리트를 변경하려면 다음으로 이동하십시오.
 * 창 - 환경 설정 - Java - 코드 스타일 - 코드 템플리트
 */
package mes.client.util;

import java.text.ParsePosition;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.GregorianCalendar;
import java.util.HashMap;
import java.util.Locale;
import java.util.TimeZone;
import java.util.Vector;

import mes.client.comm.DBServletLink;
import mes.client.common.Common;

public class DateTimeUtil {
    private static final String DATE_GUBUN = "-";
    private static final String TIME_GUBUN = ":";


    /**
     * 현재 시간을 돌려준다. - HH:MI:SS 
     */
    public static String getTimeText(int type, String szTime) {
        if(szTime != null && szTime.length() != 6) return ""; 
        
        if(szTime != null && szTime.length() == 6){         
            String hour = StringUtil.substring(szTime,0, 2);
            String minute = StringUtil.substring(szTime, 2, 4);
            String second = StringUtil.substring(szTime,4, 6);
        
            switch(type) {
                case 1:
                    return hour + TIME_GUBUN + minute + TIME_GUBUN+ second;
                case 2:
                    return  hour + TIME_GUBUN + minute;
                case 3:    
                    return  hour;
           }
        }   

        return "";
    }

    /**
     * 시간을 돌려준다. - HH:MI:SS.ss 
     */
    public static String getTimeText(String szTime) {
        System.out.println("1:"+szTime);
        if(szTime != null && szTime.length() != 8) return ""; 
        
        System.out.println("2:"+szTime);
        if(szTime != null && szTime.length() == 8){         
            String hour = StringUtil.substring(szTime,0, 2);
            String minute = StringUtil.substring(szTime, 2, 4);
            String second = StringUtil.substring(szTime,4, 6);
            String dbsecond = StringUtil.substring(szTime,6, 8);            
            System.out.println("3:"+szTime);
            return hour + TIME_GUBUN + minute + TIME_GUBUN+ second +"." + dbsecond;
        }
        System.out.println("4:"+szTime);
        
        return "";        
    }   
    
    
    public static String getDateText(int type, String szdate){
        return getDateText(type, szdate,DATE_GUBUN);
    }



    public static String getDateText(int type, String szdate,String delimeter) {
        String reDate = "";
        
        if(szdate != null && szdate.length() != 8) return ""; 
        
        
        if(szdate != null && szdate.length() == 8){         
            String year = szdate.substring(0, 4);
            String month = szdate.substring(4, 6);
            String day = szdate.substring(6, 8);
        
            switch(type) {
                case 1:
                    return  year + delimeter + month + delimeter + day;
                case 2:
                    return  year.substring(2, 4) + delimeter + month + delimeter + day;
                case 3:    
                    return month + delimeter + day;
                case 4:
                    return  year + delimeter + month;
                case 5:
                    return year;
           }
        }   
        
        return "";
    }

    
    /**
     * 특정형태의 날자 타입을 돌려준다.
     * TYPE 0 : YYYY.MM.DD HH:MI:SS
     * TYPE 1 : YYYY.MM.DD
     * TYPE 2 : YY.MM.DD
     * TYPE 3 : MM.DD
     * TYPE 4 : YYYY.MM
     * TYPE 5 : YYYY
     * TYPE 6 : MM.DD HH:MI
     * TYPE 7 : HH:MI
     * TYPE 8 : HH:MI:SS.2SS
     * @param type
     * @param dateTime
     * @return
     */
    public static String getDateType(int type, String date){
        return getDateType(type, date, DATE_GUBUN);
    }

    public static String getDateType(int type, String date, String delimeter) {
        if (date == null) {
            return "";
        }

        if(date.length() == 12) date += "01";
        else if(date.length() == 10) date += "0101";
        else if(date.length() == 8) date += "010101";
        else if(date.length() == 6) date += "01010101";
        else if(date.length() == 4) date += "0101010101";

        switch(type) {
            case 0:
                return getDateText(1,StringUtil.substring(date, 0, 8), delimeter) + " " + getTimeText(1,StringUtil.substring(date, 8, 14));
            case 1:
                return getDateText(1,StringUtil.substring(date, 0, 8), delimeter);
            case 2:
                return getDateText(2,StringUtil.substring(date, 0, 8), delimeter);
            case 3:
                return getDateText(3,StringUtil.substring(date, 0, 8), delimeter);
            case 4:
                return getDateText(4,StringUtil.substring(date, 0, 8), delimeter);
            case 5:
                return getDateText(5,StringUtil.substring(date, 0, 8), delimeter);
            case 6:
                return getDateText(3,StringUtil.substring(date, 0, 8), delimeter) + " " + getTimeText(2,StringUtil.substring(date, 8, 14));
            case 7:
                return getTimeText(2,StringUtil.substring(date, 8, 14));
            case 8:
                return getTimeText(StringUtil.substring(date, 0, 8));
            case 9:
                return getTimeText(1,StringUtil.substring(date, 0, 6));
        }
        
        return "";
    }
    
    //중간에 구분자를 넣어 시분을 돌려준다 HH:MI
    public static String getHhmm(String time) {
    	String str = "";
    	try {
    		str = time.substring(0,2) + ":" +  time.substring(2,4);
    	} catch(Exception e) {
    		str = "";
    	}
    	return str;
    }
    
    public static String getTime() {
        Date d = new Date();
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy\uB144 MM\uC6D4 dd\uC77C HH\uC2DC mm\uBD84");
        return sdf.format(d);
    }

    public static String getTime(String format) {
        Date d = new Date();
        SimpleDateFormat sdf = new SimpleDateFormat(format);
        return sdf.format(d);
    }

    public static String getCurrentDate() {
        return getCurrentDate("yyyyMMdd");
    }

    public static String getDate(String szformat) {
        return getCurrentDate(szformat);
    }
    
    public static String getCurrentDate(String format) {
        Date d = new Date();
        SimpleDateFormat sdf = new SimpleDateFormat(format);
        return sdf.format(d);
    }

    public static String getThisMonth() {
        Date d = new Date();
        SimpleDateFormat sdf = new SimpleDateFormat("yyyyMM");
        return sdf.format(d);
    }

    public static String getThisYear() {
        Date d = new Date();
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy");
        return sdf.format(d);
    }

    public static String getCurrentTime() {
        Date d = new Date();
        SimpleDateFormat sdf = new SimpleDateFormat("HHmmss");
        return sdf.format(d);
    }

    public static String getDayInterval(String format, int distance) {
        Calendar cal = getCalendar();
        cal.add(5, distance);
        Date d = cal.getTime();
        SimpleDateFormat sdf = new SimpleDateFormat(format);
        return sdf.format(d);
    }

    public static String getDayInterval(String dateString, String format, int distance) {
        Calendar cal = getCalendar(dateString);
        cal.add(5, distance);
        Date d = cal.getTime();
        SimpleDateFormat sdf = new SimpleDateFormat(format);
        return sdf.format(d);
    }

    public static String getYesterday() {
        Calendar cal = getCalendar();
        cal.add(5, -1);
        Date d = cal.getTime();
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd");
        return sdf.format(d);
    }

    public static String getLastMonth() {
        Calendar cal = getCalendar();
        cal.add(2, -1);
        Date d = cal.getTime();
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM");
        return sdf.format(d);
    }

    public static String[] getDates(String startDay, String endDay) {
        Vector v = new Vector();
        v.addElement(startDay);
        Calendar cal = getCalendar();
        cal.setTime(string2Date(startDay));
        for(String nextDay = date2String(cal.getTime()); !nextDay.equals(endDay); v.addElement(nextDay)) {
            cal.add(5, 1);
            nextDay = date2String(cal.getTime());
        }

        String go[] = new String[v.size()];
        v.copyInto(go);
        return go;
    }

    public static Calendar getCalendar() {
        Calendar calendar = new GregorianCalendar(TimeZone.getTimeZone("GMT+09:00"), Locale.KOREA);
        calendar.setTime(new Date());
        return calendar;
    }

    public static Calendar getCalendar(String dateString) {
        Calendar calendar = new GregorianCalendar(TimeZone.getTimeZone("GMT+09:00"), Locale.KOREA);
        calendar.setTime(string2Date(dateString, "yyyyMMdd"));
        return calendar;
    }

    public static Calendar getCalendar(Date date) {
        Calendar calendar = new GregorianCalendar(TimeZone.getTimeZone("GMT+09:00"), Locale.KOREA);
        calendar.setTime(date);
        return calendar;
    }

    public static String date2String(Date d) {
        return date2String(d, "yyyy/MM/dd");
    }

    public static String date2String(Date d, String format) {
        SimpleDateFormat sdf = new SimpleDateFormat(format);
        return sdf.format(d);
    }

    public static Date string2Date(String s) {
        return string2Date(s, "yyyy/MM/dd");
    }

    public static Date string2Date(String s, String format) {
        Date d = null;
        try {
            SimpleDateFormat sdf = new SimpleDateFormat(format);
            d = sdf.parse(s, new ParsePosition(0));
        } catch(Exception e) {
            throw new RuntimeException("Date format not valid.");
        }
        return d;
    }

    public static long getDayDistance(String startDate, String endDate) throws Exception {
        return getDayDistance(startDate, endDate, null);
    }

    public static long getDayDistance(String startDate, String endDate, String format) throws Exception {
        if(format == null)
            format = "yyyyMMdd";
        SimpleDateFormat sdf = new SimpleDateFormat(format);
        long day2day = 0L;
        try {
            Date sDate = sdf.parse(startDate);
            Date eDate = sdf.parse(endDate);
            day2day = (eDate.getTime() - sDate.getTime()) / 0x5265c00L;
        } catch(Exception e) {
            throw new Exception("wrong format string");
        }
        return Math.abs(day2day);
    }

    public static String convertFormat(String dateString, String fromFormat, String toFormat) {
        Date date = string2Date(dateString, fromFormat);
        return date2String(date, toFormat);
    }

    public static String applyDistance(String dateString, String dateFormat, int year, int month, int day, int hour, int minute, int second) {
        Calendar cal = getCalendar(string2Date(dateString, dateFormat));
        cal.add(1, year);
        cal.add(2, month);
        cal.add(5, day);
        cal.add(10, hour);
        cal.add(12, minute);
        cal.add(13, second);
        return date2String(cal.getTime(), dateFormat);
    }    

    
	public static String getServerDateTime() {
		String str = Common.getSystemTime("datetime");
		return str;	
	}
    
    /*
	public static String getServerDate() { 
		DBServletLink dbServletLink = new DBServletLink();
		dbServletLink.connectURL("M000S000E100");
        Vector table = dbServletLink.doQuery(" ", true);
		String str = table != null ? ((Vector)(table.get(0))).get(0).toString() : "";
		return str;	
	}
	
	public static String getServerTime() {
		DBServletLink dbServletLink = new DBServletLink();
		dbServletLink.connectURL("M000S000E101");
        Vector table = dbServletLink.doQuery(" ", true);
		String str = table != null ? ((Vector)(table.get(0))).get(0).toString() : "";
		return str;	
	}    
    
	public static String getServerDateTime() {
		DBServletLink dbServletLink = new DBServletLink();
		dbServletLink.connectURL("M000S000E102");
        Vector table = dbServletLink.doQuery(" ", true);
		String str = table != null ? ((Vector)(table.get(0))).get(0).toString() : "";
		return str;	
	}
	
	public static String getServerDateTime(String format) {
		DBServletLink dbServletLink = new DBServletLink();
		dbServletLink.connectURL("M000S000E103");
        Vector table = dbServletLink.doQuery(format, true);
		String str = table != null ? ((Vector)(table.get(0))).get(0).toString() : "";
		return str;	
	}
	*/
}
