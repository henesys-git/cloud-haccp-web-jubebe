package mes.client.data;

import java.util.Hashtable;
import java.util.Vector;


public class Session {

	
	public static String SS_MAIN_SANGHO = "HACCP";
	public static String SS_MAIN_CODE = "HACCP001";
	public static String LOGIN_ID = "DOYO1";
	public static String LOGIN_NAME = "�����";
	public static String LOGIN_PASSWORD = "";
	public static String USER_GROUP_CODE = "";
	public static String USER_GROUP_NAME = "";
	public static String USER_DEPART_CODE = "";
	public static String USER_DEPART_NAME = "";
	public static String USER_IP_ADDRESS = "";
	public static String USER_MAIL_ID = "";
	public static String agentGroup = "AAA";
	//�����  ����
	public static 	Vector AUTHO_BUTTON=null;
	public static boolean mInsert = false;
	public static boolean mUpdate = false;
	public static boolean mDelete = false;
	public static boolean mSelect = true;
	// Ű���� �̸��� ��� value���� �ڵ带 ��´�.
	public static Hashtable CONTACT_CHANNEL = null;
	public static Hashtable BIG_MINWON = null;
	
	// ó���ϼ�
	public static int TEL_WORK_DAY = 0;
	public static int DOC_WORK_DAY = 7;
	public static int WEB_WORK_DAY = 3;
	public static int VISIT_WORK_DAY = 0;
	
	// �������� �����ϴ� �޽��� ���� ���μ���
	public static Process MSG_PROCESS = null;
	public static Process FILE_PROCESS = null;
	
	// ���� ���ε�� �����̸��� �ִ� ��� Ȯ�� ������
	public static Hashtable UPLOADED_FILES = null;
	
	//���ε� �� �̹���
	public static String UPLOADED_IMAGE_NAMES[] = null;
	
    // �������÷��̾�(MoviePlayer)�� �ι��̻� �� �����...
    //public static MoviePlayer LOCAL_MON_MOVIE_PLAYER = null;
}