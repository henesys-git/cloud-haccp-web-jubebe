/**
 * 
 */
 
function ChecklistSignature(datatable, pid, btn) {
	this.datatable = datatable;
 	this.pid = pid;
 	this.btn = btn;
}

ChecklistSignature.prototype.selectTimeAndSign = async function(callback) {
	
 	await Swal.fire({
		  title: '<strong>검증시간</strong>',
		  html: '<input type="time" class="form-control" id="selectTime"/>',
		  showCloseButton: true,
		  showCancelButton: true,
		  confirmButtonText: '확인',
		  cancelButtonText: '취소'
	}).then((result) => {
		if (result.value) {
			var time = $("#selectTime").val();
			var table = this.datatable;
			var btn = this.btn;
			var pid = this.pid;
			
			var data = table.row(btn.parents('tr')).data();
			data.push(time);
			confirmChecklist(data, pid, callback);
		}
	});
}