<%@page import="com.mysql.cj.result.Row"%>
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
	
	Vector optCode =  null;
	Vector optName =  null;
	Vector JumunStatusVector = CommonData.getStatusDataAll(member_key);

	String GV_RECALLED_NO="", GV_RECALLED_DATE="",
			GV_PROD_CD="", GV_PROD_REV="",
			GV_CUST_CD="", GV_CUST_CD_REV="";
	
	if(request.getParameter("recalled_no")== null)
		GV_RECALLED_NO = "";
	else
		GV_RECALLED_NO = request.getParameter("recalled_no");	
	
	if(request.getParameter("recalled_date")== null)
		GV_RECALLED_DATE = "";
	else
		GV_RECALLED_DATE = request.getParameter("recalled_date");
	
	if(request.getParameter("prod_cd")== null)
		GV_PROD_CD = "";
	else
		GV_PROD_CD = request.getParameter("prod_cd");
	
	if(request.getParameter("prod_cd_rev")== null)
		GV_PROD_REV = "";
	else
		GV_PROD_REV = request.getParameter("prod_cd_rev");
	
	if(request.getParameter("cust_cd")== null)
		GV_CUST_CD = "";
	else
		GV_CUST_CD = request.getParameter("cust_cd");
	
	if(request.getParameter("cust_cd_rev")== null)
		GV_CUST_CD_REV = "";
	else
		GV_CUST_CD_REV = request.getParameter("cust_cd_rev");
	
	
	
	JSONObject jArray = new JSONObject();
	jArray.put( "recalled_no", GV_RECALLED_NO);
	jArray.put( "recalled_date", GV_RECALLED_DATE);
	jArray.put( "prod_cd", GV_PROD_CD);
	jArray.put( "prod_cd_rev", GV_PROD_REV);
	jArray.put( "cust_cd", GV_CUST_CD);
	jArray.put( "cust_cd_rev", GV_CUST_CD_REV);
	jArray.put( "member_key", member_key);
	
    TableModel = new DoyosaeTableModel("M838S090100E124", jArray);
	int RowCount = TableModel.getRowCount();
	
	StringBuffer html = new StringBuffer();
	
	String revisionNumberStr = "";
	int revisionNoInt = 0;
	
	for(int i=0; i<TableModel.getRowCount(); i++){
		for(int j=0; j<21; j++){
			System.out.println("111111111 TableModel.getValueAt(" + i + "," +  j + ")" + TableModel.getValueAt(i, j).toString().trim());
		}
	}
	
	if(RowCount>0) {
		// 데이터를 가져온다.
	    Vector targetVector = (Vector)(TableModel.getVector().get(0));
		
	 	// 개정번호를 만든다.
	    try {
			revisionNoInt = Integer.parseInt( targetVector.get(1).toString().trim() );
	    } catch (Exception e) {
	    	revisionNoInt = 0;
	    }
	    revisionNoInt = revisionNoInt + 1;
	    revisionNumberStr = "" + revisionNoInt;
		
		html.append("$('#txt_recalled_no').val('" 		+ TableModel.getValueAt(0,0).toString().trim() + "');\n");
		html.append("$('#txt_recalled_rev').val('" 		+ TableModel.getValueAt(0,1).toString().trim() + "');\n");
		html.append("$('#txt_recalled_date').val('" 	+ TableModel.getValueAt(0,2).toString().trim() + "');\n");
		html.append("$('#txt_prod_name').val('" 		+ TableModel.getValueAt(0,3).toString().trim() + "');\n");
		html.append("$('#txt_prod_cd').val('" 			+ TableModel.getValueAt(0,4).toString().trim() + "');\n");
		html.append("$('#txt_prod_cd_rev').val('" 		+ TableModel.getValueAt(0,5).toString().trim() + "');\n");
		html.append("$('#txt_cust_name').val('" 		+ TableModel.getValueAt(0,6).toString().trim() + "');\n");
		html.append("$('#txt_cust_cd').val('" 			+ TableModel.getValueAt(0,7).toString().trim() + "');\n");
		html.append("$('#txt_cust_cd_rev').val('" 		+ TableModel.getValueAt(0,8).toString().trim() + "');\n");
		html.append("$('#txt_recalled_reason').val('" 	+ TableModel.getValueAt(0,9).toString().trim() + "');\n");
		html.append("$('#select_proced_yn').val('" 		+ TableModel.getValueAt(0,10).toString().trim() + "');\n");
		html.append("$('#txt_recalled_note').val('" 	+ TableModel.getValueAt(0,11).toString().trim() + "');\n");
		html.append("$('#txt_uniqueness').val('" 		+ TableModel.getValueAt(0,12).toString().trim() + "');\n");
		html.append("$('#txt_writor_main').val('" 		+ TableModel.getValueAt(0,13).toString().trim() + "');\n");
		html.append("$('#txt_writor_main_rev').val('" 	+ TableModel.getValueAt(0,14).toString().trim() + "');\n");
		html.append("$('#txt_write_date').val('" 		+ TableModel.getValueAt(0,15).toString().trim() + "');\n");
		html.append("$('#txt_reviewer').val('" 			+ TableModel.getValueAt(0,16).toString().trim() + "');\n");
		html.append("$('#txt_review_date').val('" 		+ TableModel.getValueAt(0,17).toString().trim() + "');\n");
		html.append("$('#txt_approval').val('" 			+ TableModel.getValueAt(0,18).toString().trim() + "');\n");
		html.append("$('#txt_approval_date').val('" 	+ TableModel.getValueAt(0,19).toString().trim() + "');\n");
	}
	
%>
    
    <script type="text/javascript">
//     웹소켓 통신을 위해서 필요한 변수들 ---시작
	var SQL_Param = {
			PID:  "M838S090100E103", 
			excute: "queryProcess",
			stream: "N",
			param: ""
	};
//  웹소켓 통신을 위해서 필요한 변수들 ---끝	
    
    $(document).ready(function () {
        
        <%=html%>
        
        textarea_encoding();    
    });
    

//     function textarea_encoding(){
<%-- 	       var str = '<%=TableModel.getValueAt(0,12).toString().trim()%>'; --%>
// 	       var result = str.replace(/(<br>|<br\/>|<br\/>)/g, '\r\n');
// 	        $('#txt_req_contents').val(result);
// 	}
    
function SaveOderInfo() {        
	var dataJson = new Object();
	
	dataJson.recalled_no 		= "<%=GV_RECALLED_NO%>";
	dataJson.recalled_rev 		= $("#txt_recalled_rev").val();
	dataJson.recalled_date 		= $("#txt_recalled_date").val();
	dataJson.prod_cd 			= $("#txt_prod_cd").val();
	dataJson.prod_cd_rev 		= $("#txt_prod_cd_rev").val();
	dataJson.cust_cd 			= $("#txt_cust_cd").val();
	dataJson.cust_cd_rev 		= $("#txt_cust_cd_rev").val();
	dataJson.recalled_reason 	= $("#txt_recalled_reason").val();
	dataJson.proced_yn		 	= $("#select_proced_yn").val();
	dataJson.recalled_note 		= $("#txt_recalled_note").val();
	dataJson.uniqueness 		= $("#txt_uniqueness").val();
	dataJson.writor_main 		= $("#txt_writor_main").val();
	dataJson.writor_main_rev 	= $("#txt_writor_main_rev").val();
	dataJson.write_date 		= $('#txt_write_date').val();
	dataJson.reviewer 			= $("#txt_reviewer").val();
	dataJson.review_date 		= $("#txt_review_date").val();
	dataJson.approval 			= $("#txt_approval").val();
	dataJson.approval_date 		= $("#txt_approval_date").val();
	dataJson.member_key 		= "<%=member_key%>";
	
	var JSONparam = JSON.stringify(dataJson);
	
//		console.log(JSONparam);
	
	var chekrtn = confirm("삭제하시겠습니까?"); 
	
	if(chekrtn){
		SendTojsp(JSONparam, SQL_Param.PID);		
	}
}

	function SendTojsp(bomdata, pid){
		$.ajax({
			type: "POST",
	        dataType: "json", // Ajax로 json타입으로 보낸다.
	     	url: "<%=Config.this_SERVER_path%>/Contents/CommonView/insert_update_delete_json.jsp",
	     	data:  {"bomdata" : bomdata, "pid" : pid },
	        beforeSend: function () {
//	        	alert(bomdata);
	        },
	        success: function (html) {	 
	        	if(html>-1){
	        		parent.fn_MainInfo_List();
	 	            parent.$("#ReportNote").children().remove();
	 	         	parent.$('#modalReport').hide(); 
	         	}
	        },
	        error: function (xhr, option, error) {
	        }
		});		
	}  
	
    </script>

	<table class="table table-hover" style="width: 100%; margin: 0 auto; align:left">
        
        <tr style="background-color: #fff; height: 40px;  display: none;" >
            <td>회수등록번호</td>
            <td>
            	<input type="hidden" class="form-control" id="txt_recalled_no" style="width: 200px; height:100%" />
           	</td>
        </tr>
        
         <tr style="background-color: #fff; height: 40px;  display: none;">
            <td>회수개정번호</td>
            <td>
            	<input type="hidden" class="form-control" id="txt_recalled_rev" style="width: 200px; height:100%" />
           	</td>
        </tr>

        <tr style="background-color: #fff; height: 40px">
            <td>반품회수일</td>
            <td>
            	<input type='text' data-date-format='yyyy-mm-dd' class='form-control' id='txt_recalled_date' style="width: 200px; height:100%; border: solid 1px #cccccc; " />
           	</td>
        </tr>

        <tr style="background-color: #fff; height: 40px">
            <td>제품명</td>
            <td>
            	<input type="text" class="form-control" id="txt_prod_name" style="float:left; width: 200px; height:100%; margin-right:10px;"  readonly/>
            	<input type="hidden" class="form-control" id="txt_prod_cd" readonly/>
            	<input type="hidden" class="form-control" id="txt_prod_cd_rev"readonly/>
            	<button type='button' onclick="parent.pop_fn_ProductName_View(1,'ALL')" id='btn_SearchProd' class='btn btn-info' style='width:20%; height: 26px; padding-top: 1px;'>검색</button>
           	</td>
        </tr>
        
        <tr style="background-color: #fff; height: 40px">
            <td>출고처</td>
            <td>
            	<input type="text" class="form-control" id="txt_cust_name"  style="float:left; width: 200px; height:100%; margin-right:10px;" readonly />
            	<input type="hidden" class="form-control" id="txt_cust_cd" readonly />
            	<input type="hidden" class="form-control" id="txt_cust_cd_rev"  readonly />
            	<button type="button" onclick="parent.pop_fn_CustName_View(1,'O')" id="btn_SearchCust" class="btn btn-info" style='width:20%; height: 26px; padding-top: 1px;'>검색</button>
            	
           	</td>
        </tr>
         
        <tr style="background-color: #fff; height: 40px">
            <td>반품사유</td>
            <td style='width:5%; height:26px; vertical-align: middle; text-align:left; '>
<!--        <input type="text" class="form-control" id="txt_recalled_reason" style="width: 200px; height:100%"  /> -->
            	<select class="form-control" id="txt_recalled_reason" style="width: 120px; margin-right: 20px; height:26px; padding-top:1px;">
		            <option id="selectType" value="리콜" selected>리콜</option>
		            <option id="selectType" value="불만" >불만</option>
					<option id="selectType" value="오배송">오배송</option>
				</select>
           	</td>
        </tr>
        
        <tr style="background-color: #fff; height: 40px">
            <td>처리여부</td>
            <td style='width:5%; height:26px; vertical-align: middle; text-align:left; '>
                <select class="form-control" id="select_proced_yn" style="width: 120px; margin-right: 20px; height:26px; padding-top:1px;">
		            <option id="selectType" value="승인" selected>승인</option>
		            <option id="selectType" value="보류" >보류</option>
					<option id="selectType" value="거부">거부</option>
				</select>
            </td>
        </tr>

        <tr style="background-color: #fff; height: 40px">
            <td>처리결과</td>
            <td style='width:5%; height:26px; vertical-align: middle; text-align:left; '>
                <select class="form-control" id="txt_recalled_note" style="width: 120px; margin-right: 20px; height:26px; padding-top:1px;">
		            <option id="selectType" value="재사용" selected>재사용</option>
		            <option id="selectType" value="일부사용" >일부사용</option>
					<option id="selectType" value="전량폐기">전량폐기</option>
				</select>
            </td>
        </tr>
        
        <tr style="background-color: #fff; height: 40px">
            <td>특이사항</td>
            <td>
            	<input type="text" class="form-control" id="txt_uniqueness" style="width: 300px; height:100%;"  />
           	</td>
        </tr>
        
          <tr style="background-color: #fff; height: 40px; display: none;">
            <td>작성자</td>
            <td>
            	<input type="hidden" class="form-control" id="txt_writor_main" style="width: 200px; height:100%"  />
            	<input type="hidden" class="form-control" id="txt_writor_main_rev" style="width: 200px; height:100%"  />
           	</td>
        </tr>

        <tr style="background-color: #fff; height: 40px">
            <td>작성일자</td>
            <td>
            	<input type='text' data-date-format='yyyy-mm-dd' class='form-control' id='txt_write_date'
            	style="width: 200px; height:100%; border: solid 1px #cccccc; " />
           	</td>
        </tr>
        
        <tr style="background-color: #fff; height: 40px">
            <td>검토자</td>
            <td>
            	<input type="text" class="form-control" id="txt_reviewer" style="width: 200px; height:100%"  />
           	</td>
        </tr>
        
        <tr style="background-color: #fff; height: 40px">
            <td>검토일자</td>
            <td>
            	<input type='text' data-date-format='yyyy-mm-dd' class='form-control' id='txt_review_date'
            	style="width: 200px; height:100%; border: solid 1px #cccccc; " />
           	</td>
        </tr>
        
        <tr style="background-color: #fff; height: 40px">
            <td>승인자</td>
            <td>
            	<input type="text" class="form-control" id="txt_approval" style="width: 200px; height:100%"  />
           	</td>
        </tr>
        
        <tr style="background-color: #fff; height: 40px">
            <td>승인일자</td>
            <td style="width: 60%;">
            	<input type='text' data-date-format='yyyy-mm-dd' class='form-control' id='txt_approval_date'
            	style="width: 200px; height:100%; border: solid 1px #cccccc; " />
           	</td>
        </tr>
		
        <tr style="height: 60px">
            <td colspan="4" align="center">
                <p>
                	<button id="btn_Save"  class="btn btn-info" style="width: 100px" onclick="SaveOderInfo();">삭제</button>
                    <button id="btn_Canc"  class="btn btn-info" style="width: 100px" onclick="parent.$('#modalReport').hide();">취소</button>
                </p>
            </td>
        </tr>
    </table>