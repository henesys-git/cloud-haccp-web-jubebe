/**
 * 
 */

/*var alertSave = Swal.fire({
	title: '저장 하시겠습니까?',
	showDenyButton: true,
	showCancelButton: true,
	confirmButtonText: `저장`,
	denyButtonText: `취소`,
}).then((result) => {
	if (result.isConfirmed) {
    	Swal.fire('저장 완료!', '', 'success')
  	} else if (result.isDenied) {
    	Swal.fire('저장 취소!', '', 'info')
  	}
})*/

function SweetAlert() {
	/*this.save = function(fn) {
		console.log('save start!');
		Swal.fire({
			title: '저장 하시겠습니까?',
			showDenyButton: true,
			showCancelButton: true,
			confirmButtonText: `저장`,
			denyButtonText: `취소`,
		}).then((result) => {
			if (result.isConfirmed) {
				var saved = 1;
				console.log(saved);
				if(saved == 1) {
					console.log("success");
		    		Swal.fire('저장 완료!', '', 'success')
				} else {
					console.log("fail");
					Swal.fire('저장 실패!', '', 'error')
				}
		  	} else if (result.isDenied) {
		    	Swal.fire('저장 취소!', '', 'info')
		  	}
		})
	};*/

	this.success = function(arg1, arg2) {
		
		if(arguments.length == 1) {
			title = '';
			message = arguments[0];
		} else if (arguments.length == 2) {
			title = arguments[0];
			message = arguments[1];
		}
		
		Swal.fire({
		  title: title,
		  html: message,
		  icon: 'success',
		  confirmButtonText: '닫기',
		  backdrop: false
		})
	}
	
	this.successTimer = function(arg1, arg2) {
		
		if(arguments.length == 1) {
			title = '';
			message = arguments[0];
		} else if (arguments.length == 2) {
			title = arguments[0];
			message = arguments[1];
		}
		
		Swal.fire({
		  title: title,
		  html: message,
		  icon: 'success',
		  showConfirmButton: false,
		  timer: 1000
		})
	}
	
	this.error = function(arg1, arg2) {
		
		if(arguments.length == 1) {
			title = '';
			message = arguments[0];
		} else if (arguments.length == 2) {
			title = arguments[0];
			message = arguments[1];
		}
	
		Swal.fire({
		  title: title,
		  html: message,
		  icon: 'error',
		  confirmButtonText: '닫기',
		  backdrop: false
		})
    };
	
	this.errorTimer = function(arg1, arg2) {
		
		if(arguments.length == 1) {
			title = '';
			message = arguments[0];
		} else if (arguments.length == 2) {
			title = arguments[0];
			message = arguments[1];
		}
	
		Swal.fire({
		  title: title,
		  html: message,
		  icon: 'error',
		  showConfirmButton: false,
		  timer: 1000
		})
    };
	
    this.warning = function(arg1, arg2) {
		var title = '';
		var message = '';
		
		if(arguments.length == 1) {
			title = '';
			message = arguments[0];
		} else if (arguments.length == 2) {
			title = arguments[0];
			message = arguments[1];
		}
	
		Swal.fire({
		  title: title,
		  html: message,
		  icon: 'warning',
		  confirmButtonText: '닫기',
		  backdrop: false
		})
    };

    this.warningTimer = function(arg1, arg2) {
		var title = '';
		var message = '';
		
		if(arguments.length == 1) {
			title = '';
			message = arguments[0];
		} else if (arguments.length == 2) {
			title = arguments[0];
			message = arguments[1];
		}
	
		Swal.fire({
		  title: title,
		  html: message,
		  icon: 'warning',
		  showConfirmButton: false,
		  timer: 1000
		})
    };

	this.info = function(arg1, arg2) {
		var title = '';
		var message = '';
		
		if(arguments.length == 1) {
			title = '';
			message = arguments[0];
		} else if (arguments.length == 2) {
			title = arguments[0];
			message = arguments[1];
		}
		
		Swal.fire({
		  title: title,
		  html: message,
		  icon: 'info',
		  confirmButtonText: '닫기',
		  backdrop: false
		})
    };

	this.infoTimer = function(arg1, arg2) {
		var title = '';
		var message = '';
		
		if(arguments.length == 1) {
			title = '';
			message = arguments[0];
		} else if (arguments.length == 2) {
			title = arguments[0];
			message = arguments[1];
		}
		
		Swal.fire({
		  title: title,
		  html: message,
		  icon: 'info',
		  showConfirmButton: false,
		  timer: 1000
		})
    };


	/*this.check = function(arg1, arg2) {
		if(arguments.length == 1) {
			title = '';
			message = arguments[0];
		} else if (arguments.length == 2) {
			title = arguments[0];
			message = arguments[1];
		}
		
		Swal.fire({
			title: title,
			text: message,
			icon: 'warning',
			showCancelButton: true,
			confirmButtonColor: '#3085d6',
			cancelButtonColor: '#d33',
			confirmButtonText: '확인'
		}).then((result) => {
			if (result.isConfirmed) {
				return true;
		  	} else {
				return false;
			}
		})
	}*/

	this.custom = function(configObject) {
		Swal.fire(configObject)
    };
};