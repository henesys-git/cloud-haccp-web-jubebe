package mes.client.guiComponents;

import java.util.Vector;

import org.json.simple.JSONObject;

import mes.client.comm.DBServletLink;

public class EdmsDoyosaeTableModel extends DoyosaeTableModel {
    public EdmsDoyosaeTableModel(String pid, String[] columnName, String params) {
    	try {
	    	dbServletLink = new DBServletLink();
			this.columnName = columnName;
			dbServletLink.connectURL(pid);
			table = dbServletLink.doQueryTableFieldName(params, false);
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
    public boolean isEDMS() {
    	return true;
    }
    
    
    public EdmsDoyosaeTableModel(String pid, String[] columnName, JSONObject params) {
    	try {
	    	dbServletLink = new DBServletLink();
			this.columnName = columnName;
			dbServletLink.connectURL(pid);
			table = dbServletLink.doQueryTableFieldName(params, false);
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
    
    public EdmsDoyosaeTableModel(String pid, JSONObject params) {
    	try {
	    	dbServletLink = new DBServletLink();
//			this.columnName = columnName;
			dbServletLink.connectURL(pid);
			table = dbServletLink.doQueryTableFieldName(params, false);
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
}
