package mes.client.conf;

import java.awt.Color;
import java.awt.Font;
import java.net.URL;
import java.sql.Connection;

public class Config {
	// WAS�� ����
	public static final String WAS = "TOMCAT";
	
	// �������� ���� �����͸� ó���� ����V
	// -Dfile.encoding=utf-8�ϸ� console������ �ѱ� ����
	public static final String ENCODING = "utf-8";	//������ WAS�� �� ����
	
	// ������ ���Ͽ� �����Ѵ�. ==> Ű�� ���� WAS�� �������� ó���Ѵ�.
	public static String S_KEY = "HENESYS";
	
	// ����
	public static final String VERSION = "1.0";
	public static final String MES_PACKAGE_NAME = "mes.client.";
	
	// FTP����
	public static final String FTP_SERVER_IP 			= "192.168.1.201";
	public static final int FTP_SERVER_PORT 			= 22;
	public static final String FTP_SERVER_ROOT_DIR 		= "/";
	public static final String FTP_SERVER_2D_DIR 		= "FTPROOT/2d_Cad_File/";
	public static final String FTP_SERVER_3D_DIR 		= "FTPROOT/3d_File/";
	public static final String FTP_SERVER_PREVIEW_DIR 	= "FTPROOT/Preview_File/";
	public static final String FTP_SERVER_FIRST_DIR 	= "FTPROOT/Add_On_File_1/";
	public static final String FTP_SERVER_SECOND_DIR 	= "FTPROOT/Add_On_File_2/";
	public static final String FTP_SERVER_THIRD_DIR 	= "FTPROOT/Add_On_File_3/";
	
	// ������ IP
	public static String SERVER_IP = "localhost:8080";	
	
	// ���� �Ⱦ��̴� ��
	public static String WEBSERVER_IP = "106.249.230.226:38380"; // ���� ����
	
	public static String this_SERVER_path = "";
	public static String jdbcConnet = "";

	//DOC Server
	public static String DOC_SERVER_IP = "localhost:8080";
	public static String DOC_SAVEPATH = "/DocServer/DocUpload"; //�Ѽ����� �� �� 
	public static String DOC_FILE_SAVEPATH = "/DocServer/upload/files";
	public static String WEBSERVERURL = "http://localhost:8080/hcp_EdmsServerServlet";
	public static String EDMSSERVERUPLOADURL = "/DocServer/upload/FileUpload.jsp";			//smt
	public static String EDMSSERVERDOWNLOADURL = "/DocServer/upload/FileDownload.jsp";		//smt
	
	public static final String SERVER_PORT = "8051";
	// ���� ROOT
	public static String SERVER_ROOT_DIR = "HENESYS_MES_Server/" ;
	// ���� ��Ʈ
	public static String FILE_ROOT = "/DocServer/";
	// AS���� ���� ���� ��ġ
	public static String AS_FILE_PATH = FILE_ROOT + "AS/";
	// WEB �̹��� ���� ��ġ
	public static String IMAGE_FILE_PATH = "http://" + SERVER_IP + "/" + SERVER_ROOT_DIR + "images/";

	/********** StatusBar ****************************************************************************************/
	public static Color statusBarBGColor = new Color(12,63,108); // û���迭 update 10 Color...
	public static Color statusBarFGColor = Color.white; 
	
	public static String DOCUMENT_BASE = "http://" + SERVER_IP + "/";
	// ���� �̹��� ���� ���丮.
	public static String SERVER_IMAGE_DIR = "images/" ;
	// UI ������ ���丮.(free size)
	public static String SERVER_IMAGE_ICON_DIR = "icon/" ;
	
	public static String IMAGE_PATH = DOCUMENT_BASE + SERVER_ROOT_DIR + SERVER_IMAGE_DIR;
	
	// UI ������ ��ü ���.(free size)
	public static String ICON_PATH = DOCUMENT_BASE + SERVER_ROOT_DIR + SERVER_IMAGE_DIR + SERVER_IMAGE_ICON_DIR ;
	// UI ������ ���丮.(18X18)
	public static String SERVER_IMAGE_ICON18_DIR = SERVER_IMAGE_ICON_DIR + "18x18/" ;
	// UI ������ ��ü ���.(18X18)
	public static String ICON_18X18_PATH = DOCUMENT_BASE + SERVER_ROOT_DIR + SERVER_IMAGE_DIR + SERVER_IMAGE_ICON18_DIR ;
	// UI ������ ���丮.(26X26)
	public static String SERVER_IMAGE_ICON26_DIR = SERVER_IMAGE_ICON_DIR + "26x26/" ;
	// UI ������ ��ü ���.(26X26)
	public static String ICON_26X26_PATH = DOCUMENT_BASE + SERVER_ROOT_DIR + SERVER_IMAGE_DIR + SERVER_IMAGE_ICON26_DIR ;
	// Config �̹��� ���丮.
	public static String SERVER_IMAGE_CONF_DIR = "config/" ;
	
	// ��ũ�÷ξ���� �ڽ� ũ��
	public static int WFwidth = 150;
	public static int WFheight = 70;
	// �۾������ڵ�
	public static int INSERT = 1;
	public static int EDIT = 2;
	public static int DELETE = 3;
	public static int OPEN = 4;

	// ���̺� �ο��� ���� (����)
	public static final int TABLE_ROW_HIGHT = 22;
	// ���̺� �� ��� ��Ʈ (����)
	public static final Font TABLE_FONT_PLAIN_14 = new Font("����ü", Font.PLAIN, 14);
	public static final Font TABLE_FONT_BOLD_14 = new Font("����ü", Font.BOLD, 14);
	public static final Font TABLE_FONT_PLAIN_12 = new Font("����ü", Font.PLAIN, 12);
	public static final Font TABLE_FONT_BOLD_12 = new Font("����ü", Font.BOLD, 12);

	//	StringTokenizer�� ����ϱ� ������ �����ڸ� ����
	public static String MSGTOKEN = "|~|";//2018-09-10 ����
	public static String HEADTOKEN = "|~|";
	public static String PARAMTOKEN = "`#@#`";
	public static String DATATOKEN = "`#@#`";//
	
	public static int DRAFT_CODE_LENGTH = 10;

	// URL ��ȯ.
	public static URL getURL(String urlStr){
		URL url = null ;
		try {
			url = new URL(urlStr);
		} catch (Exception e) {
			// TODO: handle exception
			System.out.println("URL ���� ���� ---> " + urlStr);
		}
		return url ;
	}
	
	// frame.common�� �ִ� ������(2019-04-17 �߰�)
	public static String sysConfigPath = "";
	// EventFactory���� ȣ��ȴ�.
	public static final String CUST_ID = "mes.frame.business.";
	// WAS�� ������ �ҽ����� D/B���ؼ��� ����� ���ΰ� ���� (true�� �����ͼҽ��� ����Ѵ�)
	public static boolean useDataSource = true;
	
	// Mysql_Menu �̷� ��� client
	public static Connection con_Mysql_Menu;
}