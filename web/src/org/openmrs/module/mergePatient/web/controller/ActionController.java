package org.openmrs.module.mergePatient.web.controller;

import java.util.ArrayList;
import java.util.Calendar;
import java.util.Collection;
import java.util.Date;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.omg.CORBA.Request;
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
		Collection<PatientProgram> patientAPrograms = Context.getProgramWorkflowService().getPatientPrograms(patientA);
		Collection<PatientProgram> patientBPrograms = Context.getProgramWorkflowService().getCurrentPrograms(patientB,new Date());
		//Patient A
		model.put("patientAName", patientA.getPersonName());
		model.put("patientAId", patientA.getPatientId());
		
		Map<String, Object> dataMap;
		List<Object> dataList = new ArrayList<Object>();
		for (Encounter patientAEncounter : patientAEncounters) {
			dataMap = new HashMap<String, Object>();
			dataMap.put("id", patientAEncounter.getEncounterId());
			dataMap.put("name", patientAEncounter.getEncounterType().getName());
			dataMap.put("date", patientAEncounter.getDateCreated());
			dataList.add(dataMap);
		}
		model.put("patientAEncounter", dataList);
		
		dataList = new ArrayList<Object>();
		for (PatientIdentifier patientAIdentifier : patientAIndentifiers) {
			dataMap = new HashMap<String, Object>();
			dataMap.put("id", patientAIdentifier.getIdentifier());
			dataMap.put("name", patientAIdentifier.getIdentifierType().getName());
			dataMap.put("date", patientAIdentifier.getDateCreated());
			dataList.add(dataMap);
		}
		model.put("patientAIdentifier", dataList);
		
		dataList = new ArrayList<Object>();
		String patientAProgramjson="[";
		for (PatientProgram patientAProgram : patientAPrograms) {
			dataMap = new HashMap<String, Object>();
			dataMap.put("id", patientAProgram.getPatientProgramId());
			dataMap.put("name", patientAProgram.getProgram().getName());
			dataMap.put("date", patientAProgram.getDateCreated());
			dataList.add(dataMap);
			
			patientAProgramjson+="{\"id\": \""+patientAProgram.getPatientProgramId()+"\","
					+ "\"name\": \""+patientAProgram.getProgram().getName()+"\","
					+ "\"date\": \""+patientAProgram.getDateCreated()+"\"}, ";
			
		}
		patientAProgramjson+="{}]";
		
		model.put("patientAProgramjson", patientAProgramjson);
		
		model.put("patientAProgram", dataList);
		
		
		//Patient B
		model.put("patientBName", patientB.getPersonName());
		model.put("patientBId", patientB.getPatientId());
		
		dataList = new ArrayList<Object>();
		for (Encounter patientBEncounter : patientBEncounters) {
			dataMap = new HashMap<String, Object>();
			dataMap.put("id", patientBEncounter.getEncounterId());
			dataMap.put("name", patientBEncounter.getEncounterType().getName());
			dataMap.put("date", patientBEncounter.getDateCreated());
			dataList.add(dataMap);
		}
		model.put("patientBEncounter", dataList);
		
		dataList = new ArrayList<Object>();
		for (PatientIdentifier patientBIdentifier : patientBIndentifiers) {
			dataMap = new HashMap<String, Object>();
			dataMap.put("id", patientBIdentifier.getIdentifier());
			dataMap.put("name", patientBIdentifier.getIdentifierType().getName());
			dataMap.put("date", patientBIdentifier.getDateCreated());
			dataList.add(dataMap);
		}
		model.put("patientBIdentifier", dataList);
		
		dataList = new ArrayList<Object>();
		for (PatientProgram patientBProgram : patientBPrograms) {
			dataMap = new HashMap<String, Object>();
			dataMap.put("id", patientBProgram.getPatientProgramId());
			dataMap.put("name", patientBProgram.getProgram().getName());
			dataMap.put("date", patientBProgram.getDateCreated());
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
		int patientAId = Integer.parseInt(request.getParameter("patientA"));
		int patientBId = Integer.parseInt(request.getParameter("patientB"));
		Patient patientB = Context.getPatientService().getPatient(patientBId);
		Patient patientA = Context.getPatientService().getPatient(patientAId);
		List<Encounter> patientBEncounters = Context.getEncounterService().getEncountersByPatient(patientB);
		List<PatientIdentifier> patientBIdentifiers = patientB.getActiveIdentifiers();
		//Collection<PatientProgram> patientBPrograms = Context.getProgramWorkflowService().getPatientPrograms(patientB);
		List<Program> programs = Context.getProgramWorkflowService().getAllPrograms();
		ArrayList<String> prgs=new ArrayList<String>();
		for (Program program : programs) {
			String prgTemp = request.getParameter(String.valueOf(program.getProgramId()));
			if(prgTemp!=null && prgTemp!="")
				prgs.add(request.getParameter(String.valueOf(program.getProgramId())));
        }
	    String data=request.getParameter("programByName");
	    System.out.println("========data:"+data);
	    String data1=request.getParameter("programByName1");
	    System.out.println("========data:"+data1);
	    String data2=request.getParameter("programByName2");
	    System.out.println("========data:"+data2);
	    String data3=request.getParameter("programByName3");
	    System.out.println("========data:"+data3);
	   
	    List<Encounter> encounterMessage = MergeEncounter(request,patientBEncounters,patientA,patientB,prgs);
		//List<Object> programMessage = MergeProgram(request,patientBPrograms,patientA,patientB);
		List<Object> identifierMessage = MergeIdentifier(request,patientBIdentifiers,patientA,patientB);
		try
		{
			Context.getPatientService().voidPatient(patientB, "Duplication of patient Identifier(s) #" + patientA.getPatientId());	
		}
		catch(Exception ex)
		{
		logger.error(ex);
		}
		RedirectView model = new RedirectView("/openmrs/module/mergePatient/success.form");
		for (Encounter en : encounterMessage) {
			model.addStaticAttribute("en_"+en.getEncounterId(), en.getEncounterId());   
        }
		model.addStaticAttribute("pid", patientA.getPatientId());   
		model.addStaticAttribute("en", encounterMessage.size());   
        //model.addStaticAttribute("pr", programMessage.size());
		model.addStaticAttribute("id", identifierMessage.size());
		model.addStaticAttribute("pname", patientA.getPersonName().toString());   
		model.addStaticAttribute("identifier", patientA.getPatientIdentifier().getIdentifier()); 
		return new ModelAndView(model);
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

	private List<Encounter> MergeEncounter(HttpServletRequest request,List<Encounter> patientBEncounters,
		Patient patientA,Patient patientB,ArrayList<String> prgs){
		List<Encounter> merged=new ArrayList<Encounter>();
		for (Encounter encounter : patientBEncounters) {
			if (request.getParameter("en_" + encounter.getEncounterId()) != null) {
				Encounter newEncounter = new Encounter();
				newEncounter.setCreator(encounter.getCreator());
				newEncounter.setDateCreated(encounter.getDateCreated());
				newEncounter.setPatient(patientA);
				newEncounter.setProvider(encounter.getCreator());
				newEncounter.setEncounterType(encounter.getEncounterType());
				newEncounter.setLocation(encounter.getLocation());
				newEncounter.setEncounterDatetime(encounter.getEncounterDatetime());
				merged.add(mergeObs(encounter.getAllObs(),newEncounter,patientA, prgs,request));
				Context.getEncounterService().saveEncounter(newEncounter);
				Context.getEncounterService().voidEncounter(encounter, "Duplication of patient Id  #" + patientA.getPatientId());
			}
		}
	return merged;
	}
	
	private Encounter mergeObs(Set<Obs> oldObs,Encounter newEncounter, Patient patientA, ArrayList<String> prgs,HttpServletRequest request)
	{
		for (Obs obs : oldObs) {
            Set<Obs> obsList = traverse(obs,patientA, prgs,request);
            for (Obs o : obsList) {
	            newEncounter.addObs(o);
	        }
        }
		boolean found=false;
		for (Obs o : newEncounter.getAllObs()) {
	        if(o.getConcept().getConceptId()==576)
	        found=true;
        }
		if(found==false)
		{
			String data=request.getParameter("programByName");
		    String data1=request.getParameter("programByName1");
		    String data2=request.getParameter("programByName2");
		    String data3=request.getParameter("programByName3");
			PatientProgram program=null;
			if(data!=null && data!="")
				program=Context.getProgramWorkflowService().getPatientProgram(Integer.parseInt(data));
			else if(data1!=null && data1!="" && (newEncounter.getEncounterType().getName().equals("Specimen Collection") 
			|| newEncounter.getEncounterType().getName().equals("Transfer In") || newEncounter.getEncounterType().getName().equals("Transfer Out")))
			{	
				program=Context.getProgramWorkflowService().getPatientProgram(Integer.parseInt(data1));
			}
			else if(data2!=null && data2!="" &&  (newEncounter.getEncounterType().getName().equals("TB03") ||
			newEncounter.getEncounterType().getName().equals("Form89")))
			{
				program=Context.getProgramWorkflowService().getPatientProgram(Integer.parseInt(data2));
			}
			else if(data3!=null && data3!="" && !newEncounter.getEncounterType().getName().equals("Lab Result"))
			{
				program=Context.getProgramWorkflowService().getPatientProgram(Integer.parseInt(data3));
			}
			if(program!=null)
			{
				Obs o =new Obs();
				o.setDateCreated(new Date());
				o.setEncounter(newEncounter);
				o.setValueNumeric(program.getPatientProgramId().doubleValue());
				o.setConcept(Context.getConceptService().getConcept(576));
				o.setCreator(newEncounter.getPatient().getPersonCreator());
				newEncounter.addObs(o);
			}
		}   
        return newEncounter;
	}
	
	private Set<Obs> traverse(Obs obs, Patient patientA, ArrayList<String> prgs, HttpServletRequest request)
	{ 
	  Obs temp=new Obs();
	  Set<Obs> obsList=new HashSet<Obs>();
	  temp=temp.newInstance(obs);
	  if(temp.getConcept().getConceptId()==576)
      { 
		  Integer pr_id = temp.getValueNumeric().intValue();
		  PatientProgram patientProgramB = Context.getProgramWorkflowService().getPatientProgram(pr_id);
		  
		  if(prgs.size()>0)
		  {
			  for(int i=0;i<prgs.size();i++)
			  {
				  int pp=Integer.parseInt(prgs.get(i));
					  PatientProgram patientProgramA = Context.getProgramWorkflowService().getPatientProgram(pp); 
					  Program programA = patientProgramA.getProgram();
					  Program programB = patientProgramB.getProgram();
					  if(programB.getProgramId()==programA.getProgramId())
					  {
						  temp.setValueNumeric(patientProgramA.getPatientProgramId().doubleValue());
						  break;
					  }
			  }
		  }
		  else
		  {
			  Collection<PatientProgram> patientProgramA = Context.getProgramWorkflowService().getPatientPrograms(patientA);
			  Program programB = patientProgramB.getProgram();
			  for (PatientProgram patientProgram : patientProgramA) {
				  Program programA = patientProgram.getProgram();
				  if(programB.getProgramId()==programA.getProgramId())
				  {
					  temp.setValueNumeric(patientProgram.getPatientProgramId().doubleValue());
					  break;
				  }
			  }
		  }
      }
      obsList.add(temp);
	  
      if(obs.isObsGrouping() && obs.hasGroupMembers())
      {
        for(Obs o : obs.getGroupMembers()) {
       	 	traverse(o, patientA, prgs,request);
       	}
      }
		return obsList;
	}
}

