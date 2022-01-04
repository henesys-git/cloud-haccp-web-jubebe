<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="mes.client.comm.*" %>
<%@ page import="mes.client.guiComponents.*" %>
<%@ page import="mes.client.util.*" %>
<%@ page import="mes.client.conf.*" %>
<%
	String loginID = session.getAttribute("login_id").toString();
	if(loginID==null||loginID.equals("")){                            // id가 Null 이거나 없을 경우
		response.sendRedirect(Config.this_SERVER_path + "/Contents/index.jsp");    // 로그인 페이지로 리다이렉트 한다.
	}

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
 	  
 	
 	var vProject_name="";
 	var vProd_cd="";
 	var vProduct_name="";
 	var vLotNo="";
 	var vlot_count="";
 	var vProd_serial_no="";
 	var vCustName=""
 	
    var GV_PROCESS_MODIFY="";
    var GV_PROCESS_DELETE="";

	var popOpen;
    $(document).ready(function () {
    	new SetDate("dateFrom", -180);
    	new SetDate("dateTo", 0);
        
        GV_PROCESS_MODIFY 	="<%=GV_PROCESS_MODIFY%>";
        GV_PROCESS_DELETE 	="<%=GV_PROCESS_DELETE%>";
        

<%--    makeMenu("<%=htmlsideMenu%>"); --%>
        fn_MainSubMenuSelect("<%=sMenuTitle%>");
		$("#InfoContentTitle").html("주문목록(PO List)");
        
		fn_MainInfo_List(); 

	    $( function() {
	        $( "#tabs" ).tabs();
	    });	    

	    fn_tagProcess('<%=JSPpage%>');
	    
		$('#DetailInfo_List').on('click', function(){
			fn_DetailInfo_List();
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
    function fn_MainInfo_List() {
//         var custcode = $("#txt_cust_code").val().toString(); 
        var custcode = ""; 
        var from = $("#dateFrom").val();
        var to = $("#m_dateTo").val();
        $.ajax(
        {
            type: "POST",
            url: "<%=Config.this_SERVER_path%>/Contents/Business/M101/S101S030100.jsp",
            data: "custcode=" + custcode + "&From=" + from + "&To=" + to  + "&JSPpage=" + "<%=JSPpage%>",
            beforeSend: function () {
//                 $("#MainInfo_List_contents").children().remove();
            },
            success: function (html) {
                $("#MainInfo_List_contents").hide().html(html).fadeIn(100);
            },
            error: function (xhr, option, error) {

            }
        });
        
        $("#SubInfo_List_Doc").children().remove();
        $("#SubInfo_bom").children().remove();
        $("#SubInfo_List_contents").children().remove();
        $("#SubInfo_Process_check").children().remove();
    }

    //주문상세정보 
    function fn_DetailInfo_List() {    	
//         var custcode = $("#txt_cust_code").val().toString();
        var custcode = "";
        
        $.ajax(
        {
            type: "POST",
            url: "<%=Config.this_SERVER_path%>/Contents/Business/M101/S101S030110.jsp",
            data: "custcode=" + custcode + "&OrderNo=" + vOrderNo + "&LotNo=" + vLotNo ,
            beforeSend: function () {
//                 //$("#SubInfo_List_contents").children().remove();
            },
            success: function (html) {
	            $("#SubInfo_List_Doc").children().remove();
	            $("#SubInfo_bom").children().remove();
                $("#SubInfo_List_contents").hide().html(html).fadeIn(100);
            },
            error: function (xhr, option, error) {

            }
        });
    }
    
    //주문별 제품검사체크리스트 (PopUp)
    function pop_fn_Jumun_product_inspect_checklist_Insert(obj) {
    	if(vOrderNo.length < 1) {
    		heneSwal.warning('주문 정보를 선택하세요')
    		return false;
    	}
    	var modalContentUrl;
    	
    	modalContentUrl = "<%=Config.this_SERVER_path%>/Contents/Business/M101/S101S030131.jsp?OrderNo=" + vOrderNo 
        + "&Project_name="	+ vProject_name + "&Prod_serial_no=" + vProd_serial_no
        + "&Prod_cd=" 		+ vProd_cd 	+ "&Product_name="	+ vProduct_name
        + "&lotno=" 		+ vLotNo 	+ "&lot_count=" 	+ vlot_count;

		pop_fn_popUpScr(modalContentUrl, obj.innerText+"(S101S030131)", '80%', '85%');
     }
    
    function pop_fn_JumunDoc_Insert(obj) {
		if(vOrderNo.length < 1) {
			heneSawl.warning('PO List 하나를 선택하세요')
			return;
		}
    	var modalContentUrl;
    	modalContentUrl = "<%=Config.this_SERVER_path%>/Contents/Business/M101/S101S020121.jsp?OrderNo=" + vOrderNo 
    			+ "&jspPage=" + "<%=JSPpage%>" 
    			+ "&num_gubun=<%=GV_GET_NUM_PREFIX%>"
    			+ "&innerText=" + obj.innerText
    			+ "&LotNo=" + vLotNo
    			;

    	pop_fn_popUpScr(modalContentUrl, obj.innerText+"(S101S020121)", '550px', '1000px');
		return false;
     }


    function pop_fn_JumunBOM_Insert(obj) {
		if(vOrderNo.length < 1) {
			heneSwal.warning('PO List 하나를 선택하세요')
			return;
		}
    	var modalContentUrl;
    	modalContentUrl = "<%=Config.this_SERVER_path%>/Contents/Business/M101/S101S030111.jsp?OrderNo=" + vOrderNo 
    			+ "&jspPage=" + "<%=JSPpage%>"
//     			+ "&OrderDetailNo=" + vOrderDetailSeq
<%--     			+ "&num_gubun=" + "<%=GV_GET_NUM_PREFIX%>" --%>
    			+ "&Prod_cd=" + vProd_cd
    			+ "&Product_name=" + vProduct_name 
    			+ "&LotNo=" + vLotNo
    			;
    	pop_fn_popUpScr(modalContentUrl, obj.innerText+"(S101S030111)", '90%', '90%');
		return false;
     }
    //기술문서등록완료
    function pop_fn_Tech_Doc_Comlete(obj) {
		if(vOrderNo.length < 1){
			heneSwal.warning('PO List 하나를 선택하세요')
			return;
		}
		
    	var modalContentUrl;
    	modalContentUrl = "<%=Config.this_SERVER_path%>/Contents/Business/M101/S101S030122.jsp?OrderNo=" + vOrderNo 
// 			+ "&OrderDetail=" + vOrderDetailSeq
			+ "&jspPage=" + "<%=JSPpage%>"
			+ "&Product_name=" + vProduct_name
			+ "&custname=" + vCustName
			+ "&LotNo=" + vLotNo
			;
	    pop_fn_popUpScr(modalContentUrl, obj.innerText+"(S101S030122)", '100%', '40%');
    	
		return false;
     }   


    //주문 검토정보 (PopUp)
    function pop_Review_Confirm_Insert(obj) {
    	if(vOrderNo.length < 1) {
    		heneSwal.warning('PO List 하나를 선택하세요')
			return;
    	}
    	var mainKey = "order_no = '" + vOrderNo + "'";
    	var actionKey = "";  //inpect_no = '" + vOrderNo + "'"; 있으면 mainKey와 같은 방식으로 정의

    	fn_Process_Review_n_Confirm(obj, '<%=JSPpage%>',vOrderNo, vOrderDetailSeq, '<%=GV_PROCESS_NAME%>', mainKey, actionKey,'<%=GV_GET_NUM_PREFIX%>',"<%=prcStatusCheck.GV_PROCESS_GUBUN%>");
		return false;
     }
    
    </script>

    <div class="panel panel-default" style="margin-left:5px; margin-top:5px; margin-right:5px; margin-bottom:5px; width:100%">
        <!-- Default panel contents -->
        <div class="panel-heading" style="font-weight: bold" id="MenuTitle">여기에메뉴타이틀</div>
        <div class="panel-body">
            <div>
	            <button data-author="mainBtn" type="button"  id="mainButton"  class="btn btn-primary active"
	            			style="width: auto; float: left; ">주문납품관리-주문정보</button>
	            			
	            <button data-author="insert" type="button" onclick="pop_fn_JumunDoc_Insert(this)" id="insert" class="btn btn-default" 
	            			style="width: auto; float: left; margin-left:30px;">문서등록</button>
	            			
	            <button data-author="update" type="button" onclick="pop_fn_JumunBOM_Insert(this)" id="update" class="btn btn-default" 
	            			style="width: auto; float: left; margin-left:3px;">주문별 배합(BOM)등록</button>
<!-- 	            <button data-author="insert" type="button" onclick="pop_fn_Jumun_process_checklist_Insert(this)" id="insert" class="btn btn-default"  -->
<!-- 	            			style="width: auto; float: left; margin-left:3px;">주문별 공정확인표등록</button> -->
	            <button data-author="insert" type="button" onclick="pop_fn_Jumun_product_inspect_checklist_Insert(this)" id="insert" class="btn btn-default" 
	            			style="width: auto; float: left; margin-left:3px;">주문별 제품검사체크리스트등록</button>
<!-- 	            <button data-author="delete" type="button" onclick="pop_fn_Tech_Doc_Comlete(this)" id="delete" class="btn btn-warning"  -->
<!-- 	            			style="width: auto; float: left;  margin-left:30px;">기술문서등록완료</button> -->
	            
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
                            	<td style='width:5%; vertical-align: middle'>수행일자 :</td>
                                <td style='width:6%;  vertical-align: middle'>
                                    <input type="text" data-date-format="yyyy-mm-dd" id="dateFrom" class="form-control" />
                                </td>
                                <td style='width:1%;vertical-align: middle'>
                                    &nbsp;~&nbsp;
                                </td>
                                <td style='width:6%; vertical-align: middle'>
                                    <input type="text" data-date-format="yyyy-mm-dd" id="m_dateTo" class="form-control" />
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
	                <div style="clear:both" id="MainInfo_List_contents" >
	                </div>
	 
                </div>
                
	                <div id="tabs">
			         	<ul >
			                <li ><a id="DetailInfo_List"  href=#SubInfo_List_contents>주문상세정보</a></li>
<!-- 			                <li onclick='fn_De__tailInfo_List()'><a id="DetailInfo_List"  href=#SubInfo_List_contents>주문상세정보</a></li> -->
			                <li onclick='com_fn_SubInfo_DOC_List( this,vOrderNo)'><a id="SubInfo_DOC_List"  href='#SubInfo_List_contents'>문서목록</a></li>
			                <li onclick='pop_fn_BomList( this, "<%=JSPpage%>")'><a id="SubInfo_BomList"  href='#SubInfo_bom'>배합(BOM)정보</a></li>
<%-- 			                <li onclick='pop_fn_ProcessCheckList( this, "<%=JSPpage%>")'><a id="Subinfo_Process_checkList"  href='#Subinfo_Process_check'>주문별 공정확인표</a></li> --%>
			                <li onclick='pop_fn_ProducCheckList( this, "<%=JSPpage%>")'><a id="Subinfo_prod_checkList"  href='#Subinfo_Process_check'>주문별 제품검사체크리스트</a></li>
			                <li id="Total_Info"></li>
			            </ul>
	                    <div id="SubInfo_List_Doc" ></div>
	                    <div id="SubInfo_bom" ></div>
	                    <div id="SubInfo_List_contents"></div>
	                    <div id="Subinfo_Process_check"></div>
	                </div>
	        	</div>
            </div>
        </div>
    
