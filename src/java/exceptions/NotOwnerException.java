package exceptions;

public class NotOwnerException extends RuntimeException 
{
    public NotOwnerException()
    {
        super("You are not the Owner");
    }      
}