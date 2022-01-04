<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="mes.client.comm.*" %>
<%@ page import="mes.client.guiComponents.*" %>
<%@ page import="mes.client.util.*" %>
<%@ page import="mes.client.conf.*" %>
<%  

/* 납품관리(M101S040100.jsp) */
	String loginID = session.getAttribute("login_id").toString();
	if(loginID==null||loginID.equals("")){                            // id가 Null 이거나 없을 경우
		response.sendRedirect(Config.this_SERVER_path + "/Contents/index.jsp");    // 로그인 페이지로 리다이렉트 한다.
	}

	String sMenuTitle = request.getParameter("MenuTitle").toString();
	String sProgramId = request.getParameter("programId").toString();
	String sHeadmenuID= request.getParameter("HeadmenuID").toString();
	String sHeadmenuName= request.getParameter("HeadmenuName").toString();
	
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
 	  
 	
	// 캐시 비적용
	<%-- <%
	response.setHeader("Cache-Control","no-cache");
	response.setHeader("Pragma","no-cache");
	response.setDateHeader("Expires",0);
	%> --%>
 
 	var vProd_serial_no="";
 	var vOrder_cnt =""; 
 	var vCustCode = ""; 
 	var vCustName = ""; 
 	
	var vChulhaNo = "";
	var vChulhaSeq = "";
 	
    var GV_PROCESS_MODIFY="";
    var GV_PROCESS_DELETE="";
	
// 	{"기종", "제품모델", "제품코드", "제품일련번호", "주문대수", "납품일자", "고객요청내용", "특이사항", "기종코드", "주문세부번호" };
    $(document).ready(function () {
    	new SetDate("dateFrom", -180);
    	new SetDate("dateTo", 0);
        
        GV_PROCESS_MODIFY 	="<%=GV_PROCESS_MODIFY%>";
        GV_PROCESS_DELETE 	="<%=GV_PROCESS_DELETE%>";
        
        fn_MainSubMenuSelect("<%=sMenuTitle%>");
		$("#InfoContentTitle").html("주문목록(PO List)");

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
    }
        
    //주문기본정보
    function fn_MainInfo_List() {
//         var custcode = $("#txt_cust_code").val().toString();
        var custcode = "";
        var from = $("#dateFrom").val();
        var to = $("#dateTo").val();
        $.ajax(
        {
            type: "POST",
            url: "<%=Config.this_SERVER_path%>/Contents/Business/M101/S101S020100.jsp",
            data: "custcode=" + custcode + "&From=" + from + "&To=" + to  + "&JSPpage=" + "<%=JSPpage%>",
<%--             url: "<%=Config.this_SERVER_path%>/Contents/Business/M101/S101S040100.jsp", --%>
<%--             data: "custcode=" + custcode + "&From=" + from + "&To=" + to + "&jspPageName=" + "<%=JSPpage%>" , --%>
            beforeSend: function () {
                $("#MainInfo_List_contents").children().remove();
            },
            success: function (html) {
                $("#MainInfo_List_contents").hide().html(html).fadeIn(100);
            },
            error: function (xhr, option, error) {

            }
        });
        
        $("#SubInfo_List_contents").children().remove();
        $("#SubInfo_List_Doc").children().remove();
        $("#SubInfo_Trading").children().remove();
    }

    //주문상세정보 
    function fn_DetailInfo_List() {    	
//         var custcode = $("#txt_cust_code").val().toString(); 
        var custcode = "";
        
        $.ajax(
        {
            type: "POST",
            url: "<%=Config.this_SERVER_path%>/Contents/Business/M101/S101S040110.jsp",
            data: "OrderNo=" + vOrderNo + "&LotNo=" + vLotNo,
            beforeSend: function () {
                //$("#SubInfo_List_contents").children().remove();
            },
            success: function (html) {
                $("#SubInfo_List_contents").hide().html(html).fadeIn(100);
            },
            error: function (xhr, option, error) {

            }
        });
    }
    
  //거래명세서 
    function fn_TradingInfo_List() {    	
    	if(vOrderNo.length < 1) {
    		heneSwal.warning('주문 정보를 선택하세요')
			return false;
		}

        $.ajax(
        {
            type: "POST",
            url: "<%=Config.this_SERVER_path%>/Contents/Business/M101/S101S040146.jsp",
            data: "OrderNo=" + vOrderNo + "&LotNo=" + vLotNo,
            success: function (html) {
                $("#SubInfo_List_contents").hide().html(html).fadeIn(100);
            },
            error: function (xhr, option, error) {

            }
        });
    }
    
    //납품정보 (PopUp)
    function pop_fn_JumunInfo_Insert(obj) {
    	if(vOrderNo.length < 1) {
    		heneSwal.warning('주문 정보를 선택하세요')
			return false;
		}
    	var modalContentUrl;
    	modalContentUrl = "<%=Config.this_SERVER_path%>/Contents/Business/M101/S101S040101.jsp?jspPage=" + "<%=JSPpage%>"
						+ "&num_gubun=<%=GV_GET_NUM_PREFIX%>" 
						+ "&OrderNo=" + vOrderNo 
						 + "&LotNo=" + vLotNo
						;
    	
		modalFramePopup.setTitle(obj.innerText);
		pop_fn_popUpScr(modalContentUrl, obj.innerText+"(S101S040101)", "80%", "90%");
		return false;
     }

    function pop_fn_JumunInfo_Update(obj) {    	
		if(vChulhaNo.length < 1) {
			heneSwal.warning('거래명세서에서 납품 정보를 선택하세요')
			return false;
		}
		
    	var modalContentUrl = "<%=Config.this_SERVER_path%>/Contents/Business/M101/S101S040102.jsp?OrderNo=" + vOrderNo 
    						+ "&ChulhaNo=" + vChulhaNo
         					+ "&jspPage=" + "<%=JSPpage%>"
         					 + "&LotNo=" + vLotNo
         					;
    	
		modalFramePopup.setTitle(obj.innerText);
		pop_fn_popUpScr(modalContentUrl, obj.innerText+"(S101S040102)", "80%", "90%");
		return false;
    }


    function pop_fn_JumunInfo_Delete(obj) {
    	if(vChulhaNo.length < 1) {
			heneSwal.warning('거래명세서에서 납품 정보를 선택하세요')
			return false;
		}
    	
    	var modalContentUrl = "<%=Config.this_SERVER_path%>/Contents/Business/M101/S101S040103.jsp?OrderNo=" + vOrderNo 
							+ "&ChulhaNo=" + vChulhaNo
							+ "&jspPage=" + "<%=JSPpage%>"
							 + "&LotNo=" + vLotNo
							;
    	
		modalFramePopup.setTitle(obj.innerText);
		pop_fn_popUpScr(modalContentUrl, obj.innerText+"(S101S040103)", "80%", "90%");
		return false;
    }
    
    function pop_fn_JumunDoc_Insert(obj) {
		if(vOrderNo.length < 1) {
			heneSwal.warning('PO List 하나를 선택하세요')
			return;
		}
    	var modalContentUrl;
    	modalContentUrl = "<%=Config.this_SERVER_path%>/Contents/Business/M101/S101S020121.jsp?OrderNo=" + vOrderNo 
    			+ "&jspPage=" + "<%=JSPpage%>" 
    			+ "&num_gubun=<%=GV_GET_NUM_PREFIX%>"
    			+ "&LotNo=" + vLotNo
    			;
    	
		modalFramePopup.setTitle(obj.innerText);
		pop_fn_popUpScr(modalContentUrl, obj.innerText+"(S101S020121)", "550px", "1000px");
		return false;
     }
    
    //납품정보등록완료
	function pop_fn_JumunInfo_Comlete(obj) {
		if(vOrderNo.length < 1){
			heneSwal.warning('주문 정보를 선택하세요')
			return false;
		}
    	var modalContentUrl = "<%=Config.this_SERVER_path%>/Contents/Business/M101/S101S040122.jsp?OrderNo=" + vOrderNo 
							+ "&jspPage=" + "<%=JSPpage%>"
							 + "&LotNo=" + vLotNo
							;

		pop_fn_popUpScr(modalContentUrl, obj.innerText+"(S101S040122)", '80%', '90%');
		return false;
     }
    

    </script>

	<!-- 캐시 비적용 -->
    <meta http-equiv="Cache-Control" content="no-cache"/>
	<meta http-equiv="Expires" content="0"/>
	<meta http-equiv="Pragma" content="no-cache"/>

    <div class="panel panel-default" style="margin-left:5px; margin-top:5px; margin-right:5px; margin-bottom:5px; width:100%">
        <!-- Default panel contents -->
        <div class="panel-heading" style="font-weight: bold" id="MenuTitle">여기에메뉴타이틀</div>
        <div class="panel-body">
            <div>
	            <button data-author="mainBtn" type="button"  id="mainButton"  class="btn btn-primary active"
	            			style="width: auto; float: left; ">주문납품관리-주문정보</button>
	            <button data-author="insert" type="button" onclick="pop_fn_JumunInfo_Insert(this)" id="insert" class="btn btn-default" 
	            			style="width: auto;float: left; margin-left:30px;">납품정보등록</button>
	            <button data-author="insert" type="button" onclick="pop_fn_JumunDoc_Insert(this)" id="insert" class="btn btn-default" 
	            			style="width: auto;float: left; margin-left:3px;">문서등록</button>
	            <button data-author="update" type="button" onclick="pop_fn_JumunInfo_Update(this)" id="update" class="btn btn-outline-success" 
	            			style="width: auto; float: left; margin-left:3px;">납품정보수정</button>
	            <button data-author="delete" type="button" onclick="pop_fn_JumunInfo_Delete(this)" id="delete" class="btn btn-danger" 
	            			style="width: auto; clear:both;  margin-left:3px;">납품정보삭제</button>
<!-- 	            <button data-author="update" type="button" onclick="pop_fn_JumunInfo_Comlete(this)" id="update" class="btn btn-warning"  -->
<!-- 	            			style="width: auto; clear:both;  margin-left:3px;">납품정보등록완료</button> -->
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
                    <!-- Table --> 					
 					<div  style="clear:both; height:10px ;border-top: 1px solid #D2D6Df;" >
                    </div>
                    <div style="clear:both" id="MainInfo_List_contents" >
                    </div>
                </div>
                
	                <div id="tabs">
			         	<ul >
			                <li onclick='fn_DetailInfo_List()'><a id="DetailInfo_List"  href=#SubInfo_List_contents>주문상세정보</a></li>
			                <li onclick='com_fn_SubInfo_DOC_List( this,vOrderNo)'><a id="SubInfo_DOC_List"  href='#SubInfo_List_contents'>문서목록</a></li>
 			                <li onclick='fn_TradingInfo_List()'><a id="SubInfo_TradingList"  href='#SubInfo_List_contents'>거래명세서</a></li>
<!-- 			                <li onclick='pop_fn_ProcessCheckList(this, "<%=JSPpage%>")'><a id="Subinfo_Process_checkList"  href='#Subinfo_Process_check'>공정확인표</a></li> -->
			            </ul>
	                    <div id="SubInfo_List_contents"></div>
	                    <div id="SubInfo_List_Doc" ></div>
	                    <div id="SubInfo_Trading" ></div>
<!-- 	                    <div id="Subinfo_Process_check"></div> -->
	                </div>
	        	
            </div>
        </div>
    </div>
