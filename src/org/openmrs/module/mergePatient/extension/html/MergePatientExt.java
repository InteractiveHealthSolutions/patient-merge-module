package org.openmrs.module.mergePatient.extension.html;

import org.openmrs.module.web.extension.LinkExt;

public class MergePatientExt extends LinkExt {

	@Override
	public String getLabel() {
		return "MergePatient";
	}

	@Override
	public String getRequiredPrivilege() {
		//TODO check privileges
		return null;
	}

	@Override
	public String getUrl() {
		return "module/mergePatient/search.htm";
	}

}
