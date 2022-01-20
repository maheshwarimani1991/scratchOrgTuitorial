import { LightningElement, wire, api, track } from 'lwc';
import getObjectList from '@salesforce/apex/DisplayRecentlyViewedRecordsHandler.getObjectList';
import getRecords from '@salesforce/apex/DisplayRecentlyViewedRecordsHandler.getRecords';

export default class DisplayRecentlyViewedRecords extends LightningElement {
    @api selectedObj;
    @api noOfRecords;
    recordsToDisplay;
    sObjectName;

    isloading = true;
    error;
    columns = [];
    records = [];
    options = [];

    connectedCallback() {
        if(this.selectedObj === undefined){
            this.selectedObj = 'Contact';
        }
        if(this.noOfRecords === undefined){
            this.noOfRecords = 10;
        }
        this.recordsToDisplay = this.noOfRecords;
        this.sObjectName = this.selectedObj;
    }

    @wire(getObjectList)
    handleObjectData({error, data}) {
        console.log('data : ', data);
        this.error = undefined;
        if(data) {
            this.options = JSON.parse(data);
        } else if(error) {
            // display error
            console.log('error : ', error);
            this.error = error.body.message;
            this.isloading = false;
        }
    }

    @wire(getRecords, { objectName: '$sObjectName', recordCount: '$recordsToDisplay' })
    handleRecordsData({error, data}) {
        this.error = undefined;
        if(data) {
            this.columns = this.prepareColumns(data.fieldInfoList);
            this.records = this.prepareRecords(data.records);
            console.log('..this.columns...', this.columns);
            console.log('..this.records...', this.records);
            this.isloading = false;
        } else if(error) {
            this.isloading = false;
            this.error = error.body.message;
        }
    }

    prepareColumns(fields) {
        let cols =  fields.map((field) => {
            let column = {label : field.label, fieldName : field.apiName, type : field.type};
            return column;
        });
        cols.push({ type: 'action', typeAttributes: { rowActions: this.getRowActions } });
        return cols;
    }

    getRowActions(row, intiateCallback) {
        const actions = [];
        actions.push({
            'label': 'Edit',
            'name': 'edit',
            'disabled': !row.UserRecordAccess.HasEditAccess
        });
        
        intiateCallback(actions);
    }

    prepareRecords(recordList) {
        let recToReturn = [];
        for(let rec of recordList) {
            let temp = JSON.parse(JSON.stringify(rec));
            for(let fieldName of Object.keys(rec)) {
                if(typeof rec[fieldName] == 'object') {
                    for(let f of Object.keys(rec[fieldName])) {
                        temp[fieldName + '.' + f] = rec[fieldName][f];
                    }
                }
            }
            recToReturn.push(temp);
        }
        return recToReturn;
    }

    handleChange(event) {
        if(event.target.label == 'Select an Object'){
            this.selectedObj = event.target.value;
        }else if(event.target.label == 'No. of Records to Display'){
            this.noOfRecords = event.target.value;
        }
        const isValid = this.template.querySelector('lightning-input').checkValidity();
        if(isValid){
            this.sObjectName = this.selectedObj;
            this.recordsToDisplay = this.noOfRecords;
            this.isloading = true;
        }else{
            this.template.querySelector('lightning-input').reportValidity();
        }
    }
}