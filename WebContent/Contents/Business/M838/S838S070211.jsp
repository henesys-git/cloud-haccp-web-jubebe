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
S838S070211.jsp
원부재료 입고검사 대장 부자재 등록
*/
	String loginID = session.getAttribute("login_id").toString();
	String member_key = session.getAttribute("member_key").toString();
	
	String checklist_id = "", checklist_rev_no = "", ipgo_date = "";
	
	if(request.getParameter("checklist_id") != null)
		checklist_id = request.getParameter("checklist_id");	

	if(request.getParameter("checklist_rev_no") != null)
		checklist_rev_no = request.getParameter("checklist_rev_no");
	
	if(request.getParameter("ipgo_date") != null)
		ipgo_date = request.getParameter("ipgo_date");
%>
    
<script type="text/javascript">
    $(document).ready(function () {
    	
		new SetSingleDate2("", "#ipgo_date", 0);
		
		$('#ipgo_date').val('<%=ipgo_date%>');
		
		$('#ipgo_date').attr('disabled', true);
		
		$('#part_nm').click(function() {
			pop_fn_PartIpgo_View('<%=ipgo_date%>', 02)
		});
	
    });
    
    
	// 원부자재 검색 2차 팝업창에서 행 클릭했을때
	function SetpartName_code(part_cd, part_nm, part_rev_no, trace_key, balju_no, balju_rev_no) { 
		$('#part_cd').val(part_cd);
		$('#part_rev_no').val(part_rev_no);
		$('#part_nm').val(part_nm);
		$('#trace_key').val(trace_key);
		$('#balju_no').val(balju_no);
		$('#balju_rev_no').val(balju_rev_no);
  	}
	
	function SaveOderInfo() {
    	
	        var dataJson = new Object();
	        
										
			dataJson.checklist_id = '<%=checklist_id%>';
			dataJson.checklist_rev_no = '<%=checklist_rev_no%>';
			dataJson.ipgo_date = $('#ipgo_date').val();
			dataJson.part_cd = $('#part_cd').val();
			dataJson.part_rev_no = $('#part_rev_no').val();
			dataJson.trace_key = $('#trace_key').val();
			dataJson.standard_yn = $("input[name='standard_yn']:checked").val();
			dataJson.packing_status = $("input[name='packing_status']:checked").val();
			dataJson.visual_inspection = $("input[name='visual_inspection']:checked").val();
			dataJson.car_clean = $("input[name='car_clean']:checked").val();
			dataJson.docs_yn = $("input[name='docs_yn']:checked").val();
			dataJson.unsuit_action = $("input[name='unsuit_action']:checked").val();
			dataJson.check_yn = $("input[name='check_yn']:checked").val();
			dataJson.balju_no = $('#balju_no').val();
			dataJson.balju_rev_no = $('#balju_rev_no').val();
        	
			var JSONparam = JSON.stringify(dataJson);
			var chekrtn = confirm("등록하시겠습니까?"); 
			
			if(chekrtn) {
				SendTojsp(JSONparam, "M838S070200E111");
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
					heneSwal.success('입고검사 대장 부자재 등록이 완료되었습니다');

					$('#modalReport').modal('hide');
	        		parent.fn_MainInfo_List(toDate);
	         	} else {
					heneSwal.error('입고검사 대장 부자재 등록 실패했습니다, 다시 시도해주세요');	         		
	         	}
	         }
	     });
	}
</script>

<table class="table" id="bom_table">
	<tr>
		<td>
			입고일자
		</td>
	    <td>
			<input type="text" data-date-format="yyyy-mm-dd" id="ipgo_date" class="form-control">
			
		</td>
	</tr>
   	<tr>
 		<td>
			원부재료명
  		</td>
  		<td>
  			<input type="text" class="form-control" id="part_nm" readonly placeholder="click here"/>
  			<input type="hidden" class="form-control" id="part_cd" readonly/>
  			<input type="hidden" class="form-control" id="part_rev_no" readonly/>
  			<input type="hidden" class="form-control" id="trace_key" readonly/>
  			<input type="hidden" class="form-control" id="seq_no" readonly/>
  			<input type="hidden" class="form-control" id="balju_no" readonly/>
  			<input type="hidden" class="form-control" id="balju_rev_no" readonly/>
  		</td>
  	</tr>
 	<tr>
 		<td>
			규격적부
  		</td>
  		<td>
  			<input type="radio" name="standard_yn" id="standard_yn" value="적합" checked/>적합 &nbsp;
  			<input type="radio" name="standard_yn" id="standard_yn" value="부적합"/>부적합
  		</td>
  	</tr>
  	<tr>
		<td>
			포장상태
		</td>
	    <td>
			<input type="radio" name="packing_status" id="packing_status" value="적합" checked/>적합 &nbsp;
  			<input type="radio" name="packing_status" id="packing_status" value="부적합"/>부적합
		</td>
	</tr>
	<tr>
		<td>
			육안검사
		</td>
	    <td>
			<input type="radio" name="visual_inspection" id="visual_inspection" value="양호" checked/>양호 &nbsp;
  			<input type="radio" name="visual_inspection" id="visual_inspection" value="불량"/>불량
		</td>
	</tr>
	<tr>
		<td>
			차량청결상태
		</td>
	    <td>
			<input type="radio" name="car_clean" id="car_clean" value="양호" checked/>양호 &nbsp;
  			<input type="radio" name="car_clean" id="car_clean" value="불량"/>불량
		</td>
	</tr>
	<tr>
		<td>
			시험성적서 구비유무
		</td>
	    <td>
			<input type="radio" name="docs_yn" id="docs_yn" value="유" checked/>유 &nbsp;
  			<input type="radio" name="docs_yn" id="docs_yn" value="무"/>무
		</td>
	</tr>
	<tr>
		<td>
			부적합품 조치사항
		</td>
	    <td>
			<input type="radio" name="unsuit_action" id="unsuit_action" value="반품" checked/>반품 &nbsp;
  			<input type="radio" name="unsuit_action" id="unsuit_action" value="폐기"/>폐기 &nbsp;
  			<input type="radio" name="unsuit_action" id="unsuit_action" value=""/>조치사항 없음
		</td>
	</tr>
	<tr>
		<td>
			확인
		</td>
	    <td>
			<input type="radio" name="check_yn" id="check_yn" value="O" checked/>O &nbsp;&nbsp;&nbsp;
  			<input type="radio" name="check_yn" id="check_yn" value="X"/>X
		</td>
	</tr>
</table>