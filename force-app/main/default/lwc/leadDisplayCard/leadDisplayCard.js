import { LightningElement, wire, track } from 'lwc';
import getLeads from '@salesforce/apex/fbcLightningUtilities.getLeads';
import { updateRecord } from 'lightning/uiRecordApi';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { refreshApex } from '@salesforce/apex';

export default class LeadDisplayCard extends LightningElement {

    @track columns = [
        {
            label: 'First Name',
            fieldName: 'FirstName',
            type: 'text',
            sortable: true,
            hideDefaultActions: true,
            editable: true,
            initialWidth: 100
        },
        {
            label: 'Last Name',
            fieldName: 'LastName',
            type: 'text',
            sortable: true,
            hideDefaultActions: true,
            editable: true,
            initialWidth: 140
            
        },
        {
            label: 'Status',
            fieldName: 'Status',
            type: 'text',
            sortable: true,
            hideDefaultActions: true,
            editable: true
        },
        {
            label: 'Company',
            fieldName: 'Company',
            type: 'text',
            sortable: true,
            hideDefaultActions: true,
            editable: true
        },
        {
            label: 'Title',
            fieldName: 'Title',
            type: 'text',
            sortable: true,
            hideDefaultActions: true,
            editable: true
        },
        {
            label: 'Industry',
            fieldName: 'Industry',
            type: 'text',
            sortable: true,
            hideDefaultActions: true,
            editable: true,
            initialWidth: 120
        },
        {
            label: 'Rating',
            fieldName: 'Rating',
            type: 'text',
            sortable: true,
            hideDefaultActions: true,
            editable: true,
            initialWidth: 80
            
        },
        {
            label: 'Phone',
            fieldName: 'Phone',
            type: 'phone',
            sortable: true,
            hideDefaultActions: true,
            editable: true,
            initialWidth: 140
        },
        {
            label: 'Email',
            fieldName: 'Email',
            type: 'email',
            sortable: true,
            hideDefaultActions: true,
            editable: true
        },
        {
            label: 'Conversion Date',
            fieldName: 'Conversion_Date__c',
            type: 'date',
            sortable: true,
            hideDefaultActions: true,
            editable: true,
            initialWidth: 140
        }
    ];

    @track error;
    @track leads = [];
    @track wiredLeads;
    sortedBy;
    sortDirection = 'asc';
    draftValues = [];
    creatingLead = false;
    deletingLead = false;
    searching = false;
    isSelected = false;
    @track searchTerm = '';

    @wire(getLeads, {searchTerm : '$searchTerm'})
    getWiredLeads(result){
        this.wiredLeads = result;
        if(result.data){
            this.leads = result.data;
            this.error = undefined;
        }
        else if(result.error){
            this.error = result.error;
            this.aleads = [];
        }
    }

    updateColumnSorting(event){
        this.sortedBy = event.detail.fieldName;
        this.sortDirection = event.detail.sortDirection;
        this.sort(this.sortedBy,this.sortDirection);
    }

    sort(fieldName, direction){
        let parseData = JSON.parse(JSON.stringify(this.leads));
        let keyVal = (a) => {
            return a[fieldName]
        };
        let isReverse = direction === 'asc' ? 1 : -1;
        parseData.sort((x,y) => {
            x = keyVal(x) ? keyVal(x) : '';
            y = keyVal(y) ? keyVal(y) : '';
            return isReverse * ((x > y) - (y > x));
        });
        this.leads = parseData;
    }

    async handleSave(event){
        const leads = event.detail.draftValues.slice().map((draftValue) =>{
            const fields = Object.assign({}, draftValue);
            return {fields};
        });

        this.draftValues = [];

        try{
            const accUpdatePromises = leads.map((acc) => updateRecord(acc));
            await Promise.all(accUpdatePromises);
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Success',
                    message: 'Leads Updated',
                    variant: 'success'
                })
            );
            await refreshApex(this.wiredLeads);
        }
        catch(error){
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error Updating or Reloading Leads',
                    message: error.body.message,
                    variant: 'error'
                })
            );
        }
    }

    handleCreate(){
        this.creatingLead = true;
    }

    handleDelete(){
        this.deletingLead = true;
    }

    async handleCreateStatus(event){
        if(event.detail.status === 'FINISHED'){
            this.creatingLead = false;
            await refreshApex(this.wiredLeads);
        }
    }

    async handleDeleteStatus(event){
        if(event.detail.status === 'FINISHED'){
            this.deletingLead = false;
            await refreshApex(this.wiredLeads);
        }
    }

    handleSearchDisplay(){
        this.searching = !this.searching;
        this.isSelected = !this.isSelected;
    }

    async handleSearch(event){
        this.searchTerm = event.detail;
        await refreshApex(this.wiredLeads);
    }
    
}