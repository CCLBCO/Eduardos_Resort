/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package model;

import java.sql.Date;
import java.sql.Timestamp;

/**
 *
 * @author admin
 */
public class BookingRecord {
    // 13 properties
    private int booking_id;
    private Timestamp date_booked;
    private String name;
    private String email;
    private String phone_number;
    private String country;
    private String room_type;
    private Date start_booking;
    private Date end_booking;
    private int number_of_days;
    private double cost;
    private String booking_code;
    private String status_type;
    private String last_edited_by;
    private Timestamp last_edited_time;
    
    
    //constructors
    public BookingRecord(){}
    
    //setter constructor
    public BookingRecord(
        int booking_id,
        Timestamp date_booked,
        String name,
        String email,
        String phone_number,
        String country,
        String room_type,
        Date start_booking,
        Date end_booking,
        int number_of_days,
        double cost,
        String booking_code,
        String status_type,
        String last_edited_by,
        Timestamp last_edited_time)
    {
        this.booking_id = booking_id;
        this.date_booked = date_booked;
        this.name = name;
        this.email = email;
        this.phone_number = phone_number;
        this.country = country;
        this.room_type = room_type;
        this.start_booking = start_booking;
        this.end_booking = end_booking;
        this.number_of_days = number_of_days;
        this.cost = cost;
        this.booking_code = booking_code;
        this.status_type = status_type;
        this.last_edited_by = last_edited_by;
        this.last_edited_time = last_edited_time;
    }

    

    //setters
    public void setCost(double cost){
        this.cost = cost;  
    }
    public void setStatus(String status_type){
        this.status_type = status_type; 
    }
    
    
    //getters
    public int getBookingId(){
        return booking_id;   
    }
    public Timestamp getDateBooked(){
        return date_booked;
    }
    public String getName(){
        return name;
    }
    public String getEmail(){
        return email; 
    }
    public String getPhoneNumber(){
        return phone_number;
    }
    public String getCountry(){
        return country;
    }
    public String getRoomType(){
        return room_type; 
    }
    public Date getStartBookingDate(){
        return start_booking;
    }
    public Date getEndBookingDate(){
        return end_booking;
    }
    public int getDays(){
        return number_of_days;
    }
    public double getCost(){
        int days = getDays();
        switch(getRoomType()){
            case "deluxe": cost = days * 2500;
                            break;
            case "family": cost = days * 3500;
                            break;
        }
        return cost;
    }
    public String getBookingCode(){
        return booking_code;
    }
    public String getStatus(){
        return status_type;
    }
    public String getLastEditedBy(){
        return last_edited_by;
    }
    public Timestamp getLastEditedTime(){
        return last_edited_time;
    }
}
