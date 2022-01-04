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
	
	String GV_ORDER_NO="", GV_LOTNO="", GV_BALJUNO="";

	if(request.getParameter("order_no") == null)
		GV_ORDER_NO="";
	else
		GV_ORDER_NO = request.getParameter("order_no");	
	
	if(request.getParameter("lotno") == null)
		GV_LOTNO="";
	else
		GV_LOTNO = request.getParameter("lotno");
	
	if(request.getParameter("baljuNo") == null)
		GV_BALJUNO="";
	else
		GV_BALJUNO = request.getParameter("baljuNo");
	
	String param = GV_ORDER_NO + "|" + GV_LOTNO + "|" + GV_BALJUNO + "|";
	
	JSONObject jArray = new JSONObject();
	jArray.put("order_no", GV_ORDER_NO);
	jArray.put("lotno", GV_LOTNO);
	jArray.put("baljuNo", GV_BALJUNO);
	jArray.put("member_key", member_key);

	TableModel = new DoyosaeTableModel("M202S030100E124", jArray);	
 	int RowCount =TableModel.getRowCount();	

 	CurrentPage jspPageName = new CurrentPage(request.getRequestURI());
 	String JSPpage = jspPageName.GetJSP_FileName();
 	
 	makeGridData = new MakeGridData(TableModel);
	String RightButton[][]	= {
								{"off", "fn_Chart_View", rightbtnChartShow},
								{"off", "fn_Doc_Reg()", rightbtnDocSave},
								{"off", "file_real_name", rightbtnDocShow}
							  };
 	makeGridData.RightButton = RightButton;
 	
	makeGridData.htmlTable_ID = "TableS202S030120";
    
 	makeGridData.Check_Box 	= "true";
 	String[] HyperLink		= {""}; //strColumnHead의 수만큼
 	makeGridData.HyperLink 	= HyperLink;
 	
 	String vPart_cd = "";
 	for(int i = 0; i < TableModel.getRowCount(); i++) {
 		vPart_cd = TableModel.getValueAt(i, 2).toString().trim();
 	}
%>

<script>
	var S202S030120_Row;
	var vTableS202S030120;
	var table_info;
	var table_rows = 0;

    $(document).ready(function () {
		
    	vTableS202S030120 = $('#<%=makeGridData.htmlTable_ID%>').DataTable({
			scrollX: true,
		    scrollY: 340,
		    scrollCollapse: true,
		    paging: false,
		    searching: false,
		    ordering: true, 
		    order: [[ 1, "asc" ]],
		    keys: false,
		    info: true,
		    data: <%=makeGridData.getDataArry()%>,
		    'createdRow': function(row) {	
	      		$(row).attr('id',"<%=makeGridData.htmlTable_ID%>_rowID");
	      		$(row).attr('onclick'," <%=makeGridData.htmlTable_ID%>Event(this)");
	      		$(row).attr('role',"row");
	  		},
	  		'columnDefs': [{
	       		'targets': [1,2,4,7,8,9,10,13,15,16,17,18,19,20,21,22],
	       		'createdCell':  function (td) {
	          			$(td).attr('style', 'width:0px; display: none;'); 
	       		}
			}],
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
			S202S030120_Row = vTableS202S030120.row( this ).index();
	 		$(<%=makeGridData.htmlTable_ID%>_rowID).removeClass("hene-bg-color");		
	 		
	 		vTableS202S030120.cell(S202S030120_Row,0).nodes().to$().find("input[id='checkbox1']").prop("checked", function(){
				if($(this).prop('checked'))
					$(this).prop("checked", false);
				else
					$(this).prop("checked", true);
			});
	 		
			vTableS202S030120.row( this ).nodes().to$().attr("class", "hene-bg-color");
		} );
		
		$("#<%=makeGridData.htmlTable_ID%>_head input[id='checkboxAll']").on("click", function(){
			table_info = vTableS202S030120.page.info();
			table_rows = table_info.recordsTotal;
			
			for(var i=0;i<table_rows;i++){  
				vTableS202S030120.cell(i,0).nodes().to$().find("input[id='checkbox1']").prop("checked",this.checked);
			}
		});
	
    }); 
    
 
    function <%=makeGridData.htmlTable_ID%>Event(obj){
    	var tr = $(obj);
		var td = tr.children();
		var trNum = $(obj).closest('tr').prevAll().length;//현재 클릭한 TR의 순서 return	
		
 		$(<%=makeGridData.htmlTable_ID%>_rowID).attr("class", "");
		$(obj).attr("class", "hene-bg-color");
		
		$('#txt_store_no').val(td.eq(7).text().trim());
		$('#txt_reakes_no').val(td.eq(8).text().trim());
		$('#txt_plate_no').val(td.eq(9).text().trim());
		$('#txt_colm_no').val(td.eq(10).text().trim());
		
		$('#txt_pre_amt').val(td.eq(12).text().trim());
		$('#txt_post_stack').val(td.eq(14).text().trim());
		
		$('#txt_part_cd').val(td.eq(3).text().trim());
		$('#txt_part_cd_rev').val(td.eq(4).text().trim());
		$('#txt_part_name').val(td.eq(5).text().trim());
		$('#txt_io_count').val(td.eq(6).text().trim());
		
		$('#txt_balju_count').val(td.eq(20).text().trim());
		$('#txt_uninspect_count').val(td.eq(21).text().trim());
		
		if($("#txt_pre_amt").val()==""){$("#txt_pre_amt").val(0);}
		if($("#txt_post_stack").val()==""){$("#txt_post_stack").val(0);}
		
		vProd_cd = td.eq(3).text().trim();
		
    }
</script>

<table class='table table-bordered nowrap table-hover' id="<%=makeGridData.htmlTable_ID%>" style="width: 100%">
	<thead id="<%=makeGridData.htmlTable_ID%>_head">
		<tr>
			<th>
				<input type='checkbox' id='checkboxAll'/>
			</th><!-- 전체선택 체크박스 쓸 경우 추가 -->
			<th style='width:0px; display: none;'>주문번호</th>
			<th style='width:0px; display: none;'>Lot번호</th>
			<th>원부자재코드</th>
			<th style='width:0px; display: none;'>원부자재코드rev</th>
			<th>원부자재명</th>
			<th>검수수량</th>
			<th style='width:0px; display: none;'>창고</th>
			<th style='width:0px; display: none;'>렉</th>
			<th style='width:0px; display: none;'>선반</th>
			<th style='width:0px; display: none;'>칸</th>
			<th>창고 현위치</th>
			<th>입출고전재고</th>
			<th style='width:0px; display: none;'>입출고수</th>
			<th>재고</th>
			<th style='width:0px; display: none;'>안전재고</th>
			<th style='width:0px; display: none;'>대분류</th>
			<th style='width:0px; display: none;'>part_gubun_b</th>
			<th style='width:0px; display: none;'>중분류</th>
			<th style='width:0px; display: none;'>part_gubun_m</th>
			<th style='width:0px; display: none;'>발주수량</th>
			<th style='width:0px; display: none;'>미검수수량</th>
			<!-- 버튼 자리 makeGridData의 데이터는 항상 버튼위 위치에 데이터를 space혹은 Button 문법을 구현해 준다-->
			<th style='width:0px; display: none;'></th>
		</tr>
	</thead>
	<tbody id="<%=makeGridData.htmlTable_ID%>_body">		
	</tbody>
</table>