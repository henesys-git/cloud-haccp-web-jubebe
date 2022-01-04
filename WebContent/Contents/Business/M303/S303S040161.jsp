<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="mes.client.comm.*" %>
<%@ page import="mes.client.common.*" %>
<%@ page import="mes.client.guiComponents.*" %>
<%@ page import="mes.client.util.*" %>
<%@ page import="mes.client.conf.*" %>
<%@ page import="org.json.simple.*"%><%@ include file="/strings.jsp" %>
<!DOCTYPE html>

<%
	String loginID = session.getAttribute("login_id").toString();
	String member_key = session.getAttribute("member_key").toString();
	
	DoyosaeTableModel TableModel; 
	
	String GV_ORDER_NO="", GV_LOTNO="",
			GV_PROD_CD="", GV_PROD_CD_REV="";

	if(request.getParameter("OrderNo")== null)
		GV_ORDER_NO="";
	else
		GV_ORDER_NO = request.getParameter("OrderNo");
	
	if(request.getParameter("LotNo")== null)
		GV_LOTNO="";
	else
		GV_LOTNO = request.getParameter("LotNo");
	
	if(request.getParameter("prod_cd")== null)
		GV_PROD_CD="";
	else
		GV_PROD_CD = request.getParameter("prod_cd");

	if(request.getParameter("prod_cd_rev")== null)
		GV_PROD_CD_REV="";
	else
		GV_PROD_CD_REV = request.getParameter("prod_cd_rev");
	
	JSONObject jArray = new JSONObject();
	jArray.put( "order_no", GV_ORDER_NO);
	jArray.put( "lotno", GV_LOTNO);
	jArray.put( "prod_cd", GV_PROD_CD);
	jArray.put( "prod_cd_rev", GV_PROD_CD_REV);
	jArray.put( "member_key", member_key);
	
    TableModel = new DoyosaeTableModel("M303S040100E134", jArray);	
 	int RowCount =TableModel.getRowCount();
 	
 	StringBuffer html = new StringBuffer();
 	if(RowCount>0){
		html.append("$('#txt_order_no').val('" 		+ TableModel.getValueAt(0,2).toString().trim() + "');\n");
		html.append("$('#txt_lotno').val('" 		+ TableModel.getValueAt(0,3).toString().trim() + "');\n");
		html.append("$('#txt_prod_cd').val('" 		+ TableModel.getValueAt(0,4).toString().trim() + "');\n");
		html.append("$('#txt_prod_nm').val('" 		+ TableModel.getValueAt(0,5).toString().trim() + "');\n");
	    html.append("$('#txt_lot_count').val('" 	+ TableModel.getValueAt(0,6).toString().trim() + "');\n");
	    html.append("$('#txt_delivery_date').val('" + TableModel.getValueAt(0,7).toString().trim() + "');\n");
	    html.append("$('#txt_prod_cd_rev').val('" 	+ TableModel.getValueAt(0,8).toString().trim() + "');\n");
 	}

%>    
    <script type="text/javascript">
// 	var v_worker_input_table;
// 	var v_worker_input_table_Row_index = -1;
// 	var v_worker_input_table_info;
// 	var v_worker_input_table_RowCount=0;

    $(document).ready(function () {
	    v_worker_input_table = $('#worker_input_table').DataTable({
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
		          			$(td).attr('style', 'width:5%;'); 
		       		}
				},
		    	{
		       		'targets': [1],
		       		'createdCell':  function (td) {
		          			$(td).attr('style', 'width:30%;'); 
		       		}
				},
				{
		       		'targets': [5],
		       		'createdCell':  function (td) {
		          			$(td).attr('style', 'width:25%;'); 
		       		}
				},
		    	{
		       		'targets': [2,3,4,6], 
		       		'createdCell':  function (td) {
		          			$(td).attr('style', 'width:10%;'); 
		       		}
				}
            ],
            language: { 
                url:"<%=Config.this_SERVER_path%>/AdminLTE-3.0.5/localisation/Korean.json"
             }
		});	
	    
	    v_worker_input_table_info = v_worker_input_table.page.info();
        v_worker_input_table_RowCount = v_worker_input_table_info.recordsTotal;
	    
	    $("#btn_plus").click(function(){ 
	    	fn_plus_body();
	    }); 
	    $("#btn_mius").click(function(){ 
	    	fn_mius_body(); 
	    });
	    
		<%=html%>
    });
    
    function select_worker(obj){
    	var tr = $(obj).parent().parent();
    	var trNum = $(tr).closest('tr').prevAll().length;
    	
    	v_worker_input_table_Row_index = v_worker_input_table.row(trNum).index();
    	
    	parent.pop_fn_UserList_View(3);
    }
	
    function SetUser_Select(user_id, revision_no, user_nm, hour_pay){
    	// id중복방지
    	for(i=0; i<v_worker_input_table_RowCount; i++) {
    		var trInput2 = $($("#product_tbody tr")[i]).find(":input");
    		var trInput2_id = trInput2.eq(3).val();
    		if(trInput2_id == user_id) {
    			alert("이미 입력된 사용자입니다! 다른 사용자를 선택하세요");
    			return;
    		}
    	}
    	
   		var trInput = $($("#product_tbody tr")[v_worker_input_table_Row_index]).find(":input");
   		trInput.eq(1).val(user_nm);
   		trInput.eq(3).val(user_id);
   		trInput.eq(4).val(revision_no);
   		trInput.eq(5).val(hour_pay);
   		fn_calc_total_pay(v_worker_input_table_Row_index);
    }
    
    function fn_plus_body(){
    	v_worker_input_table_info = v_worker_input_table.page.info();
        v_worker_input_table_RowCount = v_worker_input_table_info.recordsTotal;
    	
    	v_worker_input_table.row.add( [
    		"	<input type='text' class='form-control' id='txt_detail_seq'  style='width:100%;' readonly value='" + (v_worker_input_table_RowCount+1) + "'></input>",
    		"	<input type='text' class='form-control' id='txt_user_nm' style='float:left; width:70%;' readonly></input>" +
    		"	<button type='button' onclick='select_worker(this);' id='btn_SearchProd' class='btn btn-info' style='float:left;width:30%;'>검색</button> " +
    		"	<input type='hidden' class='form-control' id='txt_user_id' readonly></input>" +
    		"	<input type='hidden' class='form-control' id='txt_user_id_rev' readonly></input>",
    		"	<input type='text' class='form-control' id='txt_hour_pay' readonly></input>",
    		"	<input type='text' class='form-control' id='txt_work_hour' onchange='fn_calc_total_pay(" + v_worker_input_table_RowCount + ")'></input>",
    		"	<input type='text' class='form-control' id='txt_total_pay' readonly></input>",
    		"	<input type='text' class='form-control' id='txt_bigo' style='width:100%;' ></input>",
    		""
        ] ).draw();
    	
	    // 숫자만
	    $("input:text[numberOnly]").on("keyup", function() {
	        $(this).val($(this).val().replace(/[^0-9]/g,""));
	    });
    }
    
    function fn_calc_total_pay(trIndex) {
    	var trInput = $($("#product_tbody tr")[trIndex]).find(":input");
    	
    	if(trInput.eq(5).val().length < 1)
			var v_hour_pay = 0;
		else
			var v_hour_pay = parseInt(trInput.eq(5).val());
    	if(trInput.eq(6).val().length < 1)
    		var v_work_hour = 0;
    	else
			var v_work_hour = parseInt(trInput.eq(6).val());
		
		trInput.eq(7).val(v_hour_pay * v_work_hour);
    }
    
    function fn_mius_body(){  	        
        v_worker_input_table.row( v_worker_input_table_RowCount-1 ).remove().draw();

        v_worker_input_table_info = v_worker_input_table.page.info();
        v_worker_input_table_RowCount = v_worker_input_table_info.recordsTotal;
    }   
    </script>

   <table class="table table-bordered" style="width: 100%; margin: 0 auto; align:left">
   	<tr>   
		<td style="width: 47%;">
   			<table class="table " style="width: 100%; margin: 0 auto; align:left">
		        <tr style="background-color: #fff;">
		            <td style="width: 15%; font-weight: 900; font-size:14px; text-align:left">주문번호</td>
		            <td style="width: 35%; font-weight: 900; font-size:14px; text-align:left">
						<input type="text" class="form-control" id="txt_order_no" style="float:left;width:200px;"  readonly/>
		           	</td>
		            <td style="width: 15%; font-weight: 900; font-size:14px; text-align:left">Lot No</td>
		            <td style="width: 35%; font-weight: 900; font-size:14px; text-align:left">
						<input type="text" class="form-control" id="txt_lotno" style="float:left;width:200px;"  readonly/>
		           	</td>
		        </tr>

				<tr style="background-color: #fff;">
		            <td style=" font-weight: 900; font-size:14px; text-align:left">제품코드</td>
		            <td >
		            	<input type="text" class="form-control" id="txt_prod_cd" style="float:left;width:200px;"  readonly/>
		            	<input type="hidden" class="form-control" id="txt_prod_cd_rev" style="float:left;width:200px;"  readonly/>
					</td>
		            <td style=" font-weight: 900; font-size:14px; text-align:left">제품명</td>
		            <td>
		            	<input type="text" class="form-control" id="txt_prod_nm" style="float:left;width:200px;"  readonly/>
		            </td>
		        </tr>

		        <tr style="background-color: #fff;">
		        	<td style=" font-weight: 900; font-size:14px; text-align:left;"  >Lot 수량</td>
		        	<td>
		        		<input type="text" class="form-control" id="txt_lot_count" style="float:left;width:200px;"  readonly/>
		            </td>
		            <td style=" font-weight: 900; font-size:14px; text-align:left;">납품예정일자</td>
		        	<td>
		        		<input type="text" class="form-control" id="txt_delivery_date" style="float:left;width:200px;"  readonly/>
		            </td>
		        </tr>
        	</table>
        	    <table class="table " id="worker_input_table" style="width: 100%; margin: 0 auto; align:left">
				<thead>
			        <tr style="vertical-align: middle">
			            <th style="width: 5%; font-weight: 900; font-size:14px; text-align:center; vertical-align: middle">#</th>
			            <th style="width: 30%; font-weight: 900; font-size:14px; text-align:center; vertical-align: middle">작업자</th>
			            <th style="width: 10%; font-weight: 900; font-size:14px; text-align:center; vertical-align: middle">작업자 시급</th>
			            <th style="width: 10%; font-weight: 900; font-size:14px; text-align:center; vertical-align: middle">투입시간</th>
			            <th style="width: 10%; font-weight: 900; font-size:14px; text-align:center; vertical-align: middle">총 임금</th>		            
			            <th style="width: 25%; font-weight: 900; font-size:14px; text-align:center; vertical-align: middle">비고</th>
			            <th style="width: 10%; font-weight: 900; font-size:14px; text-align:center; vertical-align: middle">
		                	<button alt="한줄 추가" id="btn_plus"  class="btn btn-info btn-sm" >+</button>
		                	<button alt="한줄 삭제" id="btn_mius"  class="btn btn-info btn-sm" >-</button></th>
			        </tr>
				</thead>
		        <tbody id="product_tbody">
		        </tbody>
		    </table>
        </td>
		</tr>
<!--         <tr style="height: 60px"> -->
<!--             <td align="center" colspan="2"> -->
<!--                 <p> -->
<!--                 	<button id="btn_Save"  class="btn btn-info" style="width: 100px" onclick="SaveOderInfo();">저장</button> -->
<!--                     <button id="btn_Canc"  class="btn btn-info" style="width: 100px" onclick="parent.$('#modalReport').hide();">취소</button> -->
<!--                 </p> -->
<!--             </td> -->
<!--         </tr> -->
    </table>
