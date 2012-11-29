<%@ page language="java" contentType="application/json; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>

<%@ page import="java.io.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.net.*" %>
<%@ page import="javax.servlet.jsp.*" %>
<%@ page import="org.apache.commons.io.*" %>
<%@ page import="org.apache.commons.httpclient.HttpClient" %>
<%@ page import="org.apache.commons.httpclient.HttpStatus" %>
<%@ page import="java.io.BufferedReader" %>
<%@ page import="java.io.InputStreamReader" %>

<%
	String address = ""; 
	if (request.getParameter("addr") != null) address = request.getParameter("addr");
	
	String getResponse = "";
	if (address.length() > 0) {
		getResponse = callApi(address, request, response);
	}
	
	// Response is output to the page whos content type is application/json
	out.println(getResponse);
%>

<%!
// callApi - Calls a REST based API at the address passed in and returns the content of the response as a string
public String callApi(String address, HttpServletRequest request, HttpServletResponse response) 
{
	try 
	{
		//System.out.println(address);
		ByteArrayOutputStream output = new ByteArrayOutputStream();
		URL url = new URL(address);
		URLConnection urlConnection = url.openConnection();
    	urlConnection.setDoInput(true);
    	urlConnection.setDoOutput(true);
    	urlConnection.setRequestProperty("Accept-Charset","UTF-8");
		IOUtils.copy(urlConnection.getInputStream(), output);
		return output.toString();
	} 
	catch (IOException e) 
	{
		//System.out.println("Message: " + e.getMessage() + " ---- " + e.getStackTrace());
		return null;
	}
} // TESTED
%>