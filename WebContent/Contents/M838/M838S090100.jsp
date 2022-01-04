<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="mes.client.comm.*" %>
<%@ page import="mes.client.guiComponents.*" %>
<%@ page import="mes.client.util.*" %>
<%@ page import="mes.client.conf.*" %>
<%  	
	String loginID = session.getAttribute("login_id").toString();
	String member_key = session.getAttribute("member_key").toString();
	if(loginID==null||loginID.equals("")){                            // id가 Null 이거나 없을 경우
		response.sendRedirect(Config.this_SERVER_path + "/Contents/index.jsp");    // 로그인 페이지로 리다이렉트 한다.
	}
// 	makeMenu MainMenu = new makeMenu(loginID);

	String sMenuTitle = request.getParameter("MenuTitle").toString();
	String sProgramId = request.getParameter("programId").toString();
	String sHeadmenuID= request.getParameter("HeadmenuID").toString();
	String sHeadmenuName= request.getParameter("HeadmenuName").toString();
// 	String htmlsideMenu = MainMenu.GetsideMenu(sHeadmenuID,sHeadmenuName);
	
	Get_Program_button_Autho prg_autho = new Get_Program_button_Autho(loginID,sProgramId);	

	CurrentPage jspPageName = new CurrentPage(request.getRequestURI());
	String JSPpage = jspPageName.GetJSP_FileName();

	ProcesStatusCheck prcStatusCheck = new ProcesStatusCheck(JSPpage+"|"+"NON"+"|");
	
	String GV_GET_NUM_PREFIX = prcStatusCheck.GV_PROCESS_NUMBER_GUBUN;
%>

 <script type="text/javascript">
	var regist_seq_no = "";
	var vRecalledRev = "";
	
	var checklist_id = "checklist24";
	var checklist_rev_no = "";
	var regist_seq_no = "";
	var prod_cd = "";
	var prod_date = "";
	
	var startDate = "";
	var endDate = "";
 
    $(document).ready(function () {
	    new SetRangeDate("dateParent", "dateRange", 90);
	      
		startDate = $('#dateRange').data('daterangepicker').startDate.format('YYYY-MM-DD');
		endDate = $('#dateRange').data('daterangepicker').endDate.format('YYYY-MM-DD');
		fn_MainInfo_List(startDate, endDate);
		  	
		$('#dateRange').on('apply.daterangepicker', function(ev, picker) {
			startDate = picker.startDate.format('YYYY-MM-DD');
			endDate = picker.endDate.format('YYYY-MM-DD');
			fn_MainInfo_List(startDate, endDate);
		});
		  	
		$("#InfoContentTitle").html("회수관리대장");
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

/*     function fn_clearList() {
        if ($("#MainInfo_List_contents").children().length > 0) {
            $("#MainInfo_List_contents").children().remove();
        }
    } */
        
    // 회수관리대장 목록조회
    function fn_MainInfo_List(startDate, endDate) {
    	
        $.ajax({
            type: "POST",
            url: "<%=Config.this_SERVER_path%>/Contents/Business/M838/S838S090100.jsp",
            data: "From=" + startDate + "&To=" + endDate,
            success: function (html) {
                $("#MainInfo_List_contents").hide().html(html).fadeIn(100);
            }
        });
    }
    
    // 점검표 조회
    function displayChecklist(obj) {
    	
    	if(regist_seq_no.length < 1){
    		heneSwal.warning('조회할 회수결과기록을 선택하세요.');
    		return false;
    	}
    	
    	let ajaxUrl = '<%=Config.this_SERVER_path%>/Contents/CheckList/getChecklistFormat.jsp';
    	
    	let jObj = new Object();
    	jObj.checklistId = checklist_id;
    	jObj.checklistRevNo = checklist_rev_no;
    	jObj.checklistDate = prod_date;	
		let ajaxParam = JSON.stringify(jObj);

    	$.ajax({
    		url: ajaxUrl,
    		data: {"ajaxParam" : ajaxParam},
    		success: function(rcvData) {
    			    			
    			const format = rcvData[0][0];	// 이미지 파일
    			const page = rcvData[0][1];		// jsp 페이지
    			
		    	const modalUrl = '<%=Config.this_SERVER_path%>' + page
		    				    + '?format=' + format
		    				    + '&regist_seq_no=' + regist_seq_no
		    					+ '&prod_date=' + prod_date
		    					+ '&prod_cd=' + prod_cd;
		    				   
				const footer = "<button type='button' class='btn btn-outline-primary' onclick='printChecklist()'>출력</button>";
				const title = obj.innerText;
				const heneModal = new HenesysModal(modalUrl, 'auto', title, footer);
				heneModal.open_modal();
    		}
    	});
    }
    
    // 회수관리정보등록
    function pop_fn_return_Insert(obj) {
    	
		var modalContentUrl = "<%=Config.this_SERVER_path%>/Contents/Business/M838/S838S090101.jsp"
							+ "?checklist_id="+checklist_id;
		var footer = '<button id="btn_Save" class="btn btn-info" onclick="SendTojsp();">저장</button>';
		var title = obj.innerText;
		var heneModal = new HenesysModal(modalContentUrl, 'large', title, footer);
		heneModal.open_modal();
     }
    
    // 회수관리정보수정
    function pop_fn_return_Update(obj) {
    	if(regist_seq_no.length < 1){
    		heneSwal.warning("수정하려는 결과기록을 선택하세요.");
 			return false;
		}
    	var modalContentUrl; 
    	modalContentUrl = "<%=Config.this_SERVER_path%>/Contents/Business/M838/S838S090102.jsp"
    					+ "?regist_seq_no=" + regist_seq_no + "&prod_cd=" + prod_cd + "&prod_date=" + prod_date;						
    	
    	var footer = '<button id="btn_Save" class="btn btn-info" onclick="SendTojsp();">저장</button>';
		var title = obj.innerText;
		var heneModal = new HenesysModal(modalContentUrl, 'large', title, footer);
		heneModal.open_modal();
     }
    
    // 회수관리정보삭제
    function pop_fn_return_Delete(obj) {		
    	
		if(regist_seq_no.length < 1){
    		heneSwal.warning('삭제할 관리기록을 선택하세요.');
    		return false;
    	} 

		var dataJson = new Object();
  			
  		dataJson.regist_seq_no = regist_seq_no;
  			
  		var JSONparam = JSON.stringify(dataJson);
  		var checkrtn = confirm("삭제하시겠습니까?"); 
  			
  		if(checkrtn) {
  				
   			 $.ajax({
     	        type: "POST",
     	        dataType: "json",
     	        url: "<%=Config.this_SERVER_path%>/Contents/CommonView/insert_update_delete_json.jsp", 
     	        data:  {"bomdata" : JSONparam, "pid" : "M838S090100E103"},
     			success: function (html) {	
     				if(html > -1) {
     					heneSwal.successTimer('회수결과기록 삭제가 완료되었습니다.');

     					$('#modalReport').modal('hide');
     	        		parent.fn_MainInfo_List(startDate, endDate);
     	         	} else {
     					heneSwal.error('회수결과기록 삭제에 실패했습니다, 다시 시도해주세요');	         		
     	         	}
     	         }
     	     });
  				
  		}// end if(checkrtn)
    	   
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
		      		<button type="button" onclick="pop_fn_return_Insert(this)" id="insert" class="btn btn-outline-dark">회수결과기록 등록</button>
		      		<button type="button" onclick="pop_fn_return_Update(this)" id="update" class="btn btn-outline-success">회수결과기록 수정</button>
		      		<button type="button" onclick="pop_fn_return_Delete(this)" id="delete" class="btn btn-outline-danger">회수결과기록 삭제</button>
		      		<button type="button" onclick="displayChecklist(this)" class="btn btn-outline-dark">회수결과기록 조회</button>
		      	</div>
		      </div>
     		</div><!-- /.row -->
		</div><!-- /.container-fluid -->
	</div><!-- /.content-header -->
    
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
      			</div><!-- /.col-md-12 -->
    		</div><!-- /.row -->
    	</div><!-- /.container-fluid -->
	</div><!-- /.content -->