function initModel() {
	var sUrl = "/sap/opu/odata/sap/ZT32_76_STUDENT_SRV/";
	var oModel = new sap.ui.model.odata.ODataModel(sUrl, true);
	sap.ui.getCore().setModel(oModel);
}