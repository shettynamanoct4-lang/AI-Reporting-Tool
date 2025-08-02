import { LightningElement} from 'lwc';
export default class ChldToPrntComPr extends LightningElement {
    count=0;

    handlecheckin(){
        this.count--;
        console.log(this.count);
    }

    handlecheck(){
        this.count++;
        console.log(this.count);
    }
    

}