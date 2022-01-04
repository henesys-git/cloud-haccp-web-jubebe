<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="mes.client.comm.*" %>
<%@ page import="mes.client.common.*" %>
<%@ page import="mes.client.guiComponents.*" %>
<%@ page import="mes.client.util.*" %>
<%@ page import="mes.client.conf.*" %>
<%@ page import="org.json.simple.*"%>
<%@ include file="/strings.jsp" %>
<!DOCTYPE html>
<%
	DoyosaeTableModel TableModel;
	MakeTableHTML makeTableHTML;
	String loginID = session.getAttribute("login_id").toString();
	String member_key = session.getAttribute("member_key").toString();
	
	Vector optCode =  null;
	Vector optName =  null;
	Vector tIncongVector = CommonData.getDeptCode(member_key);
	
	int startPageNo = 1;//Integer.parseInt(request.getParameter("CurrentPageNumber").toString().trim());
	final int PageSize=15; 

	String[] strColumnHead 	= {"배합(BOM)번호","품목명", "최종순번", "형식번호","적용품목",
								"부서", "승인일", "승인","순번","원부자재코드",
								"원부자재명","중량(g)","000", "구분","QAR",
								"검사장비","포장자료","수정","000","비고",
								"cust_code","cust_rev","part_cd_rev", "bom_cd_rev", "재고"};
	int[] colOff 			= { 0, 0, 0, 0, 0, 
								0, 0, 0, 1, 1,
								1, 1, 0, 0, 0,
								0, 0, 0, 0, 1,
								0, 0, 0, 0, 0 };	//전체 넓이 번튼 3개:86%, 문서2개:90%, 문서뷰:94%, 챠트보기,문서등록91%;
	String[] TR_Style		= {""," onclick='S101S030180Event(this)' "};
	String[] TD_Style		= {"align:center;font-weight: bold;"}; 
	String[] HyperLink		= {""}; 
	String RightButton[][]	= {{"off", "fn_Chart_View", rightbtnChartShow},{"off", "fn_Doc_Reg()", rightbtnDocSave},{"off", "file_real_name", "주문문서"}};
	
	String GV_PROC_PLAN_NO = "", GV_MIX_RECIPE_CNT="";

	if (request.getParameter("proc_plan_no") == null)
		GV_PROC_PLAN_NO = "";
	else
		GV_PROC_PLAN_NO = request.getParameter("proc_plan_no");
	
	if (request.getParameter("mix_recipe_cnt") == null)
		GV_MIX_RECIPE_CNT = "";
	else
		GV_MIX_RECIPE_CNT = request.getParameter("mix_recipe_cnt");
	
	JSONObject jArray = new JSONObject();

	jArray.put( "proc_plan_no", GV_PROC_PLAN_NO);
	jArray.put( "member_key", member_key);
	
    TableModel = new DoyosaeTableModel("M101S030100E184", strColumnHead, jArray);	
 	int RowCount =TableModel.getRowCount();

 	CurrentPage jspPageName = new CurrentPage(request.getRequestURI());
 	String JSPpage = jspPageName.GetJSP_FileName();
 	
    makeTableHTML= new MakeTableHTML(TableModel);
    makeTableHTML.colCount		= strColumnHead.length;
    makeTableHTML.pageSize 		= RowCount;  //RowCount 1페이지로 구성,PageSize: PageSize의 사이즈로 구성 OrderTableModel
    makeTableHTML.currentPageNum= startPageNo;
    makeTableHTML.htmlTable_ID	= "TableS101S030180";
    makeTableHTML.colOff		= colOff;
    makeTableHTML.TR_Style 		= TR_Style;
    makeTableHTML.TD_Style 		= TD_Style; 
    makeTableHTML.HyperLink 	= HyperLink;makeTableHTML.user_id	= loginID;
    makeTableHTML.Check_Box 	= "false";
    makeTableHTML.RightButton	= RightButton; makeTableHTML.jsp_page	= JSPpage;
    String zhtml=makeTableHTML.getHTML();
	String sUrl = request.getRequestURL().toString();
	String incPage = sUrl.substring(0, sUrl.indexOf("Contents"));

%>  


<script type="text/javascript">
    $(document).ready(function () {
<%--     	alert("<%=GV_LOT_NO%>"); --%>
    	
    	$('#<%=makeTableHTML.htmlTable_ID%>').DataTable({	
    		scrollX: true,
    		scrollY: 380,
    	    scrollCollapse: true,
    	    paging: false,
//     	    lengthMenu: [[10], [10]], // 페이지당 줄수 10개 고정
    	    searching: false,
    	    ordering: true,
    	    order: [[ 8, "asc" ]], 
    	    info: true,         
            language: { 
                url:"<%=Config.this_SERVER_path%>/AdminLTE-3.0.5/localisation/Korean.json"
             }
    	    });
		<%if (RowCount>0){%>
			$('#txt_bomno').val('<%=TableModel.getValueAt(0,0).toString().trim()%>');
			$('#txt_bom_name').val('<%=TableModel.getValueAt(0,1).toString().trim()%>');
			$('#txt_lastseq').val('<%=TableModel.getValueAt(0,2).toString().trim()%>');
			$('#approval_date').val('<%=TableModel.getValueAt(0,6).toString().trim()%>');
			$('#txt_type_code').val('<%=TableModel.getValueAt(0,3).toString().trim()%>');
			$('#txt_A_productname').val('<%=TableModel.getValueAt(0,4).toString().trim()%>');
<%-- 			$('#txt_deptname').val('<%=TableModel.getValueAt(0,5).toString().trim()%>'); --%>
<%-- 			$('#txt_deptcode').val('<%=TableModel.getValueAt(0,5).toString().trim()%>').prop("selected",true); --%>
			$('#txt_deptcode').val('<%=TableModel.getValueAt(0,5).toString().trim()%>');
			$('#approval').val('<%=TableModel.getValueAt(0,7).toString().trim()%>');
		<%}%>
		
		$('#txt_mix_recipe_cnt').val('<%=GV_MIX_RECIPE_CNT%>');
    });
    
    function S101S030180Event(obj){
    	var tr = $(obj);
		var td = tr.children();
		var trNum = $(obj).closest('tr').prevAll().length;//현재 클릭한 TR의 순서 return

		$($("input[id='checkbox1']")[trNum]).prop("checked", function(){
	        return !$(this).prop('checked');
	    });


		$('#txt_CustName').val(td.eq(3).text().trim());
		
		$(<%=makeTableHTML.htmlTable_ID%>_rowID).attr("class", "");
		$(obj).attr("class", "hene-bg-color");
// 		$(obj).attr("class", "bg-danger");
// 		$(obj).attr("class", "bg-success"); 
		
        vOrderNo	= td.eq(6).text().trim();
		vCustCode 	= td.eq(7).text().trim(); 

//         fn_DetailInfo_List();Showing
        
    }
    

</script>
	<table class="table table-striped " style="width: 100%; margin: 0 ; align:left">	
		<tr>
			<td style="width: 10%;  font-weight: 900; font-size:14px; text-align:left;vertical-align: middle">목록번호</td>
      		<td style="width: 23.33%;  font-weight: 900; font-size:14px; text-align:lef;">
				<input type="text" 		class="form-control" id="txt_bomno" readonly/>
				
				<input type="hidden" 	class="form-control" id="txt_bom_no_rev"></input>
				<input type="hidden" 	class="form-control" id="txt_bom_cd"></input>
				<input type="hidden" 	class="form-control" id="txt_bom_cd_rev"></input>
				
				
				<input type="hidden" 	class="form-control" id="txt_lastseq"></input>
				<input type="hidden" 	class="form-control" id="approval_date"></input>
				<input type="hidden" 	class="form-control" id="txt_type_code"></input>
				<input type="hidden" 	class="form-control" id="txt_A_productname"></input>
				<input type="hidden" 	class="form-control" id="txt_deptcode"></input>
				<input type="hidden" 	class="form-control" id="approval"></input>
				
				<input type="hidden" 	class="form-control" id="txt_num_prefix" />
				<input type="hidden" 	class="form-control" id="txt_orderno" />
				<input type="hidden" 	class="form-control" id="txt_orderdetailseq" />
			</td>

      		<td style="width: 10%;  font-weight: 900; font-size:14px; text-align:left;vertical-align: middle">품목명</td>
      		<td style="width: 23.33%; font-weight: 900; font-size:14px; text-align:left">
				<input type="text" class="form-control" id="txt_bom_name" style="float:left;" readonly/>
     		</td>
     		<td style="width: 10%;  font-weight: 900; font-size:14px; text-align:left;vertical-align: middle">배합수</td>
      		<td style="width: 23.33%; font-weight: 900; font-size:14px; text-align:left">
				<input type="text" class="form-control" id="txt_mix_recipe_cnt" style="float:left;" readonly/>
     		</td>
		</tr>      
	</table>
<%=zhtml%>
<div id="UserList_pager" class="text-center">
	<button id="btn_Canc"  class="btn btn-info" style="width: 100px">닫기</button>
</div> 


				                 
