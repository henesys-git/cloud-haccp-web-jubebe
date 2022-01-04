<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="mes.client.comm.*" %>
<%@ page import="mes.client.guiComponents.*" %>
<%@ page import="mes.client.util.*" %>
<%@ page import="mes.client.conf.*" %>
<%@ page import="org.json.simple.*"%>
<%@ include file="/strings.jsp" %>
<%
	String loginID = session.getAttribute("login_id").toString();
	String member_key = session.getAttribute("member_key").toString();

	DoyosaeTableModel TableModel;
	MakeGridData makeGridData;
	
	int startPageNo = 1;
/* =========================복사하여 수정 할 부분=================================================  */   

	String GV_CALLER="", GV_LEVEL="", GV_CHECK_GUBUN="";

	
	if(request.getParameter("caller")== null)
		GV_CALLER="";
	else
		GV_CALLER = request.getParameter("caller");	
	
	if(request.getParameter("check_gubun")== null)
		GV_CHECK_GUBUN="";
	else
		GV_CHECK_GUBUN = request.getParameter("check_gubun");
	
	JSONObject jArray = new JSONObject();
	jArray.put("check_gubun", GV_CHECK_GUBUN);
	jArray.put("member_key", member_key);
	
    TableModel = new DoyosaeTableModel("M909S030100E194", jArray);	
//     TableModel = new DoyosaeTableModel("M909S010100E204", jArray);	

/* =========================복사하여 수정 할 부분====끝=====================================  */  
 	int RowCount =TableModel.getRowCount();
 	CurrentPage jspPageName = new CurrentPage(request.getRequestURI());
 	String JSPpage = jspPageName.GetJSP_FileName();   
 	
    makeGridData= new MakeGridData(TableModel);
	String RightButton[][]	= {{"off", "fn_Chart_View", rightbtnChartShow},{"off", "fn_Doc_Reg()", rightbtnDocSave},{"off", "file_real_name", rightbtnDocShow}};
 	makeGridData.RightButton	= RightButton;
 	
 	/* =========================복사하여 수정 할 부분=================================================  */ 
    makeGridData.htmlTable_ID	= "TableCheckListView";
    /* =========================복사하여 수정 할 부분====끝=====================================  */  
    
 	makeGridData.Check_Box 	= "true";
 	String[] HyperLink		= {""}; //strColumnHead의 수만큼
 	makeGridData.HyperLink 	= HyperLink;
%>
<script type="text/javascript">

	var caller="";
	var GV_GIJONG_CD;
	
	var vTableCheckListView;
	var CheckListView_Row;
	var table_info;
	var table_rows = 0;
	
    $(document).ready(function () {
    	caller = "<%=GV_CALLER%>";
    	vTableCheckListView = $('#<%=makeGridData.htmlTable_ID%>').DataTable({	
    		scrollX: true,
//     		scrollY: 500,
    	    scrollCollapse: true,
    	    paging: true,
    	    searching: true,
    	    ordering: false,
    	    order: [[ 2, "asc" ]],
    	    info: true,
			data: <%=makeGridData.getDataArry()%>,
		    'createdRow': function(row) {	
	      		$(row).attr('id',"<%=makeGridData.htmlTable_ID%>_rowID");
	      		$(row).attr('onclick',"<%=makeGridData.htmlTable_ID%>Event(this)");
	      		$(row).attr('role',"row");
	  		}, 
	  		/* =========================복사하여 수정 할 부분===========================================  */   
	  		'columnDefs': [{
	       		'targets': [3,4,5,7,8,12],
	       		'createdCell':  function (td) {
	          			$(td).attr('style', 'display: none;'); 
	       		}
			},
			{
	       		'targets': [16],
	       		'createdCell':  function (td) {
          			$(td).attr('style', 'display: none;'); //버튼 자리아래의 테이블 버튼자리와 같이 항상 처리한다.
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
    		CheckListView_Row = vTableCheckListView.row( this ).index();
	 		$(<%=makeGridData.htmlTable_ID%>_rowID).removeClass("hene-bg-color");		
	 		
	 		vTableCheckListView.cell(CheckListView_Row,0).nodes().to$().find("input[id='checkbox1']").prop("checked", function(){
				if($(this).prop('checked'))
					$(this).prop("checked", false);
				else
					$(this).prop("checked", true);
			});
	 		
	 		vTableCheckListView.row( this ).nodes().to$().attr("class", "hene-bg-color");
		} );
		
		$("#<%=makeGridData.htmlTable_ID%>_head input[id='checkboxAll']").on("click", function(){
			table_info = vTableCheckListView.page.info();
			table_rows = table_info.recordsTotal;
			
			for(var i=0;i<table_rows;i++){  
				vTableCheckListView.cell(i,0).nodes().to$().find("input[id='checkbox1']").prop("checked",this.checked);
			}
		});

	});
    /* =========================복사하여 수정 할 부분===========================================  */  
    function <%=makeGridData.htmlTable_ID%>Event(obj){
    	var tr = $(obj);
		var td = tr.children();
		var trNum = $(obj).closest('tr').prevAll().length;//현재 클릭한 TR의 순서 return
		
		$(<%=makeGridData.htmlTable_ID%>_rowID).attr("class", "");
		$(obj).attr("class", "hene-bg-color");
		
    }
    /* =========================복사하여 수정 할 부분====끝=====================================  */ 

	function Save_CheckList(){
		var table;
		if("<%=GV_CHECK_GUBUN%>"=="QAPROCS" || "<%=GV_CHECK_GUBUN%>"=="LCPROCS") table = vTableS909S122170;
		else if("<%=GV_CHECK_GUBUN%>"=="") table = vTableS909S123170;
		else if("<%=GV_CHECK_GUBUN%>"=="PRODCT") table = vTableS909S123170;
		else if("<%=GV_CHECK_GUBUN%>"=="FPRODCT") table = vTableS909S123170;
<%-- 		else if("<%=GV_CHECK_GUBUN%>"=="IMPORT") table = vTableS909S124170; --%>
		else if("<%=GV_CHECK_GUBUN%>"=="PRS-AA") table = vTableS909S122170;
		else if("<%=GV_CHECK_GUBUN%>"=="PRS-BB") table = vTableS909S122170;
		else if("<%=GV_CHECK_GUBUN%>"=="PRS-CC") table = vTableS909S122170;
		else if("<%=GV_CHECK_GUBUN%>"=="BIOLOG") table = vTableS909S123170;
		else if("<%=GV_CHECK_GUBUN%>"=="DLYHYG") table = vTableS909S123170;
		else if("<%=GV_CHECK_GUBUN%>"=="ILLUM") table = vTableS909S123170;
		else if("<%=GV_CHECK_GUBUN%>"=="IMPORT") table = vTableS909S124170;
		else if("<%=GV_CHECK_GUBUN%>"=="IMPORT2") table = vTableS909S124170;
		else if("<%=GV_CHECK_GUBUN%>"=="INOUT") table = vTableS909S123170;
		else if("<%=GV_CHECK_GUBUN%>"=="MEASU") table = vTableS909S123170;
		else if("<%=GV_CHECK_GUBUN%>"=="METAL") table = vTableS909S123170;
		else if("<%=GV_CHECK_GUBUN%>"=="NMTAL") table = vTableS909S123170;
		else if("<%=GV_CHECK_GUBUN%>"=="PERIOD") table = vTableS909S123170;
		else if("<%=GV_CHECK_GUBUN%>"=="PIN") table = vTableS909S123170;
		else if("<%=GV_CHECK_GUBUN%>"=="PROCESS") table = vTableS909S123170;
		else if("<%=GV_CHECK_GUBUN%>"=="PRODUCT") table = vTableS909S123170;
		else if("<%=GV_CHECK_GUBUN%>"=="SHIPMENT") table = vTableS909S123170;
		else if("<%=GV_CHECK_GUBUN%>"=="WRKARE") table = vTableS909S123170;
		else if("<%=GV_CHECK_GUBUN%>"=="PACK") table = vTableS909S123170;
		
		
		var table_info = vTableCheckListView.page.info();
        var table_rows = table_info.recordsTotal;
    	for(var i=0;i<table_rows;i++){
    		if(vTableCheckListView.cell(i,0).nodes().to$().find("input[id='checkbox1']").prop("checked")){
    			console.log("input[id='checkbox1']=====" + i);
    			table.row.add( [
    				vTableCheckListView.cell(i , 3).data(),	// 3 checklist_seq : 순번
    				'', // 원부자재명
    				'', // 원부자재코드
    				'', // 원부자재개정번호
    				'', // pic_seq
    				vTableCheckListView.cell(i , 2).data(),	// 2 checklist_cd  
    				vTableCheckListView.cell(i , 4).data(),	// 4 revision_no           
    				vTableCheckListView.cell(i , 5).data(),	// 5 item_cd
    				vTableCheckListView.cell(i , 8).data(),	// 8 item_cd_rev
    				vTableCheckListView.cell(i , 7).data(),	// 7 item_seq
    				vTableCheckListView.cell(i , 9).data(),	// 9 standard_guide
    				vTableCheckListView.cell(i ,11).data(),	//11 standard_value
    				vTableCheckListView.cell(i ,10).data(),	//10 check_note
	    			vTableCheckListView.cell(i , 1).data(),	// 1 check_gubun  
	    			vTableCheckListView.cell(i , 15).data(),	// 15 check_gubun 이름  
//	    				vTableCheckListView.cell(i , 6).data(),	// 6 item_desc
//	    				vTableCheckListView.cell(i ,12).data(),	//12 html_tag    
//	    				vTableCheckListView.cell(i ,13).data(),	//13 item_type
//	    				vTableCheckListView.cell(i ,14).data(),	//14 item_bigo
    				'<button style="width: auto; float: left; " type="button" onclick="fn_mius_body(this)" id="right_btn" class="btn-outline-success">삭제</button>'
    	        ] ).draw(true);
    		}
    	}
			
		
        
        parent.$("#ReportNote_nd").children().remove();
        $('#modalReport2').modal('hide');
    }
</script>

<!--=========================복사하여 수정 할 부분=================================================-->
<table class='table table-bordered nowrap table-hover' id="<%=makeGridData.htmlTable_ID%>" style="width: 100%">
		<thead id="<%=makeGridData.htmlTable_ID%>_head">
		<tr>
			 <th><input type='checkbox' id='checkboxAll'/></th>
		     <th>구분</th>
		     <th>문항코드</th>
		     <th style='width:0px; display: none;'>문항순서</th>
		     <th style='width:0px; display: none;'>개정번호</th>
		     <th style='width:0px; display: none;'>항목코드</th>
		     <th>항목명</th>
		     <th style='width:0px; display: none;'>항목순서</th>
		     <th style='width:0px; display: none;'>항목개정번호</th>
		     <th>표준지침</th>
		     <th>체크문항명</th>
		     <th>표준값</th>
		     <th style='width:0px; display: none;'>html_tag</th>
		     <th>항목유형</th>
		     <th>항목비고</th>
		     <th>구분명</th>
<!-- 		     버튼 자리 makeGridData의 데이터는 항상 버튼위 위치에 데이터를 space혹은 Button 문법을 구현해 준다 -->
		     <th style='width:0px; display: none;'></th> 
		</tr>
		</thead>
		<tbody id="<%=makeGridData.htmlTable_ID%>_body">		
		</tbody>
	</table>

<!--=========================복사하여 수정 할 부분=====끝============================================-->
<div id="UserList_pager" class="text-center">
	<button id="btn_Save"  class="btn btn-info" style="width: 100px" onclick="Save_CheckList();">적용</button>
	<button id="btn_Canc"  class="btn btn-info" style="width: 100px" onclick="$('#modalReport2').modal('hide');">닫기</button>
</div> 