<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="mes.client.comm.*" %>
<%@ page import="mes.client.guiComponents.*" %>
<%@ page import="mes.client.util.*" %>
<%@ page import="mes.client.conf.*" %>
<%@ page import="org.json.simple.*"%><%@ include file="/strings.jsp" %>
<%@page import="java.math.BigDecimal"%>
<%
/* 
제품(모델별) 부재료 선택하는 화면
 */
	DoyosaeTableModel TableModel;
	MakeGridData makeGridData;
	String loginID = session.getAttribute("login_id").toString();
	String member_key = session.getAttribute("member_key").toString();

	String GV_PROD_CD="", GV_PROD_CD_REV="";
	
	if(request.getParameter("prod_cd")== null)
		GV_PROD_CD="";
	else
		GV_PROD_CD = request.getParameter("prod_cd");	
	
	if(request.getParameter("prod_cd_rev")== null)
		GV_PROD_CD_REV="";
	else
		GV_PROD_CD_REV = request.getParameter("prod_cd_rev");	

	JSONObject jArray = new JSONObject();
	jArray.put( "prod_cd", GV_PROD_CD);
	jArray.put( "prod_cd_rev", GV_PROD_CD_REV);
	jArray.put( "member_key", member_key);
		
    TableModel = new DoyosaeTableModel("M303S060700E166", jArray);
    /* =========================복사하여 수정 할 부분====끝=====================================  */  
 	int RowCount =TableModel.getRowCount();
 	CurrentPage jspPageName = new CurrentPage(request.getRequestURI());
 	String JSPpage = jspPageName.GetJSP_FileName();   
 	
    makeGridData= new MakeGridData(TableModel);
	String RightButton[][]	= {{"off", "fn_Chart_View", rightbtnChartShow},{"off", "fn_Doc_Reg()", rightbtnDocSave},{"off", "file_real_name", rightbtnDocShow}};
 	makeGridData.RightButton	= RightButton;
 	
 	/* =========================복사하여 수정 할 부분=================================================  */ 
    makeGridData.htmlTable_ID	= "TableS303S060796";
    /* =========================복사하여 수정 할 부분====끝=====================================  */  
    
 	makeGridData.Check_Box 	= "true";
 	String[] HyperLink		= {""}; //strColumnHead의 수만큼
 	makeGridData.HyperLink 	= HyperLink;    
 	
%>

<script type="text/javascript">
	var Rowcount='<%=RowCount%>';
	var vTableS303S060796;
	var S303S060796_Row;
	var table_info;
	var table_rows = 0;
	$(document).ready(function () {
		vTableS303S060796 = $('#<%=makeGridData.htmlTable_ID%>').DataTable({
			scrollX: true,
		    scrollY: 380,
		    scrollCollapse: true,
		    paging: false,
		    lengthMenu: [[8,9,-1], [8,9,"All"]],
		    searching: false,
		    ordering: true,
		    order: [[ 4, "asc" ]],
		    keys: false,
		    data:<%=makeGridData.getDataArry()%>,
		    info: true,
		    'createdRow': function(row) {	
	      		$(row).attr('id',"<%=makeGridData.htmlTable_ID%>_rowID");
<%-- 	      		$(row).attr('onclick',"<%=makeGridData.htmlTable_ID%>Event(this)"); --%>
	      		$(row).attr('role',"row");
	  		},
	  		'columnDefs': [{
	       		'targets': [1,2,5,9],
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
			S303S060796_Row = vTableS303S060796.row( this ).index();
	 		$(<%=makeGridData.htmlTable_ID%>_rowID).removeClass("hene-bg-color");		
	 		
	 		vTableS303S060796.cell(S303S060796_Row,0).nodes().to$().find("input[id='checkbox1']").prop("checked", function(){
				if($(this).prop('checked'))
					$(this).prop("checked", false);
				else
					$(this).prop("checked", true);
			});
	 		
	 		vTableS303S060796.row( this ).nodes().to$().attr("class", "hene-bg-color");
		} );
		
		$("#<%=makeGridData.htmlTable_ID%>_head input[id='checkboxAll']").on("click", function(){
			table_info = vTableS303S060796.page.info();
			table_rows = table_info.recordsTotal;
			
			for(var i=0;i<table_rows;i++){  
				vTableS303S060796.cell(i,0).nodes().to$().find("input[id='checkbox1']").prop("checked",this.checked);
			}
		});
	});


    
    function <%=makeGridData.htmlTable_ID%>Event(obj){
    	var tr = $(obj);
		var td = tr.children();
		var trNum = $(obj).closest('tr').prevAll().length;//현재 클릭한 TR의 순서 return	
		
		$(<%=makeGridData.htmlTable_ID%>_rowID).removeClass("hene-bg-color");
		$(obj).attr("class", "hene-bg-color");
// 		$(obj).attr("class", "bg-danger");
// 		$(obj).attr("class", "bg-success"); 

// 		$('#txt_seq').val(td.eq(0).text().trim());
// // 		$('#txt_bom_cd').val(td.eq(1).text().trim());
// 		$('#txt_bom_cd_click').val(td.eq(1).text().trim());
// 		$('#txt_part_cd').val(td.eq(3).text().trim());
// // 		$('#txt_bom_nm').val(td.eq(4).text().trim());
// 		$('#txt_part_nm').val(td.eq(5).text().trim());
// 		$('#txt_part_cd_rev').val(td.eq(6).text().trim());
// 		$('#txt_part_cnt').val(td.eq(7).text().trim());
// 		$('#txt_maesu').val(td.eq(8).text().trim());
// 		$('#txt_gubun').val(td.eq(9).text().trim());
// 		$('#txt_qar').val(td.eq(10).text().trim())
// 		$('#txt_inspectequep').val(td.eq(11).text().trim())
// 		$('#txt_package').val(td.eq(12).text().trim())	   
// 		$('#txt_modify').val(td.eq(13).text().trim());
// 		$('#txt_bom_custcode').val(td.eq(14).text().trim());
// 		$('#txt_bom_CustName').val(td.eq(15).text().trim());
// 		$('#txt_cust_rev').val(td.eq(16).text().trim());
// 		$('#txt_bigo').val(td.eq(17).text().trim());

    }       
    
    function Save_S303S060796(){
        var table_info = vTableS303S060796.page.info();
        var table_rows = table_info.recordsTotal;
    	for(var i=0;i<table_rows;i++){
    		var trInput = vTableS303S060796.cell(i, 0).nodes().to$().find(":input");
    		if($(trInput.eq(0)).is(":checked") ){
    			// part_cd 비교해서 이미 등록된 원부자재는 패스
    			var v_part_cd = vTableS303S060796.cell(i,4).data();
    			var jungbok_chk = false;
    			for(j=0; j<TableS303S060795_Row_Count; j++) {
    				if(v_part_cd==vTableS303S060795.cell(j,3).data()) {
    					jungbok_chk = true;
        			}
    			}
    			// 중복아니면 vTableS303S060795 테이블에 데이터행추가
    			if(!jungbok_chk){
    				vTableS303S060795.row.add( [
    					'', //0 warehousing_datetime
    					'', //1 io_gubun
    					'',	//2 유통기한
    					vTableS303S060796.cell(i,4).data(), //3 part_cd
    					vTableS303S060796.cell(i,5).data(), //4 part_cd_rev
    					vTableS303S060796.cell(i,6).data(), //5 원재료명
    					'', //6 규격
    					'', //7 규격(g단위)
    					'', //8 불출 전 재고
    					'', //9 불출 후 재고
    					parseFloat(vTableS303S060796.cell(i,7).data())*parseFloat(parent.$("#txt_package_cnt").val()), //10 원재료 불출 수량
    					'', //11 order_no
    					'', //12 order_detail_seq
    					'', //13 prod_cd
    					'', //14 prod_cd_rev
    					'', //15 prod_nm
    					'', //16 비고 
    					'Y', //17 insert_yn(최초등록여부:Y면등록,N이면수정) 
    					'<button style="width: auto; float: left; " type="button" onclick="fn_mius_body(this)" id="right_btn" class="btn-outline-success">삭제</button>'
        	        ] );
    			} // 중복체크 if문 end
    		} // 체크된 행 if문 end
    	}// for(i) end
    	vTableS303S060795.draw(true);
		vTableS303S060795_info = vTableS303S060795.page.info();
		TableS303S060795_Row_Count = vTableS303S060795_info.recordsTotal;
        
        parent.$("#ReportNote_nd").children().remove();
    	parent.$('#modalReport_nd').hide();
    }
</script>
<table class='table table-bordered nowrap table-hover' id="<%=makeGridData.htmlTable_ID%>" style="width: 100%">
		<thead id="<%=makeGridData.htmlTable_ID%>_head">
		<tr>
			 <th><input type='checkbox'  id='checkboxAll'/></th><!-- 전체선택 체크박스 쓸 경우 추가 -->
		     <th style='width:0px; display: none;'>prod_cd</th>
		     <th style='width:0px; display: none;'>prod_cd_rev</th>
		     <th>제품명</th>
		     <th>부자재코드</th>
		     <th style='width:0px; display: none;'>원부자재개정번호</th>
		     <th>부자재명</th>
		     <th>부자재수량</th>
		     <th>비고</th>
<!-- 		     버튼 자리 makeGridData의 데이터는 항상 버튼위 위치에 데이터를 space혹은 Button 문법을 구현해 준다 -->
		     <th style='width:0px; display: none;'></th> 
		</tr>
		</thead>
		<tbody id="<%=makeGridData.htmlTable_ID%>_body">		
		</tbody>
	</table>     

	<p style="text-align:center">
		<button id="btn_Save"  class="btn btn-info"  onclick="Save_S303S060796();">적용</button>
	    <button id="btn_Canc"  class="btn btn-info"  onclick="parent.$('#modalReport_nd').hide();">취소</button>
	</p>
	