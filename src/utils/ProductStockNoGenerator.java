package utils;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.Random;




/*
 * 작성자 : 최현수
 * 작성일 : 2022-01-17
 * 목적 : 완제품 재고 테이블 키로 사용될 완제품재고번호 생성을 위함
 * 파라미터: String(생산계획번호_생산라인번호) or No Parameter
 * 결과값 : 생산계획번호_생산라인번호_랜덤숫자4자리 or 오늘날짜_0_랜덤숫자4자리
 */
public class ProductStockNoGenerator {
	
	private static int getRandomNumberInRange(int min, int max) {
        
        Random r = new Random();
        return r.ints(min, (max + 1)).limit(1).findFirst().getAsInt();
        
    }
	
	private static String getDate() {
        
		DateTimeFormatter dtf = DateTimeFormatter.ofPattern("yyyyMMdd");  
		LocalDateTime now = LocalDateTime.now();  
		return dtf.format(now);  
    }
	
	public static String generate(String preProdStockNo) {

	    int randomNum = ProductStockNoGenerator.getRandomNumberInRange(1000, 9999);
	    String randomNumStr = String.valueOf(randomNum);
	    
	    String prodStockNum = preProdStockNo.concat("_").concat(randomNumStr);
		
	    return prodStockNum;
	}
	
	public static String generate() {

	    int randomNum = ProductStockNoGenerator.getRandomNumberInRange(1000, 9999);
	    String randomNumStr = String.valueOf(randomNum);
	    
	    return getDate().concat("_0_").concat(randomNumStr);
	}
	
}