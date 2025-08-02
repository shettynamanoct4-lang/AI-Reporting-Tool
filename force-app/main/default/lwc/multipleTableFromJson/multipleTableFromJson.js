import { LightningElement, wire } from 'lwc';
import getFieldSetData from '@salesforce/apex/AccountFieldSetController.getFieldSetData';

export default class MultipleTableFromJson extends LightningElement {
    columns = [];
    tableDataSets = []; // Array to hold separate datasets with unique keys

    @wire(getFieldSetData)
    wiredFieldSet({ error, data }) {
        if (data) {
            // Map field set labels to datatable columns
            this.columns = data.fields.map(field => {
                return { label: field.label, fieldName: field.apiName, type: 'text' };
            });

            // Prepare table data from the JSON response
            const fullData = data.data.map((item, index) => {
                return {
                    key: `table-${index}`,  // Unique key for each dataset
                    data: [{
                        Name: item['Full Name'],
                        Phone: item['Phone Number'],
                        Contact_Salary__c: item['Contact Salary'] || 'N/A',
                        SalesRep__c: item['SalesRep'],
                        contactCount__c: item['contactCount']
                    }]
                };
            });
            console.log('Data from Apex : '+ JSON.stringify(fullData));
            this.tableDataSets = fullData;
        } else if (error) {
            console.error('Error retrieving field set data: ', error);
        }
    }
}