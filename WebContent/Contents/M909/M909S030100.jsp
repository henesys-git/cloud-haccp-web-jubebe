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
	if(loginID==null||loginID.equals("")){                            			// id가 Null 이거나 없을 경우
		response.sendRedirect(Config.this_SERVER_path + "/Contents/index.jsp"); // 로그인 페이지로 리다이렉트 한다.
	}

	String sMenuTitle = request.getParameter("MenuTitle").toString();
	String sProgramId = request.getParameter("programId").toString();
	String sHeadmenuID= request.getParameter("HeadmenuID").toString();
	String sHeadmenuName= request.getParameter("HeadmenuName").toString();
	
	Get_Program_button_Autho prg_autho = new Get_Program_button_Autho(loginID,sProgramId);		

	CurrentPage jspPageName = new CurrentPage(request.getRequestURI());
	String JSPpage = jspPageName.GetJSP_FileName();
	ProcesStatusCheck prcStatusCheck = new ProcesStatusCheck(JSPpage+"|"+"NON"+"|");
	
	String GV_PROCESS_MODIFY = prcStatusCheck.GV_PROCESS_MODIFY;
	String GV_PROCESS_DELETE = prcStatusCheck.GV_PROCESS_DELETE;
	String GV_GET_NUM_PREFIX = prcStatusCheck.GV_PROCESS_NUMBER_GUBUN; 
	
	Vector optCode =  null;
    Vector optName =  null;
    Vector check_gubunVector = CommonData.getChecklistGubun_CodeALL(member_key);
%>

 <script type="text/javascript">
 	var vCheckGubunCode	= "";
 	var vCheckGubunName	= "";
    var vCheckGubunMid	= "";
    var vCheckGubunSm	= "";
 	var vCheckListCd	= "";
 	var vRevisionNo		= "";
 	var vItemSeq		= "";
 	var vCheckGubun		= "";  
 	var vCheckListSeq	= "";
 	var vItemCd			= ""; 
 	var vItemRevNo		= "";
 	var FLAG			= false;

    $(document).ready(function () {        
        
		fn_MainSubMenuSelect("<%=sMenuTitle%>");
		$("#InfoContentTitle").html("체크문항정보");

    	fn_MainInfo_List();
        
	    $("#select_check_gubun").on("change", function(){
	    	fn_MainInfo_List();
	    });

	    fn_tagProcess('<%=JSPpage%>');
	    
	    $("#total_rev_check").change(function(){
			FLAG = !FLAG;
	    	
	    	if( FLAG )
	    	{
	    		alert("등록 / 수정 / 삭제 기능이 제한됩니다.");
	    		
	    		$("#insert").prop("disabled",true);
	    		$("#update").prop("disabled",true);
	    		$("#delete").prop("disabled",true);
	    	}
	    	else
	    	{
	    		$("#insert").prop("disabled",false);
	    		$("#update").prop("disabled",false);
	    		$("#delete").prop("disabled",false);
	    	}
	    	
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
    
    //체크문항정보
    function fn_MainInfo_List() {
    	vCheckGubunCode = $("#select_check_gubun").val();
        if(vCheckGubunCode=="ALL") 
        	vCheckGubunCode="";
        
        var revCheck = $("#total_rev_check").is(":checked");
        
        $.ajax({
            type: "POST",
            url: "<%=Config.this_SERVER_path%>/Contents/Business/M909/S909S030100.jsp",
            data: "check_gubun=" + vCheckGubunCode + "&total_rev_check=" + revCheck ,
            beforeSend: function () {
                $("#MainInfo_List_contents").children().remove();
            },
            success: function (html) {
                $("#MainInfo_List_contents").hide().html(html).fadeIn(100);
            }
        });
    }
    
    //문서코드정보 (PopUp)
    function pop_fn_CheckList_Insert(obj) {
    	vCheckGubunName = $('#select_check_gubun option:selected').text(); // 벡터 텍스트 가져오는 방법
    	
    	if(vCheckGubunCode.length < 1){
    		heneSwal.warning("체크문항 구분을 선택해주세요 (구분이 전체로 되어 있으면 입력 불가능)");
 			return false;
        }
    	var modalContentUrl = "<%=Config.this_SERVER_path%>/Contents/Business/M909/S909S030101.jsp"
    						+ "?CheckGubunCode=" + vCheckGubunCode
    						+ "&CheckGubunName=" + vCheckGubunName
    						;
    	
    	var footer = '<button id="btn_Save" class="btn btn-info" style="width: 100px" onclick="SaveOderInfo();">저장</button>';
    	var title = obj.innerText;
    	var heneModal = new HenesysModal(modalContentUrl, 'large', title, footer);
    	heneModal.open_modal();
     }

    
    function pop_fn_CheckList_Update(obj) {
    	if(vCheckListCd.length < 1){
    		heneSwal.warning("체크문항 정보를 선택하세요");
 			return false;
        }
    	var modalContentUrl = "<%=Config.this_SERVER_path%>/Contents/Business/M909/S909S030102.jsp"
    						+ "?CheckGubun=" + vCheckGubun
    						+ "&CheckGubunMid=" + vCheckGubunMid
    					    + "&CheckGubunSm=" + vCheckGubunSm 		
    						+ "&CheckListCd=" + vCheckListCd 
    						+ "&RevisionNo=" + vRevisionNo 
    						+ "&ItemSeq=" + vItemSeq 
    						+ "&CheckListSeq=" + vCheckListSeq 
    						+ "&ItemCd=" + vItemCd 
    						+ "&ItemRevNo="+ vItemRevNo
    						;

    	var footer = '<button id="btn_Save" class="btn btn-info" style="width: 100px" onclick="SaveOderInfo();">저장</button>';
    	var title = obj.innerText;
    	var heneModal = new HenesysModal(modalContentUrl, 'large', title, footer);
    	heneModal.open_modal();
    }

    function pop_fn_CheckList_Delete(obj) {
    	if(vCheckListCd.length < 1){
    		heneSwal.warning("체크문항 정보를 선택하세요");
 			return false;
        }
    	var modalContentUrl = "<%=Config.this_SERVER_path%>/Contents/Business/M909/S909S030103.jsp"
    						+ "?CheckGubun="+ vCheckGubun
    						+ "&CheckGubunMid=" + vCheckGubunMid
    					    + "&CheckGubunSm=" + vCheckGubunSm 				
    						+ "&CheckListCd=" + vCheckListCd 
    						+ "&RevisionNo=" + vRevisionNo 
    						+ "&ItemSeq=" + vItemSeq 
    						+ "&CheckListSeq=" + vCheckListSeq 
    						+ "&ItemCd=" + vItemCd 
    						+ "&ItemRevNo="+ vItemRevNo
    						;
    	
    	var footer = '<button id="btn_Save" class="btn btn-info" style="width: 100px" onclick="SaveOderInfo();">확인</button>';
    	var title = obj.innerText;
    	var heneModal = new HenesysModal(modalContentUrl, 'large', title+"(S909S030103)", footer);
    	heneModal.open_modal();
    }
</script>
    
<!-- Content Header (Page header) -->
<div class="content-header">
  <div class="container-fluid">
    <div class="row mb-2">
      <div class="col-sm-6">
        <h1 class="m-0 text-dark" id="MenuTitle">여기에 메뉴 타이틀</h1>
      </div><!-- /.col -->
      <div class="col-sm-6">
      	<div class="float-sm-right">
      		<button type = "button" onclick="pop_fn_CheckList_Insert(this)" id="insert" class= "btn btn-outline-dark">체크문항등록</button>
			<button type = "button" onclick="pop_fn_CheckList_Update(this)" id="update" class= "btn btn-outline-success">체크문항수정</button>
			<button type = "button" onclick="pop_fn_CheckList_Delete(this)" id="delete" class= "btn btn-outline-danger">체크문항삭제</button>
      		<label style="width: auto; clear:both; margin-left:30px;">
	            	Rev. No 전체보기
	            	<input type="checkbox" id="total_rev_check">
	            </label>		
	            <label style="width: ;  clear:both; margin-left:3px;"></label>
      	</div>
      </div> <!-- /.col -->
    </div> <!-- /.row -->
  </div> <!-- /.container-fluid -->
</div> <!-- /.content-header -->

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
          	<div class = "card-tools">
          		<table>
                            <tr>
                            	<td style='width:50%; vertical-align: middle; font-weight: bold'>구분 : </td>
                                <td style='width:10%; vertical-align: middle; text-align:left;'> 
									<select class="form-control" id="select_check_gubun" name="check_gubun"  style="width: 120px">
							            <%optCode = (Vector)check_gubunVector.get(0);%>
							            <%optName = (Vector)check_gubunVector.get(1);%>
							            <%for(int i=0; i<optName.size();i++){ %>
											<option value='<%=optCode.get(i).toString()%>'><%=optName.get(i).toString()%></option>
										<%} %>
									</select>
                                </td>
                               <!--  <td style='width:40%; vertical-align: middle; text-align:left"'>
                                    <button type="button" onclick="fn_MainInfo_List()" id="btn_Search" class="btn btn-outline-success"
                                        style="width: 110px;">조회</button>
                                </td> -->
                            </tr>
                 	</table>
          		</div>
          </div>
          <div class="card-body" id="MainInfo_List_contents"></div> 
        </div>
      </div> <!-- /.col-md-6 -->
    </div> <!-- /.row -->
  </div> <!-- /.container-fluid -->
</div> <!-- /.content -->