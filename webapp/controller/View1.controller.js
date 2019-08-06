sap.ui.define([
	"sap/ui/core/mvc/Controller",
	"sap/m/MessageToast",
	"sap/ui/model/json/JSONModel",
	"sap/ui/model/odata/v2/ODataModel",
	"sap/m/MessageBox"
], function (Controller, MessageToast, JSONModel, ODataModel,MessageBox) {
	"use strict";

	return Controller.extend("ovly.cadastro_alunos76.controller.View1", {
		onInit: function () {
		
			var oAluno = {
				dados :{
				nome: "Paulo",
				sobreNome: "Ruiz"
				},
				skills : [
					{ id:"1",description:"ABAP"},
					{ id:"2",description:"SAP Gateway"},
					{ id:"3",description:"JavaScript"},
					{ id:"4",description:"Android"},
					{ id:"5",description:"Xamarim"}
					]
			};
			
			var oModel = new JSONModel(oAluno);
			this.getView().setModel(oModel,"oModelJsonAluno");
			
		},
		inserirAluno:function(oEvent){
			var oDataModel = this.getView().getModel();
			var oAlunoModel = this.getView().getModel("oModelJsonAluno"); // JSONModel
			var sPath = "/Students";
			var oInput = this.byId("input_first_name");
			var sFirstName = oInput.getValue();
			var sLastName = oAlunoModel.getProperty("/dados/sobreNome");
			
			var oNovoAluno = {
				FirstName: sFirstName,
				LastName: sLastName
			};
			
			var mParameters = {
				success:function(oAluno){MessageToast.show("Aluno " +  oAluno.Id + " foi Criado");},
				error:function(oError){
					/*MessageBox.show(JSON.parse(oError.responseText).error.message.value, {
									icon: MessageBox.Icon.ERROR,
									title: "Erro inesperado."
									});*/
									
									MessageBox.error(JSON.parse(oError.responseText).error.message.value, {
									title: "Erro inesperado."
									});
				}
			};
			oDataModel.create(sPath,oNovoAluno,mParameters);
		},
		excluirAluno: function (oEvent) {
			// console.log("deletar aluno");
			var oDataModel = this.getView().getModel();
			var oAlunoItem = this.byId("lstAluno").getSelectedItem();
			
			if(!oAlunoItem){
				MessageToast.show("Selecione um aluno");
				return;
			}
			
			var oAlunoContext = oAlunoItem.getBindingContext();
			var sPath = oAlunoContext.getPath();

			var mParameters = {
				success: function () {
					var sMensagem = "Aluno deletado";
					//MessageToast.show(sMensagem);
					MessageBox.show(sMensagem, {
									icon: MessageBox.Icon.INFORMATION,
									title: "Exclusão de Aluno"
									});
				},
				error: function (oError) {
					var sMensagem = JSON.parse(oError.responseText).error.message.value;
					MessageBox.error(sMensagem);
				}
			};

			oDataModel.remove(sPath, mParameters); // assincrona

		},
		selecionaAluno:function(oEvt){
			var oParameters = oEvt.getParameters();
			var oListItem = oParameters.listItem; // sem ( )
			var oListItemContext = oListItem.getBindingContext();
			var oAluno = oListItemContext.getObject();
			
			/***********ESSA É UMA FORMA - PELO ID DO CONTROLE********************/
			//this.byId("input_first_name").setValue(oAluno.FirstName);
			//this.byId("input_last_name").setValue(oAluno.LastName);
			
			/***********ESSA É OUTRA FORMA - PELO NODELO, NO CASO O DATAMODEL********************/
			var oAlunoModel = this.getView().getModel("oModelJsonAluno"); // JSONModel
			oAlunoModel.setProperty("/dados/sobreNome", oAluno.LastName);
			oAlunoModel.setProperty("/dados/nome",oAluno.FirstName);
		
		}
	});
});