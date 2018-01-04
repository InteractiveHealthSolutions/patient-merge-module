
package org.openmrs.module.mergePatient.extension.html;

import java.util.LinkedHashMap;
import java.util.Map;
import org.openmrs.api.context.Context;
import org.openmrs.util.OpenmrsClassLoader;

import org.openmrs.module.Extension;
import org.openmrs.module.web.extension.AdministrationSectionExt;

public class AdminList extends AdministrationSectionExt {


	public Extension.MEDIA_TYPE getMediaType() {
		return Extension.MEDIA_TYPE.html;
	}
	
	public String getTitle() {
		return "mergePatient.dashboardTitle";
	}

	public Map<String, String> getLinks() {
		
		Map<String, String> map = new LinkedHashMap<String, String>();
		Thread.currentThread().setContextClassLoader(OpenmrsClassLoader.getInstance());
		map.put("module/mergePatient/search.form", "mergePatient.title.homepage");
		return map;
		
	}
	
}
