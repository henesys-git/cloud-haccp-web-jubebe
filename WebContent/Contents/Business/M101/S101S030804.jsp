<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="mes.client.comm.*" %>
<%@ page import="mes.client.common.*" %>
<%@ page import="mes.client.guiComponents.*" %>
<%@ page import="mes.client.util.*" %>
<%@ page import="mes.client.conf.*" %>
<%@ page import="org.json.simple.*"%><%@ include file="/strings.jsp" %>
<%
	String loginID = session.getAttribute("login_id").toString();
	String member_key = session.getAttribute("member_key").toString();

	DoyosaeTableModel TableModel;
	String zhtml = "";
	Vector optCode =  null;
	Vector optName =  null;
	Vector sulbiGroupVector = CommonData.getSulbiGroupDataAll(member_key);

	String[] strColumnHead = {"", "", "", "", ""} ;
		
	String  GV_ORDER_NO="",GV_LOTNO="", GV_PRODUCT_GUBUN="", GV_PART_SOURCE="",GV_ROHS="";
	String  GV_FROMDATE="", GV_TODATE="";
	String  GV_PROD_CD="", GV_PROD_CD_REV="";
	
	if(request.getParameter("Fromdate")== null)
		GV_FROMDATE="";
	else
		GV_FROMDATE = request.getParameter("Fromdate");
		
	if(request.getParameter("Todate")== null)
		GV_TODATE="";
	else
		GV_TODATE = request.getParameter("Todate");
		
		
	if(request.getParameter("OrderNo")== null)
		GV_ORDER_NO="";
	else
		GV_ORDER_NO = request.getParameter("OrderNo");

	if(request.getParameter("lotno")== null)
		GV_LOTNO="";
	else
		GV_LOTNO = request.getParameter("lotno");
	
	if(request.getParameter("Product_Gubun")== null)
		GV_PRODUCT_GUBUN="";
	else
		GV_PRODUCT_GUBUN = request.getParameter("Product_Gubun");
	
	if(request.getParameter("Part_Source")== null)
		GV_PART_SOURCE="";
	else
		GV_PART_SOURCE = request.getParameter("Part_Source");
	
	if(request.getParameter("RoHS")== null)
		GV_ROHS="";
	else
		GV_ROHS = request.getParameter("RoHS");
	
	if(request.getParameter("prod_cd")== null)
		GV_PROD_CD="";
	else
		GV_PROD_CD = request.getParameter("prod_cd");
	
	if(request.getParameter("prod_cd_rev")== null)
		GV_PROD_CD_REV="";
	else
		GV_PROD_CD_REV = request.getParameter("prod_cd_rev");
	
	JSONObject jArray = new JSONObject();
	
	jArray.put("order_no", GV_ORDER_NO);
	jArray.put("lotno", GV_LOTNO);
	jArray.put("member_key", member_key);
	
	TableModel = new DoyosaeTableModel("M101S030100E805", jArray);
	int ColCount =TableModel.getColumnCount();
	CurrentPage jspPageName = new CurrentPage(request.getRequestURI());
	String JSPpage = jspPageName.GetJSP_FileName();
	
	// 데이터를 가져온다.
	Vector ModelVector = (Vector)(TableModel.getVector().get(0));
	
    // 개정번호를 만든다.
    String revisionNumberStr = "";
    int revisionNoInt = 0;
    try {
		revisionNoInt = Integer.parseInt( ModelVector.get(1).toString().trim() );
    } catch (Exception e) {
    	revisionNoInt = 0;
    }
    revisionNoInt = revisionNoInt + 1;
    revisionNumberStr = "" + revisionNoInt;
%>

<div style="width:100%; height:800px; overflow:auto">
	   	<table class="table table-bordered" style="width: 100%; margin: 0 auto; align:left">
		   	<tr>   
				<td style="width: 70%;">
		   			<table class="table table-bordered" style="width: 100%; margin: 0 auto; align:left">
				        <tr style="background-color: #fff;">
				            <td style="font-weight: 900; font-size:14px; text-align:left">고객사</td>
				            <td style="font-weight: 900; font-size:14px; text-align:left">
								<input type="text" class="form-control" id="txt_cust_name" style="width: 150px; float:left" 
				            		value="<%=ModelVector.get(0).toString()%>" readonly />
				           	</td>
				            <td style="font-weight: 900; font-size:14px; text-align:left">제품명</td>
				            <td style="font-weight: 900; font-size:14px; text-align:left" >
								<input type="text" class="form-control" id="txt_product_name" style="width: 150px; float:left" 
				            		value="<%=ModelVector.get(1).toString()%>" readonly />
				           	</td>
				           	<td style="font-weight: 900; font-size:14px; text-align:left">고객사PONO</td>
				            <td style="font-weight: 900; font-size:14px; text-align:left">
								<input type="text" class="form-control" id="txt_cust_pono" style="width: 150px; float:left" 
				            		value="<%=ModelVector.get(2).toString()%>" readonly />
				            </td>
				        </tr>
		
						<tr style="background-color: #fff;">
				            <td style=" font-weight: 900; font-size:14px; text-align:left">주문일자</td>
				            <td>
				            	<input type="text"  id="txt_order_date" class="form-control" style="width: 150px; border: solid 1px #cccccc; vertical-align: middle;"
				            		   value="<%=ModelVector.get(5).toString()%>" readonly />
				            </td>
				            <td style=" font-weight: 900; font-size:14px; text-align:left">LOT NO</td>
				            <td> 
				            	<input type="text"  id="txt_lotno" class="form-control" style="width: 150px; border: solid 1px #cccccc; vertical-align: middle;"
				            		   value="<%=ModelVector.get(6).toString()%>" readonly />
				            </td>
				            <td style=" font-weight: 900; font-size:14px; text-align:left">LOT 수량</td>
				            <td>
				            	<input type="text"  id="txt_lot_count" class="form-control" style="width: 150px; border: solid 1px #cccccc; vertical-align: middle;"
				            		   value="<%=ModelVector.get(7).toString()%>" readonly />
				            </td>		
				        </tr>
		
						<tr style="background-color: #fff;">
				            <td style="font-weight: 900; font-size:14px; text-align:left">주문번호</td>
				            <td> 
				            	<input type="text" data-date-format="yyyy-mm-dd" id="txt_OrderNo" class="form-control" style="width: 150px; border: solid 1px #cccccc;"  
				            		value="<%=ModelVector.get(13).toString()%>" readonly />
				            </td>
				            <td style="font-weight: 900; font-size:14px; text-align:left">납기일</td>
				            <td>
				            	<input type="text" data-date-format="yyyy-mm-dd" id="txt_delivery_date" class="form-control" style="width: 150px; border: solid 1px #cccccc;"
				            		value="<%=ModelVector.get(11).toString()%>" readonly />
				            </td>
				        </tr>
				        
				        <tr style="background-color: #fff">
				            <td style="font-weight: 900; font-size:14px; text-align:left" colspan="6">비고</td>
				        </tr>
				        <tr>
				            <td colspan="6">
				            	<textarea class="form-control" id="txt_Bigo" style="cols:10;rows:4;resize: none;" disabled="disabled">
				            		<%=ModelVector.get(15).toString()%>
				            	</textarea>
				            </td>		           
				        </tr>
		        	</table>
		        </td>
			</tr>
		    <tr style="background-color: #fff;" >
		        <td style="font-weight: 900; font-size:14px; text-align:left">
		        	<button id="btn_partlist_tbody" class="btn btn-info" style="width: 100%; text-align:left">
		        		주문제품 원부자재입출고현황
		        	</button>
		        </td>
		    </tr>
		    <tr style="height: 60px;" >
		        <td align="center" colspan="2">
		        <div id="partlist_tbody"></div>
		        </td>
		    </tr>
		    <tr style="background-color: #fff;">
		        <td style="font-weight: 900; font-size:14px; text-align:left">
		        	<button id="btn_production_exe_tbodyc" class="btn btn-info" style="width: 100%; text-align:left">
		        		주문제품 생산공정현황
		        	</button>
		        </td>
		    </tr>
		    <tr style="height: 60px;" >
		        <td align="center" colspan="2">
		        <div id="production_exe_tbody"></div>
		        </td>
		    </tr>
		    <tr style="background-color: #fff;" >
		        <td style="font-weight: 900; font-size:14px; text-align:left">
		        	<button id="btn_production_package_tbody" class="btn btn-info" style="width: 100%; text-align:left">
		        		주문제품 포장처리현황
		        	</button>
		        </td>
		    </tr>
		    <tr style="height: 60px;" >
		        <td align="center" colspan="2">
		        	<div id="production_package_tbody"></div>
		        </td>
		    </tr>
		    
		    <tr style="background-color: #fff;" >
		        <td style=" font-weight: 900; font-size:14px; text-align:left">
		        	<button id="btn_inspect_chulha_tbody" class="btn btn-info" style="width: 100%; text-align:left">
		        		주문제품 출하검사현황
		        	</button>
		        </td>
		    </tr>
		    <tr style="height: 60px;">
		        <td align="center" colspan="2">
		        <div id="inspect_chulha_tbody"></div>
		        </td>
		    </tr>
		        
		    <tr style="background-color: #fff;" >
		        <td style=" font-weight: 900; font-size:14px; text-align:left">
		        	<button id="btn_chulha_tbody" class="btn btn-info" style="width: 100%; text-align:left">
		        		주문제품 출하현황
		        	</button>
		        </td>
		    </tr>
		    <tr style="height: 60px;" >
		        <td align="center" colspan="2">
		        	<div id="chulha_tbody"></div>
		        </td>
		    </tr>
		    
		   	<tr style="background-color: #fff;">
		        <td style=" font-weight: 900; font-size:14px; text-align:left">
		        	<button id="btn_Suju_SubInfo_List_Doc" class="btn btn-info" style="width: 100%; text-align:left">
		        		주문 문서목록
		        	</button>
		        </td>
		    </tr>
		    <!-- <tr style="height: 60px;" >
		        <td align="center" colspan="2">
		        	<div id="Suju_SubInfo_List_Doc">
		        	</div>
		            <p>
		                <button id="btn_Canc" class="btn btn-info" style="width: 100px" onclick="parent.$('#modalReport').hide();">닫기</button>
		            </p>
		        </td>
		    </tr> -->
	  </table>
  </div> 
    
<script type="text/javascript">
    var detail_seq=1;
    var aExt=[];
    var vImageFileName="";
    var checkValue1 = '<%=GV_PRODUCT_GUBUN%>';
    var checkValue2 = '<%=GV_PART_SOURCE%>';
    var checkValue3 = '<%=GV_ROHS%>';
    
    $(document).ready(function () {
    	detail_seq=1;
    	
    	new SetSingleDate("", "txt_StartDate", 0);
    	
		//주문별 원부자재 입출고현황
		$.ajax({
            type: "POST",
			async: false,
            url: "<%=Config.this_SERVER_path%>/Contents/Business/M101/S101S030810.jsp", 
            data: "OrderNo=" + '<%=GV_ORDER_NO%>' + "&LotNo=" + '<%=GV_LOTNO%>' + 
            	  "&Todate=" + '<%=GV_TODATE%>' + "&Fromdate=" + '<%=GV_FROMDATE%>',
            beforeSend: function () {
                $("#partlist_tbody").children().remove();
            },
            success: function (html) {           	 
      			$("#partlist_tbody").hide().html(html).fadeIn(100);
            }
        });
        
		//생산공정현황
		$.ajax({
            type: "POST",
			async: false,
            url: "<%=Config.this_SERVER_path%>/Contents/Business/M101/S101S030830.jsp", 
            data: "OrderNo=" + '<%=GV_ORDER_NO%>' + "&LotNo=" + '<%=GV_LOTNO%>' + 
            	  "&Todate=" + '<%=GV_TODATE%>' + "&Fromdate=" + '<%=GV_FROMDATE%>' + 
            	  "&prod_cd=" + '<%=GV_PROD_CD%>' + "&prod_cd_rev=" + '<%=GV_PROD_CD_REV%>',
            beforeSend: function () {
                $("#production_exe_tbody").children().remove();
            },
            success: function (html) {           	 
      			$("#production_exe_tbody").hide().html(html).fadeIn(100);
            }
        });		

		//포장처리현황
		$.ajax({
            type: "POST",
			async: false,
            url: "<%=Config.this_SERVER_path%>/Contents/Business/M101/S101S030850.jsp", 
            data: "OrderNo=" + '<%=GV_ORDER_NO%>' + "&lotno=" + '<%=GV_LOTNO%>' + 
            	  "&prod_cd=" + '<%=GV_PROD_CD%>' + "&prod_cd_rev=" + '<%=GV_PROD_CD_REV%>',
            beforeSend: function () {
                $("#production_package_tbody").children().remove();
            },
            success: function (html) {           	 
      			$("#production_package_tbody").hide().html(html).fadeIn(100);
            }
        });
		
        //출하검사현황
		$.ajax({
            type: "POST",
			async: false,
            url: "<%=Config.this_SERVER_path%>/Contents/Business/M101/S101S030840.jsp", 
            data: "OrderNo=" + '<%=GV_ORDER_NO%>' + "&LotNo=" + '<%=GV_LOTNO%>' + 
                  "&Todate=" + '<%=GV_TODATE%>' + "&Fromdate=" + '<%=GV_FROMDATE%>',
            beforeSend: function () {
                $("#inspect_chulha_tbody").children().remove();
            },
            success: function (html) {           	 
      			$("#inspect_chulha_tbody").hide().html(html).fadeIn(100);
            }
        });

        //출하현황 sync
		$.ajax({
            type: "POST",
			async: false,
            url: "<%=Config.this_SERVER_path%>/Contents/Business/M101/S101S030860.jsp", 
            data: "OrderNo=" + '<%=GV_ORDER_NO%>' + "&LotNo=" + '<%=GV_LOTNO%>' + 
                  "&Todate=" + '<%=GV_TODATE%>' + "&Fromdate=" + '<%=GV_FROMDATE%>',
            beforeSend: function () {
                $("#chulha_tbody").children().remove();
            },
            success: function (html) {           	 
      			$("#chulha_tbody").hide().html(html).fadeIn(100);
            }
        });

		//문서목록
		$.ajax({
            type: "POST",
			async: false,
            url: "<%=Config.this_SERVER_path%>/Contents/Business/M101/S101S030820.jsp", 
            data: "OrderNo=" + '<%=GV_ORDER_NO%>' + "&LotNo=" + '<%=GV_LOTNO%>',
            beforeSend: function () {
            	$("#Suju_SubInfo_List_Doc").children().remove();
            },
            success: function (html) {           	 
            	$("#Suju_SubInfo_List_Doc").hide().html(html).fadeIn(100);
            }
        });
	    
    });
    
	// 라디오 버튼 값
    $("input[name=txt_part_source]").filter("input[value='"+checkValue2+"']").attr("checked",true);
	// 라디오 버튼 값
    $("input[name=txt_rohs]").filter("input[value='"+checkValue3+"']").attr("checked",true);

	function SendTojsp(bomdata, pid){
	    $.ajax({
	         type: "POST",
	         url: "<%=Config.this_SERVER_path%>/Contents/CommonView/insert_update_delete.jsp", 
	         data: "bomdata=" + bomdata + "&pid=" + pid,
	         success: function (html) {	 
	        	 if(html > -1){
	        	   	parent.fn_MainInfo_List();
	                parent.$("#ReportNote").children().remove();
	         		parent.$('#modalReport').hide();
	         	}
	         }
	     });		
	}  
	
    function fn_CommonPopupModal(sUrl, name, w, h) { // url, name, width, height, 기타 속성(생략해도 무방)     	
        var popupWin = window.showModalDialog(sUrl, name, 'dialogWidth:' + w + 'px; dialogHeight:' + h 
                + 'px; center:yes; help:no; status:no; resizable:no; scroll:yes; toolbar :no;');
    	if(typeof(popupWin) == "undefine")
    		popupWin = window.returnValue;
		return popupWin;
    }  
</script>
   	
   	
