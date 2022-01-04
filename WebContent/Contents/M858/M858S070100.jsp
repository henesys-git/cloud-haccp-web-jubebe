<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="mes.client.comm.*" %>
<%@ page import="mes.client.common.*" %>
<%@ page import="mes.client.guiComponents.*" %>
<%@ page import="mes.client.util.*" %>
<%@ page import="mes.client.conf.*" %>
<%
	String loginID = session.getAttribute("login_id").toString();
	String member_key = session.getAttribute("member_key").toString();
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
	String GV_GET_NUM_PREFIX	= prcStatusCheck.GV_PROCESS_NUMBER_GUBUN;

	
    Vector optCode =  null;
    Vector optName =  null;
    Vector partgubun_midVector = PartListComboData.getPartMidGubunDataAll("",member_key);
    Vector partgubun_bigVector = PartListComboData.getPartBigGubunDataAll(member_key);

%>  

<script type="text/javascript"> 
	var vPartgubun_big="";
	var vPartgubun_mid="";
 	var vPart_cd="";
 	var vPart_cd_rev="";
 	var vPart_name="";
 	
	var vmachineno="";
	var vrakes="";
	var vplate="";
	var vcolm="";
	var vio_amt="";
	var vpre_amt="";
	var vpost_amt="";	

	var lvmachineno="";
	var lvrakes="";
	var lvplate="";
	var lvcolm="";
	var lvio_amt="";
	var lvpre_amt="";
	var lvpost_amt="";	
	var	vipgo_no="";
	var vio_seqno="";

	var sc_width="";
	var vTableS202S120200;
	var TableS202S120200_Row_Index;
	var TableS202S120200_info;
	var TableS202S120200_Row_Count;
	
    $(document).ready(function () {	
        fn_MainSubMenuSelect("<%=sMenuTitle%>");
        
		$("#InfoContentTitle").html("완제품 목록");
		fn_MainInfo_List();	
	    
	    //탭 클릭시 처리하는 Function
	    //$( function() {$( "#tabs" ).tabs();});

        fn_tagProcess('<%=JSPpage%>');;

	    $("#partgubun_big").on("change", function(){
	    	vPartgubun_big = $(this).val();
	    	vPartgubun_mid = $("#partgubun_mid").val();
	    	fn_MainInfo_List();
	    });

	    $("#partgubun_mid").on("change", function(){
	    	vPartgubun_big = $("#partgubun_big").val();
	    	vPartgubun_mid = $(this).val();
	    	fn_MainInfo_List();
	    });
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
    }
    
    // 
    function fn_MainInfo_List() {
		if(vPartgubun_big=="ALL")
			vPartgubun_big="";
		if(vPartgubun_mid=="ALL")
			vPartgubun_mid="";
		
        var today = new Date();
        var fromday = new Date();
        fromday.setDate(today.getDate() - 170);
        
        $.ajax(
        {
            type: "POST",
            url: "<%=Config.this_SERVER_path%>/Contents/Business/M202/S202S120100.jsp", 
            data: "partgubun_big="+ vPartgubun_big +  "&partgubun_mid="+ vPartgubun_mid ,
<%--             + "&From=" + fromday.format("yyyy-MM-dd") + "&To=" + today.format("yyyy-MM-dd") + "&JSPpage=" + '<%=JSPpage%>' + "&custcode=" , --%>
            beforeSend: function () {
                $("#MainInfo_List_contents").children().remove();
            },
            success: function (html) {
//                 $("#MainInfo_List_contents").hide().html(html).fadeIn(100);
                $("#MainInfo_List_contents").hide().html(html).fadeIn(100);
            },
            error: function (xhr, option, error) {

            }
        });
    }
        
	function fn_DetailInfo_List() {
// 		if(vPart_cd.length < 1){
<%-- 			$('#alertNote').html(obj.innerText + " <BR> <%=JSPpage%>!!! <BR><BR> 주문정보를 선택하세요  !!!"); --%>
// 			$('#modalalert').show();
// 			return false;
// 		}
		
    	$.ajax(
    	    {
    	        type: "POST",
    	        url: "<%=Config.this_SERVER_path%>/Contents/Business/M202/S202S120110.jsp",
    	        data: "order_no=" + vOrderNo +"&part_cd=" +vPart_cd +"&part_cd_rev=" + vPart_cd_rev ,
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
	
	function fn_ImportInfo_List() {
		
		$.ajax(
	    	    {
	    	        type: "POST",
	    	        url: "<%=Config.this_SERVER_path%>/Contents/Business/M202/S202S120210.jsp",
	    	        data: "order_no=" + vOrderNo +"&part_cd=" +vPart_cd +"&part_cd_rev="+vPart_cd_rev ,
	    	        beforeSend: function () {
//	     	            //$("#SubInfo_List_contents").children().remove();
	    	        },
	    	        success: function (html) {
	    	            $("#SubInfo_List_contents").hide().html(html).fadeIn(100);
	    	        },
	    	        error: function (xhr, option, error) {
	    	        }
	    	    });
			return;
	}	
	
//  바코드 출력
    function fn_Barcode_Pront(obj) {
    	var modalContentUrl;

		alert("vPart_cd===" + vPart_cd);
//     	if(vPart_cd.length < 1){
<%-- 			$('#alertNote').html(obj.innerText + " <BR> <%=JSPpage%>!!! <BR><BR> 원부자재정보를 선택하세요  !!!"); --%>
// 			$('#modalalert').show();
// 			return false;
// 		}
//    alert(barcode_print_ip);
		$.ajax(
	    	    {
	    	        type: "POST",
	    	        url: "http://" + sub_server_ip +":8080/STANDARD_MES/Contents/Business/M202/S202S120150.jsp", //클라우드에서 사설아이피로 접속이 불가능하여 CORS를 적용하여 로칼보조서버를 호출함
	    	        data: "part_cd=" + vPart_cd  + "&barcode_print_ip=" + barcode_print_ip,
	    	        beforeSend: function () {
//	     	            //$("#SubInfo_List_contents").children().remove();
	    	        },
	    	        success: function (html) {
	    	        	
	    	        	$('#alertNote').html( " <BR> <%=JSPpage%>!!! <BR><BR> 바코드 출력을 " + html + "했습니다 !!!");
	    				$('#modalalert').show();
	    				return false;
	    				
	    	        },
	    	        error: function (xhr, option, error) {
	    	        }
	    	    });
			return;
     } 
 	
    //입고 등록
    function pop_fn_PartIpgo_Insert(obj) {
    	var modalContentUrl;
    	
    	if(vPart_cd.length < 1){
			$('#alertNote').html(obj.innerText + " <BR> <%=JSPpage%>!!! <BR><BR> 원부자재을 선택하세요  !!!");
			$('#modalalert').show();
			return false;
		}
    	
    	modalContentUrl = "<%=Config.this_SERVER_path%>/Contents/Business/M202/S202S120101.jsp?part_cd=" + vPart_cd
			+ "&part_cd_rev="+ vPart_cd_rev 
    		+ "&order_no=" + vOrderNo
			+ "&LotNo=" +vLotNo
    		+ "&part_name="+ vPart_name    		
    		+ "&machineno="+ vmachineno
    		+ "&rakes="+ vrakes
    		+ "&plate="+ vplate
    		+ "&colm="+ vcolm
    		+ "&io_amt="+ vio_amt
    		+ "&pre_amt="+ vpre_amt
    		+ "&post_amt="+ vpost_amt
    		+ "&partgubun_big="+ vPartgubun_big +  "&partgubun_mid="+ vPartgubun_mid 
			+ "&jspPage=" + "<%=JSPpage%>" ;
		if(vmachineno=="") sc_width="1360"
		else  sc_width="1116"
    	pop_fn_popUpScr(modalContentUrl, obj.innerText+"(S202S120101)", "570px", sc_width+"px");
     }    
    
     //입고 보정
    function pop_fn_PartIpgo_Update(obj) {
    	if(vPart_cd.length < 1){
			$('#alertNote').html(obj.innerText + " <BR> <%=JSPpage%>!!! <BR><BR> 원부자재을 선택하세요  !!!");
			$('#modalalert').show();
			return false;
		}
    	 
    	var modalContentUrl;

    	TableS202S120200_info = vTableS202S120200.page.info();
    	TableS202S120200_Row_Count = TableS202S120200_info.recordsTotal;
    	
    			
    	modalContentUrl = "<%=Config.this_SERVER_path%>/Contents/Business/M202/S202S120102.jsp?part_cd=" + vPart_cd
    			//tbi_part_storage 내용
		+ "&part_cd_rev="+ vPart_cd_rev 
		+ "&part_name="	+ vPart_name		
		+ "&machineno="	+ vmachineno
		+ "&rakes="		+ vrakes
		+ "&plate="		+ vplate
		+ "&colm="		+ vcolm
		+ "&io_amt="	+ vio_amt
		+ "&pre_amt="	+ vpre_amt
		+ "&post_amt="	+ vpost_amt
		
		//선택된 tbi_part_ipgo의 내용 이게 변경 될 가능성, 창고위치, 입출고 수량 => tbi_part_storage에 재 계산하여 Update해야함
		+ "&OrderNo=" 	+ vOrderNo
		+ "&LotNo=" 	+ vLotNo
		+ "&ipgo_no="	+ vipgo_no 
		+ "&io_seqno="	+ vio_seqno 
		+ "&lmachineno="+ lvmachineno
		+ "&lrakes="	+ lvrakes
		+ "&lplate="	+ lvplate
		+ "&lcolm="		+ lvcolm
		+ "&lio_amt="	+ lvio_amt
		+ "&lpre_amt="	+ lvpre_amt
		+ "&lpost_amt="	+ lvpost_amt
		
		+ "&partgubun_big="	+ vPartgubun_big 
		+ "&partgubun_mid="	+ vPartgubun_mid 
		+ "&jspPage=" + "<%=JSPpage%>" ;

		if(vmachineno=="") sc_width="1360"
		else  sc_width="1116"
    	pop_fn_popUpScr(modalContentUrl, obj.innerText+"(S202S120102) 재고조정", "570px", sc_width+"px");
     } 

    //입고 삭제
    function pop_fn_PartIpgo_Delete(obj) {
    	var modalContentUrl;
    	if(vPart_cd.length < 1){
			$('#alertNote').html(obj.innerText + " <BR> <%=JSPpage%>!!! <BR><BR> 주문정보를 선택하세요  !!!");
			$('#modalalert').show();
			return false;
		}
    	
    	modalContentUrl = "<%=Config.this_SERVER_path%>/Contents/Business/M202/S202S120103.jsp?part_cd=" + vPart_cd
		+ "&part_cd_rev=" + vPart_cd_rev
    	+ "&jspPage=" + "<%=JSPpage%>" 
// 		+"&part_cd_rev="+ vPart_cd_rev; 
    	pop_fn_popUpScr(modalContentUrl, obj.innerText+"(S202S120103)", "80%", "90%");
     }
    
  //출고 등록
    function pop_fn_PartChulgo_Insert(obj) {
    	var modalContentUrl;
    	
    	if(vPart_cd.length < 1){
			$('#alertNote').html(obj.innerText + " <BR> <%=JSPpage%>!!! <BR><BR> 원부자재을 선택하세요  !!!");
			$('#modalalert').show();
			return false;
		}
    	
    	modalContentUrl = "<%=Config.this_SERVER_path%>/Contents/Business/M202/S202S120201.jsp?part_cd=" + vPart_cd
			+ "&part_cd_rev="+ vPart_cd_rev 
			+ "&order_no=" + vOrderNo
			+ "&LotNo=" +vLotNo
			+ "&part_name="+ vPart_name    		
			+ "&machineno="+ vmachineno
			+ "&rakes="+ vrakes
			+ "&plate="+ vplate
			+ "&colm="+ vcolm
			+ "&io_amt="+ vio_amt
			+ "&pre_amt="+ vpre_amt
			+ "&post_amt="+ vpost_amt
			+ "&partgubun_big="+ vPartgubun_big +  "&partgubun_mid="+ vPartgubun_mid 
			+ "&jspPage=" + "<%=JSPpage%>" ;

			if(vmachineno=="") sc_width="1360"
			else  sc_width="1116"
			
    	pop_fn_popUpScr(modalContentUrl, obj.innerText+"(S202S120201)", "570px", sc_width+"px");
     }    
    
     //출고 수정
    function pop_fn_PartChulgo_Update(obj) {
    	var modalContentUrl;
    	
    	if(vPart_cd.length < 1){
			$('#alertNote').html(obj.innerText + " <BR> <%=JSPpage%>!!! <BR><BR> 주문정보를 선택하세요  !!!");
			$('#modalalert').show();
			return false;
		}
    	
    	modalContentUrl = "<%=Config.this_SERVER_path%>/Contents/Business/M202/S202S120202.jsp?part_cd=" + vPart_cd
		+ "&jspPage=" + "<%=JSPpage%>" 
		;
    	pop_fn_popUpScr(modalContentUrl, obj.innerText+"(S202S120202)", "80%", "90%");
     } 

    //출고 삭제
    function pop_fn_PartChulgo_Delete(obj) {
    	var modalContentUrl;
    	
    	if(vPart_cd.length < 1){
			$('#alertNote').html(obj.innerText + " <BR> <%=JSPpage%>!!! <BR><BR> 주문정보를 선택하세요  !!!");
			$('#modalalert').show();
			return false;
		}
    	
    	modalContentUrl = "<%=Config.this_SERVER_path%>/Contents/Business/M202/S202S120203.jsp?part_cd=" + vPart_cd
		+ "&part_cd_rev=" + vPart_cd_rev
    	+ "&jspPage=" + "<%=JSPpage%>" 
// 		+"&part_cd_rev="+ vPart_cd_rev; 
    	pop_fn_popUpScr(modalContentUrl, obj.innerText+"(S202S120203)", "80%", "90%");
     }
   
    
    //
    function pop_fn_PartIpgo_Comlete(obj) {
    	
    	if(vPart_cd.length < 1){
			$('#alertNote').html(obj.innerText + " <BR> <%=JSPpage%>!!! <BR><BR> 주문정보를 선택하세요  !!!");
			$('#modalalert').show();
			return false;
		}
    	if(part_cd_rev.length < 1){
			$('#alertNote').html(obj.innerText + " <BR> <%=JSPpage%>!!! <BR><BR> 주문정보를 선택하세요  !!!");
			$('#modalalert').show();
			return false;
		}

		var modalContentUrl;
		modalContentUrl = "<%=Config.this_SERVER_path%>/Contents/Business/M202/S202S120122.jsp?OrderNo=" + vOrderNo
		+ "&jspPage=" + "<%=JSPpage%>" 
		+ "&part_cd=" + part_cd 
		+"&part_cd_rev="+ part_cd_rev;
		pop_fn_popUpScr(modalContentUrl, obj.innerText+"(S202S120122)", "80%", "90%");
		return false;
     }
    </script>
    <div class="panel panel-default" style="margin-left:5px; margin-top:5px; margin-right:5px; margin-bottom:5px; width:100%" >
        <!-- Default panel contents -->
        <div class="panel-heading" style="font-weight: bold" id="MenuTitle">여기에메뉴타이틀</div>
        <div class="panel-body" >
        
        	<div>
	            <button data-author="mainBtn" type="button"  id="mainButton"  class="btn btn-primary active"
	            			style="width: auto; float: left; ">발주재고관리-자재입출고관리</button>
	            <button data-author="insert" type="button" onclick="pop_fn_PartIpgo_Insert(this)" id="insert" class="btn btn-default" 
	            			style="width: auto;float: left; margin-left:30px;">자재입고등록</button>
<!-- 	            <button data-author="update" type="button" onclick="pop_fn_PartIpgo_Update(this)" id="update" class="btn btn-outline-success"  -->
<!-- 	            			style="width: auto;float: left; margin-left:3px;">자재입고수정</button>   -->
<!-- 	            <button data-author="delete" type="button" onclick="pop_fn_PartIpgo_Delete(this)" id="delete" class="btn btn-danger"  -->
<!-- 	            			style="width: auto; float: left; margin-left:3px;">자재입고삭제</button> -->
	            <button data-author="insert" type="button" onclick="pop_fn_PartChulgo_Insert(this)" id="insert" class="btn btn-default" 
	            			style="width: auto;float: left; margin-left:5px;">자재출고등록</button>
<!-- 	             <button data-author="update" type="button" onclick="pop_fn_PartChulgo_Update(this)" id="update" class="btn btn-outline-success"  -->
<!-- 	            			style="width: auto;float: left; margin-left:3px;">자재출고수정</button>   -->
<!-- 	            <button data-author="delete" type="button" onclick="pop_fn_PartChulgo_Delete(this)" id="delete" class="btn btn-danger"  -->
<!-- 	            			style="width: auto; float: left; margin-left:3px;">자재출고삭제</button> -->

	            <button data-author="update" type="button" onclick="pop_fn_PartIpgo_Update(this)" id="update" class="btn btn-outline-success" 
	            			style="width: auto;float: left; margin-left:30px;">자재입출고 보정</button>  
	             <button data-author="update" type="button" onclick="fn_Barcode_Pront(this)" id="update" class="btn btn-outline-success" 
	            			style="width: auto;float: left; margin-left:30px;">바코드출력</button>  
<!-- 	            <label style="width: 100px; clear:both; margin-left:3px;"></label> -->
            </div>
            <p style="width: auto; clear:both;">
            </p>

            <div class="panel panel-default">
                <!-- Default panel contents -->
<!--                 <div class="panel-heading" style="font-size:16px; font-weight: bold"  id="InfoContentTitle">자재입고정보</div> -->
                <div class="panel-body">
                    <div style="width: 100%; float: left">
						<table style="width: 100%; text-align:left; background-color:#f5f5f5;">
							<tr>
	                           	<td style='width:10%; vertical-align: middle;'>
	                           		<div class="panel-heading" style="font-size:16px; font-weight: bold"  id="InfoContentTitle"></div>
	                           	</td>
	                           	<td style='width:6%; vertical-align: middle;text-align:right;'>원부자재 대분류</td>
	                            <td style='width:14%;vertical-align: middle'>
		                        	<select class="form-control" id="partgubun_big" >
		                                <%	optCode =  (Vector)partgubun_bigVector.get(0);%>
		                                <%	optName =  (Vector)partgubun_bigVector.get(1);%>
		                                <%for(int i=0; i<optName.size();i++){ %>
										  <option value='<%=optCode.get(i).toString()%>'><%=optName.get(i).toString()%></option>
										<%} %>
									</select>
								</td>
	                            <td style='width:2%; vertical-align: middle;'></td>  
	                           	<td style='width:6%; vertical-align: middle;text-align:right;'>원부자재 중분류</td>
	                            <td style='width:14%;vertical-align: middle'>
		                        	<select class="form-control" id="partgubun_mid" >
		                                <%	optCode =  (Vector)partgubun_midVector.get(0);%>
		                                <%	optName =  (Vector)partgubun_midVector.get(1);%>
		                                <%for(int i=0; i<optName.size();i++){ %>
										  <option value='<%=optCode.get(i).toString()%>'><%=optName.get(i).toString()%></option>
										<%} %>
									</select>
								</td>	                           	
								<td style='width:48%; vertical-align: middle;'></td>
							</tr>
						</table>
                        
                    </div>
 					<div  style="clear:both; height:10px ;border-top: 1px solid #D2D6Df;" >
                    </div>
                    <div id="MainInfo_List_contents"  style="clear:both; " >
                    </div>
                </div>
                <div id="tabs">
		         	<ul >
<!-- 		         	<li onclick='fn_Import_Inspect_List()'><a id="ImportInfo_List"  href=#SubInfo_List_contents>자재출고상세정보</a></li> -->
		                <li onclick='fn_DetailInfo_List()'><a id="DetailInfo_List"  href=#SubInfo_List_contents>자재입출고상세내역</a></li>
<!-- 		                <li onclick='fn_ImportInfo_List()'><a id="ImportInfo_List"  href=#SubInfo_List_contents>자재출고상세정보</a></li> -->
<!-- 			         	<li onclick='pop_fn_BomList(this, "<%=JSPpage%>")'><a id="SubInfo_BomList"  href='#ImportInspect_Request'>자료목록(BOM)</a></li> -->
		            </ul>
                    <div id="SubInfo_List_Doc" ></div>
                    <div id="ImportInspect_Request" ></div>
                    <div id="SubInfo_List_contents"></div>
                </div>
       		</div>
		</div>
    </div>