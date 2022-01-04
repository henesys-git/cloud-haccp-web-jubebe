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
S838S090202.jsp
클레임 제품 등록
*/
	String loginID = session.getAttribute("login_id").toString();
	String member_key = session.getAttribute("member_key").toString();
	
	String checklist_id = "", checklist_rev_no = "", seq_no = "";
		   
	if(request.getParameter("checklist_id") != null)
		checklist_id = request.getParameter("checklist_id");	

	if(request.getParameter("checklist_rev_no") != null)
		checklist_rev_no = request.getParameter("checklist_rev_no");
	
	if(request.getParameter("seq_no") != null)
		seq_no = request.getParameter("seq_no");

	JSONObject jArray = new JSONObject();
	jArray.put("seq_no", seq_no);
	jArray.put("checklist_id", checklist_id);
	jArray.put("checklist_rev_no", checklist_rev_no);

	DoyosaeTableModel table = new DoyosaeTableModel("M838S090200E144", jArray);
	MakeGridData tData = new MakeGridData(table);
	
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
    	
		new SetSingleDate2("<%= table.getValueAt(0, 3) %>", "#claim_date", 0);
		
		var dataArr = <%= tData.getDataArray() %>;
		
		$(".claim_input").each(function(idx) {

			dataArr[0][(idx+3)] = dataArr[0][(idx+3)].replace(/(<br>|<br\/>|<br \/>)/g, '\r\n');
			
			$(this).val(dataArr[0][(idx+3)]);
						
		});
		
    });	
	
 	// 주소검색
    function sample6_execDaumPostcode() {
        new daum.Postcode({
            oncomplete: function(data) {

                var addr = ''; // 주소 변수
                var extraAddr = ''; // 참고항목 변수

                if (data.userSelectedType === 'R') { 
                    addr = data.roadAddress;
                } else { 
                    addr = data.jibunAddress;
                }

                if(data.userSelectedType === 'R'){
                	
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

                $("#person_report_addr").val(addr + ", ");
            }
        }).open();
    }
	
	function inputNullCheck() {

    	let flag = true; 
    	
		$(".claim_input").each(function() {
			
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
			dataJson.seq_no = '<%=seq_no%>';
			dataJson.claim_date = $('#claim_date').val();
			dataJson.org_claim_date = $('#org_claim_date').val();
			
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
				        data:  {"bomdata" : JSONparam, "pid" : "M838S090200E102"},
						success: function (html) {	
							if(html > -1) {
								heneSwal.success('기록부 수정이 완료되었습니다');

								$('#modalReport').modal('hide');
				        		parent.fn_MainInfo_List(startDate, endDate);
				        		parent.$('#SubInfo_List_contents').hide();
				         	} else {
								heneSwal.error('기록부 수정에 실패했습니다, 다시 시도해주세요');	         		
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
			<input type="text" data-date-format="yyyy-mm-dd" id="claim_date" class="form-control claim_input">
			<input type="hidden" data-date-format="yyyy-mm-dd" id="org_claim_date" class="form-control" value = "<%=table.getValueAt(0, 3)%>">
		</td>
	</tr>
   	<tr>
 		<td>
			접수자
  		</td>
  		<td colspan = 2>
  			<input type="text" class="form-control claim_input" id="person_receipt"/>
  		</td>
  	</tr>
 	<tr>
 		<td>
			불평/불만 내용
  		</td>
  		<td colspan = 2>
  			<textarea id = "claim_detail" class="form-control claim_input" class="form-control" ></textarea>
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
			<input type="text" class="form-control claim_input" id="person_report"/>
		</td>
	</tr>
	<tr>
	    <td>
			주소
		</td>
		<td>
			<input type="text" class="form-control claim_input" id="person_report_addr" onclick="sample6_execDaumPostcode()"/>
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
			<textarea id = "company_action" class="form-control claim_input" class="form-control" ></textarea>
		</td>
	</tr>
 	<tr>
	    <td>
			고객에 <br>대한 조치
		</td>
		<td>
			<textarea id = "customer_action" class="form-control claim_input" class="form-control" ></textarea>
		</td>
	</tr>
</table>