package mes.client.util;

import java.util.Date;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Random;

/*
 * 작성자 : 최현수
 * 작성일 : 2021-01-10
 * 목적 : 제품별 생산계획(tbi_production_plan_daily_detail)과
 *       완제품 재고(tbi_prod_storage2)를 연결하는 값을 생성
 */
public class GeneratorPlanStorageMapper {
	
	private int getRandomNumberInRange(int min, int max) {
        
        Random r = new Random();
        return r.ints(min, (max + 1)).limit(1).findFirst().getAsInt();
        
    }
	
	public static String generateMappingValue() {
		
		DateFormat dateFormat = new SimpleDateFormat("yyyyMMdd");
	    Date date = new Date();
	    String dateStr = dateFormat.format(date);

	    GeneratorPlanStorageMapper mapper = new GeneratorPlanStorageMapper();
	    int randomNum = mapper.getRandomNumberInRange(1000, 9999);
	    String randomNumStr = String.valueOf(randomNum);
	    
	    String mappingValue = dateStr.concat(randomNumStr);
		
	    return mappingValue;
	}
	
}