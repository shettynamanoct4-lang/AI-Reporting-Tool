import { LightningElement , wire, track} from 'lwc';
import { loadScript } from 'lightning/platformResourceLoader';
import downloadjs from '@salesforce/resourceUrl/downloadjs';
import downloadPDF from '@salesforce/apex/PrintJobPDFController.getPDFPrint';
import { getPicklistValues, getObjectInfo } from 'lightning/uiObjectInfoApi';
import ACCOUNT_OBJECT from '@salesforce/schema/Account' ;
import 	INDUSTRY_FIELD from '@salesforce/schema/Account.Industry';

export default class PdfComponentWithPicklist extends LightningElement {
    //PickList Component 
    @wire(getObjectInfo, { objectApiName: ACCOUNT_OBJECT })
    accountMetadata;
    @track value;
    @track options;
    @track obj;
    @wire(getPicklistValues, {recordTypeId: '$accountMetadata.data.defaultRecordTypeId', fieldApiName: INDUSTRY_FIELD})
    wiredFun({data,error}){
        if(data){
            this.options=data.values;
            console.log('PickList values', data.values);
        }
        if(error){
            console.log('error',error);
        }
    }

    changeHandler(event){
        this.value = event.target.value;
    }

    //PDF Component 
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
        downloadPDF({accIndustry  : this.value}).then(response => {
            //console.log('response[0] ===>' + response[0]);
            this.strFile = "data:application/pdf;base64,"+response[0];
            window.open(response[1]);
        }).catch(error => {
            console.log('Error:' + error.body.message);
        });
    }
}