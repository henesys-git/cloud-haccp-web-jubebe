/*
* DataTables 라이브러리 기본 셋팅
* 페이지별 사용 방법:
	// 해당 페이지의 커스텀 옵션을 설정해준다
	var customOpts = {
		data : [["돼지고기a", "50kg"], ["돼지고기b", "30kg"]],
		pageLength : 15
	}
	
	$('#exampleTable').DataTable(
		// 서브테이블인 경우 heneSubTableOpts로 변경
		// 메인테이블의 기본 옵션과 커스텀 옵션을 합한
		// 옵션을 #exampleTable에 파라미터로 주며
		// DataTable을 initialize 시킨다
		mergeOptions(heneMainTableOpts, customOpts)
	);
*/

// MainTable 기본 세팅값
let heneMainTableOpts = {
    "lengthMenu": [5, 10, 25, 50],
    "lengthChange": true,
    "paging": true,
    "pageLength": 5,
	"select": true,
    "scrollCollapse": true,
    "searching": false,
	"scrollX": true,
	"scrollY": true,
    "ordering": true,
    "info": false,
    "dom": "<'row'<'col-sm-12 col-md-6'i><'col-sm-12 col-md-6'f>>" +
    	   "<'row'<'col-sm-12'tr>>" +
           "<'row'<'col-sm-12 col-md-5'l><'col-sm-12 col-md-7'p>>",
    "language": {
        "decimal":        ".",
        "thousands":        ",",
        "emptyTable":     "데이터가 없습니다",
        "info":           "총 _TOTAL_ 중  _START_ ~  _END_",
        "infoEmpty":      "데이터가 0 건있습니다",
        "infoFiltered":   "(총 _MAX_ 건수 중에 검색)",
        "infoPostFix":    "",
        "thousands":      ",",
        "lengthMenu":     "페이지당 줄수 _MENU_",
        "loadingRecords": "읽는 중...",
        "processing":     "처리 중...",
        "search":         "검색:",
        "zeroRecords":    "데이터가 없습니다",
        "paginate": {
            "previous": "이전",
            "next":     "다음",
            "first":    "처음으로",
            "last":     "마지막으로"
        },
        "aria": {
            "sortAscending":  ": 오름차순 정렬",
            "sortDescending": ": 내림차순 정렬"
        }
    },
	"retrieve": true,
	"stateSave": true
}



// SubTable 기본 세팅값
let heneSubTableOpts = {
	"select": true,
    "pageLength": 5,
    "lengthMenu": [5, 10, 25, 50],
    "scrollCollapse": true,
    "paging": false,
    "searching": false,
	"scrollX" : true,
	"scrollY" : true,
    "ordering": true,
    "info": false,
    "lengthChange": false,
    "dom": "<'row'<'col-sm-12 col-md-6'i><'col-sm-12 col-md-6'f>>" +
    	   "<'row'<'col-sm-12'tr>>" +
           "<'row'<'col-sm-12 col-md-5'l><'col-sm-12 col-md-7'p>>",
    "language": {
		"decimal":        ".",
        "thousands":      ",",
        "emptyTable":     "데이터가 없습니다",
        "info":           "총 _TOTAL_ 중  _START_ ~  _END_",
        "infoEmpty":      "데이터가 0 건있습니다",
        "infoFiltered":   "(총 _MAX_ 건수 중에 검색)",
        "infoPostFix":    "",
        "thousands":      ",",
        "lengthMenu":     "페이지당 줄수 _MENU_",
        "loadingRecords": "읽는 중...",
        "processing":     "처리 중...",
        "search":         "검색:",
        "zeroRecords":    "데이터가 없습니다",
        "paginate": {
            "previous": "이전",
            "next":     "다음",
            "first":    "처음으로",
            "last":     "마지막으로"
        },
        "aria": {
            "sortAscending":  ": 오름차순 정렬",
            "sortDescending": ": 내림차순 정렬"
        }
    },
    "createdRow": function(row) {
  		$(row).attr('id', "SubMenu_rowID");
  		$(row).attr('onclick', "clickSubMenu(this)");
  		$(row).attr('role', "row");
	},
	"retrieve": true
}

// PopupTable 기본 세팅값
let henePopupTableOpts = {
	"select": true,
    "pageLength": 5,
    "lengthMenu": [5, 10, 25, 50],
    "paging": false,
    "scrollCollapse": true,
    "searching": false,
	"scrollX" : true,
	"scrollY" : true,
    "ordering": false,
    "info": false,
    "lengthChange": false,
    "dom": "<'row'<'col-sm-12 col-md-6'i><'col-sm-12 col-md-6'f>>" +
    	   "<'row'<'col-sm-12'tr>>" +
           "<'row'<'col-sm-12 col-md-5'l><'col-sm-12 col-md-7'p>>",
    "language": {
        "decimal":        ".",
        "thousands":      ",",
        "emptyTable":     "데이터가 없습니다",
        "info":           "총 _TOTAL_ 중  _START_ ~  _END_",
        "infoEmpty":      "데이터가 0 건있습니다",
        "infoFiltered":   "(총 _MAX_ 건수 중에 검색)",
        "infoPostFix":    "",
        "thousands":      ",",
        "lengthMenu":     "페이지당 줄수 _MENU_",
        "loadingRecords": "읽는 중...",
        "processing":     "처리 중...",
        "search":         "검색:",
        "zeroRecords":    "데이터가 없습니다",
        "paginate": {
            "previous": "이전",
            "next":     "다음",
            "first":    "처음으로",
            "last":     "마지막으로"
        },
        "aria": {
            "sortAscending":  ": 오름차순 정렬",
            "sortDescending": ": 내림차순 정렬"
        }
    },
    "createdRow": function(row) {
  		$(row).attr('id', "PopupMenu_rowID");
  		$(row).attr('onclick', "clickPopupMenu(this)");
  		$(row).attr('role', "row");
	},
	"retrieve": true
}

// PopupTable 기본 세팅값
let henePopup2TableOpts = {
	"select": true,
    "pageLength": 5,
    "lengthMenu": [5, 10, 25, 50],
    "paging": false,
    "scrollCollapse": true,
    "searching": false,
	"scrollX" : true,
	"scrollY" : true,
    "ordering": false,
    "info": false,
    "lengthChange": false,
    "dom": "<'row'<'col-sm-12 col-md-6'i><'col-sm-12 col-md-6'f>>" +
    	   "<'row'<'col-sm-12'tr>>" +
           "<'row'<'col-sm-12 col-md-5'l><'col-sm-12 col-md-7'p>>",
    "language": {
        "decimal":        ".",
        "thousands":      ",",
		"info":           "총 _TOTAL_ 중  _START_ ~  _END_",
        "infoEmpty":      "데이터가 0 건있습니다",
        "infoFiltered":   "(총 _MAX_ 건수 중에 검색)",
        "infoPostFix":    "",
        "thousands":      ",",
        "lengthMenu":     "페이지당 줄수 _MENU_",
        "loadingRecords": "읽는 중...",
        "processing":     "처리 중...",
        "search":         "검색:",
        "zeroRecords":    "데이터가 없습니다",
        "paginate": {
            "previous": "이전",
            "next":     "다음",
            "first":    "처음으로",
            "last":     "마지막으로"
        },
        "aria": {
            "sortAscending":  ": 오름차순 정렬",
            "sortDescending": ": 내림차순 정렬"
        }
    },
    "createdRow": function(row) {
  		$(row).attr('id', "Popup2Menu_rowID");
  		$(row).attr('onclick', "clickPopup2Menu(this)");
  		$(row).attr('role', "row");
	},
	"retrieve": true
}

// 3rd Popup Table 기본 세팅값
let henePopup3TableOpts = {
	"select": true,
    "pageLength": 5,
    "lengthMenu": [5, 10, 25, 50],
    "paging": false,
    "scrollCollapse": true,
    "searching": false,
	"scrollX" : true,
	"scrollY" : true,
    "ordering": false,
    "info": false,
    "lengthChange": false,
    "dom": "<'row'<'col-sm-12 col-md-6'i><'col-sm-12 col-md-6'f>>" +
    	   "<'row'<'col-sm-12'tr>>" +
           "<'row'<'col-sm-12 col-md-5'l><'col-sm-12 col-md-7'p>>",
    "language": {
        "decimal":        ".",
        "thousands":      ",",
		"info":           "총 _TOTAL_ 중  _START_ ~  _END_",
        "infoEmpty":      "데이터가 0 건있습니다",
        "infoFiltered":   "(총 _MAX_ 건수 중에 검색)",
        "infoPostFix":    "",
        "thousands":      ",",
        "lengthMenu":     "페이지당 줄수 _MENU_",
        "loadingRecords": "읽는 중...",
        "processing":     "처리 중...",
        "search":         "검색:",
        "zeroRecords":    "데이터가 없습니다",
        "paginate": {
            "previous": "이전",
            "next":     "다음",
            "first":    "처음으로",
            "last":     "마지막으로"
        },
        "aria": {
            "sortAscending":  ": 오름차순 정렬",
            "sortDescending": ": 내림차순 정렬"
        }
    },
    "createdRow": function(row) {
  		$(row).attr('id', "Popup3Menu_rowID");
  		$(row).attr('onclick', "clickPopup3Menu(this)");
  		$(row).attr('role', "row");
	},
	"retrieve": true
}

function mergeOptions(obj1, obj2) {
	var newObj = new Object();
	
	return Object.assign(newObj, obj1, obj2);
}