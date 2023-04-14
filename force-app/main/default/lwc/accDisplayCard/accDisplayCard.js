import { LightningElement, wire, track } from 'lwc';
import getAccounts from '@salesforce/apex/fbcLightningUtilities.getAccounts';
import { updateRecord } from 'lightning/uiRecordApi';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { refreshApex } from '@salesforce/apex';

export default class AccDisplayCard extends LightningElement {

    @track columns = [
        {
            label: 'Name',
            fieldName: 'Name',
            type: 'text',
            sortable: true,
            hideDefaultActions: true,
            editable: true,
        },
        {
            label: 'Rating',
            fieldName: 'Rating',
            type: 'text',
            sortable: true,
            hideDefaultActions: true,
            editable: true,
            initialWidth: 100
        },
        {
            label: 'Annual Revenue',
            fieldName: 'AnnualRevenue',
            type: 'currency',
            sortable: true,
            hideDefaultActions: true,
            editable: true,
            initialWidth: 200
        },
        {
            label: 'Industry',
            fieldName: 'Industry',
            type: 'text',
            sortable: true,
            hideDefaultActions: true,
            editable: true,
            initialWidth: 300      
        },
        {
            label: 'Employees',
            fieldName: 'NumberOfEmployees',
            type: 'number',
            sortable: true,
            hideDefaultActions: true,
            editable: true,
            initialWidth: 180
        },
        {
            label: 'Phone',
            fieldName: 'Phone',
            type: 'phone',
            sortable: true,
            hideDefaultActions: true,
            editable: true,
            initialWidth: 180
        },
        {
            label: 'City',
            fieldName: 'BillingCity',
            type: 'text',
            sortable: true,
            hideDefaultActions: true,
            editable: true,
            initialWidth: 180
        },
        {
            label: 'State/Province',
            fieldName: 'BillingState',
            type: 'text',
            sortable: true,
            hideDefaultActions: true,
            editable: true,
            initialWidth: 180
        }
    ];

    @track error;
    @track accounts = [];
    @track wiredAccounts;
    sortedBy;
    sortDirection = 'asc';
    draftValues = [];
    creatingAccount = false;
    deletingAccount = false;

    @wire(getAccounts)
    getWiredAccounts(result){
        this.wiredAccounts = result;
        if(result.data){
            this.accounts = result.data;
            this.error = undefined;
        }
        else if(result.error){
            this.error = result.error;
            this.accounts = [];
        }
    }

    updateColumnSorting(event){
        this.sortedBy = event.detail.fieldName;
        this.sortDirection = event.detail.sortDirection;
        this.sort(this.sortedBy,this.sortDirection);
    }

    sort(fieldName, direction){
        let parseData = JSON.parse(JSON.stringify(this.accounts));
        let keyVal = (a) => {
            return a[fieldName]
        };
        let isReverse = direction === 'asc' ? 1 : -1;
        parseData.sort((x,y) => {
            x = keyVal(x) ? keyVal(x) : '';
            y = keyVal(y) ? keyVal(y) : '';
            return isReverse * ((x > y) - (y > x));
        });
        this.accounts = parseData;
    }

    async handleSave(event){
        const accs = event.detail.draftValues.slice().map((draftValue) =>{
            const fields = Object.assign({}, draftValue);
            return {fields};
        });

        this.draftValues = [];

        try{
            const accUpdatePromises = accs.map((acc) => updateRecord(acc));
            await Promise.all(accUpdatePromises);
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Success',
                    message: 'Accounts Updated',
                    variant: 'success'
                })
            );
            await refreshApex(this.wiredAccounts);
        }
        catch(error){
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error Updating or Reloading Accounts',
                    message: error.body.message,
                    variant: 'error'
                })
            );
        }
    }

    handleCreate(){
        this.creatingAccount = true;
    }

    handleDelete(){
        this.deletingAccount = true;
    }

    async handleCreateStatus(event){
        if(event.detail.status === 'FINISHED'){
            this.creatingAccount = false;
            await refreshApex(this.wiredAccounts);
        }
    }

    async handleDeleteStatus(event){
        if(event.detail.status === 'FINISHED'){
            this.deletingAccount = false;
            await refreshApex(this.wiredAccounts);
        }
    }

}