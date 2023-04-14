import { LightningElement } from 'lwc';

export default class RecordContainer extends LightningElement {
    
    activeSection = 'A';

    handleToggle(){
        if(this.activeSection === 'A'){
            this.activeSection = 'L';
        }
        else{
            this.activeSection = 'A';
        }
    }
}