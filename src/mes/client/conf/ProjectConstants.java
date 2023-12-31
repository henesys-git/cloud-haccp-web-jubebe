/*
 * 프로젝트별 constants를 위한 클래스
 * 
 * */
package mes.client.conf;

public class ProjectConstants {
	// 초기 비밀번호
	public static final String INITIAL_PASSWORD = "0000";
	
	// 온도 센서 아이디
	public static final String TEMP_DEVICE_RAPID_FREEZER = "autonix_temp01";
	public static final String TEMP_DEVICE_WORK_ROOM = "autonix_temp02";
	public static final String TEMP_DEVICE_RAWMATERIAL_ROOM = "autonix_temp03";
	public static final String TEMP_DEVICE_WEIGHT_ROOM = "autonix_temp04";
	public static final String TEMP_DEVICE_WASH_ROOM = "autonix_temp05";
	public static final String TEMP_DEVICE_COLD_ROOM = "autonix_temp06";
	public static final String TEMP_DEVICE_INNER_PACK = "autonix_temp07";
	public static final String TEMP_DEVICE_OPEN_ROOM = "autonix_temp08";
	public static final String TEMP_DEVICE_FREEZER = "autonix_temp09";
	
	// 중량 선별기
	public static final String WEIGHT_CHECKER = "weight_checker01";

	// 중량 선별기
	public static final String METAL_DETECTOR = "metal_detector01";
	
	// 운영 서버 정보
	public static final String SERVER_IP = "http://112.217.193.114:8080";
	
	// 인터페이스 IP & PORT
	public static final String TEMPERATURE_IP1 = "192.168.1.241";
	public static final int TEMPERATURE_PORT1 = 1470;
	
	public static final String TEMPERATURE_IP2 = "192.168.1.242";
	public static final int TEMPERATURE_PORT2 = 1470;
	
	public static final String BARCODE_PRINT_IP = "192.168.0.202";
	public static final int BARCODE_PRINT_PORT = 8000;
	
	public static final String WEIGHT_CHECKER_IP = "192.168.1.240";
	public static final int WEIGHT_CHECKER_PORT = 8899;
	
	public static final String METAL_DETECTOR_IP = "192.168.1.243";
	public static final int METAL_DETECTOR_PORT = 2004;
}