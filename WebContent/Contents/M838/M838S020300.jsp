<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="mes.client.comm.*" %>
<%@ page import="mes.client.guiComponents.*" %>
<%@ page import="mes.client.util.*" %>
<%@ page import="mes.client.conf.*" %>
<%  	
	String loginID = session.getAttribute("login_id").toString();
	String member_key = session.getAttribute("member_key").toString();
	
	if(loginID==null||loginID.equals("")){                            			// id가 Null 이거나 없을 경우
		response.sendRedirect(Config.this_SERVER_path + "/Contents/index.jsp"); // 로그인 페이지로 리다이렉트 한다.
	}

	String sMenuTitle = request.getParameter("MenuTitle").toString();
	String sProgramId = request.getParameter("programId").toString();
	String sHeadmenuID= request.getParameter("HeadmenuID").toString();
	String sHeadmenuName= request.getParameter("HeadmenuName").toString();
	
	Get_Program_button_Autho prg_autho = new Get_Program_button_Autho(loginID,sProgramId);	
%>

 <script type="text/javascript">
 	var record_seq_no 		 = "";
	var checklist_id 		 = "checklist08"; // 체크리스트 아이디
	var checklist_rev_no 	 = 0;
	var unsuit_date 		 = "";
	var unsuit_detail 		 = "";
	var unsuit_reason 		 = "";
	var improve_action 		 = "";
	var improve_action_check = "";
	var person_writer 		 = "";
 	var person_write_id 	 = "";
 	var person_checker 		 = "";
 	var person_check_id 	 = "";
 	var person_approver 	 = "";
 	var person_approve_id 	 = "";

 	
    $(document).ready(function () {
	    new SetRangeDate("dateParent", "dateRange", 180);
	      
		startDate = $('#dateRange').data('daterangepicker').startDate.format('YYYY-MM-DD');
		endDate = $('#dateRange').data('daterangepicker').endDate.format('YYYY-MM-DD');
		fn_MainInfo_List(startDate, endDate);
		
		$("#InfoContentTitle").html("수정일지 목록");
		fn_MainSubMenuSelect("<%=sMenuTitle%>");        	
		fn_tagProcess();
		
		 $('#dateRange').change(function() {
	      fn_MainInfo_List(startDate, endDate);
	     });
		 
	});

    function fn_tagProcess(){
    	var vSelect = <%=prg_autho.vSelect%>;
    	var vInsert = <%=prg_autho.vInsert%>;
    	var vUpdate = <%=prg_autho.vUpdate%>;
    	var vDelete = <%=prg_autho.vDelete%>;
    	
		if(vSelect == "0") {
	    	$('button[id="select"]').each(function () {
                $(this).prop("disabled",true);
            });
   		}
		if(vInsert == "0") {
	    	$('button[id="insert"]').each(function () {
                $(this).prop("disabled",true);
            });
   		}
		if(vUpdate == "0") {
	    	$('button[id="update"]').each(function () {
                $(this).prop("disabled",true);
                $(this).attr("onclick", " ");
            });
   		}
		if(vDelete == "0") {
	    	$('button[id="delete"]').each(function () {
                $(this).prop("disabled",true);
            });
   		}
    }
        
    function fn_MainInfo_List(startDate, endDate) {
        $.ajax({
            type: "POST",
            url: "<%=Config.this_SERVER_path%>/Contents/Business/M838/S838S020300.jsp",
            data: "From=" + startDate + 
            	  "&To=" + endDate,
            success: function (html) {
                $("#MainInfo_List_contents").hide().html(html).fadeIn(100);
            }
        });
        
        $("#SubInfo_List_contents").children().remove(); 
    }
    
    // 점검표 조회
    function displayChecklist(element) {
    	let ajaxUrl = '<%=Config.this_SERVER_path%>/Contents/CheckList/getChecklistFormat.jsp';
    	
    	let jObj = new Object();
    	jObj.checklistId = checklist_id;
    	jObj.checklistRevNo = checklist_rev_no;
    	jObj.checklistDate = unsuit_date;
		let ajaxParam = JSON.stringify(jObj);

    	$.ajax({
    		url: ajaxUrl,
    		data: {"ajaxParam" : ajaxParam},
    		success: function(rcvData) {
    			const format = rcvData[0][0];	// 이미지 파일
    			const page = rcvData[0][1];		// jsp 페이지
    			
		    	const modalUrl = '<%=Config.this_SERVER_path%>' + page
		    				    + '?format=' + format
		    				    + '&checklist_id=' + checklist_id 
		    				    + '&checklistRevNo=' + checklist_rev_no
		    				    + '&unsuit_date=' + unsuit_date
		    				    + '&record_seq_no=' + record_seq_no;
		    				   
				const footer = "<button type='button' class='btn btn-outline-primary'"
					 + "onclick='printChecklist()'>출력</button>";
				const title = element.innerText;
				const heneModal = new HenesysModal(modalUrl, 'auto', title, footer);
				heneModal.open_modal();
    		}
    	});
    }
	
    //자동기록관리 시스템 수정일지 등록
    function haccpInsert(obj) {
    	var url = "<%=Config.this_SERVER_path%>/Contents/Business/M838/S838S020301.jsp"
    				+ '?checklist_id=' + checklist_id 
    				+ '&checklist_rev_no=' + checklist_rev_no;
		var footer = '<button id="btn_Save" class="btn btn-info" onclick="SaveOderInfo();">저장</button>';
		var title = obj.innerText;
		var heneModal = new HenesysModal(url, 'standard', title, footer);
		heneModal.open_modal();
    }
    
    //자동기록관리 시스템 수정일지 수정
    function haccpUpdate(obj) {
    	
    	if(record_seq_no.length < 1){
    		heneSwal.warning('수정할 수정일지를 선택하세요');
    		return false;
    	}
    	
    	var url = "<%=Config.this_SERVER_path%>/Contents/Business/M838/S838S020302.jsp"
    				+ '?checklist_id=' + checklist_id 
    				+ '&checklist_rev_no=' + checklist_rev_no
    				+ '&record_seq_no=' + record_seq_no
 				   	+ '&unsuit_date=' + unsuit_date
 				   	+ '&unsuit_detail=' + unsuit_detail
 					+ '&unsuit_reason=' + unsuit_reason
 				   	+ '&improve_action=' + improve_action
 				   	+ '&improve_action_check=' + improve_action_check
 				   	+ '&person_write_id=' + person_write_id
 				    + '&person_writer=' + person_writer
 				   	+ '&person_check_id=' + person_check_id
		    		+ '&person_checker=' + person_checker
    				+ '&person_approve_id=' + person_approve_id
		    		+ '&person_approver=' + person_approver;
 				   
		var footer = '<button id="btn_Save" class="btn btn-info" onclick="SaveOderInfo();">저장</button>';
		var title = obj.innerText;
		var heneModal = new HenesysModal(url, 'standard', title, footer);
		heneModal.open_modal();
    }
    
    //자동기록관리 시스템 수정일지 삭제
    function haccpDelete(obj) {
    	
    	if(record_seq_no.length < 1){
    		heneSwal.warning('삭제할 수정일지를 선택하세요');
    		return false;
    	} else{
    		SaveOderInfo();
    	}
    	
    	function SaveOderInfo() {
        	
    	        var dataJson = new Object();
    			
    			dataJson.record_seq_no 	= record_seq_no;
            	
    			var JSONparam = JSON.stringify(dataJson);
    			var chekrtn = confirm("삭제하시겠습니까?"); 
    			
    			if(chekrtn) {
    				SendTojsp(JSONparam, "M838S020300E103");
    			} else{
    			       return false;
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
    					heneSwal.success('수정일지 삭제가 완료되었습니다');

    					$('#modalReport').modal('hide');
    	        		parent.fn_MainInfo_List(startDate, endDate);
    	        		parent.$('#SubInfo_List_contents').hide();
    	         	} else {
    					heneSwal.error('수정일지 삭제에 실패했습니다, 다시 시도해주세요');	         		
    	         	}
    	         }
    	     });
    	}
    }
    
</script>
    
    <!-- Content Header (Page header) -->
	<div class="content-header">
  		<div class="container-fluid">
    		<div class="row mb-2">
	      		<div class="col-sm-6">
	        		<h1 class="m-0 text-dark" id="MenuTitle">여기에 메뉴 타이틀</h1>
	      		</div>
	      		<div class="col-sm-6">
	      			<div class="float-sm-right">
	      				<button type="button" onclick="haccpInsert(this)" 
	      				  		  id="insert" class="btn btn-outline-dark">
	      					수정일지 등록
	      				</button>
	      				<button type="button" onclick="haccpUpdate(this)" 
	      				  		  id="update" class="btn btn-outline-success">
	      					수정일지 수정
	      				</button>
	      				<button type="button" onclick="haccpDelete(this)" 
	      				  		  id="delete" class="btn btn-outline-danger">
	      					수정일지 삭제
	      				</button>
	      				<button type="button" onclick="displayChecklist(this)" 
	      				  	 	class="btn btn-outline-dark">
	      					수정일지 조회
	      				</button>
	      			</div>
	      		</div>
     		</div><!-- /.row -->
		</div><!-- /.container-fluid -->
	</div>
	<!-- /.content-header -->
    
    <!-- Main content -->
		<div class="content">
  			<div class="container-fluid">
    			<div class="row">
      				<div class="col-md-12">
        				<div class="card card-primary card-outline">
          			<div class="card-header">
          					<h3 class="card-title">
          						<i class="fas fa-edit" id="InfoContentTitle"></i>
          					</h3>
          			<div class="card-tools">
          	  	<div class="input-group input-group-sm" id="dateParent">
          	  		<input type="text" class="form-control float-right" id="dateRange">
          	  	<div class="input-group-append">
          	  	  <button type="submit" class="btn btn-default">
          	  	    <i class="fas fa-search"></i>
          	  	  </button>
          	  	</div>
          	  </div>
          	</div>
          </div>
          <div class="card-body" id="MainInfo_List_contents"></div> 
        </div>
      </div>
      <!-- /.col-md-6 -->
    </div>
    <!-- /.row -->
  </div><!-- /.container-fluid -->
</div>
<!-- /.content -->