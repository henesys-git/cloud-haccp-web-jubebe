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
	
	Vector optCode =  null;
    Vector optName =  null;
    Vector Process_gubunVector = CommonData.getProcessGubun_CodeAll(member_key);

%>

 <script type="text/javascript">
 	var vProcCd		= "";
 	var vRevisionNo = "";
 	var vProcess_gubun = "";
	
    $(document).ready(function () {        
        
		fn_MainSubMenuSelect("<%=sMenuTitle%>");
		$("#InfoContentTitle").html("표준공정 정보관리");

		$("#select_CheckGubunCode").on("change", function(){
	    	vProcess_gubun = $(this).val();
	    	fn_MainInfo_List();
	    });
		
		$("#select_CheckGubunCode option:eq(0)").prop("selected", true);
	    vProcess_gubun = $("#select_CheckGubunCode").val(); 
		
    	fn_MainInfo_List();
        
	    fn_tagProcess('<%=JSPpage%>');
	    
	    $("#total_rev_check").change(function(){
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


    function fn_LoadSubPage() {
        fn_clearList();
        fn_MainInfo_List();
    }

    function fn_clearList() {
        if ($("#MainInfo_List_contents").children().length > 0) {
            $("#MainInfo_List_contents").children().remove();
        }
    }

    
    //표준공정정보관리
    function fn_MainInfo_List() {
    	var revCheck = $("#total_rev_check").is(":checked"); 
    	
        $.ajax(
        {
            type: "POST",
            url: "<%=Config.this_SERVER_path%>/Contents/Business/M909/S909S121100.jsp",
            data: "Process_gubun="+ vProcess_gubun + "&total_rev_check=" + revCheck ,
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
    
    //공정코드정보 (PopUp)
    function pop_fn_ProcCd_Insert(obj) {
    	if(vProcess_gubun.length < 1){
            alert("공정구분을 선택하세요");
            return false;
        }
    	
    	var modalContentUrl;
    	
       	modalContentUrl = "<%=Config.this_SERVER_path%>/Contents/Business/M909/S909S121101.jsp"
       					+ "?Process_gubun=" + vProcess_gubun;
    	
		modalFramePopup.setTitle(obj.innerText);
		pop_fn_popUpScr(modalContentUrl, obj.innerText+"(S909S121101)", "630px", "680px");
		return false;
     }


    
    function pop_fn_ProcCd_Update(obj) {
    	if(vProcCd.length < 1){
//      if(vProcCd==undefined){
           	alert("공정정보를 선택하세요");
           	return false;
        }
    	var modalContentUrl;

       	modalContentUrl = "<%=Config.this_SERVER_path%>/Contents/Business/M909/S909S121102.jsp?ProcCd=" + vProcCd + "&RevisionNo=" + vRevisionNo;
    	
		modalFramePopup.setTitle(obj.innerText);
		pop_fn_popUpScr(modalContentUrl, obj.innerText+"(S909S121102)", "630px", "680px");
// 		var rtnVal = fn_CommonPopupModal(modalContentUrl, null, 450, 600); modal-md 
		return false;
    }

    function pop_fn_ProcCd_Delete(obj) {
    	if(vProcCd.length < 1){
//      if(vProcCd==undefined){
           	alert("공정정보를 선택하세요");
          	return false;
        }
    	var modalContentUrl;
    	
       	modalContentUrl = "<%=Config.this_SERVER_path%>/Contents/Business/M909/S909S121103.jsp?ProcCd=" + vProcCd + "&RevisionNo=" + vRevisionNo;
    	
		modalFramePopup.setTitle(obj.innerText);
		pop_fn_popUpScr(modalContentUrl, obj.innerText+"(S909S121103)", "630px", "680px");
// 		var rtnVal = fn_CommonPopupModal(modalContentUrl, null, 450, 600); modal-md 
		return false;
    }
    
    </script>

    <div class="panel panel-default" style="margin-left:5px; margin-top:5px; margin-right:5px; margin-bottom:5px; width:100%">
        <!-- Default panel contents -->
        <div class="panel-heading" style="font-weight: bold" id="MenuTitle">여기에메뉴타이틀</div>
        <div class="panel-body">
        	<div>
	            <button data-author="mainBtn" type="button"  id="mainButton"  class="btn btn-primary active"
	            			style="width: auto; float: left; ">기준정보-표준공정 정보관리</button>
	            <button data-author="insert" type="button" onclick="pop_fn_ProcCd_Insert(this)" id="insert" class="btn btn-warning" 
	            			style="width: auto;float: left; margin-left:30px;" >표준공정 정보등록</button>
	            <button data-author="update" type="button" onclick="pop_fn_ProcCd_Update(this)" id="update" class="btn btn-outline-success" 
	            			style="width: auto; float: left; margin-left:3px;">표준공정 정보수정</button>
	            <button data-author="delete" type="button" onclick="pop_fn_ProcCd_Delete(this)" id="delete" class="btn btn-danger" 
	            			style="width: auto; float: left; margin-left:3px;">표준공정 정보삭제</button>
	            <label style="width: ;  clear:both; margin-left:3px;"></label>
	            
	            <label style="width: auto; clear:both; margin-left:30px;">
	            	Rev. No 전체보기
	            	<input type="checkbox" id="total_rev_check"  />
	            </label>
            </div>
            
            <p style="width: ;  clear:both; margin-left:3px;">
            </p>
            <div class="panel panel-default">
                <!-- Default panel contents -->
<!--                 <div class="panel-heading" style="font-size:16px; font-weight: bold" id="InfoContentTitle">공정코드정보</div> -->

                <div style="float: left">
					<table style="width: 100%; text-align:left; background-color:#f5f5f5;">
						<tr>
                           	<td style='width:10%; vertical-align: middle;'>
                           		<div class="panel-heading" style="font-size:16px; font-weight: bold"  id="InfoContentTitle"></div>
                           	</td>
                           	<td style='width:3%; vertical-align: middle'>공정코드 :</td>
                            <td style='width:50%;vertical-align: middle'>
	                        	<select class="form-control" id="select_CheckGubunCode" style="width: 120px">
	                                <%	optCode =  (Vector)Process_gubunVector.get(0);%>
	                                <%	optName =  (Vector)Process_gubunVector.get(1);%>
	                                <%for(int i=0; i<optName.size();i++){ %>
									  <option value='<%=optCode.get(i).toString()%>'><%=optName.get(i).toString()%></option>
									<%} %>
								</select>
							</td>
                              
						</tr>
					</table>
				</div>
                
                <div class="panel-body">
                    <div style="clear:both" id="MainInfo_List_contents" >
                    </div>
 
                </div>
            	</div>
            </div>
        </div>
    </div>
