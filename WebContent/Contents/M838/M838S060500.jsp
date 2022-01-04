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
	String GV_GET_NUM_PREFIX = prcStatusCheck.GV_PROCESS_NUMBER_GUBUN;
%>

 <script type="text/javascript">
 
 	var GV_PROCESS_MODIFY = "<%=GV_PROCESS_MODIFY%>";
	var GV_PROCESS_DELETE = "<%=GV_PROCESS_DELETE%>";
 
	var vVhclNo			= "";
	var vVhclNoRev		= "";
	var vVhclNm			= "";
	var vServiceDate	= "";
	var vCheckDate		= "";
	
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
	  	
		$("#InfoContentTitle").html("배송차량 청소관리 일지");
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


    function fn_clearList() {
        if ($("#MainInfo_List_contents").children().length > 0) {
            $("#MainInfo_List_contents").children().remove();
        }
        if ($("#SubInfo_List_contents").children().length > 0) {
            //$("#SubInfo_List_contents").children().remove();
        }
    }
        
    //주문기본정보
    function fn_MainInfo_List(startDate, endDate) {
		var custcode = "";
        
        $.ajax({
            type: "POST",
            url: "<%=Config.this_SERVER_path%>/Contents/Business/M838/S838S060500.jsp",
            data: "custcode=" + custcode + "&From=" + startDate + "&To=" + endDate + "&JSPpage=" + "<%=JSPpage%>",
            beforeSend: function () {
			//$("#MainInfo_List_contents").children().remove();
            },
            success: function (html) {
                $("#MainInfo_List_contents").hide().html(html).fadeIn(100);
            },
            error: function (xhr, option, error) {

            }
        });
        
        
         $("#SubInfo_List_contents").children().remove(); 
        
        
    }

    function fn_DetailInfo_List() {    	
		$.ajax(
		{
			type: "POST",
			url: "<%=Config.this_SERVER_path%>/Contents/Business/M838/S838S060520.jsp",
			data: "vhcl_no=" + vVhclNo + "&vhcl_no_rev=" + vVhclNoRev
					+ "&service_date=" + vServiceDate ,
			beforeSend: function () {
// 				$("#SubInfo_List_contents").children().remove();
			},
			success: function (html) {
				$("#SubInfo_List_contents").hide().html(html).fadeIn(100);
			},
			error: function (xhr, option, error) {
	
			}
		});
	}

    // 점검표 canvas
    function fn_HACCP_View_Canvas(obj) {
    	vVhclNo			= $(obj).parent().parent().find("td").eq(0).text().trim();
    	vVhclNoRev		= $(obj).parent().parent().find("td").eq(1).text().trim();
    	vServiceDate	= $(obj).parent().parent().find("td").eq(3).text().trim();
    	vCheckPerson	= $(obj).parent().parent().find("td").eq(5).text().trim();
    	vCheckDate		= $(obj).parent().parent().find("td").eq(15).text().trim();
    	
    	var modalContentUrl = "<%=Config.this_SERVER_path%>/Contents/Business/M838/S838S060500_canvas.jsp" 
    						//+ "?page_start=" + 1  // 1페이지부터	
    						+ "?vhcl_no=" + vVhclNo + "&vhcl_no_rev=" + vVhclNoRev
							+ "&service_date=" + vServiceDate
							+ "&check_person=" + vCheckPerson;
    	 					<%-- + "&check_gubun=" + "<%=GV_GET_NUM_PREFIX%>" --%>
    	pop_fn_popUpScr(modalContentUrl, "<%=sMenuTitle%>"+"(S838S060500_canvas)", '800px', '1260px');
		
    	return false;
		
<%-- 		fn_HACCP_View("<%=sMenuTitle%>","<%=sProgramId%>"); --%>
    }
    
    function fn_Transport_List() {    	
		$.ajax(
		{
			type: "POST",
			url: "<%=Config.this_SERVER_path%>/Contents/Business/M838/S838S060530.jsp",
			data: "vhcl_no=" + vVhclNo + "&vhcl_no_rev=" + vVhclNoRev
					+ "&service_date=" + vServiceDate ,
			beforeSend: function () {
// 				$("#Transport_List_contents").children().remove();
			},
			success: function (html) {
				$("#SubInfo_List_contents").hide().html(html).fadeIn(100);
			},
			error: function (xhr, option, error) {
	
			}
		});
	}
    
 	// 청소점검 등록
    function pop_fn_Vehicle_Clean_Check_Insert(obj) {
//     	if(vVhclNo.length < 1){
<%-- 			$('#alertNote').html(obj.innerText + " <BR> <%=JSPpage%>!!! <BR><BR> 등록할 차량운행 정보를 클릭하세요  !!!"); --%>
// 			$('#modalalert').show();
// 			return false;
// 		}
 		
		var modalContentUrl = "<%=Config.this_SERVER_path%>/Contents/Business/M838/S838S060501.jsp"
    						+ "?check_gubun=" + "<%=GV_GET_NUM_PREFIX%>" 
//     						+ "&vhcl_no=" + vVhclNo
//     						+ "&vhcl_no_rev=" + vVhclNoRev
//     						+ "&vhcl_nm=" + vVhclNm
//     						+ "&service_date=" + vServiceDate
    						;
    			
		var footer = "";
		var title = obj.innerText;
		var heneModal = new HenesysModal(modalContentUrl, 'large', title+"(S838S060501)", footer);
		heneModal.open_modal();
    }    
    
    // 청소점검 수정
    function pop_fn_Vehicle_Clean_Check_Update(obj) {    	
		if(vVhclNo.length < 1){
			heneSwal.warning(obj.innerText +" <%=JSPpage%> !! 수정할 청소점검 정보를 선택하세요  !!");
 			return false;
		}
    	var modalContentUrl = "<%=Config.this_SERVER_path%>/Contents/Business/M838/S838S060502.jsp"
    							+ "?vhcl_no=" + vVhclNo
    							+ "&vhcl_no_rev=" + vVhclNoRev
								+ "&vhcl_nm=" + vVhclNm
								+ "&service_date=" + vServiceDate ;

    	var footer = "";
		var title = obj.innerText;
		var heneModal = new HenesysModal(modalContentUrl, 'large', title+"(S838S060502)", footer);
		heneModal.open_modal();
	}
    
 	// 청소점검 삭제
    function pop_fn_Vehicle_Clean_Check_Delete(obj) {    	
		if(vVhclNo.length < 1){
			heneSwal.warning(obj.innerText +" <%=JSPpage%> !! 삭제할 청소점검 정보를 선택하세요  !!");
 			return false;
			
		}
    	var modalContentUrl = "<%=Config.this_SERVER_path%>/Contents/Business/M838/S838S060503.jsp" 
				    		+ "?vhcl_no=" + vVhclNo
				    		+ "&vhcl_no_rev=" + vVhclNoRev
							+ "&vhcl_nm=" + vVhclNm
							+ "&service_date=" + vServiceDate ;

    	var footer = "";
		var title = obj.innerText;
		var heneModal = new HenesysModal(modalContentUrl, 'large', title+"(S838S060502)", footer);
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
      	<button type ="button" onclick = "pop_fn_Vehicle_Clean_Check_Insert(this)" id="insert" class= "btn btn-outline-dark">청소점검 등록</button>
      	<button type ="button" onclick = "pop_fn_Vehicle_Clean_Check_Update(this)" id="update" class= "btn btn-outline-success">청소점검 수정</button>
      	<button type ="button" onclick = "pop_fn_Vehicle_Clean_Check_Delete(this)" id="delete" class= "btn btn-outline-danger">청소점검 삭제</button>
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
	       			<a class="nav-link" id="DetailInfo_List" data-toggle="pill" href="#SubInfo_List_contents" role="tab">점검상세정보</a>
	       		</li>
	       		<li class="nav-item" onclick='fn_Transport_List()'>
	       			<a class="nav-link" id="Transport_List" data-toggle="pill" href="#SubInfo_List_contents" role="tab">운송실적</a>
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