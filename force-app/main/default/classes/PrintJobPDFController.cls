public class PrintJobPDFController {
    @AuraEnabled
    public static List<String> getPDFPrint(String accIndustry){
        List<String> pageStrings = new List<String>();
        //PageReference pdfPage = page.generatePdf;
        PageReference pdfPage = new PageReference('/apex/generatePdf?Industry='+ accIndustry);
        Blob pdfBlob = pdfPage.getContent();
        String downloadURL = EncodingUtil.base64Encode(pdfBlob);
        
        pageStrings.add(downloadURL);
        pageStrings.add(pdfPage.getUrl());
        
        return pageStrings;
    } 

}