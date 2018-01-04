package org.openmrs.module.mergePatient.extension.html;

import org.openmrs.module.Extension;

public class mergePatientGutterItem extends Extension {
 
    String url = "module/mergePatient/search.form";
    String label = "mergePatient.title";
    
    public String getLabel(){
        return this.label;
    }
    
    
    public String getUrl(){
        return this.url;
    }
    
    public Extension.MEDIA_TYPE getMediaType() {
        return Extension.MEDIA_TYPE.html;
    }
    
    public String getRequiredPrivilege() {
        return "View Merge Patient Functions";
    }

}
