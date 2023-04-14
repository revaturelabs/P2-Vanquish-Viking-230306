import { LightningElement } from 'lwc';

export default class AccSearchCard extends LightningElement {
    
    searchTerm = '';
    hasSearched= false;

    handleTermChange(event){
        this.searchTerm = event.detail.value;
    }

    filterAccounts(){
        this.dispatchEvent(
            new CustomEvent(
                'filter',
                { detail : this.searchTerm}
            )
        );
        this.hasSearched = true;
    }

    clearSearch(){
        this.dispatchEvent(
            new CustomEvent(
                'filter',
                { detail : ''}
            )
        );
        this.hasSearched = false;
    }
}