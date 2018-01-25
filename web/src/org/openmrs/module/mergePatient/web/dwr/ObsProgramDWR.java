package org.openmrs.module.mergePatient.web.dwr;


import java.util.Date;
import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Collection;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Set;
import java.util.Vector;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.openmrs.Encounter;
import org.openmrs.Obs;
import org.openmrs.Patient;
import org.openmrs.PatientProgram;
import org.openmrs.Program;
import org.openmrs.api.context.Context;

public class ObsProgramDWR {
    protected final Log log = LogFactory.getLog(getClass());
    
    public Collection getProgramByEncounter(int encounterId) {
        
        Collection<Object> LocationList = new Vector<Object>();

        Integer userId = -1;
        if (Context.isAuthenticated())
            userId = Context.getAuthenticatedUser().getUserId();
        Encounter encounter =Context.getEncounterService().getEncounter(encounterId);
        Set<Obs> obsList = Context.getObsService().getObservations(encounter);
        for (Obs obs : obsList) {
        	if(obs.getConcept().getConceptId()==576)
            {
          	  Integer pr_id = obs.getValueNumeric().intValue();
          	  PatientProgram patientProgram = Context.getProgramWorkflowService().getPatientProgram(pr_id);
          	  Program program = patientProgram.getProgram();
          	  LocationList = new Vector<Object>(1);
          	  LocationList.add(program);
          	  return LocationList;
          	}    
        }
        
        return null;
    }
    
    public Collection getProgram(int programId) {
        
     Collection<Object> LocationList = new Vector<Object>();
     Integer userId = -1;
     if (Context.isAuthenticated())
         userId = Context.getAuthenticatedUser().getUserId();
     Program program =Context.getProgramWorkflowService().getProgram(programId);
     LocationList = new Vector<Object>(1);
  	 LocationList.add(program);
  	 return LocationList;
    }
    
    public Collection getAllPrograms() {
        
        Integer userId = -1;
        if (Context.isAuthenticated())
            userId = Context.getAuthenticatedUser().getUserId();
        List<Program> programList = Context.getProgramWorkflowService().getAllPrograms();
         return programList;
       }
    
    public Collection getProgramByPatient(int patientId) {
        
        Integer userId = -1;
        if (Context.isAuthenticated())
            userId = Context.getAuthenticatedUser().getUserId();
        Patient patient=Context.getPatientService().getPatient(patientId);
        Collection<PatientProgram> patientPrograms = Context.getProgramWorkflowService().getCurrentPrograms(patient,new Date());
        System.out.println("hello here: "+patientPrograms);
        return patientPrograms;
    }
}
