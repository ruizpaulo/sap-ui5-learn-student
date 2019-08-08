sap.ui.define([
	"sap/ui/core/mvc/Controller",
	"sap/m/MessageToast",
	"sap/ui/model/json/JSONModel",
	"sap/ui/model/odata/v2/ODataModel",
	"sap/m/MessageBox",
	"sap/m/BusyDialog"
], function (Controller, MessageToast, JSONModel, ODataModel,MessageBox,BusyDialog) {
	"use strict";

	return Controller.extend("ovly.cadastro_alunos76.controller.View1", {
		onInit: function () {
		
			var oAluno = {
				dados :{
				nome: "",
				sobreNome: "",
				nascimento:""
				},
				ToStudentSkills:[]
			};
			
			var oModel = new JSONModel(oAluno);
			this.getView().setModel(oModel,"oModelJsonAluno");
			
			
		},
	
		formatDate:function(date){
			var dateFormat = sap.ui.core.format.DateFormat.getDateInstance({pattern : "yyyy-MM-ddTHH:mm:ss" });
			var TZOffsetMs = new Date(0).getTimezoneOffset()*60*1000;
			// format date and time to strings offsetting to GMT
			var dateStr = dateFormat.format(new Date(date.getTime() + TZOffsetMs));
			return dateStr;
		},
		
		formatDateDisplay:function(date){
			var dateFormat = sap.ui.core.format.DateFormat.getDateInstance({pattern : "dd/MM/yyyy" });
			var TZOffsetMs = new Date(0).getTimezoneOffset()*60*1000;
			// format date and time to strings offsetting to GMT
			var dateStr = dateFormat.format(new Date(date.getTime() + TZOffsetMs));
			return dateStr;
		},
		
		inserirAluno:function(oEvent){
			/******************Código Deep Insert ****************/
			var oComboSkills = this.byId("cmbSkills");
			var a = new BusyDialog();
			a.open();
			a.setBusy(true);
			a.setText("Aguarde...");
			var oDataModel = this.getView().getModel();
			var oAlunoModel = this.getView().getModel("oModelJsonAluno"); // JSONModel
			var sPath = "/Students";
			var sFirstName = oAlunoModel.getProperty("/dados/nome");
			var sLastName = oAlunoModel.getProperty("/dados/sobreNome");
			var sBirthDate = this.formatDate(oAlunoModel.getProperty("/dados/nascimento"));
		
			var Students = {
				FirstName:sFirstName,
				LastName:sLastName,
				BirthDate:sBirthDate,
				ToStudentSkills:[]
				};
	
			var selectedItems = oComboSkills.getSelectedItems();
			
			for (var i = 0; i < selectedItems.length; i++) {
				var item = parseInt(selectedItems[i].getKey(),10);
				var skill = {
					    Student : "",
					    Skill : item
					};
				Students.ToStudentSkills.push(skill);
			}

			var mParameters =  {
			    success:function(oAluno){
			    	a.setBusy(false);
			    	a.close();
			    	MessageToast.show("Aluno " +  oAluno.Id + " foi Criado");
			    	
			    },
			    error:function(oError){
			    	a.setBusy(false);
			    	a.close();
					MessageBox.error(JSON.parse(oError.responseText).error.message.value, {
					title: "Erro inesperado."
					});
				},
			    async: true,  
			    urlParameters: {}  
			};
			
			oDataModel.create(sPath,Students,mParameters); 
			},
		
		alterarAluno:function(oEvent){
			
			var oAlunoItem = this.byId("lstAluno").getSelectedItem();
			
			if(!oAlunoItem){
				MessageToast.show("Selecione um aluno");
				return;
			}
			
			var oComboSkills = this.byId("cmbSkills");
			var a = new BusyDialog();
			a.open();
			a.setBusy(true);
			a.setText("Aguarde...");
			var oDataModel = this.getView().getModel();
			var oAlunoModel = this.getView().getModel("oModelJsonAluno"); // JSONModel
			var oAlunoContext = oAlunoItem.getBindingContext();
			var sPath = "/Students";
			var sFirstName = oAlunoModel.getProperty("/dados/nome");
			var sLastName = oAlunoModel.getProperty("/dados/sobreNome");
			var sBirthDate = this.formatDate(oAlunoModel.getProperty("/dados/nascimento"));
			var sId = oAlunoContext.getPath().split("'")[1];
			
			
			var Students = {
				Id: sId,
				FirstName:sFirstName,
				LastName:sLastName,
				BirthDate:sBirthDate,
				ToStudentSkills:[]
				};
	
			var selectedItems = oComboSkills.getSelectedItems();
			
			for (var i = 0; i < selectedItems.length; i++) {
				var item = parseInt(selectedItems[i].getKey(),10);
				var skill = {
					    Student : sId,
					    Skill : item
					};
				Students.ToStudentSkills.push(skill);
			}

			var mParameters =  {
			    success:function(oAluno){
			    	var sMessage = "Aluno " + sFirstName + " " + sLastName + " foi alterado.";
			    	a.setBusy(false);
			    	a.close();
			    	MessageToast.show(sMessage);
			    	
			    },
			    error:function(oError){
			    	a.setBusy(false);
			    	a.close();
					//MessageBox.error(JSON.parse(oError.responseText).error.message.value, {
					MessageBox.error(oError.responseText, {
					title: "Erro inesperado."
					});
				},
			    async: true, 
			    urlParameters: {}
			};
			oDataModel.create(sPath,Students,mParameters); 
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
			
			/***********ESSA É OUTRA FORMA - PELO NODELO, NO CASO O JSONMODEL********************/
			var oAlunoModel = this.getView().getModel("oModelJsonAluno"); // JSONModel
			oAlunoModel.setProperty("/dados/sobreNome", oAluno.LastName);
			oAlunoModel.setProperty("/dados/nome",oAluno.FirstName);
			oAlunoModel.setProperty("/dados/nascimento",oAluno.BirthDate);
			
			/**********MARCAR OS SKILLS DO ALUNO SELECIONADO NO COMBO DE SKILLS*****************/
			
			var oComboSkills = this.byId("cmbSkills");
			this.byId("lstAluno").setSelectedItem(oListItem,true);
			var a = new BusyDialog();
			a.open();
			a.setBusy(true);
			
			var sPath =oListItemContext.getPath() + "/ToStudentSkills";
			var mParameters = {
				success: function (oData) {
					var StutendSkills = new Array();
					oData["results"].forEach(function loop(element){
    				 StutendSkills.push(element.Skill.toString());
					});
					oComboSkills.setSelectedKeys(StutendSkills);
					a.setBusy(false);
					a.close();
				},
				error: function (oError) {
					a.setBusy(false);
					a.close();
					var sMensagem = JSON.parse(oError.responseText).error.message.value;
					MessageToast.show(sMensagem);
				}
			};
			var oDataModel = this.getView().getModel();
			oDataModel.read(sPath,mParameters);
		}
	});
});