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
	MakeTableHTML makeTableHTML;
	String loginID = session.getAttribute("login_id").toString();
	String member_key = session.getAttribute("member_key").toString();
	String[] strColumnHead 	= { "주문번호","BOM코드", "BOM코드명","순번", "BOM명", 
								  "원부자재코드","규격", "수량", 
								"단가","금액","Rev","part_cd_rev"};
	int[]   colOff 			= { 0, 0,  0, 10, 12, 
								10,1,1,
								1,1,0,0};//전체 넓이 번튼 3개:86%, 문서2개:90%, 문서뷰:94%, 챠트보기,문서등록91%; 고객사

	String[] TR_Style		= {""," onclick='S202S010270Event(this)' "};
	String[] TD_Style		= {"align:center;font-weight: bold;"}; 
	String[] HyperLink		= {""}; 
	String RightButton[][]	= {{"off", "fn_Chart_View", rightbtnChartShow},{"off", "fn_Doc_Reg()", rightbtnDocSave},{"off", "fn_mius_body(this)", "삭제"}};
	
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
//     TableModel = new DoyosaeTableModel("M202S010100E224", strColumnHead, param);	
	TableModel = new DoyosaeTableModel("M202S010100E224", strColumnHead, jArray);
 	int RowCount =TableModel.getRowCount();	

 	CurrentPage jspPageName = new CurrentPage(request.getRequestURI());
 	String JSPpage = jspPageName.GetJSP_FileName();
 	
    makeTableHTML= new MakeTableHTML(TableModel);
    makeTableHTML.colCount		= strColumnHead.length;
    makeTableHTML.pageSize 		= RowCount;  //RowCount 1페이지로 구성,PageSize: PageSize의 사이즈로 구성 
    makeTableHTML.currentPageNum= 1;
    makeTableHTML.htmlTable_ID	= "TableS202S010270";
    makeTableHTML.colOff		= colOff;
    makeTableHTML.TR_Style 		= TR_Style;
    makeTableHTML.TD_Style 		= TD_Style; 
    makeTableHTML.HyperLink 	= HyperLink;makeTableHTML.user_id	= loginID;
    makeTableHTML.Check_Box 	= "true";
    makeTableHTML.RightButton	= RightButton; makeTableHTML.jsp_page	= JSPpage;
    String zhtml=makeTableHTML.getHTML();	
%>
<script>
	var S202S010270_Row;
	var vTableS202S010270;
    $(document).ready(function () {

	 vTableS202S010270 = $('#<%=makeTableHTML.htmlTable_ID%>').DataTable({
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
		    'createdRow': function(row) {	
	      		$(row).attr('id',"<%=makeTableHTML.htmlTable_ID%>_rowID");
	      		$(row).attr('onclick',"S202S010270Event(this)");
	      		$(row).attr('role',"row");
	  		},
	  		'columnDefs': [{
	       		'targets': [1,2,3,11,12],
	       		'createdCell':  function (td) {
	          			$(td).attr('style', 'width:0px; display: none;'); 
	       		}
			}],
			language: { 
	               url:"<%=Config.this_SERVER_path%>/AdminLTE-3.0.5/localisation/Korean.json"
	            }
		});

		
		$('#<%=makeTableHTML.htmlTable_ID%> tbody').on( 'click', 'tr', function () {
			S202S010270_Row = vTableS202S010270
		        .row( this )
		        .index();
	 		$(<%=makeTableHTML.htmlTable_ID%>_rowID).removeClass("hene-bg-color");		
	 		
	 		$($("input[id='checkbox1']")[S202S010270_Row]).prop("checked", function(){
				if($(this).prop('checked'))
					$(this).attr("checked", false);
				else
					$(this).attr("checked", true);
					
//			        return !$(this).prop('checked');
		    });   
	 		
			vTableS202S010270
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

			vTableS202S010270
	        .row( this )
		    .nodes()
		    .to$()
		    .attr("class", "hene-bg-color_w");
		} );
    });

    function S202S010270Event(obj){
    	var tr = $(obj);
		var td = tr.children();
		var trNum = $(obj).closest('tr').prevAll().length;//현재 클릭한 TR의 순서 return			
		
<%--  		$(<%=makeTableHTML.htmlTable_ID%>_rowID).attr("class", ""); --%>
// 		$(obj).attr("class", "hene-bg-color");
    }   

    function Save_S202S010270(){
        var table_info = vTableS202S010270.page.info();
        var table_rows = table_info.recordsTotal;
    	for(var i=0;i<table_rows;i++){
    		var trInput = $($("#<%=makeTableHTML.htmlTable_ID%>_tbody tr")[i]).find(":input")
    		if($(trInput.eq(0)).is(":checked") ){
//     			{"주문번호","발주번호", "순번", "자료명",  "자료번호", "원부자재번호",  "파트코드","규격", "수량", "단가","금액","Rev","part_cd_rev",""};
    			vTableS202S010250_info = vTableS202S010250.page.info();
				TableS202S010250_RowCount = vTableS202S010250_info.recordsTotal;
    			vTableS202S010250.row.add( [
    				vTableS202S010270.cell(i , 1).data(),	//0 주문번호
    				''									,	//1 발주번호
    				vTableS202S010270.cell(i , 4).data(),	//2 순번
    				vTableS202S010270.cell(i , 5).data(),	//3 자료명
    				vTableS202S010270.cell(i , 2).data(),	//4 BOM번호
    				vTableS202S010270.cell(i , 6).data(),	//6 파트코드
    				vTableS202S010270.cell(i , 7).data(),	//7 규격
    				vTableS202S010270.cell(i , 8).data(),	//8 수량
    				vTableS202S010270.cell(i , 9).data(),	//9 단가
    				vTableS202S010270.cell(i , 10).data(),	//0 금액
    				vTableS202S010270.cell(i , 11).data(),	//1 rev
    				vTableS202S010270.cell(i , 12).data(),	//2 part_cd_rev    				
    				'<button style="width: auto; float: left; " type="button" onclick="fn_mius_body(this)" id="right_btn" class="btn-outline-success">삭제</button>'
    	        ] );
    		}
    	}
    	vTableS202S010250.draw(true);
		vTableS202S010250_info = vTableS202S010250.page.info();
		TableS202S010250_RowCount = vTableS202S010250_info.recordsTotal;
        $('#txt_seq').val( TableS202S010250_RowCount + 1);
        
        parent.$("#ReportNote_nd").children().remove();
    	parent.$('#modalReport_nd').hide();
    }
</script>

    <%=zhtml%>  
    
	<p style="text-align:center">
		<button id="btn_Save"  class="btn btn-info"  onclick="Save_S202S010270();">적용</button>
	    <button id="btn_Canc"  class="btn btn-info"  onclick="parent.$('#modalReport_nd').hide();">취소</button>
	</p>