package mes.frame.common;

public class EventDefine {
	public final static String E_UNDEFINED_EVENT = "00000000";

	// ######################################################################################### //
	// <----------------------------------------- ���� ---------------------------------------->
	/* EventFactory ���� ����ϴ� ����*/
	public final static int E_EVENT_ID_ERROR   	= -1;  //EventID�� ������� ���� .
	public final static int E_EVENT_ID_OK    	= 1;   //EventFactory�� ���������� ���������� �����.
	// ######################################################################################### //
	/* doExcute ���� ����ϴ� ����*/
	public final static int E_DOEXCUTE_INIT 	= -1; //�ʱⰪ.
	public final static int E_DOEXCUTE_ERROR 	= -1; //���� ������.
	public final static int E_PARAMETER_ERROR 	= -1; //�Ķ���� ��������.
	public final static int E_SQL_ERROR 		= -1; //SQL�� ����.
	public final static int E_QUERY_NOT_RESULT 	=  0; // SELECT ������� ����.
	public final static int E_QUERY_RESULT 		=  1; // SELECT ������� ����.

	/*EventID ���� */
	public static boolean isEventID(String eventID){
		boolean result = true;
		return result;
	}
}
