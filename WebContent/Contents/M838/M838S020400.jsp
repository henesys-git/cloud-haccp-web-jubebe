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
	var checklist_id = "checklist09";
	var checklist_rev_no = "";
	var regist_date = "";
	var seq_no = "";
	var standard_unsuit = "";
	var improve_action = "";
	var action_result = "";
 	
 	var startDate = "";
 	var endDAte = "";
 	
    $(document).ready(function () {
    	
    	var date = new SetRangeDate("dateParent", "dateRange", 30);
    	startDate = date.start.format('YYYY-MM-DD');
       	endDate = date.end.format('YYYY-MM-DD');
        
       	fn_MainInfo_List(startDate, endDate);
		
       	// 날짜 변경 시
		$('#dateRange').change(function() {
           	fn_MainInfo_List(startDate, endDate);
        });
		
		$("#InfoContentTitle").html("점검표 목록");
		fn_MainSubMenuSelect("<%=sMenuTitle%>");
		fn_tagProcess();
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
     
    // 메인 조회
    function fn_MainInfo_List(startDate, endDate) {
        $.ajax({
            type: "POST",
            url: "<%=Config.this_SERVER_path%>/Contents/Business/M838/S838S020400.jsp",
            data: "From=" + startDate + 
            	  "&To=" + endDate,
            success: function (html) {
                $("#MainInfo_List_contents").hide().html(html).fadeIn(100);
            }
        });
        
        $("#SubInfo_List_contents").children().remove(); 
    }
    
    // 상세조회
    function fn_DetailInfo_List() {     
    	$.ajax({
   	    	type: "POST",
   	        url: "<%=Config.this_SERVER_path%>/Contents/Business/M838/S838S020410.jsp",
   	        data: "regist_date=" + regist_date +	
   	     		  "&checklist_id=" + checklist_id +
   	     		  "&checklist_rev_no=" + checklist_rev_no,
   	        success: function (html) {
   	            $("#SubInfo_List_contents").hide().html(html).fadeIn(100);
   	        	
   	               	            
   	        }
   	    });
	}
    
    // 점검표 조회
    function displayChecklist(element) {
    	let ajaxUrl = '<%=Config.this_SERVER_path%>/Contents/CheckList/getChecklistFormat.jsp';
    	
    	let jObj = new Object();
    	jObj.checklistId = checklist_id;
    	jObj.checklistRevNo = checklist_rev_no;
    	jObj.checklistDate = regist_date;
		let ajaxParam = JSON.stringify(jObj);

    	$.ajax({
    		url: ajaxUrl,
    		data: {"ajaxParam" : ajaxParam},
    		success: function(rcvData) {
    			const format = rcvData[0][0];	// 이미지 파일
    			const page = rcvData[0][1];		// jsp 페이지
    			
		    	const modalUrl = '<%=Config.this_SERVER_path%>' + page
		    				    + '?format=' + format
		    				    + '&regist_date=' + regist_date;
		    				   
				const footer = "<button type='button' class='btn btn-outline-primary'"
									 + "onclick='printChecklist()'>출력</button>";
				const title = element.innerText;
				const heneModal = new HenesysModal(modalUrl, 'auto', title, footer);
				heneModal.open_modal();
    		}
    	});
    }
	
    // 등록
    function haccpInsert(obj) {
    	var url = "<%=Config.this_SERVER_path%>/Contents/Business/M838/S838S020401.jsp"
    				+ '?checklist_id=' + checklist_id
    				+ '&checklist_rev_no=' + checklist_rev_no;
		var footer = '<button id="btn_Save" class="btn btn-info" onclick="sendToJsp();">저장</button>';
		var title = obj.innerText;
		var heneModal = new HenesysModal(url, 'large', title, footer);
		heneModal.open_modal();
    }
    
    //수정
    function haccpUpdate(obj) {
    	
    	if(regist_date.length < 1){
    		heneSwal.warning('수정할 점검표를 선택하세요');
    		return false;
    	}
    	
    	var url = "<%=Config.this_SERVER_path%>/Contents/Business/M838/S838S020402.jsp"
			+ '?checklist_id=' + checklist_id
			+ '&checklist_rev_no=' + checklist_rev_no
			+ '&regist_date=' + regist_date;
    	
		var footer = '<button id="btn_Save" class="btn btn-info" onclick="sendToJsp();">저장</button>';
		var title = obj.innerText;
		var heneModal = new HenesysModal(url, 'large', title, footer);
		heneModal.open_modal();
    }
    
    //삭제
    function haccpDelete(obj) {
    	
    	if(regist_date.length < 1){
    		heneSwal.warning('삭제할 점검표를 선택하세요');
    		return false;
    	} else{
    		SaveOderInfo();
    	}
    	
    	function SaveOderInfo() {
       	
   	        var dataJson = new Object();
   			
   			dataJson.checklist_id = checklist_id;
   			dataJson.checklist_rev_no = checklist_rev_no;
   			dataJson.regist_date = regist_date;
           	
   			var JSONparam = JSON.stringify(dataJson);
   			var chekrtn = confirm("삭제하시겠습니까?"); 
   			
   			if(chekrtn) {
   				SendTojsp(JSONparam, "M838S020400E103");
   			} else {
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
    					heneSwal.success('점검표 삭제가 완료되었습니다');

    					$('#modalReport').modal('hide');
    	        		parent.fn_MainInfo_List(startDate, endDate);
    	        		parent.$('#SubInfo_List_contents').hide();
    	         	} else {
    					heneSwal.error('점검표 삭제에 실패했습니다, 다시 시도해주세요');	         		
    	         	}
    	         }
    	     });
    	}
    }
<%--     
///////////////////////////////// 상세 이상 기록
    //이상 기록 등록
    function haccpPersonInsert(obj) {
    	
    	if(regist_date.length < 1){
    		heneSwal.warning('이상 기록을 등록할 점검표를 선택하세요');
    		return false;
    	}
    	
    	var url = "<%=Config.this_SERVER_path%>/Contents/Business/M838/S838S020411.jsp"
    				+ '?regist_date=' + regist_date;
		var footer = '<button id="btn_Save" class="btn btn-info" onclick="SaveOderInfo();">저장</button>';
		var title = obj.innerText;
		var heneModal = new HenesysModal(url, 'standard', title, footer);
		heneModal.open_modal();
    }
    
  	//이상 기록 수정
    function haccpPersonUpdate(obj) {
    	
    	if(seq_no.length < 1){
    		heneSwal.warning('수정할 이상 기록을 선택하세요');
    		return false;
    	}
    	
    	var url = "<%=Config.this_SERVER_path%>/Contents/Business/M838/S838S020412.jsp"
    				+ '?seq_no=' + seq_no
    				+ '&regist_date=' + regist_date 
    				+ '&unsuit_place=' + unsuit_place
    				+ '&standard_unsuit=' + standard_unsuit
    				+ '&improve_action=' + improve_action
    				+ '&action_result=' + action_result;
    	
		var footer = '<button id="btn_Save" class="btn btn-info" onclick="SaveOderInfo();">저장</button>';
		var title = obj.innerText;
		var heneModal = new HenesysModal(url, 'standard', title, footer);
		heneModal.open_modal();
    }
  	
  	
  	//이상 기록 삭제
  	function haccpPersonDelete(obj) {
    	
    	if(seq_no.length < 1){
    		heneSwal.warning('삭제할 이상 기록을 선택하세요');
    		return false;
    	} else{
    		SaveOderInfo();
    	}
    	
    	function SaveOderInfo() {
        	
    	        var dataJson = new Object();
    			
    			dataJson.seq_no = seq_no;
    		
    			var JSONparam = JSON.stringify(dataJson);
    			var chekrtn = confirm("삭제하시겠습니까?"); 
    			
    			if(chekrtn) {
    				SendTojsp(JSONparam, "M838S020400E113");
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
    					heneSwal.success('이상 기록 삭제가 완료되었습니다');

    					$('#modalReport').modal('hide');
    	        		parent.fn_DetailInfo_List();
    	         	} else {
    					heneSwal.error('이상 기록 삭제에 실패했습니다, 다시 시도해주세요');	         		
    	         	}
    	         }
    	     });
    	}
    }
 --%>    
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
	      					점검표 등록
	      				</button>
	      				<button type="button" onclick="haccpUpdate(this)" 
	      				  		  id="update" class="btn btn-outline-success">
	      					점검표 수정
	      				</button>
	      				<button type="button" onclick="haccpDelete(this)" 
	      				  		  id="delete" class="btn btn-outline-danger">
	      					점검표 삭제
	      				</button>
	      				<button type="button" onclick="displayChecklist(this)" 
	      				  	 	class="btn btn-outline-dark">
	      					점검표 조회
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
        
         <div class="card card-primary card-outline">
	    	<div class="card-header">
	    		<h3 class="card-title">
	    			<i class="fas fa-edit">세부정보</i>
	    		</h3>
	    	<!-- 	<div class="card-tools">
					<button type="button" onclick="haccpPersonInsert(this)" 
							id="insert" class="btn btn-outline-dark">
						이상 기록 등록
					</button>          	  
					<button type="button" onclick="haccpPersonUpdate(this)" 
							id="update" class="btn btn-outline-success">
						이상 기록 수정
					</button>
					<button type="button" onclick="haccpPersonDelete(this)"
							id="delete" class="btn btn-outline-danger">
						이상 기록 삭제
					</button>       	  
	          	</div> -->
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
      </div>
      <!-- /.col-md-6 -->
    </div>
    <!-- /.row -->
  </div><!-- /.container-fluid -->
</div>
<!-- /.content -->