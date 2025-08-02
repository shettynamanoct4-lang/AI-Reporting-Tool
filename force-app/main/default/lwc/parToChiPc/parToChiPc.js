import { LightningElement , track} from 'lwc';
export default class ParToChiPc extends LightningElement {
    @track count=0;
    handleChange(event){
        this.count = event.target.value;
    }

}