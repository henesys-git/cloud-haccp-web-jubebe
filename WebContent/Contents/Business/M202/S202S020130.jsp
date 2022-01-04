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

	String RightButton[][]	= {{"off", "fn_Chart_View", rightbtnChartShow},{"off", "fn_Doc_Reg()", rightbtnDocSave},{"off", "fn_mius_body(this)", "삭제"}};
	
	String GV_ORDER_NO="",GV_BALJU_NO="";
	
	if(request.getParameter("OrderNo")== null)
		GV_ORDER_NO="";
	else
		GV_ORDER_NO = request.getParameter("OrderNo");
	
	if(request.getParameter("BaljuNo")== null)
		GV_BALJU_NO="";
	else
		GV_BALJU_NO = request.getParameter("BaljuNo");	
	
	String param = GV_ORDER_NO + "|" + GV_BALJU_NO + "|" + member_key + "|";
	
	JSONObject jArray = new JSONObject();
	jArray.put( "order_no", GV_ORDER_NO);
	jArray.put( "baljuno", GV_BALJU_NO);
	jArray.put( "member_key", member_key);	
	
//     TableModel = new DoyosaeTableModel("M202S020100E134", strColumnHead, param);	
	TableModel = new DoyosaeTableModel("M202S020100E134", jArray);	
 	int RowCount =TableModel.getRowCount();	

 	CurrentPage jspPageName = new CurrentPage(request.getRequestURI());
 	String JSPpage = jspPageName.GetJSP_FileName();
 	
 	makeGridData= new MakeGridData(TableModel);
 	makeGridData.RightButton	= RightButton;
    makeGridData.htmlTable_ID	= "tableS202S010110";
    
 	makeGridData.Check_Box 	= "false";
 	String[] HyperLink		= {""}; //strColumnHead의 수만큼
 	makeGridData.HyperLink 	= HyperLink;

%>
<script>
    $(document).ready(function () {

		vTableS202S020130 = $('#<%=makeGridData.htmlTable_ID%>').DataTable({
			scrollX: true,
// 		    scrollY: 310,
		    scrollCollapse: true,
		    paging: true,
		    lengthMenu: [[5,9,-1], [5,9,"All"]],
		    searching: false,
		    ordering: true,
		    order: [[ 1, "asc" ]],
		    keys: false,
		    info: true,
		    data: <%=makeGridData.getDataArry()%>,
   	    	'createdRow': function(row) {	
   	      		$(row).attr('id',"<%=makeGridData.htmlTable_ID%>_rowID");
   	      		$(row).attr('onclick',"<%=makeGridData.htmlTable_ID%>Event(this)");
   	      		$(row).attr('role',"row");
   	  		}, 
    	    columnDefs: [{
    	    	'targets': [0,1,5,6,7,8,15],
	   			'createdCell':  function (td) {
	      			$(td).attr('style', 'display: none;'); 
	   			}
    	    },
		    'createdRow': function(row) {	
	      		$(row).attr('id',"<%=makeGridData.htmlTable_ID%>_rowID");
// 	      		$(row).attr('onclick',"S202S020130Event(this)");
	      		$(row).attr('role',"row");
	  		},
	  		'columnDefs': [{
	       		'targets': [16],
	       		'createdCell':  function (td) {
	          			$(td).attr('style', 'width:0px; display: none;'); 
	       		}
			}],
			language: { 
	               url:"<%=Config.this_SERVER_path%>/AdminLTE-3.0.5/localisation/Korean.json"
	            }
		});

	
		$('#<%=makeGridData.htmlTable_ID%> tbody').on( 'click', 'tr', function () {
			S202S020130_Row_index = vTableS202S020130
		        .row( this )
		        .index();
			
// 			$($("input[id='checkbox1']")[S202S020130_Row_index]).prop("checked", function(){
// 		        return !$(this).prop('checked');
// 		    });

	 		$(<%=makeGridData.htmlTable_ID%>_rowID).removeClass("hene-bg-color");
			vTableS202S020130.row(this)
		    .nodes()
		    .to$()
		    .attr("class","hene-bg-color");			
		} );
		        

		$('#<%=makeGridData.htmlTable_ID%> tbody').on( 'blur', 'tr', function () {
			vTableS202S020130.row(this)
		    .nodes()
		    .to$()
		    .attr("class", "hene-bg-color_w");
		} );


	    $('#txt_seq').val( '<%=(RowCount+1)%>');
    });

    function <%=makeGridData.htmlTable_ID%>Event(obj){
    	var tr = $(obj);
		var td = tr.children();
		var trNum = $(obj).closest('tr').prevAll().length;//현재 클릭한 TR의 순서 return	
		
 		$(<%=makeGridData.htmlTable_ID%>_rowID).attr("class", "");
		$(obj).attr("class", "hene-bg-color");

// 		$('#txt_seq').val(td.eq(0).text().trim());
		
		vBalju_no 		= td.eq(8).text().trim();


    }        
</script>
<table class='table table-bordered nowrap table-hover' id="<%=makeGridData.htmlTable_ID%>" style="width: 100%">
		<thead>
			<tr>
			<th style='width:0px; display: none;'>주문번호</th>
			<th style='width:0px; display: none;'></th>
			<th>요청일</th>
			<th>입고일</th>
			<th>인계일</th>
			<th style='width:0px; display: none;'>시험서유무</th>			
			<th style='width:0px; display: none;'>검사완료일</th>
			<th style='width:0px; display: none;'>검사내용</th>
			<th style='width:0px; display: none;'>발주번호</th>
			<th>순번</th>
			<th>자료명</th>
			<th>자료번호</th>
			<th>원부자재번호</th>
			<th>파트번호</th>
			<th>요청수량</th>
			<th style='width:0px; display: none;'>part_rev_no</th>
			<th style='width:0px; display: none;'></th>
			</tr>
		</thead>
		<tbody id="<%=makeGridData.htmlTable_ID%>_body">		
		</tbody>
</table>    
    <div id="UserList_pager" class="text-center">
	</div>       