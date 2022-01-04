<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="mes.client.comm.*" %>
<%@ page import="mes.client.common.*" %>
<%@ page import="mes.client.guiComponents.*" %>
<%@ page import="mes.client.util.*" %>
<%@ page import="mes.client.conf.*" %>
<%  	
/* 
제품검사체크리스트(M909S123100.jsp)
 */
	String loginID = session.getAttribute("login_id").toString();
	String member_key = session.getAttribute("member_key").toString();
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
	ProcesStatusCheck prcStatusCheck = new ProcesStatusCheck(JSPpage+"|"+"NON"+"|");
	
	
	String GV_PROCESS_MODIFY	= prcStatusCheck.GV_PROCESS_MODIFY;
	String GV_PROCESS_DELETE	= prcStatusCheck.GV_PROCESS_DELETE;
	String GV_GET_NUM_PREFIX = prcStatusCheck.GV_PROCESS_NUMBER_GUBUN;

	Vector optCode =  null; 
    Vector optName =  null;
	Vector CheckGubunVector = CommonData.getChecklistGubun_PIN_SHIP_CodeALL(member_key);
%>

 <script type="text/javascript">
	var prod_cd = "";
	var prod_cd_rev;
	var pic_seq, checklist_cd = "", checklist_cd_rev, product_nm, check_note, checklist_seq, standard_guide, standard_value, item_desc, item_type, item_bigo;
	var vCheckGubun;
	var vCheckGubun2="";
	var menuName;
	
    $(document).ready(function () {
        fn_MainSubMenuSelect("<%=sMenuTitle%>");
		$("#InfoContentTitle").html("제품정보");
		$("#JumunInfoContentTitle2").html("제품검사체크리스트 목록");

    	fn_MainInfo_List();
	    fn_tagProcess('<%=JSPpage%>');	    
	    
	    $("#select_CheckGubunCode").on("change", function(){
	    	vCheckGubun = $(this).val();
	    	fn_DetailInfo_List();
	    });
	    vCheckGubun = $("#select_CheckGubunCode").val();

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
        
    //제품정보
    function fn_MainInfo_List() {
    	
        $.ajax(
        {
            type: "POST",
            url: "<%=Config.this_SERVER_path%>/Contents/Business/M909/S909S123100.jsp",
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

	function fn_DetailInfo_List() { //제품검사 체크리스트 목록
    	if(vCheckGubun=="ALL")
    		vCheckGubun="";
    	$.ajax(
    	    {
    	        type: "POST",
    	        url: "<%=Config.this_SERVER_path%>/Contents/Business/M909/S909S123110.jsp",
    	        data: "prod_cd=" + prod_cd + "&prod_cd_rev=" + prod_cd_rev + "&CheckGubun=" + vCheckGubun,
    	        success: function (html) {
    	            $("#Main_contents2").hide().html(html).fadeIn(100);
    	        },
    	        error: function (xhr, option, error) {
    	        }
    	    });
		return;
	}   

    function pop_fn_product_ins_checklist_Insert(obj) {
    	
    	if(prod_cd.length < 1) {
    		heneSwal.warning("제품을 선택하세요");
 			return false;
    	}
    	
    	var modalContentUrl;
    	modalContentUrl = "<%=Config.this_SERVER_path%>/Contents/Business/M909/S909S123101.jsp?prod_cd=" + prod_cd  
    			+ "&prod_cd_rev=" + prod_cd_rev
    			+ "&CheckGubun=" + vCheckGubun;
    	
    	var footer = "";
     	var title  = obj.innerText;
     	var heneModal = new HenesysModal(modalContentUrl, 'large', title, footer);
     	heneModal.open_modal();
     }

    function pop_fn_product_ins_checklist_Update(obj) {
    	if(prod_cd.length < 1){
    		heneSwal.warning("제품을 선택하세요");
 			return false;
    	}
    	var modalContentUrl;
    	modalContentUrl = "<%=Config.this_SERVER_path%>/Contents/Business/M909/S909S123102.jsp?prod_cd=" + prod_cd  
    			+ "&prod_cd_rev=" + prod_cd_rev
    			+ "&CheckGubun=" + vCheckGubun;
    	
		modalFramePopup.setTitle(obj.innerText);
		pop_fn_popUpScr(modalContentUrl, obj.innerText+"(S909S123102)", "680px", "680px");
		return false;
    }

    function pop_fn_product_ins_checklist_Delete(obj) {
    	
    	if(checklist_cd == undefined || checklist_cd.length < 1){
    		heneSwal.warning("삭제할 체크리스트를 선택하세요");
    		return false;
    	}
    	
    	var modalContentUrl;
    	
    	modalContentUrl = "<%=Config.this_SERVER_path%>/Contents/Business/M909/S909S123103.jsp?prod_cd=" + prod_cd 
    			+ "&prod_cd_rev=" 		+ prod_cd_rev 	+ "&product_nm=" 		+ product_nm
    			+ "&checklist_cd=" 		+ checklist_cd 	+ "&checklist_cd_rev= " + checklist_cd_rev
    			+ "&check_note=" 		+ check_note 	+ "&checklist_seq=" 	+checklist_seq 
    			+ "&standard_guide=" 	+ standard_guide + "&standard_value=" 	+ standard_value 
    			+ "&item_desc=" 		+ item_desc 	+ "&item_type=" 		+ item_type 
    			+ "&item_bigo=" 		+ item_bigo		+ "&CheckGubun="		+ vCheckGubun2
    			+ "&pic_seq=" 			+ pic_seq;
    	
    	var footer = "";
     	var title  = obj.innerText;
     	var heneModal = new HenesysModal(modalContentUrl, 'large', title+"(S909S123103)", footer);
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
      	  <button type="button" onclick="pop_fn_product_ins_checklist_Insert(this)" id="insert" class="btn btn-outline-dark">제품별체크리스트 등록</button>
      	  <button type="button" onclick="pop_fn_product_ins_checklist_Delete(this)" id="delete" class="btn btn-outline-danger">제품별체크리스트 삭제</button>
			
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
                           	<td>검사구분 :</td>
<!--                          	<td style='width:3%;  vertical-align: middle'> -->
<!--                          	</td> -->
                             <td>
	                                <select class="form-control" id="select_CheckGubunCode" style="width: 120px">
	                                <%	optCode =  (Vector)CheckGubunVector.get(0);%>
	                                <%	optName =  (Vector)CheckGubunVector.get(1);%>
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