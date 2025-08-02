import { LightningElement, track } from 'lwc';

export default class UBOShareholderComponent extends LightningElement {
    @track data = [
        { id: 'row1', label: 'UBO/Shareholder' },
        { id: 'row2', label: 'Shareholder :' },
        { id: 'row3', label: 'Type :' },
        { id: 'row4', label: 'Shareholder Count :' },
        { id: 'row5', label: 'Parent Shareholding :' },
        { id: 'row6', label: 'Controlling interest :' },
        { id: 'row7', label: 'UBO/UBC :' }
    ];

    @track columns = [
        { label: 'Label', fieldName: 'label', type: 'text', cellAttributes: { class: 'bold-label' }, showButtons: false },
        { label: 'Column 1', fieldName: 'col1', type: 'text', showButtons: true },
        { label: 'Column 2', fieldName: 'col2', type: 'text', showButtons: true },
        { label: 'Column 3', fieldName: 'col3', type: 'text', showButtons: true },
        { label: 'Column 4', fieldName: 'col4', type: 'text', showButtons: true },
        { label: 'Column 5', fieldName: 'col5', type: 'text', showButtons: true },
        { label: 'Column 6', fieldName: 'col6', type: 'text', showButtons: true }
    ];

    get showButtons() {
        return this.columns.some(column => column.showButtons);
    }

    handleRefresh(event) {
        const colId = event.target.dataset.id;
        console.log('Refresh button clicked for column: ' + colId);
        // Add your refresh logic here
    }

    handleCertificate(event) {
        const colId = event.target.dataset.id;
        console.log('Certificate button clicked for column: ' + colId);
        // Add your certificate logic here
    }
}