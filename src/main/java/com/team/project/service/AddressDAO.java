package com.team.project.service;

import java.util.ArrayList;

import com.team.project.entities.Address;

public interface AddressDAO {
	ArrayList<Address> selectUserAddress(String userid);
}
