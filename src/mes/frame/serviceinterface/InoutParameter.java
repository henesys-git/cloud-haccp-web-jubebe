package mes.frame.serviceinterface;

import java.util.Vector;

import mes.frame.common.EventDefine;
import mes.frame.common.HashObject;
import mes.frame.common.MessageDefine;

public class InoutParameter {
	private String m_nEvent;       // �̺�Ʈ .
	
	private String m_nUserId;      // �α��� ID. 	(USER Table �� US_ID (VARCHAR2(8))
	private int    m_nUserGrade;   // ����� ���.	(USER Table �� US_GRADE (NUMBER(1))
	
	private Vector m_vtArgv;       // �Է� �Ķ����.
	private HashObject m_shArgv;   // �Է� �Ķ����.
	private String[][] m_arArgv;   // �Է� �Ķ���� �迭�� ��ȯ.
	
	private Vector m_vtResult;     // ó����� ����.
	private String[][] m_arResult; // ó����� �迭�� ��ȯ.
	private String resultString;   // ó����� ��Ʈ��
	private String columnCount = ""; // �������� �ο� �� Į�� ��

	private String targetPage;     // �������� ��� ������
	private String m_strMessage;   // ���� �޽���.
	
	private String actionCommand = ""; // doQuery �� ... �̹��� doQueryTableFieldName�� EDMS�� ����Ҷ� �̳��� �߰��Ѵ�. 2018.06.26 ���밡...����
	
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
	
	// �Ķ������ �⺻���� /////////
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
	
	/* �Ķ��Ÿ �ʱ�ȭ */
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
	/* �̺�Ʈ ID ���� */
	public void setEventID(String id){
		m_nEvent = id;
	}
	public String getEventID(){
		return m_nEvent;
	}
	
	/* ���� ID ���� */
	public void setUserID(String id){
		m_nUserId = id;
	}
	public String getUserID(){
		return m_nUserId;
	}
	/* ���� ��� ���� */
	public void setUserGrade(int id){
		m_nUserGrade = id;
	}
	public int getUserGrade(){
		return m_nUserGrade;
	}
	/* �Է� �Ķ��Ÿ ���� */
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
	
	/* �����Ʈ�� ���� */
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

	/* ��� ��Ÿ ���� */
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
	/* �޽��� ���� */
	public void setMessage(String id){
		m_strMessage = id;
	}
	public String  getMessage(){
		return m_strMessage;
	}
	/* Ÿ�� ������ ���� */
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
