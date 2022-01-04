<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="mes.client.comm.*" %>
<%@ page import="mes.client.guiComponents.*" %>
<%@ page import="mes.client.util.*" %>
<%@ page import="mes.client.conf.*" %>
<%
	String loginID = session.getAttribute("login_id").toString();
	if(loginID == null || loginID.equals("")) {                            		   // id가 Null 이거나 없을 경우
		response.sendRedirect(Config.this_SERVER_path + "/Contents/index.jsp");    // 로그인 페이지로 리다이렉트 한다.
	}

	String sMenuTitle = request.getParameter("MenuTitle").toString();
	String sProgramId = request.getParameter("programId").toString();
	String sHeadmenuID = request.getParameter("HeadmenuID").toString();
	String sHeadmenuName = request.getParameter("HeadmenuName").toString();

	Get_Program_button_Autho prg_autho = new Get_Program_button_Autho(loginID,sProgramId);
	
	CurrentPage jspPageName = new CurrentPage(request.getRequestURI());
	String JSPpage = jspPageName.GetJSP_FileName();
	ProcesStatusCheck prcStatusCheck = new ProcesStatusCheck(JSPpage+"|"+"ODPROCS"+"|");

	String GV_PROCESS_MODIFY = prcStatusCheck.GV_PROCESS_MODIFY;
	String GV_PROCESS_DELETE = prcStatusCheck.GV_PROCESS_DELETE;
	String GV_GET_NUM_PREFIX = prcStatusCheck.GV_PROCESS_NUMBER_GUBUN;
%>

<script type="text/javascript">   
    
    $(document).ready(function () {
    	
    	var date = new SetRangeDate("dateParent", "dateRange", 180);
        
    	var startDate = $('#dateRange').data('daterangepicker').startDate.format('YYYY-MM-DD');
       	var endDate = $('#dateRange').data('daterangepicker').endDate.format('YYYY-MM-DD');
        fn_MainInfo_List(startDate, endDate);
    	
		$("#InfoContentTitle").html("주문 목록(PO List)");
        
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
            });
   		}
		if(vDelete == "0") {
	    	$('button[id="delete"]').each(function () {
                $(this).prop("disabled",true);
            });
   		}
    }

    function fn_clearList() {
        if ($("#MainInfo_List_contents").children().length > 0) {
            $("#MainInfo_List_contents").children().remove();
        }
        if ($("#SubInfo_bom").children().length > 0) {
            $("#SubInfo_bom").children().remove();
        }        
        if ($("#SubInfo_List_Doc").children().length > 0) {
            $("#SubInfo_List_Doc").children().remove();
        }
        if ($("#SubInfo_sibang").children().length > 0) {
            $("#SubInfo_sibang").children().remove();
        }
        if ($("#SubInfo_processcheck").children().length > 0) {
            $("#SubInfo_processcheck").children().remove();
        }        
    }
    
    //주문기본정보
    function fn_MainInfo_List(startDate, endDate) {
        var custcode = "";
        
        $.ajax({
            type: "POST",
            url: "<%=Config.this_SERVER_path%>/Contents/Business/M101/S101S020100.jsp",
            data: "custcode=" + custcode + "&From=" + startDate + "&To=" + endDate + 
            	  "&MemberKey" + memberKey +  "&JSPpage=" + "<%=JSPpage%>",
            success: function (html) {
                $("#MainInfo_List_contents").hide().html(html).fadeIn(100);
            }
        });
        
        $("#SubInfo_List_Doc").children().remove();
        $("#SubInfo_List_contents").children().remove();
    }

    //주문상세정보 
    function fn_DetailInfo_List() {
        $.ajax({
            type: "POST",
            url: "<%=Config.this_SERVER_path%>/Contents/Business/M101/S101S020110.jsp",
            data: "OrderNo=" + vOrderNo + "&ProdCd=" + vProdCd + "&ProdRev=" + vProdRev,
            success: function (html) {
                $("#SubInfo_List_contents").hide().html(html).fadeIn(100);
            }
        });
    }
  
    // 주문 등록
    function pop_fn_JumunInfo_Insert(obj) {
		var url = "<%=Config.this_SERVER_path%>/Contents/Business/M101/S101S020101.jsp";
		var footer = '<button id="btn_Save" class="btn btn-info"' +
					 		 'onclick="SaveOderInfo();">저장</button>';
		var title = obj.innerText;
		var heneModal = new HenesysModal(url, 'large', title, footer);
		heneModal.open_modal();
	}

    // 주문정보 수정
    function pop_fn_JumunInfo_Update(obj) {
		if(vOrderNo.length < 1) {
			heneSwal.warning('주문 정보를 선택하세요')
			return false;
		}
		
		var url = "<%=Config.this_SERVER_path%>/Contents/Business/M101/S101S020102.jsp"
				+ "?OrderNo=" + vOrderNo 
				+ "&OrderRevNo=" + vOrderRevNo
				+ "&ProdCd=" + vProdCd
				+ "&ProdRev=" + vProdRev
				+ "&DeliveryDate=" + vDeliveryDate
		var footer = '<button id="btn_Save" class="btn btn-info" onclick="SaveOderInfo();">저장</button>';
		var title = obj.innerText;
		var heneModal = new HenesysModal(url, 'large', title, footer);
		heneModal.open_modal();
	}

    // 납품 완료 처리
    function pop_fn_JumunInfo_Comlete(obj) {
    	
		if(vOrderNo.length < 1) {
			heneSwal.warning('주문 정보를 선택하세요')
			return false;
		}
    	var modalContentUrl;
    	modalContentUrl = "<%=Config.this_SERVER_path%>/Contents/Business/M101/S101S020122.jsp?OrderNo=" + vOrderNo 
			+ "&jspPage=" + "<%=JSPpage%>"
			+ "&innerText=" + obj.innerText
 			+ "&Product_Gubun=" + vProduct_Gubun
 			+ "&Part_Source=" + vPart_Source
 			+ "&Rohs=" + vRohs
			;

		pop_fn_popUpScr(modalContentUrl, obj.innerText+"(S101S020122)", '750px', '1800px');
		return false;
    }
    
    function pop_fn_JumunInfo_Delete(obj) {

		if(vOrderNo.length < 1) {
			heneSwal.warning('주문 정보를 선택하세요')
			return;
		}
		
    	var modalContentUrl = "<%=Config.this_SERVER_path%>/Contents/Business/M101/S101S020103.jsp?OrderNo=" + vOrderNo 
						+ "&jspPage=" + "<%=JSPpage%>"
	         			+ "&Product_Gubun=" + vProduct_Gubun
	         			+ "&Part_Source=" + vPart_Source
	         			+ "&Rohs=" + vRohs
						;

			pop_fn_popUpScr(modalContentUrl, obj.innerText+"(S101S020103)", '750px', '1800px');
		return false;
    }
	
    // 주문 관련 문서 등록
    function pop_fn_JumunDoc_Insert(obj) {
		if(vOrderNo.length < 1) {
			heneSwal.warning('PO List 하나를 선택하세요')
			return;
		}
    	var modalContentUrl;
    	modalContentUrl = "<%=Config.this_SERVER_path%>/Contents/Business/M101/S101S020131.jsp?OrderNo=" + vOrderNo 
    			+ "&jspPage=" + "<%=JSPpage%>" 
    			+ "&num_gubun=<%=GV_GET_NUM_PREFIX%>"
    			+ "&prod_cd=" + vProdCd
    			+ "&prod_rev=" + vProdRev
    			+ "&prod_nm=" + vProdNm
    			;

    	pop_fn_popUpScr(modalContentUrl, obj.innerText+"(S101S020131)", '80%', '70%');
		return false;
     }

    function pop_fn_JumunBOM_Insert(obj) {
		if(vOrderNo.length < 1) {
			heneSwal.warning('주문 정보를 선택하세요')
			return false;
		}
    	var modalContentUrl;
    	modalContentUrl = "<%=Config.this_SERVER_path%>/Contents/Business/M101/S101S020131.jsp?OrderNo=" + vOrderNo 
    			+ "&jspPage=" + "<%=JSPpage%>"
    			+ "&num_gubun=<%=GV_GET_NUM_PREFIX%>";
    	pop_fn_popUpScr(modalContentUrl, obj.innerText+"(S101S020131)", '900px', '860px');
		return false;
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
         	<button type="button" onclick="pop_fn_JumunDoc_Insert(this)" id="insert" class="btn btn-outline-dark">주문문서 등록</button>
         	<button type="button" onclick="pop_fn_JumunInfo_Delete(this)" id="delete" class="btn btn-outline-danger">주문서 삭제</button>
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
    			<i class="fas fa-edit">세부 정보</i>
    		</h3>
    	</div>
    	<div class="card-body">
    		<ul class="nav nav-tabs" id="custom-tabs-one-tab" role="tablist">
          		<li class="nav-item" onclick='fn_DetailInfo_List()'>
          			<a class="nav-link" id="DetailInfo_List" data-toggle="pill" href="#SubInfo_List_contents" role="tab">주문상세정보</a>
          		</li>
              	<li class="nav-item" onclick='com_fn_SubInfo_DOC_List(this,vOrderNo)'>
              		<a class="nav-link" id="SubInfo_DOC_List" data-toggle="pill" href='#SubInfo_List_Doc' role="tab">주문문서목록</a>
              	</li>
        	</ul>
        	<div class="tab-content" id="custom-tabs-one-tabContent">
        		<div class="tab-pane fade" id="SubInfo_List_contents" role="tabpanel"></div>
        		<div class="tab-pane fade" id="SubInfo_List_Doc" role="tabpanel"></div>
            </div>
    	</div>
    </div>
  </div><!-- /.container-fluid -->
</div>
<!-- /.content -->