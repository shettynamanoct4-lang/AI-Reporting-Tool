import { wire, LightningElement } from "lwc";
import getAccList from "@salesforce/apex/wrapperTable.getAccounts";
import changeRating from "@salesforce/apex/wrapperTable.changeRating";

export default class WrapperTable extends LightningElement {
  selectedAccounts = [];
  accList;
  @wire(getAccList)
  wiredRecord({ error, data }) {
    if (error) {
      let message = "Unknown error";
      if (Array.isArray(error.body)) {
        message = error.body.map((e) => e.message).join(", ");
      } else if (typeof error.body.message === "string") {
        message = error.body.message;
      }
    } else if (data) {
      this.accList = JSON.parse(data);
    }
  }
  handleAllChange(event) {
    for (var i = 0; i < this.accList.length; i++) {
      this.accList[i].isSelected = event.target.checked;
    }
  }
  handleCheckChange(event) {
    this.accList[event.target.value].isSelected = event.target.checked;
  }
  getSelectedAccounts(event) {
    for (var i = 0; i < this.accList.length; i++) {
      if (this.accList[i].isSelected) {
        this.selectedAccounts.push(this.accList[i]);
      }
    }
    changeRating({ 
      accRecords : JSON.stringify(this.selectedAccounts) 
    })
    .then(result => {
      console.log('Result \n ', result);
      window.location.reload();
    })
    .catch(error => {
      console.error('Error: \n ', error);
    });

    console.log("###Selected Accounts" + this.selectedAccounts.length);
    console.log("###Stringify : " + JSON.stringify(this.selectedAccounts));
  }
}