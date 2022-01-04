<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="mes.client.comm.*" %>
<%@ page import="mes.client.guiComponents.*" %>
<%@ page import="mes.client.util.*" %>
<%@ page import="mes.client.conf.*" %>
<%@ page import="org.json.simple.*"%><%@ include file="/strings.jsp" %>
<%
	DoyosaeTableModel TableModel;
	MakeGridData makeGridData;

	String member_key = session.getAttribute("member_key").toString();
	
	int startPageNo =1; //Integer.parseInt(request.getParameter("CurrentPageNumber").toString().trim());
// 	final int PageSize=15; 
	

	String GV_PROC_PLAN_NO="", GV_PROD_CD="", GV_PROD_REV="", GV_SEOLBI_NM="", GV_START_DT="";
	
	if(request.getParameter("Proc_plan_no")== null)
		GV_PROC_PLAN_NO="";
	else
		GV_PROC_PLAN_NO = request.getParameter("Proc_plan_no");
	
	if(request.getParameter("ProdCd")== null)
		GV_PROD_CD="";
	else
		GV_PROD_CD = request.getParameter("ProdCd");
	
	if(request.getParameter("Prod_rev")== null)
		GV_PROD_REV="";
	else
		GV_PROD_REV = request.getParameter("Prod_rev");
	
	if(request.getParameter("Seolbi_nm")== null)
		GV_SEOLBI_NM="";
	else
		GV_SEOLBI_NM = request.getParameter("Seolbi_nm");
	
	if(request.getParameter("Start_dt")== null)
		GV_START_DT="";
	else
		GV_START_DT = request.getParameter("Start_dt");
	
	//tablet 관련부분//////////////////////////////////////
	String GV_TABLET_NY = "";
	
	if(request.getParameter("TabletYN")== null)
		GV_TABLET_NY="";
	else
		GV_TABLET_NY = request.getParameter("TabletYN");
	
	JSONObject jArray = new JSONObject();
	
	jArray.put( "proc_plan_no", GV_PROC_PLAN_NO);
	jArray.put( "prod_cd", GV_PROD_CD);
	jArray.put( "prod_cd_rev", GV_PROD_REV);
	jArray.put( "seolbi_nm", GV_SEOLBI_NM);
	jArray.put( "start_dt", GV_START_DT);
	jArray.put( "member_key", member_key);
		
    TableModel = new DoyosaeTableModel("M404S030100E214", jArray);
 	int RowCount =TableModel.getRowCount();
 	
	makeGridData= new MakeGridData(TableModel);
	
	String RightButton[][]	= {{"on", "pop_fn_product_weight_Check(this)", "점검표"},{"off", "fn_Doc_Reg()", rightbtnDocSave},{"off", "file_real_name", rightbtnDocShow}};
 	makeGridData.RightButton	= RightButton;
 	 
    makeGridData.htmlTable_ID	= "tableS404S030210";
    
 	makeGridData.Check_Box 	= "false";
 	String[] HyperLink		= {""}; //strColumnHead의 수만큼
 	makeGridData.HyperLink 	= HyperLink;
    
%>
<script>
   
    $(document).ready(function () {
    	
    	var htmlTable_ID = <%=makeGridData.htmlTable_ID%>;
    	
    	var customOpts = {
				data : <%=makeGridData.getDataArray()%>,
				columnDefs : [{
					'targets': [0,2,5],
					'createdCell': function (td) {
			  			$(td).attr('style', 'display: none;'); 
					}
				}]
		}
		
		$('#<%=makeGridData.htmlTable_ID%>').DataTable(
			mergeOptions(heneSubTableOpts, customOpts)
		);
    	
		
       /*  
    	TableCD_RowCount = chk_data_tb.rows().count();
        dt_Prod_cd[0] 		= '';
    	for(var i=0; i<TableCD_RowCount; i++) { // 오른쪽테이블에 있는 왼쪽테이블 레코드제거
    		dt_Prod_cd[i] = chk_data_tb.cell(i, 0).data().trim();
    	}	
//        console.log(dt_Prod_cd[0]);
		 */
		
       	fn_Clear_varv();
    });
    

    function clickSubMenu(obj){
      	var tr = $(obj);
  		var td = tr.children();
  		var trNum = $(obj).closest('tr').prevAll().length;//현재 클릭한 TR의 순서 return

  		$(SubMenu_rowID).attr("class", "");
  		$(obj).attr("class", "hene-bg-color");
  		
	}			    	            

    function fn_Clear_varv(){

    }   
    
</script>


<table class='table table-bordered nowrap table-hover' id="<%=makeGridData.htmlTable_ID%>" style="width: 100%">
		<thead>
		<tr>
			<th style='width:0px; display: none;'>생산코드</th>
			<th>제품코드</th>
			<th style='width:0px; display: none;'>제품rev</th>
			<th>설비명</th>
			<th>제품명</th>
			<th style='width:0px; display: none;'>표준규격</th>
			<th>점검일</th>
			<th>담당자</th>
			<th>승인자</th>
<!-- 			<th style='width:0px; display: none;'></th> -->
		</tr>
		</thead>
		<tbody id="<%=makeGridData.htmlTable_ID%>_body">		
		</tbody>
</table>

<div id="UserList_pager" class="text-center">
</div>              