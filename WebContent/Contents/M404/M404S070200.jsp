<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page language="java"
	import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="mes.client.comm.*"%>
<%@ page import="mes.client.common.*"%>
<%@ page import="mes.client.guiComponents.*"%>
<%@ page import="mes.client.util.*"%>
<%@ page import="mes.client.conf.*"%>
<%
/* 
출하검사(M404S070100.jsp)
 */
	String loginID = session.getAttribute("login_id").toString();
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
// 	ProcesStatusCheck prcStatusCheck = new ProcesStatusCheck(JSPpage+"|"+"PRDINSP"+"|");
	ProcesStatusCheck prcStatusCheck = new ProcesStatusCheck(JSPpage+"|"+"ODPROCS"+"|");
	
	String GV_PROCESS_MODIFY	= prcStatusCheck.GV_PROCESS_MODIFY;
	String GV_PROCESS_DELETE	= prcStatusCheck.GV_PROCESS_DELETE;
	String GV_GET_NUM_PREFIX	= prcStatusCheck.GV_PROCESS_NUMBER_GUBUN;

// 	Vector optCode =  null;
//     Vector optName =  null;
// 	Vector InspectGubunVector = CommonData.getInspectGubunCode();


%>

<script type="text/javascript">
 	  
 	
 	var vinspect_req_no =""; 
 	var vproc_cd = ""; 
 	var vproc_cd_rev = "";
 	var vgubun_code = "";
 	var vgubun_code_name = "";
 	var vprod_cd = "";
 	var vprod_cd_rev = "";
 	var checklist_cd = "";
 	var inspect_no="";
 	var vInspectGubun = "";
 	var vLotNo = "";

    $(document).ready(function () {
    	<%-- new SetDate("dateFrom", -180);
    	new SetDate("dateTo", 0);
        
        fn_MainSubMenuSelect("<%=sMenuTitle%>");
		$("#InfoContentTitle").html("품질검사요청목록");

    	fn_MainInfo_List();
		
      //탭 클릭시 처리하는 Function
	    //$( function() {$( "#tabs" ).tabs();});

	    fn_tagProcess('<%=JSPpage%>'); --%>
	    
	    new SetRangeDate("dateParent", "dateRange", 180);
	      
		var startDate = $('#dateRange').data('daterangepicker').startDate.format('YYYY-MM-DD');
	    var endDate = $('#dateRange').data('daterangepicker').endDate.format('YYYY-MM-DD');
	    fn_MainInfo_List(startDate, endDate);
	  	
	  	$('#dateRange').on('apply.daterangepicker', function(ev, picker) {
			var startDate = picker.startDate.format('YYYY-MM-DD');
	    	var endDate = picker.endDate.format('YYYY-MM-DD');
	    	fn_MainInfo_List(startDate, endDate);
	  	});
	  	
		$("#InfoContentTitle").html("품질검사요청목록");
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
        if ($("#sub_SubInfo_List_contents").children().length > 0) {
            $("#sub_SubInfo_List_contents").children().remove();
        }
        if ($("#ProcessInfo_sibang").children().length > 0) {
            $("#ProcessInfo_sibang").children().remove();
        }
        if ($("#ProcessInfo_processcheck").children().length > 0) {
            $("#ProcessInfo_processcheck").children().remove();
        }        
    }


    function fn_MainInfo_List(startDate, endDate) {
		var custcode = "";
        
        $.ajax({
            type: "POST",
            url: "<%=Config.this_SERVER_path%>/Contents/Business/M404/S404S070200.jsp",
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
        
        //$("#SubInfo_List_contents").children().remove();
        //$("#SubInfo_List_Doc").children().remove();
        $("#SubInfo_BOM").children().remove();
        $("#SubInfo_check").children().remove();
    }
    
	function fn_DetailInfo_List() {     
    	$.ajax(
    	    {
    	        type: "POST",
    	        url: "<%=Config.this_SERVER_path%>/Contents/Business/M404/S404S070210.jsp",
    	        data: "OrderNo=" + vOrderNo + "&lotno=" + vLotNo 
    	        	+ "&order_detail_seq=" + vOrderDetailSeq + "&InspectGubun=" + vInspectGubun 
    	        	+ "&product_serial_no=" + vProductSerialNo + "&product_serial_no_end=" + vProductSerialNoEnd,
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

    //출하검사등록
    function pop_fn_inspect_result_Insert(obj) {
// 		alert(vOrderNo);
		if(vOrderNo.length < 1){
			heneSwal.warning("<%=JSPpage%>!!! 검사할 출하를 선택하세요!!");
			return false;
		}

    	var modalContentUrl;
    	
    	modalContentUrl = "<%=Config.this_SERVER_path%>/Contents/Business/M404/S404S070201.jsp?OrderNo=" + vOrderNo 
    			+ "&lotno=" + vLotNo
    			+ "&order_detail_seq=" + vOrderDetailSeq
    			+ "&product_nm=" + vProdNm
                + "&lot_count=" + vLotCount
                + "&product_serial_no=" + vProductSerialNo
                + "&product_serial_no_end=" + vProductSerialNoEnd
    			+ "&jspPage=" + "<%=JSPpage%>"
    			+ "&num_gubun=<%=GV_GET_NUM_PREFIX%>";
    			
    		var footer = "";
			var title = obj.innerText;
			var heneModal = new HenesysModal(modalContentUrl, 'large', title+"(S404S070201)", footer);
			heneModal.open_modal();
     }  

    function pop_fn_inspect_Doc_Insert(obj) {
		if(vOrderNo.length < 1){
			heneSwal.warning("<%=JSPpage%>!!! PO List 하나를 선택하세요!!");
			return false;
		}
    	var modalContentUrl;
    	modalContentUrl = "<%=Config.this_SERVER_path%>/Contents/Business/M101/S101S020121.jsp?OrderNo=" + vOrderNo 
				+ "&OrderDetail=" + vLotNo
    			+ "&jspPage=" + "<%=JSPpage%>" 
    			+ "&num_gubun=<%=GV_GET_NUM_PREFIX%>"
    			+ "&LotNo=" + vLotNo
    			;

    	var footer = "";
		var title = obj.innerText;
		var heneModal = new HenesysModal(modalContentUrl, 'large', title+"(S101S020121)", footer);
		heneModal.open_modal();
     }    
    
    //출하검사수정
    function pop_fn_inspect_result_Update(obj) {
// 		if(vOrderNo.length < 1){
<%-- 			$('#alertNote').html(obj.innerText + " <BR> <%=JSPpage%>!!! <BR><BR> 주문정보를 선택하세요  !!!"); --%>
// 			$('#modalalert').show();
// 			return false;
// 		}
    	var  modalContentUrl = "<%=Config.this_SERVER_path%>/Contents/Business/M404/S404S070202.jsp?OrderNo=" + vOrderNo 
		+ "&OrderDetail=" + vLotNo
			+ "&jspPage=" + "<%=JSPpage%>" ;
    	pop_fn_popUpScr(modalContentUrl, obj.innerText+"(S404S070202)", '500px', '1600px');
     }
    //부적합등록
    function pop_fn_inspect_incong_Update(obj) {
//     	alert(product_serial_no);
		if(vOrderNo.length < 1){
			$('#alertNote').html("<%=JSPpage%>!!! <BR><BR> 부적합 목록을 선택하세요!!");
			$('#modalalert').show();
			return;
		}
    	var modalContentUrl;
    	//GV_JSPPAGE="",GV_NUM_GUBUN="", GV_ORDER_NO="", GV_ORDER_DETAIL_SEQ="",GV_PROD_CD="",GV_PROD_CD_REV="",GV_PRODUCT_NM="",GV_LOT_NO
    	modalContentUrl = "<%=Config.this_SERVER_path%>/Contents/Business/M405/S405S030101.jsp?OrderNo=" + vOrderNo
			+ "&lotno=" + vLotNo
			+ "&prod_cd=" + vprod_cd
			+ "&prod_rev=" + vproc_cd_rev
			+ "&product_nm=" + product_nm
			+ "&proc_cd=" + vproc_cd
			+ "&proc_cd_rev=" + vproc_cd_rev
			+ "&process_name=" + process_nm
			+ "&product_serial_no=" + product_serial_no
			+ "&jspPage=" + "<%=JSPpage%>" 
			+ "&num_gubun=<%=GV_GET_NUM_PREFIX%>";
    	pop_fn_popUpScr(modalContentUrl, obj.innerText+"(S405S030101)", '550px', '800px');
     }  
    
    //출하검사삭제
    function pop_fn_inspect_result_Delete(obj) {		

//     	if(checklist_cd==false){
//     		alert("삭제할 출하을 선택하세요")
//     		return false;
//     	}
		if(checklist_cd.length < 1){
			heneSwal.warning("<%=JSPpage%>!!! 삭제할 출하를 선택하세요!!");
			return false;
		}
    	
    	var modalContentUrl;
    	modalContentUrl = "<%=Config.this_SERVER_path%>/Contents/Business/M404/S404S070203.jsp?OrderNo=" + vOrderNo 
			+ "&lotno=" + vLotNo 
			+ "&product_nm=" + vProdNm
// 			+ "&process_nm=" + process_nm
// 			+ "&gubun_code=" + vgubun_code
// 			+ "&proc_info_no=" + proc_info_no
// 	        + "&proc_cd=" + vproc_cd
// 	        + "&proc_cd_rev=" + vproc_cd_rev
// 	        + "&inspect_result_dt=" + inspect_result_dt
// 	        + "&project_name=" + project_name
	        + "&lot_count=" + vLotCount
	        + "&product_serial_no=" + vProductSerialNo
	        + "&product_serial_no_end=" + vProductSerialNoEnd
// 	        + "&inspect_no=" + inspect_no
// 	        + "&checklist_cd=" + checklist_cd
	        + "&inspect_seq=" + inspect_seq
			+ "&jspPage=" + "<%=JSPpage%>"
			+ "&num_gubun=<%=GV_GET_NUM_PREFIX%>";
    	
		var footer = "";
		var title = obj.innerText;
		var heneModal = new HenesysModal(modalContentUrl, 'large', title+"(S404S070203)", footer);
		heneModal.open_modal();
    	
     }
 
    
    function pop_fn_inspect_result_Comlete(obj) {
    	
		if(vOrderNo.length < 1){
			$('#alertNote').html("<%=JSPpage%>!!! <BR><BR> 완료할 출하을 선택하세요!!");
			$('#modalalert').show();
			return;
		}
		
    	var modalContentUrl = "<%=Config.this_SERVER_path%>/Contents/Business/M404/S404S070222.jsp?OrderNo=" + vOrderNo 
		+ "&lotno=" + vLotNo 
		+ "&product_nm=" + vProdNm
		+ "&gubun_code=" + vgubun_code
        + "&lot_count=" + vLotCount
        + "&product_serial_no=" + vProductSerialNo
        + "&product_serial_no_end=" + vProductSerialNoEnd
        + "&inspect_req_no=" + vinspect_req_no
		+ "&jspPage=" + "<%=JSPpage%>"
		+ "&num_gubun=<%=GV_GET_NUM_PREFIX%>";

		pop_fn_popUpScr(modalContentUrl, obj.innerText+"(S404S070222)", '750px', '1600px');
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
      	  <button type="button" onclick="pop_fn_inspect_result_Insert(this)" id="insert" class="btn btn-outline-dark">출하검사등록</button>
      	  <button type="button" onclick="pop_fn_inspect_Doc_Insert(this)" id="insert" class="btn btn-outline-dark">문서등록</button>
      	  <button type="button" onclick="pop_fn_inspect_result_Delete(this)" id="delete" class="btn btn-outline-danger">출하검사삭제</button>
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
	       			<a class="nav-link" id="DetailInfo_List" data-toggle="pill" href="#SubInfo_List_contents" role="tab">출하검사결과</a>
	       		</li>
	       		<li class="nav-item" onclick='com_fn_SubInfo_DOC_List(this,vOrderNo)'>
	       			<a class="nav-link" id="SubInfo_DOC_List" data-toggle="pill" href="#SubInfo_List_Doc" role="tab">문서목록</a>
	       		</li>
	       		<li class="nav-item" onclick='pop_fn_ProcessCheckList(this, "<%=JSPpage%>")'>
	       			<a class="nav-link" id="SubInfo_DOC_List" data-toggle="pill" href="#SubInfo_check" role="tab">공정확인표</a>
	       		</li>
	        </ul>
	     	<div class="tab-content" id="custom-tabs-one-tabContent">
	     		<div class="tab-pane fade" id="SubInfo_List_contents" role="tabpanel"></div>
	     		<div class="tab-pane fade" id="SubInfo_List_Doc" role="tabpanel"></div>
	     		<div class="tab-pane fade" id="SubInfo_check" role="tabpanel"></div>
	        </div>
        </div>
    </div>
  </div><!-- /.container-fluid -->
</div>
<!-- /.content -->

    
<%-- <div class="panel panel-default"
	style="margin-left: 5px; margin-top: 5px; margin-right: 5px; margin-bottom: 5px; width: 100%">
	<!-- Default panel contents -->
	<div class="panel-heading" style="font-weight: bold" id="MenuTitle">여기에메뉴타이틀</div>
	<div class="panel-body">

		<div>
			<button data-author="mainBtn" type="button" id="mainButton"
				class="btn btn-primary active" style="width: auto; float: left;">품질관리-출하검사</button>
			<button data-author="insert" type="button" onclick="pop_fn_inspect_result_Insert(this)" id="insert"
				class="btn btn-default" style="width: auto; float: left; margin-left: 30px;">출하검사등록</button>
			<button data-author="insert" type="button" onclick="pop_fn_inspect_Doc_Insert(this)" id="insert"
				class="btn btn-default" style="width: auto; float: left; margin-left: 3px;">문서등록</button>
<!-- 			<button data-author="update" type="button" onclick="pop_fn_inspect_result_Update(this)" id="update" -->
<!-- 				class="btn btn-outline-success" style="width: auto; float: left; margin-left: 3px;">출하검사수정</button> -->
<!-- 			<button data-author="update" type="button" onclick="pop_fn_inspect_incong_Update(this)" id="update" -->
<!-- 				class="btn btn-outline-success" style="width: auto; float: left; margin-left: 3px;">부적합등록</button> -->
			<button data-author="delete" type="button" onclick="pop_fn_inspect_result_Delete(this)" id="delete"
				class="btn btn-danger" style="width: auto; float: left; margin-left: 3px;">출하검사삭제</button>
<!-- 	        <button data-author="update" type="button" onclick="pop_fn_inspect_result_Comlete(this)" id="update"  -->
<!-- 	        	class="btn btn-warning"  style="width: auto; float: left;  margin-left:30px;">출하검사완료</button> -->
			<label style="width:; float: left; margin-left: 3px;"></label>

		</div>
		<p style="width: auto; clear: both;"></p>

		<div class="panel panel-default">
			<!-- Default panel contents tbi_product_inpect_request -->
<!-- 			<div class="panel-heading" style="font-size: 16px; font-weight: bold" id="InfoContentTitle"></div> -->
			<div class="panel-body">
				<div style="float: left">
                        <table style="width: 100%; text-align:left; background-color:#e9e9e9;">
                            <tr><td style='width:15%; vertical-align: middle;'>
                            		<div class="panel-heading" style="font-size:16px; font-weight: bold"  id="InfoContentTitle"></div>
                            	</td>
                            	
                            	<td style='width:5%; vertical-align: middle'>요청일자 :</td>
                                <td style='width:6%;  vertical-align: middle'>
                                    <input type="text" data-date-format="yyyy-mm-dd" id="dateFrom" class="form-control" />
                                </td>
                                <td style='width:1%;vertical-align: middle'>
                                    &nbsp;~&nbsp;
                                </td>
                                <td style='width:6%; vertical-align: middle'>
                                    <input type="text" data-date-format="yyyy-mm-dd" id="dateTo" class="form-control" />
                                </td>

<!--                                 <td style='vertical-align: middle;'> -->
<!--                                     <LABEL style="vertical-align: middle;margin-left:40px;margin-top:5px;float: left">검사구분 : &nbsp;</LABEL> -->
<!-- 	                                <select class="form-control" id="select_InspectGubunCode" style="width: 120px;float: left"> -->
	                                <%	optCode =  (Vector)InspectGubunVector.get(0);%>
	                                <%	optName =  (Vector)InspectGubunVector.get(1);%>
	                                <%for(int i=0; i<optName.size();i++){ %>
									  <option value='<%=optCode.get(i).toString()%>'><%=optName.get(i).toString()%></option>
									<%} %>
<!-- 									</select> -->
<!--                                 </td> -->
                                <td style="width:52%; text-align:left">
                                    <button type="button" onclick="fn_MainInfo_List()" id="btn_Search" class="btn  btn-outline-success" style='width:100px;margin-left:3px;'>조 회</button>
                                </td>
                            </tr>
                        </table>
                        
					<p></p>

				</div>
				<div style="clear: both; height: 10px; border-top: 1px solid #D2D6Df;">
				</div>
				<div id="MainInfo_List_contents" style="clear: both;"></div>
			</div>

			<div id="tabs">
				<ul >
					<li onclick='fn_DetailInfo_List()'><a id="DetailInfo_List"  href='#SubInfo_List_contents'>출하검사결과</a></li>
					<li onclick='com_fn_SubInfo_DOC_List(this,vOrderNo)'><a id="SubInfo_DOC_List"  href='#SubInfo_List_Doc'>문서목록</a></li>
					<li onclick='pop_fn_BomList(this, "<%=JSPpage%>")'><a id="SubInfo_BomList"  href='#SubInfo_BOM'>배합(BOM)정보</a></li>
					<li onclick='pop_fn_ProcessCheckList(this, "<%=JSPpage%>")'><a id="SubInfo_checklist"  href='#SubInfo_check'>공정확인표</a></li>
				</ul>
				<div id="SubInfo_List_contents" ></div>
				<div id="SubInfo_List_Doc" ></div>
<!-- 				<div id="SubInfo_BOM" ></div> -->
				<div id="SubInfo_check"></div>
		  	</div>
		</div>
	</div>
</div> --%>