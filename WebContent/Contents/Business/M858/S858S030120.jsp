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
	
	String GV_ORDERNO="", GV_LOTNO="" ;
	
	if(request.getParameter("order_no")== null)
		GV_ORDERNO="";
	else
		GV_ORDERNO = request.getParameter("order_no");

	if(request.getParameter("lotno")== null)
		GV_LOTNO="";
	else
		GV_LOTNO = request.getParameter("lotno");
	
	
	JSONObject jArray = new JSONObject();
	jArray.put( "order_no", GV_ORDERNO);
	jArray.put( "lotno", GV_LOTNO);
	jArray.put( "member_key", member_key);
	
    TableModel = new DoyosaeTableModel("M858S030100E124", jArray);	
 	int RowCount =TableModel.getRowCount();
 	
 	CurrentPage jspPageName = new CurrentPage(request.getRequestURI());
	String JSPpage = jspPageName.GetJSP_FileName();
    
	makeGridData= new MakeGridData(TableModel);
    
    String RightButton[][]	= {{"off", "fn_Chart_View", rightbtnChartShow},{"off", "fn_Doc_Reg()", rightbtnDocSave},{"off", "file_real_name", rightbtnDocShow}};
    
    makeGridData.RightButton	= RightButton;
	makeGridData.htmlTable_ID	= "tableS858S030120";
	makeGridData.Check_Box 	= "true";
	String[] HyperLink		= {""}; //strColumnHead의 수만큼
	makeGridData.HyperLink 	= HyperLink;
%>
    
<script>
	$(document).ready(function () {
		vTableS858S030120 = $('#<%=makeGridData.htmlTable_ID%>').DataTable({
			scrollX: true,
    		scrollY: 220,
    	    scrollCollapse: true,
    	    paging: false,
    	    searching: false,
    	    ordering: true,
    	    order: [[ 2, "asc" ]],
    	    info: true,
    	    data: <%=makeGridData.getDataArry()%>,
    	    'createdRow': function(row) {	
   	      		$(row).attr('id',"<%=makeGridData.htmlTable_ID%>_rowID");
<%--    	      		$(row).attr('onclick',"<%=makeGridData.htmlTable_ID%>Event(this)"); --%>
   	      		$(row).attr('role',"row");
   	  		},   
   	  		'columnDefs': [
        		{
    	       		'targets': [1,6],
    	       		'createdCell':  function (td) {
    	          			$(td).attr('style', 'width:0px; display: none;'); 
//     	          			$(td).parent().attr('id', 'TableS858S020130_rowID'); 
    	       		}
           		},
           		{
    	       		'targets': [10],
    	       		'createdCell':  function (td) {
   	          			$(td).attr('style', 'display: none;'); //버튼 자리아래의 테이블 버튼자리와 같이 항상 처리한다.
    	       		}
    			}
           	],
           	'drawCallback': function() { // 콜백함수
           		$("#<%=makeGridData.htmlTable_ID%> input[id='checkbox1']").on("click",function(){
        			if($(this).prop('checked'))
        				$(this).prop("checked", false);
        			else
        				$(this).prop("checked", true);
            	});
           	},
            language: { 
                url:"<%=Config.this_SERVER_path%>/AdminLTE-3.0.5/localisation/Korean.json"
             }
		});
		
		TableS858S030120_RowCount = vTableS858S030120.rows().count();
		
		for(var i=0; i<TableS858S030120_RowCount; i++) { // 오른쪽테이블에 있는 왼쪽테이블 레코드제거
			var baecha_seq_120 = vTableS858S030120.cell( i, 2).data().trim();
			for(var j=0; j<TableS858S030130_RowCount; j++) {
				var baecha_seq_130 = vTableS858S030130.cell( j, 2).data().trim();
// 				alert("TableS858S030120_RowCount="+TableS858S030120_RowCount+"\n"+"part_cd_120="+part_cd_120+"\n"+"part_cd_130="+part_cd_130);
				if(baecha_seq_120==baecha_seq_130) {
// 					alert("part="+part_cd_120+"\n"+"레코드제거");
					vTableS858S030120.row(i).remove();
					TableS858S030120_RowCount = vTableS858S030120.page.info().recordsTotal; //행제거하면 rowcount 다시계산
					i--; //행제거하면 index-1
				}
			}
 		}
		
    	$('#<%=makeGridData.htmlTable_ID%> tbody').on( 'click', 'tr', function () {
    		S858S030120_Row_index = vTableS858S030120.row( this ).index();
	 		$(<%=makeGridData.htmlTable_ID%>_rowID).removeClass("hene-bg-color");
	 		vTableS858S030120.row(this).nodes().to$().attr("class","hene-bg-color");
	 		
// 	 		clear_input();

			vTableS858S030120.cell(S858S030120_Row_index,0).nodes().to$().find("input[id='checkbox1']").prop("checked", function(){
				if($(this).prop('checked'))
					$(this).prop("checked", false);
				else
					$(this).prop("checked", true);
		    });

// 			$('#txt_transport_no').val('');
			$('#txt_baecha_no').val(vTableS858S030120.cell(S858S030120_Row_index, 1).data());
			$('#txt_baecha_seq').val(vTableS858S030120.cell(S858S030120_Row_index, 2).data());
	 		$('#txt_transport_start_dt').val(vTableS858S030120.cell(S858S030120_Row_index, 3).data());
			$('#txt_transport_end_dt').val(vTableS858S030120.cell(S858S030120_Row_index, 4).data());
			$('#txt_vehicle_cd').val(vTableS858S030120.cell(S858S030120_Row_index, 5).data());
			$('#txt_vehicle_cd_rev').val(vTableS858S030120.cell(S858S030120_Row_index, 6).data());
			$('#txt_vehicle_nm').val(vTableS858S030120.cell(S858S030120_Row_index, 7).data());
			$('#txt_driver').val(vTableS858S030120.cell(S858S030120_Row_index, 8).data());
			$('#txt_bigo').val(vTableS858S030120.cell(S858S030120_Row_index, 9).data());
			
			$('#btn_plus').html("입력");
			S858S030130_Row_index = -1;
			vTableS858S030130.rows().nodes().to$().attr("class", "hene-bg-color_w");
		} );
		        
		$('#<%=makeGridData.htmlTable_ID%> tbody').on( 'blur', 'tr', function () {
			vTableS858S030120.row(this).nodes().to$().attr("class", "hene-bg-color_w");
		} );
		
		$("#<%=makeGridData.htmlTable_ID%>"+" "+"input[id='checkboxAll']").on("click", function(){
			var table_info = vTableS858S030120.page.info();
	        var table_rows = table_info.recordsTotal;
	    	for(var i=0;i<table_rows;i++){  
	    		vTableS858S030120.cell(i,0).nodes().to$().find("input[id='checkbox1']").prop("checked",this.checked);
	    	}
	    });  
	});

</script>

<table class='table table-bordered nowrap table-hover' id="<%=makeGridData.htmlTable_ID%>" style="width: 100%">
		<thead>
		<tr>
			 <th><input type='checkbox'  id='checkboxAll'/></th>
			 <th style='width:0px; display: none;'>배차번호</th>
		     <th>배차순서</th>
		     <th>배차시작일시</th>
		     <th>배차종료일시</th>
		     <th>차량번호</th>
		     <th style='width:0px; display: none;'>차량번호rev</th>
		     <th>차량명칭</th>
		     <th>배송기사</th>
		     <th>비고</th>
		     <!-- 버튼자리 -->
		     <th style='width:0px; display: none;'></th>
		</tr>
		</thead>
		<tbody id="<%=makeGridData.htmlTable_ID%>_body">		
		</tbody>
</table>
<div id="UserList_pager" class="text-center">
</div>      

