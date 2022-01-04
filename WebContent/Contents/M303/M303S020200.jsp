<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="mes.client.comm.*" %>
<%@ page import="mes.client.common.*" %>
<%@ page import="mes.client.guiComponents.*" %>
<%@ page import="mes.client.util.*" %>
<%@ page import="mes.client.conf.*" %>

<!-- 
현장생산관리
M303S020200.jsp
-->

<%
	String loginID = session.getAttribute("login_id").toString();
	if(loginID == null || loginID.equals("")) {         // id가 Null 이거나 없을 경우
		response.sendRedirect("Contents/index.jsp");    // 로그인 페이지로 리다이렉트 한다.
	}

	String sMenuTitle = request.getParameter("MenuTitle").toString();
	String sProgramId = request.getParameter("programId").toString();
	String sHeadmenuID= request.getParameter("HeadmenuID").toString();
	String sHeadmenuName= request.getParameter("HeadmenuName").toString();
	
	Get_Program_button_Autho prg_autho = new Get_Program_button_Autho(loginID, sProgramId);
%>  

<script type="text/javascript">
	// M303S020200 공통 변수
	var selectedDate;
	
	// 메인테이블 관련 변수
	var vManufacturingDate = "";
	var vRequestRevNo = "";
	var vProdPlanDate = "";
	var vProdName = "";
	var vPlanAmount = "";
	var vPlanNote = "";
	var vPlanRevNo = "";
	var vProdCd = "";
	var vProdRevNo = "";
	var vExpirationDate = "";
	var vWorkStatus = "";
	var vWorkTime = "";
	var vWorkStartTime = "";
	var vWorkEndTime = "";
	
	// 서브테이블 관련 변수
	var vPartNm = "";
	var vBlendingRatio = "";
	var vBlendingAmtPlan = "";
	var vBlendingAmtReal = "";
	var vDiffReason = "";
	var vPartCd = "";
	var vPartRevNo = "";
	var vBomRevNo = "";
	
    $(document).ready(function () {
    	
    	// 초기 날짜  설정 및 메인테이블 조회
    	new SetSingleDate2("", "#singledate", 0);
    	selectedDate = $('#singledate').val();
	    fn_MainInfo_List(selectedDate);
	    
		$("#InfoContentTitle").html("생산작업 목록");
	    fn_MainSubMenuSelect("<%=sMenuTitle%>");
	    
	    // 날짜 변경 시 새로고침
	    $('#singledate').change(function() {
	    	selectedDate = $('#singledate').val()
	    	fn_MainInfo_List(selectedDate);
	    })
	});

    function fn_MainInfo_List(selectedDate) {
        
        $.ajax({
            type: "POST",
            url: "<%=Config.this_SERVER_path%>/Contents/Business/M303/S303S020200.jsp",
            data: "date=" + selectedDate,
            beforeSend: function () {
				$("#MainInfo_List_contents").children().remove();
            },
            success: function (html) {
                $("#MainInfo_List_contents").hide().html(html).fadeIn(100);
            }
        });
    }
    
	function fn_DetailInfo_List() {     
    	$.ajax({
   	    	type: "POST",
   	        url: "<%=Config.this_SERVER_path%>/Contents/Business/M303/S303S020210.jsp",
   	        data: "requestRevNo=" + vRequestRevNo + "&prodPlanDate=" + vProdPlanDate +
   	        	  "&planRevNo=" + vPlanRevNo + "&prodCd=" + vProdCd +
   	        	  "&prodRevNo=" + vProdRevNo + "&manufacturingDate=" + vManufacturingDate,
   	        success: function (html) {
   	            $("#SubInfo_List_contents").hide().html(html).fadeIn(100);
   	        }
   	    });
	}
    
	/* 
	 * 작업상태 확인(요청,작업중,중지,완료)
	 * 작업시작(1) 작업중지(2) 작업완료(3) 원료배합일지제출(4)
	 * return : 1 ~ 4
	*/
	function checkWorkStatus(status) {
		var returnVal = '';
		
		switch (status) {
		  case '요청':
		    returnVal = 1;
		    break;
		  case '작업중':
			returnVal = 2;
		    break;
		  case '정지':
			returnVal = 3;
		    break;
		  case '완료':
			returnVal = 4;
		    break;
		}
		
		return returnVal;
	}
	
	/* 
	* role : 파라미터로 받은 태그 중 tr 태그에 'selected'
	* 		  클래스의 존재 여부 확인(선택된 행이 있는지 확인)
	* return : true or false
	*/
	function checkIfSelectedRow(parentTag) {
		var tag = $(parentTag);
		var exist = tag.find("tr").hasClass("selected");

		return exist;
	}
	
    function startWork() {
    	var status = checkWorkStatus(vWorkStatus);
    	var selected = checkIfSelectedRow("#tableS303S020200_body");
    	
    	if(status == 2 || status == 4) {
    		heneSwal.warningTimer('이미 작업중이거나 완료된 상태입니다')
    		return false;
    	} else if(selected == false) {
    		heneSwal.warningTimer('작업 시작할 목록을 선택해주세요')
    		return false;
    	} else {
    		
    		var jsonData = new Object();
    		
    		jsonData.manufacturingDate = vManufacturingDate;
    		jsonData.requestRevNo = vRequestRevNo;
    		jsonData.prodPlanDate = vProdPlanDate;
    		jsonData.planRevNo = vPlanRevNo;
    		jsonData.prodCd = vProdCd;
    		jsonData.prodRevNo = vProdRevNo;
    		
    		var jsonStr = JSON.stringify(jsonData);
    		
    		$.ajax({
                type: "POST",
                url: "<%=Config.this_SERVER_path%>/Contents/CommonView/insert_update_delete_json.jsp",
                data: {"bomdata":jsonStr, "pid":"M303S020200E102"},
                beforeSend: function () {
    				$("#MainInfo_List_contents").children().remove();
                },
                success: function (receive) {
                	if(receive > -1) {
                		heneSwal.successTimer('작업이 시작 상태로 변경되었습니다');
                		fn_MainInfo_List(selectedDate);
                	} else {
                		heneSwal.errorTimer('작업상태 변경에 실패했습니다. 다시 시도해주세요.');
                		fn_MainInfo_List(selectedDate);
                	}
                }
            });
    	}
    }
    
    function pauseWork() {
    	var status = checkWorkStatus(vWorkStatus);
    	var selected = checkIfSelectedRow("#tableS303S020200_body");
    	
    	if(status != 2) {
    		heneSwal.warningTimer('작업중 상태가 아닙니다')
    		return false;
    	} else if(selected == false) {
    		heneSwal.warningTimer('작업 시작할 목록을 선택해주세요')
    		return false;
    	} else {
    		
    		var jsonData = new Object();
    		
    		jsonData.manufacturingDate = vManufacturingDate;
    		jsonData.requestRevNo = vRequestRevNo;
    		jsonData.prodPlanDate = vProdPlanDate;
    		jsonData.planRevNo = vPlanRevNo;
    		jsonData.prodCd = vProdCd;
    		jsonData.prodRevNo = vProdRevNo;
    		
    		var jsonStr = JSON.stringify(jsonData);
    		
    		$.ajax({
                type: "POST",
                url: "<%=Config.this_SERVER_path%>/Contents/CommonView/insert_update_delete_json.jsp",
                data: {"bomdata":jsonStr, "pid":"M303S020200E112"},
                beforeSend: function () {
    				$("#MainInfo_List_contents").children().remove();
                },
                success: function (receive) {
                	if(receive > -1) {
                		heneSwal.successTimer('작업이 정지 상태로 변경되었습니다');
                		fn_MainInfo_List(selectedDate);
                	} else {
                		heneSwal.errorTimer('작업상태 변경에 실패했습니다. 다시 시도해주세요.');
                		fn_MainInfo_List(selectedDate);
                	}
                }
            });
    	}
    }
    
    function finishWork(obj) {
    	var status = checkWorkStatus(vWorkStatus);
    	var selected = checkIfSelectedRow("#tableS303S020200_body");
    	
    	if(status == 4) {
    		heneSwal.warningTimer('이미 완료된 상태입니다')
    		return false;
    	} else if(status == 1) {
    		heneSwal.warningTimer('요청 상태의 작업입니다')
    		return false;
    	} else if(selected == false) {
    		heneSwal.warningTimer('작업 완료할 목록을 선택해주세요')
    		return false;
    	} else {
    		
    		var url = "<%=Config.this_SERVER_path%>/Contents/Business/M303/S303S020202.jsp"
						+ "?manufacturingDate=" + vManufacturingDate
						+ "&requestRevNo=" + vRequestRevNo
						+ "&prodPlanDate=" + vProdPlanDate
						+ "&planRevNo=" + vPlanRevNo
						+ "&prodCd=" + vProdCd
						+ "&prodRevNo=" + vProdRevNo
						+ "&prodName=" + vProdName
						+ "&planAmount=" + vPlanAmount
						+ "&expirationDate=" + vExpirationDate
						+ "&date=" + selectedDate
    					+ "&workTime=" + vWorkTime
    					+ "&workStartTime=" + vWorkStartTime
    					+ "&workEndTime =" + vWorkEndTime;
    		
    		var footer = '<button type="button" class="btn btn-outline-primary" onclick="SaveOderInfo()">저장</button>';
    		var title = obj.innerText;
    		
    		var heneModal = new HenesysModal(url, 'standard', title, footer);
    		heneModal.open_modal();
    	}
    }
    
    function editBlendingDoc(obj) {
    	
    	var selected = checkIfSelectedRow("#tableS303S040110_body");
    	
    	if(selected == false) {
    		heneSwal.warningTimer('배합일지를 등록할 항목을 선택해주세요')
    		return false;
    	} else {
    		var url = "<%=Config.this_SERVER_path%>/Contents/Business/M303/S303S020212.jsp"
					+ "?manufacturingDate=" + vManufacturingDate
					+ "&requestRevNo=" + vRequestRevNo
					+ "&prodPlanDate=" + vProdPlanDate
					+ "&planRevNo=" + vPlanRevNo
					+ "&prodCd=" + vProdCd
					+ "&prodRevNo=" + vProdRevNo
					+ "&partCd=" + vPartCd
					+ "&partRevNo=" + vPartRevNo
					+ "&bomRevNo=" + vBomRevNo
					+ "&partNm=" + vPartNm
					+ "&blendingRatio=" + vBlendingRatio
					+ "&blendingAmtPlan=" + vBlendingAmtPlan
					+ "&blendingAmtReal=" + vBlendingAmtReal
					+ "&diffReason=" + vDiffReason
					+ "&date=" + selectedDate;

    		var footer = '<button type="button" class="btn btn-outline-primary" onclick="updateBlendingDoc()">저장</button>';
			var title = obj.innerText;
			var heneModal = new HenesysModal(url, 'standard', title, footer);
			heneModal.open_modal();
    	}
    }
    
    function submitBlendingDoc() {
    	var status = checkWorkStatus(vWorkStatus);
    	var selected = checkIfSelectedRow("#tableS303S020200_body");
    	
    	if(selected == false) {
    		heneSwal.warningTimer('배합일지 제출할 계획 목록을 선택해주세요')
    		return false;
    	} else if(status != 4) {
    		heneSwal.warningTimer('생산 완료 상태가 아닙니다')
    		return false;
    	} else {
    		
    		var jsonData = new Object();
    		
    		jsonData.manufacturingDate = vManufacturingDate;
    		jsonData.requestRevNo = vRequestRevNo;
    		jsonData.prodPlanDate = vProdPlanDate;
    		jsonData.planRevNo = vPlanRevNo;
    		jsonData.prodCd = vProdCd;
    		jsonData.prodRevNo = vProdRevNo;
    		
    		var jsonStr = JSON.stringify(jsonData);
    		
    		var confirmed = confirm('원료배합일지를 제출하시겠습니까?');
    		
    		if(confirmed) {
	    		$.ajax({
	                type: "POST",
	                url: "<%=Config.this_SERVER_path%>/Contents/CommonView/insert_update_delete_json.jsp",
	                data: {"bomdata":jsonStr, "pid":"M303S020200E132"},
	                beforeSend: function () {
	    				$("#MainInfo_List_contents").children().remove();
	                },
	                success: function (receive) {
	                	if(receive > -1) {
	                		heneSwal.successTimer('원료배합일지 제출이 완료되었습니다.');
	                		fn_MainInfo_List(selectedDate);
	                		$("#SubInfo_List_contents").hide();
	                	} else {
	                		heneSwal.errorTimer('원료배합일지 제출에 실패했습니다. 다시 시도해주세요.');
	                		fn_MainInfo_List(selectedDate);
	                	}
	                }
	            });
    		}
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
      		<button type="button" onclick="startWork()" id="start" class="btn btn-outline-dark">작업시작</button>
      		<button type="button" onclick="finishWork(this)" id="finish" class="btn btn-outline-dark">작업완료</button>
      		<button type="button" onclick="pauseWork(this)" id="pause" class="btn btn-outline-danger">작업정지</button>
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
          	  	<input type="text" class="form-control float-right" id="singledate">
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
      <!-- /.col-md-12 -->
    </div>
    <!-- /.row -->
    <div class="card card-primary card-outline">
    	<div class="card-header">
    		<h3 class="card-title">
    			<i class="fas fa-edit">세부 정보</i>
    		</h3>
    		<div class="card-tools">
				<button type="button" onclick="editBlendingDoc(this)" id="insertDoc" class="btn btn-outline-dark">배합일지입력</button>          	  
				<button type="button" onclick="submitBlendingDoc()" id="submitDoc" class="btn btn-outline-dark">배합일지제출</button>          	  
          	</div>
    	</div>
    	<div class="card-body">
    		<ul class="nav nav-tabs" id="custom-tabs-one-tab" role="tablist">
	       		<li class="nav-item" onclick='fn_DetailInfo_List()'>
	       			<a class="nav-link" id="DetailInfo_List" data-toggle="pill" href="#SubInfo_List_contents" role="tab">작업지시정보</a>
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