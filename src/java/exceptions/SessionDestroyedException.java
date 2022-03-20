package exceptions;

public class SessionDestroyedException extends RuntimeException 
{
    public SessionDestroyedException()
    {
        super("Session Destroyed");
    }      
}