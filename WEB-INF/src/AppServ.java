
import java.io.*;
import java.lang.*;
import java.util.*;
import java.net.*;
import javax.servlet.*;
import javax.servlet.http.*;

public class AppServ extends HttpServlet {
 
    public void init(ServletConfig config) throws ServletException {
        super.init(config);                  // always!

        String func_name = "AppServ:init";

        m_acurl = null;
        m_page_hit = 0;
        m_app_name = getServletContext().getServletContextName();
        if (m_app_name == null) {
            m_app_name = "application";
        }
    }

    public void destroy() {
    }

    public void doGet(HttpServletRequest req, HttpServletResponse res) 
                               throws ServletException, IOException {
        String func_name = "AppServ:doGet";

        m_page_hit++;
        m_session_id = req.getHeader("nuance-session-id");

        String url  = req.getRequestURL().toString();
        String path = req.getPathInfo(); 

        if (m_acurl == null) {
            String context = req.getContextPath();
            String acurl_str = url.substring(0, url.indexOf(context)) +
                               "/ManagerServlet/ManagerServlet";
            m_acurl = new URL(acurl_str);
        }

        /*
         * When a vxml is called through this servlet, it is sent to application
         * container where it checks for existence of the vxml, if vxml exists
         * then it is forwarded to that vxml through this servlet
         * dispatcher.forward() method, else if vxml doesn't exist, application
         * container throws HTTP 404 error. If HTTP 404 error is sent by
         * application container, web.xml redirects the application to this
         * servlet with a URL ending with error404, hence, if the URL ends with
         * error404, senAlarmOrLog method is called with 2nd parameter set to
         * "true", which sends an alarm to MStation through ManagerServlet.
         */

        // if vxml doesn't exist, alarm is sent to mstation.
        if(url.endsWith( "error404" ))
        {
            // Send an alarm indicating the http response code.i.e 404 NOT FOUND
            sendAlarmOrLog( func_name, "true", "true", m_app_name
                    + " urlerror " + url, 404 );
        }
        // if vxml exists request is forwarded to the vxml.
        else
        {
            sendAlarmOrLog( func_name, "false", "true", m_app_name
                    + " handling request " + url, 200 );

            RequestDispatcher dispatcher = req.getRequestDispatcher( path );
            dispatcher.forward( req, res );
        }
    }


    public void sendAlarmOrLog(String funcname, String alarm, String log,
                               String message, int nResponseCode) {

        try { 
            URLConnection connection = m_acurl.openConnection();
            connection.setDoOutput(true);
            OutputStreamWriter ostream = new
                               OutputStreamWriter(connection.getOutputStream());
            BufferedWriter out = new BufferedWriter(ostream);
            
            // Construct the query.
            StringBuilder sb = new StringBuilder();
            sb.append( "AppName=" );
            sb.append( m_app_name );
            sb.append( "&FuncName=" );
            sb.append( funcname );
            sb.append( "&Alarm=" );
            sb.append( alarm );
            sb.append( "&Log=" );
            sb.append( log );
            sb.append( "&SessionId=" );
            sb.append( m_session_id );
            sb.append( "&PageHit=" );
            sb.append( m_page_hit );
            sb.append( "&Message=" );
            sb.append( message );
            sb.append( "&ResponseCode=" );
            sb.append( nResponseCode );

            out.write(sb.toString());
            out.flush();
            out.close();

            BufferedReader in = new BufferedReader(
                      new InputStreamReader(connection.getInputStream()));

            String inputLine;
            while ((inputLine = in.readLine()) != null) {
            }
            in.close();
        }
        catch (MalformedURLException e) {
        }
        catch (IOException ee) {
        } 
    }

    URL     m_acurl;
    int     m_page_hit;
    String  m_app_name;
    String  m_session_id;
}

