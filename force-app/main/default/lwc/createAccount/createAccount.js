import { LightningElement, api } from 'lwc';

export default class CreateAccount extends LightningElement {
    @api recordId;
    @api objectApiName;
    fields = ['Name','Type','Website'];
}