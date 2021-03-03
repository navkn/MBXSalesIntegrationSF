public class ResultPageController {
    public String message{get;set;}
    public String type{get;set;}
    public ResultPageController(){
         message=System.currentPageReference().getParameters().get('msg');
         type=System.currentPageReference().getParameters().get('type');
    }
}