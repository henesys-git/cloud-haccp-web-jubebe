<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="mes.client.comm.*" %>
<%@ page import="mes.client.guiComponents.*" %>
<%@ page import="mes.client.util.*" %>
<%@ page import="mes.client.conf.*" %>
<%@ page import="org.json.simple.*"%><%@ include file="/strings.jsp" %>
<%
/* 
S101S030131.jsp : 주문별 제품검사체크리스트 등록 화면 의
제품검사체크리스트 선택하는 화면
 */
	DoyosaeTableModel TableModel;
	MakeTableHTML makeTableHTML; 
	String loginID = session.getAttribute("login_id").toString();
	String member_key = session.getAttribute("member_key").toString();
	
	String[] strColumnHead 	= {"순번" ,"제품코드","제품명","체크코드", "작업표준","체크내용","표준값","항목유형","비고",
			"prod_cd_rev","checklist_seq" ,"checklist_cd_rev","item_cd","item_desc", "item_seq","item_cd_rev", "hangmok_code" ,"inspect_gubun","검사구분명" };
	int[]   colOff 			= { 1,2,3,4,5,6,7,8,9,0,0,0,0,0,0,0,0,0,1};
	String[] TR_Style		= {""," onclick='S101S030195Event(this)' "};
	String[] TD_Style		= {"align:center;font-weight: bold;"}; 
	String[] HyperLink		= {""}; 
	String RightButton[][]	= {{"off", "fn_Chart_View", rightbtnChartShow},{"off", "fn_Doc_Reg()", rightbtnDocSave},{"off", "fn_mius_body(this)", "삭제"}};
	

	String  GV_PROD_CD="", GV_INSPECT_GUBUN;
	
	if(request.getParameter("prod_cd")== null)
		GV_PROD_CD="";
	else
		GV_PROD_CD = request.getParameter("prod_cd");
	
	if(request.getParameter("inspect_gubun")== null)
		GV_INSPECT_GUBUN="";
	else
		GV_INSPECT_GUBUN = request.getParameter("inspect_gubun");
	
	String param =  GV_PROD_CD + "|" + GV_INSPECT_GUBUN + "|" ;
	
	JSONObject jArray = new JSONObject();
	jArray.put( "prod_cd", GV_PROD_CD);
	jArray.put( "inspect_gubun", GV_INSPECT_GUBUN);
	jArray.put( "member_key", member_key);	
	
    TableModel = new DoyosaeTableModel("M101S030100E195", strColumnHead, jArray);
 	int RowCount =TableModel.getRowCount();	


 	CurrentPage jspPageName = new CurrentPage(request.getRequestURI());
 	String JSPpage = jspPageName.GetJSP_FileName();
 	
    makeTableHTML= new MakeTableHTML(TableModel);
    makeTableHTML.colCount		= strColumnHead.length;
    makeTableHTML.pageSize 		= RowCount;  //RowCount 1페이지로 구성,PageSize: PageSize의 사이즈로 구성 
    makeTableHTML.currentPageNum= 1;
    makeTableHTML.htmlTable_ID	= "TableS101S030195";
    makeTableHTML.colOff		= colOff;
    makeTableHTML.TR_Style 		= TR_Style;
    makeTableHTML.TD_Style 		= TD_Style; 
    makeTableHTML.HyperLink 	= HyperLink;makeTableHTML.user_id	= loginID;
    makeTableHTML.Check_Box 	= "true";
    makeTableHTML.RightButton	= RightButton; makeTableHTML.jsp_page	= JSPpage;
    String zhtml=makeTableHTML.getHTML();
%>

<script type="text/javascript">	
	var TableS101S030195_Row_Index;
	var vTableS101S030195;
	var Rowcount='<%=RowCount%>';
	$(document).ready(function () {
		vTableS101S030195 = $('#<%=makeTableHTML.htmlTable_ID%>').DataTable({
			scrollX: true,
		    scrollY: 380,
		    scrollCollapse: true,
		    paging: false,
		    lengthMenu: [[8,9,-1], [8,9,"All"]],
		    searching: true,
		    ordering: true,
		    order: [[ 0, "asc" ]],
		    keys: false,
		    info: true
// 		    ,
// 		    'createdRow': function(row) {	
// 	      		$(row).attr('id',"<%=makeTableHTML.htmlTable_ID%>_rowID");
// 	      		$(row).attr('onclick',"S101S030195Event(this)");
// 	      		$(row).attr('role',"row");
// 	  		},
// 	  		'columnDefs': [{
// 	       		'targets': [5,12,13,14],
// 	       		'createdCell':  function (td) {
// 	          			$(td).attr('style', 'width:0px; display: none;'); 
// 	       		}
// 			}]	 
			,         
            language: { 
               url:"<%=Config.this_SERVER_path%>/AdminLTE-3.0.5/localisation/Korean.json"
            }
		});

	
		$('#<%=makeTableHTML.htmlTable_ID%> tbody').on( 'click', 'tr', function () {
			TableS101S030195_Row_Index = vTableS101S030195
		        .row( this )
		        .index();
	 		$(<%=makeTableHTML.htmlTable_ID%>_rowID).removeClass("hene-bg-color");		
	 		
	 		
// 	 		$($("input[id='checkbox1']")[TableS101S030195_Row_Index]).prop("checked", function(){
			vTableS101S030195.cell(TableS101S030195_Row_Index,0).nodes().to$().find("input[id='checkbox1']").prop("checked", function(){
				if($(this).prop('checked'))
					$(this).attr("checked", false);
				else
					$(this).attr("checked", true);
		    });   
	 		
	 		vTableS101S030195
	        .row( this )
		    .nodes()
		    .to$()
		    .attr("class", "hene-bg-color");
		} );
		
		$("input[id='checkboxAll']").on("click", function(){
			if($(this).prop('checked'))
				$("input[id='checkbox1']").attr("checked", true);
			else
				$("input[id='checkbox1']").attr("checked", false);
	    });   
		
		$('#<%=makeTableHTML.htmlTable_ID%> tbody').on( 'blur', 'tr', function () {

			vTableS101S030195
	        .row( this )
		    .nodes()
		    .to$()
		    .attr("class", "hene-bg-color_w");
		} );
		
		if(Rowcount > 0){
//         	$('#txt_lastseq').val(Rowcount);
		}
	});


    
    function S101S030195Event(obj){
    	var tr = $(obj);
		var td = tr.children();
		var trNum = $(obj).closest('tr').prevAll().length;//현재 클릭한 TR의 순서 return	
		
// 		$(<%=makeTableHTML.htmlTable_ID%>_rowID).removeClass("hene-bg-color");
// 		$(obj).attr("class", "hene-bg-color");
// // 		$(obj).attr("class", "bg-danger");
// // 		$(obj).attr("class", "bg-success"); 


    }  

    function Save_S101S030195(){
        var table_info = vTableS101S030195.page.info();
        var table_rows = table_info.recordsTotal;
    	for(var i=0;i<table_rows;i++){    		
//     		if($(this).is(":checked")) $("input:checkbox[id='chkBox']").is(":checked") ;

    		if($($("input:checkbox[id='checkbox1']")[i]).is(":checked") ){
    			console.log("input[id='checkbox1']=====" + i);
    			vTableS101S030190_info = vTableS101S030190.page.info();
				TableS101S030190_RowCount = vTableS101S030190_info.recordsTotal; 
    			vTableS101S030190.row.add( [
    				$('#txt_orderno').val(),
    				$('#txt_orderdetailseq').val(),
    				vTableS101S030195.cell(i , 18).data(),	//18 검사구분  
    				vTableS101S030195.cell(i , 19).data(),	//18 구분명  
    				'',										//   주문별체크번호, order_check_no
    				'',										//   revision_no    
    				vTableS101S030195.cell(i , 2).data(),	//1 제품코드           
    				vTableS101S030195.cell(i , 3).data(),	//2 제품명        
    				vTableS101S030195.cell(i ,10).data(),	//9 prod_cd_rev   
    				
    				vTableS101S030195.cell(i , 4).data(),	//3 체크코드       
    				vTableS101S030195.cell(i ,11).data(),	//0 checklist_seq    
    				vTableS101S030195.cell(i ,12).data(),	//1 checklist_cd_rev
    				
    				vTableS101S030195.cell(i , 5).data(),	//4 작업표준         
    				vTableS101S030195.cell(i , 7).data(),	//6 표준값   					 
    				vTableS101S030195.cell(i , 6).data(),	//5 체크내용  
   				 
    				'',	//1 order_check_seq
    				'<button style="width: auto; float: left; " type="button" onclick="fn_mius_body(this)" id="right_btn" class="btn-outline-success">삭제</button>'
    	        ] ).draw(true);
    		}
    	}
        
		vTableS101S030190_info = vTableS101S030190.page.info();
		TableS101S030190_RowCount = vTableS101S030190_info.recordsTotal;
        
        parent.$("#ReportNote_nd").children().remove();
    	parent.$('#modalReport_nd').hide();
    }
</script>
    <%=zhtml%>    
	<p style="text-align:center">
		<button id="btn_Save"  class="btn btn-info"  onclick="Save_S101S030195();">적용</button>
	    <button id="btn_Canc"  class="btn btn-info"  onclick="parent.$('#modalReport_nd').hide();">취소</button>
	</p>   

	