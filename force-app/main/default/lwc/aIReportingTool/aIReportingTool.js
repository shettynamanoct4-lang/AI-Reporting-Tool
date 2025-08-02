import { LightningElement, track, wire } from 'lwc';
import getAIReport from '@salesforce/apex/AIReportingController.getAIReport';
import getPromptSuggestions from '@salesforce/apex/AIReportingController.getPromptSuggestions';
import getAISummary from '@salesforce/apex/AIReportingController.getAISummary';
import chatbotIcon from '@salesforce/resourceUrl/ChatbotIcon';
import chartjs from "@salesforce/resourceUrl/ChartJS";
import { loadScript } from "lightning/platformResourceLoader";
import sendEmailWithSummary from '@salesforce/apex/AIReportingController.sendEmailWithSummary';

export default class AIReportingTool extends LightningElement {
    @track userQuery = '';
    @track messages = [];
    loading = false;
    messageId = 0;
    @track showSuggestions = false;
    @track promptOptions = [];
    chatbotIconUrl = chatbotIcon;
    @track showChart = false;


    chart;
    config = {
        type: "polarArea",
        data: {
            labels: ["Red", "Green", "Yellow", "Grey", "Blue"],
            datasets: [
                {
                    label: "My First Dataset",
                    data: [11, 16, 7, 3, 14],
                    backgroundColor: [
                        "rgb(255, 99, 132)",
                        "rgb(75, 192, 192)",
                        "rgb(255, 205, 86)",
                        "rgb(201, 203, 207)",
                        "rgb(54, 162, 235)"
                    ]
                }
            ]
        }
    };

    handleVisualize() {
        this.showChart = true;
        this.chartJsInitialized = false; // force reload
    }


    renderedCallback() {
        if (this.chartJsInitialized || !this.showChart) return;
        this.chartJsInitialized = true;

        loadScript(this, chartjs)
            .then(() => {
                const canvas = this.template.querySelector('canvas.chart-canvas');
                if (canvas) {
                    const ctx = canvas.getContext('2d');
                    this.chart = new window.Chart(ctx, this.config);
                }
            })
            .catch((error) => {
                console.error("Chart load failed:", error);
            });
    }

    async handleSendEmail(event) {
        const msgId = event.target.dataset.id;
        const msg = this.messages.find(m => m.id == msgId);
    
        if (!msg || !msg.tableData || msg.tableData.length === 0) {
            this.addMessage('⚠️ Cannot send email: No data to send.', 'bot-error-message');
            return;
        }
    
        this.loading = true;
        try {
            const jsonData = JSON.stringify(msg.tableData);
             const result = await sendEmailWithSummary({ tableDataJson: jsonData });
             


    
            if (result === 'Success') {
                this.addMessage('📧 Email sent successfully!', 'bot-message');
            } else {
                this.addMessage('⚠️ Failed to send email: ' + result, 'bot-error-message');
            }
        } catch (error) {
            console.error('Send Email Error:', error);
            this.addMessage('⚠️ An error occurred while sending the email.', 'bot-error-message');
        } finally {
            this.loading = false;
            this.scrollToBottom();
        }
    }



    connectedCallback() {
        console.log('Chatbot Icon URL:', this.chatbotIconUrl);
    }


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
            let result2 = result.replace('expr0', 'Result');
            let responseData = JSON.parse(result2);

            if (responseData != null && responseData[0] != null && responseData[0].attributes.type == 'AggregateResult') {
                if (responseData[0].Result == null) {
                    responseData[0].Result = 0;
                }
            }
            if (responseData.error) {
                this.addMessage('Kindly specify/rephrase your requirements clearly to obtain the desired results', 'bot-error-message')

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
                this.addMessage('Kindly specify/rephrase your requirements clearly to obtain the desired results', 'bot-message');
            }
        } catch (error) {
            console.log('error - ' + error);
            this.addMessage('Technical Error occurred. Please retry', 'bot-error-message');
        } finally {
            this.loading = false;
            this.scrollToBottom();
        }
    }

    async handleSummarize(event) {
        const msgId = event.target.dataset.id;
        const msg = this.messages.find(m => m.id == msgId);
        if (!msg || !msg.tableData.length) {
            return;
        }
        // Add "Summarizing data..." placeholder
        const loadingMsgId = ++this.messageId;
        this.messages.push({
            id: loadingMsgId,
            text: 'Summarizing data...',
            class: 'bot-message',
            isTable: false
        });
        this.scrollToBottom();
        this.loading = true;

        try {
            const result = await getAISummary({ tableData: JSON.stringify(msg.tableData) });
            let responseData = JSON.parse(result);

            // Remove "Summarizing data..." placeholder and replace with response
            this.messages = this.messages.filter(m => m.id !== loadingMsgId);

            if (responseData.error) {
                this.addMessage(responseData.error, 'bot-error-message');
            } else {
                //const formattedSummary = responseData.message.replace(/\n/g, '<br/>');
                //this.addMessage(formattedSummary, 'bot-message');
                const formattedSummary = responseData.message
                    .split('\n')
                    .map(line => {
                        const match = line.match(/^(\-?\s?\*\*(.*?)\*\*):(.*)/);
                        if (match) {
                            const label = match[2].trim();
                            const rest = match[3].trim();
                            return `- <strong>${label}</strong>: ${rest}`;
                        }
                        return line;
                    })
                    .join('<br/>');

                this.addMessage(formattedSummary, 'bot-message');


            }
        } catch (error) {
            this.messages = this.messages.filter(m => m.id !== loadingMsgId);
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
        const recordCount = tableData.length;
        const label = recordCount === 1 ? 'record' : 'records';
        this.messages.push({
            id: ++this.messageId,
            tableData,
            columns,
            recordCount,
            recordLabel: label,
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