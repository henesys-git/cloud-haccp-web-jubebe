<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="mes.client.comm.*" %>
<%@ page import="mes.client.common.*" %>
<%@ page import="mes.client.guiComponents.*" %>
<%@ page import="mes.client.util.*" %>
<%@ page import="mes.client.conf.*" %>
<%  	
/* 
외부문서발송(M606S100100.jsp)
 */
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
	
	CurrentPage jspPageName = new CurrentPage(request.getRequestURI());
	String JSPpage = jspPageName.GetJSP_FileName();
	ProcesStatusCheck prcStatusCheck = new ProcesStatusCheck(JSPpage+"|"+"ODPROCS"+"|");

	Get_Program_button_Autho prg_autho = new Get_Program_button_Autho(loginID,sProgramId);	
	
	String GV_PROCESS_MODIFY	= prcStatusCheck.GV_PROCESS_MODIFY;
	String GV_PROCESS_DELETE	= prcStatusCheck.GV_PROCESS_DELETE;
	String GV_GET_NUM_PREFIX = prcStatusCheck.GV_PROCESS_NUMBER_GUBUN;
	
	Vector optCode =  null;
    Vector optName =  null;
	Vector DocGubunVector = CommonData.getDocGubunCDAll(member_key);
// 	Vector midGubun = CommonData.getMidClassCdDataAll("GPR02");
%>

 <script type="text/javascript">
 	var vDocGubun = "";  
 	var vRegNo		= "";
 	var vRevisionNo		= "";
 	var vDocNo		= "";
    var GV_PROCESS_MODIFY="";
    var GV_PROCESS_DELETE="";

	
    $(document).ready(function () {        
        GV_PROCESS_MODIFY 	="<%=GV_PROCESS_MODIFY%>";
        GV_PROCESS_DELETE 	="<%=GV_PROCESS_DELETE%>";
        
        fn_MainSubMenuSelect("<%=sMenuTitle%>");
		$("#InfoContentTitle").html("등록문서정보");

    	fn_MainInfo_List();
        
	    $("#select_DocGubunCode").on("change", function(){
	    	vDocGubun = $(this).val();
	        fn_CheckBox_Chaned();
	    });

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



    function fn_LoadSubPage() {
        fn_clearList();
        fn_MainInfo_List();
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
    }
    
	function fn_CheckBox_Chaned(){	    
		var tr = $($("TableS606S100100 tr")[0]);
		var td = tr.children();

// 		var trNum = $(obj).closest('tr').prevAll().length;//현재 클릭한 TR의 순서 return
		$("input[id='checkbox1']").prop("checked", false);
		$($("input[id='checkbox1']")[0]).prop("checked", true);

	     ProcSeq	= td.eq(10).text().trim();
	     procCD		= td.eq(12).text().trim();
	     bomCode	= td.eq(15).text().trim();
    }

    
    //문서기본정보
    function fn_MainInfo_List() {
	
        if(vDocGubun=="ALL")
        	vDocGubun="";
        $.ajax(
        {
            type: "POST",
            url: "<%=Config.this_SERVER_path%>/Contents/Business/M606/S606S100100.jsp",
            data: "DocGubun=" + vDocGubun ,
            beforeSend: function () {
                $("#MainInfo_List_contents").children().remove();
            },
            success: function (html) {
                $("#MainInfo_List_contents").hide().html(html).fadeIn(100);
            },
            error: function (xhr, option, error) {

            }
        });
    }

    //문서상세정보 
    function fn_DetailInfo_List() {
        $.ajax(
        {
            type: "POST",
            url: "<%=Config.this_SERVER_path%>/Contents/Business/M606/S606S100110.jsp",
            data: "RegNo=" + vRegNo + "&RevisionNo=" + vRevisionNo ,
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

    //문서정보 (PopUp)
    function pop_fn_DocInfo_Insert(obj) {
    	
    	var modalContentUrl = "<%=Config.this_SERVER_path%>/Contents/Business/M606/S606S060101.jsp?jspPage=" + '<%=JSPpage%>';
    	
        pop_fn_popUpScr(modalContentUrl, obj.innerText+"(S606S010101)", '400px', '550px');
		return false;
     }

    function pop_fn_DocInfo_Update(obj) {

// 		if(vStatus > GV_PROCESS_DELETE){
<%--     			$('#alertNote').html("<%=JSPpage%>!!! <BR><BR> 현재 삭제할 수 없는 상태 입니다  !!!!!"); --%>
//     			$('#modalalert').show();
//     			return;
//     	}
// 		if(vDocNo.length < 1){
<%-- 			$('#alertNote').html("<%=JSPpage%>!!! <BR><BR> PO List 하나를 선택하세요!!"); --%>
// 			$('#modalalert').show();
// 			return;
// 		}
		
    	var modalContentUrl;
    	
    	modalContentUrl = "<%=Config.this_SERVER_path%>/Contents/Business/M606/S606S060102.jsp?jspPage=" + '<%=JSPpage%>' + "&DocNo=" + vDocNo ;

        pop_fn_popUpScr(modalContentUrl, obj.innerText+"(S606S010102)", '400px', '550px');
		return false;
    }

    function pop_fn_DocInfo_Delete(obj) {
// 		if(vStatus > GV_PROCESS_DELETE){
    	<%--     			$('#alertNote').html("<%=JSPpage%>!!! <BR><BR> 현재 삭제할 수 없는 상태 입니다  !!!!!"); --%>
//    	     			$('#modalalert').show();
//    	     			return;
//    	     	}
//    	 		if(vDocNo.length < 1){
    	<%-- 			$('#alertNote').html("<%=JSPpage%>!!! <BR><BR> PO List 하나를 선택하세요!!"); --%>
//    	 			$('#modalalert').show();
//    	 			return;
//    	 		}
    	var modalContentUrl;
    	
    	modalContentUrl = "<%=Config.this_SERVER_path%>/Contents/Business/M606/S606S060103.jsp?jspPage=" + '<%=JSPpage%>'+ "&DocNo=" + vDocNo ;

        pop_fn_popUpScr(modalContentUrl, obj.innerText+"(S606S010103)", '400px', '550px');
		return false;
    }

    //
    function pop_fn_JumunInfo_Comlete(obj) {    	
// 		if(vDocNo.length < 1){
<%-- 			$('#alertNote').html(obj.innerText + " <BR> <%=JSPpage%>!!! <BR><BR> 주문정보를 선택하세요  !!!"); --%>
// 			$('#modalalert').show();
// 			return false;
// 		}
    	var modalContentUrl; 
    	//상황에 맞게 추후 수정릏 반드시 할 것
    	modalContentUrl = "<%=Config.this_SERVER_path%>/Contents/Business/M606/S606S010122.jsp?DocNo=" + vDocNo 
			+ "&jspPage=" + "<%=JSPpage%>";

		pop_fn_popUpScr(modalContentUrl, obj.innerText+"(S101S020122)", '400px', '550px');
		return false;
     }
    
    </script>

    <div class="panel panel-default" style="margin-left:5px; margin-top:5px; margin-right:5px; margin-bottom:5px; width:100%">
        <!-- Default panel contents -->
        <div class="panel-heading" style="font-weight: bold" id="MenuTitle">여기에메뉴타이틀</div>
        <div class="panel-body">
        	<div>
	            <button data-author="mainBtn" type="button"  id="mainButton"  class="btn btn-primary active"
	            			style="width: auto; float: left; ">여기에메뉴버튼</button>
	            <button data-author="insert" type="button" onclick="pop_fn_DocInfo_Insert(this)" id="insert" class="btn btn-default" 
	            			style="width: auto;float: left; margin-left:30px;" >외부문서발송등록</button>
	            <button data-author="update" type="button" onclick="pop_fn_DocInfo_Update(this)" id="update" class="btn btn-outline-success" 
	            			style="width: auto; float: left; margin-left:3px;">외부문서발송수정</button>
	            <button data-author="delete" type="button" onclick="pop_fn_DocInfo_Delete(this)" id="delete" class="btn btn-danger" 
	            			style="width: auto; float: left; margin-left:3px;">외부문서발송삭제</button>
<!-- 	            <button data-author="update" type="button" onclick="pop_fn_JumunInfo_Comlete(this)" id="update" class="btn btn-warning"  -->
<!-- 	            			style="width: auto; float: left;  margin-left:30px;">외부문서발송완료</button> -->

	            <label style="width: ;  clear:both; margin-left:3px;"></label>
            </div>
            
            <p style="width: ;  clear:both; margin-left:3px;">
            </p>
            <div class="panel panel-default">
                <!-- Default panel contents -->
                <div class="panel-heading" style="font-size:16px; font-weight: bold" id="InfoContentTitle">문서기본정보</div>
                <div class="panel-body">
                    <div style="float:left">
                        <table style="width: 100%; text-align:left">
                            <tr>
                                <td style='vertical-align: middle'>
                                    <h5>
                                        &nbsp; 문서구분 : &nbsp;</h5>
                                </td>
                                <td>
	                                <select class="form-control" id="select_DocGubunCode" style="width: 120px">
	                                <%	optCode =  (Vector)DocGubunVector.get(0);%>
	                                <%	optName =  (Vector)DocGubunVector.get(1);%>
	                                <%for(int i=0; i<optName.size();i++){ %>
									  <option value='<%=optCode.get(i).toString()%>'><%=optName.get(i).toString()%></option>
									<%} %>
									</select>
                                </td>
                                <td style='vertical-align: middle'>
                                    &nbsp;&nbsp;&nbsp;<button type="button" onclick="fn_MainInfo_List()" id="btn_Search" class="btn btn-outline-success" style="width: 110px;" tag="select">조회</button>
                                </td>
                                <td style='vertical-align: middle'>
	            					<label style="width: 120px;"></label>&nbsp;
                                </td>
                                <td style='vertical-align: middle'>
	            					<label style="width: 120px;"></label>&nbsp;
                                </td>
                                
                                <td style='vertical-align: middle'>
	            					<label style="width: 120px;"></label>&nbsp;
                                </td>
                                <td style='vertical-align: middle'>
	            					<label style="width: 120px;"></label>&nbsp;
                                </td>                                
                                <td style='vertical-align: middle'>
	            					<label style="width: 120px;"></label>&nbsp;
                                </td>

                            </tr>
                        </table>
                    </div>
                    <!-- Table --> 	
                    <div style="clear:both" id="MainInfo_List_contents" >
                    </div>
 
                </div>
                
	                <div id="tabs">
			         	<ul >
			                <li onclick='fn_DetailInfo_List()'><a id="DetailInfo_List"  href=#SubInfo_List_contents>외부발송문서정보</a></li>
<!-- 			                <li onclick='com_fn_SubInfo_DOC_List(this,vOrderNo)'><a id="SubInfo_DOC_List"  href='#SubInfo_List_Doc'>주문문서목록</a></li> -->
<!-- 			                <li onclick='pop_fn_BomList(this, "<%=JSPpage%>")'><a id="SubInfo_BomList"  href='#SubInfo_bom'>주문별BOM</a></li> -->
<!-- 			                <li onclick='pop_fn_ProcessCheckList(this, "<%=JSPpage%>")'><a id="Subinfo_Process_checkList"  href='#Subinfo_Process_check'>공정확인표</a></li> -->
			            </ul>
	                    <div id="SubInfo_List_contents"></div>
	                    <div id="SubInfo_List_Doc" ></div>
<!-- 	                    <div id="SubInfo_bom" ></div> -->
<!-- 	                    <div id="Subinfo_Process_check"></div> -->
	                </div>
            </div>
        </div>
    </div>
