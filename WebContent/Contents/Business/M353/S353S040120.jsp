<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="mes.client.comm.*" %>
<%@ page import="mes.client.guiComponents.*" %>
<%@ page import="mes.client.util.*" %>
<%@ page import="mes.client.conf.*" %>
<%@ page import="org.json.simple.*"%><%@ include file="/strings.jsp" %>
<%

	
	String loginID = session.getAttribute("login_id").toString();
	String member_key = session.getAttribute("member_key").toString();

	DoyosaeTableModel TableModel;
	MakeGridData makeGridData;
	String param = "";
	int startPageNo = 1;
// 	Integer.parseInt(request.getParameter("CurrentPageNumber").toString().trim());
		
// 	final int PageSize=15; 

	String GV_ORDERNO="", GV_LOTNO="",
			GV_BOM_CD="", GV_BOM_CD_REV="";
	
	if(request.getParameter("order_no")== null)
		GV_ORDERNO = "";
	else
		GV_ORDERNO = request.getParameter("order_no");	
	
	if(request.getParameter("lotno")== null)
		GV_LOTNO = "";
	else
		GV_LOTNO = request.getParameter("lotno");	
	
	if(request.getParameter("bom_cd")== null)
		GV_BOM_CD = "";
	else
		GV_BOM_CD = request.getParameter("bom_cd");
	
	if(request.getParameter("bom_cd_rev")== null)
		GV_BOM_CD_REV = "";
	else
		GV_BOM_CD_REV = request.getParameter("bom_cd_rev");

	JSONObject jArray = new JSONObject();
	jArray.put( "order_no", GV_ORDERNO);
	jArray.put( "lotno", GV_LOTNO);
	jArray.put( "bom_cd", GV_BOM_CD);
	jArray.put( "bom_cd_rev", GV_BOM_CD_REV);
	jArray.put( "member_key", member_key);
		
    TableModel = new DoyosaeTableModel("M353S020100E105",  jArray);	
 	int RowCount =TableModel.getRowCount();

    
 	CurrentPage jspPageName = new CurrentPage(request.getRequestURI());
 	String JSPpage = jspPageName.GetJSP_FileName();
 	
    makeGridData= new MakeGridData(TableModel);
	String RightButton[][]	= {{"off", "fn_Chart_View", rightbtnChartShow},{"off", "fn_Doc_Reg()", rightbtnDocSave},{"off", "file_real_name", rightbtnDocShow}};
 	makeGridData.RightButton	= RightButton;
 	
    makeGridData.htmlTable_ID	= "tableS353S020120";
    
 	makeGridData.Check_Box 	= "false";
 	String[] HyperLink		= {""}; //strColumnHead의 수만큼
 	makeGridData.HyperLink 	= HyperLink;
%>
    
<script>
$(document).ready(function () {
	$('#<%=makeGridData.htmlTable_ID%>').DataTable({	
		scrollX: true,
		scrollY: 200,
	    scrollCollapse: true,
	    paging: false,
	    searching: false,
	    ordering: false,
	    order: [[ 0, "asc" ]],
	    info: false,
		data: <%=makeGridData.getDataArry()%>,

	    'createdRow': function(row) {	
      		$(row).attr('id',"<%=makeGridData.htmlTable_ID%>_rowID");
      		$(row).attr('onclick',"<%=makeGridData.htmlTable_ID%>Event(this)");
      		$(row).attr('role',"row");
  		},    
  		'columnDefs': [{
       		'targets': [0,1,2,3,4,5,6,7,8,9,10,11,13,14,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34],
       		'createdCell':  function (td) {
          			$(td).attr('style', 'display: none;'); 
       		}
		}
		], 
	    language: { 
            url:"<%=Config.this_SERVER_path%>/AdminLTE-3.0.5/localisation/Korean.json"
         }
	});
});

function <%=makeGridData.htmlTable_ID%>Event(obj){
	tr = $(obj);
	td = tr.children();
	trNum = $(obj).closest('tr').prevAll().length;//현재 클릭한 TR의 순서 return
	
	$(<%=makeGridData.htmlTable_ID%>_rowID).attr("class", "");
	$(obj).attr("class", "hene-bg-color");

//  vLotNo = td.eq(1).text().trim();
// 	vRevisionNo = td.eq(2).text().trim();
// 	vBomCd =td.eq(3).text().trim();
// 	vBomCdRev = td.eq(4).text().trim();
// 	vLastNo = td.eq(5).text().trim();
// 	vSysBomId = td.eq(6).text().trim();
// 	vTypeNo = td.eq(7).text().trim();
// 	vgeukyongpoommok = td.eq(8).text().trim();
// 	vDeptCode = td.eq(9).text().trim();
// 	vApprovalDate = td.eq(10).text().trim();
// 	vApproval = td.eq(11).text().trim();
// 	vPartCd = td.eq(12).text().trim();
// 	vPartCdRev = td.eq(13).text().trim();
// 	vBomName = td.eq(14).text().trim();
	
// 	vPartNm = td.eq(15).text().trim();
// 	vPartCnt = td.eq(16).text().trim();
// 	vMesu = td.eq(17).text().trim();
// 	vGubun = td.eq(18).text().trim();
// 	vQar = td.eq(19).text().trim();
// 	vInspectSelbi = td.eq(20).text().trim();
// 	vPackingJaryo = td.eq(21).text().trim();
// 	vModifyNote = td.eq(22).text().trim();
// 	vCustCode = td.eq(23).text().trim();
// 	vCustRev = td.eq(24).text().trim();
// 	vBigo = td.eq(25).text().trim();;
	
    $("#txt_part_cd").val(td.eq(12).text().trim());
    $("#txt_part_cd_rev").val(td.eq(13).text().trim());
    $("#txt_part_nm").val(td.eq(15).text().trim());
//     $("#txt_part_cnt").val(td.eq(16).text().trim());
}

</script>

	<table class='table table-bordered nowrap table-hover' id="<%=makeGridData.htmlTable_ID%>" style="width: 100%">
		<thead>
		<tr>
		     <th style='width:0px; display: none;'>order_no</th>
		     <th style='width:0px; display: none;'>lotno</th>
		     <th style='width:0px; display: none;'>revision_no</th>
		     <th style='width:0px; display: none;'>bom_cd</th>
		     <th style='width:0px; display: none;'>bom_cd_rev</th>
		     <th style='width:0px; display: none;'>last_no</th>
		     <th style='width:0px; display: none;'>sys_bom_id</th>
		     <th style='width:0px; display: none;'>type_no</th>
		     <th style='width:0px; display: none;'>geukyongpoommok</th>
		     <th style='width:0px; display: none;'>dept_code</th>
		     <th style='width:0px; display: none;'>approval_date</th>
		     <th style='width:0px; display: none;'>approval</th>
		     <th>원부자재코드</th>
		     <th style='width:0px; display: none;'>part_cd_rev</th>
		     <th style='width:0px; display: none;'>배합(BOM)명</th>
		     <th>원부자재명</th>
		     <th>비율</th>
		     <th style='width:0px; display: none;'>mesu</th>
		     <th style='width:0px; display: none;'>gubun</th>
		     <th style='width:0px; display: none;'>qar</th>
		     <th style='width:0px; display: none;'>inspect_selbi</th>
		     <th style='width:0px; display: none;'>packing_jaryo</th>
		     <th style='width:0px; display: none;'>modify_note</th>
		     <th style='width:0px; display: none;'>cust_code</th>
		     <th style='width:0px; display: none;'>cust_rev</th>
		     <th style='width:0px; display: none;'>bigo</th>
		     <th style='width:0px; display: none;'>create_user_id</th>
		     <th style='width:0px; display: none;'>create_date</th>
		     <th style='width:0px; display: none;'>modify_user_id</th>
		     <th style='width:0px; display: none;'>modify_date</th>
		     <th style='width:0px; display: none;'>modify_reason</th>
		     <th style='width:0px; display: none;'>review_no</th>
		     <th style='width:0px; display: none;'>confirm_no</th>
		     <th style='width:0px; display: none;'>order_detail_seq</th>
		     <th style='width:0px; display: none;'>member_key</th>
		     <th></th><!-- 실중량 -->
		</tr>
		</thead>
		<tbody id="<%=makeGridData.htmlTable_ID%>_body">		
		</tbody>
	</table>

<!-- <div id="UserList_pager" class="text-center"></div> -->


