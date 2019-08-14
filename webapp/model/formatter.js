sap.ui.define([], function () {
	"use strict";

	return {
		formataData: function (sValue) {
			if (!sValue) {
				return null;
			}
			
			return new Date(sValue);
		}
	};

});