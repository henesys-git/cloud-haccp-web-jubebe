<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="mes.client.comm.*" %>
<%@ page import="mes.client.common.*" %>
<%@ page import="mes.client.guiComponents.*" %>
<%@ page import="mes.client.util.*" %>
<%@ page import="mes.client.conf.*" %>
<%@ page import="org.json.simple.*"%><%@ include file="/strings.jsp" %>
<%
/* 
S838S015211.jsp
측정일지 등록
*/
	String loginID = session.getAttribute("login_id").toString();
	String member_key = session.getAttribute("member_key").toString();
	
	String checklist_id = "", checklist_rev_no = "", ccp_date ="";
	
	if(request.getParameter("checklist_id") != null)
		checklist_id = request.getParameter("checklist_id");	

	if(request.getParameter("checklist_rev_no") != null)
		checklist_rev_no = request.getParameter("checklist_rev_no");
	
	if(request.getParameter("ccp_date") != null)
		ccp_date = request.getParameter("ccp_date");
%>
    
<script type="text/javascript">
    $(document).ready(function () {
    	
		new SetSingleDate2("", "#measure_date", 0);
	
    });
    
 // 제품명 input tag 클릭 시 제품 검색 팝업 생성
    $('#prod_nm').click(function() {
    	parent.pop_fn_ProductName_View(2,'01')
    });
    
 
    // 제품 검색 후 클릭한 데이터를 가져옴
    function SetProductName_code(prodName, prodCode, prodRevNo, 
    							 prodGyugyuk, safeStock, curStock) {
    	
    	$('#prod_nm').val(prodName);
    	$('#prod_cd').val(prodCode);
    	$('#revision_no').val(prodRevNo);
    }
	
	function SaveOderInfo() {
    	
	        var dataJson = new Object();
	        
										
			dataJson.checklist_id = '<%=checklist_id%>';
			dataJson.checklist_rev_no = '<%=checklist_rev_no%>';
			dataJson.measure_date = $('#measure_date').val();
			dataJson.prod_cd = $('#prod_cd').val();
			dataJson.revision_no = $('#revision_no').val();
			dataJson.water_activity = $('#water_activity').val();
			dataJson.note = $('#note').val();
			dataJson.ccp_date = '<%=ccp_date%>;'
        	
			var JSONparam = JSON.stringify(dataJson);
			var chekrtn = confirm("등록하시겠습니까?"); 
			
			if(chekrtn) {
				SendTojsp(JSONparam, "M838S015200E111");
			}
		
	}

	function SendTojsp(bomdata, pid) {
	    $.ajax({
	        type: "POST",
	        dataType: "json",
	        url: "<%=Config.this_SERVER_path%>/Contents/CommonView/insert_update_delete_json.jsp", 
	        data:  {"bomdata" : bomdata, "pid" : pid},
			success: function (html) {	
				if(html > -1) {
					heneSwal.success('측정일지 등록이 완료되었습니다');

					$('#modalReport').modal('hide');
	        		parent.fn_MainInfo_List(startDate, endDate);
	         	} else {
					heneSwal.error('측정일지 등록 실패했습니다, 다시 시도해주세요');	         		
	         	}
	         }
	     });
	}
</script>

<table class="table" id="bom_table">
	<tr>
		<td>
			측정일자
		</td>
	    <td>
			<input type="text" data-date-format="yyyy-mm-dd" id="measure_date" class="form-control">
			
		</td>
	</tr>
	<tr>
 		<td>
			제품명
  		</td>
  		<td>
  			<input type="text" class="form-control" id="prod_nm" readonly/>
  			<input type="hidden" class="form-control" id="prod_cd"/>
  			<input type="hidden" class="form-control" id="revision_no"/>
  		</td>
  	</tr>
   	<tr>
 		<td>
			수분활성도
  		</td>
  		<td>
  			<input type="text" class="form-control" id="water_activity"/>
  		</td>
  	</tr>
 	<tr>
 		<td>
			비고
  		</td>
  		<td>
  			<input type="text" class="form-control" id="note"/>
  		</td>
  	</tr>
</table>