package mes.client.common;

import java.awt.Color;
import java.util.Vector;

import javax.swing.JOptionPane;

import mes.client.comm.DBServletLink;
import mes.client.data.Session;

import org.json.simple.*;

public class CommonData {
	public static String[][] machineNumbers = {{"전체","0"},{"냉장창고-1","01"},{"냉장창고-2", "02"}, {"해동실","03"}, {"냉동창고","04"}, {"완제품창고","05"}};
	
	public static String[][] part_nms = {{"전체","0"},{"고사리","01"},
										{"중숙고구마","02"},{"냉동감자당근","03"}}; 
	
    public static int INSERT = 1;
    public static int UPDATE = 2;
    public static int DELETE = 3;
    public static int SELECT = 4;

	// 수정불가한 필드 컬러. 부서
	public static Color FG_INFO = new Color(17, 33, 129) ;
//	public static Color FG_INFO = new Color(200, 230, 250) ;
//	public static Color BG_INFO = new Color(176, 187, 255) ;
	public static Color BG_INFO = new Color(238, 238, 252) ;
	
    // 다용도 데이터 배열 (key,value), 
    public static String[] commonDataArr ;
    
    public static void setCommonDataArr(String key, String value){
    	commonDataArr = new String[]{key,value} ;
    }
    public static String[] getCommonDataArr(){
    	return commonDataArr ;
    }

	// 날짜. 
	public static String getDate(String PM, int pmDayCount) {
		String params = "" + PM + "|" + pmDayCount;
        DBServletLink dbServletLink = new DBServletLink();
        dbServletLink.connectURL("M000S000000E101");
        String myDate = dbServletLink.getColumnValue(params);
		
		return myDate ;
	}

	// 채널분류코드,이름 반환. 
	public static Vector getChannelData() {
        DBServletLink dbServletLink = new DBServletLink();
        dbServletLink.connectURL("M000S010000E010");
        Vector tmpVector = dbServletLink.doQuery(Session.SS_MAIN_CODE, false);
		Vector rtnVector = new Vector() ;
		rtnVector.add(dbServletLink.getColumnData(tmpVector, 0)) ;
		rtnVector.add(dbServletLink.getColumnData(tmpVector, 1)) ;
		
		return rtnVector ;
	}

	// 타스크분류코드,이름 반환. 
	public static Vector getTaskData() {
        DBServletLink dbServletLink = new DBServletLink();
        dbServletLink.connectURL("M000S010000E020");
        Vector tmpVector = dbServletLink.doQuery(Session.SS_MAIN_CODE, false);
		Vector rtnVector = new Vector() ;
		rtnVector.add(dbServletLink.getColumnData(tmpVector, 0)) ;
		rtnVector.add(dbServletLink.getColumnData(tmpVector, 1)) ;
		
		return rtnVector ;
	}
	// 타스크분류코드,이름 반환. 전체포함
	public static Vector getTaskDataAll() {
        DBServletLink dbServletLink = new DBServletLink();
        dbServletLink.connectURL("M000S010000E020");
        Vector tmpVector = dbServletLink.doQuery(Session.SS_MAIN_CODE, false);
        // 코드추가(ALL)
        Vector codeVector = dbServletLink.getColumnData(tmpVector, 0);
        codeVector.insertElementAt("ALL", 0);
        // 이름추가(전체)
        Vector nameVector = dbServletLink.getColumnData(tmpVector, 1);
        nameVector.insertElementAt("전체", 0);
        // 합체
		Vector rtnVector = new Vector() ;
		rtnVector.add(codeVector) ;
		rtnVector.add(nameVector) ;
		
		return rtnVector ;
	}

	// 지연사유,이름 반환. 
	public static Vector getDelayReasonData(String member_key) {
        DBServletLink dbServletLink = new DBServletLink();
        dbServletLink.connectURL("M000S010000E021");
        Vector tmpVector = dbServletLink.doQuery(member_key+"|", false);
		Vector rtnVector = new Vector() ;
		rtnVector.add(dbServletLink.getColumnData(tmpVector, 0)) ;
		rtnVector.add(dbServletLink.getColumnData(tmpVector, 1)) ;
		rtnVector.add(dbServletLink.getColumnData(tmpVector, 2)) ;
		
		return rtnVector ;
	}
	

	public static Vector getDelayReasonDataAll(String member_key) {
        DBServletLink dbServletLink = new DBServletLink();
        dbServletLink.connectURL("M000S010000E021");
        Vector tmpVector = dbServletLink.doQuery(member_key+"|", false);
        // 코드추가(ALL)
        Vector codeVector = dbServletLink.getColumnData(tmpVector, 0);
        codeVector.insertElementAt("SEL", 0);
        // 이름추가(전체)
        Vector nameVector = dbServletLink.getColumnData(tmpVector, 1);
        nameVector.insertElementAt("선택", 0);
        Vector valueVector = dbServletLink.getColumnData(tmpVector, 2);
        valueVector.insertElementAt("SEL", 0);
        // 합체
		Vector rtnVector = new Vector() ;
		rtnVector.add(codeVector) ;
		rtnVector.add(nameVector) ;
		rtnVector.add(valueVector) ;
		
		return rtnVector ;
	}
	
	// 지연사유,이름 반환. 
		public static Vector getIssueReasonData() {
	        DBServletLink dbServletLink = new DBServletLink();
	        dbServletLink.connectURL("M000S010000E022");
	        Vector tmpVector = dbServletLink.doQuery(Session.SS_MAIN_CODE, false);
			Vector rtnVector = new Vector() ;
			rtnVector.add(dbServletLink.getColumnData(tmpVector, 0)) ;
			rtnVector.add(dbServletLink.getColumnData(tmpVector, 1)) ;
			rtnVector.add(dbServletLink.getColumnData(tmpVector, 2)) ;
			
			return rtnVector ;
		}
		

		public static Vector getIssueReasonDataAll() {
	        DBServletLink dbServletLink = new DBServletLink();
	        dbServletLink.connectURL("M000S010000E022");
	        Vector tmpVector = dbServletLink.doQuery(Session.SS_MAIN_CODE, false);
	        // 코드추가(ALL)
	        Vector codeVector = dbServletLink.getColumnData(tmpVector, 0);
	        codeVector.insertElementAt("SEL", 0);
	        // 이름추가(전체)
	        Vector nameVector = dbServletLink.getColumnData(tmpVector, 1);
	        nameVector.insertElementAt("선택", 0);
	        Vector valueVector = dbServletLink.getColumnData(tmpVector, 2);
	        valueVector.insertElementAt("SEL", 0);
	        // 합체
			Vector rtnVector = new Vector() ;
			rtnVector.add(codeVector) ;
			rtnVector.add(nameVector) ;
			rtnVector.add(valueVector) ;
			
			return rtnVector ;
		}
	
	// 진행상태분류코드,이름 반환. 
	public static Vector getStatusData(String member_key) {
        DBServletLink dbServletLink = new DBServletLink();
        dbServletLink.connectURL("M000S010000E030");
        Vector tmpVector = dbServletLink.doQuery(member_key+"|", false);
		Vector rtnVector = new Vector() ;
		rtnVector.add(dbServletLink.getColumnData(tmpVector, 0)) ;
		rtnVector.add(dbServletLink.getColumnData(tmpVector, 1)) ;
		rtnVector.add(dbServletLink.getColumnData(tmpVector, 2)) ;
		
		return rtnVector ;
	}
	// 진행상태분류코드,이름 반환. 전체포함
	public static Vector getStatusDataAll(String member_key) {
        DBServletLink dbServletLink = new DBServletLink();
        dbServletLink.connectURL("M000S010000E030");
        Vector tmpVector = dbServletLink.doQuery(member_key+"|", false);
        // 코드추가(ALL)
        Vector codeVector = dbServletLink.getColumnData(tmpVector, 0);
        codeVector.insertElementAt("SEL", 0);
        // 이름추가(전체)
        Vector nameVector = dbServletLink.getColumnData(tmpVector, 1);
        nameVector.insertElementAt("선택", 0);
        Vector valueVector = dbServletLink.getColumnData(tmpVector, 2);
        valueVector.insertElementAt("SEL", 0);
        // 합체
		Vector rtnVector = new Vector() ;
		rtnVector.add(codeVector) ;
		rtnVector.add(nameVector) ;
		rtnVector.add(valueVector) ;
		
		return rtnVector ;
	}

	// 진행상태분류코드,이름 반환.  
	public static Vector getProductionStatusData() {
        DBServletLink dbServletLink = new DBServletLink();
        dbServletLink.connectURL("M000S010000E031");
        Vector tmpVector = dbServletLink.doQuery(Session.SS_MAIN_CODE, false);
		Vector rtnVector = new Vector() ;
		rtnVector.add(dbServletLink.getColumnData(tmpVector, 0)) ;
		rtnVector.add(dbServletLink.getColumnData(tmpVector, 1)) ;
		rtnVector.add(dbServletLink.getColumnData(tmpVector, 2)) ;
		
		return rtnVector ;
	}
	// 전체 공정 진행상태.  
	public static Vector getProsStatusData() {
        DBServletLink dbServletLink = new DBServletLink();
        dbServletLink.connectURL("M000S010000E033");
        
        Vector tmpVector = dbServletLink.doQuery(Session.SS_MAIN_CODE, false);
        // 코드추가(ALL)
        Vector codeVector = dbServletLink.getColumnData(tmpVector, 0);
        codeVector.insertElementAt("ALL", 0);
        // 이름추가(전체)
        Vector nameVector = dbServletLink.getColumnData(tmpVector, 1);
        nameVector.insertElementAt("전체", 0);
        // 합체
		Vector rtnVector = new Vector() ;
		rtnVector.add(codeVector) ;
		rtnVector.add(nameVector) ;
		
		return rtnVector ;
	}
	
	// 전체 공정 진행상태.  
	public static Vector getBaljuStatusData() {
        DBServletLink dbServletLink = new DBServletLink();
        dbServletLink.connectURL("M000S010000E034");
        
        Vector tmpVector = dbServletLink.doQuery(Session.SS_MAIN_CODE, false);
        // 코드추가(ALL)
        Vector codeVector = dbServletLink.getColumnData(tmpVector, 0);
        codeVector.insertElementAt("ALL", 0);
        // 이름추가(전체)
        Vector nameVector = dbServletLink.getColumnData(tmpVector, 1);
        nameVector.insertElementAt("전체", 0);
        // 합체
		Vector rtnVector = new Vector() ;
		rtnVector.add(codeVector) ;
		rtnVector.add(nameVector) ;
		
		return rtnVector ;
	}
	// 공정구분코드.  
	public static Vector GetProcessGubun() {
        DBServletLink dbServletLink = new DBServletLink();
        dbServletLink.connectURL("M000S010000E001");
        
        Vector tmpVector = dbServletLink.doQuery(Session.SS_MAIN_CODE, false);
        // 코드추가(ALL)
        Vector codeVector = dbServletLink.getColumnData(tmpVector, 0);
        codeVector.insertElementAt("ALL", 0);
        // 이름추가(전체)
        Vector nameVector = dbServletLink.getColumnData(tmpVector, 1);
        nameVector.insertElementAt("전체", 0);
        // 합체
		Vector rtnVector = new Vector() ;
		rtnVector.add(codeVector) ;
		rtnVector.add(nameVector) ;
		
		return rtnVector ;
	}	

	//품질검사구분코드.  
	public static Vector getInspectGubunCode() {
        DBServletLink dbServletLink = new DBServletLink();
        dbServletLink.connectURL("M000S010000E035");
        
        Vector tmpVector = dbServletLink.doQuery(Session.SS_MAIN_CODE, false);
        // 코드추가(ALL)
        Vector codeVector = dbServletLink.getColumnData(tmpVector, 0);
        codeVector.insertElementAt("ALL", 0);
        // 이름추가(전체)
        Vector nameVector = dbServletLink.getColumnData(tmpVector, 1);
        nameVector.insertElementAt("전체", 0);
        // 합체
		Vector rtnVector = new Vector() ;
		rtnVector.add(codeVector) ;
		rtnVector.add(nameVector) ;
		
		return rtnVector ;
	}
	
	//부적합사유코드. 
	public static Vector getIncong_Code() {
        DBServletLink dbServletLink = new DBServletLink();
        dbServletLink.connectURL("M000S010000E036");
        Vector tmpVector = dbServletLink.doQuery(Session.SS_MAIN_CODE, false);
		Vector rtnVector = new Vector() ;
		rtnVector.add(dbServletLink.getColumnData(tmpVector, 0)) ;
		rtnVector.add(dbServletLink.getColumnData(tmpVector, 1)) ;
		
		return rtnVector ;
	}
	
	//부적합사유코드(전체).  
	public static Vector getIncong_CodeALL() {
        DBServletLink dbServletLink = new DBServletLink();
        dbServletLink.connectURL("M000S010000E036");
        
        Vector tmpVector = dbServletLink.doQuery(Session.SS_MAIN_CODE, false);
        // 코드추가(ALL)
        Vector codeVector = dbServletLink.getColumnData(tmpVector, 0);
        codeVector.insertElementAt("ALL", 0);
        // 이름추가(전체)
        Vector nameVector = dbServletLink.getColumnData(tmpVector, 1);
        nameVector.insertElementAt("전체", 0);
        // 합체
		Vector rtnVector = new Vector() ;
		rtnVector.add(codeVector) ;
		rtnVector.add(nameVector) ;
		
		return rtnVector ;
	}
	
	//체크리스트구분코드.  
	public static Vector getChecklistGubun_Code(String member_key) {
		DBServletLink dbServletLink = new DBServletLink();
        dbServletLink.connectURL("M000S010000E037");
        Vector tmpVector = dbServletLink.doQuery(member_key+"|", false);
		Vector rtnVector = new Vector() ;
		rtnVector.add(dbServletLink.getColumnData(tmpVector, 0)) ;
		rtnVector.add(dbServletLink.getColumnData(tmpVector, 1)) ;
		
		return rtnVector ;  	
	}
	// 체크리스트 구분코드 - 중분류
	public static Vector getChecklistGubun_Code_Mid(String param, String member_key) {
		DBServletLink dbServletLink = new DBServletLink();
        dbServletLink.connectURL("M000S010000E046");
        Vector tmpVector = dbServletLink.doQuery(param + member_key+"|", false);
		Vector rtnVector = new Vector() ;
		rtnVector.add(dbServletLink.getColumnData(tmpVector, 0)) ;
		rtnVector.add(dbServletLink.getColumnData(tmpVector, 1)) ;
		
		return rtnVector ;  	
	}
	// 체크리스트 구분코드 - 소분류
	public static Vector getChecklistGubun_Code_Sm(String param, String member_key) {
		DBServletLink dbServletLink = new DBServletLink();
        dbServletLink.connectURL("M000S010000E047");
        Vector tmpVector = dbServletLink.doQuery(param + member_key+"|", false);
		Vector rtnVector = new Vector() ;
		rtnVector.add(dbServletLink.getColumnData(tmpVector, 0)) ;
		rtnVector.add(dbServletLink.getColumnData(tmpVector, 1)) ;
		
		return rtnVector ;  	
	}
		
	//체크리스트구분코드(전체).  
	public static Vector getChecklistGubun_CodeALL(String member_key) {
		DBServletLink dbServletLink = new DBServletLink();
        dbServletLink.connectURL("M000S010000E037");
        
        Vector tmpVector = dbServletLink.doQuery(member_key+"|", false);
        // 코드추가(ALL)
        Vector codeVector = dbServletLink.getColumnData(tmpVector, 0);
        codeVector.insertElementAt("ALL", 0);
        // 이름추가(전체)
        Vector nameVector = dbServletLink.getColumnData(tmpVector, 1);
        nameVector.insertElementAt("전체", 0);
        // 합체
		Vector rtnVector = new Vector() ;
		rtnVector.add(codeVector) ;
		rtnVector.add(nameVector) ;
		
		return rtnVector ;  	
	}
	
	//체크리스트구분코드.  
	public static Vector getChecklistGubun_PIN_SHIP_Code(String member_key) {
		DBServletLink dbServletLink = new DBServletLink();
        dbServletLink.connectURL("M000S010000E137");
        Vector tmpVector = dbServletLink.doQuery(member_key+"|", false);
		Vector rtnVector = new Vector() ;
		rtnVector.add(dbServletLink.getColumnData(tmpVector, 0)) ;
		rtnVector.add(dbServletLink.getColumnData(tmpVector, 1)) ;
		
		return rtnVector ;  	
	}
	//체크리스트구분코드(출하검사,자주검사)(전체).  
	public static Vector getChecklistGubun_PIN_SHIP_CodeALL(String member_key) {
		DBServletLink dbServletLink = new DBServletLink();
        dbServletLink.connectURL("M000S010000E137");
        
        Vector tmpVector = dbServletLink.doQuery(member_key+"|", false);
        // 코드추가(ALL)
        Vector codeVector = dbServletLink.getColumnData(tmpVector, 0);
        codeVector.insertElementAt("ALL", 0);
        // 이름추가(전체)
        Vector nameVector = dbServletLink.getColumnData(tmpVector, 1);
        nameVector.insertElementAt("전체", 0);
        // 합체
		Vector rtnVector = new Vector() ;
		rtnVector.add(codeVector) ;
		rtnVector.add(nameVector) ;
		
		return rtnVector ;  	
	}
	
	//체크리스트구분코드.  
	public static Vector getChecklistGubun_IMPORT_Code(String member_key) {
		DBServletLink dbServletLink = new DBServletLink();
        dbServletLink.connectURL("M000S010000E138");
        Vector tmpVector = dbServletLink.doQuery(member_key+"|", false);
		Vector rtnVector = new Vector() ;
		rtnVector.add(dbServletLink.getColumnData(tmpVector, 0)) ;
		rtnVector.add(dbServletLink.getColumnData(tmpVector, 1)) ;
		
		return rtnVector ;  	
	}
	//체크리스트구분코드(출하검사,자주검사)(전체).  
	public static Vector getChecklistGubun_IMPORT_CodeALL(String member_key) {
		DBServletLink dbServletLink = new DBServletLink();
        dbServletLink.connectURL("M000S010000E138");
        
        Vector tmpVector = dbServletLink.doQuery(member_key+"|", false);
        // 코드추가(ALL)
        Vector codeVector = dbServletLink.getColumnData(tmpVector, 0);
        codeVector.insertElementAt("ALL", 0);
        // 이름추가(전체)
        Vector nameVector = dbServletLink.getColumnData(tmpVector, 1);
        nameVector.insertElementAt("전체", 0);
        // 합체
		Vector rtnVector = new Vector() ;
		rtnVector.add(codeVector) ;
		rtnVector.add(nameVector) ;
		
		return rtnVector ;  	
	}

	//부적합/시정조치 처리방법코드. 
	public static Vector getIncong_Method() {
        DBServletLink dbServletLink = new DBServletLink();
        dbServletLink.connectURL("M000S010000E039");
        Vector tmpVector = dbServletLink.doQuery(Session.SS_MAIN_CODE, false);
		Vector rtnVector = new Vector() ;
		rtnVector.add(dbServletLink.getColumnData(tmpVector, 0)) ;
		rtnVector.add(dbServletLink.getColumnData(tmpVector, 1)) ;
		
		return rtnVector ;
	}
	
	//부적합/시정조치 처리방법코드.  
	public static Vector getIncong_MethodALL() {
        DBServletLink dbServletLink = new DBServletLink();
        dbServletLink.connectURL("M000S010000E039");
        
        Vector tmpVector = dbServletLink.doQuery(Session.SS_MAIN_CODE, false);
        // 코드추가(ALL)
        Vector codeVector = dbServletLink.getColumnData(tmpVector, 0);
        codeVector.insertElementAt("ALL", 0);
        // 이름추가(전체)
        Vector nameVector = dbServletLink.getColumnData(tmpVector, 1);
        nameVector.insertElementAt("전체", 0);
        // 합체
		Vector rtnVector = new Vector() ;
		rtnVector.add(codeVector) ;
		rtnVector.add(nameVector) ;
		
		return rtnVector ;
	}
	


	// 제품검사구분코드
	public static Vector getProductCheckGubun_Code() {
        DBServletLink dbServletLink = new DBServletLink();
        dbServletLink.connectURL("M000S010000E038");
        Vector tmpVector = dbServletLink.doQuery(Session.SS_MAIN_CODE, false);
		Vector rtnVector = new Vector() ;
		rtnVector.add(dbServletLink.getColumnData(tmpVector, 0)) ;
		rtnVector.add(dbServletLink.getColumnData(tmpVector, 1)) ;
		
		return rtnVector ;
	}
	
	//제품검사구분코드 All.  
	public static Vector getProductCheckGubun_CodeAll() {
        DBServletLink dbServletLink = new DBServletLink();
        dbServletLink.connectURL("M000S010000E038");
        
        Vector tmpVector = dbServletLink.doQuery(Session.SS_MAIN_CODE, false);
        // 코드추가(ALL)
        Vector codeVector = dbServletLink.getColumnData(tmpVector, 0);
        codeVector.insertElementAt("ALL", 0);
        // 이름추가(전체)
        Vector nameVector = dbServletLink.getColumnData(tmpVector, 1);
        nameVector.insertElementAt("전체", 0);
        // 합체
		Vector rtnVector = new Vector() ;
		rtnVector.add(codeVector) ;
		rtnVector.add(nameVector) ;
		
		return rtnVector ;
	}
	
	// 제품구성구분코드
	public static Vector getUnitGubun(String member_key) {
        DBServletLink dbServletLink = new DBServletLink();
        dbServletLink.connectURL("M000S010000E071");
        Vector tmpVector = dbServletLink.doQuery(member_key+"|", false);
		Vector rtnVector = new Vector() ;
		rtnVector.add(dbServletLink.getColumnData(tmpVector, 0)) ;
		rtnVector.add(dbServletLink.getColumnData(tmpVector, 1)) ;
		
		return rtnVector ;
	}
	
	// 용도(제품그룹)코드,이름 반환. 
	public static Vector getYongdoData() {
        DBServletLink dbServletLink = new DBServletLink();
        dbServletLink.connectURL("M000S010000E040");
        Vector tmpVector = dbServletLink.doQuery(Session.SS_MAIN_CODE, false);
		Vector rtnVector = new Vector() ;

        // 코드추가(ALL)
        Vector codeVector = dbServletLink.getColumnData(tmpVector, 0);
        codeVector.insertElementAt("ALL", 0);
        // 이름추가(전체)
        Vector nameVector = dbServletLink.getColumnData(tmpVector, 1);
        nameVector.insertElementAt("전체", 0);
        // 합체
        
		rtnVector.add(dbServletLink.getColumnData(tmpVector, 0)) ;
		rtnVector.add(dbServletLink.getColumnData(tmpVector, 1)) ;
		rtnVector.add(dbServletLink.getColumnData(tmpVector, 2)) ;
		
		return rtnVector ;
	}
	
	

	// 부서구분코드
	public static Vector getDeptCode(String member_key) {
        DBServletLink dbServletLink = new DBServletLink();
        dbServletLink.connectURL("M000S010000E041");
        Vector tmpVector = dbServletLink.doQuery(member_key+"|", false);
		Vector rtnVector = new Vector() ;
		rtnVector.add(dbServletLink.getColumnData(tmpVector, 0)) ;
		rtnVector.add(dbServletLink.getColumnData(tmpVector, 1)) ;
		
		return rtnVector ;
	}
	
	//부서구분코드 All.  
	public static Vector getDeptCodeAll(String member_key) {
        DBServletLink dbServletLink = new DBServletLink();
        dbServletLink.connectURL("M000S010000E041");
        
        Vector tmpVector = dbServletLink.doQuery(member_key+"|", false);
        // 코드추가(ALL)
        Vector codeVector = dbServletLink.getColumnData(tmpVector, 0);
        codeVector.insertElementAt("ALL", 0);
        // 이름추가(전체)
        Vector nameVector = dbServletLink.getColumnData(tmpVector, 1);
        nameVector.insertElementAt("전체", 0);
        // 합체
		Vector rtnVector = new Vector() ;
		rtnVector.add(codeVector) ;
		rtnVector.add(nameVector) ;
		
		return rtnVector ;
	}


	// 문서파기사유
	public static Vector getDistroyReason(String member_key) {
        DBServletLink dbServletLink = new DBServletLink();
        dbServletLink.connectURL("M000S010000E042");
        Vector tmpVector = dbServletLink.doQuery(member_key+"|", false);
		Vector rtnVector = new Vector() ;
		rtnVector.add(dbServletLink.getColumnData(tmpVector, 0)) ;
		rtnVector.add(dbServletLink.getColumnData(tmpVector, 1)) ;
		
		return rtnVector ;
	}
	
	//문서파기사유 All.  
	public static Vector getDistroyReasonAll(String member_key) {
        DBServletLink dbServletLink = new DBServletLink();
        dbServletLink.connectURL("M000S010000E042");
        
        Vector tmpVector = dbServletLink.doQuery(member_key+"|", false);
        // 코드추가(ALL)
        Vector codeVector = dbServletLink.getColumnData(tmpVector, 0);
        codeVector.insertElementAt("ALL", 0);
        // 이름추가(전체)
        Vector nameVector = dbServletLink.getColumnData(tmpVector, 1);
        nameVector.insertElementAt("전체", 0);
        // 합체
		Vector rtnVector = new Vector() ;
		rtnVector.add(codeVector) ;
		rtnVector.add(nameVector) ;
		
		return rtnVector ;
	}


	// 공정구분코드
	public static Vector getProcess_gubun(String member_key) {
        DBServletLink dbServletLink = new DBServletLink();
        dbServletLink.connectURL("M000S010000E043");
        Vector tmpVector = dbServletLink.doQuery(member_key+"|", false);
		Vector rtnVector = new Vector() ;
		rtnVector.add(dbServletLink.getColumnData(tmpVector, 0)) ;
		rtnVector.add(dbServletLink.getColumnData(tmpVector, 1)) ;
		
		return rtnVector ;
	}
	
	//공정구분대분류코드.  
	public static Vector getProcess_gubun_big(String gubun,String member_key) {
        DBServletLink dbServletLink = new DBServletLink();
        dbServletLink.connectURL("M000S010000E044");
        Vector tmpVector = dbServletLink.doQuery(gubun + "|"+ member_key + "|", false);

		Vector rtnVector = new Vector() ;
		rtnVector.add(dbServletLink.getColumnData(tmpVector, 0)) ;
		rtnVector.add(dbServletLink.getColumnData(tmpVector, 1)) ;
		
		return rtnVector ;
	}
	
	//공정구분 중분류 코드.  
	public static Vector getProcess_gubun_mid(String gubun, String gubun_big) {
		DBServletLink dbServletLink = new DBServletLink();
        dbServletLink.connectURL("M000S010000E048");
        Vector tmpVector = dbServletLink.doQuery(gubun + "|" + gubun_big + "|", false);
		Vector rtnVector = new Vector() ;
		rtnVector.add(dbServletLink.getColumnData(tmpVector, 0)) ;
		rtnVector.add(dbServletLink.getColumnData(tmpVector, 1)) ;
		
		return rtnVector ;	
	}
	
	//공정구분코드 All.  
	public static Vector getProcessGubun_CodeAll(String member_key) {
		DBServletLink dbServletLink = new DBServletLink();
        dbServletLink.connectURL("M000S010000E043");
        
        Vector tmpVector = dbServletLink.doQuery(member_key+"|", false);
        // 코드추가(ALL)
        Vector codeVector = dbServletLink.getColumnData(tmpVector, 0);
        codeVector.insertElementAt("", 0);
        // 이름추가(전체)
        Vector nameVector = dbServletLink.getColumnData(tmpVector, 1);
        nameVector.insertElementAt("전체", 0);
        // 합체
		Vector rtnVector = new Vector() ;
		rtnVector.add(codeVector) ;
		rtnVector.add(nameVector) ;
		
		return rtnVector ;    
	}
	

	//CCP위해요소구분코드 All.  
	public static Vector getccpGubun_CodeAll() {
		DBServletLink dbServletLink = new DBServletLink();
        dbServletLink.connectURL("M000S010000E045");
        
        Vector tmpVector = dbServletLink.doQuery(Session.SS_MAIN_CODE, false);
        // 코드추가(ALL)
        Vector codeVector = dbServletLink.getColumnData(tmpVector, 0);
        codeVector.insertElementAt("", 0);
        // 이름추가(전체)
        Vector nameVector = dbServletLink.getColumnData(tmpVector, 1);
        nameVector.insertElementAt("전체", 0);
        // 합체
		Vector rtnVector = new Vector() ;
		rtnVector.add(codeVector) ;
		rtnVector.add(nameVector) ;
		
		return rtnVector ;    
	}
	
	
	// 본사담당자(사용자)
	public static Vector getUserData() {
        DBServletLink dbServletLink = new DBServletLink();
        dbServletLink.connectURL("M000S01000E050");
        Vector tmpVector = dbServletLink.doQuery(Session.SS_MAIN_CODE, false);
		Vector rtnVector = new Vector() ;
		rtnVector.add(dbServletLink.getColumnData(tmpVector, 0)) ;
		rtnVector.add(dbServletLink.getColumnData(tmpVector, 1)) ;
		
		return rtnVector ;
	}
	// 본사담당자(사용자)
	public static Vector getUserDataAll() {
        DBServletLink dbServletLink = new DBServletLink();
        dbServletLink.connectURL("M000S010000E050");
        Vector tmpVector = dbServletLink.doQuery(Session.SS_MAIN_CODE, false);
        // 코드추가(ALL)
        Vector codeVector = dbServletLink.getColumnData(tmpVector, 0);
        codeVector.insertElementAt("ALL", 0);
        // 이름추가(전체)
        Vector nameVector = dbServletLink.getColumnData(tmpVector, 1);
        nameVector.insertElementAt("전체", 0);
        // 합체
		Vector rtnVector = new Vector() ;
		rtnVector.add(codeVector) ;
		rtnVector.add(nameVector) ;
		
		return rtnVector ;
	}
	// 본사담당자(사용자)
	public static Vector getUserDataDefault() {
        DBServletLink dbServletLink = new DBServletLink();
        dbServletLink.connectURL("M000S010000E050");
        Vector tmpVector = dbServletLink.doQuery(Session.SS_MAIN_CODE, false);
        // 코드추가(ALL)
        Vector codeVector = dbServletLink.getColumnData(tmpVector, 0);
        codeVector.insertElementAt("DEFAULT", 0);
        // 이름추가(전체)
        Vector nameVector = dbServletLink.getColumnData(tmpVector, 1);
        nameVector.insertElementAt("선택", 0);
        // 합체
		Vector rtnVector = new Vector() ;
		rtnVector.add(codeVector) ;
		rtnVector.add(nameVector) ;
		
		return rtnVector ;
	}
	
	// 설비목록
	public static Vector getSeolbiData() {
		DBServletLink dbServletLink = new DBServletLink();
	    dbServletLink.connectURL("M000S010000E051");
	    Vector tmpVector = dbServletLink.doQuery(Session.SS_MAIN_CODE, false);
		Vector rtnVector = new Vector() ;
		rtnVector.add(dbServletLink.getColumnData(tmpVector, 0)) ;
		rtnVector.add(dbServletLink.getColumnData(tmpVector, 1)) ;
			
		return rtnVector ;
	}

	// 단위
	public static Vector getUnitDataDefault() {
        DBServletLink dbServletLink = new DBServletLink();
        dbServletLink.connectURL("M000S010000E070");
        Vector tmpVector = dbServletLink.doQuery(Session.SS_MAIN_CODE, false);
        // 코드추가(ALL)
        Vector codeVector = dbServletLink.getColumnData(tmpVector, 0);
//        codeVector.insertElementAt("DEFAULT", 0);
        // 이름추가(전체)
        Vector nameVector = dbServletLink.getColumnData(tmpVector, 1);
//        nameVector.insertElementAt("선택", 0);
        // 합체
		Vector rtnVector = new Vector() ;
		rtnVector.add(codeVector) ;
		rtnVector.add(nameVector) ;
		
		return rtnVector ;
	}

	/////////////// 트리 ///////////////////////
	// 용도(제품그룹)
	public static Vector getYongdoTreeData() {
        DBServletLink dbServletLink = new DBServletLink();
        dbServletLink.connectURL("M000S02000E010");
        Vector rtnVector = dbServletLink.doQuery(Session.SS_MAIN_CODE, false);
		
		return rtnVector ;
	}

	// 사용자그룹
	public static Vector getUserGroupData(String member_key) {
        DBServletLink dbServletLink = new DBServletLink();
        dbServletLink.connectURL("M000S010000E060");
        Vector tmpVector = dbServletLink.doQuery(member_key+"|", false);
		Vector rtnVector = new Vector() ;
		rtnVector.add(dbServletLink.getColumnData(tmpVector, 0)) ;
		rtnVector.add(dbServletLink.getColumnData(tmpVector, 1)) ;
		
		return rtnVector ;
	}
	
	// 사용자그룹
	public static Vector getUserGroupDataID(String loginID, String member_key) {
		 System.out.println("로그인ID = "+loginID);
		 
		 DBServletLink dbServletLink = new DBServletLink();
		 dbServletLink.connectURL("M000S010000E061");
        Vector tmpVector = dbServletLink.doQuery(loginID + "|" + member_key +"|", false);
		Vector rtnVector = new Vector() ;
		rtnVector.add(dbServletLink.getColumnData(tmpVector, 0)) ;
		
		return rtnVector ;   
	 }
	 
	// 사용자이름
	public static Vector getUserRevDataID(String loginID, String member_key) {
		DBServletLink dbServletLink = new DBServletLink();
		dbServletLink.connectURL("M000S010000E062");
		Vector tmpVector = dbServletLink.doQuery(loginID + "|" + member_key + "|", false);
		Vector rtnVector = new Vector() ;
		rtnVector.add(dbServletLink.getColumnData(tmpVector, 0)) ;
		
		return rtnVector ;   
	}
	
	// 사용자ID목록
	public static Vector getUserID(String member_key) {
		DBServletLink dbServletLink = new DBServletLink();
		dbServletLink.connectURL("M000S010000E063");
		Vector tmpVector = dbServletLink.doQuery(member_key + "|", false);
		Vector rtnVector = new Vector() ;
		rtnVector.add(dbServletLink.getColumnData(tmpVector, 0)) ;
		rtnVector.add(dbServletLink.getColumnData(tmpVector, 1)) ;
		rtnVector.add(dbServletLink.getColumnData(tmpVector, 2)) ;
		return rtnVector ;   
		}

	public static Vector getProductData() {
		return (new Vector());
	}
	public static Vector getWorkData() {
		return (new Vector());
	}
	
	//------------------------------------------------------
	// 제품속성 추가 2017.06.29
	//------------------------------------------------------
	public static Vector getColorData() {
        DBServletLink dbServletLink = new DBServletLink();
        dbServletLink.connectURL("M000S010000E100");
        Vector tmpVector = dbServletLink.doQuery("PRDC|", false);
		Vector rtnVector = new Vector() ;
		rtnVector.add(dbServletLink.getColumnData(tmpVector, 0)) ;
		rtnVector.add(dbServletLink.getColumnData(tmpVector, 1)) ;
		rtnVector.add(dbServletLink.getColumnData(tmpVector, 2)) ;
		
		return rtnVector ;
	}
	public static Vector getUVData() {
        DBServletLink dbServletLink = new DBServletLink();
        dbServletLink.connectURL("M000S010000E100");
        Vector tmpVector = dbServletLink.doQuery("PRDV|", false);
		Vector rtnVector = new Vector() ;
		rtnVector.add(dbServletLink.getColumnData(tmpVector, 0)) ;
		rtnVector.add(dbServletLink.getColumnData(tmpVector, 1)) ;
		rtnVector.add(dbServletLink.getColumnData(tmpVector, 2)) ;
		
		return rtnVector ;
	}
	public static Vector getEmboData() {
        DBServletLink dbServletLink = new DBServletLink();
        dbServletLink.connectURL("M000S010000E100");
        Vector tmpVector = dbServletLink.doQuery("PRDM|", false);
		Vector rtnVector = new Vector() ;
		rtnVector.add(dbServletLink.getColumnData(tmpVector, 0)) ;
		rtnVector.add(dbServletLink.getColumnData(tmpVector, 1)) ;
		rtnVector.add(dbServletLink.getColumnData(tmpVector, 2)) ;
		
		return rtnVector ;
	}
	public static Vector getPrintData() {
        DBServletLink dbServletLink = new DBServletLink();
        dbServletLink.connectURL("M000S010000E100");
        Vector tmpVector = dbServletLink.doQuery("PRDP|", false);
		Vector rtnVector = new Vector() ;
		rtnVector.add(dbServletLink.getColumnData(tmpVector, 0)) ;
		rtnVector.add(dbServletLink.getColumnData(tmpVector, 1)) ;
		rtnVector.add(dbServletLink.getColumnData(tmpVector, 2)) ;
		
		return rtnVector ;
	}
	public static Vector getSensorData() {
        DBServletLink dbServletLink = new DBServletLink();
        dbServletLink.connectURL("M000S010000E100");
        Vector tmpVector = dbServletLink.doQuery("PRDS|", false);
		Vector rtnVector = new Vector() ;
		rtnVector.add(dbServletLink.getColumnData(tmpVector, 0)) ;
		rtnVector.add(dbServletLink.getColumnData(tmpVector, 1)) ;
		rtnVector.add(dbServletLink.getColumnData(tmpVector, 2)) ;
		
		return rtnVector ;
	}
	

	public static Vector getProcessCodeAll() {
        DBServletLink dbServletLink = new DBServletLink();
        dbServletLink.connectURL("M000S010000E469");
        Vector tmpVector = dbServletLink.doQuery("%", false);
        // 코드추가(ALL)
        Vector codeVector = dbServletLink.getColumnData(tmpVector, 0);
        codeVector.insertElementAt("ALL", 0);
        // 이름추가(전체)
        Vector nameVector = dbServletLink.getColumnData(tmpVector, 1);
        nameVector.insertElementAt("전체", 0);
        // 밸류추가
        Vector valueVector = dbServletLink.getColumnData(tmpVector, 2);
        valueVector.insertElementAt("ALL", 0);
        // 합체
		Vector rtnVector = new Vector() ;
		rtnVector.add(codeVector) ;
		rtnVector.add(nameVector) ;
		rtnVector.add(valueVector) ;
		
		return rtnVector ;
	}
	
	/*공정코드 대분류*/
	public static Vector getWorkClassCdData() {
        DBServletLink dbServletLink = new DBServletLink();
        dbServletLink.connectURL("M000S010000E470");
        Vector tmpVector = dbServletLink.doQuery("%", false);
		Vector rtnVector = new Vector() ;
		rtnVector.add(dbServletLink.getColumnData(tmpVector, 0)) ;
		rtnVector.add(dbServletLink.getColumnData(tmpVector, 1)) ;
		rtnVector.add(dbServletLink.getColumnData(tmpVector, 2)) ;
		
		return rtnVector ;
	}	
	public static Vector getWorkClassCdDataAll() {
        DBServletLink dbServletLink = new DBServletLink();
        dbServletLink.connectURL("M000S010000E470");
        Vector tmpVector = dbServletLink.doQuery("%", false);
        // 코드추가(ALL)
        Vector codeVector = dbServletLink.getColumnData(tmpVector, 0);
        codeVector.insertElementAt("ALL", 0);
        // 이름추가(전체)
        Vector nameVector = dbServletLink.getColumnData(tmpVector, 1);
        nameVector.insertElementAt("전체", 0);
        // 밸류추가
        Vector valueVector = dbServletLink.getColumnData(tmpVector, 2);
        valueVector.insertElementAt("ALL", 0);
        // 합체
		Vector rtnVector = new Vector() ;
		rtnVector.add(codeVector) ;
		rtnVector.add(nameVector) ;
		rtnVector.add(valueVector) ;
		
		return rtnVector ;
	}

	/*공정코드 중분류*/
	public static Vector getmidClassCdData(String clsCode) {
        DBServletLink dbServletLink = new DBServletLink();
        dbServletLink.connectURL("M000S010000E471");
        Vector tmpVector = dbServletLink.doQuery(clsCode+"|", false);
		Vector rtnVector = new Vector() ;
		rtnVector.add(dbServletLink.getColumnData(tmpVector, 0)) ;
		rtnVector.add(dbServletLink.getColumnData(tmpVector, 1)) ;
		rtnVector.add(dbServletLink.getColumnData(tmpVector, 2)) ;
		
		return rtnVector ;
	}
	/*공정코드 중분류*/
	public static Vector getmidClassCodeData() {
        DBServletLink dbServletLink = new DBServletLink();
        dbServletLink.connectURL("M000S010000W471");
        Vector tmpVector = dbServletLink.doQuery("|", false);
		Vector rtnVector = new Vector() ;
		rtnVector.add(dbServletLink.getColumnData(tmpVector, 0)) ;
		rtnVector.add(dbServletLink.getColumnData(tmpVector, 1)) ;
		rtnVector.add(dbServletLink.getColumnData(tmpVector, 2)) ;
		
		return rtnVector ;
	}
	public static Vector getMidClassCdDataAll(String clsCode) {
        DBServletLink dbServletLink = new DBServletLink();
        dbServletLink.connectURL("M000S010000E471");
        Vector tmpVector = dbServletLink.doQuery(clsCode+"|", false);
        // 코드추가(ALL)
        Vector codeVector = dbServletLink.getColumnData(tmpVector, 0);
        codeVector.insertElementAt("ALL", 0);
        // 이름추가(전체)
        Vector nameVector = dbServletLink.getColumnData(tmpVector, 1);
        nameVector.insertElementAt("전체", 0);
        // 밸류추가
        Vector valueVector = dbServletLink.getColumnData(tmpVector, 2);
        valueVector.insertElementAt("ALL", 0);
        // 합체
		Vector rtnVector = new Vector() ;
		rtnVector.add(codeVector) ;
		rtnVector.add(nameVector) ;
		rtnVector.add(valueVector) ;
		
		return rtnVector ;
	}
	/*설비코드 대분류*/
	public static Vector getBigCdData() {
        DBServletLink dbServletLink = new DBServletLink();
        dbServletLink.connectURL("M000S010000E370");
        Vector tmpVector = dbServletLink.doQuery("%", false);
		Vector rtnVector = new Vector() ;
		rtnVector.add(dbServletLink.getColumnData(tmpVector, 0)) ;
		rtnVector.add(dbServletLink.getColumnData(tmpVector, 1)) ;
		rtnVector.add(dbServletLink.getColumnData(tmpVector, 2)) ;
		
		return rtnVector ;
	}	
	

	public static Vector getBigToolDataAll() {
        DBServletLink dbServletLink = new DBServletLink();
        dbServletLink.connectURL("M000S010000E379");
        Vector tmpVector = dbServletLink.doQuery("%", false);
        // 코드추가(ALL)
        Vector codeVector = dbServletLink.getColumnData(tmpVector, 0);
        codeVector.insertElementAt("ALL", 0);
        // 이름추가(전체)
        Vector nameVector = dbServletLink.getColumnData(tmpVector, 1);
        nameVector.insertElementAt("전체", 0);
        // 밸류추가
        Vector valueVector = dbServletLink.getColumnData(tmpVector, 2);
        valueVector.insertElementAt("ALL", 0);
        // 합체
		Vector rtnVector = new Vector() ;
		rtnVector.add(codeVector) ;
		rtnVector.add(nameVector) ;
		rtnVector.add(valueVector) ;
		
		return rtnVector ;
	}
	
	public static Vector getBigCdDataAll() {
        DBServletLink dbServletLink = new DBServletLink();
        dbServletLink.connectURL("M000S010000E370");
        Vector tmpVector = dbServletLink.doQuery("%", false);
        // 코드추가(ALL)
        Vector codeVector = dbServletLink.getColumnData(tmpVector, 0);
        codeVector.insertElementAt("ALL", 0);
        // 이름추가(전체)
        Vector nameVector = dbServletLink.getColumnData(tmpVector, 1);
        nameVector.insertElementAt("전체", 0);
        // 밸류추가
        Vector valueVector = dbServletLink.getColumnData(tmpVector, 2);
        valueVector.insertElementAt("ALL", 0);
        // 합체
		Vector rtnVector = new Vector() ;
		rtnVector.add(codeVector) ;
		rtnVector.add(nameVector) ;
		rtnVector.add(valueVector) ;
		
		return rtnVector ;
	}

	/*설비코드 중분류*/
	public static Vector getMidCdData(String clsCode) {
        DBServletLink dbServletLink = new DBServletLink();
        dbServletLink.connectURL("M000S010000E371");
        Vector tmpVector = dbServletLink.doQuery(clsCode+"|", false);
		Vector rtnVector = new Vector() ;
		rtnVector.add(dbServletLink.getColumnData(tmpVector, 0)) ;
		rtnVector.add(dbServletLink.getColumnData(tmpVector, 1)) ;
		rtnVector.add(dbServletLink.getColumnData(tmpVector, 2)) ;
		
		return rtnVector ;
	}
	public static Vector getMidCdDataAll(String clsCode) {
        DBServletLink dbServletLink = new DBServletLink();
        dbServletLink.connectURL("M000S010000E371");
        Vector tmpVector = dbServletLink.doQuery(clsCode+"|", false);
        // 코드추가(ALL)
        Vector codeVector = dbServletLink.getColumnData(tmpVector, 0);
        codeVector.insertElementAt("ALL", 0);
        // 이름추가(전체)
        Vector nameVector = dbServletLink.getColumnData(tmpVector, 1);
        nameVector.insertElementAt("전체", 0);
        // 밸류추가
        Vector valueVector = dbServletLink.getColumnData(tmpVector, 2);
        valueVector.insertElementAt("ALL", 0);
        // 합체
		Vector rtnVector = new Vector() ;
		rtnVector.add(codeVector) ;
		rtnVector.add(nameVector) ;
		rtnVector.add(valueVector) ;
		
		return rtnVector ;
	}

	/*설비보전 사유*/
	public static Vector getRepReasonData() {
        DBServletLink dbServletLink = new DBServletLink();
        dbServletLink.connectURL("M000S010000E372");
        Vector tmpVector = dbServletLink.doQuery("|", false);
		Vector rtnVector = new Vector() ;
		rtnVector.add(dbServletLink.getColumnData(tmpVector, 0)) ;
		rtnVector.add(dbServletLink.getColumnData(tmpVector, 1)) ;
		rtnVector.add(dbServletLink.getColumnData(tmpVector, 2)) ;
		
		return rtnVector ;
	}
	
//체크항목유형코드
	public static Vector getItemTypeCDAll(String member_key) {
        DBServletLink dbServletLink = new DBServletLink();
        dbServletLink.connectURL("M000S010000E360");
        Vector tmpVector = dbServletLink.doQuery(member_key+"|", false);
        // 코드추가(ALL)
        Vector codeVector = dbServletLink.getColumnData(tmpVector, 0);
        codeVector.insertElementAt("ALL", 0);
        // 이름추가(전체)
        Vector nameVector = dbServletLink.getColumnData(tmpVector, 1);
        nameVector.insertElementAt("전체", 0);
        // 밸류추가
        Vector valueVector = dbServletLink.getColumnData(tmpVector, 2);
        valueVector.insertElementAt("ALL", 0);
        // 합체
		Vector rtnVector = new Vector() ;
		rtnVector.add(codeVector) ;
		rtnVector.add(nameVector) ;
		rtnVector.add(valueVector) ;
		
		return rtnVector ;
	}	
	/*BOM코드*/
	public static Vector getBomCodeData(String GIJONG_CODE) {
        DBServletLink dbServletLink = new DBServletLink();
        dbServletLink.connectURL("M000S010000E380");
        Vector tmpVector = dbServletLink.doQuery(GIJONG_CODE + "|", false);
		Vector rtnVector = new Vector() ;
		rtnVector.add(dbServletLink.getColumnData(tmpVector, 0)) ; //BOM_seq
		rtnVector.add(dbServletLink.getColumnData(tmpVector, 1)) ; //BOM_nm
		rtnVector.add(dbServletLink.getColumnData(tmpVector, 2)) ; //gijong_cd
		
		return rtnVector ;
	}

	/* 공통코드그룹 */
	public static Vector getCodeGroupDataAll(String member_key) {
        DBServletLink dbServletLink = new DBServletLink();
        dbServletLink.connectURL("M000S010000E600");
        Vector tmpVector = dbServletLink.doQuery(member_key+"|", false);
        // 코드추가(ALL)
        Vector codeVector = dbServletLink.getColumnData(tmpVector, 0);
        codeVector.insertElementAt("ALL", 0);
        // 이름추가(전체)
        Vector nameVector = dbServletLink.getColumnData(tmpVector, 1);
        nameVector.insertElementAt("ALL", 0);
        // 밸류추가
        Vector valueVector = dbServletLink.getColumnData(tmpVector, 2);
        valueVector.insertElementAt("ALL", 0);
        // 합체
		Vector rtnVector = new Vector() ;
		rtnVector.add(codeVector) ;
		rtnVector.add(nameVector) ;
		rtnVector.add(valueVector) ;
		
		return rtnVector ;
	}

	/* 
	* 설비그룹
	* 설비그룹에는 현재(2018-09-09), 계측기와 설비 그리고 지그가 있다. 
	*/
	public static Vector getSulbiGroupDataAll(String member_key) {
        DBServletLink dbServletLink = new DBServletLink();
        dbServletLink.connectURL("M000S010000E700");
        Vector tmpVector = dbServletLink.doQuery(member_key+"|", false);
        // 코드추가(ALL)
        Vector codeVector = dbServletLink.getColumnData(tmpVector, 0);
        codeVector.insertElementAt("ALL", 0);
        // 이름추가(전체)
        Vector nameVector = dbServletLink.getColumnData(tmpVector, 1);
        nameVector.insertElementAt("ALL", 0);
        // 밸류추가
        Vector valueVector = dbServletLink.getColumnData(tmpVector, 2);
        valueVector.insertElementAt("ALL", 0);
        // 합체
		Vector rtnVector = new Vector() ;
		rtnVector.add(codeVector) ;
		rtnVector.add(nameVector) ;
		rtnVector.add(valueVector) ;
		
		return rtnVector ;
	}

	/* 
	* 설비작업 구분
	* 설비그룹에는 현재(2018-09-11), 계측기와 설비 그리고 지그가 있다. 
	*/
	public static Vector getSulbiJobDataAll(String member_key) {
        DBServletLink dbServletLink = new DBServletLink();
        dbServletLink.connectURL("M000S010000E710");
        Vector tmpVector = dbServletLink.doQuery( member_key+"|", false);
        // 코드추가(ALL)
        Vector codeVector = dbServletLink.getColumnData(tmpVector, 0);
        codeVector.insertElementAt("ALL", 0);
        // 이름추가(전체)
        Vector nameVector = dbServletLink.getColumnData(tmpVector, 1);
        nameVector.insertElementAt("ALL", 0);
        // 밸류추가
        Vector valueVector = dbServletLink.getColumnData(tmpVector, 2);
        valueVector.insertElementAt("ALL", 0);
        // 합체
		Vector rtnVector = new Vector() ;
		rtnVector.add(codeVector) ;
		rtnVector.add(nameVector) ;
		rtnVector.add(valueVector) ;
		
		return rtnVector ;
	}

	
	/*통 sql*/
	public static Vector getQueryAll(String sql) {
		int i=0;
        DBServletLink dbServletLink = new DBServletLink();
        dbServletLink.connectURL("M000S010000E999");
        Vector tmpVector = dbServletLink.doQuery(sql, false);
		Vector rtnVector = new Vector() ;
		for (i=0; i<tmpVector.size(); i++) {
			rtnVector.add(dbServletLink.getColumnData(tmpVector, i)) ; //
			//rtnVector.add(dbServletLink.getColumnData(tmpVector, 1)) ; //
			//rtnVector.add(dbServletLink.getColumnData(tmpVector, 2)) ; //
		}
		return rtnVector ;
	}
	
	public static String getCodeCheck(String sql) {
		int i=0;
        DBServletLink dbServletLink = new DBServletLink();
        dbServletLink.connectURL("M08S46000E104");
        String tmpVector = dbServletLink.getColumnValue(sql, false);
//		Vector rtnVector = new Vector() ;
//		rtnVector.add(dbServletLink.getColumnData(tmpVector, 0)) ; //
//		rtnVector.add(dbServletLink.getColumnData(tmpVector, 1)) ; 
//		rtnVector.add(dbServletLink.getColumnData(tmpVector, 2)) ; 
		System.out.println("M08S46000E104==" + tmpVector);
		return tmpVector ;
	}
	
	//HACCP문서구분코드
	public static Vector getHDocGubunCDAll(String member_key) {
        DBServletLink dbServletLink = new DBServletLink();
        dbServletLink.connectURL("M000S010000E502");
        Vector tmpVector = dbServletLink.doQuery(member_key+"|", false);
        // 코드추가(ALL)
        Vector codeVector = dbServletLink.getColumnData(tmpVector, 0);
        codeVector.insertElementAt("ALL", 0);
        // 이름추가(전체)
        Vector nameVector = dbServletLink.getColumnData(tmpVector, 1);
        nameVector.insertElementAt("전체", 0);
        // 밸류추가
        Vector valueVector = dbServletLink.getColumnData(tmpVector, 2);
        valueVector.insertElementAt("ALL", 0);
        // 합체
		Vector rtnVector = new Vector() ;
		rtnVector.add(codeVector) ;
		rtnVector.add(nameVector) ;
		rtnVector.add(valueVector) ;
		
		return rtnVector ;
	}
	
	//체크항목유형코드
	public static Vector getDocGubunCDAll(String member_key) {
        DBServletLink dbServletLink = new DBServletLink();
        dbServletLink.connectURL("M000S010000E500");
        Vector tmpVector = dbServletLink.doQuery(member_key+"|", false);
        // 코드추가(ALL)
        Vector codeVector = dbServletLink.getColumnData(tmpVector, 0);
        codeVector.insertElementAt("ALL", 0);
        // 이름추가(전체)
        Vector nameVector = dbServletLink.getColumnData(tmpVector, 1);
        nameVector.insertElementAt("전체", 0);
        // 밸류추가
        Vector valueVector = dbServletLink.getColumnData(tmpVector, 2);
        valueVector.insertElementAt("ALL", 0);
        // 합체
		Vector rtnVector = new Vector() ;
		rtnVector.add(codeVector) ;
		rtnVector.add(nameVector) ;
		rtnVector.add(valueVector) ;
		
		return rtnVector ;
	}	
	
	//문서출처구분
	public static Vector getDocGubunRegAll(String member_key) {
        DBServletLink dbServletLink = new DBServletLink();
        dbServletLink.connectURL("M000S010000E501");
        Vector tmpVector = dbServletLink.doQuery(member_key+"|", false);
        // 코드추가(ALL)
        Vector codeVector = dbServletLink.getColumnData(tmpVector, 0);
        codeVector.insertElementAt("ALL", 0);
        // 이름추가(전체)
        Vector nameVector = dbServletLink.getColumnData(tmpVector, 1);
        nameVector.insertElementAt("전체", 0);
        // 밸류추가
        Vector valueVector = dbServletLink.getColumnData(tmpVector, 2);
        valueVector.insertElementAt("ALL", 0);
        // 합체
		Vector rtnVector = new Vector() ;
		rtnVector.add(codeVector) ;
		rtnVector.add(nameVector) ;
		rtnVector.add(valueVector) ;
		
		return rtnVector ;
	}	

	public static Vector getDocGubunReg(String member_key) {
        DBServletLink dbServletLink = new DBServletLink();
        dbServletLink.connectURL("M000S010000E501");
        Vector tmpVector = dbServletLink.doQuery(member_key+"|", false);
		Vector rtnVector = new Vector() ;
		rtnVector.add(dbServletLink.getColumnData(tmpVector, 0)) ;  
		rtnVector.add(dbServletLink.getColumnData(tmpVector, 1)) ;  
		rtnVector.add(dbServletLink.getColumnData(tmpVector, 2)) ;  
		
		return rtnVector ;
	}
	
	public static Vector getCheckItemCodeList(String member_key) {
        DBServletLink dbServletLink = new DBServletLink();
        dbServletLink.connectURL("M909S030100E304");
        Vector tmpVector = dbServletLink.doQuery(member_key+"|", false);
        // item_cd 추가
        Vector codeVector = dbServletLink.getColumnData(tmpVector, 0);
//        codeVector.insertElementAt("ALL[:]..", 0);
        // item_desc 추가
        Vector descVector = dbServletLink.getColumnData(tmpVector, 1);
//        descVector.insertElementAt("전체[:]..", 0);
        // item_bigo 추가
        Vector bigoVector = dbServletLink.getColumnData(tmpVector, 2);
//        bigoVector.insertElementAt("ALL[:]..", 0);
        // item_seq 추가
        Vector seqVector = dbServletLink.getColumnData(tmpVector, 3);
//        seqVector.insertElementAt("전체[:]..", 0);
        // revision_no 추가
        Vector revVector = dbServletLink.getColumnData(tmpVector, 4);
		Vector rtnVector = new Vector() ;
		
		rtnVector.add(codeVector) ;
		rtnVector.add(descVector) ;
		rtnVector.add(bigoVector) ;
		rtnVector.add(seqVector) ;
		rtnVector.add(revVector) ;
		
		return rtnVector ;
	}	

	public static Vector getCheckItemSeq4Code(String ITEM_CD) {
        DBServletLink dbServletLink = new DBServletLink();
        dbServletLink.connectURL("M909S030100E314");
        Vector tmpVector = dbServletLink.doQuery(ITEM_CD + "|", false);
        // 코드추가(ALL)
        Vector codeVector = dbServletLink.getColumnData(tmpVector, 0);
        codeVector.insertElementAt("ALL", 0);
        // 이름추가(전체)
        Vector nameVector = dbServletLink.getColumnData(tmpVector, 1);
        nameVector.insertElementAt("전체", 0);
        // SEQ추가
        Vector valueVector = dbServletLink.getColumnData(tmpVector, 2);
        valueVector.insertElementAt("ALL", 0);
        // 합체
		Vector rtnVector = new Vector() ;
		rtnVector.add(codeVector) ;
		rtnVector.add(nameVector) ;
		rtnVector.add(valueVector) ;
		
		return rtnVector ;
	}
	
	
	//원석
	public static Vector getPartCodeGroupBigDataAll() {
        DBServletLink dbServletLink = new DBServletLink();
        dbServletLink.connectURL("M000S010000E604");
        Vector tmpVector = dbServletLink.doQuery( "%|%", false);
        // 코드추가(ALL)
        Vector codeVector = dbServletLink.getColumnData(tmpVector, 0);
        codeVector.insertElementAt("선택해주세요", 0);
        // 이름추가(전체)
        Vector nameVector = dbServletLink.getColumnData(tmpVector, 1);
        nameVector.insertElementAt("선택해주세요", 0);
        // 밸류추가
        Vector valueVector = dbServletLink.getColumnData(tmpVector, 2);
        valueVector.insertElementAt("선택해주세요", 0);
        // 합체
		Vector rtnVector = new Vector() ;
		rtnVector.add(codeVector) ;
		rtnVector.add(nameVector) ;
		rtnVector.add(valueVector) ;
		
		return rtnVector ;
	}
		
	//원석
	public static Vector getPartCodeGroupMidDataAll() {
		DBServletLink dbServletLink = new DBServletLink();
		dbServletLink.connectURL("M000S010000E605");
		Vector tmpVector = dbServletLink.doQuery( "%|%", false);
		// 코드추가(ALL)
		Vector codeVector = dbServletLink.getColumnData(tmpVector, 0);
		codeVector.insertElementAt("선택해주세요", 0);
		// 이름추가(전체)
		Vector nameVector = dbServletLink.getColumnData(tmpVector, 1);
		nameVector.insertElementAt("선택해주세요", 0);
		// 밸류추가
		Vector valueVector = dbServletLink.getColumnData(tmpVector, 2);
		valueVector.insertElementAt("선택해주세요", 0);
		// 합체
		Vector rtnVector = new Vector() ;
		rtnVector.add(codeVector) ;
		rtnVector.add(nameVector) ;
		rtnVector.add(valueVector) ;
		
		return rtnVector ;
	}
		
	//원석
	public static Vector getPartCodeGroupSmDataAll() {
		DBServletLink dbServletLink = new DBServletLink();
		dbServletLink.connectURL("M000S010000E606");
		Vector tmpVector = dbServletLink.doQuery( "%|%", false);
		// 코드추가(ALL)
		Vector codeVector = dbServletLink.getColumnData(tmpVector, 0);
		codeVector.insertElementAt("선택해주세요", 0);
		// 이름추가(전체)
		Vector nameVector = dbServletLink.getColumnData(tmpVector, 1);
		nameVector.insertElementAt("선택해주세요", 0);
		// 밸류추가
		Vector valueVector = dbServletLink.getColumnData(tmpVector, 2);
		valueVector.insertElementAt("선택해주세요", 0);
		// 합체
		Vector rtnVector = new Vector() ;
		rtnVector.add(codeVector) ;
		rtnVector.add(nameVector) ;
		rtnVector.add(valueVector) ;
		
		return rtnVector ;
	}

	// 동범
	public static Vector getCensorType(JSONObject jArray) {
		DBServletLink dbServletLink = new DBServletLink();
		dbServletLink.connectURL("M909S170100E995");

		Vector Get_Censor_Type_Vector = dbServletLink.doQuery(jArray, false);

		Vector Result_Censor_Type_Vector = new Vector();

		Result_Censor_Type_Vector.add(dbServletLink.getColumnData(Get_Censor_Type_Vector, 0));
		Result_Censor_Type_Vector.add(dbServletLink.getColumnData(Get_Censor_Type_Vector, 1));

		return Result_Censor_Type_Vector;
	}
	// 동범
	public static Vector getCCPType(JSONObject jArray) {
		DBServletLink dbServletLink = new DBServletLink();
		dbServletLink.connectURL("M909S160100E995");

		Vector Get_CCP_Type_Vector = dbServletLink.doQuery(jArray, false);

		Vector Result_CCP_Type_Vector = new Vector();

		Result_CCP_Type_Vector.add(dbServletLink.getColumnData(Get_CCP_Type_Vector, 0));
		Result_CCP_Type_Vector.add(dbServletLink.getColumnData(Get_CCP_Type_Vector, 1));

		return Result_CCP_Type_Vector;
	}
	
	// 동범 (제품 대분류)
	public static Vector getProductBigGubun(boolean FLAG, String member_key) {
		Vector Get_Product_Big_Gubun_Vector = new Vector();
		Vector Result_Big_Gubun_Vector = new Vector() ;
		
		if( FLAG ) // 'ALL' 들어가는 버전
		{
			DBServletLink dbServletLink = new DBServletLink();
			dbServletLink.connectURL("M000S010000E904");

//			Get_Product_Big_Gubun_Vector = dbServletLink.doQuery(Session.SS_MAIN_CODE, false);
			Get_Product_Big_Gubun_Vector = dbServletLink.doQuery(member_key + "|", false);
		
			// 코드추가(ALL)
			Vector TempCodeVector = dbServletLink.getColumnData(Get_Product_Big_Gubun_Vector, 0);
			TempCodeVector.insertElementAt("ALL", 0);
		
			// 이름추가(전체)
			Vector TempNameVector = dbServletLink.getColumnData(Get_Product_Big_Gubun_Vector, 1);
			TempNameVector.insertElementAt("전체", 0);
		
			// 밸류추가
			Vector TempValueVector = dbServletLink.getColumnData(Get_Product_Big_Gubun_Vector, 2);
			TempValueVector.insertElementAt("ALL", 0);
		
			Result_Big_Gubun_Vector.add(TempCodeVector);
			Result_Big_Gubun_Vector.add(TempNameVector);
			Result_Big_Gubun_Vector.add(TempValueVector);

			return Result_Big_Gubun_Vector ;
		}
		else // 'ALL' 안들어가는 버전
		{
			DBServletLink dbServletLink = new DBServletLink();
			dbServletLink.connectURL("M000S010000E904");

//			Get_Product_Big_Gubun_Vector = dbServletLink.doQuery(Session.SS_MAIN_CODE, false);
			Get_Product_Big_Gubun_Vector = dbServletLink.doQuery(member_key + "|", false);

			Result_Big_Gubun_Vector.add(dbServletLink.getColumnData(Get_Product_Big_Gubun_Vector, 0));
			Result_Big_Gubun_Vector.add(dbServletLink.getColumnData(Get_Product_Big_Gubun_Vector, 1));

			return Result_Big_Gubun_Vector;
		}
	}
	
	
	
	// 동범 (제품 중분류)
		public static Vector getProductMidGubun(String gubun, boolean FLAG, String member_key) {
			Vector Get_Product_Mid_Gubun_Vector = new Vector();
			Vector Result_Mid_Gubun_Vector = new Vector() ;
			
			if( FLAG ) // 'ALL' 들어가는 버전
			{
				DBServletLink dbServletLink = new DBServletLink();
				dbServletLink.connectURL("M000S010000E914");

				Get_Product_Mid_Gubun_Vector = dbServletLink.doQuery(gubun + "|" + member_key + "|", false);

				// 코드추가(ALL)
				Vector TempCodeVector = dbServletLink.getColumnData(Get_Product_Mid_Gubun_Vector, 0);
				TempCodeVector.insertElementAt("ALL", 0);
			
				// 이름추가(전체)
				Vector TempNameVector = dbServletLink.getColumnData(Get_Product_Mid_Gubun_Vector, 1);
				TempNameVector.insertElementAt("전체", 0);
			
				// 밸류추가
				Vector TempValueVector = dbServletLink.getColumnData(Get_Product_Mid_Gubun_Vector, 2);
				TempValueVector.insertElementAt("ALL", 0);
			
				Result_Mid_Gubun_Vector.add(TempCodeVector);
				Result_Mid_Gubun_Vector.add(TempNameVector);
				Result_Mid_Gubun_Vector.add(TempValueVector);
				
				return Result_Mid_Gubun_Vector ;
			}
			else // 'ALL' 안들어가는 버전
			{
				DBServletLink dbServletLink = new DBServletLink();
				dbServletLink.connectURL("M000S010000E914");

				Get_Product_Mid_Gubun_Vector = dbServletLink.doQuery(gubun + "|" + member_key + "|", false);

				Result_Mid_Gubun_Vector.add(dbServletLink.getColumnData(Get_Product_Mid_Gubun_Vector, 0));
				Result_Mid_Gubun_Vector.add(dbServletLink.getColumnData(Get_Product_Mid_Gubun_Vector, 1));

				return Result_Mid_Gubun_Vector;
			}
		}
		
		// 제품명
				public static Vector getProductName(String big_gubun, String mid_gubun, boolean FLAG, String member_key) {
					Vector Get_Product_Name_Vector = new Vector();
					Vector Result_Name_Vector = new Vector() ;
					
					if( FLAG ) // 'ALL' 들어가는 버전
					{
						DBServletLink dbServletLink = new DBServletLink();
						dbServletLink.connectURL("M000S010000E924");

						Get_Product_Name_Vector = dbServletLink.doQuery(big_gubun + "|" + mid_gubun + "|" + member_key + "|", false);

						// 코드추가(ALL)
						Vector TempCodeVector = dbServletLink.getColumnData(Get_Product_Name_Vector, 0);
						TempCodeVector.insertElementAt("ALL", 0);
					
						// 이름추가(분류 선택 필요)
						Vector TempNameVector = dbServletLink.getColumnData(Get_Product_Name_Vector, 1);
						TempNameVector.insertElementAt("분류를 선택해 주세요", 0);
					
						Result_Name_Vector.add(TempCodeVector);
						Result_Name_Vector.add(TempNameVector);
						
						return Result_Name_Vector ;
					}
					else // 'ALL' 안들어가는 버전
					{
						DBServletLink dbServletLink = new DBServletLink();
						dbServletLink.connectURL("M000S010000E924");

						Get_Product_Name_Vector = dbServletLink.doQuery(big_gubun + "|" + mid_gubun + "|" + member_key + "|", false);

						Result_Name_Vector.add(dbServletLink.getColumnData(Get_Product_Name_Vector, 1));

						return Result_Name_Vector;
					}
				}
		
		
		
	
	
	public static boolean getProductMidGubunSize(JSONObject jArray) {
		DBServletLink dbServletLink = new DBServletLink();
		dbServletLink.connectURL("M909S060100E998");

		return dbServletLink.doQuery(jArray, false).isEmpty();
	}
	
	public static boolean getProductNameSize(JSONObject jArray) {
		DBServletLink dbServletLink = new DBServletLink();
		dbServletLink.connectURL("M909S060100E1002");

		return dbServletLink.doQuery(jArray, false).isEmpty();
	}
	
	public static Vector getProductBigGubunCodeMaxNumber(JSONObject jArray) {
		DBServletLink dbServletLink = new DBServletLink();
		dbServletLink.connectURL("M909S060100E996");

		Vector Get_Gubun_Code_Max_Number = dbServletLink.doQuery(jArray, false);

		return (Vector)Get_Gubun_Code_Max_Number.get(0);
	}
	
	public static Vector getProductMidGubunCodeMaxNumber(JSONObject jArray) {
		DBServletLink dbServletLink = new DBServletLink();
		dbServletLink.connectURL("M909S060100E997");

		Vector Get_Gubun_Code_Max_Number = dbServletLink.doQuery(jArray, false);

		return (Vector)Get_Gubun_Code_Max_Number.get(0);
	}
	
	public static Vector Get_Part_Info_List(String member_key) {
		Vector Get_Part_Info_List = new Vector();
		Vector Result_Part_Info_List = new Vector() ;
		
		DBServletLink dbServletLink = new DBServletLink();
		dbServletLink.connectURL("M838S060700E904");

		Get_Part_Info_List = dbServletLink.doQuery(member_key + "|", false);

		Vector PartCodeVector = dbServletLink.getColumnData(Get_Part_Info_List, 0);
		Vector PartNameVector = dbServletLink.getColumnData(Get_Part_Info_List, 1);
		Vector CompanyCodeVector = dbServletLink.getColumnData(Get_Part_Info_List, 2);
		Vector CompanyNameVector = dbServletLink.getColumnData(Get_Part_Info_List, 3);
		Vector CompanyAddressVector = dbServletLink.getColumnData(Get_Part_Info_List, 4);
		Vector CompanyRevisionNumberVector = dbServletLink.getColumnData(Get_Part_Info_List, 5);
	
		Result_Part_Info_List.add(PartCodeVector);
		Result_Part_Info_List.add(PartNameVector);
		Result_Part_Info_List.add(CompanyCodeVector);
		Result_Part_Info_List.add(CompanyNameVector);
		Result_Part_Info_List.add(CompanyAddressVector);
		Result_Part_Info_List.add(CompanyRevisionNumberVector);
		
		return Result_Part_Info_List ;
	}
	
	//ccp 센서명 목록
	public static Vector getCensorGubun_Name(String[] strArr) {
		DBServletLink dbServletLink = new DBServletLink();
        dbServletLink.connectURL("M000S010000E806");
        
        String typeStr = "";
		for(int i=0; i<strArr.length; i++) {	
			typeStr += "'"+strArr[i] + ((i==(strArr.length-1))?"'":"',");
		}
        
        Vector tmpVector = dbServletLink.doQuery(typeStr, false);
        // 센서명추가(전체)
        Vector NameVector = dbServletLink.getColumnData(tmpVector, 0);
        NameVector.insertElementAt("전체", 0);
        
        // 합체
		Vector rtnVector = new Vector() ;
		rtnVector.add(NameVector) ;
		
		return rtnVector ;  	
	}
	
	//ccp 센서타입 목록
	public static Vector getCensorGubun_Type(String[] strArr) {
		DBServletLink dbServletLink = new DBServletLink();
        dbServletLink.connectURL("M000S010000E807");
        
		String typeStr = "";
		for(int i=0; i<strArr.length; i++) {	
			typeStr += "'"+strArr[i] + ((i==(strArr.length-1))?"'":"',");
		}
        
        Vector tmpVector = dbServletLink.doQuery(typeStr, false);
        // 센서타입추가(전체)
        Vector TypeVector = dbServletLink.getColumnData(tmpVector, 0);
        TypeVector.insertElementAt("전체", 0);
        
        // 합체
		Vector rtnVector = new Vector() ;
		rtnVector.add(TypeVector) ;
		
		return rtnVector ;  	
	}
		
	//ccp 센서위치 목록
	public static Vector getCensorGubun_Location(String[] strArr) {
		DBServletLink dbServletLink = new DBServletLink();
        dbServletLink.connectURL("M000S010000E808");
        
        String typeStr = "";
		for(int i=0; i<strArr.length; i++) {	
			typeStr += "'"+strArr[i] + ((i==(strArr.length-1))?"'":"',");
		}
        
        Vector tmpVector = dbServletLink.doQuery(typeStr, false);
        //센서위치 추가(전체)
        Vector LocationVector = dbServletLink.getColumnData(tmpVector, 0);
        LocationVector.insertElementAt("전체", 0);
        
        // 합체
		Vector rtnVector = new Vector() ;
		rtnVector.add(LocationVector) ;
		
		return rtnVector;
	}
	
	// 완제품 입고 타입
	public static Vector getProdIpgoType() {
        DBServletLink dbServletLink = new DBServletLink();
        dbServletLink.connectURL("M000S010100E004");

        Vector tmpVector = dbServletLink.doQuery("%", false);
        
        Vector codeVector = dbServletLink.getColumnData(tmpVector, 0);
        Vector valueVector = dbServletLink.getColumnData(tmpVector, 1);
        Vector nameVector = dbServletLink.getColumnData(tmpVector, 2);

        Vector rtnVector = new Vector() ;
		
		rtnVector.add(codeVector) ;
		rtnVector.add(valueVector) ;
		rtnVector.add(nameVector) ;
		
		return rtnVector;
	}
	
	// 완제품 출고 타입
	public static Vector getProdChulgoType() {
        DBServletLink dbServletLink = new DBServletLink();
        dbServletLink.connectURL("M000S010100E014");

        Vector tmpVector = dbServletLink.doQuery("%", false);
        
        Vector codeVector = dbServletLink.getColumnData(tmpVector, 0);
        Vector valueVector = dbServletLink.getColumnData(tmpVector, 1);
        Vector nameVector = dbServletLink.getColumnData(tmpVector, 2);

        Vector rtnVector = new Vector() ;
		
		rtnVector.add(codeVector) ;
		rtnVector.add(valueVector) ;
		rtnVector.add(nameVector) ;
		
		return rtnVector;
	}

	// 원부자재 입고 타입
	public static Vector getPartIpgoType() {
        DBServletLink dbServletLink = new DBServletLink();
        dbServletLink.connectURL("M000S010100E024");

        Vector tmpVector = dbServletLink.doQuery("%", false);
        
        Vector codeVector = dbServletLink.getColumnData(tmpVector, 0);
        Vector valueVector = dbServletLink.getColumnData(tmpVector, 1);
        Vector nameVector = dbServletLink.getColumnData(tmpVector, 2);

        Vector rtnVector = new Vector() ;
		
		rtnVector.add(codeVector) ;
		rtnVector.add(valueVector) ;
		rtnVector.add(nameVector) ;
		
		return rtnVector;
	}
	
	// 원부자재 출고 타입
	public static Vector getPartChulgoType() {
        DBServletLink dbServletLink = new DBServletLink();
        dbServletLink.connectURL("M000S010100E034");

        Vector tmpVector = dbServletLink.doQuery("%", false);
        
        Vector codeVector = dbServletLink.getColumnData(tmpVector, 0);
        Vector valueVector = dbServletLink.getColumnData(tmpVector, 1);
        Vector nameVector = dbServletLink.getColumnData(tmpVector, 2);

        Vector rtnVector = new Vector() ;
		
		rtnVector.add(codeVector) ;
		rtnVector.add(valueVector) ;
		rtnVector.add(nameVector) ;
		
		return rtnVector ;
	}
	
	// 주문 타입
	public static Vector getOrderType() {
        DBServletLink dbServletLink = new DBServletLink();
        dbServletLink.connectURL("M000S010100E044");

        Vector tmpVector = dbServletLink.doQuery("%", false);
        
        Vector codeVector = dbServletLink.getColumnData(tmpVector, 0);
        Vector valueVector = dbServletLink.getColumnData(tmpVector, 1);
        Vector nameVector = dbServletLink.getColumnData(tmpVector, 2);

        Vector rtnVector = new Vector() ;
		
		rtnVector.add(codeVector) ;
		rtnVector.add(valueVector) ;
		rtnVector.add(nameVector) ;
		
		return rtnVector ;
	}
	
	// 생산계획 타입
	public static Vector getProdPlanType() {
        DBServletLink dbServletLink = new DBServletLink();
        dbServletLink.connectURL("M000S010100E054");

        Vector tmpVector = dbServletLink.doQuery("%", false);
        
        Vector codeVector = dbServletLink.getColumnData(tmpVector, 0);
        Vector valueVector = dbServletLink.getColumnData(tmpVector, 1);
        Vector nameVector = dbServletLink.getColumnData(tmpVector, 2);

        Vector rtnVector = new Vector() ;
		
		rtnVector.add(codeVector) ;
		rtnVector.add(valueVector) ;
		rtnVector.add(nameVector) ;
		
		return rtnVector ;
	}
	
	// 배송차량 종류
	public static Vector getVehicleType() {
        DBServletLink dbServletLink = new DBServletLink();
        dbServletLink.connectURL("M000S010100E064");

        Vector tmpVector = dbServletLink.doQuery("%", false);
        
        Vector codeVector = dbServletLink.getColumnData(tmpVector, 0);
        Vector nameVector = dbServletLink.getColumnData(tmpVector, 1);
        Vector revnoVector = dbServletLink.getColumnData(tmpVector, 2);

        Vector rtnVector = new Vector();
		
		rtnVector.add(codeVector);
		rtnVector.add(nameVector);
		rtnVector.add(revnoVector);
		
		return rtnVector;
	}

	// 배송기사 목록
	public static Vector getVehicleDriver() {
		DBServletLink dbServletLink = new DBServletLink();
		dbServletLink.connectURL("M000S010100E074");
		
		Vector tmpVector = dbServletLink.doQuery("%", false);
		
		Vector codeVector = dbServletLink.getColumnData(tmpVector, 0);
		Vector nameVector = dbServletLink.getColumnData(tmpVector, 1);
		Vector revnoVector = dbServletLink.getColumnData(tmpVector, 2);
		
		Vector rtnVector = new Vector() ;
		
		rtnVector.add(codeVector);
		rtnVector.add(nameVector);
		rtnVector.add(revnoVector);
		
		return rtnVector ;
	}
	
	// 배송지역 목록
	public static Vector getDeliverLocation() {
		DBServletLink dbServletLink = new DBServletLink();
		dbServletLink.connectURL("M000S010100E084");
		
		Vector tmpVector = dbServletLink.doQuery("%", false);
		
		Vector codeVectorB = dbServletLink.getColumnData(tmpVector, 0);
		Vector codeVectorM = dbServletLink.getColumnData(tmpVector, 1);
		Vector nameVector = dbServletLink.getColumnData(tmpVector, 2);
		
		Vector rtnVector = new Vector() ;
		
		rtnVector.add(codeVectorB);
		rtnVector.add(codeVectorM);
		rtnVector.add(nameVector);
		
		return rtnVector ;
	}
	
	// 배송지역 목록
	public static Vector getCustomerGubun() {
		DBServletLink dbServletLink = new DBServletLink();
		dbServletLink.connectURL("M000S010100E094");
		
		Vector tmpVector = dbServletLink.doQuery("%", false);
		
		Vector codeVectorB = dbServletLink.getColumnData(tmpVector, 0);
		Vector nameVector = dbServletLink.getColumnData(tmpVector, 1);
		
		Vector rtnVector = new Vector() ;
		
		rtnVector.add(codeVectorB);
		rtnVector.add(nameVector);
		
		return rtnVector ;
	}
	
	
	// 금속 검출기 수동 등록을 위한 데이터 :: 0607 서승헌
	// 금속검출기 목록
	public static Vector getMetalList() {
		DBServletLink dbServletLink = new DBServletLink();
		dbServletLink.connectURL("M000S010100E104");
		
		Vector tmpVector = dbServletLink.doQuery("%", false);
		
		Vector censornoVector = dbServletLink.getColumnData(tmpVector, 0);
		Vector censornameVector = dbServletLink.getColumnData(tmpVector, 1);
		Vector censorlocaVector = dbServletLink.getColumnData(tmpVector, 2);
		
		Vector rtnVector = new Vector() ;
		rtnVector.add(censornoVector);
		rtnVector.add(censornameVector);
		rtnVector.add(censorlocaVector);
		
		return rtnVector ;
	}
		
	// 완제품(냉장육 & 냉동육) 목록
	public static Vector getProdList() {
		DBServletLink dbServletLink = new DBServletLink();
		dbServletLink.connectURL("M000S010100E114");
		
		Vector tmpVector = dbServletLink.doQuery("%", false);
		
		Vector codeVector = dbServletLink.getColumnData(tmpVector, 0);
		Vector nameVector = dbServletLink.getColumnData(tmpVector, 1);
		
		Vector rtnVector = new Vector() ;
		rtnVector.add(codeVector);
		rtnVector.add(nameVector);
		
		return rtnVector ;
	}	
	
	// 코드 목록
	public static Vector getCodeList(String code_cd) {
		DBServletLink dbServletLink = new DBServletLink();
		dbServletLink.connectURL("M000S010100E124");
		
		Vector cdVector = dbServletLink.doQuery(code_cd, false);
		
		Vector codeCdVector = dbServletLink.getColumnData(cdVector, 0);
		Vector codeValVector = dbServletLink.getColumnData(cdVector, 1);
		Vector codeNmVector = dbServletLink.getColumnData(cdVector, 2);
		
		Vector rtnVector = new Vector() ;
		rtnVector.add(codeCdVector);
		rtnVector.add(codeValVector);
		rtnVector.add(codeNmVector);
		
		return rtnVector ;
	}
		
}