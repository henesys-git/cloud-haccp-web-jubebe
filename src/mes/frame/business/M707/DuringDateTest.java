package mes.frame.business.M707;

import java.text.SimpleDateFormat;
import java.util.Date;

import org.json.simple.parser.ParseException;

public class DuringDateTest {
	public static void main(String[] args) {
		
//		String sd = "2019-12-14".replaceAll("-", "");
//		String ed = "2020-01-13".replaceAll("-", "");
//		
//		String startDt = sd;
//		int endDt = Integer.parseInt(ed);
//		
//		int startYear = Integer.parseInt(startDt.substring(0,4));
//		int startMonth= Integer.parseInt(startDt.substring(4,6));
//		int startDate = Integer.parseInt(startDt.substring(6,8));
//		SimpleDateFormat sdf;
//		Calendar cal = Calendar.getInstance();
//		ArrayList<String> list = new ArrayList<String>();
//		// Calendar의 Month는 0부터 시작하므로 -1 해준다.
//		// Calendar의 기본 날짜를 startDt로 셋팅해준다.
//		cal.set(startYear, startMonth -1, startDate);
//		JSONObject jArray = new JSONObject();
//		
//		while(true) {
//			// 날짜 출력
//			sdf = new SimpleDateFormat("yyyy-MM-dd");
////			System.out.println(sdf.format(cal.getTime()));
//			String date = sdf.format(cal.getTime());
//			
//			list.add(date.split("-")[2]);
//			jArray.put(date.split("-")[2], date);
//			
//			System.out.println(list);
//			
//			// Calendar의 날짜를 하루씩 증가한다.
//			cal.add(Calendar.DATE, 1); // one day increment
//			sdf = new SimpleDateFormat("yyyyMMdd");
//			// 현재 날짜가 종료일자보다 크면 종료  
//			if(Integer.parseInt(sdf.format(cal.getTime())) > endDt) break;
//		}
//		
//		
//		System.out.println(list.get(list.indexOf("15")));
//
////		System.out.println("값:" +list.get(list.indexOf("01")));
		
		
		

	    String strStartDate = "20191231";
        String strEndDate = "20191216";
        String strFormat = "yyyyMMdd";    //strStartDate 와 strEndDate 의 format
        
        //SimpleDateFormat 을 이용하여 startDate와 endDate의 Date 객체를 생성한다.
        SimpleDateFormat sdf = new SimpleDateFormat(strFormat);
        try{
            Date startDate = sdf.parse(strStartDate);
            Date endDate = sdf.parse(strEndDate);

            //두날짜 사이의 시간 차이(ms)를 하루 동안의 ms(24시*60분*60초*1000밀리초) 로 나눈다.
            long diffDay = (startDate.getTime() - endDate.getTime()) / (24*60*60*1000);
            System.out.println((int)diffDay+"일");
        }catch(Exception e){
            e.printStackTrace();
        }

	}
		
}
