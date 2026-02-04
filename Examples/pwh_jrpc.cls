 
 /*------------------------------------------------------------------------
    File        : pwh_jrpc.cls
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : firsoft
    Created     : Thu Sep 18 13:51:05 EET 2025
    Notes       : 
  ----------------------------------------------------------------------*/


USING Progress.Lang.*.

USING Progress.Json.ObjectModel.*.

USING OpenEdge.Web.WebResponseWriter.
USING OpenEdge.Net.HTTP.StatusCodeEnum.
USING OpenEdge.Web.WebHandler.

BLOCK-LEVEL ON ERROR UNDO, THROW.

CLASS pwh_jrpc INHERITS WebHandler: 

    METHOD OVERRIDE PROTECTED INTEGER HandleNotAllowedMethod( INPUT poRequest AS OpenEdge.Web.IWebRequest ):
        UNDO, THROW NEW Progress.Lang.AppError("METHOD NOT IMPLEMENTED").
    END METHOD.

    METHOD OVERRIDE PROTECTED INTEGER HandleNotImplemented( INPUT poRequest AS OpenEdge.Web.IWebRequest ):
        UNDO, THROW NEW Progress.Lang.AppError("METHOD NOT IMPLEMENTED").
    END METHOD.

     METHOD OVERRIDE PROTECTED INTEGER HandleGet( INPUT poRequest AS OpenEdge.Web.IWebRequest ):
         UNDO, THROW NEW Progress.Lang.AppError("METHOD NOT IMPLEMENTED").  
     END METHOD. 

      METHOD OVERRIDE PROTECTED INTEGER HandlePut( INPUT poRequest AS OpenEdge.Web.IWebRequest ):
        UNDO, THROW NEW Progress.Lang.AppError("METHOD NOT IMPLEMENTED").      
      END METHOD.
      
  
METHOD OVERRIDE PROTECTED INTEGER HandlePost( INPUT poRequest AS OpenEdge.Web.IWebRequest ):
    DEFINE VARIABLE oResponse   AS OpenEdge.Net.HTTP.IHttpResponse NO-UNDO.
    DEFINE VARIABLE oWriter     AS OpenEdge.Web.WebResponseWriter  NO-UNDO.
    DEFINE VARIABLE oBody       AS OpenEdge.Core.String            NO-UNDO.
    DEFINE VARIABLE jsonRequest  AS JsonObject                     NO-UNDO.
    DEFINE VARIABLE jsonResponce AS JsonObject                     NO-UNDO.
    DEFINE VARIABLE isJson      AS LOGICAL INITIAL FALSE           NO-UNDO.

 do ON ERROR UNDO, leave :
    isJson = TYPE-OF(poRequest:Entity, JsonObject ) .
 end.   

    IF isJson THEN do:
         jsonRequest = CAST(poRequest:Entity, JsonObject).
        run oe4jrpc.p(input jsonRequest,output jsonResponce).
        if jsonResponce = ? then
           return 0.
    end.    

     ASSIGN 
        oResponse            = NEW OpenEdge.Web.WebResponse()
        oResponse:StatusCode = INTEGER(StatusCodeEnum:OK).
        
    if isJson then 
    do: 
     
        assign 
           oResponse:Entity = jsonResponce
           oResponse:ContentType   = 'application/json':u .
    end.   
    else 
    do: 
       
        oBody = NEW OpenEdge.Core.String('~{"jsonrpc": "2.0","error": ~{"code": -32700,"message": "Invalid JSON was received by the server."}}').
        assign 
           oResponse:Entity = oBody 
           oResponse:ContentLength = oBody:Size 
           oResponse:ContentType   = 'application/text':u .
    end.         
 
    oWriter = NEW WebResponseWriter(oResponse).
    oWriter:Open().
    oWriter:Close().
 
  CATCH pwhError AS Progress.Lang.SysError :
       isJson = False .
  END CATCH.     
        
  FINALLY:
             if valid-object(jsonRequest)   then    
                delete object jsonRequest .
             if valid-object(jsonResponce)   then    
                delete object jsonResponce .      
 
             if valid-object(obody)   then    
                delete object obody .
             if valid-object(oResponse)   then           
                delete object oResponse .
             if valid-object(oWriter)   then    
                delete object oWriter .      

    END FINALLY.
  
 END METHOD.    
    
END CLASS.