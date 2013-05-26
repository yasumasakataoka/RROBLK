

 /* Starting 01-hubspot-lib.js */





/*	EventCache Version 1.0
	Copyright 2005 Mark Wubben

	Provides a way for automagically removing events from nodes and thus preventing memory leakage.
	See <http://novemberborn.net/javascript/event-cache> for more information.
	
	This software is licensed under the CC-GNU LGPL <http://creativecommons.org/licenses/LGPL/2.1/>
*/

/*	Implement array.push for browsers which don't support it natively.
	Please remove this if it's already in other code */
if(Array.prototype.push == null){
	Array.prototype.push = function(){
		for(var i = 0; i < arguments.length; i++){
			this[this.length] = arguments[i];
		};
		return this.length;
	};
};

/*	Event Cache uses an anonymous function to create a hidden scope chain.
	This is to prevent scoping issues. */
var EventCache = function(){
	var listEvents = [];
	
	return {
		listEvents : listEvents,
	
		add : function(node, sEventName, fHandler, bCapture){
			listEvents.push(arguments);
		},
	
		flush : function(){
			var i, item;
			for(i = listEvents.length - 1; i >= 0; i = i - 1){
				item = listEvents[i];
				if (!item) {continue;}
				if(item[0].removeEventListener){
					item[0].removeEventListener(item[1], item[2], item[3]);
				};
				
				/* From this point on we need the event names to be prefixed with 'on" */
				if(item[1].substring(0, 2) != "on"){
					item[1] = "on" + item[1];
				};
				
				if(item[0].detachEvent){
					item[0].detachEvent(item[1], item[2]);
				};
				
				item[0][item[1]] = null;
			};
		}
	};
}();
AddEvent = function (node, sEventName, fHandler, bCapture) {
  var evtName;
  if (node.addEventListener) {
    node.addEventListener(sEventName, fHandler, bCapture);
    EventCache.add(node, sEventName, fHandler, bCapture);
  }
  if (node.attachEvent) {
   	  if(sEventName.substring(0, 2) != "on"){
					evtName = "on" + sEventName;
		  } else {
         evtName = sEventName;
      }
    node.attachEvent(evtName, fHandler);
    EventCache.add(node, sEventName, fHandler, bCapture);
    
  }

}
RemoveEvent = function (node, sEventName, fHandler)
{

  if (node.removeEventListener)
  {
    node.removeEventListener(sEventName, fHandler, false);
  } else {
   	  if(sEventName.substring(0, 2) != "on"){
					evtName = "on" + sEventName;
		  } else {
         evtName = sEventName;
      }  
     node.detachEvent(evtName, fHandler);
   
  }
}


///  End EventCache Code



// Global Functions

isIE=document.all;
isMZ= !document.all && document.getElementById;

get = function (theID) {
  return document.getElementById(theID);
}



/*
*
*  To make an ajax request:
*  1) Define a function to handle the server response.  The function should accept an assoc.
*  2) Create a query string of the form:  key=value&thiskey=thisvalue
*  3) call:  ajax_httpPost(url, queryString, handlerFunction);
*
*/




ajax_getAssocFromResponse = function (strResponse) {
    
  var colonPos = strResponse.indexOf(":");
  var headerName = strResponse.substring(0,colonPos);
  
  if (headerName == "header-length") {
    
    var semiColonPos = strResponse.indexOf(";");
    var contentLength = strResponse.substring(colonPos+1, semiColonPos);
    var startPos = semiColonPos + 1;
    var responseHeaderString = strResponse.substring(startPos, contentLength+startPos);
    var responseBody = strResponse.substring(startPos+contentLength);

    eval(responseHeaderString);
    var responseHeader = stringToBeEvaledAndTurnedIntoAnAssoc;
  } else {
    var responseHeader = strResponse;
  }
  return responseHeader;
}

function ajax_formData2QueryString(docForm) {

        var strSubmit       = '';
        var formElem;
        var strLastElemName = '';
        
        for (i = 0; i < docForm.elements.length; i++) {
                formElem = docForm.elements[i];
                switch (formElem.type) {
                        // Text, select, hidden, password, textarea elements
                        case 'text':
                        case 'select-one':
                        case 'hidden':
                        case 'password':
                        case 'textarea':
                                strSubmit += formElem.name + 
                                '=' + escape(formElem.value) + '&'
                        break;
                        }
         }
       return strSubmit;
}


//This function is public domain
function ajax_httpPost(strURL, strSubmit, strResultFunc) {
         
        var xmlHttpReq = false;
        
        // Mozilla/Safari
        
        if (window.XMLHttpRequest) {
                xmlHttpReq = new XMLHttpRequest();
                try  {
                  xmlHttpReq.overrideMimeType('text/xml');
               } catch(e) {
                  
               }
        }
        // IE
        else if (window.ActiveXObject) {
                xmlHttpReq = new ActiveXObject("Microsoft.XMLHTTP");
        }
        
        xmlHttpReq.open('POST', strURL, true);
        xmlHttpReq.setRequestHeader('Content-Type', 
		     'application/x-www-form-urlencoded');
        xmlHttpReq.onreadystatechange = function() {
          
          if (xmlHttpReq.readyState == 4) {
             
             strResponse = xmlHttpReq.responseText;

             switch (xmlHttpReq.status) {
                     // Page-not-found error
                     case 404:
                             alert('Error: Not Found. The requested URL ' + 
                                     strURL + ' could not be found.');
                             break;
                     // Display results in a full window for server-side errors
                     case 500:
                             handleErrFullPage(strResponse);
                             break;
                     default:
                             // Call JS alert for custom error or debug messages
                             if (strResponse.indexOf('tracebackHeader') > -1 || 
                                     strResponse.indexOf('Debug:') > -1) {
                                     handleErrFullPage(strResponse);
                             }
                             // Call the desired result function
                             else {
                                 
                                     if ((typeof(strResultFunc) == "string") && (strResultFunc != "ignore") ){
                                       
                                        strResultAssoc = ajax_getAssocFromResponse(strResponse);
                                        eval(strResultFunc + '(strResultAssoc);');
                                     } else {
                                        
                                        strResultAssoc = ajax_getAssocFromResponse(strResponse);
                                        
                                        strResultFunc(strResultAssoc);
                                     }
                                     
                                     
                             }
                             break;
             }
             
          }
                   
  
        }
        if (strResultFunc == "ignore") {
          if (!document.all) {
             xmlHttpReq.onreadystatechange = function () {}
          } else {
             xmlHttpReq.onreadystatechange = function () {}
          }
        } 
        xmlHttpReq.send(strSubmit);
}



//This function is public domain
function handleErrFullPage(strIn) {

        var errorWin;

        // Create new window and display error
        try {
                errorWin = window.open('', 'errorWin');
                errorWin.document.write(strIn);
        }
        // If pop-up gets blocked, inform user
        catch(e) {
                alert('An error occurred, but the error message cannot be' +
                        ' displayed because of your browser\'s pop-up blocker.\n' +
                        'Please allow pop-ups from this Web site.');
        }
}

function ShowDownTimeAlert(Message) {
   alert(Message);

}
GlobalReadOnlyMessage = "";

function BlankOutInputs()  {

   function inputClick () {
     if (GlobalReadOnlyMessage ) {
       alert(GlobalReadOnlyMessage); 
     } else { 

       alert("This web site is in read only mode while nightly updates are performed");
     }
   }

   var inputs = document.getElementsByTagName("input");
   for (var x = 0; x < inputs.length; x++) {
      var inp = inputs[x];
      if (inp.getAttribute("type") == "submit" || inp.getAttribute("type") == "image") {
        inp.disabled = true;
      } else {
         inp.style.backgroundColor = "#EEE";
         AddEvent(inp, "click", inputClick);
      }
      

     
   }
   
   var textareas = document.getElementsByTagName("textarea");
   for (var x = 0; x < textareas.length; x++) {
      var inp = textareas[x];
         inp.style.backgroundColor = "#EEE";
         AddEvent(inp, "click", inputClick);
      AddEvent(inp, "click", inputClick);
   }   
   
}







/* Starting user timezone cookie */
try
{
    if (document.cookie.match("hubspotutktzo") == null)
    {
        var visitortime = new Date();
        var TimeZoneOffset = (visitortime.getTimezoneOffset()/60)*(-1);
        document.cookie = "hubspotutktzo="+TimeZoneOffset+"; path=/";
    }
}
catch(e){}//ignore error
 /* Ending user timezone cookie */


 /* Ending 01-hubspot-lib.js */




 /* Starting 08-bb.js */

var BBEmailArticle = function(){
	var FormBody = null, BBContainer = null;
	var BlogID = null, BlogTitle = null, ToEmail = null, FromEmail = null, Message = null, ErrorMsg = null, SubmitBtn = null;
	
    return {
        init : function(){
			
        },
        
        EmailArticleClick : function(e, blogId, blogTitle){
			var a = null;
			BlogID = blogId;
			BlogTitle = blogTitle;
			document.getElementById('emart-success').style.display = "none";
			document.getElementById('emart-fail').style.display = "none";
			document.getElementById("emart-form").style.display = "block";
			ToEmail = document.getElementById("emart-to");
			FromEmail = document.getElementById("emart-from");
			Message = document.getElementById("emart-msg");
			ErrorMsg = document.getElementById("emart-error");
			document.getElementById("emart-blog-title").innerHTML = BlogTitle;
			setTimeout("document.getElementById('emart-to').focus()", 100);
			
        },
        
        Cancel : function(){
			BlogID = null;
			FormBody.hide(true);
        },
        
        Submit : function(){
			var ErrorText = null;
			if (BlogID == null)
				ErrorText = 'No article was selected';
			else if (ToEmail.value.match(/\w+([-+.]\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*/) == null)
				ErrorText = 'Incorrect Email To format';
				
			ErrorMsg.innerHTML = '';
			if (ErrorText != null) {
				ErrorMsg.innerHTML = ErrorText;
			} else {            
				var success = function(o){
					ToEmail.value = '';
					FromEmail.value = '';
					Message.value = ''
					BlogID = null;
					document.getElementById("emart-form").style.display = "none";
					if (o == 'true') {
					   document.getElementById('emart-success').style.display = "block";
					} else {
					   document.getElementById('emart-fail').style.display = "block";
					}
				}
				var PostData = '&Action=EmailArticleTo&BlogID=' + encodeURIComponent(BlogID) + '&EmailTo=' + encodeURIComponent(ToEmail.value) + '&EmailFrom=' + encodeURIComponent(FromEmail.value) + '&Message=' + encodeURIComponent(Message.value);
				ajax_httpPost( window['CBHUrl'], PostData, success)
			}
        }
	};
}();
AddEvent(window, 'load', BBEmailArticle.init);
//YAHOO.util.Event.on(window, 'load', BBEmailArticle.init, BBEmailArticle, true);

 /* Ending 08-bb.js */




 /* Starting 09-mail-subscribe.js */

var MailSubscribe = function () {


   return {
      MailSubscribeClick : function (ModuleId, TabId)   {
         var email = get("IngeniMailSubscribeEmailInput_"+ModuleId).value;
         var url = "/Default.aspx?app=MailSubscribe&mid="+ModuleId+
                   "&tabid="+TabId;
         var data = "&AjaxModuleId="+ModuleId+"&SimpleAjaxAddEmail=true&SubscribeToBlogEmail="+encodeURIComponent(email);
         
         
         var callbackFunc = function (strResponse) {
            get("IngeniMailSubscribeContainer_"+ModuleId).innerHTML = strResponse;
         }
         
         ajax_httpPost(url, data, callbackFunc);
         
         
         get("IngeniMailSubscribeContainer_"+ModuleId).value = "Saving ...";
         
      }
   
   }

}();


 /* Ending 09-mail-subscribe.js */


var adjustSelectDropDowns = function() {
    if (!jQuery.browser.msie || jQuery.browser.version >= 9) {
        return;
    } 
   jQuery('select.wide')
    .bind('focus mouseover', function() { jQuery(this).addClass('expand').removeClass('clicked'); })
    .bind('click', function() { jQuery(this).toggleClass('clicked'); })
    .bind('mouseout', function() { if (!jQuery(this).hasClass('clicked')) { jQuery(this).removeClass('expand'); }})
    .bind('blur', function() { jQuery(this).removeClass('expand clicked'); });

}

AddEvent(window, 'load', adjustSelectDropDowns);