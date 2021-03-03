import { LightningElement } from 'lwc';

export default class MobSupportDataSaveInBrowserWindow extends LightningElement {
    renderedCallback() {
        var path = window.location.href;
        window.myApplication = {};
        var ind = path.indexOf('/lightning/r/Account/');
        var str = path.substring(ind + 21);
        var id = str.substring(0, 18);
        var startPos = path.indexOf('/lightning/r/') + 13;
        var cutString = path.substring(startPos);
        var endPos = cutString.indexOf('/') + startPos;
        var SObjectType = path.substring(startPos, endPos);
        myApplication.state = { accId: id, SObjectType: SObjectType, pathname: path };
    }
}