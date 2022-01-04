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

	String regist_seq_no = "", GV_TODATE = "";

	if(request.getParameter("regist_seq_no") != null)
		regist_seq_no = request.getParameter("regist_seq_no");
	
	JSONObject jArray = new JSONObject();
	jArray.put("regist_seq_no", regist_seq_no);				
	
    DoyosaeTableModel TableModel = new DoyosaeTableModel("M838S020800E114", jArray);
 	MakeGridData tData = new MakeGridData(TableModel);
    tData.htmlTable_ID = "TableS838S020810";
%>
<style>
.detail4 {
	background-color: #29905F;
	color : white;
}
</style>
<script>

    $(document).ready(function () {
    	
    	var htmlTable_ID = '<%=tData.htmlTable_ID%>';
    	
    	var dataArr = <%=tData.getDataArray()%>;
    	
    	var customOpts = {
				data : dataArr,
				columnDefs : [{
					'targets': [0,2],
					'createdCell': function (td) {
			  			$(td).attr('style', 'display: none;'); 
					}
				},
				{
					'targets': [8],
					'render': function (data) {
			  			if(data == "O")
			  				return "양호";
			  			else
			  				return "불량";
					}
				}]
		}
		
 		var table = $('#<%=tData.htmlTable_ID%>').DataTable(
			mergeOptions(heneSubTableOpts, customOpts)
		); 
    	
    	
    	$('#'+htmlTable_ID+'_body tr td').each(function() {
    		
			var tr = $(this).closest('tr');
			
			var td = tr.children();
			
			var check_date = td.text().substr(1,10);
			
			if(check_date == tr.next().children().text().substr(1,10) &&  check_date == tr.next().next().children().text().substr(1,10)
					&& check_date == tr.next().next().next().children().text().substr(1,10) ){
				
				tr.next().hide();
	            tr.next().next().hide();
	            tr.next().next().next().hide();
				
			} 
        	
    	});
    	
    });
      
     function clickSubMenu(obj){
    	 
    	var tr = $(obj);
		var td = tr.children();
    	
    	tr.parent().children().each(function() {
    		
    		if($(this).hasClass('detail4')){
        		$(this).hide();
        	}
    		
    	})
    	
	//	var trNum = $(obj).closest('tr').prevAll().length;
		
		var dinfec_id = td.text().substr(11,8);
        
		if(dinfec_id == 'dinfec01'){

	        if(!tr.next().is(':visible')){
	        	
	    		tr.next().show();
	            tr.next().next().show();
	            tr.next().next().next().show();
	            
	            tr.next().addClass('detail4');
	            tr.next().next().addClass("detail4");
	            tr.next().next().next().addClass("detail4");
	            
	        } else {
	        	
	        	tr.next().hide();
	            tr.next().next().hide();
	            tr.next().next().next().hide();
	        	
	        }
			
		}
		
		regist_seq_no 		= td.eq(0).text().trim();
		check_date 			= td.eq(1).text().trim();
		disinfectant_id		= td.eq(2).text().trim();
		disinfectant_nm 	= td.eq(3).text().trim();
		purchase_amount 	= td.eq(4).text().trim();
		use_amount 		= td.eq(5).text().trim();
		stock_amount 	= td.eq(6).text().trim();
		check_detail 	= td.eq(7).text().trim();
		result 			= td.eq(8).text().trim();
    } 
</script>

<table class='table table-bordered nowrap table-hover' 
		  id="<%=tData.htmlTable_ID%>" style="width:100%">
	<thead>
		<tr>
		     <th style='width:0px; display:none;'>작성일련번호</th>
		     <th>점검일자</th>
		     <th style='width:0px; display:none;'>약품 ID</th>
   		     <th>약품명</th>
		     <th>구입량</th>
		     <th>사용량</th>
		     <th>재고량</th>
		     <th>점검내용</th>
		     <th>결과</th>
		</tr>
	</thead>
	<tbody id="<%=tData.htmlTable_ID%>_body">
	</tbody>
</table>
<!--  <table id = "example" width="100%"></table> -->
<div id="UserList_pager" class="text-center">
</div>