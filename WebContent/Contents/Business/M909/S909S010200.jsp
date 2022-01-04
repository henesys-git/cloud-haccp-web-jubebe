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
	
	int startPageNo = 1;
/* =========================복사하여 수정 할 부분=================================================  */   
	String GV_BOM_CODE="", GV_REVISION_NO="", GV_PRODGUBUN_BIG="", 
		   GV_PRODGUBUN_MID="", GV_PROD_CD;
	
	if(request.getParameter("BomCode") == null)
		GV_BOM_CODE="";
	else
		GV_BOM_CODE = request.getParameter("BomCode");
	
	if(request.getParameter("prodgubun_big") == null)
		GV_PRODGUBUN_BIG = "";
	else
		GV_PRODGUBUN_BIG = request.getParameter("prodgubun_big");

	if(request.getParameter("prodgubun_mid") == null)
		GV_PRODGUBUN_MID = "";
	else
		GV_PRODGUBUN_MID = request.getParameter("prodgubun_mid");
	
	JSONObject jArray = new JSONObject();
	jArray.put("member_key", member_key);	
	jArray.put("prodgubun_big", GV_PRODGUBUN_BIG); // 대분류 : 생산(02)
	jArray.put("prodgubun_mid", GV_PRODGUBUN_MID);
	
	String param = GV_PRODGUBUN_BIG + "|" + GV_PRODGUBUN_MID + "|"  + member_key + "|";
	
	String REV_CHECK = "";
	if (request.getParameter("total_rev_check") == null)
		REV_CHECK = "";
	else
		REV_CHECK = request.getParameter("total_rev_check");
	
	String PID_FOR_REV_CHECK="M909S060100E106";
	
	if(REV_CHECK.equals("true"))
		PID_FOR_REV_CHECK = "M909S060100E107";
	else if(REV_CHECK.equals("false"))
		PID_FOR_REV_CHECK = "M909S060100E106";
	
	TableModel = new DoyosaeTableModel(PID_FOR_REV_CHECK, jArray);
/* =========================복사하여 수정 할 부분====끝=====================================  */

 	int RowCount =TableModel.getRowCount();
 	CurrentPage jspPageName = new CurrentPage(request.getRequestURI());
 	String JSPpage = jspPageName.GetJSP_FileName();   
 	
    makeGridData= new MakeGridData(TableModel);
	String RightButton[][]	= {
								{"off", "fn_Chart_View", rightbtnChartShow},
								{"off", "fn_Doc_Reg()", rightbtnDocSave},
								{"off", "file_real_name", rightbtnDocShow}
							  };
	
 	makeGridData.RightButton = RightButton;
 	
 	/* =========================복사하여 수정 할 부분===========================================  */ 
    makeGridData.htmlTable_ID	= "tableS909S010200";
    /* =========================복사하여 수정 할 부분====끝=====================================  */  
    
 	makeGridData.Check_Box = "false";
 	String[] HyperLink = {""}; //strColumnHead의 수만큼
 	makeGridData.HyperLink = HyperLink;    
%>

<script type="text/javascript">
	
	var bomInfoTable = "";
	
    $(document).ready(function () {
    	var htmlTable_ID = <%=makeGridData.htmlTable_ID%>;
    	
    	var customOpts = {
   			data : <%=makeGridData.getDataArray()%>,
   			columnDefs : [{
   	       		'targets': [2,3,7,8,9,10,11,12],
   	       		'createdCell':  function (td) {
   	          			$(td).attr('style', 'display: none;'); 
   	       		}
   			}],
   			bAutoWidth : false
    	};
    	
    	bomInfoTable = $('#<%=makeGridData.htmlTable_ID%>').DataTable(
    		mergeOptions(heneMainTableOpts, customOpts)
    	);
    	
    	bomInfoTable.columns.adjust();
    	
    	vProdgubun_big	= "";
		vProdgubun_mid	= "";
		vBomCode = "";
    	vBomListId = "";
    	vProd_cd = "";
    });
    
    function clickMainMenu(obj) {
    	var tr = $(obj);
    	var td = tr.children();
		// 현재 클릭한 TR의 순서 return
		var trNum = $(obj).closest('tr').prevAll().length;
		
		$(MainMenu_rowID).attr("class", "");
		$(obj).attr("class", "selected");
		
		vProdgubun_big	= td.eq(0).text().trim();
		vProdgubun_mid	= td.eq(1).text().trim();
		vProd_cd		= td.eq(2).text().trim();
		vProd_rev_no	= td.eq(3).text().trim();
		vProd_nm		= td.eq(4).text().trim();
		vGugyuk			= td.eq(5).text().trim();
		vStart_date 	= td.eq(6).text().trim();
		vBom_rev_no		= td.eq(13).text().trim();
		vBomInfoRowCount = 0;
		vBomListId = "";
		
		// 서브 메뉴를 보여준다.
		parent.DetailInfo_List.click();
		
		bomInfoTable.columns.adjust();
		
    }
</script>

<!--=========================복사하여 수정 할 부분=================================================-->
<table class='table table-bordered nowrap table-hover' id="<%=makeGridData.htmlTable_ID%>" style="width: 100%">
		<thead>
		<tr>
			 <th>대분류</th>
		     <th>중분류</th>
		     <th style='width:0px; display: none;'>제품코드</th>
		     <th style='width:0px; display: none;'>개정번호</th>
		     <th>제품명</th>
		     <th>규격</th>
		     <th>적용시작일자</th>
		     <th style='width:0px; display: none;'>적용종료일자</th>
		     <th style='width:0px; display: none;'>생성자</th>
		     <th style='width:0px; display: none;'>생성일자</th>
		     <th style='width:0px; display: none;'>수정자</th>
		     <th style='width:0px; display: none;'>수정사유</th>
		     <th style='width:0px; display: none;'>수정일자</th>
		     <!-- <th style='width:0px; display: none;'>배합비율 수정이력번호</th> -->
		</tr>
		</thead>
		<tbody id="<%=makeGridData.htmlTable_ID%>_body">		
		</tbody>
	</table>

<!--=========================복사하여 수정 할 부분=====끝============================================-->
<div id="UserList_pager" class="text-center">
</div>                 
