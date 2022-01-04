<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="mes.client.comm.*" %>
<%@ page import="mes.client.guiComponents.*" %>
<%@ page import="mes.client.util.*" %>
<%@ page import="mes.client.conf.*" %>
<%@ page import="org.json.simple.*"%><%@ include file="/strings.jsp" %>
<%
/* 
발주용 BOM 조회
 */
	DoyosaeTableModel TableModel;
	MakeGridData makeGridData;
	String loginID = session.getAttribute("login_id").toString();
	String member_key = session.getAttribute("member_key").toString();

	String GV_BALJU_REQ_DATE="",GV_ORDER_NO="",GV_LOTNO="";
	
	if(request.getParameter("order_no")== null)
		GV_ORDER_NO="";
	else
		GV_ORDER_NO = request.getParameter("order_no");	
	
	if(request.getParameter("lotno")== null)
		GV_LOTNO="";
	else
		GV_LOTNO = request.getParameter("lotno");	
	
	
	JSONObject jArray = new JSONObject();
	jArray.put( "order_no", GV_ORDER_NO);
	jArray.put( "lotno", GV_LOTNO);
	jArray.put( "member_key", member_key);
	
	TableModel = new DoyosaeTableModel("M202S010100E124", jArray);
 	int RowCount =TableModel.getRowCount();	

 	CurrentPage jspPageName = new CurrentPage(request.getRequestURI());
 	String JSPpage = jspPageName.GetJSP_FileName();
 	
    makeGridData= new MakeGridData(TableModel);
	String RightButton[][]	= {{"off", "fn_Chart_View", rightbtnChartShow},{"off", "fn_Doc_Reg()", rightbtnDocSave},{"off", "file_real_name", rightbtnDocShow}};
 	makeGridData.RightButton	= RightButton;
 	
    makeGridData.htmlTable_ID	= "TableS202S010170";
    
 	makeGridData.Check_Box 	= "true";
 	String[] HyperLink		= {""}; //strColumnHead의 수만큼
 	makeGridData.HyperLink 	= HyperLink;
%>
<script>
	var S202S010170_Row;
	var vTableS202S010170;
	var table_info;
	var table_rows = 0;
	
    $(document).ready(function () {

	 vTableS202S010170 = $('#<%=makeGridData.htmlTable_ID%>').DataTable({
		 scrollX: true,
		    scrollY: 380,
		    scrollCollapse: true,
		    paging: false,
		    lengthMenu: [[8,9,-1], [8,9,"All"]],
		    searching: true,
		    ordering: true,
		    order: [[ 3, "asc" ]],
		    keys: false,
		    info: true,
		    data: <%=makeGridData.getDataArry()%>,
		    'createdRow': function(row) {	
	      		$(row).attr('id',"<%=makeGridData.htmlTable_ID%>_rowID");
	      		$(row).attr('onclick'," <%=makeGridData.htmlTable_ID%>Event(this)");
	      		$(row).attr('role',"row");
	  		},
	  		'columnDefs': [{
	       		'targets': [1,2,3,11,12,14],
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
		}); // datatable
		
	 $('#<%=makeGridData.htmlTable_ID%> tbody').on( 'click', 'tr', function () {
			S202S010170_Row = vTableS202S010170.row( this ).index();
	 		$(<%=makeGridData.htmlTable_ID%>_rowID).removeClass("hene-bg-color");		
	 		
	 		vTableS202S010170.cell(S202S010170_Row,0).nodes().to$().find("input[id='checkbox1']").prop("checked", function(){
				if($(this).prop('checked'))
					$(this).prop("checked", false);
				else
					$(this).prop("checked", true);
			});
	 		
			vTableS202S010170.row( this ).nodes().to$().attr("class", "hene-bg-color");
		} );
		
		$("#<%=makeGridData.htmlTable_ID%>_head input[id='checkboxAll']").on("click", function(){
			table_info = vTableS202S010170.page.info();
			table_rows = table_info.recordsTotal;
			
			for(var i=0;i<table_rows;i++){  
				vTableS202S010170.cell(i,0).nodes().to$().find("input[id='checkbox1']").prop("checked",this.checked);
			}
		});
	 
    }); // $(document).ready

    function  <%=makeGridData.htmlTable_ID%>Event(obj){
    	var tr = $(obj);
		var td = tr.children();
		var trNum = $(obj).closest('tr').prevAll().length;//현재 클릭한 TR의 순서 return			
		
<%--  		$(<%=makeGridData.htmlTable_ID%>_rowID).attr("class", ""); --%>
// 		$(obj).attr("class", "hene-bg-color");
    }   

    function Save_S202S010170(){
        var table_info = vTableS202S010170.page.info();
        var table_rows = table_info.recordsTotal;
    	for(var i=0;i<table_rows;i++){
    		var trInput = $($("#<%=makeGridData.htmlTable_ID%>_body tr")[i]).find(":input")
    		if($(trInput.eq(0)).is(":checked") ){
//     			{"주문번호","발주번호", "순번", "자료명",  "자료번호", "원부자재번호",  "파트코드","규격", "수량", "단가","금액","Rev","part_cd_rev","재고"};
    			vTableS202S010150_info = vTableS202S010150.page.info();
				TableS202S010150_RowCount = vTableS202S010150_info.recordsTotal;
    			vTableS202S010150.row.add( [
    				vTableS202S010170.cell(i , 1).data(),	// 0 주문번호
    				''									,	// 1 발주번호
    				vTableS202S010170.cell(i , 4).data(),	// 2 순번
    				vTableS202S010170.cell(i , 5).data(),	// 3 자료명
    				vTableS202S010170.cell(i , 2).data(),	// 4 BOM번호
    				vTableS202S010170.cell(i , 6).data(),	// 6 파트코드
    				vTableS202S010170.cell(i , 7).data(),	// 7 규격
    				vTableS202S010170.cell(i , 8).data(),	// 8 수량
    				vTableS202S010170.cell(i , 9).data(),	// 9 단가
    				vTableS202S010170.cell(i , 10).data(),	// 0 금액
    				vTableS202S010170.cell(i , 11).data(),	// 1 rev
    				vTableS202S010170.cell(i , 12).data(),	// 2 part_cd_rev  
    				vTableS202S010170.cell(i , 13).data(),	// 3 BOM재고
    				'<button style="width: auto; float: left; " type="button" onclick="fn_mius_body(this)" id="right_btn" class="btn-outline-success">삭제</button>'
    	        ] );
    		}
    	}
    	vTableS202S010150.draw(true);
		vTableS202S010150_info = vTableS202S010150.page.info();
		TableS202S010150_RowCount = vTableS202S010150_info.recordsTotal;
        $('#txt_seq').val( TableS202S010150_RowCount + 1);
        
        parent.$("#ReportNote_nd").children().remove();
    	parent.$('#modalReport_nd').hide();
    }
</script>
    <table class='table table-bordered nowrap table-hover' id="<%=makeGridData.htmlTable_ID%>" style="width: 100%">
		<thead id="<%=makeGridData.htmlTable_ID%>_head">
		<tr>
			 <th><input type='checkbox'  id='checkboxAll'/></th><!-- 전체선택 체크박스 쓸 경우 추가 -->
		     <th style='width:0px; display: none;'>주문번호</th>
		     <th style='width:0px; display: none;'>배합(BOM)코드</th>
		     <th style='width:0px; display: none;'>배합(BOM)코드명</th>
		     <th>순번</th>
		     <th>원부자재명</th>
		     <th>원부자재코드</th>
		     <th>규격</th>
		     <th>수량</th>
		     <th>단가</th>
		     <th>금액</th>
		     <th style='width:0px; display: none;'>Rev</th>
		     <th style='width:0px; display: none;'>part_cd_rev</th>
		     <th>재고</th>
		     <!-- 버튼 자리 makeGridData의 데이터는 항상 버튼위 위치에 데이터를 space혹은 Button 문법을 구현해 준다-->
		     <th  style='width:0px; display: none;'></th>  
		
		</tr>
		</thead>
		<tbody id="<%=makeGridData.htmlTable_ID%>_body">		
		</tbody>
	</table>
    
	<p style="text-align:center">
		<button id="btn_Save"  class="btn btn-info"  onclick="Save_S202S010170();">적용</button>
	    <button id="btn_Canc"  class="btn btn-info"  onclick="parent.$('#modalReport_nd').hide();">취소</button>
	</p>