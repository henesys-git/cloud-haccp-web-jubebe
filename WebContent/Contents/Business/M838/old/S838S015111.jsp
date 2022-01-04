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
S838S015111.jsp
CCP-3B 모니터링 측정일지 등록
*/
	String loginID = session.getAttribute("login_id").toString();
	String member_key = session.getAttribute("member_key").toString();
	
	String checklist_id = "", checklist_rev_no = "", ccp_date = "";
	
	if(request.getParameter("checklist_id") != null)
		checklist_id = request.getParameter("checklist_id");	

	if(request.getParameter("checklist_rev_no") != null)
		checklist_rev_no = request.getParameter("checklist_rev_no");
	
	if(request.getParameter("ccp_date") != null)
		ccp_date = request.getParameter("ccp_date");
%>
    
<script type="text/javascript">
    $(document).ready(function () {
		
	
		
		
		new SetSingleDate2("", "#ccp_date", 0);
		
		$('#ccp_date').attr('disabled', true);
		
		// 제품명 input tag 클릭 시 제품 검색 팝업 생성
	    $('#prod_nm').click(function() {
	    	parent.pop_fn_ProductName_View(2,'01')
	    });
		
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
			dataJson.check_time = $('#check_time').val();
			dataJson.prod_cd = $('#prod_cd').val();
			dataJson.revision_no = $('#revision_no').val();
			dataJson.temp_place = $('#temp_place').val();
			dataJson.temp_prod = $('#temp_prod').val();
			dataJson.quick_cooling_time = $('#quick_cooling_time').val();
			dataJson.result = $("input[name='result']:checked").val();
			dataJson.person_id = '<%=checklist_id%>';
			
			dataJson.ccp_date = '<%=ccp_date%>;'
        	
			var JSONparam = JSON.stringify(dataJson);
			var chekrtn = confirm("등록하시겠습니까?"); 
			
			if(chekrtn) {
				SendTojsp(JSONparam, "M838S015100E111");
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
			측정시각
		</td>
	    <td>
			<input type="time" id="check_time" class="form-control">
			
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
			급냉실온도
  		</td>
  		<td>
  			<input type="text" class="form-control" id="temp_place"/>
  		</td>
  	</tr>
 	<tr>
 		<td>
			제품품온
  		</td>
  		<td>
  			<input type="text" class="form-control" id="temp_prod"/>
  		</td>
  	</tr>
  	<tr>
 		<td>
			급냉시간
  		</td>
  		<td>
  			<input type="text" class="form-control" id="quick_cooling_time"/>
  		</td>
  	</tr>
  	<tr>
 		<td>
			판정
  		</td>
  		<td>
  			<input type="radio" id="result_y" value="적합" checked name="result">
			<label class="form-check-label" for="result_y">적합</label>
			<input type="radio" id="result_n" value="부적합" name="result">
			<label class="form-check-label" for="result_n">부적합</label>
  		</td>
  	</tr>
</table>