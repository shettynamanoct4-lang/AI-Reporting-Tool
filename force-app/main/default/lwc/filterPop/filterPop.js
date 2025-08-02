import { LightningElement, track } from 'lwc';

export default class FilterPop extends LightningElement {
    @track filterOptions = [
        { label: 'Contains', value: 'contains' },
        { label: 'Not Contains', value: 'notContains' }
    ];
    selectedCriteria = '';
    filterValue = '';
    @track isShowModal = false;

    handleCriteriaChange(event) {
        this.selectedCriteria = event.detail.value;
    }

    handleValueChange(event) {
        this.filterValue = event.target.value;
    }

    showModalBox() {  
        this.isShowModal = true;
    }

    hideModalBox() {  
        this.isShowModal = false;
    }

    applyFilter() {
        // Send filter criteria and value to parent component
        const filterCriteria = {
            criteria: this.selectedCriteria,
            value: this.filterValue
        };
        console.log('Dispatching Filter Criteria:', filterCriteria);
        this.dispatchEvent(new CustomEvent('apply', { detail: filterCriteria }));
        // Close modal
        this.isShowModal = false;
        // Dispatch custom event to notify parent to hide the modal
        this.dispatchEvent(new CustomEvent('closemodal'));
    }
    

    clearFilter() {
        this.selectedCriteria = '';
        this.filterValue = '';
        // Dispatch custom event to notify parent to hide the modal
        this.dispatchEvent(new CustomEvent('closemodal'));
    }
}