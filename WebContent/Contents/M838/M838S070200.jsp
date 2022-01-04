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
 	var checklist_id 		= "checklist12";		
	var checklist_rev_no 	= 0;
	var ipgo_date 			= "";
	var ipgo_part_count  	= "";
	var person_write_id  	= "";
	var person_writer  	    = "";
	var person_approve_id  	= "";
	var person_approver  	= "";
 	var unsuit_detail 		= "";
 	var improve_action 		= "";
	
	//서브테이블 변수모음
	var s_checklist_id 		= "";		
	var s_checklist_rev_no  = "";	
	var seq_no 				= "";
	var s_ipgo_date 		= "";	
	var part_cd 			= "";	
	var part_rev_no 		= "";
	var part_nm 			= "";
	var supplier 			= "";
	var ipgo_amount 		= "";
	var trace_key 			= "";
	var standard_yn 		= "";
	var packing_status 		= "";
	var visual_inspection 	= "";
	var car_clean 			= "";
	var docs_yn 			= "";
	var unsuit_action		= "";
	var check_yn 			= "";
	var balju_no 			= "";
	var balju_rev_no 		= "";
	
	
 	
    $(document).ready(function () {
    	
		new SetSingleDate2("", "#dateRange", 0);
       	
       	toDate = $('#dateRange').val();
    	
	    fn_MainInfo_List(toDate);   
		
		$("#InfoContentTitle").html("입고검사대장 목록");
		fn_MainSubMenuSelect("<%=sMenuTitle%>");        	
		fn_tagProcess();
		
		$('#dateRange').change(function() {
			fn_MainInfo_List(toDate);
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
        
    function fn_MainInfo_List(toDate) {
        $.ajax({
            type: "POST",
            url: "<%=Config.this_SERVER_path%>/Contents/Business/M838/S838S070200.jsp",
            data: "ipgo_date=" + toDate,
            success: function (html) {
                $("#MainInfo_List_contents").hide().html(html).fadeIn(100);
            }
        });
        $("#SubInfo_List_contents").children().remove(); 
    }
    
    function fn_DetailInfo_List() {     
    	$.ajax({
   	    	type: "POST",
   	        url: "<%=Config.this_SERVER_path%>/Contents/Business/M838/S838S070210.jsp",
   	        data: "ipgo_date=" + ipgo_date +
   	     		  "&checklist_id=" + checklist_id +
   	     		  "&checklist_rev_no=" + checklist_rev_no,
   	        success: function (html) {
   	            $("#SubInfo_List_contents").hide().html(html).fadeIn(100);
   	        }
   	    });
	}
    
    
    // 점검표 조회
    function displayChecklist(element) {
    	
    	if(ipgo_date.length < 1){
    		heneSwal.warning('조회할 관리대장을 선택하세요');
    		return false;
    	}
    	
    	let ajaxUrl = '<%=Config.this_SERVER_path%>/Contents/CheckList/getChecklistFormat.jsp';
    	
    	let jObj = new Object();
    	jObj.checklistId = checklist_id;
    	jObj.checklistRevNo = checklist_rev_no;
    	jObj.checklistDate = ipgo_date;
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
			    				+ '&checklist_rev_no=' + checklist_rev_no
			    				+ '&seq_no=' + seq_no
			    				+ '&ipgo_date=' + ipgo_date;
		    				   
				const footer = "<button type='button' class='btn btn-outline-primary'"
					 + "onclick='printChecklist()'>출력</button>";
				const title = element.innerText;
				const heneModal = new HenesysModal(modalUrl, 'auto', title, footer);
				heneModal.open_modal();
    		}
    	});
    }
	
    //입고검사대장 등록
    function haccpInsert(obj) {
    	var url = "<%=Config.this_SERVER_path%>/Contents/Business/M838/S838S070201.jsp"
    				+ '?checklist_id=' + checklist_id 
    				+ '&checklist_rev_no=' + checklist_rev_no;
		var footer = '<button id="btn_Save" class="btn btn-info" onclick="SaveOderInfo();">저장</button>';
		var title = obj.innerText;
		var heneModal = new HenesysModal(url, 'standard', title, footer);
		heneModal.open_modal();
    }
    
    //입고검사대장 수정
    function haccpUpdate(obj) {
    	
    	if(ipgo_date.length < 1){
    		heneSwal.warning('원부재료 입고검사대장을 선택하세요');
    		return false;
    	}
    	
    	var url = "<%=Config.this_SERVER_path%>/Contents/Business/M838/S838S070202.jsp"
    				+ '?checklist_id=' + checklist_id 
					+ '&checklist_rev_no=' + checklist_rev_no
					+ '&ipgo_date=' + ipgo_date
					+ '&unsuit_detail=' + unsuit_detail					
					+ '&improve_action=' + improve_action
					+ '&person_write_id=' + person_write_id
					+ '&person_writer=' + person_writer
					+ '&person_approve_id=' + person_approve_id
					+ '&person_approver=' + person_approver;
		   
		var footer = '<button id="btn_Save" class="btn btn-info" onclick="SaveOderInfo();">저장</button>';
		var title = obj.innerText;
		var heneModal = new HenesysModal(url, 'standard', title, footer);
		heneModal.open_modal();
    }
    
    //입고검사대장 삭제
    function haccpDelete(obj) {
    	
    	if(ipgo_date.length < 1){
    		heneSwal.warning('삭제할 검사대장을 선택하세요');
    		return false;
    	} else{
    		SaveOderInfo();
    	}
    	
    	function SaveOderInfo() {
        	
    	        var dataJson = new Object();
    			
    			dataJson.ipgo_date 	 		= ipgo_date;
    			dataJson.checklist_id 		= checklist_id;
    			dataJson.checklist_rev_no 	= checklist_rev_no;
    		
            	
    			var JSONparam = JSON.stringify(dataJson);
    			var chekrtn = confirm("삭제하시겠습니까?"); 
    			
    			if(chekrtn) {
    				SendTojsp(JSONparam, "M838S070200E103");
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
    					heneSwal.success('검사대장 삭제가 완료되었습니다');

    					$('#modalReport').modal('hide');
    	        		parent.fn_MainInfo_List(toDate);
    	         	} else {
    					heneSwal.error('검사대장 삭제에 실패했습니다, 다시 시도해주세요');	         		
    	         	}
    	         }
    	     });
    	}
    }
    
    
    //입고검사대장 부자재 등록
    function haccpPersonInsert(obj) {
    	
    	if(ipgo_date.length < 1){
    		heneSwal.warning('부자재를 등록할 검사대장을 선택하세요');
    		return false;
    	}
    	
    	var url = "<%=Config.this_SERVER_path%>/Contents/Business/M838/S838S070211.jsp"
    				+ '?checklist_id=' + checklist_id 
    				+ '&checklist_rev_no=' + checklist_rev_no
    				+ '&ipgo_date=' + ipgo_date;
		var footer = '<button id="btn_Save" class="btn btn-info" onclick="SaveOderInfo();">저장</button>';
		var title = obj.innerText;
		var heneModal = new HenesysModal(url, 'standard', title, footer);
		heneModal.open_modal();
    }
    
    //입고검사대장 부자재 수정
    function haccpPersonUpdate(obj) {
    	
    	if(s_ipgo_date.length < 1){
    		heneSwal.warning('수정할 검사대장 부자재를 선택하세요');
    		return false;
    	}
    	
    	var url = "<%=Config.this_SERVER_path%>/Contents/Business/M838/S838S070212.jsp"
    				+ '?checklist_id=' + s_checklist_id 
					+ '&checklist_rev_no=' + s_checklist_rev_no
					+ '&seq_no=' + seq_no
					+ '&ipgo_date=' + s_ipgo_date
					+ '&part_cd=' + part_cd
					+ '&part_rev_no=' + part_rev_no
					+ '&part_nm=' + part_nm
					+ '&trace_key=' + trace_key
					+ '&standard_yn=' + standard_yn
					+ '&packing_status=' + packing_status
					+ '&visual_inspection=' + visual_inspection
					+ '&car_clean=' + car_clean
					+ '&docs_yn=' + docs_yn
					+ '&unsuit_action=' + unsuit_action
					+ '&check_yn=' + check_yn;
		   
		var footer = '<button id="btn_Save" class="btn btn-info" onclick="SaveOderInfo();">저장</button>';
		var title = obj.innerText;
		var heneModal = new HenesysModal(url, 'standard', title, footer);
		heneModal.open_modal();
    }
    
    //입고검사대장 부자재 삭제
    function haccpPersonDelete(obj) {
    	
    	if(s_ipgo_date.length < 1){
    		heneSwal.warning('삭제할 검사대장 부자재를 선택하세요');
    		return false;
    	} else{
    		SaveOderInfo();
    	}
    	
    	function SaveOderInfo() {
        	
   	        var dataJson = new Object();
   			
   			dataJson.seq_no = seq_no;
   			dataJson.trace_key = trace_key;
   			dataJson.part_cd = part_cd;
   			dataJson.part_rev_no = part_rev_no;
   			dataJson.balju_no = balju_no;
   			dataJson.balju_rev_no = balju_rev_no;
   		
           	
   			var JSONparam = JSON.stringify(dataJson);
   			var chekrtn = confirm("삭제하시겠습니까?"); 
   			
   			if(chekrtn) {
   				SendTojsp(JSONparam, "M838S070200E113");
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
    					heneSwal.success('입고검사대장 명단 삭제가 완료되었습니다');

    					$('#modalReport').modal('hide');
    	        		parent.fn_MainInfo_List(toDate);
    	         	} else {
    					heneSwal.error('입고검사대장 명단 삭제에 실패했습니다, 다시 시도해주세요');	         		
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
	      					입고검사대장 등록
	      				</button>
	      				<button type="button" onclick="haccpUpdate(this)" 
	      				  		  id="update" class="btn btn-outline-success">
	      					입고검사대장 수정
	      				</button>
	      				<button type="button" onclick="haccpDelete(this)" 
	      				  		  id="delete" class="btn btn-outline-danger">
	      					입고검사대장 삭제
	      				</button>
	      				<button type="button" onclick="displayChecklist(this)" 
	      				  	 	class="btn btn-outline-dark">
	      					입고검사대장 조회
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
    			<i class="fas fa-edit">관리대장 명단</i>
    		</h3>
    		<div class="card-tools">
				<button type="button" onclick="haccpPersonInsert(this)" 
						id="insert" class="btn btn-outline-dark">
					입고검사대장 부자재 등록
				</button>          	  
				<button type="button" onclick="haccpPersonUpdate(this)" 
						id="update" class="btn btn-outline-success">
					입고검사대장 부자재 수정
				</button>
				<button type="button" onclick="haccpPersonDelete(this)"
						id="delete" class="btn btn-outline-danger">
					입고검사대장 부자재 삭제
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