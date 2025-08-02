import { LightningElement, track } from 'lwc';
import getChatGPTResponse from '@salesforce/apex/ChatGPTController.getChatGPTResponse';

export default class ChatGPTSearch extends LightningElement {
    @track question = '';
    @track response = '';
    @track loading = false;

    handleInputChange(event) {
        this.question = event.target.value;
    }

    async handleSearch() {
        if (!this.question) {
            this.response = 'Please enter a question.';
            return;
        }
        this.loading = true;
        this.response = '';

        try {
            // Set timeout to handle long responses
            const timeout = new Promise((_, reject) =>
                setTimeout(() => reject(new Error("Response timed out. Try again with a shorter question.")), 120000) // 30 seconds
            );

            const resultPromise = getChatGPTResponse({ userInput: this.question });
            const result = await Promise.race([resultPromise, timeout]); // Whichever completes first

            this.response = result;
        } catch (error) {
            this.response = error.message || 'Error fetching response. Please try again.';
        }

        this.loading = false;
    }
}