<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="mes.client.comm.*" %>
<%@ page import="mes.client.common.*" %>
<%@ page import="mes.client.guiComponents.*" %>
<%@ page import="mes.client.util.*" %>
<%@ page import="mes.client.conf.*" %>
<%
/* 
생산계획(M303S020100.jsp)
 */
	String loginID = session.getAttribute("login_id").toString();
	if(loginID == null || loginID.equals("")) {         // id가 Null 이거나 없을 경우
		response.sendRedirect("Contents/index.jsp");    // 로그인 페이지로 리다이렉트 한다.
	}

	String sProgramId = request.getParameter("programId").toString();
	String sMenuTitle = request.getParameter("MenuTitle").toString();

	Get_Program_button_Autho prg_autho = new Get_Program_button_Autho(loginID,sProgramId);
	
	// '현재고' 화면 파라미터로 쓰여서 일단 놔둠
	CurrentPage jspPageName = new CurrentPage(request.getRequestURI());
	String JSPpage = jspPageName.GetJSP_FileName();
	ProcesStatusCheck prcStatusCheck = new ProcesStatusCheck(JSPpage+"|"+"ODPROCS"+"|");	
	String GV_GET_NUM_PREFIX = prcStatusCheck.GV_PROCESS_NUMBER_GUBUN;
%>

<script type="text/javascript">
	var selectedDate = "";
	var planRevNo = "";
	var planRevNoObj = {};
	
	$(document).ready(function () {
	    fn_MainInfo_List();
        fn_MainSubMenuSelect("<%=sMenuTitle%>");
		$("#InfoContentTitle").html("주간 생산 계획");
	});
	
	function fn_MainInfo_List() {
	    $.ajax({
	        type: "POST",
	        url: "<%=Config.this_SERVER_path%>/Contents/Business/M303/S303S020100.jsp", 
	        success: function (html) {
	            $("#MainInfo_List_contents").hide().html(html).fadeIn(100);
	        }
	    });
	}
	
	// 생산계획등록
	function pop_fn_Production_Plan_Insert(obj) {
		var url = '<%=Config.this_SERVER_path%>/Contents/Business/M303/S303S020101.jsp';
		var footer = '<button type="button" class="btn btn-outline-primary" onclick="pop_fn_WinNwStock_View(this)">현재고량</button>'
				   + '<button type="button" class="btn btn-outline-primary" onclick="pop_fn_WinProdChulgo_View(this)">생산/출고량 이력</button>'
				   + '<button type="button" class="btn btn-outline-primary" onclick="pop_fn_WinOrder_View(this)">주문량</button>'
				   + '<button type="button" class="btn btn-outline-primary" onclick="saveData()">저장</button>';
		var title = obj.innerText;
		var modal = new ModalProdPlan(url, title, footer);
		modal.open_modal();
	}
	
	//생산계획수정
	function pop_fn_Production_Plan_Update(obj) {
		// needtocheck
		// 작업요청서등록여부 'y'인 녀석은 수정 안되도록
		// 혹은 실제생산수량에 값이 입력된 녀석은 수정 안되도록
		
		if(selectedDate.length < 1) {
			heneSwal.warning('수정할 생산계획 날짜를 선택해주세요')
    		return false;
		} else {
			var url = '<%=Config.this_SERVER_path%>/Contents/Business/M303/S303S020102.jsp'
						+ "?selectedDate=" + selectedDate
						+ "&planRevNo=" + planRevNo;
			var footer = '<button type="button" class="btn btn-outline-primary" onclick="pop_fn_WinNwStock_View(this)">현재고량</button>'
					   + '<button type="button" class="btn btn-outline-primary" onclick="pop_fn_WinProdChulgo_View(this)">생산/출고량 이력</button>'
					   + '<button type="button" class="btn btn-outline-primary" onclick="pop_fn_WinOrder_View(this)">주문량</button>'
					   + '<button type="button" class="btn btn-outline-primary" onclick="saveData()">저장</button>';
			var title = obj.innerText;
			var modal = new ModalProdPlan(url, title, footer);
			modal.open_modal();
		}
	}
  
	//생산계획삭제
	function pop_fn_Production_Plan_Delete(obj) {
		// needtocheck
		// 작업요청서등록여부 'y'인 녀석은 삭제 안되도록
		// 혹은 실제생산수량에 값이 입력된 녀석은 삭제 안되도록
		
		if(selectedDate.length < 1) {
			heneSwal.warning('삭제할 생산계획 날짜를 선택해주세요')
    		return false;
		}
		
		var yes = confirm('해당 주문을 삭제하시겠습니까?');
		
		if(yes) {
			// 주문번호를 json 형식으로 만듬
			var data = {};
			data["prodPlanDate"] = selectedDate;
			data["planRevNo"] = planRevNo;
			var jsonStr = JSON.stringify(data);
			
			$.ajax({
		        type: "POST",
		        dataType: "json",
		        url: "<%=Config.this_SERVER_path%>/Contents/CommonView/insert_update_delete_json.jsp", 
		        data: {"bomdata" : jsonStr, "pid" : "M303S020100E003"},
		        success: function (rcvData) {
		        	if(rcvData < 0) {
		        		heneSwal.error("생산 계획 삭제 실패했습니다, 다시 시도해주세요");
		        	} else {
		        		heneSwal.success("해당 생산 계획이 삭제되었습니다");
			        	parent.fn_MainInfo_List();
			 	     	$('#modalReport').modal('hide');
		        	}
		        }
		     });	
		} else {
			return false;
		}
	}
	
	function ModalProdPlan(url, title, footer) {
		this.title = title;
		this.footer = footer;
		this.url = url;
		
		this.get_content = function() {
			$.ajax({
		    	type: "POST",
		    	url: url,
		   	  	success: function (html) {
					$('#modalBodyForPlan').html(html);
				}
			});
		};
		
		this.set_modal = function() {
			this.get_content();
	    	$('.modal-title').text(this.title);
	    	$('.modal-footer').html(this.footer);
		};
		
		this.open_modal = function() {
			this.set_modal();
			$('#modalForPlan').modal('show');
		};
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
      		<button type="button" onclick="pop_fn_Production_Plan_Insert(this)" 
      				id="insert" class="btn btn-outline-dark">생산계획등록</button>
      		<button type="button" onclick="pop_fn_Production_Plan_Update(this)" 
      				id="update" class="btn btn-outline-success">생산계획수정</button>
      		<button type="button" onclick="pop_fn_Production_Plan_Delete(this)" 
      				id="delete" class="btn btn-outline-danger">생산계획삭제</button>
      	</div>
      </div><!-- /.col -->
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

<!-- The Modal -->
<div class="modal fade bd-example-modal-xl" tabindex="-1" 
	 role="dialog" aria-labelledby="myLargeModalLabel" 
	 aria-hidden="true" id="modalForPlan">
	<div class="modal-dialog modal-xl">
		<div class="modal-content">
		
			<!-- Modal Header -->
			<div class="modal-header row">
				<div class="col-6">
					<h4 class="modal-title" id="modalTitleForPlan"></h4>
				</div>
				<div class="col-5">
				    <div class='input-group' id='dateParent'>
				    	<div class="input-group-prepend">
		          	  	  <button type="submit" class="btn btn-default">
		          	  	    <i class="fas fa-calendar"></i>
		          	  	  </button>
		          	  	</div>
						<input type='text' class='form-control float-right' id='datePlan'>
					</div>
				</div>
				<div class="col-1">
				    <button type="button" class="close" data-dismiss="modal">&times;</button>
				</div>
			</div>
      
			<!-- Modal body -->
			<div class="modal-body" id="modalBodyForPlan">
			</div>
			
			<!-- Modal footer -->
			<div class="modal-footer" id="modalFooterForPlan">
			</div>
		</div>
	</div>
</div>