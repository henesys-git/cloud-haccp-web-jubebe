package mes.frame.common;

public class EventDefine {
	public final static String E_UNDEFINED_EVENT = "00000000";

	// ######################################################################################### //
	// <----------------------------------------- 공통 ---------------------------------------->
	/* EventFactory 에서 사용하는 변수*/
	public final static int E_EVENT_ID_ERROR   	= -1;  //EventID가 없을경우 에러 .
	public final static int E_EVENT_ID_OK    	= 1;   //EventFactory가 정상적으로 수행했을때 결과값.
	// ######################################################################################### //
	/* doExcute 에서 사용하는 변수*/
	public final static int E_DOEXCUTE_INIT 	= -1; //초기값.
	public final static int E_DOEXCUTE_ERROR 	= -1; //실행 에러값.
	public final static int E_PARAMETER_ERROR 	= -1; //파라메터 갯수에러.
	public final static int E_SQL_ERROR 		= -1; //SQL문 에러.
	public final static int E_QUERY_NOT_RESULT 	=  0; // SELECT 결과갯수 없음.
	public final static int E_QUERY_RESULT 		=  1; // SELECT 결과갯수 있음.

	/*EventID 검증 */
	public static boolean isEventID(String eventID){
		boolean result = true;
		return result;
	}
}
