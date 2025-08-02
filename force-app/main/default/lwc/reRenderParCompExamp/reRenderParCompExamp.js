import { LightningElement, track } from 'lwc';

export default class ReRenderParCompExamp extends LightningElement {
    @track rerenderKey = 0;

    handleRerender() {
        this.rerenderKey += 1;
        console.log('Key Parent: '+this.rerenderKey);
    }
}