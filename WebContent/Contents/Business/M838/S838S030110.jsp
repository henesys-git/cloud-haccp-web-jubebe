<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="mes.client.comm.*" %>
<%@ page import="mes.client.guiComponents.*" %>
<%@ page import="mes.client.util.*" %>
<%@ page import="mes.client.conf.*" %>
<%@ page import="org.json.simple.*"%><%@ include file="/strings.jsp" %>
<%
	DoyosaeTableModel TableModel;
	MakeGridData makeGridData;

	String loginID = session.getAttribute("login_id").toString();
	String member_key = session.getAttribute("member_key").toString();
	
	
	int startPageNo =1; //Integer.parseInt(request.getParameter("CurrentPageNumber").toString().trim());
// 	final int PageSize=15; 
	

	String GV_SEOLBI_CD="";

	if(request.getParameter("SeolbiCd")== null)
		GV_SEOLBI_CD="";
	else
		GV_SEOLBI_CD = request.getParameter("SeolbiCd");
	
	String param = ""  + GV_SEOLBI_CD + "|";
	
	JSONObject jArray = new JSONObject();
	jArray.put( "seolbi_cd", GV_SEOLBI_CD);
	jArray.put( "member_key", member_key);
		
    TableModel = new DoyosaeTableModel("M838S030100E114",jArray);	
 	int RowCount =TableModel.getRowCount();	

 	CurrentPage jspPageName = new CurrentPage(request.getRequestURI());
 	String JSPpage = jspPageName.GetJSP_FileName();
 	
        
	makeGridData= new MakeGridData(TableModel);
	
	String RightButton[][]	= {{"off", "fn_Chart_View", rightbtnChartShow},{"off", "fn_Doc_Reg()", rightbtnDocSave},{"off", "file_real_name", rightbtnDocShow}};
 	makeGridData.RightButton	= RightButton;
 	 
    makeGridData.htmlTable_ID	= "tableS838S030110";
    
 	makeGridData.Check_Box 	= "false";
 	String[] HyperLink		= {""}; //strColumnHead의 수만큼
 	makeGridData.HyperLink 	= HyperLink;
    
%>
<script>
    $(document).ready(function () {
    	
		var htmlTable_ID = <%=makeGridData.htmlTable_ID%>;
		
		var customOpts = {
				data : <%=makeGridData.getDataArray()%>,
				columnDefs : [{
					'targets': [9],
					'createdCell': function (td) {
			  			$(td).attr('style', 'display: none;'); 
					}
				}]
		}
		
		$('#<%=makeGridData.htmlTable_ID%>').DataTable(
			mergeOptions(heneSubTableOpts, customOpts)
		);
    	
    	
    	vSeqNo="";
    	fn_Clear_varv();
    });
    
    
	
	function <%=makeGridData.htmlTable_ID%>Event(obj){
      	var tr = $(obj);
  		var td = tr.children();
  		var trNum = $(obj).closest('tr').prevAll().length;//현재 클릭한 TR의 순서 return
  		
  		$($("input[id='checkbox1']")[trNum]).prop("checked", function(){
	        return !$(this).prop('checked');
	    });
  		
  		$(<%=makeGridData.htmlTable_ID%>_rowID).attr("class", "");
  		$(obj).attr("class", "hene-bg-color");
  		
  		vSeolbiCd = td.eq(0).text().trim(); 
		vSeqNo    = td.eq(9).text().trim(); 
	     
  }
	
    function fn_Clear_varv(){
		vBalju_req_date	= "";
		vBalju_no 		= "";
		vImport_inspect_seq 			= "";
		vPart_cd 			= "";
//			vGIJONG_CODE 		= "";
		$('#txt_custcode').val("");
    }
    
</script>


<table class='table table-bordered nowrap table-hover' id="<%=makeGridData.htmlTable_ID%>" style="width: 100%">
		<thead>
		<tr>
			 <th>생산설비코드</th>
		     <th>업무구분</th>
		     <th>기관명</th>
		     <th>수리내용</th>
		     <th>반출일</th>
		     <th>완료일</th>
		     <th>담당자</th>
		     <th>비용</th>
		     <th>비고</th>
		     <th style='width:0px; display: none;'>SEQ_NO</th>
		</tr>
		</thead>
		<tbody id="<%=makeGridData.htmlTable_ID%>_body">		
		</tbody>
</table>
<div id="UserList_pager" class="text-center">
</div>              