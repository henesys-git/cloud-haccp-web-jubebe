package mes.client.guiComponents;

import java.awt.Color;
import java.util.Vector;

import javax.swing.event.TableModelEvent;
import javax.swing.table.AbstractTableModel;

import org.json.simple.JSONObject;

import mes.client.comm.DBServletLink;
import mes.client.common.Common;


public class DoyosaeTableModel extends AbstractTableModel {
	DBServletLink dbServletLink = null;
    String[] columnName = null;
    Vector table = new Vector();
    Vector rowVector = null;
    Vector tempVector = null;

    boolean cellEdit = false;
    int vectorSize = 0;
    int editCellPoint = -1;
    int editFromCellPoint = -1;
    int editToCellPoint = -1;
    boolean cellEditable = true;
    boolean editArray = false;
    int[] editArrayCell;

    private Vector rowsetVector = new Vector();
    private Vector columnsetVector = new Vector();
       
    public DoyosaeTableModel() {
    }

    public DoyosaeTableModel(String pid, String[] columnName, String params) {
    	try {
	    	dbServletLink = new DBServletLink();
			this.columnName = columnName;
			dbServletLink.connectURL(pid);
			table = dbServletLink.doQuery(params, false);
			if (table != null) {
				vectorSize = table.size();
			} else {
				table = new Vector();
				vectorSize = 0;
			}
    	} catch (Exception e) {
    		e.printStackTrace();
    	}
    }

    public DoyosaeTableModel(String pid, String params) {
    	try {
	    	dbServletLink = new DBServletLink();
			dbServletLink.connectURL(pid);
			table = dbServletLink.doQuery(params, false);
			if (table != null) {
				vectorSize = table.size();
			} else {
				table = new Vector();
				vectorSize = 0;
			}
    	} catch (Exception e) {
    		e.printStackTrace();
    	}
    }
  
    public DoyosaeTableModel(String pid, JSONObject params) {
    	try {
	    	dbServletLink = new DBServletLink();
			dbServletLink.connectURL(pid);
			table = dbServletLink.doQuery(params, false);
			if (table != null) {
				vectorSize = table.size();
			} else {
				table = new Vector();
				vectorSize = 0;
			}
    	} catch (Exception e) {
    		e.printStackTrace();
    	}
    }
    
    public DoyosaeTableModel(String pid, String[] columnName, JSONObject params) {
    	try {
	    	dbServletLink = new DBServletLink();
			this.columnName = columnName;
			dbServletLink.connectURL(pid);
			table = dbServletLink.doQuery(params, false);
			if (table != null) {
				vectorSize = table.size();
			} else {
				table = new Vector();
				vectorSize = 0;
			}
    	} catch (Exception e) {
    		e.printStackTrace();
    	}
    }
    
    public DoyosaeTableModel(String pid, String[] columnName, String params, String gubun) {
    	try {
	    	dbServletLink = new DBServletLink();
			this.columnName = columnName;
			dbServletLink.connectURL(pid);
			table = dbServletLink.doQuery(params, false);
			if (table != null) {
				vectorSize = table.size();
			} else {
				table = new Vector();
				vectorSize = 0;
			}
			
			if (gubun.equals("DESC")) {
			    int serno = vectorSize;
			    for(int i=0 ; i < vectorSize ; i++){
		    		columnsetVector = (Vector)table.elementAt(i);
		    		columnsetVector.insertElementAt("" + serno--,0);
		    		rowsetVector.addElement( columnsetVector);
			    }
			} else {
			    int serno = 1;
			    for(int i=0 ; i < vectorSize ; i++){
		    		columnsetVector = (Vector)table.elementAt(i);
		    		columnsetVector.insertElementAt("" + serno++,0);
		    		rowsetVector.addElement( columnsetVector);
			    }
			}
			
			table = rowsetVector;
		} catch (Exception e) {
			e.printStackTrace();
		}
    }

    public DoyosaeTableModel(String pid, String[] columnName, String params, boolean value) {
    	try {
	    	dbServletLink = new DBServletLink();
			this.columnName = columnName;
			dbServletLink.connectURL(pid);
			table = dbServletLink.doQuery(params, value);
			if (table != null) {
				vectorSize = table.size();
			} else {
				table = new Vector();
				vectorSize = 0;
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
    }

    public DoyosaeTableModel(String[] columnName, Vector fileVector) {
		this.columnName = columnName;
		table = fileVector;
		vectorSize = table.size();
	}
	
    public DoyosaeTableModel(String[] columnName, Vector fileVector, String gubun) {
    	try {
			this.columnName = columnName;
			table = fileVector;
			vectorSize = table.size();
		
			rowsetVector = new Vector();
			columnsetVector = null;
		
			if (gubun.equals("DESC")) {
			    int serno = vectorSize;
			    for(int i=0 ; i < vectorSize ; i++){
		    		columnsetVector = (Vector)table.elementAt(i);
		    		columnsetVector.insertElementAt("" + serno--,0);
		    		rowsetVector.addElement( columnsetVector);
			    }
			} else {
			    int serno = 1;
			    for(int i=0 ; i < vectorSize ; i++){
		    		columnsetVector = (Vector)table.elementAt(i);
		    		columnsetVector.insertElementAt("" + serno++,0);
		    		rowsetVector.addElement( columnsetVector);
			    }
			}
			
			table = rowsetVector;
		} catch (Exception e) {
			e.printStackTrace();
		}
    }

    public void setTotalRow(String[] totalColumn){
        String[] rowData = totalColumn;
		Object newRow = this.makeRow(rowData);
		table.add(getRowCount(),newRow);
		tempVector = null;
    }

    public void setTotalValue(int totalCol){
		int total = 0;
		for(int i=0 ; i < getRowCount()-1 ; i++){
		    total += Common.getIntFilter( (String)( ( (Vector)table.elementAt(i) ).elementAt(totalCol) ) );
		}
		setValueAt("" + total, getRowCount()-1, totalCol);
    }

    public void setMinusValue(int col1,int col2, int col3){
		int total = 0;
		int last_row = getRowCount() -1;
		int a1 = Common.getIntFilter( (String)( ( (Vector)table.elementAt(last_row) ).elementAt(col1) ) );
		int a2 = Common.getIntFilter( (String)( ( (Vector)table.elementAt(last_row) ).elementAt(col2) ) );
		int a3 = a1 - a2;
	
		setValueAt("" + a3, last_row, col3);
    }

    public int getTotalValue(int totalCol){
		int total = 0;
		for(int i=0 ; i < getRowCount()-1 ; i++) {
		    total += Common.getIntFilter( (String)( ( (Vector)table.elementAt(i) ).elementAt(totalCol) ) );
		}
	
		return total;
    }
    
    public int getColumnCount() {
		int colSize = 0;
		if (table.size() > 0) {
			colSize = ((Vector)table.elementAt(0)).size();
		} else {
			colSize = columnName.length;
		}
		return colSize;
    }

    public int getRowCount() {
		if (table.size() > 0) return table.size();
		return 0;
    }
    
    public String getColumnName(int col) {
		return columnName[col];
    }
    
    // ���̺������ �̸��� �ٲ۴�. ��������... 2017.11.03 �����
    public void setColumnName(String colName, int col) {
		columnName[col]=colName;
    }

    public String[] getAllColumnName() {
		return columnName;
    }

    public Object getValueAt(int row, int col) {
    	Object resObj = null;
    	try {
			if (table.size() <= 0) {
				resObj = null;
			} else {
				resObj = (Object)((Vector)table.elementAt(row)).elementAt(col);
			}
    	} catch (Exception e) {
    		e.printStackTrace();
    	}
		return resObj;
    }
    
    //2020 11.06 �ӽ� �߰�(�Ź���) - �ʿ������ �ٽ� ���� ����.
    public Object getValueAt2(int row, int col) {
    	Object resObj = null;
    	try {
			if (table.size() <= 0) {
				resObj = null;
			} else {
				resObj = (Object)((Vector)table.elementAt(row)).elementAt(col);
			}
    	} catch (Exception e) {
    		System.out.println("table.size=" + table.size() + "/row=" + row + "/col=" + col);
    		e.printStackTrace();
    	}
		return resObj;
    }
    
    /**
     * @return Ư�� ��ġ�� ���� ���� String Ÿ������ ��ȯ
     */
    public String getStrValueAt(int row, int col) {
    	String resObj = "";
    	
    	try {
			if (table.size() > 0) {
				resObj = ((Vector)table.elementAt(row)).elementAt(col).toString();
			}
    	} catch (Exception e) {
    		System.out.println("table.size=" + table.size() + "/row=" + row + "/col=" + col);
    		e.printStackTrace();
    	}
    	
		return resObj;
    }
    
    public boolean isCellEditable(int row, int col) {
        boolean retBool = true;
		if (!cellEditable) {
		    return false;
		} else if (editArray) {
		    editArray = false;
		    for (int i=0; i<editArrayCell.length; i++) {
				if (editArrayCell[i] == col) {
				    retBool = cellEdit;
				    break;
				} else retBool = !cellEdit;
		    }
		} else {
		    if (col >= editFromCellPoint && col <= editToCellPoint) retBool = cellEdit;
		    else retBool = !cellEdit;
		}

        return retBool;
    }
									
    // �̳��� ���� ���� ��.�Ұ� �ϰ� �����..
    public void setCellEdit(boolean newCellEdit) {
		if(!newCellEdit) cellEditable = false;
    }
				   
    // �̳��� Ư������ ��.�Ұ��ϰ� �����. ��, col���ϴ� ��� ��.�Ұ� ó�� @isCellEditable()
    public void setCellEdit(boolean cellEdit, int col) {
		this.cellEdit = cellEdit;
		editCellPoint = col;
    }

    // �̳��� Ư������ ��.�Ұ��ϰ� �����. ��, col���ϴ� ��� ��.�Ұ� ó�� @isCellEditable()
    public void setCellEdit(boolean cellEdit, int fromCol, int toCol) {
		this.cellEdit = cellEdit;
		editFromCellPoint = fromCol;
		editToCellPoint = toCol;
    }

    // �̳��� Ư�������� ��.�Ұ��ϰ� �����. ��, col[]�� ��� �ִ� �ѵ��� ��� �� �Ұ� ó���Ѵ�.
    public void setCellEdit(boolean cellEdit, int cols[]) {
		this.cellEdit = cellEdit;
		editArray = true;
		this.editArrayCell = cols;
    }

    // ����
    public void setValueAt(Object value, int row, int col) {
		if (row < 0 || row >= getRowCount()) {
			return;
		}
		//String strValue = value.toString();
		// �ش�ο츦 ��Ÿ�� �о�´�.
		rowVector = (Vector)table.elementAt(row);
		// �ش�Į���� ���� ����.
		rowVector.setElementAt(value, col);
		// �𵨿��� �˸���.
        fireTableChanged(new TableModelEvent(this, row, row, col));
    }

    public void setValueAt(Object value, int row, int col, Color c) {
		if (row < 0 || row >= getRowCount()) {
			return;
		}
		String strValue = value.toString();
		// �ش�ο츦 ��Ÿ�� �о�´�.
		rowVector = (Vector)table.elementAt(row);
		// �ش�Į���� ���� ����.
		rowVector.setElementAt(strValue, col);
		// �𵨿��� �˸���.
        fireTableChanged(new TableModelEvent(this, row, row, col));
    }
       
    public void setRemodelWithBool(String trueStr, int col) {
		// �ش�ο츦 ��Ÿ�� �о�´�.
		int tableSize = table.size();
		for (int i=0; i<tableSize; i++) {
	    	rowVector = (Vector)table.elementAt(i);
		    // �ش�Į���� ���� ����.
		    if ( ( (String)rowVector.elementAt(col) ).equals(trueStr.trim()) ) {
	    		rowVector.setElementAt((Boolean)new Boolean(true), col);
		    } else {
	    		rowVector.setElementAt((Boolean)new Boolean(false), col);
		    }
		}
		// �𵨿��� �˸���.
        fireTableDataChanged();
    }
    
    // ���
    public void insert(Object rowObject,int row) {
		if (row < 0) row = 0;
		if (row > table.size()) row = table.size();
		
		table.insertElementAt(rowObject, row);
		// �𵨿��� �˸���.
		fireTableRowsInserted(row,row);
    }

    // ����
    public boolean delete(int row) {
		if (row < 0 || row >= table.size()) return false;
		// �� ��Ÿ���� �ش� �ο츦 �����..
		table.remove(row);
		// �𵨿��� �˸���.
		fireTableRowsDeleted(row,row);
		return true;
    }
  
    public boolean delete(int row0, int modelRowCnt) {
		if (row0 < 0 || row0 >= table.size()) {
			return false;
		}
		if (modelRowCnt < 0 || modelRowCnt >= table.size()) {
			return false;
		}
		
		// �� ��Ÿ���� �ش� �ο츦 �����..
		for(int i=row0; i<modelRowCnt;i++) {
			table.remove(i);
		}
		
		// �𵨿��� �˸���.
		fireTableRowsDeleted(row0,modelRowCnt-1);
		return true;
    }
    
    // ��� ���� Ư�� �÷� ����
    public void deleteCols(int intArr[]) {
    	int len = getRowCount();
    	
    	for(int i = 0; i < len; i++) {
    		rowVector = (Vector)table.elementAt(i);
    		
    		for(int j = 0; j < intArr.length; j++) {
    			rowVector.remove(j);    			
    		}
    	}
    }
    
    public Class getColumnClass(int col) {
    	return getValueAt(0,col).getClass();
    }
    
    public int getVectorSize() {
		return vectorSize;
    }
    
    public void setVectorSize(int val) {
		vectorSize = vectorSize + val;
    }

    public Vector getVector() {
        return table;
    }
    
    public void setVector(Vector dataVector) {
        table = dataVector;
    }

    //�迭�� ������Ʈ�� ��ȯ
    public Object makeRow(String col[]) {
		tempVector = new Vector();
		
		for (int i = 0; i < col.length; i++) {
			tempVector.addElement(col[i]);
		}
		
		return tempVector;
    }
}