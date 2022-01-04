package mes.frame.serviceinterface;

import java.util.Vector;

import mes.frame.common.EventDefine;
import mes.frame.common.HashObject;
import mes.frame.common.MessageDefine;

public class InoutParameter {
	private String m_nEvent;       // 이벤트 .
	
	private String m_nUserId;      // 로그인 ID. 	(USER Table 의 US_ID (VARCHAR2(8))
	private int    m_nUserGrade;   // 사용자 등급.	(USER Table 의 US_GRADE (NUMBER(1))
	
	private Vector m_vtArgv;       // 입력 파라메터.
	private HashObject m_shArgv;   // 입력 파라메터.
	private String[][] m_arArgv;   // 입력 파라메터 배열로 변환.
	
	private Vector m_vtResult;     // 처리결과 벡터.
	private String[][] m_arResult; // 처리결과 배열로 변환.
	private String resultString;   // 처리결과 스트링
	private String columnCount = ""; // 내려보낼 로우 당 칼럼 수

	private String targetPage;     // 포워딩할 대상 페이지
	private String m_strMessage;   // 각종 메시지.
	
	private String actionCommand = ""; // doQuery 등 ... 이번에 doQueryTableFieldName을 EDMS에 사용할라꼬 이넘을 추가한다. 2018.06.26 지노가...ㅎㅎ
	
	public InoutParameter() {
		m_nEvent = EventDefine.E_UNDEFINED_EVENT;
		m_vtArgv = new Vector();
		m_arArgv = null;
		m_vtResult = new Vector();
		m_arResult = null;
		resultString = null;
		targetPage = new String();
		m_strMessage = MessageDefine.M_UNDEFINED_MESSAGE;
	}
	
	// 파라미터의 기본형태 /////////
	// M101S01000E001 //////////
	////////////////////////////
	public int getEventMenu(){
		return Integer.parseInt(m_nEvent.substring(1,3));
	}
	public String getEventCustID(){
		int eE=m_nEvent.indexOf("E");
		return m_nEvent.substring(0,eE);
//		return m_nEvent.substring(0,9);
	}
	public int getEventSubMenu(){
		int eE=m_nEvent.indexOf("E");
		return Integer.parseInt(m_nEvent.substring(5,eE));//20180727
//		return Integer.parseInt(m_nEvent.substring(4,eE));
//		return Integer.parseInt(m_nEvent.substring(4,9));
	}
	public String getEventSubID(){
		int eE=m_nEvent.indexOf("E");
		return m_nEvent.substring(eE);
//		return m_nEvent.substring(9,13);
	}
	
	/* 파라미타 초기화 */
	public void setClear(){
		m_nEvent = EventDefine.E_UNDEFINED_EVENT;
		m_vtArgv = new Vector();
		m_arArgv = null;
		m_vtResult = new Vector();
		m_arResult = null;
		resultString = null;
		targetPage = new String();
		m_strMessage = MessageDefine.M_UNDEFINED_MESSAGE;
	}
	/* 이벤트 ID 셋팅 */
	public void setEventID(String id){
		m_nEvent = id;
	}
	public String getEventID(){
		return m_nEvent;
	}
	
	/* 유저 ID 셋팅 */
	public void setUserID(String id){
		m_nUserId = id;
	}
	public String getUserID(){
		return m_nUserId;
	}
	/* 유저 등급 셋팅 */
	public void setUserGrade(int id){
		m_nUserGrade = id;
	}
	public int getUserGrade(){
		return m_nUserGrade;
	}
	/* 입력 파라메타 셋팅 */
	public void setInputParam(Vector id){
		m_vtArgv = id;
	}
	public void setInputParam(HashObject id){
		m_shArgv = id;
	}
	public void setInputParamArray(String[][] id){
		m_arArgv = id;
	}
	public Vector getInputParam(){
		return m_vtArgv;
	}
	public HashObject getInputHashObject() {
	    return m_shArgv;
	}
	public String[][] getInputArray(){
		if(m_vtArgv == null) return m_arArgv;
		try{
			int rowSize = m_vtArgv.size();
			Vector result = (Vector)m_vtArgv.elementAt(0);
			int colSize = result.size();
			m_arArgv = new String[rowSize][colSize];
		    for(int i=0; i < rowSize ; i++){
	        	result = (Vector)m_vtArgv.elementAt(i);
	        	for(int j=0; j < colSize; j++){
	        		m_arArgv[i][j] = (String)result.get(j);
	        	}
	        }
		} catch(Exception e) {
			
			m_arArgv = null;
		}
		return m_arArgv;
	}
	
	/* 결과스트링 세팅 */
	public void setResultString(String str) {
		resultString = str;
	}
	public String getResultString() {
		return resultString;
	}
	public void setColumnCount(String cnt) {
		columnCount = cnt;
	}
	public String getColumnCount() {
		return columnCount;
	}

	/* 결과 벡타 셋팅 */
	public void setResultVector(Vector id){
		m_vtResult = id;
	}
	public Vector getResultVector(){
		return m_vtResult;
	}
	public String[][] getResultArray(){
		if(m_vtResult == null) return m_arResult;
		try{
			int rowSize = m_vtResult.size();
			Vector result = (Vector)m_vtResult.elementAt(0);
			int colSize = result.size();
			m_arResult = new String[rowSize][colSize];
		    for(int i=0; i < rowSize ; i++){
	        	result = (Vector)m_vtResult.elementAt(i);
	        	for(int j=0; j < colSize; j++){
	        		m_arResult[i][j] = (String)result.get(j);
	        	}
	        }
		}catch(Exception e){
			
			m_arResult = null;
		}
		return m_arResult;
	}
	/* 메시지 셋팅 */
	public void setMessage(String id){
		m_strMessage = id;
	}
	public String  getMessage(){
		return m_strMessage;
	}
	/* 타겟 페이지 셋팅 */
	public void setTargetPage(String page) {
		targetPage = page;
	}
	public String getTargetPage() {
		return targetPage;
	}
	public void setActionCommand(String acCommand) {
		actionCommand = acCommand;
	}
	public String getActionCommand() {
		return actionCommand;
	}
}
