package mes.client.guiComponents;

import java.util.Vector;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import mes.client.conf.Config;
import mes.frame.common.HashObject;

public class MakeSidebarMenu {
	public String HeadMenu = "";
	public String sideMenu = "";
	public DoyosaeTableModel meModel, TableModel;
	StringBuffer html = new StringBuffer();
	public int RowCount = 0, CMRowCount = 0;
	int RowNum = 0;
	String[] strColumnBalju = { "class_id", "MENU_ID", "MENU_NAME", "autho_menu", "autho_insert", "autho_update",
			"autho_delete", "autho_select", "menu_level", "parent_menu_id", "program_id" };
	String[] strColumnHead = { "����� ��ȣ", "������ȣ", "ȸ���", "�ּ�", "��ȭ��ȣ", "��ǥ�̸�", "����", "����", "�ѽ�", "Ȩ������", "�����ȣ" };
	String packageName;
	String programID;
	String paneNameKor;
	String MenuTitle;
	String CompayName;
	String CompayLogoImageFileName;
	public String authoError = "";

	public MakeSidebarMenu(String member_key, String userID, String HeadmenuID, String group_cd) {
		String param = userID + "|" + HeadmenuID + "|" + member_key + "|" + group_cd + "|";
		meModel = new DoyosaeTableModel("M000S100000E002", strColumnBalju, param);
		RowCount = meModel.getRowCount();

		JSONObject jAJSONObject = new JSONObject();
		jAJSONObject.put("member_key", member_key);

		TableModel = new DoyosaeTableModel("M909S150100E114", strColumnHead, jAJSONObject);
		CMRowCount = TableModel.getRowCount();
		if (CMRowCount > 0) {
			CompayLogoImageFileName = TableModel.getValueAt(0, 11).toString().trim();
			CompayName = TableModel.getValueAt(0, 2).toString().trim();
		} else {
			CompayLogoImageFileName = "";
			CompayName = "�츮ȸ�������� ����ϼ���";
		}

		// �α����� ���̵� ���α׷� ������ ������� �����޼���(ERROR) ����
		if (RowCount > 0)
			authoError = "";
		else
			authoError = "ERROR";
	}

	public String GetHeadMenu() {
		return makeHeadMenu();
	}

	public String GetsideMenu(String HeadmenuID, String HeadmenuName) {
		return makesideMenu(HeadmenuID, HeadmenuName);
	}

	private String makeHeadMenu() {
		html = new StringBuffer();
		
		String [] IconName = new String[11]; //AdminLte icon class ���� �迭 ���� �� ����
		
		IconName[0] ="nav-icon fas fa-tree";
		IconName[1] ="nav-icon fas fa-table";
		IconName[2] ="nav-icon fas fa-calendar-alt";
		IconName[3] ="nav-icon fas fa-th";
		IconName[4] ="nav-icon fas fa-book";
		IconName[5] ="nav-icon fas fa-tachometer-alt";
		IconName[6] ="nav-icon fas fa-file";
		IconName[7] ="nav-icon fas fa-image";
		IconName[8] ="nav-icon fas fa-copy";
		IconName[9] ="nav-icon fas fa-edit";
		IconName[10] ="nav-icon fas fa-chart-pie";
		
		int MenuRowLimit = 0; 
		
		if(RowCount > 0) {
	        for(RowNum=0; RowNum < RowCount; RowNum++){ // menu_level 0(���޴�) ����     	
				if (meModel.getValueAt(RowNum,3).toString().equals("1") && meModel.getValueAt(RowNum,8).toString().equals("0")) {	//autho_menu=1, menu_level=0=> Head Menu
					packageName = meModel.getValueAt(RowNum,0).toString();	
					paneNameKor = meModel.getValueAt(RowNum,2).toString();
					String menuID = meModel.getValueAt(RowNum,1).toString();
					
					if((RowNum+1)< RowCount) {
						programID = meModel.getValueAt(RowNum+1,10).toString();
						MenuTitle = meModel.getValueAt(RowNum+1,2).toString();
					}
					
					html.append("<li class='nav-item has-treeview'>");
					html.append("	<a href='#' class='nav-link'>");
					//html.append("		<i class='nav-icon fas fa-chart-pie'></i>"); //��ü ������ icon class�� �����Ҷ�
					html.append("		<i class='"+IconName[MenuRowLimit]+"'></i>"); //�迭 0-10������ icon class ���� 
					html.append("		<p>");
					html.append( 			paneNameKor );
					html.append("			<i class='right fas fa-angle-left'></i>");
					html.append("		</p>");
					html.append("	</a>");
					html.append(	makeSubMenu(packageName, paneNameKor, menuID));	// Sub menu ����
					html.append("</li>");
					
					MenuRowLimit++;  
					
					if(MenuRowLimit>11) {
						MenuRowLimit=11;
					  }
				}
	        }
	        
		}
        
        return html.toString();
	}

	private String makeSubMenu(String HeadmenuID, String HeadmenuName, String ParentMenuID) { // menu_level 1 or 2
		// �������� ����ϸ� ���� ����(RowNum,html)�� ���� ��ġ�Ƿ�, �������� ���� ����
		int SubRowNum = 0;
		StringBuffer Subhtml = new StringBuffer();

		Subhtml.append("<ul class='nav nav-treeview'>");
		for (SubRowNum = 0; SubRowNum < RowCount; SubRowNum++) {
			String jspprogramID = meModel.getValueAt(SubRowNum, 10).toString();

			if (meModel.getValueAt(SubRowNum, 9).toString().equals(ParentMenuID)) { // parrnt_menu_id �˻�
				if (meModel.getValueAt(SubRowNum, 4).toString().equals("1") || // autho_insert
						meModel.getValueAt(SubRowNum, 5).toString().equals("1") || // autho_update
						meModel.getValueAt(SubRowNum, 6).toString().equals("1") || // autho_delete
						meModel.getValueAt(SubRowNum, 7).toString().equals("1")) { // autho_select
					// menu_level 1 Or 2 => Head Menu�� 1����(Sub Menu) ������� �ٷ� 2������ Sub Menu��
					if (Integer.parseInt(meModel.getValueAt(SubRowNum, 8).toString()) == 1) { // menu_level 1�� ������, Lv1
																								// ǥ��
						String SubMenuID = meModel.getValueAt(SubRowNum, 1).toString();
						String SubMenuName = meModel.getValueAt(SubRowNum, 2).toString();

						Subhtml.append("<li class='nav-item has-treeview'>");
						Subhtml.append("	<a href='#' class='nav-link'>");
						Subhtml.append("		<i class='far fa-square nav-icon'></i>");
						Subhtml.append("		<p>");
						Subhtml.append(SubMenuName);
						Subhtml.append("			<i class='right fas fa-angle-left'></i>");
						Subhtml.append("		</p>");
						Subhtml.append("	</a>");
						Subhtml.append("	<ul class='nav nav-treeview'>");
						Subhtml.append(makeSubSubMenu(HeadmenuID, HeadmenuName, SubMenuID, SubMenuName)); // subsubmenu
																											// �θ���
						Subhtml.append("	</ul>");
						Subhtml.append("</li>");
					} else if (Integer.parseInt(meModel.getValueAt(SubRowNum, 8).toString()) == 2) { // menu_level 1��
																										// ������, Sub
																										// Menu(Lv1)�κп�
																										// Lv2�� ǥ��
						Subhtml.append("<li class='nav-item' id=" + jspprogramID + "'_li' ");
						Subhtml.append(" onclick=\" return fn_MainSubMenuSelected(this, '" + Config.this_SERVER_path
								+ "/Contents/" + HeadmenuID + "/" + jspprogramID + "','" + HeadmenuID + "','"
								+ HeadmenuName + "','" + jspprogramID + "' );  \" >");
						Subhtml.append("	<a href='#' class='nav-link'>");
						Subhtml.append("		<i class='far fa-square nav-icon'></i>");
						Subhtml.append("		<p>");
						Subhtml.append(meModel.getValueAt(SubRowNum, 2).toString());
						Subhtml.append("			<i class='right far fa-angle-left'></i>");
						Subhtml.append("		</p>");
						Subhtml.append("	</a>");
						Subhtml.append("</li>");
					}
				}
			}
		}
		Subhtml.append("</ul>");

		return Subhtml.toString();
	}

	private String makeSubSubMenu(String HeadmenuID, String HeadmenuName, String SubMenuID, String SubmenuName) { // menu_level
																													// 2
		// �������� ����ϸ� ���� ����(RowNum,html)�� ���� ��ġ�Ƿ�, �������� ���� ����
		int SubSubRowNum = 0;
		StringBuffer SubSubhtml = new StringBuffer();

		for (SubSubRowNum = 0; SubSubRowNum < RowCount; SubSubRowNum++) { // menu_level 1 ������ 2���� �޴� ǥ��
			String jspprogramID = meModel.getValueAt(SubSubRowNum, 10).toString();
			if (meModel.getValueAt(SubSubRowNum, 9).toString().equals(SubMenuID)) { // parrnt_menu_id �˻�
				if (Integer.parseInt(meModel.getValueAt(SubSubRowNum, 8).toString()) == 2) { // menu_level == 2 Sub
																								// SubMenue
					if (meModel.getValueAt(SubSubRowNum, 4).toString().equals("1") || // autho_insert
							meModel.getValueAt(SubSubRowNum, 5).toString().equals("1") || // autho_update
							meModel.getValueAt(SubSubRowNum, 6).toString().equals("1") || // autho_delete
							meModel.getValueAt(SubSubRowNum, 7).toString().equals("1")) { // autho_select
						SubSubhtml.append("<li class='nav-item' id=" + jspprogramID + "'_li'");
						SubSubhtml.append(" onclick=\" return fn_MainSubMenuSelected(this, '" + Config.this_SERVER_path
								+ "/Contents/" + HeadmenuID + "/" + jspprogramID + "','" + HeadmenuID + "','"
								+ HeadmenuName + "','" + jspprogramID + "'); \" >");
						SubSubhtml.append("		<a href='#' class='nav-link'>");
						SubSubhtml.append("			<i class='far fa-circle nav-icon'></i>");
						SubSubhtml.append("			<p>");
						SubSubhtml.append(meModel.getValueAt(SubSubRowNum, 2).toString());
						SubSubhtml.append("			</p>");
						SubSubhtml.append("		</a>");
						SubSubhtml.append("</li>");
					}
				}
			}
		}

		SubSubhtml.toString();
		return SubSubhtml.toString();
	}

//	========================================= �ؿ��� �� �� =========================================

	private String makesideMenu(String HeadmenuID, String HeadmenuName) {
		html = new StringBuffer();

		for (RowNum = 0; RowNum < RowCount; RowNum++) {
			String menuspace = "";
			String jspprogramID = meModel.getValueAt(RowNum, 10).toString();
			if (meModel.getValueAt(RowNum, 0).toString().equals(HeadmenuID)) {
				if (Integer.parseInt(meModel.getValueAt(RowNum, 8).toString()) > 0) { // menu_level > 0 Sub Menu or Sub
																						// SubMenue
					if (meModel.getValueAt(RowNum, 4).toString().equals("1") || // autho_insert
							meModel.getValueAt(RowNum, 5).toString().equals("1") || // autho_update
							meModel.getValueAt(RowNum, 6).toString().equals("1") || // autho_delete
							meModel.getValueAt(RowNum, 7).toString().equals("1")) { // autho_select

						html.append("<li class='list-group-item' id=" + jspprogramID + "'_li' ");
						html.append(" onclick=\\\" return fn_MainSubMenuSelected(this, '" + Config.this_SERVER_path
								+ "/Contents/" + HeadmenuID + "/" + jspprogramID + "','" + HeadmenuID + "','"
								+ HeadmenuName + "','" + jspprogramID + "' );  \\\" > " // 'class='list-group-item'
								+ menuspace + meModel.getValueAt(RowNum, 2).toString());
						html.append("</li>");
					}
				}
			}
		}

		html.toString();
		return html.toString();
	}

	public String getValueAt(String RowNum, int col) {
		int Row = Integer.parseInt(RowNum);
		return meModel.getValueAt(Row, col).toString();
	}

	public String getAuthorityOfProgram() {
		StringBuffer authoProgram = new StringBuffer();
		StringBuffer program_id = new StringBuffer();
		StringBuffer autho_insert = new StringBuffer();
		StringBuffer autho_update = new StringBuffer();
		StringBuffer autho_delete = new StringBuffer();
		StringBuffer autho_select = new StringBuffer();
		if (RowCount > 0) {
			authoProgram.append("var authoProgram = {\n");
			program_id.append("program_id	: [\"" + meModel.getValueAt(0, 10).toString() + "\",");
			autho_insert.append("autho_insert	: [\"" + meModel.getValueAt(0, 4).toString() + "\",");
			autho_update.append("autho_update	: [\"" + meModel.getValueAt(0, 5).toString() + "\",");
			autho_delete.append("autho_delete	: [\"" + meModel.getValueAt(0, 6).toString() + "\",");
			autho_select.append("autho_select	: [\"" + meModel.getValueAt(0, 7).toString() + "\",");
			for (RowNum = 1; RowNum < RowCount; RowNum++) {
				if (Integer.parseInt(meModel.getValueAt(RowNum, 8).toString()) > 0) { // menu_level > 0 Sub Menu or Sub
																						// SubMenue
					program_id.append("\"" + meModel.getValueAt(RowNum, 10).toString() + "\",");
					autho_insert.append("\"" + meModel.getValueAt(RowNum, 4).toString() + "\",");
					autho_update.append("\"" + meModel.getValueAt(RowNum, 5).toString() + "\",");
					autho_delete.append("\"" + meModel.getValueAt(RowNum, 6).toString() + "\",");
					autho_select.append("\"" + meModel.getValueAt(RowNum, 7).toString() + "\",");
				}
			}
			program_id.append("\"\"],\n");
			autho_insert.append("\"\"],\n");
			autho_update.append("\"\"],\n");
			autho_delete.append("\"\"],\n");
			autho_select.append("\"\"] \n");

			authoProgram.append(program_id);
			authoProgram.append(autho_insert);
			authoProgram.append(autho_update);
			authoProgram.append(autho_delete);
			authoProgram.append(autho_select);
			authoProgram.append("};");
		} else
			authoProgram.append("var authoProgram='ERROR'");
		return authoProgram.toString();
	}

	public JSONObject getAuthorityOfProgramOnJSP(String program_id) {
		JSONArray authoProgram = new JSONArray();
		JSONObject rtnProgram = new JSONObject();

		if (RowCount > 0) {
			for (RowNum = 1; RowNum < RowCount; RowNum++) {
				JSONObject program = new JSONObject();
				if (program_id.trim().equals(meModel.getValueAt(0, 10).toString().trim())) {
					program.put("program_id", meModel.getValueAt(RowNum, 10).toString());
					program.put("insert", meModel.getValueAt(RowNum, 4).toString());
					program.put("update", meModel.getValueAt(RowNum, 5).toString());
					program.put("delete", meModel.getValueAt(RowNum, 6).toString());
					program.put("select", meModel.getValueAt(RowNum, 7).toString());
					authoProgram.add(program);
					rtnProgram.put(meModel.getValueAt(RowNum, 10).toString(), authoProgram);
				}
			}

		}

		return rtnProgram;
	}

	// �� ������ �º� �޴����� ���� //////////////////////////////////
	private Vector headMenuVector = new Vector();
	private Vector subMenuVector = new Vector();
	private Vector subSubMenuVector = new Vector();

	private StringBuffer htmlHeadMenu = new StringBuffer();
	private StringBuffer htmlSubMenu = new StringBuffer();
	private StringBuffer htmlSubSubMenu = new StringBuffer();

	public String GetHeadMenuTablet() {
		return makeHeadMenuTablet();
	}

	private void makeMenuVector() { // ������ ���(meModel)�� ������ Vector�� ����
		for (RowNum = 0; RowNum < RowCount; RowNum++) {
			// headMenu
			if (meModel.getValueAt(RowNum, 3).toString().equals("1")
					&& meModel.getValueAt(RowNum, 8).toString().equals("0")) { // autho_menu=1, menu_level=0=> Head Menu
				Vector headMenuVectorRow = new Vector();
				for (int i = 0; i < strColumnHead.length; i++) {
					headMenuVectorRow.add(meModel.getValueAt(RowNum, i).toString());
				}
				headMenuVector.add(headMenuVectorRow);
			}
			// subMenu
			if (meModel.getValueAt(RowNum, 3).toString().equals("1")
					&& meModel.getValueAt(RowNum, 8).toString().equals("1")) { // autho_menu=1, menu_level=1=> Sub Menu
				Vector subMenuVectorRow = new Vector();
				for (int i = 0; i < strColumnHead.length; i++) {
					subMenuVectorRow.add(meModel.getValueAt(RowNum, i).toString());
				}
				subMenuVector.add(subMenuVectorRow);
			}
			// subSubMenu
			if (meModel.getValueAt(RowNum, 3).toString().equals("1")
					&& meModel.getValueAt(RowNum, 8).toString().equals("2")) { // autho_menu=1, menu_level=2=> Sub Sub
																				// Menu
				Vector subSubMenuVectorRow = new Vector();
				for (int i = 0; i < strColumnHead.length; i++) {
					subSubMenuVectorRow.add(meModel.getValueAt(RowNum, i).toString());
				}
				subSubMenuVector.add(subSubMenuVectorRow);
			}
		}
	}

	private String makeHeadMenuTablet() {
		// �������� ��Ʈ������ �ʱ�ȭ
		html = new StringBuffer();
		htmlHeadMenu = new StringBuffer();
		htmlSubMenu = new StringBuffer();
		htmlSubSubMenu = new StringBuffer();

		if (RowCount > 0) {
			makeMenuVector(); // ������ ���(meModel)�� ������ Vector�� ����

			// ���޴� ���μ��� ĭ�� ���ϱ�
			int headMenuRowCount = headMenuVector.size(); // ���޴� ���ڵ� ����
			int nHorizon = (int) Math.ceil(Math.sqrt(headMenuRowCount)); // ���� ĭ ���� -> ������(sqrt) ���� �� �Ҽ��� �ø�
			int nVertical = (int) Math.ceil((double) headMenuRowCount / nHorizon); // ���� ĭ ���� -> �� �������� ���� ĭ ���� ���� �� �Ҽ���

			// ���޴�(Lv.0)����
			htmlHeadMenu.append("<div id='headMenu' style='margin:auto; float: left; ");
			htmlHeadMenu.append("width: 100%; height: " + (nVertical * 100) + "px;' >");
			for (int i = 0; i < nVertical; i++) {
				htmlHeadMenu.append("<div id='headMenu_row_wrap' style=' ");
				htmlHeadMenu.append("width: 100%; height: " + (100 / nVertical) + "%;' >");
				for (int j = 0; j < nHorizon; j++) {
					int headMenuRowNum = i * nHorizon + j;
					if (headMenuRowNum < headMenuRowCount) {
						Vector headMenuVectorRow = (Vector) headMenuVector.get(headMenuRowNum);
						String m_class_id = headMenuVectorRow.get(0).toString();
						String m_menu_id = headMenuVectorRow.get(1).toString();
						String m_menu_name = headMenuVectorRow.get(2).toString();

						htmlHeadMenu.append("<div style='float: left; padding: 5px; ");
						htmlHeadMenu.append("width: " + (100 / nHorizon) + "%; height: 100%;' >");
						htmlHeadMenu.append("	<button id='" + m_class_id
								+ "' class='btn-primary' style='width:100%; height:100%;' onclick=\"fn_SubMenu_show(this,'"
								+ m_class_id + "')\" >");
						htmlHeadMenu.append(m_menu_name);
						htmlHeadMenu.append("	</button>");
						htmlHeadMenu.append("</div>");

						makeSubMenuTablet(m_class_id, m_menu_name, m_menu_id); // ����޴�(LV.1 �Ǵ� Lv.2) �����
					} else {
						break;
					}
				}
				htmlHeadMenu.append("</div>");
			}
			htmlHeadMenu.append("</div>");
		}

		html.append(htmlHeadMenu.toString());
		html.append(htmlSubMenu.toString());
		html.append(htmlSubSubMenu.toString());
		return html.toString();
	}

	private void makeSubMenuTablet(String HeadmenuID, String HeadmenuName, String ParentMenuID) { // menu_level 1 or 2
		StringBuffer vHtmlSubMenu = new StringBuffer(); // �������� �ӽ� ��Ʈ������
		Vector DataVector = new Vector(); // �������� �ӽ� �����͹���

		// HeadMenuID�� ���� ����޴� ã�Ƽ� DataVector�� ����
		for (int i = 0; i < subMenuVector.size(); i++) {
			Vector subMenuVectorRow = (Vector) subMenuVector.get(i);
			if (subMenuVectorRow.get(9).equals(ParentMenuID)) { // ����޴��� parent_id�� ���޴��� program_id ��
				DataVector.add(subMenuVectorRow);
			}
		}
		// HeadMenuID�� ���� ���꼭��޴� ã�Ƽ� DataVector�� ����
		for (int i = 0; i < subSubMenuVector.size(); i++) {
			Vector subSubMenuVectorRow = (Vector) subSubMenuVector.get(i);
			if (subSubMenuVectorRow.get(9).equals(ParentMenuID)) { // ���꼭��޴��� parent_id�� ���޴��� program_id ��
				DataVector.add(subSubMenuVectorRow);
			}
		}

		// ����޴� ���μ��� ĭ�� ���ϱ�
		int subMenuRowCount = DataVector.size(); // ����޴� ���ڵ� ����
		int nHorizon = (int) Math.ceil(Math.sqrt(subMenuRowCount)); // ���� ĭ ���� -> ������(sqrt) ���� �� �Ҽ��� �ø�
		int nVertical = (int) Math.ceil((double) subMenuRowCount / nHorizon); // ���� ĭ ���� -> �� �������� ���� ĭ ���� ���� �� �Ҽ��� �ø�

		// ����޴�(Lv.1 �Ǵ� Lv.2)����
		vHtmlSubMenu.append("<div id='subMenu_" + HeadmenuID + "' style='margin:auto; float: left; display:none; ");
		vHtmlSubMenu.append("width: 100%; height: " + (nVertical * 100) + "px;' >");
		for (int i = 0; i < nVertical; i++) {
			vHtmlSubMenu.append("<div id='subMenu_row_wrap' style=' ");
			vHtmlSubMenu.append("width: 100%; height: " + (100 / nVertical) + "%;' >");
			for (int j = 0; j < nHorizon; j++) {
				int subMenuRowNum = i * nHorizon + j;
				if (subMenuRowNum < subMenuRowCount) {
					Vector subMenuVectorRow = (Vector) DataVector.get(subMenuRowNum);
					String m_menu_id = subMenuVectorRow.get(1).toString();
					String m_menu_name = subMenuVectorRow.get(2).toString();
					String m_menu_level = subMenuVectorRow.get(8).toString();
					String subMenuOnclickFn = "";
					if (m_menu_level.equals("1")) {
						makeSubSubMenuTablet(HeadmenuID, HeadmenuName, m_menu_id, m_menu_name); // ���꼭��޴�(Lv.2) �����
						subMenuOnclickFn = "fn_SubSubMenu_show(this,'" + HeadmenuID + "','" + m_menu_id + "')";
					} else if (m_menu_level.equals("2")) {
						subMenuOnclickFn = "fn_popup_ContentMain(this,'" + HeadmenuID + "','" + HeadmenuName + "','"
								+ m_menu_id + "')";
					}
					vHtmlSubMenu.append("<div style='float: left; padding: 5px; ");
					vHtmlSubMenu.append("width: " + (100 / nHorizon) + "%; height: 100%;' >");
					vHtmlSubMenu.append("	<button class='btn-primary' style='width:100%; height:100%;' onclick=\""
							+ subMenuOnclickFn + "\">");
					vHtmlSubMenu.append(m_menu_name);
					vHtmlSubMenu.append("	</button>");
					vHtmlSubMenu.append("</div>");
				} else {
					break;
				}
			}
			vHtmlSubMenu.append("</div>");
		}
		vHtmlSubMenu.append("</div>");

		htmlSubMenu.append(vHtmlSubMenu.toString());
	}

	private void makeSubSubMenuTablet(String HeadmenuID, String HeadmenuName, String SubMenuID, String SubmenuName) { // menu_level
																														// 2
		StringBuffer vHtmlSubSubMenu = new StringBuffer(); // �������� �ӽ� ��Ʈ������
		Vector DataVector = new Vector(); // �������� �ӽ� �����͹���

		// SubMenuID�� ���� ���꼭��޴� ã�Ƽ� DataVector�� ����
		for (int i = 0; i < subSubMenuVector.size(); i++) {
			Vector subSubMenuVectorRow = (Vector) subSubMenuVector.get(i);
			if (subSubMenuVectorRow.get(9).equals(SubMenuID)) { // parent_id�� SubMenuID ��
				DataVector.add(subSubMenuVectorRow);
			}
		}

		// ���꼭��޴� ���μ��� ĭ�� ���ϱ�
		int subSubMenuRowCount = DataVector.size(); // ���꼭��޴� ���ڵ� ����
		int nHorizon = (int) Math.ceil(Math.sqrt(subSubMenuRowCount)); // ���� ĭ ���� -> ������(sqrt) ���� �� �Ҽ��� �ø�
		int nVertical = (int) Math.ceil((double) subSubMenuRowCount / nHorizon); // ���� ĭ ���� -> �� �������� ���� ĭ ���� ���� �� �Ҽ���
																					// �ø�
		// ���꼭��޴�(Lv.2)����
		vHtmlSubSubMenu.append("<div id='subSubMenu_" + HeadmenuID + "_" + SubMenuID
				+ "' style='margin:auto; float: left; display:none; ");
		vHtmlSubSubMenu.append("width: 100%; height: " + (nVertical * 100) + "px;' >");
		for (int i = 0; i < nVertical; i++) {
			vHtmlSubSubMenu.append("<div id='subSubMenu_row_wrap' style=' ");
			vHtmlSubSubMenu.append("width: 100%; height: " + (100 / nVertical) + "%;' >");
			for (int j = 0; j < nHorizon; j++) {
				int subSubMenuRowNum = i * nHorizon + j;
				if (subSubMenuRowNum < subSubMenuRowCount) {
					Vector subSubMenuVectorRow = (Vector) DataVector.get(subSubMenuRowNum);
					String m_menu_id = subSubMenuVectorRow.get(1).toString();
					String m_menu_name = subSubMenuVectorRow.get(2).toString();
					vHtmlSubSubMenu.append("<div style='float: left; padding: 5px; ");
					vHtmlSubSubMenu.append("width: " + (100 / nHorizon) + "%; height: 100%;' >");
					vHtmlSubSubMenu.append(
							"	<button class='btn-primary' style='width:100%; height:100%;' onclick=\"fn_popup_ContentMain(this,'"
									+ HeadmenuID + "','" + HeadmenuName + "','" + m_menu_id + "','" + SubmenuName
									+ "')\" >");
					vHtmlSubSubMenu.append(m_menu_name);
					vHtmlSubSubMenu.append("	</button>");
					vHtmlSubSubMenu.append("</div>");
				} else {
					break;
				}
			}
			vHtmlSubSubMenu.append("</div>");
		}
		vHtmlSubSubMenu.append("</div>");

		htmlSubSubMenu.append(vHtmlSubSubMenu.toString());
	}
}