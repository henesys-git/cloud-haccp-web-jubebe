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
	//	final int PageSize=15; 


	
	String GV_ORDER_NO="",GV_IMPORT_INSPECT_REQ_NO="";
	
	if(request.getParameter("OrderNo")== null)
		GV_ORDER_NO="";
	else
		GV_ORDER_NO = request.getParameter("OrderNo");
	
	//tablet 관련부분//////////////////////////////////////
	String GV_TABLET_NY = "";
	
	if(request.getParameter("TabletYN")== null)
		GV_TABLET_NY="";
	else
		GV_TABLET_NY = request.getParameter("TabletYN");
			
	
	
	String param = GV_ORDER_NO + "|";
	
	JSONObject jArray = new JSONObject();
	jArray.put( "order_no", GV_ORDER_NO);
	jArray.put( "member_key", member_key);
		
    TableModel = new DoyosaeTableModel("M404S010100E214",jArray);	
 	int RowCount =TableModel.getRowCount();	

 	CurrentPage jspPageName = new CurrentPage(request.getRequestURI());
 	String JSPpage = jspPageName.GetJSP_FileName();
 	
	makeGridData= new MakeGridData(TableModel);
	
	String RightButton[][]	= {{"off", "fn_Chart_View", rightbtnChartShow},{"off", "fn_Doc_Reg()", rightbtnDocSave},{"off", "fn_mius_body(this)", "삭제"}};
 	makeGridData.RightButton	= RightButton;
 	 
    makeGridData.htmlTable_ID	= "tableS404S010210";
    
 	makeGridData.Check_Box 	= "false";
 	String[] HyperLink		= {""}; //strColumnHead의 수만큼
 	makeGridData.HyperLink 	= HyperLink;
 	

    
    //int ColCount =TableModel.getColumnCount();
    
//     out.println(makeTableHTML.getHTML());		
%>
<script>
    <%-- $(document).ready(function () {

		vTableS404S010130 = $('#<%=makeTableHTML.htmlTable_ID%>').DataTable({
			scrollX: true,
		    scrollY: 380,
		    scrollCollapse: true,
		    paging: false,
		    lengthMenu: [[8,9,-1], [8,9,"All"]],
		    searching: false,
		    ordering: true,
		    order: [[ 3, "asc" ]],
		    keys: false,
		    info: true,
		    'createdRow': function(row) {	
	      		$(row).attr('id',"<%=makeTableHTML.htmlTable_ID%>_rowID");
// 	      		$(row).attr('onclick',"S404S010130Event(this)");
	      		$(row).attr('role',"row");
	  		},
	  		'columnDefs': [{
	       		'targets': [0,1,  16],
	       		'createdCell':  function (td) {
	          			$(td).attr('style', 'width:0px; display: none;'); 
	       		}
       		}
       		],         
            language: { 
                url:"<%=Config.this_SERVER_path%>/AdminLTE-3.0.5/localisation/Korean.json"
             }	  	
		});

	
		$('#<%=makeTableHTML.htmlTable_ID%> tbody').on( 'click', 'tr', function () {
			S404S010130_Row_index = vTableS404S010130
		        .row( this )
		        .index();
			
// 			$($("input[id='checkbox1']")[S404S010130_Row_index]).prop("checked", function(){
// 		        return !$(this).prop('checked');
// 		    });

	 		$(<%=makeTableHTML.htmlTable_ID%>_rowID).removeClass("hene-bg-color");
			vTableS404S010130.row(this)
		    .nodes()
		    .to$()
		    .attr("class","hene-bg-color");

			$('#txt_balju_no').val(vTableS404S010130.cell(S404S010130_Row_index, 2).data());	//0 순번
			$('#txt_balju_seq').val(vTableS404S010130.cell(S404S010130_Row_index, 3).data());	//0 순번
			$('#txt_bom_nm').val(vTableS404S010130.cell(S404S010130_Row_index, 4).data());	//2 자료이름
			$('#txt_bom_cd').val(vTableS404S010130.cell(S404S010130_Row_index, 5).data());	//3 자료번호
			$('#txt_part_cd').val(vTableS404S010130.cell(S404S010130_Row_index, 7).data());	//7 파트코드
			$('#txt_request_cnt').val(vTableS404S010130.cell(S404S010130_Row_index, 8).data());	//9 요청수량
			$('#txt_inspect_cnt').val(vTableS404S010130.cell(S404S010130_Row_index, 9).data());	//9 검사수량
			$('#txt_err_cnt').val(vTableS404S010130.cell(S404S010130_Row_index, 10).data());	//9 불량수량
			$('#txt_ok_yn').val(vTableS404S010130.cell(S404S010130_Row_index, 11).data());	//9 합격여부
			$('#txt_part_cd_rev').val(vTableS404S010130.cell(S404S010130_Row_index, 12).data());//3 txt_part_cd_rev
									
			$('#btn_plus').html("수정");
		} );
		        

		$('#<%=makeTableHTML.htmlTable_ID%> tbody').on( 'blur', 'tr', function () {
			vTableS404S010130.row(this)
		    .nodes()
		    .to$()
		    .attr("class", "hene-bg-color_w");
		} );
    }); --%>
    
    
    
    $(document).ready(function () {
		
		var htmlTable_ID = <%=makeGridData.htmlTable_ID%>;
		
		var customOpts = {
				data : <%=makeGridData.getDataArray()%>,
				columnDefs : [{
					'targets': [0,1,15],
					'createdCell': function (td) {
			  			$(td).attr('style', 'display: none;'); 
					}
				}]
		}
		
		$('#<%=makeGridData.htmlTable_ID%>').DataTable(
			mergeOptions(heneSubTableOpts, customOpts)
		);
		
    	fn_Clear_varv();
    });
    	
    	
    	 
    
// 	function S404S010130Event(obj){
// 		var tr = $(obj);
// 		var td = tr.children();

// 		var trNum = $(obj).closest('tr').prevAll().length;//현재 클릭한 TR의 순서 return .bg-success

// 		$($("input[id='checkbox1']")[trNum]).prop("checked", function(){
// 	        return !$(this).prop('checked');
// 	    });


<%-- 		$(<%=makeTableHTML.htmlTable_ID%>_rowID).attr("class", ""); --%>
// 		$(obj).attr("class", "hene-bg-color");

// 	 	vBalju_no 		= td.eq(1).text().trim(); 
// 	 	vBalju_req_date = td.eq(2).text().trim(); 
// 	 	vPart_cd 		= td.eq(13).text().trim(); 
// 	 	vImport_inspect_seq= td.eq(15).text().trim(); 
// 	}

    
</script>


<table class='table table-bordered nowrap table-hover' id="<%=makeGridData.htmlTable_ID%>" style="width: 100%">
		<thead>
		<tr>
		<% if(GV_TABLET_NY.equals("Tablet")) { %>
		     <th style='width:0px; display: none;'>주문번호</th>
		     <th style='width:0px; display: none;'>주문상세번호</th>
		     <th>발주번호</th>
		     <th>발주순번</th>
		     <th>배합(BOM)번호</th>
		     
		     <th>배합(BOM)이름</th>
		     <th>원부자재번호</th>
		     <th>요청수</th>
		     <th>검사수</th>
		     
		     <th>오류수</th>
		     <th>체크내용</th>
		     <th>표준지침</th>
		     <th>표준값</th>
		     <th>결과</th>
		     
		     <th>합격여부</th>
		     <th style='width:0px; display: none;'>part_cd_rev</th>
	
		    
		     
		     <!-- 버튼 자리 makeGridData의 데이터는 항상 버튼위 위치에 데이터를 space혹은 Button 문법을 구현해 준다-->
<!-- 			<th style='width:0px; display: none;'></th> -->
		     
		<% } else { %>
			 <th style='width:0px; display: none;'>주문번호</th>
		     <th style='width:0px; display: none;'>주문상세번호</th>
		     <th>발주번호</th>
		     <th>발주순번</th>
		     <th>배합(BOM)번호</th>
		     
		     <th>배합(BOM)이름</th>
		     <th>원부자재번호</th>
		     <th>요청수</th>
		     <th>검사수</th>
		     
		     <th>오류수</th>
		     <th>체크내용</th>
		     <th>표준지침</th>
		     <th>표준값</th>
		     <th>결과</th>
		     
		     <th>합격여부</th>
		     <th style='width:0px; display: none;'>part_cd_rev</th>

		     
		     <!-- 버튼 자리 makeGridData의 데이터는 항상 버튼위 위치에 데이터를 space혹은 Button 문법을 구현해 준다-->
<!-- 		     <th style='width:0px; display: none;'></th> -->
		<% } %>
		      
		</tr>
		</thead>
		<tbody id="<%=makeGridData.htmlTable_ID%>_body">		
		</tbody>
</table>


<div id="UserList_pager" class="text-center">
</div>              