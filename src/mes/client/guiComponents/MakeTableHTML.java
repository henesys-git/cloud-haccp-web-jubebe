package mes.client.guiComponents;

import java.util.Vector;

/**
 * @author jlnho
 *
 */
public class MakeTableHTML { 
	public int pageSize;
	public int currentPageNum;
	public String htmlTable_ID="";
	public String Table_Class="";
	public String TR_Style[];
	public String TD_Style[];	//[0]=1, [1]="style="font-weight: bold" =>> 0번째 TD의 style처리
	public String HyperLink[]; 	//	List<String> oPerlishArray = new ArrayList<String>();
	public String Check_Box="false";	//true or false값을 세팅한다
	public int colOff[]; 		//colOff가 0이면 input type=hidden으로 처리
	public String Radtio_Buttob[]= {"false"};
	public int TotalPageNumber;
	public int colCount;
	public String RightButton[][];
	public String MAX_HEIGHT="";
	public String jsp_page="";
	public String user_id ="";
	public String orderno ="";

	DoyosaeTableModel TableModel;
	Vector fieldNameVector;
	int rowCount=0;
	
	public MakeTableHTML(Object Model) {
		if(Model instanceof EdmsDoyosaeTableModel) {
			this.TableModel = (EdmsDoyosaeTableModel)Model;		
			fieldNameVector = (Vector) TableModel.getVector().get(0);
			TableModel.delete(0);
		}
		else {
			this.TableModel = (DoyosaeTableModel)Model;		
		}
		rowCount=TableModel.getRowCount();	
	}
	
	public String getHTML() {
		int btn=0;
		StringBuffer html = new StringBuffer();
		try{		

			html.append("<table class='table table-bordered nowrap table-hover' id='" + htmlTable_ID + "' style='width:100%' >");
			html.append(" <thead >");
			html.append(" <tr " + getTRStyle(0) +  ">"); 
			
			if(Check_Box.equals("true")) {
				html.append("  <th >"
						+ "<input type='checkbox'  id='checkboxAll'/>"
						+ "</th>");
			}

			//테이블 헤드 생성 
			for(int col=0; col < colCount; col++) {
				if(colOff[col] > 0) {
					html.append("  <th >");

					html.append("  "
							+ TableModel.getColumnName(col) 
							);		//테이블 Head의 칼럼 명
					html.append("  </th>");
				}
				else
				{
					html.append("  <th   style='width:0px; display: none ' >");
					html.append("  </th>");
				}
			}

	    	for(btn=0; btn<RightButton.length; btn++) {
		    	if(RightButton[btn][0].equals("on")) {
	    			html.append("   <th></th>" );
		    	}
	    	}
			
			html.append(" </tr>");
			html.append(" </thead>");
	
   
	        String fileName = "";
			html.append(" <tbody  id='" + htmlTable_ID + "_tbody' >");    	
			if(rowCount > 0) {
				for(int row = 0; row < rowCount; row++) { 
						html.append(" <tr id='" + htmlTable_ID + "_rowID' " + getTRStyle(1) + ">");
					if(Check_Box.equals("true")) {
						html.append("  <td style='vertical-align: middle; width:30px; '><input type='checkbox'  id='checkbox1'  /></td>");
					}
	
	    			StringBuffer html_btn = new StringBuffer();
	
			    	for(btn=0; btn<RightButton.length; btn++) {
				    	if(RightButton[btn][0].equals("on")) {
				    		if(fieldNameVector != null) { //fieldName을 비교하는 경우
					    		switch (RightButton[btn][2]) {
							    	case "챠트보기":
						    			html_btn.append("<td  >  <button style='width: auto; float: left; ' type='button'" );
							    		html_btn.append(" onclick=' fn_Chart_View()' ");
							    		html_btn.append(" id='right_btn_chart' class='btn btn-outline-success' >" + RightButton[btn][2] + "</button></td>");
							    		break;
							    	case "문서개정":
							    		for(int col=0; col<colCount; col++){
							    			if(fieldNameVector.get(col).toString().equals(RightButton[btn][1])) {
								    			html_btn.append("<td  >  <button style='width: auto; float: left; ' type='button'" );
							    				html_btn.append(" onclick=\" fn_right_btn_view('" + TableModel.getValueAt(row,col).toString().trim() + "',this,'revision')\" ");
									    		html_btn.append(" id='right_btn_reg' class='btn btn-outline-success' >" + RightButton[btn][2] + "</button></td>");
								    		}
							    		}
							    		break;
						    		case "문서View":
							    		for(int col=0; col<colCount; col++){
							    			if(fieldNameVector.get(col).toString().equals(RightButton[btn][1])) {
								    			html_btn.append("<td  >  <button style='width: auto; float: left; ' type='button'" );
							    				html_btn.append(" onclick=\" fn_right_btn_view('" + TableModel.getValueAt(row,col).toString().trim() + "',this,'view')\" ");
									    		html_btn.append(" id='right_btn_view' class='btn btn-outline-warning' >" + RightButton[btn][2] + "</button></td>");
								    		}
							    		}
						    			break;
					    		}
							}
				    		else {//fieldName을 비교할 필요가 없는 경우 
					    		html_btn.append("<td  >  <button style='width: auto; float: left; ' type='button'" );
				    			if(RightButton[btn][2].equals("삭제")) {
					    			int leftBr = RightButton[btn][1].indexOf("(", 0);//함수명에 parameter가 있는지 확인
					    			if(leftBr > 0) {
						    			int rightBr = RightButton[btn][1].indexOf(")", 0);
						    			String pArm = RightButton[btn][1].substring(leftBr, rightBr).trim();

						    			if(pArm.length() > 1)	//parameter가 있는 경우 함수를 구대로 사용
								    		html_btn.append(" onclick='" + RightButton[btn][1]  + "' ");
						    			else	//parameter가 없는 경우 함수를 재 구성
						    				html_btn.append(" onclick='" + RightButton[btn][1].substring(leftBr, rightBr).trim() + "(" + row + ")' ");
					    			}
					    			else {//()가 �〈� 경우  ^^ 잘 정의해라
					    				html_btn.append(" onclick='" + RightButton[btn][1] + "(" + row + ")' ");
					    			}
				    			}
				    			else {
					    			html_btn.append(" onclick='" + RightButton[btn][1] + "' ");
				    			}
					    		html_btn.append(" id='right_btn' class='btn btn-outline-success' >" + RightButton[btn][2] + "</button></td>");
				    		}
				    	}
			    	} 
			    	for(int col=0; col<colCount; col++){
			    		if(colOff[col] > 0) {
			    			html.append(" <td >");
			    			if(getHyperLink(col).length()>1) {
				    			html.append("     <a href='#' onclick='" + getHyperLink(col) + "'>");
				    			html.append( TableModel.getValueAt(row,col).toString().trim());
				    			html.append("     </a>");
			    			}
			    			else {
			    				html.append( TableModel.getValueAt(row,col).toString().trim());
			    			}
			    			if(colOff[col]==9999) {
			    				html.append("<div style='overflow-y:scroll; width:auto;  height:100; padding:4px'>");
			    				html.append( TableModel.getValueAt(row,col).toString().trim());
			    				html.append("<div>");			    				
			    			}
			    			html.append("  </td>");	
			    		}
			    		else {
			    			html.append(" <td style='width:0px; display: none ' >"); 
			    			html.append( TableModel.getValueAt(row,col).toString().trim());
			    			html.append("  </td>");	
			    		}
					}
			    	html.append(html_btn.toString());
					html.append(" </tr>");
				} 
			}
			html.append("</tbody>");
			html.append("</table>");
		}
		catch (Exception e) {
			e.printStackTrace();
		}
		return html.toString();
	}

	private String getTRStyle(int row) {
		String retStr="";
		try {
			retStr=TR_Style[row].toString();
		}
		catch(Exception e) {
			retStr="";
		}
		return retStr;
	}
	
//	TD_Style에 저장되어있는 속성을 col번째를 리턴 함
//	colCount보다 큰 Col의 값을 찾으면 ""을 리턴 함	
	private String getTDStyle(int col) {
		String retStr="";
		try {
			retStr=TD_Style[col].toString();
		}
		catch(Exception e) {
			retStr="";
		}
		return retStr;
	}

	private String getHyperLink(int col) {
		String retStr="";
		try {
			retStr=HyperLink[col].toString();
		}
		catch(Exception e) {
			retStr="";
		}
		return retStr;
	}
	
	public String get_Table() {

		StringBuffer data = new StringBuffer();
		int row;
		int col;
		data.append("["); 
		for(row = 0; row < rowCount-1; row++) {
			data.append("["); 
	    	for( col=0; col<colCount-1; col++){

				if(colOff[col] > 0) 
					data.append("\"" + TableModel.getValueAt(row,col).toString().trim() + "\","); 
	    	}	
			if(colOff[col] > 0) 
				data.append("\"" + TableModel.getValueAt(row,col).toString().trim() + "\""); 
			else
	    		data.append("\"  \""); 
				
			data.append("],"); 		
		}
		
		data.append("["); 
    	for( col=0; col<colCount-1; col++){

			if(colOff[col] > 0) 
				data.append("\"" + TableModel.getValueAt(row,col).toString().trim() + "\","); 
    	}	
		if(colOff[col] > 0) 
			data.append("\"" + TableModel.getValueAt(row,col).toString().trim() + "\""); 
		else
    		data.append("\"  \""); 
			
		data.append("]"); 		
		data.append("]"); 
		return data.toString();
	}

	public String get_Table_Title() {

		StringBuffer data = new StringBuffer();

		data.append("["); 
		int col=0;
    	for( col=0; col<colCount-1; col++){

			if(colOff[col] > 0) 
				data.append("{ Title: \"" + TableModel.getColumnName(col) + "\"},"); 
    	}	
		if(colOff[col] > 0) 
			data.append("{ Title: \"" + TableModel.getColumnName(col) + "\"}"); 
		else
			data.append("{ Title: \" \"}"); 
		data.append("]"); 
		return data.toString();
	}

	public String get_Table_Head() {
		StringBuffer html = new StringBuffer();
		html.append("<table class='table table-bordered nowrap table-hover ' id='" + htmlTable_ID + "'>");
		html.append(" <thead >");
		html.append(" <tr>");  
		int col=0;
    	for( col=0; col<colCount; col++){
			if(colOff[col] > 0) 
				html.append("<th data-field=" + TableModel.getColumnName(col) + ">" + TableModel.getColumnName(col) + "</th>"); 
    	}	
		html.append("</tr>"); 	
		html.append("</thead>"); 
		html.append("</table>"); 
		return html.toString();
	}
}
