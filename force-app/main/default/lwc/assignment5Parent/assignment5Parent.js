import { LightningElement,track } from 'lwc';

export default class Assignment5Parent extends LightningElement {

    @track outputValue = '';
    @track outputValueOne = '';
    handleChangeOne(event) {
        this.outputValueOne = event.detail;
  }
    handleOutputValueChange(event) {
    this.outputValue = event.detail;
  }
}