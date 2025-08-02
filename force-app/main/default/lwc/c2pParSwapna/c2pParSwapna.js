import { LightningElement } from 'lwc';

export default class C2pParSwapna extends LightningElement {

    emName;
    emPhn;
    emCty;


    handleFire(event){
        this.emName = event.detail.empName;
        this.emPhn = event.detail.empPhone;
        this.emCty = event.detail.empCity;

    }
}