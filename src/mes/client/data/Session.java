package mes.client.data;

import java.util.Hashtable;
import java.util.Vector;


public class Session {

	
	public static String SS_MAIN_SANGHO = "HACCP";
	public static String SS_MAIN_CODE = "HACCP001";
	public static String LOGIN_ID = "DOYO1";
	public static String LOGIN_NAME = "도요새";
	public static String LOGIN_PASSWORD = "";
	public static String USER_GROUP_CODE = "";
	public static String USER_GROUP_NAME = "";
	public static String USER_DEPART_CODE = "";
	public static String USER_DEPART_NAME = "";
	public static String USER_IP_ADDRESS = "";
	public static String USER_MAIL_ID = "";
	public static String agentGroup = "AAA";
	//사용자  권한
	public static 	Vector AUTHO_BUTTON=null;
	public static boolean mInsert = false;
	public static boolean mUpdate = false;
	public static boolean mDelete = false;
	public static boolean mSelect = true;
	// 키에는 이름을 담고 value에는 코드를 담는다.
	public static Hashtable CONTACT_CHANNEL = null;
	public static Hashtable BIG_MINWON = null;
	
	// 처리일수
	public static int TEL_WORK_DAY = 0;
	public static int DOC_WORK_DAY = 7;
	public static int WEB_WORK_DAY = 3;
	public static int VISIT_WORK_DAY = 0;
	
	// 서버에서 수행하는 메시지 데몬 프로세서
	public static Process MSG_PROCESS = null;
	public static Process FILE_PROCESS = null;
	
	// 파일 업로드시 동일이름이 있는 경우 확인 데이터
	public static Hashtable UPLOADED_FILES = null;
	
	//업로드 된 이미지
	public static String UPLOADED_IMAGE_NAMES[] = null;
	
    // 동영상플레이어(MoviePlayer)가 두번이상 안 생기게...
    //public static MoviePlayer LOCAL_MON_MOVIE_PLAYER = null;
}