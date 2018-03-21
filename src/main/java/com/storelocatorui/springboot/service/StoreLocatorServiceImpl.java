package com.storelocatorui.springboot.service;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.List;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.io.Resource;
import org.springframework.core.io.ResourceLoader;
import org.springframework.stereotype.Service;

import com.google.gson.Gson;
import com.google.gson.internal.LinkedTreeMap;
import com.storelocatorui.springboot.dto.Location;

@Service

public class StoreLocatorServiceImpl implements StoreLocatorService {

	@Autowired

	ResourceLoader resourceLoader;

	public List<LinkedTreeMap> getStorsJson() throws IOException, JSONException {

		Resource resource = resourceLoader.getResource("classpath:stores.json");

		String json = new BufferedReader(new InputStreamReader(resource.getInputStream())).readLine();

		Gson googleJson = new Gson();

		ArrayList<LinkedTreeMap> javaArrayListFromGSON = googleJson.fromJson(json, ArrayList.class);

		return javaArrayListFromGSON;

	}

	private double calculateDistance(double fromLong, double fromLat,

			double toLong, double toLat) {

		double d2r = Math.PI / 180;

		double dLong = (toLong - fromLong) * d2r;

		double dLat = (toLat - fromLat) * d2r;

		double a = Math.pow(Math.sin(dLat / 2.0), 2) + Math.cos(fromLat * d2r)

				* Math.cos(toLat * d2r) * Math.pow(Math.sin(dLong / 2.0), 2);

		double c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));

		double d = 6367000 * c;

		return Math.round(d / 1000);

	}

	@Override

	public JSONObject showAddress(double lat, double lng, int radius) throws IOException, JSONException {

		JSONObject jsonObject = null;

		List<LinkedTreeMap> stores = getStorsJson();

		List<Location> locations = new ArrayList<Location>();

		for (LinkedTreeMap<String, String> store : stores) {

			double distance = calculateDistance(lat, lng, Double.parseDouble(store.get("latitude")),
					Double.parseDouble(store.get("longitude")));

			if (distance <= radius) {

				Location location = new Location();

				location.setAddress(store.get("addressName"));

				location.setDistance(distance);

				location.setLat(Double.parseDouble(store.get("latitude")));

				location.setLng(Double.parseDouble(store.get("longitude")));

				locations.add(location);

			}

		}

		// sort by distance

		Collections.sort(locations, new Comparator<Location>() {

			@Override

			public int compare(Location o1, Location o2) {

				Double d = o1.getDistance() - o2.getDistance();

				return d.intValue();

			}

		});

		String json = new Gson().toJson(locations);

		JSONArray array = new JSONArray(json);

		jsonObject = new JSONObject();

		jsonObject.put("locations", array);

		return jsonObject;

	}

}
