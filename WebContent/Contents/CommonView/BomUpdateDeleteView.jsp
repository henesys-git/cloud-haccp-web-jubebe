<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="mes.client.comm.*" %>
<%@ page import="mes.client.common.*" %>
<%@ page import="mes.client.guiComponents.*" %>
<%@ page import="mes.client.util.*" %>
<%@ page import="mes.client.conf.*" %>
<%@ page import="org.json.simple.*"%>
<%@ include file="/strings.jsp" %>
<%
	DoyosaeTableModel TableModel;
	MakeGridData makeGridData;
	MakeTableHTML makeTableHTML;
	String loginID = session.getAttribute("login_id").toString();
	String member_key = session.getAttribute("member_key").toString();
	
	int startPageNo = 1;
	
	String RightButton[][]	= {
								{"off", "fn_Chart_View", rightbtnChartShow},
								{"off", "fn_Doc_Reg()", rightbtnDocSave},
								{"off", "file_real_name", rightbtnDocShow}
							  };
	
	String GV_BOM_CODE="", GV_REVISION_NO="", GV_PROD_CD="" ,GV_CALLER="", GV_PROD_NM="";
	
	if(request.getParameter("caller") == null)
		GV_CALLER="0";
	else
		GV_CALLER = request.getParameter("caller");	
	
	if(request.getParameter("BomCode") == null)
		GV_BOM_CODE="";
	else
		GV_BOM_CODE = request.getParameter("BomCode");
	
	if(request.getParameter("prod_cd") == null)
		GV_PROD_CD="";
	else
		GV_PROD_CD = request.getParameter("prod_cd");
	
	if(request.getParameter("prod_nm") == null)
		GV_PROD_NM="";
	else
		GV_PROD_NM = request.getParameter("prod_nm");

	String param =   GV_BOM_CODE + "|" + GV_PROD_CD + "|" ;
	
	JSONObject jArray = new JSONObject();
	jArray.put("member_key", member_key);
	jArray.put("BOM_CODE", GV_BOM_CODE);
	jArray.put("prod_cd", GV_PROD_CD);
	jArray.put("prod_nm", GV_PROD_NM);
	
		
    TableModel = new DoyosaeTableModel("M909S010100E004", jArray);	
 	int RowCount =TableModel.getRowCount();

 	CurrentPage jspPageName = new CurrentPage(request.getRequestURI());
 	String JSPpage = jspPageName.GetJSP_FileName();
 	
 	makeGridData = new MakeGridData(TableModel);
 	makeGridData.RightButton	= RightButton; 
 	makeGridData.htmlTable_ID 	= "tableBomUpdateDelete";
 	
 	makeGridData.Check_Box 	= "false";
 	String[] HyperLink		= {""}; //strColumnHead의 수만큼
 	makeGridData.HyperLink 	= HyperLink;
%>

<script type="text/javascript">
    $(document).ready(function () {
    	
    	setTimeout(function(){
    	
    	var htmlTable_ID = <%=makeGridData.htmlTable_ID%>;
		
		var customOpts = {
   			data : <%=makeGridData.getDataArry()%>,
   			columnDefs : [{
   	       		'targets': [2,3,4,5,7,8,9,10],
   	       		'createdCell': function (td) {
   	          			$(td).attr('style', 'display: none;');
   	       		}
   	    	}]
    	}
    	
    	$('#<%=makeGridData.htmlTable_ID%>').DataTable(
    		mergeOptions(henePopupTableOpts, customOpts)
    	);
		
    	}, 200);
		
		vBomListId = "";
    	vPart_cd = "";
			
		});
        

		
    
    function clickPopupMenu(obj) {
    	var tr = $(obj);
		var td = tr.children();
		var trNum = $(obj).closest('tr').prevAll().length;	// 현재 클릭한 TR의 순서 return
		
		$(PopupMenu_rowID).attr("class", "");
		$(obj).attr("class", "selected");
		
		var part_cd 			= td.eq(0).text().trim();
		var part_name 			= td.eq(1).text().trim();
		var prod_cd				= td.eq(2).text().trim();
		var prod_name			= td.eq(3).text().trim();
		var part_revision_no	= td.eq(4).text().trim();
		var bom_revision_no		= td.eq(5).text().trim();
		var blending_ratio 		= td.eq(6).text().trim();
		var start_date 			= td.eq(7).text().trim();
		var duration_date		= td.eq(8).text().trim();
		var delyn				= td.eq(9).text().trim();
		var prod_revision_no	= td.eq(10).text().trim();
		
		parent.SetBomInfo(part_name, part_cd, part_revision_no, prod_cd, prod_revision_no, bom_revision_no, blending_ratio, prod_name);
		
		parent.$('#modalReport2').modal('hide');
		parent.$('#modalReport_nd').hide();
		
		
		/* vPart_cd 		= td.eq(0).text().trim();
		vPart_nm 		= td.eq(1).text().trim();
		vProd_nm		= td.eq(2).text().trim();
		vProd_cd		= td.eq(3).text().trim();
		vPart_rev_no	= td.eq(4).text().trim();
		vBom_rev_no		= td.eq(5).text().trim();
		vBlending_ratio = td.eq(6).text().trim();
		vStart_date 	= td.eq(7).text().trim();
		vDuration_date	= td.eq(8).text().trim();
		vDelyn			= td.eq(9).text().trim(); */
		
		
    }
    
    
    
    
    <%-- function pop_fn_BomInfo_Update_View(obj) {
    	//if(vBomListId == undefined || vBomListId.length < 1){
    	if(vProd_cd.length < 1){
        	alert("BOM 정보 목록 중 원부자재를 선택하세요")
        	return false;
        }
    	
		var url = "<%=Config.this_SERVER_path%>/Contents/Business/M909/S909S010212.jsp"
			+ "?BomCode=" + vBomCode 
			+ "&Bom_Rev_No=" + vBom_rev_no
			+ "&prod_cd=" + vProd_cd
			+ "&prod_nm=" + vProd_nm;
		var footer = '<button id="btn_BomUpdate" class="btn btn-outline-success" style="width: 100px"'
			   				+ 'onclick="">선택항목수정</button>';
		var title = obj.innerText;
		var heneModal = new HenesysModal2(url, 'large', title+"(S909S010221)", footer);
		heneModal.open_modal();
    } --%>
		
    
</script>

<!-- Main content -->
<div class="content">
  <div class="container-fluid">
    <div class="row">
      <div class="col-md-12">
        <div class="card card-primary card-outline">
        <div class="card-header">
          	<h3 class="card-title">
          		<i class="fas fa-edit" id="InfoContentTitle">배합(BOM)원부재료 목록</i>
          	</h3>
        </div>
          <div class="card-body">
          	<table class='table table-bordered nowrap table-hover' id="<%=makeGridData.htmlTable_ID%>" style="width: 100%">
		<thead>
			<tr>
			<th>원부재료/부자재 코드</th>
			<th>원부자재명</th>
			<th style='width:0px; display: none;'>제품 코드</th>
			<th style='width:0px; display: none;'>제품명</th>
			<th style='width:0px; display: none;'>원부재료/부자재 코드 rev</th>
			<th style='width:0px; display: none;'>배합비율 수정이력번호</th>
			<th>배합비율</th>
			<th style='width:0px; display: none;'>시작일자</th>
			<th style='width:0px; display: none;'>duration_date</th>
			<th style='width:0px; display: none;'>delyn</th>
			<th style='width:0px; display: none;'>제품 수정이력번호</th>
			</tr>
		</thead>
		<tbody id="<%=makeGridData.htmlTable_ID%>_body">		
		</tbody>
			</table>
<!-- 			<button type="button" onclick="pop_fn_BomInfo_Update_View(this)" id="update" class="btn btn-outline-success">수정</button>
 -->          </div> 
        </div>
      </div> <!-- /.col-md-6 -->
    </div> <!-- /.row -->
  </div> <!-- /.container-fluid -->
</div> <!-- /.content -->