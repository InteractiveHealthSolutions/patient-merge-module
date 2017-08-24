package org.openmrs.module.mergePatient.web.controller;

import java.util.ArrayList;
import java.util.Calendar;
import java.util.Collection;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.openmrs.Concept;
import org.openmrs.Encounter;
import org.openmrs.EncounterType;
import org.openmrs.Location;
import org.openmrs.Obs;
import org.openmrs.Patient;
import org.openmrs.PatientIdentifier;
import org.openmrs.PatientIdentifierType;
import org.openmrs.PatientProgram;
import org.openmrs.Program;
import org.openmrs.User;
import org.openmrs.api.ConceptService;
import org.openmrs.api.EncounterService;
import org.openmrs.api.ObsService;
import org.openmrs.api.PatientService;
import org.openmrs.api.context.Context;
import org.openmrs.propertyeditor.ConceptEditor;
import org.openmrs.propertyeditor.LocationEditor;
import org.openmrs.propertyeditor.PatientEditor;
import org.openmrs.propertyeditor.UserEditor;
import org.openmrs.util.OpenmrsConstants;
import org.openmrs.util.OpenmrsUtil;
import org.springframework.beans.propertyeditors.CustomCollectionEditor;
import org.springframework.beans.propertyeditors.CustomDateEditor;
import org.springframework.util.StringUtils;
import org.springframework.validation.BindException;
import org.springframework.validation.Errors;
import org.springframework.validation.ValidationUtils;
import org.springframework.web.bind.ServletRequestDataBinder;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;
import org.springframework.web.servlet.view.RedirectView;

/**
 * This controller backs the /web/module/basicmoduleForm.jsp page. This controller is tied to that
 * jsp page in the /metadata/moduleApplicationContext.xml file
 */

public class ActionController extends SimpleFormController {
	
	/** Logger for this class and subclasses */
	protected final Log log = LogFactory.getLog(getClass());
	
	/**
	 * This class returns the form backing object. This can be a string, a boolean, or a normal java
	 * pojo. The type can be set in the /config/moduleApplicationContext.xml file or it can be just
	 * defined by the return type of this method
	 * 
	 * @see org.springframework.web.servlet.mvc.AbstractFormController#formBackingObject(javax.servlet.http.HttpServletRequest)
	 */
	@Override
	protected Object formBackingObject(HttpServletRequest request) throws Exception {
		
		return new Object();
	}
	
	/**
	 * Returns any extra data in a key-->value pair kind of way
	 * 
	 * @see org.springframework.web.servlet.mvc.SimpleFormController#referenceData(javax.servlet.http.HttpServletRequest,
	 *      java.lang.Object, org.springframework.validation.Errors)
	 */
	@Override
	@SuppressWarnings("deprecation")
	protected Map<String, Object> referenceData(HttpServletRequest request, Object obj, Errors err) throws Exception {
		
		Map<String, Object> model = new HashMap<String, Object>();
		
		int patientAId = Integer.parseInt(request.getParameter("patientA"));
		int patientBId = Integer.parseInt(request.getParameter("patientB"));
		
		//Patients
		Patient patientA = Context.getPatientService().getPatient(patientAId);
		Patient patientB = Context.getPatientService().getPatient(patientBId);
		//Encounters
		List<Encounter> patientAEncounters = Context.getEncounterService().getEncounters(patientA);
		List<Encounter> patientBEncounters = Context.getEncounterService().getEncounters(patientB);
		//Indentifiers
		List<PatientIdentifier> patientAIndentifiers = patientA.getActiveIdentifiers();
		List<PatientIdentifier> patientBIndentifiers = patientB.getActiveIdentifiers();
		//Programs
		Collection<PatientProgram> patientAPrograms = Context.getProgramWorkflowService().getCurrentPrograms(patientA,
		    new Date());
		Collection<PatientProgram> patientBPrograms = Context.getProgramWorkflowService().getCurrentPrograms(patientB,
		    new Date());
		//Patient A
		model.put("patientAName", patientA.getPersonName());
		
		Map<String, Object> dataMap;
		List<Object> dataList = new ArrayList<Object>();
		for (Encounter patientAEncounter : patientAEncounters) {
			dataMap = new HashMap<String, Object>();
			dataMap.put("id", patientAEncounter.getEncounterId());
			dataMap.put("name", patientAEncounter.getEncounterType().getName());
			dataList.add(dataMap);
		}
		model.put("patientAEncounter", dataList);
		
		dataList = new ArrayList<Object>();
		for (PatientIdentifier patientAIdentifier : patientAIndentifiers) {
			dataMap = new HashMap<String, Object>();
			dataMap.put("id", patientAIdentifier.getIdentifier());
			dataMap.put("name", patientAIdentifier.getIdentifierType().getName());
			dataList.add(dataMap);
		}
		model.put("patientAIdentifier", dataList);
		
		dataList = new ArrayList<Object>();
		for (PatientProgram patientAProgram : patientAPrograms) {
			dataMap = new HashMap<String, Object>();
			dataMap.put("id", patientAProgram.getPatientProgramId());
			dataMap.put("name", patientAProgram.getProgram().getName());
			dataList.add(dataMap);
		}
		model.put("patientAProgram", dataList);
		
		//Patient B
		model.put("patientBName", patientB.getPersonName());
		
		dataList = new ArrayList<Object>();
		for (Encounter patientBEncounter : patientBEncounters) {
			dataMap = new HashMap<String, Object>();
			dataMap.put("id", patientBEncounter.getEncounterId());
			dataMap.put("name", patientBEncounter.getEncounterType().getName());
			dataList.add(dataMap);
		}
		model.put("patientBEncounter", dataList);
		
		dataList = new ArrayList<Object>();
		for (PatientIdentifier patientBIdentifier : patientBIndentifiers) {
			dataMap = new HashMap<String, Object>();
			dataMap.put("id", patientBIdentifier.getIdentifier());
			dataMap.put("name", patientBIdentifier.getIdentifierType().getName());
			dataList.add(dataMap);
		}
		model.put("patientBIdentifier", dataList);
		
		dataList = new ArrayList<Object>();
		for (PatientProgram patientBProgram : patientBPrograms) {
			dataMap = new HashMap<String, Object>();
			dataMap.put("id", patientBProgram.getPatientProgramId());
			dataMap.put("name", patientBProgram.getProgram().getName());
			dataList.add(dataMap);
		}
		model.put("patientBProgram", dataList);
		
		return model;
	}
	
	/**
	 * @see org.springframework.web.servlet.mvc.BaseCommandController#initBinder(javax.servlet.http.HttpServletRequest,
	 *      org.springframework.web.bind.ServletRequestDataBinder)
	 */
	@Override
	protected void initBinder(HttpServletRequest request, ServletRequestDataBinder binder) throws Exception {
		super.initBinder(request, binder);
		
		binder.registerCustomEditor(User.class, new UserEditor());
		binder.registerCustomEditor(Location.class, new LocationEditor());
		binder.registerCustomEditor(Patient.class, new PatientEditor());
		binder.registerCustomEditor(java.util.Date.class, new CustomDateEditor(OpenmrsUtil.getDateFormat(), true));
	}
	
	@Override
	protected void onBind(HttpServletRequest request, Object obj, BindException errors) {
		
	}
	
	@Override
	protected ModelAndView processFormSubmission(HttpServletRequest request, HttpServletResponse response, Object object,
	                                             BindException exceptions) throws Exception {
		System.out.println(request.getParameterMap());
		int patientAId = Integer.parseInt(request.getParameter("patientA"));
		int patientBId = Integer.parseInt(request.getParameter("patientB"));
		
		Patient patientB = Context.getPatientService().getPatient(patientBId);
		Patient patientA = Context.getPatientService().getPatient(patientAId);
		
		List<Encounter> patientBEncounters = Context.getEncounterService().getEncountersByPatient(patientB);
		List<PatientIdentifier> patientBIdentifiers = patientB.getActiveIdentifiers();
		Collection<PatientProgram> patientBPrograms = Context.getProgramWorkflowService().getPatientPrograms(patientB);
		
		Map<String, Object> model = new HashMap<String, Object>();
		String message="";
		List<Object> encounterMessage = MergeEncounter(request,patientBEncounters,patientA,patientB);
		List<Object> programMessage = MergeProgram(request,patientBPrograms,patientA,patientB);
		List<Object> identifierMessage = MergeIdentifier(request,patientBIdentifiers,patientA,patientB);
		try
		{
			Context.getPatientService().voidPatient(patientB, "Duplication of patient Identifier(s) #" + patientA.getIdentifiers());	
		}
		catch(Exception ex)
		{
		logger.error(ex);
		}
		
		return new ModelAndView(new RedirectView("/openmrs/module/mergePatient/success.form?en="+encounterMessage.size()+"&pr="+programMessage.size()+"&id="+identifierMessage.size()));
		
	}
	
	
    private List<Object> MergeProgram(HttpServletRequest request, Collection<PatientProgram> patientBPrograms, Patient patientA,
                              Patient patientB) {
    	List<Object> merged=new ArrayList<Object>();
		for (PatientProgram patientProgram : patientBPrograms) {
			if (request.getParameter("pg_" + patientProgram.getPatientProgramId()) != null) {
				PatientProgram pg = new PatientProgram();
				pg.setCreator(patientProgram.getCreator());
				pg.setDateCreated(patientProgram.getDateCreated());
				pg.setProgram(patientProgram.getProgram());
				pg.setDateEnrolled(patientProgram.getDateEnrolled());
				pg.setPatient(patientA);
				Context.getProgramWorkflowService().voidPatientProgram(patientProgram, "Duplication of patient Identifier(s)  #" + patientA.getIdentifiers());
				Context.getProgramWorkflowService().savePatientProgram(pg);
				merged.add(pg.getProgram().getName());
				System.out.println(merged);
			}
		}
	return merged;
	    
    }

	private List<Object> MergeIdentifier(HttpServletRequest request, List<PatientIdentifier> patientBIdentifiers, Patient patientA,
                                 Patient patientB) {
    	List<Object> merged=new ArrayList<Object>();
		for (PatientIdentifier patientIdentifier : patientBIdentifiers) {
			if (request.getParameter("id_" + patientIdentifier.getIdentifier()) != null) {
				PatientIdentifier id = new PatientIdentifier();
				id.setPatient(patientA);
				id.setIdentifierType(patientIdentifier.getIdentifierType());
				id.setLocation(patientIdentifier.getLocation());
				id.setIdentifier(patientIdentifier.getIdentifier());
				patientIdentifier.setVoided(true);
				patientIdentifier.setVoidReason("Duplication of patient Identifier(s)  #" + patientA.getIdentifiers());
				try
				{
					Context.getPatientService().updatePatientIdentifier(patientIdentifier);
				}
				catch(Exception ex)
				{
					if(ex.toString().contains("nonvoided"))
					{
					Context.getPatientService().voidPatient(patientB, "Duplication of patient Identifier(s)  #" + patientA.getIdentifiers());	
					}
				}
				patientA.addIdentifier(id);
				Context.getPatientService().updatePatient(patientA);
				merged.add(id.getIdentifierType());
				System.out.println(merged);
			}
		}
	return merged;
	}

	private List<Object> MergeEncounter(HttpServletRequest request,List<Encounter> patientBEncounters,Patient patientA,Patient patientB){
		List<Object> merged=new ArrayList<Object>();
		for (Encounter encounter : patientBEncounters) {
			if (request.getParameter("en_" + encounter.getEncounterId()) != null) {
				Encounter en = new Encounter();
				en.setForm(encounter.getForm());
				en.setCreator(encounter.getCreator());
				en.setDateCreated(new Date());
				en.setPatient(patientA);
				en.setProvider(encounter.getCreator());
				en.setEncounterType(encounter.getEncounterType());
				en.setLocation(encounter.getLocation());
				en.setEncounterDatetime(new Date());
				Context.getEncounterService().voidEncounter(encounter, "Duplication of patient Identifier(s)  #" + patientA.getIdentifiers());
				Context.getEncounterService().saveEncounter(en);
				merged.add(en.getEncounterType());
				System.out.println(merged);
			}
		}
	return merged;
	}
}

