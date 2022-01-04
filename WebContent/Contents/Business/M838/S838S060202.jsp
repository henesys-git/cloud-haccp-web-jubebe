<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="mes.client.comm.*" %>
<%@ page import="mes.client.common.*" %>
<%@ page import="mes.client.guiComponents.*" %>
<%@ page import="mes.client.util.*" %>
<%@ page import="mes.client.conf.*" %>
<%@ page import="org.json.simple.*"%><%@ include file="/strings.jsp" %>
<!DOCTYPE html>
<!-- <html xmlns="http://www.w3.org/1999/xhtml"> -->
<!-- <head id="Head1" > -->
<%
	DoyosaeTableModel TableModel;
	DoyosaeTableModel TableModelPre;
	DoyosaeTableModel PersonModel;
	DoyosaeTableModel ProductModel;
	DoyosaeTableModel PermissionModel;
	DoyosaeTableModel EquipmentModel;

	String loginID = session.getAttribute("login_id").toString();
	String member_key = session.getAttribute("member_key").toString();

	String GV_SUBCONSTRACTOR_NO = "", GV_SUBCONSTRACTOR_REV = "", GV_SUBCONSTRACTOR_SEQ = "", GV_IO_GB = "";
	
	if(request.getParameter("Subcontractor_no")== null)
		GV_SUBCONSTRACTOR_NO ="";
	else
		GV_SUBCONSTRACTOR_NO = request.getParameter("Subcontractor_no");
	
	if(request.getParameter("Subcontractor_rev")== null)
		GV_SUBCONSTRACTOR_REV ="";
	else
		GV_SUBCONSTRACTOR_REV = request.getParameter("Subcontractor_rev");
	
	if(request.getParameter("Subcontractor_seq")== null)
		GV_SUBCONSTRACTOR_SEQ ="";
	else
		GV_SUBCONSTRACTOR_SEQ = request.getParameter("Subcontractor_seq");
	
	if(request.getParameter("Io_gb")== null)
		GV_IO_GB ="";
	else
		GV_IO_GB = request.getParameter("Io_gb");
	
	JSONObject jArray = new JSONObject();
	jArray.put( "subcontractor_no", GV_SUBCONSTRACTOR_NO);
	jArray.put( "subcontractor_rev", GV_SUBCONSTRACTOR_REV);
	jArray.put( "subcontractor_seq", GV_SUBCONSTRACTOR_SEQ);
	jArray.put( "io_gb", GV_IO_GB);
	jArray.put( "member_key", member_key);
	
    TableModel = new DoyosaeTableModel("M838S060200E154", jArray);
    TableModelPre = new DoyosaeTableModel("M838S060200E164", jArray);
    PersonModel = new DoyosaeTableModel("M838S060200E114", jArray);
    ProductModel = new DoyosaeTableModel("M838S060200E124", jArray);
    PermissionModel = new DoyosaeTableModel("M838S060200E134", jArray);
    EquipmentModel = new DoyosaeTableModel("M838S060200E144", jArray);
    
	
 	int RowCount =TableModel.getRowCount();
 	int RowCountPre =TableModelPre.getRowCount();
 	int PersonRowCount =PersonModel.getRowCount();
 	int ProductRowCount =ProductModel.getRowCount();
 	int PermissionRowCount =PermissionModel.getRowCount();
 	int EquipmentRowCount =EquipmentModel.getRowCount();
 	
	StringBuffer html = new StringBuffer();
	
	if(RowCount>0){
		html.append("$('#txt_subcontractor_no').val('" 	+ TableModel.getValueAt(0,0).toString().trim() + "');\n");
		html.append("$('#txt_subcontractor_rev').val('" + TableModel.getValueAt(0,1).toString().trim() + "');\n");
		html.append("$('#txt_subcontractor_name').val('"+ TableModel.getValueAt(0,2).toString().trim() + "');\n");
		html.append("$('#txt_subcontractor_headoffice_address').val('" + TableModel.getValueAt(0,3).toString().trim() + "');\n");
		html.append("$('#txt_headoffice_phone').val('" 	+ TableModel.getValueAt(0,4).toString().trim() + "');\n");
		html.append("$('#txt_subcontractor_ceo').val('" + TableModel.getValueAt(0,5).toString().trim() + "');\n");
		html.append("$('#txt_bizno').val('" 			+ TableModel.getValueAt(0,6).toString().trim() + "');\n");
		html.append("$('#txt_uptae').val('" 			+ TableModel.getValueAt(0,7).toString().trim() + "');\n");
		html.append("$('#txt_jongmok').val('" 			+ TableModel.getValueAt(0,8).toString().trim() + "');\n");
		html.append("$('#txt_faxno').val('" 			+ TableModel.getValueAt(0,9).toString().trim() + "');\n");
		html.append("$('#txt_homepage').val('" 			+ TableModel.getValueAt(0,10).toString().trim() + "');\n");
		html.append("$('#txt_zipno').val('" 			+ TableModel.getValueAt(0,11).toString().trim() + "');\n");
		html.append("$('#txt_dangsa_damdangja').val('" 	+ TableModel.getValueAt(0,12).toString().trim() + "');\n");
		html.append("$('#txt_cust_damdangja').val('" 	+ TableModel.getValueAt(0,13).toString().trim() + "');\n");
		html.append("$('#txt_damdangja_dno').val('" 	+ TableModel.getValueAt(0,14).toString().trim() + "');\n");
		html.append("$('#txt_damdangja_hpno').val('" 	+ TableModel.getValueAt(0,15).toString().trim() + "');\n");
		html.append("$('#txt_damdangja_email').val('" 	+ TableModel.getValueAt(0,16).toString().trim() + "');\n");
		html.append("$('#txt_visit_jugi_day').val('" 	+ TableModel.getValueAt(0,17).toString().trim() + "');\n");		
		html.append("$('input[name=io_gb]').filter(\"input[value='" + TableModel.getValueAt(0,18).toString().trim() + "']\").attr('checked',true);\n");
		html.append("$('#txt_old_cust_cd').val('" 		+ TableModel.getValueAt(0,19).toString().trim() + "');\n");
		html.append("$('#txt_start_date').val('" 		+ TableModel.getValueAt(0,20).toString().trim() + "');\n");
		html.append("$('#txt_write_date').val('" 		+ TableModel.getValueAt(0,21).toString().trim() + "');\n");
		html.append("$('#txt_writor').val('" 			+ TableModel.getValueAt(0,22).toString().trim() + "');\n");
		html.append("$('#txt_modify_date').val('" 		+ TableModel.getValueAt(0,23).toString().trim() + "');\n");
		html.append("$('#txt_modify_user_id').val('" 	+ TableModel.getValueAt(0,24).toString().trim() + "');\n");
		html.append("$('#txt_duration_date').val('" 	+ TableModel.getValueAt(0,25).toString().trim() + "');\n");
		html.append("$('#txt_modify_reason').val('" 	+ TableModel.getValueAt(0,26).toString().trim() + "');\n");
		html.append("$('#txt_refno').val('" 			+ TableModel.getValueAt(0,27).toString().trim() + "');\n");
		html.append("$('#txt_member_key').val('" 		+ TableModel.getValueAt(0,28).toString().trim() + "');\n");
		// ------------------------------------------------------------------------------------------------------------------------//
		if(RowCountPre>0){
			html.append("$('#txt_subcontractor_seq').val('" 			+ TableModelPre.getValueAt(0,2).toString().trim() + "');\n");
			html.append("$('#txt_subcontractor_factory_address').val('" + TableModelPre.getValueAt(0,3).toString().trim() + "');\n");
			html.append("$('#txt_subcontractor_factory_phone').val('" 	+ TableModelPre.getValueAt(0,4).toString().trim() + "');\n");
			html.append("$('#txt_establish_date').val('" 				+ TableModelPre.getValueAt(0,5).toString().trim() + "');\n");
			html.append("$('#txt_factory_scale').val('" 				+ TableModelPre.getValueAt(0,6).toString().trim() + "');\n");
			html.append("$('#txt_checker').val('" 						+ TableModelPre.getValueAt(0,7).toString().trim() + "');\n");
			html.append("$('#txt_check_date').val('" 					+ TableModelPre.getValueAt(0,8).toString().trim() + "');\n");		
			html.append("$('#txt_approval').val('" 						+ TableModelPre.getValueAt(0,9).toString().trim() + "');\n");
			html.append("$('#txt_approve_date').val('" 					+ TableModelPre.getValueAt(0,10).toString().trim() + "');\n");
			html.append("$('input[name=chk_info]').filter(\"input[value='" + TableModelPre.getValueAt(0,11).toString().trim() + "']\").attr('checked',true);\n");
			html.append("$('#txt_member_key').val('" 					+ TableModelPre.getValueAt(0,12).toString().trim() + "');\n");
			html.append("$('#txt_present_rev').val('" 					+ TableModelPre.getValueAt(0,13).toString().trim() + "');\n");
		}                  
		for(int i=0; i<PersonRowCount; i++){
			html.append( "fn_plus_person_body();\n" );
			html.append(" var trInput = $($('#person_tbody tr')[" + i + "]).find(':input');\n");
			html.append(" trInput.eq(1).val('" + PersonModel.getValueAt(i,2).toString().trim() + "');\n");
			html.append(" trInput.eq(2).val('" + PersonModel.getValueAt(i,3).toString().trim() + "');\n");
			html.append(" trInput.eq(3).val('" + PersonModel.getValueAt(i,4).toString().trim() + "');\n");
			html.append(" trInput.eq(4).val('" + PersonModel.getValueAt(i,5).toString().trim() + "');\n");
			html.append(" trInput.eq(5).val('" + PersonModel.getValueAt(i,6).toString().trim() + "');\n");
			html.append(" trInput.eq(6).val('" + PersonModel.getValueAt(i,7).toString().trim() + "');\n");
			html.append(" trInput.eq(7).val('" + PersonModel.getValueAt(i,8).toString().trim() + "');\n");
			html.append(" trInput.eq(8).val('" + PersonModel.getValueAt(i,9).toString().trim() + "');\n");
			html.append(" trInput.eq(9).val('" + PersonModel.getValueAt(i,11).toString().trim() + "');\n");
		}
		for(int i=0; i<ProductRowCount; i++){
			html.append( "fn_plus_product_body();\n" );
			html.append(" var trInput = $($('#product_tbody tr')[" + i + "]).find(':input');\n");
			html.append(" trInput.eq(1).val('" + ProductModel.getValueAt(i,2).toString().trim() + "');\n");
			html.append(" trInput.eq(2).val('" + ProductModel.getValueAt(i,3).toString().trim() + "');\n");
			html.append(" trInput.eq(3).val('" + ProductModel.getValueAt(i,4).toString().trim() + "');\n");
			html.append(" trInput.eq(4).val('" + ProductModel.getValueAt(i,5).toString().trim() + "');\n");
			html.append(" trInput.eq(5).val('" + ProductModel.getValueAt(i,7).toString().trim() + "');\n");
			html.append(" trInput.eq(6).val('" + ProductModel.getValueAt(i,8).toString().trim() + "');\n");
		}
		for(int i=0; i<PermissionRowCount; i++){
			html.append( "fn_plus_permission_body();\n" );
			html.append(" var trInput = $($('#permission_tbody tr')[" + i + "]).find(':input');\n");
			html.append(" trInput.eq(1).val('" + PermissionModel.getValueAt(i,2).toString().trim() + "');\n");
			html.append(" trInput.eq(2).val('" + PermissionModel.getValueAt(i,3).toString().trim() + "');\n");
			html.append(" trInput.eq(3).val('" + PermissionModel.getValueAt(i,4).toString().trim() + "');\n");
			html.append(" trInput.eq(4).val('" + PermissionModel.getValueAt(i,5).toString().trim() + "');\n");
			html.append(" trInput.eq(5).val('" + PermissionModel.getValueAt(i,6).toString().trim() + "');\n");
			html.append(" trInput.eq(6).val('" + PermissionModel.getValueAt(i,8).toString().trim() + "');\n");
			html.append(" trInput.eq(7).val('" + PermissionModel.getValueAt(i,9).toString().trim() + "');\n");
		}
		for(int i=0; i<EquipmentRowCount; i++){
			html.append( "fn_plus_equipment_body();\n" );
			html.append(" var trInput = $($('#equipment_tbody tr')[" + i + "]).find(':input');\n");
			html.append(" trInput.eq(1).val('" + EquipmentModel.getValueAt(i,2).toString().trim() + "');\n");
			html.append(" trInput.eq(2).val('" + EquipmentModel.getValueAt(i,3).toString().trim() + "');\n");
			html.append(" trInput.eq(3).val('" + EquipmentModel.getValueAt(i,4).toString().trim() + "');\n");
			html.append(" trInput.eq(4).val('" + EquipmentModel.getValueAt(i,5).toString().trim() + "');\n");
			html.append(" trInput.eq(5).val('" + EquipmentModel.getValueAt(i,6).toString().trim() + "');\n");
			html.append(" trInput.eq(6).val('" + EquipmentModel.getValueAt(i,8).toString().trim() + "');\n");
			html.append(" trInput.eq(7).val('" + EquipmentModel.getValueAt(i,9).toString().trim() + "');\n");
		}
	}
	
%>
<%-- <jsp:include page="../../Common/linkcss_js.jsp" flush="false"/> --%>
    
    <script type="text/javascript">
//     웹소켓 통신을 위해서 필요한 변수들 ---시작
	var M838S060200E102 = {
			PID:  "M838S060200E102", 
			totalcnt: 0,
			retnValue: 999,
			colcnt: 0,
			colname: ["","","",""], //insert, Update, Delete 문장을 처리할 때는 사용되지않음
			data: []
	};  
	
	var SQL_Param = {
			PID:  "M838S060200E102", 
			excute: "queryProcess",
			stream: "N",
			param: ""
	};
	var GV_RECV_DATA = "";	//웹소켓 onMessage(event)들어온 데이터를 받는 변수
//  웹소켓 통신을 위해서 필요한 변수들 ---끝	
    var detail_seq=1;
   	var vproduct_person_update_table;
    var vproduct_person_update_table_Row_index = -1;
	var vproduct_person_update_table_info;
    var vproduct_person_update_table_RowCount=0;
   	var vproduct_product_update_table;
    var vproduct_product_update_table_Row_index = -1;
	var vproduct_product_update_table_info;
    var vproduct_product_update_table_RowCount=0;
   	var vproduct_permission_update_table;
    var vproduct_permission_update_table_Row_index = -1;
	var vproduct_permission_update_table_info;
    var vproduct_permission_update_table_RowCount=0;
   	var vproduct_equipment_update_table;
    var vproduct_equipment_update_table_Row_index = -1;
	var vproduct_equipment_update_table_info;
    var vproduct_equipment_update_table_RowCount=0;
        
    
    $(document).ready(function () {
    	detail_seq=1;
		// 인원현황 테이블
	    vproduct_person_update_table = $('#person_table').DataTable({
	    	scrollX: true,
		    scrollY: 250,
// 		    scrollCollapse: true,
		    paging: false,
		    searching: false,
		    ordering: false,
		    order: [[ 0, "asc" ]],
		    keys: false,
		    info: true,
		    columnDefs: [
		    	{
		       		'targets': [0],
		       		'createdCell':  function (td) {
		          			$(td).attr('style', 'width:2%;'); 
		       		}
				},
		    	{
		       		'targets': [1],
		       		'createdCell':  function (td) {
		          			$(td).attr('style', 'width:18%;'); 
		       		}
				},
		    	{
		       		'targets': [2,3,4,5,6,7,8], 
		       		'createdCell':  function (td) {
		          			$(td).attr('style', 'width:10%;'); 
		       		}
				},
		    	{
		       		'targets': [9], 
		       		'createdCell':  function (td) {
		          			$(td).attr('style', 'display:none'); 
		       		}
				},
		    	{
		       		'targets': [10],
		       		'createdCell':  function (td) {
		          			$(td).attr('style', 'width:8%;'); 
		       		}
				} 
            ],
            language: { 
                url:"<%=Config.this_SERVER_path%>/AdminLTE-3.0.5/localisation/Korean.json"
             }
		});	    	
    	// 생산능력 테이블
	    vproduct_product_update_table = $('#product_table').DataTable({
	    	scrollX: true,
		    scrollY: 250,
// 		    scrollCollapse: true,
		    paging: false,
		    searching: false,
		    ordering: false,
		    order: [[ 0, "asc" ]],
		    keys: false,
		    info: true,
		    columnDefs: [
		    	{
		       		'targets': [0],
		       		'createdCell':  function (td) {
		          			$(td).attr('style', 'width:2%;'); 
		       		}
				},
		    	{
		       		'targets': [1],
		       		'createdCell':  function (td) {
		          			$(td).attr('style', 'width:30%;'); 
		       		}
				},
		    	{
		       		'targets': [2,3,4], 
		       		'createdCell':  function (td) {
		          			$(td).attr('style', 'width:20%;'); 
		       		}
				},
		    	{
		       		'targets': [5], 
		       		'createdCell':  function (td) {
		          			$(td).attr('style', 'display:none;'); 
		       		}
				},
 		    	{
		       		'targets': [6],
		       		'createdCell':  function (td) {
		          			$(td).attr('style', 'width:13%;'); 
		       		}
				} 
            ],
            language: { 
                url:"<%=Config.this_SERVER_path%>/AdminLTE-3.0.5/localisation/Korean.json"
             }
		});	     	
 
	    // 허가관계 테이블
	    vproduct_permission_update_table = $('#permission_table').DataTable({
	    	scrollX: true,
		    scrollY: 250,
// 		    scrollCollapse: true,
		    paging: false,
		    searching: false,
		    ordering: false,
		    order: [[ 0, "asc" ]],
		    keys: false,
		    info: true,
		    columnDefs: [
		    	{
		       		'targets': [0],
		       		'createdCell':  function (td) {
		          			$(td).attr('style', 'width:2%;'); 
		       		}
				},
		    	{
		       		'targets': [1],
		       		'createdCell':  function (td) {
		          			$(td).attr('style', 'width:30%;'); 
		       		}
				},
		    	{
		       		'targets': [2,3,4,5], 
		       		'createdCell':  function (td) {
		          			$(td).attr('style', 'width:15%;'); 
		       		}
				},
		    	{
		       		'targets': [6], 
		       		'createdCell':  function (td) {
		          			$(td).attr('style', 'display:none;'); 
		       		}
				},
 		    	{
		       		'targets': [7],
		       		'createdCell':  function (td) {
		          			$(td).attr('style', 'width:13%;'); 
		       		}
 		    	}
            ],
            language: { 
                url:"<%=Config.this_SERVER_path%>/AdminLTE-3.0.5/localisation/Korean.json"
             }
		});	  
	    
	    // 설비현황 테이블
	    vproduct_equipment_update_table = $('#equipment_table').DataTable({
	    	scrollX: true,
		    scrollY: 250,
// 		    scrollCollapse: true,
		    paging: false,
		    searching: false,
		    ordering: false,
		    order: [[ 0, "asc" ]],
		    keys: false,
		    info: true,
		    columnDefs: [
		    	{
		       		'targets': [0],
		       		'createdCell':  function (td) {
		          			$(td).attr('style', 'width:2%;'); 
		       		}
				},
		    	{
		       		'targets': [1],
		       		'createdCell':  function (td) {
		          			$(td).attr('style', 'width:30%;'); 
		       		}
				},
		    	{
		       		'targets': [2,3,4,5], 
		       		'createdCell':  function (td) {
		          			$(td).attr('style', 'width:15%;'); 
		       		}
				},
 		    	{
		       		'targets': [6],
		       		'createdCell':  function (td) {
		          			$(td).attr('style', 'display:none;'); 
		       		}
 		    	},
 		    	{
		       		'targets': [7],
		       		'createdCell':  function (td) {
		          			$(td).attr('style', 'width:13%;'); 
		       		}
 		    	}
            ],
            language: { 
                url:"<%=Config.this_SERVER_path%>/AdminLTE-3.0.5/localisation/Korean.json"
             }
		});	  	  	   
	    
    	// 날짜용
        $("#txt_establish_date").datepicker({
        	format: 'yyyy-mm-dd',
        	autoclose: true,
        	language: 'ko'
        });
        $('#txt_account_start_date').datepicker({
        	format: 'yyyy-mm-dd',
        	autoclose: true,
        	language: 'ko'
        });
        $('#txt_write_date').datepicker({
        	format: 'yyyy-mm-dd',
        	autoclose: true,
        	language: 'ko'
        });       
        $('#txt_check_date').datepicker({
        	format: 'yyyy-mm-dd',
        	autoclose: true,
        	language: 'ko'
        });
        $('#txt_approve_date').datepicker({
        	format: 'yyyy-mm-dd',
        	autoclose: true,
        	language: 'ko'
        });
        $('#txt_start_date').datepicker({
        	format: 'yyyy-mm-dd',
        	autoclose: true,
        	language: 'ko'
        });
        for(var i=0; i<vproduct_permission_update_table_RowCount; i++){	            
	        $("'#txt_assessment_date"+ i +"'").datepicker({
	        	format: 'yyyy-mm-dd',
	        	autoclose: true,
	        	language: 'ko'
	        });
        }
        
        var today = new Date();
        var fromday = new Date();
        fromday.setDate(today.getDate());

        new SetSingleDate2("", "#txt_start_date", 0);
		new SetSingleDate2("", "#txt_end_date", 0);
        
	    // 숫자만
	    $("input:text[numberOnly]").on("keyup", function() {
	        $(this).val($(this).val().replace(/[^0-9]/g,""));
	    });
 	    // 인원
   	    $("#btn_plus_person").click(function(){ 
	    	fn_plus_person_body();
	    }); 
	    $("#btn_mius_person").click(function(){ 
	    	fn_mius_person_body(); 
	    }); 
	    // 생산
   	    $("#btn_plus_product").click(function(){ 
	    	fn_plus_product_body();
	    }); 
	    $("#btn_mius_product").click(function(){ 
	    	fn_mius_product_body(); 
	    }); 
	    // 허가
   	    $("#btn_plus_permission").click(function(){ 
	    	fn_plus_permission_body();
	    }); 
	    $("#btn_mius_permission").click(function(){ 
	    	fn_mius_permission_body(); 
	    }); 
	    // 설비
   	    $("#btn_plus_equipment").click(function(){ 
	    	fn_plus_equipment_body();
	    }); 
	    $("#btn_mius_equipment").click(function(){ 
	    	fn_mius_equipment_body(); 
	    }); 
 	    
 	    // 협력업체 정보 숨기기
	    $(function () {
 			var subIndex = 0;
			$('.subcontractor_title').parent().click(function(){
				subIndex++;
				if(subIndex%2 == 1){
					$('.subcontractor td').hide();
					$(this).children().css('background-color', '#f7f7f7');
				} else {							
					$('.subcontractor td').show();
					$(this).children().css('background-color', '#e8e8e8'); 
				}		
			});
		});	 	 
	    $(function () {
 			var subIndex = 0;
			$('.subcontractor_sub_title').parent().click(function(){
				subIndex++;
				if(subIndex%2 == 1){
					$('.subcontractor_sub td').hide();
					$(this).children().css('background-color', '#f7f7f7');
				} else {							
					$('.subcontractor_sub td').show();
					$(this).children().css('background-color', '#e8e8e8'); 
				}		
			});
		});	 	
 	    // 인원현황 숨기기	    
	    $(function () {
 			var personIndex = 0;
			$('.person_title').parent().click(function(){
				personIndex++;
				console.log("personIndex : " + personIndex);
				if(personIndex%2 == 1){
					$('#person_data').hide();
					$(this).children().css('background-color', '#f7f7f7'); 
				} else {							
					$('#person_data').show();
					$(this).children().css('background-color', '#e8e8e8'); 
				}		
			});	 
    	});
		// 주요 품목별 생산능력 숨기기	   
	    $(function () {
 			var productIndex = 0;

			$('.product_title').parent().click(function(){
				productIndex++;
				if(productIndex%2 == 1){
					$('#product_data').hide();
					$(this).children().css('background-color', '#f7f7f7'); 
				} else {							
					$('#product_data').show();
					$(this).children().css('background-color', '#e8e8e8'); 
				}		
			});	 
    	});		
		// 제품인증 허가관계 숨기기f
	    $(function () {
 			var permissonIndex = 0;
			$('.permission_title').parent().click(function(){
				permissonIndex++;
				if(permissonIndex%2 == 1){
					$('#permission_data').hide();
					$(this).children().css('background-color', '#f7f7f7'); 
				} else {							
					$('#permission_data').show();
					$(this).children().css('background-color', '#e8e8e8'); 
				}		
			});	 
    	});		
		// 제조설비현황
	    $(function () {
 			var equipmentIndex = 0;
			$('.equipment_title').parent().click(function(){
				equipmentIndex++;
				if(equipmentIndex%2 == 1){
					$('#equipment_data').hide();
					$(this).children().css('background-color', '#f7f7f7'); 
				} else {							
					$('#equipment_data').show();
					$(this).children().css('background-color', '#e8e8e8'); 
				}		
			});	 
    	});	
		null_chk();
<%-- 		
		// 라디오 버튼 값
	    var ckVal1 = '<%=checkValue1%>';
        $("input[name=chk_info]").filter("input[value='"+ ckVal1 +"']").attr("checked",true);
		 --%>
		<%=html%>
        
        vproduct_person_update_table_info = vproduct_person_update_table.page.info();
        vproduct_person_update_table_RowCount = vproduct_person_update_table_info.recordsTotal;        
        vproduct_product_update_table_info = vproduct_product_update_table.page.info();
     	vproduct_product_update_table_RowCount = vproduct_product_update_table_info.recordsTotal;        
     	vproduct_permission_update_table_info = vproduct_permission_update_table.page.info();
     	vproduct_permission_update_table_RowCount = vproduct_permission_update_table_info.recordsTotal;
     	vproduct_equipment_update_table_info = vproduct_equipment_update_table.page.info();
     	vproduct_equipment_update_table_RowCount = vproduct_equipment_update_table_info.recordsTotal;
	    
    }); // Doc Ready 끝

    
    $('#factory_tbody tr').each(function () {
    	var cellItem = $(this).find(":input")
    	var itemObj = new Object()
    	itemObj.title = cellItem.eq(0).val()
    	itemObj.count = cellItem.eq(1).val()
    	itemObj.info = cellItem.eq(2).val()
    	itemObj.name = cellItem.eq(3).val()
    })
	
	function SetRecvData(){
		DataPars(M838S060200E102, GV_RECV_DATA);  	
 		if(M838S060200E102.retnValue > 0)
 			alert('등록 되었습니다.');
   		
   		parent.fn_MainInfo_List();
   		$('#modalReport').modal('hide');
	}
	
	function SaveOderInfo() {      
		var qa1 = $(':input[name="chk_info"]:radio:checked').val();
		var qa2 = $(':input[name="io_gb"]:radio:checked').val();
		// 현황서
		var dataJson = new Object();			
		dataJson.subcontractor_no					= $('#txt_subcontractor_no').val();
		dataJson.subcontractor_rev					= $('#txt_subcontractor_rev').val();		
		dataJson.subcontractor_name					= $('#txt_subcontractor_name').val();		
		dataJson.subcontractor_headoffice_address	= $('#txt_subcontractor_headoffice_address').val();	
		dataJson.subcontractor_headoffice_phone		= $('#txt_headoffice_phone').val();	
		dataJson.subcontractor_ceo					= $('#txt_subcontractor_ceo').val();		
		dataJson.establish_date						= $('#txt_establish_date').val();	// create_date
		dataJson.account_start_date					= $('#txt_account_start_date').val();
        dataJson.bizno								= $('#txt_bizno').val();
		dataJson.uptae                              = $('#txt_uptae').val();
		dataJson.jongmok                            = $('#txt_jongmok').val();
		dataJson.faxno                              = $('#txt_faxno').val();
		dataJson.homepage                           = $('#txt_homepage').val();
		dataJson.zipno                              = $('#txt_zipno').val();
		dataJson.dangsa_damdangja                   = $('#txt_dangsa_damdangja').val();
		dataJson.cust_damdangja                     = $('#txt_cust_damdangja').val();
		dataJson.damdangja_dno                      = $('#txt_damdangja_dno').val();
		dataJson.damdangja_hpno                     = $('#txt_damdangja_hpno').val();
		dataJson.damdangja_email                    = $('#txt_damdangja_email').val();
		dataJson.visit_jugi_day                     = $('#txt_visit_jugi_day').val();
		dataJson.io_gb                              = qa2;
		dataJson.start_date							= $('#txt_start_date').val();
		dataJson.old_cust_cd                        = $('#txt_old_cust_cd').val();
		dataJson.refno                              = $('#txt_refno').val();
		dataJson.duration_date                      = '9999-12-31';
		dataJson.modify_date						= 'SYSDATE';
		dataJson.modify_user_id						= '<%=loginID%>';
		dataJson.member_key							= '<%=member_key%>';
		dataJson.modify_reason						= $('#txt_modify_reason').val();
		
		// 현황서 기타
		dataJson.subcontractor_seq					= $('#txt_subcontractor_seq').val();
		dataJson.appraisal_means					= qa1;
		dataJson.subcontractor_factory_address		= $('#txt_subcontractor_factory_address').val();
		dataJson.subcontractor_factory_phone		= $('#txt_subcontractor_factory_phone').val();	
		dataJson.factory_scale						= $('#txt_factory_scale').val();
		dataJson.writor								= $('#txt_writor').val();
		dataJson.write_date							= $('#txt_write_date').val();
		dataJson.checker							= $('#txt_checker').val();
		dataJson.check_date							= $('#txt_check_date').val();
		dataJson.approval							= $('#txt_approval').val();
		dataJson.approve_date						= $('#txt_approve_date').val();
		dataJson.present_rev						= $('#txt_present_rev').val();
		// 인원현황
		var personArray = new Array();
        for(var i=0; i<vproduct_person_update_table_RowCount;i++){
        	
    		var trInput = $($("#person_tbody tr")[i]).find(":input");

    		var jsonPerson = new Object(); // jSON Object 선언
    		jsonPerson.lotNo				= trInput.eq(0).val();
//    		jsonPerson.subcontractor_no		= subcon_no;
//    		jsonPerson.subcontractor_seq	= subcon_seq;
    		jsonPerson.person_division		= trInput.eq(1).val();
    		jsonPerson.person_people		= trInput.eq(2).val();
    		jsonPerson.person_desk			= trInput.eq(3).val();
    		jsonPerson.person_technical		= trInput.eq(4).val();
    		jsonPerson.person_product		= trInput.eq(5).val();
    		jsonPerson.person_etc			= trInput.eq(6).val();
    		jsonPerson.person_sum			= trInput.eq(7).val();
    		jsonPerson.person_bigo			= trInput.eq(8).val();
    		jsonPerson.person_rev			= trInput.eq(9).val();
    		jsonPerson.person_seq			= i;
<%--     	jsonPerson.member_key			= '<%=member_key%>'; --%>
    		personArray.push(jsonPerson);    
        }
        dataJson.person = personArray;
                		
		var productArray = new Array();
        for(var i=0; i<vproduct_product_update_table_RowCount;i++){
        	
    		var trInput = $($("#product_tbody tr")[i]).find(":input");
    				
    		if(trInput.eq(1).val()== '' ) { 
    			alert("제품을 입력하여 주세요");
    			return false;
    		}
    		var jsonProduct = new Object(); // jSON Object 선언
    		jsonProduct.lotNo				= trInput.eq(0).val();
//   		jsonProduct.subcontractor_no	= subcon_no;
//    		jsonProduct.subcontractor_seq	= subcon_seq;
            jsonProduct.product_division	= trInput.eq(1).val();
    		jsonProduct.product_measure		= trInput.eq(2).val();
    		jsonProduct.product_capacity	= trInput.eq(3).val();
    		jsonProduct.product_bigo		= trInput.eq(4).val();
    		jsonProduct.product_rev			= trInput.eq(5).val();
    		jsonProduct.product_seq			= i;
<%--     	jsonProduct.member_key			= '<%=member_key%>'; --%>
    		productArray.push(jsonProduct);    
            
        }	
        dataJson.product = productArray;        
        
		// 허가관계
		var permissionArray = new Array();
        for(var i=0; i<vproduct_permission_update_table_RowCount;i++){
        	
    		var trInput = $($("#permission_tbody tr")[i]).find(":input");
    				
    		if(trInput.eq(2).val()== '' ) { 
    			alert("품명을 입력하여 주세요");
    			return false;
    		}
    		var jsonPermission = new Object(); // jSON Object 선언
    		jsonPermission.lotNo				= trInput.eq(0).val();
//    		jsonPermission.subcontractor_no		= subcon_no;
//    		jsonPermission.subcontractor_seq	= subcon_seq;
<%--     	jsonPermission.member_key			= '<%=member_key%>'; --%>
    		jsonPermission.permission_division	= trInput.eq(1).val();
    		jsonPermission.permission_name		= trInput.eq(2).val();
    		jsonPermission.permission_institute	= trInput.eq(3).val();
    		jsonPermission.permission_date		= trInput.eq(4).val();
    		jsonPermission.permission_bigo		= trInput.eq(5).val();
    		jsonPermission.permission_rev		= trInput.eq(6).val();;
    		jsonPermission.permission_seq		= i;
    		permissionArray.push(jsonPermission);    
        }	
        dataJson.permission = permissionArray;		
        
		// 설비현황
		var equipmentArray = new Array();
        for(var i=0; i<vproduct_equipment_update_table_RowCount;i++){
        	
    		var trInput = $($("#equipment_tbody tr")[i]).find(":input");
    				
    		if(trInput.eq(1).val()== '' ) { 
    			alert("설비명을 입력하여 주세요");
    			return false;
    		}
    		var jsonEquipment = new Object(); // jSON Object 선언
    		jsonEquipment.lotNo						= trInput.eq(0).val();
//    		jsonEquipment.subcontractor_no			= subcon_no;
//    		jsonEquipment.subcontractor_seq			= seq;
<%-- 		jsonEquipment.member_key				= '<%=member_key%>'; --%>
    		jsonEquipment.equipment_name			= trInput.eq(1).val();
    		jsonEquipment.equipment_standard		= trInput.eq(2).val();
    		jsonEquipment.equipment_manufacturer	= trInput.eq(3).val();
    		jsonEquipment.equipment_have			= trInput.eq(4).val();
    		jsonEquipment.equipment_bigo			= trInput.eq(5).val();  
    		jsonEquipment.equipment_rev				= trInput.eq(6).val();
    		jsonEquipment.equipment_seq				= i;
    		equipmentArray.push(jsonEquipment);    
        }	
        dataJson.equipment = equipmentArray;

        var work_complete_update_check = confirm("수정하시겠습니까?");
        if(work_complete_update_check == false)   return;
        
        var JSONparam = JSON.stringify(dataJson);
//        console.log(JSONparam);
		SendTojsp(JSONparam, SQL_Param.PID); // SendToJSP를 통해 ajax로 데이터(JSONObject,PID) 보냄
	}

	function SendTojsp(bomdata, pid){
		
	    $.ajax({
	         type: "POST",
	         dataType: "json", // Ajax로 json타입으로 보낸다.
	     	 url: "<%=Config.this_SERVER_path%>/Contents/CommonView/insert_update_delete_json.jsp", // insert_update_delete_json.jsp로 연결
	     	 data:  {"bomdata" : bomdata, "pid" : pid },
	         beforeSend: function () {
//	         	 alert(bomdata);
	         },
	         
	         success: function (html) {	 
	        	 if(html>-1){
	        	   	parent.fn_MainInfo_List();
	                parent.$("#ReportNote").children().remove();
	                $('#modalReport').modal('hide');
	         		fn_DetailInfo_List();
	         	}
	         },
	         error: function (xhr, option, error) {

	         }
	     });		
	}  
	
    function fn_CommonPopupModal(sUrl, name, w, h) { // url, name, width, height, 기타 속성(생략해도 무방)     	
        var popupWin = window.showModalDialog(sUrl, name, 'dialogWidth:' + w + 'px; dialogHeight:' + h 
                + 'px; center:yes; help:no; status:no; resizable:no; scroll:yes; toolbar :no;');
    	if(typeof(popupWin)=="undefine")
    		popupWin = window.returnValue;
		return popupWin;
    }  
    
    function SetCustName_code(name, code, rev){
    	alert(code);
		$('#txt_custname').val(name);
		$('#txt_custcode').val(code);
		$('#txt_cust_rev').val(rev);

    	alert(code);
		
    }
    
    function SetCustProjectInfo(cust_cd, cust_nm, project_name, cust_pono, prod_cd, product_nm, cust_rev, projrctCnt){
		$('#txt_projrctName').val(project_name);
		$('#txt_custname').val(cust_nm);
		$('#txt_projrctCnt').val(projrctCnt);
		
		$('#txt_custcode').val(cust_cd);
		$('#txt_cust_rev').val(cust_rev);
		$('#txt_cust_poNo').val(cust_pono);
		
    }
    // 주소입력
    var loc = "";
    function pop_add_headoffice_search(obj) {    	
    	modalContentUrl = "<%=Config.this_SERVER_path%>/Contents/Business/M909/S909S150106.jsp";
    	loc = 0;
//    	alert(loc);
    	pop_fn_popUpScr_nd(modalContentUrl, obj.innerText+"주소검색(S909S150106)", "1080px", "1080px");
     }    
    function pop_add_factory_search(obj) {
    	loc = 1;
    	alert(loc);
    	modalContentUrl = "<%=Config.this_SERVER_path%>/Contents/Business/M909/S909S150106.jsp";
    	pop_fn_popUpScr_nd(modalContentUrl, obj.innerText+"주소검색(S909S150106)", "1080px", "1080px");
     }
    function pop_add_user_search(obj) {    	
    	modalContentUrl = "<%=Config.this_SERVER_path%>/Contents/CommonView/UserListView.jsp";
    	pop_fn_popUpScr_nd(modalContentUrl, obj.innerText+"사용자검색", "1080px", "1080px");
     }
    // 본사주소 받아오기
	function SetAddList_code(sido_name, sigungu_name, eupmyondong_name, road_name, building_main_no, building_sub_no, sigungu_building_name, detail_address, add_no, postcode){
//  	alert(loc);
     	if(loc == "0"){
			$("#txt_subcontractor_headoffice_address").val(sido_name + " " + sigungu_name + " " + eupmyondong_name + " " + road_name + " " + building_main_no + "-" + building_sub_no + " " + sigungu_building_name + " " + detail_address);
    	} else {
    		$("#txt_subcontractor_factory_address").val(sido_name + " " + sigungu_name + " " + eupmyondong_name + " " + road_name + " " + building_main_no + "-" + building_sub_no + " " + sigungu_building_name + " " + detail_address);
    	} 
	}
    // 우편번호 받아오기
    function SetPostcode(postcode){
     	$("#txt_Zipno").val(postcode);
    }
    
    function SetUser_Select(user_id, revision_no, user_nm){
//    	console.log("??? : " + user_id +" ~ "+ revision_no + " ~ " + user_nm);
		$("#"+ rowId).val(user_id);
		$("#"+ rowId + "_rev").val(revision_no);
	}
    
    // 인원현황 입력창 추가/제거
    function fn_plus_person_body(){
    	vproduct_person_update_table.row.add( [
    		"	<input type='text' class='form-control' id='txt_detail_seq'  style='width:30px;' readonly></input>",
    		"	<input type='text' class='form-control' id='txt_personDivision"+ vproduct_person_update_table_RowCount +"' style='float:left; width:95%;'></input>",
    		"	<input type='text' class='form-control' numberOnly id='txt_personPeople"+ vproduct_person_update_table_RowCount +"' style='float:left; width:95%;'></input>",
    		"	<input type='text' class='form-control' numberOnly id='txt_personDesk"+ vproduct_person_update_table_RowCount +"' style='float:left; width:95%;'></input>",
    		"	<input type='text' class='form-control' numberOnly id='txt_personTechnicial"+ vproduct_person_update_table_RowCount +"' style='float:left; width:95%;'></input>",
    		"	<input type='text' class='form-control' numberOnly id='txt_personProduct"+ vproduct_person_update_table_RowCount +"' style='float:left; width:95%;'></input>",
    		"	<input type='text' class='form-control' numberOnly id='txt_personEtc"+ vproduct_person_update_table_RowCount +"' style='float:left; width:95%;'></input>",
    		"	<input type='text' class='form-control' numberOnly id='txt_personSum"+ vproduct_person_update_table_RowCount +"' style='float:left; width:95%;'></input>",
    		"	<input type='text' class='form-control' id='txt_personBigo"+ vproduct_person_update_table_RowCount +"' style='float:left; width:95%;'></input>",
    		"	<input type='text' class='form-control' id='txt_person_rev"+ vproduct_product_update_table_RowCount +"' style='float:left; width:95%; display:none'></input>",
    		""
        ] ).draw();
    	
	    // 숫자만
	    $("input:text[numberOnly]").on("keyup", function() {
	        $(this).val($(this).val().replace(/[^0-9]/g,""));
	    });
	    
        vproduct_person_update_table_info = vproduct_person_update_table.page.info();
        vproduct_person_update_table_RowCount = vproduct_person_update_table_info.recordsTotal; 	
        
		var trInput = $($("#person_tbody tr")[vproduct_person_update_table_RowCount-1]).find(":input");
		trInput.eq(0).val(vproduct_person_update_table_RowCount);
		var vSerialNo =  "00000" + "1";
		var vLotNo = trInput.eq(6).val();
		
	    for(i=0;i<vproduct_person_update_table_RowCount;i++){
	    	$('input[id=dateDelevery]').eq(i).datepicker({
	        	format: 'yyyy-mm-dd',
	        	autoclose: true,
	        	language: 'ko'
	        });
	    }
	    
	    for(i=0;i<vproduct_person_update_table_RowCount;i++){
	    	$('input[id=dateChulgo]').eq(i).datepicker({
	        	format: 'yyyy-mm-dd',
	        	autoclose: true,
	        	language: 'ko'
	        });
	    }	

		$("#txt_LOTNo"+(vproduct_person_update_table_RowCount-1)).on('change', function(){ 
	        vproduct_person_update_table_info = vproduct_person_update_table.page.info();
	        vproduct_person_update_table_RowCount = vproduct_person_update_table_info.recordsTotal; 
	    		
	        vLotNo = trInput.eq(6).val();
	        
	    	trInput.eq(5).val(vLotNo + "-" + vSerialNo.slice(-4));
	    }); 
		$("#txt_LOTCount"+(vproduct_person_update_table_RowCount-1)).on('change', function(){ 
	        vproduct_person_update_table_info = vproduct_person_update_table.page.info();
	        vproduct_person_update_table_RowCount = vproduct_person_update_table_info.recordsTotal; 
	    	
	        vLotNo = trInput.eq(6).val();
	    	vSerialNo =  "00000" + trInput.eq(7).val();
	    	trInput.eq(14).val(vLotNo + "-" + vSerialNo.slice(-4));
	    }); 
		
    }

    
    function fn_mius_person_body(){  	        
        vproduct_person_update_table
        .row( vproduct_person_update_table_RowCount-1 )
        .remove()
        .draw();

        vproduct_person_update_table_info = vproduct_person_update_table.page.info();
        vproduct_person_update_table_RowCount = vproduct_person_update_table_info.recordsTotal;
        
    }   
    
    // 생산계획 입력창 추가/제거
    function fn_plus_product_body(){
    	vproduct_product_update_table.row.add( [
    		"	<input type='text' class='form-control' id='txt_detail_seq'  style='width:30px;' readonly></input>",
    		"	<input type='text' class='form-control' id='txt_productDivision"+ vproduct_product_update_table_RowCount +"' style='float:left; width:95%;'></input>",
    		"	<input type='text' class='form-control' id='txt_productMeasure"+ vproduct_product_update_table_RowCount +"' style='float:left; width:95%;'></input>",
    		"	<input type='text' class='form-control' numberOnly id='txt_productCapacity"+ vproduct_product_update_table_RowCount +"' style='float:left; width:95%;'></input>",
    		"	<input type='text' class='form-control' id='txt_productBigo"+ vproduct_product_update_table_RowCount +"' style='float:left; width:95%;'></input>",
    		"	<input type='text' class='form-control' id='txt_product_rev"+ vproduct_product_update_table_RowCount +"' style='float:left; width:95%; display:none;'></input>",
    		""
        ] ).draw();
    	
	    // 숫자만
	    $("input:text[numberOnly]").on("keyup", function() {
	        $(this).val($(this).val().replace(/[^0-9]/g,""));
	    });
	    
        vproduct_product_update_table_info = vproduct_product_update_table.page.info();
        vproduct_product_update_table_RowCount = vproduct_product_update_table_info.recordsTotal; 	
        
		var trInput = $($("#product_tbody tr")[vproduct_product_update_table_RowCount-1]).find(":input");
		trInput.eq(0).val(vproduct_product_update_table_RowCount);
		var vSerialNo =  "00000" + "1";
		var vLotNo = trInput.eq(6).val();
		
	    for(i=0;i<vproduct_product_update_table_RowCount;i++){
	    	$('input[id=dateDelevery]').eq(i).datepicker({
	        	format: 'yyyy-mm-dd',
	        	autoclose: true,
	        	language: 'ko'
	        });
	    }

		$("#txt_LOTNo"+(vproduct_product_update_table_RowCount-1)).on('change', function(){ 
	        vproduct_product_update_table_info = vproduct_product_update_table.page.info();
	        vproduct_product_update_table_RowCount = vproduct_product_update_table_info.recordsTotal; 
	    		
	        vLotNo = trInput.eq(6).val();
	        
	    	trInput.eq(5).val(vLotNo + "-" + vSerialNo.slice(-4));
	    }); 
		$("#txt_LOTCount"+(vproduct_product_update_table_RowCount-1)).on('change', function(){ 
	        vproduct_product_update_table_info = vproduct_product_update_table.page.info();
	        vproduct_product_update_table_RowCount = vproduct_product_update_table_info.recordsTotal; 
	    	
	        vLotNo = trInput.eq(6).val();
	    	vSerialNo =  "00000" + trInput.eq(7).val();
	    	trInput.eq(14).val(vLotNo + "-" + vSerialNo.slice(-4));
	    }); 
		
    }
    
    function fn_mius_product_body(){  	        
        vproduct_product_update_table
        .row( vproduct_product_update_table_RowCount-1 )
        .remove()
        .draw();

        vproduct_product_update_table_info = vproduct_product_update_table.page.info();
        vproduct_product_update_table_RowCount = vproduct_product_update_table_info.recordsTotal;
        
    }   

    
    // 허가관계 입력창 추가/제거
    function fn_plus_permission_body(){
    	vproduct_permission_update_table.row.add( [
    		"	<input type='text' class='form-control' id='txt_detail_seq'  style='width:30px;' readonly></input>",
    		"	<input type='text' class='form-control' id='txt_permissionDivision"+ vproduct_permission_update_table_RowCount +"' style='float:left; width:95%;'></input>",
    		"	<input type='text' class='form-control' id='txt_permissionName"+ vproduct_permission_update_table_RowCount +"' style='float:left; width:95%;'></input>",
    		"	<input type='text' class='form-control' id='txt_permissionInstitute"+ vproduct_permission_update_table_RowCount +"' style='float:left; width:95%;'></input>",
    		"	<input type='text' class='form-control' id='txt_permissionDate"+ vproduct_permission_update_table_RowCount +"' style='float:left; width:95%;'></input>",
    		"	<input type='text' class='form-control' id='txt_permissionBigo"+ vproduct_permission_update_table_RowCount +"' style='float:left; width:95%;'></input>",
    		"	<input type='text' class='form-control' id='txt_permission_rev"+ vproduct_permission_update_table_RowCount +"' style='float:left; width:95%; display:none;'></input>",
    		""
        ] ).draw();
    	
	    // 숫자만
	    $("input:text[numberOnly]").on("keyup", function() {
	        $(this).val($(this).val().replace(/[^0-9]/g,""));
	    });
	    
        vproduct_permission_update_table_info = vproduct_permission_update_table.page.info();
        vproduct_permission_update_table_RowCount = vproduct_permission_update_table_info.recordsTotal; 	
        
		var trInput = $($("#permission_tbody tr")[vproduct_permission_update_table_RowCount-1]).find(":input");
		trInput.eq(0).val(vproduct_permission_update_table_RowCount);
		var vSerialNo =  "00000" + "1";
		var vLotNo = trInput.eq(6).val();
		
	    for(i=0;i<vproduct_permission_update_table_RowCount;i++){
	    	$('input[id=dateDelevery]').eq(i).datepicker({
	        	format: 'yyyy-mm-dd',
	        	autoclose: true,
	        	language: 'ko'
	        });
	    }
	    
	    for(i=0;i<vproduct_permission_update_table_RowCount;i++){
	    	$('input[id=dateChulgo]').eq(i).datepicker({
	        	format: 'yyyy-mm-dd',
	        	autoclose: true,
	        	language: 'ko'
	        });
	    }	

		$("#txt_LOTNo"+(vproduct_permission_update_table_RowCount-1)).on('change', function(){ 
	        vproduct_permission_update_table_info = vproduct_permission_update_table.page.info();
	        vproduct_permission_update_table_RowCount = vproduct_permission_update_table_info.recordsTotal; 
	    		
	        vLotNo = trInput.eq(6).val();
	        
	    	trInput.eq(5).val(vLotNo + "-" + vSerialNo.slice(-4));
	    }); 
		$("#txt_LOTCount"+(vproduct_permission_update_table_RowCount-1)).on('change', function(){ 
	        vproduct_permission_update_table_info = vproduct_permission_update_table.page.info();
	        vproduct_permission_update_table_RowCount = vproduct_permission_update_table_info.recordsTotal; 
	    	
	        vLotNo = trInput.eq(6).val();
	    	vSerialNo =  "00000" + trInput.eq(7).val();
	    	trInput.eq(14).val(vLotNo + "-" + vSerialNo.slice(-4));
	    }); 
		
    }

    
    function fn_mius_permission_body(){  	        
        vproduct_permission_update_table
        .row( vproduct_permission_update_table_RowCount-1 )
        .remove()
        .draw();

        vproduct_permission_update_table_info = vproduct_permission_update_table.page.info();
        vproduct_permission_update_table_RowCount = vproduct_permission_update_table_info.recordsTotal;
        
    }   
        

    
    
    // 제조설비 입력창 추가/제거
    function fn_plus_equipment_body(){
    	vproduct_equipment_update_table.row.add( [
    		"	<input type='text' class='form-control' id='txt_detail_seq'  style='width:30px;' readonly></input>",
    		"	<input type='text' class='form-control' id='txt_equipmentName"+ vproduct_equipment_update_table_RowCount +"' style='float:left; width:95%;'></input>",
    		"	<input type='text' class='form-control' id='txt_equipmentStandard"+ vproduct_equipment_update_table_RowCount +"' style='float:left; width:95%;'></input>",
    		"	<input type='text' class='form-control' id='txt_equipmentManufacturer"+ vproduct_equipment_update_table_RowCount +"' style='float:left; width:95%;'></input>",
    		"	<input type='text' class='form-control' numberOnly id='txt_equipmentHave"+ vproduct_equipment_update_table_RowCount +"' style='float:left; width:95%;'></input>",
    		"	<input type='text' class='form-control' id='txt_equipmentBigo"+ vproduct_equipment_update_table_RowCount +"' style='float:left; width:95%;'></input>",
    		"	<input type='text' class='form-control' id='txt_equipment_rev"+ vproduct_equipment_update_table_RowCount +"' style='float:left; width:95%; display:none;'></input>",
    		""
        ] ).draw();
    	
	    // 숫자만
	    $("input:text[numberOnly]").on("keyup", function() {
	        $(this).val($(this).val().replace(/[^0-9]/g,""));
	    });
	    
        vproduct_equipment_update_table_info = vproduct_equipment_update_table.page.info();
        vproduct_equipment_update_table_RowCount = vproduct_equipment_update_table_info.recordsTotal; 	
        
		var trInput = $($("#equipment_tbody tr")[vproduct_equipment_update_table_RowCount-1]).find(":input");
		trInput.eq(0).val(vproduct_equipment_update_table_RowCount);
		var vSerialNo =  "00000" + "1";
		var vLotNo = trInput.eq(6).val();
		
	    for(i=0;i<vproduct_equipment_update_table_RowCount;i++){
	    	$('input[id=dateDelevery]').eq(i).datepicker({
	        	format: 'yyyy-mm-dd',
	        	autoclose: true,
	        	language: 'ko'
	        });
	    }
	    
	    for(i=0;i<vproduct_equipment_update_table_RowCount;i++){
	    	$('input[id=dateChulgo]').eq(i).datepicker({
	        	format: 'yyyy-mm-dd',
	        	autoclose: true,
	        	language: 'ko'
	        });
	    }	

		$("#txt_LOTNo"+(vproduct_equipment_update_table_RowCount-1)).on('change', function(){ 
	        vproduct_equipment_update_table_info = vproduct_equipment_update_table.page.info();
	        vproduct_equipment_update_table_RowCount = vproduct_equipment_update_table_info.recordsTotal; 
	    		
	        vLotNo = trInput.eq(6).val();
	        
	    	trInput.eq(5).val(vLotNo + "-" + vSerialNo.slice(-4));
	    }); 
		$("#txt_LOTCount"+(vproduct_equipment_update_table_RowCount-1)).on('change', function(){ 
	        vproduct_equipment_update_table_info = vproduct_equipment_update_table.page.info();
	        vproduct_equipment_update_table_RowCount = vproduct_equipment_update_table_info.recordsTotal; 
	    	
	        vLotNo = trInput.eq(6).val();
	    	vSerialNo =  "00000" + trInput.eq(7).val();
	    	trInput.eq(14).val(vLotNo + "-" + vSerialNo.slice(-4));
	    }); 
		
    }
    
    function fn_mius_equipment_body(){  	        
        vproduct_equipment_update_table
        .row( vproduct_equipment_update_table_RowCount-1 )
        .remove()
        .draw();

        vproduct_equipment_update_table_info = vproduct_equipment_update_table.page.info();
        vproduct_equipment_update_table_RowCount = vproduct_equipment_update_table_info.recordsTotal;
        
    }   
    
	// input 필드 null 여부 체크 
    function null_chk(){
		var chk1 = "#txt_subcontractor_no";
		var null_chk1 = '#subcontractor_no_null_chk';
       	$(null_chk1).val(" ✔");
        $(null_chk1).css("background-color", "lightgreen");	  	    
	    $(chk1).change(function(){	    	
	        if($(chk1).val() != ''){	        	
	        	$(null_chk1).val(" ✔");
		        $(null_chk1).css("background-color", "lightgreen");	
	        } else {
	        	$(null_chk1).val(" ✘");
	        	$(null_chk1).css("background-color", "tomato");	
	        }	    	
	    });
		var chk2 = "#txt_subcontractor_name";
		var null_chk2 = '#subcontractor_name_null_chk';
       	$(null_chk2).val(" ✔");
        $(null_chk2).css("background-color", "lightgreen");	
	    $(chk2).change(function(){	    	
	        if($(chk2).val() != ''){	        	
	        	$(null_chk2).val(" ✔");
		        $(null_chk2).css("background-color", "lightgreen");	
	        } else {
	        	$(null_chk2).val(" ✘");
	        	$(null_chk2).css("background-color", "tomato");	
	        }	    	
	    });
    }
    </script>

<div style="overflow-y: scroll; max-height: 700px;">
<!-- <form name="form1S909S050101" method="post" enctype="multipart/form-data" action="">  -->
   <table class="table table-bordered" style="width: 100%; margin: 0 auto; align:left">
   	<tr>   
   	
		<td style="width: 70%;">
   			<table class="table table-bordered" style="width: 100%; margin: 0 auto; align:left">
   					        
		        <!-- 구분선 --------------------------------------------------------------------------------------------------------------------------------------------------------------------- -->   		
		        <tr>
					<td class="subcontractor_title" style=" font-weight: 900; font-size:16px; text-align:left; background:#e8e8e8;" colspan="8">협력업체 정보</td>
				</tr>   			
		        <tr class="subcontractor" style="background-color: #fff;">
		            <td style=" font-weight: 900; font-size:14px; text-align:left" >협력업체 등록번호</td>
		            <td colspan="3">
		            	<input type="text" id="txt_subcontractor_no" class="form-control" style="width: 365px; border: solid 1px #cccccc; float: left;" disabled/>
		            	<input type="text" id="txt_subcontractor_rev" class="form-control" style="width: 365px; border: solid 1px #cccccc; float: left; display:none;" value="0"/>
		            	<input type="text" id="txt_subcontractor_seq" class="form-control" style="width: 365px; border: solid 1px #cccccc; float: left; display:none;" value="0" />
		            	<input type="text" id="txt_member_key" class="form-control" style="width: 365px; border: solid 1px #cccccc; float: left; display:none;" />		          
		            	<input type="text" id="subcontractor_no_null_chk" class="form-control" style="width: 35px; border: solid 1px #cccccc;" disabled/>
		            </td>
		            <td style=" font-weight: 900; font-size:14px; text-align:left" >협력업체명</td>
		            <td colspan="3"> 
		            	<input type="text" id="txt_subcontractor_name" class="form-control" style="width: 365px; border: solid 1px #cccccc; float: left;" />
		            	<input type="text" id="subcontractor_name_null_chk" class="form-control" style="width: 35px; border: solid 1px #cccccc;" disabled/>						
		            </td>
		        </tr>
		        
		        <tr class="subcontractor" style="background-color: #fff" >
		            <td style=" font-weight: 900; font-size:14px; text-align:left" >본사주소</td>
		            <td colspan="3"><input type="text" class="form-control" id="txt_subcontractor_headoffice_address" style="width: 400px; float:left;"/>
           			&nbsp;&nbsp;<input type="button" class="btn btn-info" onclick="pop_add_headoffice_search(this);" value="검색"></input></td>		        

		            <td style=" font-weight: 900; font-size:14px; text-align:left" >본사전화번호</td>
		            <td  colspan="3"> <input type="text" data-date-format="yyyy-mm-dd" id="txt_headoffice_phone" class="form-control" style="width: 400px; border: solid 1px #cccccc;" /></td>		       
		        </tr>
		        <tr class="subcontractor" style="background-color: #fff" >
		            <td style=" font-weight: 900; font-size:14px; text-align:left" >대표자명</td> 
		           	<td  colspan="3"> <input type="text" data-date-format="yyyy-mm-dd" id="txt_subcontractor_ceo" class="form-control" style="width: 400px; border: solid 1px #cccccc;" /></td>
		            <td style=" font-weight: 900; font-size:14px; text-align:left" >사업자번호</td> 
		           	<td  colspan="3"> <input type="text" data-date-format="yyyy-mm-dd" id="txt_bizno" class="form-control" style="width: 400px; border: solid 1px #cccccc;" disabled/></td>		           	 			
		        </tr>

		        <tr class="subcontractor" style="background-color: #fff" >
		            <td style=" font-weight: 900; font-size:14px; text-align:left" >업태</td>
		            <td  colspan="3"> <input type="text" data-date-format="yyyy-mm-dd" id="txt_uptae" class="form-control" style="width: 400px; border: solid 1px #cccccc;" /></td>		  
		            <td style=" font-weight: 900; font-size:14px; text-align:left" >종목</td> 
		           	<td  colspan="3"> <input type="text" data-date-format="yyyy-mm-dd" id="txt_jongmok" class="form-control" style="width: 400px; border: solid 1px #cccccc;" /></td>		                 
		        </tr>

		        <tr class="subcontractor" style="background-color: #fff" >
		            <td style=" font-weight: 900; font-size:14px; text-align:left" >팩스번호</td>
		            <td  colspan="3"> <input type="text" data-date-format="yyyy-mm-dd" id="txt_faxno" class="form-control" style="width: 400px; border: solid 1px #cccccc;" /></td>		
		            <td style=" font-weight: 900; font-size:14px; text-align:left" >홈페이지</td> 
		           	<td  colspan="3"> <input type="text" data-date-format="yyyy-mm-dd" id="txt_homepage" class="form-control" style="width: 400px; border: solid 1px #cccccc;" /></td>		                   
		        </tr>
		        
		        <tr class="subcontractor" style="background-color: #fff" >
		            <td style=" font-weight: 900; font-size:14px; text-align:left" >우편번호</td>
		            <td  colspan="3"> <input type="text" data-date-format="yyyy-mm-dd" id="txt_zipno" class="form-control" style="width: 400px; border: solid 1px #cccccc;" /></td>
		            <td style=" font-weight: 900; font-size:14px; text-align:left" >당사담당자</td> 
		           	<td  colspan="3"> <input type="text" data-date-format="yyyy-mm-dd" id="txt_dangsa_damdangja" class="form-control" style="width: 400px; border: solid 1px #cccccc;" /></td>		       
		        </tr>
	
		        <tr class="subcontractor" style="background-color: #fff" >
		            <td style=" font-weight: 900; font-size:14px; text-align:left" >고객사담당자</td>
		            <td  colspan="3"> <input type="text" data-date-format="yyyy-mm-dd" id="txt_cust_damdangja" class="form-control" style="width: 400px; border: solid 1px #cccccc;" /></td>		      
		            <td style=" font-weight: 900; font-size:14px; text-align:left" >담당자전화번호</td> 
		           	<td  colspan="3"> <input type="text" data-date-format="yyyy-mm-dd" id="txt_damdangja_dno" class="form-control" style="width: 400px; border: solid 1px #cccccc;" /></td> 
		        </tr>	        

  		        <tr class="subcontractor" style="background-color: #fff" >
		            <td style=" font-weight: 900; font-size:14px; text-align:left" >담당자휴대전화</td>
		            <td  colspan="3"> <input type="text" data-date-format="yyyy-mm-dd" id="txt_damdangja_hpno" class="form-control" style="width: 400px; border: solid 1px #cccccc;" /></td>		       
		            <td style=" font-weight: 900; font-size:14px; text-align:left" >담당자이메일</td> 
		           	<td  colspan="3"> <input type="text" data-date-format="yyyy-mm-dd" id="txt_damdangja_email" class="form-control" style="width: 400px; border: solid 1px #cccccc;" /></td>
		        </tr>

  		        <tr class="subcontractor" style="background-color: #fff" >
		            <td style=" font-weight: 900; font-size:14px; text-align:left" >방문주기</td>
		            <td  colspan="3"> <input type="text" data-date-format="yyyy-mm-dd" id="txt_visit_jugi_day" class="form-control" style="width: 400px; border: solid 1px #cccccc;" /></td>		    
		            <td style=" font-weight: 900; font-size:14px; text-align:left" >매입매출구분</td> 
		           	<td>
						<input type="radio" id="txt_io_gb" name="io_gb" value="I" checked/>입고
						<label style="width:5%"></label>
						<input type="radio" id="txt_io_gb" name="io_gb" value="O"/>  출고
					</td>             
		        </tr>
		        
  		        <tr class="subcontractor" style="background-color: #fff" >
		            <td style=" font-weight: 900; font-size:14px; text-align:left" >(구)회사명</td>
		            <td  colspan="3"> <input type="text" data-date-format="yyyy-mm-dd" id="txt_old_cust_cd" class="form-control" style="width: 400px; border: solid 1px #cccccc;" /></td>		
		            <td style=" font-weight: 900; font-size:14px; text-align:left" >거래개시일</td>
		            <td  colspan="3"> <input type="text" data-date-format="yyyy-mm-dd" id="txt_start_date" class="form-control" style="width: 400px; border: solid 1px #cccccc;" disabled/></td>	       
		        </tr>		        
  		        <tr class="subcontractor" style="background-color: #fff" >
		            <td style=" font-weight: 900; font-size:14px; text-align:left" >이력제 사업장관리번호</td>
		            <td  colspan="3"> <input type="text" data-date-format="yyyy-mm-dd" id="txt_refno" class="form-control" style="width: 400px; border: solid 1px #cccccc;" disabled/></td>	
   		            <td style=" font-weight: 900; font-size:14px; text-align:left" >수정사유</td>
		            <td  colspan="3"> <input type="text" data-date-format="yyyy-mm-dd" id="txt_modify_reason" class="form-control" style="width: 400px; border: solid 1px #cccccc;" /></td>			       
		        </tr>
				<tr class="subcontractor_sub" style="background-color: #fff" >
		            <td style=" font-weight: 900; font-size:14px; text-align:left" >작성자</td>
					<td  colspan="3" style="width: 38%; font-weight: 900; font-size:14px; text-align:left">
						<input type="text" class="form-control" id="txt_writor" style="width: 400px; float:left" readonly />
						<input type="text" class="form-control" id="txt_writor_rev" style="width: 400px; float:left; display:none;" readonly />		
						<input type="text" id="txt_present_rev" class="form-control" style="width: 365px; border: solid 1px #cccccc; float: left; display:none;" value="0" />
						&nbsp;&nbsp;<input type="button" class="btn btn-info" onclick="parent.pop_fn_UserList_View(2, 'txt_writor')" value="입력" disabled></input></td>
		            <td style=" font-weight: 900; font-size:14px; text-align:left" >작성일</td>
		            <td  colspan="3"> <input type="text" data-date-format="yyyy-mm-dd" id="txt_write_date" class="form-control" style="width: 400px; border: solid 1px #cccccc;" disabled/></td>		       
		        </tr>
		        		        
		        <tr>
					<td class="subcontractor_sub_title" style=" font-weight: 900; font-size:16px; text-align:left; background:#e8e8e8;" colspan="8">협력업체 기타항목</td>
				</tr> 

		       <tr class="subcontractor_sub" style="background-color: #fff" >
		            <td style=" font-weight: 900; font-size:14px; text-align:left" >검토자</td>
					<td  colspan="3" style="width: 38%; font-weight: 900; font-size:14px; text-align:left">
						<input type="text" class="form-control" id="txt_checker" style="width: 400px; float:left" readonly />						
						<input type="text" class="form-control" id="txt_checker_rev" style="width: 400px; float:left; display:none;" readonly />
						&nbsp;&nbsp;<input type="button" class="btn btn-info" onclick="parent.pop_fn_UserList_View(2, 'txt_checker')" value="입력"></input></td>		           	
		            <td style=" font-weight: 900; font-size:14px; text-align:left" >검토일</td>
		            <td  colspan="3"> <input type="text" data-date-format="yyyy-mm-dd" id="txt_check_date" class="form-control" style="width: 400px; border: solid 1px #cccccc;" readonly/></td>		       
		        </tr>
		       <tr class="subcontractor_sub" style="background-color: #fff" >
		            <td style=" font-weight: 900; font-size:14px; text-align:left" >승인자</td>
		            					<td  colspan="3" style="width: 38%; font-weight: 900; font-size:14px; text-align:left">
						<input type="text" class="form-control" id="txt_approval" style="width: 400px; float:left" readonly />						
						<input type="text" class="form-control" id="txt_approval_rev" style="width: 400px; float:left; display:none;" readonly />
						&nbsp;&nbsp;<input type="button" class="btn btn-info" onclick="parent.pop_fn_UserList_View(2, 'txt_approval')" value="입력"></input></td>
		            <td style=" font-weight: 900; font-size:14px; text-align:left" >승인일</td>
		            <td  colspan="3"> <input type="text" data-date-format="yyyy-mm-dd" id="txt_approve_date" class="form-control" style="width: 400px; border: solid 1px #cccccc;" readonly/></td>		       
		        </tr>
				
		        <tr class="subcontractor_sub" style="background-color: #fff" >
		            <td style=" font-weight: 900; font-size:14px; text-align:left" >공장주소</td>
		            <td colspan="3"><input type="text" class="form-control" id="txt_subcontractor_factory_address" style="width: 400px; float:left;"/>
           			&nbsp;&nbsp;<input type="button" class="btn btn-info" onclick="pop_add_factory_search(this);" value="검색"></input></td>
		            <td style=" font-weight: 900; font-size:14px; text-align:left">공장전화번호</td>       
		            <td  colspan="3"> <input type="text" data-date-format="yyyy-mm-dd" id="txt_subcontractor_factory_phone" class="form-control" style="width: 400px; border: solid 1px #cccccc;" /></td> 			
		        </tr>		        	
				
		        <tr class="subcontractor_sub" style="background-color: #fff; ">
		            <td style=" font-weight: 900; font-size:14px; text-align:left"  >공장규모</td>
		            <td  colspan="3"> <input type="text" numberOnly data-date-format="yyyy-mm-dd" id="txt_factory_scale"  class="form-control" style="width: 400px; border: solid 1px #cccccc;" /></td>
	 		        <td style=" font-weight: 900; font-size:14px; text-align:left">설립일자</td>       
		            <td  colspan="3"> <input type="text" data-date-format="yyyy-mm-dd" id="txt_establish_date" class="form-control" style="width: 400px; border: solid 1px #cccccc;" readonly/></td>
		        </tr>	            
		        
		        <tr class="subcontractor_sub" style="background-color: #fff" >
	            	<td style=" font-weight: 900; font-size:14px; text-align:left">평가방법</td>
	            	<td>
						<input type="radio" id="txt_appraisal_means" name="chk_info" value="실사평가"/>실사평가
						<label style="width:5%"></label>
						<input type="radio" id="txt_appraisal_means" name="chk_info" value="견본평가"/>  견본평가
						<label style="width:5%"></label>
						<input type="radio" id="txt_appraisal_means" name="chk_info" value="이력 및 서류평가"/>  이력 및 서류평가
					</td>
		        </tr>		        
		        
		        <!-- 구분선 --------------------------------------------------------------------------------------------------------------------------------------------------------------------- -->  

		        <tr class="person">
					<td class="person_title" style=" font-weight: 900; font-size:16px; text-align:left; background:#e8e8e8;" colspan="8">인원현황</td>
				</tr>
					<tr>
				<td id="person_data" colspan="8">
	        	    <table class="person_table" id="person_table" style="width: 100%; margin: 0 auto; align:left">
						<thead>
					        <tr class="" style="vertical-align: middle">
					            <th style="width: 2%; font-weight: 900; font-size:14px; text-align:center; vertical-align: middle">#</th>
					            <th style="width: 18%; font-weight: 900; font-size:14px; text-align:center; vertical-align: middle">구분</th>
					            <th style="width: 10%; font-weight: 900; font-size:14px; text-align:center; vertical-align: middle">인원</th>
					            <th style="width: 10%; font-weight: 900; font-size:14px; text-align:center; vertical-align: middle">사무직</th>
					            <th style="width: 10%; font-weight: 900; font-size:14px; text-align:center; vertical-align: middle">기술직</th>		            
					            <th style="width: 10%; font-weight: 900; font-size:14px; text-align:center; vertical-align: middle">생산직</th>
					            <th style="width: 10%; font-weight: 900; font-size:14px; text-align:center; vertical-align: middle">기타</th>
					            <th style="width: 10%; font-weight: 900; font-size:14px; text-align:center; vertical-align: middle">계</th>
					            <th style="width: 10%; font-weight: 900; font-size:14px; text-align:center; vertical-align: middle">비고</th>
					            <th style="width: 0%; font-weight: 900; font-size:14px; text-align:center; vertical-align: middle; display:none;">rev</th>
					            <th style="width: 8%; font-weight: 900; font-size:14px; text-align:center; vertical-align: middle">
				                	<button alt="한줄 추가" id="btn_plus_person"  class="btn btn-info btn-sm" >+</button>
				                	<button alt="한줄 삭제" id="btn_mius_person"  class="btn btn-info btn-sm" >-</button></th>
				            </tr>    	
		
						</thead>
				        <tbody id="person_tbody">
				        </tbody>
			    	</table>
		    	</td>
		    	</tr>
		    	
		    	
		    	<!-- ================================================================================================================================================== -->
		    	
				<tr class="product">
					<td class="product_title" style=" font-weight: 900; font-size:16px; text-align:left; background:#e8e8e8;" colspan="8">주요 품목별 생산능력</td>
				</tr>
				<tr>
					<td id="product_data" colspan="8">
		        	    <table class="product_table" id="product_table" style="width: 100%; margin: 0 auto; align:left">
							<thead>
						        <tr class="" style="vertical-align: middle">
						            <th style="width: 2%; font-weight: 900; font-size:14px; text-align:center; vertical-align: middle">#</th>
						            <th style="width: 30%; font-weight: 900; font-size:14px; text-align:center; vertical-align: middle">제품별</th>
						            <th style="width: 20%; font-weight: 900; font-size:14px; text-align:center; vertical-align: middle">단위</th>
						            <th style="width: 20%; font-weight: 900; font-size:14px; text-align:center; vertical-align: middle">생산능력</th>
						            <th style="width: 20%; font-weight: 900; font-size:14px; text-align:center; vertical-align: middle">비고</th>
						            <th style="width: 0%; font-weight: 900; font-size:14px; text-align:center; vertical-align: middle; display:none;">rev</th>	
						            <th style="width: 13%; font-weight: 900; font-size:14px; text-align:center; vertical-align: middle">
					                	<button alt="한줄 추가" id="btn_plus_product"  class="btn btn-info btn-sm" >+</button>
					                	<button alt="한줄 삭제" id="btn_mius_product"  class="btn btn-info btn-sm" >-</button></th>
					            </tr>    	
							</thead>
					        <tbody id="product_tbody">
					        </tbody>
				    	</table>
		    		</td>
	    		</tr>
		    	
		    	<!-- ================================================================================================================================================== -->
		    	
		    	
				<tr class="permission">
					<td class="permission_title" style="font-weight: 900; font-size:16px; text-align:left; background:#e8e8e8;" colspan="8">제품인증허가관계</td>	
				</tr>
				<tr>
					<td id="permission_data" colspan="8">				
		        	    <table class="permission_table" id="permission_table" style="width: 100%; margin: 0 auto; align:left">
						<thead>
					        <tr class="" style="vertical-align: middle">
					            <th style="width: 2%; font-weight: 900; font-size:14px; text-align:center; vertical-align: middle">#</th>
					            <th style="width: 30%; font-weight: 900; font-size:14px; text-align:center; vertical-align: middle">구분</th>
					            <th style="width: 15%; font-weight: 900; font-size:14px; text-align:center; vertical-align: middle">품명</th>
					            <th style="width: 15%; font-weight: 900; font-size:14px; text-align:center; vertical-align: middle">인증기관</th>
					            <th style="width: 15%; font-weight: 900; font-size:14px; text-align:center; vertical-align: middle">인증일자</th>		            
					            <th style="width: 15%; font-weight: 900; font-size:14px; text-align:center; vertical-align: middle">비고</th>
					            <th style="width: 0%; font-weight: 900; font-size:14px; text-align:center; vertical-align: middle; display:none;">rev</th>
					            <th style="width: 13%; font-weight: 900; font-size:14px; text-align:center; vertical-align: middle">
				                	<button alt="한줄 추가" id="btn_plus_permission"  class="btn btn-info btn-sm" >+</button>
				                	<button alt="한줄 삭제" id="btn_mius_permission"  class="btn btn-info btn-sm" >-</button></th>
				            </tr>    		
						</thead>
				        <tbody id="permission_tbody">
				        </tbody>
				    	</table>
			    	</td>
		    </tr>
		    	
		    	<!-- ================================================================================================================================================== -->
		    	
		    	
				<tr class="equipment">
					<td class="equipment_title" style=" font-weight: 900; font-size:16px; text-align:left; background:#e8e8e8;" colspan="8" >제조설비현황</td>
				</tr>
				<tr>
					<td id="equipment_data" colspan="8">	
		        	    <table class="equipment_table" id="equipment_table" style="width: 100%; margin: 0 auto; align:left">
						<thead>
					        <tr class="" style="vertical-align: middle">
					            <th style="width: 2%; font-weight: 900; font-size:14px; text-align:center; vertical-align: middle">#</th>
					            <th style="width: 30%; font-weight: 900; font-size:14px; text-align:center; vertical-align: middle">설비명</th>
					            <th style="width: 15%; font-weight: 900; font-size:14px; text-align:center; vertical-align: middle">형식 및 규격</th>
					            <th style="width: 15%; font-weight: 900; font-size:14px; text-align:center; vertical-align: middle">제조회사</th>
					            <th style="width: 15%; font-weight: 900; font-size:14px; text-align:center; vertical-align: middle">보유수량</th>		            
					            <th style="width: 15%; font-weight: 900; font-size:14px; text-align:center; vertical-align: middle">비고</th>
					            <th style="width: 0%; font-weight: 900; font-size:14px; text-align:center; vertical-align: middle; display:none;">rev</th>					          
					            <th style="width: 8%; font-weight: 900; font-size:14px; text-align:center; vertical-align: middle">
				                	<button alt="한줄 추가" id="btn_plus_equipment"  class="btn btn-info btn-sm" >+</button>
				                	<button alt="한줄 삭제" id="btn_mius_equipment"  class="btn btn-info btn-sm" >-</button></th>
				            </tr>    	
		
						</thead>
				        <tbody id="equipment_tbody">
				        </tbody>
				    	</table>
			    	</td>
		    	</tr>
		    	
		    	
		    	
        	</table>
        </td>
	</tr>

	
    <tr style="height: 60px">
        <td align="center" colspan="2">
            <p>
            	<button id="btn_Save"  class="btn btn-info" style="width: 100px" onclick="SaveOderInfo();">저장</button>
                <button id="btn_Canc"  class="btn btn-info" style="width: 100px" onclick="$('#modalReport').modal('hide');">취소</button>
            </p>
        </td>
    </tr>
  </table>
  
<!-- </form>  -->

</div>
