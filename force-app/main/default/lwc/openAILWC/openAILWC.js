import { LightningElement, track, wire } from 'lwc';
import getAIReport from '@salesforce/apex/OpenAIController.getAIReport';
import getPromptSuggestions from '@salesforce/apex/OpenAIController.getPromptSuggestions';


export default class OpenAILWC extends LightningElement {
    @track userQuery = '';
    @track messages = [];
    loading = false;
    messageId = 0;
    @track showSuggestions = false;
    @track promptOptions = [];


    handleInputChange(event) {
        this.userQuery = event.target.value; // Capture user input
        if (this.userQuery.length > 2) {
            this.fetchPromptSuggestions(this.userQuery); // Fetch suggestions
        } else {
            this.showSuggestions = false;
        }
    }


    async fetchPromptSuggestions(searchText) {
        try {
            const prompts = await getPromptSuggestions({ searchText });
            this.promptOptions = prompts.map(prompt => ({ label: prompt, value: prompt }));
            this.showSuggestions = this.promptOptions.length > 0;
        } catch (error) {
            console.error('Error fetching prompts: ', error);
            this.showSuggestions = false;
        }
    }

    handleShowSuggestions() {
        if (this.promptOptions.length > 0) {
            this.showSuggestions = true;
        }
    }

    handleSuggestionClick(event) {
        this.userQuery = event.target.dataset.value;
        this.showSuggestions = false;
    }



    async handleAsk() {
        if (!this.userQuery.trim()) return;

        this.addMessage(this.userQuery, 'user-message');
        const currentQuery = this.userQuery;
        this.userQuery = '';
        this.loading = true;

        try {
            const result = await getAIReport({ queryInput: currentQuery });
            let responseData = JSON.parse(result);

            if (responseData.error) {
                this.addMessage(responseData.error, 'bot-error-message');
            } else if (responseData.message) {
                this.addMessage(responseData.message, 'bot-message');
            } else if (Array.isArray(responseData)) {
                if (responseData.length > 0) {
                    const columns = Object.keys(responseData[0]).filter(key => key !== 'attributes').map(field => ({
                        label: field,
                        fieldName: field,
                        type: 'text'
                    }));

                    const cleanData = responseData.map(({ attributes, ...rest }) => rest);

                    this.addTableMessage(cleanData, columns);
                } else {
                    this.addMessage('No records found.', 'bot-message');
                }
            } else {
                this.addMessage('I didn\'t understand that. Could you rephrase?', 'bot-message');
            }
        } catch (error) {
            this.addMessage('Oops! Something went wrong.', 'bot-error-message');
        } finally {
            this.loading = false;
            this.scrollToBottom();
        }
    }

    handleReset() {
        this.messages = [];
        this.userQuery = '';
    }

    addMessage(text, className) {
        this.messages.push({
            id: ++this.messageId,
            text,
            class: className,
            isTable: false
        });
        this.scrollToBottom();
    }

    addTableMessage(tableData, columns) {
        this.messages.push({
            id: ++this.messageId,
            tableData,
            columns,
            class: 'bot-message',
            isTable: true
        });
        this.scrollToBottom();
    }

    scrollToBottom() {
        setTimeout(() => {
            const container = this.template.querySelector('.chat-messages');
            container.scrollTop = container.scrollHeight;
        }, 100);
    }

    downloadExcel(event) {
        const msgId = event.target.dataset.id;
        const msg = this.messages.find(m => m.id == msgId);
        if (!msg || !msg.tableData.length) {
            return;
        }

        let excelContent = '\uFEFF';
        const headers = msg.columns.map(col => col.label).join('\t');
        excelContent += headers + '\n';

        msg.tableData.forEach(row => {
            excelContent += msg.columns.map(col => row[col.fieldName]).join('\t') + '\n';
        });

        this.downloadFile(excelContent, 'AI_Report.xls');
    }

    downloadFile(content, fileName) {
        const encodedUri = encodeURI('data:text/csv;charset=utf-8,' + content);
        const link = document.createElement('a');
        link.setAttribute('href', encodedUri);
        link.setAttribute('download', fileName);
        document.body.appendChild(link);
        link.click();
        document.body.removeChild(link);
    }
}