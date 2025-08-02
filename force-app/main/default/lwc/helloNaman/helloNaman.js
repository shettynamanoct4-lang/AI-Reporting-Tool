import { LightningElement, track} from 'lwc';

export default class HelloNaman extends LightningElement {
    @track object={
        name:"sallu",
        place:"lola"
    }



    company="cognizant"
    changeHandler(event){
        this.object.name = event.target.value
    }

    get obName(){
        return this.object.name.toUpperCase()
    }




}