package com.team.project.service;

import com.team.project.entities.Book;
import com.team.project.entities.BuyRequestProduct;
import com.team.project.entities.Buyrequest;
import com.team.project.entities.User;


public interface BuyrequestService {
	public void addBuyrequest(Buyrequest buyrequest, User user, int couponcode);
	public void addBuyproduct(BuyRequestProduct buyProduct, Book book, int couponcode2);
}
