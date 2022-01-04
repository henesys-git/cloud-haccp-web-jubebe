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
	String GV_GET_NUM_PREFIX = prcStatusCheck.GV_PROCESS_NUMBER_GUBUN;
%>  

<script type="text/javascript">
 	
    var vPackageNo = "";
    var vExec_Note = "";
   	var vExpirationDate = "";

    $(document).ready(function () {
    	/* new SetDate("dateFrom", -180);
    	new SetDate("dateTo", 0); */
    	
    	 new SetRangeDate("dateParent", "dateRange", 180);
	      
		var startDate = $('#dateRange').data('daterangepicker').startDate.format('YYYY-MM-DD');
	    var endDate = $('#dateRange').data('daterangepicker').endDate.format('YYYY-MM-DD');
	    fn_MainInfo_List(startDate, endDate);
	  	
	  	$('#dateRange').on('apply.daterangepicker', function(ev, picker) {
			var startDate = picker.startDate.format('YYYY-MM-DD');
	    	var endDate = picker.endDate.format('YYYY-MM-DD');
	    	fn_MainInfo_List(startDate, endDate);
	  	});
    	
    	
<%--         makeMenu("<%=htmlsideMenu%>"); --%>
        fn_MainSubMenuSelect("<%=sMenuTitle%>");
        
        $("#InfoContentTitle").html("주문 및 공정목록");

		// 전역변수 초기화
		vOrderNo = "";
		vOrderDetailSeq = ""; 
		
		fn_MainInfo_List();
	    
	    //탭 클릭시 처리하는 Function
	    //$( function() {$( "#tabs" ).tabs();});

        fn_tagProcess('<%=JSPpage%>');
        
        
	    
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
        if ($("#ProcessInfo_seolbi").children().length > 0) {
            $("#ProcessInfo_seolbi").children().remove();
        }
        if ($("#ProcessInfo_sibang").children().length > 0) {
            $("#ProcessInfo_sibang").children().remove();
        }
        if ($("#ProcessInfo_processcheck").children().length > 0) {
            $("#ProcessInfo_processcheck").children().remove();
        }        
        if ($("#SubInfo_Inspect_List_contents").children().length > 0) {
//             $("#SubInfo_Inspect_List_contents").children().remove();
        }        
    }

    function fn_MainInfo_List(startDate, endDate) {
        <%-- var from = $("#dateFrom").val();
        var to = $("#dateTo").val();
        var custcode = '';

        $.ajax(
        {
            type: "POST",
            url: "<%=Config.this_SERVER_path%>/Contents/Business/M303/S303S060700.jsp", 
            data: "custcode=" + custcode + "&From=" + from + "&To=" + to    + "&JSPpage=" + "<%=JSPpage%>",
            beforeSend: function () {
                $("#MainInfo_List_contents").children().remove();
            },
            success: function (html) {
                $("#MainInfo_List_contents").hide().html(html).fadeIn(100);
            },
            error: function (xhr, option, error) {
            }
        });
         --%>
        
         var custcode = "";
         
         $.ajax({
             type: "POST",
             url: "<%=Config.this_SERVER_path%>/Contents/Business/M303/S303S060700.jsp",
             data: "custcode=" + custcode + "&From=" + startDate + "&To=" + endDate + "&JSPpage=" + "<%=JSPpage%>",
             beforeSend: function () {
//           	$("#MainInfo_List_contents").children().remove();
             },
             success: function (html) {
                 $("#MainInfo_List_contents").hide().html(html).fadeIn(100);
             },
             error: function (xhr, option, error) {

             }
         });
         
         
        $("#SubInfo_List_contents").children().remove();
        $("#SubInfo_List_Doc").children().remove();
        $("#SubInfo_BOM").children().remove();
        $("#SubInfo_Inspect_List_contents").children().remove();
    }
      
	function fn_DetailInfo_List() {     
    	$.ajax(
    	    {
    	        type: "POST",
    	        url: "<%=Config.this_SERVER_path%>/Contents/Business/M303/S303S060710.jsp",
    	        data: "OrderNo=" + vOrderNo + "&lotno=" + vLotNo 
    	        	+ "&prod_cd=" + vProdCd + "&prod_cd_rev=" + vProdRev
    	        	 + "&OrderDetail=" + vOrderDetailSeq,
    	        beforeSend: function () {
    	            //$("#SubInfo_List_contents").children().remove();
    	        },
    	        success: function (html) {
    	            $("#SubInfo_List_contents").hide().html(html).fadeIn(100);
    	        },
    	        error: function (xhr, option, error) {
    	        }
    	    });
		return;
	}
	
    //포장실적등록
    function pop_fn_work_result_Insert(obj,btn_gubun) {
    	if(vOrderNo.length < 1){
    		$('#alertNote').html(obj.innerText + " <BR> <%=JSPpage%>!!! <BR><BR> 주문정보를 선택하세요  !!!");
			$('#modalalert').show();
			return;
		}

    	var modalContentUrl = "<%=Config.this_SERVER_path%>/Contents/Business/M303/S303S060701.jsp"
    						+ "?order_no=" + vOrderNo
    						+ "&OrderDetail=" + vOrderDetailSeq
    						+ "&lotno=" + vLotNo
    						+ "&prod_cd=" + vProdCd + "&prod_cd_rev=" + vProdRev
    						+ "&cust_name=" + vCustName
    						+ "&prod_nm=" + vProdNm
    						+ "&jspPage=" + "<%=JSPpage%>" 
    						+ "&num_gubun=" + "<%=GV_GET_NUM_PREFIX%>"
    						+ "&product_process_yn=" + "Y"
    						+ "&packing_process_yn=" + "Y"
    						+ "&lot_count=" + vLotCount
    						+ "&expiration_date=" + vExpirationDate
							;
    					
    	pop_fn_popUpScr(modalContentUrl, obj.innerText+"(S303S060701)", '80%', '900px');
    	
     }    
    
	//문서등록
    function pop_fn_JumunDoc_Insert(obj) {
		if(vOrderNo.length < 1){
			$('#alertNote').html(obj.innerText + " <BR> <%=JSPpage%>!!! <BR><BR> 주문정보를 선택하세요  !!!");
			$('#modalalert').show();
			return;
		}
    	var modalContentUrl;
    	modalContentUrl = "<%=Config.this_SERVER_path%>/Contents/Business/M101/S101S020121.jsp?OrderNo=" + vOrderNo 
				+ "&OrderDetail=" + vOrderDetailSeq
    			+ "&jspPage=" + "<%=JSPpage%>" 
    			+ "&num_gubun=<%=GV_GET_NUM_PREFIX%>"
    			+ "&LotNo=" + vLotNo
    			;
    	
		modalFramePopup.setTitle(obj.innerText);
		pop_fn_popUpScr(modalContentUrl, obj.innerText+"(S101S020121)", "550px", "1000px");
		return false;
     }
	
    //포장실적수정
    function pop_fn_work_result_Update(obj) {
    	if(vPackageNo.length < 1){
			$('#alertNote').html(obj.innerText + " <BR> <%=JSPpage%>!!! <BR><BR> 포장공정실적(하단탭)에서 정보를 선택하세요  !!!");
			$('#modalalert').show();
			return false;
		}
    	var  modalContentUrl = "<%=Config.this_SERVER_path%>/Contents/Business/M303/S303S060702.jsp"
    						 + "?order_no=" + vOrderNo
    						 + "&OrderDetail=" + vOrderDetailSeq
							 + "&lotno=" + vLotNo
							 + "&prod_cd=" + vProdCd + "&prod_cd_rev=" + vProdRev
							 + "&cust_name=" + vCustName
							 + "&prod_nm=" + vProdNm
							 + "&package_no=" + vPackageNo
							 + "&lot_count=" + vLotCount
	    					 + "&expiration_date=" + vExpirationDate
							 ;

    	pop_fn_popUpScr(modalContentUrl, obj.innerText+"(S303S060702)", '80%', '900px');
     }
    
    //포장실적삭제
    function pop_fn_work_result_Delete(obj) {
    	if(vPackageNo.length < 1){
			$('#alertNote').html(obj.innerText + " <BR> <%=JSPpage%>!!! <BR><BR> 포장공정실적(하단탭)에서 정보를 선택하세요  !!!");
			$('#modalalert').show();
			return false;
		}
    	var  modalContentUrl = "<%=Config.this_SERVER_path%>/Contents/Business/M303/S303S060703.jsp"
    						 + "?order_no=" + vOrderNo
    						 + "&OrderDetail=" + vOrderDetailSeq
							 + "&lotno=" + vLotNo
							 + "&prod_cd=" + vProdCd + "&prod_cd_rev=" + vProdRev
							 + "&cust_name=" + vCustName
							 + "&prod_nm=" + vProdNm
							 + "&package_no=" + vPackageNo
							 + "&lot_count=" + vLotCount
	    					 + "&expiration_date=" + vExpirationDate
    						 ;

    	pop_fn_popUpScr(modalContentUrl, obj.innerText+"(S303S060703)", '80%', '40%');
    }
    
	//포장검사
	function pop_fn_work_result_Inspect(obj) {
	//     		alert(vOrderNo);
		if(vOrderNo.length < 1){
			$('#alertNote').html("<%=JSPpage%>!!! <BR><BR> 검사할 제품을 선택하세요!!");
			$('#modalalert').show();
		return;
		}
	
		var modalContentUrl;
	     	
		modalContentUrl = "<%=Config.this_SERVER_path%>/Contents/Business/M303/S303S060751.jsp?OrderNo=" + vOrderNo 
			+ "&OrderDetail=" + vOrderDetailSeq
			+ "&lotno=" + vLotNo
			+ "&prod_cd=" + vProdCd + "&prod_cd_rev=" + vProdRev
			+ "&product_nm=" + vProdNm
			+ "&cust_nm=" + vCustName
			+ "&lot_count=" + vLotCount
			+ "&product_serial_no=" + vProductSerialNo
			+ "&product_serial_no_end=" + vProductSerialNoEnd
			+ "&jspPage=" + "<%=JSPpage%>"
			+ "&num_gubun=<%=GV_GET_NUM_PREFIX%>";
		pop_fn_popUpScr(modalContentUrl, obj.innerText+"(S303S060751)", '80%', '80%');
	}  
	
	function fn_work_result_Inspect_Detail() {     
    	$.ajax(
    	    {
    	        type: "POST",
    	        url: "<%=Config.this_SERVER_path%>/Contents/Business/M303/S303S060760.jsp",
//     	        data: "OrderNo=" + vOrderNo + "&lotno=" + vLotNo + "&InspectGubun=" + vInspectGubun + "&product_serial_no=" + vProductSerialNo + "&product_serial_no_end=" + vProductSerialNoEnd,
    	        data: "OrderNo=" + vOrderNo 
    	        	+ "&OrderDetail=" + vOrderDetailSeq
    	        	+ "&lotno=" + vLotNo + "&product_serial_no=" + vProductSerialNo + "&product_serial_no_end=" + vProductSerialNoEnd,
    	        beforeSend: function () {
//     	            //$("#SubInfo_List_contents").children().remove();
    	        },
    	        success: function (html) {
    	            $("#SubInfo_List_contents").hide().html(html).fadeIn(100);
    	        },
    	        error: function (xhr, option, error) {
    	        }
    	    });
		return;
	}
	
	function fn_View_Canvas(obj) {
    	var modalContentUrl  = "<%=Config.this_SERVER_path%>/Contents/Business/M303/S303S060703_canvas_tyens.jsp"
					    		+ "?page_start=" + 0  // 1페이지	
					    		+ "&order_no=" + vOrderNo
								+ "&lotno=" + vLotNo
								+ "&prod_cd=" + vProdCd 
								+ "&prod_cd_rev=" + vProdRev
								+ "&package_no=" + vPackageNo;
    	pop_fn_popUpScr(modalContentUrl, "<%=sMenuTitle%>"+"(S303S060703_canvas)", '800px', '1500px');
    	return false;
	}

	function fn_View_Canvas2(obj) {
    	var vInspectResultDt	= $(obj).parent().parent().find("td").eq(7).text().trim();
    	var vInspectGubun	= $(obj).parent().parent().find("td").eq(14).text().trim();
    	
    	vInspectResultDt = vInspectResultDt.substring(0, 10);
    	
    	var modalContentUrl  = "<%=Config.this_SERVER_path%>/Contents/Business/M303/S303S060703_canvas2_tyens.jsp"
    	 					 + "?page_start=" + 1  // 1페이지	
							 + "&inspect_gubun=" + vInspectGubun
							 + "&inspect_result_dt=" + vInspectResultDt;
    	pop_fn_popUpScr(modalContentUrl, "<%=sMenuTitle%>"+"(S303S060703_canvas1)", '800px', '1500px');
    	return false;
	}
	
	//포장검수일지등록
    function pop_fn_Inspection_Insert(obj,btn_gubun) {
    	if(vPackageNo.length < 1){
    		$('#alertNote').html(obj.innerText + " <BR> <%=JSPpage%>!!! <BR><BR> 포장공정실적 (하단탭) 를 선택하세요  !!!");
			$('#modalalert').show();
			return;
		}
    	
    	var modalContentUrl = "<%=Config.this_SERVER_path%>/Contents/Business/M303/S303S060761.jsp"
    						+ "?order_no=" + vOrderNo
    						+ "&lotno=" + vLotNo
    						+ "&prod_cd=" + vProdCd + "&prod_cd_rev=" + vProdRev
    						+ "&package_no=" + vPackageNo 
    						+ "&jspPage=" + "<%=JSPpage%>";
    						
    	pop_fn_popUpScr(modalContentUrl, obj.innerText+"(S303S060761)", '80%', '50%');
    	
     }  
	
  //생산별 BOM등록
	function pop_fn_production_storage_Insert(obj) {		
		if(vOrderNo.length < 1){
    		$('#alertNote').html(obj.innerText + " <BR> <%=JSPpage%>!!! <BR><BR> 주문정보를 선택하세요  !!!");
   	 		$('#modalalert').show();
   	 		return false;
   	 	}
		
    	var modalContentUrl;
    	modalContentUrl = "<%=Config.this_SERVER_path%>/Contents/Business/M303/S303S060791.jsp"
			+ "?order_no=" + vOrderNo
			+ "&order_detail_seq=" + vOrderDetailSeq
			+ "&prod_cd=" + vProdCd
			+ "&prod_rev=" + vProdRev
			+ "&product_nm=" + vProdNm
			+ "&lot_count=" + vLotCount
			+ "&delivery_date=" + vDeliveryDate
			+ "&jspPage=" + "<%=JSPpage%>"
			;
    	pop_fn_popUpScr(modalContentUrl, obj.innerText+"(S303S060791)", '90%', '70%');
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
      	  <button type="button" onclick="pop_fn_work_result_Insert(this,0)" id="insert" class="btn btn-outline-dark">포장실적등록</button>
      	  <button type="button" onclick="pop_fn_work_result_Update(this)" id="update" class="btn btn-outline-success">포장실적수정</button>
      	  <button type="button" onclick="pop_fn_work_result_Delete(this)" id="delete" class="btn btn-outline-danger">포장실적삭제</button>
      	  <button type="button" onclick="pop_fn_production_storage_Insert(this)" id="insert" class="btn btn-outline-dark">부자재 불츨등록</button>
      	  <button type="button" onclick="pop_fn_JumunDoc_Insert(this)" id="insert" class="btn btn-outline-dark">문서등록</button>
      	  <button type="button" onclick="pop_fn_work_result_Inspect(this)" id="insert" class="btn btn-outline-dark">포장검사등록</button>
      	  <button type="button" onclick="pop_fn_Inspection_Insert(this)" id="insert" class="btn btn-outline-dark">포장검수일지등록</button>
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
	       			<a class="nav-link" id="DetailInfo_List" data-toggle="pill" href="#SubInfo_List_contents" role="tab">포장공정실적</a>
	       		</li>
	       		<li class="nav-item" onclick='com_fn_SubInfo_DOC_List_Process(this,vOrderNo)'>
	       			<a class="nav-link" id="SubInfo_DOC_List" data-toggle="pill" href="#SubInfo_List_Doc" role="tab">주문문서목록</a>
	       		</li>
	       		<li class="nav-item" onclick='fn_work_result_Inspect_Detail()'>
	       			<a class="nav-link" id="work_result_Inspect_Detail" data-toggle="pill" href="#SubInfo_Inspect_List_contents" role="tab">포장검사결과</a>
	       		</li>
	        </ul>
	     	<div class="tab-content" id="custom-tabs-one-tabContent">
	     		<div class="tab-pane fade" id="SubInfo_List_contents" role="tabpanel"></div>
	     		<div class="tab-pane fade" id="SubInfo_List_Doc" role="tabpanel"></div>
	     		<div class="tab-pane fade" id="SubInfo_Inspect_List_contents" role="tabpanel"></div>
	     		
	        </div>
        </div>
    </div>
  </div><!-- /.container-fluid -->
</div>
<!-- /.content -->
   
   <!--  
    <div class="panel panel-default" style="margin-left:5px; margin-top:5px; margin-right:5px; margin-bottom:5px; width:100%" >
        Default panel contents
        <div class="panel-heading" style="font-weight: bold" id="MenuTitle">여기에메뉴타이틀</div>
        <div class="panel-body" >
        
        	<div>
	            <button data-author="mainBtn" type="button"  id="mainButton"  class="btn btn-primary active"
	            			style="width: auto; float: left; ">xxxxxxx</button>
	            <button data-author="insert" type="button" onclick="pop_fn_work_result_Insert(this,0)" id="insert" class="btn btn-default" 
	            			style="width: auto;float: left; margin-left:30px;">포장실적등록</button>
	            <button data-author="update" type="button" onclick="pop_fn_work_result_Update(this)" id="update" class="btn btn-outline-success" 
	            			style="width: auto;float: left; margin-left:3px;">포장실적수정</button>
	            <button data-author="delete" type="button" onclick="pop_fn_work_result_Delete(this)" id="delete" class="btn btn-danger" 
	            			style="width: auto; float: left; margin-left:3px;">포장실적삭제</button>
	            			
	            <button data-author="insert" type="button" onclick="pop_fn_production_storage_Insert(this)" id="update" class="btn btn-default" 
	            			style="width: auto; float: left; margin-left:15px;">부자재 불출등록</button>
	            <button data-author="insert" type="button" onclick="pop_fn_JumunDoc_Insert(this)" id="insert" class="btn btn-default" 
	            			style="width: auto;float: left; margin-left:15px;">문서등록</button>
	            			
	            <button data-author="insert" type="button" onclick="pop_fn_work_result_Inspect(this)" id="insert" class="btn btn-default" 
	            			style="width: auto;float: left; margin-left:15px;">포장검사등록</button>
	            <button data-author="insert" type="button" onclick="pop_fn_Inspection_Insert(this)" id="update" class="btn btn-default" 
	            			style="width: auto; float: left;  margin-left:15px;">포장검수일지등록</button>

            </div>
            <p style="width: auto; clear:both;">
            </p>

            <div class="panel panel-default">
                Default panel contents
                <div class="panel-body">
                    <div style="float: left">
                        <table style="width: 100%; text-align:left; background-color:#e0e0e0;">
                            <tr><td style='width:20%; vertical-align: middle;'>
                            		<div class="panel-heading" style="font-size:16px; font-weight: bold"  id="InfoContentTitle"></div>
                            	</td>
                            	<td style='width:5%; vertical-align: middle'>수행일자 :</td>
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
                        <p></p>
                    </div>
 					<div  style="clear:both; border-top: 1px solid #D2D6Df;" >
	                    <div id="MainInfo_List_contents"  ></div>
                    </div>
                </div>

                <div id="tabs">
		         	<ul >
	                	<li onclick='fn_DetailInfo_List()'><a id="DetailInfo_List"  href='#SubInfo_List_contents'>포장공정실적</a></li>
	                	<li onclick='com_fn_SubInfo_DOC_List_Process(this,vOrderNo)'><a id="SubInfo_DOC_List"  href='#SubInfo_List_Doc'>주문문서목록</a></li>
		                <li onclick='fn_work_result_Inspect_Detail()'><a id="work_result_Inspect_Detail"  href='#SubInfo_Inspect_List_contents'>포장검사결과</a></li>
		            </ul>
                    <div id="SubInfo_List_contents" ></div>
                    <div id="SubInfo_List_Doc" ></div>
                    <div id="SubInfo_Inspect_List_contents" ></div>
                </div>
        	</div>
		</div>
    </div> -->