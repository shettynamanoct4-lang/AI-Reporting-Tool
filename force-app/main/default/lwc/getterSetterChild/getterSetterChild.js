import { LightningElement , api} from 'lwc';

export default class GetterSetterChild extends LightningElement {
    naam = 'default';
    @api 
    get names(){
        return this.naam;

    }
    set names(value){
        this.naam = value.toUpperCase();

    }

}