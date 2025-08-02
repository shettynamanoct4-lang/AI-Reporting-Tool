import { LightningElement, api } from 'lwc';

export default class ChildYou2 extends LightningElement {
    @api magic = "No";

    @api displayMagic(){
        this.magic = "Yes";
    }
}