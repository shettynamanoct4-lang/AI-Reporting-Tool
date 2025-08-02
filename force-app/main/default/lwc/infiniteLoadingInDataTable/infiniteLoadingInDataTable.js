import { LightningElement } from 'lwc';
import fetchAccounts from '@salesforce/apex/InfiniteLoadCls.fetchAccounts';  
 
const COLUMNS = [  
    { label: 'Name', fieldName: 'Name' }, 
    { label: 'Industry', fieldName: 'Industry' }, 
    { label: 'Account Number', fieldName: 'AccountNumber' }
];  

export default class InfiniteLoadingInDataTable extends LightningElement {
    accountRecords = []; 
    error; 
    columns = COLUMNS; 
    recordSize = 0;
    isLoadingBool = true;
    infiniteLoadingBool = true;

    connectedCallback() {

        console.log( 'Inside connected callback' );
        this.onLoadMore();

    }
 
    onLoadMore() { 
        
        console.log(
            'recordSize is ',
            this.recordSize
        );
 
        fetchAccounts( { intOffSet : this.recordSize } )   
        .then( result => { 

            console.log(
                'result is ',
                JSON.stringify( result )
            );

            if ( result.length > 0 ) {

                if ( this.recordSize > 0 ) {
                
                    this.accountRecords = [ ...this.accountRecords, ...result ];
                    console.log(
                        'No of Account Records is ',
                        this.accountRecords.length
                    );

                } else {

                    this.accountRecords = result;

                }

                console.log(
                    'accountRecords are ',
                    JSON.stringify( this.accountRecords )
                );

            } else {

                this.infiniteLoadingBool = false;
                
            }
            this.isLoadingBool = false;

        }) 
        .catch( error => { 

            console.log( 
                'error is ',
                JSON.stringify( error )
            );
            this.error = JSON.stringify( error ); 

        }); 
        this.recordSize = this.recordSize + 20;
 
    } 

    onRowSelection( event ) {

        const selectedRows = event.detail.selectedRows;
        console.log(
            'selectedRows are ',
            JSON.stringify( selectedRows )
        );

    }
 
}