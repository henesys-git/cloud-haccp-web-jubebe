<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="mes.client.comm.*" %>
<%@ page import="mes.client.common.*" %>
<%@ page import="mes.client.guiComponents.*" %>
<%@ page import="mes.client.util.*" %>
<%@ page import="mes.client.conf.*" %>
<%@ page import="org.json.simple.*"%><%@ include file="/strings.jsp" %>

<!-- 
	numpad_modal 
-->
<%
	String numStrID = "", numStrVal = "";

	if(request.getParameter("numStrID") != null)
		numStrID = request.getParameter("numStrID");	

	if(request.getParameter("numStrVal") != null)
		numStrVal = request.getParameter("numStrVal");
%>
<style>

#modalReport2 {

	position : absolute;
	left : -35%;
	font-family: sans-serif;
	font-weight: 600;
	text-align: center;
}

.numView {

	height : 45px;
	vertical-align: middle;
	font-size: 28px;
	margin : 7% 0;
}

.num_button {

	display : inline-block;
	height : 46px;
	width: 33.3%;
	cursor : pointer;
}

.num_button span {
	position: relative;
    top: 9px;
}

.num_button span i {
	font-size: 18px;
}

.num_button:hover {
	/* background-color: #f2f2f2; */
		background-color:#e6e6e6;
}

</style>

<script type="text/javascript">

    $(document).ready(function () {
    	
		var numStrVal = '<%= numStrVal %>';
		
		$(".numView").text(Number(numStrVal).toLocaleString('en'));
		
		$(".num").click(function() {
			
			var text = $(".numView").text();
			
			if(text.length == 5) return false;
			
			numStrVal += $(this).text();
			
			numStrVal = Number(numStrVal).toLocaleString('en');

			$(".numView").text(numStrVal);
			
		});
		
		$(".put_num").click(function() {
			
			var id = '<%=numStrID%>'; 
				
			$("#"+ id).val(numStrVal.replace(/[^\d]+/g, ""));
			
			$('#modalReport2').modal("hide");
			
		});
		
		$(".cancel_num").click(function() {
			
			numStrVal = numStrVal.substr(0,numStrVal.length - 1);
			
			numStrVal = numStrVal.replace(/[^\d]+/g, "");
			
			$(".numView").text(numStrVal);
			
		});
		
    });	
	
</script>

<!-- Modal body -->
<div class = "numView"></div>
<div>
 <div class = "num num_button"><span>1</span></div><div class = "num num_button"><span>2</span></div><div class = "num num_button"><span>3</span></div>
 <div class = "num num_button"><span>4</span></div><div class = "num num_button"><span>5</span></div><div class = "num num_button"><span>6</span></div>
 <div class = "num num_button"><span>7</span></div><div class = "num num_button"><span>8</span></div><div class = "num num_button"><span>9</span></div>
 <div class = "cancel_num num_button"><span><i class="fas fa-minus" style = "color : #b30000;"></i></span></div><div class = "num num_button"><span>0</span></div><div class = "put_num num_button"><span><i class="fas fa-check" style = "color : green;"></i></span></div>
</div>
