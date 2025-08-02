import { LightningElement } from 'lwc';
import qrcode from './qrcode.js';

export default class QrCodeGeneration extends LightningElement {
    renderedCallback() {
        const qrCodeGenerated = new qrcode(0, 'H');
        let strForGenearationOfQRCode  = 'This is my data.I am Shivani'
        // Construct the URL of the record page (replace 'recordId' with actual record ID)
        const recordUrl = window.location.origin + '/lightning/r/Account/0015g00001cpas9AAA/view';
        qrCodeGenerated.addData(recordUrl);
        qrCodeGenerated.make();
        let element = this.template.querySelector(".qrcode2");
        element.innerHTML = qrCodeGenerated.createSvgTag({});
   }
}