package mes.client.util;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

/*
 * 작성자 : 최현수
 * 작성일 : 2020-12-04
 * 목적 : 발주한 원부자재를 창고에 입고 시 사용할 '이력 추적 키'를 생성하기 위함
 */
public class TraceKeyGenerator {
	
	public static String generateTraceKey() {
		
		DateTimeFormatter dtf = DateTimeFormatter.ofPattern("yyyyMMddHHmmss");  
		LocalDateTime now = LocalDateTime.now();  
		String trace_key = dtf.format(now);
			
		return trace_key;
	}
	
}