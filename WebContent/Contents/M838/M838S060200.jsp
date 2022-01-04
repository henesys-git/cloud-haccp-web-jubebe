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
	
	
	String GV_PROCESS_MODIFY	= prcStatusCheck.GV_PROCESS_MODIFY;
	String GV_PROCESS_DELETE	= prcStatusCheck.GV_PROCESS_DELETE;
	String GV_GET_NUM_PREFIX	= prcStatusCheck.GV_PROCESS_NUMBER_GUBUN;

	System.out.println(request.getRemoteAddr());
%>
 <script type="text/javascript">   
    var GV_PROCESS_MODIFY 	="<%=GV_PROCESS_MODIFY%>";
    var GV_PROCESS_DELETE 	="<%=GV_PROCESS_DELETE%>";
    
    $(document).ready(function () {
	    
	    new SetRangeDate("dateParent", "dateRange", 180);
	      
		var startDate = $('#dateRange').data('daterangepicker').startDate.format('YYYY-MM-DD');
	    var endDate = $('#dateRange').data('daterangepicker').endDate.format('YYYY-MM-DD');
	    fn_MainInfo_List(startDate, endDate);
	  	
	  	$('#dateRange').on('apply.daterangepicker', function(ev, picker) {
		var startDate = picker.startDate.format('YYYY-MM-DD');
	    var endDate = picker.endDate.format('YYYY-MM-DD');
	    fn_MainInfo_List(startDate, endDate);
	  	});
	  	
	  	
	  	
		$("#InfoContentTitle").html("협력업체 목록");
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
//         var custcode	= $("#txt_cust_code").val(); 
        var custcode	= "";
        var deleteCheck = $("#delete_check").is(":checked"); 
        
        $.ajax({
            type: "POST",
            url: "<%=Config.this_SERVER_path%>/Contents/Business/M838/S838S060200.jsp",
            data: "custcode=" + custcode + "&From=" + startDate + "&To=" + endDate + "&JSPpage=" + "<%=JSPpage%>" + "&delete_check=" + deleteCheck,
            beforeSend: function () {
			// $("#MainInfo_List_contents").children().remove();
            },
            success: function (html) {
                $("#MainInfo_List_contents").hide().html(html).fadeIn(100);
            },
            error: function (xhr, option, error) {

            }
        });
        
        
         $("#SubInfo_List_contents").children().remove(); 
    }

	// 상세정보
	// 협력업체 인원현황
    function fn_DetailInfo_List() {    	
        $.ajax(
        {
            type: "POST",
            url: "<%=Config.this_SERVER_path%>/Contents/Business/M838/S838S060210.jsp",
            data: "Subcontractor_no=" + vSubcontractor_no + "&Subcontractor_rev=" +  vSubcontractor_rev	,
            beforeSend: function () {
//                 //$("#SubInfo_List_contents").children().remove();
            },
            success: function (html) {
                $("#SubInfo_List_contents").hide().html(html).fadeIn(100);
            },
            error: function (xhr, option, error) {

            }
        });
    }
	// 품목별 생산능력
    function fn_ProductInfo_List() {    	
        $.ajax(
        {
            type: "POST",
            url: "<%=Config.this_SERVER_path%>/Contents/Business/M838/S838S060220.jsp",
            data: "Subcontractor_no=" + vSubcontractor_no + "&Subcontractor_rev=" +  vSubcontractor_rev	,
            beforeSend: function () {
//                 //$("#SubInfo_List_contents").children().remove();
            },
            success: function (html) {
                $("#SubInfo_List_contents").hide().html(html).fadeIn(100);
            },
            error: function (xhr, option, error) {

            }
        });
    }
	// 제품인증 허가관계
    function fn_PermissionInfo_List() {    	
        $.ajax(
        {
            type: "POST",
            url: "<%=Config.this_SERVER_path%>/Contents/Business/M838/S838S060230.jsp",
            data: "Subcontractor_no=" + vSubcontractor_no + "&Subcontractor_rev=" +  vSubcontractor_rev	,
            beforeSend: function () {
//                 //$("#SubInfo_List_contents").children().remove();
            },
            success: function (html) {
                $("#SubInfo_List_contents").hide().html(html).fadeIn(100);
            },
            error: function (xhr, option, error) {

            }
        });
    }
	// 제조설비 현황
    function fn_EquipmentInfo_List() {    	
        $.ajax(
        {
            type: "POST",
            url: "<%=Config.this_SERVER_path%>/Contents/Business/M838/S838S060240.jsp",
            data: "Subcontractor_no=" + vSubcontractor_no + "&Subcontractor_rev=" +  vSubcontractor_rev	,
            beforeSend: function () {
//                 //$("#SubInfo_List_contents").children().remove();
            },
            success: function (html) {
                $("#SubInfo_List_contents").hide().html(html).fadeIn(100);
            },
            error: function (xhr, option, error) {

            }
        });
    }
	
	// 점검표
    function fn_HACCP_View_Canvas(obj) {
		vSubcontractor_no	= $(obj).parent().parent().find("td").eq(0).text().trim();
		vSubcontractor_rev	= $(obj).parent().parent().find("td").eq(1).text().trim();
		vSubcontractor_seq	= $(obj).parent().parent().find("td").eq(2).text().trim();	
        vIo_gb              = $(obj).parent().parent().find("td").eq(7).text().trim();	
    	
    	var modalContentUrl  = "<%=Config.this_SERVER_path%>/Contents/Business/M838/S838S060200_canvas.jsp" 
    		+ "?Subcontractor_no=" + vSubcontractor_no
       		+ "&Subcontractor_rev=" + vSubcontractor_rev
       		+ "&Io_gb=" + vIo_gb 
       		+ "&Subcontractor_seq=" + vSubcontractor_seq
            ;

    	pop_fn_popUpScr(modalContentUrl, "<%=sMenuTitle%>"+"(S838S060200_canvas)", '750px', '1260px');
    	return false;
    	
    }
  
    // 입력
    function pop_fn_Subcontractor_Insert(obj) {	
    	var modalContentUrl = "<%=Config.this_SERVER_path%>/Contents/Business/M838/S838S060201.jsp";
    	
    	var footer = "";
		var title = obj.innerText;
		var heneModal = new HenesysModal(modalContentUrl, 'large', title+"(S838S060201)", footer);
		heneModal.open_modal();
     }
    
    
    // 수정
    function pop_fn_Subcontractor_Update(obj) {    	
		if(vSubcontractor_no.length < 1){
			heneSwal.warning(obj.innerText +" <%=JSPpage%> !! 협력업체를 선택하세요  !!");
 			return false;
		}
    	var modalContentUrl = "<%=Config.this_SERVER_path%>/Contents/Business/M838/S838S060202.jsp"
    		+ "?Subcontractor_no=" + vSubcontractor_no
    		+ "&Subcontractor_rev=" + vSubcontractor_rev	
    		+ "&Subcontractor_seq=" + vSubcontractor_seq
       		+ "&Io_gb=" + vIo_gb 
         	;

    	var footer = "";
		var title = obj.innerText;
		var heneModal = new HenesysModal(modalContentUrl, 'large', title+"(S838S060202)", footer);
		heneModal.open_modal();
    }
    
	// 삭제
    function pop_fn_Subcontractor_Delete(obj) {
		if(vSubcontractor_no.length < 1){
			heneSwal.warning(obj.innerText +" <%=JSPpage%> !! 협력업체를 선택하세요  !!");
 			return false;
		}
		
    	var modalContentUrl;
    	
    	var modalContentUrl = "<%=Config.this_SERVER_path%>/Contents/Business/M838/S838S060203.jsp"
    		+ "?Subcontractor_no=" + vSubcontractor_no
			+ "&Subcontractor_rev=" + vSubcontractor_rev	
			+ "&Subcontractor_seq=" + vSubcontractor_seq
       		+ "&Io_gb=" + vIo_gb 
	     	;


    	var footer = "";
		var title = obj.innerText;
		var heneModal = new HenesysModal(modalContentUrl, 'large', title+"(S838S060203)", footer);
		heneModal.open_modal();
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
      	<button type ="button" onclick = "pop_fn_Subcontractor_Insert(this)" id="insert" class= "btn btn-outline-dark">협력업체 등록</button>
      	<button type ="button" onclick = "pop_fn_Subcontractor_Update(this)" id="update" class= "btn btn-outline-success">협력업체 수정</button>
      	<button type ="button" onclick = "pop_fn_Subcontractor_Delete(this)" id="delete" class= "btn btn-outline-danger">협력업체 삭제</button>
      	<label style="width: auto; clear:both; margin-left:30px;">
	        삭제된정보 보기
	    <input type="checkbox" id="delete_check"  />
	    </label>	 
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
    			<i class="fas fa-edit">세부 정보</i>
    		</h3>
    	</div>
    	<div class="card-body">
    		<ul class="nav nav-tabs" id="custom-tabs-one-tab" role="tablist">
	       		<li class="nav-item" onclick='fn_DetailInfo_List()'>
	       			<a class="nav-link" id="DetailInfo_List" data-toggle="pill" href="#SubInfo_List_contents" role="tab">협력업체 인원현황</a>
	       		</li>
	       		<li class="nav-item" onclick='fn_ProductInfo_List()'>
	       			<a class="nav-link" id="ProductInfo_List" data-toggle="pill" href="#SubInfo_List_contents" role="tab">품목별 생산능력</a>
	       		</li>
	       		<li class="nav-item" onclick='fn_PermissionInfo_List()'>
	       			<a class="nav-link" id="PermissionInfo_List" data-toggle="pill" href="#SubInfo_List_contents" role="tab">제품인증 허가관계</a>
	       		</li>
	       		<li class="nav-item" onclick='fn_EquipmentInfo_List()'>
	       			<a class="nav-link" id="EquipmentInfo_List" data-toggle="pill" href="#SubInfo_List_contents" role="tab">제조설비 현황</a>
	       		</li>
	       		
	        </ul>
	     	<div class="tab-content" id="custom-tabs-one-tabContent">
	     		<div class="tab-pane fade" id="SubInfo_List_contents" role="tabpanel"></div>
	     	</div>
	        
        </div>
    </div>
  </div> <!-- /.container-fluid -->
</div> <!-- /.content -->
	
    <%-- <div class="panel panel-default" style="margin-left:5px; margin-top:5px; margin-right:5px; margin-bottom:5px; width:100%">
        <!-- Default panel contents -->
        <div class="panel-heading" style="font-weight: bold" id="MenuTitle">여기에메뉴타이틀</div>
        <div class="panel-body"  style="width: 100%;">
            <div>
	            <button data-author="mainBtn" type="button"  id="mainButton"  class="btn btn-primary active"
	            			style="width: auto; float: left; "> 보관운반관리기준서 - 협력업체현황서 </button>
	            <button data-author="insert" type="button" onclick="pop_fn_Subcontractor_Insert(this)" id="insert" class="btn btn-default" 
	            			style="width: auto;float: left; margin-left:30px;">협력업체 등록</button>           			 				            			
	            <button data-author="update" type="button" onclick="pop_fn_Subcontractor_Update(this)" id="update" class="btn btn-outline-success" 
	            			style="width: auto; float: left; margin-left:3px;">협력업체 수정</button>
	            <button data-author="delete" type="button" onclick="pop_fn_Subcontractor_Delete(this)" id="delete" class="btn btn-danger" 
	            			style="width: auto; float: left;  margin-left:3px;">협력업체 삭제</button>
	            <label style="width: auto; clear:both; margin-left:30px;">
	            	삭제된정보 보기
	            	<input type="checkbox" id="delete_check"  />
	            </label>	            			

            </div>
            <p style="width: auto; clear:both;">
            </p>
            <div class="panel panel-default"  style="width: 100%;">
                <!-- Default panel contents -->
                <div class="panel-body" style="width: 100%;">
                    <div style="clear:both; width: 100%;">
                    <jsp:include page="../Common/search_table.jsp" flush="false"/>
<!--                         <table style="width: 100%; text-align:left; background-color:#e0e0e0;"> -->
<!--                             <tr><td style='width:20%; vertical-align: middle;'> -->
<!--                             		<div class="panel-heading" style="font-size:16px; font-weight: bold"  id="InfoContentTitle"></div> -->
<!--                             	</td> -->
<!--                             	<td style='width:5%; vertical-align: middle'>수행일자 :</td> -->
<!--                                 <td style='width:6%;  vertical-align: middle'> -->
<!--                                     <input type="text" data-date-format="yyyy-mm-dd" id="dateFrom" class="form-control" /> -->
<!--                                 </td> -->
<!--                                 <td style='width:1%;vertical-align: middle'> -->
<!--                                     &nbsp;~&nbsp; -->
<!--                                 </td> -->
<!--                                 <td style='width:6%; vertical-align: middle'> -->
<!--                                     <input type="text" data-date-format="yyyy-mm-dd" id="dateTo" class="form-control" /> -->
<!--                                 </td> -->
<!--                                 <td style="width:62%; text-align:left"> -->
<!--                                     <button type="button" onclick="fn_MainInfo_List()" id="btn_Search" class="btn  btn-outline-success" style='width:100px; margin-left: 20px;'>조 회</button> -->
<!--                                 </td> -->
<!--                             </tr> -->
<!--                         </table> -->
                        
                    </div>
                   
 					<div  style="clear:both; height:10px ;border-top: 1px solid #D2D6Df;" ></div>
                    <div style="clear:both" id="MainInfo_List_contents" ></div>
 
                </div>
                                
                <div id="tabs">
		         	<ul >
		                <li onclick='fn_DetailInfo_List()'><a id="DetailInfo_List"  href=#SubInfo_List_contents>협력업체 인원현황</a></li>
		                <li onclick='fn_ProductInfo_List(this,vSubcontractor_no,vSubcontractor_rev,vSubcontractor_seq)'><a id="SubInfo_DOC_List"  href='#SubInfo_List_Doc'>품목별 생산능력</a></li>
		                <li onclick='fn_PermissionInfo_List(this,vSubcontractor_no,vSubcontractor_rev,vSubcontractor_seq)'><a id="SubInfo_DOC_List"  href='#SubInfo_List_Doc'>제품인증 허가관계</a></li>
		                <li onclick='fn_EquipmentInfo_List(this,vSubcontractor_no,vSubcontractor_rev,vSubcontractor_seq)'><a id="SubInfo_DOC_List"  href='#SubInfo_List_Doc'>제조설비 현황</a></li>
		            </ul>
                    <div id="SubInfo_List_Doc" ></div>
                    <div id="SubInfo_List_contents"></div>
                </div>

            </div>
        </div>
    </div> --%>
