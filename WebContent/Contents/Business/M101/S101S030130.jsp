<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="mes.client.comm.*" %>
<%@ page import="mes.client.common.*" %>
<%@ page import="mes.client.guiComponents.*" %>
<%@ page import="mes.client.util.*" %>
<%@ page import="mes.client.conf.*" %>
<%@ page import="org.json.simple.*"%><%@ include file="/strings.jsp" %>
<%
/*
	S101S030130.jsp : 제품검사체크리스트 (하단 TAB에서 POP UP으로 뜸)
*/

	DoyosaeTableModel TableModel;
	MakeTableHTML makeTableHTML;
	
	String[] strColumnHead 	= {"inspect_gubun","검사구분명", "주문번호", "order_check_no","주문명", "일련번호","Lot번호",  "Lot수량",
			"품번", "품명", "체크문항코드",	"작업표준", "체크문항내용","표준값", "체크항목유형", "비고",
			"prod_cd_rev", "checklist_seq", "checklist_cd_rev", "item_cd", "item_desc", "item_seq", "item_cd_rev"};
	int[] colOff 	=  {0,1,1, 1,0, 0, 0, 0, 
			1, 1,  1, 1, 1, 1, 1, 1, 
			0, 0, 0, 0, 0, 0,0};
	String[] TR_Style		= {""," onclick='S101S030180Event(this)' "};
	String[] TD_Style		= {"align:center;font-weight: bold;"}; 
	String[] HyperLink		= {""}; 
	String RightButton[][]	= {{"off", "fn_Chart_View", rightbtnChartShow},{"off", "fn_Doc_Reg()", rightbtnDocSave},{"off", "fn_mius_body(this)", "삭제"}};
	
	
	String loginID = session.getAttribute("login_id").toString();
	String member_key = session.getAttribute("member_key").toString();
	String GV_ORDER_NO="", GV_PROD_CD="", GV_PRODUCT_NAME="",GV_PROJECT_NAME="";
	String GV_LOT_NO="", GV_PROD_SERIAL_NO="", GV_LOT_COUNT="" ;
	String OrderDetailNo="";
	
	if(request.getParameter("OrderNo")== null)
		GV_ORDER_NO="";
	else
		GV_ORDER_NO = request.getParameter("OrderNo");
	
	if(request.getParameter("Project_name")== null)
		GV_PROJECT_NAME="";
	else
		GV_PROJECT_NAME = request.getParameter("Project_name");
	
	if(request.getParameter("Prod_serial_no")== null)
		GV_PROD_SERIAL_NO="";
	else
		GV_PROD_SERIAL_NO = request.getParameter("Prod_serial_no");
	
	if(request.getParameter("Prod_cd")== null)
		GV_PROD_CD="";
	else
		GV_PROD_CD = request.getParameter("Prod_cd");
	
	if(request.getParameter("Product_name")== null)
		GV_PRODUCT_NAME="";
	else
		GV_PRODUCT_NAME = request.getParameter("Product_name");

	if(request.getParameter("lotno")== null)
		GV_LOT_NO="";
	else
		GV_LOT_NO = request.getParameter("lotno");

	if(request.getParameter("lot_count")== null)
		GV_LOT_COUNT="";
	else
		GV_LOT_COUNT = request.getParameter("lot_count");

	JSONObject jArray = new JSONObject();
	jArray.put( "order_no", GV_ORDER_NO);
	jArray.put( "lotno", GV_LOT_NO);
	jArray.put( "member_key", member_key);
	
    TableModel = new DoyosaeTableModel("M101S030100E134", strColumnHead, jArray);
 	int RowCount =TableModel.getRowCount();	
	
// 	CurrentPage jspPageName = new CurrentPage(request.getRequestURI());
// 	String JSPpage = jspPageName.GetJSP_FileName();
// 	ProcesStatusCheck prcStatusCheck = new ProcesStatusCheck(JSPpage+"|"+"ODPROCS"+"|");
// 	String GV_GET_NUM_PREFIX = prcStatusCheck.GV_PROCESS_NUMBER_GUBUN;
%>
    
    <script type="text/javascript">

    $(document).ready(function () {

		<%if(RowCount>0){%>
<%-- 			$('#txt_project_name').val('<%=TableModel.getValueAt(0,4).toString()%>'); --%>
	
			$('#txt_product_serial_no').val('<%=TableModel.getValueAt(0,5).toString()%>');
			$('#txt_product_code').val('<%=TableModel.getValueAt(0,8).toString()%>');
			$('#txt_productname').val('<%=TableModel.getValueAt(0,9).toString()%>');
			
			$('#txt_lotno').val('<%=TableModel.getValueAt(0,6).toString()%>');
			$('#txt_lot_count').val('<%=TableModel.getValueAt(0,7).toString()%>');
		<%}%>
		$.ajax({
            type: "POST",
	         url: "<%=Config.this_SERVER_path%>/Contents/Business/M101/S101S030135.jsp", 
            data: "OrderNo=" + '<%=GV_ORDER_NO%>' + "&lotno=" + '<%=GV_LOT_NO%>' ,
            beforeSend: function () {
                $("#bom_tbody").children().remove();
            },
            success: function (html) {           	 
      			$("#bom_tbody").hide().html(html).fadeIn(100);
            },
            error: function (xhr, option, error) {
            }
        });		
    });
     </script>

	<div class="container-fluid">
        <table class="table table-striped " style="width: 100%; margin: 0 ; align:left">	        
<!--   			<tr> -->
<!-- 	            <td style="width: 5.5%;  font-weight: 900; font-size:14px; text-align:left;vertical-align: middle">주문명</td> -->
<!-- 	            <td colspan="7" style="width: 44.5%;  font-weight: 900; font-size:14px; text-align:lef; tmargin-left:10px;"> -->
<!-- 					<input type="text" class="form-control" id="txt_project_name" style="width: 45%;float:left;" readonly /> -->
					
<!-- 	           	</td> -->
<!-- 	            <td style=" font-weight: 900; font-size:14px; text-align:left;vertical-align: middle">일련번호</td> -->
<!-- 	            <td style=" font-weight: 900; font-size:14px; text-align:left;vertical-align: middle"></td> -->
<!-- 	            <td style=" font-weight: 900; font-size:14px; text-align:left; tmargin-left:10px;"> -->
<!-- 					<input type="text" class="form-control" id="txt_product_serial_no" style="width: 60%;" readonly/> -->
<!-- 	           	</td>	           		            -->
<!-- 	            <td style=" font-weight: 900; font-size:14px; text-align:left;vertical-align: middle"></td> -->
<!-- 	            <td style=" font-weight: 900; font-size:14px; text-align:left; tmargin-left:10px;"> -->
<!-- 	           	</td> -->
<!-- 	    	</tr> -->
  			<tr>
	            <td style="width: 6%;  font-weight: 900; font-size:14px; text-align:left;vertical-align: middle">품번</td>
	            <td style="width: 19%; font-weight: 900; font-size:14px; text-align:left">
					<input type="text" class="form-control" id="txt_product_code" style="width: 60%;" readonly/>
					<input type="hidden" class="form-control" id="txt_prod_rev"  readonly/>
					
					<input type="hidden" class="form-control" id="txt_orderno"  />
					<input type="hidden" class="form-control" id="txt_orderdetailseq" />
					<input type="hidden" class="form-control" id="txt_num_prefix" />
					<input type="hidden" class="form-control" id="txt_product_serial_no" style="width: 60%;" readonly/>					
	           	</td>	   	           
				<td style="width: 6.5%;  font-weight: 900; font-size:14px; text-align:left;vertical-align: middle">품명</td>
	            <td style="width: 18.5%; font-weight: 900; font-size:14px; text-align:left">
					<input type="text" class="form-control" id="txt_productname"  readonly/>
	           	</td>         
	           	<td style="width: 6%;  font-weight: 900; font-size:14px; text-align:left;vertical-align: middle">포장단위</td>
	            <td style="width: 19%; font-weight: 900; font-size:14px; text-align:left">
					<input type="text" class="form-control" id="txt_lotno"  style="width: 60%;" readonly/>
	           	</td>
	            <td style="width: 6.5%;  font-weight: 900; font-size:14px; text-align:left;vertical-align: middle">주문수량</td>
	            <td style="width: 18.5%; font-weight: 900; font-size:14px; text-align:left">
					<input type="text" class="form-control" id="txt_lot_count" style="width: 60%;";  readonly/>					
	           	</td>
	        </tr>
       	</table>      	
        <div id="bom_tbody">
        </div>
        <table class="table table-bordered " style="width: 100%; margin: 0 ; align:center" id="bom_table">
	        <tr style="vertical-align: middle">
	            <td style="width:  100%; font-weight: 900; font-size:14px; text-align:center; vertical-align: middle">
	            <button id="btn_Canc"  class="btn btn-info" style="width: 100px" onclick="parent.$('#modalReport2').hide();">닫기</button>
	            </td>	            
	        </tr>
	    </table>
	</div>