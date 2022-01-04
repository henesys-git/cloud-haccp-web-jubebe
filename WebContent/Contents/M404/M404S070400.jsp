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
제품검사(M404S070100.jsp)
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
	ProcesStatusCheck prcStatusCheck = new ProcesStatusCheck(JSPpage+"|"+"PRDINSP"+"|");
	
	
	String GV_PROCESS_MODIFY	= prcStatusCheck.GV_PROCESS_MODIFY;
	String GV_PROCESS_DELETE	= prcStatusCheck.GV_PROCESS_DELETE;
	String GV_PROCESS_NAME		= prcStatusCheck.GV_PROCESS_NAME;
	String GV_GET_NUM_PREFIX	= prcStatusCheck.GV_PROCESS_NUMBER_GUBUN;

	Vector optCode =  null;
    Vector optName =  null;
	Vector InspectGubunVector = CommonData.getInspectGubunCode();


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

    $(document).ready(function () {
    	new SetDate("dateFrom", -180);
    	new SetDate("dateTo", 0);
        
        fn_MainSubMenuSelect("<%=sMenuTitle%>");
		$("#InfoContentTitle").html("품질검사요청목록");

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


    function fn_MainInfo_List() {
        var from = $("#dateFrom").val();
        var to = $("#dateTo").val();
        vCustCode = $("#txt_cust_code").val();
        if(vInspectGubun=="ALL")
        	vInspectGubun="";
        $.ajax(
        {
            type: "POST",
            url: "<%=Config.this_SERVER_path%>/Contents/Business/M404/S404S070300.jsp", 
            data: "From=" + from + "&To=" + to  +"&Custcode=" + vCustCode + "&InspectGubun=" + vInspectGubun + "&jspPage=" + "<%=JSPpage%>",
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
        $("#SubInfo_BOM").children().remove();
        $("#SubInfo_check").children().remove();
    }
    
	function fn_DetailInfo_List() {     
    	$.ajax(
    	    {
    	        type: "POST",
    	        url: "<%=Config.this_SERVER_path%>/Contents/Business/M404/S404S070110.jsp",
    	        data: "OrderNo=" + vOrderNo + "&lotno=" + vLotNo + "&inspect_gubun=" + vInspectGubun + "&proc_cd=" + vproc_cd + "&product_serial_no=" + product_serial_no,
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


    //검토정보 (PopUp)
    function pop_Review_Confirm_Insert(obj) {
    	if(vOrderNo.length < 1){
			$('#alertNote').html($(obj).html() + " <BR> <%=JSPpage%>!!! <BR><BR> PO List 하나를 선택하세요!!");
			$('#modalalert').show();
			return;
    	}
    	var mainKey = "inspect_no = '" + inspect_no + "'";
    	var actionKey = "";  //inpect_no = '" + vOrderNo + "'"; 있으면 mainKey와 같은 방식으로 정의

    	fn_Process_Review_n_Confirm(obj, '<%=JSPpage%>',vOrderNo, vOrderDetailSeq, '<%=GV_PROCESS_NAME%>', mainKey, actionKey,'<%=GV_GET_NUM_PREFIX%>',"<%=prcStatusCheck.GV_PROCESS_GUBUN%>",vLotNo);
		return false;
     }   
    
    </script>
<div class="panel panel-default"
	style="margin-left: 5px; margin-top: 5px; margin-right: 5px; margin-bottom: 5px; width: 100%">
	<!-- Default panel contents -->
	<div class="panel-heading" style="font-weight: bold" id="MenuTitle">여기에메뉴타이틀</div>
	<div class="panel-body">

		<div>
			<button data-author="mainBtn" type="button" id="mainButton"
				class="btn btn-primary active" style="width: auto; float: left;">품질관리-제품검사</button>
			<button data-author="insert" type="button" onclick="pop_Review_Confirm_Insert(this)" id="insert" class="btn btn-default"
				style="width: auto; float: left; margin-left: 30px;">제품검사승인</button>
			<label style="width: 100px; clear: both; margin-left: 3px;"></label>

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

                                <td style='vertical-align: middle;'>
                                    <LABEL style="vertical-align: middle;margin-left:40px;margin-top:5px;float: left">검사구분 : &nbsp;</LABEL>
	                                <select class="form-control" id="select_InspectGubunCode" style="width: 120px;float: left">
	                                <%	optCode =  (Vector)InspectGubunVector.get(0);%>
	                                <%	optName =  (Vector)InspectGubunVector.get(1);%>
	                                <%for(int i=0; i<optName.size();i++){ %>
									  <option value='<%=optCode.get(i).toString()%>'><%=optName.get(i).toString()%></option>
									<%} %>
									</select>
                                </td>
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
					<li onclick='fn_DetailInfo_List()'><a id="DetailInfo_List"  href='#SubInfo_List_contents'>제품검사결과</a></li>
					<li onclick='com_fn_SubInfo_DOC_List(this,vOrderNo)'><a id="SubInfo_DOC_List"  href='#SubInfo_List_Doc'>문서목록</a></li>
					<li onclick='pop_fn_BomList(this, "<%=JSPpage%>")'><a id="SubInfo_BomList"  href='#SubInfo_BOM'>BOM정보</a></li>
					<li onclick='pop_fn_ProcessCheckList(this, "<%=JSPpage%>")'><a id="SubInfo_checklist"  href='#SubInfo_check'>공정확인표</a></li>
				</ul>
				<div id="SubInfo_List_contents" ></div>
				<div id="SubInfo_List_Doc" ></div>
				<div id="SubInfo_BOM" ></div>
				<div id="SubInfo_check"></div>
		  	</div>
		</div>
	</div>
</div>