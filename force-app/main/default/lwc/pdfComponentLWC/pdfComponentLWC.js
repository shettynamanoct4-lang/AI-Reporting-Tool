import { LightningElement , wire} from 'lwc';
import { loadScript } from 'lightning/platformResourceLoader';
import downloadjs from '@salesforce/resourceUrl/downloadjs';
import downloadPDF from '@salesforce/apex/PrintJobPDFController.getPDFPrint';

export default class PdfComponentLWC extends LightningElement {
    boolShowSpinner = false;
    strFile;
    pdfString;

    renderedCallback(){
        loadScript(this,downloadjs)
        .then(() => console.log('Loaded Downloaded .js'))
        .catch(error => console.log(error));
    }

    generatePDF(){
        this.boolShowSpinner = true;
        downloadPDF({}).then(response => {
            console.log('response[0] ===>' + response[0]);
            this.strFile = "data:application/pdf;base64,"+response[0];
            window.open(response[1]);
        }).catch(error => {
            console.log('Error:' + error.body.message);
        });
    }
}