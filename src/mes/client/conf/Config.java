package mes.client.conf;

import java.awt.Color;
import java.awt.Font;
import java.net.URL;
import java.sql.Connection;

public class Config {
	// WAS의 종류
	public static final String WAS = "TOMCAT";
	
	// 서버에서 받은 데이터를 처리할 문자V
	// -Dfile.encoding=utf-8하면 console에서는 한글 정상
	public static final String ENCODING = "utf-8";	//리눅스 WAS일 때 적용
	
	// 보안을 위하여 설정한다. ==> 키의 값은 WAS와 서블릿에서 처리한다.
	public static String S_KEY = "HENESYS";
	
	// 버젼
	public static final String VERSION = "1.0";
	public static final String MES_PACKAGE_NAME = "mes.client.";
	
	// FTP서버
	public static final String FTP_SERVER_IP 			= "192.168.1.201";
	public static final int FTP_SERVER_PORT 			= 22;
	public static final String FTP_SERVER_ROOT_DIR 		= "/";
	public static final String FTP_SERVER_2D_DIR 		= "FTPROOT/2d_Cad_File/";
	public static final String FTP_SERVER_3D_DIR 		= "FTPROOT/3d_File/";
	public static final String FTP_SERVER_PREVIEW_DIR 	= "FTPROOT/Preview_File/";
	public static final String FTP_SERVER_FIRST_DIR 	= "FTPROOT/Add_On_File_1/";
	public static final String FTP_SERVER_SECOND_DIR 	= "FTPROOT/Add_On_File_2/";
	public static final String FTP_SERVER_THIRD_DIR 	= "FTPROOT/Add_On_File_3/";
	
	// 웹서버 IP
	public static String SERVER_IP = "localhost:8080";	
	
	// 현재 안쓰이는 듯
	public static String WEBSERVER_IP = "106.249.230.226:38380"; // 개발 서버
	
	public static String this_SERVER_path = "";
	public static String jdbcConnet = "";

	//DOC Server
	public static String DOC_SERVER_IP = "localhost:8080";
	public static String DOC_SAVEPATH = "/DocServer/DocUpload"; //한서버로 할 때 
	public static String DOC_FILE_SAVEPATH = "/DocServer/upload/files";
	public static String WEBSERVERURL = "http://localhost:8080/hcp_EdmsServerServlet";
	public static String EDMSSERVERUPLOADURL = "/DocServer/upload/FileUpload.jsp";			//smt
	public static String EDMSSERVERDOWNLOADURL = "/DocServer/upload/FileDownload.jsp";		//smt
	
	public static final String SERVER_PORT = "8051";
	// 서버 ROOT
	public static String SERVER_ROOT_DIR = "HENESYS_MES_Server/" ;
	// 파일 루트
	public static String FILE_ROOT = "/DocServer/";
	// AS관리 관련 파일 위치
	public static String AS_FILE_PATH = FILE_ROOT + "AS/";
	// WEB 이미지 파일 위치
	public static String IMAGE_FILE_PATH = "http://" + SERVER_IP + "/" + SERVER_ROOT_DIR + "images/";

	/********** StatusBar ****************************************************************************************/
	public static Color statusBarBGColor = new Color(12,63,108); // 청색계열 update 10 Color...
	public static Color statusBarFGColor = Color.white; 
	
	public static String DOCUMENT_BASE = "http://" + SERVER_IP + "/";
	// 서버 이미지 파일 디렉토리.
	public static String SERVER_IMAGE_DIR = "images/" ;
	// UI 아이콘 디렉토리.(free size)
	public static String SERVER_IMAGE_ICON_DIR = "icon/" ;
	
	public static String IMAGE_PATH = DOCUMENT_BASE + SERVER_ROOT_DIR + SERVER_IMAGE_DIR;
	
	// UI 아이콘 전체 경로.(free size)
	public static String ICON_PATH = DOCUMENT_BASE + SERVER_ROOT_DIR + SERVER_IMAGE_DIR + SERVER_IMAGE_ICON_DIR ;
	// UI 아이콘 디렉토리.(18X18)
	public static String SERVER_IMAGE_ICON18_DIR = SERVER_IMAGE_ICON_DIR + "18x18/" ;
	// UI 아이콘 전체 경로.(18X18)
	public static String ICON_18X18_PATH = DOCUMENT_BASE + SERVER_ROOT_DIR + SERVER_IMAGE_DIR + SERVER_IMAGE_ICON18_DIR ;
	// UI 아이콘 디렉토리.(26X26)
	public static String SERVER_IMAGE_ICON26_DIR = SERVER_IMAGE_ICON_DIR + "26x26/" ;
	// UI 아이콘 전체 경로.(26X26)
	public static String ICON_26X26_PATH = DOCUMENT_BASE + SERVER_ROOT_DIR + SERVER_IMAGE_DIR + SERVER_IMAGE_ICON26_DIR ;
	// Config 이미지 디렉토리.
	public static String SERVER_IMAGE_CONF_DIR = "config/" ;
	
	// 워크플로어에서의 박스 크기
	public static int WFwidth = 150;
	public static int WFheight = 70;
	// 작업구분코드
	public static int INSERT = 1;
	public static int EDIT = 2;
	public static int DELETE = 3;
	public static int OPEN = 4;

	// 테이블 로우의 높이 (공통)
	public static final int TABLE_ROW_HIGHT = 22;
	// 테이블 내 사용 폰트 (공통)
	public static final Font TABLE_FONT_PLAIN_14 = new Font("굴림체", Font.PLAIN, 14);
	public static final Font TABLE_FONT_BOLD_14 = new Font("굴림체", Font.BOLD, 14);
	public static final Font TABLE_FONT_PLAIN_12 = new Font("굴림체", Font.PLAIN, 12);
	public static final Font TABLE_FONT_BOLD_12 = new Font("굴림체", Font.BOLD, 12);

	//	StringTokenizer를 사용하기 때문에 구분자를 지정
	public static String MSGTOKEN = "|~|";//2018-09-10 수정
	public static String HEADTOKEN = "|~|";
	public static String PARAMTOKEN = "`#@#`";
	public static String DATATOKEN = "`#@#`";//
	
	public static int DRAFT_CODE_LENGTH = 10;

	// URL 반환.
	public static URL getURL(String urlStr){
		URL url = null ;
		try {
			url = new URL(urlStr);
		} catch (Exception e) {
			// TODO: handle exception
			System.out.println("URL 연결 실패 ---> " + urlStr);
		}
		return url ;
	}
	
	// frame.common에 있던 변수들(2019-04-17 추가)
	public static String sysConfigPath = "";
	// EventFactory에서 호출된다.
	public static final String CUST_ID = "mes.frame.business.";
	// WAS의 데이터 소스에서 D/B컨넥션을 사용할 것인가 여부 (true면 데이터소스를 사용한다)
	public static boolean useDataSource = true;
	
	// Mysql_Menu 이력 통계 client
	public static Connection con_Mysql_Menu;
}