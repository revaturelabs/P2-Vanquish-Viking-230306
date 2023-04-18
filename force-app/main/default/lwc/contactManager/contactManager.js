import { LightningElement, wire, track } from 'lwc';
import getCustomerContacts from '@salesforce/apex/UseCaseC30Controller.getCustomerContacts';
import saveContacts from '@salesforce/apex/UseCaseC30Controller.saveContacts';
import { refreshApex } from '@salesforce/apex';
import { deleteRecord } from 'lightning/uiRecordApi';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class ContactManager extends LightningElement {
    searchKey = '';
    @wire
    (getCustomerContacts, {searchKey: '$searchKey'}) customerContacts;

    @track
    draftValues = [];

    @track
    showNewContactForm = false;

    
    columns = [
        { label: 'First Name', fieldName: 'FirstName', editable: true},
        { label: 'Last Name', fieldName: 'LastName', editable: true },
        { label: 'Email', fieldName: 'Email', editable: true},
        { label: 'Department', fieldName: 'Department', editable: true},
        { label: 'Service Technician', 
          fieldName: 'Service_Technician__c', 
          type: 'boolean',
          editable: true,
          cellAttributes: {alignment: 'center'}
        },
        {
            type: 'button-icon',
            initialWidth: 75,
            typeAttributes: {
                iconName: 'utility:delete',
                name: 'delete',
                title: 'Delete',
                variant: 'border-filled',
                alternativeText: 'Delete',
            },
        },
        // Add more columns as needed
    ];

    handleRowAction(event) {
        this.disableSaveButton = true;
        const actionName = event.detail.action.name;
        const row = event.detail.row;
        if (actionName === 'delete') {
            this.deleteContact(row);
        }
    }

    async deleteContact(row) {
        try {
            await deleteRecord(row.Id);
            refreshApex(this.customerContacts);
        } catch (error) {
            console.error('Error deleting contact: ', error);
        }
    }

    handleSearchChange(event) {
        this.searchKey = event.target.value;
        if (this.searchKey === '') {
            refreshApex(this.customerContacts);
        } else {
            clearTimeout(this.delayTimeout);
            this.delayTimeout = setTimeout(() => {
                refreshApex(this.customerContacts);
            }, 300);
        }
    }

    handleSave(event) {
        const recordInputs = event.detail.draftValues.slice().map(draft => {
            const fields = Object.assign({}, draft);
            return { fields };
        });
        const updatedRecords = recordInputs.map(recordInput => {
            return {
                Id: recordInput.fields.Id,
                FirstName: recordInput.fields.FirstName,
                LastName: recordInput.fields.LastName,
                Email: recordInput.fields.Email,
                Department: recordInput.fields.Department,
                Service_Technician__c: recordInput.fields.Service_Technician__c
                // New fields 
            };
        });
        saveContacts({ data: updatedRecords })
            .then(() => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Success',
                        message: 'Contacts updated',
                        variant: 'success'
                    })
                );
                this.draftValues = [];
                return refreshApex(this.customerContacts);
            })
            .catch(error => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Error updating contacts',
                        message: error.body.message,
                        variant: 'error'
                    })
                );
            });
    }

    handleRowAction(event) {
        const actionName = event.detail.action.name;
        const row = event.detail.row;
        if (actionName === 'delete') {
            this.deleteContact(row);
        }
    }

    toggleNewContactForm() {
        this.showNewContactForm = !this.showNewContactForm;
    }

    handleSuccess() {
        this.dispatchEvent(
            new ShowToastEvent({
                title: 'Success',
                message: 'New contact created',
                variant: 'success'
            })
        );
        this.showNewContactForm = false;
        refreshApex(this.customerContacts);
    }
    
}
