package com.khs.example.endpoints;

import java.util.ArrayList;
import java.util.List;

import javax.annotation.security.RolesAllowed;

import com.khs.sherpa.annotation.Endpoint;
import com.khs.sherpa.annotation.Param;

@Endpoint(authenticated=true)
public class AuthenticatedService {
	
	static class Department {
		public int number;
		public String name;		
	}
		
	public List<Department> departments() {
		
		List<Department>  results = new ArrayList<Department>();
		
		Department dept = new Department();
		dept.number = 100;
		dept.name = "IT";
		results.add(dept);
		
		dept = new Department();
		dept.number = 200;
		dept.name="QA";
		results.add(dept);
		
		return results;
		
	}
	

	@RolesAllowed({"SHERPA_ADMIN"})
	public Department create(@Param(name="number") int number,@Param(name="name")String name) {	
		Department dept = new Department();
		dept.number = number;
		dept.name = name;		
		return dept;		
	}
	

}
