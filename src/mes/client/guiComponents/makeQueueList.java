package mes.client.guiComponents;

public class makeQueueList {
	public String HeadMenu="";
	public String sideMenu="";
	public DoyosaeTableModel TableModel;
	StringBuffer html = new StringBuffer();
	public int rowCount=0;
    int RowNum=0;
	String[] strColumnHead 	= {"�ֹ���ȣ", "����", "��ǰ��", "�󼼹�ȣ","�ֹ�����", "�����ܰ�", "���ܰ�","������", "��������"};

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
			html.append("  <tr class='panel-title' >");//1Row ����
			html.append("  <th style='width:80px; font-size:13px; font-weight: bold;' >");
			html.append("<span class='overlayed-text'>�ֹ���ȣ</span>");		
			html.append("  </th>");
			html.append("  <th style='font-size:13px; font-weight: bold;' >");
			html.append("<span class='overlayed-text'>����</span>");		
			html.append("  </th>");
			html.append("  <th style='font-size:13px; font-weight: bold;' >");
			html.append("��ǰ��");		
			html.append("  </th>");			
			html.append("  </tr>");//1Row ���� �Ϸ�
			html.append(" </thead>");
			for(int row = 0; row < rowCount; row++) { 
				html.append("  <tr id='QueueOrder' class='bg-warning' onclick='selectQueueEvent(this)'>");//1Row ����
				html.append("  <td style='vertical-align: middle; font-size:13px; font-weight: bold;' >");
				html.append(TableModel.getValueAt(row,0).toString().trim());		
				html.append("  </td>");
				html.append("  <td style='width:auto;vertical-align: middle; font-size:13px; font-weight: bold;' >");
				html.append(TableModel.getValueAt(row,1).toString().trim());		
				html.append("  </td>");
				html.append("  <td style='width:auto;vertical-align: middle; font-size:13px; font-weight: bold;' >");
				html.append(TableModel.getValueAt(row,2).toString().trim());		
				html.append("  </td>");			
				html.append("  </tr>");//1Row ���� �Ϸ�
				
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
//html.append("	<div class='row' style='clear:both'>");//1Row ����
//html.append("  		<div class='col-1 bg-success' style='float: left;'>");
//html.append("			<span class='overlayed-text'>�ֹ���ȣ</span>");		
//html.append("  		</div>");
//html.append("  		<div class='bg-success' style='float: left;'>");
//html.append("			<label style='width: 1px;'></label>");		
//html.append("  		</div>");
//html.append("  		<div class='col-1 bg-success' style='float: left;'>");
//html.append("			<span class='overlayed-text'>���ܰ�</span>");		
//html.append("  		</div>");
//html.append("	</div>");//1Row ���� �Ϸ�
//for(int row = 0; row < rowCount; row++) { 
//	html.append("	<div id='QueueOrder' class='row' onclick='selectQueueEvent(this)' style='clear:both'>");//1Row ����
//	html.append("  		<div id='QueueTD1' class='col-1 bg-warning'  style='float: left;'>");
//	html.append(TableModel.getValueAt(row,0).toString().trim());		
//	html.append("  		</div>");
//	html.append("  		<div id='QueueTD2' class='bg-warning' style='float: left;'>");
//	html.append("			<label style='width: 1px;'></label>");		
//	html.append("  		</div>");
//	html.append("  		<div id='QueueTD3' class='col-1 bg-warning' style='float: left;'>");
//	html.append(TableModel.getValueAt(row,4).toString().trim());			
//	html.append("  		</div>");
//	html.append("	</div>");//1Row ���� �Ϸ�
//	
//} 
//html.append(" </div>");
//html.append(" </div>");