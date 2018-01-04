package org.openmrs.module.mergePatient.web.controller;

import java.net.URLDecoder;
import java.net.URLEncoder;
import java.nio.charset.Charset;
import java.text.Collator;
import java.text.Format;
import java.text.SimpleDateFormat;
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

import sun.misc.BASE64Encoder;

/**
 * This controller backs the /web/module/basicmoduleForm.jsp page. This controller is tied to that
 * jsp page in the /metadata/moduleApplicationContext.xml file
 */

public class PatientListController extends SimpleFormController {
	
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
	
	public boolean areRussianStringsEqual(String s1, String s2) {
		boolean result = false;
		
		if(s1==null || s2==null)
			return false;
		
		if(s1.length()==0 || s2.length()==0)
			return false;
		
		java.text.Collator collator = java.text.Collator.getInstance();
		collator.setStrength(Collator.SECONDARY);
		
		int compResult = collator.compare(s1, s2);
		if(compResult==0)
			return true;
				
		return result;
	}
	@Override
	protected Map<String, Object> referenceData(HttpServletRequest request, Object obj, Errors err) throws Exception {
		
		
		Map<String, Object> model = new HashMap<String, Object>();
		Map<String, Object> data = new HashMap<String, Object>();
		ArrayList<Map<String, Object>> dataList = new ArrayList<Map<String, Object>>();
		String patientName=request.getParameter("patientName");
		String dateOfBirth=request.getParameter("DOB");
		String gender=request.getParameter("gender");
		String p=URLDecoder.decode(patientName,"UTF-8");
		List<Patient> patients=Context.getPatientService().getPatients(p);
		Format formatter = new SimpleDateFormat("yyyy-MM-dd");
		model.put("patientName", URLDecoder.decode(patientName,"UTF-8"));
		for (Patient patient : patients)
		{
			System.out.println(patient.getBirthdate());
				
			if(!gender.isEmpty() && dateOfBirth.isEmpty())
			{
				if(patient.getGender().contains(gender))
				{
					dataList=addData(data,patient,dataList);
				}
			}
			else if(!dateOfBirth.isEmpty() && gender.isEmpty())
			{
				String bod = formatter.format(patient.getBirthdate());
				
				if(bod.contains(dateOfBirth))
				{
					dataList=addData(data,patient,dataList);
				}
			}
			else if(!dateOfBirth.isEmpty() && !gender.isEmpty())
			{
				String bod = formatter.format(patient.getBirthdate());
				
				if(bod.contains(dateOfBirth) && patient.getGender().contains(gender))
				{
					dataList=addData(data,patient,dataList);
				}
			}
			else
			{
					dataList=addData(data,patient,dataList);
			}
			
		}
		model.put("patientList", dataList);
		return model;
	}
	
	private ArrayList<Map<String, Object>> addData(Map<String, Object> data,Patient patient,ArrayList<Map<String, Object>> dataList)
	{
		Format formatter = new SimpleDateFormat("yyyy-MM-dd");
		data=new HashMap<String, Object>();
		data.put("pid", patient.getPatientId());
		data.put("identifier", patient.getPatientIdentifier());
		data.put("name", patient.getPersonName());
		String bod = formatter.format(patient.getBirthdate());
		data.put("DOB", bod);
		data.put("gender", patient.getGender());
		dataList.add(data);
		return dataList;
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
		System.out.println("Patients: " + request.getParameter("primaryPatientId"));
		System.out.println("Patients: " + request.getParameter("duplicatePatientId"));
		
	}
	
	@Override
	protected ModelAndView processFormSubmission(HttpServletRequest request, HttpServletResponse response, Object object,
	                                BindException exceptions) throws Exception {
		
		String patientA=request.getParameter("primaryPatient");
		String patientB=request.getParameter("duplicatePatient");
		
		return new ModelAndView(new RedirectView("/openmrs/module/mergePatient/action.form?patientA=" + patientA +"&patientB=" + patientB ));
		}
}