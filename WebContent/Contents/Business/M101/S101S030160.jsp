<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="mes.client.comm.*" %>
<%@ page import="mes.client.common.*" %>
<%@ page import="mes.client.guiComponents.*" %>
<%@ page import="mes.client.util.*" %>
<%@ page import="mes.client.conf.*" %>
<%@ page import="org.json.simple.*"%><%@ include file="/strings.jsp" %>
<!DOCTYPE html>
<!-- <html xmlns="http://www.w3.org/1999/xhtml"> -->
<%-- <jsp:include page="../../Common/linkcss_js.jsp" flush="false"/> --%>
<!-- <head id="Head1" > -->
<%
/*
	S101S030160.jsp : 공정확인표(하단 TAB에서 POP UP으로 뜸)
*/

	DoyosaeTableModel TableModel;
	MakeTableHTML makeTableHTML; 
	String loginID = session.getAttribute("login_id").toString();
	String member_key = session.getAttribute("member_key").toString();
	String[] strColumnHead 	= {"orderNo","순번", "주문명", "일련번호", "품번", "품명", "LOT번호", "LOT수량",
			 "QAR", "사양승인원", "규격도면", "작업지도서", "프로그램 Rev", "공정번호", "공정명", "관련부서", "작업표준", 
			 "표준값", "공구", "관리항목", "체크항목유형", "비고","checklist_cd","checklist_seq"};
	int[] colOff 	=  {0,1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1,0,0};
	String[] TR_Style		= {""," onclick='S101S030160Event(this)' "};
	String[] TD_Style		= {"align:center;font-weight: bold;"}; 
	String[] HyperLink		= {""}; 
	String RightButton[][]	= {{"off", "fn_Chart_View", rightbtnChartShow},{"off", "fn_Doc_Reg()", rightbtnDocSave},{"off", "fn_mius_body(this)", "삭제"}};
	
	String GV_ORDER_NO="",GV_ORDER_DETAIL_SEQ="", GV_PROD_CD="", GV_PRODUCT_NAME="",GV_PROJECT_NAME="";
	String GV_LOT_NO="", GV_PROD_SERIAL_NO="", GV_LOT_COUNT="" ;
	String OrderDetailNo="";
	
	if(request.getParameter("order_detail_seq")== null)
		GV_ORDER_DETAIL_SEQ="";
	else
		GV_ORDER_DETAIL_SEQ = request.getParameter("order_detail_seq");
	
	if(request.getParameter("OrderNo")== null)
		GV_ORDER_NO="";
	else
		GV_ORDER_NO = request.getParameter("OrderNo");
	
	if(request.getParameter("Project_name")== null)
		GV_PROJECT_NAME="";
	else
		GV_PROJECT_NAME = request.getParameter("Project_name");
	
	if(request.getParameter("Prod_serial_no")== null)
		GV_PROD_SERIAL_NO="";
	else
		GV_PROD_SERIAL_NO = request.getParameter("Prod_serial_no");
	
	if(request.getParameter("Prod_cd")== null)
		GV_PROD_CD="";
	else
		GV_PROD_CD = request.getParameter("Prod_cd");
	
	if(request.getParameter("Product_name")== null)
		GV_PRODUCT_NAME="";
	else
		GV_PRODUCT_NAME = request.getParameter("Product_name");

	if(request.getParameter("lotno")== null)
		GV_LOT_NO="";
	else
		GV_LOT_NO = request.getParameter("lotno");

	if(request.getParameter("lot_count")== null)
		GV_LOT_COUNT="";
	else
		GV_LOT_COUNT = request.getParameter("lot_count");

	String param= GV_ORDER_NO + "|" + GV_ORDER_DETAIL_SEQ + "|" + GV_LOT_NO + "|";
	
	JSONObject jArray = new JSONObject();
	jArray.put( "order_no", GV_ORDER_NO);
	jArray.put( "lot_no", GV_LOT_NO);
	jArray.put( "member_key", member_key);
			
    TableModel = new DoyosaeTableModel("M101S030100E164", strColumnHead, jArray);
 	int RowCount =TableModel.getRowCount();	


 	CurrentPage jspPageName = new CurrentPage(request.getRequestURI());
 	String JSPpage = jspPageName.GetJSP_FileName();
 	
    makeTableHTML= new MakeTableHTML(TableModel);
    makeTableHTML.colCount		= strColumnHead.length;
    makeTableHTML.pageSize 		= RowCount;  //RowCount 1페이지로 구성,PageSize: PageSize의 사이즈로 구성 
    makeTableHTML.currentPageNum= 1;
    makeTableHTML.htmlTable_ID	= "TableS101S030160";
    makeTableHTML.colOff		= colOff;
    makeTableHTML.TR_Style 		= TR_Style;
    makeTableHTML.TD_Style 		= TD_Style; 
    makeTableHTML.HyperLink 	= HyperLink;makeTableHTML.user_id	= loginID;
    makeTableHTML.Check_Box 	= "false";
    makeTableHTML.RightButton	= RightButton; makeTableHTML.jsp_page	= JSPpage;
    
    String zhtml=makeTableHTML.getHTML(); 	
// 	ProcesStatusCheck prcStatusCheck = new ProcesStatusCheck(JSPpage+"|"+"ODPROCS"+"|");
// 	String GV_GET_NUM_PREFIX = prcStatusCheck.GV_PROCESS_NUMBER_GUBUN;
%>
    
    <script type="text/javascript">
    
    $(document).ready(function () {

    	var SELECT_ON_DATA_Row_Index;
    	var vSELECT_ON_DATA;
    	var Rowcount='<%=RowCount%>';

   		vSELECT_ON_DATA = $('#<%=makeTableHTML.htmlTable_ID%>').DataTable({
   			scrollX: true,
//     		    scrollY: 380,
   		    scrollCollapse: true,
   		    paging: true,
   		    lengthMenu: [[5,9,-1], [5,9,"All"]],
   		    searching: true,
   		    ordering: true,
   		    order: [[ 0, "asc" ],[ 12, "asc" ],[ 2, "asc" ]],
   		    keys: false,
   		    info: true,
   		    'createdRow': function(row) {	
   	      		$(row).attr('id',"<%=makeTableHTML.htmlTable_ID%>_rowID");
  	      		$(row).attr('role',"row");
   	  		},
   	  		'columnDefs': [
   	  			{
	   	       		'targets': [0,2,3,4,5,6,7,8,9,10,11,12,22,23],
	   	       		'createdCell':  function (td) {
	   	          			$(td).attr('style', 'width:0px; display: none;'); 
	   	       		}
	   			},
	   			{
	   	       		'targets': 16,
	   	       		'createdCell':  function (td) {
	   	          			$(td).attr('style', 'width:30%;'); 
	   	       		}
				}
   	  		],         
            language: { 
                url:"<%=Config.this_SERVER_path%>/AdminLTE-3.0.5/localisation/Korean.json"
             }
   		});
		
//    		$('#PrintTable').DataTable({
//     	    dom: 'Bfrtip',
//             buttons: [
                
//                 {
//                     extend: 'print',
<%--                     title: "공정확인표(주문번호:<%=GV_ORDER_NO%> <%=GV_PRODUCT_NAME%>)", --%>
//                     messageBottom: null
//                 }
//             ]
//    		});
   	
    	
		<%if(RowCount>0){%>		
			$('#txt_project_name').val('<%=TableModel.getValueAt(0,2).toString()%>');
			$('#txt_product_serial_no').val('<%=TableModel.getValueAt(0,3).toString()%>');
			$('#txt_product_code').val('<%=TableModel.getValueAt(0,4).toString()%>');
			$('#txt_productname').val('<%=TableModel.getValueAt(0,5).toString()%>');
			
			$('#txt_lotno').val('<%=TableModel.getValueAt(0,6).toString()%>');
			$('#txt_lot_count').val('<%=TableModel.getValueAt(0,7).toString()%>');
			$('#txt_qar').val('<%=TableModel.getValueAt(0,8).toString()%>');
			$('#txt_spec_approval_name').val('<%=TableModel.getValueAt(0,9).toString()%>');
			$('#txt_std_dwg_name').val('<%=TableModel.getValueAt(0,10).toString()%>');
	
			$('#txt_job_guide_name').val('<%=TableModel.getValueAt(0,11).toString()%>');
			$('#txt_program_rev').val('<%=TableModel.getValueAt(0,12).toString()%>');
		<%}%>
// 		$.ajax({
//             type: "POST",
<%-- 	         url: "<%=Config.this_SERVER_path%>/Contents/Business/M101/S101S030180.jsp",  --%>
<%--             data: "OrderNo=" + '<%=GV_ORDER_NO%>' , --%>
//             beforeSend: function () {
//                 $("#bom_tbody").children().remove();
//             },
//             success: function (html) {           	 
//       			$("#bom_tbody").hide().html(html).fadeIn(100);

//             },
//             error: function (xhr, option, error) {

//             }
//         });
				

    });
	
</script>
	<div style="width: 100%;  text-align:center;vertical-align: middle">
		<table class="table table-striped " style="width: 90%; margin: 0 ; text-align:center" id=PrintTable>
			<thead><tr><td></td></tr></thead>
			<tbody>
			<tr><td>
        <table class="table table-striped " style="width: 90%; margin: 0 ; text-align:center">	        
  			<tr>
	            <td style="width: 6%;  font-weight: 900; font-size:14px; text-align:left;vertical-align: middle">주문명</td>
	            <td colspan="3" style="width: 44%;  font-weight: 900; font-size:14px; text-align:lef; tmargin-left:10px;">
					<input type="text" class="form-control" id="txt_project_name" style="width: 45%;float:left;" readonly />
					<input type="hidden" class="form-control" id="txt_orderno"  />
					<input type="hidden" class="form-control" id="txt_orderdetailseq" />
					<input type="hidden" class="form-control" id="txt_num_prefix" />
	           	</td>
<!-- 	            <td style=" font-weight: 900; font-size:14px; text-align:left;vertical-align: middle">일련번호</td> -->
	            <td style=" font-weight: 900; font-size:14px; text-align:left;vertical-align: middle"></td>
	            <td style=" font-weight: 900; font-size:14px; text-align:left; tmargin-left:10px;">
<!-- 					<input type="text" class="form-control" id="txt_product_serial_no" style="width: 60%;" readonly/> -->
					<input type="hidden" class="form-control" id="txt_product_serial_no" style="width: 60%;" readonly/>
	           	</td>	           		           
	            <td style=" font-weight: 900; font-size:14px; text-align:left;vertical-align: middle"></td>
	            <td style=" font-weight: 900; font-size:14px; text-align:left; tmargin-left:10px;">
	           	</td>
	    	</tr>
  			<tr>
	            <td style="width: 6%;  font-weight: 900; font-size:14px; text-align:left;vertical-align: middle">품번</td>
	            <td style="width: 19%; font-weight: 900; font-size:14px; text-align:left">
					<input type="text" class="form-control" id="txt_product_code" style="width: 60%;" readonly/>
					<input type="hidden" class="form-control" id="txt_prod_rev"  readonly/>					
	           	</td>	   	           
				<td style="width: 6.5%;  font-weight: 900; font-size:14px; text-align:left;vertical-align: middle">품명</td>
	            <td style="width: 18.5%; font-weight: 900; font-size:14px; text-align:left">
					<input type="text" class="form-control" id="txt_productname"  readonly/>
	           	</td>         
	           	<td style="width: 6%;  font-weight: 900; font-size:14px; text-align:left;vertical-align: middle">LOT번호</td>
	            <td style="width: 19%; font-weight: 900; font-size:14px; text-align:left">
					<input type="text" class="form-control" id="txt_lotno"  style="width: 60%;" readonly/>
	           	</td>
	            <td style="width: 6.5%;  font-weight: 900; font-size:14px; text-align:left;vertical-align: middle">LOT 수량</td>
	            <td style="width: 18.5%; font-weight: 900; font-size:14px; text-align:left">
					<input type="text" class="form-control" id="txt_lot_count" style="width: 60%;";  readonly/>					
	           	</td>
	        </tr>
	        <tr>
	            <td style=" font-weight: 900; font-size:14px; text-align:left ;vertical-align: middle">QAR</td>
	            <td style=" tmargin-left:10px;">
					<input type="text" class="form-control" id="txt_qar" style="width: 60%;" readonly/>
	            </td>
	            <td style=" font-weight: 900; font-size:14px; text-align:left;vertical-align: middle">사양승인원</td> <!-- tbi_order_doclist 선택 -->
	            <td style=" tmargin-left:10px;"> 
	            	<input type="text"  	id="txt_spec_approval_name" class="form-control" style="width: 60%;float:left;" readonly/> <!-- file_view_name -->
	            	<input type="hidden"  	id="txt_spec_approval"  />
	            	<input type="hidden"  	id="txt_spec_approval_rev" />
<%-- 	            	<button type="button" 	onclick="parent.pop_fn_Oder_Doc_View(1,0,'<%=GV_ORDER_NO%>')" id="btn_SearchPart" --%>
<!-- 	            	    class="form-control btn btn-info" style="width:20%;float:left;">검색</button> -->
	            </td>
	            <td style=" font-weight: 900; font-size:14px; text-align:left ;vertical-align: middle">규격도면</td><!-- tbi_order_doclist 선택 -->
	            <td style=" tmargin-left:10px;">
	            	<input type="text"  	id="txt_std_dwg_name" class="form-control" style="width: 60%;float:left;" readonly/> <!-- file_view_name -->
					<input type="hidden" 	id="txt_std_dwg"  />
					<input type="hidden" 	id="txt_std_dwg_rev"   />
<%-- 					<button type="button" 	onclick="parent.pop_fn_Oder_Doc_View(1,1,'<%=GV_ORDER_NO%>')" id="btn_SearchPart"  --%>
<!-- 					class="form-control btn btn-info" style="width:20%;float:left;">검색</button> -->
	            </td>
	            <td style=" font-weight: 900; font-size:14px; text-align:left;vertical-align: middle">작업지도서</td><!-- tbi_order_doclist 선택 -->
	            <td style=" tmargin-left:10px;"> 
	            	<input type="text"  	id="txt_job_guide_name" class="form-control" style="width: 60%;float:left;" readonly/>
	            	<input type="hidden"  	id="txt_job_guide"  />
	            	<input type="hidden"  	id="txt_job_guide_rev"  />
<%-- 	            	<button type="button" 	onclick="parent.pop_fn_Oder_Doc_View(1,2,'<%=GV_ORDER_NO%>')" id="btn_SearchPart"  --%>
<!-- 	            	class="form-control btn btn-info" style="width:20%;float:left;">검색</button> -->
	            </td>	        
	        </tr>
	        <tr>
	            <td style=" font-weight: 900; font-size:14px; text-align:left ;vertical-align: middle" colspan="5">
	            <labal style="float:left; margin-right:10px;">프로그램 Rev. </labal><input type="text" class="form-control" id="txt_program_rev" style="width: 60%;float:left;" readonly/></td>
	            <td></td> 
	            <td></td>  
	            <td></td>    
	        </tr>	        
       	</table>
       	
        <div id="bom_tbody">

    	<%=zhtml%>     
        </div>
        </td></tr></tbody>
	    </table>
        
        <table class="table table-bordered " style="width: 100%; margin: 0 ; align:center" id="bom_table">
	        <tr style="vertical-align: middle">
	            <td style="width:  100%; font-weight: 900; font-size:14px; text-align:center; vertical-align: middle">
                    	<button id="btn_Canc"  class="btn btn-info" style="width: 100px" onclick="parent.$('#modalReport2').hide();">닫기</button>
	            </td>	            
	        </tr>
	    </table>
	</div>