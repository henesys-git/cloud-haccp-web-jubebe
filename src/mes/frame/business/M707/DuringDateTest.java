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
//		// Calendar�� Month�� 0���� �����ϹǷ� -1 ���ش�.
//		// Calendar�� �⺻ ��¥�� startDt�� �������ش�.
//		cal.set(startYear, startMonth -1, startDate);
//		JSONObject jArray = new JSONObject();
//		
//		while(true) {
//			// ��¥ ���
//			sdf = new SimpleDateFormat("yyyy-MM-dd");
////			System.out.println(sdf.format(cal.getTime()));
//			String date = sdf.format(cal.getTime());
//			
//			list.add(date.split("-")[2]);
//			jArray.put(date.split("-")[2], date);
//			
//			System.out.println(list);
//			
//			// Calendar�� ��¥�� �Ϸ羿 �����Ѵ�.
//			cal.add(Calendar.DATE, 1); // one day increment
//			sdf = new SimpleDateFormat("yyyyMMdd");
//			// ���� ��¥�� �������ں��� ũ�� ����  
//			if(Integer.parseInt(sdf.format(cal.getTime())) > endDt) break;
//		}
//		
//		
//		System.out.println(list.get(list.indexOf("15")));
//
////		System.out.println("��:" +list.get(list.indexOf("01")));
		
		
		

	    String strStartDate = "20191231";
        String strEndDate = "20191216";
        String strFormat = "yyyyMMdd";    //strStartDate �� strEndDate �� format
        
        //SimpleDateFormat �� �̿��Ͽ� startDate�� endDate�� Date ��ü�� �����Ѵ�.
        SimpleDateFormat sdf = new SimpleDateFormat(strFormat);
        try{
            Date startDate = sdf.parse(strStartDate);
            Date endDate = sdf.parse(strEndDate);

            //�γ�¥ ������ �ð� ����(ms)�� �Ϸ� ������ ms(24��*60��*60��*1000�и���) �� ������.
            long diffDay = (startDate.getTime() - endDate.getTime()) / (24*60*60*1000);
            System.out.println((int)diffDay+"��");
        }catch(Exception e){
            e.printStackTrace();
        }

	}
		
}
