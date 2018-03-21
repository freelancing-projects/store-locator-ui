package com.storelocatorui.springboot.controller;

import java.io.IOException;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.json.JSONException;
import org.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.storelocatorui.springboot.service.StoreLocatorService;

@Controller
public class StoreLocatorController {

	@Autowired
	StoreLocatorService storeLocatorService;

	@RequestMapping("/")
	public String index() {
		return "index";
	}

	@RequestMapping("/showAddress")
	public @ResponseBody String showAddress(HttpServletRequest request, HttpServletResponse res) throws IOException, JSONException {
		
		return storeLocatorService.showAddress(Double.parseDouble(request.getParameter("lat")),
				Double.parseDouble(request.getParameter("lng")), Integer.parseInt(request.getParameter("radius"))).toString();
	}

}
