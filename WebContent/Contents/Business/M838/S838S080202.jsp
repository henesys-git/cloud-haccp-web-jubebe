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
S838S080202.jsp
HACCP 팀 회의록 수정
*/
	String loginID = session.getAttribute("login_id").toString();
	String member_key = session.getAttribute("member_key").toString();
	
	String checklist_id = "", checklist_rev_no = "" , seq_no ="";
	
	String meeting_date = "", meeting_topic = "", meeting_detail = "",
		   meeting_result = "", attendees_cnt = "", bigo = "";
	
	String[] list = {"checklist_id","checklist_rev_no","seq_no","meeting_date","meeting_topic","meeting_detail","meeting_result","attendees_cnt","bigo"};
	
	List<String> id_list = new ArrayList<String>(Arrays.asList(list));
	List<String> val_list = new ArrayList<String>();
	
	for(String str : list){

		if(request.getParameter(str) != null){
			str = request.getParameter(str);
		}
		
		val_list.add(str);
	}
	
	// 파일
	String regist_no = "", file_name = "", file_path = "", file_rev_no = "";
	
	if(request.getParameter("regist_no") != null){
		regist_no = request.getParameter("regist_no");
	}
	
	if(request.getParameter("file_name") != null){
		file_name = request.getParameter("file_name");
	}
	
	if(request.getParameter("file_path") != null){
		file_path = request.getParameter("file_path");
	}
	
	if(request.getParameter("file_rev_no") != null){
		file_rev_no = request.getParameter("file_rev_no");
	}
%>   
<script type="text/javascript">
    $(document).ready(function () {
    	
		new SetSingleDate2("", "#meeting_date", 0);
		new SetSingleDate2("", "#bigo", 0);

		var id_list = '<%= id_list %>';
		var val_list = '<%= val_list %>';
		
		id_list = id_list.slice(1,-1).split(",");
		val_list = val_list.slice(1,-1).split(",");
		
 		for(x in id_list){
			
			$('#'+id_list[x].trim()).val(val_list[x].trim());
			
		}
	
		var fileFrmShow = '<%=file_path%>';
		
		if(fileFrmShow == "" || fileFrmShow == null){
			$("#update_form").show();
			$("#attached_document").hide();
			$("#fileDelete").hide();
		} else {
			$("#attached_document").show();
			$("#fileDelete").show();
			$("#update_form").hide();
		}
		
		// 파일 삭제
		$("#fileDelete").click(function() {
			
			var chekrtn = confirm("파일을 삭제하시겠습니까?");
			
			if(chekrtn) {
			
				 var dataJson = new Object();
				 dataJson.seq_no = '<%=val_list.get(2)%>';
				 var JSONparam = JSON.stringify(dataJson);
				
				 $.ajax({
				        type: "POST",
				        dataType: "json",
				        url: "<%=Config.this_SERVER_path%>/Contents/CommonView/insert_update_delete_json.jsp", 
				        data:  {"bomdata" : JSONparam, "pid" : "M838S080200E113"},
						success: function (html) {	
							if(html > -1) {
								alert("파일이 삭제되었습니다.");
								$("#attached_document").hide();
								$("#fileDelete").hide();
								$("#update_form").show();
							} else {
								alert("파일 삭제에 실패했습니다.");
				         	}
				         }
			     }); // ajax
			} // if
			
		}); //click
 		
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
	        			
			dataJson.checklist_id = '<%=val_list.get(0)%>';
			dataJson.checklist_rev_no = '<%=val_list.get(1)%>';
			dataJson.seq_no = '<%= val_list.get(2)  %>';
			dataJson.meeting_date = $('#meeting_date').val();
			dataJson.org_meeting_date = $('#org_meeting_date').val();
			dataJson.meeting_topic = $('#meeting_topic').val();	
			dataJson.meeting_detail = $('#meeting_detail').val();
			dataJson.meeting_result = $('#meeting_result').val();	
			dataJson.attendees_cnt = $('#attendees_cnt').val();
			dataJson.bigo = $('#bigo').val();
			dataJson.person_write_id = '<%=loginID%>';
        	
			var JSONparam = JSON.stringify(dataJson);
			var chekrtn = confirm("수정하시겠습니까?"); 
			
			if(chekrtn) {
				SendTojsp(JSONparam, "M838S080200E102");
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
						
						heneSwal.success('희의록 수정이 완료되었습니다');
						
    					$('#modalReport').modal('hide');
    	        		parent.fn_MainInfo_List(startDate, endDate);						
					} else {
						
						var form = $('#update_form')[0];
		                var data = new FormData(form);
		                
		                data.append("pid", 			$('#txt_pid').val());
		                data.append("user_id", 		$('#txt_user_id').val());
		                data.append("orderno", 		$('#txt_orderno').val());
		                data.append("order_detail", $('#txt_order_detail').val());
		                data.append("jspPage", 		$('#txt_jspPage').val());
		                data.append("getnum_prefix", "HACCP");
		                data.append("regist_no", $('#txt_regist_no').val());
		                data.append("JobType", $('#txt_JobType').val());
		                
		                data.append("docname", 		$('#txt_docname').val());
		                data.append("doccode", 		$('#txt_doccode').val());
		                data.append("rev_no", 		parseInt($('#txt_rev_no').val()) + 1);
		                data.append("doc_gubun", 	$('#txt_doc_gubun').val());
		                
		                data.append("member_key", '107-86-81841'); 		// 관리본여부
		                data.append("seq_no", '<%=val_list.get(2)%>'); 		
	
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
	
		        					heneSwal.success('희의록 수정이 완료되었습니다');
	
		        					$('#modalReport').modal('hide');
		        	        		parent.fn_MainInfo_List(startDate, endDate);
		        				} else {
		        					heneSwal.errorTimer("희의록 수정 실패했습니다, 다시 시도해주세요");
		        				}
		        			},
		           	        error: function (e) {
		        				$("#result").text(e.responseText);
		           	        }
		           	    });
		                
					}
	    
	         	} else {
					heneSwal.error('회의록 수정에 실패했습니다, 다시 시도해주세요');	         		
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
			<input type="text" data-date-format="yyyy-mm-dd" id="meeting_date" class="form-control notNull">
			<input type="hidden" data-date-format="yyyy-mm-dd" id="org_meeting_date" class="form-control" value = '<%= val_list.get(3) %>'>
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
			<input type="text" id="meeting_topic" class="form-control notNull">
		</td>
	</tr>
	<tr>
		<td>
			회의내용
		</td>
	    <td>
		    <textarea class="form-control notNull" id="meeting_detail"></textarea>
	    </td>
	</tr>
	<tr>
		<td>
			회의결과
		</td>
	    <td>
		    <textarea class="form-control notNull" id="meeting_result"></textarea>
	    </td>
	</tr>
	<tr>
		<td>
			참석인원
		</td>
	    <td>
			<div class="input-group">
	  			<input type="number" class="form-control notNull" id="attendees_cnt" min = "0">
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
			<input type="hidden" class="form-control" id="txt_pid" name="pid"  value="M838S080200E112"> 
			<input type="hidden" class="form-control" id="txt_user_id" name="user_id"  value="henesys"> 
			<input type="hidden" class="form-control" id="txt_orderno" name="orderno" value="0" > 
			<input type="hidden" class="form-control" id="txt_order_detail" name="order_detail" value="1" > 
			<input type="hidden" class="form-control" id="txt_jspPage" name="jspPage"  value="M838S080202.jsp"> 
			<input type="hidden" class="form-control" id="txt_getnum_prefix" name="getnum_prefix"  value="수정시 prefix 필요 없음"> 
			<input type="hidden" class="form-control" id="txt_JobType" name="JobType" value="UPDATE" > 
			<input type="hidden" class="form-control" id="txt_docname" name="docname" value="<%= file_name %>">
			<input type="hidden" class="form-control" id="txt_regist_no" name="regist_no" value="<%= regist_no %>">
			<input type="hidden" class="form-control" id="txt_doccode" name="doccode" value = "M838S080200" > 
			<input type="hidden" class="form-control" id="txt_rev_no" name="rev_no" value = "<%= file_rev_no %>" > 
			<input type="hidden" class="form-control" id="txt_doc_gubun" name="doc_gubun"  value="<%= file_name %>" > 
	    <!-- ///////////////////////////////////////////////////////////////////////////////////  -->	
			<form id="update_form" enctype="multipart/form-data" action="<%= request.getContextPath() %>/hcp_EdmsServerServlet" method="post">
				<input type="file" id="idFilename" name="filenames" multiple="multiple" class="form-control" style = "height: 0%;">
			</form>		
			<input type="text" id="attached_document" name = "attached_document" value = "<%= file_name %>" class="form-control" disabled><i id = "fileDelete" class="fas fa-times" style ="left:91%;"></i>
		</td>
	</tr>
</table>