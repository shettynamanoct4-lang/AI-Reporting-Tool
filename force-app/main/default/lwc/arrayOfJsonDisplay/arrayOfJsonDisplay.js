import { LightningElement, track } from 'lwc';

export default class ArrayOfJsonDisplay extends LightningElement {
    Student = [{'Name': 'Naman', 'Age': 23, 'City': 'Kundapur'}, 
               {'Name': 'Abhi', 'Age': 93, 'City': 'Kundur'},
               {'Name': 'Jeeve', 'Age': 53, 'City': 'Kpur'}];

  
    //display = JSON.parse(JSON.stringify(Str));
    @track show = [];
    
    clk(event){
        const Str = "[{'Name':'Naman', Age: 23, City': 'Kundapur'}, {'Name':'Spaman', Age: 33, City': 'Kudr'}]";
        const display = JSON.parse(JSON.stringify(Str));
        console.log(JSON.stringify(display));
        alert(display);
        this.show = display;

    }
    
}