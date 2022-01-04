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
    
    Vector partgubun_bigVector = PartListComboData.getPartBigGubunDataAll(member_key);
    Vector partgubun_midVector = PartListComboData.getPartMidGubunDataAll("", member_key);
    Vector partgubun_smVector = PartListComboData.getPartSmGubunDataAll();

%>

 <script type="text/javascript">
 	var vPart_gubun_b="";
	var vPart_gubun_m="";
	var vPart_gubun_s="";
	var vgyugyeok ="";
	var vPart_level="";
	var vPartCd		= "";
	var vRevisionNo = "";
	var vPartCode = "";
	
	var vPart_cd_alt = "";
	var vPart_nm_alt = "";
	var vPartgubun_big="";
	var vPartgubun_mid="";
	var vPartgubun_sm="";

	
$(document).ready(function () {        
        
		fn_MainSubMenuSelect("<%=sMenuTitle%>");
// 		$("#InfoContentTitle").html("원자재코드정보");

    	fn_MainInfo_List();
        
	    fn_tagProcess('<%=JSPpage%>');
	    
	    $("#total_rev_check").change(function(){
	    	fn_MainInfo_List();
	    });
	    
	    $("#partgubun_big").on("change", function(){
	    	vPartgubun_big = $(this).val();
	    	
	    	
	    	$("#partgubun_mid > option").show();
	    	$("#partgubun_sm > option").show();
	    	
	    	if($("#partgubun_big").val()=="ALL") {
	    		$("#partgubun_mid > option:eq(0)").prop("selected", true);
	    		$("#partgubun_sm > option:eq(0)").prop("selected", true);
	    		vPartgubun_mid = $("#partgubun_mid").val();
	    		vPartgubun_sm = $("#partgubun_sm").val();
	    		fn_MainInfo_List();
	    		return;
	    	}
	    	
	    	
	    	
	    	for(var i=0; i<$("#partgubun_mid > option").length; i++) {
        		if($("#partgubun_mid > option")[i].value.indexOf($("#partgubun_big").val()) ==-1) 
        			$("#partgubun_mid > option")[i].style.display="none";        		
	    	}
	    	
	    	for(var j=0; j<$("#partgubun_sm > option").length; j++) {
	    		if($("#partgubun_sm > option")[j].value.indexOf($("#partgubun_mid").val()) ==-1)
	    			$("#partgubun_sm > option")[j].style.display="none";       		
	    	}
	    	
	    	
/* 	    	$("#partgubun_mid > option")[0].style.display="block";
	    	$("#partgubun_sm > option")[0].style.display="block"; */
	    	fn_MainInfo_List();
	    });

	    $("#partgubun_mid").on("change", function(){
	    	vPartgubun_big = $("#partgubun_big").val();
	    	vPartgubun_mid = $(this).val();    	
	    	
	    	$("#partgubun_sm > option").show();
	    	
	    	if($("#partgubun_mid").val()=="ALL") {
	    		$("#partgubun_sm > option:eq(0)").prop("selected", true);
	    		vPartgubun_sm = $("#partgubun_sm").val();
	    		fn_MainInfo_List();
	    		return;
	    	}
	    	
	    	for(var i=0; i<$("#partgubun_sm > option").length; i++) {
        		if($("#partgubun_sm > option")[i].value.indexOf($("#partgubun_mid").val()) ==-1) 
        			$("#partgubun_sm > option")[i].style.display="none";
	    	}
	    	
	    	
	    	fn_MainInfo_List();
	    });
	    
	    $("#partgubun_sm").on("change", function(){
	    	vPartgubun_big = $("#partgubun_big").val();
	    	vPartgubun_mid = $("#partgubun_mid").val();
	    	vPartgubun_sm  = $(this).val();
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
        if ($("#SubInfo_List_contents").children().length > 0) {
            //$("#SubInfo_List_contents").children().remove();
        }        
        if ($("#sub_SubInfo_List_contents").children().length > 0) {
            $("#sub_SubInfo_List_contents").children().remove();
        }
    }

    
    //원자재등록정보
    function fn_MainInfo_List() {
    	var revCheck = $("#total_rev_check").is(":checked"); 
    	 
    	
		if(vPartgubun_big=="ALL")
			vPartgubun_big="";
		if(vPartgubun_mid=="ALL")
			vPartgubun_mid="";
		if(vPartgubun_sm=="ALL")
			vPartgubun_sm="";
    	
        $.ajax(
        {
            type: "POST",
            url: "<%=Config.this_SERVER_path%>/Contents/Business/M909/S909S110100.jsp",
            data: "partgubun_big="+ vPartgubun_big +  "&partgubun_mid="+ vPartgubun_mid + "&partgubun_sm=" +vPartgubun_sm + "&total_rev_check=" + revCheck,
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

    //문서코드상세정보 
    function fn_DetailInfo_List() {
        $.ajax(
        {
            type: "POST",
            url: "<%=Config.this_SERVER_path%>/Contents/Business/M909/S909S140100.jsp",
            data: "CodeGroupGubun=" + vCodeGroupGubun ,
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
    
    //원자재등록 (PopUp)
    function pop_fn_CodeCd_Insert(obj) {
    	
    	var modalContentUrl;
  
    		modalContentUrl = "<%=Config.this_SERVER_path%>/Contents/Business/M909/S909S110101.jsp";
  
    	
		modalFramePopup.setTitle(obj.innerText);
		pop_fn_popUpScr(modalContentUrl, obj.innerText+"(S909S110101)", "500px", "1280px");
		return false;
     }


    
    function pop_fn_CodeCd_Update(obj) {
    	if(vPartCode.length < 1){
//          if(vCodeValue==undefined){
               	alert("원자재를 선택하세요");
               	return false;
            }
        	var modalContentUrl;
        	

             modalContentUrl = "<%=Config.this_SERVER_path%>/Contents/Business/M909/S909S110102.jsp?part_code=" +vPartCode +"&revision_no=" + vRevisionNo;
        	
    		modalFramePopup.setTitle(obj.innerText);
    		pop_fn_popUpScr(modalContentUrl, obj.innerText+"(S909S110102)", "500px", "1280px");
    		return false;
    }

    function pop_fn_CodeCd_Delete(obj) {
    	if(vPartCode.length < 1){
//      if(vCodeValue==undefined){
           	alert("원자재를 선택하세요");
           	return false;
        }
    	var modalContentUrl;
    	

         modalContentUrl = "<%=Config.this_SERVER_path%>/Contents/Business/M909/S909S110103.jsp?part_code=" +vPartCode;
    	
		modalFramePopup.setTitle(obj.innerText);
		pop_fn_popUpScr(modalContentUrl, obj.innerText+"(S909S110103)", "500px", "680px");
		return false;
    }
    
    </script>

            
 <div class="panel panel-default" style="margin-left:5px; margin-top:5px; margin-right:5px; margin-bottom:5px; width:100%">
        <!-- Default panel contents -->
        <div class="panel-heading" style="font-weight: bold" id="MenuTitle">여기에메뉴타이틀</div>
        <div class="panel-body">
        	<div style="margin-bottom:10px;">
	            <button data-author="mainBtn" type="button"  id="mainButton"  class="btn btn-primary active"
	            			style="width: auto; float: left; ">기준정보-원자재코드관리</button>
	            <button data-author="insert" type="button" onclick="pop_fn_CodeCd_Insert(this)" id="insert" class="btn btn-warning" 
	            			style="width: auto;float: left; margin-left:30px;" >한계기준등록</button>
	            <button data-author="update" type="button" onclick="pop_fn_CodeCd_Update(this)" id="update" class="btn btn-outline-success" 
	            			style="width: auto; float: left; margin-left:3px;">한계기준수정</button>
 	            <button data-author="delete" type="button" onclick="pop_fn_CodeCd_Delete(this)" id="delete" class="btn btn-danger" 
	            			style="width: auto; float: left; margin-left:3px;">한계기준삭제</button>
	            <label style="width: ;  clear:both; margin-left:3px;"></label>
	            
	            <label style="width: auto; clear:both; margin-left:30px;">
	            	Rev. No 전체보기
	            	<input type="checkbox" id="total_rev_check"  />
	            </label>
            </div>
            
            <p style="height:5px ;clear:both; margin-bottom:3px;">
            </p>
            <div class="panel panel-default">
                <!-- Default panel contents -->
<!--                 <div class="panel-heading" style="font-size:16px; font-weight: bold" id="InfoContentTitle">원자재코드정보</div> -->
                <div style="float: left">
					<table style="width: 100%; text-align:left; background-color:#f5f5f5;">
						<tr>
                           	<td style='width:10%; vertical-align: middle;'>
                           		<div class="panel-heading" style="font-size:16px; font-weight: bold"  id="InfoContentTitle"></div>
                           	</td>
                           	<td style='width:11%; vertical-align: middle'>원자재 대분류</td>
                            <td style='width:22%;vertical-align: middle'>
	                        	<select class="form-control" id="partgubun_big" style="width: 120px">
	                                <%	optCode =  (Vector)partgubun_bigVector.get(0);%>
	                                <%	optName =  (Vector)partgubun_bigVector.get(1);%>
	                                <%for(int i=0; i<optName.size();i++){ %>
									  <option value='<%=optCode.get(i).toString()%>'><%=optName.get(i).toString()%></option>
									<%} %>
								</select>
							</td>
                              
                           	<td style='width:11%; vertical-align: middle'>원자재 중분류</td>
                            <td style='width:22%;vertical-align: middle'>
	                        	<select class="form-control" id="partgubun_mid" style="width: 120px">
	                                <%	optCode =  (Vector)partgubun_midVector.get(0);%>
	                                <%	optName =  (Vector)partgubun_midVector.get(1);%>
	                                <%for(int i=0; i<optName.size();i++){ %>
									  <option value='<%=optCode.get(i).toString()%>'><%=optName.get(i).toString()%></option>
									<%} %>
								</select>
							</td>
							
                           	<td style='width:11%;'>원자재 소분류</td>
                            <td style='width:22%;'>
	                        	<select class="form-control" id="partgubun_sm" style="width: 120px">
	                                <%	optCode =  (Vector)partgubun_smVector.get(0);%>
	                                <%	optName =  (Vector)partgubun_smVector.get(1);%>
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
