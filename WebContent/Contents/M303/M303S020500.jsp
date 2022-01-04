<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="mes.client.comm.*" %>
<%@ page import="mes.client.common.*" %>
<%@ page import="mes.client.guiComponents.*" %>
<%@ page import="mes.client.util.*" %>
<%@ page import="mes.client.conf.*" %>
<!-- 
급속냉동창고관리
M303S020500.jsp 
-->
<%
	String loginID = session.getAttribute("login_id").toString();
	if(loginID == null || loginID.equals("")) {         // id가 Null 이거나 없을 경우
		response.sendRedirect("Contents/index.jsp");    // 로그인 페이지로 리다이렉트 한다.
	}

	String sMenuTitle = request.getParameter("MenuTitle").toString();
	String sProgramId = request.getParameter("programId").toString();
	String sHeadmenuID= request.getParameter("HeadmenuID").toString();
	String sHeadmenuName= request.getParameter("HeadmenuName").toString();
	
	Get_Program_button_Autho prg_autho = new Get_Program_button_Autho(loginID,sProgramId);
%>  

<script type="text/javascript">
	var manufacturing_date = "";
	var request_rev_no = "";
	var prod_plan_date = "";
	var plan_rev_no = "";
	var product_nm = "";
	var prod_cd = "";
	var prod_rev_no = "";
	var prod_count_on_shelf = "";
	var start_time_freeze = "";
//	var proper_freeze_time = "";
//	var finish_time_freeze = "";
	var inout_status = "";
	var note = "";
	var barcode = "";
	
    $(document).ready(function () {
	    fn_MainInfo_List();
	    
		$("#InfoContentTitle").html("급속냉동창고 선반 목록");
	    fn_MainSubMenuSelect("<%=sMenuTitle%>");
	    fn_tagProcess();
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

    function fn_MainInfo_List() {
        
        $.ajax({
            type: "POST",
            url: "<%=Config.this_SERVER_path%>/Contents/Business/M303/S303S020500.jsp",
            beforeSend: function () {
				$("#MainInfo_List_contents").children().remove();
            },
            success: function (html) {
                $("#MainInfo_List_contents").hide().html(html).fadeIn(100);
            }
        });
    }

    // 선반 입고 등록
    function shelfIn() {
    	var url = "<%=Config.this_SERVER_path%>/Contents/Business/M303/S303S020501.jsp";
    	var footer = '<button id="btn_Save" class="btn-lg btn-info btn-block"' +
		 					 'onclick="ajaxInsertShelf();" style="display:none">입고 등록</button>';
    	var title = '선반 입고 등록';
    	var heneModal = new HenesysModal(url, 'large', title, footer);
    	heneModal.open_modal();
    }
    
 	// 선반 출고 등록
    function shelfOut() {
    	var url = "<%=Config.this_SERVER_path%>/Contents/Business/M303/S303S020521.jsp";
    	var footer = '<button id="btn_Save" class="btn-lg btn-info btn-block"' +
		 					 'onclick="ajaxTakeOutShelf();" style="display:none">출고 등록</button>';
    	var title = '선반 출고 등록';
    	var heneModal = new HenesysModal(url, 'large', title, footer);
    	heneModal.open_modal();
    }
    
    // 선반 입고 수정
    function pop_fn_prod_req_Update(obj){
     
    	if(barcode.length < 1) {
			heneSwal.error("수정할 선반을 선택하세요");
			return false;
		}
    	
    	var url = "<%=Config.this_SERVER_path%>/Contents/Business/M303/S303S020502.jsp?"
    			  + "barcode=" + barcode;
    	var footer = '<button id="btn_Save" class="btn-lg btn-outline-info btn-block"' +
		 					  'onclick="ajaxUpdateShelf();">수정</button>';
    	var title = '선반 입고 수정';
    	var heneModal = new HenesysModal(url, 'large', title, footer);
    	heneModal.open_modal();
    }
    
    // 선반 입고 삭제
    function pop_fn_prod_req_Delete(obj) {
    	
    	if(barcode.length < 1) {
			heneSwal.errorTimer("입고 취소할 선반을 선택하세요 ");
			return false;
		}
    	
    	var dataJson = new Object();
    	dataJson.barcode = barcode;
    	
    	var JSONparam = JSON.stringify(dataJson);
    	
    	var checkRtn = confirm("입고 취소 하시겠습니까?");
    	if(checkRtn) {
    		var msg = '선반 입고 취소';
    		sendToJsp(JSONparam, "M303S020500E103", msg);
    	} else{
    		return false;
    	}
      }
 	
 	function sendToJsp(bomdata, pid, msg) {
		$.ajax({
			type: "POST",
			dataType: "json",
	        url: "<%=Config.this_SERVER_path%>/Contents/CommonView/insert_update_delete_json.jsp", 
	        data: {"bomdata" : bomdata, "pid" : pid},
	        success: function (receive) {
				if(receive > -1) {
					heneSwal.successTimer(msg + '완료');
					fn_MainInfo_List();
				} else {
					heneSwal.errorTimer(msg + '실패, 다시 시도해주세요');
				}
			},
			error: function() {
				heneSwal.errorTimer(msg + '실패, 다시 시도해주세요');
			}
		});
	}
 	
 	// 라벨 출력
    function printLabel(obj) {
    	var url = "<%=Config.this_SERVER_path%>/Contents/Business/M303/S303S020511.jsp";
    	var footer = '<button id="btn_Save" class="btn-lg btn-outline-info btn-block"' +
		 					 'onclick="printStart();">출력</button>';
    	var title = '라벨 출력';
    	var heneModal = new HenesysModal(url, 'standard', title, footer);
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
      		<button type="button" onclick="printLabel(this)" id="insert" class="btn btn-outline-dark">라벨 출력</button>
      		<button type="button" onclick="shelfIn()" id="insert" class="btn btn-outline-dark">선반 입고</button>
      		<button type="button" onclick="shelfOut()" id="insert" class="btn btn-outline-dark">선반 출고</button>
      		<button type="button" onclick="pop_fn_prod_req_Update(this)" id="update" class="btn btn-outline-success">입고 수정</button>
      		<button type="button" onclick="pop_fn_prod_req_Delete(this)" id="delete" class="btn btn-outline-danger">입고 삭제</button>
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
          	<div class="card-tools">
          	</div>
          </div>
          <div class="card-body" id="MainInfo_List_contents"></div> 
        </div>
      </div>
      <!-- /.col-md-6 -->
    </div>
    <!-- /.row -->
  </div><!-- /.container-fluid -->
</div>
<!-- /.content -->