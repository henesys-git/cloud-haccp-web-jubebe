<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="mes.client.comm.*" %>
<%@ page import="mes.client.common.*" %>
<%@ page import="mes.client.guiComponents.*" %>
<%@ page import="mes.client.util.*" %>
<%@ page import="mes.client.conf.*" %>
<%  
/* 
HACCP 회의록 (M838S080200.jsp)
*/
	String loginID = session.getAttribute("login_id").toString();
	String member_key = session.getAttribute("member_key").toString();
	if(loginID==null||loginID.equals("")){                            // id가 Null 이거나 없을 경우
		response.sendRedirect(Config.this_SERVER_path + "/Contents/index.jsp");    // 로그인 페이지로 리다이렉트 한다.
	}
	
	String sMenuTitle = request.getParameter("MenuTitle").toString();
	String sProgramId = request.getParameter("programId").toString();
	String sHeadmenuID= request.getParameter("HeadmenuID").toString();
	String sHeadmenuName= request.getParameter("HeadmenuName").toString();

	Get_Program_button_Autho prg_autho = new Get_Program_button_Autho(loginID,sProgramId);	
	
	CurrentPage jspPageName = new CurrentPage(request.getRequestURI());
	String JSPpage = jspPageName.GetJSP_FileName();
	ProcesStatusCheck prcStatusCheck = new ProcesStatusCheck(JSPpage+"|"+"NON"+"|");
		
	Vector optCode =  null;
    Vector optName =  null;
	Vector DocGubunVector = CommonData.getHDocGubunCDAll(member_key);
%>

 <script type="text/javascript">
 
	var seq_no 				= "";
	var checklist_id 		= "checklist19"; // 체크리스트 아이디
	var checklist_rev_no 	= "";
	var meeting_date 		= "";
	var meeting_topic 	 	= "";
 	var meeting_detail 		= "";
	var meeting_result 		= "";
	var attendees_cnt 		= "";
	var bigo				= "";
	
	var regist_no			= "";
	var file_name			= "";
	var file_path			= "";
	var file_rev_no			= "";
	
 	var startDate 			= "";
 	var endDate 			= "";
 	
    $(document).ready(function () {
        
    	new SetRangeDate("dateParent", "dateRange", 180);
    	
    	startDate = $('#dateRange').data('daterangepicker').startDate.format('YYYY-MM-DD');
		endDate = $('#dateRange').data('daterangepicker').endDate.format('YYYY-MM-DD');
		fn_MainInfo_List(startDate, endDate);
    	
        fn_MainSubMenuSelect("<%=sMenuTitle%>");
		$("#InfoContentTitle").html("HACCP팀 회의록 목록");

		$('#dateRange').change(function() {
		fn_MainInfo_List(startDate, endDate);
		});
        
	    fn_tagProcess('<%=JSPpage%>');
	    
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

    //호출 되지 않음
    function fn_clearList() {
        if ($("#MainInfo_List_contents").children().length > 0) {
            $("#MainInfo_List_contents").children().remove();
        }
        if ($("#SubInfo_List_contents").children().length > 0) {
            //$("#SubInfo_List_contents").children().remove();
        }        
        if ($("#sub_SubInfo_List_contents").children().length > 0) {
            $("#sub_SubInfo_List_contents").children().remove();
        }
    }

    function fn_MainInfo_List(startDate, endDate) {
        $.ajax(
        {
            type: "POST",
            url: "<%=Config.this_SERVER_path%>/Contents/Business/M838/S838S080200.jsp",
            data: 	"From=" + startDate + 
      	  			"&To=" + endDate,
            beforeSend: function () {
                $("#MainInfo_List_contents").children().remove();
            },
            success: function (html) {
                $("#MainInfo_List_contents").hide().html(html).fadeIn(100);
            },
            error: function (xhr, option, error) {

            }
        });
    }
    
    // HACCP 회의록 조회
    function displayChecklist(element) {
    	
    	if(seq_no.length < 1){
    		heneSwal.warning('조회할 HACCP팀 회의록을 선택하세요');
    		return false;
    	}
    	
    	let ajaxUrl = '<%=Config.this_SERVER_path%>/Contents/CheckList/getChecklistFormat.jsp';
    	
    	let jObj = new Object();
    	jObj.checklistId = checklist_id;
    	jObj.checklistRevNo = checklist_rev_no;
    	jObj.checklistDate = meeting_date;
		let ajaxParam = JSON.stringify(jObj);

    	$.ajax({
    		url: ajaxUrl,
    		data: {"ajaxParam" : ajaxParam},
    		success: function(rcvData) {
    			const format = rcvData[0][0];	// 이미지 파일
    			const page = rcvData[0][1];		// jsp 페이지
    			
		    	const modalUrl = '<%=Config.this_SERVER_path%>' + page
		    				    + '?format=' + format
		    				    + '&seq_no=' + seq_no
		    				    + '&meeting_date=' + meeting_date
		    				   
				const footer = "<button type='button' class='btn btn-outline-primary'"
					 + "onclick='printChecklist()'>출력</button>";
				const title = element.innerText;
				const heneModal = new HenesysModal(modalUrl, 'auto', title, footer);
				heneModal.open_modal();
    		}
    	});
    }
    
    //HACCP 회의록 등록
    function haccpInsert(obj) {
    
    	var url = "<%=Config.this_SERVER_path%>/Contents/Business/M838/S838S080201.jsp"
		    		+ '?checklist_id=' + checklist_id;
		var footer = '<button id="btn_Save" class="btn btn-info" onclick="SaveOderInfo();">저장</button>';
		var title = obj.innerText;
		var heneModal = new HenesysModal(url, 'standard', title, footer);
		heneModal.open_modal();
     }
	
  	//HACCP 회의록 수정
    function haccpUpdate(obj) {
    	
    	if(seq_no.length < 1){
    		heneSwal.warning('수정할 HACCP팀 회의록을 선택하세요');
    		return false;
    	}

    	var url = "<%=Config.this_SERVER_path%>/Contents/Business/M838/S838S080202.jsp"
    		 	+ '?checklist_id=' + checklist_id 
			    + '&checklist_rev_no=' + checklist_rev_no
			    + '&seq_no=' + seq_no
			    + '&meeting_date=' + meeting_date
			   	+ '&meeting_topic=' + meeting_topic
			   	+ '&meeting_detail=' + meeting_detail
			   	+ '&meeting_result=' + meeting_result
			   	+ '&attendees_cnt=' + attendees_cnt
			   	+ '&bigo=' + bigo
    			+ '&regist_no=' + regist_no
    			+ '&file_name=' + file_name
    			+ '&file_path=' + file_path
    			+ '&file_rev_no=' + file_rev_no
		var footer = '<button id="btn_Save" class="btn btn-info" onclick="SaveOderInfo();">수정</button>';
		var title = obj.innerText;
		var heneModal = new HenesysModal(url, 'standard', title, footer);
		heneModal.open_modal();

    }
  	
	//교육훈련 기록부 삭제
    function haccpDelete(obj) {
    	
    	if(seq_no.length < 1){
    		heneSwal.warning('삭제할 HACCP팀 회의록을 선택하세요');
    		return false;
    	} else{
    		SaveOderInfo();
    	}
    	
    	function SaveOderInfo() {
        	
    	        var dataJson = new Object();
    			
    			dataJson.meeting_date 	= meeting_date;
    			dataJson.seq_no 		= seq_no;
            	
    			var JSONparam = JSON.stringify(dataJson);
    			var chekrtn = confirm("삭제하시겠습니까?"); 
    			
    			if(chekrtn) {
    				SendTojsp(JSONparam, "M838S080200E103");
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
    					heneSwal.success('회의록 삭제가 완료되었습니다');

    					$('#modalReport').modal('hide');
    	        		parent.fn_MainInfo_List(startDate, endDate);
    	        		parent.$('#SubInfo_List_contents').hide();
    	         	} else {
    					heneSwal.error('회의록 삭제에 실패했습니다, 다시 시도해주세요');	         		
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
      </div><!-- /.col -->
      <div class="col-sm-6">
      	<div class="float-sm-right">
      		<button type = "button" onclick = "haccpInsert(this)" 
      			id="insert" class= "btn btn-outline-dark">
      			회의록 등록
      		</button>
      		<button type = "button" onclick = "haccpUpdate(this)" 
      			id="insert" class= "btn btn-outline-success">
      			회의록 수정
      		</button>
      		<button type = "button" onclick = "haccpDelete(this)" 
      			id="insert" class= "btn btn-outline-danger">
      			회의록 삭제
      		</button>
      		<button type = "button" onclick = "displayChecklist(this)"
      			id="insert" class= "btn btn-outline-dark">
      			회의록 조회
      		</button>
      	</div>
      </div> <!-- /.col -->
    </div> <!-- /.row -->
  </div> <!-- /.container-fluid -->
</div> <!-- /.content-header -->

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
      </div> <!-- /.col-md-6 -->
    </div> <!-- /.row -->
  </div> <!-- /.container-fluid -->
</div> <!-- /.content -->