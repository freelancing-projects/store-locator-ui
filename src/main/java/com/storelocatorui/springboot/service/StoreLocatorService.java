package com.storelocatorui.springboot.service;


import java.io.IOException;
import java.util.List;

import org.json.JSONException;
import org.json.JSONObject;

import com.storelocatorui.springboot.pojo.Store;

public interface StoreLocatorService {

	JSONObject showAddress(double lat, double lng, int radius) throws IOException, JSONException;
}
