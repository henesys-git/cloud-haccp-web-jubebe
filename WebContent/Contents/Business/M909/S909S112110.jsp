<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="mes.client.comm.*" %>
<%@ page import="mes.client.guiComponents.*" %>
<%@ page import="mes.client.util.*" %>
<%@ page import="mes.client.conf.*" %>
<%
	String loginID = session.getAttribute("login_id").toString();
	String member_key = session.getAttribute("member_key").toString();
	String GV_MACHINENO="" , GV_PARTGUBUN_MID="";

	if(request.getParameter("machineno")== null)
		GV_MACHINENO="";
	else
		GV_MACHINENO = request.getParameter("machineno");
%>
<script type="text/javascript">
	var part_selected_row;
	var selectTable;
    $(document).ready(function () {
    	selectTable = $('#tableS909S112110').DataTable({
    		scrollX: true,
     		scrollY: 300,
    	    scrollCollapse: true,
    	    ordering: true,
    	    order: [[ 0, "asc" ],[ 1, "asc" ]],
		    keys: true,
    	    info: true,
    	    paging: true,
    	    pagingType: "full_numbers",
		    lengthMenu: [[8], ["8줄"]],
    	    searching: false,
   		    processing: true,
			serverSide: true,
			"dom": '<"top"i>rt<"bottom"flp><"clear">', //lengthmenu 위로 가는현상 방지.
			ajax: {
				 type: "POST",
				 url: '<%=Config.this_SERVER_path%>/Contents/JSON/M909/J909S112110.jsp',
				 data:{ 
					 machineno:"<%=GV_MACHINENO%>", 
					 partgubun_mid:"<%=GV_PARTGUBUN_MID%>"
				 }			
			},
			columns: [
                { "data": "창고번호" },
                { "data": "렉번호" },
                { "data": "선반번호" },
                { "data": "칸번호" },
                { "data": "사용여부" }
            ],
		    'createdRow': function(row) {
	      		$(row).attr('id',"tableS909S112110_rowID");
	      		$(row).attr('onclick',"S909S112110Event(this)");
	      		$(row).attr('role',"row");
	  		},       
            language: { 
                url:"<%=Config.this_SERVER_path%>/AdminLTE-3.0.5/localisation/Korean.json"
            }
  		});
    });
    
    function S909S112110Event(obj){
    	var tr = $(obj);
		var td = tr.children();
		var trNum = $(obj).closest('tr').prevAll().length;//현재 클릭한 TR의 순서 return

		$(tableS909S112110_rowID).attr("class", "");
		$(obj).attr("class", "hene-bg-color");

	 	machineno= td.eq(0).text().trim();
    }


</script>
              

<table class='table table-bordered' id="tableS909S112110" style="width: 100%">
	<thead>
		<tr>
		     <th>창고번호</th>
		     <th>렉번호</th>
		     <th>선반번호</th>
		     <th>칸번호</th>
		     <th>사용여부</th>
		</tr>
	</thead>
	<tbody id="tablePartView_body">		
	</tbody>
</table>