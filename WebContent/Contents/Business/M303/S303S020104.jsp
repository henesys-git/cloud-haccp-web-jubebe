<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="mes.client.comm.*" %>
<%@ page import="mes.client.common.*" %>
<%@ page import="mes.client.guiComponents.*" %>
<%@ page import="mes.client.util.*" %>
<%@ page import="mes.client.conf.*" %>
<%@ page import="org.json.simple.*"%><%@ include file="/strings.jsp" %>

<!-- 현재고량 조회(S303S020104).jsp  -->

<%
	String loginID = session.getAttribute("login_id").toString();
	String member_key = session.getAttribute("member_key").toString();

	String  GV_JSPPAGE="", GV_NUM_GUBUN="", GV_DETAIL_SEQ="0";
	
	if(request.getParameter("jspPage")== null)
		GV_JSPPAGE="";
	else
		GV_JSPPAGE = request.getParameter("jspPage");		
	if(request.getParameter("num_gubun")== null)
		GV_NUM_GUBUN="";
	else
		GV_NUM_GUBUN = request.getParameter("num_gubun");
%>

<section class="content">
	<div class="container-fluid">
		<div class="row">
			<div class="col-md-6">
				<div class="card card-info">
                    <div class="card-header"> 
                     <h3 class="card-title">현재고량 조회</h3>
                    </div> <!-- card-header -->
                    <div class="card-body">
                    	<table class="table table-bordered" id="popupTable1">
                    		<thead>
                                <tr>
                                    <td>완제품명</td>
                                    <td>현재재고량</td>
                                    <td>적정재고량</td>
                                </tr>
                            </thead>
                            <tbody></tbody>
                    	
                    	</table>
                    </div> <!-- card-body  -->
				</div> <!-- card card-info -->
			</div> <!-- col-md-6 -->
		</div> <!-- row -->
	</div> <!-- container-fluid -->
</section> <!-- content -->

<script type="text/javascript">
var t1;
	
	$(document).ready(function () {
	
		t1 = $('#popupTable1').DataTable(henesysPopupTableOptions);
	
	});
</script>
