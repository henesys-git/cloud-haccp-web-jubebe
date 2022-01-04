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
/* 
주문제품 출하현황 상세 
*/
	String loginID = session.getAttribute("login_id").toString();
	String member_key = session.getAttribute("member_key").toString();
	String history_yn = session.getAttribute("history_yn").toString();
	DoyosaeTableModel TableModel;
	String zhtml = "";

	String hist_no="", custname="", prodnm="", orderno="", lotno="",
			lotcount,productserialno,productserialnoend,orderdate,
			deliverydate,chulha_date,chulha_no,chulha_seq,chulha_count
			,chulha_unit,chulha_price,tugesahang;
	
	if(request.getParameter("hist_no")== null)
		hist_no = "";
	else
		hist_no = request.getParameter("hist_no");	

	if(request.getParameter("custname")== null)
		custname="";
	else
		custname = request.getParameter("custname");
	
	if(request.getParameter("prodnm")== null)
		prodnm="";
	else
		prodnm = request.getParameter("prodnm");
	
	if(request.getParameter("orderno")== null)
		orderno="";
	else
		orderno = request.getParameter("orderno");	

	if(request.getParameter("lotno")== null)
		lotno="";
	else
		lotno = request.getParameter("lotno");

// 	,,,,
	if(request.getParameter("lotcount")== null)
		lotcount="";
	else
		lotcount = request.getParameter("lotcount");
	
	if(request.getParameter("productserialno")== null)
		productserialno="";
	else
		productserialno = request.getParameter("productserialno");
	
	if(request.getParameter("productserialnoend")== null)
		productserialnoend="";
	else
		productserialnoend = request.getParameter("productserialnoend");	

	if(request.getParameter("orderdate")== null)
		orderdate="";
	else
		orderdate = request.getParameter("orderdate");
// 	,,,,
	if(request.getParameter("deliverydate")== null)
		deliverydate="";
	else
		deliverydate = request.getParameter("deliverydate");

	if(request.getParameter("chulha_date")== null)
		chulha_date="";
	else
		chulha_date = request.getParameter("chulha_date");
	
	if(request.getParameter("chulha_no")== null)
		chulha_no="";
	else
		chulha_no = request.getParameter("chulha_no");
	
	if(request.getParameter("chulha_seq")== null)
		chulha_seq="";
	else
		chulha_seq = request.getParameter("chulha_seq");
	
	if(request.getParameter("chulha_count")== null)
		chulha_count="";
	else
		chulha_count = request.getParameter("chulha_count");
// 	,,
	if(request.getParameter("chulha_unit")== null)
		chulha_unit="";
	else
		chulha_unit = request.getParameter("chulha_unit");

	if(request.getParameter("chulha_price")== null)
		chulha_price="";
	else
		chulha_price = request.getParameter("chulha_price");
	
	if(request.getParameter("tugesahang")== null)
		tugesahang="";
	else
		tugesahang = request.getParameter("tugesahang");
%>
    
    <script type="text/javascript">
    
    $(document).ready(function () {    	
		<%if(history_yn.equals("Y")){ %>
			$('#hist_no').val('<%=hist_no%>');
		<%}%>
		$('#custname').val('<%=custname%>');
		$('#prodnm').val('<%=prodnm%>');
		$('#orderno').val('<%=orderno%>');
		$('#lotno').val('<%=lotno%>');
		$('#lotcount').val('<%=lotcount%>');
		$('#productserialno').val('<%=productserialno%>');
		$('#productserialnoend').val('<%=productserialnoend%>');
		$('#orderdate').val('<%=orderdate%>');
		$('#deliverydate').val('<%=deliverydate%>');
		$('#chulha_date').val('<%=chulha_date%>');
		$('#chulha_no').val('<%=chulha_no%>');
		$('#chulha_seq').val('<%=chulha_seq%>');
		$('#chulha_count').val('<%=chulha_count%>');
		$('#chulha_unit').val('<%=chulha_unit%>');
		$('#chulha_price').val('<%=chulha_price%>');
		$('#tugesahang').val('<%=tugesahang%>');
    });		
</script>

	<table class="table table-bordered" style="width: 100%; margin: 0 auto; align:center">
		<tr style="background-color: #fff; ">
            <td style="width: 15%; font-weight: 900; font-size:14px; vertical-align: middle ;text-align:left">고객사</td>
            <td style="width: 35%; font-weight: 900; font-size:14px; vertical-align: middle ;text-align:left">
            	<input type="text" class="form-control" maxlength="50" id="custname"  readonly></input>
            </td>
		<%if(history_yn.equals("Y")){ %>
            <td style="width: 15%; font-weight: 900; font-size:14px; vertical-align: middle ;text-align:left">이력번호</td>
            <td style="width: 35%; font-weight: 900; font-size:14px; vertical-align: middle ;text-align:left">
            	<input type="text" class="form-control" maxlength="50" id="hist_no"  readonly></input>
            </td>     
         <%} else{ %>
            <td style="width: 15%; font-weight: 900; font-size:14px; vertical-align: middle ;text-align:left"></td>
            <td style="width: 35%; font-weight: 900; font-size:14px; vertical-align: middle ;text-align:left">            	
            </td>     
         <%} %>
		</tr>
            
		<tr style="background-color: #fff; ">
            <td style="width: 15%; font-weight: 900; font-size:14px; vertical-align: middle ;text-align:left">제품명</td>
            <td style="width: 35%; font-weight: 900; font-size:14px; vertical-align: middle ;text-align:left">
            	<input type="text" class="form-control" maxlength="50" id="prodnm"  readonly></input>
            </td>
            <td style="width: 15%; font-weight: 900; font-size:14px; vertical-align: middle ;text-align:left">주문번호</td>
            <td style="width: 35%; font-weight: 900; font-size:14px; vertical-align: middle ;text-align:left">
            	<input type="text" class="form-control" maxlength="50" id="orderno"  readonly></input>
            </td>            
		</tr>
            
		<tr style="background-color: #fff; ">
            <td style="width: 15%; font-weight: 900; font-size:14px; vertical-align: middle ;text-align:left">LOT번호</td>
            <td style="width: 35%; font-weight: 900; font-size:14px; vertical-align: middle ;text-align:left">
            	<input type="text" class="form-control" maxlength="50" id="lotno"  readonly></input>
            </td>
            <td style="width: 15%; font-weight: 900; font-size:14px; vertical-align: middle ;text-align:left">LOT수량</td>
            <td style="width: 35%; font-weight: 900; font-size:14px; vertical-align: middle ;text-align:left">
            	<input type="text" class="form-control" maxlength="50" id="lotcount"  readonly></input>
            </td>
		</tr>
            
		<tr style="background-color: #fff; ">
            <td style="width: 15%; font-weight: 900; font-size:14px; vertical-align: middle ;text-align:left">시리얼번호(시)</td>
            <td style="width: 35%; font-weight: 900; font-size:14px; vertical-align: middle ;text-align:left">
            	<input type="text" class="form-control" maxlength="50" id="productserialno"  readonly></input>
            </td>
            <td style="width: 15%; font-weight: 900; font-size:14px; vertical-align: middle ;text-align:left">시리얼번호(종)</td>
            <td style="width: 35%; font-weight: 900; font-size:14px; vertical-align: middle ;text-align:left">
            	<input type="text" class="form-control" maxlength="50" id="productserialnoend"  readonly></input>
            </td>
		</tr>
            
		<tr style="background-color: #fff; ">
            <td style="width: 15%; font-weight: 900; font-size:14px; vertical-align: middle ;text-align:left">주문일자</td>
            <td style="width: 35%; font-weight: 900; font-size:14px; vertical-align: middle ;text-align:left">
            	<input type="text" class="form-control" maxlength="50" id="orderdate"  readonly></input>
            </td>
            <td style="width: 15%; font-weight: 900; font-size:14px; vertical-align: middle ;text-align:left">납품예정일자</td>
            <td style="width: 35%; font-weight: 900; font-size:14px; vertical-align: middle ;text-align:left">
            	<input type="text" class="form-control" maxlength="50" id="deliverydate"  readonly></input>
            </td>
		</tr>
            
		<tr style="background-color: #fff; ">
            <td style="width: 15%; font-weight: 900; font-size:14px; vertical-align: middle ;text-align:left">출하일자</td>
            <td style="width: 35%; font-weight: 900; font-size:14px; vertical-align: middle ;text-align:left">
            	<input type="text" class="form-control" maxlength="50" id="chulha_date"  readonly></input>
            </td>
            <td style="width: 15%; font-weight: 900; font-size:14px; vertical-align: middle ;text-align:left"></td>
            <td style="width: 35%; font-weight: 900; font-size:14px; vertical-align: middle ;text-align:left">
            	<input type="hidden" class="form-control" maxlength="50" id="chulha_no_____"  readonly></input>
            </td>
		</tr>
       
            
		<tr style="background-color: #fff; ">
            <td style="width: 15%; font-weight: 900; font-size:14px; vertical-align: middle ;text-align:left">출하번호</td>
            <td style="width: 35%; font-weight: 900; font-size:14px; vertical-align: middle ;text-align:left">
            	<input type="text" class="form-control" maxlength="50" id="chulha_no"  readonly></input>
            </td>
            <td style="width: 15%; font-weight: 900; font-size:14px; vertical-align: middle ;text-align:left">출하SEQ</td>
            <td style="width: 35%; font-weight: 900; font-size:14px; vertical-align: middle ;text-align:left">
            	<input type="text" class="form-control" maxlength="50" id="chulha_seq"  readonly></input>
            </td>
		</tr>
            
		<tr style="background-color: #fff; ">
            <td style="width: 15%; font-weight: 900; font-size:14px; vertical-align: middle ;text-align:left">출하수량</td>
            <td style="width: 35%; font-weight: 900; font-size:14px; vertical-align: middle ;text-align:left">
            	<input type="text" class="form-control" maxlength="50" id="chulha_count"  readonly></input>
            </td>
            <td style="width: 15%; font-weight: 900; font-size:14px; vertical-align: middle ;text-align:left">출하단위</td>
            <td style="width: 35%; font-weight: 900; font-size:14px; vertical-align: middle ;text-align:left">
            	<input type="text" class="form-control" maxlength="50" id="chulha_unit"  readonly></input>
            </td>
		</tr>
		<tr style="background-color: #fff; ">
            <td style="width: 15%; font-weight: 900; font-size:14px; vertical-align: middle ;text-align:left">특이사항</td>
            <td colspan="3" style="width: 85%; font-weight: 900; font-size:14px; vertical-align: middle ;text-align:left">
            	<input type="text" class="form-control" maxlength="50" id="tugesahang"  readonly></input>
            </td>
            
		</tr>
      	</table>
		<table style="width: 100%;">
			<tr>
				<td>
					<div>
						<div id="inspect_body" style="width:100%; float:left;"></div>
					</div>
				</td>
			</tr>
			<tr style="height: 60px;">
				<td style="text-align:center;">
					<p>
                		<button id="btn_Canc"  class="btn btn-info"  onclick="parent.$('#modalReport_nd').hide();">닫기</button>
            		</p>
				</td>
            </tr>
        </table>
		