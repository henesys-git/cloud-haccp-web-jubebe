package mes.client.common;

import java.util.Vector;
import mes.client.comm.DBServletLink;

public class PartListComboData {
	// �Һз�
	public static Vector getPartSmGubunData(String clsCode) {
        DBServletLink dbServletLink = new DBServletLink();
        dbServletLink.connectURL("M000S04000E020");
        Vector tmpVector = dbServletLink.doQuery(clsCode+"|", false);

        Vector codeVector = dbServletLink.getColumnData(tmpVector, 0);
        codeVector.insertElementAt("ALL", 0);
        Vector nameVector = dbServletLink.getColumnData(tmpVector, 1);
        nameVector.insertElementAt("��ü", 0);
        Vector valueVector = dbServletLink.getColumnData(tmpVector, 2);
        valueVector.insertElementAt("ALL", 0);

		Vector rtnVector = new Vector() ;
		rtnVector.add(codeVector) ;
		rtnVector.add(nameVector) ;
		rtnVector.add(valueVector) ;
		return rtnVector ;
	}
	
	// ���ֿ뵵
	public static Vector getBaljuYongdo() {
        DBServletLink dbServletLink = new DBServletLink();
        dbServletLink.connectURL("M000S04000E030");
        Vector tmpVector = dbServletLink.doQuery("|", false);

        Vector codeVector = dbServletLink.getColumnData(tmpVector, 0);
        codeVector.insertElementAt("ALL", 0);
        Vector nameVector = dbServletLink.getColumnData(tmpVector, 1);
        nameVector.insertElementAt("��ü", 0);
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
		// �ڵ��߰�(ALL)
		Vector codeVector = dbServletLink.getColumnData(tmpVector, 0);
		codeVector.insertElementAt("ALL", 0);
		// �̸��߰�(��ü)
		Vector nameVector = dbServletLink.getColumnData(tmpVector, 1);
		nameVector.insertElementAt("��ü", 0);
		// ��ü
		Vector rtnVector = new Vector() ;
		rtnVector.add(codeVector);
		rtnVector.add(nameVector);
		
		return rtnVector ;
	}
	
	//����(���������з� ��ü)
	public static Vector getPartBigGubunDataAll(String member_key) {
		DBServletLink dbServletLink = new DBServletLink();
		dbServletLink.connectURL("M000S010000E804");
		Vector tmpVector = dbServletLink.doQuery(member_key + "|", false);
		// �ڵ��߰�(ALL)
		Vector codeVector = dbServletLink.getColumnData(tmpVector, 0);
		codeVector.insertElementAt("ALL", 0);
		// �̸��߰�(��ü)
		Vector nameVector = dbServletLink.getColumnData(tmpVector, 1);
		nameVector.insertElementAt("��ü", 0);
		// ����߰�
		Vector valueVector = dbServletLink.getColumnData(tmpVector, 2);
		valueVector.insertElementAt("ALL", 0);
		// ��ü
		Vector rtnVector = new Vector() ;
		rtnVector.add(codeVector) ;
		rtnVector.add(nameVector) ;
		rtnVector.add(valueVector) ;
		
		return rtnVector ;
	}
		
	//����(���������ߺз� ��ü)
	public static Vector getPartMidGubunDataAll(String bigGubun, String member_key) {
        DBServletLink dbServletLink = new DBServletLink();
        dbServletLink.connectURL("M000S010000E814");
        Vector tmpVector = dbServletLink.doQuery(bigGubun+"|" + member_key + "|", false);
        // �ڵ��߰�(ALL)
        Vector codeVector = dbServletLink.getColumnData(tmpVector, 0);
        codeVector.insertElementAt("ALL", 0);
        // �̸��߰�(��ü)
        Vector nameVector = dbServletLink.getColumnData(tmpVector, 1);
        nameVector.insertElementAt("��ü", 0);
        // ����߰�
        Vector valueVector = dbServletLink.getColumnData(tmpVector, 2);
        valueVector.insertElementAt("ALL", 0);
        // ��ü
		Vector rtnVector = new Vector() ;
		rtnVector.add(codeVector) ;
		rtnVector.add(nameVector) ;
		rtnVector.add(valueVector) ;
		
		return rtnVector ;
	}
		
		
	//����(��������Һз� ��ü)
	public static Vector getPartSmGubunDataAll() {
        DBServletLink dbServletLink = new DBServletLink();
        dbServletLink.connectURL("M000S010000E815");
        Vector tmpVector = dbServletLink.doQuery("|", false);
        // �ڵ��߰�(ALL)
        Vector codeVector = dbServletLink.getColumnData(tmpVector, 0);
        codeVector.insertElementAt("ALL", 0);
        // �̸��߰�(��ü)
        Vector nameVector = dbServletLink.getColumnData(tmpVector, 1);
        nameVector.insertElementAt("��ü", 0);
        // ����߰�
        Vector valueVector = dbServletLink.getColumnData(tmpVector, 2);
        valueVector.insertElementAt("ALL", 0);
        // ��ü
		Vector rtnVector = new Vector() ;
		rtnVector.add(codeVector) ;
		rtnVector.add(nameVector) ;
		rtnVector.add(valueVector) ;
		
		return rtnVector ;
	}
}
