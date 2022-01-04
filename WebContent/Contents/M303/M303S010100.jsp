<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="mes.client.comm.*" %>
<%@ page import="mes.client.common.*" %>
<%@ page import="mes.client.guiComponents.*" %>
<%@ page import="mes.client.util.*" %>
<%@ page import="mes.client.conf.*" %>
<%@ page import="org.json.simple.*"%><%@ include file="/strings.jsp" %>
<%
	String loginID = session.getAttribute("login_id").toString();
	if(loginID == null || loginID.equals("")) {                           			// id가 Null 이거나 없을 경우
		response.sendRedirect(Config.this_SERVER_path + "/Contents/index.jsp");    	// 로그인 페이지로 리다이렉트 한다.
	}

	String sMenuTitle = request.getParameter("MenuTitle").toString();
	String sProgramId = request.getParameter("programId").toString();
	String sHeadmenuID= request.getParameter("HeadmenuID").toString();
	String sHeadmenuName= request.getParameter("HeadmenuName").toString();
	
	Get_Program_button_Autho prg_autho = new Get_Program_button_Autho(loginID,sProgramId);
	
	Vector orderTypeCode = null;
	Vector orderTypeName = null;
	Vector orderTypeList = CommonData.getOrderType();
%>

<script type="text/javascript">   
	var vOrderDate = "";
	var vOrderNo = "";
	var vOrderRevNo = "";
	var vOrderType = "";
	
	var vCustName = "";
	var vCustCode = "";
	var vCustRevNo = "";

	var vDeliveryDate = "";
	var vDeliveryYN = "";
	var vNote = "";
	
	var startDate;
	var endDate;
	
	var maintable;
	var mainRowsData;
	var subtable;
	var subRowsData;
	
	var orderType = "";
	var vLocationType = "";
	
	$(document).ready(function () {
		
		// 주문 구분에 '전체' 추가
		$('#order_type').prepend('<option value="All" selected="selected">' +
									'전체' +
								 '</option>');
		
		let orderType = $('#order_type').val();
		
		var date = new SetRangeDate("dateParent", "dateRange", 0);
		startDate = date.start.format('YYYY-MM-DD');
	    endDate = date.end.format('YYYY-MM-DD');
		
	    // 초기 화면 업로드&세팅
	    fn_MainInfo_List(startDate, endDate, orderType);
	    displayProdSum(orderType);
		$("#InfoContentTitle").html("완제품 주문 목록");
	    fn_MainSubMenuSelect("<%=sMenuTitle%>");
	    
	    // 날짜 변경 시 화면 리로드
	    $('#dateRange').change(function() {
           	let orderType = $('#order_type').val();

           	fn_MainInfo_List(startDate, endDate, orderType);
           	displayProdSum(orderType);
        });
	    
	    // 주문 구분 변경 시 화면 리로드
	    $('#order_type').change(function() {
	    	let orderType = $('#order_type').val();
	    	
           	fn_MainInfo_List(startDate, endDate, orderType);
           	displayProdSum(orderType);
        });
	    
	    // 제품별 합계 탭 클릭 시
	    $('#prodSumList').click(function() {
	    	let orderType = $('#order_type').val();
	    	
	    	displayProdSum(orderType);
	    });
	    
	 	// 주문상세정보 탭 클릭 시
	    $('#orderDetailList').click(function() {
	    	fn_DetailInfo_List();
	    });
	});

	function fn_MainInfo_List(startDate, endDate, orderType) {
		if(orderType == "All") {
			orderType = "";
		}
		
	    $.ajax({
	        type: "POST",
	        url: "<%=Config.this_SERVER_path%>/Contents/Business/M101/S101S020100.jsp",
	        data: "From=" + startDate + 
	        	  "&To=" + endDate + 
	        	  "&orderType=" + orderType,
	        success: function (html) {
	            $("#MainInfo_List_contents").hide().html(html).fadeIn(100);
	        }
	    });
	}

	/* 
		주문상세정보 
	*/
	function fn_DetailInfo_List() {
	    $.ajax({
	        type: "POST",
	        url: "<%=Config.this_SERVER_path%>/Contents/Business/M101/S101S020110.jsp",
            data: "OrderNo=" + vOrderNo + "&OrderRevNo=" + vOrderRevNo,
	        success: function (html) {
	            $("#tab1").hide().html(html).fadeIn(100);
	        }
	    });
	}
	
	/* 
		제품별 합계 수량 조회 테이블
	*/
	function displayProdSum(orderType) {
		if(orderType == "All") {
			orderType = "";
		}
		
	    $.ajax({
	        type: "POST",
	        url: "<%=Config.this_SERVER_path%>/Contents/Business/M101/S101S020120.jsp",
	        data: "startDate=" + startDate + 
	        	  "&endDate=" + endDate + 
	        	  "&orderType=" + orderType,
	        success: function (html) {
	            $("#tab1").hide().html(html).fadeIn(100);
	        }
	    });
	}
  
	/* 
		주문정보 등록
	*/
	function pop_fn_JumunInfo_Insert(obj) {
		var url = "<%=Config.this_SERVER_path%>/Contents/Business/M101/S101S020101.jsp";
		var footer = '<button id="btn_Save" class="btn btn-info"'
					 		+ 'onclick="SaveOderInfo();">저장</button>';
		var title = obj.innerText;
		var heneModal = new HenesysModal(url, 'large', title, footer);
		heneModal.open_modal();
	}
	
	/* 
		주문정보 수정 
	*/
	function pop_fn_JumunInfo_Update(obj) {
		if(vOrderNo.length < 1) {
			heneSwal.warning('주문 정보를 선택하세요');
			return false;
		}
		
		if(vDeliveryYN == 'Y') {
			heneSwal.warning('납품 완료된 주문입니다');
			return false;
		}
		
		subRowsData = subtable.rows().data();
		
		var url = "<%=Config.this_SERVER_path%>/Contents/Business/M101/S101S020102.jsp"
					+ "?orderNo=" + vOrderNo 
					+ "&orderType=" + vOrderType 
					+ "&orderDate=" + vOrderDate
					+ "&orderRevNo=" + vOrderRevNo
					+ "&custName=" + vCustName
					+ "&custCode=" + vCustCode
					+ "&custRevNo=" + vCustRevNo
					+ "&deliveryDate=" + vDeliveryDate
					+ "&note=" + vNote
		var footer = '<button id="btn_Save" class="btn btn-info" onclick="updateOrderInfo();">저장</button>';
		var title = obj.innerText;
		var heneModal = new HenesysModal(url, 'large', title, footer);
		heneModal.open_modal();
	}
	
	/* 
		납품완료 처리 
	*/
	function pop_fn_JumunInfo_Comlete(obj) {
		if(vOrderNo.length < 1) {
			heneSwal.warning('삭제할 주문을 선택하세요');
			return false;
		}
		
		if(vDeliveryYN == 'Y') {
			heneSwal.warning('이미 납품 완료된 주문입니다');
			return false;
		}
	
		var url = "<%=Config.this_SERVER_path%>/Contents/Business/M101/S101S020122.jsp"
					+ "?orderNo=" + vOrderNo 
					+ "&orderRevNo=" + vOrderRevNo; 
		var footer = '<button id="btn_Save" class="btn btn-info" style="width:100px"'
							+ 'onclick="SaveOderInfo();">처리완료</button>';
		var title = obj.innerText;
		var heneModal = new HenesysModal(url, 'large', title, footer);
		heneModal.open_modal();
	}
	
	/* 
		주문정보삭제 
	*/
	function pop_fn_JumunInfo_Delete(obj) {
		if(vOrderNo.length < 1) {
			heneSwal.warning('삭제할 주문을 선택하세요');
			return false;
		}
		
		if(vDeliveryYN == 'Y') {
			heneSwal.warning('이미 납품 완료된 주문입니다');
			return false;
		}
		
		var data = {"orderNo":vOrderNo};
		var jsonStr = JSON.stringify(data);
		
		var chekrtn = confirm('해당 주문을 삭제하시겠습니까?');
		
		if(chekrtn) {
	    	sendToJsp(jsonStr, "M101S020100E103");
	    } else{
    		return false;
    	}
		
		
		function sendToJsp(jsonStr, pid) {
			$.ajax({
		        type: "POST",
		        dataType: "json",
		        url: "<%=Config.this_SERVER_path%>/Contents/CommonView/insert_update_delete_json.jsp", 
		        data: {"bomdata" : jsonStr, "pid" : pid},
		        success: function (rcvData) {
		        	if(rcvData < 0) {
		        		heneSwal.error("주문 삭제 실패했습니다, 다시 시도해주세요");
		        	} else {
		        		heneSwal.success("해당 주문이 삭제되었습니다");
			        	parent.fn_MainInfo_List(startDate, endDate, orderType);
			        	$("#tab1").children().remove();
			 	     	$('#modalReport').modal('hide');
		        	}
		        }
			});
		}
		
	}
	
	// 거래명세표 조회
    function displayOrderDoc2(element) {
		
    	if(vOrderNo.length < 1) {
			heneSwal.warning('명세표를 조회할 주문정보를 선택하세요');
			return false;
		}
    	
    		const format = 'images/order/20210608_order_doc_img.jpg';	// 이미지 파일
    		const page = '/Contents/Business/M303/S303S010105.jsp';		// jsp 페이지
    			
		    const modalUrl = '<%=Config.this_SERVER_path%>' + page
		    				    + '?format=' + format
		    				    + '&order_date=' + vOrderDate
		    				    + '&order_no=' + vOrderNo
		    				    + '&order_rev_no=' + vOrderRevNo
		    				    + '&location_type=' + vLocationType;
		    				   
			const footer = "<button type='button' class='btn btn-outline-primary'"
							+ "onclick='printChecklist()'>출력</button>";
			const title = element.innerText;
			const heneModal = new HenesysModal(modalUrl, 'auto', title, footer);
			heneModal.open_modal();
    	
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
      		<button type="button" onclick="pop_fn_JumunInfo_Insert(this)" id="insert" class="btn btn-outline-dark">주문서 등록</button>
      		<button type="button" onclick="pop_fn_JumunInfo_Update(this)" id="update" class="btn btn-outline-success">주문서 수정</button>
      		<button type="button" onclick="pop_fn_JumunInfo_Delete(this)" id="delete" class="btn btn-outline-danger">주문서 삭제</button>
      		<button type="button" onclick="displayOrderDoc2(this)" id="select" class="btn btn-outline-dark">거래명세표 조회</button>
      		<!-- <button type="button" onclick="pop_fn_JumunDoc_Insert(this)" id="insert" class="btn btn-outline-dark">주문문서등록</button> -->
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
						<div class="row">
							<div class="col-sm-8">
					          	<h3 class="card-title">
					          		<i class="fas fa-edit" id="InfoContentTitle"></i>
					          	</h3>
				          	</div>
				          	<div class="form-group form-inline col-sm-2">
								<label for="order_type">주문 구분 :</label>&nbsp;&nbsp;
								<select class="form-control" id="order_type">
						        	<% orderTypeCode = (Vector) orderTypeList.get(1);%>
						            <% orderTypeName = (Vector) orderTypeList.get(2);%>
						            <% for(int i = 0; i < orderTypeName.size(); i++) { %>
										<option value='<%=orderTypeCode.get(i).toString()%>'>
											<%=orderTypeName.get(i).toString()%>
										</option>
									<%} %>
								</select>
				          	</div>
							<div class="col-sm-2">
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
        			</div>
					<div class="card-body" id="MainInfo_List_contents">
					</div> 
 					</div>
				</div>
			    <!-- /.col-md-6 -->
			</div>
    		<!-- /.row -->
			<div class="card card-primary card-outline">
		    	<div class="card-header">
		    		<h3 class="card-title">
		    			<i class="fas fa-edit">세부 정보</i>
		    		</h3>
		    	</div>
    			<div class="card-body">
		    		<ul class="nav nav-tabs" id="custom-tabs-one-tab" role="tablist">
			       		<li class="nav-item active" id="prodSumList">
			       			<a class="nav-link" data-toggle="tab" 
			       			   href="#tab1" role="tab">제품별 합계</a>
			       		</li>
			           	<li class="nav-item" id="orderDetailList">
			       			<a class="nav-link" id="DetailInfo_List" data-toggle="tab" 
			       			   href="#tab2" role="tab">주문상세정보</a>
			       		</li>
			     	</ul>
			     	<div class="tab-content" id="custom-tabs-one-tabContent">
			     		<div class="tab-pane fade active show" id="tab1" role="tabpanel"></div>
			        </div>
        		</div>
			</div>
		</div><!-- /.container-fluid -->
	</div>
<!-- /.content -->
