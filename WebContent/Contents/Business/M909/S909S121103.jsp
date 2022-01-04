<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="mes.client.comm.*" %>
<%@ page import="mes.client.common.*" %>
<%@ page import="mes.client.guiComponents.*" %>
<%@ page import="mes.client.util.*" %>
<%@ page import="mes.client.conf.*" %>
<%@ page import="org.json.simple.*"%><%@ include file="/strings.jsp" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" >
<%
	DoyosaeTableModel TableModel;

	String GV_PROD_CD = "", GV_PROD_CD_REV = "";
	
	if(request.getParameter("ProdCd")== null)
		GV_PROD_CD = "";
	else
		GV_PROD_CD = request.getParameter("ProdCd");
	
	if(request.getParameter("ProdCd_rev")== null)
		GV_PROD_CD_REV="";
	else
		GV_PROD_CD_REV = request.getParameter("ProdCd_rev");
	
	String loginID = session.getAttribute("login_id").toString();
	String member_key = session.getAttribute("member_key").toString();

	JSONObject jArray = new JSONObject();
	jArray.put( "prod_cd", GV_PROD_CD);
	jArray.put( "prod_cd_rev", GV_PROD_CD_REV);
	jArray.put( "member_key", member_key);
    TableModel = new DoyosaeTableModel("M909S121100E124", jArray);	
    
 	int RowCount =TableModel.getRowCount();
 	StringBuffer html = new StringBuffer();	
	if(RowCount>0) {				             
		html.append("$('#txt_Productcode').val('" + TableModel.getValueAt(0,10).toString().trim() + "');\n"); // 9. prod_cd			                
		html.append("$('#txt_prod_rev').val('" + TableModel.getValueAt(0,11).toString().trim() + "');\n"); // 10. prod_cd_rev		            	 	
		for(int i=0; i<RowCount; i++){
			System.out.println(TableModel.getValueAt(0,10).toString().trim() + " : " + TableModel.getValueAt(i,5).toString().trim() + " : " + TableModel.getValueAt(i,6).toString().trim());
			html.append( "fn_plus_body();\n" );
			html.append(" var trInput = $($('#product_tbody tr')[" + i + "]).find(':input');\n");			
			html.append(" trInput.eq(0).val('" + TableModel.getValueAt(i,8).toString().trim()  + "');\n");
			html.append(" trInput.eq(2).val('" + TableModel.getValueAt(i,1).toString().trim() + "');\n"); 	// 0. process_gubun       
			html.append(" trInput.eq(3).val('" + TableModel.getValueAt(i,2).toString().trim() + "');\n"); 	// 1. process_gubun_rev	  
			html.append(" trInput.eq(4).val('" + TableModel.getValueAt(i,3).toString().trim() + "');\n"); 	// 2. proc_code_gb_big	  
			html.append(" trInput.eq(5).val('" + TableModel.getValueAt(i,4).toString().trim() + "');\n"); 	// 3. proc_code_gb_mid	  
			html.append(" trInput.eq(6).val('" + TableModel.getValueAt(i,5).toString().trim() + "');\n"); 	// 4. proc_cd			  
			html.append(" trInput.eq(8).val('" + TableModel.getValueAt(i,6).toString().trim() + "');\n"); 	// 5. proc_cd_rev		  
			html.append(" trInput.eq(9).val('" + TableModel.getValueAt(i,7).toString().trim() + "');\n"); 	// 6. process_nm			
			html.append(" trInput.eq(10).val('" + TableModel.getValueAt(i,8).toString().trim() + "');\n"); 	// 7. process_seq		  
			html.append(" trInput.eq(11).val('" + TableModel.getValueAt(i,9).toString().trim() + "');\n"); 	// 8. dept_gubun          
			html.append(" trInput.eq(14).val('" + TableModel.getValueAt(i,12).toString().trim() + "');\n"); // 11. std_proc_qnt		  
			html.append(" trInput.eq(15).val('" + TableModel.getValueAt(i,13).toString().trim() + "');\n"); // 12. std_man_amt		  
			html.append(" trInput.eq(16).val('" + TableModel.getValueAt(i,14).toString().trim() + "');\n"); // 13. seolbi_cd			
			html.append(" trInput.eq(18).val('" + TableModel.getValueAt(i,15).toString().trim() + "');\n"); // 14. seolbi_cd_rev		
			html.append(" trInput.eq(19).val('" + TableModel.getValueAt(i,16).toString().trim() + "');\n"); // 15. seolbi_line		  
			html.append(" trInput.eq(20).val('" + TableModel.getValueAt(i,17).toString().trim() + "');\n"); // 16. work_order_index	  
			html.append(" trInput.eq(21).val('" + TableModel.getValueAt(i,18).toString().trim() + "');\n"); // 17. bigo				  
			html.append(" trInput.eq(22).val('" + TableModel.getValueAt(i,19).toString().trim() + "');\n"); // 18. start_date			
			html.append(" trInput.eq(23).val('" + TableModel.getValueAt(i,20).toString().trim() + "');\n"); // 19. create_date		  
			html.append(" trInput.eq(24).val('" + TableModel.getValueAt(i,21).toString().trim() + "');\n"); // 20. create_user_id		
			html.append(" trInput.eq(25).val('" + TableModel.getValueAt(i,22).toString().trim() + "');\n"); // 21. modify_date		  
			html.append(" trInput.eq(26).val('" + TableModel.getValueAt(i,23).toString().trim() + "');\n"); // 22. modify_user_id		
			html.append(" trInput.eq(28).val('" + TableModel.getValueAt(i,25).toString().trim() + "');\n"); // 24. modify_reason      
			html.append(" trInput.eq(27).val('" + TableModel.getValueAt(i,24).toString().trim() + "');\n"); // 23. duration_date		
			html.append(" trInput.eq(29).val('" + TableModel.getValueAt(i,26).toString().trim() + "');\n"); // 25. check_data_type		
			html.append(" trInput.eq(30).val('" + TableModel.getValueAt(i,27).toString().trim() + "');\n"); // 26. delyn              
			html.append(" trInput.eq(31).val('" + TableModel.getValueAt(i,28).toString().trim() + "');\n"); // 27. product_process_yn 
			html.append(" trInput.eq(32).val('" + TableModel.getValueAt(i,29).toString().trim() + "');\n"); // 28. packing_process_yn    
		}
	} else {
		html.append("$('#txt_Productcode').val('" + GV_PROD_CD + "');\n"); // 9. prod_cd			                
		html.append("$('#txt_prod_rev').val('" + GV_PROD_CD_REV + "');\n"); // 10. prod_cd_rev	
	}
%>
         
<script type="text/javascript">
//     웹소켓 통신을 위해서 필요한 변수들 ---시작
	var M909S121100E103 = {
			PID: "M909S121100E103",  
			totalcnt: 0,
			retnValue: 999,
			colcnt: 0,
			colname: ["","","",""], //insert, Update, Delete 문장을 처리할 때는 사용되지않음
			data: []
	};  
	
	var SQL_Param = {
			PID: "M909S121100E103",
			excute: "queryProcess",
			stream: "N",
			param: + "|"
	};
	var GV_RECV_DATA = "";	//웹소켓 onMessage(event)들어온 데이터를 받는 변수
//  웹소켓 통신을 위해서 필요한 변수들 ---끝	
    var detail_seq=1;
	var vprocess_delete_table;
    var vprocess_delete_table_Row_index = -1;
	var vprocess_delete_table_info;
    var vprocess_delete_table_RowCount=0;
    var process_index= -1;
    var seolbi_index= -1;
	
    $(document).ready(function () {
    	detail_seq =1;
    	RowCount = '<%=RowCount%>'; 
	    vprocess_delete_table = $('#process_delete_table').DataTable({
	    	scrollX: true,
		    scrollY: 250,
// 		    scrollCollapse: true,
		    paging: false,
		    searching: false,
		    ordering: false,
		    order: [[ 10, "asc" ]],
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
		       		'targets': [1,2,3,4,5,7,9,10,11,12,16,18,20,21,22,23,24,25,27,28,29,30],
		       		'createdCell':  function (td) {
		          			$(td).attr('style', 'display:none;'); 
		       		}
				},
		    	{
		       		'targets': [6,8,13,14,15,17,19,26], 
		       		'createdCell':  function (td) {
		          			$(td).attr('style', 'width:10%;'); 
		       		}
				}
            ],
            language: { 
                url:"<%=Config.this_SERVER_path%>/AdminLTE-3.0.5/localisation/Korean.json"
             }
		});	
/* 	    
        $("#txt_start_date").datepicker({
        	format: 'yyyy-mm-dd',
        	autoclose: true,
        	language: 'ko'
        });      
        $("#txt_create_date").datepicker({
        	format: 'yyyy-mm-dd',
        	autoclose: true,
        	language: 'ko'
        });     
        $("#txt_duration_date").datepicker({
        	format: 'yyyy-mm-dd',
        	autoclose: true,
        	language: 'ko'
        });     
        $("#txt_modify_date").datepicker({
        	format: 'yyyy-mm-dd',
        	autoclose: true,
        	language: 'ko'
        });   
        
        var today = new Date();
        var fromday = new Date();
        fromday.setDate(today.getDate());
        today.setDate(today.getDate()+180);        
        
        $('#txt_start_date').datepicker('update', fromday);
        $('#txt_create_date').datepicker('update', fromday);        
        //$('#txt_modify_date').datepicker('update', fromday);
 */
	    $("#btn_plus").click(function(){ 
	    	fn_plus_body();
	    }); 
	    $("#btn_mius").click(function(){ 
	    	fn_mius_body(); 
	    }); 
     	vprocess_delete_table_info = vprocess_delete_table.page.info();
     	vprocess_delete_table_RowCount = vprocess_delete_table_info.recordsTotal;
	    
	    <%=html%>
    });

	function SaveOderInfo() {
		// JSON 파라미터 전달(하나 보낼때)
 		var dataJson = new Object();
     	vprocess_delete_table_info = vprocess_delete_table.page.info();
     	vprocess_delete_table_RowCount = vprocess_delete_table_info.recordsTotal;
			
			dataJson.member_key = "<%=member_key%>"; 		
   			dataJson.prod_cd			= $('#txt_Productcode').val();   		
   			dataJson.prod_cd_rev		= $('#txt_prod_rev').val();
  		
   		var chekrtn = confirm("삭제하시겠습니까?"); 
  			
  		if(chekrtn){
			
  			SendTojsp(JSON.stringify(dataJson), SQL_Param.PID); // 보내는 데이터묶음 하나일때 => Object하나만
  		}
	}
 
	function SendTojsp(bomdata, pid){
		
	    $.ajax({
	         type: "POST",
	         dataType: "json", // Ajax로 json타입으로 보낸다.
	         url: "<%=Config.this_SERVER_path%>/Contents/CommonView/insert_update_delete_json.jsp", 
	         data:  "bomdata=" + bomdata + "&pid=" + pid,
	         beforeSend: function () {
//	         	 alert(bomdata);
	         },	         
	         success: function (html) {
	        	 alert("삭제완료");
	        	 if(html>-1){
	        	   	parent.fn_MainInfo_List();
	                parent.$("#ReportNote").children().remove();
	         		parent.$('#modalReport').hide();
	         	}
	         },
	         error: function (xhr, option, error) {
	        	 alert("삭제실패");
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

    // 제품정보
    function SetProductName_code(txt_ProductName, txt_Productcode, txt_prod_rev){
//    	$('#txt_ProductName').val(txt_ProductName);
    	$('#txt_Productcode').val(txt_Productcode);
    	$('#txt_prod_rev').val(txt_prod_rev); 
//    	console.log($('#txt_ProductName').val());
//    	console.log($('#txt_Productcode').val());
//    	console.log($('#txt_prod_rev').val()); 
    }
    // 설비정보
    function SetSeolbiInfo(txt_seolbi_cd,txt_seolbi_rev, txt_seolbi_nm){
		var trInput = $($("#product_tbody tr")[seolbi_index]).find(":input");
//		trInput.eq(1).val(txt_seolbi_nm);
	    trInput.eq(16).val(txt_seolbi_cd);	    
	    trInput.eq(18).val(txt_seolbi_rev);
//	    for(i=0; i<33; i++){ console.log(i+ ". "+ trInput.eq(i).attr("id") + " : " + trInput.eq(i).val()); }
    }    
    // 공정정보
	function SetProcessName_code(txt_process_gubun,
			 				 txt_process_gubun_rev,
			 				 txt_proc_code_gb_big,
			 				 txt_proc_code_gb_mid,
			 				 txt_process_cd,
			 				 txt_process_rev,
							 txt_process_name,
			 				 txt_work_order_index,
			 				 txt_process_seq,
			 				 txt_product_process_yn,
			 				 txt_bigo,
			 				 txt_start_date,
			 				 txt_create_date,
			 				 txt_create_user_id,
			 				 txt_modify_date,
			 				 txt_modify_user_id,
			 				 txt_duration_date,
			 				 txt_modify_reason,
			 				 txt_check_data_type,
			 				 txt_dept_gubun,
			 				 txt_delyn,
			 				 txt_packing_process_yn)
    {
        var trInput = $($("#product_tbody tr")[process_index]).find(":input");
	    trInput.eq(2).val(txt_process_gubun);
	    trInput.eq(3).val(txt_process_gubun_rev);
	    trInput.eq(4).val(txt_proc_code_gb_big);
	    trInput.eq(5).val(txt_proc_code_gb_mid);
	    trInput.eq(6).val(txt_process_cd);
	    trInput.eq(8).val(txt_process_rev);
	    trInput.eq(9).val(txt_process_name);
	    trInput.eq(10).val(txt_process_seq);
	    trInput.eq(11).val(txt_dept_gubun);
	    trInput.eq(20).val(txt_work_order_index);
	    trInput.eq(21).val(txt_bigo);
	    trInput.eq(22).val(txt_start_date);
	    trInput.eq(23).val(txt_create_date);
	    trInput.eq(28).val(txt_modify_reason);
	    trInput.eq(29).val(txt_check_data_type);
	    trInput.eq(30).val(txt_delyn);
	    trInput.eq(31).val(txt_product_process_yn);
	    trInput.eq(32).val(txt_packing_process_yn);	    
	    // 확인용
	    //for(i=0; i<33; i++){ console.log(i+ ". "+ trInput.eq(i).attr("id") + " : " + trInput.eq(i).val()); }
    }    
	function seolbiIns(row_index){
		seolbi_index = row_index;
		parent.pop_fn_SeolbiList_View(1,2);
	}
	function processIns(row_index){
		process_index = row_index;
	    parent.pop_fn_Process_View(1,2);
	}    
    
    function fn_plus_body(){
    	vprocess_delete_table.row.add( [
    		"	<input type='text' class='form-control' id='txt_detail_seq' style='width:30px;' disabled></input>",
    		"	<input type='text' class='form-control' id='txt_member_key"+vprocess_delete_table_RowCount+"' disabled></input>",
    		"	<input type='text' class='form-control' id='txt_process_gubun"+vprocess_delete_table_RowCount+"' value='' disabled></input>",
    		"	<input type='text' class='form-control' id='txt_process_gubun_rev"+vprocess_delete_table_RowCount+"' value='' disabled></input>",
    		"	<input type='text' class='form-control' id='txt_proc_code_gb_big"+vprocess_delete_table_RowCount+"' value='' disabled></input>",
    		"	<input type='text' class='form-control' id='txt_proc_code_gb_mid"+vprocess_delete_table_RowCount+"' value='' disabled></input>",
    		"	<input type='text' class='form-control' id='txt_proc_cd"+vprocess_delete_table_RowCount+"' style='float:left; width:70%;' value='' disabled></input>" +
    		"	<button type='button' onclick='processIns("+vprocess_delete_table_RowCount+")' id='btn_SearchProd' class='btn btn-info' style='float:left;width:30%;' disabled>검색</button> ",	// 6. 공정명
    		"	<input type='text' class='form-control' id='txt_proc_cd_rev"+vprocess_delete_table_RowCount+"' value='' disabled></input>",
    		"	<input type='text' class='form-control' id='txt_process_nm"+vprocess_delete_table_RowCount+"' value='' disabled></input>",
    		"	<input type='text' class='form-control' id='txt_process_seq"+vprocess_delete_table_RowCount+"' value='' disabled></input>",
    		"	<input type='text' class='form-control' id='txt_dept_gubun"+vprocess_delete_table_RowCount+"' value='' disabled></input>",
    		"	<input type='text' class='form-control' id='txt_prod_cd"+vprocess_delete_table_RowCount+"' value='' disabled></input>",
    		"	<input type='text' class='form-control' id='txt_prod_cd_rev"+vprocess_delete_table_RowCount+"' value='' disabled></input>",
    		"	<input type='text' class='form-control' id='txt_std_proc_qnt"+vprocess_delete_table_RowCount+"' value='' disabled></input>",			// 14. 표준공수
    		"	<input type='text' class='form-control' id='txt_std_man_amt"+vprocess_delete_table_RowCount+"' value='' disabled></input>",			// 15. 필요인원수
    		"	<input type='text' class='form-control' id='txt_seolbi_cd"+vprocess_delete_table_RowCount+"' style='float:left; width:70%;' value='' disabled></input>" + // 16. 설비코드
    		"	<button type='button' onclick='seolbiIns("+vprocess_delete_table_RowCount+")' id='btn_SearchProd' class='btn btn-info' style='float:left;width:30%;' disabled>검색</button> ",	
    		"	<input type='text' class='form-control' id='txt_seolbi_cd_rev"+vprocess_delete_table_RowCount+"' value='' disabled></input>",
    		"	<input type='text' class='form-control' id='txt_seolbi_line"+vprocess_delete_table_RowCount+"' value='' disabled></input>",			
    		"	<input type='text' class='form-control' id='txt_work_order_index"+vprocess_delete_table_RowCount+"' value='' disabled></input>",
    		"	<input type='text' class='form-control' id='txt_bigo"+vprocess_delete_table_RowCount+"' value='' disabled></input>",
    		"	<input type='text' class='form-control' id='txt_start_date' value='' disabled></input>",			
    		"	<input type='text' class='form-control' id='txt_create_date' value='' disabled></input>",			
    		"	<input type='text' class='form-control' id='txt_create_user_id"+vprocess_delete_table_RowCount+"' value='' disabled></input>",
    		"	<input type='text' class='form-control' id='txt_modify_date' value='' disabled></input>",
    		"	<input type='text' class='form-control' id='txt_modify_user_id"+vprocess_delete_table_RowCount+"' value='' disabled></input>",
    		"	<input type='text' class='form-control' id='txt_duration_date' value='9999-12-31' disabled></input>",
    		"	<input type='text' class='form-control' id='txt_modify_reason"+vprocess_delete_table_RowCount+"' value='' disabled></input>",			
    		"	<input type='text' class='form-control' id='txt_check_data_type"+vprocess_delete_table_RowCount+"' value='' disabled></input>",
    		"	<input type='text' class='form-control' id='txt_delyn"+vprocess_delete_table_RowCount+"' value='' disabled></input>",
    		"	<input type='text' class='form-control' id='txt_product_process_yn"+vprocess_delete_table_RowCount+"' value='' disabled></input>",
    		"	<input type='text' class='form-control' id='txt_packing_process_yn"+vprocess_delete_table_RowCount+"' value='' disabled></input>",
    		""
		] ).draw();
    	
    	vprocess_delete_table_info = vprocess_delete_table.page.info();
     	vprocess_delete_table_RowCount = vprocess_delete_table_info.recordsTotal;
    	
	   	// 숫자만
	   	$("input:text[numberOnly]").on("keyup", function() {
	   		$(this).val($(this).val().replace(/[^0-9]/g,""));
	   	});
	   	
	   	var trInput = $($("#product_tbody tr")[vprocess_delete_table_RowCount-1]).find(":input");
	   	trInput.eq(0).val(vprocess_delete_table_RowCount);
	   	var vSerialNo =  "00000" + "1";
	   	var vLotNo = trInput.eq(6).val();
		   	   
	   	for(i=0;i<vprocess_delete_table_RowCount;i++){
		   	var today = new Date();
		   		var fromday = new Date();
		   		$('input[id=txt_start_date]').eq(i).datepicker({
		   			format: 'yyyy-mm-dd',
		   			autoclose: true,
		   			language: 'ko'
		   		});
		   	//$('#txt_start_date').datepicker('update', fromday);
	   	}     
	   	for(i=0;i<vprocess_delete_table_RowCount;i++){
	   		var today = new Date();
	   		var fromday = new Date();
	   		$('input[id=txt_create_date]').eq(i).datepicker({
	   			format: 'yyyy-mm-dd',
	   			autoclose: true,
	   			language: 'ko'
	   		});
	   		//$('#txt_create_date').datepicker('update', fromday);
	   	}	   	
	   	for(i=0;i<vprocess_delete_table_RowCount;i++){
		   	var today = new Date();
		   		var fromday = new Date();
		   		$('input[id=txt_modify_date]').eq(i).datepicker({
		   			format: 'yyyy-mm-dd',
		   			autoclose: true,
		   			language: 'ko'
		   		});
		   		$('#txt_modify_date').datepicker('update', fromday);
		  }     
		for(i=0;i<vprocess_delete_table_RowCount;i++){
	   		var today = new Date();
	   		var fromday = new Date();
	   		$('input[id=txt_duration_date]').eq(i).datepicker({
	   			format: 'yyyy-mm-dd',
	   			autoclose: true,
	   			language: 'ko'
	   		});
	   		$('#txt_duration_date').datepicker('update', fromday);
	   	}	   	
		
    }    
	function fn_mius_body(){  	        
		vprocess_delete_table
		.row( vprocess_delete_table_RowCount-1 )
		.remove()
		.draw();
		
		vprocess_delete_table_info = vprocess_delete_table.page.info();
     	vprocess_delete_table_RowCount = vprocess_delete_table_info.recordsTotal;
	}   	    	
</script>
</head>

<body>
	<table class="table" style="width: 100%; margin: 0 auto; align:left;">
		<tr style="background-color: #fff;">
            <td style=" font-weight: 900; font-size:14px; text-align:left">제품코드</td>
            <td>
           	<input type="text"  id="txt_Productcode" class="form-control" style="width: 200px; border: solid 1px #cccccc; vertical-align: middle; float: left;" readonly />
			<button type="button" onclick="parent.pop_fn_Product_View(1,2)" id="btn_SearchProd" class="btn btn-info" style="margin-left: 10px; float: left" disabled>검색</button>
			</td>
			<td style=" font-weight: 900; font-size:14px; text-align:left; display:none;">제품코드개정번호</td>
            <td style="display:none;"><input type="text" id="txt_prod_rev" class="form-control" style="width: 200px; border: solid 1px #cccccc;" readonly/></td>		        
        </tr>
	</table>
	<table class="table " id="process_delete_table" style="width: 100%; margin: 0 auto; align:left">
		<thead>
	        <tr style="vertical-align: middle">                                                                                                         
				<th style="width: 30px; font-weight: 900; font-size:14px; text-align:center; vertical-align: middle;">순서</th>                            
				<th style="width: 0%; font-weight: 900; font-size:14px; text-align:center; vertical-align: middle; display:none;">member_key</th>
				<th style="width: 0%; font-weight: 900; font-size:14px; text-align:center; vertical-align: middle; display:none;">공정구분</th>         	
				<th style="width: 0%; font-weight: 900; font-size:14px; text-align:center; vertical-align: middle; display:none;">공정구분개정번호</th>   	
				<th style="width: 0%; font-weight: 900; font-size:14px; text-align:center; vertical-align: middle; display:none;">공정구분Big</th>     	
				<th style="width: 0%; font-weight: 900; font-size:14px; text-align:center; vertical-align: middle; display:none;">공정구분Mid</th>      	
				<th style="width: 178px; font-weight: 900; font-size:14px; text-align:center; vertical-align: middle;">공정코드</th>       	  	
				<th style="width: 0%; font-weight: 900; font-size:14px; text-align:center; vertical-align: middle; display:none;">공정코드개정번호</th>    	
				<th style="width: 178px; font-weight: 900; font-size:14px; text-align:center; vertical-align: middle;;">공정명</th>	              	
				<th style="width: 89px; font-weight: 900; font-size:14px; text-align:center; vertical-align: middle; display:none;">순서</th>          	
				<th style="width: 0%; font-weight: 900; font-size:14px; text-align:center; vertical-align: middle; display:none;">부서구분</th>
				<th style="width: 0%; font-weight: 900; font-size:14px; text-align:center; vertical-align: middle; display:none;">제품코드</th>
				<th style="width: 0%; font-weight: 900; font-size:14px; text-align:center; vertical-align: middle; display:none;">제품rev</th>         	
				<th style="width: 178px; font-weight: 900; font-size:14px; text-align:center; vertical-align: middle;">표준공수(단위:시간)</th>             
				<th style="width: 178px; font-weight: 900; font-size:14px; text-align:center; vertical-align: middle;">필요인원수(단위:명)</th>             
				<th style="width: 178px; font-weight: 900; font-size:14px; text-align:center; vertical-align: middle;">설비코드</th>                      
				<th style="width: 0%; font-weight: 900; font-size:14px; text-align:center; vertical-align: middle; display:none;">설비코드개정번호</th>     
				<th style="width: 178px; font-weight: 900; font-size:14px; text-align:center; vertical-align: middle;">설비라인</th>                      
				<th style="width: 178px; font-weight: 900; font-size:14px; text-align:center; vertical-align: middle; display:none;">work_order_index</th> 
				<th style="width: 0%; font-weight: 900; font-size:14px; text-align:center; vertical-align: middle;">비고</th>              
				<th style="width: 0%; font-weight: 900; font-size:14px; text-align:center; vertical-align: middle; display:none;">시작일자</th>           
				<th style="width: 0%; font-weight: 900; font-size:14px; text-align:center; vertical-align: middle; display:none;">생성일자</th>           
				<th style="width: 0%; font-weight: 900; font-size:14px; text-align:center; vertical-align: middle; display:none;">생성자</th>            
				<th style="width: 0%; font-weight: 900; font-size:14px; text-align:center; vertical-align: middle; display:none;">수정일자</th>                      
				<th style="width: 0%; font-weight: 900; font-size:14px; text-align:center; vertical-align: middle; display:none;">수정자</th>
				<th style="width: 0%; font-weight: 900; font-size:14px; text-align:center; vertical-align: middle; display:none;">지속기간</th>
				<th style="width: 178px; font-weight: 900; font-size:14px; text-align:center; vertical-align: middle;">수정사유</th>           
				<th style="width: 0%; font-weight: 900; font-size:14px; text-align:center; vertical-align: middle; display:none;">체크데이터 유형</th>
				<th style="width: 0%; font-weight: 900; font-size:14px; text-align:center; vertical-align: middle; display:none;">지연여부</th>     
				<th style="width: 0%; font-weight: 900; font-size:14px; text-align:center; vertical-align: middle; display:none;">생산공정여부</th>  
				<th style="width: 0%; font-weight: 900; font-size:14px; text-align:center; vertical-align: middle; display:none;">포장공정여부</th>  
				<th style="width: 8%; font-weight: 900; font-size:14px; text-align:center; vertical-align: middle">                               
					<button alt="한줄 추가" id="btn_plus"  class="btn btn-info btn-sm" disabled>+</button>                                                         
					<button alt="한줄 삭제" id="btn_mius"  class="btn btn-info btn-sm" disabled>-</button>                                                         
                </th>
			</tr>
		</thead>
		<tbody id="product_tbody"></tbody>
	</table>
	<table class="table table-bordered " style="width: 100%; margin: 0 ; align:left" id="bom_table">	               
		<tr>
			<td align="center">
				<button id="btn_Save"  class="btn btn-info" style="width: 100px" onclick="SaveOderInfo();">삭제</button>
				<button id="btn_Canc"  class="btn btn-info" style="width: 100px" onclick="parent.$('#modalReport').hide();">취소</button>
			</td>
		</tr>
	</table>
</body>
</html>