package mes.client.guiComponents;

import java.util.Vector;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;


public class JsonData {

	DoyosaeTableModel TableModel;
	Vector fieldNameVector;
	int RowCount;
	int ColCounter;
	
	public JsonData(Object Model) {
		// TODO Auto-generated constructor stub
		if(Model instanceof EdmsDoyosaeTableModel) {
			this.TableModel = (EdmsDoyosaeTableModel)Model;		
			fieldNameVector = (Vector) TableModel.getVector().get(0);
			TableModel.delete(0);
		} else {
			this.TableModel = (DoyosaeTableModel)Model;		
		}
		
		RowCount = TableModel.getRowCount();	
	    ColCounter = TableModel.getColumnCount();
	}
	
	public String Get_JsonString(String sEcho) {

	    JSONArray jsonResponse = new JSONArray();
	    JSONArray jBrray = new JSONArray();
	    
		for(int i = 0; i < RowCount; i++ ) {
		    JSONArray jArray = new JSONArray();
			for(int j = 0; j < ColCounter; j++) {
				jArray.add(TableModel.getValueAt(i,j).toString().trim());
			}
			jBrray.add(jArray);
		}
		jsonResponse.add(jBrray);
		return jsonResponse.toString();
	}
	
}
