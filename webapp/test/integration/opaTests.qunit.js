/* global QUnit */
QUnit.config.autostart = false;

sap.ui.getCore().attachInit(function () {
	"use strict";

	sap.ui.require([
		"pruiz/student_76/test/integration/AllJourneys"
	], function () {
		QUnit.start();
	});
});