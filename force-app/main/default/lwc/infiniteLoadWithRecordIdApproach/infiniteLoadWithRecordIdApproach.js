import { LightningElement } from 'lwc';
import loadDataById from '@salesforce/apex/infiniteWithRecId.loadDataById';
import loadMoreData from '@salesforce/apex/infiniteWithRecId.loadMoreData';
import countOfAccounts from '@salesforce/apex/infiniteWithRecId.countOfAccounts';

const COLUMNS = [  
    { label: 'Name', fieldName: 'Name' }, 
    { label: 'Industry', fieldName: 'Industry' }, 
    { label: 'Account Number', fieldName: 'AccountNumber' }
];


export default class InfiniteLoadWithRecordIdApproach extends LightningElement {
    accountRecords = []; 
    error; 
    columns = COLUMNS; 
    recordSize = 0;
    totalRecords = 0;
    recordLoaded = 0;


    connectedCallback() {

        console.log( 'Inside connected callback' );
        this.onLoad();

    }

    async onLoad(){
        try{
            this.totalRecords = await countOfAccounts();
            this.accountRecords = await loadDataById();
            this.recordLoaded = this.accountRecords.length;

        }
        catch(error){
            console.log('error while loading ', error);

        }
        

    }

    async onLoadMore(event){
        try{
            const{target} = event;
            target.isLoading = true;
            let currentRecords = this.accountRecords;
            let lastRecord = currentRecords[currentRecords.length - 1];
            let newRecords = await loadMoreData({
                lastName :lastRecord.Name,
                lastId : lastRecord.Id
            });
            this.accountRecords = [...currentRecords, ...newRecords];
            target.isLoading = false;
            this.recordLoaded = this.accountRecords.length;

        }
        catch(error){
            console.log('error while loading ', error);

        }
    }

}