package mes.client.common;

import java.util.Vector;
import mes.client.comm.DBServletLink;

public class PartListComboData {
	// 소분류
	public static Vector getPartSmGubunData(String clsCode) {
        DBServletLink dbServletLink = new DBServletLink();
        dbServletLink.connectURL("M000S04000E020");
        Vector tmpVector = dbServletLink.doQuery(clsCode+"|", false);

        Vector codeVector = dbServletLink.getColumnData(tmpVector, 0);
        codeVector.insertElementAt("ALL", 0);
        Vector nameVector = dbServletLink.getColumnData(tmpVector, 1);
        nameVector.insertElementAt("전체", 0);
        Vector valueVector = dbServletLink.getColumnData(tmpVector, 2);
        valueVector.insertElementAt("ALL", 0);

		Vector rtnVector = new Vector() ;
		rtnVector.add(codeVector) ;
		rtnVector.add(nameVector) ;
		rtnVector.add(valueVector) ;
		return rtnVector ;
	}
	
	// 발주용도
	public static Vector getBaljuYongdo() {
        DBServletLink dbServletLink = new DBServletLink();
        dbServletLink.connectURL("M000S04000E030");
        Vector tmpVector = dbServletLink.doQuery("|", false);

        Vector codeVector = dbServletLink.getColumnData(tmpVector, 0);
        codeVector.insertElementAt("ALL", 0);
        Vector nameVector = dbServletLink.getColumnData(tmpVector, 1);
        nameVector.insertElementAt("전체", 0);
        Vector valueVector = dbServletLink.getColumnData(tmpVector, 2);
        valueVector.insertElementAt("ALL", 0);

		Vector rtnVector = new Vector() ;
		rtnVector.add(codeVector) ;
		rtnVector.add(nameVector) ;
		rtnVector.add(valueVector) ;
		return rtnVector ;
	}	
	
	public static Vector getPart(String member_key) {
		DBServletLink dbServletLink = new DBServletLink();
		dbServletLink.connectURL("M000S010000E824");
		Vector tmpVector = dbServletLink.doQuery(member_key + "|", false);
		// 코드추가(ALL)
		Vector codeVector = dbServletLink.getColumnData(tmpVector, 0);
		codeVector.insertElementAt("ALL", 0);
		// 이름추가(전체)
		Vector nameVector = dbServletLink.getColumnData(tmpVector, 1);
		nameVector.insertElementAt("전체", 0);
		// 합체
		Vector rtnVector = new Vector() ;
		rtnVector.add(codeVector);
		rtnVector.add(nameVector);
		
		return rtnVector ;
	}
	
	//원석(원부자재대분류 전체)
	public static Vector getPartBigGubunDataAll(String member_key) {
		DBServletLink dbServletLink = new DBServletLink();
		dbServletLink.connectURL("M000S010000E804");
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
		
		return rtnVector ;
	}
		
	//원석(원부자재중분류 전체)
	public static Vector getPartMidGubunDataAll(String bigGubun, String member_key) {
        DBServletLink dbServletLink = new DBServletLink();
        dbServletLink.connectURL("M000S010000E814");
        Vector tmpVector = dbServletLink.doQuery(bigGubun+"|" + member_key + "|", false);
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
		
		
	//원석(원부자재소분류 전체)
	public static Vector getPartSmGubunDataAll() {
        DBServletLink dbServletLink = new DBServletLink();
        dbServletLink.connectURL("M000S010000E815");
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
		Vector rtnVector = new Vector() ;
		rtnVector.add(codeVector) ;
		rtnVector.add(nameVector) ;
		rtnVector.add(valueVector) ;
		
		return rtnVector ;
	}
}
