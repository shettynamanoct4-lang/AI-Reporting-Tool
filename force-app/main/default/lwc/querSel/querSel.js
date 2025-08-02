import { LightningElement } from 'lwc';

export default class QuerSel extends LightningElement {
    cars= ["wagnor", "alto", "zen", "nano"]
    fetchDetailHandler(){
        const shown= this.template.querySelector('h1')
        const veh = this.template.querySelectorAll('.name')
        console.log(shown.innerText)
        Array.from(veh).forEach(element => {
            console.log(element.innerText)
        });

    }
}