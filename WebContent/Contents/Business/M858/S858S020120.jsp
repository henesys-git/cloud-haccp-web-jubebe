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
	
	int startPageNo = 1;

	String GV_BAECHA_NO="";
	
	if(request.getParameter("baecha_no")== null)
		GV_BAECHA_NO="";
	else
		GV_BAECHA_NO = request.getParameter("baecha_no"); //구분 : QAPROCS

	JSONObject jArray = new JSONObject();
	jArray.put( "baecha_no", GV_BAECHA_NO);
	jArray.put( "member_key", member_key);
	
	
	TableModel = new DoyosaeTableModel("M858S020100E124", jArray);
 	int RowCount =TableModel.getRowCount();	

  	String RightButton[][]	= {{"off", "fn_Chart_View", rightbtnChartShow},{"off", "fn_Doc_Reg()", rightbtnDocSave},{"off", "file_real_name", rightbtnDocShow}};
  	String[] HyperLink		= {""}; //strColumnHead의 수만큼
  	
  	makeGridData= new MakeGridData(TableModel);
  	
 	makeGridData.RightButton	= RightButton;
 	makeGridData.htmlTable_ID	= "tableS858S020120";
 	makeGridData.Check_Box 	= "true";
 	makeGridData.HyperLink 	= HyperLink; 
%>
    
<script>
	$(document).ready(function () {
		vTableS858S020120 = $('#<%=makeGridData.htmlTable_ID%>').DataTable({	  
			scrollX: true,
    		scrollY: 220,
    	    scrollCollapse: true,
    	    paging: false,
    	    searching: false,
    	    ordering: true,
//     	    order: [[ 11, "asc" ]], //납기일 순 정렬
    	    info: false,
//             className: 'select-checkbox',
            targets:   0,
    	    data: <%=makeGridData.getDataArry()%>,
		    'createdRow': function(row) {	
	      		$(row).attr('id',"<%=makeGridData.htmlTable_ID%>_rowID");
<%-- 	      		$(row).attr('onclick',"<%=makeGridData.htmlTable_ID%>Event(this)"); --%>
	      		$(row).attr('role',"row");
	  		},    
	  		'columnDefs': [
	  			{
	  				'targets': [1,2,3,4,6,7,13,14,15],
		   			'createdCell': function (td) {
		      			$(td).attr('style', 'display: none;'); 
		   			}
				},
				{
		   			'targets': [16],
		   			'createdCell': function (td) {
		   				$(td).attr('style', 'display: none;'); //버튼 자리아래의 테이블 버튼자리와 같이 항상 처리한다.
					}
		   		}
			],
			'drawCallback': function() { // 콜백함수(이거로 써야 테이블생성된후 체크박스에 적용된다)
				$("#<%=makeGridData.htmlTable_ID%> input[id='checkbox1']").off(); // 이전에 있던 이벤트 제거
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
		
		$('#<%=makeGridData.htmlTable_ID%> tbody').on( 'click', 'tr', function () {
			S858S020120_Row_index = vTableS858S020120.row( this ).index();
	 		$(<%=makeGridData.htmlTable_ID%>_rowID).removeClass("hene-bg-color");		
	 		
	 		vTableS858S020120.cell(S858S020120_Row_index,0).nodes().to$().find("input[id='checkbox1']").prop("checked", function(){
				if($(this).prop('checked'))
					$(this).prop("checked", false);
				else
					$(this).prop("checked", true);
			});
	 		
	 		vTableS858S020120.row( this ).nodes().to$().attr("class", "hene-bg-color");
		} );
		
		$("#<%=makeGridData.htmlTable_ID%>_head input[id='checkboxAll']").on("click", function(){
			TableS858S020120_info = vTableS858S020120.page.info();
			TableS858S020120_RowCount = TableS858S020120_info.recordsTotal;
			
			for(var i=0;i<TableS858S020120_RowCount;i++){  
				vTableS858S020120.cell(i,0).nodes().to$().find("input[id='checkbox1']").prop("checked",this.checked);
			}
		});
		
		TableS858S020120_RowCount = vTableS858S020120.rows().count();
		
		for(var i=0; i<TableS858S020120_RowCount; i++) { // 오른쪽테이블에 있는 왼쪽테이블 레코드제거
			var order_no_120 = vTableS858S020120.cell( i, 1).data().trim();
			var order_detail_seq_120 = vTableS858S020120.cell( i, 13).data().trim();
			var chulha_no_120 = vTableS858S020120.cell( i, 14).data().trim();
			var chulha_seq_120 = vTableS858S020120.cell( i, 15).data().trim();
			for(var j=0; j<TableS858S020130_RowCount; j++) {
				var order_no_130 = vTableS858S020130.cell( j, 1).data().trim();
				var order_detail_seq_130 = vTableS858S020130.cell( j, 11).data().trim();
				var chulha_no_130 = vTableS858S020130.cell( j, 12).data().trim();
				var chulha_seq_130 = vTableS858S020130.cell( j, 13).data().trim();
// 				alert("TableS858S020120_RowCount="+TableS858S020120_RowCount+"\n"+"proc_cd_120="+proc_cd_120+"\n"+"proc_cd_130="+proc_cd_130);
				if(order_no_120==order_no_130 && order_detail_seq_120==order_detail_seq_130
						&& chulha_no_120==chulha_no_130 && chulha_seq_120==chulha_seq_130) {
// 					alert("proc="+proc_cd_120+"\n"+"레코드제거");
					vTableS858S020120.row(i).remove().draw();
					TableS858S020120_RowCount = vTableS858S020120.page.info().recordsTotal; //행제거하면 rowcount 다시계산
					i--; //행제거하면 index-1
					break; // 내부 for문 반복종료 -> 다음 i 탐색
				}
			}
 		}

	});



</script>

<table class='table table-bordered nowrap table-hover' id="<%=makeGridData.htmlTable_ID%>" style="width: 100%">
		<thead id="<%=makeGridData.htmlTable_ID%>_head">
		<tr>		  	
			<th><input type='checkbox'  id='checkboxAll'/></th><!-- 전체선택 체크박스 쓸 경우 추가 -->
			<th style='width:0px; display: none;'>주문번호</th>
			<th style='width:0px; display: none;'>묶음번호</th>
			<th style='width:0px; display: none;'>고객코드</th>
			<th style='width:0px; display: none;'>고객rev</th>
			<th>주문업체</th>
			<th style='width:0px; display: none;'>제품코드</th>
			<th style='width:0px; display: none;'>제품rev</th>
			<th>주문제품</th>
			<th>주문제품갯수</th>
			<th>주문일</th>
			<th>납기일</th>
			<th>출하갯수</th>
			<th style='width:0px; display: none;'>order_detail_seq</th>
			<th style='width:0px; display: none;'>chulha_no</th>
			<th style='width:0px; display: none;'>chulha_seq</th>
			<!-- 	버튼자리	 -->			
			<th style='width:0px; display: none;'></th>
		</tr>
		</thead>
		<tbody id="<%=makeGridData.htmlTable_ID%>_body">		
		</tbody>
</table>		
<div id="UserList_pager" class="text-center">
</div>