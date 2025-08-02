import { LightningElement, api, track } from 'lwc';

export default class ReRenderExampleComp extends LightningElement {
    @track childDummyKey = 0;


    // Use a setter on the parentval property to observe changes
    @api 
    set parentval(value) {
        this._parentval = value;
        console.log('Key child: ' + this._parentval);

        // Increment childDummyKey to trigger re-render
        this.childDummyKey = this.childDummyKey + 1;
        console.log('child dummy key : ' + this.childDummyKey);
    }
    get parentval() {
        return this._parentval;
    }

    // This lifecycle hook is called whenever any property changes
    // Including the parentval property
    renderedCallback() {
        console.log('Key child (renderedCallback): ' + this.parentval);
        console.log('child dummy key(renderedCallback) : ' + this.childDummyKey);
    }
}