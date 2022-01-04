package mes.client.util;

import java.util.Date;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Random;

/*
 * 작성자 : 최현수
 * 작성일 : 2020-12-18
 * 목적 : 완제품 출하시 사용될 출하번호 생성을 위함
 */
public class ChulhaNumberGenerator {
	
	private int getRandomNumberInRange(int min, int max) {
        
        Random r = new Random();
        return r.ints(min, (max + 1)).limit(1).findFirst().getAsInt();
        
    }
	
	public static String generateChulhaNum() {
		
		DateFormat dateFormat = new SimpleDateFormat("yyyyMMdd");
	    Date date = new Date();
	    String dateStr = dateFormat.format(date);

	    ChulhaNumberGenerator ong = new ChulhaNumberGenerator();
	    int randomNum = ong.getRandomNumberInRange(1000, 9999);
	    String randomNumStr = String.valueOf(randomNum);
	    
	    String orderNum = dateStr.concat(randomNumStr);
		
	    return orderNum;
	}
	
}