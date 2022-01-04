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
S838S080201.jsp
HACCP팀 회의록 등록
*/
	String loginID = session.getAttribute("login_id").toString();
	String member_key = session.getAttribute("member_key").toString();
	
	String checklist_id = "";
	
	if(request.getParameter("checklist_id") != null)
		checklist_id = request.getParameter("checklist_id");	

%>
 <script type="text/javascript">
    $(document).ready(function () {
    	
		new SetSingleDate2("", "#meeting_date", 0);
		new SetSingleDate2("", "#bigo", 0);
		
    });	
	
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
    
	function SaveOderInfo() {
    			
		var flag = inputNullCheck();
		
		if(flag){
			
			 var dataJson = new Object();
 			
				dataJson.checklist_id = '<%=checklist_id%>';
				dataJson.meeting_date = $('#meeting_date').val();
				dataJson.meeting_topic = $('#meeting_topic').val();	
				dataJson.meeting_detail = $('#meeting_detail').val();
				dataJson.meeting_result = $('#meeting_result').val();
				dataJson.attendees_cnt = $('#attendees_cnt').val();
				dataJson.bigo = $('#bigo').val();
				dataJson.person_write_id = '<%=loginID%>';
		       	
				var JSONparam = JSON.stringify(dataJson);
				var chekrtn = confirm("등록하시겠습니까?"); 
				
				if(chekrtn) {
					SendTojsp(JSONparam, "M838S080200E101");
				}
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
					if($("#idFilename").val() == "" || $("#idFilename").val() == null){
						
	        			heneSwal.success('회의록 등록이 완료되었습니다');

						$('#modalReport').modal('hide');
		        		parent.fn_MainInfo_List(startDate, endDate);
		        		parent.$('#SubInfo_List_contents').hide();
						
					} else {
						
		            	var form = $('#upload_form')[0];
		            	
						var data = new FormData(form);
		                
		                data.append("pid", 			$('#txt_pid').val());
		                data.append("user_id", 		$('#txt_user_id').val());
		                data.append("orderno", 		$('#txt_orderno').val());
		                data.append("order_detail", $('#txt_order_detail').val());
		                data.append("jspPage", 		$('#txt_jspPage').val());
		                data.append("getnum_prefix",$('#txt_getnum_prefix').val());
		                data.append("JobType", 		$('#txt_JobType').val());

		                data.append("regist_no", 	"");
		                data.append("docname", 		$('#txt_docname').val());
		                data.append("doccode", 		$('#txt_doccode').val());
		                data.append("rev_no", 		$('#txt_rev_no').val());
		                data.append("doc_gubun", 	$('#txt_doc_gubun').val());
		                
		                data.append("member_key", '107-86-81841'); 		// 관리본여부

		           	    $.ajax({
		        			type: "POST",
		        			async: true,
		           	        enctype: "multipart/form-data",
		           	        acceptcharset: "UTF-8",
		           	        url: "<%= request.getContextPath() %>/hcp_EdmsServerServlet", 
		           	        data: data,
		           	        processData: false,
		           	        contentType: false,
		        			cache: false,
		           	        timeout: 600000,
		           	        success: function (data) {
		        				if(data.length > 0) {

		        					heneSwal.success('회의록 등록이 완료되었습니다');

		        					$('#modalReport').modal('hide');
		        	        		parent.fn_MainInfo_List(startDate, endDate);
		        	        		parent.$('#SubInfo_List_contents').hide();
		        				} else {
		        					heneSwal.errorTimer("회의록 등록 실패했습니다, 다시 시도해주세요");
		        				}
		        			},
		           	        error: function (e) {
		        				$("#result").text(e.responseText);
		           	        }
		           	    });
		                
					}
	         	} else {
					heneSwal.error('회의록 등록 실패했습니다, 다시 시도해주세요');	         		
	         	}
	         }
	     });
	}
</script>

<table class="table" id="bom_table" style = "margin-bottom: 0;">
	<tr>
		<td>
			회의일자
		</td>
	    <td>
			<input type="text" data-date-format="yyyy-mm-dd" id="meeting_date" class="form-control notNull"/>
		</td>
	</tr>
<!-- 	
   	<tr>
 		<td>
			회의장소
  		</td>
  		<td>
  			<input type="text" class="form-control" id="meeting_place"/>
  		</td>
  	</tr>
 	<tr>
 		<td>
			회의주관
  		</td>
  		<td>
  			<input type="text" class="form-control" id="meeting_runner"/>
  		</td>
  	</tr>
 -->  	
	<tr>
		<td>
			회의주제
		</td>
	    <td>
			<input type="text" id="meeting_topic" class="form-control notNull"/>
		</td>
	</tr>
	<tr>
		<td>
			회의내용
		</td>
	    <td>
		    <textarea class="form-control notNull" id="meeting_detail" ></textarea>
	    </td>
	</tr>
	<tr>
		<td>
			회의결과
		</td>
	    <td>
		    <textarea class="form-control notNull" id="meeting_result" ></textarea>
	    </td>
	</tr>
	<tr>
		<td>
			참석인원
		</td>
	    <td>
			<div class="input-group">
	  			<input type="number" class="form-control notNull" id="attendees_cnt" min = "0"/>
	  			<div class="input-group-append">
				     <span class="input-group-text">명</span>
		        </div>
	        </div>
		</td>
	</tr>
	<tr>
		<td>
			비고 (다음 회의)
		</td>
	    <td>
			<input type="text" data-date-format="yyyy-mm-dd" id = "bigo" name="bigo" class="form-control">
		</td>
	</tr>
	<tr>
		<td>
			첨부자료
		</td>    
	    <td>
			<input type="hidden" class="form-control" id="txt_pid" name="pid"  value="M838S080200E111">
			<input type="hidden" class="form-control" id="txt_user_id" name="user_id"  value="henesys"> 
			<input type="hidden" class="form-control" id="txt_orderno" name="orderno" value="0" > 
			<input type="hidden" class="form-control" id="txt_order_detail" name="order_detail" value="1" > 
			<input type="hidden" class="form-control" id="txt_jspPage" name="jspPage"  value="M838S080201.jsp"> 
			<input type="hidden" class="form-control" id="txt_getnum_prefix" name="getnum_prefix"  value="HACCP"> 
			<input type="hidden" class="form-control" id="txt_JobType" name="JobType" value="INSERT" > 
			<input type="hidden" class="form-control" id="txt_doccode" name="doccode" value = "M838S080200" > 
			<input type="hidden" class="form-control" id="txt_rev_no" name="rev_no" > 
			<input type="hidden" class="form-control" id="txt_doc_gubun" name="doc_gubun" > 
	    <!-- ///////////////////////////////////////////////////////////////////////////////////  -->
			<input type="hidden" id="attached_document" class="form-control">
			<form id="upload_form" enctype="multipart/form-data" action="<%= request.getContextPath() %>/hcp_EdmsServerServlet" method="post">
				<input type="file" id="idFilename" name="filenames" multiple="multiple" class="form-control" style = "height: 0%;">
			</form>
		</td>
	</tr>
</table>