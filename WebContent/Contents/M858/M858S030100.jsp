<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="mes.client.comm.*" %>
<%@ page import="mes.client.common.*" %>
<%@ page import="mes.client.guiComponents.*" %>
<%@ page import="mes.client.util.*" %>
<%@ page import="mes.client.conf.*" %>
<%
	String loginID = session.getAttribute("login_id").toString();
	if(loginID==null||loginID.equals("")){                            // id가 Null 이거나 없을 경우
		response.sendRedirect("Contents/index.jsp");    // 로그인 페이지로 리다이렉트 한다.
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
	ProcesStatusCheck prcStatusCheck = new ProcesStatusCheck(JSPpage+"|"+"ODPROCS"+"|");

	String GV_PROCESS_MODIFY	= prcStatusCheck.GV_PROCESS_MODIFY;
	String GV_PROCESS_DELETE	= prcStatusCheck.GV_PROCESS_DELETE;
	String GV_PROCESS_NAME		= prcStatusCheck.GV_PROCESS_NAME;
	String GV_GET_NUM_PREFIX	= prcStatusCheck.GV_PROCESS_NUMBER_GUBUN;
%>  

<script type="text/javascript">
	
	var vBaechaNo = "";
	var vBaechaSeq = "";
	var vBaechaStartDt = "";
	var vBaechaEndDt = "";
	var vVehicleCd = "";
	var vVehicleCdRev = "";
	var vVehicleNm = "";
	var vDriver = "";
	var vBigo = "";
	
	var vTransportNo = "";
	
	var vOrderNo = "";
	var vOrderDetailSeq = "";
	var vLotno = "";

    $(document).ready(function () {
    	<%-- new SetDate("dateFrom", -180);
    	new SetDate("dateTo", 0);
    	
        fn_MainSubMenuSelect("<%=sMenuTitle%>");
        
		$("#InfoContentTitle").html("배차목록");        

		fn_MainInfo_List();
	    
	    //탭 클릭시 처리하는 Function
	    //$( function() {$( "#tabs" ).tabs();});

        fn_tagProcess('<%=JSPpage%>');
         --%>
         
        new SetRangeDate("dateParent", "dateRange", 180);
	      
 		var startDate = $('#dateRange').data('daterangepicker').startDate.format('YYYY-MM-DD');
 	    var endDate = $('#dateRange').data('daterangepicker').endDate.format('YYYY-MM-DD');
 	    fn_MainInfo_List(startDate, endDate);
 	  	
 	  	$('#dateRange').on('apply.daterangepicker', function(ev, picker) {
 			var startDate = picker.startDate.format('YYYY-MM-DD');
 	    	var endDate = picker.endDate.format('YYYY-MM-DD');
 	    	fn_MainInfo_List(startDate, endDate);
 	  	});
 	  	
 		$("#InfoContentTitle").html("배차목록");
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
    
  	//배차정보
    function fn_MainInfo_List(startDate, endDate) {
       <%--  var custcode = "";
        var from = $("#dateFrom").val();
        var to = $("#dateTo").val();
        $.ajax(
        {
            type: "POST",
            url: "<%=Config.this_SERVER_path%>/Contents/Business/M101/S101S020100.jsp",
            url: "<%=Config.this_SERVER_path%>/Contents/Business/M858/S858S030100.jsp",
            data: "custcode=" + custcode + "&From=" + from + "&To=" + to  + "&JSPpage=" + "<%=JSPpage%>",
            beforeSend: function () {
                $("#MainInfo_List_contents").children().remove();
            },
            success: function (html) {
                $("#MainInfo_List_contents").hide().html(html).fadeIn(100);
            },
            error: function (xhr, option, error) {

            }
        });
		$("#SubInfo_List_contents").children().remove(); --%>
		
		var custcode = "";
        
        $.ajax({
            type: "POST",
            url: "<%=Config.this_SERVER_path%>/Contents/Business/M858/S858S030100.jsp",
            data: "custcode=" + custcode + "&From=" + startDate + "&To=" + endDate + "&JSPpage=" + "<%=JSPpage%>",
            beforeSend: function () {
//          	$("#MainInfo_List_contents").children().remove();
            },
            success: function (html) {
                $("#MainInfo_List_contents").hide().html(html).fadeIn(100);
            },
            error: function (xhr, option, error) {

            }
        });
    }
        
  	// 주문정보
	function fn_DetailInfo_List() {     
		$.ajax(
        	    {
        	        type: "POST",
        	        url: "<%=Config.this_SERVER_path%>/Contents/Business/M858/S858S030140.jsp",
        	        data: "baecha_no=" + vBaechaNo,
        	        beforeSend: function () {
//         	            //$("#SubInfo_List_contents").children().remove();
        	        },
        	        success: function (html) {
        	            $("#SubInfo_List_contents").hide().html(html).fadeIn(100);
        	        },
        	        error: function (xhr, option, error) {
        	        }
        	    });
    		return;
	}
	
	// 운송정보
    function fn_BaechaInfo_List() {
    	$.ajax(
	    	    {
	    	        type: "POST",
	    	        url: "<%=Config.this_SERVER_path%>/Contents/Business/M858/S858S030110.jsp",
	    	        data: "baecha_no=" + vBaechaNo,
	    	        beforeSend: function () {
//	     	            $("#ProcessInfo_bom").children().remove();
	    	        },
	    	        success: function (html) {
	    	            $("#SubInfo_List_contents").hide().html(html).fadeIn(100);
	    	        },
	    	        error: function (xhr, option, error) {
	    	        }
	    	    });
			return;
	}   
	
	//배차등록
    function pop_fn_BaechaInfo_Insert(obj) {
//     	if(vOrderNo.length < 1){
<%--     		$('#alertNote').html(obj.innerText + " <BR> <%=JSPpage%>!!! <BR><BR> 주문정보를 선택하세요  !!!"); --%>
//    	 		$('#modalalert').show();
//    	 		return false;
//    	 	}
    	
    	var modalContentUrl = "<%=Config.this_SERVER_path%>/Contents/Business/M858/S858S020101.jsp"
    						+ "?jspPage=" + "<%=JSPpage%>"
    						+ "&num_gubun=" + "BCH"
<%--     						+ "&num_gubun=" + "<%=GV_GET_NUM_PREFIX%>" --%>
    						;
    					
    	pop_fn_popUpScr(modalContentUrl, obj.innerText+"(S858S020101)", '80%', '90%');
     }

	//배차수정
    function pop_fn_BaechaInfo_Update(obj) {
    	if(vBaechaNo.length < 1){
			$('#alertNote').html(obj.innerText + " <BR> <%=JSPpage%>!!! <BR><BR> 배차정보를 선택하세요  !!!");
			$('#modalalert').show();
			return false;
		}
		
		var modalContentUrl;
    	
    	modalContentUrl = "<%=Config.this_SERVER_path%>/Contents/Business/M858/S858S020102.jsp"
    					+ "?baecha_no=" + vBaechaNo
    					+ "&baecha_seq=" + vBaechaSeq
    					+ "&baecha_start_dt=" + vBaechaStartDt
    					+ "&baecha_end_dt=" + vBaechaEndDt
    					+ "&vehicle_cd=" + vVehicleCd
    					+ "&vehicle_cd_rev=" + vVehicleCdRev
    					+ "&vehicle_nm=" + vVehicleNm
    					+ "&driver=" + vDriver
    					+ "&bigo=" + vBigo
    					;
    	
		pop_fn_popUpScr(modalContentUrl, obj.innerText+"(S858S020102)", '80%', '90%');
    }

	//배차삭제
    function pop_fn_BaechaInfo_Delete(obj) {
    	if(vBaechaNo.length < 1){
			$('#alertNote').html(obj.innerText + " <BR> <%=JSPpage%>!!! <BR><BR> 배차정보를 선택하세요  !!!");
			$('#modalalert').show();
			return false;
		}
		
		var modalContentUrl;
    	
    	modalContentUrl = "<%=Config.this_SERVER_path%>/Contents/Business/M858/S858S020103.jsp"
			    		+ "?baecha_no=" + vBaechaNo
						+ "&baecha_seq=" + vBaechaSeq
						+ "&baecha_start_dt=" + vBaechaStartDt
						+ "&baecha_end_dt=" + vBaechaEndDt
						+ "&vehicle_cd=" + vVehicleCd
						+ "&vehicle_cd_rev=" + vVehicleCdRev
						+ "&vehicle_nm=" + vVehicleNm
						+ "&driver=" + vDriver
						+ "&bigo=" + vBigo
						;
    	
		pop_fn_popUpScr(modalContentUrl, obj.innerText+"(S858S020103)", '80%', '90%');
    }

    //운송등록
    function pop_fn_TransportInfo_Insert(obj) {
		if(vOrderNo.length < 1){
			$('#alertNote').html(obj.innerText + " <BR> <%=JSPpage%>!!! <BR><BR> 배차주문목록에서 정보를 선택하세요  !!!");
			$('#modalalert').show();
			return false;
		}
		var modalContentUrl = "<%=Config.this_SERVER_path%>/Contents/Business/M858/S858S030101.jsp"
							+ "?jspPage=" + "<%=JSPpage%>"
							+ "&num_gubun=" + "<%=GV_GET_NUM_PREFIX%>"
							+ "&order_no=" + vOrderNo
							+ "&lotno=" + vLotno
							+ "&order_detail_seq=" + vOrderDetailSeq
							+ "&baecha_no=" + vBaechaNo
							+ "&baecha_seq=" + vBaechaSeq
							+ "&baecha_start_dt=" + vBaechaStartDt
							+ "&baecha_end_dt=" + vBaechaEndDt
							+ "&vehicle_cd=" + vVehicleCd
							+ "&vehicle_cd_rev=" + vVehicleCdRev
							+ "&vehicle_nm=" + vVehicleNm
							+ "&driver=" + vDriver
							+ "&bigo=" + vBigo 
							;
			
    	pop_fn_popUpScr(modalContentUrl, obj.innerText+"(S858S030101)", '80%', '60%');
     }  
    
    //운송수정
    function pop_fn_TransportInfo_Update(obj) {
		if(vTransportNo.length < 1){
			$('#alertNote').html(obj.innerText + " <BR> <%=JSPpage%>!!! <BR><BR> 운송실적(탭) 정보를 선택하세요  !!!");
			$('#modalalert').show();
			return false;
		}
		var modalContentUrl = "<%=Config.this_SERVER_path%>/Contents/Business/M858/S858S030102.jsp"
						 	+ "?transport_no=" + vTransportNo 
						 	+ "&baecha_no=" + vBaechaNo
							+ "&baecha_seq=" + vBaechaSeq
						 	;
		
		pop_fn_popUpScr(modalContentUrl, obj.innerText+"(S858S030102)", '80%', '60%');
     }
    
    //운송삭제
    function pop_fn_TransportInfo_Delete(obj) {		
    	if(vTransportNo.length < 1){
    		$('#alertNote').html(obj.innerText + " <BR> <%=JSPpage%>!!! <BR><BR> 운송실적(탭) 정보를 선택하세요  !!!");
			$('#modalalert').show();
			return false;
		}
    	var modalContentUrl = "<%=Config.this_SERVER_path%>/Contents/Business/M858/S858S030103.jsp"
				    		+ "?transport_no=" + vTransportNo 
						 	+ "&baecha_no=" + vBaechaNo
							+ "&baecha_seq=" + vBaechaSeq
						 	;
    	
		pop_fn_popUpScr(modalContentUrl, obj.innerText+"(S858S030103)", '80%', '60%');
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
      	  <button type="button" onclick="pop_fn_BaechaInfo_Insert(this)" id="insert" class="btn btn-outline-dark">배차등록</button>
      	  <button type="button" onclick="pop_fn_BaechaInfo_Update(this)" id="update" class="btn btn-outline-success">배차수정</button>
      	  <button type="button" onclick="pop_fn_BaechaInfo_Delete(this)" id="delete" class="btn btn-outline-danger">배차삭제</button>
      	  
      	  <button type="button" onclick="pop_fn_TransportInfo_Insert(this)" id="insert" class="btn btn-outline-dark">운송실적등록</button>
      	  <button type="button" onclick="pop_fn_TransportInfo_Update(this)" id="update" class="btn btn-outline-success">운송실적수정</button>
      	  <button type="button" onclick="pop_fn_TransportInfo_Delete(this)" id="delete" class="btn btn-outline-danger">운송실적삭제</button>
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
	       			<a class="nav-link" id="DetailInfo_List" data-toggle="pill" href="#SubInfo_List_contents" role="tab">배차주문목록</a>
	       		</li>
	       		<li class="nav-item" onclick='fn_BaechaInfo_List()'>
	       			<a class="nav-link" id="BaechaInfo_List" data-toggle="pill" href="#SubInfo_List_contents" role="tab">운송실적</a>
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
 
 <%--   
    <div class="panel panel-default" style="margin-left:5px; margin-top:5px; margin-right:5px; margin-bottom:5px; width:100%" >
        <!-- Default panel contents -->
        <div class="panel-heading" style="font-weight: bold" id="MenuTitle">여기에메뉴타이틀</div>
        <div class="panel-body" >
        
        	<div>
	            <button data-author="mainBtn" type="button"  id="mainButton"  class="btn btn-primary active"
	            			style="width: auto; float: left; ">여기에메뉴타이틀</button>
	            			
	            <button data-author="insert" type="button" onclick="pop_fn_BaechaInfo_Insert(this)" id="insert" class="btn btn-default" 
	            			style="width: auto; float: left; margin-left:30px;">배차등록</button>
	            <button data-author="update" type="button" onclick="pop_fn_BaechaInfo_Update(this)" id="update" class="btn btn-outline-success" 
	            			style="width: auto; float: left; margin-left:3px;">배차수정</button>
	            <button data-author="delete" type="button" onclick="pop_fn_BaechaInfo_Delete(this)" id="delete" class="btn btn-danger" 
	            			style="width: auto; float: left;  margin-left:3px;">배차삭제</button>
	            			
	            <button data-author="insert" type="button" onclick="pop_fn_TransportInfo_Insert(this)" id="insert" class="btn btn-default" 
	            			style="width: auto;float: left; margin-left:30px;">운송실적등록</button>
	            <button data-author="update" type="button" onclick="pop_fn_TransportInfo_Update(this)" id="update" class="btn btn-outline-success" 
	            			style="width: auto;float: left; margin-left:3px;">운송실적수정</button>
	            <button data-author="delete" type="button" onclick="pop_fn_TransportInfo_Delete(this)" id="delete" class="btn btn-danger" 
	            			style="width: auto; float: left; margin-left:3px;">운송실적삭제</button>
	            			
<!-- 	            <label style="width: 100px; clear:both; margin-left:3px;"></label> -->
            </div>
            <p style="width: auto; clear:both;">
            </p>

            <div class="panel panel-default">
                <!-- Default panel contents -->
                <div class="panel-body">
                     <div style="float: left">
                        <table style="width: 100%; text-align:left; background-color:#e0e0e0;">
                            <tr><td style='width:20%; vertical-align: middle;'>
                            		<div class="panel-heading" style="font-size:16px; font-weight: bold"  id="InfoContentTitle"></div>
                            	</td>
                            	<td style='width:5%; vertical-align: middle'>주문일자 :</td>
                                <td style='width:6%;  vertical-align: middle'>
                                    <input type="text" data-date-format="yyyy-mm-dd" id="dateFrom" class="form-control" />
                                </td>
                                <td style='width:1%;vertical-align: middle'>
                                    &nbsp;~&nbsp;
                                </td>
                                <td style='width:6%; vertical-align: middle'>
                                    <input type="text" data-date-format="yyyy-mm-dd" id="dateTo" class="form-control" />
                                </td>
                                <td style="width:62%; text-align:left">
                                    <button type="button" onclick="fn_MainInfo_List()" id="btn_Search" class="btn  btn-outline-success" style='width:100px; margin-left: 20px;'>조 회</button>
                                </td>
                            </tr>
                        </table>
                        <p>
                        </p>
                        
                    </div>
 					<div  style="clear:both; height:10px ;border-top: 1px solid #D2D6Df;" >
                    </div>
                    <div id="MainInfo_List_contents"  style="clear:both; " >
                    </div>
                </div>

                <div id="tabs">
		         	<ul >
		         		<li onclick='fn_DetailInfo_List()'><a id="DetailInfo_List"  href='#SubInfo_List_contents'>배차주문목록</a></li>
		         		<li onclick='fn_BaechaInfo_List()'><a id="BaechaInfo_List"  href='#SubInfo_List_contents'>운송실적</a></li>
		            </ul>
                    <div id="SubInfo_List_contents" ></div>
                </div>
        	</div>
		</div>
    </div>
--%>