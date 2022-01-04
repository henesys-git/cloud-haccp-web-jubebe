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

	String GV_ORDERNO="", GV_CALLER="", GV_LOTNO="" ;
	
	if(request.getParameter("order_no")== null)
		GV_ORDERNO = "";
	else
		GV_ORDERNO = request.getParameter("order_no");
	
	if(request.getParameter("lotno")== null)
		GV_LOTNO="";
	else
		GV_LOTNO = request.getParameter("lotno");
	
	if(request.getParameter("caller")== null)
		GV_CALLER="";
	else
		GV_CALLER = request.getParameter("caller");
	
	String RightButton[][]	= {{"off", "fn_Chart_View", rightbtnChartShow},{"off", "fn_Doc_Reg()", rightbtnDocSave},{"on", "fn_mius_body(this)", "삭제"}};
	
	if( GV_CALLER.equals("S858S030102") || GV_CALLER.equals("S858S030103") ) {
		RightButton[2][0] = "off"; // 수정&삭제시 행삭제버튼 off
	}

	JSONObject jArray = new JSONObject();
	jArray.put( "order_no", GV_ORDERNO);
	jArray.put( "lotno", GV_LOTNO);
	jArray.put( "member_key", member_key);

	TableModel = new DoyosaeTableModel("M858S030100E134", jArray);
 	int RowCount =TableModel.getRowCount();	
 	
 	CurrentPage jspPageName = new CurrentPage(request.getRequestURI());
	String JSPpage = jspPageName.GetJSP_FileName();
    
	makeGridData= new MakeGridData(TableModel);
    
	makeGridData.RightButton	= RightButton;
	makeGridData.htmlTable_ID	= "tableS858S030130";
	makeGridData.Check_Box 	= "false";
	String[] HyperLink		= {""}; //strColumnHead의 수만큼
	makeGridData.HyperLink 	= HyperLink;
%>

    
<script>
	$(document).ready(function () {
		var columnDefs;
    	if("<%=GV_CALLER%>"=="S858S030101") { 
    		columnDefs = [
        		{
    	       		'targets': [0,1,6],
    	       		'createdCell':  function (td) {
    	          			$(td).attr('style', 'width:0px; display: none;'); 
//     	          			$(td).parent().attr('id', 'TableS858S020130_rowID'); 
    	       		}
           		},
           		{
    	       		'targets': [12],
    	       		'createdCell':  function (td) {
    	          		$(td).html('<button style="width: auto; float: left; " type="button" onclick="fn_mius_body(this)" id="right_btn" class="btn-outline-success">삭제</button>');
//     	          		$(td).attr('style', 'display: none;'); //버튼 자리아래의 테이블 버튼자리와 같이 항상 처리한다.
    	       		}
    			}
           	];
    	} else {
    		columnDefs = [
        		{
    	       		'targets': [0,1,6],
    	       		'createdCell':  function (td) {
    	          			$(td).attr('style', 'width:0px; display: none;'); 
//     	          			$(td).parent().attr('id', 'TableS858S020130_rowID'); 
    	       		}
           		},
           		{
    	       		'targets': [12],
    	       		'createdCell':  function (td) {
   	          			$(td).attr('style', 'display: none;'); //버튼 자리아래의 테이블 버튼자리와 같이 항상 처리한다.
    	       		}
    			}
           	];
    	}
		
		vTableS858S030130 = $('#<%=makeGridData.htmlTable_ID%>').DataTable({	   
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
    	    'columnDefs': columnDefs,         
            language: { 
                url:"<%=Config.this_SERVER_path%>/AdminLTE-3.0.5/localisation/Korean.json"
             }
		});
		
		TableS858S030130_RowCount = vTableS858S030130.rows().count();
		
		if("<%=GV_CALLER%>"=="S858S030101") { 
			for(var i=0; i<TableS858S030130_RowCount; i++){  // DB에서 조회된 레코드 삭제버튼제거
// 				var trInput = $($("#TableS858S030130_tbody tr")[i]).find(":button");
// 				//trInput.eq(0).prop("disabled", true);
// 				trInput.eq(0).remove();
				var aa = vTableS858S030130.cell(i, 12).data();
				vTableS858S030130.cell(i, 12).data('');
	 		}
		}

		if("<%=GV_CALLER%>"=="S858S030102" || "<%=GV_CALLER%>"=="S858S030103") {
			if(TableS858S030130_RowCount<1) {
				alert("해당 주문의 배차정보가 없습니다."+"\n"+"배차등록 먼저 해주세요.");
				parent.$("#ReportNote").children().remove();
	     		parent.$('#modalReport').hide();
			}
		}
		
		$('#<%=makeGridData.htmlTable_ID%> tbody').on( 'click', 'tr', function () {
			S858S030130_Row_index = vTableS858S030130.row( this ).index();
	 		$(<%=makeGridData.htmlTable_ID%>_rowID).removeClass("hene-bg-color");
	 		vTableS858S030130.row(this).nodes().to$().attr("class","hene-bg-color");
	 		
<%-- 	 	if("<%=GV_CALLER%>"=="S858S030101") { --%>
// 	 			clear_input();
// 	 		}
	 		
			$('#txt_transport_no').val(vTableS858S030130.cell(S858S030130_Row_index, 0).data());
			$('#txt_baecha_no').val(vTableS858S030130.cell(S858S030130_Row_index, 1).data());
			$('#txt_baecha_seq').val(vTableS858S030130.cell(S858S030130_Row_index, 2).data());
			$('#txt_transport_start_dt').val(vTableS858S030130.cell(S858S030130_Row_index, 3).data());
			$('#txt_transport_end_dt').val(vTableS858S030130.cell(S858S030130_Row_index, 4).data());
			$('#txt_vehicle_cd').val(vTableS858S030130.cell(S858S030130_Row_index, 5).data());
			$('#txt_vehicle_cd_rev').val(vTableS858S030130.cell(S858S030130_Row_index, 6).data());
			$('#txt_vehicle_nm').val(vTableS858S030130.cell(S858S030130_Row_index, 7).data());
			$('#txt_driver').val(vTableS858S030130.cell(S858S030130_Row_index, 8).data());
			$('#txt_bigo').val(vTableS858S030130.cell(S858S030130_Row_index, 9).data());
			$('#transport_total').val(vTableS858S030130.cell(S858S030130_Row_index, 10).data());
			$('#transport_distance').val(vTableS858S030130.cell(S858S030130_Row_index, 11).data());
			
			if("<%=GV_CALLER%>"=="S858S030101") { 
				$('#btn_plus').html("수정");
				S858S030120_Row_index = -1;
				vTableS858S030120.rows().nodes().to$().attr("class", "hene-bg-color_w");
			}
		} );
		        
	});
	
</script>

<table class='table table-bordered nowrap table-hover' id="<%=makeGridData.htmlTable_ID%>" style="width: 100%">
		<thead>
		<tr>
			 <th style='width:0px; display: none;'>운송번호</th>
			 <th style='width:0px; display: none;'>배차번호</th>
			 <th>순서</th>
		     <th>운송시작일시</th>
		     <th>운송종료일시</th>
		     <th>차량번호</th>
		     <th style='width:0px; display: none;'>차량번호rev</th>
		     <th>차량명칭</th>
		     <th>배송기사</th>
		     <th>비고</th>
		     <th>주행후</th>
		     <th>운행km</th>		     
		     <!-- 버튼자리 -->
		     <%if(GV_CALLER.equals("S858S030101")){%>
		     <th></th>
		     <%} else {%>
		     <th style='width:0px; display: none;'></th>
		     <%}%>
		</tr>
		</thead>
		<tbody id="<%=makeGridData.htmlTable_ID%>_body">		
		</tbody>
</table>
<div id="UserList_pager" class="text-center">
</div>      
