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
 	
 	//메인테이블 변수모음
 	var checklist_id 		= "checklist04";		
	var checklist_rev_no 	= 0;
	var ccp_date 			= "";
	var unsuit_detail  		= "";
	var improve_action_result  	= "";
	var person_writer  		= "";
	var person_write_id 	= "";
	var person_checker  	= "";
	var person_check_id     = "";
	var person_approver  	= "";
    var person_approve_id   = "";
    var person_actioner  	= "";
    var person_action_id   = "";
	//서브테이블 변수모음
	var s_ccp_date 			= "";
	var check_time 			= "";	
	var prod_cd 			= "";
	var prod_nm 			= "";
	var revision_no			= "";
	var fe_only 			= "";
	var sus_only 			= "";
	var prod_only  			= "";
	var fe_with_prod 		= "";
	var sus_with_prod 		= "";
	var result 				= "";
	var person_sign_id 		= "";
	var note_unusual 		= "";
	
 	
    $(document).ready(function () {
	    new SetRangeDate("dateParent", "dateRange", 180);
	      
		startDate = $('#dateRange').data('daterangepicker').startDate.format('YYYY-MM-DD');
		endDate = $('#dateRange').data('daterangepicker').endDate.format('YYYY-MM-DD');
		fn_MainInfo_List(startDate, endDate);
		
		$("#InfoContentTitle").html("모니터링 일지 목록");
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
            url: "<%=Config.this_SERVER_path%>/Contents/Business/M838/S838S015400.jsp",
            data: "From=" + startDate + 
            	  "&To=" + endDate,
            success: function (html) {
                $("#MainInfo_List_contents").hide().html(html).fadeIn(100);
            }
        });
        $("#SubInfo_List_contents").children().remove(); 
    }
    
    function fn_DetailInfo_List() {     
    	$.ajax({
   	    	type: "POST",
   	        url: "<%=Config.this_SERVER_path%>/Contents/Business/M838/S838S015410.jsp",
   	        data: "ccp_date=" + ccp_date +
   	     		  "&checklist_id=" + checklist_id +
   	     		  "&checklist_rev_no=" + checklist_rev_no,
   	        success: function (html) {
   	            $("#SubInfo_List_contents").hide().html(html).fadeIn(100);
   	        }
   	    });
	}
    
    
    // 점검표 조회
    function displayChecklist(element) {
    	
    	if(ccp_date.length < 1){
    		heneSwal.warning('조회할 모니터링 일지를 선택하세요');
    		return false;
    	}
    	
    	let ajaxUrl = '<%=Config.this_SERVER_path%>/Contents/CheckList/getChecklistFormat.jsp';
    	
    	let jObj = new Object();
    	jObj.checklistId = checklist_id;
    	jObj.checklistRevNo = checklist_rev_no;
    	jObj.checklistDate = ccp_date;
		let ajaxParam = JSON.stringify(jObj);

    	$.ajax({
    		url: ajaxUrl,
    		data: {"ajaxParam" : ajaxParam},
    		success: function(rcvData) {
    			const format = rcvData[0][0];	// 이미지 파일
    			const page = rcvData[0][1];		// jsp 페이지
    			
    			console.log('이미지파일:' + format);
    			console.log('JSP페이지:' + page);
    			
		    	const modalUrl = '<%=Config.this_SERVER_path%>' + page
		    					+ '?format=' + format
			    				+ '&checklist_id=' + checklist_id 
			    				+ '&checklist_rev_no=' + checklist_rev_no
			    				+ '&check_time=' + check_time
			    				+ '&ccp_date=' + ccp_date;
		    				   
				const footer = "<button type='button' class='btn btn-outline-primary'"
					 + "onclick='printChecklist()'>출력</button>";
				const title = element.innerText;
				const heneModal = new HenesysModal(modalUrl, 'auto', title, footer);
				heneModal.open_modal();
    		}
    	});
    }
	
    //일지 등록
    function haccpInsert(obj) {
    	var url = "<%=Config.this_SERVER_path%>/Contents/Business/M838/S838S015401.jsp"
    				+ '?checklist_id=' + checklist_id 
    				+ '&checklist_rev_no=' + checklist_rev_no;
		var footer = '<button id="btn_Save" class="btn btn-info" onclick="SaveOderInfo();">저장</button>';
		var title = obj.innerText;
		var heneModal = new HenesysModal(url, 'standard', title, footer);
		heneModal.open_modal();
    }
    
    //일지 수정
    function haccpUpdate(obj) {
    	
    	if(ccp_date.length < 1){
    		heneSwal.warning('수정할 모니터링 일지를 선택하세요');
    		return false;
    	}
    	
    	var url = "<%=Config.this_SERVER_path%>/Contents/Business/M838/S838S015402.jsp"
    				+ '?checklist_id=' + checklist_id 
					+ '&checklist_rev_no=' + checklist_rev_no
					+ '&ccp_date=' + ccp_date
					+ '&unsuit_detail=' + unsuit_detail
					+ '&improve_action_result=' + improve_action_result
					+ '&person_write_id=' + person_write_id
					+ '&person_writer=' + person_writer
					+ '&person_check_id=' + person_check_id
					+ '&person_checker=' + person_checker
					+ '&person_approve_id=' + person_approve_id
					+ '&person_approver=' + person_approver
    				+ '&person_action_id=' + person_action_id
					+ '&person_actioner=' + person_actioner;
		   
		var footer = '<button id="btn_Save" class="btn btn-info" onclick="SaveOderInfo();">저장</button>';
		var title = obj.innerText;
		var heneModal = new HenesysModal(url, 'standard', title, footer);
		heneModal.open_modal();
    }
    
    //일지 삭제
    function haccpDelete(obj) {
    	
    	if(ccp_date.length < 1){
    		heneSwal.warning('삭제할 모니터링 일지를 선택하세요');
    		return false;
    	} else{
    		SaveOderInfo();
    	}
    	
    	function SaveOderInfo() {
        	
    	        var dataJson = new Object();
    			
    			dataJson.ccp_date	 		= ccp_date;
    			dataJson.checklist_id 		= checklist_id;
    			dataJson.checklist_rev_no 	= checklist_rev_no;
    		
            	
    			var JSONparam = JSON.stringify(dataJson);
    			var chekrtn = confirm("삭제하시겠습니까?"); 
    			
    			if(chekrtn) {
    				SendTojsp(JSONparam, "M838S015400E103");
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
    					heneSwal.success('모니터링 일지 삭제가 완료되었습니다');

    					$('#modalReport').modal('hide');
    	        		parent.fn_MainInfo_List(startDate, endDate);
    	         	} else {
    					heneSwal.error('모니터링 일지 삭제에 실패했습니다, 다시 시도해주세요');	         		
    	         	}
    	         }
    	     });
    	}
    }
    
    
    //측정일지 등록
    function haccpPersonInsert(obj) {
    	
    	if(ccp_date.length < 1){
    		heneSwal.warning('측정일지를 등록할 모니터링 일지를 선택하세요');
    		return false;
    	}
    	
    	var url = "<%=Config.this_SERVER_path%>/Contents/Business/M838/S838S015411.jsp"
    				+ '?checklist_id=' + checklist_id 
    				+ '&checklist_rev_no=' + checklist_rev_no
    				+ '&ccp_date=' + ccp_date;
		var footer = '<button id="btn_Save" class="btn btn-info" onclick="SaveOderInfo();">저장</button>';
		var title = obj.innerText;
		var heneModal = new HenesysModal(url, 'standard', title, footer);
		heneModal.open_modal();
    }
    
    //측정일지 수정
    function haccpPersonUpdate(obj) {
    	
    	if(check_time.length < 1){
    		heneSwal.warning('수정할 측정 일지를 선택하세요');
    		return false;
    	}
    	
    	var url = "<%=Config.this_SERVER_path%>/Contents/Business/M838/S838S015412.jsp"
    				+ '?checklist_id=' +  checklist_id 
					+ '&checklist_rev_no=' +  checklist_rev_no
					+ '&ccp_date=' + ccp_date
					+ '&check_time=' + check_time
					+ '&prod_nm=' + prod_nm
					+ '&prod_cd=' + prod_cd
					+ '&revision_no=' + revision_no
					+ '&fe_only=' + fe_only
					+ '&sus_only=' + sus_only
					+ '&prod_only=' + prod_only
					+ '&fe_with_prod=' + fe_with_prod
					+ '&sus_with_prod=' + sus_with_prod
					+ '&result=' + result
					+ '&person_sign_id=' + person_sign_id
					+ '&person_signer=' + person_signer
					+ '&note_unusual=' + note_unusual;
		   
		var footer = '<button id="btn_Save" class="btn btn-info" onclick="SaveOderInfo();">저장</button>';
		var title = obj.innerText;
		var heneModal = new HenesysModal(url, 'standard', title, footer);
		heneModal.open_modal();
    }
    
    //측정일지 삭제
    function haccpPersonDelete(obj) {
    	
    	if(check_time.length < 1){
    		heneSwal.warning('삭제할 측정 일지를 선택하세요');
    		return false;
    	} else{
    		SaveOderInfo();
    	}
    	
    	function SaveOderInfo() {
        	
    	        var dataJson = new Object();
    			
    			dataJson.ccp_date = ccp_date;
    			dataJson.check_time = check_time;
    			dataJson.prod_cd = prod_cd;
    			dataJson.revision_no = revision_no;
    		
            	
    			var JSONparam = JSON.stringify(dataJson);
    			var chekrtn = confirm("삭제하시겠습니까?"); 
    			
    			if(chekrtn) {
    				SendTojsp(JSONparam, "M838S015400E113");
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
    					heneSwal.success('측정일지 삭제가 완료되었습니다');

    					$('#modalReport').modal('hide');
    	        		parent.fn_MainInfo_List(startDate, endDate);
    	         	} else {
    					heneSwal.error('측정일지 삭제에 실패했습니다, 다시 시도해주세요');	         		
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
	      					모니터링 일지 등록
	      				</button>
	      				<button type="button" onclick="haccpUpdate(this)" 
	      				  		  id="update" class="btn btn-outline-success">
	      					모니터링 일지 수정
	      				</button>
	      				<button type="button" onclick="haccpDelete(this)" 
	      				  		  id="delete" class="btn btn-outline-danger">
	      					모니터링 일지 삭제
	      				</button>
	      				<button type="button" onclick="displayChecklist(this)" 
	      				  	 	class="btn btn-outline-dark">
	      					모니터링 일지 조회
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
    <div class="card card-primary card-outline">
    	<div class="card-header">
    		<h3 class="card-title">
    			<i class="fas fa-edit">측정일지 내역</i>
    		</h3>
    		<div class="card-tools">
				<button type="button" onclick="haccpPersonInsert(this)" 
						id="insert" class="btn btn-outline-dark">
					측정일지 등록
				</button>          	  
				<button type="button" onclick="haccpPersonUpdate(this)" 
						id="update" class="btn btn-outline-success">
					측정일지 수정
				</button>
				<button type="button" onclick="haccpPersonDelete(this)"
						id="delete" class="btn btn-outline-danger">
					측정일지 삭제
				</button>       	  
          	</div>
    	</div>
    	<div class="card-body">
    		<ul class="nav nav-tabs" id="custom-tabs-one-tab" role="tablist">
	       		<li class="nav-item" onclick='fn_DetailInfo_List()'>
	       			<a class="nav-link" id="DetailInfo_List" data-toggle="pill" href="#SubInfo_List_contents" role="tab">상세정보</a>
	       		</li>
	        </ul>
	     	<div class="tab-content" id="custom-tabs-one-tabContent">
	     		<div class="tab-pane fade" id="SubInfo_List_contents" role="tabpanel"></div>
	     	</div>
	    </div>
    </div>
  </div><!-- /.container-fluid -->
</div>
<!-- /.content -->