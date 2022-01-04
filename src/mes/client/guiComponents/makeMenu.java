package mes.client.guiComponents;

import java.util.Vector;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import mes.client.conf.Config;
import mes.frame.common.HashObject;

public class makeMenu {
	public String HeadMenu="";
	public String sideMenu="";
	public DoyosaeTableModel meModel,TableModel;
	StringBuffer html = new StringBuffer();
	public int RowCount=0, CMRowCount=0;
    int RowNum=0;
	String[] strColumnBalju = {"class_id", "MENU_ID","MENU_NAME","autho_menu","autho_insert",
			"autho_update","autho_delete","autho_select","menu_level","parent_menu_id","program_id" };
	String[] strColumnHead 	= {"사업자 번호", "개정번호", "회사명", "주소", "전화번호", "대표이름", "업태", "종목", "팩스", "홈페이지", "우편번호" } ;
	String packageName;
	String programID;
	String paneNameKor;
	String MenuTitle;
	String CompayName;
	String CompayLogoImageFileName;
	public String authoError = ""; //프로그램 권한이 없을경우 에러메세지

	public makeMenu (String userID, String HeadmenuID, String group_cd) {
		String param = userID + "|" + HeadmenuID + "|" + group_cd + "|";
		meModel = new DoyosaeTableModel("M000S100000E002", strColumnBalju, param);	
		RowCount = meModel.getRowCount();
		
		JSONObject jAJSONObject = new JSONObject();
		
		TableModel = new DoyosaeTableModel("M909S150100E114", strColumnHead, jAJSONObject);
		CMRowCount = TableModel.getRowCount();
		if(CMRowCount>0) {
			CompayLogoImageFileName = TableModel.getValueAt(0,11).toString().trim();
			CompayName = TableModel.getValueAt(0,2).toString().trim();
		} else {
			CompayLogoImageFileName = "";
			CompayName ="우리회사정보를 등록하세요";
		}
			
		// 로그인한 아이디에 프로그램 권한이 없을경우 에러메세지(ERROR) 전달
		if(RowCount > 0) authoError = "";
		else authoError = "ERROR";
	}	
	public String GetHeadMenu() {
		return makeHeadMenu();
	}
	
	public String GetsideMenu(String HeadmenuID, String HeadmenuName) {
		return makesideMenu(HeadmenuID,HeadmenuName);
	}

	private String makeHeadMenu() {
		html = new StringBuffer();

		html.append("<ul class='nav navbar-nav' id='head_ul'>");
		if(RowCount>0) {
	        for( RowNum=0; RowNum < RowCount; RowNum++){ // menu_level 0(헤드메뉴) 구성     	
				if (meModel.getValueAt(RowNum,3).toString().equals("1") && meModel.getValueAt(RowNum,8).toString().equals("0")) {	//autho_menu=1, menu_level=0=> Head Menu
					 packageName = meModel.getValueAt(RowNum,0).toString();	
					 paneNameKor = meModel.getValueAt(RowNum,2).toString();
					 if((RowNum+1)< RowCount) {
						 programID = meModel.getValueAt(RowNum+1,10).toString();
						 MenuTitle = meModel.getValueAt(RowNum+1,2).toString();
					 }
					if(RowNum==0)
						html.append("<li class='active' id='head_li'>") ;
					else
						html.append("<li class='header' id='head_li'>") ;
					html.append("<a");
					html.append(">");
					html.append( paneNameKor );
					html.append("</a>");
					
					// Dropdown 메뉴구성
					String menuID = meModel.getValueAt(RowNum,1).toString();
					html.append( makeSubMenu(packageName, paneNameKor, menuID) );
			        
					html.append("</li>");
				}
	        }
	        
	        // 회사로고(없을경우 회사명) - 클릭하면 우리회사정보등록으로 넘어감
	        html.append("<li  class='header' id='head_li'>");
        	html.append("<a  onclick=\"return fn_ContentMain(this,'" + Config.this_SERVER_path 
						+ "/Contents/M000/M606S000000.jsp','M909','기준정보','M909S150100.jsp','우리회사정보등록')\">");
        	html.append( CompayName + " MES ");
        	html.append("</a>");
	        html.append("</li>");
		}
        html.append("</ul>");        

        html.toString();
        return html.toString();
	}

	private String makeSubMenu(String HeadmenuID, String HeadmenuName, String ParentMenuID) { // menu_level 1 or 2
		//전역변수 사용하면 상위 변수(RowNum,html)에 영향 미치므로, 지역변수 새로 선언
		int SubRowNum = 0;
		StringBuffer Subhtml = new StringBuffer();
		
		Subhtml.append("<div class='dropdown-content' style='z-index:1;'>") ;
		Subhtml.append("	<ul id='MenuLv1_ul' style='width:max-content;' >") ;
        for( SubRowNum=0; SubRowNum < RowCount; SubRowNum++){ 
        	String menuspace="";
        	String jspprogramID = meModel.getValueAt(SubRowNum,10).toString();		
        	
        	if(meModel.getValueAt(SubRowNum,9).toString().equals(ParentMenuID)){ // parrnt_menu_id 검사
        		 if(meModel.getValueAt(SubRowNum,4).toString().equals("1") || 	//autho_insert
        			meModel.getValueAt(SubRowNum,5).toString().equals("1") ||	//autho_update
        			meModel.getValueAt(SubRowNum,6).toString().equals("1") ||	//autho_delete
        			meModel.getValueAt(SubRowNum,7).toString().equals("1")) {	//autho_select
        			// menu_level 1 Or 2 => Head Menu에 1레벨(Sub Menu) 없을경우 바로 2레벨을 Sub Menu로
					if (Integer.parseInt(meModel.getValueAt(SubRowNum,8).toString()) == 1) { // menu_level 1이 있으면, Lv1 표시
						String SubMenuID = meModel.getValueAt(SubRowNum,1).toString();
						String SubMenuName = meModel.getValueAt(SubRowNum,2).toString();
						Subhtml.append("<li class='list-group-item' id=" + jspprogramID + "'_li' >") ;
						Subhtml.append( "<div style='float:left; width:inherit;'>");
						Subhtml.append(  "<span style='float:left;'>" + menuspace + SubMenuName + "</span>" );
						Subhtml.append(  "<span style='float:right;'>" + "&nbsp;&nbsp;" + " >> " + "</span>" ); // SubSub메뉴 있다는 표시 화살표( >> )
						Subhtml.append( "</div>" );
						Subhtml.append(makeSubSubMenu(HeadmenuID, HeadmenuName, SubMenuID, SubMenuName)); // subsubmenu 부르기
				        Subhtml.append("</li>");
					} else if(Integer.parseInt(meModel.getValueAt(SubRowNum,8).toString()) == 2) { // menu_level 1이 없으면, Sub Menu(Lv1)부분에 Lv2를 표시
						Subhtml.append("<li class='list-group-item' id=" + jspprogramID + "'_li' ") ;
						Subhtml.append(" onclick=\" return fn_MainSubMenuSelected(this, '" + Config.this_SERVER_path + "/Contents/" + HeadmenuID + "/"  
										+ jspprogramID + "','" + HeadmenuID + "','" + HeadmenuName + "','" + jspprogramID + "' );  \" > "  //'class='list-group-item' 
										+ menuspace
										+ meModel.getValueAt(SubRowNum,2).toString() );
				        Subhtml.append("</li>");
					}
				 }
        	}      
        }
        Subhtml.append("	</ul>") ;
        Subhtml.append("</div>") ;
        
        Subhtml.toString();
        return Subhtml.toString();
	}
	
	private String makeSubSubMenu(String HeadmenuID, String HeadmenuName, String SubMenuID, String SubmenuName) { // menu_level 2
		//전역변수 사용하면 상위 변수(RowNum,html)에 영향 미치므로, 지역변수 새로 선언
		int SubSubRowNum = 0;
		StringBuffer SubSubhtml = new StringBuffer();
		
		// Dropdown(menu_level 2) 메뉴구성
		SubSubhtml.append("<div class='dropdown-content-lv2'>") ;
		SubSubhtml.append("	<ul>") ;
        for( SubSubRowNum=0; SubSubRowNum < RowCount; SubSubRowNum++){ // menu_level 1 하위의 2레벨 메뉴 표시
        	String menuspace="";
        	String jspprogramID = meModel.getValueAt(SubSubRowNum,10).toString();
        	if(meModel.getValueAt(SubSubRowNum,9).toString().equals(SubMenuID)){ // parrnt_menu_id 검사
        		if (Integer.parseInt(meModel.getValueAt(SubSubRowNum,8).toString()) == 2) {		//menu_level == 2 Sub SubMenue
					if(meModel.getValueAt(SubSubRowNum,4).toString().equals("1") || 	//autho_insert
					   meModel.getValueAt(SubSubRowNum,5).toString().equals("1") ||	//autho_update
					   meModel.getValueAt(SubSubRowNum,6).toString().equals("1") ||	//autho_delete
					   meModel.getValueAt(SubSubRowNum,7).toString().equals("1")) {	//autho_select
						
						SubSubhtml.append("<li class='list-group-item' id=" + jspprogramID + "'_li' ") ;
						SubSubhtml.append(" onclick=\" return fn_MainSubMenuSelected(this, '" 
									+ Config.this_SERVER_path + "/Contents/" + HeadmenuID + "/" + jspprogramID + "','" 
									+ HeadmenuID + "','" + HeadmenuName + "','" + jspprogramID + "','" + SubmenuName + "' );  \" > "  //'class='list-group-item' 
									+ menuspace
									+ meModel.getValueAt(SubSubRowNum,2).toString() );
						SubSubhtml.append("</li>");
					}
				}
        	}
        }
        SubSubhtml.append("	</ul>") ;
        SubSubhtml.append("</div>") ;
        
        SubSubhtml.toString();
        return SubSubhtml.toString();
	}

	private String makesideMenu(String HeadmenuID, String HeadmenuName) {
		html = new StringBuffer();
		
        for( RowNum=0; RowNum < RowCount; RowNum++){ 
        	String menuspace="";
        	String jspprogramID = meModel.getValueAt(RowNum,10).toString();		
        	if(meModel.getValueAt(RowNum,0).toString().equals(HeadmenuID)){
				if (Integer.parseInt(meModel.getValueAt(RowNum,8).toString()) > 0) {		//menu_level > 0 Sub Menu or Sub SubMenue
					if(meModel.getValueAt(RowNum,4).toString().equals("1") || 	//autho_insert
					   meModel.getValueAt(RowNum,5).toString().equals("1") ||	//autho_update
					   meModel.getValueAt(RowNum,6).toString().equals("1") ||	//autho_delete
					   meModel.getValueAt(RowNum,7).toString().equals("1")) {	//autho_select
						
						html.append("<li class='list-group-item' id=" + jspprogramID + "'_li' ") ;
						html.append(" onclick=\\\" return fn_MainSubMenuSelected(this, '" + Config.this_SERVER_path + "/Contents/" + HeadmenuID + "/"  
									+ jspprogramID + "','" + HeadmenuID + "','" + HeadmenuName + "','" + jspprogramID + "' );  \\\" > "  //'class='list-group-item' 
									+ menuspace
									+ meModel.getValueAt(RowNum,2).toString() );
			            html.append("</li>");
					}
				}
        	}      
        }
        
        html.toString();
        return html.toString();
	}
	
	public String getValueAt(String RowNum,int col) {
		int Row = Integer.parseInt(RowNum);
		return meModel.getValueAt(Row,col).toString();
	}
	public String getAuthorityOfProgram() {
		StringBuffer authoProgram = new StringBuffer();
		StringBuffer program_id = new StringBuffer();
		StringBuffer autho_insert = new StringBuffer();
		StringBuffer autho_update = new StringBuffer();
		StringBuffer autho_delete = new StringBuffer();
		StringBuffer autho_select = new StringBuffer();
		if(RowCount > 0) {
			authoProgram.append("var authoProgram = {\n");
			program_id.append	("program_id	: [\"" +  meModel.getValueAt(0,10).toString() + "\",");
			autho_insert.append	("autho_insert	: [\"" +  meModel.getValueAt(0,4).toString() + "\",");
			autho_update.append	("autho_update	: [\"" +  meModel.getValueAt(0,5).toString() + "\",");
			autho_delete.append	("autho_delete	: [\"" +  meModel.getValueAt(0,6).toString() + "\",");
			autho_select.append	("autho_select	: [\"" +  meModel.getValueAt(0,7).toString() + "\",");
	        for( RowNum=1; RowNum < RowCount; RowNum++){ 
				if (Integer.parseInt(meModel.getValueAt(RowNum,8).toString()) > 0) {		//menu_level > 0 Sub Menu or Sub SubMenue
					program_id.append	("\"" +  meModel.getValueAt(RowNum,10).toString() + "\",");
					autho_insert.append	("\"" +  meModel.getValueAt(RowNum,4).toString() + "\",");
					autho_update.append	("\"" +  meModel.getValueAt(RowNum,5).toString() + "\",");
					autho_delete.append	("\"" +  meModel.getValueAt(RowNum,6).toString() + "\",");
					autho_select.append	("\"" +  meModel.getValueAt(RowNum,7).toString() + "\",");
				}
	        }
			program_id.append  ("\"\"],\n");
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
		}
		else			
			authoProgram.append("var authoProgram='ERROR'");
		return authoProgram.toString();
	}

	public JSONObject getAuthorityOfProgramOnJSP(String program_id) {
		JSONArray authoProgram = new JSONArray();
		JSONObject rtnProgram = new JSONObject();

		if(RowCount > 0) {
	        for( RowNum=1; RowNum < RowCount; RowNum++){ 
	    		JSONObject program = new JSONObject();
				if (program_id.trim().equals(meModel.getValueAt(0,10).toString().trim())) {		
					program.put("program_id", meModel.getValueAt(RowNum,10).toString());
					program.put("insert", meModel.getValueAt(RowNum,4).toString());
					program.put("update", meModel.getValueAt(RowNum,5).toString());
					program.put("delete", meModel.getValueAt(RowNum,6).toString());
					program.put("select", meModel.getValueAt(RowNum,7).toString());
					authoProgram.add(program);
					rtnProgram.put(meModel.getValueAt(RowNum,10).toString(),authoProgram);
				}
	        }			
		}
					
		return rtnProgram;
	}
	
	// 이 밑으론 태블릿 메뉴구성 관련  //////////////////////////////////
	private Vector headMenuVector = new Vector();
	private Vector subMenuVector = new Vector();
	private Vector subSubMenuVector = new Vector();
	
	private StringBuffer htmlHeadMenu = new StringBuffer();
	private StringBuffer htmlSubMenu = new StringBuffer();
	private StringBuffer htmlSubSubMenu = new StringBuffer();
	
	public String GetHeadMenuTablet() {
		return makeHeadMenuTablet();
	}
	
	private void makeMenuVector() { // 쿼리문 결과(meModel)를 각각의 Vector로 나눔
		for(RowNum=0; RowNum<RowCount; RowNum++) {
			// headMenu
			if (meModel.getValueAt(RowNum,3).toString().equals("1") && meModel.getValueAt(RowNum,8).toString().equals("0")) {	//autho_menu=1, menu_level=0=> Head Menu
				Vector headMenuVectorRow = new Vector();
				for(int i=0; i<strColumnHead.length; i++ ) {
					headMenuVectorRow.add( meModel.getValueAt(RowNum,i).toString() );
				}
				headMenuVector.add(headMenuVectorRow);
			}
			// subMenu
			if (meModel.getValueAt(RowNum,3).toString().equals("1") && meModel.getValueAt(RowNum,8).toString().equals("1")) {	//autho_menu=1, menu_level=1=> Sub Menu
				Vector subMenuVectorRow = new Vector();
				for(int i=0; i<strColumnHead.length; i++ ) {
					subMenuVectorRow.add( meModel.getValueAt(RowNum,i).toString() );
				}
				subMenuVector.add(subMenuVectorRow);
			}
			// subSubMenu
			if (meModel.getValueAt(RowNum,3).toString().equals("1") && meModel.getValueAt(RowNum,8).toString().equals("2")) {	//autho_menu=1, menu_level=2=> Sub Sub Menu
				Vector subSubMenuVectorRow = new Vector();
				for(int i=0; i<strColumnHead.length; i++ ) {
					subSubMenuVectorRow.add( meModel.getValueAt(RowNum,i).toString() );
				}
				subSubMenuVector.add(subSubMenuVectorRow);
			}
		}
	}
	
	private String makeHeadMenuTablet() {
		// 전역변수 스트링버퍼 초기화
		html = new StringBuffer();
		htmlHeadMenu = new StringBuffer();
		htmlSubMenu = new StringBuffer();
		htmlSubSubMenu = new StringBuffer();
		
		if(RowCount>0) {
			makeMenuVector(); // 쿼리문 결과(meModel)를 각각의 Vector로 나눔
				
			// 헤드메뉴 가로세로 칸수 정하기
			int headMenuRowCount = headMenuVector.size(); // 헤드메뉴 레코드 개수
			int nHorizon  = (int)Math.ceil(Math.sqrt(headMenuRowCount)); 		// 가로 칸 개수 -> 제곱근(sqrt) 구한 후 소수점 올림
			int nVertical = (int)Math.ceil((double)headMenuRowCount/nHorizon); 	// 세로 칸 개수 -> 총 개수에서 가로 칸 개수 나눈 후 소수점 올림
			
			// 헤드메뉴(Lv.0)구성
			htmlHeadMenu.append("<div id='headMenu' style='margin:auto; float: left; ");
			htmlHeadMenu.append(	"width: 100%; height: " + (nVertical*100) + "px;' >");
			for(int i=0; i<nVertical; i++) {
				htmlHeadMenu.append("<div id='headMenu_row_wrap' style=' ");
				htmlHeadMenu.append(	"width: 100%; height: " + (100/nVertical) + "%;' >");
				for(int j=0; j<nHorizon; j++) {
					int headMenuRowNum = i*nHorizon + j ;
					if(headMenuRowNum < headMenuRowCount) {
						Vector headMenuVectorRow = (Vector)headMenuVector.get(headMenuRowNum);
						String m_class_id 	= headMenuVectorRow.get(0).toString();	
						String m_menu_id 	= headMenuVectorRow.get(1).toString();	
						String m_menu_name 	= headMenuVectorRow.get(2).toString();
						
						htmlHeadMenu.append("<div style='float: left; padding: 5px; ");
						htmlHeadMenu.append(	"width: " + (100/nHorizon) +"%; height: 100%;' >");
						htmlHeadMenu.append("	<button id='"+m_class_id+"' class='btn-primary' style='width:100%; height:100%;' onclick=\"fn_SubMenu_show(this,'"+m_class_id+"')\" >");
						htmlHeadMenu.append(		m_menu_name );
						htmlHeadMenu.append("	</button>");
						htmlHeadMenu.append("</div>");
						
						makeSubMenuTablet(m_class_id, m_menu_name, m_menu_id); // 서브메뉴(LV.1 또는 Lv.2) 만들기
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
		StringBuffer vHtmlSubMenu = new StringBuffer(); // 지역변수 임시 스트링버퍼
		Vector DataVector = new Vector(); // 지역변수 임시 데이터백터
		
		// HeadMenuID로 하위 서브메뉴 찾아서 DataVector에 복사
		for(int i=0; i<subMenuVector.size(); i++) { 
			Vector subMenuVectorRow = (Vector)subMenuVector.get(i);
			if(subMenuVectorRow.get(9).equals(ParentMenuID)) { // 서브메뉴의 parent_id와 헤드메뉴의 program_id  비교
				DataVector.add(subMenuVectorRow);
			}
		}
		// HeadMenuID로 하위 서브서브메뉴 찾아서 DataVector에 복사
		for(int i=0; i<subSubMenuVector.size(); i++) { 
			Vector subSubMenuVectorRow = (Vector)subSubMenuVector.get(i);
			if(subSubMenuVectorRow.get(9).equals(ParentMenuID)) { // 서브서브메뉴의 parent_id와 헤드메뉴의 program_id  비교
				DataVector.add(subSubMenuVectorRow);
			}
		}
		
		// 서브메뉴 가로세로 칸수 정하기
		int subMenuRowCount  = DataVector.size(); // 서브메뉴 레코드 개수
		int nHorizon  = (int)Math.ceil(Math.sqrt(subMenuRowCount)); 		// 가로 칸 개수 -> 제곱근(sqrt) 구한 후 소수점 올림
		int nVertical = (int)Math.ceil((double)subMenuRowCount/nHorizon);  // 세로 칸 개수 -> 총 개수에서 가로 칸 개수 나눈 후 소수점 올림
		
		// 서브메뉴(Lv.1 또는 Lv.2)구성
		vHtmlSubMenu.append("<div id='subMenu_"+HeadmenuID+"' style='margin:auto; float: left; display:none; ");
		vHtmlSubMenu.append(	"width: 100%; height: " + (nVertical*100) + "px;' >");
		for(int i=0; i<nVertical; i++) {
			vHtmlSubMenu.append("<div id='subMenu_row_wrap' style=' ");
			vHtmlSubMenu.append(	"width: 100%; height: " + (100/nVertical) + "%;' >");
			for(int j=0; j<nHorizon; j++) {
				int subMenuRowNum = i*nHorizon + j ;
				if( subMenuRowNum < subMenuRowCount ) {
					Vector subMenuVectorRow = (Vector)DataVector.get(subMenuRowNum);
					String m_menu_id 	= subMenuVectorRow.get(1).toString();	
					String m_menu_name 	= subMenuVectorRow.get(2).toString();
					String m_menu_level	= subMenuVectorRow.get(8).toString();
					String subMenuOnclickFn = "";
					if(m_menu_level.equals("1")) {
						makeSubSubMenuTablet(HeadmenuID, HeadmenuName, m_menu_id, m_menu_name); // 서브서브메뉴(Lv.2) 만들기
						subMenuOnclickFn = "fn_SubSubMenu_show(this,'"+HeadmenuID+"','"+m_menu_id+"')";
					} else if(m_menu_level.equals("2")) {
						subMenuOnclickFn = "fn_popup_ContentMain(this,'"+HeadmenuID+"','"+HeadmenuName+"','"+m_menu_id+"')";
					}
					vHtmlSubMenu.append("<div style='float: left; padding: 5px; ");
					vHtmlSubMenu.append(	"width: " + (100/nHorizon) +"%; height: 100%;' >");
					vHtmlSubMenu.append("	<button class='btn-primary' style='width:100%; height:100%;' onclick=\""+subMenuOnclickFn+"\">");
					vHtmlSubMenu.append(		m_menu_name );
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
	
	private void makeSubSubMenuTablet(String HeadmenuID, String HeadmenuName, String SubMenuID, String SubmenuName) { // menu_level 2
		StringBuffer vHtmlSubSubMenu = new StringBuffer(); // 지역변수 임시 스트링버퍼
		Vector DataVector = new Vector(); // 지역변수 임시 데이터백터
		
		// SubMenuID로 하위 서브서브메뉴 찾아서 DataVector에 복사
		for(int i=0; i<subSubMenuVector.size(); i++) { 
			Vector subSubMenuVectorRow = (Vector)subSubMenuVector.get(i);
			if(subSubMenuVectorRow.get(9).equals(SubMenuID)) { // parent_id와 SubMenuID 비교
				DataVector.add(subSubMenuVectorRow);
			}
		}
		
		// 서브서브메뉴 가로세로 칸수 정하기
		int subSubMenuRowCount  = DataVector.size(); // 서브서브메뉴 레코드 개수
		int nHorizon  = (int)Math.ceil(Math.sqrt(subSubMenuRowCount)); 		// 가로 칸 개수 -> 제곱근(sqrt) 구한 후 소수점 올림
		int nVertical = (int)Math.ceil((double)subSubMenuRowCount/nHorizon);  // 세로 칸 개수 -> 총 개수에서 가로 칸 개수 나눈 후 소수점 올림
		
		// 서브서브메뉴(Lv.2)구성
		vHtmlSubSubMenu.append("<div id='subSubMenu_"+HeadmenuID+"_"+SubMenuID+"' style='margin:auto; float: left; display:none; ");
		vHtmlSubSubMenu.append(	"width: 100%; height: " + (nVertical*100) + "px;' >");
		for(int i=0; i<nVertical; i++) {
			vHtmlSubSubMenu.append("<div id='subSubMenu_row_wrap' style=' ");
			vHtmlSubSubMenu.append(	"width: 100%; height: " + (100/nVertical) + "%;' >");
			for(int j=0; j<nHorizon; j++) {
				int subSubMenuRowNum = i*nHorizon + j ;
				if( subSubMenuRowNum < subSubMenuRowCount ) {
					Vector subSubMenuVectorRow = (Vector)DataVector.get(subSubMenuRowNum);
					String m_menu_id 	= subSubMenuVectorRow.get(1).toString();	
					String m_menu_name 	= subSubMenuVectorRow.get(2).toString();
					vHtmlSubSubMenu.append("<div style='float: left; padding: 5px; ");
					vHtmlSubSubMenu.append(	"width: " + (100/nHorizon) +"%; height: 100%;' >");
					vHtmlSubSubMenu.append("	<button class='btn-primary' style='width:100%; height:100%;' onclick=\"fn_popup_ContentMain(this,'"+HeadmenuID+"','"+HeadmenuName+"','"+m_menu_id+"','"+SubmenuName+"')\" >");
					vHtmlSubSubMenu.append(		m_menu_name );
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
