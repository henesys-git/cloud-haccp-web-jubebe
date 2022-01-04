<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="mes.client.comm.*" %>
<%@ page import="mes.client.common.*" %>
<%@ page import="mes.client.guiComponents.*" %>
<%@ page import="mes.client.util.*" %>
<%@ page import="mes.client.conf.*" %>
<%
/* 
(검수 원부자재 입고 등록) S202S030101.jsp
yumsam
*/
	String loginID = session.getAttribute("login_id").toString();
	String member_key = session.getAttribute("member_key").toString();
	String history_yn = session.getAttribute("history_yn").toString();

	String GV_TRACE_KEY = "", GV_BALJUNO = "",
		   GV_PART_CD = "", GV_PART_CD_REV = "", 
		   GV_PART_NAME = "", GV_BALJU_REV_NO = "",
		   GV_BALJU_AMT = "";
	
	if(request.getParameter("TraceKey") != null)
		GV_TRACE_KEY = request.getParameter("TraceKey");
	
	if(request.getParameter("BaljuNo") != null)
		GV_BALJUNO = request.getParameter("BaljuNo");

	if(request.getParameter("BaljuRevNo") != null)
		GV_BALJU_REV_NO = request.getParameter("BaljuRevNo");
	
	if(request.getParameter("PartCd") != null)
		GV_PART_CD = request.getParameter("PartCd");
	
	if(request.getParameter("PartRevNo") != null)
		GV_PART_CD_REV = request.getParameter("PartRevNo");
	
	if(request.getParameter("PartNm") == null)
		GV_PART_NAME = "";
	else
		GV_PART_NAME = request.getParameter("PartNm");
	
	if(request.getParameter("BaljuAmt") == null)
		GV_BALJU_AMT = "";
	else
		GV_BALJU_AMT = request.getParameter("BaljuAmt");
	
	String initIpgoTypeCode = "PART_IPGO_TYPE001";
	Vector ipgoTypeCode = null;
    Vector ipgoTypeName = null;
    Vector ipgoTypeList = CommonData.getPartIpgoType();
%>

<script type="text/javascript">
	
    $(document).ready(function () {
    	
    	new SetSingleDate2("", "#txt_ipgo_date", 0);
    	new SetSingleDate2("", "#txt_expiration_date", 0);
    	
	    // 숫자만
	    $("input:text[numberOnly]").on("keyup", function() {
	        $(this).val($(this).val().replace(/[^0-9]/g,""));
	    });
		
	 	// 숫자 또는 소수점만
	 	$("input:text[numberPoint]").on("keyup", function() {
	 		$(this).val($(this).val().replace(/[^0-9.]/g,""));
	 	});
	 	
	 	var io_amt = '<%=GV_BALJU_AMT%>';
	 	
	 	const amt = io_amt.replace(",", "");
	 	
	 	$('#txt_io_count').val(amt);
    });
    
	function SaveOderInfo() {		
    	if($('#txt_part_cd').val() == ""){
			alert("좌측 원부자재 중 하나를 선택하여 주세요.");
 			return;
    	}

    	if($('#txt_expiration_date').val() == ""){
			alert("유통기한을 입력하여 주세요.");
 			return;
    	}
		
		if($('#txt_io_count').val() == '') {
			alert("입고수량을 입력하세요");
			return false;
		} else {
	        var dataJson = new Object();
	        var jArray = new Array();
	        
	        dataJson.balju_no = "<%=GV_BALJUNO%>";
	        dataJson.balju_rev_no = <%=GV_BALJU_REV_NO%>;
		    dataJson.part_cd = $('#txt_part_cd').val();
		    dataJson.part_rev_no = <%=GV_PART_CD_REV%>;
		    dataJson.io_count = $('#txt_io_count').val();
		    dataJson.ipgo_type = $('#ipgo_type').val();
		    dataJson.bigo = $('#txt_bigo').val();
		    dataJson.trace_key = <%=GV_TRACE_KEY%>;
			dataJson.warehousing_date = $('#txt_ipgo_date').val();
			dataJson.expiration_date = $('#txt_expiration_date').val();
			
        	jArray.push(dataJson);
		}

		var JSONparam = JSON.stringify(dataJson);
		var chekrtn = confirm("등록하시겠습니까?"); 
		
		if(chekrtn) {
			SendTojsp(JSONparam, "M202S030100E101");
		}
	}
    
	function SendTojsp(bomdata, pid) {
		$.ajax({
			type: "POST",
			dataType: "json",
			url: "<%=Config.this_SERVER_path%>/Contents/CommonView/insert_update_delete_json.jsp", 
			data: {"bomdata" : bomdata, "pid" : pid},
			success: function (html) {	
				if(html > -1) {
					heneSwal.success('입고 등록이 완료되었습니다');
					$('#modalReport').modal('hide');
					parent.fn_MainInfo_List(startDate, endDate);
				} else {
					heneSwal.error('입고 등록 실패했습니다');
				}
			}
		});		
	}
</script>
	
<div style="width: 100%">
	<table class="table">
		<tr>
			<td>
       			입고일자
       		</td>
       		<td>
				<input type="text" data-date-format="yyyy-mm-dd" id="txt_ipgo_date" class="form-control">
       		</td>
       	</tr>
       	<tr>
       		<td>
       			원부자재 코드
       		</td>
       		<td>
       			<input type="text" class="form-control" id="txt_part_cd" readonly value=<%=GV_PART_CD%>>
       		</td>
       	</tr>
       	<tr>
       		<td>
       			원부자재 명
       		</td>
       		<td>
       			<input type="text" class="form-control" id="txt_part_name" readonly value=<%=GV_PART_NAME%>>
       		</td>
       	</tr>
       	<tr>
       		<td>
       			입고 수량
       		</td>
       		<td>
       			<input type="number" class="form-control" id="txt_io_count" value=<%=GV_BALJU_AMT%>>
       		</td>
       	</tr>
        <tr>
       		<td>
       			유통 기한
       		</td>
       		<td>
       			<input type="text" data-date-format="yyyy-mm-dd" id="txt_expiration_date" class="form-control">
       		</td>
       	</tr>
       	<tr>
		<td>
			입고 타입
		</td>
	  	<td>
			<select class="form-control" id="ipgo_type">
	        	<% ipgoTypeCode = (Vector) ipgoTypeList.get(1);%>
	            <% ipgoTypeName = (Vector) ipgoTypeList.get(2);%>
	            <% for(int i = 0; i < ipgoTypeName.size(); i++) { %>
					<option value='<%=ipgoTypeName.get(i).toString()%>' 
						<%=initIpgoTypeCode.equals(ipgoTypeCode.get(i).toString()) ? "selected" : "" %>>
						<%=ipgoTypeName.get(i).toString()%>
					</option>
				<%} %>
			</select>
		</td>
  		</tr>
       	<tr>
       		<td>
       			비고
       		</td>
       		<td>
       			<input type="text" class="form-control" id="txt_bigo">
       		</td>
       	</tr>
	</table>
</div>