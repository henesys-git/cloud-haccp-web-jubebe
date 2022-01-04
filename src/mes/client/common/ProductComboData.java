package mes.client.common;

import java.awt.Color;
import java.util.Vector;

import mes.client.comm.DBServletLink;
import mes.client.data.Session;


public class ProductComboData {
	// 기종(전체)
	public static Vector getGijongDataAll() {
        DBServletLink dbServletLink = new DBServletLink();
        dbServletLink.connectURL("M000S03000E010");
        Vector tmpVector = dbServletLink.doQuery(Session.SS_MAIN_CODE, false);
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
		Vector rtnVector = new Vector();
		rtnVector.add(codeVector);
		rtnVector.add(nameVector);
		rtnVector.add(valueVector);
		
		return rtnVector ;
	}
	
	public static Vector getGijongDataSelect() {
        DBServletLink dbServletLink = new DBServletLink();
        dbServletLink.connectURL("M000S03000E010");
        Vector tmpVector = dbServletLink.doQuery(Session.SS_MAIN_CODE, false);
        // 코드추가(ALL)
        Vector codeVector = dbServletLink.getColumnData(tmpVector, 0);
       	codeVector.insertElementAt("SEL", 0);
        // 이름추가(전체)
        Vector nameVector = dbServletLink.getColumnData(tmpVector, 1);
       	nameVector.insertElementAt("선택", 0);
        // 밸류추가
        Vector valueVector = dbServletLink.getColumnData(tmpVector, 2);
       	valueVector.insertElementAt("SEL", 0);
        // 합체
		Vector rtnVector = new Vector();
		rtnVector.add(codeVector);
		rtnVector.add(nameVector);
		rtnVector.add(valueVector);
		
		return rtnVector ;
	}
	
	// 기종(제품그룹)코드,이름 반환. 
	public static Vector getGijongData() {
        DBServletLink dbServletLink = new DBServletLink();
        dbServletLink.connectURL("M000S03000E010");
        Vector tmpVector = dbServletLink.doQuery(Session.SS_MAIN_CODE, false);
		Vector rtnVector = new Vector();
		rtnVector.add(dbServletLink.getColumnData(tmpVector, 0));
		rtnVector.add(dbServletLink.getColumnData(tmpVector, 1));
		rtnVector.add(dbServletLink.getColumnData(tmpVector, 2));
		
		return rtnVector ;
	}

	// SIZE(전체)
	public static Vector getSizeDataAll() {
        DBServletLink dbServletLink = new DBServletLink();
        dbServletLink.connectURL("M000S03000E020");
        Vector tmpVector = dbServletLink.doQuery(Session.SS_MAIN_CODE, false);
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
	
	// SIZE코드,이름 반환. 
	public static Vector getSizeData() {
        DBServletLink dbServletLink = new DBServletLink();
        dbServletLink.connectURL("M000S03000E020");
        Vector tmpVector = dbServletLink.doQuery(Session.SS_MAIN_CODE, false);
		Vector rtnVector = new Vector() ;
		rtnVector.add(dbServletLink.getColumnData(tmpVector, 0)) ;
		rtnVector.add(dbServletLink.getColumnData(tmpVector, 1)) ;
		rtnVector.add(dbServletLink.getColumnData(tmpVector, 2)) ;
		
		return rtnVector ;
	}
	
	// 면수
	public static Vector getMyonsuDataAll() {
        DBServletLink dbServletLink = new DBServletLink();
        dbServletLink.connectURL("M000S03000E030");
        Vector tmpVector = dbServletLink.doQuery(Session.SS_MAIN_CODE, false);
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
	
	// 면수코드,이름 반환. 
	public static Vector getMyonsuData() {
        DBServletLink dbServletLink = new DBServletLink();
        dbServletLink.connectURL("M000S03000E030");
        Vector tmpVector = dbServletLink.doQuery(Session.SS_MAIN_CODE, false);
		Vector rtnVector = new Vector() ;
		rtnVector.add(dbServletLink.getColumnData(tmpVector, 0)) ;
		rtnVector.add(dbServletLink.getColumnData(tmpVector, 1)) ;
		rtnVector.add(dbServletLink.getColumnData(tmpVector, 2)) ;
		
		return rtnVector ;
	}

	// 접는방법(전체)
	public static Vector getFoldingDataAll() {
        DBServletLink dbServletLink = new DBServletLink();
        dbServletLink.connectURL("M000S03000E040");
        Vector tmpVector = dbServletLink.doQuery(Session.SS_MAIN_CODE, false);
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
	
	// 접는방법코드,이름 반환.
	public static Vector getFoldingData() {
        DBServletLink dbServletLink = new DBServletLink();
        dbServletLink.connectURL("M000S03000E040");
        Vector tmpVector = dbServletLink.doQuery(Session.SS_MAIN_CODE, false);
		Vector rtnVector = new Vector();
		rtnVector.add(dbServletLink.getColumnData(tmpVector, 0)) ;
		rtnVector.add(dbServletLink.getColumnData(tmpVector, 1)) ;
		rtnVector.add(dbServletLink.getColumnData(tmpVector, 2)) ;
		
		return rtnVector ;
	}

	// 추가옵션(전체)
	public static Vector getOptionDataAll() {
        DBServletLink dbServletLink = new DBServletLink();
        dbServletLink.connectURL("M000S03000E050");
        Vector tmpVector = dbServletLink.doQuery(Session.SS_MAIN_CODE, false);
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
		Vector rtnVector = new Vector();
		rtnVector.add(codeVector);
		rtnVector.add(nameVector);
		rtnVector.add(valueVector);
		
		return rtnVector;
	}
	
	// 추가옵션코드,이름 반환. 
	public static Vector getOptionData() {
        DBServletLink dbServletLink = new DBServletLink();
        dbServletLink.connectURL("M000S03000E050");
        Vector tmpVector = dbServletLink.doQuery(Session.SS_MAIN_CODE, false);
		Vector rtnVector = new Vector();
		rtnVector.add(dbServletLink.getColumnData(tmpVector, 0));
		rtnVector.add(dbServletLink.getColumnData(tmpVector, 1));
		rtnVector.add(dbServletLink.getColumnData(tmpVector, 2));
		
		return rtnVector;
	}
	
	//(제품대분류 전체)
	public static Vector getProdBigGubunDataAll(String member_key) {
		DBServletLink dbServletLink = new DBServletLink();
		dbServletLink.connectURL("M000S010000E904");
		Vector tmpVector = dbServletLink.doQuery(member_key + "|", false);
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
		
		return rtnVector;
	}
	
	//(제품중분류 전체)
	public static Vector getProdMidGubunDataAll(String bigGubun, String member_key) {
        DBServletLink dbServletLink = new DBServletLink();
        dbServletLink.connectURL("M000S010000E914");
        Vector tmpVector = dbServletLink.doQuery(bigGubun + "|" + member_key + "|", false);
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
		Vector rtnVector = new Vector();
		rtnVector.add(codeVector);
		rtnVector.add(nameVector);
		rtnVector.add(valueVector);
		
		return rtnVector;
	}
	
	//(제품소분류 전체)
	public static Vector getProdSmGubunDataAll() {
        DBServletLink dbServletLink = new DBServletLink();
        dbServletLink.connectURL("M000S010000E915");
        Vector tmpVector = dbServletLink.doQuery("|", false);
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
		Vector rtnVector = new Vector();
		rtnVector.add(codeVector);
		rtnVector.add(nameVector);
		rtnVector.add(valueVector);
		
		return rtnVector;
	}
}