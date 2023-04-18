import { LightningElement,wire,api, track } from 'lwc';
import getOrders from '@salesforce/apex/OrderControllerLWC.getOrders';
import deleteOrder from '@salesforce/apex/OrderControllerLWC.deleteOrder';
import getOrderItems from '@salesforce/apex/OrderControllerLWC.getOrderItems';
import add12CountPencils from '@salesforce/apex/OrderControllerLWC.add12CountPencils';
import add500PaperReam from '@salesforce/apex/OrderControllerLWC.add500PaperReam';
import addMacBook from '@salesforce/apex/OrderControllerLWC.addMacBook';
import {refreshApex} from '@salesforce/apex';
import { updateRecord } from 'lightning/uiRecordApi';
import {ShowToastEvent} from 'lightning/platformShowToastEvent';

import ORDER_OBJECT from '@salesforce/schema/Order';
import ORDERSTART_DATE_FIELD from '@salesforce/schema/Order.EffectiveDate';
import ORDER_ACCOUNTID_FIELD from '@salesforce/schema/Order.AccountId';
import ORDERNAME_FIELD from '@salesforce/schema/Order.Name';
import ORDERSTATUS_FIELD from '@salesforce/schema/Order.Status';
import ORDERAMOUNT_FIELD from '@salesforce/schema/Order.TotalAmount';
import OrderNumber_FIELD from '@salesforce/schema/Order.OrderNumber';

import ORDERITEM_OBJECT from '@salesforce/schema/OrderItem';
import ORDERITEM_QUANTITY_FIELD from '@salesforce/schema/OrderItem.Quantity';
import ORDERITEM_ORDERID_FIELD from '@salesforce/schema/OrderItem.OrderId';
import ORDERITEM_PBENTRYID_FIELD from '@salesforce/schema/OrderItem.Product2Id';
import ORDERITEM_UNITPRICE_FIELD from '@salesforce/schema/OrderItem.UnitPrice';
import deleteOrderItem from '@salesforce/apex/OrderControllerLWC.deleteOrderItem';

const actions= [{label:'Delete', name:'delete'}];
const COLUMNS=[
    {label:'Order Name', fieldName:ORDERNAME_FIELD.fieldApiName, type:'text', editable:true},
    {label:'Order Number', fieldName:OrderNumber_FIELD.fieldApiName, typer:'number'},
    {label:'Status',fieldName: ORDERSTATUS_FIELD.fieldApiName, type:'picklist', editable:true},
    {label:'Amount',fieldName:ORDERAMOUNT_FIELD.fieldApiName, type:'currency'},
    {type:'action', label:'Actions', typeAttributes:{rowActions:actions}},
    {type:'button', label:'Add Product to Order', typeAttributes:{
        label:'Add Macbook Pro',
        name:'Add Macbook Pro',
        disabled:false,
        title:'Add Product',
        iconPosition:'left'}},
    {type:'button', typeAttributes:{
        label:'Add Paper Ream',
        name:'Add Paper Ream',
        disabled:false,
        iconPosition:'left'}},
    {type:'button', typeAttributes:{
        label:'Add Pencils',
        name:'Add Pencils',
        disabled:false,
        iconPosition:'left'}}
];

const itemCOLUMNS=[
    {label:'Order Name', fieldName:'OrderName__c',type:'text'},
    {label:'Product', fieldName:'Product2Id',type:'text'},
    {label:'Unit Price', fieldName:'UnitPrice',type:'currency'},
    {label:'Quantity', fieldName:'Quantity',type:'number'},
    {label:'Total Price', fieldName:'TotalPrice', type:'currency'},
    {label:'Order Id', fieldName:'OrderId',type:'text'},
    {type:'action', typeAttributes:{rowActions:actions}}
];

export default class OrderList extends LightningElement {
    columns = COLUMNS;
    columns2=itemCOLUMNS;
    draftValues = [];

    showOrderCreator=false;
    showAddProduct= false;

    @track
    actions=actions;

    @wire(getOrders)
    orders;

    @wire(getOrderItems)
    orderItems;

    orderApiName= ORDER_OBJECT;
    fields=[ORDERNAME_FIELD,ORDER_ACCOUNTID_FIELD,ORDERSTART_DATE_FIELD,ORDERSTATUS_FIELD];

    orderItemApiName=ORDERITEM_OBJECT;
    orderItemFields=[ORDERITEM_ORDERID_FIELD,ORDERITEM_PBENTRYID_FIELD,ORDERITEM_QUANTITY_FIELD,ORDERITEM_UNITPRICE_FIELD];
    

    async handleSave(event){
        const records = event.detail.draftValues.slice().map((draftValue) => {
            const fields = Object.assign({},draftValue);
            return {fields};
        });
        this.draftValues = [];
        try{
            const recordUpdatePromises = records.map((record) => 
                updateRecord(record));

                await Promise.all(recordUpdatePromises);

                this.dispatchEvent(new ShowToastEvent({
                    title:'Success',
                    message:'Order(s) updated!',
                    variant:'success'
                }));

                await refreshApex(this.orders);
        } catch(error){
            this.dispatchEvent(new ShowToastEvent({
                title:'Error updating/reloading Orders',
                message:error.body.message,
                variant:'error'
            }));
        }
        }

        async handleRowAction(event){
            const actionName= event.detail.action.name;
            const row = event.detail.row;
            console.log(row.Id);
            switch(actionName){
                case 'delete':
                    this.handleDeleteOrder(row.Id);
                    break;
                
                case 'Add Macbook Pro':
                    this.handleAddMac(row.Id);  
                    break;

                case 'Add Paper Ream':
                    this.handleAddReam(row.Id);
                    break;

                case 'Add Pencils':
                    this.handleAddPencils(row.Id);
                    break;

                default:
            }
        }

        async handleItemRowAction(event){
            const actionName = event.detail.action.name;
            const row = event.detail.row;

            switch(actionName){
                case 'delete':
                    this.handleDeleteOrderItem(row.Id);
                    break;

                default:
            }
        }

        async handleDeleteOrderItem(recordToDelete){
            await deleteOrderItem({rowid:recordToDelete})
            const deleteItemToast = new ShowToastEvent({
                title:'Delete Success',
                message:'Order Product Removed from Order',
                variant:'success'});
                this.dispatchEvent(deleteItemToast);
                return refreshApex(this.orderItems, this.orders);
        }

        async handleDeleteOrder(recordIdToDelete){
           await deleteOrder({rowid:recordIdToDelete})
            const deleteToast = new ShowToastEvent({
                title:'Delete Success',
                message:'Record deleted successfully',
                variant:'success'});
            this.dispatchEvent(deleteToast);
            return refreshApex(this.orders, this.orderItems);
        }

        async handleAddMac(itemToAdd){
            await addMacBook({orderId:itemToAdd});
            const addMac = new ShowToastEvent({
                title:'Macbook Added',
                message:'Successfully added Macbook to Order',
                variant:'success'});
            this.dispatchEvent(addMac);
            return refreshApex(this.orders, this.orderItems);
        }

       async handleAddReam(itemToAdd){
           await add500PaperReam({orderId:itemToAdd});
            const addPaper = new ShowToastEvent({
                title:'Paper Added',
                message:'A Paper Ream of 500 was added to the Order',
                variant:'success'});
                this.dispatchEvent(addPaper);
                return refreshApex(this.orders, this.orderItems);
        }

        async handleAddPencils(itemToAdd){
            await add12CountPencils({orderId:itemToAdd});
            const addPencils = new ShowToastEvent({
                title:'Pencils Added',
                message:'A 12-count of #2 Pencils Added to Order',
                variant:'success'});
                this.dispatchEvent(addPencils);
                return refreshApex(this.orders, this.orderItems);
        }

        handleSuccess(event){
            const successToast = new ShowToastEvent({
                title:'Order Created',
                message:'Record ID: ' + event.detail.Id,
                variant:'Success'
            });
            this.dispatchEvent(successToast);
            return refreshApex(this.orders);
        }

        handleItemSuccess(event){
            const itemSuccessToast = new ShowToastEvent({
                title:'Product Added',
                message:'Product successfully added to order',
                variant:'success'
            });
            this.dispatchEvent(itemSuccessToast);
            return refreshApex(this.orderItems);
        }

        toggleOrderCreator(){
            this.showOrderCreator= !this.showOrderCreator;
        }

        toggleAddProduct(){
            this.showAddProduct= !this.showAddProduct;
        }

        }
    
