<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="mes.client.comm.*" %>
<%@ page import="mes.client.common.*" %>
<%@ page import="mes.client.guiComponents.*" %>
<%@ page import="mes.client.util.*" %>
<%@ page import="mes.client.conf.*" %>
<%  	
/* 
공정별체크리스트(M909S122100.jsp)
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
	Vector Process_gubunVector = CommonData.getProcess_gubun(member_key);
%>

 <script type="text/javascript">
	var proc_cd = "";
	var proc_cd_rev;
	var process_nm;
	var checklist_cd = "";
	var menuName;
	var vProcess_gubun;
	var check_note;
	var checklist_seq;
	var standard_guide;
	var standard_value;
	var item_desc;
	var item_type;
	var item_bigo;

    $(document).ready(function () {
    	
        fn_MainSubMenuSelect("<%=sMenuTitle%>");
		$("#InfoContentTitle").html("공정별체크리스트정보");
		$("#JumunInfoContentTitle2").html("공정별체크리스트 목록");

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
        if ($("#Main_contents").children().length > 0) {
            $("#Main_contents").children().remove();
        }
        if ($("#Main_contents2").children().length > 0) {
            $("#Main_contents2").children().remove();
        }
    }
        
    //공정정보
    function fn_MainInfo_List() {
    	var revCheck = $("#total_rev_check").is(":checked"); 
    	
        $.ajax(
        {
            type: "POST",
            url: "<%=Config.this_SERVER_path%>/Contents/Business/M909/S909S122100.jsp",
            data: "Process_gubun="+ vProcess_gubun + "&total_rev_check=" + revCheck,
            beforeSend: function () {
                $("#Main_contents").children().remove();
            },
            success: function (html) {
                $("#Main_contents").hide().html(html).fadeIn(100);
            },
            error: function (xhr, option, error) {
 
            }
        });
    }

	function fn_DetailInfo_List() { 
		
    	$.ajax(
    	    {
    	        type: "POST",
    	        url: "<%=Config.this_SERVER_path%>/Contents/Business/M909/S909S122110.jsp",
    	        data: "proc_cd=" + proc_cd + "&proc_cd_rev=" + proc_cd_rev,
    	        beforeSend: function () {
//     	            $("#ProcessInfo_bom").children().remove();
    	        },
    	        success: function (html) {
    	            $("#Main_contents2").hide().html(html).fadeIn(100);
    	        },
    	        error: function (xhr, option, error) {
    	        }
    	    });
		return;
	}   

    function pop_fn_processchecklist_Insert(obj) {
    	//alert("proc_id.length=" + proc_id.length + "/" + proc_id);
		
    	if(proc_cd.length < 1){
    		heneSwal.warning("공정을 선택하세요");
    		return false;
    	}

    	var modalContentUrl;
    	modalContentUrl = "<%=Config.this_SERVER_path%>/Contents/Business/M909/S909S122101.jsp"
    					+ "?proc_cd=" + proc_cd + "&proc_cd_rev=" + proc_cd_rev+ "&process_nm=" + process_nm
    					+ "&process_gubun=" + vProcess_gubun;
    	
    	var footer = "";
     	var title  = obj.innerText;
     	var heneModal = new HenesysModal(modalContentUrl, 'large', title+"(S909S122101)", footer);
     	heneModal.open_modal();
		
    }

    function pop_fn_processchecklist_Update(obj) {
    	if(checklist_cd == undefined){
    		heneSwal.warning("수정할 공정을 선택하세요");
 			return false;
    	}

    	var modalContentUrl;
    	modalContentUrl = "<%=Config.this_SERVER_path%>/Contents/Business/M909/S909S122102.jsp?proc_cd=" + proc_cd + "&checklist_cd=" + checklist_cd + "&process_nm=" + process_nm + "&check_note=" + check_note + "&checklist_seq=" +checklist_seq + "&standard_guide=" + standard_guide + "&standard_value=" + standard_value + "&item_desc=" + item_desc + "&item_type=" + item_type + "&item_bigo=" + item_bigo;
    	
    	var footer = "";
     	var title  = obj.innerText;
     	var heneModal = new HenesysModal(modalContentUrl, 'large', title+"(S909S122102)", footer);
     	heneModal.open_modal();
    }

    function pop_fn_processchecklist_Delete(obj) {
     	
    	console.log(checklist_cd);
    	
    	if(checklist_cd == undefined || checklist_cd.length < 1){
    		heneSwal.warning("삭제할 체크리스트를 선택하세요");
 			return false;
    	} 
    	var modalContentUrl;
    	
    	modalContentUrl = "<%=Config.this_SERVER_path%>/Contents/Business/M909/S909S122103.jsp?proc_cd=" + proc_cd + "&checklist_cd=" + checklist_cd + "&process_nm=" + process_nm + "&check_note=" + check_note + "&checklist_seq=" +checklist_seq + "&standard_guide=" + standard_guide + "&standard_value=" + standard_value + "&item_desc=" + item_desc + "&item_type=" + item_type + "&item_bigo=" + item_bigo;
    	
    	var footer = "";
     	var title  = obj.innerText;
     	var heneModal = new HenesysModal(modalContentUrl, 'large', title+"(S909S122103)", footer);
     	heneModal.open_modal();
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
      	  <button type="button" onclick="pop_fn_processchecklist_Insert(this)" id="insert" class="btn btn-outline-dark">공정별체크리스트 등록</button>
      	  <button type="button" onclick="pop_fn_processchecklist_Delete(this)" id="delete" class="btn btn-outline-danger">공정별체크리스트 삭제</button>
			
		<label style="width: auto; clear:both; margin-left:30px;">
	     Rev. No 전체보기
	    <input type="checkbox" id="total_rev_check"  />
	    </label>      	
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
          			 <div style="float: right">
                       <table>
                           <tr>
                           	<td>
                           		<div class="panel-heading" style="font-size:16px; font-weight: bold"  id="InfoContentTitle"></div>
                           	</td>
                           	<td >공정구분 :</td>
                             <td>
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
          		</div>
          <div class="card-body" id="Main_contents"></div> 
        </div>
      </div> <!-- /.col-md-6 -->
    </div> <!-- /.row -->
    		<div class="card card-primary card-outline">
          		<div class="card-header">
          			<h3 class="card-title">
          				<i class="fas fa-edit" id="JumunInfoContentTitle2"></i>
          			</h3>
          		</div>
          		<div class="card-body" id="Main_contents2"></div> 
        	</div>
  		</div> <!-- /.container-fluid -->
	</div> <!-- /.content -->