import { LightningElement, track } from 'lwc';

export default class YouifTrue extends LightningElement {
    @track defaultValue= 'Show';
    @track display=false;

    changeHandler(event){
        if(event.target.label=='Show'){
            this.defaultValue= 'Hide';
            this.display=true;
        }
        else if(event.target.label=='Hide'){
            this.defaultValue= 'Show';
            this.display=false;
        }
        
        
    }
}