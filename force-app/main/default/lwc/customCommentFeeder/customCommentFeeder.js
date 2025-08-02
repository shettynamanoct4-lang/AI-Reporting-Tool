import { LightningElement, api, wire, track } from 'lwc';
import { getRecord, getFieldValue } from 'lightning/uiRecordApi';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { NavigationMixin } from 'lightning/navigation';
import { refreshApex } from '@salesforce/apex';
import searchUsers from '@salesforce/apex/CustomCommentFeederController.searchUsers'; // Import your Apex method
import createFeedItemRec from '@salesforce/apex/CustomCommentFeederController.createFeedItemRec';
import getFeedItemList from '@salesforce/apex/CustomCommentFeederController.getFeedItemList';
import STATUS_FIELD from '@salesforce/schema/Case.Status';

export default class CustomCommentFeeder extends NavigationMixin(LightningElement) {
    @api recordId;
    @track commentBody;
    @track showUserLookup = false;
    @track userLookupResults = [];
    @wire(getRecord, { recordId: '$recordId', fields: [STATUS_FIELD] }) caseRecord;

    get caseStatus() {
        return getFieldValue(this.caseRecord.data, STATUS_FIELD);
    }

    @wire(getFeedItemList, { status: '$caseStatus', parentId: '$recordId' }) comments;

    recFeedItem = {
        Body: this.commentBody,
        ParentId: this.recordId,
        IsRichText: true
    };

    handleChange(event) {
        this.recFeedItem.Body = event.target.value;
        this.commentBody = event.target.value;
    }

    handleKeyUp(event) {
        const inputValue = event.target.value;
        const plainTextValue = this.extractTextFromHTML(inputValue);
        console.log('Plain text value:', plainTextValue);
        const mentionMatch = plainTextValue.match(/@(\w*)$/);
        console.log('KeyUp Event:', mentionMatch);

        if (mentionMatch) {
            const searchTerm = mentionMatch[1];
            if (searchTerm.length > 2) { // Fetch users only if the search term is longer than 2 characters
                this.lookupUsers(searchTerm);
                console.log('Search Term:', searchTerm);
            } else {
                this.showUserLookup = false;
            }
        } else {
            this.showUserLookup = false;
        }
    }

    extractTextFromHTML(html) {
        let div = document.createElement("div");
        div.innerHTML = html;
        return div.textContent || div.innerText || "";
    }

    lookupUsers(searchTerm) {
        searchUsers({ searchTerm })
            .then(result => {
                console.log('User Lookup Results:', result);
                this.userLookupResults = result;
                this.showUserLookup = true;
            })
            .catch(error => {
                console.error('Error fetching users:', error);
                this.showUserLookup = false;
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Error fetching users',
                        message: error.body.message,
                        variant: 'error'
                    })
                );
            });
    }

    handleUserSelect(event) {
        const selectedUserId = event.currentTarget.dataset.id;
        const selectedUser = this.userLookupResults.find(user => user.Id === selectedUserId);
        const selectedUserName = selectedUser.Name;
        console.log('Selected User:', selectedUser);
        
        this.commentBody += `@${selectedUserName} `; // Append the selected username to the comment body
        this.recFeedItem.Body = this.commentBody;
        this.showUserLookup = false; // Hide the lookup results
    }

    handlePostClick(event) {
        this.recFeedItem.ParentId = this.recordId;
        console.log('Post Click Event:', JSON.stringify(this.recFeedItem));
        createFeedItemRec({ feedItemRec: this.recFeedItem })
            .then(() => {
                this.commentBody = '';
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Success',
                        message: 'Comment Posted!',
                        variant: 'success'
                    })
                );
                refreshApex(this.comments);
            })
            .catch(error => {
                console.error('Error posting comment:', error);
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Error!',
                        message: error.body.message,
                        variant: 'error'
                    })
                );
            });
    }
}