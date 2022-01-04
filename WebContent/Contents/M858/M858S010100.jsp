<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="mes.client.comm.*" %>
<%@ page import="mes.client.guiComponents.*" %>
<%@ page import="mes.client.util.*" %>
<%@ page import="mes.client.conf.*" %>
<!-- 
출하관리 (M858S010100)
yumsam
-->

<%  
	String loginID = session.getAttribute("login_id").toString();
	String member_key = session.getAttribute("member_key").toString();
	if(loginID==null||loginID.equals("")){                            				// id가 Null 이거나 없을 경우
		response.sendRedirect(Config.this_SERVER_path + "/Contents/index.jsp");    	// 로그인 페이지로 리다이렉트 한다."NON"
	}

	String sMenuTitle = request.getParameter("MenuTitle").toString();
	String sProgramId = request.getParameter("programId").toString();
	String sHeadmenuID= request.getParameter("HeadmenuID").toString();
	String sHeadmenuName= request.getParameter("HeadmenuName").toString();
	
	Get_Program_button_Autho prg_autho = new Get_Program_button_Autho(loginID, sProgramId);	
	
	CurrentPage jspPageName = new CurrentPage(request.getRequestURI());
	String JSPpage = jspPageName.GetJSP_FileName();
	ProcesStatusCheck prcStatusCheck = new ProcesStatusCheck(JSPpage+"|"+"ODPROCS"+"|");

	String GV_PROCESS_MODIFY	= prcStatusCheck.GV_PROCESS_MODIFY;
	String GV_PROCESS_DELETE	= prcStatusCheck.GV_PROCESS_DELETE;
	String GV_PROCESS_NAME		= prcStatusCheck.GV_PROCESS_NAME;
	String GV_GET_NUM_PREFIX	= prcStatusCheck.GV_PROCESS_NUMBER_GUBUN;
%>

<script>
 	var vChulhaNo = "";
 	var vChulhaRevNo = "";
 	var vChulhaDate = "";
 	var vOrderNo = "";
 	var vOrderRevNo = "";
 	var vCustNm = "";
 	var vChulhaNote = "";
 	var vOrderDate = "";
 	var vDeliveryDate = "";
 	var vOrderNote = "";
 	var vProdNm	= "";
 	var vChulhaCount = "";
 	var vChulhaDetailNote = "";
 	var vCustCd = "";
 	var vCustRevNo = "";
 	var vDriver = "";
 	var vVehicleCd = "";
 	var vVehicleRevNo = "";
 	var prodName = "";
 	var chulhaCount = "";
 	var chulhaNote = "";
 	var prodDate = "";
 	var seqNo = "";
 	var prodCode = "";
 	var prodRevNO = "";
 	var vDriver = "";
 	var vDriverId = "";
 	var vCompanyTypeNm = "";
 	var vCompanyType = "";
 	
	var startDate;
	var endDate;
	
    $(document).ready(function () {
    	vChulhaNo = "";
    	var date = new SetRangeDate("dateParent", "dateRange", 30);
		startDate = date.start.format('YYYY-MM-DD');
		endDate = date.end.format('YYYY-MM-DD');
		
		fn_MainInfo_List(startDate, endDate);
	
		$("#InfoContentTitle").html("출하 목록");
 		fn_MainSubMenuSelect("<%=sMenuTitle%>");
		
		$('#dateRange').change(function() {
           	fn_MainInfo_List(startDate, endDate);
        });
		
		// 출하 정보 등록
		$('#insertBtn').click(function() {
			$.ajax({
		    	type: "POST",
		    	url: "<%=Config.this_SERVER_path%>/Contents/Business/M858/S858S010101.jsp",
		   	  	success: function (html) {
		   	  		$('#chulhaModal').removeData('modal');
					$('#chulhaModal').html(html);
					$('#chulhaModal').modal('show');
		   	  	},
		   	  	error: function() {
		   	  		console.log('error');
		   	  	}
			});
		});
		
		// 출하 정보 수정
		$('#updateBtn').click(function() {
			
			if(vChulhaNo.length < 1){
	    		heneSwal.warning('수정할 출하정보를 선택하세요');
				return false;
			}
			
			$.ajax({
	    		type: "POST",
	    		url: "<%=Config.this_SERVER_path%>/Contents/Business/M858/S858S010106.jsp",
	    		data : "chulha_count=" + vChulhaCount
				  		+ "&chulha_no=" + vChulhaNo
				  		+ "&chulha_rev_no=" + vChulhaRevNo
				  		+ "&chulha_date=" + vChulhaDate
				  		+ "&driver_id=" + vDriverId
				  		+ "&vehicle_cd=" + vVehicleCd
				  		+ "&vehicle_rev_no=" + vVehicleRevNo
				  		+ "&location_type=" + vCompanyType
				  		+ "&location_type_nm=" + vCompanyTypeNm
				  		+ "&order_no=" + vOrderNo
						+ "&order_rev_no=" + vOrderRevNo
						+ "&chulha_note=" + vChulhaNote
						+ "&cust_nm=" + vCustNm
						+ "&order_date=" + vOrderDate
						+ "&delivery_date=" + vDeliveryDate,
						
	   	  		success: function (html) {
					$('#chulhaModal').html(html);
					$('#chulhaModal').modal('show');
	   	  		},
	   	  		error: function() {
	   	  			console.log('error');
	   	  		}
			});
		});
		
    });
    

    function fn_MainInfo_List(startDate, endDate) {
        
        $.ajax({
            type: "POST",
            url: "<%=Config.this_SERVER_path%>/Contents/Business/M858/S858S010100.jsp",
            data: "startDate=" + startDate + 
            	  "&endDate=" + endDate,
            success: function (html) {
                $("#MainInfo_List_contents").hide().html(html).fadeIn(100);
            }
        });
        
        $("#SubInfo_List_contents").children().remove();
    }

    //주문상세정보 
    function fn_DetailInfo_List() {    	
        
        $.ajax({
            type: "POST",
            url: "<%=Config.this_SERVER_path%>/Contents/Business/M858/S858S010110.jsp",
            data: "chulhaNo=" + vChulhaNo + "&chulhaRevNo=" + vChulhaRevNo 
            	  +"&orderNo=" + vOrderNo + "&chulhaDate=" + vChulhaDate,
            success: function (html) {
                $("#SubInfo_List_contents").hide().html(html).fadeIn(100);
            }
        });
    }
    
 	// 출하정보수정
    function updateChulhaInfo(obj) {  
 		
		if(vChulhaNo.length < 1){
    		heneSwal.warning('수정할 출하정보를 선택하세요');
			return false;
		}
    	
		var url = "<%=Config.this_SERVER_path%>/Contents/Business/M858/S858S010106.jsp"
					+ "?order_date=" + vOrderDate 
					+ "&cust_nm=" + vCustNm
					+ "&delivery_date=" + vDeliveryDate
					+ "&order_note=" + vOrderNote
					+ "&chulha_note=" + vChulhaNote
					+ "&order_no=" + vOrderNo
					+ "&order_rev_no=" + vOrderRevNo
					+ "&product_nm=" + vProdNm
					+ "&chulha_count=" + vChulhaCount
					+ "&chulha_detail_note=" + vChulhaDetailNote
					+ "&chulha_no=" + vChulhaNo
					+ "&chulha_rev_no=" + vChulhaRevNo
					+ "&chulha_date=" + vChulhaDate
					+ "&location_type=" + vCompanyType
					+ "&location_type_nm=" + vCompanyTypeNm;
		
		var footer = '<button id="btn_Save" class="btn btn-info" onclick="SaveOderInfo();">수정</button>';
		var title = obj.innerText;
		var heneModal = new HenesysModal(url, 'xlarge', title, footer);
		heneModal.open_modal();
    }
	
 	
 	// 출하정보삭제
    function deleteChulhaInfo(obj) {
    	if(vChulhaNo.length < 1) {
    		heneSwal.warning('삭제할 출하정보를 선택하세요');
			return false;
		}
		
		 var url = "<%=Config.this_SERVER_path%>/Contents/Business/M858/S858S010105.jsp"
				  + "?chulha_count=" + vChulhaCount
				  + "&chulha_no=" + vChulhaNo
				  + "&chulha_rev_no=" + vChulhaRevNo
				  + "&chulha_date=" + vChulhaDate
				  + "&driver=" + vDriver
				  + "&driver_id=" + vDriverId
				  + "&vehicle_cd=" + vVehicleCd
				  + "&vehicle_rev_no=" + vVehicleRevNo
				  + "&location_type=" + vCompanyType
				  + "&location_type_nm=" + vCompanyTypeNm;
				  
		var footer = '<button id="btn_Save" class="btn btn-info" onclick="SaveChulhaInfo();">삭제</button>';
		var title = obj.innerText;
		var heneModal = new HenesysModal(url, 'xlarge', title, footer);
		heneModal.open_modal();
		
    }
    
 	// 문서등록
    function pop_fn_JumunDoc_Insert(obj) {
		if(vOrderNo.length < 1){
			$('#alertNote').html("<%=JSPpage%>! <BR><BR> PO List 하나를 선택하세요.");
			$('#modalalert').show();
			return;
		}
		
		var url = "<%=Config.this_SERVER_path%>/Contents/Business/M101/S101S020121.jsp?OrderNo=" + vOrderNo 
					+ "&OrderDetail=" + vOrderDetailSeq
					+ "&jspPage=" + "<%=JSPpage%>" 
					+ "&num_gubun=<%=GV_GET_NUM_PREFIX%>"
					+ "&LotNo=" + vLotNo;
		var footer = '<button id="btn_Save" class="btn btn-info" style="width:100px"' +
					 		 'onclick="submitForm(); return false;' + 
					 		 'parent.$(\'#modalReport\').hide().fadeIn(100);">등록</button>';
		var title = obj.innerText;
		var heneModal = new HenesysModal(url, 'large', title, footer);
		heneModal.open_modal();
    }
    
    //출하정보등록완료
	function pop_fn_JumunInfo_Comlete(obj) {
		if(vOrderNo.length < 1){
			$('#alertNote').html(obj.innerText + " <BR> <%=JSPpage%>! <BR><BR> 주문정보를 선택하세요.");
			$('#modalalert').show();
			return false;
		}
    	var modalContentUrl = "<%=Config.this_SERVER_path%>/Contents/Business/M101/S101S040122.jsp?OrderNo=" + vOrderNo 
							  + "&jspPage=" + "<%=JSPpage%>"
							  + "&LotNo=" + vLotNo
							  + "&prod_cd=" + vProdCd + "&prod_rev=" + vProdRev;

		pop_fn_popUpScr(modalContentUrl, obj.innerText+"(S101S040122)", '80%', '90%');
		return false;
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
		      	  	<button type="button" id="insertBtn" id="insert" class="btn btn-outline-dark">출하등록</button>
		      	  	<button type="button" id="updateBtn" id="update" class="btn btn-outline-success">출하수정</button>
		      	 	<!-- <button type="button" onclick="updateChulhaInfo(this)" id="update" class="btn btn-outline-success">출하수정</button> -->
		      	  	<button type="button" onclick="deleteChulhaInfo(this)" id="delete" class="btn btn-outline-danger">출하삭제</button>
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
	       		<li class="nav-item" onclick='fn_DetailInfo_List()'>
	       			<a class="nav-link" id="DetailInfo_List" data-toggle="pill" href="#SubInfo_List_contents" role="tab">주문상세정보</a>
	       		</li>
	        </ul>
	     	<div class="tab-content" id="custom-tabs-one-tabContent">
	     		<div class="tab-pane fade" id="SubInfo_List_contents" role="tabpanel"></div>
	     		<div class="tab-pane fade" id="SubInfo_List_Doc" role="tabpanel"></div>
	     		<div class="tab-pane fade" id="SubInfo_Trading" role="tabpanel"></div>
	        </div>
		</div>
	</div>
  </div><!-- /.container-fluid -->
</div>
<!-- /.content -->




<div id="chulhaModal" class="modal fade">
</div>
<!-- /.modal -->
