<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="mes.client.comm.*" %>
<%@ page import="mes.client.guiComponents.*" %>
<%@ page import="mes.client.util.*" %>
<%@ page import="mes.client.conf.*" %>
<%@ page import="org.json.simple.*"%><%@ include file="/strings.jsp" %>
<%
/* 
제품(모델별) BOM 선택하는 화면
 */
	DoyosaeTableModel TableModel;
	MakeGridData makeGridData;
	String loginID = session.getAttribute("login_id").toString();
	String member_key = session.getAttribute("member_key").toString();

	String GV_BOM_CD="", GV_BOM_CD_REV="";
	
	if(request.getParameter("bom_cd")== null)
		GV_BOM_CD="";
	else
		GV_BOM_CD = request.getParameter("bom_cd");	
	
	if(request.getParameter("bom_cd_rev")== null)
		GV_BOM_CD_REV="";
	else
		GV_BOM_CD_REV = request.getParameter("bom_cd_rev");	

	String param =   GV_BOM_CD + "|" ;
	
	JSONObject jArray = new JSONObject();
	jArray.put( "bom_cd", GV_BOM_CD);
	jArray.put( "bom_cd_rev", GV_BOM_CD_REV);
	jArray.put( "member_key", member_key);
		
    TableModel = new DoyosaeTableModel("M909S010100E245", jArray);
    /* =========================복사하여 수정 할 부분====끝=====================================  */  
 	int RowCount =TableModel.getRowCount();
 	CurrentPage jspPageName = new CurrentPage(request.getRequestURI());
 	String JSPpage = jspPageName.GetJSP_FileName();   
 	
    makeGridData= new MakeGridData(TableModel);
	String RightButton[][]	= {{"off", "fn_Chart_View", rightbtnChartShow},{"off", "fn_Doc_Reg()", rightbtnDocSave},{"off", "file_real_name", rightbtnDocShow}};
 	makeGridData.RightButton	= RightButton;
 	
 	/* =========================복사하여 수정 할 부분=================================================  */ 
    makeGridData.htmlTable_ID	= "TableS101S030145";
    /* =========================복사하여 수정 할 부분====끝=====================================  */  
    
 	makeGridData.Check_Box 	= "true";
 	String[] HyperLink		= {""}; //strColumnHead의 수만큼
 	makeGridData.HyperLink 	= HyperLink;    
%>

<script type="text/javascript">
	var Rowcount='<%=RowCount%>';
	var vTableS101S030145;
	var S101S030145_Row;
	var table_info;
	var table_rows = 0;
	$(document).ready(function () {
		vTableS101S030145 = $('#<%=makeGridData.htmlTable_ID%>').DataTable({
			scrollX: true,
		    scrollY: 380,
		    scrollCollapse: true,
		    paging: false,
		    lengthMenu: [[8,9,-1], [8,9,"All"]],
		    searching: false,
		    ordering: true,
		    order: [[ 1, "asc" ]],
		    keys: false,
		    data:<%=makeGridData.getDataArry()%>,
		    info: true,
		    'createdRow': function(row) {	
	      		$(row).attr('id',"<%=makeGridData.htmlTable_ID%>_rowID");
<%-- 	      		$(row).attr('onclick',"<%=makeGridData.htmlTable_ID%>Event(this)"); --%>
	      		$(row).attr('role',"row");
	  		},
	  		'columnDefs': [{
	       		'targets': [3,5,7,9,10,11,12,13,14,15,16,17,20],
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
			S101S030145_Row = vTableS101S030145.row( this ).index();
	 		$(<%=makeGridData.htmlTable_ID%>_rowID).removeClass("hene-bg-color");		
	 		
	 		vTableS101S030145.cell(S101S030145_Row,0).nodes().to$().find("input[id='checkbox1']").prop("checked", function(){
				if($(this).prop('checked'))
					$(this).prop("checked", false);
				else
					$(this).prop("checked", true);
			});
	 		
	 		vTableS101S030145.row( this ).nodes().to$().attr("class", "hene-bg-color");
		} );
		
		$("#<%=makeGridData.htmlTable_ID%>_head input[id='checkboxAll']").on("click", function(){
			table_info = vTableS101S030145.page.info();
			table_rows = table_info.recordsTotal;
			
			for(var i=0;i<table_rows;i++){  
				vTableS101S030145.cell(i,0).nodes().to$().find("input[id='checkbox1']").prop("checked",this.checked);
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
    
    function Save_S101S030145(){
        var table_info = vTableS101S030145.page.info();
        var table_rows = table_info.recordsTotal;
    	for(var i=0;i<table_rows;i++){
    		var trInput = vTableS101S030145.cell(i, 0).nodes().to$().find(":input");
    		if($(trInput.eq(0)).is(":checked") ){
    			// part_cd 비교해서 이미 등록된 원부자재는 패스
    			var v_part_cd = vTableS101S030145.cell(i,4).data();
    			var jungbok_chk = false;
    			for(j=0; j<TableS101S030140_Row_Count; j++) {
    				if(v_part_cd==vTableS101S030140.cell(j,3).data()) {
    					jungbok_chk = true;
        			}
    			}
    			// 중복아니면 vTableS101S030140 테이블에 데이터행추가
    			if(!jungbok_chk){
    				vTableS101S030140.row.add( [
    					vTableS101S030145.cell(i,1).data(), //0 순번 txt_seq
    					vTableS101S030145.cell(i,2).data(), //1 BOM번호 txt_bom_cd_click
    					vTableS101S030145.cell(i,3).data(),	//2 개정번호 txt_bom_cd_rev
    					vTableS101S030145.cell(i,4).data(), //5 파트코드 txt_part_cd
    					vTableS101S030145.cell(i,5).data(), //6 배합(BOM)명 txt_bom_nm
    					vTableS101S030145.cell(i,6).data(), //6 자료이름 txt_part_nm
    					vTableS101S030145.cell(i,7).data(), //8 part_cd_rev
    					parseFloat(vTableS101S030145.cell(i,8).data())*parseFloat(parent.$("#txt_mix_recipe_cnt").val()), //9 중량(g)(배합중량*배합수) txt_part_cnt
    					vTableS101S030145.cell(i,9).data(), //0 매수 txt_maesu
    					vTableS101S030145.cell(i,10).data(), //1 구분 txt_gubun
    					vTableS101S030145.cell(i,11).data(), //2 구분 txt_qar
    					vTableS101S030145.cell(i,12).data(), //3 구분 txt_inspectequep
    					vTableS101S030145.cell(i,13).data(), //4 구분 txt_package          	
    					vTableS101S030145.cell(i,14).data(), //5 수정 txt_modify
    					vTableS101S030145.cell(i,15).data(), //6 cust_cd txt_bom_custcode
    					vTableS101S030145.cell(i,16).data(), //7 거래처 txt_bom_CustName
    					vTableS101S030145.cell(i,17).data(), //8 거래처 txt_cust_rev
    					vTableS101S030145.cell(i,18).data(), //9 비고 txt_bigo
    					'',
    					'',
    					'',
    					'',
    					'',
    					'',
    					vTableS101S030145.cell(i,19).data(), //9 재고 txt_bigo
    					'<button style="width: auto; float: left; " type="button" onclick="fn_mius_body(this)" id="right_btn" class="btn-outline-success">삭제</button>'
        	        ] );
    			} // 중복체크 if문 end
    		} // 체크된 행 if문 end
    	}// for(i) end
    	vTableS101S030140.draw(true);
		vTableS101S030140_info = vTableS101S030140.page.info();
		TableS101S030140_Row_Count = vTableS101S030140_info.recordsTotal;
        
		var max_seq = 0;
        for(i=0; i<TableS101S030140_Row_Count; i++) {
        	if(max_seq < parseInt(vTableS101S030140.cell( i, 0 ).data()))
        		max_seq = parseInt(vTableS101S030140.cell( i, 0 ).data());
        }
        var rCount = max_seq + 1;
	    $('#txt_seq').val(rCount);
	    $('#txt_lastseq').val(max_seq);
	    
        parent.$("#ReportNote_nd").children().remove();
    	parent.$('#modalReport_nd').hide();
    }
</script>
<table class='table table-bordered nowrap table-hover' id="<%=makeGridData.htmlTable_ID%>" style="width: 100%">
		<thead id="<%=makeGridData.htmlTable_ID%>_head">
		<tr>
			 <th><input type='checkbox'  id='checkboxAll'/></th><!-- 전체선택 체크박스 쓸 경우 추가 -->
		     <th>순번</th>
		     <th>배합(BOM)코드</th>
		     <th style='width:0px; display: none;'>배합(BOM)개정번호</th>
		     <th>원부자재코드</th>
		     <th style='width:0px; display: none;'>배합(BOM)명</th>
		     <th>원부자재명</th>
		     <th style='width:0px; display: none;'>원부자재개정번호</th>
		     <th>원부자재중량(g)</th>
		     <th style='width:0px; display: none;'>매수</th>
		     <th style='width:0px; display: none;'>구분</th>
		     <th style='width:0px; display: none;'>qar</th>
		     <th style='width:0px; display: none;'>inspect</th>
		     <th style='width:0px; display: none;'>package</th>
		     <th style='width:0px; display: none;'>수정</th>
		     <th style='width:0px; display: none;'>고객사코드</th>
		     <th style='width:0px; display: none;'>거래처</th>
		     <th style='width:0px; display: none;'>고객사개정번호</th>
		     <th>비고</th>
		     <th>재고</th>
<!-- 		     버튼 자리 makeGridData의 데이터는 항상 버튼위 위치에 데이터를 space혹은 Button 문법을 구현해 준다 -->
		     <th style='width:0px; display: none;'></th> 
		</tr>
		</thead>
		<tbody id="<%=makeGridData.htmlTable_ID%>_body">		
		</tbody>
	</table>     

	<p style="text-align:center">
		<button id="btn_Save"  class="btn btn-info"  onclick="Save_S101S030145();">적용</button>
	    <button id="btn_Canc"  class="btn btn-info"  onclick="parent.$('#modalReport_nd').hide();">취소</button>
	</p>
	