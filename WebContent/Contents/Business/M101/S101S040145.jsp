<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*,java.util.*,javax.servlet.http.*"%>
<%@ page import="mes.client.comm.*" %>
<%@ page import="mes.client.guiComponents.*" %>
<%@ page import="mes.client.util.*" %>
<%@ page import="mes.client.conf.*" %>
<%@ page import="org.json.simple.*"%><%@ include file="/strings.jsp" %>
<%
	DoyosaeTableModel TableModel;
	MakeTableHTML makeTableHTML; 
	String loginID = session.getAttribute("login_id").toString();
	String member_key = session.getAttribute("member_key").toString();
	String[] strColumnHead 	= {"No","제품명","제품코드","Lot No","출고수량","단위","단가","금액", // 0 ~ 7
			"chulha_no","order_no","order_detail_seq","cust_cd","cust_rev","일련번호","prod_rev","chuha_dt","chulha_user_id", // 8 ~ 16
			"delivery_date","project_name","project_cnt","cust_pono","cust_nm","LOT 수량","order_date","order_count","bigo","chulha_seq","product_serial_no_end","chulha_bigo" }; // 17 ~ 28
	int[]   colOff 			= { 1, 1, 0, 1, 1, 1, 1, 1,
								0, 0, 0, 0, 0, 1, 0, 0, 0,
								0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0 };
	String[] TR_Style		= {"",""};
// 	String[] TR_Style		= {""," onclick='S101S040145Event(this)' "};
	String[] TD_Style		= {"align:center;font-weight: bold;"}; 
	String[] HyperLink		= {""}; 
	String RightButton[][]	= {{"off", "fn_Chart_View", rightbtnChartShow},{"off", "fn_Doc_Reg()", rightbtnDocSave},{"on", "fn_mius_body(this)", "삭제"}};
	
	String GV_ORDER_NO="",GV_ORDER_DETAIL_SEQ="",GV_CHULHA_NO="",GV_MODE="",GV_LOTNO="",GV_PROD_CD="",GV_PROD_REV="";
	
	if(request.getParameter("order_no")== null)
		GV_ORDER_NO="";
	else
		GV_ORDER_NO = request.getParameter("order_no");	
		
	if(request.getParameter("order_detail_seq")== null)
		GV_ORDER_DETAIL_SEQ="";
	else
		GV_ORDER_DETAIL_SEQ = request.getParameter("order_detail_seq");	
	
	if(request.getParameter("chulha_no")== null)
		GV_CHULHA_NO="";
	else
		GV_CHULHA_NO = request.getParameter("chulha_no");	
	
	if(request.getParameter("mode")== null)
		GV_MODE="";
	else
		GV_MODE = request.getParameter("mode");	
	
// 	if(GV_MODE.equals("insert")){ //입력시 조회안되게
// 		GV_ORDER_NO="ㅋ";
// 		GV_ORDER_DETAIL_SEQ="0";
// 	} else
	if(GV_MODE.equals("update") || GV_MODE.equals("delete") || GV_MODE.equals("complete")){
		RightButton[2][0] = "off"; // 수정&삭제시 삭제버튼 off
	}

	if(request.getParameter("lotno")== null)
		GV_LOTNO="";
	else
		GV_LOTNO = request.getParameter("lotno");
	
	if(request.getParameter("prod_cd")== null)
		GV_PROD_CD="";
	else
		GV_PROD_CD = request.getParameter("prod_cd");
	
	if(request.getParameter("prod_rev")== null)
		GV_PROD_REV="";
	else
		GV_PROD_REV = request.getParameter("prod_rev");
	
	String param = GV_ORDER_NO + "|" + GV_ORDER_DETAIL_SEQ + "|" + GV_CHULHA_NO + "|" + GV_MODE + "|" + GV_LOTNO + "|";
	
	JSONObject jArray = new JSONObject();
	jArray.put( "order_no", GV_ORDER_NO);
	jArray.put( "lotno", GV_LOTNO);
	jArray.put( "prod_cd", GV_PROD_CD);
	jArray.put( "prod_rev", GV_PROD_REV);
//	System.out.println("1111111111111111111111111111111111111"+GV_PROD_REV);
	jArray.put( "order_detail_seq", GV_ORDER_DETAIL_SEQ);
	jArray.put( "chulhano", GV_CHULHA_NO);
	jArray.put( "mode", GV_MODE);
	jArray.put( "member_key", member_key);
	TableModel = new DoyosaeTableModel("M101S040100E145", strColumnHead, jArray);
		
 	int RowCount =TableModel.getRowCount();	

 	CurrentPage jspPageName = new CurrentPage(request.getRequestURI());
 	String JSPpage = jspPageName.GetJSP_FileName();
 	
    makeTableHTML= new MakeTableHTML(TableModel);
    makeTableHTML.colCount		= strColumnHead.length;
    makeTableHTML.pageSize 		= RowCount;  //RowCount 1페이지로 구성,PageSize: PageSize의 사이즈로 구성 
    makeTableHTML.currentPageNum= 1;
    makeTableHTML.htmlTable_ID	= "TableS101S040145";
    makeTableHTML.colOff		= colOff;
    makeTableHTML.TR_Style 		= TR_Style;
    makeTableHTML.TD_Style 		= TD_Style; 
    makeTableHTML.HyperLink 	= HyperLink;
    makeTableHTML.user_id		= loginID;
    makeTableHTML.Check_Box 	= "false";
    makeTableHTML.RightButton	= RightButton; 
    makeTableHTML.jsp_page	= JSPpage;
    String zhtml=makeTableHTML.getHTML();	
%>
<script>
    $(document).ready(function () {
    	var columnDefs;
    	if("<%=GV_MODE%>"=="insert") {
    		columnDefs = [
        		{
    	       		'targets': [2,8,9,10,11,12,14,15,16,
    	       					17,18,19,20,21,23,24,25,26,27,28], // 22 뺐음
    	       		'createdCell':  function (td) {
    	          			$(td).attr('style', 'width:0px; display: none;'); 
    	       		}
           		},
           		{
    	       		'targets': [29],
    	       		'createdCell':  function (td) {
              			$(td).attr('style', 'width:  7%; font-weight: 900; font-size:14px; text-align:center; vertical-align: middle');
    	          			$(td).html('<button style="width: auto; float: left; " type="button" onclick="fn_mius_body(this)" id="right_btn" class="btn-outline-success">삭제</button>'); 
    	       		}
    			}
           	];
    	} 
		vTableS101S040145 = $('#<%=makeTableHTML.htmlTable_ID%>').DataTable({
			scrollX: true,
		    scrollY: 200,
		    scrollCollapse: true,
		    paging: false,
		    searching: false,
		    ordering: true,
		    order: [[ 0, "asc" ]],
		    keys: false,
		    info: false,
	  		'columnDefs': columnDefs,         
            language: { 
                url:"<%=Config.this_SERVER_path%>/AdminLTE-3.0.5/localisation/Korean.json"
             }
		});
		
		TableS101S040145_RowCount = vTableS101S040145.rows().count();
		
		if("<%=GV_MODE%>"=="insert") { 
			for(i=0;i<TableS101S040145_RowCount;i++) {  // chulha_seq 최대값 구하기
 				//alert(vTableS101S040145.cell(i, 26).data());
				if(chulhaSeq_Max < vTableS101S040145.cell(i, 26).data())
					chulhaSeq_Max = vTableS101S040145.cell(i, 26).data();
			}
			
			for(var i=0; i<TableS101S040145_RowCount; i++){  // DB에서 조회된 레코드 삭제버튼제거
				var trInput = $($("#TableS101S040145_tbody tr")[i]).find(":button");
				//trInput.eq(0).prop("disabled", true);
				trInput.eq(0).remove();
	 		}
		}
		
		if("<%=GV_MODE%>"=="update" || "<%=GV_MODE%>"=="delete" || "<%=GV_MODE%>"=="complete"){
			if(TableS101S040145_RowCount==0) {
				alert("조회된 납품정보가 없습니다."+"\n"+"납품정보를 먼저 등록해주세요.");
				parent.$("#ReportNote").children().remove();
	     		parent.$('#modalReport').hide();
			}
			
			$('#txt_project_name').val(vTableS101S040145.cell(0, 18).data()); 
			$('#txt_cust_nm').val(vTableS101S040145.cell(0, 21).data());
// 			$('#txt_product_serial_no').val(vTableS101S040145.cell(0, 13).data());
			$('#txt_cust_pono').val(vTableS101S040145.cell(0, 20).data());
			$('#txt_project_cnt').val(vTableS101S040145.cell(0, 19).data());
			$('#txt_order_count').val(vTableS101S040145.cell(0, 24).data());
	 		$('#txt_order_no').val(vTableS101S040145.cell(0, 9).data());	 		
	 		$('#txt_order_bigo').val(vTableS101S040145.cell(0, 25).data());
	 		$('#txt_order_detail_seq').val(vTableS101S040145.cell(0, 10).data());
	 		$('#txt_chulha_bigo').val(vTableS101S040145.cell(0, 28).data());
		}
 		
		$('#<%=makeTableHTML.htmlTable_ID%> tbody').on( 'click', 'tr', function () { //행클릭시 이벤트
			S101S040145_Row_index = vTableS101S040145.row( this ).index();
 			$(<%=makeTableHTML.htmlTable_ID%>_rowID).removeClass("hene-bg-color");
			vTableS101S040145.row(this).nodes().to$().attr("class","hene-bg-color");
			
			$('#txt_product_nm').val(vTableS101S040145.cell(S101S040145_Row_index, 1).data());
			$('#txt_prod_cd').val(vTableS101S040145.cell(S101S040145_Row_index, 2).data());
			$('#txt_lotno').val(vTableS101S040145.cell(S101S040145_Row_index, 3).data());
			$('#txt_lot_count').val(vTableS101S040145.cell(S101S040145_Row_index, 22).data());
			$('#txt_chulha_cnt').val(vTableS101S040145.cell(S101S040145_Row_index, 4).data());
			$('#txt_chulha_unit').val(vTableS101S040145.cell(S101S040145_Row_index, 5).data());
			$('#txt_chulha_unit_price').val(vTableS101S040145.cell(S101S040145_Row_index, 6).data());
			$('#txt_chulha_amount').val(vTableS101S040145.cell(S101S040145_Row_index, 7).data());
							
			$('#txt_chulha_no').val(vTableS101S040145.cell(S101S040145_Row_index, 8).data());
			$('#txt_chulha_seq').val(vTableS101S040145.cell(S101S040145_Row_index, 26).data());
			$('#txt_prod_rev').val(vTableS101S040145.cell(S101S040145_Row_index, 14).data());
			$('#txt_cust_cd').val(vTableS101S040145.cell(S101S040145_Row_index, 11).data());
			$('#txt_cust_rev').val(vTableS101S040145.cell(S101S040145_Row_index, 12).data());
			$('#txt_chuha_dt').val(vTableS101S040145.cell(S101S040145_Row_index, 15).data());
			$('#txt_chulha_user_id').val(vTableS101S040145.cell(S101S040145_Row_index, 16).data());
			$('#txt_delivery_date').val(vTableS101S040145.cell(S101S040145_Row_index, 17).data());
			$('#txt_order_date').val(vTableS101S040145.cell(S101S040145_Row_index, 23).data());
			
			$('#txt_product_serial_no').val(vTableS101S040145.cell(S101S040145_Row_index, 13).data());
			$('#txt_product_serial_no_end').val(vTableS101S040145.cell(S101S040145_Row_index, 27).data());
			
			
			if("<%=GV_MODE%>"=="insert") { 
				$('#btn_plus').html("수정");
				S101S040140_Row_index = -1;
				vTableS101S040140.rows().nodes().to$().attr("class", "hene-bg-color_w");
			}
		} );	        

		$('#<%=makeTableHTML.htmlTable_ID%> tbody').on( 'blur', 'tr', function () {
			vTableS101S040145.row(this).nodes().to$().attr("class", "hene-bg-color_w");
		} );
		
    });

</script>

    <%=zhtml%>  