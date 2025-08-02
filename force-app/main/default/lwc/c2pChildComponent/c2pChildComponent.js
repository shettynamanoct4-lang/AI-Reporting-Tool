import { LightningElement } from 'lwc';

export default class C2pChildComponent extends LightningElement {
    closeHandler(){
        const myEvent = new CustomEvent('close', {
            detail: {
                msg:"My modal closed successfully" //detail can be either string,array,boolean,objects, etc
            }
        })
        this.dispatchEvent(myEvent)

    }
}