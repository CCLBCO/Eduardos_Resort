/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package controller;
 
import java.io.IOException;
import java.util.Date;
import java.util.Map;
import java.util.Properties;
import java.util.Set;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.activation.DataHandler;
import javax.activation.DataSource;
import javax.activation.FileDataSource;
 
import javax.mail.Authenticator;
import javax.mail.BodyPart;
import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.Multipart;
import javax.mail.PasswordAuthentication;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.AddressException;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeBodyPart;
import javax.mail.internet.MimeMessage;
import javax.mail.internet.MimeMultipart;

/**
 *
 * @author Gil Cruzada
 */
public class EmailReservationHandlerUtil {
    
    public static void sendMail(String recepient, String msg) throws MessagingException{
        System.out.println("Preparing to Send...");
        String senderAccount = "ttestuser1628@gmail.com";
        String senderAccountPW = "ihrwpylodfnjzten";
        
        
        Properties properties = new Properties();
        properties.put("mail.smtp.auth", "true");
        properties.put("mail.smtp.starttls.enable", "true");
        properties.put("mail.smtp.host","smtp.gmail.com");
        properties.put("mail.smpt.port","25");
        properties.put("mail.smtp.ssl.enable", "true");
        
        
        Authenticator auth = new Authenticator() {
            public PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(senderAccount, senderAccountPW);
            }
        };
        
        Session session = Session.getInstance(properties, auth);
        session.setDebug(true);
        Message message = prepareMessage(session, senderAccount, recepient, msg);
        
        Transport.send(message);
        System.out.println("Message Sent");
         
    }
    
    
    private static Message prepareMessage(Session session, String sA, String rec, String content) throws MessagingException{
        Map<String, String> mapInlineImages;
        
        Message msg = new MimeMessage(session);
        try {
            msg.setFrom(new InternetAddress(sA));
            InternetAddress[] toAddress = { new InternetAddress(rec) };
            msg.setRecipients(Message.RecipientType.TO, toAddress);
            msg.setSubject("Eduardo's Handler Customer Reservation Notice");
            msg.setSentDate(new Date());
            
            // creates multi-part (body, and embedded images)
            Multipart multipart = new MimeMultipart();
            
            // creates message part
            BodyPart messageBodyPart;
    
            // add content
            messageBodyPart = new MimeBodyPart();
            String htmlBody2 = content;
            messageBodyPart.setContent(htmlBody2, "text/html");
            multipart.addBodyPart(messageBodyPart);
            
            // put everything together
            msg.setContent(multipart);
            return msg;
        
        } catch (AddressException ex) {
            Logger.getLogger(EmailReservationHandlerUtil.class.getName()).log(Level.SEVERE, null, ex);
        }
        return null;        
    }
    
    
}
