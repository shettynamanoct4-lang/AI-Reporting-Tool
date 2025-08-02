import { LightningElement } from 'lwc';

export default class ParentYou2 extends LightningElement {
    handlerClick(){
        this.template.querySelector("c-child-you2").displayMagic();
    }
}