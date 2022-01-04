<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="mes.client.comm.*" %>
<%@ page import="mes.client.guiComponents.*" %>
<%@ page import="mes.client.util.*" %>
<%@ page import="mes.client.conf.*" %>
<%@ page import="org.json.simple.*"%><%@ include file="/strings.jsp" %>
<%
/* 
공정확인표등록의 공정선택하는 화면
 */
	DoyosaeTableModel TableModel;
	MakeTableHTML makeTableHTML; 
	String loginID = session.getAttribute("login_id").toString();
	String member_key = session.getAttribute("member_key").toString();

// 	proc_cd, 공정명,	A.checklist_seq,		B.checklist_cd,	B.check_note,	B.standard_guide,	B.standard_value,	C.item_type,	C.item_desc,	C.item_bigo,	A.checklist_cd_rev,A.revision_no
	String[] strColumnHead 	= {"공정번호","공정명","순번","관련부서", "체크코드","관리항목","작업표준" ,"표준값", "항목유형","항목명" ,"비고","checklist_cd_rev","A.proc_cd_rev","revision_no"};
	int[]   colOff 			= { 1,2,1,1,0,5,6,7,8,8,1,0,0,0};
	String[] TR_Style		= {"",""};
	String[] TD_Style		= {"align:center;font-weight: bold;"}; 
	String[] HyperLink		= {""}; 
	String RightButton[][]	= {{"off", "fn_Chart_View", rightbtnChartShow},{"off", "fn_Doc_Reg()", rightbtnDocSave},{"off", "fn_mius_body(this)", "삭제"}};

	String param =  "|"  ;
	
	JSONObject jArray = new JSONObject();
	jArray.put( "member_key", member_key);
			
    TableModel = new DoyosaeTableModel("M101S030100E154", strColumnHead, param);
 	int RowCount =TableModel.getRowCount();	

 	CurrentPage jspPageName = new CurrentPage(request.getRequestURI());
 	String JSPpage = jspPageName.GetJSP_FileName();
 	
    makeTableHTML= new MakeTableHTML(TableModel);
    makeTableHTML.colCount		= strColumnHead.length;
    makeTableHTML.pageSize 		= RowCount;  //RowCount 1페이지로 구성,PageSize: PageSize의 사이즈로 구성 
    makeTableHTML.currentPageNum= 1;
    makeTableHTML.htmlTable_ID	= "TableS101S030150";
    makeTableHTML.colOff		= colOff;
    makeTableHTML.TR_Style 		= TR_Style;
    makeTableHTML.TD_Style 		= TD_Style; 
    makeTableHTML.HyperLink 	= HyperLink;makeTableHTML.user_id	= loginID;
    makeTableHTML.Check_Box 	= "true";
    makeTableHTML.RightButton	= RightButton; makeTableHTML.jsp_page	= JSPpage;
    String zhtml=makeTableHTML.getHTML();
%>

<script type="text/javascript">	
	var TableS101S030150_Row_Index;
	var vTableS101S030150;
	var Rowcount='<%=RowCount%>';
	$(document).ready(function () {
		vTableS101S030150 = $('#<%=makeTableHTML.htmlTable_ID%>').DataTable({
			scrollX: true,
		    scrollY: 380,
		    scrollCollapse: true,
		    paging: false,
		    lengthMenu: [[8,9,-1], [8,9,"All"]],
		    searching: false,
		    ordering: true,
		    order: [[ 1, "asc" ],[ 3, "asc" ]],
		    keys: false,
		    info: true,
		    'createdRow': function(row) {	
	      		$(row).attr('id',"<%=makeTableHTML.htmlTable_ID%>_rowID");
	      		$(row).attr('role',"row");
	  		},
	  		'columnDefs': [{
	       		'targets': [5,12,13,14],
	       		'createdCell':  function (td) {
	          			$(td).attr('style', 'width:0px; display: none;'); 
	       		}
			}] ,         
            language: { 
                url:"<%=Config.this_SERVER_path%>/AdminLTE-3.0.5/localisation/Korean.json"
             }
		});
	
		$('#<%=makeTableHTML.htmlTable_ID%> tbody').on( 'click', 'tr', function () {
			TableS101S030150_Row_Index = vTableS101S030150.row( this ).index();
	 		$(<%=makeTableHTML.htmlTable_ID%>_rowID).removeClass("hene-bg-color");		
	 		
	 		vTableS101S030150.cell(TableS101S030150_Row_Index,0).nodes().to$().find("input[id='checkbox1']").prop("checked", function(){
				if($(this).prop('checked'))
					$(this).prop("checked", false);
				else
					$(this).prop("checked", true);
		    });

	 		vTableS101S030150.row( this ).nodes().to$().attr("class", "hene-bg-color");
		} );
		
		$("input[id='checkboxAll']").on("click", function(){
			if($(this).prop('checked'))
				$("input[id='checkbox1']").attr("checked", true);
			else
				$("input[id='checkbox1']").attr("checked", false);
	    });   
		
		$('#<%=makeTableHTML.htmlTable_ID%> tbody').on( 'blur', 'tr', function () {
			vTableS101S030150.row( this ).nodes().to$().attr("class", "hene-bg-color_w");
		} );
		
		if(Rowcount > 0){
//         	$('#txt_lastseq').val(Rowcount);
		}
	});

    function Save_S101S030150(){
        var table_info = vTableS101S030150.page.info();
        var table_rows = table_info.recordsTotal;
    	for(var i=0;i<table_rows;i++){    		
//     		if($(this).is(":checked")) $("input:checkbox[id='chkBox']").is(":checked") ;
//S101S030170 {"순번" ,"공정번호","공정명","부서", "proc_rev","체크리스코드","checklist_rev","작업표준","공구","관리항목","표준값"};				
//S101S030150 {"공정번호","공정명","순번","관련부서", "체크코드","관리항목","작업표준" ,"표준값", "항목유형","항목명" ,"비고","checklist_cd_rev","A.proc_cd_rev","revision_no"};
    		if(vTableS101S030150.cell(i,0).nodes().to$().find("input[id='checkbox1']").prop("checked") ){
//     			console.log("input[id='checkbox1']=====" + i);
    			vTableS101S030170_info = vTableS101S030170.page.info();
				TableS101S030170_RowCount = vTableS101S030170_info.recordsTotal; 				
    			vTableS101S030170.row.add( [
    				vTableS101S030150.cell(i , 3).data(),	//0 순번
    				vTableS101S030150.cell(i , 1).data(),	//1 공정번호
    				vTableS101S030150.cell(i , 2).data(),	//2 공정명
    				vTableS101S030150.cell(i , 4).data(),	//3 부서
    				vTableS101S030150.cell(i ,13).data(),	//4 proc_rev					
    				vTableS101S030150.cell(i , 5).data(),	//5 체크리스코드
    				vTableS101S030150.cell(i ,12).data(),	//6 checklist_rev
    				vTableS101S030150.cell(i , 7).data(),	//7 작업표준
    				vTableS101S030150.cell(i ,10).data(),	//8 공구
    				vTableS101S030150.cell(i , 6).data(),	//9 관리항목
    				vTableS101S030150.cell(i , 8).data(),	//0 표준값
    				
    				'<button style="width: auto; float: left; " type="button" onclick="fn_mius_body(this)" id="right_btn" class="btn-outline-success">삭제</button>'
    	        ] );
    		}
    	}
    	vTableS101S030170.draw(true);
		vTableS101S030170_info = vTableS101S030170.page.info();
		TableS101S030170_RowCount = vTableS101S030170_info.recordsTotal;
        
        parent.$("#ReportNote_nd").children().remove();
    	parent.$('#modalReport_nd').hide();
    }
</script>
    <%=zhtml%>  
	<p style="text-align:center">
		<button id="btn_Save"  class="btn btn-info"  onclick="Save_S101S030150();">적용</button>
	    <button id="btn_Canc"  class="btn btn-info"  onclick="parent.$('#modalReport_nd').hide();">취소</button>
	</p>     

	