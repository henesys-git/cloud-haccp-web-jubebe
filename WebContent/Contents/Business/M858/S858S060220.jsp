<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="mes.client.comm.*" %>
<%@ page import="mes.client.guiComponents.*" %>
<%@ page import="mes.client.util.*" %>
<%@ page import="mes.client.conf.*" %>
<%@ page import="org.json.simple.*"%><%@ include file="/strings.jsp" %>
<%
	DoyosaeTableModel TableModel;
	MakeTableHTML makeTableHTML;
	String loginID = session.getAttribute("login_id").toString();
	String member_key = session.getAttribute("member_key").toString();

	String[] strColumnHead 	= {"제품명","제품코드","prod_cd_rev","revision_no","입고전재고","창고","렉","선반","칸"};
	int[]   colOff 			= {1,1,0,0,0,0,0,0,0};//전체 넓이 번튼 3개:86%, 문서2개:90%, 문서뷰:94%, 챠트보기,문서등록91%; 고객사

	String[] TR_Style		= {"",""};
// 	String[] TR_Style		= {""," onclick='S202S020120Event(this)' "};
	String[] TD_Style		= {"align:center;font-weight: bold;"}; 
	String[] HyperLink		= {""}; 
	String RightButton[][]	= {{"off", "fn_Chart_View", rightbtnChartShow},{"off", "fn_Doc_Reg()", rightbtnDocSave},{"off", "fn_mius_body(this)", "삭제"}};
	
	String GV_PROD_CD="",GV_ORDER_NO="",GV_PROD_CD_REV;

	if(request.getParameter("order_no")== null)
		GV_ORDER_NO="";
	else
		GV_ORDER_NO = request.getParameter("order_no");	
	
	if(request.getParameter("prod_cd")== null)
		GV_PROD_CD="";
	else
		GV_PROD_CD = request.getParameter("prod_cd");	
	
	if(request.getParameter("prod_cd_rev")== null)
		GV_PROD_CD_REV="";
	else
		GV_PROD_CD_REV = request.getParameter("prod_cd_rev");
		
	String param = GV_ORDER_NO + "|" + GV_PROD_CD + "|" + GV_PROD_CD_REV + "|";
	
	JSONObject jArray = new JSONObject();
	jArray.put( "member_key", member_key);
	jArray.put( "order_no", GV_ORDER_NO);
	jArray.put( "prod_cd", GV_PROD_CD);
	jArray.put( "prod_cd_rev", GV_PROD_CD_REV);
		
    TableModel = new DoyosaeTableModel("M858S060100E224", strColumnHead, jArray);	
 	int RowCount =TableModel.getRowCount();	

 	CurrentPage jspPageName = new CurrentPage(request.getRequestURI());
 	String JSPpage = jspPageName.GetJSP_FileName();
 	
    makeTableHTML= new MakeTableHTML(TableModel);
    makeTableHTML.colCount		= strColumnHead.length;
    makeTableHTML.pageSize 		= RowCount;  //RowCount 1페이지로 구성,PageSize: PageSize의 사이즈로 구성 
    makeTableHTML.currentPageNum= 1;
    makeTableHTML.htmlTable_ID	= "TableS858S060220";
    makeTableHTML.colOff		= colOff;
    makeTableHTML.TR_Style 		= TR_Style;
    makeTableHTML.TD_Style 		= TD_Style; 
    makeTableHTML.HyperLink 	= HyperLink;makeTableHTML.user_id	= loginID;
    makeTableHTML.Check_Box 	= "false";
    makeTableHTML.RightButton	= RightButton; makeTableHTML.jsp_page	= JSPpage;
    String zhtml=makeTableHTML.getHTML();	
%>
<script>
    $(document).ready(function () {
		
		vTableS858S060220 = $('#<%=makeTableHTML.htmlTable_ID%>').DataTable({
			scrollX: true,
		    scrollY: 340,
		    scrollCollapse: true,
		    paging: false,
// 		    lengthMenu: [[8,9,-1], [8,9,"All"]],
		    searching: false,
		    ordering: true,
		    order: [[ 1, "asc" ]],
		    keys: false,
		    info: true,
		    'createdRow': function(row) {	
	      		$(row).attr('id',"<%=makeTableHTML.htmlTable_ID%>_rowID");
// 	      		$(row).attr('onclick',"S202S010120Event(this)");
	      		$(row).attr('role',"row");
	  		},
	  		'columnDefs': [{
	       		'targets': [2,3,4,5,6,7,8],
	       		'createdCell':  function (td) {
	          			$(td).attr('style', 'width:0px; display: none;'); 
	       		}
			}],
			language: { 
	               url:"<%=Config.this_SERVER_path%>/AdminLTE-3.0.5/localisation/Korean.json"
	            }
		});

	
		$('#<%=makeTableHTML.htmlTable_ID%> tbody').on( 'click', 'tr', function () {
			S858S060220_Row_index = vTableS858S060220
		        .row( this )
		        .index();
			
			
// 			$($("input[id='checkbox1']")[S202S010120_Row_index]).prop("checked", function(){
// 		        return !$(this).prop('checked');
// 		    });

	 		$(<%=makeTableHTML.htmlTable_ID%>_rowID).removeClass("hene-bg-color");
			vTableS858S060220.row(this)
		    .nodes()
		    .to$()
		    .attr("class","hene-bg-color");
			clear_input();
	
			$('#txt_prod_name').val(vTableS858S060220.cell(S858S060220_Row_index, 0).data());		//7 제품명
			$('#txt_prod_cd').val(vTableS858S060220.cell(S858S060220_Row_index, 1).data());		//6 파트코드
			$('#txt_prod_cd_rev').val(vTableS858S060220.cell(S858S060220_Row_index, 2).data());		//6 파트코드
			$('#txt_pre_amt').val(vTableS858S060220.cell(S858S060220_Row_index, 4).data());		//14 입고전재고
			$('#txt_store_no').val(vTableS858S060220.cell(S858S060220_Row_index, 5).data());
			$('#txt_rakes_no').val(vTableS858S060220.cell(S858S060220_Row_index, 6).data());
			$('#txt_plate_no').val(vTableS858S060220.cell(S858S060220_Row_index, 7).data());
			$('#txt_colm_no').val(vTableS858S060220.cell(S858S060220_Row_index, 8).data());
			
			if($("#txt_pre_amt").val()==""){$("#txt_pre_amt").val(0);}
	    	var pre_amt = parseInt($("#txt_pre_amt").val());
	    	var io_amt = parseInt($("#txt_io_amt").val());
	    	$('#txt_post_amt').val(pre_amt - io_amt);
			
			$('#btn_plus').html("입력");
			S858S060230_Row_index=-1; 
			
		} );
		        

		$('#<%=makeTableHTML.htmlTable_ID%> tbody').on( 'blur', 'tr', function () {
			vTableS858S060220.row(this)
		    .nodes()
		    .to$()
		    .attr("class", "hene-bg-color_w");
		} );


	    $('#txt_seq').val( '<%=(RowCount+1)%>');
    });

    function S858S060220Event(obj){
    	var tr = $(obj);
		var td = tr.children();
		var trNum = $(obj).closest('tr').prevAll().length;//현재 클릭한 TR의 순서 return	
		
// 		$(<%=makeTableHTML.htmlTable_ID%>_rowID).attr("class", "");
// 		$(obj).attr("class", "hene-bg-color");

// 		$('#txt_seq').val(td.eq(0).text().trim());



    }        
</script>

    <%=zhtml%>  