# JSON-RPC implementation in Openedge

Openedge json-rpc library for OE 12.8 .   
Version 0.66 .

Library entry point call:  oe4jrpc.p(oRequest,oResponce) .

oRequest is input param as JsonObject created from jsonrpc input string of the JSON-RPC protocol. 

oResponce is output param as JsonObject from which can be created jsonrpc output string of the JSON-RPC protocol.

'method' - can be as simple procedure name  or  as class method in format a.b.c  where c - method name a.b - class name .

Suported types :  'character', 'date', 'logical', 'integer', 'decimal', 'int64',
                         'datetime', 'datetimeTZ', 'table', 'dataset', 'JsonObject', 'JsonArray' .


Limitations:
 1. fields in input/input-output table/dataset can be only as json primitive types:
    numeric ('integer', 'decimal') , string ('character') or boolean  ('logical') .
    For output table/dataset can use any fields w/o limitation.

 2. in this version supprted only public and not constructor methods of classes .
    Class must have constructor w/o params.

 3. not supported protocol batch mode.

Example how use library:   
 pwh_jrpc.cls  in webhandler as json-rpc server in HTTP protocol    
 mq2oejrpc.p   in any message queue system like KAFKA,Sonic,RabbitMQ and so on.

Source codes are provided by agreement .

Please, send your comments, suggestions or offers by email : firsoffg@gmail.com 


