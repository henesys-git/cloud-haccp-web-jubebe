package mes.client.util;

import java.util.Date;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Random;

public class NumberGeneratorForCloudMES {
	
	private int getRandomNumberInRange(int min, int max) {
        
        Random r = new Random();
        return r.ints(min, (max + 1)).limit(1).findFirst().getAsInt();
        
    }
	
	public static String generateOdrNum() {
		
		DateFormat dateFormat = new SimpleDateFormat("yyyyMMddHHmmss");
	    Date date = new Date();
	    String dateStr = dateFormat.format(date);

	    NumberGeneratorForCloudMES ong = new NumberGeneratorForCloudMES();
	    int randomNum = ong.getRandomNumberInRange(1000, 9999);
	    String randomNumStr = String.valueOf(randomNum);
	    
	    String orderNum = "OD" + dateStr.concat(randomNumStr);
		
	    return orderNum;
	}
	
	public static String generatePlanNum() {
		
		DateFormat dateFormat = new SimpleDateFormat("yyyyMMddHHmmss");
	    Date date = new Date();
	    String dateStr = dateFormat.format(date);

	    NumberGeneratorForCloudMES ong = new NumberGeneratorForCloudMES();
	    int randomNum = ong.getRandomNumberInRange(1000, 9999);
	    String randomNumStr = String.valueOf(randomNum);
	    
	    String planNum = "PL" + dateStr.concat(randomNumStr);
		
	    return planNum;
	}
	
}