package mes.client.guiComponents;

import java.util.ArrayList;
import java.util.List;
import java.util.Vector;
import java.util.ResourceBundle;

/**
 * @author jlnho
 *
 */
public class MakeGridData { 
	public int pageSize;
	public int currentPageNum;
	public String htmlTable_ID = "";
	public String Table_Class = "";
	public String TR_Style[];
	public String TD_Style[];
	public String HyperLink[];
	public String Check_Box = "false";
	public int colOff[];
	public String Radtio_Buttob[] = {"false"};
	public int TotalPageNumber;
	public String RightButton[][];
	public String MAX_HEIGHT = "";
	public String jsp_page = "";
	public String user_id = "";
	public String orderno = "";

	DoyosaeTableModel TableModel;
	Vector fieldNameVector;
	List pivotList;
	int rowCount = 0;
	int colCount = 0;
	int RightButton_On_cnt = 0;
	
	ResourceBundle resource = ResourceBundle.getBundle("strings");
	
	private String rightbtnChartShow = resource.getString("rightbtn.chart.show");
	private String rightbtnDocShow = resource.getString("rightbtn.doc.show");
	private String rightbtnDocRevise = resource.getString("rightbtn.doc.revise");
	private String rightbtnDelele = resource.getString("rightbtn.delete");
	
	private String workPlanGubun = resource.getString("workplan.gubun");
	private String workPlanWorkPlan = resource.getString("workplan.workplan");
	private String workPlanAdditionalWork = resource.getString("workplan.additionalWork");
	private String workPlanEtc = resource.getString("workplan.etc");
	private String workPlanDayoff = resource.getString("workplan.dayoff");
	
	public MakeGridData(Object Model) {
		if(Model instanceof EdmsDoyosaeTableModel) {
			this.TableModel = (EdmsDoyosaeTableModel) Model;
			fieldNameVector = (Vector) TableModel.getVector().get(0);
			TableModel.delete(0);
		} else {
			this.TableModel = (DoyosaeTableModel) Model;
		}
		
		rowCount = TableModel.getRowCount();	
		
		if(rowCount > 0) {
			colCount = TableModel.getColumnCount();
		}
	}
	
	public String getDataArry() {
		int btn=0;
		StringBuffer html = new StringBuffer();
		try{		

			html.append("[");
  	
			if(rowCount>0) {
				for(int row = 0; row < rowCount; row++) { 

					html.append("[");
					if(Check_Box.equals("true")) {
						html.append("\"<input type='checkbox' id='checkbox1'/>\",");
					}
	
	    			StringBuffer html_btn = new StringBuffer();

		    		html_btn.append("\"");
			    	for(btn=0; btn<RightButton.length; btn++) {
				    	if(RightButton[btn][0].equals("on")) {
				    		if(fieldNameVector != null) { // if need to compare file names
				    			if(RightButton[btn][2].equals(rightbtnChartShow)) {
				    				html_btn.append("<button style='width: auto; float: left; margin-right:1px; ' type='button'" );
						    		html_btn.append(" onclick=' fn_Chart_View()' ");
						    		html_btn.append(" id='right_btn_chart' class='btn btn-outline-success' >" + RightButton[btn][2] + "</button> ");
				    			} else if(RightButton[btn][2].equals(rightbtnDocShow)) {
				    				for(int col=0; col<colCount; col++){
						    			if(fieldNameVector.get(col).toString().equals(RightButton[btn][1])) {
							    			html_btn.append("<button style='width: auto; float: left; margin-right:1px; ' type='button'" );
						    				html_btn.append(" onclick=\\\" fn_right_btn_view('" + TableModel.getValueAt(row,col).toString().trim() + "',this,'view')\\\" ");
								    		html_btn.append(" id='right_btn_view' class='btn btn-outline-warning' >" + RightButton[btn][2] + "</button> ");
							    		}
						    		}
				    			} else if(RightButton[btn][2].equals(rightbtnDocRevise)) {
				    				for(int col=0; col<colCount; col++){
						    			if(fieldNameVector.get(col).toString().equals(RightButton[btn][1])) {
							    			html_btn.append("<button style='width: auto; float: left; margin-right:1px; ' type='button'" );
						    				html_btn.append(" onclick=\\\" fn_right_btn_view('" + TableModel.getValueAt(row,col).toString().trim() + "',this,'revision')\\\" ");
								    		html_btn.append(" id='right_btn_reg' class='btn btn-outline-success' >" + RightButton[btn][2] + "</button> ");
							    		}
						    		}
				    			} else {
				    				html_btn.append("<button style='width: auto; float: left; margin-right:1px; ' type='button'" );
					    			html_btn.append(" onclick='" + RightButton[btn][1] + "' ");
						    		html_btn.append(" id='right_btn' class='btn btn-outline-success' >" + RightButton[btn][2] + "</button>");
				    			}
							} else {// if no need to compare file names
					    		html_btn.append("<button style='width: auto; float: left; margin-right:1px;' type='button'");
				    			if(RightButton[btn][2].equals(rightbtnDelele)) {
					    			int leftBr = RightButton[btn][1].indexOf("(", 0);
					    			if(leftBr > 0) {
						    			int rightBr = RightButton[btn][1].indexOf(")", 0);
						    			String pArm = RightButton[btn][1].substring(leftBr, rightBr).trim();

						    			if(pArm.length() > 1) {
						    				html_btn.append(" onclick='" + RightButton[btn][1]  + "' ");
						    			} 			else {
						    				html_btn.append(" onclick='" + RightButton[btn][1].substring(leftBr, rightBr).trim() + "(" + row + ")' ");
						    			}
					    			} else {
					    				html_btn.append(" onclick='" + RightButton[btn][1] + "(" + row + ")' ");
					    			}
				    			} else {
					    			html_btn.append(" onclick='" + RightButton[btn][1] + "' ");
				    			}
					    		html_btn.append(" id='right_btn' class='btn btn-outline-success' >" + RightButton[btn][2] + "</button>");
				    		}
				    	}
			    	} 
		    		html_btn.append("\"");
			    	
			    	for(int col=0; col<colCount; col++) {
		    			html.append("\"");
		    			String ColData = TableModel
		    					.getValueAt(row,col)
		    					.toString()
		    					.replace("\\", "\\\\")
		    					.replace("\n", "<br>")
		    					.replace("\r\n", "<br>")
		    					.replace("\'", "&#39;")
		    					.replace("\"", "&quot;");
		    			if(getHyperLink(col).length() > 1) {
			    			html.append("     <a href='#' onclick='" + getHyperLink(col) + "'>");
			    			html.append( ColData);
			    			html.append("     </a>");
		    			} else {
			    			html.append(ColData);
		    			}
			    		html.append("\",");
					}
			    	
			    	html.append(html_btn.toString());
			    	if(row < rowCount-1) {
			    		html.append("],");
			    	} else {
			    		html.append("]");
			    	}
				} 
			}
			html.append("]");
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		return html.toString();
	}
	
	public String getDataArray() {

		StringBuffer html = new StringBuffer();
		
		try {		
			html.append("[");
  	
			if(rowCount > 0) {
				for(int row = 0; row < rowCount; row++) { 

					html.append("[");
				    	
			    	for(int col=0; col<colCount; col++){
		    			html.append("\"");
		    			String ColData = TableModel
		    					.getValueAt(row,col)
		    					.toString()
		    					.replace("\\", "\\\\")
		    					.replace("\n", "<br>")
		    					.replace("\r\n", "<br>")
		    					.replace("\'", "&#39;")
		    					.replace("\"", "&quot;");
			    		html.append(ColData);
			    		
			    		if(col == colCount -1) {
			    			html.append("\"");
			    		} else {
			    			html.append("\",");			    			
			    		}
					}
			    	
			    	if(row < rowCount - 1) {
			    		html.append("],");
			    	} else {
			    		html.append("]");
			    	}
				} 
			}
			html.append("]");
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		return html.toString();
	}

	private String getHyperLink(int col) {
		String retStr = "";
		try {
			retStr = HyperLink[col].toString();
		}
		catch(Exception e) {
			retStr = "";
		}
		return retStr;
	}
	
	public void setFirstColumn() {
		Vector<String> firstCol = new Vector<>(5);
		firstCol.addElement(workPlanGubun);
		firstCol.addElement(workPlanWorkPlan);
		firstCol.addElement(workPlanAdditionalWork);
		firstCol.addElement(workPlanEtc);
		firstCol.addElement(workPlanDayoff);
		
		TableModel.insert(firstCol, 0);
		rowCount += 1;
	}
	
	public void deleteFirstRow() {
		for(int i = 0; i < rowCount; i++) {
			Vector v = (Vector) TableModel.getVector().get(i);
			v.remove(0);
		}
		
		colCount = colCount - 1;
	}
	
	// for yumsam, pivot data from database
	public List<List<String>> pivotData() {
		setFirstColumn();
		deleteFirstRow();
		
		List<List<String>> listOfLists = new ArrayList<List<String>>(colCount);
		
		// instantiate all columns of 2d array
		for(int i = 0; i < colCount; i++)  {
	        listOfLists.add(new ArrayList<String>());
	    }
		
		// pivot data
		for(int col = 0; col < colCount; col++) {
			for(int row = 0; row < rowCount; row++) {
				String val = (TableModel.getValueAt(row, col).toString());
				listOfLists.get(col).add(val);
			}
		}

		return listOfLists;
	}
	
	/* 
	 * yumsam (work plan related function)
	 * param : 2 dimentional array list
	 */
	public String makeElementsString(List<List<String>> list) {
		int rowCount = list.size();
		int colCount = 7; // monday to saturday and row title -> 7
		
		StringBuffer html = new StringBuffer();
		try {
			html.append("[");
			
			if(rowCount > 0) {
				for(int row = 0; row < rowCount; row++) {
					html.append("[");
			    	
			    	for(int col = 0; col < colCount; col++) {
		    			html.append("\"");
		    			
		    			String colData;
		    			
		    			try {
		    				colData = list.get(row).get(col)
					    				.replace("\\", "\\\\")
			 					   	    .replace("\'", "&#39;")
			 					        .replace("\"", "&quot;")
			 					        .replace(",", "<br>")
			 					        .replace("[", "")
			 					        .replace("]", "");
		    			} catch(IndexOutOfBoundsException e) {
		    				colData = "";
		    			}			    		
		    			
		    			html.append(colData);
		    			
		    			if(col < colCount -1) {
		    				html.append("\",");
		    			} else {
		    				html.append("\"");
		    			}
					}

			    	if(row < rowCount - 1) {
			    		html.append("],");
			    	} else {
			    		html.append("]");
			    	}
				} 
			}
			html.append("]");
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		return html.toString();
	}
}