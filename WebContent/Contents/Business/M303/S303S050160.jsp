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
	
	int startPageNo = 1;//Integer.parseInt(request.getParameter("CurrentPageNumber").toString().trim());

	String[] strColumnHead 	= { "order_detail_seq","order_no","주문확인번호", "revision_no", "qar",
								"spec_approval","spec_approval_rev","std_dwg","std_dwg_rev", "program_rev",
								"program_rev_rev","job_guide","job_guide_rev","공정번호", "proc_rev",
								"공정명","품질공정번호","q_proc_rev","품질공정명","checklist_cd",
								"checklist_seq", "checklist_rev","작업표준","공구","관리항목",
								"표준값", "결과값","create_date","user_id","project_name",
								"product_serial_no","prod_cd","product_nm","lotno","lot_count" };
	int[] colOff 			= { 0, 0, 1, 0, 0,
								0, 0, 0, 0, 0,
								0, 0, 0, 1, 0, 
								1, 1, 0, 1, 0, 
								0, 0, 1, 1, 1, 
								1, 1, 0, 0, 0,
								0, 0, 0, 0, 0 };
	String[] TR_Style		= {""," onclick='S303S050160TrEvent(this)' "};
	String[] TD_Style		= {"align:center;font-weight: bold;"};  //strColumnHead의 수만큼
	String[] HyperLink		= {"",""}; //strColumnHead의 수만큼
	String RightButton[][]	= {{"off", "fn_Chart_View", rightbtnChartShow},{"off", "fn_Doc_Reg()", rightbtnDocSave},{"off", "pop_fn_work_start(this)", "생산시작"}};

	String Fromdate="",Todate="",custCode="", GV_PROCESS_STATUS="", GV_JSPPAGE;
	String GV_ORDER_NO="", GV_ORDER_DETAIL_SEQ="",GV_PROC_CD="",GV_PROC_CD_REV="",GV_LOTNO="", GV_PRODUCT_SERIAL_NO="";

	if(request.getParameter("OrderNo")== null)
		GV_ORDER_NO = "";
	else
		GV_ORDER_NO = request.getParameter("OrderNo");	
	
	if(request.getParameter("order_detail_seq")== null)
		GV_ORDER_DETAIL_SEQ="";
	else
		GV_ORDER_DETAIL_SEQ = request.getParameter("order_detail_seq");
	
	if(request.getParameter("proc_cd")== null)
		GV_PROC_CD = "";
	else
		GV_PROC_CD = request.getParameter("proc_cd");	
	
	if(request.getParameter("proc_cd_rev")== null)
		GV_PROC_CD_REV="";
	else
		GV_PROC_CD_REV = request.getParameter("proc_cd_rev");
	
	
	if(request.getParameter("JSPpage")== null)
		GV_JSPPAGE="";
	else
		GV_JSPPAGE = request.getParameter("JSPpage");
	
	if(request.getParameter("lotno")== null) 
		GV_LOTNO="";
	else 
		GV_LOTNO = request.getParameter("lotno");
	
	if(request.getParameter("product_serial_no")== null) 
		GV_PRODUCT_SERIAL_NO="";
	else 
		GV_PRODUCT_SERIAL_NO = request.getParameter("product_serial_no");
		
	String param = GV_ORDER_NO + "|" + GV_ORDER_DETAIL_SEQ + "|"
			 	 + GV_PROC_CD + "|" + GV_PROC_CD_REV + "|" 
			 	 + GV_LOTNO + "|" + GV_PRODUCT_SERIAL_NO + "|" + member_key + "|";
	
	JSONObject jArray = new JSONObject();
	jArray.put( "order_no", GV_ORDER_NO);
	jArray.put( "detail_seq", GV_ORDER_DETAIL_SEQ);
	jArray.put( "proc_cd", GV_PROC_CD);
	jArray.put( "proc_cd_rev", GV_PROC_CD_REV);
	jArray.put( "lotno", GV_LOTNO);
	jArray.put( "product_serial_no", GV_PRODUCT_SERIAL_NO);
	jArray.put( "member_key", member_key);	
	
	TableModel = new DoyosaeTableModel("M303S050100E184", strColumnHead, jArray);
 	int RowCount =TableModel.getRowCount();	
    int colspanCount =TableModel.getColumnCount();


 	CurrentPage jspPageName = new CurrentPage(request.getRequestURI());
 	String JSPpage = jspPageName.GetJSP_FileName();
 	
    makeTableHTML= new MakeTableHTML(TableModel);
    makeTableHTML.colCount		= strColumnHead.length;
    makeTableHTML.pageSize 		= RowCount;
    makeTableHTML.currentPageNum= startPageNo;
    makeTableHTML.htmlTable_ID	= "TableS303S050160";
    makeTableHTML.colOff		= colOff;
    makeTableHTML.TR_Style 		= TR_Style;
    makeTableHTML.TD_Style 		= TD_Style; 
    makeTableHTML.HyperLink 	= HyperLink;makeTableHTML.user_id	= loginID;
    makeTableHTML.Check_Box 	= "false";
    makeTableHTML.RightButton	= RightButton; makeTableHTML.jsp_page	= JSPpage;
//     makeTableHTML.MAX_HEIGHT	= "height:250px";
    String zhtml=makeTableHTML.getHTML();
%>
    
<script>
	$(document).ready(function () {
    	$('#<%=makeTableHTML.htmlTable_ID%>').DataTable({	    
    		scrollX: true,
//     		scrollY: 180,
    	    scrollCollapse: true,
    	    paging: true,
    	    lengthMenu: [[5,9,-1], [5,9,"All"]],
    	    searching: false,
    	    ordering: true,
    	    order: [ 13, "asc" ],
    	    info: false,         
            language: { 
                url:"<%=Config.this_SERVER_path%>/AdminLTE-3.0.5/localisation/Korean.json"
             }
		});

    	<%if(RowCount>0){%>		
    	$('#txt_project_name').val('<%=TableModel.getValueAt(0,29).toString()%>');
		$('#txt_product_serial_no').val('<%=TableModel.getValueAt(0,30).toString()%>');
		$('#txt_product_code').val('<%=TableModel.getValueAt(0,31).toString()%>');
		$('#txt_productname').val('<%=TableModel.getValueAt(0,32).toString()%>');
		$('#txt_lotno').val('<%=TableModel.getValueAt(0,33).toString()%>');
		$('#txt_lot_count').val('<%=TableModel.getValueAt(0,34).toString()%>');
		$('#txt_qar').val('<%=TableModel.getValueAt(0,4).toString()%>');
		$('#txt_spec_approval_name').val('<%=TableModel.getValueAt(0,5).toString()%>');
		$('#txt_std_dwg_name').val('<%=TableModel.getValueAt(0,7).toString()%>');
		$('#txt_job_guide_name').val('<%=TableModel.getValueAt(0,11).toString()%>');
		$('#txt_program_rev').val('<%=TableModel.getValueAt(0,9).toString()%>');
		<%}%>
	});

	function S303S050160TrEvent(obj){
		var tr = $(obj);
		var td = tr.children();

		var trNum = $(obj).closest('tr').prevAll().length;//현재 클릭한 TR의 순서 return
		
		
		$(<%=makeTableHTML.htmlTable_ID%>_rowID).attr("class", "");
		$(obj).attr("class", "hene-bg-color");
// 		$(obj).attr("class", "bg-success");


	}


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
	            <td style=" font-weight: 900; font-size:14px; text-align:left;vertical-align: middle">일련번호</td>
	            <td style=" font-weight: 900; font-size:14px; text-align:left; tmargin-left:10px;">
					<input type="text" class="form-control" id="txt_product_serial_no" style="width: 60%;" readonly/>
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
                    	<button id="btn_Canc"  class="btn btn-info" style="width: 100px" onclick="parent.$('#modalReport').hide();">닫기</button>
	            </td>	            
	        </tr>
	    </table>
	</div>
