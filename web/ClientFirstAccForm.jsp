<%-- 
    Document   : ClientFirstAccForm
    Created on : Feb 8, 2019, 3:57:52 PM
    Author     : r.ganiyev
--%>

<%@page import="java.util.Properties"%>
<%@page import="ReadProperitesFile.ReadPropFile"%>
<%@page import="ExcelUtility.WorkExcel"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>DWH Reports</title>
    </head>
    <body bgcolor=#E0EBEA>
        <%
            response.setContentType("text/html; charset=UTF-8");
            response.setCharacterEncoding("UTF-8");
            request.setCharacterEncoding("UTF-8");
            if (request.getParameter("RepType") != null) {
                
                Object[] array = new Object[5];
                WorkExcel we = new WorkExcel();
                ReadPropFile rf = new ReadPropFile();
                Properties properties = null;    
                properties = rf.ReadConfigFile("StoredProcedureName.properties");
                
                String FileNamePath = null;
                String paramsValue = "";

                int RepType = Integer.parseInt(request.getParameter("RepType"));
                  String begDate = request.getParameter("TrDateB");
                  String endDate = request.getParameter("TrDateE");
                  String branchId = request.getParameter("Filial").equals("0") ? "" : "'" + request.getParameter("Filial") + "'";
                  String custTypeAll = request.getParameter("CustTypeAll");
                  StringBuilder custType= new StringBuilder("");
                  String username = request.getParameter("uname");
                  
                   if (custTypeAll==null && request.getParameterValues("CustType")!=null)
                   {
                           
                   
                      String[] cust_type= request.getParameterValues("CustType");
                      
                      for (String cust : cust_type) 
                      {
                        custType.append("'"+cust.trim()+"',");
                      }
                      
                      custTypeAll=custType.deleteCharAt(custType.length()-1).toString();
                   }
                   else
                   {
                     custTypeAll="";  
                   }
                  
                  
                     paramsValue = "dateinterval=to_date('"+begDate.trim()+"','dd.mm.yyyy') and to_date('"+endDate.trim()+"','dd.mm.yyyy')/"
                                   +"filial_code="+branchId.trim() + "/"
                                   +"customertyp="+custTypeAll.trim()+ "/";
                                  
                     
                     
                     array[0] = 85;          // page_id
                     array[1] = 1;          // query_status
                     array[2] = 1;         // cond_status
                     array[3] = paramsValue;
                     array[4] = username;
                  
                  
               
    switch (RepType) {
                    case 0: 
        %>
        <jsp:forward page="DisplayReportsData.jsp">    
            <jsp:param name="PageId" value="<%=array[0]%>"/> 
            <jsp:param name="QueryStatus" value="<%=array[1]%>"/>
            <jsp:param name="CondStatus" value="<%=array[2]%>"/>
            <jsp:param name="Params" value="<%=array[3]%>"/> 
            <jsp:param name="UserName" value="<%=array[4]%>"/>
        </jsp:forward>
        
         
        <%
                break;
                case 1:
                FileNamePath = we.ExportDataToExcel(array, properties.getProperty("ProcName"),0);

        %>
        <jsp:forward page="DownloadsFile">    
            <jsp:param name="fileNamePath" value="<%=FileNamePath%>"/> 
        </jsp:forward>                
        <%

                    break;

            }
        %>

        <%
            }
        %>
    </body>
</html>