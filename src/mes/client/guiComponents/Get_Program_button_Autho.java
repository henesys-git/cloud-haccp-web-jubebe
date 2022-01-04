package mes.client.guiComponents;

import org.json.simple.JSONObject;

import mes.client.conf.Config;

public class Get_Program_button_Autho {
	public DoyosaeTableModel meModel,TableModel;
	String[] strColumnBalju = {"class_id", "MENU_ID","MENU_NAME","autho_menu","autho_insert",
			"autho_update","autho_delete","autho_select","menu_level","parent_menu_id","program_id" };
	
	public String vSelect;
	public String vUpdate;
	public String vInsert;
	public String vDelete;
	
	public Get_Program_button_Autho() {
		// TODO Auto-generated constructor stub
	}
	
	public Get_Program_button_Autho(String userID, String programID) {
		// 로그인한 사용자의 정보
		JSONObject jArrayUser = new JSONObject();
		jArrayUser.put( "USER_ID", userID);
		DoyosaeTableModel TableModelUser = new DoyosaeTableModel("M909S080100E107", jArrayUser);
		int RowCountUser =TableModelUser.getRowCount();
		String loginIDrev = "",loginIDdept = "",loginIDgroupCd="";
		if(RowCountUser > 0) {
			loginIDrev = TableModelUser.getValueAt(0, 1).toString().trim();
			loginIDgroupCd = TableModelUser.getValueAt(0, 6).toString().trim();
			loginIDdept = TableModelUser.getValueAt(0, 10).toString().trim();
		} else {
			loginIDrev = "0";
		}
		
		JSONObject jArray = new JSONObject();
		jArray.put( "user_id", userID);
		jArray.put( "group_cd", loginIDgroupCd);
		jArray.put( "program_id", programID);
		
		meModel = new DoyosaeTableModel("M000S100000E302", strColumnBalju, jArray);	
		if (meModel.getRowCount()>0) {
			vSelect =meModel.getValueAt(0,7).toString();
			vUpdate =meModel.getValueAt(0,5).toString();
			vInsert =meModel.getValueAt(0,4).toString();
			vDelete =meModel.getValueAt(0,6).toString();
		}
	}
}
