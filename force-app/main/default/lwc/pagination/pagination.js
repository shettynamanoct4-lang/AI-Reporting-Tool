import { LightningElement, api, track } from 'lwc';

export default class Pagination extends LightningElement {
    @api totalRecords;
    @api pageSize;
    @track totalPages;
    @track currentPage = 1;

    connectedCallback() {
        this.calculateTotalPages();
    }

    @api
    setCurrentPage(pageNumber) {
        this.currentPage = pageNumber;
        this.calculateTotalPages();
    }

    calculateTotalPages() {
        this.totalPages = Math.ceil(this.totalRecords / this.pageSize);
    }

    get disablePrevious() {
        return this.currentPage <= 1;
    }

    get disableNext() {
        return this.currentPage >= this.totalPages;
    }

    handlePreviousPage() {
        if (this.currentPage > 1) {
            this.currentPage -= 1;
            this.updatePagination();
        }
    }

    handleNextPage() {
        if (this.currentPage < this.totalPages) {
            this.currentPage += 1;
            this.updatePagination();
        }
    }

    handleFirstPage() {
        this.currentPage = 1;
        this.updatePagination();
    }

    handleLastPage() {
        this.currentPage = this.totalPages;
        this.updatePagination();
    }

    updatePagination() {
        const event = new CustomEvent('pagechange', {
            detail: { pageNumber: this.currentPage }
        });
        this.dispatchEvent(event);
    }

    get showPagination() {
        return this.totalPages > 1;
    }
}