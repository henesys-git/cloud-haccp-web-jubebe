<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="mes.client.comm.*" %>
<%@ page import="mes.client.common.*" %>
<%@ page import="mes.client.guiComponents.*" %>
<%@ page import="mes.client.util.*" %>
<%@ page import="mes.client.conf.*" %>
<%@ page import="org.json.simple.*"%><%@ include file="/strings.jsp" %>
<%
	DoyosaeTableModel TableModel;
	MakeGridData makeGridData;
	MakeTableHTML makeTableHTML;
	String loginID = session.getAttribute("login_id").toString();
	String member_key = session.getAttribute("member_key").toString();
	
	int startPageNo = 1;

/* 
	String[] strColumnHead 	= { 
								"No.", "원부자재코드", "원부자재명", "중량(g)", 
								"maesu", "gumae_cheo", "Location", "비고", "bom_cd", 
								"bom_cd_rev", "sys_bom_parentid", "part_cd_rev", "level_gubun", "modify_hist"
							  };

	int[] colOff = { // 1이면 컬럼헤드 보여주고 0이면 감춤
					1, 1, 1, 1, 
					0, 0, 1, 1, 0,
					0, 0, 0, 0, 0
				   };
	String[] TR_Style		= {"", "onclick='S909S010210Event(this)'"};
	String[] TD_Style		= {""}; //strColumnHead의 수만큼
	String[] HyperLink		= {""}; //strColumnHead의 수만큼 
*/
	
	String RightButton[][]	= {
								{"off", "fn_Chart_View", rightbtnChartShow},
								{"off", "fn_Doc_Reg()", rightbtnDocSave},
								{"off", "file_real_name", rightbtnDocShow}
							  };
	
	String GV_BOM_CODE="", GV_REVISION_NO="", GV_PROD_CD="";
	
	if(request.getParameter("BomCode") == null)
		GV_BOM_CODE="";
	else
		GV_BOM_CODE = request.getParameter("BomCode");
	
	if(request.getParameter("prod_cd") == null)
		GV_PROD_CD="";
	else
		GV_PROD_CD = request.getParameter("prod_cd");

	String param =   GV_BOM_CODE + "|" + GV_PROD_CD + "|" ;
	
	JSONObject jArray = new JSONObject();
	jArray.put("member_key", member_key);
	jArray.put("BOM_CODE", GV_BOM_CODE);
	jArray.put("prod_cd", GV_PROD_CD);
		
    TableModel = new DoyosaeTableModel("M909S010100E214", jArray);	
 	int RowCount =TableModel.getRowCount();

 	CurrentPage jspPageName = new CurrentPage(request.getRequestURI());
 	String JSPpage = jspPageName.GetJSP_FileName();
 	
 	makeGridData = new MakeGridData(TableModel);
 	makeGridData.RightButton	= RightButton; 
 	makeGridData.htmlTable_ID 	= "tableS909S010220";
 	
 	makeGridData.Check_Box 	= "false";
 	String[] HyperLink		= {""}; //strColumnHead의 수만큼
 	makeGridData.HyperLink 	= HyperLink;
 	
   /*  
   	makeTableHTML = new MakeTableHTML(TableModel);
    makeTableHTML.colCount		= strColumnHead.length;
    makeTableHTML.pageSize 		= RowCount;  //RowCount 1페이지로 구성,PageSize: PageSize의 사이즈로 구성
    makeTableHTML.currentPageNum= startPageNo;
    makeTableHTML.htmlTable_ID	= "tableS909S010210";
    makeTableHTML.colOff		= colOff;
    makeTableHTML.TR_Style 		= TR_Style;
    makeTableHTML.TD_Style 		= TD_Style; 
    makeTableHTML.HyperLink 	= HyperLink;makeTableHTML.user_id = loginID;
    makeTableHTML.Check_Box 	= "false";
    makeTableHTML.RightButton	= RightButton; makeTableHTML.jsp_page = JSPpage;
    String zhtml=makeTableHTML.getHTML();
    */
%>

<script type="text/javascript">
    $(document).ready(function () {
    	var htmlTable_ID = <%=makeGridData.htmlTable_ID%>;
		
    	var vColumnDefs = [{
	    	'targets': [2,3,4,5,7,8,9],
   			'createdCell':  function (td) {
      			$(td).attr('style', 'display: none;'); 
   			}
	      }
		];
    	
		var localTableOptions = henesysSubTableOptions;
		localTableOptions.data = <%=makeGridData.getDataArry()%>;
		localTableOptions.columnDefs = vColumnDefs;
		$('#<%=makeGridData.htmlTable_ID%>').DataTable(localTableOptions);
		
    	
		vBomListId = "";
    	vPart_cd = "";
    });
    
    function clickSubMenu(obj) {
    	var tr = $(obj);
		var td = tr.children();
		var trNum = $(obj).closest('tr').prevAll().length;	// 현재 클릭한 TR의 순서 return

		$(SubMenu_rowID).attr("class", "");
		$(obj).attr("class", "selected");
		
		
		vPart_cd 		= td.eq(0).text().trim();
		vPart_nm 		= td.eq(1).text().trim();
		vProd_nm		= td.eq(2).text().trim();
		vProd_cd		= td.eq(3).text().trim();
		vPart_rev_no	= td.eq(4).text().trim();
		vBom_rev_no		= td.eq(5).text().trim();
		vBlending_ratio = td.eq(6).text().trim();
		vStart_date 	= td.eq(7).text().trim();
		vDuration_date	= td.eq(8).text().trim();
		vDelyn			= td.eq(9).text().trim();
    }
    
    
    function pop_fn_BomInfo_Update_View(obj) {
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
    }
		
    
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
			<th style='width:0px; display: none;'>제품명</th>
			<th style='width:0px; display: none;'>제품 코드</th>
			<th style='width:0px; display: none;'>원부재료/부자재 코드 rev</th>
			<th style='width:0px; display: none;'>배합비율 수정이력번호</th>
			<th>배합비율</th>
			<th style='width:0px; display: none;'>시작일자</th>
			<th style='width:0px; display: none;'>duration_date</th>
			<th style='width:0px; display: none;'>delyn</th>
			</tr>
		</thead>
		<tbody id="<%=makeGridData.htmlTable_ID%>_body">		
		</tbody>
			</table>
			<button type="button" onclick="pop_fn_BomInfo_Update_View(this)" id="update" class="btn btn-outline-success">수정</button>
          </div> 
        </div>
      </div> <!-- /.col-md-6 -->
    </div> <!-- /.row -->
  </div> <!-- /.container-fluid -->
</div> <!-- /.content -->