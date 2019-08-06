/* global QUnit */
QUnit.config.autostart = false;

sap.ui.getCore().attachInit(function () {
	"use strict";

	sap.ui.require([
		"ovly/cadastro_alunos76/test/unit/AllTests"
	], function () {
		QUnit.start();
	});
});