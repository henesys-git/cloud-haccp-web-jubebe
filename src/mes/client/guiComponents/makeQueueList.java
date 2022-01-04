package mes.client.guiComponents;

public class makeQueueList {
	public String HeadMenu="";
	public String sideMenu="";
	public DoyosaeTableModel TableModel;
	StringBuffer html = new StringBuffer();
	public int rowCount=0;
    int RowNum=0;
	String[] strColumnHead 	= {"주문번호", "고객사", "제품명", "상세번호","주문상태", "이전단계", "현단계","현업무", "이전업무"};

	public makeQueueList (String jspPage) {
		String param =  jspPage + "|";
		TableModel = new DoyosaeTableModel("M000S100000E904", strColumnHead, param);	
		rowCount = TableModel.getRowCount();
	}
	
	public String GetQueueList() {
		return makeQueue();
	}
//	
	private String makeQueue() {
		
		StringBuffer html = new StringBuffer();

		try{
			html.append("<div id='HENE_TABLE'>");
			html.append("<div id='HENE_QUEUE_ROW' style='overflow:auto;' >");
			html.append("<table class='table ' id='tablequeue' style='width:1024px'>");

			html.append(" <thead>");
			html.append("  <tr class='panel-title' >");//1Row 형성
			html.append("  <th style='width:80px; font-size:13px; font-weight: bold;' >");
			html.append("<span class='overlayed-text'>주문번호</span>");		
			html.append("  </th>");
			html.append("  <th style='font-size:13px; font-weight: bold;' >");
			html.append("<span class='overlayed-text'>고객사</span>");		
			html.append("  </th>");
			html.append("  <th style='font-size:13px; font-weight: bold;' >");
			html.append("제품명");		
			html.append("  </th>");			
			html.append("  </tr>");//1Row 형성 완료
			html.append(" </thead>");
			for(int row = 0; row < rowCount; row++) { 
				html.append("  <tr id='QueueOrder' class='bg-warning' onclick='selectQueueEvent(this)'>");//1Row 형성
				html.append("  <td style='vertical-align: middle; font-size:13px; font-weight: bold;' >");
				html.append(TableModel.getValueAt(row,0).toString().trim());		
				html.append("  </td>");
				html.append("  <td style='width:auto;vertical-align: middle; font-size:13px; font-weight: bold;' >");
				html.append(TableModel.getValueAt(row,1).toString().trim());		
				html.append("  </td>");
				html.append("  <td style='width:auto;vertical-align: middle; font-size:13px; font-weight: bold;' >");
				html.append(TableModel.getValueAt(row,2).toString().trim());		
				html.append("  </td>");			
				html.append("  </tr>");//1Row 형성 완료
				
			} 
			html.append(" </table>");
			html.append(" </div>");
			html.append(" </div>");
		}
		catch (Exception e) {
			e.printStackTrace();
		}
		return html.toString();
	}
	
}
//
//html.append("<div class='container' id='HENE_TABLE'>");
//html.append("<div class='container' id='HENE_QUEUE_ROW' style='overflow:auto;' >");
//html.append("	<div class='row' style='clear:both'>");//1Row 형성
//html.append("  		<div class='col-1 bg-success' style='float: left;'>");
//html.append("			<span class='overlayed-text'>주문번호</span>");		
//html.append("  		</div>");
//html.append("  		<div class='bg-success' style='float: left;'>");
//html.append("			<label style='width: 1px;'></label>");		
//html.append("  		</div>");
//html.append("  		<div class='col-1 bg-success' style='float: left;'>");
//html.append("			<span class='overlayed-text'>현단계</span>");		
//html.append("  		</div>");
//html.append("	</div>");//1Row 형성 완료
//for(int row = 0; row < rowCount; row++) { 
//	html.append("	<div id='QueueOrder' class='row' onclick='selectQueueEvent(this)' style='clear:both'>");//1Row 형성
//	html.append("  		<div id='QueueTD1' class='col-1 bg-warning'  style='float: left;'>");
//	html.append(TableModel.getValueAt(row,0).toString().trim());		
//	html.append("  		</div>");
//	html.append("  		<div id='QueueTD2' class='bg-warning' style='float: left;'>");
//	html.append("			<label style='width: 1px;'></label>");		
//	html.append("  		</div>");
//	html.append("  		<div id='QueueTD3' class='col-1 bg-warning' style='float: left;'>");
//	html.append(TableModel.getValueAt(row,4).toString().trim());			
//	html.append("  		</div>");
//	html.append("	</div>");//1Row 형성 완료
//	
//} 
//html.append(" </div>");
//html.append(" </div>");