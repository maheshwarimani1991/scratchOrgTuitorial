import { LightningElement, api } from 'lwc';
import { NavigationMixin } from "lightning/navigation";

export default class RecordFilterResults extends NavigationMixin(LightningElement) {
    @api records;
    @api columns;
    @api isloading;

    get hasRecords() {
        return this.records.length > 0 || this.isloading;
    }

    handleRowAction(event) {
        const action = event.detail.action;
        const row = event.detail.row;
        if(action.name == 'edit') {
            // open edit page
            this[NavigationMixin.Navigate]({
                type: "standard__recordPage",
                attributes: {
                    recordId: row.Id,
                    actionName: "edit"
                }
            });
        }
    }
}