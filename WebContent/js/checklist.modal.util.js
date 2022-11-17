/**
 * 
 */

function ChecklistModalUtil() {
	this.TO_BE_WIDTH = 900;
	
	this.setAdjustRatio = function (width) {
		return this.TO_BE_WIDTH / width;
	}
	
	this.adjustModalSize = function (obj, page) {
		var result = {};
		var width;
		var height;
		
		if(page == 1) {
			width = Number(obj.modalWidth.replace('px', ''));
			height = Number(obj.modalHeight.replace('px', ''));
		}
		else if(page == 2) {
			width = Number(obj.modalWidth2.replace('px', ''));
			height = Number(obj.modalHeight2.replace('px', ''));
		}
		else if(page == 3) {
			width = Number(obj.modalWidth3.replace('px', ''));
			height = Number(obj.modalHeight3.replace('px', ''));
		}
		else if(page == 4) {
			width = Number(obj.modalWidth4.replace('px', ''));
			height = Number(obj.modalHeight4.replace('px', ''));
		}
		else if(page == 5) {
			width = Number(obj.modalWidth5.replace('px', ''));
			height = Number(obj.modalHeight5.replace('px', ''));
		}
		
		var ratio = this.setAdjustRatio(width);
		
		result.width = width * ratio;
		result.height = height * ratio;
		
		return result;
	}
	
	this.setTagSize = function (obj, cell) {
		var result = {};
		
		var width = obj.modalWidth.replace('px', '');
		width = Number(width);
		
		var ratio = this.setAdjustRatio(width);
		
		result.startX = Number(cell.childNodes[5].firstChild.textContent.replace("px", "")) * ratio + "px";
		result.startY = Number(cell.childNodes[6].firstChild.textContent.replace("px", "")) * ratio + "px";
		result.width = Number(cell.childNodes[7].firstChild.textContent.replace("px", "")) * ratio + "px";
		result.height = Number(cell.childNodes[8].firstChild.textContent.replace("px", "")) * ratio + "px";
		
		//console.log(ratio);
		//console.log(result);
		
		return result;
	}
}