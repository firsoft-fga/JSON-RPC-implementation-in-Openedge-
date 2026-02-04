 /*------------------------------------------------------------------------
    File        : mq2oejrpc.p
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : firsoft
    Created     : Thu Sep 18 13:51:05 EET 2025
    Notes       : 
  ----------------------------------------------------------------------*/

USING Progress.Lang.*.

USING Progress.Json.ObjectModel.*.



BLOCK-LEVEL ON ERROR UNDO, THROW.


DEFINE INPUT PARAM  cjreq  AS CHAR NO-UNDO.
DEFINE OUTPUT PARAM cjresp AS LONGCHAR NO-UNDO.

DEFINE VARIABLE jsonRequest  AS JsonObject NO-UNDO.
DEFINE VARIABLE jsonResponse AS JsonObject NO-UNDO.
DEFINE VARIABLE myParser AS ObjectModelParser NO-UNDO. 

myParser = NEW ObjectModelParser(). 
jsonRequest = CAST(myParser:Parse(cjreq ),JsonObject)  .
IF NOT TYPE-OF(jsonRequest, JsonObject ) THEN 
     jsonRequest = ? .

RUN oe4jrpc.p(INPUT jsonRequest,OUTPUT jsonResponse).

IF jsonResponse NE ? THEN
   jsonResponse:Write( OUTPUT cjresp ) .
ELSE
   cjresp = ''  .

 CATCH jError AS Progress.Json.JsonError :
   cjresp='~{"jsonrpc": "2.0","error": ~{"code": -32700,"message": "Invalid JSON was received by the server."}}'.
   RETURN.
 END CATCH.  

FINALLY:
  delete object jsonRequest no-error.
  delete object jsonResponse no-error.
  delete object myParser no-error.
END FINALLY.
    
