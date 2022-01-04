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
	

	String  GV_CALLER="",GV_ORDER_NO="",GV_LOTNO="",
			GV_BOM_CD="", GV_BOM_CD_REV="";

	if(request.getParameter("OrderNo")== null)
		GV_ORDER_NO="";
	else
		GV_ORDER_NO = request.getParameter("OrderNo");
	
	if(request.getParameter("lotno")== null)
		GV_LOTNO="";
	else
		GV_LOTNO = request.getParameter("lotno");
	
	if(request.getParameter("bom_cd")== null)
		GV_BOM_CD = "";
	else
		GV_BOM_CD = request.getParameter("bom_cd");
	
	if(request.getParameter("bom_cd_rev")== null)
		GV_BOM_CD_REV = "";
	else
		GV_BOM_CD_REV = request.getParameter("bom_cd_rev");
	
	if(request.getParameter("caller")== null)
		GV_CALLER="";
	else
		GV_CALLER = request.getParameter("caller");
	
	JSONObject jArray = new JSONObject();
	jArray.put( "order_no", GV_ORDER_NO);
	jArray.put( "lotno", GV_LOTNO);
	jArray.put( "bom_cd", GV_BOM_CD);
	jArray.put( "bom_cd_rev", GV_BOM_CD_REV);
	jArray.put( "member_key", member_key);
		
    TableModel = new DoyosaeTableModel("M353S040100E114",jArray);	
 	int RowCount =TableModel.getRowCount();	

 	CurrentPage jspPageName = new CurrentPage(request.getRequestURI());
 	String JSPpage = jspPageName.GetJSP_FileName();
        
	makeGridData= new MakeGridData(TableModel);
	
	String RightButton[][]	= {{"off", "fn_Chart_View", rightbtnChartShow},{"off", "fn_Doc_Reg()", rightbtnDocSave},{"off", "file_real_name", rightbtnDocShow}};
 	makeGridData.RightButton	= RightButton;
 	 
    if(GV_CALLER.equals("S353S040102")) makeGridData.htmlTable_ID= "tableS353020102";
    else makeGridData.htmlTable_ID	= "tableS353S040110";
    
 	makeGridData.Check_Box 	= "false";
 	String[] HyperLink		= {""}; //strColumnHead의 수만큼
 	makeGridData.HyperLink 	= HyperLink;
    
%>
<script>
    $(document).ready(function () {
    	
    	var htmlTable_ID = <%=makeGridData.htmlTable_ID%>;
		var vColumnDefs = [
   	  			{
					'targets': [0,1,2,3,4,5],
		   			'createdCell':  function (td) {
		      			$(td).attr('style', 'display: none;'); 
		   			}
				},
				{
		   			'targets': [0,1,2,3,4,5],
		   			'createdCell':  function (td) {
	//	   				$(td).attr('style', 'display: none;'); //버튼 자리아래의 테이블 버튼자리와 같이 항상 처리한다.
						}
		   		}
			];
		
		henesysSubTableOptions.data =<%=makeGridData.getDataArry()%>;
		henesysSubTableOptions.columnDefs = vColumnDefs;
		
    	$('#<%=makeGridData.htmlTable_ID%>').DataTable(henesysSubTableOptions);
    	
    	
    	vSeqNo="";
    	fn_Clear_varv();
    });
    
    
	<%if(GV_CALLER.equals("S353S040102")) {%>
			function clickSubMenu(obj){
		      	var tr = $(obj);
		  		var td = tr.children();
		  		var trNum = $(obj).closest('tr').prevAll().length;//현재 클릭한 TR의 순서 return
		  		current_tr = tr;
		  		
		  		$($("input[id='checkbox1']")[trNum]).prop("checked", function(){
			        return !$(this).prop('checked');
			    });
		  		
		  		$(SubMenu_rowID).attr("class", "");
		  		$(obj).attr("class", "hene-bg-color");
		  		
				$("#txt_part_cd").val(td.eq(0).text().trim());
				$("#txt_bom_name").val(td.eq(1).text().trim());
				$("#txt_part_cnt").val(td.eq(2).text().trim());
				$("#txt_bigo").val(td.eq(3).text().trim());
				$("#txt_bom_cd").val(td.eq(4).text().trim());
				$("#txt_unit").val(td.eq(5).text().trim());	  
		  }
	<%} else {%>
			function clickSubMenu(obj){
		      	var tr = $(obj);
		  		var td = tr.children();
		  		var trNum = $(obj).closest('tr').prevAll().length;//현재 클릭한 TR의 순서 return
		  		
		  		$($("input[id='checkbox1']")[trNum]).prop("checked", function(){
			        return !$(this).prop('checked');
			    });
		  		
		  		$(SubMenu_rowID).attr("class", "");
		  		$(obj).attr("class", "hene-bg-color");
		  		
		/*   		vSeolbiCd = td.eq(0).text().trim(); 
				vSeqNo    = td.eq(9).text().trim(); */ 
			     
		  }
	
	<%}%>
	
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
			 <th>원부재자코드</th>
		     <th>배합(BOM)명</th>
		     <th>비율</th>
		     <th>비고</th>
		     <th>BOM코드</th>
		     <th>실중량</th>
		</tr>
		</thead>
		<tbody id="<%=makeGridData.htmlTable_ID%>_body">		
		</tbody>
</table>
<div id="UserList_pager" class="text-center">
</div>              