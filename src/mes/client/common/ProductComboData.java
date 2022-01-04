package mes.client.common;

import java.awt.Color;
import java.util.Vector;

import mes.client.comm.DBServletLink;
import mes.client.data.Session;


public class ProductComboData {
	// ����(��ü)
	public static Vector getGijongDataAll() {
        DBServletLink dbServletLink = new DBServletLink();
        dbServletLink.connectURL("M000S03000E010");
        Vector tmpVector = dbServletLink.doQuery(Session.SS_MAIN_CODE, false);
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
        // �ڵ��߰�(ALL)
        Vector codeVector = dbServletLink.getColumnData(tmpVector, 0);
       	codeVector.insertElementAt("SEL", 0);
        // �̸��߰�(��ü)
        Vector nameVector = dbServletLink.getColumnData(tmpVector, 1);
       	nameVector.insertElementAt("����", 0);
        // ����߰�
        Vector valueVector = dbServletLink.getColumnData(tmpVector, 2);
       	valueVector.insertElementAt("SEL", 0);
        // ��ü
		Vector rtnVector = new Vector();
		rtnVector.add(codeVector);
		rtnVector.add(nameVector);
		rtnVector.add(valueVector);
		
		return rtnVector ;
	}
	
	// ����(��ǰ�׷�)�ڵ�,�̸� ��ȯ. 
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

	// SIZE(��ü)
	public static Vector getSizeDataAll() {
        DBServletLink dbServletLink = new DBServletLink();
        dbServletLink.connectURL("M000S03000E020");
        Vector tmpVector = dbServletLink.doQuery(Session.SS_MAIN_CODE, false);
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
	
	// SIZE�ڵ�,�̸� ��ȯ. 
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
	
	// ���
	public static Vector getMyonsuDataAll() {
        DBServletLink dbServletLink = new DBServletLink();
        dbServletLink.connectURL("M000S03000E030");
        Vector tmpVector = dbServletLink.doQuery(Session.SS_MAIN_CODE, false);
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
	
	// ����ڵ�,�̸� ��ȯ. 
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

	// ���¹��(��ü)
	public static Vector getFoldingDataAll() {
        DBServletLink dbServletLink = new DBServletLink();
        dbServletLink.connectURL("M000S03000E040");
        Vector tmpVector = dbServletLink.doQuery(Session.SS_MAIN_CODE, false);
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
	
	// ���¹���ڵ�,�̸� ��ȯ.
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

	// �߰��ɼ�(��ü)
	public static Vector getOptionDataAll() {
        DBServletLink dbServletLink = new DBServletLink();
        dbServletLink.connectURL("M000S03000E050");
        Vector tmpVector = dbServletLink.doQuery(Session.SS_MAIN_CODE, false);
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
		Vector rtnVector = new Vector();
		rtnVector.add(codeVector);
		rtnVector.add(nameVector);
		rtnVector.add(valueVector);
		
		return rtnVector;
	}
	
	// �߰��ɼ��ڵ�,�̸� ��ȯ. 
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
	
	//(��ǰ��з� ��ü)
	public static Vector getProdBigGubunDataAll(String member_key) {
		DBServletLink dbServletLink = new DBServletLink();
		dbServletLink.connectURL("M000S010000E904");
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
		
		return rtnVector;
	}
	
	//(��ǰ�ߺз� ��ü)
	public static Vector getProdMidGubunDataAll(String bigGubun, String member_key) {
        DBServletLink dbServletLink = new DBServletLink();
        dbServletLink.connectURL("M000S010000E914");
        Vector tmpVector = dbServletLink.doQuery(bigGubun + "|" + member_key + "|", false);
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
		Vector rtnVector = new Vector();
		rtnVector.add(codeVector);
		rtnVector.add(nameVector);
		rtnVector.add(valueVector);
		
		return rtnVector;
	}
	
	//(��ǰ�Һз� ��ü)
	public static Vector getProdSmGubunDataAll() {
        DBServletLink dbServletLink = new DBServletLink();
        dbServletLink.connectURL("M000S010000E915");
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
		Vector rtnVector = new Vector();
		rtnVector.add(codeVector);
		rtnVector.add(nameVector);
		rtnVector.add(valueVector);
		
		return rtnVector;
	}
}