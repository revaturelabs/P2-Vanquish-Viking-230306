import { LightningElement } from 'lwc';
import FBCJPG from '@salesforce/resourceUrl/FBCJPG';

export default class RecordContainer extends LightningElement {
    
    activeSection = 'A';
    logo = FBCJPG;

    handleToggle(){
        if(this.activeSection === 'A'){
            this.activeSection = 'L';
        }
        else{
            this.activeSection = 'A';
        }
    }
}