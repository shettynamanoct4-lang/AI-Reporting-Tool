import { LightningElement, track } from 'lwc';

export default class DynamicForm extends LightningElement {
  @track fields = [
    { apiName: 'Name', label: 'Account Name', required: true },
    { apiName: 'Phone', label: 'Phone', required: false },
    { apiName: 'Rating', label: 'Rating', required: false }
    // Add more fields as needed
  ];

  handleSubmit() {
    const form = this.template.querySelector('lightning-record-edit-form');
    form.submit();
  }
}