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
public class EmailConfirmationUtil {
    
    public static void sendMail(String recepient, String name) throws MessagingException{
        System.out.println("Preparing to Send...");
        String senderAccount = "ttestuser1628@gmail.com";
        String senderAccountPW = "applebottomjeans";
        
        
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
        Message message = prepareMessage(session, senderAccount, recepient, name);
        
        Transport.send(message);
        System.out.println("Message Sent");
         
    }
    
    
    private static Message prepareMessage(Session session, String sA, String rec, String name) throws MessagingException{
        Map<String, String> mapInlineImages;
        
        Message msg = new MimeMessage(session);
        try {
            msg.setFrom(new InternetAddress(sA));
            InternetAddress[] toAddress = { new InternetAddress(rec) };
            msg.setRecipients(Message.RecipientType.TO, toAddress);
            msg.setSubject("Eduardo's Resort Customer Confirmation");
            msg.setSentDate(new Date());
            
            // creates multi-part (body, and embedded images)
            Multipart multipart = new MimeMultipart();
            
            // creates message part
            BodyPart messageBodyPart = new MimeBodyPart();
//            String htmlBody = "<img src=\"cid:image\">";
//            messageBodyPart.setContent(htmlBody, "text/html");
//            multipart.addBodyPart(messageBodyPart);

//            // creates image part
//            messageBodyPart = new MimeBodyPart();
//            DataSource fds = new FileDataSource("E:\\SE II\\Eduardos_Resort\\web\\image\\ER_logo_noBG.png");
//            messageBodyPart.setDataHandler(new DataHandler(fds));
//            messageBodyPart.setHeader("Content-ID", "<image>");
//             
//            // add image to the multipart
//            multipart.addBodyPart(messageBodyPart);
//            
            // add content
            messageBodyPart = new MimeBodyPart();
            String htmlBody2 = "<html> Hi " + name + ", <br><br>"
                    + "We would like inform you that your reservation has been sent! <br> <br>"
                    + "We're happy to hopefully see you once our handlers confirm your reservation. <br>"
                    + "Best Wishes, Eduardo's Resort "
                    + "</html>";
            messageBodyPart.setContent(htmlBody2, "text/html");
            multipart.addBodyPart(messageBodyPart);
            
            // put everything together
            msg.setContent(multipart);
            return msg;
        
        } catch (AddressException ex) {
            Logger.getLogger(EmailConfirmationUtil.class.getName()).log(Level.SEVERE, null, ex);
        }
        return null;        
    }
    
    
}
