<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="mes.client.comm.*" %>
<%@ page import="mes.client.common.*" %>
<%@ page import="mes.client.guiComponents.*" %>
<%@ page import="mes.client.util.*" %>
<%@ page import="mes.client.conf.*" %>

<!-- 생산실적관리 -->

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
	// M303S050100 공통 변수
	var selectedDate;	// 안쓰는 듯? needtocheck
	var startDate;
	var endDate;
	
	// 메인테이블 관련 변수
	var vManufacturingDate = "";
	var vRequestRevNo = "";
	var vProdPlanDate = "";
	var vProdName = "";
	var vGugyuk = "";
	var vPlanAmount = "";			// 계획수량
	var vRealAmount = "";			// 실제수량
	var vPlanNote = "";
	var vPlanRevNo = "";
	var vProdCd = "";
	var vProdRevNo = "";
	var vExpirationDate = "";
	var vWorkStatus = "";
	var vPlanStorageMapper = "";
	var vProdJournalNote = "";
	
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
    	var date = new SetRangeDate("dateParent", "dateRange", 30);
    	startDate = date.start.format('YYYY-MM-DD');
       	endDate = date.end.format('YYYY-MM-DD');
    	
	    fn_MainInfo_List(startDate, endDate);       	
	    
		$("#InfoContentTitle").html("생산 완료 목록");
	    fn_MainSubMenuSelect("<%=sMenuTitle%>");
	    
	    // 날짜 변경 시 새로고침
	    $('#dateRange').change(function() {
           	fn_MainInfo_List(startDate, endDate);
        });
	
	});

    function fn_MainInfo_List(startDate, endDate) {
        
        $.ajax({
            type: "POST",
            url: "<%=Config.this_SERVER_path%>/Contents/Business/M303/S303S050100.jsp",
            data: "startDate=" + startDate + "&endDate=" + endDate,
            beforeSend: function () {
				$("#MainInfo_List_contents").children().remove();
            },
            success: function (html) {
                $("#MainInfo_List_contents").hide().html(html).fadeIn(100);
            }
        });
        
        $("#SubInfo_List_contents").children().remove();
    }
    
	function fn_DetailInfo_List() {     
    	$.ajax({
   	    	type: "POST",
   	        url: "<%=Config.this_SERVER_path%>/Contents/Business/M303/S303S050110.jsp",
   	        data: "requestRevNo=" + vRequestRevNo + "&prodPlanDate=" + vProdPlanDate +
   	        	  "&planRevNo=" + vPlanRevNo + "&prodCd=" + vProdCd +
   	        	  "&prodRevNo=" + vProdRevNo + "&manufacturingDate=" + vManufacturingDate,
   	        success: function (html) {
   	            $("#SubInfo_List_contents").hide().html(html).fadeIn(100);
   	        }
   	    });
	}
    
	/* 
	 * 작업상태 확인
	 * 현장 담당자가 실적 제출한 상태 (1) 
	 * 사무 담당자가 실적 확인한 상태 (2)
	 * return : 1 or 2
	*/
	function checkWorkStatus(status) {
		var returnVal = '';
		
		switch (status) {
		  case '제출':	// 현장 작업자가 실적 제출한 상태
		    returnVal = 1;
		    break;
		  case '확인':	// 사무실 담당자가 모든걸 확인해서 완료된 상태
			returnVal = 2;
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
	
	/* 
		현장 담당자가 등록한 실적을 확인 후 컨펌
		생산작업요청의 상태가 '제출' -> '확인'으로 변경됨
	*/
	function confirmWorkResult() {
		var confirmed = confirm('현장 담당자가 기입한 내역에 이상이 없습니까?\n'+
								'확인을 누르시면 실적 확인 처리됩니다');
		
		if(confirmed == true) {
			var status = checkWorkStatus(vWorkStatus);
	    	var selected = checkIfSelectedRow("#tableS303S050100_body");
	    	
	    	if(selected == false) {
	    		heneSwal.warning('확인 완료할 목록을 선택해주세요');
	    		return false;
	    	} else if(status == 2) {
	    		heneSwal.warning('이미 확인 완료된 목록입니다');
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
	                data: {"bomdata":jsonStr, "pid":"M303S050100E102"},
	                beforeSend: function () {
	    				$("#MainInfo_List_contents").children().remove();
	                },
	                success: function (receive) {
	                	if(receive > -1) {
	                		heneSwal.success('실적 확인 완료되었습니다');
	                		fn_MainInfo_List(startDate, endDate);
	                	} else {
	                		heneSwal.error('실적 확인 실패했습니다. 다시 시도해주세요.');
	                		fn_MainInfo_List(startDate, endDate);
	                	}
	                }
	            });
	    	} 
		} else {
			return false;
		}
    }
	
	// 생산실적수정
	function modifyWorkResult(obj) {
		var status = checkWorkStatus(vWorkStatus);
    	var selected = checkIfSelectedRow("#tableS303S050100_body");
    	
    	if(selected == false) {
    		heneSwal.warning('수정할 목록을 선택해주세요');
    		return false;
    	} else if(status == 2) {
    		heneSwal.warning('이미 확인 완료된 항목은 완제품 입출고 관리 <br>메뉴의 재고 보정 기능을 활용해주세요');
    		return false;
    	} else {
		
			var url = "<%=Config.this_SERVER_path%>/Contents/Business/M303/S303S050102.jsp"
					+ "?manufacturingDate=" + vManufacturingDate
					+ "&requestRevNo=" + vRequestRevNo
					+ "&prodPlanDate=" + vProdPlanDate
					+ "&planRevNo=" + vPlanRevNo
					+ "&prodCd=" + vProdCd
					+ "&prodRevNo=" + vProdRevNo
					+ "&prodName=" + vProdName
					+ "&planAmount=" + vPlanAmount
					+ "&realAmount=" + vRealAmount
					+ "&expirationDate=" + vExpirationDate
					+ "&prodJournalNote=" + vProdJournalNote
					+ "&planStorageMapper=" + vPlanStorageMapper;
	
			var footer = '<button type="button" class="btn btn-outline-primary" onclick="SaveOderInfo()">저장</button>';
			var title = obj.innerText;
			
			var heneModal = new HenesysModal(url, 'standard', title, footer);
			heneModal.open_modal();
    	}
    }
    
	// 생산실적삭제
    function deleteWorkResult(obj) {
    	var status = checkWorkStatus(vWorkStatus);
    	var selected = checkIfSelectedRow("#tableS303S050100_body");
    	
    	if(selected == false) {
    		heneSwal.warning('삭제할 목록을 선택해주세요');
    		return false;
    	} else if(status == 2) {
    		heneSwal.warning('이미 확인 완료된 항목은 삭제가 불가능합니다');
    		return false;
    	} else {
    		
    		var url = "<%=Config.this_SERVER_path%>/Contents/Business/M303/S303S050103.jsp"
	    			+ "?manufacturingDate=" + vManufacturingDate
					+ "&requestRevNo=" + vRequestRevNo
					+ "&prodPlanDate=" + vProdPlanDate
					+ "&planRevNo=" + vPlanRevNo
					+ "&prodCd=" + vProdCd
					+ "&prodRevNo=" + vProdRevNo
					+ "&prodName=" + vProdName
					+ "&planAmount=" + vPlanAmount
					+ "&realAmount=" + vRealAmount
					+ "&expirationDate=" + vExpirationDate
					+ "&prodJournalNote=" + vProdJournalNote
					+ "&planStorageMapper=" + vPlanStorageMapper;
    		
    		var footer = '<button type="button" class="btn btn-outline-primary" onclick="SaveOderInfo()">삭제</button>';
    		var title = obj.innerText;
    		
    		var heneModal = new HenesysModal(url, 'standard', title, footer);
    		heneModal.open_modal();
    	}
    }
    
    function editBlendingDoc(obj) {
    	
    	var selected = checkIfSelectedRow("#tableS303S050110_body");
    	
    	if(selected == false) {
    		heneSwal.warning('배합일지 항목을 선택해주세요')
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
					+ "&diffReason=" + vDiffReason;

    		var footer = '<button type="button" class="btn btn-outline-primary" onclick="updateBlendingDoc()">저장</button>';
			var title = obj.innerText;
			var heneModal = new HenesysModal(url, 'standard', title, footer);
			heneModal.open_modal();
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
      		<button type="button" onclick="confirmWorkResult()" class="btn btn-outline-dark">실적확인</button>
      		<button type="button" onclick="modifyWorkResult(this)" class="btn btn-outline-success">실적수정</button>
      		<button type="button" onclick="deleteWorkResult(this)" class="btn btn-outline-danger">실적삭제</button>
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
      <!-- /.col-md-12 -->
    </div>
    <!-- /.row -->
    <div class="card card-primary card-outline">
    	<div class="card-header">
    		<h3 class="card-title">
    			<i class="fas fa-edit">세부 정보</i>
    		</h3>
    		<div class="card-tools">
				<button type="button" onclick="editBlendingDoc(this)" id="insertDoc" class="btn btn-outline-success">
					배합일지수정
				</button>          	  
          	</div>
    	</div>
    	<div class="card-body">
    		<ul class="nav nav-tabs" id="custom-tabs-one-tab" role="tablist">
	       		<li class="nav-item" onclick='fn_DetailInfo_List()'>
	       			<a class="nav-link" id="DetailInfo_List" data-toggle="pill" href="#SubInfo_List_contents" role="tab">
	       				작업지시정보
	       			</a>
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