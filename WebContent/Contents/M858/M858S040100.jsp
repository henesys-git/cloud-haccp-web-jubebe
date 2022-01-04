<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="mes.client.comm.*" %>
<%@ page import="mes.client.guiComponents.*" %>
<%@ page import="mes.client.util.*" %>
<%@ page import="mes.client.conf.*" %>
<!-- 
출하관리(M101S040100.jsp)
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
%>

<script>
	var discard_type = "";
	var discard_seq_no = "";
	var amount = "";
	var discard_date = "";
	var note = "";
	var chulha_no = "";
	var chulha_rev_no = "";
	var prod_date = "";
	var seq_no = ""; // 재고 일련 번호
	var prod_cd = "";
	var prod_rev_no = "";
	var cust_nm = "";
 	
	var startDate;
	var endDate;
	
    $(document).ready(function () {
		
    	var date = new SetRangeDate("dateParent", "dateRange", 30);
		startDate = date.start.format('YYYY-MM-DD');
		endDate = date.end.format('YYYY-MM-DD');
		
		fn_MainInfo_List(startDate, endDate);
		
		$("#InfoContentTitle").html("반품 목록");
 		fn_MainSubMenuSelect("<%=sMenuTitle%>");
		
		$('#dateRange').change(function() {
           	fn_MainInfo_List(startDate, endDate);
        });
		
	    // 반품정보등록
	    $('#insertDiscardBtn').click(function() {
	    	var url = "<%=Config.this_SERVER_path%>/Contents/Business/M858/S858S040101.jsp";
			var footer = '<button id="insertBtn" class="btn btn-info">저장</button>';
			var title = "반품/폐기 등록";
			var heneModal = new HenesysModal(url, 'xlarge', title, footer);
			heneModal.open_modal();
	    });
	    
	 	// 반품정보수정
	    $('#updateDiscardBtn').click(function() {
		 	if(discard_type.length < 1) {
	    		heneSwal.warning('수정할 반품정보를 선택하세요');
				return false;
			}
	    	
			var url = "<%=Config.this_SERVER_path%>/Contents/Business/M858/S858S040102.jsp"
						+ "?discard_type=" + discard_type
						+ "&discard_seq_no=" + discard_seq_no;
			var footer = '<button id="updateBtn" class="btn btn-info">수정</button>';
			var title = "반품/폐기 수정";
			var heneModal = new HenesysModal(url, 'standard', title, footer);
			heneModal.open_modal();
	    }); 
	 	
	 	// 반품정보삭제
	    $('#deleteDiscardBtn').click(function() {
	    	if(discard_type.length < 1) {
	    		heneSwal.warning('삭제할 반품정보를 선택하세요');
				return false;
			}
			
			var url = "<%=Config.this_SERVER_path%>/Contents/Business/M858/S858S040103.jsp"
						+ "?discard_type=" + discard_type
						+ "&discard_seq_no=" + discard_seq_no;
			var footer = '<button id="deleteBtn" class="btn btn-info">삭제</button>';
			var title = "반품/폐기 삭제";
			var heneModal = new HenesysModal(url, 'standard', title, footer);
			heneModal.open_modal();
	    });
    });
    
    function fn_MainInfo_List(startDate, endDate) {
        $.ajax({
            type: "POST",
            url: "<%=Config.this_SERVER_path%>/Contents/Business/M858/S858S040100.jsp",
            data: "startDate=" + startDate + 
            	  "&endDate=" + endDate,
            success: function (html) {
                $("#MainInfo_List_contents").hide().html(html).fadeIn(100);
            }
        });
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
		      	  	<button type="button" id="insertDiscardBtn" class="btn btn-outline-dark">반품등록</button>
		      	 	<button type="button" id="updateDiscardBtn" class="btn btn-outline-success">반품수정</button>
		      	  	<button type="button" id="deleteDiscardBtn" class="btn btn-outline-danger">반품삭제</button>
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
  </div><!-- /.container-fluid -->
</div>
<!-- /.content -->
