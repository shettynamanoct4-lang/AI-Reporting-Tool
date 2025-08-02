import { LightningElement, api } from 'lwc';

export default class UserCommentTile extends LightningElement {
    @api userComment;

    get createdDate() {
        return new Date(this.userComment.CreatedDate);
    }

    handleClick(event) {
        event.preventDefault();
        const selectEvent = new CustomEvent('select', {
            detail: this.userComment.Id
        });
        this.dispatchEvent(selectEvent);
    }
}