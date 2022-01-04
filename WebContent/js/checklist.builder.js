/**
 * 
 */

function CheckListBuilder() {
	
	var divId;
	
	return {
		setDivId: function(divId) {
			this.divId = divId;
			return this;
		},
		
		setEntireRatio: function(arr) {
			this.entireRatio = arr;
			return this;
		},
		
		setHeadRowCnt: function(count) {
			this.headRowCnt = count;
			return this;
		},
		
		setHeadColCnt: function(count) {
			this.headColCnt = count;
			return this;
		},
		
		setHeadRowRatio: function(arr) {
			this.headRowRatio = arr;
			return this;
		},
		
		setHeadColRatio: function(arr) {
			this.headColRatio = arr;
			return this;
		},

		howManyBodies: function(count) {
			this.bodyCnt = count;
			return this;
		},
				
		setFooterRowCnt: function(count) {
			this.footerRowCnt = count;
			return this;
		},
		
		setFooterColCnt: function(count) {
			this.footerColCnt = count;
			return this;
		},
		
		setFooterRowRatio: function(arr) {
			this.footerRowRatio = arr;
			return this;
		},
		
		setFooterColRatio: function(arr) {
			this.footerColRatio = arr;
			return this;
		},
		
		/*	setChildBodiesRowCol
				bodyObj key/value 예시
				bodyX: {
					rowCnt: x,
					colCnt: x,
					rowRatio: [],
					colRatio: []
				}
		*/
		setChildBodiesRowCol: function(bodyObj) {
			this.childBodies = bodyObj;
			return this;
		},
		
		setStartX: function(startX) {
			this.startX = startX;
			return this;
		},
		
		setStartY: function(startY) {
			this.startY = startY;
			return this;
		},
		
		build: function() {
			return new CheckList(
				this.divId,
				this.bodyCnt,
				this.entireRatio,
				this.headRowCnt,
				this.headColCnt,
				this.headRowRatio,
				this.headColRatio,
				this.footerRowCnt,
				this.footerColCnt,
				this.footerRowRatio,
				this.footerColRatio,
				this.startX,
				this.startY,
				this.childBodies
			);
		}
	}
}

// ============================
// CheckListBuilder 상속 (작성 실패, 일단 놔둠)
// ============================

function CheckListWithImageBuilder() {
	
	//var divId;
	
	return {
		setDivId: function(divId) {
			this.divId = divId;
			return this;
		},
		
		setEntireRatio: function(arr) {
			this.entireRatio = arr;
			return this;
		},
		
		setHeadRowCnt: function(count) {
			this.headRowCnt = count;
			return this;
		},
		
		setHeadColCnt: function(count) {
			this.headColCnt = count;
			return this;
		},
		
		setHeadRowRatio: function(arr) {
			this.headRowRatio = arr;
			return this;
		},
		
		setHeadColRatio: function(arr) {
			this.headColRatio = arr;
			return this;
		},

		howManyBodies: function(count) {
			this.bodyCnt = count;
			return this;
		},
				
		setFooterRowCnt: function(count) {
			this.footerRowCnt = count;
			return this;
		},
		
		setFooterColCnt: function(count) {
			this.footerColCnt = count;
			return this;
		},
		
		setFooterRowRatio: function(arr) {
			this.footerRowRatio = arr;
			return this;
		},
		
		setFooterColRatio: function(arr) {
			this.footerColRatio = arr;
			return this;
		},
		
		/*	setChildBodiesRowCol
				bodyObj key/value 예시
				bodyX: {
					rowCnt: x,
					colCnt: x,
					rowRatio: [],
					colRatio: []
				}
		*/
		setChildBodiesRowCol: function(bodyObj) {
			this.childBodies = bodyObj;
			return this;
		},
		
		setStartX: function(startX) {
			this.startX = startX;
			return this;
		},
		
		setStartY: function(startY) {
			this.startY = startY;
			return this;
		},
		
		setTest: function(flag) {
			this.test = flag;
			return this;
		},
		
		build: function() {
			if(this.test === true) {
				return new CheckListWithImageTest(
					this.divId,
					this.bodyCnt,
					this.entireRatio,
					this.headRowCnt,
					this.headColCnt,
					this.headRowRatio,
					this.headColRatio,
					this.footerRowCnt,
					this.footerColCnt,
					this.footerRowRatio,
					this.footerColRatio,
					this.childBodies,
					this.startX,
					this.startY,
					this.image
				);				
			} else {
				return new CheckListWithImage(
					this.divId,
					this.bodyCnt,
					this.entireRatio,
					this.headRowCnt,
					this.headColCnt,
					this.headRowRatio,
					this.headColRatio,
					this.footerRowCnt,
					this.footerColCnt,
					this.footerRowRatio,
					this.footerColRatio,
					this.childBodies,
					this.startX,
					this.startY,
					this.image
				);
			}
		}
	}
}

// ============================
// CheckListBuilder 상속 (작성 실패, 일단 놔둠)
// ============================

function CheckListWithImageBuilderTobeDeleted() {
	var obj = new Object();
	console.log(obj);
	console.log(Object.getPrototypeOf(obj));
	
	obj = CheckListBuilder.call(this);
	
	var objProto = Object.getPrototypeOf(obj);
	objProto = Object.create(CheckListBuilder.prototype);
	objProto.constructor = obj;
	
	objProto.setImage = function(image) {
		this.image = image;
		return this;
	}
	
	objProto.build = function() {
		return new CheckListWithImage(
					this.divId,
					this.bodyCnt,
					this.entireRatio,
					this.headRowCnt,
					this.headColCnt,
					this.headRowRatio,
					this.headColRatio,
					this.footerRowCnt,
					this.footerColCnt,
					this.footerRowRatio,
					this.footerColRatio,
					this.childBodies,
					this.image
				);
	}
	console.log(objProto);
	return obj;
}
/*
CheckListWithImageBuilder.prototype = Object.create(CheckListBuilder.prototype);
CheckListWithImageBuilder.prototype.constructor	= CheckListWithImageBuilder;

CheckListWithImageBuilder.prototype.setImage = function(image) {
	this.image = image;
	return this;
}

// override
CheckListWithImageBuilder.prototype.build = function() {
	console.log('building!');
	return new CheckListWithImage(
				this.divId,
				this.bodyCnt,
				this.entireRatio,
				this.headRowCnt,
				this.headColCnt,
				this.headRowRatio,
				this.headColRatio,
				this.footerRowCnt,
				this.footerColCnt,
				this.footerRowRatio,
				this.footerColRatio,
				this.childBodies,
				this.image
			);
}*/