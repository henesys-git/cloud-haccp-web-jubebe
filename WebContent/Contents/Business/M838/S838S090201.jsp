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
S838S090201.jsp
클레임 제품 등록
*/
	String loginID = session.getAttribute("login_id").toString();
	String member_key = session.getAttribute("member_key").toString();
	
	String checklist_id = "", checklist_rev_no = "";
	
	if(request.getParameter("checklist_id") != null)
		checklist_id = request.getParameter("checklist_id");	

	if(request.getParameter("checklist_rev_no") != null)
		checklist_rev_no = request.getParameter("checklist_rev_no");
%>
<style>
.modal-body {
    padding-bottom: 0;
}

#claim_table tr td {
	vertical-align: middle;
}

#claim_table textarea {
	width : 100%;
	height : 130px;
}
</style>
<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>      
<script type="text/javascript">
    $(document).ready(function () {
		new SetSingleDate2("", "#claim_date", 0);
    });	
	
    // 주소검색
    function sample6_execDaumPostcode() {
        new daum.Postcode({
            oncomplete: function(data) {

                // 각 주소의 노출 규칙에 따라 주소를 조합한다.
                // 내려오는 변수가 값이 없는 경우엔 공백('')값을 가지므로, 이를 참고하여 분기 한다.
                var addr = ''; // 주소 변수
                var extraAddr = ''; // 참고항목 변수

                //사용자가 선택한 주소 타입에 따라 해당 주소 값을 가져온다.
                if (data.userSelectedType === 'R') { // 사용자가 도로명 주소를 선택했을 경우
                    addr = data.roadAddress;
                } else { // 사용자가 지번 주소를 선택했을 경우(J)
                    addr = data.jibunAddress;
                }

                // 사용자가 선택한 주소가 도로명 타입일때 참고항목을 조합한다.
                if(data.userSelectedType === 'R'){
                    // 법정동명이 있을 경우 추가한다. (법정리는 제외)
                    // 법정동의 경우 마지막 문자가 "동/로/가"로 끝난다.
                    if(data.bname !== '' && /[동|로|가]$/g.test(data.bname)){
                        extraAddr += data.bname;
                    }
                    // 건물명이 있고, 공동주택일 경우 추가한다.
                    if(data.buildingName !== '' && data.apartment === 'Y'){
                        extraAddr += (extraAddr !== '' ? ', ' + data.buildingName : data.buildingName);
                    }
                    // 표시할 참고항목이 있을 경우, 괄호까지 추가한 최종 문자열을 만든다.
                    if(extraAddr !== ''){
                        extraAddr = ' (' + extraAddr + ')';
                    }
                
                } 
                // $("#person_report_addr") 에 focus로 종료 >> , 뒤에 상세주소 
                $("#person_report_addr").val(addr + ", ");
            }
        }).open();
    }
    
    
    function inputNullCheck() {

    	let flag = true; 
    	
		$(".notNull").each(function() {
			
			if($(this).val() == "" || $(this).val() == null){
				
				heneSwal.warningTimer('빈칸을 모두 입력해주세요.');
				$(this).focus();
				
				flag = false;
				return false;
			}
			
		})
		
		return flag;
	}

	function SendTojsp() {

		var flag = inputNullCheck();
		
		if(flag){
		
			var dataJson = new Object();
			
			dataJson.checklist_id = '<%=checklist_id%>';
			dataJson.checklist_rev_no = '<%=checklist_rev_no%>';
			dataJson.claim_date = $('#claim_date').val();
			
			dataJson.person_receipt = $('#person_receipt').val();		
			dataJson.claim_detail = $('#claim_detail').val();
			dataJson.person_report =  $('#person_report').val();
			dataJson.person_report_addr =  $('#person_report_addr').val();
			dataJson.customer_action = $('#customer_action').val();
			dataJson.company_action = $('#company_action').val();
			dataJson.person_write_id = '<%=loginID%>';
			
			var JSONparam = JSON.stringify(dataJson);
			var chekrtn = confirm("등록하시겠습니까?"); 
			
			if(chekrtn) {
	
				$.ajax({
			        type: "POST",
			        dataType: "json",
			        url: "<%=Config.this_SERVER_path%>/Contents/CommonView/insert_update_delete_json.jsp", 
			        data:  {"bomdata" : JSONparam, "pid" : "M838S090200E101"},
					success: function (html) {	
						if(html > -1) {
							heneSwal.success('기록부 등록이 완료되었습니다');
	
							$('#modalReport').modal('hide');
			        		parent.fn_MainInfo_List(startDate, endDate);
			        		parent.$('#SubInfo_List_contents').hide();
			         	} else {
							heneSwal.error('기록부 등록 실패했습니다, 다시 시도해주세요');	         		
			         	}
			         }
			     });
				
			}
		}
	}
</script>

<table class="table" id="claim_table">
	<tr>
		<td>
			접수일시
		</td>
	    <td colspan = 2>
			<input type="text" data-date-format="yyyy-mm-dd" id="claim_date" class="form-control notNull">
		</td>
	</tr>
   	<tr>
 		<td>
			접수자
  		</td>
  		<td colspan = 2>
  			<input type="text" class="form-control notNull" id="person_receipt"/>
  		</td>
  	</tr>
 	<tr>
 		<td>
			불평/불만 내용
  		</td>
  		<td colspan = 2>
  			<textarea id = "claim_detail" class="form-control notNull" ></textarea>
  		</td>
  	</tr>
  	<tr>
		<td rowspan = 2>
			제기자	
		</td>
	    <td>
			이름
		</td>
		<td style = "width : 300px;">
			<input type="text" class="form-control notNull" id="person_report"/>
		</td>
	</tr>
	<tr>
	    <td>
			주소
		</td>
		<td>
			<input type="text" class="form-control notNull" id="person_report_addr" onclick="sample6_execDaumPostcode()"/>
		</td>
	</tr>
	<tr>
		<td rowspan = 2>
			평가 및 조치
		</td>
	    <td>
			내부조치
		</td>
		 <td>
			<textarea id = "company_action" class="form-control notNull" ></textarea>
		</td>
	</tr>
 	<tr>
	    <td>
			고객에 <br>대한 조치
		</td>
		<td>
			<textarea id = "customer_action" class="form-control notNull" ></textarea>
		</td>
	</tr>
</table>