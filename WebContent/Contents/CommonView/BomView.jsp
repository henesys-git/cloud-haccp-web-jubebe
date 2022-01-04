<%@page import="org.json.simple.JSONObject"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="mes.client.comm.*" %>
<%@ page import="mes.client.common.*" %>
<%@ page import="mes.client.guiComponents.*" %>
<%@ page import="mes.client.util.*" %>
<%@ page import="mes.client.conf.*" %>
<%@ include file="/strings.jsp" %>
<!DOCTYPE html>
<%
	DoyosaeTableModel TableModel;
	MakeGridData makeGridData;
	String loginID = session.getAttribute("login_id").toString();
	String member_key = session.getAttribute("member_key").toString();
	
	String zhtml = "";
	int startPageNo = 1;
// 	final int PageSize=15; 
	
	String GV_CALLER="", GV_LEVEL="", GV_BOM_CD="";

	
	if(request.getParameter("caller")== null)
		GV_CALLER="";
	else
		GV_CALLER = request.getParameter("caller");	
	
	if(request.getParameter("bom_cd")== null)
		GV_BOM_CD="";
	else
		GV_BOM_CD = request.getParameter("bom_cd");	


	if(request.getParameter("level")== null)
		GV_LEVEL="";
	else
		GV_LEVEL = request.getParameter("level");	

	String param;
	if(GV_LEVEL.equals("1"))
		param = GV_LEVEL + "|" + GV_BOM_CD + "|" + member_key + "|";
	else	
		param = "|" + GV_BOM_CD + "|" + member_key + "|" ;
	
	JSONObject jArray = new JSONObject();
	if(GV_LEVEL.equals("1")){
		jArray.put("level", GV_LEVEL);
		jArray.put("bom_cd", GV_BOM_CD);
		jArray.put("member_key", member_key);
	}
	else{
		jArray.put("bom_cd", GV_BOM_CD);
		jArray.put("member_key", member_key);
	}
	
    TableModel = new DoyosaeTableModel("M909S010100E294", jArray);
    
    /* =========================복사하여 수정 할 부분====끝=====================================  */  
 	int RowCount =TableModel.getRowCount();
 	CurrentPage jspPageName = new CurrentPage(request.getRequestURI());
 	String JSPpage = jspPageName.GetJSP_FileName();   
 	
    makeGridData= new MakeGridData(TableModel);
	String RightButton[][]	= {{"off", "fn_Chart_View", rightbtnChartShow},{"off", "fn_Doc_Reg()", rightbtnDocSave},{"off", "file_real_name", rightbtnDocShow}};
 	makeGridData.RightButton	= RightButton;
 	
 	/* =========================복사하여 수정 할 부분=================================================  */ 
    makeGridData.htmlTable_ID	= "tableM909S010100E294";
    /* =========================복사하여 수정 할 부분====끝=====================================  */  
    
 	makeGridData.Check_Box 	= "false";
 	String[] HyperLink		= {""}; //strColumnHead의 수만큼
 	makeGridData.HyperLink 	= HyperLink;    
%>

<script>
 
	var caller="";
	var GV_GIJONG_CD;
	$(document).ready(function () {
		caller = "<%=GV_CALLER%>";
		
    	$('#<%=makeGridData.htmlTable_ID%>').DataTable({	
    		scrollX: true,
//     		scrollY: 500,
    	    scrollCollapse: true,
    	    paging: true,
    	    searching: true,
    	    ordering: true,
    	    order: [[ 2, "asc" ]],
    	    info: true,
			data: <%=makeGridData.getDataArry()%>,
		    'createdRow': function(row) {	
	      		$(row).attr('id',"<%=makeGridData.htmlTable_ID%>_rowID");
	      		$(row).attr('onclick',"<%=makeGridData.htmlTable_ID%>Event(this)");
	      		$(row).attr('role',"row");
	  		}, 
	  		/* =========================복사하여 수정 할 부분===========================================  */   
	  		'columnDefs': [{
	       		'targets': [2,6,8,10,11,12,14,15,16],
	       		'createdCell':  function (td) {
	          			$(td).attr('style', 'display: none;'); 
	       		}
			},
			{
	       		'targets': [18],
	       		'createdCell':  function (td) {
          			$(td).attr('style', 'display: none;'); //버튼 자리아래의 테이블 버튼자리와 같이 항상 처리한다.
       			}
	       	}
	  		/* =========================복사하여 수정 할 부분====끝=====================================  */  
			
			],    
            language: { 
                url:"<%=Config.this_SERVER_path%>/AdminLTE-3.0.5/localisation/Korean.json"
             }
		});
	});
	
	function <%=makeGridData.htmlTable_ID%>Event(obj){
		var tr = $(obj);
		var td = tr.children();

		var trNum = $(obj).closest('tr').prevAll().length;//현재 클릭한 TR의 순서 return

		$($("input[id='checkbox1']")[trNum]).prop("checked", function(){
	        return !$(this).prop('checked');
	    });
		
		$(<%=makeGridData.htmlTable_ID%>_rowID).attr("class", "");
		$(obj).attr("class", "bg-success");
		var txt_bom_cd		= td.eq(1).text().trim();
		var txt_bom_cd_rev	= td.eq(2).text().trim(); 
		var txt_part_cd	= td.eq(3).text().trim();
		var txt_bom_nm 	= td.eq(4).text().trim();
		var txt_part_nm 	= td.eq(5).text().trim();
		var txt_part_cd_rev = td.eq(6).text().trim();
		var txt_part_cnt 	= td.eq(7).text().trim();
		
		
		if(caller==0){ //일반 화면에서 부를 때
			$('#txt_bom_cd').val(txt_bom_cd);
			$('#txt_bom_cd_rev').val(txt_bom_cd_rev);
			$('#txt_bom_nm').val(txt_bom_nm);
			$('#txt_part_nm').val(txt_part_nm);
			$('#txt_part_cd').val(txt_part_cd);
			$('#txt_part_cd_rev').val(txt_part_cd_rev);
			$('#txt_part_cnt').val(txt_part_cnt);
		}
		else if(caller==1){ //레이어팝업(Iframe에서 다른 Iframe으로 값을 보낼때 상대방 Iframe의 Function을 사용)에서부를 때
 			parent.SetBomInfo('<%=GV_LEVEL%>',txt_bom_cd, txt_bom_cd_rev,txt_bom_nm,txt_part_nm,txt_part_cd,txt_part_cd_rev,txt_part_cnt);
		}
		parent.$('#modalReport_nd').hide();
	}
</script>	

<!--=========================복사하여 수정 할 부분=================================================-->
<table class='table table-bordered nowrap table-hover' id="<%=makeGridData.htmlTable_ID%>" style="width: 100%">
		<thead>
		<tr>
		     <th>순번</th>
		     <th>배합(BOM)코드</th>
		     <th style='width:0px; display: none;'>배합(BOM)개정번호</th>
		     <th>원부자재코드</th>
		     <th>배합(BOM)명</th>
		     <th>원부자재명</th>
		     <th style='width:0px; display: none;'>원부자재개정번호</th>
		     <th>원부자재수량</th>
		     <th style='width:0px; display: none;'>매수</th>
		     <th>구분</th>
		     <th style='width:0px; display: none;'>qar</th>
		     <th style='width:0px; display: none;'>inspect</th>
		     <th style='width:0px; display: none;'>package</th>
		     <th>수정</th>
		     <th style='width:0px; display: none;'>고객사코드</th>
		     <th style='width:0px; display: none;'>거래처</th>
		     <th style='width:0px; display: none;'>고객사개정번호</th>
		     <th>비고</th>
<!-- 		     버튼 자리 makeGridData의 데이터는 항상 버튼위 위치에 데이터를 space혹은 Button 문법을 구현해 준다 -->
		     <th style='width:0px; display: none;'></th> 
		</tr>
		</thead>
		<tbody id="<%=makeGridData.htmlTable_ID%>_body">		
		</tbody>
	</table>
<%=zhtml%>
<div id="UserList_pager" class="text-center">
	<button id="btn_Canc"  class="btn btn-info" style="width: 100px" onclick="parent.$('#modalReport_nd').hide();">닫기</button>
</div> 

