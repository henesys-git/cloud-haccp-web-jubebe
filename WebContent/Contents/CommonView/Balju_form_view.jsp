<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="mes.client.comm.*" %>
<%@ page import="mes.client.common.*" %>
<%@ page import="mes.client.guiComponents.*" %>
<%@ page import="mes.client.util.*" %>
<%@ page import="mes.client.conf.*" %>
<%@ page import="org.json.simple.*"%>
<!DOCTYPE html>

<%
/* 
Balju_form_view.jsp
발주서 View Form 
*/
	String loginID = session.getAttribute("login_id").toString();
	String member_key = session.getAttribute("member_key").toString();
	DoyosaeTableModel TableModel;
	String zhtml = "";
	
	String[] strColumnHead 	= {"order_no", "balju_no", "balju_text", "balju_send_date", "cust_nm", "cust_damdang", "tell_no", "fax_no", "balju_nabgi_date", 
			"nabpoom_location", "qa_ter_condtion", "balju_status", "review_no", "confirm_no"};	

	
	String GV_ORDERNO="", GV_ORDER_DETAIL_SEQ="", GV_JSPPAGE="", GV_NUM_GUBUN="",GV_BALJUNO="";
	
	if(request.getParameter("OrderNo")== null)
		GV_ORDERNO = "";
	else
		GV_ORDERNO = request.getParameter("OrderNo");	
	
	if(request.getParameter("order_detail_seq")== null)
		GV_ORDER_DETAIL_SEQ="";
	else
		GV_ORDER_DETAIL_SEQ = request.getParameter("order_detail_seq");
	
	
	if(request.getParameter("jspPage")== null)
		GV_JSPPAGE="0";
	else
		GV_JSPPAGE = request.getParameter("jspPage");	

	if(request.getParameter("num_gubun")== null)
		GV_NUM_GUBUN="";
	else
		GV_NUM_GUBUN = request.getParameter("num_gubun");
	
	if(request.getParameter("BaljuNo")== null)
		GV_BALJUNO = "";
	else
		GV_BALJUNO = request.getParameter("BaljuNo");
	
	String param =GV_ORDERNO+ "|" + GV_BALJUNO + "|";
	
	JSONObject jArray = new JSONObject();
	jArray.put( "member_key", member_key);
	jArray.put( "order_no", GV_ORDERNO);
	jArray.put( "order_detail_seq", GV_ORDER_DETAIL_SEQ);
	jArray.put( "jsppage", GV_JSPPAGE);
	jArray.put( "num_gubun", GV_NUM_GUBUN);
	jArray.put( "baljuno", GV_BALJUNO);
	
//     TableModel = new DoyosaeTableModel("M202S010100E134", strColumnHead, param);
    TableModel = new DoyosaeTableModel("M202S010100E134", strColumnHead, jArray);
 	int RowCount =TableModel.getRowCount();
  		
 // tbm_our_company_info 데이터 불러오기
    String[] strColumnHeadE125 	= { "bizno","revision_no","cust_nm","address","telno","boss_name","uptae","jongmok","faxno","homepage","zipno",
    								"start_date","create_date","create_user_id","modify_date","modify_user_id","modify_reason","duration_date","seal_img_filename", "history_yn" };
    JSONObject jArrayE125 = new JSONObject();
    jArrayE125.put( "member_key", member_key);
    DoyosaeTableModel TableModelE125 = new DoyosaeTableModel("M101S040100E125", strColumnHeadE125, jArrayE125);
    int RowCountE125 =TableModelE125.getRowCount();
%>
    
    <script type="text/javascript">
    var JOB_GUBUN = "";
    
    var vTableS202S010140_print;
	var vTableS202S010140;
	var TableS202S010140_info;
    var TableS202S010140_RowCount;
    var S202S010140_Row_index = -1;
    
    $(document).ready(function () {
		<%if(RowCount>0){%>
			  	
    	<%}%> 
        $.ajax({
	        type: "POST",
            url: "<%=Config.this_SERVER_path%>/Contents/Business/M202/S202S010140.jsp", 
	        data: "order_no=" + '<%=GV_ORDERNO%>' + "&balju_no=" + '<%=GV_BALJUNO%>',
	        beforeSend: function () {
	            $("#bom_tbody").children().remove();
	        },
	        success: function (html) {
	            $("#bom_tbody").hide().html(html).fadeIn(100);

// 	            TableS202S010140_info = vTableS202S010140.page.info(); URL error
// 	            TableS202S010140_RowCount = TableS202S010140_info.recordsTotal; 
    			
// 	            for(var i=0; i<TableS202S010140_RowCount+1; i++){
// 	    			$($("#TableS202S010140 tr")[i]).find("td").eq(14).prop('style', 'width:0px; display: none;');
// 	    			$($("#TableS202S010140 tr")[i]).find("th").eq(14).prop('style', 'width:0px; display: none;');
// 	            }
	        },
	        error: function (xhr, option, error) {
	        }
 		});

        <%if(RowCountE125>0) {%>
        var imageFileName = "<%=TableModelE125.getValueAt(0,19).toString().trim()%>";
		if(imageFileName!=null && imageFileName!="") {
			$("#SealImageFile").attr("src", "<%=Config.this_SERVER_path%>/images/SULBI/" 
					+ imageFileName + "?v=" + Math.random());
		}
		<%}%>
    });	
    
    
    
    btn_Print.onclick = function (e) {
    	var url= "<%=Config.this_SERVER_path%>/Contents/CommonView/Balju_form_view_print.jsp?order_no=" + '<%=GV_ORDERNO%>' 
    			+ "&order_detail_seq=" + '<%=GV_ORDER_DETAIL_SEQ%>'
    			+ "&BaljuNo=" + '<%=GV_BALJUNO%>';
    	fn_CommonPopup(url, "", 1336, 950);
    	parent.$('#modalReport').hide();
//     	$.ajax({
// 	        type: "POST",
<%--             url: "<%=Config.this_SERVER_path%>/Contents/CommonView/Balju_form_view_print.jsp?",  --%>
<%-- 	        data: "order_no=" + '<%=GV_ORDERNO%>' + "&order_detail_seq=" + '<%=GV_ORDER_DETAIL_SEQ%>',  --%>
// 	        beforeSend: function () {
// 	        },
// 	        success: function (html) {
// 	        	$("#bom_tbody_print").hide().html(html);
// 	        },
// 	        error: function (xhr, option, error) {
// 	        },
// 	        complete: function(){
	        	
// 	    		var windowContent = '<!DOCTYPE html>';
// 	    	    windowContent += '<html>'
// 	    	    windowContent += '<head><title>주문별 공정진척율</title></head>';
// 	    	    windowContent += '<body>'
// 	    	    windowContent += $("#PrintArea").html();
// 	    	    windowContent += '</body>';
// 	    	    windowContent += '</html>';
// 	    		jQuery.print($(windowContent));
	    		
// // 	        	jQuery.print($("#PrintArea").html());
// 	        }
//  		});			
	}
    
  
    </script>
    
	    <div id="bom_tbody_print"></div>
	<div id="PrintAreaP" >
	
	<table class="table table-bordered" style="width: 100%; margin: 0 auto; align:center; border:1px solid black !important;">
		<tr>
			<td style="font-weight: 900; font-size:20px; vertical-align: middle; text-align:center; border:1px solid black !important;" colspan="10">발주서<br>(Purchase Order)</td>
		</tr>
		<tr>
			<td  style= "width:250px; font-size:14px; vertical-align: middle; text-align:center; border:1px solid black !important;">수 신 처</td>
			<td colspan="9" style="font-size:14px; vertical-align: middle ;text-align:left; border:1px solid black !important;" id="txt_telNo">
				<%=TableModel.getValueAt(0,4).toString().trim()%>
			</td>
			
		</tr>
		<tr>
			<td style="font-weight: 900; font-size:14px; vertical-align: middle; text-align:center; border:1px solid black !important;">수 신 인</td>
			<td colspan="9" style="font-size:14px; vertical-align: middle ;text-align:left; border:1px solid black !important;" id="txt_chuha_dt">
				<%=TableModel.getValueAt(0,5).toString().trim()%>
			</td>
			
		</tr>
		<tr>
			<td style="font-weight: 900; font-size:14px; vertical-align: middle; text-align:center; border:1px solid black !important;">전 화 번 호</td>
			<td colspan="9" style="font-size:14px; vertical-align: middle ;text-align:left; border:1px solid black !important;" id="txt_telNo">
				<%=TableModel.getValueAt(0,6).toString().trim()%>
			</td>
			
		</tr>
		<tr>
			<td style="font-weight: 900; font-size:14px; vertical-align: middle; text-align:center; border:1px solid black !important;">팩 스 번 호</td>
			<td colspan="9" style="font-size:14px; vertical-align: middle ;text-align:left; border:1px solid black !important;" id="txt_FaxNo">
				<%=TableModel.getValueAt(0,7).toString().trim()%>
			</td>
			
		</tr>
		<tr>
			<td style="font-weight: 900; font-size:14px; vertical-align: middle; text-align:center; border:1px solid black !important;">제 목</td>
			<td colspan="9" style="font-size:14px; vertical-align: middle ;text-align:left; border:1px solid black !important;" id="txt_balju_text">
				<%=TableModel.getValueAt(0,2).toString().trim()%>
			</td>
			
		</tr>
<!-- 		<tr> -->
<!-- 	    	<td colspan="7" style="font-weight: 900; font-size:14px; vertical-align: middle; text-align:center;">귀 중</td> -->
	    	
<!-- 	  	</tr> -->
		
		
	</table>
	<br>
	<br>
	<br>
<!-- 			<table class="table table-bordered" id="TableS202S010140" style="width: 100%; border:1px solid black !important;"> -->
<!-- 		<thead> -->
<!-- 	        <tr style="vertical-align: middle"> -->
<!-- 	            <th style="width: 8%; font-weight: 900; font-size:14px; text-align:left; vertical-align: middle; border:1px solid black !important;">번호</th> -->
<!-- 	            <th style="width:20%; font-weight: 900; font-size:14px; text-align:left; vertical-align: middle; border:1px solid black !important;">품명</th> -->
<!-- 	            <th style="width:20%; font-weight: 900; font-size:14px; text-align:left; vertical-align: middle; border:1px solid black !important;">품번</th> -->
<!-- 	            <th style="width: 8%; font-weight: 900; font-size:14px; text-align:left; vertical-align: middle; border:1px solid black !important;">규격</th> -->
<!-- 	            <th style="width: 8%; font-weight: 900; font-size:14px; text-align:left; vertical-align: middle; border:1px solid black !important;">수량</th> -->
<!-- 	            <th style="width: 8%; font-weight: 900; font-size:14px; text-align:left; vertical-align: middle; border:1px solid black !important;">단가</th> -->
<!-- 	            <th style="width: 8%; font-weight: 900; font-size:14px; text-align:left; vertical-align: middle; border:1px solid black !important;">금액</th> -->
<!-- 	            <th style="width:20%; font-weight: 900; font-size:14px; text-align:left; vertical-align: middle; border:1px solid black !important;">Rev</th> -->
<!-- 	        </tr>		    	 -->
<!-- 		</thead> -->
	    <div id="bom_tbody">		
		</div>
<!-- 	</table> -->
	
	<table style="width: 100%;">
		<tr>
	    	<td colspan="8" style="font-weight: 900; font-size:14px; vertical-align: middle; text-align:center;"></td>
	  	</tr>
	  	<tr>
	    	<td colspan="8" style="font-weight: 900; font-size:14px; vertical-align: middle; text-align:center;"></td>
	  	</tr>
	  	<br/>
	  	<br/>
	  	<br/>
		<tr>
	    	<td colspan="7" style="font-weight: 900; font-size:14px; vertical-align: middle; text-align:left;">발주번호 : <%=TableModel.getValueAt(0, 1).toString().trim()%></td>
	    	
	  	</tr>
	  	<tr>
	    	<td colspan="7" style="font-weight: 900; font-size:14px; vertical-align: middle; text-align:left;">납기일 : <%=TableModel.getValueAt(0, 8).toString().trim()%></td>
	    	<td style="font-weight: 900; font-size:14px; vertical-align: middle; text-align:left">
	    		
	    	</td>
	  	</tr>
	  	<tr>
	    	<td colspan="7" style="font-weight: 900; font-size:14px; vertical-align: middle; text-align:left;">납품위치 : <%=TableModel.getValueAt(0, 9).toString().trim()%> </td>
	    	
	  	</tr>
	  	<tr>
	    	<td colspan="7" style="font-weight: 900; font-size:14px; vertical-align: middle; text-align:left;">품질 요구 조건 : <%=TableModel.getValueAt(0, 10).toString().trim()%> </td>
	    	
	  	</tr>
	  	<tr>
	  	<td></td>
	  	<td style="font-weight: 900; font-size:14px; vertical-align: middle; text-align:right">
	    		<img id="SealImageFile" width="50" height="50" ></img>
	    	</td>
	    	</tr>
	  	
	  	<tr>
	  	 
	    	</tr>
		
		
	</table>

		
		
	</div>
		
        <table class="table table-striped" style="width: 100%; margin: 0 ; align:left ;" id="bom_table">
 	        <tr style="height: 60px">
	            <td style="text-align:center; background-color: white;" >
	                <p>
	                	<button id="btn_Print"  class="btn btn-info"  >프린트</button>
	                    <button id="btn_Canc"  class="btn btn-info"  onclick="parent.$('#modalReport').hide();">닫기</button>
<!-- 				<button type="button"  id="btn_Print" class="btn btn-outline-success"  -->
<!-- 								style="width: 110px; float: left; margin-left:30px; " >프린트</button> -->
				
	                </p>
	            </td>
	        </tr>
	    </table>